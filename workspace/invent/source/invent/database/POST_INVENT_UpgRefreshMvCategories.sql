-------------------------------------------------------------------------
--  File:      POST_INVENT_UpgRefreshMvCategories.sql
--
--  Module:    INVENT
--
--  Purpose:   Update refresh categories if mv exist.
--
--  Date    Sign   History
--  ------  -----  --------------------------------------------------------------------------
--  150409  AyAmlk BOULDER-1051, Removed INVENT_TRANSACTION_HIST_MV and the objects connected to it.
--  150409  AyAmlk BOULDER-1032, Removed INVENTORY_TURNOVER_MV and the objects connected to it.
--  150409  MeAblk BOULDER-951, Created, Added refresh statement for INVENTORY_VALUE_PART_MVT.
---------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_UpgRefreshMvCategories.sql','Timestamp_1');
PROMPT Starting POST_INVENT_UpgRefreshMvCategories.sql

-------------------------------------------------------------------------------
------------------- REPLACE ALL MV usages WITH MVT ----------------------------
-------------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_UpgRefreshMvCategories.sql','Timestamp_2');
PROMPT Update refresh categories if mv exist

BEGIN
	IF Database_SYS.Mtrl_View_Exist('INVENTORY_VALUE_PART_MV') THEN
		Xlr_Mv_Per_Refresh_Cat_API.Replace_Mv_In_All_Categories('INVENTORY_VALUE_PART_MV' , 'INVENTORY_VALUE_PART_MVT') ;
		Database_SYS.Remove_All_Cons_And_Idx('INVENTORY_VALUE_PART_MV', TRUE);
		Xlr_Mv_Util_API.Remove_Mv('INVENTORY_VALUE_PART_MV');
   END IF;

   IF Database_SYS.Mtrl_View_Exist('INVENTORY_TURNOVER_MV') THEN
		Xlr_Mv_Per_Refresh_Cat_API.Replace_Mv_In_All_Categories('INVENTORY_TURNOVER_MV' , 'INVENTORY_TURNOVER_MVT') ;
		Database_SYS.Remove_All_Cons_And_Idx('INVENTORY_TURNOVER_MV', TRUE);
		Xlr_Mv_Util_API.Remove_Mv('INVENTORY_TURNOVER_MV');
   END IF;

   IF Database_SYS.Mtrl_View_Exist('INVENT_TRANSACTION_HIST_MV') THEN
		Xlr_Mv_Per_Refresh_Cat_API.Replace_Mv_In_All_Categories('INVENT_TRANSACTION_HIST_MV' , 'INVENT_TRANS_HIST_MVT') ;
		Database_SYS.Remove_All_Cons_And_Idx('INVENT_TRANSACTION_HIST_MV', TRUE);
		Xlr_Mv_Util_API.Remove_Mv('INVENT_TRANSACTION_HIST_MV');
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_UpgRefreshMvCategories.sql','Done');
PROMPT Finished with POST_INVENT_UpgRefreshMvCategories.sql
