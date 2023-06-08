-----------------------------------------------------------------------------
--
--  Logical unit: CompositePageElement
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
PROCEDURE Delete___ (
   objid_  IN     VARCHAR2,
   remrec_ IN     composite_page_element_tab%ROWTYPE )
IS
BEGIN
   --Add pre-processing code here
   super(objid_, remrec_);
   Pres_Object_Util_API.Remove_Pres_Object('hudElement'||remrec_.id);
   Pres_Object_Util_API.Remove_Pres_Object('lobbyElement'||remrec_.id);
   --Add post-processing code here
END Delete___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


