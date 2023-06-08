-----------------------------------------------------------------------------
--
--  Logical unit: CreateCompanyLog
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  001120  OVJOSE  Created
--  010619  Gawilk  Fixed bug # 15677. Checked General_SYS.Init_Method.
--  010915  OVJOSE  Added procedure Update_Log_Tab_To_Comments__
--  020208  ovjose  Changed calls from create_company_reg_api to crecomp_component_api
--  020319  ovjose  Added column updated and log_date.
--  021002  nikalk  Removed the use of User_Profile_SYS.Authorized.
--  100809  ovjose  Made method Insert_Into_Table___ autonomous
--  121023  Chwilk  Bug 106070, Added Transaction Statement Approved Annotation.
--  130621  Shhelk  TIBE-758,Removed Global variable
--  211215  Shdilk  FI21R2-6890, Added caching to avoid a performance issue in creating company process
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Create_Company_Log_Rec IS RECORD
  (company        VARCHAR2(20),
   module         VARCHAR2(6),
   logical_unit   VARCHAR2(40));

TYPE Micro_Cache_Type IS TABLE OF Create_Company_Log_Rec INDEX BY VARCHAR2(1000);

micro_cache_tab_                   Micro_Cache_Type;

micro_cache_value_                 Create_Company_Log_Rec;
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Insert_Into_Table___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT create_company_log_tab%ROWTYPE )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   newrec_.seq_no := Next_Create_Company_Log_Seq;
   newrec_.rowversion := SYSDATE;
   objversion_ := TO_CHAR(newrec_.rowversion,'YYYYMMDDHH24MISS');
   INSERT
      INTO create_company_log_tab (
         logical_unit,
         company,
         seq_no,
         module,
         error_text,
         status,
         updated,
         log_date,
         rowversion)
      VALUES (
         newrec_.logical_unit,
         newrec_.company,
         newrec_.seq_no,
         newrec_.module,
         newrec_.error_text,
         newrec_.status,
         newrec_.updated,
         newrec_.log_date,
         newrec_.rowversion)
   RETURNING ROWID INTO objid_;
   @ApproveTransactionStatement(2012-10-23,chwilk)
   COMMIT;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert_Into_Table___;


PROCEDURE Remove_Old_Update_Log___ (
   company_    IN VARCHAR2,
   component_  IN VARCHAR2 )
IS
   dummy_   NUMBER;
   CURSOR check_if_updated IS
      SELECT 1
      FROM   create_company_log_tab
      WHERE  company = company_
      AND    module = component_
      AND    updated = 'TRUE';
BEGIN
   OPEN check_if_updated;
   FETCH check_if_updated INTO dummy_;
   IF (check_if_updated%FOUND) THEN
      CLOSE check_if_updated;
      DELETE FROM create_company_log_tab
         WHERE company = company_
         AND module = component_
         AND updated = 'TRUE';
   ELSE
      CLOSE check_if_updated;
   END IF;
END Remove_Old_Update_Log___;


PROCEDURE Add_To_Imp_Table___ (
   company_ IN VARCHAR2 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   updated_          VARCHAR2(5) := 'FALSE';
   success_status_   VARCHAR2(50);
   comment_status_   VARCHAR2(50);
   cursor_status_    VARCHAR2(50);
   dummy2_           NUMBER;
   TYPE module_table IS TABLE OF VARCHAR2(6) INDEX BY BINARY_INTEGER;
   module_list_      module_table;
   CURSOR get_components IS
      SELECT module
      FROM   create_company_log_tab
      WHERE  company = company_
      AND    updated = updated_
      GROUP BY module;
   -- In older versions of IFS Applications the imp-table has gotten the values
   -- 'CreatedSuccessfully', 'CreatedWithComments' in the status column although updated=TRUE
   -- Either this was done intentionally or a mistake. Probably done on purpose to just
   -- show "Created"-like status at the aggregated level but at this point ot time Enterp 2.0.0
   -- it is not obvious so therefore this comment.
   -- If it is a mistake in the coding then the commented lines below could be used to correct this.
   CURSOR get_updated_data (module_ IN VARCHAR2, success_status_ IN VARCHAR2, comment_status_ IN VARCHAR2) IS
      SELECT   CASE status
                  WHEN 'Error' THEN
                     'Error'
                  WHEN success_status_ THEN
                     DECODE(error_text, NULL, 'CreatedSuccessfully', 'CreatedWithComments')
                  WHEN comment_status_ THEN
                     'CreatedWithComments'
                  ELSE
                     'CreatedSuccessfully'
                  END cursor_status
      FROM     create_company_log_tab
      WHERE    company = company_
      AND      module = module_
      AND      updated = updated_
      ORDER BY DECODE(cursor_status, 'Error', 0, 'CreatedWithComments', 1, 'CreatedSuccessfully', 2, 3);
   CURSOR company_updated IS
      SELECT 1
      FROM   create_company_log_tab
      WHERE  company = company_
      AND    updated = 'TRUE';

BEGIN
   DELETE FROM create_company_log_imp_tab
   WHERE company = company_;
   OPEN company_updated;
   FETCH company_updated INTO dummy2_;
   IF (company_updated%FOUND) THEN
      CLOSE company_updated;
      updated_ := 'TRUE';
      success_status_ := 'UpdatedSuccessfully';
      comment_status_ := 'UpdatedWithComments';
   ELSE
      CLOSE company_updated;
      updated_ := 'FALSE';
      success_status_ := 'CreatedSuccessfully';
      comment_status_ := 'CreatedWithComments';
   END IF;
   OPEN get_components;
   FETCH get_components BULK COLLECT INTO module_list_;
   CLOSE get_components;
   IF (module_list_.COUNT > 0) THEN
      FOR i_ IN module_list_.FIRST..module_list_.LAST LOOP
         cursor_status_ := NULL;
         OPEN get_updated_data(module_list_(i_), success_status_, comment_status_);
         FETCH get_updated_data INTO cursor_status_;
         CLOSE get_updated_data;
         INSERT INTO create_company_log_imp_tab(
            company,
            module,
            status,
            rowversion)
         VALUES(
            company_,
            module_list_(i_),
            NVL(cursor_status_,'CreatedSuccessfully'),
            SYSDATE);
      END LOOP;
   END IF;
   @ApproveTransactionStatement(2012-10-23,chwilk)
   COMMIT;
END Add_To_Imp_Table___;


PROCEDURE Update_Cache___ (
   company_          IN VARCHAR2,
   module_           IN VARCHAR2,
   logical_unit_     IN VARCHAR2 )
IS
   req_id_     VARCHAR2(1000) := company_||'^'||module_||'^'||logical_unit_;
BEGIN   
   IF (NOT micro_cache_tab_.exists(req_id_)) THEN
      micro_cache_value_.company := company_;
      micro_cache_value_.module := module_;
      micro_cache_value_.logical_unit := logical_unit_;
      micro_cache_tab_(req_id_) := micro_cache_value_;
   END IF; 
END Update_Cache___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Add_To_Imp_Table__ (
   company_ IN VARCHAR2 )
IS
BEGIN
   Add_To_Imp_Table___(company_);
END Add_To_Imp_Table__;


PROCEDURE Delete_Company_Log__ (
   company_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM create_company_log_tab
   WHERE company = company_;
   DELETE FROM create_company_log_imp_tab
   WHERE company = company_;
END Delete_Company_Log__;


PROCEDURE Initiate_Update_Company_Log__ (
   company_    IN VARCHAR2,
   component_  IN VARCHAR2 )
IS
BEGIN
   App_Context_SYS.Set_Value('Create_Company_Log_API.Update_Company_Started_', TRUE);
   Remove_Old_Update_Log___(company_, component_);
END Initiate_Update_Company_Log__;


PROCEDURE Reset_Log__
IS
BEGIN
   App_Context_SYS.Set_Value('Create_Company_Log_API.Update_Company_Started_', FALSE);
   App_Context_SYS.Set_Value('Create_Company_Log_API.Disable_Log_', FALSE);
END Reset_Log__;


PROCEDURE Update_Log_Tab_To_Comments__ (
   company_ IN VARCHAR2 )
IS
   CURSOR find_no_data_found_rows IS
      SELECT 'X'
      FROM   create_company_log_tab
      WHERE  company = company_
      AND    status  = 'CreatedSuccessfully'
      AND    error_text IS NOT NULL;
   CURSOR find_no_data_found_rows_upd IS
      SELECT 'X'
      FROM   create_company_log_tab
      WHERE  company = company_
      AND    status  = 'UpdatedSuccessfully'
      AND    updated = 'TRUE'
      AND    error_text IS NOT NULL;
   dummy_   VARCHAR2(1);
BEGIN
   OPEN find_no_data_found_rows_upd;
   FETCH find_no_data_found_rows_upd INTO dummy_;
   IF (find_no_data_found_rows_upd%FOUND) THEN
      CLOSE find_no_data_found_rows_upd;
      UPDATE create_company_log_tab
         SET    status = 'UpdatedWithComments'
         WHERE  company = company_
         AND    status  = 'UpdatedSuccessfully'
         AND    updated = 'TRUE'
         AND    error_text IS NOT NULL;
   ELSE
      CLOSE find_no_data_found_rows_upd;
      OPEN find_no_data_found_rows;
      FETCH find_no_data_found_rows INTO dummy_;
      IF (find_no_data_found_rows%NOTFOUND) THEN
         CLOSE find_no_data_found_rows;
      ELSE
         CLOSE find_no_data_found_rows;
         UPDATE create_company_log_tab
            SET status = 'CreatedWithComments'
            WHERE  company = company_
            AND    status  = 'CreatedSuccessfully'
            AND    error_text IS NOT NULL;
      END IF;
   END IF;
END Update_Log_Tab_To_Comments__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Exist_Error (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR exist_errors IS
     SELECT 'X'
     FROM   create_company_log_tab
     WHERE  company = company_
     AND    status  = 'Error';
   CURSOR exist_comments IS
     SELECT 'X'
     FROM   create_company_log_tab
     WHERE  company = company_
     AND    status  = 'CreatedSuccessfully'
     AND    error_text IS NOT NULL;
   CURSOR company_updated IS
      SELECT 'X'
      FROM   create_company_log_tab
      WHERE company = company_
      AND   updated = 'TRUE';
   CURSOR   update_exist_errors IS
     SELECT 'X'
     FROM   create_company_log_tab
     WHERE  company = company_
     AND    updated = 'TRUE'
     AND    status  = 'Error';
   CURSOR update_exist_comments IS
     SELECT 'X'
     FROM   create_company_log_tab
     WHERE  company = company_
     AND    status  = 'CreatedSuccessfully'
     AND    updated = 'TRUE'
     AND    error_text IS NOT NULL;
   dummy_   VARCHAR2(1);
BEGIN
   OPEN company_updated;
   FETCH company_updated INTO dummy_;
   IF (company_updated%FOUND) THEN
      CLOSE company_updated;
      OPEN update_exist_errors;
      FETCH update_exist_errors INTO dummy_;
      IF (update_exist_errors%NOTFOUND) THEN
         CLOSE update_exist_errors;
         OPEN update_exist_comments;
         FETCH update_exist_comments INTO dummy_;
         IF (update_exist_comments%NOTFOUND) THEN
            CLOSE update_exist_comments;
            RETURN 'FALSE';
         ELSE
            CLOSE update_exist_comments;
            RETURN 'COMMENTS';
         END IF;
      ELSE
         CLOSE update_exist_errors;
         RETURN 'TRUE';
      END IF;
   ELSE
      CLOSE company_updated;
      OPEN exist_errors;
      FETCH exist_errors INTO dummy_;
      IF (exist_errors%NOTFOUND) THEN
         CLOSE exist_errors;
         OPEN exist_comments;
         FETCH exist_comments INTO dummy_;
         IF (exist_comments%NOTFOUND) THEN
            CLOSE exist_comments;
            RETURN 'FALSE';
         ELSE
            CLOSE exist_comments;
            RETURN 'COMMENTS';
         END IF;
      ELSE
         CLOSE exist_errors;
         RETURN 'TRUE';
      END IF;
   END IF;
END Exist_Error;


PROCEDURE Logging (
   company_    IN VARCHAR2,
   module_     IN VARCHAR2,
   lu_name_    IN VARCHAR2,
   status_     IN VARCHAR2,
   error_      IN VARCHAR2 DEFAULT NULL )
IS   
   CURSOR exist_log_update IS
     SELECT 'X'
     FROM   create_company_log_tab
     WHERE  company = company_
     AND    module = module_
     AND    logical_unit = lu_name_
     AND    updated = 'TRUE'
     AND    (status = 'UpdatedSuccessfully'
     OR     status = 'UpdatedWithErrors');
   dummy_                     VARCHAR2(1);
   newrec_                    create_company_log_tab%ROWTYPE;
   objid_                     VARCHAR2(100);
   objversion_                VARCHAR2(2000);
   disable_log_               BOOLEAN;
   update_company_started_    BOOLEAN;
   req_id_                    VARCHAR2(1000) := company_||'^'||module_||'^'||lu_name_;
BEGIN
   newrec_.company := company_;
   newrec_.module := module_;
   newrec_.logical_unit := lu_name_;
   newrec_.error_text := error_;
   newrec_.status := status_;
   newrec_.log_date := SYSDATE;
   disable_log_ := App_Context_SYS.Find_Boolean_Value('Create_Company_Log_API.Disable_Log_',FALSE);
   update_company_started_ := App_Context_SYS.Find_Boolean_Value('Create_Company_Log_API.Update_Company_Started_',FALSE);
   IF (NOT disable_log_) THEN
      IF (update_company_started_) THEN
         IF (newrec_.status = 'CreatedSuccessfully') THEN
            newrec_.status := 'UpdatedSuccessfully';
         ELSIF (newrec_.status = 'CreateStarted') THEN
            newrec_.status := 'UpdateStarted';
         ELSIF (newrec_.status = 'CreatedWithErrors') THEN
            newrec_.status := 'UpdatedWithErrors';
         ELSIF (newrec_.status = 'CreatedWithComments') THEN
            newrec_.status := 'UpdatedWithComments';
         END IF;
         newrec_.updated := 'TRUE';
         OPEN exist_log_update;
         FETCH exist_log_update INTO dummy_;
         IF (exist_log_update%NOTFOUND) THEN
            CLOSE exist_log_update;
            Insert_Into_Table___(objid_, objversion_, newrec_);
         ELSE
            CLOSE exist_log_update;
         END IF;
      ELSE
         newrec_.updated := 'FALSE';
         IF NOT(micro_cache_tab_.exists(req_id_)) THEN
            Insert_Into_Table___(objid_, objversion_, newrec_);              
            IF (status_ = 'CreatedSuccessfully' OR status_ = 'CreatedWithErrors') THEN 
               Update_Cache___(company_, module_, lu_name_);
            END IF;   
         END IF;
      END IF;
   END IF;
END Logging;


FUNCTION Next_Create_Company_Log_Seq RETURN NUMBER
IS
   seq_num_     NUMBER;
   CURSOR get_seq_no IS
      SELECT create_company_log_seq.NEXTVAL
      FROM DUAL;
BEGIN
   OPEN  get_seq_no;
   FETCH get_seq_no INTO seq_num_;
   CLOSE get_seq_no;
   RETURN seq_num_;
END Next_Create_Company_Log_Seq;


PROCEDURE Disable_Log (
   dummy_ IN NUMBER )
IS
BEGIN
   App_Context_SYS.Set_Value('Create_Company_Log_API.Disable_Log_', TRUE);
END Disable_Log;


