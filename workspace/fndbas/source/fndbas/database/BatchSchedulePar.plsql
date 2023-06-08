-----------------------------------------------------------------------------
--
--  Logical unit: BatchSchedulePar
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  040519   HAAR  Created.
--  041001   ROOD  Added methods for New and Modify that are using records (F1PR419).
--  060814   NiWi  Added Validate_Sysdate_Exp__(Bug#58975).
--  070212   NiWi  Modified Validate_Sysdate_Exp___(Bug#63435).
--  091023  UsRaLK Increased the support for value parameter to 4000 characters. (Bug#86689)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT batch_schedule_par_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(newrec_, indrec_, attr_);
   IF INSTR(UPPER(newrec_.value), 'SYSDATE') > 0 THEN
       Validate_Sysdate_Exp___(newrec_.schedule_id, newrec_.name, newrec_.value);
   END IF; 
END Check_Insert___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT BATCH_SCHEDULE_PAR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Get Seq_No
   newrec_.seq_no := Get_Next_Seq_No___(newrec_.schedule_id);
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('SEQ_NO', newrec_.seq_no, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

PROCEDURE Register__(
   newrec_     IN OUT BATCH_SCHEDULE_PAR_TAB%ROWTYPE )
IS
   CURSOR get_seq_no IS
   SELECT bsp.seq_no 
   FROM Batch_Schedule_Par_Tab bsp
   WHERE bsp.schedule_id = newrec_.schedule_id
   AND bsp.name = newrec_.name;
   
BEGIN
   -- Check if parameter already exist
   OPEN get_seq_no;
   FETCH get_seq_no INTO newrec_.seq_no;
   IF (get_seq_no%FOUND) THEN
      CLOSE get_seq_no;      
   ELSE
      CLOSE get_seq_no;
      New__(newrec_);
   END IF;     
END Register__;

-- Version required to avoid attribute strings in attribute strings when called from server.
PROCEDURE New__ (
   newrec_     IN OUT BATCH_SCHEDULE_PAR_TAB%ROWTYPE )
IS
   objid_      BATCH_SCHEDULE_PAR.objid%TYPE;
   objversion_ BATCH_SCHEDULE_PAR.objversion%TYPE;
   attr_       VARCHAR2(2000);
BEGIN
   Batch_Schedule_API.Exist(newrec_.schedule_id);
   IF newrec_.seq_no IS NOT NULL THEN
      Error_SYS.Item_Insert(lu_name_, 'SEQ_NO');
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'SCHEDULE_ID', newrec_.schedule_id);
   Error_SYS.Check_Not_Null(lu_name_, 'NAME', newrec_.name);
   IF INSTR(UPPER(newrec_.value), 'SYSDATE') > 0 THEN
      Validate_Sysdate_Exp___(newrec_.schedule_id, newrec_.name, newrec_.value);
   END IF; 
   Insert___(objid_, objversion_, newrec_, attr_);
   -- Not intended for usage from clients
   Client_SYS.Clear_Info;
END New__;


-- Version required to avoid attribute strings in attribute strings when called from server.
PROCEDURE Modify__ (
   newrec_     IN OUT BATCH_SCHEDULE_PAR_TAB%ROWTYPE )
IS
   oldrec_     BATCH_SCHEDULE_PAR_TAB%ROWTYPE;
   objid_      BATCH_SCHEDULE_PAR.objid%TYPE;
   objversion_ BATCH_SCHEDULE_PAR.objversion%TYPE;
   attr_       VARCHAR2(2000);

   FUNCTION Item_Differs (
      old_item_  IN VARCHAR2,
      new_item_  IN VARCHAR2 ) RETURN BOOLEAN
   IS
   BEGIN
      IF old_item_ IS NULL THEN
         IF new_item_ IS NULL THEN
            RETURN FALSE;
         ELSE
            RETURN TRUE;
         END IF;
      ELSIF new_item_ IS NULL THEN 
         RETURN TRUE;
      ELSE 
         RETURN (old_item_ != new_item_);
      END IF;
   END Item_Differs;

   FUNCTION Item_Differs (
      old_item_  IN NUMBER,
      new_item_  IN NUMBER ) RETURN BOOLEAN
   IS
   BEGIN
      RETURN Item_Differs(to_char(old_item_), to_char(new_item_));
   END Item_Differs;
   
BEGIN
   oldrec_ := Lock_By_Keys___(newrec_.schedule_id, newrec_.seq_no);
   IF Item_Differs(oldrec_.schedule_id, newrec_.schedule_id) THEN
      Error_SYS.Item_Update(lu_name_, 'SCHEDULE_ID');
   END IF;
   IF Item_Differs(oldrec_.seq_no, newrec_.seq_no) THEN
      Error_SYS.Item_Update(lu_name_, 'SEQ_NO');
   END IF;
   IF Item_Differs(oldrec_.name, newrec_.name) THEN
      Error_SYS.Item_Update(lu_name_, 'NAME');
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'SCHEDULE_ID', newrec_.schedule_id);
   Error_SYS.Check_Not_Null(lu_name_, 'NAME', newrec_.name);
   newrec_.rowkey := oldrec_.rowkey;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys!
   -- Not intended for usage from clients
   Client_SYS.Clear_Info;
END Modify__;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Sysdate_Exp___(
    schedule_id_  IN NUMBER,
    name_         IN VARCHAR2,
    value_        IN VARCHAR2)
IS
    data_type_    VARCHAR2(10); 
    rep_par_type_ VARCHAR2(10);
    ptr_          NUMBER;
    par_name_     VARCHAR2(30);
    par_value_    VARCHAR2(4000); 
    
    CURSOR get_par_type IS
    SELECT c.data_type
    FROM  batch_schedule_tab a, 
          batch_schedule_method_tab b, 
          batch_schedule_method_par_tab c
    WHERE a.schedule_id = schedule_id_
    AND   a.schedule_method_id = b.schedule_method_id
    AND   c.schedule_method_id = b.schedule_method_id
    AND   c.name = name_; 
    
    CURSOR get_rep_par_type IS
    SELECT c.column_type
    FROM  batch_schedule_tab a, 
          batch_schedule_method_tab b, 
          report_sys_column_tab c
    WHERE a.schedule_id = schedule_id_
    AND   a.schedule_method_id = b.schedule_method_id
    AND   UPPER(b.method_name) = 'ARCHIVE_API.CREATE_AND_PRINT_REPORT__'
    AND   a.external_id = c.report_id
    AND   c.column_name = par_name_; 

    PROCEDURE Date_Check___ (
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
    END Date_Check___;    
     
BEGIN  
    IF name_ = 'PARAMETER_ATTR' THEN
       ptr_ := NULL;
       WHILE Client_SYS.Get_Next_From_Attr(value_, ptr_, par_name_, par_value_) LOOP
          IF INSTR(UPPER(par_value_), 'SYSDATE')>0 THEN
             OPEN get_rep_par_type;
             FETCH get_rep_par_type INTO rep_par_type_;
             CLOSE get_rep_par_type;
             IF rep_par_type_ = 'DATE' THEN
                Date_Check___(par_value_);
             END IF;
          END IF;   
       END LOOP;
    ELSE    
       OPEN get_par_type;
       FETCH get_par_type INTO data_type_;
       CLOSE get_par_type;
       IF data_type_ = 'DATE' THEN
          Date_Check___(value_);
       END IF;
    END IF;   
END Validate_Sysdate_Exp___;    

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Get_Next_Seq_No___ (
   schedule_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_seq_no IS
      SELECT MAX(seq_no)+1
      FROM   BATCH_SCHEDULE_PAR_TAB
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

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
