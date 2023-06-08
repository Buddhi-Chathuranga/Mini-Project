-----------------------------------------------------------------------------
--
--  Logical unit: InventoryValue
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110525  Cpeilk  Bug 95775, Modified method Set_Complete_Flag to set the complete flag for the previous periods.
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  100507  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060110  GeKalk  Changed the SELECT &OBJID statement to the RETURNING &OBJID in Insert___.
--  051117  LEPESE  Redesign of method Get_Max_Period to look at end_date when
--  051117          deciding which period is the latest.
--  040301  GeKalk  Removed substrb from the view for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  030910  ThPalk  Bug 38287, Added Function Is_Any_Record_Exist
--  001130  LEPE    Added PROCEDURE Get_Max_Year_Period.
--  000925  JOHESE  Added undefines.
--  000417  NISOSE  Added General_SYS.Init_Method in Check_Exist.
--  990505  SHVE    General performance improvements.
--  990414  SHVE    Upgraded to performance optimized template.
--  990223  JOKE    Removed attribut Total_Value.
--  990214  JOKE    Added fetch of objid and objversion plus removed key_columns
--                  from attr_ in Set_Complete_Flag and Reset complete_flag.
--  990212  JOKE    Corrected spelling in Public Method: New.
--  990211  JOHW    Added public function and procedures.
--  990210  JOHW    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INVENTORY_VALUE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
  site_date_ DATE;
BEGIN
   site_date_ := Site_API.Get_Site_Date(newrec_.contract);
   newrec_.create_date := site_date_;
   newrec_.last_activity_date := site_date_;

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     INVENTORY_VALUE_TAB%ROWTYPE,
   newrec_     IN OUT INVENTORY_VALUE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.last_activity_date := Site_API.Get_Site_Date(newrec_.contract);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public New method.
PROCEDURE New (
   contract_              IN VARCHAR2,
   stat_year_no_          IN NUMBER,
   stat_period_no_        IN NUMBER,
   complete_flag_db_      IN VARCHAR2 )
IS
   attr_                  VARCHAR2(32000);
   objid_                 INVENTORY_VALUE.objid%TYPE;
   objversion_            INVENTORY_VALUE.objversion%TYPE;
   newrec_                INVENTORY_VALUE_TAB%ROWTYPE;
   indrec_                Indicator_Rec;

BEGIN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Client_SYS.Add_To_Attr('STAT_YEAR_NO', stat_year_no_, attr_);
      Client_SYS.Add_To_Attr('STAT_PERIOD_NO', stat_period_no_, attr_);
      Client_SYS.Add_To_Attr('COMPLETE_FLAG_DB', complete_flag_db_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Check_Exist
--   Returns true if check exist.
FUNCTION Check_Exist (
   contract_       IN VARCHAR2,
   stat_year_no_   IN NUMBER,
   stat_period_no_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   IF Check_Exist___(contract_, stat_year_no_, stat_period_no_) THEN
      RETURN TRUE;
   END IF;
   RETURN FALSE;
END Check_Exist;


-- Set_Complete_Flag
--   Sets the complete_flag_db to Y.
PROCEDURE Set_Complete_Flag (
   contract_       IN VARCHAR2,
   stat_year_no_   IN NUMBER,
   stat_period_no_ IN NUMBER )
IS
   oldrec_             INVENTORY_VALUE_TAB%ROWTYPE;
   newrec_             INVENTORY_VALUE_TAB%ROWTYPE;
   objid_              INVENTORY_VALUE.objid%TYPE;
   objversion_         INVENTORY_VALUE.objversion%TYPE;
   attr_               VARCHAR2 (32000);
   complete_flag_db_   INVENTORY_VALUE_TAB.complete_flag%TYPE;
   previous_year_no_   INVENTORY_VALUE_TAB.stat_year_no%TYPE;
   previous_period_no_ INVENTORY_VALUE_TAB.stat_period_no%TYPE;
   indrec_             Indicator_Rec;
BEGIN

   oldrec_ := Lock_By_Keys___(contract_,stat_year_no_,stat_period_no_);
   IF (oldrec_.complete_flag = 'N') THEN
      newrec_           := oldrec_;
      complete_flag_db_ := 'Y';

      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('COMPLETE_FLAG_DB', complete_flag_db_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_,oldrec_, newrec_, attr_,objversion_,TRUE);
   END IF;
   
   Statistic_Period_API.Get_Previous_Period(previous_year_no_, previous_period_no_, stat_year_no_, stat_period_no_);
   IF (Check_Exist___(contract_, previous_year_no_, previous_period_no_)) THEN
      Set_Complete_Flag(contract_, previous_year_no_, previous_period_no_ );
   END IF;
END Set_Complete_Flag;


-- Reset_Complete_Flag
--   Sets the complete_flag_db to N.
PROCEDURE Reset_Complete_Flag (
   contract_       IN VARCHAR2,
   stat_year_no_   IN NUMBER,
   stat_period_no_ IN NUMBER )
IS
   oldrec_                        INVENTORY_VALUE_TAB%ROWTYPE;
   newrec_                        INVENTORY_VALUE_TAB%ROWTYPE;
   objid_                         INVENTORY_VALUE.objid%TYPE;
   objversion_                    INVENTORY_VALUE.objversion%TYPE;
   attr_                          VARCHAR2 (32000);
   complete_flag_db_              INVENTORY_VALUE_TAB.complete_flag%TYPE;
   indrec_                        Indicator_Rec;
BEGIN

   oldrec_ := Lock_By_Keys___(contract_,stat_year_no_,stat_period_no_);
   newrec_ := oldrec_;

   complete_flag_db_:= 'N';

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('COMPLETE_FLAG_DB', complete_flag_db_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_,oldrec_, newrec_, attr_,objversion_,TRUE);
END Reset_Complete_Flag;


PROCEDURE Get_Max_Year_Period (
   stat_year_no_   OUT NUMBER,
   stat_period_no_ OUT NUMBER,
   contract_       IN  VARCHAR2 )
IS
   CURSOR get_max_year_period IS
      SELECT stat_year_no, stat_period_no
        FROM statistic_period_pub
        WHERE end_date = (SELECT MAX(end_date)
                            FROM INVENTORY_VALUE_TAB iv, statistic_period_pub sp
                           WHERE iv.stat_year_no   = sp.stat_year_no
                             AND iv.stat_period_no = sp.stat_period_no
                             AND contract          = contract_);
BEGIN

   OPEN  get_max_year_period;
   FETCH get_max_year_period INTO stat_year_no_, stat_period_no_;
   CLOSE get_max_year_period;

END Get_Max_Year_Period;


@UncheckedAccess
FUNCTION Is_Any_Record_Exist RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   INVENTORY_VALUE_TAB ;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(1);
   END IF;
   CLOSE exist_control;
   RETURN(0);
END Is_Any_Record_Exist;



