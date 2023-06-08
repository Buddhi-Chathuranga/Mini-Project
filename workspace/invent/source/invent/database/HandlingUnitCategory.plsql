-----------------------------------------------------------------------------
--
--  Logical unit: HandlingUnitCategory
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120822  JeLise   Created
--  210609  RaNhlk   MF21R2-578, Added public New()
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   handling_unit_category_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ handling_unit_category_tab.description%TYPE;
BEGIN
   IF (handling_unit_category_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      handling_unit_category_id_), 1, 200);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  handling_unit_category_tab
      WHERE handling_unit_category_id = handling_unit_category_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(handling_unit_category_id_, 'Get_Description');
END Get_Description;

-- New
-- public interface to insert new records.
@UncheckedAccess
PROCEDURE New (
   handling_unit_category_id_ IN VARCHAR2,
   description_               IN VARCHAR2 )
IS
   newrec_ handling_unit_category_tab%ROWTYPE;
BEGIN
   newrec_.handling_unit_category_id := handling_unit_category_id_;
   newrec_.description               := description_;
   New___(newrec_);
END New;
