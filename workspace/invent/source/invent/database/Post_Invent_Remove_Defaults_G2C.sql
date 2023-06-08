-------------------------------------------------------------------------------
--
--  Filename      : Post_Invent_Remove_Defaults_G2C.sql
--
--  Module        : INVENT
--
--  Purpose       : Remove Oracle Default values from columns added by Global Extension to core tables
--                  This need to be done in a post data file to ensure error free deployment of core upgrade scripts
--
--  Date    Sign    History
--  ------  ------  -------------------------------------------------------------
--  200213  WaSalk  Created
---------------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','Post_Invent_Remove_Defaults_G2C.sql','Timestamp_1');
PROMPT Post_Invent_Remove_Defaults_G2C.sql Start

-----------------------------------------------------------------------------------------
-- Removing Oracle Defaults from table columns
-----------------------------------------------------------------------------------------

-- ***** company_invent_info_tab Start *****
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','Post_Invent_Remove_Defaults_G2C.sql','Timestamp_2');
PROMPT Removing Oracle default values from columns in company_invent_info_tab
DECLARE
   column_             Database_SYS.ColRec;
   table_              VARCHAR2(30) := 'COMPANY_INVENT_INFO_TAB';
BEGIN
   column_ := Database_SYS.Set_Column_Values('AUTO_UPDATE_DATE_APPLIED', default_value_=>'$DEFAULT_NULL$');
   Database_SYS.Alter_Table_Column (table_, 'M', column_, TRUE);
END;
/
-- ***** company_invent_info_tab End *****

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','Post_Invent_Remove_Defaults_G2C.sql','Done');
SET SERVEROUTPUT OFF

PROMPT Post_Invent_Remove_Defaults_G2C.sql End


