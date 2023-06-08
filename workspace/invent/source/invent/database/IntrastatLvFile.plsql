-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatLvFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211129  ErFelk  Bug 161322(SC21R2-5666), Added opponent_tax_id and country_of_origin to Export. Limited customs_stat_no to 8 digit.
--  200501  ErFelk  Bug 153598(SCZ-9687), Created Intrastat file for country Latvia.
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


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Output
--   Method fetches the intrastat data and formats it according to
--   specifications for Latvia.
PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2,
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2 )
IS     
   line_                 VARCHAR2(32000);   
   simplified_code_      VARCHAR2(12);
   rep_curr_rate_        NUMBER;    
   intrastat_direction_  VARCHAR2(10);
   notc_dummy_           VARCHAR2(5);
   ref_period_year_      VARCHAR2(4);
   ref_period_month_     VARCHAR2(3);
   company_address_      VARCHAR2(2000);
   association_no_       VARCHAR2(50);
   contact_person_first_name_ VARCHAR2(100);
   contact_person_last_name_  VARCHAR2(100);
   total_line_count_       NUMBER := 0;  
   page_break_             NUMBER := 1;
   lines_in_page_          NUMBER := 0;
   code_                   VARCHAR2(6);
   comp_address_id_        VARCHAR2(50);
   company_phone_          VARCHAR2(200);   
   company_email_          VARCHAR2(200);
   company_fax_            VARCHAR2(200);
   contact_person_phone_          VARCHAR2(200);   
   contact_person_email_          VARCHAR2(200);   
   contact_person_address_id_ VARCHAR2(50);
   
   -- Get all the header details
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
   
   -- Get all the line details
   
   CURSOR get_lines IS
      SELECT i.intrastat_direction,
             SUBSTR(i.customs_stat_no, 1, 8)                                  customs_stat_no, 
             i.country_of_origin,
             i.opposite_country,             
             cn.country_notc,
             SUM((NVL(i.invoiced_unit_price, NVL(i.order_unit_price,0)) + 
                  NVL(i.unit_add_cost_amount_inv, NVL(i.unit_add_cost_amount,0))) * i.quantity) * rep_curr_rate_ invoice_amount,
             SUM(i.quantity * i.net_unit_weight) net_weight_sum,
			    SUM(NVL(ABS(i.intrastat_alt_qty),0)* i.quantity) alternative_qty,
             DECODE(i.intrastat_direction, 'EXPORT', i.opponent_tax_id, '')  opponent_tax_id
      FROM   intrastat_line_tab i ,country_notc_tab cn
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    rowstate           != 'Cancelled'
      AND    i.notc = cn.notc      
      AND    cn.country_code = 'LV'
      GROUP BY  i.intrastat_direction,
                SUBSTR(i.customs_stat_no, 1, 8),                
                i.country_of_origin,
				    i.opposite_country,               
                cn.country_notc,
                DECODE(i.intrastat_direction, 'EXPORT', i.opponent_tax_id, '');
                
   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'LV'; 
     
BEGIN
   
   IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
       Error_SYS.Record_General(lu_name_, 'NOTBOTHBE: You can only create an import or export file at the time, not both at the same time');   
   ELSIF (intrastat_export_ = 'EXPORT' AND intrastat_import_ IS NULL) THEN
      intrastat_direction_ := intrastat_export_;
      simplified_code_   := 'Izvedums-2A';
   ELSIF (intrastat_export_ IS NULL AND intrastat_import_ = 'IMPORT') THEN
      intrastat_direction_ := intrastat_import_;
      simplified_code_   := 'Ievedums-1A';
   ELSE -- both is null
      Error_SYS.Record_General(lu_name_, 'DIRECTIONSNULLBE: At least one transfer option must be checked');
   END IF;

   FOR notc_rec_ IN get_notc LOOP
      OPEN get_country_notc(notc_rec_.notc);
      FETCH get_country_notc INTO notc_dummy_;
      IF (get_country_notc%NOTFOUND) THEN
         CLOSE get_country_notc;
         Error_SYS.Record_General(lu_name_, 'NOCOUNTRYNOTCBE: This country is missing an entry for NOTC :P1 in table COUNTRY_NOTC_TAB. Contact your system administrator.', notc_rec_.notc);   
      END IF;        
      CLOSE get_country_notc;  
   END LOOP;   
  
   FOR headrec_ IN get_head LOOP
      IF (headrec_.rep_curr_code NOT IN ('EUR')) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCURRBE: Reporting currency should be EUR.');
      END IF;   
      rep_curr_rate_ := headrec_.rep_curr_rate;
       -- Company address
      comp_address_id_ := Company_Address_API.Get_Default_Address(headrec_.company, Address_Type_Code_API.Decode('INVOICE'));
      
      IF (comp_address_id_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOCOMPADDR: There is no default invoice address for the company.');
      END IF;
      association_no_  := Company_API.Get_Association_No(headrec_.company);
      IF (association_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOASSOCIATIONNOLV: Association number is missing for company :P1.', headrec_.company);
      END IF;
      company_address_ := Company_Address_API.Get_Address(headrec_.company, comp_address_id_);      
      company_phone_       := Comm_Method_API.Get_Value('COMPANY', headrec_.company, Comm_Method_Code_API.Decode('PHONE'), 1, comp_address_id_, SYSDATE);      
      company_email_       := Comm_Method_API.Get_Value('COMPANY', headrec_.company, Comm_Method_Code_API.Decode('E_MAIL'), 1, comp_address_id_, SYSDATE);
      company_fax_         := Comm_Method_API.Get_Value('COMPANY', headrec_.company, Comm_Method_Code_API.Decode('FAX'), 1, comp_address_id_, SYSDATE);
      ref_period_year_     := TO_CHAR(headrec_.end_date,'YYYY'); 
      ref_period_month_    := 'M' || TO_CHAR(headrec_.end_date,'MM');   
   
      IF (headrec_.company_contact IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOPERSONLV: Company contact is missing for company :P1.', headrec_.company);  
      ELSE        
         contact_person_address_id_ := Person_Info_Address_API.Get_Default_Address(headrec_.company_contact, Address_Type_Code_API.Decode('CORRESPONDENCE'));
         contact_person_first_name_  := Person_Info_API.Get_First_Name(headrec_.company_contact);
         contact_person_last_name_   := Person_Info_API.Get_Last_Name(headrec_.company_contact);         
         contact_person_phone_ := Comm_Method_API.Get_Value('PERSON', headrec_.company_contact, Comm_Method_Code_API.Decode('PHONE'), 1, contact_person_address_id_, SYSDATE);          
         contact_person_email_ := Comm_Method_API.Get_Value('PERSON', headrec_.company_contact, Comm_Method_Code_API.Decode('E_MAIL'), 1, contact_person_address_id_, SYSDATE);       
      END IF;
      
      -- Creation of the XML part      
      line_ := '<?xml version="1.0" encoding="UTF-8"?>'|| CHR(13) || CHR(10);
      output_clob_ := line_;

      line_ := '<Survey xsi:schemaLocation="https://eparskats.csb.gov.lv/eSurvey/XMLSchemas/Survey/v1-0 Survey.xsd" xmlns="https://eparskats.csb.gov.lv/eSurvey/XMLSchemas/Survey/v1-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' || CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
      
      
      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('<RespondentInfo>',     '',         line_);
         Client_SYS.Add_To_Attr('<RegistrationNumber>', association_no_ ,         line_);
         Client_SYS.Add_To_Attr('</RegistrationNumber>',     '',         line_);
         Client_SYS.Add_To_Attr('<Name>', Company_API.Get_Name(headrec_.company) ,         line_);
         Client_SYS.Add_To_Attr('</Name>',     '',         line_);
         Client_SYS.Add_To_Attr('<LegalAddress>', company_address_ ,         line_);
         Client_SYS.Add_To_Attr('</LegalAddress>',     '',         line_);
         Client_SYS.Add_To_Attr('<ContactAddress>', company_address_ ,         line_);
         Client_SYS.Add_To_Attr('</ContactAddress>',     '',         line_);
         Client_SYS.Add_To_Attr('<Phone>',    company_phone_,                    line_);
         Client_SYS.Add_To_Attr('</Phone>',   '',                                line_);
         Client_SYS.Add_To_Attr('<Fax>', company_fax_,                      line_);
         Client_SYS.Add_To_Attr('</Fax>',         '',                                line_);      
         Client_SYS.Add_To_Attr('<Email>', company_email_,                    line_);
         Client_SYS.Add_To_Attr('</Email>',         '',                                line_);
         Client_SYS.Add_To_Attr('<Submitter>', '', line_);
         Client_SYS.Add_To_Attr('<FirstName>', contact_person_first_name_, line_);
         Client_SYS.Add_To_Attr('</FirstName>', '', line_);
         Client_SYS.Add_To_Attr('<LastName>', contact_person_last_name_, line_);
         Client_SYS.Add_To_Attr('</LastName>', '', line_);
         Client_SYS.Add_To_Attr('<Phone>', contact_person_phone_, line_);
         Client_SYS.Add_To_Attr('</Phone>', '', line_);
         Client_SYS.Add_To_Attr('<Email>', contact_person_email_, line_);
         Client_SYS.Add_To_Attr('</Email>', '', line_);
         Client_SYS.Add_To_Attr('</Submitter>', '', line_);
      Client_SYS.Add_To_Attr('</RespondentInfo>',     '',        line_); 
      Client_SYS.Add_To_Attr('<SurveyInfo>',     '',         line_);
         Client_SYS.Add_To_Attr('<Code>', simplified_code_, line_);
         Client_SYS.Add_To_Attr('</Code>', '', line_);
         Client_SYS.Add_To_Attr('<Period>', '', line_);
            Client_SYS.Add_To_Attr('<Year>', ref_period_year_, line_);
            Client_SYS.Add_To_Attr('</Year>', '', line_);
            Client_SYS.Add_To_Attr('<Month>', ref_period_month_, line_);
            Client_SYS.Add_To_Attr('</Month>', '', line_);
         Client_SYS.Add_To_Attr('</Period>', '', line_);
      Client_SYS.Add_To_Attr('</SurveyInfo>',     '',         line_);
      Create_Line___(output_clob_, line_);
      
      Client_SYS.Clear_Attr(line_);
      line_ := '<CellValueList>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
      
      -- Intrastat line details
      FOR linerec_ IN get_lines LOOP

         total_line_count_ := total_line_count_ + 1 ;
         lines_in_page_    := lines_in_page_ + 1;
         IF (lines_in_page_ > 15) THEN
            page_break_ := page_break_ + 1;
            lines_in_page_ := 1;
         END IF;  
         
         code_ := LPAD(page_break_, 3, '0')||'/'||LPAD(lines_in_page_, 2, '0');
         
         IF (intrastat_direction_ = 'IMPORT') THEN             
            IF (linerec_.country_of_origin IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'MISSINGCOUNTRYOFORIGIONBE: Country of Origin is missing for some lines.');
            END IF;
         END IF;
         IF (linerec_.customs_stat_no IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOSTATNUMBERLV: The customs statistics number must be specified for intrastat reporting.');   
         END IF;         
         
         Client_SYS.Clear_Attr(line_);
         Client_SYS.Add_To_Attr('<CellValue>',     '',         line_);
            Client_SYS.Add_To_Attr('<RowNumber>',     '1',         line_); 
            Client_SYS.Add_To_Attr('</RowNumber>',     '',         line_);
            Client_SYS.Add_To_Attr('<ColumnNumber>',     'A',         line_); 
            Client_SYS.Add_To_Attr('</ColumnNumber>',     '',         line_);
            Client_SYS.Add_To_Attr('<Value>',     linerec_.customs_stat_no,         line_); 
            Client_SYS.Add_To_Attr('</Value>',     '',         line_);
            Client_SYS.Add_To_Attr('<Code>',    code_ ,         line_);
            Client_SYS.Add_To_Attr('</Code>',     '',         line_);
            Client_SYS.Add_To_Attr('<Mark>',     'false',         line_); 
            Client_SYS.Add_To_Attr('</Mark>',     '',         line_);
         Client_SYS.Add_To_Attr('</CellValue>',     '',         line_);
         
         Client_SYS.Add_To_Attr('<CellValue>',     '',         line_);
            Client_SYS.Add_To_Attr('<RowNumber>',     '1',         line_); 
            Client_SYS.Add_To_Attr('</RowNumber>',     '',         line_);
            Client_SYS.Add_To_Attr('<ColumnNumber>',     'B',         line_); 
            Client_SYS.Add_To_Attr('</ColumnNumber>',     '',         line_);
            Client_SYS.Add_To_Attr('<Value>',     ROUND(linerec_.invoice_amount),         line_); 
            Client_SYS.Add_To_Attr('</Value>',     '',         line_);
            Client_SYS.Add_To_Attr('<Code>',     code_,         line_);
            Client_SYS.Add_To_Attr('</Code>',     '',         line_);
            Client_SYS.Add_To_Attr('<Mark>',     'false',         line_); 
            Client_SYS.Add_To_Attr('</Mark>',     '',         line_);
         Client_SYS.Add_To_Attr('</CellValue>',     '',         line_);
         
         Client_SYS.Add_To_Attr('<CellValue>',     '',         line_);
            Client_SYS.Add_To_Attr('<RowNumber>',     '1',         line_); 
            Client_SYS.Add_To_Attr('</RowNumber>',     '',         line_);
            Client_SYS.Add_To_Attr('<ColumnNumber>',     'C',         line_); 
            Client_SYS.Add_To_Attr('</ColumnNumber>',     '',         line_);
            Client_SYS.Add_To_Attr('<Value>',     ROUND(linerec_.net_weight_sum),         line_); 
            Client_SYS.Add_To_Attr('</Value>',     '',         line_);
            Client_SYS.Add_To_Attr('<Code>',     code_,         line_);
            Client_SYS.Add_To_Attr('</Code>',     '',         line_);
            Client_SYS.Add_To_Attr('<Mark>',     'false',         line_); 
            Client_SYS.Add_To_Attr('</Mark>',     '',         line_);
         Client_SYS.Add_To_Attr('</CellValue>',     '',         line_);
         
         Client_SYS.Add_To_Attr('<CellValue>',     '',         line_);
            Client_SYS.Add_To_Attr('<RowNumber>',     '1',         line_); 
            Client_SYS.Add_To_Attr('</RowNumber>',     '',         line_);
            Client_SYS.Add_To_Attr('<ColumnNumber>',     'D',         line_); 
            Client_SYS.Add_To_Attr('</ColumnNumber>',     '',         line_);
            Client_SYS.Add_To_Attr('<Value>',     NVL(linerec_.alternative_qty,0),         line_); 
            Client_SYS.Add_To_Attr('</Value>',     '',         line_);
            Client_SYS.Add_To_Attr('<Code>',     code_,         line_);
            Client_SYS.Add_To_Attr('</Code>',     '',         line_);
            Client_SYS.Add_To_Attr('<Mark>',     'false',         line_); 
            Client_SYS.Add_To_Attr('</Mark>',     '',         line_);
         Client_SYS.Add_To_Attr('</CellValue>',     '',         line_);
         
         Client_SYS.Add_To_Attr('<CellValue>',     '',         line_);
            Client_SYS.Add_To_Attr('<RowNumber>',     '1',         line_); 
            Client_SYS.Add_To_Attr('</RowNumber>',     '',         line_);
            Client_SYS.Add_To_Attr('<ColumnNumber>',     'E',         line_); 
            Client_SYS.Add_To_Attr('</ColumnNumber>',     '',         line_);
            Client_SYS.Add_To_Attr('<Value>',     linerec_.opposite_country,         line_); 
            Client_SYS.Add_To_Attr('</Value>',     '',         line_);
            Client_SYS.Add_To_Attr('<Code>',     code_,         line_);
           Client_SYS.Add_To_Attr('</Code>',     '',         line_);
            Client_SYS.Add_To_Attr('<Mark>',     'false',         line_); 
            Client_SYS.Add_To_Attr('</Mark>',     '',         line_);
         Client_SYS.Add_To_Attr('</CellValue>',     '',         line_);
         
         IF (intrastat_direction_ = 'IMPORT') THEN
            Client_SYS.Add_To_Attr('<CellValue>',     '',         line_);
               Client_SYS.Add_To_Attr('<RowNumber>',     '1',         line_); 
               Client_SYS.Add_To_Attr('</RowNumber>',     '',         line_);
               Client_SYS.Add_To_Attr('<ColumnNumber>',     'F',         line_); 
               Client_SYS.Add_To_Attr('</ColumnNumber>',     '',         line_);
               Client_SYS.Add_To_Attr('<Value>',     linerec_.country_of_origin,         line_); 
               Client_SYS.Add_To_Attr('</Value>',     '',         line_);
               Client_SYS.Add_To_Attr('<Code>',     code_,         line_);
               Client_SYS.Add_To_Attr('</Code>',     '',         line_);
               Client_SYS.Add_To_Attr('<Mark>',     'false',         line_); 
               Client_SYS.Add_To_Attr('</Mark>',     '',         line_);
            Client_SYS.Add_To_Attr('</CellValue>',     '',         line_); 

           Client_SYS.Add_To_Attr('<CellValue>',     '',         line_);
               Client_SYS.Add_To_Attr('<RowNumber>',     '1',         line_); 
               Client_SYS.Add_To_Attr('</RowNumber>',     '',         line_);
               Client_SYS.Add_To_Attr('<ColumnNumber>',     'G',         line_); 
               Client_SYS.Add_To_Attr('</ColumnNumber>',     '',         line_);
               Client_SYS.Add_To_Attr('<Value>',     linerec_.country_notc,         line_); 
               Client_SYS.Add_To_Attr('</Value>',     '',         line_);
               Client_SYS.Add_To_Attr('<Code>',     code_,         line_);
               Client_SYS.Add_To_Attr('</Code>',     '',         line_);
               Client_SYS.Add_To_Attr('<Mark>',     'false',         line_); 
               Client_SYS.Add_To_Attr('</Mark>',     '',         line_);
            Client_SYS.Add_To_Attr('</CellValue>',     '',         line_);
         ELSE
            Client_SYS.Add_To_Attr('<CellValue>',     '',         line_);
               Client_SYS.Add_To_Attr('<RowNumber>',     '1',         line_); 
               Client_SYS.Add_To_Attr('</RowNumber>',     '',         line_);
               Client_SYS.Add_To_Attr('<ColumnNumber>',     'F',         line_); 
               Client_SYS.Add_To_Attr('</ColumnNumber>',     '',         line_);
               Client_SYS.Add_To_Attr('<Value>',     linerec_.country_notc,         line_); 
               Client_SYS.Add_To_Attr('</Value>',     '',         line_);
               Client_SYS.Add_To_Attr('<Code>',     code_,         line_);
               Client_SYS.Add_To_Attr('</Code>',     '',         line_);
               Client_SYS.Add_To_Attr('<Mark>',     'false',         line_); 
               Client_SYS.Add_To_Attr('</Mark>',     '',         line_);
            Client_SYS.Add_To_Attr('</CellValue>',     '',         line_);
            
            Client_SYS.Add_To_Attr('<CellValue>',     '',         line_);
               Client_SYS.Add_To_Attr('<RowNumber>',     '1',         line_); 
               Client_SYS.Add_To_Attr('</RowNumber>',     '',         line_);
               Client_SYS.Add_To_Attr('<ColumnNumber>',     'G',         line_); 
               Client_SYS.Add_To_Attr('</ColumnNumber>',     '',         line_);
               Client_SYS.Add_To_Attr('<Value>',     linerec_.country_of_origin,         line_); 
               Client_SYS.Add_To_Attr('</Value>',     '',         line_);
               Client_SYS.Add_To_Attr('<Code>',     code_,         line_);
               Client_SYS.Add_To_Attr('</Code>',     '',         line_);
               Client_SYS.Add_To_Attr('<Mark>',     'false',         line_); 
               Client_SYS.Add_To_Attr('</Mark>',     '',         line_);
            Client_SYS.Add_To_Attr('</CellValue>',     '',         line_);   
               
            Client_SYS.Add_To_Attr('<CellValue>',     '',         line_);
               Client_SYS.Add_To_Attr('<RowNumber>',     '1',         line_); 
               Client_SYS.Add_To_Attr('</RowNumber>',     '',         line_);
               Client_SYS.Add_To_Attr('<ColumnNumber>',     'H',         line_); 
               Client_SYS.Add_To_Attr('</ColumnNumber>',     '',         line_);
               Client_SYS.Add_To_Attr('<Value>',     linerec_.opponent_tax_id,         line_); 
               Client_SYS.Add_To_Attr('</Value>',     '',         line_);
               Client_SYS.Add_To_Attr('<Code>',     code_,         line_);
               Client_SYS.Add_To_Attr('</Code>',     '',         line_);
               Client_SYS.Add_To_Attr('<Mark>',     'false',         line_); 
               Client_SYS.Add_To_Attr('</Mark>',     '',         line_);
            Client_SYS.Add_To_Attr('</CellValue>',     '',         line_);            
         END IF;  
         
         Create_Line___(output_clob_, line_);
               
      END LOOP;  
      Client_SYS.Clear_Attr(line_);
  
      Client_SYS.Add_To_Attr('<CellValue>',     '',         line_);
               Client_SYS.Add_To_Attr('<RowNumber>',     'Rsk',         line_); 
               Client_SYS.Add_To_Attr('</RowNumber>',     '',         line_); 
                  Client_SYS.Add_To_Attr('<ColumnNumber>',     '1',         line_); 
               Client_SYS.Add_To_Attr('</ColumnNumber>',     '',         line_);
         Client_SYS.Add_To_Attr('<Value>',     total_line_count_,         line_); 
         Client_SYS.Add_To_Attr('</Value>',     '',         line_);         
         Client_SYS.Add_To_Attr('<Mark>',     'false',         line_); 
         Client_SYS.Add_To_Attr('</Mark>',     '',         line_);
      Client_SYS.Add_To_Attr('</CellValue>',     '',         line_);    

      Create_Line___(output_clob_, line_);
      
      line_ := '</CellValueList>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
      line_ := '</Survey>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
   END LOOP;   
   
   info_ := Client_SYS.Get_All_Info;

END Create_Output;
