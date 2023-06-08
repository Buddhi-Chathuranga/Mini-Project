-----------------------------------------------------------------------------
--
--  Logical unit: Connectivity
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980128  ERFO  Changes concerning IFS/Server configuration parameter.
--  980324  JHMA  Removed configuration parameter CONNECTIVITY
--  980324  JHMA  Added check against configuration parameter CON_OUTBOX in
--                procedures accessing outbox.
--  980325  JHMA  Methods Set_Receive_On and Set_Send_On removed
--  980325  JHMA  Argument queue_id_ to Create_Message_Class replaced by action_
--  980325  JHMA  Security check with General_SYS.Init_Method added
--  010225  ROOD  Removed check for background processes (ToDo#3995).
--  020628  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021202  ROOD  Modified interface Create_Message_Class (GLOB04).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030218  ROOD  Changed hardcoded FNDCON to FNDBAS (ToDo#4149).
--  030402  HAAR  Added method Get_Message and Get_Mesage_Lines (ToDo#4175).
--  030902  ROOD  Added check for appowner when using dbms_job (ToDo#4196).
--  040923  JHMA  Added methods (Bug#47158).
--  041214  JHMA  No limit on restart interval (Bug#48506).
--  050615  HAAR  Changed Init_All_Processes__ to use System privileges (F1PR483).
--  061027  NiWiLK Modified Cleanup__(Bug#61210).
--  061227  HAAR  Init_All_Processes_ uses Batch_SYS.New_Job_App_Owner__ (Bug#62360).
--  110830  OVJOSE Added method Get_Next_In_Message_Id (EASTTWO-10359
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

connectivity_version_ CONSTANT VARCHAR2(10) := '2.1.0';
TYPE in_message       IS TABLE OF In_Message_Tab%ROWTYPE      INDEX BY BINARY_INTEGER;
TYPE in_message_lines IS TABLE OF In_Message_Line_pub%ROWTYPE INDEX BY BINARY_INTEGER;
TYPE in_message_line_states IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cleanup__
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Cleanup__');
   In_Message_Util_API.Cleanup;
   Out_Message_Util_API.Cleanup;
   Replication_Util_API.Cleanup__;
END Cleanup__;


PROCEDURE Init_All_Processes__ (
   dummy_ IN NUMBER )
IS
   default_time_ NUMBER;
   time_         NUMBER;
   job_key_      NUMBER;
   process_      VARCHAR2(30);
   interval_     VARCHAR2(100);
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Init_All_Processes__');
   -- Check for system privilege
   Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User);
   --
   --  Remove all old processing
   --
   Batch_SYS.Remove_Job_On_Method_('CONNECTIVITY_SYS.PROCESS');
   --
   -- Set default interval in seconds
   --
   BEGIN
      default_time_ := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('DEFJOB_INTERVAL'));
      IF (default_time_ < 5 OR default_time_ > 120 OR default_time_ IS NULL) THEN
         default_time_ := 30;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         default_time_ := 30;
   END;
   --
   --  Check if inbox should be started
   --
   BEGIN
      process_ := NVL(Fnd_Setting_API.Get_Value('CON_INBOX'),'OFF');
   EXCEPTION
      WHEN OTHERS THEN
         process_ := 'OFF';
   END;
   IF (process_ = 'ON') THEN
      --
      -- Set interval in seconds
      --
      BEGIN
         time_ := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('CON_IN_INTERVAL'));
         IF (time_ IS NULL) THEN
            time_ := default_time_;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            time_ := default_time_;
      END;
      IF    (time_ = 86400) THEN
         interval_ := 'sysdate + 1';
      ELSIF ( 86400/time_ = ROUND(86400/time_) AND 86400/time_ IN (2,3,4,6,8,12,24) ) THEN
         interval_ := 'sysdate + 1/' || to_char(86400/time_);
      ELSE
         interval_ := 'sysdate + '||to_char(time_)||'/86400';
      END IF;
      --
      -- Start new processes for inbox
      --
      Batch_SYS.New_Job_App_Owner__(job_key_, 'Connectivity_SYS.Process_Inbox__(0)', interval_);
   END IF;
   --
   --  Check if outbox should be started
   --
   BEGIN
      process_ := NVL(Fnd_Setting_API.Get_Value('CON_OUTBOX'),'OFF');
   EXCEPTION
      WHEN OTHERS THEN
         process_ := 'OFF';
   END;
   IF (process_ = 'ON') THEN
      --
      -- Set interval in seconds
      --
      BEGIN
         time_ := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('CON_OUT_INTERVAL'));
         IF (time_ IS NULL) THEN
            time_ := default_time_;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            time_ := default_time_;
      END;
      IF    (time_ = 86400) THEN
         interval_ := 'sysdate + 1';
      ELSIF ( 86400/time_ = ROUND(86400/time_) AND 86400/time_ IN (2,3,4,6,8,12,24) ) THEN
         interval_ := 'sysdate + 1/' || to_char(86400/time_);
      ELSE
         interval_ := 'sysdate + '||to_char(time_)||'/86400';
      END IF;
      --
      -- Start new processes for outbox
      --
      Batch_SYS.New_Job_App_Owner__(job_key_, 'Connectivity_SYS.Process_Outbox__(0)', interval_);
   END IF;
END Init_All_Processes__;


PROCEDURE Process_Inbox__ (
   dummy_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Process_Inbox__');
   In_Message_Util_API.Process_Inbox_;
END Process_Inbox__;


PROCEDURE Process_Outbox__ (
   dummy_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Process_Outbox__');
   Out_Message_Util_API.Process_Outbox__;
END Process_Outbox__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Message (
   in_message_id_ IN NUMBER ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Get_Message');
   attr_ := In_Message_Util_API.Get_Message_(in_message_id_);
   RETURN(attr_);
END Get_Message;


PROCEDURE Get_Message (
   count_         OUT NUMBER,
   message_       OUT in_message,
   in_message_id_ IN NUMBER ) 
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Get_Message');
   In_Message_Util_API.Get_Message_(count_, message_, in_message_id_);
END Get_Message;


PROCEDURE Get_Message_Lines (
   count_          OUT NUMBER,
   message_lines_  OUT in_message_lines,
   in_message_id_  IN  NUMBER ) 
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Get_Message_Lines');
   In_Message_Util_API.Get_Message_Lines_(count_, message_lines_, in_message_id_);
END Get_Message_Lines;


PROCEDURE Get_Message_Lines (
   count_           OUT NUMBER,
   message_lines_   OUT in_message_lines,
   in_message_id_   IN  NUMBER,
   states_          IN  in_message_line_states )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Get_Message_Lines');
   In_Message_Util_API.Get_Message_Lines_(count_, message_lines_, in_message_id_, states_);
END Get_Message_Lines;


PROCEDURE Create_Message (
   out_message_id_ OUT NUMBER,
   attr_           IN  VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   tmp_attr_   VARCHAR2(32000) := attr_;
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Create_Message');
   Out_Message_API.New__(info_, objid_, objversion_, tmp_attr_, 'DO');
   out_message_id_ := Client_SYS.Get_Item_Value('MESSAGE_ID', tmp_attr_);
END Create_Message;


PROCEDURE Create_Message_Line (
   attr_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   tmp_attr_   VARCHAR2(32000) := attr_;
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Create_Message_Line');
   Out_Message_Line_API.New__(info_, objid_, objversion_, tmp_attr_, 'DO');
END Create_Message_Line;


PROCEDURE Create_Message_Class (
   class_id_ IN VARCHAR2,
   action_   IN VARCHAR2 DEFAULT NULL,
   notes_    IN VARCHAR2 DEFAULT NULL,
   module_   IN VARCHAR2 DEFAULT 'FNDBAS' )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Create_Message_Class');
   Message_Class_API.Install_Class__(class_id_, action_, notes_, module_);
END Create_Message_Class;


PROCEDURE Release_Message (
   out_message_id_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Release_Message');
   Out_Message_API.Release_(out_message_id_);
END Release_Message;


PROCEDURE Accept_Message (
   in_message_id_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Accept_Message');
   In_Message_API.Accept_(in_message_id_);
END Accept_Message;


PROCEDURE Reject_Message (
   in_message_id_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Reject_Message');
   In_Message_API.Reject_(in_message_id_);
END Reject_Message;


FUNCTION Get_Next_Out_Message_Id RETURN NUMBER
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Get_Next_Out_Message_Id');
   RETURN Out_Message_API.Get_Next_Message_Id_;
END Get_Next_Out_Message_Id;


PROCEDURE Message_Class_Exist (
   message_class_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Message_Class_Exist');
   Message_Class_API.Exist(message_class_);
END Message_Class_Exist;


PROCEDURE Message_Media_Exist (
   media_code_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Message_Media_Exist');
   Message_Media_API.Exist(media_code_);
END Message_Media_Exist;


PROCEDURE Register_Action (
   class_id_ IN VARCHAR2,
   action_   IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Register_Action');
   Message_Class_API.Register_Action__(class_id_, action_);
END Register_Action;


FUNCTION Get_Next_In_Message_Id RETURN NUMBER
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Get_Next_In_Message_Id');
   RETURN In_Message_API.Get_Next_Message_Id__;
END Get_Next_In_Message_Id;


PROCEDURE Set_In_Message_State (
   in_message_id_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Set_In_Message_State');
   In_Message_API.Set_State_(in_message_id_);
END Set_In_Message_State;


PROCEDURE Accept_Message_Line (
   in_message_id_   IN NUMBER,
   in_message_line_ IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Accept_Message_Line');
   In_Message_Line_API.Accept_(in_message_id_, in_message_line_);
END Accept_Message_Line;


PROCEDURE Reject_Message_Line (
   in_message_id_   IN NUMBER,
   in_message_line_ IN NUMBER,
   error_           IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Reject_Message_Line');
   In_Message_Line_API.Reject_(in_message_id_, in_message_line_, error_);
END Reject_Message_Line;


PROCEDURE Reprocess_In_Message (
   in_message_id_   IN NUMBER )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Reprocess_In_Message');
   In_Message_API.Reprocess_(in_message_id_);
END Reprocess_In_Message;


PROCEDURE Add_Header_To_Attr (
   attr_                IN OUT VARCHAR2,
   in_message_line_rec_ IN OUT IN_MESSAGE_LINE_PUB%ROWTYPE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Add_Header_To_Attr');
   In_Message_Util_API.Add_Header_To_Attr_(attr_, in_message_line_rec_);
END Add_Header_To_Attr;


PROCEDURE Add_Char_To_Attr (
   attr_                IN OUT VARCHAR2,
   in_message_line_rec_ IN OUT IN_MESSAGE_LINE_PUB%ROWTYPE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Add_Char_To_Attr');
   In_Message_Util_API.Add_Char_To_Attr_(attr_, in_message_line_rec_);
END Add_Char_To_Attr;


PROCEDURE Add_Date_To_Attr (
   attr_                IN OUT VARCHAR2,
   in_message_line_rec_ IN OUT IN_MESSAGE_LINE_PUB%ROWTYPE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Add_Date_To_Attr');
   In_Message_Util_API.Add_Date_To_Attr_(attr_, in_message_line_rec_);
END Add_Date_To_Attr;


PROCEDURE Add_Number_To_Attr (
   attr_                IN OUT VARCHAR2,
   in_message_line_rec_ IN OUT IN_MESSAGE_LINE_PUB%ROWTYPE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'CONNECTIVITY_SYS', 'Add_Number_To_Attr');
   In_Message_Util_API.Add_Number_To_Attr_(attr_, in_message_line_rec_);
END Add_Number_To_Attr;



