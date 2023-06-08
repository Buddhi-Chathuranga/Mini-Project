-----------------------------------------------------------------------------
--
--  Logical unit: PartCatalog
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220525  SEBSA-SUPULI   SA_TRA_1_09_10-1-MPL: Added new methods C_Get_Outer_Diameter,C_Volume_Per_Roll
--  220525  SEBSA-SUPULI   SA_TRA_1_09_10-1-MPL: Created
-----------------------------------------------------------------------------

layer Cust;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Start)
FUNCTION C_Get_Outer_Diameter (
 part_no_   IN VARCHAR2,
 contract_  IN VARCHAR2,
 length_    IN NUMBER)RETURN NUMBER
IS
   inner_diameter_ NUMBER := 0;
   outer_diameter_ NUMBER := 0;
   n_              NUMBER := 0;
   $IF (Component_Partca_SYS.INSTALLED) $THEN
   thickness_      part_catalog_tab.c_thickness%TYPE := 0;
   $END
BEGIN
   thickness_ := Part_Catalog_API.Get_C_Thickness(part_no_);
   $IF (Component_Partca_SYS.INSTALLED) $THEN
      IF Part_Catalog_API.Get_C_Mpl_Part_Db(part_no_) = 'TRUE' THEN
   $END
      $IF (Component_Invent_SYS.INSTALLED) $THEN
      inner_diameter_ := Site_Invent_Info_API.Get_C_Roll_Inner_Diameter(contract_);
      $END
      IF thickness_ > 0  AND length_ > 0 AND inner_diameter_ >= 0 THEN 
         n_ := (thickness_ - (1000*inner_diameter_) + SQRT(POWER(((1000*inner_diameter_)-thickness_),2) + ((4*thickness_*1000*length_)/(22/7)))) / (2*thickness_);
         outer_diameter_ := ROUND((((2*n_*thickness_) + (inner_diameter_*1000))/10),2);
      END IF;
   END IF; 
   --in cm
   RETURN outer_diameter_;
END C_Get_Outer_Diameter;

FUNCTION C_Volume_Per_Roll (
 part_no_   IN VARCHAR2,
 contract_  IN VARCHAR2,
 length_    IN NUMBER)RETURN NUMBER
IS
   outer_diameter_  NUMBER:=0;
   volume_per_roll_ NUMBER:=0; 
BEGIN
   
  outer_diameter_ := C_Get_Outer_Diameter(part_no_,contract_, length_);
  -- in m
  IF outer_diameter_ > 0 THEN 
   volume_per_roll_ := ROUND((22/7) * POWER((outer_diameter_/(2*100)),2),2);
  END IF;
  
  RETURN volume_per_roll_;
  
END C_Volume_Per_Roll;
-- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Finish)
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU CUST NEW METHODS -------------------------------------
