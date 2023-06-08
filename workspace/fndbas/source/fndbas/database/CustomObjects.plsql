-----------------------------------------------------------------------------
--
--  Logical unit: CustomObjects
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  101109  HAAR  Created
--  120705  MaBose  Conditional compiliation improvements - Bug 10391
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Copy_Between_Lu_Cf_Instance (
   from_lu_       IN VARCHAR2,
   from_rowkey_   IN VARCHAR2,
   to_lu_         IN VARCHAR2,
   to_rowkey_     IN VARCHAR2  )
IS 
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   Custom_Obj_SYS.Copy_Between_Lu_Cf_Instance(from_lu_, from_rowkey_, to_lu_, to_rowkey_);
$ELSE
   NULL;
$END
END Copy_Between_Lu_Cf_Instance;


PROCEDURE Copy_Cf_Instance (
   lu_            IN VARCHAR2,
   from_rowkey_   IN VARCHAR2,
   to_rowkey_     IN VARCHAR2  )
IS 
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   Custom_Obj_SYS.Copy_Cf_Instance(lu_, from_rowkey_, to_rowkey_);
$ELSE
   NULL;
$END
END Copy_Cf_Instance;

PROCEDURE Handle_Lu_Modification (
   old_lu_name_        IN VARCHAR2,
   new_lu_name_        IN VARCHAR2 )
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   Custom_Obj_SYS.Handle_Lu_Modification(old_lu_name_,new_lu_name_);
$ELSE
   NULL;
$END
END Handle_Lu_Modification;

