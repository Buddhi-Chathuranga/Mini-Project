-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartCost
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  111207  MAMALK  Ajusted the body of Get_Cost method due to adding pragma in the method specification.
--  031019  LEPESE  Adjusted method order to match model file.
--  031014  PrJalk  Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  031010  LEPESE  Redesign of method Get_Cost to reflect changes made in method
--                  Inventory_Part_Unit_Cost_API.Get_Invent_Value_By_Condition where
--                  the estimated condition cost now is fetched if no records can be 
--                  found in InventoryPartUnitCost with the requested condition code.
--  030814  SuAmlk  Added method Get_Cost.
--  001218  SHVE    Added Get_Part_Cost since it is used by Maintenance 2000C.
--  000925  JOHESE  Added undefines.
--  000503  SHVE    Removed obsolete methods Get_Cost_Per_Part and Get_Part_Cost.
--  000417  NISOSE  Added General_SYS.Init_Method in Get_Cost_Per_Part.
--  990505  SHVE    Replaced call to Inventory_Part_API.Get_Inventory_Value by
--                  Get_Inventory_Value_By_Method.
--  990422  SHVE    Removed obsolete methods.
--  990412  SHVE    Upgraded to performance optimized template.
--  981201  SHVE    Converted to a utility L
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Total_Standard (
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   cost_set_        IN NUMBER ) RETURN NUMBER
IS
   total_standard_  NUMBER;

BEGIN
   total_standard_ := Inventory_Part_API.Get_Inventory_Value_By_Method(contract_, part_no_);
   RETURN NVL(total_standard_,0);
END Get_Total_Standard;



-- Get_Cost
--   Returns the Cost depending on the Inventory Part Cost level.
@UncheckedAccess
FUNCTION Get_Cost (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   condition_code_   IN VARCHAR2 ) RETURN NUMBER
IS
   inv_part_cost_level_  VARCHAR2(50);
   cost_                 NUMBER;
BEGIN
   IF (condition_code_ IS NULL) THEN
      cost_ := Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(contract_,
                                                                          part_no_,
                                                                          configuration_id_,
                                                                          NULL,
                                                                          NULL);
   ELSE
      inv_part_cost_level_  := Inventory_Part_API.Get_Invent_Part_Cost_Level_Db(contract_, part_no_);

      IF (inv_part_cost_level_ IN ('COST PER LOT BATCH','COST PER SERIAL')) THEN
         --Note: First of all try to find an estimated cost for this condition
         cost_ := Inv_Part_Config_Condition_API.Get_Estimated_Cost(condition_code_,
                                                                   contract_,
                                                                   part_no_,
                                                                   configuration_id_);
         IF (cost_ IS NULL) THEN
            --Note: No estimated cost registered for this condition, search for actual cost.
            cost_ := Inventory_Part_Unit_Cost_API.Get_Invent_Value_By_Condition(contract_,
                                                                                part_no_,
                                                                                configuration_id_,
                                                                                condition_code_);
         END IF;
      ELSIF (inv_part_cost_level_ = 'COST PER CONDITION') THEN
         cost_ := Inventory_Part_Unit_Cost_API.Get_Invent_Value_By_Condition(contract_,
                                                                             part_no_,
                                                                             configuration_id_,
                                                                             condition_code_);
      ELSE
         --Note: Part cost level is 'COST PER PART' or 'COST PER CONFIGURATION'
         cost_ := Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(contract_,
                                                                             part_no_,
                                                                             configuration_id_,
                                                                             NULL,
                                                                             NULL);   
      END IF;
   END IF;

   RETURN NVL(cost_,0);
END Get_Cost;



@UncheckedAccess
FUNCTION Get_Part_Cost (
   contract_         IN   VARCHAR2,
   part_no_          IN   VARCHAR2 ) RETURN NUMBER
IS
   total_standard_  NUMBER;
BEGIN
   total_standard_ := Inventory_Part_API.Get_Inventory_Value_By_Method(contract_, part_no_);
   RETURN Nvl(total_standard_,0);
END Get_Part_Cost;




