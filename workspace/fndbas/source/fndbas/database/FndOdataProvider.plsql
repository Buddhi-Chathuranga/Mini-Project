-----------------------------------------------------------------------------
--
--  Logical unit: FndOdataProvider
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170105  BUHILK  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Projection_Metadata___ (
   projection_name_       IN VARCHAR2,
   allowed_category_      IN VARCHAR2) RETURN CLOB
IS
BEGIN
   Validate_Projection_Metadata___(projection_name_, allowed_category_);
   RETURN Model_Design_SYS.Get_Data_Content_(Model_Design_SYS.SERVER_METADATA, 'projection', projection_name_, language_ => Fnd_Session_API.Get_Language);
END Get_Projection_Metadata___;

PROCEDURE Validate_Projection_Metadata___ (
   projection_name_       IN VARCHAR2,
   allowed_category_      IN VARCHAR2)
IS
   supported_categories_    FND_PROJECTION_TAB.categories%TYPE;
   allowed_category_list_   DBMS_UTILITY.UNCL_ARRAY;
   category_count_          INTEGER;
   is_allowed_category_     BOOLEAN := FALSE;
BEGIN
   Assert_SYS.Assert_Is_Projection(projection_name_);
   
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      IF NOT (Custom_Projection_API.Valid_Metadata_Exist(projection_name_)) THEN
         Error_SYS.Projection_Not_Exist(lu_name_, projection_name_);
      END IF;
   $END
   
   supported_categories_ := Fnd_Projection_API.Get_Categories(projection_name_);
   IF supported_categories_ IS NULL THEN
      Error_SYS.Projection_Category(lu_name_, projection_name_);
   ELSIF allowed_category_ != 'Dev' THEN     
      DBMS_UTILITY.COMMA_TO_TABLE (allowed_category_, category_count_, allowed_category_list_);
      FOR category_id_ IN 1 .. category_count_
      LOOP
         IF INSTR(supported_categories_, allowed_category_list_(category_id_), 1) != 0 THEN
            is_allowed_category_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
      IF NOT is_allowed_category_ THEN
         Error_SYS.Projection_Category(lu_name_, projection_name_, supported_categories_);
      END IF;
   END IF;

   IF NOT (Model_Design_SYS.Has_Data_Content_(Model_Design_SYS.SERVER_METADATA, 'projection', projection_name_)) THEN
      Error_SYS.Projection_Meta_Not_Exist(lu_name_, projection_name_);
   END IF;
END Validate_Projection_Metadata___;

FUNCTION Get_Projection_Meta_Version___ (
   projection_name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Model_Design_SYS.Get_Data_Version_(Model_Design_SYS.SERVER_METADATA, 'projection', projection_name_);
END Get_Projection_Meta_Version___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Projection_Metadata (
   projection_name_       IN VARCHAR2,
   allowed_category_      IN VARCHAR2,
   allowed_service_group_ IN VARCHAR2 DEFAULT NULL) RETURN CLOB
IS
BEGIN
   RETURN Get_Projection_Metadata___(projection_name_, allowed_category_);
END Get_Projection_Metadata;

FUNCTION Get_Projection_Meta_Version (
   projection_name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Projection_Meta_Version___(projection_name_);
END Get_Projection_Meta_Version;

FUNCTION Get_Allowed_File_Extensions RETURN VARCHAR2
IS
   docman_extensions_   VARCHAR2(3000) := '';
   media_extensions_    VARCHAR2(3000) := '';
   extensions_          VARCHAR2(30000) := '';
BEGIN
   $IF Component_Docman_SYS.INSTALLED $THEN
      docman_extensions_ := REPLACE(Edm_Application_API.Get_All_File_Extentions(), '^', ',');
      docman_extensions_ := RTRIM(docman_extensions_, ',');
   $END
   $IF Component_Appsrv_SYS.INSTALLED $THEN
      media_extensions_ := Media_Library_Util_API.Get_Media_File_Ext_List();
      media_extensions_ := REPLACE(media_extensions_, '.', '');
      media_extensions_ := RTRIM(media_extensions_, ',');
   $END
   extensions_ := Fnd_Setting_API.Get_Value('ALLOWED_EXTENSION');
   
   IF Length(docman_extensions_) > 0 THEN
      extensions_ := extensions_||','||docman_extensions_;
   END IF;
   
   IF Length(media_extensions_) > 0 THEN
      extensions_ := extensions_||','||media_extensions_;
   END IF;
   
   RETURN UPPER(extensions_);
END Get_Allowed_File_Extensions;

-------------------- LU  NEW METHODS -------------------------------------
