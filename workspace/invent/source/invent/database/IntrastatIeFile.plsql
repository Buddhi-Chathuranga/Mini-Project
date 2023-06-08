-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatIeFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150914  PrYaLK  Bug 124377, Modified Create_Output() by adding delivery term DAP.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130730  AwWelk  TIBE-849, Removed global variables and introduced conditional compilation.
--  120410  AyAmlk  Bug 100608, Increased the length of delivery_terms_ in Create_Output().
--  110309  Bmekse  DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                  inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203  Elarse  Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise  Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  100107  Umdolk Refactoring in Communication Methods in Enterprise.
--  090601  SaWjlk  Bug 83173, Removed the prog text duplications.
--  060814  Asawlk  Bug 59578, Replaced delivery term 'FXW' with 'EXW'.
--  060123  NiDalk  Added Assert safe annotation. 
--  040301  GeKalk  Replaced substrb with substr for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  040203  NaWalk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.  
--  040202  NaWalk  Removed the fourth variable of DBMS_SQL inside the for loop,for Unicode modification.
--  010411  DaJoLK  Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and 
--                  TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  010226  GEKALK  Created.
--  010305  GEKALK  Changed the NOTC check to consider the intrastat_direction..
--  010305  GEKALK  Remove the previous correction.
--  010313  GEKALK  Added a new where condition to select lines where rowstate is not equal to Cancelled
--                  from Intrastat_Line_Tab.
--  010316  GEKALK  Changed the selection of Country_of_origin
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
--   specifications for Ireland.
PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2,
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2 )
IS
   header_rec_type_             VARCHAR2(3) := 'SHR';
   file_status_                 VARCHAR2(3) := 'SFO';
   file_format_                 VARCHAR2(1) := 'F';
   return_status_               VARCHAR2(1) := 'N';
   dec_period_                  VARCHAR2(4);
   type_of_return_              VARCHAR2(1);
   trader_vat_no_               VARCHAR2(8);
   declarant_vat_no_            VARCHAR2(8);
   creation_date_               VARCHAR2(6);
   filler_head_                 VARCHAR2(45) := lpad(' ',45);

   detail_rec_type_             VARCHAR2(3) := 'SDR';
   item_no_                     VARCHAR2(3);
   commodity_                   VARCHAR2(8);
   country_of_origin_           VARCHAR2(3);
   country_of_destination_      VARCHAR2(3);
   mode_of_transport_           VARCHAR2(2);
   notc_                        VARCHAR2(2);
   delivery_terms_              VARCHAR2(5);
   invoice_value_               VARCHAR2(10);
   statistical_value_           VARCHAR2(10);
   net_mass_                    VARCHAR2(10);
   sup_units_                   VARCHAR2(10);
   stat_line_no_                VARCHAR2(12);
   filler_detail_               VARCHAR2(1) := lpad(' ',1);

   triler_rec_type_             VARCHAR2(3) := 'STR';
   tot_reported_items_          VARCHAR2(3);
   tot_invoice_value_           VARCHAR2(12);
   tot_statistical_value_       VARCHAR2(12);
   tot_net_mass_                VARCHAR2(12);
   tot_sup_unit_                VARCHAR2(12);
   phone_number_                VARCHAR2(11);
   filler_trail_                VARCHAR2(15) := lpad(' ',15);

   line_                        VARCHAR2(2000);
   line_counter_                NUMBER := 0;
   vat_no_                      VARCHAR2(50);
   rep_curr_code_               VARCHAR2(3);
   rep_curr_rate_               NUMBER;
   country_code_                VARCHAR2(2); 
   intrastat_direction_         VARCHAR2(10);
   tot_invoice_value_num_       NUMBER:= 0;
   tot_statistical_value_num_   NUMBER:= 0;
   tot_net_mass_num_            NUMBER:= 0;
   tot_sup_unit_num_            NUMBER:= 0;
   end_date_                    DATE;
   start_date_                  DATE;
   company_contact_             VARCHAR2(20); 
   representative_              VARCHAR2(20); 
   notc_dummy_                  VARCHAR2(5);
      

   -- Get all the header details
   CURSOR get_head IS
      SELECT company,
             company_contact,
             representative,
             repr_tax_no,
             --begin_date,
             end_date,
             creation_date,
             rep_curr_code,
             rep_curr_rate,
             country_code
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;
   
   -- Get all the line details
   CURSOR get_lines IS
      SELECT i.intrastat_direction,
             i.customs_stat_no,
             i.opposite_country,
             DECODE(intrastat_direction_, 'IMPORT', i.country_of_origin, '') country_of_origin,
             i.mode_of_transport,
             cn.country_notc,
             SUM(i.quantity * nvl(i.invoiced_unit_price, i.order_unit_price)) * rep_curr_rate_  invoice_value,
			    i.delivery_terms,
             SUM((nvl(i.invoiced_unit_price,nvl(i.order_unit_price,0)) + 
                  nvl(i.unit_add_cost_amount_inv,nvl(i.unit_add_cost_amount,0)) +
                  nvl(i.unit_charge_amount_inv,0) +
                  nvl(i.unit_charge_amount,0)) * i.quantity) * rep_curr_rate_ statistical_value,
             SUM(i.quantity * i.net_unit_weight) mass,
             SUM(nvl(i.intrastat_alt_qty,0)) sup_units
      FROM   intrastat_line_tab i ,country_notc_tab cn
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    rowstate           != 'Cancelled'
      AND    i.notc = cn.notc      
      AND    cn.country_code = country_code_
      GROUP BY  i.intrastat_direction,
                i.customs_stat_no,
                i.opposite_country,
                DECODE(intrastat_direction_, 'IMPORT', i.country_of_origin, ''),
                i.mode_of_transport,
                i.delivery_terms,
                cn.country_notc; 
                
   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'IE';   
                              
     
BEGIN

   
   IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
       Error_SYS.Record_General(lu_name_, 'NOTBOTH: You can only create an import or export file at the time, not both at the same time');   
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
         
      --Get the Company Vat Code     
      $IF (Component_Invoic_SYS.INSTALLED)$THEN 
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, headrec_.country_code, TRUNC(headrec_.creation_date));
      $END 

      IF (SUBSTR(vat_no_, 1, 2) = headrec_.country_code) THEN
         trader_vat_no_ := NVL(RPAD(SUBSTR(vat_no_,3,8),8),LPAD(' ',8));
      ELSE
         trader_vat_no_ := NVL(RPAD(SUBSTR(vat_no_,1,8),8),LPAD(' ',8));
      END IF;
         
      IF (headrec_.representative IS NULL) THEN
         --declarant_vat_no_ := NVL(rpad(SUBSTR(vat_no_, 3, 8),8),LPAD(' ',8));
         declarant_vat_no_   := trader_vat_no_;
      ELSIF (SUBSTR(headrec_.repr_tax_no, 1, 2) = headrec_.country_code) THEN
         declarant_vat_no_ := NVL(RPAD(SUBSTR(headrec_.repr_tax_no, 3, 8),8,' '),LPAD(' ',8));
      ELSE
         declarant_vat_no_ := NVL(RPAD(SUBSTR(headrec_.repr_tax_no, 1, 8),8,' '),LPAD(' ',8));
      END IF;
      
      dec_period_          := TO_CHAR(headrec_.end_date, 'YYMM');
      
      IF (intrastat_direction_ = 'IMPORT') THEN
         type_of_return_   := 'A';
      ELSE
         type_of_return_   := 'D';
      END IF;
      
      IF ( headrec_.rep_curr_code NOT IN ('IEP','EUR')) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCURRIEF: Currency Code :P1 is not a valid currency, only IEP and EUR is acceptable', headrec_.rep_curr_code); 
      END IF;

      creation_date_        := to_char(headrec_.creation_date, 'DDMMYY');
      rep_curr_rate_        := headrec_.rep_curr_rate;
      rep_curr_code_        := headrec_.rep_curr_code;
      end_date_             := headrec_.end_date;
      company_contact_      := headrec_.company_contact;
      representative_       := headrec_.representative;
      start_date_           := headrec_.creation_date;
      country_code_         := headrec_.country_code;
     
   END LOOP;
   
   line_ := header_rec_type_||
            file_status_||
            file_format_||
            return_status_||
            dec_period_||
            type_of_return_||
            trader_vat_no_||
            declarant_vat_no_||
            creation_date_||
            filler_head_||
            CHR(13) || CHR(10);

   output_clob_ := line_;
   
          
   FOR linerec_ IN get_lines LOOP
      line_counter_             := line_counter_ + 1;            
      item_no_                  := lpad(line_counter_,3,'0');
      commodity_                := NVL(RPAD(SUBSTR(linerec_.customs_stat_no,1,8),8),LPAD(' ',8));
      country_of_destination_   := RPAD(SUBSTR(linerec_.opposite_country,1,3),3);
      country_of_origin_        := NVL(RPAD(SUBSTR(linerec_.country_of_origin,1,3),3),LPAD(' ',3));
      notc_                     := RPAD(linerec_.country_notc,2);
      mode_of_transport_        := NVL(RPAD(linerec_.mode_of_transport,2),'  ');
      invoice_value_            := LPAD(ROUND(linerec_.invoice_value), 10, '0');
      
      IF ( linerec_.delivery_terms IN ('EXW','FCA','FAS','FOB','CFR','CIF','CPT','CIP','DAF','DES','DEQ','DDU','DDP','DAP')) THEN
         delivery_terms_		:= linerec_.delivery_terms;
      ELSE
         delivery_terms_		:= 'XXX';
      END IF;
      
      statistical_value_         := LPAD(ROUND(linerec_.statistical_value), 10, '0');
      net_mass_                  := LPAD(ROUND(linerec_.mass), 10, '0');
      sup_units_                 := LPAD(NVL(ROUND(linerec_.sup_units),0),10,'0');
      stat_line_no_              := TO_CHAR(start_date_, 'YYYYMMDD')||0||item_no_;

      tot_invoice_value_num_     := tot_invoice_value_num_ + round(linerec_.invoice_value);
      tot_statistical_value_num_ := tot_statistical_value_num_ + round(linerec_.statistical_value);
      tot_net_mass_num_          := tot_net_mass_num_ + round(linerec_.mass);
      tot_sup_unit_num_          := tot_sup_unit_num_ + round(linerec_.sup_units);

      line_ := detail_rec_type_||
               item_no_||
               commodity_||
               country_of_destination_||
               country_of_origin_ ||
               mode_of_transport_ ||
               notc_||
               invoice_value_||
               delivery_terms_||
               statistical_value_||
               net_mass_||
               sup_units_||
               stat_line_no_||
               filler_detail_||
               CHR(13) || CHR(10);

      output_clob_ := output_clob_ || line_;         
          
   END LOOP;
         
   tot_reported_items_      := RPAD(item_no_,3);
   tot_invoice_value_       := LPAD(tot_invoice_value_num_, 12, '0');
   tot_statistical_value_   := LPAD(tot_statistical_value_num_, 12, '0');
   tot_net_mass_            := LPAD(tot_net_mass_num_, 12, '0');
   tot_sup_unit_            := LPAD(tot_sup_unit_num_, 12, '0');
   
   IF (representative_ IS NOT NULL) THEN
      phone_number_      := Comm_Method_API.Get_Default_Value('PERSON', representative_, 'PHONE', NULL, start_date_);       
   END IF;

   IF (phone_number_ IS NULL) THEN
      phone_number_      := Comm_Method_API.Get_Default_Value('PERSON', company_contact_, 'PHONE', NULL, start_date_);       
   END IF;

   phone_number_         := NVL(RPAD(phone_number_,11),LPAD(' ',11));

   
   line_ := triler_rec_type_||
            tot_reported_items_||
            tot_invoice_value_||
            tot_statistical_value_||
            tot_net_mass_||
            tot_sup_unit_||
            phone_number_||
            filler_trail_||
            CHR(13) || CHR(10);
         
   output_clob_ := output_clob_ || line_;         
      
   info_ := Client_SYS.Get_All_Info;

END Create_Output;



