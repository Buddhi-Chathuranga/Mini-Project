-----------------------------------------------------------------------------
--
--  Logical unit: InsUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -----------------------------------------------------
--  2016-02-27  madrse  Created (TEJSL-633)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

new_line_ CONSTANT VARCHAR2(1) := chr(10);

date_format_      CONSTANT VARCHAR2(30) := Client_SYS.date_format_;
timestamp_format_ CONSTANT VARCHAR2(30) := Client_SYS.timestamp_format_;

TYPE Column_Desc IS RECORD (
   column_name   VARCHAR2(30),
   data_type     VARCHAR2(128),
   max_value_len NUMBER);

TYPE Column_List IS TABLE OF Column_Desc INDEX BY BINARY_INTEGER;

TYPE Pos_List IS VARRAY(30) OF BINARY_INTEGER;  --> Pos_List(1,3,5,2)

TYPE Value_List IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;

TYPE Objid_List IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;

TYPE Ins_Context IS RECORD
  (table_name           VARCHAR2(30),
   col_list             Column_List,
   lob_list             Column_List,
   primary_key          Pos_List,
   lu_package           VARCHAR2(30),
   custom_new_proc      VARCHAR2(30),
   after_remove_func    VARCHAR2(100),
   modify_row_func      VARCHAR2(100),

   get_cursor           INTEGER,

   modify_existing_rows BOOLEAN := FALSE,

   current_objid        VARCHAR2(100),
   current_objversion   VARCHAR2(2000),
   current_lob_column   VARCHAR2(30),
   current_blob         BLOB,
   current_objid_list   Objid_List,

   custom_format_func   VARCHAR2(2000),
   custom_column_name   VARCHAR2(30),

   blob_buf             RAW(32767),
   clob_buf             VARCHAR2(32767),

   created              NUMBER := 0,
   modified             NUMBER := 0,
   unchanged            NUMBER := 0,
   skipped              NUMBER := 0,
   skipped_customized   NUMBER := 0,
   skipped_invalid      NUMBER := 0,
   removed              NUMBER := 0,
   removed_details      NUMBER := 0,

   modified_lobs        NUMBER := 0,
   unchanged_lobs       NUMBER := 0,
   skipped_lobs         NUMBER := 0,

   debug                BOOLEAN := FALSE);

TYPE List IS VARRAY(100) OF VARCHAR2(2000); --> List('A','B','C')

--
-- BLOB initialized by Begin_Ins_Output, cleared by End_Ins_Output and Clear_Ins_Output
--
@ApproveGlobalVariable(2016-06-23,madrse)
ins_content_ BLOB;

-------------------- PRIVATE DECLARATIONS -----------------------------------

global_indent_ CONSTANT VARCHAR2(10) := '   ';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Spool___(line_ VARCHAR2 DEFAULT NULL) IS
   buf_ RAW(32767);
BEGIN
   IF ins_content_ IS NOT NULL THEN
      buf_ := Utl_Raw.Cast_To_Raw(line_ || new_line_);
      Dbms_Lob.WriteAppend(ins_content_, Utl_Raw.Length(buf_), buf_);
   ELSE
      Dbms_Output.Put_Line(line_);
   END IF;
END Spool___;


FUNCTION Index_Of___ (
   list_        IN List,
   value_       IN VARCHAR2,
   ignore_case_ IN BOOLEAN DEFAULT TRUE) RETURN INTEGER IS
BEGIN
   FOR i IN 1 .. list_.COUNT LOOP
      IF ignore_case_ THEN
         IF upper(list_(i)) = upper(value_) THEN
            RETURN i;
         END IF;
      ELSE
         IF list_(i) = value_ THEN
            RETURN i;
         END IF;
      END IF;
   END LOOP;
   RETURN 0;
END Index_Of___;


FUNCTION Contains___ (
   list_        IN List,
   value_       IN VARCHAR2,
   ignore_case_ IN BOOLEAN DEFAULT TRUE) RETURN BOOLEAN IS
BEGIN
   RETURN Index_Of___(list_, value_, ignore_case_) > 0;
END Contains___;


FUNCTION Format_Order_By___ (
   list_ IN List) RETURN VARCHAR2
IS
   order_by_ VARCHAR2(32767);
BEGIN
   FOR i IN 1 .. list_.COUNT LOOP
      IF i > 1 THEN
         order_by_ := order_by_ || ', ';
      END IF;
      order_by_ := order_by_ || list_(i);
   END LOOP;
   RETURN order_by_;
END Format_Order_By___;


PROCEDURE Get_Column_List___ (
   table_name_       IN  VARCHAR2,
   skip_column_list_ IN  List,
   ordered_columns_  IN  VARCHAR2,
   col_list_         OUT Column_List,
   lob_list_         OUT Column_List)
IS
   columns_   Column_List;
   lobs_      Column_List;
   col_       Column_Desc;
BEGIN
   FOR c_ IN (SELECT column_name, data_type
                FROM user_tab_columns
               WHERE table_name = upper(table_name_)
               ORDER BY Ins_Util_API.Column_Ordering(column_name, ordered_columns_))
   LOOP
      IF skip_column_list_ IS NOT NULL AND Contains___(skip_column_list_, c_.column_name) THEN
         CONTINUE;
      END IF;
      IF c_.column_name NOT IN ('OBJID', 'OBJKEY', 'OBJVERSION', 'ROWKEY', 'ROWVERSION') THEN
         col_.column_name := c_.column_name;
         col_.data_type   := c_.data_type;
         IF c_.data_type IN ('BLOB') THEN
            lobs_(lobs_.COUNT + 1) := col_;
         ELSE
            columns_(columns_.COUNT + 1) := col_;
         END IF;
      END IF;
   END LOOP;
   col_list_ := columns_;
   lob_list_ := lobs_;
END Get_Column_List___;


FUNCTION Get_Format_Method_Image___ (
   column_name_        IN VARCHAR2,
   custom_format_func_ IN VARCHAR2,
   custom_column_name_ IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   IF upper(column_name_) = upper(custom_column_name_) THEN
      RETURN custom_format_func_;
   ELSE
      RETURN 'Ins_Util_API.Format(' || lower(column_name_) || ')';
   END IF;
END Get_Format_Method_Image___;

PROCEDURE Get_Column_Value_Max_Len___ (
   columns_            IN OUT NOCOPY Column_List,
   table_name_         IN            VARCHAR2,
   where_              IN            VARCHAR2,
   debug_              IN            BOOLEAN,
   custom_format_func_ IN            VARCHAR2,
   custom_column_name_ IN            VARCHAR2)
IS
   len_    INTEGER;
   ignore_ INTEGER;
   sql_    VARCHAR2(32767);
   cursor_ INTEGER;
BEGIN
   sql_ := 'SELECT ';
   FOR i IN 1 .. columns_.COUNT LOOP
      IF i > 1 THEN
         sql_ := sql_ || ', ';
      END IF;
      sql_ := sql_ || 'nvl(max(length(' || Get_Format_Method_Image___(columns_(i).column_name, custom_format_func_, custom_column_name_) || ')),0)';
   END LOOP;
   sql_ := sql_ || new_line_ || '  FROM ' || table_name_;
   IF where_ IS NOT NULL THEN
      sql_ := sql_ || new_line_ || ' WHERE ' || where_;
   END IF;

   IF debug_ THEN
      Spool___(sql_);
      Spool___;
   END IF;

   cursor_ := Dbms_Sql.Open_Cursor;
   @ApproveDynamicStatement(2016-05-12,madrse)
   Dbms_Sql.Parse(cursor_, sql_, Dbms_Sql.NATIVE);

   FOR i IN 1 .. columns_.COUNT LOOP
      Dbms_Sql.Define_Column(cursor_, i, len_);
   END LOOP;

   ignore_ := Dbms_Sql.Execute(cursor_);
   IF Dbms_Sql.Fetch_Rows(cursor_) = 1 THEN
      FOR i in 1 .. columns_.COUNT loop
         Dbms_Sql.Column_Value(cursor_, i, columns_(i).max_value_len);
      END LOOP;
   END IF;
   Dbms_Sql.Close_Cursor(cursor_);
EXCEPTION
   WHEN OTHERS THEN
      IF Dbms_Sql.Is_Open(cursor_) THEN
         Dbms_Sql.Close_Cursor(cursor_);
      END IF;
      RAISE;
END Get_Column_Value_Max_Len___;


FUNCTION Compute_Wide_Line_Len___ (
   columns_ IN Column_List) RETURN NUMBER
IS
   len_ NUMBER := 10;
BEGIN
   FOR i IN 1 .. columns_.COUNT LOOP
      len_ := len_ + length(columns_(i).column_name) + 6 + columns_(i).max_value_len + 4;
   END LOOP;
   RETURN len_;
END Compute_Wide_Line_Len___;


PROCEDURE Compute_Column_Meta_Max_Len___ (
   columns_           IN  Column_List,
   max_name_len_      OUT INTEGER,
   max_data_type_len_ OUT INTEGER)
IS
   name_ INTEGER := 0;
   type_ INTEGER := 0;
BEGIN
   FOR i IN 1 .. columns_.COUNT LOOP
      name_ := greatest(name_, length(columns_(i).column_name));
      type_ := greatest(type_, length(columns_(i).data_type));
   END LOOP;
   max_name_len_      := name_;
   max_data_type_len_ := type_;
END Compute_Column_Meta_Max_Len___;


PROCEDURE Debug_Column_List___ (
   columns_ IN Column_List)
IS
   col_ Column_Desc;
BEGIN
   FOR i IN 1 .. columns_.COUNT LOOP
      col_ := columns_(i);
      Log(1, rpad(col_.column_name, 31) || rpad(col_.data_type, 30) || lpad(col_.max_value_len, 5));
   END LOOP;
   Log;
END Debug_Column_List___;


PROCEDURE Append_Select_Column_List___ (
   sql_                IN OUT NOCOPY VARCHAR2,
   columns_            IN            Column_List,
   format_varchar_     IN            BOOLEAN,
   custom_format_func_ IN            VARCHAR2,
   custom_column_name_ IN            VARCHAR2) IS
BEGIN
   FOR i IN 1 .. columns_.COUNT LOOP
      IF columns_(i).data_type <> 'VARCHAR2' OR format_varchar_ THEN
         sql_ := sql_ || Get_Format_Method_Image___(columns_(i).column_name, custom_format_func_, custom_column_name_) || ', ';
      ELSE
         sql_ := sql_ || lower(columns_(i).column_name) || ', ';
      END IF;
   END LOOP;
   sql_ := sql_ || 'objid, objversion';
END Append_Select_Column_List___;


FUNCTION May_Modify_Existing_Row___ (
   context_ IN Ins_Context) RETURN BOOLEAN IS
BEGIN
   RETURN context_.modify_existing_rows OR context_.modify_row_func IS NOT NULL;
END May_Modify_Existing_Row___;


PROCEDURE Update_Current_Objid_List___ (
   context_ IN OUT NOCOPY Ins_Context) IS
BEGIN
   context_.current_objid_list(context_.current_objid_list.COUNT + 1) := context_.current_objid;
END Update_Current_Objid_List___;


FUNCTION Primary_Key_Sql_Expression___ (
   context_ IN Ins_Context) RETURN VARCHAR2
IS
   sql_ VARCHAR2(32767);
BEGIN
   FOR i IN 1 .. context_.primary_key.COUNT LOOP
      IF i > 1 THEN
         sql_ := sql_ || ' || '', '' || ';
      END if;
      sql_ := sql_ || lower(context_.col_list(context_.primary_key(i)).column_name);
   END LOOP;
   RETURN sql_;
END Primary_Key_Sql_Expression___;


FUNCTION Format_Row_As_One_Line___ (
   column_list_   Column_List,
   value_list_    Value_List,
   ins_procedure_ VARCHAR2) RETURN VARCHAR2
IS
   line_ VARCHAR2(2500);
   col_  Column_Desc;
BEGIN
   FOR i IN 1 .. column_list_.COUNT LOOP
      IF i > 1 THEN
         line_ := line_ || ' , ';
      END IF;
      col_ := column_list_(i);
      line_ := line_ || lower(col_.column_name) || '_ => ' || rpad('''' || value_list_(i) || '''', col_.max_value_len + 2);
   END LOOP;
   RETURN '   ' || ins_procedure_ || '( ' || line_ || ' );';
END Format_Row_As_One_Line___;


FUNCTION Format_Row_As_Many_Lines___ (
   column_list_   Column_List,
   value_list_    Value_List,
   ins_procedure_ VARCHAR2,
   max_name_len_  NUMBER) RETURN VARCHAR2
IS
   line_ VARCHAR2(2500) := '   ' || ins_procedure_ || ' (' || new_line_;
   col_  Column_Desc;
BEGIN
   FOR i IN 1 .. column_list_.COUNT LOOP
      col_ := column_list_(i);
      line_ := line_ || '      ' || rpad(lower(col_.column_name) || '_', max_name_len_ + 1) || ' => ''' || value_list_(i) || '''';
      IF i = column_list_.COUNT THEN
         line_ := line_ || ');';
      ELSE
         line_ := line_ || ',';
      END IF;
      line_ := line_ || new_line_;
   END LOOP;
   RETURN line_;
END Format_Row_As_Many_Lines___;


FUNCTION Convert_Primary_Key_List___ (
   pk_column_list_ IN List,
   columns_        IN Column_List,
   table_name_     IN VARCHAR2) RETURN Pos_List
IS
   name_ VARCHAR2(4000);
   pk_   Pos_List := Pos_List();
   ix_   NUMBER;
BEGIN
   FOR i IN 1 .. pk_column_list_.COUNT LOOP
      name_:= upper(pk_column_list_(i));
      ix_:= Find_Column_Index(name_, columns_);
      IF ix_ = 0 THEN
         Error_SYS.Appl_General(lu_name_, 'NO_COL_IN_TAB: Column :P1 not found in table :P2', name_, table_name_);
      END IF;
      pk_.EXTEND;
      pk_(pk_.COUNT) := ix_;
   END LOOP;
   RETURN pk_;
END Convert_Primary_Key_List___;


FUNCTION Generate_Constructor___ (pk_ Pos_List) RETURN VARCHAR2 IS
   str_ VARCHAR2(4000):= 'Ins_Util_API.Pos_List(';
BEGIN
   FOR i IN 1 .. pk_.COUNT LOOP
      IF i > 1 THEN
         str_ := str_ || ', ';
      END IF;
      str_ := str_ || pk_(i);
   END LOOP;
   RETURN str_ || ')';
END Generate_Constructor___;


PROCEDURE Prepare_Get_Row___ (
   context_ IN OUT NOCOPY Ins_Context)
IS
   sql_   VARCHAR2(32767);
   value_ VARCHAR2(4000);
BEGIN
   sql_ := 'SELECT ';
   IF May_Modify_Existing_Row___(context_) THEN
      Append_Select_Column_List___(sql_, context_.col_list, FALSE, context_.custom_format_func, context_.custom_column_name);
   ELSE
      sql_ := sql_ || 'objid, objversion';
   END IF;
   sql_ := sql_ || new_line_ || '  FROM ' || context_.table_name || new_line_;
   FOR i IN 1 .. context_.primary_key.COUNT LOOP
      IF i = 1 THEN
         sql_ := sql_ || ' WHERE ';
      ELSE
         sql_ := sql_ || '   AND ';
      END IF;
      sql_ := sql_ || lower(context_.col_list(context_.primary_key(i)).column_name) || ' = :' || i || new_line_;
   END LOOP;

   IF context_.debug THEN
      Log('Preparing cursor for ' || context_.table_name);
      Debug_Column_List___ (context_.col_list);
      Spool___(sql_);
   END IF;

   context_.get_cursor := Dbms_Sql.Open_Cursor;
   @ApproveDynamicStatement(2016-05-12,madrse)
   Dbms_Sql.Parse(context_.get_cursor, sql_, Dbms_Sql.NATIVE);

   FOR i IN 1 .. CASE WHEN May_Modify_Existing_Row___(context_) THEN context_.col_list.COUNT + 2 ELSE 2 END LOOP
      Dbms_Sql.Define_Column(context_.get_cursor, i, value_, 4000);
   END LOOP;
END Prepare_Get_Row___;


PROCEDURE Fetch_Row___ (
   context_ IN OUT NOCOPY Ins_Context,
   values_  IN            Value_List,
   result_     OUT        Value_List,
   found_      OUT        BOOLEAN)
IS
   ignore_ INTEGER;
BEGIN
   IF context_.get_cursor IS NULL THEN
      Prepare_Get_Row___(context_);
   END IF;
   IF context_.debug THEN
      Log;
      Log('Fetching row');
   END IF;
   FOR i IN 1 .. context_.primary_key.COUNT LOOP
      IF context_.debug THEN
         Log(1, 'Binding PK column: ' || values_(context_.primary_key(i)));
      END IF;
      CASE context_.col_list(context_.primary_key(i)).data_type
         WHEN 'VARCHAR2' THEN
            Dbms_Sql.Bind_Variable(context_.get_cursor, ':' || i, Parse_Varchar2 (values_(context_.primary_key(i))));
         WHEN 'NUMBER' THEN
            Dbms_Sql.Bind_Variable(context_.get_cursor, ':' || i, Parse_Number   (values_(context_.primary_key(i))));
         WHEN 'DATE' THEN
            Dbms_Sql.Bind_Variable(context_.get_cursor, ':' || i, Parse_Date     (values_(context_.primary_key(i))));
         WHEN 'TIMESTAMP' THEN
            Dbms_Sql.Bind_Variable(context_.get_cursor, ':' || i, Parse_Timestamp(values_(context_.primary_key(i))));
      END CASE;
   END LOOP;

   ignore_ := Dbms_Sql.Execute(context_.get_cursor);
   IF Dbms_Sql.Fetch_Rows(context_.get_cursor) <= 0 THEN
      found_ := FALSE;
      RETURN;
   END IF;

   IF May_Modify_Existing_Row___(context_) THEN
      FOR i in 1 .. context_.col_list.COUNT LOOP
         Dbms_Sql.Column_Value(context_.get_cursor, i, result_(i));
      END LOOP;
      Dbms_Sql.Column_Value(context_.get_cursor, context_.col_list.COUNT + 1, context_.current_objid);
      Dbms_Sql.Column_Value(context_.get_cursor, context_.col_list.COUNT + 2, context_.current_objversion);
   ELSE
      Dbms_Sql.Column_Value(context_.get_cursor, 1, context_.current_objid);
      Dbms_Sql.Column_Value(context_.get_cursor, 2, context_.current_objversion);
   END IF;

   IF context_.debug THEN
      Log('Row fetched: OBJID=' || context_.current_objid || ' OBJVERSION=' || context_.current_objversion);
   END IF;

   IF Dbms_Sql.Fetch_Rows(context_.get_cursor) > 0 THEN
      Error_SYS.Appl_General(lu_name_, 'TOO_MANY_ROWS: To many rows found in table :P1', context_.table_name);
   END IF;
   found_ := TRUE;
END Fetch_Row___;


PROCEDURE Remove___ (
   context_    IN OUT NOCOPY Ins_Context,
   objid_      IN            VARCHAR2,
   objversion_ IN            VARCHAR2)
IS
   stmt_ VARCHAR2(4000) := 'BEGIN ' || context_.lu_package || '.Remove__(:1, :2, :3, ''DO''); END;';
   info_ VARCHAR2(2000);
BEGIN
   IF context_.debug THEN
      Log('Executing statement ' || stmt_);
   END IF;
   @ApproveDynamicStatement(2016-06-14,madrse)
   execute immediate stmt_ using OUT info_, IN objid_, IN objversion_;
END Remove___;


PROCEDURE Modify___ (
   attr_    IN OUT NOCOPY VARCHAR2,
   context_ IN OUT NOCOPY Ins_Context)
IS
   stmt_ VARCHAR2(4000) := 'BEGIN ' || context_.lu_package || '.Modify__(:1, :2, :3, :4,''DO''); END;';
   info_ VARCHAR2(2000);
BEGIN
   IF context_.debug THEN
      Log('Executing statement ' || stmt_);
   END IF;
   @ApproveDynamicStatement(2016-03-07,madrse)
   execute immediate stmt_ using OUT info_, IN context_.current_objid, IN OUT context_.current_objversion, IN OUT attr_;
END Modify___;


PROCEDURE New___ (
   attr_    IN OUT NOCOPY VARCHAR2,
   context_ IN OUT NOCOPY Ins_Context)
IS
   stmt_ VARCHAR2(4000) := 'BEGIN ' || context_.lu_package || '.' || nvl(context_.custom_new_proc, 'New__') || '(:1, :2, :3, :4,''DO''); END;';
   info_ VARCHAR2(2000);
BEGIN
   IF context_.debug THEN
      Log('Executing statement ' || stmt_);
   END IF;
   @ApproveDynamicStatement(2016-03-07,madrse)
   execute immediate stmt_ using OUT info_, OUT context_.current_objid, OUT context_.current_objversion, IN OUT attr_;
END New___;


PROCEDURE Nullify_Lob___ (
   context_ IN OUT NOCOPY Ins_Context)
IS
   stmt_ VARCHAR2(4000) := 'BEGIN ' || context_.lu_package || '.Write_ ' || context_.current_lob_column || '__(:1, :2, NULL); END;';
BEGIN
   IF context_.debug THEN
      Log('Executing statement ' || stmt_);
   END IF;
   @ApproveDynamicStatement(2016-03-07,madrse)
   execute immediate stmt_ using IN OUT context_.current_objversion, IN context_.current_objid;
END Nullify_Lob___;


PROCEDURE Write_Blob___ (
   blob_    IN            BLOB,
   context_ IN OUT NOCOPY Ins_Context)
IS
   stmt_ VARCHAR2(4000) := 'BEGIN ' || context_.lu_package || '.Write_' || context_.current_lob_column || '__(:1, :2, :3); END;';
BEGIN
   IF context_.debug THEN
      Log('Executing statement ' || stmt_);
   END IF;
   @ApproveDynamicStatement(2016-03-15,madrse)
   execute immediate stmt_ using IN OUT context_.current_objversion, IN context_.current_objid, IN blob_;
END Write_Blob___;


FUNCTION Fetch_Blob___ (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2,
   objid_       IN VARCHAR2) RETURN BLOB
IS
   cursor_ SYS_REFCURSOR;
   blob_   BLOB;
BEGIN
   @ApproveDynamicStatement(2016-05-12,madrse)
   OPEN cursor_ FOR 'SELECT ' || column_name_ || ' FROM ' || table_name_ || ' WHERE objid = :1' USING objid_;
   FETCH cursor_ INTO blob_;
   CLOSE cursor_;
   RETURN blob_;
END Fetch_Blob___;


PROCEDURE Spool_Blob___ (blob_ BLOB) IS
   chunk_ CONSTANT NUMBER := 1800; -- Base64 gives 1800*4/3 = 2400 < 2499, which is max input line in SQL*Plus
   len_   NUMBER := Dbms_Lob.GetLength(blob_);
   pos_   NUMBER := 1;
   buf_   RAW(3000);
   txt_   VARCHAR2(3000);
BEGIN
   IF len_ IS NULL THEN
      RETURN;
   END IF;
   WHILE pos_ < len_ LOOP
      buf_ := Dbms_Lob.substr(blob_, chunk_, pos_);
      buf_ := Utl_Encode.Base64_Encode(buf_);
      txt_ := Utl_Raw.Cast_To_Varchar2(buf_);
      txt_ := REPLACE(txt_, chr(10));
      txt_ := REPLACE(txt_, chr(13));
      Spool___('   Ins_Util_API.Append_Blob(''' || txt_ || ''', ctx_);');
      pos_ := pos_ + chunk_;
   END LOOP;
END Spool_Blob___;


PROCEDURE Spool_Text_Blob___ (
   blob_  IN BLOB,
   debug_ IN BOOLEAN)
IS
   PROCEDURE Spool (
      buf_      IN OUT NOCOPY VARCHAR2,
      amount_   IN            NUMBER)
   IS
      spool_  VARCHAR2(2500);
      method_ VARCHAR2(100);
   BEGIN
      IF substr(buf_, amount_, 1) = chr(10) THEN
         method_ := 'Append_Line';
         spool_ := substr(buf_, 1, amount_ - 1);
      ELSE
         method_ := 'Append     ';
         spool_ := substr(buf_, 1, amount_);
      END IF;
      buf_ := substr(buf_, amount_ + 1);
      spool_ := REPLACE(spool_, chr(9), '   ');
      spool_ := REPLACE(spool_, '''', '''''');
      Spool___('   Ins_Util_API.' || method_ || '(''' || spool_ || ''', ctx_);');
   END Spool;

   PROCEDURE Spool_Lines (buf_ IN OUT NOCOPY VARCHAR2, last_chunk_ IN BOOLEAN) IS
      max_line_ NUMBER := 2000; -- tabs are expanded to spaces!
      pos_ NUMBER;
   BEGIN
      buf_ := REPLACE(buf_, chr(13));
      WHILE length(buf_) > 0 LOOP
         pos_ := instr(buf_, chr(10));
         IF pos_ = 0 THEN
            IF length(buf_) > max_line_ THEN
               Spool(buf_, max_line_);
            ELSIF last_chunk_ THEN
               Spool(buf_, length(buf_));
            ELSE
               RETURN; -- keep a part of line in the buffer
            END IF;
         ELSIF pos_ > max_line_ THEN
            Spool(buf_, max_line_);
         ELSE
            Spool(buf_, pos_);
         END IF;
      END LOOP;
   END Spool_Lines;

BEGIN
   DECLARE
      chunk_   NUMBER := 30000; -- < 32K, because we need some extra space for a truncated line
      len_     NUMBER := Dbms_Lob.GetLength(blob_);
      raw_     RAW(30000);
      txt_buf_ VARCHAR2(32767) := '';
      txt_     VARCHAR2(30000);
      offset_  NUMBER := 1;
      amount_  NUMBER := chunk_;
   BEGIN
      IF debug_ THEN
         Log('-- Spooling BLOB of length ' || len_);
      END IF;
      WHILE offset_ <= len_ LOOP
         Dbms_Lob.Read(blob_, amount_, offset_, raw_);
         offset_ := offset_ + amount_;
         txt_ := Utl_Raw.Cast_To_Varchar2(raw_);
         IF debug_ THEN
            Log('-- Chunk of ' || Utl_Raw.Length(raw_) || ' bytes converted into ' || length(txt_) || ' characters');
         END IF;
         txt_buf_ := txt_buf_ || txt_;
         Spool_Lines(txt_buf_, amount_ < chunk_);
      END LOOP;
   END;
END Spool_Text_Blob___;


PROCEDURE Spool_Lobs___ (
   table_name_        IN VARCHAR2,
   lob_list_          IN Column_List,
   current_objid_     IN VARCHAR2,
   is_text_blob_func_ IN VARCHAR2,
   modify_            IN BOOLEAN,
   debug_             IN BOOLEAN)
IS
   FUNCTION Is_Text_Blob (column_name_ VARCHAR2) RETURN BOOLEAN IS
      stmt_ VARCHAR2(2000);
      flag_ VARCHAR2(2000);
   BEGIN
      IF is_text_blob_func_ IS NULL THEN
         RETURN FALSE;
      END IF;
      stmt_ := 'BEGIN :1 := ' || is_text_blob_func_ || '(:2, :3, :4); END;';
      @ApproveDynamicStatement(2016-03-16,madrse)
      execute immediate stmt_ using OUT flag_, IN table_name_, IN column_name_, IN current_objid_;
      IF debug_ THEN
         Log('-- Statement ' || stmt_ || ' returned ' || flag_);
      END IF;
      RETURN flag_ = 'TRUE';
   END Is_Text_Blob;

   PROCEDURE Spool_Blob (column_name_ VARCHAR2) IS
      blob_ BLOB := Fetch_Blob___(table_name_, column_name_, current_objid_);
   BEGIN
      IF blob_ IS NULL THEN
         IF modify_ THEN
            Spool___('   Ins_Util_API.Null_Blob(''' || column_name_  || ''', ctx_);');
         END IF;
      ELSE
         Spool___('   Ins_Util_API.Open_Blob(''' || column_name_  || ''', ctx_);');
         IF Is_Text_Blob(column_name_) THEN
            Spool_Text_Blob___(blob_, debug_);
         ELSE
            Spool_Blob___(blob_);
         END IF;
         Spool___('   Ins_Util_API.Close_Blob(ctx_);');
         Spool___('');
      END IF;
   END Spool_Blob;
BEGIN
   FOR i IN 1 .. lob_list_.COUNT LOOP
      IF lob_list_(i).data_type = 'BLOB' THEN
         Spool_Blob(lob_list_(i).column_name);
      ELSE
         NULL; -- CLOBs are not supported
      END IF;
   END LOOP;
END Spool_Lobs___;


PROCEDURE Call_Modify_Row_Func___ (
   context_         IN OUT NOCOPY Ins_Context,
   modify_row_         OUT BOOLEAN,
   customized_desc_    OUT VARCHAR2)
IS
   stmt_ VARCHAR2(2000);
   flag_ VARCHAR2(5);
BEGIN
   stmt_ := 'BEGIN ' || context_.modify_row_func || '(:1, :2, :3, :4); END;';
   @ApproveDynamicStatement(2016-10-10,madrse)
   execute immediate stmt_ using IN context_.table_name, IN context_.current_objid, OUT flag_, OUT customized_desc_;
   IF context_.debug THEN
      Log('-- Statement ' || stmt_ || ' returned ' || flag_);
   END IF;
   modify_row_ := flag_ = 'TRUE';
END Call_Modify_Row_Func___;


FUNCTION Call_After_Remove_Func___ (
   function_ IN VARCHAR2,
   debug_    IN BOOLEAN) RETURN NUMBER
IS
   stmt_  VARCHAR2(2000);
   count_ NUMBER;
BEGIN
   stmt_ := 'BEGIN :1 := ' || function_ || '; END;';
   @ApproveDynamicStatement(2016-07-28,madrse)
   execute immediate stmt_ using OUT count_;
   IF debug_ THEN
      Log('-- Statement ' || stmt_ || ' removed ' || count_ || ' rows');
   END IF;
   RETURN count_;
END Call_After_Remove_Func___;


PROCEDURE Flush_Blob_Buffer___ (
   context_ IN OUT NOCOPY Ins_Context) IS
BEGIN
   IF context_.current_objid IS NULL THEN
      RETURN; -- row has been skipped
   END IF;
   IF context_.blob_buf IS NOT NULL AND Utl_Raw.Length(context_.blob_buf) > 0 THEN
      IF context_.debug THEN
         Log('-- Flushing BLOB buffer');
      END IF;
      Dbms_Lob.WriteAppend(context_.current_blob, Utl_Raw.Length(context_.blob_buf), context_.blob_buf);
      context_.blob_buf := NULL;
   END IF;
END Flush_Blob_Buffer___;

----------
-- Diff --
----------

PROCEDURE Diff___(name_ IN VARCHAR2, new_value_ IN VARCHAR2, current_value_ IN VARCHAR2, attr_ IN OUT NOCOPY VARCHAR2) IS
BEGIN
   IF (new_value_ IS NULL AND current_value_ IS NULL) OR (new_value_ = current_value_) THEN
      RETURN;
   END IF;
   Client_SYS.Add_To_Attr(name_, new_value_, attr_);
END Diff___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

---------
-- Log --
---------

PROCEDURE Log(indent_ NUMBER, line_ VARCHAR2) IS
BEGIN
   IF indent_ > 0 THEN
      Dbms_Output.Put(lpad(' ', 3 * indent_));
   END IF;
   Dbms_Output.Put_Line(global_indent_ || line_);
END Log;

PROCEDURE Log(line_ VARCHAR2 DEFAULT NULL) IS
BEGIN
   Log(0, line_);
END Log;

----------
-- BLob --
----------

PROCEDURE Null_Blob (
   column_name_ IN            VARCHAR2,
   context_     IN OUT NOCOPY Ins_Context)
IS
   db_blob_  BLOB;
BEGIN
   context_.current_lob_column := column_name_;

   -- fetch DB-version of BLOB
   db_blob_ := Fetch_Blob___(context_.table_name, context_.current_lob_column, context_.current_objid);
   IF context_.debug THEN
      Log('Nullifying BLOB: DB-version of BLOB fetched: length=' || Dbms_Lob.GetLength(db_blob_));
   END IF;

   IF db_blob_ IS NOT NULL THEN
      Nullify_Lob___(context_);
      context_.modified_lobs := context_.modified_lobs + 1;
   ELSE
      context_.unchanged_lobs := context_.unchanged_lobs + 1;
   END IF;
END Null_Blob;


PROCEDURE Open_Blob (
   column_name_ IN            VARCHAR2,
   context_     IN OUT NOCOPY Ins_Context) IS
BEGIN
   IF context_.current_objid IS NULL THEN
      context_.skipped_lobs := context_.skipped_lobs + 1;
      RETURN; -- row has been skipped
   END IF;
   IF context_.debug THEN
      Log('Opening BLOB');
   END IF;
   context_.current_lob_column := column_name_;
   Dbms_Lob.CreateTemporary (context_.current_blob, TRUE, Dbms_Lob.SESSION);
   Dbms_Lob.Open(context_.current_blob, Dbms_Lob.LOB_READWRITE);
END Open_Blob;


PROCEDURE Append_Blob (
   b64_     IN            VARCHAR2,
   context_ IN OUT NOCOPY Ins_Context)
IS
   buf_ RAW(2500);
BEGIN
   IF context_.current_objid IS NULL THEN
      RETURN; -- row has been skipped
   END IF;
   IF context_.debug THEN
      Log('Appending BLOB');
   END IF;
   buf_ := Utl_Raw.Cast_To_Raw(b64_);
   buf_ := Utl_Encode.Base64_Decode(buf_);
   Dbms_Lob.WriteAppend(context_.current_blob, Utl_Raw.Length(buf_), buf_);
END Append_Blob;


PROCEDURE Append (
   txt_     IN            VARCHAR2,
   context_ IN OUT NOCOPY Ins_Context)
IS
   buf_ RAW(32767);
BEGIN
   IF context_.current_objid IS NULL THEN
      RETURN; -- row has been skipped
   END IF;
   IF context_.debug THEN
      Log('-- Appending BLOB text of length ' || length(txt_));
   END IF;
   buf_ := Utl_Raw.Cast_To_Raw(txt_);

   IF context_.blob_buf IS NULL THEN
      context_.blob_buf := buf_;
   ELSE
      IF Utl_Raw.Length(context_.blob_buf) + Utl_Raw.Length(buf_) > 32767 THEN
         Flush_Blob_Buffer___(context_);
         context_.blob_buf := buf_;
      ELSE
         context_.blob_buf := Utl_Raw.Concat(context_.blob_buf, buf_);
      END IF;
   END IF;
END Append;


PROCEDURE Append_Line (
   txt_     IN            VARCHAR2,
   context_ IN OUT NOCOPY Ins_Context) IS
BEGIN
   Append(txt_ || chr(10), context_);
END Append_Line;


PROCEDURE Close_Blob (
   context_ IN OUT NOCOPY Ins_Context)
IS
   ins_blob_ BLOB;
   db_blob_  BLOB;
   compare_  INTEGER;
BEGIN
   IF context_.current_objid IS NULL THEN
      RETURN; -- row has been skipped
   END IF;
   Flush_Blob_Buffer___(context_);
   IF context_.debug THEN
      Log('Closing BLOB');
   END IF;
   Dbms_Lob.Close(context_.current_blob);

   -- current_blob contains INS-version of BLOB
   ins_blob_ := context_.current_blob;
   Dbms_Lob.FreeTemporary(context_.current_blob);
   IF context_.debug THEN
      Log('INS-version of BLOB created: length=' || Dbms_Lob.GetLength(ins_blob_));
   END IF;

   -- fetch DB-version of BLOB
   db_blob_ := Fetch_Blob___(context_.table_name, context_.current_lob_column, context_.current_objid);
   IF context_.debug THEN
      Log('DB-version of BLOB fetched: length=' || Dbms_Lob.GetLength(db_blob_));
   END IF;

   compare_ := Dbms_Lob.Compare(ins_blob_, db_blob_);
   IF context_.debug THEN
      Log('Compare(INS, DB) = ' || compare_);
   END IF;

   IF compare_ = 0 THEN
      context_.unchanged_lobs := context_.unchanged_lobs + 1;
   ELSE
      Write_Blob___(ins_blob_, context_);
      context_.modified_lobs := context_.modified_lobs + 1;
   END IF;
END Close_Blob;

--------------
-- Generate --
--------------

FUNCTION Find_Column_Index (
   column_name_ IN VARCHAR2,
   columns_     IN Column_List) RETURN BINARY_INTEGER IS
BEGIN
   FOR i IN 1 .. columns_.COUNT LOOP
      IF column_name_ = columns_(i).column_name THEN
         RETURN i;
      END IF;
   END LOOP;
   RETURN 0;
END Find_Column_Index;


FUNCTION To_Base64 (txt_ IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   IF txt_ IS NULL THEN
      RETURN NULL;
   ELSE
      RETURN REPLACE(REPLACE(Utl_Raw.Cast_To_Varchar2(Utl_Encode.Base64_Encode(Utl_Raw.Cast_To_Raw(txt_))),CHR(10)),CHR(13));
   END IF;
END To_Base64;


FUNCTION From_Base64 (txt_ IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   IF txt_ IS NULL THEN
      RETURN NULL;
   ELSE
      RETURN Utl_Raw.Cast_To_Varchar2(Utl_Encode.Base64_Decode(Utl_Raw.Cast_To_Raw(txt_)));
   END IF;
END From_Base64;


FUNCTION Format (value_ VARCHAR2) RETURN VARCHAR2 IS
   v_ VARCHAR2(4000) := value_;
BEGIN
   v_ := replace(v_, '''', '''''');
   v_ := replace(v_, chr(13));
   v_ := replace(v_, chr(10), ''' || chr(10) || ''');
   v_ := replace(v_, chr(9), ''' || chr(9) || ''');
   v_ := replace(v_, ' || '''' || ', ' || ');
   RETURN v_;
END Format;


FUNCTION Format (value_ NUMBER) RETURN VARCHAR2 IS
BEGIN
   RETURN to_char(value_);
END Format;


FUNCTION Format (value_ DATE) RETURN VARCHAR2 IS
BEGIN
   RETURN to_char(value_, date_format_);
END Format;


FUNCTION Format (value_ TIMESTAMP) RETURN VARCHAR2 IS
BEGIN
   RETURN to_char(value_, timestamp_format_);
END Format;


FUNCTION Parse_Varchar2 (value_ VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN value_;
END Parse_Varchar2;


FUNCTION Parse_Number (value_ VARCHAR2) RETURN NUMBER IS
BEGIN
   RETURN to_number(value_);
END Parse_Number;


FUNCTION Parse_Date (value_ VARCHAR2) RETURN DATE IS
BEGIN
   RETURN to_date(value_, date_format_);
END Parse_Date;


FUNCTION Parse_Timestamp (value_ VARCHAR2) RETURN TIMESTAMP IS
BEGIN
   RETURN to_timestamp(value_, timestamp_format_);
END Parse_Timestamp;


FUNCTION Column_Ordering (
   column_name_     VARCHAR2,
   ordered_columns_ VARCHAR2) RETURN VARCHAR2
IS
   pos_ NUMBER := instr(ordered_columns_, ',' || column_name_ || ',');
BEGIN
   IF pos_ > 0 THEN
      RETURN lpad(to_char(pos_), 5, '0');
   ELSE
      RETURN column_name_;
   END IF;
END Column_Ordering;


PROCEDURE Spool_Ins_File_Header (
   component_ IN VARCHAR2,
   file_name_ IN VARCHAR2,
   purpose_   IN VARCHAR2) IS
BEGIN
   IF component_ IS NOT NULL THEN
      Spool___('--');
      Spool___('-- Component: ' || component_);
   END IF;
   IF file_name_ IS NOT NULL THEN
      Spool___('--');
      Spool___('-- File:      ' || file_name_);
   END IF;
   Spool___('--');
   Spool___('-- Purpose:   ' || purpose_);
   Spool___('--');
   Spool___('SET SERVEROUTPUT ON FORMAT WRAPPED');
   Spool___('SET DEFINE OFF');
END Spool_Ins_File_Header;


PROCEDURE Spool_Ins_File_Footer IS
BEGIN
   Spool___('COMMIT');
   Spool___('/');
   Spool___;
   Spool___('SET DEFINE &');
   Spool___;
END Spool_Ins_File_Footer;


PROCEDURE Generate_Ins_File (
   table_name_          VARCHAR2,               -- View name
   pk_column_list_      List,                   -- Pprimary key columns
   where_               VARCHAR2 DEFAULT NULL,  -- Optional WHERE clause
   order_by_            VARCHAR2 DEFAULT NULL,  -- Defaults to pk_column_list_
   lu_package_          VARCHAR2 DEFAULT NULL,  -- Defaults to <table_name_>_API
   ordered_column_list_ VARCHAR2 DEFAULT NULL,  -- Defaults to pk_column_list_
   skip_column_list_    List     DEFAULT NULL,  -- Columns to ignore
   custom_new_proc_     VARCHAR2 DEFAULT NULL,  -- Custom procedure, in lu_package, called instead of New__
   is_text_blob_func_   VARCHAR2 DEFAULT NULL,  -- If specified and if returns 'TRUE' then the BLOB will be stored in INS file as text, otherwise as Base64
   recreate_row_func_   VARCHAR2 DEFAULT NULL,  -- IGNORED, replaced with synchronization mode controlled by calls to modify_row_func_ during execution of INS file
   modify_row_func_     VARCHAR2 DEFAULT NULL,  -- If null existing rows will be skipped. Otherwise returns description of a customized row, or null to synchronize the row.
   custom_format_func_  VARCHAR2 DEFAULT NULL,  -- If specified will be used instead of Ins_Util_API.Format(custom_column_name_)
   custom_column_name_  VARCHAR2 DEFAULT NULL,  -- Column to call custom_format_func_ on
   before_ins_row_proc_ VARCHAR2 DEFAULT NULL,  -- If specified will be called before Ins_Util_API.Ins_Row in generated INS file
   modify_              BOOLEAN  DEFAULT FALSE, -- If TRUE synchronize existing rows, otherwise modify_row_func_, if specified, will decide at runtime
   remove_              BOOLEAN  DEFAULT FALSE, -- If TRUE and if modify_ is TRUE then remove obsolete rows (rows not found in INS file)
   after_remove_func_   VARCHAR2 DEFAULT NULL,  -- If specified, and if remove_ is TRUE, will be called after removing obsolete rows (returns number of removed detail rows)
   wide_format_         BOOLEAN  DEFAULT TRUE,  -- If TRUE and if possible, generate long lines, up to 2499 characters, otherwise one column value per line
   debug_               BOOLEAN  DEFAULT FALSE) -- Debug flag used during generation and execution of INS file
IS
   cursor_ INTEGER;
   sql_    VARCHAR2(32767);
   value_  VARCHAR2(4000);
   ignore_ INTEGER;
   line_   VARCHAR2(2500);

   col_list_ Column_List;
   lob_list_ Column_List;
   pk_       Pos_List;
   values_   Value_List;

   max_name_len_          NUMBER;
   max_data_type_len_     NUMBER;
   max_lob_name_len_      NUMBER;
   max_lob_data_type_len_ NUMBER;
   wide_format_line_len_  NUMBER;

   current_objid_         VARCHAR2(100);
   current_objversion_    VARCHAR2(2000);

   order_by_pk_       VARCHAR2(32767) := Format_Order_By___(pk_column_list_);
   ordered_columns_   VARCHAR2(32767) := upper(nvl(ordered_column_list_, order_by_pk_));
   procedure_         VARCHAR2(100) := 'Ins';
   lu_package_name_   VARCHAR2(100) := upper(nvl(lu_package_, table_name_ || '_API'));
BEGIN
   ordered_columns_ :=  ',' || replace(ordered_columns_, ' ') || ',';
   Get_Column_List___ (table_name_, skip_column_list_, ordered_columns_, col_list_, lob_list_);
   pk_:= Convert_Primary_Key_List___ (pk_column_list_, col_list_, table_name_);

   IF debug_ THEN
      Spool___;
      Spool___('/*');
   END IF;

   Get_Column_Value_Max_Len___(col_list_, table_name_, where_, debug_, custom_format_func_, custom_column_name_);

   IF debug_ THEN
      Log('Preparing query from ' || upper(table_name_));
      Debug_Column_List___(col_list_);
      Debug_Column_List___(lob_list_);
   END IF;

   sql_ := 'SELECT ';
   Append_Select_Column_List___(sql_, col_list_, TRUE, custom_format_func_, custom_column_name_);
   sql_ := sql_ || new_line_ || '  FROM ' || table_name_ || new_line_;

   IF where_ IS NOT NULL THEN
      sql_ := sql_ || ' WHERE ' || where_ || new_line_;
   END IF;

   sql_ := sql_ || ' ORDER BY ' || nvl(order_by_, order_by_pk_);

   wide_format_line_len_ := Compute_Wide_Line_Len___(col_list_);

   IF debug_ THEN
      Spool___(sql_);
      Log;
      Log('wide_format_line_len_ = ' || wide_format_line_len_);
      Log;
      Spool___('*/');
   END IF;

   cursor_ := Dbms_Sql.Open_Cursor;
   @ApproveDynamicStatement(2016-05-12,madrse)
   Dbms_Sql.Parse(cursor_, sql_, Dbms_Sql.NATIVE);

   FOR i IN 1 .. col_list_.COUNT + 2 LOOP
      Dbms_Sql.Define_Column(cursor_, i, value_, 4000);
   END LOOP;

   Compute_Column_Meta_Max_Len___(col_list_, max_name_len_    , max_data_type_len_);
   Compute_Column_Meta_Max_Len___(lob_list_, max_lob_name_len_, max_lob_data_type_len_);

   Spool___;
   Spool___('DECLARE');
   Spool___('   ctx_ Ins_Util_API.Ins_Context;');
   Spool___;
   Spool___('   PROCEDURE Init IS');
   Spool___('   BEGIN');
   Spool___('      Ins_Util_API.Set_Debug(' || CASE debug_ WHEN TRUE THEN 'TRUE' ELSE 'FALSE' END || ', ctx_);');
   IF modify_ THEN
      Spool___('      Ins_Util_API.Modify_Existing_Rows(ctx_);');
   END IF;
   Spool___('      Ins_Util_API.Set_Lu_Package(''' || lu_package_name_ || ''', ctx_);');
   IF custom_new_proc_ IS NOT NULL THEN
      Spool___('      Ins_Util_API.Set_Custom_New_Procedure(''' || custom_new_proc_ || ''', ctx_);');
   END IF;
   Spool___('      Ins_Util_API.Set_Table(''' || upper(table_name_) || ''', ctx_);');
   FOR i IN 1 .. col_list_.COUNT LOOP
      Spool___('      Ins_Util_API.Add_Column(''' || rpad(col_list_(i).column_name || '''', max_name_len_ + 2) ||
                                           ', ''' || rpad(col_list_(i).data_type   || '''', max_data_type_len_ + 2) || ', ctx_);');
   END LOOP;
   Spool___('      Ins_Util_API.Set_Primary_Key(' || Generate_Constructor___(pk_) || ', ctx_);');
   FOR i IN 1 .. lob_list_.COUNT LOOP
      Spool___('      Ins_Util_API.Add_Lob_Column(''' || rpad(lob_list_(i).column_name || '''', max_lob_name_len_ + 2) ||
                                               ', ''' || rpad(lob_list_(i).data_type   || '''', max_lob_data_type_len_ + 2) || ', ctx_);');
   END LOOP;

   IF custom_format_func_ IS NOT NULL AND custom_column_name_ IS NOT NULL THEN
      Spool___('      Ins_Util_API.Set_Custom_Format_Function(''' || custom_format_func_ || ''', ''' || custom_column_name_ || ''', ctx_);');
   END IF;

   IF after_remove_func_ IS NOT NULL THEN
      Spool___('      Ins_Util_API.Set_After_Remove_Function(''' || after_remove_func_ || ''', ctx_);');
   END IF;

   IF modify_row_func_ IS NOT NULL THEN
      Spool___('      Ins_Util_API.Set_Modify_Row_Function(''' || modify_row_func_ || ''', ctx_);');
   END IF;

   Spool___('   END Init;');
   Spool___;
   Spool___('   PROCEDURE Ins (');
   Spool___('      ' || rpad('recreate$', max_name_len_ + 1) || ' IN BOOLEAN DEFAULT FALSE,');

   FOR i IN 1 .. col_list_.COUNT LOOP
      line_ := '      ' || rpad(lower(col_list_(i).column_name) || '_', max_name_len_ + 1) || ' IN VARCHAR2';
      IF i < col_list_.COUNT THEN
         line_ := line_ || ',';
      ELSE
         line_ := line_ || ')';
      END IF;
      Spool___(line_);
   END LOOP;

   Spool___('   IS');
   Spool___('      values_ Ins_Util_API.Value_List;');
   Spool___('   BEGIN');
   FOR i IN 1 .. col_list_.COUNT LOOP
      Spool___('      values_(' || i || ') := ' || lower(col_list_(i).column_name) || '_;');
   END LOOP;
   IF before_ins_row_proc_ IS NOT NULL THEN
      Spool___('      ' || before_ins_row_proc_ || '(values_, ctx_.col_list);');
   END IF;
   Spool___('      Ins_Util_API.Ins_Row(values_, recreate$, ctx_);');
   Spool___('   END Ins;');
   Spool___;
   Spool___('BEGIN');
   Spool___('   Init;');

   ignore_ := Dbms_Sql.Execute(cursor_);
   LOOP
      EXIT WHEN Dbms_Sql.Fetch_Rows(cursor_) <= 0;
      FOR i in 1 .. col_list_.COUNT loop
         Dbms_Sql.Column_Value(cursor_, i, values_(i));
      END LOOP;
      Dbms_Sql.Column_Value(cursor_, col_list_.COUNT + 1, current_objid_);
      Dbms_Sql.Column_Value(cursor_, col_list_.COUNT + 2, current_objversion_);  --> not needed!

      IF current_objid_ IS NULL THEN -- A view, like config_parameter, may return an outer joined row, while there is no
         CONTINUE;                   -- persistent row in the corresponding table (fndcn_config_param_tab)
      END IF;

      IF wide_format_ AND wide_format_line_len_ < 2500 THEN
         line_ := Format_Row_As_One_Line___(col_list_, values_, procedure_);
      ELSE
         line_ := Format_Row_As_Many_Lines___(col_list_, values_, procedure_, max_name_len_);
      END IF;
      Spool___(line_);

      Spool_Lobs___(table_name_, lob_list_, current_objid_, is_text_blob_func_, modify_, debug_);

   END LOOP;
   IF modify_ AND remove_ THEN
      Spool___('   Ins_Util_API.Remove_Obsolete_Rows(''' || replace(where_, '''', '''''') || ''', ctx_);');
   END IF;
   Spool___('   Ins_Util_API.Summary(ctx_);');
   Spool___('   Ins_Util_API.Close(ctx_);');
   Spool___('EXCEPTION');
   Spool___('   WHEN OTHERS THEN');
   Spool___('      Ins_Util_API.Close(ctx_);');
   Spool___('      RAISE;');
   Spool___('END;');
   Spool___('/');
   Spool___;

   Dbms_Sql.Close_Cursor(cursor_);
EXCEPTION
   WHEN OTHERS THEN
      IF Dbms_Sql.Is_Open(cursor_) THEN
         Dbms_Sql.Close_Cursor(cursor_);
      END IF;
      RAISE;
END Generate_Ins_File;


PROCEDURE Clear_Ins_Output IS
BEGIN
   IF Dbms_Lob.IsTemporary(ins_content_) = 1 THEN
      Dbms_Lob.FreeTemporary(ins_content_);
   END IF;
   ins_content_ := NULL;
END Clear_Ins_Output;


PROCEDURE Begin_Ins_Output IS
BEGIN
   Clear_Ins_Output;
   Dbms_Lob.CreateTemporary(ins_content_, TRUE, Dbms_Lob.CALL);
   Dbms_Lob.Open(ins_content_, Dbms_Lob.LOB_READWRITE);
END Begin_Ins_Output;


PROCEDURE End_Ins_Output (
   blob_ OUT NOCOPY BLOB) IS
BEGIN
   Dbms_Lob.Close(ins_content_);
   blob_ := ins_content_;
   Clear_Ins_Output;
END End_Ins_Output;

---------
-- Ins --
---------

PROCEDURE Set_Lu_Package (
   lu_package_ IN            VARCHAR2,
   context_    IN OUT NOCOPY Ins_Context) IS
BEGIN
   context_.lu_package := lu_package_;
END Set_Lu_Package;


PROCEDURE Set_Custom_New_Procedure (
   custom_new_proc_ IN            VARCHAR2,
   context_         IN OUT NOCOPY Ins_Context) IS
BEGIN
   context_.custom_new_proc := custom_new_proc_;
END Set_Custom_New_Procedure;


PROCEDURE Set_Table (
   table_name_ IN            VARCHAR2,
   context_    IN OUT NOCOPY Ins_Context) IS
BEGIN
   context_.table_name := table_name_;
END Set_Table;


PROCEDURE Add_Column (
   column_name_ IN            VARCHAR2,
   data_type_   IN            VARCHAR2,
   context_     IN OUT NOCOPY Ins_Context)
IS
   col_ Column_Desc;
BEGIN
   col_.column_name := column_name_;
   col_.data_type   := data_type_;
   context_.col_list(context_.col_list.COUNT + 1) := col_;
END Add_Column;


PROCEDURE Set_Primary_Key (
   primary_key_ IN            Pos_List,
   context_     IN OUT NOCOPY Ins_Context) IS
BEGIN
   context_.primary_key := primary_key_;
END Set_Primary_Key;


PROCEDURE Add_Lob_Column (
   column_name_ IN            VARCHAR2,
   data_type_   IN            VARCHAR2,
   context_     IN OUT NOCOPY Ins_Context)
IS
   col_ Column_Desc;
BEGIN
   col_.column_name := column_name_;
   col_.data_type   := data_type_;
   context_.lob_list(context_.lob_list.COUNT + 1) := col_;
END Add_Lob_Column;


PROCEDURE Modify_Existing_Rows (
   context_ IN OUT NOCOPY Ins_Context) IS
BEGIN
   context_.modify_existing_rows := TRUE;
END Modify_Existing_Rows;


PROCEDURE Set_Debug (
   flag_    IN            BOOLEAN,
   context_ IN OUT NOCOPY Ins_Context) IS
BEGIN
   context_.debug := flag_;
END Set_Debug;


PROCEDURE Set_Custom_Format_Function (
   custom_format_func_ IN            VARCHAR2,
   custom_column_name_ IN            VARCHAR2,
   context_            IN OUT NOCOPY Ins_Context) IS
BEGIN
   context_.custom_format_func := custom_format_func_;
   context_.custom_column_name := custom_column_name_;
END Set_Custom_Format_Function;


PROCEDURE Set_Modify_Row_Function (
   modify_row_func_ IN            VARCHAR2,
   context_         IN OUT NOCOPY Ins_Context) IS
BEGIN
   context_.modify_row_func := modify_row_func_;
END Set_Modify_Row_Function;


PROCEDURE Set_After_Remove_Function (
   after_remove_func_ IN            VARCHAR2,
   context_           IN OUT NOCOPY Ins_Context) IS
BEGIN
   context_.after_remove_func := after_remove_func_;
END Set_After_Remove_Function;


PROCEDURE Ins_Row (
   ins_values_ IN            Value_List,
   context_    IN OUT NOCOPY Ins_Context) IS
BEGIN
   Ins_Row(ins_values_, FALSE, context_);
END Ins_Row;


PROCEDURE Ins_Row (
   ins_values_ IN            Value_List,
   recreate_   IN            BOOLEAN,
   context_    IN OUT NOCOPY Ins_Context)
IS
   db_values_           Value_List;
   found_               BOOLEAN;
   attr_                VARCHAR2(32767);
   modify_row_          BOOLEAN;
   customized_row_desc_ VARCHAR2(2000);
   customized_          NUMBER;
BEGIN
   --
   -- Check if row is valid (if the first primary key column is not null)
   --
   IF ins_values_(context_.primary_key(1)) IS NULL THEN
      context_.skipped_invalid := context_.skipped_invalid + 1;
      RETURN;
   END IF;

   Fetch_Row___ (context_, ins_values_, db_values_, found_);

   IF found_ AND context_.current_objid IS NOT NULL AND recreate_ THEN
      Remove___(context_, context_.current_objid, context_.current_objversion);
      found_ := FALSE;
   END IF;

   IF found_ AND context_.current_objid IS NOT NULL THEN
      IF context_.modify_existing_rows THEN
         modify_row_ := TRUE;
      ELSIF context_.modify_row_func IS NULL THEN
         modify_row_ := FALSE;
      ELSE
         Call_Modify_Row_Func___(context_, modify_row_, customized_row_desc_);
      END IF;
   END IF;

   IF modify_row_ AND upper(context_.table_name) = 'ROUTE_CONDITION' THEN
      --
      -- Special handling for routing rules:
      -- When routing rule is to be updated then remove the rule (with all its details)
      -- to force recreation of the whole master/detail structure.
      --
      Remove___(context_, context_.current_objid, context_.current_objversion);
      found_ := FALSE;
   END IF;

   Client_SYS.Clear_Attr(attr_);
   IF found_ AND context_.current_objid IS NOT NULL THEN
      IF modify_row_ THEN
         FOR i IN 1 .. context_.col_list.COUNT LOOP
            Diff___(context_.col_list(i).column_name, ins_values_(i), db_values_(i), attr_);
         END LOOP;

         IF attr_ IS NOT NULL THEN
            IF context_.debug THEN
               Log(1, 'Modifying ' || context_.table_name || ' with [' || attr_ || ']');
            END IF;
            Modify___(attr_, context_);
            context_.modified := context_.modified + 1;
         ELSE
            IF context_.debug THEN
               Log(1, 'Unchanged ' || context_.table_name);
            END IF;
            context_.unchanged := context_.unchanged + 1;
         END IF;
         Update_Current_Objid_List___(context_);
      ELSE
         IF context_.debug THEN
            Log(1, 'Skipped ' || context_.table_name);
         END IF;
         context_.current_objid := NULL;
         context_.current_objversion := NULL;
         IF customized_row_desc_ IS NOT NULL THEN
            Log(1, 'WARNING! Skipped customized ' || context_.table_name || ' row: ' || customized_row_desc_);
            context_.skipped_customized := context_.skipped_customized + 1;
         ELSE
            context_.skipped := context_.skipped + 1;
         END IF;
      END IF;
   ELSE
      --
      -- Special handling for routing rules:
      -- Skip creation of new detail rows if master row (ROUTE_CONDITION) is customized.
      -- 
      -- TODO : Need to fill the new Aurena entities with initial data
      --
--      IF (Installation_SYS.Table_Exist('FNDCN_ROUTE_CONDITION_TAB') AND 
--         upper(context_.table_name) IN ('CONDITION_PART', 'ROUTE_ADDRESS_REFERENCE')) THEN
--            SELECT customized, 'Routing rule ' || description
--              INTO customized_, customized_row_desc_
--           FROM fndcn_route_condition_tab
--           WHERE condition_id = ins_values_(1)--;
--         END IF;

      IF customized_ = 1 THEN
         IF context_.debug THEN
            Log(1, 'Skipped ' || context_.table_name);
         END IF;
         context_.current_objid := NULL;
         context_.current_objversion := NULL;
         Log(1, 'WARNING! Skipped customized ' || context_.table_name || ' row: ' || customized_row_desc_);
         context_.skipped_customized := context_.skipped_customized + 1;
      ELSE
         FOR i IN 1 .. context_.col_list.COUNT LOOP
            Client_SYS.Add_To_Attr(context_.col_list(i).column_name, ins_values_(i), attr_);
         END LOOP;
         IF context_.debug THEN
            Log(1, 'Creating new ' || context_.table_name);
         END IF;
         New___(attr_, context_);
         IF context_.modify_existing_rows THEN
            Update_Current_Objid_List___(context_);
         END IF;
         context_.created := context_.created + 1;
      END IF;
   END IF;
   IF context_.debug THEN
      Log;
   END IF;
END Ins_Row;


PROCEDURE Remove_Obsolete_Rows (
   where_   IN            VARCHAR2,
   context_ IN OUT NOCOPY Ins_Context)
IS
   list_size_  NUMBER := context_.current_objid_list.COUNT;
   list_       VARCHAR2(32767) := '';
   sql_        VARCHAR2(32767);
   cursor_     SYS_REFCURSOR;
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(2000);
   pk_         VARCHAR2(4000);
   count_      NUMBER;
BEGIN
   FOR i IN 1 .. list_size_ LOOP
      list_ := list_ || '''' || context_.current_objid_list(i) || '''';
      IF i < list_size_ THEN
         list_ := list_ || ',' || new_line_ || '   ';
      END IF;
   END LOOP;
   sql_ := 'SELECT objid, objversion, ' || Primary_Key_Sql_Expression___(context_) || ' pk' || new_line_ ||
           '  FROM ' || context_.table_name || new_line_ ||
           ' WHERE objid NOT IN' || new_line_ || '  (' || list_ || ')';
   IF where_ IS NOT NULL THEN
      sql_ := sql_ || new_line_ || '  AND ' || where_;
   END IF;

   IF context_.debug THEN
      Log;
      Log('Removing obsolete rows:');
      Log;
      Spool___(sql_);
   END IF;

   @ApproveDynamicStatement(2016-06-17,madrse)
   OPEN cursor_ FOR sql_;
   LOOP
      FETCH cursor_ INTO objid_, objversion_, pk_;
      EXIT WHEN cursor_%NOTFOUND;
      Log('Removing ' || context_.table_name || ' row: ' || pk_);
      Remove___(context_, objid_, objversion_);
      context_.removed := context_.removed + 1;
   END LOOP;
   CLOSE cursor_;

   IF context_.after_remove_func IS NOT NULL THEN
      count_ := Call_After_Remove_Func___(context_.after_remove_func, context_.debug);
      context_.removed_details := context_.removed_details + count_;
   END IF;
END Remove_Obsolete_Rows;


PROCEDURE Summary (
   context_ IN Ins_Context) IS
BEGIN
   Log;
   IF May_Modify_Existing_Row___(context_) THEN
      Log('Finished synchronization of ' || context_.table_name || ' rows:');
      Log(1, 'Created:            ' || lpad(context_.created,            9));
      Log(1, 'Modified:           ' || lpad(context_.modified,           9));
      Log(1, 'Unchanged:          ' || lpad(context_.unchanged,          9));
      Log(1, 'Skipped:            ' || lpad(context_.skipped,            9));
      Log(1, 'Skipped customized: ' || lpad(context_.skipped_customized, 9));
      Log(1, 'Skipped invalid:    ' || lpad(context_.skipped_invalid,    9));
      Log(1, 'Removed:            ' || lpad(context_.removed,            9));
      IF context_.after_remove_func IS NOT NULL THEN
         Log(1, 'Removed details:    ' || lpad(context_.removed_details, 9));
      END IF;
      Log('Synchronized LOBs:');
      Log(1, 'Modified:           ' || lpad(context_.modified_lobs,  9));
      Log(1, 'Unchanged:          ' || lpad(context_.unchanged_lobs, 9));
      Log(1, 'Skipped:            ' || lpad(context_.skipped_lobs,   9));
   ELSE
      Log('Finished insertion of ' || context_.table_name || ' rows:');
      Log(1, 'Created:            ' || lpad(context_.created,         9));
      Log(1, 'Skipped:            ' || lpad(context_.skipped,         9));
      Log(1, 'Skipped invalid:    ' || lpad(context_.skipped_invalid, 9));
      Log('Updated LOBs:');
      Log(1, 'Created:            ' || lpad(context_.modified_lobs, 9));
      Log(1, 'Skipped:            ' || lpad(context_.skipped_lobs,  9));
   END IF;
   Log;
END Summary;


PROCEDURE Close (
   context_ IN OUT NOCOPY Ins_Context) IS
BEGIN
   IF Dbms_Sql.Is_Open(context_.get_cursor) THEN
      Dbms_Sql.Close_Cursor(context_.get_cursor);
   END IF;
   IF Dbms_Lob.IsTemporary(context_.current_blob) = 1 THEN
      Dbms_Lob.FreeTemporary(context_.current_blob);
   END IF;
END Close;

---------
-- Sql --
---------

PROCEDURE Add_Or_Condition (
   column_name_ IN     VARCHAR2,
   value_list_  IN     List,
   sql_         IN OUT VARCHAR2,
   multiline_   IN     BOOLEAN DEFAULT TRUE) IS
BEGIN
   IF sql_ IS NOT NULL THEN
      sql_ := sql_ || new_line_ || '    OR ';
   END IF;
   sql_ := sql_ || column_name_ || ' IN (';
   FOR i IN 1 .. value_list_.COUNT LOOP
      IF i > 1 THEN
         sql_ := sql_ || ', ';
      END IF;
      IF multiline_ THEN
         sql_ := sql_ || new_line_ || chr(9);
      END IF;
      sql_ := sql_ || '''' || value_list_(i) || '''';
   END LOOP;
   sql_ := sql_ || ')';
END Add_Or_Condition;


PROCEDURE Add_Or_Condition (
   master_column_name_ IN     VARCHAR2,
   master_value_       IN     VARCHAR2,
   detail_column_name_ IN     VARCHAR2,
   detail_value_list_  IN     List,
   sql_                IN OUT VARCHAR2,
   multiline_          IN     BOOLEAN DEFAULT TRUE) IS
BEGIN
   IF sql_ IS NOT NULL THEN
      sql_ := sql_ || new_line_ || '    OR ';
   END IF;
   sql_ := sql_ || master_column_name_;
   IF instr(master_value_, '%') > 0 THEN
      sql_ := sql_ || ' LIKE ';
   ELSE
      sql_ := sql_ || ' = ';
   END IF;
   sql_ := sql_ || '''' || master_value_ || '''';
   sql_ := sql_ || ' AND ' || detail_column_name_ || ' IN (';
   FOR i IN 1 .. detail_value_list_.COUNT LOOP
      IF i > 1 THEN
         sql_ := sql_ || ', ';
      END IF;
      IF multiline_ THEN
         sql_ := sql_ || new_line_ || chr(9);
      END IF;
      sql_ := sql_ || '''' || detail_value_list_(i) || '''';
   END LOOP;
   sql_ := sql_ || ')';
END Add_Or_Condition;

