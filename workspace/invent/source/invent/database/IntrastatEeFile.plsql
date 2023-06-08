-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatEeFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130731  UdGnlk  TIBE-844, Removed the dynamic code and modify to conditional compilation.
--  120410  AyAmlk  Bug 100608, Increased the length of delivery_terms_ in Create_Output().
--  110323  PraWlk  Bug 95757, Modified Create_Output() by adding delivery terms DAT and DAP. 
--  110309  Bmekse  DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                  inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203  Elarse  Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise  Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead.
--  090930  ChFolk  Removed unused variables in the package.
----------------------------------- 14.0.0 ----------------------------------
--  090529  SaWjlk  Bug 83173, Removed the prog text duplications.
----------------------------------13.4.0-------------------------------------
--  060227  GeKalk Replaced substrb with substr for UNICODE modifications.
--  060123  NiDalk Rewrote the DBMS_SQL to Native dynamic SQL and added Assert safe annotation. 
--  050919  NiDalk Removed unused variables.
--  040908  CaRase Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

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
   creation_date_           VARCHAR2(15);
   dec_period_year_         VARCHAR2(4);
   dec_period_month_        VARCHAR2(2);
   type_of_return_          VARCHAR2(1);
   total_items_             NUMBER;
   trader_vat_no_           VARCHAR2(8);
   delivery_terms_          VARCHAR2(5);
   mode_of_transport_       VARCHAR2(2);
   country_of_destination_  VARCHAR2(3);
   notc_                    VARCHAR2(2);
   country_of_origin_       VARCHAR2(2);
   commodity_               VARCHAR2(8);
   net_mass_                VARCHAR2(18);
   sup_units_               VARCHAR2(18);
   invoice_value_           VARCHAR2(18);
   statistical_value_       VARCHAR2(18);
   unit_meas_               VARCHAR2(3);
   eighteendottwo_          VARCHAR2(21) := rpad(' ',21);
   three_                   VARCHAR2(3) := rpad(' ',3);
   twohundredfiftyfive_     VARCHAR2(255) := rpad(' ',255);
   item_no_                 VARCHAR2(3);
   line_                    VARCHAR2(2000);
   line_counter_             NUMBER := 0;
   vat_no_                   VARCHAR2(50);
   rep_curr_code_            VARCHAR2(3);
   rep_curr_rate_            NUMBER;
   cid_                      NUMBER;   
   country_code_             VARCHAR2(2); 
   intrastat_direction_      VARCHAR2(10);
   notc_dummy_              VARCHAR2(5);
   declarant_vat_no_        VARCHAR2(8);
   company_contact_name_    VARCHAR2(255); 
      
   kp_                      VARCHAR2(10) := 'kp';
   aasta_                   VARCHAR2(10) := 'aasta';
   kuu_                     VARCHAR2(10) := 'kuu';
   voog_                    VARCHAR2(10) := 'voog';
   ev_rn_                   VARCHAR2(10) := 'ev_rn';
   kirje_                   VARCHAR2(10) := 'kirje';
   tarne_                   VARCHAR2(10) := 'tarne';
   koht_                    VARCHAR2(10) := 'koht';
   transa_                  VARCHAR2(10) := 'transa';
   liige_                   VARCHAR2(10) := 'liige';
   tehing_                  VARCHAR2(10) := 'tehing';
   riik_                    VARCHAR2(10) := 'riik';
   cn_                      VARCHAR2(10) := 'cn';
   neto_                    VARCHAR2(10) := 'neto';
   kogus_                   VARCHAR2(10) := 'kogus';
   myh_                     VARCHAR2(10) := 'myh';
   kaups_                   VARCHAR2(10) := 'kaups';
   kaupv_                   VARCHAR2(10) := 'kaupv';
   stats_                   VARCHAR2(10) := 'stats';
   statv_                   VARCHAR2(10) := 'statv';
   ht1s_                    VARCHAR2(10) := 'ht1s';
   ht1v_                    VARCHAR2(10) := 'ht1v';
   ht2s_                    VARCHAR2(10) := 'ht2s';
   ht2v_                    VARCHAR2(10) := 'ht2v';
   ht3s_                    VARCHAR2(10) := 'ht3s';
   ht3v_                    VARCHAR2(10) := 'ht3v';
   ht4s_                    VARCHAR2(10) := 'ht4s';
   ht4v_                    VARCHAR2(10) := 'ht4v';
   ht5s_                    VARCHAR2(10) := 'ht5s';
   ht5v_                    VARCHAR2(10) := 'ht5v';
   kaup_                    VARCHAR2(10) := 'kaup';
   lisakood_                VARCHAR2(10) := 'lisakood';
   m2rkus_                  VARCHAR2(10) := 'm2rkus';
   t2itja_                  VARCHAR2(10) := 't2itja';
   de_nr_                   VARCHAR2(10) := 'de_nr';
   yxus_                    VARCHAR2(10) := 'yxus';



   -- Get all the header details
   CURSOR get_head IS
      SELECT company,
             company_contact,
             representative,
             repr_tax_no,
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
             i.opposite_country,
             i.country_of_origin,
             cn.country_notc,
             i.mode_of_transport,
             i.customs_stat_no,
			    i.delivery_terms,
             SUM(i.quantity * nvl(i.invoiced_unit_price, i.order_unit_price)) * rep_curr_rate_  invoice_value,
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
				   i.opposite_country,
               i.country_of_origin,
               cn.country_notc,
               i.mode_of_transport,
               i.customs_stat_no,
               i.delivery_terms;
                
   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'EE'; 


   CURSOR get_number_of_parts IS
      SELECT count(DISTINCT part_no)
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction = intrastat_direction_;
                              
     
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
      $IF (Component_Invoic_SYS.INSTALLED) $THEN
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, headrec_.country_code, TRUNC(headrec_.creation_date));
      $END    
      
      IF (substr(vat_no_, 1, 2) = headrec_.country_code) THEN
         trader_vat_no_ := NVL(rpad(substr(vat_no_,3,8),8),LPAD(' ',8));
      ELSE
         trader_vat_no_ := NVL(rpad(substr(vat_no_,1,8),8),LPAD(' ',8));
      END IF;


      declarant_vat_no_ := NVL(rpad(substr(headrec_.repr_tax_no, 1, 8),8,' '),LPAD(' ',8));
               
      dec_period_year_          := to_char(headrec_.end_date, 'YYYY');
      dec_period_month_         := to_char(headrec_.end_date, 'MM');
      
      IF (intrastat_direction_ = 'IMPORT') THEN
         type_of_return_   := 'S';
      ELSE
         type_of_return_    := 'L';
	   END IF;

      IF ( headrec_.rep_curr_code NOT IN ('EEK','EUR')) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCURREEF: Currency Code :P1 is not a valid currency, only EEP and EUR is acceptable', headrec_.rep_curr_code); 
      END IF;


      OPEN get_number_of_parts;
      FETCH get_number_of_parts INTO total_items_;
      CLOSE get_number_of_parts;

	  creation_date_		   := to_char(headrec_.creation_date, 'YYYYMMDD');
	  rep_curr_rate_        := headrec_.rep_curr_rate;
     rep_curr_code_        := headrec_.rep_curr_code;
     country_code_         := headrec_.country_code;
     company_contact_name_ := substr(Person_Info_API.Get_Name(headrec_.company_contact), 1, 255);   
     
   END LOOP;
 
   line_ := kp_||';'||
            aasta_||';'||
            kuu_||';'||
            voog_||';'||
            ev_rn_||';'||
            kirje_||';'||
            tarne_||';'||
            koht_||';'||
            transa_||';'||
            liige_||';'||
            tehing_||';'||
            riik_||';'||
            cn_||';'||
            neto_||';'||
            kogus_||';'||
            myh_||';'||
            kaups_||';'||
            kaupv_||';'||
            stats_||';'||
            statv_||';'||
            ht1s_||';'||
            ht1v_||';'||
            ht2s_||';'||
            ht2v_||';'||
            ht3s_||';'||
            ht3v_||';'||
            ht4s_||';'||
            ht4v_||';'||
            ht5s_||';'||
            ht5v_||';'||
            kaup_||';'||
            lisakood_||';'||
            m2rkus_||';'||
            t2itja_||';'||
            de_nr_||';'||
            yxus_||';'||
			   CHR(13) || CHR(10);

   output_clob_ := line_;
          
   FOR linerec_ IN get_lines LOOP
         
       line_counter_           := line_counter_ + 1;            
	    item_no_                := lpad(line_counter_,3,'0');
       commodity_              := nvl(rpad(substr(linerec_.customs_stat_no,1,8),8),LPAD(' ',8));
       country_of_destination_ := rpad(substr(linerec_.opposite_country,1,3),3);       
       country_of_origin_      := nvl(rpad(substr(linerec_.country_of_origin,1,2),2),LPAD(' ',2));  
       notc_                   := rpad(linerec_.country_notc,2);
		 mode_of_transport_      := nvl(rpad(linerec_.mode_of_transport,2),'  ');
       invoice_value_          := lpad(round(linerec_.invoice_value,2), 18, ' ');
       --This replace depends on that the tool which read the file only can handle decimal point.
       --The Centura session convert decimal point to dot.
       invoice_value_          := REPLACE(invoice_value_, '.',',');
		 
		 IF ( linerec_.delivery_terms IN ('EXW','FOB','FAS','FCA','CFR','CIF','CPT','CIP','DAF','DES','DEQ','DDU','DDP', 'DAT', 'DAP')) THEN
	       delivery_terms_		:= linerec_.delivery_terms;
       ELSE
		    delivery_terms_		:= 'XXX';
		 END IF;
       
       unit_meas_ := Customs_Statistics_Number_API.Get_Customs_Unit_Meas(linerec_.customs_stat_no);

       statistical_value_         := lpad(round(linerec_.statistical_value,2), 18, ' ');
       --This replace depends on that the tool which read the file only can handle decimal point.
       --The Centura session convert decimal point to dot.
       statistical_value_         := REPLACE(statistical_value_, '.',',');
       net_mass_                  := lpad(trunc(linerec_.mass,3), 18, ' ');
       sup_units_                 := lpad(nvl(trunc(linerec_.sup_units,3),0),18,' ');

		 line_ := creation_date_||';'||
                dec_period_year_||';'||
                dec_period_month_||';'||
                type_of_return_||';'||
                trader_vat_no_||';'||
                total_items_||';'||
                delivery_terms_||';'||
                twohundredfiftyfive_||';'||     --Geographical place, temporary empty                
                mode_of_transport_||';'||
                country_of_destination_||';'||
                notc_||';'||
                country_of_origin_ ||';'||
                commodity_||';'||
                net_mass_||';'||
				    sup_units_||';'||
                unit_meas_||';'||
                invoice_value_||';'||
                rep_curr_code_||';'||           --Currency of invoice value
                statistical_value_||';'||
                rep_curr_code_||';'||           --Currency of statistical value
                eighteendottwo_||';'||          --Price margin, per commodity
                three_||';'||                   --Price margin, three digit code
                eighteendottwo_||';'||          --Price margin, insurance cost per commodity
                three_||';'||                   --Price margin, currency of the insurance costs
                eighteendottwo_||';'||          --Price margin, other costs per commodity
                three_||';'||                   --Price margin, currency of other costs
                eighteendottwo_||';'||          --Price margin, transportation costs in Estonia per commodity
                three_||';'||                   --Price margin, three digit code
                eighteendottwo_||';'||          --Price margin, deduction costs per commodity
                three_||';'||                   --Price margin, currency of the deduction costs
                twohundredfiftyfive_||';'||     --Informal description of commodity
                twohundredfiftyfive_||';'||     --Informal additional code number
                twohundredfiftyfive_||';'||     --Remarks
                company_contact_name_||';'||    --Name of the person who filled in the report
                declarant_vat_no_||';'||        --Tax registration code
                twohundredfiftyfive_||';'||     --Reporting unit              
                CHR(13) || CHR(10);
                
         output_clob_ := output_clob_ || line_;
                   
   END LOOP;
               
EXCEPTION
  WHEN OTHERS THEN
      IF (dbms_sql.is_open (cid_)) THEN
         dbms_sql.close_cursor (cid_);
      END IF;
      RAISE;   
      
info_ := Client_SYS.Get_All_Info;

END Create_Output;



