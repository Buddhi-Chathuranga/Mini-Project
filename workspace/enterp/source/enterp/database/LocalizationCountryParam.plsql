-----------------------------------------------------------------------------
--
--  Logical unit: LocalizationCountryParam
--  Component:    ENTERP
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

-- gelr: localization_control_center, begin
PROCEDURE Insert_Lu_Data_Rec__ (
   localization_ IN VARCHAR2,
   parameter_    IN VARCHAR2,
   mandatory_    IN VARCHAR2 )
IS
   newrec_     localization_country_param_tab%ROWTYPE;
BEGIN   
   IF (NOT Check_Exist___(localization_, parameter_)) THEN
      newrec_.localization := localization_;
      newrec_.parameter := parameter_;
      newrec_.mandatory := mandatory_;
      newrec_.rowversion := SYSDATE;
      New___(newrec_);
   ELSE
      newrec_ := Get_Object_By_Keys___(localization_, parameter_);
      newrec_.mandatory := mandatory_;
      newrec_.rowversion := SYSDATE;
      Modify___(newrec_);
   END IF;
END Insert_Lu_Data_Rec__;
-- gelr: localization_control_center, end

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

