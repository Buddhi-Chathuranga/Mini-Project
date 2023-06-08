-----------------------------------------------------------------------------
--
--  Logical unit: SourcingObjective
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100513  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040226  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  ----------------Version 13.3.0---------------------------------------------
--  030820  GaSolk  Performed CR Merge(CR Only).
--  030516  DaZa    Changed view comments on RULE_ID to Sourcing Rule.
--  030505  JoEd    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Criterion___
--   Checks if the passed criterion already has been used on the current rule.
--   Error message is raised if this is the case.
PROCEDURE Check_Criterion___ (
   rule_id_            IN VARCHAR2,
   sequence_no_        IN NUMBER,
   sourcing_criterion_ IN VARCHAR2 )
IS
   CURSOR exist_control IS
      SELECT 1
      FROM SOURCING_OBJECTIVE_TAB
      WHERE rule_id = rule_id_
      AND sequence_no != sequence_no_
      AND sourcing_criterion = sourcing_criterion_;
   dummy_  NUMBER;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_General(lu_name_, 'CRITERIONEXIST: The sourcing criterion ":P1" is already used in this rule.',
         Sourcing_Criterion_API.Decode(sourcing_criterion_));
   ELSE
      CLOSE exist_control;
   END IF;
END Check_Criterion___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sourcing_objective_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   -- instead of dup_val_on_index error...
   IF Check_Exist___(newrec_.rule_id, newrec_.sequence_no) THEN
      Error_SYS.Record_General(lu_name_, 'SEQUENCEEXIST: Sourcing sequence :P1 already exists.', newrec_.sequence_no);
   ELSE
      Check_Criterion___(newrec_.rule_id, newrec_.sequence_no, newrec_.sourcing_criterion);
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sourcing_objective_tab%ROWTYPE,
   newrec_ IN OUT sourcing_objective_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   old_criterion_ SOURCING_OBJECTIVE_TAB.sourcing_criterion%TYPE;
BEGIN
   old_criterion_ := newrec_.sourcing_criterion;
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.sourcing_criterion != old_criterion_) THEN
      Check_Criterion___(newrec_.rule_id, newrec_.sequence_no, newrec_.sourcing_criterion);
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


