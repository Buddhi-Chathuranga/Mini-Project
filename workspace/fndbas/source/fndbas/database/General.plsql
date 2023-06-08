-----------------------------------------------------------------------------
--
--  Logical unit: General
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950926  ERFO  Created.
--  950927  ERFO  Added method Init_Session for server initiation from client.
--  950928  ERFO  Removed handle of NLS_NUMERIC_CHARACTER from Init_Session.
--  951003  ERFO  Added parameter pkg_access_list_ to method Init_Session.
--  951004  STLA  Renamed calls to Security_SYS in method Init_Session.
--  960319  ERFO  Changes in Init_Session to support all client initiation
--                steps and added method Close_Session (Idea #447).
--  960323  ERFO  Added method Set_Method_Trace for server traces (Idea #495).
--  960401  ERFO  Added dummy parameter to method Close_Session.
--  960402  ERFO  Added methods to retrieve database version info.
--  960416  ERFO  Rebuilded trace functions to be used through DBMS_OUTPUT.
--  960429  ERFO  Removed parameter trace_flag in Init_Session.
--  960515  ERFO  Fixed BIGCHAR2 problem (Bug #607) and added Init_All_Packages
--                to load important objects into shared pool (Idea #630).
--  960731  MADR  Added methods to store/clear/retrieve session info (Idea #759).
--  960820  MADR  Renamed SESSION_SYS_TAB to GENERAL_SYS_SESSION_TAB
--  960911  ERFO  Added timestamp information to trace messages (Idea #586).
--  960911  ERFO  Added call to Reference_SYS.Init in method Init_Session to
--                optimize the performance of the first client LOV (Idea #684).
--  960913  ERFO  Added method Put_Line for simple trace output (Idea #793).
--  961002  MADR  Send '' instead of NULL to Message_SYS.Find_Attribute to call
--                right version of this function
--  961030  ERFO  Added overloaded method Init_Session_ for 1.2.2-usage
--                of client category security settings (Idea #850).
--  961031  ERFO  Added method Get_Session_Properties to retrieve session
--                specific information to the client (Idea #847).
--  961210  ERFO  Added overloaded method Init_Session__ to solve size
--                problems in security lists to IFS/Client (Bug #894).
--  970428  ERFO  Removed old init session interfaces and added new one
--                Init_Centura_Session_ for Centura client (Idea #1105).
--  970429  ERFO  Added method Init_Fnd_Session___ and Fnd_Web_Session
--                for a general session initiation procedure independent
--                of the client technology.
--  970514  ERFO  Implemented fast login mode, moved functionality of
--                Open_Session, integration towards Fnd_Session_API,
--                removed method Get_Database_Properties.
--  970521  ERFO  Reinstalled method Get_Database_Properties and restored
--                old method Init_Session__.
--  970522  ERFO  Changed internals concerning APP_OWNER.
--  970527  ERFO  Changed method Get_Session_Properties, implemented real
--                database version through sys.v_$version (Idea #1310).
--  970603  ERFO  Added auto-generation of FndUser even for old interfaces.
--  970605  ERFO  Replaced call to Document_SYS with use of package
--                Object_Connection_SYS (Idea #1112).
--  970605  ERFO  Added call to recursivly define current language.
--  970605  ERFO  Changes to handle language correctly from a Web session.
--  970630  ERFO  Corrections for method Init_Web_Session.
--  970630  ERFO  Removed methods for clear and store 1.2.2 session info.
--  970630  ERFO  Stripped trace messages in method Put_Line to avoid
--                the DBMS_OUTPUT limit of 255 bytes.
--  970630  ERFO  Corrections concerning setup parameter FAST_LOGIN_ACTIVE.
--  970701  ERFO  Changed methods Message_SYS.Add_Attribute to Set_Attribute.
--  970701  ERFO  Added initialization of package Fnd_Session_API to ensure
--                correct security mechanisms from external data browers.
--  970702  ERFO  Corrections concerning LANGUAGE and NLS_DATE_FORMAT.
--  970704  ERFO  Added extra parameters to Put_Line (ToDo #1491).
--  970704  ERFO  Removed obsolete interface Get_User_Attribute.
--  970707  ERFO  Changed logic concerning preferred property settings between
--                Windows clients, Web clients and external data browsers.
--  970721  ERFO  Added support of parameter NLS_DATE_LANGUAGE for different
--                language formats on a web browser interface (ToDo #1509).
--  970724  ERFO  Made method Init_All_Packages_ protected.
--  970729  ERFO  Added protected method Close_Centura_Session_.
--  970729  ERFO  Change call to Security_SYS from Init_Method.
--  970729  ERFO  Changes to get use of Fnd_Session_API.Get_Language.
--  970813  MADR  Moved logic from Create_Fnd_User___ to Fnd_User_API
--  970817  MANY  Added new methods Fnd_Light_Cleanup_, Fnd_Heavy_Cleanup_
--                and Cleanup_Install_ (ToDo #1510).
--  970819  DAJO  Removed usage of FndSetting CHECK_F1_VERSIONS.
--  970825  ERFO  Added out parameters to Init_Centura_Session_ for user
--                profile information and Foundation1 settings (ToDo #1601).
--  970826  MANY  Improved error messages in cleanup methods.
--  970829  MANY  Fixed problem with Cleanup_Install_(), removing cleanup
--                jobs for other users than current application owner.
--  971009  MANY  Implemented Cleanup for PrintJob, added to
--                Fnd_Heavy_Cleanup__(), ToDo #1694.
--  971017  MANY  Added improved error messaging for Fnd_Heavy_Cleanup__().
--  971027  ERFO  Changes in method Get_Database_Properties to support Oracle8.
--  971215  ERFO  Return the server evaluated value of FAST_LOGIN in the output
--                structure of Init_Centura_Session__ (Bug #1837).
--  980127  ERFO  Added connectivity tasks in method Fnd_Light_Cleanup_.
--  980306  ERFO  Changes concerning new language configuration (ToDo #2212).
--  980311  ERFO  Fixed problem in method Init_Session__ when running
--                16-bit SQLWindows clients (Bug #2227).
--  980311  ERFO  Changes in the initiation methods to ensure that a non-
--                existing Foundation1 user will be generated (Bug #2228).
--  980330  ERFO  Make Connectivity_SYS dependency to be dynamic (ToDo #2298).
--  980804  ERFO  Integrated MTS_SYS into Foundation1 2.2 (ToDo #2554).
--  980818  ERFO  Added call to Security_SYS.Init in Init_Mts_Session_
--                to refresh the current Fnd User setting (Bug #2631).
--  981021  ERFO  New way of implementing method level security (ToDo #2819).
--  981103  ERFO  Fixed NLS-problems in Init_Mts_Session_ (Bug #2865).
--  981106  ERFO  New configuration setting for method security (ToDo #2872).
--  990322  MANY  Project Invader add-ons in Fnd_Light_Cleanup_ (ToDo #3177).
--  990615  ERFO  Added method Init_Centura_Session__ (ToDo #3431).
--  990623  ToFu  Map Security_SYS.Enumerate_Security_Info_ (ToDo #3431).
--  990623  ERFO  Removed method 16-bit interfaces Init_Session__, Open_Session
--                and Get_Session_Properties (ToDo #3449).
--  990701  RaKu  Added History_Log_Util_API.Cleanup__ into Heavy Cleanup-job.
--  990707  ERFO  Corrected name/sid in Get_Database_Properties (Bug #3393).
--  990813  ERFO  Solved problem with date functions for web-clients (But #3512).
--  990921  ERFO  Handled internal CLIENT_INFO in Fnd_Session_API (ToDo #3580).
--  000125  ERFO  Made three implementation methods private and removed
--                the obsolete interface Close_Session (ToDo #3818).
--  000321  ERFO  Added method Enumerate_Pres_Objects_ for Sec 2001 (ToDo #3846).
--  000531  ROOD  Modifications in Init_Centura_Session_ (ToDo #3846).
--  000816  ROOD  Added a buffer limit in Get_Mts_Trace_ (Bug #16840).
--  000912  ROOD  Increased the variable size in Init_Centura_Session__ (Bug #17430).
--  000920  ROOD  Added License Management handling (ToDo#3937).
--  001016  ROOD  Changed version to 3.0.1 Beta1.
--  001030  ROOD  Reintroduced the interface Close_Session (Bug#18119).
--  001112  ROOD  Replaced PKG with GENERAL_SYS to prevent compilation errors 
--                in the wrapped version.
--  001211  ROOD  Replaced the intitial encryption with md4-encryption (ToDo#3937).
--  001212  ROOD  Changed version to 3.0.1.
--  001214  ROOD  Appended the license limit at the end of the license key (ToDo#3937).
--  010103  ROOD  Modified the handling of demo limits. Renamed 'site' to 'project' (ToDo#3937).
--  010104  ROOD  Removed auto generation of fnd_user in Init_Centura_Session_.
--                Modifications in Validate_License___ (ToDo#3937).
--  010105  ROOD  More modifications in Validate_License___ (ToDo#3937).
--  010110  ROOD  Changes in Calculate_Project_Key___ (ToDo#3937).
--  010114  ROOD  Added expiration_date_ in Calculate_License_Key___ (ToDo#3937).
--  010425  ROOD  Updated version for 3.0.2Beta1.
--  010528  ROOD  Rewrote the encryption algorithm to use hexadecimal representation
--                instead of a character string to avoid double byte problems (Bug#21982).
--  010605  ROOD  Removed the "slack" of 5 named users. This is now handled by 
--                the Global Customer Database with "adminstrative users" (ToDo#4010).
--  010820  ROOD  Updated version for 3.0.2Beta2.
--  010907  HAAR  Added cleanup for Batch_Schedules in Fnd_Heavy_Cleanup_ (ToDo#4018).
--  011022  ROOD  Added cleanup for Personal Messages in Fnd_Heavy_Cleanup_ (ToDo#4016).
--  010820  ROOD  Updated version for 3.0.2.
--  020115  ROOD  Updated version for 3.0.3Beta1.
--  020213  ROOD  Renamed 'project' to 'installation' (ToDo#4071).
--  020218  ROOD  Updated version for 3.0.3Beta2.
--  020224  ROOD  Always block non active fnd users regardless of license type (ToDo#4083).
--  020322  ROOD  Modified interface Enumerate_Pres_Objects_. 
--                Kept old interface for compatibility for now (Bug#28798).
--  020409  ROOD  Updated version for 3.0.3.
--  020624  ROOD  Added fnd_user to info_msg_ in Init_Centura_Session_ (Bug#31084).
--  030130  ROOD  Removed old interface Init_Web_Session. Modifications in license validation
--                to always validate all sessions that have not been validated yet (ToDo#4200).
--                Updated version for 3.1.0. Shortened some unnecessary long variables.
--  030205  ROOD  Changes in Validate_License___ and Check_License_ after code review (ToDo#4200).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030304  ROOD  Removed Event Server cleanup from Fnd_Light_Cleanup (ToDo#4149).
--  030304  ROOD  Removed call to Command_SYS.Activate_Receiver_Queue (ToDo#4149).
--  030314  ROOD  Moved implementation of some interfaces to other system services (ToDo#4143).
--  030626  ROOD  Restructured implementation of Init_Centura_Session-methods.
--                Corrected handling of fast_login (ToDo#4099).
--  031022  ROOD  Modified error messages.
--  040112  ROOD  Updated version for 3.2.0.
--  041119  HAAR  Changed language handling (F1PR413E).
--                Removed Alter_Nls_Session__ and moved Init_Fnd_Session__ to Implementation.
--  050126  RAKU  Init_Centura_Session__: Removed call 'Client_Role_API.Enum_Category_Restrictions_'.
--                Added overload on Init_Centura_Session__. Removed obsolete Init_Centura_Session_ (F1PR484).
--  050309  HAAR  Add possibility to deny direct call from client to method in Init_Method (F1PR480).
--  050405  HAAR  Implement Activity Based Security (F1PR489).
--  050510  HAAR  Added trace support through Dbms_Application_Info (F1PR480).
--  050701  HAAR  Added trace support through Dbms_Application_Info (F1PR480).
--  050705  HAAR  Check for System privilege CONNECT in Init_Centura_Session__ (F1PR843).
--  051108  NiWi  Merged PEMA's modifications for New License Model: Concurrent Users
--                Added: Installation_Is_Lm_Cu___
--                Added: Concurrent_Users_LoggedIn___
--                Added: Concurrent_Users_CountRAC___
--                Added: Concurrent_Users_Count___
--                Added: Concurrent_Users_Warn___
--                Added: Concurrent_Users_Debug___
--                Modified: Calculate_License_Key___
--                Modified: Validate_License___
--                Modified: FND_LICENSE_API.Remove_Invalid_Characters___
--                New dependency: Event_SYS
--                New dependency: SYS. / PUBLIC. dbms_session
--                New soft dependency: SYS.gv_$session 
--                    GRANT SELECT ON SYS.gv_$session TO AppOwner
--                    (not required, but recommended for accurate RAC count)
--                New Event: CU_WARNING
--  051124  NiWi  Count only ACTIVE and INACTIVE sessions as concurrent sessions(Bug#54215).
--  060112  HAAR  Updated version from 3.2.0 to 4.0.0.
--  060314  PEMA  Increasing number of demo-sessions from 10 to 17 for IFS Solution Manager
--  060323  HAAR  Fallback to language 'en' if language not exists (F1PR413E).
--  060517  PEMA  Support for non-gregorian calendar (e.g. NLS_CALENDAR=Persian)
--  060619  HAAR  Added support for Persian calendar (Bug#58601).
--  060705  NiWi  Stricter enforcement of NAMED license framework(Bug#57872).
--                Modified: Validate_License___
--                Added: Get_Os_User_Count___ and Check_Vul__
--  070313  HAAR  Change version to 4.1.0.
--  071126  HAAR  Added method security (instead of trace) to Init_EE_Session__ (Bug#69569).
--  080312  HAAR  Implement Fnd_Session properties as a context (Bug#68143).
--  080425  HAAR  Corrected count in event CU_WARNING (Bug#73408).
--  081015  HAAR  Improvements IFS License (Bug#77046).
--                - Compare osuser in uppercase
--                - Add active sessions in license calculation
--  090327  MABA  Fixed counting error in Concurrent User License
--  090327  HAAR  Added support for Concurrent User license in Enterprise Explorer (Bug#81763).
--  090610  HAAR  Added function Count_License_Users for better monitoring of licenses (Bug#82508).
--  091116  HAAR  Preferred language set in Init_EE_Session (Bug#87155).
--  100209  HAAR  Added functionality for administrating license in the server (IID#40007).
--  111219  JEHUSE Moved License Management. Unwrap source    
-----------------------------------------------------------------------------
--
--  Dependencies: Security_SYS
--                Object_Connection_SYS
--                Language_SYS
--                Client_SYS
--                Error_SYS
--                Event_SYS      (new depency required by Concurrent Users)
--                Reference_SYS
--                Command_SYS
--                Message_SYS
--                Fnd_Session_API
--                Fnd_Setting_API
--                Fnd_User_API
--                Package DBMS_OUTPUT
--                Package DBMS_SESSION  (new depency required by Concurrent Users)
--                View SYS.gv_$session  (soft depency recommended for Concurrent Users in RAC)
--                View SYS.v_$session   (new depency required by Concurrent Users)
--                Table Fnd_Session_TAB (new depency required by Concurrent Users)
--                Tanle Fnd_User_TAB
--
--  Contents:     Implementation methods for session specific activities
--                Public methods for initiation activities in server.
--                Public methods for database information
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

fnd_version_       CONSTANT VARCHAR2(20) := '22.1.0';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Init_Fnd_Session___ (
   fnd_user_       IN VARCHAR2,
   lang_code_      IN VARCHAR2 DEFAULT NULL )
IS
   invalid_lang_code  EXCEPTION;
   PRAGMA             EXCEPTION_INIT(invalid_lang_code, -20111);
BEGIN
   Fnd_Session_API.Set_Fnd_User(fnd_user_);
   Fnd_Session_API.Set_Property('FND_VERSION', fnd_version_);
   Fnd_Session_API.Set_Language(nvl(lang_code_, Fnd_Session_API.Get_Language));
EXCEPTION
   WHEN invalid_lang_code THEN
      Trace_SYS.Message('You logged on with an invalid language code, we will fallback to language code "en".');
      Fnd_Session_API.Set_Language('en');
END Init_Fnd_Session___;

PRAGMA INLINE(Check_Security___, 'NO');
FUNCTION Check_Security___ RETURN BOOLEAN IS
   depth_     PLS_INTEGER  := UTL_Call_Stack.Dynamic_Depth;
   level_     PLS_INTEGER;
   owner_     VARCHAR2(30);
   --
   -- Subprogram Y (level 4) called subprogram X (level 3) that called
   -- GENERAL_SYS.INIT_METHOD (level 2) that called this procedure (level 1).
   -- If Y exists and is a PL/SQL method owned by the application owner then,
   -- we trust and assume that, Y has already checked the security.
   -- If Y is owned by SYS or has undefined owner (NULL representing anonymous block or 'SQL')
   -- then such subprogram is skipped and the next subprogram on the stack (level 5) is analyzed.
   --
   --  Level Subprogram
   --  ===== =====================================
   --      5 ...
   --      4 Y = Caller of X
   --      3 X = Caller of INIT_METHOD
   --      2 IFSAPP.GENERAL_SYS.INIT_METHOD
   --      1 IFSAPP.GENERAL_SYS.CHECK_SECURITY___
   --
BEGIN
/* Dubug code
FOR i_ IN REVERSE 1 .. depth_ LOOP
      owner_ := UTL_Call_Stack.Owner(i_);
      IF owner_ IS NULL OR owner_ = 'SQL' THEN
         owner_ := '';
      ELSE
         owner_ := owner_ || '.';
      END IF;
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'General_SYS.Check_Security...Stack trace', depth_||'.       ' || to_char(i_) || ' ' || owner_ || UTL_Call_Stack.Concatenate_Subprogram(UTL_Call_Stack.Subprogram(i_)));
   END LOOP;
*/
   IF depth_ < 0 THEN
      RETURN FALSE; -- elaboration?
   ELSIF depth_ < 4 THEN
      IF (UTL_Call_Stack.Owner(1) = Fnd_Session_API.Get_App_Owner AND
          UTL_Call_Stack.Concatenate_Subprogram(UTL_Call_Stack.Subprogram(1)) <> 'GENERAL_SYS.CHECK_SECURITY___') OR 
         (UTL_Call_Stack.Concatenate_Subprogram(UTL_Call_Stack.Subprogram(1)) LIKE '__anonymous_block%') THEN
         RETURN FALSE; -- elaboration
      END IF;
      RETURN TRUE;  -- stack too short, no level 4 on stack
   END IF;
   --
   -- Find first PL/SQL method (subprogram with defined owner) on the stack staring at level 4.
   --
   level_ := 4;
   LOOP
      owner_ := UTL_Call_Stack.Owner(level_);
      -- If subprogram is owned by a system user (SYS, C, CTXSYS) or has undefined owner (NULL representing anonymous block or 'SQL')
      -- then such subprogram is skipped and the next subprogram on the stack (level 5) is analyzed and so on.
      -- NULL is an Anonymous block
      -- C is a callout to a C-program
      EXIT WHEN owner_ <> 'SQL' AND owner_ <> 'SYS' AND owner_ <> 'C' AND owner_ <> 'CTXSYS';
      IF level_ < depth_ THEN
         level_ := level_ + 1;
      ELSE
         RETURN TRUE; -- Y not found on stack
      END IF;
   END LOOP;
   RETURN owner_ <> Fnd_Session_API.Get_App_Owner; -- Y found, check its owner
END Check_Security___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Init_EE_Session__ (
   fnd_setting_msg_      OUT VARCHAR2,
   user_globals_msg_     OUT VARCHAR2,
   os_user_name_          IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(lu_name_, 'GENERAL_SYS', 'Init_EE_Session__');
   Fnd_Session_API.Set_Os_User_Name__(os_user_name_);
   Fnd_User_API.Set_Property(Fnd_Session_API.Get_Fnd_User, 'PREFERRED_LANGUAGE', Fnd_Session_API.Get_Language);
   
    --
   -- Get All Foundation1 settings
   --
   Fnd_Setting_API.Get_All_Settings_(fnd_setting_msg_);
   --
   -- All user profile global variable information
   --
   User_Profile_SYS.Get_All_Info_(user_globals_msg_);
END Init_EE_Session__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Method_Check_ (
   method_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   -- Calcualte on which Dynamic_detpth security check should be done
   PRAGMA INLINE(Check_Security___, 'NO');
   IF (Check_Security___) THEN
      RETURN('CHECK for method '||method_);
   ELSE 
      RETURN('NOCHECK for method '||method_);
   END IF;
END Method_Check_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Init_Method
--   Initiate server activities when a method is activated.
--   Calls to this method from all methods in the application
--   is the backbone of the security mechanism in Foundation1.
@UncheckedAccess
PROCEDURE Check_Security (
   lu_name_     IN VARCHAR2,
   package_     IN VARCHAR2,
   method_      IN VARCHAR2,
   server_only_ IN BOOLEAN DEFAULT FALSE)
IS
BEGIN
   IF (Login_SYS.Get_Method_Security__) THEN
      -- Check if security check should be done
      PRAGMA INLINE(Check_Security___, 'NO');
      IF (Check_Security___) THEN
         -- Only allowed for server methods
         IF server_only_ THEN
            Error_SYS.Appl_General(service_, 'SERVER_ONLY: This method is not allowed to call direct from a client.');
         END IF;
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Security check done for ' || package_||'.'||method_);
      END IF;
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Security not checked for ' || package_||'.'||method_);
   END IF;
END Check_Security;

@UncheckedAccess
PROCEDURE Init_Method (
   lu_name_     IN VARCHAR2,
   package_     IN VARCHAR2,
   method_      IN VARCHAR2,
   trace_only_  IN BOOLEAN DEFAULT FALSE,
   server_only_ IN BOOLEAN DEFAULT FALSE,
   bootstrap_   IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (Login_SYS.Get_Method_Security__) THEN
      IF (bootstrap_) THEN 
         Log_SYS.Init_Trace_(Log_SYS.info_, package_||'.'||method_);
      ELSE 
         Log_SYS.Stack_Trace_(Log_SYS.info_, package_||'.'||method_);
      END IF;
      -- Check if security check should be done
      PRAGMA INLINE(Check_Security___, 'NO');
      IF (NOT trace_only_ AND Check_Security___) THEN
         IF (NOT bootstrap_) THEN
            Dbms_Application_Info.Set_Module(package_, method_); 
         END IF;
         -- Only allowed for server methods
         IF server_only_ THEN
            Error_SYS.Appl_General(service_, 'SERVER_ONLY: This method is not allowed to call direct from a client.');
         END IF;
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Security check done for ' || package_||'.'||method_);
      END IF;
   ELSE
      IF (NOT trace_only_) THEN
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Security not checked for ' || package_||'.'||method_);
      END IF;
   END IF;
END Init_Method;

@UncheckedAccess
PROCEDURE Init_Projection_Method (
   lu_name_     IN VARCHAR2,
   projection_  IN VARCHAR2,
   method_      IN VARCHAR2,
   trace_only_  IN BOOLEAN DEFAULT FALSE)
IS
BEGIN
   IF NOT Fnd_Session_API.Is_Odp_Session THEN
      Error_SYS.Odata_Provider_Access_(service_, 'ILLEGAL_PROJ_CALL: This method is not allowed to be called outside of the IFS OData Provider.');
   END IF;
   Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Calling Projection Method: ' || projection_||'.'||method_);
   Dbms_Application_Info.Set_Module(projection_, method_); 
END Init_Projection_Method;


BEGIN
   Fnd_Session_API.Init;
END;
