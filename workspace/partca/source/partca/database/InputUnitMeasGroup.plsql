-----------------------------------------------------------------------------
--
--  Logical unit: InputUnitMeasGroup
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201218  SBalLK   Issue SC2020R1-11830, Modified Insert_New_Record() method by removing attr_ functionality to optimize the performance.
--  151112  PrYaLK   Bug 124621, Changed the cursor to select all the records from the tab and fetch the records to a tab of a type of cursor row type
--  151112           and edited the fetched record set with new values and sent it to bulk insert in the method Insert_Input_Uom_Lines();
--  141125  TAORSE   Added Enumerate_With_Params_Db
--  120525  JeLise   Made description private.
--  120504  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120504           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120504           was added. Get_Description and the views were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  100423  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  110502  MatKSE   Modified faulty select statement in Insert_new_Record causing constraint violation on rowkey
--                   in the subsequent insert statement.
--  081006  MaJalk   Changed the parameter order of the cursor get_lines at Insert_Input_Uom_Lines().
--  080811  MaJalk   Added default_input_uom to the select statement at Insert_Input_Uom_Lines.
--  040818  RaKalk   Removed Last Parameter(true) of General_SYS.Init_Method call in method Enumerate_With_Params.
--  040716  SaJjlk   Removed the code for state machine
--  040715  JaJalk   Added the methods Is_Usage_Allowed and Enumerate_With_Params and Has_Variables___.
--  040713  HeWelk   Added INPUT_UOM_GROUP_LOV view.
--  040628  SaJjlk   Added method Insert_New_Record and Insert_Input_Uom_Lines
--  040614  DaRulk   Added checks in Unpack_Check_Insert___ and Unpack_Check_Update___
--  040607  DaRulk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Has_Variables___
--   Returns true if a variable exist in a group with value user or default.
FUNCTION Has_Variables___ (
   input_unit_meas_group_id_ IN VARCHAR2,
   unit_code_                IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR variables IS
      SELECT 1
      FROM input_unit_meas_variable_tab
      WHERE input_unit_meas_group_id = input_unit_meas_group_id_
      AND unit_code = unit_code_
      AND value_source IN ('USER', 'DEFAULT');

BEGIN

   OPEN variables;
   FETCH variables INTO dummy_;
   IF variables%NOTFOUND THEN
      CLOSE variables;
      RETURN 'FALSE';
   END IF;
   CLOSE variables;
   RETURN 'TRUE';

END Has_Variables___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   input_unit_meas_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ input_unit_meas_group_tab.description%TYPE;
BEGIN
   IF (input_unit_meas_group_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      input_unit_meas_group_id_), 1, 100);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
   INTO   temp_
   FROM   input_unit_meas_group_tab
   WHERE  input_unit_meas_group_id = input_unit_meas_group_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(input_unit_meas_group_id_, 'Get_Description');
END Get_Description;


-- Insert_New_Record
--   Inserts a new record in to the Input_unit_meas_group_tab
PROCEDURE Insert_New_Record (
   old_group_id_ IN OUT VARCHAR2,
   new_group_id_ IN OUT VARCHAR2,
   description_  IN     VARCHAR2 )
IS
   newrec_     input_unit_meas_group_tab%ROWTYPE;
BEGIN
   -- Inserts a new record in to the Input_unit_meas_group_tab
   newrec_.input_unit_meas_group_id := new_group_id_;
   newrec_.description              := description_;
   newrec_.unit_code                := Get_Unit_Code(old_group_id_);
   New___(newrec_);
   Insert_Input_Uom_Lines(old_group_id_,new_group_id_);
END Insert_New_Record;


-- Insert_Input_Uom_Lines
--   This inserts a new set of recods in to the input_unit_meas table from a bulk record.
PROCEDURE Insert_Input_Uom_Lines (
   old_group_id_ IN VARCHAR2,
   new_group_id_ IN VARCHAR2 )
IS
   CURSOR get_lines IS
      SELECT *
      FROM input_unit_meas_tab
      WHERE input_unit_meas_group_id = old_group_id_;

   type Input_Lines_Tab is table of get_lines%ROWTYPE;
   input_lines_ Input_Lines_Tab;
BEGIN
   -- This inserts a new set of recods in to the input_unit_meas table from a bulk record.
   OPEN get_lines;
   FETCH get_lines BULK COLLECT INTO input_lines_ ;
   IF get_lines%ROWCOUNT>0 THEN
      FOR i IN input_lines_.FIRST..input_lines_.LAST LOOP
         input_lines_(i).input_unit_meas_group_id := new_group_id_;
         input_lines_(i).rowversion := SYSDATE;
         input_lines_(i).rowkey := SYS_GUID();
      END LOOP;
      FORALL i IN  1..input_lines_.COUNT
        INSERT INTO input_unit_meas_tab VALUES input_lines_(i);

      FOR i IN input_lines_.FIRST..input_lines_.LAST LOOP
         IF input_lines_(i).formula_id IS NOT NULL THEN
            Input_Unit_Meas_API.Create_Uom_Variables(input_lines_(i).input_unit_meas_group_id,
                                                     input_lines_(i).unit_code,
                                                     input_lines_(i).formula_id);
         END IF;
      END LOOP;
   END IF;
   CLOSE get_lines;
END Insert_Input_Uom_Lines;


-- Enumerate_With_Params
--   Returns the unit code as enumerate value to call from a special class.
--   And also it returns the component that can be used.
PROCEDURE Enumerate_With_Params (
   client_values_            OUT VARCHAR2,
   en_list_value_            OUT VARCHAR2,
   input_unit_meas_group_id_ IN  VARCHAR2,
   component_                IN  VARCHAR2 )
IS
   desc_list_  VARCHAR2(32000);
   en_list_    VARCHAR2(32000);

   CURSOR get_value IS
      SELECT unit_code, formula_id
      FROM INPUT_UNIT_MEAS_TAB
      WHERE input_unit_meas_group_id = input_unit_meas_group_id_
      AND (purch_usage_allowed = (CASE WHEN (component_ = 'PURCH') THEN 1 END) OR
           cust_usage_allowed = (CASE WHEN (component_  = 'ORDER') THEN 1 END) OR
           manuf_usage_allowed = (CASE WHEN (component_ = 'MANUF') THEN 1 END));

BEGIN

   FOR rec_ IN get_value LOOP
         desc_list_ := desc_list_ || rec_.unit_code  || Client_SYS.field_separator_;
         IF (rec_.formula_id IS NOT NULL) THEN
            en_list_ := en_list_ || Has_Variables___(input_unit_meas_group_id_,
                                                     rec_.unit_code);
         ELSE
            en_list_ := en_list_|| 'FALSE';
         END IF;
         en_list_ := en_list_||Client_SYS.field_separator_;
   END LOOP;

   client_values_ := desc_list_;
   en_list_value_ := en_list_;

END Enumerate_With_Params;

PROCEDURE Enumerate_With_Params_Db (
   db_values_            OUT VARCHAR2,
   en_list_value_            OUT VARCHAR2,
   input_unit_meas_group_id_ IN  VARCHAR2,
   component_                IN  VARCHAR2 )
IS
   desc_list_  VARCHAR2(32000);
   en_list_    VARCHAR2(32000);

   CURSOR get_value IS
      SELECT unit_code, formula_id
      FROM INPUT_UNIT_MEAS_TAB
      WHERE input_unit_meas_group_id = input_unit_meas_group_id_
      AND (purch_usage_allowed = (CASE WHEN (component_ = 'PURCH') THEN 1 END) OR
           cust_usage_allowed = (CASE WHEN (component_  = 'ORDER') THEN 1 END) OR
           manuf_usage_allowed = (CASE WHEN (component_ = 'MANUF') THEN 1 END));

BEGIN

   FOR rec_ IN get_value LOOP
         desc_list_ := desc_list_ || rec_.unit_code  || Client_SYS.field_separator_;
         IF (rec_.formula_id IS NOT NULL) THEN
            en_list_ := en_list_ || Has_Variables___(input_unit_meas_group_id_,
                                                     rec_.unit_code);
         ELSE
            en_list_ := en_list_|| 'FALSE';
         END IF;
         en_list_ := en_list_||Client_SYS.field_separator_;
   END LOOP;

   db_values_ := desc_list_;
   en_list_value_ := en_list_;

END Enumerate_With_Params_Db;



-- Is_Usage_Allowed
--   Retunes TRUE if the group has at least one record with the selected component.
@UncheckedAccess
FUNCTION Is_Usage_Allowed (
   input_unit_meas_group_id_ IN VARCHAR2,
   component_                IN VARCHAR2 ) RETURN VARCHAR2
IS
dummy_ NUMBER;
   CURSOR comp_allow IS
      SELECT 1
      FROM input_unit_meas_tab
      WHERE input_unit_meas_group_id = input_unit_meas_group_id_
      AND (purch_usage_allowed = (CASE WHEN (component_ = 'PURCH') THEN 1 END) OR
           cust_usage_allowed = (CASE WHEN (component_  = 'ORDER') THEN 1 END) OR
           manuf_usage_allowed = (CASE WHEN (component_ = 'MANUF') THEN 1 END));



BEGIN
   OPEN comp_allow;
   FETCH comp_allow INTO dummy_;
   IF comp_allow%NOTFOUND THEN
      CLOSE comp_allow;
      RETURN 'FALSE';
   END IF;
   CLOSE comp_allow;
   RETURN 'TRUE';
END Is_Usage_Allowed;



