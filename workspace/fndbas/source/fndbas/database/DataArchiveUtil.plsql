-----------------------------------------------------------------------------
--
--  Logical unit: DataArchiveUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130820          Automatically refactored by Developer Studio
--  000301  HAAR    Created
--  000419  HAAR    Changed Process_Restore from protected method 
--                  to public method.
--                  Moved Drop_Package to package Data_Archive_Object_API.
--  000502  HAAR    Splitted Write_Log___ to Write_Log_Start___ and Write_Log_End___.
--  010419  HAAR    Removed FOR UPDATE OF next_date in Get_Order cursor in Process_Archive_,
--                  since this is not working in Oracle 8.1.7.
--  010507  HAAR    ToDo#4008 - Added view Data_Archive_Restore.
--  020703  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021209  ROOD    Modifications in Get_Template___ (Bug#34558).
--  030127  HAAR    Moved all registration of events to a separate file (ToDo#4205).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030218  ROOD    Changed hardcoded FNDSER to FNDBAS (ToDo#4149).
--  040116  BAMALK  Added validation to check the length of key field name in Create_Move_Object___ 
--                  and Get_Primary_Key_Where_Var___ (Bug#41482).
--  040407  HAAR    Unicode bulk changes, 
--                  extended define variable length in Execute_Stmt_Rowid_File___ (F1PR408B).
--  040331  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  041031  HAAR    Unicode changes for UTL_FILE (F1PR408C).
--  050225  JORA    Added assert evaluations to prevent SQL Injection (F1PR481).
--  060105  UTGULK  Annotated Sql injection.
--  060526  HAAR    Annotated Sql injection.
--  110324  JHMASE  Bug #96386 - Extended counter_ in generated package to make room for 1000 columns in a table.
--  110328  JHMASE  Bug #96407 - Extended counter_ in generated package to make room for 1000 columns in a table.
--                  Columns i SQL-scripts are named Col<character><seq_no) (ColA001, ColA002, ...)
--                  instead of Col<character>[<character>[...]] (ColA, ColAA, ColAAA, ...)
--  110510  JHMASE  Bug #97039 - Added linebreaks to select list in SQL-scripts
--  150109  AJSALK  Bug #120488 - Added new formatting to Format_Select___ , Format_Insert___ and Format_Delete___
--                  Added new method Format_Item_List___ to avoid them getting too long
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Rowid_Array_Type IS TABLE OF ROWID INDEX BY BINARY_INTEGER;

TYPE Msg_Array_Type IS TABLE OF VARCHAR2(32000) INDEX BY BINARY_INTEGER;

TYPE Table_Type IS TABLE OF VARCHAR2(32000) INDEX BY BINARY_INTEGER;

TYPE arc_type IS RECORD (
      data_archive_order_id_           Data_Archive_Order_Tab.order_id%TYPE,
      data_archive_db_link_            Data_Archive_Object_Tab.db_link%TYPE,
      data_archive_destination_        Data_Archive_Object_Tab.data_archive_destination%TYPE, --Oracle Table, SQL-file, None
      data_archive_destination_dir_    Data_Archive_Object_Tab.destination_dir%TYPE,
      data_archive_aoid_               Data_Archive_Object_Tab.aoid%TYPE,
      data_archive_transaction_size_   Data_Archive_Object_Tab.transaction_size%TYPE,
      data_archive_type_               Data_Archive_Source_Tab.data_archive_type%TYPE, -- Move, Copy, Remove, None
      data_archive_package_            Data_Archive_Object_Tab.archive_package%TYPE,
      data_archive_exec_id_            Data_Archive_Order_Exec_Tab.exec_id%TYPE,
      data_archive_seq_no_             Data_Archive_Order_Exec_Tab.seq_no%TYPE,
      data_archive_date_               DATE,
      data_archive_start_date_         Data_Archive_Log_Tab.start_date%TYPE,
      data_archive_stop_date_          Data_Archive_Log_Tab.stop_date%TYPE,
      data_archive_id_                 Data_Archive_Log_Tab.archive_id%TYPE,
      data_archive_master_stmt_        VARCHAR2(32000),
      msg_                             Msg_Array_Type,
      line_buffer_                     Msg_Array_Type,
      line_no_                         NUMBER := 0,
      no_msg_                          NUMBER,
      processed_                       NUMBER := 0,
      parameter_msg_                   VARCHAR2(32000),
      error_                           BOOLEAN := FALSE,
      arcfile_                         Utl_File.File_Type
   );

   starttag_   CONSTANT VARCHAR2(3) := '<<<';
   endtag_     CONSTANT VARCHAR2(3) := '>>>';

   cr_         CONSTANT  VARCHAR2(1) := CHR(13);
   nl_         CONSTANT  VARCHAR2(1) := CHR(10);

-------------------- PRIVATE DECLARATIONS -----------------------------------

PROCEDURE Archive___ ( 
   arc_rec_ IN OUT NOCOPY arc_type )
IS
BEGIN
   --Init_Archive_File___(arc_rec);
   Execute_Archiving_Procedure___(arc_rec_.processed_, arc_rec_.data_archive_master_stmt_, arc_rec_.data_archive_package_, arc_rec_.data_archive_order_id_, arc_rec_.data_archive_aoid_,
                                           arc_rec_.data_archive_exec_id_, arc_rec_.data_archive_date_);
   --End_Archive_File___(arc_rec);
   /*
--
-- Utl_File exception handling
--
EXCEPTION
   WHEN Utl_File.Invalid_Mode THEN
      Error_Sys.Appl_General('DataArchiveUtil', 'OPENMODE_ERR: Invalid open parameter in Fopen. (:P1)', param_);
   WHEN Utl_File.Invalid_Path THEN
      Error_Sys.Appl_General('DataArchiveUtil', 'FILE_ERR: Invalid filename or invalid path to file. (:P1)', param_);
   WHEN Utl_File.Invalid_Filehandle THEN
      Error_Sys.Appl_General('DataArchiveUtil', 'FILEHANDLE_ERR: Invalid filehandle when doing file operations. (:P1)', param_);
   WHEN Utl_File.Invalid_Operation THEN
      Error_Sys.Appl_General('DataArchiveUtil', 'OPERATION_ERR: File could not be opened as requested. (:P1)', param_);
   WHEN Utl_File.Read_Error THEN
      Error_Sys.Appl_General('DataArchiveUtil', 'OSREAD_ERR: Operating system error when reading from file. (:P1)', param_);
   WHEN Utl_File.Write_Error THEN
   Error_Sys.Appl_General('DataArchiveUtil', 'OSWRITE_ERR: Operating system error when writing to file. (:P1)', param_);
*/
END Archive___;

PROCEDURE Create_Archive_Child___ (
   arc_rec_         IN OUT NOCOPY arc_type,
   code_            OUT    CLOB,
   aoid_            IN     VARCHAR2,
   type_            IN     VARCHAR2 DEFAULT 'SPEC' )
IS
   lines_           CLOB;
   tmp_line_        VARCHAR2(32000);
   margin_          VARCHAR2(120);
   table_no_        BINARY_INTEGER := 0;
   table_no2_       BINARY_INTEGER := 0;

   CURSOR c1 IS
      SELECT table_name, destination_table_name, parent_table_name, level, master_table, data_archive_type
      FROM   data_archive_source_tab
      START WITH master_table = 'TRUE' AND aoid = aoid_
      CONNECT BY PRIOR table_name = parent_table_name AND PRIOR aoid = aoid;
   CURSOR c2 IS
      SELECT table_name, destination_table_name, parent_table_name, level, master_table, data_archive_type
      FROM   data_archive_source_tab
      START WITH master_table = 'TRUE' AND aoid = aoid_
      CONNECT BY PRIOR table_name = parent_table_name AND PRIOR aoid = aoid;
BEGIN
   
   --data_archive_destination_ := Data_Archive_Object_API.Get(aoid_).Data_Archive_Destination;
   FOR c1_rec IN c1 LOOP
      table_no_ := table_no_ + 1;
      IF (c1_rec.master_table != 'TRUE') THEN
         lines_ := Fnd_Code_Template_API.Get_Template('DataArchiveChildProcedure');
         Replace_Tag___('TABLE_NAME', upper(c1_rec.table_name), lines_);
         Replace_Tag___('ARCHIVE_PROCEDURE', 'Archive_'||to_char(table_no_)||'___', lines_);
         IF type_ = 'SPEC' THEN
            Replace_Tag___('SPEC_END', ';', lines_);
            lines_ := Dbms_Lob.Substr(lines_, Instr(lines_, ';')+1, 1);
         ELSE
            Replace_Tag___('SPEC_END', ' ', lines_);
         END IF;
         Replace_Tag___('CURSOR_SELECT_CHILD', Format_Select___(Replace(Create_Select_Child___(arc_rec_.msg_, table_no_, FALSE)||';',':',''), margin_), lines_);
         Replace_Tag___('CALL_MOVE_CHILD', 'Move_'||to_char(table_no_)||'___(obj.rowid);', lines_);
         Replace_Tag___('CALL_REMOVE_CHILD', 'Remove_'||to_char(table_no_)||'___(obj.rowid);', lines_);
         table_no2_ := 0;
         margin_ := '      ';
         FOR c2_rec IN c2 LOOP
            table_no2_ := table_no2_ + 1;
            IF (c2_rec.parent_table_name = c1_rec.table_name) THEN
               tmp_line_ := tmp_line_ || (margin_ || 'Archive_'||to_char(table_no2_)||'___(obj.rowid, aoid_);' || nl_);
            END IF;
         END LOOP;
         Replace_Tag___('CALL_ARCHIVE_CHILD_CHILDREN', tmp_line_, lines_);
         tmp_line_ := NULL;
      END IF;
      code_ := code_ || nl_ || lines_;
   END LOOP;
END Create_Archive_Child___;

PROCEDURE Create_Archive_Master___ (
   arc_rec_         IN OUT NOCOPY arc_type,
   code_            IN OUT NOCOPY    CLOB,
   aoid_            IN     VARCHAR2 )
IS
   tmp_lines_       CLOB;
   margin_          VARCHAR2(120);
   table_no_        BINARY_INTEGER := 0;
   table_no2_       BINARY_INTEGER := 0;
   
   CURSOR c1 IS
      SELECT table_name, destination_table_name, parent_table_name, master_table, data_archive_type
      FROM   data_archive_source_tab t
      WHERE  master_table = 'TRUE' 
      AND aoid = aoid_;
   
   CURSOR c2 IS
      SELECT table_name, destination_table_name, parent_table_name, level, master_table, data_archive_type
      FROM   data_archive_source_tab
      START WITH master_table = 'TRUE' AND aoid = aoid_
      CONNECT BY PRIOR table_name = parent_table_name AND PRIOR aoid = aoid;
BEGIN
   FOR c1_rec IN c1 LOOP
      table_no_ := table_no_ + 1;
      Replace_Tag___('ARCHIVE_MASTER_PROC', 'Archive_Master', code_);
      Replace_Tag___('TABLE_NAME', upper(c1_rec.table_name), code_);
      Replace_Tag___('CALL_MOVE_MASTER', 'Move_1___(rowid_arr_(i_));', code_);
      Replace_Tag___('CALL_REMOVE_MASTER', 'Remove_1___(rowid_arr_(i_));', code_);
      IF (arc_rec_.data_archive_destination_ = 'SQL File') THEN 
         Replace_Tag___('INIT_ARCHIVE_FILE', '   Data_Archive_Util_API.Init_Archive_File(arc_rec_);', code_);
         Replace_Tag___('WRITE_LINE_BUFFER', '         Data_Archive_Util_API.Write_Line_Buffer(arc_rec_);', code_);
         Replace_Tag___('END_ARCHIVE_FILE',  '   Data_Archive_Util_API.End_Archive_File(arc_rec_);', code_);
         Replace_Tag___('ARCHIVE_FILE_EXCEPTION',  
'EXCEPTION'||nl_||
'   WHEN Utl_File.Invalid_Mode THEN'||nl_||
'      Error_Sys.Appl_General(''DataArchiveUtil'', ''OPENMODE_ERR: Invalid open parameter in Fopen. (:P1)'', param_);'||nl_||
'   WHEN Utl_File.Invalid_Path THEN'||nl_||
'      Error_Sys.Appl_General(''DataArchiveUtil'', ''FILE_ERR: Invalid filename or invalid path to file. (:P1)'', param_);'||nl_||
'   WHEN Utl_File.Invalid_Filehandle THEN'||nl_||
'      Error_Sys.Appl_General(''DataArchiveUtil'', ''FILEHANDLE_ERR: Invalid filehandle when doing file operations. (:P1)'', param_);'||nl_||
'   WHEN Utl_File.Invalid_Operation THEN'||nl_||
'      Error_Sys.Appl_General(''DataArchiveUtil'', ''OPERATION_ERR: File could not be opened as requested. (:P1)'', param_);'||nl_||
'   WHEN Utl_File.Read_Error THEN'||nl_||
'      Error_Sys.Appl_General(''DataArchiveUtil'', ''OSREAD_ERR: Operating system error when reading from file. (:P1)'', param_);'||nl_||
'   WHEN Utl_File.Write_Error THEN'||nl_||
'   Error_Sys.Appl_General(''DataArchiveUtil'', ''OSWRITE_ERR: Operating system error when writing to file. (:P1)'', param_);',
         code_);
      ELSE
         Replace_Tag___('INIT_ARCHIVE_FILE', '', code_);
         Replace_Tag___('WRITE_LINE_BUFFER', '', code_);
         Replace_Tag___('END_ARCHIVE_FILE',  '', code_);
         Replace_Tag___('ARCHIVE_FILE_EXCEPTION', '', code_);
      END IF;
      table_no2_ := 0;
      margin_ := '         ';
      FOR c2_rec IN c2 LOOP
         table_no2_ := table_no2_ + 1;
         IF (c2_rec.parent_table_name = c1_rec.table_name) THEN
            tmp_lines_ := tmp_lines_ || (margin_ || 'Archive_'||to_char(table_no2_)||'___(rowid_arr_(i_), aoid_);'||nl_);
         END IF;
      END LOOP;
      Replace_Tag___('CALL_ARCHIVE_MASTER_CHILD', tmp_lines_, code_);
   END LOOP;   
END Create_Archive_Master___;

FUNCTION Create_Archive_Msg___ (
   arc_rec_  IN OUT NOCOPY arc_type,
   aoid_    IN VARCHAR2 ) RETURN NUMBER
IS
   i_          BINARY_INTEGER := 1;
   data_archive_db_link_ data_archive_object_tab.db_link%TYPE;

   CURSOR get_object IS
      SELECT db_link
      FROM   data_archive_object_tab
      WHERE  aoid = aoid_;

   CURSOR get_storage IS
      SELECT table_name, destination_table_name, parent_table_name, level, master_table, data_archive_type
      FROM   data_archive_source_tab
      START WITH master_table = 'TRUE' AND aoid = aoid_
      CONNECT BY PRIOR table_name = parent_table_name AND PRIOR aoid = aoid;
BEGIN
   OPEN  get_object;
   FETCH get_object INTO data_archive_db_link_;
   CLOSE get_object;
   FOR tab IN get_storage LOOP
      arc_rec_.msg_(i_) := Message_SYS.Construct('DATA_ARCHIVE_SOURCE');
      Message_SYS.Add_Attribute( arc_rec_.msg_(i_), 'TABLE_NAME', tab.table_name );
      Message_SYS.Add_Attribute( arc_rec_.msg_(i_), 'MASTER_TABLE', tab.master_table );
      Message_SYS.Add_Attribute( arc_rec_.msg_(i_), 'DESTINATION_TABLE_NAME', tab.destination_table_name );
      Message_SYS.Add_Attribute( arc_rec_.msg_(i_), 'LEVEL', to_number(tab.level) );
      Message_SYS.Add_Attribute( arc_rec_.msg_(i_), 'PARENT_POSITION', Find_Parent_Storage___(arc_rec_.msg_, i_ - 1, tab.level) );
      Message_SYS.Add_Attribute( arc_rec_.msg_(i_), 'PRIMARY_KEY_CLAUSE', Get_Pk_Where___ (aoid_, tab.table_name) );
      Message_SYS.Add_Attribute( arc_rec_.msg_(i_), 'COLUMN_LIST', Get_Column_List___(tab.table_name));
      Message_SYS.Add_Attribute( arc_rec_.msg_(i_), 'DATA_ARCHIVE_TYPE', tab.data_archive_type );
      IF (data_archive_db_link_ IS NOT NULL) THEN
         Message_SYS.Add_Attribute( arc_rec_.msg_(i_), 'DB_LINK', '@'||data_archive_db_link_ );
      ELSE
         Message_SYS.Add_Attribute( arc_rec_.msg_(i_), 'DB_LINK', '');
      END IF;
      i_ := i_ + 1;
   END LOOP;
   RETURN(i_ - 1);
END Create_Archive_Msg___;

PROCEDURE Create_Move_Object___ (
   arc_rec_         IN OUT NOCOPY arc_type,
   code_            OUT    CLOB,
   aoid_            IN     VARCHAR2,
   type_            IN     VARCHAR2 DEFAULT 'SPEC' )
IS
   lines_           CLOB;
   tmp_line_        CLOB;
   table_name_      VARCHAR2(30);
   table_no_        BINARY_INTEGER := 0;
   no_columns_      BINARY_INTEGER := 0;
   package_         VARCHAR2(30) := upper(aoid_)||'_ARC_API';
   margin_          VARCHAR2(120) := '   ';
   
   data_archive_destination_  Data_Archive_Object_TAB.Data_Archive_Destination%TYPE;

   CURSOR c1 IS
      SELECT table_name, destination_table_name, parent_table_name, level, master_table, data_archive_type
      FROM   data_archive_source_tab
      START WITH master_table = 'TRUE' AND aoid = aoid_
      CONNECT BY PRIOR table_name = parent_table_name AND PRIOR aoid = aoid;

   CURSOR c2 IS
      SELECT lower(column_name) column_name, data_type
      FROM   User_Tab_Columns
      WHERE  table_name = table_name_
      AND    data_type NOT IN ('LONG', 'LONG RAW', 'CLOB', 'BLOB', 'RAW')
      ORDER BY column_id;

   CURSOR get_keys IS
      SELECT cc.column_name, cc.position
      FROM   User_Constraints c, User_Cons_Columns cc
      WHERE  c.table_name = table_name_
      AND    c.constraint_type = 'P'
      AND    c.constraint_name = cc.constraint_name;
BEGIN
   data_archive_destination_ := Data_Archive_Object_API.Get(aoid_).Data_Archive_Destination;
   FOR c1_rec IN c1 LOOP
      lines_ := Fnd_Code_Template_API.Get_Template('DataArchiveMoveObjectProcedure');
      tmp_line_ := NULL;
      table_name_ := c1_rec.table_name;
      table_no_ := table_no_ + 1;
      Replace_Tag___('MOVE_PROCEDURE', 'Move_'||to_char(table_no_)||'___', lines_);
      IF type_ = 'SPEC' THEN
         Replace_Tag___('SPEC_END', ';', lines_);
         lines_ := Dbms_Lob.Substr(lines_, Instr(lines_, ';')+1, 1);
      ELSE
         Replace_Tag___('SPEC_END', ' ', lines_);
      END IF;
      Replace_Tag___('TABLE_NAME', upper(c1_rec.table_name), lines_);
      Replace_Tag___('TABLE_NO', to_char(table_no_), lines_);
      no_columns_ := 0;
      FOR c2_rec IN c2 LOOP
         no_columns_ := no_columns_ + 1;
      END LOOP;
      Replace_Tag___('NO_COLUMNS', to_char(no_columns_), lines_);
      
      tmp_line_ := NULL;      
      IF (data_archive_destination_ = 'Oracle Table') THEN
         FOR key_rec IN get_keys LOOP
            IF length(key_rec.column_name) > 28 THEN
               -- Remove last part of column name to not exceed 30 characters in variable name.
               -- Add column number in the name to be sure to avoid duplicates.
               tmp_line_ := tmp_line_ || (margin_ || substr(lower(key_rec.column_name),1,24) || '_' || lpad(to_char(key_rec.position), 3, '0') || '__ ' || lower(table_name_) || '.' || lower(key_rec.column_name) || '%TYPE;' || nl_);
            ELSE
               tmp_line_ := tmp_line_ || (margin_ || lower(key_rec.column_name) || '__ ' || lower(table_name_) || '.' || lower(key_rec.column_name) || '%TYPE;' || nl_);
            END IF;
         END LOOP;
         tmp_line_ := tmp_line_ || ('-- ' || nl_);
         tmp_line_ := tmp_line_ || (margin_ || 'CURSOR get_keys IS' || nl_);
         tmp_line_ := tmp_line_ || Format_Select___(Replace(Create_Remove_Archive_Cur___(arc_rec_.msg_, table_no_, FALSE), ':', ''), margin_)||';';
      ELSIF (data_archive_destination_ = 'SQL File') THEN
         tmp_line_ := tmp_line_ ||(margin_ || 'CURSOR get_record IS' || nl_);
         tmp_line_ := tmp_line_ || Format_Select___(Replace(Create_Move_Stmt_File___(c1_rec.table_name), ':', ''), margin_)||';';
      END IF;
      Replace_Tag___('CURSOR_MOVE_OBJECT', tmp_line_, lines_);
      tmp_line_ := NULL;
      IF (data_archive_destination_ = 'Oracle Table') THEN
         tmp_line_ := tmp_line_ || ('   IF (data_archive_destination_ = ''Oracle Table'') THEN'|| nl_);
         tmp_line_ := tmp_line_ || ('      IF (data_archive_type'||to_char(table_no_)||'_ IN (''Move'', ''Copy'')) THEN'|| nl_);
         tmp_line_ := tmp_line_ || ('         IF (data_archive_type'||to_char(table_no_)||'_ IN (''Copy'')) THEN'|| nl_);
         tmp_line_ := tmp_line_ || ('            OPEN  get_keys;'|| nl_);
         tmp_line_ := tmp_line_ || ('            FETCH get_keys INTO ');
         tmp_line_ := tmp_line_ || nl_ ;
         margin_  := '               ';
         FOR key_rec IN get_keys LOOP
            IF length(key_rec.column_name) > 28 THEN
               -- Remove last part of column name to not exceed 30 characters in variable name.
               -- Add column number in the name to be sure to avoid duplicates.
               tmp_line_ := tmp_line_ || margin_ || substr(lower(key_rec.column_name),1,24) || '_'|| lpad(to_char(key_rec.position), 3, '0') || '__, ' || nl_;
            ELSE
               tmp_line_ := tmp_line_ || margin_ || lower(key_rec.column_name) || '__, ' || nl_;
            END IF;
         END LOOP;
         tmp_line_ := (Substr(tmp_line_, 1, length(tmp_line_)-3)||';'|| nl_); -- Remove last comma and replace with semocolon.
         tmp_line_ := tmp_line_ || ('            CLOSE get_keys;'|| nl_);
         margin_   := '            ';
         tmp_line_ := tmp_line_ || Format_Delete___(Replace(Create_Remove_Archive_Stmt___(arc_rec_.msg_, table_no_, FALSE), ':', ''), margin_) || ';'|| nl_;
         tmp_line_ := tmp_line_ || ('         END IF;'|| nl_);
         margin_   := '         ';
         tmp_line_ := tmp_line_ || Format_Insert___(Replace(Create_Move_Stmt___(arc_rec_.msg_, to_char(table_no_), FALSE), ':', ''), margin_) || ';'|| nl_;
         tmp_line_ := tmp_line_ || ('      END IF;'|| nl_);
         tmp_line_ := tmp_line_ || ('   ELSE'|| nl_);
         tmp_line_ := tmp_line_ || ('      Error_Sys.Appl_General('''||package_||''', ''ORACLETABLE_ERR: This package was generated for Oracle table destination.'');'|| nl_);
         tmp_line_ := tmp_line_ || ('   END IF;'|| nl_);
      ELSIF (data_archive_destination_ = 'SQL File') THEN
         tmp_line_ := tmp_line_ || ('   IF (data_archive_destination_ = ''SQL File'') THEN'|| nl_);
         tmp_line_ := tmp_line_ || ('      IF (data_archive_type'||to_char(table_no_)||'_ IN (''Move'', ''Copy'')) THEN'|| nl_);
         tmp_line_ := tmp_line_ || ('         line_ := ''INSERT INTO ''||table_name_||''( '';'|| nl_);
         tmp_line_ := tmp_line_ || ('         Data_Archive_Util_API.Line_Buffer(arc_rec_, line_);'|| nl_);
         tmp_line_ := tmp_line_ || ('         line_ := NULL;'|| nl_);
         tmp_line_ := tmp_line_ || ('         counter_ := chr(table_value_+64);'|| nl_);
         tmp_line_ := tmp_line_ || ('         collist_no_ := ceil(no_columns_/5);'|| nl_);
         tmp_line_ := tmp_line_ || ('         FOR i IN 1..collist_no_ LOOP'|| nl_);
         tmp_line_ := tmp_line_ || ('            line_ := ''~Col''||counter_||LTRIM(TO_CHAR(i,''009''));'|| nl_);
         tmp_line_ := tmp_line_ || ('            Data_Archive_Util_API.Line_Buffer(arc_rec_, line_);'|| nl_);
         tmp_line_ := tmp_line_ || ('         END LOOP;'|| nl_);
         tmp_line_ := tmp_line_ || ('         line_ := '') VALUES ('';'|| nl_);
         tmp_line_ := tmp_line_ || ('         Data_Archive_Util_API.Line_Buffer(arc_rec_, line_);'|| nl_);
         tmp_line_ := tmp_line_ || ('         line_ := '' '';'|| nl_);
         tmp_line_ := tmp_line_ || ('         Data_Archive_Util_API.Line_Buffer(arc_rec_, line_);'|| nl_);
         tmp_line_ := tmp_line_ || ('         FOR rec IN get_record LOOP'|| nl_);
         FOR c2_rec IN c2 LOOP
            IF (c2_rec.data_type = 'VARCHAR2') THEN
               tmp_line_ := tmp_line_ || ('            Data_Archive_Util_API.Line_Buffer_Concat(arc_rec_, ''Database_SYS.Unistr('');'|| nl_);
               tmp_line_ := tmp_line_ || ('            Data_Archive_Util_API.Line_Buffer_Value(arc_rec_, Database_SYS.Asciistr(rec.'||c2_rec.column_name||'));'|| nl_);
               tmp_line_ := tmp_line_ || ('            Data_Archive_Util_API.Line_Buffer_Concat(arc_rec_, ''),'');'|| nl_);
            ELSE
               tmp_line_ := tmp_line_ || ('            Data_Archive_Util_API.Line_Buffer_Value(arc_rec_, rec.'||c2_rec.column_name||');'|| nl_);
               tmp_line_ := tmp_line_ || ('            Data_Archive_Util_API.Line_Buffer_Concat(arc_rec_, '','');'|| nl_);
            END IF;
         END LOOP;
         tmp_line_ := tmp_line_ || ('            Data_Archive_Util_API.Remove_Last_Comma(arc_rec_);'|| nl_);
         tmp_line_ := tmp_line_ || ('         END LOOP;'|| nl_);
         tmp_line_ := tmp_line_ || ('         line_ := '');'';'|| nl_);
         tmp_line_ := tmp_line_ || ('         Data_Archive_Util_API.Line_Buffer(arc_rec_, line_);'|| nl_);
         tmp_line_ := tmp_line_ || ('         line_ := NULL;'|| nl_);
         tmp_line_ := tmp_line_ || ('         Data_Archive_Util_API.Line_Buffer(arc_rec_, '''');'|| nl_);
         tmp_line_ := tmp_line_ || ('      END IF;'|| nl_);
         tmp_line_ := tmp_line_ || ('   ELSE'|| nl_);
         tmp_line_ := tmp_line_ || ('      Error_Sys.Appl_General('''||package_||''', ''SQLFILE_ERR: This package was generated for SQL File destination.'');'|| nl_);
         tmp_line_ := tmp_line_ || ('   END IF;'|| nl_);
      ELSIF (data_archive_destination_ = 'None') THEN
         tmp_line_ := tmp_line_ || ('   IF (data_archive_destination_ = ''None'') THEN'|| nl_);
         tmp_line_ := tmp_line_ || ('      NULL;'|| nl_);
         tmp_line_ := tmp_line_ || ('   ELSE'|| nl_);
         tmp_line_ := tmp_line_ || ('      Error_Sys.Appl_General('''||package_||''', ''NODEST_ERR: This package was generated for no destination.'');'|| nl_);
         tmp_line_ := tmp_line_ || ('   END IF;'|| nl_);
      END IF;
      Replace_Tag___('MOVE_OBJECT_CODE', tmp_line_, lines_);
      code_ := code_ || nl_ || lines_;
   END LOOP;
END Create_Move_Object___;


FUNCTION Create_Move_Stmt___ (
   msg_       IN Msg_Array_Type,
   msgind_    IN BINARY_INTEGER,
   rearchive_ IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   stmt_   VARCHAR2(32000);
BEGIN
   -- 
   -- Archive and Rearchive statement
   --
   IF (rearchive_ = FALSE) THEN
      stmt_ := 'INSERT INTO '||Lower(Message_SYS.Find_Attribute(msg_(msgind_), 'DESTINATION_TABLE_NAME', ''))||Message_SYS.Find_Attribute(msg_(msgind_), 'DB_LINK', '')||
               '('||Message_SYS.Find_Attribute(msg_(msgind_), 'COLUMN_LIST', '')||', data_archive_id, data_archive_date)  SELECT '||
               Message_SYS.Find_Attribute(msg_(msgind_), 'COLUMN_LIST', '')||', data_archive_id_, data_archive_date_ '||
               ' FROM '||Lower(Message_SYS.Find_Attribute(msg_(msgind_), 'TABLE_NAME', ''))||
               ' WHERE rowid = :rowid_';
   ELSE
      stmt_ := 'INSERT INTO '||Lower(Message_SYS.Find_Attribute(msg_(msgind_), 'TABLE_NAME', ''))||
               '('||Message_SYS.Find_Attribute(msg_(msgind_), 'COLUMN_LIST', '')||')  SELECT '||
               Message_SYS.Find_Attribute(msg_(msgind_), 'COLUMN_LIST', '')||
               ' FROM '||Lower(Message_SYS.Find_Attribute(msg_(msgind_), 'DESTINATION_TABLE_NAME', ''))||
               Message_SYS.Find_Attribute(msg_(msgind_), 'DB_LINK', '')||' WHERE rowid = :rowid_';
   END IF;
   RETURN(stmt_);
END Create_Move_Stmt___;

FUNCTION Create_Move_Stmt_File___ (
   table_name_ IN VARCHAR2 )  RETURN VARCHAR2
IS
BEGIN
   RETURN('SELECT ' || Get_Column_List___(table_name_) ||', ' || 'data_archive_id_ data_archive_id, ' ||
          ' data_archive_date_ data_archive_date FROM ' || Lower(table_name_) || ' WHERE rowid = :rowid_');
END Create_Move_Stmt_File___;

FUNCTION Create_Remove_Archive_Cur___ (
   msg_       IN Msg_Array_Type,
   msgind_    IN BINARY_INTEGER,
   rearchive_ IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   stmt_   VARCHAR2(32000);
BEGIN
   -- 
   -- Archive and Rearchive statement
   --
   IF (rearchive_ = FALSE) THEN
      stmt_ := 'SELECT ' ||lower(Get_Primary_Keys___(Message_SYS.Find_Attribute(msg_(msgind_), 'TABLE_NAME', '')))||
               ' FROM '||Lower(Message_SYS.Find_Attribute(msg_(msgind_), 'TABLE_NAME', ''))||' t2 '|| 
               ' WHERE rowid = :rowid_';
   ELSE
      stmt_ := NULL;
   END IF;
   RETURN(stmt_);
END Create_Remove_Archive_Cur___;

FUNCTION Create_Remove_Archive_Stmt___ (
   msg_       IN Msg_Array_Type,
   msgind_    IN BINARY_INTEGER,
   rearchive_ IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   stmt_   VARCHAR2(32000);
BEGIN
   -- 
   -- Archive and Rearchive statement
   --
   IF (rearchive_ = FALSE) THEN
      stmt_ := 'DELETE FROM '||Lower(Message_SYS.Find_Attribute(msg_(msgind_), 'DESTINATION_TABLE_NAME', ''))||Message_SYS.Find_Attribute(msg_(msgind_), 'DB_LINK', '')||
               ' t1 WHERE '||Get_Primary_Key_Where_Var___(Message_SYS.Find_Attribute(msg_(msgind_), 'TABLE_NAME', ''));
   ELSE
      stmt_ := NULL;
   END IF;
   RETURN(stmt_);
END Create_Remove_Archive_Stmt___;

PROCEDURE Create_Remove_Object___ (
   code_   OUT CLOB,
   aoid_   IN  VARCHAR2,
   type_   IN  VARCHAR2 DEFAULT 'SPEC' )
IS
   lines_           CLOB;
   table_no_        BINARY_INTEGER := 0;

   CURSOR c1 IS
      SELECT table_name, destination_table_name, parent_table_name, level, master_table, data_archive_type
      FROM   data_archive_source_tab
      START WITH master_table = 'TRUE' AND aoid = aoid_
      CONNECT BY PRIOR table_name = parent_table_name AND PRIOR aoid = aoid;
BEGIN
   FOR c1_rec IN c1 LOOP
      table_no_ := table_no_ + 1;
      lines_ := Fnd_Code_Template_API.Get_Template('DataArchiveRemoveObjectProcedure');
      Replace_Tag___('REMOVE_PROCEDURE', 'Remove_'||to_char(table_no_)||'___', lines_);
      Replace_Tag___('TABLE_NAME', Lower(c1_rec.table_name), lines_);
      Replace_Tag___('DATA_ARCHIVE_TYPE', 'data_archive_type'||to_char(table_no_)||'_', lines_);
      IF type_ = 'SPEC' THEN
         Replace_Tag___('SPEC_END', ';', lines_);
         lines_ := Dbms_Lob.Substr(lines_, Instr(lines_, ';')+1, 1);
      ELSE
         Replace_Tag___('SPEC_END', ' ', lines_);
      END IF;
      code_ := code_ || nl_ || lines_;
   END LOOP;
END Create_Remove_Object___;

FUNCTION Create_Remove_Stmt___ (
   msg_       IN Msg_Array_Type,
   msgind_    IN BINARY_INTEGER,
   rearchive_ IN BOOLEAN DEFAULT FALSE) RETURN VARCHAR2
IS
   stmt_   VARCHAR2(32000);
BEGIN
   -- 
   -- Archive and Rearchive statement
   --
   IF (rearchive_ = FALSE) THEN
      stmt_ := 'DELETE FROM '||Message_SYS.Find_Attribute(msg_(msgind_), 'TABLE_NAME', '')||' WHERE rowid = :rowid_';
   ELSE
      stmt_ := 'DELETE FROM '||Message_SYS.Find_Attribute(msg_(msgind_), 'DESTINATION_TABLE_NAME', '')||
               Message_SYS.Find_Attribute(msg_(msgind_), 'DB_LINK', '')||' WHERE rowid = :rowid_';
   END IF;
   RETURN(stmt_);
END Create_Remove_Stmt___;

FUNCTION Create_Reselect_Master___ (
   aoid_    IN VARCHAR2 )  RETURN VARCHAR2
IS
   stmt_   VARCHAR2(32000);
   CURSOR get_master IS
      SELECT da.db_link, ds.table_name, ds.table_alias, ds.destination_table_name, ds.where_clause, ds.hint
      FROM   data_archive_object_tab da, data_archive_source_tab ds
      WHERE  da.aoid = aoid_
      AND    da.aoid = ds.aoid
      AND    ds.master_table = 'TRUE';
BEGIN
   FOR master IN get_master LOOP
      stmt_ := 'SELECT rowid FROM ';
      stmt_ := stmt_ || Lower(master.destination_table_name);
      IF (master.db_link IS NOT NULL) THEN
         stmt_ := stmt_ || '@' || master.db_link;
      END IF;
      stmt_ := stmt_ || ' ' || master.table_alias;
      stmt_ := stmt_ || ' WHERE rowid = :rowid_';
   END LOOP;
   RETURN( stmt_ );
END Create_Reselect_Master___;

FUNCTION Create_Select_Child___ (
   msg_       IN msg_array_type,
   msgind_    IN BINARY_INTEGER,
   rearchive_ IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   stmt_   VARCHAR2(32000);
BEGIN
   -- 
   -- Archive and Rearchive statement
   --
   IF (rearchive_ = FALSE) THEN
      stmt_ := 'SELECT t1.rowid FROM '||Lower(Message_SYS.Find_Attribute(msg_(msgind_), 'TABLE_NAME', ''))||
               ' t1, '||Lower(Message_SYS.Find_Attribute(msg_(Message_SYS.Find_Attribute(msg_(msgind_), 'PARENT_POSITION', 1)),'TABLE_NAME', ''))||
               ' t2 WHERE '||Message_SYS.Find_Attribute(msg_(msgind_), 'PRIMARY_KEY_CLAUSE', '')||' AND t2.rowid = :rowid_';
   ELSE
      stmt_ := 'SELECT t1.rowid FROM '||Lower(Message_SYS.Find_Attribute(msg_(msgind_), 'DESTINATION_TABLE_NAME', ''))||
               Message_SYS.Find_Attribute(msg_(msgind_), 'DB_LINK', '')||' t1, '||
               Lower(Message_SYS.Find_Attribute(msg_(Message_SYS.Find_Attribute(msg_(msgind_), 'PARENT_POSITION', 1)),'DESTINATION_TABLE_NAME', ''))||
               Message_SYS.Find_Attribute(msg_(msgind_), 'DB_LINK', '')||
               ' t2 WHERE '||Message_SYS.Find_Attribute(msg_(msgind_), 'PRIMARY_KEY_CLAUSE', '')||' AND t2.rowid = :rowid_';
   END IF;
   RETURN(stmt_);
END Create_Select_Child___;

PROCEDURE Execute_Archiving_Procedure___ (
   processed_           IN OUT NUMBER,
   master_stmt_         IN OUT VARCHAR2,
   archiving_package_   IN VARCHAR2,
   order_id_            IN NUMBER,
   aoid_                IN VARCHAR2,
   exec_id_             IN VARCHAR2,
   archive_date_        IN DATE )
IS
   cursor_     NUMBER;
   stmt_       VARCHAR2(200);
   stmt2_      VARCHAR2(32000);
   cnt_        NUMBER;
BEGIN
   Assert_SYS.Assert_Is_Package(archiving_package_);
   stmt_ := 'BEGIN '||archiving_package_||'.Archive_Master(:processed, :stmt, :aoid, :exec_id, :archive_date); END;';
   stmt2_ := Create_Select_Master(aoid_, order_id_, exec_id_);
   master_stmt_ := stmt2_;
   cursor_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2006-01-05,utgulk)
   dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
   dbms_sql.bind_variable(cursor_, 'processed', processed_);
   dbms_sql.bind_variable(cursor_, 'stmt', stmt2_);
   dbms_sql.bind_variable(cursor_, 'aoid', aoid_);
   dbms_sql.bind_variable(cursor_, 'exec_id', exec_id_);
   dbms_sql.bind_variable(cursor_, 'archive_date', archive_date_);
   cnt_ := dbms_sql.execute(cursor_);
   dbms_sql.variable_value(cursor_, 'processed', processed_);
   dbms_sql.close_cursor(cursor_);
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cursor_)) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      RAISE;
END Execute_Archiving_Procedure___;

PROCEDURE Execute_Stmt_Rowid___ (
   cursor_ IN OUT NUMBER,
   rowid_  IN ROWID,
   stmt_   IN VARCHAR2 )
IS
   dummy_   NUMBER;
BEGIN
   IF (dbms_sql.is_open(cursor_) = FALSE) THEN
      cursor_ := dbms_sql.open_cursor;
      -- Safe due to system privilege DEFINE SQL is needed for entering statement in DataArchiveSource
      @ApproveDynamicStatement(2006-05-24,haarse)
      dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
   END IF;
   dbms_sql.bind_variable_rowid(cursor_, 'rowid_', rowid_);
   dummy_ := dbms_sql.execute(cursor_);
END Execute_Stmt_Rowid___;

FUNCTION Find_Parent_Storage___ (
   msg_        IN msg_array_type,
   position_   IN BINARY_INTEGER,
   level_      IN NUMBER ) RETURN NUMBER
IS
   i_ BINARY_INTEGER;
BEGIN
   i_ := position_;
   WHILE (i_ > 1) LOOP
      IF (level_ - 1 = Message_Sys.Find_Attribute(msg_(i_), 'LEVEL', 0) ) THEN
         RETURN(i_);
      END IF;
      i_ := i_ - 1;
   END LOOP;
   RETURN(i_);
END Find_Parent_Storage___;

FUNCTION Format___ (
   value_  IN  VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (value_ IS NULL) THEN
      RETURN('NULL');
   ELSE
      RETURN(''''||Replace(value_,'''','''''')||'''');
   END IF;
END Format___;

FUNCTION Format___ (
   value_  IN  DATE ) RETURN VARCHAR2
IS
BEGIN
   IF (value_ IS NULL) THEN
      RETURN('NULL');
   ELSE
      RETURN('To_Date('''||To_Char(value_, 'YYYYMMDD HH24MISS')||''',''YYYYMMDD HH24MISS'')');
   END IF;
END Format___;

FUNCTION Format___ (
   value_  IN  NUMBER ) RETURN VARCHAR2
IS
BEGIN
   IF (value_ IS NULL) THEN
      RETURN('NULL');
   ELSE
      RETURN(To_Char(value_));
   END IF;

END Format___;

FUNCTION Format_Item_List___(
   stmt_       IN VARCHAR2,
   delimiter_  IN VARCHAR2,
   margin_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   formatted_stmt_ VARCHAR2(32000) := '';
BEGIN
   formatted_stmt_ := REPLACE(margin_ || TRIM(stmt_), delimiter_ || ' ' , delimiter_ || cr_ || nl_ || margin_ );
   RETURN(formatted_stmt_);
END Format_Item_List___;
   
FUNCTION Format_Delete___ (
   stmt_   IN VARCHAR2,
   margin_ IN VARCHAR2 ) RETURN CLOB 
IS
   start_   NUMBER;
   pos_     NUMBER;
   line_    CLOB;
   indent3_ VARCHAR2(3) := '   ' ;
BEGIN
   start_ := 1;
   pos_ := start_ + LENGTH('DELETE ') ;
   line_ := line_ || (margin_ || Substr(stmt_, start_, pos_ - start_) || nl_);
   start_ := pos_;
   pos_ := Instr(stmt_, ' WHERE ', 1);
   line_ := line_ || (margin_ || Substr(stmt_, start_, pos_ - start_) || nl_);  
   start_ :=  pos_  + 1;
   pos_ := start_ + LENGTH('WHERE ') ;
   line_ := line_ || (margin_ || Substr(stmt_, start_, pos_ - start_) || nl_);
   start_ := start_ + (pos_ - start_);
   line_ := line_ || (Format_Item_List___ ( Substr(stmt_, start_), ' AND ' , margin_ || indent3_ ));
   RETURN(line_);
END Format_Delete___;

FUNCTION Format_Insert___ (
   stmt_   IN VARCHAR2,
   margin_ IN VARCHAR2 ) RETURN CLOB 
IS
   start_   NUMBER;
   pos_     NUMBER;
   line_    CLOB;
   indent3_ VARCHAR2(3) := '   ' ;
BEGIN
   start_ := 1;
   pos_ := Instr(stmt_, '(', 1);
   line_ := line_ || (margin_ || Substr(stmt_, start_, pos_) || nl_);
   start_ := pos_ + 1;
   pos_ := Instr(stmt_, ' SELECT ', 1);
   line_ := line_ || (Format_Item_List___ ( Substr(stmt_, start_ , pos_ - start_) , ',' , margin_ || indent3_ )  || nl_);
   start_ := pos_ + 1 ;
   pos_ := pos_ + LENGTH('SELECT ') ;
   line_ := line_ || (margin_ || Substr(stmt_, start_,  pos_ - start_ ) || nl_);
   start_ := pos_+ 1 ;
   pos_ := Instr(stmt_, ' FROM ', 1);
   line_ := line_ || (Format_Item_List___ ( Substr(stmt_, start_ , pos_ - start_) , ',' , margin_ || indent3_ ) || nl_ );
   start_ := pos_ + 1;
   pos_ := Instr(stmt_, ' WHERE ', 1);
   line_ := line_ || (margin_ || Substr(stmt_, start_ , pos_ - start_) || nl_);
   start_ := start_ + (pos_ - start_) + 1;
   line_ := line_ || (margin_ || Substr(stmt_, start_));
   RETURN(line_);
END Format_Insert___;

FUNCTION Format_Select___ (
   stmt_   IN VARCHAR2,
   margin_ IN VARCHAR2 ) RETURN CLOB  
IS
   start_   NUMBER;
   pos_     NUMBER;
   line_    CLOB;
   indent3_ VARCHAR2(3) := '   ' ;
BEGIN
   start_ := 1;
   pos_ := start_ + LENGTH('SELECT ');
   line_ := line_ || (margin_ || Substr(stmt_, start_, pos_ - start_) || nl_);
   start_ := pos_  ;
   pos_ := Instr(stmt_, ' FROM ', 1);
   line_ := line_ || (Format_Item_List___ ( Substr(stmt_, start_, pos_ - start_), ',', margin_ || indent3_ )  || nl_); 
   start_ := pos_ + 1;
   pos_ := Instr(stmt_, ' WHERE ', 1);
   line_ := line_ || (margin_ || Substr(stmt_, start_, pos_ - start_) || nl_);  
   start_ :=  pos_  + 1;
   pos_ := start_ + LENGTH('WHERE ');
   line_ := line_ || (margin_ || Substr(stmt_, start_, pos_ - start_) || nl_);
   start_ := start_ + (pos_ - start_);
   line_ := line_ || (Format_Item_List___ ( Substr(stmt_, start_), ' AND ' , margin_ || indent3_ ));
   RETURN(line_);
END Format_Select___;

FUNCTION Get_Column_List___ (
   table_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   collist_    VARCHAR2(32000);

   CURSOR get_table_columns IS
      SELECT lower(column_name) column_name
      FROM   User_Tab_Columns
      WHERE  table_name = table_name_
      AND    data_type NOT IN ('LONG', 'LONG RAW', 'CLOB', 'BLOB', 'RAW')
      AND    column_name NOT IN ('DATA_ARCHIVE_ID', 'DATA_ARCHIVE_DATE') -- These are generated in archive_move
      ORDER BY column_id;

BEGIN
   FOR col_rec IN get_table_columns LOOP
      collist_ := collist_ ||col_rec.column_name||', ';
   END LOOP;
   RETURN(Substr(collist_,1,Length(collist_)-2));
END Get_Column_List___;

FUNCTION Get_Pk_Where___ (
   aoid_       IN VARCHAR2,
   table_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   where_   VARCHAR2(2000);
   first_   BOOLEAN := TRUE;

   CURSOR get_pk IS
   SELECT da.column_name, da.parent_key_name
   FROM   data_archive_source_tab ds, data_archive_source_attr_tab da
   WHERE  ds.aoid = aoid_
   AND    ds.table_name = table_name_
   AND    ds.aoid = da.aoid
   AND    ds.table_name = da.table_name
   AND    da.parent_key_name IS NOT NULL
   ORDER BY da.seq_no;
BEGIN
   FOR pk IN get_pk LOOP
      IF (first_ = TRUE) THEN
         first_ := FALSE;
      ELSE
         where_ := where_ || ' AND ';
      END IF;
      where_ := where_ || ' t1.'||pk.column_name || ' = t2.' || pk.parent_key_name;
   END LOOP;
   RETURN(where_);
END Get_Pk_Where___;

FUNCTION Get_Primary_Keys___ (
   table_name_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
   temp_list_ VARCHAR2(32000);
   CURSOR get_keys IS
      SELECT cc.column_name
      FROM   User_Constraints c, User_Cons_Columns cc
      WHERE  c.table_name = table_name_
      AND    c.constraint_type = 'P'
      AND    c.constraint_name = cc.constraint_name;
BEGIN
   FOR keyrec IN get_keys LOOP
      temp_list_ := temp_list_||keyrec.column_name||',';
   END LOOP;
   RETURN(Substr(temp_list_, 1, Length(temp_list_)-1));
END Get_Primary_Keys___;

FUNCTION Get_Primary_Key_Where___ (
   table_name_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
   where_   VARCHAR2(2000);
   first_   BOOLEAN := TRUE;

   CURSOR get_keys IS
      SELECT cc.column_name
      FROM   User_Constraints c, User_Cons_Columns cc
      WHERE  c.table_name = table_name_
      AND    c.constraint_type = 'P'
      AND    c.constraint_name = cc.constraint_name;
BEGIN
   FOR keyrec IN get_keys LOOP
      IF (first_ = TRUE) THEN
         first_ := FALSE;
      ELSE
         where_ := where_ || ' AND ';
      END IF;
      where_ := where_ || ' t1.'|| keyrec.column_name || ' = t2.' || keyrec.column_name;
   END LOOP;
   RETURN(where_);
END Get_Primary_Key_Where___;

FUNCTION Get_Primary_Key_Where_Var___ (
   table_name_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
   where_   VARCHAR2(2000);
   first_   BOOLEAN := TRUE;

   CURSOR get_keys IS
      SELECT cc.column_name, cc.position
      FROM   User_Constraints c, User_Cons_Columns cc
      WHERE  c.table_name = table_name_
      AND    c.constraint_type = 'P'
      AND    c.constraint_name = cc.constraint_name;
BEGIN
   FOR keyrec IN get_keys LOOP
      IF (first_ = TRUE) THEN
         first_ := FALSE;
      ELSE
         where_ := where_ || ' AND ';
      END IF;
      IF length(keyrec.column_name) > 28 THEN
         -- Remove last part of column name to not exceed 30 characters in variable name.
         -- Add column number in the name to be sure to avoid duplicates.
         where_ := where_ || ' t1.'|| lower(keyrec.column_name) || ' = ' || substr(lower(keyrec.column_name),1,24) || '_' || lpad(to_char(keyrec.position), 3, '0') || '__';
      ELSE
         where_ := where_ || ' t1.'|| lower(keyrec.column_name) || ' = ' || lower(keyrec.column_name) || '__';
      END IF;
   END LOOP;
   RETURN(where_);
END Get_Primary_Key_Where_Var___;

PROCEDURE Init_Archive_File___ (
   arc_rec_ IN OUT NOCOPY arc_type )
IS
   i_       BINARY_INTEGER;
   j_       BINARY_INTEGER;
   k_       BINARY_INTEGER;
   l_       BINARY_INTEGER;
   start_   BINARY_INTEGER := 1;
   next_    BINARY_INTEGER := 1;
   end_     BINARY_INTEGER := 0;
   tmp_     VARCHAR2(20000);
   counter_  VARCHAR2(2000);
--
   CURSOR get_storage IS
      SELECT table_name
      FROM   data_archive_source_tab
      START WITH master_table = 'TRUE' AND aoid = arc_rec_.data_archive_aoid_
      CONNECT BY PRIOR table_name = parent_table_name AND PRIOR aoid = aoid;
BEGIN
   IF (arc_rec_.data_archive_destination_ = 'SQL File') THEN -- SQL-file
      IF (arc_rec_.data_archive_destination_dir_ IS NULL) THEN
         RAISE Utl_File.Invalid_Path;
      END IF;
      arc_rec_.arcfile_ := utl_file.fopen(arc_rec_.data_archive_destination_dir_, 
                                 Replace(arc_rec_.data_archive_aoid_ || '_' || arc_rec_.data_archive_exec_id_ || '_' || to_char(arc_rec_.data_archive_date_,'YYYYMMDD_HH24MISS') ||'.txt', ' ', '_'),
                                 'w');
      utl_file.put_line(arc_rec_.arcfile_, '-----------------------------------------------------------------------------');
      utl_file.put_line(arc_rec_.arcfile_, '--');
      utl_file.put_line(arc_rec_.arcfile_, '--  Module: FNDBAS (Archiving)');
      utl_file.put_line(arc_rec_.arcfile_, '--');
      utl_file.put_line(arc_rec_.arcfile_, '--  Date    History');
      utl_file.put_line(arc_rec_.arcfile_, '--  ------  -----------------------------------------------------------------');
      utl_file.put_line(arc_rec_.arcfile_, '--  '||to_char(sysdate,'YYMMDD')||'  Created by IFS Applications archiving');
      utl_file.put_line(arc_rec_.arcfile_, '--');
      utl_file.put_line(arc_rec_.arcfile_, '--  Archive Date       Archiving Execution');
      utl_file.put_line(arc_rec_.arcfile_, '--  -----------------  ------------------------------------------------------');
      utl_file.put_line(arc_rec_.arcfile_, '--  ' || to_char(arc_rec_.data_archive_date_,'YYYYMMDD HH24:MI:SS') || '  '|| arc_rec_.data_archive_aoid_ || ' ' || arc_rec_.data_archive_exec_id_);
      utl_file.put_line(arc_rec_.arcfile_, '-----------------------------------------------------------------------------');
      utl_file.put_line(arc_rec_.arcfile_, ' ');
      utl_file.put_line(arc_rec_.arcfile_, 'SET DEFINE "~"');
      i_ := 1;
      FOR rec_ IN get_storage LOOP
         j_ := 1;
         k_ := 1;
         l_ := 1;
         end_ := 1;
         start_ := 1;
         counter_ := NULL;
         tmp_ := Get_Column_List___(rec_.table_name);
         utl_file.put_line(arc_rec_.arcfile_, ' ');
         utl_file.put_line(arc_rec_.arcfile_, 'DEFINE Table_Name'||chr(i_+64)||' = '||rec_.table_name);
         LOOP
            next_ := end_ + 1;
            end_ := Instr(tmp_, ',', next_);
            IF (Mod(j_,5) = 0 AND end_ != 0) THEN
               counter_ := counter_ || chr(i_+64);
               utl_file.put_line(arc_rec_.arcfile_, 'DEFINE Col'||chr(i_+64)||LTRIM(TO_CHAR(l_,'009'))||' = "'||Substr(tmp_, start_, end_- start_ + 1)||'"');
               l_ := l_ + 1;
               start_ := end_ + 1;
            ELSIF (end_ = 0) THEN
               counter_ := counter_ || chr(i_+64);
               utl_file.put_line(arc_rec_.arcfile_, 'DEFINE Col'||chr(i_+64)||LTRIM(TO_CHAR(l_,'009'))||' = "'||Substr(tmp_, start_)||'"');
               l_ := l_ + 1;
               EXIT;
            END IF;
            j_ := j_ + 1;
         END LOOP;
         k_ := Ceil(j_/5);
         counter_ := NULL;
         i_ := i_ + 1;
      END LOOP;
      utl_file.put_line(arc_rec_.arcfile_, ' ');
      utl_file.fflush(arc_rec_.arcfile_);
   ELSIF (arc_rec_.data_archive_destination_ = 'Test') THEN -- Test
      arc_rec_.arcfile_ := utl_file.fopen(arc_rec_.data_archive_destination_dir_, arc_rec_.data_archive_aoid_ || '_' || arc_rec_.data_archive_exec_id_ || '_' || to_char(arc_rec_.data_archive_date_,'YYYYMMDD_HH24MISS') ||'.txt', 'w');
      FOR x_ IN 1..arc_rec_.no_msg_ LOOP
         IF ( Message_SYS.Find_Attribute(arc_rec_.msg_(x_), 'MASTER_TABLE', 'FALSE') = 'TRUE') THEN
            utl_file.put_line(arc_rec_.arcfile_, Create_Select_Master(arc_rec_.data_archive_aoid_, arc_rec_.data_archive_order_id_, arc_rec_.data_archive_exec_id_));
         ELSE
            utl_file.put_line(arc_rec_.arcfile_, Create_Select_Child___(arc_rec_.msg_, x_));
         END IF;
      END LOOP;
   END IF;
END Init_Archive_File___;

PROCEDURE End_Archive_File___ (
   arc_rec_ IN OUT NOCOPY arc_type )
IS
BEGIN
   IF (arc_rec_.data_archive_destination_ IN ('SQL File', 'Test')) THEN -- SQL-file, test
      Write_Line_Buffer___(arc_rec_);
      utl_file.put_line(arc_rec_.arcfile_, ' ');
      utl_file.put_line(arc_rec_.arcfile_, 'SET DEFINE "&"');
      utl_file.fclose_all;
   END IF;
END End_Archive_File___;

PROCEDURE Init_Variables___ (
   arc_rec_ IN OUT NOCOPY arc_type )
IS
BEGIN
   arc_rec_.msg_.delete;
   arc_rec_.no_msg_ := 0;
   arc_rec_.processed_ := 0;
   arc_rec_.parameter_msg_ := NULL;
   arc_rec_.error_ := FALSE;
END Init_Variables___;

PROCEDURE Line_Buffer_Value___ (
   arc_rec_ IN OUT NOCOPY arc_type,
   value_ IN  VARCHAR2 )
IS
   unicode_value_ VARCHAR2(32000) := value_;
BEGIN
   IF (length(arc_rec_.line_buffer_(arc_rec_.line_no_)) + lengthb(unicode_value_) < 1000) THEN
      arc_rec_.line_buffer_(arc_rec_.line_no_) := arc_rec_.line_buffer_(arc_rec_.line_no_) || unicode_value_;
   ELSE
      --
      -- 1023 byte is max length for utl_file.put_line.
      --
      IF (lengthb(unicode_value_) > 1000) THEN
         WHILE (lengthb(unicode_value_) > 1000) LOOP
            arc_rec_.line_no_ := arc_rec_.line_no_ + 1;
            arc_rec_.line_buffer_(arc_rec_.line_no_) := Substr(unicode_value_, 1, 1000);
            unicode_value_ := Substr(unicode_value_, 1001, 1000);
         END LOOP;
         arc_rec_.line_buffer_(arc_rec_.line_no_) := arc_rec_.line_buffer_(arc_rec_.line_no_);
      ELSE
         arc_rec_.line_no_ := arc_rec_.line_no_ + 1;
         arc_rec_.line_buffer_(arc_rec_.line_no_) := unicode_value_;
      END IF;
   END IF;
END Line_Buffer_Value___;

PROCEDURE Restore___ (
   arc_rec_       IN OUT NOCOPY arc_type,
   aoid_          IN VARCHAR2,
   msgind_        IN BINARY_INTEGER,
   parent_rowid_  IN ROWID )
IS
   c2_            NUMBER;
   c3_            NUMBER;
   no_record_     BINARY_INTEGER := 0;
   stmt_          VARCHAR2(32000);
   move_stmt_     VARCHAR2(32000);
   remove_stmt_   VARCHAR2(32000);
   record_        Rowid_Array_Type;
BEGIN
   arc_rec_.data_archive_type_ := 'Move'; -- Move is default archive type
   IF ( Message_SYS.Find_Attribute(arc_rec_.msg_(msgind_), 'MASTER_TABLE', 'FALSE') = 'TRUE') THEN
      stmt_ := Create_Reselect_Master___(aoid_);
   ELSE
      stmt_ := Create_Select_Child___(arc_rec_.msg_, msgind_, TRUE);
   END IF;
   Get_All_Rowids(record_, no_record_, stmt_, parent_rowid_);
   FOR i_ IN 1..no_record_ LOOP -- For each object record
      Restore_Move___(c2_, move_stmt_, arc_rec_.msg_, msgind_, record_(i_));
      FOR j_ IN 1..arc_rec_.no_msg_ - msgind_ LOOP -- For each childs children
         IF ( Message_SYS.Find_Attribute(arc_rec_.msg_(msgind_ + j_), 'PARENT_POSITION', 0) = msgind_) THEN --If child children exists
            Restore___(arc_rec_, aoid_, msgind_+ j_, record_(i_));
         END IF;
      END LOOP;
      Restore_Remove___(c3_, remove_stmt_, arc_rec_.msg_, msgind_, record_(i_));
   END LOOP;
   IF (dbms_sql.is_open(c2_)) THEN
      dbms_sql.close_cursor(c2_);
   END IF;
   IF (dbms_sql.is_open(c3_)) THEN
      dbms_sql.close_cursor(c3_);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(c2_)) THEN
         dbms_sql.close_cursor(c2_);
      END IF;
      IF (dbms_sql.is_open(c3_)) THEN
         dbms_sql.close_cursor(c3_);
      END IF;
      RAISE;
END Restore___;

PROCEDURE Restore_Move___ (
   c2_         IN OUT NOCOPY NUMBER,
   move_stmt_  IN OUT VARCHAR2,
   msg_        IN msg_array_type,
   msg_ind_    IN BINARY_INTEGER,
   rowid_      IN ROWID )
IS
BEGIN
   IF (move_stmt_ IS NULL) THEN
      move_stmt_ := Create_Move_Stmt___(msg_, msg_ind_, TRUE);
   END IF;
   Execute_Stmt_Rowid___(c2_, rowid_, move_stmt_);
END Restore_Move___;

PROCEDURE Restore_Remove___ (
   c3_          IN OUT NUMBER,
   remove_stmt_ IN OUT VARCHAR2,
   msg_         IN msg_array_type,
   msg_ind_     IN BINARY_INTEGER,
   rowid_       IN ROWID )
IS
BEGIN
   IF (remove_stmt_ IS NULL) THEN
      remove_stmt_ := Create_Remove_Stmt___(msg_, msg_ind_, TRUE);
   END IF;
   Execute_Stmt_Rowid___(c3_, rowid_, remove_stmt_);
END Restore_Remove___;

PROCEDURE Replace_Tag___ (
   tag_     IN VARCHAR2,
   value_   IN CLOB,
   code_    IN OUT NOCOPY CLOB )
IS
   tag_clob_      CLOB    := to_clob(starttag_ ||tag_||endtag_);
   length_        NUMBER  := length(value_);
   to_            NUMBER  := trunc(length_ / 32000);
   continue_tag_  VARCHAR2(20) := starttag_||'CONTINUE_TAG'||endtag_;
BEGIN
   IF (length_ > 32767) THEN 
      Replace_Tag___(tag_, substr(value_, 1, 32000)||continue_tag_, code_);
      FOR i IN 1..to_ LOOP
         Replace_Tag___('CONTINUE_TAG', substr(value_, (i*32000)+1, 32000)||continue_tag_, code_);
      END LOOP;
      Replace_Tag___('CONTINUE_TAG', substr(value_, ((to_+1)*32000)+1, 32000), code_);
   ELSE
      code_ := REPLACE(code_, tag_clob_, value_);
   END IF;
END Replace_Tag___;

PROCEDURE Write_Line_Buffer___ (
   arc_rec_ IN OUT NOCOPY arc_type )
IS
BEGIN
   IF (arc_rec_.data_archive_destination_ = 'SQL File') THEN
      FOR i_ IN 1..arc_rec_.line_no_ LOOP
         utl_file.put_line(arc_rec_.arcfile_, arc_rec_.line_buffer_(i_));
      END LOOP;
      arc_rec_.line_buffer_.DELETE;
      arc_rec_.line_no_ := 0;
      utl_file.fflush(arc_rec_.arcfile_);
   END IF;
END Write_Line_Buffer___;

FUNCTION Write_Log_Start___ (
   arc_rec_ IN OUT NOCOPY arc_type ) RETURN NUMBER
IS
   log_  Data_Archive_Log_Tab%ROWTYPE := NULL;
BEGIN
   log_.status := 'Executing';
   log_.archive_id := arc_rec_.data_archive_aoid_ || '.' || arc_rec_.data_archive_exec_id_;
   log_.archive_date := arc_rec_.data_archive_date_;
   log_.start_date := Nvl(arc_rec_.data_archive_start_date_, sysdate);
   log_.stop_date := NULL;
   log_.processed := arc_rec_.processed_;
   log_.order_id := arc_rec_.data_archive_order_id_;
   log_.exec_id := arc_rec_.data_archive_exec_id_;
   log_.parameters := arc_rec_.parameter_msg_;
   Data_Archive_Log_API.Write_Log_(log_);
   RETURN(log_.log_id);
END Write_Log_Start___;

PROCEDURE Write_Log_End___ (
   arc_rec_ IN OUT NOCOPY arc_type,
   log_id_  IN NUMBER )
IS
   log_  Data_Archive_Log_Tab%ROWTYPE := NULL;
   fnd_user_   VARCHAR2(2000);
   event_msg_  VARCHAR2(32000);
BEGIN
   IF (arc_rec_.error_ = TRUE) THEN
      log_.status := 'Error';
      log_.text := substr(sqlerrm,1,2000);
   ELSE
      log_.status := 'Ready';
      log_.text := substr(arc_rec_.data_archive_master_stmt_,1,2000);
   END IF;
   arc_rec_.error_ := FALSE;
   log_.log_id := log_id_;
   log_.archive_id := arc_rec_.data_archive_aoid_ || '.' || arc_rec_.data_archive_exec_id_;
   log_.archive_date := arc_rec_.data_archive_date_;
   log_.start_date := arc_rec_.data_archive_start_date_;
   log_.stop_date := NVL(arc_rec_.data_archive_stop_date_, sysdate);
   log_.processed := arc_rec_.processed_;
   log_.order_id := arc_rec_.data_archive_order_id_;
   log_.exec_id := arc_rec_.data_archive_exec_id_;
   log_.parameters := arc_rec_.parameter_msg_;
   Data_Archive_Log_API.Write_Log_(log_);
   IF (Event_SYS.Event_Enabled(lu_name_, 'DATA_ARCHIVE_EXECUTED')) THEN
      event_msg_ := Message_SYS.Construct('DATA_ARCHIVE_EXECUTED');
      ---
      --- Standard event parameters
      ---
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute(event_msg_, 'EVENT_DATETIME', sysdate);
      Message_SYS.Add_attribute(event_msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_attribute(event_msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_attribute(event_msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_attribute(event_msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));
      ---
      --- Primary key for object
      ---
      Message_SYS.Add_Attribute(event_msg_, 'LOG_ID', log_.log_id);
      ---
      --- Other important information
      ---
      Message_SYS.Add_Attribute(event_msg_, 'STATUS', log_.status);
      Message_SYS.Add_Attribute(event_msg_, 'TEXT', log_.text);
      Message_SYS.Add_Attribute(event_msg_, 'ARCHIVE_ID', log_.archive_id);
      Message_SYS.Add_Attribute(event_msg_, 'ARCHIVE_DATE', log_.archive_date);
      Message_SYS.Add_Attribute(event_msg_, 'START_DATE', log_.start_date);
      Message_SYS.Add_Attribute(event_msg_, 'STOP_DATE', log_.stop_date);
      Message_SYS.Add_Attribute(event_msg_, 'PROCESSED', log_.processed);
      Message_SYS.Add_Attribute(event_msg_, 'ORDER_ID', log_.order_id);
      Message_SYS.Add_Attribute(event_msg_, 'EXEC_ID', log_.exec_id);
      Message_SYS.Add_Attribute(event_msg_, 'PARAMETERS', log_.Parameters);
      Event_SYS.Event_Execute(lu_name_, 'DATA_ARCHIVE_EXECUTED', event_msg_);
   END IF;
END Write_Log_End___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Process_Archive_ (
   dummy_ IN NUMBER )
IS
   arc_rec_  arc_type;
   log_id_  NUMBER;
   CURSOR get_order IS
      SELECT order_id, execution_plan, active
      FROM   data_archive_order_tab
      WHERE  active = 'TRUE'
      AND    next_date <= sysdate
      ORDER BY next_date, order_id;
--      FOR UPDATE OF next_date;

   CURSOR get_executions IS
      SELECT do.aoid, do.data_archive_destination, do.destination_dir,
             do.db_link, do.transaction_size, do.archive_package, de.exec_id
      FROM   data_archive_order_exec_tab de, data_archive_object_tab do
      WHERE  de.order_id = arc_rec_.data_archive_order_id_
      AND    de.aoid = do.aoid
      AND    de.active = 'TRUE'
      AND    do.active = 'TRUE'
      ORDER BY seq_no;

BEGIN
   FOR ord IN get_order LOOP
      arc_rec_.data_archive_order_id_ := ord.order_id;
      Data_Archive_Order_API.Update_Next_Execution_(arc_rec_.data_archive_order_id_);
      @ApproveTransactionStatement(2013-10-23,haarse)
      COMMIT;
      arc_rec_.data_archive_date_ := sysdate;
      arc_rec_.error_ := FALSE;
      FOR exec IN get_executions LOOP
         BEGIN
            arc_rec_.data_archive_start_date_ := sysdate;
            arc_rec_.data_archive_aoid_ := exec.aoid;
            arc_rec_.data_archive_destination_ := exec.data_archive_destination;
            arc_rec_.data_archive_destination_dir_ := exec.destination_dir;
            arc_rec_.data_archive_db_link_ := exec.db_link;
            arc_rec_.data_archive_exec_id_ := exec.exec_id;
            arc_rec_.data_archive_package_ := exec.archive_package;
            arc_rec_.data_archive_id_      := exec.aoid || '_' || exec.exec_id;
            Init_Variables___(arc_rec_);
            arc_rec_.no_msg_ := Create_Archive_Msg___(arc_rec_, arc_rec_.data_archive_aoid_);
            log_id_ := Write_Log_Start___(arc_rec_);
            @ApproveTransactionStatement(2013-10-23,haarse)
            COMMIT;
            Archive___(arc_rec_);
            arc_rec_.data_archive_stop_date_ := sysdate;
            Write_Log_End___(arc_rec_, log_id_);
            @ApproveTransactionStatement(2013-10-23,haarse)
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               arc_rec_.error_ := TRUE;
               @ApproveTransactionStatement(2013-10-23,haarse)
               ROLLBACK;
               Write_Log_End___(arc_rec_, log_id_);
               @ApproveTransactionStatement(2013-10-23,haarse)
               COMMIT;
         END;
      END LOOP;
   END LOOP;
   @ApproveTransactionStatement(2013-10-23,haarse)
   COMMIT;
END Process_Archive_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Create_Select_Master (
   aoid_       IN VARCHAR2,
   order_id_   IN NUMBER,
   exec_id_    IN VARCHAR2)  RETURN VARCHAR2
IS
   stmt_       VARCHAR2(32000);
   where_      BOOLEAN := FALSE;
   hint_start_ CONSTANT VARCHAR2(3) := chr(47)||chr(42)||chr(43);
   hint_end_   CONSTANT VARCHAR2(2) := chr(42)||chr(47);

   CURSOR get_master IS
      SELECT da.db_link, ds.table_name, ds.table_alias, ds.destination_table_name, ds.where_clause, ds.hint
      FROM   data_archive_object_tab da, data_archive_source_tab ds
      WHERE  da.aoid = aoid_
      AND    da.aoid = ds.aoid
      AND    ds.master_table = 'TRUE';

   CURSOR get_parameter IS
      SELECT column_name, where_clause
      FROM   data_archive_exec_attr_tab dae
      WHERE  order_id = order_id_
      AND    exec_id = exec_id_
      AND    EXISTS (SELECT 1
                     FROM   data_archive_source_tab das
                     WHERE  das.aoid = dae.aoid
                     AND    das.table_name = dae.table_name
                     AND    das.master_table = 'TRUE')
      ORDER BY attr_no;
BEGIN
   FOR master IN get_master LOOP
      stmt_ := 'SELECT ';
      IF ( master.hint IS NOT NULL ) THEN
         stmt_ := stmt_ || hint_start_ || ' ' || master.hint || ' ' || hint_end_ || ' ';
      END IF;
      stmt_ := stmt_ || 'rowid FROM ';
      stmt_ := stmt_ || Lower(master.table_name);
      stmt_ := stmt_ || ' ' || master.table_alias || ' ';
      IF (master.where_clause IS NOT NULL) THEN      
         stmt_ := stmt_ || 'WHERE ' || master.where_clause || ' ';
         where_ := TRUE;
      END IF;
   END LOOP;
   --parameter_msg_ := Message_SYS.Construct('EXECUTION_PARAMETERS');
   FOR param IN get_parameter LOOP
      IF (where_ = TRUE) THEN
         stmt_ := stmt_ || 'AND '  || param.column_name || ' ' || param.where_clause || ' ';
      ELSE
         stmt_ := stmt_ || 'WHERE '  || param.column_name || ' ' || param.where_clause || ' ';
         where_ := TRUE;
      END IF;
      --Message_SYS.Add_Attribute(arc_rec.parameter_msg_, param.column_name, param.where_clause);
   END LOOP;
   stmt_ := stmt_ || ' FOR UPDATE ';
   RETURN( stmt_ );
END Create_Select_Master;


FUNCTION Export_Archive_Package (
   aoid_             IN VARCHAR2 ) RETURN CLOB 
IS
   code_             CLOB;
   lines_            CLOB;
   package_name_     VARCHAR2(30);
   table_no_         NUMBER := 0;
   no_msg_           NUMBER;
   arc_rec_          arc_type;
   
  CURSOR get_object IS
      SELECT do.data_archive_destination
      FROM   data_archive_object_tab do
      WHERE  do.aoid = aoid_;
  
  CURSOR get_table IS
      SELECT table_name, data_archive_type
      FROM   data_archive_source_tab
      START WITH master_table = 'TRUE' AND aoid = aoid_
      CONNECT BY PRIOR table_name = parent_table_name AND PRIOR aoid = aoid;
BEGIN
   no_msg_ := Create_Archive_Msg___(arc_rec_, aoid_);
   
   OPEN  get_object;
   FETCH get_object INTO arc_rec_.data_archive_destination_;
   CLOSE get_object;
   
   code_ := Fnd_Code_Template_API.Get_Template('DataArchivePackage');
   
   -- Replace package_name
   package_name_ := UPPER(aoid_) || '_ARC_API';
   Replace_Tag___('PKG', package_name_, code_);
   Replace_Tag___('SYSDATE', TO_CHAR(sysdate, 'yymmdd'), code_);
   Replace_Tag___('AOID', aoid_, code_);
   Replace_Tag___('AMPERSAND', chr(38), code_);
   
   FOR tabrec IN get_table LOOP
      table_no_ := table_no_ + 1;
      lines_ := lines_ || '   data_archive_type'||to_char(table_no_)||'_        Data_Archive_Source_Tab.data_archive_type%TYPE := '''|| tabrec.data_archive_type||''';'||nl_;
   END LOOP;
   Replace_Tag___('DATA_ARCHIVE_TYPE_DECL', lines_, code_);
   
   Create_Move_Object___(arc_rec_, lines_, aoid_, 'SPEC');
   Replace_Tag___('MOVE_OBJECT_DECL', lines_, code_);
   Create_Move_Object___(arc_rec_, lines_, aoid_, 'BODY');
   Replace_Tag___('MOVE_OBJECT_PROC', lines_, code_);
   
   
   Create_Remove_Object___(lines_, aoid_, 'SPEC');
   Replace_Tag___('REMOVE_OBJECT_DECL', lines_, code_);
   Create_Remove_Object___(lines_, aoid_, 'BODY');
   Replace_Tag___('REMOVE_OBJECT_PROC', lines_, code_);
   
   Create_Archive_Child___(arc_rec_, lines_, aoid_, 'SPEC');
   Replace_Tag___('ARCHIVE_CHILD_DECL', lines_, code_);
   Create_Archive_Child___(arc_rec_, lines_, aoid_, 'BODY');
   Replace_Tag___('ARCHIVE_CHILD_PROC', lines_, code_);
   
   Create_Archive_Master___(arc_rec_, code_, aoid_);
   RETURN(code_);
END Export_Archive_Package;

PROCEDURE Init_Archive_File (
   arc_rec_ IN OUT NOCOPY arc_type )
IS
BEGIN
   Init_Archive_File___(arc_rec_);
END Init_Archive_File;

PROCEDURE End_Archive_File (
   arc_rec_ IN OUT NOCOPY arc_type )
IS
BEGIN
   End_Archive_File___(arc_rec_);
END End_Archive_File;

PROCEDURE Init_Variables (
   arc_rec_ IN OUT NOCOPY arc_type )
IS
BEGIN
   NULL;
END Init_Variables;

@UncheckedAccess
PROCEDURE Line_Buffer_Concat (
   arc_rec_ IN OUT NOCOPY arc_type,
   line_    IN  VARCHAR2 )
IS
BEGIN
   arc_rec_.line_buffer_(arc_rec_.line_no_) := arc_rec_.line_buffer_(arc_rec_.line_no_) || line_;
END Line_Buffer_Concat;

@UncheckedAccess
PROCEDURE Line_Buffer (
   arc_rec_ IN OUT NOCOPY arc_type,
   line_    IN  VARCHAR2 )
IS
BEGIN
   arc_rec_.line_no_ := arc_rec_.line_no_ + 1;
   arc_rec_.line_buffer_(arc_rec_.line_no_) := line_;
END Line_Buffer;

@UncheckedAccess
PROCEDURE Line_Buffer_Value (
   arc_rec_ IN OUT NOCOPY arc_type,
   value_   IN  VARCHAR2 )
IS
BEGIN
   Line_Buffer_Value___(arc_rec_, Format___(value_));
END Line_Buffer_Value;

PROCEDURE Line_Buffer_Value (
   arc_rec_ IN OUT NOCOPY arc_type,
   value_   IN  DATE )
IS
BEGIN
   Line_Buffer_Value___(arc_rec_, Format___(value_));
END Line_Buffer_Value;

PROCEDURE Line_Buffer_Value (
   arc_rec_ IN OUT NOCOPY arc_type,
   value_   IN  NUMBER )
IS
BEGIN
   Line_Buffer_Value___(arc_rec_, Format___(value_));
END Line_Buffer_Value;

PROCEDURE Write_Line_Buffer (
   arc_rec_ IN OUT NOCOPY arc_type )
IS
BEGIN
   Write_Line_Buffer___(arc_rec_);
END Write_Line_Buffer;

@UncheckedAccess
PROCEDURE Remove_Last_Comma (
   arc_rec_ IN OUT NOCOPY arc_type )
IS
BEGIN
   arc_rec_.line_buffer_(arc_rec_.line_no_) := Substr(arc_rec_.line_buffer_(arc_rec_.line_no_), 1, Length(arc_rec_.line_buffer_(arc_rec_.line_no_))-1);
END Remove_Last_Comma;

PROCEDURE Get_All_Rowids (
   rowid_arr_     OUT Rowid_Array_Type,
   no_rowids_     OUT NUMBER,
   stmt_          IN VARCHAR2,
   parent_rowid_  IN ROWID )
IS
   c1_      NUMBER;
   dummy_   NUMBER;
   i_       BINARY_INTEGER := 0;
   rowid_   ROWID;
BEGIN   
   c1_ := dbms_sql.open_cursor;
   -- Safe due to system privilege DEFINE SQL is needed for entering statement in DataArchiveSource
   @ApproveDynamicStatement(2006-05-24,haarse)
   dbms_sql.parse(c1_, stmt_, dbms_sql.native);
   dbms_sql.define_column_rowid(c1_, 1, rowid_);
   IF (parent_rowid_ IS NOT NULL) THEN
      dbms_sql.bind_variable_rowid(c1_, 'rowid_', parent_rowid_);
   END IF;
   dummy_ := dbms_sql.execute(c1_);
   LOOP
      i_ := i_ + 1;
      IF (dbms_sql.fetch_rows(c1_) > 0) THEN
         dbms_sql.column_value_rowid(c1_, 1, rowid_);
         rowid_arr_(i_) := rowid_;
      ELSE
         EXIT;
      END IF;
   END LOOP;
   no_rowids_ := i_ - 1;
   dbms_sql.close_cursor(c1_);
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(c1_)) THEN
         dbms_sql.close_cursor(c1_);
      END IF;
      RAISE;
END Get_All_Rowids;

PROCEDURE Process_Restore (
   aoid_ IN VARCHAR2,
   rowid_ IN ROWID )
IS
   arc_rec_  arc_type;
   CURSOR get_object IS
      SELECT do.data_archive_destination, do.destination_dir,
             do.db_link, do.transaction_size
      FROM   data_archive_object_tab do
      WHERE  do.aoid = aoid_;
BEGIN
   OPEN  get_object;
   FETCH get_object INTO arc_rec_.data_archive_destination_, arc_rec_.data_archive_destination_dir_,
                         arc_rec_.data_archive_db_link_, arc_rec_.data_archive_transaction_size_;
   CLOSE get_object;
   arc_rec_.no_msg_ := Create_Archive_Msg___(arc_rec_, aoid_);
   Restore___(arc_rec_, aoid_, 1, rowid_);
END Process_Restore;
