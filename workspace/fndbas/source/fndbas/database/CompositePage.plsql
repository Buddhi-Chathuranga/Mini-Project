-----------------------------------------------------------------------------
--
--  Logical unit: CompositePage
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
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     composite_page_tab%ROWTYPE,
   newrec_     IN OUT composite_page_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   --Add pre-processing code here
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   --Add post-processing code here
END Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN     VARCHAR2,
   remrec_ IN     composite_page_tab%ROWTYPE )
IS
BEGIN
   --Add pre-processing code here
   super(objid_, remrec_);
   Pres_Object_Util_API.Remove_Pres_Object('hudPage'||remrec_.id);
   Pres_Object_Util_API.Remove_Pres_Object('lobbyPage'||remrec_.id);
   --Add post-processing code here
END Delete___;











-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
-- Is_Available__
--    Return 'TRUE' if the Presentation Object for this page is granted to
--    the current user. 'Else it returns FALSE'. This method is intended to be
--    used in the view for this LU and is custom made for this purpose.
--    Note that the parameter is the po_id, not the page_id.
--    If the presentation object does not exist, 'TRUE' will be returned.
@UncheckedAccess
FUNCTION Is_Available__ (
   po_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User) THEN
      RETURN 'TRUE';
   ELSIF Security_SYS.Is_Pres_Object_Available(po_id_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Available__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

