-----------------------------------------------------------------------------
--
--  Logical unit: DeliveryRouteException
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200610  Hahalk  Bug 152982 (SCZ-9584), Changed the ship_time value in Check_Insert___ into default value.
--  181123  Fgusse  SCUXXW4-9247, Changed default date on ship_time in Check_Insert___.
--  150319  ChFolk  Moved code from ORDER. 
--  150317  ChFolk  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_   VARCHAR2(5) := User_Default_API.Get_Contract;
BEGIN
   super(attr_);
   IF (contract_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);      
   END IF;
   Client_SYS.Add_To_Attr('ORDER_STOP_DAYS', 0, attr_);
   Client_SYS.Add_To_Attr('EXCEPTION_TYPE', Deliv_Route_Exception_Type_API.Decode('NEW'), attr_);
   Client_SYS.Add_To_Attr('EXCEPTION_TYPE_DB', 'NEW', attr_);   
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT delivery_route_exception_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   calendar_id_            VARCHAR2(10);
   week_day_db_            NUMBER;
   ship_time_              DATE; 
   route_schedule_exist_   BOOLEAN;
   route_exp_date_on_ship_date_  VARCHAR2(5) := 'FALSE';
BEGIN
   newrec_.ship_time := TO_DATE(REPLACE('0001-01-01 00:00:00', '00:00:00', TO_CHAR(newrec_.ship_time, 'HH24:MI:SS')), Report_SYS.datetime_format_);
   super(newrec_, indrec_, attr_);

   calendar_id_ := Site_API.Get_Dist_Calendar_Id(newrec_.contract);
   week_day_db_ := Work_Time_Week_Day_API.Encode(Work_Time_Calendar_API.Get_Week_Day(newrec_.exception_date));
   route_schedule_exist_ := Delivery_Route_Schedule_API.Check_Exist(newrec_.route_id, week_day_db_, newrec_.ship_time);
   -- Date factor of ship_time, has replaced by date factor of exception_date and use it in Work_Time_Calendar_API.Is_Working_Time
   -- to check whether the ship time is valid working time. 
   ship_time_ := TO_DATE(TO_CHAR(newrec_.exception_date, Report_SYS.date_format_)|| TO_CHAR(newrec_.ship_time, Report_SYS.time_format_), Report_SYS.datetime_format_);
      
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   IF (TO_CHAR(newrec_.exception_date, Report_SYS.date_format_) < TO_CHAR(Site_API.Get_Site_Date(newrec_.contract), Report_SYS.date_format_)) THEN
      Error_SYS.Record_General(lu_name_, 'EARLYEXPDATE: Exception date is earlier than today.');         
   END IF;
   IF (newrec_.exception_type = 'NEW') THEN
      IF (NVL(Work_Time_Calendar_API.Is_Working_Day(calendar_id_, newrec_.exception_date), 0) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NONWORKINGDAY: Exception date is not a working date of calendar :P1.', calendar_id_);      
      END IF;   
      IF (NVL(Work_Time_Calendar_API.Is_Working_Time_For_Time(calendar_id_, ship_time_), 0) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NONWORKINGTIME: Ship time is not a valid working time.');      
      END IF;
   END IF;   
   IF (newrec_.exception_type = 'NEW') AND (route_schedule_exist_) THEN 
      Error_SYS.Record_General(lu_name_, 'EXISTINSCHEDULE: A record already exists for this route day and ship time.');      
   END IF; 
   IF (newrec_.exception_type = 'CANCEL') AND (NOT route_schedule_exist_) THEN
      Error_SYS.Record_General(lu_name_, 'NOENTRYINSCHEDULE: There is no valid entry in route schedule to cancel.');         
   END IF;
   $IF Component_Order_SYS.INSTALLED $THEN
      route_exp_date_on_ship_date_ := Customer_Order_Line_API.Is_Route_Excp_Date_On_Shipdate(newrec_.contract, newrec_.route_id, ship_time_);
   $END
   IF (newrec_.exception_type = 'CANCEL') AND (route_exp_date_on_ship_date_ = 'TRUE') THEN
      Client_SYS.Add_Info(lu_name_, 'ORDLINESHIPDATE: There are customer order lines which are not fully delivered that have a ship date and time similar to the exception date and time entered.');
   END IF;
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_Cancel_Exceptions_Exist (
   route_id_      IN VARCHAR2,
   route_day_db_  IN VARCHAR2,
   ship_time_     IN DATE )
IS
   dummy_ NUMBER := 0;
   CURSOR check_Exist IS
      SELECT 1
      FROM  delivery_route_exception_tab
         WHERE route_id = route_id_         
         AND   Work_Time_Week_Day_API.Encode(Work_Time_Calendar_API.Get_Week_Day(exception_date)) = route_day_db_
         AND   exception_type = 'CANCEL'
         AND   TO_CHAR(ship_time, Report_SYS.time_format_) = TO_CHAR(ship_time_, Report_SYS.time_format_);
BEGIN
   OPEN check_Exist;
   FETCH check_Exist INTO dummy_;
   CLOSE check_Exist;
   IF (dummy_ = 1) THEN
      Error_SYS.Record_General(lu_name_,'CANCELEXCEPEXIST: Route departure has a connected route schedule exception. Please remove the exception(s) first.');   
   END IF;
END Check_Cancel_Exceptions_Exist;
