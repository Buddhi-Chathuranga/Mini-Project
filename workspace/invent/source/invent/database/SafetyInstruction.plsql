-----------------------------------------------------------------------------
--
--  Logical unit: SafetyInstruction
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120504  Matkse   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120504           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120504           was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  060119  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060119           and added UNDEFINE according to the new template.
--  --------------------------------- 13.3.0 --------------------------------
--  000925  JOHESE   Added undefines.
--  000303  NISOSE   Changed the status bar text for the safety code datafield
--  990421  JOHW     General performance improvements.
--  990409  JOHW     Upgraded to performance optimized template.
--  980526  JOHW     Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  980324  ANHO     SID 907. Changed promptnames on viewcolumns.
--  971202  GOPE     Upgrade to fnd 2.0
--  970312  MAGN     Changed tablename from hazard_codes to safety_instruction_tab.
--  970220  JOKE     Uses column rowversion as objversion (timestamp).
--  961213  LEPE     Modified for new template standard.
--  961030  JICE     Modified for Rational Rose/Workbench.
--  960425  MPC5     Spec 96-0002 LONG-fields is replaced by VARCHAR2(2000).
--  960307  JICE     Renamed from InvHazardCodes
--  951012  SHR      Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   hazard_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ safety_instruction_tab.description%TYPE;
BEGIN
   IF (hazard_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      hazard_code_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  safety_instruction_tab
      WHERE hazard_code = hazard_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(hazard_code_, 'Get_Description');
END Get_Description;



