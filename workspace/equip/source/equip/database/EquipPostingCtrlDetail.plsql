-----------------------------------------------------------------------------
--
--  Logical unit: EquipPostingCtrlDetail
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131128   ChAmlk  Hooks: Created
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
   Posting_Ctrl_Crecomp_API.Make_Company_Detail_Gen( 'EQUIP', lu_name_, 'EQUIP_POSTING_CTRL_DETAIL_API', attr_ );
END Make_Company;



