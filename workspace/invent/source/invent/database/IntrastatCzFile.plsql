-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatCzFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220107  Hahalk  Bug 162020(SC21R2-7000), Added opponent_tax_id and country_of_origin for Export.
--  191222  ApWilk  Bug 145333, Made necessary changes according to the new requirements of the Czech Republic.
--  150721  PrYaLK  Bug 123199, Modified Create_Output method to exclude the invoiced value of CO-PURSHIP transaction since it should be 0.
--  150519  ShKolk  Bug 121489, Modified Create_Output method to exclude the invoiced value of PURSHIP transaction since it should be 0.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130731  MaIklk  TIBE-841, Removed inst_CompanyInvoiceInfo_ global constant and used conditional compilation instead.
--  120925  ShKolk  Merged Bug 102834, Modified net weight, supplementary unit values to display them with correct decimal places.
--  120925          Removed part description and filled the country of origin in despite the Intrastat direction.
--  120411  TiRalk  Bug 100825, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Output (
   output_clob_         OUT CLOB,
   info_                OUT VARCHAR2,
   import_progress_no_  OUT NUMBER,
   export_progress_no_  OUT NUMBER,
   intrastat_id_        IN  NUMBER,
   intrastat_export_    IN  VARCHAR2,
   intrastat_import_    IN  VARCHAR2 )
IS
   dec_period_              VARCHAR2(6);
   type_of_return_          VARCHAR2(1);
   trader_vat_no_           VARCHAR2(10);
   item_no_                 VARCHAR2(3);
   commodity_               VARCHAR2(8);
   region_of_origin_        VARCHAR2(2);
   country_of_origin_       VARCHAR2(2);
   country_of_destination_  VARCHAR2(2);
   mode_of_transport_       VARCHAR2(1);
   notc_                    VARCHAR2(2);
   delivery_terms_          VARCHAR2(3);
   invoice_value_           VARCHAR2(14);
   statistical_value_       VARCHAR2(14);
   net_mass_                VARCHAR2(13);
   sup_units_               VARCHAR2(13);

   line_                     VARCHAR2(2000);
   line_counter_             NUMBER := 0;
   vat_no_                   VARCHAR2(50);
   rep_curr_rate_            NUMBER;
   country_code_             VARCHAR2(2); 
   intrastat_direction_      VARCHAR2(10);
   notc_dummy_              VARCHAR2(5);
   movement_code_           VARCHAR2(2);
   additional_code_         VARCHAR2(2);
   internal_note_first_     VARCHAR2(40);
   internal_note_second_    VARCHAR2(40);
   dec_month_               VARCHAR2(2);
   dec_year_                VARCHAR2(4);
   com_code_desc_           VARCHAR2(2000);
   goods_description_       VARCHAR2(2000);
      

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
             i.region_of_origin,
             i.country_of_origin,
             cn.country_notc,
             i.mode_of_transport,
             i.customs_stat_no,
			    i.delivery_terms,
             i.movement_code,
             DECODE (intrastat_direction_, 'EXPORT', i.opponent_tax_id, '' )    opponent_tax_id,
             SUM(i.quantity * NVL(i.invoiced_unit_price, DECODE(i.transaction, 'PURSHIP',    0, 
                                                                               'CO-PURSHIP', 0, i.order_unit_price))) * rep_curr_rate_
                                                                                 invoice_value,
             SUM((NVL(i.invoiced_unit_price,NVL(i.order_unit_price,0)) + 
                  NVL(i.unit_add_cost_amount_inv,NVL(i.unit_add_cost_amount,0)) +
                  NVL(i.unit_charge_amount_inv,0) +
                  NVL(i.unit_charge_amount,0)) * i.quantity) * rep_curr_rate_    statistical_value,
             SUM(i.quantity * i.net_unit_weight)                                 mass,
			    SUM(NVL(i.intrastat_alt_qty,0))                                     sup_units
	  FROM   intrastat_line_tab i ,country_notc_tab cn
     WHERE  intrastat_id = intrastat_id_
     AND    intrastat_direction = intrastat_direction_
     AND    rowstate           != 'Cancelled'
     AND    i.notc = cn.notc      
     AND    cn.country_code = country_code_
     GROUP BY  i.intrastat_direction,
               i.opposite_country,
               i.region_of_origin,
               i.country_of_origin,
               cn.country_notc,
               i.mode_of_transport,
               i.customs_stat_no,
               i.delivery_terms,
               i.movement_code,
               DECODE (intrastat_direction_, 'EXPORT', i.opponent_tax_id, '' );
                
   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'CZ'; 

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
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, Company_API.Get_Country_Db(headrec_.company), TRUNC(SYSDATE));
      $END
      
      IF (substrb(vat_no_, 1, 2) = headrec_.country_code) THEN
         trader_vat_no_ := NVL(LPAD(substrb(vat_no_,3,10),10),LPAD(' ',10));
      ELSE
         trader_vat_no_ := NVL(LPAD(substrb(vat_no_,1,10),10),LPAD(' ',10));
      END IF;
             
      dec_period_          := to_char(headrec_.end_date, 'MMYYYY');
      dec_month_           := to_char(headrec_.end_date, 'MM');
      dec_year_            := to_char(headrec_.end_date, 'YYYY');
      
      
      IF (intrastat_direction_ = 'IMPORT') THEN
         type_of_return_   := '1';
      ELSE
         type_of_return_    := '2';
      END IF;
      
      IF ( headrec_.rep_curr_code NOT IN ('CZK','EUR')) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCURR: Currency Code :P1 is not a valid currency, only CZK and EUR is acceptable', headrec_.rep_curr_code); 
      END IF;
      
      rep_curr_rate_        := headrec_.rep_curr_rate;
      country_code_         := headrec_.country_code;
   END LOOP;
          
   FOR linerec_ IN get_lines LOOP
      line_counter_             := line_counter_ + 1;            
      item_no_                := LPAD(line_counter_,3,'0');
      commodity_              := NVL(RPAD(substrb(linerec_.customs_stat_no,1,8),8),LPAD(' ',8));
      country_of_destination_ := RPAD(substrb(linerec_.opposite_country,1,2),2);
      
      region_of_origin_       := ' ';
      IF (intrastat_direction_ = 'EXPORT') THEN
         IF (linerec_.opponent_tax_id IS NULL) THEN
            linerec_.opponent_tax_id := 'QV123';   
         END IF;
      END IF;
      
      IF (linerec_.country_of_origin IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOCOUNTRYORIGIN: The country of origin must be specified for intrastat reporting.');   
      END IF; 
      country_of_origin_   := NVL(RPAD(substrb(linerec_.country_of_origin,1,2),2),LPAD(' ',2));
      
      com_code_desc_          := Customs_Statistics_Number_API.Get_Description(linerec_.customs_stat_no);
      goods_description_      := com_code_desc_;
      goods_description_      := ' ';
      
      
      notc_                   := NVL(LPAD(substrb(linerec_.country_notc,1,2),2),LPAD(' ',2));
      mode_of_transport_      := NVL(linerec_.mode_of_transport,1);
      invoice_value_          := NVL(LPAD(ROUND(linerec_.invoice_value), 14, ' '), LPAD(' ', 14));
		
      IF ( linerec_.delivery_terms IN ('EXW','FCA','FAS','FOB')) THEN
         delivery_terms_      := 'K';
      ELSIF (linerec_.delivery_terms IN ('CFR', 'CIF')) THEN
         delivery_terms_      := 'L';
      ELSIF (linerec_.delivery_terms IN ('DAT', 'DAP', 'DDP', 'CPT', 'CIP')) THEN
         delivery_terms_      := 'M';
      ELSE
         delivery_terms_      := 'N';
      END IF;
      
      IF SUBSTR(commodity_, 1, 4) IN ('2844', '2716') THEN
         net_mass_ := '0.001';
      ELSE
         IF linerec_.mass = 0 THEN
            net_mass_ := '0.000';
         ELSE
            IF linerec_.mass < 1 AND linerec_.mass > 0 THEN
               net_mass_ := ROUND(linerec_.mass, 3);
               net_mass_ := '0' || RPAD(SUBSTR(net_mass_,INSTR(net_mass_, '.')), 4, 0);            
            ELSE
               net_mass_ := ROUND(linerec_.mass) || '.000';
            END IF;
         END IF;
      END IF;

      IF linerec_.sup_units IS NULL THEN
         sup_units_ := '0.000';
      ELSE
         IF INSTR(linerec_.sup_units, '.') = 0 THEN
            sup_units_ := linerec_.sup_units || '.000';
         ELSE
            sup_units_ := ROUND(linerec_.sup_units, 3);
            sup_units_ := NVL(SUBSTR(sup_units_, 1, INSTR(sup_units_, '.')-1), 0) || RPAD(SUBSTR(sup_units_, INSTR(sup_units_, '.') ), 4, 0);
         END IF;
      END IF;
      
      statistical_value_         := ' ';
      additional_code_           := substrb(linerec_.customs_stat_no,9,2);
      net_mass_                  := LPAD(net_mass_, 13);
      sup_units_                 := LPAD(sup_units_, 13);
      movement_code_             := NVL(RPAD(linerec_.movement_code,2), '  ');     
      internal_note_first_       := ' ';
      internal_note_first_       := RPAD(internal_note_first_,40);
      internal_note_second_      := ' ';
      internal_note_second_      := RPAD(internal_note_second_,40);

      line_ := dec_month_ || ';' ||
             dec_year_ || ';' ||
             trader_vat_no_ || ';' ||
             type_of_return_ || ';' ||
             linerec_.opponent_tax_id || ';' ||
             country_of_destination_ || ';' ||
             region_of_origin_ || ';' ||
             country_of_origin_ || ';' ||
             notc_ || ';' ||
             mode_of_transport_ || ';' ||
             delivery_terms_ || ';' ||
             movement_code_ || ';' ||
             commodity_ || ';' ||
             additional_code_ || ';' ||
             goods_description_ || ';' ||
             net_mass_ || ';' ||
             sup_units_ || ';' ||
             invoice_value_ || ';' ||
             statistical_value_ || ';' ||
             internal_note_first_ || ';' ||
             internal_note_second_ || ';' ||
             CHR(13) || CHR(10);
             
      output_clob_ := output_clob_ || line_;
   END LOOP;

   IF line_ IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'NORECORDS: Files with no items are not allowed to be created');
   END IF;
  
info_ := Client_SYS.Get_All_Info;

END Create_Output;



