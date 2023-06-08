-----------------------------------------------------------------------------
--
--  Logical unit: IamLoginEvent
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

PROCEDURE Insert_Login_Event (
   event_id_   VARCHAR2,
   event_time_ DATE,
   event_type_ VARCHAR2,
   realm_id_   VARCHAR2,
   client_id_  VARCHAR2,
   user_name_  VARCHAR2,
   session_id_ VARCHAR2,
   error_      VARCHAR2,
   ip_address_ VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     IAM_LOGIN_EVENT_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   objrec_.event_id := event_id_;
   objrec_.event_time := event_time_;
   objrec_.event_type := event_type_;
   objrec_.realm_id := realm_id_;
   objrec_.client_id := client_id_;
   objrec_.user_name := user_name_;
   objrec_.session_id := session_id_;
   objrec_.error := error_;
   objrec_.ip_address := ip_address_;
   Insert___ (objid_, objversion_, objrec_, attr_);
END Insert_Login_Event;