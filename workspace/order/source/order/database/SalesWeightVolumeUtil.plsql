-----------------------------------------------------------------------------
--
--  Logical unit: SalesWeightVolumeUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160307  MaIklk  LIM-4670, Used Get_Config_Weight_Net() in Part_Weight_Volume_Util_API. 
--  140702  MaEdlk  Bug 117072, Removed rounding of weight and volume in method Get_Total_Weight_Volume.
--  130827  MaEelk  Modified Get_Total_Weight_Volume to add the volume of the part to the volume of the handling unit when the additive volume is checked on the handling unit.
--  130826  MaEelk  Modified Get_Total_Weight_Volume to fetch the tare weight of the connected handling unit when calculating the total_gross_weight and the adjusted_gross_weight of the part.
--  130716  MaEelk  Modified Get_Total_Weight_Volume and Get_Qty_In_Common_Uom to calculate weight and volume using weight and volume specified in handling units and part catalog. 
--  130716          If a handling unit is attached to a part and if weight and volume is defined for this handling unit it should be taken into consideration when calculating the gross weight and volume.
--  130716          With the new structure removed the usage of Calculate_Gross_Weight___, Calculate_Volume___, Calc_Partca_Gross_Weight___, Calculate_Partca_Volume___ from the logic.
--  100615  MaEelk  Replaced the usage of Company_Distribution_Info_API methods Get_Uom_For_Weight and Get_Uom_For_Volume
--  100615          with Company_Invent_Info_API methods Get_Uom_For_Weight and Get_Uom_For_Volume.
--  120404  RuLiLk  Bug 101757, Modified Get_Qty_In_Common_Uom, Get Sales part specific conversion factor 
--  120313  MoIflk  Bug 99430, Modified procedures Calc_Partca_Gross_Weight___ and Calculate_Partca_Volume___ to include inverted_conv_factor.
--  111205  MaMalk  Added pragma to Get_Total_Weight_Volume.
--  110922  NaLrlk  Modified the methods Calc_Partca_Gross_Weight___ and Calculate_Partca_Volume___.
--  110505  ChJalk  Added IN parameter configuration_id_ to the function Get_Total_Weight_Volume. 
--  090709  IrRalk  Bug 82835, Modified Calc_Partca_Gross_Weight___,Calculate_Gross_Weight___,Calculate_Partca_Volume___,Calculate_Volume___
--  090709          and Get_Total_Weight_Volume to round weight and volume to 4 and 6 decimals respectively.
--  090526  HimRlk  Bug 82874, Modified Get_Qty_In_Common_Uom to return qty_due_ for all the occasions the input UoM not used. 
--  090526          Handled pallet/parcel quantity with conversion factor in Calculate_Partca_Volume___.
--  081029  AmPalk  Changed Calculate_Gross_Weight___ and Calc_Partca_Gross_Weight___ to return net weight when package/pallet info. is missing.
--  080926  AmPalk  Added parameters to Get_Total_Weight_Volume to handle adjusted values with freight factor.
--  080926          Modified Get_Total_Weight_Volume to return partcat's net volume as adjsuted volume when package type or pallet type is missing.
--  080818  AmPalk  Added Calculate_Gross_Weight___, Calculate_Volume___, Calc_Partca_Gross_Weight___, Calculate_Partca_Volume___ by replacing Calculate_Gross_Weight and Calculate_Volume.
--  080818          Introduced Get_Total_Weight_Volume and Get_Qty_In_Common_Uom.
--  071210  MaRalk  Bug 66201, Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Qty_In_Common_Uom
--   Returns the buy_qty_due converted to the partcat/invent OR sales UoM, depending on the usage/set-up.
--   When using an Input Uom Group , sales part, invent part and part cat part has same unit.
--   If input UoM group is not used, the conversion factor can be defined in Unit Relations.
--   If both the places does not have a conversion factor and a conversion is required, 0 will get returned.
@UncheckedAccess
FUNCTION Get_Qty_In_Common_Uom (
   contract_        IN VARCHAR2,
   catalog_no_      IN VARCHAR2,
   part_no_         IN VARCHAR2,
   qty_due_         IN NUMBER,
   input_unit_meas_ IN VARCHAR2 DEFAULT NULL,
   input_qty_       IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
   sales_part_rec_           Sales_Part_API.Public_Rec;
   input_uom_group_          Inventory_Part_Tab.Input_Unit_Meas_Group_Id%TYPE;
   is_input_uom_grp_allowed_ VARCHAR2(20);
   qty_due_for_weight_       NUMBER := 0;
   con_factor_for_sal_uom_   NUMBER;

BEGIN
   sales_part_rec_           := Sales_Part_API.Get(contract_, catalog_no_);
   input_uom_group_          := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id( contract_, part_no_);
   is_input_uom_grp_allowed_ := Input_Unit_Meas_Group_API.Is_Usage_Allowed(input_uom_group_, 'ORDER' );
   IF (is_input_uom_grp_allowed_ = 'TRUE' AND input_qty_ IS NOT NULL) THEN
      IF (sales_part_rec_.sales_unit_meas = input_unit_meas_) THEN
          -- NOTE : buy_qty_due is in inventory UoM / partcat Uom.
          --        BUT on the CO Line, once the Input Uom qty entered, sales qty gets calclulated in Inventory UoM  (20-Aug-08 : AmPalk)
          --        the correct qty, is the input_qty .
          qty_due_for_weight_ := input_qty_;
       ELSE
          -- Note : In this situation, on the CO Line, user selects an other Input UoM from the dropdown box.
          --        Again the buy_qty_due gets calculated in Inventory UoM / part cat uom
          --        So get the buy_qty_due to the sales UoM
          --  Get the conversion factor for the sales part UoM in Input UoM Group on the CO line.
          con_factor_for_sal_uom_ := Input_Unit_Meas_API.Get_Conversion_Factor(input_uom_group_, sales_part_rec_.sales_unit_meas );
           IF (con_factor_for_sal_uom_ IS NOT NULL) THEN
              -- In Input UoM Group a conversion factor for the sales part UoM is there ..
              -- SO convert, buy_qty_due is in Invent UoM, get it in UoM on the sales part or on the partcat
              qty_due_for_weight_ := qty_due_ *  (1/con_factor_for_sal_uom_) ;
           ELSE
              -- Get Sales part specific conversion factor
              con_factor_for_sal_uom_ := NVL(sales_part_rec_.conv_factor, Technical_Unit_Conv_API.Get_Valid_Conv_Factor(Inventory_Part_API.Get_Unit_Meas( contract_, sales_part_rec_.part_no) ,sales_part_rec_.sales_unit_meas) );
               IF (con_factor_for_sal_uom_ IS NOT NULL) THEN
                  -- buy_qty_due is in Invent UoM, get it in UoM on the sales part or in the part cat.
                  qty_due_for_weight_ := qty_due_ * (1/con_factor_for_sal_uom_);
               ELSE
                  -- no way to convert inv part uom to sales part uom
                  qty_due_for_weight_ := 0;
               END IF;
           END IF;
       END IF;
   ELSE
       -- The UOM conversion is hadlled at the sales part level when calculating the net weight and volume. Sales qty directly can be used. 
      qty_due_for_weight_ := qty_due_;
   END IF;
   RETURN qty_due_for_weight_;
END Get_Qty_In_Common_Uom;



@UncheckedAccess
PROCEDURE Get_Total_Weight_Volume (
   total_net_weight_       IN OUT NUMBER,
   total_gross_weight_     IN OUT NUMBER,
   total_volume_           IN OUT NUMBER,
   adjusted_net_weight_    IN OUT NUMBER,
   adjusted_gross_weight_  IN OUT NUMBER,
   adjusted_volume_        IN OUT NUMBER,
   contract_               IN     VARCHAR2,
   catalog_no_             IN     VARCHAR2,
   part_no_                IN     VARCHAR2,
   buy_qty_due_            IN     NUMBER,
   configuration_id_       IN     VARCHAR2,
   input_unit_meas_        IN     VARCHAR2 DEFAULT NULL,
   input_qty_              IN     NUMBER   DEFAULT NULL,
   packing_instruction_id_ IN     VARCHAR2 DEFAULT NULL)
IS
   buy_qty_due_for_weight_ NUMBER := 0;
   company_                Company_Tab.Company%TYPE;
   sales_part_rec_         Sales_Part_API.Public_Rec;
   freight_factor_         Part_Catalog_Tab.freight_factor%TYPE;
   partca_net_weight_      NUMBER;
   total_net_volume_       NUMBER;
   partca_net_volume_      NUMBER;
   handling_unit_type_id_  VARCHAR2(25);
   handling_unit_type_rec_ Handling_Unit_Type_API.Public_Rec;
   tare_weight_            NUMBER := 0;
   max_quantity_capacity_  NUMBER;
   handling_unit_count_    NUMBER; 
   volume_uom_             VARCHAR2(30);
   weight_uom_             VARCHAR2(30);
BEGIN 
   company_                := Site_API.Get_Company(contract_);
   sales_part_rec_         := Sales_Part_API.Get(contract_, catalog_no_);
   buy_qty_due_for_weight_ := Get_Qty_In_Common_Uom(contract_, catalog_no_, part_no_, buy_qty_due_, input_unit_meas_, input_qty_);
   -- Freight factor is from partcat. This is used as a adjustment to weight and volume.
   freight_factor_         := Part_Catalog_API.Get_Freight_Factor(NVL(part_no_, catalog_no_));
   volume_uom_             := Company_Invent_Info_API.Get_Uom_For_volume(company_);
   weight_uom_             := Company_Invent_Info_API.Get_Uom_For_Weight(company_);
   
   -- Single sales part's net weight. For invent part throught Invent_Part_API and for non invent parts directly from part catalog.
   partca_net_weight_      := Part_Weight_Volume_Util_API.Get_Config_Weight_Net(contract_, catalog_no_, configuration_id_, sales_part_rec_.part_no, sales_part_rec_.sales_unit_meas,  sales_part_rec_.conv_factor, sales_part_rec_.inverted_conv_factor, weight_uom_);
   total_net_weight_       := buy_qty_due_for_weight_ * partca_net_weight_;   
   partca_net_volume_      := Part_Weight_Volume_Util_API.Get_Partca_Net_Volume(contract_, catalog_no_, part_no_, sales_part_rec_.sales_unit_meas,  sales_part_rec_.conv_factor, sales_part_rec_.inverted_conv_factor, volume_uom_);
   total_net_volume_       := buy_qty_due_for_weight_ * partca_net_volume_;
   adjusted_net_weight_    := total_net_weight_ * freight_factor_;
   
   handling_unit_type_id_  := Part_Handling_Unit_API.Get_Handl_Unit_Type_Id(catalog_no_, sales_part_rec_.sales_unit_meas, packing_instruction_id_);
  
   IF (handling_unit_type_id_ IS NOT NULL) THEN 
      handling_unit_type_rec_ := Handling_Unit_Type_API.Get(handling_unit_type_id_);      
      max_quantity_capacity_  := Part_Handling_Unit_API.Get_Max_Quantity_Capacity(catalog_no_, handling_unit_type_id_, sales_part_rec_.sales_unit_meas );
      handling_unit_count_    := CEIL(buy_qty_due_for_weight_/max_quantity_capacity_);
      tare_weight_            := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_type_rec_.tare_weight,
                                                                              handling_unit_type_rec_.uom_for_weight,
                                                                              weight_uom_),0);
      
      total_gross_weight_     := NVL(total_net_weight_,0) + (handling_unit_count_*tare_weight_);
      adjusted_gross_weight_  := NVL(adjusted_net_weight_,0) + (handling_unit_count_*tare_weight_);
      
      total_volume_           := Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_type_rec_.volume,
                                                                          handling_unit_type_rec_.uom_for_volume,
                                                                          volume_uom_) * handling_unit_count_;
      IF (handling_unit_type_rec_.additive_volume = Fnd_Boolean_API.DB_TRUE) THEN
         total_volume_  := NVL(total_volume_, 0) +  NVL(total_net_volume_, 0);  
      ELSE
         total_volume_        := NVL(total_volume_ , total_net_volume_);
      END IF;      
   ELSE
      total_gross_weight_     := total_net_weight_ ;
      adjusted_gross_weight_  := adjusted_net_weight_;
      total_volume_           := total_net_volume_; 
   END IF; 
   
   adjusted_volume_ := (total_volume_ * freight_factor_);
END Get_Total_Weight_Volume;




