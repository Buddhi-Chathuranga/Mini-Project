-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatSiFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171228  NiLalk  Bug 139519, Modified Create_Output() method by concatenating output_clob_ variable with line_ variable to construct the 
--  171228          starting tag of the xml with xml version and namespace declaration.
--  160118  PrYaLK  Bug 126656, Removed DelTermsLocation and replaced PlaceOfDelivery by locationCode in intrastat export file.
--  151026  PrYaLK  Bug 124575, Added new fields DelTermsLocation and PlaceOfDelivery.
--  151014  PrYaLK  Bug 124353, Modified the cursor get_lines to include the charges for invoiced_amount.
--  150727  PrYaLK  Bug 121011, Created.
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
   notc_a_               VARCHAR2(2);
   notc_b_               VARCHAR2(3);
   alt_quantity_         NUMBER;
   net_mass_             NUMBER;

   CURSOR get_lines IS
      SELECT il.intrastat_direction,
             il.opposite_country,
             DECODE (intrastat_direction_, 'IMPORT', il.country_of_origin, '')                    country_of_origin,
             cn.country_notc,
             il.mode_of_transport,
             SUBSTR(REPLACE(il.customs_stat_no,' '),1,8)                                          cn8_code,
             il.delivery_terms,
             il.intrastat_alt_unit_meas,
             SUM (il.quantity * il.net_unit_weight)                                               net_weight_sum,
             SUM (NVL(ABS(il.intrastat_alt_qty),0) * il.quantity)                                 intrastat_alt_qty_sum,
             SUM ((NVL(il.invoiced_unit_price,il.order_unit_price) +
                   NVL(il.unit_charge_amount_inv,0) +
                   NVL(il.unit_charge_amount,0)) * il.quantity) * rep_curr_rate_                  invoiced_amount,
             SUM ((NVL(il.invoiced_unit_price,NVL(il.order_unit_price,0)) +
               NVL(il.unit_add_cost_amount_inv,NVL(il.unit_add_cost_amount,0)) +
               NVL(il.unit_charge_amount_inv,0) +
               NVL(il.unit_charge_amount,0)) * quantity) * rep_curr_rate_                         statistical_value,
             del_terms_location,
             place_of_delivery
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
               del_terms_location,
               place_of_delivery;

BEGIN   

   pos_id_ := 0;
   FOR linerec_ IN get_lines LOOP
      pos_id_ := pos_id_ + 1;

      IF linerec_.cn8_code IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOCUSTSTAT: Customs statistics number is missing for some lines.');
      END IF;
      
      IF linerec_.delivery_terms IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NODELTERMS: Delivery term is missing for some lines.');
      ELSIF (linerec_.delivery_terms NOT IN ('EXW', 'FCA', 'FAS', 'FOB', 'CFR', 'CIF', 'CPT', 'CIP', 'DAF', 'DAP', 'DAT', 'DES', 'DEQ', 'DDU', 'DDP')) THEN
         linerec_.delivery_terms    := 'XXX';
      END IF;

      IF linerec_.mode_of_transport IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOMODETRANS: Mode of transport is missing for some lines.');
      END IF;

      IF linerec_.place_of_delivery IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOPLACEOFDEL: Place of delivery is missing for some lines.');
      END IF;

      line_ := '<Item>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;

      notc_a_ := SUBSTR(linerec_.country_notc, -2, 1);
      notc_b_ := SUBSTR(linerec_.country_notc, -1, 1);

      IF linerec_.intrastat_alt_qty_sum < 0.001 AND linerec_.intrastat_alt_qty_sum > 0  THEN
         alt_quantity_ := 0.001;
      ELSE
         alt_quantity_ := ROUND(linerec_.intrastat_alt_qty_sum, 3);
      END IF;
      IF linerec_.net_weight_sum < 0.001 AND linerec_.net_weight_sum > 0  THEN
         net_mass_ := 0.001;
      ELSE
         net_mass_ := ROUND(linerec_.net_weight_sum, 3);
      END IF;

      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('<itemNumber>',                   pos_id_,                                     line_);
      Client_SYS.Add_To_Attr('</itemNumber>',                  '',                                          line_);
      Client_SYS.Add_To_Attr('<CN8>',                          '',                                          line_);
         Client_SYS.Add_To_Attr('<CN8Code>',                   linerec_.cn8_code,                           line_);
         Client_SYS.Add_To_Attr('</CN8Code>',                  '',                                          line_);
      Client_SYS.Add_To_Attr('</CN8>',                         '',                                          line_);
      Client_SYS.Add_To_Attr('<MSConsDestCode>',               linerec_.opposite_country,                   line_);
      Client_SYS.Add_To_Attr('</MSConsDestCode>',              '',                                          line_);
      IF linerec_.country_of_origin IS NOT NULL THEN
         Client_SYS.Add_To_Attr('<countryOfOriginCode>',       linerec_.country_of_origin,                  line_);
         Client_SYS.Add_To_Attr('</countryOfOriginCode>',      '',                                          line_);
      ELSE
         Client_SYS.Add_To_Attr('<countryOfOriginCode/>',      '',                                          line_);
      END IF;
      IF net_mass_ < 1 THEN
         Client_SYS.Add_To_Attr('<netMass>',                   To_Char(net_mass_ ,'0.000'),                 line_);
         Client_SYS.Add_To_Attr('</netMass>',                  '',                                          line_);
      ELSE
         Client_SYS.Add_To_Attr('<netMass>',                   net_mass_ ,                                  line_);
         Client_SYS.Add_To_Attr('</netMass>',                  '',                                          line_);
      END IF;
      IF (alt_quantity_ != 0) THEN
         Client_SYS.Add_To_Attr('<quantityInSU>',              alt_quantity_,                               line_);
         Client_SYS.Add_To_Attr('</quantityInSU>',             '',                                          line_);
      ELSE
         Client_SYS.Add_To_Attr('<quantityInSU/>',             '',                                          line_);
      END IF;
      Client_SYS.Add_To_Attr('<invoicedAmount>',               (CEIL(linerec_.invoiced_amount*100)/100),    line_);
      Client_SYS.Add_To_Attr('</invoicedAmount>',              '',                                          line_);
      Client_SYS.Add_To_Attr('<statisticalValue>',             (CEIL(linerec_.statistical_value*100)/100),  line_);
      Client_SYS.Add_To_Attr('</statisticalValue>',            '',                                          line_);
      Client_SYS.Add_To_Attr('<NatureOfTransaction>',          '',                                          line_);
         Client_SYS.Add_To_Attr('<natureOfTransactionACode>',  notc_a_,                                     line_);
         Client_SYS.Add_To_Attr('</natureOfTransactionACode>', '',                                          line_);
         Client_SYS.Add_To_Attr('<natureOfTransactionBCode>',  notc_b_,                                     line_);
         Client_SYS.Add_To_Attr('</natureOfTransactionBCode>', '',                                          line_);
      Client_SYS.Add_To_Attr('</NatureOfTransaction>',         '',                                          line_);
      Client_SYS.Add_To_Attr('<modeOfTransportCode>',          linerec_.mode_of_transport,                  line_);
      Client_SYS.Add_To_Attr('</modeOfTransportCode>',         '',                                          line_);
      Client_SYS.Add_To_Attr('<regionCode/>',                  '',                                          line_);
      Client_SYS.Add_To_Attr('<portAirportInlandportCode/>',   '',                                          line_);
      Client_SYS.Add_To_Attr('<DeliveryTerms>',                '',                                          line_);
         Client_SYS.Add_To_Attr('<TODCode>',                   linerec_.delivery_terms,                     line_);
         Client_SYS.Add_To_Attr('</TODCode>',                  '',                                          line_);
         Client_SYS.Add_To_Attr('<locationCode>',              linerec_.place_of_delivery,                  line_);
         Client_SYS.Add_To_Attr('</locationCode>',             '',                                          line_);
      Client_SYS.Add_To_Attr('</DeliveryTerms>',               '',                                          line_);

      Create_Line___(output_clob_, line_);

      line_ := '</Item>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
   END LOOP;
   Client_SYS.Clear_Attr(line_);
   Client_SYS.Add_To_Attr('<totalNumberLines>',                pos_id_,                                     line_);
   Client_SYS.Add_To_Attr('</totalNumberLines>',               '',                                          line_);
   Create_Line___(output_clob_, line_);

END Create_Details__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Output
--   Method fetches the intrastat data and formats it according to
--   specifications for Slovenia.
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
   declaration_id_            NUMBER;
   psi_id_                    VARCHAR2(15);
   ref_period_                VARCHAR2(20);
   flow_code_                 VARCHAR2(5);
   vat_no_                    VARCHAR2(15);
   function_code_             VARCHAR2(5);
   intrastat_direction_       VARCHAR2(10);
   line_existsdummy_          NUMBER;
   notc_dummy_                VARCHAR2(2);
   country_of_origin_dummy_   NUMBER;   
   count_                     NUMBER;
   first_last_                VARCHAR2(5) := '1';
   curr_date_                 DATE;

   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;

   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'SI';

    CURSOR check_country_of_origin IS
      SELECT 1
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction = 'IMPORT'
      AND    rowstate = 'Released'
      AND    country_of_origin IS NULL;

    CURSOR check_opposite_country IS
      SELECT 1
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction IN ('EXPORT', 'IMPORT')
      AND    rowstate = 'Released'
      AND    opposite_country IS NULL;

   CURSOR get_head IS
      SELECT company,
             rep_curr_code,
             rep_curr_rate,
             country_code,
             end_date,
             dec_number_export,
             dec_number_import
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;

   CURSOR line_exists(country_code_ VARCHAR2) IS
      SELECT 1
      FROM   intrastat_line_tab il, country_notc_tab cn
      WHERE  il.intrastat_id        = intrastat_id_
      AND    il.intrastat_direction = intrastat_direction_
      AND    il.rowstate            = 'Released'
      AND    il.notc                = cn.notc
      AND    cn.country_code        = country_code_;
BEGIN

   IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
      count_ := 2;
   ELSIF (intrastat_export_ = 'EXPORT' AND intrastat_import_ IS NULL) THEN
      intrastat_direction_ := intrastat_export_;
      count_ := 1;
   ELSIF (intrastat_export_ IS NULL AND intrastat_import_ = 'IMPORT') THEN
      intrastat_direction_ := intrastat_import_;
      count_ := 1;
   ELSE -- both is null
      Error_SYS.Record_General(lu_name_, 'DIRECTIONSNULL: One transfer option must be checked.');
   END IF;
   curr_date_ := Sysdate;

   $IF (Component_Invoic_SYS.INSTALLED) $THEN
      vat_no_ := SUBSTR(Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(Intrastat_API.Get_Company(intrastat_id_), 'SI', TRUNC(SYSDATE)), 0, 10);
   $END

   IF vat_no_ IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'NOCOMPVATNO: TAX number is missing for company :P1.',Intrastat_API.Get_Company(intrastat_id_));
   END IF;

   -- Creation of the XML part
   line_ := '<?xml version="1.0" encoding="UTF-8" ?>'|| chr(13) || chr(10);
   output_clob_ := line_;

   line_ := '<INSTAT xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ';
   output_clob_ := output_clob_ || line_;
   line_ := 'xsi:noNamespaceSchemaLocation="http://intrastat-surs.gov.si/xml/schema/INSTAT62-SI.xsd">'|| chr(13) || chr(10);
   output_clob_ := output_clob_ || line_;

   Client_SYS.Clear_Attr(line_);
   Client_SYS.Add_To_Attr('<Envelope>',         '',                                 line_);
   Client_SYS.Add_To_Attr('<envelopeId>',       intrastat_id_,                      line_);
   Client_SYS.Add_To_Attr('</envelopeId>',      '',                                 line_);
   Client_SYS.Add_To_Attr('<DateTime>',         '',                                 line_);
      Client_SYS.Add_To_Attr('<date>',          TO_CHAR(curr_date_,'YYYY')||'-'||TO_CHAR(curr_date_,'MM')||'-'||TO_CHAR(curr_date_,'DD'),                            line_);
      Client_SYS.Add_To_Attr('</date>',         '',                                 line_);
      Client_SYS.Add_To_Attr('<time>',          TO_CHAR(curr_date_,'HH')||':'||TO_CHAR(curr_date_,'MI')||':'||TO_CHAR(curr_date_,'SS'),                            line_);
      Client_SYS.Add_To_Attr('</time>',         '',                                 line_);
   Client_SYS.Add_To_Attr('</DateTime>',        '',                                 line_);
   Client_SYS.Add_To_Attr('<Party partyType="PSI" partyRole="sender">', '',         line_);
      Client_SYS.Add_To_Attr('<partyId>',       vat_no_||'    000',                 line_);
      Client_SYS.Add_To_Attr('</partyId>',      '',                                 line_);
      Client_SYS.Add_To_Attr('<partyName>',     Company_API.Get_Name(Intrastat_API.Get_Company(intrastat_id_)), line_);
      Client_SYS.Add_To_Attr('</partyName>',    '',                                 line_);
   Client_SYS.Add_To_Attr('</Party>',           '',                                 line_);
   Client_SYS.Add_To_Attr('<Party partyType="CC" partyRole="receiver">', '',        line_);
      Client_SYS.Add_To_Attr('<partyId>',       'SI47730811    000',                 line_);
      Client_SYS.Add_To_Attr('</partyId>',      '',                                 line_);
      Client_SYS.Add_To_Attr('<partyName>',     'Customs Office of Nova Gorica',    line_);
      Client_SYS.Add_To_Attr('</partyName>',    '',                                 line_);
   Client_SYS.Add_To_Attr('</Party>',           '',                                 line_);
   Client_SYS.Add_To_Attr('<softwareUsed>',     'IFS Applications',                 line_);
   Client_SYS.Add_To_Attr('</softwareUsed>',    '',                                 line_);
   Create_Line___(output_clob_, line_);
   
   
   FOR rec_ IN 1..count_ LOOP
      
      IF (count_ = 2 AND rec_ = 1) THEN
         intrastat_direction_ := intrastat_export_;
         first_last_ := '0';
      ELSIF (count_ = 2 AND rec_ = 2) THEN
         intrastat_direction_ := intrastat_import_;
         first_last_ := '1';
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
         OPEN check_opposite_country;
         FETCH check_opposite_country INTO country_of_origin_dummy_;
         IF (check_opposite_country%FOUND) THEN
            CLOSE check_opposite_country;
            Error_SYS.Record_General(lu_name_, 'NOOPPOSITECOUNTRY: Some intrastat lines are missing the required Opposite Country field information.');
         END IF;
         CLOSE check_opposite_country;
      END IF;

      -- Head blocks
      FOR headrec_ IN get_head LOOP
         IF (headrec_.rep_curr_code NOT IN ('EUR')) THEN
            Error_SYS.Record_General(lu_name_, 'WRONGCURR: Reporting currency should be EUR.');
         END IF;
         
         IF(intrastat_direction_ = 'EXPORT') THEN
            declaration_id_ := headrec_.dec_number_export;
            IF UPPER(Fnd_Session_API.Get_Language) = 'EN' THEN
               flow_code_ := 'D';
            ELSE
               flow_code_ := '2';
            END IF;
         ELSE
            declaration_id_ := headrec_.dec_number_import;
            IF UPPER(Fnd_Session_API.Get_Language) = 'EN' THEN
               flow_code_ := 'A';
            ELSE
               flow_code_ := '1';
            END IF;
         END IF;

         psi_id_ := vat_no_||'000';
         ref_period_ := TO_CHAR(headrec_.end_date,'YYYY')||TO_CHAR(headrec_.end_date,'MM');
         function_code_ := '0';

         OPEN line_exists(headrec_.country_code);
         FETCH line_exists INTO line_existsdummy_;
         IF (line_exists%FOUND) THEN
            CLOSE line_exists;
            function_code_ := 'I';
         ELSE
            CLOSE line_exists;
         END IF;

         line_ := '<Declaration>'|| CHR(13) || CHR(10);
         output_clob_ := output_clob_ || line_;

         Client_SYS.Clear_Attr(line_);
         Client_SYS.Add_To_Attr('<declarationId>',       SI_INTRASTAT_SEQ.NEXTVAL,              line_);
         Client_SYS.Add_To_Attr('</declarationId>',      '',                                    line_);
         Client_SYS.Add_To_Attr('<referencePeriod>',     ref_period_,                           line_);
         Client_SYS.Add_To_Attr('</referencePeriod>',    '',                                    line_);
         Client_SYS.Add_To_Attr('<PSIId>',               psi_id_,                               line_);
         Client_SYS.Add_To_Attr('</PSIId>',              '',                                    line_);
         Create_Line___(output_clob_, line_);

         line_ := '<Function>'|| CHR(13) || CHR(10);
         output_clob_ := output_clob_ || line_;
         line_ := '<functionCode>'||function_code_||'</functionCode>';
         output_clob_ := output_clob_ || line_;
         line_ := '</Function>'|| CHR(13) || CHR(10);
         output_clob_ := output_clob_ || line_;

         Client_SYS.Clear_Attr(line_);
         Client_SYS.Add_To_Attr('<flowCode>',            flow_code_,                            line_);
         Client_SYS.Add_To_Attr('</flowCode>',           '',                                    line_);
         Client_SYS.Add_To_Attr('<currencyCode>',        headrec_.rep_curr_code,                line_);
         Client_SYS.Add_To_Attr('</currencyCode>',       '',                                    line_);
         Client_SYS.Add_To_Attr('<firstLast>',           first_last_,                           line_);
         Client_SYS.Add_To_Attr('</firstLast>',          '',                                    line_);
         Create_Line___(output_clob_, line_);

         Create_Details__(output_clob_,
                          intrastat_id_,
                          intrastat_direction_,
                          headrec_.rep_curr_rate,
                          headrec_.country_code);

         line_ := '</Declaration>'|| CHR(13) || CHR(10);
         output_clob_ := output_clob_ || line_;
      END LOOP;   -- head loop
   END LOOP;

   Client_SYS.Clear_Attr(line_);
   Client_SYS.Add_To_Attr('<numberOfDeclarations>',      count_,                                line_);
   Client_SYS.Add_To_Attr('</numberOfDeclarations>',     '',                                    line_);
   Client_SYS.Add_To_Attr('</Envelope>',                 '',                                    line_);
   Client_SYS.Add_To_Attr('</INSTAT>',                   '',                                    line_);
   Create_Line___(output_clob_, line_);

   info_ := Client_SYS.Get_All_Info;

END Create_Output;
