-----------------------------------------------------------------------------
--
--  Logical unit: ServerLogUtility
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign  History
--  ------  ----  -----------------------------------------------------------
--  070705  SUMA  Changed the Cleanup_ method for performance reasons.(Bug#65157).
--  100318  HAAR  Added support for Alert Log errors.(EACS-433).
--  111213  DUWI  Changed the calculation of the timestamp field to support DST (RDTERUNTIME-1825).
--  140217  USRA  Modified to limit no of records fetched in BULK COLLECT. (Bug#108086)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cleanup__
IS
   CURSOR get_category IS
      SELECT category_id,
             SYSDATE - days_to_keep clean_date
        FROM Server_Log_Category_Tab
       WHERE cleanup = 'TRUE';

   TYPE category_id IS TABLE OF  Server_Log_Category_Tab.Category_Id%TYPE;
   TYPE clean_date IS TABLE OF DATE;

   category_id_ category_id;
   clean_date_  clean_date;

BEGIN
   OPEN get_category;
   LOOP
   FETCH get_category BULK COLLECT INTO category_id_,clean_date_ LIMIT 1000;
   FORALL i_ IN 1..category_id_.COUNT
      DELETE FROM Server_Log_Tab
         WHERE  category_id = category_id_(i_)
         AND    date_created < clean_date_(i_)
         AND    checked = 'TRUE';
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
      EXIT WHEN get_category%NOTFOUND;
   END LOOP;
   CLOSE get_category;
END Cleanup__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


