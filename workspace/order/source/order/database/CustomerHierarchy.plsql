-----------------------------------------------------------------------------
--
--  Logical unit: CustomerHierarchy
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130117  Darklk   Bug 107827, Added Insert_Lu_Data_Rec__.
--  120525  JeLise   Made description private.
--  120509  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120509           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120509           was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  060110  CsAmlk   Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
-- --------------------------------------13.3.0----------------------
--  000920  JoEd  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_HIERARCHY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.creation_date := trunc(sysdate);
   Client_SYS.Add_To_Attr('CREATION_DATE', newrec_.creation_date, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN CUSTOMER_HIERARCHY_TAB%ROWTYPE)
IS
   dummy_      NUMBER;   
   CURSOR Exist IS
      SELECT 1
      FROM CUSTOMER_HIERARCHY_TAB
      WHERE hierarchy_id = newrec_.hierarchy_id;      
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO CUSTOMER_HIERARCHY_TAB(
            hierarchy_id,
            description,
            creation_date,
            rowversion)
         VALUES(
            newrec_.hierarchy_id,
            newrec_.description,
            newrec_.creation_date,
            newrec_.rowversion);
   ELSE
     UPDATE CUSTOMER_HIERARCHY_TAB
        SET description = newrec_.description
      WHERE hierarchy_id = newrec_.hierarchy_id;
   END IF;
   CLOSE Exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('ORDER',
                                                      'CustomerHierarchy',
                                                      newrec_.hierarchy_id,
                                                      newrec_.description);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   hierarchy_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_hierarchy_tab.description%TYPE;
BEGIN
   IF (hierarchy_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      hierarchy_id_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  customer_hierarchy_tab
      WHERE hierarchy_id = hierarchy_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(hierarchy_id_, 'Get_Description');
END Get_Description;



