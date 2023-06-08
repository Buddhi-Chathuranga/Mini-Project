-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalGroupSpec
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131203  NuKuLK  PBSA-2926, cleanup.
--  131126  NuKuLK  Hooks: Refactored and splitted code.
--  --------------------------- APPS 9 --------------------------------------
--  060925  UsRaLK Bug #60602: removed spec order check from Unpack_Check_Insert___ and Unpack_Check_Update___.
--  000629  JoSc   Replaced module declaration PLADES with APPSR
--  --------------------------- APP10 EXTEND --------------------------------
--  191028  TAJALK Corrected error message
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT technical_group_spec_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   group_name_ VARCHAR2(40);
   CURSOR exist_in_other_grp IS
      SELECT group_name 
      FROM TECHNICAL_GROUP_SPEC_TAB
      WHERE technical_class = newrec_.technical_class
        AND attribute = newrec_.attribute;

BEGIN
   super(newrec_, indrec_, attr_);
   OPEN exist_in_other_grp;
   FETCH exist_in_other_grp INTO group_name_;
   IF (exist_in_other_grp%FOUND ) THEN
      CLOSE exist_in_other_grp;
      Error_SYS.Record_General(lu_name_, 'ATTRIBINOTHERGROUP: Attribute :P1 already exist in group :P2', newrec_.attribute, group_name_);
   END IF;
   CLOSE exist_in_other_grp;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


