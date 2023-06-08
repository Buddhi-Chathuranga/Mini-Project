-----------------------------------------------------------------------------
--
--  Logical unit: IamLoginEventDetail
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Insert_Login_Event_Detail (
   event_id_   VARCHAR2,
   parameter_  VARCHAR2,
   value_      VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     IAM_LOGIN_EVENT_DETAIL_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   objrec_.event_id := event_id_;
   objrec_.parameter := parameter_;
   objrec_.value := value_;
   Insert___ (objid_, objversion_, objrec_, attr_);
END Insert_Login_Event_Detail;