------------------------------------------------------------------------------------------
--
--  Filename      : POST_ORDER_RemoveWebstoreBatchSchedules.sql
--
--  Module        : ORDER
--
--  Purpose       : Removal of obsolete WebStore Batch Schedules
--
--
--  Date    Sign    History
--  ------  ------  ----------------------------------------------------------------------------------
--  160210  HaPulk  STRSC-388, Removal of Batch Schedules since Webstore functionality is obsoleted
------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_RemoveWebstoreBatchSchedules.sql','Timestamp_1');
PROMPT Removal of Webstore Batch Schedules...
DECLARE
  PROCEDURE Remove_Batch_Schedule_(method_name_ IN VARCHAR2)
  IS
     schedule_method_id_    NUMBER;
     CURSOR get_schedule(schedule_method_id_ NUMBER) IS
        SELECT schedule_id
          FROM batch_schedule_pub
         WHERE schedule_method_id = schedule_method_id_;
  BEGIN
     schedule_method_id_ := Batch_Schedule_Method_API.Get_Schedule_Method_Id(method_name_);
     IF (schedule_method_id_ IS NOT NULL) THEN
        FOR sched_rec_ IN get_schedule(schedule_method_id_) LOOP
           BATCH_SYS.Remove_Batch_Schedule(sched_rec_.schedule_id);
        END LOOP;
        BATCH_SYS.Remove_Batch_Schedule_Method(method_name_);
        COMMIT;
     END IF;
  END Remove_Batch_Schedule_;
BEGIN
   Remove_Batch_Schedule_('ORDER_WEBSTORE_UTIL_API.EXPORT_CUSTOMERS__');
   Remove_Batch_Schedule_('ORDER_WEBSTORE_UTIL_API.EXPORT_PRODUCTS__');
   Remove_Batch_Schedule_('ORDER_WEBSTORE_UTIL_API.GET_WEBSTORE_ORDER__');

   -- DROP Package should be done after removing all BatchSchedules due to the dependency in batch_schedule_pub
   Database_SYS.Remove_Package('ORDER_WEBSTORE_UTIL_API', TRUE);
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_RemoveWebstoreBatchSchedules.sql','Timestamp_2');
PROMPT Removal of Webstore Press Objects...
DECLARE
BEGIN
   Pres_Object_Util_API.Remove_Pres_Object('taskOrder_Webstore_Util_Api.Export_Customers__', 'Manual');
   Pres_Object_Util_API.Remove_Pres_Object('taskOrder_Webstore_Util_Api.Export_Products__', 'Manual');
   Pres_Object_Util_API.Remove_Pres_Object('taskOrder_Webstore_Util_Api.Get_Webstore_Order__', 'Manual');
   COMMIT;
END;
/
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_RemoveWebstoreBatchSchedules.sql','Done');

