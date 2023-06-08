--------------------------------------------------------------------------
--  File:      POST_ORDER_UpdatePrepostedWithProj.sql
--
--  Module:    ORDER
--
--  Function:  The purpose of this script is to update records in CUSTOMER_ORDER_LINE_TAB for CO Lines with connected projects which are pre posted with activity but not manually connected.
--
--  Date    Sign     History
--  ------  -----    --------------------------------------------------------------------------------------------
--  210428  MalLlk   SC21R2-948, Rewrite the update statement with BULK UPDATE when updating CO lines, where connected projects which are
--  210428           pre posted with activity but not manually connected. Reason behind this correction is to avoid possible upgrade issue occoured
--  210428           due to unavailability of the primary key PRE_ACCOUNTING_PK, while parallel deploymeny with POST_Wo_UpgradeToTaskFramework.sql.
--  201014  OsAllk   SC2020R1-10455, Commented Component_Is_Installed to support ACTIVE/INACTIVE component.
--  170630  HaPulk   STRSC-9594, Removed usages Dbms_Output.Enable. 
--  170303  DilMlk   Bug 133558, Modified setting preposting for Customer Order Line Revenue by setting TRUE for replace_pre_posting_ parameter in Pre_Accounting_API.Set_Pre_Posting method call.
--  111003  Chselk   EASTTWO-15795 . Trimmed the ORA error code from the error message. Only showed the error message with error prefix.
--  110907  Chselk   EASTTWO-6816. Added setting preposting part for Customer Order Line Revenue.
--  110818  Chselk   PJDEAGLE-181. Created by moving the code section from Proj/database/PostInstallationDataPROJ.sql.
--  -------------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdatePrepostedWithProj.sql','Timestamp_1');
PROMPT Starting POST_ORDER_V1400_UpdatePrepostedWithProj.sql


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdatePrepostedWithProj.sql','Timestamp_2');
PROMPT Updating Customer Order Line connected projects which are pre posted with activity but not manually connected.

DECLARE
   CURSOR get_col_connected_projects IS
      SELECT pa.codeno_f pa_project_id, pa.activity_seq pa_activity_seq, col.order_no col_order_no, col.line_no col_line_no, col.rel_no col_rel_no, col.line_item_no col_line_item_no
      FROM   customer_order_line_tab col, pre_accounting_tab pa
      WHERE  col.pre_accounting_id = pa.pre_accounting_id
      AND    col.activity_seq IS NULL
      AND    nvl(pa.activity_seq, 0) != 0;
      
   TYPE col_connected_projects_tab IS TABLE OF get_col_connected_projects%ROWTYPE INDEX BY BINARY_INTEGER;
   col_connected_projects_tab_  col_connected_projects_tab; 
BEGIN   
   OPEN  get_col_connected_projects;
   FETCH get_col_connected_projects BULK COLLECT INTO col_connected_projects_tab_;
   CLOSE get_col_connected_projects;
      
   FORALL i_ IN col_connected_projects_tab_.FIRST.. col_connected_projects_tab_.LAST
      UPDATE customer_order_line_tab col
      SET    col.project_id   = col_connected_projects_tab_(i_).pa_project_id,
             col.activity_seq = col_connected_projects_tab_(i_).pa_activity_seq,
             col.supply_code  = DECODE(col.supply_code, 'NO', 'PRJ',
                                                        'IO', 'PI',
                                                        col.supply_code)
      WHERE  col.order_no     = col_connected_projects_tab_(i_).col_order_no
      AND    col.line_no      = col_connected_projects_tab_(i_).col_line_no
      AND    col.rel_no       = col_connected_projects_tab_(i_).col_rel_no
      AND    col.line_item_no = col_connected_projects_tab_(i_).col_line_item_no; 
END;
/
COMMIT;


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdatePrepostedWithProj.sql','Timestamp_3');
PROMPT Starting setting preposting for Customer Order Line Revenue (COLINEREV) project connections

DECLARE

   stmt_                    VARCHAR2(32000);
BEGIN
   --IF (Dictionary_SYS.Component_Is_Installed('PROJ')) THEN

         stmt_ := 'DECLARE

                      CURSOR colrec IS
                         SELECT col.order_no,
                                col.line_no,
                                col.rel_no,
                                col.line_item_no,
                                col.activity_seq,
                                col.project_id,
                                col.contract,
                                col.pre_accounting_id,
                                col.rowstate,
                                col.supply_code
                         FROM customer_order_line_tab col
                         WHERE col.activity_seq IS NOT NULL;

                      company_                       VARCHAR2(100);
                      proj_code_value_               VARCHAR2(30);
                      distr_proj_code_value_         VARCHAR2(30);

                      codeno_b_                      VARCHAR2(40);
                      codeno_c_                      VARCHAR2(40);
                      codeno_d_                      VARCHAR2(40);
                      codeno_e_                      VARCHAR2(40);
                      codeno_f_                      VARCHAR2(40);
                      codeno_g_                      VARCHAR2(40);
                      codeno_h_                      VARCHAR2(40);
                      codeno_i_                      VARCHAR2(40);
                      codeno_j_                      VARCHAR2(40);

                   BEGIN

                      FOR colrec_ IN colrec LOOP

                         BEGIN
                            IF (Project_Connection_API.Exist_Project_Connection(colrec_.activity_seq,colrec_.order_no,colrec_.line_no,colrec_.rel_no,colrec_.line_item_no, NULL, NULL,''COLINEREV'') = ''FALSE'') THEN

                               company_ := Site_API.Get_Company(colrec_.contract);
                               Pre_Accounting_API.Get_Project_Code_Value(proj_code_value_, distr_proj_code_value_, company_, colrec_.pre_accounting_id);

                               IF NOT (proj_code_value_ IS NOT NULL AND proj_code_value_ != colrec_.project_id) THEN

                                  Project_Pre_Accounting_API.Get_Pre_Accounting3(
                                                   codeno_b_,
                                                   codeno_c_,
                                                   codeno_d_,
                                                   codeno_e_,
                                                   codeno_f_,
                                                   codeno_g_,
                                                   codeno_h_,
                                                   codeno_i_,
                                                   codeno_j_,
                                                   colrec_.activity_seq);

                                  Pre_Accounting_API.Set_Pre_Posting(colrec_.pre_accounting_id,
                                                                     colrec_.contract,
                                                                     ''M104'',
                                                                     NULL,
                                                                     codeno_b_,
                                                                     codeno_c_,
                                                                     codeno_d_,
                                                                     codeno_e_,
                                                                     codeno_f_,
                                                                     codeno_g_,
                                                                     codeno_h_,
                                                                     codeno_i_,
                                                                     codeno_j_,
                                                                     colrec_.activity_seq,
                                                                     ''TRUE'',
                                                                     ''TRUE'');

                               END IF;
                            END IF;

                            EXCEPTION
                               WHEN OTHERS THEN
                                  dbms_output.put_line(''Error: '' || substr(SQLERRM, 11, 250));
                        END;
                      END LOOP;                      
                   EXCEPTION
                      WHEN OTHERS THEN                         
                         dbms_output.put_line(''Error: '' || substr(SQLERRM, 11, 250));
                   END;';

         EXECUTE IMMEDIATE stmt_;

   --END IF;
END;
/
COMMIT;


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdatePrepostedWithProj.sql','Timestamp_4');
PROMPT Finished with POST_ORDER_V1400_UpdatePrepostedWithProj.sql
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdatePrepostedWithProj.sql','Done');





