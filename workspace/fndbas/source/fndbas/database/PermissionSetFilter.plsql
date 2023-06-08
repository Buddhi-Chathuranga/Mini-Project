-----------------------------------------------------------------------------
--
--  Logical unit: PermissionSetFilter
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

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PERMISSION_SET_FILTER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.created_by   := Fnd_Session_API.Get_Fnd_User;
   newrec_.created_date := sysdate;
   IF newrec_.filter_id IS NULL THEN
     newrec_.filter_id := sys_guid;
   END IF;
   Client_SYS.Add_To_Attr('FILTER_ID', newrec_.filter_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___; 


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


