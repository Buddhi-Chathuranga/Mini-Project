-----------------------------------------------------------------------------
--
--  Logical unit: MessageBody
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ------------------------------------------------------------------------------
--  191203  CHAULK  Validate_Blob_To_Clob() to ensure that the blob is not null when converting 
--------------------------------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE New (
   newrec_ IN OUT NOCOPY fndcn_message_body_tab%ROWTYPE )
IS
BEGIN
   New___(newrec_);
END New;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Remove_Address_Body__ (
   application_message_id_ IN NUMBER,
   address_seq_no_         IN NUMBER)
IS
   CURSOR get IS
   SELECT application_message_id, seq_no, ROWID, rowversion
     FROM fndcn_message_body_tab
    WHERE application_message_id = application_message_id_
      AND address_seq_no = address_seq_no_;
   
   found_ BOOLEAN;
   objid_ VARCHAR2(20);
   rec_   fndcn_message_body_tab%ROWTYPE;
BEGIN
   OPEN get;
   FETCH get INTO rec_.application_message_id, rec_.seq_no, objid_, rec_.rowversion;
   found_ := get%FOUND;
   CLOSE get;
   IF found_ THEN
      Check_Delete___(rec_);
      Delete___(objid_, rec_);
   END IF;
END Remove_Address_Body__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION Validate_Blob_To_Clob(
   blob_ IN BLOB) RETURN CLOB
IS
   clob_ CLOB;
BEGIN 
   IF(DBMS_LOB.GETLENGTH(blob_) <> 0) THEN 
      clob_ := Utility_SYS.Blob_To_Clob(blob_);
   ELSE
      clob_ := '';
   END IF;
   RETURN clob_;
END Validate_Blob_To_Clob;

FUNCTION Validate_Inbound_Outbound(
   application_message_id_ IN NUMBER,
   seq_no_                 IN NUMBER) RETURN CLOB
IS 
   temp_in_bound_ BLOB; 
   temp_out_bound_ CLOB; 
   in_bound_ CLOB; 
   
   CURSOR check_in_bound IS
      SELECT t.message_value
      FROM message_body t, 
           application_message a
      WHERE t.application_message_id = a.application_message_id
      AND t.seq_no = seq_no_
      AND t.application_message_id = application_message_id_;
   
   CURSOR check_out_bound IS
      SELECT t.message_text
      FROM message_body t, 
           application_message a
      WHERE t.application_message_id = a.application_message_id 
      AND t.reply = 0
      AND t.seq_no = seq_no_
      AND t.application_message_id = application_message_id_;
   
   CURSOR get_details IS 
      SELECT a.inbound, a.message_type
      FROM application_message a
      WHERE  a.application_message_id = application_message_id_;
   
   temp_det_ get_details%ROWTYPE;
BEGIN
   OPEN get_details;
   FETCH get_details INTO temp_det_;
   CLOSE get_details;
   
   IF((temp_det_.message_type = 'REPORTING' AND temp_det_.inbound = 0) OR temp_det_.inbound = 1)THEN 
      OPEN check_in_bound;
      FETCH check_in_bound INTO temp_in_bound_;
      CLOSE check_in_bound; 
      in_bound_ := Validate_Blob_To_Clob(temp_in_bound_);
      RETURN in_bound_;
   ELSE 
      OPEN check_out_bound;
      FETCH check_out_bound INTO temp_out_bound_;
      CLOSE check_out_bound; 
      RETURN temp_out_bound_;
   END IF;
END Validate_Inbound_Outbound;

FUNCTION Get_File_Name(
   application_message_id_ IN NUMBER,
   seq_no_                 IN NUMBER) RETURN VARCHAR2
IS
   CURSOR get_details IS
      SELECT t.name, t.body_type_db, t.reply
      FROM MESSAGE_BODY t
      WHERE t.application_message_id = application_message_id_ 
      AND t.seq_no = seq_no_
      AND t.reply = 0;
   
   CURSOR get_details_output IS
      SELECT t.name, t.body_type_db, t.reply
      FROM MESSAGE_BODY t
      WHERE t.application_message_id = application_message_id_ 
      AND t.seq_no = seq_no_
      AND t.reply = 1;
   
   temp_holder_ get_details%ROWTYPE;
   temp_holder_output_ get_details_output%ROWTYPE;
   name_ VARCHAR2(32000);
BEGIN 
   OPEN get_details;
   FETCH get_details INTO temp_holder_;
   CLOSE get_details;
   
   OPEN get_details_output;
   FETCH get_details_output INTO temp_holder_output_;
   CLOSE get_details_output;
   
   IF(temp_holder_.reply = 0)THEN 
      IF(temp_holder_.name IS NULL AND temp_holder_.body_type_db = 'XML')THEN 
         name_ := 'MESSAGE_REQUESTS' ||'.xml';
      ELSIF (temp_holder_.name IS NULL AND temp_holder_.body_type_db = 'JSON')THEN 
         name_ := 'MESSAGE_REQUESTS' ||'.json';
      ELSIF(temp_holder_.name IS NOT NULL AND (temp_holder_.body_type_db = 'XML' OR temp_holder_.body_type_db = 'JSON'))THEN 
         name_ := temp_holder_.name;
      ELSIF(temp_holder_.name IS NOT NULL AND temp_holder_.body_type_db = 'PDF')THEN 
         name_ := temp_holder_.name;
      ELSIF(temp_holder_.name IS NULL AND temp_holder_.body_type_db = 'Text')THEN 
         name_ := 'MESSAGE_REQUEST' ||'.txt';
      ELSIF(temp_holder_.name IS NOT NULL AND temp_holder_.body_type_db = 'Text')THEN 
         name_ := temp_holder_.name;
      ELSIF(temp_holder_.name IS NOT NULL AND temp_holder_.body_type_db = 'Binary')THEN 
         name_ := temp_holder_.name;
      END IF;
   ELSIF(temp_holder_output_.reply = 1)THEN
      IF(temp_holder_output_.name IS NULL AND temp_holder_output_.body_type_db = 'XML')THEN 
         name_ := 'MESSAGE_RESPONSE' ||'.xml';
      ELSIF(temp_holder_output_.name IS NULL AND temp_holder_output_.body_type_db = 'JSON')THEN 
         name_ := 'MESSAGE_RESPONSE' ||'.json';
      ELSIF(temp_holder_output_.name IS NOT NULL AND temp_holder_output_.body_type_db = 'PDF')THEN 
         name_ := temp_holder_.name;
      ELSIF(temp_holder_output_.name IS NULL AND temp_holder_output_.body_type_db = 'Text')THEN 
         name_ := 'MESSAGE_RESPONSE' ||'.txt';
      END IF;
   END IF;
   RETURN name_;
END Get_File_Name;

FUNCTION Get_Pdf_Files(
   application_message_id_ IN NUMBER,
   seq_no_                 IN NUMBER) RETURN BLOB
IS
   CURSOR get_details IS 
      SELECT a.inbound, a.message_type, t.body_type_db, t.message_value
      FROM message_body t, 
           application_message a
      WHERE  t.application_message_id = a.application_message_id
      AND t.seq_no = seq_no_
      AND a.application_message_id = application_message_id_;
   
   temp_var_ get_details%ROWTYPE;
BEGIN
   OPEN get_details;
   FETCH get_details INTO temp_var_;
   CLOSE get_details;
   
   IF((temp_var_.message_type = 'REPORTING' AND temp_var_.inbound = 0 AND temp_var_.body_type_db = 'PDF') OR (temp_var_.inbound = 1 AND temp_var_.body_type_db = 'PDF'))THEN 
      RETURN temp_var_.message_value;
   END IF;
END Get_Pdf_Files;

FUNCTION Get_Binary_Files(
   application_message_id_ IN NUMBER,
   seq_no_                 IN NUMBER) RETURN BLOB
IS
   CURSOR get_details IS 
      SELECT a.inbound, a.message_type, t.body_type_db, t.message_value
      FROM message_body t, 
           application_message a
      WHERE  t.application_message_id = a.application_message_id
      AND t.seq_no = seq_no_
      AND a.application_message_id = application_message_id_;
   
   temp_var_ get_details%ROWTYPE;
BEGIN
   OPEN get_details;
   FETCH get_details INTO temp_var_;
   CLOSE get_details;
   
   IF(temp_var_.inbound = 1 AND temp_var_.body_type_db = 'Binary')THEN 
      RETURN temp_var_.message_value;
   END IF;
END Get_Binary_Files;
