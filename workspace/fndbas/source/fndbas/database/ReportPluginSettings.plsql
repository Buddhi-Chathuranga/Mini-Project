-----------------------------------------------------------------------------
--
--  Logical unit: ReportPluginSettings
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
PROCEDURE Modify_Parameter (
   parameter_   IN VARCHAR2,
   description_ IN VARCHAR2,
   value_       IN VARCHAR2,
   value_type_  IN VARCHAR2 DEFAULT 'FIXED STRING' )
IS
   attr_       VARCHAR2(32767);
   oldrec_     report_plugin_settings_tab%ROWTYPE;
   newrec_     report_plugin_settings_tab%ROWTYPE;
   objid_      report_plugin_settings.objid%TYPE;
   objversion_ report_plugin_settings.objversion%TYPE;
   indrec_     Indicator_Rec;
   not_exist   EXCEPTION;
   PRAGMA      EXCEPTION_INIT(not_exist, -20111);
BEGIN
   Exist(parameter_);
   
   IF (description_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PARAMETER_DESC', description_, attr_);
   END IF;
   IF (value_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('VALUE', value_, attr_);
   END IF;
   IF (value_type_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('VALUE_TYPE', value_type_, attr_);
   END IF;
   
   oldrec_ := Lock_By_Keys___(parameter_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
EXCEPTION
   WHEN not_exist THEN
      NULL;
END Modify_Parameter;

PROCEDURE Modify_Value (
   parameter_   IN VARCHAR2,
   value_       IN VARCHAR2)
IS
   attr_       VARCHAR2(32767);
   oldrec_     report_plugin_settings_tab%ROWTYPE;
   newrec_     report_plugin_settings_tab%ROWTYPE;
   objid_      report_plugin_settings.objid%TYPE;
   objversion_ report_plugin_settings.objversion%TYPE;
   indrec_     Indicator_Rec;
   not_exist   EXCEPTION;
   PRAGMA      EXCEPTION_INIT(not_exist, -20111);
BEGIN
   Exist(parameter_);   
   Client_SYS.Add_To_Attr('VALUE', value_, attr_);
   oldrec_ := Lock_By_Keys___(parameter_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
EXCEPTION
   WHEN not_exist THEN
      NULL;
END Modify_Value;

PROCEDURE New_Parameter (
   parameter_   IN VARCHAR2,
   description_ IN VARCHAR2,
   value_       IN VARCHAR2,
   value_type_  IN VARCHAR2 DEFAULT 'FIXED STRING' )
IS
   attr_       VARCHAR2(32767);
   newrec_     report_plugin_settings_tab%ROWTYPE;
   objid_      report_plugin_settings.objid%TYPE;
   objversion_ report_plugin_settings.objversion%TYPE;
   indrec_     Indicator_Rec;
   duplicate      EXCEPTION;   
   PRAGMA         EXCEPTION_INIT(duplicate, -20112);
BEGIN
   Client_SYS.Add_To_Attr('PARAMETER_NAME', parameter_, attr_);
   Client_SYS.Add_To_Attr('PARAMETER_DESC', description_, attr_);
   Client_SYS.Add_To_Attr('VALUE', value_, attr_);
   Client_SYS.Add_To_Attr('VALUE_TYPE', value_type_, attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN duplicate THEN
      Modify_Parameter (parameter_,
                        description_,
                        value_,
                        value_type_);
END New_Parameter;

PROCEDURE Remove_Parameter (
   parameter_   IN VARCHAR2 )
IS
   remrec_     report_plugin_settings_tab%ROWTYPE;
BEGIN
   remrec_.parameter_name := parameter_;
   Remove___(remrec_);
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END Remove_Parameter;
