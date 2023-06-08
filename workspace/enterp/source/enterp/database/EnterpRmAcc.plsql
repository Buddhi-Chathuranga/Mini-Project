-----------------------------------------------------------------------------
--
--  Logical unit: EnterpRmAcc
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160909  JanWse  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Skip_Security (
   business_object_type_   IN VARCHAR2 )  RETURN VARCHAR2
IS
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      RETURN Rm_Acc_Filter_Util_API.Skip_Security(business_object_type_);
   $ELSE
      RETURN 'TRUE';
   $END
END Skip_Security;
