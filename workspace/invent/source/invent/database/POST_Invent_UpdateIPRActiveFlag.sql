-----------------------------------------------------------------------------
--
--  Filename      : POST_Invent_UpdateIPRActiveFlag.sql
--
--  Module        : INVENT
--
--  Purpose       : During the upgrade, if INVPLA  module is installed this will set the IPR_ACTIVE flag in 
--                  COMPANY_INVENT_INFO_TAB and SITE_INVENT_INFO_TAB to 'TRUE'. If INVPLA is not installed then
--                  the value will be the one set in the UPG by default which is 'FALSE'.
--  
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------
--  170524  AwWelk  STRSC-8620, Created.
-----------------------------------------------------------------------------
SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_UpdateIPRActiveFlag.sql','Timestamp_1');
PROMPT Starting POST_Invent_UpdateIPRActiveFlag.SQL

BEGIN
   IF Component_Invpla_SYS.INSTALLED THEN 
      UPDATE COMPANY_INVENT_INFO_TAB
      SET IPR_ACTIVE = 'TRUE';
      
      UPDATE SITE_INVENT_INFO_TAB
      SET IPR_ACTIVE = 'TRUE';
      
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_UpdateIPRActiveFlag.sql','Done');
PROMPT Finished with POST_Invent_UpdateIPRActiveFlag.sql
