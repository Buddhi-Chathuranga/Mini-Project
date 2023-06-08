-----------------------------------------------------------------------------
--
--  Logical unit: CrossBorderPartMoveTax
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date       Sign    History
--  ------     ------  ---------------------------------------------------------
-- 2021-12-10  MaEelk  SC21R2-1762, Added IgnoreUnitTest annotation to Get_Next_Tax_Line_No.
-- 2021-07-19  MaEelk  SC21R2-1884, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@IgnoreUnitTest TrivialFunction
@UncheckedAccess
FUNCTION Get_Next_Tax_Line_No (
   company_          IN VARCHAR2,
   sender_country_   IN VARCHAR2,
   receiver_country_ IN VARCHAR2,
   part_no_          IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR max_tax_line_no IS
      SELECT MAX(tax_line_no)
      FROM   cross_border_part_move_tax_tab
      WHERE  company = company_
      AND    sender_country = sender_country_
      AND    receiver_country = receiver_country_
      AND    part_no = part_no_;
      
   max_tax_line_no_ NUMBER;
BEGIN
   OPEN max_tax_line_no;
   FETCH max_tax_line_no INTO max_tax_line_no_;
   CLOSE max_tax_line_no;
   
   RETURN NVL(max_tax_line_no_, 0) + 1;
   
END Get_Next_Tax_Line_No;

