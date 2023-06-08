-----------------------------------------------------------------------------
--
--  Logical unit: CompanyDeliveryTaxExemp
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  250903  Asawlk   Changed NOCHECK to CASCADE in the view comment of address id in view COMPANY_DELIVERY_TAX_EXEMP. 
--  240903  Asawlk   Added NOCHECK to the view comment of address id in view COMPANY_DELIVERY_TAX_EXEMP.
--  200803  KuPellk  Created for Chain Reaction merge
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
   Client_SYS.Add_To_Attr('EXEMPT_CERTIFICATE_TYPE', Exempt_Certificate_Type_API.Decode('BLANKET CERTIFICATE'), attr_);
END Prepare_Insert___;
                      
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

