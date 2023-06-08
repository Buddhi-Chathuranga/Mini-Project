-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatDeFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220126  ErFelk  Bug 162263(SC21R2-7418), Removed the LPAD of MSConsDestCode and countryOfOriginCode tags so that the value will display in two digits.
--  211209  ErFelk  Bug 161021(SC21R2-6450), Modified Create_Details__() and Create_Output() By removing notc 29, 31, 32, 33 from statistical_value in cursor get_lines.
--  210728  ErFelk  Bug 160291(SCZ-15706), Modified Create_Details__() to handle country of origin for EXPORT and raised an info mesage if it is empty.
--  210218  ErFelk  Bug 157117(SCZ-13052), Modified Create_Output_From_Xml() by adding address details to receiver. It was taken from the customs.
--  200710  ErFelk  Bug 147354(SCZ-5560), Added new xml tag <partnerId> to show the newly added field opponent_tax_id. New info message NOOPPONENTTAXID was also added.   
--  200422  ErFelk  Bug 153561(SCZ-9502), Modified Create_Output_From_Xml() by searching the output_clob_ to find Ampersand sign and replaces it by CHR(38) followed by amp; so that generated xml can be view correctly.  
--  191219  ErFelk  Bug 148659(SCZ-5392), Modified Create_Output_From_Xml() and Create_Output() by adding another condition to check order_unit_price to raise the error ZERONOTALLOWED.
--  191203  ErFelk  Bug 147442(SCZ-4060), Modified the normal and the xml file creation by allowing error messages ORDERUNITPRICE, INVOICEDUNITPRICEZERO and ZERONOTALLOWED to be raised when the direction is EXPORT and IMPORT. 
--  191203  ErFelk  Bug 147120(SCZ-3682), Modified get_lines cursors in Create_Output() and Create_Details__() by changing the calculation of invoiced_amount to consider charge values and
--  191203          subtract the statistical_charge_diff from statistical_value.
--  190826  ChFolk  SCUXXW4-24060, Added new method Raise_No_Vat_No_Error___ as the same error is raised in more than one method.
--  190821  DaZase  SCUXXW4-23790, Changed missing Intrastat Tax number/Interchange Agreement ID message to also support Aurena client rework.
--  190522  ErFelk  Bug 143445, Supported the XML file generation format together with the old format. Old Format is needed until all sites of customer gets the new identification number
--  190522          to start with XML format. Old format can be removed in a next project. A new field Interchange_Agreement_ID was also added.
--  190125  ErFelk  Bug 145171(SCZ-1783), Modified cursors get_lines and get_line_data by adding rowstate to the where clause in methods Create_Output(),Create_Output_From_Xml() and Create_Details__().
--  181024  ErFelk  Bug 144663, Modified get_lines cursor by joining site_invent_info_tab with other tables and replaced ca.state with sii.region_code. Because of this, 
--  181024          no need to check the state presentation for lines. Line will always have the region code fetched from inventory part or site.
--  181024          Custom and Company state will be having Financial state representation, whereas Site and Inventory Part is having state representation of inventory 
--  181024          which is the one we should be displaying. Custom and Company state needs to be convert and display it from Inventory state representation.
--  171220  DiKuLk  Bug 138969, Modified Create_Output() to handle new intrastat tax number. Earlier fetching of vat_no was removed and it was fetched from
--  171220          Company_Distribution_Info_API.Get_Intrastat_Tax_Number() the new method.
--  171218  ApWilk  Bug 139184, Modified Create_Output() so that original logic and the logic introduce from Bug 134823 is preserved. This is needed because 
--  171218          some customers do not use the Address setup per country functionality.
--  171011  ErFelk  Bug 137492, Added a new cursor get_line_data so that error messages ORDERUNITPRICE, INVOICEDUNITPRICEZERO and ZERONOTALLOWED could be raised line by line.
--  171011          Modified cursor get_lines so that statistical_value want be zero when having notc 22, 23, 29, 31, 32, 33, and 34.
--  170506  ErFelk  Bug 134823, Modified Create_Output() so that field5_s2_ and field7_ will have the correct region code/state code. It is 
--  170506          a German requirement to have 2 different state codes in Financials and Inventory. Depending on the state presentation, it is required 
--  170506          to get the state name from Finance and validate against the region name in the Region of Origin which is in Invent.
--  150721  PrYaLK  Bug 123199, Modified Create_Output method to exclude the invoiced value of CO-PURSHIP transaction since it should be 0.
--  150519  ShKolk  Bug 121489, Modified Create_Output method to exclude the invoiced value of PURSHIP transaction since it should be 0.
--  142001  KoDelk  Bug 120639, Modified the get_lines cursor not to filter out records which has zero net invoiced price value.
--  142001          Removed the check on feild20_ and feild21_ before calling the Intrastat_File_Util_API.New_Line();
--  140703  KoDelk  Bug 117074, Modified method Create_Output to raise messages when mandatory fields don't have values.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130730  AwWelk  TIBE-842, Removed global variables and introduced conditional compilation.
--  130802  MalLlk  Bug 111541, Increased the length of the variable deliv_addr_dummy_ to 50 in method Create_Output.
--  130626  IsSalk  Bug 106841, Modified cursor get_lines to consider arrival transactions with triangulation when selecting region of origin. 
--  110830  TiRalk  Bug 98710, Modified cursor get_lines to consider rows where invoice or statistical value not equal zero 
--  110830          which means to select the rows with UNRCPT- transaction also to avoid the wrong summation of net weight,
--  110830          invoice value, statistical value and alternative quantity.
--  110309  Bmekse  DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                  inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203  Elarse  Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise  Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  091007  PraWlk  Bug 85992, Modified the customs_stat_no in cursor get_lines to summarize data
--  091007          according to customs_stat_no.
--  090925  PraWlk  Bug 85992, Removed the check and the error message introduced in the bug 70656.
--  080521  SuSalk  Bug 72568, Modified get_lines cursor in the Create_Output method to exclude 
--  080521          POINV-WIP transaction's value from the invoice value.
--  080324  SuSalk  Bug 72412, Changed length of the field12_ to 6. 
--  080202  SuSalk  Bug 70656, Modified Create_Output method to handle Customs Statistics No as 8 characters long
--  080202          and added a new error message to handle Customs Statistics No that is exceeding 8 characters.
--  070117  WaJalk  Bug 62542, Modified the value of field16_ to show five spaces since its not used anymore. 
--  060707  Asawlk  Bug 59144, Modified the length of field13_ to show 10 chars in customs_stat_no.
--  060120  NiDalk  Added Assert safe annotation. 
--  060118  HoInlk  Bug 54941, Modified values for field16_ to hold only 4 digits in method Create_Output.
--  051026  DAYJLK  Bug 53604, Modified the select and group by clauses of cursor get_lines in method Create_Output to consider PURDIR.
--  050919  NiDalk  Removed unused variables.
--  041101  GaJalk  Bug 47300, Added the company check inside cursors get_lines and
--                  get_delivery_address in Create_Output.
--  041025  GaJalk  Bug 47300, Modified the cursor get_lines in procedure Create_Output 
--                  and changed an error message.
--  041001  ErSolk  Bug 47081, Changed value assigned to field10_.
--  040924  RoJalk  Bug 47126, Modified the cursors get_lines, get_delivery_address 
--  040924          and changed ca.country to ca.country_db. 
--  040324  LoPrlk  Call 113583, Cursor get_lines in method Create_Output was modified.
--  040227  GeKalk  Replaced substrb with substr for UNICODE modifications.
--  040203  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  040121  ChBalk  Bug 38752, Modified the CURSOR get_lines in PROCEDURE Create_Output 
--  040121          to include the new transaction code PODIRINTEM.
--  030901  NaWalk  Performed CR Merge02.
--  030827  SeKalk  Code Review
--  030826  ThGulk  Replaced  Company_Address_Tab with COMPANY_ADDRESS_PUB
--  030820  KiSalk  Perfromd CR Merge.
--  030424  SeKalk  Changed nvl to NVL and closed cursor Get_Delivery_Address before the Error_Sys call
--  030326  SeKalk  Replaced Site_Delivery_Address_Tab with Company_Address_Tab
--  030820  KiSalk  ***************** CR Merge Start *************************
--  021120  DaZa  Bug 34138, added extra decode on the view on region/state decode in the view, to handle PODIRSH transactions.
--  020821  DaZa  Bug 32183, added an extra where condition in get_lines cursor, so we now skip rows 
--                that don't have an invoice or statistical value. Added an extra if-check for IMPORT.
--  020807  DaZa  Bug 30820, made opposite_country and country_of_orgin(import) right justified. 
--                Added handling so export rows with no invoice or statistic value are not created.                 
--  020619  DaZa  Bug 30248, added extra handling of region_of_origin for export report.
--  020318  DaZa  Bug fix 28658, commented "line_no_ := 1;" and instead changed the declaration part to "line_no_ NUMBER := 1;"
--  020312  DaZa  Bug fix 28308, added ABS on intrastat_alt_qty so we dont get "-x * -y results" when we multiply with the regular qty.
--  010411 DaJoLK Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and 
--                TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  032001  Indi  Added an error message for no records in the Intrastat_line_tab.
--  150301  MKOR  Several Error messages added
--  140301  Indi  Changed get_line cursor.
--  120201  Indi  Created
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

PROCEDURE Raise_No_Vat_No_Error___ (
   company_ IN VARCHAR2 )
IS
BEGIN
   IF (Fnd_Session_API.Is_Odp_Session) THEN  -- Aurena client
      Error_SYS.Record_General(lu_name_, 'NOVATNO2: Intrastat Tax Number is missing for company :P1 in Supply Chain Information sub menu.', company_);
   ELSE -- IEE client
      Error_SYS.Record_General(lu_name_, 'NOVATNO1: Intrastat Tax Number is missing for company :P1 in Distribution tab.', company_);    
   END IF;
END Raise_No_Vat_No_Error___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Create_Details__ (
   output_clob_          IN OUT CLOB,
   intrastat_id_         IN     NUMBER,
   intrastat_direction_  IN     VARCHAR2,         
   rep_curr_rate_        IN     NUMBER,
   country_code_         IN     VARCHAR2 )
IS
   line_                  VARCHAR2(32000);   
   pos_id_                NUMBER := 0;   
   notc_a_                VARCHAR2(1);
   notc_b_                VARCHAR2(1);
   deliv_addr_dummy_      VARCHAR2(50);
   state_code_            VARCHAR2(2);
   
   CURSOR get_lines IS
      SELECT il.intrastat_direction,
             il.opposite_country,
             il.country_of_origin,
             il.mode_of_transport,
             il.statistical_procedure,
             DECODE(intrastat_direction_, 'IMPORT', DECODE(il.transaction, 'PODIRSH',NVL(il.region_of_origin, sii.region_code),
                                                                           'PURDIR',NVL(il.region_of_origin, sii.region_code),
                                                                           'PODIRINTEM',NVL(il.region_of_origin, sii.region_code),
                                                                           'ARRIVAL', DECODE(il.triangulation, 'TRIANGULATION', NVL(il.region_of_origin, sii.region_code), sii.region_code),
                                                                           sii.region_code),
                                                                           NVL(il.region_of_origin, sii.region_code))   region_code,
             cn.country_notc,
             SUBSTR(REPLACE(il.customs_stat_no,' '),1,8)                                                                customs_stat_no,
             il.contract,
             SUM(il.quantity * il.net_unit_weight)                                                                      mass,
             SUM(NVL(ABS(il.intrastat_alt_qty),0) * il.quantity)                                                        alternative_qty,
             SUM(il.quantity * (NVL(il.invoiced_unit_price, DECODE(il.transaction, 'POINV-WIP',  0,
                                                                                    'PURSHIP',  0,
                                                                                 'CO-PURSHIP',  0, il.order_unit_price)) +
                                NVL(il.unit_charge_amount_inv, 0) +
                                NVL(il.unit_charge_amount, 0))) * rep_curr_rate_                                        invoice_value,
             SUM((DECODE(DECODE(cn.country_notc, 22, 0,
                                                 23, 0,                                                  
                                                 34, 0, il.invoiced_unit_price), 0, il.order_unit_price,
                                                                                 NULL ,il.order_unit_price, il.invoiced_unit_price)+
               NVL(il.unit_add_cost_amount_inv, NVL(il.unit_add_cost_amount,0))+
               NVL(il.unit_charge_amount_inv,0) +
               NVL(il.unit_charge_amount,0) -
               NVL(il.unit_statistical_charge_diff, 0)) * il.quantity) * rep_curr_rate_                                 statistical_value,
               DECODE(il.intrastat_direction, 'EXPORT', il.opponent_tax_id, '')  opponent_tax_id
      FROM   country_notc_tab cn, company_address_pub ca, site_tab s, intrastat_line_tab il, site_invent_info_tab sii
      WHERE  intrastat_id        = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    il.rowstate         = 'Released'
      AND    il.contract         = s.contract
      AND    s.contract          = sii.contract
      AND    s.delivery_address  = ca.address_id
      AND    s.company           = ca.company
      AND    ca.country_db       = country_code_
      AND    il.notc             = cn.notc
      AND    cn.country_code     = country_code_    
      GROUP BY  il.intrastat_direction,
                il.opposite_country,
                il.country_of_origin,
                il.mode_of_transport,
                il.statistical_procedure,
                DECODE(intrastat_direction_, 'IMPORT', DECODE(il.transaction, 'PODIRSH',NVL(il.region_of_origin, sii.region_code),
                                                                              'PURDIR',NVL(il.region_of_origin, sii.region_code),
                                                                              'PODIRINTEM',NVL(il.region_of_origin, sii.region_code),
                                                                              'ARRIVAL', DECODE(il.triangulation, 'TRIANGULATION', NVL(il.region_of_origin, sii.region_code), sii.region_code),
                                                                              sii.region_code),
                                                                              NVL(il.region_of_origin, sii.region_code)),

                cn.country_notc,
                SUBSTR(REPLACE(il.customs_stat_no,' '),1,8),
                DECODE(il.intrastat_direction, 'EXPORT', il.opponent_tax_id, ''),
                il.contract;
                
   get_lines_dummy_  get_lines%ROWTYPE; 
   
   CURSOR get_delivery_address IS
      SELECT distinct s.delivery_address
      FROM   company_address_pub ca, site_tab s, intrastat_line_tab il
      WHERE  intrastat_id        = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    il.contract         = s.contract
      AND    s.delivery_address  = ca.address_id
      AND    s.company           = ca.company
      AND    ca.country_db       = country_code_      
      AND    ca.state            IS NULL;  
                
BEGIN   
   pos_id_ := 0;  
   
   OPEN  get_lines;
   FETCH get_lines INTO get_lines_dummy_;
      IF (get_lines%NOTFOUND) THEN
         CLOSE get_lines;      
         Error_SYS.Record_General(lu_name_, 'NORECOR: Files with no items are not allowed to be created.');      
      END IF;
   CLOSE get_lines;
   
   FOR linerec_ IN get_lines LOOP
      pos_id_ := pos_id_ + 1;      
      
      IF (linerec_.mode_of_transport IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOMODETRANS: The mode of transport must be specified for intrastat reporting.'); 
      END IF;      
      
      IF (linerec_.customs_stat_no IS NULL) THEN         
         Error_SYS.Record_General(lu_name_, 'NOSTATNUMBER: The customs statistics number must be specified for intrastat reporting.'); 
      END IF;    
      
      IF (intrastat_direction_ = 'EXPORT') THEN  
         IF (linerec_.region_code IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOREGION: Region of Origin is missing on at least one intrastat export line');            
         END IF;
         IF (linerec_.opponent_tax_id IS NULL) THEN         
            Error_SYS.Record_General(lu_name_, 'NOOPPONENTTAXID: Opponent Tax ID is missing for some lines.');
         END IF;
      ELSE         
         IF (linerec_.region_code IS NULL) THEN
            OPEN get_delivery_address;
            FETCH get_delivery_address INTO deliv_addr_dummy_;
            CLOSE get_delivery_address;
            Error_SYS.Record_General(lu_name_, 'NOSITESTAT: Country Code and Region Code are missing for Delivery Address :P1 in Site :P2.',deliv_addr_dummy_, linerec_.contract);        
         END IF;  
      END IF;      
      
      IF (linerec_.country_of_origin IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOCOUNTRYORIGIN: The country of origin must be specified for intrastat reporting.');   
      END IF;
      
      state_code_ :=  LPAD(SUBSTR(linerec_.region_code,1,2),2,'0');
            
      notc_a_ := SUBSTR(linerec_.country_notc, 1, 1);
      notc_b_ := SUBSTR(linerec_.country_notc, 2, 1); 
      
      line_ := '<Item>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;      
      
      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('<itemNumber>',                   pos_id_,                                     line_);
      Client_SYS.Add_To_Attr('</itemNumber>',                  '',                                          line_);
      Client_SYS.Add_To_Attr('<CN8>',                          '',                                          line_);
         Client_SYS.Add_To_Attr('<CN8Code>',                   linerec_.customs_stat_no,                    line_);
         Client_SYS.Add_To_Attr('</CN8Code>',                  '',                                          line_);         
      Client_SYS.Add_To_Attr('</CN8>',                         '',                                          line_);
      Client_SYS.Add_To_Attr('<goodsDescription>',             Customs_Statistics_Number_API.Get_Description(linerec_.customs_stat_no),      line_);
      Client_SYS.Add_To_Attr('</goodsDescription>',              '',                                        line_);
      Client_SYS.Add_To_Attr('<MSConsDestCode>',               linerec_.opposite_country,                   line_);
      Client_SYS.Add_To_Attr('</MSConsDestCode>',              '',                                          line_);      
      IF (linerec_.country_of_origin IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('<countryOfOriginCode>',       linerec_.country_of_origin,                  line_);
         Client_SYS.Add_To_Attr('</countryOfOriginCode>',      '',                                          line_);
      ELSE
         Client_SYS.Add_To_Attr('<countryOfOriginCode/>',      '',                                          line_);
      END IF;
         Client_SYS.Add_To_Attr('<netMass>',                   SUBSTR(TO_CHAR(ROUND(ABS(linerec_.mass))), 1, 11),              line_);
         Client_SYS.Add_To_Attr('</netMass>',                  '',                                          line_);           
         Client_SYS.Add_To_Attr('<quantityInSU>',              SUBSTR(TO_CHAR(ROUND(ABS(linerec_.alternative_qty))), 1, 11),   line_);
         Client_SYS.Add_To_Attr('</quantityInSU>',             '',                                          line_);
      
      Client_SYS.Add_To_Attr('<invoicedAmount>',               SUBSTR(TO_CHAR(ROUND(ABS(linerec_.invoice_value))), 1, 11),     line_);
      Client_SYS.Add_To_Attr('</invoicedAmount>',              '',                                          line_);
      Client_SYS.Add_To_Attr('<statisticalValue>',             SUBSTR(TO_CHAR(ROUND(ABS(linerec_.statistical_value))), 1, 11), line_);
      Client_SYS.Add_To_Attr('</statisticalValue>',            '',                                          line_);
      Client_SYS.Add_To_Attr('<partnerId>',                    linerec_.opponent_tax_id,                    line_);
      Client_SYS.Add_To_Attr('</partnerId>',                   '',                                          line_);
      Client_SYS.Add_To_Attr('<NatureOfTransaction>',          '',                                          line_);
         Client_SYS.Add_To_Attr('<natureOfTransactionACode>',  notc_a_,                                     line_);
         Client_SYS.Add_To_Attr('</natureOfTransactionACode>', '',                                          line_);
         Client_SYS.Add_To_Attr('<natureOfTransactionBCode>',  notc_b_,                                     line_);
         Client_SYS.Add_To_Attr('</natureOfTransactionBCode>', '',                                          line_);
      Client_SYS.Add_To_Attr('</NatureOfTransaction>',         '',                                          line_);
      Client_SYS.Add_To_Attr('<modeOfTransportCode>',          NVL(linerec_.mode_of_transport, '0'),        line_);
      Client_SYS.Add_To_Attr('</modeOfTransportCode>',         '',                                          line_);
      Client_SYS.Add_To_Attr('<regionCode>',                   state_code_,                                 line_); -- region_of_origin/ state
      Client_SYS.Add_To_Attr('</regionCode>',                  '',                                          line_);        
      
      Create_Line___(output_clob_, line_);
      
      line_ := '</Item>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
   END LOOP; -- Line Ends
   
END Create_Details__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Output
--   Method fetches the intrastat data and formats it according to
--   specifications for Germany.
PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2, 
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,        
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2,
   file_extension_       IN  VARCHAR2)
IS

   intrastat_direction_  VARCHAR2(10);
   field1_               VARCHAR2(1);
   field2_               VARCHAR2(1);
   field3_               VARCHAR2(1) := lpad(' ',1);
   
   field4_               VARCHAR2(10);
   field4_s1_          VARCHAR2(2);
   field4_s2_          VARCHAR2(2);
   field4_s3_          NUMBER:=1001;   
   
   field5_               VARCHAR2(18);
   field5_s1_            VARCHAR2(2) := lpad(' ',2);
   field5_s2_            VARCHAR2(2);
   field5_s3_            VARCHAR2(11);
   field5_s4_            VARCHAR2(3);
   address_id_           VARCHAR2(50);
   field5i_              VARCHAR2(1):=lpad(' ',1);
   
   field6_              VARCHAR2(3);
   field7_               VARCHAR2(2);

   field8_            VARCHAR2(2);
   field8i_              VARCHAR2(2):=lpad(' ',2);

   field9_              VARCHAR2(1);
   field10_              VARCHAR2(1);

   field11_           VARCHAR2(6)  := lpad(' ',6);                           
   field11i_          VARCHAR2(1)  := lpad(' ',1);                           

   field12_             VARCHAR2(6)  := lpad(' ',6);

   field13_              VARCHAR2(8):= NULL;

   field14_           VARCHAR2(3)  := lpad(' ',3);

   field15_           VARCHAR2(2)  := lpad(' ',2);
   field15i_          VARCHAR2(3)  ;

   field16_              VARCHAR2(5) := LPAD(' ', 5);

   end_date_             DATE;
   field17_              VARCHAR2(11);   
   field18_              VARCHAR2(11);
   field19_              VARCHAR2(2) := lpad(' ',2); 
   field20_              VARCHAR2(11); 
   field21_              VARCHAR2(11); 
   field22_              VARCHAR2(2) := lpad(' ',2);   
   field23_              VARCHAR2(4) ;  
   field23_s1_        NUMBER;
   field23_s2_        NUMBER;
   field25_              VARCHAR2(5)  := lpad(' ',5);  
   field24_              VARCHAR2(1)  ;
   field24i_             VARCHAR2(7)  := lpad(' ',7);  

   line_                 VARCHAR2(2000);
   rep_curr_code_        VARCHAR2(3);
   rep_curr_rate_        NUMBER;
   vat_no_               VARCHAR2(50); 
   notc_dummy_           VARCHAR2(2); 
   country_code_         VARCHAR2(2);  
   customs_id_           VARCHAR2(20);
   deliv_addr_dummy_     VARCHAR2(50); 
   region_dummy_         VARCHAR2(1);   
   dummy_                VARCHAR2(1);
   state_presentation_db_ VARCHAR2(20); 
   state_name_            VARCHAR2(35);
   customs_state_         VARCHAR2(35);
   region_code_           VARCHAR2(10);
                            
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
             il.country_of_origin,
             il.mode_of_transport,
             il.statistical_procedure,
             DECODE(intrastat_direction_, 'IMPORT', DECODE(il.transaction, 'PODIRSH', NVL(il.region_of_origin, sii.region_code), 
                                                                           'PURDIR',NVL(il.region_of_origin, sii.region_code), 
                                                                           'PODIRINTEM', NVL(il.region_of_origin, sii.region_code),
                                                                           'ARRIVAL', DECODE(il.triangulation, 'TRIANGULATION', NVL(il.region_of_origin, sii.region_code), sii.region_code),
                                                                           sii.region_code),
                                                                           NVL(il.region_of_origin, sii.region_code))    region_code,
             cn.country_notc,
             SUBSTR(REPLACE(il.customs_stat_no,' '),1,8)                                                          customs_stat_no,
             il.contract,
             SUM(il.quantity * il.net_unit_weight)                                                                mass,
             SUM(NVL(ABS(il.intrastat_alt_qty),0) * il.quantity)                                                  alternative_qty,
             SUM(il.quantity * (NVL(il.invoiced_unit_price, DECODE(il.transaction, 'POINV-WIP',  0,
                                                                                    'PURSHIP',  0,
                                                                                 'CO-PURSHIP',  0, il.order_unit_price)) +
                                NVL(il.unit_charge_amount_inv, 0) +
                                NVL(il.unit_charge_amount, 0))) * rep_curr_rate_                                  invoice_value,
             SUM((DECODE(DECODE(cn.country_notc, 22, 0,
                                                 23, 0,                                                  
                                                 34, 0, il.invoiced_unit_price), 0, il.order_unit_price,
                                                                                 NULL ,il.order_unit_price, il.invoiced_unit_price)+
               NVL(il.unit_add_cost_amount_inv, NVL(il.unit_add_cost_amount,0))+
               NVL(il.unit_charge_amount_inv,0) +
               NVL(il.unit_charge_amount,0) -
               NVL(il.unit_statistical_charge_diff, 0)) * il.quantity) * rep_curr_rate_                           statistical_value
      FROM   country_notc_tab cn, company_address_pub ca, site_tab s, intrastat_line_tab il, site_invent_info_tab sii
      WHERE  intrastat_id        = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    il.rowstate         = 'Released'
      AND    il.contract         = s.contract
      AND    s.contract          = sii.contract
      AND    s.delivery_address  = ca.address_id
      AND    s.company           = ca.company
      AND    ca.country_db       = country_code_
      AND    il.notc             = cn.notc
      AND    cn.country_code     = country_code_
      GROUP BY  il.intrastat_direction,
                il.opposite_country,
                il.country_of_origin,
                il.mode_of_transport,
                il.statistical_procedure,
                DECODE(intrastat_direction_, 'IMPORT', DECODE(il.transaction, 'PODIRSH',NVL(il.region_of_origin, sii.region_code), 
                                                                              'PURDIR',NVL(il.region_of_origin, sii.region_code), 
                                                                              'PODIRINTEM',NVL(il.region_of_origin, sii.region_code),
                                                                              'ARRIVAL', DECODE(il.triangulation, 'TRIANGULATION', NVL(il.region_of_origin, sii.region_code), sii.region_code),
                                                                              sii.region_code),
                                                                              NVL(il.region_of_origin, sii.region_code)),
                cn.country_notc,                                            
                SUBSTR(REPLACE(il.customs_stat_no,' '),1,8),
                il.contract;
                
   get_lines_dummy_  get_lines%ROWTYPE;
               
   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;


   CURSOR get_country_notc(notc_ VARCHAR2) IS
      SELECT country_notc
     FROM   country_notc_tab
     WHERE  notc = notc_
     AND    country_code = 'DE';

   CURSOR get_delivery_address IS
      SELECT distinct s.delivery_address
      FROM   company_address_pub ca, site_tab s, intrastat_line_tab il
      WHERE  intrastat_id        = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    il.contract         = s.contract
      AND    s.delivery_address  = ca.address_id
      AND    s.company           = ca.company
      AND    ca.country_db       = country_code_;

   CURSOR check_region_vs_country(region_of_origin_ VARCHAR2, intrastat_direct_ VARCHAR2) IS
      SELECT 1
      FROM   intrastat_line_tab
      WHERE  intrastat_id        = intrastat_id_
      AND    intrastat_direction = intrastat_direct_
      AND    country_of_origin = 'DE'
      AND    region_of_origin = region_of_origin_;

   CURSOR check_contract IS
      SELECT 1
      FROM   intrastat_line_tab
      WHERE  intrastat_id        = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    contract IS NULL;
      
   CURSOR get_region_code (field_ VARCHAR2) IS
      SELECT region_code
      FROM country_region_tab
      WHERE country_code = 'DE'
      AND   region_name = field_;   
   
   CURSOR get_line_data IS
      SELECT line_no, notc, order_unit_price, invoiced_unit_price
      FROM intrastat_line_tab
      WHERE intrastat_id = intrastat_id_
      AND   intrastat_direction = intrastat_direction_
      AND   rowstate = 'Released';
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
   
   IF(intrastat_direction_ = 'EXPORT') THEN
     field1_ :='2';
     field2_ :='2';
     
     OPEN check_region_vs_country('25', intrastat_direction_);
     FETCH check_region_vs_country INTO region_dummy_;
     IF (check_region_vs_country%FOUND) THEN    
        CLOSE check_region_vs_country;
        Error_SYS.Record_General(lu_name_, 'NOREG25FORDE: At least one intrastat export line have Country of Origin = DE while Region of Origin = 25, this is not valid, use another Country of Origin than DE.');   
     END IF;        
     CLOSE check_region_vs_country;
   ELSIF(intrastat_direction_ = 'IMPORT') THEN  
     field1_ :='1';
     field2_ :='1';
     
     OPEN check_region_vs_country('99', intrastat_direction_);
     FETCH check_region_vs_country INTO region_dummy_;
     IF (check_region_vs_country%FOUND) THEN    
        CLOSE check_region_vs_country;
        Error_SYS.Record_General(lu_name_, 'NOREG99FORDE: At least one intrastat import line have Country of Origin = DE while Region of Origin = 99, this is not valid, use another Country of Origin than DE.');   
     END IF;        
     CLOSE check_region_vs_country;
   END IF;
   
   IF (file_extension_ = 'xml') THEN
      
      Create_Output_From_Xml(output_clob_,                              
                             import_progress_no_,
                             export_progress_no_,        
                             intrastat_id_ ,
                             intrastat_direction_ );
   ELSE
      state_presentation_db_ := Enterp_Address_Country_API.Get_State_Presentation_Db('DE');

      FOR headrec_ IN get_head LOOP   

            vat_no_ := Company_Distribution_Info_API.Get_Intrastat_Tax_Number(headrec_.company);

         end_date_      := headrec_.end_date;
         field4_s1_     := lpad(to_char(headrec_.end_date, 'MM'),2,'0');   
         field4_s2_     := '00';          
         address_id_    := Customs_Info_Address_API.Get_Default_Address(headrec_.customs_id,
                                  address_type_code_api.decode('INVOICE'),
                                  headrec_.creation_date);
         country_code_  := headrec_.country_code;      

         customs_id_    := headrec_.customs_id;

         IF customs_id_ IS NULL THEN
            Error_SYS.Record_General(lu_name_, 'NOCUSTOMSID: Customs ID is missing for Intrastat ID :P1.',intrastat_id_);    
         END IF;

         IF (state_presentation_db_ IN ('NAMES', 'CODES')) THEN

            customs_state_ := Customs_Info_Address_API.Get_State(customs_id_,address_id_);

            IF customs_state_ IS NULL THEN
               Error_SYS.Record_General(lu_name_, 'NOCUSTOMSSTATE: State is missing for Customs ID :P1.',customs_id_);    
            END IF;

            state_name_ := '';
            IF (state_presentation_db_ = 'CODES') THEN
               state_name_ := State_Codes_API.Get_State_Name(headrec_.country_code, customs_state_ );
            END IF;

            OPEN get_region_code(NVL(state_name_, customs_state_)); 
            FETCH get_region_code INTO region_code_;
            CLOSE get_region_code;

            field5_s2_ := LPAD(SUBSTR(region_code_,1,2),2,'0');

            IF (field5_s2_ IS NULL) THEN
               -- No matching entry in region of origin.
               Error_SYS.Record_General(lu_name_, 'NOVALUEINORIGIN: Incorrect state code when generating files. Please check the state code/name of the address of the customs or delivery address of the sites.');
            END IF;
         ELSE
            field5_s2_ := LPAD(SUBSTR(Customs_Info_Address_API.Get_State(customs_id_,address_id_),1,2),2,'0');

            IF field5_s2_ IS NULL THEN
               Error_SYS.Record_General(lu_name_, 'NOCUSTOMSSTATE: State is missing for Customs ID :P1.',customs_id_);    
            END IF;
         END IF;

         IF vat_no_ IS NULL THEN
            Raise_No_Vat_No_Error___(headrec_.company);
         ELSE
            IF( SUBSTR(vat_no_, 1,2) = headrec_.country_code) THEN
              field5_s3_     :=RPAD(SUBSTR(vat_no_, 3, 11), 11, '0');
            ELSE
              field5_s3_     :=RPAD(SUBSTR(vat_no_, 1, 11), 11, '0');
            END IF;
         END IF; 

         field5_s4_     :=LPAD(SUBSTR(headrec_.bransch_no,1,3),3,'0');
         field5_        :=field5_s1_|| field5_s2_ ||NVL(field5_s3_,'00000000000')||NVL(field5_s4_,'000');
         rep_curr_rate_ :=headrec_.rep_curr_rate;
         rep_curr_code_ := headrec_.rep_curr_code;       

      END LOOP;

      IF(rep_curr_code_ = 'DEM') THEN
         field24_  := 1;
      ELSIF(rep_curr_code_ = 'EUR') THEN
         field24_  := 2;
      ELSE
         Error_SYS.Record_General(lu_name_, 'NOTDEMEUR: Reporting currency should be DEM or EUR.');     
      END IF;


      field4_s3_  :=1001;  

      OPEN  get_lines;
      FETCH get_lines INTO get_lines_dummy_;
      IF (get_lines%NOTFOUND) THEN
         CLOSE get_lines;      
         Error_SYS.Record_General(lu_name_, 'NORECOR: Files with no items are not allowed to be created.');      
      END IF;
      CLOSE get_lines;   

      FOR rec_ IN get_line_data LOOP         
         IF (rec_.notc IN (22,23,34)) THEN
            IF (rec_.order_unit_price = 0) THEN
               Error_SYS.Record_General(lu_name_, 'ORDERUNITPRICE: Net Price/Base cannot be zero for Intrastat Line No :P1 having NOTC :P2.', rec_.line_no, rec_.notc); 
            END IF;
            IF ((rec_.invoiced_unit_price != 0) OR (rec_.invoiced_unit_price IS NULL)) THEN   
               Error_SYS.Record_General(lu_name_, 'INVOICEDUNITPRICEZERO: Net Invoiced Price/Base should be zero for Intrastat Line No :P1 having NOTC :P2.', rec_.line_no, rec_.notc);
            END IF;
         END IF;

         IF (rec_.notc = 11) THEN
            IF ((NVL(rec_.invoiced_unit_price, 0) = 0) AND (rec_.order_unit_price = 0)) THEN   
               Error_SYS.Record_General(lu_name_, 'ZERONOTALLOWED: Net Invoiced Price/Base cannot be zero for Intrastat Line No :P1 having NOTC :P2.', rec_.line_no, rec_.notc);
            END IF;
         END IF;         
      END LOOP;

      FOR linerec_ IN get_lines LOOP       
         field6_ :=  LPAD(linerec_.opposite_country,3,' '); 
         field7_ :=  LPAD(SUBSTR(linerec_.region_code,1,2),2,'0');      

         IF (intrastat_direction_ = 'EXPORT') THEN
            IF (field7_ IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'NOREGION: Region of Origin is missing on at least one intrastat export line');            
            END IF;        
         ELSE
            IF (field7_ IS NULL) THEN
               OPEN get_delivery_address;
               FETCH get_delivery_address INTO deliv_addr_dummy_;
               CLOSE get_delivery_address;
               Error_SYS.Record_General(lu_name_, 'NOSITESTAT: Country Code and Region Code are missing for Delivery Address :P1 in Site :P2.',deliv_addr_dummy_, linerec_.contract);   
            END IF; 
         END IF;
         
         IF (linerec_.country_of_origin IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOCOUNTRYORIGIN: The country of origin must be specified for intrastat reporting.');   
         END IF;

         IF (linerec_.mode_of_transport IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOMODETRANS: The mode of transport must be specified for intrastat reporting.'); 
         END IF;

         field8_     :=  lpad(linerec_.country_notc,2,'0');
         field9_     :=  linerec_.mode_of_transport;
         field10_    :=  ' ';

         IF (linerec_.customs_stat_no IS NOT NULL) THEN
            field13_ := linerec_.customs_stat_no;
         ELSE
            Error_SYS.Record_General(lu_name_, 'NOSTATNUMBER: The customs statistics number must be specified for intrastat reporting.');   
         END IF;

         field15i_   :=  LPAD(linerec_.country_of_origin, 3, ' ');
         field17_    :=  LPAD(SUBSTR(TO_CHAR(ROUND(abs(linerec_.mass))), 1, 11), 11, '0');
         field18_    :=  LPAD(SUBSTR(TO_CHAR(ROUND(abs(linerec_.alternative_qty))), 1, 11), 11, '0');
         field20_    :=  LPAD(SUBSTR(TO_CHAR(ROUND(abs(linerec_.invoice_value))), 1, 11), 11, '0'); 
         field21_    :=  LPAD(SUBSTR(TO_CHAR(ROUND(abs(linerec_.statistical_value))), 1, 11), 11, '0'); 
         field23_s1_ :=  to_char(end_date_, 'MM');
         field23_s2_ :=  to_char(end_date_, 'YY');
         field23_    :=  LPAD(field23_s1_,2,'0')||LPAD(field23_s2_,2,'0');
         field4_     :=  field4_s1_||field4_s2_||LPAD(to_char(field4_s3_),6,'0');

         IF (intrastat_direction_ = 'EXPORT') THEN

            line_ := field1_  ||
                   field2_  ||
                   field3_  ||
                   field4_  ||
                   field5_  ||
                   field6_  ||
                   field7_  ||
                   field8_  ||
                   NVL(field9_,'0')  ||
                   field10_ ||
                   field11_ ||
                   field12_ ||
                   NVL(field13_,lpad(' ',8)) ||
                      field14_ ||
                    field15_ ||
                   field16_ ||
                   field17_ ||
                   NVL(field18_,lpad('0',11,'0')) ||
                   field19_ ||
                   field20_ ||
                   NVL(field21_,lpad('0',11,'0')) ||
                   field22_ ||
                   field23_ ||
                   field24_ ||
                   field25_ ||
                   CHR(13)  || CHR(10);                

               output_clob_ := output_clob_ || line_;

         ELSIF(intrastat_direction_ = 'IMPORT') THEN

         line_ := field1_   ||
                  field2_   ||
                  field4_   ||
                  field5_   ||
                  field5i_  ||
                  field6_   ||
                  field7_   ||
                  field8i_  ||
                  field8_   ||
                  NVL(field9_,'0')   ||
                  field11i_ ||
                  field11_  ||
                  field12_  ||
                  NVL(field13_,lpad(' ',8))  ||
                  NVL(field15i_,'   ') ||                 
                  field16_  ||
                  field17_  ||
                  NVL(field18_,lpad('0',11,'0'))  ||
                  field19_  ||
                  field20_  ||
                  NVL(field21_,lpad('0',11,'0'))  ||
                  field23_  ||
                  field24_  ||
                  field24i_ ||
                  CHR(13)   || CHR(10);      

               output_clob_ := output_clob_ || line_;
         END IF;   

         field4_s3_  := field4_s3_+1;

      END LOOP;
   END IF;   
   info_:= Client_SYS.Get_All_Info;   
END Create_Output;

-- Create_Output_From_Xml
--   Method fetches the intrastat data and formats it according to xml format.
PROCEDURE Create_Output_From_Xml (
   output_clob_          OUT CLOB,    
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,        
   intrastat_id_         IN  NUMBER,
   intrastat_direction_  IN  VARCHAR2 )
IS     
   company_distribution_info_rec_ Company_Distribution_Info_API.Public_Rec;   
   company_address_rec_    Company_Address_API.Public_Rec;
   contact_person_rec_     Person_Info_Address_API.Public_Rec;
   address_id_             VARCHAR2(50);
   line_                   VARCHAR2(32000);   
   vat_no_                 VARCHAR2(50);
   comp_address_id_        VARCHAR2(50);   
   curr_date_              DATE;
   date_                   VARCHAR2(8);
   time_of_day_            VARCHAR2(10);
   company_phone_          VARCHAR2(200);   
   company_email_          VARCHAR2(200);
   company_fax_            VARCHAR2(200);
   ref_period_             VARCHAR2(20);
   state_code_             VARCHAR2(2);
   currency_indicator_     VARCHAR2(1);   
   message_id_             VARCHAR2(2000);
   direction_type_         VARCHAR2(1);    
   state_presentation_db_  VARCHAR2(20); 
   state_name_             VARCHAR2(35);
   customs_state_          VARCHAR2(35);
   region_code_            VARCHAR2(10);
   branch_no_              VARCHAR2(3);   
   sender_party_id_        VARCHAR2(20);
   contact_person_name_    VARCHAR2(100);
   contact_person_phone_   VARCHAR2(200);
   contact_person_fax_     VARCHAR2(200);
   contact_person_email_   VARCHAR2(200);
   contact_person_address_id_ VARCHAR2(50);
   customs_address_rec_    Customs_Info_Address_API.Public_Rec;
                            
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
             country_code,
             company_contact
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_region_code (field_name_ VARCHAR2) IS
      SELECT region_code
      FROM country_region_tab
      WHERE country_code = 'DE'
      AND   region_name = field_name_;
      
   CURSOR get_line_data IS
      SELECT line_no, notc, order_unit_price, invoiced_unit_price
      FROM intrastat_line_tab
      WHERE intrastat_id = intrastat_id_
      AND   intrastat_direction = intrastat_direction_
      AND   rowstate     = 'Released';
BEGIN
   
   curr_date_ := SYSDATE;
   IF (intrastat_direction_ = 'EXPORT') THEN
      direction_type_      := 'D';
   ELSE
      -- import
      direction_type_      := 'A';
   END IF;
   FOR rec_ IN get_line_data LOOP      
      IF (rec_.notc IN (22,23,34)) THEN
         IF (rec_.order_unit_price = 0) THEN
            Error_SYS.Record_General(lu_name_, 'ORDERUNITPRICE: Net Price/Base cannot be zero for Intrastat Line No :P1 having NOTC :P2.', rec_.line_no, rec_.notc); 
         END IF;
         IF ((rec_.invoiced_unit_price != 0) OR (rec_.invoiced_unit_price IS NULL)) THEN   
            Error_SYS.Record_General(lu_name_, 'INVOICEDUNITPRICEZERO: Net Invoiced Price/Base should be zero for Intrastat Line No :P1 having NOTC :P2.', rec_.line_no, rec_.notc);
         END IF;
      END IF;

      IF (rec_.notc = 11) THEN
         IF ((NVL(rec_.invoiced_unit_price, 0) = 0) AND (rec_.order_unit_price = 0)) THEN   
            Error_SYS.Record_General(lu_name_, 'ZERONOTALLOWED: Net Invoiced Price/Base cannot be zero for Intrastat Line No :P1 having NOTC :P2.', rec_.line_no, rec_.notc);
         END IF;
      END IF;      
   END LOOP;     
   
   state_presentation_db_ := Enterp_Address_Country_API.Get_State_Presentation_Db('DE');   
   
   FOR headrec_ IN get_head LOOP 
      IF(headrec_.rep_curr_code = 'DEM') THEN
         currency_indicator_  := 1;
      ELSIF(headrec_.rep_curr_code = 'EUR') THEN
         currency_indicator_  := 2;
      ELSE
         Error_SYS.Record_General(lu_name_, 'NOTDEMEUR: Reporting currency should be DEM or EUR.');     
      END IF;          
       
      IF (headrec_.customs_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOCUSTOMSID: Customs ID is missing for Intrastat ID :P1.',intrastat_id_);    
      END IF; 
      
      address_id_    := Customs_Info_Address_API.Get_Default_Address(headrec_.customs_id,
                                                                     address_type_code_api.decode('INVOICE'),
                                                                     headrec_.creation_date);      
      
      IF (state_presentation_db_ IN ('NAMES', 'CODES')) THEN
         
         customs_state_ := Customs_Info_Address_API.Get_State(headrec_.customs_id, address_id_);
           
         IF (customs_state_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOCUSTOMSSTATE: State is missing for Customs ID :P1.', headrec_.customs_id);    
         END IF;
         
         state_name_ := '';
         IF (state_presentation_db_ = 'CODES') THEN
            state_name_ := State_Codes_API.Get_State_Name(headrec_.country_code, customs_state_ );
         END IF;

         OPEN get_region_code(NVL(state_name_, customs_state_)); 
         FETCH get_region_code INTO region_code_;
         CLOSE get_region_code;
         
         IF (region_code_ IS NULL) THEN
            -- No matching entry in region of origin.
            Error_SYS.Record_General(lu_name_, 'NOVALUEINORIGIN: Incorrect state code when generating files. Please check the state code/name of the address of the customs or delivery address of the sites.');
         END IF; 
         state_code_ := LPAD(SUBSTR(region_code_,1,2),2,'0');
      ELSE
         state_code_ := LPAD(SUBSTR(Customs_Info_Address_API.Get_State(headrec_.customs_id, address_id_),1,2),2,'0');

         IF (state_code_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOCUSTOMSSTATE: State is missing for Customs ID :P1.', headrec_.customs_id);    
         END IF;
      END IF;      
      
      company_distribution_info_rec_ := Company_Distribution_Info_API.Get(headrec_.company);
      vat_no_ := company_distribution_info_rec_.Intrastat_Tax_Number;

      IF (company_distribution_info_rec_.interchange_agreement_id IS NULL) THEN
         IF (Fnd_Session_API.Is_Odp_Session) THEN  -- Aurena client
            Error_SYS.Record_General(lu_name_, 'NOINTERCHANGEAGREEMENTID2: Interchange Agreement ID is missing for company :P1 in Supply Chain Information sub menu.',headrec_.company);
         ELSE -- IEE client
            Error_SYS.Record_General(lu_name_, 'NOINTERCHANGEAGREEMENTID: Interchange Agreement ID is missing for company :P1 in Distribution tab.',headrec_.company);
         END IF;
      END IF;
      
      IF (vat_no_ IS NULL) THEN
         Raise_No_Vat_No_Error___(headrec_.company);
      ELSE
         IF( SUBSTR(vat_no_, 1,2) = headrec_.country_code) THEN
            vat_no_    := RPAD(SUBSTR(vat_no_, 3, 11), 11, '0');
         ELSE
            vat_no_    := RPAD(SUBSTR(vat_no_, 1, 11), 11, '0');
         END IF;
      END IF; 
      
      branch_no_       := LPAD(SUBSTR(headrec_.bransch_no,1,3),3,'0');
      sender_party_id_ := state_code_||NVL(vat_no_,'00000000000')||NVL(branch_no_,'000');
      
      -- Customs address
      customs_address_rec_ := Customs_Info_Address_API.Get(headrec_.customs_id, address_id_);
      
      -- Company address
      comp_address_id_ := Company_Address_API.Get_Default_Address(headrec_.company, Address_Type_Code_API.Decode('INVOICE'));
      
      IF (comp_address_id_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOCOMPADDR: There is no default invoice address for the company.');
      END IF;
      company_address_rec_ := Company_Address_API.Get(headrec_.company, comp_address_id_);      
      company_phone_       := Comm_Method_API.Get_Value('COMPANY', headrec_.company, Comm_Method_Code_API.Decode('PHONE'), 1, comp_address_id_, curr_date_);      
      company_email_       := Comm_Method_API.Get_Value('COMPANY', headrec_.company, Comm_Method_Code_API.Decode('E_MAIL'), 1, comp_address_id_, curr_date_);
      company_fax_         := Comm_Method_API.Get_Value('COMPANY', headrec_.company, Comm_Method_Code_API.Decode('FAX'), 1, comp_address_id_, curr_date_);
      ref_period_          := TO_CHAR(headrec_.end_date,'YYYY') || TO_CHAR(headrec_.end_date,'MM');
      date_                := TO_CHAR(curr_date_,'YYYY') || TO_CHAR(curr_date_,'MM') || TO_CHAR(curr_date_,'DD');
      time_of_day_         := TO_CHAR(curr_date_,'HH') || TO_CHAR(curr_date_,'MI');
      message_id_          := company_distribution_info_rec_.interchange_agreement_id || '-' || ref_period_ || '-' || date_ || '-' || time_of_day_; 
   
      IF (headrec_.company_contact IS NOT NULL) THEN
         contact_person_address_id_ := Person_Info_Address_API.Get_Default_Address(headrec_.company_contact, Address_Type_Code_API.Decode('CORRESPONDENCE'));
         contact_person_name_  := Person_Info_API.Get_Name(headrec_.company_contact);
         contact_person_rec_   := Person_Info_Address_API.Get(headrec_.company_contact, contact_person_address_id_);
         contact_person_phone_ := Comm_Method_API.Get_Value('PERSON', headrec_.company_contact, Comm_Method_Code_API.Decode('PHONE'), 1, contact_person_address_id_, curr_date_); 
         contact_person_fax_   := Comm_Method_API.Get_Value('PERSON', headrec_.company_contact, Comm_Method_Code_API.Decode('FAX'), 1, contact_person_address_id_, curr_date_);   
         contact_person_email_ := Comm_Method_API.Get_Value('PERSON', headrec_.company_contact, Comm_Method_Code_API.Decode('E_MAIL'), 1, contact_person_address_id_, curr_date_);
      END IF;   
      
      -- Creation of the XML part
      -- Constructing the Envelope.
      line_ := '<?xml version = "1.0" encoding = "ISO-8859-1"?>'|| CHR(13) || CHR(10);
      output_clob_ := line_;

      line_ := '<INSTAT xmlns:xsd="http://www.w3.org/2001/XMLSchema">' || CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;

      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('<Envelope>',         '',                                    line_);
      Client_SYS.Add_To_Attr('<envelopeId>',       message_id_,                           line_);
      Client_SYS.Add_To_Attr('</envelopeId>',      '',                                    line_);
      Client_SYS.Add_To_Attr('<DateTime>',         '',                                    line_);
         Client_SYS.Add_To_Attr('<date>',          TO_CHAR(curr_date_,'YYYY')||'-'||TO_CHAR(curr_date_,'MM')||'-'||TO_CHAR(curr_date_,'DD'), line_);
         Client_SYS.Add_To_Attr('</date>',         '',                                    line_);
         Client_SYS.Add_To_Attr('<time>',          TO_CHAR(curr_date_,'HH')||':'||TO_CHAR(curr_date_,'MI')||':'||TO_CHAR(curr_date_,'SS'),   line_);
         Client_SYS.Add_To_Attr('</time>',         '',                                    line_);
      Client_SYS.Add_To_Attr('</DateTime>',        '',                                    line_);
      Client_SYS.Add_To_Attr('<Party partyType="CC" partyRole="receiver">', '',           line_);
         Client_SYS.Add_To_Attr('<partyId>',       '00',                                  line_);
         Client_SYS.Add_To_Attr('</partyId>',      '',                                    line_);
         Client_SYS.Add_To_Attr('<partyName>',     Customs_Info_API.Get_Name(headrec_.customs_id),          line_);
         Client_SYS.Add_To_Attr('</partyName>',    '',                                    line_);
         Client_SYS.Add_To_Attr('<Address>',       '',                                    line_);
            Client_SYS.Add_To_Attr('<streetName>',     customs_address_rec_.address1,     line_);
            Client_SYS.Add_To_Attr('</streetName>',    '',                                line_);            
            Client_SYS.Add_To_Attr('<postalCode>',     customs_address_rec_.zip_code,     line_);
            Client_SYS.Add_To_Attr('</postalCode>',    '',                                line_);
            Client_SYS.Add_To_Attr('<cityName>',       customs_address_rec_.city,         line_);
            Client_SYS.Add_To_Attr('</cityName>',      '',                                line_);            
         Client_SYS.Add_To_Attr('</Address>',          '',                                line_);
      Client_SYS.Add_To_Attr('</Party>',           '',                                    line_);
      Client_SYS.Add_To_Attr('<Party partyType="PSI" partyRole="sender">', '',            line_);
         Client_SYS.Add_To_Attr('<partyId>',       sender_party_id_,                      line_); -- region_code + Vat_no + Branch no
         Client_SYS.Add_To_Attr('</partyId>',      '',                                    line_);
         Client_SYS.Add_To_Attr('<partyName>',     Company_API.Get_Name(headrec_.company),line_);
         Client_SYS.Add_To_Attr('</partyName>',    '',                                    line_);
         Client_SYS.Add_To_Attr('<interchangeAgreementId>',     company_distribution_info_rec_.interchange_agreement_id,            line_);
         Client_SYS.Add_To_Attr('</interchangeAgreementId>',    '',                       line_);
         Client_SYS.Add_To_Attr('<Address>',       '',                                    line_);
            Client_SYS.Add_To_Attr('<streetName>',     company_address_rec_.address1,     line_);
            Client_SYS.Add_To_Attr('</streetName>',    '',                                line_);            
            Client_SYS.Add_To_Attr('<postalCode>',     company_address_rec_.zip_code,     line_);
            Client_SYS.Add_To_Attr('</postalCode>',    '',                                line_);
            Client_SYS.Add_To_Attr('<cityName>',       company_address_rec_.city,         line_);
            Client_SYS.Add_To_Attr('</cityName>',      '',                                line_);
            Client_SYS.Add_To_Attr('<countryName>',    Company_Address_API.Get_Country(headrec_.company, comp_address_id_), line_);
            Client_SYS.Add_To_Attr('</countryName>',   '',                                line_);
            Client_SYS.Add_To_Attr('<phoneNumber>',    company_phone_,                    line_);
            Client_SYS.Add_To_Attr('</phoneNumber>',   '',                                line_);
            Client_SYS.Add_To_Attr('<faxNumber>',      company_fax_,                      line_);
            Client_SYS.Add_To_Attr('</faxNumber>',     '',                                line_);
            Client_SYS.Add_To_Attr('<email>',          company_email_,                    line_);
            Client_SYS.Add_To_Attr('</email>',         '',                                line_);
         Client_SYS.Add_To_Attr('</Address>',          '',                                line_);
         Client_SYS.Add_To_Attr('<ContactPerson>',             '',                                             line_);
            Client_SYS.Add_To_Attr('<contactPersonName>',      contact_person_name_,                           line_);
            Client_SYS.Add_To_Attr('</contactPersonName>',     '',                                             line_);
            Client_SYS.Add_To_Attr('<Address>',       '',                                    line_);
               Client_SYS.Add_To_Attr('<streetName>',     contact_person_rec_.address1,     line_);
               Client_SYS.Add_To_Attr('</streetName>',    '',                                line_);               
               Client_SYS.Add_To_Attr('<postalCode>',     contact_person_rec_.zip_code,     line_);
               Client_SYS.Add_To_Attr('</postalCode>',    '',                                line_);
               Client_SYS.Add_To_Attr('<cityName>',       contact_person_rec_.city,         line_);
               Client_SYS.Add_To_Attr('</cityName>',      '',                                line_);
               Client_SYS.Add_To_Attr('<countryName>',    Person_Info_Address_API.Get_Country(headrec_.company_contact, contact_person_address_id_),            line_);
               Client_SYS.Add_To_Attr('</countryName>',   '',                                line_);
               Client_SYS.Add_To_Attr('<phoneNumber>',    contact_person_phone_,             line_);
               Client_SYS.Add_To_Attr('</phoneNumber>',   '',                                line_);
               Client_SYS.Add_To_Attr('<faxNumber>',      contact_person_fax_,               line_);
               Client_SYS.Add_To_Attr('</faxNumber>',     '',                                line_);
               Client_SYS.Add_To_Attr('<email>',          contact_person_email_,             line_);
               Client_SYS.Add_To_Attr('</email>',         '',                                line_);
         Client_SYS.Add_To_Attr('</Address>',          '',                                line_);
         Client_SYS.Add_To_Attr('</ContactPerson>',            '',                                             line_);
      Client_SYS.Add_To_Attr('</Party>',               '',                                line_);
      Client_SYS.Add_To_Attr('<softwareUsed>',         'IFS Applications',                line_);
      Client_SYS.Add_To_Attr('</softwareUsed>',        '',                                line_);
      Create_Line___(output_clob_, line_);
   
      
      line_ := '<Declaration>' || CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;

      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('<declarationId>',       message_id_,                        line_);
      Client_SYS.Add_To_Attr('</declarationId>',      '',                                 line_);
      Client_SYS.Add_To_Attr('<DateTime>',            '',                                 line_);
         Client_SYS.Add_To_Attr('<date>',             TO_CHAR(curr_date_,'YYYY')||'-'||TO_CHAR(curr_date_,'MM')||'-'||TO_CHAR(curr_date_,'DD'),  line_);
         Client_SYS.Add_To_Attr('</date>',            '',                                 line_);
         Client_SYS.Add_To_Attr('<time>',             TO_CHAR(curr_date_,'HH')||':'||TO_CHAR(curr_date_,'MI')||':'||TO_CHAR(curr_date_,'SS'),    line_);
         Client_SYS.Add_To_Attr('</time>',            '',                                 line_);
      Client_SYS.Add_To_Attr('</DateTime>',           '',                                 line_);
      Client_SYS.Add_To_Attr('<referencePeriod>',     TO_CHAR(headrec_.end_date,'YYYY') || '-' || TO_CHAR(headrec_.end_date,'MM'),               line_);
      Client_SYS.Add_To_Attr('</referencePeriod>',    '',                                 line_);
      Client_SYS.Add_To_Attr('<PSIId>',               sender_party_id_,                   line_);
      Client_SYS.Add_To_Attr('</PSIId>',              '',                                 line_);      
      Client_SYS.Add_To_Attr('<Function>',            '',                                 line_);
         Client_SYS.Add_To_Attr('<functionCode>',     'O',                                line_);
         Client_SYS.Add_To_Attr('</functionCode>',    '',                                 line_);
      Client_SYS.Add_To_Attr('</Function>',           '',                                 line_);
      Client_SYS.Add_To_Attr('<flowCode>',            direction_type_,                    line_);
      Client_SYS.Add_To_Attr('</flowCode>',           '',                                 line_);
      Client_SYS.Add_To_Attr('<currencyCode>',        currency_indicator_,                line_);
      Client_SYS.Add_To_Attr('</currencyCode>',       '',                                 line_);      
      Create_Line___(output_clob_, line_);
   
   
      -- Items
      Create_Details__(output_clob_,
                       intrastat_id_,
                       intrastat_direction_,
                       headrec_.rep_curr_rate,
                       headrec_.country_code);
                          
      line_ := '</Declaration>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
   END LOOP;     -- Head Ends
   
   -- Ampersand sign was replaced with CHR(38) inorder to avoid deployment issue.   
   output_clob_ := REPLACE(output_clob_, CHR(38), CHR(38)||'amp;'); 
   
   Client_SYS.Clear_Attr(line_);   
   Client_SYS.Add_To_Attr('</Envelope>',         '',                                       line_);
   Client_SYS.Add_To_Attr('</INSTAT>',           '',                                       line_);

   Create_Line___(output_clob_, line_);
   
END Create_Output_From_Xml;



