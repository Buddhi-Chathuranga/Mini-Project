-----------------------------------------------------------------------------
--
--  Logical unit: PackagingMaterial
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  090518  KiSalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Packaging_Material (
   packaging_material_id_ IN VARCHAR2,
   language_code_         IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   temp_ PACKAGING_MATERIAL_TAB.packaging_material%TYPE;
   CURSOR get_attr IS
      SELECT packaging_material
      FROM PACKAGING_MATERIAL_TAB
      WHERE packaging_material_id = packaging_material_id_;
BEGIN
   temp_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('INVENT', 'PackagingMaterial', packaging_material_id_,
                                                                                language_code_ ), 1, 200);
   IF (temp_ IS NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Packaging_Material;



