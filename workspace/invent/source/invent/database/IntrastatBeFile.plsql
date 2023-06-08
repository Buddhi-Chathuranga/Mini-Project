-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatBeFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190507  ErFelk  Bug 145499(SCZ-2992), Converted the file to generate in xml. Added new fields DELIVERY_TERMS, REGION_CODE,
--  190507          COUNTRY_OF_ORIGIN and OPPONENT_TAX_ID. Removed the charge amounts from the invoice value calculation in get_lines cursor.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130731  MaRalk  TIBE-840, Removed global LU constant inst_TaxLiabilityCountries_ and modified Create_Output 
--  130731          using conditional compilation instead.
--  110309  Bmekse  DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                  inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203  Elarse  Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise  Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090529  SaWjlk  Bug 83173, Removed the prog text duplications.
----------------------------------13.4.0-------------------------------------
--  060120  NiDalk  Added Assert safe annotation. 
--  040227  GeKalk  Replaced substrb with substr for UNICODE modifications.
------------------- EDGE Package Group 3 Unicode Changes --------------------
--  040123  NaWalk Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.  
--  020312  DaZa   Bug fix 28308, added ABS on intrastat_alt_qty so we dont get "-x * -y results" when we multiply with the regular qty.
--  011214  DaZa   Bug fix 26454, corrected several erroneus NVL-statements that 
--                 caused a numerical value error. Corrected several other rows 
--                 where this error could arise, by adding extra substrb.
--  010411 DaJoLK Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and 
--                TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  010320  GEKALK  Some corrections and some error messages added.
--  010315  GEKALK  Created
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
--   specifications for Belgium.
PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2,
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2 )
IS     
   dummy_                VARCHAR2(5);
   line_                 VARCHAR2(32000);   
   vat_no_               VARCHAR2(50);
   rep_curr_rate_        NUMBER;    
   intrastat_direction_  VARCHAR2(10);
   notc_dummy_           VARCHAR2(5);   
   declaration_report_   VARCHAR2(14);
   declaration_form_     VARCHAR2(14);
   direction_type_       VARCHAR2(2);
   report_date_          VARCHAR2(7);
   
   -- Get all the header details
   CURSOR get_head IS
      SELECT company,
             bransch_no,
             representative,
             repr_tax_no,
             bransch_no_repr,
             begin_date,
             end_date,
             creation_date,
             rep_curr_code,
             rep_curr_rate,
             country_code
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;
   
   -- Get all the line details
   --             Removed the charge amounts from the invoice value calculation.
   CURSOR get_lines IS
      SELECT i.intrastat_direction,
             i.customs_stat_no,
             i.region_of_origin,
             DECODE(i.intrastat_direction, 'EXPORT', i.country_of_origin, '')  country_of_origin,
             i.opposite_country,
             i.mode_of_transport,
             cn.country_notc,
             SUM((NVL(i.invoiced_unit_price, NVL(i.order_unit_price,0)) + 
                  NVL(i.unit_add_cost_amount_inv, NVL(i.unit_add_cost_amount,0))) * i.quantity) * rep_curr_rate_ invoice_value,
             SUM(i.quantity * i.net_unit_weight) weight,
			    SUM(NVL(ABS(i.intrastat_alt_qty),0)* i.quantity) alternative_qty,
             DECODE(i.intrastat_direction, 'EXPORT', i.opponent_tax_id, '')  opponent_tax_id,
             i.delivery_terms
      FROM   intrastat_line_tab i ,country_notc_tab cn
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction = intrastat_direction_
      AND    rowstate           != 'Cancelled'
      AND    i.notc = cn.notc      
      AND    cn.country_code = 'BE'
      GROUP BY  i.intrastat_direction,
                i.customs_stat_no,
                i.region_of_origin,
                DECODE(i.intrastat_direction, 'EXPORT', i.country_of_origin, ''),
				    i.opposite_country,
                i.mode_of_transport,
                cn.country_notc,
                DECODE(i.intrastat_direction, 'EXPORT', i.opponent_tax_id, ''),
                i.delivery_terms; 
                
   CURSOR get_notc IS
      SELECT distinct notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'BE';   
   
   CURSOR exist_lines IS
      SELECT 1
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_
      AND    intrastat_direction = intrastat_direction_;   
     
BEGIN
   
   IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
       Error_SYS.Record_General(lu_name_, 'NOTBOTHBE: You can only create an import or export file at the time, not both at the same time');   
   ELSIF (intrastat_export_ = 'EXPORT' AND intrastat_import_ IS NULL) THEN
      intrastat_direction_ := intrastat_export_;
      declaration_report_ := 'INTRASTAT_X_E';
      declaration_form_   := 'INTRASTAT_X_EF';
      direction_type_     := '29'; -- Dispatch
   ELSIF (intrastat_export_ IS NULL AND intrastat_import_ = 'IMPORT') THEN
      intrastat_direction_ := intrastat_import_;
      declaration_report_ := 'EX19E';
      declaration_form_   := 'EXF19E';
      direction_type_     := '19'; -- Arrivals
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
      --Get the Company Vat Code
      $IF Component_Invoic_SYS.INSTALLED $THEN
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, headrec_.country_code, TRUNC(headrec_.creation_date));
      $END
      
      IF (vat_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOCOMPTAXNOBE: Tax number is missing for Company :P1', headrec_.company);
      END IF;
      
      vat_no_ := LPAD(vat_no_, 10, '0');
      
      -- Creation of the XML part
      -- Constructing the Envelope.
      line_ := '<?xml version="1.0" encoding="UTF-8"?>'|| CHR(13) || CHR(10);
      output_clob_ := line_;

      line_ := '<DeclarationReport xmlns="http://www.onegate.eu/2010-01-01">' || CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
      
      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('<Administration>',     '',         line_);
         Client_SYS.Add_To_Attr('<From declarerType="KBO">', vat_no_ ,         line_);
         Client_SYS.Add_To_Attr('</From>',     '',         line_);
         Client_SYS.Add_To_Attr('<To>', 'NBB' ,         line_);
         Client_SYS.Add_To_Attr('</To>',     '',         line_);
         Client_SYS.Add_To_Attr('<Domain>', 'SXX' ,         line_);
         Client_SYS.Add_To_Attr('</Domain>',     '',         line_);
      Client_SYS.Add_To_Attr('</Administration>',     '',        line_);
      
      Create_Line___(output_clob_, line_);
      
      OPEN exist_lines;
      FETCH exist_lines INTO dummy_;
      CLOSE exist_lines;      
     
      report_date_      := TO_CHAR(headrec_.end_date,'YYYY')||'-'||TO_CHAR(headrec_.end_date,'MM');
      rep_curr_rate_    := headrec_.rep_curr_rate;
      
      IF (dummy_ IS NULL) THEN
         Client_SYS.Clear_Attr(line_);
         -- When generating the xml file <Report> and <Data> tags will be displaying as follows.
         -- <Report action="nihil" date="YYYY-MM" code="declaration_report value">
         -- <Data close="true" form="declaration_form value"/>
         -- </Report>
         Client_SYS.Add_To_Attr('<Report code="' ||declaration_report_|| '" date="' ||report_date_|| '" action="nihil">',     '',         line_);
         Client_SYS.Add_To_Attr('<Data form="' ||declaration_form_ ||'" close="true" />',     '',         line_);
         Client_SYS.Add_To_Attr('</Report>',     '',         line_);
         Client_SYS.Add_To_Attr('</DeclarationReport>',     '',         line_);
         Create_Line___(output_clob_, line_);
      ELSE
         Client_SYS.Clear_Attr(line_);
         -- When generating the xml file <Report> and <Data> tags will be displaying as follows.
         -- <Report action="replace" date="YYYY-MM" code="declaration_report value">
         -- <Data close="true" form="declaration_form value"/>
         
         Client_SYS.Add_To_Attr('<Report code="' ||declaration_report_|| '" date="' ||report_date_|| '" action="replace">',     '',         line_);
         Client_SYS.Add_To_Attr('<Data form="' ||declaration_form_ ||'" close="true">',     '',         line_);
         Create_Line___(output_clob_, line_);
         
         FOR linerec_ IN get_lines LOOP
            IF (linerec_.delivery_terms NOT IN ('EXW','FCA','FAS','FOB','CFR','CIF','CPT','CIP','DDP', 'DAT', 'DAP')) THEN
               Error_SYS.Record_General(lu_name_, 'WRONGDELTERMSBE: Invalid Delivery Terms.');
            END IF;
            IF (intrastat_direction_ = 'EXPORT') THEN   
               IF (linerec_.opponent_tax_id IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'MISSINGOPPTAXIDBE: Opponent Tax ID is missing for some lines.');
               END IF;
               IF (linerec_.country_of_origin IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'MISSINGCOUNTRYOFORIGIONBE: Country of Origin is missing for some lines.');
               END IF;   
            END IF;
            Client_SYS.Clear_Attr(line_);
            Client_SYS.Add_To_Attr('<Item>',     '',         line_);
               Client_SYS.Add_To_Attr('<Dim prop="EXTRF">',     direction_type_,         line_); 
               Client_SYS.Add_To_Attr('</Dim>',     '',         line_);
               Client_SYS.Add_To_Attr('<Dim prop="EXCNT">',     linerec_.opposite_country,         line_); -- partner country
               Client_SYS.Add_To_Attr('</Dim>',     '',         line_);
               Client_SYS.Add_To_Attr('<Dim prop="EXTTA">',     linerec_.country_notc,         line_); -- type of transaction
               Client_SYS.Add_To_Attr('</Dim>',     '',         line_);
               Client_SYS.Add_To_Attr('<Dim prop="EXREG">',     linerec_.region_of_origin,         line_); -- region
               Client_SYS.Add_To_Attr('</Dim>',     '',         line_);
               Client_SYS.Add_To_Attr('<Dim prop="EXTGO">',     RPAD(SUBSTR(linerec_.customs_stat_no, 1,8),8),         line_); -- commodity code
               Client_SYS.Add_To_Attr('</Dim>',     '',         line_);
               Client_SYS.Add_To_Attr('<Dim prop="EXWEIGHT">',  ROUND(linerec_.weight, 2),         line_); -- net mass
               Client_SYS.Add_To_Attr('</Dim>',     '',         line_);
               Client_SYS.Add_To_Attr('<Dim prop="EXUNITS">',   ROUND(NVL(linerec_.alternative_qty,0), 2),         line_); -- supplementary units
               Client_SYS.Add_To_Attr('</Dim>',     '',         line_);
               Client_SYS.Add_To_Attr('<Dim prop="EXTXVAL">',   linerec_.invoice_value,         line_); 
               Client_SYS.Add_To_Attr('</Dim>',     '',         line_);
               IF (intrastat_direction_ = 'EXPORT') THEN
                  Client_SYS.Add_To_Attr('<Dim prop="EXCNTORI">',   linerec_.country_of_origin,         line_);
                  Client_SYS.Add_To_Attr('</Dim>',     '',         line_);
                  Client_SYS.Add_To_Attr('<Dim prop="PARTNERID">',   linerec_.opponent_tax_id,         line_);
                  Client_SYS.Add_To_Attr('</Dim>',     '',         line_);
               END IF;   
               Client_SYS.Add_To_Attr('<Dim prop="EXTPC">',   linerec_.mode_of_transport,         line_); -- means of transport
               Client_SYS.Add_To_Attr('</Dim>',     '',         line_);
               Client_SYS.Add_To_Attr('<Dim prop="EXDELTRM">',   linerec_.delivery_terms,         line_); -- terms of delivery
               Client_SYS.Add_To_Attr('</Dim>',     '',         line_);
               Create_Line___(output_clob_, line_);   
               line_ := '</Item>'|| CHR(13) || CHR(10);
               output_clob_ := output_clob_ || line_;            
            END LOOP;
            line_ := '</Data>'|| CHR(13) || CHR(10);
            output_clob_ := output_clob_ || line_; 
            line_ := '</Report>'|| CHR(13) || CHR(10);
            output_clob_ := output_clob_ || line_;
            line_ := '</DeclarationReport>'|| CHR(13) || CHR(10);
            output_clob_ := output_clob_ || line_;
      END IF;   
   END LOOP;     
   info_ := Client_SYS.Get_All_Info;

END Create_Output;



