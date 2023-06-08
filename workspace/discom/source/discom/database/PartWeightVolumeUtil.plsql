-----------------------------------------------------------------------------
--
--  Logical unit: PartWeightVolumeUtil
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210113  ErRalk  SC2020R1-11985, Modified Get_Partca_Net_Volume and Get_Partca_Net_Weight by reducing number of calls to increase the performance.
--  200813  AsZelk  SC2020R1-7066, Removed dynamic dependency to Invent.
--  160311  MaIklk  LIM-6564, Moved Get_Partca_Net_Volume() from Sales_Part_API to this package.
--  160307  MaIklk  LIM-4670, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Config_Weight_Net
--   Returns the weight net defined in the configuration specification for a given configuration id.
--   Returns the weight net defined in the sales part if the weight net has not been defined in the
--   configuration specification or if the sales part is not a configured part.
@UncheckedAccess
FUNCTION Get_Config_Weight_Net (
   contract_               IN VARCHAR2,
   catalog_no_             IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   part_no_                IN VARCHAR2,
   sales_uom_              IN VARCHAR2,
   conv_factor_            IN NUMBER,
   inverted_conv_factor_   IN NUMBER,
   volume_uom_             IN VARCHAR2 ) RETURN NUMBER
IS
   config_net_weight_         NUMBER := NULL;   
   config_weight_uom_         VARCHAR2(10);   
   config_weight_comp_uom_    NUMBER := NULL;
BEGIN
   IF (NVL(configuration_id_,'*') != '*') THEN
      $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
         DECLARE
            temp_rec_   Configuration_Spec_API.Public_Rec;
         BEGIN
            temp_rec_            := Configuration_Spec_API.Get(part_no_, configuration_id_);
            config_net_weight_   := temp_rec_.net_weight;
            config_weight_uom_   := temp_rec_.weight_unit_code;
         END;      
         IF (config_net_weight_ IS NOT NULL AND config_weight_uom_ IS NOT NULL) THEN
            -- Weight in Company UoM.
            config_weight_comp_uom_ := Iso_Unit_API.Get_Unit_Converted_Quantity(config_net_weight_,
                                                                                config_weight_uom_,
                                                                                volume_uom_);
         END IF;
      $ELSE
         NULL;
      $END
   END IF;
   RETURN NVL(config_weight_comp_uom_, Get_Partca_Net_Weight(contract_,catalog_no_,part_no_, sales_uom_, conv_factor_, inverted_conv_factor_, volume_uom_));
END Get_Config_Weight_Net;




-- Get_Partca_Net_Weight
--   Returns the weight net of the part depending on the Partcatalog Specific values.
--   Even site specific check box ticked the net weight is fetched from this method. Because net weight is always from Part Catalog entry.
@UncheckedAccess
FUNCTION Get_Partca_Net_Weight (
   contract_             IN VARCHAR2,
   catalog_no_           IN VARCHAR2,
   part_no_              IN VARCHAR2,
   sales_uom_            IN VARCHAR2,
   conv_factor_          IN NUMBER,
   inverted_conv_factor_ IN NUMBER,
   volume_uom_           IN VARCHAR2) RETURN NUMBER
IS
   partca_net_weight_   NUMBER;
   partca_rec_          Part_Catalog_API.Public_Rec;
BEGIN 
   partca_rec_ := Part_Catalog_API.Get(catalog_no_);
   -- Re-wrote the logic so that it would first fetch the net weight from part catalog using the sales part no. 
   -- IF it is null it will then fetch the net weight passing the inventory part no. 
   partca_net_weight_ := (Iso_Unit_API.Get_Unit_Converted_Quantity(partca_rec_.weight_net,
                                                                   partca_rec_.uom_for_weight_net,
                                                                   volume_uom_)
                                  * Technical_Unit_Conv_API.Get_Valid_Conv_Factor(sales_uom_, partca_rec_.unit_code));
   
   RETURN NVL(partca_net_weight_, (Inventory_Part_API.Get_Weight_Net(contract_, part_no_) * conv_factor_/inverted_conv_factor_));
END Get_Partca_Net_Weight;


-- Get_Partca_Net_Volume
--   Returns the volume net of the part depending on the Use Partcatalog Specific values.
--   Net volume is unique for all site specifc and company/partcat specific instances.
@UncheckedAccess
FUNCTION Get_Partca_Net_Volume (
   contract_             IN VARCHAR2,
   catalog_no_           IN VARCHAR2,
   part_no_              IN VARCHAR2,
   sales_uom_            IN VARCHAR2,
   conv_factor_          IN NUMBER,    
   inverted_conv_factor_ IN NUMBER,
   volume_uom_           IN VARCHAR2) RETURN NUMBER
IS
   partca_net_volume_    NUMBER;
   partca_rec_           Part_Catalog_API.Public_Rec;
BEGIN
   partca_rec_ := Part_Catalog_API.Get(catalog_no_);
   -- Re-wrote the logic so that it would first fetch the net volume from part catalog using the sales part no. 
   -- IF it is null it will then fetch the net volume passing the inventory part no.    
   partca_net_volume_ := (Iso_Unit_API.Get_Unit_Converted_Quantity(partca_rec_.volume_net,
                                                                   partca_rec_.uom_for_volume_net,
                                                                   volume_uom_)
                  * Technical_Unit_Conv_API.Get_Valid_Conv_Factor(sales_uom_, partca_rec_.unit_code)); 
   
   RETURN NVL(partca_net_volume_, (Inventory_Part_API.Get_Volume_Net(contract_, part_no_) * conv_factor_)/ inverted_conv_factor_);
   
END Get_Partca_Net_Volume;
