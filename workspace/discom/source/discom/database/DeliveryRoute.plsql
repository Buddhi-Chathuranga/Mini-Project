-----------------------------------------------------------------------------
--
--  Logical unit: DeliveryRoute
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210505  JoWise  MF21R2-1486, Added method to fetch time from Route Schedule and add that time to a input date
--  180403  Cpeilk  Bug 140780, Modified Get_Possible_Route_Date to raise an error when work day is outside the range of calender.
--  160120  TiRalk  STRSC-867, Added Is_Valid_Route_Day to validate planned arrival date will fall within a route day.
--  151202  AwWelk  GEN-729, Added Route_Day_Rec, Route_Day_Info_Tab types and Get_Forward_Route_Dates().
--  150818  AwWelk  GEN-673, Added Get_Previous_Del_And_Ord_Date() to get the previous closest route_delivery_date_ and route_order_date_.
--  150625  SuSalk  ORA-751, Added Get_Next_Time_Slot, Is_Delivery_Day, Get_Number_Of_Time_Slots and Get_Next_Delivery_Date methods.
--  150615  ChFolk  ORA-742, Added new method Calc_Deliv_Dates_From_Route___ and modified methods Get_Previous_Route_Date and Calc_Delivery_Dates_From_Route to use that method.
--  150604  ChFolk  ORA-518, Added new method Calc_Delivery_Dates_From_Route which returns latest_route_date and latest_order_date based on the route_information.
--  150527  ChFolk  ORA-513, Modified Get_Possible_Route_Date to remove parameters  vendor_no and  vendor_addr as supplier caledar is no longer used
--  150527          used for route date calculation instead the distribution calendaer is now used. Also added the condition to check working day in distribution calendar. 
--  150427  ChFolk  Added new method Get_Previous_Route_Date o be used in purchasing when calculating planned delivery date from planned receipt date.
--  150424  ChFolk  Added new method Get_Possible_Route_Date which calculate possible route date for purchasing.
--  150319  ChFolk  Moved code from ORDER. 
--  150317  ChFolk  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Route_Day_Rec IS RECORD
  (route_day DATE,
   order_stop_days NUMBER,
   order_stop_time DATE);
   
TYPE Route_Day_Info_Tab IS TABLE OF Route_Day_Rec INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------
compare_dates_         CONSTANT DATE := TO_DATE('19790101', 'YYYYMMDD', 'NLS_CALENDAR=GREGORIAN');

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Next_Route_Id___
--   Returns the next available route id.
FUNCTION Get_Next_Route_Id___ RETURN VARCHAR2
IS
   route_id_ DELIVERY_ROUTE_TAB.route_id%TYPE;   
   exist_    BOOLEAN := TRUE;   
BEGIN   
   WHILE (exist_) LOOP
      SELECT to_char(route_seq.nextval)
      INTO route_id_ 
      FROM dual;
      exist_ := Check_Exist___(route_id_);
   END LOOP;
   RETURN route_id_;   
END Get_Next_Route_Id___;


-- Check_Time___
--   Checks the timestamp to see if the delivery time (route departure date/time)
--   is greater than the ship time (route's time).
FUNCTION Check_Time___ (
   delivery_date_ IN DATE,
   ship_date_     IN DATE ) RETURN BOOLEAN
IS
   deliver_ BOOLEAN := FALSE;
BEGIN
   IF (to_char(delivery_date_, 'HH24:MI:SS') = '00:00:00') THEN
      deliver_ := TRUE;
   ELSIF (to_char(ship_date_, 'HH24:MI:SS') != '00:00:00') THEN
      IF (to_char(delivery_date_, 'HH24:MI:SS') >= to_char(ship_date_, 'HH24:MI:SS')) THEN
         deliver_ := TRUE;
      END IF;
   END IF;
   RETURN deliver_;
END Check_Time___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CHECK_ON_LINE_LEVEL_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT DELIVERY_ROUTE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.route_id := nvl(newrec_.route_id, Get_Next_Route_Id___);
   Client_SYS.Add_To_Attr('ROUTE_ID', newrec_.route_id, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;
   

PROCEDURE Calc_Deliv_Dates_From_Route___ (
   best_route_departure_date_  OUT DATE,
   close_latest_order_date_    OUT DATE,
   route_id_                   IN  VARCHAR2,
   start_date_                 IN  DATE, 
   contract_                   IN  VARCHAR2,
   date_entered_               IN  DATE )
IS
   route_departure_date_    DATE;
   week_day_db_             VARCHAR2(20);
   timestamp_               VARCHAR2(20);
   stop_days_               NUMBER;
   stop_time_               DATE; 
   ship_day_found_          BOOLEAN := FALSE; 
   calendar_id_             VARCHAR2(10);
   dummy_                   NUMBER := 0;  
   latest_order_date_       DATE; 
   
   CURSOR check_route_days_exists IS
      SELECT 1 
      FROM   delivery_route_schedule_tab
      WHERE  route_id = route_id_;
         
   CURSOR get_route_ship_times IS
      SELECT * FROM
        (SELECT ship_time
         FROM   delivery_route_schedule_tab
         WHERE  route_id = route_id_
         AND    route_day = week_day_db_
         MINUS
         SELECT c.ship_time
         FROM   delivery_route_exception_tab c, site_public s
         WHERE  c.route_id = route_id_
         AND    c.contract = s.contract
         AND    c.contract = contract_
         AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_departure_date_, Report_SYS.date_format_) 
         AND    c.exception_type = 'CANCEL')
         UNION ALL
         SELECT c.ship_time
         FROM   delivery_route_exception_tab c, site_public s
         WHERE  c.route_id = route_id_
         AND    c.contract = s.contract
         AND    c.contract = contract_
         AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_departure_date_, Report_SYS.date_format_)
         AND    c.exception_type = 'NEW'
         ORDER BY 1 ASC;   
   
   CURSOR get_route_exception IS
      SELECT c.order_stop_days, c.order_stop_time
         FROM   delivery_route_exception_tab c, site_public s
         WHERE  c.route_id = route_id_
         AND    c.contract = s.contract
         AND    c.contract = contract_
         AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_departure_date_, Report_SYS.date_format_)
         AND    TO_CHAR(c.ship_time, Report_SYS.time_format_) = TO_CHAR(route_departure_date_, Report_SYS.time_format_)
         AND    c.exception_type = 'NEW';
          
   CURSOR get_route_schedule IS
      SELECT c.order_stop_days, c.order_stop_time
         FROM   delivery_route_schedule_tab c
         WHERE  c.route_id = route_id_
         AND    c.route_day = week_day_db_ 
         AND    TO_CHAR(c.ship_time, Report_SYS.time_format_) = TO_CHAR(route_departure_date_, Report_SYS.time_format_);
          
BEGIN
   IF (start_date_ IS NOT NULL) THEN
      calendar_id_ := Site_API.Get_Dist_Calendar_Id(contract_);
      -- start from the date which is a working day according to the distribution calendar
      IF (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, start_date_) = 0) THEN
         route_departure_date_ := Work_Time_Calendar_API.Get_Previous_Work_Day(calendar_id_, start_date_);
      ELSE
          route_departure_date_ := start_date_;
      END IF;

      OPEN check_route_days_exists;
      FETCH check_route_days_exists INTO dummy_;
      CLOSE check_route_days_exists;

      IF (dummy_ = 1) THEN 
         WHILE (NOT ship_day_found_) LOOP
            week_day_db_ := Work_Time_Week_Day_API.Encode(Work_Time_Calendar_API.Get_Week_Day(route_departure_date_));

            FOR sched_rec_ IN get_route_ship_times LOOP
               ship_day_found_ := TRUE;
               timestamp_ := TO_CHAR(TRUNC(route_departure_date_), Report_SYS.datetime_format_);
               -- time part of the route_departure_date_ is set from ship time defined in delivery route.
               timestamp_ := REPLACE(timestamp_, '00:00:00', TO_CHAR(sched_rec_.ship_time, 'HH24:MI:SS'));
               route_departure_date_ := TO_DATE(timestamp_, Report_SYS.datetime_format_);

               OPEN get_route_exception;
               FETCH get_route_exception INTO stop_days_, stop_time_;
               IF (get_route_exception%NOTFOUND) THEN
                  OPEN get_route_schedule;
                  FETCH get_route_schedule INTO stop_days_, stop_time_;
                  CLOSE get_route_schedule;
               END IF;
               CLOSE get_route_exception;

               IF ((TO_CHAR(date_entered_, 'HH24:MI') > TO_CHAR(stop_time_, 'HH24:MI'))) THEN
                  stop_days_ := stop_days_ + 1;
               END IF;

               latest_order_date_ := Work_Time_Calendar_API.Get_Start_Date(calendar_id_, route_departure_date_, stop_days_); 
               IF close_latest_order_date_ IS NULL THEN
                  close_latest_order_date_ := latest_order_date_;
                  best_route_departure_date_ := route_departure_date_;
               ELSIF (close_latest_order_date_ <= latest_order_date_ ) THEN
                  best_route_departure_date_ :=  route_departure_date_;
                  close_latest_order_date_ := latest_order_date_;
               END IF;
            END LOOP;
            IF NOT ship_day_found_ THEN
               route_departure_date_ := Work_Time_Calendar_API.Get_Previous_Work_Day(calendar_id_, route_departure_date_);
            END IF;   
         END LOOP;
      ELSE   
         best_route_departure_date_ := route_departure_date_;
         close_latest_order_date_ := route_departure_date_;
      END IF;  
   END IF;
END Calc_Deliv_Dates_From_Route___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- Returns forward route_dates and order_stop_days for route_dates
FUNCTION Get_Forward_Route_Dates(
   contract_                  IN VARCHAR2,
   route_id_                  IN VARCHAR2,
   forward_route_search_days_ IN NUMBER,
   processing_date_           IN DATE ) RETURN Route_Day_Info_Tab 
IS 

route_day_info_tab_ Route_Day_Info_Tab;

CURSOR get_route_day_info IS
   SELECT route_day, order_stop_days, order_stop_time
   FROM
   (
      SELECT route_day, order_stop_days, order_stop_time
        FROM 
            (SELECT
            TO_DATE
            ( 
              REPLACE(
                TO_CHAR(TRUNC(NEXT_DAY(((processing_date_ - 1) + ((record_control.lookup_weeks - 1) * 7)),work_time_week_day_api.decode(t.route_day))),'YYYY-MM-DD HH24:MI:SS'),
                '00:00:00',
                TO_CHAR(t.ship_time, 'HH24:MI:SS')
              ),
              'YYYY-MM-DD HH24:MI:SS'
            ) AS route_day, t.order_stop_days, t.order_stop_time
            FROM 
            delivery_route_schedule_tab t , (select level as lookup_weeks from dual connect by level <= round(forward_route_search_days_ / 7))record_control
            WHERE t.route_id = route_id_) normal_route_schedule 
      WHERE route_day NOT IN (
          SELECT
          TO_DATE
          ( 
            REPLACE(
              TO_CHAR(TRUNC(c.exception_date),'YYYY-MM-DD HH24:MI:SS'),
              '00:00:00',
              TO_CHAR(c.ship_time, 'HH24:MI:SS')
            ),
            'YYYY-MM-DD HH24:MI:SS'
          ) AS route_day
          FROM   delivery_route_exception_tab c, site_public s
          WHERE  c.route_id = route_id_
          AND    c.contract = s.contract
          AND    c.contract = contract_
          AND    c.exception_type = 'CANCEL'
          AND    c.exception_date BETWEEN (processing_date_ - 1) AND (processing_date_ + round(forward_route_search_days_))
      )

      UNION 

      SELECT
         TO_DATE
         ( 
           REPLACE(
             TO_CHAR(TRUNC(c.exception_date),'YYYY-MM-DD HH24:MI:SS'),
             '00:00:00',
             TO_CHAR(c.ship_time, 'HH24:MI:SS')
           ),
           'YYYY-MM-DD HH24:MI:SS'
         ) AS route_day, c.order_stop_days, c.order_stop_time
      FROM   delivery_route_exception_tab c, site_public s
      WHERE  c.route_id = route_id_
      AND    c.contract = s.contract
      AND    c.contract = contract_
      AND    c.exception_type = 'NEW'
      AND    c.exception_date BETWEEN (processing_date_ - 1) AND (processing_date_ + round(forward_route_search_days_))) order_schedule
   ORDER BY route_day;
BEGIN 
   IF (forward_route_search_days_ >= 0) AND (processing_date_ IS NOT NULL) THEN 
      OPEN  get_route_day_info;
      FETCH get_route_day_info  BULK COLLECT INTO route_day_info_tab_;
      CLOSE get_route_day_info;
   END IF;
   
   RETURN route_day_info_tab_;
END  Get_Forward_Route_Dates;

-- Get_Route_Delivery_Date
--   Calculates the earliest possible delivery date for an order connected to a route
--   based on wanted delivery date, date_entered, delivery_leadtime and contract.
FUNCTION Get_Route_Delivery_Date (
   route_id_                  IN VARCHAR2,
   wanted_delivery_date_      IN DATE,
   date_entered_              IN DATE,
   delivery_leadtime_         IN NUMBER,
   ext_transport_calendar_id_ IN VARCHAR2,
   contract_                  IN VARCHAR2 ) RETURN DATE
IS
   route_date_        DATE;
   planned_ship_date_ DATE;
BEGIN
   
   $IF Component_Order_SYS.INSTALLED $THEN
      Cust_Ord_Date_Calculation_API.Fetch_Calendar_Start_Date(planned_ship_date_, ext_transport_calendar_id_, wanted_delivery_date_, delivery_leadtime_);
      route_date_ := Get_Route_Ship_Date(route_id_, planned_ship_date_, date_entered_, contract_);
      Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(route_date_, ext_transport_calendar_id_, route_date_, delivery_leadtime_);
   $ELSE
      NULL;
   $END
   
   RETURN route_date_;
END Get_Route_Delivery_Date;


-- Get_Route_Ship_Date
--   Calculates the route departure date for an order connected to a route based on
--   planned ship date, date_entered and contract.
@UncheckedAccess
FUNCTION Get_Route_Ship_Date (
   route_id_          IN VARCHAR2,
   planned_ship_date_ IN DATE,
   date_entered_      IN DATE,
   contract_          IN VARCHAR2 ) RETURN DATE
IS
   calendar_id_          VARCHAR2(10);
   route_departure_date_ DATE;
   stop_days_            NUMBER;
   start_date_           DATE;
   route_date_           DATE;
   stop_time_            DATE;
BEGIN

   calendar_id_ := Site_API.Get_Dist_Calendar_Id(contract_);
   
   -- Find the earliest possible route departure date
   route_departure_date_ := Get_Next_Route_Date(route_id_, planned_ship_date_, calendar_id_, contract_);

   IF route_departure_date_ IS NOT NULL THEN
      Fetch_Stop_Days_And_Time(stop_days_, stop_time_, route_id_, calendar_id_, route_departure_date_, contract_);
   ELSE
      stop_days_ := 0;
   END IF;


   IF ((Work_Time_Calendar_API.Is_Working_Day(calendar_id_, date_entered_) = 1) AND 
       (TO_CHAR(date_entered_, 'HH24:MI') > TO_CHAR(stop_time_, 'HH24:MI'))) THEN
      stop_days_ := stop_days_ + 1;
   END IF;
   
   -- if we've jumped outside the calendar (NULL is returned), restart calculation from planned_ship_date_
   route_date_ := NVL(route_departure_date_, planned_ship_date_);

   -- Make sure shipping will be possible on the found route_departure_date given
   -- the stop_days and stop_time set for the route.
   start_date_ := Work_Time_Calendar_API.Get_Start_Date(calendar_id_, route_date_, stop_days_);

   IF (start_date_ IS NULL) THEN
      -- set day before date entered (if outside calendar), to go into while loop and fetch next route date...
      start_date_ := TRUNC(date_entered_) - 1;
   END IF;

   IF (start_date_ = TRUNC(date_entered_)) THEN
      -- if order stop time is later than date entered - fetch next route date.
      route_departure_date_ := Get_Next_Route_Date(route_id_, route_date_, calendar_id_, contract_);
   ELSE
      WHILE (start_date_ < TRUNC(date_entered_)) LOOP
         -- Not within order stop time. Fetch next route departure date.
          LOOP
            route_departure_date_ := Get_Next_Route_Date(route_id_, route_date_ , calendar_id_, contract_);
            EXIT WHEN ((TO_CHAR(route_departure_date_, Report_SYS.datetime_format_) > TO_CHAR(route_date_, Report_SYS.datetime_format_)) OR (route_departure_date_ IS NULL));
            -- Increase route_date_ by one second to fine the next route date 
            -- if the returning route_depature_date_ from Get_Next_Route_Date is equal to the route_date_.
            route_date_ := route_date_ + 1/86400;            
         END LOOP;

         IF (route_departure_date_ IS NOT NULL) THEN
            Fetch_Stop_Days_And_Time(stop_days_, stop_time_, route_id_, calendar_id_, route_departure_date_, contract_);
            IF ((Work_Time_Calendar_API.Is_Working_Day(calendar_id_, date_entered_) = 1) AND
               (TO_CHAR(date_entered_, 'HH24:MI') > TO_CHAR(stop_time_, 'HH24:MI'))) THEN
                stop_days_ := stop_days_ + 1;
            END IF;
            start_date_ := Work_Time_Calendar_API.Get_Start_Date(calendar_id_, route_departure_date_, stop_days_);

            IF (start_date_ IS NULL) THEN
               -- set null if outside calendar
               route_departure_date_ := NULL;
            END IF;
            route_date_ := route_departure_date_;
         END IF;

         EXIT WHEN route_departure_date_ IS NULL;
      END LOOP;
   END IF;

   RETURN route_departure_date_;
END Get_Route_Ship_Date;


-- Get_Next_Route_Date
--   Returns the next scheduled route departure date.
@UncheckedAccess
FUNCTION Get_Next_Route_Date (
   route_id_    IN VARCHAR2,
   start_date_  IN DATE,
   calendar_id_ IN VARCHAR2,
   contract_    IN VARCHAR2   ) RETURN DATE
IS
   route_departure_date_ DATE;
   timestamp_            VARCHAR2(20);
   week_day_db_          VARCHAR2(20);

   CURSOR get_route_ship_times IS
      SELECT * FROM
      (SELECT ship_time
       FROM   delivery_route_schedule_tab
       WHERE  route_id = route_id_
       AND    route_day = week_day_db_
       MINUS
       SELECT c.ship_time
       FROM   delivery_route_exception_tab c, site_public s
       WHERE  c.route_id = route_id_
       AND    c.contract = s.contract
       AND    c.contract = contract_
       AND    s.dist_calendar_id = calendar_id_
       AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_departure_date_, Report_SYS.date_format_) 
       AND    c.exception_type = 'CANCEL')
       UNION ALL
       SELECT c.ship_time
       FROM   delivery_route_exception_tab c, site_public s
       WHERE  c.route_id = route_id_
       AND    c.contract = s.contract
       AND    c.contract = contract_
       AND    s.dist_calendar_id = calendar_id_
       AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_departure_date_, Report_SYS.date_format_)
       AND    c.exception_type = 'NEW'
       ORDER BY 1;
BEGIN
   -- check if start date is a work day - if not fetch the next work day   -
   IF (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, start_date_) = 0) THEN
   route_departure_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(calendar_id_, start_date_);
   ELSE
      route_departure_date_ := start_date_;
   END IF;

   -- as long as we're inside the calendar...
   WHILE (route_departure_date_ IS NOT NULL) LOOP
      week_day_db_ := Work_Time_Week_Day_API.Encode(Work_Time_Calendar_API.Get_Week_Day(route_departure_date_));        

      FOR sched_rec_ IN get_route_ship_times LOOP
         timestamp_ := TO_CHAR(TRUNC(route_departure_date_), Report_SYS.datetime_format_);
         timestamp_ := REPLACE(timestamp_, '00:00:00', TO_CHAR(sched_rec_.ship_time, 'HH24:MI:SS'));         
         IF (TO_CHAR(sched_rec_.ship_time, 'HH24:MI:SS') >= TO_CHAR(route_departure_date_, 'HH24:MI:SS')) THEN
            RETURN TO_DATE(timestamp_, Report_SYS.datetime_format_);
      END IF;
      END LOOP;
      route_departure_date_ := Work_Time_Calendar_API.Get_Next_Work_Day(calendar_id_, route_departure_date_);
   END LOOP;

   -- no work day/route day found - return null
   RETURN NULL;
END Get_Next_Route_Date;


-- Get_Previous_Route_Date
--   Returns the previous scheduled route departure date.
@UncheckedAccess
FUNCTION Get_Previous_Route_Date (
   route_id_          IN VARCHAR2,
   start_date_        IN DATE,
   calendar_id_       IN VARCHAR2,
   delivery_leadtime_ IN NUMBER,
   contract_          IN VARCHAR2   ) RETURN DATE
IS

   route_departure_date_ DATE;
   week_day_db_          VARCHAR2(20);
   check_time_           BOOLEAN := TRUE;
   timestamp_            VARCHAR2(20);

   CURSOR get_route_ship_times IS
      SELECT * FROM
      (SELECT ship_time
       FROM   delivery_route_schedule_tab
       WHERE  route_id = route_id_
       AND    route_day = week_day_db_
       MINUS
       SELECT c.ship_time
       FROM   delivery_route_exception_tab c, site_public s
       WHERE  c.route_id = route_id_
       AND    c.contract = s.contract
       AND    c.contract = contract_
       AND    s.dist_calendar_id = calendar_id_
       AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_departure_date_, Report_SYS.date_format_) 
       AND    c.exception_type = 'CANCEL')
       UNION ALL
       SELECT c.ship_time
       FROM   delivery_route_exception_tab c, site_public s
       WHERE  c.route_id = route_id_
       AND    c.contract = s.contract
       AND    c.contract = contract_
       AND    s.dist_calendar_id = calendar_id_
       AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_departure_date_, Report_SYS.date_format_)
       AND    c.exception_type = 'NEW'
       ORDER BY 1;
BEGIN
   -- if start date is a non working day fetch the prior work day
   IF (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, start_date_) = 0) THEN
      route_departure_date_ := Work_Time_Calendar_API.Get_Prior_Work_Day(calendar_id_, start_date_);
   ELSE
      route_departure_date_ := start_date_;
   END IF;

   IF (TO_CHAR(route_departure_date_, Report_SYS.datetime_format_) < TO_CHAR(start_date_, Report_SYS.datetime_format_)) THEN
      check_time_ := FALSE;
   END IF; 

   IF (route_departure_date_ IS NOT NULL) THEN
      route_departure_date_ := TO_DATE(REPLACE(TO_CHAR(route_departure_date_, Report_SYS.datetime_format_), '00:00:00', TO_CHAR(start_date_, 'HH24:MI:SS')), Report_SYS.datetime_format_); 
      -- as long as we're inside the calendar
      WHILE (route_departure_date_ IS NOT NULL) LOOP
         timestamp_ := TO_CHAR(TRUNC(route_departure_date_), Report_SYS.datetime_format_);
         week_day_db_ := Work_Time_Week_Day_API.Encode(Work_Time_Calendar_API.Get_Week_Day(route_departure_date_));
         FOR sched_rec_ IN get_route_ship_times LOOP
            IF ((delivery_leadtime_ > 0) OR (NOT check_time_) OR Check_Time___(route_departure_date_, sched_rec_.ship_time)) THEN
               timestamp_ := REPLACE(timestamp_, '00:00:00', TO_CHAR(sched_rec_.ship_time, 'HH24:MI:SS'));
               RETURN TO_DATE(timestamp_, Report_SYS.datetime_format_);
            END IF;
         END LOOP;
         route_departure_date_ := Work_Time_Calendar_API.Get_Previous_Work_Day(calendar_id_, route_departure_date_);
         check_time_ := FALSE;
      END LOOP;
   END IF;
   -- no work day/route day found - return null
   RETURN NULL;
END Get_Previous_Route_Date;


@UncheckedAccess
PROCEDURE Fetch_Stop_Days_And_Time (
   stop_days_            OUT NUMBER,
   stop_time_            OUT DATE,
   route_id_              IN VARCHAR2,
   calendar_id_           IN VARCHAR2,
   route_departure_date_  IN DATE,
   contract_              IN VARCHAR2   )
IS
   week_day_db_          VARCHAR2(20);
   
   CURSOR get_route_exception IS
       SELECT c.order_stop_days, c.order_stop_time
       FROM   delivery_route_exception_tab c, site_public s
       WHERE  c.route_id = route_id_
       AND    c.contract = s.contract
       AND    c.contract = contract_
       AND    s.dist_calendar_id = calendar_id_
       AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_departure_date_, Report_SYS.date_format_)
       AND    TO_CHAR(c.ship_time, Report_SYS.time_format_) = TO_CHAR(route_departure_date_, Report_SYS.time_format_)
       AND    c.exception_type = 'NEW';
       
    
    CURSOR get_route_schedule IS     
       SELECT c.order_stop_days, c.order_stop_time
       FROM   delivery_route_schedule_tab c
       WHERE  c.route_id = route_id_
       AND    c.route_day = week_day_db_ 
       AND    TO_CHAR(c.ship_time, Report_SYS.time_format_) = TO_CHAR(route_departure_date_, Report_SYS.time_format_);
       
BEGIN   
   OPEN get_route_exception;
   FETCH get_route_exception INTO stop_days_, stop_time_;
   IF (get_route_exception%NOTFOUND) THEN
       week_day_db_ := Work_Time_Week_Day_API.Encode(Work_Time_Calendar_API.Get_Week_Day(route_departure_date_));
       OPEN get_route_schedule;
       FETCH get_route_schedule INTO stop_days_, stop_time_;
       CLOSE get_route_schedule;
   END IF;
   CLOSE get_route_exception; 
END Fetch_Stop_Days_And_Time;

@UncheckedAccess
FUNCTION Get_Description (
   route_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ delivery_route_tab.description%TYPE;
BEGIN
   IF (route_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      route_id_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  delivery_route_tab
      WHERE route_id = route_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(route_id_, 'Get_Description');
   END Get_Description;
   
PROCEDURE Get_Previous_Del_And_Ord_Date(
   prev_route_delivery_date_  OUT DATE,
   prev_route_order_date_     OUT DATE,
   route_id_                  IN  VARCHAR2,
   input_date_                IN  DATE, 
   contract_                  IN  VARCHAR2)
IS
   route_delivery_date_    DATE;
   week_day_db_            VARCHAR2(20);
   timestamp_              VARCHAR2(20);
   stop_days_              NUMBER;
   ship_day_found_         BOOLEAN := FALSE; 
   dummy_                  NUMBER := 0;  
   latest_order_date_      DATE; 
   
   CURSOR check_route_days_exists IS
      SELECT 1 
      FROM   delivery_route_schedule_tab
      WHERE  route_id = route_id_;
         
   CURSOR get_route_ship_times IS
      SELECT * FROM
        (SELECT ship_time
         FROM   delivery_route_schedule_tab
         WHERE  route_id = route_id_
         AND    route_day = week_day_db_
         MINUS
         SELECT c.ship_time
         FROM   delivery_route_exception_tab c, site_public s
         WHERE  c.route_id = route_id_
         AND    c.contract = s.contract
         AND    c.contract = contract_
         AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_delivery_date_, Report_SYS.date_format_) 
         AND    c.exception_type = 'CANCEL')
         UNION ALL
         SELECT c.ship_time
         FROM   delivery_route_exception_tab c, site_public s
         WHERE  c.route_id = route_id_
         AND    c.contract = s.contract
         AND    c.contract = contract_
         AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_delivery_date_, Report_SYS.date_format_)
         AND    c.exception_type = 'NEW'
         ORDER BY 1 ASC;   
   
   CURSOR get_route_exception IS
      SELECT c.order_stop_days
         FROM   delivery_route_exception_tab c, site_public s
         WHERE  c.route_id = route_id_
         AND    c.contract = s.contract
         AND    c.contract = contract_
         AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_delivery_date_, Report_SYS.date_format_)
         AND    TO_CHAR(c.ship_time, Report_SYS.time_format_) = TO_CHAR(route_delivery_date_, Report_SYS.time_format_)
         AND    c.exception_type = 'NEW';
          
   CURSOR get_route_schedule IS
      SELECT c.order_stop_days
         FROM   delivery_route_schedule_tab c
         WHERE  c.route_id = route_id_
         AND    c.route_day = week_day_db_ 
         AND    TO_CHAR(c.ship_time, Report_SYS.time_format_) = TO_CHAR(route_delivery_date_, Report_SYS.time_format_); 
BEGIN 
   IF (input_date_ IS NOT NULL) THEN
      route_delivery_date_ := input_date_;
      
      OPEN check_route_days_exists;
      FETCH check_route_days_exists INTO dummy_;
      CLOSE check_route_days_exists;

      IF (dummy_ = 1) THEN 
         WHILE (NOT ship_day_found_) LOOP
            week_day_db_ := Work_Time_Week_Day_API.Encode(Work_Time_Calendar_API.Get_Week_Day(route_delivery_date_));

            FOR sched_rec_ IN get_route_ship_times LOOP
               ship_day_found_ := TRUE;
               timestamp_ := TO_CHAR(TRUNC(route_delivery_date_), Report_SYS.datetime_format_);
               -- time part of the route_delivery_date_ is set from ship time defined in delivery route.
               timestamp_ := REPLACE(timestamp_, '00:00:00', TO_CHAR(sched_rec_.ship_time, 'HH24:MI:SS'));
               route_delivery_date_ := TO_DATE(timestamp_, Report_SYS.datetime_format_);

               OPEN get_route_exception;
               FETCH get_route_exception INTO stop_days_;
               IF (get_route_exception%NOTFOUND) THEN
                  OPEN get_route_schedule;
                  FETCH get_route_schedule INTO stop_days_;
                  CLOSE get_route_schedule;
               END IF;
               CLOSE get_route_exception;

               latest_order_date_ := route_delivery_date_ - stop_days_;
               IF prev_route_order_date_ IS NULL THEN
                  prev_route_order_date_    := latest_order_date_;
                  prev_route_delivery_date_ := route_delivery_date_;
               ELSIF (prev_route_order_date_ <= latest_order_date_ ) THEN
                  prev_route_order_date_    := latest_order_date_;
                  prev_route_delivery_date_ := route_delivery_date_;
               END IF;
            END LOOP;
            IF NOT ship_day_found_ THEN
              route_delivery_date_ := route_delivery_date_ - 1;
            END IF;   
         END LOOP;
      ELSE   
         prev_route_delivery_date_ := route_delivery_date_;
         prev_route_order_date_    := route_delivery_date_;
      END IF;  
   END IF;
END Get_Previous_Del_And_Ord_Date;

-- This is the method used in PO to get next possible route date when calculating Receipt Date. 
FUNCTION Get_Possible_Route_Date (
   route_id_          IN VARCHAR2,
   planned_date_      IN DATE,
   contract_          IN VARCHAR2,
   date_entered_      IN DATE ) RETURN DATE
IS
   calendar_id_             VARCHAR2(10);
   route_departure_date_    DATE;
   stop_days_               NUMBER;
   start_date_              DATE;
   stop_time_               DATE;
   week_day_db_             VARCHAR2(20);
   timestamp_               VARCHAR2(20);
   ship_day_found_          BOOLEAN := FALSE;
   correct_ship_date_found_ BOOLEAN := FALSE;
   dummy_                   NUMBER := 0;
   max_calendar_date_       DATE;
   
   CURSOR check_route_days_exists IS
      SELECT 1 
      FROM   delivery_route_schedule_tab
      WHERE  route_id = route_id_;
      
   CURSOR get_route_exception IS
      SELECT c.order_stop_days, c.order_stop_time
         FROM   delivery_route_exception_tab c, site_public s
         WHERE  c.route_id = route_id_
         AND    c.contract = s.contract
         AND    c.contract = contract_
         AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_departure_date_, Report_SYS.date_format_)
         AND    TO_CHAR(c.ship_time, Report_SYS.time_format_) = TO_CHAR(route_departure_date_, Report_SYS.time_format_)
         AND    c.exception_type = 'NEW';
       
   CURSOR get_route_schedule IS
      SELECT c.order_stop_days, c.order_stop_time
         FROM   delivery_route_schedule_tab c
         WHERE  c.route_id = route_id_
         AND    c.route_day = week_day_db_ 
         AND    TO_CHAR(c.ship_time, Report_SYS.time_format_) = TO_CHAR(route_departure_date_, Report_SYS.time_format_);
         
   CURSOR get_route_ship_times IS
      SELECT * FROM
      (SELECT ship_time, order_stop_days, order_stop_time
       FROM   delivery_route_schedule_tab
       WHERE  route_id = route_id_
       AND    route_day = week_day_db_
       MINUS
       SELECT c.ship_time, order_stop_days, order_stop_time
       FROM   delivery_route_exception_tab c, site_public s
       WHERE  c.route_id = route_id_
       AND    c.contract = s.contract
       AND    c.contract = contract_
       AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_departure_date_, Report_SYS.date_format_) 
       AND    c.exception_type = 'CANCEL')
       UNION ALL
       SELECT c.ship_time, order_stop_days, order_stop_time
       FROM   delivery_route_exception_tab c, site_public s
       WHERE  c.route_id = route_id_
       AND    c.contract = s.contract
       AND    c.contract = contract_
       AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(route_departure_date_, Report_SYS.date_format_)
       AND    c.exception_type = 'NEW'
       ORDER BY 1;
   
BEGIN
   IF (planned_date_ IS NOT NULL) THEN
      OPEN check_route_days_exists;
      FETCH check_route_days_exists INTO dummy_;
      CLOSE check_route_days_exists;

      IF (dummy_ = 1) THEN
         calendar_id_ := Site_API.Get_Dist_Calendar_Id(contract_);
         max_calendar_date_ := Work_Time_Calendar_API.Get_Max_Work_Day(calendar_id_);
         IF (planned_date_ >  max_calendar_date_) THEN
            Error_SYS.Record_General(lu_name_, 'ROUTEDATEPICK: Retrieving next work day from :P1 using route has failed. The date is outside the interval of the calendar :P2.',planned_date_, calendar_id_);
         END IF;
         -- start from the date which is a working day according to the distribution calendar
         IF (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, planned_date_) = 0) THEN
            route_departure_date_ := Work_Time_Calendar_API.Get_Next_Work_Day(calendar_id_, planned_date_);
         ELSE
             route_departure_date_ := planned_date_;
         END IF;
         -- Find the earliest possible route departure date which is also a working day according to the distribution calendar. 
         WHILE (NOT correct_ship_date_found_) LOOP
            WHILE (NOT ship_day_found_) LOOP
               week_day_db_ := Work_Time_Week_Day_API.Encode(Work_Time_Calendar_API.Get_Week_Day(route_departure_date_));

               FOR sched_rec_ IN get_route_ship_times LOOP
                  -- get the truncated value of route_departure_date_ to check it with the ship time defined in the route.
                  timestamp_ := TO_CHAR(TRUNC(route_departure_date_), Report_SYS.datetime_format_);
                  timestamp_ := REPLACE(timestamp_, '00:00:00', TO_CHAR(sched_rec_.ship_time, 'HH24:MI:SS'));
                  IF (TO_CHAR(TRUNC(sched_rec_.ship_time), 'HH24:MI:SS') >= TO_CHAR(TRUNC(route_departure_date_), 'HH24:MI:SS')) THEN
                     route_departure_date_ := TO_DATE(timestamp_, Report_SYS.datetime_format_);
                     ship_day_found_ := TRUE;
                     EXIT;
                  END IF;
               END LOOP;
               IF NOT ship_day_found_ THEN
                  route_departure_date_ := Work_Time_Calendar_API.Get_Next_Work_Day(calendar_id_, route_departure_date_);
               END IF;
            END LOOP;

            IF route_departure_date_ IS NOT NULL THEN
               OPEN get_route_exception;
               FETCH get_route_exception INTO stop_days_, stop_time_;
               IF (get_route_exception%NOTFOUND) THEN
                  week_day_db_ := Work_Time_Week_Day_API.Encode(Work_Time_Calendar_API.Get_Week_Day(route_departure_date_));
                  OPEN get_route_schedule;
                  FETCH get_route_schedule INTO stop_days_, stop_time_;
                  CLOSE get_route_schedule;
               END IF;
               CLOSE get_route_exception;
            ELSE
               stop_days_ := 0;
            END IF;

            IF ((TO_CHAR(date_entered_, 'HH24:MI') > TO_CHAR(stop_time_, 'HH24:MI'))) THEN
               stop_days_ := stop_days_ + 1;
            END IF;

            IF (route_departure_date_ IS NOT NULL) THEN
               IF (calendar_id_ IS NOT NULL) THEN
                  start_date_ := Work_Time_Calendar_API.Get_Start_Date(calendar_id_, route_departure_date_, stop_days_);
               ELSE
                  start_date_ := route_departure_date_ - stop_days_;
               END IF;   
            END IF; 

            IF (TO_CHAR(TRUNC(start_date_), 'YYYY-MM-DD') >= TO_CHAR(TRUNC(date_entered_), 'YYYY-MM-DD')) THEN
               correct_ship_date_found_ := TRUE;
            ELSE   
               -- if order stop time is later than the date after external lead time days then fetch the next route date.
               route_departure_date_ := Work_Time_Calendar_API.Get_Next_Work_Day(calendar_id_, route_departure_date_);
               ship_day_found_ := FALSE;
            END IF;

         END LOOP;
      ELSE
         route_departure_date_ := planned_date_;
      END IF;
   ELSE
       RETURN NULL;
   END IF;
   RETURN route_departure_date_;
END Get_Possible_Route_Date;

-- This method is used in purchasing when calculating the planned delivery date from the planned receipt date.    
FUNCTION Get_Previous_Route_Date (
   route_id_        IN VARCHAR2,
   start_date_      IN DATE, 
   contract_        IN VARCHAR2,
   date_entered_    IN DATE ) RETURN DATE
IS
   route_departure_date_   DATE;
   latest_order_date_      DATE;
BEGIN
   Calc_Deliv_Dates_From_Route___(route_departure_date_,
                                  latest_order_date_,
                                  route_id_,
                                  start_date_, 
                                  contract_,
                                  date_entered_);
   RETURN route_departure_date_;
END Get_Previous_Route_Date;


PROCEDURE Calc_Delivery_Dates_From_Route (
   route_departure_date_   OUT DATE,
   latest_order_date_      OUT DATE,
   route_id_               IN  VARCHAR2,
   start_date_             IN  DATE, 
   contract_               IN  VARCHAR2,
   date_entered_           IN  DATE )
IS   
          
BEGIN
   Calc_Deliv_Dates_From_Route___(route_departure_date_,
                                  latest_order_date_,
                                  route_id_,
                                  start_date_, 
                                  contract_,
                                  date_entered_);
END Calc_Delivery_Dates_From_Route;


-- Get_Next_Time_Slot
--   Returns the first valid delivery time equal to or greater than the input delivery time.
FUNCTION Get_Next_Time_Slot (
   route_id_            IN VARCHAR2,
   ship_time_           IN DATE,
   contract_            IN VARCHAR2 ) RETURN DATE
IS
   time_slot_           DATE;
   input_week_day_      VARCHAR2(1);
   route_day_db_        VARCHAR2(20);

   CURSOR get_delivery_time IS
      SELECT TO_DATE(TO_CHAR(ship_time_,'YYYYMMDD')||TO_CHAR(ship_time,'HH24MI'),'YYYYMMDDHH24MI')
      FROM  delivery_route_schedule_tab
      WHERE route_id = route_id_
      AND   route_day = route_day_db_
      AND TO_CHAR(ship_time,'HH24MISS') >= NVL(TO_CHAR(ship_time_,'HH24MISS'),' ')
      ORDER BY ship_time ;
BEGIN
   IF NOT(Work_Time_Calendar_API.Is_Working_Day(Site_API.Get_Dist_Calendar_Id(contract_),ship_time_) = 1) THEN
      RETURN NULL;
   ELSIF (Delivery_Route_API.Is_Delivery_Day(route_id_,ship_time_) = 0 ) THEN
      RETURN NULL;
   ELSIF (Delivery_Route_API.Get_Number_Of_Time_Slots(route_id_,ship_time_ , contract_) = 0)THEN
      RETURN NULL;
   ELSE
      -- Comparing with a date that you are certain was a monday and get the number of the week day.
      -- Also making use of the date in Julian format. Works regardless of NLS_TERRITORY.
      input_week_day_ := mod(to_char(ship_time_, 'J') - to_char(compare_dates_, 'J'), 7);

      IF (input_week_day_ = '0') THEN
         -- Monday
         route_day_db_ := '1';
      ELSIF (input_week_day_ = '1') THEN
         -- Tuesday
         route_day_db_ := '2';
      ELSIF (input_week_day_ = '2') THEN
         -- Wednesday
         route_day_db_ := '3';
      ELSIF (input_week_day_ = '3') THEN
         -- Thursday
         route_day_db_ := '4';
      ELSIF (input_week_day_ = '4') THEN
         -- Friday
         route_day_db_ := '5';
      ELSIF (input_week_day_ = '5') THEN
         -- Saturday
         route_day_db_ := '6';
      ELSIF (input_week_day_ = '6') THEN
         -- Sunday
         route_day_db_ := '7';
      END IF;

      OPEN get_delivery_time;
      FETCH get_delivery_time INTO time_slot_;
      CLOSE get_delivery_time;
      IF (time_slot_ IS NULL) THEN
         RETURN NULL;
      END IF;
      RETURN time_slot_;
   END IF;
END Get_Next_Time_Slot;

-- Is_Delivery_Day
--   Function indicates whether the week day is available for delivery
--   or not in this delivery route.
@UncheckedAccess
FUNCTION Is_Delivery_Day (
   route_id_            IN VARCHAR2,
   input_date_          IN DATE ) RETURN NUMBER
IS
   delivery_day_             VARCHAR2(12);
   route_day_db_             VARCHAR2(20);
   dummy_                    NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   delivery_route_schedule_tab
      WHERE  route_id = route_id_
      AND   route_day = route_day_db_;
BEGIN
   delivery_day_            := RTRIM( to_char(input_date_, 'DAY', 'NLS_DATE_LANGUAGE=AMERICAN'));
   
   IF (delivery_day_ = 'MONDAY') THEN
      route_day_db_ := '1';
   ELSIF (delivery_day_ = 'TUESDAY') THEN
       route_day_db_ := '2';
   ELSIF (delivery_day_ = 'WEDNESDAY')THEN
       route_day_db_ := '3';
   ELSIF (delivery_day_ = 'THURSDAY') THEN
       route_day_db_ := '4';
   ELSIF (delivery_day_ = 'FRIDAY') THEN
       route_day_db_ := '5';
   ELSIF (delivery_day_ = 'SATURDAY') THEN
       route_day_db_ := '6';
   ELSIF (delivery_day_ = 'SUNDAY') THEN
       route_day_db_ := '7';
   END IF;

   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(1);
   END IF;
   CLOSE exist_control;
   RETURN(0);
END Is_Delivery_Day;


@UncheckedAccess
FUNCTION Get_Number_Of_Time_Slots (
   route_id_            IN VARCHAR2,
   input_date_          IN DATE,
   contract_            IN VARCHAR2 ) RETURN NUMBER
IS
   no_of_time_slots_    NUMBER;
   input_week_day_      VARCHAR2(1);
   route_day_db_        VARCHAR2(20);

   CURSOR get_time_slots IS
      SELECT COUNT(*)
      FROM  delivery_route_schedule_tab
      WHERE route_id = route_id_
      AND   route_day = route_day_db_;
BEGIN
   IF NOT(Work_Time_Calendar_API.Is_Working_Day(Site_API.Get_Dist_Calendar_Id(contract_),input_date_)=1) THEN
      RETURN NULL;
   ELSIF (Delivery_Route_API.Is_Delivery_Day(route_id_,input_date_)= 0)THEN
      RETURN NULL;
   ELSE
      -- Comparing with a date that you are certain was a monday and get the number of the week day.
      -- Also making use of the date in Julian format. Works regardless of NLS_TERRITORY.
      input_week_day_ := mod(to_char(input_date_, 'J') - to_char(compare_dates_, 'J'), 7);

      IF (input_week_day_ = '0') THEN
         route_day_db_ := '1';
      ELSIF (input_week_day_ = '1') THEN
         route_day_db_ := '2';
      ELSIF (input_week_day_ = '2') THEN
         route_day_db_ := '3';
      ELSIF (input_week_day_ = '3') THEN
         route_day_db_ := '4';
      ELSIF (input_week_day_ = '4') THEN
         route_day_db_ := '5';
      ELSIF (input_week_day_ = '5') THEN
         route_day_db_ := '6';
      ELSIF (input_week_day_ = '6') THEN
         route_day_db_ := '7';
      END IF;

      OPEN get_time_slots;
      FETCH get_time_slots INTO no_of_time_slots_;
      CLOSE get_time_slots;
      RETURN (no_of_time_slots_);
   END IF;
END Get_Number_Of_Time_Slots;


-- Get_Next_Delivery_Date
--   Returns the first valid delivery date equal to or greater than the input date.
--   This method interacts with the calendar to be certain the day is a working day.
@UncheckedAccess
FUNCTION Get_Next_Delivery_Date (
   route_id_            IN VARCHAR2,
   input_date_          IN DATE,
   contract_            IN VARCHAR2 ) RETURN DATE
IS
   counter_                  NUMBER := 0;
   found_ok_                 BOOLEAN :=FALSE;
   delivery_day_             VARCHAR2(12);
   next_delivery_date_       DATE;
   del_day_monday_db_        VARCHAR2(1) := 'N';
   del_day_tuesday_db_       VARCHAR2(1) := 'N';
   del_day_wednesday_db_     VARCHAR2(1) := 'N';
   del_day_thursday_db_      VARCHAR2(1) := 'N';
   del_day_friday_db_        VARCHAR2(1) := 'N';
   del_day_saturday_db_      VARCHAR2(1) := 'N';
   del_day_sunday_db_        VARCHAR2(1) := 'N';

   CURSOR route_days IS
      SELECT DISTINCT(route_day)
      FROM   delivery_route_schedule_tab
      WHERE  route_id = route_id_;
BEGIN

   FOR route_day_ IN route_days LOOP
      IF (route_day_.route_day = '1') THEN
        del_day_monday_db_ := 'Y';
      ELSIF (route_day_.route_day = '2') THEN
        del_day_tuesday_db_ := 'Y';
      ELSIF (route_day_.route_day = '3') THEN
        del_day_wednesday_db_ := 'Y';
      ELSIF (route_day_.route_day = '4') THEN
        del_day_thursday_db_ := 'Y';
      ELSIF (route_day_.route_day = '5') THEN
        del_day_friday_db_ := 'Y';
      ELSIF (route_day_.route_day = '6') THEN
        del_day_saturday_db_ := 'Y';
      ELSIF (route_day_.route_day = '7') THEN
        del_day_sunday_db_ := 'Y';
      END IF;
   END LOOP;

   IF ((del_day_monday_db_ = 'N')   AND
       (del_day_tuesday_db_ = 'N')  AND
       (del_day_wednesday_db_ = 'N')AND
       (del_day_thursday_db_ = 'N' )AND
       (del_day_friday_db_ = 'N' )  AND
       (del_day_saturday_db_ = 'N' )AND
       (del_day_sunday_db_ = 'N' )) THEN
        RETURN input_date_;
   ELSE
      WHILE(NOT found_ok_)LOOP
         delivery_day_:=RTRIM(to_char(input_date_ + counter_, 'DAY', 'NLS_DATE_LANGUAGE=AMERICAN'));
         counter_ := counter_ + 1;
         IF ((delivery_day_ = 'MONDAY') AND (del_day_monday_db_ = 'Y')) THEN
            found_ok_ := TRUE;
         ELSIF ((delivery_day_ = 'TUESDAY') AND (del_day_tuesday_db_ = 'Y')) THEN
            found_ok_ := TRUE;
         ELSIF ((delivery_day_ = 'WEDNESDAY') AND (del_day_wednesday_db_ = 'Y')) THEN
            found_ok_ := TRUE;
         ELSIF ((delivery_day_ = 'THURSDAY') AND(del_day_thursday_db_ = 'Y'))THEN
            found_ok_ := TRUE;
         ELSIF ((delivery_day_ = 'FRIDAY') AND (del_day_friday_db_ ='Y'))THEN
            found_ok_ := TRUE;
         ELSIF ((delivery_day_ = 'SATURDAY') AND (del_day_saturday_db_ ='Y')) THEN
            found_ok_ := TRUE;
         ELSIF ((delivery_day_ = 'SUNDAY') AND (del_day_sunday_db_ = 'Y')) THEN
            found_ok_ := TRUE;
         END IF;
      END LOOP;
      next_delivery_date_ :=(input_date_ + counter_ - 1 );
   END IF;
   RETURN (next_delivery_date_);
END Get_Next_Delivery_Date;

-- Is_Valid_Route_Day
--   This method validate whether the planned arrival date is a route day.
@UncheckedAccess
FUNCTION Is_Valid_Route_Day (
   route_id_    IN VARCHAR2,
   input_date_  IN DATE ) RETURN BOOLEAN
IS
   exception_type_ VARCHAR2(6);
   
   CURSOR check_exceptions IS
      SELECT exception_type
      FROM  delivery_route_exception_tab
      WHERE route_id = route_id_      
      AND   TO_CHAR(exception_date, Report_SYS.date_format_) = TO_CHAR(input_date_, Report_SYS.date_format_);
      
BEGIN
   OPEN check_exceptions;
   FETCH check_exceptions INTO exception_type_;
   CLOSE check_exceptions;

   IF (Is_Delivery_Day(route_id_,input_date_) = 1) THEN      
      IF exception_type_ = 'CANCEL' THEN         
         RETURN FALSE;
      ELSE
         RETURN TRUE; 
      END IF;
   ELSE      
      IF exception_type_ = 'NEW' THEN         
         RETURN TRUE;
      ELSE
         RETURN FALSE; 
      END IF;
   END IF;
   RETURN FALSE;      
END Is_Valid_Route_Day;

-- Get_Due_Date_With_Time
--   Fetches the Due Time for Delivery from a route
--   and adds the time to the input date
@UncheckedAccess
FUNCTION Get_Due_Date_With_Time (
   route_id_   IN VARCHAR2,
   ship_date_  IN DATE,
   due_date_ IN DATE,
   contract_   IN VARCHAR2   ) RETURN DATE
IS
   ship_time_           VARCHAR2(20);
   due_date_with_time_  VARCHAR2(20);
   week_day_db_         VARCHAR2(20);

   CURSOR get_route_due_time_for_delivery IS
      SELECT * FROM
      (SELECT due_time_for_delivery
       FROM   delivery_route_schedule_tab
       WHERE  route_id = route_id_
       AND    route_day = week_day_db_
       AND    TO_CHAR(ship_time, 'HH24:MI:SS') = ship_time_
       MINUS
       SELECT c.due_time_for_delivery
       FROM   delivery_route_exception_tab c
       WHERE  c.route_id = route_id_
       AND    c.contract = contract_
       AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(ship_date_, Report_SYS.date_format_) 
       AND    c.exception_type = 'CANCEL')
       UNION ALL
       SELECT c.due_time_for_delivery
       FROM   delivery_route_exception_tab c
       WHERE  c.route_id = route_id_
       AND    c.contract = contract_
       AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(ship_date_, Report_SYS.date_format_)
       AND    c.exception_type = 'NEW'
       ORDER BY 1;
BEGIN
      IF route_id_ IS NOT NULL THEN 
         week_day_db_ := Work_Time_Week_Day_API.Encode(Work_Time_Calendar_API.Get_Week_Day(ship_date_));
         ship_time_ := TO_CHAR(ship_date_, 'HH24:MI:SS');

         FOR sched_rec_ IN get_route_due_time_for_delivery LOOP
            due_date_with_time_ := TO_CHAR(TRUNC(due_date_), Report_SYS.datetime_format_);
            due_date_with_time_ := REPLACE(due_date_with_time_, '00:00:00', TO_CHAR(sched_rec_.due_time_for_delivery, 'HH24:MI:SS'));
         END LOOP;
         
         IF due_date_with_time_ IS NULL THEN
            RETURN due_date_;
         ELSE 
            RETURN TO_DATE(due_date_with_time_, Report_SYS.datetime_format_);
         END IF;
      ELSE
         RETURN due_date_;
      END IF;
   END Get_Due_Date_With_Time;
   

-- Get_Receipt_Date_With_Time
--   Fetches the Receipt Time for Arrival from a route
--   and adds the time to the input date
@UncheckedAccess
FUNCTION Get_Receipt_Date_With_Time (
   route_id_      IN VARCHAR2,
   ship_date_     IN DATE,
   receipt_date_  IN DATE,
   contract_      IN VARCHAR2   ) RETURN DATE
IS
   ship_time_              VARCHAR2(20);
   receipt_date_with_time_ VARCHAR2(20);
   week_day_db_            VARCHAR2(20);

   CURSOR get_route_receipt_time_for_arrival IS
      SELECT * FROM
      (SELECT receipt_time_for_arrival
       FROM   delivery_route_schedule_tab
       WHERE  route_id = route_id_
       AND    route_day = week_day_db_
       AND    TO_CHAR(ship_time, 'HH24:MI:SS') = ship_time_
       MINUS
       SELECT c.receipt_time_for_arrival
       FROM   delivery_route_exception_tab c
       WHERE  c.route_id = route_id_
       AND    c.contract = contract_
       AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(ship_date_, Report_SYS.date_format_) 
       AND    c.exception_type = 'CANCEL')
       UNION ALL
       SELECT c.receipt_time_for_arrival
       FROM   delivery_route_exception_tab c
       WHERE  c.route_id = route_id_
       AND    c.contract = contract_
       AND    TO_CHAR(c.exception_date, Report_SYS.date_format_) = TO_CHAR(ship_date_, Report_SYS.date_format_)
       AND    c.exception_type = 'NEW'
       ORDER BY 1;
BEGIN
      IF route_id_ IS NOT NULL THEN 
         week_day_db_ := Work_Time_Week_Day_API.Encode(Work_Time_Calendar_API.Get_Week_Day(ship_date_));
         ship_time_ := TO_CHAR(ship_date_, 'HH24:MI:SS');

         FOR sched_rec_ IN get_route_receipt_time_for_arrival LOOP
               receipt_date_with_time_ := TO_CHAR(TRUNC(receipt_date_), Report_SYS.datetime_format_);
               receipt_date_with_time_ := REPLACE(receipt_date_with_time_, '00:00:00', TO_CHAR(sched_rec_.receipt_time_for_arrival, 'HH24:MI:SS'));
         END LOOP;
                  
         IF receipt_date_with_time_ IS NULL THEN
            RETURN receipt_date_;
         ELSE 
            RETURN TO_DATE(receipt_date_with_time_, Report_SYS.datetime_format_);
         END IF;
      ELSE
         RETURN receipt_date_;
      END IF;
END Get_Receipt_Date_With_Time;
