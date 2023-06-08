EXEC Dbms_Application_Info.Set_Module('IFS Applications Installer', 'Preparing Database');

SPOOL prepare.log
SET SERVEROUTPUT ON

START "../define.tem"

-- The name of the Camunda application owner
 DEFINE CAMUNDA_APPOWNER     = IFSCAMSYS

-- The name of the Identity and Access Manager application owner
 DEFINE IAM_APPOWNER         = IFSIAMSYS

PROMPT
--PROMPT "Create default tablespaces"
PROMPT Start deploying CreateIFSTablespaces.sql
START CreateIFSTablespaces.sql

PROMPT
--PROMPT "Create default IFS user profile"
PROMPT Start deploying CreateIFSUserProfile.sql
START CreateIFSUserProfile.sql

PROMPT
--PROMPT "Create IFS application owner and other users"
PROMPT Start deploying CreateIFSUsers.sql
SPOOL OFF
START CreateIFSUsers.sql
SPOOL prepare.log APPEND

PROMPT
--PROMPT "Grant DBA privileges for IFS users"
PROMPT Start deploying Dbagrant.sql
START Dbagrant.sql
PROMPT
PROMPT Start deploying DbagrantIAL.sql
START DbagrantIAL.sql
PROMPT
PROMPT Start deploying DbagrantIfsCamSys.sql
START DbagrantIfsCamSys.sql
PROMPT
PROMPT Start deploying DbagrantIfsIamSys.sql
START DbagrantIfsIamSys.sql
PROMPT
PROMPT Start deploying DbagrantIfsCrtSys.sql
START DbagrantIfsCrtSys.sql
PROMPT
PROMPT Start deploying DbagrantIfsDbReadOnly.sql
START DbagrantIfsDbReadOnly.sql

PROMPT
PROMPT Start deploying CreateAuditPolicy.sql
START CreateAuditPolicy.sql

PROMPT
PROMPT Start deploying EnableEditions.sql
START EnableEditions.sql

PROMPT
PROMPT Start deploying PrepareForMultitenant.sql
START PrepareForMultitenant.sql

PROMPT
PROMPT Start deploying INSTALL_TEM_SYS
START InstallTem.cre
START InstallTem.api
START InstallTem.apy

PROMPT
PROMPT Start deploying IAL_OBJECT_SLAVE
START IalObjectSlave.api
START IalObjectSlave.apy

PROMPT
PROMPT Stop scheduler processes and background jobs running IAL_OBJECT_SLAVE methods
EXEC &APPLICATION_OWNER..Install_Tem_SYS.Disable_Ial_Scheduler_Proc__;

PROMPT
PROMPT Start deploying IalGrant.sql 
START IalGrant.sql

PROMPT
PROMPT Start scheduler processes and background jobs running IAL_OBJECT_SLAVE methods
EXEC &APPLICATION_OWNER..Install_Tem_SYS.Enable_Ial_Scheduler_Proc__;

PROMPT Start deploying CAMUNDA_INSTALL_SYS
START CamundaInstall.api
START CamundaInstall.apy

PROMPT
PROMPT Start deploying IfsCamSysGrant.sql
START IfsCamSysGrant.sql

PROMPT
PROMPT Start deploying SetInternalUserProfile.sql
START SetInternalUserProfile.sql

PROMPT
PROMPT Revoke objects from role PUBLIC
SPOOL OFF
SPOOL GrantToPublic.sql 

START PublicRevoke.sql

SPOOL prepare.log APPEND

PROMPT
PROMPT Start deploying RecompileInvalidSYSObjects.sql
START RecompileInvalidSYSObjects.sql

PROMPT
--PROMPT "Recompile invalid &APPLICATION_OWNER objects"
PROMPT Start deploying RecompileInvalidAppOwnerObjects.sql
START RecompileInvalidAppOwnerObjects.sql

PROMPT
PROMPT Resetting database...
PROMPT
PROMPT Enabling &APPLICATION_OWNER queues
EXEC &APPLICATION_OWNER..Install_Tem_SYS.Enable_All_Queues__;

PROMPT
PROMPT Create contexts
EXEC &APPLICATION_OWNER..Install_Tem_SYS.Create_Context__;

PROMPT
--PROMPT "Resetting Performance Analyzer synonyms and grants"
PROMPT Start deploying RefreshProfilerGrants.sql
START RefreshProfilerGrants.sql

SET SERVEROUTPUT OFF
SPOOL OFF

