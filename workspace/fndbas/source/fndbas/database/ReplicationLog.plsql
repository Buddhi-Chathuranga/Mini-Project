-----------------------------------------------------------------------------
--
--  Logical unit: ReplicationLog
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000101  JhMa    Created.
--  000621  ROOD    Set business_object uppercase in view.
--  000628  ROOD    Changes in error handling.
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030217  ROOD    Moved registration of events to a separate file (ToDo#4205).
--  070730  DUWI    Changed the parameter name lu_name_in Create_Log__ and Create_Log_Cache__ (Bug#66753
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE type_log_table IS TABLE OF VARCHAR2(1000)
   INDEX BY BINARY_INTEGER;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Id___ RETURN NUMBER
IS
   log_seq_   NUMBER;
   CURSOR repl_log_seq IS
      SELECT replication_log_seq.nextval
      FROM   dual;
BEGIN
   OPEN repl_log_seq;
   FETCH repl_log_seq INTO log_seq_;
   CLOSE repl_log_seq;
   RETURN log_seq_;
END Get_Next_Id___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REPLICATION_LOG_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.id := Get_Next_Id___;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT replication_log_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.replication_operation := 'SEND';
   newrec_.replication_error_type := 'ERROR';
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     replication_log_tab%ROWTYPE,
   newrec_ IN OUT replication_log_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   newrec_.replication_operation := UPPER(newrec_.replication_operation);
   newrec_.replication_error_type := UPPER(newrec_.replication_error_type);
   IF ( NVL(newrec_.replication_operation, '*') NOT IN ('SEND','RECEIVE','LOAD') ) THEN
      newrec_.replication_operation := 'SEND';
   END IF;
   IF ( NVL(newrec_.replication_error_type, '*') NOT IN ('ERROR','WARNING','INFORMATION') ) THEN
      newrec_.replication_error_type := 'ERROR';
   END IF;
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_Log__ (
   business_object_           IN VARCHAR2,
   logical_unit_name_         IN VARCHAR2,
   table_name_                IN VARCHAR2,
   column_name_               IN VARCHAR2,
   message_id_                IN NUMBER,
   message_line_              IN NUMBER,
   error_                     IN VARCHAR2,
   application_error_         IN VARCHAR2,
   replication_operation_     IN VARCHAR2,
   replication_error_type_    IN VARCHAR2,
   send_warning_              IN BOOLEAN,
   send_info_                 IN BOOLEAN,
   receive_warning_           IN BOOLEAN,
   receive_info_              IN BOOLEAN )
IS
   msg_              VARCHAR2(32000);
   fnd_user_         VARCHAR2(2000);
   create_log_       BOOLEAN := TRUE;
   operation_        VARCHAR2(30) := UPPER(replication_operation_);
   error_type_       VARCHAR2(30) := UPPER(replication_error_type_);


   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   IF ( error_type_ NOT IN ('ERROR','WARNING','INFORMATION') ) THEN
      error_type_ := 'ERROR';
   END IF;
   IF ( operation_ NOT IN ('SEND','RECEIVE','LOAD') ) THEN
      operation_ := 'RECEIVE';
   END IF;
   IF ( error_type_ = 'INFORMATION' )    THEN
      IF ( operation_ = 'SEND' )         THEN
         IF ( send_info_ = FALSE )       THEN create_log_ := FALSE; END IF;
      ELSIF ( operation_ = 'RECEIVE' )   THEN
         IF ( receive_info_ = FALSE )    THEN create_log_ := FALSE; END IF;
      END IF;
   ELSIF ( error_type_ = 'WARNING' )     THEN
      IF ( operation_ = 'SEND' )         THEN
         IF ( send_warning_ = FALSE )    THEN create_log_ := FALSE; END IF;
      ELSIF ( operation_ = 'RECEIVE' )   THEN
         IF ( receive_warning_ = FALSE ) THEN create_log_ := FALSE; END IF;
      END IF;
   END IF;
   IF ( error_type_ IN ('ERROR','WARNING') )    THEN
      IF (Event_SYS.Event_Enabled( lu_name_, 'REPLICATION_ERROR' )) THEN
         msg_ := Message_SYS.Construct('REPLICATION_ERROR');
         --
         -- Standard event parameters
         --
         fnd_user_ := Fnd_Session_API.Get_Fnd_User;
         Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', sysdate );
         Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_ );
         Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION',Fnd_User_API.Get_Description(fnd_user_) );
         Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS',Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS') );
         Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE') );
         --
         -- Other important information
         --
         Message_SYS.Add_Attribute( msg_, 'REPLICATION_ERROR_TYPE', error_type_ );
         Message_SYS.Add_Attribute( msg_, 'REPLICATION_OBJECT', business_object_ );
         Message_SYS.Add_Attribute( msg_, 'REPLICATION_OPERATION', UPPER(replication_operation_) );
         Message_SYS.Add_Attribute( msg_, 'APPLICATION_ERROR', application_error_ );
         Message_SYS.Add_Attribute( msg_, 'LOGICAL_UNIT', logical_unit_name_ );
         Message_SYS.Add_Attribute( msg_, 'TABLE_NAME', table_name_ );
         Message_SYS.Add_Attribute( msg_, 'COLUMN_NAME', column_name_ );
         Message_SYS.Add_Attribute( msg_, 'MESSAGE_ID', TO_CHAR(message_id_) );
         Message_SYS.Add_Attribute( msg_, 'MESSAGE_LINE', TO_CHAR(message_line_) );
         Message_SYS.Add_Attribute( msg_, 'ERROR', error_ );
         Event_SYS.Event_Execute( lu_name_, 'REPLICATION_ERROR', msg_ );
      END IF;
   END IF;

   IF ( create_log_ ) THEN
      INSERT INTO replication_log_tab (
         id,
         business_object,
         lu_name,
         table_name,
         column_name,
         message_id,
         message_line,
         error,
         error_date,
         application_error,
         replication_operation,
         replication_error_type,
         rowversion)
      VALUES (
         replication_log_seq.nextval,
         NVL(SUBSTR(business_object_,1,30),'*'),
         NVL(SUBSTR(logical_unit_name_,1,30),'*'),
         SUBSTR(table_name_,1,30),
         SUBSTR(column_name_,1,30),
         NVL(message_id_,0),
         message_line_,
         NVL(SUBSTR(error_,1,255),'*'),
         sysdate,
         SUBSTR(application_error_,1,512),
         operation_,
         error_type_,
         sysdate);
@ApproveTransactionStatement(2013-11-13,mabose)
      COMMIT;
   END IF;
   EXCEPTION
      WHEN others THEN
@ApproveTransactionStatement(2013-11-13,mabose)
         ROLLBACK;
END Create_Log__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


