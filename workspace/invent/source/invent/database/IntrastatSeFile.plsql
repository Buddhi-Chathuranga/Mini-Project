-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatSeFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220126  ErFelk  Bug 162264(SC21R2-7419), Removed SUBSTR of country_notc so that the value displays in two digits.
--  211206  Hahalk  Bug 161177(SC21R2-6451), Added field opponent_tax_id and country of origin for the csv file generation format 
--  140130  IsSalk  Bug 114770, Modified Create_Output() to report weight up to three decimals with comma as the decimal symbol
--  140130          and to display statistical_value in integers with 1 as the minimum value.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  121016  PraWlk  Bug 105887, Removed SUBSTR to avoid length restriction of customs statistics number description. 
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090929  PraWlk  Bug 85516, Modified the length of customs_stat_no to 200. 
--  090601  SaWjlk  Bug 83173, Removed the prog text duplications.
--  070308  MaMalk Bug 63484, Modified the cursor get_lines in method Create_Output
--  070308         to exclude the charges from statistical_value.
-----------------------13.4.0------------------------------------------------
--  050906  JaBalk  Changed the SUBSTRB to SUBSTR.
--  040924  ChJalk  Bug 46743, Modified the Function Create_Output to write only the first 35 characters 
--  040924          for Customs Statistics Number Description.
--  040301  GeKalk  Replaced substrb with substr for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  020613  JOHESE   Bug fix 29284, Removed mode_of_transport from cursor get_lines
--  020312  DaZa  Bug fix 28308, added ABS on intrastat_alt_qty so we dont get "-x * -y results" when we multiply with the regular qty.
--  010322  DaZa  Created using spec 'Functional specification for IID 10230 
--                - Swedish Intrastat File' by Martin Korn
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Output
--   Method fetches the intrastat data and formats it according to
--   specifications for Sweden.
PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2,
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,   
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2 )
IS
  
   line_                 VARCHAR2(2000);
   rep_curr_rate_        NUMBER;
   country_code_         VARCHAR2(2);
   intrastat_direction_  VARCHAR2(10);
   notc_dummy_           VARCHAR2(2);
   no_of_rows_           NUMBER := 0;
   statistical_value_    NUMBER;

   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'SE';

   CURSOR get_head IS
      SELECT rep_curr_code,
             rep_curr_rate,
             country_code,
             end_date,
             begin_date
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;

   CURSOR get_lines IS
      SELECT il.opposite_country,
             DECODE(il.intrastat_direction, 'EXPORT', il.country_of_origin, '')  country_of_origin,
             cn.country_notc,
             il.customs_stat_no,
             SUM(il.quantity * NVL(il.net_unit_weight,0)) net_weight_sum,
             SUM(ABS(il.intrastat_alt_qty) * il.quantity) intrastat_alt_qty_sum,                  
             SUM((NVL(il.invoiced_unit_price, NVL(il.order_unit_price,0)) + 
             NVL(il.unit_add_cost_amount_inv, NVL(il.unit_add_cost_amount,0))) * 
             il.quantity) * rep_curr_rate_ statistical_value,
             DECODE(il.intrastat_direction, 'EXPORT', il.opponent_tax_id, '')  opponent_tax_id
        FROM intrastat_line_tab il, country_notc_tab cn
       WHERE il.intrastat_id = intrastat_id_
         AND il.intrastat_direction = intrastat_direction_
         AND il.rowstate = 'Released'        
         AND il.notc = cn.notc      
         AND cn.country_code = country_code_      
    GROUP BY il.opposite_country, DECODE(il.intrastat_direction, 'EXPORT', il.country_of_origin, ''), cn.country_notc, il.customs_stat_no, DECODE(il.intrastat_direction, 'EXPORT', il.opponent_tax_id, '');
BEGIN
  
   IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOTBOTH: You can only create an import or export file at the time, not both at the same time');   
   ELSIF (intrastat_export_ = 'EXPORT' AND intrastat_import_ IS NULL) THEN
      intrastat_direction_ := intrastat_export_;
   ELSIF (intrastat_export_ IS NULL AND intrastat_import_ = 'IMPORT') THEN
      intrastat_direction_ := intrastat_import_;
   ELSE -- both is null
      Error_SYS.Record_General(lu_name_, 'DIRECTIONSNULL: One transfer option must be checked');        
   END IF;

   -- check that country notc have valid values
   FOR notc_rec_ IN get_notc LOOP
      OPEN get_country_notc(notc_rec_.notc);
      FETCH get_country_notc INTO notc_dummy_;
      IF (get_country_notc%NOTFOUND) THEN
         CLOSE get_country_notc;
         Error_SYS.Record_General(lu_name_, 'NOCOUNTRYNOTC: This country is missing an entry for NOTC :P1 in table COUNTRY_NOTC_TAB. Contact your system administrator.', notc_rec_.notc);   
      END IF;        
      CLOSE get_country_notc;  
   END LOOP;

   -- Head blocks
   FOR headrec_ IN get_head LOOP     
   
      -- check currency
      IF (headrec_.rep_curr_code NOT IN ('SEK', 'EUR')) THEN
         Client_Sys.Add_Info(lu_name_, 'WRONGCURRSEF: Warning the Currency is :P1, SEK or EUR would be better', headrec_.rep_curr_code);
      END IF;
      rep_curr_rate_ := headrec_.rep_curr_rate;
      country_code_ := headrec_.country_code;
      
      FOR linerec_ IN get_lines LOOP     
         IF (linerec_.statistical_value < 1) THEN
            statistical_value_ := 1;
         ELSE
            statistical_value_ := linerec_.statistical_value;
         END IF;
         
         IF (intrastat_direction_ = 'EXPORT') THEN      
            IF (linerec_.opponent_tax_id IS NULL) THEN        
               Error_SYS.Record_General(lu_name_, 'NOOPPONENTTAXIDSE: Opponent Tax ID is missing for some lines.');
            END IF;
            
            IF (linerec_.country_of_origin IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'NOCOUNTRYORIGIN: The country of origin must be specified for intrastat reporting.');   
            END IF;
         END IF;
         
         -- Create Record Line (each column is semicolon separated)
         line_ :=  headrec_.rep_curr_code || ';' ||
                   Customs_Statistics_Number_API.Get_Description(linerec_.customs_stat_no) || ';' ||
                   SUBSTR(TO_CHAR(ROUND(statistical_value_)), 1, 11) || ';' ||   
                   SUBSTR(linerec_.opposite_country , 1, 2) || ';' ||    
                   linerec_.country_notc || ';' ||
                   SUBSTR(linerec_.customs_stat_no, 1, 8) || ';' ||
                   SUBSTR(TO_CHAR(ROUND(linerec_.intrastat_alt_qty_sum)), 1, 11) || ';' ||
                   SUBSTR(REPLACE(TO_CHAR(ROUND(linerec_.net_weight_sum, 3)), '.', ','), 1, 11) || ';' ||
                   linerec_.country_of_origin || ';' ||
                   linerec_.opponent_tax_id || ';' ||
                   CHR(13) || CHR(10);
         output_clob_ := output_clob_ || line_; 
         no_of_rows_ := no_of_rows_ + 1;
      END LOOP;  -- line loop
      IF (no_of_rows_ = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NORECORDS: Files with no items are not allowed to be created');       
      END IF;      
   END LOOP;   -- head loop
   
   info_ := Client_SYS.Get_All_Info;   
   
END Create_Output;



