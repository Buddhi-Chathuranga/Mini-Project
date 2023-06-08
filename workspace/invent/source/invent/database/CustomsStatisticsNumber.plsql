-----------------------------------------------------------------------------
--
--  Logical unit: CustomsStatisticsNumber
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190905  SBalLK  Bug 149829 (SCZ-6578), Removed existing overridden Get_Description() method and added new Get_Description() method to get description according to the requested language.
--  140409  JeLise  Corrected error message UPD_CONV_FACTOR.
--  121016  PraWlk  Bug 105887, Modified Get_Description() by removing the length restriction of customs stat no description.
--  120629  ChFolk  Modified View to increased the length of customs_stat_no to VARCHAR2(15).
--  090212  MalLlk  Bug 80014, Added parameter language_code_ to Get_Description. Modified
--  090212          methods Get_Description, Delete___, Update___, Insert___ and view column
--  090212          description to get the translated customs statistics number description.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060117  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  040924  ChJalk  Bug 46743,Modified the length of column 'description' in the VIEW CUSTOMS_STATISTICS_NUMBER. 
--  000925  JOHESE  Added undefines.
--  990420  ANHO  General performance improvements.
--  990409  ANHO  Upgraded to performance optimized template.
--  981015  JOED  Added Get_Customs_Unit_Meas.
--  981013  JOED  Added reference on unit measure.
--                Upgrade to Design 2.2.
--  971127  GOPE  Upgrade to fnd 2.0
--  970908  NABE  Changed Customs_unit_of_measure Uppercase to Mixed case in column comments.
--  970312  CHAN  Changed table name: inv_customs_statistics_tab is replaced by
--                customs_statistics_number_tab
--  970219  JOKE  Uses column rowversion as objversion (timestamp).
--  961213  LEPE  Modified for new template standard.
--  961104  MAOR  Changed file to new template.
--  961031  MAOR  Modified file to Rational Rose Model-standard.
--  960916  JICE  Added function Get_Description, changed view to include
--                description and unit in LOV.
--  960705  AnAr  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customs_statistics_number_tab%ROWTYPE,
   newrec_ IN OUT customs_statistics_number_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF(indrec_.customs_unit_meas = TRUE) THEN 
      Client_SYS.Add_Info(lu_name_, 'UPD_CONV_FACTOR: The intrastat conversion factor - for inventory parts using this statistics number (:P1) - might need to be changed.', newrec_.customs_stat_no);
   END IF;   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION Get_Description (
   customs_stat_no_ IN VARCHAR2,
   language_code_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_ VARCHAR2(2000) := NULL;

   CURSOR get_description IS
      SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('INVENT', 'CustomsStatisticsNumber', customs_stat_no, language_code_), description), 1, 2000)
      FROM   customs_statistics_number_tab
      WHERE  customs_stat_no = customs_stat_no_;
BEGIN
   OPEN get_description;
   FETCH get_description INTO description_;
   CLOSE get_description;
   RETURN description_;
END Get_Description;



