-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentConsolRule
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160825  MaIklk  LIM-8481, Made Insert_Lu_Data_Rec as public.
--  151014  MaRalk  LIM-3836, Moved to the module shpmnt from order module in order to support
--  151014          generic shipment functionality.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
  


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE Insert_Lu_Data_Rec (
   newrec_        IN SHIPMENT_CONSOL_RULE_TAB%ROWTYPE)
IS
   dummy_ NUMBER;
   CURSOR Exist IS
      SELECT 1 
      FROM SHIPMENT_CONSOL_RULE_TAB
      WHERE shipment_type = newrec_.shipment_type
      AND   consol_param = newrec_.consol_param;
BEGIN

   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO SHIPMENT_CONSOL_RULE_TAB (
            shipment_type,
            consol_param,
            rowversion)
         VALUES (
            newrec_.shipment_type,
            newrec_.consol_param,
            newrec_.rowversion);
   END IF;
   CLOSE Exist;
END Insert_Lu_Data_Rec;  
