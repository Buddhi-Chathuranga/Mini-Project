-----------------------------------------------------------------------------
--
--  Logical unit: ImportedPartHistManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  121102  PraWLK  Bug 106070, Modified Delete_Part_Temp_Hist___() by removing unnecessary COMMIT statement.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Delete_Part_Temp_Hist___ (
   contract_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM imported_part_temp_hist_tab
   WHERE contract = contract_;
END Delete_Part_Temp_Hist___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Import_Daily_Issues_Priv__ (
   attr_ IN VARCHAR2 )
IS
   contract_      VARCHAR2(5);
   info_          VARCHAR2(2000);
   continue_      BOOLEAN := TRUE;
   
   CURSOR get_parts_temp_hist (in_contract_ IN VARCHAR2) IS
      SELECT part_no, issue_date, qty_issued, number_of_issues,
             row_number() over ( PARTITION BY part_no
                                 ORDER BY part_no )  AS row_num
      FROM imported_part_temp_hist_tab
      WHERE contract = in_contract_
      ORDER BY part_no;

   TYPE Hist_Part_Tab_Type IS TABLE OF get_parts_temp_hist%ROWTYPE
     INDEX BY BINARY_INTEGER;

   temp_hist_part_tab_       Hist_Part_Tab_Type;

BEGIN

   contract_ := Client_SYS.Get_Item_Value( 'CONTRACT', attr_ );

   OPEN get_parts_temp_hist(contract_);
   FETCH get_parts_temp_hist BULK COLLECT INTO temp_hist_part_tab_;
   CLOSE get_parts_temp_hist;

   IF (temp_hist_part_tab_.COUNT > 0) THEN
      FOR i IN temp_hist_part_tab_.FIRST..temp_hist_part_tab_.LAST LOOP
         IF temp_hist_part_tab_(i).row_num = 1 THEN
            IF NOT (Inventory_Part_API.Check_Exist(contract_, temp_hist_part_tab_(i).part_no)) THEN
               IF (Transaction_SYS.Is_Session_Deferred) THEN
                  info_ := Language_SYS.Translate_Constant (lu_name_, 'PARTNOTEXIST: Inventory Part :P1 does not exist on Site :P2.', NULL, temp_hist_part_tab_(i).part_no, contract_);
                  Transaction_SYS.Set_Status_Info(info_, 'WARNING');
                  continue_ := FALSE;
               END IF;
            END IF;
         END IF;
      END LOOP;
   
      IF (continue_) THEN
         FOR i IN temp_hist_part_tab_.FIRST..temp_hist_part_tab_.LAST LOOP
            Imported_Part_Daily_Hist_API.Insert_Update(contract_,
                                                      temp_hist_part_tab_(i).part_no,
                                                      temp_hist_part_tab_(i).issue_date,
                                                      temp_hist_part_tab_(i).qty_issued,
                                                      temp_hist_part_tab_(i).number_of_issues);
            
         END LOOP;

         Modify_Stat_Issue_Dates__(contract_);

         Aggr_Issues_To_Period_Hist__(contract_);

         Inventory_Value_Calc_API.Calculate_Inventory_Value(contract_, 'FALSE');

         Verify_Period_Series__(contract_);

         Delete_Part_Temp_Hist___(contract_);

      END IF;
   END IF;
END Import_Daily_Issues_Priv__;


PROCEDURE Modify_Stat_Issue_Dates__ (
   contract_ IN VARCHAR2 )
IS
   
   CURSOR get_stst_issue_dates (in_contract_ IN VARCHAR2) IS
      SELECT part_no, MIN(issue_date) first_stat_issue_date, MAX(issue_date) latest_stat_issue_date
      FROM imported_part_daily_hist_tab 
      WHERE contract = in_contract_
      GROUP BY part_no;

   TYPE Stst_Issue_dates_Tab_Type IS TABLE OF get_stst_issue_dates%ROWTYPE
     INDEX BY BINARY_INTEGER;

   stat_issue_dates_tab_       Stst_Issue_dates_Tab_Type;

BEGIN

   OPEN get_stst_issue_dates(contract_);
   FETCH get_stst_issue_dates BULK COLLECT INTO stat_issue_dates_tab_;
   CLOSE get_stst_issue_dates;

   IF (stat_issue_dates_tab_.COUNT > 0) THEN
      FOR i IN stat_issue_dates_tab_.FIRST..stat_issue_dates_tab_.LAST LOOP
         -- Update First_Stat_Issue_Date
         Inventory_Part_API.Modify_Latest_Stat_Issue_Date(contract_,
                                                   stat_issue_dates_tab_(i).part_no,
                                                   stat_issue_dates_tab_(i).first_stat_issue_date);

         -- Update Latest_Stat_Issue_Date
         Inventory_Part_API.Modify_Latest_Stat_Issue_Date(contract_,
                                                   stat_issue_dates_tab_(i).part_no,
                                                   stat_issue_dates_tab_(i).latest_stat_issue_date);
      END LOOP;
   END IF;
END Modify_Stat_Issue_Dates__;


PROCEDURE Aggr_Issues_To_Period_Hist__ (
   contract_ IN VARCHAR2 )
IS
  
   CURSOR get_period_info (in_contract_ IN VARCHAR2) IS
      SELECT DISTINCT pdh.part_no, sp.stat_year_no, sp.stat_period_no
      FROM imported_part_daily_hist_tab pdh,
           statistic_period_pub sp
      WHERE pdh.contract = in_contract_
      AND pdh.included_in_period_hist = 'FALSE' 
      AND pdh.issue_date BETWEEN sp.begin_date AND sp.end_date;

   CURSOR get_part_period_hist (in_contract_ IN VARCHAR2, in_part_no_ IN VARCHAR2,
                                in_stat_year_no_ IN NUMBER, in_stat_period_no_ IN NUMBER) IS
      SELECT pdh.part_no, sp.stat_year_no, sp.stat_period_no,
             SUM(pdh.qty_issued) qty_issued, SUM(pdh.number_of_issues) number_of_issues
      FROM imported_part_daily_hist_tab pdh,
           statistic_period_pub sp
      WHERE pdh.contract = in_contract_
      AND pdh.part_no = in_part_no_
      AND sp.stat_year_no = in_stat_year_no_
      AND sp.stat_period_no = in_stat_period_no_
      AND pdh.issue_date BETWEEN sp.begin_date AND sp.end_date 
      GROUP BY pdh.part_no, sp.stat_year_no, sp.stat_period_no;

   CURSOR get_part_daily_hist (in_contract_ IN VARCHAR2, in_part_no_ IN VARCHAR2,
                                in_stat_year_no_ IN NUMBER, in_stat_period_no_ IN NUMBER) IS
      SELECT pdh.part_no, pdh.issue_date
      FROM imported_part_daily_hist_tab pdh,
           statistic_period_pub sp
      WHERE pdh.contract = in_contract_
      AND pdh.part_no = in_part_no_
      AND sp.stat_year_no = in_stat_year_no_
      AND sp.stat_period_no = in_stat_period_no_
      AND pdh.issue_date BETWEEN sp.begin_date AND sp.end_date; 
      
   TYPE Period_Info_Tab_Type IS TABLE OF get_period_info%ROWTYPE
     INDEX BY BINARY_INTEGER;

   period_info_tab_       Period_Info_Tab_Type;
   
BEGIN

   OPEN get_period_info(contract_);
   FETCH get_period_info BULK COLLECT INTO period_info_tab_;
   CLOSE get_period_info;

   IF (period_info_tab_.COUNT > 0) THEN
      
      FOR i IN period_info_tab_.FIRST..period_info_tab_.LAST LOOP
         FOR period_hist_rec_ IN get_part_period_hist(contract_, 
                                                      period_info_tab_(i).part_no,
                                                      period_info_tab_(i).stat_year_no,
                                                      period_info_tab_(i).stat_period_no) LOOP
            
            Imported_Part_Period_Hist_API.Insert_Update(contract_,
                                                   period_hist_rec_.part_no,
                                                   period_hist_rec_.stat_year_no,
                                                   period_hist_rec_.stat_period_no,
                                                   period_hist_rec_.qty_issued,
                                                   period_hist_rec_.number_of_issues);

         END LOOP;
      END LOOP;

      -- Update included_in_period_hist
      FOR i IN period_info_tab_.FIRST..period_info_tab_.LAST LOOP
         FOR daily_hist_rec_ IN get_part_daily_hist(contract_, 
                                                      period_info_tab_(i).part_no,
                                                      period_info_tab_(i).stat_year_no,
                                                      period_info_tab_(i).stat_period_no) LOOP
            
            Imported_Part_Daily_Hist_API.Modify_Included_In_Period_Hist(contract_,
                                                   daily_hist_rec_.part_no,
                                                   daily_hist_rec_.issue_date,
                                                   'TRUE');

         END LOOP;
      END LOOP;
   END IF;
END Aggr_Issues_To_Period_Hist__;


PROCEDURE Verify_Period_Series__ (
   contract_ IN VARCHAR2 )
IS
   begin_date_   DATE;

   CURSOR get_part_periods (in_contract_ IN VARCHAR2) IS
      SELECT part_no, stat_year_no, stat_period_no
      FROM (SELECT part_no, stat_year_no, stat_period_no,
             row_number() over ( PARTITION BY part_no
                                 ORDER BY part_no )  AS row_num                    
            FROM (SELECT part_no, stat_year_no, stat_period_no 
                  FROM imported_part_period_hist_tab 
                  WHERE contract = in_contract_
                  UNION
                  SELECT part_no, stat_year_no, stat_period_no
                  FROM inventory_part_period_hist_tab 
                  WHERE contract = in_contract_)
            ORDER BY part_no, stat_year_no, stat_period_no)
      WHERE  row_num = 1;

   CURSOR get_hole_periods (in_contract_ IN VARCHAR2, in_part_no_ IN VARCHAR2,
                            in_start_date_ IN DATE, in_end_date_ IN DATE)IS
      SELECT stat_year_no, stat_period_no
         FROM  statistic_period_pub 
         WHERE begin_date BETWEEN in_start_date_ AND in_end_date_ 
      MINUS 
     (SELECT  stat_year_no, stat_period_no 
         FROM imported_part_period_hist_tab 
         WHERE contract = in_contract_
         AND part_no = in_part_no_

      UNION

      SELECT stat_year_no, stat_period_no
         FROM inventory_part_period_hist_tab 
         WHERE contract = in_contract_ 
         AND part_no = in_part_no_);

   TYPE Part_Period_Tab_Type IS TABLE OF get_part_periods%ROWTYPE
     INDEX BY BINARY_INTEGER;

   part_periods_tab_       Part_Period_Tab_Type;

BEGIN

   OPEN get_part_periods(contract_);
   FETCH get_part_periods BULK COLLECT INTO part_periods_tab_;
   CLOSE get_part_periods;

   IF (part_periods_tab_.COUNT > 0) THEN
      FOR i IN part_periods_tab_.FIRST..part_periods_tab_.LAST LOOP

         begin_date_:= Statistic_Period_API.Get_Begin_Date(part_periods_tab_(i).stat_year_no,
                                                           part_periods_tab_(i).stat_period_no);

         FOR hole_period_rec_ IN get_hole_periods(contract_, part_periods_tab_(i).part_no,
                                                  begin_date_, SYSDATE) LOOP

            Imported_Part_Period_Hist_API.Insert_Update(contract_,
                                                   part_periods_tab_(i).part_no,
                                                   hole_period_rec_.stat_year_no,
                                                   hole_period_rec_.stat_period_no,
                                                   0,
                                                   0);

         END LOOP;
      END LOOP;
   END IF;
END Verify_Period_Series__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Import_Daily_Issues (
   contract_ IN VARCHAR2 )
IS
   attr_             VARCHAR2(32000);
   batch_desc_       VARCHAR2(100);
   current_contract_ VARCHAR2(5);

   CURSOR get_contracts (in_contract_ IN VARCHAR2) IS
      SELECT site contract
      FROM user_allowed_site_pub
      WHERE site LIKE NVL(in_contract_,'%');

   TYPE Contract_Tab_Type IS TABLE OF get_contracts%ROWTYPE
     INDEX BY BINARY_INTEGER;
   contract_tab_       Contract_Tab_Type;
BEGIN

   User_Allowed_Site_API.Exist_With_Wildcard(contract_);

   OPEN get_contracts(contract_);
   FETCH get_contracts BULK COLLECT INTO contract_tab_;
   CLOSE get_contracts;
   
   IF (contract_tab_.COUNT > 0) THEN
      FOR i IN contract_tab_.FIRST..contract_tab_.LAST LOOP
         current_contract_ := contract_tab_(i).contract;
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('CONTRACT', current_contract_, attr_);
   
         batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'IMPORTISSUES: Import Daily Issues from External Source for Site ');
         batch_desc_ := batch_desc_ || ' ' || current_contract_;
         Transaction_SYS.Deferred_Call('IMPORTED_PART_HIST_MANAGER_API.Import_Daily_Issues_Priv__', attr_, batch_desc_);
      END LOOP;
   END IF;
END Import_Daily_Issues;



