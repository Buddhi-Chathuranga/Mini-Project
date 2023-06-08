-------------------------------------------------------------------------
--  File:      POST_ORDER_UpgRefreshMvCategories.sql
--
--  Module:    ORDER
--
--  Purpose:   Update refresh categories if mv exist.
--
--  Date    Sign   History
--  ------  -----  -------------------------------------------------------
--  150407  MeAblk BOULDER-940, Created, Added refresh statement for CUSTOMER_ORDER_CHARGE_MVT, CUSTOMER_ORDER_LINE_MVT, CUSTOMER_ORDER_DELIV_MVT.
--------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpgRefreshMvCategories.sql','Timestamp_1');
PROMPT Starting POST_ORDER_UpgRefreshMvCategories.sql

-------------------------------------------------------------------------------
------------------- REPLACE ALL MV usages WITH MVT ----------------------------
-------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpgRefreshMvCategories.sql','Timestamp_2');
PROMPT Update refresh categories if mv exist

BEGIN
	IF Database_SYS.Mtrl_View_Exist('CUSTOMER_ORDER_CHARGE_MV') THEN
		Xlr_Mv_Per_Refresh_Cat_API.Replace_Mv_In_All_Categories('CUSTOMER_ORDER_CHARGE_MV' , 'CUSTOMER_ORDER_CHARGE_MVT') ;
		Database_SYS.Remove_All_Cons_And_Idx('CUSTOMER_ORDER_CHARGE_MV', TRUE);
		Xlr_Mv_Util_API.Remove_Mv('CUSTOMER_ORDER_CHARGE_MV');
   END IF;

   IF Database_SYS.Mtrl_View_Exist('CUSTOMER_ORDER_LINE_MV') THEN
		Xlr_Mv_Per_Refresh_Cat_API.Replace_Mv_In_All_Categories('CUSTOMER_ORDER_LINE_MV' , 'CUSTOMER_ORDER_LINE_MVT') ;
		Database_SYS.Remove_All_Cons_And_Idx('CUSTOMER_ORDER_LINE_MV', TRUE);
		Xlr_Mv_Util_API.Remove_Mv('CUSTOMER_ORDER_LINE_MV');
   END IF;

   IF Database_SYS.Mtrl_View_Exist('CUSTOMER_ORDER_DELIVERY_MV') THEN
		Xlr_Mv_Per_Refresh_Cat_API.Replace_Mv_In_All_Categories('CUSTOMER_ORDER_DELIVERY_MV', 'CUSTOMER_ORDER_DELIV_MVT') ;
		Database_SYS.Remove_All_Cons_And_Idx('CUSTOMER_ORDER_DELIVERY_MV', TRUE);
		Xlr_Mv_Util_API.Remove_Mv('CUSTOMER_ORDER_DELIVERY_MV');
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpgRefreshMvCategories.sql','Done');
PROMPT Finished with POST_ORDER_UpgRefreshMvCategories.sql
