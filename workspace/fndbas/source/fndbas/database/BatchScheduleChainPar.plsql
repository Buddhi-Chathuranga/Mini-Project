-----------------------------------------------------------------------------
--
--  Logical unit: BatchScheduleChainPar
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  080630  HAAR  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT BATCH_SCHEDULE_CHAIN_PAR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Get Seq_No
   newrec_.seq_no := Get_Next_Seq_No___(newrec_.schedule_id);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

PROCEDURE New__ (
   newrec_     IN OUT BATCH_SCHEDULE_CHAIN_PAR_TAB%ROWTYPE )
IS
   objid_      BATCH_SCHEDULE_CHAIN_PAR.objid%TYPE;
   objversion_ BATCH_SCHEDULE_CHAIN_PAR.objversion%TYPE;
   attr_       VARCHAR2(2000);
BEGIN
   Batch_Schedule_API.Exist(newrec_.schedule_id);
   IF newrec_.seq_no IS NOT NULL THEN
      Error_SYS.Item_Insert(lu_name_, 'SEQ_NO');
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'SCHEDULE_ID', newrec_.schedule_id);
   Error_SYS.Check_Not_Null(lu_name_, 'SCHEDULE_METHOD_ID', newrec_.schedule_method_id);
   Error_SYS.Check_Not_Null(lu_name_, 'STEP_NO', newrec_.step_no);
   Error_SYS.Check_Not_Null(lu_name_, 'NAME', newrec_.name);
   Insert___(objid_, objversion_, newrec_, attr_);
   -- Not intended for usage from clients
   Client_SYS.Clear_Info;
END New__;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Seq_No___ (
   schedule_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_seq_no IS
      SELECT MAX(seq_no)+1
      FROM   BATCH_SCHEDULE_CHAIN_PAR_TAB
      WHERE  schedule_id = schedule_id_;
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

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Parameters__ (
   schedule_id_        IN NUMBER,
   schedule_method_id_ IN NUMBER,
   step_no_            IN NUMBER,
   argument_type_db_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_          VARCHAR2(4000);
   parameters_     VARCHAR2(32000);
   rep_par_type_   VARCHAR2(10);
   rep_par_attr_   VARCHAR2(32000);
   ptr_            NUMBER;
   par_name_       VARCHAR2(30);
   par_value_      VARCHAR2(4000);
   new_par_value_  VARCHAR2(4000);

   CURSOR get_parameters IS
      SELECT  b.name, b.data_type, p.value
      FROM    batch_schedule_method_par_tab b,
              batch_schedule_chain_par_tab p
      WHERE   b.schedule_method_id = schedule_method_id_
      AND     p.schedule_id (+) = schedule_id_
      AND     p.step_no (+) = step_no_
      AND     b.schedule_method_id = p.schedule_method_id (+)
      AND     b.name = p.name (+)
      ORDER BY p.seq_no;

   CURSOR get_rep_par_type IS
      SELECT  c.column_type
      FROM    batch_schedule_tab a,
              batch_schedule_method_tab b,
              report_sys_column_tab c
      WHERE   a.schedule_id = schedule_id_
      AND     a.schedule_method_id = b.schedule_method_id
      AND     UPPER(b.method_name) = 'ARCHIVE_API.CREATE_AND_PRINT_REPORT__'
      AND     a.external_id = c.report_id
      AND     c.column_name = par_name_;

   FUNCTION Date_Check___ (
      value_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      date_        DATE;
      date_format_ VARCHAR2(50) := Client_SYS.date_format_;
      stmt_        VARCHAR2(2000);
   BEGIN
      IF INSTR(UPPER(value_), 'SYSDATE')>0 THEN
         Assert_SYS.Assert_Is_Sysdate_Expression(value_);
         stmt_ := 'BEGIN :date := '||value_||'; END;';
         @ApproveDynamicStatement(2007-01-25,pemase)
         EXECUTE IMMEDIATE stmt_ USING OUT date_;
         RETURN(to_char(date_, date_format_));
      ELSE
         date_ := to_date(value_, date_format_);
         RETURN(to_char(date_, date_format_));
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Appl_General(lu_name_, 'INVALID_SYSDATE_EXP: ":P1" is not a valid date expression.', value_ );
   END Date_Check___;

BEGIN
   IF (argument_type_db_ = 'MESSAGE') THEN
      parameters_ := Message_SYS.Construct('');
   END IF;
   FOR rec IN get_parameters LOOP
      value_ := rec.VALUE;
      IF (rec.data_type = 'DATE') THEN
         value_ := Date_Check___(value_);
      ELSIF rec.name = 'PARAMETER_ATTR' THEN
         rep_par_attr_ := value_;
         ptr_ := NULL;
         WHILE Client_SYS.Get_Next_From_Attr(rep_par_attr_, ptr_, par_name_, par_value_) LOOP
            new_par_value_ := NULL;
            IF INSTR(UPPER(par_value_), 'SYSDATE')>0 THEN
               OPEN get_rep_par_type;
               FETCH get_rep_par_type INTO rep_par_type_;
               CLOSE get_rep_par_type;
               IF rep_par_type_ = 'DATE' THEN
                  new_par_value_ := Date_Check___(par_value_);
               END IF;
               IF new_par_value_ <> par_value_ THEN
                  Client_SYS.Set_Item_Value(par_name_, new_par_value_, value_);
               END IF;
            END IF;
         END LOOP;
      END IF;
      IF (argument_type_db_ = 'MESSAGE') THEN
         Message_SYS.Add_Attribute(parameters_, rec.name, rec.value);
      ELSIF (argument_type_db_ = 'ATTRIBUTE') THEN
         -- Convert to an attribute string
         Client_SYS.Add_To_Attr(rec.name, rec.value, parameters_);
      ELSIF (argument_type_db_ = 'PARAMETER') THEN
         -- Convert to an attribute string
         Client_SYS.Add_To_Attr(rec.name, value_, parameters_);
      END IF;
   END LOOP;
   RETURN(parameters_);
END Get_Parameters__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
