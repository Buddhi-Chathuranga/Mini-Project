-----------------------------------------------------------------------------
--
--  Logical unit: FndEventParameter
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971030  ERFO    Created for Foundation1 2.0.0.
--  971127  ERFO    Simplified code when refreshing parameter info.
--  980223  ERFO    Increased size of id_type from 6 to 20 and added validation
--                  of parameter types in method Create_Param (ToDo #2143).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030317  ROOD    Replaced General_SYS.Put_Line with Trace_SYS.Put_Line (ToDo#4143).
--  040216  ASWI    Removed Trace_SYS.Put_Line in Find_Param__(Bug#42328)
--  070212  HAAR    Added support for Custom Defined Events (Bugg#61780).
--  080925  HAAR    Renamed parameters for Custom Defined Events (Bug#77334).
--                  New value: NEW:COLUMN_NAME => NEW:IDENTITY
--                  Old value: OLD:COLUMN_NAME => OLD:IDENTITY
--  081015  HASPLK  Added validation on custom paramter names, not to have ':' in name. (Bug#76991)
--  100224  NABA    Applied changes to Get_Fnd_Event_Parameters__ to improve its performance (Bug#88905)
--  110728  ChMu    Added method Get_Parameter_Id_Type. (Bug#96259) 
--  120717  USRA    Changed FND_EVENT_PARAMETER_SPECIAL to use views instead of the method. (Bug#102958
--  191025  PABNLK  PACCS-2255: 'Get_Current_Value', 'Get_New_Value', 'Get_Data_Type' methods implemented.
--  191101  PABNLK  PACCS-2255: 'In Get_Data_Type' function 'temp_' variables' size modified.

-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

CURSOR get_event_parameters(xml_ Xmltype) IS
   SELECT xt1.*
     FROM dual,
          xmltable('/CUSTOM_OBJECT/CUSTOM_EVENT/EVENT_PARAMETERS/EVENT_PARAMETERS_ROW' passing xml_
                         COLUMNS
                            ID VARCHAR2(64) path 'ID',
                            ID_TYPE VARCHAR2(20) path 'ID_TYPE',
                            PLSQL_METHOD VARCHAR2(4000) path 'PLSQL_METHOD',
                            CURRENT_VALUE VARCHAR2(10) path 'CURRENT_VALUE_DB',
                            NEW_VALUE VARCHAR2(10) path 'NEW_VALUE_DB'
                        ) xt1; 

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Datatype___ (
   event_id_   IN VARCHAR2,
   id_type_    IN VARCHAR2 )
IS
BEGIN
   IF (id_type_ NOT IN ('STRING', 'NUMBER', 'DATETIME', 'DATE', 'TIME', 'CLOB', 'BLOB')) THEN
      Error_SYS.Appl_General(lu_name_, 'PARERR: Invalid parameter type ":P1" for event ":P2".', id_type_, event_id_);
   END IF;
END Check_Datatype___;


FUNCTION Convert_Datatype___ (
   id_type_    IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF id_type_ = 'VARCHAR2' THEN
      RETURN('STRING');
   END IF;
   RETURN(id_type_);
END Convert_Datatype___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FND_EVENT_PARAMETER_TAB%ROWTYPE,
   newrec_     IN OUT FND_EVENT_PARAMETER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Update all actions with parameters
   Fnd_Event_Action_API.Update_Action(newrec_.event_lu_name, newrec_.event_id, NULL); 
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN FND_EVENT_PARAMETER_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   -- Update all actions with parameters
   Fnd_Event_Action_API.Update_Action(remrec_.event_lu_name, remrec_.event_id, NULL); 
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT fnd_event_parameter_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF newrec_.current_value   = 'FALSE' AND newrec_.new_value   = 'FALSE' AND 
     newrec_.plsql_method IS NOT NULL  AND (INSTR(newrec_.id, ':') > 0 ) THEN
     Error_SYS.Record_General(lu_name_, 'INVALIDPARAM: Invalid character ":" in custom attribute ":P1"', newrec_.id);
   END IF;

END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     fnd_event_parameter_tab%ROWTYPE,
   newrec_ IN OUT fnd_event_parameter_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   newrec_.id_type := Convert_Datatype___(newrec_.id_type);
   Check_Datatype___(newrec_.event_id, newrec_.id_type);
   
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Find_Param__ (
   param_list_ IN     VARCHAR2,
   ptr_        IN OUT NUMBER,
   param_      IN OUT VARCHAR2,
   type_       IN OUT VARCHAR2 ) RETURN VARCHAR2
IS
   from_  NUMBER;
   to_    NUMBER;
   index_ NUMBER;
   record_separator_ VARCHAR2(5);
   field_separator_ VARCHAR2(5);
BEGIN
   record_separator_ := '^';
   field_separator_ := '/';
   from_ := nvl(ptr_, 1);
   to_   := instr(param_list_, record_separator_, from_);
   IF (to_ > 0) THEN
      index_ := instr(param_list_, field_separator_, from_);
      param_ := substr(param_list_, from_, index_-from_);
      type_  := substr(param_list_, index_+1, to_-index_-1);
      ptr_   := to_+ 1;
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Find_Param__;


FUNCTION Get_Fnd_Event_Parameters__ RETURN Fnd_Event_Parameters_Type PIPELINED
IS
   CURSOR get_par IS
   SELECT t2.event_lu_name, t2.event_id, t1.event_type, t2.id, t2.id_type, t2.plsql_method, t2.current_value, t2.new_value
   FROM   fnd_event_tab t1, fnd_event_parameter_tab t2
   WHERE  t1.event_lu_name = t2.event_lu_name
   AND    t1.event_id = t2.event_id;

   i_                   BINARY_INTEGER := 0;
   parameter_           Fnd_Event_Parameter_Type;
BEGIN
   FOR rec IN get_par LOOP
      IF (rec.event_type = 'CUSTOM') THEN
         IF (rec.current_value = 'TRUE') THEN
            i_ := i_ + 1;
            parameter_ := Fnd_Event_Parameter_Type(rec.event_lu_name, rec.event_id, 'OLD:'||rec.id, rec.id_type, rec.plsql_method);
            PIPE ROW(parameter_);
         END IF;
         IF (rec.new_value = 'TRUE') THEN
            i_ := i_ + 1;
            parameter_ := Fnd_Event_Parameter_Type(rec.event_lu_name, rec.event_id, 'NEW:'||rec.id, rec.id_type, rec.plsql_method);
            PIPE ROW(parameter_);
         END IF;
         IF (rec.plsql_method IS NOT NULL) THEN
            i_ := i_ + 1;
            parameter_ := Fnd_Event_Parameter_Type(rec.event_lu_name, rec.event_id, rec.id, rec.id_type, rec.plsql_method);
            PIPE ROW(parameter_);
         END IF;
      ELSE
         i_ := i_ + 1;
         parameter_ := Fnd_Event_Parameter_Type(rec.event_lu_name, rec.event_id, rec.id, rec.id_type, rec.plsql_method);
         PIPE ROW(parameter_);
      END IF;
   END LOOP;
END Get_Fnd_Event_Parameters__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2)
IS
   temp_attr_     VARCHAR2(32000) ;
   event_lu_name_ VARCHAR2(100);
   event_id_      VARCHAR2(500);
BEGIN
   temp_attr_ := attr_ ;
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      -- Update all actions with parameters
      event_lu_name_ := Client_SYS.Get_Item_Value('EVENT_LU_NAME',temp_attr_);
      event_id_ := Client_SYS.Get_Item_Value('EVENT_ID',temp_attr_);
      Fnd_Event_Action_API.Update_Action(event_lu_name_, event_id_, NULL);
      -- Event Definition is updated
      Fnd_Event_API.Update_Definition_Mod_Date_(event_lu_name_, event_id_);
      Fnd_Event_API.Create_Custom_Event_Triggers(event_lu_name_, event_id_);
   END IF;
END New__;

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ fnd_event_parameter_tab%ROWTYPE;
BEGIN
   --Add pre-processing code here
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      -- Event Definition is updated
      rec_ := Get_Object_By_Id___(objid_);
      Fnd_Event_API.Update_Definition_Mod_Date_(rec_.event_lu_name, rec_.event_id);
      Fnd_Event_API.Create_Custom_Event_Triggers(rec_.event_lu_name, rec_.event_id);      
   END IF;
END Modify__;

@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   rec_ fnd_event_parameter_tab%ROWTYPE;
BEGIN
   IF (action_ = 'DO') THEN
      rec_ := Get_Object_By_Id___(objid_);
   END IF;
   super(info_, objid_, objversion_, action_);
   IF (action_ = 'DO') THEN
      Fnd_Event_API.Update_Definition_Mod_Date_(rec_.event_lu_name, rec_.event_id);
      Fnd_Event_API.Create_Custom_Event_Triggers(rec_.event_lu_name, rec_.event_id);
   END IF;
END Remove__;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Param (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   paramlist_     IN VARCHAR2 )
IS
   ptr_     NUMBER;
   id_      VARCHAR2(100);
   id_type_ VARCHAR2(20);
BEGIN
   DELETE FROM fnd_event_parameter_tab
      WHERE event_lu_name = event_lu_name_
      AND   event_id = event_id_;
   ptr_ := NULL;
   WHILE (Find_Param__(paramlist_, ptr_, id_, id_type_) = 'TRUE' ) LOOP
      Check_Datatype___( event_id_, id_type_);
      INSERT INTO fnd_event_parameter_tab
               (event_lu_name, event_id, id, id_type, rowversion,
                plsql_method, current_value, new_value )
         VALUES
            (event_lu_name_, event_id_, id_, id_type_, SYSDATE,
             NULL, 'FALSE', 'FALSE');
   END LOOP;
END Create_Param;


PROCEDURE Create_Attachment_Parameter (
   event_lu_name_  IN VARCHAR2,
   event_id_       IN VARCHAR2,
   parameter_id_   IN VARCHAR2,
   parameter_type_ IN VARCHAR2,
   description_    IN VARCHAR2,
   filename_       IN VARCHAR2,
   attach_method_  IN VARCHAR2 )
IS
BEGIN
   DELETE FROM fnd_event_parameter_tab
      WHERE event_lu_name = event_lu_name_
      AND   event_id = event_id_
      AND   id = parameter_id_;
   Check_Datatype___( event_id_, parameter_type_);
      INSERT INTO fnd_event_parameter_tab
               (event_lu_name, event_id, id, id_type, rowversion,
                plsql_method, current_value, new_value, description, filename )
         VALUES
            (event_lu_name_, event_id_, parameter_id_, parameter_type_, SYSDATE,
             attach_method_, 'FALSE', 'FALSE', description_, filename_);
END Create_Attachment_Parameter;


PROCEDURE Delete_Param (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2 )
IS
BEGIN
   DELETE FROM fnd_event_parameter_tab
      WHERE event_lu_name = event_lu_name_
      AND event_id = event_id_;
END Delete_Param;


PROCEDURE Register (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   id_            IN VARCHAR2,
   info_msg_      IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(2000);
   newrec_     FND_EVENT_PARAMETER_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('EVENT_LU_NAME',      event_lu_name_, attr_);
   Client_SYS.Add_To_Attr('EVENT_ID',           event_id_, attr_);
   Client_SYS.Add_To_Attr('ID',                 id_, attr_);
   Client_SYS.Add_To_Attr('ID_TYPE',            Message_SYS.Find_Attribute(info_msg_, 'ID_TYPE', ''), attr_);
   Client_SYS.Add_To_Attr('PLSQL_METHOD',       Message_SYS.Find_Attribute(info_msg_, 'PLSQL_METHOD', ''), attr_);
   Client_SYS.Add_To_Attr('CURRENT_VALUE_DB',   Message_SYS.Find_Attribute(info_msg_, 'CURRENT_VALUE_DB', 'FALSE'), attr_);
   Client_SYS.Add_To_Attr('NEW_VALUE_DB',       Message_SYS.Find_Attribute(info_msg_, 'NEW_VALUE_DB', 'FALSE'), attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Register;


@UncheckedAccess
FUNCTION Get_Parameter_Id_Type (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   id_            IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_id_type IS
      SELECT id_type,new_value,current_value
      FROM   fnd_event_parameter_tab
      WHERE  event_id = event_id_
      AND    event_lu_name = event_lu_name_
      AND    id = SUBSTR(id_,INSTR(id_,':')+1);
   temp_ get_id_type%ROWTYPE;
BEGIN
   OPEN get_id_type;
   FETCH get_id_type INTO temp_;
   CLOSE get_id_type;
   IF (id_ LIKE 'OLD:%' AND temp_.current_value = 'FALSE') OR (id_ LIKE 'NEW:%' AND temp_.new_value = 'FALSE') THEN
      temp_.id_type := NULL;  
   END IF;
   RETURN temp_.id_type;
END Get_Parameter_Id_Type;

@UncheckedAccess
PROCEDURE Get_Attach_Parameter_Info (
   filename_      OUT VARCHAR2,
   description_   OUT VARCHAR2,
   plsql_method_  OUT VARCHAR2,
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   id_            IN VARCHAR2 )
IS
   CURSOR get_pl_method IS
      SELECT plsql_method,filename,description
      FROM   fnd_event_parameter_tab
      WHERE  event_id = event_id_
      AND    event_lu_name = event_lu_name_
      AND    id = id_;
BEGIN
   OPEN get_pl_method;
   FETCH get_pl_method INTO plsql_method_,filename_,description_;
   CLOSE get_pl_method; 
END Get_Attach_Parameter_Info;

PROCEDURE Import(
   xml_                   IN XmlType,
   event_lu_name_         IN VARCHAR2,
   event_id_              IN VARCHAR2)
IS
   parameter_ fnd_event_parameter_tab%ROWTYPE;
BEGIN
   
   DELETE FROM fnd_event_parameter_tab WHERE event_lu_name = event_lu_name_ AND event_id = event_id_;
   
   FOR rec_ IN get_event_parameters (xml_) LOOP
      parameter_.event_id := event_id_;
      parameter_.event_lu_name := event_lu_name_;
      parameter_.id := rec_.id;
      parameter_.id_type := rec_.id_type;
      parameter_.new_value := rec_.new_value;
      parameter_.plsql_method := rec_.plsql_method;
      parameter_.current_value := rec_.current_value;
      
      New___(parameter_);
   END LOOP;
   
END Import;

PROCEDURE Validate_Import (
   info_        IN OUT App_Config_Util_API.AppConfigItemInfo,
   dep_objects_ IN OUT App_Config_Util_API.DeploymentObjectArray,
   xml_         IN XmlType,
   table_name_  IN VARCHAR2)
IS
   column_name_ VARCHAR2(30);
BEGIN
   FOR rec_ IN get_event_parameters (xml_) LOOP
      -- Don't validate Custom Parameters
      IF rec_.plsql_method IS NULL THEN
         column_name_ := rec_.id;
         IF NOT App_Config_Util_API.Column_Exist(table_name_, column_name_, dep_objects_) THEN
            Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'TABLECOLNOTEXIST: Error: Column ":P1" does not exist on table :P2 ', Fnd_Session_API.Get_Language, column_name_, table_name_), TRUE);
            App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
         END IF;
      END IF;     
   END LOOP;
END Validate_Import;

PROCEDURE Validate_Existing (
   info_        IN OUT App_Config_Util_API.AppConfigItemInfo,
   rec_      IN fnd_event_parameter_tab%ROWTYPE,
   table_name_  IN VARCHAR2)
IS
   column_name_ VARCHAR2(30);
   dep_objects_ App_Config_Util_API.DeploymentObjectArray;
BEGIN
   -- Don't validate Custom Parameters
   IF rec_.plsql_method IS NULL THEN
      column_name_ := rec_.id;
      IF NOT App_Config_Util_API.Column_Exist(table_name_, column_name_, dep_objects_) THEN
         Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'TABLECOLNOTEXIST: Error: Column ":P1" does not exist on table :P2 ', Fnd_Session_API.Get_Language, column_name_, table_name_), TRUE);
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
      END IF;
   END IF;     
END Validate_Existing;

@UncheckedAccess
FUNCTION Get_Current_Value (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   id_            IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_ IS
      SELECT current_value
      FROM   fnd_event_parameter_tab
      WHERE  event_id = event_id_
      AND    event_lu_name = event_lu_name_
      AND    id = id_;   
   temp_ VARCHAR2(5);
BEGIN  
   temp_ := 'FALSE';
   OPEN get_;
   FETCH get_ INTO temp_;
   IF (get_%FOUND) THEN
      CLOSE get_;
      RETURN temp_;
   END IF;
   CLOSE get_;
   RETURN temp_;
END Get_Current_Value;

@UncheckedAccess
FUNCTION Get_New_Value (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   id_            IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_ IS
      SELECT new_value
      FROM   fnd_event_parameter_tab
      WHERE  event_id = event_id_
      AND    event_lu_name = event_lu_name_
      AND    id = id_;
   temp_ VARCHAR2(5);
BEGIN
   temp_ := 'FALSE';
   OPEN get_;
   FETCH get_ INTO temp_;
   IF (get_%FOUND) THEN
      CLOSE get_;
      RETURN temp_;
   END IF;
   CLOSE get_;
   RETURN temp_;
END Get_New_Value;

@UncheckedAccess
FUNCTION Get_Data_Type (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   id_            IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_ IS
      SELECT id_type
      FROM   fnd_event_parameter_tab
      WHERE  event_id = event_id_
      AND    event_lu_name = event_lu_name_
      AND    id = id_;
   temp_ VARCHAR2(20);
BEGIN
   temp_ := '';
   OPEN get_;
   FETCH get_ INTO temp_;
   IF (get_%FOUND) THEN
      CLOSE get_;
      RETURN temp_;
   END IF;
   CLOSE get_;
   RETURN 'NOT FOUND';
END Get_Data_Type;
