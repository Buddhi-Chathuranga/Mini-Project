-----------------------------------------------------------------------------
--
--  Logical unit: QueryHintUtility
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign  History
--  ------  ----  -----------------------------------------------------------
--  030219  HAAR  Created (ToDo#4152).
--  040707  ROOD  Modifications in Get_Dictionary_Info___ (F1PR413).
--  050411  JORA  Added assertion for dynamic SQL.  (F1PR481)
--  060105  UTGULK Annotated Sql injection.
--  060426  HAAR  Added code for handling of ROWSTATE and STATE (Bug#57581)
--  060621  HAAR  Added support for Persian calendar (Bug#58601).
--  070730  SUMALK Moved Assert_Is_View(view_name_) from Check_parse to Parse_Query_Hint_View_(Bug#65926)
--  120917  UsRaLK Rewrote the logic on [Remove_Comments___] (Bug#104758).
--  120903  MABALK Special handling for ROWSTATE in Get_Query_Hints__(Bug#104936)
--  280114  TMadLK Modified the logic in order to parse views successfully (Bug#114773)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE ColRec IS RECORD(
   column_name VARCHAR2(30),
   source      VARCHAR2(32000),
   real_value  VARCHAR2(32000),
   hint_type   VARCHAR2(10));
TYPE ColType IS TABLE OF ColRec INDEX BY BINARY_INTEGER;
TYPE ObjRec IS RECORD(
   table_name VARCHAR2(30),
   view_name  VARCHAR2(30));
TYPE ObjectType IS TABLE OF ObjRec INDEX BY BINARY_INTEGER;
TYPE IndexRec IS RECORD(
   index_name  VARCHAR2(30),
   column_name VARCHAR2(30));
TYPE IndexType IS TABLE OF IndexRec INDEX BY BINARY_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Parse___ (
   cols_        IN ColType,
   from_clause_ IN VARCHAR2,
   group_by_clause_  IN VARCHAR2) RETURN VARCHAR2
IS
   --
   stmt_   VARCHAR2(32000) := 'SELECT ';
   cursor_ INTEGER;
BEGIN
   -- Check if the stament can be parsed
   -- Construct the statement
   FOR i IN nvl(cols_.FIRST, 0) .. nvl(cols_.LAST, -1) LOOP
      stmt_ := stmt_ || cols_(i).source || ' ' || cols_(i).column_name || ',' || chr(10) || chr(13);
   END LOOP;
   -- Remove trailing comma, CR and LF
   stmt_ := Substr(stmt_, 1, length(stmt_) - 3);
   -- Add from-clause
   stmt_ := stmt_ || ' FROM ';
   stmt_ := stmt_ || from_clause_;
   -- Add group-by-clause
   IF (group_by_clause_ IS NOT NULL) THEN
     stmt_ := stmt_ || ' GROUP BY ';
     stmt_ := stmt_ || group_by_clause_;
   END IF;
   -- Check if stmt_ can be parsed
   cursor_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2006-01-05,utgulk)
   dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
   dbms_sql.close_cursor(cursor_);
   RETURN(NULL);
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cursor_)) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      RETURN(stmt_);
END Check_Parse___;


PROCEDURE Clear_All_Query_Hints___
IS
   CURSOR clear_views IS
      SELECT view_name
      FROM   query_hint_view_tab d
      WHERE  NOT EXISTS (
             SELECT 1
             FROM   user_views u
             WHERE  u.view_name = d.view_name);
   --
BEGIN
   -- Clear removed views
   FOR rec IN clear_views LOOP
      DELETE FROM query_hint_view_tab WHERE view_name = rec.view_name;
      clear_view_query_hints___(rec.view_name, 'TRUE');
   END LOOP;
END Clear_All_Query_Hints___;


PROCEDURE Clear_View_Query_Hints___ (
   view_name_     IN  VARCHAR2,
   remove_manual_ IN  VARCHAR2 DEFAULT 'FALSE' )
IS
BEGIN
   IF remove_manual_ = 'FALSE' THEN
      -- Remove old generated data, but not manually inserted data
      DELETE FROM query_hint_col_tab   WHERE view_name = view_name_ AND manual = 'FALSE';
      DELETE FROM query_hint_table_tab WHERE view_name = view_name_ AND manual = 'FALSE';
      DELETE FROM query_hint_index_tab WHERE view_name = view_name_ AND manual = 'FALSE';
   ELSE
      -- Remove all data for removed view
      DELETE FROM query_hint_col_tab   WHERE view_name = view_name_;
      DELETE FROM query_hint_table_tab WHERE view_name = view_name_;
      DELETE FROM query_hint_index_tab WHERE view_name = view_name_;
   END IF;

END Clear_View_Query_Hints___;


PROCEDURE Get_Dictionary_Info___ (
   lu_name_   OUT VARCHAR2,
   module_    OUT VARCHAR2,
   view_name_ IN  VARCHAR2 )
IS
   --SOLSETFW
   CURSOR get_lu IS
      SELECT l.lu_name lu_name, l.module module
      FROM dictionary_sys_view_active v, dictionary_sys_lu_active l
      WHERE v.view_name = view_name_
      AND v.lu_name = l.lu_name;
BEGIN
   FOR rec IN get_lu LOOP
      lu_name_ := rec.lu_name;
      module_  := rec.module;
   END LOOP;
END Get_Dictionary_Info___;


FUNCTION Get_From_Clause___ (
   view_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   from_clause_ VARCHAR2(32000);
   first_       BINARY_INTEGER;
   last_        BINARY_INTEGER := 0;
   continue_    BOOLEAN := TRUE;
   occurence_   BINARY_INTEGER := 0;
   tempory_from_clause_ VARCHAR2(32000);
   keyword_length_       BINARY_INTEGER := 0; -- to correctly identify the position after keywords
   --
   CURSOR get_view IS
      SELECT text
      FROM   user_views
      WHERE  view_name = view_name_;
BEGIN
   FOR rec IN get_view LOOP
      from_clause_ := remove_comments___(rec.text);
      -- Strip from clause from Union, Minus and Intersect
      -- Loop through to identify the correct occurence of Union, Minus and Intersect while matching parenthesis
      WHILE (continue_ = TRUE AND occurence_ < 10) LOOP
        occurence_ := occurence_ + 1;
        last_ := instr(from_clause_, ' UNION ');
        keyword_length_ := 7;
        IF (last_ = 0) THEN
           last_ := instr(from_clause_, ' MINUS ');
           keyword_length_ := 7;
           IF (last_ = 0) THEN
              last_ := instr(from_clause_, ' INTERSECT ');
              keyword_length_ := 11;
              IF (last_ = 0) THEN
                last_ := length(from_clause_)+1;
                keyword_length_ := 0;
              END IF;
           END IF;
        END IF;
        IF (last_ > 0) THEN
          -- If parenthesis are not matching, loop again until find a match
          IF ( Match_Parentheses___(tempory_from_clause_ || substr(from_clause_, 1, last_)) = TRUE) THEN
            continue_ := FALSE;
            from_clause_ := tempory_from_clause_ || substr(from_clause_, 1, last_);
          ELSE
            tempory_from_clause_ := tempory_from_clause_ || Substr(from_clause_, 1 , last_  + keyword_length_);
            from_clause_ := Substr(from_clause_, last_ + keyword_length_);
            keyword_length_ := 0;
          END IF;
        END IF;
      END LOOP;

      -- If the first character is '(', remove that with the last matching ')' 
      from_clause_ := TRIM(from_clause_);
      IF (substr(from_clause_, 1, 1) = '(' AND substr(from_clause_, LENGTH(from_clause_), 1) = ')') THEN
        from_clause_ := substr(from_clause_, 2);
        from_clause_ := substr(from_clause_, 1,LENGTH(from_clause_) - 1 );
      END IF;

      -- reinitialize the variables to use in next loop
      continue_ := TRUE;
      occurence_ := 0;
      tempory_from_clause_ := null;

      -- Find the start of the from-clause
      WHILE (continue_ = TRUE AND occurence_ < 15) LOOP
        occurence_ := occurence_ + 1;
        -- use REGEX because it can start from_clause_ in many ways
        first_       := REGEXP_INSTR(from_clause_, '(\s|CHR(10))(FROM|from)(\s|CHR(10)|\()' , 1, occurence_) + 6;

        IF (substr(from_clause_, first_ -1, 1) = '(') THEN
          first_ := first_ - 1;
        END IF;

        IF (Match_Parentheses___( substr(from_clause_, 1, first_ - 6)) = TRUE) THEN
          continue_ := FALSE;
          from_clause_ := substr(from_clause_, first_);
        END IF;
      END LOOP;

      continue_ := TRUE;
      occurence_ := 0;
      first_ := 1;
      
      -- Find the end of the from_clause_
      WHILE (continue_ = TRUE AND occurence_ < 10) LOOP
        occurence_ := occurence_ + 1;
        last_ := instr(from_clause_, ' WHERE ' );
        IF (last_ = 0) THEN
           last_ := instr(from_clause_, ' START ');
           IF (last_ = 0) THEN
              last_ := instr(from_clause_, ' GROUP ');
              IF (last_ = 0) THEN
                last_ := instr(from_clause_, ' WITH ' );
                IF (last_ = 0) THEN
                     last_ := instr(from_clause_, ' ORDER ');
                     IF (last_ = 0) THEN
                        last_ := length(from_clause_)+1;
                     END IF;
                   END IF;
                END IF;
           END IF;
        END IF;
        IF (last_ != 0) THEN
          IF ( Match_Parentheses___(tempory_from_clause_ || Substr(from_clause_, first_, last_ - first_ + 6)) = TRUE) THEN
            continue_ := FALSE;
            from_clause_ := tempory_from_clause_ || Substr(from_clause_, first_, last_ - first_);
          ELSE
            tempory_from_clause_ := tempory_from_clause_ || Substr(from_clause_, first_, last_ - first_ + 6);
            from_clause_ := Substr(from_clause_, last_ + 6);
          END IF;
        END IF;
      END LOOP;
   END LOOP;
   RETURN(from_clause_);
END Get_From_Clause___;


FUNCTION Get_Indexes___ (
   view_name_  IN VARCHAR2,
   table_name_ IN VARCHAR2,
   indxes_     IN IndexType ) RETURN IndexType
IS
   --
   i_          BINARY_INTEGER := nvl(indxes_.LAST, 0);
   ret_indxes_ IndexType := indxes_;
   --
   CURSOR get_ind_col IS
      SELECT u.index_name, nvl(d.column_name,u.column_name) column_name
      FROM   user_ind_columns u, query_hint_col_tab d
      WHERE  u.table_name = table_name_
      AND    u.column_name = d.SOURCE(+)
      AND    d.hint_type(+) = 'MISMATCH'
      AND    d.view_name(+) = view_name_
      AND    u.index_name NOT IN (
             SELECT index_name
             FROM   query_hint_index_tab d
             WHERE  d.view_name = view_name_)
      ORDER  BY index_name, column_position;
   --
BEGIN
   FOR rec IN get_ind_col LOOP
      i_ := i_ + 1;
      ret_indxes_(i_).index_name := rec.index_name;
      ret_indxes_(i_).column_name := rec.column_name;
   END LOOP;
   RETURN(ret_indxes_);
END Get_Indexes___;

-- Searching/Filtering an In-Memory enabled table column (without function calls)
-- should be as fast as filtering a indexed column, hence we can consider 
-- columns of such table as indexed 
-- special case: BLOBs and CLOBs are not handled by Oracle In-memory system
-- such columns are not consider (pseudo)indexed.
FUNCTION Get_Pseudo_IM_Indexes___ (
   view_name_  IN VARCHAR2,
   table_name_ IN VARCHAR2,
   indxes_     IN IndexType ) RETURN IndexType
IS
   --
   i_          BINARY_INTEGER := nvl(indxes_.LAST, 0);
   ret_indxes_ IndexType := indxes_;
   --SOLSETFW
   CURSOR get_pseudo_ind_col IS
      SELECT UNIQUE c.column_name, i.index_name
      FROM   query_hint_col_tab c
      JOIN   query_hint_table_tab t
      ON     t.view_name = c.view_name
      JOIN   fnd_im_segments s
      ON     t.table_name = s.segment_name
      LEFT OUTER JOIN user_ind_columns i
      ON     t.table_name = i.table_name AND c.column_name = i.column_name
      JOIN   dictionary_sys_tab_columns_act tc
      ON     t.table_name = tc.table_name AND c.column_name = tc.column_name
      WHERE  s.populate_status = 'COMPLETED'
      AND    c.hint_type != 'FUNCTION'
      AND    tc.data_type not in ('BLOB', 'CLOB')
      AND    t.view_name = view_name_
      AND    t.table_name = table_name_
      ORDER BY i.index_name;
   --
BEGIN
   IF Dictionary_SYS.Is_Db_Inmemory_Supported THEN
      FOR rec IN get_pseudo_ind_col LOOP
         i_ := i_ + 1;
         ret_indxes_(i_).index_name := rec.index_name;
         ret_indxes_(i_).column_name := rec.column_name;
      END LOOP;
   END IF;
   RETURN(ret_indxes_);
END Get_Pseudo_IM_Indexes___;

FUNCTION Get_Select_Clause___ (
   view_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   --
   select_clause_ VARCHAR2(32000);
   first_         BINARY_INTEGER;
   last_          BINARY_INTEGER;
   continue_      BOOLEAN := TRUE;
   occurence_   BINARY_INTEGER := 0;
   --
   CURSOR get_view IS
      SELECT text
      FROM   user_views
      WHERE  view_name = view_name_;
BEGIN
   FOR rec IN get_view LOOP
      select_clause_ := remove_comments___(rec.text);
      -- Find the start of the select_clause_
      first_         := REGEXP_INSTR(select_clause_, '(SELECT|select)(\s|CHR(10))') + 7;

      -- Find the end of the select_clause_
      WHILE (continue_ = TRUE AND occurence_ < 15) LOOP
        occurence_ := occurence_ +1;
        last_          := REGEXP_INSTR(select_clause_, '(\s|CHR(10))(FROM|from)(\s|CHR(10)|\()', first_ , occurence_ );
        IF (last_ = 0) THEN
           last_ := instr(select_clause_, 'WITH ');
           IF (last_ = 0) THEN
              last_ := instr(select_clause_, 'ORDER ');
              IF (last_ = 0) THEN
                 last_ := length(select_clause_);
              END IF;
           END IF;
        END IF;

        IF (Match_Parentheses___(Substr(select_clause_, first_, last_ - first_)) = TRUE) THEN
          continue_ := FALSE;
          select_clause_ := Substr(select_clause_, first_, last_ - first_);
        END IF;
      END LOOP;
   END LOOP;
   RETURN(select_clause_);
END Get_Select_Clause___;


FUNCTION Get_Tables___ (
   view_name_   IN VARCHAR2,
   from_clause_ IN VARCHAR2,
   objects_      IN ObjectType ) RETURN ObjectType
IS
   --
   clause_      VARCHAR2(200)  := upper(substr(from_clause_, 1,200));
   i_           BINARY_INTEGER := nvl(objects_.LAST, 0);
   ret_objects_ ObjectType     := objects_;
   appowner_    VARCHAR2(30)   := Fnd_Session_API.Get_App_Owner;
   --
   CURSOR get_ref_obj(owner_ IN VARCHAR2) IS
      SELECT referenced_type, referenced_owner, referenced_name
      FROM   user_dependencies
      WHERE  name = view_name_
      AND    referenced_owner = owner_
      AND    type = 'VIEW'
      AND    referenced_type IN ('TABLE', 'VIEW')
      AND    INSTR(clause_, referenced_name) > 0;
BEGIN
   FOR rec IN get_ref_obj(appowner_) LOOP
      IF (rec.referenced_type = 'TABLE') THEN
         i_ := i_ + 1;
         ret_objects_(i_).table_name := rec.referenced_name;
         ret_objects_(i_).view_name  := view_name_;
      ELSIF (rec.referenced_type = 'VIEW') THEN
         ret_objects_ := get_tables___(rec.referenced_name, get_from_clause___(rec.referenced_name), ret_objects_);
      END IF;
   END LOOP;
   RETURN(ret_objects_);
END Get_Tables___;


FUNCTION Parse_Select_Clause___ (
   view_name_ IN VARCHAR2 ) RETURN ColType
IS
   --
   first_          BINARY_INTEGER := 0;
   last_           BINARY_INTEGER := 0;
   col_id_         BINARY_INTEGER;
   i_              BINARY_INTEGER;
   error_          BOOLEAN;
   one_col_        BOOLEAN := TRUE;
   previous_col_   VARCHAR2(30);
   current_col_    VARCHAR2(30);
   select_clause_  VARCHAR2(32000);
   col_string_     VARCHAR2(32000);
   tmp_col_string_ VARCHAR2(32000);
   ret_columns_    ColType;
   --
   CURSOR get_columns IS
      SELECT column_name, column_id
      FROM   user_tab_columns u
      WHERE  table_name = view_name_
      ORDER  BY u.column_id DESC;
   --
   PROCEDURE Check_Parse_Result___(col_id_ IN NUMBER) IS
      --
      source_        VARCHAR2(32000);
      --
      CURSOR get_column IS
         SELECT source
         FROM   query_hint_col_tab
         WHERE  view_name = view_name_
         AND    column_name = previous_col_;
   BEGIN
      -- Save real value
      ret_columns_(col_id_).real_value := substr(col_string_, 1, 32000);
      -- Check if strings matches
      IF (Substr(col_string_, instr(col_string_, '.') + 1,
                 length(col_string_)) != previous_col_) THEN
         -- Check if function (or bad expression to search on) ...
         IF (instr(col_string_, '(') != 0) THEN
            -- Special handling for state, if encode method exists we can convert to db column in client
            IF (previous_col_ = 'STATE') THEN
               IF (Dictionary_SYS.Get_State_Encode_Method__(view_name_) IS NOT NULL) THEN
                  ret_columns_(col_id_).hint_type := 'NORMAL';
               ELSE
                  ret_columns_(col_id_).hint_type := 'FUNCTION';
               END IF;
            ELSE
               ret_columns_(col_id_).hint_type := 'FUNCTION';
            END IF;
         ELSE
            -- Strip from trailing table alias if not function
            tmp_col_string_ := ltrim(rtrim(Substr(col_string_,
                                              instr(col_string_, '.', 1) + 1)));
            -- ... could still be function ...
            IF (instr(tmp_col_string_, '*') != 0) OR
               (instr(tmp_col_string_, '/') != 0) OR
               (instr(tmp_col_string_, '+') != 0) OR
               (instr(tmp_col_string_, '-') != 0) OR
               (instr(tmp_col_string_, '||') != 0) OR
               (instr(tmp_col_string_, '''') != 0) OR
               (instr(tmp_col_string_, '.') != 0) THEN
               ret_columns_(col_id_).hint_type := 'FUNCTION';
            ELSE
            -- ... otherwise mismatch ...
            -- Special handling for state, if encode method exists we can convert to db column in client
               IF (previous_col_ = 'STATE') THEN
                  IF (Dictionary_SYS.Get_State_Encode_Method__(view_name_) IS NULL) THEN
                     ret_columns_(col_id_).hint_type := 'NORMAL';
                  ELSE
                     ret_columns_(col_id_).hint_type := 'MISMATCH';
                  END IF;
               -- Special handling for objstate, rowstate is db column
               ELSIF (previous_col_ = 'OBJSTATE') THEN
                  ret_columns_(col_id_).hint_type := 'NORMAL';
               ELSE
                  ret_columns_(col_id_).hint_type := 'MISMATCH';
               END IF;
            END IF;
         END IF;
      ELSE
         -- ... else normal ...
         ret_columns_(col_id_).hint_type := 'NORMAL';
      END IF;
      ret_columns_(col_id_).column_name := previous_col_;
      -- Get the manual source value if it exists
      source_ := NULL;
      OPEN  get_column;
      FETCH get_column INTO source_;
      CLOSE get_column;
      -- if manual source value exists use that, otherwise use new source value
      ret_columns_(col_id_).source := nvl(source_, substr(col_string_, 1, 32000));
   END Check_Parse_Result___;
   --
BEGIN
   select_clause_ := get_select_clause___(view_name_);
   OPEN  get_columns;
   FETCH get_columns INTO previous_col_, col_id_;
   IF get_columns%NOTFOUND THEN
      CLOSE get_columns;
      Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Should not occur!!!');
      RAISE no_data_found;
   END IF;
   LOOP
      FETCH get_columns
         INTO current_col_, col_id_;
      -- If only on column exists in the Select list
      IF get_columns%NOTFOUND THEN
         IF (one_col_ = TRUE) THEN
            -- Remove previous_col from select_clause_
            col_string_ := ltrim(rtrim(Substr(select_clause_, 1,
                                              instr(select_clause_,
                                                     previous_col_, -1) - 1)));
            IF col_string_ = '"' THEN
              col_string_ := '';
            END IF;
         ELSE
            -- Remove previous_col from select_clause_
            col_string_ := ltrim(rtrim(select_clause_));
         END IF;
         check_parse_result___(col_id_);
         EXIT;
      END IF;
      one_col_ := FALSE;
      -- Real code starts here
      IF last_ = 0 THEN
         last_ := instr(select_clause_, previous_col_, -1, 1);
         IF ((Substr(select_clause_, last_ - 1, 1) = '"') AND
            (Substr(select_clause_, last_ + length(previous_col_), 1) = '"')) THEN
             last_ := last_ -1;
         END IF;
      ELSE
         last_ := first_;
      END IF;
      -- Remove previous_col from select_clause_
      select_clause_ := ltrim(rtrim(Substr(select_clause_, 1, last_ - 1)));
      i_             := 0;
      first_         := 1;
      -- Find the right current column
      <<While_Loop_>>
      WHILE first_ > 0 LOOP
         i_     := i_ + 1;
         first_ := instr(Substr(select_clause_, 1,
                                instr(select_clause_, ',', -1)),
                         current_col_, -1, i_);

         col_string_ := ltrim(rtrim(Substr(select_clause_,
                                        instr(select_clause_, ',', first_) + 1)));

         IF ((Substr(select_clause_, first_ - 1, 1) = ' ') OR
            (Substr(select_clause_, first_ + length(current_col_), 1) = ' ') OR
            (Substr(select_clause_, first_ + length(current_col_), 1) = ',')) THEN
            IF (Substr(select_clause_, first_ + length(current_col_), 1) = ')') OR
               (Substr(select_clause_, first_ - 1, 1) = '(') THEN
               error_ := TRUE;
            ELSIF (Match_Parentheses___(col_string_) = FALSE) THEN
              GOTO While_Loop_;
            ELSE
               EXIT;
            END IF;
         ELSIF ((Substr(select_clause_, first_ - 1, 1) = '"') AND
            (Substr(select_clause_, first_ + length(current_col_), 1) = '"')) THEN
            first_ := first_ - 1;
            EXIT;
         ELSE
            error_ := TRUE;
         END IF;
      END LOOP;
      col_string_ := ltrim(rtrim(Substr(select_clause_,
                                        instr(select_clause_, ',', first_) + 1)));
      -- Change select_clause_
      select_clause_ := Substr(select_clause_, 1, first_ - 1);
      check_parse_result___(col_id_ + 1);
      previous_col_ := current_col_;
   END LOOP;
   IF get_columns%ISOPEN THEN
      CLOSE get_columns;
   END IF;
   RETURN(ret_columns_);
END Parse_Select_Clause___;


FUNCTION Check_Modified_Base_View___ (
   view_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   base_view_name_ VARCHAR2(32000);
   base_view_text_ VARCHAR2(32000);
   match_count_    INTEGER := 0;
BEGIN
   --
   BEGIN
      --SOLSETFW
      SELECT view_name INTO base_view_name_
      FROM dictionary_sys_view_active
      WHERE view_name = view_name_ AND
            view_type = 'B';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         base_view_name_ := NULL;
         NULL;
   END;
   
   IF base_view_name_ IS NULL THEN
      RETURN 'FALSE';
   END IF;
   
   SELECT text_vc INTO base_view_text_
   FROM sys.user_views
   WHERE view_name = view_name_;
   
   match_count_ := regexp_count(base_view_text_, '[\s,][Tt]0\.');
   base_view_text_ := NULL;
   
   IF match_count_ > 0 THEN
      RETURN 'TRUE';
   END IF;
   
   RETURN 'FALSE';
   --
END Check_Modified_Base_View___;


PROCEDURE Rebuild_Base_View_Query_Hints___ (
   attr_      OUT VARCHAR2,
   view_name_ IN  VARCHAR2)
IS
   TYPE index_typ IS TABLE OF VARCHAR2(32000);
   TYPE dict_view_col_rec IS RECORD (
      column_name_ VARCHAR2(3200),
      source_      VARCHAR2(3200),
      type_        VARCHAR2(3200)
   );
   TYPE dict_view_col_typ IS TABLE OF dict_view_col_rec;
   --
   table_name_ VARCHAR2(32000);
   lu_name_    VARCHAR2(30);
   module_     VARCHAR2(6);
   idx_cols_   index_typ;
   view_cols_  dict_view_col_typ;
BEGIN
   --
   Get_Dictionary_Info___(lu_name_, module_, view_name_);
   table_name_ := Dictionary_SYS.Get_Base_Table_Name(lu_name_);
   
   IF table_name_ IS NULL THEN
      RETURN;
   END IF;
   
   BEGIN
      SELECT column_name
         BULK COLLECT INTO idx_cols_
         FROM sys.user_ind_columns
         WHERE table_name = table_name_;
      --SOLSETFW   
      SELECT * BULK COLLECT INTO view_cols_ 
         FROM (SELECT column_name, table_column_name AS source, 'FUNCTION' AS type 
                  FROM dictionary_sys_view_column_act 
                  WHERE table_column_name IS NOT NULL
                  AND view_name = view_name_
               UNION ALL
               SELECT column_name, enumeration AS source, 'IID' AS type 
                  FROM dictionary_sys_view_column_act 
                  WHERE enumeration IS NOT NULL
                  AND view_name = view_name_);        
   END;
   
   FOR i_ IN 1..idx_cols_.COUNT LOOP
      BEGIN
         INSERT INTO query_hint_col_tab (view_name, column_name, source, hint_type, manual, rowversion)
         VALUES (view_name_, idx_cols_(i_), idx_cols_(i_), 'NORMAL', 'FALSE', SYSDATE);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            NULL;
      END;
   END LOOP;
   
   FOR i_ IN 1..view_cols_.COUNT LOOP
      BEGIN
         INSERT INTO query_hint_col_tab (view_name, column_name, source, hint_type, manual, rowversion)
         VALUES (view_name_, view_cols_(i_).column_name_, UPPER(view_cols_(i_).source_), view_cols_(i_).type_, 'FALSE', SYSDATE);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            NULL;
      END;   
   END LOOP;
   
   BEGIN
      INSERT INTO query_hint_table_tab (view_name, table_name, manual, rowversion)
            VALUES (view_name_, table_name_, 'FALSE', SYSDATE);
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               NULL;
   END;

   Get_Dictionary_Info___(lu_name_, module_, view_name_);
   
   BEGIN
      INSERT INTO query_hint_view_tab (view_name, lu_name, module, parsed, timestamp, rowversion)
      VALUES (view_name_, lu_name_, module_, 'TRUE', SYSDATE, SYSDATE);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         UPDATE query_hint_view_tab
         SET 
            lu_name    = lu_name_,
            module     = module_,
            parsed     = 'TRUE',
            timestamp  = sysdate,
            rowversion = sysdate
         WHERE view_name = view_name_;
   END;
   
   Client_SYS.Add_To_Attr('LU_NAME', lu_name_, attr_);
   Client_SYS.Add_To_Attr('MODULE', module_, attr_);
   Client_SYS.Add_To_Attr('PARSED_DB', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('TIMESTAMP', sysdate, attr_);
   Client_SYS.Add_To_Attr('INVALID_QUERY_HINT', Query_Hint_View_API.Invalid_Query_Hint__(view_name_), attr_);
   --
END Rebuild_Base_View_Query_Hints___;


FUNCTION Remove_Comments___ (
   view_text_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   str_start_   NUMBER := 0;           -- String Start
   str_finish_  NUMBER := 0;           -- String Finish
   mul_start_   NUMBER := 0;           -- Multi line comment start
   mul_finish_  NUMBER := 0;           -- Multi line comment finish
   sin_start_   NUMBER := 0;           -- Single line comment start
   sin_finish_  NUMBER := 0;           -- Single line comment finish
   curr_pos_    NUMBER := 1;           -- Pointer to the current position of scan
   str_pos_     NUMBER := 0;           -- Current position in the string
   length_      NUMBER := 0;           -- Temp var to hold lengh information
   str_contin_  NUMBER := 0;           -- Temp var to hold string continuation related info
   return_tx_   VARCHAR2(32000) := ''; -- Text that will be returned after comments are stripped
   length_tx_   NUMBER := LENGTH(view_text_);
BEGIN
   -------------------------------------------------------------------------
   -- 1. Get the first occurrence of                                      --
   --      * String start                                                 --
   --      * Single line comment start                                    --
   --      * Multi line comment start                                     --
   -- 2. Copy the executable code up to that point to the return string.  --
   -- 3. If string found first copy the code until end of string.         --
   -- 4. If comments found strip it from code and continue search.        --
   -------------------------------------------------------------------------
   WHILE ( (curr_pos_ > -1) AND (curr_pos_ <= length_tx_) ) LOOP
      str_start_ := INSTR(view_text_, '''', curr_pos_);
      mul_start_ := INSTR(view_text_, '/*', curr_pos_);
      sin_start_ := INSTR(view_text_, '--', curr_pos_);
      --
      IF (str_start_ > 0) AND (( str_start_ < mul_start_ ) OR (mul_start_ = 0)) AND ((str_start_ < sin_start_) OR (sin_start_ = 0)) THEN
         length_     := str_start_ - curr_pos_;
         return_tx_  := return_tx_ || SUBSTR(view_text_, curr_pos_, length_);
         --
         curr_pos_   := str_start_;
         str_finish_ := str_start_;
         str_contin_ := str_start_;
         str_pos_    := str_start_ + 1; -- +1 so the search will be inside the string
         --
         WHILE ( ( str_pos_ > 0 ) AND ( str_pos_ < length_tx_ ) AND ( str_finish_ > 0 ) AND ( curr_pos_ > 0 ) ) LOOP
            str_finish_ := INSTR(view_text_, '''', str_pos_);
            str_contin_ := INSTR(view_text_, '''''', str_pos_);
            IF ( ( str_finish_ > 0 ) AND ( str_finish_ = str_contin_ )) THEN
               str_pos_ := str_contin_ + 2; -- Add two characters for "''"
            ELSE
               EXIT;
            END IF;
         END LOOP;
         curr_pos_   := str_finish_;     -- Current position will be advanced by one more at the end of the loop
         str_finish_ := str_finish_ + 1; -- Add one to include the string closing quote also
         length_     := str_finish_ - str_start_;
         return_tx_  := return_tx_ || SUBSTR(view_text_, str_start_, length_);
      ELSIF (sin_start_ > 0) AND (( sin_start_ < mul_start_ ) OR (mul_start_ = 0)) THEN
         length_     := sin_start_ - curr_pos_;
         return_tx_  := return_tx_ || SUBSTR(view_text_, curr_pos_, length_);
         return_tx_  := return_tx_ || ' ';
         -- Remove "--" comments
         sin_finish_ := INSTR(view_text_, chr(10), sin_start_);
         IF ( sin_finish_ > 0 ) THEN
            -- TODO: Do we need to remove the end-of-line character as well?
            curr_pos_ := sin_finish_ - 1; -- EOL will be left untouched.
         ELSE
            curr_pos_ := length_tx_;
         END IF;
      ELSIF (mul_start_ > 0) THEN
         length_    := mul_start_ - curr_pos_;
         return_tx_ := return_tx_ || SUBSTR(view_text_, curr_pos_, length_);
         return_tx_ := return_tx_ || ' ';
         -- Remove /* */ comments
         mul_finish_ := INSTR(view_text_, '*/', mul_start_); -- Need to add 2 for * and /
         IF ( mul_finish_ > 0 ) THEN
            curr_pos_ := mul_finish_ + 1; -- Need to add 2 for * and / (another will be added at the end of the loop)
         ELSE
            -- Emergency exit - should normally not occur
            curr_pos_ := length_tx_;
         END IF;
      ELSE
         return_tx_ := return_tx_ || SUBSTR(view_text_, curr_pos_);
         EXIT; -- No more comments to be removed so exit the main loop
      END IF;
      curr_pos_  := curr_pos_ + 1;
   END LOOP;
   -- Remove CR and LF
   -- TODO: Why uppercase? (This comes from previous logic)
   return_tx_ := TRANSLATE(UPPER(return_tx_), chr(10), ' ');
   return_tx_ := TRANSLATE(UPPER(return_tx_), chr(13), ' ');
   --
   RETURN return_tx_;
END Remove_Comments___;


PROCEDURE Update_Iids___ (
   view_name_ IN VARCHAR2 )
IS
   --
   CURSOR get_iid IS
   SELECT a.view_name,a.column_name, b.column_name db_column_name
   FROM   query_hint_col_tab a, query_hint_col_tab b
   WHERE  a.view_name = view_name_
   AND    a.view_name = b.view_name
   AND    a.column_name = b.column_name||'_DB';
BEGIN
   FOR rec IN get_iid LOOP
      UPDATE query_hint_col_tab
      SET    hint_type = 'IID'
      WHERE  view_name = view_name_
      AND    column_name IN (rec.column_name, rec.db_column_name);
   END LOOP;
END Update_Iids___;

FUNCTION Match_Parentheses___ (
  text_ IN VARCHAR2) RETURN BOOLEAN

IS
  reduced_text_          VARCHAR2(400) ;
  parenthesis_string_    VARCHAR2(400);
  c_                     CHAR ;
  final_string_          VARCHAR2(50);

BEGIN
  -- reduce the text in order to remove characters and other symbols as much as can
  reduced_text_ := REGEXP_REPLACE( text_, '\w|\*|\.|,|\s|=|-|>|<|"|''|\+|\|');

  -- filter only the parenthesis from the text
  IF reduced_text_ IS NOT NULL THEN
    FOR i IN 1 .. LENGTH(reduced_text_) LOOP
      c_ := SUBSTR(reduced_text_,i,1);
      IF( c_ = '(' OR c_ = ')') THEN
        parenthesis_string_ := parenthesis_string_ || c_;
      END IF;
    END LOOP;
  END IF;

  -- if the starting parenthesis is ')' or ending parenthesis is '(' return false
  IF(SUBSTR(parenthesis_string_,1,1) = ')' OR SUBSTR(parenthesis_string_,LENGTH(parenthesis_string_),1) = '(' OR LENGTH(parenthesis_string_) MOD 2 = 1 ) THEN
     RETURN FALSE;
  END IF;

  final_string_ := SUBSTR(parenthesis_string_,1,1);

  -- match parentesis pairs
  IF final_string_ IS NOT NULL THEN
    FOR i IN 2 .. LENGTH(parenthesis_string_) LOOP
      c_ := SUBSTR(parenthesis_string_,i,1);
      IF( c_ = ')' ) THEN
        IF(final_string_ IS NULL) THEN
          RETURN FALSE;
        ELSE
          final_string_ := SUBSTR(final_string_,1,LENGTH(final_string_)-1);
        END IF;
      ELSE
        final_string_ := final_string_ || '(';
      END IF;
    END LOOP;
  END IF;

  -- if the final string is null, that means parenthesis are matching
  IF(final_string_ IS NULL) THEN
     RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END Match_Parentheses___;

FUNCTION Get_Group_By_Clause___ (
   view_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   group_by_clause_ VARCHAR2(32000);
   first_       BINARY_INTEGER;
   last_        BINARY_INTEGER := 0;
   continue_    BOOLEAN := TRUE;
   occurence_   BINARY_INTEGER := 0;
   tempory_group_by_clause_ VARCHAR2(32000);
   keyword_length_       BINARY_INTEGER := 0; -- to coreectly identify the position after keywords

   CURSOR get_view IS
      SELECT text
      FROM   user_views
      WHERE  view_name = view_name_;
BEGIN
   FOR rec IN get_view LOOP
      group_by_clause_ := remove_comments___(rec.text);

      -- Find the start of the union or minus or intersect
      WHILE (continue_ = TRUE AND occurence_ < 3) LOOP
        occurence_ := occurence_ + 1;
        last_ := instr(group_by_clause_, ' UNION ');
        keyword_length_ := 7;
        IF (last_ = 0) THEN
           last_ := instr(group_by_clause_, ' MINUS ');
           keyword_length_ := 7;
           IF (last_ = 0) THEN
              last_ := instr(group_by_clause_, ' INTERSECT ');
              keyword_length_ := 11;
              IF (last_ = 0) THEN
                last_ := length(group_by_clause_)+1;
                keyword_length_ := 0;
              END IF;
           END IF;
        END IF;
        IF (last_ > 0) THEN
          IF ( Match_Parentheses___(tempory_group_by_clause_ || substr(group_by_clause_, 1, last_)) = TRUE) THEN
            continue_ := FALSE;
            group_by_clause_ := tempory_group_by_clause_ || substr(group_by_clause_, 1, last_);
          ELSE
            tempory_group_by_clause_ := tempory_group_by_clause_ || Substr(group_by_clause_, 1 , last_  + keyword_length_ );
            group_by_clause_ := Substr(group_by_clause_, last_ + keyword_length_ );
            keyword_length_ := 0;
          END IF;
        END IF;
      END LOOP;

      continue_ := TRUE;
      occurence_ := 0;
      -- Find the start of the group-by-clause
      WHILE (continue_ = TRUE AND occurence_ < 5) LOOP
        occurence_ := occurence_ + 1;
        -- use REGEX since there can be the keywords GROUP BY with different number of spaces
        first_       := REGEXP_INSTR(group_by_clause_, ' GROUP\s+BY ', 1, occurence_) + 10;
        IF first_ != 10 THEN
          IF (Match_Parentheses___( substr(group_by_clause_, 1, first_ - 10)) = TRUE) THEN
            continue_ := FALSE;
          END IF;
        END IF;
      END LOOP;

      -- if there's no Group By keyword, there's no group_by_clause_. Else, find the end of the group_by_clause_
      IF first_ = 10 THEN
        group_by_clause_ := '';
      ELSE
        group_by_clause_ := substr(group_by_clause_, first_);
        first_ := 1;
        last_ := instr(group_by_clause_, ' START ');
        IF (last_ = 0) THEN
           last_ := instr(group_by_clause_, ' WITH ');
           IF (last_ = 0) THEN
              last_ := instr(group_by_clause_, ' ORDER ');
              IF (last_ = 0) THEN
                 last_ := length(group_by_clause_)+1;
              END IF;
           END IF;
        END IF;
        IF (last_ != 0) THEN
           group_by_clause_ := Substr(group_by_clause_, first_, last_ - first_);
        END IF;
      END IF;
   END LOOP;
   RETURN(group_by_clause_);
END Get_Group_By_Clause___;

-----------------------------------------------------------------------------
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Count_Invalid_Query_Hints__ RETURN NUMBER
IS
   rebuild_needed_ NUMBER;
   CURSOR get_views IS
      SELECT COUNT(o.object_name)
      FROM   user_objects o,
             query_hint_view_tab d
      WHERE  o.object_type = 'VIEW'
      AND    o.object_name = d.view_name(+)
      AND    o.timestamp > TO_CHAR(nvl(d.timestamp, Database_SYS.First_Calendar_Date_), 'RRRR-MM-DD:HH24:MI:SS');
BEGIN
   OPEN  get_views;
   FETCH get_views INTO rebuild_needed_;
   CLOSE get_views;
   RETURN (rebuild_needed_);
END Count_Invalid_Query_Hints__;


PROCEDURE Get_Query_Hints__ (
   indexes_   OUT VARCHAR2,
   functions_ OUT VARCHAR2,
   view_name_ IN  VARCHAR2 )
IS
   i_          BINARY_INTEGER := 0;
   j_          BINARY_INTEGER := 0;
   index_name_ VARCHAR2(30) := 'QwErTy';
   indxes_     IndexType;
   -- When a table is In-Memory enabled it should be as fast as if not faster than accessing a DB index
   inmemory_pseudo_indx_ IndexType;
   
   indx_col_found_ BOOLEAN;
   
   message_    VARCHAR2(32000) := Message_SYS.Construct('');
   --
   CURSOR get_view_dep IS
      SELECT view_name, table_name
      FROM   query_hint_table_tab
      WHERE  view_name = view_name_;
   --
   CURSOR get_function_col IS
      SELECT column_name, source, hint_type
      FROM   query_hint_col_tab
      WHERE  hint_type = 'FUNCTION'
      AND    view_name = view_name_
      AND    column_name NOT IN ('OBJVERSION', 'OBJID');
BEGIN
   -- Fetch values for indexed columns
   FOR rec IN get_view_dep LOOP
      indxes_ := get_indexes___(view_name_, rec.table_name, indxes_);
      IF Dictionary_SYS.Is_Db_Inmemory_Supported THEN
         inmemory_pseudo_indx_ := Get_Pseudo_IM_Indexes___(view_name_, rec.table_name, inmemory_pseudo_indx_);
      END IF;
   END LOOP;
         
   FOR i IN nvl(indxes_.FIRST, 0) .. nvl(indxes_.LAST, -1) LOOP
      IF (index_name_ != indxes_(i) .index_name) THEN
         j_          := 1;
         index_name_ := indxes_(i) .index_name;
      ELSE
         j_ := j_ + 1;
      END IF;
      -- Special handling for rowstate, if encode method exists handle state skip rowstate
      IF (indxes_(i).column_name = 'ROWSTATE') THEN
         IF (Dictionary_SYS.Get_State_Encode_Method__(view_name_) IS NOT NULL) THEN     
            Message_SYS.Add_Attribute(message_, 'STATE', to_char(j_));
         ELSE
            j_ := j_ - 1;
         END IF;
      ELSE
         Message_SYS.Add_Attribute(message_, indxes_(i).column_name, to_char(j_));
      END IF;
   END LOOP;
   
   IF Dictionary_SYS.Is_Db_Inmemory_Supported THEN
   -- Note: Last parameter to Message_SYS.Add_Attribute is to indicate that those columns belong to the same index
   -- that means if columns A, B, C are index using indexD numbers related with A,B,C columns will be 1,2,3 respectively 
   -- But in In-Memory case it's not a actual index, but a pseudo index; therefore it will be considered as a seperate index per column
   
      FOR k IN nvl(inmemory_pseudo_indx_.FIRST, 0) .. nvl(inmemory_pseudo_indx_.LAST, -1) LOOP
         -- Special handling for rowstate, if encode method exists handle state skip rowstate
         IF (inmemory_pseudo_indx_(k).column_name = 'ROWSTATE') THEN
            CONTINUE;
         ELSE
            -- only add in-memory columns as indexes if they are not already added as indexed columns
            indx_col_found_ := FALSE;
            FOR i IN nvl(indxes_.FIRST, 0) .. nvl(indxes_.LAST, -1) LOOP
               IF indxes_(i).column_name = inmemory_pseudo_indx_(k).column_name THEN 
                  indx_col_found_ := TRUE;
                  EXIT WHEN indx_col_found_;
               END IF;
            END LOOP;
            IF NOT indx_col_found_ THEN
               Message_SYS.Add_Attribute(message_, inmemory_pseudo_indx_(k).column_name, to_char(1));
            END IF;
         END IF;
      END LOOP;
   END IF;
   
   indexes_ := message_;
   -- Fetch values for bad columns
   i_       := 0;
   message_ := Message_SYS.Construct('');
   FOR rec IN get_function_col LOOP
      -- Special handling for state, if encode method exists we can convert to db column in client
      IF (rec.column_name = 'STATE') THEN
         IF (Dictionary_SYS.Get_State_Encode_Method__(view_name_) IS NULL) THEN
            i_ := i_ + 1;
            Message_SYS.Add_Attribute(message_, rec.column_name, to_char(i_));
         END IF;
      ELSE
         i_ := i_ + 1;
         Message_SYS.Add_Attribute(message_, rec.column_name, to_char(i_));
      END IF;
   END LOOP;
   functions_ := message_;
END Get_Query_Hints__;


PROCEDURE Submit_All_Query_Hints__ (
   remove_manual_ IN  VARCHAR2 )
IS
   attr_ VARCHAR2(100);
BEGIN
   Client_SYS.Add_To_Attr('REMOVE_MANUAL_', remove_manual_, attr_);
   Transaction_SYS.Deferred_Call('Query_Hint_Utility_API.Rebuild_All_Query_Hints_',
                                 'PARAMETER',
                                 attr_,
                                 'Rebuild Query Hints for all views');
END Submit_All_Query_Hints__;


PROCEDURE Submit_Invalid_Query_Hints__ (
   remove_manual_ IN  VARCHAR2 )
IS
   attr_ VARCHAR2(100);
BEGIN
   Client_SYS.Add_To_Attr('REMOVE_MANUAL_', remove_manual_, attr_);
   Transaction_SYS.Deferred_Call('Query_Hint_Utility_API.Rebuild_Invalid_Query_Hints_',
                                 'PARAMETER',
                                 attr_,
                                 'Rebuild Query Hints for invalid views');
END Submit_Invalid_Query_Hints__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

FUNCTION Parse_Query_Hint_View_ (
   view_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cols_ ColType;
   i_    BINARY_INTEGER := 0;
   --
   CURSOR get_columns IS
      SELECT column_name, source
      FROM   query_hint_col_tab
      WHERE  view_name = view_name_;
BEGIN
   Assert_SYS.Assert_Is_View(view_name_);
   FOR rec IN get_columns LOOP
      i_ := i_ + 1;
      cols_(i_).column_name := rec.column_name;
      cols_(i_).source      := rec.source;
   END LOOP;
   RETURN (check_parse___(cols_, get_from_clause___(view_name_), Get_Group_By_Clause___(view_name_)));
EXCEPTION
   WHEN value_error THEN
      RETURN('View text too long for the Query Hint Parser!');
END Parse_Query_Hint_View_;


PROCEDURE Rebuild_All_Query_Hints_ (
   remove_manual_ IN VARCHAR2 )
IS
   attr_        VARCHAR2(32000);
   total_views_ NUMBER;
   --
   CURSOR get_views IS
      SELECT view_name
      FROM   user_views v
	  WHERE v.view_name NOT LIKE 'AQ$%';
   CURSOR count_views IS
      SELECT count(*)
      FROM   user_views v
	  WHERE v.view_name NOT LIKE 'AQ$%';
BEGIN
   -- Clear removed views
   OPEN count_views;
   FETCH count_views INTO total_views_;
   CLOSE count_views;
   Transaction_SYS.Update_Total_Work(Transaction_SYS.Get_Current_Job_Id, total_views_);
   @ApproveTransactionStatement(2013-11-19,haarse)
   COMMIT;
   clear_all_query_hints___;
   -- Rebuild all views
   FOR rec IN get_views LOOP
      Rebuild_View_Query_Hints_ (attr_, rec.view_name, remove_manual_);
      Transaction_SYS.Log_Progress_Info(rec.view_name);
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
   END LOOP;
   Transaction_SYS.Log_Progress_Info(NULL);
END Rebuild_All_Query_Hints_;


PROCEDURE Rebuild_Invalid_Query_Hints_ (
   remove_manual_ IN VARCHAR2 )
IS
   attr_   VARCHAR2(32000);
   total_views_ NUMBER;
   --
   CURSOR get_views IS
      SELECT o.object_name view_name
      FROM   user_objects o,
             query_hint_view_tab d
      WHERE  o.object_type = 'VIEW'
      AND    o.object_name = d.view_name(+)
      AND    o.timestamp > TO_CHAR(nvl(d.timestamp, Database_SYS.First_Calendar_Date_), 'RRRR-MM-DD:HH24:MI:SS')
      AND    o.object_name NOT LIKE 'AQ$%';
   CURSOR count_views IS
      SELECT count(*)
      FROM   user_objects o,
             query_hint_view_tab d
      WHERE  o.object_type = 'VIEW'
      AND    o.object_name = d.view_name(+)
      AND    o.timestamp > TO_CHAR(nvl(d.timestamp, Database_SYS.First_Calendar_Date_), 'RRRR-MM-DD:HH24:MI:SS')
      AND    o.object_name NOT LIKE 'AQ$%';
BEGIN
   OPEN count_views;
   FETCH count_views INTO total_views_;
   CLOSE count_views;
   Transaction_SYS.Update_Total_Work(Transaction_SYS.Get_Current_Job_Id, total_views_);
   @ApproveTransactionStatement(2013-11-19,haarse)
   COMMIT;
   -- Clear removed views
   clear_all_query_hints___;
   -- Rebuild all views
   FOR rec IN get_views LOOP
      Transaction_SYS.Log_Progress_Info(rec.view_name);
      Rebuild_View_Query_Hints_ (attr_, rec.view_name, remove_manual_);    
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
   END LOOP;
   Transaction_SYS.Log_Progress_Info(NULL);
END Rebuild_Invalid_Query_Hints_;

PROCEDURE Rebuild_Other_View_Query_Hints (
   attr_          OUT VARCHAR2,
   view_name_     IN  VARCHAR2,
   remove_manual_ IN  VARCHAR2 )
IS
   cols_            ColType;
   objects_         ObjectType;
   from_clause_     VARCHAR2(32000);
   group_by_clause_ VARCHAR2(32000);
   stmt_            VARCHAR2(32000);
   parsed_          VARCHAR2(5);
   lu_name_         VARCHAR2(30);
   module_          VARCHAR2(6);
   source_          VARCHAR2(2000);
   timestamp_       DATE;
BEGIN
   -- Get the from-clause
   from_clause_ := get_from_clause___(view_name_);
   -- Get the group-by-clause
   group_by_clause_ := Get_Group_By_Clause___(view_name_);
   -- Parse the view source code and get the column information
   cols_         := parse_select_clause___(view_name_);
   -- Parse the parse code to see if the first parse was successful
   stmt_ := check_parse___(cols_, from_clause_,group_by_clause_);
   IF (stmt_ IS NULL) THEN
      parsed_ := 'TRUE';
   ELSE
      parsed_ := 'FALSE';
   END IF;
   -- Loop over all the columns
   FOR i IN nvl(cols_.FIRST, 0) .. nvl(cols_.LAST, -1) LOOP
      -- Only insert columns that has a reason for Query Hint
      source_ := substr(cols_(i).source, 1, 2000);
      BEGIN
         INSERT INTO query_hint_col_tab
            (view_name, column_name, source, hint_type, manual, rowversion)
         VALUES
            (view_name_, cols_(i).column_name, source_, cols_(i).hint_type, 'FALSE', SYSDATE);
      EXCEPTION
         WHEN dup_val_on_index THEN
            NULL;
      END;
   END LOOP;
   -- Remove IID's
   update_IIDs___(view_name_);
   -- Clean up cols
   cols_.DELETE;
   -- Get the tables the view is dependent on
   objects_ := get_tables___(view_name_, from_clause_, objects_);
   -- Insert tables the view is dependent on
   FOR i IN nvl(objects_.FIRST, 0) .. nvl(objects_.LAST, -1) LOOP
      BEGIN
         INSERT INTO query_hint_table_tab
            (view_name, table_name, manual, rowversion)
         VALUES
            (view_name_, objects_(i).table_name, 'FALSE', SYSDATE);
      EXCEPTION
         WHEN dup_val_on_index THEN
            NULL;
      END;
   END LOOP;
   -- Get Logical Unit and Module from Dictionary
   Get_Dictionary_Info___(lu_name_, module_, view_name_);
   timestamp_ := SYSDATE;
   BEGIN
      -- Insert or Update (if it already exists) the view into query_hint_view_tab
      INSERT INTO query_hint_view_tab
         (view_name, lu_name, module, parsed, timestamp, rowversion)
      VALUES
         (view_name_, lu_name_, module_, parsed_, timestamp_, SYSDATE);
   EXCEPTION
      WHEN dup_val_on_index THEN
         UPDATE query_hint_view_tab
            SET lu_name = lu_name_,
                module  = module_,
                parsed  = parsed_,
                timestamp = timestamp_,
                rowversion= SYSDATE
         WHERE  view_name = view_name_;
   END;
   Client_SYS.Add_To_Attr('LU_NAME', lu_name_, attr_);
   Client_SYS.Add_To_Attr('MODULE', module_, attr_);
   Client_SYS.Add_To_Attr('PARSED_DB', parsed_, attr_);
   Client_SYS.Add_To_Attr('TIMESTAMP', timestamp_, attr_);
   Client_SYS.Add_To_Attr('INVALID_QUERY_HINT', Query_Hint_View_API.Invalid_Query_Hint__(view_name_), attr_);
   -- Clean up objects
   objects_.DELETE;
EXCEPTION
   WHEN value_error THEN
      BEGIN
         -- Insert or Update (if it already exists) the view into query_hint_view_tab
         timestamp_ := SYSDATE;
         parsed_    := 'FALSE';
         INSERT INTO query_hint_view_tab
            (view_name, lu_name, module, parsed, timestamp, rowversion)
         VALUES
            (view_name_, lu_name_, module_, parsed_, timestamp_, SYSDATE);
      EXCEPTION
         WHEN dup_val_on_index THEN
            UPDATE query_hint_view_tab
               SET lu_name = lu_name_,
                   module  = module_,
                   parsed  = parsed_,
                   timestamp = timestamp_,
                   rowversion= SYSDATE
            WHERE  view_name = view_name_;
      END;
      Client_SYS.Add_To_Attr('LU_NAME', lu_name_, attr_);
      Client_SYS.Add_To_Attr('MODULE', module_, attr_);
      Client_SYS.Add_To_Attr('PARSED_DB', parsed_, attr_);
      Client_SYS.Add_To_Attr('TIMESTAMP', timestamp_, attr_);
      Client_SYS.Add_To_Attr('INVALID_QUERY_HINT', Query_Hint_View_API.Invalid_Query_Hint__(view_name_), attr_);
END Rebuild_Other_View_Query_Hints;


PROCEDURE Rebuild_View_Query_Hints_ (
   attr_          OUT VARCHAR2,
   view_name_     IN  VARCHAR2,
   remove_manual_ IN  VARCHAR2 )
IS

BEGIN
   -- Clear previous Query Hint information
   Clear_View_Query_Hints___(view_name_, remove_manual_);
   
   IF Check_Modified_Base_View___(view_name_) = 'TRUE' THEN
      Rebuild_Base_View_Query_Hints___(attr_, view_name_);
   ELSE
      Rebuild_Other_View_Query_Hints(attr_, view_name_, remove_manual_);
   END IF;

END Rebuild_View_Query_Hints_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


