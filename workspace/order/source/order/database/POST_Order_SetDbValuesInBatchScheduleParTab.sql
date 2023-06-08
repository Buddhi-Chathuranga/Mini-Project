--------------------------------------------------------------------------------------------------------
--
--  File        : POST_Order_SetDbValuesInBatchScheduleParTab.sql
--
--  Module      : ORDER 14.0.0
--
--  Purpose     : Replace client values with database values stored in schedule task parameters.
--                Applies to schedule methods CREATE_PICK_LIST_API.CREATE_CONSOL_PICK_LIST__, CUST_ORD_STAT_UTIL_API.GENERATE_CUST_ORD_STAT
--                and RESERVE_CUSTOMER_ORDER_API.BATCH_RESERVE_ORDERS__. Client values in different languages will be encoded after finding the
--                language. Then the client value will be replaced with the encoded db value.
--                The previous file was obsoleted because, earlier variable lng_code_ could have an older value of a previous iteration,
--                if the current iteration does not returns a value.
--
--  Date     Sign    History
--  ------   ------  -----------------------------------------------------------------------------------
--  200923   MaRalk  SC2020R1-9694, Removed Patch Registration when preparing the file for 2020R1 Release.
--  121012   NipKlk  Bug 102071, Created.
--------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_SetDbValuesInBatchScheduleParTab.sql','Timestamp_1');
PROMPT Starting POST_Order_SetDbValuesInBatchScheduleParTab.sql

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_SetDbValuesInBatchScheduleParTab.sql','Timestamp_2');
PROMPT Replacing client values with database values in batch_schedule_par_tab.

BEGIN
   DECLARE
      client_value_  VARCHAR2(2000);
      db_value_      VARCHAR2(50);
      lng_code_      VARCHAR2(5);
      prev_lng_code_ VARCHAR2(5);

   CURSOR get_lng_code(module_ VARCHAR2, path_ VARCHAR2, text_ VARCHAR2) IS
      SELECT lang_code
        FROM language_translation_loc
       WHERE module = module_ AND path LIKE path_ AND text = text_ AND main_type = 'LU' AND status_db = 'O';

   CURSOR get_rec IS
      SELECT bsp.name, bsp.value
        FROM batch_schedule_tab bs, batch_schedule_method_tab bsm, batch_schedule_par_tab bsp
       WHERE bs.schedule_id = bsp.schedule_id
         AND bsm.schedule_method_id = bs.schedule_method_id
         AND bsm.module = 'ORDER'
         AND bsm.method_name IN ('CREATE_PICK_LIST_API.CREATE_CONSOL_PICK_LIST__', 'CUST_ORD_STAT_UTIL_API.GENERATE_CUST_ORD_STAT', 'RESERVE_CUSTOMER_ORDER_API.BATCH_RESERVE_ORDERS__')
         AND bsp.name IN ('CONSOLIDATE', 'PICK_ALL_THE_LINES_IN_CO', 'IGNORE_EXISTING_SHIPMENT', 'ISSUE_', 'RESERVE_ALL_LINES_CO', 'FAIR_SHARE_RES')
      FOR UPDATE OF bsp.value;
   BEGIN      
      -- Get the current language.
      prev_lng_code_ := Fnd_Session_API.Get_Language();
      FOR rec_ IN get_rec LOOP
         IF (rec_.name = 'CONSOLIDATE') THEN
            client_value_ := rec_.value;
            OPEN  get_lng_code('ORDER', 'PickListConsolidation.%', client_value_);
            FETCH get_lng_code INTO lng_code_;
            IF (get_lng_code%NOTFOUND) THEN
               lng_code_ := 'en';
            END IF;
            CLOSE get_lng_code;

            -- Set the language code found and get the correct db value.
            Fnd_Session_API.Set_Language(lng_code_);
            Pick_List_Consolidation_API.Language_Refreshed();

            -- Encode the client value after setting the language.
            db_value_ := Pick_List_Consolidation_API.Encode(client_value_);
            -- Null check to stop updating the second time.
            IF (db_value_ IS NOT NULL) THEN
               UPDATE batch_schedule_par_tab
               SET VALUE = db_value_
               WHERE CURRENT OF get_rec;
            END IF;
         ELSIF (rec_.name = 'ISSUE_') THEN
            client_value_ := rec_.value;
            OPEN  get_lng_code('ORDER', 'OrdAggregateIssue.%', client_value_);
            FETCH get_lng_code INTO lng_code_;
            IF (get_lng_code%NOTFOUND) THEN
               lng_code_ := 'en';
            END IF;
            CLOSE get_lng_code;

            Fnd_Session_API.Set_Language(lng_code_);
            Ord_Aggregate_Issue_API.Language_Refreshed();

            db_value_ := Ord_Aggregate_Issue_API.Encode(client_value_);
            IF(db_value_ IS NOT NULL) THEN
               UPDATE batch_schedule_par_tab
               SET VALUE = db_value_
               WHERE CURRENT OF get_rec;
            END IF;
         ELSIF (rec_.name IN ('PICK_ALL_THE_LINES_IN_CO', 'IGNORE_EXISTING_SHIPMENT', 'RESERVE_ALL_LINES_CO', 'FAIR_SHARE_RES')) THEN
            client_value_ := rec_.value;
            OPEN  get_lng_code('FNDBAS', 'FndBoolean.%', client_value_);
            FETCH get_lng_code INTO lng_code_;
            IF (get_lng_code%NOTFOUND) THEN
               lng_code_ := 'en';
            END IF;
            CLOSE get_lng_code;

            Fnd_Session_API.Set_Language(lng_code_);
            Fnd_Boolean_API.Language_Refreshed();

            db_value_ := Fnd_Boolean_API.Encode(client_value_);
            IF(db_value_ IS NOT NULL) THEN
               UPDATE batch_schedule_par_tab
               SET VALUE = db_value_
               WHERE CURRENT OF get_rec;
            END IF;
         END IF;
      END LOOP;
      -- Set the initial language once again.
      Fnd_Session_API.Set_Language(prev_lng_code_);      
      COMMIT;      
   END;
END;
/

PROMPT Finished with POST_Order_SetDbValuesInBatchScheduleParTab.sql
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_SetDbValuesInBatchScheduleParTab.sql','Done');
