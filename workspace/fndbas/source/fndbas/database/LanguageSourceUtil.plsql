-----------------------------------------------------------------------------
--
--  Logical unit: LanguageSourceUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970723  ERFO    Changed WHERE-clause in method Build_Prompts___ concerning
--                  cursor including column condition on 'OBJID' (ToDo #1516).
--  980414  ERFO    Remove limitation of 254 bytes for a PL/SQL line (Bug #2352).
--  980630  DAJO    Fixed bug #2552
--  990222  ERFO    Yoshimura: Changes in Build_Messages___ (ToDo #3160).
--  011122  ROOD    Get use of new view FND_COL_COMMENTS (Bug#26328).
--  011218  STDA    Added Build_Templ_Trans (ToDo#4096).
--  020228  STDA    Changed length of progtext from 500 to 2000 and name
--                  from 50 to 120 (ToDo#4096).
--  020705  ROOD    Updated to new server templates (ToDo#4117).
--  020925  ROOD    Merged fix earlier made by STDA (Bug#14519).
--  020930  STDA    GLOB01E. Move Component Translations to F1.
--  021016  OVJOSE  GLOB01. Added Load_Basic_Data_Translation.
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030317  ROOD    Replaced General_SYS.Put_Line with Trace_SYS.Put_Line (ToDo#4143).
--  030813  HAAR    Changed VARCHAR declarations to VARCHAR2 (ToDo#4278).
--  031010  ROOD    Modified method Build_Prompts___ to use report cache information.
--  031015  ROOD    Avoided empty report titles being found.
--  031024  ROOD    Increased variable length in Message_Position___.
--  040706  ROOD    Modified the usage of Dictionary_SYS (F1PR413).
--  051108  ASWILK  Removed leading spaces before finding the message position in Message_Position___ (Bug#49166).
--  060919  ovjose  Bug 60440 Corrected.
--  070828  LALI    Added new public methods Build_Top_Level_Context,Build_Child_Of_Context,Build_Attribute (Bug#69111)
--  210617  MABALK Scan translatable code show error buffer to small (DUXZREP-562)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Page_Group_Rec IS RECORD(
     page_group   VARCHAR2(100),
     scope_id     VARCHAR2(100)
);

TYPE Page_Group_Tab IS TABLE OF Page_Group_Rec INDEX BY BINARY_INTEGER;

TYPE Translatable_Field_Meta_Rec   IS RECORD(
     sub_type       VARCHAR2(20),
     attribute_name VARCHAR2(200),
     path           VARCHAR2(1000),
     prog_text      VARCHAR2(1000));
TYPE Translatable_Field_Meta_Tab IS TABLE OF Translatable_Field_Meta_Rec INDEX BY BINARY_INTEGER;
-------------------- PRIVATE DECLARATIONS -----------------------------------

field_separator_ CONSTANT VARCHAR2(1) := chr(31);
SOURCE_LU                       CONSTANT VARCHAR2(5) := 'LU';
SOURCE_SS                       CONSTANT VARCHAR2(5) := 'SS';
context_type_global_data_       CONSTANT VARCHAR2(50) := 'Global Data';
context_type_logical_unit_      CONSTANT VARCHAR2(50) := 'Logical Unit';
context_type_message_           CONSTANT VARCHAR2(50) := 'Message';
context_type_iid_element_       CONSTANT VARCHAR2(50) := 'Iid Element';
context_type_view_              CONSTANT VARCHAR2(50) := 'View';
context_type_column_            CONSTANT VARCHAR2(50) := 'Column';
context_type_report_            CONSTANT VARCHAR2(50) := 'Report';
context_type_report_layout_     CONSTANT VARCHAR2(50) := 'Report Layout';
context_type_report_data_       CONSTANT VARCHAR2(50) := 'Report Data';
context_type_report_column_     CONSTANT VARCHAR2(50) := 'Report Column';
context_type_report_constants_  CONSTANT VARCHAR2(50) := 'Report Constants';
context_type_question_          CONSTANT VARCHAR2(50) := 'Question';
context_type_state_             CONSTANT VARCHAR2(50) := 'State';
context_name_messages_          CONSTANT VARCHAR2(50) := 'Messages';
context_name_iid_               CONSTANT VARCHAR2(50) := 'Iid';
context_name_comp_temp_         CONSTANT VARCHAR2(50) := 'Company Template';
context_name_basic_data_        CONSTANT VARCHAR2(50) := 'Basic Data';
attribute_name_text_            CONSTANT VARCHAR2(50) := 'Text';
attribute_name_client_value_    CONSTANT VARCHAR2(50) := 'Client Value';
attribute_name_client_values_   CONSTANT VARCHAR2(50) := 'Client Values';
attribute_name_order_           CONSTANT VARCHAR2(50) := 'Order';
attribute_name_prompt_          CONSTANT VARCHAR2(50) := 'Prompt';
attribute_name_title_           CONSTANT VARCHAR2(50) := 'Title';
attribute_name_query_           CONSTANT VARCHAR2(50) := 'Query';
attribute_name_status_text_     CONSTANT VARCHAR2(50) := 'Status Text';

TYPE Configured_Artifact_Tab       IS TABLE OF CLOB INDEX BY BINARY_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Message_Position___ (
   text_ IN VARCHAR2 ) RETURN NUMBER
IS
   text_upper_ VARCHAR2(32000);
BEGIN
   text_upper_ := ltrim(upper(text_));
   IF (instr(text_upper_, 'ERROR_SYS.APPL_GENERAL') > 0) THEN              --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.APPL_GENERAL');                 --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.RECORD_GENERAL') > 0) THEN         --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.RECORD_GENERAL');               --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.ITEM_GENERAL') > 0) THEN           --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.ITEM_GENERAL');                 --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'NLS_MSG___') > 0) THEN                       --#NOTRANSLATE
      RETURN instr(text_upper_, 'NLS_MSG___');                             --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'LANGUAGE_SYS.TRANSLATE_CONSTANT') > 0) THEN  --#NOTRANSLATE
      RETURN instr(text_upper_, 'LANGUAGE_SYS.TRANSLATE_CONSTANT');        --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'CLIENT_SYS.ADD_INFO') > 0) THEN              --#NOTRANSLATE
      RETURN instr(text_upper_, 'CLIENT_SYS.ADD_INFO');                    --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'CLIENT_SYS.ADD_WARNING') > 0) THEN           --#NOTRANSLATE
      RETURN instr(text_upper_, 'CLIENT_SYS.ADD_WARNING');                 --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.RECORD_NOT_EXIST') > 0) THEN       --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.RECORD_NOT_EXIST');             --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.RECORD_EXIST') > 0) THEN           --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.RECORD_EXIST');                 --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.RECORD_LOCKED') > 0) THEN          --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.RECORD_LOCKED');                --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.RECORD_MODIFIED') > 0) THEN        --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.RECORD_MODIFIED');              --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.RECORD_REMOVED') > 0) THEN         --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.RECORD_REMOVED');               --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.RECORD_CONSTRAINT') > 0) THEN      --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.RECORD_CONSTRAINT');            --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.ITEM_UPDATE') > 0) THEN            --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.ITEM_UPDATE');                  --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.ITEM_INSERT') > 0) THEN            --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.ITEM_INSERT');                  --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.ITEM_UPDATE_IF_NULL') > 0) THEN    --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.ITEM_UPDATE_IF_NULL');          --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.ITEM_UPDATE_IF_NULL') > 0) THEN    --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.ITEM_UPDATE_IF_NULL');          --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.ITEM_FORMAT') > 0) THEN            --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.ITEM_FORMAT');                  --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.ITEM_NOT_EXIST') > 0) THEN         --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.ITEM_NOT_EXIST');               --#NOTRANSLATE
   ELSIF (instr(text_upper_, 'ERROR_SYS.STATE_GENERAL') > 0) THEN          --#NOTRANSLATE
      RETURN instr(text_upper_, 'ERROR_SYS.STATE_GENERAL');                --#NOTRANSLATE
   ELSE
      RETURN 0;
   END IF;
END Message_Position___;


FUNCTION Get_And_Remove_First_Item___ (
   items_ IN OUT VARCHAR2,
   item_  IN OUT VARCHAR2 ) RETURN BOOLEAN
IS
   index_ NUMBER;
   end_   BOOLEAN;
BEGIN
   -- Find out if we have reached the end
   end_ := (length(ltrim(rtrim(items_))) = 0);
   index_ := instr( items_, field_separator_);
   item_ := substr( items_, 1, index_ - 1);
   items_ := substr( items_, index_ + 1, length(items_) - index_ );
   RETURN( NOT end_ );
END Get_And_Remove_First_Item___;


FUNCTION Get_Part_Of_String___ (
   string_    IN VARCHAR2,
   delimiter_ IN VARCHAR2,
   no_        IN NUMBER ) RETURN VARCHAR2
IS
   text_            VARCHAR2(2000);
   start_           NUMBER;
   stop_            NUMBER;
   quotas_           NUMBER;
   char_              VARCHAR2(1);
   length_          NUMBER;
   last_quotas_     NUMBER:=0;
   delimeter_found_ NUMBER:=0;
BEGIN
   -- Find start of desired parameter
   IF no_ > 1 THEN
      start_ := instr( string_, delimiter_, 1, no_ - 1 );
   ELSE
      start_ := 1;
   END IF;
   -- Find stop if succesfull, or return null if not
   IF (start_ <> 0) THEN
      -- Find stop of parameter
      stop_ := start_ + 1;
	   length_ := length(string_);
	   quotas_ := 0; 
      WHILE   (stop_ <= length_) LOOP
         char_ := substr(string_, stop_, 1);                      
		   IF char_ = '''' THEN 
			   quotas_ := quotas_ + 1; 
			   IF (MOD(quotas_, 2) = 0) THEN
			   	last_quotas_ := stop_;
			   END IF;
		   END IF;
		   IF (char_ = delimiter_ AND MOD(quotas_, 2) = 0) THEN 
			   delimeter_found_:=1;
			   EXIT;
		   END IF;
		   stop_ := stop_ + 1;
      END LOOP;
      --
      -- Cut of possible trailing parameters
      text_ :=substr( string_, start_ + 1, stop_ - start_ - 1 );
      IF ((delimeter_found_ = 0) AND (last_quotas_ + 1 = length_)) THEN
	      text_ := substr( string_, start_ + 1, stop_ - start_ - 2 );
      END IF;
   ELSE
      text_ := NULL;
   END IF;
   RETURN (text_);
END Get_Part_Of_String___;


FUNCTION Get_Statement___ (
   package_name_ IN VARCHAR2,
   start_line_   IN NUMBER,
   max_lines_    IN NUMBER ) RETURN VARCHAR2
IS
   text_           user_source.text%TYPE;
   all_text_       VARCHAR2(2000);
   stmt_end_delim_pos_ NUMBER;
   done_           BOOLEAN;
   CURSOR statement_ IS
      SELECT text
      FROM   user_source
      WHERE  type = 'PACKAGE BODY'
      AND  (name = package_name_)
      AND  line >= start_line_
      AND  line <= start_line_ + max_lines_;
BEGIN
   done_ := FALSE;
   OPEN statement_;
   FETCH statement_ INTO text_;
   WHILE ( statement_%FOUND AND NOT done_ ) LOOP
      --
      -- Remove possible carridge return, line feeds etc
      text_ := replace(text_, chr(10), '');
      text_ := replace(text_, chr(13), '');
      --
      -- Remove concatenation characters
      text_ := replace(text_, '||', '');
      --
      -- Append this row to the previous ones
      stmt_end_delim_pos_ := instr(text_, ';', 1);
      IF ( stmt_end_delim_pos_ > 0 ) THEN
         all_text_ := all_text_ || ltrim( substr( text_, 1, stmt_end_delim_pos_ ) );
      ELSE
         all_text_ := all_text_ || rtrim(ltrim(text_));
      END IF;
      done_ := stmt_end_delim_pos_ > 0;
      FETCH statement_ INTO text_;
   END LOOP;
   CLOSE statement_;
   --
   -- remove concatenation characters and double qoutation marks
   all_text_ := replace(all_text_, chr(39) || chr(39), '');
   --   dbms_output.put_line( all_text_ );
   RETURN (all_text_);
END Get_Statement___;


FUNCTION Get_Parameter_Text___ (
   package_name_ IN VARCHAR2,
   start_line_   IN NUMBER,
   parameter_no_ IN NUMBER,
   start_pos_    IN NUMBER ) RETURN VARCHAR2
IS
   all_text_       VARCHAR2(2000);
   start_          NUMBER;
   stop_           NUMBER;
BEGIN
   --
   -- Get statement
   all_text_ := Get_Statement___( package_name_, start_line_, 20 ) ;
   --
   -- extract the part that represents the parameters
   start_    := instr(all_text_, '(', start_pos_);
   stop_     := instr(all_text_, ');', start_);
   all_text_ := rtrim(ltrim(substr(all_text_, start_ + 1, stop_ - ( start_ + 1 ) )));
   --
   -- we now have the whole parameter list, time to retrive the desired parameter
   all_text_ := Get_Part_Of_String___( all_text_, ',', parameter_no_ );
   RETURN (all_text_);
END Get_Parameter_Text___;


PROCEDURE Build_Iid_Elements___ (
   parent_context_ IN Language_Context_API.context_rectype,
   packages_in_    IN VARCHAR2,
   layer_          IN VARCHAR2)
IS
   cf_                VARCHAR2(20);
   context_           Language_Context_API.context_rectype;
   attribute_         Language_Attribute_API.attribute_rectype;
   packages_          VARCHAR2(2000);
   package_name_      VARCHAR2(2000);
   db_value_list_     VARCHAR2(32000);
   client_value_list_ VARCHAR2(32000);
   index_             NUMBER;
   counter_           NUMBER;
   db_index_          NUMBER;
   client_index_      NUMBER;
   db_text_           VARCHAR2(2000);
   client_text_       VARCHAR2(2000);
   null_found_        BOOLEAN;
   found_             BOOLEAN;
   lu_type_           VARCHAR2(30);
BEGIN
   -- Never use customer fitting option
   cf_ := 'N';
   -- Make local copy of package names
   packages_ := packages_in_;
   WHILE (Get_And_Remove_First_Item___( packages_, package_name_ )) LOOP
      --
      -- get db values. If none are found we need to do nothing further
      found_ := TRUE;
      db_value_list_       := NULL;
      client_value_list_   := NULL;
      lu_type_             := NULL;
      DECLARE
         stmt_             VARCHAR2(32000);
         lu_type_not_found EXCEPTION;
         PRAGMA            EXCEPTION_INIT(lu_type_not_found, -6550);

      BEGIN
         Assert_SYS.Assert_Is_Package(package_name_);
         stmt_ := 'DECLARE '||
                  '   lu_type_             VARCHAR2(100);'||
                  'BEGIN '||
                  '   lu_type_ := '||package_name_||'.lu_type_;'||
                  '   IF (lu_type_ IN (''Enumeration'', ''EntityWithState'')) THEN '||
                  '       '||package_name_||'.Init; '||
                  '       :db_values_     := Domain_SYS.Get_Db_Values('||package_name_||'.lu_name_);'||
                  '       :client_values_ := Domain_SYS.Get_Prog_Values('||package_name_||'.lu_name_);'||
                  '       :lu_type_       := lu_type_;'||
                  '   END IF;'||
                  'END;';
         @ApproveDynamicStatement(2011-05-30,krguse)
         EXECUTE IMMEDIATE stmt_ USING OUT db_value_list_, OUT client_value_list_, OUT lu_type_;
      EXCEPTION
         WHEN lu_type_not_found THEN
            NULL;
      END;
      IF db_value_list_ IS NOT NULL THEN
         found_ := TRUE;
      ELSE
         found_ := FALSE;
      END IF;
      --
      -- Only insert contexts when some text was actually found
      IF (found_) THEN
         --
         -- loop through the value lists and insert words
         --
         db_index_     := 1;
         client_index_ := 1;
         counter_      := 1;
         index_ := instr(db_value_list_, '^', db_index_);
         null_found_ := FALSE;
         WHILE (index_ > 0 ) LOOP
            db_text_      := substr(db_value_list_, db_index_, index_ - db_index_);
            db_index_     := index_ + 1;
            index_        := instr(client_value_list_, '^', client_index_);
            client_text_  := substr(client_value_list_, client_index_, index_ - client_index_);
            client_index_ := index_ + 1;
            index_        := instr(db_value_list_, '^', db_index_);
            --
            -- Special considerations if db value is NULL
            IF db_text_ IS NULL THEN
               IF null_found_ THEN
                  Error_SYS.Appl_General( lu_name_, 'MANYNULL: More than one null value in IID' );
               END IF;
               db_text_ := '<NULL>';
               null_found_ := TRUE;
            END IF;
            context_.name     := db_text_;
            IF (lu_type_ = 'Enumeration') THEN
               context_.sub_type := context_type_iid_element_;
            ELSE
               context_.sub_type := context_type_state_;
            END IF;
            --
            -- Refresh iid context
            Language_Context_API.Make_Child_Of_( context_, parent_context_ );
            Language_Context_API.Refresh_( context_.context_id, cf_, context_.name, context_.parent, context_.main_type, context_.sub_type, context_.module, context_.path, layer_ );
            --
            -- Refresh iid order value
            Language_Property_API.Refresh_( context_.context_id, 'Position', counter_ );
            counter_ := counter_ + 1;
            --
            -- Refresh value
            attribute_.context_id := context_.context_id;
            attribute_.name       := attribute_name_text_;
            attribute_.prog_text  := client_text_;
            Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text );
         END LOOP;
      END IF;
   END LOOP;
END Build_Iid_Elements___;


PROCEDURE Build_Prompts___ (
   parent_context_ IN Language_Context_API.context_rectype,
   views_in_       IN VARCHAR2,
   layer_          IN VARCHAR2)
IS
   cf_                   VARCHAR2(20);
   view_context_         Language_Context_API.context_rectype;
   context_              Language_Context_API.context_rectype;
   attribute_            Language_Attribute_API.attribute_rectype;
   view_is_report_       BOOLEAN;
   view_is_report_group_ BOOLEAN;
   views_                VARCHAR2(32000);
   view_name_            VARCHAR2(30);
   text_name_list_       VARCHAR2(4000);
   text_list_            VARCHAR2(32000);
   text_name_            VARCHAR2(50);
   text_                 VARCHAR2(2000);
   column_name_list_     VARCHAR2(32000);
   column_prompt_list_   VARCHAR2(32000);
   column_title_list_    VARCHAR2(32000);
   column_query_list_    VARCHAR2(32000);
   column_status_list_   VARCHAR2(32000);
   column_name_          VARCHAR2(30);
   column_prompt_        VARCHAR2(50);
   column_title_         VARCHAR2(50);
   column_query_         VARCHAR2(50);
   column_status_        VARCHAR2(100);
   layout_name_list_     VARCHAR2(32000);
   layout_title_list_    VARCHAR2(32000);
   layout_name_          VARCHAR2(50);
   layout_title_         VARCHAR2(50);
   --
   -- Cursor to select all columns in regular views that should be translated.
   -- These are all columns except objid and objversion.
   --
   --SOLSETFW
   CURSOR get_column_prompts IS
      SELECT column_name,
             column_prompt
      FROM   dictionary_sys_view_column_act
      WHERE  view_name = view_name_
      AND    column_name NOT IN ('OBJID', 'OBJVERSION', 'OBJSTATE', 'OBJEVENTS', 'OBJKEY');
   --   
   -- Cursor to select all columns for report groups that should be translated.
   -- Reports are fetched from the report cache and thus are not included here.
   --
   CURSOR get_group_columns IS
      SELECT column_name   name,
             comments      comments
      FROM  report_sys_group_column_tab
      WHERE group_name = view_name_;
   
BEGIN
   -- Never user customer fitting option
   cf_ := 'N';
   -- Make local copy of view names
   views_ := views_in_;
   -- Iterate over all views in LU
   WHILE (Get_And_Remove_First_Item___( views_, view_name_ )) LOOP
      --
      -- Check to see if view is a report definition or a report group
      view_is_report_       := upper(substr(view_name_, -4)) = '_REP'; 
      view_is_report_group_ := upper(substr(view_name_, -4)) = '_GRP';

      view_context_.name     := view_name_;
      --
      -- Set correct sub-type depending on whether view is a report definition
      --
      IF view_is_report_ OR view_is_report_group_ THEN
         view_context_.sub_type := context_type_report_;
      ELSE
         view_context_.sub_type := context_type_view_;
      END IF;
      --
      -- Refresh view context
      --
      Language_Context_API.Make_Child_Of_( view_context_, parent_context_ );
      Language_Context_API.Refresh_( view_context_.context_id, cf_,
      view_context_.name, view_context_.parent,
      view_context_.main_type, view_context_.sub_type,
      view_context_.module, view_context_.path, layer_ );
      --
      -- Report views
      --
      IF view_is_report_ THEN
         --
         -- Report title
         --
         attribute_.context_id := view_context_.context_id;
         attribute_.name       := attribute_name_title_;
         attribute_.prog_text  := Report_SYS.Get_Report_Title( view_name_ );
         IF attribute_.prog_text IS NOT NULL THEN
            Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text);
         END IF;
         --
         -- Report columns
         --
         Report_SYS.Enumerate_Report_Columns_(column_name_list_, column_prompt_list_, column_title_list_, column_query_list_, column_status_list_, view_name_);
         WHILE (Get_And_Remove_First_Item___( column_name_list_, column_name_ )) LOOP
            
            context_.name     := column_name_;
            context_.sub_type := context_type_report_column_;
            --
            -- Refresh column context
            --
            Language_Context_API.Make_Child_Of_( context_, view_context_ );
            Language_Context_API.Refresh_( context_.context_id, cf_, context_.name, context_.parent,
            context_.main_type, context_.sub_type, context_.module, context_.path, layer_ );
            
            -- Column prompt
            IF Get_And_Remove_First_Item___(column_prompt_list_, column_prompt_ ) THEN
               attribute_.context_id := context_.context_id;
               attribute_.name       := attribute_name_prompt_;
               attribute_.prog_text  := column_prompt_;
               IF attribute_.prog_text IS NOT NULL THEN
                  Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text );
               END IF;
            END IF;
            
            -- Column title
            IF Get_And_Remove_First_Item___(column_title_list_, column_title_ ) THEN
               attribute_.context_id := context_.context_id;
               attribute_.name       := attribute_name_title_;
               attribute_.prog_text  := column_title_;
               IF attribute_.prog_text IS NOT NULL THEN
                  Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text );
               END IF;
            END IF;

            -- Column query text
            IF Get_And_Remove_First_Item___(column_query_list_, column_query_ ) THEN
               attribute_.context_id := context_.context_id;
               attribute_.name       := attribute_name_query_;
               attribute_.prog_text  := column_query_;
               IF attribute_.prog_text IS NOT NULL THEN
                  Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text );
               END IF;
            END IF;
         
            -- Column status text
            IF Get_And_Remove_First_Item___(column_status_list_, column_status_ ) THEN
               attribute_.context_id := context_.context_id;
               attribute_.name       := attribute_name_status_text_;
               attribute_.prog_text  := column_status_;
               IF attribute_.prog_text IS NOT NULL THEN
                  Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text );
               END IF;
            END IF;
         END LOOP;
         
         --
         -- Refresh report data context (reuse existing variable)
         --
         context_.name     := context_type_report_constants_;
         context_.sub_type := context_type_report_data_;
         Language_Context_API.Make_Child_Of_( context_, view_context_ );
         Language_Context_API.Refresh_( context_.context_id, cf_, context_.name, context_.parent, context_.main_type, context_.sub_type, context_.module, context_.path, layer_ );
         --
         -- Report texts
         --
         Report_SYS.Enumerate_Report_Texts_( text_name_list_, text_list_, view_name_ );
         WHILE (Get_And_Remove_First_Item___( text_name_list_, text_name_ )) LOOP
            IF Get_And_Remove_First_Item___( text_list_, text_ ) THEN
               attribute_.context_id := context_.context_id;
               attribute_.name       := text_name_;
               attribute_.prog_text  := text_;
               Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text );
            END IF;
         END LOOP;
         --
         -- Report layouts
         --
         Report_SYS.Enumerate_Report_Layouts_( layout_name_list_, layout_title_list_, view_name_ );
         WHILE (Get_And_Remove_First_Item___( layout_name_list_, layout_name_ )) LOOP
            IF Get_And_Remove_First_Item___( layout_title_list_, layout_title_ ) THEN
               context_.name     := layout_name_;
               context_.sub_type := context_type_report_layout_;
               Language_Context_API.Make_Child_Of_( context_, view_context_ );
               Language_Context_API.Refresh_( context_.context_id, cf_, context_.name, context_.parent, context_.main_type, context_.sub_type, context_.module, context_.path, layer_ );
               attribute_.context_id := context_.context_id;
               attribute_.name       := attribute_name_title_;
               attribute_.prog_text  := layout_title_;
               Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text );
            END IF;
         END LOOP;
      --
      -- Report groups
      --
      ELSIF view_is_report_group_ THEN
         FOR col IN get_group_columns LOOP
            context_.name     := col.name;
            context_.sub_type := context_type_report_column_; -- Should change?
            --
            -- Refresh column context
            --
            Language_Context_API.Make_Child_Of_( context_, view_context_ );
            Language_Context_API.Refresh_( context_.context_id, cf_, context_.name, context_.parent,
            context_.main_type, context_.sub_type, context_.module, context_.path, layer_ );
            --
            -- Add the column information
            --
            attribute_.context_id := context_.context_id;
            attribute_.name       := attribute_name_query_;
            attribute_.prog_text  := Dictionary_SYS.Comment_Value_('QUERY', col.comments);
            IF attribute_.prog_text IS NOT NULL THEN
               Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text );
            END IF;
            attribute_.context_id := context_.context_id;
            attribute_.name       := attribute_name_status_text_;
            attribute_.prog_text  := Dictionary_SYS.Comment_Value_('STATUS', col.comments);
            IF attribute_.prog_text IS NOT NULL THEN
               Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text );
            END IF;
         END LOOP;

      --
      -- Regular views
      --
      ELSE
         FOR col IN get_column_prompts LOOP
            context_.name     := col.column_name;
/*            context_.sub_type := context_type_column_;
            --
            -- Refresh column context
            Language_Context_API.Make_Child_Of_( context_, view_context_ );
            Language_Context_API.Refresh_( context_.context_id, cf_, context_.name, context_.parent,
            context_.main_type, context_.sub_type, context_.module, context_.path, layer_ );
            --
            -- Add the column information
            --
            attribute_.context_id := context_.context_id;
            attribute_.name       := attribute_name_prompt_;
            attribute_.prog_text  := col.column_prompt;
            IF attribute_.prog_text IS NOT NULL THEN
               Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text );
            END IF;*/
         END LOOP;
      END IF;
   END LOOP;
END Build_Prompts___;


PROCEDURE Build_Messages___ (
   parent_context_ IN Language_Context_API.context_rectype,
   packages_in_    IN VARCHAR2,
   layer_          IN VARCHAR2)
IS
   cf_               VARCHAR2(20);
   context_          Language_Context_API.context_rectype;
   attribute_        Language_Attribute_API.attribute_rectype;
   package_name_     VARCHAR2(2000);
   packages_         VARCHAR2(2000);
   start_line_       user_source.line%TYPE;
   index_            NUMBER;
   parameter_no_     NUMBER;
   all_text_         VARCHAR2(2000);
   message_          VARCHAR2(2000);
   message_key_      VARCHAR2(50);
   message_text_     VARCHAR2(2000);
   row_line_         NUMBER;
   row_text_         VARCHAR2(2000);
   start_pos_        NUMBER;
   --
   -- Select cursor
   CURSOR text_start IS
      SELECT text, line
      FROM   user_source
      WHERE  type = 'PACKAGE BODY'
      AND  ( name = package_name_ )
      and name like '%_RPI'
      AND  instr(text, chr(40)) > 0
      AND ( instr(text, ',') > 0 )
      AND  NOT (upper(substr(ltrim(text), 1, 9)) = 'PROCEDURE')
      AND  NOT (upper(substr(ltrim(text), 1, 8)) = 'FUNCTION')
      AND  NOT (instr( text , '--#NOTRANSLATE') > 0 )
      AND ((instr(upper(text), 'ERROR_SYS') > 0 )
            OR (instr(upper(text), 'CLIENT_SYS') > 0 )              --#NOTRANSLATE
            OR (instr(upper(text), 'NLS_MSG___') > 0 )              --#NOTRANSLATE
            OR (instr(upper(text), 'LANGUAGE_SYS') > 0 ));          --#NOTRANSLATE
BEGIN
   -- Never use customer fitting option
   cf_ := 'N';
   -- Make local copy of package names
   packages_ := packages_in_;
   WHILE (Get_And_Remove_First_Item___( packages_, package_name_ )) LOOP
      --
      -- Find where all error message calls start
      FOR rec IN text_start LOOP
         start_pos_ := Message_Position___( rec.text );
         IF ( start_pos_ > 0 ) THEN
            start_line_ := rec.line;
            row_line_   := rec.line;
            row_text_   := rec.text;
            --
            -- Find what parameter is the error text
            IF ( ( instr(upper(rec.text), 'ERROR_SYS.ITEM_GENERAL') > 0 )                 --#NOTRANSLATE
               OR ( instr(upper(rec.text), 'ERROR_SYS.ITEM_INSERT') > 0 )                 --#NOTRANSLATE
               OR ( instr(upper(rec.text), 'ERROR_SYS.ITEM_UPDATE') > 0 )                 --#NOTRANSLATE
               OR ( instr(upper(rec.text), 'ERROR_SYS.ITEM_UPDATE_IF_NULL') > 0 ) ) THEN  --#NOTRANSLATE
               parameter_no_ := 3;
            ELSIF (  ( instr(upper(rec.text), 'ERROR_SYS.RECORD_CONSTRAINT') > 0 )        --#NOTRANSLATE
               OR ( instr(upper(rec.text), 'ERROR_SYS.ITEM_FORMAT') > 0 )                 --#NOTRANSLATE
               OR ( instr(upper(rec.text), 'ERROR_SYS.ITEM_NOT_EXIST') > 0 ) ) THEN       --#NOTRANSLATE
               parameter_no_ := 4;
            ELSE
               parameter_no_ := 2;
            END IF;
            all_text_  := Get_Parameter_Text___( package_name_, start_line_, parameter_no_, start_pos_);
            --
            -- Only insert messages that have a length contains two ' characters
            IF ( length( all_text_ ) > 0 ) AND ( instr( all_text_, chr(39) ) > 0 ) THEN
               --
               -- Cleanup text if last character is ) character
               IF (substr(all_text_,length(all_text_)-1) = chr(39)||')') THEN
                 all_text_ := substr(all_text_,1, length(all_text_)-1);
               END IF;
               -- Split message into key and value
               message_       := replace( all_text_, chr(39), '' );
               index_         := instr( message_, ':' );
               message_key_   := rtrim(ltrim( substr( message_, 1, index_ - 1 ) ) );
               message_text_  := rtrim(ltrim( substr( message_, index_ + 1, length( message_ ) - index_ ) ) );
               --
               -- Assign values to a context and connect it to the parent
               context_.name     := message_key_;
               --context_.sub_type := context_type_message_;
               context_.sub_type := 'Report Message';
               Language_Context_API.Make_Child_Of_( context_, parent_context_ );
               Language_Context_API.Refresh_( context_.context_id, cf_, context_.name, context_.parent, context_.main_type, context_.sub_type, context_.module, context_.path, layer_ );
               -- Store attribute
               attribute_.context_id := context_.context_id;
               attribute_.name       := attribute_name_text_;
               attribute_.prog_text  := message_text_;
               Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text );
            END IF;
         END IF;
      END LOOP;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Appl_General(lu_name_, 'MSGERR: Error when building message on line :P1 with text :P2', to_char(row_line_), row_text_ );
END Build_Messages___;


PROCEDURE Build_Basic_Data_Trans___ (
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
      layer_          IN VARCHAR2)
IS
   CURSOR get_lu_trans_data IS
      SELECT module, lu, attribute_key, Nvl(installation_text, text) installation_text
      FROM   basic_data_translation
      WHERE  type = 'Basic Data'
      AND    lang_code = 'PROG'
      AND    module = module_
      AND    lu = lu_;
     
  id_       NUMBER := 0;
  new_id_   NUMBER := 0;
BEGIN
   FOR rec_ IN get_lu_trans_data LOOP
      Build_Templ_Trans( id_,
                         module_,
                         rec_.lu,
                         rec_.attribute_key,
                         'Basic Data',
                         rec_.installation_text,
                         layer_);
      IF ( new_id_ = 0 ) THEN
         new_id_ := id_;         
      END IF;   
      id_ := new_id_;         
   END LOOP;      
   id_ := 0;
END Build_Basic_Data_Trans___;


PROCEDURE Build_Top_Level_Context___(
   context_rec_    IN OUT Language_Context_API.context_rectype,
   layer_          IN VARCHAR2)
IS
   context_id_       NUMBER;
BEGIN
-- Parent=0 at input for the top level context
   IF (NVL(context_rec_.parent,0) = 0) THEN
      -- Get parent context id
      context_id_ := Language_Context_API.Get_Id_( NVL(context_rec_.parent,0), 
                                                   context_rec_.name, 
                                                   context_rec_.main_type, layer_ );
      -- make top level context and all child contexts obsolete 
      IF (context_id_ > 0) THEN
         Language_Context_API.Make_Obsolete_( context_id_, layer_ );
      END IF;
   -- Refresh the top level context
      Language_Context_API.Refresh_( context_rec_.context_id, --out
                                     context_rec_.customer_fitting, 
                                     context_rec_.name, 
                                     context_rec_.parent, 
                                     context_rec_.main_type, 
                                     context_rec_.sub_type, 
                                     context_rec_.module, 
                                     context_rec_.path,
                                     layer_,
                                     context_rec_.bulk );
   END IF;  
END Build_Top_Level_Context___;


PROCEDURE Build_Child_Of_Context___(
   child_context_rec_  OUT    Language_Context_API.context_rectype,
   parent_context_rec_ IN     Language_Context_API.context_rectype,
   child_sub_type_     IN     VARCHAR2,
   child_context_name_ IN     VARCHAR2,
   layer_          IN VARCHAR2,
   name_in_path_       IN     VARCHAR2 DEFAULT NULL)
IS
   child_ctx_rec_  Language_Context_API.context_rectype;
BEGIN
   -- first create a child record based on the current parent
   child_ctx_rec_.sub_type := child_sub_type_;
   child_ctx_rec_.name     := NVL(name_in_path_,child_context_name_);
   Language_Context_API.Make_Child_Of_ (child_ctx_rec_, parent_context_rec_ );
   child_ctx_rec_.name     := child_context_name_;
   -- refresh the new child context
   Language_Context_API.Refresh_( child_ctx_rec_.context_id, --out
                                  child_ctx_rec_.customer_fitting, 
                                  child_ctx_rec_.name, 
                                  child_ctx_rec_.parent, 
                                  child_ctx_rec_.main_type, 
                                  child_ctx_rec_.sub_type, 
                                  child_ctx_rec_.module, 
                                  child_ctx_rec_.path,
                                  layer_,
                                  child_ctx_rec_.bulk );

   child_context_rec_ := child_ctx_rec_;
END Build_Child_Of_Context___;


PROCEDURE Build_Attribute___(
   context_rec_       IN OUT  Language_Context_API.context_rectype,
   attribute_rec_     IN OUT  Language_Attribute_API.attribute_rectype,
   layer_             IN VARCHAR2)
IS
BEGIN
   --Refresh current context
   Language_Context_API.Refresh_( context_rec_.context_id, 
                                  context_rec_.customer_fitting, 
                                  context_rec_.name, 
                                  context_rec_.parent, 
                                  context_rec_.main_type, 
                                  context_rec_.sub_type, 
                                  context_rec_.module, 
                                  context_rec_.path,
                                  layer_,
                                  context_rec_.bulk );          
   -- Refresh attribute context
   --   output context is used as input for the attrtibute
   attribute_rec_.context_id := context_rec_.context_id;
   Language_Attribute_API.Refresh_( attribute_rec_.attribute_id, 
                                    attribute_rec_.context_id, 
                                    attribute_rec_.name, 
                                    attribute_rec_.prog_text );
END Build_Attribute___;

PROCEDURE Make_Context_Obsolete___ ( 
   name_      IN  VARCHAR2,
   main_type_ IN  VARCHAR2,
   layer_     IN  VARCHAR2)
IS
   context_id_ NUMBER;
BEGIN
   context_id_ := Language_Context_API.Get_Id_ (0,name_,main_type_,layer_);
   IF context_id_ >0 THEN
      Language_Context_API.Make_Obsolete_(context_id_,layer_);
   END IF;
END Make_Context_Obsolete___;

FUNCTION Extract_Trans_meta___ (
   label_text_  IN VARCHAR2,
   page_group_  IN VARCHAR2,
   scope_id_    IN VARCHAR2) RETURN Translatable_Field_Meta_Rec
IS   
   trans_meta_ VARCHAR2(2000);
   prog_text_ VARCHAR2(500);
   parent_path_ VARCHAR2(500);
   trans_meta_rec_count_ NUMBER;
   trans_meta_rec_ Utility_Sys.STRING_TABLE;
   translatable_field_meta_rec_ Translatable_Field_Meta_Rec;   
BEGIN
   parent_path_ := '['||scope_id_||'].'||page_group_;
   IF REGEXP_INSTR(label_text_,':CONFIGCLIENT:') > 0 THEN         
      Get_Trans_Meta___(prog_text_,trans_meta_,label_text_);         
      Utility_Sys.Tokenize(trans_meta_,':',trans_meta_rec_,trans_meta_rec_count_);         
      IF trans_meta_rec_count_ > 0 THEN
         translatable_field_meta_rec_.sub_type       := trans_meta_rec_(1);
         translatable_field_meta_rec_.path           := trans_meta_rec_(2);
         translatable_field_meta_rec_.attribute_name := REPLACE(trans_meta_rec_(2),parent_path_||'.','');
         translatable_field_meta_rec_.prog_text      := prog_text_;
      END IF;       
   END IF;
   RETURN translatable_field_meta_rec_;
END Extract_Trans_meta___;

FUNCTION Ext_Artifact_Trans_Fields___(
   artifact_    IN CLOB,
   page_group_  IN VARCHAR2,
   scope_id_    IN VARCHAR2) RETURN Translatable_Field_Meta_Tab
IS
   nth_appearance_ NUMBER := 1;
   label_text_ VARCHAR2(2000);
   translatable_field_meta_tab_  Translatable_Field_Meta_Tab;
   
   PROCEDURE Add_To_List___ (
      tab_ IN OUT NOCOPY Translatable_Field_Meta_Tab,      
      rec_ Translatable_Field_Meta_Rec)
   IS
      rec_count_ NUMBER;
   BEGIN
      rec_count_ := NVL(tab_.count + 1, 1);
      tab_(rec_count_) := rec_;
   END;
   
BEGIN
   LOOP
      label_text_ := REGEXP_SUBSTR(artifact_,'\[#\[translatesys:[^,]*\]#\]',1,nth_appearance_);
      nth_appearance_ := nth_appearance_+1;
      IF REGEXP_INSTR(label_text_,':CONFIGCLIENT:') > 0 THEN         
         Add_To_List___(translatable_field_meta_tab_,Extract_Trans_meta___(label_text_,page_group_,scope_id_));
      END IF;
      EXIT WHEN label_text_ IS NULL;
   END LOOP;
   RETURN translatable_field_meta_tab_;
END Ext_Artifact_Trans_Fields___;

FUNCTION Get_Configured_Artifacts___(
   model_id_ IN VARCHAR2,
   context_  IN VARCHAR2) RETURN Configured_Artifact_Tab
IS
  configured_artifact_list_ Configured_Artifact_Tab;
BEGIN
   SELECT a.content
     BULK COLLECT INTO configured_artifact_list_
     FROM fnd_model_design_data_tab a
    WHERE a.model_id = model_id_       
      AND a.layer_no = 90
      AND a.scope_id = context_;
   RETURN configured_artifact_list_;
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN configured_artifact_list_;
END Get_Configured_Artifacts___;

PROCEDURE Get_Trans_Meta___(   
   prog_text_   OUT VARCHAR2,
   trans_meta_  OUT VARCHAR2,
   label_text_   IN VARCHAR2)
IS
   temp_ VARCHAR2(2000);
BEGIN
   temp_ := REGEXP_SUBSTR(label_text_,'\[#\[translatesys:([^#]+)\]#\]',1,1,NULL,1);
         
   trans_meta_  := SUBSTR(temp_,1,(REGEXP_INSTR(temp_,':',1,4)-1));
   prog_text_ := SUBSTR(temp_,(REGEXP_INSTR(temp_,':',1,4)+1));
END Get_Trans_Meta___;


FUNCTION Get_Page_Config_Trans_Fields___ (
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2) RETURN Translatable_Field_Meta_Tab
IS
   nth_appearance_ NUMBER;
   label_text_ VARCHAR2(2000);
   translatable_field_meta_tab_  Translatable_Field_Meta_Tab;   
   configured_artifact_list_ Configured_Artifact_Tab;

   PROCEDURE Add_To_List___ (
      tab_        IN OUT NOCOPY Translatable_Field_Meta_Tab,      
      rec_        Translatable_Field_Meta_Rec)
   IS
      rec_count_ NUMBER;
   BEGIN
      rec_count_ := NVL(tab_.count + 1, 1);
      tab_(rec_count_) := rec_;
   END;

BEGIN
   -- fetch configured artifacts belongs to the given model from the model_design_data__data_tab
   configured_artifact_list_:= Get_Configured_Artifacts___(model_id_,scope_id_);
   FOR i_ IN 1..configured_artifact_list_.COUNT LOOP
      nth_appearance_ := 1;
      LOOP
         label_text_ := REGEXP_SUBSTR(configured_artifact_list_(i_),'\[#\[translatesys:[^,]*\]#\]',1,nth_appearance_);
         nth_appearance_ := nth_appearance_+1;
         IF REGEXP_INSTR(label_text_,':CONFIGCLIENT:') > 0 THEN         
            Add_To_List___(translatable_field_meta_tab_,Extract_Trans_meta___(label_text_,REGEXP_SUBSTR (model_id_,'[^:]+$'),scope_id_));
         END IF;
         EXIT WHEN label_text_ IS NULL;
      END LOOP;
   END LOOP;
   RETURN translatable_field_meta_tab_;
END Get_Page_Config_Trans_Fields___;

FUNCTION Get_Nav_Config_Trans_Fields___ (
   page_group_ IN VARCHAR2,
   scope_id_   IN VARCHAR2) RETURN Translatable_Field_Meta_Tab
IS
   translatable_field_meta_tab_  Translatable_Field_Meta_Tab; 
   CURSOR get_navigator_labels IS
      SELECT label
        FROM fnd_navigator_entry_tab ne,fnd_navigator_structure_tab ns
       WHERE ne.entry_name = ns.child_entry_name
         AND ne.layer_no = 90
         AND ns.layer_no = 90
         AND ne.scope_id = scope_id_
         AND ns.scope_id = scope_id_
         AND ns.client_origin = page_group_; 

   PROCEDURE Add_To_List___ (
      tab_        IN OUT NOCOPY Translatable_Field_Meta_Tab,      
      rec_        Translatable_Field_Meta_Rec)
   IS
      rec_count_ NUMBER;
   BEGIN
      rec_count_ := NVL(tab_.count + 1, 1);
      tab_(rec_count_) := rec_;
   END;
BEGIN
   FOR navigator_labels_rec_ IN get_navigator_labels LOOP
       Add_To_List___(translatable_field_meta_tab_,Extract_Trans_meta___(navigator_labels_rec_.label,page_group_,scope_id_));
   END LOOP;
   RETURN translatable_field_meta_tab_;
END Get_Nav_Config_Trans_Fields___;


FUNCTION Get_Translatable_Fields___ (   
   page_group_ IN VARCHAR2,
   scope_id_   IN VARCHAR2) RETURN Translatable_Field_Meta_Tab
IS
   page_config_field_meta_tab_  Translatable_Field_Meta_Tab;
   nav_config_field_meta_tab_  Translatable_Field_Meta_Tab;
   translatable_field_meta_tab_  Translatable_Field_Meta_Tab;
BEGIN  
   page_config_field_meta_tab_ := Get_Page_Config_Trans_Fields___('ClientMetadata.client:'||page_group_,scope_id_);   
   nav_config_field_meta_tab_ := Get_Nav_Config_Trans_Fields___(page_group_,scope_id_);   
     
   SELECT * BULK COLLECT INTO translatable_field_meta_tab_ 
   FROM   (SELECT * FROM TABLE(nav_config_field_meta_tab_) UNION SELECT * FROM TABLE(page_config_field_meta_tab_));
   
   RETURN translatable_field_meta_tab_;   
END Get_Translatable_Fields___;

FUNCTION Get_Config_Page_Groups___ (
   model_id_ IN VARCHAR2,
   scope_id_ IN VARCHAR2) RETURN Page_Group_Tab
IS 
   page_group_   VARCHAR2(100);  
   page_group_rec_ Page_Group_Rec;
   page_group_tab_ Page_Group_Tab;  
   page_group_count_ NUMBER :=1;
   
   CURSOR get_page_groups IS
      SELECT DISTINCT client_origin,scope_id
        FROM fnd_navigator_structure_tab
       WHERE layer_no = 90
       UNION 
      SELECT DISTINCT REGEXP_SUBSTR (model_id,'[^:]+$'),scope_id
        FROM fnd_model_design_data_tab
       WHERE layer_no = 90;
BEGIN
   -- Extract page group name from the model id & construct parent path
   IF model_id_ IS NOT NULL THEN
      page_group_ := REGEXP_SUBSTR (model_id_,'[^:]+$');   

      page_group_rec_.page_group := page_group_;
      page_group_rec_.scope_id := scope_id_;
   
      page_group_tab_(page_group_count_) := page_group_rec_;
   ELSE
      FOR page_groups_rec_ IN get_page_groups LOOP
         page_group_rec_.page_group := page_groups_rec_.client_origin;
         page_group_rec_.scope_id := page_groups_rec_.scope_id;      
         page_group_tab_(page_group_count_) := page_group_rec_;
         page_group_count_ := page_group_count_ +1;
      END LOOP;    
   END IF;
   
   RETURN   page_group_tab_;
END Get_Config_Page_Groups___;

FUNCTION Get_Config_Page_Trans_Fields___ (
   model_id_ IN VARCHAR2 DEFAULT NULL,
   scope_id_ IN VARCHAR2 DEFAULT NULL) RETURN Translatable_Field_Meta_Tab
IS   
   configured_artifact_list_ Configured_Artifact_Tab;
BEGIN
   -- fetch configured artifacts belongs to the given model from the model_design_data__data_tab
   configured_artifact_list_:= Get_Configured_Artifacts___(model_id_,scope_id_);   
END Get_Config_Page_Trans_Fields___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Build_Lu__ (
   result_ OUT VARCHAR2,
   name_ IN VARCHAR2,
   full_name_ IN VARCHAR2,
   module_ IN VARCHAR2,
   customer_fitting_ IN VARCHAR2,
   options_ IN VARCHAR2,
   lu_type_ IN VARCHAR2,
   layer_   IN VARCHAR2)
IS
   parent_context_    Language_Context_API.context_rectype;
   context_           Language_Context_API.context_rectype;
   attribute_         Language_Attribute_API.attribute_rectype;
   cf_                VARCHAR2(1);
   views_             VARCHAR2(2000);
   packages_          VARCHAR2(2000);
   group_views_       VARCHAR2(2000);
   group_packages_    VARCHAR2(2000);
   context_id_        NUMBER;
   --layer_             VARCHAR2(100) := 'Core';
BEGIN

   -- Find all packages and views for the LU.
   Dictionary_SYS.Get_Logical_Unit_Views__( name_, views_);
   Dictionary_SYS.Get_Logical_Unit_Packages__( name_, packages_);
   IF lu_type_ != 'SYS' THEN
      Report_SYS.Get_Logical_Unit_Groups( name_, group_views_, group_packages_);
      views_ := views_ || group_views_;
      packages_ := packages_ || group_packages_;
   END IF;
   Trace_SYS.Put_Line('Building ' || name_  );
   Trace_SYS.Put_Line('  Views:    ' || views_ );
   Trace_SYS.Put_Line('  Packages: ' || packages_ );
   --
   -- Initialize context that will be used as parent for all other contexts
   -- in this source
   parent_context_.main_type  := SOURCE_LU;
   parent_context_.module     := module_;
   parent_context_.context_id := 0;
   parent_context_.path       := '';
   context_.sub_type  := context_type_logical_unit_;
   context_.name      := name_;
   cf_                := customer_fitting_;
   Language_Context_API.Make_Child_Of_( context_, parent_context_ );
   --
   IF Dictionary_SYS.Is_Report_Module_Lu(module_, name_) THEN
      -- Make context obsolete
      context_id_ :=  Language_Context_API.Get_Id_( context_.parent, context_.name, SOURCE_LU, layer_ );
      IF context_id_ > 0 THEN
            --Language_Context_API.Make_Obsolete_( context_id_, layer_ );
            Language_Context_API.Make_Report_Obsolete_( context_id_, layer_ );
      END IF;
      --
      -- Write top-level context to database
      Language_Context_API.Refresh_( context_.context_id, cf_, context_.name, context_.parent, context_.main_type, context_.sub_type, context_.module, context_.path, layer_ );
      --
      -- Build attributes for the LU itself.
      attribute_.context_id := context_.context_id;
      attribute_.name       := attribute_name_prompt_;
      attribute_.prog_text  := Dictionary_SYS.Get_Lu_Prompt_( name_ );
      Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, attribute_.prog_text );
      --
      -- Build messages
      Build_Messages___( context_, packages_, layer_ );
      --
      -- Build prompts
      Build_Prompts___( context_, views_, layer_ );
      --
      -- Build Iid elements
      --Build_Iid_elements___( context_, packages_, layer_ );
      --
   END IF;
         
   IF (Basic_Data_Translation_API.Is_Basic_Data_Module_Lu_(module_, name_)) THEN
      -- Build Basic Data Translations
      --Data_Translation_Util_API.Import_Attributes_( module_, name_ );
      Build_Basic_Data_Trans___( module_, name_, layer_ );
   END IF;

END Build_Lu__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Build_Templ_Trans (
   id_             IN OUT NUMBER,
   component_      IN VARCHAR2,
   path_           IN VARCHAR2,
   attribute_key_  IN VARCHAR2,
   sub_type_       IN VARCHAR2,
   text_           IN VARCHAR2)
IS

BEGIN
   Build_Templ_Trans(id_, component_, path_, attribute_key_, sub_type_, text_, 'Core');
     
END Build_Templ_Trans;

   
PROCEDURE Build_Templ_Trans (
   id_             IN OUT NUMBER,
   component_      IN VARCHAR2,
   path_           IN VARCHAR2,
   attribute_key_  IN VARCHAR2,
   sub_type_       IN VARCHAR2,
   text_           IN VARCHAR2,
      layer_          IN VARCHAR2)
IS
   context_          Language_Context_API.context_rectype;
   attribute_        Language_Attribute_API.attribute_rectype;
   cf_               VARCHAR2(1):='N';
   context_id_       NUMBER;
   prog_text_        VARCHAR2(2000);
   name_             VARCHAR2(120);
BEGIN

   context_.main_type            := SOURCE_LU;
   context_.module               := component_;
   context_.customer_fitting     := cf_;
   IF (sub_type_ = context_name_comp_temp_) THEN
      context_.sub_type  := context_name_comp_temp_;
   ELSE
      context_.sub_type  := context_name_basic_data_;
   END IF;
   -- Initialize context that will be used as parent for all other contexts
   -- in this source
   IF (id_ = 0) THEN
      context_.parent            := id_;
      context_.path              := path_||'_'||component_;
      -- Make context obsolete
      context_id_ :=  Language_Context_API.Get_Id_( context_.parent, context_.path, SOURCE_LU, layer_ );
      IF context_id_ > 0 THEN
         Language_Context_API.Make_Obsolete_( context_id_, layer_ );
      END IF;
   -- Write top-level context to database
      name_ := context_.path;
      Language_Context_API.Refresh_( context_.context_id, cf_, name_, context_.parent, context_.main_type, context_.sub_type, context_.module, context_.path, layer_ );
      id_ := context_.context_id;
   END IF;
   name_ := attribute_key_;
   context_.path := path_||'_'||component_||'.'||attribute_key_;
   Language_Context_API.Refresh_( context_.context_id, cf_, name_, id_, context_.main_type, context_.sub_type, context_.module, context_.path, layer_ );

   attribute_.context_id := context_.context_id;
   attribute_.name       := attribute_name_text_;
   prog_text_  := text_;

   Language_Attribute_API.Refresh_( attribute_.attribute_id, attribute_.context_id, attribute_.name, prog_text_ );

END Build_Templ_Trans;


PROCEDURE Load_Basic_Data_Translation (
   module_        IN VARCHAR2,
   lang_code_     IN VARCHAR2 )
IS

dummy_ NUMBER := 0;

CURSOR get_translations IS
      SELECT path, text
      FROM  basic_data_translation
      WHERE lang_code != 'PROG'
      AND   module = module_
      AND   lang_code = lang_code_ ;

CURSOR get_context_id (path_ IN VARCHAR2) IS
      SELECT context_id
      FROM  language_context_tab
      WHERE sub_type = 'Basic Data'
      AND   module = module_
      AND   path = path_;

CURSOR get_attribute_id (context_id_ IN VARCHAR2) IS
      SELECT attribute_id, prog_text
      FROM  language_attribute_tab
      WHERE name = 'Text'
      AND   context_id = context_id_;

BEGIN
      FOR trans_ IN get_translations LOOP
      dummy_:=dummy_+1;
         FOR cnt_ IN get_context_id (trans_.path) LOOP
            FOR attr_ IN get_attribute_id (cnt_.context_id) LOOP
               Language_Translation_API.Refresh_( attr_.attribute_id,
                                                  lang_code_,                                                  
                                                  trans_.text,
                                                  'O');
            END LOOP;      
         END LOOP;      
      END LOOP;      
      IF dummy_ > 1 THEN
         Language_Source_API.Register__( 'Basic Data Translation', 
                                         NULL,                                                                                               
                                         module_,
                                         'BDT',                                                                                  
                                         NULL,                                                                                          
                                         'L');
      END IF;
END Load_Basic_Data_Translation;


PROCEDURE Load_Company_Templ_Translation (
   module_        IN VARCHAR2,
   lang_code_     IN VARCHAR2,
   path_          IN VARCHAR2,
   text_          IN VARCHAR2 )
IS

CURSOR get_context_id IS
      SELECT context_id
      FROM  language_context_tab
      WHERE sub_type = 'Company Template'
      AND   module = module_
      AND   path = path_;

CURSOR get_attribute_id (context_id_ IN VARCHAR2) IS
      SELECT attribute_id, prog_text
      FROM  language_attribute_tab
      WHERE name = 'Text'
      AND   context_id = context_id_;

BEGIN
      FOR cnt_ IN get_context_id LOOP
       FOR attr_ IN get_attribute_id (cnt_.context_id) LOOP
        Language_Translation_API.Refresh_( attr_.attribute_id,
                                           lang_code_,                                          
                                           text_,
                                           'O');
        END LOOP;      
      END LOOP;      

END Load_Company_Templ_Translation;


PROCEDURE Register_Source (
   name_             IN VARCHAR2,
   full_name_        IN VARCHAR2,
   module_           IN VARCHAR2,
   main_type_        IN VARCHAR2,
   customer_fitting_ IN VARCHAR2,
   import_method_    IN VARCHAR2 )
IS
BEGIN
   Language_Source_API.Register__(name_, 
                                  full_name_, 
                                  module_, 
                                  main_type_, 
                                  customer_fitting_, 
                                  import_method_);
END Register_Source;


PROCEDURE Build_Top_Level_Context(
   context_rec_    IN OUT Language_Context_API.context_rectype,
   layer_          IN VARCHAR2)
IS
BEGIN
   Build_Top_Level_Context___(context_rec_, layer_);
END Build_Top_Level_Context;


PROCEDURE Build_Child_Of_Context(
   child_context_rec_  OUT    Language_Context_API.context_rectype,
   parent_context_rec_ IN     Language_Context_API.context_rectype,
   child_sub_type_     IN     VARCHAR2,
   child_context_name_ IN     VARCHAR2,
   layer_              IN     VARCHAR2,
   name_in_path_       IN     VARCHAR2 DEFAULT NULL)
IS
BEGIN
   Build_Child_Of_Context___( child_context_rec_,
                              parent_context_rec_,
                              child_sub_type_,
                              child_context_name_,
                              layer_,
                              name_in_path_);
   
END Build_Child_Of_Context;


PROCEDURE Build_Attribute(
   context_rec_       IN OUT  Language_Context_API.context_rectype,
   attribute_rec_     IN OUT  Language_Attribute_API.attribute_rectype,
   layer_             IN VARCHAR2)
IS
BEGIN
   Build_Attribute___(context_rec_, 
                      attribute_rec_,
                      layer_);
END Build_Attribute;


PROCEDURE Build_Meta_Data_Ctx(
   module_       IN VARCHAR2,
   source_type_  IN VARCHAR2,
   source_name_  IN VARCHAR2,
   layer_        IN VARCHAR2)
IS
BEGIN
$IF Component_Biserv_SYS.INSTALLED $THEN   
   Xlr_Translation_Util_API.Build_Meta_Data_Ctx(module_,
                                                source_type_,
                                                source_name_,
                                                layer_);   
$ELSE
   NULL;
$END
END;

PROCEDURE Get_Xlr_Translation_Sources(
   xml_        OUT CLOB,
   module_      IN VARCHAR2,
   source_type_ IN VARCHAR2,
   source_name_ IN VARCHAR2)
IS
BEGIN
$IF Component_Biserv_SYS.INSTALLED $THEN   
   Xlr_Translation_Util_API.Get_Xlr_Translation_Sources(xml_ ,
                                                        module_,
                                                        source_type_,
                                                        source_name_);   
$ELSE
   xml_ := empty_clob();
$END
END;

PROCEDURE Refresh_Mobile_contexts_(
   refresh_count_ OUT NUMBER,
   context_id_     IN NUMBER,
   module_         IN VARCHAR2,
   app_            IN VARCHAR2,
   entity_         IN VARCHAR2,
   lu_name_        IN VARCHAR2,
   view_           IN VARCHAR2, 
   layer_          IN VARCHAR2 )
IS
   view_path_ VARCHAR2(500);
   temp_path_ VARCHAR2(500);
   temp_context_id_  NUMBER;
   main_type_ VARCHAR2(10) := 'MOBILE';
   CURSOR get_lu_contexts(path_ VARCHAR2) IS
      SELECT *
      FROM language_context_tab
      WHERE parent = (
         SELECT context_id
         FROM language_context_tab
         WHERE path = path_);
BEGIN
   refresh_count_ := 0;
   view_path_ :=  lu_name_ ||'.'|| view_;
   FOR get_lu_contexts_rec_ IN get_lu_contexts(view_path_) LOOP
      temp_path_ := get_lu_contexts_rec_.path;
      get_lu_contexts_rec_.name := get_lu_contexts_rec_.path;
      get_lu_contexts_rec_.path := app_||'.'||entity_||'.'||get_lu_contexts_rec_.path;
      Make_Context_Obsolete___(get_lu_contexts_rec_.name,main_type_,layer_);
      language_context_api.Refresh_(temp_context_id_,
         NULL,
         get_lu_contexts_rec_.name,
         context_id_,
         main_type_,
         get_lu_contexts_rec_.sub_type,
         module_,
         get_lu_contexts_rec_.path,
         layer_,
         0);
         Refresh_Mobile_attributes_(temp_context_id_,temp_path_);
         refresh_count_:=refresh_count_+1;
   END LOOP;
END Refresh_Mobile_contexts_;

PROCEDURE Refresh_Mobile_attributes_ (
   context_id_   IN  NUMBER,
   path_         IN VARCHAR2)
IS
   name_ VARCHAR2(4):= 'Text';
   prog_text_ VARCHAR2(100);
   attribute_id_ NUMBER;
   
   $IF Component_Fnddev_SYS.INSTALLED $THEN
      CURSOR get_prog_text IS
         SELECT a.prog_text
         FROM   language_attribute_tab a,language_context_tab c
         WHERE  a.context_id = c.context_id
         AND    c.path = path_;
   $END
BEGIN
   $IF Component_Fnddev_SYS.INSTALLED $THEN
      OPEN get_prog_text;
      FETCH get_prog_text INTO prog_text_; 
      CLOSE get_prog_text;
      language_attribute_api.Refresh_(attribute_id_,context_id_,name_,prog_text_);
   $ELSE 
      NULL;
   $END
END Refresh_Mobile_attributes_;
/*
PROCEDURE Scan_Config_Trans_Contexts_
IS
   parent_path_       VARCHAR2(1000);
   main_type_         VARCHAR2(12):= 'CONFIGCLIENT';
   module_            VARCHAR2(6) := 'CONFIG';
   layer_             VARCHAR2(4) := 'User';
   pagegroup_subtype_ VARCHAR2(20):= 'Global Data';
   parent_context_id_ NUMBER;
   translatable_field_meta_rec_ Translatable_Field_Meta_Rec;
   context_rec_     Language_Context_API.context_rectype;
   attribute_rec_   Language_Attribute_API.attribute_rectype;
   
   CURSOR get_page_groups IS
      SELECT client_origin,scope_id
        FROM fnd_navigator_structure_tab
       WHERE layer_no = 90
    GROUP BY client_origin,scope_id;
    
   CURSOR get_navigator_labels(page_group_ VARCHAR2,scope_ VARCHAR2) IS
      SELECT label
        FROM fnd_navigator_entry_tab ne,fnd_navigator_structure_tab ns
       WHERE ne.entry_name = ns.child_entry_name
         AND ne.layer_no = 90
         AND ns.layer_no = 90
         AND ne.scope_id = scope_
         AND ns.scope_id = scope_
         AND ns.client_origin = page_group_;   
BEGIN

   FOR page_groups_rec_ IN get_page_groups LOOP
      parent_path_ := '['||page_groups_rec_.scope_id||'].'||page_groups_rec_.client_origin;
      
      -- Create parent page group context      
      context_rec_.name := parent_path_;
      context_rec_.parent := 0;
      context_rec_.main_type := main_type_;
      context_rec_.sub_type := pagegroup_subtype_;
      context_rec_.module := module_;
      context_rec_.path := parent_path_;
      context_rec_.customer_fitting := NULL;
            
      Build_Top_Level_Context___(context_rec_,layer_);
      parent_context_id_ := context_rec_.context_id;
      
      -- Create navigator entry contexts
      FOR navigator_labels_rec_ IN get_navigator_labels(page_groups_rec_.client_origin,page_groups_rec_.scope_id) LOOP
         translatable_field_meta_rec_:= Extract_Trans_meta___(navigator_labels_rec_.label,parent_path_);
         -- update translation meta tables with new/modified fields metadata
         IF translatable_field_meta_rec_.attribute_name IS NOT NULL THEN
            context_rec_.name := translatable_field_meta_rec_.attribute_name;
            context_rec_.parent := parent_context_id_;
            context_rec_.main_type := main_type_;
            context_rec_.sub_type := translatable_field_meta_rec_.sub_type;
            context_rec_.module := module_;
            context_rec_.path := translatable_field_meta_rec_.path;
            context_rec_.customer_fitting := NULL;
         
            attribute_rec_.name :=  translatable_field_meta_rec_.attribute_name;
            attribute_rec_.prog_text := translatable_field_meta_rec_.prog_text;
         
            Build_Attribute___(context_rec_,attribute_rec_,layer_);
         END IF;
      END LOOP;      
   END LOOP;    
EXCEPTION
   WHEN OTHERS THEN
      DBMS_Output.Put_Line('An Error occured during extracting translatable contexts!');     
END Scan_Config_Trans_Contexts_;


PROCEDURE Scan_Config_Trans_Contexts_ (
   model_id_ IN VARCHAR2,
   context_  IN VARCHAR2)
IS
   parent_context_id_ NUMBER;
   page_group_name_   VARCHAR2(100);
   parent_path_       VARCHAR2(1000);
   main_type_         VARCHAR2(12):= 'CONFIGCLIENT';
   module_            VARCHAR2(6) := 'CONFIG';
   layer_             VARCHAR2(4) := 'User';
   pagegroup_subtype_ VARCHAR2(20):= 'Global Data';
   parent_context_created_ BOOLEAN:= FALSE;
   configured_artifact_list_ Configured_Artifact_Tab;
   translatable_field_meta_tab_ Translatable_Field_Meta_Tab;
   context_rec_     Language_Context_API.context_rectype;
   attribute_rec_   Language_Attribute_API.attribute_rectype;
BEGIN
   -- Extract page group name from the model id & construct parent path
   page_group_name_ := REGEXP_SUBSTR (model_id_,'[^:]+$');
   parent_path_ := '['||context_||'].'||page_group_name_;     
   
   -- fetch configured artifacts belongs to the given model from the model_design_data__data_tab
   configured_artifact_list_:= Get_Configured_Artifacts___(model_id_,context_);
   
   FOR i_ IN 1..configured_artifact_list_.COUNT LOOP
      -- extract translatable strings from the artifact
      translatable_field_meta_tab_.delete;
      translatable_field_meta_tab_ := Ext_Artifact_Trans_Fields___(configured_artifact_list_(i_),parent_path_);
      
      -- update translate tables with new/modified fields metadata
      FOR rec_ IN 1..translatable_field_meta_tab_.COUNT LOOP
         IF NOT parent_context_created_ THEN           
            -- Create parent page group context      
            context_rec_.name := parent_path_;
            context_rec_.parent := 0;
            context_rec_.main_type := main_type_;
            context_rec_.sub_type := pagegroup_subtype_;
            context_rec_.module := module_;
            context_rec_.path := parent_path_;
            context_rec_.customer_fitting := NULL;
            
            Build_Top_Level_Context___(context_rec_,layer_);
            parent_context_id_ := context_rec_.context_id;
            parent_context_created_ := TRUE;
         END IF;
         IF translatable_field_meta_tab_(rec_).attribute_name IS NOT NULL THEN
            context_rec_.name := translatable_field_meta_tab_(rec_).attribute_name;
            context_rec_.parent := parent_context_id_;
            context_rec_.main_type := main_type_;
            context_rec_.sub_type := translatable_field_meta_tab_(rec_).sub_type;
            context_rec_.module := module_;
            context_rec_.path := translatable_field_meta_tab_(rec_).path;
            context_rec_.customer_fitting := NULL;
         
            attribute_rec_.name :=  translatable_field_meta_tab_(rec_).attribute_name;
            attribute_rec_.prog_text := translatable_field_meta_tab_(rec_).prog_text;
         
            Build_Attribute___(context_rec_,attribute_rec_,layer_);
         END IF;       
      END LOOP;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_Output.Put_Line('An Error occured during extracting translatable contexts!');
END Scan_Config_Trans_Contexts_;
*/

PROCEDURE Scan_Config_Trans_Contexts_ (
   model_id_ IN VARCHAR2 DEFAULT NULL,
   scope_id_ IN VARCHAR2 DEFAULT NULL)
IS
   parent_context_id_ NUMBER;
   parent_path_       VARCHAR2(1000);
   main_type_         VARCHAR2(12):= 'CONFIGCLIENT';
   module_            VARCHAR2(6) := 'CONFIG';
   layer_             VARCHAR2(4) := 'User';
   pagegroup_subtype_ VARCHAR2(20):= 'Global Data';
   parent_context_created_ BOOLEAN:= FALSE;
   page_group_tab_ Page_Group_Tab;
   translatable_field_meta_tab_ Translatable_Field_Meta_Tab;
   context_rec_     Language_Context_API.context_rectype;
   attribute_rec_   Language_Attribute_API.attribute_rectype;
BEGIN
   page_group_tab_ := Get_Config_Page_Groups___(model_id_,scope_id_);

   FOR page_group_rec_ IN 1..page_group_tab_.COUNT LOOP
      parent_path_ := '['||page_group_tab_(page_group_rec_).scope_id||'].'||page_group_tab_(page_group_rec_).page_group;   
      translatable_field_meta_tab_ := Get_Translatable_Fields___(page_group_tab_(page_group_rec_).page_group,page_group_tab_(page_group_rec_).scope_id);
      parent_context_created_ := FALSE; 
       -- update translate tables with new/modified fields metadata
      FOR rec_ IN 1..translatable_field_meta_tab_.COUNT LOOP
         IF NOT parent_context_created_ THEN
            -- Create parent page group context      
            context_rec_.name := parent_path_;
            context_rec_.parent := 0;
            context_rec_.main_type := main_type_;
            context_rec_.sub_type := pagegroup_subtype_;
            context_rec_.module := module_;
            context_rec_.path := parent_path_;
            context_rec_.customer_fitting := NULL;
      
            Build_Top_Level_Context___(context_rec_,layer_);
            parent_context_id_ := context_rec_.context_id;
            parent_context_created_ := TRUE;
         END IF;
         IF translatable_field_meta_tab_(rec_).attribute_name IS NOT NULL THEN
            context_rec_.name := translatable_field_meta_tab_(rec_).attribute_name;
            context_rec_.parent := parent_context_id_;
            context_rec_.main_type := main_type_;
            context_rec_.sub_type := translatable_field_meta_tab_(rec_).sub_type;
            context_rec_.module := module_;
            context_rec_.path := translatable_field_meta_tab_(rec_).path;
            context_rec_.customer_fitting := NULL;
         
            attribute_rec_.name :=  translatable_field_meta_tab_(rec_).attribute_name;
            attribute_rec_.prog_text := translatable_field_meta_tab_(rec_).prog_text;
            Build_Attribute___(context_rec_,attribute_rec_,layer_);
         END IF;
      END LOOP;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_Output.Put_Line('An Error occured during extracting translatable contexts!');
END Scan_Config_Trans_Contexts_;

PROCEDURE Scan_Custom_Enum_Contexts_ (
   lu_ IN VARCHAR2)
IS
   packages_          VARCHAR2(2000);
   main_type_         VARCHAR2(12):= 'CONFIGLU';
   module_            VARCHAR2(6) := 'CONFIG';
   layer_             VARCHAR2(4) := 'User';
   lu_subtype_        VARCHAR2(20):= 'Logical Unit';
   parent_context_    Language_Context_API.context_rectype;
   context_           Language_Context_API.context_rectype;  
   attribute_         Language_Attribute_API.attribute_rectype;
BEGIN
   -- Find the package of the LU
   Dictionary_SYS.Get_Logical_Unit_Packages__( lu_, packages_);
   --
   -- Initialize context that will be used as parent for all other contexts in this source
   -- 
   parent_context_.main_type  := main_type_;
   parent_context_.module     := module_;
   parent_context_.context_id := 0;
   parent_context_.path       := '';
   context_.sub_type  := lu_subtype_;
   context_.name      := lu_;
   
   Language_Context_API.Make_Child_Of_( context_, parent_context_ ); 
   --
   -- Write top-level context to database
   Build_Top_Level_Context___(context_,layer_);   
   --
   -- Build attributes for the LU itself.   
   attribute_.context_id := context_.context_id;
   attribute_.name       := lu_;
   attribute_.prog_text  := Dictionary_SYS.Get_Lu_Prompt_( lu_ );

   Build_Attribute___(context_,attribute_,layer_);
   --
   -- Build Iid elements
   Build_Iid_elements___( context_, packages_, layer_ );
   --
EXCEPTION
   WHEN OTHERS THEN
      DBMS_Output.Put_Line('An Error occured during extracting translatable contexts!');
END Scan_Custom_Enum_Contexts_;


