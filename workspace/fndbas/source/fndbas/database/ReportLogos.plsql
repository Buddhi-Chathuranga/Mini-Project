-----------------------------------------------------------------------------
--
--  Logical unit: ReportLogos
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191127  subblk  TSMI-68, Added overwrite methods.
--  191105  CHAALK  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE Import_Image_File (
   image_name_        IN  VARCHAR2,
   image_             IN  BLOB,
   prevent_overwrite_ IN  VARCHAR2,
   ret_value_         OUT VARCHAR2) 
IS
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   objid_          VARCHAR2(100);
   objversion_     VARCHAR2(100);
   
BEGIN
   
   IF (NOT Report_Logos_API.Exists(image_name_)) THEN
      New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('IMAGE_NAME',image_name_,attr_);
      Client_SYS.Add_To_Attr('PREVENT_OVERWRITE',prevent_overwrite_,attr_);
      New__(info_, objid_, objversion_,attr_, 'DO');
      Write_Image__(objversion_, objid_, image_);      
      ret_value_ := 'IMPORT';
   ELSE
      IF (UPPER(Get_Prevent_Overwrite(image_name_)) = 'FALSE') THEN
         Get_Id_Version_By_Keys___ (objid_,objversion_,image_name_);
         Client_SYS.Add_To_Attr('PREVENT_OVERWRITE',prevent_overwrite_,attr_);
         Modify__(info_, objid_, objversion_,attr_, 'DO');
         Write_Image__(objversion_, objid_, image_);               
         ret_value_ := 'MODIFY';
      ELSE
         ret_value_ := 'LOCKED';
      END IF;
   END IF;
   
END Import_Image_File;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Prevent_Overwrite (
   image_name_ IN VARCHAR2,
   overwrite_  IN VARCHAR2)
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   info_             VARCHAR2(2000);
   attr_             VARCHAR2(4000);
BEGIN
	Get_Id_Version_By_Keys___(objid_, objversion_, image_name_);
   Client_SYS.Add_To_Attr('PREVENT_OVERWRITE', overwrite_, attr_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Prevent_Overwrite;


PROCEDURE Enable_Overwrite (
   image_name_ IN VARCHAR2,
   overwrite_  IN VARCHAR2)
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   info_             VARCHAR2(2000);
   attr_             VARCHAR2(4000);
BEGIN
	Get_Id_Version_By_Keys___(objid_, objversion_, image_name_);
   Client_SYS.Add_To_Attr('PREVENT_OVERWRITE', overwrite_, attr_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Enable_Overwrite;


PROCEDURE Overwrite (
   image_name_ IN VARCHAR2,
   image_      IN BLOB)
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
BEGIN
	Get_Id_Version_By_Keys___(objid_, objversion_, image_name_);
   Write_Image__(objversion_, objid_, image_);
END Overwrite;


PROCEDURE Delete_Logo (
   image_name_ IN VARCHAR2)
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   info_             VARCHAR2(2000);
BEGIN
	Get_Id_Version_By_Keys___(objid_, objversion_, image_name_);
   Remove__(info_, objid_, objversion_, 'DO');
END Delete_Logo;