-----------------------------------------------------------------------------
--
--  Logical unit: FndBoolean
--  Component:    FNDBAS
--
--  Template:     3.0
--  Built by:     IFS Developer Studio 8.72.65.2062
--
--  NOTE! Do not edit!! This file is completely generated and will be
--        overwritten next time the corresponding model is saved.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DOMAIN CONSTANTS --------------------------------

-------------------- PUBLIC DOMAIN METHODS ----------------------------------

@UncheckedAccess
FUNCTION Evaluate (
   client_value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Fnd_Boolean_API.DB_TRUE = Encode(client_value_));
END Evaluate;


@UncheckedAccess
FUNCTION Evaluate_Db (
   db_value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Fnd_Boolean_API.DB_TRUE = db_value_);
END Evaluate_Db;

@UncheckedAccess
FUNCTION Is_True (
   client_value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Fnd_Boolean_API.DB_TRUE = Encode(client_value_));
END Is_True;


@UncheckedAccess
FUNCTION Is_True_Db (
   db_value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Fnd_Boolean_API.DB_TRUE = db_value_);
END Is_True_Db;


-------------------- IMPLEMENTATION DOMAIN METHODS --------------------------

-------------------- FOUNDATION1 METHODS ------------------------------------

