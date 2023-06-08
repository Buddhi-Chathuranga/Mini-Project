-----------------------------------------------------------------------------
--
--  Logical unit: FndbasInstallation
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  151014  ChAlLK  Errors on 'Distribution Groups' window when log on with language other than EN (Bug#125215)
--  160712  NaBaLK  Server Side Excel Quick Reports merged from Apps9 (Bug#129251)
--  160715  NaBaLK  Server Side Excel Quick Reports merged from Apps9 (Bug#129644)
--  170117  MaBaLK  Removed obsolete Browsequickreport2 and Executequickreport2 activities from Database(Bug# 133737)
--  170307  NaBaLK  Added FND_MONITORING role and granted it to IFSMONITORING  user (TEBASE-2105)--
--  210623  Lgunlk  Granted permission for 'WorkFlowBpmnHandling' Projection (TEWF-390)
--  210721  Lgunlk  Added validation for Grant permission for 'WorkFlowBpmnHandling' Projection (TEWF-450)
--  211110  Papelk  Moved workflow related implementations to fndwf
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

   role1_  CONSTANT VARCHAR2(30) := 'FND_WEBRUNTIME';
   role3_  CONSTANT VARCHAR2(30) := 'FND_ADMIN';
   role4_  CONSTANT VARCHAR2(30) := 'FND_PRINTSERVER';
   role5_  CONSTANT VARCHAR2(30) := 'FND_DEVELOPER';
   role6_  CONSTANT VARCHAR2(30) := 'FND_PLSQLAP';
   role7_  CONSTANT VARCHAR2(30) := 'FND_CONNECT';
   role9_  CONSTANT VARCHAR2(30) := 'FND_CUSTOMIZE';
   role12_ CONSTANT VARCHAR2(30) := 'FND_QUICK_REPORTS';
   role13_ CONSTANT VARCHAR2(30) := 'FND_IAL_ADMIN';
   role15_ CONSTANT VARCHAR2(30) := 'FND_TRANS_MAN';
   role17_ CONSTANT VARCHAR2(30) := 'FND_WEBENDUSER_MAIN';
   role18_ CONSTANT VARCHAR2(30) := 'FND_WEBENDUSER_B2B';
   role19_ CONSTANT VARCHAR2(30) := 'FND_BPA_ADMIN';
   role20_ CONSTANT VARCHAR2(30) := 'FND_PRINTAGENT';
   role21_ CONSTANT VARCHAR2(30) := 'IFSREADONLYSUPPORT';
   role22_ CONSTANT VARCHAR2(30) := 'FND_LOBBY_ADMIN';
   role23_ CONSTANT VARCHAR2(30) := 'FND_LOBBY_SQLDS_ADMIN';
   
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Run_Ddl_Command___ (
   stmt_ IN VARCHAR2,
   show_errors_ IN BOOLEAN DEFAULT TRUE,
   raise_       IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   @ApproveDynamicStatement(2014-07-15,mabose)
   EXECUTE IMMEDIATE stmt_;
EXCEPTION
   WHEN OTHERS THEN
      IF show_errors_ THEN
         dbms_output.put_line('ERROR  : ' || stmt_);
         dbms_output.put_line('ERROR  : ' || SQLERRM);
      END IF;
      IF raise_ THEN
         RAISE;
      END IF;
END Run_Ddl_Command___;

PROCEDURE Grant_Role___ (
   role_ VARCHAR2,
   grantee_ VARCHAR2 )
IS
BEGIN
   Security_SYS.Grant_Role(role_, grantee_);
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END Grant_Role___;

PROCEDURE Grant_Projection___ (
   projection_ VARCHAR2,
   role_ VARCHAR2)
IS
BEGIN
   Fnd_Projection_Grant_API.Grant_All(projection_,role_, 'FALSE');
END Grant_Projection___;

PROCEDURE Grant_Query_Projection___ (
   projection_ VARCHAR2,
   role_ VARCHAR2)
IS
BEGIN
   Fnd_Projection_Grant_API.Grant_Query(projection_, role_, 'FALSE');
END Grant_Query_Projection___;

PROCEDURE Grant_System_Privilege___ (
   privilege_id_ VARCHAR2,
   role_ VARCHAR2)
IS
BEGIN
   Security_SYS.Grant_System_Privilege(privilege_id_, role_);
END Grant_System_Privilege___;

PROCEDURE Clear_Role___ (
   role_ IN VARCHAR2 )
IS
BEGIN
   -- Revoke everything from FNDBAS method security
   Security_SYS.Clear_Role(role_, FALSE);
   Run_Ddl_Command___('DELETE FROM security_sys_tab WHERE role = '''||role_||'''');
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END Clear_Role___;


FUNCTION Is_Fnd_Role_Created___(role_ VARCHAR2) RETURN BOOLEAN
IS
   temp_ NUMBER;

   CURSOR check_fnd_role IS
      SELECT 1
      FROM fnd_role_tab
      WHERE role=UPPER(role_);
BEGIN
   OPEN check_fnd_role;
   FETCH check_fnd_role INTO temp_;
   IF check_fnd_role%FOUND THEN
      CLOSE check_fnd_role;
      RETURN TRUE;
   ELSE
      CLOSE check_fnd_role;
      RETURN FALSE;
   END IF;
END Is_Fnd_Role_Created___;

PROCEDURE Create_Role___ (
   role_        IN VARCHAR2,
   description_ IN VARCHAR2,
   role_type_   IN VARCHAR2 )
IS
   upper_role_     VARCHAR2(30);
   user_role_exist EXCEPTION;
   PRAGMA          exception_init(user_role_exist, -20112);
BEGIN
   upper_role_ := UPPER(role_);
   IF NOT Is_Fnd_Role_Created___(upper_role_) THEN  
      BEGIN
         Security_SYS.Create_Role(upper_role_, description_, role_type_);
      EXCEPTION
         WHEN user_role_exist THEN
            NULL;
      END;
   END IF;
END Create_Role___;


PROCEDURE Fndbas_Security_Object___
IS
BEGIN
   DBMS_Output.Put_Line('Creating Roles and grants needed by IFS Base Server');
   IF Installation_Sys.Get_Installation_Mode THEN
      DBMS_Output.Put_Line('Clearing predefined roles (if created) before granting to guarantee correctness');
      DBMS_Output.Put_Line('Clearing role '||role1_||', '||role3_||', '||role5_||', '||role9_||', '||role12_||', '||role13_||','||role15_);
      -- Clearing of FND_PRINTSERVER and FND_PLSQLAP should not be done
      -- since these roles then would loose all grants...

-- NOTE! This code is commented since it could create severe performance problems. Since we do not know the reason for the problem we temporary skip it
-- 2018-02-26 Chmulk, Mabose, Dobese
--      DBMS_Output.Put_Line('Revoke_Deadlock_Packages___ '||role1_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
--      Revoke_Deadlock_Packages___(role1_);
--      DBMS_Output.Put_Line('Revoke_Deadlock_Packages___ '||role2_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
--      Revoke_Deadlock_Packages___(role2_);
--      DBMS_Output.Put_Line('Revoke_Deadlock_Packages___ '||role3_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
--      Revoke_Deadlock_Packages___(role3_);
--      DBMS_Output.Put_Line('Revoke_Deadlock_Packages___ '||role5_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
--      Revoke_Deadlock_Packages___(role5_);
--      DBMS_Output.Put_Line('Revoke_Deadlock_Packages___ '||role9_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
--      Revoke_Deadlock_Packages___(role9_);
--      DBMS_Output.Put_Line('Revoke_Deadlock_Packages___ '||role12_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
--      Revoke_Deadlock_Packages___(role12_);
--      DBMS_Output.Put_Line('Revoke_Deadlock_Packages___ '||role13_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
--      Revoke_Deadlock_Packages___(role13_);
--      DBMS_Output.Put_Line('Revoke_Deadlock_Packages___ '||role15_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
--      Revoke_Deadlock_Packages___(role15_);
--      DBMS_Output.Put_Line('Done Revoke_Deadlock_Packages___ at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
      --
--      DBMS_Output.Put_Line('Clear_Role___ '||role1_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
      Clear_Role___(role1_);
--      DBMS_Output.Put_Line('Clear_Role___ '||role3_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
      Clear_Role___(role3_);
--      DBMS_Output.Put_Line('Clear_Role___ '||role5_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
      Clear_Role___(role5_);
--      DBMS_Output.Put_Line('Clear_Role___ '||role9_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
      Clear_Role___(role9_);
--      DBMS_Output.Put_Line('Clear_Role___ '||role12_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
      Clear_Role___(role12_);
--      DBMS_Output.Put_Line('Clear_Role___ '||role13_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
      Clear_Role___(role13_);
--      DBMS_Output.Put_Line('Clear_Role___ '||role15_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
      Clear_Role___(role15_);
--      DBMS_Output.Put_Line('Done Clear_Role___ at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
      Clear_Role___(role22_);
      Clear_Role___(role23_);
      --
   END IF;

   DBMS_Output.Put_Line('Creating predefined Foundation1 roles if not already created');
   DBMS_Output.Put_Line('Creating role '||role1_||', '||role3_||', '||role4_||', '||role5_||', '||role7_||', '||role9_||', '||role12_||', '||role13_ );
--   DBMS_Output.Put_Line('Create_Role___ '||role1_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role1_,  'Required grants to database objects for standard and IFS Aurena framework functionality','BUILDROLE');
--   DBMS_Output.Put_Line('Create_Role___ '||role3_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role3_,  'Grants to all Administration forms not requiring Appowner privileges','ENDUSERROLE');
--   DBMS_Output.Put_Line('Create_Role___ '||role4_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role4_,  'All required grants for a Print Server user','ENDUSERROLE');
--   DBMS_Output.Put_Line('Create_Role___ '||role5_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role5_,  'Role for Foundation1 Developers for debugging and analyzing. NOTE! This role should only contain system privileges since granting this role to endusers should not require refresh of security cache.','ENDUSERROLE');
--   DBMS_Output.Put_Line('Create_Role___ '||role6_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role6_,  'Role needed for PL/SQL Access Provider user.','ENDUSERROLE');
--   DBMS_Output.Put_Line('Create_Role___ '||role7_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role7_,  'Role needed for IFS Connect framework user.','ENDUSERROLE');
--   DBMS_Output.Put_Line('Create_Role___ '||role9_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role9_,  'Role needed for customizing clients.','BUILDROLE');
--   DBMS_Output.Put_Line('Create_Role___ '||role12_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role12_, 'Role needed for creating and publishing Quick Reports', 'ENDUSERROLE');
--   DBMS_Output.Put_Line('Create_Role___ '||role13_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role13_, 'Role needed for administrating IAL Objects', 'ENDUSERROLE');
--   DBMS_Output.Put_Line('Create_Role___ '||role15_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role15_, 'Role contains grants related to Translations Management in central scanning environments', 'ENDUSERROLE');
--   DBMS_Output.Put_Line('Create_Role___ '||role17_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role17_, 'Basic role for end users of IFS Aurena. Contains framework functionality for end users', 'ENDUSERROLE');
--   DBMS_Output.Put_Line('Create_Role___ '||role18_||' at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role18_, 'Basic role for B2B users of IFS Aurena. Contains framework functionality for B2B users', 'ENDUSERROLE');
--   DBMS_Output.Put_Line('Done Create_Role___ at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role19_, 'End user role for required to interact with the camunda rest api.', 'ENDUSERROLE');
--   DBMS_Output.Put_Line('Done Create_Role___ at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role20_, 'All required grants for a Print Agent user.', 'ENDUSERROLE');
--   DBMS_Output.Put_Line('Done Create_Role___ at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role21_, 'Read-Only Grants for all Projections.', 'ENDUSERROLE');
--   DBMS_Output.Put_Line('Done Create_Role___ at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role22_, 'End user role administrating Aurena Lobby', 'ENDUSERROLE');
--   DBMS_Output.Put_Line('Done Create_Role___ at '||TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS'));
   Create_Role___(role23_, 'End user role administrating Aurena Lobby and manipulating SQL data sources ', 'ENDUSERROLE');

END Fndbas_Security_Object___;

PROCEDURE Fndbas_Security_Data___
IS
BEGIN
   Create_Role_Hierarchy___;   
   Do_Fnd_Web_Grants___;
   Do_Fnd_Printserver_Grants___;   
   Do_Fnd_PLSQLAP_Grants___;
   Do_Fnd_Connect_Grants___;  
   Do_Fnd_Webenduser_Main_Grants___;
   Do_Fnd_Webenduser_B2b_Grants___;
   Do_Fnd_Admin_Grants___;
   Do_Fnd_Bpa_Admin_Grants___;
   Do_Ifsmonitoring_Grants___;
   Do_Ifsreadonlysupp_Grants___;
   Do_File_Storage_Grants___;
   Do_Lobby_Admin_Grants___;
   Do_Lobby_SQL_DS_Admin_Grants___;
END Fndbas_Security_Data___;


PROCEDURE Create_Role_Hierarchy___
IS
BEGIN
   -- Grant FND_CUSTOMIZE to FND_ADMIN.
   Grant_Role___(role9_, role3_);
   -- Grant FND_WEBRUNTIME to FND_PRINTSERVER
   Grant_Role___(role1_ , role4_);
   -- Grant FND_WEBRUNTIME to FND_DEVELOPER
   Grant_Role___(role1_, role5_);
   -- Grant FND_WEBRUNTIME to FND_CONNECT
   Grant_Role___(role1_, role7_);
   -- Grant FND_CONNECT to FND_PLSQLAP
   Grant_Role___(role7_, role6_);
   -- Grant FND_WEBENDUSER_MAIN to FND_TRANS_MAN
   Grant_Role___(role17_, role15_);
   -- Grant FND_WEBENDUSER_B2B to FND_TRANS_MAN
   Grant_Role___(role18_, role15_);
   -- Grant FND_PRINTSERVER to user IFSPRINT
   Grant_Role___(role4_,'IFSPRINT');
   -- Grant FND_PRINTAGENT to user IFSPRINTAGENT
   Grant_Role___(role20_, 'IFSPRINTAGENT');
   -- Grant FND_ADMIN to user IFSADMIN
   Grant_Role___(role3_,'IFSADMIN');
   -- Grant FND_CONNECT to user IFSADMIN
   Grant_Role___(role7_,'IFSADMIN');
   -- Grant FND_PLSQLAP to user IFSPLSQLAP
   Grant_Role___(role6_,'IFSPLSQLAP');
   -- Grant FND_CONNECT to user IFSCONNECT
   Grant_Role___(role7_,'IFSCONNECT');
   -- Grant FND_WEBRUNTIME to user FND_WEBENDUSER_MAIN
   Grant_Role___('FND_WEBRUNTIME', role17_);
   -- Grant FND_WEBRUNTIME to user FND_WEBENDUSER_B2B
   Grant_Role___('FND_WEBRUNTIME', role18_);
   -- Grant FND_WEBENDUSER_MAIN to role FND_ADMIN
   Grant_Role___(role17_, role3_);
   -- Grant FND_WEBENDUSER_B2B to role FND_ADMIN
   Grant_Role___(role18_, role3_);
   -- Grant FND_BPA_API to role FND_ADMIN
   Grant_Role___(role19_, role3_);
   -- Grant FND_WEBENDUSER_MAIN to user IFSAPPMONITOR
   Grant_Role___(role17_,'IFSAPPMONITOR');
   -- Grant FND_WEBENDUSER_B2B to user IFSAPPMONITOR
   Grant_Role___(role18_,'IFSAPPMONITOR');
      -- Grant FND_WEBENDUSER_B2B to user IFSAPPMONITOR
   Grant_Role___(role21_,'IFSREADONLYSUPP');
   
   Grant_Role___(role22_, role23_);
   
   Grant_Role___(role22_, role3_);
END Create_Role_Hierarchy___;



PROCEDURE Do_Fnd_Web_Grants___
IS
BEGIN
   Security_SYS.Grant_Framework_Projections(role1_);
END Do_Fnd_Web_Grants___;
   

PROCEDURE Do_Fnd_Printserver_Grants___
IS
BEGIN
   --
   -- IFSPRINT is an Oracle User, should be able to connect to the database
   --
   Run_DDL_Command___('GRANT CREATE SESSION TO IFSPRINT', TRUE, TRUE);
   --
   -- IFS System privileges
   --
   Security_SYS.Grant_System_Privilege('ADMINISTRATOR', role4_);
   Security_SYS.Grant_System_Privilege('IMPERSONATE USER', role4_);
   --
   -- Grants on Activities
   --

   Security_SYS.Grant_Activity('PrintJobHandler', role4_);
   Security_SYS.Grant_Activity('FormatReport', role4_);
   Security_SYS.Grant_Activity('ReportingMessageHandlerService', role4_);
   Security_SYS.Grant_Activity('PrintAgentService', role4_);
   Security_SYS.Grant_Activity('ExcelQuickReport', role4_);
   Security_SYS.Grant_Activity('ExcelQuickReportActivity', role4_);
   
   --
   -- Grants on Projections
   --
   Grant_Projection___('PrintAgent', role20_);
END Do_Fnd_Printserver_Grants___;

PROCEDURE Do_Fnd_PLSQLAP_Grants___
IS
BEGIN
   --
   -- IFS System privileges
   --
   Security_SYS.Grant_System_Privilege('CONNECT', role6_);
   Security_SYS.Grant_System_Privilege('IMPERSONATE USER', role6_);
END Do_Fnd_PLSQLAP_Grants___;


PROCEDURE Do_Fnd_Connect_Grants___
IS
BEGIN
   --Grants on Database Tasks
   --
   Security_SYS.Grant_Pres_Object('taskApp_Message_Processing_Api.Run_Application_Server_Task', role7_);
   -- 
   --
   -- IFS System privileges
   --
   Security_SYS.Grant_System_Privilege('IMPERSONATE USER', role7_);
   --
   -- Grants on System Privileges
   --
   Security_SYS.Grant_System_Privilege('CONNECT', role7_);
   Security_SYS.Grant_System_Privilege('IMPERSONATE USER', role7_);
   
   Security_SYS.Grant_Activity('MessageHandlerService', role7_);
   Security_SYS.Grant_Activity('PrintAgentService', role7_);
   Security_SYS.Grant_Activity('ExternalPrintAgent', role7_);
   Security_SYS.Grant_Activity('ExcelQuickReport', role7_);
   Security_SYS.Grant_Activity('ExcelQuickReportActivity', role7_);
   
   Grant_Projection___('ApplicationMessageHandling', role7_);
	Grant_Projection___('ApplicationMessagesHandling', role7_);
	Grant_Projection___('ApplicationMessagesLobbyHandling', role7_);
	Grant_Projection___('ApplicationMessageStatisticsHandling', role7_);
	Grant_Projection___('BatchProcessorQueueHandling', role7_);
	Grant_Projection___('ConnectConfigurationHandling', role7_);
	Grant_Projection___('ConnectExportHandling', role7_);
	Grant_Projection___('ConnectImportHandling', role7_);
	Grant_Projection___('ConnectNodeHandling', role7_);
	Grant_Projection___('ConnectReaderQueueHandling', role7_);
	Grant_Projection___('JsfPropertiesHandling', role7_);
	Grant_Projection___('RoutingAddressesHandling', role7_);
	Grant_Projection___('RoutingRulesHandling', role7_);
   
END Do_Fnd_Connect_Grants___;


PROCEDURE Do_Fnd_Webenduser_Main_Grants___
IS
BEGIN
   Grant_Projection___('MediaUtility', role17_);
   Grant_Projection___('OperationalReports', role17_);
   Grant_Projection___('ScheduledReports', role17_);
   Grant_Projection___('PrintDialog', role17_);
   Grant_Projection___('QuickReports', role17_);
   Grant_Projection___('SqlQuickReports', role17_);
   Grant_Projection___('ReportArchive', role17_);
   Grant_Projection___('StreamSubscriptions', role17_);
   Grant_Projection___('UserTasks', role17_);
   Grant_Projection___('ScheduledDatabaseTasksHandling', role17_);
   Grant_Projection___('ScheduledDatabaseTaskChainsHandling', role17_);
   Grant_Projection___('AddressLayout', role17_);
   Grant_Projection___('BookmarkService', role17_);
   Grant_Projection___('BackgroundJobsHandling', role17_);
   Grant_Projection___('EventActionSubscriptionHandling', role17_);
   Grant_Projection___('UserPinHandling', role17_);
   Grant_Projection___('CamundaRestInterface', role17_);
   Grant_Projection___('ConditionalFormatHandling', role17_);
   Grant_Query_Projection___('ProjectionExplorer', role17_);
   Grant_Query_Projection___('OutboundMessageHandling', role17_);
   Pres_Object_Util_API.Grant_Pres_Object('taskArchive_Api.Create_And_Print_Report__', role17_);
END Do_Fnd_Webenduser_Main_Grants___;

   
PROCEDURE Do_Fnd_Webenduser_B2b_Grants___
IS
BEGIN
   Grant_Projection___('MediaUtility', role18_);
   Grant_Projection___('OperationalReports', role18_);
   Grant_Projection___('ScheduledReports', role18_);
   Grant_Projection___('PrintDialog', role18_);
   Grant_Projection___('QuickReports', role18_);
   Grant_Projection___('SqlQuickReports', role18_);
   Grant_Projection___('ReportArchive', role18_);
   Grant_Projection___('StreamSubscriptions', role18_);
   Grant_Projection___('UserTasks', role18_);
   Grant_Projection___('AddressLayout', role18_);
   Grant_Projection___('BookmarkService', role18_);
   Grant_Projection___('EventActionSubscriptionHandling', role18_);
   Grant_Projection___('CamundaRestInterface', role18_);
   Grant_Projection___('ConditionalFormatHandling', role18_);
   Pres_Object_Util_API.Grant_Pres_Object('taskArchive_Api.Create_And_Print_Report__', role18_);
END Do_Fnd_Webenduser_B2b_Grants___;

      
PROCEDURE Do_Fnd_Admin_Grants___
IS
BEGIN
   Grant_Projection___('ScheduledDatabaseTasksHandling', role3_);
   Grant_Projection___('ScheduledDatabaseTaskChainsHandling', role3_);
   Grant_Projection___('UserGroupHandling', role3_);
   Grant_Projection___('PermissionSetHandling', role3_);
   Grant_Projection___('BackgroundJobsHandling', role3_);
   Grant_Projection___('ProjectionCheckpointHandling', role3_);
   Grant_Projection___('UserHandling', role3_);
   Grant_Projection___('CamundaRestInterface', role3_);
   Grant_Projection___('CustomBranding', role3_);
   Grant_Projection___('AppearanceConfiguration', role3_);
   Grant_Projection___('BatchQueueConfigurationHandling', role3_);
   Grant_Projection___('ReportImagesHandling', role3_);
END Do_Fnd_Admin_Grants___;   

PROCEDURE Do_Fnd_Bpa_Admin_Grants___
IS
BEGIN
   Grant_Projection___('CamundaRestInterface', role19_);
END Do_Fnd_Bpa_Admin_Grants___;  

PROCEDURE Do_Ifsmonitoring_Grants___
IS
BEGIN
   Run_DDL_Command___('GRANT CREATE SESSION TO IFSMONITORING', TRUE, TRUE);
   Run_DDL_Command___('GRANT EXECUTE ON FND_MONITOR_ENTRY_API TO IFSMONITORING', TRUE, TRUE);
   Run_DDL_Command___('GRANT SELECT ON SYS.GV_$SESSION TO IFSMONITORING', TRUE, TRUE);
END Do_Ifsmonitoring_Grants___;

PROCEDURE Do_Ifsreadonlysupp_Grants___
IS
   attr_    VARCHAR2(2000);
BEGIN
   Client_SYS.Add_To_Attr('ROLE_', role21_, attr_); 
  
   IF NOT (Deferred_Job_API.Procedure_Already_Posted_('Database_SYS.Grant_All_Projections_Readonly')) THEN
      Transaction_SYS.Deferred_Call('Database_SYS.Grant_All_Projections_Readonly',
                                    Argument_Type_API.DB_NORMAL_PARAMETER,
                                    attr_,
                                    'Read Only Grant All Projection to '||role21_,
                                    posted_date_ => (sysdate + 1/48));
   END IF;
   
END Do_Ifsreadonlysupp_Grants___;

PROCEDURE Do_File_Storage_Grants___
IS
BEGIN
   Grant_Projection___('FileStorageHandling', role1_);
END Do_File_Storage_Grants___;

PROCEDURE Do_Lobby_Admin_Grants___
IS
BEGIN
   Grant_Projection___('LobbyConfiguration', role22_);
   Grant_Projection___('LobbyElementConfiguration', role22_);
   Grant_Projection___('LobbyDatasourceConfiguration', role22_);
END Do_Lobby_Admin_Grants___;

PROCEDURE Do_Lobby_SQL_DS_Admin_Grants___
IS
BEGIN
   Grant_System_Privilege___('LOBBY DATASOURCE DESIGNER', role23_);
   Grant_System_Privilege___('DEFINE SQL', role23_);
END Do_Lobby_SQL_DS_Admin_Grants___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Post_Installation_Object
IS
BEGIN
   Fndbas_Security_Object___;
END Post_Installation_Object;

@UncheckedAccess
PROCEDURE Post_Installation_Data
IS
BEGIN
   IF Installation_SYS.Get_Installation_Mode = FALSE
   OR Module_API.Is_Affected_By_Delivery('FNDBAS') THEN
      Fndbas_Security_Data___;
   END IF;
   Navigator_SYS.Insert_Navigator_Entries;
END Post_Installation_Data;
