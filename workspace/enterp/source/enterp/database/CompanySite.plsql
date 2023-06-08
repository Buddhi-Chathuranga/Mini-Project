-----------------------------------------------------------------------------
--
--  Logical unit: CompanySite
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  070306  Lisvse  Created
--  070509  Surmlk  Changed the method name in General_SYS.Init_Method of procedure Create_Company_Site
--  070515  Surmlk  Added ifs_assert_safe comment
--  101207  Mamalk  Added country to the LU.
--  101216  Mamalk  Added validations in Unpack_Check_Update___ to have the same country in ditribution site when a delivery address is connected.
--  110404  MaMalk  Modified Unpack_Check_Update___ to take the Iso_Country_API.Exist check out of the loop and modified the base view to remove the decode for country.
--  120329  Mohrlk  EASTRTM-4212 , Added in parameter country_db_ to the method Create_Company_Site and country_code_db_ out parameter to Get_Info() method.
--  130614  DipeLK  TIBE-725, Removed global variables which used to check exsistance of ACCRUL,MPCCOM components
--  141205  PRIKLK  PRSA-5814, Override methods Insert and Update and added RCMINT method calls.
--  160922  Chwilk  STRFI-3435, Removed methods Insert() and Update().
--  210201  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in Create_Company_Site
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                   
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT company_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Error_SYS.Check_Valid_Key_String('CONTRACT', newrec_.contract);
   super(newrec_, indrec_, attr_);   
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     company_site_tab%ROWTYPE,
   newrec_ IN OUT company_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   del_addr_    VARCHAR2(50);
   del_country_ VARCHAR2(2);
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   IF (indrec_.country) THEN
      $IF Component_Mpccom_SYS.INSTALLED $THEN
         del_addr_ := Site_API.Get_Delivery_Address(newrec_.contract);
         IF (del_addr_ IS NOT NULL) THEN
            del_country_ := Company_Address_API.Get_Country_Db(newrec_.company, del_addr_);
            IF (del_country_ <> newrec_.country) THEN
               Client_SYS.Add_Info(lu_name_, 'DIFFCOUNTRY: Site :P1 has a Delivery Address in Country :P2.', newrec_.contract, ISO_Country_API.Decode(del_country_));
            END IF;
         END IF;
      $ELSE
         NULL;
      $END      
   END IF;
END Check_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Info (
   country_code_db_  OUT    VARCHAR2,
   description_      IN OUT VARCHAR2,
   company_          IN OUT VARCHAR2,
   company_name_     IN OUT VARCHAR2,
   contract_         IN     VARCHAR2 )
IS
BEGIN
   description_     := Get_Description(contract_);
   company_         := Get_Company(contract_);
   company_name_    := Company_API.Get_Name(company_);
   country_code_db_ := Get_Country_Db(contract_);
END Get_Info;


@UncheckedAccess
FUNCTION Check_Exist (
   contract_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(contract_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Exist; 


PROCEDURE Create_Company_Site (
   contract_               IN VARCHAR2,
   description_            IN VARCHAR2,
   company_                IN VARCHAR2,
   country_db_             IN VARCHAR2 DEFAULT NULL)
IS
   newrec_      company_site_tab%ROWTYPE;
BEGIN
   --Create's a new site in the CompanySite.
   newrec_.contract     := contract_;
   newrec_.description  := description_;
   newrec_.company      := company_;
   newrec_.country      := NVL(country_db_, Company_API.Get_Country_Db(company_));
   New___(newrec_);
   Invalidate_Cache___;
END Create_Company_Site;



