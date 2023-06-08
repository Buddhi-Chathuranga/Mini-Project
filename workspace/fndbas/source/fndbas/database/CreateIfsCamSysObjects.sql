SET SERVEROUTPUT ON

--
--                 IFS Research & Development
--
--  This program is protected by copyright law and by international
--  conventions. All licensing, renting, lending or copying (including
--  for private use), and all other use of the program, which is not
--  expressively permitted by IFS Research & Development (IFS), is a
--  violation of the rights of IFS. Such violations will be reported to the
--  appropriate authorities.
--
--  VIOLATIONS OF ANY COPYRIGHT IS PUNISHABLE BY LAW AND CAN LEAD
--  TO UP TO TWO YEARS OF IMPRISONMENT AND LIABILITY TO PAY DAMAGES.
--
-- ------------------------------------------------------------------------------
-- Copyright Camunda Services GmbH and/or licensed to Camunda Services GmbH
-- under one or more contributor license agreements. See the NOTICE file
-- distributed with this work for additional information regarding copyright
-- ownership. Camunda licenses this file to you under the Apache License,
-- Version 2.0; you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

PROMPT Creating/Upgrading IfsCamSys (Camunda) Schema Objects

DEFINE CAMUNDA_APPOWNER         = IFSCAMSYS

-- Drop functional indices to enable column changes
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_UNIQ_AUTH_USER';
   table_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION';
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Remove_Indexes(table_name_, index_name_);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_UNIQ_AUTH_GROUP';
   table_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION';
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Remove_Indexes(table_name_, index_name_);
END;
/

-- Start of schema from oracle_engine.sql

DECLARE
   table_name_ VARCHAR2(30) := 'ACT_GE_PROPERTY';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VALUE_', 'NVARCHAR2(300)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_GE_PROPERTY_PK';
   table_name_ VARCHAR2(30) := 'ACT_GE_PROPERTY';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_GE_BYTEARRAY';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEPLOYMENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GENERATED_', 'NUMBER(1)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('BYTES_', 'BLOB', 'Y', NULL, 'LOB (BYTES_) STORE AS (TABLESPACE &IFSAPP_LOB CHUNK 4096 ENABLE STORAGE IN ROW)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Add_Lob_Column(table_name_, column_, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_GE_BYTEARRAY_PK';
   table_name_ VARCHAR2(30) := 'ACT_GE_BYTEARRAY';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_GE_SCHEMA_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIMESTAMP_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VERSION_', 'NVARCHAR2(255)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_GE_SCHEMA_LOG_PK';
   table_name_ VARCHAR2(30) := 'ACT_GE_SCHEMA_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RE_DEPLOYMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEPLOY_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SOURCE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RE_DEPLOYMENT_PK';
   table_name_ VARCHAR2(30) := 'ACT_RE_DEPLOYMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BUSINESS_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PARENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUPER_EXEC_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUPER_CASE_EXEC_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'IS_ACTIVE_', 'NUMBER(1)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'IS_CONCURRENT_', 'NUMBER(1)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'IS_SCOPE_', 'NUMBER(1)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'IS_EVENT_SCOPE_', 'NUMBER(1)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUSPENSION_STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CACHED_ENT_STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SEQUENCE_COUNTER_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'LOCK_EXP_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'LOCK_OWNER_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXCLUSIVE_', 'NUMBER(1)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROCESS_INSTANCE_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROCESS_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROCESS_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RETRIES_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXCEPTION_STACK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXCEPTION_MSG_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DUEDATE_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REPEAT_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'HANDLER_TYPE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'HANDLER_CFG_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEPLOYMENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUSPENSION_STATE_', 'NUMBER(38)', 'N', 1);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PRIORITY_', 'NUMBER(19)', 'N', 0);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SEQUENCE_COUNTER_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_JOB_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_JOBDEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_TYPE_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_CONFIGURATION_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUSPENSION_STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_PRIORITY_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_JOBDEF_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOBDEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RE_PROCDEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CATEGORY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'KEY_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VERSION_', 'NUMBER(38)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEPLOYMENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RESOURCE_NAME_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DGRM_RESOURCE_NAME_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'HAS_START_FORM_KEY_', 'NUMBER(1)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUSPENSION_STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VERSION_TAG_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'HISTORY_TTL_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'STARTABLE_', 'NUMBER(1)', 'N', 1);

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RE_PROCDEF_PK';
   table_name_ VARCHAR2(30) := 'ACT_RE_PROCDEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PARENT_TASK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DESCRIPTION_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'OWNER_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ASSIGNEE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DELEGATION_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PRIORITY_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DUE_DATE_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'FOLLOW_UP_DATE_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUSPENSION_STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_TASK_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_IDENTITYLINK_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BYTEARRAY_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DOUBLE_', 'NUMBER(*,10)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'LONG_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TEXT_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TEXT2_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VAR_SCOPE_', 'NVARCHAR2(64)','N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SEQUENCE_COUNTER_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'IS_CONCURRENT_LOCAL_', 'NUMBER(1)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_EVENT_SUBSCR';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EVENT_TYPE_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EVENT_NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACTIVITY_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CONFIGURATION_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATED_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_EVENT_SUBSCR_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_EVENT_SUBSCR';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'INCIDENT_TIMESTAMP_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'INCIDENT_MSG_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'INCIDENT_TYPE_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACTIVITY_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CAUSE_INCIDENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_CAUSE_INCIDENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CONFIGURATION_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DEF_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NUMBER(38)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RESOURCE_TYPE_', 'NUMBER(38)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RESOURCE_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PERMS_', 'NUMBER(38)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_FILTER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RESOURCE_TYPE_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'OWNER_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);

   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('QUERY_', 'NCLOB', 'N', NULL, 'LOB (QUERY_) STORE AS (TABLESPACE &IFSAPP_LOB CHUNK 4096 ENABLE STORAGE IN ROW)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Add_Lob_Column(table_name_, column_, TRUE);
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('PROPERTIES_', 'NCLOB', 'Y', NULL, 'LOB (PROPERTIES_) STORE AS (TABLESPACE &IFSAPP_LOB CHUNK 4096 ENABLE STORAGE IN ROW)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Add_Lob_Column(table_name_, column_, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_FILTER_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_FILTER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_METER_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REPORTER_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VALUE_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIMESTAMP_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'MILLISECONDS_', 'NUMBER(19)', 'N', 0);

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_METER_LOG_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_METER_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_EXT_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'WORKER_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TOPIC_NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RETRIES_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ERROR_MSG_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ERROR_DETAILS_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'LOCK_EXP_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUSPENSION_STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PRIORITY_', 'NUMBER(19)', 'N', 0);

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_EXT_TASK_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXT_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_BATCH';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TOTAL_JOBS_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOBS_CREATED_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOBS_PER_SEED_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'INVOCATIONS_PER_JOB_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SEED_JOB_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BATCH_JOB_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'MONITOR_JOB_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUSPENSION_STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CONFIGURATION_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_USER_ID_', 'NVARCHAR2(255)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_BATCH_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_BATCH';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EXE_ROOT_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EXEC_BUSKEY';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BUSINESS_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EXEC_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TASK_CREATE';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TASK_ASSIGNEE';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ASSIGNEE_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TASK_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_IDENT_LNK_USER';
   table_name_ VARCHAR2(30) := 'ACT_RU_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_IDENT_LNK_GROUP';
   table_name_ VARCHAR2(30) := 'ACT_RU_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EVENT_SUBSCR_CONFIG_';
   table_name_ VARCHAR2(30) := 'ACT_RU_EVENT_SUBSCR';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CONFIGURATION_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EVENT_SUBSCR_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_EVENT_SUBSCR';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_VARIABLE_TASK_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_VARIABLE_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_INC_CONFIGURATION';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CONFIGURATION_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_INC_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_JOB_EXECUTION_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_JOB_HANDLER';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'HANDLER_TYPE_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'HANDLER_CFG_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_JOB_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROCESS_INSTANCE_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_JOB_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_JOBDEF_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOBDEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_METER_LOG_MS';
   table_name_ VARCHAR2(30) := 'ACT_RU_METER_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'MILLISECONDS_'); 
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_METER_LOG_NAME_MS';
   table_name_ VARCHAR2(30) := 'ACT_RU_METER_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'MILLISECONDS_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_METER_LOG_REPORT';
   table_name_ VARCHAR2(30) := 'ACT_RU_METER_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REPORTER_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'MILLISECONDS_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_METER_LOG_TIME';
   table_name_ VARCHAR2(30) := 'ACT_RU_METER_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIMESTAMP_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_METER_LOG';
   table_name_ VARCHAR2(30) := 'ACT_RU_METER_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIMESTAMP_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EXT_TASK_TOPIC';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXT_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TOPIC_NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EXT_TASK_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXT_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EXT_TASK_PRIORITY';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXT_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PRIORITY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EXT_TASK_ERR_DETAILS';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXT_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ERROR_DETAILS_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_AUTH_GROUP_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_JOB_JOB_DEF_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_BYTEAR_DEPL';
   table_name_ VARCHAR2(30) := 'ACT_GE_BYTEARRAY';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEPLOYMENT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_BYTEARR_DEPL';
   table_name_ VARCHAR2(30) := 'ACT_GE_BYTEARRAY';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEPLOYMENT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RE_DEPLOYMENT (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EXE_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_EXE_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EXE_PARENT';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PARENT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_EXE_PARENT';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PARENT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EXE_SUPER';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUPER_EXEC_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_EXE_SUPER';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUPER_EXEC_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EXE_PROCDEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_EXE_PROCDEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RE_PROCDEF (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TSKASS_TASK';
   table_name_ VARCHAR2(30) := 'ACT_RU_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_TSKASS_TASK';
   table_name_ VARCHAR2(30) := 'ACT_RU_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_TASK (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_ATHRZ_PROCEDEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_ATHRZ_PROCEDEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RE_PROCDEF (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TASK_EXEC';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_TASK_EXE';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TASK_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_TASK_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TASK_PROCDEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_TASK_PROCDEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RE_PROCDEF (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_VAR_EXE';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_VAR_EXE';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_VAR_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_VAR_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_VAR_BYTEARRAY';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BYTEARRAY_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_VAR_BYTEARRAY';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BYTEARRAY_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_GE_BYTEARRAY (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_JOB_EXCEPTION';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXCEPTION_STACK_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_JOB_EXCEPTION';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXCEPTION_STACK_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_GE_BYTEARRAY (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EVENT_SUBSCR';
   table_name_ VARCHAR2(30) := 'ACT_RU_EVENT_SUBSCR';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_EVENT_EXEC';
   table_name_ VARCHAR2(30) := 'ACT_RU_EVENT_SUBSCR';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_EXECUTION (ID_)');
END;
/

DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_INC_EXE';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_EXECUTION (ID_)');
END;
/

DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_INC_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_EXECUTION (ID_)');
END;
/

DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_INC_PROCDEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RE_PROCDEF (ID_)');
END;
/

DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_INC_CAUSE';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CAUSE_INCIDENT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_INCIDENT (ID_)');
END;
/

DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_INC_RCAUSE';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_CAUSE_INCIDENT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_INCIDENT (ID_)');
END;
/

DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_EXT_TASK_ERROR_DETAILS';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXT_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ERROR_DETAILS_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_GE_BYTEARRAY (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_INC_JOB_DEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_INC_JOB_DEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_JOBDEF (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_UNIQ_AUTH_USER';
   table_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'case when "USER_ID_" is null then null else "TYPE_" end');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'case when "USER_ID_" is null then null else "RESOURCE_TYPE_" end');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'case when "USER_ID_" is null then null else "RESOURCE_ID_" end');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'case when "USER_ID_" is null then null else "USER_ID_" end');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'U', '&IFSAPP_INDEX', NULL, TRUE, TRUE, expression_ => TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_UNIQ_AUTH_GROUP';
   table_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'case when "GROUP_ID_" is null then null else "TYPE_" end');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'case when "GROUP_ID_" is null then null else "RESOURCE_TYPE_" end');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'case when "GROUP_ID_" is null then null else "RESOURCE_ID_" end');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'case when "GROUP_ID_" is null then null else "GROUP_ID_" end');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'U', '&IFSAPP_INDEX', NULL, TRUE, TRUE, expression_ => TRUE);
END;
/

DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_UNIQ_VARIABLE';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VAR_SCOPE_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'U', NULL, NULL, TRUE, TRUE, FALSE);
END;
/

DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_EXT_TASK_EXE';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXT_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_BATCH_SEED_JOB_DEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_BATCH';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SEED_JOB_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_BATCH_SEED_JOB_DEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_BATCH';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SEED_JOB_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_JOBDEF (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_BATCH_MONITOR_JOB_DEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_BATCH';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'MONITOR_JOB_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_BATCH_MONITOR_JOB_DEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_BATCH';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'MONITOR_JOB_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_JOBDEF (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_BATCH_JOB_DEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_BATCH';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BATCH_JOB_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_BATCH_JOB_DEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_BATCH';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BATCH_JOB_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_JOBDEF (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_INC_CAUSEINCID';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CAUSE_INCIDENT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_INC_EXID';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_INC_PROCDEFID';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_INC_PROCINSTID';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_INC_ROOTCAUSEINCID';
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_CAUSE_INCIDENT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_AUTH_RESOURCE_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RESOURCE_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EXT_TASK_EXEC';
   table_name_ VARCHAR2(30) := 'ACT_RU_EXT_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_BYTEARRAY_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_GE_BYTEARRAY';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_BYTEARRAY_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_GE_BYTEARRAY';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_BYTEARRAY_NAME';
   table_name_ VARCHAR2(30) := 'ACT_GE_BYTEARRAY';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_DEPLOYMENT_NAME';
   table_name_ VARCHAR2(30) := 'ACT_RE_DEPLOYMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_DEPLOYMENT_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RE_DEPLOYMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_JOBDEF_PROC_DEF_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOBDEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_JOB_HANDLER_TYPE';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'HANDLER_TYPE_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_EVENT_SUBSCR_EVT_NAME';
   table_name_ VARCHAR2(30) := 'ACT_RU_EVENT_SUBSCR';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EVENT_NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_PROCDEF_DEPLOYMENT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RE_PROCDEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEPLOYMENT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_PROCDEF_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RE_PROCDEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_PROCDEF_VER_TAG';
   table_name_ VARCHAR2(30) := 'ACT_RE_PROCDEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VERSION_TAG_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_PROCDEF_KEY';
   table_name_ VARCHAR2(30) := 'ACT_RE_PROCDEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RE_CASE_DEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CATEGORY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'KEY_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VERSION_', 'NUMBER(38)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEPLOYMENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RESOURCE_NAME_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DGRM_RESOURCE_NAME_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'HISTORY_TTL_', 'NUMBER(38)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RE_CASE_DEF_PK';
   table_name_ VARCHAR2(30) := 'ACT_RE_CASE_DEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUPER_CASE_EXEC_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUPER_EXEC_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BUSINESS_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PARENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PREV_STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CURRENT_STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REQUIRED_', 'NUMBER(1)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_CASE_EXECUTION_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_SENTRY_PART';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXEC_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SENTRY_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SOURCE_CASE_EXEC_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'STANDARD_EVENT_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SOURCE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VARIABLE_EVENT_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VARIABLE_NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SATISFIED_', 'NUMBER(1)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_CASE_SENTRY_PART_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_SENTRY_PART';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_CASE_EXEC_BUSKEY';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BUSINESS_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_CASE_EXE_CASE_INST';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_CASE_EXE_CASE_INST';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_CASE_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_CASE_EXE_PARENT';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PARENT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_CASE_EXE_PARENT';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PARENT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_CASE_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_CASE_EXE_CASE_DEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_CASE_EXE_CASE_DEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RE_CASE_DEF (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_VAR_CASE_EXE';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_VAR_CASE_EXE';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_CASE_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_VAR_CASE_INST_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_VAR_CASE_INST';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_CASE_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TASK_CASE_EXEC';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_TASK_CASE_EXE';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_CASE_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TASK_CASE_DEF_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_TASK_CASE_DEF';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RE_CASE_DEF (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_CASE_SENTRY_CASE_INST';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_SENTRY_PART';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_CASE_SENTRY_CASE_INST';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_SENTRY_PART';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_CASE_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_CASE_SENTRY_CASE_EXEC';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_SENTRY_PART';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXEC_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_CASE_SENTRY_CASE_EXEC';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_SENTRY_PART';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXEC_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_CASE_EXECUTION (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_CASE_DEF_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RE_CASE_DEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_CASE_EXEC_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_CASE_EXECUTION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RE_DECISION_DEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CATEGORY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'KEY_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VERSION_', 'NUMBER(38)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEPLOYMENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RESOURCE_NAME_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DGRM_RESOURCE_NAME_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_REQ_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_REQ_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'HISTORY_TTL_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VERSION_TAG_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RE_DECISION_DEF_PK';
   table_name_ VARCHAR2(30) := 'ACT_RE_DECISION_DEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RE_DECISION_REQ_DEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CATEGORY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'KEY_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VERSION_', 'NUMBER(38)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEPLOYMENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RESOURCE_NAME_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DGRM_RESOURCE_NAME_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RE_DECISION_REQ_DEF_PK';
   table_name_ VARCHAR2(30) := 'ACT_RE_DECISION_REQ_DEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_DEC_REQ';
   table_name_ VARCHAR2(30) := 'ACT_RE_DECISION_DEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_REQ_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RE_DECISION_REQ_DEF (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_DEC_DEF_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RE_DECISION_DEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_DEC_DEF_REQ_ID';
   table_name_ VARCHAR2(30) := 'ACT_RE_DECISION_DEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_REQ_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_DEC_REQ_DEF_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_RE_DECISION_REQ_DEF';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_PROCINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BUSINESS_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'START_TIME_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DURATION_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'START_USER_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'START_ACT_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_ACT_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUPER_PROCESS_INSTANCE_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUPER_CASE_INSTANCE_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DELETE_REASON_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'STATE_', 'NVARCHAR2(255)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_PROCINST_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_PROCINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_PROCINST_UNI_PROC_INST';
   table_name_ VARCHAR2(30) := 'ACT_HI_PROCINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'U', NULL, NULL, TRUE, TRUE, FALSE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PARENT_ACT_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_ID_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CALL_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CALL_CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_TYPE_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ASSIGNEE_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'START_TIME_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DURATION_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_INST_STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SEQUENCE_COUNTER_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_ACTINST_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_TASKINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PARENT_TASK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DESCRIPTION_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'OWNER_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ASSIGNEE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'START_TIME_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DURATION_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DELETE_REASON_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PRIORITY_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DUE_DATE_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'FOLLOW_UP_DATE_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_TASKINST_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_TASKINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_VARINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VAR_TYPE_', 'NVARCHAR2(100)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BYTEARRAY_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DOUBLE_', 'NUMBER(*,10)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'LONG_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TEXT_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TEXT2_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'STATE_', 'NVARCHAR2(20)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_VARINST_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_VARINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VAR_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VAR_TYPE_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIME_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BYTEARRAY_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DOUBLE_', 'NUMBER(*,10)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'LONG_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TEXT_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TEXT2_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SEQUENCE_COUNTER_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'OPERATION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_DETAIL_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIMESTAMP_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'OPERATION_TYPE_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ASSIGNER_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_IDENTITYLINK_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_COMMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIME_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACTION_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'MESSAGE_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('FULL_MSG_', 'BLOB', 'Y', NULL, 'LOB (FULL_MSG_) STORE AS (TABLESPACE &IFSAPP_LOB CHUNK 4096 ENABLE STORAGE IN ROW)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Add_Lob_Column(table_name_, column_, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_COMMENT_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_COMMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_ATTACHMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DESCRIPTION_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'URL_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CONTENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_ATTACHMENT_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_ATTACHMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEPLOYMENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BATCH_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIMESTAMP_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'OPERATION_TYPE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'OPERATION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ENTITY_TYPE_', 'NVARCHAR2(30)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROPERTY_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ORG_VALUE_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NEW_VALUE_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CATEGORY_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXTERNAL_TASK_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'INCIDENT_MSG_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'INCIDENT_TYPE_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACTIVITY_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CAUSE_INCIDENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_CAUSE_INCIDENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CONFIGURATION_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'INCIDENT_STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIMESTAMP_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DUEDATE_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_RETRIES_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_PRIORITY_', 'NUMBER(19)', 'N', 0);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_EXCEPTION_MSG_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_EXCEPTION_STACK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DEF_TYPE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DEF_CONFIGURATION_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROCESS_INSTANCE_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROCESS_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROCESS_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEPLOYMENT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SEQUENCE_COUNTER_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_BATCH';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TOTAL_JOBS_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOBS_PER_SEED_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'INVOCATIONS_PER_JOB_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SEED_JOB_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'MONITOR_JOB_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BATCH_JOB_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_USER_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'START_TIME_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');  

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_BATCH_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_BATCH';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIMESTAMP_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXT_TASK_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RETRIES_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TOPIC_NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'WORKER_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PRIORITY_', 'NUMBER(19)', 'N', 0);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ERROR_MSG_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ERROR_DETAILS_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_PRO_INST_END';
   table_name_ VARCHAR2(30) := 'ACT_HI_PROCINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_PRO_I_BUSKEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_PROCINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BUSINESS_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_PRO_INST_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_PROCINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_PRO_INST_PROC_KEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_PROCINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_PRO_INST_PROC_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_PROCINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'START_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_PI_PDEFID_END_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_PROCINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_PRO_INST_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_PROCINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_PRO_INST_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_PROCINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ACTINST_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ACT_INST_START';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'START_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ACT_INST_END';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ACT_INST_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_ID_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ACT_INST_COMP';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_ID_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');      
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ACT_INST_STATS';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_INST_STATE_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ACT_INST_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ACT_INST_PROC_KEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_AI_PDEFID_END_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ACT_INST_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_TASKINST_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_TASKINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_TASK_INST_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_TASKINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_TASK_INST_PROC_KEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_TASKINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_TASKINST_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_HI_TASKINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_TASKINSTID_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_HI_TASKINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_TASK_INST_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_TASKINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_TASK_INST_START';
   table_name_ VARCHAR2(30) := 'ACT_HI_TASKINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'START_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_TASK_INST_END';
   table_name_ VARCHAR2(30) := 'ACT_HI_TASKINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_PROC_INST';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_ACT_INST';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_CASE_INST';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_CASE_EXEC';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_EXECUTION_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_NAME';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_TASK_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_PROC_KEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_BYTEAR';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BYTEARRAY_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_TASK_BYTEAR';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BYTEARRAY_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_IDENT_LNK_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_IDENT_LNK_USER';
   table_name_ VARCHAR2(30) := 'ACT_HI_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_IDENT_LNK_GROUP';
   table_name_ VARCHAR2(30) := 'ACT_HI_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_IDENT_LNK_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_IDENT_LNK_PROC_KEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_IDENT_LINK_TASK';
   table_name_ VARCHAR2(30) := 'ACT_HI_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_IDENT_LINK_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_IDENT_LNK_TIMESTAMP';
   table_name_ VARCHAR2(30) := 'ACT_HI_IDENTITYLINK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIMESTAMP_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_VARINST_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_VARINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_PROCVAR_PROC_INST';
   table_name_ VARCHAR2(30) := 'ACT_HI_VARINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_PROCVAR_NAME_TYPE';
   table_name_ VARCHAR2(30) := 'ACT_HI_VARINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VAR_TYPE_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_CASEVAR_CASE_INST';
   table_name_ VARCHAR2(30) := 'ACT_HI_VARINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_VAR_INST_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_VARINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_VAR_INST_PROC_KEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_VARINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_VARINST_BYTEAR';
   table_name_ VARCHAR2(30) := 'ACT_HI_VARINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BYTEARRAY_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_VARINST_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_VARINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_INCIDENT_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_INCIDENT_PROC_KEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_INCIDENT_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_INCIDENT_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_INCIDENT_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_JOB_LOG_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_JOB_LOG_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROCESS_INSTANCE_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_JOB_LOG_PROCDEF';
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROCESS_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_JOB_LOG_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_JOB_LOG_JOB_DEF_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_JOB_LOG_PROC_KEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROCESS_DEF_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_JOB_LOG_EX_STACK';
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_EXCEPTION_STACK_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_JOB_LOG_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_HI_BAT_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_BATCH';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG_PROCDEF';
   table_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG_PROC_KEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_EXTTASKLOG_ERRORDET';
   table_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ERROR_DETAILS_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_EXT_TASK_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_OP_LOG_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_OP_LOG_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_OP_LOG_PROCDEF';
   table_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_OP_LOG_TASK';
   table_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_OP_LOG_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_OP_LOG_TIMESTAMP';
   table_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIMESTAMP_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_OP_LOG_USER_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_OP_LOG_OP_TYPE';
   table_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'OPERATION_TYPE_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_OP_LOG_ENTITY_TYPE';
   table_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ENTITY_TYPE_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_COMMENT_TASK';
   table_name_ VARCHAR2(30) := 'ACT_HI_COMMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_COMMENT_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_COMMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_COMMENT_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_HI_COMMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_COMMENT_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_COMMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ATTACHMENT_CONTENT';
   table_name_ VARCHAR2(30) := 'ACT_HI_ATTACHMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CONTENT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ATTACHMENT_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_ATTACHMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ATTACHMENT_PROCINST';
   table_name_ VARCHAR2(30) := 'ACT_HI_ATTACHMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ATTACHMENT_TASK';
   table_name_ VARCHAR2(30) := 'ACT_HI_ATTACHMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ATTACHMENT_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_ATTACHMENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_CASEINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BUSINESS_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CLOSE_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DURATION_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_USER_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUPER_CASE_INSTANCE_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SUPER_PROCESS_INSTANCE_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_CASEINST_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_CASEINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_CASEINST_UNI_PROC_CASE';
   table_name_ VARCHAR2(30) := 'ACT_HI_CASEINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'U', NULL, NULL, TRUE, TRUE, FALSE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_CASEACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PARENT_ACT_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_ACT_ID_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CALL_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CALL_CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_ACT_NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_ACT_TYPE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DURATION_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'STATE_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REQUIRED_', 'NUMBER(1)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_CASEACTINST_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_CASEACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_CAS_I_CLOSE';
   table_name_ VARCHAR2(30) := 'ACT_HI_CASEINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CLOSE_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_CAS_I_BUSKEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_CASEINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BUSINESS_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_CAS_I_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_CASEINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_CAS_A_I_CREATE';
   table_name_ VARCHAR2(30) := 'ACT_HI_CASEACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_CAS_A_I_END';
   table_name_ VARCHAR2(30) := 'ACT_HI_CASEACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_CAS_A_I_COMP';
   table_name_ VARCHAR2(30) := 'ACT_HI_CASEACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_ACT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_CAS_A_I_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_CASEACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_DEF_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_DEF_KEY_', 'NVARCHAR2(255)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_DEF_NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_DEF_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EVAL_TIME_', 'TIMESTAMP(6)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'COLLECT_VALUE_', 'NUMBER(*,10)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_DEC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_REQ_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_REQ_KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_DECINST_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_DEC_IN';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_INST_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CLAUSE_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CLAUSE_NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VAR_TYPE_', 'NVARCHAR2(100)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BYTEARRAY_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DOUBLE_', 'NUMBER(*,10)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'LONG_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TEXT_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TEXT2_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_DEC_IN_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_DEC_IN';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_DEC_OUT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_INST_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CLAUSE_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CLAUSE_NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RULE_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RULE_ORDER_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VAR_NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VAR_TYPE_', 'NVARCHAR2(100)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BYTEARRAY_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DOUBLE_', 'NUMBER(*,10)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'LONG_', 'NUMBER(19)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TEXT_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TEXT2_', 'NVARCHAR2(2000)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_HI_DEC_OUT_PK';
   table_name_ VARCHAR2(30) := 'ACT_HI_DEC_OUT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_DEF_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_KEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_DEF_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_CI';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CASE_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_ACT';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_ACT_INST';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ACT_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_TENANT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_ROOT_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_DEC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_REQ_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_REQ_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_REQ_KEY';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_REQ_KEY_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_INST_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_DECINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_IN_INST';
   table_name_ VARCHAR2(30) := 'ACT_HI_DEC_IN';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_IN_CLAUSE';
   table_name_ VARCHAR2(30) := 'ACT_HI_DEC_IN';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CLAUSE_ID_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_IN_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_DEC_IN';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_IN_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_DEC_IN';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_OUT_INST';
   table_name_ VARCHAR2(30) := 'ACT_HI_DEC_OUT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'DEC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_OUT_RULE';
   table_name_ VARCHAR2(30) := 'ACT_HI_DEC_OUT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'RULE_ORDER_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CLAUSE_ID_');   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_OUT_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_HI_DEC_OUT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DEC_OUT_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_DEC_OUT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

-- End of schema from oracle_engine.sql

-- Start of schema from oracle_identity.sql

DECLARE
   table_name_ VARCHAR2(30) := 'ACT_ID_GROUP';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NVARCHAR2(255)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_ID_GROUP_PK';
   table_name_ VARCHAR2(30) := 'ACT_ID_GROUP';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_ID_MEMBERSHIP';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_ID_MEMBERSHIP_PK';
   table_name_ VARCHAR2(30) := 'ACT_ID_MEMBERSHIP';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_ID_USER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'FIRST_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'LAST_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'EMAIL_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PWD_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'SALT_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'LOCK_EXP_TIME_', 'TIMESTAMP(6)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ATTEMPTS_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PICTURE_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_ID_USER_PK';
   table_name_ VARCHAR2(30) := 'ACT_ID_USER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_ID_INFO';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'KEY_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VALUE_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PARENT_ID_', 'NVARCHAR2(255)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('PASSWORD_', 'BLOB', 'Y', NULL, 'LOB (PASSWORD_) STORE AS (TABLESPACE &IFSAPP_LOB CHUNK 4096 ENABLE STORAGE IN ROW)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Add_Lob_Column(table_name_, column_, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_ID_INFO_PK';
   table_name_ VARCHAR2(30) := 'ACT_ID_INFO';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_ID_TENANT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REV_', 'NUMBER(38)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_', 'NVARCHAR2(255)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_ID_TENANT_PK';
   table_name_ VARCHAR2(30) := 'ACT_ID_TENANT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_ID_TENANT_MEMBER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)','N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_', 'NVARCHAR2(64)', 'N');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_', 'NVARCHAR2(64)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_ID_TENANT_MEMBER_PK';
   table_name_ VARCHAR2(30) := 'ACT_ID_TENANT_MEMBER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/


DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_MEMB_GROUP';
   table_name_ VARCHAR2(30) := 'ACT_ID_MEMBERSHIP';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_MEMB_GROUP';
   table_name_ VARCHAR2(30) := 'ACT_ID_MEMBERSHIP';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_ID_GROUP (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_MEMB_USER';
   table_name_ VARCHAR2(30) := 'ACT_ID_MEMBERSHIP';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_MEMB_USER';
   table_name_ VARCHAR2(30) := 'ACT_ID_MEMBERSHIP';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_ID_USER (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TENANT_MEMB';
   table_name_ VARCHAR2(30) := 'ACT_ID_TENANT_MEMBER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_TENANT_MEMB';
   table_name_ VARCHAR2(30) := 'ACT_ID_TENANT_MEMBER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TENANT_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_ID_TENANT (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TENANT_MEMB_USER';
   table_name_ VARCHAR2(30) := 'ACT_ID_TENANT_MEMBER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_TENANT_MEMB_USER';
   table_name_ VARCHAR2(30) := 'ACT_ID_TENANT_MEMBER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'USER_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_ID_USER (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TENANT_MEMB_GROUP';
   table_name_ VARCHAR2(30) := 'ACT_ID_TENANT_MEMBER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_TENANT_MEMB_GROUP';
   table_name_ VARCHAR2(30) := 'ACT_ID_TENANT_MEMBER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'GROUP_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_ID_GROUP (ID_)');
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_UNIQ_TENANT_MEMB_USER';
   table_name_ VARCHAR2(30) := 'ACT_ID_TENANT_MEMBER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'case when "USER_ID_" is null then null else "TENANT_ID_" end');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'case when "USER_ID_" is null then null else "USER_ID_" end');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'U', '&IFSAPP_INDEX', NULL, TRUE, TRUE, expression_ => TRUE);
END;
/

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_UNIQ_TENANT_MEMB_GROUP';
   table_name_ VARCHAR2(30) := 'ACT_ID_TENANT_MEMBER';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'case when "GROUP_ID_" is null then null else "TENANT_ID_" end');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'case when "GROUP_ID_" is null then null else "GROUP_ID_" end');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'U', '&IFSAPP_INDEX', NULL, TRUE, TRUE, expression_ => TRUE);
END;
/

-- End of schema from oracle_identity.sql

PROMPT Granting all objects in Camunda schema to IFSSYS
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Grant_Ifssys();
END;
/

PROMPT Granting all objects in Camunda schema to Appowner
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Grant_Appowner();
END;
/

DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_PROPERTY WHERE NAME_ = 'schema.version' AND VALUE_ = 'fox';
DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_PROPERTY WHERE NAME_ = 'schema.history' AND VALUE_ = 'create(fox)';
DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_PROPERTY WHERE NAME_ = 'next.dbid' AND VALUE_ = '1';
DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_PROPERTY WHERE NAME_ = 'deployment.lock' AND VALUE_ = '0';
DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_PROPERTY WHERE NAME_ = 'history.cleanup.job.lock' AND VALUE_ = '0';
DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_PROPERTY WHERE NAME_ = 'startup.lock' AND VALUE_ = '0';
DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '0' AND VERSION_ = '7.11.0';  

INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_PROPERTY (NAME_, VALUE_, REV_) VALUES ('schema.version', 'fox', 1);
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_PROPERTY (NAME_, VALUE_, REV_) VALUES ('schema.history', 'create(fox)', 1);
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_PROPERTY (NAME_, VALUE_, REV_) VALUES ('next.dbid', '1', 1);
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_PROPERTY (NAME_, VALUE_, REV_) VALUES ('deployment.lock', '0', 1);
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_PROPERTY (NAME_, VALUE_, REV_) VALUES ('history.cleanup.job.lock', '0', 1);
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_PROPERTY (NAME_, VALUE_, REV_) VALUES ('startup.lock', '0', 1);
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('0', CURRENT_TIMESTAMP, '7.11.0');
COMMIT;



PROMPT Upgrading IfsCamSys (Camunda) Schema Objects From 7.11 to 7.15


DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_JOB_LOG_JOB_CONF';
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'JOB_DEF_CONFIGURATION_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '1' AND VERSION_ = '7.11.3';
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('1', CURRENT_TIMESTAMP, '7.11.3');


DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ACT_INST_START';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Remove_Indexes(table_name_, index_name_);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_ACT_INST_START_END';
   table_name_ VARCHAR2(30) := 'ACT_HI_ACTINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'START_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '2' AND VERSION_ = '7.11.8';
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('2', CURRENT_TIMESTAMP, '7.11.8');


DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_PROPERTY WHERE NAME_ = 'telemetry.lock' AND VALUE_ = '0';
DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_PROPERTY WHERE NAME_ = 'installationId.lock' AND VALUE_ = '0';
DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '3' AND VERSION_ = '7.11.19';  
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_PROPERTY (NAME_, VALUE_, REV_) VALUES ('telemetry.lock', '0', 1);
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_PROPERTY (NAME_, VALUE_, REV_) VALUES ('installationId.lock', '0', 1);
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('3', CURRENT_TIMESTAMP, '7.11.19');


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_OP_LOG';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('ANNOTATION_', 'NVARCHAR2(2000)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/      
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('REPEAT_OFFSET_', 'NUMBER(19,0)', 'Y', 0);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/   
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('HISTORY_CONFIGURATION_', 'NVARCHAR2(255)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/   
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_DETAIL_VAR_INST_ID';
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VAR_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '100' AND VERSION_ = '7.12.0';
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('100', CURRENT_TIMESTAMP, '7.12.0');


-- NOTE: This patch was a repeat of patch 7.11.8
DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '101' AND VERSION_ = '7.12.1';
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('101', CURRENT_TIMESTAMP, '7.12.1');
   

DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_INCIDENT_CREATE_TI';
   table_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'CREATE_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_INCIDENT_END_TIME';
   table_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'END_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '102' AND VERSION_ = '7.12.11';
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('102', CURRENT_TIMESTAMP, '7.12.11');


-- NOTE: This patch was a repeat of patch 7.11.19
DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '103' AND VERSION_ = '7.12.12';  
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('103', CURRENT_TIMESTAMP, '7.12.12');


DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_HI_VAR_PI_NAME_TYPE';
   table_name_ VARCHAR2(30) := 'ACT_HI_VARINST';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'VAR_TYPE_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('HOSTNAME_', 'NVARCHAR2(255)', 'Y', NULL);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/ 
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('FAILED_ACT_ID_', 'NVARCHAR2(255)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/ 
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_JOB_LOG';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('FAILED_ACT_ID_', 'NVARCHAR2(255)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/ 
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('FAILED_ACTIVITY_ID_', 'NVARCHAR2(255)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('FAILED_ACTIVITY_ID_', 'NVARCHAR2(255)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('REMOVAL_TIME_', 'TIMESTAMP(6)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_AUTH_RM_TIME';
   table_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'REMOVAL_TIME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('ROOT_PROC_INST_ID_', 'NVARCHAR2(64)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_AUTH_ROOT_PI';
   table_name_ VARCHAR2(30) := 'ACT_RU_AUTHORIZATION';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ROOT_PROC_INST_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_JOBDEF';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('DEPLOYMENT_ID_', 'NVARCHAR2(64)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('PROC_DEF_ID_', 'NVARCHAR2(64)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_DETAIL';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('INITIAL_', 'NUMBER(1,0)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/

DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '200' AND VERSION_ = '7.13.0';
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('200', CURRENT_TIMESTAMP, '7.13.0');


DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TASK_OWNER';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'OWNER_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '201' AND VERSION_ = '7.13.5_1';
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('201', CURRENT_TIMESTAMP, '7.13.5_1');


-- NOTE: This patch was a repeat of patch 7.12.11
DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '202' AND VERSION_ = '7.13.5_2';
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('202', CURRENT_TIMESTAMP, '7.13.5_2');
   

-- NOTE: This patch was a repeat of patches 7.11.19 and 7.12.12
DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '203' AND VERSION_ = '7.13.6';  
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('203', CURRENT_TIMESTAMP, '7.13.6');


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('BATCH_ID_', 'NVARCHAR2(64)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_BATCH_ID';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BATCH_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_FK_VAR_BATCH';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'BATCH_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'F', NULL, NULL, TRUE, TRUE, FALSE, 'references ACT_RU_BATCH (ID_)');
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_VARIABLE_TASK_NAME_TYP';
   table_name_ VARCHAR2(30) := 'ACT_RU_VARIABLE';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TASK_ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'NAME_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TYPE_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '300' AND VERSION_ = '7.14.0';  
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('300', CURRENT_TIMESTAMP, '7.14.0');


DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_JOB_HANDLER';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Remove_Indexes(table_name_, index_name_);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_JOB_HANDLER';
   table_name_ VARCHAR2(30) := 'ACT_RU_JOB';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'HANDLER_TYPE_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, SUBSTR('HANDLER_CFG_', 1, 1850));   
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/

DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '301' AND VERSION_ = '7.14.3';  
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('301', CURRENT_TIMESTAMP, '7.14.3');


DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK_METER_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
   column_     &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_', 'NVARCHAR2(64)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ASSIGNEE_HASH_', 'NUMBER(19,0)');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIMESTAMP_', 'TIMESTAMP(6)');

   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Or_Replace_Table(table_name_, columns_, '&IFSAPP_DATA', NULL, TRUE);
END;
/
DECLARE
   constraint_name_ VARCHAR2(30) := 'ACT_RU_TASK_METER_LOG_PK';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK_METER_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'ID_');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Constraint(table_name_, constraint_name_, columns_, 'P', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   index_name_ VARCHAR2(30) := 'ACT_IDX_TASK_METER_LOG_TIME';
   table_name_ VARCHAR2(30) := 'ACT_RU_TASK_METER_LOG';
   columns_    &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColumnTabType;
BEGIN
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Reset_Column_Table(columns_);
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Table_Column(columns_, 'TIMESTAMP_');  
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Create_Index(table_name_, index_name_, columns_, 'N', '&IFSAPP_INDEX', NULL, TRUE, TRUE);
END;
/
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_RU_INCIDENT';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('ANNOTATION_', 'NVARCHAR2(2000)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/
DECLARE
   table_name_ VARCHAR2(30) := 'ACT_HI_INCIDENT';
   column_ &CAMUNDA_APPOWNER..Camunda_Install_SYS.ColRec;
BEGIN   
   column_ := &CAMUNDA_APPOWNER..Camunda_Install_SYS.Set_Column_Values('ANNOTATION_', 'NVARCHAR2(2000)', 'Y');
   &CAMUNDA_APPOWNER..Camunda_Install_SYS.Alter_Table_Column(table_name_, 'ADD', column_, TRUE);
END;
/

DELETE FROM &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG WHERE ID_ = '400' AND VERSION_ = '7.15.0';  
INSERT INTO &CAMUNDA_APPOWNER..ACT_GE_SCHEMA_LOG (ID_, TIMESTAMP_, VERSION_) VALUES ('400', CURRENT_TIMESTAMP, '7.15.0');

COMMIT;
