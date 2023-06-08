-----------------------------------------------------------------------------
--
--  Logical unit: InvPartPlanningMethod
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120525  JeLise  Made description private.
--  120507  Matkse  Replaced calls to obsolete Module_Translate_Attr_Util_API with Basic_Data_Translation_API.Added the possibility to translate data by adding a call to Basic_Data_Translation_API.
--  120507          Insert_Basic_Data_Translation in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507          was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
@UncheckedAccess
FUNCTION Get_Description (
   planning_method_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inv_part_planning_method_tab.description%TYPE;
BEGIN
   IF (planning_method_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      planning_method_), 1, 120);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  inv_part_planning_method_tab
      WHERE planning_method = planning_method_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(planning_method_, 'Get_Description');
END Get_Description;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN INV_PART_PLANNING_METHOD_TAB%ROWTYPE)
IS
   dummy_ VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM INV_PART_PLANNING_METHOD_TAB
      WHERE planning_method = newrec_.planning_method;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO INV_PART_PLANNING_METHOD_TAB(
         planning_method,
         description,
         rowversion)
      VALUES (
         newrec_.planning_method,
         newrec_.description,
         newrec_.rowversion);
   ELSE
      UPDATE INV_PART_PLANNING_METHOD_TAB
         SET description = newrec_.description
         WHERE planning_method = newrec_.planning_method;
   END IF;
   -- Insert Data into Basic Data Translations tab
   Basic_Data_Translation_API.Insert_Prog_Translation('INVENT',
                                                      'InvPartPlanningMethod',
                                                      newrec_.planning_method,
                                                      newrec_.description);
   CLOSE Exist;
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Is_Order_Point_Or_Tpss_Char (
   planning_method_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   is_order_point_or_tpss_char_ VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF (Is_Order_Point(planning_method_) OR Is_Tpss(planning_method_)) THEN
      is_order_point_or_tpss_char_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   
   RETURN is_order_point_or_tpss_char_;
END Is_Order_Point_Or_Tpss_Char;

FUNCTION Is_Order_Point_Or_Tpss (
   planning_method_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN (Is_Order_Point_Or_Tpss_Char(planning_method_) = Fnd_Boolean_API.DB_TRUE);
END Is_Order_Point_Or_Tpss;

FUNCTION Is_Order_Point_Char (
   planning_method_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   is_order_point_char_ VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF (planning_method_ = 'B') THEN
      is_order_point_char_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   
   RETURN is_order_point_char_;
END Is_Order_Point_Char;

FUNCTION Is_Order_Point (
   planning_method_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN (Is_Order_Point_Char(planning_method_) = Fnd_Boolean_API.DB_TRUE);
END Is_Order_Point;

FUNCTION Is_Tpss_Char (
   planning_method_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   is_tpss_char_ VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF (planning_method_ IN ('A', 'D', 'E', 'F', 'G', 'M'))THEN
      is_tpss_char_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   
   RETURN is_tpss_char_;
END Is_Tpss_Char;

FUNCTION Is_Tpss (
   planning_method_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN 
   RETURN (Is_Tpss_Char(planning_method_) = Fnd_Boolean_API.DB_TRUE);
END Is_Tpss;

