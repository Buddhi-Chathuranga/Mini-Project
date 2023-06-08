-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatFiFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210913  ErFelk  Bug 160574(SC21R2-2536), Modified Create_Detail__() by changing the reg_no parameter type to VARCHAR2. Modified Create_Output()
--  210913          by concatenating vat_no and reg_no for csv file.
--  210809  ErFelk  Bug 159926(SCZ-15791), Modified the code to support asc and csv file formats.
--  160308  PrYaLK  Bug 127102, Modified Create_Detail__() by adding semicolon as a column seperator when creating record lines for
--  160308          import and export files.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130731  MaIklk  TIBE-845, Removed inst_TaxLiabilityCountries_ global constant and used conditional compilation instead.
--  110309  Bmekse  DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                  inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203  Elarse  Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise  Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090601  SaWjlk  Bug 83173, Removed the prog text duplications.
--  071015  MarSlk  Bug 66556, Modified code to include INT code to Declarant code 
--  071015          and sender's identification. Increased the length of variables 
--  071015          reg_no_, additional_code_vat_id_ to avoid buffer too small oracle error. 
--  071015          Formatted the declarant_id_.
--  070411  ChBalk  Replaced SUBSTRB with SUBSTR.
--  061218  SuSalk  LCS Merge 58769, Added new variables and temp_head cursor for fix the bug. Reduced 
--  061218          Create_Detail__ procedure call in the Create_Output procedure to one and  
--  061218          take it into inner FOR LOOP. SUM line preparation part moved to inner FOR LOOP. 
--  060120  NiDalk  Added Assert safe annotation. 
--  050919  NiDalk  Removed unused variables.
--  040301  GeKalk  Replaced substrb with substr for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  040202  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.  
--  030801  KeFelk  Performed SP4 Merge. (SP4Only)
--  030507  ThAjlk  Bug 36761, Modified the Cursor get_lines in Procedure Create_Detail__  in order to get the 
--  030507          correct value for alternate_qty. Added ABS on alternate_qty to prevent getting "-x * -y results"
--  030507          when we multiply with the regular qty. 
--  010525  JSAnse  Bug fix 21463, Added call to General_SYS.Init_Method to procedures Create_Detail__ and Create_Output.
--  010411  DaJoLK  Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and 
--                  TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  010212  GEKALK  Created.
--  010305  GEKALK  Changed the NOTC check to consider the intrastat_direction..
--  010306  GEKALK  Removed the above correction. Added a new Procedure Create_Details.
--  010307  GEKALK  Changed the calculation for statistical_value.
--  010313  GEKALK  Added a new where condition to select lines where row_state is not equal to Cancelled
--                  from Intrastat_Line_Tab.
--  010314  GEKALK  Added two error messages.
--  010316  GEKALK  Changed the selection of Country_of_origin.
--  010320  GEKALK  Some corrections done in some error messages
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Detail__
--   Method fetches the detail data for a specific intrastat.
PROCEDURE Create_Detail__ (
   output_clob_               IN OUT CLOB,
   seq_no_                    IN NUMBER,
   reg_no_                    IN VARCHAR2, 
   line_counter_              IN OUT NUMBER,
   nim_counter_               IN OUT NUMBER,
   tot_invoice_amount_item_   IN OUT NUMBER,
   intrastat_id_              IN NUMBER,
   intrastat_direction_       IN VARCHAR2,
   vat_no_                    IN VARCHAR2,
   h_repr_tax_no_             IN VARCHAR2,
   h_end_date_                IN DATE,
   h_customs_id_              IN VARCHAR2,
   h_creation_date_           IN DATE,
   h_bransch_no_              IN VARCHAR2,
   h_country_code_            IN VARCHAR2,
   h_rep_curr_rate_           IN NUMBER,
   h_rep_curr_code_           IN VARCHAR2)
   
IS
   --header record
   header_rec_type_         VARCHAR2(3) := 'OTS';
   intrastat_dec_id_        VARCHAR2(13);
   flow_of_goods_           VARCHAR2(1);
   dec_period_              VARCHAR2(4);
   statistical_procedure_   VARCHAR2(3);
   sent_msg_id_             VARCHAR2(13) := LPAD(' ',13);
   declarant_id_            VARCHAR2(17);
   dec_agent_id_            VARCHAR2(17);
   dec_agent_remain_id_     VARCHAR2(10);
   competent_customs_id_    VARCHAR2(17);
   dec_currency_            VARCHAR2(3);

   --transaction record
   trans_rec_type_          VARCHAR2(3) := 'NIM';
   item_no_                 VARCHAR2(5);
   commodity_               VARCHAR2(8);
   notc_                    VARCHAR2(2);
   country_of_origin_       VARCHAR2(2);
   country_of_exportation_  VARCHAR2(2);
   country_of_destination_  VARCHAR2(2);
   mode_of_transport_       VARCHAR2(1);
   statistical_value_       VARCHAR2(10);
   dec_reference_           VARCHAR2(15) := LPAD(' ', 15);
   qualifier1_              VARCHAR2(3) := 'WT ';
   net_weight_code1_        VARCHAR2(3) := 'KGM';
   mass1_                   VARCHAR2(10);
   qualifier2_              VARCHAR2(3) := 'AAE';
   other_mass_code_         VARCHAR2(3);
   mass2_                   VARCHAR2(10);
   invoice_amount_item_     VARCHAR2(10);

   end_date_                VARCHAR2(2);
   customs_id_              VARCHAR2(2);
   creation_date_           VARCHAR2(3);
   bransch_no_              VARCHAR2(3);
   counter_                 VARCHAR2(3) := 0;
   line_                    VARCHAR2(2000);
   dummy_                   NUMBER;
   nim_rec_counter_         NUMBER;   
   
   -- Get all the line details
   CURSOR get_lines IS
      SELECT i.intrastat_direction,
             i.opposite_country,
             DECODE(intrastat_direction_, 'IMPORT', i.country_of_origin, '') country_of_origin,
             i.mode_of_transport,
             i.statistical_procedure,
             cn.country_notc,
             i.customs_stat_no,
             i.intrastat_alt_unit_meas,
             SUM(i.quantity * i.net_unit_weight) mass1,
             SUM(i.quantity * nvl(abs(i.intrastat_alt_qty),0)) mass2,
             SUM(i.quantity * nvl(i.invoiced_unit_price, i.order_unit_price)) * h_rep_curr_rate_  invoice_value,
             SUM((nvl(i.invoiced_unit_price,nvl(i.order_unit_price,0)) + 
                  nvl(i.unit_add_cost_amount_inv,nvl(i.unit_add_cost_amount,0)) +
                  nvl(i.unit_charge_amount_inv,0) +
                  nvl(i.unit_charge_amount,0)) * i.quantity) * h_rep_curr_rate_ statistical_value
      FROM   intrastat_line_tab i, country_notc_tab cn
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    rowstate           != 'Cancelled'
      AND    i.notc = cn.notc
      AND    cn.country_code = h_country_code_
      GROUP BY  i.intrastat_direction,
                i.opposite_country,
                DECODE(intrastat_direction_, 'IMPORT', i.country_of_origin, ''),
                i.mode_of_transport,
                i.statistical_procedure,
                cn.country_notc,
                i.customs_stat_no,
                i.intrastat_alt_unit_meas;
                
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
   
   end_date_             := to_char(h_end_date_, 'YY');
   customs_id_           := NVL(RPAD(SUBSTR(h_customs_id_,1,2),2),LPAD(' ',2));
   creation_date_        := to_char(h_creation_date_,'DDD');
   bransch_no_           := NVL(RPAD(SUBSTR(h_bransch_no_,1,3),3),LPAD(' ',3));
   dec_period_           := to_char(h_end_date_, 'YYMM');
   dec_agent_id_         := NVL(RPAD(SUBSTR(h_repr_tax_no_, 1, 17),17),LPAD(' ',17));
   dec_agent_remain_id_  := NVL(RPAD(SUBSTR(h_repr_tax_no_, 18, 10),10),LPAD(' ',10));
   competent_customs_id_ := NVL(RPAD(SUBSTR(h_customs_id_,1,17),17),LPAD(' ',17));
      
   OPEN exist_lines;
   FETCH exist_lines INTO dummy_;
   IF (exist_lines%FOUND) THEN
      CLOSE exist_lines;
      statistical_procedure_ := RPAD('T',3);
   ELSE
      CLOSE exist_lines;
      statistical_procedure_ := 'NIL';
   END IF;
   
   line_counter_     := line_counter_ + 1;
   counter_          := LPAD(seq_no_,3,'0');
   
   --declarant_id_     := h_country_code_ || nvl(RPAD(substrb(vat_no_, 1, 15),15),LPAD(' ',15));
   declarant_id_     := RPAD(NVL(SUBSTR(vat_no_, 1, 12) || SUBSTR(reg_no_, 1,5), '                 '),17);

   intrastat_dec_id_ := end_date_ || customs_id_ || creation_date_ || bransch_no_ || counter_;

   IF ( h_rep_curr_code_ IN ('FIM','EUR')) THEN
      dec_currency_  := h_rep_curr_code_;
   ELSE
      Error_SYS.Record_General(lu_name_, 'WRONGCURRFIF: Currency Code :P1 is not a valid currency, only FIM and EUR is acceptable', h_rep_curr_code_); 
   END IF;
   
   line_ :=  header_rec_type_ ||
             intrastat_dec_id_ ||
             flow_of_goods_ ||
             dec_period_ ||
             statistical_procedure_ ||
             sent_msg_id_ ||
             declarant_id_ ||
             dec_agent_id_ ||
             dec_agent_remain_id_ ||
             competent_customs_id_ ||
             dec_currency_ ||
             CHR(13) || CHR(10);
             
   output_clob_ := output_clob_ || line_;
      
   nim_rec_counter_ := 0;
   FOR linerec_ IN get_lines LOOP
         nim_rec_counter_        := nim_rec_counter_ + 1;
         nim_counter_            := nim_counter_ + 1;
         item_no_                := LPAD(nim_rec_counter_,5,'0');
         commodity_              := NVL(RPAD(SUBSTR(linerec_.customs_stat_no,1,8),8),LPAD(' ',8));
         notc_                   := LPAD(linerec_.country_notc,2);

         country_of_origin_      := NVL(RPAD(SUBSTR(linerec_.country_of_origin,1,2),2),LPAD(' ',2));
         
         IF (linerec_.intrastat_direction = 'IMPORT') THEN
            country_of_exportation_ := RPAD(SUBSTR(linerec_.opposite_country,1,2),2);
         ELSE
            country_of_exportation_ := LPAD(' ',2);
         END IF;
         IF (linerec_.intrastat_direction = 'EXPORT') THEN
            country_of_destination_ := RPAD(SUBSTR(linerec_.opposite_country,1,2),2);
         ELSE
            country_of_destination_ := LPAD(' ',2);  -- import
         END IF;

         mode_of_transport_         := NVL(linerec_.mode_of_transport,' ');
         statistical_value_         := LPAD(round(linerec_.statistical_value), 10, '0');
         mass1_                     := LPAD(round(linerec_.mass1), 10, '0');
         other_mass_code_           := RPAD(SUBSTR(NVL(linerec_.intrastat_alt_unit_meas,'   '),1,3),3);
         mass2_                     := LPAD(round(linerec_.mass2), 10, '0');
         invoice_amount_item_       := LPAD(round(linerec_.invoice_value), 10, '0');
         tot_invoice_amount_item_   := tot_invoice_amount_item_ +  round(linerec_.invoice_value);
         
         line_ := trans_rec_type_ ||
                  item_no_ ||
                  commodity_ ||
                  notc_ ||
                  country_of_origin_ ||
                  country_of_exportation_ ||
                  country_of_destination_ ||
                  mode_of_transport_ ||
                  statistical_value_ ||
                  dec_reference_ ||
                  qualifier1_ ||
                  net_weight_code1_ ||
                  mass1_ ||
                  qualifier2_ ||
                  other_mass_code_||
                  mass2_ ||
                  invoice_amount_item_ ||
                  CHR(13) || CHR(10);
         output_clob_ := output_clob_ || line_;                        
   END LOOP;         
         
END Create_Detail__;

PROCEDURE Create_Details_For_Csv (
   output_clob_         IN OUT CLOB,
   intrastat_id_        IN NUMBER,   
   intrastat_direction_ IN VARCHAR2,
   country_code_        IN VARCHAR2,
   rep_curr_rate_       IN NUMBER )  
IS
   reference_  VARCHAR2(15);
   line_count_ NUMBER := 0;
   line_       VARCHAR2(32000);
   
   -- Get all the line details
   CURSOR get_lines IS
      SELECT i.intrastat_direction,
             i.opposite_country,
             DECODE(intrastat_direction_, 'IMPORT', i.country_of_origin, '') country_of_origin,
             i.mode_of_transport,             
             cn.country_notc,
             i.customs_stat_no,             
             SUM(i.quantity * i.net_unit_weight) net_mass,
             SUM(i.quantity * nvl(abs(i.intrastat_alt_qty),0)) alternative_qty,
             SUM(i.quantity * nvl(i.invoiced_unit_price, i.order_unit_price)) * rep_curr_rate_  invoice_value,
             SUM((nvl(i.invoiced_unit_price,nvl(i.order_unit_price,0)) + 
                  nvl(i.unit_add_cost_amount_inv,nvl(i.unit_add_cost_amount,0)) +
                  nvl(i.unit_charge_amount_inv,0) +
                  nvl(i.unit_charge_amount,0)) * i.quantity) * rep_curr_rate_ statistical_value
      FROM   intrastat_line_tab i, country_notc_tab cn
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    rowstate           != 'Cancelled'
      AND    i.notc = cn.notc
      AND    cn.country_code = country_code_
      GROUP BY  i.intrastat_direction,
                i.opposite_country,
                DECODE(intrastat_direction_, 'IMPORT', i.country_of_origin, ''),
                i.mode_of_transport,                
                cn.country_notc,
                i.customs_stat_no;                                
   
BEGIN      
   FOR linerec_ IN get_lines LOOP    
      line_count_ := line_count_ + 1;
         IF line_count_ > 1 THEN
             -- basic declaration details
            line_ :=  ';'||';'||';'||';';
            output_clob_ := output_clob_ || line_; 
         END IF; 
            
      line_ := linerec_.customs_stat_no ||';'||
               linerec_.country_notc ||';'||
               linerec_.opposite_country ||';'||
               linerec_.country_of_origin ||';'||
               linerec_.mode_of_transport ||';'||
               SUBSTR(TO_CHAR(ROUND(ABS(linerec_.net_mass))), 1, 10) ||';'||
               SUBSTR(TO_CHAR(ROUND(ABS(linerec_.alternative_qty))), 1, 10) ||';'||
               SUBSTR(TO_CHAR(ROUND(ABS(linerec_.invoice_value))), 1, 10) ||';'||
               SUBSTR(TO_CHAR(ROUND(ABS(linerec_.statistical_value))), 1, 10) ||';'||
               reference_ ||';'||
               CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;                        
   END LOOP;   
   
END Create_Details_For_Csv;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Output
--   Method fetches the intrastat data and formats it according to
--   specifications for Finland.
PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2,
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,  
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2,
   file_extension_       IN  VARCHAR2 )
IS
   --sender record
   sender_rec_type_         VARCHAR2(3) := 'KON';
   sender_fix_              VARCHAR2(4) := '0037';
   sender_vat_no_           VARCHAR2(13);
   sender_id_               VARCHAR2(17);
   
   --end record
   end_rec_type_            VARCHAR2(3) := 'SUM';
   tot_reported_items_      VARCHAR2(18);
   tot_reported_invoiced_amount_  VARCHAR2(18);
   
   line_                    VARCHAR2(2000);  
   vat_no_                  VARCHAR2(52);
   notc_dummy_              VARCHAR2(5);
   intrastat_direction_     VARCHAR2(10);
   nim_counter_             NUMBER;
   line_counter_            NUMBER:=0;
   tot_invoice_amount_item_ NUMBER;
   repr_tax_no_             VARCHAR2(52);

   direction_count_         NUMBER :=1;
   temp_counter_            NUMBER :=0;
   kon_line_                VARCHAR2(2000);
   additional_code_vat_id_  VARCHAR2(20);
   
   file_print_export_       VARCHAR2(30);
   file_print_import_       VARCHAR2(30);
   seq_no_                  NUMBER; 
   reg_no_                  VARCHAR2(20);
   period_                  VARCHAR2(6);
   flow_of_goods_           VARCHAR2(1);
   direction_lines_         NUMBER := 0;
   
   -- Get all the header details
   CURSOR get_head IS
      SELECT company,
             representative,
             repr_tax_no,
             customs_id,
             --begin_date,
             end_date,
             bransch_no,
             creation_date,
             rep_curr_code,
             rep_curr_rate,
             country_code,
             registration_no
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR temp_head IS
      SELECT file_print_export,
             file_print_import,
             export_progress_no,
             import_progress_no,
             registration_no
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;  
      
   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
      CURSOR get_country_notc (notc_ VARCHAR2) IS
         SELECT country_notc
         FROM   country_notc_tab
         WHERE  notc = notc_
         AND    country_code = 'FI'; 
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

      IF (headrec_.customs_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CUSTIDNULL: The Customs Id must have a value.'); 
      END IF;
      
      --Get the Company Vat Code
      $IF (Component_Invoic_SYS.INSTALLED) $THEN
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, headrec_.country_code, TRUNC(headrec_.creation_date));
      $END
      
      OPEN temp_head ; 
      FETCH temp_head INTO file_print_export_,file_print_import_,export_progress_no_,import_progress_no_,reg_no_;
      CLOSE temp_head;
         
      IF (file_extension_ != 'asc')  THEN 
         
         line_ :=  'Tiedonantaja' ||';'||
                   'Jakso' ||';'||
                   'Suunta' ||';'||
                   'Asiamies' ||';'||
                   'CN8' ||';'||
                   'Kauppa' ||';'||
                   Database_SYS.Unistr('J\00E4senmaa') ||';'||
                   Database_SYS.Unistr('Alkuper\00E4maa') ||';'||
                   'Kuljetusmuoto' ||';'||
                   'Nettopaino' ||';'||
                   Database_SYS.Unistr('Lis\00E4yksik\00F6t') ||';'||
                   'Laskutusarvo euroissa' || ';' ||
                   'Tilastoarvo euroissa' || ';' ||
                   'Viite' || ';' ||
                   CHR(13) || CHR(10);

         output_clob_ := output_clob_ || line_;
   
         IF (intrastat_direction_ = 'IMPORT') THEN
            -- arrivals
            flow_of_goods_ := '1';
         ELSE
            -- dispatches
            flow_of_goods_ := '2';
         END IF;
         period_ := TO_CHAR(headrec_.end_date,'YYYY') || TO_CHAR(headrec_.end_date,'MM');
         IF (headrec_.representative IS NOT NULL) THEN
            sender_vat_no_ := headrec_.repr_tax_no;
         END IF;
         -- basic declaration details
         line_ :=  SUBSTR(vat_no_, 1, 10) || SUBSTR(reg_no_, 1,5) ||';'||
                   period_ ||';'||
                   flow_of_goods_ ||';'||
                   sender_vat_no_ ||';';
         output_clob_ := output_clob_ || line_; 
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
           
         IF (intrastat_direction_ = 'IMPORT') THEN
            IF ( file_print_import_ != 'IMPORT FILE PRINTED') THEN
               SELECT fi_progress_no.NEXTVAL   
               INTO seq_no_
               FROM dual;
               import_progress_no_ := seq_no_;
            ELSE
               seq_no_ := import_progress_no_;
            END IF;
         ELSIF (intrastat_direction_ = 'EXPORT') THEN
            IF (file_print_export_ != 'EXPORT FILE PRINTED') THEN
               SELECT fi_progress_no.NEXTVAL
               INTO seq_no_
               FROM dual;
               export_progress_no_ := seq_no_;
            ELSE
               seq_no_ := export_progress_no_;
            END IF;
         END IF;
         
         IF (file_extension_ = 'asc') THEN 
            IF (headrec_.bransch_no IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'BRANCHNONULL: The Branch Code must have a value.'); 
            END IF;
            -- remove the country code from the vat_no
            IF (SUBSTR(vat_no_, 1, 2) != headrec_.country_code) THEN
               vat_no_ := 'FI'||vat_no_;
            END IF;

            IF (SUBSTR(headrec_.repr_tax_no, 1, 2) != headrec_.country_code) THEN
               repr_tax_no_ := 'FI'||headrec_.repr_tax_no;
            END IF;

            IF (headrec_.representative IS NULL) THEN
               sender_vat_no_ := NVL(RPAD(SUBSTR(vat_no_, 3, 11),13),LPAD(' ',13));
            ELSE
               sender_vat_no_ := NVL(RPAD(SUBSTR(repr_tax_no_, 3, 11),13),LPAD(' ',13));
            END IF;


            sender_id_  := sender_fix_ || sender_vat_no_;
            sender_id_  := RPAD(sender_id_,12);

            additional_code_vat_id_ := RPAD(NVL(headrec_.registration_no,'     '),5);

            kon_line_ := sender_rec_type_ ||
                         sender_id_ ||
                         additional_code_vat_id_ ||
                         CHR(13) || CHR(10);
            output_clob_ := output_clob_ || kon_line_;
            nim_counter_ :=0;
            tot_invoice_amount_item_ :=0;

            Create_Detail__( output_clob_,
                             seq_no_,
                             reg_no_,
                             line_counter_,
                             nim_counter_,
                             tot_invoice_amount_item_,
                             intrastat_id_,
                             intrastat_direction_,
                             vat_no_,
                             repr_tax_no_,
                             headrec_.end_date,
                             headrec_.customs_id,
                             headrec_.creation_date,
                             headrec_.bransch_no,
                             headrec_.country_code,
                             headrec_.rep_curr_rate,
                             headrec_.rep_curr_code);

            tot_reported_items_ := LPAD(nim_counter_,18,'0');
            tot_reported_invoiced_amount_ := LPAD(tot_invoice_amount_item_,18,'0');
            line_ := end_rec_type_ ||
                     tot_reported_items_ ||
                     tot_reported_invoiced_amount_ ||
                     CHR(13) || CHR(10);
            output_clob_ := output_clob_ || line_;
         ELSE            
            direction_lines_ := direction_lines_ + 1;
            IF (direction_lines_ > 1) THEN
                -- basic declaration details
               line_ :=  ';'||';'||';'||';';
               output_clob_ := output_clob_ || line_; 
            END IF;   
            Create_Details_For_Csv( output_clob_,
                                    intrastat_id_,
                                    intrastat_direction_,
                                    headrec_.country_code,                                    
                                    headrec_.rep_curr_rate);
         END IF;   
      END LOOP; 
   END LOOP;   

END Create_Output;