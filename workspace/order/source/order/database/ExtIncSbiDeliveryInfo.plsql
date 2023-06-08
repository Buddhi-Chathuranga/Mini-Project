-----------------------------------------------------------------------------
--
--  Logical unit: ExtIncSbiDeliveryInfo
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050701 UsRalk Added public method [New].
--  050629 UsRalk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   attr_ IN VARCHAR2 )
IS
   newrec_     EXT_INC_SBI_DELIVERY_INFO_TAB%ROWTYPE;
   newattr_    VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   newattr_ := attr_;  
   Unpack___(newrec_, indrec_, newattr_);
   Check_Insert___(newrec_, indrec_, newattr_);
   Insert___(objid_, objversion_, newrec_, newattr_);
END New;



