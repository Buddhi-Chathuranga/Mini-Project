-----------------------------------------------------------------------------
--
--  Logical unit: QuickReportType
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  191024  Ratslk  TSMI-12: Quick Report Type functions. Get Index Of XmlValue, Get Xml Value
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
FUNCTION Get_Index_Of_Xml_Value (
   xml_value_ VARCHAR2) RETURN VARCHAR2
IS
BEGIN
	CASE xml_value_ 
   WHEN 'SQL_STATEMENT'    THEN RETURN 0; 
   WHEN 'CRYSTAL_REPORTS'  THEN RETURN 1; 
   WHEN 'MS_REPORT'        THEN RETURN 2;
   WHEN 'DASHBOARD'        THEN RETURN 3; 
   WHEN 'WEB_REPORT'       THEN RETURN 4;
   WHEN 'QUERY'            THEN RETURN 5;
   END CASE;
END Get_Index_Of_Xml_Value;

FUNCTION Get_Xml_Value (
   client_value_ VARCHAR2) RETURN VARCHAR2
IS
BEGIN
	RETURN REGEXP_REPLACE(UPPER(client_value_), '\s', '_');
END Get_Xml_Value;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU  NEW METHODS -------------------------------------
