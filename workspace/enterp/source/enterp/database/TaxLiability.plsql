-----------------------------------------------------------------------------
--
--  Logical unit: TaxLiability
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  021209  dagalk  Created IIDESFI109E Salsa
--  021216  Hecolk  IIDESFI109E, Added PROCEDURE Enumerate_Liability_Types
--  021217  Hecolk  IIDESFI109E, Modified View 'TAX_LIABILITY' and Procedures 'Unpack_Check_Insert___' & 'Unpack_Check_Update___'
--  000110  Dagalk  IIDESFI109E, Modified fn Check_Delete__ for  restrict to delete default data '
--  030128  wapelk  IIDESFI109E, Changed the Enumerate_Types method to select the country of the Customer, not the one of the
--                  connected company.
--  030203  chajlk  ARFI124N - Added tax_liability_lov
--  030225  wapelk  IID ESFI109E - Bug 94088. Droped column type_id from tax_liability_tab.
--  030313  mgutse  IID ITFI127N. Added revenue_tax_with_cat to LU TaxLiability.
--  030324  ISJALK  IID RDFI140NE, made changes for taxable's db values.
--  030401  Bmekse  IID ITFI127N. Removed revenue_tax_with_cat from LU TaxLiability.
--  030421  WAPELK  Bud Id 96387. Remove country dependency of "RDE" in Enumerate_Liability_Types method.
--  030707  Dagalk  Bug 97978 set country_code key for tax_liability_tab.
--  030707  Dagalk  Bug 99590 added description for tax_liability_tab.
--  030923  Hecolk  LCS Merge, LCS Bug 37594 Manually Corrected. Modified Method Get_Taxable
--  091016  Kanslk  East-200, Reverse-Engineering, Modified view 'TAX_LIABILITY' by changing the reference of taxable to Taxable.
--  101122  Elarse  DF-441, Added column tax_liability to view TAX_LIABILITY for zoom purposes.
--  110116  MaMalk  Added method Get_Vat and Check_Exist methods.
--  120423  PRatlk  Added taxable_db to tax_liability_lov view to filter for exempt type tax liabilities.
--  130115  MaRalk  PBR-1203, Added customer_category filter to the where clause in get_types cursor-Enumerate_Types method
--  141128  TAORSE  Added Enumerate_Liability_Types_Db and Enumerate_Types_Db
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_); 
   Client_SYS.Add_To_Attr('SYSTEM_DEF_DB', Fnd_Boolean_API.DB_FALSE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN tax_liability_tab%ROWTYPE )
IS   
BEGIN
   IF (remrec_.system_def = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'TYPECANNOTDELETE: It is not allowed to delete a default Tax Liability');
   END IF ;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT tax_liability_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_ IS
      SELECT 1
      FROM   tax_liability_tab
      WHERE  tax_liability = newrec_.tax_liability
      AND    country_code = '*';
BEGIN
   OPEN exist_;
   FETCH exist_ INTO dummy_;
   IF (exist_%FOUND) THEN
      CLOSE exist_;
      Error_SYS.Record_General(lu_name_, 'TYPECANNOTSAVE: It is not allowed to save a Tax Liability that already exist with country *');
   END IF;   
   CLOSE exist_;
   super(newrec_, indrec_, attr_);
END Check_Insert___;

------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_Tax_Liability (
   tax_liability_   IN VARCHAR2,
   country_code_    IN VARCHAR2 )
IS
   country_db_ VARCHAR2(2);
BEGIN
   country_db_ := country_code_;
   IF (tax_liability_ IS NOT NULL) THEN      
      IF (tax_liability_ = 'TAX' OR tax_liability_ = 'EXEMPT') THEN
         country_db_ := '*';
      END IF;
      Exist(tax_liability_, country_db_);
   END IF;
END Check_Tax_Liability;


@Override
@UncheckedAccess
FUNCTION Get_Tax_Liability_Type_Db (
   tax_liability_ IN VARCHAR2,
   country_code_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   tax_liability_type_db_  tax_liability_tab.tax_liability_type%TYPE;
BEGIN
   tax_liability_type_db_ := super(tax_liability_, country_code_);
   IF (tax_liability_type_db_ IS NULL) THEN
      tax_liability_type_db_ := super(tax_liability_, '*');
   END IF;
   RETURN tax_liability_type_db_;
END Get_Tax_Liability_Type_Db;


@Override 
FUNCTION Get_Tax_Liability_Type (
   tax_liability_ IN VARCHAR2,
   country_code_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   tax_liability_type_  tax_liability_tab.tax_liability_type%TYPE;
BEGIN
   tax_liability_type_ := super(tax_liability_, country_code_);
   IF (tax_liability_type_ IS NULL) THEN
      tax_liability_type_ := super(tax_liability_, '*');
   END IF;
   RETURN tax_liability_type_;
END Get_Tax_Liability_Type;


@Override 
FUNCTION Get_Description (
   tax_liability_ IN VARCHAR2,
   country_code_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_ tax_liability_tab.description%TYPE;
BEGIN
   description_ := super(tax_liability_, country_code_);
   IF (description_ IS NULL) THEN
      description_ := super(tax_liability_, '*');
   END IF;
   RETURN description_;
END Get_Description;


@Override 
FUNCTION Get (
   tax_liability_ IN VARCHAR2,
   country_code_  IN VARCHAR2 ) RETURN Public_Rec
IS
   pub_rec_    Public_Rec;
BEGIN
   pub_rec_ := super(tax_liability_, country_code_);
   IF (pub_rec_.tax_liability IS NULL) THEN
      pub_rec_ := super(tax_liability_, '*');
   END IF;
   RETURN pub_rec_;
END Get;


FUNCTION Check_Exist (
   tax_liability_  IN VARCHAR2,
   country_code_   IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(tax_liability_, country_code_);
END Check_Exist;

