-----------------------------------------------------------------------------
--
--  Logical unit: DataArchive
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000301  HAAR  Created
--  020628  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030902  ROOD  Added check for appowner when using dbms_job (ToDo#4196).
--  050615  HAAR  Changed Init_All_Processes__ to use System privileges (F1PR483).
--  061227  HAAR  Init_All_Processes_ uses Batch_SYS.New_Job_App_Owner__ (Bug#62360).
--  100324  ASWI  Init_All_Processes_ : added schema_user to the where clause (Bug#89727)
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Init_All_Processes_ (
   dummy_ IN NUMBER )
IS
   time_         NUMBER;
   job_key_      NUMBER;
   process_      VARCHAR2(30);
   interval_     VARCHAR2(100);
BEGIN
   General_SYS.Check_Security(service_, 'DATA_ARCHIVE_SYS', 'Init_All_Processes_');
   -- Check for system privilege
   Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User);
   --
   --  Remove all old processing
   --
   Batch_SYS.Remove_Job_On_Method_('DATA_ARCHIVE_UTIL_API.PROCESS');
   --
   --  Check if arhiving process should be started
   --
   BEGIN
      process_ := Fnd_Setting_API.Get_Value('DATA_ARCHIVE');
   EXCEPTION
      WHEN OTHERS THEN
         process_ := 'OFF';
   END;
   IF (process_ = 'ON') THEN
      --
      -- Set interval in seconds
      --
      BEGIN
         time_ :=
          Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('DATA_ARCHIVE_STARTUP'));
         IF (time_ IS NULL) THEN
            time_ := 3600;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            time_ := 3600;
      END;
      interval_ := 'sysdate + '||to_char(time_)||'/86400';
      --
      -- Start new processes for archiving service
      --
      Batch_SYS.New_Job_App_Owner__(job_key_, 'Data_Archive_Util_API.Process_Archive_(0)', interval_);
   END IF;
END Init_All_Processes_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Register_Exec_Attr (
   order_id_ IN NUMBER,
   exec_id_ IN VARCHAR2,
   attr_no_ IN NUMBER,
   info_msg_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATA_ARCHIVE_SYS', 'Register_Exec_Attr');
   Data_Archive_Exec_Attr_API.Register__(order_id_, exec_id_, attr_no_, info_msg_);
END Register_Exec_Attr;


PROCEDURE Register_Object (
   aoid_ IN VARCHAR2,
   info_msg_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATA_ARCHIVE_SYS', 'Register_Object');
   Data_Archive_Object_API.Register__(aoid_, info_msg_);
END Register_Object;


PROCEDURE Register_Order (
   order_id_ IN OUT NUMBER,
   info_msg_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATA_ARCHIVE_SYS', 'Register_Order');
   Data_Archive_Order_API.Register__(order_id_, info_msg_);
END Register_Order;


PROCEDURE Register_Order_Exec (
   order_id_ IN NUMBER,
   exec_id_   IN VARCHAR2,
   info_msg_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATA_ARCHIVE_SYS', 'Register_Order_Exec');
   Data_Archive_Order_Exec_API.Register__(order_id_, exec_id_, info_msg_);
END Register_Order_Exec;


PROCEDURE Register_Source (
   aoid_ IN VARCHAR2,
   table_name_ IN VARCHAR2,
   info_msg_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATA_ARCHIVE_SYS', 'Register_Source');
   Data_Archive_Source_API.Register__(aoid_, table_name_, info_msg_);
END Register_Source;


PROCEDURE Register_Source_Attr (
   aoid_ IN VARCHAR2,
   table_name_ IN VARCHAR2,
   column_name_ IN VARCHAR2,
   info_msg_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DATA_ARCHIVE_SYS', 'Register_Source_Attr');
   Data_Archive_Source_Attr_API.Register__(aoid_, table_name_, column_name_, info_msg_);
END Register_Source_Attr;



