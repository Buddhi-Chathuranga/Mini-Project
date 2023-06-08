-----------------------------------------------------------------------------
--
--  Logical unit: EnterpLobWriter
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

g_flush_point_   CONSTANT PLS_INTEGER     := 30000;
crlf_            CONSTANT VARCHAR2(10)    := CHR(13)||CHR(10);

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Write_String___ (
   file_stream_ IN OUT CLOB,
   file_buffer_ IN OUT VARCHAR2,
   string_      IN     VARCHAR2 )
IS
   l_buffer_  PLS_INTEGER := NVL(LENGTH(file_buffer_),0);
BEGIN
   -- check buffer 
   IF (l_buffer_ + LENGTH(string_) >= g_flush_point_) THEN
      -- Flush buffer to temporary-clob      
      Dbms_Lob.WriteAppend(file_stream_, l_buffer_, file_buffer_);
      file_buffer_ := '';      
   END IF;
   file_buffer_ := file_buffer_ || string_;
END Write_String___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Write_Initiate (
   file_stream_    OUT CLOB,
   file_buffer_ IN OUT VARCHAR2 )
IS
BEGIN   
   -- initialize buffer
   file_buffer_ := '';   
   -- initialize temporary-clob
   Dbms_Lob.CreateTemporary(file_stream_, TRUE);
END Write_Initiate;


PROCEDURE Write_String (
   file_stream_ IN OUT CLOB,
   file_buffer_ IN OUT VARCHAR2,
   string_      IN     VARCHAR2 )
IS
BEGIN   
   Write_String___(file_stream_, file_buffer_, string_);
END Write_String;


PROCEDURE Write_Line_String (
   file_stream_ IN OUT CLOB,
   file_buffer_ IN OUT VARCHAR2,
   string_      IN     VARCHAR2 )
IS
BEGIN   
   Write_String___(file_stream_, file_buffer_, (string_ || crlf_));
END Write_Line_String;


PROCEDURE Write_Finalize (
   clob_final_     OUT CLOB,
   file_stream_ IN OUT CLOB,
   file_buffer_ IN OUT VARCHAR2 )
IS
   l_buffer_ PLS_INTEGER := NVL(LENGTH(file_buffer_),0);
BEGIN   
   -- Flush buffer to temporary-clob
   IF (l_buffer_ > 0) THEN
      Dbms_Lob.WriteAppend(file_stream_, l_buffer_, file_buffer_);
      file_buffer_ := '';
   END IF;
   -- Retrive clob to output clob
   clob_final_ := file_stream_;
   -- free temporary-clob
   IF (Dbms_Lob.istemporary(file_stream_) = 1) THEN
      Dbms_Lob.freetemporary(file_stream_);
   END IF;
END Write_Finalize;


