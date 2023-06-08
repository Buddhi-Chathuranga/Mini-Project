-----------------------------------------------------------------------------
--
--  Logical unit: AlternateUnitOfMeasure
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200218  NWeelk  GESPRING20-3706, Added Check_Mx_Alt_Uom_Exists and Get_Mx_Alt_Uom.
--  191129  HIRALK  GESPRING20-1553, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Check_Alt_Uom_Exists (
   unit_code_ VARCHAR2) RETURN VARCHAR2
IS
   dummy_   NUMBER;
   CURSOR find_rows IS
      SELECT 1
      FROM  alternate_unit_of_measure_tab
      WHERE unit_code = unit_code_;
BEGIN
   OPEN find_rows;
   FETCH find_rows INTO dummy_;
   IF(find_rows%FOUND) THEN
      CLOSE find_rows;
      RETURN 'TRUE';
   END IF;
   CLOSE find_rows;
   RETURN 'FALSE';
END Check_Alt_Uom_Exists;

-- gelr:mx_xml_doc_reporting, begin
FUNCTION Check_Mx_Alt_Uom_Exists (
   unit_code_ VARCHAR2) RETURN BOOLEAN
IS
   dummy_   NUMBER;
   CURSOR find_rows IS
      SELECT 1
      FROM  alternate_unit_of_measure_tab
      WHERE unit_code = unit_code_
      AND   uom_classification LIKE 'MX%';
BEGIN
   OPEN find_rows;
   FETCH find_rows INTO dummy_;
   IF(find_rows%FOUND) THEN
      CLOSE find_rows;
      RETURN TRUE;
   END IF;
   CLOSE find_rows;
   RETURN FALSE;
END Check_Mx_Alt_Uom_Exists;

FUNCTION Get_Mx_Alt_Uom (
   unit_code_ VARCHAR2) RETURN VARCHAR2 
IS
   alt_uom_code_  VARCHAR2(30);
   CURSOR find_rows IS
      SELECT alt_uom_code
      FROM  alternate_unit_of_measure_tab
      WHERE unit_code = unit_code_
      AND   uom_classification LIKE 'MX%';
BEGIN
   OPEN find_rows;
   FETCH find_rows INTO alt_uom_code_;
   CLOSE find_rows;   
   RETURN alt_uom_code_;
END Get_Mx_Alt_Uom;
-- gelr:mx_xml_doc_reporting, end


