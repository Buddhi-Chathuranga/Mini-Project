SET SERVEROUT ON

DECLARE

   PROCEDURE Execute___ (sql_ IN VARCHAR2) IS
   BEGIN
      EXECUTE IMMEDIATE sql_;
   EXCEPTION
      WHEN others THEN
        dbms_output.put_line ('Error in SQL: ' || sqlerrm);
   END Execute___;


   FUNCTION Table_Exist___ (table_name_ IN VARCHAR2) RETURN BOOLEAN IS
      count_ NUMBER;
   BEGIN
      SELECT count(*) INTO count_
        FROM user_tables
        WHERE table_name = UPPER (table_name_);
      IF count_ > 0 THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;
   END Table_Exist___;


   FUNCTION Index_Exist___ (index_name_ IN VARCHAR2) RETURN BOOLEAN IS
      count_ NUMBER;
   BEGIN
      SELECT count(*) INTO count_
        FROM user_indexes
        WHERE index_name = UPPER (index_name_);
      IF count_ > 0 THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;
   END Index_Exist___;


   PROCEDURE Create_Tables__ IS
   BEGIN

      IF NOT Table_Exist___ ('fs_mig_log_tab') THEN
         Execute___ ('CREATE TABLE fs_mig_log_tab (lu_name           VARCHAR2(100)  NOT NULL,
                                                    key_ref           VARCHAR2(2000) NOT NULL,
                                                    log_timestamp     TIMESTAMP      NOT NULL,
                                                    info              VARCHAR2(4000) NOT NULL)');
      END IF;

      IF NOT Table_Exist___ ('fs_mig_status_tab') THEN
           Execute___ ('CREATE TABLE fs_mig_status_tab (lu_name           VARCHAR2(100)  NOT NULL,
                                                         key_ref           VARCHAR2(2000) NOT NULL,
                                                         object_rowversion DATE           NOT NULL,
                                                         content_length    NUMBER         NULL,
                                                         hash              VARCHAR2(2000) NULL,
                                                         status            VARCHAR2(20)   NOT NULL,
                                                         status_date       TIMESTAMP      NOT NULL)');
      END IF;

      IF NOT Index_Exist___ ('fs_mig_log_ix1') THEN
         Execute___ ('CREATE INDEX fs_mig_log_ix1 ON fs_mig_log_tab (lu_name, key_ref)');
      END IF;

      IF NOT Index_Exist___ ('fs_mig_status_ix1') THEN
         Execute___ ('CREATE INDEX fs_mig_status_ix1 ON fs_mig_status_tab (lu_name, key_ref, status)');
      END IF;


   END Create_Tables__;

   PROCEDURE Drop_Tables__ IS
   BEGIN
      Execute___ ('DROP TABLE fs_mig_log_tab');
      Execute___ ('DROP TABLE fs_mig_status_tab');
      Execute___ ('DROP INDEX fs_mig_log_ix1');
      Execute___ ('DROP INDEX fs_mig_status_ix1');
   END Drop_Tables__;

BEGIN
  --Drop_Tables__;
   Create_Tables__;
END;
/



-- ######################## HEADER #############################
-- ######################## HEADER #############################
-- ######################## HEADER #############################
-- ######################## HEADER #############################
-- ######################## HEADER #############################
-- ######################## HEADER #############################



CREATE OR REPLACE PACKAGE Fs_Mig_Tool_API IS

FUNCTION Media_Hash___ (
 item_id_ IN NUMBER) RETURN VARCHAR2;

PROCEDURE Log_Document_Info__
  (doc_class_ IN VARCHAR2,
   doc_no_    IN VARCHAR2,
   doc_sheet_ IN VARCHAR2,
   doc_rev_   IN VARCHAR2,
   doc_type_  IN VARCHAR2,
   file_no_   IN NUMBER,
   info_      IN VARCHAR2);

PROCEDURE Log_Media_Info__
  (item_id_   IN NUMBER,
   info_      IN VARCHAR2);

PROCEDURE Set_Document_Transfer_Status__
  (doc_class_ IN VARCHAR2,
   doc_no_    IN VARCHAR2,
   doc_sheet_ IN VARCHAR2,
   doc_rev_   IN VARCHAR2,
   doc_type_  IN VARCHAR2,
   file_no_   IN NUMBER,
   status_    IN VARCHAR2);

PROCEDURE Set_Media_Transfer_Status__
  (item_id_   IN NUMBER,
   status_    IN VARCHAR2);

FUNCTION Get_Document_File_And_Size__
  (size_      OUT NUMBER,
   doc_class_ IN VARCHAR2,
   doc_no_    IN VARCHAR2,
   doc_sheet_ IN VARCHAR2,
   doc_rev_   IN VARCHAR2,
   doc_type_  IN VARCHAR2,
   file_no_   IN NUMBER) RETURN BLOB;

FUNCTION Get_Media_File_And_Size__
  (size_      OUT NUMBER,
   item_id_   IN NUMBER) RETURN BLOB;

FUNCTION Doc_Allowed_For_Transfer__
  (reason_    OUT VARCHAR2,
   doc_class_ IN  VARCHAR2,
   doc_no_    IN  VARCHAR2,
   doc_sheet_ IN  VARCHAR2,
   doc_rev_   IN  VARCHAR2,
   doc_type_  IN  VARCHAR2,
   file_no_   IN  NUMBER) RETURN VARCHAR2;

FUNCTION Media_Allowed_For_Transfer__
   (reason_   OUT VARCHAR2,
   item_id_   IN  NUMBER) RETURN VARCHAR2;

END Fs_Mig_Tool_API;
/



-- ######################## BODY #############################
-- ######################## BODY #############################
-- ######################## BODY #############################
-- ######################## BODY #############################
-- ######################## BODY #############################



CREATE OR REPLACE PACKAGE BODY Fs_Mig_Tool_API IS

TYPE edm_file_keys IS RECORD (doc_class VARCHAR2(12),
                              doc_no    VARCHAR2(200),
                              doc_sheet VARCHAR2(10),
                              doc_rev   VARCHAR2(10),
                              doc_type  VARCHAR2(20),
                              file_no   NUMBER);

-- IMPLEMENTATION METHODS
-- IMPLEMENTATION METHODS
-- IMPLEMENTATION METHODS


FUNCTION Edm_File_Keys___
  (doc_class_ IN VARCHAR2,
   doc_no_    IN VARCHAR2,
   doc_sheet_ IN VARCHAR2,
   doc_rev_   IN VARCHAR2,
   doc_type_  IN VARCHAR2,
   file_no_   IN NUMBER) RETURN edm_file_keys IS
   rec_ edm_file_keys;
BEGIN
   rec_.doc_class := doc_class_;
   rec_.doc_no    := doc_no_;
   rec_.doc_sheet := doc_sheet_;
   rec_.doc_rev   := doc_rev_;
   rec_.doc_type  := doc_type_;
   rec_.file_no   := file_no_;
   RETURN rec_;
END Edm_File_Keys___;


FUNCTION Document_Rowversion___
  (keys_ IN edm_file_keys) RETURN DATE
IS
   rowversion_ DATE;
BEGIN
   SELECT rowversion INTO rowversion_
     FROM edm_file_tab
     WHERE doc_class = keys_.doc_class
     AND doc_no      = keys_.doc_no
     AND doc_sheet   = keys_.doc_sheet
     AND doc_rev     = keys_.doc_rev
     AND doc_type    = keys_.doc_type
     AND file_no     = keys_.file_no;
   RETURN rowversion_;
END Document_Rowversion___;


FUNCTION Media_Rowversion___
  (item_id_ IN NUMBER) RETURN DATE
IS
   rowversion_ DATE;
BEGIN
   SELECT rowversion INTO rowversion_
     FROM media_item_tab
     WHERE item_id = item_id_;
   RETURN rowversion_;
END Media_Rowversion___;


FUNCTION Document_Key_Ref___
  (doc_ IN edm_file_keys) RETURN VARCHAR2 IS
BEGIN
   RETURN 'DOC_CLASS=' || doc_.doc_class ||
         '^DOC_NO='    || doc_.doc_no    ||
         '^DOC_REV='   || doc_.doc_rev   ||
         '^DOC_SHEET=' || doc_.doc_sheet ||
         '^DOC_TYPE='  || doc_.doc_type  ||
         '^FILE_NO='   || doc_.file_no   || '^';
END Document_Key_Ref___;


FUNCTION Media_Key_Ref___
  (item_id_ IN media_item_tab.item_id%TYPE) RETURN VARCHAR2 IS
BEGIN
   RETURN 'ITEM_ID=' || item_id_ || '^';
END Media_Key_Ref___;


FUNCTION Obj_Trans_Status_Rec_Exists___
  (lu_name_           IN VARCHAR2,
   key_ref_           IN VARCHAR2) RETURN BOOLEAN
IS
   count_ NUMBER;
BEGIN
   SELECT COUNT(*) INTO count_
     FROM fs_mig_status_tab
     WHERE lu_name = lu_name_
     AND   key_ref = key_ref_;
   RETURN count_ > 0;
END Obj_Trans_Status_Rec_Exists___;


PROCEDURE Set_Object_Transfer_Status___
  (lu_name_           IN VARCHAR2,
   key_ref_           IN VARCHAR2,
   status_            IN VARCHAR2,
   object_rowversion_ IN DATE,
   content_length_    IN NUMBER,
   hash_              IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   IF Obj_Trans_Status_Rec_Exists___ (lu_name_, key_ref_) THEN
      UPDATE fs_mig_status_tab
        SET status = status_,
        content_length = content_length_,
        object_rowversion =  object_rowversion_,
        status_date = sysdate
        WHERE lu_name = lu_name_
        AND   key_ref = key_ref_;        
   ELSE
      INSERT INTO fs_mig_status_tab (
         lu_name,
         key_ref,
         content_length,
         status,
         status_date,
         object_rowversion,
         hash)
     VALUES (
         lu_name_,
         key_ref_,
         content_length_,
         status_,
         sysdate,
         object_rowversion_,
         hash_);
   END IF;
END Set_Object_Transfer_Status___;


FUNCTION Get_Document_Size___
  (doc_keys_ IN edm_file_keys) RETURN NUMBER
IS
   document_size_ NUMBER;
BEGIN
   SELECT NVL(DBMS_LOB.GetLength (file_data), 0) INTO document_size_
     FROM edm_file_storage_tab
     WHERE doc_class = doc_keys_.doc_class
     AND   doc_no    = doc_keys_.doc_no
     AND   doc_sheet = doc_keys_.doc_sheet
     AND   doc_rev   = doc_keys_.doc_rev
     AND   doc_type  = doc_keys_.doc_type
     AND   file_no   = doc_keys_.file_no;

   RETURN document_size_;
END Get_Document_Size___;


FUNCTION Get_Media_Size___
  (item_id_ IN NUMBER) RETURN NUMBER
IS
   media_size_ NUMBER;
BEGIN
   SELECT NVL(DBMS_LOB.GetLength (media_object), 0) INTO media_size_
     FROM media_item_tab
     WHERE item_id = item_id_;
   RETURN NVL(media_size_, 0);
END Get_Media_Size___;


FUNCTION Document_Exists___
  (doc_keys_ IN edm_file_keys) RETURN BOOLEAN
IS
   count_ NUMBER;
BEGIN
   SELECT COUNT(*) INTO count_
     FROM edm_file_storage_tab
     WHERE doc_class = doc_keys_.doc_class
     AND   doc_no    = doc_keys_.doc_no
     AND   doc_sheet = doc_keys_.doc_sheet
     AND   doc_rev   = doc_keys_.doc_rev
     AND   doc_type  = doc_keys_.doc_type
     AND   file_no   = doc_keys_.file_no;
   RETURN count_ > 0;
END Document_Exists___;


FUNCTION Media_Exists___
  (item_id_ IN NUMBER) RETURN BOOLEAN
IS
   count_ NUMBER;
BEGIN
   SELECT COUNT(*) INTO count_
     FROM media_item_tab
     WHERE item_id = item_id_;
   RETURN count_ > 0;
END Media_Exists___;


PROCEDURE Log_Object_Info__
  (lu_name_           IN VARCHAR2,
   key_ref_           IN VARCHAR2,
   info_              IN VARCHAR2) IS
BEGIN
   INSERT INTO fs_mig_log_tab
     (
      lu_name,
      key_ref,
      info,
      log_timestamp)
     VALUES
     (
      lu_name_,
      key_ref_,
      info_,
      sysdate);
END Log_Object_Info__;


PROCEDURE Log_Document_Info__
  (doc_class_ IN VARCHAR2,
   doc_no_    IN VARCHAR2,
   doc_sheet_ IN VARCHAR2,
   doc_rev_   IN VARCHAR2,
   doc_type_  IN VARCHAR2,
   file_no_   IN NUMBER,
   info_      IN VARCHAR2)
IS
   doc_keys_ edm_file_keys := Edm_File_Keys___ (doc_class_, doc_no_, doc_sheet_, doc_rev_, doc_type_, file_no_);
BEGIN
   Log_Object_Info__ ('EdmFileStorage', Document_Key_Ref___ (doc_keys_), info_);
END Log_Document_Info__;


PROCEDURE Log_Media_Info__
  (item_id_ IN NUMBER,
   info_    IN VARCHAR2)
IS
BEGIN
   Log_Object_Info__ ('MediaItem', Media_Key_Ref___ (item_id_), info_);
END Log_Media_Info__;


PROCEDURE Set_Document_Transfer_Status__
  (doc_class_ IN VARCHAR2,
   doc_no_    IN VARCHAR2,
   doc_sheet_ IN VARCHAR2,
   doc_rev_   IN VARCHAR2,
   doc_type_  IN VARCHAR2,
   file_no_   IN NUMBER,
   status_    IN VARCHAR2)
IS
   doc_keys_ edm_file_keys := Edm_File_Keys___ (doc_class_, doc_no_, doc_sheet_, doc_rev_, doc_type_, file_no_);
BEGIN
     Set_Object_Transfer_Status___ ('EdmFileStorage',
                                    Document_Key_Ref___ (doc_keys_),
                                    status_,
                                    Document_Rowversion___ (doc_keys_),
                                    Get_Document_Size___ (doc_keys_));
END Set_Document_Transfer_Status__;


FUNCTION Media_Hash___ (
   item_id_ IN NUMBER) RETURN VARCHAR2
IS
   hash_source_str_ VARCHAR2(32000);
   hash_            VARCHAR2(2000);
   
  CURSOR Get_Media_Item IS
    SELECT name,
           description,
           obsolete,
           resolution,
           media_file,
           private_media_item,
           archived,
           archive_no,
           latest_access_date
    FROM media_item_tab
    WHERE item_id = item_id_;

BEGIN
   FOR rec_ IN Get_Media_Item
   LOOP
      hash_source_str_ := rec_.name;
      hash_source_str_ := hash_source_str_ || rec_.description;
      hash_source_str_ := hash_source_str_ || rec_.obsolete;
      hash_source_str_ := hash_source_str_ || rec_.resolution;
      hash_source_str_ := hash_source_str_ || rec_.media_file;
      hash_source_str_ := hash_source_str_ || rec_.private_media_item;
      hash_source_str_ := hash_source_str_ || rec_.archived;
      hash_source_str_ := hash_source_str_ || rec_.archive_no;
      hash_source_str_ := hash_source_str_ || TO_CHAR (rec_.latest_access_date, 'YYYYMMDDHH24MISS');
   END LOOP;

--   DBMS_OUTPUT.Put_Line ('media hash_source_str_ = ' || hash_source_str_);

   select rawtohex(
     DBMS_CRYPTO.Hash (UTL_I18N.STRING_TO_RAW (hash_source_str_, 'AL32UTF8'), 2)) INTO hash_
   FROM dual;
   
--   hash_raw_ := dbms_crypto.hash(src => hash_source_str_,
--                                 typ => dbms_crypto.hash_md5);
								
--	hash_ := utl_encode.base64_encode(hash_raw_);
--	hash_ := utl_raw.cast_to_varchar2(hash_);

--   DBMS_OUTPUT.Put_Line ('media hash = ' || hash_);

   RETURN hash_;

END Media_Hash___;


PROCEDURE Set_Media_Transfer_Status__
  (item_id_ IN NUMBER,
   status_  IN VARCHAR2)
IS
   key_ref_ VARCHAR2(2000) := Media_Key_Ref___ (item_id_);
   rowversion_ DATE;
BEGIN
   SELECT rowversion INTO rowversion_
     FROM media_item_tab
     WHERE item_id = item_id_;
   Set_Object_Transfer_Status___ ('MediaItem', key_ref_, status_, rowversion_, Get_Media_Size___ (item_id_), Media_Hash___ (item_id_));
END Set_Media_Transfer_Status__;



FUNCTION Doc_Transfer_Status___
  (keys_ IN edm_file_keys) RETURN VARCHAR2
IS
   status_ VARCHAR2(20);

   CURSOR get_status (key_ref_ IN VARCHAR2) IS
     SELECT status
     FROM fs_mig_status_tab
     WHERE lu_name = 'EdmFileStorage'
     AND key_ref = key_ref_;

BEGIN
   OPEN get_status (Document_Key_Ref___ (keys_));
   FETCH get_status INTO status_;
   CLOSE get_status;

   RETURN status_;
END Doc_Transfer_Status___;


FUNCTION Media_Transfer_Status___
  (item_id_ IN NUMBER) RETURN VARCHAR2
IS
   status_  VARCHAR2(20);
   key_ref_ VARCHAR2(2000) := Media_Key_Ref___ (item_id_);

   CURSOR get_status IS
     SELECT status
     FROM fs_mig_status_tab
    WHERE lu_name = 'MediaItem'
     AND key_ref = key_ref_;

BEGIN
   OPEN get_status;
   FETCH get_status INTO status_;
   CLOSE get_status;

   RETURN status_;
END Media_Transfer_Status___;


FUNCTION Document_Location_Type___
  (keys_ IN edm_file_keys) RETURN VARCHAR2
IS
   type_ VARCHAR2 (10);
BEGIN
   SELECT DECODE(el.location_type, '1', 'Shared', '2', 'FTP', '3', 'DB') INTO type_
     FROM edm_file_tab ef,
          edm_location_tab el
     WHERE ef.doc_class     = keys_.doc_class
           AND ef.doc_no    = keys_.doc_no
           AND ef.doc_sheet = keys_.doc_sheet
           AND ef.doc_rev   = keys_.doc_rev
           AND ef.doc_type  = keys_.doc_type
           AND ef.file_no   = keys_.file_no
           AND  el.location_name = ef.location_name;
   RETURN type_;
EXCEPTION
   WHEN no_data_found THEN
     RETURN NULL;
END Document_Location_Type___;


FUNCTION Document_File_Status___
  (keys_ IN edm_file_keys) RETURN VARCHAR2
IS
   status_ VARCHAR2 (30);
BEGIN
   SELECT rowstate INTO status_
     FROM edm_file_tab ef
     WHERE ef.doc_class     = keys_.doc_class
           AND ef.doc_no    = keys_.doc_no
           AND ef.doc_sheet = keys_.doc_sheet
           AND ef.doc_rev   = keys_.doc_rev
           AND ef.doc_type  = keys_.doc_type
           AND ef.file_no   = keys_.file_no;
   RETURN status_;
EXCEPTION
   WHEN no_data_found THEN
     RETURN NULL;
END Document_File_Status___;


FUNCTION Get_Object_Status_Rec___
  (lu_name_ IN VARCHAR2,
   key_ref_ IN VARCHAR2) RETURN fs_mig_status_tab%ROWTYPE
IS
   rec_ fs_mig_status_tab%ROWTYPE;
BEGIN
   SELECT * INTO rec_
     FROM fs_mig_status_tab
     WHERE lu_name = lu_name_
     AND key_ref = key_ref_;
   RETURN rec_;
END Get_Object_Status_Rec___;


FUNCTION Media_Changed___
  (item_id_ IN NUMBER) RETURN BOOLEAN
IS
   status_rec_             fs_mig_status_tab%ROWTYPE;
   current_rowversion_     edm_file_storage_tab.rowversion%TYPE;
   transferred_media_size_ NUMBER;
   current_media_size_     NUMBER;
   current_media_hash_     VARCHAR2(32000);

   CURSOR get_current_info IS
     SELECT rowversion, DBMS_LOB.Getlength (media_object)
     FROM media_item_tab
     WHERE item_id = item_id_;
BEGIN
   status_rec_ := Get_Object_Status_Rec___ ('MediaItem', Media_Key_Ref___ (item_id_));

   OPEN get_current_info;
   FETCH get_current_info INTO current_rowversion_, current_media_size_;
   CLOSE get_current_info;

   current_media_hash_ := Media_Hash___ (item_id_);

   IF status_rec_.object_rowversion != current_rowversion_ AND status_rec_.hash != current_media_hash_ THEN
      RETURN TRUE;
   END IF;

   RETURN FALSE;

END Media_Changed___;


-- PROTECTED METHODS - Only to be used from the FS Migration tool!
-- PROTECTED METHODS - Only to be used from the FS Migration tool!
-- PROTECTED METHODS - Only to be used from the FS Migration tool!


FUNCTION Doc_Allowed_For_Transfer__
  (reason_    OUT VARCHAR2,
   doc_class_ IN  VARCHAR2,
   doc_no_    IN  VARCHAR2,
   doc_sheet_ IN  VARCHAR2,
   doc_rev_   IN  VARCHAR2,
   doc_type_  IN  VARCHAR2,
   file_no_   IN  NUMBER) RETURN VARCHAR2
IS

   doc_keys_ edm_file_keys := Edm_File_Keys___ (doc_class_, doc_no_, doc_sheet_, doc_rev_, doc_type_, file_no_);
   status_        VARCHAR2 (20) := Doc_Transfer_Status___ (doc_keys_);
   location_type_ VARCHAR2 (10) := Document_Location_Type___ (doc_keys_);

   status_rec_          fs_mig_status_tab%ROWTYPE;
   current_rowversion_  edm_file_tab.rowversion%TYPE;

   CURSOR get_current_rowversion IS
     SELECT rowversion
     FROM edm_file_tab
     WHERE doc_class = doc_keys_.doc_class
     AND doc_no      = doc_keys_.doc_no
     AND doc_sheet   = doc_keys_.doc_sheet
     AND doc_rev     = doc_keys_.doc_rev
     AND doc_type    = doc_keys_.doc_type
     AND file_no     = doc_keys_.file_no;


BEGIN

   IF NOT Document_Exists___ (doc_keys_) THEN
      reason_ := 'The document does not exist: ' || Document_Key_Ref___ (doc_keys_);
      RETURN 'FALSE';
   END IF;

   IF Document_File_Status___ (doc_keys_) != 'Checked In' THEN
      reason_ := 'Document must be checked in';
      RETURN 'FALSE';      
   END IF;

   IF status_ = 'In progress' THEN
      reason_ := 'Document transfer in progress';
      RETURN 'FALSE';
   END IF;

   IF location_type_ != 'DB' THEN
      reason_ := 'Repository type ' || location_type_ || ' is currently not supported.';
      RETURN 'FALSE';
   END IF;

   IF status_ = 'Done' THEN
      status_rec_ := Get_Object_Status_Rec___ ('EdmFileStorage', Document_Key_Ref___ (doc_keys_));

      OPEN get_current_rowversion;
      FETCH get_current_rowversion INTO current_rowversion_;
      CLOSE get_current_rowversion;

      IF status_rec_.object_rowversion != current_rowversion_ THEN
         reason_ := 'Document was successfully transferred earlier but the version have changed';
         RETURN 'TRUE';
      ELSE
         reason_ := 'Document is already transferred';
         RETURN 'FALSE';
      END IF;

   END IF;

   RETURN 'TRUE';
END Doc_Allowed_For_Transfer__;


FUNCTION Media_Allowed_For_Transfer__
   (reason_  OUT VARCHAR2,
    item_id_ IN  NUMBER) RETURN VARCHAR2
IS
   status_ VARCHAR2 (20) := Media_Transfer_Status___ (item_id_);
BEGIN

   IF NOT Media_Exists___ (item_id_) THEN
      reason_ := 'The media does not exist: ' || Media_Key_Ref___ (item_id_);
      RETURN 'FALSE';
   END IF;

   IF Get_Media_Size___ (item_id_) = 0 THEN
      reason_ := 'The media item is empty: ' || Media_Key_Ref___ (item_id_);
      RETURN 'FALSE';
   END IF;

   IF status_ = 'In progress' THEN
      reason_ := 'Media transfer in progress';
      RETURN 'FALSE';
   END IF;

   IF status_ = 'Done' THEN
      IF Media_Changed___ (item_id_) THEN
         reason_ := 'Media was successfully transferred earlier but the content have changed';
         RETURN 'TRUE';
      ELSE
         reason_ := 'Media is already transferred';
         RETURN 'FALSE';
      END IF;
   END IF;

   RETURN 'TRUE';
END Media_Allowed_For_Transfer__;


FUNCTION Get_Document_File_And_Size__
  (size_      OUT NUMBER,
   doc_class_ IN VARCHAR2,
   doc_no_    IN VARCHAR2,
   doc_sheet_ IN VARCHAR2,
   doc_rev_   IN VARCHAR2,
   doc_type_  IN VARCHAR2,
   file_no_   IN NUMBER) RETURN BLOB
IS
   file_data_ BLOB;
BEGIN
   SELECT file_data, NVL(DBMS_LOB.GetLength (file_data), 0) INTO file_data_, size_
     FROM edm_file_storage_tab
     WHERE doc_class = doc_class_
       AND doc_no    = doc_no_
       AND doc_sheet = doc_sheet_
       AND doc_rev   = doc_rev_
       AND doc_type  = doc_type_
       AND file_no   = file_no_;
   RETURN file_data_;
END Get_Document_File_And_Size__;


FUNCTION Get_Media_File_And_Size__
  (size_      OUT NUMBER,
   item_id_   IN NUMBER) RETURN BLOB
IS
   media_object_ BLOB;
BEGIN
   SELECT media_object, NVL(DBMS_LOB.GetLength (media_object), 0) INTO media_object_, size_
     FROM media_item_tab
     WHERE item_id = item_id_;
   RETURN media_object_;
END Get_Media_File_And_Size__;

END Fs_Mig_Tool_API;
/

show err

