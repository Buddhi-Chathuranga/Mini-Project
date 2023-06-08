-----------------------------------------------------------------------------
--
--  Logical unit: XmlReportData
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  040205  RAKU  Added method Clear. (Bug#41529).
--  040206  RAKU  Added method Retreive_Xml_Data__. (Bug#41529).
--  040206  RAKU  Added method Xml_Data_Exist__. (Bug#41529).
--  040210  RAKU  Modifyed method Xml_Data_Exist__. (Bug#41529).
--  120215  LAKRLK RDTERUNTIME-184
--  140129  AsiWLK   Merged LCS-111925
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Retreive_Xml_Data__ (
   string_ OUT VARCHAR2,
   continue_ OUT VARCHAR2,
   result_key_ IN NUMBER,
   report_id_ IN VARCHAR2,
   count_ IN NUMBER )
IS
   length_     NUMBER;
   chunk_size_ NUMBER := 1024 * 8; -- 8K characters
   data_       CLOB;
   CURSOR get_data IS
   SELECT data
      FROM  XML_REPORT_DATA_TAB
      WHERE result_key = result_key_
      AND   report_id = report_id_;
BEGIN
   OPEN  get_data;
   FETCH get_data INTO data_;
   CLOSE get_data;
   dbms_lob.open(data_, dbms_lob.lob_readonly );
   length_ := dbms_lob.getlength(data_);
   string_ := dbms_lob.substr(data_, chunk_size_, (count_ * chunk_size_) + 1);
   dbms_lob.close(data_);
   IF length_ > (count_ + 1) * chunk_size_ THEN
      continue_ := 'TRUE';
   ELSE
      continue_ := 'FALSE';
   END IF;
END Retreive_Xml_Data__;


@UncheckedAccess
FUNCTION Xml_Data_Exist__ (
   result_key_ IN NUMBER,
   report_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(result_key_, report_id_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Xml_Data_Exist__;

FUNCTION Compress_XML__ (
      l_original_clob_ IN CLOB,
      l_original_size_ OUT NUMBER) RETURN BLOB 
IS
    l_original_blob_   BLOB;
    l_compressed_blob_ BLOB;
    l_warning_         NUMBER := 0;
    l_in_              NUMBER := 1;
    l_out_             NUMBER := 1;
    l_lang_            NUMBER := 873;
BEGIN

    dbms_lob.createtemporary(l_compressed_blob_,TRUE);
    dbms_lob.createtemporary(l_original_blob_,TRUE);
    dbms_lob.converttoblob(l_original_blob_,
                           l_original_clob_,
                           dbms_lob.getlength(l_original_clob_),
                           l_in_,
                           l_out_,
                           dbms_lob.default_csid,
                           l_lang_,
                           l_warning_);
    l_original_size_ := dbms_lob.Getlength(l_original_blob_);
    utl_compress.lz_compress (l_original_blob_, l_compressed_blob_);
    dbms_lob.Freetemporary(l_original_blob_);
    RETURN l_compressed_blob_;
END Compress_XML__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Clear (
   result_key_ IN NUMBER )
IS
BEGIN
   DELETE
      FROM XML_REPORT_DATA_TAB
      WHERE result_key = result_key_;
END Clear;


PROCEDURE Insert_Data (
   result_key_ IN NUMBER,
   report_id_ IN VARCHAR2,
   data_ IN CLOB )
IS
   z_data_ BLOB;
   original_size_ NUMBER;
BEGIN   
   IF (dbms_lob.getlength(data_) >= 100000) THEN
     z_data_ := Compress_XML__(data_,original_size_);
     INSERT INTO XML_REPORT_DATA_TAB(result_key, report_id, z_data, original_size, rowversion)
        VALUES(result_key_, report_id_, z_data_,  original_size_, sysdate);
   ELSE   
     INSERT INTO XML_REPORT_DATA_TAB(result_key, report_id, data, rowversion)
        VALUES(result_key_, report_id_, data_, sysdate);
   END IF;
END Insert_Data;

FUNCTION Get_XML_Data (
         result_key_ NUMBER ) RETURN CLOB 
IS
   data_clob_             CLOB;
   compressed_blob_     BLOB;
   uncompressed_blob_     BLOB;

   CURSOR Fetch_Data_Value (result_key_ IN NUMBER)
   IS
   SELECT s.DATA
   FROM XML_REPORT_DATA  s
   WHERE s.result_key = result_key_;

   CURSOR Fetch_Zdata_Value (result_key_ IN NUMBER)
   IS
   SELECT s.z_data
   FROM XML_REPORT_DATA  s
   WHERE s.result_key = result_key_;

   BEGIN
      
   dbms_lob.createtemporary(data_clob_,TRUE); 
      
   OPEN  Fetch_Data_Value(result_key_);
   FETCH Fetch_Data_Value INTO data_clob_;
   CLOSE Fetch_Data_Value;
              
   IF data_clob_ IS NULL THEN

      dbms_lob.createtemporary(compressed_blob_,TRUE);
      dbms_lob.createtemporary(uncompressed_blob_,TRUE);
      
      OPEN  Fetch_Zdata_Value(result_key_);
      FETCH Fetch_Zdata_Value INTO compressed_blob_;
      CLOSE Fetch_Zdata_Value;
      
      UTL_COMPRESS.lz_uncompress(src => compressed_blob_, dst =>  uncompressed_blob_);
      
      RETURN Convert_Blob_To_Clob__(uncompressed_blob_);
   ELSE
      RETURN data_clob_;
   END IF;         
END Get_XML_Data;


FUNCTION Convert_Blob_To_Clob__(blob_in_ IN BLOB) RETURN CLOB
IS
   out_clob_ clob;
   file_size_ integer := dbms_lob.lobmaxsize;
   dest_offset_ integer := 1;
   src_offset_ integer := 1;
   blob_csid_ number := dbms_lob.default_csid;
   lang_context_ number := dbms_lob.default_lang_ctx;
   warning_ integer;

BEGIN
   dbms_lob.createtemporary(out_clob_, true);
   dbms_lob.converttoclob(out_clob_,
      blob_in_,
      file_size_,
      dest_offset_,
      src_offset_,
      blob_csid_,
      lang_context_,
      warning_);
      
   return out_clob_;   
END Convert_Blob_To_Clob__;
