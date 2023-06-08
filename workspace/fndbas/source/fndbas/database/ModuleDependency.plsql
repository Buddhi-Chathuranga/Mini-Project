-----------------------------------------------------------------------------
--
--  Logical unit: ModuleDependency
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  111124  MaBoSe  Added clear method
--  120705  MaBose  Conditional compiliation improvements - Bug 10391
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Clear (
   module_ IN VARCHAR2 )
IS
   CURSOR getrec IS
      SELECT dependent_module
      FROM MODULE_DEPENDENCY_TAB
      WHERE module = module_;
   remrec_     MODULE_DEPENDENCY_TAB%ROWTYPE;
BEGIN
-- Do not add General_SYS.Init_Method here!!!
   FOR rec IN getrec LOOP
      remrec_ := Lock_By_Keys___(module_, rec.dependent_module);
      DELETE
         FROM  module_dependency_tab
         WHERE module = module_
         AND   dependent_module = rec.dependent_module;
   END LOOP;
END Clear;


@UncheckedAccess
FUNCTION Dependency_Exist (
   module_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR getrec IS
      SELECT 1
      FROM MODULE_DEPENDENCY_TAB
      WHERE dependent_module = module_;
BEGIN
   OPEN getrec;
   FETCH getrec INTO dummy_;
   IF getrec%FOUND THEN
      CLOSE getrec;
      RETURN 'TRUE';
   ELSE
      CLOSE getrec;
      RETURN 'FALSE';
   END IF;
END Dependency_Exist;



