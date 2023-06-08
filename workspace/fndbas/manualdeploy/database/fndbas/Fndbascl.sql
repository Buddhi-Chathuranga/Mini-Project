--------------------------------------------------------------------------------
--
--  File:         Fndbascl.sql
--
--  Component:    FNDBAS
--
--  Purpose:      Remove obsolete objects from previous versions. Only necessary
--                to run when upgrading, not when performing a fresh install.
--
--  Date    Sign  History
--  ------  ----  --------------------------------------------------------------
--  031017  ROOD  Created.
--  031118  ROOD  Added drop of column protection in report_category_tab.
--  040401  ROOD  Renamed file Fndbas310cl.sql -> Fndbascl.sql. Added drop of
--                objects in Agenda and obsolete objects in Plsql Access Provider.
--                Used Installation_SYS instead of own dynamic implementation.
--  040513  HAAR  Added drop of parameters in BatchSchedule and BatchScheduleMethod (F1PR419).
--  040707  ROOD  Added drop of columns in dictionary_sys-tables (F1PR413).
--  040813  HAAR  Removed column value_list in user_profile_sys_tab (Bug#43588).
--  040917  ROOD  Removed column lu_name from reference_sys_tab (F1PR413).
--  041026  ROOD  Removed objects for scheduled reports (F1PR419).
--  041117  HAAR  Removed column Description_NLS from Language_Code_Tab (F1PR413E).
--  041222  JORA  Removed column lu_name and fullmethod from security_sys_tab (Bug#48113)
--  050126  RAKU  Removed objects for CLIENT_ROLE, CLIENT_ROLE_RESTRICTION
--                and CLIENT_CATEGORY (F1PR484).
--  050321  RAKU  Added clean on CLIENT_PROFILE* objects (F1PR483).
--  050322  RAKU  Added clean on WEB_PROFILE objects (F1PR483).
--  060323  HAAR  Remove old PL/SQL Access Provider Java classes.
--  060530  HAAR  Remove LU MethodExecutor (F1PR447).
--  070314  HAAR  Added table Language_SYS_400 and Language_SYS_410.
--  070731  DUWI  Remove databse objects related to CLIENT_PROFILE_TAB and CLIENT_PROFILE_USER_TAB (Bug#64189).
--  110802  ASIWLK removed print_server_sys_tab
--  110906  SHAA  Remove fnddr_search*_tab tables (EADS-1776)
--  110921  MaBo  Remove DICTIONARY_SYS_ARGUMENT_OLD table (RDTERUNTIME-1076)
--  110921  MaBo  Remove removal of lu_name from reference_sys_tab (RDTERUNTIME-1091)
--  111020  MABO  Drop IFSMOBILITY user and FND_MOBILITY role (RDTERUNTIME-1330)
--  111031  HAAR  Remove removal of view Client_Profile (RDTERUNTIME-1427).
--  111122  HAAR  Remove WebProfile (RDTERUNTIME-1582).
--  120309  MADR  Remove unused tables in security cache (RDTERUNTIME-2239).
--  120411  CHDOLK Remove unused quick report permissions (RDTERUNTIME-1585).
--  130321  SHFRLK Remove columns TEXT1, TEXT2 and TEXT3 from XLR_LOG_TAB (RUB-667)
--  130820  HAAR  Remove Security Checkpoint IID (TENEV-30).
--  131219  SJayLK Removed entries correspond to BI objects
--  141110  MADRSE Removed tables not used by Batch Processor
--  141208  DOBESE Moved latest obsolete packages, indexes, sequences and views to 600.upg
--  160518  ANTRSE Removed drop of user IFSMOBILITY - STRTE-442
--------------------------------------------------------------------------------

SET SERVEROUT ON

PROMPT Drop obsolete tables from previous releases.

BEGIN
   -- 3.1.0
   Installation_SYS.Remove_Table('TRANSACTION_SYS_CONNECT_TAB', TRUE);
   Installation_SYS.Remove_Table('TRANSACTION_SYS_AREA_TAB', TRUE);
   Installation_SYS.Remove_Table('TRANSACTION_SYS_REMOTE_TAB', TRUE);
   Installation_SYS.Remove_Table('COMMAND_SYS_BUFFER_TAB', TRUE);
   Installation_SYS.Remove_Table('COMMAND_SYS_LOOKOUT_TAB', TRUE);
   Installation_SYS.Remove_Table('COMMAND_SYS_TAB', TRUE);
   Installation_SYS.Remove_Table('REPORT_LAYOUT_DEFINITION_TAB', TRUE);
   Installation_SYS.Remove_Table('USER_PROFILE_SYS_PROPERTY_TAB', TRUE);
   -- 4.0.0
   Installation_SYS.Remove_Table('AGENDA_TAB', TRUE);
   Installation_SYS.Remove_Table('AGENDA_DISTRIBUTION_TAB', TRUE);
   Installation_SYS.Remove_Table('AGENDA_LOG_TAB', TRUE);
   Installation_SYS.Remove_Table('AGENDA_REPORT_PARAMETER_TAB', TRUE);
   Installation_SYS.Remove_Table('AGENDA_REPORT_TAB', TRUE);
   Installation_SYS.Remove_Table('PLSQLAP_CORBA_ENVIRONMENT', TRUE);
   Installation_SYS.Remove_Table('PLSQLAP_ENVIRONMENT', TRUE);
   Installation_SYS.Remove_Table('OUT_MESSAGE_CLOB_TAB', TRUE);
   Installation_SYS.Remove_Table('SCHEDULED_REPORT_TAB', TRUE);
   Installation_SYS.Remove_Table('CLIENT_ROLE_RESTRICTION_TAB', TRUE);
   Installation_SYS.Remove_Table('CLIENT_ROLE_TAB', TRUE);
   Installation_SYS.Remove_Table('CLIENT_CATEGORY_TAB', TRUE);
   Installation_SYS.Remove_Table('LANGUAGE_SYS_400', TRUE);
   Installation_SYS.Remove_Table('CLIENT_PROFILE_TAB', TRUE);
   Installation_SYS.Remove_Table('CLIENT_PROFILE_USER_TAB', TRUE);

-- Old User Profiles MUST FIRST be converted by running the Admin.exe form
-- 'Installation/Profile Convert Tool'. Once the tables 'CLIENT_PROFILE_TAB' and
-- 'CLIENT_PROFILE_USER_TAB' are removed, the possibility to
-- convert old user profiles will be gone.

--   Installation_SYS.Remove_Table('CLIENT_PROFILE_TAB', TRUE);
--   Installation_SYS.Remove_Table('CLIENT_PROFILE_USER_TAB', TRUE);


-- Old Web Profiles MUST FIRST be converted by running a java converting tool.
-- Once the table 'WEB_PROFILE_TAB' is removed, the possibility to
-- convert old web profiles will be gone.

   Installation_SYS.Remove_Table('WEB_PROFILE_TAB', TRUE);
   -- 4.1.0
   Installation_SYS.Remove_Table('LANGUAGE_SYS_410', TRUE);
   Installation_SYS.Remove_Table('LANGUAGE_TERM_DICTIONARY_410', TRUE);
   Installation_SYS.Remove_Table('LANGUAGE_WORDBOOK_410', TRUE);
   Installation_SYS.Remove_Table('DICTIONARY_BASE_LANGUAGE_410', TRUE);
   Installation_SYS.Remove_Table('DICTIONARY_CONTEXT_410', TRUE);
   Installation_SYS.Remove_Table('DICTIONARY_OWNER_410', TRUE);
   Installation_SYS.Remove_Table('DICTIONARY_SOURCE_410', TRUE);

   -- 5.0.0
   Installation_SYS.Remove_Table('print_server_sys_tab', TRUE);
   Installation_SYS.Remove_Table('FNDDR_SEARCH_DOM_QRY_OBJ_TAB', TRUE);
   Installation_SYS.Remove_Table('FNDDR_SEARCH_DOMAIN_ASSOC_TAB', TRUE);
   Installation_SYS.Remove_Table('FNDDR_SEARCH_DOMAIN_ATTRIB_TAB', TRUE);
   Installation_SYS.Remove_Table('FNDDR_SEARCH_DOMAIN_OBJECT_TAB', TRUE);
   Installation_SYS.Remove_Table('FNDDR_SEARCH_DOMAIN_TAB', TRUE);
   Installation_SYS.Remove_Table('DICTIONARY_SYS_ARGUMENT_OLD', TRUE);

   Installation_SYS.Remove_Table('SEARCH_DOMAIN_ASSOCIATIONS_TAB',TRUE);
   Installation_SYS.Remove_Table('SEARCH_DOMAIN_ATTRIBUTE_TAB',TRUE);
   Installation_SYS.Remove_Table('SEARCH_DOMAIN_ENTITY_TAB',TRUE);
   Installation_SYS.Remove_Table('SEARCH_DOMAIN_TRIGGER_TAB',TRUE);
   Installation_SYS.Remove_Table('SEARCH_DOMAIN_QUERY_OBJECT_TAB',TRUE);

   Installation_SYS.Remove_Table('SECURITY_SYS_RPRIVS_COPY_TAB',TRUE);
   Installation_SYS.Remove_Table('SECURITY_SYS_ROLE_PRIVS_TAB',TRUE);
   Installation_SYS.Remove_Table('COMPONENT_MANAGER_500',TRUE);
   Installation_SYS.Remove_Table('FND_DEVELOPER_500',TRUE);
   Installation_SYS.Remove_Table('FND_LOG_500',TRUE);
   Installation_SYS.Remove_Table('FND_LOG_ACCESS_500',TRUE);
   Installation_SYS.Remove_Table('FND_LOG_PRIORITY_500',TRUE);
   Installation_SYS.Remove_Table('FND_LOG_TYPE_500',TRUE);
   Installation_SYS.Remove_Table('FND_RELEASE_500',TRUE);

   -- 6.0.0
   Installation_SYS.Remove_Table('REPORT_IN_PROGRESS_TMP', TRUE);
   Installation_SYS.Remove_Table('FND_SESSION_TAB', TRUE);
   Installation_SYS.Remove_Table('NOTE_OLD', TRUE);
   Installation_SYS.Remove_Table('NOTE_BOOK_OLD', TRUE);
   Installation_SYS.Remove_Table('FND_EVENT_MY_MESSAGES_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_HANDLER_METHOD_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_VIEW_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_VIEW_ATTRIBUTE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ENTITY_PKG_DIAGRAM_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ENTITY_DIAGRAM_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ENTITY_ATTRIBUTE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_STEREOTYPE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_STATE_DIAGRAM_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ACTIVITY_PKG_DIAG_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_MODULE_DIAGRAM_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_PLSQL_METHOD_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_PACKAGE_DIAGRAM_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_STORAGE_DIAGRAM_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_STORAGE_ATTRIBUTE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_MODEL_IMPORT_LOG_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_METHOD_PARAMETER_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_CLIENT_DIAGRAM_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ACTIVITY_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_FILTER_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ENTITY_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ENUMERATION_VALUE_OLD', TRUE);
   Installation_SYS.Remove_Table('WORKSPACE_OLD', TRUE);
   Installation_SYS.Remove_Table('NOTE_TAB', TRUE);
   Installation_SYS.Remove_Table('NOTE_BOOK_TAB', TRUE);
   Installation_SYS.Remove_Table('FNDBAS_MODEL_OBJECT_TAB', TRUE);
   Installation_SYS.Remove_Table('PRES_OBJECT_GRANT_DEFAULT_TAB', TRUE);
   Installation_SYS.Remove_Table('FNDCN_BACKGROUND_JOB_TAB', TRUE);
   Installation_SYS.Remove_Table('FNDCN_RECURRENCE_AGENDA_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDCN_RECURRENCE_PATTERN_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDCN_TARGET_OLD', TRUE);

   Installation_SYS.Remove_Table('FNDDR_MOBILE_CLIENT_PKG_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDMOB_ENTITY_SYNCH_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDMOB_OPTIMIZER_DATA_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDMOB_USER_CACHE_OLD', TRUE);

   Installation_SYS.Remove_Table('FNDDR_ACTIVITY_ENT_FILTR_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ACTIVITY_ENT_USAGE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ACTIVITY_PACKAGE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ATTR_STAT_VALIDATION_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ATTR_VALIDATION_RULE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_CLIENT_PACKAGE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_CLIENTPLUGIN_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_CLIENTPLUGIN_ACT_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_DETAIL_VALIDATION_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ENTITY_ASSOCIATION_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ENTITY_ASSO_ATTR_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ASSOC_STATE_VALID_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ENTITY_PACKAGE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_ENTITY_STATE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_FEATURE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_FEATURE_ACTIVITY_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_FEATURE_WIDGET_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_FILTER_PARAMETER_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_HANDLER_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_INDEX_COLUMN_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_J2EE_APPLICATION_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_J2EE_MODULE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_LOGICAL_UNIT_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_MAPPED_ENTITY_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_METHOD_FILTER_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_MODEL_WORKSPACE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_MODULE_DEPENDENCY_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_MODULE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_PACKAGE_DEPENDENCY_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_PARAMETER_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_PLSQL_PACKAGE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_PLSQL_PARAMETER_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_PROJECT_SETTING_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_REPORT_PARAMETER_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_REPORT_TEXT_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_SERVER_PACKAGE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_SERV_PKG_DEPENDENCY_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_STATE_EVENT_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_STORAGE_OBJECT_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_STORAGE_PACKAGE_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_TABLE_INDEX_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_VALIDATION_OBJECT_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_VIEW_ASSOCIATION_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_WIDGET_OLD', TRUE);
   Installation_SYS.Remove_Table('FNDDR_WIDGET_ACTIVITY_OLD', TRUE);
   Installation_SYS.Remove_Table('FND_TRANSLATION_600', TRUE);

   -- 7.0.0
   Installation_SYS.Remove_Table('FNDCN_CONFIG_PARAM_AREA_700', TRUE);
   Installation_SYS.Remove_Table('FNDCN_CONFIG_PARAM_GROUP_700', TRUE);
   Installation_SYS.Remove_Table('LDAP_DOMAIN_CONFIG_700',  TRUE);
   Installation_SYS.Remove_Table('LDAP_CONFIGURATION_700',  TRUE);
   Installation_SYS.Remove_Table('LDAP_MAPPING_700',  TRUE);
   Installation_SYS.Remove_Table('TERM_700', TRUE);
   Installation_SYS.Remove_Table('TERM_DOMAIN_700', TRUE);
   Installation_SYS.Remove_Table('TERM_HISTORY_700', TRUE);
   Installation_SYS.Remove_Table('TERM_OWNER_700', TRUE);
   Installation_SYS.Remove_Table('TERM_DEFINITION_HISTORY_700', TRUE);
   Installation_SYS.Remove_Table('TERM_ALERT_INDICATOR_700', TRUE);
   Installation_SYS.Remove_Table('TERM_TRANSLATED_DEFINITION_700', TRUE);
   Installation_SYS.Remove_Table('TERM_RELATION_700', TRUE);
   Installation_SYS.Remove_Table('TERM_USAGE_DEFINITION_700', TRUE);
   Installation_SYS.Remove_Table('TERM_OWNER_MODULE_700', TRUE);
   Installation_SYS.Remove_Table('TERM_TRANSLATED_NAME_700', TRUE);
   Installation_SYS.Remove_Table('TERM_STOP_LIST_700', TRUE);
   Installation_SYS.Remove_Table('TERM_USAGE_IDENTIFIER_700', TRUE);
   Installation_SYS.Remove_Table('ROWKEY_PREPARE_700', TRUE);
   Installation_SYS.Remove_Table('ROWKEY_PREPARE_OLD', TRUE);

   -- 12.1.0
   Installation_SYS.Remove_Table('ORACLE_ACCOUNT_2110', TRUE);
   Installation_SYS.Remove_Table('FND_PROJ_COMPATIBILITY_2110', TRUE);
   Installation_SYS.Remove_Table('SEARCH_DOMAIN_DOCUMENT_2110', TRUE);
   Installation_SYS.Remove_Table('SEARCH_DOMAIN_GROUP_MEMBER_2110', TRUE);
   Installation_SYS.Remove_Table('SEARCH_DOMAIN_GROUP_2110', TRUE);
   Installation_SYS.Remove_Table('SEARCH_DOMAIN_RUNTIME_2110', TRUE);
   Installation_SYS.Remove_Table('SEARCH_DOMAIN_UNSYNCHED_2110', TRUE);
END;
/

PROMPT Drop obsolete indexes from previous releases.

BEGIN
   -- 3.1.0
   Installation_SYS.Remove_Indexes('PLSQLAP_BUFFER_TMP', 'IND1_PLSQLAP_BUFFER_TMP', TRUE);
   -- 6.0.0
   -- Moved to upg-file
END;
/

PROMPT Drop obsolete table columns from previous releases.

DECLARE
   column_  Installation_SYS.ColRec;
BEGIN
   -- 3.1.0

   column_ := Installation_SYS.Set_Column_Values ('METHOD');
   Installation_SYS.Alter_Table_Column('BATCH_SCHEDULE_TAB', 'DROP COLUMN', column_, TRUE);
   column_ := Installation_SYS.Set_Column_Values ('SINGLE_EXECUTION');
   Installation_SYS.Alter_Table_Column('BATCH_SCHEDULE_TAB', 'DROP COLUMN', column_, TRUE);

   column_ := Installation_SYS.Set_Column_Values ('PROCEDURE_TYPE');
   Installation_SYS.Alter_Table_Column('TRANSACTION_SYS_LOCAL_TAB', 'DROP COLUMN', column_, TRUE);

   column_ := Installation_SYS.Set_Column_Values ('PROTECTION');
   Installation_SYS.Alter_Table_Column('REPORT_CATEGORY_TAB', 'DROP COLUMN', column_, TRUE);
   -- 4.0.0
   column_ := Installation_SYS.Set_Column_Values ('PARAMETERS');
   Installation_SYS.Alter_Table_Column('BATCH_SCHEDULE_TAB', 'DROP COLUMN', column_, TRUE);
   column_ := Installation_SYS.Set_Column_Values ('PARAMETERS');
   Installation_SYS.Alter_Table_Column('BATCH_SCHEDULE_METHOD_TAB', 'DROP COLUMN', column_, TRUE);

   column_ := Installation_SYS.Set_Column_Values ('PARENT');
   Installation_SYS.Alter_Table_Column('DICTIONARY_SYS_TAB', 'DROP COLUMN', column_, TRUE);
   column_ := Installation_SYS.Set_Column_Values ('VIEW_LIST');
   Installation_SYS.Alter_Table_Column('DICTIONARY_SYS_TAB', 'DROP COLUMN', column_, TRUE);
   column_ := Installation_SYS.Set_Column_Values ('PACKAGE_LIST');
   Installation_SYS.Alter_Table_Column('DICTIONARY_SYS_TAB', 'DROP COLUMN', column_, TRUE);
   column_ := Installation_SYS.Set_Column_Values ('METHOD_LIST');
   Installation_SYS.Alter_Table_Column('DICTIONARY_SYS_TAB', 'DROP COLUMN', column_, TRUE);
   column_ := Installation_SYS.Set_Column_Values ('METHOD_LIST2');
   Installation_SYS.Alter_Table_Column('DICTIONARY_SYS_TAB', 'DROP COLUMN', column_, TRUE);
   column_ := Installation_SYS.Set_Column_Values ('TIMESTAMP');
   Installation_SYS.Alter_Table_Column('DICTIONARY_SYS_TAB', 'DROP COLUMN', column_, TRUE);

   column_ := Installation_SYS.Set_Column_Values ('IND');
   Installation_SYS.Alter_Table_Column('DICTIONARY_SYS_PACKAGE_TAB', 'DROP COLUMN', column_, TRUE);

   column_ := Installation_SYS.Set_Column_Values ('METHOD');
   Installation_SYS.Alter_Table_Column('DICTIONARY_SYS_METHOD_TAB', 'DROP COLUMN', column_, TRUE);
   column_ := Installation_SYS.Set_Column_Values ('TYPE');
   Installation_SYS.Alter_Table_Column('DICTIONARY_SYS_METHOD_TAB', 'DROP COLUMN', column_, TRUE);

   column_ := Installation_SYS.Set_Column_Values ('VALUE_LIST');
   Installation_SYS.Alter_Table_Column('USER_PROFILE_SYS_TAB', 'DROP COLUMN', column_, TRUE);

   column_ := Installation_SYS.Set_Column_Values ('DESCRIPTION_NLS');
   Installation_SYS.Alter_Table_Column('LANGUAGE_CODE_TAB', 'DROP COLUMN', column_, TRUE);

   column_ := Installation_SYS.Set_Column_Values ('LU_NAME');
   Installation_SYS.Alter_Table_Column('SECURITY_SYS_TAB', 'DROP COLUMN', column_, TRUE);
   column_ := Installation_SYS.Set_Column_Values ('FULLMETHOD');
   Installation_SYS.Alter_Table_Column('SECURITY_SYS_TAB', 'DROP COLUMN', column_, TRUE);
   -- 5.0.0
   column_ := Installation_SYS.Set_Column_Values('ENTITY_NAME', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('SEARCH_DOMAIN_RUNTIME_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('FROM_STMT', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('SEARCH_DOMAIN_RUNTIME_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('INDEX_COLUMN_NAME', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('SEARCH_DOMAIN_RUNTIME_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('INDEX_NAME', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('SEARCH_DOMAIN_RUNTIME_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('STORAGE_OBJECT_NAME', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('SEARCH_DOMAIN_RUNTIME_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('TABLE_NAME', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('SEARCH_DOMAIN_RUNTIME_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('TERM_ID', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('SEARCH_DOMAIN_RUNTIME_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('DISPLAY_TYPE', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('SEARCH_DOMAIN_RUNTIME_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('TITLE', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('SEARCH_DOMAIN_RUNTIME_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('USAGE_ID', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('SEARCH_DOMAIN_RUNTIME_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('WHERE_STMT', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('SEARCH_DOMAIN_RUNTIME_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('SYNCHRONIZE_ONGOING', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('SEARCH_DOMAIN_RUNTIME_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   -- 6.0.0
   column_ := Installation_SYS.Set_Column_Values('PRINTED', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('PRINT_JOB_CONTENTS_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('FROM_MODULE', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('PRES_OBJECT_DEPENDENCY_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('PRES_OBJECT_SEQ', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('PRES_OBJECT_DEPENDENCY_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('FROM_MODULE', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('PRES_OBJECT_DEP_CHANGE_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('MODULE', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('PRES_OBJECT_DEPENDENCY_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('PRES_OBJECT_SEQ', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('PRES_OBJECT_DEP_CHANGE_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('MODULE', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('PRES_OBJECT_DEP_CHANGE_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('SOURCE_AREA', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('TRANSACTION_SYS_LOCAL_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('SOURCE_ID', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('TRANSACTION_SYS_LOCAL_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('LENGTH', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('BINARY_OBJECT_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('STATUS_TEXT', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('CUSTOM_MENU_TEXT_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('TRANSFORMER_2', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('FNDCN_ROUTE_ADDRESS_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('RESPONSE_TRANSFORMER_2', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('FNDCN_ROUTE_ADDRESS_TAB', 'D', column_);
   Installation_SYS.Reset_Column(column_);

   -- 7.0.0
   column_ := Installation_SYS.Set_Column_Values('ORDINAL', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('FNDCN_CONFIG_PARAM_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('PARAMETER_TYPE', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('FNDCN_CONFIG_PARAM_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('VALUE_LIST', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('FNDCN_CONFIG_PARAM_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('HELP_TEXT', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('FNDCN_CONFIG_PARAM_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('WRITE_PROTECTED', NULL, 'Y');
   Installation_SYS.Alter_Table_Column('FNDCN_CONFIG_PARAM_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('TERM_USAGE_VERSION_ID');
   Installation_SYS.Alter_Table_Column('LANGUAGE_ATTRIBUTE_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('NO_TERM_CONNECTION');
   Installation_SYS.Alter_Table_Column('LANGUAGE_ATTRIBUTE_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('TERM_VERSION_HANDLE_ID');
   Installation_SYS.Alter_Table_Column('FND_OBJ_SUBSCRIP_COLUMN_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('TERM_DISPLAY_TYPE');
   Installation_SYS.Alter_Table_Column('FND_OBJ_SUBSCRIP_COLUMN_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('PROG_TEXT');
   Installation_SYS.Alter_Table_Column('LANGUAGE_TRANSLATION_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('ROWKEY_700');
   Installation_SYS.Alter_Table_Column('FNDRR_CLIENT_PROFILE_VALUE_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('ROWKEY_700');
   Installation_SYS.Alter_Table_Column('HISTORY_LOG_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('ROWKEY_700');
   Installation_SYS.Alter_Table_Column('HISTORY_LOG_ATTRIBUTE_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('ROWKEY_700');
   Installation_SYS.Alter_Table_Column('LANGUAGE_FILE_EXPORT_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('ROWKEY_700');
   Installation_SYS.Alter_Table_Column('LANGUAGE_FILE_IMPORT_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('ROWKEY_700');
   Installation_SYS.Alter_Table_Column('LANGUAGE_TRANSLATION_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('ROWKEY_700');
   Installation_SYS.Alter_Table_Column('REPLICATION_LOG_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('ROWKEY_700');
   Installation_SYS.Alter_Table_Column('SERVER_LOG_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('TERM_USAGE_VERSION_ID');
   Installation_SYS.Alter_Table_Column('LANGUAGE_SYS_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('TEXT_ID$');
   Installation_SYS.Alter_Table_Column('FNDRR_CLIENT_PROFILE_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);
   
   column_ := Installation_SYS.Set_Column_Values('TRANSFORMER_2');
   Installation_SYS.Alter_Table_Column('FNDCN_ADDRESS_LABEL_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);

   column_ := Installation_SYS.Set_Column_Values('RESPONSE_TRANSFORMER_2');
   Installation_SYS.Alter_Table_Column('FNDCN_ADDRESS_LABEL_TAB', 'D', column_, TRUE);
   Installation_SYS.Reset_Column(column_);

END;
/

PROMPT Drop obsolete views from previous releases.

BEGIN
   -- 3.1.0
   Installation_SYS.Remove_View('FND_ORA_ROLE_LOV', TRUE);
   -- 4.0.0
   Installation_SYS.Remove_View('AGENDA', TRUE);
   Installation_SYS.Remove_View('AGENDA_DISTRIBUTION', TRUE);
   Installation_SYS.Remove_View('AGENDA_LOG', TRUE);
   Installation_SYS.Remove_View('AGENDA_REPORT', TRUE);
   Installation_SYS.Remove_View('AGENDA_REPORT_PARAMETER', TRUE);
   Installation_SYS.Remove_View('OUT_MESSAGE_CLOB', TRUE);
   Installation_SYS.Remove_View('SCHEDULED_REPORT', TRUE);
   Installation_SYS.Remove_View('CLIENT_ROLE_RESTRICTION', TRUE);
   Installation_SYS.Remove_View('CLIENT_ROLE', TRUE);
   Installation_SYS.Remove_View('CLIENT_CATEGORY', TRUE);
   -- 5.0.0
   Installation_SYS.Remove_View('PRINT_SERVER', TRUE);
   Installation_SYS.Remove_View('PRES_OBJECT_SECURITY_LOV', TRUE);
   Installation_SYS.Remove_View('SEARCH_DOMAIN_ASSOCIATIONS');
   Installation_SYS.Remove_View('SEARCH_DOMAIN_ATTRIBUTE');
   Installation_SYS.Remove_View('SEARCH_DOMAIN_ENTITY');
   Installation_SYS.Remove_View('SEARCH_DOMAIN_TRIGGER');
   Installation_SYS.Remove_View('SEARCH_DOMAIN_QUERY_OBJECT');

-- Old User Profiles MUST FIRST be converted by running the Admin.exe form
-- 'Installation/Profile Convert Tool'. Once the view 'CLIENT_PROFILE' is removed, the possibility to
-- convert old user profiles will be gone.

--   Installation_SYS.Remove_View('CLIENT_PROFILE', TRUE);
   Installation_SYS.Remove_View('CLIENT_PROFILE_USER', TRUE);

-- Old Web Profiles MUST FIRST be converted by running a java converting tool.
-- Once the view 'WEB_PROFILE' is removed, the possibility to
-- convert old web profiles will be gone.

   Installation_SYS.Remove_View('WEB_PROFILE', TRUE);

   -- 6.0.0
   -- Moved to upg-file

END;
/

PROMPT Drop obsolete sequences from previous releases.

BEGIN
   -- 3.1.0
   Installation_SYS.Remove_Sequence('COMMAND_SYS_BUFFER_SEQ', TRUE);
   Installation_SYS.Remove_Sequence('COMMAND_SYS_SEQ', TRUE);
   -- 4.0.0
   Installation_SYS.Remove_Sequence('AGENDA_SEQ', TRUE);
   -- 5.0.0
   Installation_SYS.Remove_Sequence('FND_LOG_SQL', TRUE);
   -- 6.0.0
   -- Moved to upg-file
END;
/

PROMPT Drop obsolete packages from previous releases.

BEGIN
   -- 3.1.0
   Installation_SYS.Remove_Package('Web_User_SYS', TRUE);
   Installation_SYS.Remove_Package('Report_Definition2_API', TRUE);
   Installation_SYS.Remove_Package('Report_Category_Prot_API', TRUE);
   -- 4.0.0
   Installation_SYS.Remove_Package('Agenda_Distribution_API', TRUE);
   Installation_SYS.Remove_Package('Agenda_Log_API', TRUE);
   Installation_SYS.Remove_Package('Agenda_Log_Status_API', TRUE);
   Installation_SYS.Remove_Package('Agenda_Report_API', TRUE);
   Installation_SYS.Remove_Package('Agenda_Report_Parameter_API', TRUE);
   Installation_SYS.Remove_Package('Agenda_Status_API', TRUE);
   Installation_SYS.Remove_Package('Out_Message_Clob_API', TRUE);
   Installation_SYS.Remove_Package('Scheduled_Report_API', TRUE);
   Installation_SYS.Remove_Package('Client_Role_Restriction_API', TRUE);
   Installation_SYS.Remove_Package('Client_Role_API', TRUE);
   Installation_SYS.Remove_Package('Client_Category_API', TRUE);
   Installation_SYS.Remove_Package('Method_Executor_API', TRUE);
   -- 5.0.0
   Installation_SYS.Remove_Package('print_server_sys', TRUE);
   Installation_SYS.Remove_Package('SEARCH_DOMAIN_ASSOCIATIONS_API');
   Installation_SYS.Remove_Package('SEARCH_DOMAIN_ATTRIBUTE_API');
   Installation_SYS.Remove_Package('SEARCH_DOMAIN_ENTITY_API');
   Installation_SYS.Remove_Package('SEARCH_DOMAIN_TRIGGER_API');
   Installation_SYS.Remove_Package('SEARCH_DOMAIN_QUERY_OBJECT_API');

   -- 6.0.0
   -- Moved to upg-file
END;
/

PROMPT Drop obsolete Java classes from previous releases.

DECLARE
   TYPE ObjectNames   IS TABLE OF VARCHAR2(1000);
   javaClasses        ObjectNames;
   javaResources      ObjectNames;
   stmt_              VARCHAR2(2000);
   msg_               VARCHAR2(200);
   object_not_found_  EXCEPTION;
   PRAGMA EXCEPTION_INIT(object_not_found_, -04043);
BEGIN
   javaClasses := ObjectNames(
      'ifs/fnd/buffer/BufferFormatException',
      'ifs/fnd/buffer/StandardBufferIterator',
      'ifs/fnd/service/InterruptFndException',
      'ifs/fnd/util/PreparedString$Variable',
      'ifs/fnd/buffer/StandardBufferFormatter',
      'ifs/fnd/buffer/ItemNotFoundException',
      'ifs/fnd/util/AttributeNotFoundException',
      'ifs/fnd/buffer/UnsupportedOperationException',
      'ifs/fnd/buffer/SynchronizedStandardBufferIterator',
      'ifs/fnd/util/EndOfStreamException',
      'ifs/fnd/buffer/StandardBufferParsingTask',
      'ifs/fnd/buffer/StandardTokenWriter',
      'ifs/fnd/buffer/SynchronizedStandardBuffer',
      'ifs/fnd/buffer/StandardBufferFormattingTask',
      'ifs/fnd/service/SQLRecognizer$SQLProcedure',
      'ifs/fnd/service/SQLRecognizer$Keyword',
      'ifs/fnd/buffer/BooleanFormatter',
      'ifs/fnd/util/InvalidMessageFormatException',
      'ifs/fnd/buffer/StandardTokenReader',
      'ifs/fnd/service/FndException$OraError',
      'ifs/fnd/os/unix/NativeUtilities',
      'ifs/fnd/service/StandardFactory',
      'ifs/fnd/buffer/AutoString',
      'ifs/fnd/buffer/Buffer',
      'ifs/fnd/buffer/BufferFormatter',
      'ifs/fnd/buffer/BufferIterator',
      'ifs/fnd/buffer/Bufferable',
      'ifs/fnd/buffer/Buffers',
      'ifs/fnd/buffer/DataFormatter',
      'ifs/fnd/buffer/DateFormatter',
      'ifs/fnd/buffer/Item',
      'ifs/fnd/buffer/ItemComparator',
      'ifs/fnd/buffer/NumberFormatter',
      'ifs/fnd/buffer/RowComparator',
      'ifs/fnd/buffer/ServerFormatter',
      'ifs/fnd/buffer/StandardBuffer',
      'ifs/fnd/buffer/StringFormatter',
      'ifs/fnd/buffer/TaskRequestor',
      'ifs/fnd/os/NativeUtilities',
      'ifs/fnd/os/OSInfo',
      'ifs/fnd/os/ms/NativeUtilities',
      'ifs/fnd/service/CellPhone',
      'ifs/fnd/service/DebugInfo',
      'ifs/fnd/service/Factory',
      'ifs/fnd/service/FndException',
      'ifs/fnd/service/FndException$1',
      'ifs/fnd/service/IfsNames',
      'ifs/fnd/service/LogOutput',
      'ifs/fnd/service/SQLRecognizer',
      'ifs/fnd/service/SQLTokenizer',
      'ifs/fnd/service/TraceEvent',
      'ifs/fnd/service/TraceEventType',
      'ifs/fnd/service/Util',
      'ifs/fnd/util/Attribute',
      'ifs/fnd/util/Base64',
      'ifs/fnd/util/Log',
      'ifs/fnd/util/Message',
      'ifs/fnd/util/ObjectHolder',
      'ifs/fnd/util/Packable',
      'ifs/fnd/util/PackedObject',
      'ifs/fnd/util/PreparedString',
      'ifs/fnd/util/QuotedPrintable',
      'ifs/fnd/util/Str',
      'ifs/fnd/util/StreamWriter',
      'ifs/fnd/util/Time',
      'PlsqlAccessProvider');
   javaResources := ObjectNames(
      'META-INF/MANIFEST.MF');

   FOR i IN javaClasses.FIRST..javaClasses.LAST LOOP
      stmt_ := 'DROP JAVA CLASS "' || javaClasses(i) || '"';
      BEGIN
         EXECUTE IMMEDIATE(stmt_);
         dbms_output.put_line(stmt_ || '...OK');
      EXCEPTION
         WHEN object_not_found_ THEN
            NULL;
         WHEN OTHERS THEN
            msg_ := SUBSTR(SQLERRM,1,200);
            dbms_output.put_line(stmt_ || '...FAILED; ' || msg_);
      END;
   END LOOP;
   FOR i IN javaResources.FIRST..javaResources.LAST LOOP
      stmt_ := 'DROP JAVA RESOURCE "' || javaResources(i) || '"';
      BEGIN
         EXECUTE IMMEDIATE(stmt_);
         dbms_output.put_line(stmt_ || '...OK');
      EXCEPTION
         WHEN object_not_found_ THEN
            NULL;
         WHEN OTHERS THEN
            msg_ := SUBSTR(SQLERRM,1,200);
            dbms_output.put_line(stmt_ || '...FAILED; ' || msg_);
      END;
   END LOOP;
END;
/


PROMPT Drop obsolete roles from previous releases.

DECLARE
   role_       VARCHAR2(30);
BEGIN
   -- 5.0.0
   role_ := 'FND_MOBILITY';
   IF Fnd_Role_API.Exists(role_) THEN
      UPDATE fnd_event_action_tab
      SET role = NULL
      WHERE role = role_;
      COMMIT;
      Security_SYS.Drop_Role(role_);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      Dbms_Output.Put_Line('Error droping role ' || role_);
      Dbms_Output.Put_Line(SUBSTR(SQLERRM,1,200));
END;
/

PROMPT Drop obsolete users from previous releases.

PROMPT Drop obsolete quick reports from previous releases.

DECLARE
   cursor get_dep_reports is
     select quick_report_id,
          po_id
     from quick_report_tab
     where description in (
          'Available Tablespaces',
          'Foundation1 User Roles',
          'Illegal Foundation1 Users');

BEGIN

  FOR rec_ IN get_dep_reports
  LOOP
    -- deleting quick reports from pres object table
    delete from pres_object_tab
    where po_id = rec_.po_id;

    -- deleting quick reports from pres object grant table
    delete from pres_object_grant_tab
    where po_id = rec_.po_id;

    -- deleting quick reports from quick reports table
    delete from quick_report_tab
    where quick_report_id =rec_.quick_report_id;

  END LOOP;
END;
/


PROMPT Drop obsolete events from previous releases.

BEGIN
   -- 6.0.0
   Event_SYS.Disable_Event('General', 'CU_WARNING');
END;
/

PROMPT ---------------------------------------------------
PROMPT Drop of obsolete objects in FNDBAS done!
PROMPT ---------------------------------------------------

