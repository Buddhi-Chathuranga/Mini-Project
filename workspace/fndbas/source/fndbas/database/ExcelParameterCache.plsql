-----------------------------------------------------------------------------
--
--  Logical unit: ExcelParameterCache
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
PROCEDURE Add_Parameters (
   id_         IN VARCHAR2,
   parameters_ IN CLOB )
IS
BEGIN
   INSERT
      INTO EXCEL_PARAMETER_CACHE_TAB (
         id,
         parameters,
         rowversion)
      VALUES (
         id_,
         parameters_,
         SYSDATE);
END Add_Parameters;

FUNCTION Get_Parameters (
   id_    IN VARCHAR2 ) RETURN CLOB
IS
   temp_ EXCEL_PARAMETER_CACHE_TAB.Parameters%TYPE;
   CURSOR get_attr IS
      SELECT Parameters
      FROM EXCEL_PARAMETER_CACHE_TAB
      WHERE id = id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Parameters;

PROCEDURE Remove_Parameters (
   id_    IN VARCHAR2 )
IS
BEGIN
   DELETE FROM EXCEL_PARAMETER_CACHE_TAB
      WHERE id = id_;
END Remove_Parameters;

-- Clear entries older than one hour
PROCEDURE Clear_Obsolete_Entries
IS
BEGIN
   DELETE FROM EXCEL_PARAMETER_CACHE_TAB
      WHERE rowversion < (SYSDATE - 1/24);
END Clear_Obsolete_Entries;

