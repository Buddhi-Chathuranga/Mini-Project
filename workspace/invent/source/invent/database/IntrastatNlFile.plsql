-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatNlFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220128  ErFelk  Bug 162143(SC21R2-7321), Modified the code so that country notc 2 digit is used for import. 
--  210608  ErFelk  Bug 158692(SCZ-14501), Modified the code to include opponent_tax_id , country_of_origin and country notc 1 digit for import
--  210608          2 digit for export.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130730  AwWelk  TIBE-853, Removed global variables and introduced conditional compilation.
--  110309  Bmekse  DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                  inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203  Elarse  Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise  Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090601  SaWjlk  Bug 83173, Removed the prog text duplications.
--  060123  NiDalk  Added Assert safe annotation. 
--  050920  NiDalk  Removed unused variables.
--  040301  GeKalk  Replaced substrb with substr for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  040203 NaWalk Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  040202 NaWalk Removed the fourth variable of DBMS_SQL inside the loop,for Unicode modification.
--  020913 MKrase Bug 32565, changed calculation for supplementary_unit in  
--                cursor get_import_lines and get_export_lines.           
--  010525 JSAnse Bug fix 21463, Added call to General_SYS.Init_Method in Create_Details.
--  010411 DaJoLK Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and 
--                TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  010322  DaZa  Created using spec 'Functional specification for IID 10219 
--                - Dutch Intrastat File' by Martin Korn
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Details__
--   Method formats the detail data for a specific intrastat.
PROCEDURE Create_Details__ (
   output_clob_          IN OUT CLOB,
   file_line_no_         IN OUT NUMBER,
   intrastat_direction_  IN VARCHAR2,
   transaction_period_   IN VARCHAR2,
   vat_no_               IN VARCHAR2,
   opposite_country_     IN VARCHAR2,
   p_mode_of_transport_  IN VARCHAR2,
   region_port_          IN VARCHAR2,
   stat_procedure_       IN VARCHAR2,
   country_notc_         IN VARCHAR2,
   customs_stat_no_      IN VARCHAR2,
   p_mass_               IN NUMBER,
   suppl_unit_           IN NUMBER,
   inv_value_            IN NUMBER,
   rep_curr_code_        IN VARCHAR2,
   country_code_         IN VARCHAR2,
   opponent_tax_id_      IN VARCHAR2,
   country_of_origin_    IN VARCHAR2 )
IS
   -- Data Record
   commodity_flow_      VARCHAR2(1);
   psi_                 VARCHAR2(12);
   file_str_line_no_    VARCHAR2(5);   
   country_of_destination_ VARCHAR2(3);
   mode_of_transport_   VARCHAR2(1);
   container_           VARCHAR2(1) := '0';
   traffic_region_port_ VARCHAR2(2);
   statistical_procedure_ VARCHAR2(2);   
   commodity_code_      VARCHAR2(8);
   taric_               VARCHAR2(2) := '00';
   mass_sign_           VARCHAR2(1);
   mass_                VARCHAR2(10);
   supplementary_unit_sign_ VARCHAR2(1);
   supplementary_unit_  VARCHAR2(10);
   invoice_value_sign_  VARCHAR2(1);
   invoice_value_       VARCHAR2(10);
   statistical_value_   VARCHAR2(11) := '+0000000000';
   administration_no_   VARCHAR2(10) := lpad(' ',10);
   boe_reserve_         VARCHAR2(2) := '  ';
   affiliates_reserve_  VARCHAR2(1) := ' ';
   csa_reserve_         VARCHAR2(1) := ' ';
   preference_          VARCHAR2(3) := '000';
   currency_            VARCHAR2(1);
   data_reserve_        VARCHAR2(6) := lpad(' ',6);   
   line_                 VARCHAR2(2000);   

BEGIN
   
   IF (intrastat_direction_ = 'IMPORT') THEN
      commodity_flow_ := '6';  -- import      
   ELSE
      commodity_flow_ := '7';  -- export      
   END IF;
   
   IF (SUBSTR(vat_no_,1,2) = country_code_ ) THEN
      -- do not include country code in the vat no
      psi_ := RPAD(SUBSTR(NVL(vat_no_,' '), 3, 12), 12);  -- always company's vat no
   ELSE
      psi_ := RPAD(SUBSTR(NVL(vat_no_,' '), 1, 12), 12);   -- always company's vat no
   END IF;    
     
   file_line_no_           := file_line_no_ + 1;
   file_str_line_no_       := SUBSTR(TO_CHAR(file_line_no_,'00000'), 2, 5); -- 2 because of an extra character in the beginning of string from to_char on a number  
   country_of_destination_ := UPPER(RPAD(SUBSTR(opposite_country_, 1, 3), 3));
   mode_of_transport_      := RPAD(NVL(p_mode_of_transport_, ' '), 1);
   
   -- Generate an error if Region/Port is null while mode_of_transport is 1, 4 or 8
   IF ((p_mode_of_transport_ IN ('1','4','8')) AND (region_port_ IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'REGPORTNULL: Some row or rows have empty Traffic Region/Port fields while Mode of Transport is 1, 4, or 8. Traffic Region/Port must have a value in these cases');        
   END IF;

   traffic_region_port_    := LPAD(NVL(SUBSTR(region_port_, 1, 2), '0'), 2, '0');
   statistical_procedure_  := stat_procedure_;
   commodity_code_         := LPAD(NVL(SUBSTR(customs_stat_no_, 1, 8), '0'), 8, '0');
   
   IF (p_mass_ < 0) THEN
      mass_sign_ := '-';
   ELSE
      mass_sign_ := '+';
   END IF;
   mass_ := LPAD(SUBSTR(TO_CHAR(ROUND(ABS(p_mass_))), 1, 10), 10, '0');
   
   IF (suppl_unit_ < 0) THEN
      supplementary_unit_sign_ := '-';
   ELSE
      supplementary_unit_sign_ := '+';
   END IF;
   supplementary_unit_ := LPAD(SUBSTR(TO_CHAR(ROUND(ABS                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   (suppl_unit_))), 1, 10), 10, '0');    
   
   IF (inv_value_ < 0) THEN
      invoice_value_sign_ := '-';
   ELSE
      invoice_value_sign_ := '+';
   END IF;
   invoice_value_ := LPAD(SUBSTR(TO_CHAR(ROUND(ABS(inv_value_))), 1, 10), 10, '0');
   
   IF (rep_curr_code_ = 'NLG') THEN
      currency_ := 'G';
   ELSIF (rep_curr_code_ = 'EUR') THEN
      currency_ := 'E';
   ELSE
      Error_SYS.Record_General(lu_name_, 'WRONGCURRNLF: Currency Code :P1 is not a valid currency, only NLG and EUR is acceptable', rep_curr_code_);
   END IF;
   
   -- Create Data Record Line 
   line_ := transaction_period_ ||
            commodity_flow_ ||
            psi_ ||
            file_str_line_no_ ||
            RPAD(NVL(country_of_origin_, ' '), 3) ||
            country_of_destination_ ||
            mode_of_transport_ ||
            container_ ||
            traffic_region_port_ ||
            statistical_procedure_ ||
            LPAD(NVL(country_notc_, ' '), 1) ||
            commodity_code_ ||
            taric_ ||
            mass_sign_ ||
            mass_ ||
            supplementary_unit_sign_ ||
            supplementary_unit_ ||
            invoice_value_sign_ ||
            invoice_value_ ||
            statistical_value_ ||
            administration_no_ ||
            boe_reserve_ ||
            affiliates_reserve_ ||
            csa_reserve_ ||
            preference_ ||
            currency_ ||
            data_reserve_ ||
            LPAD(NVL(country_notc_, ' '), 2) ||
            RPAD(NVL(opponent_tax_id_, ' '), 17) ||
            CHR(13) || CHR(10);
            
   output_clob_ := output_clob_ || line_;

END Create_Details__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Output
--   Method fetches the intrastat data and formats it according to
--   specifications for Netherlands.
PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2,
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2 ) 
IS
   -- Preliminary Record
   record_type_          VARCHAR2(4) := '9801';
   psi_agent_vat_no_     VARCHAR2(12);
   review_period_        VARCHAR2(6);
   psi_agent_name_       VARCHAR2(40);
   statistics_nl_reg_no_ VARCHAR2(6) := '000000';
   version_number_       VARCHAR2(5) := '10000';
   creation_date_        VARCHAR2(8);
   creation_time_        VARCHAR2(6);   
   prel_reserve_         VARCHAR2(28) := lpad(' ',28);

   -- End Record
   end_record_type_     VARCHAR2(4) := '9899';
   end_reserve_         VARCHAR2(111) := lpad(' ', 111);
   
   line_                 VARCHAR2(2000);
   vat_no_               VARCHAR2(50);
   rep_curr_code_        VARCHAR2(3);
   rep_curr_rate_        NUMBER;
   country_code_         VARCHAR2(2); 
   notc_dummy_           VARCHAR2(2);  
   file_line_no_         NUMBER := 0;
   no_of_rows_           NUMBER := 0;

   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'NL';

   CURSOR get_head IS
      SELECT company,
             representative,
             repr_tax_no,  
             end_date,
             creation_date,
             rep_curr_code,
             rep_curr_rate,
             country_code,
             begin_date
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;

   CURSOR get_import_lines IS
      SELECT il.intrastat_direction,
             il.opposite_country,
             il.mode_of_transport,
             il.region_port,
             cn.country_notc,  
             il.customs_stat_no,    
             SUM(il.quantity * il.net_unit_weight) mass,
             SUM(il.quantity * nvl(ABS(il.intrastat_alt_qty),0)) supplementary_unit,
             SUM(il.quantity * nvl(il.invoiced_unit_price, il.order_unit_price)) * rep_curr_rate_ invoice_value
      FROM   intrastat_line_tab il, country_notc_tab cn
      WHERE  il.rowstate = 'Released'
      AND    il.intrastat_id = intrastat_id_
      AND    il.intrastat_direction = 'IMPORT'
      AND    il.notc = cn.notc          
      AND    cn.country_code = country_code_
      GROUP BY  il.intrastat_direction,
                il.opposite_country,
                il.mode_of_transport,
                il.region_port,  
                cn.country_notc, 
                il.customs_stat_no;
            
   CURSOR get_export_lines IS
      SELECT il.intrastat_direction,
             il.opposite_country,
             il.mode_of_transport,
             il.region_port,
             DECODE(il.statistical_procedure, 'DELIVERY', '00', 
                                              'BEFORE SUBCONTRACTING','02',
                                              'AFTER SUBCONTRACTING','00','00') statistical_procedure,
             cn.country_notc,  
             il.customs_stat_no,    
             SUM(il.quantity * il.net_unit_weight) mass,
             SUM(il.quantity * nvl(ABS(il.intrastat_alt_qty),0)) supplementary_unit,
             SUM(il.quantity * nvl(il.invoiced_unit_price, il.order_unit_price)) * rep_curr_rate_ invoice_value,
             il.opponent_tax_id,
             il.country_of_origin
      FROM   intrastat_line_tab il, country_notc_tab cn
      WHERE  il.rowstate = 'Released'
      AND    il.intrastat_id = intrastat_id_
      AND    il.intrastat_direction = 'EXPORT'
      AND    il.notc = cn.notc              
      AND    cn.country_code = country_code_
      GROUP BY  il.intrastat_direction,
                il.opposite_country,
                il.mode_of_transport,
                il.region_port,  
                DECODE(il.statistical_procedure, 'DELIVERY', '00', 
                                                 'BEFORE SUBCONTRACTING','02',
                                                 'AFTER SUBCONTRACTING','00','00'),
                cn.country_notc, 
                il.customs_stat_no,
                il.opponent_tax_id,
                il.country_of_origin;                

BEGIN
      
   IF (intrastat_export_ IS NULL AND intrastat_import_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DIRECTIONSNULL: At least one transfer option must be checked');        
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

   -- Preliminary Record
   FOR headrec_ IN get_head LOOP     

      $IF (Component_Invoic_SYS.INSTALLED)$THEN 
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, headrec_.country_code, TRUNC(headrec_.creation_date));
      $END 
            
      IF vat_no_ IS NULL THEN 
         Error_SYS.Record_General(lu_name_, 'NOCOMPVATNO1: TAX number is missing for company :P1.',headrec_.company);
      END IF; 
      
      IF (headrec_.representative IS NULL) THEN
         IF (SUBSTR(vat_no_,1,2) = headrec_.country_code ) THEN
            -- do not include country code in the vat no
            psi_agent_vat_no_ := RPAD(SUBSTR(NVL(vat_no_,' '), 3, 12), 12);
         ELSE
            psi_agent_vat_no_ := RPAD(SUBSTR(NVL(vat_no_,' '), 1, 12), 12);
         END IF;    
         psi_agent_name_   := UPPER(RPAD(SUBSTR(Company_API.Get_Name(headrec_.company), 1, 40), 40));
      ELSE
         IF (headrec_.repr_tax_no IS NULL) THEN
             Error_SYS.Record_General(lu_name_, 'NOAGENTVATNO: Representative tax no is missing for Intrastat ID :P1.',intrastat_id_);
         END IF;
         
         IF (SUBSTR(headrec_.repr_tax_no,1,2) = headrec_.country_code) THEN
            -- do not include country code in the vat no
            psi_agent_vat_no_ := RPAD(SUBSTR(NVL(headrec_.repr_tax_no,' '), 3, 12), 12);               
         ELSE
            psi_agent_vat_no_ := RPAD(SUBSTR(NVL(headrec_.repr_tax_no,' '), 1, 12), 12);      
         END IF;
         psi_agent_name_   := UPPER(RPAD(SUBSTR(NVL(Person_Info_API.Get_Name(headrec_.representative),' '), 1, 40), 40));
      END IF;
      
      review_period_ := to_char(headrec_.end_date, 'YYYYMM');         
      creation_date_ := to_char(headrec_.creation_date, 'YYYYMMDD');
      creation_time_ := to_char(headrec_.creation_date, 'HH24MISS');
      rep_curr_code_ := headrec_.rep_curr_code;
      rep_curr_rate_ := headrec_.rep_curr_rate;
      country_code_ := headrec_.country_code;
      
   END LOOP;
   
  
   -- Create Preliminary Record Line
   line_ := record_type_ ||
            psi_agent_vat_no_ ||
            review_period_ ||
            psi_agent_name_ ||
            statistics_nl_reg_no_ ||
            version_number_ ||
            creation_date_ ||
            creation_time_ ||
            prel_reserve_ ||
            CHR(13) || CHR(10);
   output_clob_ := line_;

   -- Data Records
   IF (intrastat_import_ = 'IMPORT') THEN
      no_of_rows_ := 0;
      FOR linerec_ IN get_import_lines LOOP       
         no_of_rows_ := no_of_rows_ + 1;
         Create_Details__(output_clob_,
                          file_line_no_,
                          'IMPORT',
                          review_period_,
                          vat_no_,
                          linerec_.opposite_country,
                          linerec_.mode_of_transport,
                          linerec_.region_port,
                          '00',
                          linerec_.country_notc,
                          linerec_.customs_stat_no,
                          linerec_.mass,
                          linerec_.supplementary_unit,
                          linerec_.invoice_value,
                          rep_curr_code_,
                          country_code_,
                          NULL,
                          NULL );     
      END LOOP;      
      IF (no_of_rows_ = 0) THEN
         -- create one empty import detail row
         Create_Details__(output_clob_,
                          file_line_no_,
                          'IMPORT',
                          review_period_,
                          vat_no_,
                          'QV',
                          ' ',
                          ' ',
                          '00',
                          ' ',
                          ' ',
                          0,
                          0,
                          0,
                          rep_curr_code_,
                          country_code_,
                          NULL,
                          NULL );      
      END IF;
   END IF;
   IF (intrastat_export_ = 'EXPORT') THEN
      no_of_rows_ := 0;
      FOR linerec_ IN get_export_lines LOOP
         IF (linerec_.opponent_tax_id IS NULL) THEN         
            Error_SYS.Record_General(lu_name_, 'NOOPPONENTTAXIDNL: Opponent Tax ID is missing for some lines.');
         END IF;
         IF (linerec_.country_of_origin IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'MISSINGCOUNTRYOFORIGIONNL: Country of Origin is missing for some lines.');
         END IF;
         no_of_rows_ := no_of_rows_ + 1;
         Create_Details__(output_clob_,
                          file_line_no_,
                          'EXPORT',
                          review_period_,
                          vat_no_,
                          linerec_.opposite_country,
                          linerec_.mode_of_transport,
                          linerec_.region_port,
                          linerec_.statistical_procedure,
                          linerec_.country_notc,
                          linerec_.customs_stat_no,
                          linerec_.mass,
                          linerec_.supplementary_unit,
                          linerec_.invoice_value,
                          rep_curr_code_,
                          country_code_,
                          linerec_.opponent_tax_id,
                          linerec_.country_of_origin );     
      END LOOP;
      IF (no_of_rows_ = 0) THEN
         -- create one empty export detail row
         Create_Details__(output_clob_,
                          file_line_no_,
                          'EXPORT',
                          review_period_,
                          vat_no_,
                          'QV',
                          ' ',
                          ' ',
                          '00',
                          ' ',
                          ' ',
                          0,
                          0,
                          0,
                          rep_curr_code_,
                          country_code_,
                          NULL,
                          NULL );         
      END IF;                          
   END IF;

   -- End Record
   -- Create End Record Line
   line_ := end_record_type_ ||
            end_reserve_ ||
            CHR(13) || CHR(10);
   output_clob_ := output_clob_ || line_;  

   info_ := Client_SYS.Get_All_Info;      

END Create_Output;



