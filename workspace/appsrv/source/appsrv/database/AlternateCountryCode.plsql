-----------------------------------------------------------------------------
--
--  Logical unit: AlternateCountryCode
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191107  fiallk  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------



-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Check_Alt_Country_Codes_Exists (
   country_code_ VARCHAR2) RETURN VARCHAR2
IS
   dummy_   NUMBER;
   CURSOR find_rows IS
      SELECT 1
      FROM  alternate_country_code_tab
      WHERE country_code = country_code_;
BEGIN
   OPEN find_rows;
   FETCH find_rows INTO dummy_;
   IF(find_rows%FOUND) THEN
      CLOSE find_rows;
      RETURN 'TRUE';
   END IF;
   CLOSE find_rows;
   RETURN 'FALSE';
END Check_Alt_Country_Codes_Exists;
