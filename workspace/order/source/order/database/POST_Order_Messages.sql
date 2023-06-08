---------------------------------------------------------------------
--
--  File: POST_Order_Messages.sql
--
--  Module        : ORDER
--
--  Purpose       : Create/Update Connectivity Message Classes for ORDER, depending on the availabllity of dynamic dependant modules.
--
--  Note          :
--
--
--  Date    Sign    History
--  ------  ----    -------------------------------------------------
--  180103  KiSalk  Created.
---------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_Messages.sql','Timestamp_1');
PROMPT Create Connectivity Message Classes ORDERS, ORDCHG, ORDRSP, DIRDEL, DESADV, PRICAT, SBIINV, RECADV...

BEGIN
   -- Call the following method from DISCOM to Create/Update Connectivity Message Classes 
   Create_Connect_Messages_API.Register_Message_Classes();
END;
/
COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_Messages.sql','Timestamp_2');
PROMPT Done WITH Creating Connectivity Message Classes
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_Messages.sql','Done');
