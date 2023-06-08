-----------------------------------------------------------------------------
--
--  Logical unit: DiscomGeneralUtil
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211103  SaLelk  SC21R2-688,  Modified the method Get_Owner_Name so that it return owner_name_ from ENTERP component.
--  211005  PamPlk  SC21R2-3109, Modified the method Get_Owner_Name in order to support for SUPPLIER LOANED ownership.
--  211004  PamPlk  SC21R2-3084, Created and added Get_Owner_Name.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
FUNCTION Get_Owner_Name (
   owning_customer_no_   IN VARCHAR2,
   owning_vendor_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   owner_name_       VARCHAR2(100):= NULL;   
BEGIN     
   IF (owning_customer_no_ IS NOT NULL) THEN
      owner_name_ := Customer_Info_API.Get_Name(owning_customer_no_);
   ELSIF (owning_vendor_no_ IS NOT NULL) THEN
      owner_name_ := Supplier_Info_API.Get_Name(owning_vendor_no_);
   END IF;
   RETURN owner_name_;
END Get_Owner_Name;



-------------------- LU  NEW METHODS -------------------------------------
