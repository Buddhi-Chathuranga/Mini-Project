-----------------------------------------------------------------------------
--
--  Logical unit: ObjConnectLuTransform
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210205  SHAGLK  AM2020R1-7260, Added new parameter service_ and modified method Transform_Object_Connection 
--  201029  DEEKLK  AM2020R1-6341, Modified Dictionary_Sys methods for Solution Set support. 
--  200929  MDAHSE  Change to use the new dictionary_sys views because of the work with solution sets.
--  190417  SIGALK  SAUXXW4-10439, Added new method Service_Name_Table().
--  180912  MDAHSE  SAUXXW4-9905, Move code from Doc_Reference_Object_API.Transform_Object_Connection to here.
--  ------------------------------Core 10.0----------------------------------
--  180504  SAMGLK  Bug 141301, Increased the size of key_refs. TYPE Transformed_Lu_Key_Rec,    Set_Source_Key___(),    Transform_By_Method___(),       Transform_By_Record___()
--  190129  LoPrlk  Bug: 146581, Added the method Bind_Var_To_Cursor___ and called inside Run_And_Get_Statement___.
--  181114  CLEKLK  Bug 145236, Modified Validate_Flags___ and Check_Common___
--  180504  SAMGLK  Bug 141301, Increased the size of key_refs. TYPE Transformed_Lu_Key_Rec,    Set_Source_Key___(),    Transform_By_Method___(),       Transform_By_Record___()
--  180404  LoPrlk  Merged: Bug 140499, Modified Transform_By_Method___(), Get_Transformed_Lu_Key_List(), Get_Next_From_Key_List(), Get_Client_Hit_Count(),
--                  Get_Key_Refs() to change some variable data types and method return types from VARCHAR2 to CLOB.
--  -------------------------------------------------------------------------
--  170105  LoPrlk  Bug 133073, Altered the method Get_Editable_Lu_Name to consider only active records.
--  160907  SADELK  STRSA-9753, Modified Get_CS_All_Columns() to have a longer variables for all columns.
--  160809  BAKALK  STRSA-9316, Existing rules are not set back to being active by register method now
--  160712  BAKALK  STRSA-7327, Added a check to see if derived source object does really exist replacing previous solution.
--  160512  SADELK  Bug 128773, Modified Set_Key_By_Position___() to work object connection transformation for functional object IDs with equal sign.
--  160510  LoPrlk  Bug 127928, Altered the method Check_Common___.
--  160425  MAATLK  STRMF-4049, Merged LCS Patch 128727.
--  160425          160420  MAATLK  Bug 128727, Modified the method Get_Transformed_Lu_Key_List() to handle exception block.
--  150706  Dinklk  Bug 121349, Modified Add_To_Source_Key_Ref_List() to set record_sep_ (Client_SYS.record_separator_) instead of hard coding CHR(29).
--  150702  BAKALK  Bug 122506, One-one relation has been broken, fixed
--  150626  BAKALK  Bug 122506, Further issues found and fixed them
--  150526  BAKALK  Bug 122506, Fixed the issue that target lu and source lu with one-many relation do not get transformed objects
--  150415  INMALK  Bug 121899, Modified Get_Transformed_Lu_Key_List() to give out the error message and Validate_Transformation___() to get the correct iterator
--  141208  Maabse  PRSC-4550, Added public Format_LU_Key_Ref
--  140801  JuPelk  PRMF-1304, Merged LCS patch 114551.
--  140801          140131  RaNhlk  Bug 114551, Modified Transform_By_Record___() to call Object_Connection_SYS.Replace_Client_Values to replace client values in key ref.
--  140423  ARWILK  PBSA-3535: Merged LCS 113723 (the code is added through PBSA-5082)
--  131129  JAGRNO  Hooks: Refactored and split code. Removed bug tags. Modified attribute
--                  ACTIVE to become not mandatory, and instead handling default values.
--                  Modified method Validate_Flags___ to match with new template code.
--  130910  CHANLK  Model errors corrected.
--  130904  BJSASE  Enabled transformation of records for the same logical unit
--  130828  ARWILK  Bug 111940, Modified Get_Transformed_Lu_Key_List so that it returns null when no active transformations exist.
--  130624  NRATLK  Bug 110811, Modified Get_Target_Lu() to improve performance.
--  130418  ARWILK  Bug 109413, Added two new functions Generate_Where_Stmt, LU_Has_Editable_Rule.
--  130308  ErSrLK  Bug 108032, Modified Get_Transformed_Lu_Key_List(), added check if source_key_ref_ is not null
--  130308          because source_key_ref_ will be null if Source LU is not installed/deployed.
--  130215  AMCHLK  Bug 107974, Added new column "Modified Date" into OBJ_CONNECT_LU_TRANSFORM_TAB table.
--  130202  AMCHLK  Bug 107974, Added two columns "Modified By" and "System Defined"  into OBJ_CONNECT_LU_TRANSFORM_TAB table.
--  121009  INMALK  Bug 93429, Added ifs_assert_safe annotation
--  120706  ErSrLK  Bug 103874, Added procedure Add_To_Source_Key_Ref_List() and increased the variable size
--  120706          of source_key_ref and places it has been used, to VARCHAR2 32000.
--  120626  LoPrlk  Bug: 103203, Added the method Get_Target_Lu.
--  120402  MDAHSE  Add Is_Currently_Transformed and Get_Transformed_Key_Ref.
--  120401  BJSASE  EASTRTM-8488, Changed Get_Transformed_Lu_Key_List to always include target LU.
--  120202  MAANLK  SMA-1680, Removed obsolete private methods.
--  120201  MAANLK  SMA-1661, Added new method Test_Transformation.
--  120131  MAANLK  SMA-1653, Added new method Get_CS_All_Columns.
--  120131  MAANLK  SMA-1599, Added new methods Get_CS_Key_Columns, Get_Lu_And_Service_Names,
--  120131          Get_Service_List and Get_Lu_Names_For_Service. Modified Prepare_Insert___.
--  110711  LoPrlk  Issue: SADEAGLE-773, Altered the method Transform_By_Method___.
--  110328  KAYOLK  Added Row Key to required views.
--  110304  BJSASE  Added Get_Client_Hit_Count
--  110222  BJSASE  Added Skip Validation Check
--  100601  BJSASE  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Transformed_Lu_Key_Rec IS RECORD
   (src_lu_name         VARCHAR2(30),
    trans_src_lu_name   VARCHAR2(2000),
    key_ref             VARCHAR2(24000),
    read_only           VARCHAR2(5));

TYPE Transformed_Lu_Key_Tbl IS TABLE OF Transformed_Lu_Key_Rec INDEX BY BINARY_INTEGER;

TYPE Service_Name_Rec IS RECORD (
   lu_name           OBJECT_CONNECTION_SYS_TAB.lu_name%TYPE,
   service_list      OBJECT_CONNECTION_SYS_TAB.service_list%TYPE);

TYPE Service_Name_Arr IS TABLE OF Service_Name_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------

field_sep_ CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;
record_sep_ CONSTANT VARCHAR2(1) := Client_SYS.record_separator_;
text_sep_ CONSTANT VARCHAR2(1) := Client_SYS.text_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ACTIVE_DB', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('EDITABLE_DB', 'NONE', attr_);
   Client_SYS.Add_To_Attr('EDITABLE', Obj_Connect_Lu_Edit_Type_API.Decode('NONE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     OBJ_CONNECT_LU_TRANSFORM_TAB%ROWTYPE,
   newrec_     IN OUT OBJ_CONNECT_LU_TRANSFORM_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   -- server defaults
   newrec_.modified_by := Fnd_Session_API.Get_Fnd_User;
   newrec_.modified_date := sysdate;
   Client_SYS.Add_To_Attr('MODIFIED_BY', newrec_.modified_by, attr_);
   Client_SYS.Add_To_Attr('MODIFIED_DATE', newrec_.modified_date, attr_);
   --
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     obj_connect_lu_transform_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY obj_connect_lu_transform_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   skip_validation_ BOOLEAN := FALSE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- Handle default values for empty columns
   newrec_.system_defined := nvl(newrec_.system_defined, 'FALSE');
   newrec_.active := nvl(newrec_.active, 'TRUE');
   --
   IF newrec_.source_lu_name = newrec_.target_lu_name THEN
      Client_SYS.Add_Warning(lu_name_, 'SRCSMEASTRGT: Target and Source LU are the same. This is often not what you want.');
   END IF;
   --
   skip_validation_ := Client_SYS.Item_Exist('SKIP_VALIDATION', attr_);
   IF (NOT skip_validation_) THEN
      Validate_Transformation___(newrec_.transformation_method, newrec_.target_lu_name, newrec_.source_lu_name);
      -- Specific for NEW records
      IF (newrec_.rowversion IS NULL) THEN
         Check_Connection_Aware___ (newrec_.target_lu_name, newrec_.service_name);
         Check_Connection_Aware___ (newrec_.source_lu_name, newrec_.service_name);
      END IF;
   END IF;
   IF (Is_New_Record__(oldrec_)                                                                        -- Check record has not saved already
       OR Validate_SYS.Is_Changed (oldrec_.active,                newrec_.active)
       OR Validate_SYS.Is_Changed (oldrec_.editable,              newrec_.editable)
       OR Validate_SYS.Is_Changed (oldrec_.transformation_method, newrec_.transformation_method)) THEN

      Validate_Flags___ (newrec_);
   END IF;
END Check_Common___;


PROCEDURE Transf_Column_Exists___(
   column_name_           IN VARCHAR2,
   target_lu_name_        IN VARCHAR2,
   source_lu_name_        IN VARCHAR2)
IS
   target_column_    VARCHAR2(100);
   source_column_    VARCHAR2(100);
   target_view_      VARCHAR2(30);
   source_view_      VARCHAR2(30);
   validate_         BOOLEAN := TRUE;
   start_char_       CHAR;
   end_char_         CHAR;
BEGIN
   target_column_ := Get_Target_Column_Name___(column_name_);
   target_view_ := Get_View_For_LU___(target_lu_name_);

   IF Is_Numeric___(target_column_) THEN
      validate_ := FALSE;
   END IF;

   start_char_ := REPLACE(SUBSTR(target_column_, 1, 1), '"', '''');
   end_char_ := REPLACE(SUBSTR(target_column_, LENGTH(target_column_), 1), '"', '''');
   IF  start_char_ = '!' THEN
      validate_ := FALSE;
   END IF;

   IF start_char_ = '''' AND end_char_ = '''' THEN
      validate_ := FALSE;
   END IF;

   IF validate_ AND NOT Database_SYS.Column_Exist(target_view_, target_column_) THEN
      Error_Sys.Record_General(lu_name_,
         'NOTARGETCOLUMNEXIST: The  column '':P1'' does not exist in target view '':P2''. Hint use menu option Edit Transformation.',
         target_column_, target_view_);
   END IF;

   source_column_ := Get_Source_Column_Name___(column_name_);
   source_view_ := Get_View_For_LU___(source_lu_name_);
   IF NOT Database_SYS.Column_Exist(source_view_, source_column_) THEN
      Error_Sys.Record_General(lu_name_,
         'NOCOLUMNEXIST: The column '':P1'' does not exist in source view '':P2''. Hint use menu option Edit Transformation.',
          source_column_, source_view_);
   END IF;
END Transf_Column_Exists___;


PROCEDURE Validate_Transformation___ (
   transformation_method_ IN OUT VARCHAR2,
   target_lu_name_        IN     VARCHAR2,
   source_lu_name_        IN     VARCHAR2)
IS
   num_keys_         INTEGER := 0;
   key_ref_table_    Object_Connection_SYS.KEY_REF;

BEGIN
  IF NOT Is_Existing_Method___(transformation_method_) THEN
     IF transformation_method_ IS NULL THEN
        transformation_method_ := Get_CS_Key_Columns(source_lu_name_);
     ELSE
        transformation_method_ := TRIM(RTRIM(transformation_method_, ','));
        Set_Source_Key___(key_ref_table_, num_keys_, transformation_method_);

        IF num_keys_ = 0 THEN
           Error_SYS.Record_General(lu_name_, 'SOURCEKEYMISS: Source Transformation Keys are missing for LU :P1', source_lu_name_);
        END IF;

        FOR i IN 1..num_keys_ LOOP
           Transf_Column_Exists___ (key_ref_table_(i).NAME, target_lu_name_, source_lu_name_);
        END LOOP;
     END IF;
  END IF;
END Validate_Transformation___;


PROCEDURE Validate_Flags___ (
   lurec_     IN OBJ_CONNECT_LU_TRANSFORM_TAB%ROWTYPE )
IS
   CURSOR check_flags (
      editable_ IN VARCHAR2,
      objid_    IN VARCHAR2 ) IS
    SELECT 1
    FROM OBJ_CONNECT_LU_TRANSFORM_TAB
    WHERE (objid_ IS NULL OR rowid != objid_)
    AND target_lu_name = lurec_.target_lu_name
    AND service_name = lurec_.service_name
    AND ((editable = 'SOURCE') OR
         (editable = 'TARGET') AND editable_ = 'SOURCE')
    AND (active = 'TRUE' OR (active = 'FALSE' AND system_defined = 'TRUE' ));
   dummy_      NUMBER;
   objid_      VARCHAR2(20) := NULL;
   objversion_ VARCHAR2(2000);
BEGIN
   IF lurec_.editable != 'NONE' THEN
      IF (lurec_.rowversion IS NOT NULL) THEN
         Get_Id_Version_By_Keys___(objid_, objversion_, lurec_.target_lu_name, lurec_.source_lu_name, lurec_.service_name);
      END IF;
      OPEN check_flags(lurec_.editable, objid_);
      FETCH check_flags INTO dummy_;
      IF check_flags%FOUND THEN
         CLOSE check_flags;
         Error_SYS.Record_General( lu_name_, 'SEVERALUNITSENABLED: Only one logical unit can be setup as edit allowed for object connections.');
      END IF;
      CLOSE check_flags;
   END IF;
END Validate_Flags___;


PROCEDURE Format_Transform_Method___ (
   package_                  OUT VARCHAR2,
   method_                   OUT VARCHAR2,
   transformation_method_ IN     VARCHAR2 )
IS
   index_         INTEGER := 0;
BEGIN
   index_ := INSTR(transformation_method_, CHR(46));
   IF (index_ > 1) THEN
      package_ := SUBSTR(transformation_method_, 0, index_ -1);
      method_ := SUBSTR(transformation_method_, index_ +1);
   END IF;
END Format_Transform_Method___ ;


PROCEDURE Set_Key_By_Position___(
    key_ref_table_      IN OUT Object_Connection_SYS.KEY_REF,
    num_keys_           IN OUT INTEGER,
    is_value_           IN     BOOLEAN,
    source_key_ref_     IN     VARCHAR2,
    position_           IN     INTEGER,
    length_             IN     INTEGER)
IS
   temp_      VARCHAR2(1000);
BEGIN
   IF length_ > 0 AND position_ > 0 AND LENGTH(source_key_ref_) > position_ THEN
      temp_ := TRIM(SUBSTR(source_key_ref_, position_, length_));
      num_keys_ := num_keys_ + 1;
      IF is_value_ THEN
         temp_ := REPLACE(temp_, text_sep_, '');
         key_ref_table_(num_keys_).VALUE := temp_;
      ELSE
         temp_ := REPLACE(temp_, ',', '');
         key_ref_table_(num_keys_).NAME := temp_;
      END IF;
   END IF;
END Set_Key_By_Position___;


PROCEDURE Set_Source_Key___ (
   key_ref_table_      IN OUT Object_Connection_SYS.KEY_REF,
   num_keys_           IN OUT INTEGER,
   key_transformation_ IN     VARCHAR2 )
IS
   counter_         INTEGER := 1;
   position_        INTEGER := 0;
   old_position_    INTEGER := 0;
   source_keys_     VARCHAR2(32000);
BEGIN
   source_keys_     :=  key_transformation_ || ',';
   position_ := INSTR(source_keys_, ',', 1, counter_);
   WHILE position_ > 0
   LOOP
      Set_Key_By_Position___( key_ref_table_,
                              num_keys_,
                              FALSE,
                              source_keys_,
                              old_position_ +1,
                              position_ - old_position_);
      old_position_ := position_;
      position_ := INSTR(source_keys_, ',', 1, counter_);
      counter_ := counter_ +1;
   END LOOP;
END Set_Source_Key___;


PROCEDURE Check_Connection_Aware___ (
   logical_unit_     IN VARCHAR2,
   service_name_     IN VARCHAR2)
IS
BEGIN
   IF NOT Object_Connection_SYS.Is_Connection_Aware(logical_unit_, service_name_) THEN
      Error_SYS.Record_General(
        lu_name_,
        'NOTCONAWARE: The Logical Unit '':P1'' is not set as connection aware for service '':P2.''',
        logical_unit_,
        service_name_);
   END IF;
END Check_Connection_Aware___;


FUNCTION Build_Select_Statement___(
    target_view_        IN VARCHAR2,
    key_ref_table_      IN Object_Connection_SYS.KEY_REF,
    num_keys_           IN INTEGER) RETURN VARCHAR2
IS
   sep_         VARCHAR2(5) := '||''' || text_sep_ || '''';
   sep_next_    VARCHAR2(2) := '||';
   name_        VARCHAR2(100);
   stmt_        VARCHAR2(1000) := 'SELECT ';
BEGIN
   FOR i IN 1..num_keys_ LOOP
      name_ := Get_Target_Column_Name___( key_ref_table_(i).NAME);
      name_ := REPLACE(name_, '"', '''');
      IF ((REGEXP_INSTR(name_,'[([:digit:].,)]') = 0) AND (SUBSTR(name_, 0, 1) != '''' OR SUBSTR(name_, LENGTH(name_)) != '''')) THEN
         Assert_SYS.Assert_Is_View_Column(target_view_, LTRIM(name_, '!'));
      END IF;
      stmt_ := stmt_ || LTRIM(name_, '!') || sep_ ;
      IF i < num_keys_ THEN
         stmt_ := stmt_ || sep_next_;
      END IF;
   END LOOP;
   RETURN stmt_;
END Build_Select_Statement___;


FUNCTION Run_And_Get_Statement___ (
   target_view_           IN VARCHAR2,
   target_key_ref_        IN VARCHAR2,
   select_statement_      IN VARCHAR2 ) RETURN VARCHAR2
IS
  tok_key_ref_   Object_Connection_SYS.Key_Ref;

  stmt_          VARCHAR2(2000);
  result_        VARCHAR2(1000);

  num_keys_      NUMBER;
  dummy_         NUMBER;
  cursor_        NUMBER;
BEGIN
  Object_Connection_SYS.Tokenize_Key_Ref__ ( target_key_ref_, tok_key_ref_, num_keys_ );

  -- Create the sql statement
  Assert_SYS.Assert_Is_View(target_view_);
  stmt_ := select_statement_|| ' FROM ' || target_view_ || ' WHERE ';
  FOR key_counter_  IN 1..num_keys_ LOOP
     Assert_SYS.Assert_Is_View_Column(target_view_, tok_key_ref_( key_counter_ ).NAME);
     stmt_ := stmt_ || tok_key_ref_( key_counter_ ).NAME || ' = :bindval' || key_counter_;
     IF key_counter_ < num_keys_ THEN
        stmt_ := stmt_ || ' AND ';
     END IF;
  END LOOP;

  cursor_ := dbms_sql.open_cursor;
  @ApproveDynamicStatement(2012-10-09,inmalk)
  dbms_sql.parse (cursor_, stmt_, dbms_sql.native);
  dbms_sql.define_column ( cursor_, 1, result_, 1000);

  -- Bind variables
  FOR key_counter_ IN 1..num_keys_ LOOP
     Bind_Var_To_Cursor___(cursor_ => cursor_,
                           bind_var_ => 'bindval' || key_counter_,
                           view_name_ => target_view_,
                           keyref_item_ => tok_key_ref_(key_counter_));
  END LOOP;

  dummy_ := dbms_sql.execute ( cursor_ );
  dummy_ := dbms_sql.fetch_rows ( cursor_ );
  dbms_sql.column_value ( cursor_, 1, result_ );
  dbms_sql.close_cursor ( cursor_ );

  RETURN result_;
EXCEPTION
     WHEN NO_DATA_FOUND THEN
        RETURN NULL;
     WHEN OTHERS THEN
        IF (dbms_sql.is_open(cursor_)) THEN
           dbms_sql.close_cursor( cursor_ );
        END IF;
        Trace_SYS.Put_Line('Unexpected error when running select statement '':P1''.', stmt_);
        Error_Sys.Record_General(lu_name_, 'TRANSERR: Unexpected error '':P1'' when transforming connections FOR target view '':P2''.',
           SUBSTR(SQLERRM,1,200), target_view_);
        RETURN NULL;
END Run_And_Get_Statement___;


PROCEDURE Bind_Var_To_Cursor___ (
   cursor_      IN NUMBER,
   bind_var_    IN VARCHAR2,
   view_name_   IN VARCHAR2,
   keyref_item_ IN Object_Connection_SYS.KEY_REF_PAIR )
IS
   db_data_type_  VARCHAR2(100) := NULL;
   success_       BOOLEAN := FALSE;
   value_         VARCHAR2(1000);
   dt_value_      DATE;
   ts_value_      TIMESTAMP;
   no_value_      NUMBER;
BEGIN
   BEGIN
      SELECT data_type
         INTO   db_data_type_
         FROM   user_tab_columns
         WHERE  table_name  = view_name_
         AND    column_name = keyref_item_.name;
   EXCEPTION
      WHEN no_data_found THEN
         db_data_type_ := NULL;
   END;

   value_ := keyref_item_.value;
   IF db_data_type_ = 'DATE' THEN
      BEGIN
         dt_value_ := to_date(value_, Client_SYS.date_format_);
         success_  := TRUE;
      EXCEPTION
         WHEN OTHERS THEN
            success_  := FALSE;
      END;

      IF NOT success_ THEN
         BEGIN
            dt_value_ := to_date(value_);
            success_  := TRUE;
         EXCEPTION
            WHEN OTHERS THEN
               success_  := FALSE;
         END;
      END IF;

      IF NOT success_ THEN
         -- If the last try to convert fails, let the exception to fire.
         dt_value_ := to_date(value_, Client_SYS.trunc_date_format_);
      END IF;

      dbms_sql.bind_variable(cursor_, bind_var_, dt_value_);
   ELSIF INSTR(db_data_type_, 'TIMESTAMP') != 0 THEN
      BEGIN
         ts_value_ := to_timestamp(value_, Client_SYS.timestamp_format_);
         success_  := TRUE;
      EXCEPTION
         WHEN OTHERS THEN
            success_  := FALSE;
      END;

      IF NOT success_ THEN
         BEGIN
            ts_value_ := to_timestamp(value_, Client_SYS.date_format_);
            success_  := TRUE;
         EXCEPTION
            WHEN OTHERS THEN
               success_  := FALSE;
         END;
      END IF;

      IF NOT success_ THEN
         BEGIN
            ts_value_ := to_timestamp(value_);
            success_  := TRUE;
         EXCEPTION
            WHEN OTHERS THEN
               success_  := FALSE;
         END;
      END IF;

      IF NOT success_ THEN
         -- If the last try to convert fails, let the exception to fire.
         ts_value_ := to_timestamp(value_, Client_SYS.trunc_date_format_);
      END IF;

      dbms_sql.bind_variable(cursor_, bind_var_, ts_value_);
   ELSIF db_data_type_ = 'FLOAT' OR db_data_type_ = 'NUMBER' THEN
      no_value_ := to_number(value_);
      dbms_sql.bind_variable(cursor_, bind_var_, no_value_);
   ELSE
      -- If the value_ is not identified specifically, it will be treated as VRCHAR2.
      dbms_sql.bind_variable(cursor_, bind_var_, value_);
   END IF;
END Bind_Var_To_Cursor___;


FUNCTION Get_View_For_LU___ (lu_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   view_name_   VARCHAR2(30);
   temp_        VARCHAR2(1000);
BEGIN
   Object_Connection_SYS.Get_Configuration_Properties(view_name_, temp_, temp_,temp_, lu_name_);
   RETURN view_name_;
END Get_View_For_LU___;


FUNCTION Format_LU_Key_Ref___ (
   source_lu_name_        IN VARCHAR2,
   source_key_ref_        IN VARCHAR2,
   read_only_             IN BOOLEAN) RETURN VARCHAR2
IS
   message_          VARCHAR2(2000);
   trans_lu_name_    VARCHAR2(2000);
   read_only_str_    VARCHAR2(5) := 'FALSE';
BEGIN
   IF read_only_ THEN
      read_only_str_ := 'TRUE';
   END IF;
   trans_lu_name_ := Object_Connection_SYS.Get_Logical_Unit_Description(source_lu_name_);
   message_ := Message_Sys.Construct('OCULT');
   Message_SYS.Add_Attribute(message_, 'SOURCE_LU_NAME', source_lu_name_);
   Message_SYS.Add_Attribute(message_, 'TRANS_SOURCE_LU_NAME', trans_lu_name_);
   Message_SYS.Add_Attribute(message_, 'READ_ONLY', read_only_str_);

   RETURN message_ || field_sep_ || source_key_ref_ ||record_sep_;
END Format_LU_Key_Ref___ ;


FUNCTION Transform_By_Method___ (
   service_name_          IN VARCHAR2,
   target_key_ref_        IN VARCHAR2,
   source_lu_name_        IN VARCHAR2,
   transformation_method_ IN VARCHAR2 ) RETURN CLOB
IS
   source_key_ref_     CLOB;
   stmt_               VARCHAR2(32000);
BEGIN

   Assert_SYS.Assert_Is_Package_Method(transformation_method_);
   stmt_ := 'BEGIN :source_key_ref_ := '||transformation_method_||'(:TargetKeyRef, :ServiceName); END;';

   @ApproveDynamicStatement(2011-07-11,LoPrlk)
   EXECUTE IMMEDIATE stmt_
   USING OUT source_key_ref_,
         IN  target_key_ref_,
         IN  service_name_;

   RETURN source_key_ref_;
END Transform_By_Method___ ;


   FUNCTION Transform_By_Record___ (
   target_lu_name_        IN VARCHAR2,
   target_key_ref_        IN VARCHAR2,
   source_lu_name_        IN VARCHAR2,
   key_transformation_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   source_key_ref_  VARCHAR2(32000);
   select_stmt_     VARCHAR2(32000);
   result_          VARCHAR2(1000);
   target_view_     VARCHAR2(30);
   source_view_     VARCHAR2(30);
   source_column_   VARCHAR2(100);
   counter_         INTEGER := 1;
   position_        INTEGER := 0;
   old_position_    INTEGER := 0;
   num_keys_        INTEGER := 0;
   num_values_      INTEGER := 0;
   key_ref_table_   Object_Connection_SYS.KEY_REF;
BEGIN
   target_view_ := Get_View_For_LU___(target_lu_name_);
   source_view_ := Get_View_For_LU___(source_lu_name_);

   Set_Source_Key___(key_ref_table_, num_keys_, key_transformation_);

   select_stmt_ := Build_Select_Statement___(target_view_, key_ref_table_, num_keys_);
   -- IMPORTANT NOTE: Kindly refrain from modifying "select_stmt_" and simply pass along the returned value from Build_Select_Statement___ into Run_And_Get_Statement___
   result_ := Run_And_Get_Statement___ (target_view_, target_key_ref_, select_stmt_);

   -- Loop result
   old_position_ := 0;
   counter_ := 1;
   position_ := INSTR(result_, text_sep_, 1, counter_);

   FOR i IN 1..num_keys_ LOOP
      Set_Key_By_Position___( key_ref_table_, num_values_, TRUE,
         result_, old_position_ +1, position_ - old_position_);
      old_position_ := position_;
      counter_ := counter_ +1;
      position_ := INSTR(result_, text_sep_, 1, counter_);
   END LOOP;

   -- check if soruce record really exists: bakalk
   IF NOT Check_Source_Record_Exist___(key_ref_table_, num_keys_, source_view_) THEN
      RETURN NULL;
   END IF;

   -- Build Source Key Ref
   FOR i IN 1..num_keys_  LOOP
      source_column_ := Get_Source_Column_Name___(key_ref_table_(i).NAME);
      source_key_ref_ := source_key_ref_ || source_column_|| '=';
      source_key_ref_ :=  source_key_ref_ || key_ref_table_(i).VALUE || text_sep_;
   END LOOP;
   RETURN Object_Connection_SYS.Replace_Client_Values(source_lu_name_, source_key_ref_);
END Transform_By_Record___;


FUNCTION Transform_Key_Ref___ (
   lu_rec_            IN OBJ_CONNECT_LU_TRANSFORM_TAB%ROWTYPE,
   target_key_ref_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF NOT Object_Connection_SYS.Is_Connection_Aware(lu_rec_.source_lu_name, lu_rec_.service_name) THEN
      RETURN NULL;
   END IF;

   IF Is_Existing_Method___(lu_rec_.transformation_method) THEN
      RETURN Transform_By_Method___ (lu_rec_.service_name,
                                     target_key_ref_,
                                     lu_rec_.source_lu_name,
                                     lu_rec_.transformation_method);
   END IF;
   RETURN Transform_By_Record___(lu_rec_.target_lu_name,
                                    target_key_ref_,
                                    lu_rec_.source_lu_name,
                                    lu_rec_.transformation_method);
END Transform_Key_Ref___;


FUNCTION Get_Lu_For_Obj_Connection___ (
   target_lu_name_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_lu IS
    SELECT DECODE(editable, 'SOURCE', source_lu_name, target_lu_name) source_lu_name
    FROM OBJ_CONNECT_LU_TRANSFORM_TAB
    WHERE target_lu_name = target_lu_name_
    AND service_name = service_name_
    AND editable != 'NONE'
    AND active = 'TRUE';
   source_lu_name_    OBJ_CONNECT_LU_TRANSFORM_TAB.source_lu_name%TYPE;
BEGIN
   OPEN get_lu;
   FETCH get_lu INTO source_lu_name_;
   IF get_lu%FOUND THEN
      RETURN source_lu_name_;
   END IF;
   CLOSE get_lu;
   RETURN NULL;
END Get_Lu_For_Obj_Connection___;


FUNCTION Get_Target_Column_Name___ (
   column_name_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF INSTR(column_name_, '=') > 1 THEN
      RETURN SUBSTR(column_name_, INSTR(column_name_, '=')+1);
   END IF;
   RETURN UPPER(column_name_);
END Get_Target_Column_Name___;


FUNCTION Get_Source_Column_Name___ (
   column_name_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF INSTR(column_name_, '=') > 1 THEN
      RETURN SUBSTR(column_name_, 0, INSTR(column_name_, '=')-1);
   END IF;
   RETURN UPPER(column_name_);
END Get_Source_Column_Name___;


FUNCTION Is_Numeric___ (
   value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_  INTEGER := 0;
   CURSOR check_number IS
    SELECT 1
    FROM dual
    WHERE regexp_like(value_,'[([:digit:].,)]{'||decode(substr((value_),1,1),'-',
          nvl(length(value_)-1,0),length(value_))||',}','i');
BEGIN
   OPEN check_number;
   FETCH check_number INTO dummy_ ;
   CLOSE check_number;
   RETURN NVL(dummy_, 0) = 1;
END Is_Numeric___;


FUNCTION Is_Existing_Method___ (
   transformation_method_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   package_            VARCHAR2(30);
   method_             VARCHAR2(30);
BEGIN
   Format_Transform_Method___(package_, method_, transformation_method_);
   IF package_ IS NOT NULL AND method_ IS NOT NULL THEN
      IF Database_SYS.Method_Exist(package_, method_) THEN
         RETURN TRUE;
      END IF;
   END IF;
   RETURN FALSE;
END Is_Existing_Method___;

FUNCTION Check_Source_Record_Exist___ (
   key_ref_table_  IN Object_Connection_SYS.KEY_REF,
   num_keys_       IN INTEGER,
   source_view_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER;
   cursor_         NUMBER;
   source_column_  VARCHAR2(100);
   stmt_           VARCHAR2(2000);
   result_         VARCHAR2(1000);

BEGIN
   Assert_SYS.Assert_Is_View(source_view_);
   stmt_ := 'SELECT count(*) FROM ' || source_view_ || ' WHERE ';
   FOR key_counter_  IN 1..num_keys_ LOOP
      source_column_ := Get_Source_Column_Name___(key_ref_table_( key_counter_ ).NAME);
      Assert_SYS.Assert_Is_View_Column(source_view_, source_column_);
      stmt_ := stmt_ || source_column_ || ' = :bindval' || key_counter_;
      IF key_counter_ < num_keys_ THEN
         stmt_ := stmt_ || ' AND ';
      END IF;
   END LOOP;

   cursor_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2016-07-12,bakalk)
   dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
   dbms_sql.define_column( cursor_, 1, result_, 1000);

   -- Bind variables
   FOR key_counter_ IN 1..num_keys_ LOOP
     dbms_sql.bind_variable(cursor_, 'bindval' || key_counter_, key_ref_table_( key_counter_ ).VALUE);
   END LOOP;

   dummy_ := dbms_sql.execute( cursor_ );
   dummy_ := dbms_sql.fetch_rows( cursor_ );
   dbms_sql.column_value( cursor_, 1, result_ );
   dbms_sql.close_cursor( cursor_ );

   IF result_ = '1' THEN
      RETURN TRUE;
   END IF;

   RETURN FALSE;
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cursor_)) THEN
         dbms_sql.close_cursor( cursor_ );
      END IF;
      RETURN FALSE;

   END Check_Source_Record_Exist___;


-- Check whether a given record exists or not
FUNCTION Is_New_Record__(
      oldrec_ IN obj_connect_lu_transform_tab%ROWTYPE) RETURN BOOLEAN
IS
BEGIN

   RETURN (oldrec_.rowkey IS NULL AND oldrec_.rowversion IS NULL);
END Is_New_Record__;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Transform_Object_Connection (
   lu_name_ IN OUT VARCHAR2,
   key_ref_ IN OUT VARCHAR2,
   service_ IN VARCHAR2 DEFAULT 'DocReferenceObject')
IS
   save_on_lu_name_  VARCHAR2(100);
BEGIN
   IF Obj_Connect_Lu_Transform_API.Is_Currently_Transformed(lu_name_, service_) = 'TRUE' THEN
      save_on_lu_name_ := NVL(Obj_Connect_LU_Transform_API.Get_Editable_Lu_Name(lu_name_, service_), lu_name_ || 'This Will Never Match');
      IF save_on_lu_name_ != lu_name_ THEN
         IF key_ref_ IS NOT NULL THEN
            key_ref_  := Obj_Connect_LU_Transform_API.Get_Transformed_Key_Ref(lu_name_, save_on_lu_name_, service_, key_ref_);
         ELSE
            Obj_Connect_Lu_Transform_API.Exist(lu_name_, save_on_lu_name_, service_);
         END IF;
         lu_name_  := save_on_lu_name_;
      END IF;
   END IF;
END Transform_Object_Connection;

@UncheckedAccess
FUNCTION Get_Transformed_Lu_Key_List (
   target_lu_name_   IN VARCHAR2,
   key_ref_          IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN CLOB
IS
   CURSOR loop_source  IS
    SELECT *
    FROM OBJ_CONNECT_LU_TRANSFORM_TAB
    WHERE target_lu_name = target_lu_name_
    AND service_name = service_name_
    AND active = 'TRUE';

   key_ref_list_        CLOB;
   source_key_ref_      VARCHAR2(32000);
   target_read_only_    BOOLEAN := TRUE;
   read_only_           BOOLEAN := FALSE;
   counter_             INTEGER := 0;
   sub_rec_             VARCHAR2(32000);
   sub_rec_start_       NUMBER;
   sub_rec_end_         NUMBER;
BEGIN
   FOR rec_ IN loop_source LOOP
      counter_ := counter_ + 1;
      source_key_ref_ := Transform_Key_Ref___ (rec_, key_ref_);

      -- Check if source_key_ref_ is not null coz it is null if sourceLU is not installed/deployed or no source is found
      IF source_key_ref_ IS NOT NULL THEN
         IF Message_SYS.Is_Message(source_key_ref_) THEN
            key_ref_list_ := key_ref_list_ || source_key_ref_;
         ELSE
                           sub_rec_start_ := 1;
            sub_rec_end_   := 1;
            read_only_ := rec_.editable != 'SOURCE';
            -- Extract each sub-record from the source key ref
            LOOP
               IF sub_rec_start_ > LENGTH(source_key_ref_) THEN -- when record separator included at the end of source_key_ref_ : bakalk
                 EXIT;
               END IF;
               sub_rec_end_ := INSTR(source_key_ref_, record_sep_, sub_rec_start_);
               IF sub_rec_end_ = 0 THEN
                  sub_rec_ := SUBSTR(source_key_ref_, sub_rec_start_);
                   ELSE
                  sub_rec_ := SUBSTR(source_key_ref_, sub_rec_start_, (sub_rec_end_ - sub_rec_start_));
               END IF;
               key_ref_list_ := key_ref_list_ || Format_LU_Key_Ref___( rec_.source_lu_name, sub_rec_, read_only_);
               EXIT WHEN sub_rec_end_ = 0;
               sub_rec_start_ := sub_rec_end_ + 1;
            END LOOP;
         END IF;
      END IF;

      IF rec_.editable = 'TARGET' THEN
         target_read_only_ := FALSE;
      END IF;
   END LOOP;
   IF counter_ = 0 THEN
      target_read_only_ := FALSE; -- OCULT not used;
   END IF;

   -- Returns an empty string if no active transformation is found for target and service
   RETURN key_ref_list_;
EXCEPTION
   WHEN OTHERS THEN
      IF (Error_SYS.Is_Foundation_Error(SQLCODE)) THEN
         RAISE;
      ELSIF SQLCODE IN (-4061, -4065, -4068) THEN -- Don't catch these exceptions.
         RAISE;
      ELSE
         Error_SYS.Record_General(lu_name_, 'OBJTRANSERROR: There is an error in an Object Connection Transformation associated with the LU :P1 for the service :P2. Please check the following error: ' || SQLERRM, target_lu_name_, service_name_);
      END IF;
END Get_Transformed_Lu_Key_List;

@UncheckedAccess
FUNCTION Format_LU_Key_Ref (
   source_lu_name_        IN VARCHAR2,
   source_key_ref_        IN VARCHAR2,
   read_only_             IN BOOLEAN) RETURN VARCHAR2
IS
BEGIN
   RETURN Format_LU_Key_Ref___(source_lu_name_, source_key_ref_, read_only_);
END Format_LU_Key_Ref ;

@UncheckedAccess
FUNCTION Is_Read_Only (
   target_lu_name_ IN VARCHAR2,
   service_name_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR overriden IS
    SELECT 1
    FROM OBJ_CONNECT_LU_TRANSFORM_TAB
    WHERE target_lu_name = target_lu_name_
    AND service_name = service_name_
    AND active = 'TRUE';
   dummy_   INTEGER := 0;
BEGIN
   OPEN overriden;
   FETCH overriden INTO dummy_;
   IF overriden%NOTFOUND THEN
      CLOSE overriden;
      RETURN 'FALSE';
   END IF;
   CLOSE overriden;
   IF Get_Lu_For_Obj_Connection___ (target_lu_name_, service_name_) IS NOT NULL THEN
      RETURN 'FALSE';
   END IF;
   RETURN 'TRUE';
END Is_Read_Only;


@UncheckedAccess
FUNCTION Get_Editable_Lu_Name (
   target_lu_name_ IN VARCHAR2,
   service_name_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ OBJ_CONNECT_LU_TRANSFORM_TAB.target_lu_name%TYPE;

   CURSOR get_attr IS
      SELECT editable_lu_name
      FROM
        (SELECT
           (CASE editable
             WHEN 'TARGET' THEN target_lu_name
             WHEN 'SOURCE' THEN source_lu_name
             ELSE NULL
            END) editable_lu_name
         FROM OBJ_CONNECT_LU_TRANSFORM_TAB
         WHERE target_lu_name = target_lu_name_
         AND   service_name = service_name_
         AND   active       = Fnd_Boolean_API.DB_TRUE)
      WHERE editable_lu_name IS NOT NULL ;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Editable_Lu_Name;


FUNCTION Get_Next_From_Key_List (
   source_lu_name_             OUT VARCHAR2,
   trans_source_lu_name_       OUT VARCHAR2,
   key_ref_                    OUT CLOB,
   read_only_                  OUT VARCHAR,
   ptr_                     IN OUT NUMBER,
   key_ref_list_            IN     CLOB ) RETURN VARCHAR2
IS
   from_       NUMBER;
   to_         NUMBER;
   record_     VARCHAR2(32000);
   message_    VARCHAR2(32000);
BEGIN

   from_ := NVL(ptr_, 1);
   to_   := instr(key_ref_list_, record_sep_, from_);

   IF (to_ > 0) THEN
      record_ := SUBSTR(key_ref_list_, from_, (to_- from_));
      ptr_ := to_+1;

      to_   := instr(record_, field_sep_);
      message_ := SUBSTR(record_, 0, to_-1);
      IF NOT (Message_Sys.Is_Message(message_)) THEN
         RETURN 'FALSE';
      END IF;
      Message_SYS.Get_Attribute(message_, 'SOURCE_LU_NAME', source_lu_name_);
      Message_SYS.Get_Attribute(message_, 'TRANS_SOURCE_LU_NAME', trans_source_lu_name_);
      Message_SYS.Get_Attribute(message_, 'READ_ONLY', read_only_);
      key_ref_ := SUBSTR(record_, to_+1, LENGTH(record_)- to_ );
      RETURN 'TRUE';
   END IF;
   RETURN 'FALSE';
END Get_Next_From_Key_List;





FUNCTION Get_Client_Hit_Count(
   service_name_      IN VARCHAR2,
   lu_name_           IN VARCHAR2,
   key_ref_           IN VARCHAR2,
   view_name_         IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
  ptr_              NUMBER;
  source_lu_        VARCHAR2(2000);
  trans_source_lu_  VARCHAR2(2000);
  read_only_        VARCHAR2(30);
  source_ref_list_  CLOB;
  source_ref_       VARCHAR2(32000);
  temp_view_         VARCHAR2(30);
  count_             NUMBER := 0;
  temp_count_        NUMBER := 0;
  stmt_              VARCHAR2(2000);
BEGIN
   temp_view_ := view_name_;
  IF temp_view_ IS NULL THEN
     temp_view_ := Dictionary_Sys.Get_Base_View_Active(service_name_);
  END IF;
  source_ref_list_ := Obj_Connect_LU_Transform_API.Get_Transformed_Lu_Key_List(lu_name_, key_ref_, service_name_);

  ptr_ := NULL;
  Assert_SYS.Assert_Is_View(temp_view_);
  WHILE Obj_Connect_Lu_Transform_API.Get_Next_From_Key_List(source_lu_, trans_source_lu_, source_ref_, read_only_, ptr_, source_ref_list_) = 'TRUE' LOOP
      stmt_ :=  ' SELECT COUNT(*)
                    FROM '||temp_view_||
                  ' WHERE lu_name = :source_lu
                    AND key_ref = :source_ref';
      @ApproveDynamicStatement(2011-05-25,nukulk)
      EXECUTE IMMEDIATE stmt_ INTO temp_count_ USING source_lu_, source_ref_;
      count_ := count_ + temp_count_;
  END LOOP;
  RETURN count_;
END Get_Client_Hit_Count;


PROCEDURE Register (
   target_lu_name_          IN VARCHAR2,
   source_lu_name_          IN VARCHAR2,
   service_name_            IN VARCHAR2,
   editable_                IN VARCHAR DEFAULT 'NONE',
   transformation_method_   IN VARCHAR2 DEFAULT NULL,
   system_defined_          IN VARCHAR2 DEFAULT 'TRUE' )
IS
   CURSOR getobjid IS
      SELECT rowid
      FROM  OBJ_CONNECT_LU_TRANSFORM_TAB
      WHERE target_lu_name = target_lu_name_
      AND   source_lu_name = source_lu_name_
      AND   service_name = service_name_;

   attr_         VARCHAR2(2000);
   newrec_       OBJ_CONNECT_LU_TRANSFORM_TAB%ROWTYPE;
   oldrec_       OBJ_CONNECT_LU_TRANSFORM_TAB%ROWTYPE;
   objid_        OBJ_CONNECT_LU_TRANSFORM.objid%TYPE;
   objversion_   OBJ_CONNECT_LU_TRANSFORM.objversion%TYPE;
   indrec_       Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('TRANSFORMATION_METHOD', transformation_method_, attr_);
   Client_SYS.Add_To_Attr('EDITABLE_DB', editable_, attr_);
   Client_SYS.Add_To_Attr('SKIP_VALIDATION', 'TRUE', attr_);

   IF NOT Check_Exist___ (target_lu_name_, source_lu_name_, service_name_) THEN
      Client_SYS.Add_To_Attr('TARGET_LU_NAME', target_lu_name_, attr_);
      Client_SYS.Add_To_Attr('SOURCE_LU_NAME', source_lu_name_, attr_);
      Client_SYS.Add_To_Attr('SERVICE_NAME', service_name_, attr_);
      Client_SYS.Add_To_Attr('SYSTEM_DEFINED', system_defined_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      OPEN getobjid;
      FETCH getobjid INTO objid_;
      CLOSE getobjid;

      oldrec_ := Lock_By_Keys___(target_lu_name_, source_lu_name_, service_name_);
      newrec_ := oldrec_;
      -- Activating existing rules does not work for all
      -- Client_SYS.Add_To_Attr('ACTIVE_DB', 'TRUE', attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
END Register;


PROCEDURE Unregister (
   target_lu_name_         IN VARCHAR2,
   source_lu_name_         IN VARCHAR2,
   service_name_           IN VARCHAR2)
IS
   CURSOR getobjid IS
      SELECT rowid
      FROM  OBJ_CONNECT_LU_TRANSFORM_TAB
      WHERE target_lu_name = target_lu_name_
      AND   source_lu_name = source_lu_name_
      AND   service_name = service_name_;

   remrec_       OBJ_CONNECT_LU_TRANSFORM_TAB%ROWTYPE;
   objid_        OBJ_CONNECT_LU_TRANSFORM.objid%TYPE;
BEGIN
        IF Check_Exist___ (target_lu_name_, source_lu_name_, service_name_) THEN
      OPEN getobjid;
      FETCH getobjid INTO objid_;
      CLOSE getobjid;

      remrec_ := Lock_By_Keys___(target_lu_name_, source_lu_name_, service_name_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
END Unregister;


PROCEDURE Prepare_Transformed_Lu (
   source_lu_          OUT VARCHAR2,
   source_key_ref_     OUT VARCHAR2,
   target_lu_name_  IN     VARCHAR2,
   target_key_ref_  IN     VARCHAR2,
   service_name_    IN     VARCHAR2 )
IS
   tmp_lu_name_  OBJ_CONNECT_LU_TRANSFORM_TAB.target_lu_name%TYPE;
   lu_rec_       OBJ_CONNECT_LU_TRANSFORM_TAB%ROWTYPE;
BEGIN

        IF Is_Read_Only(target_lu_name_, service_name_) = 'FALSE' THEN
           source_lu_ := target_lu_name_;
           source_key_ref_ := target_key_ref_;

           tmp_lu_name_ := Get_Lu_For_Obj_Connection___(target_lu_name_, service_name_);
           IF tmp_lu_name_ IS NOT NULL THEN
              source_lu_ := tmp_lu_name_;
              IF tmp_lu_name_ != target_lu_name_ THEN
                 lu_rec_ := Get_Object_By_Keys___(target_lu_name_, tmp_lu_name_, service_name_);
            source_key_ref_ := Transform_Key_Ref___(lu_rec_, target_key_ref_);
         END IF;
      END IF;
   END IF;
END Prepare_Transformed_Lu;


@UncheckedAccess
FUNCTION Get_CS_Key_Columns (
   source_lu_name_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   key_columns_  VARCHAR2(1000);
   source_view_  VARCHAR2(30);

   CURSOR get_key_columns (view_ VARCHAR2) IS
      SELECT column_name
      FROM   dictionary_sys_view_column_act
      WHERE  view_name = view_
      AND    type_flag IN ('P', 'K')
      ORDER BY NLSSORT(column_name,'NLS_SORT=BINARY_AI');
BEGIN
   source_view_ := Get_View_For_LU___ (source_lu_name_);
   IF source_view_ IS NULL THEN
      RETURN NULL;
   END IF;

   FOR rec_ IN get_key_columns(source_view_) LOOP
      key_columns_ := key_columns_ || rec_.column_name || ',';
   END LOOP;
   RETURN RTRIM(key_columns_, ',');
END Get_CS_Key_Columns;


@UncheckedAccess
FUNCTION Get_CS_All_Columns (
   lu_name_   IN VARCHAR2 ) RETURN VARCHAR2
 IS
   all_columns_  VARCHAR2(32000);
   source_view_  VARCHAR2(30);

   CURSOR get_columns (view_ VARCHAR2) IS
      SELECT column_name
      FROM   dictionary_sys_view_column_act
      WHERE  view_name = view_
      ORDER BY NLSSORT(column_name,'NLS_SORT=BINARY_AI');
BEGIN
   source_view_ := Get_View_For_LU___ (lu_name_);
   IF source_view_ IS NULL THEN
      RETURN NULL;
   END IF;

   FOR rec_ IN get_columns(source_view_) LOOP
      all_columns_ := all_columns_ || rec_.column_name || ',';
   END LOOP;
   RETURN RTRIM(all_columns_, ',');
END Get_CS_All_Columns;


PROCEDURE Test_Transformation (
   error_text_          OUT VARCHAR2,
   source_key_ref_      OUT VARCHAR2,
   source_key_desc_     OUT VARCHAR2,
   target_lu_name_   IN     VARCHAR2,
   target_key_ref_   IN     VARCHAR2,
   source_lu_name_   IN     VARCHAR2,
   service_name_     IN     VARCHAR2 )
IS
   lu_rec_           OBJ_CONNECT_LU_TRANSFORM_TAB%ROWTYPE;
   transformed_key_  VARCHAR2(2000);
   dummy_            VARCHAR2(30);
   source_lu_        VARCHAR2(30);
   ptr_              NUMBER;

BEGIN

   lu_rec_ := Get_Object_By_Keys___(target_lu_name_, source_lu_name_, service_name_);

   transformed_key_ := Transform_Key_Ref___ (lu_rec_, target_key_ref_);

   IF Message_SYS.Is_Message(transformed_key_) THEN
      IF Get_Next_From_Key_List (source_lu_, dummy_, source_key_ref_, dummy_, ptr_, transformed_key_) = 'TRUE' THEN
         NULL;
      END IF;
   ELSE
      source_key_ref_ := transformed_key_;
      source_lu_ := source_lu_name_;
   END IF;

   source_key_desc_ := Object_Connection_SYS.Get_Instance_Description(
      source_lu_,
      Get_View_For_LU___(source_lu_),
      source_key_ref_);

   EXCEPTION
      WHEN OTHERS THEN
         error_text_ := SQLERRM;
END Test_Transformation;

@UncheckedAccess
PROCEDURE Get_Lu_And_Service_Names (
   lu_names_ OUT VARCHAR2,
   services_ OUT VARCHAR2 )
IS
   temp_lu_names_ VARCHAR2(32000);
   temp_services_ VARCHAR2(32000);

   CURSOR get_lu_names IS
      SELECT lu_name
      FROM  object_connection
      WHERE lu_name != '*'
      ORDER BY lu_name ASC;

   CURSOR get_services IS
      SELECT service_name
      FROM obj_connect_service_lov;
BEGIN

   FOR lu_rec_ IN get_lu_names LOOP
      temp_lu_names_ := temp_lu_names_ || lu_rec_.lu_name || '^';
   END LOOP;
   lu_names_ := RTRIM(temp_lu_names_, '^');

   FOR serv_rec_ IN get_services LOOP
      temp_services_ := temp_services_ || serv_rec_.service_name || '^';
   END LOOP;
   services_ := RTRIM(temp_services_, '^');
END Get_Lu_And_Service_Names;


@UncheckedAccess
FUNCTION Get_Service_List (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   service_list_ VARCHAR2(2000);

   CURSOR get_service IS
      SELECT service_list
      FROM   object_connection
      WHERE  lu_name = lu_name_;
BEGIN
   OPEN  get_service;
   FETCH get_service INTO service_list_;
   CLOSE get_service;

   RETURN service_list_;
END Get_Service_List;

@UncheckedAccess
FUNCTION Service_Name_Table RETURN Service_Name_Arr PIPELINED
IS
   TYPE Lu_Name_Arr IS TABLE OF OBJECT_CONNECTION_SYS_TAB.lu_name%TYPE INDEX BY BINARY_INTEGER;
   lu_table_                  Lu_Name_Arr ;
   rec_                       Service_Name_Rec;
   enum_values_               VARCHAR2(32000);
   value_table_               Utility_SYS.STRING_TABLE;
   value_count_               NUMBER;
BEGIN
   SELECT lu_name
      BULK COLLECT INTO lu_table_
      FROM OBJECT_CONNECTION_SYS_TAB;

   IF (lu_table_.count > 0) THEN
      FOR param_index_ IN lu_table_.first..lu_table_.last LOOP
         rec_.lu_name := lu_table_(param_index_);
         enum_values_ := Get_Service_List(rec_.lu_name);
          Utility_SYS.Tokenize(enum_values_, '^', value_table_, value_count_);
         IF (value_table_.count > 0) THEN
            FOR value_index_ IN value_table_.first..value_table_.last LOOP
               rec_.service_list := value_table_(value_index_);
               PIPE ROW (rec_);
            END LOOP;
         END IF;
      END LOOP;
   END IF;
   RETURN;
END Service_Name_Table;

@UncheckedAccess
FUNCTION Get_Lu_Names_For_Service (
   service_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   lu_names_ VARCHAR2(32000);
   service_condition_ VARCHAR2(102);

   CURSOR get_lu_names IS
      SELECT lu_name
      FROM  object_connection
      WHERE service_list LIKE service_condition_
      AND   lu_name != '*'
      ORDER BY lu_name ASC;
BEGIN
   service_condition_ := '%' || service_name_ || '%';

   FOR rec_ IN get_lu_names LOOP
      lu_names_ := lu_names_ || rec_.lu_name || '^';
   END LOOP;

   RETURN lu_names_;
END Get_Lu_Names_For_Service;


@UncheckedAccess
FUNCTION Is_Currently_Transformed (
   target_lu_name_ IN VARCHAR2,
   service_name_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR active_transformation_exists_ IS
    SELECT 1
    FROM OBJ_CONNECT_LU_TRANSFORM_TAB
    WHERE target_lu_name = target_lu_name_
    AND service_name = service_name_
    AND active = 'TRUE';
   dummy_   INTEGER := 0;
BEGIN
   OPEN active_transformation_exists_;
   FETCH active_transformation_exists_ INTO dummy_;
   IF active_transformation_exists_%NOTFOUND THEN
      CLOSE active_transformation_exists_;
      RETURN 'FALSE';
   END IF;
   CLOSE active_transformation_exists_;
   RETURN 'TRUE';
END Is_Currently_Transformed;


@UncheckedAccess
FUNCTION Get_Transformed_Key_Ref (
   target_lu_name_ IN VARCHAR2,
   source_lu_name_ IN VARCHAR2,
   service_name_   IN VARCHAR2,
   target_key_ref_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_record_  IS
     SELECT *
     FROM OBJ_CONNECT_LU_TRANSFORM_TAB
     WHERE target_lu_name = target_lu_name_
     AND   service_name   = service_name_
     and   source_lu_name = source_lu_name_;

   source_key_ref_      VARCHAR2(32000);
   rec_                 OBJ_CONNECT_LU_TRANSFORM_TAB%ROWTYPE;

BEGIN
   Exist(target_lu_name_, source_lu_name_, service_name_);

   OPEN get_record_;
   FETCH get_record_ INTO rec_;
   CLOSE get_record_;

   source_key_ref_ := Transform_Key_Ref___ (rec_, target_key_ref_);

   RETURN source_key_ref_;
END Get_Transformed_Key_Ref;


@UncheckedAccess
FUNCTION Get_Target_Lu (
   src_lu_name_  IN     VARCHAR2,
   key_ref_      IN     VARCHAR2,
   service_name_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
   package_    VARCHAR2(50);
   target_lu_  VARCHAR2(50) := NULL;

BEGIN
   package_ := Dictionary_SYS.Get_Base_Package_Active(src_lu_name_);
   IF (Database_Sys.Method_Exist(package_,  'GET_TARGET_LU_NAME'))THEN
      BEGIN
         @ApproveDynamicStatement(2013-06-21,nratlk)
         EXECUTE  IMMEDIATE 'BEGIN :res := ' || package_ || '.Get_Target_Lu_Name(:key_ref_, :service_name_); END;'
         USING OUT target_lu_,
            IN  key_ref_,
            IN  service_name_;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
      END;
   END IF;

   target_lu_ := NVL(target_lu_, src_lu_name_);
   RETURN target_lu_;
END Get_Target_Lu;


-- Add_To_Source_Key_Ref_List
--   CHR(29) acts as a record seperator for a key ref. Use this to concatenate
--   several key ref records that can be identified by OCULT framework.
PROCEDURE Add_To_Source_Key_Ref_List (
   source_key_list_      IN OUT CLOB,
   source_key_ref_       IN VARCHAR2 )
IS
BEGIN
   IF source_key_ref_ IS NOT NULL THEN
      source_key_list_ := source_key_list_ || source_key_ref_ || record_sep_;
   END IF;
END Add_To_Source_Key_Ref_List;


@UncheckedAccess
FUNCTION Generate_Where_Stmt (
   target_lu_name_      IN VARCHAR2,
   target_key_ref_      IN VARCHAR2,
   service_name_        IN VARCHAR2) RETURN VARCHAR2
IS
   transformed_keys_    CLOB;
   source_lu_name_      OBJ_CONNECT_LU_TRANSFORM_TAB.Source_Lu_Name%TYPE;
   source_lu_name_desc_ VARCHAR2(3200);
   source_key_ref_      VARCHAR2(32000);
   read_only_           VARCHAR2(5);
   ptr_                 NUMBER;
   where_stmt_          VARCHAR2(32000);
BEGIN
  transformed_keys_ := Get_Transformed_Lu_Key_List(target_lu_name_, target_key_ref_, service_name_);

  where_stmt_ := NULL;

  WHILE (Get_Next_From_Key_List(source_lu_name_,source_lu_name_desc_, source_key_ref_, read_only_, ptr_, transformed_keys_) = 'TRUE') LOOP
     -- Check if source_lu_name_ and source_key_ref_ do not contain SQL statements
     Assert_SYS.Assert_Is_Logical_Unit(source_lu_name_);
     --Assert_SYS.Assert_Match_Regexp(source_key_ref_, '');

     -- Assert_SYS.Encode_Single_Quote_String is used to make sure that it is not possible to end the statement (because quotes will be encoded), and insert other SQL statements.
     IF where_stmt_ IS NULL THEN
        where_stmt_ := '(LU_NAME = ''' || source_lu_name_ || ''' AND KEY_REF = ''' || Assert_SYS.Encode_Single_Quote_String(source_key_ref_) || ''')';
     ELSE
        where_stmt_ := where_stmt_ || ' OR (LU_NAME = ''' || source_lu_name_ || ''' AND KEY_REF = ''' || Assert_SYS.Encode_Single_Quote_String(source_key_ref_) || ''')';
     END IF;
  END LOOP;
  RETURN where_stmt_;
END Generate_Where_Stmt;

@UncheckedAccess
FUNCTION LU_Has_Editable_Rule (
   target_lu_name_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER := 0;
   CURSOR check_lu_defined IS
      SELECT 1
      FROM OBJ_CONNECT_LU_TRANSFORM_TAB t
      WHERE t.target_lu_name = target_lu_name_
      AND t.service_name = service_name_;

   CURSOR check_lu_editable IS
      SELECT 1
      FROM OBJ_CONNECT_LU_TRANSFORM_TAB t
      WHERE t.target_lu_name = target_lu_name_
      AND t.service_name = service_name_
      AND t.editable != 'NONE';
BEGIN
   OPEN check_lu_defined;
   FETCH check_lu_defined INTO dummy_;

   -- IF any OCULT reules are defined for the TargetLu and ServiceName combination the check if any one of those
   -- rules have Editable != 'None'
   IF (check_lu_defined%FOUND) THEN
      CLOSE check_lu_defined;
      OPEN check_lu_editable;
      FETCH check_lu_editable INTO dummy_;
      IF (check_lu_editable%FOUND) THEN
         CLOSE check_lu_editable;
         RETURN 'TRUE';
      END IF;
      CLOSE check_lu_editable;
      RETURN 'FALSE';
   END IF;

   RETURN 'TRUE';
EXCEPTION
   WHEN OTHERS THEN
        IF (check_lu_defined%ISOPEN) THEN
           CLOSE check_lu_defined;
        END IF;

        IF (check_lu_editable%ISOPEN) THEN
           CLOSE check_lu_editable;
        END IF;
     END LU_Has_Editable_Rule;

@UncheckedAccess
FUNCTION Get_Key_Refs (
   target_lu_      IN VARCHAR2,
   target_key_ref_ IN VARCHAR2,
   service_        IN VARCHAR2) RETURN Transformed_Lu_Key_Tbl
IS
   rec_                       Transformed_Lu_Key_Rec;
   ret_                       Transformed_Lu_Key_Tbl; -- := Transformed_Lu_Key_Tbl();
   count_                     NUMBER := 1;

   list_                      CLOB;
   ptr_                       NUMBER;
   source_lu_name_            VARCHAR2(30);
   trans_source_lu_name_      VARCHAR2(2000);
   key_ref_                   CLOB;
   read_only_                 VARCHAR2(5);
BEGIN
   rec_.src_lu_name       := target_lu_;
   rec_.trans_src_lu_name := Object_Connection_SYS.Get_Logical_Unit_Description(target_lu_);
   rec_.key_ref           := target_key_ref_;
   rec_.read_only         := 'FALSE';
   ret_(count_) := rec_;
   count_ := count_ + 1;

   list_ := Get_Transformed_Lu_Key_List(target_lu_, target_key_ref_, service_);

   ptr_ := NULL;
   WHILE Get_Next_From_Key_List(source_lu_name_, trans_source_lu_name_, key_ref_, read_only_, ptr_, list_) = 'TRUE' LOOP
      rec_.src_lu_name       := source_lu_name_;
      rec_.trans_src_lu_name := trans_source_lu_name_;
      rec_.key_ref           := key_ref_;
      rec_.read_only         := read_only_;
      ret_(count_) := rec_;
      count_ := count_ + 1;
   END LOOP;

   RETURN ret_;
END Get_Key_Refs;

PROCEDURE Change_Target_Lu (
   old_target_lu_name_   IN VARCHAR2,
   new_target_lu_name_       IN VARCHAR2 )
IS
   CURSOR get_target_lu IS
         SELECT *
         FROM  obj_connect_lu_transform_tab
         WHERE target_lu_name = old_target_lu_name_;

BEGIN
   FOR obj_conn_ IN get_target_lu LOOP
      Obj_Connect_Lu_Transform_API.Unregister(obj_conn_.target_lu_name, obj_conn_.source_lu_name, obj_conn_.service_name);
      IF ( NOT Obj_Connect_Lu_Transform_API.Exists(new_target_lu_name_, obj_conn_.source_lu_name, obj_conn_.service_name)) THEN
         Obj_Connect_Lu_Transform_API.Register(new_target_lu_name_,
                                               obj_conn_.source_lu_name,
                                               obj_conn_.service_name,
                                               obj_conn_.editable, obj_conn_.transformation_method ,
                                               obj_conn_.system_defined );
      END IF;
   END LOOP;
END Change_Target_Lu;

PROCEDURE Change_Source_Lu (
   old_source_lu_name_   IN VARCHAR2,
   new_source_lu_name_       IN VARCHAR2 )
IS
   CURSOR get_source_lu IS
         SELECT *
         FROM  obj_connect_lu_transform_tab
         WHERE source_lu_name = old_source_lu_name_;

BEGIN
   FOR obj_conn_ IN get_source_lu LOOP
      Obj_Connect_Lu_Transform_API.Unregister(obj_conn_.target_lu_name, obj_conn_.source_lu_name, obj_conn_.service_name);
      IF ( NOT Obj_Connect_Lu_Transform_API.Exists(obj_conn_.target_lu_name, new_source_lu_name_, obj_conn_.service_name)) THEN
         Obj_Connect_Lu_Transform_API.Register(obj_conn_.target_lu_name,
                                               new_source_lu_name_,
                                               obj_conn_.service_name,
                                               obj_conn_.editable, obj_conn_.transformation_method ,
                                               obj_conn_.system_defined );
      END IF;
   END LOOP;
END Change_Source_Lu;

FUNCTION Get_View_For_Column_Name(lu_name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_View_For_LU___ (lu_name_);
END Get_View_For_Column_Name;
