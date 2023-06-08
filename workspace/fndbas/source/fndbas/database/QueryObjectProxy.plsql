-----------------------------------------------------------------------------
--
--  Logical unit: QueryObjectProxy
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
@IgnoreUnitTest TrivialFunction
FUNCTION Server_Entityset_Metadata(
   params_ IN VARCHAR2 DEFAULT NULL )  RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Query_Object_Metadata_SYS.Server_Entitysets(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Server_Entityset_Metadata;

@IgnoreUnitTest TrivialFunction
FUNCTION Server_Entity_Type_Metadata(
   params_ IN VARCHAR2 DEFAULT NULL) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Query_Object_Metadata_SYS.Server_Entity_Types(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Server_Entity_Type_Metadata;

@IgnoreUnitTest TrivialFunction
FUNCTION Client_Entityset_Metadata(
   params_ IN VARCHAR2 DEFAULT NULL )  RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Query_Object_Metadata_SYS.Client_Entitysets(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Client_Entityset_Metadata;

@IgnoreUnitTest TrivialFunction
FUNCTION Client_Entity_Type_Metadata(
   params_ IN VARCHAR2 DEFAULT NULL) RETURN CLOB
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Query_Object_Metadata_SYS.Client_Entity_Types(params_);
   $ELSE   
      RETURN empty_clob();
   $END
END Client_Entity_Type_Metadata;

-------------------- LU  NEW METHODS -------------------------------------
