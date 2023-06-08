-----------------------------------------------------------------------------
--
--  Logical unit: EquipPostingCtrl
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110404   NRATLK  Created
--  131121   NEKOLK  Refactored and splitted.
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
   Posting_Ctrl_Crecomp_API.Make_Company_Gen( 'EQUIP', lu_name_, 'EQUIP_POSTING_CTRL_API', attr_ );
END Make_Company;



