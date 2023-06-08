-----------------------------------------------------------------------------
--
--  Logical unit: AssortmentStructureLevel
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210101  SBalLK  Issue SC2020R1-11830, Modified New(), Copy_Level() methods by removing attr_ functionality to optimize the performance.
--  080916  JeLise   Added name to the LOV.
--  ------------------------- Nice Price ----------------------------------
--  070427  ChBalk   Added SUBSTR for Basic_Data_Translation_API.Get_Basic_Data_Translation returning value.
--  061213  AmPalk   Implemented method Copy_Level.
--  061109  AmPaLK   Added method New.
--  061113  MiErlk   Modified Method name Get_Level_Name in to Get_Name and added code to get Get the langauge independant name.
--  061109  AmPaLK   Added method Get_Level_Name.
--  061026  ISWILK   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Name (
   assortment_id_   IN VARCHAR2,
   structure_level_ IN NUMBER,
   language_code_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   name_      assortment_structure_level_tab.Name%TYPE;

   CURSOR get_name IS
      SELECT name
      FROM assortment_structure_level_tab
      WHERE assortment_id = assortment_id_
      AND structure_level = structure_level_;
BEGIN
   name_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('INVENT',
                                                                          'AssortmentStructureLevel',
                                                                           assortment_id_ || '^' || structure_level_  ,
                                                                           language_code_), 1, 200);

   IF (name_ IS NULL) THEN
      OPEN get_name;
      FETCH get_name INTO name_;
      CLOSE get_name;
   END IF;
   RETURN name_;
END Get_Name;


PROCEDURE New (
   assortment_id_   IN VARCHAR2,
   structure_level_ IN NUMBER,
   name_            IN VARCHAR2 )
IS
   newrec_  assortment_structure_level_tab%ROWTYPE;
BEGIN
   newrec_.assortment_id   := assortment_id_;
   newrec_.structure_level := structure_level_;
   newrec_.name            := name_;
   New___(newrec_);
END New;


PROCEDURE Copy_Level (
   assortment_id_    IN VARCHAR2,
   structure_level_  IN NUMBER,
   new_assort_id_    IN VARCHAR2,
   new_level_        IN NUMBER,
   new_level_name_   IN VARCHAR2 DEFAULT NULL )
IS
   newrec_  assortment_structure_level_tab%ROWTYPE;
BEGIN
   newrec_.assortment_id   := new_assort_id_;
   newrec_.structure_level := new_level_;
   newrec_.name            := NVL(new_level_name_,Get_Name(assortment_id_,structure_level_));
   New___(newrec_);
END Copy_Level;



