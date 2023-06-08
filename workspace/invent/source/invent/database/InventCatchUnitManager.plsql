-----------------------------------------------------------------------------
--
--  Logical unit: InventCatchUnitManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  151029  JeLise LIM-4351, Removed call to Inventory_Part_API.Check_Pallet_Part_Exist in Handle_Enable_Catch.
--  110302  DaZase Changed call to Inventory_Part_API.Check_Pallet_Part_Exist from the old now obsolete Inventory_Part_Pallet_API.Check_Pallet_Part_Exist.
--  100511  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  061116  ShVese Added code to loop over inventory parts in Handle_Enable_Catch.
--  060213  RaKalk Modified method Handle_Enable_Catch to give an error message when the 
--  060213         unexecuted transport tasks exists for the part
--  041129  IsAnlk Removed method Handle_Disable_Catch and edit Handle_Enable_Catch.
--  041125  SaJjlk Modifications to error message wording in Handle_Enable_Catch and Handle_Disable_Catch.
--  041118  GeKalk Modified the error message for Negative on hand allowed parts in Handle_Enable_Catch.
--  041117  IsAnlk Added method Handle_Disable_Catch.
--  041012  IsAnlk Modified error messages in Handle_Enable_Catch.
--  041004  SaJjlk Modifications to Error message for pallet handled parts.
--  040915  SaJjlk Modified information message for quantity on-hand in method Handle_Enable_Catch.
--  040907  SaJjlk Created and added method Handle_Enable_Catch
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Handle_Enable_Catch
--   This method checks conditions for enabling catch unit functionality.
PROCEDURE Handle_Enable_Catch (
   part_no_ IN VARCHAR2 )
IS
    CURSOR get_rec IS
      SELECT *
      FROM inventory_part_pub
      WHERE part_no = part_no_;
BEGIN
   IF (Inventory_Part_API.Check_Neg_Onhand_Part_Exist(part_no_) = 'TRUE') THEN
       Error_SYS.Record_General(lu_name_, 'NONEGONHANDALLOW: Catch unit handling cannot be enabled since negative on hand is allowed for inventory part :P1 on at least one site.',part_no_);
   END IF;

   IF (Inventory_Part_In_Stock_API.Transi_Qty_Without_Catch_Exist(part_no_) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'QTYINTRANSITEXIST: Catch unit handling cannot be enabled since inventory part :P1 exist in a transit location on at least one site.',part_no_);
   END IF;

   IF (Inventory_Part_In_Stock_API.Check_Qty_Onhand_Exist(part_no_) = 'TRUE') THEN
      Client_SYS.Add_Info(lu_name_, 'POSITIVEQTYONHAND: Catch Quantity needs to be defined on the Location for Catch Unit enabled Parts. Please perform counting.');
   END IF;

   IF (Transport_Task_API.Check_Unexecuted_Tasks(part_no_) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_,'TRANSPORTTASKSFOUND: Catch unit handling cannot be enabled when there are transport tasks for the part in :P1 state',Transport_Task_Status_API.Decode('CREATED'));
   END IF;
   --Loop over all sites where inventory part exist
   FOR inv_part_rec IN get_rec LOOP
      IF (inv_part_rec.catch_unit_meas IS NULL) THEN
         Error_SYS.Record_General(lu_name_,'CATCHUNITMEAS: Catch unit handling cannot be enabled since Catch UoM has not been entered for inventory part :P1 on atleast one site.',part_no_);
      END IF;
   END LOOP;
END Handle_Enable_Catch;



