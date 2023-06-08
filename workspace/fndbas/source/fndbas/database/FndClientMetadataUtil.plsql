-----------------------------------------------------------------------------
--
--  Logical unit: FndClientMetadataUtil
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

FUNCTION Get_Metadata___ (
   pkg_name_   IN VARCHAR2,
   pkg_method_ IN VARCHAR2) RETURN CLOB
IS
   stmt_ VARCHAR2(200) := 'BEGIN :clob_:=' || pkg_name_ || '.' || pkg_method_ || '; END;';
   clob_ CLOB;
BEGIN
   Assert_SYS.Assert_Is_Package_Method(pkg_name_, pkg_method_);
   @ApproveDynamicStatement(2018-03-21,kratlk)
   EXECUTE IMMEDIATE stmt_ USING OUT clob_;
   RETURN clob_;
END Get_Metadata___;

FUNCTION Get_Metadata_Version___ (
   pkg_name_   IN VARCHAR2,
   pkg_method_ IN VARCHAR2) RETURN VARCHAR2
IS
   stmt_    VARCHAR2(200) := 'BEGIN :version_:=' || pkg_name_ || '.' || pkg_method_ || '; END;';
   version_ VARCHAR2(100);
BEGIN
   Assert_SYS.Assert_Is_Package_Method(pkg_name_, pkg_method_);
   @ApproveDynamicStatement(2018-03-21,kratlk)
   EXECUTE IMMEDIATE stmt_ USING OUT version_;
   RETURN version_;
END Get_Metadata_Version___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Client_Metadata (
   client_pkg_ IN VARCHAR2,
   pkg_method_ IN VARCHAR2) RETURN CLOB
IS
BEGIN
   RETURN Get_Metadata___(client_pkg_, pkg_method_);
END Get_Client_Metadata;

FUNCTION Get_Client_Metadata_Version (
   client_pkg_ IN VARCHAR2,
   pkg_method_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Metadata_Version___(client_pkg_, pkg_method_);
END Get_Client_Metadata_Version;

-------------------- LU  NEW METHODS -------------------------------------
