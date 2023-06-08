-----------------------------------------------------------------------------
--
--  Logical unit: ReportFontConfigXml
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200218  CHAALK  Modifications to remove sta jar useage 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Clear_All__
IS
BEGIN
   DELETE
      FROM  REPORT_FONT_CONFIG_XML_TAB;
END Clear_All__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Import_XML_File (
   file_name_         IN  VARCHAR2,
   xml_               IN  BLOB,
   ret_value_         OUT VARCHAR2) 
IS
   info_             VARCHAR2(2000);
   attr_             VARCHAR2(32000);
   objid_            VARCHAR2(100);
   objversion_       VARCHAR2(100);
   
BEGIN
   
   IF (NOT Report_Font_Config_Xml_API.Exists(file_name_)) THEN
      New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('FILE_NAME',file_name_,attr_);
      New__(info_, objid_, objversion_,attr_, 'DO');
      Write_Data__(objversion_, objid_, xml_);
      ret_value_ := 'IMPORT';
   ELSE
      Get_Id_Version_By_Keys___ (objid_,objversion_,file_name_);
      Modify__(info_, objid_, objversion_,attr_, 'DO');
      Write_Data__(objversion_, objid_, xml_);
      ret_value_ := 'MODIFY';
   END IF;
   
END Import_XML_File;
