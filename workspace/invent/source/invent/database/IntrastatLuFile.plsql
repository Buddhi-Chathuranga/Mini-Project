-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatLuFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200120  ErFelk  Bug 151857(SCZ-8500), Modified cursor get_lines by removing charges when calculating the statistical_value.
--  191207  ChJalk  Bug 150820(SCZ-7228), Created Intrastat file for country Luxembourg.
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
   rep_curr_rate_         NUMBER;
   country_code_          VARCHAR2(2);   
   intrastat_direction_   VARCHAR2(10);
   dummy_                 VARCHAR2(1);
   notc_dummy_            VARCHAR2(2);
   field1_                VARCHAR2(2);
   field2_                VARCHAR2(2);
   field3_                VARCHAR2(2);
   field4_                VARCHAR2(1);
   field5_                VARCHAR2(8);
   field6_                VARCHAR2(10);
   field7_                VARCHAR2(10);
   field8_                VARCHAR2(10);
   field9_                VARCHAR2(10);
   field10_               VARCHAR2(20);  
   
   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'LU';   

   CURSOR check_contract IS
         SELECT 1
         FROM   intrastat_line_tab
         WHERE  intrastat_id        = intrastat_id_
         AND    intrastat_direction = intrastat_direction_
         AND    contract IS NULL;
         
   CURSOR get_head IS
      SELECT company,
             creation_date,
             rep_curr_code,
             rep_curr_rate,
             country_code
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;
      
   CURSOR get_lines IS
      SELECT il.intrastat_direction,
             il.opposite_country                                                                                  opposite_country,
             DECODE(intrastat_direction_, 'IMPORT', il.country_of_origin, '')                                     country_of_origin,
             cn.country_notc,
             il.mode_of_transport,
             SUBSTR(REPLACE(il.customs_stat_no,' '),1,8)                                                          customs_stat_no,
             SUM(il.quantity * il.net_unit_weight)                                                                mass,
             SUM(NVL(ABS(il.intrastat_alt_qty),0) * il.quantity)                                                  alternative_qty,
             SUM(il.quantity * NVL(il.invoiced_unit_price, il.order_unit_price)) * rep_curr_rate_                 invoice_value,
             SUM((NVL(il.invoiced_unit_price, NVL(il.order_unit_price,0)) + 
                  NVL(il.unit_add_cost_amount_inv, NVL(il.unit_add_cost_amount,0))) * il.quantity) * rep_curr_rate_    statistical_value,                                                                                                     
             DECODE(intrastat_direction_, 'EXPORT',il.opponent_tax_id, '')                                        partner_vat_no
      FROM   country_notc_tab cn, intrastat_line_tab il
      WHERE  intrastat_id        = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    il.rowstate         = 'Released'      
      AND    il.notc             = cn.notc
      AND    cn.country_code     = country_code_
      GROUP BY  il.intrastat_direction,
                il.opposite_country,
                DECODE(intrastat_direction_, 'IMPORT', il.country_of_origin, ''),
                il.mode_of_transport,                                
                cn.country_notc,                                            
                SUBSTR(REPLACE(il.customs_stat_no,' '),1,8),                
                DECODE(intrastat_direction_, 'EXPORT',il.opponent_tax_id, '');
                   
      get_lines_dummy_  get_lines%ROWTYPE;
      
BEGIN
   IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOTBOTH: You can only create an import or export file at the time, not both at the same time');   
   ELSIF (intrastat_export_ = 'EXPORT' AND intrastat_import_ IS NULL) THEN
      intrastat_direction_ := intrastat_export_;
   ELSIF (intrastat_export_ IS NULL AND intrastat_import_ = 'IMPORT') THEN
      intrastat_direction_ := intrastat_import_;
   ELSE 
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
   
   OPEN check_contract;
   FETCH check_contract INTO dummy_;
   IF (check_contract%FOUND) THEN    
      CLOSE check_contract;
      Error_SYS.Record_General(lu_name_, 'NOCONTRACT: The site must be specified for intrastat reporting.');   
   END IF;        
   CLOSE check_contract; 

   -- Head blocks
   FOR headrec_ IN get_head LOOP      
      IF (headrec_.rep_curr_code NOT IN ('EUR')) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCURR: Currency Code :P1 is not a valid currency, only EUR is acceptable', headrec_.rep_curr_code);         
      END IF;
      rep_curr_rate_ := headrec_.rep_curr_rate;
      country_code_  := headrec_.country_code;
      
      OPEN  get_lines;
      FETCH get_lines INTO get_lines_dummy_;
      IF (get_lines%NOTFOUND) THEN
         CLOSE get_lines;      
         Error_SYS.Record_General(lu_name_, 'NORECOR: Files with no items are not allowed to be created.');      
      END IF;
      CLOSE get_lines;
      
      FOR linerec_ IN get_lines LOOP
         field1_ := linerec_.opposite_country;
         IF (linerec_.country_of_origin IS NULL AND intrastat_direction_ = 'IMPORT') THEN
            Error_SYS.Record_General(lu_name_, 'NOCOUNTRYORIGIN: The country of origin must be specified for intrastat reporting.');   
         END IF;
         field2_ := linerec_.country_of_origin;         
         field3_ := linerec_.country_notc;         
         field4_ := linerec_.mode_of_transport;         
         IF (linerec_.customs_stat_no IS NOT NULL) THEN
            field5_ := linerec_.customs_stat_no;            
         ELSE
            Error_SYS.Record_General(lu_name_, 'NOSTATNUMBER: The customs statistics number must be specified for intrastat reporting.');   
         END IF;
         field6_  := SUBSTR(TO_CHAR(ROUND(abs(linerec_.mass))), 1, 10);         
         field7_  := SUBSTR(TO_CHAR(ROUND(abs(linerec_.alternative_qty))), 1, 10);         
         field8_  := SUBSTR(TO_CHAR(ROUND(abs(linerec_.invoice_value))), 1, 10);         
         field9_  := SUBSTR(TO_CHAR(ROUND(abs(linerec_.statistical_value))), 1, 10);         
         field10_ := SUBSTR(REPLACE(linerec_.partner_vat_no,' '),1,20);
         IF (intrastat_direction_ = 'EXPORT') THEN   
            line_ := field1_  || ';' ||                  
                  field3_  || ';' ||
                  field4_  || ';' ||
                  field5_  || ';' ||
                  field6_  || ';' ||
                  field7_  || ';' ||
                  field8_  || ';' ||
                  field9_  || ';' ||
                  field10_ || ';' ||                  
                  CHR(13)  || CHR(10);
            output_clob_ := output_clob_ || line_;
         ELSIF(intrastat_direction_ = 'IMPORT') THEN
            line_ := field1_  || ';' ||
                  field2_  || ';' ||
                  field3_  || ';' ||
                  field4_  || ';' ||
                  field5_  || ';' ||
                  field6_  || ';' ||
                  field7_  || ';' ||
                  field8_  || ';' ||
                  field9_  || ';' ||                                    
                  CHR(13)  || CHR(10);
            output_clob_ := output_clob_ || line_;
         END IF;
      END LOOP;      
      info_        := Client_SYS.Get_All_Info;   
   END LOOP; -- head loop
END Create_Output;
-------------------- LU  NEW METHODS -------------------------------------
