-----------------------------------------------------------------------------
--
--  Logical unit: InventCompanyCreation
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  001113  DaMa    Rewrote logic to facilitate easier localizations. 
--  000925  JOHESE  Added undefines.
--  000417  NISOSE  Added General_SYS.Init_Method in Create_Company.
--  000309  ROOD    Added default accounts for posting type M90.
--  000202  LEPE    Added default accounts for posting types M88 and M89.
--  990412  SHVE    Upgraded to performance optimized template.
--  990225  JOKE    Changed company_ to 20 characters.
--  990210  LEPE    Added default accounts for posting_type M60 and M61.
--  980420  JOKE    Changed default value for str_code 'M5'.
--  980406  JOHNI   Removed M50.
--  971127  GOPE    Upgrade to fnd 2.0
--  970514  RaKu    Changed module name from 'INVENTORY' to 'ACCRUL'.
--  970514  RaKu    Changed CONTROL_TYPE in procedure Create_Company to 'AC1'.
--  970510  JOKE    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Company
--   Used for default values on creation of company.
PROCEDURE Create_Company (
   attr_ IN VARCHAR2 )
IS
  company_   VARCHAR2(20);

CURSOR get_default_data IS
      SELECT *
      FROM INVENT_POSTING_CTRL_DEF_TAB;
BEGIN
   company_ := Client_SYS.Get_Item_Value('NEW_COMPANY',  attr_);
   IF ( company_ IS NOT NULL ) THEN
      FOR rec_ IN get_default_data LOOP
--     Check if posting control already exists
         IF ( NOT Posting_Ctrl_API.Exist_Posting_Control ( company_,
                                                           rec_.posting_type,
                                                           rec_.control_type,
                                                           rec_.code_part )
            ) THEN
            Posting_Ctrl_API.Insert_Posting_Control( 
                company_, 
                rec_.posting_type, 
                rec_.code_part,
                rec_.control_type,
                rec_.module,
                rec_.override,
                rec_.default_value );
          END IF;
      END LOOP;
   END IF;
END Create_Company;



