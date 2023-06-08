-----------------------------------------------------------------------------
--
--  Logical unit: CrossBorderPartReceTax
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date       Sign    History
--  ------     ------  ---------------------------------------------------------
-- 2021-12-10  MaEelk  SC21R2-1762, Added IgnoreUnitTest annotation to Check_Insert___.
-- 2021-07-19  MaEelk  SC21R2-1884, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@IgnoreUnitTest TrivialFunction
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT NOCOPY cross_border_part_move_tax_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN   
   newrec_.tax_line_no := Cross_Border_Part_Move_Tax_API.Get_Next_Tax_Line_No (newrec_.company, newrec_.sender_country, newrec_.receiver_country, newrec_.part_no);
   Validate_Line___(newrec_);
   SUPER(newrec_, indrec_, attr_);
END Check_Insert___;

PROCEDURE Validate_Line___ (
   newrec_ IN OUT NOCOPY cross_border_part_move_tax_tab%ROWTYPE )
IS
   CURSOR get_line_rec IS
      SELECT tax_code, valid_from
      FROM   cross_border_part_move_tax_tab
      WHERE  company = newrec_.company
      AND    sender_country = newrec_.sender_country
      AND    receiver_country = newrec_.receiver_country
      AND    part_no = newrec_.part_no
      AND    rowtype LIKE 'CrossBorderPartReceTax%';

   tax_code_valid_from_ DATE;

BEGIN
   FOR rec_ IN get_line_rec LOOP
      IF (rec_.tax_code = newrec_.tax_code) THEN
         Error_SYS.Record_General(lu_name_, 'TAXCODEEXIST: Tax Code :P1 is already defined in Receiver Country :P2.', newrec_.tax_code, Iso_Country_API.Decode(newrec_.receiver_country));  
      END IF;

      IF (rec_.valid_from = newrec_.valid_from) THEN
         Error_SYS.Record_General(lu_name_, 'VALIDFROMEXIST: Valid From Date :P1 is already defined for Tax Code :P2 in Receiver Country :P3.', newrec_.valid_from, rec_.tax_code, Iso_Country_API.Decode(newrec_.receiver_country));  
      END IF;      
   END LOOP; 
   
   tax_code_valid_from_ := Statutory_Fee_API.Get_Valid_From (newrec_.company, newrec_.tax_code);
   IF (newrec_.valid_from < tax_code_valid_from_) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDVALIDFROM: Valid From Date :P1 should not be less than the Valid From Date :P2 defined for Tax Code :P3.', newrec_.valid_from, tax_code_valid_from_, newrec_.tax_code);  
   END IF;

END Validate_Line___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION Get_Latest_Receiver_Tax_Code (
   company_          IN VARCHAR2,
   sender_country_   IN VARCHAR2,
   receiver_country_ IN VARCHAR2,
   part_no_          IN VARCHAR2,
   from_date_        IN DATE ) RETURN VARCHAR2 
IS
   CURSOR receiver_tax_for_part IS
      SELECT tax_code
      FROM   cross_border_part_move_tax_tab
      WHERE  company = company_
      AND    sender_country = sender_country_
      AND    receiver_country = receiver_country_
      AND    part_no = part_no_
      AND    valid_from <= from_date_
      AND    rowtype LIKE 'CrossBorderPartReceTax%'
      ORDER BY valid_from DESC;

   CURSOR receiver_tax_for_all_parts IS
      SELECT tax_code
      FROM   cross_border_part_move_tax_tab
      WHERE  company = company_
      AND    sender_country = sender_country_
      AND    receiver_country = receiver_country_
      AND    part_no = '*'
      AND    valid_from <= from_date_
      AND    rowtype LIKE 'CrossBorderPartReceTax%'
      ORDER BY valid_from DESC;

   receiver_tax_code_  VARCHAR2(20);
   
BEGIN
   OPEN receiver_tax_for_part;
   FETCH receiver_tax_for_part INTO receiver_tax_code_;
   IF receiver_tax_for_part%NOTFOUND THEN
      OPEN receiver_tax_for_all_parts;
      FETCH receiver_tax_for_all_parts INTO receiver_tax_code_;
      CLOSE receiver_tax_for_all_parts;
   END IF;
   CLOSE receiver_tax_for_part;
   RETURN receiver_tax_code_;  
END Get_Latest_Receiver_Tax_Code;
