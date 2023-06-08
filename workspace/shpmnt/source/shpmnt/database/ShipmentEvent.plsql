-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentEvent
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160729  MaIklk  LIM-8057, Made Insert_Lu_Data_Rec as public since this will be accessed from Order.
--  151130  MaRalk  LIM-4594, Modified Insert_Lu_Data_Rec__ to support 
--  151130          basic data translations from shpmnt module.
--  151015  MaRalk  LIM-3836, Moved to the shpmnt module from order module in order to support
--  151015          generic shipment functionality.
--  140312  RoJalk  Modified Insert_Lu_Data_Rec__ and used Basic_Data_Translation_API.Insert_Prog_Translation.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Insert_Lu_Data_Rec
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec (
   newrec_        IN SHIPMENT_EVENT_TAB%ROWTYPE)
IS
   dummy_      VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM SHIPMENT_EVENT_TAB
      WHERE event = newrec_.event;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO SHIPMENT_EVENT_TAB(
            event,
            description,
            rowversion)
         VALUES(
            newrec_.event,
            newrec_.description,
            newrec_.rowversion);
   ELSE
      UPDATE SHIPMENT_EVENT_TAB
         SET description = newrec_.description
       WHERE event = newrec_.event;
   END IF;
   CLOSE Exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('SHPMNT', 
                                                      'ShipmentEvent',
                                                       newrec_.event,
                                                       newrec_.description);
END Insert_Lu_Data_Rec;
