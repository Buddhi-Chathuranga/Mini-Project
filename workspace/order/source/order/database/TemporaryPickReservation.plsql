-----------------------------------------------------------------------------
--
--  Logical unit: TemporaryPickReservation
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210722  RoJalk  SC21R2-1374, Removed the unused method Modify_Qty_To_Pick.
--  210722  RoJalk  SC21R2-1374, Modified Check_Insert___ to assign a default value to ship_handling_unit_id.
--  210722  RoJalk  SC21R2-1374, Added the parameter ship_handling_unit_id_ to Modify_Qty_To_Pick.
--  161103  KHVESE  LIM-9406, Added method Modify_Qty_To_Pick.
--  151105  UdGnlk  LIM-3746, Removed Check_Insert___() since Inventory_Part_Loc_Pallet_API method call exists, INVENTORY_PART_LOC_PALLET_TAB will be obsolete. 
--  150423  UdGnlk  LIM-172, Added handling_unit_id as new key column to Temporary_Pick_Reservation_Tab therefore did necessary changes.  
--  131008  MAHPLK  Added shipment_id to the LU.
--  130522  KiSalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT temporary_pick_reservation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   -- shipment handling unit id will be added to attr only when pick reported from shipment handling unit tab
   -- since a key column need to set the default value as 0
   IF (NOT indrec_.ship_handling_unit_id) THEN
      newrec_.ship_handling_unit_id := 0;
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;




-- Remove_Old_Sessions___
--   Delete all the records older than 7 days. Since all the records
--   are deleted after the the transaction, the old data means redundant ones.
PROCEDURE Remove_Old_Sessions___
IS
   CURSOR get_old_records IS
      SELECT DISTINCT session_id
      FROM TEMPORARY_PICK_RESERVATION_TAB
      WHERE TRUNC(rowversion) < TRUNC(SYSDATE) - 7;
BEGIN
   FOR rec_ IN get_old_records LOOP
      Delete_Session___(rec_.session_id);
   END LOOP;
END Remove_Old_Sessions___;


-- Delete_Session___
--   Delete all the records with a particular session_id.
--   No checking required because obsolete records are supposed to be removed.
PROCEDURE Delete_Session___ (
   session_id_ IN NUMBER )
IS
BEGIN
   DELETE
   FROM  TEMPORARY_PICK_RESERVATION_TAB
   WHERE session_id = session_id_;
END Delete_Session___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_New__
--   Creates a new records with the values in atr_ parameter passed.
PROCEDURE Create_New__ (
   attr_ IN OUT VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     TEMPORARY_PICK_RESERVATION_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Create_New__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Next_Session_Id
--   Get the next value from sequence temporary_pick_reservation_seq and returns.
@UncheckedAccess
FUNCTION Get_Next_Session_Id RETURN NUMBER
IS
   session_id_ NUMBER;

   CURSOR get_id IS
      SELECT temporary_pick_reservation_seq.nextval
      FROM dual;
BEGIN
   OPEN get_id;
   FETCH get_id INTO session_id_;
   CLOSE get_id;

   RETURN session_id_;
END Get_Next_Session_Id;


-- Clear_Session
--   Deletes the records with given session_id_ and clears old obsolete records.
PROCEDURE Clear_Session (
   session_id_ IN OUT NUMBER )
IS
BEGIN
   Remove_Old_Sessions___;
   Delete_Session___( session_id_);
   session_id_ := NULL;
END Clear_Session;



