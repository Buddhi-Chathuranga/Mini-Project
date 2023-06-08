-----------------------------------------------------------------------------
--
--  Logical unit: FndObjSubscriptionUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------
TYPE conditional_columns_type IS TABLE OF fnd_obj_subscrip_column_tab%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE array_of_characters  IS TABLE OF VARCHAR2(30) INDEX BY VARCHAR2(30);

TYPE subscription_col_info IS RECORD (subscription_id NUMBER, 
                                  username VARCHAR2(30),
                                  send_email VARCHAR2(10),
                                  self_notify VARCHAR2(10),
                                  one_time VARCHAR2(10),
                                  client_url VARCHAR2(4000),
                                  client_view VARCHAR2(30),
                                  notes VARCHAR2(4000),
                                  column_name VARCHAR2(30),
                                  condition VARCHAR2(4000),
                                  subscription_header VARCHAR2(2000),
                                  display_name VARCHAR2(4000),
                                  column_path VARCHAR2(4000),                                  
                                  web_url VARCHAR2(4000));
                                  
TYPE subscription_col_info_tab_type IS TABLE OF subscription_col_info INDEX BY BINARY_INTEGER;

TYPE subscription_info IS RECORD (subscription_id NUMBER, 
                                  username VARCHAR2(30),
                                  send_email VARCHAR2(10),
                                  self_notify VARCHAR2(10),
                                  one_time VARCHAR2(10),
                                  client_url VARCHAR2(4000),
                                  client_view VARCHAR2(30),
                                  notes VARCHAR2(4000),
                                  subscription_header VARCHAR2(2000),
                                  web_url VARCHAR2(4000));

TYPE subscription_info_tab_type IS TABLE OF subscription_info INDEX BY BINARY_INTEGER;

TYPE changed_col_values_type  IS TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(30);
TYPE asserted_views           IS TABLE OF NUMBER INDEX BY VARCHAR2(30);
TYPE cached_col_info          IS TABLE OF VARCHAR2(30) INDEX BY VARCHAR2(100);

TYPE stream_rec_type IS RECORD (stream fnd_stream_tab%ROWTYPE, send_email VARCHAR2(10), self_notify VARCHAR2(10), one_time VARCHAR2(10), subscription_id NUMBER, client_view VARCHAR2(30), has_info BOOLEAN);
TYPE streams_tab     IS TABLE OF stream_rec_type INDEX BY BINARY_INTEGER;

newline_      CONSTANT VARCHAR2(10) := chr(10);
log_category_ CONSTANT VARCHAR2(100) := 'Server Errors';

TAG_ATTR_INFO   CONSTANT VARCHAR2(10) := '$ATTRINFO';
TAG_VIEW_INFO   CONSTANT VARCHAR2(10) := '$V_N';
TAG_COL_NAME    CONSTANT VARCHAR2(10) := '$COL_N';
TAG_DIS_NAME    CONSTANT VARCHAR2(10) := '$DIS_N';
TAG_COL_PATH    CONSTANT VARCHAR2(10) := '$COL_P';
TAG_PROG        CONSTANT VARCHAR2(10) := '$PROG';
TAG_MOD1        CONSTANT VARCHAR2(10) := '$MOD1';
TAG_MOD2        CONSTANT VARCHAR2(10) := '$MOD2';
TAG_SET         CONSTANT VARCHAR2(10) := '$SET';
TAG_UNSET       CONSTANT VARCHAR2(10) := '$UNSET';
TAG_OBJ_CHANGED CONSTANT VARCHAR2(10) := '$CHANGED';
TAG_OBJ_REMOVED CONSTANT VARCHAR2(10) := '$REM';
TAG_SUB_RENEW   CONSTANT VARCHAR2(10) := '$RENEW';
TAG_FIELD       CONSTANT VARCHAR2(10) := '$FIELD';
TAG_OBJTRK_MESSAGE CONSTANT VARCHAR2(10) := 'OBJTRKMSG';
TAG_LU_NAME   CONSTANT VARCHAR2(10) := '$LU';
TAG_VIEW_NAME CONSTANT VARCHAR2(10) := '$V_N';
TAG_FROM      CONSTANT VARCHAR2(10) := '$FROM';
TAG_P1        CONSTANT VARCHAR2(10) := '$P1';
TAG_P2        CONSTANT VARCHAR2(10) := '$P2';
TAG_P3        CONSTANT VARCHAR2(10) := '$P3';
TAG_REF       CONSTANT VARCHAR2(10) := '$REF';
TAG_DTYPE     CONSTANT VARCHAR2(10) := '$DTYPE';
TAG_JOB       CONSTANT VARCHAR2(10) := '$JOB';
TAG_CONDITION CONSTANT VARCHAR2(10) := '$CONDITION';
TAG_HEADER_TRANCONSTANT CONSTANT VARCHAR2(20) := '$TRANSCONTANT';
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Is_Object_Available___  (
   view_name_ IN VARCHAR2,
   objkey_    IN VARCHAR2,
   fnd_user_  IN VARCHAR2) RETURN BOOLEAN
IS
   stmt_  VARCHAR2(1000);
   dummy_ NUMBER;
BEGIN
   Fnd_Session_API.Impersonate_Fnd_User(fnd_user_);
   -- Assert Is View should be done ealier.   
   stmt_ := 'SELECT 1 FROM '||view_name_||' WHERE OBJKEY = '''||objkey_||'''';
   @ApproveDynamicStatement(2014-10-07,wawilk)
   EXECUTE IMMEDIATE stmt_ INTO dummy_;
   Fnd_Session_API.Reset_Fnd_User;
   RETURN dummy_ = 1;   
EXCEPTION
   WHEN OTHERS THEN
      BEGIN
         Fnd_Session_API.Reset_Fnd_User;
      EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line(SQLERRM);
      END;
      RETURN FALSE;
END Is_Object_Available___;
   
FUNCTION Is_Po_Available___  (
   po_       IN VARCHAR2,
   fnd_user_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_ BOOLEAN := FALSE;
BEGIN
   Fnd_Session_API.Impersonate_Fnd_User(fnd_user_);
   dummy_ := Security_SYS.Is_Pres_Object_Available(po_);
   Fnd_Session_API.Reset_Fnd_User;
   
   RETURN dummy_ ;
EXCEPTION
   WHEN OTHERS THEN
      BEGIN
         Fnd_Session_API.Reset_Fnd_User;
      EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line(SQLERRM);
      END;
      RETURN FALSE;
END Is_Po_Available___;

FUNCTION Get_Subscrib_Users_Col_Det___ (
   lu_name_ IN VARCHAR2,
   objkey_  IN VARCHAR2 ) RETURN subscription_col_info_tab_type
IS
   users_ subscription_col_info_tab_type;
   --SOLSETFW
   CURSOR get_users IS
      SELECT t.subscription_id, username, send_email, self_notify, one_time, client_url, t.client_view, notes,
             c.subscription_column, c.condition, t.subscription_header, c.display_name, c.column_path, t.web_url
      FROM fnd_obj_subscription_tab t, fnd_obj_subscrip_column_tab c, dictionary_sys_tab d, module_tab m
      WHERE t.lu_name = lu_name_
      AND t.lu_name = d.lu_name AND d.module = m.module AND m.active = 'TRUE'
      AND sub_objkey = objkey_
      AND t.subscription_id = c.subscription_id
      AND t.disabled = 'FALSE'
      ORDER BY username;
BEGIN
   OPEN get_users;
   FETCH get_users BULK COLLECT INTO users_;
   CLOSE get_users;
   RETURN users_;
END Get_Subscrib_Users_Col_Det___;

FUNCTION Get_Subscrib_Users___ (
   lu_name_ IN VARCHAR2,
   objkey_  IN VARCHAR2 ) RETURN subscription_info_tab_type
IS
   users_ subscription_info_tab_type;
   CURSOR get_users IS
      SELECT subscription_id, username, send_email, self_notify, one_time, client_url, t.client_view, notes, 
             t.subscription_header, t.web_url 
      FROM fnd_obj_subscription_tab t
      WHERE lu_name = lu_name_
      AND sub_objkey = objkey_
      AND disabled = 'FALSE';
BEGIN
   OPEN get_users;
   FETCH get_users BULK COLLECT INTO users_;
   CLOSE get_users;
   RETURN users_;
END Get_Subscrib_Users___;

FUNCTION Convert_To_Dict___(
   count_      NUMBER,
   col_names_  Message_SYS.name_table,
   col_values_ Message_SYS.line_table ) RETURN changed_col_values_type
IS
   dict_ changed_col_values_type;
BEGIN
   FOR i_ IN 1..count_ LOOP
      dict_(col_names_(i_)) := col_values_(i_);
   END LOOP;
   RETURN dict_;
END Convert_To_Dict___;

FUNCTION Append_Names___ (
   tab1_ IN Message_SYS.name_table,
   tab2_ IN Message_SYS.name_table) RETURN Message_SYS.name_table
IS
   tmp_ Message_SYS.name_table;
BEGIN
   IF tab1_ IS NULL AND tab2_ IS NULL THEN
      RETURN tmp_;
   ELSIF tab1_ IS NULL THEN
      RETURN tab2_;
   ELSIF tab2_ IS NULL THEN
      RETURN tab1_;
   ELSE  
      tmp_ := tab1_;

      FOR i_ IN 1..tab2_.COUNT LOOP
         tmp_(tmp_.COUNT+1) := tab2_(i_);
      END LOOP;
   END IF;
   RETURN tmp_;
END Append_Names___;

FUNCTION Append_Values___ (
   tab1_ IN Message_SYS.line_table,
   tab2_ IN Message_SYS.line_table) RETURN Message_SYS.line_table
IS
   tmp_ Message_SYS.line_table;
BEGIN
   IF tab1_ IS NULL AND tab2_ IS NULL THEN
      RETURN tmp_;
   ELSIF tab1_ IS NULL THEN
      RETURN tab2_;
   ELSIF tab2_ IS NULL THEN
      RETURN tab1_;
   ELSE  
      tmp_ := tab1_;

      FOR i_ IN 1..tab2_.COUNT LOOP
         tmp_(tmp_.COUNT+1) := tab2_(i_);
      END LOOP;
   END IF;
   RETURN tmp_;
END Append_Values___;

FUNCTION Get_Value___(
   dict_  changed_col_values_type,
   name_  IN VARCHAR2,
   value_ OUT VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   value_ := dict_(name_);
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      value_ := NULL;
      RETURN FALSE;
END Get_Value___;


PROCEDURE Create_Stream_Msg___(
   stream_rec_ IN OUT fnd_stream_tab%ROWTYPE)
IS
   -- PRAGMA autonomous_transaction;
BEGIN
   -- Remove trailing new_lines;
   stream_rec_.message := RTRIM(stream_rec_.message, newline_);
   stream_rec_.read        := Fnd_Boolean_API.DB_FALSE;
   stream_rec_.visible     := Fnd_Boolean_API.DB_TRUE;
   Fnd_Stream_API.New_Stream_Item(stream_rec_);
   -- --@ApproveTransactionStatement(2014/06/13,chmulk)
   --  COMMIT;
END Create_Stream_Msg___;

PROCEDURE Bulk_Cleanup_User_(
   method_ IN VARCHAR2)
IS
BEGIN
   IF (method_ = 'HIDDEN') THEN
      -- Delete all hidden for current user
      DELETE FROM fnd_stream_tab
      WHERE visible = Fnd_Boolean_API.DB_FALSE
      AND to_user = Fnd_Session_API.Get_Fnd_User;
   ELSIF (method_ = 'READ') THEN
      -- Delete all read for current user
      DELETE FROM fnd_stream_tab
      WHERE read = Fnd_Boolean_API.DB_TRUE
      AND to_user = Fnd_Session_API.Get_Fnd_User;
  ELSIF (method_ = 'OLD') THEN
      -- Delete all older than 30 days for current user
      DELETE FROM fnd_stream_tab
      WHERE trunc(created_date) <= trunc(sysdate) - 30 
      AND to_user = Fnd_Session_API.Get_Fnd_User;
  END IF;
END Bulk_Cleanup_User_;

PROCEDURE Bulk_Update_User_(
   method_ IN VARCHAR2)
IS
BEGIN
   IF (method_ = 'UNREAD') THEN
      -- Mark All as unread
      UPDATE fnd_stream_tab t
      SET read = Fnd_Boolean_API.DB_FALSE
      WHERE to_user = Fnd_Session_API.Get_Fnd_User;
   ELSIF (method_ = 'READ') THEN
      -- Mark All as read
      UPDATE fnd_stream_tab t
      SET read = Fnd_Boolean_API.DB_TRUE
      WHERE to_user = Fnd_Session_API.Get_Fnd_User;
  ELSIF (method_ = 'HIDE') THEN
      -- Mark All as hidden
      UPDATE fnd_stream_tab t
      SET visible = Fnd_Boolean_API.DB_FALSE
      WHERE to_user = Fnd_Session_API.Get_Fnd_User;
  END IF;
END Bulk_Update_User_;
   
PROCEDURE Send_Email___(
   stream_rec_   IN fnd_stream_tab%ROWTYPE,
   change_type_  IN VARCHAR2 )
IS
   email_msg_ VARCHAR2(32000);
   ext_url_ VARCHAR2(1000) := Fnd_Setting_API.Get_Value('SYSTEM_URL')||'/client/runtime/Ifs.Fnd.Explorer.application?url=';
   subject_ VARCHAR2(2000);
   header_  VARCHAR2(2000);
   fields_changed_ VARCHAR2(200);
   fields_info_    VARCHAR2(32000);
   note_ VARCHAR2(100);
   lang_code_ VARCHAR2(10) := Fnd_User_API.Get_Recursive_Property_(stream_rec_.to_user, 'PREFERRED_LANGUAGE');
BEGIN
   IF change_type_ = 'D' THEN
      subject_ := Language_SYS.Translate_Constant(lu_name_, 'MAILSUBREM: :P1 Removed.' , lang_code_, stream_rec_.header);
   ELSE
      subject_ := Language_SYS.Translate_Constant(lu_name_, 'MAILSUB: :P1 Changed.' , lang_code_, stream_rec_.header);
      header_  := Language_SYS.Translate_Constant(lu_name_, 'MAILHEADER: The following :P1 has changed.' , lang_code_, Language_SYS.Translate_Lu_Prompt_(stream_rec_.lu_name, lang_code_));
      fields_changed_ := Language_SYS.Translate_Constant(lu_name_, 'MAILFIELDS: Field(s) which were changed.', lang_code_);
   END IF;
   
   note_ := Language_SYS.Translate_Constant(lu_name_, 'MAILNOTES: Notes: ', lang_code_);
   
   IF header_ IS NOT NULL THEN
      email_msg_ := header_ || newline_;
   END IF;
         
   IF stream_rec_.url IS NOT NULL THEN
      email_msg_ := email_msg_ || ext_url_|| utl_url.escape(stream_rec_.url,TRUE) || newline_ || newline_;
   END IF;
   
   fields_info_ := Get_Translated_Msg(stream_rec_.message, 'TRUE', lang_code_);
   
   IF fields_info_ IS NOT NULL THEN
      email_msg_ := email_msg_ || fields_changed_ || newline_ ||
                    rpad('-',50,'-')|| newline_ ||
                    fields_info_ ||
                    rpad('-',50,'-')|| newline_ ;
   END IF;
                 
   IF stream_rec_.notes IS NOT NULL THEN
      email_msg_ := email_msg_ || note_ || stream_rec_.notes;
   END IF;
   
   Command_SYS.Mail(stream_rec_.from_user, stream_rec_.to_user, email_msg_, subject_ => subject_); 
END Send_Email___;

FUNCTION Create_Tagged_Line___ (
   tag_ IN VARCHAR2,
   p1_  IN VARCHAR2 DEFAULT NULL,
   p2_  IN VARCHAR2 DEFAULT NULL,
   p3_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   msg_ VARCHAR2(1000);
BEGIN
   msg_ := Message_SYS.Construct(tag_);
   CASE tag_ 
   WHEN TAG_SET THEN
      Message_SYS.Add_Attribute(msg_, TAG_P1, p1_);
      Message_SYS.Add_Attribute(msg_, TAG_P2, p2_);
   WHEN TAG_UNSET THEN
      Message_SYS.Add_Attribute(msg_, TAG_P1, p1_);
      Message_SYS.Add_Attribute(msg_, TAG_P2, p2_);
   WHEN TAG_OBJ_REMOVED THEN
      -- Special handling for Removed Object
      Message_SYS.Add_Attribute(msg_, TAG_P1, p2_);
   WHEN TAG_MOD1 THEN
      Message_SYS.Add_Attribute(msg_, TAG_P1, p1_);
      Message_SYS.Add_Attribute(msg_, TAG_P2, p2_);
      Message_SYS.Add_Attribute(msg_, TAG_P3, p3_);
   WHEN TAG_MOD2 THEN
      Message_SYS.Add_Attribute(msg_, TAG_P1, p1_);
   WHEN TAG_SUB_RENEW THEN
      Message_SYS.Add_Attribute(msg_, TAG_P1, p2_);
   WHEN TAG_JOB THEN
      Message_SYS.Add_Attribute(msg_, TAG_P2, p2_);
      Message_SYS.Add_Attribute(msg_, TAG_P3, p3_);
   WHEN TAG_OBJ_CHANGED THEN
      NULL;   
   END CASE;

   RETURN msg_;
END Create_Tagged_Line___;

PROCEDURE Append_Node___ (
   main_    IN OUT CLOB,
   child_   IN CLOB,
   counter_ IN NUMBER)
IS
BEGIN  
   Message_SYS.Add_Clob_Attribute(main_, TAG_FIELD||counter_, child_);
END Append_Node___;

FUNCTION Get_Iid_Info___ (
   view_name_      IN VARCHAR2,
   column_name_    IN VARCHAR2,
   list_attribute_ IN BOOLEAN) RETURN VARCHAR2
IS
   enum_lu_ VARCHAR2(30);
BEGIN
   IF column_name_ = 'ROWSTATE' THEN
      RETURN Dictionary_SYS.Get_State_Decode_Method_(view_name_);
   -- Check if the column is the OBJSTATE column of the LU
   ELSIF column_name_ = UPPER(Dictionary_SYS.Get_Table_Column_Impl(view_name_, 'OBJSTATE')) THEN
      RETURN Dictionary_SYS.Get_State_Decode_Method_(view_name_);
   ELSE
      enum_lu_ := Dictionary_SYS.Get_Enumeration_Lu(view_name_, column_name_);
      IF enum_lu_ IS NULL THEN
         enum_lu_ := Dictionary_SYS.Get_Lookup_Lu(view_name_, column_name_);
      END IF;
      
      IF enum_lu_ IS NOT NULL THEN
         IF list_attribute_ THEN
            RETURN Dictionary_SYS.Get_Base_Package(enum_lu_)||'.Decode_List';
         ELSE
            RETURN Dictionary_SYS.Get_Base_Package(enum_lu_)||'.Decode';
         END IF;
      END IF;
   END IF;
   RETURN NULL;
END Get_Iid_Info___;

FUNCTION Get_CFV_Name___ (
   lu_name_ IN VARCHAR2,
   view_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cf_view_name_ VARCHAR2(30) := view_name_;
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      BEGIN
         SELECT cf_view_name INTO cf_view_name_
           FROM custom_field_views_tab
          WHERE lu = lu_name_
            AND view_name = view_name_
            AND lu_type = Custom_Field_Lu_Types_API.DB_CUSTOM_FIELD;
          cf_view_name_ := NVL(cf_view_name_, view_name_);
      EXCEPTION
         WHEN no_data_found THEN
            RETURN NVL(Custom_Fields_API.Get_View_Name(lu_name_, Custom_Field_Lu_Types_API.DB_CUSTOM_FIELD), view_name_);
         WHEN OTHERS THEN
            RETURN view_name_;
      END;
   $END
   RETURN cf_view_name_;
END Get_CFV_Name___;

FUNCTION Attribute_Info_Tag___ (
   subscription_id_ IN NUMBER,
   view_name_    IN VARCHAR2,
   column_name_  IN VARCHAR2,
   display_name_ IN VARCHAR2,
   column_path_  IN VARCHAR2,
   data_type_    IN VARCHAR2 DEFAULT 'V',
   cf_view_name_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   msg_ VARCHAR2(32000);
   prog_text_ VARCHAR2(1000);
   iid_info_ VARCHAR2(100);
   list_attribute_ BOOLEAN := data_type_ = 'L';
BEGIN
   iid_info_  := Get_Iid_Info___(NVL(cf_view_name_,view_name_), column_name_, list_attribute_);
   prog_text_ := Fnd_Obj_Subscrip_Column_API.Get_Column_Text(subscription_id_, column_name_);
   
   msg_ := Message_SYS.Construct(TAG_ATTR_INFO);
   Message_SYS.Add_Attribute(msg_, TAG_REF, iid_info_);
   Message_SYS.Add_Attribute(msg_, TAG_DTYPE, data_type_);
   IF cf_view_name_ IS NOT NULL THEN
      -- This is a Custom Field, set V_N to the actual _CFV view
      Message_SYS.Add_Attribute(msg_, TAG_VIEW_INFO, cf_view_name_);
   END IF;
   Message_SYS.Add_Attribute(msg_, TAG_COL_NAME, column_name_);
   Message_SYS.Add_Attribute(msg_, TAG_PROG, prog_text_);
   Message_SYS.Add_Attribute(msg_, TAG_DIS_NAME, display_name_);
   Message_SYS.Add_Attribute(msg_, TAG_COL_PATH, column_path_);
   RETURN msg_;
END Attribute_Info_Tag___;

FUNCTION Shorten_Msg___ ( 
   user_      IN VARCHAR2,
   lu_        IN VARCHAR2,
   view_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_msg_ VARCHAR2(4000);
   line_     VARCHAR2(4000);
BEGIN
   -- TODO: Implement a trimming mechanism for the stream message
   temp_msg_ := Init_Msg___(user_, lu_, view_name_);
   line_ := Create_Tagged_Line___(TAG_OBJ_CHANGED);
   Append_Node___(temp_msg_, line_, 1);
   RETURN temp_msg_;
END Shorten_Msg___;
  
FUNCTION Finalize_Msg_To_String___ (
   msg_       IN CLOB,
   user_      IN VARCHAR2,
   lu_        IN VARCHAR2,
   view_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   string_msg_ VARCHAR2(4000);
   temp_ NUMBER;
BEGIN
   BEGIN
      string_msg_ := msg_;
   EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE = -06502 THEN
            -- buffer too small
            RETURN Shorten_Msg___(user_, lu_, view_name_);
         ELSE
            -- something else
            RAISE;
         END IF;
   END;
   RETURN string_msg_;
EXCEPTION
   WHEN OTHERS THEN
      temp_ := Server_Log_API.Log_Autonomous(NULL, 'Server Errors', 'Object Tracking Error', 
                                            'Unable to process Stream message for ['||user_||'] ERROR: '||SUBSTR(1,1500));
      string_msg_ := NULL;
END Finalize_Msg_To_String___;

FUNCTION Init_Msg___ (
   from_user_ IN VARCHAR2,
   lu_name_   IN VARCHAR2,
   view_name_ IN VARCHAR2 ) RETURN CLOB
IS
   msg_ CLOB;
BEGIN  
   msg_ := Message_SYS.Construct_Clob_Message(TAG_OBJTRK_MESSAGE);
   Message_SYS.Add_Attribute(msg_, TAG_FROM, from_user_);
   Message_SYS.Add_Attribute(msg_, TAG_LU_NAME, lu_name_);
   Message_SYS.Add_Attribute(msg_, TAG_VIEW_NAME, view_name_);
   RETURN msg_;
END Init_Msg___;
 
FUNCTION Format___ (
   value_ IN VARCHAR2,
   type_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   CASE type_
   WHEN 'V' THEN
      RETURN value_;
   WHEN 'DT' THEN
      RETURN to_char(to_date(value_, Client_SYS.date_format_), 'YYYY-MM-DD HH.MI.SS AM');
   WHEN 'T' THEN
      RETURN to_char(to_date(value_, Client_SYS.date_format_), 'HH.MI.SS AM');
   WHEN 'D' THEN
      RETURN to_char(to_date(value_, Client_SYS.date_format_), 'YYYY-MM-DD');
   WHEN 'P' THEN
      RETURN to_char(to_number(value_)*100) || ' %';
   WHEN 'N' THEN
      RETURN value_;
   WHEN 'C' THEN
      RETURN value_;
   ELSE
      RETURN value_;
   END CASE;
EXCEPTION
   WHEN OTHERS THEN
      RETURN value_;
END Format___;

FUNCTION Get_Node_Value___ (
  node_    IN VARCHAR2,
  iid_ref_ IN VARCHAR2 DEFAULT NULL,
  type_    IN VARCHAR2 DEFAULT NULL,
  format_  IN BOOLEAN DEFAULT FALSE,
  lang_code_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
  val_ VARCHAR2(500);
  stmnt_ VARCHAR2(1000);
  iid_val_ VARCHAR2(500);
  s_lang_code_ VARCHAR2(10);
BEGIN
  val_ := node_;
  
  IF val_ IS NOT NULL THEN
     IF iid_ref_ IS NOT NULL THEN
        BEGIN
            IF lang_code_ IS NOT NULL THEN
               s_lang_code_ := Fnd_Session_API.Get_Language();
               Fnd_Session_API.Set_Language(lang_code_);
            END IF;
           
           Assert_Function_Check_Cache___(iid_ref_); 
           stmnt_ := 'SELECT '||iid_ref_||'('''||val_||''') FROM dual';
           @ApproveDynamicStatement(2014-07-25,wawilk)
           EXECUTE IMMEDIATE stmnt_ INTO iid_val_;
           val_ := NVL(iid_val_, val_);
           
            IF lang_code_ IS NOT NULL THEN
               Fnd_Session_API.Set_Language(s_lang_code_);
            END IF;
        EXCEPTION
           WHEN OTHERS THEN
              dbms_output.put_line(stmnt_||SQLERRM);
        END;
     END IF;

     IF format_ THEN
        RETURN Format___(val_, type_ );
     ELSE
        CASE type_
        WHEN 'R' THEN
           val_ := '<FORMAT DTYPE="V">'||val_||'</FORMAT>';
        WHEN 'L' THEN
           val_ := '<FORMAT DTYPE="V">'||val_||'</FORMAT>';
        ELSE
           val_ := '<FORMAT DTYPE="'||type_||'">'||val_||'</FORMAT>';
        END CASE;
     END IF;
  END IF;
  
  RETURN val_;
END Get_Node_Value___;

FUNCTION Get_Cus_Fld_Trans_Prompt___ (
   lu_name_     IN VARCHAR2,
   view_name_   IN VARCHAR2,
   column_name_ IN VARCHAR2,
   lang_code_   IN VARCHAR2) RETURN VARCHAR2
IS
   attribute_name_ VARCHAR2(30) := substr(column_name_, 5);
   prompt_ VARCHAR2(2000);
   lu_type_ VARCHAR2(100);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   BEGIN
      IF view_name_ LIKE '%/_CLV' ESCAPE '/' THEN
         lu_type_ := Custom_Field_Lu_Types_API.DB_CUSTOM_LU;
      ELSE
         lu_type_ := Custom_Field_Lu_Types_API.DB_CUSTOM_FIELD;
      END IF;
      SELECT Custom_Field_Attributes_API.Get_Prompt_Translation(lu, lu_type, 
                                                                Custom_Fields_SYS.Get_Column_Prefix(lu_type)||attribute_name, 
                                                                rowkey, 
                                                                prompt,
                                                                lang_code_) 
        INTO prompt_
        FROM Custom_Field_Attributes_Tab t
       WHERE t.lu = lu_name_
         AND attribute_name = attribute_name_
         AND lu_type = lu_type_;
      RETURN prompt_;
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;
$ELSE
   RETURN NULL;
$END
END Get_Cus_Fld_Trans_Prompt___;

FUNCTION Get_Translated_Attr_Info___(
   iid_ref_     OUT VARCHAR2,
   type_        OUT VARCHAR2,
   msg_          IN VARCHAR2,
   lu_name_      IN VARCHAR2,
   in_view_name_ IN VARCHAR2,
   lang_code_    IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   info_ VARCHAR2(1000);
   view_name_ VARCHAR2(50) := in_view_name_;
   column_name_ VARCHAR2(50);
   display_name_ VARCHAR2(4000);
   column_path_ VARCHAR2(4000);
   prog_         VARCHAR2(50);
   string_null_ VARCHAR2(1) := NULL;
BEGIN
   iid_ref_      := Message_SYS.Find_Attribute(msg_, TAG_REF, string_null_);
   type_         := Message_SYS.Find_Attribute(msg_, TAG_DTYPE, string_null_);
   
   view_name_    := Message_SYS.Find_Attribute(msg_, TAG_VIEW_INFO, string_null_);
   column_name_  := Message_SYS.Find_Attribute(msg_, TAG_COL_NAME, string_null_);
   prog_         := Message_SYS.Find_Attribute(msg_, TAG_PROG, string_null_);
   display_name_ := Message_SYS.Find_Attribute(msg_, TAG_DIS_NAME, string_null_);  
   column_path_  := Message_SYS.Find_Attribute(msg_, TAG_COL_PATH, string_null_);

   IF display_name_ IS NOT NULL THEN      
         info_ := display_name_;
   END IF;

   IF info_ IS NULL AND view_name_ IS NOT NULL AND column_name_ IS NOT NULL  THEN
      IF column_name_ LIKE 'CF$/_%' ESCAPE '/' THEN
         info_ := NVL(Get_Cus_Fld_Trans_Prompt___(lu_name_, view_name_, column_name_, lang_code_), prog_ );
      ELSIF info_ IS NULL THEN
         info_ := Language_SYS.Translate_Item_Prompt_(view_name_||'.'||column_name_, prog_, lang_code_);
      END IF;
   END IF;
   
   IF info_ IS NULL THEN
      info_ := prog_;
   END IF;
     
   RETURN info_;
END Get_Translated_Attr_Info___;

PROCEDURE Extract_Values___ (
   p1_     OUT VARCHAR2,
   p2_     OUT VARCHAR2,
   p3_     OUT VARCHAR2,
   node_   IN VARCHAR2,
   type_   IN VARCHAR2,
   format_ IN BOOLEAN DEFAULT FALSE,
   lu_name_   IN VARCHAR2 DEFAULT NULL,
   view_name_ IN VARCHAR2 DEFAULT NULL,
   lang_code_ IN VARCHAR2 DEFAULT NULL)
IS
   iid_ref_   VARCHAR2(100);
   dtype_     VARCHAR2(10);
   count_     NUMBER;
   names_  Message_SYS.name_table;
   values_ Message_SYS.line_table;

   name_  VARCHAR2(2000);
   value_ VARCHAR2(2000);
BEGIN
   Message_SYS.Get_Attributes(node_, count_,  names_, values_);
   
   FOR i_ IN 1..count_ LOOP
      name_  := names_(i_);
      value_ := values_(i_);
      CASE name_
      WHEN TAG_P1 THEN
         IF type_ = TAG_OBJ_REMOVED THEN
            -- Special handling for Removed Object
            p1_ := Get_Node_Value___(value_, iid_ref_, lang_code_ => lang_code_);
         ELSIF type_ = TAG_SUB_RENEW THEN
            -- Special handling for Renewal Notification
            p1_ := Get_Node_Value___(value_, iid_ref_, 'N', TRUE, lang_code_);
         ELSE
            p1_ := Get_Translated_Attr_Info___(iid_ref_, dtype_, value_, lu_name_, view_name_, lang_code_);
         END IF;
      WHEN TAG_P2 THEN
         p2_ := Get_Node_Value___(value_, iid_ref_, dtype_, format_, lang_code_);
      WHEN TAG_P3 THEN
         p3_ := Get_Node_Value___(value_, iid_ref_, dtype_, format_, lang_code_);
      ELSE
         NULL;
      END CASE;
   END LOOP;
END Extract_Values___;

FUNCTION Translate_Mod1_Msg___ (
  parent_node_ IN VARCHAR2,
  format_      IN BOOLEAN DEFAULT FALSE,
  lu_name_     IN VARCHAR2 DEFAULT NULL,
  view_name_   IN VARCHAR2 DEFAULT NULL,
  lang_code_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
  msg_ VARCHAR2(4000);
  p1_ VARCHAR2(100);
  p2_ VARCHAR2(1000);
  p3_ VARCHAR2(1000);
BEGIN  
  Extract_Values___(p1_, p2_, p3_, parent_node_, TAG_MOD1, format_, lu_name_, view_name_, lang_code_);
  msg_ := Language_SYS.Translate_Constant(Fnd_Obj_Subscription_Util_API.lu_name_, 'MSGMOD1: :P1 modified from :P2 to :P3.', lang_code_, p1_, p2_, p3_);
  RETURN msg_;
END Translate_Mod1_Msg___;

FUNCTION Translate_Mod2_Msg___ (
  parent_node_ IN VARCHAR2,
  format_      IN BOOLEAN DEFAULT FALSE,
  lu_name_     IN VARCHAR2 DEFAULT NULL,
  view_name_   IN VARCHAR2 DEFAULT NULL,
  lang_code_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
  msg_ VARCHAR2(4000);
  p1_ VARCHAR2(100);
  p2_ VARCHAR2(1000);
  p3_ VARCHAR2(1000);
BEGIN  
  Extract_Values___(p1_, p2_, p3_, parent_node_, TAG_MOD2, format_, lu_name_, view_name_, lang_code_);
  msg_ := Language_SYS.Translate_Constant(Fnd_Obj_Subscription_Util_API.lu_name_, 'MSGMOD2: :P1 modified.', lang_code_, p1_); 
  RETURN msg_;
END Translate_Mod2_Msg___;

FUNCTION Translate_Set_Msg___ (
  parent_msg_ IN VARCHAR2,
  format_      IN BOOLEAN DEFAULT FALSE,
  lu_name_     IN VARCHAR2 DEFAULT NULL,
  view_name_   IN VARCHAR2 DEFAULT NULL,
  lang_code_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
  msg_ VARCHAR2(4000);
  p1_ VARCHAR2(100);
  p2_ VARCHAR2(1000);
  p3_ VARCHAR2(1000);
BEGIN  
  Extract_Values___(p1_, p2_, p3_, parent_msg_, TAG_SET, format_, lu_name_, view_name_, lang_code_);
  msg_ := Language_SYS.Translate_Constant(Fnd_Obj_Subscription_Util_API.lu_name_, 'MSGSET: :P1 set to :P2.', lang_code_, p1_, p2_);
  RETURN msg_;
END Translate_Set_Msg___;

FUNCTION Translate_Unset_Msg___ (
  parent_msg_ IN VARCHAR2,
  format_      IN BOOLEAN DEFAULT FALSE,
  lu_name_     IN VARCHAR2 DEFAULT NULL,
  view_name_   IN VARCHAR2 DEFAULT NULL,
  lang_code_   IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
  msg_ VARCHAR2(4000);
  p1_ VARCHAR2(100);
  p2_ VARCHAR2(1000);
  p3_ VARCHAR2(1000);
BEGIN  
  Extract_Values___(p1_, p2_, p3_, parent_msg_, TAG_UNSET, format_, lu_name_, view_name_, lang_code_);
  msg_ := Language_SYS.Translate_Constant(Fnd_Obj_Subscription_Util_API.lu_name_, 'MSGUNSET: :P1 set to empty from :P2.', lang_code_, p1_, p2_);
  RETURN msg_;
END Translate_Unset_Msg___;

FUNCTION Translate_Rem_Msg___ (
  parent_msg_ IN VARCHAR2,
  lang_code_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
  msg_ VARCHAR2(4000);
  p1_ VARCHAR2(100);
  p2_ VARCHAR2(1000);
  p3_ VARCHAR2(1000);
BEGIN  
  Extract_Values___(p1_, p2_, p3_, parent_msg_, TAG_OBJ_REMOVED, lang_code_ => lang_code_);
  msg_ := Language_SYS.Translate_Constant(Fnd_Obj_Subscription_Util_API.lu_name_, 'MSGREM: This object you have subscribed to has been removed.', lang_code_);
  RETURN msg_;
END Translate_Rem_Msg___;

FUNCTION Translate_Exp_Msg___ (
  parent_msg_ IN VARCHAR2,
  lang_code_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
  msg_ VARCHAR2(4000);
  p1_ VARCHAR2(100);
  p2_ VARCHAR2(1000);
  p3_ VARCHAR2(1000);
BEGIN  
  Extract_Values___(p1_, p2_, p3_, parent_msg_, TAG_SUB_RENEW, lang_code_ => lang_code_);
  msg_ := Language_SYS.Translate_Constant(Fnd_Obj_Subscription_Util_API.lu_name_, 'MSGSUBEXP: This subscription will expire in :P1 day(s).', lang_code_, p1_);
  RETURN msg_;
END Translate_Exp_Msg___;

FUNCTION Translate_Obj_Changed_Msg___ (
  parent_msg_ IN VARCHAR2,
  lang_code_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
  msg_ VARCHAR2(4000);
  p1_ VARCHAR2(100);
  p2_ VARCHAR2(1000);
  p3_ VARCHAR2(1000);
BEGIN  
  Extract_Values___(p1_, p2_, p3_, parent_msg_, TAG_OBJ_CHANGED, lang_code_ => lang_code_);
  msg_ := Language_SYS.Translate_Constant(Fnd_Obj_Subscription_Util_API.lu_name_, 'MSGFIELDCHANGED: Multiple fields have changed.', lang_code_);
  RETURN msg_;
END Translate_Obj_Changed_Msg___;

FUNCTION Translate_Job_Msg___ (
  parent_msg_ IN VARCHAR2,
  lu_name_     IN VARCHAR2,
  lang_code_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
  msg_ VARCHAR2(4000);
  p1_ VARCHAR2(1000);
  p2_ VARCHAR2(2000);
  p3_ VARCHAR2(1000);
  BEGIN
   -- Formatting as Character to remove any formatting markers
   Extract_Values___(p1_, p2_, p3_, parent_msg_,'C',true);  
   -- Using P2 to hold the translation constant
   IF(p2_ IS NOT NULL) THEN    
      IF(lu_name_ IS NOT NULL) THEN
         msg_ :=  Language_SYS.Translate_Constant(lu_name_, p2_, lang_code_, p3_);  
      ELSE
         msg_:= p2_; --Cannot translate, simply returning as ProgText.
      END IF;        
   ELSE     
      msg_ := Language_SYS.Translate_Constant(Fnd_Obj_Subscription_Util_API.lu_name_, 'MSGJOBFINISHED: Job Has Finished Executing', lang_code_);
   END IF;      
  RETURN msg_;  

END Translate_Job_Msg___;



FUNCTION Renewal_Notification_Msg___ (
   time_     IN VARCHAR2,
   fnd_user_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   msg_  VARCHAR2(200);
   line_ VARCHAR2(400);
BEGIN
   msg_ := Init_Msg___(fnd_user_,'','');
   line_ := Create_Tagged_Line___(TAG_SUB_RENEW, p2_=> time_);
   Append_Node___(msg_, line_, 1);
   RETURN msg_;
END Renewal_Notification_Msg___;

FUNCTION Get_Reference_Value___ (
   asserted_views_ IN OUT asserted_views,
   lu_name_      IN VARCHAR2,
   column_name_  IN VARCHAR2,
   objkey_value_ IN VARCHAR2,
   fnd_user_     IN VARCHAR2) RETURN VARCHAR2
IS
   stmt_       VARCHAR2(2000);
   value_      VARCHAR2(32000) := objkey_value_;
   meta_data_  VARCHAR2(4000);
   lov_view_   VARCHAR2(30);
   temp_       BOOLEAN;
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT metadata, lov_view
     INTO meta_data_, lov_view_
     FROM custom_field_attributes_tab
    WHERE lu = lu_name_
      AND attribute_name = SUBSTR(column_name_, 5); -- Remove CF$_
         
   IF meta_data_ IS NOT NULL AND lov_view_ IS NOT NULL THEN
      Fnd_Session_API.Impersonate_Fnd_User(fnd_user_);
      temp_ := Assert_View_Check___(asserted_views_, lov_view_);
      stmt_ := 'SELECT '||meta_data_||' FROM '||lov_view_||' WHERE objkey = '''||objkey_value_||'''';
      @ApproveDynamicStatement(2015-2-20,chmulk)
      EXECUTE IMMEDIATE stmt_ INTO value_;
      Fnd_Session_API.Reset_Fnd_User;
   END IF;  
   $END
   RETURN NVL(value_, objkey_value_);
EXCEPTION
   WHEN OTHERS THEN
      Fnd_Session_API.Reset_Fnd_User;
      value_ := Server_Log_API.Log_Autonomous(NULL, 'Server Errors', 'Object Tracking Error', SQLERRM);
      RETURN objkey_value_;
END Get_Reference_Value___;

PROCEDURE Write_Trans_Msg_Line___(
   msg_             IN OUT CLOB,
   count_           IN OUT NUMBER,
   asserted_views_  IN OUT asserted_views,
   subscription_id_ IN NUMBER,
   column_name_     IN VARCHAR2,
   old_val_         IN VARCHAR2,
   new_val_         IN VARCHAR2,
   mod_type_        IN VARCHAR2,
   view_name_       IN VARCHAR2,
   display_name_    IN VARCHAR2,
   column_path_     IN VARCHAR2,
   lu_name_         IN VARCHAR2,
   fnd_user_        IN VARCHAR2,
   data_type_       IN VARCHAR2 DEFAULT 'V')
IS
   temp_msg_       VARCHAR2(4000);
   buffer_overflow EXCEPTION;
   PRAGMA          exception_init(buffer_overflow, -6502);
   attribute_info_msg_  VARCHAR2(4000);
   cf_view_name_   VARCHAR2(30)    := NULL;
   new_value_      VARCHAR2(32000) := new_val_;
   old_value_      VARCHAR2(32000) := old_val_;
BEGIN
   count_ := count_+1;
   IF column_name_ LIKE 'CF$/_%' ESCAPE '/' AND view_name_ NOT LIKE '%/_CLV' ESCAPE '/' THEN
      -- This is a Custom Field
      cf_view_name_ := Get_CFV_Name___(lu_name_, view_name_);
   END IF;   
   attribute_info_msg_ := Attribute_Info_Tag___(subscription_id_, view_name_, column_name_, display_name_, column_path_, data_type_, cf_view_name_);
   IF data_type_ = 'R' THEN
      IF old_value_ IS NOT NULL THEN
         old_value_ := Get_Reference_Value___(asserted_views_, lu_name_, column_name_, old_value_, fnd_user_);
      END IF;
      IF new_value_ IS NOT NULL THEN
         new_value_ := Get_Reference_Value___(asserted_views_, lu_name_, column_name_, new_value_, fnd_user_);
      END IF;
   END IF;
   
   IF mod_type_ = 'U' THEN
      IF LENGTH(old_value_) > 200 OR LENGTH(new_value_) > 200 THEN
         temp_msg_ := Create_Tagged_Line___(TAG_MOD2, attribute_info_msg_);
      ELSIF old_value_ IS NULL AND new_value_ IS NOT NULL THEN
         temp_msg_ := Create_Tagged_Line___(TAG_SET, attribute_info_msg_, new_value_);
      ELSIF old_value_ IS NOT NULL AND new_value_ IS NULL THEN
         temp_msg_ := Create_Tagged_Line___(TAG_UNSET, attribute_info_msg_, old_value_);
      ELSIF old_value_ IS NOT NULL AND new_value_ IS NOT NULL THEN
         temp_msg_ := Create_Tagged_Line___(TAG_MOD1, attribute_info_msg_, old_value_, new_value_);
      END IF;     
   END IF;
   
   Append_Node___(msg_, temp_msg_, count_);
END Write_Trans_Msg_Line___;

FUNCTION Assert_View_Check___ (
   views_     IN OUT asserted_views,
   view_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   temp_ NUMBER;
BEGIN
   -- We do not need to Assert the same view repeateadly
   -- So we cache it.
   BEGIN
      temp_ := views_(view_name_);
      -- Already checked
   EXCEPTION
      WHEN no_data_found THEN
         -- Has not been checked
         Assert_SYS.Assert_Is_View(view_name_);
         views_(view_name_) := 1;
   END;
   RETURN TRUE;   
EXCEPTION
   WHEN OTHERS THEN
      RETURN FALSE;      
END Assert_View_Check___;
   
PROCEDURE Assert_Function_Check_Cache___ (
   function_ IN VARCHAR2 )
IS
   temp_ VARCHAR2(100);
   context_id_ VARCHAR2(100) := 'Assert_func';
BEGIN
   -- We do not need to Assert the same function repeateadly
   -- So we cache it.
   BEGIN
      temp_ := Get_From_Context___(context_id_, function_);
      IF temp_ IS NULL THEN
         RAISE no_data_found;
      END IF;
      -- Already checked and passed
   EXCEPTION
      WHEN no_data_found THEN
         -- Has not been checked
         Assert_SYS.Assert_Is_Function(function_);
         Cache_In_Context___(context_id_, function_, 'TRUE');
   END;
EXCEPTION
   WHEN OTHERS THEN
      Log_SYS.App_Trace(Log_SYS.error_, 'Error in Assert_Function_Check_Cache___'||SUBSTR(SQLERRM,1,100)); 
END Assert_Function_Check_Cache___;
     
FUNCTION Get_Model_Data_Type___ (
   view_name_   IN VARCHAR2,
   column_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   data_type_ VARCHAR2(1000);
BEGIN
   --SOLSETFW
   SELECT column_datatype INTO data_type_
   FROM dictionary_sys_view_column_act
   WHERE view_name = UPPER(view_name_)
   AND column_name = upper(column_name_)
   FETCH FIRST 1 ROW ONLY;

   RETURN UPPER(data_type_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Model_Data_Type___;

FUNCTION Get_Data_Type___(
   cols_       IN OUT cached_col_info,
   lu_name_        IN VARCHAR2,
   in_view_name_   IN VARCHAR2,
   column_name_    IN VARCHAR2) RETURN VARCHAR2
IS
   data_type_ VARCHAR2(30);
   model_data_type_ VARCHAR2(1000);
   view_name_    VARCHAR2(30);
BEGIN
   -- Check if it is cached
   data_type_ := cols_(UPPER(in_view_name_)||'^'||UPPER(column_name_));
   RETURN data_type_;
EXCEPTION
   -- Not in cache 
   WHEN no_data_found THEN     
      IF column_name_ LIKE 'CF$/_%' ESCAPE '/' AND in_view_name_ NOT LIKE '%/_CLV' ESCAPE '/' THEN
         -- Custom Field, get the actual _CFV view used
         -- but cache it using the in_view_name_
         view_name_ := Get_CFV_Name___(lu_name_,in_view_name_);
      ELSE
         view_name_ := in_view_name_;
      END IF;
      data_type_ := Database_SYS.Get_Column_Type(view_name_, column_name_);
      IF data_type_ = 'NUMBER' THEN
         model_data_type_ := Get_Model_Data_Type___(view_name_, column_name_);        
         IF model_data_type_ LIKE '%CURRENCY%' THEN
            data_type_ := 'C';
         ELSIF model_data_type_ LIKE '%PERCENTAGE%' THEN
            data_type_ := 'P';
         ELSIF model_data_type_ LIKE '%DECIMAL%' THEN
            data_type_ := 'DEC';
         ELSE
            data_type_ := 'N';
         END IF;
      ELSIF data_type_ = 'VARCHAR2' THEN
         -- Special Handling for REFERENCE type Custom Fields
         model_data_type_ := Get_Model_Data_Type___(view_name_, column_name_);
         IF model_data_type_ LIKE 'REFERENCE%' THEN
            data_type_ := 'R';
         -- List Enumertation
         ELSIF model_data_type_ LIKE '%/LIST' THEN
            data_type_ := 'L';
         ELSE
            data_type_ := 'V';
         END IF;
      ELSIF data_type_ = 'DATE' THEN
         model_data_type_ := Get_Model_Data_Type___(view_name_, column_name_);
         IF model_data_type_ LIKE '%DATETIME%' THEN
            data_type_ := 'DT';
         ELSIF model_data_type_ LIKE '%TIME%' THEN
            data_type_ := 'T';
         ELSE
            data_type_ := 'D';
         END IF;
      ELSE
         data_type_ := 'V';
      END IF;
      cols_(UPPER(in_view_name_)||'^'||UPPER(column_name_)) := data_type_;
      RETURN data_type_;
END Get_Data_Type___;
   
PROCEDURE Process_Message_Payload___ (
   msg_payload_lu_ IN fnd_rec_trk_info_type,
   msg_payload_cf_ IN fnd_rec_trk_info_type DEFAULT NULL)
IS
BEGIN
   IF (msg_payload_lu_.dmo_type = 'U' OR msg_payload_cf_.dmo_type = 'U') THEN
      Process_Message_Payload_U___(msg_payload_lu_, msg_payload_cf_);
   ELSIF (msg_payload_lu_.dmo_type = 'D' OR msg_payload_cf_.dmo_type = 'D') THEN
      Process_Message_Payload_D___(msg_payload_lu_, msg_payload_cf_);
   END IF;
END Process_Message_Payload___;

PROCEDURE Process_Message_Payload_D___ (
   msg_payload_lu_ IN fnd_rec_trk_info_type,
   msg_payload_cf_ IN fnd_rec_trk_info_type DEFAULT NULL)
IS
   subs_info_    subscription_info_tab_type;
   msg_payload_  fnd_rec_trk_info_type;
   msg_          CLOB;
   line_         VARCHAR2(1000);
   stream_       fnd_stream_tab%ROWTYPE;
   curr_user_          VARCHAR2(30);
BEGIN
   IF msg_payload_lu_.view_name IS NOT NULL THEN
      msg_payload_ := msg_payload_lu_;
   ELSIF msg_payload_cf_.view_name IS NOT NULL THEN
      msg_payload_ := msg_payload_cf_;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'INVINP: Invaild input');
   END IF;
   
   msg_ := Init_Msg___(msg_payload_.fnd_user, msg_payload_lu_.lu_name,'');
   line_ := Create_Tagged_Line___(TAG_OBJ_REMOVED, p2_=> msg_payload_lu_.lu_name);
   Append_Node___(msg_, line_, 1);
   
   --Finalize_Msg___(msg_, msg_payload_.fnd_user);
   -- Get All users subscribed to any column for that object
   subs_info_ := Get_Subscrib_Users___(msg_payload_.lu_name, msg_payload_.rowkey);
   
   FOR i_ IN 1..subs_info_.COUNT LOOP		
      curr_user_ := subs_info_(i_).username;
      IF curr_user_ IS NOT NULL AND (msg_payload_.fnd_user != curr_user_ OR subs_info_(i_).self_notify = 'TRUE') THEN         
         stream_.from_user   := msg_payload_.fnd_user;
         stream_.to_user     := subs_info_(i_).username;
         stream_.header      := subs_info_(i_).subscription_header;
         stream_.stream_type := Fnd_Stream_Type_API.DB_SUBSCRIBED_OBJECT;
         stream_.lu_name     := msg_payload_.lu_name;
         stream_.reference   := Fnd_Obj_Subscription_Util_API.Create_Subscription_Ref_(subs_info_(i_).subscription_id, msg_payload_.rowkey);
         stream_.url         := NULL;
         stream_.notes       := subs_info_(i_).notes;
         stream_.message     := msg_;
         stream_.web_url     := subs_info_(i_).web_url;
         Create_Stream_Msg___(stream_);
         IF subs_info_(i_).send_email = 'TRUE' THEN
            Send_Email___(stream_, 'D');
         END IF;
      END IF;
      -- Removing subscription as the object is deleted
      Fnd_Obj_Subscription_API.Remove_Subscription__(subs_info_(i_).subscription_id);
   END LOOP;
END Process_Message_Payload_D___;

PROCEDURE Process_Message_Payload_U___ (
   msg_payload_lu_ IN fnd_rec_trk_info_type,
   msg_payload_cf_ IN fnd_rec_trk_info_type DEFAULT NULL)
IS
   stream_recs_        streams_tab;
   stream_count_       NUMBER := 0;
   subs_users_cols_    subscription_col_info_tab_type;
   
   col_names_old_      Message_SYS.name_table;
   col_values_old_     Message_SYS.line_table;
   col_old_count_      NUMBER;
   col_names_new_      Message_SYS.name_table;
   col_values_new_     Message_SYS.line_table;
   col_new_count_      NUMBER;
   
   cf_col_names_old_   Message_SYS.name_table;
   cf_col_values_old_  Message_SYS.line_table;
   cf_col_old_count_   NUMBER;
   cf_col_names_new_   Message_SYS.name_table;
   cf_col_values_new_  Message_SYS.line_table;
   cf_col_new_count_   NUMBER;
   
   old_vals_dict_      changed_col_values_type;
   new_vals_dict_      changed_col_values_type;
   
   temp_val_old_       VARCHAR2(4000);
   temp_val_new_       VARCHAR2(4000);
   
   curr_user_          VARCHAR2(30);
   cf_po_              VARCHAR2(50);
   cf_po_checked_      BOOLEAN := FALSE;
   cf_available_       BOOLEAN := FALSE;
   msg_payload_        fnd_rec_trk_info_type;
   conditional_columns_  conditional_columns_type;
   asserted_views_     asserted_views;
   curr_column_        VARCHAR2(1000);
   conditions_met_     BOOLEAN := FALSE;
   curr_condition_     VARCHAR2(4000);
   data_type_ VARCHAR2(1000);
   cust_lu_            BOOLEAN := TRUE;
   feild_count_        NUMBER;
   conditional_columns_to_add_  array_of_characters;
   conditional_column_names_  array_of_characters;
   append_message_to_stream_  BOOLEAN := TRUE;
   users_to_send_stream_  array_of_characters;
   
   TYPE messages_tab IS TABLE OF CLOB INDEX BY BINARY_INTEGER;
   messages_       messages_tab;
   cols_           cached_col_info;
BEGIN
   -- Extract all attributes
   Message_SYS.Get_Attributes(msg_payload_lu_.old_values, col_old_count_, col_names_old_, col_values_old_);
   Message_SYS.Get_Attributes(msg_payload_lu_.new_values, col_new_count_, col_names_new_, col_values_new_);
   
   Message_SYS.Get_Attributes(msg_payload_cf_.old_values, cf_col_old_count_, cf_col_names_old_, cf_col_values_old_);
   Message_SYS.Get_Attributes(msg_payload_cf_.new_values, cf_col_new_count_, cf_col_names_new_, cf_col_values_new_);
   
   -- Merge attributes from the two messages together
   col_names_old_  := Append_Names___(col_names_old_, cf_col_names_old_);
   col_values_old_ := Append_Values___(col_values_old_, cf_col_values_old_);
   col_names_new_  := Append_Names___(col_names_new_,cf_col_names_new_);
   col_values_new_ := Append_Values___(col_values_new_, cf_col_values_new_);
   
   col_old_count_ := col_old_count_ + cf_col_old_count_;
   col_new_count_ := col_new_count_ + cf_col_new_count_;
   
   old_vals_dict_ := Convert_To_Dict___(col_old_count_, col_names_old_, col_values_old_);
   new_vals_dict_ := Convert_To_Dict___(col_new_count_, col_names_new_, col_values_new_);
      
   IF msg_payload_lu_.view_name IS NOT NULL THEN
      msg_payload_ := msg_payload_lu_;
   ELSIF msg_payload_cf_.view_name IS NOT NULL THEN
      msg_payload_ := msg_payload_cf_;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'INVINP: Invaild input');
   END IF;
   
   IF msg_payload_.table_name LIKE '%/_CLT' ESCAPE '/' THEN
      cust_lu_ := TRUE;
   END IF;
   
   subs_users_cols_ := Get_Subscrib_Users_Col_Det___(msg_payload_.lu_name, msg_payload_.rowkey);
   
   --Assert_SYS.Assert_Is_View(msg_payload_.view_name);
   --
   -- The following loop will iterate through subscription information 
   -- for all relavent users. The list is ordered by usernames. 
   -- When the username changes, we validate and create and add a stream to an array.
   -- Then start processing the next user
   -- Afterwards all stream messages are validate and sent.
   --
   -- This code was written in this way to minimize mulitple SELECTs on the table.
   --  
   FOR i_ IN 1..subs_users_cols_.COUNT LOOP
      append_message_to_stream_ := TRUE;
      --Here, create the stream item for each user. Some users may not be notified if conditions for the subscription are not met.
      IF users_to_send_stream_.COUNT = 0 OR NOT users_to_send_stream_.Exists(subs_users_cols_(i_).username) THEN
         -- New user
         curr_user_ := subs_users_cols_(i_).username;
         IF curr_user_ IS NOT NULL AND msg_payload_.fnd_user = curr_user_ THEN
            IF subs_users_cols_(i_).self_notify = 'FALSE' THEN
               CONTINUE;
            END IF;
         END IF;
         
         --Reset variables
         temp_val_new_ := '';
         data_type_ := '';
         curr_column_ := '';
         conditions_met_ := FALSE;
         conditional_columns_.Delete();
         conditional_columns_to_add_.Delete();
         conditional_column_names_.Delete();
         
         conditional_columns_ := Get_Columns_With_Conds___(col_names_new_, msg_payload_.lu_name, subs_users_cols_(i_).subscription_id);
         
         --Checking Conditional Subscriptions for the user
         IF conditional_columns_ IS NOT NULL AND conditional_columns_.COUNT > 0 THEN            
            Fnd_Session_API.Impersonate_Fnd_User(msg_payload_.fnd_user);
            
            --Check each condition to see which columns have satisfied the condition.
            --Only the columns which satisfy the conditions are sent in the stream.
            FOR p_ IN 1..conditional_columns_.COUNT LOOP               
               curr_column_ := conditional_columns_(p_).subscription_column;
               conditional_column_names_(curr_column_) := 1;
               IF Get_Value___(new_vals_dict_,curr_column_ ,temp_val_new_) THEN     
                  
                  curr_condition_ := conditional_columns_(p_).condition; 
                  data_type_ := Get_Data_Type___(cols_,msg_payload_.lu_name, subs_users_cols_(i_).client_view, curr_column_);
                           
                  IF Evaluate_Condition_Dynamic___(curr_condition_, curr_column_, data_type_, temp_val_new_) = 'TRUE' THEN
                     conditions_met_ := TRUE;
                     conditional_columns_to_add_(curr_column_) := 1;
                     CONTINUE;
                  END IF;
               END IF;
            END LOOP;
            
            Fnd_Session_API.Reset_Fnd_User;
            
            IF conditional_column_names_.Exists(subs_users_cols_(i_).column_name) AND conditions_met_ = FALSE THEN
               CONTINUE;
            END IF;
         END IF;
         
         stream_count_ := stream_count_ + 1;
         cf_po_checked_ := FALSE;
         stream_recs_(stream_count_).subscription_id := subs_users_cols_(i_).subscription_id;
         stream_recs_(stream_count_).send_email      := subs_users_cols_(i_).send_email;
         stream_recs_(stream_count_).client_view     := subs_users_cols_(i_).client_view;
         stream_recs_(stream_count_).has_info        := FALSE;
         
         stream_recs_(stream_count_).stream.from_user   := msg_payload_.fnd_user;
         stream_recs_(stream_count_).stream.to_user     := subs_users_cols_(i_).username;
         stream_recs_(stream_count_).stream.header      := subs_users_cols_(i_).subscription_header;
         stream_recs_(stream_count_).stream.stream_type := Fnd_Stream_Type_API.DB_SUBSCRIBED_OBJECT;
         stream_recs_(stream_count_).stream.lu_name     := msg_payload_.lu_name;
         stream_recs_(stream_count_).stream.reference   := Fnd_Obj_Subscription_Util_API.Create_Subscription_Ref_(stream_recs_(stream_count_).subscription_id, msg_payload_.rowkey);
         stream_recs_(stream_count_).stream.url         := subs_users_cols_(i_).client_url;
         stream_recs_(stream_count_).stream.notes       := subs_users_cols_(i_).notes;
         stream_recs_(stream_count_).one_time           := subs_users_cols_(i_).one_time;
         stream_recs_(stream_count_).stream.web_url     := subs_users_cols_(i_).web_url;         
         messages_(stream_count_) := Init_Msg___(msg_payload_.fnd_user, msg_payload_.lu_name, subs_users_cols_(i_).client_view);
         users_to_send_stream_(curr_user_) := 1;
      END IF;
      
      $IF Component_Fndcob_SYS.INSTALLED $THEN
      -- When a Custom Field is found we need to check against the Custom Fields
      -- PO, to see if the CF data is available to the user.
        
      IF subs_users_cols_(i_).column_name LIKE 'CF$/_%' ESCAPE '/' AND NOT cust_lu_ THEN
         IF cf_po_ IS NULL THEN
            cf_po_ := Custom_Fields_API.Get_Po_Id(msg_payload_.lu_name);
         END IF;
      
         IF NOT cf_po_checked_ THEN
            cf_available_ := Is_Po_Available___(cf_po_, subs_users_cols_(i_).username);
            cf_po_checked_ := TRUE;
         END IF;
      END IF;      
      $ELSE
            cf_available_ := FALSE;
      $END
      
      feild_count_ := 1;
      
      --Check if message should be appended to the stream
      IF conditional_column_names_.Exists(subs_users_cols_(i_).column_name) = FALSE THEN
         append_message_to_stream_ := TRUE;
      ELSE
         append_message_to_stream_ := (conditional_column_names_.Exists(subs_users_cols_(i_).column_name) AND conditional_columns_to_add_.Exists(subs_users_cols_(i_).column_name));
      END IF;   
      
      IF append_message_to_stream_ = TRUE AND messages_.COUNT > 0 AND messages_.COUNT >= stream_count_ THEN
         IF (NOT subs_users_cols_(i_).column_name LIKE 'CF$/_%' ESCAPE '/' OR cf_available_ OR cust_lu_) THEN         
            IF Get_Value___(old_vals_dict_,subs_users_cols_(i_).column_name ,temp_val_old_) THEN
               IF Get_Value___(new_vals_dict_,subs_users_cols_(i_).column_name ,temp_val_new_) THEN
                  stream_recs_(stream_count_).has_info := TRUE;
                  Write_Trans_Msg_Line___(messages_(stream_count_), 
                                          feild_count_,
                                          asserted_views_,
                                          subs_users_cols_(i_).subscription_id, 
                                          subs_users_cols_(i_).column_name, 
                                          temp_val_old_, 
                                          temp_val_new_,
                                          'U',
                                          subs_users_cols_(i_).client_view,
                                          subs_users_cols_(i_).display_name,
                                          subs_users_cols_(i_).column_path,
                                          msg_payload_.lu_name,
                                          subs_users_cols_(i_).username,
                                          Get_Data_Type___(cols_, msg_payload_.lu_name, subs_users_cols_(i_).client_view, subs_users_cols_(i_).column_name));
               END IF;
            END IF;
         END IF;
      END IF;
   END LOOP; 
         
   /*$IF Fnd_Obj_Tracking_SYS.debug_ $THEN
      IF stream_count_ = 0 THEN
         Log_Error_Autonomous('Message Discarded');
      ELSE
         Log_Error_Autonomous(stream_count_ || ' to be created');
      END IF;
   $END*/
   
   -- Send the Streams   
   FOR i_ IN 1..stream_count_ LOOP
      IF stream_recs_(i_).has_info AND Assert_View_Check___(asserted_views_, stream_recs_(i_).client_view) THEN
         IF Is_Object_Available___(stream_recs_(i_).client_view, msg_payload_.rowkey, stream_recs_(i_).stream.to_user) THEN            
            stream_recs_(i_).stream.message := Finalize_Msg_To_String___(messages_(i_), msg_payload_.fnd_user, msg_payload_.lu_name, stream_recs_(i_).client_view);
            -- The message should not be NULL, if it is then something has gone wrong so do not send the message
            IF stream_recs_(i_).stream.message IS NOT NULL THEN           
               Create_Stream_Msg___(stream_recs_(i_).stream);
               IF stream_recs_(i_).send_email = 'TRUE' THEN
                  Send_Email___(stream_recs_(i_).stream, 'U');
               END IF;
               IF (msg_payload_.dmo_type = 'U') AND stream_recs_(i_).one_time = 'TRUE' THEN
                     Fnd_Obj_Subscription_API.Remove_Subscription__(stream_recs_(i_).subscription_id);
               END IF;
            END IF;
         END IF;
      END IF;
   END LOOP;
   
   messages_.DELETE;
END Process_Message_Payload_U___;
   
PROCEDURE Log_Timestamp___ (text_ IN VARCHAR2 DEFAULT NULL)
IS
   -- temp_ NUMBER;
BEGIN 
   --temp_ := Server_Log_API.Log_Autonomous(NULL, log_category_, 'Tracking Object Execution Timestamp', text_||' '||to_char(systimestamp,'HH24:Mi:SS FF'));
   NULL;
END Log_Timestamp___;

PROCEDURE Cache_In_Context___ (
   context_ IN VARCHAR2,
   name_    IN VARCHAR2,
   value_   IN VARCHAR2)
IS 
BEGIN
   App_Context_SYS.Set_Value(lu_name_||'-cached-'||context_||'-'||name_, value_);
END Cache_In_Context___;

FUNCTION Get_From_Context___ (
   context_ IN VARCHAR2,
   name_    IN VARCHAR2) RETURN VARCHAR2
IS 
BEGIN
   RETURN App_Context_SYS.Get_Value(lu_name_||'-cached-'||context_||'-'||name_);
EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;    
END Get_From_Context___;
   
-------------------- LU SPECIFIC PRIVATE METHODS ---------------------------

@UncheckedAccess
FUNCTION Get_Columns_With_Conds___ (
   changed_column_list_ IN     Message_SYS.name_table,
   lu_name_             IN     VARCHAR2,
   subscription_id_  IN VARCHAR2) RETURN conditional_columns_type   
IS
   column_names_ conditional_columns_type;
   
   CURSOR get_conditional_columns IS
      SELECT *
      FROM fnd_obj_subscrip_column_tab c
      WHERE subscription_lu = lu_name_
      AND subscription_id_ = c.subscription_id
      AND subscription_column IN (SELECT column_value FROM TABLE(changed_column_list_))
      AND condition IS NOT NULL;
BEGIN
   OPEN get_conditional_columns;
   FETCH get_conditional_columns BULK COLLECT INTO column_names_;
   CLOSE get_conditional_columns;
   RETURN column_names_;
EXCEPTION 
   WHEN no_data_found THEN
      RETURN column_names_;
END Get_Columns_With_Conds___;
   
FUNCTION Evaluate_Condition_Dynamic___ (
   cond_ IN VARCHAR2,
   column_name_ IN VARCHAR2,
   data_type_ IN VARCHAR2,
   value_ IN VARCHAR2) RETURN VARCHAR2
IS 
   result_ VARCHAR2(10) := 'FALSE';
   eval_cond_ VARCHAR2(4000);
BEGIN
   IF instr(cond_, '&<'||column_name_) > 0 THEN
      eval_cond_ := replace(cond_,'&<' ||column_name_||'>',column_name_);
      
      IF(data_type_ IS NOT NULL AND (data_type_ = 'D' OR data_type_ = 'DT' OR data_type_ = 'T')) THEN      
         eval_cond_ := replace(eval_cond_,column_name_,'to_date('|| '''' || value_ ||'''' ||', Client_SYS.date_format_)');
      ELSE
         eval_cond_ := replace(eval_cond_,column_name_,'''' || value_ || '''');         
      END IF;
    
      eval_cond_ := Context_Substitution_Var_API.Replace_Variables__(eval_cond_); 
            
      dbms_output.put_line('Execute Immediate for checking conditional subscriptions, condition: ' || eval_cond_);
      @ApproveDynamicStatement(2016-03-02,ashdlk)
      EXECUTE IMMEDIATE 'BEGIN IF '||eval_cond_||' THEN :ret := ''TRUE''; ELSE :ret := ''FALSE''; END IF; END;' USING OUT result_;
      dbms_output.put_line('Execute Immediate for checking conditional subscriptions, result: ' || result_);
   END IF;
   RETURN result_;
END Evaluate_Condition_Dynamic___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

FUNCTION Get_Objkey_From_Objid_(
   lu_name_ IN VARCHAR2,
   objid_ IN VARCHAR2,
   view_name_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 
IS
   obj_id_ ROWID ; 
   objkey_ VARCHAR2(100);
   stmt_ VARCHAR2(200);
   base_table_ VARCHAR2(50);
   temp_ NUMBER;
   view_ VARCHAR2(50);
BEGIN
   IF view_name_ LIKE '%/_CLV' ESCAPE '/' THEN
      -- In Custom Logical Units objid is the Objkey
      RETURN objid_;
   END IF;
   base_table_ := Dictionary_SYS.Get_Base_Table_Name(lu_name_);
   IF (view_name_ IS NULL) THEN
      view_ := Dictionary_SYS.Get_Base_View(lu_name_);
   ELSE 
      view_ := view_name_;
   END IF;
   obj_id_ := CHARTOROWID(objid_);
   stmt_ := 'SELECT objkey FROM ' || view_ || ' WHERE objid= :obj_id_' ;
   @ApproveDynamicStatement(2014-06-25,wawilk)
   EXECUTE IMMEDIATE stmt_ INTO objkey_ USING obj_id_ ;
   
   --checks if the returned objkey from the view is the only really presend as the rowkey in the base table
   --this is important because the tracking triggers checks the table columns
   stmt_ := 'SELECT 1 FROM '|| base_table_ || ' WHERE rowkey= :objkey_';
   @ApproveDynamicStatement(2014-12-11,wawilk)
   EXECUTE IMMEDIATE stmt_ INTO temp_ USING objkey_ ;
   
   RETURN objkey_;
EXCEPTION
   WHEN OTHERS THEN
      Log_SYS.App_Trace(Log_SYS.error_, 'Error : '|| SUBSTR(SQLERRM, 1, 100));
      IF stmt_ IS NOT NULL THEN
         Log_SYS.App_Trace(Log_SYS.error_, 'Error statement: '||stmt_);
      END IF;
      Error_SYS.Appl_General(Fnd_Obj_Subscription_Util_API.lu_name_, 'OBJKEYERR: Error occured while retriving ROWKEY in LU ":P1"', lu_name_); 
END Get_Objkey_From_Objid_; 

PROCEDURE Cleanup_Subscriptions_
IS
BEGIN
   Remove_Expired_Subscriptions_;
   Create_Renewal_Notifications_;   
END Cleanup_Subscriptions_;

@UncheckedAccess
FUNCTION Create_Subscription_Ref_ (
   subscription_id_ IN VARCHAR2,
   objkey_          IN VARCHAR2) RETURN VARCHAR2
IS
   msg_ VARCHAR2(1000);
BEGIN
   msg_ := Message_SYS.Construct(Fnd_Obj_Subscription_API.lu_name_);
   Message_SYS.Add_Attribute(msg_,'SUBSCRIPTION_ID', subscription_id_);
   Message_SYS.Add_Attribute(msg_,'SUBS_OBJ_OBJKEY', objkey_);
   RETURN msg_;
END Create_Subscription_Ref_;

PROCEDURE Process_Request_(
   msg_payload_lu_    fnd_rec_trk_info_type,
   msg_payload_cf_    IN fnd_rec_trk_info_type DEFAULT NULL)
IS
BEGIN
   Process_Message_Payload___(msg_payload_lu_, msg_payload_cf_);
END Process_Request_;

PROCEDURE Create_Renewal_Notifications_
IS
   stream_ fnd_stream_tab%ROWTYPE;
   p1_                 VARCHAR2(5);
   notify_before_days_ NUMBER := to_number(Fnd_Setting_API.Get_Value('NOTIFY_BEFORE_DAYS'));
   today_              DATE := sysdate;
   TYPE REC_LIST_TYP IS TABLE OF fnd_obj_subscription_tab%ROWTYPE INDEX BY PLS_INTEGER;
   rec_list_ REC_LIST_TYP;
   CURSOR expiring_subscriptions_ IS
      SELECT * 
      FROM fnd_obj_subscription_tab
      WHERE expiry_date between (today_+notify_before_days_-1) and (today_+notify_before_days_);
BEGIN
   OPEN expiring_subscriptions_;
   LOOP
      FETCH expiring_subscriptions_
         BULK COLLECT INTO rec_list_ LIMIT 100;
      EXIT WHEN rec_list_.COUNT = 0;
      FOR i IN 1..rec_list_.COUNT LOOP
         p1_ := to_char(ceil(rec_list_(i).expiry_date - today_));
         stream_ := NULL;
         stream_.to_user   := rec_list_(i).username;
         stream_.header    := rec_list_(i).subscription_header;
         stream_.message   := Renewal_Notification_Msg___(p1_, NULL); 
         stream_.stream_type := Fnd_Stream_Type_API.DB_SUBSCRIPTION_EXPIRED;
         stream_.read        := Fnd_Boolean_API.DB_FALSE;
         stream_.visible     := Fnd_Boolean_API.DB_TRUE;
         stream_.url         := rec_list_(i).client_url;
         stream_.reference   := Create_Subscription_Ref_(rec_list_(i).subscription_id,rec_list_(i).sub_objkey);
         Fnd_Stream_API.New_Stream_Item(stream_);      
      END LOOP;
   END LOOP;
END Create_Renewal_Notifications_;

PROCEDURE Remove_Expired_Subscriptions_
IS 
   TYPE REC_LIST_TYP IS TABLE OF fnd_obj_subscription_tab%ROWTYPE INDEX BY PLS_INTEGER;
   rec_list_ REC_LIST_TYP;
   CURSOR expired_subscriptions_ IS 
      SELECT * FROM fnd_obj_subscription_tab WHERE expiry_date < sysdate;
      
BEGIN
   OPEN expired_subscriptions_;
   LOOP 
      FETCH expired_subscriptions_
         BULK COLLECT INTO rec_list_ LIMIT 100;
      EXIT WHEN rec_list_.COUNT = 0;
      FOR i IN 1..rec_list_.COUNT LOOP
         Fnd_Obj_Subscription_API.Remove_(rec_list_(i));
      END LOOP;
   END LOOP;
END Remove_Expired_Subscriptions_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

/* 
  Return Values
  NULL: No Subscriptions Found
  -1  : Subscriptions disabled by Admin
  -2  : Error while determining OBJKEY (Possibly a not supported LU)
   0> : Subscription ID
*/
FUNCTION Get_Object_Sub_Id_For_User(
   lu_name_ IN VARCHAR2,
   objid_ IN VARCHAR2,
   view_name_ IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   objkey_ VARCHAR2(50);
   sub_id_ NUMBER;
   admin_disabled_ VARCHAR2(20);
   fnd_user_ VARCHAR2(50);
   not_supported_lu_ EXCEPTION;
   PRAGMA exception_init (not_supported_lu_,-20255);
BEGIN 
   IF NVL(Fnd_Obj_Tracking_Runtime_API.Get_Active_Db(lu_name_),Fnd_Boolean_API.DB_TRUE) = Fnd_Boolean_API.DB_TRUE THEN
      objkey_ := Get_Objkey_From_Objid_(lu_name_,objid_,view_name_);
      IF objkey_ IS NULL THEN
         RAISE not_supported_lu_;
      ELSE 
         BEGIN
            fnd_user_ := Fnd_Session_API.Get_Fnd_User;
            SELECT subscription_id,disabled INTO sub_id_,admin_disabled_ FROM fnd_obj_subscription_tab t
               WHERE t.lu_name  = lu_name_
               AND t.sub_objkey = objkey_
               AND t.username = fnd_user_;
            IF admin_disabled_ = Fnd_Boolean_API.DB_TRUE THEN
               --admin has disabled this particular subscription
               RETURN -1;
            ELSE 
               RETURN sub_id_;
            END IF;
         EXCEPTION 
            WHEN no_data_found THEN
               RETURN NULL;
         END;
      END IF;
   ELSE 
      --admin has diactivated the logical unit for subscriptions
      RETURN -1;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      Log_SYS.App_Trace(Log_SYS.warning_, 'Unable to Subscribe to LU '||lu_name_|| '( Error: '|| SUBSTR(SQLERRM,1,100) || ')'); 
      RETURN -2;
END Get_Object_Sub_Id_For_User;

@UncheckedAccess
FUNCTION Get_Translated_Msg (
   message_ IN VARCHAR2,
   format_  IN VARCHAR2 DEFAULT 'FALSE',
   lang_code_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   msg_ VARCHAR2(4000);
   line_ VARCHAR2(1000);
   type_ VARCHAR2(100);

   format_b_ BOOLEAN;
   view_name_ VARCHAR2(30);
   lu_name_   VARCHAR2(30);
   field_names_  Message_SYS.name_table;
   field_values_ Message_SYS.line_table;
   field_count_ NUMBER;
BEGIN
   IF format_ = 'TRUE' THEN
      format_b_ := TRUE;
   ELSE
      format_b_ := FALSE;
   END IF;
     
   Message_SYS.Get_Attribute(message_, TAG_LU_NAME, lu_name_);
   Message_SYS.Get_Attribute(message_, TAG_VIEW_NAME, view_name_);
   
   Message_SYS.Get_Attributes(message_, field_count_, field_names_, field_values_);
   
   FOR i_ IN 1..field_count_ LOOP     
      IF field_names_(i_) LIKE TAG_FIELD ||'%' THEN 
         type_ := Message_SYS.Get_Name(field_values_(i_));
         CASE type_
         WHEN TAG_MOD1 THEN
            line_ := Translate_Mod1_Msg___(field_values_(i_), format_b_, lu_name_, view_name_, lang_code_);
         WHEN TAG_MOD2 THEN
            line_ := Translate_Mod2_Msg___(field_values_(i_), format_b_, lu_name_, view_name_, lang_code_);
         WHEN TAG_SET THEN
            line_ := Translate_Set_Msg___(field_values_(i_), format_b_, lu_name_, view_name_, lang_code_);
         WHEN TAG_UNSET THEN
            line_ := Translate_Unset_Msg___(field_values_(i_), format_b_, lu_name_, view_name_, lang_code_);
         WHEN TAG_OBJ_REMOVED THEN
            line_ := Translate_Rem_Msg___(field_values_(i_), lang_code_);
         WHEN TAG_SUB_RENEW THEN
            line_ := Translate_Exp_Msg___(field_values_(i_), lang_code_);
         WHEN TAG_OBJ_CHANGED THEN
            line_ := Translate_Obj_Changed_Msg___(field_values_(i_), lang_code_);
         WHEN TAG_JOB THEN           
            line_ := Translate_Job_Msg___(field_values_(i_),lu_name_, lang_code_);            
         ELSE
            line_ := field_values_(i_);
         END CASE;
         msg_ := msg_ || line_ ||newline_;
      END IF;
    END LOOP;
   RETURN msg_;
EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM|| dbms_utility.format_error_backtrace);
      RETURN message_;
END Get_Translated_Msg;   
  
@UncheckedAccess
FUNCTION Get_Translated_Header (
   to_     IN VARCHAR2,
   from_   IN VARCHAR2,
   lu_     IN VARCHAR2,
   header_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   trans_header_ VARCHAR2(4000);
BEGIN
   IF from_ = Fnd_Session_API.Get_Fnd_User THEN
      trans_header_ := Language_SYS.Translate_Constant(lu_name_, 'MODYOU: You have modified');
   ELSE
      trans_header_ := Language_SYS.Translate_Constant(lu_name_, 'MODOTHER: :P1 have modified', NULL, Fnd_User_API.Get_Description(from_));
   END IF;
   RETURN trans_header_ || header_;
END Get_Translated_Header;

-- Gets A Translatable Streams Header
@UncheckedAccess
FUNCTION Get_Translated_Msg_Header(
   header_ IN VARCHAR2 ) RETURN VARCHAR2
  IS
   trans_contant_ VARCHAR2(2000);
   lu_name_ VARCHAR2(20);
BEGIN
   IF(Message_SYS.Is_Message(header_)) THEN
      trans_contant_ := Message_SYS.Find_Attribute(header_,TAG_HEADER_TRANCONSTANT, '');
      lu_name_ := Message_SYS.Find_Attribute(header_, TAG_LU_NAME, '');
      IF (lu_name_ IS NOT NULL) THEN         
         RETURN Language_SYS.Translate_Constant(lu_name_, trans_contant_);
      ELSE
         RETURN trans_contant_ ; -- Cannot translate.Simply returning as ProgText.
      END IF;
   ELSE
      RETURN header_;      
   END IF;
END Get_Translated_Msg_Header;

@UncheckedAccess
FUNCTION Translatable_Msg_Header (
   lu_name_     IN VARCHAR2,   
   translation_constant_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   trans_header_ VARCHAR2(4000);
BEGIN
  trans_header_ := Init_Msg___(NULL,lu_name_,NULL);
  Message_SYS.Add_Attribute(trans_header_, TAG_HEADER_TRANCONSTANT, translation_constant_);  
  RETURN trans_header_;
END Translatable_Msg_Header;

FUNCTION Translatable_Jobs_Message (
   lu_name_     IN VARCHAR2,   
   translation_constant_ IN VARCHAR2,
   parameter_ IN VARCHAR2) RETURN VARCHAR2
IS
   trans_message_ VARCHAR2(4000);
   tagged_line_ VARCHAR2(2000);
   BEGIN
      trans_message_ := Init_Msg___(NULL,lu_name_,NULL);
      tagged_line_:= Create_Tagged_Line___(TAG_JOB, null,translation_constant_ , parameter_);
      Message_SYS.Add_Attribute(trans_message_, TAG_FIELD|| '1', tagged_line_);
   RETURN trans_message_;
END Translatable_Jobs_Message;

   
FUNCTION Get_Person_Name_For_User (
   user_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
$IF (Component_Enterp_SYS.INSTALLED)$THEN
   RETURN Person_Info_API.Get_Name_For_User(user_id_);
$ELSE
   RETURN Fnd_User_API.Get_Description(user_id_);
$END
END Get_Person_Name_For_User;