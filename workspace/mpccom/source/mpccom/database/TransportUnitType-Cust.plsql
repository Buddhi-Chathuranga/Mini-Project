-----------------------------------------------------------------------------
--
--  Logical unit: TransportUnitType
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220525  SEBSA-SUPULI   SA_TRA_1_09_10-1-MPL; Override Check_COmmon___
--  220525  SEBSA-SUPULI   SA_TRA_1_09_10-1-MPL; Created
-----------------------------------------------------------------------------

layer Cust;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Start)
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     transport_unit_type_tab%ROWTYPE,
   newrec_ IN OUT transport_unit_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Start)
   IF (newrec_.c_height IS NULL OR newrec_.c_width IS NULL)THEN
      Error_SYS.Record_General(lu_name_, 'CNOWIDTHHEIGHT: Height and Width values are mandatory for Transport Unit Type');
   END IF;
   -- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Finish)
END Check_Common___;
-- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Finish)


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU CUST NEW METHODS -------------------------------------
