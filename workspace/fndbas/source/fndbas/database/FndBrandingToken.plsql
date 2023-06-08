-----------------------------------------------------------------------------
--
--  Logical unit: FndBrandingToken
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

PROCEDURE New_Property (
   property_      IN VARCHAR2,
   description_   IN VARCHAR2,
   type_          IN VARCHAR2,
   platform_      IN VARCHAR2 DEFAULT 'WEB',
   css_property_  IN VARCHAR2,
   css_override_  IN VARCHAR2 DEFAULT 'NONE')
IS
   indrec_        Indicator_Rec;
   newrec_        FND_BRANDING_TOKEN_TAB%ROWTYPE;
   attr_          VARCHAR2(32000);
   objid_         FND_BRANDING_TOKEN.objid%TYPE;
   objversion_    FND_BRANDING_TOKEN.objversion%TYPE;

   duplicate      EXCEPTION;   
   PRAGMA         EXCEPTION_INIT(duplicate, -20112);
BEGIN
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PROPERTY', property_, attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
   Client_SYS.Add_To_Attr('TYPE', type_, attr_);
   Client_SYS.Add_To_Attr('PLATFORM', platform_, attr_);
   Client_SYS.Add_To_Attr('CSS_PROPERTY', css_property_, attr_);
   Client_SYS.Add_To_Attr('CSS_OVERRIDE', css_override_, attr_);
    
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN duplicate THEN
      Modify_Property  (property_,
                        description_,
                        type_,
                        platform_,
                        css_property_,
                        css_override_);
END New_Property;


PROCEDURE Modify_Property (
   property_      IN VARCHAR2,
   description_   IN VARCHAR2,
   type_          IN VARCHAR2,
   platform_      IN VARCHAR2 DEFAULT 'WEB',
   css_property_  IN VARCHAR2,
   css_override_  IN VARCHAR2 DEFAULT 'NONE')
IS
   attr_       VARCHAR2(32000);
   indrec_     Indicator_Rec;
   oldrec_     FND_BRANDING_TOKEN_TAB%ROWTYPE;
   newrec_     FND_BRANDING_TOKEN_TAB%ROWTYPE;
   objid_      FND_BRANDING_TOKEN.objid%TYPE;
   objversion_ FND_BRANDING_TOKEN.objversion%TYPE;
   
   not_exist   EXCEPTION;
   PRAGMA      EXCEPTION_INIT(not_exist, -20111);
BEGIN
   Exist(property_);
   IF (description_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
   END IF;
   IF (type_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('TYPE', type_, attr_);
   END IF;
   IF (platform_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PLATFORM', platform_, attr_);
   END IF;
   IF (css_property_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CSS_PROPERTY', css_property_, attr_);
   END IF;
   IF (css_override_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CSS_OVERRIDE', css_override_, attr_);
   END IF;

   oldrec_ := Lock_By_Keys___(property_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); 

EXCEPTION
   WHEN not_exist THEN
      NULL;
END Modify_Property;

PROCEDURE Remove_Property (
   property_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM FND_BRANDING_TOKEN_TAB
   WHERE property = property_;
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END Remove_Property;

PROCEDURE Remove_All_Web_Properties
IS
BEGIN
   DELETE FROM FND_BRANDING_TOKEN_TAB
   WHERE property LIKE 'W-%';
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END Remove_All_Web_Properties;


