-----------------------------------------------------------------------------
--
--  Logical unit: ContractClauseType
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200923  ambslk  MF2020R1-7177, Override Check_Common() method.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     contract_clause_type_tab%ROWTYPE,
   newrec_ IN OUT contract_clause_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   $IF (Component_Docman_SYS.INSTALLED) $THEN
      IF (indrec_.approval_profile_id AND newrec_.approval_required = Fnd_Boolean_API.DB_TRUE) THEN
         IF Approval_Template_API.Steps_Exists(newrec_.approval_profile_id) = 'FALSE' THEN
            Error_SYS.Record_General(lu_name_, 'NOSTEPSFOUND: The approval template should contain at least one approval step.');
         END IF;
      END IF;
   $END
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

