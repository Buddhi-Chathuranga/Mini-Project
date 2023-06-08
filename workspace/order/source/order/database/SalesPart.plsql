-----------------------------------------------------------------------------
--
--  Logical unit: SalesPart
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220131  Jayplk  MF21R2-6781, Modified Check_Sourcing_Option___() to not allow source option to be set to Shop Order when connected inventory part has automatic capability check set to Reserve and Allocate .
--  220127  KaPblk  Bug 162090(SC21R2-7359), Modified Copy() to Check whether the Purchase Part is Exist before Copying
--  211207  NiRalk  SC21R2-5959, Modified New_Inventory_Part___() by adding statistical_code_,acquisition_origin_ and acquisition_reason_id_.
--  210524  ChFolk   SCZ-14841(Bug 159133), Added new method Get_Desc_For_New_Sales_Part which returns suggested value for catalog_desc which is used in Check_Insert___ when it is not defined from the client.
--  210203  NiDalk   SC2020R1-12228, Modified Check_Common___ to add validation for Close Tolerance.
--  210113  Maeelk   SC2020R1-12091, Modified Copy and replaced Unpack___, Check_Insert___ and Insert___ with New___.
--  210113           Modified Modify_List_Price, Copy_Characteristics, Copy_Customer_Warranty, Modify_Purchase_Part_No, Modify_Intrastat_And_Customs.
--  210113           Replaced Unpack___, Check_Update___ and Update___ with Modify___.
--  201202  PamPlk   Bug 154128(SCZ-12746), Modified Get_Supply_Site_Part_No__() to return inv_part_no_ if the supply_inv_part_ is null.  
--  201016  Skanlk   Bug 154258 (SCZ-11830), Modified Validate_Catalog_No_By_Gtin_No method to fetch the correct catalog_no by passing GTIN_NO or GTIN14.
--  200929  SBalLK   GESPRING20-537, Modified Check_Common___() method to validate statistical code for non-inventory services.
--  200826  MaRalk   SC2020R1-9443, Modified method Create_Part___ condition for the error message to have only Security_SYS.Is_Proj_Entity_CUD_Available check.
--  200623  MaRalk   SCXTEND-4449, Added annotation @ObjectConnectionMethod to the method call Get_Catalog_Desc in order to support object connection modeling.
--  200618  KhVese   SCXTEND-4435, Modified Create_Part___ and added Security_SYS.Is_Proj_Entity_CUD_Available() to check user permission when session is Odp.
--  200217  MaEelk   SCXTEND-2223, Modified Prepare_Insert___ and set LIST_PRICE and LIST_PRICE_INCL_TAX.
--  191129  SBalLK   Bug 150878 (SCZ-7736), Added Get_Catalog_No_By_Gtin_No() method.
--  190927  DaZase   SCSPRING20-151, Added Raise_Sm_Not_Allowed_Error___, Raise_Conv_Factor_Error___, Raise_Cc_Source_Opt_Error___ to solve MessageDefinitionValidation issues.
--  190530  ChBnlk   Bug 148505(SCZ-5192),  Added UncheckedAccess annotation to Get_Supply_Site_Part_No__.
--  190519  Cpeilk   Bug 147826 (SCZ-4760), Modified Get_Valid_Sourcing_Option to use catalog_no instead of part_no in the where condition.
--  180613  AsZelk   Bug 142293, Modified Check_Sourcing_Option___() and Check_Inv_Part_Planning_Data() in order to allow Primary Supplier Transit and Primary Supplier Direct sourcing options for Sales Part.
--  171122  MaEelk   STRSC-14625, parameter sales_price_type_db_ was removed from the call to Sales_Part_Base_Price_API.Modify_Prices_For_Tax in Update___.
--  170912  Cpeilk   Bug 137031, Removed the reference made to purchase_part_no in view comments of SALES_PART view. Modified Modify_Purchase_Part_No() to handle both removal and insertion of Purchase_Part_No field.
--  170626  ErRalk   Bug 135979, Changed the text case of message content in message constant PARTCATINVERTEDCONVFONE to eliminate duplicated definition for same message.
--  170601  niedlk   STRSC-8016, Modified Validate_Config_Allowed to make sure that a part cannot be set as configurable if  
--  170601           a sales part having a sales type including rental is available.
--  170523  niedlk   STRSC-8016, Modified Check_Commom___ method.
--  170512  niedlk   STRSC-8016, Modified Check_Commom___ method.
--  170507  niedlk   STRSC-8016, Modified Check_Commom___ method to raise an error if the sales type of a configurable sales part is set as Rental or Sales and Rental.
--  170506  ErFelk   Bug 133412, Added method Get_Valid_Sourcing_Option().
--  170405  KiAuse   STRMF-10229, Added method Get_Suggested_Sales_Part().
--  170317  Hairlk   APPUXX-10442, Added Is_Part_Available_For_Cust to check if the sales part is allowed for customer and modified Check_Limit_Sales_To_Assort to use that function.
--  160913  RasDlk   Bug 131386, Modified Check_If_Package_Part_Exist___ by removing the unnecessary codes and changing the information message PARENTPARTEXIST to be more generic.
--  160909  NWeelk   FINHR-1336, Modified Create_Sales_Part to calculate LIST_PRICE and LIST_PRICE_INCL_TAX using central logic.
--  160701  ThEdlk   Bug 130150, Modifed Insert___() and Update___() by changing the error message to an info message by allowing to create sales part when the Part Status in inventory part has "Demands Not Allowed".
--  160311  MaIklk   LIM-6564, Moved Get_Partca_Net_Volume() to DISCOM.
--  160307  MaIklk   LIM-4670, Moved Get_Partca_Net_Weight() and Get_Config_Weight_Net() to Part_Weight_Volume_Util_API.
--  160304  RuLiLk   Bug 127366, Added method Validate_Create_SM_Object___() to validate if 'Create SM Object' option is enabled when serial tracking is disabled
--  160304           and modified method Check_Serial_Track_Change() by moving the logic to a new method Validate_Sales_Type___() and calling Validate_Create_SM_Object___();
--  151123  IsSalk   FINHR-341, Moved tax fetching logic to Customer_Order_Tax_Util_API.
--  151123  IsSalk   FINHR-344, Moved tax related validations to Tax_Handling_Util_API.
--  151106  HimRlk   Bug 123910, Added new method Copy_Customer_Warranty().
--  151029  ApWilk   Bug 125280, Raised the error message NONINVPARTERROR in Check_Insert___, if part_no is not null and catalog_type is 'NON'.
--  151019  IsSalk   FINHR-136, Used FndBoolean in taxable attribute in sales part.
--  151013  IsSalk   FINHR-143, Renamed column FEE_CODE as TAX_CODE.
--  150820  NaLrlk   RED-68, Added Check_Serial_Track_Change() to part catalog validation for track changes.
--  150811  Vishlk   ANPJ-1349, Restrict the use of external resource purchase parts.
--  150729  DilMlk   Bug 123781, Modified Validate_Tax_Code___ to get an error message for Tax Codes with invalid date ranges.
--  150603  RuLiLk   Merged bug 121256, Modified Update___() to pass the base price site to update agreement sales part deal.
--  150226  NaSalk   PRSC-6277, Added Check_Commom___ method.
--  150207  SudJlk   Bug 120425, Modified Copy() method to copy delivery_type when copying a sales part.
--  150205  HimRlk   PRSC-5221, Added new private method Get_Supply_Site_Part_No__ to fetch inventory part no in the supply site.
--  141209  Hiralk   PRFI-3633, Modified Update___() to pass the base price site to update sales price lists.
--  141115  RasDlk   Bug 119396, Modified Copy() to set purchase_part_no to avoid the error when copying non inventory parts.
--  141030  MaIklk   EAP-648, Added Validate_Catalog_No__() in order to fetch the contract.
--  140722  ChFolk   Modified Update___ to modify fixed_amount in characteristic base price based on the change of tax infomation in sales part.
--  140718  AwWelk   PRSC-1525, Removed the assignment of default value for PART_STATUS when calling Inventory_Part_API.New_Part()
--  140718           in the method New_Inventory_Part___.
--  140604  MaEdlk  Bug 117072, Removed rounding at Get_Partca_Net_Weight and Get_Partca_Net_Volume.
--  140613  NaLrlk   Added rental_db_ parameter to Get_Default_Supply_Code() to fetch rental primaray supplier for rentals.
--  140523  MaEelk   Made changes to 113407 done in Insert___  according to the corrections relevant to the current code 
--  140519  MaRalk   PBSC-8806, Merged bug 116332 - Modified Get_Catalog_Desc() method by restructuring the code.
--  140509  NipKlk   Bug 116929, Modified call to Inventory_Part_API.New_Part method in New_Inventory_Part___ by passing the Inventory_Part_Status_Par_API.Get_Default_Status()
--  140509           as the part_status_ instead of 'A' to get the default past status from the Inventory Basic Data window.
--  140426  MaEelk   Removed the unnecessary block to call Part_Catalog_API.Create_Part in New_Inventory_Part___. Intriduce the Implementation method Create_Part___ and ,
--  140426           rewrote the logic of calling call Part_Catalog_API.Create_Part in New_Inventory_Part___ from Insert___.
--  140417  AyAmlk   Bug 116409, Modified Insert___() and New_Inventory_Part___(), so that a part catalog record will not be created
--  140417           if the user does not have permission for the Part_Catalog_API.Create_Part method.
--  140314  TiRalk   Bug 115882, Modified Check_Insert___, Insert___, Check_Update___, Update___ and Get by adding country_of_origin
--  140314           to get the value from non inventory sales part when collecting intrastat.
--  131220  ErFelk   Bug 114216, Modified Create_Sales_Part() by adding a default null patameter tax_class_id_. 
--  140402  NiDalk   Bug 113858, Modified method Copy to copy TAX_CLASS_ID as well. 
--  140305  SURBLK   Change Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Db in to Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db.
--  140228  AwWelk   PBSC-7474, Modified Check_Insert___() to handle the null value of list_price_incl_tax.
--  140217  MaEdlk   Bug 113407, Added procedure Validate_Config_Allowed. Modified Unpack_Check_Insert___, Insert___, Check_Configs_On_Sites___ and Check_Sourcing_Option___ to make sure:- 
--  140217           (1) The only allowed sales part/ inventory part combinations are 'both configured' or both 'not configured' in part catalog.
--  140217           (2) Only part catalog of the inventory part connected to sales part can have configutation family connected.
--  140217  THLILK   PBMF-5332, Added new method Get_Active_Catalog_No which returns the active sales part else return NULL.
--  140110  RoJalk   Modified PROCEDURE New and used new_attr_ instead of attr_ when calling Unpack methods.
--  121219  NaSalk   Modified Copy method to add sales type.
--  131205  CPriLK   CONV-2853, Added RENTAL_LIST_PRICE_INCL_TAX to SALES_PART_TAB and modified required places.
--  131125  IsSalk   Modified Check_Delete___() to check for commission agreement lines related to the sales part.
--  130717  PraWlk   Bug 111158, Modified Check_Delete___() by adding conditional compilation instead of dynamic method calls.  
--  130215  JuMalk   Bug 108257, Modified cursor get_all_parts in method Update_Weight_Volume_In_All to handle sales parts which has a different id than the connected inventory part.
--  130321  CPriLK   Added acquisition type to Purchase_Part_API.Exist.
--  130319  MaKrlk   Modified copy() method and remove the sales_type filtering in the view SALES_PART_FOR_PRICE_LIST_LOV
--  130318  MaKrlK   Added the new view ALL_SALES_PART_SERVICE_LOV
--  130314  MaKrlK   Added rental_price column in the LOV views
--  130312  NaLrlk   Added Get_Rental_List_Price and include rental_list_price column to select list in Get method.
--  130902  MaEelk   Removed package_type, pallet_type, proposed_parcel_qty and proposed_pallet_qty parameters from Create_Sales_Part.
--  130802  MaEelk   Added Get_Gross_Weight which would calculate the weight using handling units
--  130723  MeAblk   Modified the references of Pallet_Type_API and Package_Type_API into Handling_Unit_Type_API.
--  130716  MaEelk   Modified Get_Partca_Net_Weight and Get_Partca_Net_Volume to fetch the net weight and net volume from part catalog first using the sales part no. 
--  130716           If it is null it will then fetch the net weight passing the inventory part no. 
--  130225  NaSalk   Modified Exist method.
--  121221  CPriLK   Added Get_Sales_Type_Db(), NON_RENTAL_SALES_PART_LOV, ALL_SALES_PART_ACTIVE_LOV, added sales_type column to SALES_PART_GTIN_NO_LOV added where condition to the SALES_PART_LOV,   
--  121221           SALES_PART_ACTIVE_LOV, SALES_PART_SERVICE_LOV, SALES_PART_COM_LOV, SALES_PART_ALTERNATE_LOV, SALES_PART_FOR_PRICE_LIST_LOV, SALES_PART_EXCHANGE_COMP_LOV, SALES_PART_PRICE_TAX_LOV, 
--  130711  MaIklk   TIBE-1020, Removed global constants and used conditional compilation instead.
--  130711           Also moved declaration of g_purchase_part_ global variable to relevant function.--  130215  JuMalk   Bug 108257, Modified cursor get_all_parts in method Update_Weight_Volume_In_All to handle sales parts which has a different id than the connected inventory part.
--  130116  SURBLK   Modified Copy() by adding use price incl tax as 'false' for the non-VAT environments.
--  130115  SURBLK   Added Prices update method to update price list and customer agreement when changed the tax code.
--  121012  GayDLK   Bug 105778, Added new function Get_Expected_Average_Price and modified Get() by adding expected_average_price to the select list.
--  120920  RuLiLk   Bug 104306, Modified view SALES_PART_LOV2. Added catalog_group,sales_price_group_id and gtin_no, Enabled LOV for contract. 
--  120920           This view will be used as the LOV view for 'Sales Part' in 'Sales Part Base Price' window.
--  120917  NipKlk   Bug 104930, Restructured the code to raise an error message when connecting a configurable inventory part to a non-configurable sales part.
--  120907  GiSalk   Bug 105044, Modified Prepare_Insert___() by avoiding the assignment of date_entered. Modified Copy(), not to copy the value of date_entered.
--  120907  GiSalk   Modified Insert___() by inserting the site date in to the attribute, date_entered.
--  120705  UdGnlk   Modified the length of column CUSTOMS_STAT_NO in view comments.
--  121221           SALES_PART_PACKAGE_LOV and SALES_PART_PKG_COMP_LOV, SALES_PART_CLASSIFICATION_LOV, SALES_PART_LOV2, SALES_PART_GTIN_NO_LOV and added default parameter usage_ for Exist().
--  121207  PeSulk   Added new column sales_type.
--  120629  NipKlk   Bug 102950, Added Check_Reference_Exist method calls in Check_Delete___  to validate if a Business Object Reference exists.
--  120627  ShKolk   Modified Unpack_Check_Update___ to call Sales_Part_Base_Price_API.Modify_Base_Prices when tax code is changed.
--  100615  MaEelk   Replaced the usage of Company_Distribution_Info_API methods Get_Uom_For_Weight and Get_Uom_For_Volume
--  100615           with Company_Invent_Info_API methods Get_Uom_For_Weight and Get_Uom_For_Volume.
--  120606  MaRalk   Bug 103076, Added attribute activeind to view SALES_PART_PRICE_TAX_LOV.
--  120525  ShKolk   Added columns use_price_incl_tax and list_price_incl_tax.
--  120305  MaMalk   Bug 99430, Added attribute inverted conversion factor to define the inventory conversion factor in an inverted way
--  120305           so the long decimal values caused by division can be avoided.
--  120301  MeAblk   Bug 101074, Modified the View SALES_PART_PRICE_TAX_LOV by adding part_no and export_to_external_app in order to use this view as the LOV for Sales Part No in the Sales Quotation lines. 
--  120206  NaLrlk   Modified the method Validate_Catalog_No_By_Gtin_No to change the error message.
--  120201  ChJalk   Added NOCHECK to the view comments of part_no in view SALES_PART_LOV2.
--  120130  PraWlk   Bug 99404, Modified New_Inventory_Part___() by removing the parameter superseded_by when calling Inventory_Part_API.New_Part().
--  120130  NaLrlk   Replaced the method call Part_Catalog_API.Get_Active_Gtin_No with Part_Gtin_API.Get_Default_Gtin_No.
--  120126  NaLrlk   Modified Validate_Catalog_No_By_Gtin_No, Get_Gtin_No to change the method calls Part_Input_Unit_Meas_API to Part_Gtin_Unit_Meas_API.
--  120126           Modified the SALES_PART_GTIN_NO_LOV view accordingly.
--  120126  ChJalk   Modified the view comments of the column gtin_no in the base view.
--  120124  MoIflk   Bug 100743, Added procedure Modify_Intrastat_And_Customs to update the customs_stat_no and intrastat_conv_factor fields 
--  120124           in sales part when inventory part is connected.
--  120109  NipKlk   Bug 99736, Modified error messages for constants NOINTRA, NOINTRA1 and INTRACONVGREATER0 to make them more clear.
--  111207  MaMalk   Added pragma to Get_Total_Cost and Get_Totals__.
--  111108  ChJalk   Added user allowed site filter to the view SALES_PART_ACTIVE_LOV.
--  111024  NaLrlk   Modified the method Get_Config_Weight_Net retreive the config weight net in company UoM.
--  111014  MaMalk   Bug 98941, Modified method Check_Sourcing_Option___ to use inventory part no or the purchase part no when checking for purchase part exist.
--  111005  NWeelk   Bug 99242, Modified method Get_Total_Cost to send the unrounded value for total cost. 
--  110926  ChJalk   Modified the method Get_Gtin_No to return active gtin nos and views SALES_PART, SALES_PART_LOV, SALES_PART_ACTIVE_LOV and SALES_PART_SERVICE_LOV to return active gtin nos.
--  110922  NaLrlk   Modified the method Get_Salpart_Gross_Weight and Get_Salpart_Volume.
--  110922  ChJalk   Modified the method Validate_Classification_Data to raise an error message if the same classification part no is connected to two sales parts in the same assorment.
--  110921  NaLrlk   Modified the methods Get_Partca_Gross_Weight and Get_Partca_Volume.
--  110915  MaMalk   Added extra where condition to view SALES_PART_FOR_PRICE_LIST_LOV to only select active sales part base price records.
--  110906  ChJalk   Modified the error message NOGTIN.
--  110906  ChJalk   Renamed the method call Get_Catalog_No_By_Gtin_No to Validate_Catalog_No_By_Gtin_No.
--  110906  ChJalk   Modified the views SALES_PART, SALES_PART_LOV, SALES_PART_ACTIVE_LOV and SALES_PART_SERVICE_LOV to fetch the gtin_no for non-inventory sales parts and package parts correctly.
--  110906  ChJalk   The function Get_Catalog_No_By_Gtin_No was changd to a procedure and introduced the error message NOGTIN.
--  110905  NaLrlk   Modified the method Get_Partca_Volume to convert the gross volume from Company UOM.
--  110901  ChJalk   Added gtin_no to the base view.
--  110829  NWeelk   Bug 98514, Modified method Get_Totals__ to send unrounded total_sales_price_. 
--  110817  ChJalk   Bug 97482, Modified Get_Config_Weight_Net to correct the calculation.
--  110817  AmPalk   Bug 97482, Modified Get_Config_Weight_Net to consider, instances where invent UoM is not from weight type. (E.g. PCS)
--  110721  ChJalk   Removed the view SALES_PART_UIV.
--  110719  ChJalk   Added the user allowed site filteration to the views SALES_PART_EXCHANGE_COMP_LOV and SALES_PART.
--  110718  MaMalk   Bug 98061, Modified Unpack_Check_Update___() and Unpack_Check_Insert___ by removing IF condition to update intrastat conv factor without 
--  110718           considering the customs_stat_no is NULL or not.
--  110708  Cpeilk   Bug 96494, Removed text_id column from view SALES_PART_BPRICE_ALLOWED_LOV to eliminate incorrect results displayed.
--  110706  MaMalk   Added the user allowed site filteration to the SALES_PART_ALTERNATE_LOV, SALES_PART_GTIN_NO_LOV and SALES_PART_PRICE_TAX_LOV.
--  110705  ChJalk   Added User_Allowed_Site filter to the view VIEW2 and VIEW_PKG_COMP_LOV.
--  110701  JuMalk   Bug 94895, Modified method Copy. Added extra attributes to the attribute string. Modified methods Copy_Characteristics() and Copy_Language_Descriptions()
--  110701           added condition to raise the error only for inventory parts. Modified method Copy. Added condition to check catalog_type - INV before calling Inventory_Part_API.Check_Exist.
--  110701           By doing this Inventory_Part_API.Check_Exist will be only called for inventory parts. 
--  110526  ShKolk   Added General_SYS for Get_Company_Freight_Figures() and Get_Site_Freight_Figures().
--  110509  AmPalk   Bug 96073, Modified Get_Config_Weight_Net to return the weight converted to the sales UoM.
--  110506  JaBalk   Bug 95920, Added reference for the purchase_part_no in view comments of SALES_PART view. Removed duplicate code from New_Inventory_Part___(). Moved the code
--  110506           to assign newrec.part_no to newrec.purchase_part_no to Insert___() from Unpack_Check_Insert___(). Restructured the method call Inventory_Part_API.New_Part().
--  110506           Added new procedure Modify_Purchase_Part_No() to update the purchase_part_no field for a specific catalog_no in SALES_PART_TAB if the purchase_part_no field is NULL.
--  110506           Added method call to update purchase_part_no field of existing customer order lines where order is in planned state for the above part.
--  110506  MatKse   Modified validation in Update___ for when a sales part is set to active and the corresponding inventory part have no demands allowed.
--                   Error is now only triggered if one try to change the specific flag in contrast to when the error was triggered on any change in sales part.
--  110505  ChJalk   Added function Get_Config_Weight_Net.
--  110504  MiKulk   Modified the method Copy, to calculated the Price, Cost and expected average price
--  110504           with the currency conversion between from and to sites..
--  110321  ShKolk   Removed auto_created_gtin from views.
--  110308  Darklk   Bug 95798, Added an implemention procedure Handle_Description_Change___ to update the changed sales part description in the doc reference,
--  110308           added procedures Handle_Partca_Desc_Flag_Change and Handle_Partca_Desc_Change and modified the procedure Update___ to
--  110308           update the changed sales part, non-inventory and package parts description in the doc reference.
--  110204  ShVese   Replaced several calls to Part_Catalog_API with Get method in Unpack_Check_Insert___ and replaced
--                   replaced serial_tracking_code with receipt_issue_serial_track. 
--  110111  Darklk   Bug 95149, Added the function Get_Catalog_Group_Desc.
--  101028  LEPESE   Renamed method Part_Catalog_API.Tracked_In_Inventory to Lot_Or_Serial_Tracked.
--  110131  Nekolk   EANE-3744  added where clause to View SALES_PART
--  110113  Elarse   DF-553, Modified code in Validate_Tax_Code___().
--  101217  Elarse   DF-562, Restructured Validate_Tax___() and added new procedure Validate_Tax_Code___().
--  101202  Elarse   DF-534, Added error message and modified validations in Validate_Tax___().
--  101129   Elarse   DF-526, Added new attribute TaxClassId. Added tax_class_id_ parameter to Validate_Tax___().
--  101018  ShKolk   Removed GTIN_NO and GTIN_SERIES.
--  100716  SudJlk   Bug 91540, Redefined the scope of method Get_Active_Prim_Catalog_No as public.
--  100930  NaLrlk   Modified the view SALES_PART_GTIN_NO_LOV and method Get_Catalog_No_By_Gtin_No.
--  100811  SUJALK   EANE-3311, Removed the code segment which synchronized the sales part with the sales configurator my removing the dynamic method call Config_Xms_Interface_API.Sync_Xms_Part.
--  100929  NaLrlk   Added method Get_Gtin_No.
--  100804  MaRalk   Added method Check_Non_Inv_Salespart_Active in order to use in Cro Service Type Connection.
--  100714  ChFolk   Removed public attributes bonus_basis_flag and bonus_value_flag and their public methods and corresponding entries in Unpack_Check_Insert___, Insert___,
--  100714           Unpack_Check_Update___ and Update___. Modified Create_Sales_Part to remove parameters bonus_basis_flag_ and bonus_value_flag_ as bonus functionality is obsoleted.
--  100514  KRPELK   Merge Rose Method Documentation.
--  091103  NaLrlk   Bug 86768, Merge IPR to APP75 Core.
--  090930  MaMalk   Removed methods Modify_Cost___, New_Template___, Get_No_Of_Active_Sales_Parts, Get_Active_Catalog_No_For_Part and Get_Active_Catalog_No_For_Pur.
--  090930           Removed unused code in Unpack_Check_Insert___, Unpack_Check_Update___ and Check_If_Package_Part_Exist___.
--  ------------------------- 14.0.0 -------------------------------------------
--  100312  NaLrlk   Added derived column auto_created_gtin and used it in server call Part_Catalog_API.Update_Gtin.
--  091103  NaLrlk   Bug 86768, Merge IPR to APP75 Core.
--  090924  ChJalk   Bug 82611, Modified the methods Unpack_Check_Insert___ and Unpack_Check_Update___ to avoid error messages NOINTRA and NOINTRA1 for package parts.
--  091125  RiLase   Removed weight and weight unit of measure in part catalog part creation in Insert___.
--  090814  MaJalk   Bug 83121, Changed the data type of the gtin no to string.      
--  090728  ChJalk   Bug 82866, Modified method Get_Partca_Gross_Weight to correct the conversion factor for non-inventory parts.
--  090715  ChJalk   Bug 82866, Modified method Get_Partca_Net_Volume to get the correct value of sales_uom.
--  090702  LaPrlk   Bug 82866, Added Get_Site_Freight_Figures, Get_Company_Freight_Figures and modified Get_Partca_Gross_Weight, Get_Partca_Net_Volume, Get_Partca_Net_Weight.
--  090811  IrRalk   Bug 82835, Modified methods Unpack_Check_Insert___, Get_Partca_Net_Weight, Get_Partca_Gross_Weight, Get_Partca_Volume and
--  090811            Get_Partca_Net_Volume to round weight and volume to 4 and 6 decimals respectively.
--  090824  ShKolk   Modified cursor get_all_parts_packpallet of Update_Weight_Volume_In_All() to select correct values for package_type and pallet_type. 
--  090817  ShKolk   Modified Get_Partca_Volume() to convert into company uom.
--  090527  SuJalk   Bug 83173, Added a fullstop at the end of the message NEEDDATE. Changed the translation constant to NOTAXINFODEF in Prepare_Insert___.
--  090504  MaMalk   Bug 80272, Modified view SALES_PART, methods Prepare_Insert___, Unpack_Check_Insert___, Insert___, Unpack_Check_Update___, Update___, Copy and Get
--  090504           to introduce attribue PRIMARY_CATALOG. Added methods Get_Primary_Catalog, Get_Active_Catalog_No, Get_Active_Prim_Catalog_No___, Get_No_Of_Active_Sale_Parts___
--  090504           and Check_Active_Sales_Part. Removed methods Get_No_Of_Active_Sales_Parts, Get_Active_Catalog_No_For_Part and Get_Active_Catalog_No_For_Pur introduced by bug 72223.
--  090330  SudJlk   Bug 77435, Modified method New_Inventory_Part___ to change value assignment for planner_buyer_ and check if it's NULL.
--  081218  NWeelk   Bug 78131, Added a procedure Check_Enable_Catch_Unit and modified Unpack_Check_Insert___ to handle Catch Unit
--  081218           correctly for non-inventory sales parts and for package parts.
--  081008  PraWlk   Bug 76816, Restructured Check_Enable_Part_Tracking. Modified Unpack_Check_Insert___ to
--  081008           prevent creating a package part if the part is serial tracked and/or lot batch tracked.
--  080929  PraWlk   Bug 76816, Added Check_Enable_Part_Tracking. Modified Unpack_Check_Insert___ to prevent
--  080929           creating a non-inventory sales part if the part is serial tracked and/or lot batch tracked.
--  090708  HimRlk   Bug 83459, Modified the IF condition in method Modify and method Modify__ when updating the GTIN in part catalog.  
--  090225  KiSalk   Modified create_sales_part to set USE_SITE_SPECIFIC_DB when PACKAGE_TYPE or PALLET_TYPE has value.
--  081201  MaJalk   At Unpack_Check_Insert___, removed unnecessary assignment of GTIN.
--  081106  AmPalk   Added Get_Salpart_Gross_Weight and Get_Salpart_Volume, peplaced code in Unpack_Check_Insert___, Unpack_Check_Update___, Insert___ and Update_Weight_Volume_In_All. 
--  081103  AmPalk   Added volume_net_ to Update_Weight_Volume_In_All. Made gross volume = net volume when package/pallet info null.
--  081030  AmPalk   Added parameter sales_uom_ to Get_Partca_Net_Volume,Get_Partca_Net_Weight and Get_Partca_Gross_Weight.
--  081023  MaJalk   Corrected validations for GTIN No at Unpack_Check_Insert___.
--  081021  KiSalk   Added Validate_Classification_Data.
--  081005  AmPalk   Removed weight and volume parameters from create_sales_part, since now freight information is based from part catalog.
--  081005           Added Get_Partca_Net_Volume. Removed Get_Used_Net_Weight.
--  081005           Modified Unpack_Insert___ by adjusting the code that calclulate gross weight and volume.
--  081003  AmPalk   Modified Unpack_Insert___ by adding code to fetch net weight when no value passed in. This is due to the Copy Part functionality.
--  081003           Now in copy method any freight information does not get copyed.
--  080828  AmPalk   Added Get_Partca_Gross_Weight and Get_Partca_Net_Weight and Update_Weight_Volume_In_All.
--  080827  AmPalk   Commented COMMIT in Modify_Freight_Details__.
--  080808  AmPalk   Added Use_Site_Specific.
--  080807  AmPalk   Modified methods Insert___ and New_Inventory_Part___ to pass weight_net and UoM of that attribute to the PARTCA side when a part catalog record gets entered from ORDER side.
--  080701  KiSalk   Merged APP75 SP2.
--  ----------------------------- APP75 SP2 Merge - End -----------------------------
--  080510  ChJalk   Bug 73822, Modified Unpack_Check_Update___ to add the error message SAMEASSALESPARTNO if the replacement part no is as same as the sales part no.
--  080331  NaLrlk   Bug 72223, Added functions Get_No_Of_Active_Sales_Parts, Get_Active_Catalog_No_For_Part and Get_Active_Catalog_No_For_Pur.
--  080306  MaMalk   Bug 70852, Added method Copy_Language_Descriptions.
--  ----------------------------- APP75 SP2 Merge - Start -----------------------------
--  080528  AmPalk   Renamed Update_Gtin_In_All to Update_Gtin_In_All_Sites. Most of the Update_Gtin_In_All_Sites method calls moved in to the Part_Catalog_API.Update_Gtin.
--  080527  KiSalk   Removed ean_no.
--  080513  AmPalk   Modified Create_Sales_Part and Copy methods to handle sales_part_rebate_group.
--  080502  KiSalk   Added gtin_no to views SALES_PART_LOV, SALES_PART_ACTIVE_LOV and SALES_PART_SERVICE_LOV.
--  080425  AmPalk   Set GTIN nullable.
--  080424  AmPalk   Added parameter gtin_series_ TO Part_Catalog_API.Create_Part.
--  080423  KiSalk   Added attribute gtin_series and method Get_Gtin_Series. Added parameter gtin_series to Update_Gtin_In_All.
--  080418  KiSalk   Added views SALES_PART_GTIN_NO_LOV and SALES_PART_CLASSIFICATION_LOV.
--  080418  AmPalk   Modified Modify__ and Modify to handle GTIN update.
--  080417  AmPalk   Modified Insert___ to update GTIN in part cat and invent parts if the GTIN entered at the sales Part level and the sales part is from an existing part.
--  080417  KiSalk   Added Get_Catalog_No_By_Gtin_No
--  080416  AmPalk   Added Update_Gtin_In_All.
--  080416  AmPalk   Called Part_Catalog_API.Update_Gtin to set GTIN on part catalog when inserting a ssales part for existing part.
--  080416  AmPalk   Only active gtin nos will be saved on sales part.
--  080412  AmPalk   Added gtin_no.
--  080312  RiLase   APP75 SP1 merged.
--  ---------------------- APP75 SP1 merge - End ----------------------
--  080108  NaLrlk   Bug 70155, Modified the method Copy to handle copy functionality when same Inventory & Sales part exist.
--  071227  ChJalk   Bug 69400, Addded parameter raise_error_ o the function Check_If_Valid_Component and modified the method.
--  071227           Also added view SALES_PART_PKG_COMP_LOV.
--  071218  SaJjlk   Bug 69456, Modified method Validate_Tax__ to raise same error messgae for tax regimes VAT and MIX.
--  071217  MaRalk   Bug 68703, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to change the replacement part connention logic.
--  071210  MaRalk   Bug 66201, Modified Unpack_Check_Insert___, Unpack_Check_Update___ and Modify_Freight_Details__
--  071210           to correctly fetch gross weight. Modified functions Get_Volume, Get_Weight_Gross and Get_Weight_Net.
--  071030  MaMalk   Bug 68168, Modified Check_Sourcing_Option___ to restrict entering Non Inventory Sales Parts
--  071030           with sourcing option PRODUCTIONSCHEDULE.
--  ---------------------- APP75 SP1 merge - Start ----------------------
--  080225  JeLise   Added IF-statement on sales_part_rebate_group in Unpack_Check_Update___.
--  080213  JeLise   Added Get_Sales_Part_Rebate_Group.
--  080124  RiLase   Added exist check on Sales_Part_Rebate_Group in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  080122  RiLase   Added Sales_Part_Rebate_Group.
--  080116  JeLise   Commented use of bonus_basis_flag, bonus_basis_flag_db, bonus_value_flag and bonus_value_flag_db.
--  ---------------------- Nice Price ----------------------
--  070925  MoNilk   Added text_id$ and view comments to LU connected views.
--  070913  ChBalk   Bug 67061, Function Check_If_Valid_Component__ was set to public.
--  070910  MoNilk   Added text_id$ to the view PURCHASE_PART.
--  070910  RoJalk   Replaced the method Get_Part_Desc_Doc_Text with Get_All_Notes.
--  070821  MaJalk   Changed view SALES_PART_ALTERNATE_LOV.
--  070803  RoJalk   Minor modifications to the method Get_Part_Desc_Doc_Text.
--  070727  RoJalk   Minor modifications to the method Get_Part_Desc_Doc_Text.
--  070726  RoJalk   Added the method Get_Part_Desc_Doc_Text.
--  070712  KaDilk   Bug 66376, Modified Validate_Tax___ to add conditions to the error message ONLY_VAT.
--  070711  MiKulk   Bug 65861, Removed 'P' from mrp_order_code list, for DOPORDER check, in method Check_Inv_Part_Planning_Data.
--  070629  MaJalk   Bug 64918, Removed 'P' from mrp_order_code list, for DOPORDER check.
--  070626  MaMalk   Bug 65873, Modified the view SALES_PART_ACTIVE_LOV and added columns tax_price, fee_code and description.
--  070619  NaLrlk   Bug 65282, Modified method Copy and added new error message INVPARTNOTEXIST.
--  070619  NaLrlk   Added the procedure Check_If_Package_Part_Exist___ and modified Unpack_Check_Update___.
--  070426  WaJalk   Changed the error message REPLACED in Check_If_Valid_Component__ to be more descriptive.
--  070215  MiErlk   Modified the PROCEDURE Create_Sales_Part.
--  070125  KeFelk   Changes to Create_Sales_Part.
--  070111  DaZase   Added contract_ as an inparam in method Check_Enable_Catch_Unit and also in the cursor of this method.
--                   Fix in Check_Catch_Unit___ so it calls Inventory Part to fetch Catch Unit Meas.
--  070108  NaLrlk   Added the function Get_Allow_Partial_Pkg_Deliv_Db.
--  070104  RaKalk   Modified Get_Totals and Get_Total_Cost method to pass null for sales_qty parameter and to pass 'CHARGED ITEM' for charged_item parameter.
--  061221  ChBalk   Replaced Inventory_Part_API.Get_Inventory_Value_By_Method with Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead.
--  061214  IsWilk   Modified the PROCEDURE Create_Sales_Part.
--  061213  IsWilk   Modified the PROCEDURE Create_Sales_Part.
--  061211  NiDalk   Added method Create_Sales_Part.
--  061206  NaLrlk   Bug 61994, Modified method Validate_Tax___ to only allow tax codes of type VAT when the company tax regime is VAT.
--  061116  NaLrlk   Modified the Unpack_Check_Insert___ for non pkg parts - attribute allow_partial_pkg_deliv.
--  061115  MaJalk   Added method Get_Allow_Partial_Pkg_Deliv and attribute allow_partial_pkg_deliv.
--  060829  HaPulk   Bug 59569, Added the views SALES_PART_PACKAGE_LOV and SALES_PART_INVENTORY_LOV.
--  060821  ErFelk   Bug 59786, Set the lov flag of the CONTRACT in the base view in order to reselected in the dynamic lov of the object connection.
--  060803  RoJalk   Removed catalog_desc from public Get.
--  060727  RoJalk   Modified the method Get_Catalog_Desc and added language_code_ parameter.
--  060727           Modified Get_Catalog_Desc_For_Lang.
--  060726  RoJalk   Modified the method Get_Catalog_Desc and modified the views to use it
--  060726           to fetch the catalog_desc instead from the table.
--  060605  MiErlk   Enlarge Description - Changed Variables Definitions.
--  060601  MiErlk   Enlarge Description - Changed view comments .
--  060529  PrPrlk   Bug 57598, Changed the logic in method Get_Catalog_No_For_Part_No to return the first active sales part if one exists,
--  --------------------------------- 13.4.0 --------------------------------
--  060316  KeFelk   Added code to Prepare_Insert___ to fetch the Tax_free_TAx_code when Taxable is False.
--  060309  NiDalk   Modified Customs_Stat_No validations to check for 0 Intrastat conversion factors in Unpack_Chaek_Insert___ and Unpack_Check_Update___.
--  060307  IsWilk   Added the FUNCTION Get_Eng_Attribute and modified the PROCEDURE Unpack_Check_Update__
--  060307           to add the error message ERRENGATTR
--  060306  JaJalk   Added Assert safe annotation.
--  060225  NiDalk   Modified Unpack_Chaek_Insert___ and Unpack_Check_Update___ to make parcel quantity null when
--                   package_type and parcel_type are null.
--  060222  NiDalk   Added Customs_Stat_No validations to Unpack_Chaek_Insert___ and Unpack_Check_Update___.
--  060216  SaNalk   Modified the Cursor in Get_Commission_Catalog_Desc.
--  060206  DaZase   Change in Prepare_Insert___ so DOP parts will be defaulted with sourcing option DOPORDER instead of INVENTORYORDER.
--  060130  IsWilk   Added the PROCEDURE Check_Delivery_Type__ and mofified the reference of delivery_type.
--  060124  JaJalk   Added Assert safe annotation.
--  060102  RaKalk   Added view SALES_PART_CC_LOV to be used in Call_Center module
--  051219  RaKalk   Modified Unpack_Chaek_Insert___, and Unpack_Check_Update___ to give an error
--  051219           when proposed_parcel_qty field is set to zero or a negative value.
--  051216  JoEd     Added EXPORT_TO_EXTERNAL_APP. Removed CONFIGURATION.
--                   Removed Set_Not_Configured.
--  051020  IsWilk   Added the attribute delivery_type.
--  051003  SuJalk   Changed the references in SALES_PART_SERVICE_LOV,SALES_PART_PL_LOV,SALES_PART_BPRICE_ALLOWED_LOV,
--                   SALES_PART_COM_LOV,SALES_PART_FOR_PRICE_LIST_LOV,SALES_PART_LOV2 views to user_allowed_site_pub.
--                   Also changed the references of get_attr cursors on Get_Commission_Catalog_Desc and Catalog_No_Exist to user_allowed_site_pub.
--  050920  MaEelk   Removed unused variables.
--  050601  IsWilk   Removed column warranty.
--  050518  KeFelk   Added VAT_MANDATORY error msg to the Validate_Tax___.
--  050518  SaJjlk   Modified method Unpack_Check_Insert___ to set purchase_part_no for inventory parts before validating sourcing option.
--  050503  JoEd     Bug 49796. Changed Check_Sourcing_Option__ and Get_Default_Supply_Code
--                   to fetch primary supplier from the correct purchase part.
--  050429  KeFelk   Changed parameters to the method call Approval_Routing_API.Copy_App_Route().
--  050421  SaJjlk   Added method Modify_Freight_Details__ and Package_Type_Exist.
--  050405  ChFolk   Bug 50489, Modified Prepare_Insert___ to add a default value to cost of Non Inventory Sales Part.
--  050324  KeFelk   Change copy value to to_part for Part_No in Copy().
--  050323  JoEd     Changed Get_Default_Supply_Code further. Removed prior addition (ND).
--  050322  JoEd     Added default supply code ND for options PRIMARYSUPP* having no primary supplier.
--  050314  KeFelk   Changed the cursor where condition of Copy().
--  050310  JoEd     Added delivery_confirmation from sales_group to VIEW2 and VIEW3.
--  050309  KeFelk   Corrected key_refs in Copy_Connected_Objects.
--  050214  KeFelk   Added methods Copy, Copy_Note_Texts, Copy_Connected_Objects and Copy_Characteristics.
--  050207  DaZase   Added new function Src_Option_Must_Be_Dop_Or_So and some new sourcing option checks in unpack methods.
--  050201  JICE     Bug 49187, Added public attribute minimum_qty.
--  050119  DaZase   Added new method Check_Inv_Part_Planning_Data.
--  050113  JaBalk   Removed Package_Weight column and Get_Package_Weight and changed the logic of calculating
--  050113           weight_gross in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  050112  DaZase   Removed check for order_requisition in Get_Default_Supply_Code and only check for sourcing option DOPORDER now instead.
--  050110  ToBeSe   Bug 48972, Modified Unpack_Check_Insert___ to fetch customs_stat_no and intrastat_conv_factor
--                   from inventory part for inventory sales parts.
--  050103  NaLrLk   Added the if condition IF (taxable_ = 'Use sales tax') in Prepare_Insert__
--  041227  NaLrLk   Removed the if condition for quick_registered=TRUE in Prepare_Insert__
--  041216  RaKalk   Replaced get_total_price, get_inventory_sum, get_non_inventory_sum cursors with cursor get_totals in Get_Totals__ method.
--  041216           Replaced get_inventory_sum, get_non_inventory_sum cursors with cursor get_sums in Get_Total_Cost method.
--  041203  DaZase   Removed error message SUPPTYPEDOPORDER in Check_Sourcing_Option___ and replaced it with
--                   a new check on mrp_order_code and a new error message MRPCODEPNNOTALLOWED.
--  041101  GeKalk   Removed method Get_Common_Price_Uom and added a new method Check_Enable_Catch_Unit.
--  041101  GeKalk   Added a new method Get_Common_Price_Uom.
--  041028  DiVelk   Modified Check_Sourcing_Option___ and Get_Default_Supply_Code.
--  041020  GeKalk   Added a new method Check_Catch_Unit___.
--  041013  SaRalk   Modified SALES_PART_PRICE_TAX_LOV by rearranging the fields and view comments.
--  040930  ChBalk   Bug 46903, Removed total_sales_cost_ parameter from Get_Totals__. Added Get_Total_Cost() method.
--  040920  DiVelk   Modified methods [New] and [Prepare_Insert___].
--  040917  GeKalk   Added a new view SALES_PART_PRICE_TAX_LOV.
--  040915  DhAalk   Modified the procedure Check_Sourcing_Option___ to remove the ckeck on Primary Supplier
--  040915           when the sourcing option is PRIMARYSUPPTRANSIT or PRIMARYSUPPDIRECT.
--  040910  LoPrlk   Modified the method Get_Catalog_From_Cross_Ref.
--  040831  DhWilk   Added the Not Null Column QUICK_REGISTERED_PART to SALES_PART_TAB.
--  040830  DhAalk   Modified the procedure Check_Sourcing_Option___ to restrict the sourcing option "Invent Order"
--  040830           for Configured parts regardless of part type is DOP-Part or not.
--  040825  DhAalk   Modified the procedure Check_Sourcing_Option___ to change an error label.
--  040825  DhAalk   Modified the procedure Check_Sourcing_Option___.
--  040824  LaBolk   Added method Check_Exist_On_User_Site. Added UNDEFINE statements.
--  040722  LaBolk   Removed General_SYS.Init_Method from Get_Catalog_From_Cross_Ref and Is_Same_Catalog_No_For_Part_No to comply with PRAGMA.
--  040720  VeMolk   Bug 45030, Modified an error message in Check_Unit_Meas_On_Sites___ for giving better explanation.
--  040715  HeWelk   Modified Unpack_Check_Update___- Check the conversion factor against
--                   Inventory part if Inventory UuM group exist.
--  040715  HeWelk   Modified Unpack_Check_Insert___- Check the conversion factor against
--                   Inventory Part and part catalog if UuM group exist.
--  040714  HeWelk   Added public method Exist_Mum_Inv_Part().
--  040630  DhAalk   Modified procedure Check_Sourcing_Option___ and function Get_Default_Supply_Code.
--  040628  PrTilk   Bug 43130, Modified the view SALES_PART_EXCHANGE_COMP_LOV to exclude the
--  040628           alternate parts that are not condition code enable parts.
--  040617  GeKalk   Added a new method Is_Same_Catalog_No_For_Part_No to find a part no who's catalog no similar to the part no.
--  040616  DhAalk   Modified the procedure Check_Sourcing_Option___.
--  040616  GeKalk   Added the method Get_Catalog_From_Cross_Ref.
--  040608  DhAalk   Modified the procedure Check_Sourcing_Option___ to add validations for newly
--  040608           added sourcing options Primary supplier transit/direct and DOP order.
--  040607  UdGnlk   Bug 45110, Added Public method Get_Catalog_Desc_For_Lang.
--  040507  DhAalk   Added code for shop order in function Get_Default_Supply_Code and
--  040507           added check for shop order in  Check_Sourcing_Option___.
--  040423  KaDilk   Bug 44028, Modified the error message CTOPARTERROR in function Check_Sourcing_Option___.
--  040225  IsWilk   Removed SUBSTRB from the views for Unicode Changes.
--  040129  GeKalk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  020502  MaGu     Added tagging of code.
--  011217  Prinlk   Sales Part net weight defaulted to the corresponding inventory part weight when
--                   inserting the sales part into the system. The attributes pallet_type and proposed_pallet_qty
--                   has been added to the corresponding table.
--  ********************* VSHSB Merge *****************************
--  040113  LaBolk   Removed call to public cursor get_attributes in New_Template___ and used a local cursor instead.
--  ------------------------------ 13.3.0 -------------------------------------
--  031118  JoAnSe   Reversed the previous correction in Check_Sourcing_Option___
--  031023  JOHESE   Changed checks in Check_Sourcing_Option___
--  031015  JoEd     Changed sourcing option validation for CTO parts.
--  031013  JoEd     Changed default value for sourcing option (from part wizard).
--  031013  PrJalk   Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  031010  DaZa     Added better error message in Check_Sourcing_Option___ for options that dont allow rules.
--  030922  PrTilk   Merged Bug 37447, Added the error message INVPARTEXISTS in Unpack_Check_Insert___ and Added the function Get_Catalog_Type_Db.
--  030911  UdGnlk   Modified Validate_Tax___ changing error messages tagging constant.
--  030901  NuFilk   CR Merge 02
--  030828  NaWalk   Performed Code Review.
--  **************************** CR Merge 02 ************************************
--  030819  SaNalk   Performed CR Merge.
--  030716  NaWalk   Removed Bug coments.
--  030516  DaZa     Changed view comments on RULE_ID to Sourcing Rule.
--  030514  DaZa     Added a validation and a info message in Update___ for special changes on sourcing_option.
--  030507  JoEd     Added public attributes SOURCING_OPTION and RULE_ID.
--                   Removed attributes sales_part_sourcing, purchase_flag and so_flag.
--                   Added package variable g_purchase_part_ to create purchase part on insert.
--                   Removed Check_So_Flag.
--  ************************* CR Merge *******************************************
--  030729  UsRalk   Merged SP4 changes to TAKEOFF code.
--  030718  JOHESE   Added function Is_Part_Used and changed Unpack_Check_Insert___
--  030613  SudWlk   Renamed LOV view, SALES_PART_REQ_EX_COMP_LOV to SALES_PART_EXCHANGE_COMP_LOV.
--  030611  SudWlk   Added new LOV view, SALES_PART_REQ_EX_COMP_LOV.
--  030522  ChFolk   Modified PROCEDUREs Prepare_Insert___ and New to add CONTRACT and CATALOG_TYPE_DB to the parameter attr.
--  030506  ChFolk   Call ID 96789. Modified the inconsistent error messages.
--  030505  ChFolk   Call ID 96247. Modified method Validate_Tax___. Used method Get_Order_Fee_Rate instead of Get_Fee_Rate.
--  030331  JaJaLk   Modified the db values for tax_regime_db_ according to the Invoice Tax_Regime_API.
--  030324  GaSolk   Modified Validate_Tax___ according to the changes in the Invoice.
--  030319  SaAblk   Add new public method Get_Characteristics
--  030317  SaAblk   Made Note_Text a public attribute.
--  030311  GaSolk   Modified the Proc: Validate_Tax___.
--  030311  ThPalk   Bug 36231, Removed the correction done for the bug 32213.
--  030310  GaSolk   Added the method Validate_Tax___ and called it in the
--                   Proc: Unpack_Check_Insert___ and Unpack_Check_Update___.Also
--                   removed the old Tax/Vat checks in those methods. Also modified Proc: Prepare_Insert___.
--  030206  WaJalk   Bug 35246, Added Method Modify to update Customs Stat Number in sales part with inventory part's Customs Stat Number.
--  021217  GeKaLk   Merged bug fixes in 2002-3 SP3.
--  021123  NuFilk   Bug 34278, Added Method Get_Commission_Catalog_Desc to get Sales Part Description for Commission Agree Line.
--  021122  MiKulk   Bug 33019, Remove the earlier corrections
--  021120  DayJlk   Bug 34169, Modified LOV view SALES_PART_LOV2 to contain more columns.
--  021118  MiKulk   Bug 33019, Added the procedure Check_For_Usage and modified the procedure Update__ to give relevent error messages.
--  021106  MiKulk   Bug 33748, Modified the method Unpack_Check_Insert___ to make restrictions on connecting configurable sales part with inventory part.
--  021106           Added two methods Get_Purch_No_For_Catalog_No and Get_Catalog_Type to implement the same functionality.
--  021022  NaWalk   Bug 33160, Added LOV SALES_PART_LOV2.
--  021011  Jejalk   Call ID 89535, add condition to the SALES_PART_SERVICE_LOV view,to get user allowed sites.
--  020919  JoAnSe   Merged the IceAge bugg corrections below onto the AD 2002-3 track.
--  020826  RuRalk   Bug 32213, Modified unpack_check_update___ to update the gross weight when net weight is updated for a non-inventory part.
--  020815  MaGu     Bug 30882. Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___.
--  020815           Removed check on net weight when customs stat no unit of measure is used.
--  020813  KiSalk   Bug 22276, Added view 'SALES_PART_FOR_PRICE_LIST_LOV'
--  020528  ROALUS   Bug fix 29505, Update__ changes restored.
--  020515  ROALUS   Bug fix 29505, Update__ and Unpack_Check_Update__ modified to allow update of 'N' parts
--  ---------------------------------- IceAge Merge End ------------------------------------
--  020625  SiJono   Added view SALES_PART_ALTERNATE_LOV.
--  -------------------------------- AD 2002-3 Baseline ------------------------------------
--  020226  CaStse   Bug 26786, Added check that list_price >= 0 in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  020213  JICE     Sending catalog_no instead of part_no to Sales Configurator.
--  020109  CaRa     Bug Fix 26698, Add check of Part Type when MRP code N.
--  010914  Samnlk   Bug Fix 24228 ,Rename the method Exits_Purch_Part to Exist_Purch_Part
--  010809  RoAnse   Bug fix 23529, Added new function Get_Catalog_No_For_Purch_No.
--  010625  Samnlk   Bug Fix 21302,Add a new method(Exits_Purch_Part) to get no of purchase parts for perticular Sales part.
--  010529  JSAnse   Bug Fix 21463, Added call to General_SYS.Init_Method in procedures Remove_Part__ and Catalog_No_Exist.
--  010413  JaBa     Bug Fix 20598, Added new global lu constants to check the logical unit installed.
--  010305  RoAnse   Bug fix 20472, Added 'AND sp2.contract = User_Allowed_Site_API.Authorized(sp2.contract))'
--                   in the second sub-query in the definition of the view SALES_PART_COM_LOV.
--  010214  MaGu     Bug fux 19177. Made attribute customs_stat_no public.
--  010129  MaGu     Bug fix 19177. Added value for non_inv_part_type in Prepare_Insert___ and
--                   Unpack_Check_Insert___. Added check on customs_stat_no in Unpack_Check_Insert___ and
--                   Unpack_Check_Update___.
--  010126  MaGu     Bug fix 19177. Added new attributes non_inv_part_type and intrastat_conv_factor.
--  001207  JoAn     CID 57485 Added check for sales part to Part_Configurable_At_Any_Site
--  001116  JoAn     Changed the logic for export of sales parts to XMS.
--                   Parts are exported when the part catalog part is configurable.
--                   Synchronisation only made in Insert___.
--  001109  CaRa     Replaced catalog_no with part_no in call to Part_Catalog_API.Check_Part_Exists
--                   and Part_Catalog_API.Get_Configurable_Db. In Unpack_Check_Insert___ and
--                   Unpack_Check_Update___.
--  001031  JoEd     Added NOCHECK flag on cust_warranty_id.
--  001026  JoEd     Added public attribute CUST_WARRANTY_ID.
--  001013  JoAn     Added Part_Configurable_At_Any_Site
--  001005  JoEd     Bug fix 17605. Added info message TAXNOTALLOWED in
--                   Unpack_Check_Insert___ and Unpack_Check_Update___.
--  000913  FBen     Added UNDEFINED.
--  000901  CaRa     Removed handling of configurable from procedure New_Inventory_Part___.
--  000727  JakH     Changed call for exist check of Configuration flag to call Part_Configuration_API
--  000628  LIN      Chameleon - Added function Check_Configs_On_Sites
--  000627  LIN      Chameleon - Added functions Get_Configurable/Get_Configurable_DB
--  000522  JakH     Chameleon - Added Exception handlers for dynamic calls.
--  000522  PhDe     Chameleon - In Insert___ and Update___, added dynamic
--                   call to Xms_Interface_API.Sync_Xms_Part when sales part
--                   is set to configured.
--  000519  BjSa     Chameleon - Added Catalog_No_Exist
--  000511  BjSa     Chameleon - Changed view SALES_PART_COM_LOV
--  000508  ThIs     Chameleon - Added view SALES_PART_COM_LOV
--  000710  JakH     Merged from Chameleon
--  ------------------------------ 13.0 -------------------------------------
--  000606  DaZa     Added method Modify_List_Price.
--  000508  DaZa     Added public method Check_Exist.
--  000503  DaZa     Added public new method.
--  000426  PaLj     Changed check for installed logical units. A check is made when API is instantiatet.
--                   See beginning of api-file.
--  000308  DaZa     Made Create_Sm_Object_Flag insertable again.
--  000302  SaMi     Aquisition changed to Acquisition in comments
--  000222  JakH     Made Create_Sm_Object_Flag not insertable, it's however still a NOT NULL Column.
--  000214  JoEd     Changed fetch of "VAT usage" from Company. Added error message NOTAXINFO.
--  000131  JoEd     Changed taxable vs fee code check once more.
--  000127  JoEd     Added method Get_Taxable_Db.
--                   Changed the taxable-fee_code check.
--  000125  JoEd     Added extra check on taxable and fee_code - depending on the
--                   site's company settings.
--                   Removed mandatory flag from fee_code.
--  000125  MaGu     Modified Check_If_Valid_Component, changed from function to procedure. Added check for
--                   replacement parts.
--  000117  MaGu     Modified New_Inventory_Part___. Removed parameters in call to Inventory_Part_API.New_Part
--                   according to changes in Inventory.
--  000117  JoEd     Added Get_Ean_No. Added default values to fields in Insert___
--                   that are getting default values in Prepare_Insert___.
--  000113  MaGu     Added check on replacement_part_no and date_of_replacement in unpack_check_insert___ and unpack_check_update___.
--  000112  MaGu     Added public attributes replacement_part_no and date_of_replacement.
--  991215  SaMi     SALES_PART_BPRICE_ALLOWED_LOV added. It shows all sales parts which allowes for a user
--                   Uses for updating base price list
--  ------------------------------ 12.0 -------------------------------------
--  991105  sami     when purchase_flag = 'N' sales_part_sourcing can only be 'NOT SOURCED'. Changes in
--                   Unpack_check_insert and Unpack_check_update
--  991029  JoEd     Changed check on purchase_flag and so_flag in Insert___ and Update___.
--  991019  JoAn     Changed Get_Default_Supply_Code, added new parameter
--                   enable sourcing.
--  991018  JoEd     Changed check on purchase_flag for inventory sales parts in Update___.
--  991016  JoAn     Purchase part no initialized set NULL for DOP parts in
--                   Unpack_Check_Insert___.
--  991007  JoEd     Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  991007  JoEd     Call Id 21210: Corrected double-byte problems.
--  991006  JoEd     Changed call to Exist_Purchase_Part___ on Insert to avoid
--                   error when creating inventory sales parts.
--  990930  JoEd     Added assign of so_flag and purchase_flag for non-inventory part.
--  990928  JoEd     Enabled configuration column for package parts.
--  990920  JoEd     Added purchase_part_no.
--  990906  JoAn     Added new attribute expected_average_price.
--  990823  sami     Sales_Part_Sourcing for choosing supply_code is added to
--                   the if statement. If sales_part_sourcing != 'NOT SOURCED'
--                   supply_code = 'ND'.
--  990820  sami     'NOT SOURCED' is added to Unpack_Check_Insert___.
--                   This value is insert's to any salespart as default value.
--  990819  sami     Added SalesPartSourcing to the Prepare_Insert___ 'NOT SOURCED'
--                   is default value in client. Sales_Part_sourcing added to view.
--  ------------------------------ 11.1 -------------------------------------
--  990528  PaLj     CID 18763. Added VIEW5 = SALES_PRICE_LIST_REP
--  990527  JoEd     Changed error message MRP_ORDER_CODE_OTK to work with Localize.
--  990510  RaKU     Replaced Inventory_Part_Cost_API.Get_Total_Standard with
--                   Inventory_Part_API.Get_Inventory_Value_By_Method.
--  990510  RaKu     Removed CURRENCY_CODE from Prepare_Insert___.
--  990421  RaKu     Y.Bug fixes.
--  990419  RaKu     Y.Cleanup.
--  990408  RaKu     Changed to new templates.
--  990406  JakH     Y.CID 10582 Removed use of Gen_Def_Key_value. use '*' where possible.
--  990401  RaKu     Changes made in Get_Totals__. Added price_conv_factor in cursor.
--  990331  RaKu     Changed language-constant in Check_Conv_Factor_On_Sites___.
--  990329  RaKu     Changed conv_factor in Get_Totals__.
--  990317  RaKu     Changed in Get_Totals__.
--  990316  JakH     CID 11344 Added checks for negative warranty.
--  990310  RaKu     Added column ean_no.
--  990303  RaKu     Added procedure Check_Conv_Factor_On_Sites___.
--  990219  JoAn     Extended lenght of planner_buyer variable in New_Inventory_Part___
--  990205  JoAn     Using new method Inventory_Part_Status_Par_API.Get_Demand_Flag_Db
--                   instead of Get_Demand_Flag.
--  990201  JakH     Cleaned up interface for using characteristic templates
--  990201  JoAn     Removed call to Inventory_Part_Obsolete_API when creating new
--                   inventory part.
--  990129  JoAn     Added Get_No_Of_Sales_Parts_For_Part.
--  990118  PaLj     Changed sysdate to Site_API.Get_Site_Date(contract)
--  990108  JakH     Added Warranty days and CreateSmObjectOption
--  990105  JoEd     Added DOP check in Get_Default_Supply_Code.
--                   Added DOP check on purchase_flag and so_flag in Unpack_Check_....
--  981221  JoAn     Added missing parameter in call to New_Inventory_Part.
--  981216  JoAn     Added Get_Default_Supply_Code
--  981211  JICE     Added public attribute Configuration and related methods.
--  981207  JoEd     Changed qty_... column comments.
--  981117  JoEd     SID 6224: Added check on inventory part's part_status when
--                   creating inventory based sales part.
--                   Removed check on inactive_obs_flag when setting value on activeind (SID 5917).
--                   Use part_status instead - check on part_status's demand_flag.
--  981109  RaKu     Added procedure Check_Unit_Meas_On_Sites___.
--  981106  RaKu     Added price group checks on Unpack_Check_Insert___/Update___.
--  981102  RaKu     Removed obsolete function Get_Buy_Qty_Price, Count_Records_In_Price_List
--                   and Adjust_Price_List.
--  981023  CAST     Default value for CLOSE_TOLERANCE = 0.
--  981021  RaKu     Added SALES_PRICE_GROUP_ID.
--  981014  JoEd     Removed serial_flag and lot_batch_flag from call to Inventory_Part_API.New_Part.
--  981012  CAST     New column CLOSE_TOLERANCE in SALES_PART_TAB.
--  981005  JoAn     Replaced Sales_Part_Create_Po_API.Get_Client_Value calls with
--                   Sales_Part_Create_Po_API.Encode. Change needed because new IID
--                   values have been inserted.
--  980922  JoEd     Support id 5917 - check inactive obs flag when creating and
--                   updating sales part that are connected to inventory parts.
--  980922  JoEd     Support id 4880 - rewrote cursor get_inventory_sum in method Get_Totals__.
--  980818  JOHW     Changed Inventory_Part_API.Get_Mrp_Order_Code to Inventory_Part_Planning_API.Get...
--  980807  ANHO     Removed some parameters in call to Inventory_Part_API.New_Part in New_Inventory_Part___.
--  980626  FRDI     Changed modle so sales_part is an assosiation between Site &
--                   PartCa. Since Part catalog is created in Insert___ some checks
--                   are comented out in Unpack_Check_Insert___.
--  980611  FRDI     Added inserttion of part_no & catalog_no into Part_catalog, this is done in Insert___
--                   & change call to Purchase_part_api.new() due to reconstruction.
--  980527  JOHW     Removed uppercase on COMMENT ON COLUMN &VIEW..catalog_desc,
--                   COMMENT ON COLUMN &VIEW2..catalog_desc, COMMENT ON COLUMN &VIEW3..catalog_desc and
--                   COMMENT ON COLUMN &VIEW4..catalog_desc
--  980423  RaKu     Added check for conv_factor and price_conv_factor
--                   so less or equal to zero is not allowed.
--  980421  JoAn     Added view SALES_PART_SERVICE_LOV used by maintenance.
--  980413  RaKu     Added view SALES_PART_ACTIVE_LOV.
--  980310  DaZa     Support Id 777. Added automatic calculation of weight_gross in
--                   Unpack_Check_Insert__ and Unpack_Check_Update__.
--  980227  MNYS     Support Id 623. Added LOV-flag for List_Price in view SALES_PART.
--  980217  MNYS     Bugfix 3011 - Added check for updating acquisition codes in unpack_check_update.
--  980224  ToOs     Corrected roundings
--  980211  ToOs     Changed hardcoded roundings to get_currency_rounding
--  980210  ToOs     Changed format on amount columns
--  980210  RaKu     Removed LOV-flag from Taxable.
--  980113  DaZa     Added new attribute Proposed_Parcel_Qty.
--  971201  RaKu     BUGID-2363. Changed procedure Get_Totals__.Parameterns in call to
--                   Inventory_Part_Cost_API.Get_Total_Standard was incorrect.
--  971125  RaKu     Changed to FND200 Templates.
--  971104  RoNi     note_id.nextval changed to Document_Text_API.Get_Next_Note_Id
--  971031  RaKu     Changed Get_Totals__. Added so marg_rate_ initiated to 0.
--  971029  RaKu     Changed in prepare_insert___ so fee_code is only returned when NOT NULL.
--  971023  RaKu     Added CURRENCY_CODE in Prepare_Insert___.
--  971014  RoNi     unit_meas_ changed to VARCHAR2(10)
--  970916  JoAn     Corrected parameter value for supply_code in call
--                   to Inventory_Part_API.New_Part
--  970908  MAJE     Changed unit of measure references to 10 character,
--                   mixed case, IsoUnit ref
--  970904  JoAn     Added new attribute taxable used to indicate if sales tax
--                   should be applied for a part or not.
--  970612  JoEd     Added check on mrp_code S.
--  970604  JoEd     Moved check on catalog_type to Prepare_Insert___ for so_flag
--                   and purchase_flag.
--  970603  RaKu     Added check for packages in Unpack_Check_Insert__ to set
--                   the so-flag and po-flag right.
--  970603  JoEd     Call Remove_Characteristics when emptying eng_attribute field
--                   on insert and update.
--                   Changed default values on purchase_flag and so_flag.
--  970521  JoEd     Added exist check before creating new Part Catalog
--                   Changed structure of Get_... methods
--  970520  JoEd     Rebuild Get_.. methods calling Get_Instance___.
--                   Added .._db columns in the view for all IID columns.
--  970520  JoEd     Added an NVL on part description when creating new inventory part
--  970519  FRMA/P   ELA Replaced Part_Ledger with Part_Catalog.
--  970516  PEKR     Changed interface to Inventory_Part_API.New_Part.
--  970507  JoEd     Removed dummy curr_code from LU.
--                   Changed vat_code to fee_code. Added dummy column COMPANY for
--                   LOV on fee code.
--  970506  JoEd     Removed part_description and unit_meas from the view, but
--                   not from the Unpack... methods and the Insert___ method.
--                   Handled as dummy columns for insert of a non-existing inventory part.
--                   Column unit_meas has the flags 'AMI--' set in the client form.
--  970430  JoAn     Added check for parts with mrp code N on insert and update.
--  970327  RaKu     Added function Get_Package_Weight and Get_Package_Type.
--  970312  JoEd     Changed table name.
--  970306  JoEd     Changed Sales_Part_Type_Lov_API to Sales_Part_Type_API.
--  970218  JoEd     Changed objversion.
--  960216  JoEd     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_                 CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;

db_false_                CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Sm_Not_Allowed_Error___
IS
BEGIN   
   Error_SYS.Record_General(lu_name_, 'SM_NOT_ALLOWED: The Create SM Object Option can not be set on an item without serial tracking');
END Raise_Sm_Not_Allowed_Error___;

PROCEDURE Raise_Conv_Factor_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'INVPARTCONVFONE: Conversion factor should be equal to 1 when the Inventory Part is connected to an Input UoM Group.');
END Raise_Conv_Factor_Error___;   

PROCEDURE Raise_Cc_Source_Opt_Error___ (
   automatic_cc_db_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'INVPARTACCYES: Sourcing Option must be set to DOP Order or Shop Order if Automatic Capability Check on inventory part is ":P1".',Capability_Check_Allocate_API.Decode(automatic_cc_db_));
END Raise_Cc_Source_Opt_Error___;
   
   

-- New_Inventory_Part___
--   Make an insert of an inventory part into the Part_Description
--   LU, when the part doesn't exist.
PROCEDURE New_Inventory_Part___ (
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   description_            IN VARCHAR2,
   unit_meas_              IN VARCHAR2,
   create_purchase_part_   IN VARCHAR2,
   statistical_code_       IN VARCHAR2,
   acquisition_origin_     IN NUMBER,
   acquisition_reason_id_  IN VARCHAR2)
IS
   asset_class_          VARCHAR2(2);
   planner_buyer_        VARCHAR2(20);
   type_code_            VARCHAR2(20);
   lead_time_code_       VARCHAR2(20);
   nulln_                NUMBER;
   nullc_                VARCHAR2(1);
   asterisk_             VARCHAR2(1) := '*';
   site_date_            DATE;   
BEGIN

   asset_class_ := Mpccom_Defaults_API.Get_Char_Value(asterisk_, 'PART_DESCRIPTION', 'ASSET_CLASS');

   planner_buyer_ := User_Default_API.Get_Planner_Id(Fnd_Session_API.Get_Fnd_User);

   IF (planner_buyer_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NODEFAULTPLANNER: A Default Planner for the user must be specified');
   END IF;

   IF create_purchase_part_ = Fnd_Boolean_API.DB_TRUE THEN
      type_code_ := '4';
      lead_time_code_ := 'P';      
   ELSE
      type_code_ := '1';
      lead_time_code_ := 'M';      
   END IF;

   site_date_ := TRUNC(Site_API.Get_Site_Date(contract_));
   -- gelr: good_service_statistical_code, acquisition_origin and  brazilian_specific_attributes added.
   Inventory_Part_API.New_Part(contract_                  => contract_,
                               part_no_                   => part_no_,
                               accounting_group_          => nullc_,
                               asset_class_               => Mpccom_Defaults_API.Get_Char_Value(asterisk_, 'PART_DESCRIPTION', 'ASSET_CLASS'),
                               country_of_origin_         => nullc_,
                               hazard_code_               => nullc_,
                               part_product_code_         => nullc_,
                               part_product_family_       => nullc_,
                               part_status_               => nullc_,
                               planner_buyer_             => planner_buyer_,
                               prime_commodity_           => nullc_,
                               second_commodity_          => nullc_,
                               unit_meas_                 => unit_meas_,
                               description_               => description_,
                               abc_class_                 => NULL,
                               count_variance_            => 0,
                               create_date_               => site_date_,
                               cycle_code_                => Inventory_Part_Count_Type_API.Decode('N'),
                               cycle_period_              => 0,
                               dim_quality_               => nullc_,
                               durability_day_            => nulln_,
                               expected_leadtime_         => 0,
                               inactive_obs_flag_         => nullc_,
                               last_activity_date_        => site_date_,
                               lead_time_code_            => Inv_Part_Lead_Time_Code_API.Decode(lead_time_code_),
                               manuf_leadtime_            => 0,
                               note_text_                 => nullc_,
                               oe_alloc_assign_flag_      => Asset_Class_API.Get_Oe_Alloc_Assign_Flag(asset_class_),
                               onhand_analysis_flag_      => Asset_Class_API.Get_Onhand_Analysis_Flag(asset_class_),
                               purch_leadtime_            => 0,
                               supersedes_                => nullc_,
                               supply_code_               => Material_Requis_Supply_API.Decode('IO'),
                               type_code_                 => Inventory_Part_Type_API.Decode(type_code_),
                               customs_stat_no_           => nullc_,
                               type_designation_          => nullc_,
                               zero_cost_flag_            => Inventory_Part_Zero_Cost_API.Decode('N'),
                               avail_activity_status_     => nullc_,
                               eng_attribute_             => nullc_,
                               forecast_consumption_flag_ => nullc_,
                               create_purchase_part_      => create_purchase_part_,
                               input_unit_meas_group_id_  => Part_Catalog_API.Get_Input_Unit_Meas_Group_Id(part_no_),
                               statistical_code_          => statistical_code_,
                               acquisition_origin_        => acquisition_origin_,
                               acquisition_reason_id_     => acquisition_reason_id_);
                             
END New_Inventory_Part___;


-- Check_Configs_On_Sites___
--   Generates an error if part_no of catalog_no is configurable
--   in part catalog and used on another site with different part_no
PROCEDURE Check_Configs_On_Sites___ (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2,
   part_no_    IN VARCHAR2 )
IS
   inventory_part_   SALES_PART_TAB.part_no%TYPE;
   other_contract_   SALES_PART_TAB.contract%TYPE;

   CURSOR find_conf_on_other_sites IS
      SELECT contract, part_no
      FROM   SALES_PART_TAB
      WHERE  contract != contract_
      AND    catalog_no = catalog_no_
      AND    part_no != part_no_;
BEGIN
   IF (part_no_ IS NOT NULL) THEN
      IF (Part_Catalog_API.Get_Configurable_Db(part_no_) = 'CONFIGURED') THEN
         OPEN  find_conf_on_other_sites;
         FETCH find_conf_on_other_sites INTO other_contract_, inventory_part_;
         IF (find_conf_on_other_sites%FOUND) THEN
            CLOSE find_conf_on_other_sites;
            Error_SYS.Record_General(lu_name_,
            'MULTI_SITE_CONFIG: The sales part [:P1] is already connected to the inventory part [:P2] on site [:P3].', catalog_no_, inventory_part_, other_contract_);
         ELSE
            CLOSE find_conf_on_other_sites;
         END IF;
      END IF;
   END IF;
END Check_Configs_On_Sites___;


-- Check_Unit_Meas_On_Sites___
--   Generates an error if catalog_no is used on another site with  the same
--   SalesPriceGroupId but different UnitMeas.
PROCEDURE Check_Unit_Meas_On_Sites___ (
   contract_             IN VARCHAR2,
   catalog_no_           IN VARCHAR2,
   sales_price_group_id_ IN VARCHAR2,
   price_unit_meas_      IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR find_diff_on_other_sites IS
      SELECT 1
      FROM   SALES_PART_TAB
      WHERE  contract != contract_
      AND    catalog_no = catalog_no_
      AND    sales_price_group_id = sales_price_group_id_
      AND    price_unit_meas != price_unit_meas_;
BEGIN
   OPEN  find_diff_on_other_sites;
   FETCH find_diff_on_other_sites INTO dummy_;
   IF (find_diff_on_other_sites%FOUND) THEN
      CLOSE find_diff_on_other_sites;
      Error_SYS.Record_General(lu_name_,
         'MULTI_SITE_CATALOG1: Sales part :P1 with price group :P2 is defined on other site(s) and must have the same price U/M. Price group must be changed to update price U/M.', catalog_no_, sales_price_group_id_);
      END IF;
   CLOSE find_diff_on_other_sites;
END Check_Unit_Meas_On_Sites___;


-- Check_Conv_Factor_On_Sites___
--   Generates an error if catalog_no is used on another site with  the same
--   SalesPriceGroupId but different ConvFactor.
PROCEDURE Check_Conv_Factor_On_Sites___ (
   contract_             IN VARCHAR2,
   catalog_no_           IN VARCHAR2,
   sales_price_group_id_ IN VARCHAR2,
   price_conv_factor_    IN NUMBER )
IS
   dummy_ NUMBER;
   CURSOR find_diff_on_other_sites IS
      SELECT 1
      FROM   SALES_PART_TAB
      WHERE  contract != contract_
      AND    catalog_no = catalog_no_
      AND    sales_price_group_id = sales_price_group_id_
      AND    price_conv_factor != price_conv_factor_;
BEGIN
   OPEN  find_diff_on_other_sites;
   FETCH find_diff_on_other_sites INTO dummy_;
   IF (find_diff_on_other_sites%FOUND) THEN
      CLOSE find_diff_on_other_sites;
      Error_SYS.Record_General(lu_name_,
         'MULTI_SITE_CATALOG2: Sales part :P1 with price group :P2 is defined on other site(s) and must have the same price converion factor.', catalog_no_, sales_price_group_id_);
   ELSE
      CLOSE find_diff_on_other_sites;
   END IF;
END Check_Conv_Factor_On_Sites___;


-- Exist_Purchase_Part___
--   Dynamic Exist call to PurchasePart LU.
--   If inventory_part flag is FALSE, and extended check is made ->
--   the purchase part number has to be a non-inventory part.
PROCEDURE Exist_Purchase_Part___ (
   contract_         IN VARCHAR2,
   purchase_part_no_ IN VARCHAR2,
   inventory_part_   IN BOOLEAN DEFAULT TRUE )
IS   
   found_ NUMBER := 0;
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      Purchase_Part_API.Exist(contract_, purchase_part_no_, Acquisition_Type_API.DB_PURCHASE_AND_RENTAL_ONLY);
      IF NOT inventory_part_ THEN
         found_ := Purchase_Part_API.Is_Inventory_Part(contract_, purchase_part_no_);
         IF (found_ = 1) THEN
            Error_SYS.Record_General(lu_name_, 'INVPURPART: The purchase part :P1 is an inventory part. Not allowed for non-inventory sales parts!', purchase_part_no_);
         END IF;
      END IF;
   $ELSE
      NULL;   
   $END
END Exist_Purchase_Part___;


-- Check_Sourcing_Option___
--   Checks allowed sourcing option combinations.
PROCEDURE Check_Sourcing_Option___ (
   newrec_ IN SALES_PART_TAB%ROWTYPE,
   attr_   IN VARCHAR2 )
IS
   found_                        NUMBER := 1;
   is_prod_line_part_            NUMBER;
   automatic_capability_check_   VARCHAR2(50);
   inv_part_planning_rec_        Inventory_Part_Planning_API.Public_Rec;
BEGIN
   inv_part_planning_rec_ := Inventory_Part_Planning_API.Get(newrec_.contract, newrec_.part_no);

   -- Only sourcing options Invent Order and DOP Order are allowed for DOP parts.
   IF (nvl(inv_part_planning_rec_.order_requisition, '*') = 'D') THEN
      IF (newrec_.sourcing_option NOT IN ('INVENTORYORDER', 'DOPORDER', 'PRIMARYSUPPTRANSIT', 'PRIMARYSUPPDIRECT')) THEN
         Error_SYS.Record_General(lu_name_, 'DOPINVENTORDERONLY: Only sourcing options "Inventory Order", "DOP Order", "Primary Supplier Transit" and "Primary Supplier Direct" are valid for DOP parts.');
      END IF;
   END IF;

   -- Inventory Order or Production Schedule is not allowed for configured parts regardless the part type is DOP-Part or not.
   IF (newrec_.sourcing_option IN ('INVENTORYORDER', 'PRODUCTIONSCHEDULE')) THEN
      IF (Get_Configurable_Db(newrec_.contract, NVL( newrec_.part_no, newrec_.catalog_no)) = 'CONFIGURED') THEN
         Error_SYS.Record_General(lu_name_, 'CTOPARTERRORNEW: Sourcing option ":P1" is not valid for configured parts.', Sourcing_Option_API.Decode(newrec_.sourcing_option));
      END IF;
   END IF;

   -- check for invalid combination...
   IF (((newrec_.catalog_type = 'INV') AND (newrec_.sourcing_option = 'NOTSUPPLIED')) OR
       ((newrec_.catalog_type = 'NON') AND (newrec_.sourcing_option IN ('INVENTORYORDER', 'SHOPORDER', 'DOPORDER', 'PRODUCTIONSCHEDULE')) OR
       ((newrec_.catalog_type = 'PKG') AND (newrec_.sourcing_option != 'NOTSUPPLIED')))) THEN
      Error_SYS.Record_General(lu_name_, 'PARTTYPEERROR: Sourcing option ":P1" is not valid for type ":P2".',
                               Sourcing_Option_API.Decode(newrec_.sourcing_option), Sales_Part_Type_API.Decode(newrec_.catalog_type));
   -- Rule ID is mandatory for Use Sourcing Rule
   ELSIF (newrec_.sourcing_option = 'USESOURCINGRULE') THEN
      Error_SYS.Check_Not_Null(lu_name_, 'RULE_ID', newrec_.rule_id);
   -- Rule ID can be entered if Not Decided. Not mandatory.
   -- For all other sourcing options the rule ID is not insertable.
   ELSIF (newrec_.sourcing_option != 'NOTDECIDED') AND (newrec_.rule_id IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'RULENOTVALIDFOROPT: Sourcing rules are not allowed for sourcing option ":P1".',
                               Sourcing_Option_API.Decode(newrec_.sourcing_option));
   ELSIF (newrec_.sourcing_option IN ('PRIMARYSUPPTRANSIT', 'PRIMARYSUPPDIRECT')) THEN
      -- if purchase part is created (insert mode) there's no need to check if it exists
      -- for update mode we don't create a new part - and we have to do a check!    
      $IF (Component_Purch_SYS.INSTALLED) $THEN      
         IF (Client_SYS.Get_Item_Value('CREATE_PURCHASE_PART', attr_) = Fnd_Boolean_API.DB_FALSE) THEN        
            found_ := Purchase_Part_API.Check_Exist(newrec_.contract, NVL(newrec_.part_no, newrec_.purchase_part_no)); 
         IF (found_ = 0) THEN
            Error_SYS.Record_General(lu_name_, 'ASSOCIATEPURCHPART: There should be an associated Purchase Part for sourcing option ":P1".',
                             Sourcing_Option_API.Decode(newrec_.sourcing_option));
         END IF;
      END IF;
      $ELSE
         NULL;
      $END
   ELSIF (newrec_.sourcing_option = 'DOPORDER') THEN
      IF (inv_part_planning_rec_.planning_method = 'N') THEN
          Error_SYS.Record_General(lu_name_, 'MRPCODEPNNOTALLOWED: Associated Inventory Part cannot have MRP order code ":P1" when using sourcing option ":P2".',
                          inv_part_planning_rec_.planning_method, Sourcing_Option_API.Decode(newrec_.sourcing_option));
      END IF;
   END IF;

   -- Production Schedule Check
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      IF newrec_.sourcing_option = 'PRODUCTIONSCHEDULE' THEN
         IF (Production_Line_Part_API.Is_Production_Line_Part(newrec_.contract, newrec_.catalog_no)) THEN
            is_prod_line_part_ := 1;
                         ELSE
            is_prod_line_part_ := 0;
         END IF;                
         IF( is_prod_line_part_ = 0) THEN
            Error_SYS.Record_General(lu_name_, 'NOTEXISTINPRODLINE: Sourcing option ":P1" is only allowed for parts that exist as a production line part for at least one production line.',
                               Sourcing_Option_API.Decode(newrec_.sourcing_option));
         END IF;
      END IF;
   $END
   
   IF (newrec_.sourcing_option = 'SHOPORDER') THEN
      automatic_capability_check_ := Inventory_Part_API.Get_Automatic_Capability_Ch_Db(newrec_.contract, newrec_.catalog_no);
      IF automatic_capability_check_ = 'RESERVE AND ALLOCATE' THEN
         Error_SYS.Record_General(lu_name_, 'SOANDAOINVALID: Sourcing Option cannot be set to ":P1" if Capability Check on connected inventory part is set to ":P2".',
                                 Sourcing_Option_API.Decode(newrec_.sourcing_option),
                                 Capability_Check_Allocate_API.Decode(automatic_capability_check_));         
      END IF;
   END IF;

END Check_Sourcing_Option___;


-- Check_Catch_Unit___
--   Fetch the catch unit code from part catalog if catch unit is enabled and
--   compare it with the price unit of measure to give an error message if
--   catch unit code is not equal to price unit of measure.
PROCEDURE Check_Catch_Unit___ (
   newrec_ IN SALES_PART_TAB%ROWTYPE )
IS
   part_catalog_rec_ Part_Catalog_API.Public_Rec;
BEGIN
   part_catalog_rec_ := Part_Catalog_API.Get(newrec_.part_no);
   -- IF the part is a catch unit enabled part Price Unit of Meas. should equal to the Catch Unit of Meas.
   IF (part_catalog_rec_.catch_unit_enabled = db_true_) THEN
      IF (Inventory_Part_API.Get_Catch_Unit_Meas(newrec_.contract,newrec_.part_no) != newrec_.price_unit_meas) THEN
         Error_SYS.Record_General(lu_name_, 'CATCHPRICEUNIT: Price U/M should always equal to Catch UoM for catch unit enabled parts.');
      END IF;
   END IF;
END Check_Catch_Unit___;


PROCEDURE Check_If_Package_Part_Exist___ (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 )
IS
   found_              NUMBER;

   CURSOR exist_control IS
      SELECT 1
        FROM SALES_PART_PACKAGE_TAB
       WHERE contract   = contract_
         AND catalog_no = catalog_no_;

BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%FOUND) THEN
      Client_SYS.Add_Info(lu_name_, 'PARENTPARTEXIST: The sales part :P1 is used in one or more package parts.',catalog_no_);
   END IF;
   CLOSE exist_control;
END Check_If_Package_Part_Exist___;


-- Get_No_Of_Active_Sale_Parts___
--   Return the number of active sales parts connected to the specified inventory part.
FUNCTION Get_No_Of_Active_Sale_Parts___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   no_of_active_sales_parts_ NUMBER;

   CURSOR active_sales_parts IS
      SELECT COUNT(catalog_no)
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    activeind = 'Y';         
BEGIN   
   OPEN active_sales_parts;
   FETCH active_sales_parts INTO no_of_active_sales_parts_;   
   CLOSE active_sales_parts;
   RETURN no_of_active_sales_parts_;
END Get_No_Of_Active_Sale_Parts___;


-- Handle_Description_Change___
--   Refresh the Doc_Reference_Object_Tab when the sales part description is changed
PROCEDURE Handle_Description_Change___ (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 )
IS
   key_ref_    VARCHAR2(2000);   
   objid_      SALES_PART.objid%TYPE;
   objversion_ SALES_PART.objversion%TYPE;
BEGIN
   $IF (Component_Docman_SYS.INSTALLED) $THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, contract_, catalog_no_);
      Client_SYS.Get_Key_Reference(key_ref_, lu_name_, objid_);
      Doc_Reference_Object_API.Refresh_Object_Reference_Desc(lu_name_, key_ref_);
   $ELSE
      NULL;   
   $END
END Handle_Description_Change___;

PROCEDURE Create_Part___ ( 
   part_no_         IN VARCHAR2,
   description_     IN VARCHAR2,
   unit_code_       IN VARCHAR2,
   configurable_db_ IN VARCHAR2 )
IS
BEGIN
   IF NOT Part_Catalog_API.Check_Part_Exists(part_no_) THEN
      IF (NOT Security_SYS.Is_Proj_Entity_CUD_Available('PartHandling', 'PartCatalog')) THEN
         Error_SYS.Record_General(lu_name_, 'METHODNOTALLOWED: User does not have access rights to create a new part catalog record as per the security permissions.');
      END IF; 
      Part_Catalog_API.Create_Part(part_no_                  => part_no_, 
                                   description_              => description_, 
                                   unit_code_                => unit_code_,
                                   std_name_id_              => NULL, 
                                   info_text_                => NULL,
                                   part_main_group_          => NULL, 
                                   eng_serial_tracking_code_ => NULL, 
                                   serial_tracking_code_     => NULL,
                                   configurable_db_          => configurable_db_);                                   
   END IF;   
END Create_Part___;

-- Validate_Create_SM_Object___
--    When disabling receipt and issue serial tracking validate if Create SM Object option is
--    enabled for any sales part.
PROCEDURE Validate_Create_SM_Object___(
   part_no_                       IN VARCHAR2,
   receipt_issue_serial_track_db_ IN VARCHAR2)
IS
   
   CURSOR check_create_sm_object_opt IS
      SELECT 1
      FROM   SALES_PART_TAB
      WHERE  catalog_no = part_no_
      AND    create_sm_object_option = Create_Sm_Object_Option_API.DB_CREATE_SM_OBJECT;
   
   temp_   NUMBER;
BEGIN
   IF (receipt_issue_serial_track_db_ = db_false_) THEN
      OPEN check_create_sm_object_opt;
      FETCH check_create_sm_object_opt INTO temp_;
      CLOSE check_create_sm_object_opt;
      
      IF temp_ IS NOT NULL THEN
         Error_SYS.Record_General(lu_name_, 'CREATESMOBJSERIAL: The Create SM Object Option is only allowed for parts that are serial tracked at receipt and issue.');
      END IF;         
   END IF;

END Validate_Create_SM_Object___;

-- Validate_Sales_Type___
--   Check whether a part is defined as a sales only or not.
PROCEDURE Validate_Sales_Type___ (
   part_no_                       IN VARCHAR2,
   serial_tracking_code_db_       IN VARCHAR2,
   receipt_issue_serial_track_db_ IN VARCHAR2)
IS
   sales_type_db_  SALES_PART_TAB.sales_type%TYPE;   
   CURSOR get_sales_type IS
      SELECT sales_type
      FROM   SALES_PART_TAB
      WHERE  catalog_no = part_no_
      AND    sales_type IN (Sales_Type_API.DB_RENTAL_ONLY, 
                            Sales_Type_API.DB_SALES_AND_RENTAL)
      AND    catalog_type = 'INV';
BEGIN
   IF (serial_tracking_code_db_ = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING) AND
      (receipt_issue_serial_track_db_ = Fnd_Boolean_API.DB_TRUE) THEN
      OPEN get_sales_type;
      FETCH get_sales_type INTO sales_type_db_;
      IF (get_sales_type%FOUND) THEN
         CLOSE get_sales_type;
         Error_SYS.Record_General(lu_name_,'NOTALLOWRENTSALETYPEPART: You cannot remove serial-tracking in inventory for serial part :P1 with the sales type :P2.', part_no_, Sales_Type_API.Decode(sales_type_db_));
      END IF;
      CLOSE get_sales_type;
   END IF;
END Validate_Sales_Type___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   company_          VARCHAR2(20);
   contract_         SALES_PART_TAB.contract%TYPE;
   catalog_type_     SALES_PART_TAB.catalog_type%TYPE;
   tax_code_         SALES_PART_TAB.tax_code%TYPE;
   part_no_          SALES_PART_TAB.part_no%TYPE;
   catalog_no_       SALES_PART_TAB.catalog_no%TYPE;
   sourcing_option_  SALES_PART_TAB.sourcing_option%TYPE;
   taxable_db_       VARCHAR2(50);
BEGIN
   -- CATALOG_TYPE is set in the sales part clients' ...GetDefaults methods
   catalog_type_ := Client_SYS.Get_Item_Value('CATALOG_TYPE_DB', attr_);
   -- CONTRACT, PART_NO and CATALOG_NO are sent from the part wizard dialog when an Inventory Sales Part is created.
   -- use those to set a more correct SOURCING_OPTION default value
   contract_         := NVL(Client_SYS.Get_Item_Value('CONTRACT', attr_), User_Default_API.Get_Contract);
   part_no_          := Client_SYS.Get_Item_Value('PART_NO', attr_);
   catalog_no_       := Client_SYS.Get_Item_Value('CATALOG_NO', attr_);

   Trace_SYS.Field('catalog_type', catalog_type_);
   Trace_SYS.Field('contract', contract_);
   Trace_SYS.Field('catalog_no', catalog_no_);
   Trace_SYS.Field('part_no', part_no_);

   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('ACTIVEIND_DB', 'Y', attr_);
   Client_SYS.Add_To_Attr('CONV_FACTOR', 1, attr_);
   Client_SYS.Add_To_Attr('INVERTED_CONV_FACTOR', 1, attr_);
   Client_SYS.Add_To_Attr('PRICE_CONV_FACTOR', 1, attr_);
   Client_SYS.Add_To_Attr('CLOSE_TOLERANCE', 0, attr_);
   Client_SYS.Add_To_Attr('QUICK_REGISTERED_PART_DB', db_false_, attr_);
   Client_SYS.Add_To_Attr('ALLOW_PARTIAL_PKG_DELIV_DB', db_true_, attr_);
   Client_SYS.Add_To_Attr('SALES_TYPE', Sales_Type_API.Decode(Sales_Type_API.DB_SALES_ONLY), attr_);
   Client_SYS.Add_To_Attr('LIST_PRICE', 0, attr_);
   Client_SYS.Add_To_Attr('LIST_PRICE_INCL_TAX', 0, attr_);   
   Client_SYS.Add_To_Attr('RENTAL_LIST_PRICE', 0, attr_);
   Client_SYS.Add_To_Attr('RENTAL_LIST_PRICE_INCL_TAX', 0, attr_);
   IF (Client_SYS.Get_Item_Value('USE_PRICE_INCL_TAX_DB', attr_) IS NULL) THEN
      Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(contract_), attr_);
   END IF;
 
   IF (catalog_type_ = 'NON') THEN
      Client_SYS.Add_To_Attr('NON_INV_PART_TYPE', Non_Inventory_Part_Type_API.Decode('SERVICE'), attr_);
      Client_SYS.Add_To_Attr('COST', 0, attr_);
   ELSIF (catalog_type_ = 'INV') THEN      
      Client_SYS.Add_To_Attr('PRIMARY_CATALOG_DB', db_false_, attr_);      
   END IF;

   company_ := Site_API.Get_Company(contract_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);

   Tax_Handling_Order_Util_API.Get_Tax_Info_For_Sales_Object(tax_code_, taxable_db_, company_);
   IF (tax_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('TAX_CODE', tax_code_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('TAXABLE_DB', taxable_db_, attr_);

   Client_SYS.Add_To_Attr('CREATE_SM_OBJECT_OPTION_DB', 'DONOTCREATESMOBJECT', attr_);

   -- default sourcing option DOPORDER for DOP parts.
   IF (nvl(Inventory_Part_Planning_API.Get_Order_Requisition_Db(contract_, part_no_), '*') = 'D') THEN
      sourcing_option_ := 'DOPORDER';
   -- configured and not DOP
   ELSIF (nvl(Part_Catalog_API.Get_Configurable_Db(nvl(part_no_, catalog_no_)), ' ') = 'CONFIGURED') THEN
      sourcing_option_ := 'NOTDECIDED';
   -- inventory sales part
   ELSIF (catalog_type_ = 'INV') THEN
      sourcing_option_ := 'INVENTORYORDER';
   -- non-inventory sales part and package part
   ELSE
      sourcing_option_ := 'NOTSUPPLIED';
   END IF;
   Client_SYS.Add_To_Attr('SOURCING_OPTION', Sourcing_Option_API.Decode(sourcing_option_), attr_);
   Client_SYS.Add_To_Attr('EXPORT_TO_EXTERNAL_APP_DB', db_false_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SALES_PART_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   ptr_                 NUMBER;
   -- Temporary attribute string
   temp_                VARCHAR2(32000) := NULL;
   name_                VARCHAR2(30);
   value_               VARCHAR2(2000);
   part_status_         INVENTORY_PART.part_status%TYPE;
   part_exists_         BOOLEAN;   
   found_               NUMBER := 0;
   configurable_db_   VARCHAR2(20) := Part_Configuration_API.DB_NOT_CONFIGURED;
BEGIN
   newrec_.date_entered := nvl(newrec_.date_entered, trunc(Site_API.Get_Site_Date(newrec_.contract)));
   Client_SYS.Add_To_Attr('DATE_ENTERED', newrec_.date_entered, attr_);
   IF NOT (newrec_.part_no = newrec_.catalog_no) AND (newrec_.part_no IS NOT NULL) THEN
      IF Part_Catalog_API.Check_Part_Exists(newrec_.part_no) THEN
         configurable_db_ := Part_Catalog_API.Get_Configurable_Db(newrec_.part_no);
      END IF;
   END IF;
   
   Create_Part___(newrec_.catalog_no, newrec_.catalog_desc, newrec_.sales_unit_meas, configurable_db_);

   IF NOT (newrec_.part_no = newrec_.catalog_no) THEN
      Create_Part___(newrec_.part_no, newrec_.catalog_desc, newrec_.price_unit_meas, configurable_db_);
      -- This is when a different Invent part create for a sales part.
      -- Invent part has a different partcat entry.
      -- Do not enter gtin for invent part.
   END IF;
   IF (newrec_.catalog_type = 'INV') THEN
      part_exists_ := Inventory_Part_API.Check_Exist(newrec_.contract, newrec_.part_no);
      -- fetch customer warranty ID...
      IF part_exists_ THEN
         -- ...from the inventory part
         newrec_.cust_warranty_id := Inventory_Part_API.Get_Cust_Warranty_Id(newrec_.contract, newrec_.part_no);
      ELSE
         -- ...from the part catalog
         newrec_.cust_warranty_id := Part_Catalog_API.Get_Cust_Warranty_Id(newrec_.part_no);
      END IF;
      
      -- Check if inventory part exists. Otherwise create it.
      IF NOT part_exists_ THEN
         
         -- Use the values in the attr string. They come from the Unpack_Check_Insert___ method
         -- gelr: good_service_statistical_code, acquisition_origin and  brazilian_specific_attributes added to New_Inventory_Part___ method         
         New_Inventory_Part___(newrec_.contract, newrec_.part_no,
         nvl(Client_SYS.Get_Item_Value('PART_DESCRIPTION', attr_), newrec_.catalog_desc),
         Client_SYS.Get_Item_Value('UNIT_MEAS', attr_), Client_SYS.Get_Item_Value('CREATE_PURCHASE_PART', attr_),
         newrec_.statistical_code, newrec_.acquisition_origin, newrec_.acquisition_reason_id);

      END IF;
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         found_ := Purchase_Part_API.Check_Exist(newrec_.contract, newrec_.part_no); 
         IF (found_ = 1) THEN
            newrec_.purchase_part_no := newrec_.part_no;
         END IF;
      $END
      -- IF sales part is active and inventory part isn't allowed to have demands - display error msg
      IF (newrec_.activeind = 'Y') THEN
         part_status_ := Inventory_Part_API.Get_Part_Status(newrec_.contract, newrec_.part_no);
         IF ((Inventory_Part_Status_Par_API.Get_Demand_Flag_Db(part_status_)) = 'N') THEN
            Client_SYS.Add_Info(lu_name_, 'DEMANDSNOTALLOWED: New demands are not allowed for inventory part :P1.', newrec_.part_no);
         END IF;
      END IF;
   ELSIF (newrec_.catalog_type = 'NON') THEN
      -- fetch customer warranty ID from the part catalog
      newrec_.cust_warranty_id := Part_Catalog_API.Get_Cust_Warranty_Id(newrec_.catalog_no);
   END IF;
   -- Tell the warranty that it's shared
   IF (newrec_.cust_warranty_id IS NOT NULL) THEN
      Cust_Warranty_API.Inherit(newrec_.cust_warranty_id);
      Client_SYS.Add_To_Attr('CUST_WARRANTY_ID', newrec_.cust_warranty_id, attr_);
   END IF;

   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
   -- Remove PART_DESCRIPTION and UNIT_MEAS from the attr string before returning to client
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ NOT IN ('PART_DESCRIPTION', 'UNIT_MEAS')) THEN
         Client_SYS.Add_To_Attr(name_, value_, temp_);
      END IF;
   END LOOP;
   attr_ := temp_;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SALES_PART_TAB%ROWTYPE,
   newrec_     IN OUT SALES_PART_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   part_status_       INVENTORY_PART.part_status%TYPE;

BEGIN

   IF (newrec_.catalog_type = 'INV') THEN
      -- IF sales part is active and inventory part isn't allowed to have demands - display error msg
      IF (oldrec_.activeind != newrec_.activeind AND newrec_.activeind = 'Y') THEN
         part_status_ := Inventory_Part_API.Get_Part_Status(newrec_.contract, newrec_.part_no);
         IF ((Inventory_Part_Status_Par_API.Get_Demand_Flag_Db(part_status_)) = 'N') THEN
            Client_SYS.Add_Info(lu_name_, 'DEMANDSNOTALLOWED: New demands are not allowed for inventory part :P1.', newrec_.part_no);
         END IF;
      END IF;
   END IF;

   -- add a warning if the sourcing option was changed from Not Decided/Use Sourcing Rule to
   -- Inventory Order/Not Supplied while there exist some sourcing rules on some customers/customer addresses
   IF (oldrec_.sourcing_option = 'NOTDECIDED' OR oldrec_.sourcing_option = 'USESOURCINGRULE') AND
    (newrec_.sourcing_option = 'INVENTORYORDER' OR newrec_.sourcing_option = 'SHOPORDER' OR newrec_.sourcing_option = 'NOTSUPPLIED') AND
    (Source_Rule_Per_Customer_API.Exist_Any_Rules_For_Sales_Part(newrec_.contract, newrec_.catalog_no) = 1 OR
    Source_Rule_Per_Cust_Addr_API.Exist_Any_Rules_For_Sales_Part(newrec_.contract, newrec_.catalog_no) = 1) THEN
      Client_SYS.Add_Info(lu_name_, 'CUST_RULE_EXIST: There are some sourcing rules in the Sourcing Rules for Customer and Sales Part window for sales part :P1 that are obsolete now when the sourcing option was changed to :P2.', newrec_.catalog_no, Sourcing_Option_API.Decode(newrec_.sourcing_option));
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   IF (newrec_.catalog_desc != oldrec_.catalog_desc) AND (Site_Discom_Info_API.Get_Use_Partca_Desc_Order_Db(newrec_.contract) = 'FALSE') THEN
      Handle_Description_Change___(newrec_.contract, newrec_.catalog_no);
   END IF;

   IF (NVL(newrec_.tax_code, Database_SYS.string_null_) != NVL(oldrec_.tax_code, Database_SYS.string_null_)) THEN
      Sales_Part_Base_Price_API.Modify_Prices_For_Tax(newrec_.contract, newrec_.catalog_no, newrec_.tax_code);
      Sales_Price_List_Part_API.Modify_Prices_For_Tax(newrec_.contract, newrec_.catalog_no, newrec_.tax_code);
      Agreement_Sales_Part_Deal_API.Modify_Prices_For_Tax(newrec_.contract, newrec_.catalog_no);
   END IF;

   IF ((NVL(newrec_.tax_code, Database_SYS.string_null_) != NVL(oldrec_.tax_code, Database_SYS.string_null_)) OR (newrec_.use_price_incl_tax != oldrec_.use_price_incl_tax)) THEN
      Characteristic_Base_Price_API.Modify_Fixed_Amt_For_Tax(newrec_.catalog_no, newrec_.contract, newrec_.use_price_incl_tax, newrec_.tax_code);
   END IF; 

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN SALES_PART_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   Commission_Agree_Line_API.Check_Sales_Part_Usage(remrec_.catalog_no);
   
   $IF (Component_Callc_SYS.INSTALLED) $THEN 
      Cc_Case_Business_Object_API.Check_Reference_Exist('SALES_PART', remrec_.catalog_no, remrec_.contract );
      Cc_Case_Sol_Business_Obj_API.Check_Reference_Exist('SALES_PART', remrec_.catalog_no, remrec_.contract );
   $END
   $IF (Component_Supkey_SYS.INSTALLED) $THEN
      Cc_Sup_Key_Business_Obj_API.Check_Reference_Exist('SALES_PART', remrec_.catalog_no, remrec_.contract );
   $END
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   tax_percentage_         NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   planning_method_        VARCHAR2(1);
   part_desc_              SALES_PART_TAB.catalog_desc%TYPE ;
   unit_meas_              VARCHAR2(10);
   sales_price_group_unit_ VARCHAR2(10);
   company_                VARCHAR2(20);   
   inventory_uom_group_    VARCHAR2(30);
   partca_uom_group_       VARCHAR2(30);
   automatic_cc_db_        VARCHAR2(50);   
   catalog_no_             SALES_PART_TAB.catalog_no%TYPE;
   lot_or_serial_tracked_  BOOLEAN := FALSE;
   pcrec_                  Part_Catalog_API.Public_Rec;
   pirec_                  Part_Catalog_API.Public_Rec;
   create_purchase_part_   VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   sales_config_family_id_ VARCHAR2(24);
   part_configurable_      BOOLEAN;
   catalog_configurable_   BOOLEAN;
   purchase_part_exist_    NUMBER;
   external_resource_db_   VARCHAR2(5);
   tax_types_event_        VARCHAR2(20):= 'RESTRICTED';
BEGIN
   IF (indrec_.activeind  = FALSE) THEN
      newrec_.activeind := 'Y';
   END IF;
   IF (indrec_.conv_factor = FALSE) THEN
      newrec_.conv_factor := 1;
   END IF;   
   IF (indrec_.inverted_conv_factor = FALSE) THEN
      newrec_.inverted_conv_factor := 1;
   END IF;  
   IF (indrec_.price_conv_factor = FALSE) THEN
      newrec_.price_conv_factor := 1;
   END IF;
   IF (indrec_.close_tolerance = FALSE) THEN
      newrec_.close_tolerance := 0;
   END IF;
   IF (indrec_.rental_list_price = FALSE) THEN
      newrec_.rental_list_price := 0;
   END IF;
   IF (indrec_.rental_list_price_incl_tax = FALSE) THEN
      newrec_.rental_list_price_incl_tax := 0;
   END IF;
   IF (indrec_.sourcing_option = FALSE) THEN
      -- default for package sales part (package form doesn't send this attribute)
      newrec_.sourcing_option := 'NOTSUPPLIED';
   END IF; 

   company_ := Site_API.Get_Company(newrec_.contract);

   IF (indrec_.create_sm_object_option = FALSE) THEN
      newrec_.create_sm_object_option := 'DONOTCREATESMOBJECT';
   END IF;
   IF (indrec_.non_inv_part_type = FALSE) THEN
      newrec_.non_inv_part_type := 'GOODS';
   END IF;

   -- default for package sales part (package form doesn't send this attribute)
   --newrec_.sourcing_option := 'NOTSUPPLIED';
   IF (indrec_.export_to_external_app = FALSE) THEN
      newrec_.export_to_external_app := db_false_;  
   END IF; 
   IF (indrec_.sales_type = FALSE) THEN
      newrec_.sales_type := Sales_Type_API.DB_SALES_ONLY;
   END IF;      
   
   part_desc_ := Client_Sys.Get_Item_Value('PART_DESCRIPTION', attr_);
   
   IF (newrec_.catalog_desc IS NULL) THEN
      newrec_.catalog_desc := Get_Desc_For_New_Sales_Part(newrec_.contract, newrec_.catalog_no);
      IF (part_desc_ IS NULL AND newrec_.catalog_type = 'INV') THEN
         part_desc_ := newrec_.catalog_desc;
      END IF;      
   END IF;
   
   IF (Client_Sys.Item_Exist('UNIT_MEAS', attr_)) THEN
      unit_meas_ := Client_Sys.Get_Item_Value('UNIT_MEAS', attr_);
      Iso_Unit_API.Exist(unit_meas_);   
   END IF; 
    
   create_purchase_part_ :=  NVL(Client_Sys.Get_Item_Value('CREATE_PURCHASE_PART', attr_), Fnd_Boolean_API.DB_FALSE);
    
   IF (newrec_.quick_registered_part IS NULL) THEN
      newrec_.quick_registered_part := 'FALSE';
   END IF;
   
   IF (newrec_.cost < 0) THEN
      Error_SYS.Record_General(lu_name_, 'COST_LESS_ZERO: Cost must be greater than zero');
   END IF;
   
   -- When catalog_type is not 'PKG', allow_partial_pkg_deliveries will 'TRUE'.
   IF (newrec_.catalog_type != 'PKG') THEN
      newrec_.allow_partial_pkg_deliv := db_true_;
   END IF;

   IF (newrec_.primary_catalog IS NULL) THEN
      newrec_.primary_catalog := db_false_; 
   END IF;
   
   IF (newrec_.list_price_incl_tax IS NULL) THEN  
      tax_percentage_ := NVL(Statutory_Fee_API.Get_Fee_Rate(Site_API.Get_Company(newrec_.contract), newrec_.tax_code), 0); 
      newrec_.list_price_incl_tax := newrec_.list_price * ((tax_percentage_ / 100) + 1); 
   END IF;
   
   super(newrec_, indrec_, attr_);
   
   pcrec_ := Part_Catalog_API.Get(newrec_.catalog_no);
   pirec_ := Part_Catalog_API.Get(newrec_.part_no);
   IF ((pcrec_.receipt_issue_serial_track = db_true_) OR
       (pcrec_.lot_tracking_code != 'NOT LOT TRACKING')) THEN
      lot_or_serial_tracked_ := TRUE;
   END IF;

   IF (newrec_.catalog_type = 'INV') THEN
      IF (newrec_.primary_catalog = db_true_) THEN
         catalog_no_ := Get_Active_Prim_Catalog_No(newrec_.contract, newrec_.part_no);
         IF (catalog_no_ IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'ACTIVE_PRIM_EXIST: The sales part :P1 has been assigned as the primary sales part for inventory part :P2 on site :P3.', catalog_no_, newrec_.part_no, newrec_.contract);
         END IF;          
      END IF; 
   ELSIF (newrec_.catalog_type = 'NON') THEN
      IF (newrec_.part_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NONINVPARTERROR: Inventory part should be null for a non inventory sales part.');
      END IF;
     
      IF(pcrec_.catch_unit_enabled = db_true_) THEN
         Error_SYS.Record_General(lu_name_,'CANNOTINSERTNON: It is not allowed to create a non-inventory part if the part is catch unit enabled.');
      END IF;
   ELSE
      IF(pcrec_.catch_unit_enabled = db_true_) THEN
         Error_SYS.Record_General(lu_name_,'CANNOTINSERTPKG: It is not allowed to create a package part if the part is catch unit enabled.');
      END IF;
   END IF;
   
   Client_SYS.Add_To_Attr('CREATE_PURCHASE_PART', create_purchase_part_, attr_);
   Client_SYS.Add_To_Attr('PART_DESCRIPTION', part_desc_, attr_);
   Check_Sourcing_Option___(newrec_, attr_);
   --Check the catch unit code.
   Check_Catch_Unit___(newrec_);

   -- When catalog_type is 'PKG', cost must be 'ZERO'.
   IF (newrec_.catalog_type = 'PKG') THEN
      newrec_.cost := 0;
      IF (lot_or_serial_tracked_) THEN
         Error_SYS.Record_General(lu_name_,'PKGPARTTRACKED: It is not allowed to create a package part if the part is serial tracked and/or lot batch tracked.');
      END IF;
   END IF;

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   Tax_Handling_Util_API.Validate_Tax_On_Object(company_, tax_types_event_, newrec_.tax_code, newrec_.taxable, newrec_.tax_class_id, newrec_.catalog_no, SYSDATE, 'CUSTOMER_TAX');
   IF (newrec_.replacement_part_no IS NOT NULL) THEN
      IF Sales_Part_Package_API.Check_Exist(newrec_.contract, newrec_.replacement_part_no, newrec_.catalog_no) THEN
         Error_SYS.Record_General(lu_name_, 'NOTVALID: A replacement part with type Package Part cannot replace a sales part of type Inventory Part or Non-Inventory Part that also exists as a component of a Package Part.');
      END IF;
      IF (newrec_.date_of_replacement IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NEEDDATE: Replacement part must have a date of replacement.');
      END IF;
   END IF;

   IF (newrec_.date_of_replacement IS NOT NULL) AND (newrec_.replacement_part_no IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOPART: Date of replacement may only be entered if a replacement part number has been indicated.');
   END IF;

   IF (newrec_.catalog_type = 'NON') THEN
      IF (Inventory_Part_API.Check_Exist(newrec_.contract,newrec_.catalog_no)) THEN
         Error_SYS.Record_General(lu_name_, 'INVPARTEXISTS: Inventory part :P1 already exists on Site :P2, sales part has to be created as an inventory sales part.',newrec_.catalog_no, newrec_.contract);
      END IF;
      Trace_SYS.Field('PURCHASE_PART_NO', newrec_.purchase_part_no);
      IF (newrec_.purchase_part_no IS NOT NULL) THEN
         Exist_Purchase_Part___(newrec_.contract, newrec_.purchase_part_no, (newrec_.catalog_type = 'INV'));
      END IF;
      IF (lot_or_serial_tracked_) THEN
         Error_SYS.Record_General(lu_name_,'PARTTRACKED: It is not allowed to create a non-inventory part if the part is serial tracked and/or lot batch tracked.');
      END IF;
   END IF;

   IF (newrec_.list_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGPRICE: Price must not be negative.');
   END IF;
   
   IF (newrec_.rental_list_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGRNTPRICE: Rental price must not be negative.');
   END IF;

   -- Create SM object option check
   IF ((newrec_.create_sm_object_option = 'CREATESMOBJECT') AND
       (pirec_.receipt_issue_serial_track = db_false_)) THEN
      Raise_Sm_Not_Allowed_Error___;
   END IF;

   -- Copy the fields back to the attr string, to use in the Insert___ method
   Client_SYS.Add_To_Attr('PART_DESCRIPTION', part_desc_, attr_);
   Client_SYS.Add_To_Attr('UNIT_MEAS', unit_meas_, attr_);

   IF (Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(newrec_.sales_price_group_id) = 'UNIT BASED') THEN
      -- Unit based. Check if unit equals the price group unit.
      sales_price_group_unit_ := Sales_Price_Group_API.Get_Sales_Price_Group_Unit(newrec_.sales_price_group_id);
      IF (sales_price_group_unit_ != newrec_.price_unit_meas) THEN
         Error_SYS.Record_General(lu_name_, 'INVALID_UNIT: The price U/M (:P1) must match the Price Group Unit (:P2).',
                                  newrec_.price_unit_meas, sales_price_group_unit_);
      END IF;
   END IF;

   IF ((newrec_.conv_factor != 1 OR newrec_.inverted_conv_factor != 1) AND (newrec_.catalog_type != 'INV')) THEN
      Error_SYS.Record_General(lu_name_,'CONV_FACTOR_NOT_ONE: The conversion factor and the inverted conversion factor must be 1 for non-inventory parts.');
   END IF;

   IF (newrec_.conv_factor <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'CONV_GREATER_ZERO: The conversion factor must be greater than zero');
   END IF;   
   
   IF (newrec_.inverted_conv_factor <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVERTED_CONV_GREATER_ZERO: The inverted conversion factor must be greater than zero');
   END IF;

   IF (newrec_.price_conv_factor <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'PRICONV_GREATER_ZERO: The price conversion factor must be greater than zero');
   END IF;


   -- Both the conversion factor and the inverted conversion factor cannot have a value which is not equal to one at the same time.
   IF (newrec_.conv_factor != 1 AND newrec_.inverted_conv_factor != 1) THEN
     newrec_.inverted_conv_factor := 1;
   END IF;

   IF (newrec_.close_tolerance < 0) OR NOT (newrec_.close_tolerance < 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_CLOSE_TOL: The close tolerance must be less than 100');
   END IF;

   planning_method_ := Inventory_Part_Planning_API.Get_Planning_Method(newrec_.contract, newrec_.part_no);

   IF (planning_method_ IN ('O', 'T', 'K')) THEN
      Error_SYS.Record_General(lu_name_,'MRP_ORDER_CODE_OTK: Inventory parts with MRP order code O T or K are not allowed to be sale parts.');
   END IF;

   IF ((newrec_.catalog_type = 'INV') AND (newrec_.catalog_no != NVL(newrec_.part_no, newrec_.catalog_no)) AND (Part_Catalog_API.Check_Part_Exists(newrec_.part_no))) THEN
      catalog_configurable_:= (Part_Catalog_API.Get_Configurable_Db(newrec_.catalog_no) = 'CONFIGURED');
      part_configurable_   := (Part_Catalog_API.Get_Configurable_Db(newrec_.part_no) = 'CONFIGURED');
      IF (catalog_configurable_) THEN
         IF (part_configurable_) THEN
            $IF Component_Cfgchr_SYS.INSTALLED $THEN
               sales_config_family_id_ := Config_Part_Catalog_API.Get_Config_Family_Id(newrec_.catalog_no);  
            $END
            
            IF (sales_config_family_id_ IS NOT NULL) THEN
               Error_SYS.Record_General(lu_name_, 'CATALOGHASCONFIGFAMILY: A configurable sales part, whose master part is connected to a configuration family, is not allowed to be connected to another configurable inventory part.');
            END IF;
         ELSE
            Error_SYS.Record_General(lu_name_, 'INVNOTCONFIG: A non configurable inventory part cannot be connected to a sales part that is set as configurable in part catalog.');
         END IF;
         -- catalog_configurable_ is NULL when catalog_no is a new one to be created in part catalog
      ELSIF (catalog_configurable_ IS NOT NULL AND part_configurable_) THEN
         Error_SYS.Record_General(lu_name_, 'CATNOTCONFIG: The non-configurable sales part [:P1] is not allowed to be connected to the configurable inventory part [:P2].', newrec_.catalog_no, newrec_.part_no);
      END IF;
   END IF;
   
   Check_Unit_Meas_On_Sites___(newrec_.contract, newrec_.catalog_no, newrec_.sales_price_group_id, newrec_.price_unit_meas);
   Check_Conv_Factor_On_Sites___(newrec_.contract, newrec_.catalog_no, newrec_.sales_price_group_id, newrec_.price_conv_factor);
   -- Check for conflicting definitions
   Check_Configs_On_Sites___(newrec_.contract, newrec_.catalog_no, newrec_.part_no);
   IF (newrec_.catalog_type = 'INV') THEN
      newrec_.customs_stat_no := Inventory_Part_API.Get_Customs_Stat_No(newrec_.contract, newrec_.part_no);
      newrec_.intrastat_conv_factor := Inventory_Part_API.Get_Intrastat_Conv_Factor(newrec_.contract, newrec_.part_no);
   END IF;

   IF (newrec_.catalog_type != 'PKG') THEN
      -- IF customs statistics number's unit measure has a value, check if intrastat conv factor and net weight have been entered too
      IF (Customs_Statistics_Number_API.Get_Customs_Unit_Meas(newrec_.customs_stat_no) IS NOT NULL) THEN
         IF (newrec_.intrastat_conv_factor IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOINTRA: Intrastat conversion factor must have a value when the customs statistics number has a defined customs unit of measure.');
         END IF;
      ELSE
         IF (newrec_.intrastat_conv_factor IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOINTRA1: Intrastat conversion factor cannot have a value if the customs statistics number does not have a unit of measure.');
         END IF;
      END IF;
   END IF;

   IF (newrec_.intrastat_conv_factor <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'INTRACONVGREATER0: The Intrastat conversion factor must be greater than zero.');
   END IF;

   IF pirec_.position_part = 'POSITION PART' THEN
      Error_SYS.Record_General(lu_name_, 'POSITIONPART: Position parts are not allowed to be sales parts.');
   END IF;

   --Check against the Inventory Part.
   IF (newrec_.catalog_type='INV') AND (newrec_.conv_factor != 1 OR newrec_.inverted_conv_factor != 1) THEN
      inventory_uom_group_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id (newrec_.contract,newrec_.part_no);
      IF inventory_uom_group_  IS NOT NULL THEN
         IF newrec_.conv_factor != 1 THEN
            Raise_Conv_Factor_Error___;
         ELSIF newrec_.inverted_conv_factor != 1 THEN
            Error_SYS.Record_General(lu_name_, 'INVPARTINVERTEDCONVFONE: Inverted conversion factor should be equal to 1 when the Inventory Part is connected to an Input UoM Group.');
         END IF;
      END IF;
   END IF;

   IF (newrec_.catalog_type='INV') THEN
      automatic_cc_db_ := Capability_Check_Allocate_API.Encode(Inventory_Part_API.Get_Automatic_Capability_Check(newrec_.contract, newrec_.part_no));
      IF (automatic_cc_db_ IN ('RESERVE AND ALLOCATE','ALLOCATE ONLY','NEITHER RESERVE NOR ALLOCATE') AND
          newrec_.sourcing_option NOT IN ('DOPORDER','SHOPORDER')) THEN
         Raise_Cc_Source_Opt_Error___(automatic_cc_db_);
      END IF;
   END IF;

   --Check against the Part Catalog.
   IF (newrec_.catalog_type='INV') AND (newrec_.conv_factor != 1 OR newrec_.inverted_conv_factor != 1) THEN
      partca_uom_group_ := pirec_.input_unit_meas_group_id;
      IF partca_uom_group_  IS NOT NULL THEN
         IF newrec_.conv_factor != 1 THEN
            Error_SYS.Record_General(lu_name_, 'PARTCATCONVFONE: Conversion factor should be equal to 1 when the Part in Part Catalog is connected to a Default Input UoM Group.');
         ELSIF newrec_.inverted_conv_factor != 1 THEN
            Error_SYS.Record_General(lu_name_, 'PARTCATINVERTEDCONVFONE: Inverted Conversion factor should be equal to 1 when the Part in Part Catalog is connected to a Default Input UoM Group.');
         END IF;
      END IF;
   END IF;

   -- XPR, not allowed to create sales parts if part is already created with the external resource flag in purchase part.
   $IF (Component_Purch_SYS.INSTALLED) $THEN 
      purchase_part_exist_ := Purchase_Part_API.Check_Exist(newrec_.contract, newrec_.catalog_no);
      IF (purchase_part_exist_ = 1) THEN
         external_resource_db_ := Purchase_Part_API.Get_External_Resource_Db(newrec_.contract, newrec_.catalog_no);
         IF (external_resource_db_ = Fnd_Boolean_API.DB_TRUE) THEN
            Error_SYS.Record_General(lu_name_, 'SALESEXTRESEXIST: :P1 is already a contractor purchase part on site :P2, and cannot be defined as a sales part.', newrec_.catalog_no, newrec_.contract);
         END IF;
      END IF;     
   $END
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sales_part_tab%ROWTYPE,
   newrec_ IN OUT sales_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(4000);
   price_changed_          BOOLEAN := FALSE;
   sales_price_group_unit_ VARCHAR2(10);
   company_                VARCHAR2(20);   
   inventory_uom_group_    VARCHAR2(30);
   automatic_cc_db_        VARCHAR2(50); 
   unit_meas_              VARCHAR2(10);
   catalog_no_             SALES_PART_TAB.catalog_no%TYPE;
   part_desc_              SALES_PART_TAB.catalog_desc%TYPE ;
   tax_types_event_        VARCHAR2(20):= 'RESTRICTED';
BEGIN
   company_ := Site_API.Get_Company(newrec_.contract);
   IF(indrec_.purchase_part_no AND newrec_.purchase_part_no IS NOT NULL) THEN
      Exist_Purchase_Part___(newrec_.contract, newrec_.purchase_part_no, (newrec_.catalog_type = 'INV'));
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);     
      
   Check_If_Package_Part_Exist___(newrec_.contract, newrec_.catalog_no );
   
   IF (newrec_.cost < 0) THEN
      Error_SYS.Record_General(lu_name_, 'COST_LESS_ZERO: Cost must be greater than zero');
   END IF;
   
   part_desc_ := Client_Sys.Get_Item_Value('PART_DESCRIPTION', attr_);
   IF (part_desc_ IS NOT NULL) THEN
       Error_SYS.Item_Update(lu_name_, 'PART_DESCRIPTION');
   END IF;   
   
   unit_meas_ := Client_Sys.Get_Item_Value('UNIT_MEAS', attr_);
   IF (unit_meas_ IS NOT NULL) THEN
       Error_SYS.Item_Update(lu_name_, 'UNIT_MEAS');
   END IF;   
   
   IF (newrec_.list_price IS NOT NULL OR newrec_.list_price_incl_tax IS NOT NULL) THEN
      price_changed_ := TRUE;
   END IF;   
   
   IF NOT price_changed_ THEN
      Error_SYS.Item_Update(lu_name_, 'PRICE_CHANGE_DATE');
   END IF;
   
   IF (newrec_.catalog_type = 'PKG' AND newrec_.sales_type IN (Sales_Type_API.DB_RENTAL_ONLY, Sales_Type_API.DB_SALES_AND_RENTAL)) THEN
      Error_SYS.Record_General(lu_name_, 'PKGPARTNOTFORRENTAL: Package Parts are not allowed for Rental.');
   END IF;
   Client_SYS.Add_To_Attr('CREATE_PURCHASE_PART', Fnd_Boolean_API.DB_FALSE, attr_);
   Check_Sourcing_Option___(newrec_, attr_);
   --Check the catch unit code.
   Check_Catch_Unit___(newrec_);

   Trace_SYS.Field('PURCHASE_PART_NO', newrec_.purchase_part_no);
   Tax_Handling_Util_API.Validate_Tax_On_Object(company_, tax_types_event_, newrec_.tax_code, newrec_.taxable ,newrec_.tax_class_id, newrec_.catalog_no, SYSDATE, 'CUSTOMER_TAX');
   IF (newrec_.replacement_part_no IS NOT NULL) THEN
      IF (newrec_.replacement_part_no = newrec_.catalog_no) THEN
         Error_SYS.Record_General(lu_name_, 'SAMEASSALESPARTNO: The replacement part number must be different from the sales part number.');
      END IF;
      IF Sales_Part_Package_API.Check_Exist(newrec_.contract, newrec_.replacement_part_no, newrec_.catalog_no) THEN
         Error_SYS.Record_General(lu_name_, 'NOTVALID: A replacement part with type Package Part cannot replace a sales part of type Inventory Part or Non-Inventory Part that also exists as a component of a Package Part.');
      END IF;
      IF (newrec_.date_of_replacement IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NEEDDATE: Replacement part must have a date of replacement.');
      END IF;
   END IF;

   IF (newrec_.date_of_replacement IS NOT NULL) AND (newrec_.replacement_part_no IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOPART: Date of replacement may only be entered if a replacement part number has been indicated.');
   END IF;

   IF (newrec_.list_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGPRICE: Price must not be negative.');
   END IF;
   
   IF (newrec_.rental_list_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGRNTPRICE: Rental price must not be negative.');
   END IF;

   -- create SM object option check
   IF ((newrec_.create_sm_object_option = 'CREATESMOBJECT') AND
       (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(newrec_.part_no) = db_false_)) THEN
      Raise_Sm_Not_Allowed_Error___;
   END IF;

   IF ((newrec_.conv_factor != 1 OR newrec_.inverted_conv_factor != 1) AND (newrec_.catalog_type != 'INV')) THEN
      Error_SYS.Record_General(lu_name_, 'CONV_FACTOR_NOT_ONE: The conversion factor and the inverted conversion factor must be 1 for non-inventory parts.');
   END IF;

   IF (newrec_.conv_factor <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'CONV_GREATER_ZERO: The conversion factor must be greater than zero');
   END IF;

   IF (newrec_.inverted_conv_factor <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVERTED_CONV_GREATER_ZERO: The inverted conversion factor must be greater than zero');
   END IF;

   IF (newrec_.price_conv_factor <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'PRICONV_GREATER_ZERO: The price conversion factor must be greater than zero');
   END IF;


   -- Both the conversion factor and the inverted conversion factor cannot have a value which is not equal to one at the same time.
   IF (newrec_.conv_factor != 1 AND newrec_.inverted_conv_factor != 1) THEN
     IF (oldrec_.conv_factor != newrec_.conv_factor) THEN
        newrec_.inverted_conv_factor := 1;
     ELSIF (oldrec_.inverted_conv_factor != newrec_.inverted_conv_factor) THEN
        newrec_.conv_factor := 1;
     END IF;
   END IF;

   IF (Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(newrec_.sales_price_group_id) = 'UNIT BASED') THEN
      -- Unit based. Check if unit equals the price group unit.
      sales_price_group_unit_ := Sales_Price_Group_API.Get_Sales_Price_Group_Unit(newrec_.sales_price_group_id);
      IF (sales_price_group_unit_ != newrec_.price_unit_meas) THEN
         Error_SYS.Record_General(lu_name_, 'INVALID_UNIT: The price U/M (:P1) must match the Price Group Unit (:P2).',newrec_.price_unit_meas, sales_price_group_unit_);
      END IF;
   END IF;

   IF price_changed_ THEN
      newrec_.price_change_date := trunc(Site_API.Get_Site_Date(newrec_.contract));
   END IF;
   Client_SYS.Add_To_Attr('PRICE_CHANGE_DATE', newrec_.price_change_date, attr_);
   
   Check_Unit_Meas_On_Sites___(newrec_.contract, newrec_.catalog_no, newrec_.sales_price_group_id, newrec_.price_unit_meas);
   Check_Conv_Factor_On_Sites___(newrec_.contract, newrec_.catalog_no, newrec_.sales_price_group_id, newrec_.price_conv_factor);
   -- Check for conflicting definitions
   Check_Configs_On_Sites___(newrec_.contract, newrec_.catalog_no, newrec_.part_no);

   IF (newrec_.catalog_type != 'PKG') THEN
      -- IF customs statistics number's unit measure has a value, check if intrastat conv factor and net weight have been entered too
      IF (Customs_Statistics_Number_API.Get_Customs_Unit_Meas(newrec_.customs_stat_no) IS NOT NULL) THEN
         IF (newrec_.intrastat_conv_factor IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOINTRA: Intrastat conversion factor must have a value when the customs statistics number has a defined customs unit of measure.');
         END IF;
      ELSE
         IF (newrec_.intrastat_conv_factor IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOINTRA1: Intrastat conversion factor cannot have a value if the customs statistics number does not have a unit of measure.');
         END IF;
      END IF;
   END IF;

   IF (newrec_.intrastat_conv_factor <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'INTRACONVGREATER0: The Intrastat conversion factor must be greater than zero.');
   END IF;

   --Check against the Inventory Part.
   IF (newrec_.catalog_type='INV') AND (newrec_.conv_factor != 1 OR newrec_.inverted_conv_factor != 1) THEN
      inventory_uom_group_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id (newrec_.contract,newrec_.part_no);
      IF inventory_uom_group_  IS NOT NULL THEN
         IF newrec_.conv_factor != 1 THEN
            Raise_Conv_Factor_Error___;
         ELSIF newrec_.inverted_conv_factor != 1 THEN
            Error_SYS.Record_General(lu_name_, 'INVPARTINVERTEDCONVFONE: Inverted conversion factor should be equal to 1 when the Inventory Part is connected to an Input UoM Group.');
         END IF; 
      END IF;
   END IF;

   IF (newrec_.catalog_type='INV') THEN
      IF ((newrec_.primary_catalog = db_true_) AND (oldrec_.primary_catalog = db_false_)) THEN 
         catalog_no_ := Get_Active_Prim_Catalog_No(newrec_.contract, newrec_.part_no);
          IF (catalog_no_ IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'ACTIVE_PRIM_EXIST: The sales part :P1 has been assigned as the primary sales part for inventory part :P2 on site :P3.', catalog_no_, newrec_.part_no, newrec_.contract);
         END IF;      
      END IF;  
      automatic_cc_db_ := Capability_Check_Allocate_API.Encode(Inventory_Part_API.Get_Automatic_Capability_Check(newrec_.contract, newrec_.part_no));
      IF (automatic_cc_db_ IN ('RESERVE AND ALLOCATE','ALLOCATE ONLY','NEITHER RESERVE NOR ALLOCATE') AND
          newrec_.sourcing_option NOT IN ('DOPORDER','SHOPORDER')) THEN
         Raise_Cc_Source_Opt_Error___(automatic_cc_db_);
      END IF;
   END IF;

   IF (newrec_.catalog_type='INV') AND (newrec_.conv_factor != 1 OR newrec_.inverted_conv_factor != 1) THEN      
      IF (Part_Catalog_API.Get_Input_Unit_Meas_Group_Id(newrec_.part_no)  IS NOT NULL) THEN
         IF newrec_.conv_factor != 1 THEN
            Error_SYS.Record_General(lu_name_, 'PARTCATCONVFONE: Conversion factor should be equal to 1 when the Part in Part Catalog is connected to a Default Input UoM Group.');
         ELSIF newrec_.inverted_conv_factor != 1 THEN
            Error_SYS.Record_General(lu_name_, 'PARTCATINVERTEDCONVFONE: Inverted Conversion factor should be equal to 1 when the Part in Part Catalog is connected to a Default Input UoM Group.');
         END IF;
      END IF;
   END IF;

   IF (newrec_.eng_attribute IS NULL) THEN
      IF (Sales_Part_Characteristic_API.Check_Characteristic_Code(newrec_.catalog_no, newrec_.contract) = 1) THEN
         Error_SYS.Record_General(lu_name_,'ERRENGATTR: To remove the template, Characteristic Code should be removed first.');
      END IF;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override   
PROCEDURE Check_Common___ (
   oldrec_ IN            sales_part_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY sales_part_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.close_tolerance < 0 OR newrec_.close_tolerance > 100) THEN
      Error_SYS.Item_General(lu_name_,'CLOSE_TOLERANCE', 'INVALIDCLOSETOL: Close Tolerance cannot be less than 0 or greater than 100.');
   END IF;
   
   IF (newrec_.sales_type IN (Sales_Type_API.DB_RENTAL_ONLY, Sales_Type_API.DB_SALES_AND_RENTAL)) THEN
      IF (Part_Catalog_API.Serial_Trak_Only_Rece_Issue_Db(newrec_.part_no) = db_true_) THEN
         Error_SYS.Record_General(lu_name_,'SALESTYPEFORTRACK: It is not possible to set the sales type to :P1 for parts that are serial tracked at receipt and issue but not serial tracked in inventory.',
                               Sales_Type_API.Decode(newrec_.sales_type));
      END IF;
      IF (Part_Catalog_API.Get_Configurable_Db(newrec_.catalog_no) = Part_Configuration_API.DB_CONFIGURED) THEN
         Error_SYS.Record_General(lu_name_, 'SALESPARTFORCONFIG: Sales types including rental are not allowed for configurable parts.');
      END IF;
   END IF;
   -- gelr:italy_intrastat, start
   IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(newrec_.contract, 'ITALY_INTRASTAT') = Fnd_Boolean_API.DB_TRUE) THEN
      IF (newrec_.catalog_type = Sales_Part_Type_API.DB_NON_INVENTORY_PART AND newrec_.non_inv_part_type = Non_Inventory_Part_Type_API.DB_GOODS AND newrec_.statistical_code IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'STATCODEINVALID: Goods/Services statistical code cannot has value for non-inventory goods.');
      END IF;
   END IF;
   -- gelr:italy_intrastat, end
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Totals__
--   Get sale part totals for cost and price.
@UncheckedAccess
PROCEDURE Get_Totals__ (
   total_sales_price_ OUT NUMBER,
   marg_rate_         OUT NUMBER,
   contract_          IN  VARCHAR2,
   catalog_no_        IN  VARCHAR2 )
IS
   inv_sum_     NUMBER;
   non_inv_sum_ NUMBER;
   total_cost_  SALES_PART_TAB.cost%TYPE;

   CURSOR get_totals IS
      SELECT NVL(SUM(sp.list_price * price_conv_factor * spp.qty_per_assembly), NULL)                 total_sales_price,
             NVL(sum((NVL(Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead(spp.contract,
                 Sales_Part_API.Get_Part_No(contract_, spp.catalog_no), NULL, NULL, NULL,
                 'CHARGED ITEM', NULL, NULL, NULL), 0) * spp.qty_per_assembly) * sp.conv_factor/ sp.inverted_conv_factor), 0)  inventory_sum,

             NVL(SUM(sp.cost * spp.qty_per_assembly), 0)                                              non_invetory_sum

      FROM   SALES_PART_TAB sp, SALES_PART_PACKAGE_TAB spp
      WHERE  spp.parent_part  = catalog_no_
      AND    spp.contract     = contract_
      AND    spp.contract     = sp.contract
      AND    spp.catalog_no   = sp.catalog_no;

   CURSOR get_attr IS
      SELECT list_price * price_conv_factor list_price
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    catalog_no = catalog_no_;

   rec_               get_attr%ROWTYPE;
   currency_code_     VARCHAR2(3);
   currency_rounding_ NUMBER;
BEGIN
   currency_code_     := Company_Finance_API.Get_Currency_Code(Site_API.Get_Company(contract_));
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(contract_),currency_code_);

   marg_rate_ := 0;

   OPEN get_totals;
   FETCH get_totals INTO total_sales_price_, inv_sum_, non_inv_sum_;
   CLOSE get_totals;

   total_cost_ := round((inv_sum_ + non_inv_sum_), currency_rounding_);

   OPEN get_attr;
   FETCH get_attr INTO rec_;
   CLOSE get_attr;

   marg_rate_ := round((((rec_.list_price - total_cost_) / rec_.list_price) * 100), currency_rounding_);
EXCEPTION
   WHEN zero_divide THEN
      NULL;
END Get_Totals__;

-- Check_Inv_Part_Exist__
--   Checks if inventory part exists. If found, print an error message.
--   Used as cascade delete check when removing an inventory part.
PROCEDURE Check_Inv_Part_Exist__ (
   key_list_ IN VARCHAR2 )
IS
   contract_ SALES_PART_TAB.contract%TYPE;
   part_no_  SALES_PART_TAB.part_no%TYPE;
   found_    NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_;
BEGIN
   contract_ := substr(key_list_, 1, instr(key_list_, '^') - 1);
   part_no_  := substr(key_list_, instr(key_list_, '^') + 1, instr(key_list_, '^' , 1, 2) - (instr(key_list_, '^') + 1));
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   IF (found_ = 1) THEN
      Error_SYS.Record_General(lu_name_, 'NO_DEL_7: This part exists as a sales part and must first be deleted as such.');
   END IF;
END Check_Inv_Part_Exist__;


PROCEDURE Remove_Part__ (
   key_list_ IN VARCHAR2 )
IS
BEGIN
   NULL;
END Remove_Part__;


-- Check_Delivery_Type__
--   Checks if delivery_type exists. If found, print an error message.
--   Used for restricted delete check when removing an delivery_type (INVOIC-module).
PROCEDURE Check_Delivery_Type__ (
   key_list_ IN VARCHAR2 )
IS
   company_       VARCHAR2(20);
   delivery_type_ SALES_PART_TAB.delivery_type%TYPE;
   found_         NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   SALES_PART_TAB
      WHERE  Site_API.Get_Company(contract) = company_
      AND    delivery_type = delivery_type_;
BEGIN
   company_       := substr(key_list_, 1, instr(key_list_, '^') - 1);
   delivery_type_ := substr(key_list_, instr(key_list_, '^') + 1, instr(key_list_, '^' , 1, 2) - (instr(key_list_, '^') + 1));

   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   IF found_ = 1 THEN
      Error_SYS.Record_General(lu_name_, 'NO_DEL_TYPE: Delivery Type :P1 exists on one or several Sales Part(s)', delivery_type_ );
   END IF;
END Check_Delivery_Type__;

-- Validate_Catalog_No__
--   Return the contract for a given catalog_no and company.
PROCEDURE Validate_Catalog_No__ (
   many_rows_        OUT VARCHAR2,
   contract_         OUT VARCHAR2,
   catalog_no_       IN  VARCHAR2,
   company_          IN  VARCHAR2)
IS
   
BEGIN
   SELECT sp.contract INTO contract_
      FROM   sales_part_tab sp, company_site_pub cs
      WHERE sp.catalog_no = catalog_no_
      AND cs.contract = sp.contract
      AND cs.company = company_
      AND sp.activeind = 'Y'
      AND EXISTS (SELECT 1 FROM user_allowed_site_pub
                   WHERE sp.contract = site);
   many_rows_ := 'FALSE';
EXCEPTION
   WHEN no_data_found THEN
      many_rows_ := 'FALSE';
   WHEN too_many_rows THEN
      contract_ := NULL;    
      many_rows_ := 'TRUE';
END Validate_Catalog_No__;

-- Get_Supply_Site_Part_No__
--   Returns the inventory_part_no in the supply site.
--   First get the supplier's part no specified in the supplier for purchase part record
--   If it's null get the part_no added in the cross reference
--   If that is also null check for a part no with the same name as in demand site
@UncheckedAccess
FUNCTION Get_Supply_Site_Part_No__ (   
   supply_site_       IN  VARCHAR2,
   demand_site_       IN  VARCHAR2,
   sales_part_no_     IN  VARCHAR2,
   vendor_no_         IN  VARCHAR2) RETURN VARCHAR2
IS
   supp_sales_part_no_ VARCHAR2(80);
   inv_part_no_        VARCHAR2(25);
   supply_inv_part_    VARCHAR2(25);
   internal_cust_      VARCHAR2(20);
BEGIN
   inv_part_no_ := Sales_Part_API.Get_Part_No(demand_site_, sales_part_no_);   
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      supp_sales_part_no_ := Purchase_Part_Supplier_API.Get_Vendor_Part_No(demand_site_, inv_part_no_, vendor_no_);                                      
   $END
   IF (supp_sales_part_no_ IS NULL) THEN
      internal_cust_ := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(demand_site_);
      supp_sales_part_no_ := Sales_Part_Cross_Reference_API.Get_Catalog_No(internal_cust_, supply_site_, sales_part_no_);
   END IF;
   supply_inv_part_ := Sales_Part_API.Get_Part_No(supply_site_, NVL(supp_sales_part_no_, inv_part_no_));

   RETURN NVL(supply_inv_part_, inv_part_no_);
   
END Get_Supply_Site_Part_No__;


-- Register_Sales_part__
--   Creating Sales Part(Any of the types Inventory part, Non Inventory part or Package part)
--   and adding cost information to the inventory part if the catalog type is INV.
PROCEDURE Register_Sales_Part__ (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS 
   catalog_no_      Sales_Part_Tab.catalog_no%TYPE;
   contract_        Sales_Part_Tab.contract%TYPE; 
   catalog_type_db_ Sales_Part_Tab.catalog_type%TYPE;
   part_no_         Sales_Part_Tab.part_no%TYPE;
   cost_            Sales_Part_Tab.cost%TYPE;
BEGIN
   
   catalog_no_      := Client_SYS.Get_Item_Value('CATALOG_NO', attr_);
   contract_        := Client_SYS.Get_Item_Value('CONTRACT', attr_); 
   catalog_type_db_ := Sales_Part_Type_API.Encode(Client_SYS.Get_Item_Value('CATALOG_TYPE', attr_));
   part_no_         := Client_SYS.Get_Item_Value('PART_NO', attr_);
   cost_            := Client_SYS.Get_Item_Value('COST', attr_);
   
   Sales_Part_API.New(info_, attr_);
   
   -- Updating estimated material cost of the inventory part using the cost defined by the user.
   -- (Note: When existing inventory part is used attribute string does not having 'COST' element.)
   IF ((catalog_type_db_ = Sales_Part_Type_API.DB_INVENTORY_PART) AND (cost_ IS NOT NULL)) THEN
      Inventory_Part_Config_API.Modify_Estimated_Material_Cost(contract_, part_no_, '*', cost_, true); 
   END IF;
   
END Register_Sales_Part__; 

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
@UncheckedAccess
PROCEDURE Exist (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2,
   usage_      IN VARCHAR2 DEFAULT Sales_Type_API.DB_SALES_ONLY)
IS
   sales_type_db_ SALES_PART_TAB.sales_type%TYPE;
BEGIN
   super(contract_, catalog_no_);
   
   IF (usage_ != Sales_Type_API.DB_SALES_AND_RENTAL) THEN
      sales_type_db_ := Get_Sales_Type_Db(contract_, catalog_no_);
      IF ((usage_ = Sales_Type_API.DB_SALES_ONLY AND sales_type_db_ = Sales_Type_API.DB_RENTAL_ONLY) OR
         ( usage_ = Sales_Type_API.DB_RENTAL_ONLY AND sales_type_db_ = Sales_Type_API.DB_SALES_ONLY)) THEN
         Error_SYS.Record_General(lu_name_, 'INVALSALESTYPE: It is not possible to use sales part :P1, as the sales type for this part is set to :P2 in site :P3.', 
                                    catalog_no_, Sales_Type_API.Decode(sales_type_db_), contract_);
      END IF;
   END IF;
END Exist;


@Override
@UncheckedAccess
FUNCTION Get_Cost (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ SALES_PART_TAB.cost%TYPE;
BEGIN
   temp_ := super(contract_, catalog_no_);
   RETURN NVL(temp_, 0);
END Get_Cost;


-- Get_Active_Catalog_No
--   This method checks whether there are active sales parts exist for a given inventory part. If multiple
--   active sales parts exist, checks whether one sales part exist with primary flag set. If no error is
--   raised it will return the active sales part for the given inventory part.
PROCEDURE Get_Active_Catalog_No (
   catalog_no_ OUT VARCHAR2,
   contract_   IN  VARCHAR2,
   part_no_    IN  VARCHAR2 )
IS   
   no_of_active_sales_parts_ NUMBER; 
BEGIN
   no_of_active_sales_parts_ := Get_No_Of_Active_Sale_Parts___(contract_, part_no_); 

   IF (no_of_active_sales_parts_ = 0)  THEN
      Error_SYS.Record_General(lu_name_, 'NOACTIVESALESPARTFORINV: An active sales part does not exist for inventory part :P1 in site :P2.' , part_no_ , contract_);
   ELSIF (no_of_active_sales_parts_ = 1) THEN
      catalog_no_ := Get_Catalog_No_For_Part_No(contract_, part_no_);
   ELSIF (no_of_active_sales_parts_ > 1)  THEN
      catalog_no_ := Get_Active_Prim_Catalog_No(contract_, part_no_);
      IF (catalog_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'PRIMSALEPARTNOTEXIST: There are more than one active sales parts exist for the inventory part :P1. Therefore, a primary sales part needs to be defined.', part_no_);
      END IF;
   END IF;
END Get_Active_Catalog_No;

-- Get_Active_Catalog_No
--   Returns the active sales part connected to the specified inventory part else return NULL.
FUNCTION Get_Active_Catalog_No (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   catalog_no_ SALES_PART_TAB.catalog_no%TYPE;

   CURSOR get_active_catalog IS
      SELECT catalog_no
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    activeind = 'Y';
BEGIN
   catalog_no_ := Get_Active_Prim_Catalog_No(contract_, part_no_); 
   IF (catalog_no_ IS NULL) THEN
      OPEN get_active_catalog;
      FETCH get_active_catalog INTO catalog_no_;
      IF (get_active_catalog%NOTFOUND) THEN
         catalog_no_ := NULL;
      END IF; 
      CLOSE get_active_catalog;
   END IF; 
   RETURN catalog_no_; 
END Get_Active_Catalog_No;

-- Check_Active_Sales_Part
--   This method checks whether an active sales part exist
PROCEDURE Check_Active_Sales_Part (
   contract_    IN VARCHAR2,
   catalog_no_  IN VARCHAR2 )
IS
   activeind_  SALES_PART_TAB.activeind%TYPE;

   CURSOR get_activeind IS
      SELECT activeind
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    catalog_no = catalog_no_;
BEGIN

   OPEN get_activeind;
   FETCH get_activeind INTO activeind_;
   IF (get_activeind%NOTFOUND) THEN
      CLOSE get_activeind;
      Error_SYS.Record_Not_Exist(lu_name_);
   ELSE   
      CLOSE get_activeind;
   END IF;

   IF (activeind_ = 'N') THEN
      Error_SYS.Record_General(lu_name_, 'NOACTIVESALESPART: The sales part :P1 is not active in site :P2.', catalog_no_ , contract_);
   END IF;     
END Check_Active_Sales_Part;


-- Get_Catalog_Group_Desc
--   Get catalog group's description.
@UncheckedAccess
FUNCTION Get_Catalog_Group_Desc (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS

BEGIN
   RETURN Sales_Group_API.Get_Description(Get_Catalog_Group(contract_,catalog_no_));
END Get_Catalog_Group_Desc;


-- Check_If_Valid_Component
--   Checks for contract and catalog_no in Sales_Part_Lov view
--   Used to validate the component part in a package.
PROCEDURE Check_If_Valid_Component (
   contract_    IN VARCHAR2,
   catalog_no_  IN VARCHAR2,
   raise_error_ IN VARCHAR2 DEFAULT 'YES' )
IS
   sales_part_rec_ SALES_PART_API.Public_Rec;
BEGIN
   IF NOT (Check_Exist___(contract_, catalog_no_)) THEN
      Error_SYS.Record_General(lu_name_, 'NOTEXIST: The specified component part does not exist.');
   END IF;

   sales_part_rec_ := Get(contract_, catalog_no_);

   IF (sales_part_rec_.activeind = 'N' AND raise_error_ = 'YES') THEN
      Error_SYS.Record_General(lu_name_, 'NOTACTIVE: The specified component part is not active for sale.');
   ELSIF (sales_part_rec_.catalog_type = 'PKG') THEN
      Error_SYS.Record_General(lu_name_, 'NOVALID: A sales part with the type '':P1'' cannot be used as a component part.', Sales_Part_Type_API.Decode(sales_part_rec_.catalog_type));
   ELSIF (sales_part_rec_.replacement_part_no IS NOT NULL) AND (sales_part_rec_.date_of_replacement <= Site_API.Get_Site_Date(contract_)) THEN
      Error_SYS.Record_General(lu_name_, 'REPLACED: The specified sales part has been replaced by :P1 and cannot be used as a component part.', sales_part_rec_.replacement_part_no);
   END IF;
END Check_If_Valid_Component;


-- Get_Commission_Catalog_Desc
--   Returns the sale part's Description for the catalog_no_ without contract.
@UncheckedAccess
FUNCTION Get_Commission_Catalog_Desc (
   catalog_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ SALES_PART_TAB.catalog_desc%TYPE;
   CURSOR  get_attr IS
   SELECT  sp.catalog_desc          catalog_desc
   FROM    sales_part_tab sp
   WHERE   sp.activeind = 'Y'
   AND     sp.contract IN (SELECT site FROM user_allowed_site_pub
                           WHERE sp.contract = site)
   AND     sp.rowid = (SELECT MAX(sp2.rowid)
                       FROM   sales_part_tab sp2
                       WHERE sp2.catalog_no = catalog_no_
                       AND   sp2.contract IN (SELECT site FROM user_allowed_site_pub
                                              WHERE sp2.contract = site))
   AND     sp.catalog_no = catalog_no_;

BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Commission_Catalog_Desc;


-- Get_Return_Unit_Meas
--   Return the sale part's unit measure used when returning parts.
@UncheckedAccess
FUNCTION Get_Return_Unit_Meas (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_        SALES_PART_API.Public_Rec;
BEGIN
   IF Check_Exist___(contract_, catalog_no_) THEN
      rec_ := Get(contract_, catalog_no_);
      RETURN nvl(Inventory_Part_API.Get_Unit_Meas(contract_, rec_.part_no), rec_.sales_unit_meas);
   ELSE
      RETURN NULL;
   END IF;
END Get_Return_Unit_Meas;


-- Exist_Inventory_Part
--   Checks for part_no, contract.
@UncheckedAccess
FUNCTION Exist_Inventory_Part (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF exist_control%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN found_;
END Exist_Inventory_Part;


-- Get_Next_Line_Item_No
--   Return the next available line item for a package part.
PROCEDURE Get_Next_Line_Item_No (
   line_item_no_ IN OUT NUMBER,
   contract_     IN     VARCHAR2,
   catalog_no_   IN     VARCHAR2 )
IS
   found_ NUMBER;
   CURSOR get_line_no IS
      SELECT MAX(line_item_no) + 1
      FROM   SALES_PART_PACKAGE_TAB
      WHERE  contract    = contract_
      AND    parent_part = catalog_no_;

   CURSOR exist_control IS
      SELECT 1
      FROM   SALES_PART_PACKAGE_TAB
      WHERE  contract     = contract_
      AND    parent_part  = catalog_no_
      AND    line_item_no = line_item_no_;
BEGIN
   IF (line_item_no_ IS NOT NULL) THEN
      OPEN exist_control;
      FETCH exist_control INTO found_;
      IF exist_control%FOUND THEN
         OPEN get_line_no;
         FETCH get_line_no INTO line_item_no_;
         CLOSE get_line_no;
      END IF;
      CLOSE exist_control;
   ELSE
      OPEN get_line_no;
      FETCH get_line_no INTO line_item_no_;
      CLOSE get_line_no;
   END IF;
   IF (line_item_no_ IS NULL) THEN
      line_item_no_ := 1;
   ELSIF (line_item_no_ > 999) THEN
      line_item_no_ := 0;
   END IF;
END Get_Next_Line_Item_No;


-- Get_Catalog_No_For_Part_No
--   Return sales part number for a given inventory part.
--   Note that there could be several matches. Only the first catalog_no will
--   be returned.
@UncheckedAccess
FUNCTION Get_Catalog_No_For_Part_No (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   catalog_no_ SALES_PART_TAB.catalog_no%TYPE;
   CURSOR get_catalog IS
      SELECT catalog_no
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_
      ORDER BY activeind DESC;
BEGIN
   OPEN  get_catalog;
   FETCH get_catalog INTO catalog_no_;
   IF get_catalog%NOTFOUND THEN
      catalog_no_ := NULL;
   END IF;
   CLOSE get_catalog;
   RETURN catalog_no_;
END Get_Catalog_No_For_Part_No;


-- Exist_Purch_Part
--   Get no of purchase parts for the specific sales part
FUNCTION Exist_Purch_Part (
   contract_      IN VARCHAR2,
   purchase_part_ IN VARCHAR2 ) RETURN NUMBER
IS
no_of_sales_parts_   NUMBER;

CURSOR count_sales_parts IS
   SELECT COUNT(*)
      FROM SALES_PART_TAB
      WHERE contract = contract_
      AND purchase_part_no =purchase_part_ ;
BEGIN
   OPEN count_sales_parts;
   FETCH count_sales_parts INTO no_of_sales_parts_;
   CLOSE count_sales_parts;
   RETURN no_of_sales_parts_;
END Exist_Purch_Part;


-- Get_Catalog_No_For_Purch_No
--   Return sales part number for a given purchase part.
@UncheckedAccess
FUNCTION Get_Catalog_No_For_Purch_No (
   contract_         IN VARCHAR2,
   purchase_part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   catalog_no_ SALES_PART_TAB.catalog_no%TYPE;
   CURSOR get_catalog IS
      SELECT catalog_no
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    purchase_part_no = purchase_part_no_;
BEGIN
   OPEN  get_catalog;
   FETCH get_catalog INTO catalog_no_;
   IF get_catalog%NOTFOUND THEN
      catalog_no_ := NULL;
   END IF;
   CLOSE get_catalog;
   RETURN catalog_no_;
END Get_Catalog_No_For_Purch_No;


-- Get_Unit_Meas
--   Returns the inventory unit measure for a specific sales part.
@UncheckedAccess
FUNCTION Get_Unit_Meas (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Inventory_Part_API.Get_Unit_Meas(contract_, Get_Part_No(contract_, catalog_no_));
END Get_Unit_Meas;


-- Get_Default_Supply_Code
--   Return the default supply code for this sales part. The default supply code will be based on the SourcingOption.
@UncheckedAccess
FUNCTION Get_Default_Supply_Code (
   contract_        IN VARCHAR2,
   catalog_no_      IN VARCHAR2,
   rental_db_       IN VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2
IS
   catalog_type_        SALES_PART_TAB.catalog_type%TYPE;
   part_no_             SALES_PART_TAB.part_no%TYPE;
   sourcing_option_     SALES_PART_TAB.sourcing_option%TYPE;
   purchase_part_no_    SALES_PART_TAB.purchase_part_no%TYPE;
   configurable_        VARCHAR2(20);
   supply_code_         VARCHAR2(3);
   supply_category_     VARCHAR2(20) := NULL;
   default_vendor_no_   VARCHAR2(20);

   CURSOR get_flags IS
      SELECT catalog_type, part_no, sourcing_option, purchase_part_no
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    catalog_no = catalog_no_;
BEGIN
   OPEN  get_flags;
   FETCH get_flags INTO catalog_type_, part_no_, sourcing_option_, purchase_part_no_;
   CLOSE get_flags;

   IF (catalog_type_ = 'PKG') THEN
      supply_code_ := 'PKG';
   ELSIF (sourcing_option_ = 'DOPORDER') THEN
      supply_code_ := 'DOP';
   ELSIF (sourcing_option_ = 'INVENTORYORDER') THEN
      configurable_ := Part_Catalog_API.Get_Configurable_Db(nvl(part_no_, catalog_no_));
      -- if the part is configured set the supply code to 'Not Decided'
      IF (configurable_ = 'CONFIGURED') THEN
         supply_code_ := 'ND';
      ELSE
         supply_code_ := 'IO';
      END IF;
   ELSIF (sourcing_option_ = 'NOTSUPPLIED') THEN
      supply_code_ := 'NO';
   ELSIF (sourcing_option_ = 'NOTDECIDED') THEN
      supply_code_ := 'ND';
   ELSIF (sourcing_option_ = 'USESOURCINGRULE') THEN
      supply_code_ := 'SRC';
   ELSIF (sourcing_option_ = 'SHOPORDER') THEN
      supply_code_ := 'SO';
   ELSIF (sourcing_option_ = 'PRODUCTIONSCHEDULE') THEN
      supply_code_ := 'PS';
   ELSE
      -- if Purchase module is installed
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         IF rental_db_ = Fnd_Boolean_API.DB_FALSE THEN
            default_vendor_no_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(contract_, NVL(part_no_, purchase_part_no_));
         ELSE
            default_vendor_no_ := Purchase_Part_Supplier_API.Get_Primary_Rental_Supplier_No(contract_, NVL(part_no_, purchase_part_no_));
         END IF;
         supply_category_ := Supplier_Category_API.Encode(Supplier_API.Get_Category(default_vendor_no_)); 
      $END

      IF (supply_category_ IS NOT NULL) THEN
         IF (sourcing_option_ = 'PRIMARYSUPPTRANSIT') THEN
            -- IF Primary supplier is an External supplier
            IF (supply_category_ = 'E') THEN
               supply_code_ := 'PT';
            ELSE
               supply_code_ := 'IPT';
            END IF;

         ELSIF (sourcing_option_ = 'PRIMARYSUPPDIRECT') THEN
            -- IF Primary supplier is an External supplier
            IF (supply_category_ = 'E') THEN
               supply_code_ := 'PD';
            ELSE
               supply_code_ := 'IPD';
            END IF;
         END IF;
      END IF;
   END IF;

   RETURN Order_Supply_Type_API.Decode(supply_code_);
END Get_Default_Supply_Code;


-- Get_Configurable
--   Fetch CTO configuration client value from part_catalog for a specified sales part.
@UncheckedAccess
FUNCTION Get_Configurable (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   part_no_ SALES_PART_TAB.part_no%TYPE;
BEGIN
   part_no_ := Get_Part_No(contract_, catalog_no_);
   RETURN Part_Catalog_API.Get_Configurable(nvl(part_no_, catalog_no_));
END Get_Configurable;


-- Get_Configurable_Db
--   Fetch configuration db value from part_catalog for a specified sales part
@UncheckedAccess
FUNCTION Get_Configurable_Db (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   part_no_ SALES_PART_TAB.part_no%TYPE;
BEGIN
   part_no_ := Get_Part_No(contract_, catalog_no_);
   RETURN Part_Catalog_API.Get_Configurable_Db(nvl(part_no_, catalog_no_));
END Get_Configurable_Db;


-- Catalog_No_Exist
--   Ckecks, if catalog no exists on any site.
PROCEDURE Catalog_No_Exist (
   catalog_no_ IN VARCHAR2 )
IS
   temp_ SALES_PART_TAB.catalog_no%TYPE;

   CURSOR get_attr IS
    SELECT catalog_no
    FROM SALES_PART_TAB
    WHERE catalog_no = catalog_no_
    AND EXISTS (SELECT 1 FROM user_allowed_site_pub
                WHERE contract = site);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%NOTFOUND THEN
      CLOSE get_attr;
      Error_SYS.Record_General (lu_name_, 'CATALOG_NOTFOUND: The sales part :P1 does not exist', catalog_no_);
   END IF;
   CLOSE get_attr;
END Catalog_No_Exist;


-- Get_No_Of_Sales_Parts_For_Part
--   Returns the number of sales parts connected to the specified inventory part.
@UncheckedAccess
FUNCTION Get_No_Of_Sales_Parts_For_Part (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   no_of_sales_parts_ NUMBER;

   CURSOR count_sales_parts IS
      SELECT count(*)
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_;
BEGIN
   OPEN count_sales_parts;
   FETCH count_sales_parts INTO no_of_sales_parts_;
   CLOSE count_sales_parts;
   RETURN no_of_sales_parts_;
END Get_No_Of_Sales_Parts_For_Part;


-- New
--   Public interface for creating a new sales part.
--   Used by WebStore.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
   new_attr_   VARCHAR2(2000);
   newrec_     SALES_PART_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN

   -- Retrieve the default attribute values.
   Client_SYS.Add_To_Attr('CONTRACT', Client_SYS.Get_Item_Value('CONTRACT', attr_), new_attr_);
   Client_SYS.Add_To_Attr('CATALOG_TYPE_DB', Client_SYS.Get_Item_Value('CATALOG_TYPE_DB', attr_), new_attr_);
   Client_SYS.Add_To_Attr('QUICK_REGISTERED_PART_DB', Client_SYS.Get_Item_Value('QUICK_REGISTERED_PART_DB', attr_), new_attr_);

   -- Retrieve the default attribute values.
   Prepare_Insert___(new_attr_);

   --Replace the default attribute values with the ones passed in the inparameterstring.
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
   END LOOP;

   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);
   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;
END New;


-- Check_Exist
--   Public interface for checking if sales part exist.
--   Returns 1 for true and 0 for false
@UncheckedAccess
FUNCTION Check_Exist (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(contract_, catalog_no_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Exist;


-- Modify_List_Price
--   Update list price for a specific catalog_no.
PROCEDURE Modify_List_Price (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2,
   list_price_ IN NUMBER )
IS
   newrec_     SALES_PART_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(contract_, catalog_no_);
   newrec_.list_price := list_price_;
   Modify___(newrec_);
END Modify_List_Price;


-- Part_Configurable_At_Any_Site
--   Return TRUE (1) if a sales part with the specified part number
--   is set to configurable at any site.
@UncheckedAccess
FUNCTION Part_Configurable_At_Any_Site (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;

   CURSOR check_sales_part IS
      SELECT 1
      FROM   SALES_PART_TAB
      WHERE  part_no = part_no_;

BEGIN
   IF (Part_Catalog_API.Get_Configurable_Db(part_no_) = 'CONFIGURED') THEN
      OPEN check_sales_part;
      FETCH check_sales_part INTO found_;
      IF (check_sales_part%NOTFOUND) THEN
         CLOSE check_sales_part;
         -- Part is configurable but does not exist as a sales part on any site.
         RETURN 0;
      ELSE
         CLOSE check_sales_part;
         RETURN 1;
      END IF;
   ELSE
      -- The part is not configurable
      RETURN 0;
   END IF;
END Part_Configurable_At_Any_Site;


-- Get_Purch_No_For_Catalog_No
--   Return inventory part number for a given sales part.
@UncheckedAccess
FUNCTION Get_Purch_No_For_Catalog_No (
   catalog_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   part_no_  VARCHAR2(25);
   CURSOR Get_Purch_No_For_Catalog_No IS
      SELECT purchase_part_no
      FROM sales_part_tab
      WHERE catalog_no = catalog_no_;
BEGIN
   OPEN Get_Purch_No_For_Catalog_No;
   FETCH Get_Purch_No_For_Catalog_No INTO part_no_;
   CLOSE Get_Purch_No_For_Catalog_No;
   RETURN part_no_;
END Get_Purch_No_For_Catalog_No;


-- Get_Characteristics
--   Returns the characteristics of a sales part packed in a message
PROCEDURE Get_Characteristics (
   info_message_ IN OUT VARCHAR2,
   contract_     IN     VARCHAR2,
   catalog_no_   IN     VARCHAR2 )
IS
   msg_attr_         VARCHAR2(32000);

   CURSOR get_characteristics IS
      SELECT catalog_no,
             contract,
             characteristic_code,
             Characteristic_API.Get_Description(characteristic_code)    description,
             attr_value,
             unit_meas,
             Characteristic_API.Get_Search_Type(characteristic_code)   search_type
      FROM  sales_part_characteristic_tab
      WHERE contract = contract_
      AND   catalog_no = catalog_no_;

BEGIN
   FOR rec_ IN get_characteristics LOOP
      -- Note: The description
      msg_attr_ := Message_SYS.Construct(rec_.characteristic_code || '_DESC');
      Message_SYS.Add_Attribute( msg_attr_ , 'DATATYPE', 'string' );
      Message_SYS.Add_Attribute( msg_attr_ , 'VALUE', rec_.description );
      Message_SYS.Add_Attribute( info_message_, rec_.characteristic_code || '_DESC', msg_attr_ );

      -- Note: The value
      msg_attr_ := Message_SYS.Construct(rec_.characteristic_code || '_VALUE');
      IF (Alpha_Numeric_API.Encode( rec_.search_type) = 'N') THEN
         Message_SYS.Add_Attribute( msg_attr_ , 'DATATYPE', 'float' );
      ELSE
         Message_SYS.Add_Attribute( msg_attr_ , 'DATATYPE', 'string' );
      END IF;
      Message_SYS.Add_Attribute( msg_attr_ , 'VALUE', rec_.attr_value );
      Message_SYS.Add_Attribute( info_message_, rec_.characteristic_code || '_VALUE', msg_attr_ );

      -- Note: The UOM
      msg_attr_ := Message_SYS.Construct(rec_.characteristic_code || '_UOM');
      Message_SYS.Add_Attribute( msg_attr_ , 'DATATYPE', 'string' );
      Message_SYS.Add_Attribute( msg_attr_ , 'VALUE', rec_.unit_meas );
      Message_SYS.Add_Attribute( info_message_, rec_.characteristic_code || '_UOM', msg_attr_ );
   END LOOP;

END Get_Characteristics;


-- Get_Desc_Lang_Attr
--   Returns the Language and the catalog descriptions of a sales part
@UncheckedAccess
FUNCTION Get_Desc_Lang_Attr (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   attr_    VARCHAR2(32000);
   CURSOR get_desc IS
      SELECT language_code, catalog_desc
      FROM   sales_part_language_desc_tab
      WHERE  contract   = contract_
      AND    catalog_no = catalog_no_;
BEGIN
   FOR rec_ IN get_desc LOOP
      Client_SYS.Add_To_Attr(rec_.language_code, rec_.catalog_desc , attr_);
   END LOOP;

   RETURN (attr_);
END Get_Desc_Lang_Attr;


-- Is_Part_Used
--   Checks for a part no at all sites
FUNCTION Is_Part_Used (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SALES_PART_TAB
      WHERE  part_no = part_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN db_true_;
   END IF;
   CLOSE exist_control;
   RETURN db_false_;
END Is_Part_Used;


-- Modify
--   General function to modify attribute values.
PROCEDURE Modify (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2,
   attr_       IN VARCHAR2 )
IS
   oldrec_             SALES_PART_TAB%ROWTYPE;
   newrec_             SALES_PART_TAB%ROWTYPE;
   newattr_            VARCHAR2(2000);
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
   indrec_             Indicator_Rec;
BEGIN
   newattr_ := attr_;
   oldrec_  := Lock_By_Keys___(contract_,catalog_no_);
   newrec_  := oldrec_;
   Unpack___(newrec_, indrec_, newattr_);
   Check_Update___(oldrec_, newrec_, indrec_, newattr_);
   Update___(objid_, oldrec_, newrec_, newattr_, objversion_, TRUE);
END Modify;


-- Get_Catalog_From_Cross_Ref
--   Get the customer part from Sales Part Cross Reference which is
--   connected to a specific sales part.
@UncheckedAccess
FUNCTION Get_Catalog_From_Cross_Ref (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cust_part_no_  VARCHAR2(75);
   catalog_no_    VARCHAR2(75);

   CURSOR get_sales_parts IS
      SELECT catalog_no
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_;
BEGIN
   FOR rec_ IN get_sales_parts LOOP
      cust_part_no_:= Sales_Part_Cross_Reference_API.Get_Customer_Part_No(customer_no_,contract_,rec_.catalog_no);
      IF cust_part_no_ IS NULL THEN
         catalog_no_ := NULL;
      ELSE
         catalog_no_ := rec_.catalog_no;
         EXIT;
      END IF;
   END LOOP;
   RETURN catalog_no_;
END Get_Catalog_From_Cross_Ref;


-- Is_Same_Catalog_No_For_Part_No
--   Return 1 if there is a sales part which has a catalog no similar to the inventory part no
--   for a specific site.
@UncheckedAccess
FUNCTION Is_Same_Catalog_No_For_Part_No (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   exist_ NUMBER;

   CURSOR get_sales_parts IS
      SELECT catalog_no
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_;
BEGIN
   FOR rec_ IN get_sales_parts LOOP
      IF (rec_.catalog_no= part_no_) THEN
         exist_ := 1;
         EXIT;
      ELSE
         exist_ := 0;
      END IF;
   END LOOP;
   RETURN exist_;
END Is_Same_Catalog_No_For_Part_No;


-- Exist_Mum_Inv_Part
--   Check whether for a given inventory part there exist sales parts which
--   the convesion factor (Inventory U/M and Sales U/M)is not equal to 1.
@UncheckedAccess
FUNCTION Exist_Mum_Inv_Part (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_convfnot_1 IS
      SELECT 1
      FROM   SALES_PART_TAB
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   (conv_factor <> 1 OR inverted_conv_factor <> 1);

BEGIN
   OPEN exist_convfnot_1;
   FETCH exist_convfnot_1 INTO dummy_;
   IF exist_convfnot_1%NOTFOUND  THEN
      dummy_ := 0;
   END IF;
   CLOSE exist_convfnot_1;
   RETURN dummy_;
END Exist_Mum_Inv_Part;


-- Get_Catalog_Desc_For_Lang
--   Note: Return catalog description if language description exists, else the default
@UncheckedAccess
FUNCTION Get_Catalog_Desc_For_Lang (
   contract_      IN VARCHAR2,
   catalog_no_    IN VARCHAR2,
   language_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   catalog_desc_ sales_part_language_desc_tab.catalog_desc%TYPE;
   CURSOR get_attr IS
      SELECT catalog_desc
      FROM   sales_part_language_desc_tab
      WHERE  contract = contract_
      AND    catalog_no = catalog_no_
      AND    language_code = language_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO catalog_desc_;
   IF (get_attr%NOTFOUND) THEN
      catalog_desc_ := Get_Catalog_Desc(contract_, catalog_no_, language_code_);
   END IF;
   CLOSE get_attr;
   RETURN catalog_desc_;
END Get_Catalog_Desc_For_Lang;


-- Check_Exist_On_User_Site
--   This method checks if the given part number exists in at least one user
--   allowed site, and if so, returns 'TRUE' ('FALSE' otherwise).
@UncheckedAccess
FUNCTION Check_Exist_On_User_Site (
   catalog_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM  SALES_PART_TAB sp, USER_ALLOWED_SITE_PUB uas
      WHERE sp.contract = uas.site
      AND   sp.catalog_no = catalog_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN('TRUE');
   END IF;
   CLOSE exist_control;
   RETURN('FALSE');
END Check_Exist_On_User_Site;


-- Check_Limit_Sales_To_Assort
--   This method checks if the given part is restricted for the given customer.
@UncheckedAccess
PROCEDURE Check_Limit_Sales_To_Assort (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2,
   customer_no_ IN VARCHAR2 )
IS
BEGIN
   IF (Is_Part_Available_For_Cust(contract_, catalog_no_, customer_no_) = 'NOT_AVAILABLE') THEN
      Error_SYS.Record_General(lu_name_,'CHECKLIMITSALESTOASSORT: Sales part :P1 is not connected to assortments limited to customer :P2.',catalog_no_, customer_no_ );
   END IF;
END Check_Limit_Sales_To_Assort;

@UncheckedAccess
FUNCTION Is_Part_Available_For_Cust (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2,
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   NUMBER;
   
   CURSOR limit_sales IS
      SELECT 1
      FROM  Limit_To_Assort_Sales_Part_Lov sp
      WHERE sp.contract  = contract_
      AND   sp.catalog_no  = catalog_no_
      AND   sp.customer_no  = customer_no_;
BEGIN
	OPEN limit_sales;
   FETCH limit_sales INTO dummy_;
   IF (limit_sales%NOTFOUND) THEN
      CLOSE limit_sales;
      RETURN 'NOT_AVAILABLE';
   END IF;
   CLOSE limit_sales;
	RETURN 'AVAILABLE';
END Is_Part_Available_For_Cust;

-- Check_Enable_Catch_Unit
--   Check whether the catch_unit_enabled part is defined as a non-inventory sales part or a package part.
--   If there are sales parts for a given part no get the price unit of measure of those.
--   If all the parts have the same Price UoM set the common price uom to that otherwise set to null.
PROCEDURE Check_Enable_Catch_Unit (
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   catch_unit_code_ IN VARCHAR2 )
IS
   CURSOR sales_part IS
      SELECT count(*)
      FROM   SALES_PART_TAB
      WHERE  price_unit_meas != catch_unit_code_
      AND    part_no          = part_no_
      AND    contract         = contract_;
   temp_     NUMBER := 0;
BEGIN

   OPEN sales_part;
   FETCH sales_part INTO temp_;
   CLOSE sales_part;

   IF (Is_Part_Used(part_no_) = db_true_) AND (temp_ > 0 ) THEN
      Error_SYS.Record_General(lu_name_,'NOUPDATESALESEXIST: Cannot enable Catch Unit when there exist sales parts with Price U/M different to Catch Unit Code.');
   END IF;

END Check_Enable_Catch_Unit;


-- Check_Enable_Catch_Unit
--   Check whether the catch_unit_enabled part is defined as a non-inventory sales part or a package part.
--   If there are sales parts for a given part no get the price unit of measure of those.
--   If all the parts have the same Price UoM set the common price uom to that otherwise set to null.
PROCEDURE Check_Enable_Catch_Unit (
   part_no_         IN VARCHAR2 )
IS
   contract_       SALES_PART_TAB.contract%TYPE;
   catalog_type_    SALES_PART_TAB.Catalog_Type%TYPE;

   CURSOR get_contract_catalog_type  IS
      SELECT contract, catalog_type
      FROM   SALES_PART_TAB
      WHERE  catalog_no = part_no_
      AND    catalog_type IN ('NON', 'PKG');
BEGIN

   OPEN get_contract_catalog_type ;
   FETCH get_contract_catalog_type  INTO contract_, catalog_type_;
   CLOSE get_contract_catalog_type ;

   IF (contract_ IS NOT NULL) THEN
      IF (catalog_type_ = 'NON') THEN
         Error_SYS.Record_General('SalesPart', 'NONINVSALEPARTEXIST: Part Number :P1 is defined as a non-inventory sales part on Site :P2. Catch Unit Handling is not allowed for non-inventory parts.', part_no_, contract_);
      END IF;
      IF (catalog_type_ = 'PKG') THEN
         Error_SYS.Record_General('SalesPart', 'NONINVPKGEXIST: Part Number :P1 is defined as a package part on Site :P2. Catch Unit Handling is not allowed for package parts.', part_no_, contract_);
      END IF;
   END IF;

END Check_Enable_Catch_Unit;


@UncheckedAccess
FUNCTION Get_Total_Cost (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_sums IS
      SELECT NVL(SUM((NVL(Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead(spp.contract,
                 SALES_PART_API.Get_Part_No(contract_, spp.catalog_no), NULL, NULL, NULL,
                 'CHARGED ITEM', NULL, NULL, NULL), 0)  * spp.qty_per_assembly) * sp.conv_factor/sp.inverted_conv_factor), 0)           inventory_sum,
             NVL(SUM(sp.cost * spp.qty_per_assembly), 0)                                        non_inventory_sum
      FROM   sales_part_package_tab spp, SALES_PART_TAB sp
      WHERE  spp.contract     = contract_
      AND    spp.parent_part  = catalog_no_
      AND    spp.contract     = sp.contract
      AND    spp.catalog_no   = sp.catalog_no;

   inv_sum_             NUMBER;
   non_inv_sum_         NUMBER;
BEGIN
   OPEN get_sums;
   FETCH get_sums INTO inv_sum_, non_inv_sum_;
   CLOSE get_sums;

   RETURN (inv_sum_ + non_inv_sum_);
END Get_Total_Cost;


-- Check_Inv_Part_Planning_Data
--   Performs some checks on some parameters from Inventory Part Planning and Sourcing Options
PROCEDURE Check_Inv_Part_Planning_Data (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   order_requisition_ IN VARCHAR2,
   planning_method_   IN VARCHAR2 )
IS
   CURSOR get_sourcing_options IS
      SELECT sourcing_option
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    part_no  = part_no_;
BEGIN

   -- check if any related sales part are using the correct combination of sourcing_option
   -- with parts order_requisition and planning_method from the inventory part
   FOR sales_part_rec_ IN get_sourcing_options LOOP
      -- Modified the condition to allow sourcing options for PRIMARYSUPPDIRECT and PRIMARYSUPPTRANSIT and modified the error message.
      -- supply type cant be DOP if the sourcing options isnt DOPORDER, INVENTORYORDER, PRIMARYSUPPTRANSIT or PRIMARYSUPPDIRECT
      IF (order_requisition_ = 'D' and sales_part_rec_.sourcing_option NOT IN ('DOPORDER','INVENTORYORDER', 'PRIMARYSUPPTRANSIT', 'PRIMARYSUPPDIRECT')) THEN
         Error_SYS.Record_General(lu_name_, 'DOPINVENTORDERONLY2: Supply Type can only be set to DOP if Sourcing Option on related sales parts is either either Inventory Order, DOP Order, Primary Supplier Transit or Primary Supplier Direct');
      END IF;
      -- DOP order sourcing option and mrp order code N is not allowed
      IF (sales_part_rec_.sourcing_option = 'DOPORDER' AND planning_method_ = 'N') THEN
          Error_SYS.Record_General(lu_name_, 'MRPCODEPNNOTALLOWED2: MRP Order Code cannot be set to P or N if sourcing option on any related sales part is :P1',
                          Sourcing_Option_API.Decode(sales_part_rec_.sourcing_option));
      END IF;
   END LOOP;

END Check_Inv_Part_Planning_Data;


-- Src_Option_Must_Be_Dop_Or_So
--   Checks if connected sales parts have sourcing option DOPORDER or SHOPORDER
@UncheckedAccess
FUNCTION Src_Option_Must_Be_Dop_Or_So (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER := 1;
   dummy_ NUMBER;
   CURSOR find_non_dop_so_parts IS
      SELECT 1
      FROM   SALES_PART_TAB
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   sourcing_option NOT IN ('DOPORDER','SHOPORDER');

BEGIN
   OPEN find_non_dop_so_parts;
   FETCH find_non_dop_so_parts INTO dummy_;
   IF find_non_dop_so_parts%FOUND  THEN
      found_ := 0;
   END IF;
   CLOSE find_non_dop_so_parts;
   RETURN found_;
END Src_Option_Must_Be_Dop_Or_So;


-- Copy_Characteristics
--   This method copies characteristics of a given part to another part.
PROCEDURE Copy_Characteristics (
   from_contract_            IN VARCHAR2,
   from_part_no_             IN VARCHAR2,
   to_contract_              IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   newrec_         SALES_PART_TAB%ROWTYPE;
   frompartrec_    SALES_PART_TAB%ROWTYPE;
   exit_procedure_ EXCEPTION;
BEGIN

   frompartrec_ := Get_Object_By_Keys___(from_contract_, from_part_no_);

   IF ((frompartrec_.part_no IS NULL) AND (frompartrec_.catalog_type = 'INV')) THEN
      IF (error_when_no_source_ = db_true_) THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'SPNOTEXIST: Sales Part :P1 does not exist on site :P2', from_part_no_, from_contract_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;

   IF (frompartrec_.eng_attribute IS NULL) THEN
      IF (error_when_no_source_ = db_true_) THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'SPNOCHARTEMP: Characteristic template does not exist for part :P1 on site :P2', from_part_no_, from_contract_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;

   IF NOT (Check_Exist___(to_contract_, to_part_no_)) THEN
      RAISE exit_procedure_;
   END IF;

   newrec_ := Get_Object_By_Keys___(to_contract_, to_part_no_);

   IF (newrec_.eng_attribute IS NOT NULL) THEN
      IF (error_when_existing_copy_ = db_true_) THEN
         Error_SYS.Record_Exist(lu_name_, 'SPCHARTEMPEXIST: Characteristic template does already exist for part :P1 on site :P2', to_part_no_, to_contract_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;

   newrec_.eng_attribute := frompartrec_.eng_attribute;
   Modify___(newrec_);

   Sales_Part_Characteristic_API.Copy(from_contract_,
                                      from_part_no_,
                                      to_contract_,
                                      to_part_no_,
                                      error_when_no_source_,
                                      error_when_existing_copy_);
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Copy_Characteristics;


-- Copy_Connected_Objects
--   This method copies connected objects of a given part to another part.
PROCEDURE Copy_Connected_Objects (
   from_contract_            IN VARCHAR2,
   from_part_no_             IN VARCHAR2,
   to_contract_              IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   objid_               SALES_PART.objid%TYPE;
   objversion_          SALES_PART.objversion%TYPE;
   source_key_ref_      VARCHAR2(2000);
   destination_key_ref_ VARCHAR2(2000);   
BEGIN

   Get_Id_Version_By_Keys___(objid_,
                             objversion_,
                             to_contract_,
                             to_part_no_);


   source_key_ref_      := Client_SYS.Get_Key_Reference(lu_name_, 'CATALOG_NO', from_part_no_,
                                                                  'CONTRACT', from_contract_);

   destination_key_ref_ := Client_SYS.Get_Key_Reference(lu_name_, 'CATALOG_NO', to_part_no_,
                                                                  'CONTRACT', to_contract_);
   $IF (Component_Docman_SYS.INSTALLED) $THEN
      Doc_Reference_Object_API.Copy(lu_name_,
                                    source_key_ref_,
                                    lu_name_,
                                    destination_key_ref_,
                                    '',
                                    error_when_no_source_,
                                    error_when_existing_copy_); 
      
      Approval_Routing_API.Copy_App_Route(lu_name_,
                                          source_key_ref_,
                                          lu_name_,
                                          objid_,
                                          error_when_no_source_);
   $END
  
   Technical_Object_Reference_API.Copy(lu_name_,
                                       source_key_ref_,
                                       destination_key_ref_,
                                       error_when_no_source_,
                                       error_when_existing_copy_);
END Copy_Connected_Objects;


-- Copy_Note_Texts
--   This method copies the note texts from a given part to another part.
PROCEDURE Copy_Note_Texts (
   from_contract_            IN VARCHAR2,
   from_part_no_             IN VARCHAR2,
   to_contract_              IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   from_note_id_ SALES_PART_TAB.note_id%TYPE;
   to_note_id_   SALES_PART_TAB.note_id%TYPE;
BEGIN

   from_note_id_ := Get_Note_Id(from_contract_ , from_part_no_);
   to_note_id_   := Get_Note_Id(to_contract_   , to_part_no_);

   Document_Text_API.Copy_All_Note_Texts(from_note_id_,
                                         to_note_id_,
                                         error_when_no_source_,
                                         error_when_existing_copy_);
END Copy_Note_Texts;

-----------------------------------------------------------------------------
-- Copy_Customer_Warranty
--    This method copies the customer warranty from a given part to another part.
-----------------------------------------------------------------------------
PROCEDURE Copy_Customer_Warranty (
   from_contract_            IN VARCHAR2,
   from_part_no_             IN VARCHAR2,
   to_contract_              IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   cust_warranty_id_ SALES_PART_TAB.cust_warranty_id%TYPE;
   attr_             VARCHAR2(32000);
   objid_            ROWID;
   objversion_       VARCHAR2(2000);
   newrec_           SALES_PART_TAB%ROWTYPE;
   oldrec_           SALES_PART_TAB%ROWTYPE;
   frompartrec_      SALES_PART_TAB%ROWTYPE;
   exit_procedure_   EXCEPTION;
   append_warranties_ BOOLEAN := FALSE;
   new_warranty_id_   SALES_PART_TAB.cust_warranty_id%TYPE;
   indrec_            Indicator_Rec;
BEGIN
   
   frompartrec_ := Get_Object_By_Keys___(from_contract_, from_part_no_);
   IF ((frompartrec_.part_no IS NULL) AND (frompartrec_.catalog_type = 'INV')) THEN
      IF (error_when_no_source_ = db_true_) THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'SPNOTEXIST: Sales Part :P1 does not exist on site :P2', from_part_no_, from_contract_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;
   
   cust_warranty_id_ := frompartrec_.cust_warranty_id;
   
   IF (frompartrec_.cust_warranty_id IS NOT NULL) THEN      
      newrec_ := Get_Object_By_Keys___(to_contract_, to_part_no_);      
      IF (newrec_.cust_warranty_id IS NOT NULL) THEN
         IF (newrec_.cust_warranty_id = cust_warranty_id_) THEN
            IF (error_when_existing_copy_ = 'TRUE') THEN
               Error_SYS.Record_Exist(lu_name_, 'CUSWAREXIST: Customer Warranty :P1 does already exist for the part :P2 for the site :P3.', cust_warranty_id_, to_part_no_, to_contract_);               
            END IF;               
         ELSE
            append_warranties_ := TRUE;
            -- If both sales parts have warranties, must merge warranty details 
            Cust_Warranty_API.Copy_Cust_Warranty(new_warranty_id_, frompartrec_.cust_warranty_id, newrec_.cust_warranty_id, error_when_no_source_, error_when_existing_copy_);
         END IF;
      ELSE
         Cust_Warranty_API.Inherit(frompartrec_.cust_warranty_id);
      END IF;      
      IF (append_warranties_) THEN
         cust_warranty_id_ := new_warranty_id_;
      END IF;
      
      newrec_.cust_warranty_id := cust_warranty_id_;
      Modify___(newrec_);
   END IF;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;   
END Copy_Customer_Warranty;

-- Copy_Language_Descriptions
--   Calls Sales_Part_Language_Desc_API.Copy to copy the language descriptions from one part to another
PROCEDURE Copy_Language_Descriptions (
   from_contract_            IN VARCHAR2,
   from_part_no_             IN VARCHAR2,
   to_contract_              IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   frompartrec_    SALES_PART_TAB%ROWTYPE;
   exit_procedure_ EXCEPTION;

BEGIN

   frompartrec_ := Get_Object_By_Keys___(from_contract_, from_part_no_);

   IF ((frompartrec_.part_no IS NULL) AND (frompartrec_.catalog_type = 'INV')) THEN
      IF (error_when_no_source_ = db_true_) THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'SPNOTEXIST: Sales Part :P1 does not exist on site :P2', from_part_no_, from_contract_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;

   IF NOT (Check_Exist___(to_contract_, to_part_no_)) THEN
      RAISE exit_procedure_;
   END IF;

   Sales_Part_Language_Desc_API.Copy(from_contract_,
                                     from_part_no_,
                                     to_contract_,
                                     to_part_no_,
                                     error_when_no_source_,
                                     error_when_existing_copy_);
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Copy_Language_Descriptions;


-- Copy
--   Duplicates a SalesPart.
PROCEDURE Copy (
   from_contract_            IN VARCHAR2,
   from_part_no_             IN VARCHAR2,
   to_contract_              IN VARCHAR2,
   to_part_no_               IN VARCHAR2,
   to_part_desc_             IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2 )
IS
   attr_                       VARCHAR2(32000);
   objid_                      ROWID;
   objversion_                 VARCHAR2(2000);
   newrec_                     SALES_PART_TAB%ROWTYPE;
   rec_                        SALES_PART_TAB%ROWTYPE;
   company_                    VARCHAR2(20);
   exit_procedure_             EXCEPTION;
   from_inv_part_              VARCHAR2(25);
   list_price_                 NUMBER;
   list_price_incl_tax_        NUMBER;
   expected_average_price_     NUMBER;
   cost_                       NUMBER;
   new_use_price_incl_tax_     VARCHAR2(20);
   rental_list_price_          NUMBER;
   rental_list_price_incl_tax_ NUMBER;
   indrec_                     Indicator_Rec;

   CURSOR org_part IS
      SELECT *
      FROM SALES_PART_TAB
      WHERE catalog_no = from_part_no_
      AND contract = from_contract_;
BEGIN
   OPEN org_part;
   FETCH org_part INTO rec_;
   IF org_part%NOTFOUND THEN
      CLOSE org_part;
      IF (error_when_no_source_ = db_true_) THEN
         Error_SYS.Record_General(lu_name_, 'SPNOTFOUND: The sales part :P1 does not exist on site :P2.', from_part_no_, from_contract_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   ELSE
      CLOSE org_part;
   END IF;

   IF (error_when_existing_copy_ = db_false_) THEN
      IF (Check_Exist___(to_contract_, to_part_no_)) THEN
         RAISE exit_procedure_;
      END IF;
   END IF;

   -- list_price, expected_average_price and the cost should be converted to the currency of the to_contract_'s company currency
   list_price_                 := Site_API.Get_Currency_Converted_Amount(from_contract_, to_contract_, rec_.list_price);
   list_price_incl_tax_        := Site_API.Get_Currency_Converted_Amount(from_contract_, to_contract_, rec_.list_price_incl_tax);
   cost_                       := Site_API.Get_Currency_Converted_Amount(from_contract_, to_contract_, rec_.cost);
   expected_average_price_     := Site_API.Get_Currency_Converted_Amount(from_contract_, to_contract_, rec_.expected_average_price);
   rental_list_price_          := Site_API.Get_Currency_Converted_Amount(from_contract_, to_contract_, rec_.rental_list_price);
   rental_list_price_incl_tax_ := Site_API.Get_Currency_Converted_Amount(from_contract_, to_contract_, rec_.rental_list_price_incl_tax);
 
   company_                    := Site_API.Get_Company(to_contract_);

   Client_SYS.Clear_Attr(attr_);
   newrec_.use_price_incl_tax := rec_.use_price_incl_tax;
   newrec_.contract := to_contract_;
   newrec_.catalog_no := to_part_no_;
   newrec_.catalog_desc := NVL(to_part_desc_, rec_.catalog_desc);
   newrec_.catalog_group := rec_.catalog_group;
   newrec_.sales_price_group_id := rec_.sales_price_group_id;
   newrec_.sales_unit_meas := rec_.sales_unit_meas;
   newrec_.activeind := rec_.activeind;
   newrec_.primary_catalog := rec_.primary_catalog;
   newrec_.catalog_type := rec_.catalog_type;
   newrec_.conv_factor := rec_.conv_factor;
   newrec_.inverted_conv_factor := rec_.inverted_conv_factor;
   newrec_.list_price := list_price_;
   newrec_.list_price_incl_tax := list_price_incl_tax_;
   newrec_.rental_list_price := rental_list_price_;
   newrec_.rental_list_price_incl_tax := rental_list_price_;
   newrec_.price_conv_factor := rec_.price_conv_factor;
   newrec_.taxable := rec_.taxable;
   newrec_.close_tolerance := rec_.close_tolerance;
   newrec_.create_sm_object_option := rec_.create_sm_object_option;
   newrec_.non_inv_part_type := rec_.non_inv_part_type;
   newrec_.sourcing_option := rec_.sourcing_option;

   newrec_.discount_group := rec_.discount_group;
   newrec_.note_text := rec_.note_text;
   newrec_.price_unit_meas := rec_.price_unit_meas;
   newrec_.expected_average_price := expected_average_price_;
   newrec_.rule_id := rec_.rule_id;
   newrec_.quick_registered_part := rec_.quick_registered_part;
   newrec_.minimum_qty := rec_.minimum_qty;
   newrec_.export_to_external_app := rec_.export_to_external_app;
   newrec_.sales_type := rec_.sales_type;
   newrec_.delivery_type := rec_.delivery_type;
   
   $IF (Component_Purch_SYS.INSTALLED) $THEN 
         IF (Purchase_Part_API.Check_Exist(to_contract_, to_part_no_) = 1) THEN
           newrec_.purchase_part_no := rec_.purchase_part_no;
         END IF;     
   $END

   IF (rec_.catalog_type = 'INV') THEN
      from_inv_part_ := rec_.part_no;
      IF (from_inv_part_ != from_part_no_) THEN
         IF NOT (Inventory_Part_API.Check_Exist(to_contract_, from_inv_part_ )) THEN
            Error_SYS.Record_General(lu_name_, 'INVPARTNOTEXIST: Inventory Part :P1 does not exist on Site :P2.', from_inv_part_, to_contract_);
         ELSE
            newrec_.part_no := from_inv_part_;
         END IF;
      ELSE
         IF NOT (Inventory_Part_API.Check_Exist(to_contract_, to_part_no_ )) THEN
            Error_SYS.Record_General(lu_name_, 'INVPARTNOTEXIST: Inventory Part :P1 does not exist on Site :P2.', to_part_no_, to_contract_);
         ELSE
            newrec_.part_no := to_part_no_;
         END IF;
      END IF;
   ELSE
      newrec_.customs_stat_no := rec_.customs_stat_no;
      IF (rec_.catalog_type = 'NON') THEN 
         newrec_.intrastat_conv_factor := rec_.intrastat_conv_factor;   
         newrec_.country_of_origin := rec_.country_of_origin;
      END IF;  
      IF (rec_.catalog_type = 'PKG') THEN
         newrec_.allow_partial_pkg_deliv := rec_.allow_partial_pkg_deliv;
         newrec_.list_price := 0;
         newrec_.list_price_incl_tax := 0;
      END IF;
   END IF;

   newrec_.cost := cost_;
   newrec_.replacement_part_no := rec_.replacement_part_no;
   newrec_.date_of_replacement := rec_.date_of_replacement;
   newrec_.print_control_code := rec_.print_control_code;

   
   newrec_.tax_code := rec_.tax_code;
   newrec_.tax_class_id := rec_.tax_class_id;

   newrec_.sales_part_rebate_group := rec_.sales_part_rebate_group;

   New___(newrec_);
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Copy;


PROCEDURE Calculate_Prices (
   list_price_            IN OUT NUMBER,
   list_incl_tax_         IN OUT NUMBER,
   tax_code_              IN     VARCHAR2,
   contract_              IN     VARCHAR2,
   use_price_incl_tax_    IN     VARCHAR2 )
IS
   tax_percentage_   NUMBER;
BEGIN

   tax_percentage_ := NVL(Statutory_Fee_API.Get_Fee_Rate(Site_API.Get_Company(contract_), tax_code_), 0); 
   IF (use_price_incl_tax_ = 'TRUE') THEN
      list_price_      := list_incl_tax_ / ((tax_percentage_ / 100) + 1);
   ELSE
      list_incl_tax_ := list_price_ * ((tax_percentage_ / 100) + 1);
   END IF;
END Calculate_Prices;


-- Get_Catalog_Desc
--   Retuns the Catalog Description depending on the flag set on SiteDiscomInfo.
@ObjectConnectionMethod
@UncheckedAccess
FUNCTION Get_Catalog_Desc (
   contract_      IN VARCHAR2,
   catalog_no_    IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   catalog_desc_   SALES_PART_TAB.catalog_desc%TYPE;
   CURSOR get_attr IS
      SELECT catalog_desc
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    catalog_no = catalog_no_;
BEGIN
   IF (Site_Discom_Info_API.Get_Use_Partca_Desc_Order_Db(contract_) = db_true_) THEN
      catalog_desc_ := Part_Catalog_API.Get_Description(catalog_no_, language_code_);
   ELSE
      OPEN   get_attr;
      FETCH  get_attr INTO catalog_desc_;
      CLOSE  get_attr;
   END IF;
   RETURN catalog_desc_;
END Get_Catalog_Desc;


-- Create_Sales_Part
--   Creates a sales part with assigned values.
PROCEDURE Create_Sales_Part (
   contract_                IN VARCHAR2,
   catalog_no_              IN VARCHAR2,
   conv_factor_             IN NUMBER,
   inverted_conv_factor_    IN NUMBER,
   price_conv_factor_       IN NUMBER,
   list_price_              IN NUMBER,
   expected_average_price_  IN NUMBER,
   minimum_qty_             IN NUMBER,
   close_tolerance_         IN NUMBER,
   date_of_replacement_     IN DATE,
   sourcing_option_         IN VARCHAR2,
   activeind_               IN VARCHAR2,
   taxable_                 IN VARCHAR2,
   export_to_external_app_  IN VARCHAR2,
   create_sm_object_option_ IN VARCHAR2,
   rule_id_                 IN VARCHAR2,
   sales_unit_meas_         IN VARCHAR2,
   price_unit_meas_         IN VARCHAR2,
   sales_price_group_id_    IN VARCHAR2,
   catalog_group_           IN VARCHAR2,
   discount_group_          IN VARCHAR2,
   tax_code_                IN VARCHAR2,
   replacement_part_no_     IN VARCHAR2,
   delivery_type_           IN VARCHAR2,
   sales_part_rebate_group_ IN VARCHAR2,
   tax_class_id_            IN VARCHAR2 DEFAULT NULL )
IS
   newrec_              SALES_PART_TAB%ROWTYPE;
   objid_               SALES_PART.objid%TYPE;
   objversion_          SALES_PART.objversion%TYPE;
   attr_                VARCHAR2(32000);
   tax_percentage_      NUMBER;
   new_tax_code_        VARCHAR2(20);
   inv_unit_meas_       SALES_PART.sales_unit_meas%TYPE;
   indrec_              Indicator_Rec;
   use_price_incl_tax_  VARCHAR2(20);
   calc_base_           VARCHAR2(10);
   price_               NUMBER := 0; 
   price_incl_tax_      NUMBER := 0;
BEGIN

   Client_SYS.Add_To_Attr('CATALOG_TYPE_DB', 'INV', attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Prepare_Insert___(attr_);

   Client_SYS.Add_To_Attr('CATALOG_TYPE_DB', 'INV', attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_, attr_);
   Client_SYS.Add_To_Attr('CATALOG_DESC', Inventory_Part_API.Get_Description(contract_, catalog_no_), attr_);
   -- only inventory sales parts will be created from assortments structures
   Client_SYS.Add_To_Attr('PART_NO', catalog_no_, attr_); 

   -- replaces the values from Assortmennt Sales Part Defaults
   IF (conv_factor_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('CONV_FACTOR', conv_factor_, attr_);
   END IF;
   IF (inverted_conv_factor_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('INVERTED_CONV_FACTOR', inverted_conv_factor_, attr_);
   END IF;
   IF (price_conv_factor_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('PRICE_CONV_FACTOR', price_conv_factor_, attr_);
   END IF;
   IF (tax_code_ IS NOT NULL OR tax_class_id_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('TAX_CODE', tax_code_, attr_);
      Client_SYS.Set_Item_Value('TAX_CLASS_ID', tax_class_id_, attr_); 
   END IF;
   
   IF (list_price_ IS NOT NULL) THEN
      new_tax_code_        := Client_SYS.Get_Item_Value('TAX_CODE', attr_);
      tax_percentage_      := NVL(Statutory_Fee_API.Get_Fee_Rate(Site_API.Get_Company(contract_), new_tax_code_), 0); 
      use_price_incl_tax_  := Client_SYS.Get_Item_Value('USE_PRICE_INCL_TAX_DB', attr_);
      IF (use_price_incl_tax_ = Fnd_Boolean_API.DB_TRUE) THEN
         calc_base_      := 'GROSS_BASE';
         price_incl_tax_ := list_price_;
      ELSE
         calc_base_ := 'NET_BASE';
         price_     := list_price_; 
      END IF;
      
      Tax_Handling_Util_API.Calculate_Prices(price_, 
                                             price_incl_tax_, 
                                             calc_base_, 
                                             tax_percentage_, 
                                             16);
      Client_SYS.Set_Item_Value('LIST_PRICE', price_, attr_);     
      Client_SYS.Set_Item_Value('LIST_PRICE_INCL_TAX', price_incl_tax_, attr_);   
   END IF;
   IF (expected_average_price_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('EXPECTED_AVERAGE_PRICE', expected_average_price_, attr_);
   END IF;
   IF (minimum_qty_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('MINIMUM_QTY', minimum_qty_, attr_);
   END IF;
   IF (close_tolerance_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('CLOSE_TOLERANCE', close_tolerance_, attr_);
   END IF;
   IF (date_of_replacement_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('DATE_OF_REPLACEMENT', date_of_replacement_, attr_);
   END IF;
   IF (sourcing_option_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('SOURCING_OPTION', sourcing_option_, attr_);
   END IF;
   IF (activeind_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('ACTIVEIND', activeind_, attr_);
   END IF;
   IF (taxable_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('TAXABLE', taxable_, attr_);
   END IF;
   IF (export_to_external_app_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('EXPORT_TO_EXTERNAL_APP', export_to_external_app_, attr_);
   END IF;
   IF (create_sm_object_option_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('CREATE_SM_OBJECT_OPTION', create_sm_object_option_, attr_);
   END IF;
   IF (rule_id_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('RULE_ID', rule_id_, attr_);
   END IF;
   IF (sales_unit_meas_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('SALES_UNIT_MEAS', sales_unit_meas_, attr_);
   END IF;
   IF (price_unit_meas_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('PRICE_UNIT_MEAS', price_unit_meas_, attr_);
   END IF;
   IF (sales_price_group_id_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('SALES_PRICE_GROUP_ID', sales_price_group_id_, attr_);
   END IF;
   IF (catalog_group_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('CATALOG_GROUP', catalog_group_, attr_);
   END IF;
   IF (discount_group_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('DISCOUNT_GROUP', discount_group_, attr_);
   END IF;
   IF (replacement_part_no_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('REPLACEMENT_PART_NO', replacement_part_no_, attr_);
   END IF;
   IF (delivery_type_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('DELIVERY_TYPE', delivery_type_, attr_);
   END IF;
   IF sales_part_rebate_group_ IS NOT NULL THEN
      Client_SYS.Set_Item_Value('SALES_PART_REBATE_GROUP', sales_part_rebate_group_, attr_);
   END IF;


   inv_unit_meas_ := Inventory_Part_API.Get_Unit_Meas(contract_, catalog_no_);

   IF sales_unit_meas_ IS NULL THEN
      Client_SYS.Set_Item_Value('SALES_UNIT_MEAS', inv_unit_meas_, attr_);
   END IF;

   IF price_unit_meas_ IS NULL THEN
      Client_SYS.Set_Item_Value('PRICE_UNIT_MEAS', inv_unit_meas_, attr_);
   END IF;

   IF conv_factor_ IS NULL THEN
      Client_SYS.Add_To_Attr('CONV_FACTOR', Technical_Unit_Conv_API.Get_Valid_Conv_Factor(Client_SYS.Get_Item_Value('SALES_UNIT_MEAS', attr_), inv_unit_meas_), attr_);
   END IF;

   IF price_conv_factor_ IS NULL THEN
      Client_SYS.Add_To_Attr('PRICE_CONV_FACTOR', Technical_Unit_Conv_API.Get_Valid_Conv_Factor(Client_SYS.Get_Item_Value('SALES_UNIT_MEAS', attr_), Client_SYS.Get_Item_Value('PRICE_UNIT_MEAS', attr_)), attr_);
   END IF;
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Create_Sales_Part;


-- Get_All_Notes
--   Fetches Notes Connected to a Sales Part considering the given prority
--   for the Order Flow.
PROCEDURE Get_All_Notes (
   partca_part_note_id_ OUT NUMBER,
   partca_part_notes_   OUT VARCHAR2,
   inv_part_note_id_    OUT NUMBER,
   inv_part_notes_      OUT VARCHAR2,
   sales_part_note_id_  OUT NUMBER,
   sales_part_notes_    OUT VARCHAR2,
   contract_            IN  VARCHAR2,
   catalog_no_          IN  VARCHAR2,
   document_code_       IN  VARCHAR2,
   language_code_       IN  VARCHAR2 )
IS
   part_no_         SALES_PART_TAB.part_no%TYPE;
   CURSOR get_sales_lang_note IS
      SELECT note_id
        FROM SALES_PART_LANGUAGE_DESC_TAB
       WHERE contract      = contract_
         AND catalog_no    = catalog_no_
         AND language_code = language_code_;
BEGIN

   IF (Site_Discom_Info_API.Get_Use_Partca_Desc_Order_Db(contract_) = db_true_) THEN
      partca_part_note_id_ := Part_Catalog_Language_API.Get_Note_Id(catalog_no_, language_code_);
   END IF;
   partca_part_notes_      := Document_Text_API.Get_All_Notes(partca_part_note_id_, document_code_);

   part_no_ := Get_Part_No(contract_, catalog_no_);
   inv_part_note_id_ := Inventory_Part_API.Get_Note_Id(contract_, part_no_);
   inv_part_notes_   := Document_Text_API.Get_All_Notes(inv_part_note_id_, document_code_);

   OPEN get_sales_lang_note;
   FETCH get_sales_lang_note INTO sales_part_note_id_;
   CLOSE get_sales_lang_note;

   IF (sales_part_note_id_ IS NULL) THEN
     sales_part_note_id_ := Get_Note_Id(contract_, catalog_no_);
   END IF;
   sales_part_notes_     := Document_Text_API.Get_All_Notes(sales_part_note_id_, document_code_);

END Get_All_Notes;


-- Validate_Catalog_No_By_Gtin_No
--   Returns sales part number for given GTIN and contract if exist.
--   Otherwise return NULL.
PROCEDURE Validate_Catalog_No_By_Gtin_No (
   part_no_  OUT VARCHAR2,
   gtin_no_  IN  VARCHAR2,
   contract_ IN  VARCHAR2 )
IS
   inv_input_uom_group_id_ VARCHAR2(30);
   sales_part_exist_       BOOLEAN := FALSE;
   inv_part_no_            VARCHAR2(25) := NULL;
   gtin14_part_exist_      BOOLEAN := FALSE;
   is_inv_part_            BOOLEAN := FALSE;
BEGIN
   
   part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(gtin_no_);
   IF (part_no_ IS NULL) THEN
      -- Fetching part number by passing GTIN 14
      part_no_ := Part_Gtin_Unit_Meas_API.Get_Part_Via_Identified_Gtin(gtin_no_);
      gtin14_part_exist_ := TRUE;
   END IF;
   
   -- Check existance for catalog number
   IF (Check_Exist___(contract_, part_no_))  THEN
      sales_part_exist_ := TRUE;
      inv_part_no_      := Get_Part_No(contract_, part_no_);
   ELSIF (Check_Exist___(contract_, Get_Catalog_No_For_Part_No(contract_, part_no_))) THEN 
      inv_part_no_      := part_no_;
      sales_part_exist_ := TRUE;
      is_inv_part_      := TRUE;
   END IF;
   
   IF (part_no_ IS NOT NULL) AND (sales_part_exist_) THEN
      -- Check existance for GTIN 14 part_no
      IF (NOT gtin14_part_exist_) THEN
         gtin14_part_exist_ := (NVL(Part_Gtin_Unit_Meas_API.Get_Part_Via_Identified_Gtin(gtin_no_), Database_SYS.string_null_) = part_no_);
      END IF;
      
      IF (gtin14_part_exist_) THEN
         inv_input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, inv_part_no_);
         IF (NVL(inv_input_uom_group_id_, Database_SYS.string_null_) != Part_Catalog_API.Get_Input_Unit_Meas_Group_Id(part_no_)) THEN
            part_no_ := NULL; 
         END IF;
         
         IF (is_inv_part_ AND part_no_ IS NOT NULL) THEN
            part_no_ := Get_Catalog_No_For_Part_No(contract_, part_no_);
         END IF;
      END IF;  
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOIDENTGTIN: The entered GTIN is not used for identification of any part.');
   END IF;
END Validate_Catalog_No_By_Gtin_No;


-- Check_Enable_Part_Tracking
--   Check whether a part is defined as a non-inventory sales part.
PROCEDURE Check_Enable_Part_Tracking (
   part_no_ IN VARCHAR2 )
IS
   contract_     SALES_PART_TAB.contract%TYPE;
   catalog_type_ SALES_PART_TAB.Catalog_Type%TYPE;

   CURSOR get_non_inventory_contract IS
      SELECT contract, catalog_type
      FROM   SALES_PART_TAB
      WHERE  catalog_no = part_no_
      AND    catalog_type IN ('NON', 'PKG');
BEGIN

   OPEN get_non_inventory_contract;
   FETCH get_non_inventory_contract INTO contract_, catalog_type_;
   CLOSE get_non_inventory_contract;
   IF (contract_ IS NOT NULL) THEN
      IF (catalog_type_ = 'NON') THEN
         Error_SYS.Record_General('SalesPart', 'NONINVSALESPARTEXIST: Part Number :P1 is defined as a non-inventory sales part on Site :P2. Serial and/or Lot/Batch tracking is not allowed for non-inventory parts.', part_no_, contract_);
      END IF;
      IF (catalog_type_ = 'PKG') THEN
         Error_SYS.Record_General('SalesPart', 'NONINVPKGPARTEXIST: Part Number :P1 is defined as a package part on Site :P2. Serial and/or Lot/Batch tracking is not allowed for package parts.', part_no_, contract_);
      END IF;
   END IF;

END Check_Enable_Part_Tracking;

-- Check_Serial_Track_Change
--   Validations when serial tracking is changed.
PROCEDURE Check_Serial_Track_Change (
   part_no_                       IN VARCHAR2,
   serial_tracking_code_db_       IN VARCHAR2,
   receipt_issue_serial_track_db_ IN VARCHAR2)
IS
BEGIN

   Validate_Sales_Type___(part_no_, serial_tracking_code_db_, receipt_issue_serial_track_db_);
   
   Validate_Create_SM_Object___(part_no_,receipt_issue_serial_track_db_);
   
END Check_Serial_Track_Change;

-- Get_Active_Prim_Catalog_No
--   Returns the active primary sales part connected to the specified inventory part.
@UncheckedAccess
FUNCTION Get_Active_Prim_Catalog_No (
   contract_   IN VARCHAR2,
   part_no_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   catalog_no_ SALES_PART_TAB.catalog_no%TYPE;

   CURSOR get_active_primary_catalog IS
      SELECT catalog_no
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    activeind = 'Y'
      AND    primary_catalog = 'TRUE';
BEGIN

   OPEN get_active_primary_catalog;
   FETCH get_active_primary_catalog INTO catalog_no_;
   IF (get_active_primary_catalog%NOTFOUND) THEN
      catalog_no_ := NULL;
   END IF; 
   CLOSE get_active_primary_catalog;
   RETURN catalog_no_;   
END Get_Active_Prim_Catalog_No;


-- Validate_Classification_Data
--   Validate classification details and raise errors if invalid.
PROCEDURE Validate_Classification_Data (
   contract_                 IN VARCHAR2,
   classification_standard_  IN VARCHAR2,
   classification_part_no_   IN VARCHAR2,
   classification_unit_meas_ IN VARCHAR2 )
IS
   dummy_          NUMBER;
   assortmet_id_   VARCHAR2(50);

   CURSOR get_sales_part_classification IS 
      SELECT count(*)
      FROM   sales_part_tab sp, assortment_node_tab ant
      WHERE  ant.assortment_id = assortmet_id_
      AND    ant.part_no = sp.catalog_no
      AND    (classification_part_no_ IS NULL OR ant.classification_part_no = classification_part_no_)
      AND    (classification_unit_meas_ IS NULL OR ant.unit_code = classification_unit_meas_)
      AND    contract = contract_;

BEGIN

   assortmet_id_ := Assortment_Structure_API.Get_Assort_For_Classification(classification_standard_);

   OPEN get_sales_part_classification;
   FETCH get_sales_part_classification INTO dummy_;
   CLOSE get_sales_part_classification;
   IF (dummy_ = 0) THEN
      IF (classification_part_no_ IS NOT NULL AND classification_unit_meas_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CLASSUOMCATERR: Sales part does not exist on Site :P1 for classification part number :P2 with classification unit of measure :P3.',contract_, classification_part_no_, classification_unit_meas_);
      ELSIF classification_part_no_ IS NOT NULL THEN
         Error_SYS.Record_General(lu_name_, 'CLASSPARTCATERR: Sales part does not exist on Site :P1 for classification part number :P2.',contract_, classification_part_no_);
      END IF;
   ELSIF (dummy_ > 1) THEN
      IF (classification_part_no_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'MOREPARTS: The classification part number :P1 is defined for more than one sales part in assortment :P2 of classification standard :P3. To select the specific classification part you require, please specify the unit of measure of that part.',classification_part_no_, assortmet_id_, classification_standard_);
      END IF;
   END IF;
END Validate_Classification_Data;


-- Check_Non_Inv_Salespart_Active
--   Check whether specific part is not active and is not a non inventory sales part.
--   This method is called from Srv_Service_Type_Connect_API
PROCEDURE Check_Non_Inv_Salespart_Active (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 )
IS
   activeind_    SALES_PART_TAB.activeind%TYPE;
   catalog_type_ SALES_PART_TAB.catalog_type%TYPE;

   CURSOR get_attr IS
      SELECT activeind, catalog_type
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    catalog_no = catalog_no_;
BEGIN

   OPEN get_attr;
   FETCH get_attr INTO activeind_, catalog_type_;
   IF (get_attr%NOTFOUND) THEN
      CLOSE get_attr;
      Error_SYS.Record_Not_Exist(lu_name_);
   ELSE
      CLOSE get_attr;
   END IF;

   IF (activeind_ = Active_Sales_Part_API.DB_INACTIVE_PART) THEN
      Error_SYS.Record_General(lu_name_, 'NOACTIVESALESPART: The sales part :P1 is not active in site :P2.', catalog_no_ , contract_);
   END IF;
   IF NOT(catalog_type_ = Sales_Part_Type_API.DB_NON_INVENTORY_PART) THEN
      Error_SYS.Record_General(lu_name_, 'NOTNONINVPART: Only Non Inventory Sales Parts are allowed as Service Parts.');
   END IF;
END Check_Non_Inv_Salespart_Active;


@UncheckedAccess
FUNCTION Get_Gtin_No (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2,
   unit_code_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   gtin_no_                   VARCHAR2(14) := NULL;
   gtin14_                    VARCHAR2(14) := NULL;
   inv_input_uom_group_id_    VARCHAR2(30);
   partca_rec_                Part_Catalog_API.Public_Rec;
BEGIN
   partca_rec_ := Part_Catalog_API.Get(catalog_no_);
   gtin_no_    := Part_Gtin_API.Get_Default_Gtin_No(catalog_no_);
   IF (unit_code_ IS NOT NULL AND partca_rec_.input_unit_meas_group_id IS NOT NULL) THEN
      inv_input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, 
                                                                                 Get_Part_No(contract_, catalog_no_));
      IF (NVL(inv_input_uom_group_id_, Database_SYS.string_null_) = partca_rec_.input_unit_meas_group_id ) THEN
         gtin14_ := Part_Gtin_Unit_Meas_API.Get_Identified_Gtin14(catalog_no_, gtin_no_, unit_code_);
      END IF;
   END IF;
   RETURN NVL(gtin14_, gtin_no_);
END Get_Gtin_No;


-- Handle_Partca_Desc_Flag_Change
--   Change the sales part description in doc_reference_object_tab
--   when the part catalog description is used instead of sales part description.
PROCEDURE Handle_Partca_Desc_Flag_Change (
   contract_ IN VARCHAR2 )
IS
   partca_description_   SALES_PART_TAB.catalog_desc%TYPE;
   CURSOR get_part_info IS
      SELECT catalog_no, catalog_desc
      FROM   SALES_PART_TAB
      WHERE  contract = contract_;
BEGIN
   FOR get_part_info_ IN get_part_info LOOP
     partca_description_ := Part_Catalog_API.Get_Description(get_part_info_.catalog_no);
     IF (get_part_info_.catalog_desc != partca_description_) THEN
        Handle_Description_Change___(contract_, get_part_info_.catalog_no);
     END IF;
   END LOOP;
END Handle_Partca_Desc_Flag_Change;


-- Handle_Partca_Desc_Change
--   Change the description in doc_reference_object_tab when the part catalog description is changed.
PROCEDURE Handle_Partca_Desc_Change (
   catalog_no_ IN VARCHAR2 )
IS
   CURSOR get_contract IS
      SELECT contract
      FROM   SALES_PART_TAB
      WHERE  catalog_no = catalog_no_;
BEGIN
   FOR get_contract_ IN get_contract LOOP
      IF (Site_Discom_Info_API.Get_Use_Partca_Desc_Order_Db(get_contract_.contract) = 'TRUE') THEN
         Handle_Description_Change___(get_contract_.contract, catalog_no_);
      END IF;
   END LOOP;
END Handle_Partca_Desc_Change;


-- Modify_Purchase_Part_No
--   Update purchase_part_no field for a specific catalog_no, if the purchase_part_no field
--   is NULL or remove the purchase_part_no entry if the purchase_part_no is removed from Purchasing.
PROCEDURE Modify_Purchase_Part_No (
   contract_   IN VARCHAR2,
   part_no_    IN VARCHAR2)
IS
   newrec_     SALES_PART_TAB%ROWTYPE;

   CURSOR get_sales_parts IS
      SELECT catalog_no, purchase_part_no
      FROM   SALES_PART_TAB
      WHERE  part_no = part_no_
      AND    contract = contract_
      AND    ((purchase_part_no IS NULL) OR (purchase_part_no = part_no_))
      AND    activeind = 'Y';

BEGIN
   FOR sales_parts_rec_ IN get_sales_parts LOOP
      newrec_ := Get_Object_By_Keys___(contract_, sales_parts_rec_.catalog_no);
      IF (sales_parts_rec_.purchase_part_no IS NULL) THEN
         newrec_.purchase_part_no := part_no_;
      ELSE
         newrec_.purchase_part_no := '';
      END IF;
      Modify___(newrec_);
      IF (sales_parts_rec_.purchase_part_no IS NULL) THEN
         Customer_Order_API.Modify_Line_Purchase_Part_No(contract_,sales_parts_rec_.catalog_no,part_no_);
      END IF;
   END LOOP;
END Modify_Purchase_Part_No;


-- Modify_Intrastat_And_Customs
--   Update the customs_stat_no and intrastat_conv_factor fields in sales part for
--   given inventory part.
PROCEDURE Modify_Intrastat_And_Customs (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   customs_stat_no_       IN VARCHAR2,
   intrastat_conv_factor_ IN NUMBER)
IS
   newrec_     SALES_PART_TAB%ROWTYPE;
   CURSOR get_sales_parts IS
      SELECT catalog_no
      FROM   SALES_PART_TAB
      WHERE  part_no = part_no_
      AND    contract = contract_;
BEGIN
   
   FOR sales_parts_rec_ IN get_sales_parts LOOP
      newrec_ := Get_Object_By_Keys___(contract_, sales_parts_rec_.catalog_no);
      newrec_.customs_stat_no := customs_stat_no_;
      newrec_.intrastat_conv_factor := intrastat_conv_factor_;
      Modify___(newrec_);
   END LOOP;   
END Modify_Intrastat_And_Customs;


@UncheckedAccess
FUNCTION Get_Gross_Weight (
   contract_             IN VARCHAR2,
   catalog_no_           IN VARCHAR2 ) RETURN NUMBER
IS
   weight_net_             NUMBER;
   weight_gross_           NUMBER;
   handling_unit_type_id_  VARCHAR2(25); 
   handling_unit_type_rec_ Handling_Unit_Type_API.Public_Rec; 
   tare_weight_            NUMBER := 0;
   rec_                    Sales_Part_API.Public_Rec;
BEGIN
   rec_ := Get(contract_, catalog_no_);
   weight_net_ := Part_Weight_Volume_Util_API.Get_Partca_Net_Weight(contract_, catalog_no_, rec_.part_no, rec_.sales_unit_meas, rec_.conv_factor, rec_.inverted_conv_factor, Company_Invent_Info_API.Get_Uom_For_Weight(Site_API.Get_Company(contract_)));
   handling_unit_type_id_ := Part_Handling_Unit_API.Get_Handl_Unit_Type_Id(catalog_no_, rec_.sales_unit_meas, NULL);
   IF (handling_unit_type_id_ IS NOT NULL) THEN 
       handling_unit_type_rec_ := Handling_Unit_Type_API.Get(handling_unit_type_id_);      
       tare_weight_            := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_type_rec_.tare_weight,
                                                                               handling_unit_type_rec_.uom_for_weight,
                                                                               Company_Invent_Info_API.Get_Uom_For_Weight(Site_API.Get_Company(contract_))),0);
       weight_gross_           := weight_net_ + tare_weight_;
   ELSE
       weight_gross_           := weight_net_;
   END IF; 
   RETURN weight_gross_;
END Get_Gross_Weight;


-- Get_Catalog_Type
--   Return the sale part's catalog type
--   Return Return Catalog Type for a given part.
@UncheckedAccess
FUNCTION Get_Catalog_Type (
   catalog_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   catalog_type_  VARCHAR2(4);
   CURSOR get_catalog IS
      SELECT catalog_type
      FROM sales_part_tab
      WHERE catalog_no = catalog_no_;
BEGIN
   OPEN get_catalog;
   FETCH get_catalog INTO catalog_type_;
   CLOSE get_catalog;
   RETURN catalog_type_;
END Get_Catalog_Type;

----------------------------------------------------------------------------------------------------------
-- Validate_Config_Allowed
--    If config_family_id_ has a value, check whether a config_family_id_ can be connected to this Sales Part.
--    Otherwise if configurable_db_ has a value, check whether the part can be set as configurable or not configurable.
----------------------------------------------------------------------------------------------------------

PROCEDURE Validate_Config_Allowed (
   catalog_no_          IN VARCHAR2,
   configurable_db_     IN VARCHAR2,
   config_family_id_    IN VARCHAR2 )
IS
   inv_part_no_         SALES_PART_TAB.part_no%TYPE;
   sales_part_no_       SALES_PART_TAB.catalog_no%TYPE;
   
   -- Sales part records having catalog number catalog_no_
   CURSOR check_config_sales_parts (config_db_ VARCHAR2) IS
      SELECT sp.part_no 
      FROM   SALES_PART_TAB sp, part_catalog_tab pc
      WHERE  sp.catalog_no = catalog_no_
      AND    sp.part_no != sp.catalog_no
      AND    sp.catalog_no = pc.part_no
      AND    pc.configurable != config_db_;

   -- Sales part records having Inventory part number catalog_no_
   CURSOR check_config_inv_parts IS
      SELECT sp.catalog_no 
      FROM   SALES_PART_TAB sp, part_catalog_tab pc
      WHERE  sp.part_no = catalog_no_
      AND    sp.part_no != sp.catalog_no
      AND    sp.catalog_no = pc.part_no
      AND    pc.configurable != configurable_db_;
      
   -- Sales parts having types including 'rental'
   CURSOR get_rental_sales_parts IS
      SELECT catalog_no
      FROM   sales_part_tab
      WHERE  catalog_no = catalog_no_
      AND    sales_type IN ('RENTAL', 'SALES RENTAL'); 
      
BEGIN
   IF (config_family_id_ IS NOT NULL ) THEN
      -- Check if Configuration Family allowed
      -- Check if the catalog number passed is a sales part connected to a configurable inventory part
      OPEN check_config_sales_parts('NOT CONFIGURED');
      FETCH check_config_sales_parts INTO inv_part_no_;
      CLOSE check_config_sales_parts;
      IF (inv_part_no_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CONFIGINVCONNECTED: Connecting a configuration family is not allowed when a sales part of the specified part is already connected to [:P1] which is another configurable part.', inv_part_no_);
      END IF;
   ELSIF (configurable_db_ IS  NOT NULL) THEN
      -- Check if setting configurable_db is acceptable 
      OPEN check_config_inv_parts;
      FETCH check_config_inv_parts INTO sales_part_no_;
      CLOSE check_config_inv_parts;
      IF (sales_part_no_ IS NOT NULL) THEN
         IF (configurable_db_ = 'CONFIGURED' )THEN
            Error_SYS.Record_General(lu_name_, 'CONFIGSALERROR1: The non-configurable sales part [:P1] is not allowed to be connected to the configurable inventory part [:P2]', sales_part_no_, catalog_no_);
         ELSE
            Error_SYS.Record_General(lu_name_, 'CONFIGSALERROR2: The configurable sales part  [:P1] is not allowed to be connected to the non-configurable inventory part  [:P2].', sales_part_no_, catalog_no_);
         END IF;
      END IF;

      OPEN check_config_sales_parts(configurable_db_);
      FETCH check_config_sales_parts INTO inv_part_no_;
      CLOSE check_config_sales_parts;
      IF (inv_part_no_ IS NOT NULL) THEN
         IF (configurable_db_ = 'CONFIGURED' )THEN
            Error_SYS.Record_General(lu_name_, 'CONFIGSALERROR3: The non-configurable inventory part [:P1] is not allowed to be connected to the configurable sales part [:P2].', inv_part_no_, catalog_no_);
         ELSE
            Error_SYS.Record_General(lu_name_, 'CONFIGSALERROR4: The configurable inventory part [:P1] is not allowed to be connected to the non-configurable sales part [:P2].', inv_part_no_, catalog_no_);
         END IF;
      END IF;
      
      IF (configurable_db_ = 'CONFIGURED') THEN
         OPEN get_rental_sales_parts;
         FETCH get_rental_sales_parts INTO sales_part_no_;
         IF (get_rental_sales_parts%FOUND) THEN
            CLOSE get_rental_sales_parts;
            Error_SYS.Record_General(lu_name_, 'CONFIGSALERROR5: The configurable flag may not be set for part :P1 because the part has a sales type including rental in a Sales Part', catalog_no_);
         END IF;   
         CLOSE get_rental_sales_parts;
      END IF;        
   END IF;

END Validate_Config_Allowed;


-- Get_Suggested_Sales_Part
--    Gets a suggested Sales Part and Sales Part Description.
--    Gets the Primary Sales Part if set.
--    If No Primary Sales Part is set, Sales Part is fetched only if just one active Sales Parts exists.
PROCEDURE Get_Suggested_Sales_Part (
   catalog_no_          IN OUT VARCHAR2,
   catalog_no_desc_     IN OUT VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   limit_to_assortment_ IN VARCHAR2,
   customer_no_         IN VARCHAR2)
IS
   prim_catalog_no_in_assorted_ BOOLEAN := FALSE;
   CURSOR get_single_sales_part IS
      SELECT spcfc.catalog_no
      FROM   sales_part_created_from_config spcfc
      WHERE  spcfc.contract = contract_
      AND    spcfc.part_no = part_no_
      AND    (SELECT COUNT(spcfc.catalog_no)
              FROM sales_part_created_from_config spcfc
              WHERE  spcfc.contract = contract_
              AND    spcfc.part_no = part_no_) = 1;
   CURSOR get_single_sales_part_assorted IS
      SELECT cfcla.catalog_no
      FROM   created_from_conf_limit_assort cfcla
      WHERE  cfcla.contract = contract_
      AND    cfcla.part_no = part_no_
      AND    cfcla.customer_no = customer_no_
      AND    (SELECT COUNT(cfcla.catalog_no)
              FROM created_from_conf_limit_assort cfcla
              WHERE  cfcla.contract = contract_
              AND    cfcla.part_no = part_no_
              AND    cfcla.customer_no = customer_no_) = 1;
   CURSOR get_sales_part_assorted IS
      SELECT cfcla.catalog_no
      FROM   created_from_conf_limit_assort cfcla
      WHERE  cfcla.contract = contract_
      AND    cfcla.part_no = part_no_
      AND    cfcla.customer_no = customer_no_;    
BEGIN
   catalog_no_ := Sales_Part_API.Get_Active_Prim_Catalog_No(contract_, part_no_);
   IF limit_to_assortment_ = 'TRUE' AND catalog_no_ IS NOT NULL THEN
      FOR sales_parts_assorted_rec_ IN get_sales_part_assorted LOOP
         IF sales_parts_assorted_rec_.catalog_no = catalog_no_ THEN
            prim_catalog_no_in_assorted_ := TRUE;
         END IF;
      END LOOP;
      IF NOT prim_catalog_no_in_assorted_ THEN
         catalog_no_ := NULL;
      END IF;
   END IF;
   IF catalog_no_ IS NULL THEN
      IF limit_to_assortment_ = 'TRUE' THEN
         OPEN get_single_sales_part_assorted;
         FETCH get_single_sales_part_assorted INTO catalog_no_;
         CLOSE get_single_sales_part_assorted;
      ELSE
         OPEN get_single_sales_part;
         FETCH get_single_sales_part INTO catalog_no_;
         CLOSE get_single_sales_part;
      END IF;
   END IF;
   IF catalog_no_ IS NOT NULL THEN
      catalog_no_desc_ := Sales_Part_API.Get_Catalog_Desc(contract_, catalog_no_);
   ELSE
      catalog_no_desc_ := NULL;
   END IF;
END Get_Suggested_Sales_Part;

-- Get_Company_Unique_Uom
--    If the sales UoM of a sales part is defined uniquely across company level this method will return that UoM. Else Null will be returned
FUNCTION Get_Company_Unique_Uom (
   catalog_no_ IN VARCHAR2,
   company_    IN VARCHAR2) RETURN VARCHAR2
IS
   sales_unit_meas_  VARCHAR2(10) := NULL;
   CURSOR get_uom IS
      SELECT DISTINCT sp.sales_unit_meas 
      FROM   sales_part_tab sp, site_tab si
      WHERE  sp.contract = si.contract
      AND    si.company  = company_
      AND    sp.catalog_no = catalog_no_;
BEGIN
   OPEN get_uom;
   LOOP
      FETCH get_uom INTO sales_unit_meas_;
      IF (get_uom%ROWCOUNT > 1) THEN
         sales_unit_meas_ := NULL;
      END IF; 
      EXIT WHEN (get_uom%ROWCOUNT > 1) OR (get_uom%NOTFOUND);
   END LOOP;   
   CLOSE get_uom;
   RETURN sales_unit_meas_;
END Get_Company_Unique_Uom;

-- Get_Valid_Sourcing_Option
--    This will return the soucing option of the primary sales part if exist or
--    if no primary exist it will return the first one found.
@UncheckedAccess
FUNCTION Get_Valid_Sourcing_Option (
   contract_    IN VARCHAR2,
   catalog_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   sourcing_option_ SALES_PART_TAB.sourcing_option%TYPE;
   
   CURSOR get_attr IS
      SELECT sourcing_option
      FROM   sales_part_tab
      WHERE  contract = contract_
      AND    catalog_no = catalog_no_
      AND    activeind = 'Y'
      ORDER BY primary_catalog DESC;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO sourcing_option_;
   CLOSE get_attr;
   RETURN sourcing_option_;
END Get_Valid_Sourcing_Option;

-- Get Contribution Margin amount
@UncheckedAccess
FUNCTION Get_Contribution_Margin (
   contract_          IN  VARCHAR2,
   catalog_no_        IN  VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_attr IS
      SELECT list_price * price_conv_factor list_price
      FROM   SALES_PART_TAB
      WHERE  contract = contract_
      AND    catalog_no = catalog_no_;

   rec_               get_attr%ROWTYPE;
   currency_code_     VARCHAR2(3);
   currency_rounding_ NUMBER;
   marg_rate_         NUMBER := 0;
   total_cost_        SALES_PART_TAB.cost%TYPE;
BEGIN
   currency_code_     := Company_Finance_API.Get_Currency_Code(Site_API.Get_Company(contract_));
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(contract_),currency_code_);

   OPEN get_attr;
   FETCH get_attr INTO rec_;
   CLOSE get_attr;

   IF rec_.list_price = 0  THEN
      marg_rate_ := 0;
   ELSE
      total_cost_ := Get_Total_Cost(contract_, catalog_no_);
      marg_rate_ := round((((rec_.list_price - total_cost_) / rec_.list_price) * 100), currency_rounding_);
   END IF;
   
   RETURN marg_rate_;

END Get_Contribution_Margin;

-- Get Total Sales Price amount
@UncheckedAccess
FUNCTION Get_Total_Sales_Price (
   contract_          IN  VARCHAR2,
   catalog_no_        IN  VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_totals IS
         SELECT NVL(SUM(sp.list_price * price_conv_factor * spp.qty_per_assembly), NULL) total_sales_price  
         FROM   SALES_PART_TAB sp, SALES_PART_PACKAGE_TAB spp
         WHERE  spp.parent_part  = catalog_no_
         AND    spp.contract     = contract_
         AND    spp.contract     = sp.contract
         AND    spp.catalog_no   = sp.catalog_no;
   
   total_sales_price_ NUMBER;
BEGIN
   OPEN get_totals;
   FETCH get_totals INTO total_sales_price_;
   CLOSE get_totals;
   
   RETURN total_sales_price_;
END Get_Total_Sales_Price;

@UncheckedAccess
FUNCTION Get_Catalog_No_By_Gtin_No(
   gtin_no_  IN  VARCHAR2,
   contract_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
   part_no_                sales_part_tab.part_no%TYPE;
   inv_input_uom_group_id_ VARCHAR2(30);
BEGIN
   part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(gtin_no_);
   IF (part_no_ IS NOT NULL) AND (Check_Exist___(contract_, part_no_)) THEN
      -- Check existance for GTIN 14 part_no
      IF (NVL(Part_Gtin_Unit_Meas_API.Get_Part_Via_Identified_Gtin(gtin_no_), Database_SYS.string_null_) = part_no_) THEN
         inv_input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, Get_Part_No(contract_, part_no_));
         IF (NVL(inv_input_uom_group_id_, Database_SYS.string_null_) != Part_Catalog_API.Get_Input_Unit_Meas_Group_Id(part_no_)) THEN
            part_no_ := NULL; 
         END IF;
      END IF;  
   ELSE
      part_no_ := NULL;
   END IF;
   RETURN part_no_;
END Get_Catalog_No_By_Gtin_No;

@UncheckedAccess
FUNCTION Get_Desc_For_New_Sales_Part (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   use_part_catalog_desc_  VARCHAR2(5);
   part_catalog_desc_      VARCHAR2(200);
   inventory_desc_         VARCHAR2(200);
   new_catalog_desc_       VARCHAR2(200);
   
BEGIN
   use_part_catalog_desc_ := Site_Discom_Info_API.Get_Use_Partca_Desc_Order_Db(contract_);
   part_catalog_desc_     := Part_Catalog_API.Get_Description(catalog_no_);
   
   IF (use_part_catalog_desc_ = 'TRUE') THEN
      IF part_catalog_desc_ IS NOT NULL THEN
         new_catalog_desc_ := part_catalog_desc_;
      END IF; 
   ELSE
      inventory_desc_ := Inventory_Part_API.Get_Description(contract_, catalog_no_);
      IF (inventory_desc_ IS NOT NULL)  THEN
         new_catalog_desc_ := inventory_desc_;
      ELSE
         -- non inv part and package parts
         IF part_catalog_desc_ IS NOT NULL THEN
            new_catalog_desc_ := part_catalog_desc_;
         END IF;
      END IF;
   END IF;
   
   RETURN new_catalog_desc_;
END Get_Desc_For_New_Sales_Part;


