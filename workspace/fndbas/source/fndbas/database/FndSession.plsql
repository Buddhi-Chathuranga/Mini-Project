-----------------------------------------------------------------------------
--
--  Logical unit: FndSession
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970417  JAPA  Created.
--  970430  ERFO  Implementation through package globals.
--  970514  ERFO  Added methods Get_Session_Info_, Get_Properties_,
--                Store_Properties_ and Clear_Properties_.
--  970521  ERFO  Removed use of method Get_Database_Properties___.
--  970522  ERFO  Added three public methods for specific tasks.
--  970602  ERFO  Made Set/Get_Property public.
--  970604  ERFO  Added method Get_Language.
--  970605  ERFO  Changes in Set_Property to support language changes.
--  970701  ERFO  Added initialization part to ensure correct security
--                mechanisms from external data browers (Idea #1480).
--  970707  ERFO  Changed logic concerning user identity and preferred
--                language setting between General_SYS and Fnd_Session_API.
--  970818  MANY  Added method Cleanup_().
--  971124  ERFO  Fixed problem with external Oracle users without any
--                associated Foundation1 user (Bug #1792).
--  971219  ERFO  Cursor correction in method Get_Properties_ (Bug #1930).
--  971219  ERFO  Improved error message in Store_Properties_ (ToDo #1931).
--  980306  ERFO  Changes concerning new language configuration (ToDo #2212).
--  981103  ERFO  Performance improvements in Get-methods (Bug #2852).
--  990222  ERFO  Yoshimura: Changes in Store_/Clear_Properties_ (ToDo #3160).
--  990320  ERFO  Changed performance problems on view USER_USERS (Bug #3237).
--  990913  ERFO  Added method Set_Client_Info to support CLIENT_INFO
--                concept for improved performance (ToDo #3532).
--  990920  ERFO  Changed internal structure of CLIENT_INFO (ToDo #3532).
--  991011  BVLI  Changed FndSession from utility class to ordinary class.
--                Implementation methods NOT generated.
--                Added new view FND_SESSION_RUNTIME.  (ToDo #3609).
--  991011  BVLI  Added public method 'Kill_Session' (ToDo #3609).
--  001029  ROOD  Moved view FND_SESSION to api to make it public (ToDo#3953).
--  001229  ERFO  Added new method (ToDo #3937).
--  020626  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030219  ROOD  Changed hardcoded subcomponent name in message (ToDo#4149).
--  040209  NIPE  Security - Roles per User Limit (Bug #42362).
--  041119  HAAR  Change language handling (F1PR413E).
--                Added Set_Language.
--  041221  HAAR  Removed Set_Nls_Parameters___ (F1PR413E).
--  050404  JORA  Added assertion for dynamic SQL.  (F1PR481)
--  050601  HAAR  Added support for nls_date_format and nls_time_format (F1PR413).
--  060105  UTGULK Annotated Sql injection.
--  060515  HAAR  Added NLS string encoding (Bug#57108).
--  060619  HAAR  Added Get_Calendar and Set_Calendar (Bug#58601).
--  060831  HAAR  Changed implemetation of Set_Calendar (Bug#60186).
--  060912  HAAR  Added support for Application context variables in PL/SQL (Bug#60449).
--  061012  NiWi  Used sys.fnd_user$ instead of sys.user$(Bug#61106).
--  070104  NiWi  Revoked 61106. used SYS_CONTEXT instead.
--  070523  SuMa  Changed the V$Session to GV$Session(Bug#65347).
--  070626  SuMa  Changed the Fnd_Session_Runtime to include last query and status to sydate when active(Bug#63719).
--  071023  HAAR  Changed view Fnd_Session_Runtime to view FndUser properties only (Bug#68681).
--  080312  HAAR  Implement Fnd_Session properties as a context (Bug#68143).
--  080513  HAAR  System Information about Sessions where missing (Bug#73929).
--  080812  HAAR  More robust elaboration of FND_Sessions and support for Appowner owned contexts (Bug#76153).
--  090309  HASP  Modified method Set_Language to check is current session in installation mode (Bug#81092).
--  090401  HAAR  Added attribute OS_USER_NAME to support Concurrent License for EE (Bug#81763).
--  090626  HAAR  Changed how to get FndUse rfrom Fnd_Session_Runtime view (Bug#84294).
--  090702  DUWI  Changed view V$SESSION to GV$SESSION in Cleanup_ to support RAC (Bug84332).
--  090720  USRA  Changed Get_Properties_ to return a proper message (Bug#83435).
--  110624  DUWI  Modified Clear_Properties_ and Store_Properties_ to log session detials(Bug96748).
--  030506  DUWI  Introduced new larger data type for application context (Bug109738)
-----------------------------------------------------------------------------
--
-- CLIENT_INFO internal structure
--
--   Property                          Mapping         Default
--   ---------------------------------------------------------
--   FND_USER || ' ' || OS_USER        1-6
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

context_       CONSTANT VARCHAR2(30) := 'FNDSESSION_CTX';
app_owner_     CONSTANT VARCHAR2(30) := Sys_Context('USERENV', 'CURRENT_SCHEMA');

--  tracks the container to create and init the connection
--@ApproveGlobalVariable(2021-08-09,lasrlk)
init_context_  VARCHAR2(30) := NULL;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Osuser_On_Windows___ (
   osuser_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   osname_                    VARCHAR2(200);
   domain_separator1_ CONSTANT VARCHAR2(1) := '\';
   domain_separator2_ CONSTANT VARCHAR2(1) := '@';
BEGIN
   IF    Instr(osuser_, domain_separator1_) > 0 THEN
      osname_ := Substr(osuser_, Instr(osuser_, domain_separator1_) + 1);
   ELSIF Instr(osuser_, domain_separator2_) > 0 THEN
      osname_ := Substr(osuser_, 1, Instr(osuser_, domain_separator2_) - 1);
   ELSE
      osname_ := osuser_;
   END IF;
   RETURN(osname_);
END Get_Osuser_On_Windows___;


PROCEDURE Set_Program___ (
   program_  IN VARCHAR2 )
IS
    program_maxlength_ VARCHAR2(255);
BEGIN
   program_maxlength_ := substr(program_, 1, 255);
   Fnd_Session_Util_API.Set_Program_(program_maxlength_);
END Set_Program___;


PROCEDURE Set_Machine___ (
   machine_  IN VARCHAR2 )
IS
   machine_maxlength_ VARCHAR2(255);
BEGIN
   machine_maxlength_ := substr(machine_, 1, 255);
   Fnd_Session_Util_API.Set_Machine_(machine_maxlength_);
END Set_Machine___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Os_User_Name__ RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'OS_USER_NAME'));
END Get_Os_User_Name__;


@UncheckedAccess
FUNCTION Get_Program__ RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'PROGRAM'));
END Get_Program__;


@UncheckedAccess
FUNCTION Get_Machine__ RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'MACHINE'));
END Get_Machine__;


PROCEDURE Set_Calendar__ (
   calendar_  IN VARCHAR2 DEFAULT 'GREGORIAN')
IS
   db_calendar_      CONSTANT VARCHAR2(30) := Nvl(Database_SYS.Get_Initialization_Parameter__('NLS_CALENDAR'), 'GREGORIAN');
BEGIN
   -- Restriction in IFSAPP7 only one calendar per system allowed
   -- Set session calendar to same value as instance parameter NLS_CALENDAR
   Nls_Calendar_API.Exist_Db(db_calendar_);
   @ApproveDynamicStatement(2006-06-19,haarse)
   EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_CALENDAR =''' || Assert_SYS.Encode_Single_Quote_String(db_calendar_)||'''';
   Fnd_Session_Util_API.Set_Calendar_(db_calendar_);
END Set_Calendar__;


PROCEDURE Set_Os_User_Name__ (
   os_user_name_  IN VARCHAR2 )
IS
BEGIN
   Fnd_Session_Util_API.Set_Os_User_Name_(Get_Osuser_On_Windows___(os_user_name_));
END Set_Os_User_Name__;


PROCEDURE Set_Directory_Id__ (
   directory_id_  IN VARCHAR2 )
IS
BEGIN
   Fnd_Session_Util_API.Set_Directory_Id_(directory_id_);
END Set_Directory_Id__;


PROCEDURE Set_Rfc3066__ (
   rfc3066_  IN VARCHAR2 )
IS
BEGIN
   Fnd_Session_Util_API.Set_Rfc3066_(rfc3066_);
END Set_Rfc3066__;


PROCEDURE Set_Client_Id__ (
   client_id_  IN VARCHAR2 )
IS
BEGIN
   Fnd_Session_Util_API.Set_Client_Id_(client_id_);
END Set_Client_Id__;


PROCEDURE Set_Checkpoint_Id__ (
   checkpoint_id_ IN VARCHAR2 )
IS
BEGIN
   Fnd_Session_Util_API.Set_Checkpoint_Id_(checkpoint_id_);
END Set_Checkpoint_Id__;


PROCEDURE Set_Web_User__ (
   web_user_ IN VARCHAR2 )
IS
BEGIN
   Fnd_Session_Util_API.Set_Web_User_(web_user_);
END Set_Web_User__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Get_Session_Info_ (
   info_msg_ OUT VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'DEPRECATED: Deprecated method.');
END Get_Session_Info_;


PROCEDURE Store_Properties_
IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'DEPRECATED: Deprecated method.');
END Store_Properties_;


PROCEDURE Clear_Properties_
IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'DEPRECATED: Deprecated method.');
END Clear_Properties_;


@UncheckedAccess
FUNCTION Get_Properties_ (
   identity_ IN VARCHAR2,
   name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'DEPRECATED: Deprecated method.');
   RETURN(NULL);
END Get_Properties_;


PROCEDURE Set_Client_Info_ (
   name_  IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Fnd_Session_Util_API.Set_Client_Info_(name_, value_);
END Set_Client_Info_;


PROCEDURE Set_Key_ (
   identity_ IN VARCHAR2 )
IS
   temp_ VARCHAR2(2000);
BEGIN
   temp_ := concat(lpad(trunc(ascii(identity_)+power(log(3,exp(0)),sqrt(3))),''),'');
   Fnd_User_API.Set_User_Key_(identity_);
END Set_Key_;


-- used to determine if the connection is from the ODP, Mobile or something else.
@UncheckedAccess
PROCEDURE Set_Init_Context_(context_ IN VARCHAR2) IS 
BEGIN
      init_context_ := context_;
END Set_Init_Context_;

@UncheckedAccess
FUNCTION Get_Init_Context_(context_ IN VARCHAR2) RETURN VARCHAR2 IS 
BEGIN
      RETURN init_context_;
END Get_Init_Context_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Fnd_User (
   fnd_user_ IN VARCHAR2 )
IS
   --
   PROCEDURE Package_Check___ 
   IS
      package_    VARCHAR2(30);
   BEGIN
      package_ := Nvl(Substr(Utl_Call_Stack.Concatenate_Subprogram(Utl_Call_Stack.Subprogram(4)), 1, Instr(Utl_Call_Stack.Concatenate_Subprogram(Utl_Call_Stack.Subprogram(4)), '.')-1), 'DuMmY');
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Package: '||package_);
      IF (package_  NOT IN ('GENERAL_SYS', 'LOGIN_SYS', 'FND_SESSION_UTIL_API')) OR
            (Utl_Call_Stack.Owner(4) != sys_context('userenv', 'current_schema')) THEN
         Error_SYS.Appl_General(lu_name_, 'ONLY_F1: This method is only allowed to be used from special packages in the FNDBAS component.');
      END IF;
   END Package_Check___;
   --
BEGIN
   -- Extra security to avoid impersonating
   Package_Check___;
   Fnd_Session_Util_API.Set_Fnd_User_(fnd_user_);
END Set_Fnd_User;

@UncheckedAccess
PROCEDURE Set_Fnd_User_Parallel (
   fnd_user_ IN VARCHAR2 )
IS
   --
   PROCEDURE Package_Check___ 
   IS
      package_    VARCHAR2(30);
   BEGIN
      package_ := Nvl(Substr(Utl_Call_Stack.Concatenate_Subprogram(Utl_Call_Stack.Subprogram(7)), 1,
                         Instr(Utl_Call_Stack.Concatenate_Subprogram(Utl_Call_Stack.Subprogram(7)), '.')-1), 'DuMmY');        
         Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Package: '||package_);
         IF (package_ NOT IN ('DBMS_PARALLEL_EXECUTE')) THEN
            Error_SYS.Appl_General(lu_name_, 'ONLY_PARALLEL: This method is only allowed to be used from parallel execution.');
         END IF;
   END Package_Check___;
   --
BEGIN
   -- Extra security to avoid impersonating
   Package_Check___;
   Fnd_Session_Util_API.Set_Fnd_User_Parallel_(fnd_user_);
END Set_Fnd_User_Parallel;

PROCEDURE Reset_Fnd_User
IS
BEGIN
   Fnd_Session_Util_API.Reset_Fnd_User_;
END Reset_Fnd_User;


PROCEDURE Impersonate_Fnd_User (
   fnd_user_ IN VARCHAR2 )
IS
BEGIN
   Fnd_Session_Util_API.Impersonate_Fnd_User_(fnd_user_);
END Impersonate_Fnd_User;


PROCEDURE Set_Language (
   language_ IN VARCHAR2 )
IS
   invalid_nls EXCEPTION;
   PRAGMA      EXCEPTION_INIT(invalid_nls, -12705);
   stmt_       VARCHAR2(1000);
   lang_rec_    Language_Code_API.Public_rec;
   lang_code_  language_code.lang_code%TYPE;
   lang_version_     language_code.objversion%TYPE;
   lang_version_act_ language_code.objversion%TYPE;
BEGIN
   stmt_ := 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''. ''';
   -- Do not set language if already set, if NULL then nothing
   IF language_ IS NULL THEN
      @ApproveDynamicStatement(2006-02-15,pemase)
      EXECUTE IMMEDIATE stmt_;
   ELSE
      lang_code_        := Sys_Context(context_, 'LANGUAGE');
      lang_version_act_ := Language_Code_API.Get_Objversion_By_Key(language_);
      lang_version_     := Sys_Context(context_, upper(lang_code_)||'_LANG_VERSION');
      
      IF lang_code_ IS NULL OR lang_code_ != language_ OR lang_version_ IS NULL OR lang_version_ != lang_version_act_ THEN
         Language_Code_API.Exist(language_);
         lang_rec_  := Language_Code_API.Get(language_);
         Fnd_Session_API.Set_Calendar__(nvl(lang_rec_.nls_calendar, 'GREGORIAN'));
         IF NOT Dictionary_SYS.Get_Installation_Mode THEN
            stmt_     := stmt_       ||' NLS_LANGUAGE  = '''||Assert_SYS.Encode_Single_Quote_String(lang_rec_.nls_language)||''''||
                                       ' NLS_TERRITORY = '''||Assert_SYS.Encode_Single_Quote_String(lang_rec_.nls_territory)||'''';
            IF lang_rec_.nls_date_format IS NOT NULL THEN
               stmt_  := stmt_       ||' NLS_DATE_FORMAT = '''||Assert_SYS.Encode_Single_Quote_String(lang_rec_.nls_date_format)||'''';
            END IF;
            IF lang_rec_.nls_time_format IS NOT NULL THEN
               stmt_  := stmt_       ||' NLS_TIME_FORMAT = '''||Assert_SYS.Encode_Single_Quote_String(lang_rec_.nls_time_format)||'''';
            END IF;
         END IF;
         @ApproveDynamicStatement(2006-05-15,haarse)
         EXECUTE IMMEDIATE stmt_;
         Fnd_Session_Util_API.Set_Language_(language_);
         Fnd_Session_Util_API.Set_Lang_Code_Version_(lang_code_, lang_version_act_);
      END IF;
   END IF;
EXCEPTION
   WHEN invalid_nls THEN
      Fnd_Session_Util_API.Set_Language_(language_);
      Error_SYS.Appl_General(lu_name_,
                             'INVALID_NLS: Language ":P1" has incorrect values in NLS parameters. Language [:P2], Territory [:P3] and Calendar [:P4].',
                             language_, lang_rec_.nls_language, lang_rec_.nls_territory, lang_rec_.nls_calendar);
END Set_Language;


PROCEDURE Set_Property (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   CASE name_
      WHEN 'APP_OWNER' THEN
         Error_SYS.Appl_General( lu_name_, 'SET_APPOWNER: You are not allowed to change the APP_OWNER property.' );
      WHEN 'FND_USER' THEN
         Error_SYS.Appl_General( lu_name_, 'SET_FNDUSER: You are not allowed to change the FND_USER property with this method. Use Impersonate_Fnd_User instead.' );
      WHEN 'CALENDAR' THEN
         Error_SYS.Appl_General( lu_name_, 'SET_CALENDAR: You are not allowed to change the CALENDAR property with this method. Use Set_Calendar instead.' );
      WHEN 'LANGUAGE' THEN
         Error_SYS.Appl_General( lu_name_, 'SET_LANGUAGE: You are not allowed to change the LANGUAGE property with this method. Use Set_Language instead.' );
      WHEN 'ORACLE_USER' THEN
         Error_SYS.Appl_General( lu_name_, 'ORACLE_USER: You are not allowed to change the ORACLE_USER property.' );
      WHEN 'OS_USER_NAME' THEN
         Error_SYS.Appl_General( lu_name_, 'SET_OS_USER_NAME: You are not allowed to change the OS_USER_NAME property with this method. Use Set_Os_User_Name__ instead.' );
      WHEN 'PROPERTIES' THEN
         --Fnd_Session_Util_API.Set_Properties_(value_);
         NULL;
      ELSE
         Fnd_Session_Util_API.Set_Property_(name_, value_);
   END CASE;
END Set_Property;

@UncheckedAccess
FUNCTION Is_Odp_Session RETURN BOOLEAN
IS
BEGIN
   RETURN NVL(Get_Property('ODP_SESSION'), 'FALSE') = 'TRUE';
END Is_Odp_Session;

@UncheckedAccess
FUNCTION Get_Property (
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   CASE name_
      WHEN 'FND_USER' THEN
         RETURN(Get_Fnd_User);
      WHEN 'APP_OWNER' THEN
         RETURN(Get_App_Owner);
      WHEN 'LANGUAGE' THEN
         RETURN(Get_Language);
      WHEN 'ORACLE_USER' THEN
         RETURN(Get_Oracle_User);
      WHEN 'OS_USER_NAME' THEN
         RETURN(Get_Os_User_Name__);
      WHEN 'PROPERTIES' THEN
         --         RETURN(Sys_Context(context_, 'PROPERTIES', 4000));
         RETURN(NULL);
      ELSE
         RETURN(Sys_Context(context_, name_, 4000));
   END CASE;
END Get_Property;


@UncheckedAccess
FUNCTION Get_App_Owner RETURN VARCHAR2
IS
BEGIN
   RETURN(app_owner_);
END Get_App_Owner;


@UncheckedAccess
FUNCTION Get_Initiator RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'INITIATOR'));
END Get_Initiator;


@UncheckedAccess
FUNCTION Get_Fnd_User RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'FND_USER'));
END Get_Fnd_User;


@UncheckedAccess
FUNCTION Get_Oracle_User RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'ORACLE_USER'));
END Get_Oracle_User;


@UncheckedAccess
FUNCTION Get_Calendar RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'CALENDAR'));
END Get_Calendar;


@UncheckedAccess
FUNCTION Get_Language RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'LANGUAGE'));
END Get_Language;


@UncheckedAccess
FUNCTION Get_Directory_Id RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'DIRECTORY_ID'));
END Get_Directory_Id;


@UncheckedAccess
FUNCTION Get_Rfc3066 RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'RFC3066'));
END Get_Rfc3066;


@UncheckedAccess
FUNCTION Get_Client_Id RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'CLIENT_ID'));
END Get_Client_Id;


@UncheckedAccess
FUNCTION Get_Checkpoint_Id RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'CHECKPOINT_ID'));
END Get_Checkpoint_Id;


@UncheckedAccess
FUNCTION Get_Web_User RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'WEB_USER'));
END Get_Web_User;

@UncheckedAccess
FUNCTION Get_Checkpoint_User RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'CHECKPOINT_USER'));
END Get_Checkpoint_User;

@UncheckedAccess
FUNCTION Get_Checkpoint_Comment RETURN VARCHAR2
IS
BEGIN
   RETURN(Sys_Context(context_, 'CHECKPOINT_COMMENT'));
END Get_Checkpoint_Comment;

@UncheckedAccess
FUNCTION Get_Sql_Statement (
   address_    IN RAW,
   hash_value_ IN NUMBER,
   sql_id_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   stmt_    VARCHAR2(32000);
   CURSOR get_sql IS
   SELECT sql_text
     FROM v$sqltext_with_newlines
    WHERE address = address_
      AND hash_value = hash_value_
      AND sql_id = sql_id_
   ORDER BY piece;
BEGIN
   FOR rec IN get_sql LOOP
      stmt_ := stmt_ || rec.sql_text;
      IF lengthb(stmt_) > 4000 THEN --SQL can only handle 4000 bytes
         EXIT;
      END IF;
   END LOOP;
   RETURN(substrb(stmt_, 1, 4000)); -- Only return 4000 bytes
END Get_Sql_Statement;


--PROCEDURE Kill_Session (
--   sid_         IN NUMBER,
--   serial_no_   IN NUMBER,
--   instance_id_ IN NUMBER DEFAULT NULL)
--IS
--   inst_id_ NUMBER;
--   stmt_    VARCHAR2(200);
--   audsid_  NUMBER;
--BEGIN
--   
--   IF instance_id_ IS NULL THEN
--      -- If instance id is not specified,
--      -- default to the instace of the current session
--      inst_id_ := sys_context('USERENV','INSTANCE');
--   ELSE
--      inst_id_ := instance_id_;
--   END IF;
--   
--   SELECT audsid, inst_id
--   INTO audsid_, inst_id_
--   FROM gv$session
--   WHERE sid = sid_
--   AND serial# = serial_no_
--   AND inst_id = inst_id_;
--   
--   stmt_  := 'ALTER SYSTEM KILL SESSION '''|| sid_ || ',' || serial_no_ ||',@'||inst_id_||'''';
--   
--   @ApproveDynamicStatement(2006-01-05,utgulk)
--   EXECUTE IMMEDIATE stmt_;
--   Trace_SYS.Message('Session ['||sid_ || ',' || serial_no_ ||',@'||inst_id_||'] Killed.');
--   --
--EXCEPTION
--   WHEN no_data_found THEN
--      Error_SYS.Appl_General( lu_name_, 'KILLNOSESSION: Session [:P1] not found', sid_ || ',' || serial_no_ || ',@'|| inst_id_);
--   WHEN OTHERS THEN
--      IF sqlcode = -27  THEN
--        Error_SYS.Appl_General( lu_name_, 'CURRKILL: Cannot kill current session' );
--      ELSE
--        Error_SYS.Appl_General( lu_name_, 'NOKILL: Could not kill session (SID: :P1). Reason: :P2', sid_ , substr(SQLERRM,1,100));
--      END IF;
--END Kill_Session;


@UncheckedAccess
FUNCTION Get_Category (
   username_     IN VARCHAR2,
   client_id_    IN VARCHAR2,
   program_      IN VARCHAR2,
   type_         IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   -- This if-elsif structure is dependent of the order it occurs in
   IF ((upper(program_) LIKE 'ORACLE%(J%') AND type_ = 'USER') THEN
      RETURN('Database background job');
   ELSIF (program_ = 'IFS Middleware Server' AND client_id_ = 'IFSODP-Internal') THEN
      RETURN('IFS Odata Provider Internal Session');
   ELSIF (program_ = 'IFS Middleware Server' AND client_id_ LIKE 'IFSODP-%') THEN
      RETURN('IFS Odata Provider User Session');
   ELSIF (program_ = 'IFS Middleware Server') THEN
      RETURN('Activity/Service');
   ELSIF (program_ = 'IFS Middleware Server AQJMS') THEN
      RETURN('JMS-AQ integration');
   ELSIF (client_id_ LIKE '%-'||username_||'-%') THEN
      RETURN('PL/SQL Access');
   ELSE
      RETURN('Other session');
   END IF;
END Get_Category;


@UncheckedAccess
FUNCTION Get_Transaction_Id RETURN VARCHAR2
IS
BEGIN
   RETURN(Dbms_Transaction.Local_Transaction_Id(FALSE));
END Get_Transaction_Id;

BEGIN
   Fnd_Session_Util_API.Init;
END;
