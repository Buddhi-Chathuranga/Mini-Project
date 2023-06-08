-----------------------------------------------------------------------------
--
--  Logical unit: CounterPartCompMapping
--  Component:    ACCRUL
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220520  jadulk  FIDEV-10472, Added Create_Rec, Remove_Rec and Modify_Rec to handle counter part values.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Rec(
   newrec_  IN OUT counter_part_comp_mapping_tab%ROWTYPE)
IS
BEGIN
   New___(newrec_);
END Create_Rec;


PROCEDURE Remove_Rec(
   newrec_  IN OUT counter_part_comp_mapping_tab%ROWTYPE)
IS
BEGIN
   Delete___(newrec_);
END Remove_Rec;


PROCEDURE Modify_Rec(
   newrec_  IN OUT counter_part_comp_mapping_tab%ROWTYPE)
IS
BEGIN
   Modify___(newrec_);
END Modify_Rec;