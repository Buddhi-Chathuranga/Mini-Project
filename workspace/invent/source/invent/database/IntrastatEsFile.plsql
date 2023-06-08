-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatEsFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210625  ErFelk  Bug 159817(SCZ-15327), Modified Create_Output() by adding opponent_tax_id. Removed the statistical_procedure code so that it is empty.  
--  200710  ErFelk  Bug 152132(SCZ-8750), Modified rounding of net_weight_sum to display up to three decimals. 
--  160308  PrYaLK  Bug 127311, Modified Create_Output() to exclude record lines in which the invoice_value is zero when creating output files.
--  160201  ErFelk  Bug 126802, Modified Create_Output() so that linerec_.intrastat_alt_qty_sum is display with two decimals even if that number is an integer.
--  160128  ErFelk  Bug 126802, Modified Create_Output() to round intrastat_alt_qty_sum, to display up to two decimals, separated with comma. 
--  160128  ErFelk  Bug 126145, Modified Create_Output() to round net_weight_sum, invoice_value and statistical_value to display up to 
--  160128          two decimals, separated with comma.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  110323  PraWlk  Bug 95757, Modified Create_Output() by adding delivery terms DAT and DAP.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  100420  PraWlk  Bug 89971, Rearranged the order of intrastat line records as per the new legislation. Modified the
--  100420          cursor get_lines by removing the decode for country_of_origin and Create_Output() by removing if 
--  100420          condition added for country_of_origin to display country_of_origin in both import and export reports.
--  050919  NiDalk  Removed unused variables.
--  041101  GaJalk  Bug 47300, Deleted the cursor get_delivery_address inside Create_Output.
--  041025  GaJalk  Bug 47300, Deleted an error message inside procedure Create_Output.
--  040924  RoJalk  Bug 47126, Modified the cursor get_delivery_address and changed
--  040924          ca.country to ca.country_db. 
--  040301  GeKalk  Replaced substrb with substr for UNICODE modifications.
--  --------------- EDGE Package Group 3 Unicode Changes --------------------
--  030903  GaSolk  Performed CR Merge 2(CR Only).
--  030827  SeKalk  Code Review
--  030826  ThGulk  Replaced  Company_Address_Tab with COMPANY_ADDRESS_PUB
--  030424  SeKalk  Changed substrb to SUBSTRB
--  030326  SeKalk  Replaced Site_Delivery_Address_Tab and Site_Delivery_Address_API with Company_Address_Tab and Company_Address_API
--  *********************************CR Merge**********************************
--  020312  DaZa    Bug fix 28308, added ABS on intrastat_alt_qty so we dont get "-x * -y results" when we multiply with the regular qty.
--  032201  MKOR    Added an error message for Site and State; Error concerning country of origin corrected
--                  Decode on delivery_terms in get_lines added
--- 032001  Indi    Added an error message for no records in the Intrastat_line_tab.
--  031501  Indi    Created using spec 'Functional specification for IID 10144 
--                  - Spanish Intrastat File' by Martin Korn
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
--   specifications for Spain.
PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2,
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,   
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2 )
IS
  
   line_                  VARCHAR2(2000);
   rep_curr_rate_         NUMBER;
   country_code_          VARCHAR2(2);
   intrastat_direction_   VARCHAR2(10);
   notc_dummy_            VARCHAR2(2);
   statistical_procedure_ VARCHAR2(1); 
   delivery_terms_        INTRASTAT_LINE_TAB.delivery_terms%TYPE;
   federal_state_         VARCHAR2(2);

   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'ES';

   CURSOR get_head IS
      SELECT rep_curr_code,
             rep_curr_rate,
             country_code,
             end_date,
             begin_date
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_lines IS
      SELECT il.intrastat_direction,
             il.customs_stat_no,
             cn.country_notc,             
             il.opposite_country,
             il.contract,
             il.mode_of_transport,
             DECODE(il.delivery_terms, 'EXW','EXW',
                                       'FCA','FCA',
                                       'FAS','FAS',
                                       'FOB','FOB',
                                       'CFR','CFR',
                                       'CIF','CIF',
                                       'CPT','CPT',
                                       'CIP','CIP',
                                       'DAF','DAF',
                                       'DES','DES',
                                       'DEQ','DEQ',
                                       'DDU','DDU',
                                       'DDP','DDP',
                                       'DAP','DAP',
                                       'DAT','DAT','XXX') delivery_terms,
             il.country_of_origin, 
             il.region_port,
             SUM(il.quantity * NVL(il.net_unit_weight,0))                                          net_weight_sum,
             SUM(NVL(ABS(il.intrastat_alt_qty),0) * il.quantity)                                   intrastat_alt_qty_sum,                  
             SUM(il.quantity * NVL(il.invoiced_unit_price, il.order_unit_price)) * rep_curr_rate_  invoice_value,
             SUM((NVL(il.invoiced_unit_price, NVL(il.order_unit_price,0)) + 
                  NVL(il.unit_add_cost_amount_inv, NVL(il.unit_add_cost_amount,0)) +
                  NVL(il.unit_charge_amount_inv,0) + NVL(il.unit_charge_amount,0)) * 
                  il.quantity) * rep_curr_rate_                                                     statistical_value,
             DECODE(il.intrastat_direction, 'EXPORT', il.opponent_tax_id, '')                        opponent_tax_id     
      FROM   intrastat_line_tab il, country_notc_tab cn
      WHERE  il.intrastat_id = intrastat_id_
      AND    il.intrastat_direction = intrastat_direction_
      AND    il.rowstate = 'Released'        
      AND    il.notc = cn.notc      
      AND    cn.country_code = country_code_      
      GROUP BY  il.intrastat_direction,
                il.customs_stat_no,
                cn.country_notc,                
                il.opposite_country,
                il.contract,
                il.mode_of_transport,
                DECODE(il.delivery_terms, 'EXW','EXW',
                                          'FCA','FCA',
                                          'FAS','FAS',
                                          'FOB','FOB',
                                          'CFR','CFR',
                                          'CIF','CIF',
                                          'CPT','CPT',
                                          'CIP','CIP',
                                          'DAF','DAF',
                                          'DES','DES',
                                          'DEQ','DEQ',
                                          'DDU','DDU',
                                          'DDP','DDP',
                                          'DAP','DAP',
                                          'DAT','DAT','XXX'),
                il.country_of_origin,
                DECODE(il.intrastat_direction, 'EXPORT', il.opponent_tax_id, ''),
                il.region_port;
             
      get_lines_dummy_  get_lines%ROWTYPE;


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
   
   FOR headrec_ IN get_head LOOP           
         rep_curr_rate_ := headrec_.rep_curr_rate;
         country_code_  := headrec_.country_code;
   END LOOP;
   
   OPEN  get_lines;
   FETCH get_lines INTO get_lines_dummy_;
   IF (get_lines%NOTFOUND) THEN
      CLOSE get_lines;      
      Error_SYS.Record_General(lu_name_, 'NORECOR: Files with no items are not allowed to be created.');
   END IF;
   CLOSE get_lines;

   FOR linerec_ IN get_lines LOOP      
                    
       IF ((linerec_.mode_of_transport IN ('1','4')) AND (linerec_.region_port IS NULL)) THEN
          Error_SYS.Record_General(lu_name_, 'REGPORTNULL: Some row or rows have empty Traffic Region/Port fields while Mode of Transport is 1, 4, or 8. Traffic Region/Port must have a value in these cases');
       END IF;

       IF (linerec_.delivery_terms IN ('CFR','CIF','CIP','CPT','DAF','DDU','DDP','DEQ','DES','EXW','FAS','FCA','FOB','DAT', 'DAP','XXX')) THEN
              delivery_terms_ :=linerec_.delivery_terms;
       ELSE
            delivery_terms_ :='XXX';
       END IF;

       IF ((linerec_.contract IS NULL)) THEN
          Error_SYS.Record_General(lu_name_, 'CONTRACTNULL: At least one row has no value in column Site.');
       END IF;
       
       IF ((intrastat_direction_ = 'EXPORT') AND (linerec_.opponent_tax_id IS NULL)) THEN         
          Client_SYS.Add_Info(lu_name_, 'NOOPPONENTTAXIDES: Opponent Tax ID is missing for some lines.');
       END IF;
       
       federal_state_ := SUBSTR(Company_Address_API.Get_State(Site_API.Get_Company(linerec_.contract), Site_API.Get_Delivery_Address(linerec_.contract)),1,2);
        
       -- Create Record Line (each column is semicolon separated)
       IF NOT linerec_.invoice_value = 0 THEN
          line_ := SUBSTR(linerec_.opposite_country, 1, 3) || ';' ||
                   federal_state_|| ';' ||
                   delivery_terms_||';'||
                   SUBSTR(linerec_.country_notc, 1, 1) || SUBSTR(linerec_.country_notc, 2, 1) || ';' ||
                   SUBSTR(linerec_.mode_of_transport, 1, 1) || ';' ||
                   SUBSTR(linerec_.region_port, 1, 4)|| ';' ||
                   SUBSTR(linerec_.customs_stat_no , 1, 8) || ';' ||
                   SUBSTR(linerec_.country_of_origin, 1, 2) || ';' ||
                   statistical_procedure_ || ';' ||
                   SUBSTR(REPLACE(TO_CHAR(ROUND(linerec_.net_weight_sum, 3)), '.', ','), 1, 11) || ';' ||
                   SUBSTR(REPLACE(LTRIM(TO_CHAR(ROUND(linerec_.intrastat_alt_qty_sum, 2), 99999999.99)), '.', ','), 1, 11) || ';' ||
                   SUBSTR(REPLACE(TO_CHAR(ROUND(linerec_.invoice_value, 2)), '.', ','), 1, 13) || ';' ||
                   SUBSTR(REPLACE(TO_CHAR(ROUND(linerec_.statistical_value, 2)), '.', ','), 1, 13) || ';' ||
                   linerec_.opponent_tax_id || ';' ||
                   CHR(13) || CHR(10);
          output_clob_ := output_clob_ || line_;
       END IF;
  END LOOP;      
  info_        := Client_SYS.Get_All_Info;   
   
END Create_Output;



