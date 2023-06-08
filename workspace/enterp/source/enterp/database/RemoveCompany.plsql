-----------------------------------------------------------------------------
--
--  Logical unit: RemoveCompany
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  010306  LiSv    Created.
--  010504  ovjose  Added view USER_FINANCE in order to avoid installation errors.
--  020208  ovjose  Changed calls from create_company_reg_api to crecomp_component_api
--  021113  ovjose  Glob06. Moved column column_name to new LU Remove_Company_Detail.
--                  Changed internally component to module.
--  030509  ovjose  Bug 35886 Corrected. Removed dynamic creation of view USER_FINANCE
--  090521  AsHelk  Bug 80221, Adding Transaction Statement Approved Annotation.
--  130306  Kagalk  Bug 108571, Added new error message to Start_Remove_Company__ 
--  130614  DipeLK  TIBE-726, Removed global variables which are used to check exsistance of MPCCOM,PROJ
--                  PERSON,MSCOM,WRKSCH,ACCRUL components
--  151222  Chiblk  STRFI-890, Rewrite sub methods to implmentation methods
--  200701  tkavlk  Bug 154601, Change Start_Remove_Company. Added reverse delete order
--  200921  tkavlk  obsolete FINREP,BUDPRO,CONACC related tables in hard coded array
--  210203  tkavlk  Bug merge 157487,156963 modify Start_Remove_Company__
--  210914  Sacnlk  FI21R2-4065, LCS Bug Merged 160775, Modify Start_Remove_Company. 
--  220103  Shdilk  FI21R2-7069, Modify Start_Remove_Company to remove Company_Cost_Alloc_Info data.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------                  
              
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Bind_Variables___ (
   bp1_   IN OUT VARCHAR2,
   bp2_   IN OUT VARCHAR2,
   bp3_   IN OUT VARCHAR2,
   bp4_   IN OUT VARCHAR2,
   bp5_   IN OUT VARCHAR2,
   bp6_   IN OUT VARCHAR2,
   bp7_   IN OUT VARCHAR2,
   bp8_   IN OUT VARCHAR2,
   bp9_   IN OUT VARCHAR2,
   bp10_  IN OUT VARCHAR2,
   cid_   IN OUT INTEGER,
   bind_  IN     NUMBER )
IS
BEGIN
   IF (bind_ = 1) THEN
      dbms_sql.bind_variable(cid_, ':bind1', bp1_);
   ELSIF (bind_ = 2) THEN
      dbms_sql.bind_variable(cid_, ':bind2', bp2_);
   ELSIF (bind_ = 3) THEN
      dbms_sql.bind_variable(cid_, ':bind3', bp3_);
   ELSIF (bind_ = 4) THEN
      dbms_sql.bind_variable(cid_, ':bind4', bp4_);
   ELSIF (bind_ = 5) THEN
      dbms_sql.bind_variable(cid_, ':bind5', bp5_);
   ELSIF (bind_ = 6) THEN
      dbms_sql.bind_variable(cid_, ':bind6', bp6_);
   ELSIF (bind_ = 7) THEN
      dbms_sql.bind_variable(cid_, ':bind7', bp7_);
   ELSIF (bind_ = 8) THEN
      dbms_sql.bind_variable(cid_, ':bind8', bp8_);
   ELSIF (bind_ = 9) THEN
      dbms_sql.bind_variable(cid_, ':bind9', bp9_);
   ELSIF (bind_ = 10) THEN
      dbms_sql.bind_variable(cid_, ':bind10', bp10_);
   ELSE
      Error_SYS.Record_General(lu_name_, 'TOMANY: To many bind variable used in remove company function');
   END IF;
END Bind_Variables___;


PROCEDURE Reset_Binds___ (
   bp1_   IN OUT VARCHAR2,
   bp2_   IN OUT VARCHAR2,
   bp3_   IN OUT VARCHAR2,
   bp4_   IN OUT VARCHAR2,
   bp5_   IN OUT VARCHAR2,
   bp6_   IN OUT VARCHAR2,
   bp7_   IN OUT VARCHAR2,
   bp8_   IN OUT VARCHAR2,
   bp9_   IN OUT VARCHAR2,
   bp10_  IN OUT VARCHAR2 )
IS
BEGIN
   bp1_ := NULL;
   bp2_ := NULL;
   bp3_ := NULL;
   bp4_ := NULL;
   bp5_ := NULL;
   bp6_ := NULL;
   bp7_ := NULL;
   bp8_ := NULL;
   bp9_ := NULL;
   bp10_ := NULL;
END Reset_Binds___;


PROCEDURE Assign_Binds___ (
   stmt_  IN OUT VARCHAR2,
   bp1_   IN OUT VARCHAR2,
   bp2_   IN OUT VARCHAR2,
   bp3_   IN OUT VARCHAR2,
   bp4_   IN OUT VARCHAR2,
   bp5_   IN OUT VARCHAR2,
   bp6_   IN OUT VARCHAR2,
   bp7_   IN OUT VARCHAR2,
   bp8_   IN OUT VARCHAR2,
   bp9_   IN OUT VARCHAR2,
   bp10_  IN OUT VARCHAR2,
   value_ IN     VARCHAR2,
   bind_  IN     NUMBER )
IS
BEGIN
   IF (bind_ = 1) THEN
      bp1_  := value_;
      stmt_ :=  stmt_||' = :bind1 ';
   ELSIF (bind_ = 2) THEN
      bp2_  := value_;
      stmt_ :=  stmt_||' = :bind2 ';
   ELSIF (bind_ = 3) THEN
      bp3_  := value_;
      stmt_ := stmt_||' = :bind3 ';
   ELSIF (bind_ = 4) THEN
      bp4_  := value_;
      stmt_ := stmt_||' = :bind4 ';
   ELSIF (bind_ = 5) THEN
      bp5_  := value_;
      stmt_ := stmt_||' = :bind5 ';
   ELSIF (bind_ = 6) THEN
      bp6_  := value_;
      stmt_ := stmt_||' = :bind6 ';
   ELSIF (bind_ = 7) THEN
      bp7_  := value_;
      stmt_ := stmt_||' = :bind7 ';
   ELSIF (bind_ = 8) THEN
      bp8_  := value_;
      stmt_ := stmt_||' = :bind8 ';
   ELSIF (bind_ = 9) THEN
      bp9_  := value_;
      stmt_ := stmt_||' = :bind9 ';
   ELSIF (bind_ = 10) THEN
      bp10_ := value_;
      stmt_ := stmt_||' = :bind10 ';
   ELSE
      Error_SYS.Record_General(lu_name_, 'TOMANY: To many bind variable used in remove company function');
   END IF;
END Assign_Binds___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('STANDARD_TABLE', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT remove_company_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);   
   Assert_SYS.Assert_Is_Table(newrec_.table_name);
END Check_Insert___;
                    
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Add_Table__ (
   remove_rec_ IN remove_company_tab%ROWTYPE )
IS
   attr_          VARCHAR2(2000);
   newrec_        remove_company_tab%ROWTYPE;
   oldrec_        remove_company_tab%ROWTYPE;
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(2000);
   indrec_        Indicator_Rec;
BEGIN
   IF (Check_Exist___(remove_rec_.module, remove_rec_.table_name)) THEN
      oldrec_ := Lock_By_Keys___(remove_rec_.module, remove_rec_.table_name);
      newrec_ := oldrec_;
      attr_ := Pack___(remove_rec_);
      Unpack___(newrec_, indrec_, attr_);
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);    
      Check_Update___(oldrec_, newrec_, indrec_, attr_);   
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   ELSE
      newrec_ := remove_rec_;
      New___(newrec_);
   END IF;
END Add_Table__;


PROCEDURE Remove_Table__ (
   module_     IN VARCHAR2,
   table_name_ IN VARCHAR2 )
IS
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(2000);
   remrec_        remove_company_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, module_, table_name_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Delete___(objid_, remrec_);
   --remove detail rows
   DELETE
      FROM remove_company_detail_tab
      WHERE module = module_
      AND   table_name = table_name_;
END Remove_Table__;


PROCEDURE Start_Remove_Company__ (
   company_     IN  VARCHAR2 )
IS
   component_                  VARCHAR2(6);
   idum_                       NUMBER;
   num_                        NUMBER;
   pkg_name_                   VARCHAR2(30);
   proc_name_                  VARCHAR2(20) := 'DROP_COMPANY';
   method_name_                VARCHAR2(20) := 'REMOVE_COMPANY';
   default_company_for_user_   User_Profile_Entry.Entry_Value%TYPE;
   users_                      VARCHAR2(2000);
   counter_                    NUMBER := 0;
   stmt_                       VARCHAR2(100);
   check_stmt_                 VARCHAR2(100);
   result_                     VARCHAR2(20);
   records_                    VARCHAR2(20);
   cid_                        INTEGER;
   bindinpar_                  VARCHAR2(2000) ;
   ignore_                     INTEGER;
   site_exist                  EXCEPTION;
   person_company_exist        EXCEPTION;
   org_company_exist           EXCEPTION;
   wage_class_company_exist    EXCEPTION;
   proj_exist                  EXCEPTION;
   employee_exist              EXCEPTION;
   default_company             EXCEPTION;
   default_company_long        EXCEPTION;
   check_other_data            EXCEPTION;
   i_                          PLS_INTEGER :=0;
   n_                          PLS_INTEGER :=0;
   userid_                     VARCHAR2(30);
   fnd_user_                   VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   -- 10 bind_parameters should be enough for some time
   bp1_                        VARCHAR2(30);
   bp2_                        VARCHAR2(30);
   bp3_                        VARCHAR2(30);
   bp4_                        VARCHAR2(30);
   bp5_                        VARCHAR2(30);
   bp6_                        VARCHAR2(30);
   bp7_                        VARCHAR2(30);
   bp8_                        VARCHAR2(30);
   bp9_                        VARCHAR2(30);
   bp10_                       VARCHAR2(30);
   num_binds_                  NUMBER := 0;
   TYPE remove_company_array IS TABLE OF VARCHAR2(100) NOT NULL;   
   remove_record_array_  remove_company_array;
   TYPE table_array IS TABLE OF VARCHAR2(100) NOT NULL; 
   table_array_                table_array;
   TYPE dependency_array IS TABLE OF VARCHAR2(100) NOT NULL;
   dependency_array_           dependency_array;
   table_                      VARCHAR2(100);
   table_name_                 VARCHAR2(100);
   TYPE OtherTableType  IS REF CURSOR;
   check_data_                 OtherTableType;  
   -- If component is not active then do not do anything for the component.   
   CURSOR get_component IS
      SELECT module, use_make_company
      FROM   crecomp_component
      WHERE  Dictionary_SYS.Component_Is_Active_Num(module) = 1
      ORDER BY component_seq DESC;
   CURSOR ordertabs IS
      SELECT exec_order, r.table_name AS table_name,t.package
      FROM   crecomp_component_lu_tab t
      INNER JOIN Dictionary_Sys_Active d ON (t.module = d.module) AND (t.lu = d.lu_name)
      INNER JOIN remove_company_tab r ON d.table_name = r.table_name
      WHERE  t.module = component_
      AND    t.exec_order IS NOT NULL
      AND EXISTS ( SELECT 1 
                   FROM   user_tables
                   WHERE  table_name = r.table_name )
      ORDER BY t.exec_order DESC;  
   CURSOR detail_info (table_name_ IN VARCHAR2) IS
      SELECT column_name, column_value
      FROM   remove_company_detail_tab rc
      WHERE  module = component_
      AND    table_name = table_name_;
   CURSOR column_detail(table_name_ IN VARCHAR2) IS
      SELECT column_name, column_value
      FROM   remove_company_detail_tab rc
      WHERE  table_name = table_name_;
   CURSOR get_pkg_name IS
      SELECT package_name name 
      FROM   dictionary_sys_package p
      WHERE EXISTS (SELECT 1 
                    FROM   dictionary_sys_lu l
                    WHERE  l.lu_name = p.lu_name
                    AND    l.module = component_);
   CURSOR check_drop_company IS
      SELECT 1 
      FROM   dictionary_sys_method
      WHERE  package_name = pkg_name_
      AND    UPPER(method_name) = 'DROP_COMPANY';
   CURSOR check_remove_company IS
      SELECT 1
      FROM   dictionary_sys_method
      WHERE  package_name = pkg_name_
      AND    UPPER(method_name) = 'REMOVE_COMPANY';
   -- If component is not active then do not do anything for the component.
   CURSOR other_table IS
      SELECT r.table_name AS table_name 
      FROM   crecomp_component_lu_tab t 
      INNER JOIN dictionary_sys_active d 
      ON     (t.module = d.module) 
      AND    (t.lu = d.lu_name) 
      RIGHT OUTER JOIN remove_company_tab r 
      ON     d.table_name = r.table_name 
      WHERE  t.exec_order IS NULL
      AND Dictionary_SYS.Component_Is_Active_Num(r.module) = 1
      AND EXISTS ( SELECT 1 
                   FROM   user_tables
                   WHERE  table_name = r.table_name );     
   $IF Component_Mpccom_SYS.INSTALLED $THEN
      CURSOR check_exist_site_public IS
         SELECT 1 
         FROM   site_public 
         WHERE  company = company_;    
   $END
   $IF Component_Person_SYS.INSTALLED $THEN
      CURSOR check_exist_person IS 
         SELECT 1 
         FROM   company_person 
         WHERE  emp_no <> 'SYS'
         AND    company_id = company_; 
      CURSOR check_exist_org IS
         SELECT 1 
         FROM   company_org 
         WHERE  company_id = company_;
   $END
   $IF Component_Proj_SYS.INSTALLED $THEN
      CURSOR check_exist_proj IS 
         SELECT 1 
         FROM   project
         WHERE  company = company_;   
   $END
   $IF Component_Mscom_SYS.INSTALLED $THEN
      CURSOR check_exist_employee IS 
         SELECT 1 
         FROM   employee 
         WHERE  company = company_;     
   $END
   $IF Component_Wrksch_SYS.INSTALLED $THEN
      CURSOR check_exist_wage_class IS
         SELECT 1 
         FROM   wage_class
         WHERE  company_id = company_;   
   $END
   $IF Component_Accrul_SYS.INSTALLED $THEN
      CURSOR check_exist_user_finance IS
         SELECT userid
         FROM   user_finance
         WHERE  company = company_;
   $END   
BEGIN
   IF (Company_API.Remove_Company_Allowed(company_) = 'TRUE') THEN
      Client_SYS.Add_To_Attr('DROP_COMPANY', company_, bindinpar_);
      cid_ := dbms_sql.open_cursor;
      $IF Component_Mpccom_SYS.INSTALLED $THEN
         OPEN check_exist_site_public; 
         FETCH check_exist_site_public INTO result_;
         IF (check_exist_site_public%FOUND) THEN
            IF (result_ = 1) THEN
               RAISE site_exist;
            END IF;
         END IF;
         CLOSE check_exist_site_public;
      $ELSE
         NULL;
      $END
      $IF Component_Person_SYS.INSTALLED $THEN
         OPEN check_exist_person;
         FETCH check_exist_person INTO result_;
         IF (check_exist_person%FOUND) THEN
            IF (result_ = 1) THEN
               RAISE person_company_exist;
            END IF;
         END IF;
         CLOSE check_exist_person;
         OPEN check_exist_org;
         FETCH check_exist_org INTO result_;
         IF (check_exist_org%FOUND) THEN
            IF (result_ = 1) THEN
               RAISE org_company_exist;
            END IF;
         END IF;
         CLOSE check_exist_org;
      $ELSE
         NULL;
      $END
      $IF Component_Wrksch_SYS.INSTALLED $THEN
         OPEN check_exist_wage_class;
         FETCH check_exist_wage_class INTO result_;
         IF (check_exist_wage_class%FOUND) THEN
            IF (result_ = 1) THEN
               RAISE wage_class_company_exist;
            END IF;
         END IF;
         CLOSE check_exist_wage_class;
      $ELSE
         NULL;
      $END
      $IF Component_Proj_SYS.INSTALLED $THEN
         OPEN check_exist_proj;
         FETCH check_exist_proj INTO result_;
         IF (check_exist_proj%FOUND) THEN
            IF (result_ = 1) THEN
               RAISE proj_exist;
            END IF;
         END IF;
         CLOSE check_exist_proj;
      $ELSE
         NULL;
      $END
      $IF Component_Mscom_SYS.INSTALLED $THEN
         OPEN check_exist_employee;
         FETCH check_exist_employee INTO result_;
         IF (check_exist_employee%FOUND) THEN
            IF (result_ = 1) THEN
               RAISE employee_exist;
            END IF;
         END IF;
         CLOSE check_exist_employee;
      $ELSE
         NULL;
      $END
      $IF Component_Mscom_SYS.INSTALLED $THEN
         OPEN check_exist_employee;
         FETCH check_exist_employee INTO result_;
         IF (check_exist_employee%FOUND) THEN
            IF (result_ = 1) THEN
               RAISE employee_exist;
            END IF;
         END IF;
         CLOSE check_exist_employee;
      $ELSE
         NULL;
      $END
      $IF Component_Accrul_SYS.INSTALLED $THEN
         OPEN check_exist_user_finance;
         FETCH check_exist_user_finance INTO userid_;
         WHILE (check_exist_user_finance%FOUND) LOOP
            default_company_for_user_ := User_Profile_SYS.Get_default('COMPANY', userid_);
            IF (default_company_for_user_ = company_) THEN
               counter_ := counter_ + 1;
               users_ := userid_;
            END IF;
            FETCH check_exist_user_finance INTO userid_;
         END LOOP;
         CLOSE check_exist_user_finance;
      $ELSE
         NULL;
      $END
      IF (counter_ = 1) THEN
         RAISE default_company;
      ELSIF (counter_ > 1) THEN
         RAISE default_company_long;
      END IF;
      $IF Component_Percos_SYS.INSTALLED $THEN
         Company_Cost_Alloc_Info_API.Remove_Company(company_);
      $END
      remove_record_array_ := remove_company_array('COMPANY_TAB','CREATE_COMPANY_LOG_IMP_TAB','CREATE_COMPANY_LOG_TAB','KEY_LU_TAB','KEY_LU_ATTRIBUTE_TAB','KEY_LU_TRANSLATION_TAB','KEY_MASTER_TAB','USER_PRIV_REMOVE_COMPANY_TAB');
      table_array_ := table_array('FOOTER_FIELD_TAB','FIN_SEL_TEMPL_VALUES_TAB','FIN_SEL_OBJ_TEMPL_DET_TAB','FIN_SEL_OBJ_TEMPL_TAB','FOOTER_CONNECTION_TAB','POSTING_CTRL_COMB_DET_SPEC_TAB',
                                  'POSTING_CTRL_DETAIL_SPEC_TAB','POSTING_CTRL_COMB_DETAIL_TAB','POSTING_CTRL_DETAIL_TAB','POSTING_CTRL_TAB','EMP_PRESE_ANALYSIS_TAB');
      dependency_array_ := dependency_array('TAX_CODE_PER_TAX_BOOK_TAB','PROJ_C_COST_EL_CODE_P_DEM_TAB', 'CASH_ACCOUNT_TEXT_TAB', 'CASH_ACCOUNT_TRANS_TYPES_TAB', 'CASH_ACCOUNT_USER_GROUPS_TAB', 
                                            'COMB_RULE_ID_TAB', 'FA_ID_SERIES_TAB', 'BUSINESS_UNIT_TAB','REVAL_CODE_PARTS_TAB');
      FOR check_ IN other_table LOOP
         Assert_SYS.Assert_Is_Table(check_.table_name);
         IF NOT (check_.table_name MEMBER OF remove_record_array_ OR check_.table_name MEMBER OF table_array_ OR check_.table_name MEMBER OF dependency_array_) THEN
            check_stmt_ := 'SELECT 1 ' || ' FROM '|| check_.table_name;
            table_name_ := check_.table_name;
            FOR c_ IN column_detail(check_.table_name) LOOP
               Assert_SYS.Assert_Is_Table_Column(check_.table_name, c_.column_name);
               check_stmt_ := check_stmt_ || ' WHERE ' || c_.column_name;
               IF (c_.column_value = '<COMPANY>') THEN 
                  check_stmt_ := check_stmt_ ||' = :company'; 
                  @ApproveDynamicStatement(2020-07-01,tkavlk)
                  OPEN check_data_ FOR check_stmt_ USING company_;
                  FETCH check_data_ INTO records_;
                  CLOSE check_data_;      
                     IF (records_ = 1) THEN
                        RAISE check_other_data;
                     END IF;      
               END IF;
            END LOOP;
         END IF;   
      END LOOP;
      -- Utility API related data manually handled
      $IF Component_Accrul_SYS.INSTALLED $THEN
         Footer_Field_API.Remove_Company(company_);
         Fin_Sel_Templ_Values_API.Remove_Company(company_);
         Fin_Sel_Obj_Templ_Det_API.Remove_Company(company_);
         Fin_Sel_Obj_Templ_API.Remove_Company(company_);
         Footer_Connection_API.Remove_Company(company_);
         Posting_Ctrl_Comb_Det_Spec_API.Remove_Company(company_);
         Posting_Ctrl_Detail_Spec_API.Remove_Company(company_); 
         Posting_Ctrl_Comb_Detail_API.Remove_Company(company_); 
         Posting_Ctrl_Detail_API.Remove_Company(company_);
         Posting_Ctrl_API.Remove_Company(company_);    
      $END
      User_Priv_Remove_Company_API.Remove_Company(company_);    
      FOR rec_ IN get_component LOOP
         component_ := rec_.module;
         IF (rec_.use_make_company = 'TRUE') THEN
            IF (component_ = 'ACCRUL') THEN
               $IF Component_Accrul_SYS.INSTALLED $THEN
                  OPEN check_exist_user_finance;
                  FETCH check_exist_user_finance INTO userid_;
                  WHILE (check_exist_user_finance%FOUND) LOOP                     
                     BEGIN
                        User_Profile_SYS.Remove_Value('COMPANY', userid_, company_);                        
                     EXCEPTION
                        WHEN OTHERS THEN
                           NULL;
                     END;                     
                     FETCH check_exist_user_finance INTO userid_;
                  END LOOP;
                  CLOSE check_exist_user_finance;
               $ELSE
                  NULL;
               $END 
            END IF;
            FOR b_ IN ordertabs LOOP
               Assert_SYS.Assert_Is_Table(b_.table_name);
               pkg_name_ := b_.package;
               OPEN check_remove_company;
               FETCH check_remove_company INTO num_;
                  IF (check_remove_company%FOUND) THEN
                     Assert_SYS.Assert_Is_Package_Method(pkg_name_, method_name_);
                     stmt_ := 'BEGIN ' || pkg_name_ || '.' || method_name_ || '(:company_); END;';
                     @ApproveDynamicStatement(2020-07-01,tkavlk)
                     EXECUTE IMMEDIATE stmt_ USING company_;
                  END IF;
               CLOSE check_remove_company;
               IF NOT (DATABASE_SYS.Method_Exist(pkg_name_, method_name_)) THEN
                  stmt_ := 'DELETE FROM '||b_.table_name;
                  i_ := 1;
                  FOR c_ IN detail_info(b_.table_name) LOOP
                     n_ := 1;
                     IF (i_ = 1) THEN
                        Assert_SYS.Assert_Is_Table_Column(b_.table_name, c_.column_name);
                        stmt_ := stmt_ ||' WHERE '||c_.column_name;
                        IF (c_.column_value = '<COMPANY>') THEN
                           stmt_ := stmt_||' = :company ';
                        ELSE
                           num_binds_ := num_binds_ + 1;
                           Assign_Binds___(stmt_, bp1_, bp2_, bp3_, bp4_, bp5_, bp6_, bp7_, bp8_, bp9_, bp10_, c_.column_value, num_binds_);
                        END IF;
                     ELSE
                        Assert_SYS.Assert_Is_Table_Column(b_.table_name, c_.column_name);
                        stmt_ := stmt_||' AND '||c_.column_name;
                        IF (c_.column_value = '<COMPANY>') THEN
                           stmt_ := stmt_||' = :company ';
                        ELSE
                           num_binds_ := num_binds_ + 1;
                           Assign_Binds___(stmt_, bp1_, bp2_, bp3_, bp4_, bp5_, bp6_, bp7_, bp8_, bp9_, bp10_, c_.column_value, num_binds_);
                        END IF;
                     END IF;
                     i_ := i_ +1;
                  END LOOP;
                  -- Check if any detail_info
                  IF (n_ > 0) THEN
                     @ApproveDynamicStatement(2005-11-15,ovjose)
                     dbms_sql.parse(cid_, stmt_, dbms_sql.native);
                     dbms_sql.bind_variable(cid_, ':company', company_);
                  ELSE
                     -- add default where statement on a column named company since no detail info exists                  
                     stmt_ := stmt_ ||' WHERE COMPANY = :company';                  
                     @ApproveDynamicStatement(2005-11-15,ovjose)
                     dbms_sql.parse(cid_, stmt_, dbms_sql.native);
                     dbms_sql.bind_variable(cid_, ':company', company_);
                  END IF;
                  IF (num_binds_ > 0) THEN
                     FOR j_ IN 1..num_binds_ LOOP
                        Bind_Variables___(bp1_, bp2_, bp3_, bp4_, bp5_, bp6_, bp7_, bp8_, bp9_, bp10_, cid_, j_);
                     END LOOP;
                  END IF;
                  ignore_ := dbms_sql.execute(cid_);
                  stmt_ := NULL;
                  n_ := 0;
                  Reset_Binds___(bp1_, bp2_, bp3_, bp4_, bp5_, bp6_, bp7_, bp8_, bp9_, bp10_);
                  num_binds_ := 0;
               END IF;
            END LOOP;
            @ApproveTransactionStatement(2009-05-21,ashelk)
            COMMIT;
         ELSIF (rec_.use_make_company = 'FALSE') THEN
            FOR c_ IN get_pkg_name LOOP
               pkg_name_ := c_.name;
               OPEN check_drop_company;
               FETCH check_drop_company INTO idum_;
               IF (check_drop_company%FOUND) THEN
                  Assert_SYS.Assert_Is_Package_Method(pkg_name_, proc_name_);
                  stmt_ := 'BEGIN ' || pkg_name_ || '.' || proc_name_ || '(:bindinpar_); END;';
                  @ApproveDynamicStatement(2005-11-10,ovjose)
                  EXECUTE IMMEDIATE stmt_ USING bindinpar_;
                  CLOSE check_drop_company;
                  @ApproveTransactionStatement(2009-05-21,ashelk)
                  COMMIT;
                  EXIT;
               END IF;
               CLOSE check_drop_company;
            END LOOP;
         END IF;
      END LOOP;
      $IF Component_Prjrep_SYS.INSTALLED $THEN
         Emp_Prese_Analysis_API.Remove_Company(company_);
      $END
      FOR j IN REVERSE 1..remove_record_array_.count LOOP
         table_ := remove_record_array_(j);
         Assert_SYS.Assert_Is_Table(table_);
         stmt_ := 'DELETE FROM '|| table_;
         i_ := 1;
         FOR c_ IN column_detail(table_) LOOP
            n_ := 1;
            IF (i_ = 1) THEN
               Assert_SYS.Assert_Is_Table_Column(remove_record_array_(j), c_.column_name);
               stmt_ := stmt_ ||' WHERE '||c_.column_name;
               IF (c_.column_value = '<COMPANY>') THEN
                  stmt_ := stmt_||' = :company ';
               ELSE
                  num_binds_ := num_binds_ + 1;
                  Assign_Binds___(stmt_, bp1_, bp2_, bp3_, bp4_, bp5_, bp6_, bp7_, bp8_, bp9_, bp10_, c_.column_value, num_binds_);
               END IF; 
            ELSE
               Assert_SYS.Assert_Is_Table_Column(remove_record_array_(j), c_.column_name);
               stmt_ := stmt_||' AND '||c_.column_name;
               IF (c_.column_value = '<COMPANY>') THEN
                  stmt_ := stmt_||' = :company ';
               ELSE
                  num_binds_ := num_binds_ + 1;
                  Assign_Binds___(stmt_, bp1_, bp2_, bp3_, bp4_, bp5_, bp6_, bp7_, bp8_, bp9_, bp10_, c_.column_value, num_binds_);
               END IF;
            END IF;
            i_ := i_ +1;
         END LOOP;
         -- Check if any detail_info
         IF (n_ > 0) THEN
            @ApproveDynamicStatement()
            dbms_sql.parse(cid_, stmt_, dbms_sql.native);
            dbms_sql.bind_variable(cid_, ':company', company_);
         ELSE
            -- add default where statement on a column named company since no detail info exists                  
            stmt_ := stmt_ ||' WHERE COMPANY = :company';                  
            @ApproveDynamicStatement()
            dbms_sql.parse(cid_, stmt_, dbms_sql.native);
            dbms_sql.bind_variable(cid_, ':company', company_);
         END IF;
         IF (num_binds_ > 0) THEN
            FOR j_ IN 1..num_binds_ LOOP
               Bind_Variables___(bp1_, bp2_, bp3_, bp4_, bp5_, bp6_, bp7_, bp8_, bp9_, bp10_, cid_, j_);
            END LOOP;
         END IF;
         ignore_ := dbms_sql.execute(cid_);
         stmt_ := NULL;
         n_ := 0;
         Reset_Binds___(bp1_, bp2_, bp3_, bp4_, bp5_, bp6_, bp7_, bp8_, bp9_, bp10_);
         num_binds_ := 0;
      END LOOP;
      @ApproveTransactionStatement()
      COMMIT;
      dbms_sql.close_cursor(cid_);
   ELSE
      Error_SYS.Appl_General(lu_name_, 'USERNOTALLOWED: User: :P1 are not allowed to remove company: :P2 ', fnd_user_, company_);
   END IF;
EXCEPTION
   WHEN site_exist THEN
      Error_SYS.Record_General(lu_name_, 'SITEEXIST: You can not remove Company :P1 because it is connected to a Site.', company_);
   WHEN person_company_exist THEN
      Error_SYS.Record_General(lu_name_, 'PERSONEXIST: You can not remove Company :P1 because it is connected to a Person.', company_);
   WHEN org_company_exist THEN
      Error_SYS.Record_General(lu_name_, 'ORGEXIST: You can not remove Company :P1 because it is connected to an Organization.', company_);
   WHEN wage_class_company_exist THEN
      Error_SYS.Record_General(lu_name_, 'WAGECLASSEXIST: You can not remove Company :P1 because it is connected to a Wage Class.', company_);
   WHEN proj_exist THEN
      Error_SYS.Record_General(lu_name_, 'PROJEXIST: You can not remove Company :P1 because it is connected to a Project.', company_);
   WHEN employee_exist THEN
      Error_SYS.Record_General(lu_name_, 'EMPLOYEEEXIST: You can not remove Company :P1 because it is connected to a Employee.', company_);
   WHEN default_company THEN
      Error_SYS.Record_General(lu_name_, 'DEFCOMP: You can not remove Company :P1 because it is Default Company for the user :P2.', company_, users_);
   WHEN default_company_long THEN
      Error_SYS.Record_General(lu_name_, 'DEFCOMPLONG: You can not remove Company :P1 because it is Default Company for the user :P2 and there are more user(s) that has Company :P3 as Default Company.', company_, users_, company_);
   WHEN check_other_data THEN
      Error_SYS.Appl_General(lu_name_, 'DATAAVAILABLE: Company :P1 can not be removed as user defined basic data or transactions exist (:P2).',  company_, table_name_);                  
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cid_)) THEN
         dbms_sql.close_cursor(cid_);
      END IF;
      RAISE;
END Start_Remove_Company__;


PROCEDURE Delete_Info__ (
   module_               IN VARCHAR2,
   remove_standard_only_ IN BOOLEAN )
IS
BEGIN
   IF (remove_standard_only_ = TRUE) THEN
      DELETE FROM remove_company_detail_tab rct
         WHERE EXISTS (SELECT * 
                       FROM   remove_company_tab rc
                       WHERE  module = module_
                       AND    rc.table_name =rct.table_name
                       AND    standard_table = 'TRUE');
      DELETE
      FROM remove_company_tab
      WHERE module = module_
      AND   standard_table = 'TRUE';
   ELSE
      DELETE
      FROM remove_company_tab
      WHERE module = module_;
      DELETE
      FROM remove_company_detail_tab
      WHERE module = module_;
   END IF;
END Delete_Info__;


PROCEDURE Add_Table_Detail__ (
   module_        IN VARCHAR2,
   table_name_    IN VARCHAR2,
   column_name_   IN VARCHAR2,
   column_value_  IN VARCHAR2 )
IS
BEGIN
   Remove_Company_Detail_API.Add_Table_Detail__(module_, table_name_, column_name_, column_value_);
END Add_Table_Detail__;
                                                                                    
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

