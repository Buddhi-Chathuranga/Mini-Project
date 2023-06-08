-----------------------------------------------------------------------------
--
--  Logical unit: PartAvailabilityControl
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  171127  LEPESE  STRSC-14755, Reimplemented all Check_XXX_Control methods to use generated Get_XXX_Db so that we make use of micro-cache-array solution.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729          method call in ORDER BY clause to sort string and number values seperately.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  140619  DaZase  PRSC-1207, Changed Create_Data_Capture_Lov so it now only uses ORDER BY ASC.
--  140311  SBalLK  Bug 115529, Added Check_Part_Movement_Allowed() method to validate whether the part movement is allowed according
--  140311          to the part availability control id.
--  131126  SWiclk  Bug 112876, Added Create_Data_Capture_Lov().
--  131016  Matkse  Added method Check_Putaw_Zone_Refill_Source. 
--  131016          Modified Unpack_Check_Insert___ by adding attribute default value for PUTAWAY_ZONE_REFILL_SOURCE_DB.
--  131008  Matkse  Added method Get_Putaway_Zone_Refill_Src_Db.
--  131007  Matkse  Added attribute PUTAWAY_ZONE_REFILL_SOURCE.
--  130619  Erlise  Added function Check_Noorder_Issue_Control.
--  120525  JeLise  Made description private.
--  120507  Matkse  Added the possibility to translate data by adding a call to Basic_Data_Translation_API.
--  120507          Insert_Basic_Data_Translation in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507          was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  091127  SaWjlk  Bug 86793, Added default IID values to the procedures Prepare_Insert___ and Unpack_Check_Insert___.
--  090203  NWeelk  Bug 79703, Added new column part_noorder_issue_control, modified Unpack_Check_Update___ 
--  090203          to make the controls not updatable and added a Function Noorder_Issue_Allowed. 
--  060309  NiDalk  Modified Unpack_Check_Update___ to allow updating of description.
--  051205  RaSilk  Modified flag to make lov item on column part_movement_control.
--  050929  SaMelk  Added new function Check_Part_Movement_Control.
--  050928  SaMelk  Added new column 'part_movement_control'.
--  040302  GeKalk  Removed substrb from views for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  031014  PrJalk  Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  030605  JOHESE  Modified Check_Scrap_Control & Check_Counting_Control to return db values instead of client values
--  030430  MaGulk  Modified Unpack_Check_Update___ to stop modifying a record
--  030425  MaGulk  Added public methods Check_Scrap_Control & Check_Counting_Control
--  030425  MaGulk  Added columns Part_Scrap_Control & Part_Counting_Control
--  020325  ANHO  Added method Check_Man_Reservation_Control.
--  020315  ChFolk  Rollback the column renaming Part_Reservation_Control.
--  020205  ChFolk  Renamed column, Part_Reservation_Control as Part_Auto_Reserv_Ctrl and
--                  Added column, Part_Manual_Reserv_Ctrl.
--  000925  JOHESE  Added undefines.
--  990419  ANHO  General performance improvements.
--  990407  ANHO  Upgraded to performance optimized template.
--  981208  ANHO  Added methods Check_Supply_Control, Check_Reservation_Control and
--                Check_Issue_Control.
--  981202  ANHO  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
@UncheckedAccess
FUNCTION Get_Description (
   availability_control_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_availability_control_tab.description%TYPE;
BEGIN
   IF (availability_control_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      availability_control_id_), 1, 50);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  part_availability_control_tab
      WHERE availability_control_id = availability_control_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(availability_control_id_, 'Get_Description');
END Get_Description;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PART_SCRAP_CONTROL', Part_Scrap_Control_API.Decode('SCRAPPABLE'), attr_);
   Client_SYS.Add_To_Attr('PART_COUNTING_CONTROL', Part_Counting_Control_API.Decode('ALLOW REDUCING'), attr_);
   Client_SYS.Add_To_Attr('PART_SUPPLY_CONTROL', Part_Supply_Control_API.Decode('NETTABLE'), attr_);
   Client_SYS.Add_To_Attr('PART_ORDER_ISSUE_CONTROL', Part_Order_Issue_Control_API.Decode('ORDER ISSUE'), attr_);
   Client_SYS.Add_To_Attr('PART_RESERVATION_CONTROL', Part_Reservation_Control_API.Decode('AUTO RESERVATION'), attr_);
   Client_SYS.Add_To_Attr('PART_MANUAL_RESERV_CTRL', Part_Manual_Reserv_Ctrl_API.Decode('MANUAL_RESERV'), attr_);
   Client_SYS.Add_To_Attr('PART_MOVEMENT_CONTROL', Part_Movement_Control_API.Decode('ALL ALLOWED'), attr_);
   Client_SYS.Add_To_Attr('PART_NOORDER_ISSUE_CONTROL', Part_Noorder_Issue_Control_API.Decode('NON-ORDER ISSUE'), attr_);
   Client_SYS.Add_To_Attr('PUTAWAY_ZONE_REFILL_SOURCE_DB', Fnd_Boolean_API.DB_TRUE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT part_availability_control_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     part_availability_control_tab%ROWTYPE,
   newrec_ IN OUT part_availability_control_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_    VARCHAR2(30);
   value_   VARCHAR2(4000);   
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Supply_Control
--   Returns the dbvalue of part_supply_control (nettable, not nettable)
--   of a specific availability control id. If the availability control id
--   is null, it returns the dbvalue nettable.
@UncheckedAccess
FUNCTION Check_Supply_Control (
   availability_control_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (availability_control_id_ IS NULL) THEN
      RETURN (Part_Supply_Control_API.DB_NETTABLE);
   ELSE
      RETURN (Get_Part_Supply_Control_Db(availability_control_id_));
   END IF;
END Check_Supply_Control;


-- Check_Reservation_Control
--   Returns the dbvalue of part_reservation_control (auto reservation,
--   not auto reservation) of a specific availability control id. If the
--   availability control id is null, it returns the dbvalue auto reservation.
@UncheckedAccess
FUNCTION Check_Reservation_Control (
   availability_control_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (availability_control_id_ IS NULL) THEN
      RETURN (Part_Reservation_Control_API.DB_AUTO_RESERVATION);
   ELSE
      RETURN (Get_Part_Reservation_Contro_Db(availability_control_id_));
   END IF;
END Check_Reservation_Control;


-- Check_Order_Issue_Control
--   Returns the dbvalue of part_order_issue_control (order issue, not
--   order issue) of a specific availability control id. If the availability
--   control id is null, it returns the dbvalue order issue.
@UncheckedAccess
FUNCTION Check_Order_Issue_Control (
   availability_control_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (availability_control_id_ IS NULL) THEN
      RETURN (Part_Order_Issue_Control_API.DB_ORDER_ISSUE);
   ELSE
      RETURN (Get_Part_Order_Issue_Contro_Db(availability_control_id_));
   END IF;
END Check_Order_Issue_Control;


-- Check_Man_Reservation_Control
--   Returns the dbvalue of part_manual_reserv_ctrl(manual reserve, not
--   manual reserve) of a specific availability control id. If the availability
--   control id is null, it returns the dbvalue MANUAL_RESERV.
@UncheckedAccess
FUNCTION Check_Man_Reservation_Control (
   availability_control_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (availability_control_id_ IS NULL) THEN
      RETURN (Part_Manual_Reserv_Ctrl_API.DB_MANUAL_RESERVATION);
   ELSE
      RETURN (Get_Part_Manual_Reserv_Ctrl_Db(availability_control_id_));
   END IF;
END Check_Man_Reservation_Control;


-- Check_Counting_Control
--   Returns the dbvalue of part_counting_control(ALLOW REDUCING, NOT ALLOW
--   REDUCING) of a specific availability control id. If the availability
--   control id is null, it returns the dbvalue ALLOW REDUCING.
@UncheckedAccess
FUNCTION Check_Counting_Control (
   availability_control_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (availability_control_id_ IS NULL) THEN
      RETURN (Part_Counting_Control_API.DB_ALLOW_REDUCING);
   ELSE
      RETURN (Get_Part_Counting_Control_Db(availability_control_id_));
   END IF;
END Check_Counting_Control;


-- Check_Scrap_Control
--   Returns the dbvalue of part_scrap_control(SCRAPPABLE, NOT SCRAPPABLE)
--   of a specific availability control id. If the availability control id
--   is null, it returns the dbvalue SCRAPPABLE.
@UncheckedAccess
FUNCTION Check_Scrap_Control (
   availability_control_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (availability_control_id_ IS NULL) THEN
      RETURN (Part_Scrap_Control_API.DB_SCRAPPABLE);
   ELSE
      RETURN (Get_Part_Scrap_Control_Db(availability_control_id_));
   END IF;
END Check_Scrap_Control;


PROCEDURE Check_Part_Movement_Allowed(
   part_no_                 IN VARCHAR2,
   availability_control_id_ IN VARCHAR2 )
IS
BEGIN
   IF Check_Part_Movement_Control(availability_control_id_) = Part_Movement_Control_API.DB_NOT_ALLOWED THEN
      Error_SYS.Record_General('PartAvailabilityControl', 'CANNOTMOVEPART: Part :P1 with Availability Control ID :P2 cannot be moved.', part_no_, availability_control_id_);
   END IF;
END Check_Part_Movement_Allowed;


-- Check_Part_Movement_Control
--   Returns the dbvalue of part_movement_control(ALL ALLOWED, NOT ALLOWED)
--   of a specific availability control id.
@UncheckedAccess
FUNCTION Check_Part_Movement_Control (
   availability_control_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (availability_control_id_ IS NULL) THEN
      RETURN (Part_Movement_Control_API.DB_ALL_ALLOWED);
   ELSE
      RETURN (Get_Part_Movement_Control_Db(availability_control_id_));
   END IF;
END Check_Part_Movement_Control;


@UncheckedAccess
FUNCTION Noorder_Issue_Allowed (
   availability_control_id_ IN VARCHAR2 ) RETURN BOOLEAN  
IS
   part_noorder_issue_control_db_ PART_AVAILABILITY_CONTROL_TAB.part_noorder_issue_control%TYPE;       
   noorder_issue_allowed_ BOOLEAN := FALSE;                        
BEGIN                                                              
   IF (availability_control_id_ IS NULL) THEN                      
      noorder_issue_allowed_ := TRUE;                              
   ELSE                                                            
      part_noorder_issue_control_db_ := Get_Part_Noorder_Issue_Cont_Db(availability_control_id_);          
                                                                   
      IF (part_noorder_issue_control_db_ = Part_Noorder_Issue_Control_API.DB_NON_ORDER_ISSUE) THEN 
         noorder_issue_allowed_ := TRUE;                           
      END IF;                                                      
   END IF;
   RETURN (noorder_issue_allowed_);         

END Noorder_Issue_Allowed;   

@UncheckedAccess
FUNCTION Get_Putaway_Zone_Refill_Src_Db (
   availability_control_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_availability_control_tab.putaway_zone_refill_source%TYPE;
   CURSOR get_attr IS
      SELECT putaway_zone_refill_source
      FROM   PART_AVAILABILITY_CONTROL_TAB
      WHERE  availability_control_id = availability_control_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;   
END Get_Putaway_Zone_Refill_Src_Db;

-- Check_Noorder_Issue_Control
--    Returns the dbvalue of part_noorder_issue_control (non-order issue, not
--    non-order issue) of a specific availability control id. If the availability
--    control id is null, it returns the dbvalue non-order issue.
@UncheckedAccess
FUNCTION Check_Noorder_Issue_Control (
   availability_control_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (availability_control_id_ IS NULL) THEN
      RETURN (Part_Noorder_Issue_Control_API.DB_NON_ORDER_ISSUE);
   ELSE
      RETURN (Get_Part_Noorder_Issue_Cont_Db(availability_control_id_));
   END IF;
END Check_Noorder_Issue_Control;

-- Check_Putaw_Zone_Refill_Source
--    Returns the dbvalue of putaway_zone_refill_source
--    of a specific availability control id.
@UncheckedAccess
FUNCTION Check_Putaw_Zone_Refill_Source (
   availability_control_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (availability_control_id_ IS NULL) THEN
      RETURN (Fnd_Boolean_API.DB_TRUE);
   ELSE
      RETURN Get_Putaway_Zone_Refill_Sou_Db(availability_control_id_);
   END IF;
END Check_Putaw_Zone_Refill_Source;


-- This method is used by DataCaptureInventUtil and DataCaptRecSoByProd
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   capture_session_id_ IN NUMBER )

IS
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;

   CURSOR get_avail_ctrl_id IS
     SELECT availability_control_id
     FROM   part_availability_control_tab
     ORDER BY Utility_SYS.String_To_Number(availability_control_id) ASC, availability_control_id ASC;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      FOR rec_ IN get_avail_ctrl_id LOOP
         Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                          capture_session_id_    => capture_session_id_,
                                          lov_item_value_        => rec_.availability_control_id,
                                          lov_item_description_  => Get_Description(rec_.availability_control_id),
                                          lov_row_limitation_    => lov_row_limitation_,    
                                          session_rec_           => session_rec_);
         EXIT WHEN exit_lov_;

      END LOOP;
   $ELSE
      NULL;  
   $END
END Create_Data_Capture_Lov;



