-----------------------------------------------------------------------------
--
--  Logical unit: RemoteDebug
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  040816  HAAR  Created
--  040929  HAAR  Added support for stateless sessions (F1PR440)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Allowed___
IS
   remote_debugging_     VARCHAR2(3)    := Fnd_Setting_API.Get_Value('REMOTE_DEBUGGING');
   
   not_allowed EXCEPTION;
BEGIN
   IF (remote_debugging_ = 'OFF') THEN
      RAISE not_allowed;
   END IF;
EXCEPTION
   WHEN not_allowed THEN
      Error_SYS.Record_General(service_, 'DEBUG_NOT_ALLOWED: Remote debugging is not allowed on this installation.');
END Check_Allowed___;


PROCEDURE Start___ (
   host_ IN VARCHAR2,
   port_ IN NUMBER )
IS
   debug_privileges  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(debug_privileges, -1031);
   no_listener       EXCEPTION;
   PRAGMA            EXCEPTION_INIT(no_listener, -30683);
   debug_started     EXCEPTION;
   PRAGMA            EXCEPTION_INIT(debug_started, -30677);
BEGIN
   -- Check if Remote Debugging is allowed
   Check_Allowed___;
   Dbms_Debug_Jdwp.Connect_Tcp(host_, port_);
EXCEPTION
   WHEN debug_privileges THEN
      Error_SYS.Record_General(service_, 'DEBUG_PRIV_START: The user must have the role FND_DEVELOPER granted to be able to start remote debug session.');
   WHEN no_listener THEN
      Error_SYS.Record_General(service_, 'DEBUG_NO_LISTENER: No Remote Debug Listener exists to connect to on this host and port number.');
   WHEN debug_started THEN
      --Stop___;
      Dbms_Debug_Jdwp.Connect_Tcp(host_, port_);
END Start___;


PROCEDURE Stop___
IS
   debug_privileges  EXCEPTION;
   PRAGMA            EXCEPTION_INIT(debug_privileges, -1031);
BEGIN
   -- Check if Remote Debugging is allowed
   Check_Allowed___;
   Dbms_Debug_Jdwp.Disconnect;
EXCEPTION
   WHEN debug_privileges THEN
      Error_SYS.Record_General(service_, 'DEBUG_PRIV_STOP: The user must have the role FND_DEVELOPER granted to be able to stop remote debug session.');
END Stop___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remote_Debug_Start (
   host_ IN VARCHAR2 DEFAULT 'localhost',
   port_ IN NUMBER DEFAULT 4000 )
IS
BEGIN
   Start___(host_, port_);
END Remote_Debug_Start;


PROCEDURE Remote_Debug_Stop
IS
BEGIN
   Stop___;
END Remote_Debug_Stop;



