-----------------------------------------------------------------------------
--
--  Logical unit: ForwarderInfoOurId
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990125  Camk    Created.
--  091203  Kanslk  Reverse-Engineering, changed company to a parent key
--  140703  Hawalk  Bug 116673 (merged via PRFI-287), User-company authorization added inside Check_Common___().
--  171018  MaRalk  STRSC-11324, Override Check_Delete___ in order to restrict the delete
--  171018          when the record is referred in shipments.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     forwarder_info_our_id_tab%ROWTYPE,
   newrec_ IN OUT forwarder_info_our_id_tab%ROWTYPE,
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


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN forwarder_info_our_id_tab%ROWTYPE )
IS
BEGIN
  super(remrec_);
  -- Check Shipments exist for the given record
  $IF Component_Shpmnt_SYS.INSTALLED $THEN
     Shipment_API.Check_Exist_By_Fwdr_Info_Ourid(remrec_.company, remrec_.forwarder_id, remrec_.our_id); 
  $END
END Check_Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

