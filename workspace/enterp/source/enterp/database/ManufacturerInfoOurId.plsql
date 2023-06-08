-----------------------------------------------------------------------------
--
--  Logical unit: ManufacturerInfoOurId
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990125  Camk    Created.
--  990420  Camk    New template
--  091203  Kanslk  Reverse-Engineering, changed the company to a parent key
--  140703  Hawalk  Bug 116673 (merged via PRFI-287), User-company authorization added inside Check_Common___().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     manufacturer_info_our_id_tab%ROWTYPE,
   newrec_ IN OUT manufacturer_info_our_id_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   -- Note: Validate that the user is one within the company.
   -- Note: No need for ELSE as application doesn't run without ACCRUL - only installation issue addressed here!
   $IF Component_Accrul_SYS.INSTALLED $THEN
      User_Finance_API.Exist_Current_User(newrec_.company);
   $END
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


