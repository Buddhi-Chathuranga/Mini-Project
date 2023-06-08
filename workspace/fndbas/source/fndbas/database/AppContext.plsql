-----------------------------------------------------------------------------
--
--  Logical unit: AppContext
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE context_arr IS TABLE OF VARCHAR2(32767) INDEX BY VARCHAR2(1000);
@ApproveGlobalVariable(2014-06-30,haarse)
context_       context_arr;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Clear_Context___ 
IS
BEGIN
   context_.delete;
END Clear_Context___;


FUNCTION Get_Value___ (
   name_ IN VARCHAR2,
   raise_error_ IN BOOLEAN DEFAULT TRUE,
   default_value_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN(context_(name_));
EXCEPTION
   WHEN no_data_found THEN 
      IF raise_error_ THEN 
         Error_SYS.Appl_General(service_, 'CONTEXT_NOT_EXISTS: Context [:P1] is not set.', name_);
      ELSE
         RETURN(default_value_);
      END IF;
END Get_Value___;


PROCEDURE Set_Value___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 ) 
IS
BEGIN
   context_(name_) := value_;
END Set_Value___;


PROCEDURE Set_Values___ (
   msg_ IN VARCHAR2 ) 
IS
   name_    Message_SYS.name_table;
   value_   Message_SYS.line_table;
   count_   INTEGER;

BEGIN
   -- Clear context
   Clear_Context___;
   IF (msg_ IS NOT NULL) THEN
      -- Get all values from context
      Message_SYS.Get_Attributes (msg_, count_, name_, value_);
      FOR i IN 1..count_ LOOP
         Set_Value___(name_(i), value_(i));
      END LOOP;
   END IF;
END Set_Values___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Value (
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Get_Value___(name_, TRUE));
END Get_Value;


@UncheckedAccess
FUNCTION Get_Date_Value (
   name_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN(To_Date(Get_Value___(name_, TRUE), Client_SYS.date_format_));
END Get_Date_Value;


@UncheckedAccess
FUNCTION Get_Number_Value (
   name_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN(To_Number(Get_Value___(name_, TRUE)));
END Get_Number_Value;


@UncheckedAccess
FUNCTION Get_Boolean_Value (
   name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF (Get_Value___(name_, TRUE) = Fnd_Boolean_API.DB_TRUE) THEN 
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Get_Boolean_Value;


@UncheckedAccess
FUNCTION Find_Value (
   name_ IN VARCHAR2,
   default_value_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Get_Value___(name_, FALSE, default_value_));
END Find_Value;


@UncheckedAccess
FUNCTION Find_Date_Value (
   name_ IN VARCHAR2,
   default_value_ IN DATE DEFAULT NULL ) RETURN DATE
IS
BEGIN
   RETURN(To_Date(Get_Value___(name_, FALSE, TO_CHAR(default_value_,Client_SYS.date_format_)), Client_SYS.date_format_));
END Find_Date_Value;


@UncheckedAccess
FUNCTION Find_Number_Value (
   name_ IN VARCHAR2,
   default_value_ IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
BEGIN
   RETURN(To_Number(Get_Value___(name_, FALSE, default_value_)));
END Find_Number_Value;


@UncheckedAccess
FUNCTION Find_Boolean_Value (
   name_ IN VARCHAR2,
   default_value_ IN BOOLEAN DEFAULT TRUE ) RETURN BOOLEAN
IS
   new_default_value_ VARCHAR2(10);
BEGIN
   IF (default_value_ = TRUE) THEN 
      new_default_value_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      new_default_value_ := Fnd_Boolean_API.DB_FALSE;
   END IF;      
   IF (Get_Value___(name_, FALSE, new_default_value_) = Fnd_Boolean_API.DB_TRUE) THEN 
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Find_Boolean_Value;


@UncheckedAccess
FUNCTION Exists (
   name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF (Get_Value___(name_, FALSE) IS NOT NULL) THEN 
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RETURN(FALSE);
END Exists;


@UncheckedAccess
PROCEDURE Set_Value (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Set_Value___(name_, value_);
END Set_Value;


@UncheckedAccess
PROCEDURE Set_Value (
   name_ IN VARCHAR2,
   value_ IN DATE )
IS
BEGIN
   Set_Value___(name_, to_char(value_, Client_SYS.date_format_));
END Set_Value;


@UncheckedAccess
PROCEDURE Set_Value (
   name_ IN VARCHAR2,
   value_ IN NUMBER )
IS
BEGIN
   Set_Value___(name_, to_number(value_));
END Set_Value;


@UncheckedAccess
PROCEDURE Set_Value (
   name_ IN VARCHAR2,
   value_ IN BOOLEAN )
IS
BEGIN
   IF (value_ = TRUE) THEN
      Set_Value___(name_, Fnd_Boolean_API.DB_TRUE);
   ELSE
      Set_Value___(name_, Fnd_Boolean_API.DB_FALSE);
   END IF;
END Set_Value;


@UncheckedAccess
PROCEDURE Set_Values (
   msg_ IN VARCHAR2 )
IS
BEGIN
   Set_Values___(msg_);
END Set_Values;



