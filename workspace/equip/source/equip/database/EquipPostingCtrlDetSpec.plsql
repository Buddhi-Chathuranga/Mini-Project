-----------------------------------------------------------------------------
--
--  Logical unit: EquipPostingCtrlDetSpec
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110404   NRATLK  Created
--  131130  NEKOLK  PBSA-1839: Hooks: Refactored and split code.
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
   Posting_Ctrl_Crecomp_API.Make_Company_Detail_Spec_Gen( 'EQUIP', lu_name_, 'EQUIP_POST_CTRL_DET_SPEC_API', attr_ );
END Make_Company;



