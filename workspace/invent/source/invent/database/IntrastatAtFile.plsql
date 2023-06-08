-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatAtFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210714  Hahalk  Bug 159683(SCZ-15468), Supported the csv file generation format instead of the old format.
--  191025  ErFelk  Bug 150686(SCZ-7592), Modified Create_Details__() and Write_Block__() by increasing the variables ftx_ and out_line_ to 3000 characters.
--  160509  NWeelk  STRLOC-55, Modified Create_Details__ by adding new address fields.
--  150721  PrYaLK  Bug 123199, Modified Create_Details__ method to exclude the invoiced value of CO-PURSHIP transaction since it should be 0.
--  150519  ShKolk  Bug 121489, Modified Create_Details__ method to exclude the invoiced value of PURSHIP transaction since it should be 0.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130730  AwWelk  TIBE-839, Removed global variables.
--  121016  PraWlk  Bug 105887, Removed SUBSTR to avoid length restriction of customs statistics number description. 
--  110309  Bmekse  DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                  inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203  Elarse  Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise  Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead. 
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  100107  Umdolk  Refactoring in Communication Methods in Enterprise.
--  090929  PraWlk  Bug 85516, Increased the length of ftx_goods_desc_ to 200.
--  090529  SaWjlk  Bug 83173, Removed the prog text duplications.
--  060810  ChJalk  Modified hard_coded dates to be able to use any calendar.
--  060516  IsAnlk  Enlarge Address - Changed variable definitions.
----------------------------------13.4.0-------------------------------------
--  060120  NiDalk  Added Assert safe annotation. 
--  050919  NiDalk  Removed unused variables.
--  050906  JaBalk  Changed the SUBSTRB to SUBSTR and modified the length of the variable ftx_goods_desc_ to 35.
--  040924  ChJalk  Bug 46743, Modified the length of the variable ftx_goods_desc_ and assigned only the first
--  040924          70 characters to the variable.
--  040227  GeKalk  Replaced substrb with substr for UNICODE modifications.
------------------- EDGE Package Group 3 Unicode Changes --------------------
--  040123  NaWalk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.  
--  030911  MiKulk  Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  020312  DaZa  Bug fix 28308, added ABS on intrastat_alt_qty so we dont get "-x * -y results" when we multiply with the regular qty.
--  010525 JSAnse Bug fix 21463, Added call to General_SYS.Init_Method in procedures Create_Details__ and Write_Block__.
--  010410 DaJoLK Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and 
--                TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  010322  DaZa  Created using spec 'Functional specification for IID 10218 
--                - Austrian Intrastat File' by Martin Korn
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
-- Filter__
--   Method removes unwanted EDIFACT specified characters from a string.
@UncheckedAccess
FUNCTION Filter__ (
   str_           IN VARCHAR2 ) RETURN VARCHAR2
IS
   out_str_       VARCHAR2(2000);
BEGIN
   -- remove any EDIFACTs defined characters 
   out_str_ := replace(str_, '''');  
   out_str_ := replace(out_str_, '+'); 
   out_str_ := replace(out_str_, ':');   
   out_str_ := replace(out_str_, '?'); 
   
   out_str_ := REPLACE(out_str_, ';', '');
   out_str_ := REPLACE(out_str_, '#', '');
   out_str_ := REPLACE(out_str_, '$', '');
   out_str_ := REPLACE(out_str_, '|', '');
   out_str_ := REPLACE(out_str_, '\t', '');
   RETURN out_str_;
END Filter__;   



-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Output
--   Method fetches the intrastat data and formats it according to
--   specifications for Austria.
PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2,
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2 )
IS
   vat_no_               VARCHAR2(50);
   intrastat_direction_  VARCHAR2(10);
   notc_dummy_           VARCHAR2(2);     

   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'AT';   

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
             customs_id,
             registration_no,
             country_code,
             begin_date
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;

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
 
   -- Head blocks
   FOR headrec_ IN get_head LOOP     
      $IF (Component_Invoic_SYS.INSTALLED)$THEN 
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, headrec_.country_code, TRUNC(headrec_.creation_date));
      $END 

      -- head checks
      IF vat_no_ IS NULL THEN 
         Error_SYS.Record_General(lu_name_, 'NOCOMPVATNO: TAX number is missing for company :P1.',headrec_.company);
      END IF;       
      IF (headrec_.representative IS NOT NULL AND headrec_.repr_tax_no IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOREPRVATNO: Representative tax no is missing for Intrastat ID :P1.',intrastat_id_);
      END IF;
      IF (headrec_.customs_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOCUSTOMSID: Customs ID is missing for Intrastat ID :P1.',intrastat_id_);
      END IF;
      IF (headrec_.registration_no IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NULLTAXNO: Reg No is missing for Intrastat :P1', intrastat_id_);       
      END IF;
           
      IF (intrastat_import_ = 'IMPORT') THEN
         Create_Details__(output_clob_,
                           intrastat_id_,
                           'IMPORT',
                           headrec_.creation_date,
                           headrec_.representative,
                           headrec_.rep_curr_rate,
                           headrec_.customs_id,
                           headrec_.country_code);
      END IF;

      IF (intrastat_export_ = 'EXPORT') THEN
         Create_Details__(output_clob_,
                           intrastat_id_,
                           'EXPORT',
                           headrec_.creation_date,
                           headrec_.representative,
                           headrec_.rep_curr_rate,
                           headrec_.customs_id,
                           headrec_.country_code);
      END IF;
            
   END LOOP;   -- head loop
 
   info_ := Client_SYS.Get_All_Info;      


END Create_Output;

-- Create_Details__
-- Method fetches the intrastat data and formats in according to csv format.
PROCEDURE Create_Details__ (
   output_clob_          IN OUT CLOB,
   intrastat_id_         IN     NUMBER,
   intrastat_direction_  IN     VARCHAR2,
   creation_date_        IN     DATE,
   representative_       IN     VARCHAR2,
   rep_curr_rate_        IN     NUMBER,
   customs_id_           IN     VARCHAR2,
   country_code_         IN     VARCHAR2) 
IS
   cn8_code_               VARCHAR2(8);
   nature_of_transaction_  VARCHAR2(1);
   cst_row_no_             NUMBER := 0;
   country_of_origin_      VARCHAR2(2);
   country_of_dispatch_    VARCHAR2(2);
   goods_desc_             VARCHAR2(2048);
   mode_of_transport_      VARCHAR2(1);
   net_mass_               NUMBER := 0;
   supplementary_units_    NUMBER := 0;
   partner_id_             VARCHAR2(17);
   stat_proc_              VARCHAR2(5);
   aut_value_              VARCHAR2(200);
   
   invoiced_values_sum_    NUMBER := 0;
   statistical_values_sum_ NUMBER := 0;
   first_calendar_date_    DATE   := Database_Sys.first_calendar_date_;
   last_calendar_date_     DATE   := Database_Sys.last_calendar_date_;
   line_                   VARCHAR2(2000);

   CURSOR get_lines  IS
      SELECT il.opposite_country,
             il.country_of_origin             country_of_origin,
             cn.country_notc,
             il.mode_of_transport,
             il.customs_stat_no,
             il.statistical_procedure,
             il.intrastat_alt_unit_meas,
             SUM(il.quantity * nvl(il.net_unit_weight,0))                                 net_weight_sum,
             SUM(nvl(ABS(il.intrastat_alt_qty),0) * il.quantity)                          intrastat_alt_qty_sum,
             SUM(il.quantity * nvl(il.invoiced_unit_price, DECODE(il.transaction, 'PURSHIP',    0, 
                                                                                  'CO-PURSHIP', 0, il.order_unit_price))) * rep_curr_rate_
                                                                                          invoiced_amount,
             SUM((nvl(il.invoiced_unit_price, nvl(il.order_unit_price,0)) + 
                  nvl(il.unit_add_cost_amount_inv, nvl(il.unit_add_cost_amount,0)) +
                  nvl(il.unit_charge_amount_inv,0) + nvl(il.unit_charge_amount,0)) * 
                  il.quantity) * rep_curr_rate_                                           statistical_value,
                  DECODE(il.intrastat_direction, 'EXPORT', il.opponent_tax_id, '')  opponent_tax_id
      FROM   intrastat_line_tab il, country_notc_tab cn
      WHERE  il.intrastat_id = intrastat_id_
      AND    il.intrastat_direction = intrastat_direction_
      AND    il.rowstate = 'Released'      
      AND    il.notc = cn.notc      
      AND    cn.country_code = country_code_      
      GROUP BY  il.opposite_country,
                il.country_of_origin,
                cn.country_notc,
                il.mode_of_transport,
                il.customs_stat_no,
                il.statistical_procedure,
                il.intrastat_alt_unit_meas,
                DECODE(il.intrastat_direction, 'EXPORT', il.opponent_tax_id, '');
      
   CURSOR get_authenticy IS
      SELECT value
      FROM   customs_info_comm_method
      WHERE  customs_id = customs_id_
      AND    method_id_db = 'INTERCOM'
      AND    creation_date_ BETWEEN nvl(valid_from, first_calendar_date_)
                            AND     nvl(valid_to,   last_calendar_date_)
      AND    method_default = 'TRUE';   


BEGIN
   -- detail blocks     
   FOR linerec_ IN get_lines LOOP
            
      cst_row_no_ := cst_row_no_ + 1;
            
      cn8_code_ := Filter__(linerec_.customs_stat_no);
      nature_of_transaction_ := Filter__(linerec_.country_notc);
      goods_desc_ := Filter__(Customs_Statistics_Number_API.Get_Description(linerec_.customs_stat_no));
      country_of_dispatch_ := linerec_.opposite_country;   

      mode_of_transport_ := linerec_.mode_of_transport;
      net_mass_ := round(linerec_.net_weight_sum);
      supplementary_units_ := round(linerec_.intrastat_alt_qty_sum);
      invoiced_values_sum_ := round(invoiced_values_sum_ + linerec_.invoiced_amount);
      statistical_values_sum_ := round(statistical_values_sum_ + linerec_.statistical_value);
      country_of_origin_ := linerec_.country_of_origin;

      IF (intrastat_direction_ = 'IMPORT') THEN
               
         IF (linerec_.country_of_origin IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'IMPMISSCOOATF: Some import inventory parts have no country of origin');
         END IF;    

         IF (linerec_.statistical_procedure = 'DELIVERY') THEN
            stat_proc_ := '40000';
         ELSIF (linerec_.statistical_procedure = 'BEFORE SUBCONTRACTING') THEN         
            stat_proc_ := '51004';
         ELSIF (linerec_.statistical_procedure = 'AFTER SUBCONTRACTING') THEN
            stat_proc_ := '61215';         
         END IF;
         partner_id_ := '';
      ELSE -- export
         
         IF (linerec_.opponent_tax_id IS NULL) THEN        
            Client_SYS.Add_Info(lu_name_, 'NOOPPONENTTAXIDAT: Opponent Tax ID is missing for some lines.');
         END IF;
         
         IF (linerec_.statistical_procedure = 'DELIVERY') THEN
            stat_proc_ := '10000';
         ELSIF (linerec_.statistical_procedure = 'BEFORE SUBCONTRACTING') THEN         
            stat_proc_ := '22002';
         ELSIF (linerec_.statistical_procedure = 'AFTER SUBCONTRACTING') THEN
            stat_proc_ := '31514';         
         END IF;
         partner_id_ := linerec_.opponent_tax_id;
      END IF;

      line_ := cn8_code_ || ';' ||
               goods_desc_ || ';' ||
               country_of_dispatch_ || ';' ||
               country_of_origin_ || ';' ||
               nature_of_transaction_ || ';' ||
               stat_proc_ || ';' ||
               mode_of_transport_ || ';' ||
               net_mass_ || ';' ||
               supplementary_units_ || ';' ||
               invoiced_values_sum_ || ';' ||
               statistical_values_sum_ || ';' ||
               partner_id_ || ';' ||
               CHR(13) || CHR(10);
             
      output_clob_ := output_clob_ || line_;

   END LOOP;  -- line loop

   OPEN get_authenticy;
   FETCH get_authenticy INTO aut_value_;
   CLOSE get_authenticy;
   IF (aut_value_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOAUTHCODE: Authenticy code is missing, the code should be saved as a default intercom value for Customs ID :P1', customs_id_);     
   END IF;     
   
END Create_Details__;



