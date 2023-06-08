-----------------------------------------------------------------------------
--
--  Logical unit: SiteDataCaptureMenu
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200506	BudKlk  SC2020R1-6885,Removed dupilcated private New__() and Remove__().
--	160310	KhVeSe	LIM-4892 ,Removed public method Remove().
--  160223  KhVeSe  LIM-4892 ,Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Site_API.New_Data_Capture_Menu__(info_, objid_, objversion_, attr_, action_);
END New__;

PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
BEGIN
   Site_API.Remove_Data_Capture_Menu__(info_, objid_, objversion_, action_);
END Remove__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

