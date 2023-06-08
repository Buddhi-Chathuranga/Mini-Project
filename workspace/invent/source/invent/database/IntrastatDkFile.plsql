-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatDkFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211207  Hahalk  Bug 161186(SC21R2-6469), Modified the file format to use tab instead of spaces and added country of origin and opponent tax id to the report.
--  160426  PrYaLK  Bug 127368, Modified Create_Output() by adding a line separator at the end of each different record types in
--  160426          import and export files.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130731  MaIklk  TIBE-843, Removed inst_TaxLiabilityCountries_ global constant and used conditional compilation instead.
--  110309  Bmekse  DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                  inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203  Elarse  Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise  Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead. 
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060120  NiDalk  Added Assert safe annotation. 
--  060104  RoJalk  Bug 55428, Modified the code related to net_weight_ calculation. 
--  050919  NiDalk  Removed unused variables.
--  040308  KaDilk  Bug 42922, Round up the net_weight_ value to its upper limit if 0<net_weight_< 1.
--  040301  GeKalk  Replaced substrb with substr for UNICODE modifications.
--  040203  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  030911  MiKulk  Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  020322  DaZa  Bug fix 28308, added ABS on intrastat_alt_qty so we dont get "-x * -y results" when we multiply with the regular qty.
--  020320  CaSt  Bug fix 28679, Added ROUND to the calculation of sup_qty_. Modified calculation of
--                alternative_qty in cursor get_lines. 
--  010411 DaJoLK Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and 
--                TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  260201  Indi  Created.
--  190301  Indi  Changed according to the file sent
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
--   specifications for Denmark.
PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2,
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,  
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2 )
IS

   intrastat_direction_  VARCHAR2(10);
   
   item_no_             NUMBER;  
   country_              VARCHAR2(3);
   not_                VARCHAR2(2);
   notc_dummy_           VARCHAR2(2); 
   com_code_          VARCHAR2(8);
   net_weight_          VARCHAR2(15);
   sup_qty_              VARCHAR2(10);
   stat_val_          VARCHAR2(15);
      
   boundle_tot_          NUMBER:=0;

   end_date_             DATE;   
   line_                 VARCHAR2(2000);
   rep_curr_rate_        NUMBER;
   vat_no_               VARCHAR2(50);   
   country_code_         VARCHAR2(2);

   tmp_counter_          NUMBER;

   country_of_origin_    VARCHAR2(3);
   partnet_vat_no_       VARCHAR2(20);
   refernce_no_          VARCHAR2(30);

								    
   CURSOR get_head IS
      SELECT company,
             representative,
             repr_tax_no,  
             end_date,
			    customs_id,
			    bransch_no,
             creation_date,
             rep_curr_code,
             rep_curr_rate,
			    begin_date,
             country_code
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;

  CURSOR get_lines IS
      SELECT il.intrastat_direction,
             il.opposite_country,                          
             cn.country_notc,            
             il.customs_stat_no,                 
             SUM(il.quantity * il.net_unit_weight) mass,
             SUM(il.quantity * nvl(ABS(il.intrastat_alt_qty),0)) alternative_qty,
             SUM(il.quantity * nvl(il.invoiced_unit_price, il.order_unit_price)) * rep_curr_rate_ invoice_value,
			    SUM((nvl(il.invoiced_unit_price, il.order_unit_price)+
			      nvl(il.unit_add_cost_amount_inv, nvl(il.unit_add_cost_amount,0))+
			      nvl(il.unit_charge_amount_inv,0)+nvl(il.unit_charge_amount,0))*il.quantity)*rep_curr_rate_ statistical_value,
             DECODE(il.intrastat_direction, 'EXPORT', il.country_of_origin, '')      country_of_origin,
             DECODE(il.intrastat_direction, 'EXPORT', il.opponent_tax_id, '')  opponent_tax_id
      FROM   intrastat_line_tab il, country_notc_tab cn
      WHERE  intrastat_id        = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    il.notc             = cn.notc      
      AND    cn.country_code     = country_code_
      AND    rowstate            = 'Released'           
      GROUP BY  il.intrastat_direction,
                il.opposite_country,
                cn.country_notc,            
                il.customs_stat_no,
                DECODE(il.intrastat_direction, 'EXPORT', il.country_of_origin, ''),
                DECODE(il.intrastat_direction, 'EXPORT', il.opponent_tax_id, '');

 CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;

 
 CURSOR get_country_notc(notc_ VARCHAR2) IS
      SELECT country_notc
	  FROM   country_notc_tab
	  WHERE  notc = notc_
	  AND    country_code = 'DK';

BEGIN  

  IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
     intrastat_direction_ := 'BOTH';  
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
 

   FOR headrec_ IN get_head LOOP  
      $IF (Component_Invoic_SYS.INSTALLED) $THEN
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, headrec_.country_code, TRUNC(headrec_.creation_date));
      $END
	   end_date_      :=headrec_.end_date;
	   rep_curr_rate_ :=headrec_.rep_curr_rate;
	   country_code_  := headrec_.country_code;      
   END LOOP;
      
   IF(intrastat_export_ IS NOT NULL) THEN
      intrastat_direction_ := intrastat_export_;
      item_no_ := 1;
      tmp_counter_ := 0;
      
      FOR linerec_ IN get_lines LOOP       
         tmp_counter_ := tmp_counter_ + 1;
         IF (linerec_.opponent_tax_id IS NULL) THEN    
            Error_SYS.Record_General(lu_name_, 'NOOPPONENTTAXIDDK: Opponent Tax ID is missing for some lines.');
         END IF; 
         
         IF (linerec_.country_of_origin IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOCOUNTRYORIGIN: The country of origin must be specified for intrastat reporting.');   
         END IF;
         
         country_           := RPAD(linerec_.opposite_country,3,' ');
         not_               := RPAD(linerec_.country_notc,2,' ');
         com_code_          := RPAD(linerec_.customs_stat_no,8,' ');

         IF ( linerec_.mass BETWEEN 0 AND 1 ) THEN
            net_weight_     := RPAD(TO_CHAR(CEIL(ABS(linerec_.mass))),10,' ');
         ELSE
            net_weight_     := RPAD(TO_CHAR(ROUND(ABS(linerec_.mass))),10,' ');
         END IF;
         sup_qty_           := RPAD(TO_CHAR(ROUND(NVL(linerec_.alternative_qty,0))),11,' ');
         stat_val_          := RPAD(TO_CHAR(ROUND(ABS(linerec_.invoice_value))),11,' ');
         boundle_tot_       := boundle_tot_+ROUND(linerec_.invoice_value) ;
         country_of_origin_ := RPAD(linerec_.country_of_origin,3,' ');
         partnet_vat_no_    := RPAD(linerec_.opponent_tax_id,20,' ');
         refernce_no_       := '';
         
         line_ := com_code_ || CHR(9) ||
                  country_  || CHR(9) ||
                  not_ || CHR(9) ||
                  sup_qty_ || CHR(9) ||
                  net_weight_ || CHR(9) || 
                  stat_val_ || CHR(9) ||     
                  rpad(refernce_no_,30,' ') || CHR(9) ||        
                  partnet_vat_no_ || CHR(9) ||     
                  country_of_origin_ || CHR(9) ||     
                  CHR(13) || CHR(10);

           output_clob_ := output_clob_ || line_;   
         item_no_ := item_no_+1;	             
      END LOOP;
   END IF;

   IF(intrastat_import_ IS NOT NULL) THEN 
      intrastat_direction_  := intrastat_import_;	   
      item_no_              := 1;
      tmp_counter_          := 0;
      FOR linerec_ IN get_lines LOOP       
         tmp_counter_       := tmp_counter_ + 1; 
         
         country_           := RPAD(linerec_.opposite_country,3,' ');
         not_               := RPAD(linerec_.country_notc,2,' ' );
         com_code_          := RPAD(linerec_.customs_stat_no,8,' ');

         IF ( linerec_.mass BETWEEN 0 AND 1 ) THEN
            net_weight_     := RPAD(TO_CHAR(CEIL(ABS(linerec_.mass))), 10, ' ');
         ELSE
            net_weight_     := RPAD(TO_CHAR(ROUND(ABS(linerec_.mass))), 10, ' ');
         END IF;
       
         sup_qty_           := RPAD(TO_CHAR(ROUND(NVL(linerec_.alternative_qty,0))),11,' ');
         stat_val_          := RPAD(TO_CHAR(ROUND(ABS(linerec_.invoice_value))),11,' ');
         boundle_tot_       := boundle_tot_+ROUND(linerec_.invoice_value) ;
         country_of_origin_ := RPAD(linerec_.country_of_origin,3,' ');
         partnet_vat_no_    := RPAD(linerec_.opponent_tax_id,20,' ');
         refernce_no_       := '';

         line_ := com_code_ || CHR(9) ||
                  country_  || CHR(9) ||
                  not_ || CHR(9) ||
                  sup_qty_ || CHR(9) ||
                  net_weight_ || CHR(9) || 
                  stat_val_ || CHR(9) ||     
                  rpad(refernce_no_,30,' ') || CHR(9) ||        
                  partnet_vat_no_ || CHR(9) ||     
                  country_of_origin_ || CHR(9) ||     
                  CHR(13) || CHR(10);
               
         output_clob_ := output_clob_ || line_;
         item_no_ := item_no_+1;	             
      END LOOP; 
   END IF;

  info_:= Client_SYS.Get_All_Info;   
  
END Create_Output;



