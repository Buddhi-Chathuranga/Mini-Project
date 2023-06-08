-----------------------------------------------------------------------------
--
--  Logical unit: CompanyAddressDelivInfo
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200324  SBalLK  Bug 152848 (SCZ-9452), Removed Get_Intrastat_Exempt_Db() method to avoid automatic testing issues, so base method can be used.
--  131105  UdGnlk  PBSC-203, Modified base view comments to align with model file errors. 
--  120106  AyAmlk  Bug 100608, Increased the column length of delivery_terms to 5 in view COMPANY_ADDRESS_DELIV_INFO.
--  070119  NaWilk  Removed Delivery_Terms_Desc.
--  060925  ChBalk  Increased length of the address_name to 100 in view comments.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060117  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  040226  GeKalk  Removed substrb from views for UNICODE modifications.
--  --------------- EDGE Package Group 3 Unicode Changes ---------------------
--  031014  PrJalk  Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  030917  SeKalk  Modified view COMPANY_ADDRESS_DELIV_INFO
--  030903  GaSolk  Performed CR Merge 2(CR Only).
--  270803  SeKalk  Code Review
--  260803  ThGuLk  Removed view COMPANY_ADDRESS_LOV, moved the view to Enterp.
--  260803  ThGuLk  Added the purpose..
--  100403  ThGuLk  Changed view COMPANY_ADDRESS_LOV, undifined the view_lov.
--  040403  ThGuLk  Changed view COMPANY_ADDRESS_LOV
--  240303  ThGuLk  Added view COMPANY_ADDRESS_LOV
--  240303  ThGuLk  Added Reference to Ship_Via_code & Delivery_Terms
--  200303  ThGuLk  Added Function Get_Intrastat_Exempt_Db
--  190303  ThGuLk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT company_address_deliv_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF newrec_.intrastat_exempt IS NULL THEN
     newrec_.intrastat_exempt :='INCLUDE';
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Check_Record (
   company_    IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(company_, address_id_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Record;



