-----------------------------------------------------------------------------
--
--  Logical unit: ClientProfileValue ReplReceive
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


-------------------- REPLICATION RECEIVE IMPLEMENTATION METHODS ---------------------
@Overtake Core

PROCEDURE Check_Common___ (
   oldrec_ IN     fndrr_client_profile_value_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY fndrr_client_profile_value_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
$SEARCH
   Client_Profile_API.Exist(newrec_.profile_id);
$REPLACE
   NULL;
$END
END Check_Common___;
-------------------- REPLICATION RECEIVE PRIVATE METHODS ----------------------------


-------------------- REPLICATION RECEIVE PROTECTED METHODS --------------------------


-------------------- REPLICATION RECEIVE PUBLIC METHODS -----------------------------

