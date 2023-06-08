-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatFrFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211212  ErFelk   Bug 161488(SC21R2-6707), Modified Create_output() by making country_of_origin visible to both import and export.
--  170921  ApWilk   Bug 137682, Added Customers VAT No to display when creating the intrastat file.
--  130813  AwWelk   TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  110811  GayDLK   Bug 95717, Added checks to determine intrastat direction for the new statistical procedures 'DECREASE' and 
--  110811           'TRIANGULAR' and assigned statistical procedure values accordingly in Create_Output().
--  110323  PraWlk   Bug 95757, Modified Create_Output() by adding delivery terms DAT and DAP.
--  100511  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  091007  PraWlk   Bug 85992, Modified the customs_stat_no in cursor get_lines to summarize data
--  091007           according to customs_stat_no.
--  090925  PraWlk   Bug 85992, Removed the spaces of customs_stat_no.
--  050920  NiDalk   Removed unused variables.
--  041101  GaJalk   Bug 47300, Deleted the curosr get_delivery_address inside Create_Output.
--  041025  GaJalk   Bug 47300, Deleted an error message inside procedure Create_Output.
--  040924  RoJalk   Bug 47126, Modified the cursor get_delivery_address and changed
--  040924           ca.country to ca.country_db. 
--  040301  GeKalk  Replaced substrb with substr for UNICODE modifications.
------------------- EDGE Package Group 3 Unicode Changes --------------------
--  030903  GaSolk   Performed CR Merge 2(CR Only).
--  030827  SeKalk   Code Review
--  030826  ThGulk   Replaced  Company_Address_Tab with COMPANY_ADDRESS_PUB
--  030326  SeKalk   Replaced Site_Delivery_Address_Tab and Site_Delivery_Address_API with Company_Address_Tab and Company_Address_API
--  *******************************CR Merge*************************************
--  020312  DaZa     Bug fix 28308, added ABS on intrastat_alt_qty so we dont get "-x * -y results" when we multiply with the regular qty.
--  032201  MKOR     Added an error message for Site and State; Decode on delivery_terms in get_lines added
--  010320  GEKALK   Added an error message to handle when no records for an intrastat_direction..
--  010319  GEKALK   Created
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
--   specifications for France.
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
   statistical_procedure_ VARCHAR2(2); 
   country_of_origin_     VARCHAR2(4); 
   delivery_terms_        INTRASTAT_LINE_TAB.delivery_terms%TYPE;   
   dummy_                 VARCHAR2(5);
   federal_state_         VARCHAR2(2);
   
   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'FR';

   CURSOR get_head IS
      SELECT rep_curr_code,
             rep_curr_rate,
             country_code,
             end_date
             --begin_date
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;
      
   CURSOR exist_lines IS
      SELECT 1
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction = intrastat_direction_;
   
   CURSOR get_lines IS
      SELECT il.intrastat_direction,
             SUBSTR(REPLACE(il.customs_stat_no,' '),1,8)    customs_stat_no,
             cn.country_notc,
             il.statistical_procedure,
             il.opposite_country,
             il.contract,
			    il.mode_of_transport,
             il.delivery_terms,
			    il.country_of_origin,
             SUM(il.quantity * NVL(il.net_unit_weight,0)) net_weight_sum,
             SUM(NVL(ABS(il.intrastat_alt_qty),0) * il.quantity) intrastat_alt_qty_sum,                  
               SUM(il.quantity * NVL(il.invoiced_unit_price, il.order_unit_price)) * rep_curr_rate_  invoice_value,
             SUM((NVL(il.invoiced_unit_price, NVL(il.order_unit_price,0)) + 
                  NVL(il.unit_add_cost_amount_inv, NVL(il.unit_add_cost_amount,0)) +
                  NVL(il.unit_charge_amount_inv,0) +
                  NVL(il.unit_charge_amount,0)) * il.quantity) * rep_curr_rate_  statistical_value,
             DECODE (intrastat_direction_, 'EXPORT', il.opponent_tax_id, '' )    opponent_tax_id
      FROM   intrastat_line_tab il, country_notc_tab cn
      WHERE  il.intrastat_id = intrastat_id_
      AND    il.intrastat_direction = intrastat_direction_
      AND    il.rowstate != 'Cancelled'        
      AND    il.notc = cn.notc      
      AND    cn.country_code = country_code_      
      GROUP BY  il.intrastat_direction,
                SUBSTR(REPLACE(il.customs_stat_no,' '),1,8),
                cn.country_notc,
                il.statistical_procedure,
                il.opposite_country,
                il.contract,
			       il.mode_of_transport,
                il.delivery_terms,
			       il.country_of_origin,
                DECODE (intrastat_direction_, 'EXPORT', il.opponent_tax_id, '' );


BEGIN
  
   IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
          Error_SYS.Record_General(lu_name_, 'NOTBOTH: You can only create an import or export file at the time, not both at the same time');   
   ELSIF (intrastat_export_ = 'EXPORT' AND intrastat_import_ IS NULL) THEN
         intrastat_direction_ := intrastat_export_;
   ELSIF (intrastat_export_ IS NULL AND intrastat_import_ = 'IMPORT') THEN
         intrastat_direction_ := intrastat_import_;
   ELSE -- both is null
         Error_SYS.Record_General(lu_name_, 'DIRECTIONSNULL: At least one transfer option must be checked.');        
   END IF;

   OPEN exist_lines;
     FETCH exist_lines INTO dummy_;
     IF (exist_lines%FOUND) THEN
         CLOSE exist_lines;
     ELSE
         CLOSE exist_lines;
         Error_SYS.Record_General(lu_name_, 'RECORDSNULL: Files with no items are not allowed to be created'); 
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

   FOR linerec_ IN get_lines LOOP   
   
        IF (linerec_.statistical_procedure = 'DELIVERY' ) THEN
             IF (intrastat_direction_ = 'IMPORT') THEN
               statistical_procedure_ := '11';
             ELSE
               statistical_procedure_ := '21';
             END IF;
	     ELSIF (linerec_.statistical_procedure = 'BEFORE SUBCONTRACTING' ) THEN
            IF (intrastat_direction_ = 'IMPORT') THEN
               statistical_procedure_ := '19';
             ELSE
               statistical_procedure_ := '29';
             END IF;
		  ELSIF (linerec_.statistical_procedure = 'AFTER SUBCONTRACTING' ) THEN
            IF (intrastat_direction_ = 'IMPORT') THEN
               statistical_procedure_ := '19';
             ELSE
               statistical_procedure_ := '29';
             END IF;
        ELSIF (linerec_.statistical_procedure = 'DECREASE' ) THEN
            IF (intrastat_direction_ = 'EXPORT') THEN
               statistical_procedure_ := '25';
            END IF;
        ELSIF (linerec_.statistical_procedure = 'TRIANGULAR' ) THEN
            IF (intrastat_direction_ = 'EXPORT') THEN
               statistical_procedure_ := '31';
            END IF;
        ELSIF (linerec_.statistical_procedure = 'INCREASE' ) THEN
            IF (intrastat_direction_ = 'EXPORT') THEN
               statistical_procedure_ := '26';
            END IF;
	     END IF;
        
        IF (linerec_.country_of_origin IS NOT NULL) THEN
            country_of_origin_ := linerec_.country_of_origin || ';' ;
        ELSE
            country_of_origin_ := '';
        END IF;
        
        IF (intrastat_direction_ = 'EXPORT') THEN
           IF (linerec_.country_of_origin IS NULL) THEN
              Error_SYS.Record_General(lu_name_, 'NOCOUNTRYORIGINFR: The country of origin must be specified for intrastat reporting.');   
           END IF;
           IF (linerec_.opponent_tax_id IS NULL) THEN             
              Error_SYS.Record_General(lu_name_, 'NOOPPONENTTAXIDFR: Opponent Tax ID is missing for some lines.');
           END IF;
        END IF;
        
       IF ((linerec_.contract IS NULL)) THEN
          Error_SYS.Record_General(lu_name_, 'CONTRACTNULL: At least one row has no value in column Site.');
       END IF;
  
       federal_state_ := SUBSTR(Company_Address_API.Get_State(Site_API.Get_Company(linerec_.contract), Site_API.Get_Delivery_Address(linerec_.contract)),1,2);
  
        IF (linerec_.delivery_terms IN ('CFR','CIF','CIP','CPT','DAF','DDU','DDP','DEQ','DES','EXW','FAS','FCA','FOB','DAT','DAP','XXX'))  THEN
           delivery_terms_ := linerec_.delivery_terms;
		  ELSIF (linerec_.delivery_terms IS NULL) THEN
           Error_SYS.Record_General(lu_name_, 'NODELIVTERM: At least one row has no value in column Delivery Terms.', linerec_.delivery_terms);
		  ELSE
           Error_SYS.Record_General(lu_name_, 'INVALDELIVTERM: Delivery term :P1 is invalid.', linerec_.delivery_terms);
        END IF;

        -- Create Record Line (each column is semicolon separated)
        line_ :=  linerec_.customs_stat_no || ';' ||    
				      SUBSTR(linerec_.country_notc, 1, 1) || ';' ||
				      SUBSTR(linerec_.country_notc, 2, 1) || ';' ||
				      statistical_procedure_ || ';' ||
				      SUBSTR(linerec_.opposite_country, 1, 3) || ';' ||
				      country_of_origin_ ||
                  federal_state_ || ';' ||
				      SUBSTR(TO_CHAR(ROUND(linerec_.net_weight_sum)), 1, 11) || ';' ||
				      SUBSTR(TO_CHAR(ROUND(linerec_.intrastat_alt_qty_sum)), 1, 11) || ';' ||
				      SUBSTR(linerec_.mode_of_transport, 1, 1) || ';' ||
                  SUBSTR(TO_CHAR(ROUND(linerec_.invoice_value)), 1, 13) || ';' ||
				      SUBSTR(TO_CHAR(ROUND(linerec_.statistical_value)), 1, 13) || ';' ||
				      delivery_terms_||';'||
				      '1' ||';'||
                  linerec_.opponent_tax_id || ';' ||
                  CHR(13) || CHR(10);
        output_clob_ := output_clob_ || line_;
  
  END LOOP;      
 
  info_ := Client_SYS.Get_All_Info;   
   
END Create_Output;



