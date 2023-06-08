-----------------------------------------------------------------------------
--
--  Logical unit: ApplicationMsgStatistics
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Forward_Statistics
IS
      CURSOR get_statistics IS
      SELECT QUEUE,STATE_DB,COUNT(APPLICATION_MESSAGE_ID) AS COUNT
      FROM  APPLICATION_MESSAGE
      GROUP BY QUEUE,STATE_DB ;

      attr_         VARCHAR2(2000);
      info_         VARCHAR2(100);
      objid_        VARCHAR2(100);
      objversion_   VARCHAR2(100);
      created_date_ DATE;
      created_by_   VARCHAR2(30);
BEGIN   
   created_date_ := SYSDATE;
   created_by_   := Fnd_Session_API.Get_Fnd_User;
   FOR rec_ IN get_statistics LOOP
      client_sys.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('LOG_ID',sys_guid(), attr_);
      client_sys.Add_To_Attr('QUEUE', rec_.queue,attr_);
      client_sys.Add_To_Attr('STATE', rec_.state_db,attr_);
      client_sys.Add_To_Attr('COUNT', rec_.count,attr_);
      client_sys.Add_To_Attr('CREATED_DATE', created_date_,attr_);
      client_sys.Add_To_Attr('CREATED_BY', created_by_,attr_);

      New__(info_,objid_,objversion_,attr_,'DO');
   END LOOP;

END Forward_Statistics;

PROCEDURE Cleanup
IS
   sysdate_        DATE := SYSDATE;
   TYPE log_id_type IS TABLE OF APPLICATION_MSG_STATISTICS_TAB.log_id%TYPE;
   log_id_       log_id_type;
   cleanup_days_   NUMBER;

   CURSOR get_recs IS
      SELECT log_id
      FROM APPLICATION_MSG_STATISTICS_TAB
      WHERE  created_date <= (sysdate_ - cleanup_days_);
BEGIN
   cleanup_days_ := to_number(Fnd_Setting_API.Get_Value('KEEP_MSG_STAT'));
   OPEN get_recs;
   LOOP
      FETCH get_recs BULK COLLECT INTO log_id_ LIMIT 1000;
      FORALL i_ IN 1..log_id_.count
        DELETE
            FROM APPLICATION_MSG_STATISTICS_TAB
            WHERE log_id = log_id_(i_);
     
      -- Commit to avoid snapshot too old error
      @ApproveTransactionStatement(2014-07-08,maddlk)
      COMMIT;
      EXIT WHEN get_recs%NOTFOUND;
   END LOOP;
   CLOSE get_recs;
END Cleanup;