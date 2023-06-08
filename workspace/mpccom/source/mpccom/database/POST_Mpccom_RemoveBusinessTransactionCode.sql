-----------------------------------------------------------------------------
--  Module : MPCCOM
--
--  File   : POST_Mpccom_RemoveBusinessTransactionCode.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  211124   ShKolk  Created
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_Mpccom_RemoveBusinessTransactionCode.sql','Timestamp_1');
PROMPT Starting POST_Mpccom_RemoveBusinessTransactionCode.sql
PROMPT Remove obsolete client BusinessTransactionCode, projection BusinessTransactionCodeHandling
BEGIN
   Database_SYS.Remove_Client('BusinessTransactionCode');
   Database_SYS.Remove_Projection('BusinessTransactionCodeHandling');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_Mpccom_RemoveBusinessTransactionCode.sql','Done');
PROMPT Finished with POST_Mpccom_RemoveBusinessTransactionCode.sql
