-----------------------------------------------------------------------------
--
--  Logical unit: ReplicationDesignUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000428  JhMa    Changed naming of triggers from {table}_RAT/{table}_RBT to
--                  {LU}_RAT/{LU}_RBT in methods Create_Before_Trigger___ and 
--                  Create_After_Trigger___
--  000428  JhMa    Added trigger firing conditions in methods 
--                  Create_Before_Trigger___ and Create_After_Trigger___
--  000428  JhMa    Added check of updated columns in methods 
--                  Create_Before_Trigger___ and Create_After_Trigger___ 
--  000628  ROOD    Changes in error handling.
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040914  BaMalk  Added formatting to Create_Db_Update___ (Bug#43909)
--  070813  SUMALK  Changed SUBSTRB  to SUBSTR for unicode(Call 147296).
--  130117  DUWI  Changed the length of type variable table_type (Bug107724).
--  130617  PGAN  Corrected initialization of variable tmp_  in Get_Line___ (Bug110705)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Load_Create_Export__ (
   obj_type_        IN VARCHAR2,
   template_name_   IN VARCHAR2,
   action_          IN VARCHAR2,
   business_object_ IN VARCHAR2 ) RETURN CLOB
IS
   
   out_rec_        CLOB;
   template_rec_   CLOB;
   object_type_    VARCHAR2(30);
   value_          VARCHAR2(2000);
   ptr_            NUMBER;
   file_handle_    UTL_FILE.FILE_TYPE;
   template_       file_handle_%TYPE;
   output_         file_handle_%TYPE;

   TYPE table_type IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;

   template_api_        table_type;
   template_apy_        table_type;
   package_api_         table_type;
   package_apy_         table_type;
   empty_tab_           table_type;
   template_index_api_  BINARY_INTEGER;
   template_index_apy_  BINARY_INTEGER;
   package_index_api_   BINARY_INTEGER;
   package_index_apy_   BINARY_INTEGER;
   export_type_         VARCHAR2(3);
   template_type_       VARCHAR2(3);
   create_type_         VARCHAR2(3);
   use_table_           BOOLEAN := FALSE;
   cr_                  VARCHAR2(1) := CHR(13);
   nl_                  VARCHAR2(1) := CHR(10);


   FUNCTION Replace_Keyword___ (
      line_      IN VARCHAR2,
      key_word_  IN VARCHAR2,
      new_value_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      IF ( key_word_ IS NULL ) THEN
         RETURN line_;
      ELSE
         RETURN REPLACE(line_, '<<<' || key_word_ || '>>>', new_value_);
      END IF;
   END Replace_Keyword___;
   
   FUNCTION Find_Keyword___ (
      line_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      pos_       NUMBER;
      start_pos_ NUMBER;
      length_    NUMBER;
   BEGIN
      pos_ := INSTR(line_, '<<<');
      IF ( pos_ = 0 ) THEN
         RETURN NULL;
      ELSE
         start_pos_ := pos_ + 3;
         length_ := INSTR(line_, '>>>') - start_pos_;
         RETURN SUBSTR(line_, start_pos_, length_);
      END IF;
   END Find_Keyword___;

   PROCEDURE Put_Line___ (
      file_ IN OUT file_handle_%TYPE,
      line_ IN     VARCHAR2 )
   IS
   BEGIN
      IF ( use_table_ ) THEN
         IF ( create_type_ = 'APY' ) THEN
            package_apy_(package_index_apy_) := line_;
            package_index_apy_ := package_index_apy_ + 1;
         ELSE
            package_api_(package_index_api_) := line_;
            package_index_api_ := package_index_api_ + 1;
         END IF;
      ELSE
   -- 041101 jhmase - Unicode start
   --      UTL_FILE.PUT_LINE(file_, (line_);
         UTL_FILE.PUT_LINE(file_, Database_SYS.Db_To_File_Encoding(line_));
   -- 041101 jhmase - Unicode end
      END IF;
   END Put_Line___;


   PROCEDURE Add_Date_Column___ (
      table_           IN OUT table_type,
      business_object_ IN     VARCHAR2,
      number_of_lines_ IN     BINARY_INTEGER )
   IS
      out_line_        VARCHAR2(2000);
      new_value_       VARCHAR2(2000);
      key_word_        VARCHAR2(100);
      index_           BINARY_INTEGER := 1;
      margin_          VARCHAR2(120);
      CURSOR c1_table (object_ replication_attr_group_def_tab.business_object%TYPE) IS
         SELECT DISTINCT(a.trigger_table) AS trigger_table
         FROM   replication_attr_group_def_tab a
         WHERE  a.business_object = object_;
   BEGIN
      FOR c1 IN c1_table (business_object_) LOOP
         index_ := 1;
         WHILE ( index_ <= number_of_lines_ ) LOOP
            key_word_ := Find_Keyword___(table_(index_));
            IF ( key_word_ IS NOT NULL ) THEN
               margin_ := RPAD(' ', (INSTR(table_(index_),'<<<') - 1));
            ELSE
               margin_ := NULL;
            END IF;
            IF ( key_word_ IS NULL ) THEN
               NULL;
            ELSIF ( key_word_ = 'LOOP_ADD_DATE_COLUMN' ) THEN
               new_value_ := NULL;
            ELSIF ( key_word_ = 'TABLE' ) THEN
               new_value_ := LOWER(c1.trigger_table);
            END IF;
            out_line_ := Replace_Keyword___(table_(index_), key_word_, new_value_);
            IF ( LTRIM(RTRIM(out_line_)) IS NOT NULL ) THEN
               Put_Line___(output_, out_line_);
            END IF;
            index_ := index_ + 1;
         END LOOP;
      END LOOP;
   END Add_Date_Column___;

   PROCEDURE Close_All___
   IS
   BEGIN
      IF ( use_table_ ) THEN RETURN; END IF;
      UTL_FILE.FCLOSE_ALL;
   END Close_All___;


   PROCEDURE Create_After_Trigger___ (
      table_           IN OUT table_type,
      business_object_ IN     VARCHAR2,
      number_of_lines_ IN     BINARY_INTEGER )
   IS
      condition_       table_type;
      idx_             BINARY_INTEGER;
      or_              VARCHAR2(10);
      if_              VARCHAR2(10);
      column_          VARCHAR2(30);
      tmp_condition_   VARCHAR2(2000);
      out_line_        VARCHAR2(2000);
      new_value_       VARCHAR2(2000);
      key_word_        VARCHAR2(100);
      index_           BINARY_INTEGER := 1;
      margin_          VARCHAR2(120);
      no_new_          NUMBER;
      no_modify_       NUMBER;
      no_not_modify_   NUMBER;
      CURSOR c1_lu (object_ replication_attr_group_def_tab.business_object%TYPE) IS
         SELECT a.lu_name           AS lu_name,
                a.trigger_table     AS trigger_table,
                a.trigger_condition AS trigger_condition
         FROM   replication_attr_group_def_tab a
         WHERE  a.business_object = object_
         AND EXISTS ( SELECT 'x'
                      FROM   replication_attr_group_tab b
                      WHERE  b.business_object = a.business_object
                      AND    b.lu_name         = a.lu_name
                      AND   (b.on_new          = 'TRUE'
                         OR  b.on_modify       = 'TRUE')
                    );
      CURSOR c2_keys (object_ replication_attr_def_tab.business_object%TYPE,
                      lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT UPPER(NVL(a.table_key_name, a.column_name)) AS column_name,
                UPPER(a.column_name)                        AS view_column_name
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.key             = 'TRUE';
      CURSOR c3_bo_keys (object_ replication_attr_def_tab.business_object%TYPE,
                         lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT UPPER(NVL(a.table_key_name, a.column_name)) AS column_name,
                UPPER(a.bo_key_name)                        AS bo_key
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.key             = 'TRUE'
         AND    a.bo_key_name     IS NOT NULL;
      CURSOR c4_replicate (object_ replication_attr_group_tab.business_object%TYPE,
                           lu_     replication_attr_group_tab.lu_name%TYPE) IS
         SELECT a.replication_group AS replication_group,
                a.on_new            AS on_new,
                a.on_modify         AS on_modify
         FROM   replication_attr_group_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND   (a.on_new          = 'TRUE'
            OR  a.on_modify       = 'TRUE');
      CURSOR c5_generic_condition (object_ replication_condition_tab.business_object%TYPE,
                                   group_  replication_condition_tab.replication_group%TYPE) IS
         SELECT a.condition AS condition
         FROM   replication_condition_tab a
         WHERE  a.replication_group = group_
         AND    a.business_object   = object_
         AND    a.lu_name           = '*'
         AND    a.column_name       = '*'
         ORDER BY a.condition_sequence;
      CURSOR c6_generic_column (object_ replication_condition_tab.business_object%TYPE,
                                group_  replication_condition_tab.replication_group%TYPE,
                                table_  VARCHAR2) IS
         SELECT DISTINCT(a.column_name) AS column_name
         FROM   replication_condition_tab a
         WHERE  a.replication_group = group_
         AND    a.business_object   = object_
         AND    a.lu_name           = '*'
         AND    a.column_name      != '*'
         AND EXISTS ( SELECT 'x'
                      FROM   user_tab_columns b
                      WHERE  b.column_name = DECODE(SUBSTR(a.column_name, LENGTH(a.column_name)-2, 3), '_DB',
                                               SUBSTR(a.column_name, 1, LENGTH(a.column_name)-3), a.column_name)
                      AND    b.table_name  = table_
                     );
      CURSOR c7_generic_column_condition (object_ replication_condition_tab.business_object%TYPE,
                                          group_  replication_condition_tab.replication_group%TYPE,
                                          column_ replication_condition_tab.column_name%TYPE,
                                          table_   VARCHAR2) IS
         SELECT a.condition AS condition
         FROM   replication_condition_tab a
         WHERE  a.replication_group = group_
         AND    a.business_object   = object_
         AND    a.lu_name           = '*'
         AND    a.column_name       = column_
         AND EXISTS ( SELECT 'x'
                      FROM   user_tab_columns b
                      WHERE  b.column_name = DECODE(SUBSTR(a.column_name, LENGTH(a.column_name)-2, 3), '_DB',
                                               SUBSTR(a.column_name, 1, LENGTH(a.column_name)-3), a.column_name)
                      AND    b.table_name  = table_
                     )
         ORDER BY a.condition_sequence;
      CURSOR c8_column (object_ replication_condition_tab.business_object%TYPE,
                        group_  replication_condition_tab.replication_group%TYPE,
                        lu_     replication_condition_tab.lu_name%TYPE,
                        table_  VARCHAR2) IS
         SELECT DISTINCT(a.column_name) AS column_name
         FROM   replication_condition_tab a
         WHERE  a.replication_group = group_
         AND    a.business_object   = object_
         AND    a.lu_name           = lu_
         AND    a.column_name      != '*'
         AND EXISTS ( SELECT 'x'
                      FROM   user_tab_columns b
                      WHERE  b.column_name = DECODE(SUBSTR(a.column_name, LENGTH(a.column_name)-2, 3), '_DB',
                                               SUBSTR(a.column_name, 1, LENGTH(a.column_name)-3), a.column_name)
                      AND    b.table_name  = table_
                     );
      CURSOR c9_column_condition (object_ replication_condition_tab.business_object%TYPE,
                                  group_  replication_condition_tab.replication_group%TYPE,
                                  lu_     replication_condition_tab.lu_name%TYPE,
                                  column_ replication_condition_tab.column_name%TYPE,
                                  table_  VARCHAR2) IS
         SELECT a.condition AS condition
         FROM   replication_condition_tab a
         WHERE  a.replication_group = group_
         AND    a.business_object   = object_
         AND    a.lu_name           = lu_
         AND    a.column_name       = column_
         AND EXISTS ( SELECT 'x'
                      FROM   user_tab_columns b
                      WHERE  b.column_name = DECODE(SUBSTR(a.column_name, LENGTH(a.column_name)-2, 3), '_DB',
                                               SUBSTR(a.column_name, 1, LENGTH(a.column_name)-3), a.column_name)
                      AND    b.table_name  = table_
                     )
         ORDER BY a.condition_sequence;
      CURSOR c10_update_columns (object_ replication_attr_def_tab.business_object%TYPE,
                                 lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT NVL(a.table_key_name,
                   DECODE(SUBSTR(a.column_name, LENGTH(a.column_name)-2, 3), '_DB',
                   SUBSTR(a.column_name, 1, LENGTH(a.column_name)-3), a.column_name)) AS column_name
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.on_modify       = 'TRUE';
      CURSOR c11_insert_update (object_ replication_attr_def_tab.business_object%TYPE,
                                lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT SUM(DECODE(a.on_new,'TRUE',1,0))     AS no_new,
                SUM(DECODE(a.on_modify,'TRUE',1,0))  AS no_modify,
                SUM(DECODE(a.on_modify,'FALSE',1,0)) AS no_not_modify
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_;
   BEGIN
      FOR c1 IN c1_lu (business_object_) LOOP
         index_ := 1;
         WHILE ( index_ <= number_of_lines_ ) LOOP
            key_word_ := Find_Keyword___(table_(index_));
            IF ( key_word_ IS NOT NULL ) THEN
               margin_ := RPAD(' ', (INSTR(table_(index_),'<<<') - 1));
            ELSE
               margin_ := NULL;
            END IF;
            --
            -- Create instructions for primary key columns
            -- -------------------------------------------
            IF ( (key_word_ IS NOT NULL) AND (key_word_ = 'OBJECT_KEYS') ) THEN
               FOR c2 IN c2_keys (business_object_, c1.lu_name) LOOP
                  Put_Line___(output_, margin_ || 'Client_SYS.Add_To_Attr(''' || c2.view_column_name || ''', :new.' || LOWER(c2.column_name) || ', attr_);');
               END LOOP;
               Put_Line___(output_, margin_ || '--');
               FOR c2 IN c2_keys (business_object_, c1.lu_name) LOOP
                  Put_Line___(output_, margin_ || 'IF ( :old.' || LOWER(c2.column_name) || ' <> :new.' || LOWER(c2.column_name) || ' ) THEN');
                  Put_Line___(output_, margin_ || '   Client_SYS.Add_To_Attr(''OLD_' || c2.view_column_name || ''', :old.' || LOWER(c2.column_name) || ', attr_);');
                  Put_Line___(output_, margin_ || 'END IF;');
               END LOOP;
            --
            -- Create instructions for Business Object key(s)
            -- ----------------------------------------------
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'BO_OBJECT_KEYS') ) THEN
               FOR c3 IN c3_bo_keys (business_object_, c1.lu_name) LOOP
                  Put_Line___(output_, margin_ || 'Client_SYS.Add_To_Attr(''' || c3.bo_key || ''', :new.' || LOWER(c3.column_name) || ', attr_);');
               END LOOP;
            --
            -- Create instructions to check for updated columns
            -- ------------------------------------------------
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'CHECK_UPDATED_COLUMNS') ) THEN
               if_ := 'IF ';
               FOR c10 IN c10_update_columns (business_object_, c1.lu_name) LOOP
                  IF    ( c10.column_name = 'OBJID'      ) THEN column_ := 'ROWID';
                  ELSIF ( c10.column_name = 'OBJVERSION' ) THEN column_ := 'ROWVERSION';
                  ELSE                                          column_ := c10.column_name;
                  END IF;
                  Put_Line___(output_, margin_ || if_ || '    ( ( :old.' || LOWER(column_) || ' IS NULL AND :new.' || LOWER(column_) || ' IS NULL )');
                  Put_Line___(output_, margin_ || '   OR   ( ( :old.' || LOWER(column_) || ' IS NOT NULL AND :new.' || LOWER(column_) || ' IS NOT NULL )');
                  Put_Line___(output_, margin_ || '      AND ( :old.' || LOWER(column_) || ' = :new.' || LOWER(column_) || ' ) ) )');
                  if_ := 'AND';
               END LOOP;
               IF ( if_ = 'AND' ) THEN
                  Put_Line___(output_, margin_ || 'THEN');
                  Put_Line___(output_, margin_ || '   RETURN;');
                  Put_Line___(output_, margin_ || 'END IF;');
               END IF;
            --
            -- Create conditions for each replication group
            -- --------------------------------------------
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'REPLICATION_GROUP') ) THEN
               FOR c4 IN c4_replicate (business_object_, c1.lu_name) LOOP
                  Put_Line___(output_, margin_ || 'newrec_.replication_group := ''' || c4.replication_group || ''';');
                  idx_ := 0;
                  --
                  -- Create generic conditions for business object
                  -- ---------------------------------------------
                  FOR c5 IN c5_generic_condition (business_object_, c4.replication_group) LOOP
                     idx_ := idx_ + 1;
                     condition_(idx_) := '( ' || c5.condition || ' )';
                  END LOOP;
                  --
                  -- Create generic conditions for business object columns
                  -- -----------------------------------------------------
                  FOR c6 IN c6_generic_column (business_object_, c4.replication_group, c1.trigger_table) LOOP
                     tmp_condition_ := '( ';
                     or_ := NULL;
                     FOR c7 IN c7_generic_column_condition (business_object_, c4.replication_group, c6.column_name, c1.trigger_table) LOOP
                        tmp_condition_ := tmp_condition_ || or_ || '(' || c7.condition || ')';
                        or_ := ' OR ';
                     END LOOP;
                     IF ( LENGTH(tmp_condition_) > 3 ) THEN
                        tmp_condition_ := tmp_condition_ || ' )';
                        idx_ := idx_ + 1;
                        condition_(idx_) := '( ' || tmp_condition_ || ' )';
                     END IF;
                  END LOOP;
                  --
                  -- Create conditions for business object lu columns
                  -- ------------------------------------------------
                  FOR c8 IN c8_column (business_object_, c4.replication_group, c1.lu_name, c1.trigger_table) LOOP
                     tmp_condition_ := '( ';
                     or_ := NULL;
                     FOR c9 IN c9_column_condition (business_object_, c4.replication_group, c1.lu_name, c8.column_name, c1.trigger_table) LOOP
                        tmp_condition_ := tmp_condition_ || or_ || '(' || c9.condition || ')';
                        or_ := ' OR ';
                     END LOOP;
                     IF ( LENGTH(tmp_condition_) > 3 ) THEN
                        tmp_condition_ := tmp_condition_ || ' )';
                        idx_ := idx_ + 1;
                        condition_(idx_) := '( ' || tmp_condition_ || ' )';
                     END IF;
                  END LOOP;
                  IF ( idx_ > 0 ) THEN
                     FOR i_ IN 1..idx_ LOOP
                        IF ( i_ = 1 ) THEN
                           Put_Line___(output_, margin_ || 'IF  ' || condition_(i_));
                        ELSE
                           Put_Line___(output_, margin_ || 'AND ' || condition_(i_));
                        END IF;
                     END LOOP;
                     Put_Line___(output_, margin_ || 'THEN');
                     margin_ := margin_ || '   ';
                  END IF;
                  IF ( (c4.on_new = 'TRUE') AND (c4.on_modify = 'TRUE') ) THEN
                     Put_Line___(output_, margin_ || 'Replication_Queue_API.Create_New__(newrec_);');
                  ELSIF ( c4.on_new = 'TRUE' ) THEN
                     Put_Line___(output_, margin_ || 'IF ( INSERTING ) THEN');
                     Put_Line___(output_, margin_ || '   Replication_Queue_API.Create_New__(newrec_);');
                     Put_Line___(output_, margin_ || 'END IF;');
                  ELSIF ( c4.on_modify = 'TRUE' ) THEN
                     Put_Line___(output_, margin_ || 'IF ( UPDATING ) THEN');
                     Put_Line___(output_, margin_ || '   Replication_Queue_API.Create_New__(newrec_);');
                     Put_Line___(output_, margin_ || 'END IF;');
                  END IF;
                  IF ( idx_ > 0 ) THEN
                     margin_ := SUBSTR(margin_, 1, LENGTH(margin_) - 3);
                     Put_Line___(output_, margin_ || 'END IF;');
                  END IF;
               END LOOP;
            ELSE
               IF ( key_word_ IS NULL ) THEN
                  new_value_ := NULL;
               ELSIF ( key_word_ = 'LOOP_CREATE_AFTER_TRIGGER' ) THEN
                  new_value_ := NULL;
               ELSIF ( key_word_ = 'LU' ) THEN
                  new_value_ := c1.lu_name;
               ELSIF ( key_word_ = 'TABLE' ) THEN
                  new_value_ := c1.trigger_table;
               ELSIF ( key_word_ = 'TRIGGER' ) THEN
   --               new_value_ := REPLACE(c1.trigger_table, 'TAB', 'RAT');
   --               Trigger name changed from {table}_RAT to {lu}_RAT
   --               ------------------------------------------------------
                  new_value_ := Dictionary_SYS.ClientNameToDbName_(c1.lu_name) || '_RAT';
               ELSIF ( key_word_ = 'TRIGGER_CONDITION' ) THEN
                  IF ( c1.trigger_condition IS NOT NULL ) THEN
                     new_value_ := 'WHEN ( ' || c1.trigger_condition || ' )';
                  ELSE
                     new_value_ := NULL;
                  END IF;
               ELSIF ( key_word_ = 'INSERT_UPDATE_KEY_WORDS' ) THEN
                  OPEN c11_insert_update (business_object_, c1.lu_name);
                  FETCH c11_insert_update INTO no_new_, no_modify_, no_not_modify_;
                  CLOSE c11_insert_update;
                  IF ( (no_new_ > 0) AND (no_modify_ > 0) ) THEN
                     new_value_ := 'INSERT OR UPDATE';
                  ELSIF ( no_new_ > 0 ) THEN
                     new_value_ := 'INSERT';
                  ELSE
                     new_value_ := 'UPDATE';
                  END IF;
               ELSE
                  new_value_ := key_word_;
               END IF;
               out_line_ := Replace_Keyword___(table_(index_), key_word_, new_value_);
               IF ( LTRIM(RTRIM(out_line_)) IS NOT NULL ) THEN
                  Put_Line___(output_, out_line_);
               END IF;
            END IF;
            index_ := index_ + 1;
         END LOOP;
      END LOOP;
   END Create_After_Trigger___;

   PROCEDURE Create_Before_Trigger___ (
      table_           IN OUT table_type,
      business_object_ IN     VARCHAR2,
      number_of_lines_ IN     BINARY_INTEGER )
   IS
      out_line_        VARCHAR2(2000);
      new_value_       VARCHAR2(2000);
      key_word_        VARCHAR2(100);
      column_          VARCHAR2(30);
      index_           BINARY_INTEGER := 1;
      margin_          VARCHAR2(120);
      if_              VARCHAR2(10);
      CURSOR c1_lu (object_ replication_attr_group_def_tab.business_object%TYPE) IS
         SELECT a.lu_name           AS lu_name,
                a.trigger_table     AS trigger_table,
                a.trigger_condition AS trigger_condition
         FROM   replication_attr_group_def_tab a
         WHERE  a.business_object = object_;
      CURSOR c10_update_columns (object_ replication_attr_def_tab.business_object%TYPE,
                                 lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT NVL(a.table_key_name,
                   DECODE(SUBSTR(a.column_name, LENGTH(a.column_name)-2, 3), '_DB',
                   SUBSTR(a.column_name, 1, LENGTH(a.column_name)-3), a.column_name)) AS column_name
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.on_modify       = 'TRUE';
   BEGIN
      FOR c1 IN c1_lu (business_object_) LOOP
         index_ := 1;
         WHILE ( index_ <= number_of_lines_ ) LOOP
            key_word_ := Find_Keyword___(table_(index_));
            IF ( key_word_ IS NOT NULL ) THEN
               margin_ := RPAD(' ', (INSTR(table_(index_),'<<<') - 1));
            ELSE
               margin_ := NULL;
            END IF;
            --
            -- Create instructions to check for updated columns
            -- ------------------------------------------------
            IF ( (key_word_ IS NOT NULL) AND (key_word_ = 'CHECK_UPDATED_COLUMNS') ) THEN
               if_ := 'IF ';
               FOR c10 IN c10_update_columns (business_object_, c1.lu_name) LOOP
                  IF    ( c10.column_name = 'OBJID'      ) THEN column_ := 'ROWID';
                  ELSIF ( c10.column_name = 'OBJVERSION' ) THEN column_ := 'ROWVERSION';
                  ELSE                                          column_ := c10.column_name;
                  END IF;
                  Put_Line___(output_, margin_ || if_ || '    ( ( :old.' || LOWER(column_) || ' IS NULL AND :new.' || LOWER(column_) || ' IS NULL )');
                  Put_Line___(output_, margin_ || '   OR   ( ( :old.' || LOWER(column_) || ' IS NOT NULL AND :new.' || LOWER(column_) || ' IS NOT NULL )');
                  Put_Line___(output_, margin_ || '      AND ( :old.' || LOWER(column_) || ' = :new.' || LOWER(column_) || ' ) ) )');
                  if_ := 'AND';
               END LOOP;
               IF ( if_ = 'AND' ) THEN
                  Put_Line___(output_, margin_ || 'THEN');
                  Put_Line___(output_, margin_ || '   RETURN;');
                  Put_Line___(output_, margin_ || 'END IF;');
               END IF;
            ELSE
               IF ( key_word_ IS NULL ) THEN
                  new_value_ := NULL;
               ELSIF ( key_word_ = 'LOOP_CREATE_BEFORE_TRIGGER' ) THEN
                  new_value_ := NULL;
               ELSIF ( key_word_ = 'LU' ) THEN
                  new_value_ := c1.lu_name;
               ELSIF ( key_word_ = 'TABLE' ) THEN
                  new_value_ := c1.trigger_table;
               ELSIF ( key_word_ = 'TRIGGER' ) THEN
   --               Trigger name changed from {table}_RBT to {lu}_RBT
   --               new_value_ := REPLACE(c1.trigger_table, 'TAB', 'RBT');
   --               ------------------------------------------------------
                  new_value_ := Dictionary_SYS.ClientNameToDbName_(c1.lu_name) || '_RBT';
               ELSIF ( key_word_ = 'TRIGGER_CONDITION' ) THEN
                  IF ( c1.trigger_condition IS NOT NULL ) THEN
                     new_value_ := 'WHEN ( ' || c1.trigger_condition || ' )';
                  ELSE
                     new_value_ := NULL;
                  END IF;
               ELSE
                  new_value_ := key_word_;
               END IF;
               out_line_ := Replace_Keyword___(table_(index_), key_word_, new_value_);
               IF ( LTRIM(RTRIM(out_line_)) IS NOT NULL ) THEN
                  Put_Line___(output_, out_line_);
               END IF;
            END IF;
            index_ := index_ + 1;
         END LOOP;
      END LOOP;
   END Create_Before_Trigger___;

   PROCEDURE Create_Db_Update___ (
      table_           IN OUT table_type,
      business_object_ IN     VARCHAR2,
      number_of_lines_ IN     BINARY_INTEGER )
   IS
      out_line_        VARCHAR2(2000);
      new_value_       VARCHAR2(2000);
      key_word_        VARCHAR2(100);
      data_type_       VARCHAR2(30);
      condition_word_  VARCHAR2(30);
      comma_           VARCHAR2(5);
      margin_          VARCHAR2(120);
      index_           BINARY_INTEGER := 1;
      var_column_name_ VARCHAR2(30);
      CURSOR c1_lu (object_ replication_attr_group_def_tab.business_object%TYPE) IS
         SELECT a.lu_name AS lu_name,
                a.view_name AS view_name
         FROM   replication_attr_group_def_tab a
         WHERE  a.business_object = object_;
      CURSOR c3_key_column (object_ replication_attr_def_tab.business_object%TYPE,
                            lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT LOWER(a.column_name) column_name ,LOWER(a.column_name)||'__' var_column_name, rownum 
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.key             IN ('TRUE','Y');
      CURSOR c31_column_type (table_  VARCHAR2,
                              column_ VARCHAR2) IS
         SELECT a.data_type AS data_type
         FROM   user_tab_columns a
         WHERE  a.table_name  = UPPER(table_)
         AND    a.column_name = UPPER(column_);
      CURSOR c4_date_column (table_ VARCHAR2) IS
         SELECT a.column_name AS column_name
         FROM   user_tab_columns a
         WHERE  a.table_name = table_
         AND    a.data_type  = 'DATE';
      CURSOR c5_rcv_lu (object_ receive_attr_group_tab.business_object%TYPE,
                        lu_     receive_attr_group_tab.lu_name%TYPE,
                        new_    receive_attr_group_tab.new_allowed%TYPE,
                        modify_ receive_attr_group_tab.modify_allowed%TYPE) IS
         SELECT a.receive_group AS receive_group
         FROM   receive_attr_group_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.new_allowed     LIKE new_ || '%'
         AND    a.modify_allowed  LIKE modify_ || '%';
      CURSOR c101_new_modify (object_ receive_attr_group_tab.business_object%TYPE,
                              lu_     receive_attr_group_tab.lu_name%TYPE,
                              new_    VARCHAR2,
                              modify_ VARCHAR2) IS
         SELECT DISTINCT(a.receive_group) AS receive_group
         FROM   receive_attr_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.new_allowed     LIKE new_ || '%'
         AND    a.modify_allowed  LIKE modify_ || '%';
      CURSOR c102_new_modify (group_  receive_attr_group_tab.receive_group%TYPE,
                              object_ receive_attr_group_tab.business_object%TYPE,
                              lu_     receive_attr_group_tab.lu_name%TYPE,
                              new_    VARCHAR2,
                              modify_ VARCHAR2) IS
         SELECT a.column_name    AS column_name
         FROM   receive_attr_tab a
         WHERE  a.receive_group   = group_
         AND    a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.new_allowed     LIKE new_ || '%'
         AND    a.modify_allowed  LIKE modify_ || '%';
      CURSOR c103_method (object_ receive_attr_group_tab.business_object%TYPE,
                          lu_     receive_attr_group_tab.lu_name%TYPE) IS
         SELECT a.receive_group AS receive_group,
                a.method        AS method
         FROM   receive_attr_group_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.method          IS NOT NULL
         ORDER BY a.receive_group;
      CURSOR c104_spread_column (object_ receive_attr_group_tab.business_object%TYPE,
                                 lu_     receive_attr_group_tab.lu_name%TYPE) IS
         SELECT a.spread_column AS spread_column
         FROM   receive_attr_group_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.spread_column   IS NOT NULL
         AND    a.spread_value    IS NOT NULL;
      CURSOR c105_new_method (object_ receive_attr_group_tab.business_object%TYPE,
                              lu_     receive_attr_group_tab.lu_name%TYPE) IS
         SELECT a.receive_group AS receive_group,
                a.new_method    AS new_method
         FROM   receive_attr_group_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.new_method      IS NOT NULL
         ORDER BY a.receive_group;
      CURSOR c105_modify_method (object_ receive_attr_group_tab.business_object%TYPE,
                                 lu_     receive_attr_group_tab.lu_name%TYPE) IS
         SELECT a.receive_group AS receive_group,
                a.modify_method AS modify_method
         FROM   receive_attr_group_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.modify_method   IS NOT NULL
         ORDER BY a.receive_group;
   BEGIN
      FOR c1_rec IN c1_lu (business_object_) LOOP
         index_ := 1;
         WHILE ( index_ <= number_of_lines_ ) LOOP
            key_word_ := Find_Keyword___(table_(index_));
            IF ( key_word_ IS NOT NULL ) THEN
               margin_ := RPAD(' ', (INSTR(table_(index_),'<<<') - 1));
            ELSE
               margin_ := NULL;
            END IF;
            IF ( (key_word_ IS NOT NULL) AND (key_word_ = 'OBJECT_KEY_DECL') ) THEN
               FOR c3 IN c3_key_column (business_object_, c1_rec.lu_name) LOOP
                  IF length(c3.column_name) > 20 THEN
                    var_column_name_ := substr(c3.var_column_name,1,20)||'_'|| lpad(c3.rownum, 3, '0')||'__' ; 
                  ELSE 
                    var_column_name_ := c3.var_column_name;   
                  END IF;

                  Put_Line___(output_, margin_ || RPAD(var_column_name_,30) || '  ' ||
                     LOWER(c1_rec.view_name) || '.' || c3.column_name || '%TYPE;');
                  Put_Line___(output_, margin_ || RPAD('old_' || var_column_name_ ,30) || '  ' ||
                     LOWER(c1_rec.view_name) || '.' || c3.column_name || '%TYPE;');   
               END LOOP;
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'OBJECT_KEY_CONDITION') ) THEN
               condition_word_ := 'WHERE';
               FOR c3 IN c3_key_column (business_object_, c1_rec.lu_name) LOOP
                  IF length(c3.column_name) > 20 THEN
                    var_column_name_ := substr(c3.var_column_name,1,20) ||'_'|| lpad(c3.rownum, 3, '0')||'__' ;
                  ELSE 
                    var_column_name_ := c3.var_column_name;   
                  END IF;

                  Put_Line___(output_, margin_ || condition_word_ || '  ' || c3.column_name ||
                     ' = ' || var_column_name_);
                  condition_word_ := 'AND  ';
               END LOOP;
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'FIND_KEY_VALUES_AND_OLD_VALUES') ) THEN
               Put_Line___(output_, margin_ || 'IF ( value_ = ''OPERATION'' ) THEN ');
               Put_Line___(output_, margin_ || '   IF ( Client_SYS.Get_Next_From_Attr(attr_grp_rec_, ptr_, name_, value_) ) THEN ');
               Put_Line___(output_, margin_ || '      operation_ := value_;');
               Put_Line___(output_, margin_ || '   ELSE');
               Put_Line___(output_, margin_ || '      RAISE message_error_; -- syntax error in message');
               Put_Line___(output_, margin_ || '   END IF;');
               FOR c3 IN c3_key_column (business_object_, c1_rec.lu_name) LOOP
                  IF length(c3.column_name) > 20 THEN
                    var_column_name_ := substr(c3.var_column_name,1,20) ||'_'|| lpad(c3.rownum, 3, '0')||'__' ;
                  ELSE 
                    var_column_name_ := c3.var_column_name;   
                  END IF;

                  Put_Line___(output_, margin_ || 'ELSIF ( value_ = ''' || UPPER(c3.column_name) || ''' ) THEN ');
                  Put_Line___(output_, margin_ || '   IF ( Client_SYS.Get_Next_From_Attr(attr_grp_rec_, ptr_, name_, value_) ) THEN ');
                  OPEN c31_column_type (Dictionary_SYS.ClientNameToDbName_(c1_rec.lu_name), c3.column_name);
                  FETCH c31_column_type INTO data_type_;
                  IF ( c31_column_type%NOTFOUND) THEN
                     data_type_ := 'NOT_DATE';
                  END IF;
                  CLOSE c31_column_type;
                  IF ( data_type_ = 'DATE' ) THEN
                     Put_Line___(output_, margin_ || '      ' || var_column_name_ || ' := TO_DATE(value_, remote_date_format_);');
                  ELSE
                     Put_Line___(output_, margin_ || '      ' || var_column_name_ || ' := value_;');
                  END IF;
                  Put_Line___(output_, margin_ || '   ELSE');
                  Put_Line___(output_, margin_ || '      RAISE message_error_; -- syntax error in message');
                  Put_Line___(output_, margin_ || '   END IF;');
                  Put_Line___(output_, margin_ || 'ELSIF ( value_ = ''' || 'OLD_' || UPPER(c3.column_name) || ''' ) THEN ');
                  Put_Line___(output_, margin_ || '   IF ( Client_SYS.Get_Next_From_Attr(attr_grp_rec_, ptr_, name_, value_) ) THEN ');
                  IF ( data_type_ = 'DATE' ) THEN
                     Put_Line___(output_, margin_ || '      ' || 'old_' || var_column_name_ || ' := TO_DATE(value_, remote_date_format_);');
                  ELSE
                     Put_Line___(output_, margin_ || '      ' || 'old_' || var_column_name_ || ' := value_;');
                  END IF;
                  Put_Line___(output_, margin_ || '   END IF;');
               END LOOP;
               Put_Line___(output_, margin_ || 'END IF;');
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'FIND_KEY_VALUES') ) THEN
               FOR c3 IN c3_key_column (business_object_, c1_rec.lu_name) LOOP
                  OPEN c31_column_type (Dictionary_SYS.ClientNameToDbName_(c1_rec.lu_name), c3.column_name);
                  FETCH c31_column_type INTO data_type_;
                  IF ( c31_column_type%NOTFOUND) THEN
                     data_type_ := 'NOT_DATE';
                  END IF;
                  CLOSE c31_column_type;

                  IF length(c3.column_name) > 20 THEN
                    var_column_name_ := substr(c3.var_column_name,1,20) ||'_'|| lpad(c3.rownum, 3, '0')||'__' ;
                  ELSE 
                    var_column_name_ := c3.var_column_name;   
                  END IF;

                  IF ( data_type_ = 'DATE' ) THEN
                     Put_Line___(output_, margin_ || var_column_name_ ||' := TO_DATE(Client_SYS.Get_Item_Value(''' || UPPER(c3.column_name) || ''', new_attr_),remote_date_format_);');
                  ELSE
                     Put_Line___(output_, margin_ || var_column_name_ ||' := Client_SYS.Get_Item_Value(''' || UPPER(c3.column_name) || ''', new_attr_);');
                  END IF;
               END LOOP;
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'REMOVE_KEY_VALUES') ) THEN
               condition_word_ := 'IF';
               FOR c3 IN c3_key_column (business_object_, c1_rec.lu_name) LOOP
                  Put_Line___(output_, margin_ || condition_word_ || ' ( name_ = ''' || UPPER(c3.column_name) || ''' ) THEN ');
                  Put_Line___(output_, margin_ || '   add_attribute_ := FALSE;');
                  condition_word_ := 'ELSIF';
               END LOOP;
               IF ( condition_word_ = 'ELSIF' ) THEN
                  Put_Line___(output_, margin_ || 'END IF;');
               END IF;
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'NEW_COLUMN_LIST') ) THEN
               condition_word_ := NULL;
               FOR c101 IN c101_new_modify (business_object_, c1_rec.lu_name, 'TRUE', NULL) LOOP
                  Put_Line___(output_, margin_ || condition_word_ || ' ( receive_group_ = ''' || c101.receive_group || ''' AND column_ IN (');
                  comma_ := NULL;
                  FOR c102 IN c102_new_modify (c101.receive_group, business_object_, c1_rec.lu_name, 'TRUE', NULL) LOOP
                     Put_Line___(output_, margin_ || comma_ || CHR(39) || c102.column_name || CHR(39));
                     comma_ := ',';
                  END LOOP;
                  Put_Line___(output_, margin_ || ')');
                  condition_word_ := 'OR';
               END LOOP;
               Put_Line___(output_, margin_ || ')');
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'MODIFY_COLUMN_LIST') ) THEN
               condition_word_ := NULL;
               FOR c101 IN c101_new_modify (business_object_, c1_rec.lu_name, NULL, 'TRUE') LOOP
                  Put_Line___(output_, margin_ || condition_word_ || ' ( receive_group_ = ''' || c101.receive_group || ''' AND column_ IN (');
                  comma_ := NULL;
                  FOR c102 IN c102_new_modify (c101.receive_group, business_object_, c1_rec.lu_name, NULL, 'TRUE') LOOP
                     Put_Line___(output_, margin_ || comma_ || CHR(39) || c102.column_name || CHR(39));
                     comma_ := ',';
                  END LOOP;
                  Put_Line___(output_, margin_ || ')');
                  condition_word_ := 'OR';
               END LOOP;
               Put_Line___(output_, margin_ || ')');
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'FUNCTION_CALL_ON_ATTR') ) THEN
               condition_word_ := 'IF';
               FOR c6 IN  c103_method (business_object_, c1_rec.lu_name) LOOP
                  Put_Line___(output_, margin_ || condition_word_ || ' ( receive_group_ = ''' || c6.receive_group || ''' ) THEN ');
                  IF ( INSTR(c6.method, ';') > 0 ) THEN
                     Put_Line___(output_, margin_ || '   ' || c6.method);
                  ELSE
                     Put_Line___(output_, margin_ || '   ' || c6.method || '(' || CHR(39) || c6.receive_group ||
                        CHR(39) || ', ' || CHR(39) || business_object_ || CHR(39) || ', ' || CHR(39) ||
                        c1_rec.lu_name || CHR(39) || ', local_operation_, attr_, na_);');
                  END IF;
                  condition_word_ := 'ELSIF';
               END LOOP;
               IF ( condition_word_ = 'ELSIF' ) THEN
                  Put_Line___(output_, margin_ || 'END IF;');
               END IF;

            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'CALL_NEW') ) THEN
               condition_word_ := 'IF';
               FOR c7 IN  c105_new_method (business_object_, c1_rec.lu_name) LOOP
                  Put_Line___(output_, margin_ || condition_word_ || ' ( receive_group_ = ''' || c7.receive_group || ''' ) THEN ');
                  IF ( INSTR(c7.new_method, ';') > 0 ) THEN
                     Put_Line___(output_, margin_ || '   ' || c7.new_method);
                  ELSE
                     Put_Line___(output_, margin_ || '   ' || c7.new_method ||
                        '(info_, objid_, objversion_, attr_, ' || CHR(39) || 'DO' || CHR(39) || ');');
                  END IF;
                  condition_word_ := 'ELSIF';
               END LOOP;
               IF ( condition_word_ = 'ELSIF' ) THEN
                  Put_Line___(output_, margin_ || 'ELSE');
                  Put_Line___(output_, margin_ || '   ' || INITCAP(Dictionary_SYS.ClientNameToDbName_(c1_rec.lu_name)) ||
                     '_API.New__(info_, objid_, objversion_, attr_, ' || CHR(39) || 'DO' || CHR(39) || ');');
                  Put_Line___(output_, margin_ || 'END IF;');
               ELSE
                  Put_Line___(output_, margin_ || INITCAP(Dictionary_SYS.ClientNameToDbName_(c1_rec.lu_name)) ||
                     '_API.New__(info_, objid_, objversion_, attr_, ' || CHR(39) || 'DO' || CHR(39) || ');');
               END IF;
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'CALL_MODIFY') ) THEN
               condition_word_ := 'IF';
               FOR c8 IN  c105_modify_method (business_object_, c1_rec.lu_name) LOOP
                  Put_Line___(output_, margin_ || condition_word_ || ' ( receive_group_ = ''' || c8.receive_group || ''' ) THEN ');
                  IF ( INSTR(c8.modify_method, ';') > 0 ) THEN
                     Put_Line___(output_, margin_ || '   ' || c8.modify_method);
                  ELSE
                     Put_Line___(output_, margin_ || '   ' || c8.modify_method ||
                        '(info_, objid_, objversion_, attr_, ' || CHR(39) || 'DO' || CHR(39) || ');');
                  END IF;
                  condition_word_ := 'ELSIF';
               END LOOP;
               IF ( condition_word_ = 'ELSIF' ) THEN
                  Put_Line___(output_, margin_ || 'ELSE');
                  Put_Line___(output_, margin_ || '   ' || INITCAP(Dictionary_SYS.ClientNameToDbName_(c1_rec.lu_name)) ||
                     '_API.Modify__(info_, objid_, objversion_, attr_, ' || CHR(39) || 'DO' || CHR(39) || ');');
                  Put_Line___(output_, margin_ || 'END IF;');
               ELSE
                  Put_Line___(output_, margin_ || INITCAP(Dictionary_SYS.ClientNameToDbName_(c1_rec.lu_name)) ||
                     '_API.Modify__(info_, objid_, objversion_, attr_, ' || CHR(39) || 'DO' || CHR(39) || ');');
               END IF;
            ELSE
               IF ( key_word_ IS NULL ) THEN
                  new_value_ := NULL;
               ELSIF ( key_word_ = 'LOOP_CREATE_RECEIVE_LINES' ) THEN
                  new_value_ := c1_rec.lu_name || '___';
               ELSIF ( key_word_ = 'PROC_NAME' ) THEN
                  new_value_ := c1_rec.lu_name;
               ELSIF ( key_word_ = 'OBJECT_VIEW' ) THEN
                  new_value_ := LOWER(c1_rec.view_name);
               ELSIF ( key_word_ = 'CALL_NEW_PREPARE' ) THEN
                  new_value_ := INITCAP(Dictionary_SYS.ClientNameToDbName_(c1_rec.lu_name)) ||
                     '_API.New__(info_, objid_, objversion_, new_attr_, ' || CHR(39) || 'PREPARE' || CHR(39) || ');';
               ELSIF ( key_word_ = 'DATE_COLUMN_LIST' ) THEN
                  new_value_ := CHR(39) || 'DATE' || CHR(39);
                  FOR c4 IN  c4_date_column (Dictionary_SYS.ClientNameToDbName_(c1_rec.lu_name)) LOOP
                     new_value_ := new_value_ || ',' || CHR(39) || c4.column_name || CHR(39);
                  END LOOP;
               ELSIF ( key_word_ = 'RCV_LU_NEW' ) THEN
                  comma_ := NULL;
                  FOR c5 IN  c5_rcv_lu (business_object_, c1_rec.lu_name, 'TRUE', '') LOOP
                     new_value_ := new_value_ || comma_ || CHR(39) || c5.receive_group|| CHR(39);
                     comma_ := ',';
                  END LOOP;
                  IF ( new_value_ IS NULL ) THEN
                     new_value_ := CHR(39) || 'None accepted' || CHR(39);
                  END IF;
               ELSIF ( key_word_ = 'RCV_LU_MODIFY' ) THEN
                  comma_ := NULL;
                  FOR c5 IN  c5_rcv_lu (business_object_, c1_rec.lu_name, '', 'TRUE') LOOP
                     new_value_ := new_value_ || comma_ || CHR(39) || c5.receive_group|| CHR(39);
                     comma_ := ',';
                  END LOOP;
                  IF ( new_value_ IS NULL ) THEN
                     new_value_ := CHR(39) || 'None accepted' || CHR(39);
                  END IF;
               ELSIF ( key_word_ = 'SPREAD_COLUMN' ) THEN
                  FOR c104 IN  c104_spread_column (business_object_, c1_rec.lu_name) LOOP
                     new_value_ :=  c104.spread_column;
                  END LOOP;
               ELSE
                  new_value_ := key_word_;
               END IF;
               out_line_ := Replace_Keyword___(table_(index_), key_word_, new_value_);
               IF ( LTRIM(RTRIM(out_line_)) IS NOT NULL ) THEN
                  Put_Line___(output_, out_line_);
               END IF;
            END IF;
            index_ := index_ + 1;
         END LOOP;
      END LOOP;
   END Create_Db_Update___;

   PROCEDURE Create_Load___ (
      table_           IN OUT table_type,
      business_object_ IN     VARCHAR2,
      number_of_lines_ IN     BINARY_INTEGER )
   IS
      condition_       table_type;
      or_              VARCHAR2(10);
      tmp_condition_   VARCHAR2(2000);
      out_line_        VARCHAR2(2000);
      new_value_       VARCHAR2(2000);
      key_word_        VARCHAR2(100);
      index_           BINARY_INTEGER := 1;
      idx_             BINARY_INTEGER;
      margin_          VARCHAR2(120);
      CURSOR c1_lu (object_ replication_attr_group_def_tab.business_object%TYPE) IS
         SELECT a.lu_name       AS lu_name,
                a.trigger_table AS trigger_table
         FROM   replication_attr_group_def_tab a
         WHERE  a.business_object = object_
         AND EXISTS ( SELECT 'x'
                      FROM   replication_attr_group_tab b
                      WHERE  b.business_object = a.business_object
                      AND    b.lu_name         = a.lu_name
                      AND   (b.on_new          = 'TRUE'
                         OR  b.on_modify       = 'TRUE')
                    );
      CURSOR c2_keys (object_ replication_attr_def_tab.business_object%TYPE,
                      lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT UPPER(NVL(a.table_key_name, a.column_name)) AS column_name,
                UPPER(a.column_name)                        AS view_column_name
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.key             = 'TRUE';
      CURSOR c3_bo_keys (object_ replication_attr_def_tab.business_object%TYPE,
                         lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT UPPER(NVL(a.table_key_name, a.column_name)) AS column_name,
                UPPER(a.bo_key_name)                        AS bo_key
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.key             = 'TRUE'
         AND    a.bo_key_name     IS NOT NULL;
      CURSOR c4_replicate (object_ replication_attr_group_tab.business_object%TYPE,
                           lu_     replication_attr_group_tab.lu_name%TYPE) IS
         SELECT a.replication_group AS replication_group,
                a.on_new            AS on_new,
                a.on_modify         AS on_modify
         FROM   replication_attr_group_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND   (a.on_new          = 'TRUE'
            OR  a.on_modify       = 'TRUE');
      CURSOR c5_generic_condition (object_ replication_condition_tab.business_object%TYPE,
                                   group_  replication_condition_tab.replication_group%TYPE) IS
         SELECT REPLACE(REPLACE(a.condition,':new.','c1.'),':NEW.','c1.') AS condition
         FROM   replication_condition_tab a
         WHERE  a.replication_group = group_
         AND    a.business_object   = object_
         AND    a.lu_name           = '*'
         AND    a.column_name       = '*'
         ORDER BY a.condition_sequence;
      CURSOR c6_generic_column (object_ replication_condition_tab.business_object%TYPE,
                                group_  replication_condition_tab.replication_group%TYPE,
                                table_  VARCHAR2) IS
         SELECT DISTINCT(a.column_name) AS column_name
         FROM   replication_condition_tab a
         WHERE  a.replication_group = group_
         AND    a.business_object   = object_
         AND    a.lu_name           = '*'
         AND    a.column_name      != '*'
         AND EXISTS ( SELECT 'x'
                      FROM   user_tab_columns b
                      WHERE  b.column_name = DECODE(SUBSTR(a.column_name, LENGTH(a.column_name)-2, 3), '_DB',
                                               SUBSTR(a.column_name, 1, LENGTH(a.column_name)-3), a.column_name)
                      AND    b.table_name  = table_
                     );
      CURSOR c7_generic_column_condition (object_ replication_condition_tab.business_object%TYPE,
                                          group_  replication_condition_tab.replication_group%TYPE,
                                          column_ replication_condition_tab.column_name%TYPE,
                                          table_   VARCHAR2) IS
         SELECT REPLACE(REPLACE(a.condition,':new.','c1.'),':NEW.','c1.') AS condition
         FROM   replication_condition_tab a
         WHERE  a.replication_group = group_
         AND    a.business_object   = object_
         AND    a.lu_name           = '*'
         AND    a.column_name       = column_
         AND EXISTS ( SELECT 'x'
                      FROM   user_tab_columns b
                      WHERE  b.column_name = DECODE(SUBSTR(a.column_name, LENGTH(a.column_name)-2, 3), '_DB',
                                               SUBSTR(a.column_name, 1, LENGTH(a.column_name)-3), a.column_name)
                      AND    b.table_name  = table_
                     )
         ORDER BY a.condition_sequence;
      CURSOR c8_column (object_ replication_condition_tab.business_object%TYPE,
                        group_  replication_condition_tab.replication_group%TYPE,
                        lu_     replication_condition_tab.lu_name%TYPE,
                        table_  VARCHAR2) IS
         SELECT DISTINCT(a.column_name) AS column_name
         FROM   replication_condition_tab a
         WHERE  a.replication_group = group_
         AND    a.business_object   = object_
         AND    a.lu_name           = lu_
         AND    a.column_name      != '*'
         AND EXISTS ( SELECT 'x'
                      FROM   user_tab_columns b
                      WHERE  b.column_name = DECODE(SUBSTR(a.column_name, LENGTH(a.column_name)-2, 3), '_DB',
                                               SUBSTR(a.column_name, 1, LENGTH(a.column_name)-3), a.column_name)
                      AND    b.table_name  = table_
                     );
      CURSOR c9_column_condition (object_ replication_condition_tab.business_object%TYPE,
                                  group_  replication_condition_tab.replication_group%TYPE,
                                  lu_     replication_condition_tab.lu_name%TYPE,
                                  column_ replication_condition_tab.column_name%TYPE,
                                  table_  VARCHAR2) IS
         SELECT REPLACE(REPLACE(a.condition,':new.','c1.'),':NEW.','c1.') AS condition
         FROM   replication_condition_tab a
         WHERE  a.replication_group = group_
         AND    a.business_object   = object_
         AND    a.lu_name           = lu_
         AND    a.column_name       = column_
         AND EXISTS ( SELECT 'x'
                      FROM   user_tab_columns b
                      WHERE  b.column_name = DECODE(SUBSTR(a.column_name, LENGTH(a.column_name)-2, 3), '_DB',
                                               SUBSTR(a.column_name, 1, LENGTH(a.column_name)-3), a.column_name)
                      AND    b.table_name  = table_
                     )
         ORDER BY a.condition_sequence;
   BEGIN
      FOR c1 IN c1_lu (business_object_) LOOP
         index_ := 1;
         WHILE ( index_ <= number_of_lines_ ) LOOP
            key_word_ := Find_Keyword___(table_(index_));
            IF ( key_word_ IS NOT NULL ) THEN
               margin_ := RPAD(' ', (INSTR(table_(index_),'<<<') - 1));
            ELSE
               margin_ := NULL;
            END IF;
            IF ( (key_word_ IS NOT NULL) AND (key_word_ = 'OBJECT_KEYS') ) THEN
               FOR c2 IN c2_keys (business_object_, c1.lu_name) LOOP
                  Put_Line___(output_, margin_ || 'Client_SYS.Add_To_Attr(''' || c2.view_column_name || ''', c1.' || LOWER(c2.column_name) || ', attr_);');
               END LOOP;
               Put_Line___(output_, margin_ || '--');
            --
            -- Create instructions for Business Object key(s)
            -- ----------------------------------------------
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'BO_OBJECT_KEYS') ) THEN
               FOR c3 IN c3_bo_keys (business_object_, c1.lu_name) LOOP
                  Put_Line___(output_, margin_ || 'Client_SYS.Add_To_Attr(''' || c3.bo_key || ''', c1.' || LOWER(c3.column_name) || ', attr_);');
               END LOOP;
            ELSIF ( (key_word_ IS NOT NULL) AND (key_word_ = 'REPLICATION_GROUP') ) THEN
               FOR c4 IN c4_replicate (business_object_, c1.lu_name) LOOP
                  Put_Line___(output_, margin_ || 'IF ( replication_group_ = ''' || c4.replication_group || ''') THEN');
                  margin_ := margin_ || '   ';
                  idx_ := 0;
                  --
                  -- Create generic conditions for business object
                  -- ---------------------------------------------
                  FOR c5 IN c5_generic_condition (business_object_, c4.replication_group) LOOP
                     idx_ := idx_ + 1;
                     condition_(idx_) := '( ' || c5.condition || ' )';
                  END LOOP;
                  --
                  -- Create generic conditions for business object columns
                  -- -----------------------------------------------------
                  FOR c6 IN c6_generic_column (business_object_, c4.replication_group, c1.trigger_table) LOOP
                     tmp_condition_ := '( ';
                     or_ := NULL;
                     FOR c7 IN c7_generic_column_condition (business_object_, c4.replication_group, c6.column_name, c1.trigger_table) LOOP
                        tmp_condition_ := tmp_condition_ || or_ || '(' || c7.condition || ')';
                        or_ := ' OR ';
                     END LOOP;
                     IF ( LENGTH(tmp_condition_) > 3 ) THEN
                        tmp_condition_ := tmp_condition_ || ' )';
                        idx_ := idx_ + 1;
                        condition_(idx_) := '( ' || tmp_condition_ || ' )';
                     END IF;
                  END LOOP;
                  --
                  -- Create conditions for business object lu columns
                  -- ------------------------------------------------
                  FOR c8 IN c8_column (business_object_, c4.replication_group, c1.lu_name, c1.trigger_table) LOOP
                     tmp_condition_ := '( ';
                     or_ := NULL;
                     FOR c9 IN c9_column_condition (business_object_, c4.replication_group, c1.lu_name, c8.column_name, c1.trigger_table) LOOP
                        tmp_condition_ := tmp_condition_ || or_ || '(' || c9.condition || ')';
                        or_ := ' OR ';
                     END LOOP;
                     IF ( LENGTH(tmp_condition_) > 3 ) THEN
                        tmp_condition_ := tmp_condition_ || ' )';
                        idx_ := idx_ + 1;
                        condition_(idx_) := '( ' || tmp_condition_ || ' )';
                     END IF;
                  END LOOP;
                  IF ( idx_ > 0 ) THEN
                     FOR i_ IN 1..idx_ LOOP
                        IF ( i_ = 1 ) THEN
                           Put_Line___(output_, margin_ || 'IF  ' || condition_(i_));
                        ELSE
                           Put_Line___(output_, margin_ || 'AND ' || condition_(i_));
                        END IF;
                     END LOOP;
                     Put_Line___(output_, margin_ || 'THEN');
                     margin_ := margin_ || '   ';
                  END IF;
                  IF ( (c4.on_new = 'TRUE') ) THEN
                     Put_Line___(output_, margin_ || 'Replication_Queue_API.Create_New__(newrec_);');
                  ELSE
                     Put_Line___(output_, margin_ || 'NULL;');
                  END IF;
                  IF ( idx_ > 0 ) THEN
                     margin_ := SUBSTR(margin_, 1, LENGTH(margin_) - 3);
                     Put_Line___(output_, margin_ || 'END IF;');
                  END IF;
                  margin_ := SUBSTR(margin_, 1, LENGTH(margin_) - 3);
                  Put_Line___(output_, margin_ || 'END IF;');
               END LOOP;
            ELSE
               IF ( key_word_ IS NULL ) THEN
                  new_value_ := NULL;
               ELSIF ( key_word_ IN ('CREATE_LOAD_CURSOR','CREATE_LOAD_INSTRUCTION') ) THEN
                  new_value_ := NULL;
               ELSIF ( key_word_ = 'LU' ) THEN
                  new_value_ := c1.lu_name;
               ELSIF ( key_word_ = 'TABLE' ) THEN
                  new_value_ := LOWER(c1.trigger_table);
               ELSE
                  new_value_ := key_word_;
               END IF;
               out_line_ := Replace_Keyword___(table_(index_), key_word_, new_value_);
               IF ( LTRIM(RTRIM(out_line_)) IS NOT NULL ) THEN
                  Put_Line___(output_, out_line_);
               END IF;
            END IF;
            index_ := index_ + 1;
         END LOOP;
      END LOOP;
   END Create_Load___;

   PROCEDURE Create_Message___ (
      table_           IN OUT table_type,
      business_object_ IN     VARCHAR2,
      number_of_lines_ IN     BINARY_INTEGER )
   IS
      out_line_        VARCHAR2(2000);
      new_value_       VARCHAR2(2000);
      key_word_        VARCHAR2(100);
      column_name_1_   VARCHAR2(30);
      column_name_2_   VARCHAR2(30);
      column_no_       NUMBER;
      column_no_save_  NUMBER;
      new_count_       NUMBER;
      modify_count_    NUMBER;
      condition_word_  VARCHAR2(10);
      index_           BINARY_INTEGER := 1;
      margin_          VARCHAR2(120);
      CURSOR c1_lu (object_ replication_attr_group_def_tab.business_object%TYPE) IS
         SELECT a.lu_name   AS lu_name,
                a.view_name AS view_name
         FROM   replication_attr_group_def_tab a
         WHERE  a.business_object = object_;
      CURSOR c2_column (object_ replication_attr_def_tab.business_object%TYPE,
                        lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT UPPER(a.column_name) AS column_name
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND  ((a.on_new          = 'TRUE'
            AND a.on_modify       = 'TRUE')
            OR  a.key             = 'TRUE')
         ORDER BY a.sequence_no;
      CURSOR c3_column_on_new_count (object_ replication_attr_def_tab.business_object%TYPE,
                                     lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT COUNT(*) AS count_
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.on_new          = 'TRUE'
         AND    a.on_modify       = 'FALSE'
         AND    a.key             = 'FALSE';
      CURSOR c3_column_on_new (object_ replication_attr_def_tab.business_object%TYPE,
                               lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT UPPER(a.column_name) AS column_name
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.on_new          = 'TRUE'
         AND    a.on_modify       = 'FALSE'
         AND    a.key             = 'FALSE'
         ORDER BY a.sequence_no;
      CURSOR c4_column_on_modify_count (object_ replication_attr_def_tab.business_object%TYPE,
                                        lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT COUNT(*) AS count_
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.on_new          = 'FALSE'
         AND    a.on_modify       = 'TRUE'
         AND    a.key             = 'FALSE';
      CURSOR c4_column_on_modify (object_ replication_attr_def_tab.business_object%TYPE,
                                  lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT UPPER(a.column_name) AS column_name
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.on_new          = 'FALSE'
         AND    a.on_modify       = 'TRUE'
         AND    a.key             = 'FALSE'
         ORDER BY a.sequence_no;
      CURSOR c5_column_not_replicated (object_ replication_attr_def_tab.business_object%TYPE,
                                       lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT UPPER(a.column_name) AS column_name
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_
         AND    a.on_new          = 'FALSE'
         AND    a.on_modify       = 'FALSE'
         ORDER BY a.sequence_no;
   BEGIN
      FOR c1_rec IN c1_lu (business_object_) LOOP
         index_ := 1;
         WHILE ( index_ <= number_of_lines_ ) LOOP
            key_word_ := Find_Keyword___(table_(index_));
            IF ( key_word_ IS NOT NULL ) THEN
               margin_ := RPAD(' ', (INSTR(table_(index_),'<<<') - 1));
            ELSE
               margin_ := NULL;
            END IF;
            IF ( (key_word_ IS NOT NULL) AND (key_word_ = 'VIEW_COLUMNS') ) THEN
               column_no_ := 0;
               FOR c2 IN c2_column (business_object_, c1_rec.lu_name) LOOP
                  IF ( column_no_ > 96 ) THEN
                     Put_Line___(output_, margin_ || 'Connectivity_SYS.Create_Message_Line(attr_);');
                     Put_Line___(output_, margin_ || 'message_line_ := message_line_ + 1;');
                     column_no_ := 0;
                     Put_Line___(output_, margin_ || 'Client_SYS.Clear_Attr(attr_);');
                     Put_Line___(output_, margin_ || 'Client_SYS.Add_To_Attr(''MESSAGE_ID'', message_id_, attr_);');
                     Put_Line___(output_, margin_ || 'Client_SYS.Add_To_Attr(''MESSAGE_LINE'', message_line_, attr_);');
                     Put_Line___(output_, margin_ || 'Client_SYS.Add_To_Attr(''NAME'', ''ATTRIBUTE'', attr_);');
                  END IF;
                  column_name_1_ := 'C' || LTRIM(TO_CHAR(column_no_, '00'));
                  column_name_2_ := 'C' || LTRIM(TO_CHAR((column_no_ + 1), '00'));
                  column_no_ := column_no_ + 2;
                  Put_Line___(output_, margin_ || 'Add_To_Attr___(''' || column_name_1_ || ''', ''' || c2.column_name || ''', attr_);');
                  Put_Line___(output_, margin_ || 'Add_To_Attr___(''' || column_name_2_ || ''', c1_rec.' || LOWER(c2.column_name) || ', attr_);');
               END LOOP;
               Put_Line___(output_, margin_ || '--');
               FOR c5 IN c5_column_not_replicated (business_object_, c1_rec.lu_name) LOOP
                  Put_Line___(output_, margin_ || '-- NOT replicated: ' || c5.column_name);
               END LOOP;
               Put_Line___(output_, margin_ || '--');
               column_name_1_ := 'C' || LTRIM(TO_CHAR(column_no_, '00'));
               column_name_2_ := 'C' || LTRIM(TO_CHAR((column_no_ + 1), '00'));
               Put_Line___(output_, margin_ || 'Client_SYS.Add_To_Attr(''' || column_name_1_ || ''', ''END_ATTRIBUTE'', attr_);');
   --
               OPEN c3_column_on_new_count (business_object_, c1_rec.lu_name);
               FETCH c3_column_on_new_count INTO new_count_;
               CLOSE c3_column_on_new_count;
               OPEN c4_column_on_modify_count (business_object_, c1_rec.lu_name);
               FETCH c4_column_on_modify_count INTO modify_count_;
               CLOSE c4_column_on_modify_count;
   --
               condition_word_ := 'IF';
               column_no_save_ := column_no_;
               IF ( new_count_ > 0 ) THEN
                  Put_Line___(output_, margin_ || condition_word_ || ' ( operation_ IN (''NEW'',''LOAD'') ) THEN');
                  condition_word_ := 'ELSIF';
                  FOR c3 IN c3_column_on_new (business_object_, c1_rec.lu_name) LOOP
                     IF ( column_no_ > 96 ) THEN
                        Put_Line___(output_, margin_ || '   Connectivity_SYS.Create_Message_Line(attr_);');
                        Put_Line___(output_, margin_ || '   message_line_ := message_line_ + 1;');
                        column_no_ := 0;
                        Put_Line___(output_, margin_ || '   Client_SYS.Clear_Attr(attr_);');
                        Put_Line___(output_, margin_ || '   Client_SYS.Add_To_Attr(''MESSAGE_ID'', message_id_, attr_);');
                        Put_Line___(output_, margin_ || '   Client_SYS.Add_To_Attr(''MESSAGE_LINE'', message_line_, attr_);');
                        Put_Line___(output_, margin_ || '   Client_SYS.Add_To_Attr(''NAME'', ''ATTRIBUTE'', attr_);');
                     END IF;
                     column_name_1_ := 'C' || LTRIM(TO_CHAR(column_no_, '00'));
                     column_name_2_ := 'C' || LTRIM(TO_CHAR((column_no_ + 1), '00'));
                     column_no_ := column_no_ + 2;
                     Put_Line___(output_, margin_ || '   Add_To_Attr___(''' || column_name_1_ || ''', ''' || c3.column_name || ''', attr_);');
                     Put_Line___(output_, margin_ || '   Add_To_Attr___(''' || column_name_2_ || ''', c1_rec.' || LOWER(c3.column_name) || ', attr_);');
                  END LOOP;
                  Put_Line___(output_, margin_ || '   --');
                  column_name_1_ := 'C' || LTRIM(TO_CHAR(column_no_, '00'));
                  column_name_2_ := 'C' || LTRIM(TO_CHAR((column_no_ + 1), '00'));
                  Put_Line___(output_, margin_ || '   Client_SYS.Add_To_Attr(''' || column_name_1_ || ''', ''END_ATTRIBUTE'', attr_);');
               END IF;
   --
               column_no_ := column_no_save_;
               IF ( modify_count_ > 0 ) THEN
                  Put_Line___(output_, margin_ || condition_word_ || ' ( operation_ = ''MODIFY'' ) THEN');
                  condition_word_ := 'ELSIF';
                  FOR c4 IN c4_column_on_modify (business_object_, c1_rec.lu_name) LOOP
                     IF ( column_no_ > 96 ) THEN
                        Put_Line___(output_, margin_ || '   Connectivity_SYS.Create_Message_Line(attr_);');
                        Put_Line___(output_, margin_ || '   message_line_ := message_line_ + 1;');
                        column_no_ := 0;
                        Put_Line___(output_, margin_ || '   Client_SYS.Clear_Attr(attr_);');
                        Put_Line___(output_, margin_ || '   Client_SYS.Add_To_Attr(''MESSAGE_ID'', message_id_, attr_);');
                        Put_Line___(output_, margin_ || '   Client_SYS.Add_To_Attr(''MESSAGE_LINE'', message_line_, attr_);');
                        Put_Line___(output_, margin_ || '   Client_SYS.Add_To_Attr(''NAME'', ''ATTRIBUTE'', attr_);');
                     END IF;
                     column_name_1_ := 'C' || LTRIM(TO_CHAR(column_no_, '00'));
                     column_name_2_ := 'C' || LTRIM(TO_CHAR((column_no_ + 1), '00'));
                     column_no_ := column_no_ + 2;
                     Put_Line___(output_, margin_ || '   Add_To_Attr___(''' || column_name_1_ || ''', ''' || c4.column_name || ''', attr_);');
                     Put_Line___(output_, margin_ || '   Add_To_Attr___(''' || column_name_2_ || ''', c1_rec.' || LOWER(c4.column_name) || ', attr_);');
                  END LOOP;
                  Put_Line___(output_, margin_ || '   --');
                  column_name_1_ := 'C' || LTRIM(TO_CHAR(column_no_, '00'));
                  column_name_2_ := 'C' || LTRIM(TO_CHAR((column_no_ + 1), '00'));
                  Put_Line___(output_, margin_ || '   Client_SYS.Add_To_Attr(''' || column_name_1_ || ''', ''END_ATTRIBUTE'', attr_);');
               END IF;
   --
               IF ( (new_count_ + modify_count_) > 0 ) THEN
                  Put_Line___(output_, margin_ || 'END IF;');
               END IF;
               Put_Line___(output_, margin_ || 'Connectivity_SYS.Create_Message_Line(attr_);');
               Put_Line___(output_, margin_ || 'message_line_ := message_line_ + 1;');
            ELSE
               IF ( key_word_ IS NULL ) THEN
                  new_value_ := NULL;
               ELSIF ( key_word_ = 'CREATE_MESSAGE_LINES' ) THEN
                  new_value_ := c1_rec.lu_name || '___';
               ELSIF ( key_word_ = 'PROC_NAME' ) THEN
                  new_value_ := c1_rec.lu_name;
               ELSIF ( key_word_ = 'VIEW_NAME' ) THEN
                  new_value_ := LOWER(c1_rec.view_name);
               ELSE
                  new_value_ := key_word_;
               END IF;
               out_line_ := Replace_Keyword___(table_(index_), key_word_, new_value_);
               IF ( LTRIM(RTRIM(out_line_)) IS NOT NULL ) THEN
                  Put_Line___(output_, out_line_);
               END IF;
            END IF;
            index_ := index_ + 1;
         END LOOP;
      END LOOP;
   END Create_Message___;

   FUNCTION Get_Directory___ (
      file_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      IF ( INSTR(file_, '\', -1) > 0 ) THEN
         RETURN SUBSTR(file_, 1, INSTR(file_, '\', -1));
      ELSIF ( INSTR(file_, '/', -1) > 0 ) THEN
         RETURN SUBSTR(file_, 1, INSTR(file_, '/', -1));
      ELSE
         RETURN NULL;
      END IF;
   END Get_Directory___;

   FUNCTION Get_File_Name___ (
      file_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      IF ( INSTR(file_, '\', -1) > 0 ) THEN
         RETURN SUBSTR(file_, INSTR(file_, '\', -1) + 1);
      ELSIF ( INSTR(file_, '/', -1) > 0 ) THEN
         RETURN SUBSTR(file_, INSTR(file_, '/', -1) + 1);
      ELSE
         RETURN file_;
      END IF;
   END Get_File_Name___;

   PROCEDURE Get_Line___ (
      file_ IN OUT file_handle_%TYPE,
      line_ IN OUT VARCHAR2 )
   IS
   -- 041101 jhmase - Unicode start
      tmp_ VARCHAR2(32000);
   -- 041101 jhmase - Unicode end
   BEGIN
      IF ( use_table_ ) THEN
         IF ( create_type_ = 'APY' ) THEN
            line_ := template_apy_(template_index_apy_);
            template_index_apy_ := template_index_apy_ + 1;
         ELSE
            line_ := template_api_(template_index_api_);
            template_index_api_ := template_index_api_ + 1;
         END IF;
      ELSE
   -- 041101 jhmase - Unicode start
      UTL_FILE.GET_LINE(file_, tmp_);
--    UTL_FILE.GET_LINE(file_, line_);
         line_ := Database_SYS.File_To_Db_Encoding(tmp_);
   -- 041101 jhmase - Unicode end
      END IF;
   END Get_Line___;

   FUNCTION Load_Lines___ (
      in_line_  IN     VARCHAR2,
      key_word_ IN     VARCHAR2,
      table_    IN OUT table_type ) RETURN BINARY_INTEGER
   IS
      key_          VARCHAR2(100);
      line_         VARCHAR2(2000) := in_line_;
      index_        BINARY_INTEGER := 1;
      end_of_file_  BOOLEAN := FALSE;
   BEGIN
      table_(index_) := line_;
      WHILE NOT end_of_file_ LOOP
         index_ := index_ + 1;
         BEGIN
            Get_Line___(template_, line_);
            table_(index_) := line_;
            key_ := Find_Keyword___(line_);
            IF ( (key_ IS NOT NULL) AND (key_ = key_word_) ) THEN
               end_of_file_ := TRUE;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               end_of_file_ := TRUE;
            WHEN OTHERS THEN
               RAISE;
         END;
      END LOOP;
      RETURN index_;
   END Load_Lines___;

   FUNCTION Open_File___ (
      file_           IN VARCHAR2,
      mode_           IN VARCHAR2 ) RETURN file_handle_%TYPE
   IS
      null_handle_    file_handle_%TYPE;
   BEGIN
      IF ( use_table_ ) THEN RETURN(null_handle_); END IF;
      IF ( mode_ NOT IN ('R','W') ) THEN
         Error_SYS.Appl_General(lu_name_, 'UNKNOWNMODE: Unknown mode :P1.', mode_);
      END IF;
      IF ( file_ IS NULL ) THEN
         IF ( mode_ = 'R' ) THEN
            Error_SYS.Appl_General(lu_name_, 'NOTEMPLATEFILE: Template file name missing!');
         ELSE
            Error_SYS.Appl_General(lu_name_, 'NOOUTPUTFILE: Output file name missing!');
         END IF;
      END IF;
      BEGIN
         RETURN(UTL_FILE.FOPEN(Get_Directory___(file_), Get_File_Name___(file_), mode_));
      EXCEPTION
         WHEN OTHERS THEN
            Error_SYS.Appl_General(lu_name_, 'ERROROPEN: Can not open - Directory: :P1 File: :P2 - :P3', Get_Directory___(file_), Get_File_Name___(file_), sqlerrm);
      END;
   END Open_File___;

   PROCEDURE Create_Receive_Package___ (
      business_object_ IN     VARCHAR2,
      template_api_    IN OUT VARCHAR2,
      template_apy_    IN OUT VARCHAR2,
      out_file_api_    IN OUT VARCHAR2,
      out_file_apy_    IN OUT VARCHAR2 )
   IS
      table_           table_type;
      end_of_file_     BOOLEAN := FALSE;
      package_name_    VARCHAR2(30);
      in_line_         VARCHAR2(2000);
      out_line_        VARCHAR2(2000);
      key_word_        VARCHAR2(100);
      new_value_       VARCHAR2(2000);
      condition_word_  VARCHAR2(30);
      comma_           VARCHAR2(2);
      index_           BINARY_INTEGER;
      count_           BINARY_INTEGER;
      margin_          VARCHAR2(120);
      dummy_           VARCHAR2(2000);
      CURSOR c1_master (object_ replication_object_def_tab.business_object%TYPE) IS
         SELECT a.master_lu        AS master_lu,
                a.new_modify_error AS new_modify_error
         FROM   replication_object_def_tab a
         WHERE  a.business_object = object_;
      CURSOR c2_lu (object_ replication_attr_group_def_tab.business_object%TYPE) IS
         SELECT a.lu_name AS lu_name
         FROM   replication_attr_group_def_tab a
         WHERE  a.business_object = object_;
      CURSOR c3_rcv_object (object_ receive_object_tab.business_object%TYPE,
                            new_    receive_object_tab.new_allowed%TYPE,
                            modify_ receive_object_tab.modify_allowed%TYPE) IS
         SELECT a.receive_group AS receive_group
         FROM   receive_object_tab a
         WHERE  a.business_object = object_
         AND    a.new_allowed     LIKE new_ || '%'
         AND    a.modify_allowed  LIKE modify_ || '%';
      CURSOR c4_spread (object_ receive_attr_group_tab.business_object%TYPE) IS
         SELECT a.receive_group AS receive_group,
                a.lu_name       AS lu_name,
                a.spread_column AS spread_column,
                a.spread_value  AS spread_value
         FROM   receive_attr_group_tab a
         WHERE  a.business_object = object_
         AND    a.spread_column   IS NOT NULL
         AND    a.spread_value    IS NOT NULL
         ORDER BY a.receive_group, a.lu_name, a.spread_column;
      CURSOR c5_subst (object_ receive_attr_group_tab.business_object%TYPE) IS
         SELECT a.receive_group       AS receive_group,
                a.lu_name             AS lu_name,
                a.column_name         AS column_name,
                a.substitution_value  AS subst_value
         FROM   receive_attr_tab a
         WHERE  a.business_object    = object_
         AND    a.substitution_value IS NOT NULL
         ORDER BY a.receive_group, a.lu_name, a.column_name;
      CURSOR c6_constant (object_ receive_attr_group_tab.business_object%TYPE) IS
         SELECT a.receive_group   AS receive_group,
                a.lu_name         AS lu_name,
                a.column_name     AS column_name,
                a.constant_value  AS constant_value
         FROM   receive_attr_tab a
         WHERE  a.business_object = object_
         AND    a.constant_value  IS NOT NULL
         ORDER BY a.receive_group, a.lu_name, a.column_name;
      CURSOR c7_column_access  (object_ receive_attr_tab.business_object%TYPE) IS
         SELECT a.receive_group   AS receive_group,
                a.lu_name         AS lu_name,
                a.column_name     AS column_name,
                a.new_allowed     AS new_allowed,
                a.modify_allowed  AS modify_allowed
         FROM   receive_attr_tab a
         WHERE  a.business_object = object_
         AND   (a.new_allowed     = 'TRUE'
            OR  a.modify_allowed  = 'TRUE')
         ORDER BY a.receive_group, a.lu_name, a.column_name;
      CURSOR c8_default (object_ receive_attr_group_tab.business_object%TYPE) IS
         SELECT a.receive_group   AS receive_group,
                a.lu_name         AS lu_name,
                a.column_name     AS column_name,
                a.default_value   AS default_value
         FROM   receive_attr_tab a
         WHERE  a.business_object = object_
         AND    a.default_value  IS NOT NULL
         ORDER BY a.receive_group, a.lu_name, a.column_name;
   BEGIN
      package_name_ := UPPER(business_object_) || '_BOR_API';
      count_ := 0;
      WHILE ( count_ < 2 ) LOOP
         IF ( count_ = 0 ) THEN
            create_type_ := 'API';
            template_    := Open_File___(template_api_, 'R');
            output_      := Open_File___(out_file_api_, 'W');
         ELSE
            create_type_ := 'APY';
            template_    := Open_File___(template_apy_, 'R');
            output_      := Open_File___(out_file_apy_, 'W');
         END IF;
         end_of_file_ := FALSE;
         WHILE NOT end_of_file_ LOOP
            BEGIN
               Get_Line___(template_, in_line_);
               key_word_ := Find_Keyword___(in_line_);
               IF ( key_word_ IS NOT NULL ) THEN
                  margin_ := RPAD(' ', (INSTR(in_line_,'<<<') - 1));
               ELSE
                  margin_ := NULL;
               END IF;
               new_value_ := NULL;
               IF ( NVL(key_word_, 'KEY WORD') NOT IN ('LOOP_CREATE_RECEIVE_LINES',
                                                       'CALL_RECEIVE_LINES',
                                                       'COLUMN_ACCESS_RIGHTS',
                                                       'CONSTANT_VALUES',
                                                       'DEFAULT_VALUES',
                                                       'SPREAD_VALUES',
                                                       'SUBST_VALUES') ) THEN
                  IF ( key_word_ IS NULL ) THEN
                     new_value_ := NULL;
                  ELSIF ( key_word_ = 'SYSDATE' ) THEN
                     new_value_ := TO_CHAR(sysdate, 'yy-mm-dd');
                  ELSIF ( key_word_ = 'LU' ) THEN
                     new_value_ := business_object_;
                  ELSIF ( key_word_ = 'PKG' ) THEN
                     new_value_ := package_name_;
                  ELSIF ( key_word_ = 'BO' ) THEN
                     new_value_ := business_object_;
                  ELSIF ( key_word_ = 'MASTER_LU' ) THEN
                     OPEN c1_master (business_object_);
                     FETCH c1_master INTO new_value_, dummy_;
                     CLOSE c1_master;
                  ELSIF ( key_word_ = 'NEW_MODIFY_TRUE_FALSE' ) THEN
                     OPEN c1_master (business_object_);
                     FETCH c1_master INTO dummy_, new_value_;
                     CLOSE c1_master;
                  ELSIF ( key_word_ = 'RCV_OBJECT_NEW' ) THEN
                     comma_ := NULL;
                     FOR c3 IN  c3_rcv_object (business_object_, 'TRUE', '') LOOP
                        new_value_ := new_value_ || comma_ || CHR(39) || c3.receive_group || CHR(39);
                        comma_ := ',';
                     END LOOP;
                     IF ( new_value_ IS NULL ) THEN
                        new_value_ := CHR(39) || 'None accepted' || CHR(39);
                     END IF;
                  ELSIF ( key_word_ = 'RCV_OBJECT_MODIFY' ) THEN
                     comma_ := NULL;
                     FOR c3 IN  c3_rcv_object (business_object_, '', 'TRUE') LOOP
                        new_value_ := new_value_ || comma_ || CHR(39) || c3.receive_group || CHR(39);
                        comma_ := ',';
                     END LOOP;
                     IF ( new_value_ IS NULL ) THEN
                        new_value_ := CHR(39) || 'None accepted' || CHR(39);
                     END IF;
                  ELSE
                     new_value_ := key_word_;
                  END IF;
                  out_line_ := Replace_Keyword___(in_line_, key_word_, new_value_);
                  IF ( LTRIM(RTRIM(out_line_)) IS NOT NULL ) THEN
                     Put_Line___(output_, out_line_);
                  END IF;
               ELSIF ( key_word_ = 'DEFAULT_VALUES' ) THEN
                  index_ := 1;
                  FOR c8 IN c8_default (business_object_) LOOP
                     Put_Line___(output_, margin_ || 'default_table_(' || TO_CHAR(index_) || ').receive_group := ''' || c8.receive_group || ''';');
                     Put_Line___(output_, margin_ || 'default_table_(' || TO_CHAR(index_) || ').lu_name       := ''' || c8.lu_name       || ''';');
                     Put_Line___(output_, margin_ || 'default_table_(' || TO_CHAR(index_) || ').column_name   := ''' || c8.column_name   || ''';');
                     Put_Line___(output_, margin_ || 'default_table_(' || TO_CHAR(index_) || ').column_value  := ''' || c8.default_value || ''';');
                     index_ := index_ + 1;
                  END LOOP;
               ELSIF ( key_word_ = 'CONSTANT_VALUES' ) THEN
                  index_ := 1;
                  FOR c6 IN c6_constant (business_object_) LOOP
                     Put_Line___(output_, margin_ || 'constant_table_(' || TO_CHAR(index_) || ').receive_group := ''' || c6.receive_group    || ''';');
                     Put_Line___(output_, margin_ || 'constant_table_(' || TO_CHAR(index_) || ').lu_name       := ''' || c6.lu_name          || ''';');
                     Put_Line___(output_, margin_ || 'constant_table_(' || TO_CHAR(index_) || ').column_name   := ''' || c6.column_name      || ''';');
                     Put_Line___(output_, margin_ || 'constant_table_(' || TO_CHAR(index_) || ').column_value  := ''' || c6.constant_value   || ''';');
                     index_ := index_ + 1;
                  END LOOP;
               ELSIF ( key_word_ = 'SUBST_VALUES' ) THEN
                  index_ := 1;
                  FOR c5 IN c5_subst (business_object_) LOOP
                     Put_Line___(output_, margin_ || 'subst_table_(' || TO_CHAR(index_) || ').receive_group := ''' || c5.receive_group || ''';');
                     Put_Line___(output_, margin_ || 'subst_table_(' || TO_CHAR(index_) || ').lu_name       := ''' || c5.lu_name       || ''';');
                     Put_Line___(output_, margin_ || 'subst_table_(' || TO_CHAR(index_) || ').column_name   := ''' || c5.column_name   || ''';');
                     Put_Line___(output_, margin_ || 'subst_table_(' || TO_CHAR(index_) || ').column_value  := ''' || c5.subst_value   || ''';');
                     index_ := index_ + 1;
                  END LOOP;
               ELSIF ( key_word_ = 'SPREAD_VALUES' ) THEN
                  index_ := 1;
                  FOR c4 IN c4_spread (business_object_) LOOP
                     Put_Line___(output_, margin_ || 'spread_table_(' || TO_CHAR(index_) || ').receive_group := ''' || c4.receive_group || ''';');
                     Put_Line___(output_, margin_ || 'spread_table_(' || TO_CHAR(index_) || ').lu_name       := ''' || c4.lu_name       || ''';');
                     Put_Line___(output_, margin_ || 'spread_table_(' || TO_CHAR(index_) || ').column_name   := ''' || c4.spread_column || ''';');
                     Put_Line___(output_, margin_ || 'spread_table_(' || TO_CHAR(index_) || ').column_value  := ''' || c4.spread_value  || ''';');
                     index_ := index_ + 1;
                  END LOOP;
               ELSIF ( key_word_ = 'COLUMN_ACCESS_RIGHTS' ) THEN
                  index_ := 1;
                  FOR c7 IN c7_column_access (business_object_) LOOP
                     Put_Line___(output_, margin_ || 'column_allowed_(' || TO_CHAR(index_) || ').receive_group  := ''' || c7.receive_group  || ''';');
                     Put_Line___(output_, margin_ || 'column_allowed_(' || TO_CHAR(index_) || ').lu_name        := ''' || c7.lu_name        || ''';');
                     Put_Line___(output_, margin_ || 'column_allowed_(' || TO_CHAR(index_) || ').column_name    := ''' || c7.column_name    || ''';');
                     Put_Line___(output_, margin_ || 'column_allowed_(' || TO_CHAR(index_) || ').new_allowed    := '   || c7.new_allowed    || ';');
                     Put_Line___(output_, margin_ || 'column_allowed_(' || TO_CHAR(index_) || ').modify_allowed := '   || c7.modify_allowed || ';');
                     index_ := index_ + 1;
                  END LOOP;
               ELSIF ( key_word_ = 'CALL_RECEIVE_LINES' ) THEN
                  condition_word_ := 'IF';
                  FOR c2 IN c2_lu (business_object_) LOOP
                     Put_Line___(output_, margin_ || condition_word_ || ' ( lu_ = ''' || c2.lu_name || ''' ) THEN ');
                     Put_Line___(output_, margin_ || '   ' || c2.lu_name ||
                        '___(message_id_, receive_group_, operation_, attr_grp_rec_, attribute_rec_, send_warning_, send_info_, receive_warning_, receive_info_, log_operation_, new_modify_error_, remote_timezone_difference_, remote_date_format_);');
                     condition_word_ := 'ELSIF';
                  END LOOP;
                  Put_Line___(output_, margin_ || 'END IF;');
               ELSIF ( key_word_ = 'LOOP_CREATE_RECEIVE_LINES' ) THEN
                  index_ := Load_Lines___(in_line_, key_word_, table_);
                  Create_Db_Update___(table_, business_object_, index_);
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  end_of_file_ := TRUE;
               WHEN OTHERS THEN
                  RAISE;
            END;
         END LOOP;
         count_ := count_ + 1;
         Close_All___;
      END LOOP;
      Close_All___;
   EXCEPTION
      WHEN OTHERS THEN
         Close_All___;
         RAISE;
   END Create_Receive_Package___;

   PROCEDURE Create_Send_Package___ (
      business_object_ IN     VARCHAR2,
      template_api_    IN OUT VARCHAR2,
      template_apy_    IN OUT VARCHAR2,
      out_file_api_    IN OUT VARCHAR2,
      out_file_apy_    IN OUT VARCHAR2 )
   IS
      table_           table_type;
      end_of_file_     BOOLEAN := FALSE;
      package_name_    VARCHAR2(30);
      in_line_         VARCHAR2(2000);
      out_line_        VARCHAR2(2000);
      key_word_        VARCHAR2(100);
      new_value_       VARCHAR2(2000);
      db_name_         VARCHAR2(30);
      condition_word_  VARCHAR2(30);
      index_           BINARY_INTEGER;
      count_           BINARY_INTEGER;
      margin_          VARCHAR2(120);
      CURSOR c1_master (object_ replication_object_def_tab.business_object%TYPE) IS
         SELECT a.master_lu AS master_lu
         FROM   replication_object_def_tab a
         WHERE  a.business_object = object_;
      CURSOR c2_lu (object_ replication_attr_group_def_tab.business_object%TYPE) IS
         SELECT a.lu_name   AS lu_name,
                a.view_name AS view_name
         FROM   replication_attr_group_def_tab a
         WHERE  a.business_object = object_;
   BEGIN
      package_name_ := UPPER(business_object_) || '_BOS_API';
      count_ := 0;
      WHILE ( count_ < 2 ) LOOP
         IF ( count_ = 0 ) THEN
            create_type_ := 'API';
            template_    := Open_File___(template_api_, 'R');
            output_      := Open_File___(out_file_api_, 'W');
         ELSE
            create_type_ := 'APY';
            template_    := Open_File___(template_apy_, 'R');
            output_      := Open_File___(out_file_apy_, 'W');
         END IF;
         end_of_file_ := FALSE;
         WHILE NOT end_of_file_ LOOP
            BEGIN
               Get_Line___(template_, in_line_);
               key_word_ := Find_Keyword___(in_line_);
               IF ( key_word_ IS NOT NULL ) THEN
                  margin_ := RPAD(' ', (INSTR(in_line_,'<<<') - 1));
               ELSE
                  margin_ := NULL;
               END IF;
               IF ( NVL(key_word_, 'KEY WORD') NOT IN ('ROWID_DECL',
                                                       'ROWID_NULL',
                                                       'CALL_MESSAGE_LINES',
                                                       'CREATE_MESSAGE_LINES',
                                                       'CREATE_LOAD_CURSOR',
                                                       'CREATE_LOAD_INSTRUCTION') ) THEN
                  IF ( key_word_ IS NULL ) THEN
                     new_value_ := NULL;
                  ELSIF ( key_word_ = 'SYSDATE' ) THEN
                     new_value_ := TO_CHAR(sysdate, 'yy-mm-dd');
                  ELSIF ( key_word_ = 'LU' ) THEN
                     new_value_ := business_object_;
                  ELSIF ( key_word_ = 'PKG' ) THEN
                     new_value_ := package_name_;
                  ELSIF ( key_word_ = 'BO' ) THEN
                     new_value_ := business_object_;
                  ELSIF ( key_word_ = 'MASTER_LU' ) THEN
                     OPEN c1_master (business_object_);
                     FETCH c1_master INTO new_value_;
                     CLOSE c1_master;
                  ELSE
                     new_value_ := key_word_;
                  END IF;
                  out_line_ := Replace_Keyword___(in_line_, key_word_, new_value_);
                  IF ( LTRIM(RTRIM(out_line_)) IS NOT NULL ) THEN
                     Put_Line___(output_, out_line_);
                  END IF;
               ELSIF ( key_word_ IN ('ROWID_DECL', 'ROWID_NULL') ) THEN
                  FOR c2 IN c2_lu (business_object_) LOOP
                     db_name_ := LOWER(Dictionary_SYS.ClientNameToDbName_(c2.lu_name));
                     IF ( key_word_ = 'ROWID_DECL' ) THEN
                        new_value_ := RPAD('   '||SUBSTR(LOWER(c2.view_name),1,26) || '_id_',35) || 'ROWID;';
                     ELSIF ( key_word_ = 'ROWID_NULL' ) THEN
                        new_value_ := RPAD(SUBSTR(LOWER(c2.view_name),1,26) || '_id_',35) || ' := NULL;';
                     END IF;
                     out_line_ := Replace_Keyword___(in_line_, key_word_, new_value_);
                     IF ( LTRIM(RTRIM(out_line_)) IS NOT NULL ) THEN
                        Put_Line___(output_, out_line_);
                     END IF;
                  END LOOP;
               ELSIF ( key_word_ = 'CALL_MESSAGE_LINES' ) THEN
                  condition_word_ := 'IF';
                  FOR c2 IN c2_lu (business_object_) LOOP
                     Put_Line___(output_, margin_ || condition_word_ || ' ( c3.lu_name = ''' || c2.lu_name || ''' ) THEN ');
                     Put_Line___(output_, margin_ || '   ' || c2.lu_name || '___(message_id_, message_line_,');
                     Put_Line___(output_, margin_ || '      c2.receiver, c1.replication_group, c3.lu_name,');
                     Put_Line___(output_, margin_ || '      c3.operation, c3.key_values, c3.key_rowid,');
                     Put_Line___(output_, margin_ || '      c3.business_object_version, ' || SUBSTR(LOWER(c2.view_name),1,26) || '_id_' || ',');
                     Put_Line___(output_, margin_ || '      send_warning_, send_info_, receive_warning_, receive_info_);');
                     condition_word_ := 'ELSIF';
                  END LOOP;
                  Put_Line___(output_, margin_ || 'END IF;');
               ELSIF ( key_word_ = 'CREATE_MESSAGE_LINES' ) THEN
                  index_ := Load_Lines___(in_line_, key_word_, table_);
                  Create_Message___(table_, business_object_, index_);
               ELSIF ( key_word_ = 'CREATE_LOAD_CURSOR' ) THEN
                  index_ := Load_Lines___(in_line_, key_word_, table_);
                  Create_Load___(table_, business_object_, index_);
               ELSIF ( key_word_ = 'CREATE_LOAD_INSTRUCTION' ) THEN
                  index_ := Load_Lines___(in_line_, key_word_, table_);
                  Create_Load___(table_, business_object_, index_);
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  end_of_file_ := TRUE;
               WHEN OTHERS THEN
                  RAISE;
            END;
         END LOOP;
         count_ := count_ + 1;
         Close_All___;
      END LOOP;
   EXCEPTION
      WHEN OTHERS THEN
         Close_All___;
         RAISE;
   END Create_Send_Package___;

   PROCEDURE Create_Trigger___ (
      business_object_ IN     VARCHAR2,
      template_cre_    IN OUT VARCHAR2,
      out_file_cre_    IN OUT VARCHAR2 )
   IS
      table_           table_type;
      end_of_file_     BOOLEAN := FALSE;
      in_line_         VARCHAR2(2000);
      out_line_        VARCHAR2(2000);
      key_word_        VARCHAR2(100);
      new_value_       VARCHAR2(2000);
      index_           BINARY_INTEGER;
      margin_          VARCHAR2(120);
   BEGIN
      create_type_ := 'TRG';
      template_    := Open_File___(template_cre_, 'R');
      output_      := Open_File___(out_file_cre_, 'W');
      WHILE NOT end_of_file_ LOOP
         BEGIN
            Get_Line___(template_, in_line_);
            key_word_ := Find_Keyword___(in_line_);
            IF ( key_word_ IS NOT NULL ) THEN
               margin_ := RPAD(' ', (INSTR(in_line_,'<<<') - 1));
            ELSE
               margin_ := NULL;
            END IF;
            IF ( NVL(key_word_, 'KEY WORD') NOT IN ('LOOP_CREATE_BEFORE_TRIGGER',
                                                    'LOOP_CREATE_AFTER_TRIGGER',
                                                    'LOOP_ADD_DATE_COLUMN') ) THEN
               IF ( key_word_ IS NULL ) THEN
                  new_value_ := NULL;
               ELSIF ( key_word_ = 'SYSDATE' ) THEN
                  new_value_ := TO_CHAR(sysdate, 'yy-mm-dd');
               ELSIF ( key_word_ = 'BO' ) THEN
                  new_value_ := business_object_;
               ELSE
                  new_value_ := key_word_;
               END IF;
               out_line_ := Replace_Keyword___(in_line_, key_word_, new_value_);
               IF ( LTRIM(RTRIM(out_line_)) IS NOT NULL ) THEN
                  Put_Line___(output_, out_line_);
               END IF;
            ELSIF ( key_word_ = 'LOOP_CREATE_BEFORE_TRIGGER' ) THEN
               index_ := Load_Lines___(in_line_, key_word_, table_);
               Create_Before_Trigger___(table_, business_object_, index_);
            ELSIF ( key_word_ = 'LOOP_CREATE_AFTER_TRIGGER' ) THEN
               index_ := Load_Lines___(in_line_, key_word_, table_);
               Create_After_Trigger___(table_, business_object_, index_);
            ELSIF ( key_word_ = 'LOOP_ADD_DATE_COLUMN' ) THEN
               index_ := Load_Lines___(in_line_, key_word_, table_);
               Add_Date_Column___(table_, business_object_, index_);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               end_of_file_ := TRUE;
            WHEN OTHERS THEN
               RAISE;
         END;
      END LOOP;
      Close_All___;
   EXCEPTION
      WHEN OTHERS THEN
         Close_All___;
         RAISE;
   END Create_Trigger___;

   PROCEDURE Create_File__ (
      type_            IN VARCHAR2,
      business_object_ IN VARCHAR2 )
   IS
      wrong_type_      EXCEPTION;
      arg1_            VARCHAR2(1) := NULL;
      arg2_            VARCHAR2(1) := NULL;
      arg3_            VARCHAR2(1) := NULL;
      arg4_            VARCHAR2(1) := NULL;
   BEGIN
      IF ( UPPER(type_) NOT IN ('SEND','RECEIVE','TRIGGER') ) THEN
         RAISE wrong_type_;
      END IF;
      package_api_        := empty_tab_;
      package_apy_        := empty_tab_;
      package_index_api_  := 1;
      package_index_apy_  := 1;
      template_index_api_ := 1;
      template_index_apy_ := 1;
      use_table_          := TRUE;
      IF    ( UPPER(type_) = 'SEND' )    THEN Create_Send_Package___   (business_object_, arg1_, arg2_, arg3_, arg4_);
      ELSIF ( UPPER(type_) = 'RECEIVE' ) THEN Create_Receive_Package___(business_object_, arg1_, arg2_, arg3_, arg4_);
      ELSIF ( UPPER(type_) = 'TRIGGER' ) THEN Create_Trigger___        (business_object_, arg1_, arg2_);
      ELSE                               NULL;
      END IF;
      use_table_ := FALSE;
   EXCEPTION
      WHEN wrong_type_ THEN
         Error_SYS.Appl_General(lu_name_, 'UNKNOWNTYPE: Unknown type :P1.', type_);
   END Create_File__;


   PROCEDURE Export_File__ (
      type_ IN OUT VARCHAR2,
      file_ IN OUT CLOB )
   IS
      text_out_         CLOB := NULL;
      text_line_        VARCHAR2(2000);
      wrong_type_       EXCEPTION;
   BEGIN
      IF ( type_ IS NOT NULL ) THEN
         export_type_ := UPPER(type_);
         IF ( export_type_  = 'APY' )            THEN 
            package_index_apy_ := 1;
         ELSIF ( export_type_ IN ('API','TRG') ) THEN 
            package_index_api_ := 1;
         ELSE                                         
            RAISE wrong_type_;
         END IF;
         type_ := NULL;
      END IF;
      BEGIN
         LOOP
            IF ( export_type_ = 'APY' ) THEN text_line_ := package_apy_(package_index_apy_);
            ELSE                             text_line_ := package_api_(package_index_api_);
            END IF;
            text_out_ := text_out_ || text_line_ || cr_ || nl_;
            IF ( export_type_ = 'APY' ) THEN package_index_apy_ := package_index_apy_ + 1;
            ELSE                             package_index_api_ := package_index_api_ + 1;
            END IF;
         END LOOP;
      EXCEPTION
         WHEN no_data_found THEN
            type_ := NULL;
            file_ := text_out_;
         WHEN wrong_type_ THEN
            Error_SYS.Appl_General(lu_name_, 'UNKNOWNPACKAGE: Unknown package type :P1.', export_type_);
      END;
   END Export_File__;

   PROCEDURE Load_Template__ (
      type_     IN OUT VARCHAR2,
      template_ IN OUT VARCHAR2 )
   IS
      wrong_type_   EXCEPTION;
      to_much_      EXCEPTION;
      start_        NUMBER;
      end_          NUMBER;
      chr#_         NUMBER;
   BEGIN
      IF ( type_ IS NOT NULL ) THEN
         template_type_ := UPPER(type_);
         IF    ( template_type_ IN ('API','TRG') ) THEN
            template_api_       := empty_tab_;
            template_index_api_ := 1;
         ELSIF ( template_type_ =  'APY' )         THEN
            template_apy_       := empty_tab_;
            template_index_apy_ := 1;
         ELSE
            RAISE wrong_type_;
         END IF;
         type_ := NULL;
      END IF;
      IF ( (template_index_api_ > 25000) OR (template_index_apy_ > 25000) ) THEN
         RAISE to_much_;
      END IF;
      IF ( SUBSTR(template_,LENGTH(template_), 1) != nl_ ) THEN
         template_ := template_ || nl_;
      END IF;
      end_ := INSTR(template_, nl_, 1) - 1;
      IF ( end_ > 0 ) THEN
         IF ( (ASCII(SUBSTR(template_, end_, 1)) < 32 )           AND
              (ASCII(SUBSTR(template_, end_, 1)) != ASCII(nl_)) ) THEN
            cr_ := SUBSTR(template_, end_, 1);
         END IF;
      END IF;
      start_ := 1;
      end_   := INSTR(template_, nl_, start_);
      chr#_  := end_ - start_;
      WHILE ( start_ < LENGTH(template_) ) LOOP
         IF ( (template_index_api_ > 25000) OR (template_index_apy_ > 25000) ) THEN
            RAISE to_much_;
         END IF;
         IF ( template_type_ = 'APY' ) THEN
            template_apy_(template_index_apy_) := SUBSTR(template_, start_, chr#_);
            template_index_apy_ := template_index_apy_ + 1;
         ELSIF ( template_type_ IN ('API','TRG') ) THEN
            template_api_(template_index_api_) := SUBSTR(template_, start_, chr#_);
            template_index_api_ := template_index_api_ + 1;
         ELSE
            RAISE wrong_type_;
         END IF;
         start_ := end_ + 1;
         end_   := INSTR(template_, nl_, start_);
         chr#_  := end_ - start_;
      END LOOP;
   EXCEPTION
      WHEN wrong_type_ THEN
         Error_SYS.Appl_General(lu_name_, 'UNKNOWNTEMPLATE: Unknown template type :P1.', template_type_);
      WHEN to_much_ THEN
         Error_SYS.Appl_General(lu_name_, 'OUTOFCONTROL: Running out of control.');
   END Load_Template__;

   FUNCTION Get_Next_From_Attr (
      attr_  IN     CLOB,
      ptr_   IN OUT NUMBER,
      value_ IN OUT VARCHAR2 ) RETURN BOOLEAN
   IS
      from_  NUMBER;
      to_    NUMBER;
   BEGIN
      from_ := nvl(ptr_, 1);
      to_   := instr(attr_, CHR(10), from_);
      IF (to_ > 0) THEN
         value_  := substr(attr_, from_, to_-from_);
         ptr_   := to_+1;
         RETURN(TRUE);
      ELSE
         RETURN(FALSE);
      END IF;
   END Get_Next_From_Attr;

BEGIN
   object_type_ := obj_type_;
   ptr_ := NULL;
   template_rec_ := Fnd_Code_Template_API.Get_Template(template_name_);
   WHILE (Get_Next_From_Attr(template_rec_, ptr_, value_)) LOOP
      Load_Template__(object_type_, value_);
   END LOOP;
   Create_File__(action_, business_object_);
   object_type_ := obj_type_;
   out_rec_ := NULL;
   Export_File__ (object_type_, out_rec_);
   RETURN out_rec_;
END Load_Create_Export__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


