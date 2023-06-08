-----------------------------------------------------------------------------
--
--  Logical unit: HistoryLogAttribute
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980309  DOZE  Removed Init_Method from New__
--  980826  ERFO  Changes for improved performance (Bug #2635).
--  990701  RaKu  Recreated with new templates.
--  000111  ReAl  Connection between History and Event Registry.
--  020626  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021207  ROOD  Modified New_Entry methods (Bug#33765).
--  030127  HAAR  Moved all registration of events to a separate file (ToDo#4205).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  040128  NIPE  Modified New_Entry methods (Bug#42138).
--                of attribute strings, since the values themselves may 
--                be attribute strings (Bug#43904).
--  050322  NiWi  Bug49509, Modified New_Entry. Handled the error ORA-04091 When
--                history logs are created for FND_USER_TAB or FND_USER_PROPERTY_TAB.
--  091106  JHMASE Added columns in event HISTORY_LOG_MODIFIED (Bug #87003)
--                 and moved event to HistoryLog LU.
--  110804  ChMuLK Increased size of columns Old Value,New Value (Bug#95022
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE New_Entry___ (
   log_id_      IN OUT NUMBER,
   column_name_ IN VARCHAR2,
   old_value_   IN VARCHAR2,
   new_value_   IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   objid_      HISTORY_LOG_ATTRIBUTE.objid%TYPE;
   objversion_ HISTORY_LOG_ATTRIBUTE.objversion%TYPE;
   newrec_     HISTORY_LOG_ATTRIBUTE_TAB%ROWTYPE;
BEGIN
   IF (log_id_ = 0) OR (log_id_ IS NULL) THEN
      SELECT history_log_seq.nextval INTO log_id_ FROM dual;
   END IF;
   -- Go straight for Insert___ using record to avoid attribute string problems.
   newrec_.log_id      := log_id_;
   newrec_.column_name := column_name_;
   newrec_.old_value   := old_value_;
   newrec_.new_value   := new_value_;
   -- Checks normally made in Unpack_Check_Insert___
   Error_SYS.Check_Not_Null(lu_name_, 'LOG_ID', newrec_.log_id);
   Error_SYS.Check_Not_Null(lu_name_, 'COLUMN_NAME', newrec_.column_name);
   -- Insert the record
   Insert___(objid_, objversion_, newrec_, attr_);
   --
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
   WHEN OTHERS THEN
      Trace_SYS.Message('Following Error occured while executing History_Log_Attribute_API.New_Entry.['|| SUBSTR(SQLERRM,1,100)||']');
END New_Entry___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New_Entry (
   log_id_      IN OUT NUMBER,
   column_name_ IN VARCHAR2,
   old_value_   IN VARCHAR2,
   new_value_   IN VARCHAR2 )
IS
BEGIN
   New_Entry___(log_id_, 
                column_name_, 
                old_value_, 
                new_value_);
END New_Entry;


PROCEDURE New_Entry (
   log_id_      IN OUT NUMBER,
   column_name_ IN VARCHAR2,
   old_value_   IN DATE,
   new_value_   IN DATE )
IS
BEGIN
   New_Entry___(log_id_, 
             column_name_, 
             to_char(old_value_, 'YYYYMMDD HH24:MI:SS'), 
             to_char(new_value_, 'YYYYMMDD HH24:MI:SS'));
END New_Entry;


PROCEDURE New_Entry (
   log_id_      IN OUT NUMBER,
   column_name_ IN VARCHAR2,
   old_value_   IN CLOB,
   new_value_   IN CLOB )
IS
   old_log_val_  VARCHAR2(4000);
   new_log_val_  VARCHAR2(4000);
   overflow_msg_ VARCHAR2(100) := 'NOTE: Data length exceeds 4000 characters. Actual data was not logged.';
BEGIN
   IF length(old_value_) > 4000 THEN
      old_log_val_ := overflow_msg_;
   ELSE
      old_log_val_ := old_value_;
   END IF;
   IF length(new_value_) > 4000 THEN
      new_log_val_ := overflow_msg_;
   ELSE
      new_log_val_ := new_value_;
   END IF;
   New_Entry___(log_id_, 
                column_name_, 
                old_log_val_, 
                new_log_val_);
END New_Entry;


