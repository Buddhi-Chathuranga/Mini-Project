-----------------------------------------------------------------------------
--
--  Logical unit: FndSessionUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  071031  HAAR  Created
--  080805  HAAR  Added function debug.
--                Added Appowner owned contexts.
--                Switched to implementation methods during elaboration (Bug#76153).
--  101014  HAAR  Don't set all properties during elaboration if user is IFSSYS (Bug#93593).
--  110810  DUWI  Added machine name and program for the session (Bug#94800)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

context_ CONSTANT VARCHAR2(30) := 'FNDSESSION_CTX';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Set_Client_Info___ (
   name_  IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   --
   -- Right now we are just using position 1..34.
   -- When new parameters are added we need to change the code below to handle the whole string.
   --
   IF (name_ = 'FND_USER') THEN
      Set_Client_Info___(value_, 1, 30);
   ELSIF (name_ = 'APP_OWNER_BOOLEAN') THEN
      Set_Client_Info___(value_, 31, 31);
   ELSIF (name_ = 'LANGUAGE') THEN
      Set_Client_Info___(value_, 32, 35);
   END IF;
END Set_Client_Info___;


PROCEDURE Set_Client_Info___ (
   value_    IN VARCHAR2,
   from_pos_ IN NUMBER,
   to_pos_   IN NUMBER )
IS
   client_info_ VARCHAR2(64);
BEGIN
   dbms_application_info.read_client_info(client_info_);
   client_info_ := rpad(substr(Nvl(client_info_,' '), 1, from_pos_-1), from_pos_-1)||
                   rpad(value_, to_pos_ - from_pos_ + 1)||
                   substr(client_info_, to_pos_ + 1);
   dbms_application_info.set_client_info(client_info_);
END Set_Client_Info___;


PROCEDURE Set_Fnd_User___ (
      fnduser_    IN VARCHAR2 )
IS 
BEGIN
   Dbms_Session.Set_Context(context_, 'FND_USER', fnduser_);
   Set_Client_Info___('FND_USER', fnduser_);
   IF (fnduser_ = Sys_Context('USERENV', 'CURRENT_SCHEMA')) THEN
      Dbms_Session.Set_Context(context_, 'APP_OWNER_BOOLEAN', '1');
      Set_Client_Info___('APP_OWNER_BOOLEAN', '1');
   ELSE
      Dbms_Session.Set_Context(context_, 'APP_OWNER_BOOLEAN', '0');
      Set_Client_Info___('APP_OWNER_BOOLEAN', '0');
   END IF;
   Trace_SYS.Message('========================================== ');
   Trace_SYS.Message('Set_Fnd_User_ ');
   Trace_SYS.Message('========================================== ');
   Trace_SYS.Message('Foundation User is set to ' || fnduser_ || '.');
END Set_Fnd_User___;


PROCEDURE Set_App_Owner___ (
   appowner_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'APP_OWNER', appowner_);
END Set_App_Owner___;

PROCEDURE Set_Initiator___ (
   initiator_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'INITIATOR', initiator_);
END Set_Initiator___;


PROCEDURE Set_Oracle_User___ (
   oracle_user_ IN VARCHAR2 )
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'ORACLE_USER', oracle_user_);
END Set_Oracle_User___;


PROCEDURE Set_Os_User_Name___ (
   os_user_name_ IN VARCHAR2 )
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'OS_USER_NAME', os_user_name_);
END Set_Os_User_Name___;


PROCEDURE Set_Program___ (
   program_ IN VARCHAR2 )
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'PROGRAM', program_);
END Set_Program___;


PROCEDURE Set_Machine___ (
   machine_ IN VARCHAR2 )
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'MACHINE', machine_);
END Set_Machine___;


PROCEDURE Set_Language___ (
   language_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'LANGUAGE', language_);
   Set_Client_Info___('LANGUAGE', language_);
END Set_Language___;


PROCEDURE Set_Lang_Code_Version___ (
   lang_code_  IN VARCHAR2,
   version_    IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, upper(lang_code_)||'_LANG_VERSION', version_);
END Set_Lang_Code_Version___;


PROCEDURE Set_Calendar___ (
   calendar_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'CALENDAR', calendar_);
END Set_Calendar___;


PROCEDURE Set_Property___ (
   name_  IN VARCHAR2,
   value_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, name_, value_);
END Set_Property___;


PROCEDURE Set_Properties___ (
   properties_ IN VARCHAR2 ) 
IS
BEGIN
   --   Dbms_Session.Set_Context(context_, 'PROPERTIES', properties_);
   NULL;
END Set_Properties___;


PROCEDURE Set_Directory_Id___ (
   directory_id_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'DIRECTORY_ID', directory_id_);
END Set_Directory_Id___;


PROCEDURE Set_Rfc3066___ (
   rfc3066_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'RFC3066', rfc3066_);
END Set_Rfc3066___;


PROCEDURE Set_Client_Id___ (
   client_id_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'CLIENT_ID', client_id_);
   Dbms_Session.Set_Identifier(client_id_);
END Set_Client_Id___;


PROCEDURE Set_Checkpoint_Id___ (
   checkpoint_id_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'CHECKPOINT_ID', checkpoint_id_);
END Set_Checkpoint_Id___;


PROCEDURE Set_Web_User___ (
   web_user_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'WEB_USER', web_user_);
END Set_Web_User___;


PROCEDURE Set_Current_Job_Id___ (
   job_id_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'CURRENT_JOB_ID', job_id_);
END Set_Current_Job_Id___;

PROCEDURE Set_Checkpoint_User___ (
   checkpoint_user_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'CHECKPOINT_USER', checkpoint_user_);
END Set_Checkpoint_User___;

PROCEDURE Set_Checkpoint_Comment___ (
   checkpoint_comment_ IN VARCHAR2 ) 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'CHECKPOINT_COMMENT', checkpoint_comment_);
END Set_Checkpoint_Comment___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Clear_User_Properties_ (
   clear_all_  IN BOOLEAN DEFAULT FALSE )
IS
   context_arr_   Dbms_Session.appctxtabtyp;
   context_size_ NUMBER;
BEGIN
   Dbms_Session.List_Context (context_arr_, context_size_);
   FOR i IN 1 .. context_arr_.COUNT LOOP
      IF (context_arr_(i).namespace = context_) THEN
         IF (clear_all_) THEN
            IF (context_arr_(i).attribute NOT IN ('SECURITY_CHECKPOINT', 'CHECKPOINT_USER', 'CHECKPOINT_COMMENT')) THEN
               Dbms_Session.Clear_Context(namespace => context_arr_(i).namespace, attribute => context_arr_(i).attribute);
            END IF;
         ELSE
            IF (context_arr_(i).attribute NOT IN ('SECURITY_CHECKPOINT', 'CHECKPOINT_USER', 'CHECKPOINT_COMMENT', 'FND_USER', 'APP_OWNER', 'WEB_USER', 'CALENDAR', 'APP_OWNER_BOOLEAN', 'LANGUAGE', 'OS_USER_NAME', 'DIRECTORY_ID', 'RFC3066', 'PROGRAM', 'MACHINE')) THEN 
               Dbms_Session.Clear_Context(namespace => context_arr_(i).namespace, attribute => context_arr_(i).attribute);
            END IF;
         END IF;
      END IF;
   END LOOP;
END Clear_User_Properties_;


PROCEDURE Set_Client_Info_ (
   name_  IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Set_Client_Info___(name_, value_);
END Set_Client_Info_;


PROCEDURE Set_App_Owner_ (
   appowner_ IN VARCHAR2 ) 
IS
BEGIN
   Set_App_Owner___(appowner_);
END Set_App_Owner_;


PROCEDURE Set_Initiator_ (
   initiator_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Initiator___(initiator_);
END Set_Initiator_;


PROCEDURE Set_Oracle_User_ (
   oracle_user_ IN VARCHAR2 )
IS
BEGIN
   Set_Oracle_User___(oracle_user_);
END Set_Oracle_User_;


PROCEDURE Set_Os_User_Name_ (
   os_user_name_ IN VARCHAR2 )
IS
BEGIN
   Set_Os_User_Name___(os_user_name_);
END Set_Os_User_Name_;


PROCEDURE Set_Program_ (
   program_ IN VARCHAR2 )
IS
BEGIN
   Set_Program___(program_);
END Set_Program_;


PROCEDURE Set_Machine_ (
   machine_ IN VARCHAR2 )
IS
BEGIN
   Set_Machine___(machine_);
END Set_Machine_;

PROCEDURE Open_Security_Checkpoint_ 
IS
BEGIN
   Dbms_Session.Set_Context(context_, 'SECURITY_CHECKPOINT', 'OPEN');
END Open_Security_Checkpoint_;

PROCEDURE Reset_Security_Checkpoint_Ctx_ 
IS
BEGIN
  Dbms_Session.Clear_Context(namespace => context_, attribute => 'SECURITY_CHECKPOINT');
END Reset_Security_Checkpoint_Ctx_;

PROCEDURE Set_Fnd_User_ (
   fnduser_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Fnd_User___(fnduser_);
END Set_Fnd_User_;

@UncheckedAccess
PROCEDURE Set_Fnd_User_Parallel_ (
   fnduser_ IN VARCHAR2 ) 
IS
BEGIN   
   Set_Fnd_User___(fnduser_);
END Set_Fnd_User_Parallel_;

PROCEDURE Reset_Fnd_User_ 
IS
   old_fnd_user_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   level_        VARCHAR2(10) := nvl(Fnd_Session_API.Get_Property('ORIGINAL_FND_USER_LEVEL'), '0');
BEGIN
   IF level_ > 0 THEN
      Set_Fnd_User_(Fnd_Session_API.Get_Property('ORIGINAL_FND_USER_'||level_));
      Dbms_Session.Clear_Context(context_, NULL, 'ORIGINAL_FND_USER_'||level_);
      Dbms_Session.Set_Context(context_, 'ORIGINAL_FND_USER_LEVEL', to_char(to_number(level_)-1));
      Log_SYS.Fnd_Trace_(Log_SYS.info_, '========================================== ');
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Fnd_Session_Util_API.Reset_Fnd_User_ ');
      Log_SYS.Fnd_Trace_(Log_SYS.info_, '========================================== ');
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Foundation User is reset from ' || old_fnd_user_ || ' to original Foundation User ' || Fnd_Session_API.Get_Fnd_User || '.');
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, '========================================== ');
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Fnd_Session_Util_API.Reset_Fnd_User_ ');
      Log_SYS.Fnd_Trace_(Log_SYS.info_, '========================================== ');
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Foundation User is not reset. Foundation user is ' || Fnd_Session_API.Get_Fnd_User || '.');
--      Error_SYS.Appl_General(lu_name_, 'NOT_IMPERSONATING: You are currently not impersonating any user [Currrent user is :P1].', Fnd_Session_API.Get_Fnd_User);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      Log_SYS.Fnd_Trace_(Log_SYS.error_, '========================================== ');
      Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Fnd_Session_Util_API.Reset_Fnd_User_ ');
      Log_SYS.Fnd_Trace_(Log_SYS.error_, '========================================== ');
      Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Foundation User is not reset. Foundation user is ' || Fnd_Session_API.Get_Fnd_User || '.');
      RAISE;
END Reset_Fnd_User_;


PROCEDURE Impersonate_Fnd_User_ (
   fnduser_ IN VARCHAR2 ) 
IS
   old_fnduser_  VARCHAR2(30);
   level_        VARCHAR2(10)    := nvl(Fnd_Session_API.Get_Property('ORIGINAL_FND_USER_LEVEL'), '0');
BEGIN
   -- Set old fnd_user
   old_fnduser_ := Fnd_Session_API.Get_Fnd_User;
   -- Extra security check
   Security_SYS.Has_System_Privilege('IMPERSONATE USER', old_fnduser_);
   -- Check if Fnd_User exists
   Fnd_User_API.Exist(fnduser_);
   -- Check if trying to impersonate more than once, if yes then raise error.
   -- It is not allowed to impersonate recursive, one must use reset_user before impersonating again instead.
      -- If the job is a background job we need to accept that one is impersonating twice, 
      -- since the framework starts to do the first impersonation in Batch_SYS.Run_Job and the second in Transaction_SYS.Process_All_Pending
   IF Sys_Context('USERENV', 'BG_JOB_ID') IS NOT NULL THEN
      IF level_+1 > 3 THEN
         Error_SYS.Appl_General(lu_name_, 
                                'IMPERSONATING_LEVEL: You are impersonating more than once, which is not allowed. [Currrent user is :P1.]', 
                                Fnd_Session_API.Get_Fnd_User);
      END IF;
   ELSE
      IF level_+1 > 1 THEN
         Error_SYS.Appl_General(lu_name_, 
                                'IMPERSONATING_LEVEL: You are impersonating more than once, which is not allowed. [Currrent user is :P1.]', 
                                Fnd_Session_API.Get_Fnd_User);
      END IF;
   END IF;
   -- Important to set this before setting App_owner
   level_ := to_char(to_number(level_)+1);
   Dbms_Session.Set_Context(context_, 'ORIGINAL_FND_USER_'||level_, old_fnduser_);
   Dbms_Session.Set_Context(context_, 'ORIGINAL_FND_USER_LEVEL', level_);
   Set_Fnd_User_(fnduser_);
   Log_SYS.Fnd_Trace_(Log_SYS.info_, '========================================== ');
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Fnd_Session_Util_API.Impersonate_Fnd_User_ ');
   Log_SYS.Fnd_Trace_(Log_SYS.info_, '========================================== ');
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Foundation User ' || old_fnduser_ || ' is impersonating Foundation User ' || fnduser_ || '.');
EXCEPTION
   WHEN OTHERS THEN
      Log_SYS.Fnd_Trace_(Log_SYS.error_, '========================================== ');
      Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Fnd_Session_Util_API.Impersonate_Fnd_User_ ');
      Log_SYS.Fnd_Trace_(Log_SYS.error_, '========================================== ');
      Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Could not impersonate Foundation User ' || fnduser_ || '.');
      RAISE;
END Impersonate_Fnd_User_;


PROCEDURE Set_Language_ (
   language_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Language___(language_);
END Set_Language_;


PROCEDURE Set_Calendar_ (
   calendar_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Calendar___(calendar_);
END Set_Calendar_;


PROCEDURE Set_Directory_Id_ (
   directory_id_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Directory_Id___(directory_id_);
END Set_Directory_Id_;


PROCEDURE Set_Rfc3066_ (
   rfc3066_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Rfc3066___(rfc3066_);
END Set_Rfc3066_;


PROCEDURE Set_Client_Id_ (
   client_id_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Client_Id___(client_id_);
END Set_Client_Id_;


PROCEDURE Set_Checkpoint_Id_ (
   checkpoint_id_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Checkpoint_Id___(checkpoint_id_);
END Set_Checkpoint_Id_;


PROCEDURE Set_Web_User_ (
   web_user_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Web_USer___(web_user_);
END Set_Web_User_;


PROCEDURE Set_Current_Job_Id_ (
   job_id_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Current_Job_Id___(job_id_);
END Set_Current_Job_Id_;


PROCEDURE Set_Property_ (
   name_  IN VARCHAR2,
   value_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Property___(name_, value_);
END Set_Property_;


PROCEDURE Set_Properties_ (
   properties_ IN VARCHAR2 ) 
IS
BEGIN
   --Set_Properties___(properties_);
   NULL;
END Set_Properties_;

PROCEDURE Set_Checkpoint_User_ (
   checkpoint_user_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Checkpoint_User___(checkpoint_user_);
END Set_Checkpoint_User_;

PROCEDURE Set_Checkpoint_Comment_ (
   checkpoint_comment_ IN VARCHAR2 ) 
IS
BEGIN
   Set_Checkpoint_Comment___(checkpoint_comment_);
END Set_Checkpoint_Comment_;

PROCEDURE Set_Lang_Code_Version_ (
   lang_code_     IN VARCHAR2,
   version_       IN VARCHAR2 ) 
IS
BEGIN
   Set_Lang_Code_Version___(lang_code_, version_);
END Set_Lang_Code_Version_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Debug
IS
   context_arr_   Dbms_Session.appctxtabtyp;
   context_size_ NUMBER;
BEGIN
   Dbms_Session.List_Context (context_arr_, context_size_);
   FOR i IN 1 .. context_arr_.COUNT LOOP
      IF (context_arr_(i).namespace = context_) THEN
         Dbms_Output.Put_Line(context_arr_(i).namespace||':'||context_arr_(i).attribute||': '||context_arr_(i).value);
      END IF;
   END LOOP;
END Debug;


BEGIN
   Set_App_Owner___(Sys_Context('USERENV', 'CURRENT_SCHEMA'));
   IF (user != 'IFSSYS' AND Nvl(Fnd_Session_API.Get_Initiator, 'NONE') = 'NONE') THEN
      Set_Initiator___('ELABORATION');
      Set_Fnd_User___(USER);
      Set_Language___(nvl(Fnd_User_API.Get_Recursive_Property_(Fnd_Session_API.Get_Fnd_User, 'PREFERRED_LANGUAGE'), Fnd_Setting_API.Get_Value('DEFAULT_LANGUAGE', TRUE))); -- Special case because of Log_SYS call, Passing TRUE to skip_module_check_, and DEFAULT_LANGUAGE is in FNDBAS
      Set_Calendar___('GREGORIAN');
   END IF;
END;
