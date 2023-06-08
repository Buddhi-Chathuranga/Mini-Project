-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatRoFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220125  ErFelk  Bug 162141(SCZ-17448), Modified Create_Details__() by switching the values of SupplUnitCode tag and QtyInSupplUnits tag.
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  151111  PrYaLK  PrYaLK  Bug 121643, Added new field PartnerVatNr.
--  150721  PrYaLK  Bug 123199, Modified Create_Details__ method to exclude the invoiced value of CO-PURSHIP transaction since it should be 0.
--  150519  ShKolk  Bug 121489, Modified Create_Details__ method to exclude the invoiced value of PURSHIP transaction since it should be 0.
--  131022  Hiralk  CAHOOK-2182, Replaced Person_Info_Comm_Method_API with Comm_Method_API.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130731  MaIklk  TIBE-856, Removed inst_CompanyInvoiceInfo_ global constant and used conditional compilation instead.
--  121010  TiRalk  Bug 101052, Created
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
   line_                 VARCHAR2(32000);   
   pos_id_               NUMBER := 0;
   direction_lines_      NUMBER := 0;
   notc_a_               VARCHAR2(2);
   notc_b_               VARCHAR2(3);
   alt_quantity_         NUMBER;

   CURSOR get_lines IS
      SELECT il.intrastat_direction,
             il.opposite_country,
             DECODE (intrastat_direction_, 'IMPORT', il.country_of_origin, '')                     country_of_origin,
             cn.country_notc,
             il.mode_of_transport,
             SUBSTR(REPLACE(il.customs_stat_no,' '),1,8)                                           customs_stat_no,
             il.delivery_terms,
             il.intrastat_alt_unit_meas,
             SUM (il.quantity * il.net_unit_weight)                                                net_weight_sum,
             SUM (NVL(ABS(il.intrastat_alt_qty),0) * il.quantity)                                  intrastat_alt_qty_sum,
             SUM (il.quantity * NVL(il.invoiced_unit_price, DECODE(il.transaction, 'PURSHIP',    0, 
                                                                                   'CO-PURSHIP', 0, il.order_unit_price))) * rep_curr_rate_
                                                                                                   invoiced_amount,
             SUM ((NVL(il.invoiced_unit_price,NVL(il.order_unit_price,0)) +
                 NVL(il.unit_add_cost_amount_inv,NVL(il.unit_add_cost_amount,0)) +
                 NVL(il.unit_charge_amount_inv,0) +
                 NVL(il.unit_charge_amount,0)) * quantity) * rep_curr_rate_                        statistical_value,
             opponent_tax_id
      FROM   intrastat_line_tab il, country_notc_tab cn
      WHERE  il.intrastat_id        = intrastat_id_
      AND    il.intrastat_direction = intrastat_direction_
      AND    il.rowstate            = 'Released'
      AND    il.notc                = cn.notc
      AND    cn.country_code        = country_code_
      GROUP BY il.intrastat_direction,
               il.opposite_country,
               cn.country_notc,
               il.mode_of_transport,
               SUBSTR(REPLACE(il.customs_stat_no,' '),1,8),
               il.delivery_terms,
               il.intrastat_alt_unit_meas,
               DECODE (intrastat_direction_, 'IMPORT', il.country_of_origin, ''),
               opponent_tax_id;

    CURSOR get_no_lines IS
      SELECT count(*) no_rows
      FROM   intrastat_line_tab
      WHERE  intrastat_id        = intrastat_id_
      AND    intrastat_direction = intrastat_direction_;
   
BEGIN
   --Fetch no of lines for this direction
   OPEN get_no_lines;
   FETCH get_no_lines INTO direction_lines_;
   CLOSE get_no_lines;

   IF direction_lines_ = 0 THEN
      Error_SYS.Record_General(lu_name_, 'NORECORDS: Files with no items are not allowed to be created.');
   END IF;

   pos_id_ := 0;
   FOR linerec_ IN get_lines LOOP
      pos_id_ := pos_id_ + 1;

      IF linerec_.customs_stat_no IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOCUSTSTAT: Customs statistics number is missing for some lines.');
      END IF;
      
      IF linerec_.delivery_terms IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NODELTERMS: Delivery term is missing for some lines.');
      ELSIF (linerec_.delivery_terms NOT IN ('EXW', 'FCA', 'FAS', 'FOB', 'CFR', 'CIF', 'CPT', 'CIP', 'DAT', 'DDP')) THEN
         linerec_.delivery_terms    := 'XXX';
      END IF;

      IF linerec_.mode_of_transport IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOMODETRANS: Mode of transport is missing for some lines.');
      END IF;

      IF intrastat_direction_ = 'IMPORT' THEN
         line_ := '<InsArrivalItem OrderNr="' || pos_id_ || '">'|| CHR(13) || CHR(10);
      ELSE
         line_ := '<InsDispatchItem OrderNr="' || pos_id_ || '">'|| CHR(13) || CHR(10);
      END IF;

      IF ((linerec_.opponent_tax_id IS NULL) AND (intrastat_direction_ = 'EXPORT')) THEN
         Error_SYS.Record_General(lu_name_, 'NOOPPONENTTAXID: Opponent tax ID is missing in some export lines and is required for Intrastat export report.');
      END IF;

      output_clob_ := output_clob_ || line_;

      notc_a_ := SUBSTR(linerec_.country_notc, -2, 1);
      IF notc_a_ IS NULL THEN
         notc_a_ := linerec_.country_notc;
         notc_b_ := NULL;
      ELSE
         notc_b_ := SUBSTR(linerec_.country_notc, -1, 1);
         notc_b_ := notc_a_ || '.' || notc_b_;
      END IF;

      IF linerec_.intrastat_alt_qty_sum < 1 AND linerec_.intrastat_alt_qty_sum > 0  THEN
         alt_quantity_ := 1;
      ELSE
         alt_quantity_ := ROUND(linerec_.intrastat_alt_qty_sum);
      END IF;

      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('<Cn8Code>',                                 linerec_.customs_stat_no,              line_);
      Client_SYS.Add_To_Attr('</Cn8Code>',                                '',                                    line_);
      Client_SYS.Add_To_Attr('<InvoiceValue>',                            CEIL(linerec_.invoiced_amount),        line_);
      Client_SYS.Add_To_Attr('</InvoiceValue>',                           '',                                    line_);
      Client_SYS.Add_To_Attr('<StatisticalValue>',                        CEIL(linerec_.statistical_value),      line_);
      Client_SYS.Add_To_Attr('</StatisticalValue>',                       '',                                    line_);
      Client_SYS.Add_To_Attr('<NetMass>',                                 ROUND(linerec_.net_weight_sum),        line_);
      Client_SYS.Add_To_Attr('</NetMass>',                                '',                                    line_);
      Client_SYS.Add_To_Attr('<NatureOfTransactionACode>',                notc_a_,                               line_);
      Client_SYS.Add_To_Attr('</NatureOfTransactionACode>',               '',                                    line_);
      IF notc_b_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('<NatureOfTransactionBCode>',             notc_b_,                               line_);
         Client_SYS.Add_To_Attr('</NatureOfTransactionBCode>',            '',                                    line_);
      END IF;
      Client_SYS.Add_To_Attr('<DeliveryTermsCode>',                       linerec_.delivery_terms,               line_);
      Client_SYS.Add_To_Attr('</DeliveryTermsCode>',                      '',                                    line_);
      Client_SYS.Add_To_Attr('<ModeOfTransportCode>',                     linerec_.mode_of_transport,            line_);
      Client_SYS.Add_To_Attr('</ModeOfTransportCode>',                    '',                                    line_);      
      IF alt_quantity_ != 0 THEN
         Client_SYS.Add_To_Attr('<InsSupplUnitsInfo>',                    '',                                    line_);
         Client_SYS.Add_To_Attr('<SupplUnitCode>',                        linerec_.intrastat_alt_unit_meas,      line_);
         Client_SYS.Add_To_Attr('</SupplUnitCode>',                       '',                                    line_);
         Client_SYS.Add_To_Attr('<QtyInSupplUnits>',                      alt_quantity_,                         line_);
         Client_SYS.Add_To_Attr('</QtyInSupplUnits>',                     '',                                    line_);
         Client_SYS.Add_To_Attr('</InsSupplUnitsInfo>',                   '',                                    line_);
      END IF;
      IF intrastat_direction_ = 'IMPORT' THEN
         Client_SYS.Add_To_Attr('<CountryOfOrigin>',                      linerec_.country_of_origin,            line_);
         Client_SYS.Add_To_Attr('</CountryOfOrigin>',                     '',                                    line_);
         Client_SYS.Add_To_Attr('<CountryOfConsignment>',                 linerec_.opposite_country,             line_);
         Client_SYS.Add_To_Attr('</CountryOfConsignment>',                '',                                    line_);
      ELSE
         Client_SYS.Add_To_Attr('<PartnerVatNr>',                         linerec_.opponent_tax_id,              line_);
         Client_SYS.Add_To_Attr('</PartnerVatNr>',                        '',                                    line_);
         Client_SYS.Add_To_Attr('<CountryOfDestination>',                 linerec_.opposite_country,             line_);
         Client_SYS.Add_To_Attr('</CountryOfDestination>',                '',                                    line_);
      END IF;
             
      Create_Line___(output_clob_, line_);
      
      IF intrastat_direction_ = 'IMPORT' THEN
         line_ := '</InsArrivalItem>'|| CHR(13) || CHR(10);
      ELSE
         line_ := '</InsDispatchItem>'|| CHR(13) || CHR(10);
      END IF;
      output_clob_ := output_clob_ || line_;
   END LOOP;

END Create_Details__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2, 
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,
   intrastat_id_     IN  NUMBER,
   intrastat_export_ IN  VARCHAR2,
   intrastat_import_ IN  VARCHAR2 )
IS
  
   line_                      VARCHAR2(2000);
   intrastat_direction_       VARCHAR2(10);
   notc_dummy_                VARCHAR2(2);
   vat_no_                    VARCHAR2(50);
   company_name_              VARCHAR2(100);
   ref_period_                VARCHAR2(20);
   person_last_name_          VARCHAR2(100);
   person_first_name_         VARCHAR2(100);
   person_phone_              VARCHAR2(200);
   person_fax_                VARCHAR2(200);
   person_email_              VARCHAR2(200);
   country_of_origin_dummy_   NUMBER;  

   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'RO';

    CURSOR check_country_of_origin IS
      SELECT 1
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction = 'IMPORT'
      AND    rowstate = 'Released'
      AND    country_of_origin IS NULL;
   
   CURSOR get_head IS
      SELECT company,
             creation_date,
             company_contact,
             rep_curr_code,
             rep_curr_rate,
             country_code,
             end_date,
             begin_date
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;
   
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

   -- Check for country_of_origin when intrastat_direction_ = 'IMPORT' .
   IF (intrastat_direction_ = 'IMPORT') THEN
      OPEN check_country_of_origin;
      FETCH check_country_of_origin INTO country_of_origin_dummy_;
      IF (check_country_of_origin%FOUND) THEN
         CLOSE check_country_of_origin;
         Error_SYS.Record_General(lu_name_, 'NOCOUNTRYOFORIGIN: Country of Origin is mandatory for import lines. Values are missing for some import lines.');
      END IF;
      CLOSE check_country_of_origin;
   END IF;

   -- Check for opposite country when intrastat_direction_ = 'EXPORT' .
   IF (intrastat_direction_ = 'EXPORT') THEN
      OPEN check_country_of_origin;
      FETCH check_country_of_origin INTO country_of_origin_dummy_;
      IF (check_country_of_origin%FOUND) THEN
         CLOSE check_country_of_origin;
         Error_SYS.Record_General(lu_name_, 'NOOPPOSITECOUNTRY: Opposite country is mandatory for export lines. Values are missing for some export lines.');
      END IF;
      CLOSE check_country_of_origin;
   END IF;

   -- Head blocks
   FOR headrec_ IN get_head LOOP
      -- check currency
      IF (headrec_.rep_curr_code NOT IN ('RON')) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCURR: Reporting currency should be RON.');
      END IF;
      
      $IF (Component_Invoic_SYS.INSTALLED) $THEN
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, Company_API.Get_Country_Db(headrec_.company), TRUNC(SYSDATE));
      $END

      IF vat_no_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOCOMPVATNO: TAX number is missing for company :P1.',headrec_.company);
      END IF;

      -- Company address
      company_name_ := Company_API.Get_Name(headrec_.company);
      ref_period_ := TO_CHAR(headrec_.end_date,'YYYY')||'-'||TO_CHAR(headrec_.end_date,'MM');
      IF headrec_.company_contact IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOPERSON: Company contact is missing for company :P1.', headrec_.company);
      ELSE
         person_last_name_ := Person_Info_API.Get_Last_Name(headrec_.company_contact);
         person_first_name_ := Person_Info_API.Get_First_Name(headrec_.company_contact);
         person_email_ := Comm_Method_API.Get_Default_Value('PERSON', headrec_.company_contact, 'E_MAIL', NULL, headrec_.creation_date);
         person_phone_ := Comm_Method_API.Get_Default_Value('PERSON', headrec_.company_contact, 'PHONE', NULL, headrec_.creation_date);
         IF person_phone_ IS NULL THEN
            Error_SYS.Record_General(lu_name_, 'NOCONTACTPHONE: Phone number is missing for company contact :P1.', headrec_.company_contact);
         END IF;
         person_fax_ := Comm_Method_API.Get_Default_Value('PERSON', headrec_.company_contact, 'FAX', NULL, headrec_.creation_date);
      END IF;

      -- Creation of the XML part
      line_ := '<?xml version="1.0" encoding="UTF-8" ?>'|| chr(13) || chr(10);
      output_clob_ := line_;
      
      IF intrastat_direction_ = 'IMPORT' THEN
         line_ := '<InsNewArrival SchemaVersion="1.0" xmlns="http://www.intrastat.ro/xml/InsSchema">'|| chr(13) || chr(10);
      ELSE
         line_ := '<InsNewDispatch SchemaVersion="1.0" xmlns="http://www.intrastat.ro/xml/InsSchema">'|| chr(13) || chr(10);
      END IF;
      output_clob_ := output_clob_ || line_;

      line_ := '<InsDeclarationHeader>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
      
      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('<VatNr>',                     vat_no_,                            line_);
      Client_SYS.Add_To_Attr('</VatNr>',                    '',                                 line_);
      Client_SYS.Add_To_Attr('<FirmName>',                  company_name_,                      line_);
      Client_SYS.Add_To_Attr('</FirmName>',                 '',                                 line_);
      Client_SYS.Add_To_Attr('<RefPeriod>',                 ref_period_,                        line_);
      Client_SYS.Add_To_Attr('</RefPeriod>',                '',                                 line_);
      Client_SYS.Add_To_Attr('<CreateDt>',                  headrec_.creation_date,             line_);
      Client_SYS.Add_To_Attr('</CreateDt>',                 '',                                 line_);
      
      IF headrec_.company_contact IS NOT NULL THEN
         Client_SYS.Add_To_Attr('<ContactPerson>',          '',                                 line_);
         Client_SYS.Add_To_Attr('<LastName>',               person_last_name_,                  line_);
         Client_SYS.Add_To_Attr('</LastName>',              '',                                 line_);
         Client_SYS.Add_To_Attr('<FirstName>',              person_first_name_,                 line_);
         Client_SYS.Add_To_Attr('</FirstName>',             '',                                 line_);
         IF person_email_ IS NOT NULL THEN
            Client_SYS.Add_To_Attr('<Email>',               person_email_,                      line_);
            Client_SYS.Add_To_Attr('</Email>',              '',                                 line_);
         END IF;
         IF person_email_ IS NOT NULL THEN
            Client_SYS.Add_To_Attr('<Phone>',               person_phone_,                      line_);
            Client_SYS.Add_To_Attr('</Phone>',              '',                                 line_);
         END IF;
         IF person_fax_ IS NOT NULL THEN
            Client_SYS.Add_To_Attr('<Fax>',                 person_fax_,                        line_);
            Client_SYS.Add_To_Attr('</Fax>',                '',                                 line_);
         END IF;
         Client_SYS.Add_To_Attr('</ContactPerson>',         '',                                 line_);
      END IF; 
      
      Create_Line___(output_clob_, line_);
      line_ := '</InsDeclarationHeader>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
      
      Create_Details__(output_clob_,
                       intrastat_id_,
                       intrastat_direction_,
                       headrec_.rep_curr_rate,
                       headrec_.country_code);
      
      IF intrastat_direction_ = 'IMPORT' THEN
         line_ := '  </InsNewArrival>'|| CHR(13) || CHR(10);
      ELSE
         line_ := '  </InsNewDispatch>'|| CHR(13) || CHR(10);
      END IF;

      output_clob_ := output_clob_ || line_;
      --End XML Header part
   END LOOP;   -- head loop
   
   info_ := Client_SYS.Get_All_Info;   
   
END Create_Output;



