-----------------------------------------------------------------------------
--
--  Logical unit: OrderCompanyCreation
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100520  KRPE  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  001113  DaMa  Rewrote logic to facilitate easier localizations. 
--  000419  PaLj  Corrected Init_Method Errors
--  ------------------------------- 12.0 ------------------------------------
--  000209  JoAn  Bug ID 13572 Chenged default account for M71, M72
--  000208  JoAn  Added posting types M73-M76 for discounts to Create_Company
--  000207  JakH  Added posting types M77 to M87 for RMA's to Create_Company.
--  991111  JoEd  Changed datatype length on company_ in Create_Company.
--  990922  DaZa  Added posting types M67, M68, M69, M70, M71 and M72 to Create_Company.
--  ------------------------------- 11.1-------------------------------------
--  990412  JakH  New template.
--  971125  RaKu  Changed to FND200 Templates.
--  970514  RaKu  Changed module name from 'INVENTORY' to 'ACCRUL'.
--  970514  RaKu  Changed CONTROL_TYPE in procedure Create_Company to 'AC1'.
--  970510  RaKu  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Company
--   Inserts posting control in the ACCRUL-Module. This procedure is called
--   by the ACCRUL-module using dynamic call.
PROCEDURE Create_Company (
   attr_ IN VARCHAR2 )
IS
   company_  VARCHAR2(20);

CURSOR get_default_data IS
      SELECT *
      FROM ORDER_POSTING_CTRL_DEF_TAB;
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



