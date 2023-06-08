-----------------------------------------------------------------------------
--
--  Logical unit: FndcgProjectionSvcUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Text_Arr        IS TABLE OF VARCHAR2(4000);

TYPE Boolean_Arr     IS TABLE OF BOOLEAN;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION To_Ret (
   rec_ IN BOOLEAN ) RETURN VARCHAR2
IS
BEGIN
   RETURN (CASE rec_ WHEN TRUE THEN 'TRUE' WHEN FALSE THEN 'FALSE' ELSE NULL END);
END To_Ret;
 
FUNCTION To_Boolean (
   rec_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN (CASE rec_ WHEN 'TRUE' THEN TRUE WHEN 'FALSE' THEN FALSE ELSE NULL END);
END To_Boolean;


FUNCTION To_Boolean_Arr (
   arr_ IN Text_Arr ) RETURN Boolean_Arr
IS
   ret_ Boolean_Arr := Boolean_Arr();
BEGIN
   IF (arr_.count > 0) THEN
      FOR i IN arr_.first .. arr_.last LOOP
      ret_.extend;
      ret_(ret_.last) := To_Boolean(arr_(i));
      END LOOP;
   END IF;
   RETURN ret_;
END To_Boolean_Arr;

-------------------- LU  NEW METHODS -------------------------------------
