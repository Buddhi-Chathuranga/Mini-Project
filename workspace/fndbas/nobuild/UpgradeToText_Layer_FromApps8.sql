-----------------------------------------------------------------------------
-- File    : UpgradeToTextApps8
--
-- Purpose : This script will convert App8 or earlier terms to App10 text and move App8 Text to App10
-----------------------------------------------------------------------------

-- Creating a database link to App8 enviornment

   create database link TERMS
      connect to IFSAPP identified by ifsapp
      using '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=<host>)(PORT=<port>)))(CONNECT_DATA=(SERVICE_NAME=<service name>)))';      
-- Example 
--  '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=lkpgse32)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=d2708)))';


-- Getting Data containing clobs from App8 or earlier database

BEGIN
   DBMS_OUTPUT.put_line('Start: Creating Temp Tables');
   execute immediate 'create table temp_term_usage_def_tab as select term_id, usage_id, version_handling_id, basic_text from term_usage_definition_tab@terms';   
   commit;  
   execute immediate 'create table temp_term_trans_def_tab as select term_id, usage_id, language_code, translated_basic_text,entity_state from term_translated_definition_tab@terms';
   commit;
   DBMS_OUTPUT.put_line('End: Creating Temp Tables');
END; 


-- Moving Term and Text translations to App10

DECLARE 
   
   input_lang_code_     VARCHAR2(100) := 'sv'; -- ex: 'sv'
   input_component_     VARCHAR2(100) := 'ORDER'; -- ex: 'PURCH'
   input_main_type_     VARCHAR2(100) := NULL;--'RWC'; -- ex: 'RWC'   
   replace_layer1_      VARCHAR2(10)  := '_Cust_.';
   replace_layer2_      VARCHAR2(10)  := '_Cust.';
   
   TYPE a10_array    IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
   TYPE a200_array   IS TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
   TYPE a2000_array  IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;
   TYPE a4000_array  IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
   TYPE number_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
      
   TYPE Term_Translation_Rec IS RECORD (
      translated_text_   varchar2(2000),
      basic_text_        CLOB,
      status_            varchar2(10),
      usage_status_      varchar2(10)
   );
   
   TYPE Text_Translation_Rec IS RECORD (
      translated_text_   varchar2(2000),
      prog_text_         varchar2(2000),
      status_            varchar2(10)
   );
   
   term_translation_rec_  Term_Translation_Rec;
   text_translation_rec_  Text_Translation_Rec;
   
   text_translation_ varchar2(2000);
   
   
   lang_code_arr_ a10_array;
   component_arr_ a10_array;

   context_id_array_             number_array;
   path_array_                   a2000_array;
   main_type_array_              a200_array;
   attribute_id_array_           number_array;
   name_array_                   a2000_array;
   prog_text_array_              a4000_array;
   term_usage_version_id_array_  a200_array;
   display_name_type_array_      a200_array;
   exclude_from_doc_array_       number_array;
   no_term_connection_array_     number_array;
   translation_array_            a4000_array;

   fetch_limit_                  NUMBER := 2000;
   a_id_                         language_attribute_tab.attribute_id%TYPE := 0;


   CURSOR get_lang_code (input_lang_code_ VARCHAR2) IS
      SELECT lang_code
      FROM   language_code_tab
      WHERE  lang_code = nvl(input_lang_code_,lang_code)
      AND    status = 'A'
      UNION
      SELECT 'en' FROM dual;  -- 'en' was added to migrate Prog Text changes

   CURSOR get_component (input_component_ VARCHAR2) IS
      SELECT module
      FROM   module_tab
      WHERE  module = nvl(input_component_,module)
      AND    NVL(version, '*') != '*'
      ORDER  BY module;
       
   CURSOR get_term_data___ (component_ VARCHAR2, input_main_type_ VARCHAR2) IS
      SELECT ctx.context_id,
             ctx.path, 
             ctx.main_type,
             atr.attribute_id,
             atr.name,
             atr.prog_text,
             t8_atr.term_usage_version_id,
             t8_atr.display_name_type,
             t8_atr.exclude_from_documentation,
             t8_atr.no_term_connection
       FROM  language_context_tab ctx,
             language_attribute_tab atr,             
             LANGUAGE_CONTEXT_TAB@TERMS t8_ctx,
             LANGUAGE_ATTRIBUTE_TAB@TERMS t8_atr
       WHERE ctx.context_id = atr.context_id
       and   t8_ctx.context_id = t8_atr.context_id 
       and   ctx.module = t8_ctx.module
       and   ctx.main_type = t8_ctx.main_type
       and   ctx.sub_type = t8_ctx.sub_type
       and   replace(replace(ctx.path, replace_layer1_, '_.'), replace_layer2_, '.') = t8_ctx.path -- remove layer from the path
       and   atr.name = t8_atr.name        
       and   NVL(t8_atr.connection_complete,0) = 1       
       and   ctx.module = nvl(component_,ctx.module)
       AND   ctx.main_type =  nvl(input_main_type_,ctx.main_type)
       AND   ctx.obsolete <> 'Y'
       AND   ctx.context_id = atr.context_id
       AND   atr.obsolete <> 'Y';
      

   CURSOR get_text_data___ (component_ VARCHAR2, input_main_type_ VARCHAR2) IS   
      SELECT ctx.context_id,
             ctx.path, 
             ctx.main_type,
             atr.attribute_id,
             atr.name,
             atr.prog_text  
      FROM   language_context_tab ctx,
             language_attribute_tab atr
      WHERE  ctx.context_id = atr.context_id
      AND    ctx.module = nvl(component_,ctx.module)
      AND    ctx.main_type =  nvl(input_main_type_,ctx.main_type)
      AND    ctx.obsolete <> 'Y'      
      AND    atr.obsolete <> 'Y'       
      AND    (ctx.main_type not in ('JAVA' ,'SO' ,'LU' ,'RWC' ,'MT', 'BI')  OR
             (ctx.main_type='JAVA' and ctx.sub_type != 'Data Field') OR
             (ctx.main_type='RWC' and ctx.sub_type != 'Data Field') OR
             (ctx.main_type='SO' and ctx.sub_type not in ('Column', 'Data Field', 'Check Box',
             'Custom Control', 'Combo Box', 'Radio Button', 'Picture', 'Multiline Field', 'List Box')) OR
             (ctx.main_type='LU' and ctx.sub_type != 'Column'));

   FUNCTION Get_Space_Near_Position___ (
      line_break_   IN NUMBER,
      text_         IN VARCHAR2 ) RETURN NUMBER
   IS
      index_           NUMBER := 0;
      index_next_      NUMBER := 0;
      index_prev_      NUMBER := 0;
      temp_            VARCHAR2(2000);
      pos_             NUMBER := 0;
   BEGIN
      index_ := INSTR(text_, CHR(32));

      IF index_ <= 0 THEN
         RETURN -1;
      END IF;

      IF index_ = line_break_ THEN
         RETURN index_;
      END IF;

      IF LENGTH(text_) <= line_break_ THEN
         RETURN index_;
      END IF;

      index_next_ := INSTR(text_, CHR(32), line_break_);
      temp_ := SUBSTR(text_, 0, line_break_);

      -- Get Last Index Of CHR(32) in temp_
      pos_ := 1;
      
      WHILE INSTR(temp_, CHR(32), pos_) > 0  LOOP
         index_prev_ := INSTR(temp_, CHR(32), pos_);
         pos_ := pos_ + 1;
      END LOOP;

      IF index_next_ <= 0 THEN
         RETURN index_prev_;
      END IF;

      IF index_prev_ <= 0 THEN
         RETURN index_next_;
      END IF;

      -- Return Closest To Line Break
      IF (index_next_ - line_break_) <= (line_break_ - index_prev_) THEN
         RETURN index_next_;
      END IF;

      RETURN index_prev_;
   END Get_Space_Near_Position___;

   FUNCTION Format_Line_Break___ (
      text_        IN VARCHAR2,
      prog_text_   IN VARCHAR2,
      main_type_   IN VARCHAR2 ) RETURN VARCHAR2
   IS
      include_break_  BOOLEAN := FALSE;
      check_string_   VARCHAR2(10);
      substitute_     VARCHAR2(10) := '';
      break_position_ NUMBER := 0;
      space_position_ NUMBER := 0;
      temp_text_      VARCHAR2(2000);
      temp_prog_      VARCHAR2(2000);
      return_text_    VARCHAR2(2000);
   BEGIN
      IF (main_type_ = 'RWC') THEN
         check_string_ := CHR(10);
      ELSE
         check_string_ := CHR(13)||CHR(10);
      END IF;

      break_position_ := INSTR(prog_text_, check_string_);

      IF break_position_ > 0 THEN
         include_break_ := TRUE;
      ELSE
         check_string_ := '<br>';
         break_position_ := INSTR(prog_text_, check_string_);
         IF break_position_ > 0 THEN
            include_break_ := TRUE;
         END IF;
      END IF;

      IF include_break_ = FALSE THEN
         -- No line breaks needs to be added
         RETURN text_;
      END IF;

      substitute_ := check_string_;

      IF INSTR(text_, check_string_) > 0 THEN
         -- Line breaks already exists in the translated text, do nothing
         RETURN text_;
      END IF;


      temp_text_ := text_;
      temp_prog_ := prog_text_;
      return_text_ := '';

      -- Add Line Breaks
      WHILE break_position_ > 0 LOOP
         space_position_ := Get_Space_Near_Position___(break_position_, temp_text_);

         IF space_position_ > 0 THEN
            return_text_ := return_text_ || SUBSTR(temp_text_, 0, space_position_-1) || substitute_;
            temp_text_ := SUBSTR(temp_text_, space_position_+1);
         ELSE
            RETURN return_text_ || temp_text_;
         END IF;

         temp_prog_ := SUBSTR(temp_prog_, break_position_ + 1);
         break_position_ := INSTR(temp_prog_, check_string_);
      END LOOP;
      RETURN return_text_ || temp_text_;
   END Format_Line_Break___;

   FUNCTION Clob_To_V2___(
      clob_                     IN CLOB,
      term_version_handling_id_ IN VARCHAR2) RETURN VARCHAR2
   IS      
      max_length_   PLS_INTEGER := 2000; -- Table column allows 4000 characters, but the client only allows 2000 characters
      l_            PLS_INTEGER;
      offset_       PLS_INTEGER := 1;
   BEGIN
      l_ := NVL(DBMS_LOB.GETLENGTH(clob_),0);
      IF (l_ = 0) THEN
         RETURN NULL;
      END IF;
      IF(l_>max_length_) THEN
         RETURN 'FIELD DESCRIPTION EXCEEDS THE MAXIMUM LENGTH ALLOWED,PLEASE REWRITE'|| chr(13)||chr(10)||chr(13)||chr(10)||
         'Term Version Handling ID: '|| term_version_handling_id_; -- term_versiona_handling_id_ is provided to make it easier to locate App9 Term Usage      
      END IF;
      l_ := LEAST(l_, max_length_);
      RETURN(RTRIM(DBMS_LOB.SUBSTR(clob_, l_, offset_),CHR(13)||CHR(10)));
   END Clob_To_V2___;

   FUNCTION Get_Term_Translation___(
      lang_code_             IN VARCHAR2,
      prog_text_             IN VARCHAR2,
      main_type_             IN VARCHAR2,
      term_usage_version_id_ IN VARCHAR2,
      display_type_          IN VARCHAR2,
      exclude_from_doc_      IN NUMBER) RETURN Term_Translation_Rec
   IS
      translated_text_  varchar2(2000);
      status_           varchar2(10);
      usage_status_     varchar2(10);
      term_             varchar2(200);
      display_name_     varchar2(2000);
      usage_id_         varchar2(100);
      basic_text_       CLOB;
      translatable_     NUMBER;
      language_code_    VARCHAR2(20);
      term_translation_rec_  Term_Translation_Rec;

      CURSOR get_display_name IS
         SELECT d.display_name, d.term_id, t.translatable, u.basic_text, u.usage_id
           FROM term_display_name_tab@TERMS d,
                term_tab@TERMS t,
                temp_term_usage_def_tab u
         WHERE  t.term_id = d.term_id
           AND  t.term_id = u.term_id
           AND  u.version_handling_id = term_usage_version_id_
           AND  d.display_type = display_type_
           AND  t.entity_state != 'Obsolete';

      CURSOR get_translation IS
         SELECT translated_text,DECODE(entity_state,'Translated','O','Revised','C','O') status
           FROM term_translated_name_tab@TERMS
          WHERE term_id = term_     
            AND language_code = language_code_
            AND display_type = display_type_
            AND translated_text IS NOT NULL;

      CURSOR get_usage_translation IS
         SELECT translated_basic_text,DECODE(entity_state,'Translated','O','Revised','C','O') status
         FROM  temp_term_trans_def_tab
         WHERE term_id = term_ 
         AND   usage_id = usage_id_
         AND   language_code = language_code_
         AND   translated_basic_text IS NOT NULL;

   BEGIN       
      language_code_ := Language_Code_API.Get_Lang_Code_Rfc3066(lang_code_);
      OPEN get_display_name;     
      FETCH get_display_name INTO display_name_, term_, translatable_, basic_text_, usage_id_;     
      IF get_display_name%NOTFOUND THEN
         CLOSE get_display_name;
         RETURN NULL;
      END IF;
      CLOSE get_display_name;    
      -- Record Exists, now check if it's translatable
      IF ((NVL(translatable_, 0) = 0) AND (lang_code_!='en')) THEN
         RETURN NULL;
      -- If lang_code 'en', check if there exist any reason to add display name as 'en' translation.
      ELSIF (lang_code_='en' AND prog_text_ != display_name_) THEN
         translated_text_ := display_name_;
         status_ := 'O';
      ELSE
      -- Get Translation
         OPEN get_translation;
         FETCH get_translation INTO translated_text_,status_;
         CLOSE get_translation;
      END IF;

      IF (translated_text_ IS NOT NULL) THEN
         translated_text_ := Format_Line_Break___ (translated_text_, prog_text_, main_type_);
         IF (lang_code_='ar') THEN
            -- Check and add colon
            IF ((prog_text_ LIKE '%:') AND translated_text_ NOT LIKE ':%') THEN
               translated_text_ := ':' || translated_text_;
            END IF;
            -- Check and add ...
            IF ((prog_text_ LIKE '%...') AND translated_text_ NOT LIKE '...%') THEN
               translated_text_ := '...' || translated_text_;
            END IF;
         ELSE
            -- Check and add colon
            IF ((prog_text_ LIKE '%:') AND translated_text_ NOT LIKE '%:') THEN
               translated_text_ := translated_text_ || ':';
            END IF;
         END IF;
      END IF;

      IF (replace(prog_text_, ' ', '') = replace(translated_text_, ' ', '') AND lang_code_ = 'en') THEN
         translated_text_ := NULL;
      END IF;

      -- Check if Usage should be returned.
      IF (main_type_ = 'RWC' OR main_type_ = 'MT') THEN
         IF (exclude_from_doc_ = 1) THEN
            basic_text_ := NULL;
         ELSIF (lang_code_ != 'en') THEN
            -- Get Usage Translation
            basic_text_ := NULL;
            OPEN get_usage_translation;
               FETCH get_usage_translation 
            INTO  basic_text_,usage_status_;
            CLOSE get_usage_translation;
         END IF;
      ELSE
         basic_text_ := NULL;
      END IF;

      term_translation_rec_.translated_text_ := translated_text_;
      term_translation_rec_.status_ := status_;
      term_translation_rec_.basic_text_ := basic_text_;
      term_translation_rec_.usage_status_ := usage_status_;
     
      RETURN term_translation_rec_;
      
   END Get_Term_Translation___;

   FUNCTION Get_Text_Translation___(
      lang_code_             IN VARCHAR2,
      path_                  IN VARCHAR2)RETURN Text_Translation_Rec
   IS
      CURSOR get_text_translation IS
         SELECT prog_text,text,status
         FROM LANGUAGE_TEXT_TRANSLATION@TERMS
         WHERE lang_code = lang_code_     
         AND path = path_        
         AND text IS NOT NULL;
      text_ VARCHAR2(2000);
      prog_text_ VARCHAR2(2000);
      status_ VARCHAR2(10);
      text_translation_rec_  Text_Translation_Rec;
   BEGIN
      OPEN get_text_translation;
      FETCH get_text_translation INTO prog_text_,text_,status_;
      CLOSE get_text_translation; 
      
      text_translation_rec_.translated_text_       := text_;
      text_translation_rec_.prog_text_ := prog_text_;
      text_translation_rec_.status_ := status_;
   
      RETURN text_translation_rec_;
              
   END Get_Text_Translation___;

BEGIN
   -- If no lang_code given as input, run update for all records on all active languages.
   OPEN get_lang_code(input_lang_code_);
   FETCH get_lang_code BULK COLLECT INTO lang_code_arr_;
   CLOSE get_lang_code;
  
   -- If no component given as input, run update for all records on defined language code.
   OPEN get_component(input_component_);
   FETCH get_component BULK COLLECT INTO component_arr_;
   CLOSE get_component;
   
   DBMS_OUTPUT.put_line('Copy Translation: Started!' );
   
   FOR comp_ IN Nvl(component_arr_.FIRST,1)..Nvl(component_arr_.LAST,-1) LOOP -- BEGIN component loop
     
     DBMS_OUTPUT.put_line('## Module - ' || component_arr_(comp_)  );
     
     BEGIN --**loop through term translations
        DBMS_OUTPUT.put_line('Copy Term Translations : Started!');
        OPEN get_term_data___(component_arr_(comp_), input_main_type_); 
        LOOP
           FETCH get_term_data___ BULK COLLECT
              INTO context_id_array_, path_array_, main_type_array_, attribute_id_array_, name_array_, prog_text_array_, term_usage_version_id_array_, display_name_type_array_, exclude_from_doc_array_, no_term_connection_array_ LIMIT fetch_limit_;
             
           IF path_array_.count > 0 THEN
              
              FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP -- Loop through contexts
                 
                 FOR lang_ IN Nvl(lang_code_arr_.FIRST,1)..Nvl(lang_code_arr_.LAST,-1) LOOP -- Loop through all the languages
                                        
                    DBMS_OUTPUT.put_line('## Language - ' || lang_code_arr_(lang_)  );                      
                    BEGIN                                                
                       IF (term_usage_version_id_array_(rec_) IS NOT NULL AND no_term_connection_array_(rec_) = 0) THEN --** has a term usage                           
                          -- Translation and basic text from Term.
                          term_translation_rec_ := Get_Term_Translation___(lang_code_arr_(lang_), prog_text_array_(rec_), main_type_array_(rec_),term_usage_version_id_array_(rec_), display_name_type_array_(rec_), exclude_from_doc_array_(rec_));                             
                              
                          -- If lang code=en the attribute should be updated with the usage, not as translation
                          IF (lang_code_arr_(lang_) = 'en' AND term_translation_rec_.basic_text_ IS NOT NULL) THEN
                             Language_Attribute_API.Refresh_(a_id_, context_id_array_(rec_), name_array_(rec_), prog_text_array_(rec_), 'TRUE', Clob_To_V2___(term_translation_rec_.basic_text_,term_usage_version_id_array_(rec_)));
                             term_translation_rec_.basic_text_ := NULL;                            
                          END IF;                            
                              
                          -- If translation exist, insert the translation, if Term Display Name and Prog Text is differ en entry will be inserted
                          IF (term_translation_rec_.translated_text_ IS NOT NULL) THEN                           
                             Language_Translation_API.Refresh_( attribute_id_array_(rec_), lang_code_arr_(lang_), term_translation_rec_.translated_text_, term_translation_rec_.status_);                                                            
                             term_translation_rec_.translated_text_ := NULL;
                          END IF;
                              
                          -- If usage translation exist (not 'en'), insert the translation
                          IF (term_translation_rec_.basic_text_ IS NOT NULL AND lang_code_arr_(lang_) != 'en') THEN                                 
                             Language_Translation_API.Refresh_Usage_( attribute_id_array_(rec_), lang_code_arr_(lang_), Clob_To_V2___(term_translation_rec_.basic_text_,term_usage_version_id_array_(rec_)),term_translation_rec_.usage_status_);
                             term_translation_rec_.basic_text_ := NULL;
                          END IF;
                       END IF;
                       COMMIT;
                    EXCEPTION
                    -- In case of unexpected error, continue with next file.
                       WHEN OTHERS THEN
                          DBMS_OUTPUT.put_line('An error was encountered while copying: '||component_arr_(comp_)||' '||path_array_(rec_)||' '||prog_text_array_(rec_)||' '||lang_code_arr_(lang_));
                          DBMS_OUTPUT.put_line('Error '|| SQLCODE || '-' || SUBSTR(SQLERRM, 1, 2000));
                          ROLLBACK;
                    END;                   
                 END LOOP;                  
              END LOOP;
           END IF;
      
           EXIT WHEN get_term_data___%NOTFOUND;
        END LOOP;
        CLOSE get_term_data___;
           COMMIT;
      EXCEPTION
      -- In case of unexpected error, continue with next file.
         WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('An error was encountered while processing: '||comp_);
            DBMS_OUTPUT.put_line('Error '|| SQLCODE || '-' || SUBSTR(SQLERRM, 1, 2000));
            ROLLBACK;
      END;
      DBMS_OUTPUT.put_line('Copy Term Translations : Completed!');
      
      BEGIN --**loop through text translations
         DBMS_OUTPUT.put_line('Copy Text Translations : Started!');
         OPEN get_text_data___(component_arr_(comp_), input_main_type_); 
            LOOP
               FETCH get_text_data___ BULK COLLECT
                  INTO context_id_array_, path_array_, main_type_array_, attribute_id_array_, name_array_, prog_text_array_ LIMIT fetch_limit_;
            
               IF path_array_.count > 0 THEN                 
                  FOR rec_ IN Nvl(path_array_.first, 0)..Nvl(path_array_.last, -1) LOOP -- loop through contexts
                    
                     FOR lang_ IN Nvl(lang_code_arr_.FIRST,1)..Nvl(lang_code_arr_.LAST,-1) LOOP   -- loop through languages
                                              
                        DBMS_OUTPUT.put_line('## Language - ' || lang_code_arr_(lang_)  );                     
                        BEGIN                                                
                           text_translation_rec_:= Get_Text_Translation___(lang_code_arr_(lang_), path_array_(rec_)); -- get existing translation                                                               
                           -- If translation exist, copy
                           IF (text_translation_rec_.translated_text_ IS NOT NULL) THEN
                              Language_Translation_API.Refresh_( attribute_id_array_(rec_), lang_code_arr_(lang_), text_translation_rec_.translated_text_, text_translation_rec_.status_,text_translation_rec_.prog_text_); -- add/modify translation to the new enviornment
                              text_translation_rec_.translated_text_ := NULL; 
                              text_translation_rec_.prog_text_ := NULL;
                              text_translation_rec_.status_ := NULL;                                                             
                           END IF;                                                  
                        EXCEPTION
                        -- In case of unexpected error, continue with next file.
                           WHEN OTHERS THEN
                              DBMS_OUTPUT.put_line('Problems when copying: '||component_arr_(comp_)||' '||path_array_(rec_)||' '||prog_text_array_(rec_)||' '||lang_code_arr_(lang_));
                              ROLLBACK;                                 
                        END;
                     END LOOP;
                     COMMIT;
                  END LOOP;
               END IF;      
               EXIT WHEN get_text_data___%NOTFOUND;
            END LOOP;
         CLOSE get_text_data___;
         COMMIT;
      EXCEPTION
      -- In case of unexpected error, continue with next component.
         WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('Problems when processing: '||comp_);
            ROLLBACK;
      END;
      DBMS_OUTPUT.put_line('Copy Text Translations : Completed!');
   END LOOP; -- END component loop 
   DBMS_OUTPUT.put_line('Copy Translation: Completed!' );
END;
/

-- Dropping temperary tables once the migration is done ( uncomment and run )
BEGIN
   DBMS_OUTPUT.put_line('Start: Drop Temp Tables');
   execute immediate 'DROP TABLE temp_term_usage_def_tab';
   execute immediate 'DROP TABLE temp_term_trans_def_tab';
   DBMS_OUTPUT.put_line('Finish: Drop Temp Tables');
END; 
/


