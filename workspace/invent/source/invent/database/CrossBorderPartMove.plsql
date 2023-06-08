-----------------------------------------------------------------------------
--
--  Logical unit: CrossBorderPartMove
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date       Sign    History
--  ------     ------  ---------------------------------------------------------
-- 2021-12-10  MaEelk  SC21R2-1762, Added IgnoreUnitTest annotation to Check_Insert___ and Validate_Rec___.
-- 2021-07-16  MaEelk  SC21R2-1884, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT NOCOPY cross_border_part_move_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   
BEGIN
   Validate_Rec___(newrec_);
   SUPER(newrec_, indrec_, attr_);
END Check_Insert___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Validate_Rec___ (
   newrec_ IN cross_border_part_move_tab%ROWTYPE )
IS
BEGIN
   IF (newrec_.sender_country = newrec_.receiver_country) THEN
      Error_SYS.Record_General(lu_name_, 'SAMECOUNTRY: Sender Country and Receiver Country cannot be the same');   
   END IF;
END Validate_Rec___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

