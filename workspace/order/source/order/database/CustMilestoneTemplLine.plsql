-----------------------------------------------------------------------------
--
--  Logical unit: CustMilestoneTemplLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160830  IzShlk STRSC-1783, Overriden Check_Update___ to make sure parent is not blocked for access.
--  100513  Ajpelk Merge rose method documentation
--  090923  MaMalk Removed unused procedure Withdraw_Parenthood___. 
-- --------------------------------------14.0.0----------------------
--  060110  CsAmlk Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
-- --------------------------------------13.3.0----------------------
--  000913  FBen  Added UNDEFINE.
--  990601  JakH  CID 18922 Negative lead times not allowed.
--  990419  RaKu  Y.Cleanup.
--  990409  PaLj  YOSHIMURA - New Template
--  981116  CAST  SID 6934: Leadtime has to be an integer.
--  981103  CAST  Check that progress is a number between 0 and 100.
--  981020  CAST  Added column PROGRESS.
--  980826  KaSu  Declared the LU Specific Implementaions methods.
--                Also moved the LU specific method definitions
--                to the correct place.
--  980823  KaSu  Modified Check_For_Cycle___ and CUST_MILESTONE_TEMPL_LINE_PAR
--  980806  KaSu  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Validate_Insert___
--   This will do validation regarding the template milestones before
--   inserting a record.
PROCEDURE Validate_Insert___ (
   newrec_ IN CUST_MILESTONE_TEMPL_LINE_TAB%ROWTYPE )
IS
BEGIN
   --checking for valid parent
   IF (newrec_.previous_milestone IS NOT NULL) THEN
      IF NOT Check_Exist___ ( newrec_.template_id , newrec_.previous_milestone ) THEN
         Error_SYS.Record_General(lu_name_, 'PREVIOUSMISSING: Corresponding previous milestone is not found');
      END IF;
   END IF;
   --checking for valid progress
   IF (newrec_.progress < 0) OR (newrec_.progress > 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGPROGRESS: Progress must be a number between 0 and 100');
   END IF;
   --checking that lead_time is an integer
   IF (newrec_.lead_time != TRUNC(newrec_.lead_time, 0)) THEN
      Error_SYS.Record_General(lu_name_, 'LEADTIMENOTINTEGER: The lead time can only be integer');
   END IF;
END  Validate_Insert___;


-- Validate_Update___
--   This will do validation regarding the template milestones before
--   updating a record.
PROCEDURE Validate_Update___ (
   newrec_ IN CUST_MILESTONE_TEMPL_LINE_TAB%ROWTYPE )
IS
BEGIN
   --checking for valid parent
   IF (newrec_.previous_milestone IS NOT NULL) THEN
      IF NOT Check_Exist___ ( newrec_.template_id , newrec_.previous_milestone ) THEN
         Error_SYS.Record_General(lu_name_, 'PREVIOUSMISSING: Corresponding previous milestone is not found');
      ELSIF (newrec_.previous_milestone = newrec_.milestone_id) THEN
         Error_SYS.Record_General(lu_name_, 'SAMEPREVIOUS: A milestone cannot have itself as its previous milestone');
      END IF;
      Check_For_Cycle___(newrec_);
   END IF;
   --checking for valid progress
   IF (newrec_.progress < 0) OR (newrec_.progress > 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGPROGRESS: Progress must be a number between 0 and 100');
   END IF;
   --checking that lead_time is an integer
   IF (newrec_.lead_time != TRUNC(newrec_.lead_time, 0)) THEN
      Error_SYS.Record_General(lu_name_, 'LEADTIMENOTINTEGER: The lead time can only be integer');
   END IF;
END  Validate_Update___;


-- Check_For_Cycle___
--   This will check whether there exist any cycles when entering a
--   template milestone.
--   If there exist any cycle then this will give error.
--   e.g. for cycle :
--   A is parent of B.
--   B is parent of C.
--   C is parent of A.
PROCEDURE Check_For_Cycle___ (
   newrec_ IN CUST_MILESTONE_TEMPL_LINE_TAB%ROWTYPE )
IS
   ascendent_count_     NUMBER;
   previous_milestone_  VARCHAR2(5);

   CURSOR cur_asec_count IS
      SELECT count(*)
      FROM   CUST_MILESTONE_TEMPL_LINE_TAB
      WHERE  template_id =  newrec_.template_id;
BEGIN
   OPEN  cur_asec_count;
   FETCH cur_asec_count INTO ascendent_count_;
   CLOSE cur_asec_count;
   previous_milestone_ := newrec_.previous_milestone;
   WHILE ( ascendent_count_ > 0 ) AND (previous_milestone_ IS NOT NULL) AND (newrec_.milestone_id != previous_milestone_) LOOP
      ascendent_count_  := ascendent_count_ - 1 ;
      previous_milestone_ := Get_Previous_Milestone(newrec_.template_id, previous_milestone_);
   END LOOP;
   IF (previous_milestone_ IS NOT NULL) OR (newrec_.milestone_id = previous_milestone_) THEN
      Error_SYS.Record_General(lu_name_, 'CYCLE: There should not be any cycles when setting previous milestones ');
   END IF;
END Check_For_Cycle___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PROGRESS', 0, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_milestone_templ_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);  
   Validate_Insert___(newrec_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_milestone_templ_line_tab%ROWTYPE,
   newrec_ IN OUT cust_milestone_templ_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_); 
   Cust_Milestone_Templ_API.Exist(newrec_.template_id, TRUE);
   Validate_Update___(newrec_);  
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     cust_milestone_templ_line_tab%ROWTYPE,
   newrec_ IN OUT cust_milestone_templ_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
   
   IF (newrec_.lead_time IS NOT NULL AND indrec_.lead_time)
   AND (Validate_SYS.Is_Changed(oldrec_.lead_time, newrec_.lead_time) AND (newrec_.lead_time < 0)) THEN
      Error_SYS.Record_General(lu_name_, 'NEGLEADTIME: Lead time must not be less than zero.');
   END IF;
END Check_Common___;





-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Delete_Tree (
   template_id_ IN VARCHAR2,
   milestone_id_ IN VARCHAR2 )
IS
BEGIN
   NULL;
END Delete_Tree;



