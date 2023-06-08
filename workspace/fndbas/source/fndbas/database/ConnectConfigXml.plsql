-----------------------------------------------------------------------------
--
--  Logical unit: ConnectConfigXml
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -----------------------------------------------------
--  2019-11-07  japase  Created (PACZDATA-1753, PACZDATA-1733)
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Import_Result IS RECORD (
   total   INTEGER := 0,
   added   INTEGER := 0,
   updated INTEGER := 0,
   deleted INTEGER := 0
);

-- private declaration that must be in the package specification

TYPE Instance__ IS RECORD (
   db_name    VARCHAR2(30),
   elem_id    INTEGER, --Plsqlap_Document_API.Element_Id,
   parent_val VARCHAR2(500),
   key_val    VARCHAR2(500),
   objid      VARCHAR2(100),
   objversion VARCHAR2(40)
);
TYPE Instance_Table__ IS TABLE OF Instance__ INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Binary_Column IS RECORD (
   name  VARCHAR2(30),
   data  BLOB
);

TYPE Entity_Attribute IS RECORD (
   attr_name   VARCHAR2(50),
   attr_value  VARCHAR2(4000)
);
TYPE Entity_Attr_Map IS TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(50);

TYPE Custom_Attrs IS TABLE OF Entity_Attribute INDEX BY BINARY_INTEGER;

TYPE Preserved_Instances IS TABLE OF Instance_Table__ INDEX BY VARCHAR2(50);

TYPE Col_Lists IS RECORD (
   col_list      VARCHAR2(4000),
   char_col_list VARCHAR2(4000)
);
TYPE Col_List_Map IS TABLE OF Col_Lists INDEX BY VARCHAR2(50);

-- list of groups supported by this utility in order allowing removal
TYPE Group_List IS VARRAY(20) OF VARCHAR2(30);
GROUPS CONSTANT Group_List := Group_List (
      'ROUTING_RULE',
      'ROUTING_ADDRESS',
      'CONNECT_PRINT_AGENT_TASK',
      'CONNECT_READER',
      'CONNECT_SENDER',
      'CONNECT_ENVELOPE',
      'CONNECT_QUEUE',
      'CONNECT_SIMPLE_ROUTING',
      'CONNECT_SERVER',
      'CONNECT_TRANSFORMER',
      'CONNECT_PROPERTY',
      'CUSTOM_CONNECTOR_LIBRARY',
      'CUSTOM_READER_PARAM',
      'CUSTOM_SENDER_PARAM');

-- variables user only for timing measurment
start_      NUMBER;
fetch_cols_ NUMBER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Trace___ (
   text_ IN VARCHAR2 DEFAULT NULL)
IS
   time_ NUMBER := Dbms_Utility.Get_Time;
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.trace_, '{'||lpad((time_-start_)/100,5)||'}: '||text_);
   --Dbms_Output.Put_Line('{'||lpad((time_-start_)/100,5)||'}: '||text_);
END Trace___;


PROCEDURE Debug_Attr_Str___ (
   text_     IN VARCHAR2,
   attr_str_ IN VARCHAR2)
IS
BEGIN
   Trace___(text_||' ['||replace(replace(attr_str_, chr(31), '='), chr(30), '^')||']');
END Debug_Attr_Str___;


-- checks if the given group is on the list of supported groups
PROCEDURE Check_Group___ (
   group_name_ IN VARCHAR2)
IS
BEGIN
   Trace___('Checking group ['||group_name_||']');
   FOR i IN 1..GROUPS.count LOOP
      IF group_name_ = GROUPS(i) THEN
         RETURN;
      END IF;
   END LOOP;
   Error_SYS.Appl_General(lu_name_, 'CONNCFGEXPGRP: Invalid group name [:P1]', group_name_);
END Check_Group___;


-- returns column name for the parent key column
FUNCTION Get_Parent_Key___ (
   db_name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN
      CASE upper(db_name_)
         WHEN 'CUSTOM_CONNECTOR_LIBRARY' THEN 'group_name'
         WHEN 'CUSTOM_READER_PARAM'      THEN 'instance_name'
         WHEN 'CUSTOM_SENDER_PARAM'      THEN 'instance_name'
         WHEN 'PRINTER_MAPPING'          THEN 'template_instance_name'
         WHEN 'ROUTING_RULE_CONDITION'   THEN 'rule_name'
         WHEN 'ROUTING_RULE_ADDRESS'     THEN 'rule_name'
         ELSE                                 NULL
      END;
END Get_Parent_Key___;


-- returns column name for the key column
FUNCTION Get_Key___ (
   db_name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN
      CASE upper(db_name_)
         WHEN 'ROUTING_RULE'             THEN 'rule_name'
         WHEN 'ROUTING_ADDRESS'          THEN 'address_name'
         WHEN 'CUSTOM_CONNECTOR_LIBRARY' THEN 'instance_name'
         WHEN 'CONNECT_READER'           THEN 'instance_name'
         WHEN 'CUSTOM_READER_PARAM'      THEN 'parameter_name'
         WHEN 'CONNECT_SENDER'           THEN 'instance_name'
         WHEN 'CUSTOM_SENDER_PARAM'      THEN 'parameter_name'
         WHEN 'PRINTER_MAPPING'          THEN 'logical_printer_id'
         WHEN 'ROUTING_RULE_CONDITION'   THEN 'seq_no'
         WHEN 'ROUTING_RULE_ADDRESS'     THEN 'address_name'
         WHEN 'CONNECT_PROPERTY'         THEN 'property_name'
         ELSE                                 'instance_name'
      END;
END Get_Key___;


-- returns TRUE if the specified column is of type BLOB
FUNCTION Is_Binary_Column___ (
   col_name_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN upper(col_name_) IN ('JAR_FILE', 'TRANS_FILE_CONTENT', 'ENVELOPE_FILE_CONTENT');
END Is_Binary_Column___;


-- parses string of key values (instance names, address names, rule names...)
-- separated with '^' character and used to define objects to be exported
-- to a temporary table; returns number of values in the list
FUNCTION Parse_Selector_Values___ (
   values_ IN VARCHAR2 ) RETURN INTEGER
IS
   len_   INTEGER := length(values_);
   p1_    INTEGER := 1;
   p2_    INTEGER;
   cnt_   INTEGER := 0;
BEGIN
   DELETE FROM connect_config_xml_tmp_tab;
   WHILE p1_ <= len_ LOOP
      p2_ := instr(values_, '^', p1_);
      IF p2_ = 0 THEN
         p2_ := len_ + 1;
      END IF;
      INSERT INTO connect_config_xml_tmp_tab VALUES(trim(substr(values_, p1_, p2_ - p1_)));
      cnt_ := cnt_ + 1;
      p1_ := p2_ + 1;
   END LOOP;
   RETURN cnt_;
END Parse_Selector_Values___;


-- fetches list of columnt that need to be transformed, either using Base64
-- or Export_<column_name>_ / Import_<column_name>_ functions
PROCEDURE Fetch_Transformed_Columns___ (
   db_name_      IN     VARCHAR2,
   hidden_cols_  IN OUT VARCHAR2,
   special_cols_ IN OUT VARCHAR2)
IS
   pkg_name_  VARCHAR2(30) := db_name_||'_API';
   proc_name_ VARCHAR2(30) := 'Xml_Transformed_Columns_';
   t1_        NUMBER := Dbms_Utility.Get_Time;

   FUNCTION Prepare_List(list_ VARCHAR2) RETURN VARCHAR2 IS
   BEGIN
      RETURN CASE list_ IS NULL WHEN TRUE THEN NULL ELSE ','||upper(replace(list_,' '))||',' END;
   END;

BEGIN
   IF Installation_SYS.Method_Exist(pkg_name_, proc_name_) THEN
      @ApproveDynamicStatement(2019-11-27,japase)
      EXECUTE IMMEDIATE 'BEGIN '||pkg_name_||'.'||proc_name_||'(:hidden_, :special_); END;'
      USING OUT hidden_cols_, OUT special_cols_;
      hidden_cols_  := Prepare_List(hidden_cols_);
      special_cols_ := Prepare_List(special_cols_);
   END IF;
   Trace___('  - special columns for ['||db_name_||']: hidden_cols_:  ['||hidden_cols_||'], special_cols_: ['||special_cols_||']'||
            ' (checked/fetched in #'||to_char((Dbms_Utility.Get_Time-t1_)/100)||' sec)');
END Fetch_Transformed_Columns___;


-- returns transformed value if the column name is on the list for 'special' treatment,
-- i.e. hidden (password) or requires call to dedicated Import_<column_name>_ function
FUNCTION Transform_Col_Value___ (
   col_name_     IN VARCHAR2,
   col_value_    IN VARCHAR2,
   db_name_      IN VARCHAR2,
   hidden_cols_  IN VARCHAR2,
   special_cols_ IN VARCHAR2) RETURN VARCHAR2
IS
   FUNCTION Is_Hidden RETURN BOOLEAN IS
   BEGIN
      RETURN instr(hidden_cols_, ','||upper(col_name_)||',') > 0;
   END;

   FUNCTION Is_Special RETURN BOOLEAN IS
   BEGIN
      RETURN instr(special_cols_, ','||upper(col_name_)||',') > 0;
   END;

BEGIN
   IF Is_Hidden THEN
      RETURN Ins_Util_API.From_Base64(col_value_);
   ELSIF Is_Special THEN
      DECLARE
         new_value_ VARCHAR2(4000);
      BEGIN
         @ApproveDynamicStatement(2019-12-30,japase)
         EXECUTE IMMEDIATE 'BEGIN :newval := '||db_name_||'_API.Import_'||col_name_||'_(:value); END;'
         USING OUT new_value_, IN col_value_;
         RETURN new_value_;
      END;
   ELSE
      RETURN col_value_;
   END IF;
END Transform_Col_Value___;


-- returns a list of colums to be exported from the actual entity
-- the list is fetch from data dictionary
-- optionally adds a column alias and calls functions in the entity
FUNCTION Get_Column_List___ (
   db_name_        IN VARCHAR2,
   alias_          IN VARCHAR2 DEFAULT 'X',
   exclude_        IN VARCHAR2 DEFAULT NULL,
   alias_prefix_   IN VARCHAR2 DEFAULT NULL,
   transform_      IN BOOLEAN  DEFAULT TRUE,
   to_char_        IN BOOLEAN  DEFAULT FALSE,
   exp_customized_ IN BOOLEAN  DEFAULT FALSE) RETURN VARCHAR2
IS
   col_list_     VARCHAR2(32000);
   hidden_cols_  VARCHAR2(4000);
   special_cols_ VARCHAR2(4000);
   col_name_     VARCHAR2(100);
   customized_   VARCHAR2(30) := CASE exp_customized_ WHEN TRUE THEN 'dummy' ELSE 'CUSTOMIZED' END;
   enabled_      VARCHAR2(30) := CASE db_name_ WHEN 'CONNECT_QUEUE' THEN 'ENABLED' ELSE 'dummy' END;
   table_name_   VARCHAR2(30) := CASE db_name_ WHEN 'CONNECT_PROPERTY' THEN 'JSF_PROPERTY_TAB' ELSE db_name_||'_TAB' END;
   t1_           NUMBER;
   t2_           NUMBER;

   CURSOR cols_ IS
      WITH
         view_cols AS
         (
            SELECT column_name, column_id
              FROM user_tab_columns
             WHERE table_name = db_name_
               AND column_name NOT IN ('STATIC_CONFIG', enabled_, customized_, upper(nvl(exclude_,'*')))
         ),
         tab_cols AS
         (
            SELECT column_name
              FROM user_tab_columns
             WHERE table_name = table_name_
               AND column_name NOT IN ('STATIC_CONFIG', enabled_, customized_, upper(nvl(exclude_,'*')))
         )
         SELECT lower(V.column_name) column_name
           FROM view_cols V, tab_cols T
          WHERE T.column_name = V.column_name
          ORDER BY V.column_id;
   
   CURSOR get_db_cols_ IS
    SELECT lower(column_name) column_name
      FROM user_tab_columns
     WHERE table_name = db_name_
       AND column_name LIKE '%_DB'
       AND column_name NOT IN ('STATIC_CONFIG', enabled_, customized_, upper(nvl(exclude_,'*')));

   FUNCTION Is_Hidden(name_ VARCHAR2) RETURN BOOLEAN IS
   BEGIN
      RETURN instr(hidden_cols_, ','||upper(name_)||',') > 0;
   END;

   FUNCTION Is_Special(name_ VARCHAR2) RETURN BOOLEAN IS
   BEGIN
      RETURN instr(special_cols_, ','||upper(name_)||',') > 0;
   END;

   FUNCTION Replace_to_db_name(name_ VARCHAR2) RETURN VARCHAR2 IS
      db_col_name_ VARCHAR2(100);
   BEGIN
      OPEN get_db_cols_;
      IF get_db_cols_%ROWCOUNT = 0 THEN
         db_col_name_ := name_;
      END IF;
      CLOSE get_db_cols_;

      FOR view_db_col_ IN get_db_cols_ LOOP
         IF name_||'_db' = view_db_col_.column_name THEN
            db_col_name_ := view_db_col_.column_name;
            EXIT;
         ELSE
            db_col_name_ := name_;
         END IF;
      END LOOP;
      RETURN db_col_name_;
   END;

BEGIN
   Trace___(' - building column list for ['||db_name_||']');
   IF transform_ THEN
      Fetch_Transformed_Columns___(db_name_, hidden_cols_, special_cols_);
   END IF;

   t1_ := Dbms_Utility.Get_Time;
   FOR col_ IN cols_ LOOP
      col_.column_name := Replace_to_db_name(col_.column_name);
      col_name_ := CASE alias_ IS NULL WHEN TRUE THEN '' ELSE alias_||'.' END ||col_.column_name;
      IF Is_Special(col_.column_name) THEN
         col_name_ := db_name_||'_API.Export_'||col_name_||'_('||col_name_||') '||col_.column_name;
      ELSIF Is_Hidden(col_.column_name) THEN
         col_name_ := 'Ins_Util_API.To_Base64('||col_name_||') '||col_.column_name;
      ELSIF to_char_ THEN
         col_name_ := 'to_char('||col_name_||') '||col_name_;
      ELSIF alias_ IS NOT NULL THEN
         col_name_ := col_name_ ||' "'||nvl(alias_prefix_,'')||upper(col_.column_name)||'"';
      END IF;
      IF transform_ OR NOT Is_Binary_Column___(col_.column_name) THEN
         col_list_ := CASE col_list_ IS NULL WHEN TRUE THEN '' ELSE col_list_||', ' END || col_name_;
      END IF;
   END LOOP;
   t2_ := Dbms_Utility.Get_Time;
   fetch_cols_ := fetch_cols_ + (t2_-t1_);
   Trace___('  - column list fetched in #'||to_char((t2_-t1_)/100)||' sec');
   RETURN col_list_;
END Get_Column_List___;

-- returns a list of columns (Both DB and client value columns) to be exported from the actual entity
-- the list is fetch from data dictionary
-- optionally adds a column alias and calls functions in the entity
FUNCTION Get_All_Column_List___ (
   db_name_        IN VARCHAR2,
   alias_          IN VARCHAR2 DEFAULT 'X',
   exclude_        IN VARCHAR2 DEFAULT NULL,
   alias_prefix_   IN VARCHAR2 DEFAULT NULL,
   transform_      IN BOOLEAN  DEFAULT TRUE,
   to_char_        IN BOOLEAN  DEFAULT FALSE,
   exp_customized_ IN BOOLEAN  DEFAULT FALSE) RETURN VARCHAR2
IS
   col_list_     VARCHAR2(32000);
   hidden_cols_  VARCHAR2(4000);
   special_cols_ VARCHAR2(4000);
   col_name_     VARCHAR2(100);
   customized_   VARCHAR2(30) := CASE exp_customized_ WHEN TRUE THEN 'dummy' ELSE 'CUSTOMIZED' END;
   enabled_      VARCHAR2(30) := CASE db_name_ WHEN 'CONNECT_QUEUE' THEN 'ENABLED' ELSE 'dummy' END;
   table_name_   VARCHAR2(30) := CASE db_name_ WHEN 'CONNECT_PROPERTY' THEN 'JSF_PROPERTY_TAB' ELSE db_name_||'_TAB' END;
   t1_           NUMBER;
   t2_           NUMBER;

   CURSOR cols_ IS
      WITH
         view_cols AS
         (
            SELECT column_name, column_id
              FROM user_tab_columns
             WHERE table_name = db_name_
               AND column_name NOT IN ('STATIC_CONFIG', enabled_, customized_, upper(nvl(exclude_,'*')))
         ),
         tab_cols AS
         (
            SELECT column_name
              FROM user_tab_columns
             WHERE table_name = table_name_
               AND column_name NOT IN ('STATIC_CONFIG', enabled_, customized_, upper(nvl(exclude_,'*')))
         )
         SELECT lower(V.column_name) column_name
           FROM view_cols V, tab_cols T
          WHERE T.column_name = V.column_name OR (T.column_name || '_DB' = V.column_name)
          ORDER BY V.column_id;
   
   FUNCTION Is_Hidden(name_ VARCHAR2) RETURN BOOLEAN IS
   BEGIN
      RETURN instr(hidden_cols_, ','||upper(name_)||',') > 0;
   END;

   FUNCTION Is_Special(name_ VARCHAR2) RETURN BOOLEAN IS
   BEGIN
      RETURN instr(special_cols_, ','||upper(name_)||',') > 0;
   END;    

BEGIN
   Trace___(' - building column list for ['||db_name_||']');
   IF transform_ THEN
      Fetch_Transformed_Columns___(db_name_, hidden_cols_, special_cols_);
   END IF;

   t1_ := Dbms_Utility.Get_Time;
   FOR col_ IN cols_ LOOP
      col_name_ := CASE alias_ IS NULL WHEN TRUE THEN '' ELSE alias_||'.' END ||col_.column_name;
      IF Is_Special(col_.column_name) THEN
         col_name_ := db_name_||'_API.Export_'||col_name_||'_('||col_name_||') '||col_.column_name;
      ELSIF Is_Hidden(col_.column_name) THEN
         col_name_ := 'Ins_Util_API.To_Base64('||col_name_||') '||col_.column_name;
      ELSIF to_char_ THEN
         col_name_ := 'to_char('||col_name_||') '||col_name_;
      ELSIF alias_ IS NOT NULL THEN
         col_name_ := col_name_ ||' "'||nvl(alias_prefix_,'')||upper(col_.column_name)||'"';
      END IF;
      IF transform_ OR NOT Is_Binary_Column___(col_.column_name) THEN
         col_list_ := CASE col_list_ IS NULL WHEN TRUE THEN '' ELSE col_list_||', ' END || col_name_;
      END IF;
   END LOOP;
   t2_ := Dbms_Utility.Get_Time;
   fetch_cols_ := fetch_cols_ + (t2_-t1_);
   Trace___('  - column list fetched in #'||to_char((t2_-t1_)/100)||' sec');
   RETURN col_list_;
END Get_All_Column_List___;

-- generates XML for a given select statement using Dbms_Xmlgen package
FUNCTION Create_Xml___ (
   stmt_   IN VARCHAR2,
   rowset_ IN VARCHAR2,
   row_    IN VARCHAR2) RETURN CLOB
IS
   handle_   Dbms_Xmlgen.CtxHandle;
   xml_type_ XMLTYPE;
BEGIN
   Trace___(chr(10)||'STMT: ['||stmt_||']');

   handle_ := Dbms_Xmlgen.NewContext(stmt_);
   Dbms_Xmlgen.SetRowsetTag(handle_, rowset_);
   Dbms_Xmlgen.SetRowTag(handle_, row_);

   xml_type_ := Dbms_Xmlgen.GetXmlType(handle_) ;
   Dbms_Xmlgen.CloseContext(handle_);
   RETURN CASE xml_type_ IS NULL WHEN TRUE THEN NULL ELSE xml_type_.GetClobVal END;
END Create_Xml___;


-- generates XML for custom entities (readers, senders and addresses)
PROCEDURE Add_Custom___ (
   xml_             IN OUT CLOB,
   db_name_         IN     VARCHAR2,
   key_col_         IN     VARCHAR2,
   type_col_        IN     VARCHAR2,
   selector_exists_ IN     BOOLEAN)
IS
   TYPE REF_CURSOR IS REF CURSOR;

   ref_cursor_ REF_CURSOR;
   key_value_  VARCHAR2(500);
   custom_lu_  VARCHAR2(30);
   stmt_       VARCHAR2(2000) := '
      select <key>, custom_lu_name
        from <view>
       where <type_col> = ''Custom''
         and custom_lu_name is not null';
BEGIN
   IF selector_exists_ THEN
      stmt_ := stmt_ ||' and <key> in (select instance_name from connect_config_xml_tmp_tab)';
   END IF;
   stmt_ := replace(stmt_, '<key>',      key_col_);
   stmt_ := replace(stmt_, '<view>',     db_name_);
   stmt_ := replace(stmt_, '<type_col>', type_col_);

   @ApproveDynamicStatement(2019-12-02,japase)
   OPEN  ref_cursor_ FOR stmt_;
   LOOP
      FETCH ref_cursor_ INTO key_value_, custom_lu_;
      EXIT WHEN ref_cursor_%NOTFOUND;
      DECLARE
         cust_db_name_ VARCHAR2(30)   := Connect_Config_API.Mixed_Case_To_Db_Case_(custom_lu_);
         cust_stmt_    VARCHAR2(2000) := '
            select <cols>, <custom_cols>
              from <view> X, <custom_view> C
             where X.<key> = ''<key_value>''
               and C.<key> = X.<key>';
      BEGIN
         cust_stmt_ := replace(cust_stmt_, '<cols>',        Get_Column_List___(db_name_));
         cust_stmt_ := replace(cust_stmt_, '<custom_cols>', Get_Column_List___(cust_db_name_, 'C', key_col_ , 'CUSTOM.'));
         cust_stmt_ := replace(cust_stmt_, '<view>',        db_name_);
         cust_stmt_ := replace(cust_stmt_, '<custom_view>', cust_db_name_);
         cust_stmt_ := replace(cust_stmt_, '<key>',         key_col_);
         cust_stmt_ := replace(cust_stmt_, '<key_value>',   key_value_);
         xml_ := xml_ || Create_Xml___(cust_stmt_, null, db_name_);
      END;
   END LOOP;
   CLOSE ref_cursor_;
END Add_Custom___;


-- exports a single group (with possible child or custom entities)
PROCEDURE Export_Group___ (
   xml_             IN OUT CLOB,
   db_name_         IN     VARCHAR2,
   selector_exists_ IN     BOOLEAN,
   exp_customized_  IN     BOOLEAN)
IS
   rowset_       VARCHAR2(50);
   is_address_   BOOLEAN      := db_name_ = 'ROUTING_ADDRESS';
   has_custom_   BOOLEAN      := FALSE;
   parent_key_   VARCHAR2(30) := Get_Parent_Key___(db_name_);
   key_col_      VARCHAR2(30) := Get_Key___(db_name_);
   type_col_     VARCHAR2(30) := CASE is_address_ WHEN TRUE THEN 'transport_connector' ELSE 'instance_type' END;
   stmt_         VARCHAR2(32000);
   where_        VARCHAR2(10000);

   FUNCTION Get_Rowset_Name RETURN VARCHAR2 IS
   BEGIN
      IF db_name_ LIKE '%S' THEN
         RETURN db_name_ || 'ES';
      ELSIF db_name_ LIKE '%Y' THEN
         RETURN substr(db_name_, 1, length(db_name_)-1) || 'IES';
      ELSE
         RETURN db_name_ || 'S';
      END IF;
   END;

   FUNCTION Get_Cursor_Stmt (table_name_ VARCHAR2, tab_alias_ VARCHAR2, column_alias_ VARCHAR2, order_ VARCHAR2,
                             master_key_col_ VARCHAR2, detail_key_col_ VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
   IS
      det_key_ VARCHAR2(30)   := nvl(detail_key_col_, master_key_col_);
      cursor_  VARCHAR2(4000) := '
      cursor (select <cols>
                from <table> <alias>
               where <alias>.<detail_key> = X.<master_key>
               order by <alias>.<order_by>
             ) <column_alias>';
   BEGIN
      cursor_ := replace(cursor_, '<cols>',         Get_Column_List___(table_name_, tab_alias_, det_key_));
      cursor_ := replace(cursor_, '<table>',        table_name_);
      cursor_ := replace(cursor_, '<alias>',        tab_alias_);
      cursor_ := replace(cursor_, '<detail_key>',   det_key_);
      cursor_ := replace(cursor_, '<master_key>',   master_key_col_);
      cursor_ := replace(cursor_, '<order_by>',     order_);
      cursor_ := replace(cursor_, '<column_alias>', column_alias_);
      RETURN ', '||cursor_;
   END;

BEGIN
   Trace___('Exporting group ['||db_name_||']...');
   stmt_ := '
      select <cols> <cursors>
        from <table> X
             <where>';

   rowset_ := Get_Rowset_Name;
   IF selector_exists_ THEN
      IF parent_key_ IS NOT NULL THEN
         where_ := ' X.'||parent_key_||'||''-''||';
      END IF;
      where_ := where_||' X.'||key_col_||' in (select instance_name from connect_config_xml_tmp_tab)';
   END IF;

   IF has_custom_ THEN
      where_ := where_ || CASE where_ IS NOT NULL WHEN TRUE THEN ' and ' ELSE '' END || ' X.'||type_col_||' <> ''Custom''';
      xml_ := xml_||'<'||rowset_||'>'||chr(10);
      Add_Custom___(xml_, db_name_, key_col_, type_col_, selector_exists_);
   END IF;

   IF where_ IS NOT NULL THEN
      where_ := ' where '||where_;
   END IF;

   stmt_ := replace(stmt_, '<cols>',  Get_Column_List___(db_name_, exp_customized_ => exp_customized_));
   stmt_ := replace(stmt_, '<table>', db_name_);
   stmt_ := replace(stmt_, '<where>', where_);
   stmt_ := replace(stmt_, '<cursors>',
      CASE db_name_
         WHEN 'ROUTING_RULE' THEN
            Get_Cursor_Stmt('ROUTING_RULE_CONDITION', 'C', 'conditions', 'seq_no',        'rule_name') ||
            Get_Cursor_Stmt('ROUTING_RULE_ADDRESS',   'A', 'addresses',  'chain_link_no', 'rule_name')
         WHEN 'CONNECT_PRINT_AGENT_TASK' THEN
            Get_Cursor_Stmt('PRINTER_MAPPING', 'P', 'printers',  'logical_printer_id', 'instance_name', 'template_instance_name')
         WHEN 'CONNECT_READER' THEN
            Get_Cursor_Stmt('CUSTOM_READER_PARAM', 'RP', 'params', 'parameter_name', 'instance_name') ||
            Get_Cursor_Stmt('CUSTOM_CONNECTOR_LIBRARY',   'L', 'library',  'jar_name', 'instance_name')
         WHEN 'CONNECT_SENDER' THEN
            Get_Cursor_Stmt('CUSTOM_SENDER_PARAM', 'RP', 'params', 'parameter_name', 'instance_name') ||
            Get_Cursor_Stmt('CUSTOM_CONNECTOR_LIBRARY',   'L', 'library',  'jar_name', 'instance_name')
         ELSE
            NULL
      END);

   xml_ := xml_ || Create_Xml___(stmt_, CASE has_custom_ WHEN TRUE THEN NULL ELSE rowset_ END, db_name_);
   IF has_custom_ THEN
      xml_ := xml_||'</'||rowset_||'>'||chr(10);
   END IF;
END Export_Group___;


-- generates XML header with version number
FUNCTION Get_Header___ RETURN CLOB
IS
   xml_ CLOB := '<?xml version="1.0" encoding="UTF-8"?>'||chr(10)||
                '<CONNECT_CONFIG>'||chr(10)||
                '<EXPORT_VERSION>11.0</EXPORT_VERSION>'||chr(10);
BEGIN
   RETURN xml_;
END Get_Header___;


-- appends final XML tag to the export file
PROCEDURE Append_Footer___ (
   xml_ IN OUT CLOB)
IS
BEGIN
   xml_ := xml_ ||'</CONNECT_CONFIG>' ||chr(10);
END Append_Footer___;


-- checks if a row already exists in the database
FUNCTION Row_Exists___ (
   db_name_    IN VARCHAR2,
   parent_val_ IN VARCHAR2,
   key_val_    IN VARCHAR2) RETURN BOOLEAN
IS
   exists_ BOOLEAN;
BEGIN
   IF parent_val_ IS NULL THEN
      @ApproveDynamicStatement(2019-12-04,japase)
      EXECUTE IMMEDIATE 'BEGIN :exists := '||db_name_||'_API.Exists(:name); END;' USING OUT exists_, IN key_val_;
   ELSE -- CUSTOM_CONNECTOR_LIBRARIES and detail entities
      @ApproveDynamicStatement(2019-12-04,japase)
      EXECUTE IMMEDIATE 'BEGIN :exists := '||db_name_||'_API.Exists(:parent, :name); END;' USING OUT exists_, IN parent_val_, IN key_val_;
   END IF;
   RETURN exists_;
END Row_Exists___;


-- creates a map with old values (i.e. from database) for the actual instance
-- the map is used to create proper attribute string
FUNCTION Create_Attribute_Map___ (
   db_name_        IN     VARCHAR2,
   col_list_map_   IN OUT Col_List_Map,
   parent_val_     IN     VARCHAR2,
   key_val_        IN     VARCHAR2,
   parent_db_name_ IN     VARCHAR2 DEFAULT NULL) RETURN Entity_Attr_Map
IS
   TYPE Entity_Attr_Table IS TABLE OF Entity_Attribute INDEX BY BINARY_INTEGER;

   attr_tab_   Entity_Attr_Table;
   attr_map_   Entity_Attr_Map;
   parent_key_ VARCHAR2(30)    := Get_Parent_Key___(db_name_);
   key_col_    VARCHAR2(30)    := Get_Key___(nvl(parent_db_name_, db_name_));
   col_lists_  Col_Lists;
   stmt_       VARCHAR2(32767) :=
     'with client as (
         select <tochar_cols>
           from <view>
          where <parent_key> = :parentval
            and <key> = :keyval
      )
      select *
        from client
     unpivot (attr_value for attr_name in (<cols>))';
BEGIN
   BEGIN
      col_lists_ := col_list_map_(db_name_);
   EXCEPTION
      WHEN no_data_found THEN
         col_lists_.char_col_list := Get_All_Column_List___(db_name_, NULL, transform_ => FALSE, to_char_ => TRUE);
         col_lists_.col_list := Get_All_Column_List___(db_name_, NULL, transform_ => FALSE);
         col_list_map_(db_name_) := col_lists_;
   END;

   stmt_ := replace(stmt_, '<tochar_cols>', col_lists_.char_col_list);
   stmt_ := replace(stmt_, '<view>',        db_name_);
   stmt_ := replace(stmt_, '<parent_key>',  nvl(parent_key_, key_col_));
   stmt_ := replace(stmt_, '<key>',         key_col_);
   stmt_ := replace(stmt_, '<cols>',        col_lists_.col_list);
   Trace___(' - stmt: ['||stmt_||']');
   @ApproveDynamicStatement(2019-12-09,japase)
   EXECUTE IMMEDIATE stmt_ BULK COLLECT INTO attr_tab_ USING nvl(parent_val_, key_val_), key_val_;
   Trace___(' - old values:');
   FOR i IN 1..attr_tab_.count LOOP
      DECLARE
         attr_ Entity_Attribute := attr_tab_(i);
      BEGIN
         Trace___('  - '||attr_.attr_name||' = '||attr_.attr_value);
         attr_map_(upper(attr_.attr_name)) := attr_.attr_value;
      END;
   END LOOP;
   RETURN attr_map_;
END Create_Attribute_Map___;


-- converts binary value form the HEX representation
FUNCTION From_Hex___ (
   clob_ IN CLOB) RETURN BLOB
IS
   chunk_ CONSTANT INTEGER := 16000;
   len_   INTEGER := Dbms_Lob.GetLength(clob_);
   pos_   INTEGER := 1;
   buf_   RAW(32000);
   blob_  BLOB;
BEGIN
   IF len_ IS NULL OR len_ = 0 THEN
      RETURN NULL;
   END IF;
   Dbms_Lob.CreateTemporary(blob_, TRUE);
   WHILE pos_ < len_ LOOP
      buf_ := Dbms_Lob.substr(clob_, chunk_, pos_);
      Dbms_Lob.Append(blob_, HexToRaw(buf_));
      pos_ := pos_ + chunk_;
   END LOOP;
   RETURN blob_;
END From_Hex___;


-- creates an attribute string optionally using a map with attribute values for existing instances
FUNCTION Create_Attr_Str___ (
   doc_          IN     Plsqlap_Document_API.Document,
   id_           IN     Plsqlap_Document_API.Element_Id,
   attr_map_     IN     Entity_Attr_Map,
   key_col_      IN     VARCHAR2,
   key_value_    IN OUT VARCHAR2,
   attr_str_     IN OUT VARCHAR2,
   db_name_      IN     VARCHAR2,
   hidden_cols_  IN     VARCHAR2,
   special_cols_ IN     VARCHAR2,
   binary_col_   IN OUT Binary_Column,
   custom_lu_    IN OUT VARCHAR2,
   custom_attrs_ IN OUT Custom_Attrs,
   det_entities_ IN OUT Instance_Table__) RETURN BOOLEAN
IS
   attribs_       Plsqlap_Document_API.Child_Table := Plsqlap_Document_API.Get_Child_Elements(doc_, id_);
   attr_id_       Plsqlap_Document_API.Element_Id;
   attr_name_     VARCHAR2(4000);
   customized_    BOOLEAN;

   FUNCTION Value_Changed (value_ VARCHAR2) RETURN BOOLEAN IS
   BEGIN
      Trace___('  - checking value for ['||attr_name_||']');
      IF attr_map_.count = 0 THEN
         RETURN TRUE;
      END IF;
      RETURN value_ <> attr_map_(attr_name_);
   EXCEPTION
      WHEN no_data_found THEN
         Trace___('  - attribute not found in map...');
         RETURN TRUE;
   END;

   FUNCTION Get_Detail_Db_Name (doc_name_ VARCHAR2) RETURN VARCHAR2 IS
   BEGIN
      RETURN
         CASE doc_name_
            WHEN 'CONDITIONS_ROW' THEN 'ROUTING_RULE_CONDITION'
            WHEN 'ADDRESSES_ROW'  THEN 'ROUTING_RULE_ADDRESS'
            WHEN 'PRINTERS_ROW'   THEN 'PRINTER_MAPPING'
         END;
   END;

BEGIN
   FOR a IN 1..attribs_.count LOOP
      attr_id_ := attribs_(a);
      attr_name_ := upper(Plsqlap_Document_API.Get_Name(doc_, attr_id_));
      IF Plsqlap_Document_API.Is_Simple(doc_, attr_id_) THEN
         IF Is_Binary_Column___(attr_name_) THEN
            binary_col_.name := attr_name_;
            binary_col_.data := From_Hex___(Plsqlap_Document_API.Get_Clob_Value(doc_, attr_id_));
         ELSE
            DECLARE
               value_ VARCHAR2(4000) := Plsqlap_Document_API.Get_Value(doc_, attr_id_);
            BEGIN
               IF attr_name_ LIKE 'CUSTOM.%' THEN
                  DECLARE
                     cust_attr_      Entity_Attribute;
                     cust_attr_name_ VARCHAR2(30) := substr(attr_name_,8);
                  BEGIN
                     Trace___('  - adding custom attribute ['||cust_attr_name_||'='||value_||']');
                     cust_attr_.attr_name  := cust_attr_name_;
                     cust_attr_.attr_value := value_;
                     custom_attrs_(custom_attrs_.count+1) := cust_attr_;
                  END;
               ELSIF attr_name_ = 'CUSTOMIZED' THEN
                  customized_ := CASE value_ WHEN 1 THEN TRUE ELSE FALSE END;
               ELSE
                  IF attr_name_ = upper(key_col_) THEN
                     IF key_value_ IS NOT NULL THEN
                        value_ := key_value_;
                     ELSE
                        key_value_ := value_;
                     END IF;
                  ELSIF attr_name_ = 'CUSTOM_LU_NAME' THEN
                     custom_lu_ := value_;
                  END IF;
                  value_ := Transform_Col_Value___(attr_name_, value_, db_name_, hidden_cols_, special_cols_);
                  IF Value_Changed(value_) THEN
                     Client_SYS.Add_To_Attr(attr_name_, value_, attr_str_);
                  END IF;
               END IF;
            END;
         END IF;
      ELSE -- compound attribute
         DECLARE
            elements_   Plsqlap_Document_API.Child_Table := Plsqlap_Document_API.Get_Child_Elements(doc_, attr_id_);
            det_entity_ Instance__;
         BEGIN
            FOR e IN 1..elements_.count LOOP
               det_entity_.db_name := Get_Detail_Db_Name(Plsqlap_Document_API.Get_Name(doc_, elements_(e)));
               det_entity_.elem_id := elements_(e);
               det_entities_(det_entities_.count+1) := det_entity_;
            END LOOP;
         END;
      END IF;
   END LOOP;
   RETURN nvl(customized_, FALSE);
END Create_Attr_Str___;


PROCEDURE Create_Attr_Str___ (
   doc_          IN     Plsqlap_Document_API.Document,
   id_           IN     Plsqlap_Document_API.Element_Id,
   attr_map_     IN     Entity_Attr_Map,
   key_col_      IN     VARCHAR2,
   key_value_    IN OUT VARCHAR2,
   attr_str_     IN OUT VARCHAR2,
   db_name_      IN     VARCHAR2,
   hidden_cols_  IN     VARCHAR2,
   special_cols_ IN     VARCHAR2)
IS
   binary_col_    Binary_Column;
   custom_lu_     VARCHAR2(30);
   custom_attrs_  Custom_Attrs;
   det_entities_  Instance_Table__;
   customized_    BOOLEAN;
BEGIN
   customized_ := Create_Attr_Str___(doc_, id_, attr_map_, key_col_, key_value_, attr_str_,
                                     db_name_, hidden_cols_, special_cols_,
                                     binary_col_, custom_lu_, custom_attrs_, det_entities_);
END Create_Attr_Str___;


-- calls Set_Customized_(FALSE) after call to New__ or Modify__ in mode DELIVERY
PROCEDURE Unset_Customized___ (
   db_name_   IN VARCHAR2,
   key_value_ IN VARCHAR2)
IS
   pkg_name_  VARCHAR2(30) := db_name_||'_API';
   proc_name_ VARCHAR2(30) := 'Set_Customized_';
BEGIN
   IF Installation_SYS.Method_Exist(pkg_name_, proc_name_) THEN
      Trace___(' - un-setting customized in ['||db_name_||']');
      @ApproveDynamicStatement(2019-12-13,japase)
      EXECUTE IMMEDIATE 'BEGIN '||pkg_name_||'.'||proc_name_||'(:key, :customized); END;'
      USING key_value_, FALSE;
   END IF;
END Unset_Customized___;


-- fetches OBJID and OBJVERSION for existings rows
-- returns TRUE if the instance has the 'customized' and the flag is TRUE
FUNCTION Get_Objid___ (
   db_name_        IN  VARCHAR2,
   parent_val_     IN  VARCHAR2,
   key_val_        IN  VARCHAR2,
   objid_          OUT VARCHAR2,
   objver_         OUT VARCHAR2,
   parent_db_name_ IN  VARCHAR2 DEFAULT NULL) RETURN BOOLEAN
IS
   parent_key_ VARCHAR2(30) := Get_Parent_Key___(db_name_);
   key_col_    VARCHAR2(30) := Get_Key___(nvl(parent_db_name_, db_name_));
   customized_ NUMBER;
   stmt_       VARCHAR2(1000);

   FUNCTION Has_Customized_Flag RETURN BOOLEAN IS
   BEGIN
      RETURN db_name_ IN (
         'ROUTING_RULE',
         'ROUTING_ADDRESS',
         'CONNECT_TRANSFORMER',
         'CONNECT_ENVELOPE');
   END;

BEGIN
   stmt_ := '
      select objid, objversion, <customized>
        from <view>
       where <parent_key> = :parentval
         and <key> = :keyval';
   stmt_ := replace(stmt_, '<customized>', CASE Has_Customized_Flag WHEN TRUE THEN 'customized' ELSE '0' END);
   stmt_ := replace(stmt_, '<view>',       db_name_);
   stmt_ := replace(stmt_, '<parent_key>', nvl(parent_key_, key_col_));
   stmt_ := replace(stmt_, '<key>',        key_col_);

   Trace___(' - stmt: ['||stmt_||']');

   @ApproveDynamicStatement(2019-12-06,japase)
   EXECUTE IMMEDIATE stmt_ INTO objid_, objver_, customized_ USING nvl(parent_val_, key_val_), key_val_;
   RETURN CASE nvl(customized_, 0) WHEN 1 THEN TRUE ELSE FALSE END;
END Get_Objid___;

-- creates new record by calling New__
PROCEDURE New_Row___ (
   db_name_  IN     VARCHAR2,
   attr_str_ IN OUT VARCHAR2,
   objid_    OUT    VARCHAR2,
   objver_   OUT    VARCHAR2)
IS
   info_ VARCHAR2(100);
BEGIN
   Debug_Attr_Str___(' - creating new row in ['||db_name_||'] with attr_str', attr_str_);
   @ApproveDynamicStatement(2019-12-04,japase)
   EXECUTE IMMEDIATE 'BEGIN '||db_name_||'_API.New__(:info, :objid, :objver, :attr, ''DO''); END;'
   USING OUT info_, OUT objid_, OUT objver_, IN OUT attr_str_;
   Trace___('   - new row in ['||db_name_||'] with OBJID ['||objid_||'] created with info ['||info_||']');
END New_Row___;


-- modifies a record by calling Modify__
FUNCTION Modify_Row___ (
   db_name_  IN     VARCHAR2,
   attr_str_ IN OUT VARCHAR2,
   objid_    IN     VARCHAR2,
   objver_   IN OUT VARCHAR2) RETURN INTEGER
IS
   info_ VARCHAR2(100);
BEGIN
   Debug_Attr_Str___(' - modifying row in ['||db_name_||'] with objid ['||objid_||'] and attr_str', attr_str_);
   IF attr_str_ IS NOT NULL THEN
      @ApproveDynamicStatement(2019-12-06,japase)
      EXECUTE IMMEDIATE 'BEGIN '||db_name_||'_API.Modify__(:info, :objid, :objver, :attr, ''DO''); END;'
      USING OUT info_, IN objid_, IN OUT objver_, IN OUT attr_str_;
      Trace___('   - row in ['||db_name_||'] with OBJID ['||objid_||'] modified with info ['||info_||']');
      RETURN 1;
   END IF;
   RETURN 0;
END Modify_Row___;


-- removes a record by calling Remove__; called only in mode REPLACE
PROCEDURE Remove_Row___ (
   db_name_ IN VARCHAR2,
   objid_   IN VARCHAR2,
   objver_  IN VARCHAR2)
IS
   info_ VARCHAR2(100);
BEGIN
   Trace___(' - removing row from ['||db_name_||']');
   @ApproveDynamicStatement(2019-12-09,japase)
   EXECUTE IMMEDIATE 'BEGIN '||db_name_||'_API.Remove__(:info, :objid, :objver, ''DO''); END;'
   USING OUT info_, IN objid_, IN objver_;
   Trace___('   - row in ['||db_name_||'] with OBJID ['||objid_||'] removed with info ['||info_||']');
END Remove_Row___;


-- removes all records for a particular group except the ones on the supplied list,
-- i.e. present in the expor file; called only in mode REPLACE
FUNCTION Remove_Rows___ (
   db_name_             IN VARCHAR2,
   parent_value_        IN VARCHAR2,
   preserved_instances_ IN Instance_Table__) RETURN INTEGER
IS
   to_remove_  Instance_Table__;
   removed_    INTEGER        := 0;
   parent_key_ VARCHAR2(30)   := Get_Parent_Key___(db_name_);
   key_col_    VARCHAR2(30)   := Get_Key___(db_name_);
   static_     VARCHAR2(30)   := CASE db_name_ WHEN 'CONNECT_QUEUE' THEN 'static_config' ELSE '0' END;
   stmt_       VARCHAR2(1000) := '
      select null db_name, null elem_id, <parent_key>, <key>, objid, objversion
        from <view>
       where <parent_key> like :parent
         and <key> not in (select key_val from table(:tab))
         and <static> <> 1';
BEGIN
   IF db_name_ IN ('CONNECT_SIMPLE_ROUTING','CONNECT_SERVER') THEN
      RETURN 0;
   END IF;

   stmt_ := replace(stmt_, '<parent_key>',  nvl(parent_key_, key_col_));
   stmt_ := replace(stmt_, '<key>',         key_col_);
   stmt_ := replace(stmt_, '<view>',        db_name_);
   stmt_ := replace(stmt_, '<static>',      static_);

   Trace___(' - stmt: ['||stmt_||']');
   Trace___('  - preserved instances:');
   FOR i IN 1..preserved_instances_.count LOOP
      Trace___('     ['||preserved_instances_(i).parent_val||', '||preserved_instances_(i).key_val||']');
   END LOOP;

   @ApproveDynamicStatement(2019-12-09,japase)
   EXECUTE IMMEDIATE stmt_ BULK COLLECT INTO to_remove_ USING parent_value_, preserved_instances_;
   FOR i IN 1..to_remove_.count LOOP
      DECLARE
         instance_ Instance__ := to_remove_(i);
      BEGIN
         Remove_Row___(db_name_, instance_.objid, instance_.objversion);
         removed_ := removed_ + 1;
         Trace___(' - instance with name ['||instance_.key_val||'] and OBJID ['||instance_.objid||'] deleted');
      END;
   END LOOP;
   RETURN removed_;
END Remove_Rows___;


-- updates binary value by calling corresponding Write_<column_name>__ procedure
FUNCTION Update_Binary___ (
   db_name_    IN     VARCHAR2,
   objid_      IN     VARCHAR2,
   objver_     IN OUT VARCHAR2,
   binary_col_ IN     Binary_Column) RETURN INTEGER
IS
   value_ BLOB;
   stmt_  VARCHAR2(1000) := '
      select <col>
        from <view>
       where objid = :objid
         and objversion = :objver ';
         
   FUNCTION Equal (blob1_ BLOB, blob2_ BLOB) RETURN BOOLEAN IS
   BEGIN
      IF blob1_ IS NULL AND blob2_ IS NULL THEN
         RETURN TRUE;
      ELSE
         RETURN Dbms_Lob.Compare(value_, binary_col_.data) = 0;
      END IF;
   END;

BEGIN
   IF binary_col_.data IS NOT NULL THEN
      stmt_ := replace(stmt_, '<col>',  binary_col_.name);
      stmt_ := replace(stmt_, '<view>', db_name_);
      Trace___(' - stmt: ['||stmt_||']');

      @ApproveDynamicStatement(2019-12-30,japase)
      EXECUTE IMMEDIATE stmt_ INTO value_ USING objid_, objver_;

      IF Equal(value_, binary_col_.data) THEN
         Trace___(' - binary value for row in ['||db_name_||'] with OBJID ['||objid_||'] does not differ');
         RETURN 0;
      ELSE
         Trace___(' - modyfying binary value in ['||db_name_||']');
         @ApproveDynamicStatement(2019-12-06,japase)
         EXECUTE IMMEDIATE 'BEGIN '||db_name_||'_API.Write_'||binary_col_.name||'__(:objver, :rowid, :lob); END;'
         USING IN OUT objver_, IN objid_, IN binary_col_.data;
         Trace___('   - binary value for row in ['||db_name_||'] with OBJID ['||objid_||'] modified');
         RETURN 1;
      END IF;
   END IF;
   RETURN 0;
END Update_Binary___;


-- imports a single group
PROCEDURE Import_Group___ (
   doc_            IN     Plsqlap_Document_API.Document,
   grp_id_         IN     PLSQLAP_Document_API.Element_Id,
   mode_           IN     VARCHAR2,
   new_name_       IN     VARCHAR2,
   preserved_inst_ OUT    Preserved_Instances,
   result_         IN OUT Import_Result)
IS
   inst_names_   Instance_Table__;
   db_name_      VARCHAR2(50);
   col_list_map_ Col_List_Map;
   parent_key_   VARCHAR2(30);
   key_col_      VARCHAR2(30);
   hidden_cols_  VARCHAR2(4000);
   special_cols_ VARCHAR2(4000);

   PROCEDURE Import_Instance (inst_id_ Plsqlap_Document_API.Element_Id) IS
      inst_name_     VARCHAR2(500);
      inst_name_db_     VARCHAR2(500);
      parent_name_   VARCHAR2(20);
      inst_exists_   BOOLEAN;

      PROCEDURE Create_Instance (name_ VARCHAR2) IS
         objid_        VARCHAR2(100);
         objver_       VARCHAR2(100);
         binary_col_   Binary_Column;
         empty_map_    Entity_Attr_Map;
         key_value_    VARCHAR2(500) := name_;
         attr_str_     VARCHAR2(32767);
         custom_lu_    VARCHAR2(30);
         custom_attrs_ Custom_Attrs;
         det_entities_ Instance_Table__;
         customized_   BOOLEAN;
         updated_      INTEGER;

      BEGIN
         Trace___(' - creating instance with name ['||name_||']');
         customized_ := Create_Attr_Str___(doc_, inst_id_, empty_map_, key_col_, key_value_, attr_str_,
                                           db_name_, hidden_cols_, special_cols_,
                                           binary_col_, custom_lu_, custom_attrs_, det_entities_);
         New_Row___(db_name_, attr_str_, objid_, objver_); -- always sets the customized flag
         IF mode_ = 'DELIVERY' AND NOT customized_ THEN -- unset the flag only if not set in the file
            Unset_Customized___(db_name_, key_value_);
            customized_ := Get_Objid___(db_name_, parent_name_, inst_name_, objid_, objver_);
         END IF;
         updated_ := Update_Binary___(db_name_, objid_, objver_, binary_col_);

         -- create row in custom entity, if any
         IF custom_attrs_.count > 0 THEN
            DECLARE
               cust_db_name_      VARCHAR2(30) := Connect_Config_API.Mixed_Case_To_Db_Case_(custom_lu_);
               cust_hidden_cols_  VARCHAR2(4000);
               cust_special_cols_ VARCHAR2(4000);
            BEGIN
               Fetch_Transformed_Columns___(cust_db_name_, cust_hidden_cols_, cust_special_cols_); -- TODO: not optimal to call it for each instance
               Client_SYS.Clear_Attr(attr_str_);
               Client_SYS.Add_To_Attr(upper(key_col_),
                                      --key_value_,
                                      Transform_Col_Value___(key_col_, key_value_, cust_db_name_, cust_hidden_cols_, cust_special_cols_),
                                      attr_str_); -- parent key
               FOR i IN 1..custom_attrs_.count LOOP
                  Client_SYS.Add_To_Attr(custom_attrs_(i).attr_name,
                                         --custom_attrs_(i).attr_value,
                                         Transform_Col_Value___(custom_attrs_(i).attr_name, custom_attrs_(i).attr_value,
                                                                cust_db_name_, cust_hidden_cols_, cust_special_cols_),
                                         attr_str_);
               END LOOP;
               New_Row___(cust_db_name_, attr_str_, objid_, objver_);
            END;
         END IF;

         -- create rows in detail entities, if any
         FOR i IN 1..det_entities_.count LOOP
            DECLARE
               det_entity_       Instance__   := det_entities_(i);
               det_key_col_      VARCHAR2(30) := Get_Key___(det_entity_.db_name);
               det_key_val_      VARCHAR2(100);
               det_hidden_cols_  VARCHAR2(4000);
               det_special_cols_ VARCHAR2(4000);
               parent_key_col_   VARCHAR2(30) := CASE det_entity_.db_name
                                                    WHEN 'PRINTER_MAPPING' THEN 'TEMPLATE_INSTANCE_NAME'
                                                    ELSE upper(key_col_)
                                                 END;
            BEGIN
               Client_SYS.Clear_Attr(attr_str_);
               Client_SYS.Add_To_Attr(parent_key_col_, key_value_, attr_str_); -- parent key
               Fetch_Transformed_Columns___(det_entity_.db_name, det_hidden_cols_, det_special_cols_); -- TODO: not optimal to call it for each instance
               Create_Attr_Str___(doc_, det_entity_.elem_id, empty_map_, det_key_col_, det_key_val_, attr_str_,
                                  det_entity_.db_name, det_hidden_cols_, det_special_cols_);
               New_Row___(det_entity_.db_name, attr_str_, objid_, objver_);
            END;
         END LOOP;

         result_.added := result_.added + 1;
         Trace___(' - instance with name ['||name_||'] created.');
      END;

      PROCEDURE Update_Instance (name_ VARCHAR2) IS
         info_           VARCHAR2(100);
         objid_          VARCHAR2(100);
         objver_         VARCHAR2(40);
         attr_map_       Entity_Attr_Map;
         key_value_      VARCHAR2(500) := name_;
         attr_str_       VARCHAR2(32767);
         binary_col_     Binary_Column;
         custom_lu_      VARCHAR2(30);
         custom_attrs_   Custom_Attrs;
         det_entities_   Instance_Table__;
         old_customized_ BOOLEAN;
         new_customized_ BOOLEAN;
         updated_        INTEGER := 0;
         dummy_          BOOLEAN;
      BEGIN
         Trace___(' - updating instance name ['||name_||']');

         attr_map_ := Create_Attribute_Map___(db_name_, col_list_map_, parent_name_, inst_name_);
         new_customized_ := Create_Attr_Str___(doc_, inst_id_, attr_map_, key_col_, key_value_, attr_str_,
                                               db_name_, hidden_cols_, special_cols_,
                                               binary_col_, custom_lu_, custom_attrs_, det_entities_);
         old_customized_ := Get_Objid___(db_name_, parent_name_, inst_name_, objid_, objver_);
         IF mode_ = 'DELIVERY' AND old_customized_ THEN -- skip this instance on DELIVERY if customized
            RETURN;
         END IF;

         updated_ := Modify_Row___(db_name_, attr_str_, objid_, objver_); -- always sets the customized flag
         IF mode_ = 'DELIVERY' AND NOT new_customized_ THEN -- only unset the flag if not set in the file
            Unset_Customized___(db_name_, key_value_);
            updated_ := updated_ + 1;
            old_customized_ := Get_Objid___(db_name_, parent_name_, inst_name_, objid_, objver_);
         END IF;
         updated_ := updated_ + Update_Binary___(db_name_, objid_, objver_, binary_col_);

         -- update row in custom entity, if any
         IF custom_attrs_.count > 0 THEN
            DECLARE
               custom_db_name_    VARCHAR2(30) := Connect_Config_API.Mixed_Case_To_Db_Case_(custom_lu_);
               custom_attr_       Entity_Attribute;
               attr_value_        VARCHAR2(4000);
               cust_hidden_cols_  VARCHAR2(4000);
               cust_special_cols_ VARCHAR2(4000);
            BEGIN
               Fetch_Transformed_Columns___(custom_db_name_, cust_hidden_cols_, cust_special_cols_); -- TODO: not optimal to call it for each instance
               attr_map_ := Create_Attribute_Map___(custom_db_name_, col_list_map_, parent_name_, inst_name_, db_name_);
               Client_SYS.Clear_Attr(attr_str_);
               FOR i IN 1..custom_attrs_.count LOOP
                  custom_attr_ := custom_attrs_(i);
                  attr_value_ := Transform_Col_Value___(custom_attr_.attr_name, custom_attr_.attr_value,
                                                        custom_db_name_, cust_hidden_cols_, cust_special_cols_);
                  IF attr_value_ <> attr_map_(custom_attr_.attr_name) THEN
                     Client_SYS.Add_To_Attr(custom_attr_.attr_name, attr_value_, attr_str_);
                  END IF;
               END LOOP;
               dummy_ := Get_Objid___(custom_db_name_, parent_name_, inst_name_, objid_, objver_, db_name_);
               updated_ := updated_ + Modify_Row___(custom_db_name_, attr_str_, objid_, objver_);
            END;
         END IF;

         -- handle rows in detail entities, if any
         DECLARE
            preserved_        Preserved_Instances;
            det_entity_       Instance__;
            det_key_col_      VARCHAR2(30);
            det_key_val_      VARCHAR2(500);
            det_hidden_cols_  VARCHAR2(4000);
            det_special_cols_ VARCHAR2(4000);
         BEGIN
            FOR i IN 1..det_entities_.count LOOP
               Client_SYS.Clear_Attr(attr_str_);
               attr_map_.delete;
               det_entity_  := det_entities_(i);
               det_key_col_ := Get_Key___(det_entity_.db_name);
               det_key_val_ := Plsqlap_Document_API.Get_Value(doc_, upper(det_key_col_), det_entity_.elem_id);
               Fetch_Transformed_Columns___(det_entity_.db_name, det_hidden_cols_, det_special_cols_); -- TODO: not optimal to call it for each instance
               IF Row_Exists___(det_entity_.db_name, inst_name_, det_key_val_) THEN
                  -- detail exists - update it
                  attr_map_ := Create_Attribute_Map___(det_entity_.db_name, col_list_map_, inst_name_, det_key_val_);
                  Create_Attr_Str___(doc_, det_entity_.elem_id, attr_map_, det_key_col_, det_key_val_, attr_str_,
                                     det_entity_.db_name, det_hidden_cols_, det_special_cols_);
                  dummy_ := Get_Objid___(det_entity_.db_name, inst_name_, det_key_val_, objid_, objver_);
                  updated_ := Modify_Row___(det_entity_.db_name, attr_str_, objid_, objver_);
               ELSE
                  -- detail doesn't exist - create it
                  DECLARE
                     parent_key_col_   VARCHAR2(30) := CASE det_entity_.db_name
                                                    WHEN 'PRINTER_MAPPING' THEN 'TEMPLATE_INSTANCE_NAME'
                                                    ELSE upper(key_col_)
                                                 END;
                  BEGIN
                      Client_SYS.Add_To_Attr(parent_key_col_, key_value_, attr_str_); -- parent key
                      Create_Attr_Str___(doc_, det_entity_.elem_id, attr_map_, det_key_col_, det_key_val_, attr_str_,
                                     det_entity_.db_name, det_hidden_cols_, det_special_cols_);
                      New_Row___(det_entity_.db_name, attr_str_, objid_, objver_);  
                  END;                  
                  updated_ := updated_ + 1;
               END IF;
               
               DECLARE
                     instance_ Instance__;
                  BEGIN
                     instance_.parent_val := inst_name_;
                     instance_.key_val := det_key_val_;
                     IF preserved_.exists(det_entity_.db_name) THEN
                        preserved_(det_entity_.db_name)(preserved_(det_entity_.db_name).count+1) := instance_;
                     ELSE
                        DECLARE
                           instances_ Instance_Table__;
                        BEGIN
                           instances_(1) := instance_;
                           preserved_(det_entity_.db_name) := instances_;
                        END;
                     END IF;
               END;
            END LOOP;
            -- remove obsolete details
            DECLARE
               det_db_name_ VARCHAR2(30) := preserved_.FIRST;
               instances_   Instance_Table__;
            BEGIN
               WHILE det_db_name_ IS NOT NULL LOOP
                  instances_ := preserved_(det_db_name_);
                  updated_ := updated_ + Remove_Rows___(det_db_name_, key_value_, instances_);
                  det_db_name_ := preserved_.NEXT(det_db_name_);
               END LOOP;
            END;
         END;

         IF updated_ > 0 THEN
            result_.updated := result_.updated + 1;
            Trace___(' - instance with name ['||name_||'] and OBJID ['||objid_||'] updated: '||info_);
         END IF;
      END;

   BEGIN --Import_Instance
      Trace___(chr(10)||'>>> Found instance of ['||db_name_||'] (pk:'||parent_key_||' '||key_col_||')');
      inst_name_ := nvl(new_name_, Plsqlap_Document_API.Get_Value(doc_, upper(key_col_), inst_id_));
      inst_name_db_ := Plsqlap_Document_API.Get_Value(doc_, upper(key_col_) || '_DB', inst_id_);
      IF inst_name_ IS NULL AND inst_name_db_ IS NOT NULL THEN
         DECLARE
            stmt_       VARCHAR2(1000);
         BEGIN
            stmt_ := 'select instance_name from ' || db_name_ || ' WHERE instance_name_db = :name_db';
            @ApproveDynamicStatement(2021-08-09,rdhalk)
            EXECUTE IMMEDIATE stmt_ INTO inst_name_ USING inst_name_db_;
         END;         
      END IF;   
      parent_name_ := Plsqlap_Document_API.Get_Value(doc_, upper(nvl(parent_key_,'*')), inst_id_);
      inst_exists_ := Row_Exists___(db_name_, parent_name_, inst_name_);

      Trace___(' - instance ['||db_name_||']:'||parent_name_||' '||inst_name_||' already exists: '||CASE inst_exists_ WHEN TRUE THEN 'TRUE' ELSE 'FALSE' END);

      /*
      mode_     inst_exists_    action
      -------   -------------   ---------
      ADD       true            do nothing
      ADD       false           New__
      MERGE     true            Modify__
      MERGE     false           New__
      REPLACE   true            Modify__
      REPLACE   false           New__
      (REPLACE                  Remove__ not existing in file)
      DELIVERY                  same as merge
      */

      IF inst_exists_ AND mode_ <> 'ADD' THEN
         Update_Instance(inst_name_);
      ELSIF NOT inst_exists_ THEN
         Create_Instance(inst_name_);
      END IF;

      IF mode_ = 'REPLACE' THEN
         -- to handle none-existing instances...
         DECLARE
            instance_ Instance__;
         BEGIN
            instance_.parent_val := nvl(parent_name_, inst_name_);
            instance_.key_val := inst_name_;
            Trace___(' - REPLACE mode: adding instance ['||inst_name_||'] to preserve list at pos #'||to_char(inst_names_.count+1));
            inst_names_(inst_names_.count+1) := instance_;
         END;
      END IF;
   END;

BEGIN -- Import_Group___
   Trace___('>>> Found group ['||Plsqlap_Document_API.Get_Name(doc_, grp_id_)||']...');
   DECLARE
      instances_ Plsqlap_Document_API.Child_Table := Plsqlap_Document_API.Get_Child_Elements(doc_, grp_id_);
   BEGIN
      FOR i IN 1..instances_.COUNT LOOP
         result_.total := result_.total + 1;
         IF i = 1 THEN
            -- some late initializations done before importing first instance in a group
            db_name_       := Plsqlap_Document_API.Get_Name(doc_, instances_(i));
            Check_Group___(db_name_);
            parent_key_    := Get_Parent_Key___(db_name_);
            key_col_       := Get_Key___(db_name_);
            hidden_cols_   := NULL;
            special_cols_  := NULL;
            Fetch_Transformed_Columns___(db_name_, hidden_cols_, special_cols_);
         END IF;
         Import_Instance(instances_(i));
      END LOOP;
   END;

   IF mode_ = 'REPLACE' THEN
      Trace___(' - REPLACE mode: adding #'||to_char(inst_names_.count)||' instances fror ['||db_name_||'] to preserve map...');
      preserved_inst_(db_name_) := inst_names_;
   END IF;
END Import_Group___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Export_
-- Export one or more instances. The instances_ argument is a list of instances
-- separated by the '^' character. It is only possible to supply list of instances
-- of the same type, i.e. lu_name_ argument must be given.
-- If exp_customized_ is set to TRUE the customized flag will also be exported.
FUNCTION Export_ (
   lu_name_        IN VARCHAR2 DEFAULT NULL,
   instances_      IN VARCHAR2 DEFAULT NULL,
   exp_customized_ IN BOOLEAN  DEFAULT FALSE) RETURN CLOB
IS
   xml_     CLOB := Get_Header___;
   cnt_     INTEGER;
   db_name_ VARCHAR2(30);
BEGIN
   start_ := Dbms_Utility.Get_Time;
   fetch_cols_ := 0;

   IF lu_name_ IS NULL THEN
      -- if LU name is not given iterate through all supported groups
      -- and export each of them
      FOR i IN REVERSE 1..GROUPS.count LOOP
         Export_Group___(xml_, GROUPS(i), FALSE, exp_customized_);
      END LOOP;
   ELSE
      -- if LU name is given, convert it to DB name and check if valid
      db_name_ := Connect_Config_API.Mixed_Case_To_Db_Case_(lu_name_);
      Check_Group___(db_name_);
      -- parse a list of instances to be exported and export the group
      cnt_ := Parse_Selector_Values___(instances_);
      Export_Group___(xml_, db_name_, cnt_>0, exp_customized_);
   END IF;
   Append_Footer___(xml_);
   Trace___('All column lists fetched in #'||to_char(fetch_cols_/100)||' sec');
   RETURN xml_;
END Export_;


-- Import_
-- Import mode may be one of:
--    - REPLACE  - configuration form the file will replace the current configuration,
--                 which means instances not present in the file will be removed with
--                 exception of read-only (staticConfig) instances. This mode is supported
--                 for files containing complete configuration, so other types of files
--                 will cause an exception to be thrown.
--                 However groups not present in the file will remain untouched.
--
--    - MERGE    - New instances will be added and existing updated. An import file
--                 with a single instance that already exists will update it.
--
--    - ADD      - Only instances that not already exist will be added; all other will
--                 be ignored. If the file contains a single instance it is possible to
--                 give a new name.
--
--    - DELIVERY - Similar to MERGE, but will not update existing instances if customized
--                 flag is set to TRUE. If the import file contains customized flags,
--                 they will be preserved, otherwise imported instances will not be marked
--                 as customized.
--
--   In all modes except DELIVERY the customized flag will be set on New__ or Modify__.
-- If the import file contains only a single instance it is possible to rename it using
-- the new_name_ argument.
FUNCTION Import_ (
   xml_      IN CLOB,
   mode_     IN VARCHAR2 DEFAULT 'ADD',
   new_name_ IN VARCHAR2 DEFAULT NULL) RETURN Import_Result
IS
   doc_            Plsqlap_Document_API.Document;
   ver_id_         PLSQLAP_Document_API.Element_Id;
   ver_            VARCHAR2(10);
   groups_         Plsqlap_Document_API.Child_Table;
   preserved_inst_ Preserved_Instances;
   result_         Import_Result;
BEGIN
   start_ := Dbms_Utility.Get_Time;
   fetch_cols_ := 0;

   -- first check if the chosen import mode is valid
   Connect_Import_Mode_API.Exist_Db(mode_);
   Trace___('Importing XML file in mode ['||mode_||']...');

   -- read the entire import file to a PL/SQL Document and check the file version
   Plsqlap_Document_API.From_Ifs_Xml(doc_, xml_);
   ver_id_ := Plsqlap_Document_API.Get_Element_Id(doc_, 'EXPORT_VERSION');
   ver_ := Plsqlap_Document_API.Get_Value(doc_, ver_id_);
   IF ver_ <> '11.0' THEN
      Error_SYS.Appl_General(lu_name_, 'CONNCFGIMPVER: Not supported export file version [:P1]', ver_);
   END IF;
   Plsqlap_Document_API.Debug(doc_);

   -- new_name_ can only be given if the import file contains a single instance
   groups_ := Plsqlap_Document_API.Get_Child_Elements(doc_);
   IF groups_.COUNT = 2 AND Plsqlap_Document_API.Get_Child_Elements(doc_, groups_(2)).COUNT = 1 THEN
      Trace___('Export file contains single instance');
   ELSIF new_name_ IS NOT NULL THEN
      Error_SYS.Appl_General(lu_name_, 'CONNCFGIMPNAME: New name is valid only for file with a single instance');
   END IF;

   -- iterate through all groups in the file and call Import_Group___ for each one
   FOR g IN 1..groups_.COUNT LOOP
      IF groups_(g) <> ver_id_ THEN
         Import_Group___(doc_, groups_(g), mode_, new_name_, preserved_inst_, result_);
      END IF;
   END LOOP;

   -- in mode REPLACE remove all instances not present in the file,
   -- but only for groups represented in the file
   -- NOTE that removal is done according to the order on the list to minimize dependencies
   IF mode_ = 'REPLACE' THEN
      IF groups_.COUNT >= 10 THEN
         FOR i IN 1..GROUPS.count LOOP
            DECLARE
               db_name_   VARCHAR2(30)     := GROUPS(i);
            BEGIN
               result_.deleted := Remove_Rows___(db_name_, '%', preserved_inst_(db_name_));
            EXCEPTION
               WHEN no_data_found THEN
                  NULL;
            END;
         END LOOP;
      ELSE
         Error_SYS.Appl_General(lu_name_, 'CONNCFGIMPMODE: REPLACE mode is only available for files with all connect configurations');
      END IF;
   END IF;

   Trace___('All column lists fetched in #'||to_char(fetch_cols_/100)||' sec');
   -- returns the result counter
   RETURN result_;
END Import_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-------------------- LU  NEW METHODS -------------------------------------
