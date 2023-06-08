-----------------------------------------------------------------------------
--
--  Logical unit: CustomerHierarchyLevel
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130117  Darklk   Bug 107827, Added Insert_Lu_Data_Rec__.
--  080505  KiSalk   Added Check_Exist public function.
--  080123  JeLise   Added check on customer_level to make sure that it is larger than 1 in Unpack_Check_Insert___.
--  080117  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_hierarchy_level_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);

   IF newrec_.customer_level < 1 THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_LEVEL: Hierarchy Level should be greater than 1.');
   END IF;

END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN CUSTOMER_HIERARCHY_LEVEL_TAB%ROWTYPE)
IS
   dummy_      NUMBER;   
   CURSOR Exist IS
      SELECT 1
      FROM CUSTOMER_HIERARCHY_LEVEL_TAB
      WHERE hierarchy_id = newrec_.hierarchy_id
      AND customer_level = newrec_.customer_level;     
  
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO CUSTOMER_HIERARCHY_LEVEL_TAB(
            hierarchy_id,
            customer_level,
            name,
            rowversion)
         VALUES(
            newrec_.hierarchy_id,
            newrec_.customer_level,
            newrec_.name,
            newrec_.rowversion);
   ELSE
     UPDATE CUSTOMER_HIERARCHY_LEVEL_TAB
        SET name = newrec_.name
        WHERE hierarchy_id = newrec_.hierarchy_id
        AND customer_level = newrec_.customer_level;
   END IF;
   CLOSE Exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('ORDER',
                                                      'CustomerHierarchyLevel',
                                                      newrec_.hierarchy_id || '^' || newrec_.customer_level,
                                                      newrec_.name);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Name (
   hierarchy_id_   IN VARCHAR2,
   customer_level_ IN NUMBER,
   language_code_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_HIERARCHY_LEVEL_TAB.name%TYPE;

   CURSOR get_attr IS
      SELECT name
      FROM CUSTOMER_HIERARCHY_LEVEL_TAB
      WHERE hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_;

BEGIN
   temp_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER',
                                                                         'CustomerHierarchyLevel',
                                                                         hierarchy_id_ || '^' || customer_level_,
                                                                         language_code_), 1, 200);
   IF (temp_ IS NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Name;

@UncheckedAccess
FUNCTION Get_Name (
   hierarchy_id_   IN VARCHAR2,
   customer_level_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ customer_hierarchy_level_tab.name%TYPE;
BEGIN
   IF (hierarchy_id_ IS NULL OR customer_level_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      hierarchy_id_||'^'||customer_level_), 1, 200);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT name
      INTO  temp_
      FROM  customer_hierarchy_level_tab
      WHERE hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(hierarchy_id_, customer_level_, 'Get_Name');
END Get_Name;

PROCEDURE New (
   hierarchy_id_   IN VARCHAR2,
   customer_level_   IN NUMBER,
   name_             IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
BEGIN
   Client_SYS.Add_To_Attr('HIERARCHY_ID', hierarchy_id_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL', customer_level_, attr_);
   Client_SYS.Add_To_Attr('NAME', name_, attr_);
   New__(info_,objid_,objversion_,attr_,'DO');
END New;


@UncheckedAccess
FUNCTION Check_Exist (
   hierarchy_id_   IN VARCHAR2,
   customer_level_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(hierarchy_id_, customer_level_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Exist;



