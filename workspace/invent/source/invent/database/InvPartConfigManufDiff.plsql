-----------------------------------------------------------------------------
--
--  Logical unit: InvPartConfigManufDiff
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170624  LEPESE  STRSC-9332, Added a manually written Remove__ to support cascade delete since model has DbClientInterface "read-only". 
--  150504  JoAnSe  MONO-193, Added Get_Total_Diff.
--  150415  JoAnSe  MONO-187, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ inv_part_config_manuf_diff_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      remrec_ := Get_Object_By_Id___(objid_);
      Check_Delete___(remrec_);
   ELSIF (action_ = 'DO') THEN
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Remove__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Cost_Detail_Tab
--    Retrieve the current manuf diff details for the specified part and configuration_id and return the as as 
--    an array of cost details.
FUNCTION Get_Cost_Detail_Tab (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab
IS
   cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_cost_detail IS
      SELECT accounting_year,
             contract,
             cost_bucket_id,
             company,
             cost_source_id,
             accumulated_manuf_diff
      FROM   inv_part_config_manuf_diff_tab
      WHERE contract         = contract_
      AND   part_no          = part_no_
      AND   configuration_id = configuration_id_;
BEGIN
   OPEN get_cost_detail;
   FETCH get_cost_detail BULK COLLECT INTO cost_detail_tab_;
   CLOSE get_cost_detail;

   RETURN(cost_detail_tab_);
END Get_Cost_Detail_Tab;

-- Get_Total_Diff
--    Retrieve the total accumulated manuf diff for a part and configuration id by adding up all cost details.
FUNCTION Get_Total_Diff (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   total_diff_      NUMBER;
BEGIN
   cost_detail_tab_ := Get_Cost_Detail_Tab(contract_, part_no_, configuration_id_);

   IF (cost_detail_tab_.COUNT = 0) THEN
      total_diff_ := NULL;
   ELSE
      total_diff_ := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(cost_detail_tab_);
   END IF;

   RETURN(total_diff_);
END Get_Total_Diff;

-- Add_To_Manuf_Diff
--    Add the diff details passed in to what is already stored and store the result as the manuf new diff details.
PROCEDURE Add_To_Manuf_Diff (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   manuf_diff_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab )
IS
   accum_diff_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_diff_details IS
      SELECT accounting_year, contract, cost_bucket_id, company, cost_source_id, accumulated_manuf_diff
      FROM inv_part_config_manuf_diff_tab
      WHERE contract         = contract_
      AND   part_no          = part_no_
      AND   configuration_id = configuration_id_
      FOR UPDATE;

BEGIN
   -- Retrieve the current manufacturing diff details
   OPEN get_diff_details;
   FETCH get_diff_details BULK COLLECT INTO accum_diff_detail_tab_;
   CLOSE get_diff_details;

   IF (accum_diff_detail_tab_.COUNT = 0)  THEN
      accum_diff_detail_tab_ := manuf_diff_detail_tab_;
   ELSE
      accum_diff_detail_tab_ := Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(accum_diff_detail_tab_, manuf_diff_detail_tab_, 1);
   END IF;

   Set_Manuf_Diff_Details(contract_, part_no_, configuration_id_, accum_diff_detail_tab_);

END Add_To_Manuf_Diff;

-- Subtract_From_Manuf_Diff
--    Subtract the diff details passed in from what is already stored and store the result as the manuf new diff details.
PROCEDURE Subtract_From_Manuf_Diff (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   manuf_diff_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab )
IS
   accum_diff_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_diff_details IS
      SELECT accounting_year, contract, cost_bucket_id, company, cost_source_id, accumulated_manuf_diff
      FROM inv_part_config_manuf_diff_tab
      WHERE contract         = contract_
      AND   part_no          = part_no_
      AND   configuration_id = configuration_id_
      FOR UPDATE;

BEGIN
   -- Retrieve the current manufacturing diff details
   OPEN get_diff_details;
   FETCH get_diff_details BULK COLLECT INTO accum_diff_detail_tab_;
   CLOSE get_diff_details;

   IF (accum_diff_detail_tab_.COUNT = 0)  THEN
      accum_diff_detail_tab_ := manuf_diff_detail_tab_;
      FOR i_ IN 1..accum_diff_detail_tab_.COUNT LOOP
         accum_diff_detail_tab_(i_).unit_cost := - 1 * accum_diff_detail_tab_(i_).unit_cost;
      END LOOP;
   ELSE
      accum_diff_detail_tab_ := Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(accum_diff_detail_tab_, manuf_diff_detail_tab_, -1);
   END IF;

   Set_Manuf_Diff_Details(contract_, part_no_, configuration_id_, accum_diff_detail_tab_);

END Subtract_From_Manuf_Diff;

-- Set_Manuf_Diff_Details
--    Delete the current manuf diff details if any and replace them with the cost details passed in.
PROCEDURE Set_Manuf_Diff_Details (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   manuf_diff_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab )
IS
   newrec_  inv_part_config_manuf_diff_tab%ROWTYPE;
BEGIN
      
   -- Remove current diff details
   DELETE FROM inv_part_config_manuf_diff_tab
      WHERE contract         = contract_
      AND   part_no          = part_no_
      AND   configuration_id = configuration_id_;

   newrec_.contract         := contract_;
   newrec_.part_no          := part_no_;
   newrec_.configuration_id := configuration_id_;

   -- Store the new diff details
   FOR i_ IN 1..manuf_diff_detail_tab_.COUNT LOOP
      IF (manuf_diff_detail_tab_(i_).unit_cost != 0) THEN
         newrec_.accounting_year        := manuf_diff_detail_tab_(i_).accounting_year;
         newrec_.cost_bucket_id         := manuf_diff_detail_tab_(i_).cost_bucket_id;
         newrec_.company                := manuf_diff_detail_tab_(i_).company;
         newrec_.cost_source_id         := manuf_diff_detail_tab_(i_).cost_source_id;
         newrec_.accumulated_manuf_diff := manuf_diff_detail_tab_(i_).unit_cost;
         New___(newrec_);
      END IF;
   END LOOP;
END Set_Manuf_Diff_Details;

-- Clear_Manuf_Diff_Details
--    Delete the current manuf diff details if any.
PROCEDURE Clear_Manuf_Diff_Details (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
BEGIN
   -- Remove current diff details
   DELETE FROM inv_part_config_manuf_diff_tab
      WHERE contract         = contract_
      AND   part_no          = part_no_
      AND   configuration_id = configuration_id_;

END Clear_Manuf_Diff_Details;
