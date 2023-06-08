-----------------------------------------------------------------------------
--
--  Logical unit: EquipPostingCtrlCDetSpec
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110404   NRATLK  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Make_Company (
   attr_       IN VARCHAR2 )
IS
BEGIN
   Posting_Ctrl_Crecomp_API.Make_Company_Comb_Det_Spec_Gen( 'EQUIP', lu_name_, 'EQUIP_POST_CTRL_CDET_SPEC_API', attr_ );
END Make_Company;



