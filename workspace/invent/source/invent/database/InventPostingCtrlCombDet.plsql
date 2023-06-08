-----------------------------------------------------------------------------
--
--  Logical unit: InventPostingCtrlCombDet
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050816  reanpl   Create
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
   Posting_Ctrl_Crecomp_API.Make_Company_Comb_Detail_Gen( 'INVENT', lu_name_, 'INVENT_POST_CTRL_COMB_DET_API', attr_ );
END Make_Company;   



