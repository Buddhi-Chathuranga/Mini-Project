-----------------------------------------------------------------------------
--
--  Logical unit: TaxIdType
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210103  Chajlk  Created.
--  240324  Shsalk  IID ARFI124NC. Added new attribute layout_format and function Format_Tax_Number.
--  250324  Raablk  IID ARFI123N. Added new function Get_Report_Code.
--  120905  WAPELK  Merged LCS 52177. Corrected the variable lengths of Format_Tax_Number Function.
--  101104  Mamalk  DF-489, Added method Check_Country_Type
--  210212  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified method Update_Layout__
--  211210  Chwilk  KEEP-5772, Merged Bug 161134, Overrided Check_Insert___, as the mandatory attribute validate_tax_id_number was added to the entity.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   validate_tax_id_number_ VARCHAR2(20);
BEGIN
   super(attr_);
   validate_tax_id_number_ := Fnd_Boolean_API.DB_FALSE;
   Client_SYS.Add_To_Attr('VALIDATE_TAX_ID_NUMBER_DB', validate_tax_id_number_, attr_);
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Update_Layout__ (
   tax_id_type_   IN VARCHAR2,
   layout_format_ IN VARCHAR2 )
IS
   newrec_           tax_id_type_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(tax_id_type_);
   newrec_.layout_format   := layout_format_;
   Modify___(newrec_);
END Update_Layout__;
               
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Format_Tax_Number (
   layout_format_ IN VARCHAR2,
   tax_id_number_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp1_  VARCHAR2(50);
   temp2_  VARCHAR2(50);
   temp3_  VARCHAR2(50);
   dummy_  VARCHAR2(50);
   j_ NUMBER;
   k_ NUMBER;
   l_ NUMBER;
BEGIN
   temp1_ := REPLACE(layout_format_,' ','');
   temp1_ := REPLACE(layout_format_,'-','');
   temp2_ := REPLACE(tax_id_number_,' ','');
   temp2_ := REPLACE(tax_id_number_,'-','');
   temp3_ := REPLACE(layout_format_,' ','');
   IF (NVL(LENGTH(temp1_),0) <> NVL(LENGTH(temp2_),0)) THEN
      dummy_ := 'FALSE';
   ELSE
      j_ := 1;
      k_ := 1;
      l_ := 1;
      -- code to change the tax id number to the layout format.
      WHILE (j_ <> 0) LOOP
         j_ := INSTR(temp3_,'-',k_);
         IF (j_ <> 0) THEN
            dummy_ := dummy_||SUBSTR(temp2_,l_,j_-k_)||'-';
         ELSE
            dummy_ := dummy_||SUBSTR(temp2_,l_,LENGTH(temp2_)-l_+1);
         END IF;
         l_ := l_ + j_ - k_ ;
         k_ := j_+1;
      END LOOP;
   END IF;
   RETURN dummy_;
END Format_Tax_Number;


@UncheckedAccess
FUNCTION Check_Country_Type (
   country_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER;
   CURSOR get_country IS
      SELECT COUNT(*)
      FROM   tax_id_type_tab
      WHERE  country_code = country_db_;
BEGIN   
   OPEN get_country;
   FETCH get_country INTO temp_;
   CLOSE get_country;
   IF (temp_ > 0) THEN
      RETURN 'TRUE';
   END IF;
   RETURN 'FALSE';
END Check_Country_Type;


PROCEDURE Validate_Tax_Id_Type_Layout (
   tax_id_number_ IN OUT VARCHAR2,
   tax_id_type_   IN     VARCHAR2 )
IS
   layout_format_    VARCHAR2(50);
   tax_number_       VARCHAR2(50);
BEGIN
   layout_format_ := Get_Layout_Format(tax_id_type_);
   IF (layout_format_ IS NOT NULL) THEN
      tax_number_ := Format_Tax_Number(layout_format_, tax_id_number_);
      IF (tax_number_ = 'FALSE') THEN
         Client_SYS.Clear_Info;
         Client_SYS.Add_Warning(lu_name_, 'WRONGTAXFORMAT: Tax ID Number not in predefined layout.');
      ELSE
         tax_id_number_ := tax_number_;   
      END IF;
   END IF;
END Validate_Tax_Id_Type_Layout;


