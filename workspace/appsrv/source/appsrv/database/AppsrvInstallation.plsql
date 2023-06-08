-----------------------------------------------------------------------------
--
--  Logical unit: AppsrvInstallation
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

   mst_role_ CONSTANT VARCHAR2(30) := 'FND_CONNECT';
   role_     CONSTANT VARCHAR2(30) := 'FND_CONNECT_APPSRV';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Post_Installation_Object
IS
BEGIN
   IF (Fnd_Role_Api.Get(role_).fnd_role_type IS NULL) THEN
      Security_SYS.Create_Role(role_, 'Role needed for IFS Connect framework user', 'BUILDROLE','TRUE');
   ELSE
      Security_SYS.Clear_Role(role_, FALSE);
   END IF;
END Post_Installation_Object;

@UncheckedAccess
PROCEDURE Post_Installation_Data
IS
BEGIN
   -- Do not grant to FNDBAS roles directly, use local component role
   IF Database_SYS.Component_Active('APPSRV') THEN
      Fnd_Projection_Grant_API.Grant_All('MediaLibraryRepositoryTransferService', role_, 'FALSE');
   END IF;
   Security_SYS.Grant_Role(role_, mst_role_);
END Post_Installation_Data;
-------------------- LU  NEW METHODS -------------------------------------
