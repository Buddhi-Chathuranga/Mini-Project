-----------------------------------------------------------------------------
--
--  Logical unit: ClassifyInventoryPart
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210803  JaThlk  SC21R2-2192, Modified Classify_Parts___ to set frequency_class_locked_ and lifecycle_stage_locked_ to false 
--  210803          when the lock until dates are not greater than or equal to today. 
--  210601  JaThlk  SC21R2-1009, Modified Classify_Parts___ to prevent updating of INVENTORY_PART_TAB if there are manually entered values for
--  210601          abc_class, frequency_class or lifecycle_stage.
--  170809  ErRalk  Bug 135979, Changed the error message constant from NOSEASON to IGNORESEASON in Load_Periods_For_Season___ to eliminate duplication of message constant.
--  141201  AwWelk  GEN-239, Modified Get_Stat_Issue_Dates___() by removing decline_issue_counter_ and expired_issue_counter_ OUT params. Modified
--  141201          Get_Lifecycle_Stage_Db___() to get the correct lifecycle stage considering the issue counters and decline/expiry issue limits.
--  141107  AwWelk  GEN-184, Modified Get_Lifecycle_Stage_Db___() for the field change EXPIRED_TO_MATURE_ISSUES to EXPIRED_TO_INTRO_ISSUES.
--  141029  AwWelk  GEN-48, Modified Get_Stat_Issue_Dates___(), Get_Lifecycle_Stage_Db___() to consider decline_to_mature_issues and
--  141029          expired_to_mature_issues with issue counters.
--  141022  AwWelk  GEN-43, Modified Get_Frequency_Class_Db___() to use new frequency class VERY SLOW MOVER.
--  130731  UdGnlk  TIBE-828, Removed the dynamic code and modify to conditional compilation.
--  121011  MaMalk  Bug 102071, Modified the methods Classify and Validate_Params to handle the db value for cost_type parameter.
--  120308  AyAmlk  Bug 101297, Increased the length of batch_desc_ to 200 in Classify().
--  120130  PraWlk  Bug 99404, Modified Load_Part_Volume_Value___() by changing the cursors get_issue_history and get_imported_issue_history to get  
--  120130          the superseded_by value using the method Inventory_Part_API.Get_Superseded_By(). Added new parameter part_no to 
--  120130          Get_Lifecycle_Stage_Db___() and passed part_no value to it from Classify_Parts___().
--  110627  Asawlk  Bug 95507, Modified Classify_Parts___() to perform the ABC classification when total_volume_value_ > 0,
--  110627          otherwise set the abc class to 'C'.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Info_Display_Tab IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Cost_Set___ (
   contract_ IN VARCHAR2,
   cost_set_ IN NUMBER )
IS
BEGIN

   $IF (Component_Cost_SYS.INSTALLED) $THEN
      IF (Site_API.Check_Exist(contract_) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_,'SITECOSTSET: When a Cost Set is given then Site must be given without wild card characters.');
      END IF;
      Cost_Set_API.Exist(contract_,cost_set_);               
   $ELSE
      Error_SYS.Record_General(lu_name_,'NOCOSTSET: Cost Set cannot be given since Costing is not installed.');
   $END
END Check_Cost_Set___;


PROCEDURE Check_Cost_Set_Cost_Type___ (
   contract_     IN VARCHAR2,
   cost_set_     IN NUMBER,
   cost_type_db_ IN VARCHAR2 )
IS
BEGIN

   IF ((cost_set_ IS     NULL AND cost_type_db_ IS     NULL) OR
       (cost_set_ IS NOT NULL AND cost_type_db_ IS NOT NULL)) THEN
      Error_SYS.Record_General(lu_name_,'COSTSETCOSTTYPE: Either Cost Set or Cost Type must be given.');
   END IF;

   IF (cost_set_ IS NOT NULL) THEN
      Check_Cost_Set___(contract_, cost_set_);
   END IF;

   IF (cost_type_db_ IS NOT NULL) THEN
      Inventory_Cost_Type_API.Exist_Db(cost_type_db_);
   END IF;

END Check_Cost_Set_Cost_Type___;


PROCEDURE Check_Number_Of_Periods___ (
   number_of_periods_ IN NUMBER )
IS
BEGIN

   IF (number_of_periods_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_,'NULLPERIOD: You must enter a value for the desired number of periods.');
   ELSE
      IF ((number_of_periods_ <= 0) OR (number_of_periods_ != ROUND(number_of_periods_))) THEN
         Error_SYS.Record_General(lu_name_,'PERPOSINT: The desired number of periods must be a positive integer.');
      END IF;
   END IF;
   
END Check_Number_Of_Periods___;


PROCEDURE Check_Parameters___ (
   contract_          IN VARCHAR2,
   cost_set_          IN NUMBER,
   cost_type_db_      IN VARCHAR2,
   number_of_periods_ IN NUMBER )
IS
BEGIN

   User_Allowed_Site_API.Exist_With_Wildcard(contract_);

   Check_Cost_Set_Cost_Type___(contract_, cost_set_, cost_type_db_);

   Check_Number_Of_Periods___(number_of_periods_);

END Check_Parameters___;


FUNCTION Get_Unit_Cost___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   cost_set_         IN NUMBER,
   cost_type_db_     IN VARCHAR2 ) RETURN NUMBER
IS
   unit_cost_ NUMBER;
   stmt_      VARCHAR2(2000);
BEGIN

   IF (cost_set_ IS NULL) THEN
      IF (cost_type_db_ = 'INVENTORY VALUE') THEN
         unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Config(
                                                                                contract_,
                                                                                part_no_,
                                                                                configuration_id_);
      ELSIF (cost_type_db_ = 'LATEST PURCHASE PRICE') THEN
         unit_cost_ := Inventory_Part_Config_API.Get_Latest_Purchase_Price(contract_,
                                                                           part_no_,
                                                                           configuration_id_);
      ELSIF (cost_type_db_ = 'AVERAGE PURCHASE PRICE') THEN
         unit_cost_ := Inventory_Part_Config_API.Get_Average_Purchase_Price(contract_,
                                                                            part_no_,
                                                                            configuration_id_);
      ELSE
         Error_SYS.Record_General(lu_name_,'COSTTYPE: Cost Type :P1 is not handled by the Part Classification bakground job.', Inventory_Cost_Type_API.Decode(cost_type_db_));
      END IF;
   ELSE
      stmt_ := 'BEGIN '                                                                 ||
                  ':unit_cost := Cost_Int_API.Get_Total_Cost_Per_Cost_Set(:contract, '  ||
                                                                         ':part_no, '   ||
                                                                         ':cost_set); ' ||
               'END;';
      @ApproveDynamicStatement(2008-10-24,lepese)
      EXECUTE IMMEDIATE stmt_ USING OUT unit_cost_,
                                    IN  contract_,
                                    IN  part_no_,
                                    IN  cost_set_;
   END IF;

   RETURN (NVL(unit_cost_,0));
END Get_Unit_Cost___;


PROCEDURE Load_Part_Volume_Value___ (
   total_volume_value_ IN OUT NUMBER,
   contract_           IN     VARCHAR2,
   cost_set_           IN     NUMBER,
   cost_type_db_       IN     VARCHAR2,
   asset_class_        IN     VARCHAR2,
   part_no_            IN     VARCHAR2,
   inherit_to_part_no_ IN     VARCHAR2 )
IS
   unit_cost_                NUMBER;
   volume_value_             NUMBER;
   quantity_issued_          NUMBER;
   number_of_issues_         NUMBER;
   previous_part_no_         inventory_part_tab.part_no%TYPE := Database_SYS.Get_First_Character;
   local_inherit_to_part_no_ inventory_part_tab.part_no%TYPE;

   CURSOR get_issue_history IS
      SELECT a.part_no,
             a.configuration_id,
             c.supersedes        supersedes_part_no,
             Inventory_Part_API.Get_Superseded_By(c.contract, c.part_no)   superseded_by_part_no,
             (SELECT NVL(SUM(mtd_issues),0)
                FROM inventory_part_period_hist_tab b
               WHERE a.part_no          = b.part_no
                 AND a.contract         = b.contract
                 AND a.configuration_id = b.configuration_id
                 AND (stat_year_no, stat_period_no) IN (SELECT stat_year_no,stat_period_no
                                                          FROM statistic_period_tmp))
             quantity_issued,
             (SELECT NVL(SUM(count_issues),0)
                FROM inventory_part_period_hist_tab b
               WHERE a.part_no          = b.part_no
                 AND a.contract         = b.contract
                 AND a.configuration_id = b.configuration_id
                 AND (stat_year_no, stat_period_no) IN (SELECT stat_year_no,stat_period_no
                                                          FROM statistic_period_tmp))
             number_of_issues
        FROM inventory_part_config_tab a,
             inventory_part_tab        c
       WHERE  a.contract    = contract_
         AND (a.part_no     = part_no_ OR part_no_ IS NULL)
         AND  a.contract    = c.contract
         AND  a.part_no     = c.part_no
         AND (c.asset_class = asset_class_ OR asset_class_ IS NULL)
      ORDER BY a.part_no;

   CURSOR get_imported_issue_history IS
      SELECT a.part_no,
             Inventory_Part_API.Get_Superseded_By(c.contract, c.part_no) superseded_by_part_no,
             SUM(qty_issued)       quantity_issued,
             SUM(number_of_issues) number_of_issues
        FROM imported_part_period_hist_tab a,
             inventory_part_tab            c
       WHERE  a.contract    = contract_
         AND (a.part_no     = part_no_ OR part_no_ IS NULL)
         AND  a.contract    = c.contract
         AND  a.part_no     = c.part_no
         AND (c.asset_class = asset_class_ OR asset_class_ IS NULL)
         AND ((stat_year_no, stat_period_no) IN (SELECT stat_year_no,stat_period_no
                                                          FROM statistic_period_tmp))
      GROUP BY a.part_no, Inventory_Part_API.Get_Superseded_By(c.contract, c.part_no);
BEGIN

   local_inherit_to_part_no_ := inherit_to_part_no_;

   IF (local_inherit_to_part_no_ IS NULL) THEN
      -- When this call is not recursively done we need to initialize the temporary table
      -- and the total volume value. But when the call is recursive we need to keep the data.
      DELETE FROM invent_part_volume_value_tmp;
      total_volume_value_ := 0;
   END IF;

   FOR history_rec_ IN get_issue_history LOOP

      IF ((history_rec_.superseded_by_part_no IS     NULL) OR
          (local_inherit_to_part_no_          IS NOT NULL)) THEN
         -- When the call is recursively done we need to consider the historical data although the
         -- superseded since the result will be store for the local_inherit_to_part_no_ which is the
         -- part number that is currently active, not superseded.
         quantity_issued_  := history_rec_.quantity_issued;
         number_of_issues_ := history_rec_.number_of_issues;
      ELSE
         -- The part has been superseded and we are not collecting data for the superseding part
         -- (local_inherit_to_part_no_ is NULL) so we should report zero statistics for this part. 
         quantity_issued_  := 0;
         number_of_issues_ := 0;
      END IF;

      IF (quantity_issued_ != 0) THEN
         -- No need to fetch the cost if the quantity is zero since the volume value will be zero.
         unit_cost_ := Get_Unit_Cost___(contract_,
                                        history_rec_.part_no,
                                        history_rec_.configuration_id,
                                        cost_set_,
                                        cost_type_db_);
      ELSE
         unit_cost_ := 0;
      END IF;

      volume_value_       := quantity_issued_ * unit_cost_;
      total_volume_value_ := total_volume_value_ + volume_value_;

      INSERT INTO invent_part_volume_value_tmp
         (part_no,
          volume_value,
          number_of_issues)
         VALUES
         (NVL(local_inherit_to_part_no_, history_rec_.part_no),
          volume_value_,
          number_of_issues_);

      IF ((history_rec_.supersedes_part_no IS NOT NULL) AND 
          (history_rec_.part_no != previous_part_no_)) THEN
         -- The part is superseding an older part so we need to find the statistics for the
         -- superseded part and store it on the part that should inherit this statistics.
         -- We need to make sure that we do this just once for each part number. Otherwise
         -- this will be a problem for configured parts where each configuration otherwise
         -- would inherit the statistics for every configuration of the superseded part. 
         -- The cursor is sorted by part_no to make sure we can handle this properly. 
         IF ((local_inherit_to_part_no_          IS NULL) AND
             (history_rec_.superseded_by_part_no IS NULL)) THEN
            -- This part is not replaced by any other and should inherit the statistics from the
            -- superseded parts. We might find several links in the superseding chain but all
            -- statistics should end up on the part that ultimately supersedes them all.
            local_inherit_to_part_no_ := history_rec_.part_no;
         END IF;

         IF (local_inherit_to_part_no_ IS NOT NULL) THEN
         -- Recursive call to find the statistics for the superseded part and store it on the
         -- part number that is the last link in the superseding chain. 
            Load_Part_Volume_Value___(total_volume_value_,
                                      contract_,
                                      cost_set_,
                                      cost_type_db_,
                                      NULL,
                                      history_rec_.supersedes_part_no,
                                      local_inherit_to_part_no_);
         END IF;
      END IF;

      IF (local_inherit_to_part_no_ = history_rec_.part_no) THEN
         -- We are back on the top level of the recursive call chain again. We can now break
         -- the inheritance chain and continue with the next part number.
         local_inherit_to_part_no_ := NULL;
      END IF;

      previous_part_no_ := history_rec_.part_no;

   END LOOP;

   FOR history_rec_ IN get_imported_issue_history LOOP

      IF ((history_rec_.superseded_by_part_no IS     NULL) OR
          (local_inherit_to_part_no_          IS NOT NULL)) THEN
         -- When the call is recursively done we need to consider the historical data although the
         -- superseded since the result will be store for the local_inherit_to_part_no_ which is the
         -- part number that is currently active, not superseded.
         quantity_issued_  := history_rec_.quantity_issued;
         number_of_issues_ := history_rec_.number_of_issues;
      ELSE
         -- The part has been superseded and we are not collecting data for the superseding part
         -- (local_inherit_to_part_no_ is NULL) so we should report zero statistics for this part. 
         quantity_issued_  := 0;
         number_of_issues_ := 0;
      END IF;

      IF (quantity_issued_ != 0) THEN
         -- No need to fetch the cost if the quantity is zero since the volume value will be zero.
         unit_cost_ := Get_Unit_Cost___(contract_,
                                        history_rec_.part_no,
                                        '*',
                                        cost_set_,
                                        cost_type_db_);
      ELSE
         unit_cost_ := 0;
      END IF;

      volume_value_       := quantity_issued_ * unit_cost_;
      total_volume_value_ := total_volume_value_ + volume_value_;

      INSERT INTO invent_part_volume_value_tmp
         (part_no,
          volume_value,
          number_of_issues)
         VALUES
         (NVL(local_inherit_to_part_no_, history_rec_.part_no),
          volume_value_,
          number_of_issues_);
   END LOOP;

END Load_Part_Volume_Value___;


FUNCTION Get_Frequency_Class_Db___ (
   number_of_issues_     IN NUMBER,
   number_of_days_       IN NUMBER,
   site_invent_info_rec_ IN Site_Invent_Info_API.Public_Rec,
   asset_class_rec_      IN Asset_Class_API.Public_Rec ) RETURN VARCHAR2
IS
   frequency_class_db_         VARCHAR2(20) := Inv_Part_Frequency_Class_API.DB_VERY_SLOW_MOVER;
   issues_per_year_            NUMBER;
   upper_limit_veryslow_mover_ NUMBER;
   upper_limit_slow_mover_     NUMBER;
   upper_limit_medium_mover_   NUMBER;
BEGIN

   IF (number_of_issues_ > 0) THEN
      issues_per_year_            := (number_of_issues_ / number_of_days_) * 365;
      
      upper_limit_veryslow_mover_ := NVL(asset_class_rec_.upper_limit_veryslow_mover,
                                        site_invent_info_rec_.upper_limit_veryslow_mover);
      
      upper_limit_slow_mover_     := NVL(asset_class_rec_.upper_limit_slow_mover,
                                         site_invent_info_rec_.upper_limit_slow_mover);

      upper_limit_medium_mover_   := NVL(asset_class_rec_.upper_limit_medium_mover,
                                         site_invent_info_rec_.upper_limit_medium_mover);

      IF (issues_per_year_ > upper_limit_medium_mover_) THEN
         frequency_class_db_ := Inv_Part_Frequency_Class_API.DB_FAST_MOVER;
      ELSIF (issues_per_year_ > upper_limit_slow_mover_) THEN
         frequency_class_db_ := Inv_Part_Frequency_Class_API.DB_MEDIUM_MOVER;
      ELSIF (issues_per_year_ > upper_limit_veryslow_mover_) THEN
         frequency_class_db_ := Inv_Part_Frequency_Class_API.DB_SLOW_MOVER;
      END IF;
   END IF;

   RETURN (frequency_class_db_);
END Get_Frequency_Class_Db___;


PROCEDURE Get_Stat_Issue_Dates___ (
   latest_stat_issue_date_ OUT DATE,
   first_stat_issue_date_  OUT DATE,
   part_rec_               IN  Inventory_Part_API.Public_Rec,
   contract_               IN  VARCHAR2 )
IS
   local_part_rec_ Inventory_Part_API.Public_Rec;
BEGIN

   -- If the part supersedes another part then start looping backwards
   -- in the supersession chain to find the very first and very latest
   -- Stat Issue Dates. Reason for this is that if a part is created to supersed
   -- an old Mature part then the new part should immediately become Mature.
   local_part_rec_ := part_rec_;

   LOOP
      IF (NVL(local_part_rec_.latest_stat_issue_date, Database_Sys.first_calendar_date_) > 
          NVL(latest_stat_issue_date_, Database_Sys.first_calendar_date_)) THEN
         -- Found a later latest_stat_issue_date
         latest_stat_issue_date_ := local_part_rec_.latest_stat_issue_date;
      END IF;

      IF (NVL(local_part_rec_.first_stat_issue_date, Database_Sys.last_calendar_date_) <
          NVL(first_stat_issue_date_, Database_Sys.last_calendar_date_)) THEN
         -- Found an earlier first_stat_issue_date
         first_stat_issue_date_ := local_part_rec_.first_stat_issue_date;
      END IF;
    
      EXIT WHEN local_part_rec_.supersedes IS NULL;

      local_part_rec_ := Inventory_Part_API.Get(contract_, local_part_rec_.supersedes);
   END LOOP;

END Get_Stat_Issue_Dates___;


FUNCTION Get_Lifecycle_Stage_Db___ (
   company_rec_     IN Company_Invent_Info_API.Public_Rec,
   part_rec_        IN Inventory_Part_API.Public_Rec,
   asset_class_rec_ IN Asset_Class_API.Public_Rec,
   today_           IN DATE,
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   lifecycle_stage_db_         VARCHAR2(20);
   days_of_inactivity_         NUMBER;
   days_since_introduction_    NUMBER;
   introduction_duration_days_ NUMBER;
   decline_inactivity_days_    NUMBER;
   expired_inactivity_days_    NUMBER;
   latest_stat_issue_date_     DATE;
   first_stat_issue_date_      DATE;
   decline_to_mature_issues_   NUMBER;
   expired_to_intro_issues_    NUMBER;

BEGIN

   -- The part has not been superseded.
   IF (Inventory_Part_API.Get_Superseded_By(contract_, part_no_) IS NULL) THEN
   Get_Stat_Issue_Dates___(latest_stat_issue_date_,
                           first_stat_issue_date_,
                           part_rec_,
                           contract_);

      days_of_inactivity_      := today_ - latest_stat_issue_date_;
      days_since_introduction_ := today_ - first_stat_issue_date_ + 1;

      introduction_duration_days_ := NVL(asset_class_rec_.introduction_duration_days,
                                         company_rec_.introduction_duration_days);
      decline_inactivity_days_    := NVL(asset_class_rec_.decline_inactivity_days,
                                         company_rec_.decline_inactivity_days);
      expired_inactivity_days_    := NVL(asset_class_rec_.expired_inactivity_days,
                                         company_rec_.expired_inactivity_days);
      decline_to_mature_issues_   := NVL(asset_class_rec_.decline_to_mature_issues,
                                         company_rec_.decline_to_mature_issues);
      expired_to_intro_issues_    := NVL(asset_class_rec_.expired_to_intro_issues,
                                         company_rec_.expired_to_intro_issues);


      IF (first_stat_issue_date_ IS NULL) THEN
         lifecycle_stage_db_ := 'DEVELOPMENT';
      ELSIF (days_since_introduction_ <= introduction_duration_days_) THEN
         lifecycle_stage_db_ := 'INTRODUCTION';
      ELSE
         IF (days_of_inactivity_ > expired_inactivity_days_) THEN
            lifecycle_stage_db_ := 'EXPIRED';
         ELSIF (days_of_inactivity_ > decline_inactivity_days_) THEN
            IF ((part_rec_.lifecycle_stage = 'EXPIRED') AND (part_rec_.expired_issue_counter < expired_to_intro_issues_)) THEN
               lifecycle_stage_db_ := 'EXPIRED';
            ELSE
               lifecycle_stage_db_ := 'DECLINE';
            END IF;
         ELSE
            IF ((part_rec_.lifecycle_stage = 'DECLINE') AND (part_rec_.decline_issue_counter < decline_to_mature_issues_)) THEN
               lifecycle_stage_db_ := 'DECLINE';
            ELSIF ((part_rec_.lifecycle_stage = 'EXPIRED') AND (part_rec_.expired_issue_counter < expired_to_intro_issues_)) THEN
               lifecycle_stage_db_ := 'EXPIRED';
            ELSE
               lifecycle_stage_db_ := 'MATURE';
            END IF;
         END IF;
      END IF;
   ELSE
      -- The part has been superseded and thereby immediately expired.
      lifecycle_stage_db_ := 'EXPIRED';
   END IF;

   RETURN (lifecycle_stage_db_);
END Get_Lifecycle_Stage_Db___;


PROCEDURE Classify_Parts___ (
   contract_                IN VARCHAR2,
   number_of_days_          IN NUMBER,
   site_invent_info_rec_    IN Site_Invent_Info_API.Public_Rec,
   total_volume_value_      IN NUMBER,
   company_invent_info_rec_ IN Company_Invent_Info_API.Public_Rec,
   today_                   IN DATE )
IS
   accumulated_volume_value_ NUMBER;
   class_a_                  VARCHAR2(1) := 'A';
   class_b_                  VARCHAR2(1) := 'B';
   class_c_                  VARCHAR2(1) := 'C';
   class_a_fraction_         NUMBER;
   class_b_fraction_         NUMBER;
   current_abc_class_        VARCHAR2(1);
   current_class_fraction_   NUMBER;
   frequency_class_db_       VARCHAR2(20);
   inventory_part_rec_       Inventory_Part_API.Public_Rec;
   lifecycle_stage_db_       VARCHAR2(20);
   asset_class_rec_          Asset_Class_API.Public_Rec;
   temp_abc_class_           VARCHAR2(1);
   frequency_class_locked_   BOOLEAN := FALSE;
   lifecycle_stage_locked_   BOOLEAN := FALSE;

   CURSOR get_part_volume_values IS
      SELECT part_no,
             SUM(volume_value) volume_value,
             SUM(number_of_issues) number_of_issues
        FROM invent_part_volume_value_tmp
        GROUP BY part_no
        ORDER BY volume_value DESC;
BEGIN

   IF (total_volume_value_ > 0) THEN
      class_a_fraction_       := Abc_Class_API.Get_Abc_Percent(class_a_) / 100;
      class_b_fraction_       := class_a_fraction_ + (Abc_Class_API.Get_Abc_Percent(class_b_) / 100);
      current_abc_class_      := class_a_;
      current_class_fraction_ := class_a_fraction_;
   ELSE
      current_abc_class_      := class_c_;
   END IF;

   accumulated_volume_value_ := 0;
   FOR part_rec_ IN get_part_volume_values LOOP

      inventory_part_rec_ := Inventory_Part_API.Get(contract_, part_rec_.part_no);

      IF (today_ <= inventory_part_rec_.freq_class_locked_until) THEN
         frequency_class_db_     := inventory_part_rec_.frequency_class;
         frequency_class_locked_ := TRUE;
      ELSE
         frequency_class_locked_ := FALSE;
      END IF;   
      
      IF (today_ <= inventory_part_rec_.life_stage_locked_until) THEN
         lifecycle_stage_db_     := inventory_part_rec_.lifecycle_stage;
         lifecycle_stage_locked_ := TRUE;
      ELSE
         lifecycle_stage_locked_ := FALSE;
      END IF; 
      
      IF (today_ <= inventory_part_rec_.abc_class_locked_until) THEN
         temp_abc_class_   := inventory_part_rec_.abc_class;
      ELSE
         temp_abc_class_ := current_abc_class_;
      END IF; 
      
      IF (NOT (frequency_class_locked_ AND lifecycle_stage_locked_))  THEN
         asset_class_rec_    := Asset_Class_API.Get(inventory_part_rec_.asset_class);
      END IF;
      
      IF (NOT frequency_class_locked_) THEN
         frequency_class_db_ := Get_Frequency_Class_Db___(part_rec_.number_of_issues,
                                                          number_of_days_,
                                                          site_invent_info_rec_,
                                                          asset_class_rec_);
      END IF;                                                 

      IF (NOT lifecycle_stage_locked_) THEN
         lifecycle_stage_db_ := Get_Lifecycle_Stage_Db___(company_invent_info_rec_,
                                                          inventory_part_rec_,
                                                          asset_class_rec_,
                                                          today_,
                                                          contract_,
                                                          part_rec_.part_no);
      END IF;                                                 

      IF ((temp_abc_class_  != inventory_part_rec_.abc_class)       OR
          (frequency_class_db_ != inventory_part_rec_.frequency_class) OR
          (lifecycle_stage_db_ != inventory_part_rec_.lifecycle_stage)) THEN

         Inventory_Part_API.Modify_Abc_Frequency_Lifecycle(contract_,
                                                           part_rec_.part_no,
                                                           temp_abc_class_,
                                                           frequency_class_db_,
                                                           lifecycle_stage_db_);
      END IF;

      Inventory_Part_Planning_API.Auto_Update_Planning_Method(contract_,
                                                              part_rec_.part_no,
                                                              temp_abc_class_,
                                                              frequency_class_db_,
                                                              lifecycle_stage_db_,
                                                              inventory_part_rec_);
      
      accumulated_volume_value_ := accumulated_volume_value_ + part_rec_.volume_value;

      IF (total_volume_value_ > 0) THEN
         IF (accumulated_volume_value_ / total_volume_value_ >= current_class_fraction_) THEN
            IF (current_abc_class_ = class_a_) THEN
               IF ((accumulated_volume_value_ / total_volume_value_) >= class_b_fraction_) THEN
                  current_abc_class_      := class_c_;
                  current_class_fraction_ := 1;
               ELSE
                  current_abc_class_      := class_b_;
                  current_class_fraction_ := class_b_fraction_;
               END IF;
            ELSIF (current_abc_class_ = class_b_) THEN
               current_abc_class_      := class_c_;
               current_class_fraction_ := 1;
            END IF;
         END IF;
      END IF;
   END LOOP;
END Classify_Parts___;


FUNCTION Period_Exist___ (
   contract_       IN VARCHAR2,
   stat_year_no_   IN NUMBER,
   stat_period_no_ IN NUMBER ) RETURN BOOLEAN
IS
   period_exist_ BOOLEAN := FALSE;
BEGIN
   IF (Inventory_Part_Period_Hist_API.Period_Exist(contract_, stat_year_no_, stat_period_no_)) THEN
      period_exist_ := TRUE;
   ELSE
      period_exist_ := Imported_Part_Period_Hist_API.Period_Exist(contract_, stat_year_no_, stat_period_no_);
   END IF;

   RETURN(period_exist_);
END Period_Exist___;


PROCEDURE Load_Periods_For_No_Season___ (
   number_of_days_                OUT NUMBER,
   info_display_tab_           IN OUT Info_Display_Tab,
   contract_                   IN     VARCHAR2,
   number_of_periods_          IN     NUMBER,
   today_                      IN     DATE )
IS 
   stat_year_no_                NUMBER;
   stat_period_no_              NUMBER;
   begin_year_no_               NUMBER;
   begin_period_no_             NUMBER;
   end_year_no_                 NUMBER;
   end_period_no_               NUMBER;
   current_year_no_             NUMBER;
   current_period_no_           NUMBER;
   latest_history_period_found_ BOOLEAN := FALSE;
   latest_period_is_current_    BOOLEAN := FALSE;
   period_counter_              NUMBER := 0;
   info_                        VARCHAR2(2000);
BEGIN

   Statistic_Period_API.Get_Statistic_Period(stat_year_no_, stat_period_no_, today_);
   current_year_no_   := stat_year_no_;
   current_period_no_ := stat_period_no_;

   DELETE FROM statistic_period_tmp;

   LOOP
      IF (Period_Exist___(contract_, stat_year_no_, stat_period_no_)) THEN
         IF (latest_history_period_found_) THEN

            INSERT INTO statistic_period_tmp
               (stat_year_no,
                stat_period_no)
               VALUES
               (stat_year_no_,
                stat_period_no_);

            period_counter_  := period_counter_ + 1;
            begin_year_no_   := stat_year_no_;
            begin_period_no_ := stat_period_no_;

            IF (end_year_no_ IS NULL) THEN
               end_year_no_   := stat_year_no_;
               end_period_no_ := stat_period_no_;
               IF NOT (latest_period_is_current_) THEN
                  IF NOT (info_display_tab_(4)) THEN
                     info_ := Language_SYS.Translate_Constant(lu_name_, 'LATESTHISTORY: Statistical information has not been aggregated for period :P1 on site :P2. The last period that will be considered is :P3.', NULL, current_year_no_||'-'||current_period_no_, contract_, end_year_no_||'-'||end_period_no_);
                     Transaction_SYS.Set_Status_Info(info_);
                     info_display_tab_(4) := TRUE;
                  END IF;
               END IF;
            END IF;
         ELSE
            latest_history_period_found_ := TRUE;
            IF ((stat_year_no_   = current_year_no_) AND
                (stat_period_no_ = current_period_no_)) THEN
               latest_period_is_current_ := TRUE;
            END IF;
         END IF;
      ELSE
         IF (latest_history_period_found_) THEN
            EXIT;
         END IF;
      END IF;

      EXIT WHEN (period_counter_ = number_of_periods_);

      Statistic_Period_API.Get_Previous_Period(stat_year_no_,
                                               stat_period_no_,
                                               stat_year_no_,
                                               stat_period_no_);
      EXIT WHEN stat_year_no_ IS NULL;
   END LOOP;

   IF (period_counter_ = 0) THEN
      IF NOT (info_display_tab_(2)) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NOHISTORY: Classification not performed on site :P1 because no statistical information was found.', NULL, contract_);
         Transaction_SYS.Set_Status_Info(info_);
         info_display_tab_(2) := TRUE;
      END IF;
   ELSIF (period_counter_ < number_of_periods_) THEN
      IF NOT (info_display_tab_(3)) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'LESSHISTORY: Classification on site :P1 was performed on :P2 periods because statistical information was not found for :P3 periods.', NULL, contract_, period_counter_, number_of_periods_);
         Transaction_SYS.Set_Status_Info(info_);
         info_display_tab_(3) := TRUE;
      END IF;
   END IF;

   IF (begin_year_no_ IS NOT NULL) THEN
      number_of_days_ := Statistic_Period_API.Get_Number_Of_Days(begin_year_no_,
                                                                 begin_period_no_,
                                                                 end_year_no_,
                                                                 end_period_no_);
   END IF;

END Load_Periods_For_No_Season___;


PROCEDURE Load_Periods_For_Season___ (
   number_of_days_                OUT NUMBER,
   info_display_tab_           IN OUT Info_Display_Tab,
   contract_                   IN     VARCHAR2,
   number_of_periods_          IN     NUMBER,
   today_                      IN     DATE )
IS 
   stat_year_no_                NUMBER;
   stat_period_no_              NUMBER;
   begin_year_no_               NUMBER;
   begin_period_no_             NUMBER;
   end_year_no_                 NUMBER;
   end_period_no_               NUMBER;
   next_year_no_                NUMBER;
   next_period_no_              NUMBER;
   period_counter_              NUMBER := 0;
   info_                        VARCHAR2(2000);
   exit_procedure_              EXCEPTION;
BEGIN

   Statistic_Period_API.Get_Statistic_Period(stat_year_no_,
                                             stat_period_no_,
                                             ADD_MONTHS(today_, -12));

   IF NOT (Period_Exist___(contract_, stat_year_no_, stat_period_no_)) THEN

      IF NOT (info_display_tab_(1)) THEN         
         info_ := Language_SYS.Translate_Constant(lu_name_, 'IGNORESEASON: The Seasonal Demand Pattern must be ignored since there is no statistical information for statistic period :P1 on site :P2.', NULL, stat_year_no_||'-'||stat_period_no_, contract_);
         Transaction_SYS.Set_Status_Info(info_);
         info_display_tab_(1) := TRUE;
      END IF;
      Load_Periods_For_No_Season___(number_of_days_,
                                    info_display_tab_,
                                    contract_,
                                    number_of_periods_,
                                    today_);
      RAISE exit_procedure_;
   END IF;

   DELETE FROM statistic_period_tmp;

   LOOP
      IF (Period_Exist___(contract_, stat_year_no_, stat_period_no_)) THEN

         Statistic_Period_API.Get_Next_Period(next_year_no_,
                                              next_period_no_,
                                              stat_year_no_,
                                              stat_period_no_);

         IF NOT (Period_Exist___(contract_, next_year_no_, next_period_no_)) THEN
            EXIT;
         END IF;

         INSERT INTO statistic_period_tmp
            (stat_year_no,
             stat_period_no)
            VALUES
            (stat_year_no_,
             stat_period_no_);

         period_counter_  := period_counter_ + 1;
         end_year_no_     := stat_year_no_;
         end_period_no_   := stat_period_no_;

         IF (begin_year_no_ IS NULL) THEN
            begin_year_no_   := stat_year_no_;
            begin_period_no_ := stat_period_no_;
         END IF;
      ELSE
         EXIT;
      END IF;

      EXIT WHEN (period_counter_ = number_of_periods_);

      Statistic_Period_API.Get_Next_Period(stat_year_no_,
                                           stat_period_no_,
                                           stat_year_no_,
                                           stat_period_no_);
      EXIT WHEN stat_year_no_ IS NULL;
   END LOOP;

   IF (period_counter_ = 0) THEN
      IF NOT (info_display_tab_(6)) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NOSEASON: Classification not performed for asset classes with Seasonal Demand Pattern on site :P1 because no complete statistical information was found.', NULL, contract_);
         Transaction_SYS.Set_Status_Info(info_);
         info_display_tab_(6) := TRUE;
      END IF;
   ELSIF (period_counter_ < number_of_periods_) THEN
      IF NOT (info_display_tab_(5)) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'LESSEASON: Classification for asset classes with Seasonal Demand Pattern on site :P1 was performed on :P2 periods because complete statistical information was not found for :P3 periods.', NULL, contract_, period_counter_, number_of_periods_);
         Transaction_SYS.Set_Status_Info(info_);
         info_display_tab_(5) := TRUE;
      END IF;
   END IF;

   IF (begin_year_no_ IS NOT NULL) THEN
      number_of_days_ := Statistic_Period_API.Get_Number_Of_Days(begin_year_no_,
                                                                 begin_period_no_,
                                                                 end_year_no_,
                                                                 end_period_no_);
   END IF;

EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Load_Periods_For_Season___;


PROCEDURE Load_Statistic_Periods___ (
   number_of_days_                OUT NUMBER,
   info_display_tab_           IN OUT Info_Display_Tab,
   contract_                   IN     VARCHAR2,
   number_of_periods_          IN     NUMBER,
   today_                      IN     DATE,
   seasonal_demand_pattern_db_ IN     VARCHAR2 )
IS 
BEGIN

   IF (seasonal_demand_pattern_db_ = 'TRUE') THEN

      Load_Periods_For_Season___(number_of_days_,
                                 info_display_tab_,
                                 contract_,
                                 number_of_periods_,
                                 today_);
   ELSE
      Load_Periods_For_No_Season___(number_of_days_,
                                    info_display_tab_,
                                    contract_,
                                    number_of_periods_,
                                    today_);
   END IF;

END Load_Statistic_Periods___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Classify_Site__ (
   attr_ IN VARCHAR2 )
IS
   contract_                VARCHAR2(5);
   cost_set_                NUMBER;
   cost_type_db_            VARCHAR2(50);
   number_of_periods_       NUMBER;
   number_of_days_          NUMBER;
   ptr_                     NUMBER;
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(2000);
   site_invent_info_rec_    Site_Invent_Info_API.Public_Rec;
   company_invent_info_rec_ Company_Invent_Info_API.Public_Rec;
   total_volume_value_      NUMBER;
   today_                   DATE;
   info_display_tab_        Info_Display_Tab;

   CURSOR get_asset_classes IS
      SELECT asset_class, seasonal_demand_pattern, classification_periods
        FROM asset_class_tab;

   TYPE Asset_Class_Tab IS TABLE OF get_asset_classes%ROWTYPE
     INDEX BY PLS_INTEGER;
   asset_class_tab_ Asset_Class_Tab;
BEGIN

   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'COST_SET') THEN
         cost_set_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'COST_TYPE_DB') THEN
         cost_type_db_ := value_;
      ELSIF (name_ = 'NUMBER_OF_PERIODS') THEN
         number_of_periods_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   Check_Parameters___(contract_, cost_set_, cost_type_db_, number_of_periods_);

   today_ := TRUNC(Site_API.Get_Site_Date(contract_));

   company_invent_info_rec_ := Company_Invent_Info_API.Get(Site_API.Get_Company(contract_));
   site_invent_info_rec_    := Site_Invent_Info_API.Get(contract_);

   FOR i IN 1..6 LOOP
      info_display_tab_(i) := FALSE;
   END LOOP;
  
   IF (site_invent_info_rec_.abc_class_per_asset_class = 'TRUE') THEN
  
      OPEN  get_asset_classes;
      FETCH get_asset_classes BULK COLLECT INTO asset_class_tab_;
      CLOSE get_asset_classes;
  
      IF (asset_class_tab_.COUNT > 0) THEN
         FOR i IN asset_class_tab_.FIRST..asset_class_tab_.LAST LOOP
  
            Load_Statistic_Periods___(number_of_days_,
                                      info_display_tab_,
                                      contract_,
                                      NVL(asset_class_tab_(i).classification_periods,
                                          number_of_periods_),
                                      today_,
                                      asset_class_tab_(i).seasonal_demand_pattern);

            Load_Part_Volume_Value___(total_volume_value_,
                                      contract_,
                                      cost_set_,
                                      cost_type_db_,
                                      asset_class_tab_(i).asset_class,
                                      NULL,
                                      NULL);

            Classify_Parts___(contract_,
                              number_of_days_,
                              site_invent_info_rec_,
                              total_volume_value_,
                              company_invent_info_rec_,
                              today_);
         END LOOP;
      END IF;
   ELSE
      Load_Statistic_Periods___(number_of_days_, 
                                info_display_tab_,
                                contract_,
                                number_of_periods_,
                                today_,
                                'FALSE');

      Load_Part_Volume_Value___(total_volume_value_,
                                contract_,
                                cost_set_,
                                cost_type_db_,
                                NULL,
                                NULL,
                                NULL);

      Classify_Parts___(contract_,
                        number_of_days_,
                        site_invent_info_rec_,
                        total_volume_value_,
                        company_invent_info_rec_,
                        today_);
   END IF;
END Classify_Site__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Classify (
   contract_          IN VARCHAR2,
   cost_set_          IN NUMBER,
   cost_type_         IN VARCHAR2,
   number_of_periods_ IN NUMBER )
IS
   batch_desc_   VARCHAR2(200);
   attr_         VARCHAR2(2000);

   CURSOR get_contracts IS
      SELECT site contract
      FROM user_allowed_site_pub
      WHERE site LIKE NVL(contract_,'%');

   TYPE Contract_Tab_Type IS TABLE OF get_contracts%ROWTYPE
     INDEX BY BINARY_INTEGER;
   contract_tab_       Contract_Tab_Type;
BEGIN

   Check_Parameters___(contract_, cost_set_, cost_type_, number_of_periods_);

   OPEN  get_contracts;
   FETCH get_contracts BULK COLLECT INTO contract_tab_;
   CLOSE get_contracts;

   FOR i IN contract_tab_.FIRST..contract_tab_.LAST LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT',          contract_tab_(i).contract, attr_);
      Client_SYS.Add_To_Attr('COST_SET',          cost_set_,                 attr_);
      Client_SYS.Add_To_Attr('COST_TYPE_DB',      cost_type_,                attr_);
      Client_SYS.Add_To_Attr('NUMBER_OF_PERIODS', number_of_periods_,        attr_);

      batch_desc_ := Language_SYS.Translate_Constant(lu_name_, 'ABCFREQLIFE: Perform ABC, Frequency, and Lifecycle classification for inventory parts on site');
      batch_desc_ := batch_desc_ || ' ' || contract_tab_(i).contract;
      Transaction_SYS.Deferred_Call('CLASSIFY_INVENTORY_PART_API.Classify_Site__', attr_, batch_desc_);
   END LOOP;
END Classify;


PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_             NUMBER;
   name_arr_          Message_SYS.name_table;
   value_arr_         Message_SYS.line_table;
   contract_          VARCHAR2(5);
   cost_set_          NUMBER;
   cost_type_db_      VARCHAR2(50);
   number_of_periods_ NUMBER;
BEGIN

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT_') THEN
         contract_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'COST_SET_') THEN
         cost_set_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'NUMBER_OF_PERIODS_') THEN
         number_of_periods_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'COST_TYPE_') THEN
         cost_type_db_ := value_arr_(n_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;
   
   Check_Parameters___(contract_, cost_set_, cost_type_db_, number_of_periods_);

END Validate_Params;



