-----------------------------------------------------------------------------
--
--  Logical unit: BatchScheduleMethodPar
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  040507  HAAR  Created
--  041202  HAAR  Added column default_expression and data_type. 
--                Added Get_Default_Values__ and Get_Default_Value___ (F1PR419).
--  041216  HAAR  Added Get_Default_Value__(F1PR419).
--  060524  HAAR  Added check of system privilege DEFINE SQL (F1PR447).
--  060726  NiWi  Changed Get_Default_Value___ to allow sysdate and it's expressions ad values of format DATE(Bug#58975).
--  070212  NiWi  Modified Unpack_Check_Insert___ and Unpack_Check_Update__(Bug#63435).
--  100715  ChMu  Certified the assert safe for dynamic SQLs (Bug#84970). 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     BATCH_SCHEDULE_METHOD_PAR_TAB%ROWTYPE,
   newrec_ IN OUT BATCH_SCHEDULE_METHOD_PAR_TAB%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF newrec_.data_type NOT IN ('STRING', 'DATE', 'NUMBER') THEN
       Error_SYS.Record_General(lu_name_, 'WRONG_DATATYPE_I: The datatype of a parameter must be STRING, DATE or NUMBER, it can not be [:P1].', newrec_.data_type);
   END IF;
   IF newrec_.data_type = 'DATE' AND  instr(UPPER(newrec_.value), 'SYSDATE')>0 THEN
      Sysdate_Exp_Check___(newrec_.value);
   END IF;
END Check_Common___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT BATCH_SCHEDULE_METHOD_PAR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   dummy_ VARCHAR2(2000);
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   -- Validate Default values
   dummy_ := Get_Default_Value___(newrec_.data_type, newrec_.default_expression,newrec_.value);
   -- Get Seq_No
   newrec_.seq_no := Get_Next_Seq_No___(newrec_.schedule_method_id);
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('SEQ_NO', newrec_.seq_no, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     BATCH_SCHEDULE_METHOD_PAR_TAB%ROWTYPE,
   newrec_     IN OUT BATCH_SCHEDULE_METHOD_PAR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   dummy_ VARCHAR2(2000);
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   -- Validate Default values
   dummy_ := Get_Default_Value___(newrec_.data_type, newrec_.default_expression,newrec_.value);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Default_Value___ (
   data_type_          IN VARCHAR2,
   default_expression_ IN VARCHAR2,
   value_              IN VARCHAR2 ) RETURN VARCHAR2
IS
   default_value_ VARCHAR2(2000);
BEGIN
   IF default_expression_ IS NOT NULL THEN
      BEGIN
         CASE data_type_
         WHEN 'STRING' THEN
            -- Safe due to Security_SYS.Has_System_Privilege check in Insert___ and Update___
            @ApproveDynamicStatement(2010-07-15,chmulk)
            EXECUTE IMMEDIATE 'BEGIN :default_value := '||default_expression_||'; END;' USING OUT default_value_;
         WHEN 'DATE' THEN
            @ApproveDynamicStatement(2010-07-15,chmulk)
            EXECUTE IMMEDIATE 'BEGIN :default_value := to_char('||default_expression_||', Client_SYS.Date_Format_); END;' USING OUT default_value_;
         WHEN 'NUMBER' THEN
            @ApproveDynamicStatement(2010-07-15,chmulk)
            EXECUTE IMMEDIATE 'BEGIN :default_value := to_char('||default_expression_||'); END;' USING OUT default_value_;
         END CASE;
      EXCEPTION
         WHEN OTHERS THEN
         Error_SYS.Appl_General(lu_name_, 'DEFAULT_EXPRESSION: Invalid default expression: ' || default_expression_);   
      END;
   ELSE
      IF value_ IS NOT NULL THEN
         BEGIN
            CASE data_type_
            WHEN 'STRING' THEN
               @ApproveDynamicStatement(2006-02-15,pemase)
               EXECUTE IMMEDIATE 'BEGIN :default_value := :value; END;' USING OUT default_value_, IN value_;
            WHEN 'DATE' THEN
               IF INSTR(UPPER(value_), 'SYSDATE') > 0 THEN
                  default_value_ := value_;
               ELSE
                  @ApproveDynamicStatement(2006-02-15,pemase)
                  EXECUTE IMMEDIATE 'BEGIN :default_value := to_char(to_date(:value, Client_SYS.Date_Format_), Client_SYS.Date_Format_); END;' USING OUT default_value_, IN value_;
               END IF;
            WHEN 'NUMBER' THEN
               @ApproveDynamicStatement(2006-02-15,pemase)
               EXECUTE IMMEDIATE 'BEGIN :default_value := to_char(:value); END;' USING OUT default_value_, IN value_;
            END CASE;
         EXCEPTION
            WHEN OTHERS THEN
               Error_SYS.Appl_General(lu_name_, 'VALUE: Invalid value: ' || value_);
         END;
      END IF;
   END IF;
   RETURN(default_value_);
END Get_Default_Value___;

FUNCTION Get_Next_Seq_No___ (
   schedule_method_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_seq_no IS
      SELECT MAX(seq_no)+1
      FROM   BATCH_SCHEDULE_METHOD_PAR_TAB
      WHERE  schedule_method_id = schedule_method_id_;
   seq_no_  NUMBER;
BEGIN
   OPEN get_seq_no;
   FETCH get_seq_no INTO seq_no_;
   CLOSE get_seq_no;
   IF seq_no_ IS NULL THEN
      seq_no_ := 1;
   END IF;
   RETURN seq_no_;
END Get_Next_Seq_No___;

PROCEDURE Sysdate_Exp_Check___ (
   value_ IN VARCHAR2 ) 
IS
   date_        DATE;
   stmt_        VARCHAR2(2000);
BEGIN
   Assert_SYS.Assert_Is_Sysdate_Expression(value_);  
   stmt_ := 'BEGIN :date := '||value_||'; END;';
   @ApproveDynamicStatement(2007-02-12,niwilk)
   EXECUTE IMMEDIATE stmt_ USING OUT date_;
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Appl_General(lu_name_, 'INVALID_SYSDATE_EXP: ":P1" is not a valid date expression.', value_ );      
END Sysdate_Exp_Check___;    

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Default_Value__ (
   schedule_method_id_ IN NUMBER,
   seq_no_             IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_parameter IS
      SELECT name, data_type, default_expression, value
      FROM   batch_Schedule_method_par_tab
      WHERE  schedule_method_id = schedule_method_id_
      AND    seq_no = seq_no_;
BEGIN
   FOR rec IN get_parameter LOOP
      RETURN(Get_Default_Value___(rec.data_type, rec.default_expression, rec.value));
   END LOOP;
END Get_Default_Value__;

PROCEDURE Get_Default_Values__ (
   msg_ OUT VARCHAR2,
   schedule_method_id_ IN NUMBER )
IS
   CURSOR get_parameters IS
      SELECT name, data_type, default_expression, value
      FROM   batch_Schedule_method_par_tab
      WHERE  schedule_method_id = schedule_method_id_;
BEGIN
   msg_ := Message_SYS.Construct('DEFAULT_VALUES');
   FOR rec IN get_parameters LOOP
      Message_SYS.Set_Attribute(msg_, rec.name, Get_Default_Value___(rec.data_type, rec.default_expression, rec.value));
   END LOOP;
END Get_Default_Values__;

FUNCTION Validate_Date___(date_ VARCHAR2) RETURN BOOLEAN   
IS
dte_ VARCHAR2 (100);
BEGIN
   dte_ := to_date(date_,'YYYY-MM-DD-HH24-MI-SS');
   return TRUE;
   exception 
      when others then 
         return FALSE;
END Validate_Date___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Mandatory_Db (
   schedule_method_id_ IN NUMBER,
   name_               IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ BATCH_SCHEDULE_METHOD_PAR_TAB.mandatory%TYPE;
   CURSOR get_attr IS
      SELECT mandatory
      FROM BATCH_SCHEDULE_METHOD_PAR_TAB
      WHERE schedule_method_id = schedule_method_id_
      AND   name = name_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Mandatory_Db;

@UncheckedAccess
FUNCTION Get_Parameter_Name (
   schedule_method_id_ IN NUMBER,
   seq_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ BATCH_SCHEDULE_METHOD_PAR_TAB.name%TYPE;
   CURSOR get_attr IS
      SELECT name
      FROM BATCH_SCHEDULE_METHOD_PAR_TAB
      WHERE schedule_method_id = schedule_method_id_
      AND   seq_no = seq_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Parameter_Name;

FUNCTION Get_Default_Value (
   data_type_          IN VARCHAR2,
   default_expression_ IN VARCHAR2,
   value_              IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   RETURN Get_Default_Value___(data_type_, default_expression_, value_);
END Get_Default_Value;

PROCEDURE Check_Valid_Date (
   date_value_ IN VARCHAR2 )
IS
BEGIN
   IF INSTR(UPPER(date_value_), 'SYSDATE')>0 THEN
      Sysdate_Exp_Check___(date_value_);
   ELSE
      IF NOT Validate_Date___(date_value_) THEN 
         Error_SYS.Appl_General(lu_name_,'DATE_INVL: Please enter a valid Date in the format YYYY-MM-DD-HH24-MI-SS');
      END IF;
   END IF;
END Check_Valid_Date;