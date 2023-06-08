-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatHuFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211118  ErFelk  Bug 161257 (SC21R2-5286), Converted all the xml tags to English. Removed tag oszlop.
--  200214  ApWilk  Bug 149793 (SCZ-6714), Moved the IF block to create the missing XML tags in import and export XML.
--  200214  ApWilk  Bug 147907 (SCZ-4297), Made necessary changes to support additional requiremnets of intrastat changes in 2019.
--  200213  ApWilk  Bug 145769 (SCZ-2219), Added the methods Create_Line___(),Create_Details__() and modified Create_Output() to generate the file in xml.
--  200213          Also merged the neccessary changes done through the bugs 147907 and 149793.
--  170705  PrYaLK  Bug 136586, Modified Create_Output() by reducing the casting field length of repr_tax_no_.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130731  MaIklk  TIBE-848, Removed inst_TaxLiabilityCountries_ global constant and used conditional compilation instead.
--  120410  AyAmlk  Bug 100608, Increased the length of delivery_terms_ in Create_Output().
--  110421  AwWelk  Bug 95352, Removed the country_notc code 42 from the NOT IN check in the   
--  110421          WHERE clauses of CURSOR get_lines and CURSOR get_number_of_line in Create_Output().
--  110421  GayDLK  Bug 93954, Removed the country_notc code 52 from the NOT IN checks in the   
--  110421          WHERE clauses of CURSOR get_lines and CURSOR get_number_of_line in Create_Output().
--  110323  PraWlk  Bug 95757, Modified Create_Output() by adding delivery terms DAT and DAP.
--  110309  Bmekse  DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                  inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203  Elarse  Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise  Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead.
--  100107  Umdolk Refactoring in Communication Methods in Enterprise.
--  090928  ChFolk  Removed unused variables in the package.
--  ---------------------------- 14.0.0 -------------------------------------
--  090601  SaWjlk  Bug 83173, Removed the prog text duplications.
--  090121  HoInlk  Bug 79846, Removed length restrictions of number variables sequence_number_
--  090121          invoice_value_ and statistical_value_.
--  060516  IsAnlk  Enlarge Address - Changed variable definitions.
--  --------------------------13.4.0-----------------------------------------
--  061109  KaDilk Bug 60521, Changed few NUMBER type variables into VARCHAR2.
--  060123  NiDalk Rewrote the DBMS_SQL to Native dynamic SQL and added Assert safe annotation. 
--  050906  JaBalk Removed the SUBSTRB and changed the length of variable company_contact_name_ to 100.
--  040908  CaRase Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Create_Line___(
   output_clob_ IN OUT CLOB,
   line_        IN     VARCHAR2 )
IS
   text_    VARCHAR2(32000);
   ptr_     NUMBER;
   name_    VARCHAR2(1000);
   value_   VARCHAR2(32000);
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(line_, ptr_, name_, value_)) LOOP
      text_ := text_ || name_ || value_;
   END LOOP;
   output_clob_ := output_clob_ || text_;
END Create_Line___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Create_Details__ (
   output_clob_          IN OUT CLOB,
   intrastat_id_         IN     NUMBER,
   intrastat_direction_  IN     VARCHAR2,         
   rep_curr_rate_        IN     NUMBER,
   country_code_         IN     VARCHAR2 )
IS
   line_                    VARCHAR2(32000);
   pos_id_                  NUMBER := 0;
   sequence_number_         NUMBER := 0;
   line_count_              NUMBER := 0;
   dummy_                   BOOLEAN := TRUE;
   commodity_               VARCHAR2(8);              
   country_of_destination_  VARCHAR2(3); 
   notc_                    VARCHAR2(2);                   
   invoice_value_           NUMBER;
   statistical_value_       NUMBER; 
   net_weight_sum_          VARCHAR2(10);  
   sup_units_               VARCHAR2(18);  
   country_of_origin_       VARCHAR2(2);  
   partner_tax_id_          VARCHAR2(50);
   total_rows_              NUMBER;
   line_no_                 NUMBER := 0;
   rounded_invoice_value_   NUMBER;
   rounded_order_value_     NUMBER;
   
   -- Get all the line details
   CURSOR get_lines IS
      SELECT i.intrastat_direction,
            i.opposite_country,
            cn.country_notc,
            SUBSTR(i.customs_stat_no, 1, 8)                                                            customs_stat_no, 
            SUM(i.quantity * i.net_unit_weight)                                                        net_weight_sum,
            SUM(i.quantity * nvl(i.invoiced_unit_price, i.order_unit_price)) * rep_curr_rate_          invoice_value,
            SUM(i.quantity * nvl(i.order_unit_price, i.order_unit_price)) * rep_curr_rate_             order_value,
            SUM((NVL(i.invoiced_unit_price,nvl(i.order_unit_price,0)) + 
                 NVL(i.unit_add_cost_amount_inv,nvl(i.unit_add_cost_amount,0)) +
                 NVL(i.unit_charge_amount_inv,0) +
                 NVL(i.unit_charge_amount,0)) * i.quantity) * rep_curr_rate_                           statistical_value,
            SUM(nvl(ABS(i.intrastat_alt_qty),0) * i.quantity)                                          sup_units,
            i.country_of_origin                                                                        country_of_origin,
            DECODE(intrastat_direction_, 'EXPORT', i.opponent_tax_id, NULL)                            opponent_tax_id,
            i.intrastat_alt_unit_meas
      FROM   intrastat_line_tab i ,country_notc_tab cn
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    rowstate           != 'Cancelled'
      AND    i.notc = cn.notc      
      AND    cn.country_code = country_code_
      AND    cn.country_notc NOT IN (43, 53, 61, 62) 
      AND    i.quantity != i.qty_reversed
      AND    i.transaction NOT IN ('UNRCPT-','OEUNSHIP') 
      GROUP BY  i.intrastat_direction,
                i.opposite_country,
                cn.country_notc,
                SUBSTR(i.customs_stat_no, 1, 8),
                i.country_of_origin,
                DECODE(intrastat_direction_, 'EXPORT', i.opponent_tax_id, NULL),
                i.intrastat_alt_unit_meas;
                
   CURSOR get_number_of_line IS
      SELECT count(*) FROM
         (SELECT i.intrastat_direction,
               i.opposite_country,
               cn.country_notc,
               SUBSTR(i.customs_stat_no, 1, 8)                                                            customs_stat_no,
               i.country_of_origin,
               DECODE(intrastat_direction_, 'EXPORT', i.opponent_tax_id, NULL)                            opponent_tax_id,
               i.intrastat_alt_unit_meas
         FROM   intrastat_line_tab i ,country_notc_tab cn
         WHERE  intrastat_id = intrastat_id_
         AND    intrastat_direction = intrastat_direction_
         AND    rowstate != 'Cancelled'
         AND    i.notc = cn.notc      
         AND    cn.country_code = country_code_
         AND    cn.country_notc NOT IN (43, 53, 61, 62)
         AND    i.quantity != i.qty_reversed
         AND    i.transaction NOT IN ('UNRCPT-','OEUNSHIP')      
         GROUP BY  i.intrastat_direction,
                  i.opposite_country,
                  cn.country_notc,
                  SUBSTR(i.customs_stat_no, 1, 8),
                  i.country_of_origin,
                  DECODE(intrastat_direction_, 'EXPORT', i.opponent_tax_id, NULL),
                  i.intrastat_alt_unit_meas);      
               
BEGIN
    
   pos_id_              := 0;
   sequence_number_     := 0;
   line_count_          := 0;
   dummy_               := TRUE;
   line_no_             := 0;
     
   OPEN get_number_of_line;
   FETCH get_number_of_line INTO total_rows_;
   CLOSE get_number_of_line; 
     
   FOR linerec_ IN get_lines LOOP
   
         pos_id_                    := pos_id_ + 1;
         rounded_invoice_value_     := ROUND(linerec_.invoice_value);
         rounded_order_value_       := ROUND(linerec_.order_value);
         IF(rounded_invoice_value_ != 0 OR rounded_order_value_ != 0)THEN
         
            line_count_                := line_count_ + 1;
            commodity_                 := NVL(rpad(SUBSTR(linerec_.customs_stat_no,1,8),8),LPAD(' ',8));
            country_of_destination_    := SUBSTR(linerec_.opposite_country,1,3);
            notc_                      := RPAD(linerec_.country_notc,2);

            IF linerec_.invoice_value IS NOT NULL THEN
               invoice_value_          := ROUND(linerec_.invoice_value);
            ELSE
               invoice_value_          := ROUND(linerec_.order_value);
            END IF;

            statistical_value_         := ROUND(linerec_.statistical_value);


            IF(linerec_.net_weight_sum > 1)THEN
               net_weight_sum_         := ROUND(linerec_.net_weight_sum);
            ELSE
               net_weight_sum_         := ROUND(linerec_.net_weight_sum,3);
            END IF;

            IF(linerec_.sup_units > 1)THEN
               sup_units_              := ROUND(linerec_.sup_units); 
            ELSE
               sup_units_              := ROUND(linerec_.sup_units,3);   
            END IF;

            country_of_origin_         := linerec_.country_of_origin;
            partner_tax_id_            := linerec_.opponent_tax_id;

            IF(line_count_ = 1 AND dummy_) THEN
               sequence_number_        := sequence_number_ + 1;
               line_ := '<chapter>' || CHR(13) || CHR(10);
               output_clob_ := output_clob_ || line_;
               line_ := '<identifier>' || '1' || '</identifier>';
               output_clob_ := output_clob_ || line_;
               line_ := '<order>' || sequence_number_ || '</order>';
               output_clob_ := output_clob_ || line_;
               line_ := '<table>' || CHR(13) || CHR(10);
               output_clob_ := output_clob_ || line_;
               line_ := '<identifier>' || 'Termek' || '</identifier>';
               output_clob_ := output_clob_ || line_;
               Create_Line___(output_clob_, line_);
               dummy_ := FALSE;
            END IF;         
            
            line_no_ := line_no_ + 1;
           
            line_ := '<row>' || CHR(13) || CHR(10);
            output_clob_ := output_clob_ || line_;

            Client_SYS.Clear_Attr(line_);
            Client_Sys.Add_To_Attr('<data>',                               '',                                 line_);
               Client_Sys.Add_To_Attr('<identifier>',                      'T_SORSZ',                          line_);
               Client_Sys.Add_To_Attr('</identifier>',                     '',                                 line_);
               Client_Sys.Add_To_Attr('<value>',                           LPAD(line_no_, 5, '0'),              line_);
               Client_Sys.Add_To_Attr('</value>',                          '',                                 line_);
            Client_Sys.Add_To_Attr('</data>',                              '',                                 line_);
            Client_Sys.Add_To_Attr('<data>',                               '',                                 line_);
               Client_Sys.Add_To_Attr('<identifier>',                      'TEKOD',                            line_);
               Client_Sys.Add_To_Attr('</identifier>',                     '',                                 line_);
               Client_Sys.Add_To_Attr('<value>',                           commodity_,                         line_);
               Client_Sys.Add_To_Attr('</value>',                          '',                                 line_);
            Client_Sys.Add_To_Attr('</data>',                              '',                                 line_);
            Client_Sys.Add_To_Attr('<data>',                               '',                                 line_);
               Client_Sys.Add_To_Attr('<identifier>',                      'UKOD',                             line_);
               Client_Sys.Add_To_Attr('</identifier>',                     '',                                 line_);
               Client_Sys.Add_To_Attr('<value>',                           notc_,                              line_);
               Client_Sys.Add_To_Attr('</value>',                          '',                                 line_);
            Client_Sys.Add_To_Attr('</data>',                              '',                                 line_);
            Client_Sys.Add_To_Attr('<data>',                               '',                                 line_);
               IF (linerec_.intrastat_direction = 'IMPORT') THEN 
                  Client_Sys.Add_To_Attr('<identifier>',                   'FTA',                              line_);
                  Client_Sys.Add_To_Attr('</identifier>',                  '',                                 line_);
               ELSE
                  Client_Sys.Add_To_Attr('<identifier>',                   'RTA',                              line_);
                  Client_Sys.Add_To_Attr('</identifier>',                  '',                                 line_);
               END IF;
                  Client_Sys.Add_To_Attr('<value>',                        country_of_destination_,            line_);
                  Client_Sys.Add_To_Attr('</value>',                       '',                                 line_);
            Client_Sys.Add_To_Attr('</data>',                              '',                                 line_);
            Client_Sys.Add_To_Attr('<data>',                               '',                                 line_);
                  Client_Sys.Add_To_Attr('<identifier>',                   'SZAORSZ',                          line_);
                  Client_Sys.Add_To_Attr('</identifier>',                  '',                                 line_);
                  Client_Sys.Add_To_Attr('<value>',                        country_of_origin_,                 line_);
                  Client_Sys.Add_To_Attr('</value>',                       '',                                 line_);
            Client_Sys.Add_To_Attr('</data>',                              '',                                 line_);
               
            IF(linerec_.intrastat_alt_unit_meas IS NULL)THEN
               Client_Sys.Add_To_Attr('<data>',                            '',                                 line_);
                  Client_Sys.Add_To_Attr('<identifier>',                   'KGM',                              line_);
                  Client_Sys.Add_To_Attr('</identifier>',                  '',                                 line_);
                  IF(net_weight_sum_ = 0)THEN
                     Client_Sys.Add_To_Attr('<value/>',                    '',                                line_);
                  ELSE
                     Client_Sys.Add_To_Attr('<value>',                     net_weight_sum_,                   line_);
                     Client_Sys.Add_To_Attr('</value>',                    '',                                line_);
                  END IF;
               Client_Sys.Add_To_Attr('</data>',                           '',                                line_);
            ELSE   
               Client_Sys.Add_To_Attr('<data>',                            '',                                line_);
                  Client_Sys.Add_To_Attr('<identifier>',                   'KIEGME',                          line_);
                  Client_Sys.Add_To_Attr('</identifier>',                  '',                                line_);
                  IF(sup_units_ = 0)THEN
                     Client_Sys.Add_To_Attr('<value/>',                    '',                                line_);
                  ELSE
                     Client_Sys.Add_To_Attr('<value>',                     sup_units_,                        line_);
                     Client_Sys.Add_To_Attr('</value>',                    '',                                line_);
                  END IF;
               Client_Sys.Add_To_Attr('</data>',                           '',                                line_);   
            END IF;
            
            Client_Sys.Add_To_Attr('<data>',                               '',                                line_);
               Client_Sys.Add_To_Attr('<identifier>',                      'SZAOSSZ',                         line_);
               Client_Sys.Add_To_Attr('</identifier>',                     '',                                line_);
               Client_Sys.Add_To_Attr('<value>',                           invoice_value_,                    line_);
               Client_Sys.Add_To_Attr('</value>',                          '',                                line_);
            Client_Sys.Add_To_Attr('</data>',                              '',                                line_);
            Client_Sys.Add_To_Attr('<data>',                               '',                                line_);
               Client_Sys.Add_To_Attr('<identifier>',                      'STAERT',                          line_);
               Client_Sys.Add_To_Attr('</identifier>',                     '',                                line_);
               Client_Sys.Add_To_Attr('<value>',                           statistical_value_,                line_);
               Client_Sys.Add_To_Attr('</value>',                          '',                                line_);
            Client_Sys.Add_To_Attr('</data>',                              '',                                 line_);
                  IF (linerec_.intrastat_direction = 'EXPORT') THEN 
                     Client_Sys.Add_To_Attr('<data>',                      '',                                 line_);
                     Client_Sys.Add_To_Attr('<identifier>',                'PADO',                             line_);
                     Client_Sys.Add_To_Attr('</identifier>',               '',                                 line_);
                     Client_Sys.Add_To_Attr('<value>',                     partner_tax_id_,                    line_);
                     Client_Sys.Add_To_Attr('</value>',                    '',                                 line_);
                     Client_Sys.Add_To_Attr('</data>',                     '',                                 line_);
                  END IF;

            Create_Line___(output_clob_, line_);
            line_ := '</row>'|| CHR(13) || CHR(10);
            output_clob_ := output_clob_ || line_;
         END IF;
         
         IF(line_count_ = 25 OR pos_id_ = total_rows_) THEN
            dummy_ := TRUE;
            line_ := '</table>' || CHR(13) || CHR(10);
            output_clob_ := output_clob_ || line_;
            line_ := '</chapter>' || CHR(13) || CHR(10);
            output_clob_ := output_clob_ || line_;
            Create_Line___(output_clob_, line_);
            line_count_ := 0;
         END IF;                 
   END LOOP;  
END Create_Details__;

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
    
   line_                    VARCHAR2(32000);  
   address_id_              Company_Address_Pub.address_id%TYPE;
   contact_email_           VARCHAR2(200);
   name_                    VARCHAR2(100);
   addr1_                   VARCHAR2(100);
   city_                    VARCHAR2(35);
   zip_code_                VARCHAR2(35);
   contact_address_id_      VARCHAR2(50);
   contact_city_            VARCHAR2(35);
   contact_phone_           VARCHAR2(200);
   contact_fax_             VARCHAR2(200);
   repr_tax_no_             VARCHAR2(8);
   reg_number_              VARCHAR2(16);
   dec_period_year_         VARCHAR2(4);
   dec_period_month_        VARCHAR2(2);
   trader_vat_no_           VARCHAR2(8);
   vat_no_                  VARCHAR2(50);
   cid_                     NUMBER;   
   intrastat_direction_     VARCHAR2(10);
   notc_dummy_              VARCHAR2(5);
   customs_id_              VARCHAR2(20);  
   executive_name_          VARCHAR2(200);
   executive_status_        VARCHAR2(200);
   executive_phone_         VARCHAR2(200);
   executive_email_         VARCHAR2(200);
   contact_name_            VARCHAR2(200);
   contact_status_          VARCHAR2(200);
   client_version_          VARCHAR2(500);
   begin_date_              VARCHAR2(15);
   end_date_                VARCHAR2(15);
      
   -- Get all the header details
   CURSOR get_head IS
      SELECT company,
             company_contact,
             representative,
             repr_tax_no,
             begin_date,
             end_date,
             customs_id,
             creation_date,
             rep_curr_code,
             rep_curr_rate,
             country_code
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
      AND    country_code = 'HU';      
BEGIN

   IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
       Error_SYS.Record_General(lu_name_, 'NOTBOTH: You can only create an import or export file at the time, not both at the same time');   
   ELSIF (intrastat_export_ = 'EXPORT' AND intrastat_import_ IS NULL) THEN
      intrastat_direction_ := intrastat_export_;
      reg_number_ := 2010;
   ELSIF (intrastat_export_ IS NULL AND intrastat_import_ = 'IMPORT') THEN
      intrastat_direction_ := intrastat_import_;
      reg_number_ := 2012;
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

      IF (SUBSTR(vat_no_, 1, 2) = headrec_.country_code) THEN
         trader_vat_no_ := NVL(RPAD(SUBSTR(vat_no_,3,8),8),LPAD(' ',8));
      ELSE
         trader_vat_no_ := NVL(RPAD(SUBSTR(vat_no_,1,8),8),LPAD(' ',8));
      END IF;

      customs_id_    := headrec_.customs_id;
      begin_date_             := to_char(headrec_.begin_date,'MM');
      end_date_               := to_char(headrec_.end_date,'MM');
      
      IF(begin_date_ != end_date_ )THEN
        Error_SYS.Record_General(lu_name_, 'WRONGPERIOD: The time scale for this Intrastat covers more than one month. It is only allowed to submit Intrastat for one month',intrastat_id_);   
      END IF;
      IF customs_id_ IS NULL THEN
       Error_SYS.Record_General(lu_name_, 'NOCUSTOMSID: Customs ID is missing for Intrastat ID :P1.',intrastat_id_);    
      END IF;
      
      --Company address
      address_id_ := Company_Address_API.Get_Default_Address(headrec_.company, Address_Type_Code_API.Decode('INVOICE'));
      IF address_id_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOCOMPADDR: There is no default invoice address for the company!');
      END IF;
      name_       := Company_API.Get_Name(headrec_.company);
      addr1_      := Company_Address_API.Get_Address1(headrec_.company, address_id_);
      city_       := Company_Address_API.Get_City(headrec_.company, address_id_);
      zip_code_   := Company_Address_API.Get_Zip_Code(headrec_.company, address_id_);
      IF name_ IS NULL OR addr1_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'INCOMADDR: Company address is incomplete!');
      END IF;

      --Company contact
      contact_name_        := Person_Info_Api.Get_Name(headrec_.company_contact);
      contact_status_      := Comm_Method_API.Get_Description(Party_Type_API.Decode('PERSON'), headrec_.company_contact, 
                                  Comm_Method_API.Get_Comm_Id_By_Method(headrec_.company_contact, 'PHONE', 
                                  Comm_Method_API.Get_Default_Value('PERSON', headrec_.company_contact, 'PHONE')));
      contact_phone_       := Comm_Method_API.Get_Default_Value('PERSON', headrec_.company_contact, 'PHONE');
      contact_email_       := Comm_Method_API.Get_Default_Value('PERSON', headrec_.company_contact, 'E_MAIL');  

      contact_address_id_  := Person_Info_Address_API.Get_Default_Address(headrec_.company_contact, Address_Type_Code_API.Decode('VISIT'));
      contact_city_        := Person_Info_Address_API.Get_City(headrec_.company_contact, contact_address_id_);
      contact_fax_         := Comm_Method_API.Get_Default_Value('PERSON', headrec_.company_contact, 'FAX');
         
      --Executive details
      executive_name_      := Person_Info_Api.Get_Name(headrec_.representative);
      executive_status_    := Comm_Method_API.Get_Description(Party_Type_API.Decode('PERSON'), headrec_.representative, 
                                  Comm_Method_API.Get_Comm_Id_By_Method(headrec_.representative, 'PHONE', 
                                  Comm_Method_API.Get_Default_Value('PERSON', headrec_.representative, 'PHONE')));
      executive_phone_     := Comm_Method_API.Get_Default_Value('PERSON', headrec_.representative, 'PHONE');
      executive_email_     := Comm_Method_API.Get_Default_Value('PERSON', headrec_.representative, 'E_MAIL');

      IF headrec_.representative IS NOT NULL THEN
         IF (SUBSTR(headrec_.country_code, 1, 2) = 'HU') AND (headrec_.repr_tax_no IS NOT NULL) THEN
            repr_tax_no_ := SUBSTR(headrec_.repr_tax_no,1,8);
         ELSE 
            repr_tax_no_ := trader_vat_no_;
         END IF;    
      END IF;

      IF ( headrec_.rep_curr_code NOT IN ('HUF','EUR')) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCURRHUF: Currency Code :P1 is not a valid currency, only HUF and EUR is acceptable', headrec_.rep_curr_code); 
      END IF;

      client_version_         := Database_SYS.Unistr('A bevall\00E1s az IFS Applications v\00E1llalatir\00E1ny\00EDt\00E1si szoftverrel k\00E9sz\00FClt.');
      dec_period_year_        := to_char(headrec_.begin_date, 'YY');
      dec_period_month_       := to_char(headrec_.begin_date, 'MM');
      
      -- Constructing the XML header
      line_ := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'|| CHR(13) || CHR(10);
      output_clob_ := line_;

      line_ := '<form xmlns="http://iform-html.kdiv.hu/schemas/form">' || CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
      
      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('<templateKeys>',  '',               line_);
      Client_SYS.Add_To_Attr('<element>',       '',               line_);
      Client_SYS.Add_To_Attr('<name>',          'mc01',           line_);
      Client_SYS.Add_To_Attr('</name>',         '',               line_);
      Client_SYS.Add_To_Attr('<value>',         reg_number_,      line_);
      Client_SYS.Add_To_Attr('</value>',        '',               line_);
      Client_SYS.Add_To_Attr('</element>',      '',               line_);
      Client_SYS.Add_To_Attr('<element>',       '',               line_);
      Client_SYS.Add_To_Attr('<name>',          'mev',            line_);
      Client_SYS.Add_To_Attr('</name>',         '',               line_);
      Client_SYS.Add_To_Attr('<value>',         dec_period_year_, line_);
      Client_SYS.Add_To_Attr('</value>',        '',               line_);
      Client_SYS.Add_To_Attr('</element>',      '',               line_);
      Client_SYS.Add_To_Attr('</templateKeys>', '',               line_);
      Create_Line___(output_clob_, line_);

      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('<chapter s="P">',                    '',                             line_);
      Client_Sys.Add_To_Attr('<identifier>',                       '0',                            line_);
      Client_Sys.Add_To_Attr('</identifier>',                      '',                             line_);
      Client_Sys.Add_To_Attr('<order>',                            '1',                            line_);
      Client_Sys.Add_To_Attr('</order>',                           '',                             line_);
      Client_Sys.Add_To_Attr('<data s="P">',                       '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'MC01',                         line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          reg_number_,                    line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data s="P">',                       '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'M003_G',                       line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          trader_vat_no_,                 line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data>',                             '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'JHNEV',                        line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          executive_name_,                line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data>',                             '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'JBEOSZTAS',                    line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          executive_status_,              line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data>',                             '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'JTELEFON',                     line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          executive_phone_,               line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data>',                             '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'JEMAIL',                       line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          executive_email_,               line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data>',                             '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'KNEV',                         line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          contact_name_,                  line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data>',                             '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'KBEOSZTAS',                    line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          contact_status_,                line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data>',                             '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'KTELEFON',                     line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          contact_phone_,                 line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data>',                             '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'KEMAIL',                       line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          contact_email_,                 line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data>',                             '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'MEGJEGYZES',                   line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          client_version_,                line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data>',                             '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'VGEA002',                      line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          '30',                           line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data s="P">',                       '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'MHO',                          line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          dec_period_month_,              line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data s="P">',                       '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'MEV',                          line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          dec_period_year_,               line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('<data s="P">',                       '',                             line_);
        Client_Sys.Add_To_Attr('<identifier>',                     'M003',                         line_);
        Client_Sys.Add_To_Attr('</identifier>',                    '',                             line_);
        Client_Sys.Add_To_Attr('<value>',                          trader_vat_no_,                 line_);
        Client_Sys.Add_To_Attr('</value>',                         '',                             line_);
      Client_Sys.Add_To_Attr('</data>',                            '',                             line_);
      Client_Sys.Add_To_Attr('</chapter>',                         '',                             line_);
      
      Create_Line___(output_clob_, line_);
      Create_Details__(output_clob_,
                       intrastat_id_,
                       intrastat_direction_,
                       headrec_.rep_curr_rate,
                       headrec_.country_code);
   END LOOP ;
   
   Client_SYS.Clear_Attr(line_);
   Client_Sys.Add_To_Attr('</form>', '', line_);
      
   Create_Line___(output_clob_, line_); 
           
   info_ := Client_SYS.Get_All_Info; 
   

EXCEPTION
  WHEN OTHERS THEN
      IF (dbms_sql.is_open (cid_)) THEN
         dbms_sql.close_cursor (cid_);
      END IF;
      RAISE;   
      
info_ := Client_SYS.Get_All_Info;

END Create_Output;



