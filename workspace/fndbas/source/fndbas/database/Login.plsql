-----------------------------------------------------------------------------
--
--  Logical unit: Login
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000121  ERFO  Created for version 3.0.0 Beta1 (ToDo #3818).
--  001212  ERFO  Added corrections in Init_External_Session_ (ToDo #3937).
--  001219  ROOD  Replaced PKG with LOGIN_SYS to enable wrapping (ToDo #3937).
--  010103  ROOD  Changes in Init_Nt_Session_ (ToDo #3937).
--  010104  ROOD  Added method Check_Session_ (ToDo #3937).
--  030209  ROOD  Made username always uppercase to make interfaces more tolerant.
--                Minor modifications for FNDAS (ToDo#4200).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030826  ROOD  Performance improvements in Init-methods (ToDo#4280).
--  031022  ROOD  Emptied current_directory_id in Init_External_Session_ to avoid
--                possible incorrect setting of user (ToDo#4280).
--  031022  ROOD  Activated a check that Oracle sessions could not be created as appowner.
--  041001  HAAR  Added Init_Fnd_Session and Remote Debugging for Extended Server (F1PR440).
--  041119  HAAR  Changed language handling (F1PR413E).
--                Changed Init_Fnd_Session_ to handle RFC_3066 language code.
--  050405  HAAR  Implement Activity Based Security (F1PR489).
--  050510  HAAR  Added trace support through Dbms_Application_Info (F1PR480).
--  050705  HAAR  Check for System privilege CONNECT in Init_Fnd_Session__ (F1PR843).
--  050926  HAAR  Init_Session___ should not accept null in directory_id_.
--  051123  HAAR  Removed check for System privilege CONNECT in Init_Fnd_Session__ (F1PR843).
--  060618  HAAR  Prepared for support of Persian calendar in server code (Bug#58601).
--  060912  HAAR  Added support for Application context variables in PL/SQL (Bug#60449).
--  071123  HAAR  Performance tuning of Init_Fnd_Session_ (Bug#69534).
--  080312  HAAR  Implement Fnd_Session properties as a context (Bug#68143).
--  090319  HAAR  Added support for client tracing (IID#80009).
--  110327  HAAR  Added support for changing language (EACS-2095).
------------------------------------------------------------------------------
--
--  Dependencies: General_SYS
--                Security_SYS
--                Client_SYS
--                Trace_SYS
--                Fnd_User_API
--
--  Contents:     Public methods for session initiation task
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

ifssys_                 CONSTANT VARCHAR2(30)  := 'IFSSYS';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Client_Tracing___ (
   client_id_           IN VARCHAR2,
   activity_            IN VARCHAR2,
   method_              IN VARCHAR2,   
   client_tracing_      IN VARCHAR2 DEFAULT 'FALSE',
   client_statistics_   IN VARCHAR2 DEFAULT 'FALSE')
IS
   tracing_enabled      EXCEPTION;
   PRAGMA               EXCEPTION_INIT(tracing_enabled, -13851);
   tracing_disabled     EXCEPTION;
   PRAGMA               EXCEPTION_INIT(tracing_disabled, -13850);
   statistics_enabled   EXCEPTION;
   PRAGMA               EXCEPTION_INIT(statistics_enabled, -13861);
   statistics_disabled  EXCEPTION;
   PRAGMA               EXCEPTION_INIT(statistics_disabled, -13862);
BEGIN
   Dbms_Application_Info.Set_Module(activity_, method_); 
   Dbms_Session.Set_Identifier(client_id_);
   BEGIN
      IF client_tracing_ = 'TRUE' THEN
         Dbms_Monitor.Client_Id_Trace_Enable(client_id_, TRUE, TRUE);
      ELSE
         Dbms_Monitor.Client_Id_Trace_Disable(client_id_);
      END IF;
   EXCEPTION 
      WHEN tracing_enabled OR tracing_disabled THEN
         NULL;
   END;
   --
   BEGIN
      IF client_statistics_ = 'TRUE' THEN
         Dbms_Monitor.Client_Id_Stat_Enable(client_id_);
      ELSE
         Dbms_Monitor.Client_Id_Stat_Disable(client_id_);
      END IF;
   EXCEPTION 
      WHEN statistics_enabled OR statistics_disabled THEN
         NULL;
   END;
END Client_Tracing___;

PROCEDURE Set_Language___ (
   lang_code_rfc3066_ IN VARCHAR2)
IS
   lang_code_ VARCHAR2(5); 
BEGIN
   Fnd_Session_API.Set_Rfc3066__(lang_code_rfc3066_);
   lang_code_ := Language_Code_API.Get_Lang_Code_From_Rfc3066(lang_code_rfc3066_);
   IF lang_code_ IS NULL THEN
      Error_SYS.Appl_General(service_, 'INVALID_LANG_CODE: Invalid laguage code (:P1).',lang_code_rfc3066_);
   END IF;
   Fnd_Session_API.Set_Language(lang_code_);
END Set_Language___;

FUNCTION Init_Fnd_Session___ (
   context_             IN VARCHAR2,
   directory_id_        IN VARCHAR2,
   lang_code_rfc3066_   IN VARCHAR2,
   log_level_           IN VARCHAR2 ) RETURN VARCHAR2
IS
   upper_directory_id_ VARCHAR2(2048) := upper(directory_id_);
   fnd_user_           VARCHAR2(30);
   -- To be replaced when implemeting support for different calendars
   --calendar_           VARCHAR2(30) := Message_SYS.Find_Attribute(context_, 'CALENDAR', '');
   calendar_           VARCHAR2(30) := 'GREGORIAN';
   
BEGIN
   --
   -- Set session trace flags
   --
   Log_SYS.Set_Log_Level_(Log_SYS.Get_Level_(log_level_));      
   
   --
   -- Check that Directory_id_ is not null
   --
   IF (directory_id_ IS NULL) THEN
      Error_SYS.Appl_General(service_, 'DIRIDNULL: Directory id must have a value, can not be NULL.',
                             upper_directory_id_);
   END IF;
   --
   -- Set current session language variables if new session.
   -- Changing language is not possible for performance reasons
   --
   IF (Fnd_Session_API.Get_Language IS NULL OR lang_code_rfc3066_ <> Fnd_Session_API.Get_Rfc3066) THEN
      Set_Language___(lang_code_rfc3066_);
   END IF;
   --
   -- Set calendar if client has a different value
   --
   IF (calendar_ != Fnd_Session_API.Get_Calendar) THEN
      IF (calendar_ IS NOT NULL) THEN
         Fnd_Session_API.Set_Calendar__(calendar_);
      END IF;
   END IF;
   --
   -- Fetch FndUser from Web User/Directory Id, check license and initialize session properties if new user
   --
   IF Fnd_Session_API.Get_Directory_Id IS NULL OR Fnd_Session_API.Get_Fnd_User IS NULL OR Fnd_Session_API.Get_Directory_Id <> upper_directory_id_ THEN
      fnd_user_ := Fnd_User_API.Get_Web_User_Identity_(upper_directory_id_);
      IF (fnd_user_ IS NULL) THEN
         Error_SYS.Appl_General(service_, 'FUSRNULL: The directory id :P1 is not allowed to run the application.',
                                upper_directory_id_);
      END IF;
      --
      -- Check that the Oracle user is IFS Applications System User. This is to avoid the possibility to run
      -- a complete installation with many sessions using a demo license.
      --
      IF (User != ifssys_) THEN
         Error_SYS.Appl_General(service_, 'NOT_IFSSYS_USER: Only IFS Applications System user is allowed to run initiate sessions.');
      END IF;
      --
      -- Set properties
      --
      Fnd_Session_API.Set_Fnd_User(fnd_user_);
      Fnd_Session_API.Set_Directory_Id__(upper_directory_id_);
      Fnd_Session_API.Set_Property('WEB_USER', upper_directory_id_);
   ELSE
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
   END IF;
   Fnd_Session_Util_API.Clear_User_Properties_;
   Client_SYS.Clear_Info;
   --
   -- Give some trace output
   --
   IF (log_level_ IS NOT NULL) THEN
      Log_SYS.Fnd_Trace_(Log_SYS.info_, '============================ ');
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Login_SYS.Init_Fnd_Session__ ');
      Log_SYS.Fnd_Trace_(Log_SYS.info_, '============================ ');
      Log_SYS.Fnd_Trace_(Log_SYS.info_, '============================ ');
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Context: ' || context_);
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Foundation User: ' || Fnd_Session_API.Get_Fnd_User);
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Current Language Code Rfc3066: ' || Fnd_Session_API.Get_Rfc3066);
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Language Code Rfc3066: ' || lang_code_rfc3066_);
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Current Language Code: ' || Fnd_Session_API.Get_Language);
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Language Code: ' || Language_Code_API.Get_Lang_Code_From_Rfc3066(lang_code_rfc3066_));
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Calendar: ' || Fnd_Session_API.Get_Calendar);
   END IF;
   RETURN fnd_user_;
END Init_Fnd_Session___;


PROCEDURE Set_Method_Security___ (
   check_method_security_ IN VARCHAR2 )
IS
BEGIN
   CASE check_method_security_
      WHEN 'FALSE' THEN
         Fnd_Context_SYS.Set_Value('LOGIN_SYS.method_security_', FALSE);
      WHEN 'TRUE' THEN
         Fnd_Context_SYS.Set_Value('LOGIN_SYS.method_security_', TRUE);
      ELSE
         Fnd_Context_SYS.Set_Value('LOGIN_SYS.method_security_', TRUE);
   END CASE;
END Set_Method_Security___;


-- Reset_Odp_Session___
--   This method is to be called to reset a Odata Provider database session
PROCEDURE Reset_Odp_Session___
IS
BEGIN
   IF (User != ifssys_) THEN
      Error_SYS.Appl_General(service_, 'NOT_IFSSYS_USER2: Only IFS Applications System user is allowed to run this method.');
   END IF;
   Fnd_Session_Util_API.Clear_User_Properties_(TRUE);
   Dbms_Application_Info.Set_Module(NULL, NULL); 
   Dbms_Session.Set_Identifier(NULL);      
END Reset_Odp_Session___;

FUNCTION Init_Odp_Session___ (
   lang_code_rfc3066_     IN OUT VARCHAR2,
   debug_enabled_         IN OUT VARCHAR2,
   sql_trace_enabled_     IN OUT VARCHAR2,
   directory_id_          IN VARCHAR2,
   security_check_type_   IN VARCHAR2,
   projection_name_       IN VARCHAR2 DEFAULT NULL,
   metadata_version_      IN VARCHAR2 DEFAULT NULL,
   entity_name_           IN VARCHAR2 DEFAULT NULL,
   action_name_           IN VARCHAR2 DEFAULT NULL,
   client_id_             IN VARCHAR2 DEFAULT NULL,
   client_statistics_     IN VARCHAR2 DEFAULT 'FALSE',
   client_tracing_        IN VARCHAR2 DEFAULT 'FALSE' ) RETURN VARCHAR2
IS
   fnd_user_ VARCHAR2(32000);
   in_lang_code_rfc3066_ VARCHAR2(20) := lang_code_rfc3066_;
   
   activity_   VARCHAR2(1000);
   method_     VARCHAR2(1000);
   log_level_  VARCHAR2(100) := NULL;
   version_    VARCHAR2(100);
BEGIN
   Reset_Odp_Session___;
   IF Language_Code_API.Get_Installed_Db_From_Rfs3066(in_lang_code_rfc3066_) = 'FALSE' THEN
      IF Language_Code_API.Get_Installed_Db(in_lang_code_rfc3066_) = 'TRUE' THEN
         lang_code_rfc3066_ := Language_Code_API.Get_Lang_Code_Rfc3066(in_lang_code_rfc3066_);
         in_lang_code_rfc3066_ := lang_code_rfc3066_;
      ELSE
         lang_code_rfc3066_ := Language_Code_API.Get_Lang_Code_Rfc3066(nvl(Fnd_Setting_API.Get_Value('DEFAULT_LANGUAGE'), 'en'));
      END IF;
   END IF;
   
   activity_ := projection_name_;
   
   CASE security_check_type_
   WHEN 'PROJECTION' THEN
      method_ := 'QUERY';
   WHEN 'ENTITY_CUD' THEN
      method_ := 'CUD';
   WHEN 'UNBOUND_ACTION' THEN
      method_ := action_name_;
   WHEN 'BOUND_ACTION' THEN
      method_ := entity_name_ || '.' || action_name_; 
   ELSE
      NULL;
   END CASE;
   
   IF debug_enabled_ = 'TRUE' THEN
      log_level_ := 'DEBUG';
   END IF;
   
   fnd_user_ := Init_Fnd_Session_(directory_id_ => directory_id_,
                                  check_method_security_ => 'FALSE',
                                  lang_code_rfc3066_ => lang_code_rfc3066_,
                                  log_level_ => log_level_,
                                  client_id_ => client_id_,
                                  client_statistics_ => client_statistics_,
                                  client_tracing_ => client_tracing_,
                                  activity_ => activity_,
                                  method_ => method_);
                                  
   Fnd_Session_API.Set_Property('ODP_SESSION', 'TRUE');
  
   IF sql_trace_enabled_  = 'TRUE' THEN
      IF Security_SYS.Has_System_Privilege('DEBUGGER', fnd_user_) AND Fnd_Setting_API.Get_Value('SQL_TRACE') = 'ON' THEN
         Database_SYS.Set_Sql_Trace__('TRUE', client_id_);
      ELSE
         sql_trace_enabled_ := 'FALSE';
      END IF;
   END IF;

   IF debug_enabled_ = 'TRUE' THEN
      -- We can only do this check after session initilization
      IF Security_SYS.Has_System_Privilege('DEBUGGER') = 'FALSE' THEN
         -- User does not have privileges turn off debug
         debug_enabled_ := 'FALSE';
         Log_SYS.Set_Log_Level_(Log_SYS.Get_Level_(NULL));  
      END IF;
   END IF;
   
   IF in_lang_code_rfc3066_ <> lang_code_rfc3066_ THEN
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Language ['||in_lang_code_rfc3066_||'] was not available. Defaulted to ['||lang_code_rfc3066_||']' );
   END IF;
   
   IF (projection_name_ = 'QuickReports') THEN
      -- Version for Quick Reports are being retrieved from their QR Template projection.
      version_ := Quick_Report_API.Get_Projection_Version__;
   ELSE
      version_ := Model_Design_SYS.Get_Projection_Version_(projection_name_);
   END IF;
   
   IF fnd_user_ = Fnd_Session_API.Get_App_Owner THEN
      IF metadata_version_ IS NOT NULL AND metadata_version_ != version_ THEN
         Error_SYS.Projection_Meta_Modified(lu_name_, projection_name_);
      END IF;
      RETURN fnd_user_;
   END IF;
   
   CASE security_check_type_
   WHEN 'PROJECTION' THEN
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Checking security for Projection ' || projection_name_);
      Fnd_Projection_Grant_API.Check_Available(projection_name_);
   WHEN 'ENTITY_CUD' THEN
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Checking CUD security for ' || projection_name_||'.'||entity_name_);
      Fnd_Proj_Entity_Grant_API.Check_CUD_Allowed(projection_name_,entity_name_);
   WHEN 'UNBOUND_ACTION' THEN
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Checking security for Action '|| action_name_ || ' on Projection '|| projection_name_);
      Fnd_Proj_Action_Grant_API.Check_Available(projection_name_,action_name_);
   WHEN 'BOUND_ACTION' THEN
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Checking security for Action '|| action_name_ || ' on Entity '|| projection_name_ || '.' ||entity_name_);
      Fnd_Proj_Ent_Action_Grant_API.Check_Available(projection_name_,entity_name_,action_name_);
   WHEN 'NO_CHECK' THEN
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Odata Provider Session intilized without Projection security check.');   
   ELSE
      Error_SYS.Odata_Provider_Access_(lu_name_, 'INCORRECT_INIT_OP: Incorrect usage of Odata provider session initilization.');   
   END CASE;
   
   IF metadata_version_ IS NOT NULL AND metadata_version_ != version_ THEN
      Error_SYS.Projection_Meta_Modified(lu_name_, projection_name_);
   END IF;
   
   RETURN fnd_user_;
END Init_Odp_Session___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Method_Security__ RETURN BOOLEAN
IS
BEGIN
   RETURN(Fnd_Context_SYS.Find_Boolean_Value('LOGIN_SYS.method_security_', TRUE));
END Get_Method_Security__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
PROCEDURE Check_Session_ (
   result_ IN VARCHAR2 )
IS
BEGIN
   NULL;
END Check_Session_;


@UncheckedAccess
PROCEDURE Init_Session_ (
   client_id_             IN VARCHAR2 )
IS
BEGIN
   -- Init Session
   NULL;
   -- Do some insert into Fnd_Session per logon here if needed
END Init_Session_;


-- Init_Native_Session_
--   Make Native Mobile specific session startup activities and maps the
--   Directory User (OS-user) to an existing FndUser and set session globals.
--   This set ODP_SESSION = TRUE and allow to call projection methods.  
--   This service can to be used for mobile transaction initialisation,
--   which implies that the language code is the same as the session
--   already is initiated with.
@UncheckedAccess
FUNCTION Init_Native_Session_ (
   directory_id_          IN VARCHAR2,
   lang_code_rfc3066_     IN VARCHAR2,
   log_level_             IN VARCHAR2 DEFAULT NULL,
   f1_context_            IN VARCHAR2 DEFAULT NULL,
   check_method_security_ IN VARCHAR2 DEFAULT 'TRUE',
   activity_              IN VARCHAR2 DEFAULT NULL,
   method_                IN VARCHAR2 DEFAULT NULL,
   app_context_           IN VARCHAR2 DEFAULT NULL,
   client_id_             IN VARCHAR2 DEFAULT NULL,
   client_statistics_     IN VARCHAR2 DEFAULT 'FALSE',
   client_tracing_        IN VARCHAR2 DEFAULT 'FALSE' ) RETURN VARCHAR2
IS
   fnd_user_         VARCHAR2(30);
BEGIN
   -- Set F1 context
   Fnd_Context_SYS.Set_Values(f1_context_);
   -- Set Application context
   App_Context_SYS.Set_Values(app_context_);
   -- Set Method Security_
   Set_Method_Security___(check_method_security_);
   -- Init Session
   fnd_user_ := Init_Fnd_Session___(f1_context_, directory_id_, lang_code_rfc3066_, log_level_);
   -- Trace in v$session
   Client_Tracing___(nvl(client_id_, fnd_user_), activity_, method_, client_tracing_, client_statistics_);
   -- Security Checkpoint
   --Security_Checkpoint___(f1_context_);
   --
   Fnd_Session_API.Set_Property('ODP_SESSION', 'TRUE');
   RETURN(fnd_user_);
END Init_Native_Session_;



-- Init_Fnd_Session_
--   Make FndExt specific session startup activities and maps the
--   Directory User (OS-user) to an existing FndUser and set session globals.
--   This service can to be used for transaction initialisation,
--   which implies that the language code is the same as the session
--   already is initiated with.
@UncheckedAccess
FUNCTION Init_Fnd_Session_ (
   directory_id_          IN VARCHAR2,
   lang_code_rfc3066_     IN VARCHAR2,
   log_level_             IN VARCHAR2 DEFAULT NULL,
   f1_context_            IN VARCHAR2 DEFAULT NULL,
   check_method_security_ IN VARCHAR2 DEFAULT 'TRUE',
   activity_              IN VARCHAR2 DEFAULT NULL,
   method_                IN VARCHAR2 DEFAULT NULL,
   app_context_           IN VARCHAR2 DEFAULT NULL,
   client_id_             IN VARCHAR2 DEFAULT NULL,
   client_statistics_     IN VARCHAR2 DEFAULT 'FALSE',
   client_tracing_        IN VARCHAR2 DEFAULT 'FALSE' ) RETURN VARCHAR2
IS
   fnd_user_         VARCHAR2(30);
BEGIN
   -- Set F1 context
   Fnd_Context_SYS.Set_Values(f1_context_);
   -- Set Application context
   App_Context_SYS.Set_Values(app_context_);
   -- Set Method Security_
   Set_Method_Security___(check_method_security_);
   -- Init Session
   fnd_user_ := Init_Fnd_Session___(f1_context_, directory_id_, lang_code_rfc3066_, log_level_);
   -- Trace in v$session
   Client_Tracing___(nvl(client_id_, fnd_user_), activity_, method_, client_tracing_, client_statistics_);
   -- Security Checkpoint
   --Security_Checkpoint___(f1_context_);
   --
   Fnd_Session_API.Set_Property('ODP_SESSION', 'FALSE');
   RETURN(fnd_user_);
END Init_Fnd_Session_;


-- Init_Odp_Session_
--   This method is to be called from fnd_odata_provider to initialize a database session
FUNCTION Init_Odp_Session_ (
   lang_code_rfc3066_     IN OUT VARCHAR2,
   debug_enabled_         IN OUT VARCHAR2,
   sql_trace_enabled_     IN OUT VARCHAR2,
   directory_id_          IN VARCHAR2,
   security_check_type_   IN VARCHAR2,
   projection_name_       IN VARCHAR2 DEFAULT NULL,
   metadata_version_      IN VARCHAR2 DEFAULT NULL,
   entity_name_           IN VARCHAR2 DEFAULT NULL,
   action_name_           IN VARCHAR2 DEFAULT NULL,
   client_id_             IN VARCHAR2 DEFAULT NULL,
   client_statistics_     IN VARCHAR2 DEFAULT 'FALSE',
   client_tracing_        IN VARCHAR2 DEFAULT 'FALSE' ) RETURN VARCHAR2
IS
BEGIN
   RETURN Init_Odp_Session___(lang_code_rfc3066_, debug_enabled_, sql_trace_enabled_,
                              directory_id_, security_check_type_, projection_name_, metadata_version_,
                              entity_name_, action_name_, client_id_, client_statistics_, client_tracing_);
END Init_Odp_Session_;

-- Init_ODP_Sys_Session_
--   This method is to be called from fnd_odata_provider to initialize a System database session
@UncheckedAccess
PROCEDURE Init_Odp_Sys_Session_ (
   lang_code_rfc3066_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   IF (User != ifssys_) THEN
      Error_SYS.Appl_General(service_, 'NOT_IFSSYS_USER: Only IFS Applications System user is allowed to run initiate sessions.');
   END IF;
   Reset_Odp_Session___;
   Set_Method_Security___('FALSE');
   Dbms_Session.Set_Identifier('IFSODP-Internal');
   IF lang_code_rfc3066_ IS NOT NULL THEN
      Set_Language___(lang_code_rfc3066_);
   END IF;
   Fnd_Session_API.Set_Property('ODP_SESSION', 'TRUE');
END Init_Odp_Sys_Session_;

-- Reset_Session_
--   Reset the Session, to be used by the MWS Session Pool
@UncheckedAccess
PROCEDURE Reset_Session_
IS
BEGIN
   IF (User != ifssys_) THEN
      Error_SYS.Appl_General(service_, 'NOT_IFSSYS_USER: Only IFS Applications System user is allowed to run initiate sessions.');
   END IF;
   Reset_Odp_Session___;
END Reset_Session_;

PROCEDURE End_Odp_Session_
IS
BEGIN  
   fnd_session_util_api.Reset_Security_Checkpoint_Ctx_;
   Database_SYS.Set_Sql_Trace__('FALSE');
   Set_Method_Security___('TRUE');
   Dbms_Session.Modify_Package_State(Dbms_Session.Reinitialize);
END End_Odp_Session_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
