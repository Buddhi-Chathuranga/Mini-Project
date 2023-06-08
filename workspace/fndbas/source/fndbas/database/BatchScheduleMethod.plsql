-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--
--  Logical unit: BatchScheduleMethod
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  021023  HAAR  Created (ToDo#4146).
--  021211  HAAR  Minor chages for translations (ToDo#4146).
--  021219  HAAR  Changes for Argument_Type (ToDo#4146).
--  030122  HAAR  Removed Exist check for Module du to fresh installation
--                problems (ToDo#4146).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030218  ROOD  Changed hardcoded FNDSER to FNDBAS (ToDo#4149).
--  030819  ROOD  Removed access control on Is_Method_Available__ (ToDo#4160).
--  040331  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  040426  HAAR  Added Po_Id and Create_Presentation_Object___ for Presentation Object security (F1PR419).
--  040507  HAAR  Changed Export__ and Register__ to handle new parameter storage (F1PR419).
--  040512  HAAR  Removed New_Batch_Schedule_Method__ and Modify_Batch_Schedule_Method__ (F1PR419).
--  040512  HAAR  Removed attribute Parameters (F1PR419).
--  040524  HAAR  Added method Execute_Online__ (F1PR419).
--  040614  HAAR  Added view Batch_Schedule_Report_Method (F1PR419B).
--  040705  ROOD  Changed some calls to Dictionary_SYS to use Design_SYS instead (F1PR413).
--  041202  HAAR  Added column Validation_method and Validate_Parameters__ (F1PR419).
--  050411  JORA  Added assertion for dynamic SQL.  (F1PR481)
--  050516  HAAR  Added validation method to Presentation Object (F1PR419).
--  051010  RAKU  Remade method Get_Validation_Method__ from being an impl-method (F1PR419).
--  060106  UTGULK Annotated Sql injection.
--  060524  HAAR  Added check of system privilege DEFINE SQL (F1PR447).
--  061113  HAAR  Possible to use Module_API.Exist again during Insert (Bug#61809).
--  061218  HAAR  Remove check against Module_API.Exist again during Insert (Bug#61809).
--  061227  HAAR  Possible to use Module_API.Exist again during Insert (Bug#62523).
--  070212  NiWi  Modified Export__(Bug#63435).
--  080630  HAAR  Added support for Scheduled Task Sequences (Bug#72846).
--  080911  JOWISE  Modified Prepare_Insert (Bug#72846).
--  080911  JOWISE  Added the new attributes in Export__ (Bug#72846).
--  081128  HAAR  Method without parameter is not possible to register (Bug#78889).
--  091130  DUWI  Added procedure Remove_Method__ (Bug#85225).
--  140309  USRA  Modified [Export__] to include a COMMIT (TEBASE-70).
--  141128  CHMULK Modifying Method_Arguments__ and Method_Exist___. (Bug#119168/TEBASE-768)
-----------------------------------------------------------------------------


layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
FUNCTION Check_Exist___ (
   schedule_method_id_ IN     NUMBER ) RETURN BOOLEAN
IS
BEGIN
   --Add pre-processing code here
   RETURN super(schedule_method_id_) OR Batch_Schedule_Chain_API.Exists(schedule_method_id_);
END Check_Exist___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('SINGLE_EXECUTION_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SINGLE_EXECUTION', Fnd_Boolean_API.Decode('FALSE'), attr_);
   Client_SYS.Add_To_Attr('ARGUMENT_TYPE_DB', 'PARAMETER', attr_);
   Client_SYS.Add_To_Attr('ARGUMENT_TYPE', Argument_Type_API.Decode('PARAMETER'), attr_);
   Client_SYS.Add_To_Attr('CHECK_EXECUTING_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('CHECK_EXECUTING', Fnd_Boolean_API.Decode('FALSE'), attr_);
   Client_SYS.Add_To_Attr('CHECK_DAY_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('CHECK_DAY', Fnd_Boolean_API.Decode('FALSE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT BATCH_SCHEDULE_METHOD_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   --  Check if method exists
   IF ( NOT Method_Exist___( newrec_.method_name ) ) THEN
      Error_SYS.Record_General('BatchScheduleMethod', 'METHNOTEX: Method [:P1] does not exist in database.', newrec_.method_name );
   END IF;
   -- Check security
   IF Is_Method_Available__(newrec_.method_name) = 'FALSE' THEN
      Error_SYS.Record_General('BatchScheduleMethod', 'SEC_INS: Method [:P1] must exist to be able to create a new batch schedule.', newrec_.method_name );
   END IF;
   -- Check security for Validation method
   IF (newrec_.validation_method IS NOT NULL AND
       Is_Method_Available__(newrec_.validation_method) = 'FALSE') THEN
      Error_SYS.Record_General('BatchScheduleMethod', 'SEC_INS: Method [:P1] must exist to be able to create a new batch schedule.', newrec_.validation_method );
   END IF;
   --
   IF newrec_.schedule_method_id IS NULL THEN
      SELECT schedule_method_id_seq.NEXTVAL
      INTO   newrec_.schedule_method_id
      FROM   dual;
   END IF;
   -- Add Presentation Object
   newrec_.po_id := Create_Presentation_Object___ (newrec_.description,
                                                   newrec_.method_name,
                                                   newrec_.validation_method,
                                                   newrec_.module);
   newrec_.method_name := upper(newrec_.method_name);
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('SCHEDULE_METHOD_ID', newrec_.schedule_method_id, attr_);
   -- Add translations
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     BATCH_SCHEDULE_METHOD_TAB%ROWTYPE,
   newrec_     IN OUT BATCH_SCHEDULE_METHOD_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   IF ( NOT Method_Exist___( newrec_.method_name ) ) THEN
      Error_SYS.Record_General('BatchScheduleMethod', 'METHNOTEX: Method [:P1] does not exist in database.', newrec_.method_name );
   END IF;
   -- Check security
   IF Is_Method_Po_Available__(newrec_.method_name, newrec_.po_id) = 'FALSE' THEN
      Error_SYS.Record_General('BatchScheduleMethod', 'SEC_UPD: Must have the right to execute method [:P1] to be able to create a new batch schedule.', newrec_.method_name );
   END IF;
   -- Check security for Validation method
   IF (newrec_.validation_method IS NOT NULL AND
       Is_Method_Available__(newrec_.validation_method) = 'FALSE') THEN
      Error_SYS.Record_General('BatchScheduleMethod', 'SEC_INS: Method [:P1] must exist to be able to create a new batch schedule.', newrec_.validation_method );
   END IF;
   newrec_.method_name := upper(newrec_.method_name);
   -- Add Presentation Object
   newrec_.po_id := Create_Presentation_Object___ (newrec_.description,
                                                   newrec_.method_name,
                                                   newrec_.validation_method,
                                                   newrec_.module);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Return schedule_method_id_
   Client_SYS.Add_To_Attr('SCHEDULE_METHOD_ID', newrec_.schedule_method_id, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN BATCH_SCHEDULE_METHOD_TAB%ROWTYPE )
IS
BEGIN
   Batch_Schedule_Method_API.Remove_Basic_Data_Translation(remrec_);
   super(objid_, remrec_);
   -- Remove if already there
   Pres_Object_Util_API.Remove_Pres_Object(remrec_.po_id, 'Manual');
END Delete___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     batch_schedule_method_tab%ROWTYPE,
   newrec_ IN OUT batch_schedule_method_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (NOT Installation_SYS.Get_Installation_Mode) THEN
      Module_API.Check_Active(newrec_.module);
   END IF;
END Check_Common___;




-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Create_Presentation_Object___ (
   description_          IN VARCHAR2,
   method_name_          IN VARCHAR2,
   validation_method_    IN VARCHAR2,
   module_               IN VARCHAR2 ) RETURN VARCHAR2
IS
   po_id_          VARCHAR2(200)   := 'task'||InitCap( method_name_);
   po_description_ VARCHAR2(250)   := 'Task - '||Substr(description_, 1, 230);
   pkg_            VARCHAR2(30)    := Upper(substr(method_name_, 1, instr(method_name_, '.')-1));
   met_            VARCHAR2(30)    := replace(initcap(replace(substr(method_name_, instr(method_name_, '.')+1), '_', ' ')), ' ', '_');
   sec_object_     VARCHAR2(100)   := pkg_||'.'||met_;
   pkg2_           VARCHAR2(30);
   met2_           VARCHAR2(30);
   sec_object2_    VARCHAR2(100);
BEGIN
   -- Remove if already there
   Pres_Object_Util_API.Remove_Pres_Object(po_id_, 'Manual');
   -- Create presentation object
   Pres_Object_Util_API.New_Pres_Object(po_id_, module_, 'OTHER', po_description_, 'Manual');
   -- Method_Name
   Pres_Object_Util_API.New_Pres_Object_Sec(po_id_, sec_object_, 'METHOD', '2', 'Manual');
   -- Validation_Method
   IF validation_method_ IS NOT NULL THEN
      pkg2_        := Upper(substr(validation_method_, 1, instr(validation_method_, '.')-1));
      met2_        := replace(initcap(replace(substr(validation_method_, instr(validation_method_, '.')+1), '_', ' ')), ' ', '_');
      sec_object2_ := pkg2_||'.'||met2_;
      Pres_Object_Util_API.New_Pres_Object_Sec(po_id_, sec_object2_, 'METHOD', '2', 'Manual');
   END IF;
   RETURN(po_id_);
END Create_Presentation_Object___;

FUNCTION Method_Exist___ (
   method_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   object_name_  VARCHAR2(30);
   method_name2_ VARCHAR2(30);
BEGIN
   --
   object_name_  := UPPER(substr(method_name_, 1, instr(method_name_, '.') - 1));
   method_name2_ := UPPER(substr(method_name_, instr(method_name_, '.') + 1 ));
   --
   RETURN Method_Exist___(object_name_, method_name2_);
END Method_Exist___;

FUNCTION Method_Exist___ (
   package_ IN VARCHAR2,
   method_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF Installation_SYS.Get_Installation_Mode THEN
      RETURN Database_SYS.Method_Exist(package_, method_);
   ELSE
      RETURN Database_SYS.Method_Active(package_, method_);
   END IF;
END Method_Exist___;

@UncheckedAccess
FUNCTION Get_Basic_Data_Translation (
   schedule_method_id_ IN NUMBER,
   method_name_ IN VARCHAR2,
   single_execution_ IN VARCHAR2,
   description_ IN VARCHAR2,
   module_ IN VARCHAR2,
   argument_type_ IN VARCHAR2,
   po_id_ IN VARCHAR2,
   validation_method_ IN VARCHAR2,
   check_executing_ IN VARCHAR2,
   check_day_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Return(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, Dictionary_SYS.Get_Logical_Unit(Substr(method_name_, 1, Instr(method_name_, '.')-1), 'PACKAGE'),method_name_||'^'||'DESCRIPTION',NULL));
END Get_Basic_Data_Translation;


PROCEDURE Insert_Basic_Data_Translation (
   newrec_ IN batch_schedule_method_tab%ROWTYPE )
IS
   lu_name_ VARCHAR2(30) := Dictionary_SYS.Get_Logical_Unit(Substr(newrec_.method_name, 1, Instr(newrec_.method_name, '.')-1), 'PACKAGE');
BEGIN
   -- Insert Basic Data Translation
   Basic_Data_Translation_API.Insert_Basic_Data_Translation(newrec_.module,
                                                            lu_name_,
                                                            newrec_.method_name||'^'||'DESCRIPTION',
                                                            NULL,
                                                            newrec_.description);
END Insert_Basic_Data_Translation;


PROCEDURE Remove_Basic_Data_Translation (
   remrec_ IN batch_schedule_method_tab%ROWTYPE )
IS 
   method_name_ VARCHAR2(200):= Get_Method_Name(remrec_.schedule_method_id);
   lu_name_     VARCHAR2(30) := Dictionary_SYS.Get_Logical_Unit(Substr(method_name_, 1, Instr(method_name_, '.')-1), 'PACKAGE');
BEGIN
   -- Remove translations
   Basic_Data_Translation_API.Remove_Basic_Data_Translation (remrec_.module, lu_name_, method_name_||'^'||'DESCRIPTION');
END Remove_Basic_Data_Translation;

FUNCTION Get(
   schedule_method_id_        IN NUMBER,
   skip_module_active_check_  IN BOOLEAN ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (schedule_method_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   IF skip_module_active_check_ THEN
      SELECT schedule_method_id, rowid, rowversion, rowkey,
             method_name, 
             single_execution, 
              substr(nvl(Batch_Schedule_Method_API.Get_Basic_Data_Translation(schedule_method_id, method_name, single_execution, description, module, argument_type, po_id, validation_method, check_executing, check_day), description), 1, 200), 
             module, 
             argument_type, 
             po_id, 
             check_executing, 
             check_day
         INTO  temp_
         FROM  batch_schedule_method_tab
         WHERE schedule_method_id = schedule_method_id_;
      RETURN temp_;
   ELSE
      RETURN Get(schedule_method_id_);
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(schedule_method_id_, 'Get');
END Get;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Execute_Online__ (
   schedule_method_id_ IN NUMBER,
   arguments_          IN VARCHAR2 DEFAULT NULL )
IS
   rec_   Batch_Schedule_Method_API.Public_Rec;
BEGIN
   -- Check if registered method
   Exist(schedule_method_id_);
   rec_ := Get(schedule_method_id_);
   Transaction_SYS.Dynamic_Call(rec_.method_name, rec_.argument_type, arguments_);
END Execute_Online__;

FUNCTION Export_Blob__ (
   schedule_method_id_ IN  NUMBER ) RETURN BLOB
IS
   string_ VARCHAR2(32000);
BEGIN
      Batch_Schedule_Method_API.Export__(string_, schedule_method_id_);
      RETURN utl_raw.Cast_To_Raw(string_);
END Export_Blob__;
   
FUNCTION Export_Xml__ (
   schedule_method_id_ IN  NUMBER ) RETURN BLOB 
IS
   string_ VARCHAR2(32000);
   rec_    BATCH_SCHEDULE_METHOD_TAB%ROWTYPE;

BEGIN
   rec_     := Get_Object_By_Keys___(schedule_method_id_);

   SELECT XMLELEMENT("DATABASE_TASK", 
            XMLELEMENT("METHOD_NAME", rec_.method_name),
            XMLELEMENT("DESCRIPTION", rec_.DESCRIPTION),
            XMLELEMENT("MODULE", rec_.MODULE),
            XMLELEMENT("SINGLE_EXECUTION", rec_.SINGLE_EXECUTION),
            XMLELEMENT("ARGUMENT_TYPE", rec_.ARGUMENT_TYPE),
            XMLELEMENT("VALIDATION_METHOD", rec_.VALIDATION_METHOD),
            XMLELEMENT("CHECK_EXECUTING", rec_.CHECK_EXECUTING),
            XMLELEMENT("CHECK_DAY", rec_.CHECK_DAY),
         (SELECT  XMLELEMENT("PARAMETERS", XMLAGG(XMLELEMENT("PARAMETER", 
                  XMLFOREST(seq_no, NAME, mandatory, 
                  data_type, default_expression, VALUE)))) 
         FROM batch_schedule_method_par_tab
         WHERE schedule_method_id = schedule_method_id_)).getStringVal() 
         INTO string_
         FROM dual;
    RETURN utl_raw.Cast_To_Raw(string_);  
END Export_Xml__;
   
PROCEDURE Export__ (
   string_             OUT VARCHAR2,
   schedule_method_id_ IN  NUMBER )
IS
   newline_    CONSTANT VARCHAR2(2) := chr(13)||chr(10);
   value_               VARCHAR2(2000);
   default_expression_  VARCHAR2(2000);
   rec_                 BATCH_SCHEDULE_METHOD_TAB%ROWTYPE;
   CURSOR get_parameter IS
      SELECT seq_no, name, mandatory, data_type, default_expression, value
      FROM   Batch_Schedule_Method_Par_Tab
      WHERE  schedule_method_id = schedule_method_id_;
BEGIN
   rec_     := Get_Object_By_Keys___(schedule_method_id_);
   --
   -- Create Export file
   --
   string_ :=            '-------------------------------------------------------------------------------------------- ' || newline_;
   string_ := string_ || '-- Export file for Task ' || rec_.method_name || '.' || newline_;
   string_ := string_ || '-- ' || newline_;
   string_ := string_ || '--  Date    Sign    History' || newline_;
   string_ := string_ || '--  ------  ------  -----------------------------------------------------------' || newline_;
   string_ := string_ || '--  ' || to_char(sysdate, 'YYMMDD') || '  ' || rpad(Fnd_Session_API.Get_Fnd_User, 6, ' ') || '  ' ||
                         'Export file for task ' || rec_.method_name || '.' || newline_;
   string_ := string_ || '-------------------------------------------------------------------------------------------- ' || newline_;
   string_ := string_ || newline_;
   string_ := string_ || 'PROMPT Register Batch Schedule Method "' || rec_.method_name || '"' || newline_;
   string_ := string_ || 'DECLARE' || newline_;
   string_ := string_ || '   schedule_method_id_ NUMBER          := NULL;' || newline_;
   string_ := string_ || '   seq_no_             NUMBER          := NULL;' || newline_;
   string_ := string_ || '   info_msg_           VARCHAR2(32000) := NULL;' || newline_;
   string_ := string_ || 'BEGIN' || newline_;
   --
   -- Create Main Message
   --
   string_ := string_ || '-- Construct Main Message' || newline_;
   string_ := string_ || '   info_msg_    := Message_SYS.Construct('''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''METHOD_NAME'', ''' || rec_.method_name || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''DESCRIPTION'', ''' || rec_.description || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''MODULE'', ''' || rec_.module || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''SINGLE_EXECUTION_DB'', ''' || rec_.single_execution || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''ARGUMENT_TYPE_DB'', ''' || rec_.argument_type || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''VALIDATION_METHOD'', ''' || rec_.validation_method || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''CHECK_EXECUTING_DB'', ''' || rec_.check_executing || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''CHECK_DAY_DB'', ''' || rec_.check_day || ''');' || newline_;
   string_ := string_ || '-- Register Batch Schedule Method' || newline_;
   string_ := string_ || '   Batch_SYS.Register_Batch_Schedule_Method(schedule_method_id_, info_msg_);' || newline_;
   --
   -- Add parameters
   --
   string_ := string_ || '-- Adding parameters' || newline_;
   FOR rec2 IN get_parameter LOOP
      CASE rec2.data_type
      WHEN 'STRING' THEN
         IF rec2.value IS NULL THEN
            value_ := 'to_char(NULL)';
         ELSE
            value_ := '''' || rec2.value || '''';
         END IF;
      WHEN 'DATE' THEN
         IF rec2.value IS NULL THEN
            value_ := 'to_date(NULL)';
         ELSIF INSTR(UPPER(rec2.value),'SYSDATE')>0 THEN
            value_ := '''#SYSDATEEXP#'|| rec2.value||'''';
         ELSE
            value_ := 'to_date(''' || rec2.value || ''',''' || Client_SYS.Date_Format_ || ''')';
         END IF;
      WHEN 'NUMBER' THEN
         IF rec2.value IS NULL THEN
            value_ := 'to_number(NULL)';
         ELSE
            value_ := rec2.value;
         END IF;
      ELSE
         value_ := 'NULL';
      END CASE;
      IF rec2.default_expression IS NULL THEN
         default_expression_ := 'NULL';
      ELSE
         default_expression_ := '''' || rec2.default_expression || '''';
      END IF;
      string_ := string_ || '   Batch_SYS.Register_Schedule_Method_Param(seq_no_, schedule_method_id_, ''' || rec2.name || ''', ' || value_ || ', ''' || rec2.mandatory || ''', ' || default_expression_ || ');' || newline_;
   END LOOP;
   string_ := string_ || 'END;' || newline_;
   string_ := string_ || '/' || newline_;
   string_ := string_ || 'COMMIT' || newline_;
   string_ := string_ || '/' || newline_;
END Export__;

@UncheckedAccess
FUNCTION Get_Validation_Method__ (
   schedule_method_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ BATCH_SCHEDULE_METHOD_TAB.validation_method%TYPE;
   CURSOR get_attr IS
      SELECT validation_method
      FROM BATCH_SCHEDULE_METHOD_TAB
      WHERE schedule_method_id = schedule_method_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Validation_Method__;


@UncheckedAccess
FUNCTION Is_Method_Available__ (
   method_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   package_  VARCHAR2(50) := upper(substr(method_name_, 1, instr(method_name_, '.') - 1));
   method_   VARCHAR2(50) := upper(substr(method_name_, instr(method_name_, '.') + 1));
BEGIN
   IF Method_Exist___(package_, method_) THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Is_Method_Available__;

@UncheckedAccess
FUNCTION Is_Method_Po_Available__ (
   method_name_      IN VARCHAR2,
   pres_object_id_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   package_  VARCHAR2(50) := upper(substr(method_name_, 1, instr(method_name_, '.') - 1));
   method_   VARCHAR2(50) := upper(substr(method_name_, instr(method_name_, '.') + 1));
BEGIN
   IF NOT Method_Exist___(package_, method_) THEN
      RETURN('FALSE');
   END IF;
   
   IF Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User) THEN
      RETURN('TRUE');
   ELSIF Security_SYS.Is_Pres_Object_Available(pres_object_id_) THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Is_Method_Po_Available__;


PROCEDURE Method_Arguments__ (
   msg_         OUT VARCHAR2,
   method_name_ IN VARCHAR2 )
IS
   package_name_  VARCHAR2(30)    := upper(substr(method_name_, 1, instr(method_name_, '.')-1));
   object_name_   VARCHAR2(30)    := upper(substr(method_name_, instr(method_name_, '.')+1, length(method_name_)));
   TYPE arg_arr IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
   arguments_      arg_arr;
   data_types_     arg_arr;
   in_out_         arg_arr;
   
   invalid_datatype  EXCEPTION;
   invalid_parameter EXCEPTION;
BEGIN
   msg_ := Message_SYS.Construct('ARGUMENTS');
   SELECT argument_name,
       CASE nvl(data_type, 'NO_PARAMETER')
          WHEN 'VARCHAR2' THEN
             'STRING'
          WHEN 'NUMBER' THEN
             'NUMBER'
          WHEN 'DATE' THEN
             'DATE'
          WHEN 'NO_PARAMETER' THEN
             'NO PARAMETER'
          ELSE
             'UNKNOWN'
       END data_type, in_out
   BULK COLLECT INTO arguments_, data_types_, in_out_
   FROM   user_arguments
   WHERE  package_name = package_name_
   AND    object_name  = object_name_
   ORDER BY position;
   --
   FOR i IN nvl(arguments_.FIRST, 0)..nvl(arguments_.LAST, 0) LOOP -- Let it loop and handle the exception
      IF (data_types_(i) = 'NO PARAMETER') THEN
         NULL;
      ELSIF (data_types_(i) != 'UNKNOWN') THEN
         Message_SYS.Add_Attribute(msg_, arguments_(i), data_types_(i));
      ELSE
         RAISE invalid_datatype; -- We can only handle VARCHAR2, DATE and NUMBER data types.
      END IF;
      IF (in_out_(i) != 'IN') THEN
         RAISE invalid_parameter; -- We can not handle IN OUT or OUT parameters, neither functions
      END IF;
   END LOOP;
EXCEPTION
   WHEN no_data_found THEN
      IF NOT Method_Exist___(package_name_, object_name_) THEN
         Error_SYS.Record_General('BatchScheduleMethod', 'ARGUMENTS: This method does not exist [:P1].', method_name_ );
      -- ELSE, the method is there but there are no arguments (Oracle 12.1.0.2 onwards) 
      END IF;
   WHEN invalid_datatype THEN
      Error_SYS.Record_General('BatchScheduleMethod', 'DATATYPE: This method [:P1] has a parameter with an unsupported data type. Only String, Number and Date data types are handled.', method_name_);
   WHEN invalid_parameter THEN
      Error_SYS.Record_General('BatchScheduleMethod', 'PARAMETERS: Method [:P1] is a function or has parameters that are not supported. Only IN parameters are supported.', method_name_ );
END Method_Arguments__;

@UncheckedAccess
FUNCTION Parameters_Has_Expressions__ (
   schedule_method_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_expression IS
      SELECT 'TRUE'
      FROM   batch_schedule_method_par_tab
      WHERE  default_expression IS NOT NULL
      AND    schedule_method_id = schedule_method_id_;

   return_value_ VARCHAR2(5) := 'FALSE';
BEGIN
   OPEN get_expression;
   FETCH get_expression INTO return_value_;
   CLOSE get_expression;
   RETURN(return_value_);
END Parameters_Has_Expressions__;

PROCEDURE Register__ (
   schedule_method_id_ IN OUT NUMBER,
   info_msg_           IN     VARCHAR2 )
IS
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     BATCH_SCHEDULE_METHOD_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   objrec_.schedule_method_id := schedule_method_id_;
   objrec_.method_name := Message_SYS.Find_Attribute(info_msg_, 'METHOD_NAME', '');
   Client_SYS.Add_To_Attr('DESCRIPTION',         Message_SYS.Find_Attribute(info_msg_, 'DESCRIPTION', ''), attr_);
   Client_SYS.Add_To_Attr('SINGLE_EXECUTION_DB', Message_SYS.Find_Attribute(info_msg_, 'SINGLE_EXECUTION_DB', 'FALSE'), attr_);
   Client_SYS.Add_To_Attr('CHECK_DAY_DB',        Message_SYS.Find_Attribute(info_msg_, 'CHECK_DAY_DB', 'FALSE'), attr_);
   Client_SYS.Add_To_Attr('CHECK_EXECUTING_DB',  Message_SYS.Find_Attribute(info_msg_, 'CHECK_EXECUTING_DB', 'FALSE'), attr_);
   Client_SYS.Add_To_Attr('ARGUMENT_TYPE_DB',    Message_SYS.Find_Attribute(info_msg_, 'ARGUMENT_TYPE_DB', ''), attr_);
   Client_SYS.Add_To_Attr('VALIDATION_METHOD',   Message_SYS.Find_Attribute(info_msg_, 'VALIDATION_METHOD', ''), attr_);
   --
   -- Check if method already exists in table
   --
   IF schedule_method_id_ IS NULL THEN
      objrec_.schedule_method_id := Get_Schedule_Method_Id(objrec_.method_name);
   ELSE
      IF Check_Exist___ (schedule_method_id_) THEN
         Error_SYS.Appl_General(lu_name_, 'DUPLICATE: The Batch Schedule Method [:P1] already exists.', Message_SYS.Find_Attribute(info_msg_, 'METHOD_NAME', ''));
      ELSE
         objrec_.schedule_method_id := schedule_method_id_;
      END IF;
   END IF;
   -- Remove the parameters if they exists
   Batch_Schedule_Method_API.Remove_Parameters__(objrec_.schedule_method_id);
   --
   Get_Id_Version_By_Keys___ (objid_, objversion_, objrec_.schedule_method_id);
   Client_SYS.Add_To_Attr('MODULE',      Message_SYS.Find_Attribute(info_msg_, 'MODULE', ''), attr_);
   IF objrec_.schedule_method_id IS NULL THEN
      Client_SYS.Add_To_Attr('METHOD_NAME', objrec_.method_name, attr_);
      New__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      Modify__ (info_, objid_, objversion_, attr_, 'DO');
   END IF;
   -- Return Schedule_Method_Id
   schedule_method_id_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SCHEDULE_METHOD_ID', attr_));
END Register__;

PROCEDURE Remove_Parameters__ (
   schedule_method_id_ IN NUMBER )
IS
BEGIN
   DELETE FROM batch_schedule_method_par_tab
   WHERE  schedule_method_id = schedule_method_id_;
END Remove_Parameters__;

PROCEDURE Validate_Parameters__ (
   schedule_method_id_ IN NUMBER,
   msg_ IN VARCHAR2 )
IS
   method_name_ VARCHAR2(100) := Get_Validation_Method__(schedule_method_id_);
BEGIN
   Assert_SYS.Assert_Is_Procedure(method_name_);
   @ApproveDynamicStatement(2006-01-06,utgulk)
   EXECUTE IMMEDIATE 'BEGIN ' || method_name_ || '(:msg); END;' using msg_;
END Validate_Parameters__;

PROCEDURE Remove_Method__(
   method_name_ VARCHAR2)
IS
  info_       VARCHAR2(2000);
  objid_      VARCHAR2(2000);
  objversion_ VARCHAR2(2000);
  schedule_method_id_ NUMBER;
BEGIN
  schedule_method_id_ := Get_Schedule_Method_Id(method_name_);
  IF schedule_method_id_ IS NOT NULL THEN
     -- Remove the parameters
     Remove_Parameters__(schedule_method_id_);
     -- Remove the method
     Get_Id_Version_By_Keys___(objid_, objversion_, schedule_method_id_);
     Remove__(info_, objid_, objversion_, 'DO');  
  END IF;  
END Remove_Method__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Schedule_Method_Id (
   method_name_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ BATCH_SCHEDULE_METHOD_TAB.schedule_method_id%TYPE;
   CURSOR get_attr IS
      SELECT schedule_method_id
      FROM   BATCH_SCHEDULE_METHOD_TAB
      WHERE  method_name = Upper(method_name_);
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Schedule_Method_Id;

FUNCTION Get_Po_Id_For_Method(
   method_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ BATCH_SCHEDULE_METHOD_TAB.po_id%TYPE;
   CURSOR get_attr IS
      SELECT po_id
      FROM   BATCH_SCHEDULE_METHOD_TAB
      WHERE  method_name = Upper(method_name_);
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Po_Id_For_Method;

@UncheckedAccess
FUNCTION Get_Method_Name(
   schedule_method_id_  IN NUMBER,
   skip_module_check_   IN BOOLEAN ) RETURN VARCHAR2
IS
   temp_ batch_schedule_method_tab.method_name%TYPE;
BEGIN
   IF (schedule_method_id_ IS NULL OR NOT skip_module_check_) THEN
      RETURN Get_Method_Name(schedule_method_id_);
   END IF;
   SELECT method_name
      INTO  temp_
      FROM  batch_schedule_method_tab
      WHERE schedule_method_id = schedule_method_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(schedule_method_id_, 'Get_Method_Name');
END Get_Method_Name;

@UncheckedAccess
FUNCTION Get_Module(
   schedule_method_id_  IN NUMBER,
   skip_module_check_   IN BOOLEAN ) RETURN VARCHAR2
IS
   temp_ batch_schedule_method_tab.module%TYPE;
BEGIN
   IF (schedule_method_id_ IS NULL OR NOT skip_module_check_) THEN
      RETURN Get_Module(schedule_method_id_);
   END IF;
   SELECT module
      INTO  temp_
      FROM  batch_schedule_method_tab
      WHERE schedule_method_id = schedule_method_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(schedule_method_id_, 'Get_Module');
END Get_Module;

@UncheckedAccess
FUNCTION Get_Po_Id(
   schedule_method_id_  IN NUMBER,
   skip_module_check_   IN BOOLEAN) RETURN VARCHAR2
IS
   temp_ batch_schedule_method_tab.po_id%TYPE;
BEGIN
   IF (schedule_method_id_ IS NULL OR NOT skip_module_check_) THEN
      RETURN Get_Po_Id(schedule_method_id_);
   END IF;
   SELECT po_id
      INTO  temp_
      FROM  batch_schedule_method_tab
      WHERE schedule_method_id = schedule_method_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(schedule_method_id_, 'Get_Po_Id');
END Get_Po_Id;


@UncheckedAccess
FUNCTION Get_Method_Name(
   schedule_method_id_                 IN NUMBER,
   skip_module_check_if_install_mode_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF skip_module_check_if_install_mode_ = 'TRUE' THEN
      RETURN Get_Method_Name(schedule_method_id_, Installation_SYS.Get_Installation_Mode);
   ELSE
      RETURN Get_Method_Name(schedule_method_id_);
   END IF;
END Get_Method_Name;

@UncheckedAccess
FUNCTION Get_Po_Id(
   schedule_method_id_                 IN NUMBER,
   skip_module_check_if_install_mode_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF skip_module_check_if_install_mode_ = 'TRUE' THEN
      RETURN Get_Po_Id(schedule_method_id_, Installation_SYS.Get_Installation_Mode);
   ELSE
      RETURN Get_Po_Id(schedule_method_id_);
   END IF;
END Get_Po_Id;
