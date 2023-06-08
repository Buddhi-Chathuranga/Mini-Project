-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatGbFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180716  ErFelk Bug 142868, Modified Create_Details__ to include opposite_country in both IMPORT and EXPORT reports.
--  170309  NiDalk Bug 134683, Modified Create_Details__ to show Agent Line only when representative is available.
--  160708  PrYaLK Bug 129609, Modified Create_Output() and Create_Details__() by adding some new logics and removed Write_Block__()
--  160708         since UK intrastat file format has been changed.
--  130813  AwWelk TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130731  MaIklk TIBE-847, Removed inst_TaxLiabilityCountries_ global constant and used conditional compilation instead.
--  120409  NipKlk Bug 102036, Modified Create_Details__ by changing representative vat no length 8 to 9 and to remove
--  120409  NipKlk hyphen between company vat no, branch no and from company vat no.
--  120221  TiRalk Bug 100356, Modified CURSOR get_lines by altering invoiced_amount to include charge amounts.
--  110223  PraWlk Bug 95757, Modified Create_Details__() by adding delivery terms DAT and DAP to the cursor get_lines.
--  110309  Bmekse DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                 inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203  Elarse Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead.
--  101110  GayDLK Bug 94088, Added two new delivery terms 'DAF' and 'FCA' to the DECODE function in 
--  101110         SELECT and GROUP BY clauses of Create_Details__().
--  100511  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090601  SaWjlk  Bug 83173, Removed the prog text duplications.
--  060810  ChJalk Modified hard_coded dates to be able to use any calendar.
--  060522  Asawlk Bug 57961, Increased the length of nad_1_party_details_ to VARCHAR2(13).
--  060123  NiDalk Added Assert safe annotation. 
--  060106  RoJalk Bug 55090, Modified the get_lines cursor in Create_Details__
--  060106         to include additional cost amount in invoiced_amount calculation. 
--  050920  NiDalk Removed unused variables.
--  050905  NaWalk Replaced substrb with substr.
--  041004  ErSolk Bug 47109, Modified procedures Create_Details__ and Create_Output.
--  040301  GeKalk  Replaced substrb with substr for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  040203  NaWalk Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.  
--  040202  NaWalk Removed the fourth variable of DBMS_SQL inside the loop,for Unicode modification.
--  020312  DaZa  Bug fix 28308, added ABS on intrastat_alt_qty so we dont get "-x * -y results" when we multiply with the regular qty.
--  010525 JSAnse Bug fix 21463, Added call to General_SYS.Init_Method in procedures Create_Details__ and Write_Block__.
--  010411 DaJoLK Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and 
--                TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  010322  DAZA  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Details__
--   Method fetches the detail data for a specific intrastat.
PROCEDURE Create_Details__ (
   output_clob_         IN OUT CLOB,
   intrastat_id_        IN     NUMBER,
   intrastat_direction_ IN     VARCHAR2,
   creation_date_       IN     DATE,
   end_date_            IN     DATE,
   company_             IN     VARCHAR2,
   bransch_no_          IN     VARCHAR2,
   bransch_no_repr_     IN     VARCHAR2,
   company_vat_no_      IN     VARCHAR2,
   repr_tax_no_         IN     VARCHAR2,
   company_contact_     IN     VARCHAR2,
   representative_      IN     VARCHAR2,
   rep_curr_code_       IN     VARCHAR2,
   rep_curr_rate_       IN     NUMBER,
   country_code_        IN     VARCHAR2 ) 
IS
   -- agent header record
   agent_flag_rec_        VARCHAR2(1) := 'A';
   agent_vat_no_          VARCHAR2(9);
   agent_branch_no_       VARCHAR2(3);
   agent_rep_name_        VARCHAR2(30);
   agent_empty1_          VARCHAR2(1);
   agent_empty2_          VARCHAR2(1);
   agent_empty3_          VARCHAR2(1);
   agent_empty4_          VARCHAR2(1);
   
   -- trader header record
   trader_flag_rec_       VARCHAR2(1) := 'T';
   trader_vat_no_         VARCHAR2(9);
   trader_branch_no_      VARCHAR2(3);
   trader_rep_name_       VARCHAR2(30);
   return_flag_           VARCHAR2(1);
   flow_of_goods_         VARCHAR2(1);
   trader_end_date_       VARCHAR2(6);
   trader_period_         VARCHAR2(4);
   version_               VARCHAR2(5) := 'CSV02';
   
   -- line record
   commodity_code_        VARCHAR2(8);
   value_                 VARCHAR2(14);
   delivery_terms_        VARCHAR2(3);
   notc_                  VARCHAR2(2);
   net_mass_              VARCHAR2(11);
   supp_units_            VARCHAR2(11);
   country_rec_           VARCHAR2(2);
   reference_number_      VARCHAR2(11);
   line_                  VARCHAR2(2000);
   dummy_                 NUMBER;

   CURSOR get_lines IS
      SELECT il.customs_stat_no,
             DECODE(il.delivery_terms, 'EXW','EXW', 
                                       'FOB','FOB',
                                       'FAS','FAS',
                                       'CIF','CIF',
                                       'DEQ','DEQ',
                                       'DES','DES',
                                       'CPT','CPT',
                                       'CIP','CIP',
                                       'CFR','CFR',
                                       'DAF','DAF',
                                       'FCA','FCA',
                                       'DDU','DDU',
                                       'DDP','DDP',
                                       'DAT','DAT',
                                       'DAP','DAP','XXX') delivery_terms,             
             cn.country_notc,                
             il.opposite_country,
             DECODE(intrastat_direction_, 'IMPORT', il.country_of_origin, '') country_of_origin,
             il.mode_of_transport,
             SUM(il.quantity * il.net_unit_weight)                            net_weight_sum,
             SUM(ABS(il.intrastat_alt_qty) * il.quantity)                     intrastat_alt_qty_sum,
             SUM((NVL(il.invoiced_unit_price, il.order_unit_price) +
             NVL(il.unit_add_cost_amount_inv, NVL(il.unit_add_cost_amount,0)) +
             NVL(il.unit_charge_amount_inv,0) + NVL(il.unit_charge_amount,0)) * il.quantity) * rep_curr_rate_ invoiced_amount
      FROM   intrastat_line_tab il, country_notc_tab cn
      WHERE  il.intrastat_id = intrastat_id_
      AND    il.intrastat_direction = intrastat_direction_
      AND    il.rowstate = 'Released'        
      AND    il.notc = cn.notc      
      AND    cn.country_code = country_code_      
      GROUP BY  il.customs_stat_no,
                DECODE(il.delivery_terms, 'EXW','EXW', 
                                          'FOB','FOB',
                                          'FAS','FAS',
                                          'CIF','CIF',
                                          'DEQ','DEQ',
                                          'DES','DES',
                                          'CPT','CPT',
                                          'CIP','CIP',
                                          'CFR','CFR',
                                          'DAF','DAF',
                                          'FCA','FCA',
                                          'DDU','DDU',
                                          'DDP','DDP',
                                          'DAT','DAT',
                                          'DAP','DAP','XXX'),
                cn.country_notc,                
                il.opposite_country,
                DECODE(intrastat_direction_, 'IMPORT', il.country_of_origin, ''),
                il.mode_of_transport;

   CURSOR exist_lines IS
      SELECT 1
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction = intrastat_direction_;

BEGIN
   IF (intrastat_direction_ = 'IMPORT') THEN
      flow_of_goods_ := 'A';
   ELSE
      flow_of_goods_ := 'D';
   END IF;
   
   agent_branch_no_  := NVL(RPAD(SUBSTR(bransch_no_repr_,1,3),3),LPAD(' ',3));
   agent_rep_name_   := NVL(RPAD(SUBSTR(representative_,1,30),30),LPAD(' ',30));
   trader_branch_no_ := NVL(RPAD(SUBSTR(bransch_no_,1,3),3),LPAD(' ',3));
   trader_rep_name_  := NVL(RPAD(SUBSTR(company_contact_,1,30),30),LPAD(' ',30));
   trader_end_date_  := to_char(end_date_,'DDMMYY');
   trader_period_    := to_char(end_date_,'MMYY');
   
   OPEN exist_lines;
   FETCH exist_lines INTO dummy_;
   IF (exist_lines%FOUND) THEN
      CLOSE exist_lines;
      return_flag_ := 'X';
   ELSE
      CLOSE exist_lines;
      return_flag_ := 'N';
   END IF;

   -- Remove any country code in the vat numbers
   IF (SUBSTR(company_vat_no_,1,2) = country_code_ ) THEN
      -- do not include country code in the vat no
      trader_vat_no_ := SUBSTR(Filter__(NVL(company_vat_no_,' ')), 3, 9);
   ELSE
      trader_vat_no_ := SUBSTR(Filter__(NVL(company_vat_no_,' ')), 1, 9);
   END IF;
   IF (SUBSTR(repr_tax_no_,1,2) = country_code_) THEN
      -- do not include country code in the vat no
      agent_vat_no_ := SUBSTR(Filter__(NVL(repr_tax_no_,' ')), 3, 9);
   ELSE
      agent_vat_no_ := SUBSTR(Filter__(NVL(repr_tax_no_,' ')), 1, 9);
   END IF;
   
   Client_SYS.Clear_Attr(line_);
   
   -- Create Record Line for Agent Line Details (each column is comma separated)
   -- Show the Agent Line only when representative is available
   IF (representative_ IS NOT NULL) THEN 
      line_ := agent_flag_rec_ ||','||
               agent_vat_no_ ||','||
               agent_branch_no_ ||','||
               agent_rep_name_ ||','||
               agent_empty1_ ||','||
               agent_empty2_ ||','||
               agent_empty3_ ||','||
               agent_empty4_ ||','||
               version_ ||','||
               CHR(13) || CHR(10);

      output_clob_ := output_clob_ || line_;
   END IF;
   
   -- Create Record Line for Trader Line Details (each column is comma separated)
   line_ := trader_flag_rec_ ||','||
            trader_vat_no_ ||','||
            trader_branch_no_ ||','||
            trader_rep_name_||','||
            return_flag_ ||','||
            flow_of_goods_||','||
            trader_end_date_||','||
            trader_period_||','||
            version_||','||
            CHR(13) || CHR(10);
           
   output_clob_ := output_clob_ || line_;

   -- detail blocks
   FOR linerec_ IN get_lines LOOP
      commodity_code_    := NVL(RPAD(SUBSTR(linerec_.customs_stat_no,1,8),8),LPAD(' ',8));
      value_             := LPAD(round(linerec_.invoiced_amount), 14, '0');
      delivery_terms_    := SUBSTR(linerec_.delivery_terms, 1, 3);
      notc_              := LPAD(linerec_.country_notc,2);
      net_mass_          := LPAD(round(linerec_.net_weight_sum), 11, '0');
      supp_units_        := LPAD(round(linerec_.intrastat_alt_qty_sum), 11, '0');
      country_rec_       := RPAD(SUBSTR(linerec_.opposite_country,1,2),2);

      -- fetch a new reference number
      SELECT TO_CHAR(gb_intrastat_seq.nextval) INTO reference_number_ FROM dual;
      
      line_ := commodity_code_||','||
               value_||','||
               delivery_terms_||','||
               notc_||','||
               net_mass_||','||
               supp_units_||','||
               country_rec_||','||
               reference_number_||','||
               CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
   END LOOP;

END Create_Details__;


-- Filter__
--   Method removes unwanted EDIFACT specified characters from a string.
@UncheckedAccess
FUNCTION Filter__ (
   str_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   out_str_ VARCHAR2(2000);
BEGIN
   -- remove any EDIFACTs defined characters 
   out_str_ := replace(str_, '''');  
   out_str_ := replace(out_str_, '+'); 
   out_str_ := replace(out_str_, ':');   
   out_str_ := replace(out_str_, '?');
   out_str_ := replace(out_str_, '-');
   RETURN out_str_;
END Filter__; 



-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Output
--   Method fetches the intrastat data and formats it according to
--   specifications for Great Britain.
PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2,
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2 ) 
IS
   interchange_recipient_    VARCHAR2(35);
   vat_no_                   VARCHAR2(50);
   intrastat_direction_      VARCHAR2(10);
   notc_dummy_               VARCHAR2(2);
   line_                     VARCHAR2(2000);
   direction_count_          NUMBER :=1;
   temp_counter_             NUMBER :=0;

   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'GB';      

   CURSOR get_head IS
      SELECT company,
             representative,
             repr_tax_no,  
             end_date,
             creation_date,
             rep_curr_code,
             bransch_no,
             bransch_no_repr,
             company_contact,
             rep_curr_rate,
             country_code,
             begin_date
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;

   CURSOR get_intercom_name(company_contact_ VARCHAR2, curr_date_ DATE) IS
      SELECT SUBSTR(name, 1, 35)
      FROM   person_info_comm_method
      WHERE  person_id = company_contact_
      AND    method_id_db = 'INTERCOM'
      AND    curr_date_ BETWEEN nvl(valid_from, Database_Sys.first_calendar_date_)
                        AND     nvl(valid_to,   Database_Sys.last_calendar_date_)
      AND    method_default = 'TRUE';

BEGIN
   
   IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
      intrastat_direction_ := 'BOTH';
      direction_count_ := 2;
   ELSIF (intrastat_export_ = 'EXPORT' AND intrastat_import_ IS NULL) THEN
      intrastat_direction_ := intrastat_export_;
   ELSIF (intrastat_export_ IS NULL AND intrastat_import_ = 'IMPORT') THEN
      intrastat_direction_ := intrastat_import_;
   ELSE -- both is null
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

   -- Head blocks
   FOR headrec_ IN get_head LOOP     
      $IF (Component_Invoic_SYS.INSTALLED) $THEN
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, headrec_.country_code, TRUNC(headrec_.creation_date)); 
         IF (vat_no_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOVAT: Tax Number in not defined for the company.');
         END IF;

         IF (SUBSTR(vat_no_,1,2) = headrec_.country_code ) THEN
            vat_no_ := SUBSTR(Filter__(NVL(vat_no_,' ')), 3, 9);
         ELSE
            vat_no_ := SUBSTR(Filter__(NVL(vat_no_,' ')), 1, 9);
         END IF;
      $END

      -- check currency
      IF (headrec_.rep_curr_code != 'GBP') THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCURRGBF: Currency Code :P1 is not a valid currency, only GBP is acceptable', headrec_.rep_curr_code);
      END IF;

      -- check valid intercom
      OPEN get_intercom_name(headrec_.company_contact, headrec_.creation_date);
      FETCH get_intercom_name INTO interchange_recipient_;
      CLOSE get_intercom_name;
      -- communication channel qualifiers (allowed values):
      -- '5013546006194' = INS-Tradanet or BT EDI
      -- 'X400 U9986392' = IBM information exhange
      -- 'DISK' = when data is sent on disk
      -- 'TAPE' = when data is sent on tape
      -- 'PORT' = when data is sent via a Port Community
      -- 'OTHER' = when data is send via X400 or Internet
      IF (interchange_recipient_ NOT IN ('5013546006194','X400 U9986392','DISK','TAPE','PORT','OTHER') OR interchange_recipient_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'UNBBADINTERCOM: Company contact :P1 is missing a valid default intercom. Valid intercom names are 5013546006194, X400 U9986392, DISK, TAPE, PORT and OTHER.', headrec_.company_contact);
      END IF;
      
      FOR i IN 1..direction_count_ LOOP
         IF(direction_count_ = 2)THEN
            temp_counter_ := temp_counter_+1;
            IF(temp_counter_ = 1)THEN
               intrastat_direction_ := 'IMPORT';
            ELSE
               intrastat_direction_ := 'EXPORT';
            END IF;
         END IF;

         Create_Details__(output_clob_,
                          intrastat_id_,
                          intrastat_direction_,
                          headrec_.creation_date,
                          headrec_.end_date,
                          headrec_.company,
                          headrec_.bransch_no,
                          headrec_.bransch_no_repr,
                          vat_no_,
                          headrec_.repr_tax_no,
                          headrec_.company_contact,
                          headrec_.representative,
                          headrec_.rep_curr_code,
                          headrec_.rep_curr_rate,
                          headrec_.country_code);
         output_clob_ := output_clob_ || line_;
      END LOOP;
      
   END LOOP;   -- head loop

   info_        := Client_SYS.Get_All_Info;    
END Create_Output;
