-----------------------------------------------------------------------------
--
--  Logical unit: InputUnitMeas
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201218  SBalLK  Issue SC2020R1-11830, Modified Create_Uom_Item___() method by removing attr_ functionality to optimize the performance.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  190410  ChBnlk  Bug 147902 (SCZ-4050), Modified Create_Data_Capture_Lov() by changing conditional compilation of session_rec_ usage to check for both Mpccom  
--  190410          and Wadaco to avoid build errors. 
--  181119  LEPESE  SCUXXW4-14405, Corrected bug in Create_Data_Capture_Lov to make sure to check for both MPCCOM and WADACO in the
--  181119          conditional compilation block because session_rec_ variable is declare as a being of a type defined in MPCCOM.
--  170908  SWiclk STRSC-11956, Added Get_Column_Value_If_Unique().
--  170816  SWiclk STRSC-9612, Modified Create_Data_Capture_Lov() and Record_With_Column_Value_Exist() by   
--  170816         adding sql_where_expression_ parameter so that each process could handle its own filteration.
--  170714  ChFolk STRSC-10875, Added dynamic connection for mpccom on Create_Data_Capture_Lov.
--  170707  SWiclk STRSC-9612, Added Create_Data_Capture_Lov() and Record_With_Column_Value_Exist() in order to implemented GTIN support.
--  140410  DaZase PBSC-8258, Added code Check_Unit_Code_Ref___ to stop Check_Common___ from doing the Iso_Unit_API.Exist 
--  140410         check for user defined UoMs, this is now only performed in the new method for SYSTEM_DEFINED unit codes. 
--  140410         This reference is also changed in the model so it has custom DbCheckImplementation.
--  130730  MaIklk TIBE-1037, Removed global constants and used conditional compilation instead.
--  111222  JuMalk Bug 100498, Modified method Get_Input_Value_String by converting parameter input_quantity to a string value.
--  100909  NaLrlk Modified the description column to public and modified method Check_Delete___.
--  100423  KRPELK Merge Rose Method Documentation.
--  081016  MaJalk Modified Unpack_Check_Update___, Unpack_Check_Insert___, Insert___ to validate and set default_input_uom.
--  080108  MaJalk Removed update of rowversion at default_input_uom = TRUE record at Update___.
--  080925  MaJalk Set cust_usage_allowed as a public attribute.
--  080811  MaJalk Added method Get_Default_Input_Uom and attribute default_input_uom.
--  080716  MaJalk Added method Get_Cust_Usage_Allowed.
--  040820  SaJjlk Modified Unpack_Check_Insert___, Insert___ and Unpack_Check_Update___
--  040728  DaRulk Added the function Get_Input_Value_String.
--  040724  DaRulk Made the ROUNDING_DECIMALS public.
--  040720  JaJalk Made the CONVERSION_FACTOR public.
--  040713  SaJjlk Modified properties for formula_id and changed code added to Modify__
--  040708  SaJjlk Added more checks for Unpack_Check_Update___
--  040705  JaJalk Corrected some unit test bugs.
--  040628  SaJjlk Added method Insert_New_Record
--  040616  JaJalk Added the method Create_Uom_Item___.
--  040614  SaJjlk Added Is_Formula_Used
--  040614  DaRulk Added more checks in Unpack_Check_Insert___ and  Unpack_Check_Update___
--  040612  DaRulk Prepare_Insert___ and Unpack_Check_Insert___
--  040610  DaRulk Removed Is_Iso_Unit method.
--  040607  DaRulk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Create_Uom_Item___
--   Inserts records to the InputUnitMeasVariable if the line contains
--   a formula with variables.
PROCEDURE Create_Uom_Item___ (
   input_unit_meas_group_id_ IN VARCHAR2,
   unit_code_                IN VARCHAR2,
   formula_id_               IN VARCHAR2 )
IS
   CURSOR get_variable IS
      SELECT * FROM FORMULA_ITEM_VARIABLE_PUB
      WHERE  formula_id = formula_id_;
BEGIN

   FOR rec_ IN get_variable LOOP
      IF (get_variable%FOUND) THEN
         Input_Unit_Meas_Variable_API.Create_Uom_Item(input_unit_meas_group_id_,
                                                      unit_code_,
                                                      formula_id_,
                                                      rec_.formula_item_id,
                                                      rec_.variable_id,
                                                      rec_.variable_value,
                                                      rec_.value_source );
      END IF;
   END LOOP;
END Create_Uom_Item___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('MANUF_USAGE_ALLOWED', 1, attr_);   
   $IF (Component_Order_SYS.INSTALLED) $THEN
      Client_SYS.Add_To_Attr('CUST_USAGE_ALLOWED', 1, attr_);
   $ELSE
      Client_SYS.Add_To_Attr('CUST_USAGE_ALLOWED', 0, attr_);
   $END
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      Client_SYS.Add_To_Attr('PURCH_USAGE_ALLOWED', 1, attr_);
   $ELSE
      Client_SYS.Add_To_Attr('PURCH_USAGE_ALLOWED', 0, attr_);
   $END
   Client_SYS.Add_To_Attr('DEFAULT_INPUT_UOM_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INPUT_UNIT_MEAS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.default_input_uom = 'TRUE') THEN
      UPDATE input_unit_meas_tab
         SET default_input_uom = 'FALSE'
       WHERE input_unit_meas_group_id = newrec_.input_unit_meas_group_id
         AND default_input_uom = 'TRUE';
   END IF;

   super(objid_, objversion_, newrec_, attr_);
   IF (newrec_.formula_id IS NOT NULL) THEN
      Create_Uom_Item___ (newrec_.input_unit_meas_group_id,
                          newrec_.unit_code,
                          newrec_.formula_id);
   END IF;

   Client_SYS.Add_To_Attr('ROUNDING_DECIMALS',newrec_.rounding_decimals,attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     INPUT_UNIT_MEAS_TAB%ROWTYPE,
   newrec_     IN OUT INPUT_UNIT_MEAS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.default_input_uom = 'TRUE') THEN
      UPDATE input_unit_meas_tab
         SET default_input_uom = 'FALSE'
       WHERE input_unit_meas_group_id = newrec_.input_unit_meas_group_id
         AND default_input_uom = 'TRUE';
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN INPUT_UNIT_MEAS_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   Part_Catalog_API.Check_Delete_Input_Unit_Meas(remrec_.input_unit_meas_group_id, remrec_.unit_code);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT input_unit_meas_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   
   IF (newrec_.input_unit_meas_type = 'SYSTEM_DEFINED') and (Iso_Unit_API.Check_Exist(newrec_.unit_code)='FALSE') and (newrec_.formula_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_,'SYSDEFBEISO: The Input UoM cannot be a System Defined UoM');
   END IF;

   IF (newrec_.input_unit_meas_type = 'SYSTEM_DEFINED') and (Iso_Unit_API.Check_Exist(newrec_.unit_code)='TRUE') THEN
         newrec_.conversion_factor:=Iso_Unit_API.Convert_Unit_Quantity(1,newrec_.unit_code,
               Input_Unit_Meas_Group_API.Get_Unit_Code(newrec_.input_unit_meas_group_id));

   END IF;
   IF (Iso_Unit_API.Check_Exist(newrec_.unit_code)='FALSE' and newrec_.formula_id IS NULL) THEN
         newrec_.input_unit_meas_type := 'USER_DEFINED';
   END IF;

   IF (newrec_.formula_id IS NOT NULL) and (Formula_API.Get_Obj_State(newrec_.formula_id)='Invalid') THEN
      Error_SYS.Record_General(lu_name_,'ATTACHINVFORMULA: Cannot attach formulas in Invalid state to Input UoMs');
   END IF;

   IF (newrec_.rounding_decimals IS NULL) THEN
      newrec_.rounding_decimals:=6;
   ELSE 
      newrec_.rounding_decimals := CEIL(newrec_.rounding_decimals);
   END IF;

   IF (newrec_.default_input_uom = 'TRUE' AND newrec_.cust_usage_allowed = 0) THEN
      Error_SYS.Record_General(lu_name_,'INVALDEFAULTS: If the Sales Usage Allowed check box has not been selected, then you cannot select the Default Input UoM check box.');
   END IF;

   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     input_unit_meas_tab%ROWTYPE,
   newrec_ IN OUT input_unit_meas_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.input_unit_meas_type = 'SYSTEM_DEFINED') and (Iso_Unit_API.Check_Exist(newrec_.unit_code)='FALSE') and (newrec_.formula_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_,'SYSDEFBEISO: The Input UoM cannot be a System Defined UoM');
   END IF;

   IF (newrec_.input_unit_meas_type = 'SYSTEM_DEFINED') and (Iso_Unit_API.Check_Exist(newrec_.unit_code)='TRUE') THEN
         newrec_.conversion_factor:=Iso_Unit_API.Convert_Unit_Quantity(1,newrec_.unit_code,
               Input_Unit_Meas_Group_API.Get_Unit_Code(newrec_.input_unit_meas_group_id));

   END IF;
   IF (Iso_Unit_API.Check_Exist(newrec_.unit_code)='FALSE' and newrec_.formula_id IS NULL) THEN
         newrec_.input_unit_meas_type := 'USER_DEFINED';
   END IF;

   IF (newrec_.formula_id IS NOT NULL) and (Formula_API.Get_Obj_State(newrec_.formula_id)='Invalid') THEN
      Error_SYS.Record_General(lu_name_,'ATTACHINVFORMULA: Cannot attach formulas in Invalid state to Input UoMs');
   END IF;

   IF (newrec_.rounding_decimals IS NULL) THEN
      newrec_.rounding_decimals:=6;
   END IF;

   IF (newrec_.default_input_uom = 'TRUE' AND newrec_.cust_usage_allowed = 0) THEN
      Error_SYS.Record_General(lu_name_,'INVALDEFAULTS: If the Sales Usage Allowed check box has not been selected, then you cannot select the Default Input UoM check box.');
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


PROCEDURE Check_Unit_Code_Ref___ (
   newrec_ IN OUT input_unit_meas_tab%ROWTYPE )
IS
BEGIN
   -- Only do exist checks on SYSTEM_DEFINED unit codes
   IF (newrec_.input_unit_meas_type = 'SYSTEM_DEFINED') THEN
      Iso_Unit_API.Exist(newrec_.unit_code);
   END IF;
END Check_Unit_Code_Ref___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Is_Formula_Used
--   Returns 'TRUE' if the formula has been used by an Input UoM Group.
@UncheckedAccess
FUNCTION Is_Formula_Used (
   formula_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_items_ IS
   SELECT input_unit_meas_group_id
   FROM input_unit_meas_tab
   WHERE formula_id=formula_id_;

   items_ VARCHAR2(1000);
   formula_used_ VARCHAR2(10);
BEGIN

-- This returns 'TRUE' if the formula has been used in any of the Input UoM

   OPEN get_items_;
   FETCH get_items_ INTO items_;
   CLOSE get_items_ ;
   IF items_ IS NOT NULL THEN
      formula_used_:='TRUE';
   ELSE
      formula_used_:='FALSE';
   END IF;
   RETURN formula_used_;
END Is_Formula_Used;


-- Create_Uom_Variables
--   This calls the implementation method for creating variables for input
--   units of measurement of type 'Formula'
PROCEDURE Create_Uom_Variables (
   input_unit_meas_group_id_  IN VARCHAR2,
   unit_code_                 IN VARCHAR2,
   formula_id_                IN VARCHAR2 )
IS
BEGIN
-- Enter variable lines for 'formula' type of input units of measurement
  Create_Uom_Item___ (input_unit_meas_group_id_,
                      unit_code_,
                      formula_id_);

END Create_Uom_Variables;


@UncheckedAccess
FUNCTION Get_Input_Value_String(
       input_quantity_  IN NUMBER,
       input_unit_meas_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   input_qty_str_ VARCHAR2(100);
BEGIN
   input_qty_str_ := to_char(input_quantity_);
   IF(input_quantity_ < 1 AND input_quantity_ > 0) THEN
      input_qty_str_ := '0'||input_qty_str_;    
   END IF;
   -- Parameter input_quantity_ was converted to a string and sent in order to have the leading zero.
   RETURN Language_SYS.Translate_Constant(lu_name_, 'INPUTSTRING: Input Quantity: :P1 :P2',NULL, input_qty_str_, input_unit_meas_ );
END Get_Input_Value_String;


-- Get_Default_Input_Uom
--   Returns the Default Input UoM for a Input UoM Group Id.
@UncheckedAccess
FUNCTION Get_Default_Input_Uom (
   input_unit_meas_group_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ INPUT_UNIT_MEAS_TAB.unit_code%TYPE;
   CURSOR get_attr IS
      SELECT unit_code
      FROM INPUT_UNIT_MEAS_TAB
      WHERE input_unit_meas_group_id = input_unit_meas_group_id_
      AND   default_input_uom = 'TRUE';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Default_Input_Uom;


-- This method is used by DataCaptAttachPartHu, DataCaptCountPartRep, DataCaptIssueInvPart, DataCaptIssueMtrlReq,
-- DataCaptRecFromTransit, DataCaptScrapInvPart, DataCaptTranspTaskPart, DataCaptUnattachPartHu, DataCaptureCountPart,
-- DataCaptureMovePart, DataCaptReportPickPart, DataCapRecPartDispAdv, DataCaptRegstrArrivals, DataCaptureMoveReceipt,
-- DataCapPackIntoHuShip, DataCapProcessPartShip, DataCaptUnpackHuShip, DataCaptManIssSoPart, DataCaptRecSo,
-- DataCaptRecSoByProd, DataCaptRepPickPartSo, DataCaptManIssueWo, DataCaptUnissueWo and DataCaptUnplanIssueWo
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (   
   capture_session_id_       IN NUMBER,
   input_unit_meas_group_id_ IN VARCHAR2,
   column_name_              IN VARCHAR2,
   lov_type_db_              IN VARCHAR2,   
   sql_where_expression_     IN VARCHAR2 DEFAULT NULL)
IS
   $IF Component_Mpccom_SYS.INSTALLED $THEN
      session_rec_          Data_Capture_Common_Util_API.Session_Rec;
   $END
   lov_row_limitation_   NUMBER;
   exit_lov_             BOOLEAN := FALSE;
   second_column_name_   VARCHAR2(200);
   second_column_value_  VARCHAR2(200); 
   stmt_                 VARCHAR2(2000);
   TYPE Lov_Value_Tab    IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_        Lov_Value_Tab;
   TYPE Get_Lov_Values   IS REF CURSOR;
   get_lov_values_       Get_Lov_Values;
   lov_item_description_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED AND Component_Mpccom_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id      
      Assert_SYS.Assert_Is_Table_Column('INPUT_UNIT_MEAS_TAB', column_name_);
      
      stmt_ := '  FROM INPUT_UNIT_MEAS_TAB
                  WHERE input_unit_meas_group_id = :input_unit_meas_group_id_ ';
      
      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;
      
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK 
         stmt_ := 'SELECT ' || column_name_ || stmt_ || ' ORDER BY Utility_SYS.String_To_Number(' || column_name_ || '), ' || column_name_ || ' ASC' ;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_ || stmt_ || ' ORDER BY Utility_SYS.String_To_Number(' || column_name_ || '), ' || column_name_ || ' ASC';
      END IF;
      
      @ApproveDynamicStatement(2017-08-16,SWICLK)
      OPEN get_lov_values_ FOR stmt_ USING input_unit_meas_group_id_;
      
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('UNIT_CODE') THEN
               second_column_name_ := 'DESCRIPTION';
            ELSE
               NULL;
         END CASE;
            
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'DESCRIPTION') THEN                     
                     second_column_value_ := Input_Unit_Meas_API.Get_Description(input_unit_meas_group_id_, lov_value_tab_(i));
                  END IF;
                  IF (second_column_value_ IS NOT NULL) THEN
                     lov_item_description_ := second_column_value_;
                  ELSE
                    lov_item_description_ := NULL;
                  END IF;
               END IF;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;                                  
      
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


-- This method is used by DataCaptAttachPartHu, DataCaptCountPartRep, DataCaptIssueInvPart, DataCaptIssueMtrlReq,
-- DataCaptRecFromTransit, DataCaptScrapInvPart, DataCaptTranspTaskPart, DataCaptUnattachPartHu, DataCaptureCountPart,
-- DataCaptureMovePart, DataCaptReportPickPart, DataCapRecPartDispAdv, DataCaptRegstrArrivals, DataCaptureMoveReceipt,
-- DataCapPackIntoHuShip, DataCapProcessPartShip, DataCaptUnpackHuShip, DataCaptManIssSoPart, DataCaptRecSo,
-- DataCaptRecSoByProd, DataCaptRepPickPartSo, DataCaptManIssueWo, DataCaptUnissueWo and DataCaptUnplanIssueWo
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (   
   input_unit_meas_group_id_ IN VARCHAR2,    
   column_name_              IN VARCHAR2,
   column_value_             IN VARCHAR2,
   column_description_       IN VARCHAR2,
   sql_where_expression_     IN VARCHAR2 DEFAULT NULL)
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(2000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
   -- NOTE: This method can be changed to have several cursors/views etc if more wadaco processes start to use it (it was created for Unissue WO)
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id      
   Assert_SYS.Assert_Is_Table_Column('INPUT_UNIT_MEAS_TAB', column_name_);

   stmt_ := ' SELECT 1
              FROM INPUT_UNIT_MEAS_TAB
              WHERE input_unit_meas_group_id = NVL(:input_unit_meas_group_id_, input_unit_meas_group_id)
              AND ' || column_name_ ||'  = :column_value_';

   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;  
      
   @ApproveDynamicStatement(2017-07-11,SWICLK)
   OPEN exist_control_ FOR stmt_ USING input_unit_meas_group_id_,
                                       column_value_;
             
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
   END IF;
END Record_With_Column_Value_Exist;


-- This method is used by DataCaptAttachPartHu, DataCaptCountPartRep, DataCaptIssueInvPart, DataCaptIssueMtrlReq,
-- DataCaptRecFromTransit, DataCaptScrapInvPart, DataCaptTranspTaskPart, DataCaptUnattachPartHu, DataCaptureCountPart,
-- DataCaptureMovePart, DataCaptReportPickPart, DataCapRecPartDispAdv, DataCaptRegstrArrivals, DataCaptureMoveReceipt,
-- DataCapPackIntoHuShip, DataCapProcessPartShip, DataCaptUnpackHuShip, DataCaptManIssSoPart, DataCaptRecSo,
-- DataCaptRecSoByProd, DataCaptRepPickPartSo, DataCaptManIssueWo, DataCaptUnissueWo and DataCaptUnplanIssueWo
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   input_unit_meas_group_id_ IN VARCHAR2,
   column_name_              IN VARCHAR2,
   sql_where_expression_     IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(4000);
   column_value_                  VARCHAR2(50);
   unique_column_value_           VARCHAR2(50);

BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_Table_Column('INPUT_UNIT_MEAS_TAB', column_name_);   
   stmt_ := ' SELECT ' || column_name_ || '
              FROM  INPUT_UNIT_MEAS_TAB
              WHERE input_unit_meas_group_id = NVL(:input_unit_meas_group_id_, input_unit_meas_group_id) ';
   
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || sql_where_expression_;
   END IF;

   @ApproveDynamicStatement(2017-08-16,SWICLK)
   OPEN get_column_values_ FOR stmt_ USING input_unit_meas_group_id_;  
                                                       
   LOOP
      FETCH get_column_values_ INTO column_value_;
      EXIT WHEN get_column_values_%NOTFOUND;

      IF (unique_column_value_ IS NULL) THEN
         unique_column_value_ := column_value_;
      ELSIF (unique_column_value_ != column_value_) THEN
         unique_column_value_ := NULL;
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_column_values_;   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;



