-----------------------------------------------------------------------------
--
--  Logical unit: InMessageUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980127  ERFO    Rearrangements for release 2.1.0.
--  990705  ERFO    Performance in the Inbox (Bug #3399).
--  000329  ERFO    Changed cursor for date format in method Cleanup (Bug #13996).
--  020702  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030113  ROOD    Updated to new server templates (ToDo#4117).
--                  Removed unused implementation methods.
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030402  HAAR    Added method Get_Message_ and Get_Mesage_Lines_ (ToDo#4175).
--  040113  NIPE    Performance improvement in Process_Inbox_ (Bug#38136).
--  040315  HAAR    Can not use view Message_Class due to installation order.
--                  Use table Message_Clas_Tab instead (Bug#43425).
--  040917  JHMA    Added new methods to retreive on state (Bug#47158).
--  051108  ASWILK  Improved performance in Cleanup using BULK COLLECT, FORALL (Bug#48401).
--  060719  NiWiLK  Modified Process_Inbox_. When there are no message lines, state set to 'Incomplete(Bug#58876).
--  061027  NiWiLK  Modified method Cleanup(Bug#61210).
--  100526  JHMA    No description of background job (Bug #90933
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Get_Next_Message_ RETURN VARCHAR2
IS
BEGIN
   RETURN NULL;
END Get_Next_Message_;



@UncheckedAccess
FUNCTION Get_Message_ (
   message_id_ IN NUMBER ) RETURN VARCHAR2
IS
   attr_           VARCHAR2(32000);
   in_message_rec_ IN_MESSAGE%ROWTYPE;
   CURSOR getmessage (message_id_  IN_MESSAGE.MESSAGE_ID%TYPE) IS
      SELECT *
      FROM   IN_MESSAGE
      WHERE  message_id = message_id_;
BEGIN
   IF (message_id_ IS NOT NULL) THEN
      OPEN getmessage (message_id_);
      FETCH getmessage INTO in_message_rec_;
      IF (getmessage%FOUND) THEN
         Client_SYS.Add_To_Attr ('MESSAGE_ID', in_message_rec_.message_id, attr_);
         Client_SYS.Add_To_Attr ('RECEIVER', in_message_rec_.receiver, attr_);
         Client_SYS.Add_To_Attr ('SENDER', in_message_rec_.sender, attr_);
         Client_SYS.Add_To_Attr ('SENDER_MESSAGE_ID', in_message_rec_.sender_message_id, attr_);
         Client_SYS.Add_To_Attr ('APPLICATION_MESSAGE_ID', in_message_rec_.application_message_id, attr_);
         Client_SYS.Add_To_Attr ('RECEIVED_TIME', in_message_rec_.received_time, attr_);
         Client_SYS.Add_To_Attr ('VERSION', in_message_rec_.version, attr_);
         Client_SYS.Add_To_Attr ('CLASS_ID', in_message_rec_.class_id, attr_);
         Client_SYS.Add_To_Attr ('SENDER_ID', in_message_rec_.sender_id, attr_);
         IF (in_message_rec_.transferred_time IS NOT NULL) THEN
            Client_SYS.Add_To_Attr ('TRANSFERRED_TIME', in_message_rec_.transferred_time, attr_);
         END IF;
         IF (in_message_rec_.error_message IS NOT NULL) THEN
            Client_SYS.Add_To_Attr ('ERROR_MESSAGE', in_message_rec_.error_message, attr_);
         END IF;
      END IF;
      CLOSE getmessage;
   END IF;
   RETURN attr_;
END Get_Message_;



@UncheckedAccess
PROCEDURE Get_Message_ (
   count_      OUT NUMBER,
   message_    OUT Connectivity_SYS.In_Message,
   message_id_ IN  NUMBER )
IS
   CURSOR get_message IS
      SELECT *
      FROM   in_message_tab
      WHERE  message_id = message_id_;
--
BEGIN
   count_ := 0;
   FOR rec IN get_message LOOP
      count_ := count_ + 1;
      message_(count_) := rec;
   END LOOP;
END Get_Message_;


PROCEDURE Get_Message_Lines_ (
   count_         OUT NUMBER,
   message_lines_ OUT Connectivity_SYS.in_message_lines,
   message_id_    IN  NUMBER )
IS
   i_ BINARY_INTEGER := 0;
--
   CURSOR get_message_lines IS
      SELECT *
      FROM   in_message_line_pub
      WHERE  message_id = message_id_
      ORDER BY message_line;
--
BEGIN
   FOR rec IN get_message_lines LOOP
      i_ := i_ + 1;
      message_lines_(i_) := rec;
   END LOOP;
   count_ := i_;
END Get_Message_Lines_;


PROCEDURE Get_Message_Lines_ (
   count_         OUT NUMBER,
   message_lines_ OUT Connectivity_SYS.in_message_lines,
   message_id_    IN  NUMBER,
   states_        IN  Connectivity_SYS.in_message_line_states )
IS
   i_ BINARY_INTEGER := 0;
--
   CURSOR get_message_lines IS
      SELECT *
      FROM   in_message_line_pub
      WHERE  message_id = message_id_
      ORDER BY message_line;
--
   FUNCTION ValidState (
      rowstate_ IN VARCHAR2,
      states_   IN Connectivity_SYS.in_message_line_states ) RETURN BOOLEAN
   IS
   BEGIN
      IF ( states_.count = 0 ) THEN
         RETURN TRUE;
      END IF;
      FOR j IN 1..states_.count LOOP
         IF ( states_(j) = rowstate_ OR states_(j) = In_Message_line_API.Finite_State_Decode__(rowstate_) ) THEN
            RETURN TRUE;
         END IF;
      END LOOP;
      RETURN FALSE;
   END ValidState;
BEGIN
   FOR rec IN get_message_lines LOOP
      IF ValidState(rec.objstate, states_) THEN
         i_ := i_ + 1;
         message_lines_(i_) := rec;
      END IF;
   END LOOP;
   count_ := i_;
END Get_Message_Lines_;


PROCEDURE Post_Loaded_
IS
   CURSOR c_loaded_ IS
      SELECT * FROM in_message_loaded;
BEGIN
   FOR loaded_ IN c_loaded_ LOOP
      In_Message_API.Post_ (loaded_.message_id);
   END LOOP;
END Post_Loaded_;


PROCEDURE Process_Inbox_
IS
   dummy_            NUMBER;
   full_method_name_ VARCHAR2(2000);
   description_      VARCHAR2(2000);
   error_message_    VARCHAR2(200);
   
   CURSOR inbox_messages IS 
      SELECT message_id, class_id 
      FROM in_message i
      WHERE EXISTS (SELECT 1 
                    FROM message_class_tab m 
                    WHERE m.class_id = i.class_id 
                    AND m.receive = 'TRUE' ) 
      AND objstate = 'Posted' 
      ORDER BY message_id;

   CURSOR get_message_lines(message_id_ VARCHAR2) IS
       SELECT 1
       FROM   in_message_line_tab
       WHERE  message_id = message_id_;

BEGIN
   FOR msg IN inbox_messages LOOP
      --
      -- Lock explicit entry in Inbox
      --
      BEGIN
         SELECT 1
            INTO dummy_
            FROM   in_message_tab
            WHERE  rowstate = 'Posted'
            AND    message_id = msg.message_id
            FOR UPDATE NOWAIT;
      EXCEPTION
         WHEN OTHERS THEN
            GOTO end_loop;                   -- Skip job if already removed or locked...
      END;
      --
      -- Update status for specific message
      --
      UPDATE   in_message_tab
         SET   rowstate = 'Processing'
         WHERE message_id = msg.message_id;
      --
      -- Commit to publish new status
      --
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;

      error_message_ := '';
      Message_Class_API.Get_Action(msg.class_id,full_method_name_,description_);      
      
      IF (full_method_name_ IS NULL) THEN
         error_message_ := Language_SYS.Translate_Constant(lu_name_, 'METHODERR: No method connected to the message');      
      ELSE
         OPEN get_message_lines(msg.message_id);
         FETCH get_message_lines INTO dummy_;
         IF get_message_lines%NOTFOUND THEN
            error_message_ := Language_SYS.Translate_Constant(lu_name_, 'NOLINESERR: No message lines');
         END IF;
         CLOSE get_message_lines;
      END IF;

      IF error_message_ IS NOT NULL THEN
         --
         -- Update status for unhandled messages
         --
         UPDATE in_message_tab
            SET   rowstate = 'Incomplete',
                  error_message = error_message_
            WHERE message_id = msg.message_id;
      ELSE 
         --
         -- Create background process entry in Transaction_SYS
         --
         Transaction_SYS.Deferred_Call(full_method_name_, msg.message_id, 'Connectivity: In message ' || TO_CHAR(msg.message_id) || ' - ' || description_);
         --
         -- Update status for initiated messages
         --
         UPDATE in_message_tab
            SET   rowstate = 'Transferred',
                  transferred_time = sysdate,
                  error_message = NULL
            WHERE message_id = msg.message_id;
      END IF;

      --
      -- Commit each message separately
      --
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
      <<end_loop>>
      NULL;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      @ApproveTransactionStatement(2013-11-19,haarse)
      ROLLBACK;
      NULL; -- Severe problems
END Process_Inbox_;


PROCEDURE Receive_
IS
BEGIN
   NULL;
END Receive_;


@UncheckedAccess
PROCEDURE Add_Header_To_Attr_ (
   attr_                IN OUT VARCHAR2,
   in_message_line_rec_ IN OUT IN_MESSAGE_LINE_PUB%ROWTYPE )
IS
BEGIN
   Client_SYS.Add_To_Attr ('MESSAGE_ID', in_message_line_rec_.message_id, attr_);
   Client_SYS.Add_To_Attr ('NAME', in_message_line_rec_.name, attr_);
   Client_SYS.Add_To_Attr ('MESSAGE_LINE', in_message_line_rec_.message_line, attr_);
   Client_SYS.Add_To_Attr ('OBJSTATE', in_message_line_rec_.objstate, attr_);
   Client_SYS.Add_To_Attr ('STATE', in_message_line_rec_.state, attr_);
   IF (in_message_line_rec_.error_message IS NOT NULL) THEN
      Client_SYS.Add_To_Attr ('ERROR_MESSAGE', in_message_line_rec_.error_message, attr_);
   END IF;
END Add_Header_To_Attr_;



@UncheckedAccess
PROCEDURE Add_Char_To_Attr_ (
   attr_                IN OUT VARCHAR2,
   in_message_line_rec_ IN OUT IN_MESSAGE_LINE_PUB%ROWTYPE )
IS
BEGIN
   IF in_message_line_rec_.c00 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C00', in_message_line_rec_.c00, attr_);
   END IF;
   IF in_message_line_rec_.c01 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C01', in_message_line_rec_.c01, attr_);
   END IF;
   IF in_message_line_rec_.c02 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C02', in_message_line_rec_.c02, attr_);
   END IF;
   IF in_message_line_rec_.c03 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C03', in_message_line_rec_.c03, attr_);
   END IF;
   IF in_message_line_rec_.c04 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C04', in_message_line_rec_.c04, attr_);
   END IF;
   IF in_message_line_rec_.c05 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C05', in_message_line_rec_.c05, attr_);
   END IF;
   IF in_message_line_rec_.c06 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C06', in_message_line_rec_.c06, attr_);
   END IF;
   IF in_message_line_rec_.c07 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C07', in_message_line_rec_.c07, attr_);
   END IF;
   IF in_message_line_rec_.c08 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C08', in_message_line_rec_.c08, attr_);
   END IF;
   IF in_message_line_rec_.c09 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C09', in_message_line_rec_.c09, attr_);
   END IF;
   IF in_message_line_rec_.c10 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C10', in_message_line_rec_.c10, attr_);
   END IF;
   IF in_message_line_rec_.c11 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C11', in_message_line_rec_.c11, attr_);
   END IF;
   IF in_message_line_rec_.c12 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C12', in_message_line_rec_.c12, attr_);
   END IF;
   IF in_message_line_rec_.c13 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C13', in_message_line_rec_.c13, attr_);
   END IF;
   IF in_message_line_rec_.c14 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C14', in_message_line_rec_.c14, attr_);
   END IF;
   IF in_message_line_rec_.c15 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C15', in_message_line_rec_.c15, attr_);
   END IF;
   IF in_message_line_rec_.c16 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C16', in_message_line_rec_.c16, attr_);
   END IF;
   IF in_message_line_rec_.c17 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C17', in_message_line_rec_.c17, attr_);
   END IF;
   IF in_message_line_rec_.c18 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C18', in_message_line_rec_.c18, attr_);
   END IF;
   IF in_message_line_rec_.c19 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C19', in_message_line_rec_.c19, attr_);
   END IF;
   IF in_message_line_rec_.c20 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C20', in_message_line_rec_.c20, attr_);
   END IF;
   IF in_message_line_rec_.c21 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C21', in_message_line_rec_.c21, attr_);
   END IF;
   IF in_message_line_rec_.c22 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C22', in_message_line_rec_.c22, attr_);
   END IF;
   IF in_message_line_rec_.c23 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C23', in_message_line_rec_.c23, attr_);
   END IF;
   IF in_message_line_rec_.c24 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C24', in_message_line_rec_.c24, attr_);
   END IF;
   IF in_message_line_rec_.c25 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C25', in_message_line_rec_.c25, attr_);
   END IF;
   IF in_message_line_rec_.c26 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C26', in_message_line_rec_.c26, attr_);
   END IF;
   IF in_message_line_rec_.c27 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C27', in_message_line_rec_.c27, attr_);
   END IF;
   IF in_message_line_rec_.c28 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C28', in_message_line_rec_.c28, attr_);
   END IF;
   IF in_message_line_rec_.c29 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C29', in_message_line_rec_.c29, attr_);
   END IF;
   IF in_message_line_rec_.c30 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C30', in_message_line_rec_.c30, attr_);
   END IF;
   IF in_message_line_rec_.c31 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C31', in_message_line_rec_.c31, attr_);
   END IF;
   IF in_message_line_rec_.c32 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C32', in_message_line_rec_.c32, attr_);
   END IF;
   IF in_message_line_rec_.c33 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C33', in_message_line_rec_.c33, attr_);
   END IF;
   IF in_message_line_rec_.c34 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C34', in_message_line_rec_.c34, attr_);
   END IF;
   IF in_message_line_rec_.c35 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C35', in_message_line_rec_.c35, attr_);
   END IF;
   IF in_message_line_rec_.c36 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C36', in_message_line_rec_.c36, attr_);
   END IF;
   IF in_message_line_rec_.c37 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C37', in_message_line_rec_.c37, attr_);
   END IF;
   IF in_message_line_rec_.c38 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C38', in_message_line_rec_.c38, attr_);
   END IF;
   IF in_message_line_rec_.c39 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C39', in_message_line_rec_.c39, attr_);
   END IF;
   IF in_message_line_rec_.c40 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C40', in_message_line_rec_.c40, attr_);
   END IF;
   IF in_message_line_rec_.c41 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C41', in_message_line_rec_.c41, attr_);
   END IF;
   IF in_message_line_rec_.c42 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C42', in_message_line_rec_.c42, attr_);
   END IF;
   IF in_message_line_rec_.c43 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C43', in_message_line_rec_.c43, attr_);
   END IF;
   IF in_message_line_rec_.c44 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C44', in_message_line_rec_.c44, attr_);
   END IF;
   IF in_message_line_rec_.c45 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C45', in_message_line_rec_.c45, attr_);
   END IF;
   IF in_message_line_rec_.c46 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C46', in_message_line_rec_.c46, attr_);
   END IF;
   IF in_message_line_rec_.c47 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C47', in_message_line_rec_.c47, attr_);
   END IF;
   IF in_message_line_rec_.c48 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C48', in_message_line_rec_.c48, attr_);
   END IF;
   IF in_message_line_rec_.c49 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C49', in_message_line_rec_.c49, attr_);
   END IF;
   IF in_message_line_rec_.c50 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C50', in_message_line_rec_.c50, attr_);
   END IF;
   IF in_message_line_rec_.c51 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C51', in_message_line_rec_.c51, attr_);
   END IF;
   IF in_message_line_rec_.c52 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C52', in_message_line_rec_.c52, attr_);
   END IF;
   IF in_message_line_rec_.c53 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C53', in_message_line_rec_.c53, attr_);
   END IF;
   IF in_message_line_rec_.c54 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C54', in_message_line_rec_.c54, attr_);
   END IF;
   IF in_message_line_rec_.c55 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C55', in_message_line_rec_.c55, attr_);
   END IF;
   IF in_message_line_rec_.c56 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C56', in_message_line_rec_.c56, attr_);
   END IF;
   IF in_message_line_rec_.c57 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C57', in_message_line_rec_.c57, attr_);
   END IF;
   IF in_message_line_rec_.c58 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C58', in_message_line_rec_.c58, attr_);
   END IF;
   IF in_message_line_rec_.c59 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C59', in_message_line_rec_.c59, attr_);
   END IF;
   IF in_message_line_rec_.c60 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C60', in_message_line_rec_.c60, attr_);
   END IF;
   IF in_message_line_rec_.c61 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C61', in_message_line_rec_.c61, attr_);
   END IF;
   IF in_message_line_rec_.c62 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C62', in_message_line_rec_.c62, attr_);
   END IF;
   IF in_message_line_rec_.c63 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C63', in_message_line_rec_.c63, attr_);
   END IF;
   IF in_message_line_rec_.c64 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C64', in_message_line_rec_.c64, attr_);
   END IF;
   IF in_message_line_rec_.c65 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C65', in_message_line_rec_.c65, attr_);
   END IF;
   IF in_message_line_rec_.c66 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C66', in_message_line_rec_.c66, attr_);
   END IF;
   IF in_message_line_rec_.c67 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C67', in_message_line_rec_.c67, attr_);
   END IF;
   IF in_message_line_rec_.c68 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C68', in_message_line_rec_.c68, attr_);
   END IF;
   IF in_message_line_rec_.c69 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C69', in_message_line_rec_.c69, attr_);
   END IF;
   IF in_message_line_rec_.c70 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C70', in_message_line_rec_.c70, attr_);
   END IF;
   IF in_message_line_rec_.c71 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C71', in_message_line_rec_.c71, attr_);
   END IF;
   IF in_message_line_rec_.c72 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C72', in_message_line_rec_.c72, attr_);
   END IF;
   IF in_message_line_rec_.c73 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C73', in_message_line_rec_.c73, attr_);
   END IF;
   IF in_message_line_rec_.c74 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C74', in_message_line_rec_.c74, attr_);
   END IF;
   IF in_message_line_rec_.c75 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C75', in_message_line_rec_.c75, attr_);
   END IF;
   IF in_message_line_rec_.c76 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C76', in_message_line_rec_.c76, attr_);
   END IF;
   IF in_message_line_rec_.c77 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C77', in_message_line_rec_.c77, attr_);
   END IF;
   IF in_message_line_rec_.c78 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C78', in_message_line_rec_.c78, attr_);
   END IF;
   IF in_message_line_rec_.c79 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C79', in_message_line_rec_.c79, attr_);
   END IF;
   IF in_message_line_rec_.c80 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C80', in_message_line_rec_.c80, attr_);
   END IF;
   IF in_message_line_rec_.c81 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C81', in_message_line_rec_.c81, attr_);
   END IF;
   IF in_message_line_rec_.c82 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C82', in_message_line_rec_.c82, attr_);
   END IF;
   IF in_message_line_rec_.c83 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C83', in_message_line_rec_.c83, attr_);
   END IF;
   IF in_message_line_rec_.c84 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C84', in_message_line_rec_.c84, attr_);
   END IF;
   IF in_message_line_rec_.c85 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C85', in_message_line_rec_.c85, attr_);
   END IF;
   IF in_message_line_rec_.c86 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C86', in_message_line_rec_.c86, attr_);
   END IF;
   IF in_message_line_rec_.c87 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C87', in_message_line_rec_.c87, attr_);
   END IF;
   IF in_message_line_rec_.c88 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C88', in_message_line_rec_.c88, attr_);
   END IF;
   IF in_message_line_rec_.c89 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C89', in_message_line_rec_.c89, attr_);
   END IF;
   IF in_message_line_rec_.c90 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C90', in_message_line_rec_.c90, attr_);
   END IF;
   IF in_message_line_rec_.c91 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C91', in_message_line_rec_.c91, attr_);
   END IF;
   IF in_message_line_rec_.c92 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C92', in_message_line_rec_.c92, attr_);
   END IF;
   IF in_message_line_rec_.c93 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C93', in_message_line_rec_.c93, attr_);
   END IF;
   IF in_message_line_rec_.c94 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C94', in_message_line_rec_.c94, attr_);
   END IF;
   IF in_message_line_rec_.c95 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C95', in_message_line_rec_.c95, attr_);
   END IF;
   IF in_message_line_rec_.c96 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C96', in_message_line_rec_.c96, attr_);
   END IF;
   IF in_message_line_rec_.c97 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C97', in_message_line_rec_.c97, attr_);
   END IF;
   IF in_message_line_rec_.c98 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C98', in_message_line_rec_.c98, attr_);
   END IF;
   IF in_message_line_rec_.c99 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('C99', in_message_line_rec_.c99, attr_);
   END IF;
END Add_Char_To_Attr_;



@UncheckedAccess
PROCEDURE Add_Date_To_Attr_ (
   attr_                IN OUT VARCHAR2,
   in_message_line_rec_ IN OUT IN_MESSAGE_LINE_PUB%ROWTYPE )
IS
BEGIN
   IF in_message_line_rec_.d00 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D00', in_message_line_rec_.d00, attr_);
   END IF;
   IF in_message_line_rec_.d01 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D01', in_message_line_rec_.d01, attr_);
   END IF;
   IF in_message_line_rec_.d02 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D02', in_message_line_rec_.d02, attr_);
   END IF;
   IF in_message_line_rec_.d03 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D03', in_message_line_rec_.d03, attr_);
   END IF;
   IF in_message_line_rec_.d04 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D04', in_message_line_rec_.d04, attr_);
   END IF;
   IF in_message_line_rec_.d05 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D05', in_message_line_rec_.d05, attr_);
   END IF;
   IF in_message_line_rec_.d06 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D06', in_message_line_rec_.d06, attr_);
   END IF;
   IF in_message_line_rec_.d07 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D07', in_message_line_rec_.d07, attr_);
   END IF;
   IF in_message_line_rec_.d08 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D08', in_message_line_rec_.d08, attr_);
   END IF;
   IF in_message_line_rec_.d09 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D09', in_message_line_rec_.d09, attr_);
   END IF;
   IF in_message_line_rec_.d10 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D10', in_message_line_rec_.d10, attr_);
   END IF;
   IF in_message_line_rec_.d11 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D11', in_message_line_rec_.d11, attr_);
   END IF;
   IF in_message_line_rec_.d12 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D12', in_message_line_rec_.d12, attr_);
   END IF;
   IF in_message_line_rec_.d13 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D13', in_message_line_rec_.d13, attr_);
   END IF;
   IF in_message_line_rec_.d14 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D14', in_message_line_rec_.d14, attr_);
   END IF;
   IF in_message_line_rec_.d15 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D15', in_message_line_rec_.d15, attr_);
   END IF;
   IF in_message_line_rec_.d16 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D16', in_message_line_rec_.d16, attr_);
   END IF;
   IF in_message_line_rec_.d17 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D17', in_message_line_rec_.d17, attr_);
   END IF;
   IF in_message_line_rec_.d18 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D18', in_message_line_rec_.d18, attr_);
   END IF;
   IF in_message_line_rec_.d19 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D19', in_message_line_rec_.d19, attr_);
   END IF;
   IF in_message_line_rec_.d20 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D20', in_message_line_rec_.d20, attr_);
   END IF;
   IF in_message_line_rec_.d21 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D21', in_message_line_rec_.d21, attr_);
   END IF;
   IF in_message_line_rec_.d22 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D22', in_message_line_rec_.d22, attr_);
   END IF;
   IF in_message_line_rec_.d23 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D23', in_message_line_rec_.d23, attr_);
   END IF;
   IF in_message_line_rec_.d24 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D24', in_message_line_rec_.d24, attr_);
   END IF;
   IF in_message_line_rec_.d25 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D25', in_message_line_rec_.d25, attr_);
   END IF;
   IF in_message_line_rec_.d26 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D26', in_message_line_rec_.d26, attr_);
   END IF;
   IF in_message_line_rec_.d27 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D27', in_message_line_rec_.d27, attr_);
   END IF;
   IF in_message_line_rec_.d28 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D28', in_message_line_rec_.d28, attr_);
   END IF;
   IF in_message_line_rec_.d29 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D29', in_message_line_rec_.d29, attr_);
   END IF;
   IF in_message_line_rec_.d30 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D30', in_message_line_rec_.d30, attr_);
   END IF;
   IF in_message_line_rec_.d31 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D31', in_message_line_rec_.d31, attr_);
   END IF;
   IF in_message_line_rec_.d32 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D32', in_message_line_rec_.d32, attr_);
   END IF;
   IF in_message_line_rec_.d33 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D33', in_message_line_rec_.d33, attr_);
   END IF;
   IF in_message_line_rec_.d34 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D34', in_message_line_rec_.d34, attr_);
   END IF;
   IF in_message_line_rec_.d35 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D35', in_message_line_rec_.d35, attr_);
   END IF;
   IF in_message_line_rec_.d36 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D36', in_message_line_rec_.d36, attr_);
   END IF;
   IF in_message_line_rec_.d37 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D37', in_message_line_rec_.d37, attr_);
   END IF;
   IF in_message_line_rec_.d38 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D38', in_message_line_rec_.d38, attr_);
   END IF;
   IF in_message_line_rec_.d39 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('D39', in_message_line_rec_.d39, attr_);
   END IF;
END Add_Date_To_Attr_;



@UncheckedAccess
PROCEDURE Add_Number_To_Attr_ (
   attr_                IN OUT VARCHAR2,
   in_message_line_rec_ IN OUT IN_MESSAGE_LINE_PUB%ROWTYPE )
IS
BEGIN
   IF in_message_line_rec_.n00 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N00', in_message_line_rec_.n00, attr_);
   END IF;
   IF in_message_line_rec_.n01 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N01', in_message_line_rec_.n01, attr_);
   END IF;
   IF in_message_line_rec_.n02 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N02', in_message_line_rec_.n02, attr_);
   END IF;
   IF in_message_line_rec_.n03 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N03', in_message_line_rec_.n03, attr_);
   END IF;
   IF in_message_line_rec_.n04 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N04', in_message_line_rec_.n04, attr_);
   END IF;
   IF in_message_line_rec_.n05 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N05', in_message_line_rec_.n05, attr_);
   END IF;
   IF in_message_line_rec_.n06 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N06', in_message_line_rec_.n06, attr_);
   END IF;
   IF in_message_line_rec_.n07 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N07', in_message_line_rec_.n07, attr_);
   END IF;
   IF in_message_line_rec_.n08 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N08', in_message_line_rec_.n08, attr_);
   END IF;
   IF in_message_line_rec_.n09 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N09', in_message_line_rec_.n09, attr_);
   END IF;
   IF in_message_line_rec_.n10 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N10', in_message_line_rec_.n10, attr_);
   END IF;
   IF in_message_line_rec_.n11 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N11', in_message_line_rec_.n11, attr_);
   END IF;
   IF in_message_line_rec_.n12 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N12', in_message_line_rec_.n12, attr_);
   END IF;
   IF in_message_line_rec_.n13 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N13', in_message_line_rec_.n13, attr_);
   END IF;
   IF in_message_line_rec_.n14 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N14', in_message_line_rec_.n14, attr_);
   END IF;
   IF in_message_line_rec_.n15 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N15', in_message_line_rec_.n15, attr_);
   END IF;
   IF in_message_line_rec_.n16 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N16', in_message_line_rec_.n16, attr_);
   END IF;
   IF in_message_line_rec_.n17 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N17', in_message_line_rec_.n17, attr_);
   END IF;
   IF in_message_line_rec_.n18 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N18', in_message_line_rec_.n18, attr_);
   END IF;
   IF in_message_line_rec_.n19 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N19', in_message_line_rec_.n19, attr_);
   END IF;
   IF in_message_line_rec_.n20 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N20', in_message_line_rec_.n20, attr_);
   END IF;
   IF in_message_line_rec_.n21 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N21', in_message_line_rec_.n21, attr_);
   END IF;
   IF in_message_line_rec_.n22 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N22', in_message_line_rec_.n22, attr_);
   END IF;
   IF in_message_line_rec_.n23 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N23', in_message_line_rec_.n23, attr_);
   END IF;
   IF in_message_line_rec_.n24 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N24', in_message_line_rec_.n24, attr_);
   END IF;
   IF in_message_line_rec_.n25 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N25', in_message_line_rec_.n25, attr_);
   END IF;
   IF in_message_line_rec_.n26 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N26', in_message_line_rec_.n26, attr_);
   END IF;
   IF in_message_line_rec_.n27 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N27', in_message_line_rec_.n27, attr_);
   END IF;
   IF in_message_line_rec_.n28 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N28', in_message_line_rec_.n28, attr_);
   END IF;
   IF in_message_line_rec_.n29 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N29', in_message_line_rec_.n29, attr_);
   END IF;
   IF in_message_line_rec_.n30 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N30', in_message_line_rec_.n30, attr_);
   END IF;
   IF in_message_line_rec_.n31 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N31', in_message_line_rec_.n31, attr_);
   END IF;
   IF in_message_line_rec_.n32 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N32', in_message_line_rec_.n32, attr_);
   END IF;
   IF in_message_line_rec_.n33 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N33', in_message_line_rec_.n33, attr_);
   END IF;
   IF in_message_line_rec_.n34 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N34', in_message_line_rec_.n34, attr_);
   END IF;
   IF in_message_line_rec_.n35 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N35', in_message_line_rec_.n35, attr_);
   END IF;
   IF in_message_line_rec_.n36 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N36', in_message_line_rec_.n36, attr_);
   END IF;
   IF in_message_line_rec_.n37 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N37', in_message_line_rec_.n37, attr_);
   END IF;
   IF in_message_line_rec_.n38 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N38', in_message_line_rec_.n38, attr_);
   END IF;
   IF in_message_line_rec_.n39 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N39', in_message_line_rec_.n39, attr_);
   END IF;
   IF in_message_line_rec_.n40 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N40', in_message_line_rec_.n40, attr_);
   END IF;
   IF in_message_line_rec_.n41 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N41', in_message_line_rec_.n41, attr_);
   END IF;
   IF in_message_line_rec_.n42 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N42', in_message_line_rec_.n42, attr_);
   END IF;
   IF in_message_line_rec_.n43 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N43', in_message_line_rec_.n43, attr_);
   END IF;
   IF in_message_line_rec_.n44 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N44', in_message_line_rec_.n44, attr_);
   END IF;
   IF in_message_line_rec_.n45 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N45', in_message_line_rec_.n45, attr_);
   END IF;
   IF in_message_line_rec_.n46 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N46', in_message_line_rec_.n46, attr_);
   END IF;
   IF in_message_line_rec_.n47 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N47', in_message_line_rec_.n47, attr_);
   END IF;
   IF in_message_line_rec_.n48 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N48', in_message_line_rec_.n48, attr_);
   END IF;
   IF in_message_line_rec_.n49 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N49', in_message_line_rec_.n49, attr_);
   END IF;
   IF in_message_line_rec_.n50 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N50', in_message_line_rec_.n50, attr_);
   END IF;
   IF in_message_line_rec_.n51 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N51', in_message_line_rec_.n51, attr_);
   END IF;
   IF in_message_line_rec_.n52 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N52', in_message_line_rec_.n52, attr_);
   END IF;
   IF in_message_line_rec_.n53 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N53', in_message_line_rec_.n53, attr_);
   END IF;
   IF in_message_line_rec_.n54 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N54', in_message_line_rec_.n54, attr_);
   END IF;
   IF in_message_line_rec_.n55 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N55', in_message_line_rec_.n55, attr_);
   END IF;
   IF in_message_line_rec_.n56 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N56', in_message_line_rec_.n56, attr_);
   END IF;
   IF in_message_line_rec_.n57 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N57', in_message_line_rec_.n57, attr_);
   END IF;
   IF in_message_line_rec_.n58 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N58', in_message_line_rec_.n58, attr_);
   END IF;
   IF in_message_line_rec_.n59 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N59', in_message_line_rec_.n59, attr_);
   END IF;
   IF in_message_line_rec_.n60 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N60', in_message_line_rec_.n60, attr_);
   END IF;
   IF in_message_line_rec_.n61 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N61', in_message_line_rec_.n61, attr_);
   END IF;
   IF in_message_line_rec_.n62 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N62', in_message_line_rec_.n62, attr_);
   END IF;
   IF in_message_line_rec_.n63 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N63', in_message_line_rec_.n63, attr_);
   END IF;
   IF in_message_line_rec_.n64 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N64', in_message_line_rec_.n64, attr_);
   END IF;
   IF in_message_line_rec_.n65 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N65', in_message_line_rec_.n65, attr_);
   END IF;
   IF in_message_line_rec_.n66 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N66', in_message_line_rec_.n66, attr_);
   END IF;
   IF in_message_line_rec_.n67 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N67', in_message_line_rec_.n67, attr_);
   END IF;
   IF in_message_line_rec_.n68 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N68', in_message_line_rec_.n68, attr_);
   END IF;
   IF in_message_line_rec_.n69 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N69', in_message_line_rec_.n69, attr_);
   END IF;
   IF in_message_line_rec_.n70 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N70', in_message_line_rec_.n70, attr_);
   END IF;
   IF in_message_line_rec_.n71 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N71', in_message_line_rec_.n71, attr_);
   END IF;
   IF in_message_line_rec_.n72 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N72', in_message_line_rec_.n72, attr_);
   END IF;
   IF in_message_line_rec_.n73 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N73', in_message_line_rec_.n73, attr_);
   END IF;
   IF in_message_line_rec_.n74 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N74', in_message_line_rec_.n74, attr_);
   END IF;
   IF in_message_line_rec_.n75 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N75', in_message_line_rec_.n75, attr_);
   END IF;
   IF in_message_line_rec_.n76 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N76', in_message_line_rec_.n76, attr_);
   END IF;
   IF in_message_line_rec_.n77 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N77', in_message_line_rec_.n77, attr_);
   END IF;
   IF in_message_line_rec_.n78 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N78', in_message_line_rec_.n78, attr_);
   END IF;
   IF in_message_line_rec_.n79 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N79', in_message_line_rec_.n79, attr_);
   END IF;
   IF in_message_line_rec_.n80 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N80', in_message_line_rec_.n80, attr_);
   END IF;
   IF in_message_line_rec_.n81 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N81', in_message_line_rec_.n81, attr_);
   END IF;
   IF in_message_line_rec_.n82 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N82', in_message_line_rec_.n82, attr_);
   END IF;
   IF in_message_line_rec_.n83 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N83', in_message_line_rec_.n83, attr_);
   END IF;
   IF in_message_line_rec_.n84 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N84', in_message_line_rec_.n84, attr_);
   END IF;
   IF in_message_line_rec_.n85 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N85', in_message_line_rec_.n85, attr_);
   END IF;
   IF in_message_line_rec_.n86 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N86', in_message_line_rec_.n86, attr_);
   END IF;
   IF in_message_line_rec_.n87 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N87', in_message_line_rec_.n87, attr_);
   END IF;
   IF in_message_line_rec_.n88 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N88', in_message_line_rec_.n88, attr_);
   END IF;
   IF in_message_line_rec_.n89 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N89', in_message_line_rec_.n89, attr_);
   END IF;
     IF in_message_line_rec_.n90 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N90', in_message_line_rec_.n90, attr_);
   END IF;
   IF in_message_line_rec_.n91 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N91', in_message_line_rec_.n91, attr_);
   END IF;
   IF in_message_line_rec_.n92 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N92', in_message_line_rec_.n92, attr_);
   END IF;
   IF in_message_line_rec_.n93 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N93', in_message_line_rec_.n93, attr_);
   END IF;
   IF in_message_line_rec_.n94 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N94', in_message_line_rec_.n94, attr_);
   END IF;
   IF in_message_line_rec_.n95 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N95', in_message_line_rec_.n95, attr_);
   END IF;
   IF in_message_line_rec_.n96 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N96', in_message_line_rec_.n96, attr_);
   END IF;
   IF in_message_line_rec_.n97 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N97', in_message_line_rec_.n97, attr_);
   END IF;
   IF in_message_line_rec_.n98 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N98', in_message_line_rec_.n98, attr_);
   END IF;
   IF in_message_line_rec_.n99 IS NOT NULL THEN
      Client_SYS.Add_To_Attr ('N99', in_message_line_rec_.n99, attr_);
   END IF;
END Add_Number_To_Attr_;



-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Cleanup
IS
   cleanup_days_   NUMBER;
   cleanup_states_  VARCHAR2(100);
   sysdate_        DATE := SYSDATE;
   TYPE msg_id_type IS TABLE OF in_message_tab.message_id%TYPE;
   msg_id_          msg_id_type;

   CURSOR get_recs(cleanup_day_  NUMBER,
                   cleanup_states_  VARCHAR2) IS
      SELECT message_id
      FROM   in_message_tab
      WHERE  rowstate IN (select regexp_substr(cleanup_states_,'[^,]+', 1, level) from dual
                      connect by regexp_substr(cleanup_states_, '[^,]+', 1, level) is not null)
      AND    class_id   NOT IN ('IFS_REPLICATION', 'IFS_REPLICATION_CONFIGURATION')
      AND    rowversion < (sysdate_ - cleanup_day_);

BEGIN
   BEGIN
      cleanup_days_  := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('CON_KEEP_INBOX'));
      cleanup_states_ := Fnd_Setting_API.Get_Value('CON_CLEANUP_STATES');
   EXCEPTION
      WHEN OTHERS THEN
         cleanup_days_ := NULL;
   END;
   IF (cleanup_days_ IS NOT NULL) THEN
      OPEN get_recs(cleanup_days_, cleanup_states_);
      LOOP
         FETCH get_recs BULK COLLECT INTO msg_id_ LIMIT 1000; 
         FORALL i_ IN 1..msg_id_.count
            DELETE
               FROM in_message_tab
               WHERE message_id = msg_id_(i_);

         FORALL i_ IN 1..msg_id_.count
            DELETE 
               FROM in_message_line_tab 
               WHERE message_id = msg_id_(i_);
         -- Commit to avoid snapshot too old error
         @ApproveTransactionStatement(2013-11-19,haarse)
         COMMIT;
         EXIT WHEN get_recs%NOTFOUND;
      END LOOP;
      CLOSE get_recs;
   END IF;
END Cleanup;



