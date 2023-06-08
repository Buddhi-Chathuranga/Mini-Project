-----------------------------------------------------------------------------
--
--  Logical unit: LanguageTranslationUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030317  ROOD    Replaced General_SYS.Put_Line with Trace_SYS.Put_Line (ToDo#4143).
--  040331  HAAR    Unicode bulk changes, replaced Chr expression with constant string (F1PR408B).
--  040407  HAAR    Unicode bulk changes, 
--                  extended define variable length in Copy_Module_ and Replace_(F1PR408B).
--  050815  RAKU    Added asciistr in Copy_Module_ (F1PR408E).
--  060302  STDA    Added asciistr in Translate_Prog_Text__ and in Translate_All_Text__ (F1PR480).
--  070307   STDA    Removed obsolete code (F1PR496).
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK  Merged Rose Documentation
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Replace_Extended___ (
   num_replacements_ OUT NUMBER,
   text_ IN VARCHAR2,
   search_for_ IN VARCHAR2,
   replace_with_ IN VARCHAR2,
   match_case_ IN BOOLEAN,
   match_whole_word_ IN BOOLEAN,
   brake_chars_ IN VARCHAR2 DEFAULT ' ' ) RETURN VARCHAR2
IS
   new_text_         VARCHAR2(2000);
   start_            NUMBER;
   end_              NUMBER;
   last_end_         NUMBER;
   old_part_         VARCHAR2(2000);
   new_part_         VARCHAR2(2000);
   prev_char_        VARCHAR2(1);
   next_char_        VARCHAR2(1);
   counter_  NUMBER;
   tries_    NUMBER;
BEGIN
   --
   -- Replace all occurances
   new_text_ := '';
   start_    := 1;
   last_end_ := 1;
   --
   -- Find first occurance
   IF match_case_ THEN
      start_ := instr( text_, search_for_ );
   ELSE
      start_ := instr( upper(text_), upper(search_for_) );
   END IF;
   --
   tries_   := 0;
   counter_ := 0;
   WHILE ( start_ > 0  AND (counter_ < 5) ) LOOP
      --
      -- Find start of text plus previous and next character
      end_   := start_ + length( search_for_ );
      old_part_ := substr( text_, start_, length( search_for_ ));
      IF start_ > 1 THEN
         prev_char_ := substr( text_, start_ -1, 1);
      ELSE
         prev_char_ := NULL;
      END IF;
      IF end_ < length( text_ ) THEN
         next_char_ := substr( text_, end_, 1 );
      ELSE
         next_char_ := NULL;
      END IF;
      --
      -- Perform replacement
      IF match_case_ THEN
         new_part_  := replace_with_;
      ELSIF old_part_ = lower(search_for_) THEN
         new_part_ := lower(replace_with_ );
      ELSIF old_part_ = upper( search_for_ ) THEN
         new_part_ := upper(replace_with_);
      ELSIF old_part_ = initcap(search_for_) THEN
         new_part_ := initcap(replace_with_);
      END IF;
      --
      -- Only make replacement if correct brake characters or we are not using word matching
      IF ( ( NOT match_whole_word_ )
         OR ( ( prev_char_ IS NULL OR instr( brake_chars_, prev_char_ ) > 0 )
         AND ( next_char_ IS NULL OR instr( brake_chars_, next_char_ ) > 0 ) ) )
      THEN
         new_text_ := new_text_ || substr( text_, last_end_, (start_ - last_end_ ) ) || new_part_;
         counter_ := counter_ + 1;
      ELSE
         new_text_ := new_text_ || substr( text_, last_end_, (start_ - last_end_ ) ) || old_part_;
      END IF;
      --
      tries_ := tries_ + 1;
      --
      -- Find next occurance
      IF match_case_ THEN
         start_ := instr( text_, search_for_, 1, tries_ + 1 );
      ELSE
         start_ := instr( upper(text_), upper(search_for_), 1, tries_  + 1  );
      END IF;
      last_end_ := end_;
   END LOOP;
   --
   new_text_ := new_text_ || substr( text_, last_end_, length( text_ ) - last_end_ + 1 );
   num_replacements_ := counter_;
   RETURN( new_text_ );
END Replace_Extended___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Suggest__ (
   text_      OUT VARCHAR2,
   module_    IN  VARCHAR2,
   main_type_ IN  VARCHAR2,
   sub_type_  IN  VARCHAR2,
   attribute_ IN  VARCHAR2,
   prog_text_ IN  VARCHAR2,
   lang_code_ IN  VARCHAR2,
   context_id_ IN  VARCHAR2,
   quit_       IN  VARCHAR2 )
IS
   temp_                 VARCHAR2(2000);
   main_type_db_         VARCHAR2(50);
   record_separator_     VARCHAR2(5) := chr(29);
   int_prog_text_        VARCHAR2(2000);
   counter_              NUMBER;
   MUSTQUIT              EXCEPTION;
   
CURSOR typed_in_module_any IS
      SELECT DISTINCT text
      FROM language_context_tab ctx, language_attribute_tab atr, language_translation_tab tra
      WHERE ctx.context_id = atr.context_id
      AND atr.attribute_id = tra.attribute_id
      AND ((ctx.module = module_ ) 
         OR module IN ( SELECT source_component
                       FROM language_connection
                       WHERE destination_component = module_ ))
      AND tra.lang_code = lang_code_
      AND atr.prog_text_short = int_prog_text_;

   CURSOR typed_in_module IS
      SELECT DISTINCT text
      FROM language_context_tab ctx, language_attribute_tab atr, language_translation_tab tra
      WHERE ctx.context_id = atr.context_id
      AND atr.attribute_id = tra.attribute_id
      AND ((ctx.module = module_ ) 
         OR module IN ( SELECT source_component
                       FROM language_connection
                       WHERE destination_component = module_ ))
      AND ctx.main_type = main_type_db_
      AND ctx.sub_type = sub_type_
      AND atr.name = attribute_
      AND tra.lang_code = lang_code_
      AND atr.prog_text_short = int_prog_text_;
   
   CURSOR any_at_all IS
      SELECT DISTINCT text
      FROM language_translation_tab tra, language_attribute_tab atr
      WHERE tra.attribute_id = atr.attribute_id
      AND tra.lang_code = lang_code_
      AND atr.prog_text_short = int_prog_text_;
  
BEGIN
   Trace_SYS.Message('Trying to find suggestion for ' || prog_text_);
   counter_ := 0;
   --
   main_type_db_ := Language_Context_Main_Type_API.Encode( main_type_ );
   IF main_type_db_ IS NULL THEN
      main_type_db_ := '[Any]';
   END IF;
   --
   
   int_prog_text_ := prog_text_;
 
   --
   -- Try to find a translation of a totally identical item in the
   -- same module or any module connection
   FOR rec IN typed_in_module LOOP
      IF (rec.text IS NOT NULL) THEN
          temp_ := temp_||rec.text||record_separator_;
          Trace_SYS.Put_Line('Found totally identical text in module');
          counter_ := counter_ + 1;
          IF ((quit_ = 'TRUE') OR (counter_ > 10)) THEN
             RAISE MUSTQUIT;
          END IF;   
      END IF; 
   END LOOP; 

   --
   -- Try to find a translation of a item in the
   -- same module or any module connection
   FOR rec IN typed_in_module_any LOOP
      IF (rec.text IS NOT NULL) THEN
          temp_ := temp_||rec.text||record_separator_;
          Trace_SYS.Put_Line('Found typed text in module');
          counter_ := counter_ + 1;
          IF ((quit_ = 'TRUE') OR (counter_ > 10)) THEN
             RAISE MUSTQUIT;
          END IF;
      END IF; 
   END LOOP;
    
   --
   -- Try to find any match in the module language table
   --
   FOR rec IN any_at_all LOOP
      IF (rec.text IS NOT NULL) THEN
          temp_ := temp_||rec.text||record_separator_;
          Trace_SYS.Put_Line('Found text somewhere else in the database');
          counter_ := counter_ + 1;
          IF ((quit_ = 'TRUE') OR (counter_ > 10)) THEN
             RAISE MUSTQUIT;
          END IF;
      END IF; 
   END LOOP;

   text_:= temp_;
EXCEPTION
   WHEN MUSTQUIT THEN
      text_ := temp_;  
END Suggest__;


-- Translate_Prog_Text__
--   The TranslateProgText function automtically automatically translates all
--   attributes with the specified prog text.
PROCEDURE Translate_Prog_Text__ (
   result_ OUT VARCHAR2,
   module_ IN VARCHAR2,
   lang_code_ IN VARCHAR2,
   prog_text_ IN VARCHAR2,
   translation_ IN VARCHAR2,
   mode_        IN NUMBER DEFAULT 0 ) 
IS
   CURSOR attributes_ IS
      SELECT a.attribute_id, a.prog_text
      FROM language_context c, language_attribute a
      WHERE a.context_id = c.context_id
      AND c.module = module_
      AND a.prog_text = prog_text_
      AND Language_Translation_API.Get_Text( a.attribute_id, lang_code_ ) IS NULL;

   CURSOR attributes_LOC_ IS
      SELECT a.attribute_id, a.prog_text
      FROM language_context c, language_attribute a, language_translation_loc l
      WHERE a.context_id = c.context_id
      AND c.module = module_
      AND a.prog_text = prog_text_
      AND Language_Translation_API.Get_Text( a.attribute_id, lang_code_ ) IS NULL
      AND l.attribute_id = a.attribute_id
      AND l.module = c.module
      AND l.lang_code = lang_code_;

   CURSOR attributes_TEMPL_ IS
      SELECT a.attribute_id, a.prog_text
      FROM language_context c, language_attribute a
      WHERE a.context_id = c.context_id
      AND a.prog_text = prog_text_
      AND Language_Translation_API.Get_Text( a.attribute_id, lang_code_ ) IS NULL
      AND c.sub_type = 'Company Template'
      AND c.main_type_db = 'LU'
      AND substr(c.path,1,instr(c.path,'.')-1) = module_;  -- module_ = Name of template

   counter_ NUMBER;
   translation_asciistr_ VARCHAR2(2000) := Database_Sys.Asciistr(translation_);
BEGIN
   --
   -- Clear client info
   counter_ := 0;
   Client_SYS.Clear_Info;
   --
   -- Copy translation to all attributes with identical prog_text
   IF (mode_ = 1) THEN
      FOR attribute IN attributes_LOC_ LOOP
         Language_Translation_API.Refresh_( attribute.attribute_id, lang_code_, translation_asciistr_, 'O' );
       counter_ := counter_ + 1;
      END LOOP;
   ELSIF (mode_ = 2) THEN
      FOR attribute IN attributes_TEMPL_ LOOP
         Language_Translation_API.Refresh_( attribute.attribute_id, lang_code_, translation_asciistr_, 'O' );
         counter_ := counter_ + 1;
      END LOOP;
   ELSE
      FOR attribute IN attributes_ LOOP
         Language_Translation_API.Refresh_( attribute.attribute_id, lang_code_, translation_asciistr_, 'O' );
         counter_ := counter_ + 1;
      END LOOP;
   END IF;
   --
   -- Clear client info
   Client_SYS.Add_Info( lu_name_, 'TRANALL: :P1 texts were translated.', to_char( counter_ ) );
   result_ := Client_SYS.Get_All_Info;

END Translate_Prog_Text__;


-- Translate_All_Text__
--   Added by R and M:
--   The TranslateAllText function automtically translates all empty attributes
--   using the Suggest functionality.
PROCEDURE Translate_All_Text__ (
   result_ OUT VARCHAR2,
   module_ IN VARCHAR2,
   lang_code_ IN VARCHAR2,
   context_id_ IN VARCHAR2,
   mode_       IN NUMBER DEFAULT 0 )
IS
   CURSOR attributes_ IS
      SELECT a.attribute_id, a.prog_text, c.main_type, c.sub_type, a.name
      FROM language_context c, language_attribute a
      WHERE a.context_id = c.context_id
      AND c.module = module_
      AND a.prog_text IS NOT NULL
      AND Language_Translation_API.Get_Text( a.attribute_id, lang_code_ ) IS NULL;

   CURSOR attributes_LOC_ IS
      SELECT a.attribute_id, a.prog_text, c.main_type, c.sub_type, a.name
      FROM language_context c, language_attribute a, language_translation_loc l
      WHERE a.context_id = c.context_id
      AND c.module = module_
      AND a.prog_text IS NOT NULL
      AND Language_Translation_API.Get_Text( a.attribute_id, lang_code_ ) IS NULL
      AND l.attribute_id = a.attribute_id
      AND l.module = c.module
      AND l.lang_code = lang_code_;

   counter_ NUMBER;
   translation_     VARCHAR2(2000);
   text_            VARCHAR2(2000);
BEGIN
   --
   -- Clear client info
   counter_ := 0;
   Client_SYS.Clear_Info;
   --
   -- Enter a suggestion for all untranslated texts.
   IF (mode_ = 1) THEN
      FOR x IN attributes_LOC_ LOOP
         text_ := null;
         Suggest__(text_, module_, x.main_type, x.sub_type, x.name, x.prog_text, lang_code_, context_id_, 'TRUE');
         IF (text_ IS NOT NULL) THEN
            -- The text will always come with a record separator.
            translation_ := Database_Sys.Asciistr(SUBSTR(text_, 1, instr(text_, chr(29)) - 1));
            Language_Translation_API.Refresh_( x.attribute_id, lang_code_, translation_, 'A' );
            counter_ := counter_ + 1;
         END IF;
      END LOOP;
   ELSE
       FOR x IN attributes_ LOOP
          text_ := null;
          Suggest__(text_, module_, x.main_type, x.sub_type, x.name, x.prog_text, lang_code_, context_id_, 'TRUE');
          IF (text_ IS NOT NULL) THEN
             -- The text will always come with a record separator.
             translation_ := Database_Sys.Asciistr(SUBSTR(text_, 1, instr(text_, chr(29)) - 1));
             Language_Translation_API.Refresh_( x.attribute_id, lang_code_, translation_, 'A' );
             counter_ := counter_ + 1;
          END IF;
       END LOOP;
   END IF;
   --
   -- Add to client info
   Client_SYS.Add_Info( lu_name_, 'TRANALL: :P1 texts were translated.', to_char( counter_ ) );
   result_ := Client_SYS.Get_All_Info;
END Translate_All_Text__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Copy_Module_
--   The CopyModule function copies translation between two
--   languages (or prog and one language) in the specified module.
--   A extra where-clause may optionally be specified.
PROCEDURE Copy_Module_ (
   result_     OUT VARCHAR2,
   module_     IN  VARCHAR2,
   lang_from_  IN  VARCHAR2,
   lang_to_    IN  VARCHAR2,
   overwrite_  IN  VARCHAR2 DEFAULT 'FALSE',   
   user_prefix_ IN VARCHAR2 DEFAULT NULL,
   user_suffix_ IN VARCHAR2 DEFAULT NULL)
IS
   cursor_       NUMBER;
   stmt_         VARCHAR2(2000);
   stmt_select_  VARCHAR2(2000);
   stmt_from_    VARCHAR2(2000);
   stmt_where_   VARCHAR2(2000);
   attribute_id_ NUMBER;
   prog_text_    VARCHAR2(2000);
   text_         VARCHAR2(2000);
   sub_type_     VARCHAR2(50);
   dummy_        NUMBER;
   counter_      NUMBER;
BEGIN
   --
   -- Parameter validation
   IF lang_from_ <> 'PROG' THEN
      Language_Code_API.Exist( lang_from_ );
   END IF;
   Language_Code_API.Exist( lang_to_ );
   IF (module_ = '' ) THEN
      Error_SYS.Appl_General( lu_name_, 'INVPARAM: Invalid parametrs' );
   END IF;
   --
   -- Clear client info
   Client_SYS.Clear_Info;
   --
   -- Build fetch statements                   
   IF lang_from_ = 'PROG' THEN
      stmt_select_   := 'SELECT DISTINCT ATTRIBUTE_ID, Database_SYS.Asciistr(PROG_TEXT), Database_SYS.Asciistr(PROG_TEXT), SUB_TYPE ';
      stmt_from_     := 'FROM LANGUAGE_TRANSLATION_EXP ';
      stmt_where_    := 'WHERE MODULE = :module_ ';
   ELSE
      stmt_select_   := 'SELECT ATTRIBUTE_ID, Database_SYS.Asciistr(PROG_TEXT), Database_SYS.Asciistr(TEXT), SUB_TYPE ';
      stmt_from_     := 'FROM LANGUAGE_TRANSLATION_EXP ';
      stmt_where_    := 'WHERE MODULE = :module_ AND TEXT IS NOT NULL AND LANG_CODE = :lang_from_ ';
   END IF;
   --
   -- Build complete fetch statement
   stmt_ := stmt_select_ || stmt_from_ || stmt_where_ ;
   --
   -- Open dynamic SQL cursor and parse statement
   cursor_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2014-08-29,haarse)
   dbms_sql.parse( cursor_, stmt_, dbms_sql.native );
   --
   -- Bind variables in WHERE clause
   IF lang_from_ = 'PROG' THEN
      dbms_sql.bind_variable( cursor_, 'module_', module_ );
   ELSE
      dbms_sql.bind_variable( cursor_, 'module_', module_ );
      dbms_sql.bind_variable( cursor_, 'lang_from_', lang_from_ );
   END IF;
   --
   -- Define output colums
   dbms_sql.define_column( cursor_, 1, attribute_id_ );
   dbms_sql.define_column( cursor_, 2, prog_text_, 20000 );
   dbms_sql.define_column( cursor_, 3, text_, 20000 );
   dbms_sql.define_column( cursor_, 4, sub_type_, 500 );
   --
   -- Execute dynamic sql
   dummy_ := dbms_sql.execute( cursor_ );
   --
   -- Fetch all rows
   counter_ := 0;
   WHILE ( dbms_sql.fetch_rows( cursor_ ) > 0 ) LOOP
      --
      -- Bind column values
      dbms_sql.column_value( cursor_, 1, attribute_id_ );
      dbms_sql.column_value( cursor_, 2, prog_text_ );
      dbms_sql.column_value( cursor_, 3, text_ );
      dbms_sql.column_value( cursor_, 4, sub_type_ );
      --
      IF length(text_) > 0 THEN
         IF sub_type_ IN ('Iid Element', 'State') THEN 
            IF (length(user_prefix_||user_suffix_) <= length(text_)) THEN
               text_ := user_prefix_ || substr(text_, 1, length(text_) - length(user_prefix_||user_suffix_)) || user_suffix_;
            END IF;
         ELSE
            text_ := user_prefix_ || text_ || user_suffix_;
         END IF;
         IF overwrite_ = 'TRUE' THEN
            Language_Translation_API.Refresh_( attribute_id_, lang_to_, text_, 'A' );
            counter_ := counter_ + 1;
         ELSE
            IF Language_Translation_API.Get_Status_Db( attribute_id_, lang_to_ ) = 'N' THEN
               Language_Translation_API.Refresh_( attribute_id_, lang_to_, text_, 'A' );
               counter_ := counter_ + 1;
            END IF;
         END IF;
      END IF;
   END LOOP;
   --
   -- Clear client info0
   dbms_sql.close_cursor( cursor_ );
   --
   -- Clear client info1
   Client_SYS.Add_Info( lu_name_, 'TRANSCOPY: :P1 translations were copied.', to_char( counter_ ) );
   result_ := Client_SYS.Get_All_Info;
END Copy_Module_;


-- Replace_
--   The Replace method performs search and replace for translations in a module.
--   An extra where-clause limiting what texts are serach may optionally be specified.
PROCEDURE Replace_ (
   result_           OUT VARCHAR2,
   module_           IN  VARCHAR2,
   lang_code_        IN  VARCHAR2,
   search_for_       IN  VARCHAR2,
   replace_with_     IN  VARCHAR2,
   match_whole_word_ IN  VARCHAR2,
   match_case_       IN  VARCHAR2,
   user_word_brakes_ IN  VARCHAR2,
   user_where_       IN  VARCHAR2,
   mode_       IN  NUMBER DEFAULT 0 )
IS
   cursor_       NUMBER;
   stmt_         VARCHAR2(2000);
   stmt_select_  VARCHAR2(2000);
   stmt_from_    VARCHAR2(2000);
   stmt_where_   VARCHAR2(2000);
   attribute_id_ NUMBER;
   text_         VARCHAR2(2000);
   new_text_     VARCHAR2(2000);
   word_brakes_  VARCHAR2(10);
   dummy_        NUMBER;
   counter_      NUMBER;
   num_replaced_ NUMBER;
BEGIN
   --
   -- Parameter validation
   Language_Code_API.Exist( lang_code_ );
   IF (module_ = '' OR search_for_ = '' ) THEN
      Error_SYS.Appl_General( lu_name_, 'INVPARAM: Invalid parametrs' );
   END IF;
   --
   -- Use default word break characters if user has not supplied any
   IF (user_word_brakes_ = '') OR (user_word_brakes_ IS NULL) THEN
      word_brakes_ := ' ';
   ELSE
      word_brakes_ := user_word_brakes_;
   END IF;
   --
   -- Clear client info
   Client_SYS.Clear_Info;
   counter_ := 0;
   --
   -- Build fetch statements
   stmt_select_   := 'SELECT ATTRIBUTE_ID, TEXT ';
   IF (mode_ = 1) THEN
      stmt_from_     := 'FROM LANGUAGE_TRANSLATION_LOC ';
   ELSE
      stmt_from_     := 'FROM LANGUAGE_TRANSLATION_EXP ';
   END IF;
   stmt_where_    := 'WHERE TEXT IS NOT NULL AND MODULE = :module_ AND LANG_CODE = :lang_code_ ' ||
   '  AND instr(upper(TEXT), upper(:search_for_)) > 0 ';
   --
   -- Build complete fetch statement
   stmt_ := stmt_select_ || stmt_from_ || stmt_where_ || Assert_SYS.Encode_Single_Quote_String(user_where_);
   --
   -- Open dynamic SQL cursor and parse statement
   cursor_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2014-08-29,haarse)
   dbms_sql.parse( cursor_, stmt_, dbms_sql.native );
   --
   -- Bind variables in WHERE clause
   dbms_sql.bind_variable( cursor_, 'module_', module_ );
   dbms_sql.bind_variable( cursor_, 'lang_code_', lang_code_ );
   dbms_sql.bind_variable( cursor_, 'search_for_', search_for_ );
   --
   -- Define output colums
   dbms_sql.define_column( cursor_, 1, attribute_id_ );
   dbms_sql.define_column( cursor_, 2, text_, 20000 );
   --
   -- Execute dynamic sql
   dummy_ := dbms_sql.execute( cursor_ );
   --
   -- Fetch all rows
   counter_ := 0;
   WHILE ( dbms_sql.fetch_rows( cursor_ ) > 0 ) LOOP
      --
      -- Use default word break characters if user has not supplied any0
      dbms_sql.column_value( cursor_, 1, attribute_id_ );
      dbms_sql.column_value( cursor_, 2, text_ );
      --
      -- Use default word break characters if user has not supplied any1
      new_text_ := Replace_Extended___( num_replaced_, text_, search_for_, replace_with_,
      (match_case_ = 'TRUE'), (match_whole_word_ = 'TRUE'), word_brakes_ );
      IF num_replaced_ > 0 THEN
         UPDATE language_translation_tab
            SET text = new_text_
            WHERE attribute_id = attribute_id_ AND lang_code = lang_code_;
         counter_ := counter_ + num_replaced_;
      END IF;
   END LOOP;
   -- Use default word break characters if user has not supplied any2
   dbms_sql.close_cursor( cursor_ );
   --
   -- Use default word break characters if user has not supplied any3
   Client_SYS.Add_Info( lu_name_, 'REPLACE: :P1 replacements where made.', to_char( counter_ ) );
   result_ := Client_SYS.Get_All_Info;
END Replace_;


-- Check_Memonics_
--   The CheckMemonics functions checks for conflicts in memonics in menus
--   and/or windows.
PROCEDURE Check_Memonics_ (
   result_ OUT VARCHAR2,
   attribute_ IN NUMBER,
   memonic_ IN VARCHAR2 )
IS
BEGIN
   NULL;
END Check_Memonics_;

PROCEDURE Import_Mobile_Translations(
    layer_   IN  VARCHAR2)
IS
   context_path_ VARCHAR2(500);
   lang_code_    VARCHAR2(10);
   current_status_ VARCHAR2(20);

   CURSOR get_attributes_ IS
      SELECT ctx.path,atr.attribute_id 
      FROM LANGUAGE_CONTEXT_TAB ctx,LANGUAGE_ATTRIBUTE_TAB atr
      WHERE ctx.context_id = atr.context_id
      AND ctx.main_type = 'MOBILE'
      AND ctx.sub_type = 'Column'
      AND ctx.layer = layer_
      AND ctx.obsolete = 'N';
   CURSOR translation_(attribute_id_ NUMBER,lang_code_ VARCHAR2) IS
      SELECT status
      FROM LANGUAGE_TRANSLATION_TAB
      WHERE attribute_id = attribute_id_
      AND lang_code = lang_code_;
   $IF Component_Fnddev_SYS.INSTALLED $THEN
      CURSOR get_translations_ (context_path_ VARCHAR2)IS
         SELECT trs.text,trs.lang_code 
         FROM   language_translation_tab trs,
                language_attribute_tab atr,
                language_context_tab ctx
         WHERE  trs.attribute_id = atr.attribute_id
         AND    atr.context_id = ctx.context_id
         AND    ctx.path = context_path_;
   $END
BEGIN
   $IF Component_Fnddev_SYS.INSTALLED $THEN 
      FOR get_attributes_rec_ IN get_attributes_ LOOP 
         context_path_ := Substr(get_attributes_rec_.path, Instr(get_attributes_rec_.path, '.',1,2)+1);
         FOR get_translations_rec_ IN get_translations_(context_path_) LOOP
            lang_code_ :=get_translations_rec_.lang_code;
            OPEN translation_(get_attributes_rec_.attribute_id,lang_code_);
               FETCH translation_ INTO current_status_;
               IF translation_%NOTFOUND THEN                                                         
                  Language_Translation_API.Refresh_(get_attributes_rec_.attribute_id,lang_code_,get_translations_rec_.text,'O');
               END IF;                    
            CLOSE translation_;
         END LOOP;
      END LOOP;
   $ELSE
      NULL; 
   $END
EXCEPTION
   WHEN OTHERS THEN
      Transaction_SYS.Log_Progress_Info('Unexpected error when copying translations'||sqlerrm||'.' );
END Import_Mobile_Translations;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


