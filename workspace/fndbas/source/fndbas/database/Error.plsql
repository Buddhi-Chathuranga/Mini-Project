-----------------------------------------------------------------------------
--
--  Logical unit: Error
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950518  STLA  Created package Common.
--  950522  ERFO  Package renamed to Error_SYS.
--  950530  ERFO  Changed text standards and added overview information.
--  950606  ERFO  Added call to package Language_SYS for NLS.
--  950615  ERFO  Changed 3 messages to include the LU-name.
--                Record_Not_Exist, Record_Not_Exist, Record_Constraint.
--  950616  ERFO  Changed interface to function Language_SYS.Translate_.
--                Added parameter info_ to method Record_Constraint.
--  950824  ERFO  Added method Access_General for access messages.
--  950830  ERFO  Added default parameters to method Record_General.
--  950904  ERFO  Added parameter count_ to method Record_Constraint.
--                Moved error messages to be able to translate them.
--  950905  ERFO  Added implementation method Raise_Error___.
--                Translation of messages through new method in package
--                Language_SYS.Translate_Msg_.
--  950911  ERFO  Added implementation methods Nls_msg___ and Nls_Prompt___.
--  950912  ERFO  Added documentation headers and examples.
--  950926  ERFO  Added parameter "package_" to method Appl_Access.
--  950929  ERFO  Changed parameter names from view_item_ back to item_,
--                due to new logic in package Language_SYS.
--  951003  ERFO  Removed translation of prompts in item methods.
--  951030  ERFO  Added support for LU-defined error messages for standard
--                error texts, hardcoded within package Error_SYS.
--                The problem is solved by using default parameters in the
--                API with its old interface still supported.
--  951030  ERFO  Changes in name conventions of system services through
--                package Language_SYS.
--  951116  ERFO  Enhanced error texts for standard messages.
--  960325  STLA  Added methods for finite state error reporting (Idea #449).
--  960327  ERFO  Decreased the error call stack by making call to method
--                Raise_Application_Error in each error method (Idea #467).
--  960409  ERFO  Added boolean method Is_Foundation_Error to detect whether
--                an error through Error_SYS has occcurred or not (Idea #481).
--  960507  ERFO  Changed error messages in Appl_Access_ and Record_Constraint.
--  960507  ERFO  Added language translation tag for special cases.
--  960725  ERFO  Added extra default parameter lang_code_ in the methods
--                Appl_General and Nls_Msg___ to support NLS-texts without
--                relying on the language setting in Language_SYS (Idea #689).
--  961216  ERFO  Corrected error text in method State_Not_Exist.
--  971022  ERFO  Review and changes of error messages (ToDo #1111).
--  971024  ERFO  Rearrangements to old algorithm when fetching the
--                description of the logical unit prompt.
--  980303  ERFO  Removed tag for early translation support (ToDo #2184).
--  980728  ERFO  Review of English texts by US (ToDo #2497).
--  990701  RaKu  Changed error-text in procedures Check_Not_Null (ToDo #3550).
--  991020  RaKu  Added message in Item_Format handling  case when item_ is NULL (Bug#3295).
--  000118  ROOD  Corrected Check_Not_Null to make Localization find error text (Bug#19022).
--  020524  ROOD  Added clearing of Client_SYS info. Put this in in Nls_Msg___,
--                this method always is called before raising error (Bug#30025).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030624  ROOD  Improved error message in Appl_Access_ (ToDo#4202).
--  030624  ROOD  Improved error message in Item_Format (ToDo#4204). Rephrased many others
--                as well to include more of the available information.
--                Modified limits in Is_Foundation_Error since Oracle now have started
--                using numbers below -21000 (but only 100 number are reserved).
--  031017  ROOD  A few more improvements in error messages after review.
--  031103  ROOD  Even more improvements in error messages after review.
--  040212  ROOD  Increased two local variables to 2000 characters (Bug#42723).
--  041027  HAAR  Added procedure Sec_Checkpoint_ (F1PR414).
--  060922  HAAR  Added procedure Check_Valid_Key_String (Bug#60671).
--  090218  HASP  Modified procedure Check_Valid_Key_String.
--                Checked any oracle reserved characters and operator characters.(Bug#79826).
--  090505  HASP  Modified procedure Check_Valid_Key_String. Checked trailing spaces in user enterd values (Bug#81878).
--  090525  HASP  Modified procedure Check_Valid_Key_String. Checked leading spaces in user enterd values (Bug#83018).
--  091025  DUWI  Modified procedure Check_Valid_Key_String, Allowed chatracter '.' and restrict folowing '~' and '..' (Bug#86427).
--  091109  NABA  Added procedure Check_Valid_Identifier (Bug#86681)
--  100624  DUWI  Changed the functionality of Check_Valid_Key_String and added function Get_Key_Reg_Exp___(Bug#86672).
--  110801  NaBa  Modified the method Nls_Msg___ to limit the length of the text returned (RDTERUNTIME-410).
--  120319  WAWI  Added Client_Sys.text_separator to separator_pattern_ in procedure Check_Valid_Key_String (RDTERUNTIME-2629).
--  120614  DUWI  Added Trim_Space_Validation and Get_Space_Validation___ (Bug#103412).
--  121217  HAAR  Added method [Component_Not_Exist] (Bug#107105).
-----------------------------------------------------------------------------
--
--  Dependencies: Language_SYS
--
--  Contents:     Implementation methods to isolate other package dependencies
--                Protected application error methods
--                Public system error methods without NLS-support
--                Public application error methods
--                Public record error methods
--                Public item error methods
--                Public item validation check methods (overloading)
--                Public finite state error methods
--                public projection error methods
--                Public general methods
--
-----------------------------------------------------------------------------
--
--  Format:   'ORA-20XXX: <LU-name>.<Msgkey>: <Translated text>
--
--  Example:  'ORA-20113: PayStatus.LOCKED: Row is locked by another user.'
--
--  Client:   Message:        Row is locked...  (standard)
--            Oracle number:  20113             (advanced)
--            Logical unit:   PayStatus         (advanced)
--            Message key:    LOCKED            (advanced)
--
-----------------------------------------------------------------------------
--  Overview of Oracle server error messages:
--
--  Error type   ORA-no     Error method             Type
-----------------------------------------------------------------------------
--
--  SYSTEM       -20100     System_General           Public
--
--  APPLICATION  -20105     Appl_General             Public
--               -20106     Appl_Access_             Protected
--               -20107     Odata_Provider_Access_   Protected
--
--  RECORD       -20110     Record_General           Public
--               -20111     Record_Not_Exist           ||
--               -20112     Record_Exist               ||
--               -20113     Record_Locked              ||
--               -20114     Record_Modified            ||
--               -20115     Record_Removed             ||
--               -20116     Record_Constraint          ||
--
--  ITEM         -20120     Item_General             Public
--               -20121     Item_Insert                ||
--               -20122     Item_Update                ||
--               -20123     Item_Update_If_Null        ||
--               -20124     Item_Format                ||
--               -20125     Item_Not_Exist             ||
--               -20126     Item_Length                ||
--
--  FINITE STATE -20130     State_General            Public
--               -20131     State_Not_Exist            ||
--               -20132     State_Event_Not_Handled    ||
--
--  OTHERS       -20140     Security_Checkpoint_     Protected
--               -20150     Code Generation          Protecte
--               -20160     Rowkey_Exist             Public 
--
--  PROJECTION   -20170     Projection_General       Public
--               -20171     Projection_Not_Exist       ||
--               -20172     Projection_Category        ||
--               -20173     Projection_Group           ||
--               -20174     Projection_Meta_Not_Exist  ||
--               -20175     Projection_Meta_Modified   ||
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

   Err_Sytem_General EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Sytem_General, -20100);
   Err_Appl_General  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Appl_General, -20105);
   Err_Appl_Access   EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Appl_Access, -20106);
   Err_Odata_Provider_Access   EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Odata_Provider_Access, -20107);

   Err_Record_General  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Record_General, -20110);
   Err_Record_Not_Exist  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Record_Not_Exist, -20111);
   Err_Record_Exist  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Record_Exist, -20112);
   Err_Record_Locked  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Record_Locked, -20113);
   Err_Record_Modified  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Record_Modified, -20114);
   Err_Record_Removed  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Record_Removed, -20115);
   Err_Record_Constraint  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Record_Constraint, -20116);
   Err_Too_Many_Rows  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Too_Many_Rows, -20117);
   Err_Record_Access_Blocked EXCEPTION;
   PRAGMA            exception_init(Err_Record_Access_Blocked, -20118);

   Err_Item_General  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Item_General, -20120);
   Err_Item_Insert  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Item_Insert, -20121);
   Err_Item_Update  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Item_Update, -20122);
   Err_Item_Update_If_Null  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Item_Update_If_Null, -20123);
   Err_Item_Format  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Item_Format, -20124);
   Err_Item_Not_Exist  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Item_Not_Exist, -20125);
   Err_Item_Length  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Item_Length, -20126);
   
   Err_State_General  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_State_General, -20130);
   Err_State_Not_Exist  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_State_Not_Exist, -20131);
   Err_State_Event_Not_Handled  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_State_Event_Not_Handled, -20132);
   
   Err_Security_Checkpoint  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Security_Checkpoint, -20140);
   Err_Component_Not_Exist  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Component_Not_Exist, -20141);
   Err_Deprecated_Error EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Deprecated_Error, -20149);
   Err_Compile_Error EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Compile_Error, -20150);
   Err_Rowkey_Exist  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(Err_Rowkey_Exist, -20160);
   
   Err_Projection_General  EXCEPTION;
   PRAGMA            exception_init(Err_Projection_General, -20170);
   Err_Projection_Not_Exist  EXCEPTION;
   PRAGMA            exception_init(Err_Projection_Not_Exist, -20171);
   Err_Projection_Category  EXCEPTION;
   PRAGMA            exception_init(Err_Projection_Category, -20172);
   Err_Projection_Group  EXCEPTION;
   PRAGMA            exception_init(Err_Projection_Group, -20173);
   Err_Projection_Meta_Not_Exist  EXCEPTION;
   PRAGMA            exception_init(Err_Projection_Meta_Not_Exist, -20174);
   Err_Projection_Meta_Modified  EXCEPTION;
   PRAGMA            exception_init(Err_Projection_Meta_Modified, -20175);
   
   Err_Odp_Record_Not_Exist  EXCEPTION;
   PRAGMA            exception_init(Err_Odp_Record_Not_Exist, -20180);
   Err_Init_Check_Failure EXCEPTION;
   PRAGMA            exception_init(Err_Init_Check_Failure, -20181);
      
-------------------- PRIVATE DECLARATIONS -----------------------------------

separator_ CONSTANT VARCHAR2(1) := chr(8);

line_feed_ CONSTANT VARCHAR2(1) := chr(10);

line_feed_marker_ CONSTANT VARCHAR2(2) := 'LF';

carriage_return_ CONSTANT VARCHAR2(1) := chr(13);

carriage_return_marker_ CONSTANT VARCHAR2(2) := 'CR';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Space_Validation___ (
   value_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   IF LENGTH(value_) != LENGTH(LTRIM(value_)) THEN
      RETURN 'LEFT';
   END IF;
   IF LENGTH(value_) != LENGTH(RTRIM(value_)) THEN
      RETURN 'RIGHT';
   END IF;
   RETURN NULL;
END Get_Space_Validation___;


PROCEDURE Raise_Application_Error___ (
   error_no_   IN VARCHAR2,
   error_text_ IN VARCHAR2 )
IS
   call_stack_ VARCHAR2(32000);
   FUNCTION Format_Call_Stack___ RETURN VARCHAR2 
   IS
      stack_ VARCHAR2(32000);
      depth_ PLS_INTEGER := Utl_Call_Stack.Dynamic_Depth();
   BEGIN
      FOR i_ IN REVERSE 1 .. depth_ LOOP
         stack_ := stack_ || UTL_Call_Stack.Concatenate_Subprogram(UTL_Call_Stack.Subprogram(i_)) || ' at line ' || To_Char(UTL_Call_Stack.Unit_Line(i_)) || chr(10);
      END LOOP;
      RETURN stack_;
   END Format_Call_Stack___;
BEGIN
   BEGIN
      call_stack_ := Format_Call_Stack___;
      -- Send the error stack 
      Fnd_Context_SYS.Set_Value('EXCEPTION', Fnd_Boolean_API.DB_TRUE);
      -- Conditional compilation for Oracle12c
      Fnd_Context_SYS.Set_Value('ERROR_CALL_STACK', call_stack_);
      Log_SYS.Stack_Trace_(Log_SYS.Debug_, call_stack_);
   EXCEPTION
      WHEN OTHERS THEN 
         Fnd_Context_SYS.Set_Value('ERROR_CALL_STACK', Dbms_Utility.Format_Error_Backtrace);
         RAISE;
   END;
   Raise_Application_Error(error_no_, error_text_);
END Raise_Application_Error___;

FUNCTION Nls_Translate___ (
   lu_name_   IN VARCHAR2,
   err_text_  IN VARCHAR2,
   lang_code_ IN VARCHAR2 DEFAULT NULL,
   p1_        IN VARCHAR2 DEFAULT NULL,
   p2_        IN VARCHAR2 DEFAULT NULL,
   p3_        IN VARCHAR2 DEFAULT NULL,
   service_name_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
BEGIN
   RETURN(Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_, lang_code_,service_name_));
END Nls_Translate___;


-- Nls_Msg___
--   Translate server error message from NLS run-time database.
FUNCTION Nls_Msg___ (
   lu_name_   IN VARCHAR2,
   err_text_  IN VARCHAR2,
   p1_        IN VARCHAR2 DEFAULT NULL,
   p2_        IN VARCHAR2 DEFAULT NULL,
   p3_        IN VARCHAR2 DEFAULT NULL,
   lang_code_ IN VARCHAR2 DEFAULT NULL,
   service_name_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   temp_ VARCHAR2(32000);
BEGIN
   IF service_name_ IS NOT NULL THEN
     temp_ := Language_SYS.Translate_Msg_(service_name_, err_text_, lang_code_);     
   ELSE
     temp_ := Language_SYS.Translate_Msg_(lu_name_, err_text_, lang_code_);
   END IF;     
   temp_ := replace(temp_, ':P1', p1_);
   temp_ := replace(temp_, ':P2', p2_);
   temp_ := replace(temp_, ':P3', p3_);
   temp_ := replace(temp_, ':LU', Nls_Lu_Prompt___(lu_name_));
   -- Clear obsolete client info before the error is raised
   Client_SYS.Clear_Info;
   RETURN(substr(temp_,1,1950));
END Nls_Msg___;

FUNCTION Get_Formatted_Error_Text (
   lu_name_   IN VARCHAR2,
   err_text_  IN VARCHAR2,
   p1_        IN VARCHAR2 DEFAULT NULL,
   p2_        IN VARCHAR2 DEFAULT NULL,
   p3_        IN VARCHAR2 DEFAULT NULL,
   p4_        IN VARCHAR2 DEFAULT NULL,
   p5_        IN VARCHAR2 DEFAULT NULL,
   p6_        IN VARCHAR2 DEFAULT NULL,
   p7_        IN VARCHAR2 DEFAULT NULL,
   p8_        IN VARCHAR2 DEFAULT NULL,
   p9_        IN VARCHAR2 DEFAULT NULL,
   p10_       IN VARCHAR2 DEFAULT NULL,
   lang_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN Nls_Msg_10___(lu_name_,err_text_,p1_,p2_,p3_,p4_,p5_,p6_,p7_,p8_,p9_,p10_,lang_code_);
END Get_Formatted_Error_Text;

FUNCTION Nls_Msg_10___ (
   lu_name_   IN VARCHAR2,
   err_text_  IN VARCHAR2,
   p1_        IN VARCHAR2 DEFAULT NULL,
   p2_        IN VARCHAR2 DEFAULT NULL,
   p3_        IN VARCHAR2 DEFAULT NULL,
   p4_        IN VARCHAR2 DEFAULT NULL,
   p5_        IN VARCHAR2 DEFAULT NULL,
   p6_        IN VARCHAR2 DEFAULT NULL,
   p7_        IN VARCHAR2 DEFAULT NULL,
   p8_        IN VARCHAR2 DEFAULT NULL,
   p9_        IN VARCHAR2 DEFAULT NULL,
   p10_       IN VARCHAR2 DEFAULT NULL,
   lang_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(32000);
BEGIN
   temp_ := Language_SYS.Translate_Msg_(lu_name_, err_text_, lang_code_);
   temp_ := replace(temp_, ':P1', p1_);
   temp_ := replace(temp_, ':P2', p2_);
   temp_ := replace(temp_, ':P3', p3_);
   temp_ := replace(temp_, ':P4', p4_);
   temp_ := replace(temp_, ':P5', p5_);
   temp_ := replace(temp_, ':P6', p6_);
   temp_ := replace(temp_, ':P7', p7_);
   temp_ := replace(temp_, ':P8', p8_);
   temp_ := replace(temp_, ':P9', p9_);
   temp_ := replace(temp_, ':P10', p10_);
   temp_ := replace(temp_, ':LU', Nls_Lu_Prompt___(lu_name_));
   
   RETURN(substr(temp_,1,1950));
END Nls_Msg_10___;


-- Nls_Item_Prompt___
--   Translate attribute prompt from NLS run-time database.
FUNCTION Nls_Item_Prompt___ (
   lu_name_ IN VARCHAR2,
   item_    IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Language_SYS.Translate_Item_Prompt_(lu_name_, item_);
END Nls_Item_Prompt___;


-- Nls_Lu_Prompt___
--   Translate lu prompt from NLS run-time database.
FUNCTION Nls_Lu_Prompt___ (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Language_SYS.Translate_Lu_Prompt_(lu_name_);
END Nls_Lu_Prompt___;


FUNCTION Get_Key_Reg_Exp___(
   client_string_ IN VARCHAR2) RETURN VARCHAR2
IS
   reg_exp_reserved_list_     VARCHAR2(5) := '.([)]';
   length_                    NUMBER := length(client_string_);
   temp_char_                 VARCHAR2(1);
   temp_multi_chars_          VARCHAR2(32000);
   temp_multichar_encoded_    VARCHAR2(32000);
   temp_multichar_member_     VARCHAR2(1);
   pos_                       NUMBER := 1;
   normal_chars_              VARCHAR2(32000);
   special_chars_             VARCHAR2(32000);
   multiple_chars_            VARCHAR2(32000);
   multiple_seperator_open_   VARCHAR2(1) := '(';
   multiple_seperator_close_  VARCHAR2(1) := ')';
   
BEGIN
   WHILE pos_ <= length_ LOOP
      temp_char_ := SUBSTR(client_string_, pos_, 1);
      IF temp_char_ = multiple_seperator_open_ AND SUBSTR(client_string_, pos_+1, 1)!= multiple_seperator_open_ THEN
         --extract the multiple character pair
         -- looking for the next matching end paranthesis
         temp_multi_chars_ := SUBSTR(client_string_, pos_+1,INSTR(SUBSTR(client_string_, pos_+1),multiple_seperator_close_)-1);
         --safety precaution to encode special chars if any
         temp_multichar_encoded_ := '';
         FOR i IN 1..LENGTH(temp_multi_chars_) LOOP
            temp_multichar_member_ := SUBSTR(temp_multi_chars_,i,1);
            IF INSTR(reg_exp_reserved_list_,temp_multichar_member_)>0 THEN
               temp_multichar_encoded_ := temp_multichar_encoded_ || '\' ||temp_multichar_member_ ;
            ELSE
               temp_multichar_encoded_ := temp_multichar_encoded_ || temp_multichar_member_ ;
            END IF;
         END LOOP;
         multiple_chars_ := multiple_chars_ || '|' || '(' || temp_multichar_encoded_ || ')';
         pos_ := pos_ + LENGTH(temp_multi_chars_) +1;
      ELSE
         IF temp_char_ = multiple_seperator_close_ AND SUBSTR(client_string_, pos_+1, 1)!= multiple_seperator_close_ THEN
            pos_ := pos_ + 1;
         ELSE
            IF (temp_char_ = multiple_seperator_open_ AND SUBSTR(client_string_, pos_+1, 1) = multiple_seperator_open_) OR  (temp_char_ = multiple_seperator_close_ AND SUBSTR(client_string_, pos_+1, 1) = multiple_seperator_close_) THEN
               pos_ := pos_ +1;
               temp_char_ := SUBSTR(client_string_, pos_, 1);
            END IF;
            
            IF INSTR(reg_exp_reserved_list_,temp_char_) > 0 THEN
               special_chars_ := special_chars_ || '\' ||temp_char_ ||'|';
            ELSE
               normal_chars_ := normal_chars_ || temp_char_;
            END IF;
            pos_ := pos_ + 1;
         END IF;
      END IF;
   END LOOP;
   -- Create the regular expression 
   IF special_chars_ IS NOT NULL  THEN
      special_chars_ := '(' || SUBSTR(special_chars_,1, length(special_chars_)-1) || ')|';
   END IF;
   IF multiple_chars_ IS NOT NULL  THEN
      multiple_chars_ := SUBSTR(multiple_chars_,2, length(multiple_chars_)) || '|';
   END IF;
   normal_chars_ := '['||normal_chars_||']';
   
   RETURN '(' || special_chars_ || multiple_chars_ || normal_chars_ || ')';
END Get_Key_Reg_Exp___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Appl_Access_
--   Access errors to be used from system service Security_SYS.
@UncheckedAccess
PROCEDURE Appl_Access_ (
   lu_name_ IN VARCHAR2,
   package_ IN VARCHAR2,
   method_  IN VARCHAR2 )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Nls_Msg___(lu_name_, 'NOACCESS: You do not have privileges to use the ":METHOD" operation for ":LU".',service_name_=>service_);
   text_ := replace(text_, ':METHOD', package_||'.'||method_);
   Raise_Application_Error___(-20106, lu_name_||'.'||text_);
END Appl_Access_;

-- Odata_Provider_Access_
--   Access errors to be used from Odata Provider Authorization.
@UncheckedAccess
PROCEDURE Odata_Provider_Access_ (
   lu_name_   IN VARCHAR2,
   err_text_  IN VARCHAR2,
   p1_        IN VARCHAR2 DEFAULT NULL,
   p2_        IN VARCHAR2 DEFAULT NULL,
   p3_        IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   Raise_Application_Error___(-20107, lu_name_||'.'||text_);
END Odata_Provider_Access_;

-- Security_Checkpoint_
--   Security Checkpoint errors to be used from system service Security_SYS.
--   Security Checkpoint errors to be used from system service Security_SYS.
@UncheckedAccess
PROCEDURE Security_Checkpoint_ (
   msg_ IN VARCHAR2 )
IS
   tmp_msg_ VARCHAR2(32000) := msg_;
BEGIN
   Message_SYS.Set_Attribute(tmp_msg_, 'TOKEN', Message_SYS.Find_Attribute(msg_, 'TOKEN', ''));
   Raise_Application_Error___(-20140, Client_SYS.record_separator_ || tmp_msg_ || Client_SYS.record_separator_);
END Security_Checkpoint_;


@UncheckedAccess
PROCEDURE Compile_Error_ (
   lu_name_ IN VARCHAR2 )
IS
   text_ VARCHAR2(4000);
BEGIN
   text_ := Nls_Msg___(lu_name_, 'COMPILE_ERROR: Error during compilation of LU [:P1].', lu_name_,service_name_=>service_);
   Raise_Application_Error___(-20150, text_);
END Compile_Error_;

@UncheckedAccess
PROCEDURE Deprecated_Error_ (
   lu_name_ IN VARCHAR2,
   method_name_ IN VARCHAR2 )
IS
   text_ VARCHAR2(4000);
BEGIN
   text_ := Nls_Msg___(lu_name_, 'Deprecated_ERROR: Method [:P2] in LU [:P1] is deprecated.', lu_name_, method_name_,service_name_=>service_);
   Raise_Application_Error___(-20149, text_);
END Deprecated_Error_;


@UncheckedAccess
PROCEDURE Compile_Error_ (
   lu_name_ IN VARCHAR2,
   details_ IN VARCHAR2)
IS
   text_ VARCHAR2(4000);
BEGIN
   text_ := Nls_Msg___(lu_name_, 'COMPILE_ERROR2: Error during compilation of LU [:P1].:P3Error details: :P2', lu_name_, details_, chr(13) || chr(10) || chr(13) || chr(10), service_name_=>service_);
   Raise_Application_Error___(-20150, text_);
END Compile_Error_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- System_General
--   General error method used by the system.
@UncheckedAccess
PROCEDURE System_General (
   err_text_ IN VARCHAR2,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := err_text_;
   text_ := replace(text_, ':P1', p1_);
   text_ := replace(text_, ':P2', p2_);
   text_ := replace(text_, ':P3', p3_);
   Raise_Application_Error___(-20100, service_||'.'||text_);
END System_General;


-- Appl_General
--   General error method to be used by the logical units.
@UncheckedAccess
PROCEDURE Appl_General (
   lu_name_   IN VARCHAR2,
   err_text_  IN VARCHAR2,
   p1_        IN VARCHAR2 DEFAULT NULL,
   p2_        IN VARCHAR2 DEFAULT NULL,
   p3_        IN VARCHAR2 DEFAULT NULL,
   lang_code_ IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_, lang_code_);
   Raise_Application_Error___(-20105, lu_name_||'.'||text_);
END Appl_General;


-- Record_General
--   General error method for record tasks with user defined messages.
@UncheckedAccess
PROCEDURE Record_General (
   lu_name_  IN VARCHAR2,
   err_text_ IN VARCHAR2,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_);
   Raise_Application_Error___(-20110, lu_name_||'.'||text_);
END Record_General;


@UncheckedAccess
PROCEDURE Fnd_Record_Not_Exist (
   lu_name_       IN VARCHAR2 )
IS
   text_ VARCHAR2(2000) := Nls_Translate___(lu_name_, 'FND_RECORD_NOT_EXIST: The :LU does not exist.', Fnd_Session_API.Get_Language,service_name_=>service_);
BEGIN
   Raise_Application_Error___(-20111, lu_name_||'.'||text_);
END Fnd_Record_Not_Exist;


-- Record_Not_Exist
--   Validation message, used from all <LU>_API.Exist.
@UncheckedAccess
PROCEDURE Record_Not_Exist (
   lu_name_  IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_);
   ELSE
      IF p1_ IS NOT NULL THEN
         text_ := Nls_Msg___(lu_name_, 'NOTEXIST: The :LU ":P1" does not exist.', p1_,service_name_=>service_);
      ELSE
         text_ := Nls_Msg___(lu_name_, 'NOTEXIST2: The :LU object does not exist.',service_name_=>service_);
      END IF;
   END IF;
   Raise_Application_Error___(-20111, lu_name_||'.'||text_);
END Record_Not_Exist;


-- Record_Exist
--   Duplicate key message when registering new records.
@UncheckedAccess
PROCEDURE Record_Exist (
   lu_name_  IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_);
   ELSE
      IF p1_ IS NOT NULL THEN
         text_ := Nls_Msg___(lu_name_, 'EXIST: The :LU ":P1" already exists.', p1_,service_name_=>service_);
      ELSE
         text_ := Nls_Msg___(lu_name_, 'EXIST2: The :LU object already exists.',service_name_=>service_);
      END IF;
   END IF;
   Raise_Application_Error___(-20112, lu_name_||'.'||text_);
END Record_Exist;


@UncheckedAccess
PROCEDURE Fnd_Record_Exist (
   lu_name_       IN VARCHAR2 )
IS
   text_ VARCHAR2(2000) := Nls_Translate___(lu_name_, 'FND_RECORD_EXIST: The :LU already exists.', Fnd_Session_API.Get_Language,service_name_=>service_);
BEGIN
   Raise_Application_Error___(-20112, lu_name_||'.'||text_);
END Fnd_Record_Exist;


-- Rowkey_Exist
--   Duplicate rowkey message when registering new records.
@UncheckedAccess
PROCEDURE Rowkey_Exist (
   lu_name_  IN VARCHAR2,
   rowkey_   IN VARCHAR2 )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Nls_Msg___(service_, 'ROWKEY_EXIST: The rowkey :P2 for ":P1" already exists.', lu_name_, rowkey_,service_name_=>service_);
   Raise_Application_Error___(-20160, lu_name_||'.'||text_);
END Rowkey_Exist;


@UncheckedAccess
PROCEDURE Fnd_Rowkey_Exist (
   lu_name_       IN VARCHAR2,
   rowkey_        IN VARCHAR2 )
IS
   text_ VARCHAR2(2000) := Nls_Translate___(lu_name_, 'FND_ROWKEY_EXIST: The rowkey ":P1" for :LU already exists.', Fnd_Session_API.Get_Language, rowkey_,service_name_=>service_);
BEGIN
   Raise_Application_Error___(-20160, text_);
END Fnd_Rowkey_Exist;

-- Record_Locked
--   Message for row lockings, used by method Lock___.
@UncheckedAccess
PROCEDURE Record_Locked (
   lu_name_  IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      IF p1_ IS NOT NULL THEN
         text_ := Nls_Msg___(lu_name_, 'LOCKED: The :LU ":P1" is locked by another user.', p1_,service_name_=>service_);
      ELSE
         text_ := Nls_Msg___(lu_name_, 'LOCKED2: The :LU object is locked by another user.',service_name_=>service_);
      END IF;
   END IF;
   Raise_Application_Error___(-20113, lu_name_||'.'||text_);
END Record_Locked;


@UncheckedAccess
PROCEDURE Fnd_Record_Locked (
   lu_name_       IN VARCHAR2 )
IS
   text_ VARCHAR2(2000) := Nls_Translate___(lu_name_, 'FND_LOCKED: The update could not be performed since the :LU record is currently locked. Please retry the operation.', Fnd_Session_API.Get_Language,service_name_=>service_);
BEGIN
   Raise_Application_Error___(-20113, lu_name_||'.'||text_);
END Fnd_Record_Locked;


-- Record_Modified
--   Message when old information are fetched from the database.
@UncheckedAccess
PROCEDURE Record_Modified (
   lu_name_  IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      IF p1_ IS NOT NULL THEN
         text_ := Nls_Msg___(lu_name_, 'MODIFIED: The :LU ":P1" has been modified by another user. Please refresh the object and reenter your changes.', p1_,service_name_=>service_);
      ELSE
         text_ := Nls_Msg___(lu_name_, 'MODIFIED2: The :LU object has been modified by another user. Please refresh the object and reenter your changes.',service_name_=>service_);
      END IF;
   END IF;
   Raise_Application_Error___(-20114, lu_name_||'.'||text_);
END Record_Modified;


@UncheckedAccess
PROCEDURE Fnd_Record_Modified (
   lu_name_       IN VARCHAR2 )
IS
   text_ VARCHAR2(2000) := Nls_Translate___(lu_name_, 'FND_MODIFIED: The :LU record has already been changed. Please refresh the record and reenter your changes.', Fnd_Session_API.Get_Language,service_name_=>service_);
BEGIN
   Raise_Application_Error___(-20114, lu_name_||'.'||text_);
END Fnd_Record_Modified;


-- Record_Removed
--   Message when record removed from the database by another user.
@UncheckedAccess
PROCEDURE Record_Removed (
   lu_name_  IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )

IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      IF p1_ IS NOT NULL THEN
         text_ := Nls_Msg___(lu_name_, 'REMOVED: The :LU ":P1" has been removed by another user.', p1_,service_name_=>service_);
      ELSE
         text_ := Nls_Msg___(lu_name_, 'REMOVED2: The :LU object has been removed by another user.',service_name_=>service_);
      END IF;
   END IF;
   Raise_Application_Error___(-20115, lu_name_||'.'||text_);
END Record_Removed;


@UncheckedAccess
PROCEDURE Fnd_Record_Removed (
   lu_name_       IN VARCHAR2,
   label_         IN VARCHAR2,
   value_         IN VARCHAR2,
   parent_key_msg_ IN VARCHAR2 )
IS
   text_ VARCHAR2(2000) := Nls_Translate___(lu_name_, 'The :P1 ":P2" has already been removed by another user.:P3', Fnd_Session_API.Get_Language, label_, value_, separator_ || parent_key_msg_,service_);
BEGIN
   Raise_Application_Error___(-20115, lu_name_||'.'||text_);
END Fnd_Record_Removed;


@UncheckedAccess
PROCEDURE Fnd_Record_Removed (
   lu_name_       IN VARCHAR2 )
IS
   text_ VARCHAR2(2000) := Nls_Translate___(lu_name_, 'The ":LU" has already been removed by another user.', Fnd_Session_API.Get_Language,service_name_=>service_);
BEGIN
   Raise_Application_Error___(-20115, lu_name_||'.'||text_);
END Fnd_Record_Removed;


-- Record_Constraint
--   Message for restricted delete for foreign keys.
@UncheckedAccess
PROCEDURE Record_Constraint (
   lu_name_  IN VARCHAR2,
   info_     IN VARCHAR2,
   count_    IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      IF p1_ IS NOT NULL THEN
         text_ := Nls_Msg___(lu_name_, 'CONSTRAINT: The :LU ":P1" is used by :COUNT rows in another object (:INFO).', p1_,service_name_=>service_);
      ELSE
         text_ := Nls_Msg___(lu_name_, 'CONSTRAINT2: The :LU object is used by :COUNT rows in another object (:INFO).',service_name_=>service_);
      END IF;
      text_ := replace(text_, ':INFO', info_);
      text_ := replace(text_, ':COUNT', count_);
   END IF;
   Raise_Application_Error___(-20116, lu_name_||'.'||text_);
END Record_Constraint;


@UncheckedAccess
PROCEDURE Too_Many_Rows (
   lu_name_  IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      text_ := Nls_Msg___(lu_name_, 'TOO_MANY_ROWS: The method ":P1" in :LU returns more than one row.', p1_,service_name_=>service_);
   END IF;
   Raise_Application_Error___(-20117, lu_name_||'.'||text_);
END Too_Many_Rows;



@UncheckedAccess
PROCEDURE Fnd_Too_Many_Rows (
   lu_name_       IN VARCHAR2,
   method_name_   IN VARCHAR2,
   formatted_key_ IN VARCHAR2 )
IS
   text_ VARCHAR2(2000) := Nls_Translate___(lu_name_, 'FND_TOO_MANY_ROWS: The method ":P1" in :LU returns more than one row.', Fnd_Session_API.Get_Language, method_name_,service_name_=>service_);
BEGIN
   Raise_Application_Error___(-20117, lu_name_||'.'||text_);
END Fnd_Too_Many_Rows;

@UncheckedAccess
PROCEDURE Record_Access_Blocked (
   lu_name_  IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      text_ := Nls_Msg___(lu_name_, 'ACCESSBLOCKED: :LU is blocked for use.',service_name_=>service_);   
   END IF;
   Raise_Application_Error___(-20118, lu_name_||'.'||text_);
END Record_Access_Blocked;


-- Data_Access
--   General error method to be used by the logical units.
@UncheckedAccess
PROCEDURE Data_Access_Security (
   lu_name_   IN VARCHAR2,
   err_text_  IN VARCHAR2,
   p1_        IN VARCHAR2 DEFAULT NULL,
   p2_        IN VARCHAR2 DEFAULT NULL,
   p3_        IN VARCHAR2 DEFAULT NULL,
   p4_        IN VARCHAR2 DEFAULT NULL,
   p5_        IN VARCHAR2 DEFAULT NULL,
   p6_        IN VARCHAR2 DEFAULT NULL,
   p7_        IN VARCHAR2 DEFAULT NULL,
   p8_        IN VARCHAR2 DEFAULT NULL,
   p9_        IN VARCHAR2 DEFAULT NULL,
   p10_       IN VARCHAR2 DEFAULT NULL,
   lang_code_ IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(4000);
BEGIN
   text_ := Nls_Msg_10___(lu_name_, err_text_, p1_, p2_, p3_, p4_, p5_, p6_, p7_, p8_, p9_, p10_, lang_code_);
   -- Clear obsolete client info before the error is raised
   Client_SYS.Clear_Info;
   Raise_Application_Error___(-20119, lu_name_||'.'||text_);
END Data_Access_Security;

-- Appl_Failure
--   General error method to be used within 'initial check' methods
@UncheckedAccess
PROCEDURE Appl_Failure (
   lu_name_    IN VARCHAR2,
   caller_     IN VARCHAR2 DEFAULT NULL,
   err_text_   IN VARCHAR2 DEFAULT NULL,
   err_source_ IN VARCHAR2 DEFAULT NULL,      
   p1_         IN VARCHAR2 DEFAULT NULL,
   p2_         IN VARCHAR2 DEFAULT NULL,
   p3_         IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   -- Argument 'err_source_' is currently unused, being defined to be used for debugging purposes.
   IF (err_text_ IS NULL) THEN
      IF (caller_ IS NULL) THEN
         text_ := Nls_Msg___(lu_name_, 'ACCESS_FAILURE: Arguments used to execute current operation are not allowed.',service_name_=>service_);
      ELSE
         text_ := Nls_Msg___(lu_name_, 'ACTION_ACCESS_FAILURE: Arguments used to execute ":CALLER" are not allowed.',service_name_=>service_);
         text_ := replace(text_, ':CALLER', caller_);
      END IF;
   ELSE
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   END IF;   
   Raise_Application_Error___(-20181, lu_name_||'.'||text_);
END Appl_Failure;

-- Item_General
--   General error method for item tasks with used defined messages.
@UncheckedAccess
PROCEDURE Item_General (
   lu_name_  IN VARCHAR2,
   item_     IN VARCHAR2,
   err_text_ IN VARCHAR2,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   text_ := replace(text_, ':NAME', item_);
   Raise_Application_Error___(-20120, lu_name_||'.'||text_);
END Item_General;


-- Item_Insert
--   Message when an illegal attribute is changed at NEW.
@UncheckedAccess
PROCEDURE Item_Insert (
   lu_name_  IN VARCHAR2,
   item_     IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      text_ := Nls_Msg___(lu_name_, 'INSERT: Field [:NAME] in :LU may not be specified for new objects.',service_name_=>service_);
      text_ := replace(text_, ':NAME', item_);
   END IF;
   Raise_Application_Error___(-20121, lu_name_||'.'||text_);
END Item_Insert;


-- Item_Update
--   Message when an illegal attribute is changed at MODIFY.
@UncheckedAccess
PROCEDURE Item_Update (
   lu_name_  IN VARCHAR2,
   item_     IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      text_ := Nls_Msg___(lu_name_, 'UPDATE: Field [:NAME] in :LU may not be modified.',service_name_=>service_);
      text_ := replace(text_, ':NAME', item_);
   END IF;
   Raise_Application_Error___(-20122, lu_name_||'.'||text_);
END Item_Update;


-- Item_Update_If_Null
--   Message when an illegal attribute is changed at MODIFY.
@UncheckedAccess
PROCEDURE Item_Update_If_Null (
   lu_name_  IN VARCHAR2,
   item_     IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      text_ := Nls_Msg___(lu_name_, 'UPDATEIFNULL: Field [:NAME] in :LU may not be modified.',service_name_=>service_);
      text_ := replace(text_, ':NAME', item_);
   END IF;
   Raise_Application_Error___(-20123, lu_name_||'.'||text_);
END Item_Update_If_Null;


-- Item_Format
--   Message when a bad format is found (often when unpacking attr_).
@UncheckedAccess
PROCEDURE Item_Format (
   lu_name_  IN VARCHAR2,
   item_     IN VARCHAR2,
   value_    IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      IF (item_ IS NULL) THEN
         text_ := Nls_Msg___(lu_name_, 'FORMAT: Assignment of an invalid value or value type has occurred in :LU.',service_name_=>service_);
         text_ := replace(text_, ':LU', lu_name_);
      ELSE
         -- Include the value if is reasonably short...
         IF length(value_) < 81 THEN
            text_ := Nls_Msg___(lu_name_, 'FORMAT2: Field [:NAME] in :LU has an invalid value format. The value is: ":VALUE".',service_name_=>service_);
            text_ := replace(text_, ':VALUE', value_);
         ELSE
            text_ := Nls_Msg___(lu_name_, 'FORMAT3: Field [:NAME] in :LU has an invalid value format.',service_name_=>service_);
         END IF;
         text_ := replace(text_, ':NAME', item_);
      END IF;
   END IF;
   Raise_Application_Error___(-20124, lu_name_||'.'||text_);
END Item_Format;


@UncheckedAccess
PROCEDURE Fnd_Item_Format (
   lu_name_       IN VARCHAR2,
   label_         IN VARCHAR2,
   value_         IN VARCHAR2,
   cause_         IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000) := Nls_Translate___(lu_name_, 'FND_ITEM_FORMAT: The value ":P2" has incorrect format for [:P1] in :LU. :P3', Fnd_Session_API.Get_Language, label_, value_, cause_,service_);
BEGIN
   Raise_Application_Error___(-20124, lu_name_||'.'||text_);
END Fnd_Item_Format;


-- Item_Not_Exist
--   Message when unidentified attributes are found (within attr_).
@UncheckedAccess
PROCEDURE Item_Not_Exist (
   lu_name_  IN VARCHAR2,
   item_     IN VARCHAR2,
   value_    IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      IF value_ IS NULL THEN
         text_ := Nls_Msg___(lu_name_, 'ITEMNOTEXIST: Field [:NAME] is not a part of :LU.',service_name_=>service_);
      ELSE
         text_ := Nls_Msg___(lu_name_, 'ITEMNOTEXIST2: Field [:NAME] with value ":VALUE" is not a part of :LU.',service_name_=>service_);
         text_ := replace(text_, ':VALUE', value_);
      END IF;
      text_ := replace(text_, ':NAME', item_);
   END IF;
   Raise_Application_Error___(-20125, lu_name_||'.'||text_);
END Item_Not_Exist;


@UncheckedAccess
PROCEDURE Fnd_Item_Length (
   lu_name_       IN VARCHAR2,
   err_text_      IN VARCHAR2)
IS
   text_ VARCHAR2(2000) := Nls_Translate___(lu_name_, 'FND_ITEM_LENGTH: The length exceeds the maximum length for the database. (:P1)', Fnd_Session_API.Get_Language, err_text_, service_name_=>service_);
BEGIN
   Raise_Application_Error___(-20126, lu_name_||'.'||text_);
END Fnd_Item_Length;


@UncheckedAccess
PROCEDURE Component_Not_Exist (
   module_  IN VARCHAR2 )
IS
   text_ VARCHAR2(4000);
BEGIN
   text_ := Nls_Msg___(service_, 'COMPONENT_NOT_EXIST: Component [:P1] is not available.', module_,service_name_=>service_);
   Raise_Application_Error___(-20141, text_);
END Component_Not_Exist;


-- Check_Not_Null
--   Method to check if an attribute is NULL or not.
--   The value is given as a parameter.
@UncheckedAccess
PROCEDURE Check_Not_Null (
   lu_name_ IN VARCHAR2,
   item_    IN VARCHAR2,
   value_   IN VARCHAR2 )
IS
   temp_ VARCHAR2(100);
BEGIN
   IF (value_ IS NULL) THEN
      temp_ := Nls_Lu_Prompt___(lu_name_);
      Error_SYS.Item_Format(service_, NULL, NULL, 'NULLVALUE: Field [:P1] is mandatory for :P2 and requires a value.', item_, temp_);
   END IF;
END Check_Not_Null;


-- Check_Not_Null
--   Method to check if an attribute is NULL or not.
--   The value is given as a parameter.
@UncheckedAccess
PROCEDURE Check_Not_Null (
   lu_name_ IN VARCHAR2,
   item_    IN VARCHAR2,
   value_   IN NUMBER )
IS
BEGIN
   Check_Not_Null(lu_name_, item_, to_char(value_));
END Check_Not_Null;


-- Check_Not_Null
--   Method to check if an attribute is NULL or not.
--   The value is given as a parameter.
@UncheckedAccess
PROCEDURE Check_Not_Null (
   lu_name_ IN VARCHAR2,
   item_    IN VARCHAR2,
   value_   IN DATE )
IS
BEGIN
   Check_Not_Null(lu_name_, item_, to_char(value_));
END Check_Not_Null;


-- Check_Not_Null
--   Method to check if an attribute is NULL or not.
--   The value is given as a parameter.
@UncheckedAccess
PROCEDURE Check_Not_Null (
   lu_name_ IN VARCHAR2,
   item_    IN VARCHAR2,
   value_   IN TIMESTAMP_UNCONSTRAINED )
IS
BEGIN
   Check_Not_Null(lu_name_, item_, to_char(value_));
END Check_Not_Null;


@UncheckedAccess
PROCEDURE Check_Null (
   lu_name_ IN VARCHAR2,
   item_    IN VARCHAR2,
   value_   IN VARCHAR2 )
IS
   temp_ VARCHAR2(100);
BEGIN
   IF (value_ IS NOT NULL) THEN
      temp_ := Nls_Lu_Prompt___(lu_name_);
      Error_SYS.Item_Format(service_, NULL, NULL, 'NOTNULLVALUE: Field [:P1] is a system generated value  for :P2 and cannot be set to value :P3.', item_, temp_, value_);
   END IF;
END Check_Null;


@UncheckedAccess
PROCEDURE Check_Null (
   lu_name_ IN VARCHAR2,
   item_    IN VARCHAR2,
   value_   IN NUMBER )
IS
BEGIN
   Check_Null(lu_name_, item_, to_char(value_));
END Check_Null;


@UncheckedAccess
PROCEDURE Check_Null (
   lu_name_ IN VARCHAR2,
   item_    IN VARCHAR2,
   value_   IN DATE )
IS
BEGIN
   Check_Null(lu_name_, item_, to_char(value_));
END Check_Null;


@UncheckedAccess
PROCEDURE Check_Null (
   lu_name_ IN VARCHAR2,
   item_    IN VARCHAR2,
   value_   IN TIMESTAMP_UNCONSTRAINED )
IS
BEGIN
   Check_Null(lu_name_, item_, to_char(value_));
END Check_Null;


-- Check_No_Update
--   Method to check if an attribute is updated or not.
--   The old and the new values are given as parameters.
@UncheckedAccess
PROCEDURE Check_No_Update (
   lu_name_   IN VARCHAR2,
   item_      IN VARCHAR2,
   new_value_ IN VARCHAR2,
   old_value_ IN VARCHAR2 )
IS
BEGIN
   IF (( old_value_ IS NULL) AND ( new_value_ IS NOT NULL))
      OR (( new_value_ IS NULL) AND ( old_value_ IS NOT NULL))
      OR ( new_value_ != old_value_) THEN
         Item_Update(lu_name_, item_);
   END IF;
END Check_No_Update;


-- Check_No_Update
--   Method to check if an attribute is updated or not.
--   The old and the new values are given as parameters.
@UncheckedAccess
PROCEDURE Check_No_Update (
   lu_name_   IN VARCHAR2,
   item_      IN VARCHAR2,
   new_value_ IN NUMBER,
   old_value_ IN NUMBER )
IS
BEGIN
   IF (( old_value_ IS NULL) AND ( new_value_ IS NOT NULL))
      OR (( new_value_ IS NULL) AND ( old_value_ IS NOT NULL))
      OR ( new_value_ != old_value_) THEN
         Item_Update(lu_name_, item_);
   END IF;
END Check_No_Update;


-- Check_No_Update
--   Method to check if an attribute is updated or not.
--   The old and the new values are given as parameters.
@UncheckedAccess
PROCEDURE Check_No_Update (
   lu_name_   IN VARCHAR2,
   item_      IN VARCHAR2,
   new_value_ IN DATE,
   old_value_ IN DATE )
IS
BEGIN
   IF (( old_value_ IS NULL) AND ( new_value_ IS NOT NULL))
      OR (( new_value_ IS NULL) AND ( old_value_ IS NOT NULL))
      OR ( new_value_ != old_value_) THEN
         Item_Update(lu_name_, item_);
   END IF;
END Check_No_Update;


-- Check_No_Update
--   Method to check if an attribute is updated or not.
--   The old and the new values are given as parameters.
@UncheckedAccess
PROCEDURE Check_No_Update (
   lu_name_   IN VARCHAR2,
   item_      IN VARCHAR2,
   new_value_ IN TIMESTAMP_UNCONSTRAINED,
   old_value_ IN TIMESTAMP_UNCONSTRAINED )
IS
BEGIN
   IF (( old_value_ IS NULL) AND ( new_value_ IS NOT NULL))
      OR (( new_value_ IS NULL) AND ( old_value_ IS NOT NULL))
      OR ( new_value_ != old_value_) THEN
         Item_Update(lu_name_, item_);
   END IF;
END Check_No_Update;


-- Check_Update_If_Null
--   Method to check if an attribute is updated from NULL or not.
--   The old and the new values are given as parameters.
@UncheckedAccess
PROCEDURE Check_Update_If_Null (
   lu_name_   IN VARCHAR2,
   item_      IN VARCHAR2,
   new_value_ IN VARCHAR2,
   old_value_ IN VARCHAR2 )
IS
BEGIN
   IF (( new_value_ IS NULL) AND ( old_value_ IS NOT NULL))
   OR ( new_value_ != old_value_) THEN
      Item_Update_If_Null(lu_name_, item_);
   END IF;
END Check_Update_If_Null;


-- Check_Update_If_Null
--   Method to check if an attribute is updated from NULL or not.
--   The old and the new values are given as parameters.
@UncheckedAccess
PROCEDURE Check_Update_If_Null (
   lu_name_   IN VARCHAR2,
   item_      IN VARCHAR2,
   new_value_ IN NUMBER,
   old_value_ IN NUMBER )
IS
BEGIN
   IF (( new_value_ IS NULL) AND ( old_value_ IS NOT NULL))
   OR ( new_value_ != old_value_) THEN
      Item_Update_If_Null(lu_name_, item_);
   END IF;
END Check_Update_If_Null;


-- Check_Update_If_Null
--   Method to check if an attribute is updated from NULL or not.
--   The old and the new values are given as parameters.
@UncheckedAccess
PROCEDURE Check_Update_If_Null (
   lu_name_   IN VARCHAR2,
   item_      IN VARCHAR2,
   new_value_ IN DATE,
   old_value_ IN DATE )
IS
BEGIN
   IF (( new_value_ IS NULL) AND ( old_value_ IS NOT NULL))
   OR ( new_value_ != old_value_) THEN
      Item_Update_If_Null(lu_name_, item_);
   END IF;
END Check_Update_If_Null;


-- Check_Update_If_Null
--   Method to check if an attribute is updated from NULL or not.
--   The old and the new values are given as parameters.
@UncheckedAccess
PROCEDURE Check_Update_If_Null (
   lu_name_   IN VARCHAR2,
   item_      IN VARCHAR2,
   new_value_ IN TIMESTAMP_UNCONSTRAINED,
   old_value_ IN TIMESTAMP_UNCONSTRAINED )
IS
BEGIN
   IF (( new_value_ IS NULL) AND ( old_value_ IS NOT NULL))
   OR ( new_value_ != old_value_) THEN
      Item_Update_If_Null(lu_name_, item_);
   END IF;
END Check_Update_If_Null;


@UncheckedAccess
PROCEDURE Check_Lower (
   lu_name_   IN VARCHAR2,
   label_     IN VARCHAR2,
   value_     IN VARCHAR2 )
IS
   cause_     VARCHAR2(2000);
BEGIN
   IF (value_ != Lower(value_)) THEN 
      cause_ := Language_SYS.Translate_Constant(lu_name_, 'FORMAT_LOWERCASE: Should be in lowercase.');
      Fnd_Item_Format(lu_name_, label_, value_, cause_);
   END IF;
END Check_Lower;


@UncheckedAccess
PROCEDURE Check_Upper (
   lu_name_   IN VARCHAR2,
   label_     IN VARCHAR2,
   value_     IN VARCHAR2 )
IS
   cause_     VARCHAR2(2000);
BEGIN
   IF (value_ != Upper(value_)) THEN 
      cause_ := Language_SYS.Translate_Constant(lu_name_, 'FORMAT_UPPERCASE: Should be in uppercase.');
      Fnd_Item_Format(lu_name_, label_, value_, cause_);
   END IF;
END Check_Upper;

@UncheckedAccess
PROCEDURE Check_Date_Truncated (
   lu_name_   IN VARCHAR2,
   label_     IN VARCHAR2,
   value_     IN DATE )
IS
   cause_     VARCHAR2(2000);
BEGIN
   IF (value_ != Trunc(value_)) THEN 
      cause_ := Language_SYS.Translate_Constant(lu_name_, 'DATE_TRUNCATED: Date must be without time.');
      Fnd_Item_Format(lu_name_, label_, Database_SYS.Get_Formatted_Datetime(value_), cause_);
   END IF;
END Check_Date_Truncated;


@UncheckedAccess
PROCEDURE Check_Valid_Key_String (
   key_name_   IN VARCHAR2,
   key_value_  IN VARCHAR2 )
IS
   -- NOTE!!! Client_SYS.Text_Separator must not be the first character in the pattern
   --         since caret means negation in Regular Expression.
   --
   -- Client_SYS constants can not be used in Key attributes,
   -- this leads to errors in Client_SYS methods.
   --
   separator_pattern_  CONSTANT VARCHAR2(10) :=  '['||
                                       Client_SYS.field_separator_||
                                       Client_SYS.record_separator_||
                                       Client_SYS.group_separator_||
                                       Client_SYS.file_separator_||
                                       Client_SYS.text_separator_||
                                       ']';
                                       
  disallowed_new_line_char_seq_ VARCHAR2(10) := '';                                    
   -- Hndle the user supplies keys
   validate_key_string_ VARCHAR2(32000);
   reg_exp_ VARCHAR2(32000);

   char_     VARCHAR2(20) := NULL;
   location_ VARCHAR2(5);
BEGIN
   validate_key_string_ := Fnd_Setting_Api.Get_Value('KEY_STRING_VALIDATE', Installation_SYS.Get_Installation_Mode);
   IF(instr(validate_key_string_,line_feed_marker_)>0) THEN
      disallowed_new_line_char_seq_ := disallowed_new_line_char_seq_ || line_feed_;
      validate_key_string_ := replace(validate_key_string_, line_feed_marker_);
   END IF;
   IF (instr(validate_key_string_,carriage_return_marker_)>0) THEN
      disallowed_new_line_char_seq_ := disallowed_new_line_char_seq_ || carriage_return_;
      validate_key_string_ := replace(validate_key_string_, carriage_return_marker_);
   END IF;
   IF (length(disallowed_new_line_char_seq_) > 0 ) THEN 
      char_ := regexp_substr(key_value_, '['||disallowed_new_line_char_seq_||']');
      IF char_ IS NOT NULL THEN
         Error_SYS.Item_Format(service_, NULL, NULL, 'INVALIDKEYVALUENEWLINE: Newline character is not allowed as key value [:P1].', key_name_);
      END IF;
   END IF;
   IF validate_key_string_ != '*' THEN
      reg_exp_ := Get_Key_Reg_Exp___(validate_key_string_);
      char_ := regexp_substr(key_value_, reg_exp_);
      IF char_ IS NOT NULL THEN
         Error_SYS.Item_Format(service_, NULL, NULL, 'INVALIDKEYVALUE2: Character [:P1] is not allowed as key value [:P2].', char_, key_name_);
      END IF;
   END IF;

   char_ := regexp_substr(key_value_, separator_pattern_);
   IF char_ IS NOT NULL THEN
         Error_SYS.Item_Format(service_, NULL, NULL, 'INVALIDKEYVALUE: Illegal character in key value [:P1].', key_name_);
   END IF;
   location_ := Get_Space_Validation___(key_value_);
   IF location_ = 'RIGHT' THEN
      Error_SYS.Item_Format(service_, NULL, NULL, 'INVALIDKEYVALUE3: Trailing spaces are not allowed in key value [:P1].', key_name_);
   ELSIF location_ = 'LEFT' THEN
      Error_SYS.Item_Format(service_, NULL, NULL, 'INVALIDKEYVALUE4: Leading spaces are not allowed in key value [:P1].', key_name_);
   END IF;
END Check_Valid_Key_String;


@UncheckedAccess
PROCEDURE Check_Valid_Identifier (
   name_  IN VARCHAR2,
   value_ IN VARCHAR2)
IS
   separator_pattern_ CONSTANT VARCHAR2(10) := '['||
                                          Client_SYS.field_separator_||
                                          Client_SYS.record_separator_||
                                          Client_SYS.group_separator_||
                                          Client_SYS.file_separator_||
                                          ']';

   char_pattern_ CONSTANT VARCHAR2(20) := '[^[:alnum:]_]';

   start_char_pattern_ CONSTANT VARCHAR2(20) := '^[[:digit:]_]';

   char_ VARCHAR2(2);
BEGIN
   char_ := regexp_substr(value_, separator_pattern_);
   IF char_ IS NOT NULL THEN
      Error_SYS.Item_Format(service_, NULL, NULL, 'INVALIDIDENTIFIER1: Illegal character in value [:P1].', name_);
   ELSE
      char_ := regexp_substr(value_, char_pattern_);
      IF char_ IS NOT NULL THEN
         Error_SYS.Item_Format(service_, NULL, NULL, 'INVALIDIDENTIFIER2: Character [:P1] is not allowed in value [:P2].', char_, name_);
      ELSE
         char_ := regexp_substr(value_, start_char_pattern_);
         IF char_ IS NOT NULL THEN
            Error_SYS.Item_Format(service_, NULL, NULL, 'INVALIDIDENTIFIER3: Character [:P1] is not allowed at the begining in value [:P2].', char_, name_);
         END IF;
      END IF;
   END IF;
END Check_Valid_Identifier;


@UncheckedAccess
PROCEDURE Trim_Space_Validation (
   value_ IN VARCHAR2)
IS
   location_ VARCHAR2(5);
BEGIN
   location_ := Get_Space_Validation___(value_);
   IF location_ = 'LEFT' THEN
      Error_SYS.Item_Format(service_, NULL, NULL, 'INVALIDLEFTSPACE: Leading spaces are not allowed in value [:P1].', value_);
   ELSIF location_ = 'RIGHT' THEN
      Error_SYS.Item_Format(service_, NULL, NULL, 'INVALIDRIGTSPACE: Trailing spaces are not allowed in value [:P1].', value_);
   END IF;
END Trim_Space_Validation;


-- State_General
--   General error method for state events with user defined messages.
@UncheckedAccess
PROCEDURE State_General (
   lu_name_  IN VARCHAR2,
   err_text_ IN VARCHAR2,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   Raise_Application_Error___(-20130, lu_name_||'.'||text_);
END State_General;


-- State_Not_Exist
--   Message when unidentified finite state is found.
@UncheckedAccess
PROCEDURE State_Not_Exist (
   lu_name_  IN VARCHAR2,
   state_    IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      text_ := Nls_Msg___(lu_name_, 'NOTEVENT: State ":STATE" is not valid for :LU.',service_name_=>service_);
      text_ := replace(text_, ':STATE', state_);
   END IF;
   Raise_Application_Error___(-20131, lu_name_||'.'||text_);
END State_Not_Exist;


-- State_Event_Not_Handled
--   Message when an event is not handled by current state.
@UncheckedAccess
PROCEDURE State_Event_Not_Handled (
   lu_name_  IN VARCHAR2,
   event_    IN VARCHAR2,
   state_    IN VARCHAR2,
   err_text_ IN VARCHAR2 DEFAULT NULL,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF (err_text_ IS NOT NULL) THEN
      text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   ELSE
      IF p1_ IS NOT NULL THEN
         text_ := Nls_Msg___(lu_name_, 'NOTHANDLED: The operation ":EVENT" is not allowed for :LU ":P1" which is in state ":STATE".', p1_,service_name_=>service_);
      ELSE
         text_ := Nls_Msg___(lu_name_, 'NOTHANDLED2: The operation ":EVENT" is not allowed for :LU objects in state ":STATE".',service_name_=>service_);
      END IF;
      text_ := replace(text_, ':EVENT', event_);
      text_ := replace(text_, ':STATE', state_);
   END IF;
   Raise_Application_Error___(-20132, lu_name_||'.'||text_);
END State_Event_Not_Handled;


@UncheckedAccess
PROCEDURE Projection_General (
   lu_name_  IN VARCHAR2,
   err_text_ IN VARCHAR2,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Nls_Msg___(lu_name_, err_text_, p1_, p2_, p3_,service_name_=>service_);
   Raise_Application_Error___(-20170, lu_name_||'.'||text_);
END Projection_General;


@UncheckedAccess
PROCEDURE Projection_Not_Exist (
   lu_name_         IN VARCHAR2,
   projection_name_ IN VARCHAR2 )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Nls_Translate___(lu_name_, 'Projection_Not_Exist: The projection [:P1] does not exist.', Fnd_Session_API.Get_Language, projection_name_, service_name_=>service_);
   Raise_Application_Error___(-20171, lu_name_||'.'||text_);
END Projection_Not_Exist;


@UncheckedAccess
PROCEDURE Projection_Category (
   lu_name_         IN VARCHAR2,
   projection_name_ IN VARCHAR2,
   category_        IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF category_ IS NULL THEN 
      text_ := Nls_Translate___(lu_name_, 'Projection_Category: The projection [:P1] is not accessible through this endpoint.', Fnd_Session_API.Get_Language, projection_name_, service_name_=>service_);
   ELSE
      text_ := Nls_Translate___(lu_name_, 'Projection_Category2: The projection [:P1] of category [:P2] is not accessible through this endpoint.', Fnd_Session_API.Get_Language, projection_name_, category_, service_name_=>service_);
   END IF;
   Raise_Application_Error___(-20172, lu_name_||'.'||text_);
END Projection_Category;


@UncheckedAccess
PROCEDURE Projection_Group (
   lu_name_         IN VARCHAR2,
   projection_name_ IN VARCHAR2,
   group_           IN VARCHAR2 DEFAULT NULL )
IS
   text_ VARCHAR2(2000);
BEGIN
   IF group_ IS NULL THEN 
      text_ := Nls_Translate___(lu_name_, 'Projection_Group: The projection [:P1] is not accessible through this endpoint.', Fnd_Session_API.Get_Language, projection_name_, service_name_=>service_);
   ELSE
      text_ := Nls_Translate___(lu_name_, 'Projection_Group2: The projection [:P1] of service group [:P2] is not accessible through this endpoint.', Fnd_Session_API.Get_Language, projection_name_, group_, service_name_=>service_);
   END IF;
   Raise_Application_Error___(-20173, lu_name_||'.'||text_);
END Projection_Group;


@UncheckedAccess
PROCEDURE Projection_Meta_Not_Exist (
   lu_name_         IN VARCHAR2,
   projection_name_ IN VARCHAR2 )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Nls_Translate___(lu_name_, 'Projection_Meta_Not_Exist: Metadata for projection [:P1] does not exist.', Fnd_Session_API.Get_Language, projection_name_, service_name_=>service_);
   Raise_Application_Error___(-20174, lu_name_||'.'||text_);
END Projection_Meta_Not_Exist;

@UncheckedAccess
PROCEDURE Projection_Meta_Modified (
   lu_name_         IN VARCHAR2,
   projection_name_ IN VARCHAR2 )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Nls_Translate___(lu_name_, 'Projection_Meta_Modified: Metadata for projection [:P1] has been modified.', Fnd_Session_API.Get_Language, projection_name_, service_name_=>service_);
   Raise_Application_Error___(-20175, lu_name_||'.'||text_);
END Projection_Meta_Modified;

@UncheckedAccess
PROCEDURE Odp_Record_Not_Exist (
   lu_name_         IN VARCHAR2 )
IS
   text_ VARCHAR2(2000);
BEGIN
   text_ := Nls_Translate___(lu_name_, 'ODP_RECORD_NOT_EXIST: The :LU object does not exist.', Fnd_Session_API.Get_Language,service_name_=>service_);
   Raise_Application_Error___(-20180, lu_name_||'.'||text_);
END Odp_Record_Not_Exist;


-- Is_Foundation_Error
--   Return true if an error occurred through system service Error_SYS
@UncheckedAccess
FUNCTION Is_Foundation_Error (
   oracle_no_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN oracle_no_ BETWEEN -20199 AND -20100;
END Is_Foundation_Error;


@UncheckedAccess
FUNCTION Strip_Ora_Error (
   sqlerrm_        IN VARCHAR2,
   sqlcode_        IN NUMBER DEFAULT NULL,
   strip_ora_only_ IN BOOLEAN DEFAULT FALSE,
   keep_non_fnd_   IN BOOLEAN DEFAULT TRUE) RETURN VARCHAR2 
IS
   lsqlcode_ NUMBER;
BEGIN
   IF (sqlcode_ IS NULL AND sqlerrm_ LIKE 'ORA-%') THEN
      lsqlcode_ := to_number(SUBSTR(sqlerrm_, 4, INSTR(sqlerrm_, ':') - 4));
   ELSE
      lsqlcode_ := sqlcode_;
   END IF;
   IF (lsqlcode_ IS NOT NULL) THEN
      IF (Is_Foundation_Error(lsqlcode_)) THEN
         IF (strip_ora_only_) THEN
            -- Remove 'ORA-xyz: ' but keep 'LuName.ERROR_NAME: '
            RETURN trim(SUBSTR(sqlerrm_, INSTR(sqlerrm_, ':') + 2));
         ELSE
            -- Remove 'ORA-xyz: ' and 'LuName.ERROR_NAME: '
            RETURN trim(SUBSTR(sqlerrm_, INSTR(sqlerrm_, ':', 1, 2) + 2));
         END IF;
      ELSE
         IF (keep_non_fnd_) THEN
            -- Keep 'ORA-xyz: '
            RETURN trim(sqlerrm_);
         ELSE
            -- Remove 'ORA-xyz: '
            RETURN trim(SUBSTR(sqlerrm_, INSTR(sqlerrm_, ':') + 2));
         END IF;
      END IF;
   ELSE
      RETURN trim(sqlerrm_);
   END IF;
END Strip_Ora_Error;

PROCEDURE Set_Key_Values (
   key_message_ IN VARCHAR2,
   formatted_keys_ IN VARCHAR2 )
IS
BEGIN
   Fnd_Context_SYS.Set_Value('ERROR_KEY_MESSAGE', key_message_);
   Fnd_Context_SYS.Set_Value('ERROR_FORMATTED_KEY', formatted_keys_);
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Key values', formatted_keys_);
END Set_Key_Values;

