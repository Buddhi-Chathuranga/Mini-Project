-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatItFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220124  ErFelk  Bug 161523(FI21R2-7714), Modified CURSOR get_line_summary and CURSOR get_lines by adding DECODE to some fields. This is a merge from GET.
--  220124  ErFelk  Bug 161502(FI21R2-7088), All lines in Italian Intrastat should start with EUROX. This is a merge from GET.
--  220120  ErFelk  Bug 161243(FI21R2-6364), Removed Is_Alphabetic_Character___(). Modified Create_Output() to correctly show opponent tax id. This is a merge from GET.  
--  211104  ErFelk  Bug 161107(SC21R2-4958), Modified Create_Output() by removing the fetching of line_vat_no logic and replaced it by opponent tax id taken from intrastat line.
--  200831  SBalLK  GESPRING20-537, Added Get_Invoice_Value___(), Is_Alphabetic_Character___() methods and
--  200831          modified Create_Output() method to enabled italy intrastat localization.
--  140418  TiRalk  Bug 116087, Modified Create_Output() to fetch line_vat_no_ properly when opponent type is company.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130731  MaIklk  TIBE-850, Removed global constants and used conditional compilation instead.
--  130816  IsSalk  Bug 111274, Modified Create_Output() to get the Customer's Tax ID according to the delivery country.
--  130710  AyAmlk  Bug 111144, Modified Decode_Val() to match the END statement name with the procedure/function name.
--  120410  AyAmlk  Bug 100608, Increased the length of delivery_terms_ in Create_Output().
--  120405  RoJalk  Bug 101284, Modified Create_Output() to avoid error message when fetching opponent number document address
--  120405          to generate file with return transactions and get the correct opponent document address country code
--  120405          when the opponent is supplier, customer and company.
--  110323  PraWlk  Bug 95757, Modified Create_Output() by adding delivery terms DAT and DAP.
--                  Replaced inst_CustomerInfoVat_ with inst_CustomerDocumentTaxInfo_.
--  110309  Bmekse  DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                  inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203  Elarse  Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise  Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead.
--  090928  ChFolk  Removed unused variables in the package.
------------------------------------ 14.0.0 ----------------------------------
--  090601  SaWjlk  Bug 83173, Removed the prog text duplications.
--  060911  ChBalk  Merged call 53157, Restructured the code to fulfill the new requirements for Italy.
--  060123  NiDalk  Added Assert safe annotation. 
--  040428  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs.
--  040301  GeKalk  Replaced substrb with substr for UNICODE modifications.
--  040202  NaWalk  Removed the fourth variable of DBMS_SQL inside the loop,for Unicode modification.
--  040127  NaWalk  Modified the code in method Create_Output to improve performance.
--  040126  NaWalk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.  
------------------------------------ 13.3.0 ----------------------------------
--  011016  DaZa  Created using spec 'Functional specification for IID 10235 
--                - Italian Intrastat File' by Martin Korn
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-- gelr:italy_intrastat, start
FUNCTION Get_Invoice_Value___(
   invoice_amount_  IN NUMBER) RETURN VARCHAR2
IS
   invoiced_value_         NUMBER;
   invoiced_value_in_char_ VARCHAR2(13);
BEGIN
   IF (invoice_amount_ < 0) THEN
      invoiced_value_ := ABS(invoice_amount_);
      CASE (SUBSTR(invoice_amount_, -1, 1))
         WHEN 0 THEN invoiced_value_in_char_ := ((invoiced_value_ - 0)/10) || 'p';
         WHEN 1 THEN invoiced_value_in_char_ := ((invoiced_value_ - 1)/10) || 'q';
         WHEN 2 THEN invoiced_value_in_char_ := ((invoiced_value_ - 2)/10) || 'r';
         WHEN 3 THEN invoiced_value_in_char_ := ((invoiced_value_ - 3)/10) || 's';
         WHEN 4 THEN invoiced_value_in_char_ := ((invoiced_value_ - 4)/10) || 't';
         WHEN 5 THEN invoiced_value_in_char_ := ((invoiced_value_ - 5)/10) || 'u';
         WHEN 6 THEN invoiced_value_in_char_ := ((invoiced_value_ - 6)/10) || 'v';
         WHEN 7 THEN invoiced_value_in_char_ := ((invoiced_value_ - 7)/10) || 'w';
         WHEN 8 THEN invoiced_value_in_char_ := ((invoiced_value_ - 8)/10) || 'x';
         WHEN 9 THEN invoiced_value_in_char_ := ((invoiced_value_ - 9)/10) || 'y';
      END CASE;
   ELSE
      invoiced_value_in_char_ := TO_CHAR(invoice_amount_);
   END IF;
   RETURN invoiced_value_in_char_;
END Get_Invoice_Value___;
-- gelr:italy_intrastat, end

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2,
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2 )
IS
  
   line_                      VARCHAR2(2000);
   rep_curr_rate_             NUMBER;
   country_code_              VARCHAR2(2);
   intrastat_direction_       VARCHAR2(10);
   notc_dummy_                VARCHAR2(2);
   no_of_rows_                NUMBER := 0;
   vat_no_                    VARCHAR2(50);   
   progress_no_               NUMBER;   
   no_of_lines_               NUMBER := 0;
   total_invoiced_            NUMBER := 0;
   line_progress_no_          NUMBER := 0;
   document_address_          VARCHAR2(50);
   doc_country_code_          VARCHAR2(2);
   supp_currency_             VARCHAR2(3);
   currency_type_             VARCHAR2(10);
   conv_factor_               NUMBER;
   currency_rate_             NUMBER;
   invoice_value_curr_        NUMBER;
   delivery_terms_            VARCHAR2(5);
   country_of_origin_dummy_   NUMBER;
   delivery_country_code_     VARCHAR2(2);
   -- gelr:italy_intrastat, start
   italy_intrastat_enabled_         BOOLEAN := FALSE;
   italy_intrastat_                 VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   no_of_service_lines_             NUMBER := 0;
   total_service_invoiced_          NUMBER := 0;
   no_of_adjusted_service_lines_    NUMBER := 0;
   total_adjusted_service_invoiced_ NUMBER := 0;
   no_of_adjusted_lines_            NUMBER := 0;
   total_adjusted_invoiced_         NUMBER := 0;
   service_line_progress_no_        NUMBER := 0;
   invoice_doc_country_code_        VARCHAR2(2);
   -- gelr:italy_intrastat, end
   substr_no_                       NUMBER;

   CURSOR get_notc IS
      SELECT DISTINCT notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'IT';

   CURSOR check_opponent_number IS
      SELECT COUNT(*)                  
      FROM   intrastat_line_tab il
      WHERE  il.intrastat_id = intrastat_id_
      AND    il.intrastat_direction = intrastat_direction_
      AND    il.rowstate = 'Released'
      AND    il.opponent_number IS NULL;

    CURSOR check_opponent_type IS
      SELECT COUNT(*)                  
      FROM   intrastat_line_tab il
      WHERE  il.intrastat_id = intrastat_id_
      AND    il.intrastat_direction = intrastat_direction_
      AND    il.rowstate = 'Released'
      AND    il.opponent_type IS NULL
      AND    il.opponent_number IS NOT NULL;

   --            export_progress_no and import_progress_no to the cursor.
   CURSOR get_head IS
      SELECT rep_curr_code,
             rep_curr_rate,
             country_code,
             company,
             begin_date,
             end_date,
             repr_tax_no,
             file_print_export,
             file_print_import,
             export_progress_no,
             import_progress_no,
             creation_date,
             to_invoice_date
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;

   --            country_of_origin and intrastat_alt_qty_sum and removed partner.
   CURSOR get_lines IS
      SELECT DECODE(il.customs_stat_no, NULL, NULL, il.opposite_country)  opposite_country,
             DECODE(il.customs_stat_no, NULL, NULL, il.mode_of_transport) mode_of_transport,
             DECODE(il.customs_stat_no, NULL, NULL, il.delivery_terms)    delivery_terms,
             DECODE(intrastat_direction_, 'IMPORT', DECODE(il.customs_stat_no, NULL, NULL, il.country_of_origin), NULL) country_of_origin,
             il.opponent_number,
             il.contract,
             il.opponent_type,
             il.opponent_tax_id,
             DECODE(il.customs_stat_no, NULL, NULL, SUBSTR(il.county, 1, 2)) county,
             DECODE(il.customs_stat_no, NULL, NULL,
             DECODE(il.triangulation, 'TRIANGULATION', 
                    DECODE(cn.country_notc,'1','A',
                                           '2','B',
                                           '3','C',
                                           '4','D',
                                           '5','E',
                                           '6','F',
                                           '7','G',
                                           '8','H',
                                           '9','I', cn.country_notc), 
                    cn.country_notc)) decoded_country_notc,                                            
             il.customs_stat_no,
             SUM((NVL(il.invoiced_unit_price, NVL(il.order_unit_price,0)) + 
                  NVL(il.unit_add_cost_amount_inv, NVL(il.unit_add_cost_amount,0)) +
                  NVL(il.unit_charge_amount_inv,0) + NVL(il.unit_charge_amount,0)) * 
                  il.quantity) * rep_curr_rate_ invoiced_value,
             SUM(il.quantity * NVL(il.net_unit_weight,0)) net_weight_sum,
             SUM(NVL(il.intrastat_alt_qty, 0) * il.quantity) intrastat_alt_qty_sum,
             -- gelr:italy_intrastat, start
             SUM(NVL(il.opposite_country_curr_amt, 0))                  opposite_country_curr_amt,
             DECODE(italy_intrastat_, 'FALSE', DECODE(il.customs_stat_no, NULL, il.invoice_serie,  NULL), NULL)  invoice_serie,             -- Need to set value to null when italy intrastat not enabled to discard the effect of this attibute
             DECODE(italy_intrastat_, 'FALSE', DECODE(il.customs_stat_no, NULL, il.invoice_number, NULL), NULL) invoice_number,            -- Need to set value to null when italy intrastat not enabled to discard the effect of this attibute
             DECODE(il.customs_stat_no, NULL, il.invoice_date,   NULL) invoice_date,
             il.adjust_to_prev_intrastat,
             DECODE(il.customs_stat_no, NULL, il.service_statistical_code, NULL) service_statistical_code,
             DECODE(il.customs_stat_no, NULL, il.service_way,    NULL) service_way,
             DECODE(il.customs_stat_no, NULL, il.service_payment_way,    NULL) service_payment_way,             
             il.protocol_no
             -- gelr:italy_intrastat, end
      FROM   intrastat_line_tab il, country_notc_tab cn
      WHERE  il.intrastat_id = intrastat_id_
      AND    il.intrastat_direction = intrastat_direction_
      AND    il.rowstate = 'Released'        
      AND    il.notc = cn.notc      
      AND    cn.country_code = country_code_      
      GROUP BY  DECODE(il.customs_stat_no, NULL, NULL, il.opposite_country),
                DECODE(il.customs_stat_no, NULL, NULL, il.mode_of_transport),
                DECODE(il.customs_stat_no, NULL, NULL, il.delivery_terms),
                DECODE(intrastat_direction_, 'IMPORT', DECODE(il.customs_stat_no, NULL, NULL, il.country_of_origin), NULL),
                il.opponent_number,
                il.contract,
                il.opponent_type,
                il.opponent_tax_id,
                DECODE(il.customs_stat_no, NULL, NULL, SUBSTR(il.county, 1, 2)),
                DECODE(il.customs_stat_no, NULL, NULL,
                DECODE(il.triangulation, 'TRIANGULATION', 
                       DECODE(cn.country_notc,'1','A',
                                              '2','B',
                                              '3','C',
                                              '4','D',
                                              '5','E',
                                              '6','F',
                                              '7','G',
                                              '8','H',
                                              '9','I', cn.country_notc), cn.country_notc)),
                il.customs_stat_no,
                -- gelr:italy_intrastat, start
                DECODE(italy_intrastat_, 'FALSE', DECODE(il.customs_stat_no, NULL, il.invoice_serie,  NULL), NULL),               -- Need to set value to null when italy intrastat not enabled to discard the effect of this attibute
                DECODE(italy_intrastat_, 'FALSE', DECODE(il.customs_stat_no, NULL, il.invoice_number, NULL), NULL),              -- Need to set value to null when italy intrastat not enabled to discard the effect of this attibute
                DECODE(il.customs_stat_no, NULL, il.invoice_date,   NULL),
                il.adjust_to_prev_intrastat,
                DECODE(il.customs_stat_no, NULL, il.service_statistical_code, NULL),                
                DECODE(il.customs_stat_no, NULL, il.service_way,    NULL),
                DECODE(il.customs_stat_no, NULL, il.service_payment_way,    NULL),
                il.protocol_no
                -- gelr:italy_intrastat, end
                ;
   
   -- gelr:italy_intrastat, Related attribute will be null and make no harm when Italy intrastat not enabled.
   CURSOR get_line_summary IS
      SELECT SUM((NVL(il.invoiced_unit_price, NVL(il.order_unit_price,0)) + 
                  NVL(il.unit_add_cost_amount_inv, NVL(il.unit_add_cost_amount,0)) +
                  NVL(il.unit_charge_amount_inv,0) + NVL(il.unit_charge_amount,0)) * 
                  il.quantity) * rep_curr_rate_ invoiced_value,
                  -- gelr:italy_intrastat, start
                  il.adjust_to_prev_intrastat,
                  DECODE(il.customs_stat_no, NULL, il.service_statistical_code, NULL) service_statistical_code
                  -- gelr:italy_intrastat, end
      FROM   intrastat_line_tab il, country_notc_tab cn
      WHERE  il.intrastat_id = intrastat_id_
      AND    il.intrastat_direction = intrastat_direction_
      AND    il.rowstate = 'Released'        
      AND    il.notc = cn.notc      
      AND    cn.country_code = country_code_
      GROUP BY  DECODE(il.customs_stat_no, NULL, NULL, il.opposite_country),
                DECODE(il.customs_stat_no, NULL, NULL, il.mode_of_transport),
                DECODE(il.customs_stat_no, NULL, NULL, il.delivery_terms),
                DECODE(intrastat_direction_, 'IMPORT', DECODE(il.customs_stat_no, NULL, NULL, il.country_of_origin), NULL),
                il.opponent_number,
                il.contract,
                il.opponent_type,
                il.opponent_tax_id,
                DECODE(il.customs_stat_no, NULL, NULL, SUBSTR(il.county, 1, 2)),
                DECODE(il.customs_stat_no, NULL, NULL,
                DECODE(il.triangulation, 'TRIANGULATION', 
                       DECODE(cn.country_notc,'1','A',
                                              '2','B',
                                              '3','C',
                                              '4','D',
                                              '5','E',
                                              '6','F',
                                              '7','G',
                                              '8','H',
                                              '9','I', cn.country_notc), cn.country_notc)),
                il.customs_stat_no,
                -- gelr:italy_intrastat, start
                il.adjust_to_prev_intrastat,               
                DECODE(italy_intrastat_, 'FALSE', DECODE(il.customs_stat_no, NULL, il.invoice_serie,  NULL), NULL),
                DECODE(italy_intrastat_, 'FALSE', DECODE(il.customs_stat_no, NULL, il.invoice_number, NULL), NULL),
                DECODE(il.customs_stat_no, NULL, il.invoice_date,   NULL),
                DECODE(il.customs_stat_no, NULL, il.service_statistical_code, NULL),
                DECODE(il.customs_stat_no, NULL, il.service_way,    NULL),
                DECODE(il.customs_stat_no, NULL, il.service_payment_way,    NULL),
                il.protocol_no;
                -- gelr:italy_intrastat, end


   CURSOR check_country_of_origin(italy_intrastat_ IN VARCHAR2) IS
      SELECT 1                  
      FROM   intrastat_line_tab
      WHERE  intrastat_id        = intrastat_id_
      AND    intrastat_direction = 'IMPORT'
      AND    rowstate            = 'Released'
      AND    country_of_origin IS NULL
      -- gelr:italy_intrastat, start
      AND    ((italy_intrastat_ = 'FALSE') OR 
              (italy_intrastat_ = 'TRUE' AND service_statistical_code IS NULL));
      -- gelr:italy_intrastat, end

   
   FUNCTION Decode_Val ( expression_    VARCHAR2,
                         search_        VARCHAR2,
                         result_        VARCHAR2,
                         default_       VARCHAR2) RETURN VARCHAR2
   IS
   BEGIN
      IF (expression_ = search_) THEN
         RETURN result_;
      ELSE
         RETURN default_;
      END IF;
   END Decode_Val;

BEGIN
  
   IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOTBOTH: You can only create an import or export file at the time, not both at the same time.');   
   ELSIF (intrastat_export_ = 'EXPORT' AND intrastat_import_ IS NULL) THEN
      intrastat_direction_ := intrastat_export_;
   ELSIF (intrastat_export_ IS NULL AND intrastat_import_ = 'IMPORT') THEN
      intrastat_direction_ := intrastat_import_;
   ELSE -- both is null
      Error_SYS.Record_General(lu_name_, 'DIRECTIONSNULL: One transfer option must be checked.');        
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
   
   -- check that no opponent_number is NULL
   OPEN check_opponent_number;
   FETCH check_opponent_number INTO no_of_rows_;
   IF (no_of_rows_ > 0) THEN
      Error_SYS.Record_General(lu_name_, 'OPPONENTNONULL: This transaction have 1 or more rows with an empty Opponent Number, they must have a valid Opponent Number.');      
   END IF;   
   CLOSE check_opponent_number;

   -- check that no opponent_type is NULL
   no_of_rows_ := 0;
   OPEN check_opponent_type;
   FETCH check_opponent_type INTO no_of_rows_;
   IF (no_of_rows_ > 0) THEN
      Error_SYS.Record_General(lu_name_, 'NOOPPONENTTYPE: Opponent type is missing for one or more lines.');      
   END IF;   
   CLOSE check_opponent_type;
   
   -- gelr:italy_intrastat, start
   IF(Company_Localization_Info_API.Get_Parameter_Value_Db(Intrastat_API.Get_Company(intrastat_id_), 'ITALY_INTRASTAT') = Fnd_Boolean_API.DB_TRUE) THEN
      italy_intrastat_enabled_ := TRUE;
      italy_intrastat_         :=  Fnd_Boolean_API.DB_TRUE; -- Use only for cursor changes since sql doesn't support boolean.
   END IF;
   -- gelr:italy_intrastat, end
   
   -- Check for country_of_origin when intrastat_direction_ = 'IMPORT' .
   IF (intrastat_direction_ = 'IMPORT') THEN
      OPEN check_country_of_origin(italy_intrastat_);
      FETCH check_country_of_origin INTO country_of_origin_dummy_;
      IF (check_country_of_origin%FOUND) THEN
         CLOSE check_country_of_origin;
         Error_SYS.Record_General(lu_name_, 'NOCOUNTRYOFORIGIN: Country of Origin is mandatory for import lines. Values are missing for some import lines.'); 
      END IF;
      CLOSE check_country_of_origin;
   END IF;

   no_of_rows_ := 0;
   
   -- Head blocks
   FOR headrec_ IN get_head LOOP     
   
      -- check currency
      IF (headrec_.rep_curr_code != ('EUR')) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCURRITF: Currency Code :P1 is not a valid currency, only EUR is acceptable.', headrec_.rep_curr_code); 
      END IF;
      rep_curr_rate_ := headrec_.rep_curr_rate;
      country_code_  := headrec_.country_code;

      -- Try to create header lines.
      $IF (Component_Invoic_SYS.INSTALLED) $THEN
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, headrec_.country_code, TRUNC(headrec_.creation_date)); 
      $END
      
      IF (intrastat_direction_ = 'IMPORT') THEN
         IF (headrec_.file_print_import != 'IMPORT FILE PRINTED') THEN
            IF(italy_intrastat_enabled_) THEN
               -- gelr:italy_intrastat, start
               Company_Invent_Info_API.Create_Next_Intrastat_File_No(progress_no_, headrec_.company);
               -- gelr:italy_intrastat, end
            ELSE
               SELECT it_progress_no.NEXTVAL
                  INTO progress_no_
                  FROM dual;
            END IF;
         ELSE
            progress_no_ := headrec_.import_progress_no;
         END IF;
         import_progress_no_ := progress_no_;
      ELSIF (intrastat_direction_ = 'EXPORT') THEN
         IF (headrec_.file_print_export != 'EXPORT FILE PRINTED') THEN
            IF(italy_intrastat_enabled_) THEN
               -- gelr:italy_intrastat, start
               Company_Invent_Info_API.Create_Next_Intrastat_File_No(progress_no_, headrec_.company);
               -- gelr:italy_intrastat, end
            ELSE
               SELECT it_progress_no.NEXTVAL
                  INTO progress_no_
                  FROM dual;
            END IF;
         ELSE
            progress_no_ := headrec_.export_progress_no;
         END IF;
         export_progress_no_ := progress_no_;
      END IF;
      -- gelr:italy_intrastat, start
      IF (italy_intrastat_enabled_) THEN
         import_progress_no_ := progress_no_;
         export_progress_no_ := progress_no_;
      END IF;
      -- gelr:italy_intrastat, end
      Intrastat_File_Util_API.Get_Progress_Nos(import_progress_no_, export_progress_no_, intrastat_id_);

      -- Rounded line_summary_rec_.invoiced_value before summing up. 
      FOR line_summary_rec_ IN get_line_summary LOOP
         -- gelr:italy_intrastat, Made use of old line calculation as same as when Italy Intrastat not enabled for avaoid additional validations.
         IF (italy_intrastat_enabled_) THEN
            -- gelr:italy_intrastat, start
            IF (line_summary_rec_.adjust_to_prev_intrastat = 'FALSE') THEN
               IF ( line_summary_rec_.service_statistical_code IS NOT NULL ) THEN
                  no_of_service_lines_    := no_of_service_lines_ + 1;
                  total_service_invoiced_ := total_service_invoiced_ + ROUND(line_summary_rec_.invoiced_value);
               ELSE
                  no_of_lines_    := no_of_lines_ + 1;
                  total_invoiced_ := total_invoiced_ + ROUND(line_summary_rec_.invoiced_value);
               END IF;
            ELSE
               IF ( line_summary_rec_.service_statistical_code IS NOT NULL ) THEN
                  no_of_adjusted_service_lines_    := no_of_adjusted_service_lines_ + 1;
                  total_adjusted_service_invoiced_ := total_adjusted_service_invoiced_ + ROUND(line_summary_rec_.invoiced_value);
               ELSE
                  no_of_adjusted_lines_    := no_of_adjusted_lines_ + 1;
                  total_adjusted_invoiced_ := total_adjusted_invoiced_ + ROUND(line_summary_rec_.invoiced_value);
               END IF;
            END IF;
            -- gelr:italy_intrastat, end
         ELSE
            no_of_lines_ := no_of_lines_ + 1;
            total_invoiced_ := total_invoiced_ + ROUND(line_summary_rec_.invoiced_value);
         END IF;
      END LOOP;

      line_ := LPAD(SUBSTR(NVL(vat_no_,'           ') ,1, 11), 11, 0) ||
               LPAD(SUBSTR(NVL(progress_no_, '000000'), 1, 6), 6, 0)||
               '0'||
               '00000'||
               Decode_Val(intrastat_direction_,'EXPORT', 'C', 'A') || 
               TO_CHAR(headrec_.begin_date,'YY')||
               'M'||
               TO_CHAR(headrec_.begin_date,'MM')||
               LPAD(SUBSTR(NVL(vat_no_,'           ') ,1, 11), 11, 0) ||
               '0'||
               '0'||
               LPAD(SUBSTR(NVL(headrec_.repr_tax_no, '00000000000'), 1, 11) ,11 ,0)||
               LPAD(no_of_lines_, 5, 0)||
               LPAD(total_invoiced_, 13, 0);
               
      IF (italy_intrastat_enabled_) THEN
         -- gelr:italy_intrastat, start
         line_ := 'EUROX'|| line_ ||
                  LPAD(no_of_adjusted_lines_, 5, 0)||
                  LPAD(Get_Invoice_Value___(total_adjusted_invoiced_), 13, 0)||
                  LPAD(no_of_service_lines_, 5, 0)||
                  LPAD(total_service_invoiced_, 13, 0)||
                  LPAD(no_of_adjusted_service_lines_, 5, 0)||
                  LPAD(total_adjusted_service_invoiced_, 13, 0);
         -- gelr:italy_intrastat, end
      ELSE
         line_ := 'EUROA' || line_ ||
                  '00000'||
                  '000000000000'||
                  'p';
      END IF;
      output_clob_ := line_ ||
                      CHR(13) || CHR(10);

      FOR linerec_ IN get_lines LOOP
         -- gelr:italy_intrastat, Made use of old line calculation as same as when Italy Intrastat not enabled for avaoid additional validations.
         IF (italy_intrastat_enabled_) THEN
            -- gelr:italy_intrastat, start
            IF(linerec_.service_statistical_code IS NOT NULL) THEN
               service_line_progress_no_ := service_line_progress_no_ + 1;
            ELSE
               line_progress_no_ := line_progress_no_ + 1;
            END IF;
            -- gelr:italy_intrastat, end
         ELSE
            line_progress_no_ := line_progress_no_ + 1;
         END IF;

         IF (linerec_.opponent_type = 'SUPPLIER') THEN
            document_address_ := Supplier_Info_Address_API.Get_Default_Address(linerec_.opponent_number, Address_Type_Code_API.Decode('INVOICE'));
            doc_country_code_ := Supplier_Info_Address_API.Get_Country_Code(linerec_.opponent_number, document_address_);
            -- Retrieve VAT Number and currency from supplier.
            $IF (Component_Invoic_SYS.INSTALLED) $THEN               
               supp_currency_ := Identity_Invoice_Info_API.Get_Def_Currency (headrec_.company, 
                                                                             linerec_.opponent_number,
                                                                             Party_Type_API.Decode('SUPPLIER'));

               -- Convert invoiced_value_ to supplier currency
               Currency_Rate_API.Get_Currency_Rate_Defaults(currency_type_, 
                                                            conv_factor_,
                                                            currency_rate_,
                                                            headrec_.company,
                                                            supp_currency_,
                                                            headrec_.end_date);
               
               -- gelr:italy_intrastat, Made use of old line calculation as same as when Italy Intrastat not enabled for avaoid additional validations.
               IF (italy_intrastat_enabled_) THEN
                  -- gelr:italy_intrastat, start
                  invoice_value_curr_ := linerec_.opposite_country_curr_amt;
                  -- gelr:italy_intrastat, end
               ELSE
                  IF (supp_currency_ = 'EUR') THEN
                     invoice_value_curr_ := 0;    
                  ELSE
                     invoice_value_curr_ := linerec_.invoiced_value * conv_factor_ / currency_rate_; 
                  END IF;
               END IF;
            $END
            
         ELSIF (linerec_.opponent_type = 'CUSTOMER') THEN
            document_address_ := Customer_Info_Address_API.Get_Default_Address(linerec_.opponent_number, Address_Type_Code_API.Decode('INVOICE'));
            doc_country_code_ := Customer_Info_Address_API.Get_Country_Code(linerec_.opponent_number, document_address_);
            delivery_country_code_ := Customer_Info_Address_API.Get_Delivery_Country_Db(linerec_.opponent_number);            
          -- If Opponent_type is COMPANY, it fetches the document address country code of company.
         ELSE
            document_address_ := Company_Address_API.Get_Default_Address(linerec_.opponent_number, Address_Type_Code_API.Decode('INVOICE'));
            doc_country_code_ := Company_Address_API.Get_Country_Db(linerec_.opponent_number, document_address_);            
         END IF;

         Iso_Country_API.Exist_Db(doc_country_code_);

		   IF ( linerec_.delivery_terms IN ('EXW','FCA','FAS','FOB','CFR','CIF','CPT','CIP','DAF','DES','DEQ','DDU','DDP', 'DAT', 'DAP')) THEN
			   delivery_terms_		:= linerec_.delivery_terms;
         ELSE
		      delivery_terms_		:= 'XXX';
         END IF;

         IF (italy_intrastat_enabled_) THEN
            doc_country_code_ := NULL;
            substr_no_ := 14;
         ELSE
            substr_no_ := 12;
         END IF;         
         
         -- Create Record Line
         IF(italy_intrastat_enabled_) AND (linerec_.service_statistical_code IS NOT NULL) THEN
            -- gelr:italy_intrastat, start
            invoice_doc_country_code_ := Company_Address_API.Get_Country_Db(headrec_.company, 
                                                                            Company_Address_API.Get_Default_Address (headrec_.company,
                                                                                                                     Address_Type_Code_API.Decode('INVOICE'),
                                                                                                                     sysdate));
            
            
            line_ := 'EUROX' ||
                     LPAD(SUBSTR(NVL(vat_no_,'           ') ,1, 11), 11, 0) ||
                     LPAD(SUBSTR(NVL(progress_no_, '000000'), 1, 6), 6, 0)||
                     '3'||
                     LPAD(service_line_progress_no_, 5, 0)||
                     doc_country_code_ ||
                     RPAD(SUBSTR(NVL(linerec_.opponent_tax_id, '            '),1, substr_no_), substr_no_, ' ') ||
                     LPAD(SUBSTR(ROUND(linerec_.invoiced_value), 1, 13), 13, 0);
                     
            IF (intrastat_direction_ = 'IMPORT') THEN
               line_ := line_ || LPAD(SUBSTR(ROUND(ABS(invoice_value_curr_)), 1, 13), 13, 0);
            END IF;
            
            line_ := line_ || 
                     RPAD(SUBSTR(CONCAT(linerec_.invoice_serie, linerec_.invoice_number), 1, 15), 15, ' ') ||
                     TO_CHAR(linerec_.invoice_date, 'DDMMYY') ||
                     LPAD(SUBSTR(linerec_.service_statistical_code, 1, 6), 6, 0) ||
                     linerec_.service_way ||
                     linerec_.service_payment_way||
                     invoice_doc_country_code_||
                     CHR(13) || CHR(10);
            -- gelr:italy_intrastat, end
         ELSE
            IF (intrastat_direction_ = 'EXPORT') THEN
               line_ := 'EUROX' ||
                        LPAD(SUBSTR(NVL(vat_no_,'           ') ,1, 11), 11, 0) ||
                        LPAD(progress_no_, 6, 0)||
                        '1'||
                        LPAD(line_progress_no_, 5, 0)||
                        Decode_Val(doc_country_code_, 'GR','EL', doc_country_code_)||                        
                        RPAD(SUBSTR(NVL(linerec_.opponent_tax_id, '            '),1, substr_no_), substr_no_, ' ') ||
                        LPAD(SUBSTR(ROUND(linerec_.invoiced_value), 1, 13), 13, 0) ||
                        SUBSTR(linerec_.decoded_country_notc, 1, 1) ||
                        LPAD(SUBSTR(NVL(linerec_.customs_stat_no, '        '), 1, 8), 8, 0) ||
                        LPAD(SUBSTR(ROUND(linerec_.net_weight_sum), 1, 10), 10, 0) ||
                        LPAD(SUBSTR(linerec_.intrastat_alt_qty_sum, 1, 10), 10, 0) ||
                        LPAD(SUBSTR(ROUND(linerec_.invoiced_value), 1, 13), 13, 0) ||
                        SUBSTR(delivery_terms_, 1, 1) ||
                        SUBSTR(linerec_.mode_of_transport, 1, 1) ||
                        SUBSTR(Decode_Val(linerec_.opposite_country, 'GR', 'EL', linerec_.opposite_country), 1, 2) ||
                        linerec_.county ||
                        CHR(13) || CHR(10);
            ELSIF (intrastat_direction_ = 'IMPORT') THEN
               line_ := 'EUROX' ||
                        LPAD(SUBSTR(NVL(vat_no_,'           ') ,1, 11), 11, 0) ||
                        LPAD(progress_no_, 6, 0)||
                        '1'||
                        LPAD(line_progress_no_, 5, 0)||
                        Decode_Val(doc_country_code_, 'GR','EL', doc_country_code_)||
                        RPAD(SUBSTR(NVL(linerec_.opponent_tax_id, '            '),1, substr_no_), substr_no_, ' ') ||
                        LPAD(SUBSTR(ROUND(linerec_.invoiced_value), 1, 13), 13, 0) ||
                        LPAD(SUBSTR(ROUND(invoice_value_curr_), 1, 13), 13, 0) ||
                        SUBSTR(linerec_.decoded_country_notc, 1, 1) ||
                        LPAD(SUBSTR(NVL(linerec_.customs_stat_no, '        '), 1, 8), 8, 0) ||
                        LPAD(SUBSTR(ROUND(linerec_.net_weight_sum), 1, 10), 10, 0) ||
                        LPAD(SUBSTR(linerec_.intrastat_alt_qty_sum, 1, 10), 10, 0) ||
                        LPAD(SUBSTR(ROUND(linerec_.invoiced_value), 1, 13), 13, 0) ||
                        SUBSTR(delivery_terms_, 1, 1) ||
                        SUBSTR(linerec_.mode_of_transport, 1, 1) ||
                        SUBSTR(Decode_Val(linerec_.opposite_country, 'GR', 'EL', linerec_.opposite_country), 1, 2) ||
                        SUBSTR(NVL(Decode_Val(linerec_.country_of_origin, 'GR', 'EL', linerec_.country_of_origin), '  '), 1, 2) ||
                        linerec_.county||
                        CHR(13) || CHR(10);   
            END IF;
         END IF;
         output_clob_ := output_clob_ || line_;  
         no_of_rows_  := no_of_rows_ + 1;
      END LOOP;
      IF (no_of_rows_ = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NORECORDS: Files with no items are not allowed to be created.');       
      END IF;      
   END LOOP;
END Create_Output;



