-----------------------------------------------------------------------------
--  Module : INVENT
--
--  File   : POST_INVENT_RemoveIprActiveFlag.sql
--
--  Purpose       : Remove IprActive column from Site_Invent_Info_Tab and move it to INVPLA component along with the existing data.
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------------
--  210818   RaMolk  SC21R2-2338, Moved IPR_ACTIVE column obsoleteing logic to INVENT 2120.cdb
--  210514   JiThlk  SCZ-14214, Removing IPR_ACTIVE column from SITE_INVENT_INFO_TAB and transfer data to SiteIprInfo.
--  ------   ------  --------------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_RemoveIprActiveFlag.sql','Timestamp_1');
PROMPT Transfer IPR_ACTIVE data FROM Site_Invent_Info_Tab TO Site_Ipr_Info_Tab.

DECLARE
   $IF Component_Invpla_SYS.INSTALLED $THEN
      CURSOR get_site_invent_info IS
         SELECT contract, ipr_active
         FROM   site_invent_info_tab a
         WHERE  NOT EXISTS (SELECT 1
                            FROM   site_ipr_info_pub b
                            WHERE  b.contract = a.contract);
   $END
BEGIN
   $IF Component_Invpla_SYS.INSTALLED $THEN
      FOR rec_ IN get_site_invent_info LOOP
               Site_Ipr_Info_API.New(rec_.contract, nvl(rec_.ipr_active,Fnd_Boolean_API.DB_FALSE));
      END LOOP;
      COMMIT;
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_RemoveIprActiveFlag.sql','Timestamp_2');
PROMPT Done with transfering IPR_ACTIVE data FROM Site_Invent_Info_Tab TO Site_Ipr_Info_Tab.
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_RemoveIprActiveFlag.sql','Done');
