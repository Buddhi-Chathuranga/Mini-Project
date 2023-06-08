-----------------------------------------------------------------------------
--
--  Logical unit: ConcatenatedStateInfo
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020123  KAGALK  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Exist___ (
   state_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   concatenated_state_info
      WHERE  state = state_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Exist___;
             
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Display_State (
   country_code_ IN VARCHAR2,
   state_code_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN SUBSTR(country_code_ || ' ' || state_code_, 1, 20);
END Display_State;


@UncheckedAccess
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   state_       IN  VARCHAR2 )
IS
   temp_ concatenated_state_info.state_name%TYPE;
   CURSOR get_attr IS
      SELECT state_name
      FROM   concatenated_state_info
      WHERE  state = state_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   description_:= temp_;
END Get_Control_Type_Value_Desc;


@UncheckedAccess
PROCEDURE Exist (
   state_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(state_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist;



