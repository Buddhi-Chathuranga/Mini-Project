-----------------------------------------------------------------------------
--
--  Logical unit: OrdAggStatLog
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100519  KRPELK  Merge Rose Method Documentation.
--  091208  MaMalk  Made the necessary changes to make Company and AggregateId the key.
--  ----------------- 14.0.0 ------------------------------------------------
--  060726  ThGulk Added Objid instead of rowid in Procedure Insert__
--  060112  NaWalk Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  040220  IsWilk Removed the SUBSTRB from view for Unicode Changes.
--  ------------- Edge Package Group 3 Unicode Changes-----------------------
--  000228  JakH  Added public New, Modify and Get_Process_Id
--  000126  JakH  Init_Method fixes.
--  -------------------- 12.0 ----------------------------------------------
--  990407  JakH  New template, removed public view, removed get_log_item.
--                Added public remove.
--  990208  JoEd  Run through Design.
--  990117  KaSu  Renamed OrdAggProcessStat as OrdProcessStatus
--                Renamed Ord_Agg_Process_stat_API as Ord_Process_Status_API
--                Renamed Ord_Agg_Process_stat as Status
--  98xxxx  xxxx  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Modify
--   This public method will modify a log entry specified by its key, the ProcessId.
PROCEDURE Modify (
   attr_         IN OUT VARCHAR2,
   company_      IN VARCHAR2,
   aggregate_id_ IN NUMBER )
IS
   newrec_     ORD_AGG_STAT_LOG_TAB%ROWTYPE;
   oldrec_     ORD_AGG_STAT_LOG_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(company_, aggregate_id_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify;


-- New
--   This public method will create a new log entry for a specified
--   Aggregate_ID and will return it's process_id
PROCEDURE New (
   attr_    IN OUT VARCHAR2 )
IS
   newrec_     ORD_AGG_STAT_LOG_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);   
END New;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
FUNCTION Exist (
   company_      IN VARCHAR2,
   aggregate_id_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(company_, aggregate_id_);
END;



