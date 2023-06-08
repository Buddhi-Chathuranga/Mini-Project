-----------------------------------------------------------------------------
--
--  Logical unit: MpccomShipVia
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220525  SEBSA-SUPULI   SA_TRA_1_09_10-1-MPL : Override Check_Common___
--  220525  SEBSA-SUPULI   SA_TRA_1_09_10-1-MPL : Created
-----------------------------------------------------------------------------

layer Cust;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Start)
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     mpccom_ship_via_tab%ROWTYPE,
   newrec_ IN OUT mpccom_ship_via_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   -- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Start)
   IF newrec_.transport_unit_type IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'CNOTRANSUNITTYPE: Transport Unit Type is mandatory for the ship via code');
   END IF;
   -- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Finish)
END Check_Common___;
-- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Finish)



-------------------- LU CUST NEW METHODS -------------------------------------
