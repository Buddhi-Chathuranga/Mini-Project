-----------------------------------------------------------------------------
--
--  Logical unit: DataArchiveObject
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000301  HAAR  Created
--  000417  HAAR  ToDo 3945 added function Package_Generated and changed view
--                DATA_ARCHIVE_DBLINK_LOV to ALL_DB_LINKS.
--  000419  HAAR  Moved Drop_Package__, Export_Archive_Package__ and 
--                Process_Restore__ from Data_Archive_Util_API package.
--  000502  HAAR  Changed Check_Master_Stmt___ to procedure and changed error 
--                handling.
--                Changed how to produce the export file in Export_Settings__.
--                Changed name of data and index tablespace in Export_Storage__.
--  011011  HAAR  Bug #25370 - Data Archive uses client values instead of db 
--                             values when generating Archive packages.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030218  ROOD  Changed hardcoded FNDSER to FNDBAS (ToDo#4149).
--  030305  HAAR  Correct view comments (ToDo#4239).
--  040120  HAAR  Copy__ generates wrong Archive package name (Bug#41039).
--  040331  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  050225  JORA  Added assert evaluations to prevent SQL Injection (F1PR481).
--  060105  UTGULK Annotated Sql injection.
--  060526  HAAR  Annotated Sql injection.
--  060621  HAAR  Added support for Persian calendar (Bug#58601).
--  100819  DUWI  Added functionality to create indexes in Export_Storage__ (Bug#91926).
--  101011  ChMu  Modified Export_Settings__ (Bug#93503).  
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Info_Array_Type IS TABLE OF VARCHAR2(32000) INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

ampersand_     CONSTANT VARCHAR2(1) := chr(38);
newline_       CONSTANT VARCHAR2(2) := chr(13)||chr(10);
system_user_   CONSTANT VARCHAR2(30):= 'IFSSYS';
   
@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ACTIVE', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('DATA_ARCHIVE_DESTINATION', Data_Archive_Destination_API.Decode('Oracle Table'), attr_);
   Client_SYS.Add_To_Attr('TRANSACTION_SIZE', 1, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT data_archive_object_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.aoid IS NOT NULL) THEN
      newrec_.aoid := REPLACE(newrec_.aoid, ' ', '_');
      attr_ := Client_SYS.Remove_Attr('AOID', attr_);
   END IF;
   
   IF (newrec_.archive_package IS NULL) THEN
      newrec_.archive_package := upper(newrec_.aoid)||'_ARC_API';
      attr_ := Client_SYS.Remove_Attr('ARCHIVE_PACKAGE', attr_);
   END IF;
   IF (newrec_.transaction_size IS NULL) THEN
      newrec_.transaction_size := 1;
      attr_ := Client_SYS.Remove_Attr('TRANSACTION_SIZE', attr_);
   END IF;
   super(newrec_, indrec_, attr_);
   --Add post-processing code here
END Check_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT DATA_ARCHIVE_OBJECT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.archive_package IS NULL) THEN
      newrec_.archive_package := upper(newrec_.aoid)||'_ARC_API';
   END IF;
   IF (newrec_.transaction_size IS NULL) THEN
      newrec_.transaction_size := 1;
   END IF;
   Client_SYS.Add_To_Attr('ARCHIVE_PACKAGE', newrec_.archive_package, attr_);
   Client_SYS.Add_To_Attr('TRANSACTION_SIZE', newrec_.transaction_size, attr_);
   IF (newrec_.data_archive_destination = Data_Archive_Destination_API.Encode('Oracle Table')) THEN
      NULL; -- Place Oracle table destination checks here
   ELSIF (newrec_.data_archive_destination = Data_Archive_Destination_API.Encode('SQL File')) THEN
      IF (newrec_.destination_dir IS NULL) THEN
         Client_SYS.Add_To_Attr('DESTINATION_DIR', '<Put your directory here.>', attr_);       
      END IF;
   ELSIF (newrec_.data_archive_destination = Data_Archive_Destination_API.Encode('None')) THEN
      NULL; -- Place None destination checks here
   END IF;
   
   newrec_.aoid := replace(newrec_.aoid, ' ', '_');
   newrec_.transaction_size := nvl(newrec_.transaction_size,1);
   
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     DATA_ARCHIVE_OBJECT_TAB%ROWTYPE,
   newrec_     IN OUT DATA_ARCHIVE_OBJECT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   
   IF (newrec_.data_archive_destination = Data_Archive_Destination_API.Encode('Oracle Table')) THEN
      NULL;
   ELSIF (newrec_.data_archive_destination = Data_Archive_Destination_API.Encode('SQL File')) THEN
      IF (newrec_.destination_dir IS NULL) THEN
         Error_Sys.Appl_General(
            'DataArchiveObject', 'NODIR_ERR: Destination directory is mandatory when archiving to SQL file.');
      END IF;
   ELSIF (newrec_.data_archive_destination = Data_Archive_Destination_API.Encode('None')) THEN
      NULL;
   END IF;
/*
   --
   -- If the archive object is inactivated, inactivate order executions which uses the specified archive object
   --
   IF (newrec_.active = 'FALSE') THEN
      Data_Archive_Util_API.Inacivate_Executions(newrec_.aoid, newrec_.active);
   END IF;
   */
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Stmt___(
   stmt_          IN VARCHAR2) 
IS
   c1_      NUMBER;
BEGIN
   c1_ := dbms_sql.open_cursor;
   -- Safe due to system privilege DEFINE SQL is needed for entering statement in DataArchiveSource
   @ApproveDynamicStatement(2006-05-24,haarse)
   dbms_sql.parse(c1_, stmt_, dbms_sql.native);
   dbms_sql.close_cursor(c1_);
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(c1_)) THEN
         dbms_sql.close_cursor(c1_);
      END IF;
      RAISE;
END Check_Stmt___;

FUNCTION Create_Table_Statement___ (
   table_name_       IN VARCHAR2,
   dest_table_name_  IN VARCHAR2,
   tablespace_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   stmt_   VARCHAR2(32000);
   
   CURSOR get_columns IS
      SELECT '   '||column_name column_name,
             Decode(data_type,
             'VARCHAR',  'VARCHAR2'||'('||Data_Length||')',
             'VARCHAR2', 'VARCHAR2'||'('||Data_Length||')',
             'CHAR',     'VARCHAR2'||'('||Data_Length||')',
             'INTEGER',  'NUMBER',
             'FLOAT',    'NUMBER',
             data_type) data_type
      FROM   User_Tab_Columns
      WHERE  table_name = table_name_
      AND    data_type NOT IN ('LONG', 'CLOB', 'BLOB', 'LONG RAW', 'RAW')
      AND    column_name NOT IN ('DATA_ARCHIVE_ID', 'DATA_ARCHIVE_DATE') -- These are generated in archive_move
      ORDER BY column_id;

BEGIN
   stmt_ := 'CREATE TABLE '||dest_table_name_||'('||newline_;
   FOR col IN get_columns LOOP
      stmt_ := stmt_ || col.column_name || ' ' || col.data_type || ',' || newline_;
   END LOOP;
   stmt_ := Substr(stmt_, 1, Length(stmt_) - Length(','||newline_))||' ) '||newline_;
   stmt_ := stmt_ || 'TABLESPACE '||tablespace_name_;
   RETURN(stmt_);
END Create_Table_Statement___;

FUNCTION Create_Alter_Statement___ (
   dest_table_name_  IN VARCHAR2,
   column_name_      IN VARCHAR2, 
   data_type_        IN VARCHAR2 ) RETURN VARCHAR2
IS 
BEGIN
   RETURN('ALTER TABLE '||dest_table_name_||' ADD '||column_name_||' '||data_type_);
END Create_Alter_Statement___;

FUNCTION Create_Pk_Statement___ (
   table_name_       IN VARCHAR2,
   dest_table_name_  IN VARCHAR2,
   tablespace_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS 
BEGIN
   RETURN('ALTER TABLE '||dest_table_name_||newline_||
          'ADD ( CONSTRAINT '||substr(table_name_, 1, length(table_name_)-4)||'_PKA PRIMARY KEY ( '||Get_Primary_Keys___(table_name_)||' )'||newline_||
                              'USING INDEX'||newline_||
                              'TABLESPACE '||tablespace_name_||')');
END Create_Pk_Statement___;

FUNCTION Create_Grant_Statement___ (
   table_name_    IN VARCHAR2,
   user_          IN VARCHAR2 ) RETURN VARCHAR2
IS 
BEGIN
   RETURN('GRANT SELECT ON '||table_name_||' TO '||user_);
END Create_Grant_Statement___;

FUNCTION Create_Index_Statement___ (
   table_name_       IN VARCHAR2,
   tablespace_name_  IN VARCHAR2,
   column_name_      IN VARCHAR2,
   index_no_         IN NUMBER ) RETURN VARCHAR2
IS 
BEGIN
   RETURN('CREATE INDEX '||Substr(table_name_, 1, length(table_name_)-4)||'_AX'||index_no_||' ON '||table_name_||' ('||column_name_||')'||newline_||'TABLESPACE '||tablespace_name_||')');
END Create_Index_Statement___;

FUNCTION Format___ (
   value_  IN  VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(''''||Replace(value_, '''', '''''')||'''');
END Format___;

FUNCTION Format___ (
   value_  IN  NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN(value_);
END Format___;

FUNCTION Format___ (
   value_  IN  DATE ) RETURN VARCHAR2
IS
BEGIN
   IF (value_ IS NULL) THEN
      RETURN('Database_SYS.Get_Last_Calendar_Date');
   ELSE
      RETURN('To_Date('''||To_Char(value_,'YYYYMMDD HH24MISS')||''',''YYYYMMDD HH24MISS'')');
   END IF;
END Format___;

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

PROCEDURE Pack_Array___ (
   count_        OUT NUMBER,
   string_array_ IN OUT Info_Array_Type,
   index_        IN     BINARY_INTEGER )
IS
   tmp_  VARCHAR2(32000);
   j_     BINARY_INTEGER := 0;
BEGIN
   FOR i IN 1..index_ LOOP
      BEGIN
         tmp_ := tmp_ || string_array_(i) || newline_;
         string_array_(i) := NULL;
      EXCEPTION
         WHEN value_error THEN
            j_ := j_ + 1;
            string_array_(j_) := tmp_;
            tmp_ := NULL;
            tmp_ := string_array_(i) || newline_;
      END;
   END LOOP;
   IF (tmp_ IS NOT NULL) THEN
      j_ := j_ + 1;
      string_array_(j_) := tmp_;
   END IF;
   count_ := j_;
END Pack_Array___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Check_Master_Stmt__(
   stmt_    OUT VARCHAR2,
   aoid_    IN  VARCHAR2 )
IS
   statement_  VARCHAR2(32000);
BEGIN
   statement_ := Data_Archive_Util_API.Create_Select_Master(aoid_, NULL, NULL);
   Check_Stmt___(statement_);
   stmt_ := statement_;
END Check_Master_Stmt__;

PROCEDURE Copy__ (
   aoid_ IN VARCHAR2,
   new_aoid_ IN VARCHAR2,
   new_description_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     DATA_ARCHIVE_OBJECT_TAB%ROWTYPE;
   sourcerec_  DATA_ARCHIVE_SOURCE_TAB%ROWTYPE;
   attrrec_    DATA_ARCHIVE_SOURCE_ATTR_TAB%ROWTYPE;
   attr_       VARCHAR2(32000);

   table_name_    Data_Archive_Source_Tab.table_name%TYPE;

   CURSOR get_object IS
      SELECT *
      FROM   Data_Archive_Object_Tab
      WHERE  aoid = aoid_;
   CURSOR get_source IS
      SELECT *
      FROM   data_archive_source_tab
      START WITH master_table = 'TRUE' AND aoid = aoid_
      CONNECT BY PRIOR table_name = parent_table_name AND PRIOR aoid = aoid;
   CURSOR get_attr IS
      SELECT *
      FROM   Data_Archive_Source_Attr_Tab
      WHERE  aoid = aoid_
      AND    table_name = table_name_
      ORDER BY seq_no;
BEGIN
   FOR obj IN get_object LOOP
      objrec_ := NULL;
      objrec_.aoid := new_aoid_;
      objrec_.description := new_description_;
      objrec_.active := 'FALSE';
      objrec_.transaction_size := obj.transaction_size;
      objrec_.db_link := obj.db_link;
      objrec_.destination_dir := obj.destination_dir;
      objrec_.data_archive_destination := obj.data_archive_destination;
      objrec_.archive_package := upper(new_aoid_)||'_ARC_API';
      Insert___ (objid_, objversion_, objrec_, attr_);
      FOR source IN get_source LOOP
         sourcerec_ := NULL;
         table_name_ := source.table_name;
         sourcerec_.aoid := new_aoid_;
         sourcerec_.table_name := source.table_name;
         sourcerec_.description := source.description;
         sourcerec_.table_alias := source.table_alias;
         sourcerec_.destination_table_name := source.destination_table_name;
         sourcerec_.master_table := source.master_table;
         sourcerec_.hint := source.hint;
         sourcerec_.where_clause := source.where_clause;
         sourcerec_.data_archive_type := source.data_archive_type;
         sourcerec_.parent_table_name := source.parent_table_name;
         Data_Archive_Source_API.Insert__ (objid_, objversion_, sourcerec_, attr_);
         FOR attr IN get_attr LOOP
            attrrec_ := NULL;
            attrrec_.aoid := new_aoid_;
            attrrec_.table_name := attr.table_name;
            attrrec_.column_name := attr.column_name;
            attrrec_.primary_key := attr.primary_key;
            attrrec_.parent_key_name := attr.parent_key_name;
            attrrec_.seq_no := attr.seq_no;
            attrrec_.when_ordered := attr.when_ordered;
            attrrec_.create_index := attr.create_index;
            Data_Archive_Source_Attr_API.Insert__ (objid_, objversion_, attrrec_, attr_);
         END LOOP;
      END LOOP;
   END LOOP;
END Copy__;


PROCEDURE Drop_Package__ (
   aoid_ IN VARCHAR2 )
IS
   cursor_          NUMBER;
   stmt_            VARCHAR2(2000);
   cnt_             NUMBER;
   archive_package_ VARCHAR2(30);

   CURSOR get_package IS
      SELECT archive_package
      FROM   data_archive_object_tab
      WHERE  aoid = aoid_;
BEGIN
   OPEN  get_package;
   FETCH get_package INTO archive_package_;
   CLOSE get_package;
   Assert_SYS.Assert_Is_Package(archive_package_);
   stmt_ := 'DROP PACKAGE '||archive_package_;
   cursor_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2006-01-05,utgulk)
   dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
   cnt_ := dbms_sql.execute(cursor_);
   dbms_sql.close_cursor(cursor_);
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cursor_)) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
END Drop_Package__;

FUNCTION Export_Archive_Package__ (
   aoid_             IN VARCHAR2 ) RETURN CLOB 
IS
BEGIN
   RETURN(Data_Archive_Util_API.Export_Archive_Package(aoid_));
END Export_Archive_Package__;

FUNCTION Export_Settings__ (
   aoid_             IN VARCHAR2 ) RETURN CLOB 
IS
   table_name_    Data_Archive_Source_Tab.table_name%TYPE;
   string_        CLOB;

   CURSOR get_object IS
      SELECT *
      FROM   Data_Archive_Object_Tab
      WHERE  aoid = aoid_;
   CURSOR get_source IS
      SELECT *
      FROM   data_archive_source_tab
      START WITH master_table = 'TRUE' AND aoid = aoid_
      CONNECT BY PRIOR table_name = parent_table_name AND PRIOR aoid = aoid;
   CURSOR get_attr IS
      SELECT *
      FROM   Data_Archive_Source_Attr_Tab
      WHERE  aoid = aoid_
      AND    table_name = table_name_
      ORDER BY seq_no;
BEGIN
   string_ := 'DECLARE' || newline_;
   string_ := string_ || '   aoid_       VARCHAR2(30) := ' || Format___(aoid_) || ';' || newline_;
   string_ := string_ || '   info_msg_   VARCHAR2(32000);' || newline_;
   string_ := string_ || '   PROCEDURE Archive_Object (' || newline_;
   string_ := string_ || '      aoid_                     IN VARCHAR2,' || newline_;
   string_ := string_ || '      description_              IN VARCHAR2,' || newline_;
   string_ := string_ || '      active_                   IN VARCHAR2,' || newline_;
   string_ := string_ || '      transaction_size_         IN NUMBER,' || newline_;
   string_ := string_ || '      db_link_                  IN VARCHAR2,' || newline_;
   string_ := string_ || '      destination_dir_          IN VARCHAR2,' || newline_;
   string_ := string_ || '      archive_package_          IN VARCHAR2,' || newline_;
   string_ := string_ || '      data_archive_destination_ IN VARCHAR2 )' || newline_;
   string_ := string_ || '   IS' || newline_;
   string_ := string_ || '   BEGIN' || newline_;
   string_ := string_ || '      info_msg_ := NULL;' || newline_;
   string_ := string_ || '      info_msg_ := Message_SYS.Construct(''DATA_ARCHIVE_OBJECT_TAB'');' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''DESCRIPTION'', description_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''ACTIVE'', active_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''TRANSACTION_SIZE'', transaction_size_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''DB_LINK'', db_link_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''DESTINATION_DIR'', destination_dir_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''DATA_ARCHIVE_DESTINATION'', data_archive_destination_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''ARCHIVE_PACKAGE'', archive_package_);' || newline_;
   string_ := string_ || '      Data_Archive_SYS.Register_Object(aoid_, info_msg_);' || newline_;
   string_ := string_ || '   END Archive_Object;' || newline_ || newline_;
   string_ := string_ || '   PROCEDURE Archive_Source (' || newline_;
   string_ := string_ || '      aoid_                     IN VARCHAR2,' || newline_;
   string_ := string_ || '      table_name_               IN VARCHAR2,' || newline_;
   string_ := string_ || '      description_              IN VARCHAR2,' || newline_;
   string_ := string_ || '      table_alias_              IN VARCHAR2,' || newline_;
   string_ := string_ || '      destination_table_name_   IN VARCHAR2,' || newline_;
   string_ := string_ || '      master_table_             IN VARCHAR2,' || newline_;
   string_ := string_ || '      hint_                     IN VARCHAR2,' || newline_;
   string_ := string_ || '      where_clause_             IN VARCHAR2,' || newline_;
   string_ := string_ || '      data_archive_type_        IN VARCHAR2,' || newline_;
   string_ := string_ || '      parent_table_name_        IN VARCHAR2 )' || newline_;
   string_ := string_ || '   IS' || newline_;
   string_ := string_ || '   BEGIN' || newline_;
   string_ := string_ || '      info_msg_ := NULL;' || newline_;
   string_ := string_ || '      info_msg_ := Message_SYS.Construct(''DATA_ARCHIVE_SOURCE_TAB'');' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''DESCRIPTION'', description_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''TABLE_ALIAS'', table_alias_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''DESTINATION_TABLE_NAME'', destination_table_name_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''MASTER_TABLE'', master_table_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''HINT'', hint_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''WHERE_CLAUSE'', where_clause_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''DATA_ARCHIVE_TYPE'', data_archive_type_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''PARENT_TABLE_NAME'', parent_table_name_);' || newline_;
   string_ := string_ || '      Data_Archive_SYS.Register_Source(aoid_, table_name_, info_msg_);' || newline_;
   string_ := string_ || '   END Archive_Source;' || newline_ || newline_;
   string_ := string_ || '   PROCEDURE Archive_Source_Attr (' || newline_;
   string_ := string_ || '      aoid_                     IN VARCHAR2,' || newline_;
   string_ := string_ || '      table_name_               IN VARCHAR2,' || newline_;
   string_ := string_ || '      column_name_              IN VARCHAR2,' || newline_;
   string_ := string_ || '      primary_key_              IN VARCHAR2,' || newline_;
   string_ := string_ || '      parent_key_name_          IN VARCHAR2,' || newline_;
   string_ := string_ || '      seq_no_                   IN NUMBER,' || newline_;
   string_ := string_ || '      when_ordered_             IN VARCHAR2,' || newline_;
   string_ := string_ || '      create_index_             IN VARCHAR2 )' || newline_;
   string_ := string_ || '   IS' || newline_;
   string_ := string_ || '   BEGIN' || newline_;
   string_ := string_ || '      info_msg_ := NULL;' || newline_;
   string_ := string_ || '      info_msg_ := Message_SYS.Construct(''DATA_ARCHIVE_SOURCE_ATTR_TAB'');' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''PRIMARY_KEY'', primary_key_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''PARENT_KEY_NAME'', parent_key_name_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''SEQ_NO'', seq_no_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''WHEN_ORDERED'', when_ordered_);' || newline_;
   string_ := string_ || '      Message_SYS.Add_Attribute(info_msg_, ''CREATE_INDEX'', create_index_);' || newline_;
   string_ := string_ || '      Data_Archive_SYS.Register_Source_Attr(aoid_, table_name_, column_name_, info_msg_);' || newline_;
   string_ := string_ || '   END Archive_Source_Attr;' || newline_;
   string_ := string_ || 'BEGIN'|| newline_;
   FOR obj IN get_object LOOP
      string_ := string_ || '   Archive_Object(aoid_, ' || Format___(obj.description) || ', ''FALSE'','||
                               Format___(obj.transaction_size) || ', ' || Format___(obj.db_link) || ', ' || Format___(obj.destination_dir) || ', ' ||
                               Format___(obj.archive_package) || ', ' ||Format___(obj.data_archive_destination) || ');' || newline_;
      FOR source IN get_source LOOP
         table_name_ := source.table_name;
         string_ := string_ || '   Archive_Source(aoid_, ' || Format___(table_name_) || ',' || Format___(source.description) || ', '||
                                  Format___(source.table_alias) || ', ' || Format___(source.destination_table_name) || ', ' || Format___(source.master_table) || ', ' ||
                                  Format___(source.hint) || ', ' ||Format___(source.where_clause) || ', ' ||Format___(source.data_archive_type) || ', ' ||Format___(source.parent_table_name) || ');' || newline_;
         FOR attr IN get_attr LOOP
            string_ := string_ || '   Archive_Source_Attr(aoid_, ' || Format___(table_name_) || ',' || Format___(attr.column_name) || ', '||
                                     Format___(attr.primary_key) || ', ' || Format___(attr.parent_key_name) || ', ' || Format___(attr.seq_no) || ', ' ||
                                     Format___(attr.when_ordered) || ', ' || Format___(attr.create_index) ||');' || newline_;
         END LOOP;
      END LOOP;
   END LOOP;
   string_ := string_  || 'END;' || newline_;
   string_ := string_ || '/' || newline_;
   RETURN(string_);
END Export_Settings__;

FUNCTION Export_Storage__ (
   aoid_             IN VARCHAR2 ) RETURN CLOB 
IS
   db_link_                   VARCHAR2(50);
   data_archive_destination_  data_archive_object_tab.data_archive_destination%TYPE;
   table_name_                VARCHAR2(30);
   destination_table_name_    VARCHAR2(30);
   string_                    CLOB;

   -- For indexes creating
   index_no_  NUMBER;

   CURSOR get_object IS
      SELECT data_archive_destination, decode(db_link, NULL, NULL, '@'||db_link) db_link
      FROM   data_archive_object_tab
      WHERE  aoid = aoid_;

   CURSOR get_source IS
      SELECT table_name, destination_table_name, parent_table_name, level, master_table, data_archive_type
      FROM   data_archive_source_tab
      START WITH master_table = 'TRUE' AND aoid = aoid_
      CONNECT BY PRIOR table_name = parent_table_name AND PRIOR aoid = aoid;

    CURSOR get_index_columns(table_ VARCHAR2) IS
      SELECT column_name
      FROM  data_archive_source_attr_tab
      WHERE table_name = table_ 
      AND   create_index = 'TRUE'; 
    
BEGIN
   OPEN  get_object;
   FETCH get_object INTO data_archive_destination_, db_link_;
   CLOSE get_object;
   IF (data_archive_destination_ NOT IN ('Oracle Table')) THEN -- Oracle table
      Error_Sys.Appl_General(
         'DataArchiveObject', 'STORAGEERR: Can only create storage for destination Oracle Table.');
   END IF;
   string_ := '-----------------------------------------------------------------------------'||newline_||
              '--'||newline_||
              '--  Module: FNDBAS (Archiving)'||newline_||
              '--'||newline_||
              '--  Date    Sign  History'||newline_||
              '--  ------  ----  -----------------------------------------------------------'||newline_||
              '--  '||to_char(sysdate,'YYMMDD')||'        Created by archiving'||newline_||
              '--'||newline_||
              '-----------------------------------------------------------------------------'||newline_||newline_||
              '-----------------------------------------------------------------------------'||newline_||
              '-------------------- TABLES AND INDEXES -------------------------------------'||newline_||
              '-----------------------------------------------------------------------------'||newline_||newline_||
              'SET DEFINE "'||ampersand_||'"'||newline_||
              'PROMPT Creating tables and indexes'||newline_||newline_||
              'DEFINE archive_data = '||ampersand_||'archive_data'||newline_||
              'DEFINE archive_index = '||ampersand_||'archive_index'||newline_;
          --||'DEFINE normal = '||ampersand_||'normal'||newline_||newline_;

   FOR source IN get_source LOOP
      table_name_ := source.table_name;
      destination_table_name_ := source.destination_table_name;
      string_ := string_ ||newline_|| Create_Table_Statement___(table_name_, destination_table_name_, ampersand_||'archive_data') || newline_||'/';
      string_ := string_ ||newline_|| Create_Alter_Statement___(destination_table_name_, 'DATA_ARCHIVE_DATE', 'DATE') || newline_||'/';
      string_ := string_ ||newline_|| Create_Alter_Statement___(destination_table_name_, 'DATA_ARCHIVE_ID', 'VARCHAR2(55)') || newline_||'/';
      string_ := string_ ||newline_|| Create_Pk_Statement___(table_name_, destination_table_name_, ampersand_||'archive_index') || newline_||'/';
      string_ := string_ ||newline_|| Create_Grant_Statement___(destination_table_name_, system_user_) || newline_||'/'||newline_||newline_;

      index_no_ := 0;
      FOR index_col IN get_index_columns(table_name_) LOOP
        IF index_no_ = 10 THEN
           Error_Sys.Appl_General('DataArchiveObject', 'TOOMANYINDEXS: Please reduce the created indexes in :P1. Maximum 10 indexes are allowed in destination Table', table_name_);
        END IF;
        index_no_ := index_no_ + 1;
        string_ := string_ ||newline_|| Create_Index_Statement___(destination_table_name_,  ampersand_||'archive_index', index_col.column_name, index_no_)||newline_||'/';
     END LOOP;
   END LOOP;
   RETURN(string_);
END Export_Storage__;

PROCEDURE Generate_Code__ (
   aoid_             IN VARCHAR2,
   tablespace_name_  IN VARCHAR2,
   indexspace_name_  IN VARCHAR2 )
IS
   db_link_                   VARCHAR2(50);
   data_archive_destination_  data_archive_object_tab.data_archive_destination%TYPE;
   table_name_                VARCHAR2(30);
   destination_table_name_    VARCHAR2(30);

   -- For indexes creating
   index_no_ NUMBER;

   CURSOR get_object IS
      SELECT data_archive_destination, decode(db_link, NULL, NULL, '@'||db_link) db_link
      FROM   data_archive_object_tab
      WHERE  aoid = aoid_;

   CURSOR get_source IS
      SELECT table_name, destination_table_name, parent_table_name, level, master_table, data_archive_type
      FROM   data_archive_source_tab
      START WITH master_table = 'TRUE' AND aoid = aoid_
      CONNECT BY PRIOR table_name = parent_table_name AND PRIOR aoid = aoid;

    CURSOR get_index_columns(table_ VARCHAR2) IS
      SELECT column_name
      FROM  data_archive_source_attr_tab
      WHERE table_name = table_ 
      AND   create_index = 'TRUE'; 
    
    PROCEDURE Deploy___ (
       stmt_ IN VARCHAR2 )
    IS
    BEGIN
       Log_SYS.Fnd_Trace_(Log_SYS.trace_, stmt_);
       -- Safe due to system privilege DEFINE SQL is needed for entering statement in DataArchiveSource
       @ApproveDynamicStatement(2014-08-29,haarse)
       EXECUTE IMMEDIATE stmt_;
    END Deploy___;
    
BEGIN
   OPEN  get_object;
   FETCH get_object INTO data_archive_destination_, db_link_;
   CLOSE get_object;
   IF (data_archive_destination_ NOT IN ('Oracle Table')) THEN -- Oracle table
      Error_Sys.Appl_General('DataArchiveObject', 'STORAGEERR2: Can only generate code for destination Oracle Table.');
   END IF;
   FOR source IN get_source LOOP
      table_name_ := source.table_name;
      destination_table_name_ := source.destination_table_name;
      Assert_SYS.Assert_Is_Table(table_name_);
      Assert_SYS.Assert_Is_Table(destination_table_name_);
      Assert_SYS.Assert_Is_Tablespace(tablespace_name_);
      Assert_SYS.Assert_Is_Tablespace(indexspace_name_);
      Assert_SYS.Assert_Is_User(system_user_);
      Deploy___(Create_Table_Statement___(table_name_, destination_table_name_, tablespace_name_));
      Deploy___(Create_Alter_Statement___(destination_table_name_, 'DATA_ARCHIVE_DATE', 'DATE'));
      Deploy___(Create_Alter_Statement___(destination_table_name_, 'DATA_ARCHIVE_ID', 'VARCHAR2(55)'));
      Deploy___(Create_Pk_Statement___(table_name_, destination_table_name_, indexspace_name_));
      Deploy___(Create_Grant_Statement___(destination_table_name_, system_user_));
      index_no_ := 0;
      FOR index_col IN get_index_columns(table_name_) LOOP
        IF index_no_ = 10 THEN
           Error_Sys.Appl_General('DataArchiveObject', 'TOOMANYINDEXS: Please reduce the created indexes in :P1. Maximum 10 indexes are allowed in destination Table', table_name_);
        END IF;
        Assert_SYS.Assert_Is_Table_Column(destination_table_name_, index_col.column_name);
        Deploy___(Create_Index_Statement___(destination_table_name_, indexspace_name_, index_col.column_name, index_no_));
     END LOOP;
   END LOOP;
END Generate_Code__;


PROCEDURE Process_Restore__ (
   aoid_ IN VARCHAR2,
   rowid_ IN ROWID )
IS
BEGIN
   Data_Archive_Util_API.Process_Restore(aoid_, rowid_);
END Process_Restore__;


PROCEDURE Register__ (
   aoid_ IN VARCHAR2,
   info_msg_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     DATA_ARCHIVE_OBJECT_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   objrec_.aoid := aoid_;
   objrec_.description := Message_SYS.Find_Attribute(info_msg_, 'DESCRIPTION', '');
   objrec_.active := 'FALSE';
   objrec_.transaction_size := Message_SYS.Find_Attribute(info_msg_, 'TRANSACTION_SIZE', '');
   objrec_.db_link := Message_SYS.Find_Attribute(info_msg_, 'DB_LINK', '');
   objrec_.destination_dir := Message_SYS.Find_Attribute(info_msg_, 'DESTINATION_DIR', '');
   objrec_.data_archive_destination := Message_SYS.Find_Attribute(info_msg_, 'DATA_ARCHIVE_DESTINATION', '');
   objrec_.archive_package := Message_SYS.Find_Attribute(info_msg_, 'ARCHIVE_PACKAGE', '');
   Get_Id_Version_By_Keys___ (objid_, objversion_, aoid_);
   IF (objid_ IS NOT NULL) THEN 
      objrec_ := Lock_By_Keys___ (aoid_);
      Delete___ (objid_, objrec_);
   END IF;
   Insert___ (objid_, objversion_, objrec_, attr_);
END Register__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Package_Generated (
   aoid_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   tmp_date_      DATE;
   aoid_date_     DATE;
   package_date_  DATE;

   CURSOR get_aoid_date1 IS
      SELECT max(rowversion)
      FROM data_archive_object_tab
      WHERE aoid = aoid_;

   CURSOR get_aoid_date2 IS
      SELECT max(rowversion)
      FROM data_archive_source_tab
      WHERE aoid = aoid_;

   CURSOR get_aoid_date3 IS
      SELECT max(rowversion)
      FROM data_archive_source_attr_tab
      WHERE aoid = aoid_;

   CURSOR get_package_date IS
      SELECT last_ddl_time 
      FROM user_objects
      WHERE object_name = aoid_||'ARC_API' AND object_type = 'PACKAGE BODY';
BEGIN
   OPEN  get_aoid_date1;
   FETCH get_aoid_date1 INTO aoid_date_;
   CLOSE get_aoid_date1;
   OPEN  get_aoid_date2;
   FETCH get_aoid_date2 INTO tmp_date_;
   CLOSE get_aoid_date2;
   aoid_date_ := greatest(aoid_date_, nvl(tmp_date_, Database_SYS.Get_First_Calendar_Date));
   OPEN  get_aoid_date3;
   FETCH get_aoid_date3 INTO tmp_date_;
   CLOSE get_aoid_date3;
   aoid_date_ := greatest(aoid_date_, nvl(tmp_date_, Database_SYS.Get_First_Calendar_Date));
   OPEN  get_package_date;
   FETCH get_package_date INTO package_date_;
   CLOSE get_package_date;
   IF (aoid_date_ > nvl(package_date_, Database_SYS.Get_First_Calendar_Date)) THEN
      RETURN(FALSE);
   ELSE
      RETURN(TRUE);
   END IF;
END Package_Generated;
