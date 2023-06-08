-----------------------------------------------------------------------------
--
--  Logical unit: SerialWarrantyDates
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201222  SBalLK  Issue SC2020R1-11830, Modified Calculate_Dates(both), Remove_Type() and Copy() methods by removing attr_ functionality
--  201222          to optimize the performance.
--  150616  IsSalk  KES-517, Removed Remove_Warranty_Dates() and added Remove_Serial().
--  150406  IsSalk  KES-517, Added Remove_Warranty_Dates() to remove warranty dates connected to the serial part.
--  130729  MaIklk  TIBE-1049, Removed global constants and used conditional compilation instead.
--  100423  KRPELK  Merge Rose Method Documentation.
--  100120  HimRlk   Moved method calls to Transaction_SYS.Logical_Unit_Is_Installed to Global constants.
--  060727  ThGulk  Added &OBJID instead of rowif in Procedure Insert___
--  060123  JaJalk  Added Assert safe annotation.
--  060110  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  050919  NaLrlk  Removed unused variables.
--  040527  SHVESE  M4/Transibal merge: Removed the check for state_ in method Calculate_Warranty_Dates.
--  040428  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs.
--  040217  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  040211  IsAnlk  B110740 - Removed REF from Warranty Type ID in view comments.
--  031231  IsAnlk  Removed General_SYS.Init_Method calls from implementation methods.
--  031223  IsAnlk  Changed the positions of Procedure Copy,Calculate_Dates(both) to tally with the Cat. Changed the parameter
--                  Order Of Lock_By_Keys___ to tally wiht the Cat file.
--  -------------------------------- 12.3.0 ----------------------------------
--  030428  SaAblk  Call 96195: Modified Calculate_Dates to refer to MPCCOM methods via Dynamic PLSQL.
--  030204  viasno  WP610 Warranties, Added Calculate_Dates(5 param).
--  020917  JoAnSe  -- Merged the IceAge bugg corrections below onto the AD 2002-3 track. --
--  020823  NuFilk  Bug 32228, Set the old record values to the new record in the Copy procedure.
--  020701  NuFilk  Bug 21502, Commented code which removes the old record in the Copy procedure.
--  ------------------------------------ IceAge Merge End ---------------------
--  020522  CHFOLK  Extended the length to 50 of the variable, serial_no in
--                  Calculate_Warranty_Dates and the view comments.
--  ------------------------------------ AD 2002-3 Baseline -------------------
--  010525  JSAnse  Modified the General_SYS.Init_Method call in Calculate_Dates.
--                  Removed 'TRUE' as last parameter and changed to the correct name.
--  001129  PaLj    Added dynamic call to Warranty_condition_API.Exist.
--  001124  PaLj    Added method Check_Condition__ and Remove_Type
--  001123  PaLj    Changed Unpack_Check_Insert and Copy
--  001121  JoEd    Changed reference to CustWarrantyCondition.
--  001120  PaLj    Rebuild: now having dynamic calls to Mpccom LU:s
--  001115  PaLj    Added method Copy.
--  001102  PaLj    Changed method Calculate_Warranty_Dates
--  001025  PaLj    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Condition__
--   This is used to check the given Warranty ID is used by other instances
--   of this class. If it is used, it will give an error message.
PROCEDURE Check_Condition__ (
   warranty_id_      IN NUMBER,
   warranty_type_id_ IN VARCHAR2,
   condition_id_     IN NUMBER )
IS
   CURSOR check_cond IS
   SELECT count(*)
   FROM serial_warranty_dates_tab
   WHERE warranty_id    = warranty_id_
   AND warranty_type_id = warranty_type_id_
   AND condition_id     = condition_id_;

   cnt_ NUMBER;

BEGIN
   OPEN check_cond;
   FETCH check_cond INTO cnt_;
   CLOSE check_cond;
   IF cnt_ > 0 THEN
      Error_SYS.Record_Constraint(lu_name_, 'Serial Warranty Dates',to_char(cnt_));
   END IF;
END Check_Condition__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Calculate_Warranty_Dates
--   Called by customer order when delivering a serial part
PROCEDURE Calculate_Warranty_Dates (
   part_no_       IN VARCHAR2,
   serial_no_     IN VARCHAR2,
   delivery_date_ IN DATE DEFAULT Sysdate )
IS
   sup_warranty_id_  NUMBER;
   cust_warranty_id_ NUMBER;   
BEGIN
   Trace_SYS.Field('part_no_ ',part_no_);
   Trace_SYS.Field('serial_no_ ',serial_no_);

   sup_warranty_id_ := Part_Serial_Catalog_API.Get_Sup_Warranty_Id(part_no_, serial_no_);
   IF (sup_warranty_id_ IS NOT NULL) THEN
      $IF (Component_Mpccom_SYS.INSTALLED) $THEN
         Sup_Warranty_Type_API.Warranty_Dates_At_Delivery(part_no_, serial_no_, sup_warranty_id_, delivery_date_);
      $ELSE
         NULL;
      $END
   END IF;
   cust_warranty_id_ := Part_Serial_Catalog_API.Get_Cust_Warranty_Id(part_no_, serial_no_);
   IF (cust_warranty_id_ IS NOT NULL) THEN
      $IF (Component_Mpccom_SYS.INSTALLED) $THEN
         Cust_Warranty_Type_API.Warranty_Dates_At_Delivery(part_no_, serial_no_, cust_warranty_id_, delivery_date_);                     
      $ELSE
         NULL;
      $END
   END IF;
   Part_Serial_Catalog_API.Get_Children_And_Calculate(part_no_, serial_no_, delivery_date_);
END Calculate_Warranty_Dates;


-- Calculate_Dates
--   - Calculates valid from date and valid to date
--   Calculate valid from date and to date using entered time unit.
--   Calculate valid from date and valid to date.
PROCEDURE Calculate_Dates (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   warranty_id_      IN NUMBER,
   warranty_type_id_ IN VARCHAR2,
   condition_id_     IN NUMBER,
   time_unit_        IN VARCHAR2,
   min_value_        IN NUMBER,
   max_value_        IN NUMBER,
   start_date_       IN DATE,
   year_             IN VARCHAR2,
   month_            IN VARCHAR2,
   day_              IN VARCHAR2 )
IS
   from_date_  DATE;
   to_date_    DATE;
   newrec_     serial_warranty_dates_tab%ROWTYPE;
BEGIN
   IF NOT Check_Exist___ (part_no_, serial_no_, warranty_id_, warranty_type_id_, condition_id_) THEN
      IF time_unit_ = year_ THEN
        --Year--
        from_date_ := add_months(start_date_, 12*min_value_);
        to_date_   := add_months(start_date_, 12*max_value_);
      ELSIF time_unit_ = month_ THEN
        --Month--
        from_date_ := add_months(start_date_, min_value_);
        to_date_   := add_months(start_date_, max_value_);
      ELSIF time_unit_ = day_ THEN
        --Day--
        from_date_ := start_date_ + min_value_;
        to_date_   := start_date_ + max_value_;
      ELSE
        Error_SYS.Record_General(lu_name_, 'WRONG_UNIT: The time unit :P1 is not valid!',time_unit_);
      END IF;
      
      newrec_.part_no          := part_no_;
      newrec_.serial_no        := serial_no_;
      newrec_.warranty_id      := warranty_id_;
      newrec_.warranty_type_id := warranty_type_id_;
      newrec_.condition_id     := condition_id_;
      newrec_.valid_from       := from_date_;
      newrec_.valid_to         := to_date_;
      New___(newrec_);
   END IF;
END Calculate_Dates;


-- Calculate_Dates
--   - Calculates valid from date and valid to date
--   Calculate valid from date and to date using entered time unit.
--   Calculate valid from date and valid to date.
PROCEDURE Calculate_Dates (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   warranty_id_      IN NUMBER,
   warranty_type_id_ IN VARCHAR2,
   condition_id_     IN NUMBER,
   start_date_       IN DATE )
IS
   from_date_    DATE;
   to_date_      DATE;
   min_value_    NUMBER;
   max_value_    NUMBER;
   time_unit_    VARCHAR2(20);
   newrec_       serial_warranty_dates_tab%ROWTYPE;
BEGIN

   $IF (Component_Mpccom_SYS.INSTALLED) $THEN
      DECLARE            
         warranty_rec_  Sup_Warranty_Condition_API.Public_Rec;
      BEGIN
         time_unit_     := Warranty_Condition_API.Get_Time_Unit_Db( condition_id_ );
         warranty_rec_  := Sup_Warranty_Condition_API.Get( warranty_id_, warranty_type_id_, condition_id_ );
         min_value_ := warranty_rec_.min_value;
         max_value_ := warranty_rec_.max_value;
      END;

      IF (time_unit_ = 'YEAR') THEN
         from_date_ := add_months(start_date_, 12 * min_value_);
         to_date_   := add_months(start_date_, 12 * max_value_);
      ELSIF (time_unit_ = 'MONTH') THEN
         from_date_ := add_months(start_date_, min_value_);
         to_date_   := add_months(start_date_, max_value_);
      ELSIF (time_unit_ = 'DAY') THEN
         from_date_ := start_date_ + min_value_;
         to_date_   := start_date_ + max_value_;
      ELSE
         Error_SYS.Record_General(lu_name_, 'WRONG_UNIT: The time unit :P1 is not valid!',time_unit_);
      END IF;
      --
      IF ( NOT Check_Exist___ (part_no_, serial_no_, warranty_id_, warranty_type_id_, condition_id_)) THEN
         newrec_.part_no          := part_no_;
         newrec_.serial_no        := serial_no_;
         newrec_.warranty_id      := warranty_id_;
         newrec_.warranty_type_id := warranty_type_id_;
         newrec_.condition_id     := condition_id_;
         newrec_.valid_from       := from_date_;
         newrec_.valid_to         := to_date_;
         New___(newrec_);
      ELSE
         newrec_ := Lock_By_Keys___(part_no_, serial_no_, warranty_id_, warranty_type_id_, condition_id_);
         newrec_.valid_from := from_date_;
         newrec_.valid_to   := to_date_;
         Modify___(newrec_);
      END IF;
   $ELSE
      NULL;      
   $END

END Calculate_Dates;


-- Copy
--   This method will copy from one Warranty ID to another Warranty ID
--   for a specific part no and serial no combination.
PROCEDURE Copy (
   old_warranty_id_ IN NUMBER,
   new_warranty_id_ IN NUMBER,
   part_no_         IN VARCHAR2,
   serial_no_       IN VARCHAR2 )
IS
   CURSOR get_record IS
      SELECT *
      FROM serial_warranty_dates_tab
      WHERE warranty_id = old_warranty_id_
      AND part_no       = part_no_
      AND serial_no     = serial_no_;

   newrec_     serial_warranty_dates_tab%ROWTYPE;
BEGIN
   FOR rec_ IN get_record LOOP
      -- Add the new record
      newrec_             := rec_;
      newrec_.warranty_id := new_warranty_id_;
      New___(newrec_);
   END LOOP;
END Copy;


PROCEDURE Remove_Type (
   warranty_id_      IN NUMBER,
   warranty_type_id_ IN VARCHAR2 )
IS
   CURSOR get_remrec IS
      SELECT *
      FROM   serial_warranty_dates_tab
      WHERE  warranty_id      = warranty_id_
      AND    warranty_type_id = warranty_type_id_
      FOR UPDATE;
BEGIN
   FOR remrec_ IN get_remrec LOOP
      Remove___(remrec_);
   END LOOP;
END Remove_Type;

-- Remove_Serial
PROCEDURE Remove_Serial (
   part_no_     IN VARCHAR2,
   serial_no_   IN VARCHAR2,
   warranty_id_ IN NUMBER  )
IS
   CURSOR get_remrec IS
      SELECT *
        FROM serial_warranty_dates_tab
       WHERE  part_no     = part_no_
         AND  serial_no   = serial_no_ 
         AND  warranty_id = warranty_id_
         FOR UPDATE;
BEGIN
   FOR remrec_ IN get_remrec LOOP
      Remove___(remrec_);
   END LOOP;
END Remove_Serial;
