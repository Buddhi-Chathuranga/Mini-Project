-----------------------------------------------------------------------------
--
--  Logical unit: AccessoryOnHuHistory
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170202  Chfose  LIM-10117, Added new method Handling_Unit_Connected_Exists.
--  161221  UdGnlk  LIM-10045, Added Create_Snapshot() to add history records;  
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Snapshot (
   sequence_no_      IN NUMBER,   
   handling_unit_id_ IN NUMBER )
IS
   CURSOR get_attr IS
      SELECT handling_unit_accessory_id, quantity
         FROM accessory_on_handling_unit_tab
         WHERE handling_unit_id = handling_unit_id_;
         
   newrec_     ACCESSORY_ON_HU_HISTORY_TAB%ROWTYPE;    
BEGIN
   FOR rec IN get_attr LOOP
      newrec_.sequence_no := sequence_no_;
      newrec_.handling_unit_id := handling_unit_id_;
      newrec_.handling_unit_accessory_id := rec.handling_unit_accessory_id;
      newrec_.quantity := rec.quantity;
      New___(newrec_);
   END LOOP; 
END Create_Snapshot;


@UncheckedAccess
FUNCTION Handling_Unit_Connected_Exist (
   sequence_no_      IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
        FROM ACCESSORY_ON_HU_HISTORY_TAB
       WHERE sequence_no = sequence_no_
         AND handling_unit_id = handling_unit_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO temp_;
   IF(exist_control%NOTFOUND) THEN
      CLOSE exist_control;
      RETURN Fnd_Boolean_API.DB_FALSE;
   ELSE
      CLOSE exist_control;
      RETURN Fnd_Boolean_API.DB_TRUE;
   END IF;
END Handling_Unit_Connected_Exist;

