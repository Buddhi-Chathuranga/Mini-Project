-----------------------------------------------------------------------------
--
--  Logical unit: ArchiveDistribution
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960409  MANY  Base Table to Logical Unit Generator 1.0A
--  960520  MANY  Added method Cleanup_Users__(), removing dependency between
--                Archive and ArchiveDistribution.
--  960809  MANY  Fixed bug with redistribution in method New_Entry_Instance___
--                changing cursor select from view to table (security overides
--                selecttion against view).
--  960930  MANY  Added methods Get_Printed(), Set_Printed().
--                Fixed bug in method New_Entry_Instance___(), (no distribution)
--  961112  MANY  Added column SHOW_STATE, and methods Set_Show_State() and
--                Get_Show_State().
--  961212  MANY  Added method Connect_Instance()
--  970407  MANY  Modified method Remove_Old_Users() toset instance as hidden
--                if included in a printjob.
--  970806  MANY  Chenges concerning new user concept FndUser
--  970930  MANY  Fixed Oracle compatability problem with method Get_Show_State(),
--                induced by assigning value to record thus violating PRAGMA !.
--  971009  MANY  Small improvement tomethod Set_Expire_Date(), now creates new
--                distribution entry when ordinary entry no found.
--  980129  MANY  Fixed bug #2067, Archive only cleaned correctly for application owner.
--  980727  MANY  Optimized SQL-statement in view (Bug #2578)
--  980827  MANY  Fixed problem with cleanup not setting hidden (Bug #2601)
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  990119  MANY  Added newly created method for row-level security on view.
--  990222  ERFO  Yoshimura: Changes in Set_Printed and Set_Show_State (ToDo #3160).
--  990322  DOZE  Rewritten to new templates (ToDo #3198).
--  990324  ERFO  Changed view definition according to performance (Bug #3236).
--  990920  ERFO  Rewrite of view definition for improved performance (ToDo #3580).
--  991020  ERFO  Minor performance issue in New_Entry_Instance___ (Bug #3621).
--  000509  ROOD  Performance improvements in Is_Distributed (Bug #16093).
--  020702  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  020703  ROOD  Added declaration of implementation method
--                New_Entry_Instance___ (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  040305  ROOD  Changed design approach for user_name, i.e. selecting from table
--                instead of view. Made the columns printed and show_state mandatory.
--                Updated template (Bug#33057).
--  040318  ROOD  Created new replacement version of Set_Show_State and used
--                this new method in Remove_User (Bug#33057).
--  040702  ROOD  Added view allowed_report, modified condition in main view.
--                Added raw data view INFO_SERVICES_RPV (Bug#44975).
--  040708  ROOD  Corrected view comment for the new raw data view (F1PR413).
--  040713  ROOD  Set parameter user_name default and last in Set_Show_State (Bug#43917).
--  040713  ROOD  Synchronized with model and made some implementation changes (Bug#44945).
--  070424  UTGULK Added column comments to INFO_SERVICES_RPV to avoid refresh warnings.
--  080818  HASPLK Added method Is_Key_Available (Bug#72528)
--  100901  DUWI  Removed Socket_Message calling from New_Entry_Instance___(EACS-986)
--  121112  NaBa  Added emailing functionality for distribution in IFS EE and Web (Bug#106412)
--  140318  NaBa  Added logic to activate/deactivate sending emails when distributed (Bug#115645)
--  180220  HADOLK  Changed Command_SYS.Mail argument list (BugID#2808)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE New_Entry_Instance___ (
   result_key_  IN NUMBER,
   user_name_   IN VARCHAR2,
   expire_date_ IN DATE,
   message_     IN VARCHAR2 DEFAULT NULL,
   notify_self_ IN BOOLEAN DEFAULT FALSE )
IS
   new_expire_date_ DATE;
   old_expire_date_ DATE;
   fnd_user_        VARCHAR2(30);
   newrec_          ARCHIVE_DISTRIBUTION_TAB%ROWTYPE;
   objid_           ARCHIVE_DISTRIBUTION.objid%TYPE;
   objversion_      ARCHIVE_DISTRIBUTION.objversion%TYPE;
   empty_attr_      VARCHAR2(2000);
   subject_         VARCHAR2(200);
   email_msg_       VARCHAR2(1000);
   ext_server_      VARCHAR2(200);
   iee_url_         VARCHAR2(500);

BEGIN
   IF NOT Check_Exist___(result_key_, user_name_) THEN
      newrec_.result_key := result_key_;
      newrec_.user_name  := user_name_;
      newrec_.arrival_time := SYSDATE;
      newrec_.expire_date := expire_date_;
      newrec_.printed := 0;
      newrec_.show_state := 'V';
      Insert___(objid_, objversion_, newrec_, empty_attr_);
         
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      IF ((message_ IS NOT NULL AND fnd_user_ <> user_name_ OR (notify_self_ AND fnd_user_ = user_name_))
          AND NVL(Fnd_Setting_API.Get_Value('REP_ARCH_DIST_EMAIL'),'YES') = 'YES') THEN
         ext_server_ := Fnd_Setting_API.Get_Value('SYSTEM_URL');
         subject_ := Language_SYS.Translate_Constant(lu_name_, 'DISTRIBSUBJ: The report has been delivered', NULL);
         IF (ext_server_ IS NOT NULL) AND NOT (ext_server_='http://<host>:<port>') THEN
            iee_url_ := Language_SYS.Translate_Constant(lu_name_,'DISTRIBIEEURL: IF you are using IFS Enterprise Explorer, click on the following link to print the report: ' ,NULL);
            iee_url_ := iee_url_||CHR(13)||CHR(10)||ext_server_|| '/client/runtime/Ifs.Fnd.Explorer.application?url=' || utl_url.escape('ifswin:Ifs.Application.InfoServices.ReportArchive?action=get'||'&'||'key1='|| result_key_, TRUE, NULL)||CHR(13)||CHR(10);
         END IF;
         email_msg_ := Language_SYS.Translate_Constant(lu_name_, 
                                                       'DISTRIBRDY: The report with result key :P1 has been delivered. ' ||CHR(13)||CHR(10)||
                                                       ':P2 Alternatively, open the Report Archive window, highlight the row with result key :P1 and select "Print..." from the context menu.', NULL, result_key_, iee_url_);
/*         Command_SYS.Mail(fnd_user_, 
                          user_name_,
                          email_msg_,
                          subject_ => subject_,
                          from_alias_ => 'IFS Applications'); */
         --Command_SYS.Mail('IFS Applications', fnd_user_, user_name_, NULL, NULL, subject_, email_msg_, NULL);
         Command_SYS.Mail(fnd_user_, user_name_, email_msg_, NULL, NULL, NULL, subject_, NULL, NULL, 'IFS Applications', NULL);
      END IF;
   ELSE
      old_expire_date_ := Get_Expire_Date(result_key_, user_name_);
      IF (expire_date_ > old_expire_date_) THEN
         new_expire_date_ := expire_date_;
      ELSE
         new_expire_date_ := old_expire_date_;
      END IF;
      UPDATE ARCHIVE_DISTRIBUTION_TAB
         SET expire_date = new_expire_date_, 
             show_state  = 'V'
         WHERE result_key = result_key_
         AND   user_name = user_name_;
   END IF;
END New_Entry_Instance___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ARCHIVE_DISTRIBUTION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.printed := nvl(newrec_.printed,0);
   newrec_.show_state :=  nvl(newrec_.show_state,'V');
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE New_Entry_Distribution__ (
   result_key_        IN NUMBER,
   distribution_list_ IN VARCHAR2,
   expire_date_       IN DATE,
   message_           IN VARCHAR2 DEFAULT NULL,
   notify_self_       IN BOOLEAN DEFAULT FALSE )
IS
   field_separator_ VARCHAR2(1) := Client_SYS.field_separator_;
   from_            NUMBER;
   to_              NUMBER;
   member_          VARCHAR2(30);
   user_name_       VARCHAR2(30);
   group_list_      VARCHAR2(32000);
   dist_list_       VARCHAR2(32000);
   group_from_      NUMBER;
   group_to_        NUMBER;
   any_success_     BOOLEAN := FALSE;
   any_error_       BOOLEAN := FALSE;

BEGIN
   dist_list_ := distribution_list_ || Fnd_Session_API.Get_Fnd_User || field_separator_;
   from_ := 1;
   to_ := instr(dist_list_, field_separator_, from_);      
   WHILE (to_ > 0) LOOP
      member_ := substr(dist_list_, from_, to_ - from_);
      IF (Distribution_Group_API.Is_Group(member_)) THEN
         Distribution_Group_Member_API.Get_Members(group_list_, member_);
         group_from_ := 1;
         group_to_ := instr(group_list_, field_separator_, group_from_);
         WHILE (group_to_ > 0) LOOP
            user_name_ := substr(group_list_, group_from_, group_to_ - group_from_);
            IF (Distribution_Group_API.Is_User(user_name_)) THEN
               New_Entry_Instance___(result_key_, user_name_, expire_date_, message_, notify_self_);
               any_success_ := TRUE;
            ELSE
               any_error_ := TRUE; -- Create no error for now.
            END IF;
            group_from_ := group_to_ + 1;
            group_to_ := instr(group_list_, field_separator_, group_from_);
         END LOOP;
      ELSIF (Distribution_Group_API.Is_User(member_)) THEN
         New_Entry_Instance___(result_key_, member_, expire_date_, message_, notify_self_);
         any_success_ := TRUE;
      ELSE
         any_error_ := TRUE; -- Create no error for now.
      END IF;
      from_ := to_ + 1;
      to_ := instr(dist_list_, field_separator_, from_);
   END LOOP;
   IF any_error_ THEN  -- Now create error.
      IF any_success_ THEN
         Error_SYS.Appl_General(ARCHIVE_DISTRIBUTION_API.lu_name_, 'NEWDISTRSOME: Report was not distributed successfully to all of ":P1".',
                                distribution_list_);
      ELSE
         Error_SYS.Appl_General(ARCHIVE_DISTRIBUTION_API.lu_name_, 'NEWDISTR: No valid members in distributionlist ":P1".',
                                distribution_list_);
      END IF;
   ELSIF NOT any_success_ THEN
      New_Entry_Instance___(result_key_, Fnd_Session_API.Get_Fnd_User, expire_date_, message_, notify_self_);
   END IF;
END New_Entry_Distribution__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Expire_Date (
   result_key_  IN NUMBER,
   user_name_   IN VARCHAR2,
   expire_date_ IN DATE )
IS
BEGIN
   UPDATE ARCHIVE_DISTRIBUTION_TAB
      SET   expire_date = expire_date_
      WHERE result_key = result_key_
      AND   user_name = user_name_;
   IF (SQL%NOTFOUND) THEN
      New_Entry_Instance___(result_key_, user_name_, expire_date_);
   END IF;
END Set_Expire_Date;


PROCEDURE Set_Show_State (
   result_key_ IN NUMBER,
   show_state_ IN VARCHAR2,
   user_name_  IN VARCHAR2 DEFAULT NULL )
IS
   user_name_int_ VARCHAR2(30);
BEGIN
   user_name_int_ := nvl(user_name_, Fnd_Session_API.Get_Fnd_User);
   UPDATE ARCHIVE_DISTRIBUTION_TAB
      SET show_state = show_state_
      WHERE result_key = result_key_
      AND user_name = user_name_int_;
END Set_Show_State;


PROCEDURE Set_Printed (
   result_key_ IN NUMBER,
   identity_   IN VARCHAR2 )
IS
BEGIN
   UPDATE ARCHIVE_DISTRIBUTION_TAB
      SET printed = 1
      WHERE result_key = result_key_
      AND user_name = identity_;
END Set_Printed;


PROCEDURE Set_Printed (
   result_key_ IN NUMBER )
IS
   fnduser_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   Set_Printed(result_key_, fnduser_);
END Set_Printed;


@UncheckedAccess
FUNCTION Is_Distributed (
   result_key_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   found_ BOOLEAN;
   -- SELECT.. must be against table to give a correct value.
   CURSOR get_distribution IS
      SELECT 1
      FROM ARCHIVE_DISTRIBUTION_TAB
      WHERE result_key = result_key_;
BEGIN
   OPEN get_distribution;
   FETCH get_distribution INTO dummy_;
   found_ := get_distribution%FOUND;
   CLOSE get_distribution;
   RETURN found_;
END Is_Distributed;


PROCEDURE Remove_Old_Users
IS
   -- SELECT.. must be against table to give a correct value.
   CURSOR get_rec IS
      SELECT result_key, user_name
      FROM ARCHIVE_DISTRIBUTION_TAB
      WHERE expire_date <= SYSDATE;
BEGIN
   FOR rec IN get_rec LOOP
      Remove_User(rec.result_key, rec.user_name);
   END LOOP;
END Remove_Old_Users;


PROCEDURE Remove_User (
   result_key_  IN NUMBER,
   user_name_   IN VARCHAR2 )
IS
BEGIN
   IF (NOT Print_Job_Contents_API.Is_Distributed(result_key_)) THEN
      Trace_SYS.Message('DELETING: '||result_key_||', '||user_name_);
      DELETE FROM ARCHIVE_DISTRIBUTION_TAB
         WHERE result_key = result_key_
         AND   user_name = user_name_;
   ELSE
      Trace_SYS.Message('HIDING: '||result_key_||', '||user_name_);
      Set_Show_State(result_key_, 'H', user_name_);
   END IF;
END Remove_User;


PROCEDURE Connect_Instance (
   result_key_  IN NUMBER,
   user_name_   IN VARCHAR2,
   expire_date_ IN DATE )
IS
   newrec_          ARCHIVE_DISTRIBUTION_TAB%ROWTYPE;
   objid_           ARCHIVE_DISTRIBUTION.objid%TYPE;
   objversion_      ARCHIVE_DISTRIBUTION.objversion%TYPE;
   empty_attr_      VARCHAR2(2000);
BEGIN
   IF NOT Check_Exist___(result_key_, user_name_) THEN
      newrec_.result_key := result_key_;
      newrec_.user_name  := user_name_;
      newrec_.arrival_time := SYSDATE;
      newrec_.expire_date := expire_date_;
      newrec_.printed := 0;
      newrec_.show_state := 'H';
      Insert___(objid_, objversion_, newrec_, empty_attr_);
   END IF;
END Connect_Instance;

@UncheckedAccess
FUNCTION Is_Key_Available (
   result_key_ IN NUMBER,
   user_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER;
   CURSOR get_key IS
      SELECT 1
      FROM ARCHIVE_DISTRIBUTION_TAB
      WHERE user_name = user_name_
      AND result_key = result_key_;

BEGIN
   OPEN get_key;
   FETCH get_key INTO temp_;
   IF (get_key%FOUND) THEN
      CLOSE get_key;
      RETURN 'TRUE';
   ELSE
      CLOSE get_key;
      RETURN 'FALSE';
   END IF;
END Is_Key_Available;



