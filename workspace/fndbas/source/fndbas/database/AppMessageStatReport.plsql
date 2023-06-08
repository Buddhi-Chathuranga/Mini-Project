-----------------------------------------------------------------------------
--
--  Logical unit: AppMessageStatReport
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  ---------------------------------------------------------
--  2019-05-03  madrse  LCS-145612: Created
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

DB_INVOKE_AQ   CONSTANT VARCHAR2(20) := App_Message_Stat_Type_API.DB_INVOKE_AQ;
DB_CREATE_AM   CONSTANT VARCHAR2(20) := App_Message_Stat_Type_API.DB_CREATE_AM;
DB_FORWARD_MDB CONSTANT VARCHAR2(20) := App_Message_Stat_Type_API.DB_FORWARD_MDB;
DB_INVOKE_MDB  CONSTANT VARCHAR2(20) := App_Message_Stat_Type_API.DB_INVOKE_MDB;
DB_PROCESS     CONSTANT VARCHAR2(20) := App_Message_Stat_Type_API.DB_PROCESS;
DB_SEND        CONSTANT VARCHAR2(20) := App_Message_Stat_Type_API.DB_SEND;

NEW_LINE       CONSTANT VARCHAR2(1) := CHR(10);

TYPE Report_Context IS RECORD
  (trace      BOOLEAN,
   trace_text CLOB,
   spool_text CLOB);

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Security___ (
   method_ IN VARCHAR2) IS
BEGIN
   General_SYS.Check_Security(lu_name_, 'APP_MESSAGE_STAT_REPORT_API', method_);
END Check_Security___;


PROCEDURE Spool_Clob___(clob_ IN CLOB) IS
   offset_    NUMBER := 1;
   total_len_ NUMBER := length(clob_);
   line_len_  NUMBER;
   line_      VARCHAR2(32767);
BEGIN
   WHILE offset_ <= total_len_ LOOP
      line_len_ := instr(clob_, NEW_LINE, offset_) - offset_;
      IF line_len_ < 0 THEN
         line_len_ := total_len_ + 1 - offset_;
      END IF;
      line_ := substr(clob_, offset_, line_len_);
      Dbms_Output.Put_Line(line_);
      offset_ := offset_ + line_len_ + 1;
   END LOOP;
END Spool_Clob___;


PROCEDURE Trace___ (
   context_ IN OUT Report_Context,
   line_    IN     VARCHAR2 DEFAULT NULL) IS
BEGIN
   context_.trace_text := context_.trace_text || line_ || NEW_LINE;
END Trace___;


PROCEDURE Spool___ (
   context_ IN OUT Report_Context,
   line_    IN     VARCHAR2 DEFAULT NULL) IS
BEGIN
   context_.spool_text := context_.spool_text || line_ || NEW_LINE;
END Spool___;


FUNCTION Format_Pct___(pct_ NUMBER) RETURN VARCHAR2 IS
BEGIN
   RETURN to_char(pct_, '9999990.9');
END Format_Pct___;


--
-- Insert into temporary table APP_MESSAGE_STAT_INPUT_TAB set of valid InvokeAq
-- application message IDs matching input criteria.
-- Compute start_diff and end_diff between database and java timestamps.
--
PROCEDURE Insert_Report_Input___ (
   context_      IN OUT Report_Context,
   cluster_name_ IN     VARCHAR2,  -- INT, MAIN, %
   from_         IN     TIMESTAMP,
   to_           IN     TIMESTAMP)
IS
   t1_ NUMBER := Dbms_Utility.Get_Time;
   t2_ NUMBER;
BEGIN
   INSERT INTO app_message_stat_input_tab(application_message_id, start_diff, end_diff)
   SELECT application_message_id,
          --
          Batch_Processor_Test_API.Elapsed_Seconds((SELECT S.end_timestamp
                                                      FROM app_message_stat_local S
                                                     WHERE S.application_message_id = I.application_message_id
                                                       AND S.stat_type = DB_CREATE_AM)
                                                      ,
                                                   (SELECT S.start_timestamp
                                                      FROM app_message_stat_local S
                                                     WHERE S.application_message_id = I.application_message_id
                                                       AND S.stat_type = DB_FORWARD_MDB)) start_diff,
          --
          Batch_Processor_Test_API.Elapsed_Seconds((SELECT S.end_timestamp
                                                      FROM app_message_stat_local S
                                                     WHERE S.application_message_id = I.application_message_id
                                                       AND S.stat_type = DB_INVOKE_MDB)
                                                      ,
                                                   (SELECT S.end_timestamp
                                                      FROM app_message_stat_local S
                                                     WHERE S.application_message_id = I.application_message_id
                                                       AND S.stat_type = DB_INVOKE_AQ)) end_diff
     FROM (SELECT S.application_message_id
             FROM app_message_stat_local S
            WHERE S.start_timestamp >= from_
              AND S.end_timestamp <= to_
              AND (cluster_name_ = '%' OR EXISTS (SELECT NULL
                                                    FROM app_message_stat_local SS
                                                   WHERE SS.application_message_id = S.application_message_id
                                                     AND SS.stat_type = DB_FORWARD_MDB
                                                     AND SS.stat_category LIKE cluster_name_))
            GROUP BY S.application_message_id
            HAVING LISTAGG(stat_type, ',') WITHIN GROUP (ORDER BY stat_type) = 'CREATE_AM,FORWARD_MDB,INVOKE_AQ,INVOKE_MDB,PROCESS,SEND') I;

   t2_ := Dbms_Utility.Get_Time;
   Trace___(context_, 'Created ' || SQL%ROWCOUNT || ' rows in temporary table APP_MESSAGE_STAT_INPUT_TAB in ' || (t2_ - t1_) / 100 || ' sec');

   DELETE app_message_stat_input_tab WHERE ABS(start_diff) > 1000 OR ABS(end_diff) > 1000; -- Rows not corrected yet
   Trace___(context_, 'Deleted ' || SQL%ROWCOUNT || ' rows with invalid start_diff or end_diff');
END Insert_Report_Input___;


--
-- Compute and update DATABASE_SHIFT in temporary table APP_MESSAGE_STAT_INPUT_TAB
--
PROCEDURE Shift_Report_Data___ (
   context_ IN OUT Report_Context)
IS
   EPS                CONSTANT NUMBER := 0.010; --  10 ms
   MAX_DATABASE_SHIFT CONSTANT NUMBER := 0.3;   -- 300 ms

   CURSOR diff IS
   SELECT application_message_id, start_diff, end_diff
     FROM app_message_stat_input_tab
    WHERE start_diff < 0 OR end_diff < 0
    ORDER BY application_message_id;

   TYPE Diff_Tab IS TABLE OF diff%ROWTYPE;
   d_ Diff_Tab;

   TYPE Id_Tab IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
   ignore_list_ Id_Tab;

   count_    NUMBER := 0;
   db_shift_ NUMBER;

   t1_       NUMBER := Dbms_Utility.Get_Time;
   t2_       NUMBER;
   t3_       NUMBER;
BEGIN
   --
   -- Fetch rows that need correction
   --
   OPEN diff;
   FETCH diff BULK COLLECT INTO d_;
   CLOSE diff;

   t2_ := Dbms_Utility.Get_Time;
   Trace___(context_, 'Fetched ' || d_.COUNT || ' rows from temporary table APP_MESSAGE_STAT_INPUT_TAB in ' || (t2_ - t1_) / 100 || ' sec');

   FOR i IN 1 .. d_.COUNT LOOP
      --
      -- Compute database_shift
      --
      DECLARE
         start_db_shift_ NUMBER;
         end_db_shift_   NUMBER;
      BEGIN
         db_shift_ := NULL;

         IF d_(i).start_diff < 0 AND d_(i).end_diff + d_(i).start_diff >= -EPS THEN
            start_db_shift_ := d_(i).start_diff;
         END IF;

         IF d_(i).end_diff < 0 AND d_(i).start_diff - d_(i).end_diff >= -EPS THEN
            end_db_shift_ := -d_(i).end_diff;
         END IF;

         IF start_db_shift_ IS NULL AND end_db_shift_ IS NULL THEN  -- row will be ignored (cannot be corrected)
            db_shift_ := 0;
         ELSIF start_db_shift_ IS NOT NULL AND end_db_shift_ IS NOT NULL THEN -- Take bigger shift
            IF ABS(start_db_shift_) > ABS(end_db_shift_) THEN
               db_shift_ := start_db_shift_;
            ELSE
               db_shift_ := end_db_shift_;
            END IF;
         ELSIF start_db_shift_ IS NOT NULL THEN
            db_shift_ := start_db_shift_;
         ELSIF end_db_shift_ IS NOT NULL THEN
            db_shift_ := end_db_shift_;
         END IF;
      END;

      IF ABS(db_shift_) > MAX_DATABASE_SHIFT THEN
         db_shift_ := 0;
      END IF;

      UPDATE app_message_stat_input_tab
         SET database_shift = db_shift_
       WHERE application_message_id = d_(i).application_message_id;

      count_ := count_ + SQL%ROWCOUNT;
      --Trace___(context_, 'Updated: application_message_id=' || d_(i).application_message_id || ' database_shift=' || db_shift_ || ' rows=' || SQL%ROWCOUNT ||
      --    CASE db_shift_ = 0 WHEN TRUE THEN '   WARNING! This application message rows will be ignored by report.' END);
      IF db_shift_ = 0 THEN
         ignore_list_(ignore_list_.COUNT + 1) := d_(i).application_message_id;
      END IF;
   END LOOP;
   t3_ := Dbms_Utility.Get_Time;
   Trace___(context_, 'Updated DATABASE_SHIFT for ' || count_ || ' rows in ' || (t3_ - t2_) / 100 || ' sec');
   Trace___(context_, 'Updated ' || ignore_list_.COUNT || ' rows with DATABASE_SHIFT = 0. These rows will be ignored by report.');
   --FOR i IN 1 .. ignore_list_.COUNT LOOP
   --   Trace___(context_, ignore_list_(i));
   --END LOOP;
END Shift_Report_Data___;


--
-- Insert into temporary table APP_MESSAGE_STAT_REPORT_TAB rows from view APP_MESSAGE_STAT_REPORT
--
PROCEDURE Insert_Report_Output___ (
   context_       IN OUT Report_Context,
   app_msg_rows_     OUT NUMBER,
   min_timestamp_    OUT TIMESTAMP,
   max_timestamp_    OUT TIMESTAMP,
   skip_tail_     IN     BOOLEAN)
IS
   t1_      NUMBER := Dbms_Utility.Get_Time;
   t2_      NUMBER;
   deleted_ NUMBER;
BEGIN
   INSERT INTO app_message_stat_report_tab
     (application_message_id ,
      cluster_name           ,
      start_diff             ,
      end_diff               ,
      database_shift         ,
      invoke_aq_start_time   ,
      invoke_aq_end_time     ,
      invoke_aq_time         ,
      create_am_start_time   ,
      create_am_end_time     ,
      create_am_time         ,
      forward_mdb_start_time ,
      forward_mdb_end_time   ,
      forward_mdb_time       ,
      invoke_mdb_start_time  ,
      invoke_mdb_end_time    ,
      invoke_mdb_time        ,
      process_start_time     ,
      process_end_time       ,
      process_time           ,
      send_start_time        ,
      send_end_time          ,
      send_time              ,
      create_am_before       ,
      forward_mdb_before     ,
      invoke_mdb_before      ,
      process_before         ,
      process_after          ,
      send_before            ,
      send_after             ,
      invoke_mdb_after       ,
      pre_process_time       ,
      post_process_time)
   SELECT
      application_message_id ,
      cluster_name           ,
      start_diff             ,
      end_diff               ,
      database_shift         ,
      invoke_aq_start_time   ,
      invoke_aq_end_time     ,
      invoke_aq_time         ,
      create_am_start_time   ,
      create_am_end_time     ,
      create_am_time         ,
      forward_mdb_start_time ,
      forward_mdb_end_time   ,
      forward_mdb_time       ,
      invoke_mdb_start_time  ,
      invoke_mdb_end_time    ,
      invoke_mdb_time        ,
      process_start_time     ,
      process_end_time       ,
      process_time           ,
      send_start_time        ,
      send_end_time          ,
      send_time              ,
      create_am_before       ,
      forward_mdb_before     ,
      invoke_mdb_before      ,
      process_before         ,
      process_after          ,
      send_before            ,
      send_after             ,
      invoke_mdb_after       ,
      pre_process_time       ,
      post_process_time
   FROM app_message_stat_report;

   app_msg_rows_ := SQL%ROWCOUNT;

   IF skip_tail_ THEN
      DELETE app_message_stat_report_tab
       WHERE invoke_aq_time < 2;

      deleted_ := SQL%ROWCOUNT;
      app_msg_rows_ := app_msg_rows_ - deleted_;
      Trace___(context_, 'Ignored ' || deleted_ || ' AM rows with short InvokeAq time');

      DELETE app_message_stat_report_tab
       WHERE send_time > 60
         AND 100.0 * (invoke_aq_time - send_time) / invoke_aq_time < 10; -- wait_time_pct

      deleted_ := SQL%ROWCOUNT;
      app_msg_rows_ := app_msg_rows_ - deleted_;
      Trace___(context_, 'Ignored ' || deleted_ || ' AM rows with long Send time');
   END IF;

   SELECT MIN(invoke_aq_start_time), MAX(invoke_aq_end_time)
     INTO min_timestamp_, max_timestamp_
     FROM app_message_stat_report_tab;

   t2_ := Dbms_Utility.Get_Time;
   Trace___(context_, 'Created ' || app_msg_rows_ || ' AM rows in temporary table APP_MESSAGE_STAT_REPORT_TAB in ' || (t2_ - t1_) / 100 || ' sec');
END Insert_Report_Output___;


PROCEDURE Scan_Time_Events___ (
   context_ IN OUT Report_Context)
IS
   MAX_TIME_EVENT_ROWS CONSTANT NUMBER := 100000;

   CURSOR event IS
   SELECT application_message_id,
          stat_type,
          event_type,
          DECODE(event_type, 'START', 1, 'END', -1) delta,
          timestamp
     FROM (SELECT application_message_id, stat_type, start_time, end_time
             FROM (SELECT application_message_id ,
                          invoke_aq_start_time   ,
                          invoke_aq_end_time     ,
                          create_am_start_time   ,
                          create_am_end_time     ,
                          forward_mdb_start_time ,
                          forward_mdb_end_time   ,
                          invoke_mdb_start_time  ,
                          invoke_mdb_end_time    ,
                          process_start_time     ,
                          process_end_time       ,
                          send_start_time        ,
                          send_end_time
                     FROM app_message_stat_report_tab)
           UNPIVOT ((start_time, end_time) FOR stat_type IN ((invoke_aq_start_time,   invoke_aq_end_time    ) AS 'INVOKE_AQ',
                                                             (forward_mdb_start_time, forward_mdb_end_time  ) AS 'FORWARD_MDB',
                                                             (invoke_mdb_start_time,  invoke_mdb_end_time   ) AS 'INVOKE_MDB',
                                                             (send_start_time,        send_end_time         ) AS 'SEND',
                                                             (create_am_end_time,     forward_mdb_start_time) AS 'FORWARD_MDB_BEFORE',
                                                             (forward_mdb_end_time,   invoke_mdb_start_time ) AS 'INVOKE_MDB_BEFORE',
                                                             (process_start_time,     send_start_time       ) AS 'SEND_BEFORE')))
   UNPIVOT (timestamp FOR event_type IN (start_time AS 'START',
                                         end_time   AS 'END'))
   ORDER BY timestamp, application_message_id, 4 DESC, DECODE(stat_type, 'INVOKE_AQ',          1,
                                                                         'FORWARD_MDB_BEFORE', 2,
                                                                         'FORWARD_MDB',        3,
                                                                         'INVOKE_MDB_BEFORE',  4,
                                                                         'INVOKE_MDB',         5,
                                                                         'SEND_BEFORE',        6,
                                                                         'SEND',               7);

   TYPE Time_Events IS TABLE OF event%ROWTYPE;

   events_ Time_Events;

   TYPE Counter IS RECORD
     (current_count NUMBER := 0,
      max_count     NUMBER := 0,
      max_time      TIMESTAMP(6));

   empty_counter_ Counter;

   TYPE Counters IS TABLE OF Counter INDEX BY VARCHAR2(20); -- stat_type -> Counter

   counters_ Counters;

   TYPE Stat_Types IS TABLE OF VARCHAR2(20);

   stat_types_ Stat_Types := Stat_Types(DB_INVOKE_AQ, DB_FORWARD_MDB, DB_INVOKE_MDB, DB_SEND, 'FORWARD_MDB_BEFORE', 'INVOKE_MDB_BEFORE', 'SEND_BEFORE');

   t1_ NUMBER;
   t2_ NUMBER;
   t3_ NUMBER;

   PROCEDURE Update_Counter (
      current_count_ IN OUT NUMBER,
      max_count_     IN OUT NUMBER,
      max_time_      IN OUT TIMESTAMP,
      delta_         IN     NUMBER,
      timestamp_     IN     TIMESTAMP) IS
   BEGIN
      current_count_ := current_count_ + delta_;
      IF current_count_ > max_count_ THEN
         max_count_ := current_count_;
         max_time_  := timestamp_;
      END IF;
   END;

BEGIN
   t1_ := Dbms_Utility.Get_Time;
   OPEN event;
   FETCH event BULK COLLECT INTO events_;
   CLOSE event;
   t2_ := Dbms_Utility.Get_Time;
   Trace___(context_, 'Fetched ' || events_.COUNT || ' time event rows in ' || (t2_ - t1_) / 100 || ' sec');

   FOR t IN 1 .. stat_types_.COUNT LOOP
      counters_(stat_types_(t)) := empty_counter_;
   END LOOP;

   Trace___(context_);
   Trace___(context_, '(*) Time Events -> Waiting for Forward/Consume/Send Thread:');
   Trace___(context_);
   Trace___(context_, '   TIMESATMP                   APP_MSG_ID EVENT_TYPE STAT_TYPE                      FCS_WAIT#           INVOKE_AQ# FORWARD_MDB_BEFORE#        FORWARD_MDB#  INVOKE_MDB_BEFORE#         INVOKE_MDB#        SEND_BEFORE#               SEND#   WAITING (F=Forward C=Consume S=Send)');
   Trace___(context_, '   ----------------------- -------------- ---------- ------------------- -------------------- -------------------- ------------------- ------------------- ------------------- ------------------- ------------------- -------------------   ----------------------------------------------------------');
   FOR e IN 1 ..  events_.COUNT LOOP
      DECLARE
         stat_type_          VARCHAR2(20);
         forward_wait_count_ NUMBER;
         consume_wait_count_ NUMBER;
         send_wait_count_    NUMBER;
      BEGIN
         stat_type_ := events_(e).stat_type;
         Update_Counter(current_count_ => counters_(stat_type_).current_count,
                        max_count_     => counters_(stat_type_).max_count,
                        max_time_      => counters_(stat_type_).max_time,
                        delta_         => events_(e).delta,
                        timestamp_     => events_(e).timestamp);

         IF e <= MAX_TIME_EVENT_ROWS THEN
            forward_wait_count_ := counters_('FORWARD_MDB_BEFORE').current_count;
            consume_wait_count_ := counters_('INVOKE_MDB_BEFORE' ).current_count;
            send_wait_count_    := counters_('SEND_BEFORE'       ).current_count;
            Trace___(context_, '   ' ||
               Format_Timestamp(events_(e).timestamp) ||
               lpad(events_(e).application_message_id, 15) || ' '||
               rpad(events_(e).event_type, 11) ||
               rpad(events_(e).stat_type, 20) ||
               lpad(forward_wait_count_ + consume_wait_count_ + send_wait_count_, 20) ||
               lpad(counters_('INVOKE_AQ'         ).current_count, 20) ||
               lpad(counters_('FORWARD_MDB_BEFORE').current_count, 20) ||
               lpad(counters_('FORWARD_MDB'       ).current_count, 20) ||
               lpad(counters_('INVOKE_MDB_BEFORE' ).current_count, 20) ||
               lpad(counters_('INVOKE_MDB'        ).current_count, 20) ||
               lpad(counters_('SEND_BEFORE'       ).current_count, 20) ||
               lpad(counters_('SEND'              ).current_count, 20) || '   ' ||
               rpad('F', forward_wait_count_, 'F') ||
               rpad('C', consume_wait_count_, 'C') ||
               rpad('S', send_wait_count_   , 'S'));
         ELSIF e = MAX_TIME_EVENT_ROWS + 1 THEN
            Trace___(context_, '   Truncated after ' || MAX_TIME_EVENT_ROWS || ' Time Event rows.');
         END IF;
      END;
   END LOOP;
   t3_ := Dbms_Utility.Get_Time;
   Trace___(context_);
   Trace___(context_, 'Updated counters for ' || events_.COUNT || ' time event rows in ' || (t3_ - t2_) / 100 || ' sec');

   Spool___(context_);
   Spool___(context_, '   Max Concurrent Threads:');
   Spool___(context_);
   FOR t IN 1 .. stat_types_.COUNT LOOP
      Spool___(context_, '      ' || rpad(stat_types_(t), 20) ||
                                     lpad(counters_(stat_types_(t)).max_count, 5) || '  (' ||
                                     Format_Timestamp(counters_(stat_types_(t)).max_time) || ')'); -- max_app_msg_id?
   END LOOP;
END Scan_Time_Events___;


--
-- Spool time distribution report from APP_MESSAGE_STAT_REPORT_TAB,
-- via report views APP_MESSAGE_STAT_REPORT_SUM and APP_MESSAGE_STAT_REPORT_DIST
--
PROCEDURE Spool_Dist_Report___ (
   context_ IN OUT Report_Context)
IS
   CURSOR report_sum IS
   SELECT *
     FROM app_message_stat_report_sum;

   sum_ report_sum%ROWTYPE;

   CURSOR report_dist IS
   SELECT stat_type, time, frequency
     FROM app_message_stat_report_dist
    ORDER BY stat_type, time;

   TYPE Dist_Tab IS TABLE OF report_dist%ROWTYPE;

   dist_tab_ Dist_Tab;

   t1_ NUMBER;
   t2_ NUMBER;

   PROCEDURE Spool(type_ IN VARCHAR2, min_ IN NUMBER, max_ IN NUMBER, avg_ IN NUMBER, sum_ IN NUMBER) IS
      total_count_ NUMBER := 0;
      count_       NUMBER;

      PROCEDURE Spool_One(func_ IN VARCHAR2, time_ IN NUMBER) IS
      BEGIN
         Spool___(context_, '  ' || func_ || to_char(time_, '999999999990.99'));
      END;
   BEGIN
      Spool___(context_);
      Spool___(context_, upper(type_) || ' [sec]:');
      Spool___(context_);

      Spool_One('Min', min_);
      Spool_One('Max', max_);
      Spool_One('Avg', avg_);
      Spool_One('Sum', sum_);

      Spool___(context_);
      Spool___(context_, '      Time      Count');
      Spool___(context_, '  -------- ----------');
      FOR i IN 1 .. dist_tab_.COUNT LOOP
         IF dist_tab_(i).stat_type = type_ THEN
            count_       := dist_tab_(i).frequency;
            total_count_ := total_count_ + count_;
            Spool___(context_, to_char(dist_tab_(i).time, '9999990.9') ||' ' || lpad(count_, 10));
         END IF;
      END LOOP;
      Spool___(context_, '           ----------');
      Spool___(context_, '           ' || lpad(total_count_, 10));
   END;

   PROCEDURE Spool_Max(type_ IN VARCHAR2, max_ IN NUMBER) IS
   BEGIN
      Spool___(context_, '      ' || rpad(type_, 18) || to_char(max_, '99990.9') || ' sec');
   END;
BEGIN
   t1_ := Dbms_Utility.Get_Time;
   OPEN report_sum;
   FETCH report_sum INTO sum_;
   CLOSE report_sum;
   t2_ := Dbms_Utility.Get_Time;
   Trace___(context_, 'Fetched 1 row from APP_MESSAGE_STAT_REPORT_SUM in ' || (t2_ - t1_) / 100 || ' sec');

   t1_ := Dbms_Utility.Get_Time;
   OPEN report_dist;
   FETCH report_dist BULK COLLECT INTO dist_tab_;
   CLOSE report_dist;
   t2_ := Dbms_Utility.Get_Time;
   Trace___(context_, 'Fetched ' || dist_tab_.COUNT || ' rows from APP_MESSAGE_STAT_REPORT_DIST in ' || (t2_ - t1_) / 100 || ' sec');

   Spool___(context_);
   Spool___(context_, '   Wait Process Time:  ' || Format_Pct___(sum_.wait_time_pct)      || ' %');
   Spool___(context_, '   Wait Send Time:     ' || Format_Pct___(sum_.wait_send_time_pct) || ' %');
   Spool___(context_);
   Spool___(context_, '   Min Wait Send Time: ' || Format_Pct___(sum_.min_wait_time_pct)  || ' %');
   Spool___(context_, '   Max Wait Send Time: ' || Format_Pct___(sum_.max_wait_time_pct)  || ' %');
   Spool___(context_, '   Avg Wait Send Time: ' || Format_Pct___(sum_.avg_wait_time_pct)  || ' %');
   Spool___(context_);
   Spool___(context_, '   Max Wait Time [sec]:');
   Spool___(context_);
   Spool_Max('PRE_PROCESS_TIME'  , sum_.max_pre_process_time);
   Spool_Max('POST_PROCESS_TIME' , sum_.max_post_process_time);

   Spool_Max('CREATE_AM_BEFORE'   , sum_.max_create_am_before  );
   Spool_Max('CREATE_AM_TIME'     , sum_.max_create_am_time    );
   Spool_Max('FORWARD_MDB_BEFORE' , sum_.max_forward_mdb_before);
   Spool_Max('FORWARD_MDB_TIME'   , sum_.max_forward_mdb_time  );
   Spool_Max('INVOKE_MDB_BEFORE'  , sum_.max_invoke_mdb_before );
   Spool_Max('INVOKE_MDB_AFTER'   , sum_.max_invoke_mdb_after  );
   Spool_Max('PROCESS_BEFORE'     , sum_.max_process_before    );
   Spool_Max('SEND_BEFORE'        , sum_.max_send_before       );
   Spool_Max('PROCESS_AFTER'      , sum_.max_process_after     );
   Spool_Max('SEND_AFTER'         , sum_.max_send_after        );
   Spool___(context_);

   --
   -- The following two sums should match INVOKE_AQ_TIME sum, just to verify correctness
   --
   Spool___(context_, '   Sum Process Time: ' || to_char(round(sum_.sum_pre_process_time + sum_.sum_process_time + sum_.sum_post_process_time, 2)) || ' sec (Should match Sum INVOKE_AQ_TIME)');
   Spool___(context_, '   Sum Invoke Time:  ' || to_char(round(sum_.sum_create_am_before + sum_.sum_create_am_time + sum_.sum_forward_mdb_before + sum_.sum_forward_mdb_time + sum_.sum_invoke_mdb_before + sum_.sum_invoke_mdb_after + sum_.sum_process_before + sum_.sum_process_after + sum_.sum_send_before + sum_.sum_send_time + sum_.sum_send_after, 2)) || ' sec');
   Spool___(context_);
   Spool___(context_, '(*) Time Distribution:');
   Spool___(context_);

   Spool('INVOKE_AQ_TIME'    , sum_.min_invoke_aq_time    , sum_.max_invoke_aq_time    , sum_.avg_invoke_aq_time    , sum_.sum_invoke_aq_time    );

   Spool('CREATE_AM_BEFORE'  , sum_.min_create_am_before  , sum_.max_create_am_before  , sum_.avg_create_am_before  , sum_.sum_create_am_before  );
   Spool('CREATE_AM_TIME'    , sum_.min_create_am_time    , sum_.max_create_am_time    , sum_.avg_create_am_time    , sum_.sum_create_am_time    );

   Spool('FORWARD_MDB_BEFORE', sum_.min_forward_mdb_before, sum_.max_forward_mdb_before, sum_.avg_forward_mdb_before, sum_.sum_forward_mdb_before);
   Spool('FORWARD_MDB_TIME'  , sum_.min_forward_mdb_time  , sum_.max_forward_mdb_time  , sum_.avg_forward_mdb_time  , sum_.sum_forward_mdb_time  );

   Spool('INVOKE_MDB_BEFORE' , sum_.min_invoke_mdb_before , sum_.max_invoke_mdb_before , sum_.avg_invoke_mdb_before , sum_.sum_invoke_mdb_before );
   Spool('INVOKE_MDB_TIME'   , sum_.min_invoke_mdb_time   , sum_.max_invoke_mdb_time   , sum_.avg_invoke_mdb_time   , sum_.sum_invoke_mdb_time   );
   Spool('INVOKE_MDB_AFTER'  , sum_.min_invoke_mdb_after  , sum_.max_invoke_mdb_after  , sum_.avg_invoke_mdb_after  , sum_.sum_invoke_mdb_after  );

   Spool('PROCESS_BEFORE'    , sum_.min_process_before    , sum_.max_process_before    , sum_.avg_process_before    , sum_.sum_process_before    );
   Spool('PROCESS_TIME'      , sum_.min_process_time      , sum_.max_process_time      , sum_.avg_process_time      , sum_.sum_process_time      );
   Spool('PROCESS_AFTER'     , sum_.min_process_after     , sum_.max_process_after     , sum_.avg_process_after     , sum_.sum_process_after     );

   Spool('SEND_BEFORE'       , sum_.min_send_before       , sum_.max_send_before       , sum_.avg_send_before       , sum_.sum_send_before       );
   Spool('SEND_TIME'         , sum_.min_send_time         , sum_.max_send_time         , sum_.avg_send_time         , sum_.sum_send_time         );
   Spool('SEND_AFTER'        , sum_.min_send_after        , sum_.max_send_after        , sum_.avg_send_after        , sum_.sum_send_after        );

   Spool('PRE_PROCESS_TIME'  , sum_.min_pre_process_time  , sum_.max_pre_process_time  , sum_.avg_pre_process_time  , sum_.sum_pre_process_time  );
   Spool('POST_PROCESS_TIME' , sum_.min_post_process_time , sum_.max_post_process_time , sum_.avg_post_process_time , sum_.sum_post_process_time );
END Spool_Dist_Report___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

--
-- Generate Invoke AQ report for specified input criteria
--
--  (1) Insert into temporary table APP_MESSAGE_STAT_INPUT_TAB set of valid
--      application message IDs matching input criteria. Compute start_diff
--      and end_diff between database and java timestamps.
--
--  (2) Compute and update DATABASE_SHIFT in temporary table APP_MESSAGE_STAT_INPUT_TAB.
--
--  (3) Insert into temporary table APP_MESSAGE_STAT_REPORT_TAB rows from view APP_MESSAGE_STAT_REPORT.
--
--  (4) Spool time distribution report from APP_MESSAGE_STAT_REPORT_TAB,
--      via report views APP_MESSAGE_STAT_REPORT_SUM and APP_MESSAGE_STAT_REPORT_DIST.
--
--                                     -*-
--
-- The following timing events, defined by enumeration AppMessageStatType, are registered at runtime,
-- if J2EE_SERVER property ifs.enableApplicationMessageStat=true:
--
--    INVOKE_AQ   - Plsqlap_Server_API.Invoke_Aq___
--    CREATE_AM   - Plsqlap_Server_API.Invoke_Aq___
--    FORWARD_MDB - AbstractMessageDrivenBean.onMessage()
--    INVOKE_MDB  - AbstractMessageDrivenBean.onMessage()
--    PROCESS     - MessageProcessor.processMessage()
--    SEND        - ConnectSenderManager.waitForWorkCompletion()
--
-- The following events are computed from the registered ones:
--
--    CREATE_AM_BEFORE
--    FORWARD_MDB_BEFORE
--    INVOKE_MDB_BEFORE
--    PROCESS_BEFORE
--    SEND_BEFORE
--
--    INVOKE_MDB_AFTER
--    PROCESS_AFTER
--    SEND_AFTER
--
--    PRE_PROCESS
--    POST_PROCESS
--
--  -------------------------------------------------------------------------------------------------------
--  |                     PRE_PROCESS                             |        PROCESS        | POST_PROCESS  |
--  -------------------------------------------------------------------------------------------------------
--
--                                                                -------------------------
--                                                                | BEFORE | SEND | AFTER |
--                                                       ------------------------------------------
--                                                       | BEFORE |         PROCESS       | AFTER |
--  -------------------------------------------------------------------------------------------------------
--  | BEFORE | CREATE_AM | BEFORE | FORWARD_MDB | BEFORE |             INVOKE_MDB                 | AFTER |
--  -------------------------------------------------------------------------------------------------------
--  |                                             INVOKE_AQ                                               |
--  -------------------------------------------------------------------------------------------------------
--
--                                     -*-
--
--   Wait Process Time[%] = (PRE_PROCESS + POST_PROCESS) / INVOKE_AQ
--   Wait Send Time[%]    = (INVOKE_AQ - SEND) / INVOKE_AQ
--
PROCEDURE Generate_Invoke_Aq_Report_ (
   cluster_name_ IN VARCHAR2,  -- INT, MAIN, %
   from_         IN TIMESTAMP,
   to_           IN TIMESTAMP,
   skip_tail_    IN BOOLEAN)
IS
   context_ Report_Context;

   app_msg_rows_  NUMBER;
   min_timestamp_ TIMESTAMP(6);
   max_timestamp_ TIMESTAMP(6);

   t1_ NUMBER := Dbms_Utility.Get_Time;
   t2_ NUMBER;
BEGIN
   Check_Security___('Generate_Invoke_Aq_Report_');
   --
   -- Commit to clear report temporary tables
   --
   @ApproveTransactionStatement(2018-03-09,madrse)
   COMMIT;

   Insert_Report_Input___(context_, cluster_name_, from_, to_);
   Shift_Report_Data___(context_);
   Insert_Report_Output___(context_, app_msg_rows_, min_timestamp_, max_timestamp_, skip_tail_);

   Spool___(context_, 'Invoke AQ Report');
   Spool___(context_, '================');
   Spool___(context_);
   Spool___(context_, '(*) Input:');
   Spool___(context_);
   Spool___(context_, '   Cluster:          ' || cluster_name_);
   Spool___(context_, '   From:             ' || Format_Timestamp(from_));
   Spool___(context_, '   To:               ' || Format_Timestamp(to_));
   Spool___(context_);
   Spool___(context_, '(*) Result:');
   Spool___(context_);
   Spool___(context_, '   App Msg rows:     ' || app_msg_rows_);
   Spool___(context_, '   Min Timestamp:    ' || Format_Timestamp(min_timestamp_));
   Spool___(context_, '   Max Timestamp:    ' || Format_Timestamp(max_timestamp_));

   Scan_Time_Events___(context_);
   Spool_Dist_Report___(context_);
   Spool___(context_);
   Spool___(context_);

   t2_ := Dbms_Utility.Get_Time;
   Trace___(context_, 'Generated Invoke AQ report for ' || app_msg_rows_ || ' application messages in ' || (t2_ - t1_) / 100 || ' sec');
   Trace___(context_);

   Spool_Clob___(context_.spool_text);
   Spool_Clob___(context_.trace_text);
END Generate_Invoke_Aq_Report_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Format_Timestamp (
   timestamp_ IN TIMESTAMP) RETURN VARCHAR2 IS
BEGIN
   RETURN to_char(timestamp_, 'YYYY-MM-DD HH24:MI:SS,FF3');
END Format_Timestamp;

