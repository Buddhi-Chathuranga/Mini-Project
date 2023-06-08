-----------------------------------------------------------------------------
--
--  Logical unit: DeliveryRouteSchedule
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200610  Hahalk  Bug 152982 (SCZ-9584), Changed the ship_time value in Check_Insert___ into default value.
--  181123  Fgusse  SCUXXW4-9247, Changed default date on ship_time in Check_Insert___.
--  151202  AwWelk  GEN-729, Added Check_Exist().
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
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ORDER_STOP_DAYS', 0, attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     delivery_route_schedule_tab%ROWTYPE,
   newrec_ IN OUT delivery_route_schedule_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.order_stop_days < 0) OR (newrec_.order_stop_days != trunc(newrec_.order_stop_days, 0)) THEN
      Error_SYS.Record_General(lu_name_, 'ORDERSTOP_DAYS: The number of days before route day must be a positive integer.');
   END IF;
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT delivery_route_schedule_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);

   newrec_.ship_time := TO_DATE(REPLACE('0001-01-01 00:00:00', '00:00:00', TO_CHAR(newrec_.ship_time, 'HH24:MI:SS')), Report_SYS.datetime_format_);

END Check_Insert___;

@Override
PROCEDURE Check_Delete___ (
    remrec_ IN     delivery_route_schedule_tab%ROWTYPE )
IS
BEGIN
   Delivery_Route_Exception_API.Check_Cancel_Exceptions_Exist(remrec_.route_id, remrec_.route_day, remrec_.ship_time);
   super(remrec_);   
END Check_Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   route_id_     IN VARCHAR2,
   route_day_db_ IN VARCHAR2,
   ship_time_    IN DATE ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   DELIVERY_ROUTE_SCHEDULE_TAB
      WHERE  route_id = route_id_
       AND   route_day = route_day_db_
       AND   TO_CHAR(ship_time, Report_SYS.time_format_) = TO_CHAR(ship_time_, Report_SYS.time_format_);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END;

@UncheckedAccess
FUNCTION Check_Exist (
   route_id_     IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   DELIVERY_ROUTE_SCHEDULE_TAB
      WHERE  route_id = route_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END;


@UncheckedAccess
FUNCTION Get_Order_Stop_Days (
   route_id_ IN VARCHAR2,
   route_day_ IN VARCHAR2,
   ship_time_ IN DATE ) RETURN NUMBER
IS
   temp_ DELIVERY_ROUTE_SCHEDULE_TAB.order_stop_days%TYPE;
   CURSOR get_attr IS
      SELECT order_stop_days
      FROM   DELIVERY_ROUTE_SCHEDULE_TAB
      WHERE  route_id = route_id_
       AND   route_day = (select Work_Time_Week_Day_API.Encode(route_day_) from dual)
       AND   TO_CHAR(ship_time, Report_SYS.time_format_) = TO_CHAR(ship_time_, Report_SYS.time_format_);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Order_Stop_Days;


@UncheckedAccess
FUNCTION Get_Order_Stop_Time (
   route_id_ IN VARCHAR2,
   route_day_ IN VARCHAR2,
   ship_time_ IN DATE ) RETURN DATE
IS
   temp_ DELIVERY_ROUTE_SCHEDULE_TAB.order_stop_time%TYPE;
   CURSOR get_attr IS
      SELECT order_stop_time
      FROM   DELIVERY_ROUTE_SCHEDULE_TAB
      WHERE  route_id = route_id_
       AND   route_day = (select Work_Time_Week_Day_API.Encode(route_day_) from dual)
       AND   TO_CHAR(ship_time, Report_SYS.time_format_) = TO_CHAR(ship_time_, Report_SYS.time_format_);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Order_Stop_Time;