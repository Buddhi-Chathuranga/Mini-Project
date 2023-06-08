-----------------------------------------------------------------------------
--
--  Logical unit: BatchProcessorTest
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -----------------------------------------------------
--  2014-10-14  madrse  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Modify_Bmp___(data_ IN OUT NOCOPY BLOB) IS
   len_ NUMBER;
BEGIN
   -- changes color to rose in a bmp file representing red squere 20x20 pixels
   -- in it's upper half
   len_ := length(data_);
   Log_SYS.App_Trace(Log_SYS.debug_, 'Binary data length: '||len_);
   FOR i IN round(len_/2)..len_ LOOP
      DECLARE
         byte_ RAW(1) := Dbms_Lob.Substr(data_, 1, i);
      BEGIN
         IF to_char(byte_) = '24' OR to_char(byte_) = '1C' THEN
            Dbms_Lob.Write(data_, 1, i, Utl_Raw.Cast_From_Number(85));
         END IF;
      END;
   END LOOP;
END Modify_Bmp___;


FUNCTION From_Base64___(data_ CLOB) RETURN BLOB IS
   substr_   VARCHAR2(3000);
   len_      PLS_INTEGER := 4*512; -- must be multiple of 4
   n_        PLS_INTEGER := 0;
   b64_data_ CLOB;
   result_   BLOB;
   line_     RAW(4000);
BEGIN
   b64_data_ := regexp_replace(data_, '[[:space:]]*','');
   Dbms_Lob.Createtemporary(result_, true);
   Dbms_Lob.Open(result_, Dbms_Lob.lob_readwrite);
   WHILE TRUE LOOP
      substr_ := Dbms_Lob.substr(b64_data_, least(len_, length(b64_data_)-len_*n_), len_*n_+1);
      IF substr_ IS NULL THEN
         EXIT;
      END IF;
      line_ := utl_encode.base64_decode(utl_raw.cast_to_raw(substr_));
      Dbms_Lob.Writeappend(result_, Utl_Raw.length(line_), line_);
      n_ := n_ + 1;
   END LOOP;
   Dbms_Lob.Close(result_);
   RETURN result_;
END From_Base64___;


FUNCTION To_Base64___(data_ BLOB) RETURN CLOB IS
   substr_  RAW(4000);
   len_     PLS_INTEGER := 3*1024; -- must be multiple of 3
   n_       PLS_INTEGER := 0;
   result_  CLOB;
BEGIN
   WHILE TRUE LOOP
      substr_ := Dbms_Lob.substr(data_, least(len_, length(data_)-len_*n_), len_*n_+1);
      IF substr_ IS NULL THEN
         EXIT;
      END IF;
      result_ := result_ || regexp_replace(utl_raw.cast_to_varchar2(utl_encode.base64_encode(substr_)),'[[:space:]]*','');
      n_ := n_ + 1;
   END LOOP;
   RETURN result_;
END To_Base64___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

--
-- Spools to Dbms_Output delete and insert statements for specified table and where condition.
-- Only VARCHAR2, NUMBER, DATE, short CLOB and short textual BLOB columns are supported.
--
PROCEDURE Export_One_Table (
   grp_name_     VARCHAR2,
   tab_name_     VARCHAR2,
   where_clause_ VARCHAR2,
   order_by_     VARCHAR2 DEFAULT NULL)
IS
   column_list_     VARCHAR2(4096) := NULL;
   insert_list_     VARCHAR2(16096);
   ref_cur_columns_ VARCHAR2(16096) := NULL;
   ref_cur_query_   VARCHAR2(16000);
   ref_cur_output_  VARCHAR2(16000) := NULL;
   column_name_     VARCHAR2(256);

   CURSOR c1 IS
      SELECT column_name, data_type FROM user_tab_columns
       WHERE table_name = upper(tab_name_) ORDER BY column_id;

   refcur_ sys_refcursor;
BEGIN
   Dbms_Output.Put_Line('-----------------------------------------------');
   Dbms_Output.Put_Line('PROMPT '|| grp_name_ || ': ' || upper(tab_name_));
   Dbms_Output.Put_Line('-----------------------------------------------');
   Dbms_Output.Put_Line('DELETE FROM '|| tab_name_ ||' WHERE ' || where_clause_ || ';');

   FOR i IN c1 LOOP
      IF i.data_type = 'NUMBER' THEN
         column_name_ := i.column_name;
      ELSIF i.data_type = 'DATE' THEN
         column_name_ := chr(39)||'to_date('||chr(39)||'||chr(39)'||'||to_char('||i.column_name||','||chr(39)||'yyyy-mm-dd hh24:mi:ss'||chr(39)||')||chr(39)||'||chr(39)||','||chr(39)||'||chr(39)||'||chr(39)||'yyyy-mm-dd hh24:mi:ss'||chr(39)||'||chr(39)||'||chr(39)||')'||chr(39);
      ELSIF i.data_type = 'TIMESTAMP(6)' THEN
         column_name_ := chr(39)||'to_timestamp('||chr(39)||'||chr(39)'||'||to_char('||i.column_name||','||chr(39)||'yyyy-mm-dd hh24:mi:ss.ff6'||chr(39)||')||chr(39)||'||chr(39)||','||chr(39)||'||chr(39)||'||chr(39)||'yyyy-mm-dd hh24:mi:ss.ff6'||chr(39)||'||chr(39)||'||chr(39)||')'||chr(39);
      ELSIF i.data_type = 'VARCHAR2' THEN
         column_name_ := 'chr(39)||replace('|| i.column_name ||','''''''','''''''''''')||chr(39)';
      ELSIF i.data_type = 'CLOB' THEN
         column_name_ := 'chr(39)||replace('|| i.column_name ||','''''''','''''''''''')||chr(39)';
      ELSIF i.data_type = 'BLOB' THEN
         column_name_ := '''Utl_Raw.Cast_To_Raw(''||chr(39)||replace(Utl_Raw.Cast_To_Varchar2('|| i.column_name ||'),'''''''','''''''''''')||chr(39)||'')''';
      ELSE
         CONTINUE;
      END IF;
      column_list_ := column_list_||','||i.column_name;
      ref_cur_columns_ := ref_cur_columns_||'||'||chr(39)||','||chr(39)||'||'||column_name_;
   END LOOP;

   IF column_list_ is null then
      Dbms_Output.Put_Line('--Table '|| tab_name_ || ' does not exist');
   ELSE
      column_list_     := LTRIM(column_list_,',');
      ref_cur_columns_ := SUBSTR(ref_cur_columns_,8);

      insert_list_     := 'INSERT INTO '||tab_name_||' ('||column_list_||') VALUES ';
      ref_cur_query_   := 'SELECT '||ref_cur_columns_||' FROM '|| tab_name_  || ' WHERE '||where_clause_;
      IF order_by_ IS NOT NULL THEN
         ref_cur_query_ := ref_cur_query_ || ' ORDER BY ' || order_by_;
      END IF;

      @ApproveDynamicStatement(2015-01-14,madrse)
      OPEN refcur_ FOR ref_cur_query_;
      LOOP
         FETCH refcur_ INTO ref_cur_output_;
         EXIT WHEN refcur_%NOTFOUND;
         ref_cur_output_ := '('||ref_cur_output_||');';
         ref_cur_output_ := REPLACE(ref_cur_output_,',,',',null,');
         ref_cur_output_ := REPLACE(ref_cur_output_,',,',',null,');
         ref_cur_output_ := REPLACE(ref_cur_output_,'(,','(null,');
         ref_cur_output_ := REPLACE(ref_cur_output_,',,)',',null)');
         ref_cur_output_ := REPLACE(ref_cur_output_,'null,)','null,null)');
         ref_cur_output_ := REPLACE(ref_cur_output_, chr(10)||chr(10), ''' || chr(10) || chr(10) || ''');
         ref_cur_output_ := REPLACE(ref_cur_output_,chr(13),'');
         ref_cur_output_ := insert_list_||ref_cur_output_;
         Dbms_Output.Put_Line (ref_cur_output_);
      END LOOP;
      IF ref_cur_output_ IS NULL THEN
         Dbms_Output.Put_Line('--No data in '||tab_name_);
      END IF;
   END IF;
END Export_One_Table;


@UncheckedAccess
FUNCTION Elapsed_Seconds (t1_ timestamp, t2_ timestamp) RETURN NUMBER IS
   diff_ interval day to second := t2_ - t1_;
BEGIN
    RETURN extract(day from diff_) * 86400 + extract(hour from diff_) * 3600 + extract(minute from diff_) * 60 + extract(second from diff_);
END Elapsed_Seconds;


PROCEDURE Rest_Sender_Callback_Test (xml_ CLOB, app_msg_id_ NUMBER) IS

   clob_ CLOB := xml_;

   FUNCTION Get_Value (name_ VARCHAR2) RETURN VARCHAR2 IS
      start_ BINARY_INTEGER := Dbms_Lob.instr(xml_, '<'||name_||'>') + length(name_) + 2;
      end_   BINARY_INTEGER := Dbms_Lob.instr(xml_, '</'||name_||'>');
   BEGIN
      IF start_ > 1 AND end_ > start_ THEN
         RETURN Dbms_Lob.substr(xml_, end_ - start_, start_);
      ELSE
         RETURN 'NO_SENDER';
      END IF;
   END;

BEGIN
   PLSQLAP_Server_API.Post_Outbound_Message (
      xml_                 => clob_,
      sender_              => 'CONNTEST_'||Get_Value('TEST_ID'),
      receiver_            => 'CONNTEST_REST_CALLBACK',
      message_function_    => NULL,
      external_message_id_ => app_msg_id_);
END Rest_Sender_Callback_Test;


FUNCTION Plsql_Address_Test (xml_ CLOB) RETURN CLOB IS
   app_msg_id_ NUMBER;
   result_     CLOB;
BEGIN
   Log_SYS.App_Trace(Log_SYS.trace_, 'Incoming document:'||xml_);
   app_msg_id_ := App_Context_SYS.Find_Number_Value('APPLICATION_MESSAGE_ID', 0);
   result_ := replace(xml_, '</COMMENTS>', '/Modified by Batch_Processor_Test_API.Plsql_Address_Test ['||app_msg_id_||']</COMMENTS>');
   RETURN result_;
END Plsql_Address_Test;


FUNCTION Plsql_Address_Test_Txt (txt_ CLOB) RETURN CLOB IS
   pos_      NUMBER;
   scenario_ VARCHAR2(50);
BEGIN
   Log_SYS.App_Trace(Log_SYS.debug_, 'Incoming document:'||txt_);
   pos_ := instr(txt_, '@', 1, 2);
   scenario_ := substr(txt_, pos_+1, 32);
   RETURN 'Document retrieved by Plsql_Address_Test_Txt method for scenario ['||scenario_||'].';
END Plsql_Address_Test_Txt;


FUNCTION Plsql_Address_Test_Bin (xml_ CLOB) RETURN CLOB IS
   doc_    Plsqlap_Document_API.Document;
   data_   BLOB;
   result_ CLOB;
BEGIN
   Log_SYS.App_Trace(Log_SYS.debug_, 'Incoming XML document:'||chr(10)||xml_);
   Plsqlap_Document_API.From_Ifs_Xml(doc_, xml_);
   data_ := Plsqlap_Document_API.Get_Blob_Value(doc_, 'BIN_DATA');
   Modify_Bmp___(data_);

   doc_ := Plsqlap_Document_API.New_Document('BINARY_PARAMETER');
   Plsqlap_Document_API.Add_Attribute(doc_, 'BIN_DATA', data_);
   Plsqlap_Document_API.To_Ifs_Xml(result_, doc_);
   Log_SYS.App_Trace(Log_SYS.debug_, 'Resulting XML document:'||result_);
   RETURN result_;
END Plsql_Address_Test_Bin;


FUNCTION Plsql_Address_Test_Bin2 (xml_ CLOB) RETURN CLOB IS
   enc_data_ CLOB;
   ns_       VARCHAR2(4000) := 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ifsrecord="urn:ifsworld-com:ifsrecord" xmlns="urn:ifsworld-com:schemas:connectframework_binary_parameter"';
   data_     BLOB;
   result_   CLOB;
BEGIN
   Log_SYS.App_Trace(Log_SYS.debug_, 'Incoming XML document:'||chr(10)||xml_);

   SELECT EXTRACTVALUE(XMLTYPE(xml_), '/BINARY_PARAMETER/BIN_DATA', ns_) INTO enc_data_ FROM dual;
   Log_SYS.App_Trace(Log_SYS.debug_, 'Extracted data:'||enc_data_);

   data_ := From_Base64___(enc_data_);
   Modify_Bmp___(data_);
   enc_data_ := To_Base64___(data_);

   SELECT XMLAGG(XMLELEMENT("BINARY_PARAMETER", XMLELEMENT("BIN_DATA",enc_data_))).getClobVal() INTO result_ FROM dual;
   Log_SYS.App_Trace(Log_SYS.debug_, 'Resulting XML document:'||result_);
   RETURN result_;
END Plsql_Address_Test_Bin2;

