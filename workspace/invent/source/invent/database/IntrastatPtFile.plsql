-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatPtFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200210  ApWilk  Bug 147188 (SCZ-3428), Made necessary changes to support the new intrastat requiremnts for 2019.
--  130829  TiRalk  Bug 109740, Added Create_Details__ and modified Create_Output by moving line information code segmant to
--  130829          new method since it is needed to create file when checked both import and export check boxes.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130731  MaRalk  TIBE-855, Removed global LU constant inst_TaxLiabilityCountries_ and modified Create_Output 
--  130731          using conditional compilation instead.
--  130207  TiRalk  Bug 107599, Modified the code to handle the net_weight_sum value properly.
--  130121  TiRalk  Bug 107599, Modified cursor get_lines by removing intrastat_alt_unit_meas, contract 
--  130121          and variable region_ since they are not necessary.
--  121228  TiRalk  Bug 107599, Modified method Create_Output to add some new logics and removed methods Create_Details__,
--  121228          Write_Block__ since Portuguese file format has been changed and they are not needed anymore
--  110309  Bmekse  DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                  inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203  Elarse  Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise  Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  100107  Umdolk  Refactoring in Communication Methods in Enterprise.
--  090609  SaWjlk  Bug 83173, Removed the prog text duplications.
--  090528  SaWjlk  Bug 83173, Removed the prog text duplications.
--  060516  IsAnlk  Enlarge Address - Changed variable definitions.
--  --------------------------13.4.0-------------------------------------------
--  060123  NiDalk  Added Assert safe annotation. 
--  050920  NiDalk  Removed unused variables.
--  040301  GeKalk  Replaced substrb with substr for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  040203  NaWalk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.  
--  040202  NaWalk  Removed the fourth variable of DBMS_SQL inside the loop,for Unicode modification.
--  030911  MiKulk  Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  030903  GaSolk  Performed CR Merge 2(CR Only).
--  030827  SeKalk  Code Review
--  030826  ThGulk  Replaced  Company_Address_Tab with COMPANY_ADDRESS_PUB
--  030326  SeKalk  Replaced Site_Delivery_Address_API and Site_Delivery_Address_Tab with Company_Address_API and Company_Address_Tab
--  ********************************CR Merge***********************************
--  020322  DaZa    Bug fix 28610, changed the substrb on moa_l1_invoice_amount_ from 18 to 35, 
--                  added substrb,1,35 to moa_2_amount_. Added an errormessage when cst_row_no_ > 99999.
--  020312  DaZa    Bug fix 28308, added ABS on intrastat_alt_qty so we dont get "-x * -y results" when we multiply with the regular qty.
--  010525 JSAnse   Bug fix 21463, Added call to General_SYS.Init_Method in Procedures Create_Details__ and Write_Block__.
--  010411 DaJoLK   Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and 
--                  TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  010322  DaZa    Created using spec 'Functional specification for IID 10224 
--                  - Portuguese Intrastat File' by Martin Korn
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_Details__ (
   output_clob_          IN OUT CLOB,
   line_no_              IN OUT NUMBER,
   intrastat_id_         IN     NUMBER,
   intrastat_direction_  IN     VARCHAR2, 
   creation_date_        IN     DATE,       
   rep_curr_rate_        IN     NUMBER,
   country_code_         IN     VARCHAR2,
   vat_no_               IN     VARCHAR2,
   fluxo_value_          IN     VARCHAR2 )
IS 
   net_weight_zero_       VARCHAR2(1);   
   line_                  VARCHAR2(2000);
   CURSOR get_lines IS
      SELECT il.opposite_country,
             il.country_of_origin,
             cn.country_notc,
             il.mode_of_transport,
             il.customs_stat_no,
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
                                       'DAT','DAT',
                                       'DAP','DAP',
                                       'DDP','DDP','XXX') delivery_terms,
             il.region_port,
             ca.state,
             SUM(il.quantity * NVL(il.net_unit_weight,0)) net_weight_sum,
             SUM(ABS(il.intrastat_alt_qty) * il.quantity) intrastat_alt_qty_sum,    
             SUM(il.quantity * NVL(il.invoiced_unit_price,il.order_unit_price)) * rep_curr_rate_ invoiced_amount,                 
             SUM((NVL(il.invoiced_unit_price, NVL(il.order_unit_price,0)) + 
                  NVL(il.unit_add_cost_amount_inv, NVL(il.unit_add_cost_amount,0)) +
                  NVL(il.unit_charge_amount_inv,0) + NVL(il.unit_charge_amount,0)) * 
                  il.quantity) * rep_curr_rate_ statistical_value,
             il.opponent_tax_id
      FROM   intrastat_line_tab il, country_notc_tab cn, site_tab s, company_address_pub ca
      WHERE  il.rowstate = 'Released'
      AND    cn.country_code = country_code_
      AND    il.notc = cn.notc      
      AND    ca.address_id  = s.delivery_address
      AND    il.contract = s.contract      
      AND    il.intrastat_id = intrastat_id_
      AND    il.intrastat_direction = intrastat_direction_
      AND    s.company = ca.company
      GROUP BY  il.opposite_country,
                il.country_of_origin,
                cn.country_notc,
                il.mode_of_transport,
                il.customs_stat_no,
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
                                          'DAT','DAT',
                                          'DAP','DAP',
                                          'DDP','DDP','XXX'),
                il.region_port,
                ca.state,
                il.opponent_tax_id;
BEGIN
   FOR linerec_ IN get_lines LOOP   
      IF ((linerec_.mode_of_transport IN ('1','4')) AND (linerec_.region_port IS NULL)) THEN
         Error_SYS.Record_General(lu_name_, 'REGPORTNULL: Some row or rows have empty Region/Port fields while Mode of Transport is 1 or 4. Region/Port must have a value in these cases');
      END IF; 
      
      IF(linerec_.country_of_origin IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CNTRYOFORGNNULL: Country of Origin is missing for some rows. This is necessary when creating the file.');
      END IF;
      
      IF(intrastat_direction_ = 'EXPORT' AND linerec_.opponent_tax_id IS NULL)THEN
         Error_SYS.Record_General(lu_name_, 'OPPTAXIDNULL: Opponent Tax Id is missing for some rows. This is necessary when creating the file.');
      END IF;
                  
      -- When net_weight_sum is less than 1 and having decimals, it should display as 0,XXX.
      -- So here net_weight_zero_ has been introduced to handle that scenario since ROUND function
      -- will return the value without leading zero.
      IF INSTR(linerec_.net_weight_sum, '.') = 0 THEN
         net_weight_zero_ := '';
      ELSE
         IF linerec_.net_weight_sum > 1 THEN
            net_weight_zero_ := '';
         ELSE
            net_weight_zero_ := '0';
         END IF;
      END IF;

      IF linerec_.intrastat_alt_qty_sum = 0 THEN
         linerec_.intrastat_alt_qty_sum := NULL;
      END IF;
        
      Client_SYS.Clear_Attr(line_);
      -- Create Record Line (each column is semicolon separated)
      line_ := fluxo_value_ || ';' ||
               to_char(creation_date_, 'YYYYMM') || ';' ||
               SUBSTR(vat_no_, 1, 9) || ';' ||
               ';' || -- REF value kept blank        
               SUBSTR(linerec_.customs_stat_no , 1, 10) || ';' || 
               linerec_.opposite_country || ';' ||
               linerec_.country_of_origin || ';' ||
               linerec_.state || ';' ||
               SUBSTR(linerec_.delivery_terms, 1, 3) || ';' ||
               SUBSTR(linerec_.country_notc, 1, 1) || SUBSTR(linerec_.country_notc, 2, 1) || ';' ||
               SUBSTR(linerec_.mode_of_transport, 1, 1) || ';' ||
               SUBSTR(linerec_.region_port, 1, 3) || ';' ||
               net_weight_zero_ || REPLACE(ROUND(linerec_.net_weight_sum, 3), '.' , ',') || ';' ||
               SUBSTR(to_char(ROUND(linerec_.intrastat_alt_qty_sum)), 1, 10) || ';' ||                
               SUBSTR(to_char(ROUND(linerec_.invoiced_amount)), 1, 9) || ';' ||
               SUBSTR(to_char(ROUND(linerec_.statistical_value)), 1, 9) || ';' ||
               linerec_.opponent_tax_id || ';' ||
               CHR(13) || CHR(10); 
      output_clob_ := output_clob_ || line_;
   END LOOP; -- line loop       
END Create_Details__;


-- Filter__
--   Method removes unwanted EDIFACT specified characters from a string.
@UncheckedAccess
FUNCTION Filter__ (
   str_           IN VARCHAR2 ) RETURN VARCHAR2
IS
   out_str_       VARCHAR2(2000);
BEGIN
   -- remove any EDIFACTs defined characters 
   out_str_ := replace(str_, '''');  
   out_str_ := replace(out_str_, '+'); 
   out_str_ := replace(out_str_, ':');   
   out_str_ := replace(out_str_, '?'); 
   RETURN out_str_;
END Filter__; 



-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Output
--   Method fetches the intrastat data and formats it according to
--   specifications for Portugal.
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
   line_no_               NUMBER  := 1;
   rep_curr_rate_         NUMBER;
   country_code_          VARCHAR2(2);   
   notc_dummy_            VARCHAR2(2);
   deladdr_               VARCHAR2(10);   

   vat_no_                VARCHAR2(50);

   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'PT';   

   CURSOR get_sites IS
      SELECT distinct contract
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;

   CURSOR get_head IS
      SELECT company,
             creation_date,
             rep_curr_code,
             rep_curr_rate,
             country_code
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;
BEGIN
   
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
   
   -- check that all sites in the intrastat have delivery addresses 
   -- (this is important since we group on state from delivery address)
   FOR site_rec_ IN get_sites LOOP
      deladdr_ := Site_API.Get_Delivery_Address(site_rec_.contract);
      IF (deladdr_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NODELADDR: Site :P1 is missing a Delivery Address. This is necessary when getting State information.', site_rec_.contract);           
      END IF; 
   END LOOP; 
   
   -- Head blocks
   FOR headrec_ IN get_head LOOP           
      $IF Component_Invoic_SYS.INSTALLED $THEN
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, headrec_.country_code, TRUNC(headrec_.creation_date));  
      $END
      
      -- Remove any country code in the vat numbers
      IF (SUBSTR(vat_no_,1,2) = headrec_.country_code) THEN
         -- do not include country code in the vat no
         vat_no_ := SUBSTR(Filter__(vat_no_), 3, 9);
      ELSE
         vat_no_ := SUBSTR(Filter__(vat_no_), 1, 9);
      END IF;
      
      IF (headrec_.rep_curr_code NOT IN ('EUR')) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCURR: Currency Code :P1 is not a valid currency, only EUR is acceptable', headrec_.rep_curr_code);         
      END IF;

      rep_curr_rate_ := headrec_.rep_curr_rate;
      country_code_  := headrec_.country_code;
      
      line_ := 'FLUXO;PERIODO;NIF;REF;NC;PAIS;PORIGEM;REGIAO;CODENT;NATTRA;MODTRA;AERPOR;MASSA;UNSUP;VALFAT;VALEST;ADQNIF;' || CHR(13) || CHR(10);
      output_clob_ := line_;
      IF intrastat_import_ = 'IMPORT' THEN
        Create_Details__(output_clob_,
                         line_no_,
                         intrastat_id_,
                         'IMPORT',
                         headrec_.creation_date,         
                         rep_curr_rate_,
                         country_code_,
                         vat_no_,   
                         'INTRA-CH');
      END IF;
      IF intrastat_export_ = 'EXPORT' THEN
        Create_Details__(output_clob_,
                         line_no_,
                         intrastat_id_,
                         'EXPORT',
                         headrec_.creation_date,
                         rep_curr_rate_,
                         country_code_,
                         vat_no_,
                         'INTRA-EX');
      END IF;
      info_        := Client_SYS.Get_All_Info;   
   END LOOP; -- head loop
END Create_Output;



