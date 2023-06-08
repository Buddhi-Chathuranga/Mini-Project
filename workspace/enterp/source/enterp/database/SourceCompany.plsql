-----------------------------------------------------------------------------
--
--  Logical unit: SourceCompany
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
 
-------------------- PRIVATE DECLARATIONS -----------------------------------
 
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT source_company_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (Target_Company_API.Check_Target_Company(newrec_.source_company)) THEN
      Error_SYS.Record_General(lu_name_, 'USEASTARGET: Company :P1 is already defined as a target company therefore it cannot be used as a source company', newrec_.source_company);
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
 
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
 
-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

