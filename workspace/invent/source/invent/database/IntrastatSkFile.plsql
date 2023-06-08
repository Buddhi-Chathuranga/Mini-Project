-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatSkFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211122   ErFelk   Bug 161313(SC21R2-5342), Added opponent_tax_id to the new xml tag ICD_PARTNERA.  
--  171101   MeAblk   Bug 138598, Modified Create_Details__() and Create_Output() to change the formattings of ROK, DRUH_OBCHODU and REGION_POVODU.
--  130813   AwWelk   TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130730   AwWelk   TIBE-857, Removed global variables and introduced conditional compilation.
--  121016   PraWlk   Bug 105887, Removed SUBSTR to avoid length restriction of customs statistics number description. 
--  110323   PraWlk   Bug 95757, Modified Create_Details__() by adding delivery terms DAT and DAP.
--  110309   Bmekse   DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                    inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110203   Elarse   Added sysdate in calls to Tax_Liability_Countries_API.
--  101215   jofise   Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead.
--  090929   PraWlk   Bug 85516, Modified the length of description_ to 200.
--  090928   ChFolk   Removed unused variables in the package.
----------------------------------- 14.0.0 --------------------------------------
--  090601   SaWjlk   Bug 83173, Removed the prog text duplications.
--  070704   ChBalk   Bug 66078, Modified code to fetch only the first 35 chrarcters
--  070704            to the variable description_.
--  070227   KaDilk   Bug 46111, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Encode___ (
   value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(32000) := value_;
BEGIN
   temp_ := REPLACE(temp_, CHR(38), CHR(38)||'amp;');
   temp_ := REPLACE(temp_, '"', CHR(38)||'quot;');
   temp_ := REPLACE(temp_, CHR(39), CHR(38)||'apos;');
   temp_ := REPLACE(temp_, '<', CHR(38)||'lt;');
   temp_ := REPLACE(temp_, '>', CHR(38)||'gt;');
   RETURN (temp_);
END Encode___;


PROCEDURE Create_Line___(
   output_clob_   IN OUT CLOB,
   line_          IN     VARCHAR2 )
IS
   text_     VARCHAR2(32000);
   ptr_      NUMBER;
   name_     VARCHAR2(1000);
   value_    VARCHAR2(32000);
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
   creation_date_        IN     DATE,
   end_date_             IN     DATE,
   company_              IN     VARCHAR2,
   company_vat_no_       IN     VARCHAR2,
   repr_tax_no_          IN     VARCHAR2,
   company_contact_      IN     VARCHAR2,
   representative_       IN     VARCHAR2,
   rep_curr_code_        IN     VARCHAR2,
   rep_curr_rate_        IN     NUMBER,
   country_code_         IN     VARCHAR2,
   report_type_          IN     NUMBER ) 
IS

   direction_lines_      NUMBER := 0;
   line_                 VARCHAR2(32000);
   description_          VARCHAR2(2000);
   pos_id_               NUMBER := 0;
   formatted_country_notc_ VARCHAR2(3);
   
   
   CURSOR get_lines IS
      SELECT il.intrastat_direction,
             il.opposite_country,
             DECODE (intrastat_direction_, 'IMPORT', il.country_of_origin, '')                    country_of_origin,
             cn.country_notc,
             il.mode_of_transport,
             il.customs_stat_no,
             il.delivery_terms,
             il.region_of_origin, 
             SUM (il.quantity * il.net_unit_weight)                                               net_weight_sum,
             SUM (NVL(ABS(il.intrastat_alt_qty),0) * il.quantity)                                 intrastat_alt_qty_sum,
             SUM (il.quantity * NVL(il.invoiced_unit_price,il.order_unit_price)) * rep_curr_rate_ invoiced_amount,
             DECODE(il.intrastat_direction, 'EXPORT', il.opponent_tax_id, '')  opponent_tax_id
      FROM   intrastat_line_tab il, country_notc_tab cn
      WHERE  il.intrastat_id        = intrastat_id_
      AND    il.intrastat_direction = intrastat_direction_
      AND    il.rowstate            = 'Released'        
      AND    il.notc                = cn.notc    
      AND    cn.country_code = country_code_      
      GROUP BY il.intrastat_direction,
               il.opposite_country,
               il.region_of_origin,
               DECODE (intrastat_direction_, 'IMPORT', il.country_of_origin, ''),
               cn.country_notc,
               il.mode_of_transport,
               il.customs_stat_no,
               il.delivery_terms,
               il.region_of_origin,
               DECODE(il.intrastat_direction, 'EXPORT', il.opponent_tax_id, '');

   CURSOR get_no_lines IS
      SELECT COUNT(*) no_rows
      FROM   intrastat_line_tab
      WHERE  intrastat_id        = intrastat_id_
      AND    intrastat_direction = intrastat_direction_;

BEGIN

   pos_id_ := 0;

   --Fetch no of lines for this direction
   OPEN get_no_lines;
   FETCH get_no_lines INTO direction_lines_;
   CLOSE get_no_lines;
   
   IF direction_lines_ = 0 THEN
      line_ := '<POLOZKA>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
      
      Create_Line___(output_clob_, line_);
      line_ := '  </POLOZKA>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;      
   END IF;

   FOR linerec_ IN get_lines LOOP
      pos_id_ := pos_id_ + 1;
      IF (linerec_.delivery_terms NOT IN ('EXW','FOB','FAS','FCA','CFR','CIF','CPT','CIP','DAF','DES','DEQ','DDU','DDP', 'DAT', 'DAP')) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGDELTERMS: Wrong Delivery Terms');
      END IF;
      IF (linerec_.customs_stat_no = '*') THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCUSTOMSNO: Wrong Customs Stat No');
      END IF;
      IF (linerec_.country_notc IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGNOTC: Wrong Notc');
      END IF; 
      description_ := Customs_Statistics_Number_API.Get_Description(linerec_.customs_stat_no); 

      line_ := '<POLOZKA>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
      --Full report is ordered.
      IF report_type_ = 0 THEN
         
         Client_SYS.Clear_Attr(line_);
         Client_SYS.Add_To_Attr('<KOD_TOVARU>',                linerec_.customs_stat_no,      line_);
         Client_SYS.Add_To_Attr('</KOD_TOVARU>',               '',                            line_);
         Client_SYS.Add_To_Attr('<OPIS_TOVARU>',               Encode___(description_),       line_);
         Client_SYS.Add_To_Attr('</OPIS_TOVARU>',              '',                            line_);
         IF intrastat_direction_ = 'IMPORT' THEN
            Client_SYS.Add_To_Attr('<KRAJINA_ODOSLANIA>',       linerec_.opposite_country,    line_);
            Client_SYS.Add_To_Attr('</KRAJINA_ODOSLANIA>',       '',                          line_);
            Client_SYS.Add_To_Attr('<KRAJINA_POVODU>',       linerec_.country_of_origin,      line_);
            Client_SYS.Add_To_Attr('</KRAJINA_POVODU>',       '',                             line_);
         ELSE
            Client_SYS.Add_To_Attr('<KRAJINA_URCENIA>', linerec_.opposite_country,            line_);
            Client_SYS.Add_To_Attr('</KRAJINA_URCENIA>', '',                                  line_);  
         END IF;
         Client_SYS.Add_To_Attr('<HMOTNOST>',                 ROUND(linerec_.net_weight_sum), line_);
         Client_SYS.Add_To_Attr('</HMOTNOST>',                '',                             line_);
         IF linerec_.intrastat_alt_qty_sum IS NOT NULL THEN         
            Client_SYS.Add_To_Attr('<MNOZSTVO>',  ROUND(linerec_.intrastat_alt_qty_sum),      line_);
            Client_SYS.Add_To_Attr('</MNOZSTVO>',              '',                            line_);
         END IF;
         Client_SYS.Add_To_Attr('<SUMA>',                     ROUND(linerec_.invoiced_amount),  line_);
         Client_SYS.Add_To_Attr('</SUMA>',                     '',                            line_);
         Client_SYS.Add_To_Attr('<DODACIE_PODMIENKY>',         linerec_.delivery_terms,       line_);
         Client_SYS.Add_To_Attr('</DODACIE_PODMIENKY>',         '',                           line_);
         Client_SYS.Add_To_Attr('<DRUH_DOPRAVY>',              linerec_.mode_of_transport,    line_);
         Client_SYS.Add_To_Attr('</DRUH_DOPRAVY>',             '',                            line_);
         
         IF LENGTH(linerec_.country_notc) = 2 THEN
            IF SUBSTR(linerec_.country_notc,2,1) != '0' THEN
               formatted_country_notc_ := SUBSTR(linerec_.country_notc,1,1) || ',' || SUBSTR(linerec_.country_notc,2,1);
            ELSE
               formatted_country_notc_ := SUBSTR(linerec_.country_notc,1,1);
            END IF;
         ELSE
            formatted_country_notc_ := linerec_.country_notc;
         END IF;
         Client_SYS.Add_To_Attr('<DRUH_OBCHODU>',              formatted_country_notc_,         line_);
         Client_SYS.Add_To_Attr('</DRUH_OBCHODU>',             '',                              line_);
         
         IF intrastat_direction_ = 'IMPORT' THEN      
            Client_SYS.Add_To_Attr('<REGION_URCENIA>',            LTRIM(linerec_.region_of_origin,'0'), line_);
            Client_SYS.Add_To_Attr('</REGION_URCENIA>',            '',                        line_);
         ELSE
            Client_SYS.Add_To_Attr('<REGION_POVODU>',             LTRIM(linerec_.region_of_origin,'0'),  line_);
            Client_SYS.Add_To_Attr('</REGION_POVODU>',            '',                         line_);            
            Client_SYS.Add_To_Attr('<ICD_PARTNERA>',              linerec_.opponent_tax_id,  line_);
            Client_SYS.Add_To_Attr('</ICD_PARTNERA>',            '',                         line_);            
         END IF;

      ELSE

         Client_SYS.Clear_Attr(line_);
         Client_SYS.Add_To_Attr('<KOD_TOVARU>',                linerec_.customs_stat_no,      line_);
         Client_SYS.Add_To_Attr('</KOD_TOVARU>',               '',                            line_);
         IF intrastat_direction_ = 'IMPORT' THEN
            Client_SYS.Add_To_Attr('<KRAJINA_ODOSLANIA>',       linerec_.opposite_country,    line_);
            Client_SYS.Add_To_Attr('</KRAJINA_ODOSLANIA>',       '',                          line_);
         ELSE
            Client_SYS.Add_To_Attr('<KRAJINA_URCENIA>', linerec_.opposite_country,            line_);
            Client_SYS.Add_To_Attr('</KRAJINA_URCENIA>', '',                                  line_);  
         END IF;
         Client_SYS.Add_To_Attr('<SUMA>',                     ROUND(linerec_.invoiced_amount),  line_);
         Client_SYS.Add_To_Attr('</SUMA>',                     '',                            line_);         
         IF (intrastat_direction_ = 'EXPORT') THEN         
            Client_SYS.Add_To_Attr('<ICD_PARTNERA>',              linerec_.opponent_tax_id,  line_);
            Client_SYS.Add_To_Attr('</ICD_PARTNERA>',            '',                         line_);            
         END IF;         
      END IF;

      Create_Line___(output_clob_, line_);
      line_ := '  </POLOZKA>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
   END LOOP;    

END Create_Details__;   


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Output (
   output_clob_             OUT CLOB,
   info_                    OUT VARCHAR2,
   import_progress_no_      OUT NUMBER,
   export_progress_no_      OUT NUMBER,
   intrastat_id_         IN     NUMBER,
   intrastat_export_     IN     VARCHAR2,
   intrastat_import_     IN     VARCHAR2,
   report_type_          IN     NUMBER ) 
IS
   line_                 VARCHAR2(32000);
   vat_no_               VARCHAR2(50);
   intrastat_direction_  VARCHAR2(10);
   direction_type_       VARCHAR2(1);
   association_no_       VARCHAR2(50);
   own_no_               VARCHAR2(20);
   notc_dummy_           VARCHAR2(2);
   rep_curr_rate_        NUMBER;
   total_rows_           NUMBER;

   CURSOR get_notc IS
      SELECT DISTINCT notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc         = notc_
      AND    country_code = 'SK';      

   CURSOR get_head IS
      SELECT company, 
             creation_date,
             end_date,
             company_contact,
             customs_id, 
             representative,
             repr_tax_no,
             rep_curr_rate,
             rep_curr_code,
             country_code,
             bransch_no,
             RPAD (bransch_no_repr,14,0) bransch_no_repr
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;
      
    CURSOR get_number_of_line IS
       SELECT COUNT(*)
       FROM   intrastat_line_tab
       WHERE  intrastat_id        = intrastat_id_
       AND    intrastat_direction = intrastat_direction_;

BEGIN
     
   IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
      intrastat_direction_ := 'BOTH';   
   ELSIF (intrastat_export_ = 'EXPORT' AND intrastat_import_ IS NULL) THEN
      intrastat_direction_ := intrastat_export_;
      direction_type_ := 'O';
   ELSIF (intrastat_export_ IS NULL AND intrastat_import_ = 'IMPORT') THEN
      intrastat_direction_ := intrastat_import_;
      direction_type_ := 'P';
   ELSE 
      Error_SYS.Record_General(lu_name_, 'DIRECTIONSNULL: At least one transfer option must be checked');        
   END IF; 
   
   OPEN get_number_of_line;
   FETCH get_number_of_line INTO total_rows_;
   CLOSE get_number_of_line;  

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
      
      association_no_   := Customs_Info_API.Get_Association_No(headrec_.customs_id);

      IF (association_no_ IS NULL AND total_rows_ > 0) THEN
         Error_SYS.Record_General(lu_name_, 'CUSTASSOCNOTEX: Custom office code is missing!');
      END IF;
      IF (headrec_.rep_curr_code NOT IN ('SKK','EUR')) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCURRSKF: Currency Code :P1 is not a valid currency, only SKK and EUR is acceptable', headrec_.rep_curr_code);
      END IF; 
      IF (vat_no_ IS NULL AND total_rows_ > 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOCOMPVATNO: TAX number is missing for company :P1.',headrec_.company);
      END IF;   

      IF (SUBSTR(vat_no_, 1, 2) = 'SK') THEN
         vat_no_ := SUBSTR(vat_no_,4,10);
      END IF;         

      rep_curr_rate_ := headrec_.rep_curr_rate;

      --Creation of the XML part
      line_ := '<?xml version="1.0" encoding="ISO-8859-2" ?>'|| CHR(13) || CHR(10);
      output_clob_ := line_;
         
      line_ := '<INTRASTAT>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
      
      line_ := '<HLASENIE>'|| CHR(13) || CHR(10);
      output_clob_ := output_clob_ || line_;
                  
      own_no_ := TO_CHAR(headrec_.creation_date,'YY')||'IST'||intrastat_id_;

      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('<MESIAC>',                   TO_CHAR(headrec_.end_date,'MM'),  line_);
      Client_SYS.Add_To_Attr('</MESIAC>',                  '',                                 line_);
      Client_SYS.Add_To_Attr('<ROK>',                      TO_CHAR(headrec_.end_date,'YY'),    line_);
      Client_SYS.Add_To_Attr('</ROK>',                     '',                                 line_);
      IF total_rows_ > 0 THEN 
          Client_SYS.Add_To_Attr('<DRUH_HLASENIA>',             report_type_,                               line_);
          Client_SYS.Add_To_Attr('</DRUH_HLASENIA>',            '',                              line_);
      ELSE
          Client_SYS.Add_To_Attr('<DRUH_HLASENIA>',             2,                               line_);
          Client_SYS.Add_To_Attr('</DRUH_HLASENIA>',            '',                              line_);
      END IF;    
      Client_SYS.Add_To_Attr('<TYP_HLASENIA>',              direction_type_,                   line_);
      Client_SYS.Add_To_Attr('</TYP_HLASENIA>',             '',                                line_);
      Client_SYS.Add_To_Attr('<CISLO>',                    '1',                                line_);
      Client_SYS.Add_To_Attr('</CISLO>',                   '',                                 line_);     
      Create_Line___(output_clob_, line_);
      --End XML Header part

      --Create the intrastat lines for Import
       IF (intrastat_import_ = 'IMPORT') THEN
         Create_Details__(output_clob_,
                          intrastat_id_,
                          'IMPORT',
                          headrec_.creation_date,
                          headrec_.end_date,
                          headrec_.company,
                          vat_no_,
                          headrec_.repr_tax_no,
                          headrec_.company_contact,
                          headrec_.representative,
                          headrec_.rep_curr_code,
                          headrec_.rep_curr_rate,
                          headrec_.country_code,
                          report_type_);
      END IF;

      --Create the intrastat lines for Export
      IF (intrastat_export_ = 'EXPORT') THEN
         Create_Details__(output_clob_,
                          intrastat_id_,
                          'EXPORT',
                          headrec_.creation_date,
                          headrec_.end_date,
                          headrec_.company,
                          vat_no_,
                          headrec_.repr_tax_no,
                          headrec_.company_contact,
                          headrec_.representative,
                          headrec_.rep_curr_code,
                          headrec_.rep_curr_rate,
                          headrec_.country_code,
                          report_type_);
      END IF;         

   END LOOP;

   line_ := '  </HLASENIE>'|| CHR(13) || CHR(10)||'</INTRASTAT>';
   output_clob_ := output_clob_ || line_;

   info_ := Client_SYS.Get_All_Info;    

END Create_Output;



