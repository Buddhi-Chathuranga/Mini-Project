-----------------------------------------------------------------------------
--
--  Logical unit: IamEventUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210519  mjaylk
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU  NEW METHODS -------------------------------------

PROCEDURE Clear_Iam_Events
IS
   cleanup_days_   NUMBER;
   sysdate_        DATE := SYSDATE;
   TYPE event_id_type IS TABLE OF iam_login_event_tab.event_id%TYPE;
   event_id_          event_id_type;

   CURSOR get_recs(cleanup_day_  NUMBER) IS
      SELECT event_id
      FROM   iam_login_event_tab
      WHERE  event_time < (sysdate_ - cleanup_day_);
      
   CURSOR get_admin_recs(cleanup_day_  NUMBER) IS
      SELECT event_id
      FROM   iam_admin_event_tab
      WHERE  event_time < (sysdate_ - cleanup_day_);

BEGIN
   BEGIN
      cleanup_days_ := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('KEEP_IAM_EVENTS'));
   EXCEPTION
      WHEN OTHERS THEN
         cleanup_days_ := NULL;
   END;
   IF (cleanup_days_ IS NOT NULL) THEN
      OPEN get_recs(cleanup_days_);
      LOOP
         FETCH get_recs BULK COLLECT INTO event_id_ LIMIT 1000; 
         FORALL i_ IN 1..event_id_.count
            DELETE
               FROM iam_login_event_tab
               WHERE event_id = event_id_(i_);
         -- Commit to avoid snapshot too old error
         @ApproveTransactionStatement(2021-05-19,mjaylk)
         COMMIT;
         EXIT WHEN get_recs%NOTFOUND;
      END LOOP;
      CLOSE get_recs;
      
      OPEN get_admin_recs(cleanup_days_);
      LOOP
         FETCH get_admin_recs BULK COLLECT INTO event_id_ LIMIT 1000; 
         FORALL i_ IN 1..event_id_.count
            DELETE
               FROM iam_admin_event_tab
               WHERE event_id = event_id_(i_);
         -- Commit to avoid snapshot too old error
         @ApproveTransactionStatement(2021-05-19,mjaylk)
         COMMIT;
         EXIT WHEN get_admin_recs%NOTFOUND;
      END LOOP;
      CLOSE get_admin_recs;
   END IF;
END Clear_Iam_Events;
