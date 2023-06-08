-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatPlFile
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211212  ErFelk  Bug 160972(SC21R2-6298), Modified Create_Output_Line___() and Create_Output() by making country_of_origin enable for both Import and Export.  
--  210304  ApWilk  Bug 156696(SCZ-13937), Modified Create_Details__() and Create_Output() by adding a new parameter pre_intrastat_id_. Modified get_lines, get_totals and get_no_of_lines
--  210304          cursors in order to modify the output in an ordered manner. Added Create_Output_Line___() in order to move the common code into a single location.
--  200612  ErFelk  Bug 154358(SCZ-10384), Modified Create_Details__() by adding an error message WRONGOPPTAXID.
--` 200602  ErFelk  Bug 154212(SCZ-10288), Modified Create_Details__() so that tag IdKontrahenta is shown only when the intrastat direction is EXPORT. 
--  171207  ErFelk  Bug 138948, Modified Create_Output() by adding opponent_tax_id to the Group by of get_totals cursor.
--  171206  ErFelk  Bug 138697, Modified Create_Output() by adding opponent_tax_id to the Group by of get_no_of_lines cursor.
--  171205  ErFelk  Bug 135151, Added opponent_tax_id to the get_lines cursor and to the generated Intrastat export file.
--  170502  PrYaLK  Bug 135480, Added a new method Filter__() in order to remove unwanted EDIFACT specified characters from the vat_no_.
--  160915  ErFelk  Bug 131336, Modified Create_Output() to set zero for total_invoice_value_ and total_statistical_value_ if there are no lines.
--  160915          Modified Create_Details__() by removing an xml tag <Towar LiczbaPozycji="0"> which is not needed if there are no lines. 
--  160915  ErFelk  Bug 131338, Modified Create_Output() so that each file has an unique identity by adding an extra character at the end of 
--  160915          own_no_ to denote Import, Export or both.
--  160715  ApWilk  Bug 129802, Modified Create_Output() to reorder the header and summary data presented in the xml file due to legal requirement.
--  150213  KoDelk  Bug 121046, Modified Create_Output() to reorder the header and summary data presented in the xml file Due to legal requirement.
--  140731  NipKlk  Bug 118047, Removed the bug correction 115122 and assigned the values to Wersja, Numer and Rodzaj from the database which are manually entered from the client
--  140731          and added new method Validate_Import_Export___ to check if above values are null.
--  140731  KoDelk  Bug 117268, Modified Create_Output() method to fetched custom_id when relevant custom association number is NULL.
--  140610  TiRalk  Bug 117387, Modified Create_Output by removing il.contract from cursor get_lines to avoid incorrect grouping of intrastat Lines by Site. 
--  130822  IsSalk  Bug 107531, Modified cursors get_lines and get_totals  by changing the calculation of invoiced_amount to consider 
--  130822          the charge values and subtract the new value unit_statistical_charge_diff from statistical_value.
--  130812  TiRalk  Bug 111783, Modified Create_Output by replacing UTF-8 instead of windows-1250.
--  130813  AwWelk  TIBE-846, Redesigned the implementation related to Transfer Intrastat to File by using clob data handling.
--  130731  MaIklk  TIBE-854, Removed inst_TaxLiabilityCountries_ global constant and used conditional compilation instead.
--  130424  PraWlk  Bug 109577, Removed the spaces of customs_stat_no and modified the length to 8. Also modified the 
--  130424          cursor get_lines to summarize data upon customs_stat_no.
--  130418  PraWlk  Bug 109487, Removed il.contract from cursor get_lines to avoid incorrect grouping of intrastat Lines by Site. 
--  130418          Also fetched the customs statistics no description using Company_API.Get_Default_Language_Db(). 
--  121016  PraWlk  Bug 105887, Removed SUBSTR to avoid length restriction of customs statistics number description. 
--  120228  TiRalk  Bug 101359, Modified Create_Output() by changing the value of own_no_ as it displays
--  120228          a wrong declaration number in generated xml file.
--  110712  Asawlk  Bug 97849, Modified Create_Output() to calculate total_invoice_value_ and total_statistical_value_
--  110712          to be align with the SUM of linerec_.invoiced_amount and linerec_.statistical_value respectively.   
--  110502  Asawlk  Bug 96688, Modified Create_Output() by removing cursor get_number_of_parts and its 
--  110502          usage. Added new cursor get_no_of_lines to count the no of lines. Changed cursor
--  110502          get_totals to include only records having rowstate = 'Released'.    
--  110309  Bmekse  DF-917 Modifed call to Tax_Liability_Countries_API.Get_Tax_Id_Number. Replaced 
--                  inst_CompanyInvoiceInfo_ with inst_TaxLiabilityCountries_.
--  110223  PraWlk  Bug 95757, Modified Create_Details__() by adding delivery terms DAT and DAP.
--  110203  Elarse  Added sysdate in calls to Tax_Liability_Countries_API.
--  101215  jofise  Changed calls to Company_Invoice_Info_Api.Get_Vat_No to Tax_Liability_Countries_API.Get_Tax_Id_Number instead.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  100107  Umdolk  Refactoring in Communication Methods in Enterprise.
--  090929  PraWlk  Bug 85516, Modified the length of description_ to 200.
--  090928  ChFolk  Removed duplicate assignment for comp_association_.
--  090601  SaWjlk  Bug 83173, Removed the prog text duplications.
--  090223  HoInlk  Bug 79732, Modified Create_Output by adding the new field Wersja (version) and
--  090223          changed fields Rok and Miesiac to refer to end date.
--  090212  MalLlk  Bug 80014, Modified Create_Details__ by passing the language code as a parameter to  
--  090212          the method Customs_Statistics_Number_API.Get_Description to get the translated value.
--  090212          Modified the the SELECT and GROUP BY clauses of CURSOR get_lines. 
--  080527  SuSalk  Bug 72952, Modified to return NULL when intrastat_alt_qty_sum is zero 
--  080527          of get_lines cursor in Create_Details__ method.
--  060516  IsAnlk Enlarge Address - Changed variable definitions.
----------------------------13.4.0-------------------------------------------
--  060123  NiDalk  Added Assert safe annotation. 
--  050920  NiDalk  Removed unused variables.
--  050906  SaJjlk  Changed SUBSTRB to SUBSTR.
--  050331  Asawlk  Bug 44648, Removed a check for association_no and added a check for customs_id
--  050331          inside procedure Create_Output.
--  050307  Asawlk  Bug 44648, Created file
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Encode___
--   This is used to encode a string as needed.
FUNCTION Encode___ (
   value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(32000) := value_;
BEGIN
   temp_ := replace(temp_, chr(38), chr(38)||'amp;');
   temp_ := replace(temp_, '"',     chr(38)||'quot;');
   temp_ := replace(temp_, chr(39), chr(38)||'apos;');
   temp_ := replace(temp_, '<',     chr(38)||'lt;');
   temp_ := replace(temp_, '>',     chr(38)||'gt;');
   RETURN (temp_);
END Encode___;


-- Create_Line___
--   This method is used to create a line.
PROCEDURE Create_Line___ (
   output_clob_ IN OUT CLOB,
   line_        IN     VARCHAR2 )
IS
   text_     VARCHAR2(32000);
   ptr_      NUMBER;
   name_     VARCHAR2(1000);
   value_    VARCHAR2(32000);
   delim_    VARCHAR2(1) :=' ';
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(line_, ptr_, name_, value_)) LOOP
      IF name_ = 'BEGIN' THEN
         text_ := value_;
      ELSIF name_ = 'END' THEN
         text_ := rtrim(text_) || value_ || chr(13) || chr(10);
      ELSE
         text_ := text_ || delim_ || name_ || '="' || value_ || '"';
      END IF;
   END LOOP;
   output_clob_ := output_clob_ || text_;
END Create_Line___;


PROCEDURE Validate_Import_Export___ (
   dec_no_        IN  NUMBER,
   version_no_    IN  NUMBER,
   dec_type_      IN  VARCHAR2 )
IS
BEGIN
   IF (version_no_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'VERNUMBERNULL: Version number cannot be null for Polish Intrastat reporting.');         
   END IF;
    
   IF (dec_type_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DECTYPENULL: Declaration Type cannot be null for Polish Intrastat reporting.');         
   END IF;
   
   IF (dec_no_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DECNUMBERNULL: Declaration Number cannot be null for Polish Intrastat reporting.');         
   END IF;
END Validate_Import_Export___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
-- Create_Output_Line___
--   Method used for creating the output file for intrastat lines.
PROCEDURE Create_Output_Line___ (
   output_clob_          IN OUT NOCOPY CLOB,
   total_ivc_value_      IN OUT NUMBER,
   total_stat_value_     IN OUT NUMBER,
   position_id_          IN OUT NUMBER,
   intrastat_id_         IN NUMBER,
   pre_intrastat_id_     IN NUMBER,
   rep_curr_rate_        IN NUMBER,
   company_              IN VARCHAR2,
   intrastat_direction_  IN VARCHAR2,
   country_code_         IN VARCHAR2 )
IS
   line_                    VARCHAR2(32000);
   description_             VARCHAR2(2000);
   pos_id_                  NUMBER := 0;
   trimmed_customs_stat_no_ VARCHAR2(8);
   customs_stat_no_         VARCHAR2(15);

   CURSOR customs_stat_no IS
         SELECT il.customs_stat_no
         FROM   intrastat_line_tab il, country_notc_tab cn
         WHERE  il.intrastat_id = intrastat_id_
         AND    il.intrastat_direction = intrastat_direction_
         AND    il.rowstate = 'Released'        
         AND    il.notc = cn.notc     
         AND    cn.country_code = country_code_
         AND    SUBSTR(REPLACE(il.customs_stat_no,' '),1,8) = trimmed_customs_stat_no_;
         
   CURSOR get_lines IS
      SELECT il.intrastat_direction,
             il.opposite_country,
             il.country_of_origin,
             cn.country_notc,
             il.mode_of_transport,
             SUBSTR(REPLACE(il.customs_stat_no,' '),1,8) customs_stat_no,
             il.delivery_terms,
             SUM(il.quantity * il.net_unit_weight) net_weight_sum,
             DECODE(SUM(NVL(ABS(il.intrastat_alt_qty),0) * il.quantity),0,NULL,
                   (SUM(NVL(ABS(il.intrastat_alt_qty),0) * il.quantity))) intrastat_alt_qty_sum,
             SUM(il.quantity * (NVL(il.invoiced_unit_price,il.order_unit_price) +
                                NVL(il.unit_charge_amount_inv, 0) +
                                NVL(il.unit_charge_amount, 0))) * rep_curr_rate_ invoiced_amount,             
             SUM((NVL(il.invoiced_unit_price,NVL(il.order_unit_price,0)) +
                  NVL(il.unit_add_cost_amount_inv,NVL(il.unit_add_cost_amount,0)) +
                  NVL(il.unit_charge_amount_inv,0) +
                  NVL(il.unit_charge_amount,0) -
                  NVL(il.unit_statistical_charge_diff, 0)) * quantity) * rep_curr_rate_ statistical_value,
             il.opponent_tax_id     
      FROM   intrastat_line_all_tmp il, country_notc_tab cn
      WHERE  il.intrastat_id IN (pre_intrastat_id_, intrastat_id_)
      AND    il.intrastat_direction = intrastat_direction_
      AND    il.rowstate = 'Released'
      AND    il.notc = cn.notc
      AND    cn.country_code = country_code_
      GROUP BY  il.intrastat_direction,
                il.opposite_country,
                il.country_of_origin,
                cn.country_notc,
                il.mode_of_transport,
                SUBSTR(REPLACE(il.customs_stat_no,' '),1,8),
                il.delivery_terms,
                il.opponent_tax_id
      ORDER BY  SUBSTR(REPLACE(il.customs_stat_no,' '),1,8),
                 il.opposite_country,
                 il.mode_of_transport,
                 il.delivery_terms;
BEGIN
   IF (position_id_ IS NOT NULL) THEN
      pos_id_ := position_id_;
   ELSE
      pos_id_ := 0;
   END IF;
   
   FOR linerec_ IN get_lines LOOP
         pos_id_ := pos_id_ + 1;
         IF (linerec_.delivery_terms NOT IN ('EXW','FCA','FAS','FOB','CFR','CIF','CPT','CIP','DAF','DES','DEQ','DDU','DDP', 'DAT', 'DAP')) THEN
            Error_SYS.Record_General(lu_name_, 'WRONGDELTERMS: Wrong Delivery Terms.');
         END IF;
         IF (linerec_.customs_stat_no = '*') THEN
            Error_SYS.Record_General(lu_name_, 'WRONGCUSTOMSNO: Wrong Customs Stat No.');
         END IF;
         IF (linerec_.country_notc IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'WRONGNOTC: Wrong Notc.');
         END IF;
         IF ((intrastat_direction_ = 'EXPORT') AND (linerec_.opponent_tax_id IS NULL)) THEN
            Error_SYS.Record_General(lu_name_, 'WRONGOPPTAXID: Wrong Opponent Tax Id.');
         END IF;
         IF (linerec_.country_of_origin IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOCOUNTRYORIGINPL: The country of origin must be specified for intrastat reporting.');
         END IF;
         
         description_ := Customs_Statistics_Number_API.Get_Description(linerec_.customs_stat_no, Company_API.Get_Default_Language_Db(company_));
         IF description_ IS NULL THEN
            trimmed_customs_stat_no_ := linerec_.customs_stat_no;
            OPEN customs_stat_no; 
            FETCH customs_stat_no INTO customs_stat_no_;
            CLOSE customs_stat_no; 
            description_ := Customs_Statistics_Number_API.Get_Description(customs_stat_no_, Company_API.Get_Default_Language_Db(company_));
         END IF;

         Client_SYS.Clear_Attr(line_);
         Client_SYS.Add_To_Attr('BEGIN',                    '     <Towar',                    line_);
         Client_SYS.Add_To_Attr('PozId',                    pos_id_,                          line_);
         Client_SYS.Add_To_Attr('OpisTowaru',               Encode___(description_),          line_);
         Client_SYS.Add_To_Attr('KrajPrzeznaczeniaWysylki', linerec_.opposite_country,        line_);
         Client_SYS.Add_To_Attr('KrajPochodzenia',          linerec_.country_of_origin,       line_);         
         Client_SYS.Add_To_Attr('WarunkiDostawy',           linerec_.delivery_terms,          line_);
         Client_SYS.Add_To_Attr('RodzajTransakcji',         linerec_.country_notc,            line_);
         Client_SYS.Add_To_Attr('RodzajTransportu',         linerec_.mode_of_transport,       line_);
         Client_SYS.Add_To_Attr('KodTowarowy',              linerec_.customs_stat_no,         line_); 
         IF (intrastat_direction_ = 'EXPORT') THEN
            Client_SYS.Add_To_Attr('IdKontrahenta',         linerec_.opponent_tax_id,         line_);
         END IF;
         Client_SYS.Add_To_Attr('MasaNetto',                ROUND(linerec_.net_weight_sum),   line_);
         IF (linerec_.intrastat_alt_qty_sum IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('IloscUzupelniajacaJm',  ROUND(linerec_.intrastat_alt_qty_sum),   line_);
         END IF;
         Client_SYS.Add_To_Attr('WartoscFaktury',           ROUND(linerec_.invoiced_amount),  line_);
         Client_SYS.Add_To_Attr('WartoscStatystyczna',      ROUND(linerec_.statistical_value),line_);         
         total_ivc_value_  := NVL(total_ivc_value_,0)  + ROUND(linerec_.invoiced_amount);
         total_stat_value_ := NVL(total_stat_value_,0) + ROUND(linerec_.statistical_value);
         Client_SYS.Add_To_Attr('END',                      ' />',                            line_);
         Create_Line___(output_clob_, line_);
      END LOOP;
      position_id_ := pos_id_;
   END Create_Output_Line___;
   
-- Create_Details__
-- Method fetches the detail data for a specific intrastat
PROCEDURE Create_Details__ (
   output_clob_         IN OUT CLOB,
   total_ivc_value_     IN OUT NUMBER,
   total_stat_value_    IN OUT NUMBER,
   intrastat_id_        IN     NUMBER,
   intrastat_direction_ IN     VARCHAR2,
   creation_date_       IN     DATE,
   end_date_            IN     DATE,
   company_             IN     VARCHAR2,
   bransch_no_          IN     VARCHAR2,
   bransch_no_repr_     IN     VARCHAR2,
   company_vat_no_      IN     VARCHAR2,
   repr_tax_no_         IN     VARCHAR2,
   company_contact_     IN     VARCHAR2,
   representative_      IN     VARCHAR2,
   rep_curr_code_       IN     VARCHAR2,
   rep_curr_rate_       IN     NUMBER,
   country_code_        IN     VARCHAR2,
   pre_intrastat_id_    IN     NUMBER DEFAULT NULL)
IS
   direction_lines_           NUMBER := 0;
   pos_id_                    NUMBER := 0;
   pre_index_                 PLS_INTEGER;
   new_index_                 PLS_INTEGER := 1;
   rec_found_                 BOOLEAN := FALSE;
   match_found_               BOOLEAN := FALSE;

   CURSOR get_pre_intrastat_data IS
      SELECT *
      FROM   intrastat_line_tab il
      WHERE  il.intrastat_id = pre_intrastat_id_
      AND    il.transaction_id IS NOT NULL;
      
   CURSOR get_temp_intrastat_data IS
      SELECT *
      FROM   intrastat_line_tab il
      WHERE  il.intrastat_id = intrastat_id_;
      
      TYPE Intrastat_Line_Tab IS TABLE OF get_pre_intrastat_data%ROWTYPE INDEX BY PLS_INTEGER;
      
      pre_intrastat_line_tab_    Intrastat_Line_Tab;   
      temp_intrastat_line_tab_   Intrastat_Line_Tab;
      new_intrastat_line_tab_    Intrastat_Line_Tab;

   CURSOR get_no_lines IS
      SELECT COUNT(*) no_rows
      FROM   intrastat_line_tab
      WHERE  intrastat_id IN (pre_intrastat_id_, intrastat_id_)
      AND    intrastat_direction = intrastat_direction_;
BEGIN
   OPEN get_no_lines;
   FETCH get_no_lines INTO direction_lines_;
   CLOSE get_no_lines;
   
   IF(pre_intrastat_id_ IS NOT NULL) THEN
      OPEN get_pre_intrastat_data;
      FETCH get_pre_intrastat_data BULK COLLECT INTO pre_intrastat_line_tab_;
      CLOSE get_pre_intrastat_data; 
   END IF;
   
   OPEN get_temp_intrastat_data;
   FETCH get_temp_intrastat_data BULK COLLECT INTO temp_intrastat_line_tab_;
   CLOSE get_temp_intrastat_data;
   
   IF(pre_intrastat_line_tab_.COUNT > 0 AND temp_intrastat_line_tab_.COUNT > 0)THEN
      FOR i IN temp_intrastat_line_tab_.FIRST..temp_intrastat_line_tab_.LAST LOOP
         FOR j IN pre_intrastat_line_tab_.FIRST..pre_intrastat_line_tab_.LAST LOOP
            IF(NVL(temp_intrastat_line_tab_(i).transaction_id,0) != pre_intrastat_line_tab_(j).transaction_id)THEN
               IF((temp_intrastat_line_tab_(i).customs_stat_no 
                                                                  = pre_intrastat_line_tab_(j).customs_stat_no) AND
                  (temp_intrastat_line_tab_(i).opposite_country 
                                                                  = pre_intrastat_line_tab_(j).opposite_country) AND
                  (temp_intrastat_line_tab_(i).mode_of_transport 
                                                                  = pre_intrastat_line_tab_(j).mode_of_transport) AND
                  (temp_intrastat_line_tab_(i).delivery_terms 
                                                                  = pre_intrastat_line_tab_(j).delivery_terms)) THEN
                  rec_found_ := TRUE;
               END IF;
            ELSIF(NVL(temp_intrastat_line_tab_(i).transaction_id,0) = pre_intrastat_line_tab_(j).transaction_id)THEN
               match_found_ := TRUE;
               EXIT;
            END IF;
         END LOOP;
         IF NOT(match_found_)THEN
            IF NOT(rec_found_)THEN
               new_intrastat_line_tab_(new_index_) := temp_intrastat_line_tab_(i);
               new_index_ := new_index_ + 1;
            ELSE
               pre_index_ := pre_intrastat_line_tab_.LAST + 1;
               pre_intrastat_line_tab_(pre_index_) := temp_intrastat_line_tab_(i);
               rec_found_ := FALSE;
            END IF;
         ELSE
            match_found_ := FALSE;
            rec_found_ := FALSE;
         END IF;
      END LOOP;
   ELSIF(temp_intrastat_line_tab_.COUNT > 0)THEN
      FOR i IN temp_intrastat_line_tab_.FIRST..temp_intrastat_line_tab_.LAST LOOP
         new_intrastat_line_tab_(new_index_) := temp_intrastat_line_tab_(i);
         new_index_ := new_index_ + 1;
      END LOOP;
   END IF;
   IF(direction_lines_ > 0) THEN
      IF (pre_intrastat_line_tab_.COUNT > 0) THEN
         FORALL i_ IN pre_intrastat_line_tab_.FIRST..pre_intrastat_line_tab_.LAST
            INSERT INTO intrastat_line_all_tmp (intrastat_id,
                                                line_no,
                                                transaction,
                                                order_type,
                                                contract,
                                                part_no,
                                                part_description,
                                                configuration_id,
                                                lot_batch_no,
                                                serial_no,
                                                order_ref1,
                                                order_ref2,
                                                order_ref3,
                                                order_ref4,
                                                inventory_direction,
                                                quantity,
                                                qty_reversed,
                                                unit_meas,
                                                reject_code,
                                                date_applied,
                                                userid,
                                                net_unit_weight,
                                                customs_stat_no,
                                                intrastat_alt_qty,
                                                intrastat_alt_unit_meas,
                                                notc,
                                                intrastat_direction,
                                                country_of_origin,
                                                intrastat_origin,
                                                opposite_country,
                                                opponent_number,
                                                opponent_name,
                                                order_unit_price,
                                                unit_add_cost_amount,
                                                unit_charge_amount,
                                                mode_of_transport,
                                                invoice_serie,
                                                invoice_number,
                                                invoiced_unit_price,
                                                unit_add_cost_amount_inv,
                                                unit_charge_amount_inv,
                                                delivery_terms,
                                                triangulation,
                                                region_port,
                                                statistical_procedure,
                                                rowversion,
                                                rowstate,
                                                region_of_origin,             
                                                county,
                                                return_reason,
                                                return_material_reason,
                                                rowkey,
                                                opponent_type,
                                                movement_code,
                                                unit_statistical_charge_diff,
                                                opponent_tax_id,
                                                del_terms_location,
                                                place_of_delivery)
                                        VALUES (pre_intrastat_line_tab_(i_).intrastat_id,
                                                pre_intrastat_line_tab_(i_).line_no,
                                                pre_intrastat_line_tab_(i_).transaction,
                                                pre_intrastat_line_tab_(i_).order_type,
                                                pre_intrastat_line_tab_(i_).contract,
                                                pre_intrastat_line_tab_(i_).part_no,
                                                pre_intrastat_line_tab_(i_).part_description,
                                                pre_intrastat_line_tab_(i_).configuration_id,
                                                pre_intrastat_line_tab_(i_).lot_batch_no,
                                                pre_intrastat_line_tab_(i_).serial_no,
                                                pre_intrastat_line_tab_(i_).order_ref1,
                                                pre_intrastat_line_tab_(i_).order_ref2,
                                                pre_intrastat_line_tab_(i_).order_ref3,
                                                pre_intrastat_line_tab_(i_).order_ref4,
                                                pre_intrastat_line_tab_(i_).inventory_direction,
                                                pre_intrastat_line_tab_(i_).quantity,
                                                pre_intrastat_line_tab_(i_).qty_reversed,
                                                pre_intrastat_line_tab_(i_).unit_meas,
                                                pre_intrastat_line_tab_(i_).reject_code,
                                                pre_intrastat_line_tab_(i_).date_applied,
                                                pre_intrastat_line_tab_(i_).userid,
                                                pre_intrastat_line_tab_(i_).net_unit_weight,
                                                pre_intrastat_line_tab_(i_).customs_stat_no,
                                                pre_intrastat_line_tab_(i_).intrastat_alt_qty,
                                                pre_intrastat_line_tab_(i_).intrastat_alt_unit_meas,
                                                pre_intrastat_line_tab_(i_).notc,
                                                pre_intrastat_line_tab_(i_).intrastat_direction,
                                                pre_intrastat_line_tab_(i_).country_of_origin,
                                                pre_intrastat_line_tab_(i_).intrastat_origin,
                                                pre_intrastat_line_tab_(i_).opposite_country,
                                                pre_intrastat_line_tab_(i_).opponent_number,
                                                pre_intrastat_line_tab_(i_).opponent_name,
                                                pre_intrastat_line_tab_(i_).order_unit_price,
                                                pre_intrastat_line_tab_(i_).unit_add_cost_amount,
                                                pre_intrastat_line_tab_(i_).unit_charge_amount,
                                                pre_intrastat_line_tab_(i_).mode_of_transport,
                                                pre_intrastat_line_tab_(i_).invoice_serie,
                                                pre_intrastat_line_tab_(i_).invoice_number,               
                                                pre_intrastat_line_tab_(i_).invoiced_unit_price,
                                                pre_intrastat_line_tab_(i_).unit_add_cost_amount_inv,
                                                pre_intrastat_line_tab_(i_).unit_charge_amount_inv,
                                                pre_intrastat_line_tab_(i_).delivery_terms,
                                                pre_intrastat_line_tab_(i_).triangulation,
                                                pre_intrastat_line_tab_(i_).region_port,
                                                pre_intrastat_line_tab_(i_).statistical_procedure,
                                                pre_intrastat_line_tab_(i_).rowversion,
                                                pre_intrastat_line_tab_(i_).rowstate,
                                                pre_intrastat_line_tab_(i_).region_of_origin,
                                                pre_intrastat_line_tab_(i_).county,
                                                pre_intrastat_line_tab_(i_).return_reason,
                                                pre_intrastat_line_tab_(i_).return_material_reason,
                                                pre_intrastat_line_tab_(i_).rowkey,
                                                pre_intrastat_line_tab_(i_).opponent_type,
                                                pre_intrastat_line_tab_(i_).movement_code,
                                                pre_intrastat_line_tab_(i_).unit_statistical_charge_diff,
                                                pre_intrastat_line_tab_(i_).opponent_tax_id,
                                                pre_intrastat_line_tab_(i_).del_terms_location,
                                                pre_intrastat_line_tab_(i_).place_of_delivery);
         
               Create_Output_Line___(output_clob_,
                                    total_ivc_value_,
                                    total_stat_value_,
                                    pos_id_,
                                    intrastat_id_,
                                    pre_intrastat_id_,
                                    rep_curr_rate_,
                                    company_,
                                    intrastat_direction_,
                                    country_code_);
            DELETE FROM intrastat_line_all_tmp;
      END IF;
      IF(new_intrastat_line_tab_.COUNT > 0)THEN
         FORALL i_ IN new_intrastat_line_tab_.FIRST..new_intrastat_line_tab_.LAST
            INSERT INTO intrastat_line_all_tmp (intrastat_id,
                                                line_no,
                                                transaction,
                                                order_type,
                                                contract,
                                                part_no,
                                                part_description,
                                                configuration_id,
                                                lot_batch_no,
                                                serial_no,
                                                order_ref1,
                                                order_ref2,
                                                order_ref3,
                                                order_ref4,
                                                inventory_direction,
                                                quantity,
                                                qty_reversed,
                                                unit_meas,
                                                reject_code,
                                                date_applied,
                                                userid,
                                                net_unit_weight,
                                                customs_stat_no,
                                                intrastat_alt_qty,
                                                intrastat_alt_unit_meas,
                                                notc,
                                                intrastat_direction,
                                                country_of_origin,
                                                intrastat_origin,
                                                opposite_country,
                                                opponent_number,
                                                opponent_name,
                                                order_unit_price,
                                                unit_add_cost_amount,
                                                unit_charge_amount,
                                                mode_of_transport,
                                                invoice_serie,
                                                invoice_number,
                                                invoiced_unit_price,
                                                unit_add_cost_amount_inv,
                                                unit_charge_amount_inv,
                                                delivery_terms,
                                                triangulation,
                                                region_port,
                                                statistical_procedure,
                                                rowversion,
                                                rowstate,
                                                region_of_origin,             
                                                county,
                                                return_reason,
                                                return_material_reason,
                                                rowkey,
                                                opponent_type,
                                                movement_code,
                                                unit_statistical_charge_diff,
                                                opponent_tax_id,
                                                del_terms_location,
                                                place_of_delivery)
                                        VALUES (new_intrastat_line_tab_(i_).intrastat_id,
                                                new_intrastat_line_tab_(i_).line_no,
                                                new_intrastat_line_tab_(i_).transaction,
                                                new_intrastat_line_tab_(i_).order_type,
                                                new_intrastat_line_tab_(i_).contract,
                                                new_intrastat_line_tab_(i_).part_no,
                                                new_intrastat_line_tab_(i_).part_description,
                                                new_intrastat_line_tab_(i_).configuration_id,
                                                new_intrastat_line_tab_(i_).lot_batch_no,
                                                new_intrastat_line_tab_(i_).serial_no,
                                                new_intrastat_line_tab_(i_).order_ref1,
                                                new_intrastat_line_tab_(i_).order_ref2,
                                                new_intrastat_line_tab_(i_).order_ref3,
                                                new_intrastat_line_tab_(i_).order_ref4,
                                                new_intrastat_line_tab_(i_).inventory_direction,
                                                new_intrastat_line_tab_(i_).quantity,
                                                new_intrastat_line_tab_(i_).qty_reversed,
                                                new_intrastat_line_tab_(i_).unit_meas,
                                                new_intrastat_line_tab_(i_).reject_code,
                                                new_intrastat_line_tab_(i_).date_applied,
                                                new_intrastat_line_tab_(i_).userid,
                                                new_intrastat_line_tab_(i_).net_unit_weight,
                                                new_intrastat_line_tab_(i_).customs_stat_no,
                                                new_intrastat_line_tab_(i_).intrastat_alt_qty,
                                                new_intrastat_line_tab_(i_).intrastat_alt_unit_meas,
                                                new_intrastat_line_tab_(i_).notc,
                                                new_intrastat_line_tab_(i_).intrastat_direction,
                                                new_intrastat_line_tab_(i_).country_of_origin,
                                                new_intrastat_line_tab_(i_).intrastat_origin,
                                                new_intrastat_line_tab_(i_).opposite_country,
                                                new_intrastat_line_tab_(i_).opponent_number,
                                                new_intrastat_line_tab_(i_).opponent_name,
                                                new_intrastat_line_tab_(i_).order_unit_price,
                                                new_intrastat_line_tab_(i_).unit_add_cost_amount,
                                                new_intrastat_line_tab_(i_).unit_charge_amount,
                                                new_intrastat_line_tab_(i_).mode_of_transport,
                                                new_intrastat_line_tab_(i_).invoice_serie,
                                                new_intrastat_line_tab_(i_).invoice_number,               
                                                new_intrastat_line_tab_(i_).invoiced_unit_price,
                                                new_intrastat_line_tab_(i_).unit_add_cost_amount_inv,
                                                new_intrastat_line_tab_(i_).unit_charge_amount_inv,
                                                new_intrastat_line_tab_(i_).delivery_terms,
                                                new_intrastat_line_tab_(i_).triangulation,
                                                new_intrastat_line_tab_(i_).region_port,
                                                new_intrastat_line_tab_(i_).statistical_procedure,
                                                new_intrastat_line_tab_(i_).rowversion,
                                                new_intrastat_line_tab_(i_).rowstate,
                                                new_intrastat_line_tab_(i_).region_of_origin,
                                                new_intrastat_line_tab_(i_).county,
                                                new_intrastat_line_tab_(i_).return_reason,
                                                new_intrastat_line_tab_(i_).return_material_reason,
                                                new_intrastat_line_tab_(i_).rowkey,
                                                new_intrastat_line_tab_(i_).opponent_type,
                                                new_intrastat_line_tab_(i_).movement_code,
                                                new_intrastat_line_tab_(i_).unit_statistical_charge_diff,
                                                new_intrastat_line_tab_(i_).opponent_tax_id,
                                                new_intrastat_line_tab_(i_).del_terms_location,
                                                new_intrastat_line_tab_(i_).place_of_delivery);
            Create_Output_Line___(output_clob_,
                                 total_ivc_value_,
                                 total_stat_value_,
                                 pos_id_,
                                 intrastat_id_,
                                 pre_intrastat_id_,
                                 rep_curr_rate_,
                                 company_,
                                 intrastat_direction_,
                                 country_code_);
            DELETE FROM intrastat_line_all_tmp;
      END IF;
   END IF;
END Create_Details__;

-- Method removes unwanted EDIFACT specified characters from a string.
@UncheckedAccess
FUNCTION Filter__ (
   str_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   out_str_ VARCHAR2(2000);
BEGIN
   -- remove any EDIFACTs defined characters
   out_str_ := replace(str_, '''');
   out_str_ := replace(out_str_, '+');
   out_str_ := replace(out_str_, ':');
   out_str_ := replace(out_str_, '?');
   out_str_ := replace(out_str_, '-');
   out_str_ := replace(out_str_, ' ');
   RETURN out_str_;
END Filter__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Output
--   Method fetches the intrastat data and formats it according to
--   specifications for Polan
PROCEDURE Create_Output (
   output_clob_          OUT CLOB,
   info_                 OUT VARCHAR2,
   import_progress_no_   OUT NUMBER,
   export_progress_no_   OUT NUMBER,
   intrastat_id_         IN  NUMBER,
   intrastat_export_     IN  VARCHAR2,
   intrastat_import_     IN  VARCHAR2,
   pre_intrastat_id_     IN  NUMBER DEFAULT NULL)
IS
   total_items_             NUMBER;
   line_                    VARCHAR2(32000);
   vat_no_                  VARCHAR2(50);   
   intrastat_direction_     VARCHAR2(10);
   direction_type_          VARCHAR2(1);
   doc_type_                VARCHAR2(1) := 'D';
   association_no_          VARCHAR2(50);
   address_id_              Company_Address_Pub.address_id%TYPE;
   contact_email_           VARCHAR2(200);
   company_email_           VARCHAR2(200);
   name_                    VARCHAR2(100);
   addr1_                   VARCHAR2(100);
   city_                    VARCHAR2(35);
   zip_code_                VARCHAR2(35);
   own_no_                  VARCHAR2(20);
   comp_association_        VARCHAR2(50);
   phone_                   VARCHAR2(200);
   fax_                     VARCHAR2(200);
   contact_address_id_      VARCHAR2(50);
   contact_city_            VARCHAR2(35);
   notc_dummy_              VARCHAR2(2);
   rep_curr_rate_           NUMBER;
   country_code_            VARCHAR2(2);
   progress_no_             NUMBER;
   declaration_no_          NUMBER;
   total_ivc_value_         NUMBER;
   total_stat_value_        NUMBER;
   header_output_clob_      CLOB;

   CURSOR get_notc IS
      SELECT DISTINCT notc
      FROM   intrastat_line_tab
      WHERE  intrastat_id = intrastat_id_;

   CURSOR get_country_notc (notc_ VARCHAR2) IS
      SELECT country_notc
      FROM   country_notc_tab
      WHERE  notc = notc_
      AND    country_code = 'PL';

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
             RPAD(bransch_no_repr,14,0) bransch_no_repr,
             dec_number_export,
             version_export,
             DECODE(declaration_export, Intrastat_Declaration_API.DB_DECLARATION, 'D',
                                        Intrastat_Declaration_API.DB_CORRECTION,  'P',
                                        Intrastat_Declaration_API.DB_REPLACEMENT, 'K')      declaration_export,
             dec_number_import,
             version_import,
             DECODE(declaration_import, Intrastat_Declaration_API.DB_DECLARATION, 'D',
                                        Intrastat_Declaration_API.DB_CORRECTION,  'P',
                                        Intrastat_Declaration_API.DB_REPLACEMENT, 'K')       declaration_import 
      FROM   intrastat_tab
      WHERE  intrastat_id = intrastat_id_;
   
   CURSOR get_no_of_lines IS
      SELECT COUNT(*)
      FROM (SELECT 1
            FROM   intrastat_line_tab il, country_notc_tab cn
            WHERE  il.intrastat_id IN (pre_intrastat_id_, intrastat_id_)
            AND    il.intrastat_direction = intrastat_direction_
            AND    il.rowstate = 'Released'
            AND    il.notc = cn.notc
            AND    cn.country_code = country_code_
            GROUP BY  il.intrastat_direction,
                      il.opposite_country,
                      il.country_of_origin,
                      cn.country_notc,
                      il.mode_of_transport,
                      il.customs_stat_no,
                      il.delivery_terms,
                      il.opponent_tax_id);
BEGIN
   IF (intrastat_export_ IS NOT NULL AND intrastat_import_ IS NOT NULL) THEN
      intrastat_direction_ := 'BOTH';
   ELSIF (intrastat_export_ = 'EXPORT' AND intrastat_import_ IS NULL) THEN
      intrastat_direction_ := intrastat_export_;
      direction_type_ := 'W';
   ELSIF (intrastat_export_ IS NULL AND intrastat_import_ = 'IMPORT') THEN
      intrastat_direction_ := intrastat_import_;
      direction_type_ := 'P';
   ELSE
      Error_SYS.Record_General(lu_name_, 'DIRECTIONSNULL: At least one transfer option must be checked.');
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

      IF (intrastat_direction_ = 'IMPORT') THEN
         Validate_Import_Export___(headrec_.dec_number_import, headrec_.version_import, headrec_.declaration_import);
      ELSIF (intrastat_direction_ = 'EXPORT') THEN
         Validate_Import_Export___(headrec_.dec_number_export, headrec_.version_export, headrec_.declaration_export);
      END IF;

      $IF (Component_Invoic_SYS.INSTALLED) $THEN
         vat_no_ := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(headrec_.company, headrec_.country_code, TRUNC(headrec_.creation_date));
      $END

      IF (headrec_.customs_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOCUSTOMID: Customs ID is missing for Intrastat ID :P1.',intrastat_id_);
      END IF;

      association_no_ := Customs_Info_API.Get_Association_No(headrec_.customs_id);
      
      IF (association_no_ IS NULL) THEN
        association_no_ := headrec_.customs_id;
      END IF;

      IF (headrec_.rep_curr_code NOT IN ('PLN','EUR')) THEN
         Error_SYS.Record_General(lu_name_, 'WRONGCURRPLF: Currency Code :P1 is not a valid currency, only PLN and EUR is acceptable', headrec_.rep_curr_code);
      END IF;
      IF vat_no_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOCOMPVATNO: TAX number is missing for company :P1.',headrec_.company);
      END IF;

      IF (SUBSTR(vat_no_, 1, 2) = 'PL') THEN
         vat_no_ := SUBSTR(Filter__(vat_no_),3,10);
      ELSE
         vat_no_ := SUBSTR(Filter__(vat_no_),1,10);
      END IF;

      rep_curr_rate_ := headrec_.rep_curr_rate;
      country_code_  := headrec_.country_code;

      OPEN get_no_of_lines;
      FETCH get_no_of_lines INTO total_items_;
      CLOSE get_no_of_lines;

      -- Company address
      address_id_ := Company_Address_API.Get_Default_Address(headrec_.company, Address_Type_Code_API.Decode('INVOICE'));
      IF address_id_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOCOMPADDR: There is no default invoice address for the company!');
      END IF;
      name_             := Company_API.Get_Name(headrec_.company);
      addr1_            := Company_Address_API.Get_Address1(headrec_.company, address_id_);
      city_             := Company_Address_API.Get_City(headrec_.company, address_id_);
      zip_code_         := Company_Address_API.Get_Zip_Code(headrec_.company, address_id_);
      comp_association_ := Company_API.Get_Association_No(headrec_.company);
      IF name_ IS NULL OR addr1_ IS NULL OR zip_code_ IS NULL OR city_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'INCOMADDR: Company address is incomplete!');
      END IF;

      -- Company default e-mail
      company_email_ := Comm_Method_API.Get_Default_Value('COMPANY', headrec_.company, 'E_MAIL');

      -- Company contact
      contact_address_id_ := Person_Info_Address_API.Get_Default_Address(headrec_.company_contact, Address_Type_Code_API.Decode('VISIT'));
      contact_city_       := Person_Info_Address_API.Get_City(headrec_.company_contact, contact_address_id_);
      contact_email_      := Comm_Method_API.Get_Default_Value('PERSON', headrec_.company_contact, 'E_MAIL');
      IF contact_city_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'INCRCONTADDR: Company contact person address is incomplete!');
      END IF;

      -- Creation of the XML part
      line_ := '<?xml version="1.0" encoding="UTF-8" ?>'|| chr(13) || chr(10);
      output_clob_ := line_;
      IF company_email_ IS NOT NULL THEN
         line_ := '<ist:IST Email="'||company_email_||'" xmlns:ist="http://www.mf.gov.pl/xsd/Intrastat/IST.xsd">'|| chr(13) || chr(10);
      ELSE
         line_ := '<ist:IST xmlns:ist="http://www.mf.gov.pl/xsd/Intrastat/IST.xsd">'|| chr(13) || chr(10);
      END IF;
      output_clob_ := output_clob_ || line_;

      import_progress_no_ := NULL;
      export_progress_no_ := NULL;
      
      IF intrastat_direction_ = 'IMPORT' THEN
         progress_no_    := headrec_.version_import;
         doc_type_       := headrec_.declaration_import;
         declaration_no_ := headrec_.dec_number_import;
         own_no_ := TO_CHAR(headrec_.end_date,'YY')||'IST'||intrastat_id_|| 'I';
      ELSIF intrastat_direction_ = 'EXPORT' THEN
         progress_no_    := headrec_.version_export;
         doc_type_       := headrec_.declaration_export;
         declaration_no_ := headrec_.dec_number_export;
         own_no_ := TO_CHAR(headrec_.end_date,'YY')||'IST'||intrastat_id_|| 'E';
      END IF;
      
      IF intrastat_direction_ = 'BOTH' THEN
         progress_no_    := NULL;
         doc_type_       := NULL;
         declaration_no_ := NULL;
         own_no_ := TO_CHAR(headrec_.end_date,'YY')||'IST'||intrastat_id_|| 'IE';
      END IF; 

      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('BEGIN',                    '  <Deklaracja',                       line_);
      Client_SYS.Add_To_Attr('xmlns',    'http://www.mf.gov.pl/xsd/Intrastat/IST.xsd',          line_);
      Client_SYS.Add_To_Attr('NrWlasny',                 own_no_,                               line_);
      Client_SYS.Add_To_Attr('UC',                       association_no_,                       line_);
      Client_SYS.Add_To_Attr('Typ',                      direction_type_,                       line_);
      Client_SYS.Add_To_Attr('Rodzaj',                   doc_type_,                             line_);
      Client_SYS.Add_To_Attr('Rok',                      to_char(headrec_.end_date,'YYYY'),     line_);
      Client_SYS.Add_To_Attr('Miesiac',                  to_char(headrec_.end_date,'MM'),       line_);
      Client_SYS.Add_To_Attr('Numer',                    declaration_no_,                       line_);
      Client_SYS.Add_To_Attr('Wersja',                   progress_no_,                          line_);
      Client_SYS.Add_To_Attr('LacznaWartoscFaktur',      'dummy_total_invoice_value',           line_);
      Client_SYS.Add_To_Attr('LacznaWartoscStatystyczna','dummy_total_statistical_value',       line_);
      Client_SYS.Add_To_Attr('LacznaLiczbaPozycji',      ROUND(total_items_),                   line_);
      Client_SYS.Add_To_Attr('Miejscowosc',              contact_city_,                         line_);
      Client_SYS.Add_To_Attr('Data',                     TO_CHAR(SYSDATE,'YYYY-MM-DD'),         line_);
      Client_SYS.Add_To_Attr('END',                      '>',                                   line_);
      Create_Line___(output_clob_, line_);
      -- Company info
      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('BEGIN',                    '     <PodmiotZobowiazany',   line_);
      Client_SYS.Add_To_Attr('Nazwa',                    Encode___(name_),             line_);
      Client_SYS.Add_To_Attr('UlicaNumer',               Encode___(addr1_),            line_);
      Client_SYS.Add_To_Attr('KodPocztowy',              zip_code_,                    line_);
      Client_SYS.Add_To_Attr('Miejscowosc',              city_,                        line_);
      Client_SYS.Add_To_Attr('Nip',                      vat_no_,                      line_);
      IF comp_association_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('Regon',                 RPAD(comp_association_,14,0), line_);
      END IF;
      Client_SYS.Add_To_Attr('END',                      ' />',                        line_);
      Create_Line___(output_clob_, line_);      
      header_output_clob_ := output_clob_;
      output_clob_ := null;
      
      IF headrec_.representative IS NOT NULL THEN
         IF headrec_.repr_tax_no IS NULL THEN
            Error_SYS.Record_General(lu_name_, 'REPRVATNONOTEX: Vat Number for representative person is missing!');
         END IF;

         IF (SUBSTR(headrec_.repr_tax_no, 1, 2) = 'PL') THEN
            headrec_.repr_tax_no := SUBSTR(headrec_.repr_tax_no,4,10);
         END IF;

         address_id_ := Person_Info_Address_API.Get_Default_Address(headrec_.representative, Address_Type_Code_API.Decode('VISIT'));
         IF address_id_ IS NULL THEN
            Error_SYS.Record_General(lu_name_, 'NOREPRADDR: There is no default visit address for representative person!');
         END IF;
         name_     := Person_Info_API.Get_Name(headrec_.representative);
         addr1_    := Person_Info_Address_API.Get_Address1(headrec_.representative, address_id_);
         city_     := Person_Info_Address_API.Get_City(headrec_.representative, address_id_);
         zip_code_ := Person_Info_Address_API.Get_Zip_Code(headrec_.representative, address_id_);
         IF name_ IS NULL OR addr1_ IS NULL OR zip_code_ IS NULL OR city_ IS NULL THEN
            Error_SYS.Record_General(lu_name_, 'INCREPRADDR: Representative person address is incomplete!');
         END IF;

         Client_SYS.Clear_Attr(line_);
         Client_SYS.Add_To_Attr('BEGIN',                    '     <Zglaszajacy',          line_);
         Client_SYS.Add_To_Attr('Nazwa',                    Encode___(name_),             line_);
         Client_SYS.Add_To_Attr('UlicaNumer',               Encode___(addr1_),            line_);
         Client_SYS.Add_To_Attr('KodPocztowy',              zip_code_,                    line_);
         Client_SYS.Add_To_Attr('Miejscowosc',              city_,                        line_);
         Client_SYS.Add_To_Attr('Nip',                      headrec_.repr_tax_no,         line_);
         IF comp_association_ IS NOT NULL THEN
            Client_SYS.Add_To_Attr('Regon',                 headrec_.bransch_no_repr,     line_);
         END IF;
         Client_SYS.Add_To_Attr('END',                      ' />',                        line_);
         Create_Line___(output_clob_, line_);
      END IF;
      -- End XML Header part

      -- Create the intrastat lines for Import
      IF (intrastat_import_ = 'IMPORT') THEN
         Create_Details__(output_clob_,
                          total_ivc_value_,
                          total_stat_value_,
                          intrastat_id_,
                          'IMPORT',
                          headrec_.creation_date,
                          headrec_.end_date,
                          headrec_.company,
                          headrec_.bransch_no,
                          headrec_.bransch_no_repr,
                          vat_no_,
                          headrec_.repr_tax_no,
                          headrec_.company_contact,
                          headrec_.representative,
                          headrec_.rep_curr_code,
                          headrec_.rep_curr_rate,
                          headrec_.country_code,
                          pre_intrastat_id_);
      END IF;

      -- Create the intrastat lines for Export
      IF (intrastat_export_ = 'EXPORT') THEN
         Create_Details__(output_clob_,
                          total_ivc_value_,
                          total_stat_value_,
                          intrastat_id_,
                          'EXPORT',
                          headrec_.creation_date,
                          headrec_.end_date,
                          headrec_.company,
                          headrec_.bransch_no,
                          headrec_.bransch_no_repr,
                          vat_no_,
                          headrec_.repr_tax_no,
                          headrec_.company_contact,
                          headrec_.representative,
                          headrec_.rep_curr_code,
                          headrec_.rep_curr_rate,
                          headrec_.country_code,
                          pre_intrastat_id_);
      END IF;

      -- Company contact
      name_  := Person_Info_API.Get_Name(headrec_.company_contact);
      phone_ := Comm_Method_API.Get_Default_Value('PERSON', headrec_.company_contact, 'PHONE');
      fax_   := Comm_Method_API.Get_Default_Value('PERSON', headrec_.company_contact, 'FAX');

      Client_SYS.Clear_Attr(line_);
      Client_SYS.Add_To_Attr('BEGIN',                    '     <Wypelniajacy',         line_);
      Client_SYS.Add_To_Attr('NazwiskoImie',             Encode___(name_),             line_);
      IF phone_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('Telefon',               phone_,                       line_);
      END IF;
      IF fax_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('Faks',                  fax_,                         line_);
      END IF;
      IF contact_email_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('Email',                 contact_email_,               line_);
      END IF;
      Client_SYS.Add_To_Attr('END',                      ' />',                        line_);
      Create_Line___(output_clob_, line_);
   END LOOP;

   line_ := '  </Deklaracja>'|| chr(13) || chr(10)||'</ist:IST>';
   output_clob_ := output_clob_ || line_;  
   header_output_clob_ := REPLACE(header_output_clob_, 'dummy_total_invoice_value', total_ivc_value_ );
   header_output_clob_ := REPLACE(header_output_clob_, 'dummy_total_statistical_value', total_stat_value_ );  
   output_clob_ := header_output_clob_ || output_clob_; 
   
   info_        := Client_SYS.Get_All_Info;
END Create_Output;   
