--------------------------------------------------------------------------------------------------------
--
--  File        : POST_Invent_SetDbValuesInBatchScheduleParTab.sql
--
--  Module      : INVENT 14.0.0
--
--  Purpose     : Replace client values with database values stored in schedule task parameters.
--                Applies to schedule methods INVENT_TRANSACTION_REPORT_API.CREATE_INV_TRANS_REPORT__ and
--                CLASSIFY_INVENTORY_PART_API.CLASSIFY. Client values in different languages will be encoded
--                after finding the language.Then the client value will be replaced with the encoded db value.
--
--  Date     Sign    History
--  ------   ------  -----------------------------------------------------------------------------------
--  121010   MaMalk  Bug 102071, Created.
--------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_SetDbValuesInBatchScheduleParTab.sql','Timestamp_1');
PROMPT Starting POST_Invent_SetDbValuesInBatchScheduleParTab

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_SetDbValuesInBatchScheduleParTab.sql','Timestamp_2');
PROMPT Replacing client values with database values in batch_schedule_par_tab.

BEGIN
   DECLARE
      client_value_  VARCHAR2(4000);
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
         AND bsm.module = 'INVENT'
         AND bsm.method_name IN ('INVENT_TRANSACTION_REPORT_API.CREATE_INV_TRANS_REPORT__', 'CLASSIFY_INVENTORY_PART_API.CLASSIFY',
             'WAREHOUSE_TASK_API.CALC_ACT_SETUP_TIME_NEEDED', 'WAREHOUSE_TASK_API.CALC_ACT_TASK_TYPE_EFF_RATE', 'INVENTORY_PART_IN_STOCK_API.OPTIMIZE_USING_PUTAWAY')
         AND bsp.name IN ('GROUP_PER_WAREHOUSE', 'GROUP_PER_USER', 'GROUP_PER_ORDER', 'PRINT_COST', 'COST_TYPE_', 'TASK_TYPE_', 'LOCATION_TYPE')
      FOR UPDATE OF bsp.value;
   BEGIN
      -- Get the current language.
      prev_lng_code_ := Fnd_Session_API.Get_Language();
      FOR rec_ IN get_rec LOOP
         IF (rec_.name = 'COST_TYPE_') THEN
            client_value_ := rec_.value;
            OPEN  get_lng_code('INVENT', 'InventoryCostType.%', client_value_);
            FETCH get_lng_code INTO lng_code_;
            IF (get_lng_code%NOTFOUND) THEN
               lng_code_ := 'en';
            END IF;
            CLOSE get_lng_code;

            -- Set the language code found and get the correct db value. Set to en if it is null.
            -- Non translated values can be retrived by setting to en.

            Fnd_Session_API.Set_Language(lng_code_);
            Inventory_Cost_Type_API.Language_Refreshed();
            -- Encode the client value after setting the language.
            db_value_ := Inventory_Cost_Type_API.Encode(client_value_);

            -- Null check to stop updating the second time.
            IF (db_value_ IS NOT NULL) THEN
               UPDATE batch_schedule_par_tab
               SET VALUE = db_value_
               WHERE CURRENT OF get_rec;
            END IF;
         ELSIF (rec_.name IN ('GROUP_PER_WAREHOUSE', 'GROUP_PER_USER', 'GROUP_PER_ORDER', 'PRINT_COST')) THEN
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
         ELSIF (rec_.name = 'TASK_TYPE_') THEN
            client_value_ := rec_.value;
            OPEN  get_lng_code('INVENT', 'WarehouseTaskType.%', client_value_);
            FETCH get_lng_code INTO lng_code_;
            IF (get_lng_code%NOTFOUND) THEN
               lng_code_ := 'en';
            END IF;
            CLOSE get_lng_code;

            Fnd_Session_API.Set_Language(lng_code_);
            Warehouse_Task_Type_API.Language_Refreshed();
            db_value_ := Warehouse_Task_Type_API.Encode(client_value_);

            IF(db_value_ IS NOT NULL) THEN
               UPDATE batch_schedule_par_tab
               SET VALUE = db_value_
               WHERE CURRENT OF get_rec;
            END IF;
         ELSIF (rec_.name = 'LOCATION_TYPE') THEN
            client_value_ := rec_.value;
            OPEN  get_lng_code('INVENT', 'InventoryLocationType.%', client_value_);
            FETCH get_lng_code INTO lng_code_;
            IF (get_lng_code%NOTFOUND) THEN
               lng_code_ := 'en';
            END IF;
            CLOSE get_lng_code;

            Fnd_Session_API.Set_Language(lng_code_);
            Inventory_Location_Type_API.Language_Refreshed();
            db_value_ := Inventory_Location_Type_API.Encode(client_value_);

            IF (db_value_ IS NOT NULL) THEN
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

PROMPT Finished with POST_Invent_SetDbValuesInBatchScheduleParTab.sql
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_SetDbValuesInBatchScheduleParTab.sql','Done');
