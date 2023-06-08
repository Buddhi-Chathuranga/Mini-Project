-----------------------------------------------------------------------------
--
--  Logical unit: LocalizationParameter
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191003    Nuudlk   gelr: Added to support Global Extension Functionalities 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- gelr:localization_control_center, begin
PROCEDURE Insert_Lu_Data_Rec__ (
   parameter_             IN VARCHAR2,
   parameter_no_          IN NUMBER,
   parameter_description_ IN VARCHAR2,
   parameter_text_        IN VARCHAR2 )
IS
   dummy_      NUMBER;
   CURSOR exist IS
      SELECT 1
      FROM   localization_parameter_tab
      WHERE  parameter = parameter_;
BEGIN
   OPEN exist;
   FETCH exist INTO dummy_;
   IF (exist%NOTFOUND) THEN
      INSERT
         INTO localization_parameter_tab(
            parameter,
            parameter_no,
            parameter_description,
            parameter_text,
            rowversion)
         VALUES(
            parameter_,
            parameter_no_,
            parameter_description_,
            parameter_text_,
            SYSDATE);
      Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP',
                                                         lu_name_,
                                                         parameter_||'^'||'PARAMETER_DESCRIPTION',
                                                         parameter_description_);
      Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP',
                                                         lu_name_,
                                                         parameter_||'^'||'PARAMETER_TEXT',
                                                         parameter_text_);
   ELSE
      Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP',
                                                         lu_name_,
                                                         parameter_||'^'||'PARAMETER_DESCRIPTION',
                                                         parameter_description_);
      Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP',
                                                         lu_name_,
                                                         parameter_||'^'||'PARAMETER_TEXT',
                                                         parameter_text_);
      UPDATE localization_parameter_tab SET
         parameter_no            = parameter_no_,
         parameter_description   = parameter_description_,
         parameter_text          = parameter_text_,
         rowversion              = SYSDATE
      WHERE parameter = parameter_;
   END IF;
   CLOSE exist;
END Insert_Lu_Data_Rec__;
-- gelr:localization_control_center, end

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- gelr:localization_control_center, begin
PROCEDURE Remove_Loc_Parameter (
   parameter_        IN VARCHAR2 )
IS
   remrec_ localization_parameter_tab%ROWTYPE;
BEGIN
   IF (Localization_Parameter_API.Exists(parameter_)) THEN
      remrec_.parameter := parameter_;
      Remove___(remrec_,TRUE);
   END IF;
END Remove_Loc_Parameter;
-- gelr:localization_control_center, end