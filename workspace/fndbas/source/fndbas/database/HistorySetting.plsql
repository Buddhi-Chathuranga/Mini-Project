-----------------------------------------------------------------------------
--
--  Logical unit: HistorySetting
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990629  RaKu  Created.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  050426  UTGU  Added method Register(F1PR480).
--  050704  HAAR  Changed view to use Dba_Tables instead of User_Tables. (F1PR843)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Register (
   table_name_ IN VARCHAR2,
   info_msg_   IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     HISTORY_SETTING_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   objrec_.table_name := table_name_;
   objrec_.activate_cleanup := Message_SYS.Find_Attribute(info_msg_, 'ACTIVATE_CLEANUP', 'FALSE');
   objrec_.days_to_keep := Message_SYS.Find_Attribute(info_msg_, 'DAYS_TO_KEEP', 0 );
   Insert___ (objid_, objversion_, objrec_, attr_);
END Register;


