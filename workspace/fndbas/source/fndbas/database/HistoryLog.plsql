-----------------------------------------------------------------------------
--
--  Logical unit: HistoryLog
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980227  DOZE  Bug #2163
--  980309  DOZE  Removed Init_Method from New__
--  980505  DOZE  Make history log work properly (Bug #2417).
--  980818  DOZE  Changes to get History work in other languages (Bug #2553).
--  980826  ERFO  Changes for improved performance (Bug #2635).
--  990108  DOZE  Added Translate_Item_prompt (ToDo #3059)
--  990304  ERFO  Consistency changes in Is_View_Available_ (Bug #3191).
--  990701  RaKu  Added method Remove_Older_Than__ (ToDo #3313).
--  990720  RaKu  Changed error-messages in Remove_Older_Than__ (ToDo #3313).
--  011024  ROOD  Improved performance in Remove_Older_Than__ (Bug#25763).
--  020626  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021207  ROOD  Modified method New_Entry (Bug#33765).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030311  HAAR  Added Set_Note and Clear_Note (ToDo#4140).
--  040223  ROOD  Replaced oracle_role with role everywhere (ToDo#????).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  050811  HAAR  Changed Is_View_Available_ to use Security_SYS.Is_View_Available (F1PR489).
--  050919  NiWi  Modified Remove_Older_Than__. Avoid snapshot too old error(Bug#50228).
--  051108  ASWI  Added logic to method Get_Description to map key names if reference exists.(Bug#49294)
--  071107  SUMA  Changed Get_Description to allow history logging to get the keys.(Bug#67969)
--  091106  JHMASE Added columns in event HISTORY_LOG_MODIFIED (Bug #87003)
--                 and moved the event from HistoryLogAttribute LU to this LU.
--  120925  ChMuLK Modified Is_View_Available_ to check security of the Base View. (Bug#104240)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT HISTORY_LOG_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.transaction_id := Dbms_Transaction.Local_Transaction_Id;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
--   WHEN dup_val_on_index THEN
--      Error_SYS.Record_Exist(lu_name_);
--   Ignore all errors, the main transaction is more important
   WHEN OTHERS THEN
     NULL;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     HISTORY_LOG_TAB%ROWTYPE,
   newrec_     IN OUT HISTORY_LOG_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.transaction_id := Dbms_Transaction.Local_Transaction_Id;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Remove_Older_Than__ (
   message_ IN VARCHAR2 )
IS
   table_name_   VARCHAR2(30);
   lu_name_      VARCHAR2(30);
   module_       VARCHAR2(6);

   days_to_keep_ NUMBER;
   time_stamp_   DATE;

   count_        NUMBER;
   msg_name_     VARCHAR2(200);
   name_arr_     Message_SYS.name_table;
   value_arr_    Message_SYS.line_table;

   TYPE log_id_type IS TABLE OF history_log_tab.log_id%TYPE;
   log_ids_       log_id_type;

   CURSOR get_table_recs IS
      SELECT log_id
      FROM history_log_tab
      WHERE table_name = table_name_
      AND time_stamp < time_stamp_;

   CURSOR get_lu_recs IS
      SELECT log_id
      FROM history_log_tab
      WHERE lu_name = lu_name_
      AND time_stamp < time_stamp_;

   CURSOR get_module_recs IS
      SELECT log_id
      FROM history_log_tab
      WHERE module = module_
      AND time_stamp < time_stamp_;
BEGIN
   msg_name_ := Message_SYS.Get_Name(message_);
   IF (msg_name_ != 'CLEANUP_HISTORY_LOG') THEN
      Error_SYS.Appl_General(lu_name_, 'INVALID_MSG_NAME: Message :P1 can not be used in this method.', msg_name_);
   END IF;

   Message_SYS.Get_Attribute(message_, 'DAYS_TO_KEEP', days_to_keep_);
   time_stamp_ := SYSDATE - days_to_keep_;

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'DAYS_TO_KEEP') THEN
         -- Already decoded (mandatory for all operations).
         NULL;
      ELSIF (name_arr_(n_) = 'TABLE_NAME') THEN
         table_name_ := value_arr_(n_);
         OPEN get_table_recs;
         LOOP
            FETCH get_table_recs BULK COLLECT INTO log_ids_ LIMIT 1000; 
            FORALL i_ IN 1..log_ids_.count
               DELETE
                  FROM history_log_tab
                  WHERE log_id = log_ids_(i_);

            FORALL i_ IN 1..log_ids_.count
               DELETE 
                  FROM history_log_attribute_tab 
                  WHERE log_id = log_ids_(i_);
@ApproveTransactionStatement(2013-10-30,mabose)
            COMMIT;
            EXIT WHEN get_table_recs%NOTFOUND;
         END LOOP;
         CLOSE get_table_recs;
      
      ELSIF (name_arr_(n_) = 'LU_NAME') THEN
         lu_name_ := value_arr_(n_);
         OPEN get_lu_recs;
         LOOP
            FETCH get_lu_recs BULK COLLECT INTO log_ids_ LIMIT 1000; 
            FORALL i_ IN 1..log_ids_.count
               DELETE
                  FROM history_log_tab
                  WHERE log_id = log_ids_(i_);

            FORALL i_ IN 1..log_ids_.count
               DELETE 
                  FROM history_log_attribute_tab 
                  WHERE log_id = log_ids_(i_);
@ApproveTransactionStatement(2013-10-30,mabose)
            COMMIT;
            EXIT WHEN get_lu_recs%NOTFOUND;
         END LOOP;
         CLOSE get_lu_recs;

      ELSIF (name_arr_(n_) = 'MODULE') THEN
         module_ := value_arr_(n_);
         OPEN get_module_recs;
         LOOP
            FETCH get_module_recs BULK COLLECT INTO log_ids_ LIMIT 1000; 
            FORALL i_ IN 1..log_ids_.count
               DELETE
                  FROM history_log_tab
                  WHERE log_id = log_ids_(i_);

            FORALL i_ IN 1..log_ids_.count
               DELETE 
                  FROM history_log_attribute_tab 
                  WHERE log_id = log_ids_(i_);
@ApproveTransactionStatement(2013-10-30,mabose)
            COMMIT;
            EXIT WHEN get_module_recs%NOTFOUND;
         END LOOP;
         CLOSE get_module_recs;

      ELSE
         Error_SYS.Appl_General(lu_name_, 'INCORRECT_MESSAGE: Attribute :P1 can not be used in this method.');
      END IF;
   END LOOP;
END Remove_Older_Than__;


@UncheckedAccess
FUNCTION Translate_Item_Prompt__ (
   lu_name_   IN VARCHAR2,
   item_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   prog_ VARCHAR2(2000) := upper(substr(item_name_,1,1))||lower(replace(substr(item_name_,2),'_',' '));
   
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   IF item_name_ LIKE 'CF$/_%' ESCAPE '/' THEN
      IF Custom_LUs_API.Exists(lu_name_, Custom_Field_Lu_Types_API.DB_CUSTOM_LU) THEN
         RETURN Custom_Field_Attributes_API.Get_Prompt_Translation(lu_name_, Custom_Field_Lu_Types_API.DB_CUSTOM_LU, item_name_, NULL, prog_);
      ELSE
         RETURN Custom_Field_Attributes_API.Get_Prompt_Translation(lu_name_, Custom_Field_Lu_Types_API.DB_CUSTOM_FIELD, item_name_, NULL, prog_);
      END IF;
   END IF;      
$END
   
   RETURN Language_SYS.Translate_Item_Prompt_(Dictionary_SYS.Get_Base_View(lu_name_)||'.'||item_name_, prog_, 0);
END Translate_Item_Prompt__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Is_View_Available_ (
   view_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'OBSOLETE_VIEW: Calling obsolete interface History_Log_API.Is_View_Available_! Arguments: :P1', view_name_);
   RETURN(NULL);
END Is_View_Available_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   log_id_ IN NUMBER ) RETURN VARCHAR2
IS
   lu_name_          HISTORY_LOG_TAB.lu_name%TYPE;
   keys_             HISTORY_LOG_TAB.keys%TYPE;
   tmp_keys_         HISTORY_LOG_TAB.keys%TYPE;
   key_              HISTORY_LOG_TAB.keys%TYPE;
   table_name_       VARCHAR2(30);
   ref_view_name_    VARCHAR2(30);
   view_name_        VARCHAR2(30);
   info_msg_         VARCHAR2(2000);
   column_ref_       Message_SYS.line_table;
   column_name_      Message_SYS.name_table;
   cnt_              INTEGER;
   n_                INTEGER;
   m_                INTEGER;
   o_                INTEGER;
   a_                INTEGER; 
   by_position_      BOOLEAN := TRUE;
   found_            BOOLEAN;
   col_name_         Message_SYS.name_table;
   col_value_        Message_SYS.name_table;

   CURSOR get_info IS
      SELECT lu_name, table_name, keys
      FROM HISTORY_LOG_TAB
      WHERE log_id = log_id_;
   --SOLSETFW   
   CURSOR get_sort_order IS
      SELECT column_name,
             row_number() OVER (ORDER BY column_name) as row_order_1,
             row_number() OVER (ORDER BY NLSSORT(column_name,'NLS_SORT=BINARY_AI')) as row_order_2
      FROM   dictionary_sys_view_column_act
      WHERE  view_name = view_name_
      AND    type_flag IN ('P', 'K');
BEGIN
   OPEN  get_info;
   FETCH get_info INTO lu_name_, table_name_, keys_;
   CLOSE get_info;
   
   ref_view_name_ := SUBSTR(table_name_, 1, LENGTH(table_name_)-4);
   view_name_     := Dictionary_SYS.ClientNameToDbName_(lu_name_);
   Reference_SYS.Get_View_Reference_Info_(info_msg_, view_name_, ref_view_name_, NULL);
      
   IF table_name_ LIKE '%/_CLT' ESCAPE '/' AND keys_ LIKE 'OBJKEY=%' THEN
      view_name_ := Dictionary_SYS.Get_Base_View(lu_name_);
   END IF;

   IF (info_msg_ IS NOT NULL) THEN
      Message_SYS.Get_Attributes(info_msg_, cnt_, column_name_, column_ref_);
      n_ := 1;
      tmp_keys_ := keys_; 
      WHILE (NVL(INSTR(tmp_keys_, '^', 1, 1),0)>0) LOOP
         a_ :=n_;
         key_ := SUBSTR(tmp_keys_, 1, INSTR(tmp_keys_, '^', 1, 1)-1);
         col_name_(n_) := SUBSTR(key_, 1, INSTR(key_, '=', 1, 1)-1);
         col_value_(n_) := SUBSTR(key_, INSTR(key_, '=', 1, 1)+1);
         tmp_keys_ := SUBSTR(tmp_keys_, INSTR(tmp_keys_, '^', 1, 1)+1);
         n_ := n_ + 1;
      END LOOP;

      m_ := 1;
      WHILE m_<= cnt_ LOOP
         IF  (column_ref_(m_) IS NOT NULL) AND (column_name_(m_) IS NOT NULL) THEN
            IF (column_ref_(m_) <> column_name_(m_)) THEN
               o_ := 1;
               found_ := FALSE;
               WHILE (o_ <= a_ AND NOT found_) LOOP
                  IF col_name_(o_) = column_ref_(m_) THEN
                     col_name_(o_) := column_name_(m_);
                     found_ := TRUE;
                  END IF;
                  o_ := o_ + 1;
               END LOOP;
            END IF;
         END IF;
         m_ := m_ + 1;
      END LOOP;

      m_ := 1;
      keys_ := NULL;
      WHILE m_ <= a_ LOOP
         keys_ := keys_||col_name_(m_)||'='||col_value_(m_)||'^';
         m_ := m_ + 1;
      END LOOP;
      by_position_ := FALSE;
   ELSE          
      FOR rec_ IN get_sort_order LOOP
         IF rec_.row_order_1 != rec_.row_order_2 THEN
            by_position_ := FALSE;
         END IF;
         EXIT WHEN by_position_ = FALSE;
      END LOOP;
   END IF;
   RETURN Object_Connection_SYS.Get_Instance_Description(lu_name_, view_name_, keys_, by_position_);
END Get_Description;


PROCEDURE New_Entry (
   log_id_     IN NUMBER,
   module_     IN VARCHAR2,
   lu_name_    IN VARCHAR2,
   table_name_ IN VARCHAR2,
   keys_       IN VARCHAR2,
   operation_  IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   objid_      HISTORY_LOG.objid%TYPE;
   objversion_ HISTORY_LOG.objversion%TYPE;
   newrec_     HISTORY_LOG_TAB%ROWTYPE;
   table_mutating_  EXCEPTION;
   fnd_user_        VARCHAR2(30);
   msg_             VARCHAR2(32000);
   indrec_          Indicator_Rec;
   PRAGMA           EXCEPTION_INIT(table_mutating_, -04091);
   
   CURSOR details_ IS
      SELECT *
      FROM   HISTORY_LOG_ATTRIBUTE_TAB
      WHERE  log_id = log_id_;
BEGIN
   fnd_user_ := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('LOG_ID', log_id_, attr_);
   Client_SYS.Add_To_Attr('MODULE', module_, attr_);
   Client_SYS.Add_To_Attr('LU_NAME', lu_name_, attr_);
   Client_SYS.Add_To_Attr('TABLE_NAME', table_name_, attr_);
   Client_SYS.Add_To_Attr('KEYS', keys_, attr_);
   Client_SYS.Add_To_Attr('HISTORY_TYPE', History_Type_API.Decode(operation_), attr_);
   Client_SYS.Add_To_Attr('TIME_STAMP', sysdate, attr_);
   Client_SYS.Add_To_Attr('USERNAME', fnd_user_, attr_);   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_); 
   Insert___(objid_, objversion_, newrec_, attr_);
   
-- Event generation moved here from History_Attribute_Log
   IF (Event_SYS.Event_Enabled(History_Log_API.lu_name_, 'HISTORY_LOG_MODIFIED')) THEN
      FOR detail_rec_ in details_ LOOP
         msg_ := Message_SYS.Construct('HISTORY_LOG_MODIFIED');
         ---
         --- Standard event parameters
         ---
         Message_SYS.Add_Attribute(msg_, 'EVENT_DATETIME', sysdate);
         Message_SYS.Add_attribute(msg_, 'USER_IDENTITY', fnd_user_);
         BEGIN
            Message_SYS.Add_attribute(msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
            Message_SYS.Add_attribute(msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
            Message_SYS.Add_attribute(msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));
         EXCEPTION
            WHEN table_mutating_ THEN
               Message_SYS.Add_attribute(msg_, 'USER_DESCRIPTION', '');
               Message_SYS.Add_attribute(msg_, 'USER_MAIL_ADDRESS', '');
               Message_SYS.Add_attribute(msg_, 'USER_MOBILE_PHONE', '');
            WHEN OTHERS THEN
               RAISE;
         END;	  

         ---
         --- Primary key for object
         ---
         Message_SYS.Add_Attribute(msg_, 'LOG_ID', to_char(log_id_));
         ---
         --- Header information
         ---
         Message_SYS.Add_Attribute(msg_, 'MODULE', module_);
         Message_SYS.Add_Attribute(msg_, 'LU_NAME', lu_name_);
         Message_SYS.Add_Attribute(msg_, 'TABLE_NAME', table_name_);
         Message_SYS.Add_Attribute(msg_, 'KEYS', keys_);
         Message_SYS.Add_Attribute(msg_, 'HISTORY_TYPE', History_Type_API.Decode(operation_));
         ---
         --- Detail information
         ---
         Message_SYS.Add_Attribute(msg_, 'COLUMN_NAME', detail_rec_.column_name);
         Message_SYS.Add_Attribute(msg_, 'OLD_VALUE', detail_rec_.old_value);
         Message_SYS.Add_Attribute(msg_, 'NEW_VALUE', detail_rec_.new_value);
         Event_SYS.Event_Execute(History_Log_API.lu_name_, 'HISTORY_LOG_MODIFIED', msg_);
      END LOOP;
   END IF;
END New_Entry;


