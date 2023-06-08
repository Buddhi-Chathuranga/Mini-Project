-----------------------------------------------------------------------------
--
--  Logical unit: SecCheckpointGateParam
--  Component:    FNDBAS
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
PROCEDURE Check_Common___ (
   oldrec_ IN     sec_checkpoint_gate_param_tab%ROWTYPE,
   newrec_ IN OUT sec_checkpoint_gate_param_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF newrec_.datatype NOT IN ('STRING', 'DATE', 'NUMBER') THEN
      Error_SYS.Item_General(lu_name_, 'DATATYPE', 'WRONG_DATATYPE: The datatype of a parameter must be STRING, DATE or NUMBER, it can not be [:P1].', newrec_.datatype);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

