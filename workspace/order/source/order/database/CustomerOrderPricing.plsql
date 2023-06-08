-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderPricing
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220131  Sanvlk  CRM21R2-830, Added additional_discount to the price and discount calculation when source is 'Bo' in Calculate_Margin_Values.
--  210507  Skanlk  Bug 159001(SCZ-14722), Modified Get_Sales_Part_Price_Info___, Get_Additional_Discount___, Get_Default_Discount_Rec, Get_Default_Discount_Rec and Get_Default_Qdiscount_Rec methods by adding
--  210507          new parameter quantity_ to solve the issue in feching price agreement Id.
--  210423  AsZelk  Bug 158429(SCZ-14262), Modified Calculate_Sales_Prices___ by removing rounding for base_price_.
--  210415  MaEelk  SC21R2-49, Modified Calculate_Additional_Discount and rounded discounted_unit_price_ to the currency rounding value; 
--  201108  RasDlk  SCZ-12100, Modified Calculate_Margin_Values() to find the uom_conv_ratio with price_conv_factor.
--  201027  RasDlk  SCZ-11053, Added Raise_Rec_Add_Info_Message___, Raise_Rec_Upd_Info_Message___ and Raise_Base_Prc_Info_Message___ to solve MessageDefinitionValidation issues.
--  200921  MaEelk  GESPRING20-5401, Passed Use_Price_Incl_Tax to Price_Query_Discount_Line_API.Get_Total_Line_Discount in Do_Price_Query_Calculations
--  200826  MaEelk  GESPRING20-5398, Added Calculate_Additional_Discount
--  200716  RaVdlk   SCXTEND-4289, Added the check for ignore_if_low_price_found_ in Get_Default_Qdiscount_Rec method
--  200728  AjShlk  Bug 154872(SCZ-10834), Modified Start_Add_New_Sales_Parts__() by replacing Transaction_SYS.Set_Progress_Info() with Transaction_SYS.Log_Progress_Info()
--  200728          as it may lead to a deadlock situation when the task is run in a Schedule Chain.
--  200626  ErRalk  Bug 154011(SCZ-10174), Modified Get_Sales_Part_Price_Info___ by handling NVL for hierarchy_price_list_no_ to fetch price souce when the price list is not connected to customer.
--  200527  ThKrLk  Bug 153974(SCZ-10083), Modified Duplicate_Price_List_Part___() by passing correct value for base price including tax when it adds new sales price list part line.
--  200312  KiSalk  Bug 152582(SAZM-4808), In Calculate_Total_Discount___, removed rounding of prices to calculate total discount along with the currency_rounding_ parameter.
--  200131  KiSalk  Bug 150187(SCZ-7394), Passed price_qty_due_ to Find_Price_On_Agr_Part_Deal___ instead of buy_qty_due_ in Get_Default_Discount_Rec, Get_Default_Qdiscount_Rec, Get_Default_Pq_Discount_Rec and Update_Prices_From_Agreement.
--  190910  DiKulk  Bug 149606 (SCZ-6454), Modified Get_Sales_Part_Price_Info___() to correct the fetching and validation of price lists.
--  190823  DiKulk  Bug 149651(SCZ-6528),Modified  Get_Sales_Part_Price_Info___() to change condition to give priority to campaign when the prices are equal.
--  190511  LaThlk  Bug 142914, Modified Add_Part_To_Price_List__() by Passing the from_header_ parameter as TRUE into Sales_Price_List_Part_API.Insert_Price_Break_Lines() 
--  190511          in order to identify the adding sales part through the header.
--  181218  UdGnlk  Bug 145652, Modified Duplicate_Price_List_Part___() to retrieve price_break_template_id_ from sales price list part. 
--  180824  ChBnlk  Bug 143146, Modified Get_Price_Query_Data() by passing values to the price_qty_due_ parameter of Sales_Price_List_API.Get_Valid_Price_List() to fetch the correct price 
--  180824          source considering the minimum quantity. Modified Get_Sales_Part_Price_Info___() to stop calling the above method when it's been called from Get_Price_Query_Data()
--  180824          since it's already been fetched properly in it.
--  180610  ShPrlk  Bug 139081, Modified Get_Sales_Part_Price_Info___ to make assortment based agreement fetch values correctly based on Customer Hierarchy.
--  180710  KiSalk  Bug 142976(SCZ-533), Corrected a mistakenly added deal_price NOT null condition in some cursors in Find_Disc_On_Agr_Part_Deal__ done with STRSC-3574 development.
--  180705  NiLalk  Bug 137647, Modified New_Default_Discount_Rec, Modify_Default_Discount_Rec, New_Default_Qdiscount_Rec, Modify_Default_Qdiscount_Rec, New_Default_Pq_Discount_Rec,
--  180705          and Modify_Default_Pq_Discount_Rec to retrieve the primary discount source and passed it to Get_Multiple_Discount___ to determine the secondary discount source. Modified
--  180705          Get_Additional_Discount___ by adding parameters and conditions to retrieve secondary dicount source that is not same as the primary source. Modified Get_Sales_Part_Price_Info___ 
--  180705          by adding an elsif condition to omit NULL assignment when the exclude_from_autopricing is ticked. 
--  180123  NiDalk  Bug 139849, Modified Calculate_Margin_Values to set uom conv ratio to 1 for non exist part in BO line.
--  180118  SURBLK  Modified Update_Part_Prices___ by adding Get_Objstate() instead of Get_State()
--  171219  NiNilk  Bug 137779, Modified the price logic in customer agreement when the exclude from autopricing is checked and unchecked and also when there is 
--  171219          a deal per assortment connected by passing the catalog no instead of the inventory part no to fetch the correct price in method Get_Sales_Part_Price_Info___.
--  171205  ShPrlk  Bug 138965, Modified Get_Sales_Part_Price_Info___ to enable the pricelist to be passed into the pricelist fetching algorithm.
--  171004  JaThlk  Bug 137791, Modified the Modify_Default_Qdiscount_Rec to remove Manual discount methods with the Customer discounts when the customer is changed.
--  170915  AsZelk  Bug 137764, Modified Get_Sales_Part_Price_Info() in order to fix the overload of Customer_Order_Pricing_API.Get_Sales_Part_Price_Info does not pass correct parameters.
--  170824  ShPrlk  Bug 136668, Modified Get_Sales_Part_Price_Info___ to make agreement and pricelist fetch values from Customer Hierarchy and adjusted parameters for the method call Sales_Price_List_API.Get_Valid_Price_List.
--  170428  JeeJlk  Bug 134883, Modified Get_Additional_Discount___  to fetch hightest discount if ignore_if_low_price_found is enabled in campaign.
--  170320  SeJalk  Bug 134412, Modified the method Calculate_Margin_Values() to Multiplied to get correct cost in sales UoM.
--  170307  AmPalk  STRMF-6615, Changed Do_Price_Query_Calculations to reflect the changes in Rebate_Agreement_Receiver_API.Get_Active_Agreement with multiple active agreement handling. 
--  170120  BudKlk  Bug 132274, Modified the method Calculate_Margin_Values() to get the sales_price value eventhough the discount is null in order to calculate the contribution margin.
--  161010  ChFolk  STRSC-4269, Modified Update_Part_Prices___ to support base price update when the include period check box is selected.
--  161006  ChFolk  STRSC-4267, Added new parameter include_period_ into Update_Part_Prices__, Update_Part_Prices___ and Update_Part_Prices_Batch__. Added new parameters modify_base_price_ 
--  161006          and create_new_line_ to Duplicate_Price_List_Part___ which are used to identify whether to create new line or modify base price or adjust offset.
--  161006          Modified Update_Part_Prices___ to support base price update when include_period flag is un-checked.
--  160918  ChFolk  STRSC-3834, Removed method Get_Offset_Values___ as it is no longer used. Removed parameter min_qty_template_ in Duplicate_Price_List_Part___ as it is no used.
--  160918          Modified Adjust_Offset_Price_List__ and Duplicate_Price_List_Part___ to support adjust offset with include_period and valid_to_date.
--  160901  ChFolk  STRSC-3863 , Modified Remove_Invalid_Base_Prices__ to fixes some issues in remove invalid prices.
--  160830  ChFolk  STRSC-3834, Modified Update_Assort_Prices___, Update_Assort_Prices_Batch__, Start_Update_Assort_Prices__ and Duplicate_Price_List_Assort___ to consider valid_to_date when updating assortment node based Prices.
--  160831          Modified Update_Unit_Prices___, Update_Unit_Prices_Batch__, Start_Update_Unit_Prices__ and Duplicate_Price_List_Unit___ to consider valid_to_date when updating unit based Prices.
--  160816  ChFolk  STRSC-3734, Added new parameter valid_to-date_ into Duplicate_Price_List_Assort___, Update_Assort_Prices___, Update_Assort_Prices_Batch__ and Update_Assort_Prices__.
--  160815  ChFolk  STRSC-3733, Added new parameter valid_to_date_ into Update_Unit_Prices__, Duplicate_Price_List_Unit___, Update_Unit_Prices___, Update_Unit_Prices_Batch__
--  160815          Modified those methods to consider valide_to_date when updating the records.
--  160810  ChFolk  STRSC-3732, Added new parameter new_valid_to_date_ into Duplicate_Price_List_Part___ and Adjust_Offset_Price_List__ and modified Duplicate_Price_List_Part___
--  160810          to both consider new_valid_to_date and new_valid_from date when adjusting and adding offset is done.
--  160809  ChFolk  STRSC-3731, Modified Remove_Invalid_Base_Prices__ to consider valid_to date when removing the invalid lines.
--  160805  ChFolk  STRSC-3725, Modified Update_Part_Prices___ and Add_Part_To_Price_List__ as new parameter valid_to_date is added to Sales_Price_List_Part_API.Insert_Price_Break_Lines.
--  160805  ChFolk  STRSC-3585, Added new parameter valid_to_date into Add_Parts_To_Price_Lists__, Start_Add_Prt_To_Price_Lists__, Add_Parts_To_Price_Lists_Bat__,
--  160805          Add_Part_To_Price_List__, Add_Part_To_Price_List_Batch__ and Start_Add_Part_To_Price_List__. Did necessary changes to calling places as well.
--  160721  ChFolk  STRSC-3574, Modified Find_Price_On_Agr_Part_Deal___ to change the cursor find_part_based_min_qty as there is a requirement to fetch the
--  160721          price from the line which has a period defined when there are overlappings exists. Did the similar modification in Find_Disc_On_Agr_Part_Deal___.
--  160715  ChFolk  STRSC-3574, Modified Find_Price_On_Agr_Part_Deal___ to add condition for valid_to_date.
--  160623  MAHPLK  FINHR-1759, Modified Calculate_Discount method and convert it to implementation method since it is not called from outside of the LU.
--  160608  KiSalk  Bug 129739, Modified Add_Part_To_Price_List__ to stop calling same code in a loop when semicolon separated values passed.
--  160202  ErFelk  Bug 123221, Modified Get_Quote_Line_Price_Info() and Get_Sales_Part_Price_Info___() by making sale_unit_price_ and unit_price_incl_tax_ as IN OUT parameters.
--  160202          sale_unit_price_ and unit_price_incl_tax_ will have values when it only comes from Order_Quotation_Line_API.Build_Attr_For_Copy_Line___(). 
--  160201  SBalLK  Bug 125958, Modified Get_Sales_Price_In_Currency() and Get_Base_Price_In_Currency() methods by adding parameter to use currency rates according to new parameter date.
--  160119  KiSalk  Bug 126812, In Calculate_Total_Discount___, handled null value of parameter discount_.
--  151019  AyAmlk  Bug 124656, Modified Get_Sales_Part_Price_Info___() and Get_Additional_Discount___() by adding a condition to check a given agreement
--  151019          has a valid deal with the latest valid from date.
--  150527  NaLrlk  RED-335, Modified New_Default_Qdiscount_Rec, Modify_Default_Qdiscount_Rec, Get_Default_Qdiscount_Rec, New_Default_Pq_Discount_Rec, 
--  150527          Modify_Default_Pq_Discount_Rec, Get_Default_Pq_Discount_Recto support for rental quotations.
--  150306  MeAblk  Bug 121374, Modified Get_Additional_Discount___ in order to use the discount price uom when retrieving the assortment deal record.
--  141210  JeLise  PRSC-461, Added NVL when giving part_no_ a value in both Get_Default_Discount_Rec and Get_Additional_Discount___ , 
--  141210          since package parts and non-inventory parts only have catalog_no.
--  141208  MaIklk  PRSC-3582, Added Get_Sales_Price_List_Cost__().
--  141205  JeLise  PRSC-461, Added NVL when giving part_no_ a value in Get_Sales_Part_Price_Info___, since package parts and non-inventory parts only have catalog_no.
--  141201  ChJalk  PRSC-4191, Modified the method Calculate_Margin_Values to correct the calculation when using foreign currency.
--  141113  KiSalk  Bug 119665, Modified Calculate_Total_Discount___ and its call in Get_Disc_For_Price_Source___ to stop recalculate total if one discount is null, 
--  141113          to avoid adding rounding error to the only discount percentage applicable.
--  141119  ChJalk  PRSC-3411, Modified the method Calculate_Margin_Values to avoid division by zero error when the discount is 100%.
--  141107  ChJalk  PRSC-3412, Modified the method Replace_Default_Discount_Rec to change the default discount type when uses copy_discounts.
--  141015  ChJalk  PRSC-3679, Modified the method Calculate_Margin_Values to handle the margin calculation for BO.
--  140929  ChJalk  PRSC-1966, Added method Calculate_Discount and modified the method Calculate_Margin_Values for calculating the discount.
--  140922  ChJalk  PRSC-1969, Added method Calculate_Margin_Values.
--  140915  Budklk  Bug 118723, Modified the method Calc_Sales_Price_List_Cost__() in order to add a new variable part_no to get the sales part's inventory part no.  --  140910  ChJalk  PRSC-2901, Added NVL for discount and cost in the method Calculate_Margin_Values.
--  140827  UdGnlk  PRSC-1964, Modified Calculate_Margin_Values() to use base sale unit pice instead sale unit price.
--  140820  ChJalk  PRSC-2067, Added parameter create_partial_sum_ to the method Replace_Default_Discount_Rec.
--  140729  ChJalk  PRSC-1928, Modified Calculate_Margin_Values to change the calculation.
--  140725  ChJalk  PRSC-1928, Modified the type of the paramer margin_percentage_ in Calculate_Margin_Values.
--  140724  ChJalk  PRSC-1928, Added method Calculate_Margin_Values.
--  140324  TiRalk  Bug 116041, Modified Get_First_Base_Price_Site__ to set null when there are more than one base price site.

--  140703  PeSulk  Modified Get_Order_Line_Price_Info to disable rebate_builder_db_ for rental CO lines.
--  140324  TiRalk  Bug 116041, Modified Get_First_Base_Price_Site__ to set null when there are more than one base price site.
--  140227  AyAmlk  Bug 114733, Modified Do_Price_Query_Calculations() in order to prevent incorrect cost calculation when the currency conversion factor is different than 1.
--  140218  Nasalk  Modified Get_Additional_Discount___ and Get_Multiple_Discount___ to support discount for rentals.
--  140213  NaSalk  Modified New_Default_Discount_Rec, Get_Default_Discount_Rec and Modify_Default_Discount_Rec to include rental chargeable days for 
--  140213          discount calculation.
--  131206  CPriLK  CONV-2855, Modified Add_New_Sales_Parts() and Get_Sales_Part_Price_Info___() to use rental_list_price_incl_tax correctly. 
--  131024  SBalLK  Bug 113162, Modified Modify_Default_Discount_Rec() and Modify_Default_Qdiscount_Rec() methods to remove discount record which didn't create manually before
--  131024          fetching new discounts.
--  130630  RuLiLk  Bug 110133, Modified method Do_Price_Query_Calculations()by changing  Calculation logic of line discount amount to be consistent with discount postings.
--  130630          Remove roundings of price values.
--  130404  NaSalk  Added sales_price_type_db_ to Get_Offset_Values___ and modified all calls to it.
--  130326  Vwloza  Added min_duration_ to Get_Offset_Values___ and calls to it in Adjust_Offset_Price_List__.
--  130321  NaLrlk  Added sales_price_type_db parameter to Get_Sales_Part_Price_Info___ and Get_Disc_For_Price_Source___ to consider rental prices.
--  130318  NaSalk  Modified Get_Order_Line_Price_Info and Get_Sales_Part_Price_Info___ to add rental_chargable_days_ parameter.
--  130314  NaLrlk  Modified Update_Part_Prices__, Start_Update_Part_Prices__, Update_Part_Prices___ and Update_Part_Prices_Batch__ to add the update_price_type parameter.
--  130313  Vwloza  Removed min_duration parameter from Add_Part_To_Price_List__, Start_Add_Part_To_Price_List__, Start_Add_Prt_To_Price_Lists__.
--                  Updated Add_Part_To_Price_List__, Add_Parts_To_Price_Lists_Bat__, Start_Add_Prt_To_Price_Lists__.
--  130311  NaSalk  Modified Get_First_Base_Price_Site__ to add the sales_price_type_db parameter.
--  130311  NaLrlk  Modified Add_New_Sales_Parts, Start_Add_New_Sales_Parts__ and Add_New_Sales_Parts_Batch__ to add the sales_price_type_db parameter.
--  130307  NaSalk  Modified Add_Parts_To_Price_Lists__, Add_Part_To_Price_List__, Add_Part_To_Price_List_Batch__, Duplicate_Price_List_Part___, Update_Part_Prices___, 
--  130307          Remove_Invalid_Base_Prices__, Adjust_Offset_Price_List__, Start_Add_Part_To_Price_List__ and Start_Add_Prt_To_Price_Lists__.
--  130705  MaIklk  TIBE-985, Removed global constant inst_CostInt_ and used conditional compilation instead.
--  130308  PraWlk  Bug 108720, Modified Do_Price_Query_Calculations() to use Sales_Part_API.Get_Total_Cost() to get the part cost for package parts.
--  130227  SURBLK  Added  parameters unit_price_incl_tax_, base_unit_price_incl_tax_ and use_price_incl_tax_ in to Get_Qsubstitute_Price_Info(). 
--  130221  SURBLK  Added new parameters to Get_Sales_Part_Price_Info() and Get_Substitute_Part_Price_Info().
--  130213  JeeJlk  Modified Get_Sales_Part_Price_Info___ to fetch Price/Price incl tax based on use price incl tax value when price source is campaign.
--  130213          Modified Get_Default_Discount_Rec, Get_Default_Qdiscount_Rec, Get_Default_Pq_Discount_Rec by adding a parameter to the method call of
--  130213          Campaign_API.Get_Campaign_Price_Info.
--  121213  JeeJlk  Modified Get_Price_Query_Data and Get_Price_Query_Data_Source to assign correct values for sale_unit_price and base_sale_unit_price.
--  121212  JeeJlk  Modified Get_Price_Query_Data and Get_Price_Query_Data_Source to assign values for use price incl tax.
--  120905  JeeJlk  Modified Add_New_Sales_Parts to pass price or price incl tax depending on use price incl tax.
--  120726  HimRlk  Modified Add_Part_To_Price_List__ to consider value of use price incl tax when calculating prices. Added new method Calculate_Sales_Prices___.
--  120720  HimRlk  Modified Duplicate_Price_List_Part___ to handle price including tax columns.
--  120719  ShKolk  Added price including tax columns to methods which return price information.
--  120719          Get_Sales_Part_Price_Info, Get_Order_Line_Price_Info, Get_Quote_Line_Price_Info, Get_Sales_Part_Price_Info___.
--  120717  SURBLK  Modified Duplicate_Price_List_Part___ and Add_Part_To_Price_List__ by adding sales_price_incl_tax_ and calc_sales_price_incl_tax_.
--  120327  NaLrlk  Modified methods Duplicate_Price_List_Unit___, Duplicate_Price_List_Assort___ to round the sales_price.
--  120315  RiLase  Added price_list_no_ as an in parameter to Calc_Sales_Price_List_Cost__ and added handling of currency to cost calculation.
--  120313  MaMalk  Bug 99430, Modified the code to consider inverted_conv_factor where conv_factor has been considered.
--  120220  JeeJlk  Modified the method Get_Default_Pq_Discount_Rec to avoid fetching discount information when the price source is CONDITION CODE.
--  120105  NaLrlk  Modified the method New_Default_Pq_Discount_Rec and Modify_Default_Pq_Discount_Rec to consider the net price when discount calculate.
--  120105          Modified methods Get_Price_Query_Data and Get_Price_Query_Data_Source to update the price_source_net_price.
--  111017  MaRalk  Made part_level_db_, part_level_id_ parameters only OUT in Get_Sales_Part_Price_Info___, Get_Order_Line_Price_Info, Get_Quote_Line_Price_Info 
--  111017          Get_Default_Discount_Rec, Get_Default_Qdiscount_Rec, Get_Default_Pq_Discount_Rec methods. Removed same parameters from 
--  111017          New_Default_Discount_Rec, New_Default_Qdiscount_Rec, New_Default_Pq_Discount_Rec, Modify_Default_Discount_Rec, Modify_Default_Qdiscount_Rec,  
--  111017          Modify_Default_Pq_Discount_Rec methods. Removed method Find_Price_On_Pricelist. Modified methods Get_Valid_Price_List, 
--  111017          Get_Substitute_Part_Price_Info, Get_Qsubstitute_Price_Info, Get_Price_Query_Data.      
--  110926  MaRalk  Modified methods Get_Sales_Part_Price_Info___, Get_Default_Discount_Rec, Get_Default_Qdiscount_Rec, Get_Default_Pq_Discount_Rec 
--  110926          to remove unused parameter currency_code from method calls Sales_Price_List_API.Is_Valid and Is_Valid_Assort.   
--  110922  MaRalk  Added check Sales_Price_List_API.Is_Valid_Assort to Get_Sales_Part_Price_Info___, Get_Default_Discount_Rec, Get_Default_Qdiscount_Rec  
--  110922          and Get_Default_Pq_Discount_Rec methods for correct price calculations.
--  110824  ChJalk  Bug 95597, Modified the methods Get_Sales_Part_Price_Info___,  Get_Default_Pq_Discount_Rec, Get_Default_Discount_Rec and 
--  110824          Get_Default_Qdiscount_Rec to add IN parameter catalog_no to the method call Sales_Price_List_API.Is_Valid.
--  110506  NWeelk  Bug 96967, Modified method Get_Additional_Discount___ to insert discount lines when there are stand-alone discounts defined in the agreement and modified method 
--  110506          Find_Disc_On_Agr_Part_Deal___ by removing discount IS NOT NULL check from the cursors and to return discount_ correctly when there are discount amounts defined. 
--  110429  NWeelk  Bug 96125, Modified methods New_Default_Discount_Rec, New_Default_Qdiscount_Rec and New_Default_Pq_Discount_Rec by removing discount_temp_ != 0  
--  110429          check since now the discount can be 0 when there are discount amounts define and the deal price is null in the agreement.
--  110530  RiLase  Removed General_SYS.Init() from Get_Base_Price_From_Costing..
--  110521  NaLrlk  Modified the method Get_Sales_Part_Price_Info___ to fetch the discount for hierarchy customers.
--  110519  MiKulk  Modified the method Add_Parts_To_Price_Lists__ to correctly compare the owning_company_.
--  110505  ChJalk  Added IN paramater configuration Id to the Sales_Weight_Volume_Util_API.Get_Total_Weight_Volume.
--  110406  RiLase  Added procedure Calc_Sales_Price_List_Cost__ that fetches cost details and calculates the cost
--  110406          to be used when calculating the contribution margin on a sales price list part line.
--  110322  MatKse  Bug BP-4632, Updated Add_Part_To_Price_List and Add_Parts_To_Price_Lists to use Report_SYS.Parse_Parameter as replacement for
--                  'LIKE' and 'BETWEEN' in SQL statement.
--  110321  RiLase  Changed Get_Base_Price_From_Costing from procedure to function.
--  110315  RiLase  Removed methods Update_Base_Prices__ and Update_Base_Prices_Costing__.
--  110207  RiLase  Added validation on sales part base price status when updating base prices,
--  110207          sales price lists and customer agreement.
--  110204  RiLase  Added call to Sales_Price_List_Part_API.Insert_Price_Break_Lines() to Update_Part_Prices___().
--  110121  NaLrlk  Modified the methods Add_Part_To_Price_List__, Duplicate_Price_List_Part___ to fetch the calculated base price.
--  101215  RiLase  Modified Update_Base_Prices__ and Update_Base_Prices_Costing__ to handle baseline price and base price calculation.
--  101210  ShKolk  Renamed company to owning_company.
--  101209  RiLase  Modified Campaign_API.Get_Price_Info() call in Get_Default_Pq_Discount_Rec so that temp_customer_level_db and temp_customer_level_id is used.
--  100702  NaLrlk  Modified the methods Get_Default_Discount_Rec and Get_Default_Pq_Discount_Rec.
--  100629  NaLrlk  Added method Get_Disc_For_Price_Source___ and modified the method Get_Sales_Part_Price_Info___.
--  100520  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  100312  ShKolk  Modified Update_Prices_From_Agreement() to update PART_PRICE and PROVISIONAL_PRICE_DB.
--  100305  KiSalk  Modified Modify_Default_Pq_Discount_Rec to out the accumulated discount, from manually entered discount lines.
--  100121  KiSalk  Handled new parameters customer_level_db_ and customer_level_id_ in Campaign_API.Get_Campaign_Price_Info.
--  090831  ChJalk  Bug 83838, Modified the method Get_Default_Qdiscount_Rec to avoid fetching discount information when the price source is CONDITION CODE for Order Quotations.
--  090826  ChJalk  Bug 83838, Modified the method Get_Default_Discount_Rec to avoid fetching discount information when the price source is CONDITION CODE.
--  090810  SudJlk  Bug 83218, Modified method Update_Prices_From_Agreement to restrict price modification in the CO line if the supply code is SEO.                                                           
--  091216  AmPalk  Bug 87401, Added Get_Source_Reb_Builder_Db___. Modified Get_Order_Line_Price_Info to get rebate_builder_db_ from discount source if the price source has no value or has a FALSE. 
--  091216          Modified Get_Sales_Part_Price_Info___ and its used places to include price_source_db_,   discount_source_db_ and discount_source_id_ as out parameters.
--  091022  DaZase  Bug 82295, added this bug solution also in method Create_New_Pq_Disc_Lines___ and the calls to it in New_Default_Pq_Discount_Rec/Modify_Default_Pq_Discount_Rec.
--  091012  IrRalk  Bug 84990, Modified Get_Sales_Part_Price_Info___ to fetch customer agreement deal per part price considering price effective date correctly.
--  091005  DaZase  Renamed variable/attribute base_net_price_incl_acc_disc to base_net_price_incl_ac_dsc.
--  090925  DaZase  Changed so customer_level_id_ only get customer_no and not custom_no_pay as a value.
--  090925  KiSalk  Added company condition from COMPANY_FINANCE_AUTH_PUB in price list update methods.
--  090821  AmPalk  Bug 84285, Modified Get_Sales_Part_Price_Info___ to search a Escm_Campaign price only for the ordering customer all the time.
--  090828  DaZase  Fixes in Get_Additional_Discount___/Get_Default_Discount_Rec/Get_Default_Pq_Discount_Rec/Get_Default_Qdiscount_Rec/Get_Sales_Part_Price_Info___
--  090828          so we return customer level for cases that uses exclude_from_auto_pricing_ = 'Y'.
--  090826  HimRlk  Added new parameter to method call Escm_Campaign_API.Get_Escm_Campaign_Price_Info. 
--  090611  AmPalk  Bug 82295, Made changes to discount fetching logic based on the ability to enter standalone discounts valid  for all price UoMs on customer agreement deal per assortment. 
--  090804  KiSalk  Added methods Update_Assort_Prices___, Update_Unit_Prices__, Update_Assort_Prices_Batch__, Start_Update_Assort_Prices__.
--  090804  MaJalk  Modified Get_Additional_Discount___ to handle prices and discounts from CO header agreement.
--  090730  MaJalk  Modified Get_Sales_Part_Price_Info___ to handle prices from CO header agreement.  
--  090516  MaMalk  Bug 80827, Modified Copy_Sales_Price_List__ method to copy the characteristics correctly. Removed copying of option values from this API to Characteristic_Price_List_API.
--  090516          Also removed the handling of characteristics from unit_based price lists.
--  081124  ThAylk  Bug 74643, Modified methods New_Default_Discount_Rec, Modify_Default_Discount_Rec and Replace_Default_Discount_Rec
--  081124          to add a call to Cust_Order_Line_Discount_API.Calc_Discount_Upd_Co_Line__. 
--  090707  MaJalk  Corrected the discount fetching order at methods Get_Default_Discount_Rec, Get_Default_Qdiscount_Rec and Get_Default_Pq_Discount_Rec.
--  090624  KiSalk  Moved methods Copy_Sales_Price_List__ (as Copy__), Get_Valid_Price_List and Find_Price_On_Pricelist___ to SalesPriceList LU as public methods.
--  090507  NaLrlk  Modified the method Get_Price_Query_Data_Source to handle the price_qty.
--  090505  RiLase  Added nvl() with sysdate on rebate agreement exist check in Do_Price_Query_Calculations.
--  090409  DaZase  Added new method Do_Price_Query_Calculations.
--  090401  DaZase  Added new parameters to methods Get_Quote_Line_Price_Info, Create_New_Qdiscount_Lines___, Create_New_Default_Qdiscount_Rec, Modify_Default_Qdiscount_Rec and Get_Default_Qdiscount_Rec 
--  090326  DaZase  Added methods Get_Price_Query_Data_Source and Copy_Discounts_To_Pq.
--  090324  DaZase  Added new parameters to methods Get_Order_Line_Price_Info, Create_New_Discount_Lines___, Create_New_Default_Discount_Rec, Modify_Default_Discount_Rec and Get_Default_Discount_Rec.
--  090220  DaZase  Added methods Create_New_Pq_Disc_Lines___, New_Default_Pq_Discount_Rec, Modify_Default_Pq_Discount_Rec and Get_Default_Pq_Discount_Rec to handle discounts for the price query client.
--  090220          Added new OUT parameters to method Get_Multiple_Discount___.
--  090129  DaZase  Added method Get_Price_Query_Data for use from the new Price Query client.
--  090123  DaZase  Re-added function Get_Valid_Price_List so components outside this extension can use it, this function is obsolete and should be removed when this extension is merged into CORE.
--  090122  DaZase  Added extra IF check in method Get_Additional_Discount___ for campaign case so it will not override a Agreement excl Auto Pricing case.
--  090121  DaZase  Changed function Get_Valid_Price_List to become a procedure. Added 4 new OUT parameters to Get_Sales_Part_Price_Info___/Get_Additional_Discount___/Get_Valid_Price_List.
--  090115  DaZase  Removed campaign else case in Get_Additional_Discount___ so it now is always is performed instead of
--  090115          only when exclude_from_auto_pricing_ != 'Y'. Added functionality in Get_Sales_Part_Price_Info___/Get_Additional_Discount___
--  090115          to handle the new price/discount source part/customer levels.
--  081208  KiSalk  Removed Active state checks from the assortment fethed using  Customer_Agreement_API.Get_Assortment_Id.
--  081021  MiKulk  Modified the method Get_Default_QDiscount_Rec to modoify the discount fetching logic by giving priority to
--  081021          CO header customer agreements only with exclude from auto pricing.
--  081016  RiLase  Added campaign discount handling in Get_Default_Qdiscount_Rec.
--  081002  MaJalk  Changed condition to fetch prices from customer hierarchy at Get_Sales_Part_Price_Info___.
--  081001  MaJalk  At Get_Sales_Part_Price_Info___, set condition to call Find_Price_On_Agr_Part_Deal___.
--  080922  MiKulk  Modified the method  Get_Sales_Part_Price_Info___ in accordance with some changes in ESCM module.
--  080911  MiKulk  Update the methods Get_Sales_Part_Price_Info___, Get_Additional_Discount___, Get_Default_Discount_Rec to
--  080911          modify the price and discount fetching logic by giving priority to CO header customer agreements
--  080911          only with exclude from auto pricing then the price and discounts in campaigns.
--  080627  AmPalk  Corrections in Get_Default_Discount_Rec, Get_Additional_Discount___ and Get_Default_Qdiscount_Rec.
--  080623  MaJalk  Modified method Update_Prices_From_Agreement.
--  080528  MaJalk  Added currency conversion for sales price which is fetched from Campaign at Get_Sales_Part_Price_Info___.
--    080505   MaJalk  Changed price fetching logic at Get_Sales_Part_Price_Info___.
--  080505  MaHplk  Modified Get_Order_Line_Price_Info to use dymanic calls.
--  080428  MaJalk  Added rebate_builder_db_ parameter to method Get_Order_Line_Price_Info and modified.
--    080403   MaJalk  Modified Get_Sales_Part_Price_Info___, Get_Additional_Discount___, Get_Default_Discount_Rec to handle price U/M at campaign assortments.
--    080402  MaJalk  Modified Get_Default_Discount_Rec, Get_Sales_Part_Price_Info___, Get_Additional_Discount___.
--    080401   MaJalk  Modified Get_Additional_Discount___, Get_Default_Discount_Rec to handle campaign discounts.
--  080331  MaJalk  Modified method Get_Default_Discount_Rec to handle campaign discounts.
--  080328  MaJalk  Modified methods Get_Additional_Discount___, Get_Sales_Part_Price_Info___,
--    080328           Get_Multiple_Discount___ and Get_Default_Discount_Rec to handle campaign pricing.
--  080313  KiSalk   Merged APP75 SP1.
--  ---------------------   APP75 SP1 merge - End ------------------------------
--  080104  SaJjlk  Bug 69893, Modified method Get_Valid_Price_List to change the order of retrieval of price list.
--  071224  MaRalk  Bug 64486, Added new parameter currency_rate_type_ to Get_Base_Price_In_Currency, Get_Sales_Price_In_Currency and Get_Sales_Part_Price_Info___.
--  071224          Modified the methods Get_Order_Line_Price_Info, Get_Order_Line_Price_Info_web, Duplicate_Price_List_Part___, Add_Part_To_Price_List__,
--  071224          Update_Prices_From_Agreement to give priority to CO currency rate type when calculate prices.
--  ---------------------   APP75 SP1 merge - Start ------------------------------
--  080304  AmPalk  Modified Get_Additional_Discount___ by removing wrong use of agreement_price_.
--  080226  MaJalk  Added method Find_Disc_On_Agr_Part_Deal___. Modified methods Get_Additional_Discount___ and Update_Prices_From_Sb.
--  080221  AmPalk  Now Agreement_Sales_Group_Deal_API.Find_Agr_Sales_Grp_Deal is used to get the discount from deal per sales group.
--  080220  AmPalk  Modified calls tp Agreement_Sales_Group_Deal_API.Get method with new parameters.
--  080218  AmPalk  Added a condition to check if the price fetched is net; in all default discount new and modify methods for customer order and sales quotation.
--  080218  KiSalk  Added parameters assortment_id_, assortment_node_id_ to Get_Default_Discount_Rec and  min_quantity_ ,
--  080218          valid_from_date_, assortment_id_, assortment_node_id_ to Get_Default_Qdiscount_Rec.
--  080216  AmPalk  Modified Get_Quote_Line_Price_Info by adding net_price_fetched_ OUT parameter.
--  080218          Also added method Create_New_Qdiscount_Lines___ and moved Order_Quote_Line_Discount_API.New calls to it.
--  080216  AmPalk  Modified Find_Price_On_Agr_Part_Deal___ by adding out parameter to send net_price value.
--  080216  AmPalk  Modified Get_Sales_Part_Price_Info___ by adding rounding and currency conversion to the deal per assortment price fetching part.
--  080214  AmPalk  Modified methods Get_Sales_Part_Price_Info___ and Get_Order_Line_Price_Info to out the parameter net_price_fetched_ inorder to save it with the fetched price.
--  080211  AmPalk  Changed Find_Price_On_Agr_Part_Deal___ by truncating the date values and adding a filter to check the deal_price value.
--  080211  AmPalk  Remove the false usage of the agreement_assort_deal_rec_ in  Get_Additional_Discount___.
--  080211          Correct values comes with the agreement_assort_disc_rec_.
--  080208  MaJalk  Changed parameters of Agreement_Sales_Part_Deal_API.New at Update_Prices_From_Sb.
--  081225  AmPalk  Modified Get_Additional_Discount___ and Get_Multiple_Discount___ with new parameters.
--  081225          Added code to fetch additional discount from deal per assortment.
--  081225          The places checked discount_type chaged to check directly the discount_amount, because with multiple discounts there can be a amount only.
--  081225  AmPalk  Added discount_sub_source_ to track sub source of the fetched discount in Get_Default_Discount_Rec and Get_Default_Qdiscount_Rec.
--  081225          Sub source is used in the Create_New_Discount_Lines___.
--  080124  AmPalk  Added discount fetching logic with deal per assortment.
--  080123  KiSalk  Added parameters min_quantity_ and valid_from_date_ to Get_Default_Discount_Rec, Get_Additional_Discount___, Get_Multiple_Discount___
--  080123          and Find_Price_On_Agr_Part_Deal___. Added Procedure Create_New_Discount_Lines___. Modified Get_Sales_Part_Price_Info___,
--  080123          New_Default_Discount_Re, Get_Default_Qdiscount_Rec, New_Default_Qdiscount_Rec and Modify_Default_Qdiscount_Rec.
--  080114  MaHplk  Modified Get_Default_Discount_Rec, Get_Default_Qdiscount_Rec and Update_Prices_From_Sb methods to
--  080114          call Find_Price_On_Agr_Part_Deal___.
--  080112  MaJalk  Added new method Find_Price_On_Agr_Part_Deal___.
--  080103  AmPalk  Modified Get_Sales_Part_Price_Info___ by adding part step pricing logic for deal per Assortments.
--  071217  AmPalk  Modified Get_Sales_Part_Price_Info___ by adding code to fetch price from deal per Assortment tab.
--  071129  MaJalk  Added method Get_First_Base_Price_Site__.
--  ------------------------- Nice Price Start ------------------------------
--  070815  NaLrlk  Modified the Cursor get_base_price_site in Get_First_Base_Price_Site__.
--  070806  NaLrlk  Bug 66788, Modified method Get_First_Base_Price_Site__ to consider the sales price group id when fetching base price site.
--  070425  CsAmlk  Added ifs_assert_safe statement.
--  070425  MaMalk  Bug 64461, Modified method Get_Valid_Price_List to consider the parent customer customer price group when a hierarchy exists.
--  070126  ChBalk  Removed the call to Get_Total_Cost_Per_Cost_Set from Get_Base_Price_From_Costing.
--  070108  ChBalk  Added call to Cost_Int_API.Get_Sales_Cost_Per_Cost_Set in Get_Base_Price_From_Costing.
--  061025  NiDalk  Bug 61151, Modified method Copy_Sales_Price_List__ to correctly copy the rounding on the line level.
--  060606  MaJalk  Bug 58362, Added Sales_Discount_Type_API.Check_Exist() instead of Get_Description() at Replace_Default_Discount_Rec.
--  060524  MiKulk  Changed the coding to remove LU dependancies.
--  060419  IsWilk  Enlarge Customer - modified the added variable definitions.
--  060419  SaRalk  Enlarge Customer - Changed variable definitions.
--  --------------------------------- 13.4.0 --------------------------------
--  060125  NiDalk  Added Assert safe annotation.
--  051228  LaBolk  Bug 55316, Modified Duplicate_Price_List_Part___ to assign a value to the OUT parameter no_of_changes_ before the RETURN statement.
--  051107  IsAnlk  Added customer_no_pay_as a parameter to Get_Sales_Part_Price_Info___.
--  051012   KeFelk  Added Site_Discom_Info_API in some places for Site_API.
--  050929  SuJalk  Changed references in find_records_for_update, find_records_for_insert cursors and stmt_ statement to user_allowed_site_pub
--  050927  IsAnlk  Added customer_no as parameter to Get_Base_Price_In_Currency and Get_Sales_Price_In_Currency.
--  050818  IsAnlk  Modified cursor get_order_lines in Update_Prices_From_Sb.
--  050811  RaKalk  Modified Update_Prices_From_Agreement method to validate the planned delivery date range.
--  050805  IsAnlk  Modified method Update_Prices_From_Self_Bill as Update_Prices_From_Sb.
--  050630  IsAnlk  Added method Update_Prices_From_Self_Bill to update prices from self-billing.
--  050613  IsAnlk  Modified cursor get_order_lines and method Update_Prices_From_Agreement.
--  050608  NuFilk  Modified method Get_Quote_Line_Price_Info, added parameter provisional_price_db_ to the
--  050608          call Get_Sales_Part_Price_Info___.
--  050603  AnLaSe  SCJP625: Added method Get_Base_Price_By_Rate.
--  050527  NuFilk  Added a new parameter provisional_price_db_ to methods Get_Sales_Part_Price_Info___
--  050527          Get_Order_Line_Price_Info, Get_Order_Line_Price_Info_Web and modified method Get_Sales_Part_Price_Info___.
--  050513  GeKalk  Added a new public method Update_Prices_From_Agreement.
--  050512  UsRalk  Manually merged LCS patch for bug 49463.
--  050323  Castse  Bug 49463, Rewrote logic for fetching price and discount from agreement in procedures
--  050323          Get_Sales_Part_Price_Info___, Get_Additional_Discount___, Get_Default_Discount_Rec and Get_Default_Qdiscount_Rec.
--  050307  MiKulk  Bug 49744, Modified the cursor find_records_for_insert in the procedure Add_Part_To_Price_List__.
--  041029  Kisalk  Modified corsor find_records_for_update in Update_Base_Prices_Costing__ to filter user allowed sites.
--  041028  ChJalk  Bug 47452, Modified PROCEDURE Get_Offset_Values___.
--  040929  IsAnlk  Modified Get_Valid_Price_List to search preferred price list in customer hierarchy.
--  040914  HoInlk  Bug 46870, Modified procedure Add_New_Sales_Parts to work for multiple selections seperated by semicolon
--  040720  UsRalk  Merged LCS patch 45253.
--  040629  MaMalk  Bug 45253, Modified procedure Copy_Sales_Price_List__ in order to remove the unused variables and cursors,
--  040629          Restructured this procedure in order to copy the correct sales price list records when a valid_from_date_ is given.
--  040426  MaMalk  Bug 37374, Added sales_price_list_no_ to Get_Valid_Price_List and modified the method.
--  -------------------------------TouchDown Merge End----------------------------------------------------------------
--  040108  GaJalk  Modified the procedure Get_Sales_Part_Price_Info___ and Get_Valid_Price_List.
--  040106  GaJalk  Modified the procedure Get_Sales_Part_Price_Info___.
--  031210  HeWelk  Modified Get_Sales_Part_Price_Info___ enables sales price per condition code for any currency.
--  -------------------------------TouchDown Merge Begin----------------------------------------------------------------
--  040224  ChJalk  Bug 42277, Modified Copy_Sales_Price_List__ to copy correct data with correct valid from dates.
--  040224  Samnlk  Bug 42445, Modified procedure New_Default_Discount_Rec.
--  040209  GaJalk  Bug 42489, Merged Touch Down code.
--  040126  GeKalk  Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  040114  LoPrlk  Rmove public cursors, Calls to cursor CUST_HIERARCHY_STRUCT_API.Get_Parent_Customer were replaced by calls to
--  040114          Get_Parent_Cust. Methods Get_Sales_Part_Price_Info___, Get_Multiple_Discount___, Get_Valid_Price_List,
--  040114          Get_Default_Discount_Rec and Get_Default_Qdiscount_Rec were altered.
--  031229  SaRalk  Bug 40343, Modified procedure New_Default_Discount_Rec to update customer order line discounts when discount_temp_ = 0.
--  030925  BhRalk  Bug 38391,Modified Duplicate_Price_List_Part___, Added DESC to the ORDER BY.
--  030925  BhRalk  Bug 38391, Modified Duplicate_Price_List_Part___ to remove incorrect bug correction for 33394 and
--  030925          Modifed Calculate_Sales_Price_Part___ to add the correct correction for 33394.
--  030912  ChCrlk  Added new parameter condition_code_ to procedure Get_Sales_Part_Price_Info.
--  030911  MiKulk  Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  030807  ChIwlk  Modified method Get_Sales_Part_Price_Info___ to use the correct part no in checking for
--  030807          condition code usage.
--  030729  AjShlk  Merged bug fixes in 2002-3 SP4
--  030725  LaBolk  Added a comment for method Find_Price_On_Pricelist.
--  030723  LaBolk  Added method Find_Price_On_Pricelist.
--  030718  ChIwlk  Call Id 100102, Modified procedure Get_Sales_Part_Price_Info__ to support currency conversion in
--  030718          condition code pricing.
--  030610  ChIwlk  Changed procedure Get_Sales_Part_Price_Info__ to add new parameter condition_code. Changed procedures
--  030610          Get_Order_Line_Price_Info,Get_Order_Line_Price_Info_Web and Get_Quote_Line_Price_Info which call this method.
--  030509  DhAalk  Bug 37061, Modified PROCEDURE Update_Part_Prices___ .
--  030421  ThPalk  Bug 36612, Removed changes done under bug 36370,
--  030421          And changed method Copy_Sales_Price_List__ in order to copy correct lines with correct valid from dates.
--  030324  LaBolk  Bug 36370,Modified a cursor in Copy_Sales_Price_List__ to make it copy correct lines as per the Valid From date.
--  030306  JOHESE  Bug 36184, Rewrote procedure Update_Part_Prices___ due to performance problems
--  030220  PrTilk  Bug 35854, Modified PROCEDURE Modify_Default_QDiscount_Rec and New_Default_QDiscount_Rec.
--  030220          Made changes to the IF conditions to support the functionality for Sales Quotations.
--  030217  PrTilk  Bug 35854, Modified PROCEDURE Modify_Default_Discount_Rec. Made changes to the
--  030217          IF conditions.
--  021212  Asawlk  Merged bug fixes in 2002-3 SP3
--  021101  GaJalk  Bug 33394, Modified procedure Duplicate_Price_List_Part___.
--  020726  KiSalk  Bug 22276, Modified Add_Part_To_Price_List__ to have correct whare condition for base_price_site
--  020726           in Cursor 'find_records_for_insert' to function correctly when multiple sites selected.
--  020619  SaNalk  Bug 30911, Added a While loop in Procedure Add_Part_To_Price_List__.Modified the cursor find_records_for_insert.
--  020107  Castse  Bug fix 26922, Modified New_Default_Discount_Rec to allow negative discount.
--  010720  ViPalk  Bug fix 21370, Added a new IN parameter currency_rate when calling Characteristic_Price_List_API.Copy and
--                  Option_Value_Price_List_API.Copy within the procedure Copy_Sales_Price_List__.
--  010528  JSAnse  Bug Fix 21463, Added call to General_SYS.Init_Method for Get_QSubsitute_Price_Info, Get_Order_Line_Price_Info,
--                  and Get_Substitute_Part_Price_Info. Removed 'TRUE' as last parameter in the same call in procedures
--                  New_Default_Qdiscount_Rec, Modify_Default_Qdiscount_Rec and Get_Default_Qdiscount_Rec.
--  010413  JaBa    Bug Fix 20598,Added a global lu constant inst_CostInt_.
--  010105  JoAn    Changed Replace_Default_Discount_Records to handle discount = 0.
--  010105  JoEd    Bug fix 18469. Changed Copy_Sales_Price_List__ so it copies correct
--                  lines to the new price list.
--  000103  JoAn    Added new method Replace_Default_Discount_Records.
--  001222  FBen    Changed sysdate to sitedate in Get_Order_Line_Price_Info.
--  001221  MaGu    Added public method Get_Qsubstitute_Price_Info.
--  001221  MaGu    Added public method Get_Substitute_Part_Price_Info.
--  001220  MaGu    Modified method Find_Price_On_Pricelist so that price effectivity date is checked for min_quantity.
--  001218  FBen    Added IF statement in Calculate_Total_Discount___ that if sales_price_ = 0 THEN total_discount_ := 0.
--  001218  MaGu    Added out parameter price_source_id to method Get_Order_Line_Price_Info_Web.
--  001218  MaGu    Modified method Get_Valid_Price_List so that unit based price lists are handled as well.
--  001215  MaGu    Added price and discount search from agreement for current customer in mehtods Get_Sales_Part_Price_Info___,
--                  Get_Additional_Discount___, Get_Default_Discount_Rec and Get_Default_Qdiscount_Rec.
--  001211  MaGu    Truncated site date when assigning price_effectivity_date in a number of price and discount methods.
--  001207  MaGu    Modified Get_Sales_Part_Price_Info___, Modify_Default_Discount_Rec, Modify_Default_Qdiscount_Rec,
--                  New_Default_Discount_Rec and New_Default_Qdiscount_Rec so that no additional discount is
--                  fetched when discount method is SINGLE_DISCOUNT and discount found is 0.
--                  Also modified Get_Default_Discount_Rec and Get_Default_Qdiscount_Rec so that NULL is returned
--                  when no discount is found.
--  001129  CaSt    Bug fix 18469. Changed from MAX to MIN in cursors find_valid_from_date_base and find_valid_from_date_unit in
--                  Copy_Sales_Price_List__.
--  001109  MaGu    Modified procedures Get_Sales_Part_Price_Info___, Get_Order_Line_Price_Info and
--                  Get_Quote_Line_Price_Info. Added new parameter price_source_id_.
--  001108  MaGu    Modified procedures Get_Default_Discount_Rec and Get_Default_Qdiscount_Rec,
--                  added parameter price_source_id.
--  001107  MaGu    Modified all calls to Cust_Order_Line_Discount_API.New and Order_Quote_Line_Discount_API.New.
--  001102  MaGu    Added method Calculate_Total_Discount___.
--  001031  MaGu    Modified methods Modify_Default_Discount_Rec and Modify_Default_Qdiscount_Rec to
--                  handle multiple discount.
--  001031  MaGu    Changed all calls to cust_order_line_discount due to changed key. New key is dicount_no_.
--  001030  MaGu    Modified methods New_Default_Qdiscount_Rec and New_Default_Qdiscount_Rec to handle hierarchy
--                  search and multiple discounts.
--  001027  MaGu    Modified New_Default_Discount_Rec. Added fetching of additional discount.
--                  Added method Get_Multiple_Discount___ and Get_Additional_Discount___.
--                  Modified Get_Default_Discount_Rec to fetch discount from customer hierarchy.
--                  Discount is fetched in the same way as in Get_Sales_Part_Price_Info___.
--  001023  MaGu    Modified Get_Valid_Price_List. Added search for price list in customer hierarchy.
--                  Set price_effectivity_date_ to site date if NULL.
--                  Added PL/SQL table tab_customer_no. Modified Get_Sales_Part_Price_Info___ to
--                  handle fetch of price and discount from customer hierarchy.
--  001020  MaGu    Added procedures Get_Order_Line_Price_Info_Web and Get_Sales_Part_Price_Info_Web.
--                  Copys of Get_Order_Line_Price_Info and Get_Sales_Part_Price_Info that is needed because
--                  web application can not handle two procedures with same name
--                  and different parameters.
--  001004  FBen    Added effectivity_date in Get_Sales_Part_Price_Info.
--  000925  FBen    Added effectivity_date_ in Get_Order_Line_Price_Info.
--  000918  JoEd    Added NVL check on discount type in Modify_Default_Discount_Rec.
--  000913  FBen    Added UNDEFINE.
--  000825  JakH    Restoring backward compatibility in Get*Price_Info
--  000705  TFU     Added in the Copy_Sales_Price_List the copy from Characteristic and Option.
--  000704  LIN     Extended pricing informations
--  000607  LIN     No automatic discount on quotation when qty = 0 or price breaks exist
--  000518  LIN     Added parameter effectivity_date in several functions for use in
--                  FIND_PRICE_ON_PRICELIST, CUSTOMER_AGREEMENT.API, SALES_PRICE_LIST.API
--  000510  LIN     Added procedures New/Modify/Get_Default_Qdiscount_Rec
--  000413  GBO     Added procedure Get_Quote_Line_Price_Info,
--                  modify Get_Sales_Part_Price_Info___ for handling quotation Prospect
--  --------------  ------------ 13.0 -----------------------------------------
--  000425  PaLj    Changed check for installed logical units. A check is made when API is instantiatet.
--                  See beginning of api-file.
--  000419  PaLj    Corrected Init_Method Errors
--  000410  MaGu    Added function Calculate_Sales_Price_Part___.
--  000410  MaGu    Added procedure Add_Part_To_Price_List__, Add_Part_To_Price_List_Batch and
--                  Start_Add_Part_To_Price_List.
--  000121  SaMi    Add_New_Sales_Parts modified, price gets from costing if costing is used
--  000120  SaMi    Add_New_Sales_Parts modified to check sales part base price before calling new function
--  000119  SaMi    Get_Offset_Values___ added
--  000114  JoEd    Bug fix 12911, Added check on new_discount_type_ in
--                  Modify_Default_Discount_Rec.
--  000113  DaZa    Bug fix 12646, Added cursor find_records_not_yet_valid in
--                  Update_Unit_Prices___, also changed parameters in call to
--                  Duplicate_Price_List_Unit___ where added cursor are called.
--  991228  SaMi    Duplicate_Price_List_Part___ got a new out parameter,no_of_changes_.
--                  All calls to this procedure is modified.
--                  no_of_changes indicates number of changes in existig
--                  records or number of new records new recods
--  991217  SaMi    Added Procedure Adjust_Offset_Price_List__
--  991217  SaMi    Duplicate_Price_List_Part___ gets percentage and amount as arameters and
--                  do not fetch them incide procedure
--  991217  SaMi    Update_Part_Prices___ modified to call Duplicate_Price_List_Part___
--                  with right number of parameters
--  991210  SaMi    Added procedure Add_New_Sales_Parts.
--  991210  SaMi    Added procedures Add_New_Sales_Parts_Batch__ and Start_Add_New_Sales_Parts__.
--  991129  JoEd    Changed condition for updating default discount record
--                  in Modify_Default_Discount_Rec.
--  --------------  ------------ 11.2 -----------------------------------------
--  991112  JoEd    Bug fix 12561: Changed cursors find_records_not_yet_valid and
--                  find_records_not_yet_valid2 in Update_Part_Prices___,
--                  also changed parameters in call to Duplicate_Price_List_Part___
--                  where changed cursors are used.
--  991112  JoEd    Bug fix 12560: Added cursors find_valid_from_date_base and
--                  find_valid_from_date_unit in Copy_Sales_Price_List__ to
--                  fetch valid_from_date. Also made smaller changes in cursor
--                  find_valid_part_based_records and find_valid_unit_based_records.
--  991112  JoAn    CID 28132 Corrected cursors in Copy_Sales_Price_List__
--  991111  JoEd    Changed datatype length on company_ variables.
--  991103  JoEd    Changed Get_Sales_Part_Price_Info___ and Get_Default_Discount_Rec
--                  so that they return discount 0 when discount is NULL.
--  991006  JOHW    More corrections regarding Multiple Discounts.
--  991005  JOHW    Modified the functionality regarding Multiple Discounts.
--  991002  JOHW    Added functionality for Multiple Discounts.
--  990920  JOHW    Added procedure Create_Default_Record.
--  990901  JOHW    Removed Discount_Class and added Discount_Type and Discount.
--  --------------  ------------ 11.1 -----------------------------------------
--  990602  JoEd    Call id 18795: Changed fetch of rounding in Copy_Sales_Price_List__.
--                  Retreive value from destination price list header instead of source lines.
--  990510  RaKu    Replaced Get_Inventory_Value with Get_Inventory_Value_By_Method.
--  990506  RaKu    Corrected GROUP BY expression in Copy_Sales_Price_List__.
--  990420  RaKu    Added Client_SYS.Attr_Value_To_Date in procedures Start_Update_Unit_Prices__
--                  and Start_Update_Part_Prices__.
--  990415  RaKu    Yoshimura changes and cleanup.
--  990329  RaKu    Call ID 14567. Sales price was wrong calculated in Duplicate_Price_List_Part___.
--  990323  RaKu    Added NULL-check in Get_Base_Price_From_Costing.
--  990323  RaKu    Added parameter sales_price in several calls to SalesPriceListPart.
--  990315  RaKu    Added parameter currency_code in call to CustomerPricelist
--                  CustPriceListGroup.
--  990311  RaKu    Changed function Get_Base_Price_From_Costing to a procedure.
--  990308  RaKu    Changed info-text in Start_Update_Part_Prices__ again.
--  990308  RaKu    Changed info-text in Start_Update_Part_Prices__.
--  990308  RaKu    Changed logic for copying price lists in Copy_Sales_Price_List__ .
--  990304  RaKu    Added parameter company in Copy_Sales_Price_List__.
--  990304  RaKu    Call ID 10990. Changed in Update_Part_Prices___ and added logic for
--                  update of records that do not have a valid period when executed.
--  990303  RaKu    Changed in Get_Sales_Part_Price_Info___ so buy_qty_due is always
--                  a positive parameter. To be used together with Service Managment.
--  990118  PaLj    changed sysdate to Site_API.Get_Site_Date(contract)
--  990115  RaKu    Changed return value in call to Customer_Agreement_API.Is_Valid.
--  981126  RaKu    SID 7679 again. Switched converting factors in Get_Base_Price_From_Costing.
--                  Renamed Update_Price_Lists___ to Update_Part_Prices___.
--                  Renamed several procedures.
--  981124  RaKu    SID 7679. Added converting factors to Get_Base_Price_From_Costing.
--  981118  RaKu    Additional check on sales_price_group_id was added to the Get_Sales_Part_Price_Info___.
--  981117  RaKu    SID 7021. Added function Get_Base_Price_From_Costing.
--  981116  RaKu    SID 7092. Changed in Find_Price_On_Pricelist___. Rounding is made
--                  with 20 decimals if no rounding is specified (NULL).
--  981113  RaKu    Added proedures Copy_Sales_Price_List__.
--  981112  RaKu    Added procedures Update_Unit_Prices__, Update_Unit_Prices_Batch__,
--                  Start_Update_Unit_Prices__ and Update_Unit_Prices___.
--  981112  RaKu    SID 6951. Changed price-logic in Get_Sales_Part_Price_Info___.
--  981112  RaKu    SID 6911. Changed so price_qty_due_ is used instead of buy_qty_due_
--                  as parameter in call to Find_Price_On_Pricelist___.
--  981109  RaKu    Rewrote Get_Sales_Part_Price_Info___ logic.
--  981102  RaKu    Added procedure Remove_Invalid_Base_Prices__. Added several checks.
--  981102  RaKu    Added procedures Update_Price_Lists___, Update_Price_Lists_Batch__,
--                  Update_Base_Prices__ and Update_Base_Prices_Costing__.
--  981030  RaKu    Added procedures Start_Update_Price_Lists__ and Update_Price_Lists__.
--  981027  RaKu    Added procedure Get_Sales_Price_In_Currency, Get_Base_Price_In_Currency.
--  981022  RaKu    Added procedures Get_Sales_Part_Price_Info, Get_Order_Line_Price_Info
--                  and Get_Sales_Part_Price_Info___.
--                  Added function Get_Valid_Price_List.
--  981019  RaKu    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_      CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.DB_TRUE;
db_false_     CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.DB_FALSE;
TYPE tab_customer_no              IS TABLE OF CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE INDEX BY BINARY_INTEGER;
TYPE tab_quotation_no             IS TABLE OF ORDER_QUOTATION_LINE_TAB.quotation_no%TYPE INDEX BY BINARY_INTEGER;
TYPE tab_line_no                  IS TABLE OF ORDER_QUOTATION_LINE_TAB.line_no%TYPE INDEX BY BINARY_INTEGER;
TYPE tab_rel_no                   IS TABLE OF ORDER_QUOTATION_LINE_TAB.rel_no%TYPE INDEX BY BINARY_INTEGER;
TYPE tab_line_item_no             IS TABLE OF ORDER_QUOTATION_LINE_TAB.line_item_no%TYPE INDEX BY BINARY_INTEGER;
TYPE tab_base_unit_price_incl_tax IS TABLE OF ORDER_QUOTATION_LINE_TAB.base_unit_price_incl_tax%TYPE INDEX BY BINARY_INTEGER;
TYPE tab_unit_price_incl_tax      IS TABLE OF ORDER_QUOTATION_LINE_TAB.unit_price_incl_tax%TYPE INDEX BY BINARY_INTEGER;
TYPE tab_base_unit_price          IS TABLE OF ORDER_QUOTATION_LINE_TAB.base_sale_unit_price%TYPE INDEX BY BINARY_INTEGER;
TYPE tab_unit_price               IS TABLE OF ORDER_QUOTATION_LINE_TAB.sale_unit_price%TYPE INDEX BY BINARY_INTEGER;
TYPE tab_discount                 IS TABLE OF ORDER_QUOTATION_LINE_TAB.discount%TYPE INDEX BY BINARY_INTEGER;
TYPE tab_total_line_discount      IS TABLE OF ORDER_QUOTATION_LINE_TAB.discount%TYPE INDEX BY BINARY_INTEGER;
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Rec_Add_Info_Message___ (
   info_    OUT VARCHAR2)
IS
BEGIN
   info_ := Language_SYS.Translate_Constant(lu_name_, 'NO_LINES: No records added.');
END Raise_Rec_Add_Info_Message___;


PROCEDURE Raise_Rec_Upd_Info_Message___ (
   info_    OUT VARCHAR2)
IS
BEGIN
   info_ := Language_SYS.Translate_Constant(lu_name_, 'NO_UPDATES: No records were updated.');
END Raise_Rec_Upd_Info_Message___;


PROCEDURE Raise_Base_Prc_Info_Message___ (
   info_                OUT VARCHAR2,
   number_of_updates_    IN NUMBER)
IS
BEGIN
   info_ := Language_SYS.Translate_Constant(lu_name_, 'NUMBER_OF_UPDATES: Base price updated in :P1 record(s).', NULL, TO_CHAR(number_of_updates_));
END Raise_Base_Prc_Info_Message___;


-- Get_Sales_Part_Price_Info___
--   Retrieve sale_unit_price, base_sale_unit_price, currency_rate and discount
--   for current contract, customer_no, currency_code, agreement_id,
--   catalog_no, buy_qty_due and price_list_no.
PROCEDURE Get_Sales_Part_Price_Info___ (
   sale_unit_price_          IN OUT NUMBER,
   unit_price_incl_tax_      IN OUT NUMBER,
   base_sale_unit_price_     OUT    NUMBER,
   base_unit_price_incl_tax_ OUT    NUMBER,
   currency_rate_            OUT    NUMBER,
   discount_                 OUT    NUMBER,
   price_source_id_          OUT    VARCHAR2,
   provisional_price_db_     OUT    VARCHAR2,
   net_price_fetched_        OUT    VARCHAR2,
   price_source_db_          OUT    VARCHAR2,
   discount_source_db_       OUT    VARCHAR2,
   discount_source_id_       OUT    VARCHAR2,
   part_level_db_            OUT    VARCHAR2,
   part_level_id_            OUT    VARCHAR2,
   customer_level_db_        IN OUT VARCHAR2,
   customer_level_id_        IN OUT VARCHAR2,
   contract_                 IN     VARCHAR2,
   customer_no_              IN     VARCHAR2,
   customer_no_pay_          IN     VARCHAR2,
   currency_code_            IN     VARCHAR2,
   agreement_id_             IN     VARCHAR2,
   catalog_no_               IN     VARCHAR2,
   buy_qty_due_              IN     NUMBER,
   price_list_no_            IN     VARCHAR2,
   effectivity_date_         IN     DATE,
   condition_code_           IN     VARCHAR2,
   currency_rate_type_       IN     VARCHAR2,
   use_price_incl_tax_       IN     VARCHAR2,
   rental_chargable_days_    IN     NUMBER,
   from_price_query_         IN     BOOLEAN DEFAULT FALSE)
IS
   price_found_                   NUMBER;
   price_incl_tax_found_          NUMBER;
   discount_type_found_           VARCHAR2(25);
   discount_found_                NUMBER;
   price_list_price_              NUMBER;
   price_list_price_incl_tax_     NUMBER;
   price_list_discount_type_      VARCHAR2(25);
   price_list_discount_           NUMBER;
   found_sales_price              EXCEPTION;
   price_qty_due_                 NUMBER;
   sales_part_rec_                Sales_Part_API.Public_Rec;
   hierarchy_id_                  CUST_HIERARCHY_STRUCT_TAB.hierarchy_id%TYPE;
   n_                             BINARY_INTEGER := 0;
   total_                         BINARY_INTEGER := 0;
   customer_arr_                  tab_customer_no;
   date_                          DATE;
   hierarchy_agreement_           VARCHAR2(10);
   part_exists_                   BOOLEAN;
   condtion_code_usage_           VARCHAR2(20);
   part_no_                       VARCHAR2(25);
   prnt_cust_                     CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE;
   cond_code_rec_                 Condition_Code_Sale_Price_API.Public_Rec;
   cond_code_base_price_          NUMBER;
   cond_code_base_price_incl_tax_ NUMBER;
   price_list_currcode_           VARCHAR2(3);
   price_list_base_price_         NUMBER;
   price_list_bprice_incl_tax_    NUMBER;
   price_agreement_               VARCHAR2(10) := NULL;
   provisional_price_db_found_    VARCHAR2(20) := db_false_;
   price_um_                      SALES_PART_TAB.price_unit_meas%TYPE;
   agreement_assort_id_           ASSORTMENT_STRUCTURE_TAB.assortment_id%TYPE;
   node_id_with_deal_price_       ASSORTMENT_NODE_TAB.assortment_node_id%TYPE := NULL;
   min_qty_with_deal_price_       AGREEMENT_ASSORTMENT_DEAL_TAB.min_quantity%TYPE := NULL;
   valid_frm_with_deal_price_     AGREEMENT_ASSORTMENT_DEAL_TAB.valid_from%TYPE := NULL;
   agreement_assort_deal_rec_     Agreement_Assortment_Deal_API.Public_Rec;
   temp_agreement_id_             AGREEMENT_ASSORTMENT_DEAL_TAB.agreement_id%TYPE := NULL;
   temp_assortment_id_            AGREEMENT_ASSORTMENT_DEAL_TAB.assortment_id%TYPE := NULL;
   agreement_price_               NUMBER;
   agreement_price_incl_tax_      NUMBER;
   provisional_price_             AGREEMENT_SALES_PART_DEAL_TAB.provisional_price%TYPE;
   agreement_discount_type_       AGREEMENT_SALES_PART_DEAL_TAB.discount_type%TYPE;
   agreement_discount_            NUMBER;
   agreement_curr_code_           CUSTOMER_AGREEMENT_TAB.currency_code%TYPE;
   agreement_base_price_          NUMBER;
   agreement_base_price_incl_tax_ NUMBER;
   effective_min_quantity_        NUMBER;
   effective_valid_from_date_     DATE;
   is_net_price_                  VARCHAR2(20) := db_false_;
   campaign_id_                   NUMBER;
   campaign_discount_             NUMBER;
   campaign_discount_type_        VARCHAR2(30);
   exclude_from_auto_pricing_     VARCHAR2(5) := 'N';
   temp_customer_level_db_        VARCHAR2(30) := NULL;
   temp_customer_level_id_        VARCHAR2(200) := NULL;
   ignore_if_low_price_found_     VARCHAR2(5) := db_false_;
   low_price_found_allowed_       BOOLEAN := FALSE;
   camp_sales_unit_price_         NUMBER;
   camp_unit_price_incl_tax_      NUMBER;
   camp_base_sale_unit_price_     NUMBER;
   camp_base_unit_price_incl_tax_ NUMBER;
   camp_provisional_price_db_     VARCHAR2(20);
   camp_price_source_db_          VARCHAR2(2000);
   camp_discount_source_db_       VARCHAR2(2000); 
   camp_discount_source_id_       VARCHAR2(25);
   camp_price_source_id_          VARCHAR2(25);
   camp_part_level_db_            VARCHAR2(30);
   camp_part_level_id_            VARCHAR2(200);
   camp_customer_level_db_        VARCHAR2(30);
   camp_customer_level_id_        VARCHAR2(200);
   is_camp_net_price_             VARCHAR2(20);
   camp_currency_rate_            NUMBER;
   camp_discount_                 NUMBER := NULL;
   camp_net_price_fetched_        VARCHAR2(20);
   campaign_price_                NUMBER;
   price_                         NUMBER;
   sales_price_type_db_           VARCHAR2(20);           
   sales_part_price_              NUMBER;
   sales_part_price_inc_tax_      NUMBER;
   hierarchy_price_list_no_       VARCHAR2(10);
BEGIN
   provisional_price_db_ := provisional_price_db_found_;
   IF (effectivity_date_ IS NULL) THEN
      date_ := TRUNC(Site_API.Get_Site_Date(contract_));
   ELSE
      date_ := effectivity_date_;
   END IF;
   sales_part_rec_  := Sales_Part_API.Get(contract_, catalog_no_);
   hierarchy_id_    := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
   price_um_        := sales_part_rec_.price_unit_meas;
   price_qty_due_   := ABS(buy_qty_due_) * sales_part_rec_.price_conv_factor;

   -- When rental_chargable_days_ is specified, it is considered rental prices.
   -- Then price list and rental price defined in sales part are the only sources for rental price.
   IF (rental_chargable_days_ IS NULL) THEN
      sales_price_type_db_ := Sales_Price_Type_API.DB_SALES_PRICES;
   ELSE
      sales_price_type_db_ := Sales_Price_Type_API.DB_RENTAL_PRICES;
   END IF;
   
   IF (hierarchy_id_ IS NOT NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
      -- Create an array with the customer_no:s from the hierarchy in chronological order
      -- upwards to the hierarchy root customer.
      prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
      WHILE (prnt_cust_ IS NOT NULL) LOOP
         n_ := n_ + 1;
         customer_arr_(n_) := prnt_cust_;

         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
      END LOOP;
      total_ := n_;
   END IF;

   --------------------------------------------------------
   -- ********* Price from condition code *********
   --------------------------------------------------------
   part_no_     := NVL(sales_part_rec_.part_no, catalog_no_);
   part_exists_ := Part_Catalog_API.Check_Part_Exists(part_no_);
   IF (part_exists_ AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
      -- Check if condition code is used for the sales part
      condtion_code_usage_ := Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_);
      IF (condtion_code_usage_ = 'ALLOW_COND_CODE') THEN
         cond_code_rec_ := Condition_Code_Sale_Price_API.Get(condition_code_, contract_, catalog_no_);
         IF (cond_code_rec_.price IS NOT NULL AND cond_code_rec_.price_incl_tax IS NOT NULL) THEN

            -- Convert condition code price into base price
            Get_Base_Price_In_Currency(cond_code_base_price_incl_tax_, 
                                       currency_rate_,
                                       NVL(customer_no_pay_, customer_no_),
                                       contract_, 
                                       cond_code_rec_.currency_code, 
                                       cond_code_rec_.price_incl_tax, 
                                       currency_rate_type_);
            Get_Base_Price_In_Currency(cond_code_base_price_, 
                                       currency_rate_,
                                       NVL(customer_no_pay_, customer_no_),
                                       contract_, 
                                       cond_code_rec_.currency_code, 
                                       cond_code_rec_.price, 
                                       currency_rate_type_);
            -- Connvert base price into sales price
            Get_Sales_Price_In_Currency(price_found_, 
                                        currency_rate_,
                                        NVL(customer_no_pay_, customer_no_),
                                        contract_, 
                                        currency_code_, 
                                        cond_code_base_price_, 
                                        currency_rate_type_);
            Get_Sales_Price_In_Currency(price_incl_tax_found_, 
                                        currency_rate_,
                                        NVL(customer_no_pay_, customer_no_),
                                        contract_, 
                                        currency_code_, 
                                        cond_code_base_price_incl_tax_, 
                                        currency_rate_type_);

            -- Keep price_source
            price_source_db_   := 'CONDITION CODE';
            price_source_id_   := NULL;
            part_level_db_     := NULL;
            part_level_id_     := NULL;
            customer_level_db_ := NULL;
            customer_level_id_ := NULL;
            RAISE found_sales_price;
         END IF;
      END IF;
   END IF;

   --------------------------------------------------------------------------------------
   -- ********* Price from customer agreement- exclude from autopricing *********
   --------------------------------------------------------------------------------------
   IF (agreement_id_ IS NOT NULL) THEN
      exclude_from_auto_pricing_ := Customer_Agreement_API.Get_Use_Explicit_Db(agreement_id_);
   END IF;
   -- If customer order header defines agreement_id which exclude from autopricing is checked.
   -- Then it gets the highest priority.
   IF (exclude_from_auto_pricing_ = 'Y' AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
      -- First check if the agrement id is valid/active one.
      IF (Customer_Agreement_API.Is_Valid(agreement_id_, contract_, customer_no_, currency_code_, date_) = 1) THEN
         IF Customer_Agreement_API.Has_Valid_Part_Deal(agreement_id_, catalog_no_, 1, price_qty_due_, date_) = 1 THEN
            Find_Price_On_Agr_Part_Deal___(agreement_price_, 
                                           agreement_price_incl_tax_,
                                           provisional_price_, 
                                           agreement_discount_type_, 
                                           agreement_discount_, 
                                           effective_min_quantity_, 
                                           effective_valid_from_date_, 
                                           is_net_price_, 
                                           catalog_no_, 
                                           agreement_id_, 
                                           price_qty_due_, 
                                           date_);
         END IF;
         price_found_          := agreement_price_;
         price_incl_tax_found_ := agreement_price_incl_tax_;
         IF (price_found_ IS NOT NULL) THEN
            -- Currency code from customer agreement
            agreement_curr_code_ := Customer_Agreement_API.Get_Currency_Code(agreement_id_);
            IF (currency_code_ != agreement_curr_code_) THEN
               -- Convert agreement price into base price
               Get_Base_Price_In_Currency(agreement_base_price_, 
                                          currency_rate_,
                                          NVL(customer_no_pay_, customer_no_),
                                          contract_, 
                                          agreement_curr_code_, 
                                          price_found_, 
                                          currency_rate_type_);

               -- Convert base agreement price into sales price
               Get_Sales_Price_In_Currency(price_found_, 
                                           currency_rate_,
                                           NVL(customer_no_pay_, customer_no_),
                                           contract_, 
                                           currency_code_, 
                                           agreement_base_price_, 
                                           currency_rate_type_);

               -- Convert agreement price into base price
               Get_Base_Price_In_Currency(agreement_base_price_incl_tax_, 
                                          currency_rate_,
                                          NVL(customer_no_pay_, customer_no_),
                                          contract_, 
                                          agreement_curr_code_, 
                                          price_incl_tax_found_, 
                                          currency_rate_type_);

               -- Convert base agreement price into sales price
               Get_Sales_Price_In_Currency(price_incl_tax_found_, 
                                           currency_rate_,
                                           NVL(customer_no_pay_, customer_no_),
                                           contract_, 
                                           currency_code_, 
                                           agreement_base_price_incl_tax_, 
                                           currency_rate_type_);
            END IF;
            discount_type_found_ := agreement_discount_type_;
            discount_found_      := agreement_discount_;

            -- Keep price_source
            price_source_db_   := 'AGREEMENT';
            price_source_id_   := agreement_id_;
            part_level_db_     := 'PART';
            part_level_id_     := catalog_no_;
            customer_level_db_ := 'CUSTOMER';
            customer_level_id_ := customer_no_;
            RAISE found_sales_price;
         END IF;
         IF (price_found_ IS NOT NULL OR price_incl_tax_found_ IS NOT NULL) THEN
            price_agreement_ := agreement_id_;
         ELSE
            agreement_assort_id_ := Customer_Agreement_API.Get_Assortment_Id(agreement_id_);
            IF (agreement_assort_id_ IS NOT NULL AND part_exists_) THEN
               IF Customer_Agreement_API.Has_Valid_Assortment_Deal(agreement_id_, agreement_assort_id_, catalog_no_, price_um_, 1, price_qty_due_, date_) = 1 THEN
                  Agreement_Assortment_Deal_API.Get_Deal_Price_Node(node_id_with_deal_price_,
                                                                    min_qty_with_deal_price_,
                                                                    valid_frm_with_deal_price_,
                                                                    agreement_assort_id_,
                                                                    catalog_no_,
                                                                    agreement_id_,
                                                                    price_um_,
                                                                    price_qty_due_,
                                                                    date_);
               END IF;
               IF (node_id_with_deal_price_ IS NOT NULL) THEN
                  price_agreement_ := agreement_id_;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;

   --------------------------------------------------
   -- ********* Price from campaign ********
   --------------------------------------------------

   -- If no agreement defined in customer order header.
   IF (price_agreement_ IS NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
      camp_provisional_price_db_ := provisional_price_db_found_;
      Campaign_API.Get_Campaign_Price_Info(sale_unit_price_   => camp_sales_unit_price_,
                                           unit_price_incl_tax_ => camp_unit_price_incl_tax_,
                                           discount_type_     => campaign_discount_type_,
                                           discount_          => campaign_discount_,
                                           price_source_db_   => camp_price_source_db_,
                                           price_source_id_   => camp_price_source_id_,
                                           part_level_db_     => camp_part_level_db_,
                                           part_level_id_     => camp_part_level_id_,
                                           customer_level_db_ => camp_customer_level_db_,
                                           customer_level_id_ => camp_customer_level_id_,
                                           net_price_         => is_camp_net_price_,
                                           customer_no_       => customer_no_,
                                           contract_          => contract_,
                                           catalog_no_        => catalog_no_,
                                           currency_code_     => currency_code_,
                                           price_unit_meas_   => price_um_,
                                           price_effectivity_date_ => date_);

      -- Note: camp_sales_unit_price_ is in base currency.
      IF (camp_sales_unit_price_ != 0  AND camp_unit_price_incl_tax_ != 0) THEN
         -- If ignore if low price found is checked in the campaign, 
         -- Then it should be checked whether there might be any low price defined price and discount source. 
         ignore_if_low_price_found_ := Fnd_Boolean_API.Encode(Campaign_API.Get_Ignore_If_Low_Price_Found(camp_price_source_id_));
         low_price_found_allowed_   := (ignore_if_low_price_found_ = db_true_);
         -- If ignore if low price found is not checked, then go ahead as usual,
         -- Otherwise price and discount values are stored to temporarily variables
         IF (ignore_if_low_price_found_ = db_false_) THEN
            price_found_          := camp_sales_unit_price_;
            price_incl_tax_found_ := camp_unit_price_incl_tax_;
            price_source_db_      := camp_price_source_db_;
            price_source_id_      := camp_price_source_id_;
            customer_level_db_    := camp_customer_level_db_;
            customer_level_id_    := camp_customer_level_id_;
            is_net_price_         := is_camp_net_price_;

            campaign_id_          := price_source_id_;
            discount_type_found_  := campaign_discount_type_;
            discount_found_       := campaign_discount_;
            part_level_db_        := camp_part_level_db_;
            part_level_id_        := camp_part_level_id_;
            RAISE found_sales_price;
         END IF;
      END IF;
   END IF;

   --------------------------------------------------
   -- ******** Price from customer agreement ********
   --------------------------------------------------
   -- If no agreement was passed in or no price could be retrieved from that agreement then
   -- retrieve the default price agreement
   IF (price_agreement_ IS NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
       price_agreement_ := Customer_Agreement_API.Get_Price_Agreement_For_Part(customer_no_, contract_,
                                                                               currency_code_, catalog_no_, date_, price_qty_due_);
       IF price_agreement_ IS NOT NULL THEN
         Find_Price_On_Agr_Part_Deal___(agreement_price_, 
                                        agreement_price_incl_tax_,
                                        provisional_price_, 
                                        agreement_discount_type_, 
                                        agreement_discount_, 
                                        effective_min_quantity_, 
                                        effective_valid_from_date_, 
                                        is_net_price_, 
                                        catalog_no_, 
                                        price_agreement_, 
                                        price_qty_due_, 
                                        date_);
       END IF;
       IF (agreement_price_  IS NOT NULL OR agreement_price_incl_tax_ IS NOT NULL)THEN
          price_found_          := agreement_price_ ;
          price_incl_tax_found_ := agreement_price_incl_tax_;
       END IF;
   END IF;
   IF (price_found_ IS NOT NULL OR price_incl_tax_found_ IS NOT NULL) THEN
      -- Currency code from customer agreement
      agreement_curr_code_ := Customer_Agreement_API.Get_Currency_Code(agreement_id_);
      IF (currency_code_ != agreement_curr_code_) THEN
         -- Convert agreement price into base price
         Get_Base_Price_In_Currency(agreement_base_price_, 
                                    currency_rate_,
                                    NVL(customer_no_pay_, customer_no_),
                                    contract_, 
                                    agreement_curr_code_, 
                                    price_found_, 
                                    currency_rate_type_);

         -- Convert base agreement price into sales price
         Get_Sales_Price_In_Currency(price_found_, 
                                     currency_rate_,
                                     NVL(customer_no_pay_, customer_no_),
                                     contract_, 
                                     currency_code_, 
                                     agreement_base_price_, 
                                     currency_rate_type_);

         -- Convert agreement price into base price
         Get_Base_Price_In_Currency(agreement_base_price_incl_tax_, 
                                    currency_rate_,
                                    NVL(customer_no_pay_, customer_no_),
                                    contract_, 
                                    agreement_curr_code_, 
                                    price_incl_tax_found_, 
                                    currency_rate_type_);

         -- Convert base agreement price into sales price
         Get_Sales_Price_In_Currency(price_incl_tax_found_, 
                                     currency_rate_,
                                     NVL(customer_no_pay_, customer_no_),
                                     contract_, 
                                     currency_code_, 
                                     agreement_base_price_incl_tax_, 
                                     currency_rate_type_);
      END IF;
      discount_type_found_ := agreement_discount_type_;
      discount_found_      := agreement_discount_;

      -- Keep price_source
      price_source_db_            := 'AGREEMENT';
      price_source_id_            := price_agreement_;
      provisional_price_db_found_ := provisional_price_;
      part_level_db_              := 'PART';
      part_level_id_              := catalog_no_;
      customer_level_db_          := 'CUSTOMER';
      customer_level_id_          := customer_no_;
      RAISE found_sales_price;
   ELSIF (exclude_from_auto_pricing_ != 'Y' AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
      price_agreement_            := NULL; 
   END IF;

   -- If the deal per part records from customer's agreement(s) does/do not have matching price line or
   -- In case there is a customer agreement on the CO header and its deal per assortment records does not have matching price
   -- Then search through customer hierarchy
   IF ((hierarchy_id_ IS NOT NULL) AND (price_found_ IS NULL) AND (price_agreement_ IS NULL) AND (sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES)) THEN
      -- Loop through the hierarchy and select price and discount from first customer that has valid agreement.
      n_ := 1;
      FOR n_ IN 1 .. total_ LOOP
         -- Get first valid agreement for catalog_no.
         hierarchy_agreement_ := Customer_Agreement_API.Get_Price_Agreement_For_Part(customer_no_      => customer_arr_(n_),
                                                                                     contract_         => contract_,
                                                                                     currency_         => currency_code_,
                                                                                     catalog_no_       => catalog_no_,
                                                                                     effectivity_date_ => date_,
                                                                                     quantity_	       => price_qty_due_ );

         IF (hierarchy_agreement_ IS NOT NULL) THEN
             Find_Price_On_Agr_Part_Deal___(agreement_price_, 
                                            agreement_price_incl_tax_,
                                            provisional_price_, 
                                            agreement_discount_type_, 
                                            agreement_discount_, 
                                            effective_min_quantity_, 
                                            effective_valid_from_date_, 
                                            is_net_price_, 
                                            catalog_no_, 
                                            hierarchy_agreement_, 
                                            price_qty_due_, 
                                            date_);

             IF (agreement_price_ IS NOT NULL) THEN
                price_found_          := agreement_price_ ;
                price_incl_tax_found_ := agreement_price_incl_tax_;
                discount_type_found_  := agreement_discount_type_;
                discount_found_       := agreement_discount_;

                -- Keep price_source
                price_source_db_            := 'AGREEMENT';
                price_source_id_            := hierarchy_agreement_;
                provisional_price_db_found_ := provisional_price_;
                part_level_db_              := 'PART';
                part_level_id_              := catalog_no_;
                customer_level_db_          := 'HIERARCHY';
                customer_level_id_          := customer_arr_(n_);
                RAISE found_sales_price;
             END IF;
          END IF;
      END LOOP;
   END IF;

   -- Get price from best deal per assortment record. 
   -- This can be from a valid agreement of the customer or/else from customer hierarchy.
   IF (node_id_with_deal_price_ IS NULL AND part_exists_ AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
      -- Get the valid agreement - assortment combination first.
      Customer_Agreement_API.Get_Price_Agrm_For_Part_Assort(temp_assortment_id_,
                                                            temp_agreement_id_,
                                                            temp_customer_level_db_,
                                                            temp_customer_level_id_,
                                                            customer_no_,
                                                            contract_,
                                                            currency_code_,
                                                            date_,
                                                            catalog_no_,
                                                            price_um_,
                                                            hierarchy_id_,
                                                            price_qty_due_);

      -- Using part step pricing logic for deal per Assortment, 
      -- Search for the best node in the assortment structure selected from above method call.
      Agreement_Assortment_Deal_API.Get_Deal_Price_Node(node_id_with_deal_price_,
                                                        min_qty_with_deal_price_,
                                                        valid_frm_with_deal_price_,
                                                        temp_assortment_id_,
                                                        catalog_no_,
                                                        temp_agreement_id_,
                                                        price_um_,
                                                        price_qty_due_,
                                                        date_);
      IF (node_id_with_deal_price_ IS NOT NULL) THEN
         price_agreement_     := temp_agreement_id_;
         agreement_assort_id_ := temp_assortment_id_;
      END IF;
   END IF;

   -- If a node_id_with_deal_price_ found an assortment node with a deal price has found.
   IF (node_id_with_deal_price_ IS NOT NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
      agreement_assort_deal_rec_ := Agreement_Assortment_Deal_API.Get(price_agreement_, 
                                                                      agreement_assort_id_, 
                                                                      node_id_with_deal_price_,
                                                                      min_qty_with_deal_price_, 
                                                                      valid_frm_with_deal_price_, 
                                                                      price_um_);

      price_found_               := ROUND(agreement_assort_deal_rec_.deal_price, NVL(agreement_assort_deal_rec_.rounding, 20));
      price_incl_tax_found_      := price_found_;
      -- Currency code from agreement
      agreement_curr_code_       := Customer_Agreement_API.Get_Currency_Code(agreement_id_);
      IF (currency_code_ != agreement_curr_code_) THEN
         -- Convert agreement price into base price
         Get_Base_Price_In_Currency(agreement_base_price_, 
                                    currency_rate_,
                                    NVL(customer_no_pay_, customer_no_),
                                    contract_, 
                                    agreement_curr_code_, 
                                    price_found_, 
                                    currency_rate_type_);

         -- Convert base agreement price into sales price
         Get_Sales_Price_In_Currency(price_found_, 
                                     currency_rate_,
                                     NVL(customer_no_pay_, customer_no_),
                                     contract_, 
                                     currency_code_, 
                                     agreement_base_price_, 
                                     currency_rate_type_);
      END IF;
      discount_type_found_ := agreement_assort_deal_rec_.discount_type;
      discount_found_      := agreement_assort_deal_rec_.discount;
      is_net_price_        := agreement_assort_deal_rec_.net_price;

      -- keep price_source
      price_source_db_            := 'AGREEMENT';
      price_source_id_            := price_agreement_;
      provisional_price_db_found_ := agreement_assort_deal_rec_.provisional_price;
      part_level_db_              := 'ASSORTMENT';
      part_level_id_              := agreement_assort_id_ || ' - ' || node_id_with_deal_price_;
      IF (exclude_from_auto_pricing_ = 'Y') THEN
         customer_level_db_ := 'CUSTOMER';
         customer_level_id_ := customer_no_;
      ELSE
         customer_level_db_ := temp_customer_level_db_;  
         customer_level_id_ := temp_customer_level_id_;
      END IF;
      RAISE found_sales_price;
   END IF;

   ------------------------------------------
   -- ******** Price from price list ********
   ------------------------------------------   
   -- If there exist sales and rental price list, select valid price list according to the sales_price_type.
   IF (price_list_no_ IS NOT NULL) THEN
      -- Check for valid price list
      IF ((Sales_Price_List_API.Is_Valid(price_list_no_, contract_, catalog_no_, date_, sales_price_type_db_) = TRUE)
          OR (Sales_Price_List_API.Is_Valid_Assort(price_list_no_, contract_, catalog_no_, date_) = TRUE)) AND
          (Sales_Price_List_API.Get_Sales_Price_Group_Id(price_list_no_) = sales_part_rec_.sales_price_group_id) THEN            
         -- Allows service managment to use negative amount.
         -- Stopped refetching the price list if it's called from price query because the price list is fetched properly in it. 
         
         IF (from_price_query_ = FALSE) THEN
            Sales_Price_List_API.Get_Valid_Price_List(customer_level_db_,
                                                      customer_level_id_,
                                                      hierarchy_price_list_no_,
                                                      contract_,
                                                      catalog_no_,
                                                      customer_no_,
                                                      currency_code_,
                                                      date_,
                                                      price_qty_due_,
                                                      sales_price_type_db_);
            -- Fetch the price list details again only if manually added pricelist is not matching with the hierarchy_price_list_no_.
            IF (NVL(hierarchy_price_list_no_,Database_SYS.string_null_) != price_list_no_) THEN
               hierarchy_price_list_no_:= price_list_no_;
               Sales_Price_List_API.Get_Valid_Price_List(customer_level_db_,
                                                     customer_level_id_,
                                                     hierarchy_price_list_no_,
                                                     contract_,
                                                     catalog_no_,
                                                     customer_no_,
                                                     currency_code_,
                                                     date_,
                                                     price_qty_due_,
                                                     sales_price_type_db_);
            END IF;
            
         ELSE
            hierarchy_price_list_no_:= price_list_no_;
         END IF;
         Sales_Price_List_API.Find_Price_On_Pricelist(price_list_price_, 
                                                      price_list_price_incl_tax_,
                                                      price_list_discount_type_, 
                                                      price_list_discount_, 
                                                      part_level_db_,
                                                      part_level_id_,
                                                      hierarchy_price_list_no_, 
                                                      catalog_no_, 
                                                      price_qty_due_, 
                                                      date_, 
                                                      price_um_,
                                                      rental_chargable_days_);
         price_found_          := price_list_price_;
         price_incl_tax_found_ := price_list_price_incl_tax_;
         IF (price_found_ IS NOT NULL) OR (price_incl_tax_found_ IS NOT NULL) THEN
            -- Currency code from sales price list
            price_list_currcode_ := Sales_Price_List_API.Get_Currency_Code(hierarchy_price_list_no_);
            IF (currency_code_ != price_list_currcode_) THEN
               -- Convert price list price into base price
               Get_Base_Price_In_Currency(price_list_base_price_, 
                                          currency_rate_,
                                          NVL(customer_no_pay_, customer_no_),
                                          contract_, 
                                          price_list_currcode_, 
                                          price_found_, 
                                          currency_rate_type_);
               Get_Base_Price_In_Currency(price_list_bprice_incl_tax_, 
                                          currency_rate_,
                                          NVL(customer_no_pay_, customer_no_),
                                          contract_, 
                                          price_list_currcode_, 
                                          price_incl_tax_found_, 
                                          currency_rate_type_);

               -- Convert above base price list price into sales price
               Get_Sales_Price_In_Currency(price_found_, 
                                           currency_rate_,
                                           NVL(customer_no_pay_, customer_no_),
                                           contract_, 
                                           currency_code_, 
                                           price_list_base_price_, 
                                           currency_rate_type_);
               Get_Sales_Price_In_Currency(price_incl_tax_found_, 
                                           currency_rate_,
                                           NVL(customer_no_pay_, customer_no_),
                                           contract_, 
                                           currency_code_, 
                                           price_list_bprice_incl_tax_, 
                                           currency_rate_type_);
            END IF;
            discount_type_found_ := price_list_discount_type_;
            discount_found_      := price_list_discount_;

            -- Keep price_source
            price_source_db_ := 'PRICELIST';
            price_source_id_ := hierarchy_price_list_no_;
            RAISE found_sales_price;
         END IF;
      END IF;
   END IF;

   ------------------------------------------
   -- ******** Price from sales part ********
   ------------------------------------------
   IF (price_found_ IS NULL OR price_incl_tax_found_ IS NULL) THEN
      -- If price not found, get sales price or rental price from sales part.
      IF (sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         sales_part_price_         := sales_part_rec_.list_price;
         sales_part_price_inc_tax_ := sales_part_rec_.list_price_incl_tax;
      ELSE 
         sales_part_price_         := sales_part_rec_.rental_list_price; 
         sales_part_price_inc_tax_ := sales_part_rec_.rental_list_price_incl_tax;
      END IF;
         
      Get_Sales_Price_In_Currency(price_incl_tax_found_, 
                                  currency_rate_,
                                  NVL(customer_no_pay_, customer_no_),
                                  contract_, 
                                  currency_code_, 
                                  sales_part_price_inc_tax_,
                                  currency_rate_type_);
      Get_Sales_Price_In_Currency(price_found_, 
                                  currency_rate_,
                                  NVL(customer_no_pay_, customer_no_),
                                  contract_, 
                                  currency_code_, 
                                  sales_part_price_,
                                  currency_rate_type_);
      
      price_source_db_     := 'BASE';
      price_source_id_     := NULL;
      part_level_db_       := NULL;
      part_level_id_       := NULL;
      customer_level_db_   := NULL;
      customer_level_id_   := NULL;
      RAISE found_sales_price;
   END IF;
EXCEPTION
   WHEN found_sales_price THEN
      sale_unit_price_      := NVL(sale_unit_price_, price_found_);      
      unit_price_incl_tax_  := NVL(unit_price_incl_tax_, price_incl_tax_found_);
      provisional_price_db_ := provisional_price_db_found_;
      net_price_fetched_    := NVL(is_net_price_,db_false_);
      IF (net_price_fetched_ = db_false_) THEN
         discount_ := discount_found_;
      END IF;

      Get_Disc_For_Price_Source___(base_sale_unit_price_,   base_unit_price_incl_tax_, discount_source_db_,
                                   discount_source_id_,     currency_rate_,            discount_,                 
                                   sale_unit_price_,        unit_price_incl_tax_,      net_price_fetched_,
                                   price_source_db_,        price_source_id_,          contract_,
                                   catalog_no_,             customer_no_,              customer_no_pay_,
                                   currency_code_,          agreement_id_,             campaign_id_,
                                   hierarchy_id_,           date_,                     customer_arr_,
                                   buy_qty_due_,            total_,                    currency_rate_type_,
                                   use_price_incl_tax_,     sales_price_type_db_);

      -- The low_price_found_allowed_ is TRUE for campaign with ignore if low price found is checked.
      -- Then check whether a best price gives to customer from campaign price, discount source.
      -- If campaign price select the lowest price, then return the campaign as a price, discount source.
      -- Otherwise return the current price and discount source itself.
      IF (low_price_found_allowed_) THEN
         camp_net_price_fetched_ := NVL(is_camp_net_price_, db_false_);
         IF ( camp_net_price_fetched_ = db_false_) THEN
            camp_discount_ := campaign_discount_;
         END IF;
         campaign_id_ := camp_price_source_id_;

         -- Retreive the price information for campaign
         Get_Disc_For_Price_Source___(camp_base_sale_unit_price_, camp_base_unit_price_incl_tax_, camp_discount_source_db_, 
                                      camp_discount_source_id_,   camp_currency_rate_,            camp_discount_,
                                      camp_sales_unit_price_,     camp_unit_price_incl_tax_,      camp_net_price_fetched_,
                                      camp_price_source_db_,      camp_price_source_id_,          contract_,
                                      catalog_no_,                customer_no_,                   customer_no_pay_,
                                      currency_code_,             agreement_id_,                  campaign_id_,
                                      hierarchy_id_,              date_,                          customer_arr_,
                                      buy_qty_due_,               total_,                         currency_rate_type_,
                                      use_price_incl_tax_,        sales_price_type_db_);

         -- If campaign gives better price, then overwrite the out parameter variables from campaign data.
         -- Compare the (price - discount) and select the lowest value.
         IF (use_price_incl_tax_ = 'TRUE') THEN
            campaign_price_  := camp_unit_price_incl_tax_ * (100 - camp_discount_);
            price_           := unit_price_incl_tax_ * (100 - discount_);
         ELSE
            campaign_price_  := camp_sales_unit_price_ * (100 - camp_discount_);
            price_           := sale_unit_price_ * (100 - discount_);
         END IF;
         
         IF (campaign_price_ <= price_) THEN
            sale_unit_price_          := camp_sales_unit_price_;
            unit_price_incl_tax_      := camp_unit_price_incl_tax_;    
            base_sale_unit_price_     := camp_base_sale_unit_price_;
            base_unit_price_incl_tax_ := camp_base_unit_price_incl_tax_;
            currency_rate_            := camp_currency_rate_;
            discount_                 := camp_discount_;
            price_source_id_          := camp_price_source_id_;
            provisional_price_db_     := camp_provisional_price_db_;
            net_price_fetched_        := camp_net_price_fetched_;
            price_source_db_          := camp_price_source_db_;
            discount_source_db_       := camp_discount_source_db_;
            discount_source_id_       := camp_discount_source_id_;
            part_level_db_            := camp_part_level_db_;
            part_level_id_            := camp_part_level_id_;
            customer_level_db_        := camp_customer_level_db_;
            customer_level_id_        := camp_customer_level_id_;
         END IF;
      END IF;
      
      Trace_SYS.Message('Price searched from ~~~~~~');
      Trace_SYS.Message('     Price source      : '|| price_source_db_   || ' - ' || price_source_id_);
      Trace_SYS.Message('     Price part level  : '|| part_level_db_     || ' - ' || NVL(part_level_id_, ' '));
      Trace_SYS.Message('     Price cust level  : '|| customer_level_db_ || ' - ' || NVL(customer_level_id_, ' '));
      Trace_SYS.Message('----------------------');
      Trace_SYS.Field('Sales price               : ', sale_unit_price_);
      Trace_SYS.Field('Sales price Incl Tax      : ', unit_price_incl_tax_);
      Trace_SYS.Field('Base sales price          : ', base_sale_unit_price_);
      Trace_SYS.Field('Base sales price Incl Tax : ', base_unit_price_incl_tax_);
      Trace_SYS.Field('Net price checked         : ', net_price_fetched_);
      Trace_SYS.Field('Total discount            : ', discount_);
END Get_Sales_Part_Price_Info___;

-- Added 2 new parameters to obtain previous discount source to prevent fetching discount from the same source
-- Get_Additional_Discount___
--   Calculates additional discount for an order line.
PROCEDURE Get_Additional_Discount___ (
   discount_              OUT NUMBER,
   discount_type_         OUT VARCHAR2,
   discount_source_       OUT VARCHAR2,
   discount_source_id_    OUT VARCHAR2,
   min_quantity_          OUT NUMBER,
   valid_from_date_       OUT DATE,
   assortment_id_         OUT VARCHAR2,
   assortment_node_id_    OUT VARCHAR2,
   discount_sub_source_   OUT VARCHAR2,
   discount_price_uom_    OUT VARCHAR2,
   part_level_db_         OUT VARCHAR2,
   part_level_id_         OUT VARCHAR2,
   customer_level_db_     OUT VARCHAR2,
   customer_level_id_     OUT VARCHAR2,
   contract_              IN  VARCHAR2,
   catalog_no_            IN  VARCHAR2,
   customer_no_           IN  VARCHAR2,
   currency_code_         IN  VARCHAR2,
   agreement_id_          IN  VARCHAR2,
   campaign_id_           IN  NUMBER,
   hierarchy_id_          IN  VARCHAR2,
   effectivity_date_      IN  DATE,
   customer_arr_          IN  tab_customer_no,
   buy_qty_due_           IN  NUMBER,
   total_                 IN  BINARY_INTEGER,
   sales_price_type_db_   IN  VARCHAR2,
   prev_discount_source_  IN  VARCHAR2,
   prev_discount_sub_source_ IN VARCHAR2)
IS
   discount_found_            NUMBER;
   discount_type_found_       VARCHAR2(25);
   discount_source_db_        VARCHAR2(25);
   found_discount             EXCEPTION;
   n_                         BINARY_INTEGER := 1;
   customer_rec_              Cust_Ord_Customer_API.Public_Rec;
   date_                      DATE;
   sales_part_rec_            Sales_Part_API.Public_Rec;
   hierarchy_agreement_       VARCHAR2(10);
   customer_agreement_        VARCHAR2(10);
   discount_agreement_        VARCHAR2(10) := NULL;
   provisional_price_         AGREEMENT_SALES_PART_DEAL_TAB.provisional_price%TYPE;
   agreement_discount_type_   AGREEMENT_SALES_PART_DEAL_TAB.discount_type%TYPE;
   agreement_discount_        NUMBER;
   price_qty_due_             NUMBER;
   price_um_                  SALES_PART_TAB.price_unit_meas%TYPE;
   part_no_                   SALES_PART_TAB.part_no%TYPE;
   agreement_assort_id_       ASSORTMENT_STRUCTURE_TAB.assortment_id%TYPE;
   node_id_with_discount_     ASSORTMENT_NODE_TAB.assortment_node_id%TYPE := NULL;
   min_qty_with_discount_     AGREEMENT_ASSORTMENT_DEAL_TAB.min_quantity%TYPE := NULL;
   valid_frm_with_discount_   AGREEMENT_ASSORTMENT_DEAL_TAB.valid_from%TYPE := NULL;
   temp_agreement_id_         AGREEMENT_ASSORTMENT_DEAL_TAB.agreement_id%TYPE := NULL;
   temp_assortment_id_        AGREEMENT_ASSORTMENT_DEAL_TAB.assortment_id%TYPE := NULL;
   part_exists_               BOOLEAN := FALSE;
   agreement_assort_disc_rec_ Agreement_Assortment_Deal_API.Public_Rec;
   is_net_price_              VARCHAR2(20);
   campain_discount_          NUMBER;
   temp_campaign_id_          NUMBER;
   campain_discount_type_     VARCHAR2(25);
   exclude_from_auto_pricing_ VARCHAR2(5) := 'N';
   temp_customer_level_db_    VARCHAR2(30) := NULL;
   temp_customer_level_id_    VARCHAR2(200) := NULL;
   temp_discount_price_uom_   SALES_PART_TAB.price_unit_meas%TYPE;
   temp_assort_node_id_       ASSORTMENT_NODE_TAB.assortment_node_id%TYPE := NULL;
   low_price_found_allowed_    BOOLEAN := FALSE;
   ignore_if_low_price_found_  VARCHAR2(5) := db_false_;
   
   CURSOR get_customer_discount(customer_parent_ IN VARCHAR2) IS
      SELECT discount, discount_type
      FROM Cust_Ord_Customer_Tab
      WHERE customer_no = customer_parent_;
BEGIN
   IF (effectivity_date_ IS NULL) THEN
      date_ := TRUNC(Site_API.Get_Site_Date(contract_));
   ELSE
      date_ := effectivity_date_;
   END IF;

   sales_part_rec_      := Sales_Part_API.Get(contract_, catalog_no_);
   price_um_            := sales_part_rec_.price_unit_meas;
   price_qty_due_       := ABS(buy_qty_due_) * sales_part_rec_.price_conv_factor;
   part_no_             := NVL(sales_part_rec_.part_no, catalog_no_);
   part_exists_         := Part_Catalog_API.Check_Part_Exists(part_no_);
   -- Used in the Create_New_Discount_Lines___
   discount_sub_source_ := NULL;

   -- If CO header has an agreement defined check whehter it's a manually added one with exclude from autopricing.
   IF (agreement_id_ IS NOT NULL) THEN
      exclude_from_auto_pricing_ := Customer_Agreement_API.Get_Use_Explicit_Db(agreement_id_);
   END IF;

   -- Adding a check to make sure that the discount is not from the same source as the first discount line fetched. 
   -- First check if the agrement id passed in can be used for discount retrieval
   -- If CO header has an agreement with excluded from auto pricing it gets the highest priority.
   IF (exclude_from_auto_pricing_ = 'Y' AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES AND (prev_discount_source_ IS NULL OR prev_discount_source_ != 'AGREEMENT')) THEN
      IF (Customer_Agreement_API.Is_Valid(agreement_id_, contract_, customer_no_, currency_code_, date_) = 1) THEN
         IF Customer_Agreement_API.Has_Valid_Part_Deal(agreement_id_, catalog_no_, 0, buy_qty_due_, date_) = 1 THEN
            Find_Disc_On_Agr_Part_Deal___(provisional_price_, agreement_discount_type_, agreement_discount_,
                                          min_quantity_, valid_from_date_, is_net_price_, catalog_no_,
                                          agreement_id_, buy_qty_due_, date_);
         END IF;

         discount_type_found_ := agreement_discount_type_;
         discount_found_      := agreement_discount_;

         IF (discount_found_ IS NOT NULL) THEN
            discount_agreement_ := agreement_id_;
         ELSE
            agreement_assort_id_ := Customer_Agreement_API.Get_Assortment_Id(agreement_id_);
            IF (agreement_assort_id_ IS NOT NULL AND part_exists_) THEN
               IF Customer_Agreement_API.Has_Valid_Assortment_Deal(agreement_id_, agreement_assort_id_, part_no_, price_um_, 0, price_qty_due_, date_) = 1 THEN
                  -- Sent NULL as the assort_node_id_. A matching assortment node id will get retrieved by the method.
                  Agreement_Assortment_Deal_API.Get_Discount_Node(node_id_with_discount_,
                                                                  min_qty_with_discount_,
                                                                  valid_frm_with_discount_,
                                                                  temp_discount_price_uom_,
                                                                  agreement_assort_id_,
                                                                  NULL,
                                                                  part_no_,
                                                                  agreement_id_,
                                                                  price_um_,
                                                                  price_qty_due_,
                                                                  date_);
               END IF;
               IF (node_id_with_discount_ IS NOT NULL) THEN
                  discount_agreement_        := agreement_id_;
                  discount_price_uom_        := temp_discount_price_uom_;

                  agreement_assort_disc_rec_ := Agreement_Assortment_Deal_API.Get(discount_agreement_, agreement_assort_id_, 
                                                                                  node_id_with_discount_, min_qty_with_discount_, 
                                                                                  valid_frm_with_discount_, discount_price_uom_);
                  discount_type_found_       := agreement_assort_disc_rec_.discount_type;
                  discount_found_            := agreement_assort_disc_rec_.discount;
                  
                  IF discount_found_ IS NULL THEN
                     IF (Agreement_Assortment_Deal_API.Discount_Amount_Exist(discount_agreement_, min_qty_with_discount_, 
                                                                             valid_frm_with_discount_, discount_price_uom_, agreement_assort_id_, 
                                                                             node_id_with_discount_) = db_true_) THEN
                        discount_found_ := 1;
                     END IF;
                  END IF; 

                  discount_source_db_  := 'AGREEMENT';
                  discount_source_id_  := discount_agreement_;
                  assortment_id_       := agreement_assort_id_;
                  assortment_node_id_  := node_id_with_discount_;
                  min_quantity_        := min_qty_with_discount_;
                  valid_from_date_     := valid_frm_with_discount_;
                  discount_sub_source_ := 'AgreementDealPerAssortment';
                  part_level_db_       := 'ASSORTMENT';
                  part_level_id_       := agreement_assort_id_ || ' - ' || node_id_with_discount_;
                  customer_level_db_   := 'CUSTOMER';
                  customer_level_id_   := customer_no_;
                  RAISE found_discount;
               END IF;
            END IF;
         END IF;

         -- Discount from sales group
         IF (agreement_id_ IS NOT NULL AND discount_agreement_ IS NULL) THEN
            Agreement_Sales_Group_Deal_API.Find_Agr_Sales_Grp_Deal(discount_found_, discount_type_found_, min_quantity_, 
                                                                   valid_from_date_, sales_part_rec_.catalog_group, agreement_id_, 
                                                                   buy_qty_due_, date_);

            IF (discount_found_ IS NOT NULL) THEN
               -- keep discount_source
               discount_source_db_  := 'AGREEMENT';
               discount_source_id_  := agreement_id_;
               discount_sub_source_ := 'AgreementDealPerSalesGroup';
               part_level_db_       := 'SALES_GROUP';
               part_level_id_       := sales_part_rec_.catalog_group;
               customer_level_db_   := 'CUSTOMER';
               customer_level_id_   := customer_no_;
               RAISE found_discount;
            END IF;
         END IF;
      END IF;
   END IF;

   -- Adding a check to make sure that the discount is not from the same source as the first discount line fetched. 
   IF (discount_agreement_ IS NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES AND (prev_discount_source_ IS NULL OR prev_discount_source_ != 'CAMPAIGN')) THEN
      temp_campaign_id_ := campaign_id_;
      Campaign_API.Get_Campaign_Disc_Info(campain_discount_,
                                          campain_discount_type_,
                                          assortment_id_,
                                          assortment_node_id_,
                                          temp_customer_level_db_,
                                          temp_customer_level_id_,
                                          temp_campaign_id_,
                                          customer_no_,
                                          contract_,
                                          catalog_no_,
                                          currency_code_,
                                          price_um_,
                                          date_); 
      IF (campain_discount_ IS NOT NULL) THEN
         discount_type_found_ := campain_discount_type_;
         discount_found_      := campain_discount_;
         min_quantity_        := 0;
         discount_source_db_  := 'CAMPAIGN';
         discount_source_id_  := temp_campaign_id_;
         part_level_db_       := 'ASSORTMENT';
         part_level_id_       := assortment_id_ || ' - ' || assortment_node_id_;
         customer_level_db_   := temp_customer_level_db_;
         customer_level_id_   := temp_customer_level_id_;
         --Note: If ignore_if_low_price_found_ proceed to find the next discount source.
         ignore_if_low_price_found_ := Fnd_Boolean_API.Encode(Campaign_API.Get_Ignore_If_Low_Price_Found(temp_campaign_id_));
         low_price_found_allowed_ := (ignore_if_low_price_found_ = db_true_);
         IF(low_price_found_allowed_ = FALSE) THEN 
            RAISE found_discount;     
         END IF;
      END IF;
   END IF;

   -- Adding a check to make sure that the discount is not from the same source as the first discount line fetched. 
   -- If no agreement was passed in or no discount could be retrieved from that agreement then
   -- retrieve the default discount agreement
   IF (discount_agreement_ IS NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES AND (prev_discount_sub_source_ IS NULL OR prev_discount_sub_source_ != 'AgreementDealPerPart')) THEN
      discount_agreement_  := Customer_Agreement_API.Get_Disc_Agreement_For_Part(customer_no_, contract_,
                                                                                 currency_code_, catalog_no_, date_, price_qty_due_);
      Find_Disc_On_Agr_Part_Deal___(provisional_price_, agreement_discount_type_, agreement_discount_, min_quantity_, valid_from_date_, is_net_price_, catalog_no_, discount_agreement_, buy_qty_due_, date_);
      discount_type_found_ := agreement_discount_type_;
      discount_found_      := agreement_discount_;
   END IF;

   -- Only fetch discount if price is not found. Otherwise, discount was already fetched when price was fetched.
   IF (discount_found_ IS NOT NULL) THEN
      -- keep discount_source
      Trace_SYS.Field('Additional discount searched until Agreement (Sales Part Deal)', discount_agreement_);
      discount_source_db_  := 'AGREEMENT';
      discount_source_id_  := discount_agreement_;
      discount_sub_source_ := 'AgreementDealPerPart';
      part_level_db_       := 'PART';
      part_level_id_       := catalog_no_;
      customer_level_db_   := 'CUSTOMER';
      customer_level_id_   := customer_no_;
      RAISE found_discount;
   END IF;

   -- Adding a check to make sure that the discount is not from the same source as the first discount line fetched.
   -- Discount per customer and sales part from agreement in hierarchy. To handle agreements with only discount, no price.
   IF (hierarchy_id_ IS NOT NULL AND discount_agreement_ IS NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES AND (prev_discount_sub_source_ IS NULL OR prev_discount_sub_source_ != 'AgreementDealPerPart')) THEN
      -- Loop through the hierarchy and select discount from first customer that has valid agreement per part.
      n_ := 1;
      FOR n_ IN 1 .. total_ LOOP
         hierarchy_agreement_ := Customer_Agreement_API.Get_Disc_Agreement_For_Part (
                                       customer_no_       => customer_arr_(n_),
                                       contract_          => contract_,
                                       currency_          => currency_code_,
                                       catalog_no_        => catalog_no_,
                                       effectivity_date_  => date_,
                                       quantity_          => price_qty_due_ );

         IF (hierarchy_agreement_ IS NOT NULL) THEN
            Find_Disc_On_Agr_Part_Deal___(provisional_price_, agreement_discount_type_, agreement_discount_, min_quantity_, valid_from_date_, is_net_price_, catalog_no_, hierarchy_agreement_, buy_qty_due_, date_);
            -- Only fetch discount if price is not found. Otherwise, discount was already fetched when price was fetched.
            discount_type_found_ := agreement_discount_type_;
            discount_found_      := agreement_discount_;
            IF (discount_found_ IS NOT NULL) THEN
                -- keep discount_source
                Trace_SYS.Field('Additional discount searched in hierarchy until Agreement (Sales Part Deal)', agreement_id_);
                discount_source_db_  := 'AGREEMENT';
                discount_source_id_  := hierarchy_agreement_;
                discount_sub_source_ := 'AgreementDealPerPart';
                part_level_db_       := 'PART';
                part_level_id_       := catalog_no_;
                customer_level_db_   := 'HIERARCHY';
                customer_level_id_   := customer_arr_(n_);
                RAISE found_discount;
            END IF;
         END IF;
      END LOOP;
   END IF;

   -- Adding a check to make sure that the discount is not from the same source as the first discount line fetched.
   -- Discount from default agreement per sales group
   IF (agreement_id_ IS NOT NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES AND (prev_discount_sub_source_ IS NULL OR prev_discount_sub_source_ != 'AgreementDealPerSalesGroup')) THEN
      IF (Customer_Agreement_API.Is_Valid(agreement_id_, contract_, customer_no_, currency_code_, date_) = 1) THEN
         Agreement_Sales_Group_Deal_API.Find_Agr_Sales_Grp_Deal(discount_found_, discount_type_found_, min_quantity_, valid_from_date_, sales_part_rec_.catalog_group, agreement_id_, buy_qty_due_, date_);

         IF (discount_found_ IS NOT NULL) THEN
            Trace_SYS.Field('Additional discount searched until Agreement (Sales Group Deal)', agreement_id_);
            -- keep discount_source
            discount_source_db_  := 'AGREEMENT';
            discount_source_id_  := agreement_id_;
            discount_sub_source_ := 'AgreementDealPerSalesGroup';
            part_level_db_       := 'SALES_GROUP';
            part_level_id_       := sales_part_rec_.catalog_group;
            customer_level_db_   := 'CUSTOMER';
            customer_level_id_   := customer_no_;
            RAISE found_discount;
         END IF;
      END IF;
   END IF;

   -- Discount from agreement for current customer per sales group. To handle agreements with only discount, no price.
   -- Get first agreement valid for the current catalog_no.
   Customer_Agreement_API.Get_Agreement_For_Group(customer_agreement_, 
                                                  customer_no_, 
                                                  contract_,
                                                  currency_code_, 
                                                  sales_part_rec_.catalog_group, 
                                                  date_,
                                                  price_qty_due_);

   -- Adding a check to make sure that the discount is not from the same source as the first discount line fetched.
   IF (customer_agreement_ IS NOT NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES AND (prev_discount_sub_source_ IS NULL OR prev_discount_sub_source_ != 'AgreementDealPerSalesGroup')) THEN
      Agreement_Sales_Group_Deal_API.Find_Agr_Sales_Grp_Deal(discount_found_, 
                                                             discount_type_found_, 
                                                             min_quantity_, 
                                                             valid_from_date_, 
                                                             sales_part_rec_.catalog_group, 
                                                             customer_agreement_, 
                                                             buy_qty_due_, 
                                                             date_);

      IF (discount_found_ IS NOT NULL) THEN
         Trace_SYS.Field('Additional discount searched until Customer Agreement (Sales Group Deal)', customer_agreement_);
         -- keep discount_source
         discount_source_db_  := 'AGREEMENT';
         discount_source_id_  := customer_agreement_;
         discount_sub_source_ := 'AgreementDealPerSalesGroup';
         part_level_db_       := 'SALES_GROUP';
         part_level_id_       := sales_part_rec_.catalog_group;
         customer_level_db_   := 'CUSTOMER';
         customer_level_id_   := customer_no_;
         RAISE found_discount;
      END IF;
   END IF;

   -- Adding a check to make sure that the discount is not from the same source as the first discount line fetched.
   -- Discount per customer and sales group from agreement in hierarchy.
   IF (hierarchy_id_ IS NOT NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES AND (prev_discount_sub_source_ IS NULL OR prev_discount_sub_source_ != 'AgreementDealPerSalesGroup')) THEN
      -- Loop through the hierarchy and select discount from first customer that has valid agreement per sales group.
      n_ := 1;
      FOR n_ IN 1 .. total_ LOOP
         Customer_Agreement_API.Get_Agreement_For_Group(hierarchy_agreement_, customer_arr_(n_), contract_,
                                                        currency_code_, sales_part_rec_.catalog_group, date_, price_qty_due_);

         IF (hierarchy_agreement_ IS NOT NULL) THEN
            Agreement_Sales_Group_Deal_API.Find_Agr_Sales_Grp_Deal(discount_found_, 
                                                                   discount_type_found_, 
                                                                   min_quantity_, 
                                                                   valid_from_date_, 
                                                                   sales_part_rec_.catalog_group, 
                                                                   hierarchy_agreement_, buy_qty_due_, date_);

            IF (discount_found_ IS NOT NULL) THEN
               Trace_SYS.Field('Additional discount searched in hierarchy until Customer Agreement (Sales Group Deal)', hierarchy_agreement_);
               -- keep discount_source
               discount_source_db_  := 'AGREEMENT';
               discount_source_id_  := hierarchy_agreement_;
               discount_sub_source_ := 'AgreementDealPerSalesGroup';
               part_level_db_       := 'SALES_GROUP';
               part_level_id_       := sales_part_rec_.catalog_group;
               customer_level_db_   := 'HIERARCHY';
               customer_level_id_   := customer_arr_(n_);
               RAISE found_discount;
            END IF;
         END IF;
      END LOOP;
   END IF;

   -- Adding a check to make sure that the discount is not from the same source as the first discount line fetched.
   IF (discount_found_ IS NULL AND node_id_with_discount_ IS NULL AND part_exists_ AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES AND (prev_discount_sub_source_ IS NULL OR prev_discount_sub_source_ != 'AgreementDealPerAssortment')) THEN
      -- Used temp_assort_node_id_ as the assortment node id of the dicount agreement.
      -- Get the valid Agreement - Assortment combination first.
      Customer_Agreement_API.Get_Disc_Agrm_For_Part_Assort(temp_assortment_id_,
                                                           temp_assort_node_id_,
                                                           temp_agreement_id_,
                                                           temp_customer_level_db_,
                                                           temp_customer_level_id_,
                                                           customer_no_,
                                                           contract_,
                                                           currency_code_,
                                                           effectivity_date_,
                                                           part_no_,
                                                           price_um_,
                                                           hierarchy_id_,
                                                           price_qty_due_);
      --  Assign discount_price_uom_ to get the selected line's price UoM.
      --  Passed in the temp_assort_node_id_ found in above method. So prevents a duplicate search. 
      --  Using Part step pricing logic for deal per Assortment, search for the best node in the Assortment Structure selected from above method call.
      Agreement_Assortment_Deal_API.Get_Discount_Node(node_id_with_discount_,
                                                      min_qty_with_discount_,
                                                      valid_frm_with_discount_,
                                                      temp_discount_price_uom_,
                                                      temp_assortment_id_,
                                                      temp_assort_node_id_,
                                                      part_no_,
                                                      temp_agreement_id_,
                                                      price_um_,
                                                      price_qty_due_,
                                                      effectivity_date_);
      IF (node_id_with_discount_ IS NOT NULL) THEN
          discount_agreement_  := temp_agreement_id_;
          agreement_assort_id_ := temp_assortment_id_;
          discount_price_uom_  := temp_discount_price_uom_;
      END IF;
   END IF;

   IF (node_id_with_discount_ IS NOT NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
      agreement_assort_disc_rec_ := Agreement_Assortment_Deal_API.Get(discount_agreement_, agreement_assort_id_, node_id_with_discount_, min_qty_with_discount_, valid_frm_with_discount_, discount_price_uom_);
      discount_type_found_       := agreement_assort_disc_rec_.discount_type;
      discount_found_            := agreement_assort_disc_rec_.discount;
      Trace_SYS.Field('Additionl discount searched until Customer Agreement with a descount Assortment : ', discount_agreement_);
      
      IF discount_found_ IS NULL THEN
         IF (Agreement_Assortment_Deal_API.Discount_Amount_Exist(discount_agreement_, min_qty_with_discount_, valid_frm_with_discount_, discount_price_uom_, agreement_assort_id_, node_id_with_discount_) = db_true_) THEN
            discount_found_ := 1;
         END IF;
      END IF; 

      discount_source_db_  := 'AGREEMENT';
      discount_source_id_  := discount_agreement_;
      assortment_id_       := agreement_assort_id_;
      assortment_node_id_  := node_id_with_discount_;
      min_quantity_        := min_qty_with_discount_;
      valid_from_date_     := valid_frm_with_discount_;
      discount_sub_source_ := 'AgreementDealPerAssortment';
      part_level_db_       := 'ASSORTMENT';
      part_level_id_       := agreement_assort_id_ || ' - ' || node_id_with_discount_;
      customer_level_db_   := temp_customer_level_db_;
      customer_level_id_   := temp_customer_level_id_;
      RAISE found_discount;
   END IF;

   -- Adding a check to make sure that the discount is not from the same source as the first discount line fetched.
   -- Discount from customer
   -- For rental prices, customer discount is considered.
   IF (discount_found_ IS NULL AND customer_no_ IS NOT NULL AND (prev_discount_source_ IS NULL OR prev_discount_source_ != 'CUSTOMER' )) THEN
       -- Discount class not found. Get it from CustOrdCustomer.
       customer_rec_        := Cust_Ord_Customer_API.Get(customer_no_);
       discount_type_found_ := customer_rec_.discount_type;
       discount_found_      := customer_rec_.discount;

       IF (discount_type_found_ IS NOT NULL) THEN
          Trace_SYS.Field('Additional discount searched until Customer', customer_no_);
          -- keep discount_source
          discount_source_db_ := 'CUSTOMER';
          discount_source_id_ := customer_no_;
          part_level_db_      := 'PART';
          part_level_id_      := catalog_no_;
          customer_level_db_  := 'CUSTOMER';
          customer_level_id_  := customer_no_;
          RAISE found_discount;
       END IF;
   END IF;

   -- Adding a check to make sure that the discount is not from the same source as the first discount line fetched.
   -- Discount from customer in customer hierarchy
   -- For rental prices, customer hierarchy is considered.
   IF (hierarchy_id_ IS NOT NULL AND (prev_discount_source_ IS NULL OR prev_discount_source_ != 'CUSTOMER')) THEN
      -- Loop through the hierarchy and select discount from first customer that has a customer discount.
      n_ := 1;
      FOR n_ IN 1 .. total_ LOOP
         OPEN  get_customer_discount(customer_arr_(n_));
         FETCH get_customer_discount INTO discount_found_, discount_type_found_;
         IF (get_customer_discount%NOTFOUND) THEN
             discount_type_found_ := NULL;
         END IF;
         CLOSE get_customer_discount;

         IF (discount_type_found_ IS NOT NULL) THEN
            Trace_SYS.Field('Additional discount searched in hierarchy until Customer ', customer_arr_(n_));
            -- keep discount_source
            discount_source_db_ := 'CUSTOMER';
            discount_source_id_ := customer_arr_(n_);
            part_level_db_      := 'PART';
            part_level_id_      := catalog_no_;
            customer_level_db_  := 'HIERARCHY';
            customer_level_id_  := customer_arr_(n_);
            RAISE found_discount;
         END IF;
      END LOOP;
   END IF;

   RAISE found_discount;
EXCEPTION
   WHEN found_discount THEN
      discount_        := nvl(discount_found_, 0);
      discount_type_   := discount_type_found_;
      discount_source_ := discount_source_db_;
      --Note: Compare discount from campaign and from another discount source and get the highest discount in order to get the lowest price.
      IF(low_price_found_allowed_) THEN 
         IF(nvl(campain_discount_,0) > nvl(discount_found_,0)) THEN        
            discount_type_       := campain_discount_type_;
            discount_            := nvl(campain_discount_, 0);
            min_quantity_        := 0;
            discount_source_     := 'CAMPAIGN';
            discount_source_id_  := temp_campaign_id_;
            part_level_db_       := 'ASSORTMENT';
            part_level_id_       := assortment_id_ || ' - ' || assortment_node_id_;
            customer_level_db_   := temp_customer_level_db_;
            customer_level_id_   := temp_customer_level_id_;
         END IF;
      END IF;
      Trace_SYS.Field('Discount Source >> ', discount_source_);
      Trace_SYS.Field('Discount Part Level >> ', part_level_db_);
      Trace_SYS.Field('Discount Part Level Id >> ', part_level_id_);
      Trace_SYS.Field('Discount Customer Level >> ', customer_level_db_);
      Trace_SYS.Field('Discount Customer Level Id >> ', customer_level_id_);
END Get_Additional_Discount___;


-- Duplicate_Price_List_Part___
--   Makes a copy of the specified part based record with current base price and
--   a new valid_from_ date. If the record already exist, only the base price is updated.
PROCEDURE Duplicate_Price_List_Part___ (
   no_of_changes_       OUT NUMBER,
   price_list_no_       IN  VARCHAR2,
   catalog_no_          IN  VARCHAR2,
   min_quantity_        IN  NUMBER,
   valid_from_date_     IN  DATE,
   min_duration_        IN  NUMBER,
   new_valid_from_date_ IN  DATE,
   percentage_offset_   IN  NUMBER,
   amount_offset_       IN  NUMBER,
   new_valid_to_date_   IN  DATE,
   modify_base_price_   IN  BOOLEAN,
   create_new_line_     IN  BOOLEAN )
IS
   base_price_                   NUMBER;
   base_price_in_spl_curr_       NUMBER;
   base_price_tax_in_spl_curr_   NUMBER;
   currency_rate_                NUMBER;
   curr_code_                    VARCHAR2(3);
   base_price_site_              VARCHAR2(5);
   discount_type_                VARCHAR2(25);
   discount_                     NUMBER;
   rounding_                     NUMBER;
   counter_                      NUMBER:=0;
   price_list_rec_               Sales_Price_List_API.Public_Rec;
   used_price_break_template_id_ VARCHAR2(10);
   sales_price_type_db_          VARCHAR2(20);
   tax_percentage_               NUMBER;
   base_price_incl_tax_          NUMBER;
   current_base_price_           NUMBER;
   current_base_price_incl_tax_  NUMBER;
   new_base_price_               NUMBER;
   new_base_price_incl_tax_      NUMBER;
   new_sales_price_              NUMBER;
   new_sales_price_incl_tax_     NUMBER;   
   calc_base_price_              NUMBER;
   calc_base_price_incl_tax_     NUMBER;
   
   CURSOR get_sales_price_list_part_info IS
      SELECT base_price_site, discount_type, discount, rounding, sales_price_type, base_price, base_price_incl_tax, price_break_template_id
      FROM   sales_price_list_part_tab
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    min_duration = min_duration_;
BEGIN
   -- Fetch record to duplicate.
   OPEN  get_sales_price_list_part_info;
   FETCH get_sales_price_list_part_info INTO base_price_site_, discount_type_, discount_, rounding_, sales_price_type_db_, current_base_price_, current_base_price_incl_tax_, used_price_break_template_id_;
   IF (get_sales_price_list_part_info%NOTFOUND) THEN
      CLOSE get_sales_price_list_part_info;
      Trace_SYS.Message('No record found');
   ELSE
      CLOSE get_sales_price_list_part_info;

      price_list_rec_ := Sales_Price_List_API.Get(price_list_no_);
      IF (Sales_Part_API.Get_Sales_Price_Group_Id(base_price_site_, catalog_no_) != price_list_rec_.sales_price_group_id) THEN
         Trace_SYS.Message('Invalid sales part ' || catalog_no_ || ' on price list ' || price_list_no_);
         no_of_changes_ := 0;
         RETURN;
      END IF;
      
      curr_code_ := price_list_rec_.currency_code;
      -- Fetch new base price/ base price incl tax
      IF (price_list_rec_.use_price_incl_tax = 'FALSE') THEN
         Sales_Part_Base_Price_API.Calculate_Base_Price(used_price_break_template_id_,
                                                        base_price_,
                                                        base_price_site_,
                                                        catalog_no_,
                                                        sales_price_type_db_,
                                                        min_quantity_,
                                                        price_list_rec_.use_price_break_templates,
                                                        min_duration_);
         -- Convert base price to price list currency.
         Get_Sales_Price_In_Currency(base_price_in_spl_curr_, currency_rate_, NULL, base_price_site_, curr_code_, base_price_, NULL);
      ELSE
         Sales_Part_Base_Price_API.Calculate_Base_Price_Incl_Tax(used_price_break_template_id_,
                                                                 base_price_incl_tax_,
                                                                 base_price_site_,
                                                                 catalog_no_,
                                                                 sales_price_type_db_,
                                                                 min_quantity_,
                                                                 price_list_rec_.use_price_break_templates,
                                                                 min_duration_);
         -- Convert base price incl tax to price list currency.
         Get_Sales_Price_In_Currency(base_price_tax_in_spl_curr_, currency_rate_, NULL, base_price_site_, curr_code_, base_price_incl_tax_, NULL);
      END IF; 
      
      IF (NOT create_new_line_) THEN
         --Modifies base prices
         IF (modify_base_price_) THEN
            -- Record already exist. Modify base price/base price incl tax.
            IF (price_list_rec_.use_price_incl_tax = 'FALSE') THEN
               calc_base_price_ := base_price_in_spl_curr_;
               new_base_price_ := base_price_in_spl_curr_;
               Sales_Part_Base_Price_API.Calculate_Part_Prices(calc_base_price_, 
                                                               new_base_price_incl_tax_, 
                                                               new_sales_price_, 
                                                               new_sales_price_incl_tax_, 
                                                               percentage_offset_, 
                                                               amount_offset_, 
                                                               base_price_site_, 
                                                               catalog_no_, 
                                                               'NET_BASE', 
                                                               'FORWARD', 
                                                               rounding_, 
                                                               16); 
            ELSE 
               calc_base_price_incl_tax_ := base_price_tax_in_spl_curr_;
               new_base_price_incl_tax_:= base_price_tax_in_spl_curr_;
               Sales_Part_Base_Price_API.Calculate_Part_Prices(new_base_price_, 
                                                               calc_base_price_incl_tax_, 
                                                               new_sales_price_, 
                                                               new_sales_price_incl_tax_, 
                                                               percentage_offset_, 
                                                               amount_offset_, 
                                                               base_price_site_, 
                                                               catalog_no_, 
                                                               'GROSS_BASE', 
                                                               'FORWARD', 
                                                               rounding_, 
                                                               16);                                                                 
            END IF;
            Sales_Price_List_Part_API.Modify_Price_Info(price_list_no_, 
                                                        catalog_no_, 
                                                        min_quantity_, 
                                                        valid_from_date_, 
                                                        min_duration_,
                                                        new_base_price_,
                                                        new_base_price_incl_tax_,
                                                        new_sales_price_,
                                                        new_sales_price_incl_tax_,
                                                        used_price_break_template_id_,
                                                        new_valid_to_date_,
                                                        percentage_offset_,
                                                        amount_offset_);
            counter_ := counter_ + 1;
         ELSE 
            --Modifies percentage offset and amount offset when new valid date is equal or older than current valid date
            Sales_Price_List_Part_API.Calculate_Sales_Prices(new_sales_price_,
                                                             new_sales_price_incl_tax_,
                                                             current_base_price_,
                                                             current_base_price_incl_tax_,
                                                             percentage_offset_,
                                                             amount_offset_,
                                                             rounding_,
                                                             base_price_site_,
                                                             catalog_no_,
                                                             price_list_rec_.use_price_incl_tax,
                                                             'FORWARD',
                                                             NULL,
                                                             NULL);
            Sales_Price_List_Part_API.Modify_Offset(price_list_no_,
                                                    catalog_no_,
                                                    min_quantity_,
                                                    valid_from_date_,
                                                    min_duration_,
                                                    percentage_offset_,
                                                    amount_offset_,
                                                    new_valid_to_date_,
                                                    new_sales_price_,
                                                    new_sales_price_incl_tax_);
            counter_ := counter_ + 1;
         END IF;
      ELSE   
         --add new record
         IF NOT(Sales_Price_List_Part_API.Check_Exist(price_list_no_,catalog_no_, min_quantity_, new_valid_from_date_, min_duration_)) THEN
            tax_percentage_  := NVL(Statutory_Fee_API.Get_Fee_Rate(Site_API.Get_Company(base_price_site_), Sales_Part_API.Get_Tax_Code(base_price_site_, catalog_no_)), 0);               
            Calculate_Sales_Prices___(new_sales_price_, 
                                      new_sales_price_incl_tax_, 
                                      base_price_in_spl_curr_, 
                                      base_price_tax_in_spl_curr_,
                                      percentage_offset_,
                                      amount_offset_,
                                      rounding_,
                                      tax_percentage_,
                                      price_list_rec_.use_price_incl_tax);
            Sales_Price_List_Part_API.New(price_list_no_,               catalog_no_,                min_quantity_, 
                                          new_valid_from_date_,         min_duration_,              base_price_site_,      discount_type_,
                                          discount_,                    base_price_in_spl_curr_,    base_price_tax_in_spl_curr_,
                                          new_sales_price_,             new_sales_price_incl_tax_,  percentage_offset_,
                                          amount_offset_,               rounding_,                   
                                          template_id_         => used_price_break_template_id_,
                                          sales_price_type_db_ => sales_price_type_db_,
                                          valid_to_date_ => new_valid_to_date_);

            counter_ := counter_ + 1;
         END IF;
      END IF;
   END IF;
   no_of_changes_ := counter_;
END Duplicate_Price_List_Part___;


-- Duplicate_Price_List_Unit___
--   Makes a copy of the specified unit based record but calculates a new sales price and
--   sets a new valid_from_ date. If the record already exist, only the sales price is updated.
--   The sales price is calculated from the previous one adding offsets.
PROCEDURE Duplicate_Price_List_Unit___ (
   price_list_no_       IN VARCHAR2,
   min_quantity_        IN NUMBER,
   valid_from_date_     IN DATE,
   new_valid_from_date_ IN DATE,
   percentage_offset_   IN NUMBER,
   amount_offset_       IN NUMBER,
   valid_to_date_       IN DATE )
IS
   sales_price_   NUMBER;
   discount_type_ VARCHAR2(25);
   discount_      NUMBER;
   rounding_      NUMBER;
   
   CURSOR get_sales_price_list_unit_info IS
      SELECT sales_price, discount_type, discount, rounding
      FROM   sales_price_list_unit_tab
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_;
BEGIN
   -- Fetch record to duplicate.
   OPEN  get_sales_price_list_unit_info;
   FETCH get_sales_price_list_unit_info INTO sales_price_, discount_type_, discount_, rounding_;
   IF (get_sales_price_list_unit_info%NOTFOUND) THEN
      CLOSE get_sales_price_list_unit_info;
      Trace_SYS.Message('No record found');
   ELSE
      CLOSE get_sales_price_list_unit_info;

      -- Calculate new sales price.
      sales_price_ := ROUND((sales_price_ * (1 + percentage_offset_ / 100)) + amount_offset_, NVL(rounding_,20));

      IF (new_valid_from_date_ = valid_from_date_) THEN
         -- Record already exist. Modify sales price.
         Sales_Price_List_Unit_API.Modify_Sales_Price(price_list_no_   => price_list_no_,
                                                      min_quantity_    => min_quantity_,
                                                      valid_from_date_ => valid_from_date_,
                                                      sales_price_     => sales_price_,
                                                      valid_to_date_  => valid_to_date_);
      ELSE
         -- Duplicate record with new valid_from_date.
         Sales_Price_List_Unit_API.New(price_list_no_, min_quantity_, new_valid_from_date_,
                                       discount_type_, discount_, sales_price_, rounding_, valid_to_date_);
      END IF;
   END IF;
END Duplicate_Price_List_Unit___;


-- Duplicate_Price_List_Assort___
--   If there is a SalesPriceListAssort record for the given keys modify that with offset.
--   Create a new record for new_valid_from_date_ otherwise.
PROCEDURE Duplicate_Price_List_Assort___ (
   price_list_no_       IN VARCHAR2,
   min_quantity_        IN NUMBER,
   valid_from_date_     IN DATE,
   assortment_id_       IN VARCHAR2,
   assortment_node_id_  IN VARCHAR2,
   price_unit_meas_     IN VARCHAR2,
   new_valid_from_date_ IN DATE,
   percentage_offset_   IN NUMBER,
   amount_offset_       IN NUMBER,
   valid_to_date_       IN DATE )
IS
   sales_price_          NUMBER;
   discount_type_        VARCHAR2(25);
   discount_             NUMBER;
   rounding_             NUMBER;
   
   CURSOR get_price_list_assort_info IS
      SELECT sales_price, discount_type, discount, rounding
      FROM   sales_price_list_assort_tab
      WHERE  price_list_no      = price_list_no_
      AND    min_quantity       = min_quantity_
      AND    valid_from_date    = valid_from_date_
      AND    assortment_id      = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas    = price_unit_meas_;
BEGIN
   -- Fetch record to duplicate.
   OPEN  get_price_list_assort_info;
   FETCH get_price_list_assort_info INTO sales_price_, discount_type_, discount_, rounding_;
   IF (get_price_list_assort_info%NOTFOUND) THEN
      CLOSE get_price_list_assort_info;
   ELSE
      CLOSE get_price_list_assort_info;

      -- Calculate new sales price.
      sales_price_ := ROUND((sales_price_ * (1 + percentage_offset_ / 100)) + amount_offset_, NVL(rounding_,20));
      IF (new_valid_from_date_ = valid_from_date_) THEN
         -- Record already exist. Modify sales price.
         Sales_Price_List_Assort_API.Modify_Sales_Price(price_list_no_      => price_list_no_,
                                                        min_quantity_       => min_quantity_,
                                                        valid_from_date_    => valid_from_date_,
                                                        assortment_id_      => assortment_id_,
                                                        assortment_node_id_ => assortment_node_id_,
                                                        price_unit_meas_    => price_unit_meas_,
                                                        sales_price_        => sales_price_,
                                                        valid_to_date_      => valid_to_date_);
      ELSE
         -- Duplicate record with new valid_from_date.
         Sales_Price_List_Assort_API.New_Line(price_list_no_      => price_list_no_,
                                              min_quantity_       => min_quantity_,
                                              valid_from_date_    => new_valid_from_date_,
                                              assortment_id_      => assortment_id_,
                                              assortment_node_id_ => assortment_node_id_,
                                              price_unit_meas_    => price_unit_meas_,
                                              rounding_           => rounding_,
                                              sales_price_        => sales_price_,
                                              discount_           => discount_,
                                              discount_type_      => discount_type_,
                                              valid_to_date_      => valid_to_date_);
      END IF;
   END IF;
END Duplicate_Price_List_Assort___;


-- Update_Part_Prices___
--   Updates part based records using specified select criteria on price lists,
--   fetching currect base prices. Returns the number of updates made.
PROCEDURE Update_Part_Prices___ (
   number_of_updates_      OUT NUMBER,
   valid_from_date_        IN  DATE,
   sales_price_origin_db_  IN  VARCHAR2,
   price_list_attr_        IN  VARCHAR2,
   sales_price_group_attr_ IN  VARCHAR2,
   catalog_no_attr_        IN  VARCHAR2,
   base_price_site_attr_   IN  VARCHAR2,
   company_attr_           IN  VARCHAR2,
   update_sales_prices_    IN  VARCHAR2,
   update_rental_prices_   IN  VARCHAR2,
   include_period_         IN  VARCHAR2 )
IS
   counter_                   NUMBER := 0;
   number_of_changes_         NUMBER := 0;
   sales_price_origin_        VARCHAR2(200);
   price_list_where_          VARCHAR2(2000);
   sales_price_group_where_   VARCHAR2(2000);
   catalog_no_where_          VARCHAR2(2000);
   base_price_site_where_     VARCHAR2(2000);
   company_where_             VARCHAR2(2000);
   attr_                      VARCHAR2(2000);
   stmt_                     VARCHAR2(32000);
 --  stmt2_                     VARCHAR2(32000);
   TYPE dynamic_cursor_type   IS REF CURSOR;
   dynamic_cursor_            dynamic_cursor_type;

   price_list_no_             SALES_PRICE_LIST_TAB.price_list_no%TYPE;
   catalog_no_                SALES_PRICE_LIST_PART_TAB.catalog_no%TYPE;
   min_quantity_              SALES_PRICE_LIST_PART_TAB.min_quantity%TYPE;
   line_valid_from_date_      SALES_PRICE_LIST_PART_TAB.valid_from_date%TYPE;
   line_valid_to_date_        SALES_PRICE_LIST_PART_TAB.valid_to_date%TYPE;
   percentage_offset_         SALES_PRICE_LIST_PART_TAB.percentage_offset%TYPE;
   amount_offset_             SALES_PRICE_LIST_PART_TAB.amount_offset%TYPE;
   base_price_site_           SALES_PRICE_LIST_PART_TAB.base_price_site%TYPE;
   discount_type_             SALES_PRICE_LIST_PART_TAB.discount_type%TYPE;
   discount_                  SALES_PRICE_LIST_PART_TAB.discount%TYPE;
   min_duration_              SALES_PRICE_LIST_PART_TAB.min_duration%TYPE;
   sales_price_type_db_       SALES_PRICE_LIST_PART_TAB.sales_price_type%TYPE;
   new_valid_to_date_         DATE;
   exist_rec_                 Sales_Price_List_Part_tab%ROWTYPE;
   new_valid_from_date_       DATE;
   create_new_line_           BOOLEAN;
   next_valid_from_date_      DATE;
   next_valid_to_date_        DATE;
   next_valid_from_found_     BOOLEAN := FALSE;
   line_count_                NUMBER;
   new_line_from_date_        DATE;
   prev_price_list_no_        VARCHAR2(10);
   prev_catalog_no_           VARCHAR2(25);
   prev_min_quantity_         NUMBER;
   prev_min_duration_         NUMBER;
   same_date_record_updated_  BOOLEAN := FALSE;
   new_rec_created_on_from_date_  BOOLEAN;
   dummy_                     NUMBER;
   
   CURSOR get_exist_record(price_list_no_ IN VARCHAR2, catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN NUMBER, new_from_date_ IN DATE) IS
      SELECT *
      FROM sales_price_list_part_tab
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    valid_from_date = new_from_date_; 

   CURSOR get_adjacent_valid_rec(price_list_no_ IN VARCHAR2, catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN NUMBER, next_valid_from_date_ IN DATE) IS
      SELECT valid_to_date
      FROM   sales_price_list_part_tab
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    valid_from_date = next_valid_from_date_;
   
   CURSOR check_overlap_rec_found(price_list_no_ IN VARCHAR2, catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN NUMBER, from_date_ IN DATE, to_date_ IN DATE) IS
      SELECT 1
      FROM sales_price_list_part_tab
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    valid_to_date IS NULL
      AND    valid_from_date > from_date_
      AND    valid_from_date <= to_date_;
  
BEGIN
   number_of_updates_ := 0;
   -- If both update_sales_prices_ and update_rental_prices_ are 'FALSE', non of the records updated.
   IF (update_sales_prices_ = Fnd_Boolean_API.DB_FALSE) AND (update_rental_prices_ = Fnd_Boolean_API.DB_FALSE) THEN
      RETURN;
   END IF;

   sales_price_origin_ := Sales_Price_Origin_API.Decode(sales_price_origin_db_);

   -- Convert input variables to where conditions
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('pl.price_list_no', price_list_attr_, attr_);
   price_list_where_ := Report_SYS.Parse_Where_Expression(attr_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('sales_price_group_id', sales_price_group_attr_, attr_);
   sales_price_group_where_ := Report_SYS.Parse_Where_Expression(attr_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('catalog_no', catalog_no_attr_, attr_);
   catalog_no_where_ := Report_SYS.Parse_Where_Expression(attr_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('base_price_site', base_price_site_attr_, attr_);
   base_price_site_where_ := Report_SYS.Parse_Where_Expression(attr_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('pl.owning_company', company_attr_, attr_);
   company_where_ := Report_SYS.Parse_Where_Expression(attr_);
   
   IF (include_period_ = 'FALSE') THEN
      stmt_ := 'SELECT pl.price_list_no, plp.catalog_no, plp.min_quantity, plp.valid_from_date, plp.min_duration, plp.percentage_offset, plp.amount_offset, 
                       plp.base_price_site, plp.discount_type, plp.discount, plp.sales_price_type
            FROM  sales_price_list_tab pl, sales_price_list_part_tab plp
            WHERE  pl.price_list_no = plp.price_list_no
            AND    pl.owning_company IN (SELECT company FROM  company_finance_auth_pub)
            AND   (Sales_Part_Base_Price_API.Get_Sales_Price_Origin(base_price_site, catalog_no, Sales_Price_Type_API.Decode(plp.sales_price_type)) = :sales_price_origin OR :sales_price_origin_db IS NULL)';
               
   ELSE 
      stmt_ := 'SELECT pl.price_list_no, plp.catalog_no, plp.min_quantity, plp.valid_from_date, plp.valid_to_date, plp.min_duration, plp.percentage_offset, plp.amount_offset, 
                       plp.base_price_site, plp.discount_type, plp.discount, plp.sales_price_type
            FROM  sales_price_list_tab pl, sales_price_list_part_tab plp
            WHERE  pl.price_list_no = plp.price_list_no
            AND    pl.owning_company IN (SELECT company FROM  company_finance_auth_pub)
            AND   (Sales_Part_Base_Price_API.Get_Sales_Price_Origin(base_price_site, catalog_no, Sales_Price_Type_API.Decode(plp.sales_price_type)) = :sales_price_origin OR :sales_price_origin_db IS NULL)';
   END IF;

   IF price_list_where_ IS NOT NULL THEN
      stmt_ := stmt_ || ' AND ' || price_list_where_;
   END IF;
   IF company_where_ IS NOT NULL THEN
      stmt_ := stmt_ || ' AND ' || company_where_;
   END IF;
   IF sales_price_group_where_ IS NOT NULL THEN
      stmt_ := stmt_ || ' AND ' || sales_price_group_where_;
   END IF;
   IF catalog_no_where_ IS NOT NULL THEN
      stmt_ := stmt_ || ' AND ' || catalog_no_where_;
   END IF;
   IF base_price_site_where_ IS NOT NULL THEN
      stmt_ := stmt_ || ' AND ' || base_price_site_where_;
   END IF;
   IF (update_sales_prices_ = Fnd_Boolean_API.DB_TRUE AND update_rental_prices_ = Fnd_Boolean_API.DB_FALSE) THEN
      stmt_ := stmt_ || ' AND sales_price_type = ''SALES PRICES''';
   ELSIF (update_sales_prices_ = Fnd_Boolean_API.DB_FALSE AND update_rental_prices_ = Fnd_Boolean_API.DB_TRUE) THEN
      stmt_ := stmt_ || ' AND sales_price_type = ''RENTAL PRICES''';
   END IF;

   -- Note: Removed GROUP BY and added ORDER BY
   -- Note: Added DESC to the ORDER BY
   IF (include_period_ = 'FALSE') THEN  
      stmt_ := stmt_ || 'AND    NVL(plp.valid_to_date, :valid_from_date) >= :valid_from_date
                         AND    plp.valid_to_date IS NULL
                         AND   (pl.price_list_no, plp.catalog_no, plp.min_quantity, plp.min_duration, plp.valid_from_date) IN
                           (SELECT price_list_no, catalog_no, min_quantity, min_duration, valid_from_date
                            FROM  sales_price_list_part_tab
                            WHERE (price_list_no, catalog_no, min_quantity, min_duration, valid_from_date) IN
                              (SELECT price_list_no, catalog_no, min_quantity, min_duration, MAX(valid_from_date) valid_from_date
                               FROM   sales_price_list_part_tab
                               WHERE  valid_from_date <= :valid_from_date
                               AND    valid_to_date IS NULL
                               GROUP BY price_list_no, catalog_no, min_quantity, min_duration)
                               UNION ALL
                              (SELECT price_list_no, catalog_no, min_quantity, min_duration, valid_from_date
                               FROM   sales_price_list_part_tab
                               WHERE  valid_from_date > :valid_from_date
                               AND    valid_to_date IS NULL))
               ORDER BY pl.price_list_no, plp.catalog_no, plp.min_quantity, plp.min_duration, plp.valid_from_date';
   ELSE 
      stmt_ := stmt_ || 'AND    NVL(plp.valid_to_date, :valid_from_date) >= :valid_from_date
                         AND   (pl.price_list_no, plp.catalog_no, plp.min_quantity, plp.min_duration, plp.valid_from_date) IN
                           (SELECT price_list_no, catalog_no, min_quantity, min_duration, valid_from_date
                            FROM  sales_price_list_part_tab
                            WHERE (price_list_no, catalog_no, min_quantity, min_duration, valid_from_date) IN
                              (SELECT price_list_no, catalog_no, min_quantity, min_duration, MAX(valid_from_date) valid_from_date
                               FROM   sales_price_list_part_tab
                               WHERE  valid_from_date <= :valid_from_date
                               AND    valid_to_date IS NULL
                               GROUP BY price_list_no, catalog_no, min_quantity, min_duration)
                               UNION ALL
                              (SELECT price_list_no, catalog_no, min_quantity, min_duration, valid_from_date
                               FROM   sales_price_list_part_tab
                               WHERE  valid_from_date >= :valid_from_date)
                               UNION ALL
                              (SELECT price_list_no, catalog_no, min_quantity, min_duration, valid_from_date
                               FROM   sales_price_list_part_tab
                               WHERE  valid_to_date IS NOT NULL
                               AND    valid_from_date < :valid_from_date
                               AND    valid_to_date >= :valid_from_date ))
               ORDER BY pl.price_list_no, plp.catalog_no, plp.min_quantity, plp.min_duration, plp.valid_from_date';
   END IF;   

   IF (include_period_ = 'FALSE') THEN
      -- Fetch with the previously created select statement
      @ApproveDynamicStatement(2007-04-25,CSAMLK)
      OPEN dynamic_cursor_ FOR stmt_ USING sales_price_origin_, sales_price_origin_db_, TRUNC(valid_from_date_), TRUNC(valid_from_date_), TRUNC(valid_from_date_), TRUNC(valid_from_date_);
      LOOP
         FETCH dynamic_cursor_ INTO price_list_no_, catalog_no_, min_quantity_, line_valid_from_date_, min_duration_, percentage_offset_, amount_offset_, base_price_site_,
                                    discount_type_, discount_, sales_price_type_db_;
         EXIT WHEN dynamic_cursor_%NOTFOUND;
         IF (Sales_Part_Base_Price_API.Get_Objstate(base_price_site_, catalog_no_, Sales_Price_Type_API.Decode(sales_price_type_db_)) = 'Active') THEN
            new_valid_from_date_ := NULL;
            create_new_line_ := FALSE;
            exist_rec_ := NULL;
            next_valid_from_date_ := NULL;
            next_valid_to_date_ := NULL;
            
            IF (line_valid_from_date_ < valid_from_date_) THEN
               -- Need to create a new line with valid from_date = valid_from_date_.
               -- For that we need to check whether any record exists with that valid_from_date.
               next_valid_from_found_ := FALSE;
               new_valid_from_date_ := valid_from_date_;
               LOOP
                  EXIT WHEN (next_valid_from_found_);
                  OPEN get_exist_record(price_list_no_, catalog_no_, min_quantity_, min_duration_, new_valid_from_date_);
                  FETCH get_exist_record INTO exist_rec_;
                  IF (get_exist_record%FOUND) THEN
                     CLOSE get_exist_record;
                     IF (exist_rec_.valid_to_date IS NULL) THEN
                        -- record exist with valid_from_date = valid_from_date_ and valid_to_date null. Hence no need to create a new record
                        next_valid_from_found_ := TRUE;
                        create_new_line_ := FALSE;
                     ELSE
                        new_valid_from_date_ := exist_rec_.valid_to_date + 1; 
                     END IF;   
                  ELSE
                     CLOSE get_exist_record;
                     create_new_line_ := TRUE;
                     next_valid_from_found_ := TRUE;
                  END IF;   
               END LOOP;
               IF (create_new_line_) THEN
                  -- find the next record with valid_to_date null. If that record valid_from_date is earlier than our new valid_from_date then no need to create the record
                  OPEN check_overlap_rec_found(price_list_no_, catalog_no_, min_quantity_, min_duration_, valid_from_date_, new_valid_from_date_);
                  FETCH check_overlap_rec_found INTO dummy_;
                  IF (check_overlap_rec_found%NOTFOUND) THEN
                     CLOSE check_overlap_rec_found;
                     -- create new record with valid_from_date = valid_from_date_
                     Duplicate_Price_List_Part___(line_count_, price_list_no_, catalog_no_, min_quantity_, line_valid_from_date_,
                                                  min_duration_, new_valid_from_date_, percentage_offset_, amount_offset_, NULL, TRUE, TRUE);                                              
                     counter_ := counter_ + line_count_;
                  ELSE
                     CLOSE check_overlap_rec_found;
                  END IF;
               END IF;
            ELSE
               -- line_valid_from_date >= user defined from_date. Hence update those records with base price.
               Duplicate_Price_List_Part___(line_count_, price_list_no_, catalog_no_, min_quantity_, line_valid_from_date_,
                                            min_duration_, line_valid_from_date_, percentage_offset_, amount_offset_, NULL, TRUE, FALSE);
               counter_ := counter_ + line_count_;
            END IF;
        -- END IF;
         END IF;
      END LOOP;
      CLOSE dynamic_cursor_;
   ELSE
      -- include_period_ = TRUE
      @ApproveDynamicStatement(2016-10-07, ChFolk)
      OPEN dynamic_cursor_ FOR stmt_ USING sales_price_origin_, sales_price_origin_db_, TRUNC(valid_from_date_), TRUNC(valid_from_date_), TRUNC(valid_from_date_), TRUNC(valid_from_date_), TRUNC(valid_from_date_), TRUNC(valid_from_date_);
      LOOP
         FETCH dynamic_cursor_ INTO price_list_no_, catalog_no_, min_quantity_, line_valid_from_date_, line_valid_to_date_, min_duration_, percentage_offset_, amount_offset_, base_price_site_,
                                    discount_type_, discount_, sales_price_type_db_;
         EXIT WHEN dynamic_cursor_%NOTFOUND;
         IF (Sales_Part_Base_Price_API.Get_Objstate(base_price_site_, catalog_no_, Sales_Price_Type_API.Decode(sales_price_type_db_)) = 'Active') THEN
            next_valid_to_date_ := NULL;
            create_new_line_ := FALSE;
            exist_rec_ := NULL; 
            new_line_from_date_ := NULL;
            IF ((NVL(prev_price_list_no_, price_list_no_) != price_list_no_) OR (NVL(prev_catalog_no_, catalog_no_) != catalog_no_) 
               OR (NVL(prev_min_quantity_, min_quantity_) != min_quantity_) OR (NVL(prev_min_duration_, min_duration_) != min_duration_)) THEN
               same_date_record_updated_ := FALSE;
               new_rec_created_on_from_date_ := FALSE;
            END IF;
            IF (line_valid_from_date_ < valid_from_date_) THEN
               IF (line_valid_to_date_ IS NOT NULL) THEN
                  -- timeframe record found. that has to be broken into two. with old prices and new prices with adjustments.
                  -- update record with valid_to_date = valid_from_date_ - 1 
                  new_valid_to_date_ := valid_from_date_ - 1;
                  Sales_Price_List_Part_API.Modify_Valid_To_Date(price_list_no_, catalog_no_, min_quantity_, line_valid_from_date_, min_duration_, new_valid_to_date_);
               END IF;
               -- create a new line with valid from date = valid_from_date_. If any line exists with same valid_from_date_ update that record
               OPEN get_exist_record(price_list_no_, catalog_no_, min_quantity_, min_duration_, valid_from_date_);
               FETCH get_exist_record INTO exist_rec_;
               CLOSE get_exist_record;
               IF (exist_rec_.valid_from_date IS NOT NULL) THEN
                  -- there is an record exists with given valid_from_date
                  IF (line_valid_to_date_ IS NOT NULL) THEN
                     -- current line has a valid_to_date. Hence we have to update it with new base price. But we need to create a new line after the todate.
                     IF (NOT same_date_record_updated_) THEN
                        -- update existing record with price information of line_rec_ and offset from existing rec
                        Duplicate_Price_List_Part___(line_count_, price_list_no_, catalog_no_, min_quantity_, valid_from_date_,
                                                     min_duration_, valid_from_date_, percentage_offset_, amount_offset_, line_valid_to_date_, TRUE, FALSE);
                        counter_ := counter_ + line_count_;
                        same_date_record_updated_ := TRUE;
                     END IF;
                     next_valid_to_date_ := line_valid_to_date_;
                     IF (exist_rec_.valid_to_date IS NULL AND new_rec_created_on_from_date_) THEN
                        -- new line has already created on the user specified valid_from_date which falls in between the current line timeframe
                        -- Needs to modify the valid_to_date as well as correct offset values from the current line. 
                       -- Sales_Price_List_Part_API.Modify_Offset(price_list_no_, catalog_no_, min_quantity_, valid_from_date_, min_duration_, percentage_offset_, amount_offset_, line_valid_to_date_, exist_rec_.sales_price, exist_rec_.sales_price_incl_tax);  
                        Duplicate_Price_List_Part___(line_count_, price_list_no_, catalog_no_, min_quantity_, valid_from_date_,
                                                     min_duration_, valid_from_date_, percentage_offset_, amount_offset_, line_valid_to_date_, TRUE, FALSE);
                        -- No need to increase the line_count here as this line is already counted at the time of creation. 
                        -- Here it is just modifying with correct offset and to_date which were unable to decide at the time of creation.                                                
                     END IF;
                  ELSE
                     IF (NOT same_date_record_updated_) THEN
                        -- if line_rec_ is not timeframed, existing record can be modified only with offset values
                        Duplicate_Price_List_Part___(line_count_, price_list_no_, catalog_no_, min_quantity_, valid_from_date_,
                                                     min_duration_, valid_from_date_, exist_rec_.percentage_offset, exist_rec_.amount_offset, exist_rec_.valid_to_date, TRUE, FALSE);
                        counter_ := counter_ + line_count_;
                        same_date_record_updated_ := TRUE;
                     END IF;   
                     next_valid_to_date_ := exist_rec_.valid_to_date;
                  END IF;
                  next_valid_from_found_ := FALSE;
                  create_new_line_ := FALSE;
                  LOOP
                     EXIT WHEN next_valid_from_found_;
                     new_line_from_date_ := next_valid_to_date_ + 1;
                     OPEN get_adjacent_valid_rec(price_list_no_, catalog_no_, min_quantity_, min_duration_, new_line_from_date_);
                     FETCH get_adjacent_valid_rec INTO next_valid_to_date_;
                     IF (get_adjacent_valid_rec%FOUND) THEN
                        CLOSE get_adjacent_valid_rec;
                        IF (next_valid_to_date_ IS NULL) THEN
                           next_valid_from_found_ := TRUE;
                           create_new_line_ := FALSE;
                        END IF;
                     ELSE      
                        CLOSE get_adjacent_valid_rec;
                        create_new_line_ := TRUE;
                        next_valid_from_found_ := TRUE;
                     END IF;
                  END LOOP;
                  IF (create_new_line_) THEN
                     -- need to create a new line with valid_from_date = next_valid_to_date_ + 1 = new_line_from_date_;.
                     OPEN check_overlap_rec_found(price_list_no_, catalog_no_, min_quantity_, min_duration_, valid_from_date_, new_line_from_date_);
                     FETCH check_overlap_rec_found INTO dummy_;
                     IF (check_overlap_rec_found%NOTFOUND) THEN
                        CLOSE check_overlap_rec_found;
                        IF (line_valid_to_date_ IS NOT NULL) THEN
                           -- create new line on new_line_from_date_
                           Duplicate_Price_List_Part___(line_count_, price_list_no_, catalog_no_, min_quantity_, valid_from_date_,
                                                        min_duration_, new_line_from_date_, exist_rec_.percentage_offset, exist_rec_.amount_offset, NULL, TRUE, TRUE);                 
                           counter_ := counter_ + line_count_;
                        ELSE
                         -- if no overlapping rec found. The  create the line 
                           Duplicate_Price_List_Part___(line_count_, price_list_no_, catalog_no_, min_quantity_, line_valid_from_date_,
                                                        min_duration_, new_line_from_date_, percentage_offset_, amount_offset_, NULL, TRUE, TRUE); 
                           counter_ := counter_ + line_count_;
                        END IF;
                       
                     ELSE
                        CLOSE check_overlap_rec_found;
                        -- no need to create the line
                     END IF;
                  END IF;
               ELSE
                  -- There is no record exists in the given valid_from_date. Hence create a new record on that date
                  IF (NOT same_date_record_updated_) THEN
                     -- No record exists on user defined from_date_. Hence Create a new line on that date with offset adjustment     
                     Duplicate_Price_List_Part___(line_count_, price_list_no_, catalog_no_, min_quantity_, line_valid_from_date_,
                                                  min_duration_, valid_from_date_, percentage_offset_, amount_offset_, line_valid_to_date_, TRUE, TRUE);
                     counter_ := counter_ + line_count_;
                     same_date_record_updated_ := TRUE;
                     new_rec_created_on_from_date_ := TRUE;
                  END IF;
               END IF;
            ELSIF ( (line_valid_from_date_ > valid_from_date_) OR (line_valid_from_date_ = valid_from_date_ AND NOT same_date_record_updated_)) THEN
               -- update the existing lines with new base price
               Duplicate_Price_List_Part___(line_count_, price_list_no_, catalog_no_, min_quantity_, line_valid_from_date_,
                                            min_duration_, line_valid_from_date_, percentage_offset_, amount_offset_, line_valid_to_date_, TRUE, FALSE);
               counter_ := counter_ + line_count_;
            END IF;
            prev_price_list_no_ := price_list_no_;
            prev_catalog_no_ := catalog_no_;
            prev_min_quantity_ := min_quantity_;
            prev_min_duration_ := min_duration_;
         END IF;
      END LOOP;
      CLOSE dynamic_cursor_;
   END IF;
   number_of_updates_ := counter_;
END Update_Part_Prices___;


-- Update_Unit_Prices___
--   Updates unit based records with specified select criteria on price lists,
--   using the offsets to set the new sales price . Returns the number of updates made.
PROCEDURE Update_Unit_Prices___ (
   number_of_updates_      OUT NUMBER,
   valid_from_date_        IN  DATE,
   percentage_offset_      IN  NUMBER,
   amount_offset_          IN  NUMBER,
   price_list_attr_        IN  VARCHAR2,
   sales_price_group_attr_ IN  VARCHAR2,
   company_attr_           IN  VARCHAR2,
   include_period_         IN  VARCHAR2 )
IS
   counter_                    NUMBER := 0;
   new_valid_to_date_          DATE;
   new_valid_from_date_        DATE;
   next_valid_from_found_      BOOLEAN := FALSE;
   dummy_                      NUMBER;
   create_new_line_            BOOLEAN;
   exist_rec_                  Sales_Price_List_Unit_tab%ROWTYPE;
   sales_price_                NUMBER;
   next_valid_from_date_       DATE;
   next_valid_to_date_         DATE;
   same_date_record_updated_   BOOLEAN := FALSE;
   new_line_from_date_         DATE;
   prev_price_list_no_         VARCHAR2(10);
   prev_min_quantity_          NUMBER;
   new_rec_created_on_from_date_ BOOLEAN;
   
   CURSOR find_null_valid_to_date_recs IS
         SELECT pl.price_list_no, plu.min_quantity, plu.valid_from_date, plu.sales_price, plu.rounding
         FROM  sales_price_list_tab pl, sales_price_list_unit_tab plu
         WHERE  pl.price_list_no = plu.price_list_no
         AND    pl.owning_company IN (SELECT company 
                                      FROM   company_finance_auth_pub)
         AND    Report_SYS.Parse_Parameter(pl.owning_company, company_attr_) = db_true_
         AND    Report_SYS.Parse_Parameter(pl.price_list_no, price_list_attr_) = db_true_
         AND    Report_SYS.Parse_Parameter(sales_price_group_id, sales_price_group_attr_) = db_true_
         AND    NVL(pl.valid_to_date, valid_from_date_) >= valid_from_date_
         AND    plu.valid_to_date IS NULL
         AND   (pl.price_list_no, plu.min_quantity, plu.valid_from_date) IN
             (SELECT price_list_no, min_quantity, valid_from_date
              FROM  sales_price_list_unit_tab
              WHERE (price_list_no, min_quantity, valid_from_date) IN
                    (SELECT price_list_no, min_quantity, MAX(valid_from_date) valid_from_date
                     FROM   sales_price_list_unit_tab
                     WHERE  valid_from_date <= valid_from_date_
                     AND    valid_to_date IS NULL
                     GROUP BY price_list_no, min_quantity)
                     UNION ALL
                     (SELECT price_list_no, min_quantity, valid_from_date
                      FROM   sales_price_list_unit_tab
                      WHERE  valid_from_date > valid_from_date_
                      AND    valid_to_date IS NULL))
         ORDER BY pl.price_list_no, plu.min_quantity, plu.valid_from_date;
         
   CURSOR find_valid_record IS
         SELECT pl.price_list_no, plu.min_quantity, plu.valid_from_date, plu.valid_to_date, plu.sales_price, plu.rounding
         FROM  sales_price_list_tab pl, sales_price_list_unit_tab plu
         WHERE  pl.price_list_no = plu.price_list_no
         AND    pl.owning_company IN (SELECT company 
                                      FROM   company_finance_auth_pub)
         AND    Report_SYS.Parse_Parameter(pl.owning_company, company_attr_) = db_true_
         AND    Report_SYS.Parse_Parameter(pl.price_list_no, price_list_attr_) = db_true_
         AND    Report_SYS.Parse_Parameter(sales_price_group_id, sales_price_group_attr_) = db_true_
         AND    NVL(pl.valid_to_date, valid_from_date_) >= valid_from_date_
         AND   (pl.price_list_no, plu.min_quantity, plu.valid_from_date) IN
             (SELECT price_list_no, min_quantity, valid_from_date
              FROM  sales_price_list_unit_tab
              WHERE (price_list_no, min_quantity, valid_from_date) IN
                    (SELECT price_list_no, min_quantity, MAX(valid_from_date) valid_from_date
                     FROM   sales_price_list_unit_tab
                     WHERE  valid_from_date <= valid_from_date_
                     AND    valid_to_date IS NULL
                     GROUP BY price_list_no, min_quantity)
                     UNION ALL
                     (SELECT price_list_no, min_quantity, valid_from_date
                      FROM   sales_price_list_unit_tab
                      WHERE  valid_from_date >= valid_from_date_)
                     UNION ALL
                     (SELECT price_list_no, min_quantity, valid_from_date
                     FROM   sales_price_list_unit_tab
                     WHERE  valid_to_date IS NOT NULL
                     AND    valid_from_date < valid_from_date_
                     AND    valid_to_date >= valid_from_date_ ))
         ORDER BY pl.price_list_no, plu.min_quantity, plu.valid_from_date;
         
   CURSOR get_adjacent_valid_rec(price_list_no_ IN VARCHAR2, min_quantity_ IN NUMBER, new_valid_from_date_ IN DATE) IS
      SELECT valid_to_date
      FROM   sales_price_list_unit_tab
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = new_valid_from_date_;
      
   CURSOR check_overlap_rec_found(price_list_no_ IN VARCHAR2, min_quantity_ IN NUMBER, from_date_ IN DATE, to_date_ IN DATE) IS
      SELECT 1
      FROM sales_price_list_unit_tab
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    valid_to_date IS NULL
      AND    valid_from_date > from_date_
      AND    valid_from_date <= to_date_;
         
   CURSOR get_exist_record(price_list_no_ IN VARCHAR2, min_quantity_ IN NUMBER, from_date_ IN DATE) IS
      SELECT *
      FROM sales_price_list_unit_tab
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = from_date_;

BEGIN 
   IF (include_period_ = 'FALSE') THEN
      FOR line_rec_ IN find_null_valid_to_date_recs LOOP
         new_valid_from_date_ := NULL;
         create_new_line_ := FALSE;
         exist_rec_ := NULL;
         next_valid_from_date_ := NULL;
         next_valid_to_date_ := NULL;
         IF (line_rec_.valid_from_date < valid_from_date_) THEN
            -- Need to create a new line with valid from_date = valid_from_date_.
            -- FOr that we need to check whether any record exists with that valid_from_date.
            next_valid_from_found_ := FALSE;
            new_valid_from_date_ := valid_from_date_;
            LOOP
               EXIT WHEN (next_valid_from_found_);
              -- new_valid_from_date_ := timeframe_valid_to_date_ + 1;
               OPEN get_exist_record(line_rec_.price_list_no, line_rec_.min_quantity, new_valid_from_date_);
               FETCH get_exist_record INTO exist_rec_;
               IF (get_exist_record%FOUND) THEN
                  CLOSE get_exist_record;
                  IF (exist_rec_.valid_to_date IS NULL) THEN
                     -- record exist with valid_from_date = new_valid_from_date_ and valid_to_date null. Hence no need to create a new record
                     next_valid_from_found_ := TRUE;
                     create_new_line_ := FALSE;
                  ELSE
                     new_valid_from_date_ := exist_rec_.valid_to_date + 1; 
                  END IF;   
               ELSE
                  CLOSE get_exist_record;
                  create_new_line_ := TRUE;
                  next_valid_from_found_ := TRUE;
               END IF;   
            END LOOP;
            IF (create_new_line_) THEN
               -- find the next record with valid_to_date null. If that record valid_from_date is earlier than our new valid_from_date then no need to create the record
               OPEN check_overlap_rec_found(line_rec_.price_list_no, line_rec_.min_quantity, valid_from_date_, new_valid_from_date_);
               FETCH check_overlap_rec_found INTO dummy_;
               IF (check_overlap_rec_found%NOTFOUND) THEN
                  CLOSE check_overlap_rec_found;
                  -- create new record with valid_from_date = new_valid_from_date_
                  Duplicate_Price_List_Unit___(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                               new_valid_from_date_, percentage_offset_, amount_offset_, NULL);
                  counter_ := counter_ + 1;
               ELSE
                  CLOSE check_overlap_rec_found;
               END IF;
            END IF;   
         ELSE
            -- valid_from_date >= user defined from_date. Hence update those records with the given offset.
            Duplicate_Price_List_Unit___(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                         line_rec_.valid_from_date, percentage_offset_, amount_offset_, NULL);
            counter_ := counter_ + 1;
         END IF;   
      END LOOP; 
   ELSE
      -- include_period = TRUE
      FOR line_rec_ IN find_valid_record LOOP
         next_valid_to_date_ := NULL;
         create_new_line_ := FALSE;
         exist_rec_ := NULL; 
         new_line_from_date_ := NULL;
         IF ((NVL(prev_price_list_no_, line_rec_.price_list_no) != line_rec_.price_list_no) OR NVL(prev_min_quantity_, line_rec_.min_quantity) != line_rec_.min_quantity) THEN
            same_date_record_updated_ := FALSE;
            new_rec_created_on_from_date_ := FALSE;
         END IF;
         IF (line_rec_.valid_from_date < valid_from_date_) THEN
            IF (line_rec_.valid_to_date IS NOT NULL) THEN
               -- timeframe record found. that has to be broken into two. with old prices and new prices with adjustments.
               -- update record with valid_to_date = valid_from_date_ - 1 
               new_valid_to_date_ := valid_from_date_ - 1;
               Sales_Price_List_Unit_API.Modify_Valid_To_Date(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.valid_from_date, new_valid_to_date_);
            END IF;
            -- create a new line with valid from date = valid_from_date_. If any line exists with same valid_from_date_ update that record
            OPEN get_exist_record(line_rec_.price_list_no, line_rec_.min_quantity, valid_from_date_);
            FETCH get_exist_record INTO exist_rec_;
            CLOSE get_exist_record;
            IF (exist_rec_.valid_from_date IS NOT NULL) THEN
               IF (line_rec_.valid_to_date IS NOT NULL) THEN
                  sales_price_ := ROUND((line_rec_.sales_price * (1 + percentage_offset_ / 100)) + amount_offset_, NVL(line_rec_.rounding,20));
                  IF (NOT same_date_record_updated_) THEN
                     -- update existing record with price information of line_rec_ and offset
                     Sales_Price_List_Unit_API.Modify_Sales_Price(line_rec_.price_list_no, line_rec_.min_quantity, valid_from_date_, sales_price_, line_rec_.valid_to_date);
                     counter_ := counter_ + 1;
                     same_date_record_updated_ := TRUE;
                  END IF;
                  next_valid_to_date_ := line_rec_.valid_to_date;
                  IF (exist_rec_.valid_to_date IS NULL AND same_date_record_updated_) THEN
                     Sales_Price_List_Unit_API.Modify_Sales_Price(line_rec_.price_list_no, line_rec_.min_quantity, exist_rec_.valid_from_date, sales_price_, next_valid_to_date_);
                  END IF;
               ELSE
                  IF (NOT same_date_record_updated_) THEN
                     -- if line_rec_ is not timeframed, existing record can be modified only with offset values
                     Duplicate_Price_List_Unit___(line_rec_.price_list_no, line_rec_.min_quantity, exist_rec_.valid_from_date,
                                                 valid_from_date_, percentage_offset_, amount_offset_, exist_rec_.valid_to_date);
                     counter_ := counter_ + 1;
                     same_date_record_updated_ := TRUE;
                  END IF;   
                  next_valid_to_date_ := exist_rec_.valid_to_date;
               END IF;
               next_valid_from_found_ := FALSE;
               create_new_line_ := FALSE;
               LOOP
                  EXIT WHEN next_valid_from_found_;
                  new_line_from_date_ := next_valid_to_date_ + 1;
                  OPEN get_adjacent_valid_rec(line_rec_.price_list_no, line_rec_.min_quantity, new_line_from_date_);
                  FETCH get_adjacent_valid_rec INTO next_valid_to_date_;
                  IF (get_adjacent_valid_rec%FOUND) THEN
                     CLOSE get_adjacent_valid_rec;
                     IF (next_valid_to_date_ IS NULL) THEN
                        next_valid_from_found_ := TRUE;
                        create_new_line_ := FALSE;
                     END IF;
                  ELSE      
                     CLOSE get_adjacent_valid_rec;
                     create_new_line_ := TRUE;
                     next_valid_from_found_ := TRUE;
                  END IF;
               END LOOP;
               IF (create_new_line_) THEN
                  -- need to create a new line with valid_from_date = next_valid_to_date_ + 1;.
                  OPEN check_overlap_rec_found(line_rec_.price_list_no, line_rec_.min_quantity, valid_from_date_, new_line_from_date_);
                  FETCH check_overlap_rec_found INTO dummy_;
                  IF (check_overlap_rec_found%NOTFOUND) THEN
                     CLOSE check_overlap_rec_found;
                     IF (line_rec_.valid_to_date IS NOT NULL) THEN
                        -- create new line on new_line_from_date_
                        sales_price_ := ROUND((exist_rec_.sales_price * (1 + percentage_offset_ / 100)) + amount_offset_, NVL(exist_rec_.rounding,20));
                        IF new_rec_created_on_from_date_ THEN
                           -- offset has already adjusted.. so need to re-calculate it.
                           sales_price_ := exist_rec_.sales_price;
                        END IF;
                        -- create new timeframed record with valid from date = valid_from_date_ and adjust offset
                        Sales_Price_List_Unit_API.New(line_rec_.price_list_no, line_rec_.min_quantity, new_line_from_date_, exist_rec_.discount_type,
                                                      exist_rec_.discount, sales_price_, exist_rec_.rounding, NULL);
                        counter_ := counter_ + 1;
                     ELSE
                        Duplicate_Price_List_Unit___(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                                     new_line_from_date_, percentage_offset_, amount_offset_, NULL);
                        counter_ := counter_ + 1;
                     END IF;
                    
                  ELSE
                     CLOSE check_overlap_rec_found;
                     -- no need to create the line
                  END IF;
               END IF;
            ELSE
               IF (NOT same_date_record_updated_) THEN
                  -- No record exists on user defined from_date_. Hence Create a new line on that date with offset adjustment     
                  Duplicate_Price_List_Unit___(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                               valid_from_date_, percentage_offset_, amount_offset_, line_rec_.valid_to_date);
                  counter_ := counter_ + 1;
                  same_date_record_updated_ := TRUE;
                  new_rec_created_on_from_date_ := TRUE;
               END IF;
            END IF;
         ELSIF ( (line_rec_.valid_from_date > valid_from_date_) OR (line_rec_.valid_from_date = valid_from_date_ AND NOT same_date_record_updated_)) THEN
            -- update the line with offset values
            Duplicate_Price_List_Unit___(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                         line_rec_.valid_from_date, percentage_offset_, amount_offset_, line_rec_.valid_to_date);
            counter_ := counter_ + 1;
         END IF;
         prev_price_list_no_ := line_rec_.price_list_no;
         prev_min_quantity_ := line_rec_.min_quantity;
      END LOOP;
   END IF;
   number_of_updates_ := counter_;
END Update_Unit_Prices___;

-- Calculate_Sales_Prices___
--   Calculate sales_price/sales_price_incl_tax according to use_price_incl_tax.
PROCEDURE Calculate_Sales_Prices___ (
   sales_price_           OUT    NUMBER,
   sales_price_incl_tax_  OUT    NUMBER,
   base_price_            IN OUT NUMBER,
   base_price_incl_tax_   IN OUT NUMBER,
   percentage_offset_     IN     NUMBER,
   amount_offset_         IN     NUMBER,
   rounding_              IN     NUMBER,
   tax_percentage_        IN     NUMBER,
   use_price_incl_tax_db_ IN     VARCHAR2 )
IS
BEGIN
   IF (use_price_incl_tax_db_ = 'TRUE') THEN
      -- base_price_ should not be rounded based on the data setup.
      base_price_           := ROUND(base_price_incl_tax_ / ((tax_percentage_ / 100) + 1), 20);
      sales_price_incl_tax_ := ROUND((base_price_incl_tax_ * (1 + percentage_offset_ / 100)) + amount_offset_, NVL(rounding_,20));
      sales_price_          := ROUND(sales_price_incl_tax_ / ((tax_percentage_ / 100) + 1),NVL(rounding_,20));
   ELSE
      -- base_price_ should not be rounded based on the data setup.
      base_price_incl_tax_  := ROUND(base_price_ * ((tax_percentage_ / 100) + 1), 20);
      sales_price_          := ROUND((base_price_ * (1 + percentage_offset_ / 100)) + amount_offset_, NVL(rounding_,20));   
      sales_price_incl_tax_ := ROUND(sales_price_ * ((tax_percentage_ / 100) + 1),NVL(rounding_,20));
   END IF;
END Calculate_Sales_Prices___;

-- Added two additional parameters to pass the discount source of the primary discount line. 
-- Get_Multiple_Discount___
--   Prepares parameters to call Get_Additional_Discount___.
--   Returns discount, discount type and discount source of additional discount.
PROCEDURE Get_Multiple_Discount___ (
   discount_                   OUT NUMBER,
   discount_type_              OUT VARCHAR2,
   discount_source_            OUT VARCHAR2,
   discount_source_id_         OUT VARCHAR2,
   min_quantity_               OUT NUMBER,
   valid_from_date_            OUT DATE,
   assortment_id_              OUT VARCHAR2,
   assortment_node_id_         OUT VARCHAR2,
   discount_sub_source_        OUT VARCHAR2,
   discount_price_uom_         OUT VARCHAR2,
   part_level_db_              OUT VARCHAR2,
   part_level_id_              OUT VARCHAR2,
   customer_level_db_          OUT VARCHAR2,
   customer_level_id_          OUT VARCHAR2,
   contract_                   IN  VARCHAR2,
   catalog_no_                 IN  VARCHAR2,
   customer_no_                IN  VARCHAR2,
   currency_code_              IN  VARCHAR2,
   agreement_id_               IN  VARCHAR2,
   buy_qty_due_                IN  NUMBER,
   effectivity_date_           IN  DATE,
   rental_chargable_days_      IN  NUMBER,
   prev_discount_source_       IN VARCHAR2,
   prev_discount_sub_source_   IN VARCHAR2)
IS
   hierarchy_id_        VARCHAR2(10);
   customer_arr_        tab_customer_no;
   n_                   BINARY_INTEGER := 0;
   total_               BINARY_INTEGER := 0;
   date_                DATE;
   prnt_cust_           CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE;
   campaign_id_         NUMBER;
   sales_price_type_db_ VARCHAR2(20);
BEGIN
   hierarchy_id_ := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);

   IF (effectivity_date_ IS NULL) THEN
      date_ := TRUNC(Site_API.Get_Site_Date(contract_));
   ELSE
      date_ := effectivity_date_;
   END IF;

   IF (hierarchy_id_ IS NOT NULL) THEN
      -- Create an array with the customer_no:s from the hierarchy in chronological order
      -- upwards to the hierarchy root customer.
      prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
      WHILE (prnt_cust_ IS NOT NULL) LOOP
         n_ := n_ + 1;
         customer_arr_(n_) := prnt_cust_;

         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
      END LOOP;

      total_ := n_;
   END IF;
   -- When rental_chargable_days_ is specified, it is considered rental prices.
   -- The discounts are fetched from the customer and customer hierarchy for rental prices.
   IF (rental_chargable_days_ IS NULL) THEN
      sales_price_type_db_ := Sales_Price_Type_API.DB_SALES_PRICES;
   ELSE
      sales_price_type_db_ := Sales_Price_Type_API.DB_RENTAL_PRICES;
   END IF;

   -- Passed last 2 parameters to prevent discount being fetched from the same source as the previously fetched discount source
   Get_Additional_Discount___(discount_, discount_type_, discount_source_, discount_source_id_, min_quantity_, valid_from_date_,
                              assortment_id_, assortment_node_id_, discount_sub_source_, discount_price_uom_,
                              part_level_db_, part_level_id_, customer_level_db_, customer_level_id_,
                              contract_,catalog_no_, customer_no_, currency_code_, agreement_id_, campaign_id_, 
                              hierarchy_id_, date_,customer_arr_, buy_qty_due_, total_, sales_price_type_db_, prev_discount_source_, prev_discount_sub_source_);
END Get_Multiple_Discount___;


-- Calculate_Total_Discount___
--   Calculates the total discount for the order line using partial sums and multiple discount.
FUNCTION Calculate_Total_Discount___ (
   discount_             IN NUMBER,
   additional_discount_  IN NUMBER,
   sales_price_          IN NUMBER,
   sales_price_incl_tax_ IN NUMBER,
   use_price_incl_tax_   IN VARCHAR2 ) RETURN NUMBER
IS
   total_discount_ NUMBER;
   new_price_      NUMBER;
BEGIN
   IF (use_price_incl_tax_ = 'TRUE') THEN
      IF (sales_price_incl_tax_ = 0 ) THEN
         total_discount_ := 0;
      ELSIF (discount_ IS NULL OR additional_discount_ IS NULL) THEN
         -- If there's only one discount applicable, no need to calculate that may lead to rounding difference
         total_discount_ := NVL(discount_, additional_discount_);  
      ELSE
         new_price_      := sales_price_incl_tax_ - (sales_price_incl_tax_ * (NVL(discount_, 0)/100));
         new_price_      := new_price_ - (new_price_ * (additional_discount_ / 100));
         total_discount_ := ((sales_price_incl_tax_ - new_price_) / sales_price_incl_tax_) * 100;
      END IF;
   ELSE
      IF (sales_price_ = 0 ) THEN
         total_discount_ := 0;
      ELSE
         new_price_      := sales_price_ - (sales_price_ * (NVL(discount_, 0)/100));
         new_price_      := new_price_ - (new_price_ * (additional_discount_ / 100));
         total_discount_ := ((sales_price_ - new_price_) / sales_price_) * 100;
      END IF;
   END IF;
   RETURN NVL(total_discount_, 0);
END Calculate_Total_Discount___;


-- Find_Price_On_Agr_Part_Deal___
--   Retrieve price,provisional price, discount_type and discount for specified
--   catalog no, agreement id, price qty due.
PROCEDURE Find_Price_On_Agr_Part_Deal___ (
   price_               OUT NUMBER,
   price_incl_tax_      OUT NUMBER,
   provisional_price_   OUT VARCHAR2,
   discount_type_       OUT VARCHAR2,
   discount_            OUT NUMBER,
   min_quantity_        OUT NUMBER,
   valid_from_date_     OUT DATE,
   net_price_           OUT VARCHAR2,
   catalog_no_          IN  VARCHAR2,
   agreement_id_        IN  VARCHAR2,
   price_qty_due_       IN  NUMBER,
   effectivity_date_    IN  DATE DEFAULT NULL )
IS
   price_found_           NUMBER;
   price_incl_tax_found_  NUMBER;
   discount_type_found_   VARCHAR2(25);
   discount_found_        NUMBER;
   date_                  DATE;
   last_calendar_date_    DATE := Database_Sys.Get_Last_Calendar_Date();
   
   CURSOR find_part_based_min_qty IS
      SELECT    MAX(min_quantity)
         FROM   agreement_sales_part_deal_tab
         WHERE  agreement_id = agreement_id_
         AND    catalog_no = catalog_no_
         AND    min_quantity <= price_qty_due_
         AND    TRUNC(valid_from_date) <= TRUNC(NVL(date_,SYSDATE))
         AND    TRUNC(NVL(valid_to_date, last_calendar_date_)) >= TRUNC(NVL(date_,SYSDATE))
         AND    deal_price IS NOT NULL;
      
   CURSOR get_from_date_from_period IS
      SELECT valid_from_date   
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    TRUNC(valid_from_date) <= TRUNC(NVL(date_,SYSDATE))
      AND    TRUNC(valid_to_date) >= TRUNC(NVL(date_,SYSDATE))
      AND    deal_price IS NOT NULL
      AND    valid_to_date IS NOT NULL; 
    
   CURSOR get_from_date_from_null_end IS
      SELECT MAX(valid_from_date)   
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    TRUNC(valid_from_date) <= TRUNC(NVL(date_,SYSDATE))
      AND    deal_price IS NOT NULL
      AND    valid_to_date IS NULL; 
      
   CURSOR get_part_based_attributes IS
      SELECT GREATEST(0, ROUND(deal_price, NVL(rounding,20))),
             GREATEST(0, ROUND(deal_price_incl_tax, NVL(rounding,20))),
             discount_type, discount, provisional_price, net_price
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    deal_price IS NOT NULL;
BEGIN
   IF (effectivity_date_ IS NULL)  THEN
       date_ := TRUNC(Site_API.Get_Site_Date(User_Default_API.Get_Contract));
   ELSE
       date_ := effectivity_date_;
   END IF;

   OPEN  find_part_based_min_qty;
   FETCH find_part_based_min_qty INTO min_quantity_;
   CLOSE find_part_based_min_qty;
   IF min_quantity_ IS NOT NULL THEN
      OPEN get_from_date_from_period;
      FETCH get_from_date_from_period INTO valid_from_date_;
      CLOSE get_from_date_from_period;
      IF (valid_from_date_ IS NULL) THEN
         OPEN get_from_date_from_null_end;
         FETCH get_from_date_from_null_end INTO valid_from_date_;
         CLOSE get_from_date_from_null_end;
      END IF;
      IF (valid_from_date_ IS NOT NULL) THEN
         OPEN  get_part_based_attributes;
         FETCH get_part_based_attributes INTO price_found_, price_incl_tax_found_, discount_type_found_, discount_found_, provisional_price_, net_price_;
         CLOSE get_part_based_attributes;
      END IF;   
   END IF;

   price_          := price_found_;
   price_incl_tax_ := price_incl_tax_found_;
   discount_type_  := discount_type_found_;
   discount_       := discount_found_;
END Find_Price_On_Agr_Part_Deal___;


PROCEDURE Create_New_Discount_Lines___ (
   order_no_             IN  VARCHAR2,
   line_no_              IN  VARCHAR2,
   rel_no_               IN  VARCHAR2,
   line_item_no_         IN  NUMBER,
   discount_source_id_   IN  VARCHAR2,
   discount_source_      IN  VARCHAR2,
   discount_type_        IN  VARCHAR2,
   discount_             IN  NUMBER,
   min_quantity_         IN  NUMBER,
   valid_from_date_      IN  DATE,
   catalog_no_           IN  VARCHAR2,
   discount_lines_exist_ IN  BOOLEAN,
   assortment_id_        IN  VARCHAR2,
   assortment_node_id_   IN  VARCHAR2,
   discount_sub_source_  IN  VARCHAR2,
   discount_price_uom_   IN  VARCHAR2,
   part_level_db_        IN  VARCHAR2,
   part_level_id_        IN  VARCHAR2,
   customer_level_db_    IN  VARCHAR2,
   customer_level_id_    IN  VARCHAR2 )
IS
   create_partial_sum_    VARCHAR2(20);
   discount_line_no_      NUMBER;
   catalog_group_         VARCHAR2(10);
   price_unit_meas_       AGREEMENT_ASSORT_DISCOUNT_TAB.price_unit_meas%TYPE;

   CURSOR agreement_part_discount_lines IS
      SELECT discount_type, discount, discount_amount
      FROM   agreement_part_discount_tab
      WHERE  agreement_id = discount_source_id_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    catalog_no = catalog_no_
      ORDER BY discount_line_no;

   CURSOR agr_assort_discount_lines IS
      SELECT discount_type, discount, discount_amount
      FROM   agreement_assort_discount_tab
      WHERE  agreement_id = discount_source_id_
      AND    min_quantity = min_quantity_
      AND    valid_from = valid_from_date_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas = price_unit_meas_
      ORDER BY discount_line_no;

   CURSOR agreement_GROUP_discount_lines IS
      SELECT discount_type, discount
      FROM   agreement_group_discount_tab
      WHERE  agreement_id = discount_source_id_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    catalog_group = catalog_group_
      ORDER BY discount_line_no;
BEGIN
   IF discount_lines_exist_ THEN
      discount_line_no_ := Cust_Order_Line_Discount_API.Get_Last_Discount_Line_No(order_no_, line_no_, rel_no_, line_item_no_) + 1;
   ELSE
      discount_line_no_ := 1;
   END IF;
   price_unit_meas_ := NVL(discount_price_uom_, Customer_Order_Line_API.Get_Price_Unit_Meas(order_no_, line_no_, rel_no_, line_item_no_));

   create_partial_sum_ := 'PARTIAL SUM';

   IF (discount_source_ = 'AGREEMENT') THEN
      IF discount_sub_source_= 'AgreementDealPerPart' THEN
         FOR discount_rec_ IN agreement_part_discount_lines LOOP
            Cust_Order_Line_Discount_API.New(order_no_,
                                             line_no_,
                                             rel_no_,
                                             line_item_no_,
                                             discount_rec_.discount_type,
                                             discount_rec_.discount,
                                             discount_source_,
                                             create_partial_sum_,
                                             discount_line_no_,
                                             discount_source_id_,
                                             discount_rec_.discount_amount,
                                             part_level_db_,
                                             part_level_id_,
                                             customer_level_db_,
                                             customer_level_id_);
            discount_line_no_ := discount_line_no_ + 1;
         END LOOP;
      ELSIF discount_sub_source_= 'AgreementDealPerAssortment' THEN
         FOR discount_rec_ IN agr_assort_discount_lines LOOP
            Cust_Order_Line_Discount_API.New(order_no_,
                                             line_no_,
                                             rel_no_,
                                             line_item_no_,
                                             discount_rec_.discount_type,
                                             discount_rec_.discount,
                                             discount_source_,
                                             create_partial_sum_,
                                             discount_line_no_,
                                             discount_source_id_,
                                             discount_rec_.discount_amount,
                                             part_level_db_,
                                             part_level_id_,
                                             customer_level_db_,
                                             customer_level_id_);
            discount_line_no_ := discount_line_no_ + 1;
         END LOOP;
      ELSIF discount_sub_source_= 'AgreementDealPerSalesGroup' THEN
         catalog_group_ := Sales_Part_API.Get_Catalog_Group(Customer_Order_API.Get_Contract(order_no_), catalog_no_);
         FOR discount_rec_ IN agreement_group_discount_lines LOOP
            Cust_Order_Line_Discount_API.New(order_no_,
                                             line_no_,
                                             rel_no_,
                                             line_item_no_,
                                             discount_rec_.discount_type,
                                             discount_rec_.discount,
                                             discount_source_,
                                             create_partial_sum_,
                                             discount_line_no_,
                                             discount_source_id_,
                                             NULL,
                                             part_level_db_,
                                             part_level_id_,
                                             customer_level_db_,
                                             customer_level_id_);
            discount_line_no_ := discount_line_no_ + 1;
         END LOOP;
      END IF;
   ELSE
      Cust_Order_Line_Discount_API.New(order_no_,
                                       line_no_,
                                       rel_no_,
                                       line_item_no_,
                                       discount_type_,
                                       discount_,
                                       discount_source_,
                                       create_partial_sum_,
                                       discount_line_no_,
                                       discount_source_id_,
                                       NULL,
                                       part_level_db_,
                                       part_level_id_,
                                       customer_level_db_,
                                       customer_level_id_);
   END IF;
END Create_New_Discount_Lines___;


PROCEDURE Create_New_Qdiscount_Lines___ (
   quotation_no_         IN  VARCHAR2,
   line_no_              IN  VARCHAR2,
   rel_no_               IN  VARCHAR2,
   line_item_no_         IN  NUMBER,
   discount_source_id_   IN  VARCHAR2,
   discount_source_      IN  VARCHAR2,
   discount_type_        IN  VARCHAR2,
   discount_             IN  NUMBER,
   min_quantity_         IN  NUMBER,
   valid_from_date_      IN  DATE,
   catalog_no_           IN  VARCHAR2,
   discount_lines_exist_ IN  BOOLEAN,
   assortment_id_        IN  VARCHAR2,
   assortment_node_id_   IN  VARCHAR2,
   discount_sub_source_  IN  VARCHAR2,
   discount_price_uom_   IN  VARCHAR2,
   part_level_db_        IN  VARCHAR2,
   part_level_id_        IN  VARCHAR2,
   customer_level_db_    IN  VARCHAR2,
   customer_level_id_    IN  VARCHAR2,
   update_tax_           IN  VARCHAR2 DEFAULT 'TRUE')
IS
   create_partial_sum_    VARCHAR2(20);
   discount_line_no_      NUMBER;
   catalog_group_         VARCHAR2(10);
   price_unit_meas_       AGREEMENT_ASSORT_DISCOUNT_TAB.price_unit_meas%TYPE;

   CURSOR agreement_part_discount_lines IS
      SELECT discount_type, discount, discount_amount
      FROM   agreement_part_discount_tab
      WHERE  agreement_id = discount_source_id_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    catalog_no = catalog_no_
      ORDER BY discount_line_no;

   CURSOR agr_assort_discount_lines IS
      SELECT discount_type, discount, discount_amount
      FROM   agreement_assort_discount_tab
      WHERE  agreement_id = discount_source_id_
      AND    min_quantity = min_quantity_
      AND    valid_from = valid_from_date_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas = price_unit_meas_
      ORDER BY discount_line_no;

   CURSOR agreement_GROUP_discount_lines IS
      SELECT discount_type, discount
      FROM   agreement_group_discount_tab
      WHERE  agreement_id = discount_source_id_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    catalog_group = catalog_group_
      ORDER BY discount_line_no;
BEGIN
   IF discount_lines_exist_ THEN
      discount_line_no_ := Order_Quote_Line_Discount_API.Get_Last_Discount_Line_No(quotation_no_, line_no_, rel_no_, line_item_no_) + 1;
   ELSE
      discount_line_no_ := 1;
   END IF;
   price_unit_meas_ := NVL(discount_price_uom_, Order_Quotation_Line_API.Get_Price_Unit_Meas(quotation_no_, line_no_, rel_no_, line_item_no_));

   create_partial_sum_ := 'PARTIAL SUM';

   IF (discount_source_ = 'AGREEMENT') THEN
      IF discount_sub_source_= 'AgreementDealPerPart' THEN
         FOR discount_rec_ IN agreement_part_discount_lines LOOP
            Order_Quote_Line_Discount_API.New(quotation_no_,
                                              line_no_,
                                              rel_no_,
                                              line_item_no_,
                                              discount_rec_.discount_type,
                                              discount_rec_.discount,
                                              discount_source_,
                                              create_partial_sum_,
                                              discount_line_no_,
                                              discount_source_id_,
                                              discount_rec_.discount_amount,
                                              part_level_db_,
                                              part_level_id_,
                                              customer_level_db_,
                                              customer_level_id_,
                                              update_tax_ => update_tax_);
            discount_line_no_ := discount_line_no_ + 1;
         END LOOP;
      ELSIF discount_sub_source_= 'AgreementDealPerAssortment' THEN
         FOR discount_rec_ IN agr_assort_discount_lines LOOP
            Order_Quote_Line_Discount_API.New(quotation_no_,
                                              line_no_,
                                              rel_no_,
                                              line_item_no_,
                                              discount_rec_.discount_type,
                                              discount_rec_.discount,
                                              discount_source_,
                                              create_partial_sum_,
                                              discount_line_no_,
                                              discount_source_id_,
                                              discount_rec_.discount_amount,
                                              part_level_db_,
                                              part_level_id_,
                                              customer_level_db_,
                                              customer_level_id_,
                                              update_tax_ => update_tax_);
            discount_line_no_ := discount_line_no_ + 1;
         END LOOP;
      ELSIF discount_sub_source_= 'AgreementDealPerSalesGroup' THEN
         catalog_group_ := Sales_Part_API.Get_Catalog_Group(Order_Quotation_API.Get_Contract(quotation_no_), catalog_no_);
         FOR discount_rec_ IN agreement_group_discount_lines LOOP
            Order_Quote_Line_Discount_API.New(quotation_no_,
                                             line_no_,
                                             rel_no_,
                                             line_item_no_,
                                             discount_rec_.discount_type,
                                             discount_rec_.discount,
                                             discount_source_,
                                             create_partial_sum_,
                                             discount_line_no_,
                                             discount_source_id_,
                                             NULL,
                                             part_level_db_,
                                             part_level_id_,
                                             customer_level_db_,
                                             customer_level_id_,
                                             update_tax_ => update_tax_);
            discount_line_no_ := discount_line_no_ + 1;
         END LOOP;
      END IF;
   ELSE
      Order_Quote_Line_Discount_API.New(quotation_no_,
                                        line_no_,
                                        rel_no_,
                                        line_item_no_,
                                        discount_type_,
                                        discount_,
                                        discount_source_,
                                        create_partial_sum_,
                                        discount_line_no_,
                                        discount_source_id_,
                                        NULL,
                                        part_level_db_,
                                        part_level_id_,
                                        customer_level_db_,
                                        customer_level_id_,
                                        update_tax_ => update_tax_);
   END IF;
END Create_New_Qdiscount_Lines___;


-- Find_Disc_On_Agr_Part_Deal___
--   Find discounts on deal per part agreement lines where deal price is null.
PROCEDURE Find_Disc_On_Agr_Part_Deal___ (
   provisional_price_   OUT VARCHAR2,
   discount_type_       OUT VARCHAR2,
   discount_            OUT NUMBER,
   min_quantity_        OUT NUMBER,
   valid_from_date_     OUT DATE,
   net_price_           OUT VARCHAR2,
   catalog_no_          IN  VARCHAR2,
   agreement_id_        IN  VARCHAR2,
   price_qty_due_       IN  NUMBER,
   effectivity_date_    IN  DATE DEFAULT NULL )
IS
   discount_type_found_ VARCHAR2(25);
   discount_found_      NUMBER;
   date_                DATE;
   temp_                NUMBER;
   last_calendar_date_  DATE := Database_Sys.Get_Last_Calendar_Date();
   CURSOR find_part_based_min_qty IS
      SELECT    MAX(min_quantity)
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity <= price_qty_due_
      AND    TRUNC(valid_from_date) <= TRUNC(NVL(date_,SYSDATE))
      AND    TRUNC(NVL(valid_to_date, last_calendar_date_)) >= TRUNC(NVL(date_,SYSDATE))
      AND    deal_price IS NULL;

   CURSOR get_from_date_from_period IS
      SELECT valid_from_date   
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    TRUNC(valid_from_date) <= TRUNC(NVL(date_,SYSDATE))
      AND    TRUNC(valid_to_date) >= TRUNC(NVL(date_,SYSDATE))
      AND    deal_price IS NULL
      AND    valid_to_date IS NOT NULL; 

   CURSOR get_from_date_from_null_end IS
      SELECT MAX(valid_from_date)   
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    TRUNC(valid_from_date) <= TRUNC(NVL(date_,SYSDATE))
      AND    deal_price IS NULL
      AND    valid_to_date IS NULL;
         
   CURSOR get_part_based_attributes IS
      SELECT discount_type, discount, provisional_price, net_price
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    deal_price IS NULL;

   CURSOR get_disc_amount IS
      SELECT count(agreement_id)
      FROM   agreement_part_discount_tab
      WHERE  agreement_id    = agreement_id_
      AND    min_quantity    = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    catalog_no      = catalog_no_
      AND    discount_amount IS NOT NULL;
BEGIN
   IF (effectivity_date_ IS NULL)  THEN
      date_ := TRUNC(Site_API.Get_Site_Date(User_Default_API.Get_Contract));
   ELSE
      date_ := effectivity_date_;
   END IF;

   OPEN find_part_based_min_qty;
   FETCH find_part_based_min_qty INTO min_quantity_;
   CLOSE find_part_based_min_qty;
   IF min_quantity_ IS NOT NULL THEN
      OPEN get_from_date_from_period;
      FETCH get_from_date_from_period INTO valid_from_date_;
      CLOSE get_from_date_from_period;
      IF (valid_from_date_ IS NULL) THEN
         OPEN get_from_date_from_null_end;
         FETCH get_from_date_from_null_end INTO valid_from_date_;
         CLOSE get_from_date_from_null_end;
      END IF;
      IF (valid_from_date_ IS NOT NULL) THEN
         OPEN get_part_based_attributes;
         FETCH get_part_based_attributes INTO discount_type_found_, discount_found_, provisional_price_, net_price_;
         CLOSE get_part_based_attributes;
      END IF;
   END IF;

   discount_type_ := discount_type_found_;
   discount_      := discount_found_;
   IF (discount_ IS NULL) THEN
      OPEN get_disc_amount;
      FETCH get_disc_amount INTO temp_;
      CLOSE get_disc_amount;
      
      IF (temp_ >= 1) THEN 
         discount_ := 1;
      END IF;
   END IF;
END Find_Disc_On_Agr_Part_Deal___;


PROCEDURE Create_New_Pq_Disc_Lines___ (
   acc_discount_               OUT NUMBER,
   price_query_id_             IN  NUMBER,
   discount_source_id_         IN  VARCHAR2,
   discount_source_            IN  VARCHAR2,
   discount_type_              IN  VARCHAR2,
   discount_                   IN  NUMBER,
   min_quantity_               IN  NUMBER,
   valid_from_date_            IN  DATE,
   contract_                   IN  VARCHAR2,
   catalog_no_                 IN  VARCHAR2,
   discount_lines_exist_       IN  BOOLEAN,
   assortment_id_              IN  VARCHAR2,
   assortment_node_id_         IN  VARCHAR2,
   discount_sub_source_        IN  VARCHAR2,
   discount_price_uom_         IN  VARCHAR2,
   part_level_db_              IN  VARCHAR2,
   part_level_id_              IN  VARCHAR2,
   customer_level_db_          IN  VARCHAR2,
   customer_level_id_          IN  VARCHAR2 )
IS
   create_partial_sum_    VARCHAR2(20);
   discount_line_no_      NUMBER;
   catalog_group_         VARCHAR2(10);
   price_unit_meas_       AGREEMENT_ASSORT_DISCOUNT_TAB.price_unit_meas%TYPE;

   CURSOR agreement_part_discount_lines IS
      SELECT discount_type, discount, discount_amount
      FROM   agreement_part_discount_tab
      WHERE  agreement_id = discount_source_id_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    catalog_no = catalog_no_
      ORDER BY discount_line_no;

   CURSOR agr_assort_discount_lines IS
      SELECT discount_type, discount, discount_amount
      FROM   agreement_assort_discount_tab
      WHERE  agreement_id = discount_source_id_
      AND    min_quantity = min_quantity_
      AND    valid_from = valid_from_date_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas = price_unit_meas_
      ORDER BY discount_line_no;

   CURSOR agreement_GROUP_discount_lines IS
      SELECT discount_type, discount
      FROM   agreement_group_discount_tab
      WHERE  agreement_id = discount_source_id_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    catalog_group = catalog_group_
      ORDER BY discount_line_no;
BEGIN
   IF discount_lines_exist_ THEN
      discount_line_no_ := Price_Query_Discount_Line_API.Get_Last_Discount_Line_No(price_query_id_) + 1;
   ELSE
      discount_line_no_ := 1;
   END IF;
   price_unit_meas_ := NVL(discount_price_uom_, Sales_Part_API.Get_Price_Unit_Meas(contract_, catalog_no_));

   create_partial_sum_ := 'PARTIAL SUM';

   IF (discount_source_ = 'AGREEMENT') THEN
      IF discount_sub_source_= 'AgreementDealPerPart' THEN
         FOR discount_rec_ IN agreement_part_discount_lines LOOP
            Price_Query_Discount_Line_API.New(acc_discount_,
                                              price_query_id_,
                                              discount_rec_.discount_type,
                                              discount_rec_.discount,
                                              discount_source_,
                                              create_partial_sum_,
                                              discount_line_no_,
                                              discount_source_id_,
                                              discount_rec_.discount_amount,
                                              part_level_db_,
                                              part_level_id_,
                                              customer_level_db_,
                                              customer_level_id_);
            discount_line_no_ := discount_line_no_ + 1;
         END LOOP;
      ELSIF discount_sub_source_= 'AgreementDealPerAssortment' THEN
         FOR discount_rec_ IN agr_assort_discount_lines LOOP
            Price_Query_Discount_Line_API.New(acc_discount_,
                                              price_query_id_,
                                              discount_rec_.discount_type,
                                              discount_rec_.discount,
                                              discount_source_,
                                              create_partial_sum_,
                                              discount_line_no_,
                                              discount_source_id_,
                                              discount_rec_.discount_amount,
                                              part_level_db_,
                                              part_level_id_,
                                              customer_level_db_,
                                              customer_level_id_);
            discount_line_no_ := discount_line_no_ + 1;
         END LOOP;
      ELSIF discount_sub_source_= 'AgreementDealPerSalesGroup' THEN
         catalog_group_ := Sales_Part_API.Get_Catalog_Group(contract_, catalog_no_);
         FOR discount_rec_ IN agreement_group_discount_lines LOOP
            Price_Query_Discount_Line_API.New(acc_discount_,
                                              price_query_id_,
                                              discount_rec_.discount_type,
                                              discount_rec_.discount,
                                              discount_source_,
                                              create_partial_sum_,
                                              discount_line_no_,
                                              discount_source_id_,
                                              NULL,
                                              part_level_db_,
                                              part_level_id_,
                                              customer_level_db_,
                                              customer_level_id_);
            discount_line_no_ := discount_line_no_ + 1;
         END LOOP;
      END IF;
   ELSE
      Price_Query_Discount_Line_API.New(acc_discount_,
                                        price_query_id_,
                                        discount_type_,
                                        discount_,
                                        discount_source_,
                                        create_partial_sum_,
                                        discount_line_no_,
                                        discount_source_id_,
                                        NULL,
                                        part_level_db_,
                                        part_level_id_,
                                        customer_level_db_,
                                        customer_level_id_);
   END IF;
END Create_New_Pq_Disc_Lines___;


-- Update_Assort_Prices___
--   Adds or modifies SalesPriceListAssort records with the given attributes with given offsets.
PROCEDURE Update_Assort_Prices___ (
   number_of_updates_       OUT NUMBER,
   valid_from_date_         IN  DATE,
   percentage_offset_       IN  NUMBER,
   amount_offset_           IN  NUMBER,
   price_list_attr_         IN  VARCHAR2,
   sales_price_group_attr_  IN  VARCHAR2,
   assortment_id_attr_      IN  VARCHAR2,
   assortment_node_id_attr_ IN  VARCHAR2,
   company_attr_            IN  VARCHAR2,
   include_period_          IN  VARCHAR2 )
IS
   counter_                    NUMBER := 0;
   next_valid_from_date_       DATE;
   next_valid_to_date_         DATE;
   new_valid_to_date_          DATE;
   new_valid_from_date_        DATE;
   new_line_from_date_         DATE;
   next_valid_from_found_      BOOLEAN := FALSE;
   dummy_                      NUMBER;
   create_new_line_            BOOLEAN;
   exist_rec_                  sales_price_list_assort_tab%ROWTYPE;
   sales_price_                NUMBER;
   same_date_record_updated_   BOOLEAN := FALSE;
   prev_price_list_no_         VARCHAR2(10);
   prev_assortment_id_         VARCHAR2(50);
   prev_assortment_node_id_    VARCHAR2(50);
   prev_price_unit_meas_       VARCHAR2(30);
   prev_min_quantity_          NUMBER;  
   new_rec_created_on_from_date_  BOOLEAN;
   
   CURSOR find_null_valid_to_date_recs IS
      SELECT pl.price_list_no, pla.min_quantity, pl.assortment_id, pla.assortment_node_id, pla.price_unit_meas, pla.valid_from_date, pla.sales_price, pla.rounding
      FROM sales_price_list_tab pl, sales_price_list_assort_tab pla
      WHERE pl.price_list_no = pla.price_list_no
      AND    pl.owning_company IN (SELECT company 
                                   FROM   company_finance_auth_pub)
      AND    Report_SYS.Parse_Parameter(pl.owning_company, company_attr_) = db_true_
      AND    Report_SYS.Parse_Parameter(pl.price_list_no, price_list_attr_) = db_true_
      AND    Report_SYS.Parse_Parameter(sales_price_group_id, sales_price_group_attr_) = db_true_
      AND    Report_SYS.Parse_Parameter(pl.assortment_id, assortment_id_attr_) = db_true_
      AND    Report_SYS.Parse_Parameter(assortment_node_id, assortment_node_id_attr_) = db_true_
      AND    NVL(pl.valid_to_date, valid_from_date_) >= valid_from_date_
      AND   (pl.price_list_no, pla.min_quantity, pl.assortment_id, pla.assortment_node_id, pla.price_unit_meas, pla.valid_from_date ) IN
          (SELECT price_list_no, min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date
           FROM  sales_price_list_assort_tab
           WHERE (price_list_no, min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date) IN
                 (SELECT price_list_no, min_quantity, assortment_id, assortment_node_id, price_unit_meas, MAX(valid_from_date) valid_from_date
                  FROM   sales_price_list_assort_tab
                  WHERE  valid_from_date <= valid_from_date_
                  AND    valid_to_date IS NULL
                  GROUP BY price_list_no, min_quantity, assortment_id, assortment_node_id, price_unit_meas)
                  UNION ALL
                  (SELECT price_list_no, min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date
                   FROM   sales_price_list_assort_tab
                   WHERE  valid_from_date > valid_from_date_
                   AND    valid_to_date IS NULL))
      ORDER BY pl.price_list_no, pl.assortment_id, pla.assortment_node_id, pla.min_quantity, pla.price_unit_meas, pla.valid_from_date;
                   
                   
   CURSOR find_valid_record IS
      SELECT pl.price_list_no, pla.min_quantity, pl.assortment_id, pla.assortment_node_id, pla.price_unit_meas, pla.valid_from_date, pla.valid_to_date, pla.sales_price, pla.rounding
      FROM sales_price_list_tab pl, sales_price_list_assort_tab pla
      WHERE pl.price_list_no = pla.price_list_no
      AND    pl.owning_company IN (SELECT company 
                                   FROM   company_finance_auth_pub)
      AND    Report_SYS.Parse_Parameter(pl.owning_company, company_attr_) = db_true_
      AND    Report_SYS.Parse_Parameter(pl.price_list_no, price_list_attr_) = db_true_
      AND    Report_SYS.Parse_Parameter(sales_price_group_id, sales_price_group_attr_) = db_true_
      AND    Report_SYS.Parse_Parameter(pl.assortment_id, assortment_id_attr_) = db_true_
      AND    Report_SYS.Parse_Parameter(assortment_node_id, assortment_node_id_attr_) = db_true_
      AND    NVL(pl.valid_to_date, valid_from_date_) >= valid_from_date_
      AND   (pl.price_list_no, pla.min_quantity, pl.assortment_id, pla.assortment_node_id, pla.price_unit_meas, pla.valid_from_date ) IN
          (SELECT price_list_no, min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date
           FROM  sales_price_list_assort_tab
           WHERE (price_list_no, min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date) IN
                 (SELECT price_list_no, min_quantity, assortment_id, assortment_node_id, price_unit_meas, MAX(valid_from_date) valid_from_date
                  FROM   sales_price_list_assort_tab
                  WHERE  valid_from_date <= valid_from_date_
                  AND    valid_to_date IS NULL
                  GROUP BY price_list_no, min_quantity, assortment_id, assortment_node_id, price_unit_meas)
                  UNION ALL
                  (SELECT price_list_no, min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date
                   FROM   sales_price_list_assort_tab
                   WHERE  valid_from_date >= valid_from_date_)
                  UNION ALL
                  (SELECT price_list_no, min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date
                   FROM   sales_price_list_assort_tab
                   WHERE  valid_to_date IS NOT NULL
                   AND    valid_from_date < valid_from_date_
                   AND    valid_to_date >= valid_from_date_ ))
      ORDER BY pl.price_list_no, pl.assortment_id, pla.assortment_node_id, pla.min_quantity, pla.price_unit_meas, pla.valid_from_date;
       
   CURSOR get_next_adjacent_rec(price_list_no_ IN VARCHAR2, min_quantity_ IN NUMBER, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, price_unit_meas_ IN VARCHAR2, new_valid_from_date_ IN DATE) IS
      SELECT valid_to_date
      FROM   sales_price_list_assort_tab
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas = price_unit_meas_
      AND    valid_from_date = new_valid_from_date_;
   
   CURSOR check_overlap_rec_found(price_list_no_ IN VARCHAR2, min_quantity_ IN NUMBER, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, price_unit_meas_ IN VARCHAR2, from_date_ IN DATE, to_date_ IN DATE) IS
      SELECT 1
      FROM sales_price_list_assort_tab
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas = price_unit_meas_
      AND    valid_to_date IS NULL
      AND    valid_from_date > from_date_
      AND    valid_from_date <= to_date_;
   
   CURSOR get_exist_record(price_list_no_ IN VARCHAR2, min_quantity_ IN NUMBER, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, price_unit_meas_ IN VARCHAR2, from_date_ IN DATE) IS
      SELECT *
      FROM sales_price_list_assort_tab
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas = price_unit_meas_
      AND    valid_from_date = from_date_;

BEGIN
   IF (include_period_ = 'FALSE') THEN
      FOR line_rec_ IN find_null_valid_to_date_recs LOOP
         new_valid_from_date_ := NULL;
         create_new_line_ := FALSE;
         exist_rec_ := NULL;
         next_valid_from_date_ := NULL;
         next_valid_to_date_ := NULL;
         IF (line_rec_.valid_from_date < valid_from_date_) THEN
            -- Need to create a new line with valid from_date = valid_from_date_.
            -- FOr that we need to check whether any record exists with that valid_from_date.
            next_valid_from_found_ := FALSE;
            new_valid_from_date_ := valid_from_date_;
            LOOP
               EXIT WHEN (next_valid_from_found_);
              -- new_valid_from_date_ := timeframe_valid_to_date_ + 1;
               OPEN get_exist_record(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.price_unit_meas, new_valid_from_date_);
               FETCH get_exist_record INTO exist_rec_;
               IF (get_exist_record%FOUND) THEN
                  CLOSE get_exist_record;
                  IF (exist_rec_.valid_to_date IS NULL) THEN
                     -- record exist with valid_from_date = new_valid_from_date_ and valid_to_date null. Hence no need to create a new record
                     next_valid_from_found_ := TRUE;
                     create_new_line_ := FALSE;
                  ELSE
                     new_valid_from_date_ := exist_rec_.valid_to_date + 1; 
                  END IF;   
               ELSE
                  CLOSE get_exist_record;
                  create_new_line_ := TRUE;
                  next_valid_from_found_ := TRUE;
               END IF;   
            END LOOP;
            IF (create_new_line_) THEN
               -- find the next record with valid_to_date null. If that record valid_from_date is earlier than our new valid_from_date then no need to create the record
               OPEN check_overlap_rec_found(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.price_unit_meas, valid_from_date_, new_valid_from_date_);
               FETCH check_overlap_rec_found INTO dummy_;
               IF (check_overlap_rec_found%NOTFOUND) THEN
                  CLOSE check_overlap_rec_found;
                  -- create new record with valid_from_date = new_valid_from_date_
                  Duplicate_Price_List_Assort___(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.valid_from_date, line_rec_.assortment_id, 
                                                 line_rec_.assortment_node_id, line_rec_.price_unit_meas, new_valid_from_date_, percentage_offset_,
                                                 amount_offset_, NULL);                             
                  counter_ := counter_ + 1;
               ELSE
                  CLOSE check_overlap_rec_found;
               END IF;
            END IF;   
         ELSE
            -- valid_from_date >= user defined from_date. Hence update those records with the given offset.
            Duplicate_Price_List_Assort___(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.valid_from_date, line_rec_.assortment_id, 
                                           line_rec_.assortment_node_id, line_rec_.price_unit_meas, line_rec_.valid_from_date, percentage_offset_,
                                           amount_offset_, NULL);                             
            counter_ := counter_ + 1;
         END IF;   
      END LOOP; 
   ELSE
      -- include_period = TRUE
      FOR line_rec_ IN find_valid_record LOOP
         next_valid_to_date_ := NULL;
         create_new_line_ := FALSE;
         exist_rec_ := NULL; 
         new_line_from_date_ := NULL;
         IF ((NVL(prev_price_list_no_, line_rec_.price_list_no) != line_rec_.price_list_no) OR 
             (NVL(prev_assortment_id_, line_rec_.assortment_id) != line_rec_.assortment_id) OR
             (NVL(prev_assortment_node_id_, line_rec_.assortment_node_id) != line_rec_.assortment_node_id) OR
             (NVL(prev_price_unit_meas_, line_rec_.price_unit_meas) != line_rec_.price_unit_meas) OR
             (NVL(prev_min_quantity_, line_rec_.min_quantity) != line_rec_.min_quantity)) THEN
            same_date_record_updated_ := FALSE;
            new_rec_created_on_from_date_ := FALSE;
         END IF;
         IF (line_rec_.valid_from_date < valid_from_date_) THEN
            IF (line_rec_.valid_to_date IS NOT NULL) THEN
               -- timeframe record found. that has to be broken into two. with old prices and new prices with adjustments.
               -- update record with valid_to_date = valid_from_date_ - 1 
               new_valid_to_date_ := valid_from_date_ - 1;
               Sales_Price_List_Assort_API.Modify_Valid_To_Date(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.valid_from_date, line_rec_.assortment_id, 
                                                                line_rec_.assortment_node_id, line_rec_.price_unit_meas, new_valid_to_date_);
            END IF;
            -- create a new line with valid from date = valid_from_date_. If any line exists with same valid_from_date_ update that record
            OPEN get_exist_record(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.price_unit_meas, valid_from_date_);
            FETCH get_exist_record INTO exist_rec_;
            CLOSE get_exist_record;
            IF (exist_rec_.valid_from_date IS NOT NULL) THEN
               IF (line_rec_.valid_to_date IS NOT NULL) THEN
                  sales_price_ := ROUND((line_rec_.sales_price * (1 + percentage_offset_ / 100)) + amount_offset_, NVL(line_rec_.rounding,20));
                  IF (NOT same_date_record_updated_) THEN
                     -- update existing record with price information of line_rec_ and offset
                     Sales_Price_List_Assort_API.Modify_Sales_Price(line_rec_.price_list_no, line_rec_.min_quantity, valid_from_date_, line_rec_.assortment_id,
                                                                    line_rec_.assortment_node_id, line_rec_.price_unit_meas, sales_price_, line_rec_.valid_to_date);
                     counter_ := counter_ + 1;
                     same_date_record_updated_ := TRUE;
                  END IF;
                  next_valid_to_date_ := line_rec_.valid_to_date;
                  IF (exist_rec_.valid_to_date IS NULL AND same_date_record_updated_) THEN
                     Sales_Price_List_Assort_API.Modify_Sales_Price(line_rec_.price_list_no, line_rec_.min_quantity, exist_rec_.valid_from_date, line_rec_.assortment_id,
                                                                     line_rec_.assortment_node_id, line_rec_.price_unit_meas, sales_price_, next_valid_to_date_);
                  END IF;
               ELSE
                  IF (NOT same_date_record_updated_) THEN
                     -- if line_rec_ is not timeframed, existing record can be modified only with offset values
                     Duplicate_Price_List_Assort___(line_rec_.price_list_no, line_rec_.min_quantity, exist_rec_.valid_from_date, line_rec_.assortment_id, 
                                                    line_rec_.assortment_node_id, line_rec_.price_unit_meas, valid_from_date_, percentage_offset_,
                                                    amount_offset_, exist_rec_.valid_to_date);
                     counter_ := counter_ + 1;
                     same_date_record_updated_ := TRUE;
                  END IF;   
                  next_valid_to_date_ := exist_rec_.valid_to_date;
               END IF;
               next_valid_from_found_ := FALSE;
               create_new_line_ := FALSE;
               LOOP
                  EXIT WHEN next_valid_from_found_;
                  new_line_from_date_ := next_valid_to_date_ + 1;
                  OPEN get_next_adjacent_rec(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.price_unit_meas, new_line_from_date_);
                  FETCH get_next_adjacent_rec INTO next_valid_to_date_;
                  IF (get_next_adjacent_rec%FOUND) THEN
                     CLOSE get_next_adjacent_rec;
                     IF (next_valid_to_date_ IS NULL) THEN
                        next_valid_from_found_ := TRUE;
                        create_new_line_ := FALSE;
                     END IF;
                  ELSE
                     CLOSE get_next_adjacent_rec;
                     create_new_line_ := TRUE;
                     next_valid_from_found_ := TRUE;
                  END IF;
               END LOOP;
               IF (create_new_line_) THEN
                  -- need to create a new line with valid_from_date = next_valid_to_date_ + 1;.
                  --OPEN check_overlap_rec_found(line_rec_.price_list_no, line_rec_.min_quantity, valid_from_date_, new_line_from_date_);
                  OPEN check_overlap_rec_found(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.price_unit_meas, valid_from_date_, new_line_from_date_);
                  FETCH check_overlap_rec_found INTO dummy_;
                  IF (check_overlap_rec_found%NOTFOUND) THEN
                     CLOSE check_overlap_rec_found;
                     IF (line_rec_.valid_to_date IS NOT NULL) THEN
                        -- create new line on new_line_from_date_
                        sales_price_ := ROUND((exist_rec_.sales_price * (1 + percentage_offset_ / 100)) + amount_offset_, NVL(exist_rec_.rounding,20));
                        IF (new_rec_created_on_from_date_) THEN
                           --  offset has already adjusted.. so need to re-calculate it.
                           sales_price_ := exist_rec_.sales_price;
                        END IF;
                        -- create new timeframed record with valid from date = valid_from_date_ and adjust offset
                        Sales_Price_List_Assort_API.New_Line(line_rec_.price_list_no, line_rec_.min_quantity, new_line_from_date_, line_rec_.assortment_id,
                                                             line_rec_.assortment_node_id, line_rec_.price_unit_meas, exist_rec_.rounding, sales_price_,
                                                             exist_rec_.discount, exist_rec_.discount_type, NULL);
                        counter_ := counter_ + 1;
                     ELSE
                        Duplicate_Price_List_Assort___(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.valid_from_date, line_rec_.assortment_id, 
                                                       line_rec_.assortment_node_id, line_rec_.price_unit_meas, new_line_from_date_, percentage_offset_,
                                                       amount_offset_, NULL);
                        counter_ := counter_ + 1;
                     END IF;
                  ELSE
                     CLOSE check_overlap_rec_found;
                     -- no need to create the line
                  END IF;
               END IF;
            ELSE
               IF (NOT same_date_record_updated_) THEN
                  -- No record exists on user defined from_date_. Hence Create a new line on that date with offset adjustment     
                  Duplicate_Price_List_Assort___(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.valid_from_date, line_rec_.assortment_id, 
                                                 line_rec_.assortment_node_id, line_rec_.price_unit_meas, valid_from_date_, percentage_offset_,
                                                 amount_offset_, line_rec_.valid_to_date);
                  counter_ := counter_ + 1;
                  same_date_record_updated_ := TRUE;
                  new_rec_created_on_from_date_ := TRUE;
               END IF;
            END IF;
         ELSIF ((line_rec_.valid_from_date > valid_from_date_) OR (line_rec_.valid_from_date = valid_from_date_ AND NOT same_date_record_updated_)) THEN
            -- update the line with offset values
            Duplicate_Price_List_Assort___(line_rec_.price_list_no, line_rec_.min_quantity, line_rec_.valid_from_date, line_rec_.assortment_id, 
                                           line_rec_.assortment_node_id, line_rec_.price_unit_meas, line_rec_.valid_from_date, percentage_offset_,
                                           amount_offset_, line_rec_.valid_to_date);
            counter_ := counter_ + 1;
         END IF;
         prev_price_list_no_ := line_rec_.price_list_no;
         prev_assortment_id_ := line_rec_.assortment_id;
         prev_assortment_node_id_ := line_rec_.assortment_node_id;
         prev_price_unit_meas_ := line_rec_.price_unit_meas;
         prev_min_quantity_ := line_rec_.min_quantity;
      END LOOP;
   END IF;
   number_of_updates_ := counter_;
END Update_Assort_Prices___;


-- Get_Source_Reb_Builder_Db___
--   Retrieve reb_builder_db_ from given source and source id.
PROCEDURE Get_Source_Reb_Builder_Db___ (
   rebate_builder_db_ IN OUT VARCHAR2,
   source_db_         IN     VARCHAR2,
   source_id_         IN     VARCHAR2 )
IS
BEGIN
   rebate_builder_db_ := NULL;
   IF (source_db_ = 'AGREEMENT') THEN
      rebate_builder_db_ := Customer_Agreement_API.Get_Rebate_Builder_Db(source_id_);
   ELSIF (source_db_ = 'CAMPAIGN') THEN
      rebate_builder_db_ := Campaign_API.Get_Rebate_Builder_Db(source_id_);
   END IF;
END Get_Source_Reb_Builder_Db___;


-- Get_Disc_For_Price_Source___
--   Retrieve base_sale_unit_price, discount_source_db, discount_source_id, currency_rate_
--   and discount_  from given price source and source id.
PROCEDURE Get_Disc_For_Price_Source___(
   base_sale_unit_price_     OUT    NUMBER,
   base_unit_price_incl_tax_ OUT    NUMBER,
   discount_source_db_       OUT    VARCHAR2,
   discount_source_id_       OUT    VARCHAR2,
   currency_rate_            OUT    NUMBER,
   discount_                 IN OUT NUMBER,
   sale_unit_price_          IN     NUMBER,
   sale_unit_price_incl_tax_ IN     NUMBER,
   net_price_fetched_        IN     VARCHAR2,
   price_source_db_          IN     VARCHAR2,
   price_source_id_          IN     VARCHAR2,
   contract_                 IN     VARCHAR2,
   catalog_no_               IN     VARCHAR2,
   customer_no_              IN     VARCHAR2,
   customer_no_pay_          IN     VARCHAR2,
   currency_code_            IN     VARCHAR2,
   agreement_id_             IN     VARCHAR2,
   campaign_id_              IN     NUMBER,
   hierarchy_id_             IN     VARCHAR2,
   effectivity_date_         IN     DATE,
   customer_arr_             IN     tab_customer_no,
   buy_qty_due_              IN     NUMBER,
   total_                    IN     BINARY_INTEGER,
   currency_rate_type_       IN     VARCHAR2,
   use_price_incl_tax_       IN     VARCHAR2,
   sales_price_type_db_      IN     VARCHAR2 )
IS
   discount_method_db_         VARCHAR2(30);
   additional_disc_type_       VARCHAR2(25);
   assortment_id_              VARCHAR2(50);
   assortment_node_id_         VARCHAR2(50);
   discount_sub_source_        VARCHAR2(30);
   discount_part_level_db_     VARCHAR2(30);
   discount_part_level_id_     VARCHAR2(200);
   discount_customer_level_db_ VARCHAR2(30);
   discount_customer_level_id_ VARCHAR2(200);
   additional_discount_        NUMBER;
   effective_min_quantity_     NUMBER;
   currency_rounding_          NUMBER;
   effective_valid_from_date_  DATE;
   effective_disc_price_uom_   SALES_PART_TAB.price_unit_meas%TYPE;
BEGIN
   -- If net price is checked with the fetched price, do not pick any discount.
   IF (net_price_fetched_ = db_false_) THEN
      discount_method_db_ := Cust_Order_Discount_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Discount_Method(contract_));
      IF (discount_ IS NOT NULL) THEN
         discount_source_db_ := price_source_db_;
         discount_source_id_ := price_source_id_;
      END IF;
      -- More than one automatic discount per order line not allowed.
      IF (discount_method_db_ = 'SINGLE_DISCOUNT') THEN
         IF (discount_ IS NULL) THEN
            -- Passed NULL as last 2 parameters, introduced to handle multiple discount hierarchy structure.
            Get_Additional_Discount___(additional_discount_,  additional_disc_type_, discount_source_db_, discount_source_id_, effective_min_quantity_, 
                                       effective_valid_from_date_, assortment_id_, assortment_node_id_, discount_sub_source_, effective_disc_price_uom_,
                                       discount_part_level_db_, discount_part_level_id_, discount_customer_level_db_, discount_customer_level_id_,
                                       contract_, catalog_no_, customer_no_, currency_code_, agreement_id_, campaign_id_, hierarchy_id_, effectivity_date_, 
                                       customer_arr_, buy_qty_due_, total_, sales_price_type_db_, NULL, NULL);

            discount_ := additional_discount_;
         END IF;
      ELSE
         -- Passed NULL as last 2 parameters, introduced to handle multiple discount hierarchy structure.
         Get_Additional_Discount___(additional_discount_, additional_disc_type_, discount_source_db_, discount_source_id_, effective_min_quantity_, 
                                    effective_valid_from_date_, assortment_id_, assortment_node_id_, discount_sub_source_, effective_disc_price_uom_,
                                    discount_part_level_db_, discount_part_level_id_, discount_customer_level_db_, discount_customer_level_id_,
                                    contract_, catalog_no_, customer_no_, currency_code_, agreement_id_, campaign_id_, hierarchy_id_, effectivity_date_,
                                    customer_arr_, buy_qty_due_, total_, sales_price_type_db_, NULL, NULL);

         IF (additional_discount_ IS NOT NULL) THEN
            currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(contract_),
                                                                          currency_code_);

            discount_          := Calculate_Total_Discount___(discount_, 
                                                              additional_discount_, 
                                                              sale_unit_price_, 
                                                              sale_unit_price_incl_tax_,
                                                              use_price_incl_tax_);
         END IF;
      END IF;
   END IF;
   discount_ := NVL(discount_, 0);

   Get_Base_Price_In_Currency(base_unit_price_incl_tax_,
                              currency_rate_,
                              NVL(customer_no_pay_, customer_no_),
                              contract_, 
                              currency_code_, 
                              sale_unit_price_incl_tax_, 
                              currency_rate_type_);
   Get_Base_Price_In_Currency(base_sale_unit_price_,
                              currency_rate_,
                              NVL(customer_no_pay_, customer_no_),
                              contract_, 
                              currency_code_, 
                              sale_unit_price_, 
                              currency_rate_type_);
END Get_Disc_For_Price_Source___;

   
PROCEDURE Calc_Sales_Price_List_Cost___ (
   cost_                OUT NUMBER,
   use_inventory_value_ IN  VARCHAR2,
   cost_set_            IN  NUMBER,
   base_price_site_     IN  VARCHAR2,
   valid_from_date_     IN  DATE,
   catalog_no_          IN  VARCHAR2,
   min_quantity_        IN  NUMBER,   
   price_list_no_       IN  VARCHAR2)
IS
   supply_type_          VARCHAR2(3) := NULL;
   currency_rate_        NUMBER;
   conv_factor_          NUMBER;
   currency_type_        VARCHAR2(10);
   sales_price_list_rec_ Sales_Price_List_API.Public_Rec;
   part_no_              VARCHAR2(25);
BEGIN   
   -- Cost calculation
   IF use_inventory_value_ = db_true_ THEN
      part_no_     := Sales_Part_API.Get_Part_No(base_price_site_,catalog_no_);
      supply_type_ := Order_Supply_Type_API.Encode(Sales_Part_API.Get_Default_Supply_Code(base_price_site_, catalog_no_));
      cost_        := Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead(base_price_site_,
                                                                       part_no_,
                                                                       '*',
                                                                       NULL,
                                                                       min_quantity_,
                                                                       'CHARGED ITEM',
                                                                       supply_type_,
                                                                       NULL,
                                                                       'COMPANY OWNED');
   ELSIF cost_set_ IS NOT NULL THEN
      cost_ := Customer_Order_Pricing_API.Get_Base_Price_From_Costing(base_price_site_,catalog_no_, cost_set_);
   END IF;
   
   sales_price_list_rec_ := Sales_Price_List_API.Get(price_list_no_);
   
   IF cost_ IS NOT NULL AND cost_ > 0 AND sales_price_list_rec_.currency_code != Company_Finance_Api.Get_Currency_Code(Site_API.Get_Company(base_price_site_)) THEN
      Invoice_Library_API.Get_Currency_Rate_Defaults(currency_type_,
                                                     conv_factor_,
                                                     currency_rate_,
                                                     sales_price_list_rec_.owning_company,
                                                     sales_price_list_rec_.currency_code,
                                                     valid_from_date_);
      currency_rate_ := currency_rate_ / conv_factor_;
      cost_          := cost_ / currency_rate_;
   END IF;
END Calc_Sales_Price_List_Cost___;


PROCEDURE Calculate_Discount___ (   
   total_disc_amt_  OUT NUMBER,
   quotation_no_    IN  VARCHAR2,
   line_no_         IN  VARCHAR2,
   rel_no_          IN  VARCHAR2,
   line_item_no_    IN  NUMBER,
   disc_pct_        IN  NUMBER,
   unit_price_      IN  NUMBER,
   quantity_        IN  NUMBER,
   price_conv_fact_ IN  NUMBER,   
   calc_disc_excl_tax_ IN  BOOLEAN DEFAULT FALSE )
IS
   quote_rec_                Order_Quotation_API.Public_Rec;  
   currency_rounding_        NUMBER;      
   line_discount_amount_     NUMBER;      
   contract_                 VARCHAR2(5);
   currency_code_            VARCHAR2(3);
   price_qty_                NUMBER;            
   unround_line_disc_amount_ NUMBER;
   line_disc_amount_incl_tax_ NUMBER;
   dummy_tax_dom_amount_      NUMBER;
   dummy_tax_curr_amount_     NUMBER;
   dummy_net_dom_amount_      NUMBER; 
   dummy_gross_dom_amount_    NUMBER; 
   line_disc_amount_          NUMBER; 
   
BEGIN       
   quote_rec_                := Order_Quotation_API.Get(quotation_no_);
   contract_                 := quote_rec_.contract;
   currency_code_            := quote_rec_.currency_code;
   currency_rounding_        := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(contract_), currency_code_);     

   price_qty_                := quantity_ * price_conv_fact_;           
   unround_line_disc_amount_ := (unit_price_ * (disc_pct_ / 100)) * price_qty_;      
   line_discount_amount_     := ROUND(unround_line_disc_amount_, currency_rounding_);      

   -- get line discount amount excluding tax when price including tax is specified.
   IF calc_disc_excl_tax_ THEN
      line_disc_amount_incl_tax_ := line_discount_amount_;
      
      Tax_Handling_Order_Util_API.Get_Amounts(dummy_tax_dom_amount_, 
                                             dummy_net_dom_amount_, 
                                             dummy_gross_dom_amount_, 
                                             dummy_tax_curr_amount_, 
                                             line_disc_amount_, 
                                             line_disc_amount_incl_tax_, 
                                             Site_API.Get_Company(quote_rec_.contract), 
                                             Tax_Source_API.DB_ORDER_QUOTATION_LINE, 
                                             quotation_no_, 
                                             line_no_, 
                                             rel_no_, 
                                             line_item_no_,
                                             '*');                                            
      
      line_discount_amount_ := line_disc_amount_;
   END IF;

   total_disc_amt_ := line_discount_amount_;       
END Calculate_Discount___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Calc_Sales_Price_List_Cost__ (
   cost_                OUT    NUMBER,
   use_inventory_value_ IN OUT VARCHAR2,
   cost_set_            IN OUT NUMBER,
   base_price_site_     IN     VARCHAR2,
   valid_from_date_     IN     DATE,
   catalog_no_          IN     VARCHAR2,
   min_quantity_        IN     NUMBER,
   cost_source_type_    IN     VARCHAR2,
   price_list_no_       IN     VARCHAR2)
IS   
BEGIN
   -- If a cost set is passed or the use inventory value flag is true, only cost will be calculated.
   IF cost_set_ IS NULL AND NVL(use_inventory_value_, db_false_) != db_true_ THEN
      IF cost_source_type_ IN ('INVENTORYVALUE', 'ALL') THEN
         use_inventory_value_ := Pricing_Contri_Margin_Ctrl_API.Get_Valid_Use_Inv_Value_Db(base_price_site_, valid_from_date_);
      END IF;
      IF cost_source_type_ IN ('COSTSET', 'ALL') THEN
         cost_set_            := Pricing_Contri_Margin_Ctrl_API.Get_Valid_Cost_Set(base_price_site_, valid_from_date_);
      END IF;
   END IF;
   -- Cost calculation
   Calc_Sales_Price_List_Cost___(cost_, use_inventory_value_, cost_set_, base_price_site_, valid_from_date_, catalog_no_, min_quantity_, price_list_no_);
   
END Calc_Sales_Price_List_Cost__;


@UncheckedAccess
FUNCTION Get_Sales_Price_List_Cost__ (   
   use_inventory_value_ IN VARCHAR2,
   cost_set_            IN NUMBER,
   base_price_site_     IN VARCHAR2,
   valid_from_date_     IN DATE,
   catalog_no_          IN VARCHAR2,
   min_quantity_        IN NUMBER,    
   price_list_no_       IN VARCHAR2 ) RETURN NUMBER
IS
   cost_ NUMBER;   
BEGIN   
  -- Cost calculation
  Calc_Sales_Price_List_Cost___(cost_, use_inventory_value_, cost_set_, base_price_site_, valid_from_date_, catalog_no_, min_quantity_, price_list_no_);
  RETURN cost_;
END Get_Sales_Price_List_Cost__;


PROCEDURE Add_Parts_To_Price_Lists__ (
   number_of_new_lines_ OUT NUMBER,
   price_list_no_       IN  VARCHAR2,
   owning_company_      IN  VARCHAR2,
   catalog_no_          IN  VARCHAR2,
   base_price_site_     IN  VARCHAR2,
   sales_price_group_   IN  VARCHAR2,
   valid_from_          IN  DATE,
   add_sales_prices_    IN  VARCHAR2,
   add_rental_prices_   IN  VARCHAR2,
   valid_to_date_       IN  DATE )
IS
   added_lines_ NUMBER := 0;

   CURSOR get_price_lists_to_update IS
      SELECT price_list_no, sales_price_group_id, default_percentage_offset, default_amount_offset
      FROM   sales_price_list_tab
      WHERE  Report_SYS.Parse_Parameter(price_list_no, price_list_no_) = db_true_
      AND    Report_SYS.Parse_Parameter(owning_company, owning_company_) = db_true_
      AND    Report_SYS.Parse_Parameter(sales_price_group_id, sales_price_group_) = db_true_
      AND    subscribe_new_sales_parts = Fnd_Boolean_API.db_true
      AND    owning_company IN (SELECT company 
                                FROM   company_finance_auth_pub);
BEGIN
   number_of_new_lines_ := 0;

   FOR lists_ IN get_price_lists_to_update LOOP
      Add_Part_To_Price_List__(added_lines_,
                               lists_.price_list_no,
                               catalog_no_,
                               valid_from_,
                               base_price_site_,
                               NULL,
                               NULL,
                               lists_.default_percentage_offset,
                               lists_.default_amount_offset,
                               lists_.sales_price_group_id,
                               add_sales_prices_,
                               add_rental_prices_,
                               valid_to_date_);
      number_of_new_lines_ := number_of_new_lines_ + added_lines_;
   END LOOP;
END Add_Parts_To_Price_Lists__;


PROCEDURE Start_Add_Prt_To_Price_Lists__ (
   attr_ IN VARCHAR2 )
IS
   number_of_new_lines_  NUMBER;
   price_list_no_        VARCHAR2(10);
   catalog_no_           VARCHAR2(4000);
   valid_from_           DATE;
   base_price_site_      VARCHAR2(2000);
   sales_price_group_    VARCHAR2(4000);
   info_                 VARCHAR2(2000);
   owning_company_       VARCHAR2(20);
   add_sales_prices_     VARCHAR2(5);
   add_rental_prices_    VARCHAR2(5);
   valid_to_date_        DATE;
   
BEGIN
   price_list_no_     := Client_SYS.Get_Item_Value('PRICE_LIST_NO', attr_);
   owning_company_    := Client_SYS.Get_Item_Value('OWNING_COMPANY', attr_);
   catalog_no_        := Client_SYS.Get_Item_Value('CATALOG_NO', attr_);
   base_price_site_   := Client_SYS.Get_Item_Value('BASE_PRICE_SITE', attr_);
   sales_price_group_ := Client_SYS.Get_Item_Value('SALES_PRICE_GROUP', attr_);
   valid_from_        := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_FROM', attr_));
   add_sales_prices_  := Client_SYS.Get_Item_Value('ADD_SALES_PRICES', attr_);
   add_rental_prices_ := Client_SYS.Get_Item_Value('ADD_RENTAL_PRICES', attr_);
   valid_to_date_     := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_TO_DATE', attr_));
   
   Add_Parts_To_Price_Lists__(number_of_new_lines_,
                              price_list_no_,
                              owning_company_,
                              catalog_no_,
                              base_price_site_,
                              sales_price_group_,
                              valid_from_,
                              add_sales_prices_,
                              add_rental_prices_,
                              valid_to_date_);

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (number_of_new_lines_ > 0) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NEW_LINES_LISTS: :P1 Sales Part(s) added to the Price List(s).', NULL, TO_CHAR(number_of_new_lines_));
      ELSE
         Raise_Rec_Add_Info_Message___(info_);
      END IF;
      Transaction_SYS.Set_Progress_Info(info_);
   END IF;
END Start_Add_Prt_To_Price_Lists__;


PROCEDURE Add_Parts_To_Price_Lists_Bat__ (
   price_list_no_     IN VARCHAR2,
   owning_company_    IN VARCHAR2,
   catalog_no_        IN VARCHAR2,
   base_price_site_   IN VARCHAR2,
   sales_price_group_ IN VARCHAR2,
   valid_from_        IN DATE,
   add_sales_prices_  IN VARCHAR2,
   add_rental_prices_ IN VARCHAR2,
   valid_to_date_     IN DATE )
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Add_To_Attr('PRICE_LIST_NO', price_list_no_, attr_);
   Client_SYS.Add_To_Attr('OWNING_COMPANY', owning_company_, attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_, attr_);
   Client_SYS.Add_To_Attr('BASE_PRICE_SITE', base_price_site_, attr_);
   Client_SYS.Add_To_Attr('SALES_PRICE_GROUP', sales_price_group_, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM', valid_from_, attr_);
   Client_SYS.Add_To_Attr('ADD_SALES_PRICES', add_sales_prices_, attr_);
   Client_SYS.Add_To_Attr('ADD_RENTAL_PRICES', add_rental_prices_, attr_);
   Client_SYS.Add_To_Attr('VALID_TO_DATE', valid_to_date_, attr_);
   
   Transaction_SYS.Deferred_Call('Customer_Order_Pricing_API.Start_Add_Prt_To_Price_Lists__', attr_,
   Language_SYS.Translate_Constant(lu_name_, 'ADD_TO_PRICELISTS: Add Sales Parts to Sales Price Lists'));
END Add_Parts_To_Price_Lists_Bat__;


-------------------------------------------------------------------------------------------------------------------
-- Get_First_Base_Price_Site__
--    Return the base price site if only one site exists. 
--    Return null if there are more than one site.
-------------------------------------------------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_First_Base_Price_Site__ (
   catalog_no_           IN VARCHAR2,
   sales_price_group_id_ IN VARCHAR2,
   sales_price_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS
   base_price_site_ VARCHAR2(5);
   next_price_site_ VARCHAR2(5);
   CURSOR get_base_price_site IS
      SELECT base_price_site
      FROM   sales_part_base_price_tab bp, sales_part_tab sp
      WHERE  bp.catalog_no = catalog_no_
      AND    sp.sales_price_group_id = sales_price_group_id_
      AND    bp.base_price_site = sp.contract
      AND    bp.catalog_no = sp.catalog_no
      AND    bp.sales_price_type = sales_price_type_db_;
BEGIN
   OPEN  get_base_price_site;
   FETCH get_base_price_site INTO base_price_site_;
   IF get_base_price_site%FOUND THEN
      FETCH get_base_price_site INTO next_price_site_;
      IF base_price_site_ != next_price_site_ THEN
         CLOSE get_base_price_site;
         RETURN NULL;
      END IF;
   END IF;
   CLOSE get_base_price_site;
   RETURN base_price_site_;
END Get_First_Base_Price_Site__;


-------------------------------------------------------------------------------------------------------------------
-- Get_First_Base_Price_Site__
--    Return the base price site if only one site exists. 
--    Return null if there are more than one site.
-------------------------------------------------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_First_Base_Price_Site__ (
   catalog_no_          IN VARCHAR2,
   sales_price_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   base_price_site_ VARCHAR2(5);
   next_price_site_ VARCHAR2(5);
   CURSOR get_base_price_site IS
      SELECT base_price_site
      FROM   sales_part_base_price_tab bp, sales_part_tab sp
      WHERE  bp.catalog_no = catalog_no_
      AND    bp.base_price_site = sp.contract
      AND    bp.catalog_no = sp.catalog_no
      AND    bp.sales_price_type = sales_price_type_db_;
BEGIN
   OPEN  get_base_price_site;
   FETCH get_base_price_site INTO base_price_site_;
   IF get_base_price_site%FOUND THEN
      FETCH get_base_price_site INTO next_price_site_;
      IF base_price_site_ != next_price_site_ THEN
         CLOSE get_base_price_site;
         RETURN NULL;
      END IF;
   END IF;
   CLOSE get_base_price_site;
   RETURN base_price_site_;
END Get_First_Base_Price_Site__;


-- Update_Part_Prices__
--   Updates part based records using specified select criteria on price lists,
--   fetching currect base prices. Returns the number of updates made.
PROCEDURE Update_Part_Prices__ (
   number_of_updates_      OUT NUMBER,
   valid_from_date_        IN  DATE,
   sales_price_origin_db_  IN  VARCHAR2,
   price_list_attr_        IN  VARCHAR2,
   sales_price_group_attr_ IN  VARCHAR2,
   catalog_no_attr_        IN  VARCHAR2,
   base_price_site_attr_   IN  VARCHAR2,
   company_attr_           IN  VARCHAR2,
   update_sales_prices_    IN  VARCHAR2,
   update_rental_prices_   IN  VARCHAR2,
   include_period_         IN  VARCHAR2 )
IS    
BEGIN
   Update_Part_Prices___(number_of_updates_, 
                         valid_from_date_, 
                         sales_price_origin_db_, 
                         price_list_attr_,
                         sales_price_group_attr_, 
                         catalog_no_attr_, 
                         base_price_site_attr_, 
                         company_attr_,
                         update_sales_prices_,
                         update_rental_prices_,
                         include_period_);
END Update_Part_Prices__;


-- Update_Part_Prices_Batch__
--   Updates part based records as a background job using specified select criteria
--   on price lists, fetching currect base prices. The number of updates is stored
--   in the background details.
PROCEDURE Update_Part_Prices_Batch__ (
   valid_from_date_        IN DATE,
   sales_price_origin_db_  IN VARCHAR2,
   price_list_attr_        IN VARCHAR2,
   sales_price_group_attr_ IN VARCHAR2,
   catalog_no_attr_        IN VARCHAR2,
   base_price_site_attr_   IN VARCHAR2,
   company_attr_           IN VARCHAR2,
   update_sales_prices_    IN VARCHAR2,
   update_rental_prices_   IN VARCHAR2,
   include_period_         IN VARCHAR2 )
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', valid_from_date_, attr_);
   Client_SYS.Add_To_Attr('SALES_PRICE_ORIGIN_DB', sales_price_origin_db_, attr_);
   Client_SYS.Add_To_Attr('PRICE_LIST_ATTR', price_list_attr_, attr_);
   Client_SYS.Add_To_Attr('SALES_PRICE_GROUP_ATTR', sales_price_group_attr_, attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO_ATTR', catalog_no_attr_, attr_);
   Client_SYS.Add_To_Attr('BASE_PRICE_SITE_ATTR', base_price_site_attr_, attr_);
   Client_SYS.Add_To_Attr('COMPANY_ATTR', company_attr_, attr_);
   Client_SYS.Add_To_Attr('UPDATE_SALES_PRICES', update_sales_prices_, attr_);
   Client_SYS.Add_To_Attr('UPDATE_RENTAL_PRICES', update_rental_prices_, attr_);
   Client_SYS.Add_To_Attr('INCLUDE_PERIOD', include_period_, attr_);

   Transaction_SYS.Deferred_Call('Customer_Order_Pricing_API.Start_Update_Part_Prices__', attr_,
                                       Language_SYS.Translate_Constant(lu_name_, 'UPDATE_PRICELIST: Update Sales Price Lists'));
END Update_Part_Prices_Batch__;


-- Update_Unit_Prices__
--   Updates unit based records with specified select criteria on price lists,
--   using the offsets to set the new sales price . Returns the number of updates made.
PROCEDURE Update_Unit_Prices__ (
   number_of_updates_      OUT NUMBER,
   valid_from_date_        IN  DATE,
   percentage_offset_      IN  NUMBER,
   amount_offset_          IN  NUMBER,
   price_list_attr_        IN  VARCHAR2,
   sales_price_group_attr_ IN  VARCHAR2,
   company_attr_           IN  VARCHAR2,
   include_period_         IN  VARCHAR2 )
IS
BEGIN
   Update_Unit_Prices___(number_of_updates_, valid_from_date_, percentage_offset_, amount_offset_,
                         price_list_attr_, sales_price_group_attr_, company_attr_, include_period_);
END Update_Unit_Prices__;


-- Update_Unit_Prices_Batch__
--   Updates unit based records in a background job using specified select criteria on
--   price lists, using the offsets to set the new sales price . The number of updates
--   is stored in the background details.
PROCEDURE Update_Unit_Prices_Batch__ (
   valid_from_date_        IN DATE,
   percentage_offset_      IN NUMBER,
   amount_offset_          IN NUMBER,
   price_list_attr_        IN VARCHAR2,
   sales_price_group_attr_ IN VARCHAR2,
   company_attr_           IN VARCHAR2,
   include_period_         IN  VARCHAR2 )
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', valid_from_date_, attr_);
   Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', percentage_offset_, attr_);
   Client_SYS.Add_To_Attr('AMOUNT_OFFSET', amount_offset_, attr_);
   Client_SYS.Add_To_Attr('PRICE_LIST_ATTR', price_list_attr_, attr_);
   Client_SYS.Add_To_Attr('SALES_PRICE_GROUP_ATTR', sales_price_group_attr_, attr_);
   Client_SYS.Add_To_Attr('COMPANY_ATTR', company_attr_, attr_);
   Client_SYS.Add_To_Attr('INCLUDE_PERIOD', include_period_, attr_);

   Transaction_SYS.Deferred_Call('Customer_Order_Pricing_API.Start_Update_Unit_Prices__', attr_,
                                 Language_SYS.Translate_Constant(lu_name_, 'UPDATE_UNIT_BASED: Update Unit Based Price Lists'));
END Update_Unit_Prices_Batch__;


-- Start_Update_Part_Prices__
--   Starts the Update_Part_Prices___ procedure. This is just a "remapping"-method
--   so a batch job can be initiated with all corresponding parameters. Number of modifyed
--   records is store in the background job details.
PROCEDURE Start_Update_Part_Prices__ (
   attr_ IN VARCHAR2 )
IS
   number_of_updates_      NUMBER;
   valid_from_date_        DATE;
   sales_price_origin_db_  VARCHAR2(10);
   price_list_attr_        VARCHAR2(4000);
   sales_price_group_attr_ VARCHAR2(4000);
   catalog_no_attr_        VARCHAR2(4000);
   base_price_site_attr_   VARCHAR2(4000);
   company_attr_           VARCHAR2(2000);
   info_                   VARCHAR2(2000);
   update_sales_prices_    VARCHAR2(5);
   update_rental_prices_   VARCHAR2(5);
   include_period_         VARCHAR2(10);
BEGIN

   valid_from_date_        := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_FROM_DATE', attr_));
   sales_price_origin_db_  := Client_SYS.Get_Item_Value('SALES_PRICE_ORIGIN_DB', attr_);
   price_list_attr_        := Client_SYS.Get_Item_Value('PRICE_LIST_ATTR', attr_);
   sales_price_group_attr_ := Client_SYS.Get_Item_Value('SALES_PRICE_GROUP_ATTR', attr_);
   catalog_no_attr_        := Client_SYS.Get_Item_Value('CATALOG_NO_ATTR', attr_);
   base_price_site_attr_   := Client_SYS.Get_Item_Value('BASE_PRICE_SITE_ATTR', attr_);
   company_attr_           := Client_SYS.Get_Item_Value('COMPANY_ATTR', attr_);
   update_sales_prices_    := Client_SYS.Get_Item_Value('UPDATE_SALES_PRICES', attr_);
   update_rental_prices_   := Client_SYS.Get_Item_Value('UPDATE_RENTAL_PRICES', attr_);
   include_period_         := Client_SYS.Get_Item_Value('INCLUDE_PERIOD', attr_);
   
   Update_Part_Prices___(number_of_updates_, 
                         valid_from_date_, 
                         sales_price_origin_db_, 
                         price_list_attr_,
                         sales_price_group_attr_, 
                         catalog_no_attr_, 
                         base_price_site_attr_, 
                         company_attr_,
                         update_sales_prices_,
                         update_rental_prices_,
                         include_period_);

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (number_of_updates_ > 0) THEN
         Raise_Base_Prc_Info_Message___(info_, number_of_updates_);
      ELSE
         Raise_Rec_Upd_Info_Message___(info_);
      END IF;
      Transaction_SYS.Set_Progress_Info(info_);
   END IF;
END Start_Update_Part_Prices__;


-- Start_Update_Unit_Prices__
--   Starts the Update_Unit_Prices___ procedure. This is just a "remapping" -method so a
--   batch job can be initiated with all corresponding parameters. Number of modifyed
--   records is store in the background job details.
PROCEDURE Start_Update_Unit_Prices__ (
   attr_ IN VARCHAR2 )
IS
   number_of_updates_      NUMBER;
   valid_from_date_        DATE;
   percentage_offset_      NUMBER;
   amount_offset_          NUMBER;
   price_list_attr_        VARCHAR2(4000);
   sales_price_group_attr_ VARCHAR2(4000);
   company_attr_           VARCHAR2(2000);
   info_                   VARCHAR2(2000);
   include_period_         VARCHAR2(5);
BEGIN

   valid_from_date_        := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_FROM_DATE', attr_));
   percentage_offset_      := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('PERCENTAGE_OFFSET', attr_));
   amount_offset_          := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('AMOUNT_OFFSET', attr_));
   price_list_attr_        := Client_SYS.Get_Item_Value('PRICE_LIST_ATTR', attr_);
   sales_price_group_attr_ := Client_SYS.Get_Item_Value('SALES_PRICE_GROUP_ATTR', attr_);
   company_attr_           := Client_SYS.Get_Item_Value('COMPANY_ATTR', attr_);
   include_period_         := Client_SYS.Get_Item_Value('INCLUDE_PERIOD', attr_);

   Update_Unit_Prices___(number_of_updates_, valid_from_date_, percentage_offset_, amount_offset_,
                         price_list_attr_, sales_price_group_attr_, company_attr_, include_period_);

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (number_of_updates_ > 0) THEN
         Raise_Base_Prc_Info_Message___(info_, number_of_updates_);
      ELSE
         Raise_Rec_Upd_Info_Message___(info_);
      END IF;
      Transaction_SYS.Set_Progress_Info(info_);
   END IF;
END Start_Update_Unit_Prices__;


-- Start_Update_Assort_Prices__
--   Update SalesPriceListAssort records with the keys and attributes
--   passed with the attr_.
PROCEDURE Start_Update_Assort_Prices__ (
   attr_ IN VARCHAR2 )
IS
   number_of_updates_       NUMBER;
   valid_from_date_         DATE;
   percentage_offset_       NUMBER;
   amount_offset_           NUMBER;
   price_list_attr_         VARCHAR2(4000);
   sales_price_group_attr_  VARCHAR2(4000);
   assortment_id_attr_      VARCHAR2(4000);
   assortment_node_id_attr_ VARCHAR2(4000);
   company_attr_            VARCHAR2(2000);
   info_                    VARCHAR2(2000);
   include_period_          VARCHAR2(5);
   
BEGIN
   valid_from_date_         := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_FROM_DATE', attr_));
   percentage_offset_       := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('PERCENTAGE_OFFSET', attr_));
   amount_offset_           := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('AMOUNT_OFFSET', attr_));
   price_list_attr_         := Client_SYS.Get_Item_Value('PRICE_LIST_ATTR', attr_);
   sales_price_group_attr_  := Client_SYS.Get_Item_Value('SALES_PRICE_GROUP_ATTR', attr_);
   assortment_id_attr_      := Client_SYS.Get_Item_Value('ASSORTMENT_ID_ATTR', attr_);
   assortment_node_id_attr_ := Client_SYS.Get_Item_Value('ASSORTMENT_NODE_ID_ATTR', attr_);
   company_attr_            := Client_SYS.Get_Item_Value('COMPANY_ATTR', attr_);
   include_period_          := Client_SYS.Get_Item_Value('INCLUDE_PERIOD', attr_);
   
   Update_Assort_Prices___(number_of_updates_, valid_from_date_, percentage_offset_, amount_offset_,
                           price_list_attr_, sales_price_group_attr_, assortment_id_attr_, assortment_node_id_attr_,
                           company_attr_, include_period_);

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (number_of_updates_ > 0) THEN
         Raise_Base_Prc_Info_Message___(info_, number_of_updates_);
      ELSE
         Raise_Rec_Upd_Info_Message___(info_);
      END IF;
      Transaction_SYS.Set_Progress_Info(info_);
   END IF;
END Start_Update_Assort_Prices__;


-- Remove_Invalid_Base_Prices__
--   Deletes all records from price_lists specified in the attribute string that
--   are no longer valid.
--   Starts the AddNewSalesPart procedure. This is just a remapping -method so a batch
--   job can be initiated with all corresponding parameters. Number of modifyed records
--   is store in the background job details.
--   Do the same thing as Start_Add_New_Sales_Parts but it starts as batch job Number
--   of new lines loggs
PROCEDURE Remove_Invalid_Base_Prices__ (
   removed_items_   OUT NUMBER,
   valid_from_date_ IN  DATE,
   price_list_attr_ IN  VARCHAR2 )
IS
   counter_                 NUMBER := 0;
   ptr_                     NUMBER := NULL;
   name_                    VARCHAR2(30);
   price_list_no_           VARCHAR2(10);
   decision_pending_        BOOLEAN;
   next_valid_to_date_      DATE;
   effective_from_date_     DATE;
   current_valid_from_      DATE;
   
   CURSOR get_past_timeframed_part_rec IS
      SELECT catalog_no, min_quantity, min_duration, valid_from_date
      FROM   sales_price_list_part_tab
      WHERE  price_list_no = price_list_no_
      AND    valid_to_date < valid_from_date_
      AND    valid_to_date IS NOT NULL;
   
   CURSOR find_invalid_part_records IS
      SELECT catalog_no, min_quantity, min_duration, MAX(valid_from_date) valid_from_date
      FROM   sales_price_list_part_tab
      WHERE  price_list_no = price_list_no_
      AND    valid_from_date < valid_from_date_
      AND    valid_to_date IS NULL
      GROUP BY catalog_no, min_quantity, min_duration;
      
   CURSOR get_past_part_records(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN VARCHAR2, max_valid_from_ IN DATE) IS
      SELECT valid_from_date
      FROM   sales_price_list_part_tab
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    valid_from_date < max_valid_from_
      AND    valid_to_date IS NULL;
   
   CURSOR get_part_rec_valid_dates(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN VARCHAR2, effetive_valid_from_ IN DATE, current_valid_from_ IN DATE) IS
      SELECT valid_from_date, valid_to_date
      FROM   sales_price_list_part_tab
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    valid_from_date <= effetive_valid_from_
      AND    valid_from_date > current_valid_from_;
   
   CURSOR get_past_timeframed_unit_rec IS
      SELECT min_quantity, valid_from_date
      FROM   sales_price_list_unit_tab
      WHERE  price_list_no = price_list_no_
      AND    valid_to_date < valid_from_date_
      AND    valid_to_date IS NOT NULL;
   
   CURSOR find_invalid_unit_records IS
      SELECT min_quantity, MAX(valid_from_date) valid_from_date
      FROM   sales_price_list_unit_tab
      WHERE  price_list_no = price_list_no_
      AND    valid_from_date < valid_from_date_
      AND    valid_to_date IS NULL
      GROUP BY min_quantity;
      
   CURSOR get_past_unit_records(min_quantity_ IN NUMBER, max_valid_from_ IN DATE) IS
      SELECT valid_from_date
      FROM   sales_price_list_unit_tab
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date < max_valid_from_
      AND    valid_to_date IS NULL;
   
   CURSOR get_unit_rec_valid_dates(min_quantity_ IN NUMBER, effetive_valid_from_ IN DATE, current_valid_from_ IN DATE) IS
      SELECT valid_from_date, valid_to_date
      FROM   sales_price_list_unit_tab
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date <= effetive_valid_from_
      AND    valid_from_date > current_valid_from_;
      
   CURSOR get_past_timeframed_assort_rec IS
      SELECT assortment_id, assortment_node_id, price_unit_meas, min_quantity, valid_from_date
      FROM   sales_price_list_assort_tab
      WHERE  price_list_no = price_list_no_
      AND    valid_to_date < valid_from_date_
      AND    valid_to_date IS NOT NULL;
   
   CURSOR find_invalid_assort_records IS
      SELECT assortment_id, assortment_node_id, price_unit_meas, min_quantity, MAX(valid_from_date) valid_from_date
      FROM   sales_price_list_assort_tab
      WHERE  price_list_no = price_list_no_
      AND    valid_from_date < valid_from_date_
      AND    valid_to_date IS NULL
      GROUP BY assortment_id, assortment_node_id, price_unit_meas, min_quantity;
      
   CURSOR get_past_assort_records(assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, price_unit_meas_ IN VARCHAR2, min_quantity_ IN NUMBER, max_valid_from_ IN DATE) IS
      SELECT valid_from_date
      FROM   sales_price_list_assort_tab
      WHERE  price_list_no = price_list_no_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas = price_unit_meas_
      AND    min_quantity = min_quantity_
      AND    valid_from_date < max_valid_from_
      AND    valid_to_date IS NULL;
   
   CURSOR get_assort_rec_valid_dates(assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, price_unit_meas_ IN VARCHAR2, min_quantity_ IN NUMBER, effetive_valid_from_ IN DATE, current_valid_from_ IN DATE) IS
      SELECT valid_from_date, valid_to_date
      FROM   sales_price_list_assort_tab
      WHERE  price_list_no = price_list_no_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas = price_unit_meas_
      AND    min_quantity = min_quantity_
      AND    valid_from_date <= effetive_valid_from_
      AND    valid_from_date > current_valid_from_;
      
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(price_list_attr_, ptr_, name_, price_list_no_)) LOOP
      -- Removed all part prices that are defined both from date and to date which are before the user specified valid_from_date.
      FOR rem_rec_ IN get_past_timeframed_part_rec LOOP
         Sales_Price_List_Part_API.Remove(price_list_no_, rem_rec_.catalog_no, rem_rec_.min_quantity, rem_rec_.valid_from_date, rem_rec_.min_duration);
         counter_ := counter_ + 1;
      END LOOP;
      
      FOR rec_ IN find_invalid_part_records LOOP
         -- all record prior to the max(valid_from_date) < user defined valid_from_date must be removed
         FOR rem_rec_ IN get_past_part_records(rec_.catalog_no, rec_.min_quantity, rec_.min_duration, rec_.valid_from_date) LOOP
            Sales_Price_List_Part_API.Remove(price_list_no_, rec_.catalog_no, rec_.min_quantity, rem_rec_.valid_from_date, rec_.min_duration);
            counter_ := counter_ + 1;
         END LOOP;
         -- need to consider whether the current record can be removed
         effective_from_date_ := valid_from_date_;
         current_valid_from_ := rec_.valid_from_date;
         decision_pending_ := TRUE;
         LOOP
            next_valid_to_date_ := NULL;
            EXIT WHEN NOT(decision_pending_);
            OPEN get_part_rec_valid_dates(rec_.catalog_no, rec_.min_quantity, rec_.min_duration, effective_from_date_, current_valid_from_);
            FETCH get_part_rec_valid_dates INTO current_valid_from_, next_valid_to_date_;
            IF (get_part_rec_valid_dates%FOUND) THEN
               CLOSE get_part_rec_valid_dates;
               IF (next_valid_to_date_ IS NULL) THEN 
                  -- another valid record exists from the defined date. Hence we can remove the MAX(valid_from_date) < user defined from date(valid_from_date_)
                  Sales_Price_List_Part_API.Remove(price_list_no_, rec_.catalog_no, rec_.min_quantity, rec_.valid_from_date, rec_.min_duration);
                  counter_ := counter_ + 1;
                  decision_pending_ := FALSE;
               ELSE
                  effective_from_date_ := next_valid_to_date_ + 1;
               END IF;
            ELSE
               CLOSE get_part_rec_valid_dates;
               decision_pending_ := FALSE;
            END IF;
         END LOOP;
      END LOOP;

      -- Removed all unit based prices that are defined both from date and to date which are before the user specified valid_from_date.
      FOR rem_rec_ IN get_past_timeframed_unit_rec LOOP
         Sales_Price_List_Unit_API.Remove(price_list_no_, rem_rec_.min_quantity, rem_rec_.valid_from_date);
         counter_ := counter_ + 1;
      END LOOP;
      
      FOR rec_ IN find_invalid_unit_records LOOP
         -- all record prior to the max(valid_from_date) < user defined valid_from_date must be removed
         FOR rem_rec_ IN get_past_unit_records(rec_.min_quantity, rec_.valid_from_date) LOOP
            Sales_Price_List_Unit_API.Remove(price_list_no_, rec_.min_quantity, rem_rec_.valid_from_date);
            counter_ := counter_ + 1;
         END LOOP;
         -- need to consider whether the current record can be removed
         effective_from_date_ := valid_from_date_;
         current_valid_from_ := rec_.valid_from_date;
         decision_pending_ := TRUE;
         LOOP
            next_valid_to_date_ := NULL;
            EXIT WHEN NOT(decision_pending_);
            OPEN get_unit_rec_valid_dates(rec_.min_quantity, effective_from_date_, current_valid_from_);
            FETCH get_unit_rec_valid_dates INTO current_valid_from_, next_valid_to_date_;
            IF (get_unit_rec_valid_dates%FOUND) THEN
               CLOSE get_unit_rec_valid_dates;
               IF (next_valid_to_date_ IS NULL) THEN 
                  -- another valid record exists from the defined date. Hence we can remove the MAX(valid_from_date) < user defined from date(valid_from_date_)
                  Sales_Price_List_Unit_API.Remove(price_list_no_, rec_.min_quantity, rec_.valid_from_date);
                  counter_ := counter_ + 1;
                  decision_pending_ := FALSE;
               ELSE
                  effective_from_date_ := next_valid_to_date_ + 1;
               END IF;
            ELSE
               CLOSE get_unit_rec_valid_dates;
               decision_pending_ := FALSE;
            END IF;
         END LOOP;   
      END LOOP;

      -- Removed all assortment based prices that are defined both from date and to date which are before the user specified valid_from_date.
      FOR rem_rec_ IN get_past_timeframed_assort_rec LOOP
         Sales_Price_List_Assort_API.Remove(price_list_no_, rem_rec_.min_quantity, rem_rec_.valid_from_date, rem_rec_.assortment_id, rem_rec_.assortment_node_id, rem_rec_.price_unit_meas);
         counter_ := counter_ + 1;
      END LOOP;
      
      FOR rec_ IN find_invalid_assort_records LOOP
         -- all record prior to the max(valid_from_date) < user defined valid_from_date must be removed
         FOR rem_rec_ IN get_past_assort_records(rec_.assortment_id, rec_.assortment_node_id, rec_.price_unit_meas, rec_.min_quantity, rec_.valid_from_date) LOOP
            Sales_Price_List_Assort_API.Remove(price_list_no_, rec_.min_quantity, rem_rec_.valid_from_date, rec_.assortment_id, rec_.assortment_node_id, rec_.price_unit_meas);
            counter_ := counter_ + 1;
         END LOOP;
         -- need to consider whether the current record can be removed
         effective_from_date_ := valid_from_date_;
         current_valid_from_ := rec_.valid_from_date;
         decision_pending_ := TRUE;
         LOOP
            next_valid_to_date_ := NULL;
            EXIT WHEN NOT(decision_pending_);
            OPEN get_assort_rec_valid_dates(rec_.assortment_id, rec_.assortment_node_id, rec_.price_unit_meas, rec_.min_quantity, effective_from_date_, current_valid_from_);
            FETCH get_assort_rec_valid_dates INTO current_valid_from_, next_valid_to_date_;
            IF (get_assort_rec_valid_dates%FOUND) THEN
               CLOSE get_assort_rec_valid_dates;
               IF (next_valid_to_date_ IS NULL) THEN 
                  -- another valid record exists from the defined date. Hence we can remove the MAX(valid_from_date) < user defined from date(valid_from_date_)
                  Sales_Price_List_Assort_API.Remove(price_list_no_, rec_.min_quantity, rec_.valid_from_date, rec_.assortment_id, rec_.assortment_node_id, rec_.price_unit_meas);
                  counter_ := counter_ + 1;
                  decision_pending_ := FALSE;
               ELSE
                  effective_from_date_ := next_valid_to_date_ + 1;
               END IF;
            ELSE
               CLOSE get_assort_rec_valid_dates;
               decision_pending_ := FALSE;
            END IF;
         END LOOP;
      END LOOP;
   END LOOP;

   removed_items_ := counter_;
END Remove_Invalid_Base_Prices__;


PROCEDURE Start_Add_New_Sales_Parts__ (
   attr_ IN VARCHAR2 )
IS
   number_of_new_lines_    NUMBER;
   cost_set_               NUMBER;
   sales_price_origin_     VARCHAR2(200);
   base_price_site_attr_   VARCHAR2(2000);
   catalog_no_attr_        VARCHAR2(4000);
   sales_price_group_attr_ VARCHAR2(4000);
   info_                   VARCHAR2(2000);
   sales_price_type_db_    VARCHAR2(20);
   percentage_offset_      NUMBER;
   amount_offset_          NUMBER;
BEGIN
   sales_price_group_attr_ := Client_SYS.Get_Item_Value('SALES_PRICE_GROUP_ATTR', attr_);
   catalog_no_attr_        := Client_SYS.Get_Item_Value('CATALOG_NO_ATTR', attr_);
   base_price_site_attr_   := Client_SYS.Get_Item_Value('BASE_PRICE_SITE_ATTR', attr_);
   sales_price_origin_     := Client_SYS.Get_Item_Value('SALES_PRICE_ORIGIN', attr_);
   sales_price_type_db_    := Client_SYS.Get_Item_Value('SALES_PRICE_TYPE_DB', attr_);
   cost_set_               := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('COST_SET', attr_));
   percentage_offset_      := Client_SYS.Get_Item_Value('PERCENTAGE_OFFSET', attr_);
   amount_offset_          := Client_SYS.Get_Item_Value('AMOUNT_OFFSET', attr_);

   Add_New_Sales_Parts(number_of_new_lines_,
                       base_price_site_attr_,
                       catalog_no_attr_,
                       sales_price_group_attr_,
                       sales_price_origin_,
                       sales_price_type_db_,
                       cost_set_,
                       percentage_offset_,
                       amount_offset_);

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (number_of_new_lines_ > 0) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NUMBER_OF_NEWLINES: :P1 Sales Part(s) added to base price.', NULL, TO_CHAR(number_of_new_lines_));
      ELSE
         Raise_Rec_Add_Info_Message___(info_);
      END IF;
      Transaction_SYS.Log_Progress_Info(info_);
   END IF;
END Start_Add_New_Sales_Parts__;


PROCEDURE Add_New_Sales_Parts_Batch__ (
   base_price_site_attr_      IN VARCHAR2,
   catalog_no_attr_           IN VARCHAR2,
   sales_price_group_attr_    IN VARCHAR2,
   sales_price_origin_        IN VARCHAR2,
   sales_price_type_db_       IN VARCHAR2,
   cost_set_                  IN VARCHAR2,
   percentage_offset_         IN NUMBER,
   amount_offset_             IN NUMBER )
IS
   attr_ VARCHAR2(32000);
BEGIN
    Client_SYS.Clear_Attr(attr_);
    Client_SYS.Add_To_Attr('BASE_PRICE_SITE_ATTR', base_price_site_attr_, attr_);
    Client_SYS.Add_To_Attr('CATALOG_NO_ATTR', catalog_no_attr_, attr_);
    Client_SYS.Add_To_Attr('SALES_PRICE_GROUP_ATTR', sales_price_group_attr_, attr_);
    Client_SYS.Add_To_Attr('SALES_PRICE_ORIGIN', sales_price_origin_, attr_);
    Client_SYS.Add_To_Attr('SALES_PRICE_TYPE_DB', sales_price_type_db_, attr_);
    Client_SYS.Add_To_Attr('COST_SET', cost_set_, attr_);
    Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', percentage_offset_, attr_);
    Client_SYS.Add_To_Attr('AMOUNT_OFFSET', amount_offset_, attr_);

   Transaction_SYS.Deferred_Call('Customer_Order_Pricing_API.Start_Add_New_Sales_Parts__', attr_,
   Language_SYS.Translate_Constant(lu_name_, 'ADD_REC_PRICELIST: Add Sales parts to Sales Price Lists'));
END Add_New_Sales_Parts_Batch__;


-- Adjust_Offset_Price_List__
--   Adjust/Add percentage offset and AmountOffset
PROCEDURE Adjust_Offset_Price_List__ (
   number_of_adjustmets_ OUT NUMBER,
   price_list_no_        IN  VARCHAR2,
   percentage_offset_    IN  NUMBER,
   amount_offset_        IN  NUMBER,
   new_valid_from_date_  IN  DATE,
   adjustment_type_      IN  VARCHAR2,
   include_period_       IN  VARCHAR2 )
IS
   counter_                  NUMBER := 0;
   new_valid_to_date_          DATE;
   valid_from_date_            DATE;
   next_valid_from_found_      BOOLEAN := FALSE;
   dummy_                      NUMBER;
   create_new_line_            BOOLEAN;
   exist_rec_                  Sales_Price_List_Part_tab%ROWTYPE;
   sales_price_                NUMBER;
   next_valid_from_date_       DATE;
   next_valid_to_date_         DATE;
   same_date_record_updated_   BOOLEAN := FALSE;
   new_line_from_date_         DATE;
   sales_price_incl_tax_       NUMBER;
   use_price_incl_tax_db_      VARCHAR2(20);
   line_count_                 NUMBER := 0;
   final_percentage_offset_    NUMBER;
   final_amount_offset_        NUMBER;
   prev_catalog_no_            VARCHAR2(25);
   prev_min_quantity_          NUMBER;
   prev_min_duration_          NUMBER;
   new_rec_created_on_from_date_ BOOLEAN;
      
   CURSOR find_null_valid_to_date_recs IS
            SELECT catalog_no, min_quantity, min_duration, valid_from_date, sales_price, rounding, base_price, base_price_incl_tax, base_price_site,
                   percentage_offset, amount_offset
            FROM   sales_price_list_part_tab
            WHERE  price_list_no = price_list_no_
            AND    valid_to_date IS NULL
            AND   (catalog_no, min_quantity, valid_from_date) IN
                (SELECT catalog_no, min_quantity, valid_from_date
                 FROM  sales_price_list_part_tab
                 WHERE (catalog_no, min_quantity, valid_from_date) IN
                       (SELECT catalog_no, min_quantity, MAX(valid_from_date) valid_from_date
                        FROM   sales_price_list_part_tab
                        WHERE  price_list_no = price_list_no_
                        AND    valid_from_date <= new_valid_from_date_
                        AND    valid_to_date IS NULL
                        GROUP BY catalog_no, min_quantity)
                        UNION ALL
                        (SELECT catalog_no, min_quantity, valid_from_date
                         FROM   sales_price_list_part_tab
                         WHERE  price_list_no = price_list_no_
                         AND    valid_from_date > new_valid_from_date_
                         AND    valid_to_date IS NULL))
            ORDER BY catalog_no, min_quantity, valid_from_date;
            
      CURSOR find_valid_record IS
            SELECT catalog_no, min_quantity, min_duration, valid_from_date, valid_to_date, sales_price, sales_price_incl_tax, rounding, base_price, base_price_incl_tax, base_price_site,
                   percentage_offset, amount_offset
            FROM  sales_price_list_part_tab
            WHERE  price_list_no = price_list_no_
            AND    NVL(valid_to_date, new_valid_from_date_) >= new_valid_from_date_
            AND   (catalog_no, min_quantity, min_duration, valid_from_date) IN
                (SELECT catalog_no, min_quantity, min_duration, valid_from_date
                 FROM  sales_price_list_part_tab
                 WHERE (catalog_no, min_quantity, min_duration, valid_from_date) IN
                       (SELECT catalog_no, min_quantity, min_duration, MAX(valid_from_date) valid_from_date
                        FROM   sales_price_list_part_tab
                        WHERE  price_list_no = price_list_no_
                        AND    valid_from_date <= new_valid_from_date_
                        AND    valid_to_date IS NULL
                        GROUP BY catalog_no, min_quantity, min_duration)
                        UNION ALL
                        (SELECT catalog_no, min_quantity, min_duration, valid_from_date
                         FROM   sales_price_list_part_tab
                         WHERE  price_list_no = price_list_no_
                         AND    valid_from_date >= new_valid_from_date_)
                        UNION ALL
                        (SELECT catalog_no, min_quantity, min_duration, valid_from_date
                        FROM   sales_price_list_part_tab
                        WHERE  price_list_no = price_list_no_
                        AND    valid_to_date IS NOT NULL
                        AND    valid_from_date < new_valid_from_date_
                        AND    valid_to_date >= new_valid_from_date_ ))
            ORDER BY catalog_no, min_quantity, min_duration, valid_from_date;
            
      CURSOR get_adjacent_valid_rec(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN NUMBER, next_valid_from_date_ IN DATE) IS
         SELECT valid_to_date
         FROM   sales_price_list_part_tab
         WHERE  price_list_no = price_list_no_
         AND    catalog_no = catalog_no_
         AND    min_quantity = min_quantity_
         AND    min_duration = min_duration_
         AND    valid_from_date = next_valid_from_date_;
         
      CURSOR check_overlap_rec_found(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN NUMBER, from_date_ IN DATE, to_date_ IN DATE) IS
         SELECT 1
         FROM sales_price_list_part_tab
         WHERE  price_list_no = price_list_no_
         AND    catalog_no = catalog_no_
         AND    min_quantity = min_quantity_
         AND    min_duration = min_duration_
         AND    valid_to_date IS NULL
         AND    valid_from_date > from_date_
         AND    valid_from_date <= to_date_;
            
      CURSOR get_exist_record(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN NUMBER, from_date_ IN DATE) IS
         SELECT *
         FROM sales_price_list_part_tab
         WHERE  price_list_no = price_list_no_
         AND    catalog_no = catalog_no_
         AND    min_quantity = min_quantity_
         AND    min_duration = min_duration_
         AND    valid_from_date = from_date_;

BEGIN
   IF (percentage_offset_ != 0) OR (amount_offset_ != 0) THEN
      IF (include_period_ = 'FALSE') THEN
         FOR line_rec_ IN find_null_valid_to_date_recs LOOP
            valid_from_date_ := NULL;
            create_new_line_ := FALSE;
            exist_rec_ := NULL;
            next_valid_from_date_ := NULL;
            next_valid_to_date_ := NULL;
            line_count_ := 0;
            IF adjustment_type_ = 'AddToOffset' THEN
               final_percentage_offset_ := line_rec_.percentage_offset + percentage_offset_;
               final_amount_offset_     := line_rec_.amount_offset     + amount_offset_;
            ELSIF adjustment_type_ =  'AdjustOffset' THEN
               final_percentage_offset_  := line_rec_.percentage_offset +(line_rec_.percentage_offset * percentage_offset_)/100;
               final_amount_offset_      := line_rec_.amount_offset     +(line_rec_.amount_offset * amount_offset_)/100;
            END IF;   
            IF (line_rec_.valid_from_date < new_valid_from_date_) THEN
               -- Need to create a new line with valid from_date = valid_from_date_.
               -- For that we need to check whether any record exists with that valid_from_date.
               next_valid_from_found_ := FALSE;
               valid_from_date_ := new_valid_from_date_;
               LOOP
                  EXIT WHEN (next_valid_from_found_);
                  OPEN get_exist_record(line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.min_duration, valid_from_date_);
                  FETCH get_exist_record INTO exist_rec_;
                  IF (get_exist_record%FOUND) THEN
                     CLOSE get_exist_record;
                     IF (exist_rec_.valid_to_date IS NULL) THEN
                        -- record exist with valid_from_date = valid_from_date_ and valid_to_date null. Hence no need to create a new record
                        next_valid_from_found_ := TRUE;
                        create_new_line_ := FALSE;
                     ELSE
                        valid_from_date_ := exist_rec_.valid_to_date + 1; 
                     END IF;   
                  ELSE
                     CLOSE get_exist_record;
                     create_new_line_ := TRUE;
                     next_valid_from_found_ := TRUE;
                  END IF;   
               END LOOP;
               IF (create_new_line_) THEN
                  -- find the next record with valid_to_date null. If that record valid_from_date is earlier than our new valid_from_date then no need to create the record
                  OPEN check_overlap_rec_found(line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.min_duration, new_valid_from_date_, valid_from_date_);
                  FETCH check_overlap_rec_found INTO dummy_;
                  IF (check_overlap_rec_found%NOTFOUND) THEN
                     CLOSE check_overlap_rec_found;
                     -- create new record with valid_from_date = valid_from_date_
                     Duplicate_Price_List_Part___(line_count_, price_list_no_, line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                                  line_rec_.min_duration, valid_from_date_, final_percentage_offset_, final_amount_offset_, NULL, FALSE, TRUE);
                     counter_ := counter_ + line_count_;
                  ELSE
                     CLOSE check_overlap_rec_found;
                  END IF;
               END IF;   
            ELSE
               -- valid_from_date >= user defined from_date. Hence update those records with the given offset.
               Duplicate_Price_List_Part___(line_count_, price_list_no_, line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                            line_rec_.min_duration, line_rec_.valid_from_date, final_percentage_offset_, final_amount_offset_, NULL, FALSE, FALSE);
               counter_ := counter_ + line_count_;
            END IF;   
         END LOOP; 
      ELSE
         -- include_period = TRUE
         use_price_incl_tax_db_ := Sales_Price_List_API.Get_Use_Price_Incl_Tax_Db(price_list_no_);
         
         FOR line_rec_ IN find_valid_record LOOP
            next_valid_to_date_ := NULL;
            create_new_line_ := FALSE;
            exist_rec_ := NULL; 
            new_line_from_date_ := NULL;
            IF ((NVL(prev_catalog_no_, line_rec_.catalog_no) != line_rec_.catalog_no) OR (NVL(prev_min_quantity_, line_rec_.min_quantity) != line_rec_.min_quantity) OR (NVL(prev_min_duration_, line_rec_.min_duration) != line_rec_.min_duration)) THEN
               same_date_record_updated_ := FALSE;
               new_rec_created_on_from_date_ := FALSE;
            END IF;
            IF adjustment_type_ = 'AddToOffset' THEN
               final_percentage_offset_ := line_rec_.percentage_offset + percentage_offset_;
               final_amount_offset_     := line_rec_.amount_offset     + amount_offset_;
            ELSIF adjustment_type_ =  'AdjustOffset' THEN
               final_percentage_offset_ := line_rec_.percentage_offset +(line_rec_.percentage_offset * percentage_offset_)/100;
               final_amount_offset_     := line_rec_.amount_offset     +(line_rec_.amount_offset * amount_offset_)/100;
            END IF;
            IF (line_rec_.valid_from_date < new_valid_from_date_) THEN
               IF (line_rec_.valid_to_date IS NOT NULL) THEN
                  -- timeframe record found. that has to be broken into two. with old prices and new prices with adjustments.
                  -- update record with valid_to_date = new_valid_from_date_ - 1 
                  new_valid_to_date_ := new_valid_from_date_ - 1;
                  Sales_Price_List_Part_API.Modify_Valid_To_Date(price_list_no_, line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.valid_from_date, line_rec_.min_duration, new_valid_to_date_);
               END IF;
               -- create a new line with valid from date = new_valid_from_date_. If any line exists with same new_valid_from_date_ update that record
               OPEN get_exist_record(line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.min_duration, new_valid_from_date_);
               FETCH get_exist_record INTO exist_rec_;
               CLOSE get_exist_record;
               IF (exist_rec_.valid_from_date IS NOT NULL) THEN
                  IF (line_rec_.valid_to_date IS NOT NULL) THEN
                     IF (NOT same_date_record_updated_) THEN
                        -- update existing record with price information of line_rec_ and offset
                        Sales_Price_List_Part_API.Calculate_Sales_Prices(sales_price_,
                                                                         sales_price_incl_tax_,
                                                                         line_rec_.base_price,
                                                                         line_rec_.base_price_incl_tax,
                                                                         final_percentage_offset_,
                                                                         final_amount_offset_,
                                                                         line_rec_.rounding,
                                                                         line_rec_.base_price_site,
                                                                         line_rec_.catalog_no,
                                                                         use_price_incl_tax_db_,
                                                                         'FORWARD',
                                                                         NULL,
                                                                         NULL);
                        Sales_Price_List_Part_API.Modify_Offset(price_list_no_,
                                                                line_rec_.catalog_no,
                                                                line_rec_.min_quantity,
                                                                new_valid_from_date_,
                                                                line_rec_.min_duration,
                                                                final_percentage_offset_,
                                                                final_amount_offset_,
                                                                line_rec_.valid_to_date,
                                                                sales_price_,
                                                                sales_price_incl_tax_);                                                
                        counter_ := counter_ + 1;
                        same_date_record_updated_ := TRUE;
                     END IF;
                     next_valid_to_date_ := line_rec_.valid_to_date;
                     IF (exist_rec_.valid_to_date IS NULL AND same_date_record_updated_) THEN
                        Sales_Price_List_Part_API.Modify_Offset(price_list_no_,
                                                                line_rec_.catalog_no,
                                                                line_rec_.min_quantity,
                                                                exist_rec_.valid_from_date,
                                                                line_rec_.min_duration,
                                                                final_percentage_offset_,
                                                                final_amount_offset_,
                                                                next_valid_to_date_,
                                                                line_rec_.sales_price,
                                                                line_rec_.sales_price_incl_tax);
                     END IF;
                  ELSE
                     IF (NOT same_date_record_updated_) THEN
                        -- if line_rec_ is not timeframed, existing record can be modified only with offset values
                        IF adjustment_type_ = 'AddToOffset' THEN
                           final_percentage_offset_ := exist_rec_.percentage_offset + percentage_offset_;
                           final_amount_offset_     := exist_rec_.amount_offset     + amount_offset_;
                        ELSIF adjustment_type_ =  'AdjustOffset' THEN
                           final_percentage_offset_ := exist_rec_.percentage_offset +(exist_rec_.percentage_offset * percentage_offset_)/100;
                           final_amount_offset_     := exist_rec_.amount_offset     +(exist_rec_.amount_offset * amount_offset_)/100;
                        END IF;
                        Duplicate_Price_List_Part___(line_count_, price_list_no_, line_rec_.catalog_no, line_rec_.min_quantity, exist_rec_.valid_from_date,
                                                     line_rec_.min_duration, new_valid_from_date_, final_percentage_offset_, final_amount_offset_, exist_rec_.valid_to_date, FALSE, FALSE);
                        counter_ := counter_ + line_count_;
                        same_date_record_updated_ := TRUE;
                     END IF;
                     next_valid_to_date_ := exist_rec_.valid_to_date;
                  END IF;
                  next_valid_from_found_ := FALSE;
                  create_new_line_ := FALSE;
                  LOOP
                     EXIT WHEN next_valid_from_found_;
                     new_line_from_date_ := next_valid_to_date_ + 1;
                     OPEN get_adjacent_valid_rec(line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.min_duration, new_line_from_date_);
                     FETCH get_adjacent_valid_rec INTO next_valid_to_date_;
                     IF (get_adjacent_valid_rec%FOUND) THEN
                        CLOSE get_adjacent_valid_rec;
                        IF (next_valid_to_date_ IS NULL) THEN
                           next_valid_from_found_ := TRUE;
                           create_new_line_ := FALSE;
                        END IF;
                     ELSE      
                        CLOSE get_adjacent_valid_rec;
                        create_new_line_ := TRUE;
                        next_valid_from_found_ := TRUE;
                     END IF;
                  END LOOP;
                  IF (create_new_line_) THEN
                     -- need to create a new line with valid_from_date = next_valid_to_date_ + 1;.
                     OPEN check_overlap_rec_found(line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.min_duration, new_valid_from_date_, new_line_from_date_);
                     FETCH check_overlap_rec_found INTO dummy_;
                     IF (check_overlap_rec_found%NOTFOUND) THEN
                        CLOSE check_overlap_rec_found;
                        IF (line_rec_.valid_to_date IS NOT NULL) THEN
                           -- create new line on new_line_from_date_
                           IF adjustment_type_ = 'AddToOffset' THEN
                              final_percentage_offset_ := exist_rec_.percentage_offset + percentage_offset_;
                              final_amount_offset_     := exist_rec_.amount_offset     + amount_offset_;
                           ELSIF adjustment_type_ =  'AdjustOffset' THEN
                              final_percentage_offset_ := exist_rec_.percentage_offset +(exist_rec_.percentage_offset * percentage_offset_)/100;
                              final_amount_offset_     := exist_rec_.amount_offset     +(exist_rec_.amount_offset * amount_offset_)/100;
                           END IF;
                           IF (new_rec_created_on_from_date_) THEN
                              -- offset has already adjusted.. so need to re-calculate it.
                              final_percentage_offset_ := exist_rec_.percentage_offset;
                              final_amount_offset_     := exist_rec_.amount_offset;
                           END IF;
                           Sales_Price_List_Part_API.Calculate_Sales_Prices(sales_price_,
                                                                            sales_price_incl_tax_,
                                                                            exist_rec_.base_price,
                                                                            exist_rec_.base_price_incl_tax,
                                                                            final_percentage_offset_,
                                                                            final_amount_offset_,
                                                                            exist_rec_.rounding,
                                                                            exist_rec_.base_price_site,
                                                                            line_rec_.catalog_no,
                                                                            use_price_incl_tax_db_,
                                                                            'FORWARD',
                                                                            NULL,
                                                                            NULL);
                           -- create new timeframed record with valid from date = new_valid_from_date_ and adjust offset
                           Sales_Price_List_Part_API.New(price_list_no_, line_rec_.catalog_no, line_rec_.min_quantity, new_line_from_date_, line_rec_.min_duration,
                                                         line_rec_.base_price_site, exist_rec_.discount_type, exist_rec_.discount, exist_rec_.base_price, exist_rec_.base_price_incl_tax,
                                                         sales_price_, sales_price_incl_tax_, final_percentage_offset_, final_amount_offset_, exist_rec_.rounding,                   
                                                         template_id_         => Sales_Part_Base_Price_API.Get_Template_Id(line_rec_.base_price_site, line_rec_.catalog_no, exist_rec_.sales_price_type),
                                                         sales_price_type_db_ => exist_rec_.sales_price_type,
                                                         valid_to_date_ => NULL);
                           counter_ := counter_ + 1;
                        ELSE
                           IF adjustment_type_ = 'AddToOffset' THEN
                              final_percentage_offset_ := line_rec_.percentage_offset + percentage_offset_;
                              final_amount_offset_     := line_rec_.amount_offset     + amount_offset_;
                           ELSIF adjustment_type_ =  'AdjustOffset' THEN
                              final_percentage_offset_ := line_rec_.percentage_offset +(line_rec_.percentage_offset * percentage_offset_)/100;
                              final_amount_offset_     := line_rec_.amount_offset     +(line_rec_.amount_offset * amount_offset_)/100;
                           END IF;
                           Duplicate_Price_List_Part___(line_count_, price_list_no_, line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                                        line_rec_.min_duration, new_line_from_date_, final_percentage_offset_, final_amount_offset_, NULL, FALSE, TRUE);
                           counter_ := counter_ + line_count_;
                        END IF;
                     ELSE
                        CLOSE check_overlap_rec_found;
                        -- no need to create the line
                     END IF;
                  END IF;
               ELSE
                  IF (NOT same_date_record_updated_) THEN
                     -- No record exists on user defined from_date_. Hence Create a new line on that date with offset adjustment
                     IF adjustment_type_ = 'AddToOffset' THEN
                        final_percentage_offset_ := line_rec_.percentage_offset + percentage_offset_;
                        final_amount_offset_     := line_rec_.amount_offset     + amount_offset_;
                     ELSIF adjustment_type_ =  'AdjustOffset' THEN
                        final_percentage_offset_ := line_rec_.percentage_offset +(line_rec_.percentage_offset * percentage_offset_)/100;
                        final_amount_offset_     := line_rec_.amount_offset     +(line_rec_.amount_offset * amount_offset_)/100;
                     END IF;
                     Duplicate_Price_List_Part___(line_count_, price_list_no_, line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                                  line_rec_.min_duration, new_valid_from_date_, final_percentage_offset_, final_amount_offset_, line_rec_.valid_to_date, FALSE, TRUE);
                     counter_ := counter_ + line_count_;
                     same_date_record_updated_ := TRUE;
                     new_rec_created_on_from_date_ := TRUE;
                  END IF;
               END IF;
            ELSIF ( (line_rec_.valid_from_date > new_valid_from_date_) OR (line_rec_.valid_from_date = new_valid_from_date_ AND NOT same_date_record_updated_)) THEN
               -- update the line with offset values
               Duplicate_Price_List_Part___(line_count_, price_list_no_, line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                            line_rec_.min_duration, line_rec_.valid_from_date, final_percentage_offset_, final_amount_offset_, line_rec_.valid_to_date, FALSE, FALSE);
               counter_ := counter_ + line_count_;
            END IF;
            prev_catalog_no_ := line_rec_.catalog_no;
            prev_min_quantity_ := line_rec_.min_quantity;
            prev_min_duration_ := line_rec_.min_duration;
         END LOOP; 
      END IF; 
   END IF;

   number_of_adjustmets_ := counter_;
END Adjust_Offset_Price_List__;


-- Add_Part_To_Price_List__
--   Add new sales parts to the price list. All sales parts that fit the selection
--   criteria stated will be addet to the price list.
PROCEDURE Add_Part_To_Price_List__ (
   number_of_new_lines_ OUT NUMBER,
   price_list_no_       IN  VARCHAR2,
   catalog_no_          IN  VARCHAR2,
   valid_from_date_     IN  DATE,
   base_price_site_     IN  VARCHAR2,
   discount_type_       IN  VARCHAR2,
   discount_            IN  NUMBER,
   percentage_offset_   IN  NUMBER,
   amount_offset_       IN  NUMBER,
   sales_price_group_   IN  VARCHAR2,
   add_sales_prices_    IN  VARCHAR2,
   add_rental_prices_   IN  VARCHAR2,
   valid_to_date_       IN  DATE )
IS
   counter_                      NUMBER := 0;
   sales_price_                  NUMBER;
   sales_price_incl_tax_         NUMBER;
   min_quantity_                 NUMBER := 0;
   min_duration_                 NUMBER := -1;
   rate_                         NUMBER;
   base_price_curr_              NUMBER;
   base_price_                   NUMBER;
   base_price_incl_tax_curr_     NUMBER;
   base_price_incl_tax_          NUMBER;
   price_list_rec_               Sales_Price_List_API.Public_Rec;
   added_lines_                  NUMBER;
   used_price_break_template_id_ VARCHAR2(10);
   ignore_sales_price_type_      VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   sales_price_type_db_          VARCHAR2(20):= NULL;
   tax_percentage_               NUMBER;


   -- DECODE is used to handle situations where '%' is passed as the base_price_site,
   -- there is a default base price site given on the price list header and
   -- the sales part base price is defined on multiple base price sites. In this
   -- case the default base price site is prefered.
   CURSOR find_records_for_insert (default_base_price_site_ VARCHAR2) IS
      SELECT base_price_site, catalog_no, template_id, sales_price_type
      FROM   sales_part_base_price_tab sbp
      WHERE  (base_price_site_ = '%' OR Report_SYS.Parse_Parameter(base_price_site, base_price_site_) = db_true_)
      AND    (catalog_no_ = '%' OR Report_SYS.Parse_Parameter(catalog_no, catalog_no_) = db_true_)
      AND    (ignore_sales_price_type_ = 'TRUE' OR sales_price_type = sales_price_type_db_)
      AND    rowstate = 'Active'
      AND    catalog_no NOT IN (SELECT catalog_no
                                FROM   sales_price_list_part_tab
                                WHERE  price_list_no = price_list_no_
                                AND    sales_price_type = sbp.sales_price_type)
      AND EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE base_price_site = site)
      ORDER BY DECODE(base_price_site, default_base_price_site_, 1, 2);
BEGIN
   price_list_rec_ := Sales_Price_List_API.Get(price_list_no_);

   -- If both add_sales_prices_ and add_rental_prices_ are 'FALSE', non of the records updated.
   IF (add_sales_prices_ = Fnd_Boolean_API.DB_FALSE) AND (add_rental_prices_ = Fnd_Boolean_API.DB_FALSE) THEN
      RETURN;
   END IF;

   IF (add_sales_prices_ = Fnd_Boolean_API.DB_TRUE) AND (add_rental_prices_ = Fnd_Boolean_API.DB_TRUE) THEN
      ignore_sales_price_type_ := Fnd_Boolean_API.DB_TRUE;
   ELSIF (add_sales_prices_ = Fnd_Boolean_API.DB_TRUE) THEN
      sales_price_type_db_ := Sales_Price_Type_API.DB_SALES_PRICES;
   ELSIF (add_rental_prices_ = Fnd_Boolean_API.DB_TRUE) THEN
      sales_price_type_db_ := Sales_Price_Type_API.DB_RENTAL_PRICES;
   END IF;

   IF (Sales_Price_group_API.Get_Sales_Price_Group_Type_Db(sales_price_group_) != 'UNIT BASED') THEN
      FOR rec_ IN find_records_for_insert(Sales_Price_List_API.Get_Default_Base_Price_Site(price_list_no_)) LOOP
         IF (rec_.sales_price_type = Sales_Price_Type_API.DB_SALES_PRICES) THEN 
            min_duration_ := -1;
         ELSIF (rec_.sales_price_type = Sales_Price_Type_API.DB_RENTAL_PRICES) THEN
            min_duration_ := 0;
         END IF;
         IF (Sales_Part_API.Get_Sales_Price_Group_Id(rec_.base_price_site, rec_.catalog_no) = sales_price_group_) THEN
            IF (NOT Sales_Price_List_Part_API.Check_Exist(price_list_no_, rec_.catalog_no, min_quantity_, valid_from_date_, min_duration_)) THEN
               used_price_break_template_id_ := NULL;
               IF (price_list_rec_.use_price_incl_tax = 'TRUE') THEN 
                  -- Retreive/calculate the base price incl tax
                  Sales_Part_Base_Price_API.Calculate_Base_Price_incl_Tax(used_price_break_template_id_, 
                                                                          base_price_incl_tax_,
                                                                          rec_.base_price_site,
                                                                          rec_.catalog_no,
                                                                          rec_.sales_price_type,
                                                                          min_quantity_,
                                                                          price_list_rec_.use_price_break_templates,
                                                                          min_duration_);
                  -- Get base price incl tax in price list currency
                  Get_Sales_Price_In_Currency(base_price_incl_tax_curr_, rate_, NULL, rec_.base_price_site, price_list_rec_.currency_code, base_price_incl_tax_, NULL);                        
               ELSE
                  -- Retreive/calculate the base price
               -- Retreive/calculate the base price
                  Sales_Part_Base_Price_API.Calculate_Base_Price(used_price_break_template_id_, 
                                                                 base_price_, 
                                                                 rec_.base_price_site, 
                                                                 rec_.catalog_no, 
                                                                 rec_.sales_price_type, 
                                                                 min_quantity_,
                                                                 price_list_rec_.use_price_break_templates,
                                                                 min_duration_);

                  -- Get base price in price list currency
                  Get_Sales_Price_In_Currency(base_price_curr_, rate_, NULL, rec_.base_price_site, price_list_rec_.currency_code, base_price_, NULL);
               END IF;

               -- Fetch price break template
               IF used_price_break_template_id_ IS NULL AND price_list_rec_.use_price_break_templates = Fnd_Boolean_API.DB_TRUE THEN
                  used_price_break_template_id_ := Sales_Part_Base_Price_API.Get_Template_Id(rec_.base_price_site, rec_.catalog_no, Sales_Price_Type_API.Decode(rec_.sales_price_type));
               END IF;

               IF used_price_break_template_id_ IS NOT NULL THEN
                 -- Add part lines from price break template
                 Sales_Price_List_Part_API.Insert_Price_Break_Lines(added_lines_,
                                                                    price_list_no_,
                                                                    rec_.catalog_no,
                                                                    rec_.base_price_site,
                                                                    valid_from_date_,
                                                                    discount_type_,
                                                                    discount_,
                                                                    percentage_offset_,
                                                                    amount_offset_,
                                                                    NULL, 
                                                                    sales_price_type_db_ => rec_.sales_price_type,
                                                                    valid_to_date_ => valid_to_date_,
                                                                    from_header_ => TRUE);
                  counter_ := counter_ + added_lines_;
               ELSE
                  tax_percentage_             := NVL(Statutory_Fee_API.Get_Fee_Rate(Site_API.Get_Company(rec_.base_price_site), Sales_Part_API.Get_Tax_Code(rec_.base_price_site, rec_.catalog_no)), 0);
                  Calculate_Sales_Prices___(sales_price_, 
                                             sales_price_incl_tax_, 
                                             base_price_curr_, 
                                             base_price_incl_tax_curr_,
                                             percentage_offset_,
                                             amount_offset_,
                                             price_list_rec_.rounding,
                                             tax_percentage_,
                                             price_list_rec_.use_price_incl_tax );                 

                  Sales_Price_List_Part_API.New(price_list_no_,             rec_.catalog_no,           min_quantity_,
                                                valid_from_date_,           min_duration_,             rec_.base_price_site,
                                                discount_type_,             discount_,                 base_price_curr_, 
                                                base_price_incl_tax_curr_,  sales_price_,              sales_price_incl_tax_, 
                                                percentage_offset_,         amount_offset_,            price_list_rec_.rounding,
                                                sales_price_type_db_ => rec_.sales_price_type, valid_to_date_ => valid_to_date_);

                  counter_ := counter_ + 1;
               END IF;
            END IF;
         END IF;
      END LOOP;
   END IF;

   number_of_new_lines_ := counter_;
END Add_Part_To_Price_List__;


-- Add_Part_To_Price_List_Batch__
--   Add new sales parts to the price list. All sales parts that fit the selection
--   criteria stated will be added to the price list in a background job.
PROCEDURE Add_Part_To_Price_List_Batch__ (
   price_list_no_      IN VARCHAR2,
   catalog_no_         IN VARCHAR2,
   valid_from_date_    IN DATE,
   base_price_site_    IN VARCHAR2,
   discount_type_      IN VARCHAR2,
   discount_           IN NUMBER,
   percentage_offset_  IN NUMBER,
   amount_offset_      IN NUMBER,
   sales_price_group_  IN VARCHAR2,
   add_sales_prices_   IN VARCHAR2,
   add_rental_prices_  IN VARCHAR2,
   valid_to_date_      IN DATE )
IS
   attr_ VARCHAR2(32000);
BEGIN
    Client_SYS.Clear_Attr(attr_);
    Client_SYS.Add_To_Attr('PRICE_LIST_NO', price_list_no_, attr_);
    Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_, attr_);
    Client_SYS.Add_To_Attr('VALID_FROM_DATE', valid_from_date_, attr_);
    Client_SYS.Add_To_Attr('BASE_PRICE_SITE', base_price_site_, attr_);
    Client_SYS.Add_To_Attr('DISCOUNT_TYPE', discount_type_, attr_);
    Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
    Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', percentage_offset_, attr_);
    Client_SYS.Add_To_Attr('AMOUNT_OFFSET', amount_offset_, attr_);
    Client_SYS.Add_To_Attr('SALES_PRICE_GROUP', sales_price_group_, attr_);
    Client_SYS.Add_To_Attr('ADD_SALES_PRICES', add_sales_prices_, attr_);
    Client_SYS.Add_To_Attr('ADD_RENTAL_PRICES', add_rental_prices_, attr_);
    Client_SYS.Add_To_Attr('VALID_TO_DATE', valid_to_date_, attr_);

    Transaction_SYS.Deferred_Call('Customer_Order_Pricing_API.Start_Add_Part_To_Price_List__', attr_,
    Language_SYS.Translate_Constant(lu_name_, 'ADD_TO_PRICELIST: Add Sales Parts to Sales Price List'));
END Add_Part_To_Price_List_Batch__;


-- Start_Add_Part_To_Price_List__
--   Starts the AddPartToPriceList method as a background job.
--   Add the new Sales parts to the base_price_list. Calls by   Start_Add_New_Sales_Parts__,
--   and  Add_New_Sales_Parts_Batch__
PROCEDURE Start_Add_Part_To_Price_List__ (
   attr_ IN VARCHAR2 )
IS
   number_of_new_lines_  NUMBER;
   price_list_no_        VARCHAR2(10);
   catalog_no_           VARCHAR2(4000);
   valid_from_date_      DATE;
   base_price_site_      VARCHAR2(2000);
   discount_type_        VARCHAR2(25);
   discount_             NUMBER;
   percentage_offset_    NUMBER;
   amount_offset_        NUMBER;
   sales_price_group_    VARCHAR2(4000);
   info_                 VARCHAR2(2000);
   add_sales_prices_     VARCHAR2(5);
   add_rental_prices_    VARCHAR2(5);
   valid_to_date_        DATE;
BEGIN
   price_list_no_          := Client_SYS.Get_Item_Value('PRICE_LIST_NO', attr_);
   catalog_no_             := Client_SYS.Get_Item_Value('CATALOG_NO', attr_);
   valid_from_date_        := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_FROM_DATE', attr_));
   base_price_site_        := Client_SYS.Get_Item_Value('BASE_PRICE_SITE', attr_);
   discount_type_          := Client_SYS.Get_Item_Value('DISCOUNT_TYPE', attr_);
   discount_               := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('DISCOUNT', attr_));
   percentage_offset_      := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('PERCENTAGE_OFFSET', attr_));
   amount_offset_          := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('AMOUNT_OFFSET', attr_));
   sales_price_group_      := Client_SYS.Get_Item_Value('SALES_PRICE_GROUP', attr_);
   add_sales_prices_       := Client_SYS.Get_Item_Value('ADD_SALES_PRICES', attr_);
   add_rental_prices_      := Client_SYS.Get_Item_Value('ADD_RENTAL_PRICES', attr_);
   valid_to_date_          := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_TO_DATE', attr_));
   
   Add_Part_To_Price_List__(number_of_new_lines_,price_list_no_,catalog_no_, valid_from_date_, base_price_site_, discount_type_, discount_,
                            percentage_offset_, amount_offset_, sales_price_group_, add_sales_prices_, add_rental_prices_, valid_to_date_);

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (number_of_new_lines_ > 0) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NEW_LINES: :P1 Sales Part(s) added to the Price List.', NULL, TO_CHAR(number_of_new_lines_));
      ELSE
         Raise_Rec_Add_Info_Message___(info_);
      END IF;
      Transaction_SYS.Set_Progress_Info(info_);
   END IF;
END Start_Add_Part_To_Price_List__;


PROCEDURE Update_Assort_Prices_Batch__ (
   valid_from_date_         IN DATE,
   percentage_offset_       IN NUMBER,
   amount_offset_           IN NUMBER,
   price_list_attr_         IN VARCHAR2,
   sales_price_group_attr_  IN VARCHAR2,
   assortment_id_attr_      IN VARCHAR2,
   assortment_node_id_attr_ IN VARCHAR2,
   company_attr_            IN VARCHAR2,
   include_period_          IN VARCHAR2 )
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', valid_from_date_, attr_);
   Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', percentage_offset_, attr_);
   Client_SYS.Add_To_Attr('AMOUNT_OFFSET', amount_offset_, attr_);
   Client_SYS.Add_To_Attr('PRICE_LIST_ATTR', price_list_attr_, attr_);
   Client_SYS.Add_To_Attr('SALES_PRICE_GROUP_ATTR', sales_price_group_attr_, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_ID_ATTR', assortment_id_attr_, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_NODE_ID_ATTR', assortment_node_id_attr_, attr_);
   Client_SYS.Add_To_Attr('COMPANY_ATTR', company_attr_, attr_);
   Client_SYS.Add_To_Attr('INCLUDE_PERIOD', include_period_, attr_);

   Transaction_SYS.Deferred_Call('Customer_Order_Pricing_API.Start_Update_Assort_Prices__', attr_,
                                 Language_SYS.Translate_Constant(lu_name_, 'UPDATE_ASSORT_BASED: Update Assortment Node Based Price Lists'));
END Update_Assort_Prices_Batch__;


PROCEDURE Update_Assort_Prices__ (
   number_of_updates_       OUT NUMBER,
   valid_from_date_         IN  DATE,
   percentage_offset_       IN  NUMBER,
   amount_offset_           IN  NUMBER,
   price_list_attr_         IN  VARCHAR2,
   sales_price_group_attr_  IN  VARCHAR2,
   assortment_id_attr_      IN  VARCHAR2,
   assortment_node_id_attr_ IN  VARCHAR2,
   company_attr_            IN  VARCHAR2,
   include_period_          IN  VARCHAR2 )
IS
BEGIN
   Update_Assort_Prices___(number_of_updates_, valid_from_date_, percentage_offset_, amount_offset_, price_list_attr_, 
                           sales_price_group_attr_, assortment_id_attr_, assortment_node_id_attr_, company_attr_, include_period_);
END Update_Assort_Prices__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Sales_Part_Price_Info
--   Retrieve sale_unit_price, base_sale_unit_price, currency_rate and discount
--   for current contract, customer_no, currency_code, agreement_id, catalog_no,
--   buy_qty_due and price_list_no.
--   Retrieve sale_unit_price, base_sale_unit_price, currency_rate, discount
--   price source for current contract, customer_no, currency_code, agreement_id,
--   catalog_no, buy_qty_due , price_list_no and effectivity_date.
PROCEDURE Get_Sales_Part_Price_Info (
   sale_unit_price_          OUT NUMBER,
   unit_price_incl_tax_      OUT NUMBER,
   base_sale_unit_price_     OUT NUMBER,
   base_unit_price_incl_tax_ OUT NUMBER,
   currency_rate_            OUT NUMBER,
   discount_                 OUT NUMBER,
   contract_                 IN  VARCHAR2,
   customer_no_              IN  VARCHAR2,
   currency_code_            IN  VARCHAR2,
   agreement_id_             IN  VARCHAR2,
   catalog_no_               IN  VARCHAR2,
   buy_qty_due_              IN  NUMBER,
   price_list_no_            IN  VARCHAR2,
   use_price_incl_tax_       IN  VARCHAR2)
IS
   price_source_id_       VARCHAR2(25) := '';
   provisional_price_db_  VARCHAR2(20);
   net_price_fetched_     VARCHAR2(20) := db_false_;
   price_source_db_       VARCHAR2(2000) := NULL;
   discount_source_db_    VARCHAR2(2000) := NULL;
   discount_source_id_    VARCHAR2(25) := NULL;
   part_level_db_         VARCHAR2(30) := NULL;
   part_level_id_         VARCHAR2(200) := NULL;
   customer_level_db_     VARCHAR2(30) := NULL;
   customer_level_id_     VARCHAR2(200) := NULL;
BEGIN
   -- compatibility function for old interface
   Get_Sales_Part_Price_Info___(sale_unit_price_,   unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_,
                                currency_rate_,     discount_,            price_source_id_,      provisional_price_db_,
                                net_price_fetched_, price_source_db_,     discount_source_db_,   discount_source_id_,
                                part_level_db_,     part_level_id_,       customer_level_db_,    customer_level_id_,   
                                contract_,          customer_no_,         NULL,                  currency_code_,         
                                agreement_id_,      catalog_no_,          buy_qty_due_,          price_list_no_,
                                SYSDATE,            NULL,                 NULL,                  use_price_incl_tax_,
                                NULL);
END Get_Sales_Part_Price_Info;


-- Get_Sales_Part_Price_Info
--   Retrieve sale_unit_price, base_sale_unit_price, currency_rate and discount
--   for current contract, customer_no, currency_code, agreement_id, catalog_no,
--   buy_qty_due and price_list_no.
--   Retrieve sale_unit_price, base_sale_unit_price, currency_rate, discount
--   price source for current contract, customer_no, currency_code, agreement_id,
--   catalog_no, buy_qty_due , price_list_no and effectivity_date.
PROCEDURE Get_Sales_Part_Price_Info (
   sale_unit_price_          OUT NUMBER,
   unit_price_incl_tax_      OUT NUMBER,
   base_sale_unit_price_     OUT NUMBER,
   base_unit_price_incl_tax_ OUT NUMBER,
   currency_rate_            OUT NUMBER,
   discount_                 OUT NUMBER,
   price_source_             OUT VARCHAR2,
   price_source_id_          OUT VARCHAR2,
   contract_                 IN  VARCHAR2,
   customer_no_              IN  VARCHAR2,
   currency_code_            IN  VARCHAR2,
   agreement_id_             IN  VARCHAR2,
   catalog_no_               IN  VARCHAR2,
   buy_qty_due_              IN  NUMBER,
   price_list_no_            IN  VARCHAR2,
   effectivity_date_         IN  DATE,
   condition_code_           IN  VARCHAR2,
   use_price_incl_tax_       IN  VARCHAR2 )
IS
   provisional_price_db_  VARCHAR2(20);
   net_price_fetched_     VARCHAR2(20) := db_false_;
   price_source_db_       VARCHAR2(2000) := NULL;
   discount_source_db_    VARCHAR2(2000) := NULL;
   discount_source_id_    VARCHAR2(25) := NULL;
   part_level_db_         VARCHAR2(30) := NULL;
   part_level_id_         VARCHAR2(200) := NULL;
   customer_level_db_     VARCHAR2(30) := NULL;
   customer_level_id_     VARCHAR2(200) := NULL;
BEGIN
   Get_Sales_Part_Price_Info___(sale_unit_price_,   unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_,
                                currency_rate_,     discount_,            price_source_id_,      provisional_price_db_,
                                net_price_fetched_, price_source_db_,     discount_source_db_,   discount_source_id_, 
                                part_level_db_,     part_level_id_,       customer_level_db_,    customer_level_id_,    
                                contract_,          customer_no_,         NULL,                  currency_code_,
                                agreement_id_,      catalog_no_,          buy_qty_due_,          price_list_no_,
                                effectivity_date_,  condition_code_,      NULL,                  use_price_incl_tax_,
                                NULL);
   price_source_ := Pricing_Source_API.Decode(price_source_db_); 
END Get_Sales_Part_Price_Info;


-- Get_Sales_Part_Price_Info_Web
--   Copy of Get_Sales_Part_Price_Info that is needed because web application can not handle
--   two procedures with same name and different parameters.
PROCEDURE Get_Sales_Part_Price_Info_Web (
   sale_unit_price_          OUT NUMBER,
   unit_price_incl_tax_      OUT NUMBER,
   base_sale_unit_price_     OUT NUMBER,
   base_unit_price_incl_tax_ OUT NUMBER,
   currency_rate_            OUT NUMBER,
   discount_                 OUT NUMBER,
   price_source_             OUT VARCHAR2,
   contract_                 IN  VARCHAR2,
   customer_no_              IN  VARCHAR2,
   currency_code_            IN  VARCHAR2,
   agreement_id_             IN  VARCHAR2,
   catalog_no_               IN  VARCHAR2,
   buy_qty_due_              IN  NUMBER,
   price_list_no_            IN  VARCHAR2,
   effectivity_date_         IN  DATE,
   use_price_incl_tax_       IN  VARCHAR2 )
IS
   price_source_id_       VARCHAR2(25);
   provisional_price_db_  VARCHAR2(20);
   net_price_fetched_     VARCHAR2(20) := db_false_;
   price_source_db_       VARCHAR2(2000) := NULL;
   discount_source_db_    VARCHAR2(2000) := NULL;
   discount_source_id_    VARCHAR2(25) := NULL;
   part_level_db_         VARCHAR2(30) := NULL;
   part_level_id_         VARCHAR2(200) := NULL;
   customer_level_db_     VARCHAR2(30) := NULL;
   customer_level_id_     VARCHAR2(200) := NULL;
BEGIN
   Get_Sales_Part_Price_Info___(sale_unit_price_,   unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_, 
                                currency_rate_,     discount_,            price_source_id_,      provisional_price_db_,
                                net_price_fetched_, price_source_db_,     discount_source_db_,   discount_source_id_,
                                part_level_db_,     part_level_id_,       customer_level_db_,    customer_level_id_,
                                contract_,          customer_no_,         NULL,                  currency_code_,
                                agreement_id_,      catalog_no_,          buy_qty_due_,          price_list_no_,
                                effectivity_date_,  NULL,                 NULL,                  use_price_incl_tax_,
                                NULL);
   price_source_ := Pricing_Source_API.Decode(price_source_db_);
END Get_Sales_Part_Price_Info_Web;


-- Get_Order_Line_Price_Info
--   Retrieve sale_unit_price, base_sale_unit_price, currency_rate and discount
--   for current order_no, catalog_no, buy_qty_due and price_list_no.
--   Retrieve sale_unit_price, base_sale_unit_price, currency_rate, discount and price source
--   for current order_no, catalog_no, buy_qty_due,
--   price_list_no and effectivity_date.
--   OLD interface kept for support of components not included in Nice Surprise project
--   This method will fetch and calculate "old" price info from either Customer Order Line or Order Quotation Line for the Pricy Query client
PROCEDURE Get_Order_Line_Price_Info (
   sale_unit_price_      OUT NUMBER,
   base_sale_unit_price_ OUT NUMBER,
   currency_rate_        OUT NUMBER,
   discount_             OUT NUMBER,
   rebate_builder_db_    OUT VARCHAR2,
   order_no_             IN  VARCHAR2,
   catalog_no_           IN  VARCHAR2,
   buy_qty_due_          IN  NUMBER,
   price_list_no_        IN  VARCHAR2,
   condition_code_       IN  VARCHAR2 DEFAULT NULL )
IS
   price_source_           VARCHAR2(2000) := '';
   price_source_id_        VARCHAR2(25);
   contract_               VARCHAR2(5);
   provisional_price_db_   VARCHAR2(20);
   net_price_fetched_      VARCHAR2(20);
   part_level_db_          VARCHAR2(30);
   part_level_id_          VARCHAR2(200);
   customer_level_db_      VARCHAR2(30);
   customer_level_id_      VARCHAR2(200);
BEGIN
   contract_:= Customer_Order_API.Get_Contract(order_no_);
   -- compatibility function for old interface
   Get_Order_Line_Price_Info( sale_unit_price_,
                              sale_unit_price_,
                              base_sale_unit_price_ ,
                              base_sale_unit_price_,
                              currency_rate_ ,
                              discount_ ,
                              price_source_ ,
                              price_source_id_,
                              provisional_price_db_,
                              net_price_fetched_,
                              rebate_builder_db_,
                              part_level_db_,
                              part_level_id_,
                              customer_level_db_,
                              customer_level_id_,
                              order_no_ ,
                              catalog_no_ ,
                              buy_qty_due_ ,
                              price_list_no_,
                              Site_API.Get_Site_Date(contract_),
                              condition_code_,
                              'FALSE' );
END Get_Order_Line_Price_Info;


-- Get_Order_Line_Price_Info
--   Retrieve sale_unit_price, base_sale_unit_price, currency_rate and discount
--   for current order_no, catalog_no, buy_qty_due and price_list_no.
--   Retrieve sale_unit_price, base_sale_unit_price, currency_rate, discount and price source
--   for current order_no, catalog_no, buy_qty_due,
--   price_list_no and effectivity_date.
--   OLD interface kept for support of components not included in Nice Surprise project
--   This method will fetch and calculate "old" price info from either Customer Order Line or Order Quotation Line for the Pricy Query client
PROCEDURE Get_Order_Line_Price_Info (
   sale_unit_price_          OUT    NUMBER,
   unit_price_incl_tax_      OUT    NUMBER,
   base_sale_unit_price_     OUT    NUMBER,
   base_unit_price_incl_tax_ OUT    NUMBER,
   currency_rate_            OUT    NUMBER,
   discount_                 OUT    NUMBER,
   price_source_             OUT    VARCHAR2,
   price_source_id_          OUT    VARCHAR2,
   provisional_price_db_     OUT    VARCHAR2,
   net_price_fetched_        OUT    VARCHAR2,
   rebate_builder_db_        OUT    VARCHAR2,
   part_level_db_            OUT    VARCHAR2,
   part_level_id_            OUT    VARCHAR2,
   customer_level_db_        IN OUT VARCHAR2,
   customer_level_id_        IN OUT VARCHAR2,
   order_no_                 IN     VARCHAR2,
   catalog_no_               IN     VARCHAR2,
   buy_qty_due_              IN     NUMBER,
   price_list_no_            IN     VARCHAR2,
   effectivity_date_         IN     DATE,
   condition_code_           IN     VARCHAR2,
   use_price_incl_tax_       IN     VARCHAR2,
   rental_chargable_days_    IN     NUMBER   DEFAULT NULL )
IS
   contract_           VARCHAR2(5);
   customer_no_        CUSTOMER_ORDER_TAB.customer_no%TYPE;
   currency_code_      VARCHAR2(3);
   agreement_id_       VARCHAR2(10);
   customer_no_pay_    CUSTOMER_ORDER_TAB.customer_no_pay%TYPE;
   currency_rate_type_ VARCHAR2(10);
   price_source_db_    VARCHAR2(2000) := NULL;
   discount_source_db_ VARCHAR2(2000) := NULL;
   discount_source_id_ VARCHAR2(25) := NULL;

   CURSOR get_order_info IS
      SELECT contract, customer_no, customer_no_pay, currency_code, agreement_id, currency_rate_type
      FROM   customer_order_tab
      WHERE  order_no = order_no_;
BEGIN
   OPEN  get_order_info;
   FETCH get_order_info INTO contract_, customer_no_, customer_no_pay_, currency_code_, agreement_id_, currency_rate_type_;
   CLOSE get_order_info;
   Get_Sales_Part_Price_Info___(sale_unit_price_,   unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_,
                                currency_rate_,     discount_,            price_source_id_,      provisional_price_db_,
                                net_price_fetched_, price_source_db_,     discount_source_db_,   discount_source_id_,
                                part_level_db_,     part_level_id_,       customer_level_db_,    customer_level_id_,
                                contract_,          customer_no_,         customer_no_pay_,      currency_code_,
                                agreement_id_,      catalog_no_,          buy_qty_due_,          price_list_no_,
                                effectivity_date_,  condition_code_,      currency_rate_type_,   use_price_incl_tax_,
                                rental_chargable_days_);

   price_source_ := Pricing_Source_API.Decode(price_source_db_);
   IF (rental_chargable_days_ IS NULL) THEN
      Get_Source_Reb_Builder_Db___(rebate_builder_db_, price_source_db_, price_source_id_);
   ELSE
      rebate_builder_db_ := db_false_;
   END IF;

   -- If price source has rebate_builder_db_ FALSE returnnrd value is FALSE
   -- If price source has rebate_builder_db_ TRUE, the discount source must checked. 
   -- If price or discount have rebate_builder_db_ FALSE, returned value should be FALSE.
   IF (NVL(rebate_builder_db_, Database_Sys.string_null_) != db_false_) THEN
      Get_Source_Reb_Builder_Db___(rebate_builder_db_, discount_source_db_, discount_source_id_);
   END IF;

   IF (rebate_builder_db_ IS NULL) THEN
      rebate_builder_db_ := db_true_;
   END IF;
END Get_Order_Line_Price_Info;


-- Get_Order_Line_Price_Info_Web
--   Copy of GetOrderLinePriceInfo that is needed for usage from web application.
--   Retrieve sale_unit_price, base_sale_unit_price, currency_rate, discount and price source
--   for current order_no, catalog_no, buy_qty_due,
--   price_list_no and effectivity_date.
PROCEDURE Get_Order_Line_Price_Info_Web (
   sale_unit_price_          OUT NUMBER,
   unit_price_incl_tax_      OUT NUMBER,
   base_sale_unit_price_     OUT NUMBER,
   base_unit_price_incl_tax_ OUT NUMBER,
   currency_rate_            OUT NUMBER,
   discount_                 OUT NUMBER,
   price_source_             OUT VARCHAR2,
   price_source_id_          OUT VARCHAR2,
   provisional_price_db_     OUT VARCHAR2,
   order_no_                 IN  VARCHAR2,
   catalog_no_               IN  VARCHAR2,
   buy_qty_due_              IN  NUMBER,
   price_list_no_            IN  VARCHAR2,
   effectivity_date_         IN  DATE,
   condition_code_           IN  VARCHAR2 DEFAULT NULL,
   use_price_incl_tax_       IN  VARCHAR2 DEFAULT 'FALSE' )
IS
   contract_           VARCHAR2(5);
   customer_no_        CUSTOMER_ORDER_TAB.customer_no%TYPE;
   currency_code_      VARCHAR2(3);
   agreement_id_       VARCHAR2(10);
   customer_no_pay_    CUSTOMER_ORDER_TAB.customer_no_pay%TYPE;
   currency_rate_type_ VARCHAR2(10);
   net_price_fetched_  VARCHAR2(20) := db_false_;
   price_source_db_    VARCHAR2(2000) := NULL;
   discount_source_db_ VARCHAR2(2000) := NULL;
   discount_source_id_ VARCHAR2(25) := NULL;
   part_level_db_      VARCHAR2(30) := NULL;
   part_level_id_      VARCHAR2(200) := NULL;
   customer_level_db_  VARCHAR2(30) := NULL;
   customer_level_id_  VARCHAR2(200) := NULL;

   CURSOR get_order_info IS
      SELECT contract, customer_no, customer_no_pay, currency_code, agreement_id, currency_rate_type
      FROM   customer_order_tab
      WHERE  order_no = order_no_;
BEGIN
   OPEN  get_order_info;
   FETCH get_order_info INTO contract_, customer_no_, customer_no_pay_, currency_code_, agreement_id_, currency_rate_type_;
   CLOSE get_order_info;
   Get_Sales_Part_Price_Info___(sale_unit_price_,   unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_,
                                currency_rate_,     discount_,            price_source_id_,      provisional_price_db_,
                                net_price_fetched_, price_source_db_,     discount_source_db_,   discount_source_id_,     
                                part_level_db_,     part_level_id_,       customer_level_db_,    customer_level_id_,
                                contract_,          customer_no_,         customer_no_pay_,      currency_code_,
                                agreement_id_,      catalog_no_,          buy_qty_due_,          price_list_no_,
                                effectivity_date_,  condition_code_,      currency_rate_type_,   use_price_incl_tax_,
                                NULL);
   price_source_ := Pricing_Source_API.Decode(price_source_db_); 
END Get_Order_Line_Price_Info_Web;


-- Get_Valid_Price_List
--   Returns valid price_list_no for specified contract, catalog_no,
--   customer_no and currency_code. NULL if no valid price list was found.
FUNCTION Get_Valid_Price_List (
   contract_            IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   customer_no_         IN VARCHAR2,
   currency_code_       IN VARCHAR2,
   effectivity_date_    IN DATE DEFAULT NULL,
   sales_price_list_no_ IN VARCHAR2  DEFAULT NULL ) RETURN VARCHAR2
IS
   price_list_no_             VARCHAR2(10) := NULL;
   dummy_customer_level_db_   VARCHAR2(30);
   dummy_customer_level_id_   VARCHAR2(200);
BEGIN
   price_list_no_ := sales_price_list_no_;
   Sales_Price_List_API.Get_Valid_Price_List(dummy_customer_level_db_,
                                             dummy_customer_level_id_,
                                             price_list_no_,
                                             contract_,
                                             catalog_no_,
                                             customer_no_,
                                             currency_code_,
                                             effectivity_date_,
                                             NULL              );
   RETURN price_list_no_;
END Get_Valid_Price_List;


-- Get_Sales_Price_In_Currency
--   Calculates the sales_price and currency_rate for specified contract,
--   currency and base_price.
PROCEDURE Get_Sales_Price_In_Currency (
   sales_price_        OUT NUMBER,
   currency_rate_      OUT NUMBER,
   customer_no_        IN  VARCHAR2,
   contract_           IN  VARCHAR2,
   curr_code_          IN  VARCHAR2,
   base_price_         IN  NUMBER,
   currency_rate_type_ IN  VARCHAR2 DEFAULT NULL,
   date_               IN  DATE     DEFAULT NULL )
IS
   company_     VARCHAR2(20);
   curr_type_   VARCHAR2(10);
   conv_factor_ NUMBER;
   rate_        NUMBER;
   tmp_date_    DATE;
BEGIN
   company_   := Site_API.Get_Company(contract_);
   tmp_date_  := NVL(date_, Site_API.Get_Site_Date(contract_));
   curr_type_ := currency_rate_type_;
   Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, conv_factor_, rate_, company_, curr_code_,
                                                  tmp_date_, 'CUSTOMER', customer_no_);
   rate_      := rate_ / conv_factor_;

   IF (Company_Finance_API.Get_Currency_Code(company_) = curr_code_) THEN
      sales_price_ := base_price_;
   ELSE
      IF (rate_ = 0) THEN
         sales_price_ := 0;
      ELSE
         sales_price_ := base_price_ / rate_;
      END IF;
   END IF;
   currency_rate_ := rate_;
END Get_Sales_Price_In_Currency;


-- Get_Base_Price_In_Currency
--   Calculates the base_price and currency_rate for specified contract,
--   currency and sales_price.
PROCEDURE Get_Base_Price_In_Currency (
   base_price_         OUT NUMBER,
   currency_rate_      OUT NUMBER,
   customer_no_        IN  VARCHAR2,
   contract_           IN  VARCHAR2,
   curr_code_          IN  VARCHAR2,
   sales_price_        IN  NUMBER,
   currency_rate_type_ IN  VARCHAR2 DEFAULT NULL,
   date_               IN  DATE     DEFAULT NULL )
IS
   company_     VARCHAR2(20);
   curr_type_   VARCHAR2(10);
   conv_factor_ NUMBER;
   rate_        NUMBER;
   temp_date_   DATE;
BEGIN
   company_       := Site_API.Get_Company(contract_);
   temp_date_     := NVL(date_, Site_API.Get_Site_Date(contract_));
   curr_type_     := currency_rate_type_;
   Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, conv_factor_, rate_, company_, curr_code_,
                                                  temp_date_, 'CUSTOMER', customer_no_);
   rate_          := rate_ / conv_factor_;

   base_price_    := sales_price_ * rate_;
   currency_rate_ := rate_;
END Get_Base_Price_In_Currency;


-- Get_Base_Price_By_Rate
--   Recalculates the sales price to base price in currency.
--   Use the rate on the order specified as in-parameter.
--   Any other date could return another rate and another result.
--   Used when creating interim vouchers for Separate Sales Postings.
@UncheckedAccess
FUNCTION Get_Base_Price_By_Rate (
   currency_rate_ IN  NUMBER,
   conv_factor_   IN  NUMBER,
   sales_price_   IN  NUMBER ) RETURN NUMBER
IS
   base_price_ NUMBER;
   rate_       NUMBER;
BEGIN
   rate_       := currency_rate_ / conv_factor_;
   base_price_ := sales_price_ * rate_;
   RETURN base_price_;
END Get_Base_Price_By_Rate;



-- Get_Base_Price_From_Costing
--   Returns the base_price based on calculations from costing.
@UncheckedAccess
FUNCTION Get_Base_Price_From_Costing (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2,
   cost_set_   IN NUMBER ) RETURN NUMBER
IS
   base_price_           NUMBER;
   catalog_type_db_      VARCHAR2(4);
   part_no_              VARCHAR2(25);
   conv_factor_          NUMBER;
   inverted_conv_factor_ NUMBER;
   price_conv_factor_    NUMBER;
   price_                NUMBER;
   sales_cost_           NUMBER;

   CURSOR get_sales_part_info IS
      SELECT catalog_type, part_no, conv_factor, inverted_conv_factor, price_conv_factor
      FROM   sales_part_tab
      WHERE  contract = contract_
      AND    catalog_no = catalog_no_;
BEGIN
   OPEN  get_sales_part_info;
   FETCH get_sales_part_info INTO catalog_type_db_, part_no_, conv_factor_, inverted_conv_factor_, price_conv_factor_;
   CLOSE get_sales_part_info;

   IF (catalog_type_db_ = 'INV') THEN
      -- Check whether CostSet LU is installed.
      $IF (Component_Cost_SYS.INSTALLED) $THEN
         sales_cost_ := Cost_Int_API.Get_Sales_Cost_Per_Cost_Set( contract_, part_no_, cost_set_ );               
         price_      := NVL(sales_cost_, 0);
      $ELSE
         price_ := NVL(Inventory_Part_API.Get_Inventory_Value_By_Method(contract_, part_no_), 0);
      $END
      END IF;

   IF (price_ IS NULL) THEN
      base_price_ := 0;
   ELSE
      base_price_ := (price_ * conv_factor_/inverted_conv_factor_) / price_conv_factor_;
   END IF;
   RETURN base_price_;
END Get_Base_Price_From_Costing;



-- New_Default_Discount_Rec
--   Creates a new discount record.
PROCEDURE New_Default_Discount_Rec (
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   contract_               IN VARCHAR2,
   customer_no_            IN VARCHAR2,
   currency_code_          IN VARCHAR2,
   agreement_id_           IN VARCHAR2,
   catalog_no_             IN VARCHAR2,
   buy_qty_due_            IN NUMBER,
   price_list_no_          IN VARCHAR2,
   customer_level_db_      IN VARCHAR2,
   customer_level_id_      IN VARCHAR2,
   rental_chargeable_days_ IN NUMBER DEFAULT NULL,
   update_tax_             IN VARCHAR2 DEFAULT 'TRUE')
IS
   discount_type_             VARCHAR2(25);
   discount_                  NUMBER;
   discount_source_           VARCHAR2(40);
   discount_source_id_        VARCHAR2(25);
   discount_temp_             NUMBER;
   discount_method_db_        VARCHAR2(30);
   effectivity_date_          DATE;
   discount_flag_             BOOLEAN := FALSE;
   effective_min_quantity_    NUMBER;
   effective_valid_from_date_ DATE;
   effective_disc_price_uom_  SALES_PART_TAB.price_unit_meas%TYPE;
   discount_sub_source_       VARCHAR2(30);
   assortment_id_             VARCHAR2(50);
   assortment_node_id_        VARCHAR2(50);
   price_fetched_is_net_      VARCHAR2(20);
   temp_part_level_db_        VARCHAR2(30) := NULL;
   temp_part_level_id_        VARCHAR2(200) := NULL;
   temp_customer_level_db_    VARCHAR2(30) := customer_level_db_;
   temp_customer_level_id_    VARCHAR2(200) := customer_level_id_;
   check_new_method_          BOOLEAN := FALSE;
   discount_source_temp_      VARCHAR2(40);
   discount_sub_source_temp_  VARCHAR2(30);
BEGIN
   price_fetched_is_net_ := Customer_Order_Line_API.Get_Price_Source_Net_Price(order_no_, line_no_, rel_no_, line_item_no_);

   -- If price_fetched_is_net_ is TRUE no discounts should be there.
   IF (Fnd_Boolean_API.Encode(price_fetched_is_net_) = db_false_) THEN
      effectivity_date_ := Customer_Order_Line_API.Get_Price_Effectivity_Date(order_no_, line_no_, rel_no_, line_item_no_);

      IF (effectivity_date_ IS NULL) THEN
         effectivity_date_ := TRUNC(Site_API.Get_Site_Date(contract_));
      END IF;
      discount_method_db_ := Cust_Order_Discount_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Discount_Method(contract_));

      Get_Default_Discount_Rec(discount_type_,
                               discount_,
                               discount_source_,
                               discount_source_id_,
                               effective_min_quantity_,
                               effective_valid_from_date_,
                               assortment_id_,
                               assortment_node_id_,
                               discount_sub_source_,
                               temp_part_level_db_,
                               temp_part_level_id_,
                               temp_customer_level_db_,
                               temp_customer_level_id_,
                               order_no_,
                               line_no_,
                               rel_no_,
                               line_item_no_,
                               contract_,
                               customer_no_,
                               currency_code_,
                               agreement_id_,
                               catalog_no_,
                               buy_qty_due_,
                               price_list_no_,
                               rental_chargeable_days_ );

      discount_temp_ := discount_;
      discount_source_temp_ := discount_source_;
      discount_sub_source_temp_ := discount_sub_source_;

      IF (discount_temp_ IS NOT NULL) THEN
         discount_flag_ := TRUE;
         Create_New_Discount_Lines___ (order_no_,
                                       line_no_,
                                       rel_no_,
                                       line_item_no_,
                                       discount_source_id_,
                                       discount_source_,
                                       discount_type_,
                                       discount_,
                                       effective_min_quantity_,
                                       effective_valid_from_date_,
                                       catalog_no_,
                                       FALSE,
                                       assortment_id_,
                                       assortment_node_id_,
                                       discount_sub_source_,
                                       NULL,
                                       temp_part_level_db_,
                                       temp_part_level_id_,
                                       temp_customer_level_db_,
                                       temp_customer_level_id_);
         check_new_method_ := TRUE;
      END IF;
      IF (discount_method_db_ = 'SINGLE_DISCOUNT' AND discount_temp_ IS NULL) OR (discount_method_db_ = 'MULTIPLE_DISCOUNT') THEN
         -- Fetch additional discount.
         discount_ := 0;
         -- Passed 2 additional parameters discount_source_temp_ and discount_sub_source_temp_
         Get_Multiple_Discount___(discount_,
                                  discount_type_,
                                  discount_source_,
                                  discount_source_id_,
                                  effective_min_quantity_,
                                  effective_valid_from_date_,
                                  assortment_id_,
                                  assortment_node_id_,
                                  discount_sub_source_,
                                  effective_disc_price_uom_,
                                  temp_part_level_db_,
                                  temp_part_level_id_,
                                  temp_customer_level_db_,
                                  temp_customer_level_id_,
                                  contract_,
                                  catalog_no_,
                                  customer_no_,
                                  currency_code_,
                                  agreement_id_,
                                  buy_qty_due_,
                                  effectivity_date_,
                                  rental_chargeable_days_,
                                  discount_source_temp_,
                                  discount_sub_source_temp_);

         discount_temp_ := discount_;

         IF (discount_temp_ != 0 AND discount_temp_ IS NOT NULL) THEN
            Create_New_Discount_Lines___ (order_no_,
                                          line_no_,
                                          rel_no_,
                                          line_item_no_,
                                          discount_source_id_,
                                          discount_source_,
                                          discount_type_,
                                          discount_,
                                          effective_min_quantity_,
                                          effective_valid_from_date_,
                                          catalog_no_,
                                          TRUE,
                                          assortment_id_,
                                          assortment_node_id_,
                                          discount_sub_source_,
                                          effective_disc_price_uom_,
                                          temp_part_level_db_,
                                          temp_part_level_id_,
                                          temp_customer_level_db_,
                                          temp_customer_level_id_);
            check_new_method_ := TRUE;
         ELSIF (discount_temp_ = 0) AND (discount_flag_ =FALSE)  THEN
            Customer_Order_Line_API.Modify_Discount__(order_no_, line_no_, rel_no_, line_item_no_,0, update_tax_);
         END IF;
      END IF;
   END IF;
   IF check_new_method_ THEN
     Cust_Order_Line_Discount_API.Calc_Discount_Upd_Co_Line__(order_no_, line_no_, rel_no_, line_item_no_, update_tax_);
   END IF;
END New_Default_Discount_Rec;


-- Modify_Default_Discount_Rec
--   Modify a existing discount record.
PROCEDURE Modify_Default_Discount_Rec (
   order_no_                IN  VARCHAR2,
   line_no_                 IN  VARCHAR2,
   rel_no_                  IN  VARCHAR2,
   line_item_no_            IN  NUMBER,
   contract_                IN  VARCHAR2,
   customer_no_             IN  VARCHAR2,
   currency_code_           IN  VARCHAR2,
   agreement_id_            IN  VARCHAR2,
   catalog_no_              IN  VARCHAR2,
   buy_qty_due_             IN  NUMBER,
   price_list_no_           IN  VARCHAR2,
   customer_level_db_       IN  VARCHAR2,
   customer_level_id_       IN  VARCHAR2,
   rental_chargeable_days_  IN  NUMBER DEFAULT NULL)
IS
   new_discount_type_           VARCHAR2(25);
   new_discount_                NUMBER;
   new_discount_source_         VARCHAR2(40);
   discount_method_db_          VARCHAR2(30);
   effectivity_date_            DATE;
   new_discount_source_id_      VARCHAR2(25);
   effective_min_quantity_      NUMBER;
   effective_valid_from_date_   DATE;
   discount_sub_source_         VARCHAR2(30);
   effective_disc_price_uom_    SALES_PART_TAB.price_unit_meas%TYPE;
   assortment_id_               VARCHAR2(50);
   assortment_node_id_          VARCHAR2(50);
   price_fetched_is_net_        VARCHAR2(20);
   temp_part_level_db_          VARCHAR2(30) := NULL;
   temp_part_level_id_          VARCHAR2(200) := NULL;
   temp_customer_level_db_      VARCHAR2(30) := customer_level_db_;
   temp_customer_level_id_      VARCHAR2(200) := customer_level_id_;
   check_new_method_            BOOLEAN := FALSE;
   discount_source_temp_        VARCHAR2(40);
   discount_sub_source_temp_    VARCHAR2(30);

   CURSOR get_old_rec IS
      SELECT order_no, line_no, rel_no, line_item_no, discount_no
      FROM   cust_order_line_discount_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    discount_source NOT LIKE ('MANUAL');
BEGIN
   price_fetched_is_net_ := Customer_Order_Line_API.Get_Price_Source_Net_Price(order_no_, line_no_, rel_no_, line_item_no_);
   -- Moved code block out from IF condition to remove discount line which didn't create manually, before proceed to fetch dicounts.
   -- Remove all old discount lines that has not been created manually.
   FOR old_line_rec_ IN get_old_rec LOOP
      IF (old_line_rec_.order_no IS NOT NULL) THEN
         Cust_Order_Line_Discount_API.Remove_Discount_Row(old_line_rec_.order_no,
                                                          old_line_rec_.line_no,
                                                          old_line_rec_.rel_no,
                                                          old_line_rec_.line_item_no,
                                                          old_line_rec_.discount_no);
      END IF;
   END LOOP;
   -- If price_fetched_is_net_ is TRUE no discounts should be there.
   IF (Fnd_Boolean_API.Encode(price_fetched_is_net_) = db_false_) THEN
      effectivity_date_ := Customer_Order_Line_API.Get_Price_Effectivity_Date(order_no_, line_no_, rel_no_, line_item_no_);

      IF (effectivity_date_ IS NULL) THEN
         effectivity_date_ := TRUNC(Site_API.Get_Site_Date(contract_));
      END IF;

      discount_method_db_ := Cust_Order_Discount_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Discount_Method(contract_));
    
      -- Get new discount lines.
      Get_Default_Discount_Rec(new_discount_type_,
                               new_discount_,
                               new_discount_source_,
                               new_discount_source_id_,
                               effective_min_quantity_,
                               effective_valid_from_date_,
                               assortment_id_,
                               assortment_node_id_,
                               discount_sub_source_,
                               temp_part_level_db_,
                               temp_part_level_id_,
                               temp_customer_level_db_,
                               temp_customer_level_id_,
                               order_no_,
                               line_no_,
                               rel_no_,
                               line_item_no_,
                               contract_,
                               customer_no_,
                               currency_code_,
                               agreement_id_,
                               catalog_no_,
                               buy_qty_due_,
                               price_list_no_,
                               rental_chargeable_days_);
                               
      discount_source_temp_ := new_discount_source_;
      discount_sub_source_temp_ := discount_sub_source_;

      IF (new_discount_ IS NOT NULL) THEN
         Create_New_Discount_Lines___ (order_no_,
                                       line_no_,
                                       rel_no_,
                                       line_item_no_,
                                       new_discount_source_id_,
                                       new_discount_source_,
                                       new_discount_type_,
                                       new_discount_,
                                       effective_min_quantity_,
                                       effective_valid_from_date_,
                                       catalog_no_,
                                       TRUE,
                                       assortment_id_,
                                       assortment_node_id_,
                                       discount_sub_source_,
                                       NULL,
                                       temp_part_level_db_,
                                       temp_part_level_id_,
                                       temp_customer_level_db_,
                                       temp_customer_level_id_);
         check_new_method_ := TRUE;
      END IF;
      IF (discount_method_db_ = 'SINGLE_DISCOUNT' AND new_discount_ IS NULL) OR (discount_method_db_ = 'MULTIPLE_DISCOUNT') THEN
         -- Fetch additional discount if no discount was found or if multiple discount is used.
         new_discount_ := 0;
         -- Passed 2 additional parameters discount_source_temp_ and discount_sub_source_temp_.
         Get_Multiple_Discount___(new_discount_,
                                  new_discount_type_,
                                  new_discount_source_,
                                  new_discount_source_id_,
                                  effective_min_quantity_,
                                  effective_valid_from_date_,
                                  assortment_id_,
                                  assortment_node_id_,
                                  discount_sub_source_,
                                  effective_disc_price_uom_,
                                  temp_part_level_db_,
                                  temp_part_level_id_,
                                  temp_customer_level_db_,
                                  temp_customer_level_id_,
                                  contract_,
                                  catalog_no_,
                                  customer_no_,
                                  currency_code_,
                                  agreement_id_,
                                  buy_qty_due_,
                                  effectivity_date_,
                                  rental_chargeable_days_,
                                  discount_source_temp_,
                                  discount_sub_source_temp_);

         IF (new_discount_ != 0 AND new_discount_ IS NOT NULL) THEN
            Create_New_Discount_Lines___ (order_no_,
                                          line_no_,
                                          rel_no_,
                                          line_item_no_,
                                          new_discount_source_id_,
                                          new_discount_source_,
                                          new_discount_type_,
                                          new_discount_,
                                          effective_min_quantity_,
                                          effective_valid_from_date_,
                                          catalog_no_,
                                          TRUE,
                                          assortment_id_,
                                          assortment_node_id_,
                                          discount_sub_source_,
                                          effective_disc_price_uom_,
                                          temp_part_level_db_,
                                          temp_part_level_id_,
                                          temp_customer_level_db_,
                                          temp_customer_level_id_);
            check_new_method_ := TRUE;
         END IF;
      END IF;
   END IF;
   IF check_new_method_ THEN
      Cust_Order_Line_Discount_API.Calc_Discount_Upd_Co_Line__(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;
END Modify_Default_Discount_Rec;


-- Get_Default_Discount_Rec
--   Fetches discount source and discount type and discount.
PROCEDURE Get_Default_Discount_Rec (
   discount_type_          OUT    VARCHAR2,
   discount_               OUT    NUMBER,
   discount_source_        OUT    VARCHAR2,
   discount_source_id_     OUT    VARCHAR2,
   min_quantity_           OUT    NUMBER,
   valid_from_date_        OUT    DATE,
   assortment_id_          OUT    VARCHAR2,
   assortment_node_id_     OUT    VARCHAR2,
   discount_sub_source_    OUT    VARCHAR2,
   part_level_db_          OUT    VARCHAR2,
   part_level_id_          OUT    VARCHAR2,
   customer_level_db_      IN OUT VARCHAR2,
   customer_level_id_      IN OUT VARCHAR2,
   order_no_               IN     VARCHAR2,
   line_no_                IN     VARCHAR2,
   rel_no_                 IN     VARCHAR2,
   line_item_no_           IN     NUMBER,
   contract_               IN     VARCHAR2,
   customer_no_            IN     VARCHAR2,
   currency_code_          IN     VARCHAR2,
   agreement_id_           IN     VARCHAR2,
   catalog_no_             IN     VARCHAR2,
   buy_qty_due_            IN     NUMBER,
   price_list_no_          IN     VARCHAR2,
   rental_chargeable_days_ IN     NUMBER DEFAULT NULL)
IS
   price_found_                NUMBER;
   price_incl_tax_found_       NUMBER;
   discount_type_found_        VARCHAR2(25);
   discount_found_             NUMBER;
   price_list_price_           NUMBER;
   price_list_price_incl_tax_  NUMBER;
   price_list_discount_type_   VARCHAR2(25);
   price_list_discount_        NUMBER;
   found_discount              EXCEPTION;
   price_qty_due_              NUMBER;
   discount_source_found_      VARCHAR2(40);
   sales_part_rec_             Sales_Part_API.Public_Rec;
   hierarchy_id_               VARCHAR2(10);
   effectivity_date_           DATE;
   hierarchy_agreement_        VARCHAR2(10);
   prnt_cust_                  CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE;
   price_agreement_            VARCHAR2(10) := NULL;
   agreement_price_            NUMBER;
   agreement_price_incl_tax_   NUMBER;
   provisional_price_          AGREEMENT_SALES_PART_DEAL_TAB.provisional_price%TYPE;
   agreement_discount_type_    AGREEMENT_SALES_PART_DEAL_TAB.discount_type%TYPE;
   agreement_discount_         NUMBER;
   agreement_assort_id_        ASSORTMENT_STRUCTURE_TAB.assortment_id%TYPE;
   part_no_                    VARCHAR2(25);
   part_exists_                BOOLEAN;
   node_id_with_deal_price_    ASSORTMENT_NODE_TAB.assortment_node_id%TYPE := NULL;
   min_qty_with_deal_price_    AGREEMENT_ASSORTMENT_DEAL_TAB.min_quantity%TYPE := NULL;
   valid_frm_with_deal_price_  AGREEMENT_ASSORTMENT_DEAL_TAB.valid_from%TYPE := NULL;
   agreement_assort_deal_rec_  Agreement_Assortment_Deal_API.Public_Rec;
   temp_agreement_id_          AGREEMENT_ASSORTMENT_DEAL_TAB.agreement_id%TYPE := NULL;
   temp_assortment_id_         AGREEMENT_ASSORTMENT_DEAL_TAB.assortment_id%TYPE := NULL;
   price_um_                   SALES_PART_TAB.price_unit_meas%TYPE;
   is_net_price_               VARCHAR2(20);
   campaign_discount_type_     VARCHAR2(25);
   campaign_discount_          NUMBER;
   campaign_price_             NUMBER;
   campaign_price_incl_tax_    NUMBER;
   exclude_from_auto_pricing_  VARCHAR2(5) := 'N';
   temp_part_level_db_         VARCHAR2(30) := NULL;
   temp_part_level_id_         VARCHAR2(200) := NULL;
   temp_customer_level_db_     VARCHAR2(30) := NULL;
   temp_customer_level_id_     VARCHAR2(200) := NULL;
   co_linerec_                 Customer_Order_Line_API.Public_Rec;
   price_source_               VARCHAR2(25);
   ignore_if_low_price_found_  VARCHAR2(5) := db_false_;
   sales_price_type_db_        VARCHAR2(20);
BEGIN
   co_linerec_       := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   price_source_     := co_linerec_.price_source;
   effectivity_date_ := co_linerec_.price_effectivity_date;

   IF (effectivity_date_ IS NULL) THEN
      effectivity_date_ := TRUNC(Site_API.Get_Site_Date(contract_));
   END IF;
   -- When rental_chargeable_days_ is specified, it is considered rental prices.
   -- Discount should only be fetched from rental price list and sales part.
   IF (rental_chargeable_days_ IS NULL) THEN
      sales_price_type_db_ := Sales_Price_Type_API.DB_SALES_PRICES;
   ELSE
      sales_price_type_db_ := Sales_Price_Type_API.DB_RENTAL_PRICES;
   END IF;

   sales_part_rec_      := Sales_Part_API.Get(contract_, catalog_no_);
   hierarchy_id_        := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
   part_no_             := NVL(sales_part_rec_.part_no, catalog_no_);
   part_exists_         := Part_Catalog_API.Check_Part_Exists(part_no_);
   price_um_            := sales_part_rec_.price_unit_meas;
   price_qty_due_       := ABS(buy_qty_due_) * sales_part_rec_.price_conv_factor;
   -- Used in the Create_New_Discount_Lines___
   discount_sub_source_ := NULL;

   IF (price_source_ != 'CONDITION CODE') THEN
      -- if CO header has an agreement defined check whehter it's a manually added one with exclude from atopicing.
      IF (agreement_id_ IS NOT NULL) THEN
         exclude_from_auto_pricing_ := Customer_Agreement_API.Get_Use_Explicit_Db(agreement_id_);
      END IF;

      -- Discount from agreement.
      -- If CO header has an agreement the deal per part tab and deal per assortment tab of it gets the highest priority.
      -- First check if the agrement id passed in can be used for discount retrieval
      IF (exclude_from_auto_pricing_ = 'Y' AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         IF (Customer_Agreement_API.Is_Valid(agreement_id_, contract_, customer_no_, currency_code_, effectivity_date_) = 1) THEN
            Find_Price_On_Agr_Part_Deal___(agreement_price_, agreement_price_incl_tax_, provisional_price_, agreement_discount_type_, agreement_discount_,
                                           min_quantity_, valid_from_date_, is_net_price_, catalog_no_, agreement_id_, price_qty_due_, effectivity_date_);
            IF (agreement_price_ IS NOT NULL OR agreement_price_incl_tax_ IS NOT NULL) THEN
               price_agreement_ := agreement_id_;
            ELSE
               agreement_assort_id_ := Customer_Agreement_API.Get_Assortment_Id(agreement_id_);
               IF (agreement_assort_id_ IS NOT NULL AND part_exists_) THEN
                  Agreement_Assortment_Deal_API.Get_Deal_Price_Node(node_id_with_deal_price_,
                                                                    min_qty_with_deal_price_,
                                                                    valid_frm_with_deal_price_,
                                                                    agreement_assort_id_,
                                                                    part_no_,
                                                                    agreement_id_,
                                                                    price_um_,
                                                                    price_qty_due_,
                                                                    effectivity_date_);
                  IF (node_id_with_deal_price_ IS NOT NULL) THEN
                     price_agreement_ := agreement_id_;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;

      -- Fetch discount from campaign if agreement id CO header is for auto pricing
      IF (price_agreement_ IS NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         Campaign_API.Get_Campaign_Price_Info(campaign_price_,
                                              campaign_price_incl_tax_,
                                              campaign_discount_type_,
                                              campaign_discount_,
                                              discount_source_found_,
                                              discount_source_id_,
                                              temp_part_level_db_,
                                              temp_part_level_id_,
                                              temp_customer_level_db_,
                                              temp_customer_level_id_,
                                              is_net_price_,
                                              customer_no_,
                                              contract_,
                                              catalog_no_,
                                              currency_code_,
                                              price_um_,
                                              effectivity_date_);

         IF (discount_source_id_ IS NOT NULL) THEN
            ignore_if_low_price_found_ := Fnd_Boolean_API.Encode(Campaign_API.Get_Ignore_If_Low_Price_Found(discount_source_id_));
            IF (ignore_if_low_price_found_ = db_true_ AND price_source_ = 'CAMPAIGN') OR 
                (ignore_if_low_price_found_ = db_false_) THEN
               discount_type_found_ := campaign_discount_type_;
               discount_found_      := campaign_discount_;
               part_level_db_       := temp_part_level_db_;
               part_level_id_       := temp_part_level_id_;
               customer_level_db_   := temp_customer_level_db_;
               customer_level_id_   := temp_customer_level_id_;
               RAISE found_discount;
            END IF;
         END IF;
      END IF;

      -- If no agreement was passed in or no discount could be retrieved from that agreement then
      -- retrieve the default discount agreement
      IF (price_agreement_ IS NULL) THEN
          price_agreement_ := Customer_Agreement_API.Get_Price_Agreement_For_Part(customer_no_, contract_,
                                                                                  currency_code_, catalog_no_, effectivity_date_, price_qty_due_);
          Find_Price_On_Agr_Part_Deal___(agreement_price_, agreement_price_incl_tax_, provisional_price_, agreement_discount_type_, agreement_discount_,
                                         min_quantity_, valid_from_date_, is_net_price_, catalog_no_, price_agreement_, price_qty_due_, effectivity_date_);
      END IF;

      -- Primary discount is fetched from same place as where sales price is fetched.
      IF ((agreement_price_ IS NOT NULL OR agreement_price_incl_tax_ IS NOT NULL) AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         discount_type_found_   := agreement_discount_type_;
         discount_found_        := agreement_discount_;
         discount_source_found_ := 'AGREEMENT';
         discount_source_id_    := price_agreement_;
         discount_sub_source_   := 'AgreementDealPerPart';
         part_level_db_         := 'PART';
         part_level_id_         := catalog_no_;
         customer_level_db_     := 'CUSTOMER';
         customer_level_id_     := customer_no_;
         RAISE found_discount;
      END IF;

      -- Discount per part and agreement from customer hierarchy.
      -- If the deal per part records from customer's agreement(s) does/do not have maching discount line OR
      -- In case there is a customer agreement id on the CO header and its deal per assortment records does not have matching discount
      -- search through customer hierarchy
      IF (hierarchy_id_ IS NOT NULL AND price_agreement_ IS NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         -- Loop through the hierarchy and select price and discount from first customer that has valid agreement.
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
         WHILE (prnt_cust_ IS NOT NULL) LOOP
            -- Get first price agreement valid for the current catalog_no.
            hierarchy_agreement_ := Customer_Agreement_API.Get_Price_Agreement_For_Part (
                                                customer_no_       => prnt_cust_,
                                                contract_          => contract_,
                                                currency_          => currency_code_,
                                                catalog_no_        => catalog_no_,
                                                effectivity_date_  => effectivity_date_,
                                                quantity_	       => price_qty_due_ );

            IF (hierarchy_agreement_ IS NOT NULL) THEN
               Find_Price_On_Agr_Part_Deal___(price_found_, price_incl_tax_found_, provisional_price_, agreement_discount_type_, agreement_discount_,
                                              min_quantity_, valid_from_date_, is_net_price_, catalog_no_, hierarchy_agreement_, price_qty_due_, effectivity_date_);

                -- Primary discount is fetched from same place as where sales price is fetched.
               IF (price_found_ IS NOT NULL OR price_incl_tax_found_ IS NOT NULL) THEN
                  discount_type_found_   := agreement_discount_type_;
                  discount_found_        := agreement_discount_;
                  discount_source_found_ := 'AGREEMENT';
                  discount_source_id_    := hierarchy_agreement_;
                  discount_sub_source_   := 'AgreementDealPerPart';
                  part_level_db_         := 'PART';
                  part_level_id_         := catalog_no_;
                  customer_level_db_     := 'HIERARCHY';
                  customer_level_id_     := prnt_cust_;
                  RAISE found_discount;
               END IF;
            END IF;
            prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
         END LOOP;
      END IF;

      --Get price from best deal per Assortment record. This can be from a valid agreement of the customer or else from customer hierarchy.
      IF (node_id_with_deal_price_ IS NULL AND part_exists_) THEN
         -- Get the valid Agreement - Assortment combination first.
         Customer_Agreement_API.Get_Price_Agrm_For_Part_Assort(temp_assortment_id_,
                                                               temp_agreement_id_,
                                                               temp_customer_level_db_,
                                                               temp_customer_level_id_,
                                                               customer_no_,
                                                               contract_,
                                                               currency_code_,
                                                               effectivity_date_,
                                                               part_no_,
                                                               price_um_,
                                                               hierarchy_id_);

         -- Using Part step pricing logic for deal per Assortment, search for the best node in the Assortment Structure selected from above method call.
         Agreement_Assortment_Deal_API.Get_Deal_Price_Node(node_id_with_deal_price_,
                                                           min_qty_with_deal_price_,
                                                           valid_frm_with_deal_price_,
                                                           temp_assortment_id_,
                                                           part_no_,
                                                           temp_agreement_id_,
                                                           price_um_,
                                                           price_qty_due_,
                                                           effectivity_date_);
         IF (node_id_with_deal_price_ IS NOT NULL) THEN
            price_agreement_     := temp_agreement_id_;
            agreement_assort_id_ := temp_assortment_id_;
         END IF;
      END IF;

      -- IF a node_id_with_deal_price_ found a Assortment Node with a deal price has found.
      IF (node_id_with_deal_price_ IS NOT NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         agreement_assort_deal_rec_ := Agreement_Assortment_Deal_API.Get(price_agreement_, agreement_assort_id_, node_id_with_deal_price_, min_qty_with_deal_price_, valid_frm_with_deal_price_, price_um_);
         discount_type_found_       := agreement_assort_deal_rec_.discount_type;
         discount_found_            := agreement_assort_deal_rec_.discount;
         Trace_SYS.Field('Default discount searched until Customer Agreement with a deal per Assortment : ', price_agreement_);
         discount_source_found_     := 'AGREEMENT';
         discount_source_id_        := price_agreement_;
         assortment_id_             := agreement_assort_id_;
         assortment_node_id_        := node_id_with_deal_price_;
         min_quantity_              := min_qty_with_deal_price_;
         valid_from_date_           := valid_frm_with_deal_price_;
         discount_sub_source_       := 'AgreementDealPerAssortment';
         part_level_db_             := 'ASSORTMENT';
         part_level_id_             := agreement_assort_id_ || ' - ' || node_id_with_deal_price_;
         IF (exclude_from_auto_pricing_ = 'Y') THEN
            customer_level_db_ := 'CUSTOMER';
            customer_level_id_ := customer_no_;
         ELSE
            customer_level_db_ := temp_customer_level_db_;
            customer_level_id_ := temp_customer_level_id_;
         END IF;
         RAISE found_discount;
      END IF;

      -- Discount from price list
      -- If there exists sales and rental price lists, select the valid price list according to the sales_price_type.
      IF (price_list_no_ IS NOT NULL) THEN
         -- Pricelist used. Check if valid.
         IF ((Sales_Price_List_API.Is_Valid(price_list_no_, contract_, catalog_no_, effectivity_date_, sales_price_type_db_ ) = TRUE) 
             OR (Sales_Price_List_API.Is_Valid_Assort(price_list_no_, contract_, catalog_no_, effectivity_date_) = TRUE)) AND
            (Sales_Price_List_API.Get_Sales_Price_Group_Id(price_list_no_) = sales_part_rec_.sales_price_group_id) THEN
            -- Allows Service Managment to use negative amount.
            price_qty_due_ := ABS(buy_qty_due_) * sales_part_rec_.price_conv_factor;
            Sales_Price_List_API.Find_Price_On_Pricelist(price_list_price_, 
                                                         price_list_price_incl_tax_, 
                                                         price_list_discount_type_, 
                                                         price_list_discount_, 
                                                         part_level_db_, 
                                                         part_level_id_, 
                                                         price_list_no_, 
                                                         catalog_no_, 
                                                         price_qty_due_,
                                                         effectivity_date_, 
                                                         price_um_,
                                                         rental_chargeable_days_);

            price_found_          := price_list_price_;
            price_incl_tax_found_ := price_list_price_incl_tax_;

            -- Primary discount is fetched from same place as where sales price is fetched.
            IF (price_found_ IS NOT NULL) OR (price_incl_tax_found_ IS NOT NULL) THEN
               discount_type_found_   := price_list_discount_type_;
               discount_found_        := price_list_discount_;
               discount_source_found_ := 'PRICE LIST';
               discount_source_id_    := price_list_no_;
               discount_sub_source_   := 'PriceList';
               RAISE found_discount;
            END IF;
         END IF;
      END IF;
   END IF;
   RAISE found_discount;
EXCEPTION
   WHEN found_discount THEN
      discount_type_   := discount_type_found_;
      discount_        := discount_found_;
      discount_source_ := discount_source_found_;

      Trace_SYS.Field('Discount Source >> ', discount_source_);
      Trace_SYS.Field('Discount Part Level >> ', part_level_db_);
      Trace_SYS.Field('Discount Part Level Id >> ', part_level_id_);
      Trace_SYS.Field('Discount Customer Level >> ', customer_level_db_);
      Trace_SYS.Field('Discount Customer Level Id >> ', customer_level_id_);
END Get_Default_Discount_Rec;


-- Add_New_Sales_Parts
--   Add new sales part(s)
PROCEDURE Add_New_Sales_Parts (
   number_of_new_lines_    OUT NUMBER,
   base_price_site_attr_   IN  VARCHAR2,
   catalog_no_attr_        IN  VARCHAR2,
   sales_price_group_attr_ IN  VARCHAR2,
   sales_price_origin_     IN  VARCHAR2,
   sales_price_type_db_    IN  VARCHAR2,
   cost_set_               IN  VARCHAR2,
   percentage_offset_      IN  NUMBER,
   amount_offset_          IN  NUMBER )
IS
  counter_                    NUMBER := 0;
  costing_list_price_         NUMBER :=0;
  baseline_price_             NUMBER := 0;
  baseline_price_inc_tax_     NUMBER := 0;
  attr_                       VARCHAR2(2000);
  catalog_no_where_           VARCHAR2(2000);
  base_price_site_where_      VARCHAR2(2000);
  sales_price_group_where_    VARCHAR2(2000);
  stmt_                       VARCHAR2(32000);

  TYPE dynamic_cursor_type IS REF CURSOR;
  dynamic_cursor_             dynamic_cursor_type;

  list_price_                 SALES_PART_TAB.list_price%TYPE;
  list_price_incl_tax_        SALES_PART_TAB.list_price_incl_tax%TYPE;  
  rental_list_price_          SALES_PART_TAB.rental_list_price%TYPE;
  rental_list_price_incl_tax_ SALES_PART_TAB.Rental_List_Price_Incl_Tax%TYPE;
 
  contract_                   SALES_PART_TAB.contract%TYPE;
  sales_price_group_id_       SALES_PART_TAB.sales_price_group_id%TYPE;
  catalog_no_                 SALES_PART_TAB.catalog_no%TYPE;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', base_price_site_attr_, attr_);
   base_price_site_where_ := Report_SYS.Parse_Where_Expression(attr_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_attr_, attr_);
   catalog_no_where_ := Report_SYS.Parse_Where_Expression(attr_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SALES_PRICE_GROUP_ID', sales_price_group_attr_, attr_);
   sales_price_group_where_ := Report_SYS.Parse_Where_Expression(attr_);

   stmt_ := 'SELECT contract, catalog_no, sales_price_group_id, list_price, list_price_incl_tax, rental_list_price, rental_list_price_incl_tax
             FROM SALES_PART_TAB
             WHERE ';

   IF base_price_site_where_ IS NOT NULL THEN
      stmt_ := stmt_ || base_price_site_where_ || ' AND ';
   END IF;

   IF catalog_no_where_ IS NOT NULL THEN
      stmt_ := stmt_ || catalog_no_where_ || ' AND ';
   END IF;

   IF sales_price_group_where_ IS NOT NULL THEN
      stmt_ := stmt_ || sales_price_group_where_ || ' AND ';
   END IF;

   IF sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES THEN
      stmt_ := stmt_ || 'sales_type IN (''SALES'', ''SALES RENTAL'') AND ';
   ELSIF sales_price_type_db_ = Sales_Price_Type_API.DB_RENTAL_PRICES THEN
      stmt_ := stmt_ || 'sales_type IN (''RENTAL'', ''SALES RENTAL'') AND ';
   END IF;

   stmt_ := stmt_ || 'EXISTS (SELECT 1 FROM user_allowed_site_pub
                              WHERE contract = site)';
   @ApproveDynamicStatement(2012-09-05,JeeJlk)
   OPEN dynamic_cursor_ FOR stmt_;
   LOOP
      FETCH dynamic_cursor_ INTO contract_, catalog_no_, sales_price_group_id_, list_price_, list_price_incl_tax_, rental_list_price_, rental_list_price_incl_tax_;
      EXIT WHEN dynamic_cursor_%NOTFOUND;

         IF NOT(Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_price_group_id_)= 'UNIT BASED')
             AND (Sales_Part_Base_Price_API.Check_Exist(contract_,catalog_no_, sales_price_type_db_) != 1) THEN
            -- price fetches from costing if costing uses
            IF sales_price_origin_ = 'Costing' THEN
               costing_list_price_ := Get_Base_Price_From_Costing(contract_,catalog_no_,cost_set_);
               Sales_Part_Base_Price_API.New(contract_, catalog_no_, sales_price_type_db_, costing_list_price_, costing_list_price_, sales_price_origin_, cost_set_, percentage_offset_, amount_offset_);
               counter_            := counter_ + 1;
            ELSE
               IF (sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
                  baseline_price_         := list_price_;
                  baseline_price_inc_tax_ := list_price_incl_tax_;
               ELSIF (sales_price_type_db_ = Sales_Price_Type_API.DB_RENTAL_PRICES) THEN
                  baseline_price_         := rental_list_price_;
                  baseline_price_inc_tax_ := rental_list_price_incl_tax_;
               END IF;
               Sales_Part_Base_Price_API.New(contract_, catalog_no_, sales_price_type_db_, baseline_price_, baseline_price_inc_tax_, sales_price_origin_, cost_set_, percentage_offset_, amount_offset_);
               counter_ := counter_ + 1;
            END IF;
       END IF;
   END LOOP;
   CLOSE dynamic_cursor_;
   number_of_new_lines_ := counter_;
END Add_New_Sales_Parts;


-- Get_Quote_Line_Price_Info
--   Retrieve sale_unit_price, base_sale_unit_price, currency_rate and discount
--   for current quotation_no, catalog_no, buy_qty_due and price_list_no.
PROCEDURE Get_Quote_Line_Price_Info (
   sale_unit_price_          IN OUT NUMBER,
   unit_price_incl_tax_      IN OUT NUMBER,
   base_sale_unit_price_     OUT    NUMBER,
   base_unit_price_incl_tax_ OUT    NUMBER,
   currency_rate_            OUT    NUMBER,
   discount_                 OUT    NUMBER,
   price_source_             OUT    VARCHAR2,
   price_source_id_          OUT    VARCHAR2,
   net_price_fetched_        OUT    VARCHAR2,
   part_level_db_            OUT    VARCHAR2,
   part_level_id_            OUT    VARCHAR2,
   customer_level_db_        IN OUT VARCHAR2,
   customer_level_id_        IN OUT VARCHAR2,
   quotation_no_             IN     VARCHAR2,
   catalog_no_               IN     VARCHAR2,
   buy_qty_due_              IN     NUMBER,
   price_list_no_            IN     VARCHAR2,
   effectivity_date_         IN     DATE,
   condition_code_           IN     VARCHAR2,
   use_price_incl_tax_       IN     VARCHAR2,
   rental_chargable_days_    IN     NUMBER   DEFAULT NULL)
IS
   contract_              VARCHAR2(5);
   customer_no_           ORDER_QUOTATION_TAB.customer_no%TYPE;
   currency_code_         VARCHAR2(3);
   agreement_id_          VARCHAR2(10);
   provisional_price_db_  VARCHAR2(20);
   price_source_db_       VARCHAR2(2000) := NULL;
   discount_source_db_    VARCHAR2(2000) := NULL;
   discount_source_id_    VARCHAR2(25) := NULL;
   customer_no_pay_       ORDER_QUOTATION_TAB.customer_no_pay%TYPE;

   CURSOR get_quote_info IS
      SELECT contract, customer_no, customer_no_pay, currency_code, agreement_id
      FROM   order_quotation_tab
      WHERE  quotation_no = quotation_no_;
BEGIN
   OPEN  get_quote_info;
   FETCH get_quote_info INTO contract_, customer_no_, customer_no_pay_, currency_code_, agreement_id_;
   CLOSE get_quote_info;
   Get_Sales_Part_Price_Info___(sale_unit_price_,   unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_,
                                currency_rate_,     discount_,            price_source_id_,      provisional_price_db_,
                                net_price_fetched_, price_source_db_,     discount_source_db_,   discount_source_id_,
                                part_level_db_,     part_level_id_,       customer_level_db_,    customer_level_id_,
                                contract_,          customer_no_,         customer_no_pay_,      currency_code_,
                                agreement_id_,      catalog_no_,          buy_qty_due_,          price_list_no_,
                                effectivity_date_,  condition_code_,      NULL,                  use_price_incl_tax_,
                                rental_chargable_days_);
   price_source_ := Pricing_Source_API.Decode(price_source_db_); 
END Get_Quote_Line_Price_Info;


-- New_Default_Qdiscount_Rec
--   Creates a new discount record for quotation line.
PROCEDURE New_Default_Qdiscount_Rec (
   quotation_no_           IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   contract_               IN VARCHAR2,
   customer_no_            IN VARCHAR2,
   currency_code_          IN VARCHAR2,
   agreement_id_           IN VARCHAR2,
   catalog_no_             IN VARCHAR2,
   buy_qty_due_            IN NUMBER,
   price_list_no_          IN VARCHAR2,
   effectivity_date_       IN DATE DEFAULT NULL,
   customer_level_db_      IN VARCHAR2,
   customer_level_id_      IN VARCHAR2,
   rental_chargeable_days_ IN NUMBER DEFAULT NULL,
   update_tax_             IN VARCHAR2 DEFAULT 'TRUE')
IS
   discount_type_             VARCHAR2(25);
   discount_                  NUMBER;
   discount_source_           VARCHAR2(40);
   discount_method_db_        VARCHAR2(200);
   discount_temp_             NUMBER;
   date_                      DATE;
   discount_source_id_        VARCHAR2(25);
   effective_min_quantity_    NUMBER;
   effective_valid_from_date_ DATE;
   discount_sub_source_       VARCHAR2(30);
   effective_disc_price_uom_  SALES_PART_TAB.price_unit_meas%TYPE;
   assortment_id_             VARCHAR2(50);
   assortment_node_id_        VARCHAR2(50);
   price_fetched_is_net_      VARCHAR2(20);
   temp_part_level_db_        VARCHAR2(30) := NULL;
   temp_part_level_id_        VARCHAR2(200) := NULL;
   temp_customer_level_db_    VARCHAR2(30) := customer_level_db_;
   temp_customer_level_id_    VARCHAR2(200) := customer_level_id_;
   discount_source_temp_        VARCHAR2(40);
   discount_sub_source_temp_    VARCHAR2(30);
BEGIN
   price_fetched_is_net_ := Order_Quotation_Line_API.Get_Price_Source_Net_Price(quotation_no_, line_no_, rel_no_, line_item_no_);
   -- If price_fetched_is_net_ is TRUE no discounts should be there.
   IF (Fnd_Boolean_API.Encode(price_fetched_is_net_) = db_false_) THEN
      IF (effectivity_date_ IS NULL) THEN
         date_ := TRUNC(Site_API.Get_Site_Date(contract_));
      ELSE
         date_ := effectivity_date_;
      END IF;
      discount_method_db_ := Cust_Order_Discount_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Discount_Method(contract_));

      Get_Default_Qdiscount_Rec(discount_type_,
                                discount_,
                                discount_source_,
                                discount_source_id_,
                                effective_min_quantity_,
                                effective_valid_from_date_,
                                assortment_id_,
                                assortment_node_id_,
                                discount_sub_source_,
                                temp_part_level_db_,
                                temp_part_level_id_,
                                temp_customer_level_db_,
                                temp_customer_level_id_,
                                quotation_no_,
                                line_no_,
                                rel_no_,
                                line_item_no_,
                                contract_,
                                customer_no_,
                                currency_code_,
                                agreement_id_,
                                catalog_no_,
                                buy_qty_due_,
                                price_list_no_,
                                date_,
                                rental_chargeable_days_);

      discount_temp_ := discount_;
      discount_source_temp_ := discount_source_;
      discount_sub_source_temp_ := discount_sub_source_;

      IF (discount_temp_ IS NOT NULL) THEN
         Create_New_Qdiscount_Lines___ (quotation_no_,
                                        line_no_,
                                        rel_no_,
                                        line_item_no_,
                                        discount_source_id_,
                                        discount_source_,
                                        discount_type_,
                                        discount_,
                                        effective_min_quantity_,
                                        effective_valid_from_date_,
                                        catalog_no_,
                                        FALSE,
                                        assortment_id_,
                                        assortment_node_id_,
                                        discount_sub_source_,
                                        NULL,
                                        temp_part_level_db_,
                                        temp_part_level_id_,
                                        temp_customer_level_db_,
                                        temp_customer_level_id_,
                                        update_tax_);
      END IF;

      IF (discount_method_db_ = 'SINGLE_DISCOUNT' AND discount_temp_ IS NULL) OR (discount_method_db_ = 'MULTIPLE_DISCOUNT') THEN
         -- Fetch additional discount.
         discount_ := 0;
         -- Passed 2 additional parameters discount_source_temp_, discount_sub_source_temp_
         Get_Multiple_Discount___(discount_,
                                  discount_type_,
                                  discount_source_,
                                  discount_source_id_,
                                  effective_min_quantity_,
                                  effective_valid_from_date_,
                                  assortment_id_,
                                  assortment_node_id_,
                                  discount_sub_source_,
                                  effective_disc_price_uom_,
                                  temp_part_level_db_,
                                  temp_part_level_id_,
                                  temp_customer_level_db_,
                                  temp_customer_level_id_,
                                  contract_,
                                  catalog_no_,
                                  customer_no_,
                                  currency_code_,
                                  agreement_id_,
                                  buy_qty_due_,
                                  date_,
                                  rental_chargeable_days_,
                                  discount_source_temp_,
                                  discount_sub_source_temp_);

         discount_temp_ := discount_;

         IF (discount_temp_ != 0 AND discount_temp_ IS NOT NULL) THEN
            Create_New_Qdiscount_Lines___ (quotation_no_,
                                           line_no_,
                                           rel_no_,
                                           line_item_no_,
                                           discount_source_id_,
                                           discount_source_,
                                           discount_type_,
                                           discount_,
                                           effective_min_quantity_,
                                           effective_valid_from_date_,
                                           catalog_no_,
                                           TRUE,
                                           assortment_id_,
                                           assortment_node_id_,
                                           discount_sub_source_,
                                           effective_disc_price_uom_,
                                           temp_part_level_db_,
                                           temp_part_level_id_,
                                           temp_customer_level_db_,
                                           temp_customer_level_id_,
                                           update_tax_);
         END IF;
      END IF;
   END IF;
END New_Default_Qdiscount_Rec;


-- Modify_Default_Qdiscount_Rec
--   Modify a existing discount record for quotation line.
PROCEDURE Modify_Default_Qdiscount_Rec (
   quotation_no_         IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER,
   contract_             IN VARCHAR2,
   customer_no_          IN VARCHAR2,
   currency_code_        IN VARCHAR2,
   agreement_id_         IN VARCHAR2,
   catalog_no_           IN VARCHAR2,
   buy_qty_due_          IN NUMBER,
   price_list_no_        IN VARCHAR2,
   effectivity_date_     IN DATE DEFAULT NULL,
   customer_level_db_    IN VARCHAR2,
   customer_level_id_    IN VARCHAR2,
   rental_chargeable_days_  IN  NUMBER DEFAULT NULL,
   clear_manual_discount_   IN  VARCHAR2 DEFAULT 'FALSE')
IS
   new_discount_type_           VARCHAR2(25);
   new_discount_                NUMBER;
   new_discount_source_         VARCHAR2(40);
   discount_method_db_          VARCHAR2(30);
   date_                        DATE;
   new_discount_source_id_      VARCHAR2(25);
   effective_min_quantity_      NUMBER;
   effective_valid_from_date_   DATE;
   discount_sub_source_         VARCHAR2(30);
   effective_disc_price_uom_    SALES_PART_TAB.price_unit_meas%TYPE;
   assortment_id_               VARCHAR2(50);
   assortment_node_id_          VARCHAR2(50);
   price_fetched_is_net_        VARCHAR2(20);
   temp_part_level_db_          VARCHAR2(30) := NULL;
   temp_part_level_id_          VARCHAR2(200) := NULL;
   temp_customer_level_db_      VARCHAR2(30) := customer_level_db_;
   temp_customer_level_id_      VARCHAR2(200) := customer_level_id_;
   discount_source_temp_        VARCHAR2(40);
   discount_sub_source_temp_    VARCHAR2(30);

   CURSOR get_old_rec IS
      SELECT quotation_no, line_no, rel_no, line_item_no, discount_no
      FROM   order_quote_line_discount_tab
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND (discount_source NOT LIKE ('MANUAL') OR clear_manual_discount_ = 'TRUE');
BEGIN
   price_fetched_is_net_ := Order_Quotation_Line_API.Get_Price_Source_Net_Price(quotation_no_, 
                                                                                line_no_, 
                                                                                rel_no_, 
                                                                                line_item_no_);
   -- Moved code block out from IF condition to remove discount line which didn't create manually, before proceed to fetch dicounts.
   -- Remove all old discount lines that has not been created manually.
   FOR old_line_rec_ IN get_old_rec LOOP
      IF (old_line_rec_.quotation_no IS NOT NULL) THEN
         Order_Quote_Line_Discount_API.Remove_Discount_Row(old_line_rec_.quotation_no,
                                                           old_line_rec_.line_no,
                                                           old_line_rec_.rel_no,
                                                           old_line_rec_.line_item_no,
                                                           old_line_rec_.discount_no);
      END IF;
   END LOOP;
   -- If price_fetched_is_net_ is TRUE no discounts should be there.
   IF (Fnd_Boolean_API.Encode(price_fetched_is_net_) = db_false_) THEN
      IF (effectivity_date_ IS NULL) THEN
         date_ := TRUNC(Site_API.Get_Site_Date(contract_));
      ELSE
         date_ := effectivity_date_;
      END IF;

      discount_method_db_ := Cust_Order_Discount_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Discount_Method(contract_));
      
      -- Get new discount lines.
      Get_Default_Qdiscount_Rec(new_discount_type_,
                                new_discount_,
                                new_discount_source_,
                                new_discount_source_id_,
                                effective_min_quantity_,
                                effective_valid_from_date_,
                                assortment_id_,
                                assortment_node_id_,
                                discount_sub_source_,
                                temp_part_level_db_,
                                temp_part_level_id_,
                                temp_customer_level_db_,
                                temp_customer_level_id_,
                                quotation_no_,
                                line_no_,
                                rel_no_,
                                line_item_no_,
                                contract_,
                                customer_no_,
                                currency_code_,
                                agreement_id_,
                                catalog_no_,
                                buy_qty_due_,
                                price_list_no_,
                                date_,
                                rental_chargeable_days_);
      
      discount_source_temp_ := new_discount_source_;
      discount_sub_source_temp_ := discount_sub_source_;

      IF (new_discount_ IS NOT NULL) THEN
         Create_New_Qdiscount_Lines___ (quotation_no_,
                                        line_no_,
                                        rel_no_,
                                        line_item_no_,
                                        new_discount_source_id_,
                                        new_discount_source_,
                                        new_discount_type_,
                                        new_discount_,
                                        effective_min_quantity_,
                                        effective_valid_from_date_,
                                        catalog_no_,
                                        TRUE,
                                        assortment_id_,
                                        assortment_node_id_,
                                        discount_sub_source_,
                                        NULL,
                                        temp_part_level_db_,
                                        temp_part_level_id_,
                                        temp_customer_level_db_,
                                        temp_customer_level_id_);
      END IF;

      IF (discount_method_db_ = 'SINGLE_DISCOUNT' AND new_discount_ IS NULL) OR (discount_method_db_ = 'MULTIPLE_DISCOUNT') THEN
         -- Fetch additional discount if no discount was found or if multiple discount is used.
         new_discount_ := 0;
         -- Passed 2 additional parameters discount_source_temp_, discount_sub_source_temp_
         Get_Multiple_Discount___(new_discount_,
                                  new_discount_type_,
                                  new_discount_source_,
                                  new_discount_source_id_,
                                  effective_min_quantity_,
                                  effective_valid_from_date_,
                                  assortment_id_,
                                  assortment_node_id_,
                                  discount_sub_source_,
                                  effective_disc_price_uom_,
                                  temp_part_level_db_,
                                  temp_part_level_id_,
                                  temp_customer_level_db_,
                                  temp_customer_level_id_,
                                  contract_,
                                  catalog_no_,
                                  customer_no_,
                                  currency_code_,
                                  agreement_id_,
                                  buy_qty_due_,
                                  date_,
                                  rental_chargeable_days_,
                                  discount_source_temp_,
                                  discount_sub_source_temp_);

         IF (new_discount_ != 0 AND new_discount_ IS NOT NULL) THEN
            Create_New_Qdiscount_Lines___ (quotation_no_,
                                           line_no_,
                                           rel_no_,
                                           line_item_no_,
                                           new_discount_source_id_,
                                           new_discount_source_,
                                           new_discount_type_,
                                           new_discount_,
                                           effective_min_quantity_,
                                           effective_valid_from_date_,
                                           catalog_no_,
                                           TRUE,
                                           assortment_id_,
                                           assortment_node_id_,
                                           discount_sub_source_,
                                           effective_disc_price_uom_,
                                           temp_part_level_db_,
                                           temp_part_level_id_,
                                           temp_customer_level_db_,
                                           temp_customer_level_id_);
         END IF;
      END IF;
    END IF;
END Modify_Default_Qdiscount_Rec;


-- Get_Default_Qdiscount_Rec
--   Fetches discount source and discount type and discount for quotation line.
PROCEDURE Get_Default_Qdiscount_Rec (
   discount_type_          OUT    VARCHAR2,
   discount_               OUT    NUMBER,
   discount_source_        OUT    VARCHAR2,
   discount_source_id_     OUT    VARCHAR2,
   min_quantity_           OUT    NUMBER,
   valid_from_date_        OUT    DATE,
   assortment_id_          OUT    VARCHAR2,
   assortment_node_id_     OUT    VARCHAR2,
   discount_sub_source_    OUT    VARCHAR2,
   part_level_db_          OUT    VARCHAR2,
   part_level_id_          OUT    VARCHAR2,
   customer_level_db_      IN OUT VARCHAR2,
   customer_level_id_      IN OUT VARCHAR2,
   quotation_no_           IN     VARCHAR2,
   line_no_                IN     VARCHAR2,
   rel_no_                 IN     VARCHAR2,
   line_item_no_           IN     NUMBER,
   contract_               IN     VARCHAR2,
   customer_no_            IN     VARCHAR2,
   currency_code_          IN     VARCHAR2,
   agreement_id_           IN     VARCHAR2,
   catalog_no_             IN     VARCHAR2,
   buy_qty_due_            IN     NUMBER,
   price_list_no_          IN     VARCHAR2,
   effectivity_date_       IN     DATE   DEFAULT NULL,
   rental_chargeable_days_ IN     NUMBER DEFAULT NULL)
IS
   price_found_               NUMBER;
   price_incl_tax_found_      NUMBER;
   discount_type_found_       VARCHAR2(25);
   discount_found_            NUMBER;
   price_list_price_          NUMBER;
   price_list_price_incl_tax_ NUMBER;
   price_list_discount_type_  VARCHAR2(25);
   price_list_discount_       NUMBER;
   found_discount             EXCEPTION;
   price_qty_due_             NUMBER;
   discount_source_found_     VARCHAR2(40);
   sales_part_rec_            Sales_Part_API.Public_Rec;
   date_                      DATE;
   hierarchy_id_              VARCHAR2(10);
   hierarchy_agreement_       VARCHAR2(10);
   prnt_cust_                 CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE;
   price_agreement_           VARCHAR2(10) := NULL;
   agreement_price_           NUMBER;
   agreement_price_incl_tax_  NUMBER;
   provisional_price_         AGREEMENT_SALES_PART_DEAL_TAB.provisional_price%TYPE;
   agreement_discount_type_   AGREEMENT_SALES_PART_DEAL_TAB.discount_type%TYPE;
   agreement_discount_        NUMBER;
   effective_min_quantity_    NUMBER;
   effective_valid_from_date_ DATE;
   agreement_assort_id_       ASSORTMENT_STRUCTURE_TAB.assortment_id%TYPE;
   part_no_                   VARCHAR2(25);
   part_exists_               BOOLEAN;
   node_id_with_deal_price_   ASSORTMENT_NODE_TAB.assortment_node_id%TYPE := NULL;
   min_qty_with_deal_price_   AGREEMENT_ASSORTMENT_DEAL_TAB.min_quantity%TYPE := NULL;
   valid_frm_with_deal_price_ AGREEMENT_ASSORTMENT_DEAL_TAB.valid_from%TYPE := NULL;
   agreement_assort_deal_rec_ Agreement_Assortment_Deal_API.Public_Rec;
   temp_agreement_id_         AGREEMENT_ASSORTMENT_DEAL_TAB.agreement_id%TYPE := NULL;
   temp_assortment_id_        AGREEMENT_ASSORTMENT_DEAL_TAB.assortment_id%TYPE := NULL;
   price_um_                  SALES_PART_TAB.price_unit_meas%TYPE;
   is_net_price_              VARCHAR2(20);
   campaign_discount_type_    VARCHAR2(25);
   campaign_discount_         NUMBER;
   campaign_price_            NUMBER;
   campaign_price_incl_tax_   NUMBER;
   exclude_from_auto_pricing_ VARCHAR2(5) := 'N';
   temp_part_level_db_        VARCHAR2(30) := NULL;
   temp_part_level_id_        VARCHAR2(200) := NULL;
   temp_customer_level_db_    VARCHAR2(30) := NULL;
   temp_customer_level_id_    VARCHAR2(200) := NULL;
   price_source_              VARCHAR2(25);
   sales_price_type_db_       VARCHAR2(20);
   ignore_if_low_price_found_  VARCHAR2(5) := db_false_;

BEGIN
   -- no discount without quantity or if price breaks exist
   IF (NVL(buy_qty_due_, 0) = 0) OR (Order_Quotation_Grad_Price_API.Grad_Price_Exist(quotation_no_, line_no_, rel_no_, line_item_no_) = db_true_) THEN
      Trace_SYS.Message('No discount');
      RAISE found_discount;
   END IF;

   IF (effectivity_date_ IS NULL) THEN
      date_ := TRUNC(Site_API.Get_Site_Date(contract_));
   ELSE
      date_ := effectivity_date_;
   END IF;
   
   -- When rental_chargeable_days_ is specified, it is considered rental prices.
   -- Discount should only be fetched from rental price list and sales part.
   IF (rental_chargeable_days_ IS NULL) THEN
      sales_price_type_db_ := Sales_Price_Type_API.DB_SALES_PRICES;
   ELSE
      sales_price_type_db_ := Sales_Price_Type_API.DB_RENTAL_PRICES;
   END IF;

   price_source_        := Order_Quotation_Line_API.Get_Price_Source(quotation_no_, 
                                                                     line_no_, 
                                                                     rel_no_, 
                                                                     line_item_no_);
   sales_part_rec_      := Sales_Part_API.Get(contract_, catalog_no_);
   hierarchy_id_        := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
   part_no_             := sales_part_rec_.part_no;
   part_exists_         := Part_Catalog_API.Check_Part_Exists(part_no_);
   price_um_            := sales_part_rec_.price_unit_meas;
   price_qty_due_       := ABS(buy_qty_due_) * sales_part_rec_.price_conv_factor;
   -- Used in the Create_New_Discount_Lines___
   discount_sub_source_ := NULL;

   IF (Pricing_Source_API.Encode(price_source_) != 'CONDITION CODE') THEN
      IF (agreement_id_ IS NOT NULL) THEN
         exclude_from_auto_pricing_ := Customer_Agreement_API.Get_Use_Explicit_Db(agreement_id_);
      END IF;

      -- Discount from agreement.
      -- If OQ header has an agreement the deal per part tab and deal per assortment tab of it gets the highest priority.
      -- First check if the agrement id passed in can be used for discount retrieval
      IF (exclude_from_auto_pricing_ = 'Y' AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         IF (Customer_Agreement_API.Is_Valid(agreement_id_, contract_, customer_no_, currency_code_, effectivity_date_) = 1) THEN
            Find_Price_On_Agr_Part_Deal___(agreement_price_, agreement_price_incl_tax_, provisional_price_, agreement_discount_type_, agreement_discount_, effective_min_quantity_, effective_valid_from_date_, is_net_price_, catalog_no_, agreement_id_, price_qty_due_, date_);

            IF (agreement_price_ IS NOT NULL OR agreement_price_incl_tax_ IS NOT NULL) THEN
               price_agreement_ := agreement_id_;
            ELSE
               agreement_assort_id_ := Customer_Agreement_API.Get_Assortment_Id(agreement_id_);
               IF (agreement_assort_id_ IS NOT NULL AND part_exists_) THEN
                  Agreement_Assortment_Deal_API.Get_Deal_Price_Node(node_id_with_deal_price_,
                                                                    min_qty_with_deal_price_,
                                                                    valid_frm_with_deal_price_,
                                                                    agreement_assort_id_,
                                                                    part_no_,
                                                                    agreement_id_,
                                                                    price_um_,
                                                                    price_qty_due_,
                                                                    effectivity_date_);
                  IF (node_id_with_deal_price_ IS NOT NULL) THEN
                     price_agreement_ := agreement_id_;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;

      IF (price_agreement_ IS NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         Campaign_API.Get_Campaign_Price_Info(campaign_price_,
                                              campaign_price_incl_tax_,
                                              campaign_discount_type_,
                                              campaign_discount_,
                                              discount_source_found_,
                                              discount_source_id_,
                                              temp_part_level_db_,
                                              temp_part_level_id_,
                                              temp_customer_level_db_,
                                              temp_customer_level_id_,
                                              is_net_price_,
                                              customer_no_,
                                              contract_,
                                              catalog_no_,
                                              currency_code_,
                                              price_um_,
                                              effectivity_date_); 

         IF (discount_source_id_ IS NOT NULL) THEN
            ignore_if_low_price_found_ := Fnd_Boolean_API.Encode(Campaign_API.Get_Ignore_If_Low_Price_Found(discount_source_id_));
            IF (ignore_if_low_price_found_ = db_true_ AND price_source_ = 'CAMPAIGN') OR (ignore_if_low_price_found_ = db_false_) THEN
               discount_type_found_    := campaign_discount_type_;
               discount_found_         := campaign_discount_;
               part_level_db_          := temp_part_level_db_;
               part_level_id_          := temp_part_level_id_;
               customer_level_db_      := temp_customer_level_db_;
               customer_level_id_      := temp_customer_level_id_;
            END IF;
            RAISE found_discount;
         END IF;
      END IF;

      -- If no agreement was passed in or no discount could be retrieved from that agreement then
      -- retrieve the default discount agreement
      IF (price_agreement_ IS NULL) THEN
          price_agreement_ := Customer_Agreement_API.Get_Price_Agreement_For_Part(customer_no_, contract_,
                                                                                  currency_code_, catalog_no_, effectivity_date_, price_qty_due_);
         Find_Price_On_Agr_Part_Deal___(agreement_price_, agreement_price_incl_tax_, provisional_price_, agreement_discount_type_, agreement_discount_, effective_min_quantity_, effective_valid_from_date_, is_net_price_, catalog_no_, price_agreement_, price_qty_due_, date_);
      END IF;

      -- Primary discount is fetched from same place as where sales price is fetched.
      IF (agreement_price_ IS NOT NULL OR agreement_price_incl_tax_ IS NOT NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         discount_type_found_   := agreement_discount_type_;
         discount_found_        := agreement_discount_;
         discount_source_found_ := 'AGREEMENT';
         discount_source_id_    := price_agreement_;
         discount_sub_source_   := 'AgreementDealPerPart';
         part_level_db_         := 'PART';
         part_level_id_         := catalog_no_;
         customer_level_db_     := 'CUSTOMER';
         customer_level_id_     := customer_no_;
         min_quantity_          := effective_min_quantity_;
         valid_from_date_       := effective_valid_from_date_;
         RAISE found_discount;
      END IF;

      -- If the deal per part or deal per assortment records from customer's agreement(s) does/do not have maching discount line
      -- search through customer hierarchy
      -- Discount per part and agreement from customer hierarchy.
      IF (hierarchy_id_ IS NOT NULL AND price_agreement_ IS NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         -- Loop through the hierarchy and select price and discount from first customer that has valid agreement.
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
         WHILE (prnt_cust_ IS NOT NULL) LOOP
            -- Get first price agreement valid for the current catalog_no.
            hierarchy_agreement_ := Customer_Agreement_API.Get_Price_Agreement_For_Part(
                                                   customer_no_      => prnt_cust_,
                                                   contract_         => contract_,
                                                   currency_         => currency_code_,
                                                   catalog_no_       => catalog_no_,
                                                   effectivity_date_ => date_,
                                                   quantity_	       => price_qty_due_);

            IF (hierarchy_agreement_ IS NOT NULL) THEN
               Find_Price_On_Agr_Part_Deal___(price_found_, price_incl_tax_found_, provisional_price_, agreement_discount_type_, agreement_discount_,
                                              effective_min_quantity_, effective_valid_from_date_, is_net_price_, catalog_no_, hierarchy_agreement_, price_qty_due_, date_);

                -- Primary discount is fetched from same place as where sales price is fetched.
               IF (price_found_ IS NOT NULL OR price_incl_tax_found_ IS NOT NULL) THEN
                  discount_type_found_   := agreement_discount_type_;
                  discount_found_        := agreement_discount_;
                  discount_source_found_ := 'AGREEMENT';
                  discount_source_id_    := hierarchy_agreement_;
                  discount_sub_source_   := 'AgreementDealPerPart';
                  part_level_db_         := 'PART';
                  part_level_id_         := catalog_no_;
                  customer_level_db_     := 'HIERARCHY';
                  customer_level_id_     := prnt_cust_;
                  min_quantity_          := effective_min_quantity_;
                  valid_from_date_       := effective_valid_from_date_;
                  RAISE found_discount;
               END IF;
             END IF;
             prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
         END LOOP;
      END IF;

      --Get price from best deal per Assortment record. This can be from a valid agreement of the customer or else from customer hierarchy.
      IF (node_id_with_deal_price_ IS NULL AND part_exists_) THEN
         -- Get the valid Agreement - Assortment combination first.
         Customer_Agreement_API.Get_Price_Agrm_For_Part_Assort(temp_assortment_id_,
                                                               temp_agreement_id_,
                                                               temp_customer_level_db_,
                                                               temp_customer_level_id_,
                                                               customer_no_,
                                                               contract_,
                                                               currency_code_,
                                                               effectivity_date_,
                                                               part_no_,
                                                               price_um_,
                                                               hierarchy_id_);

         -- Using Part step pricing logic for deal per Assortment, search for the best node in the Assortment Structure selected from above method call.
         Agreement_Assortment_Deal_API.Get_Deal_Price_Node(node_id_with_deal_price_,
                                                             min_qty_with_deal_price_,
                                                             valid_frm_with_deal_price_,
                                                             temp_assortment_id_,
                                                             part_no_,
                                                             temp_agreement_id_,
                                                             price_um_,
                                                             price_qty_due_,
                                                             effectivity_date_);
         IF (node_id_with_deal_price_ IS NOT NULL) THEN
             price_agreement_ := temp_agreement_id_;
             agreement_assort_id_ := temp_assortment_id_;
         END IF;
      END IF;

      -- IF a node_id_with_deal_price_ found a Assortment Node with a deal price has found.
      IF (node_id_with_deal_price_ IS NOT NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         agreement_assort_deal_rec_ := Agreement_Assortment_Deal_API.Get(price_agreement_, agreement_assort_id_, node_id_with_deal_price_, min_qty_with_deal_price_, valid_frm_with_deal_price_, price_um_);
         discount_type_found_       := agreement_assort_deal_rec_.discount_type;
         discount_found_            := agreement_assort_deal_rec_.discount;
         Trace_SYS.Field('Default discount searched until Customer Agreement with a deal per Assortment : ', price_agreement_);
         discount_source_found_     := 'AGREEMENT';
         discount_source_id_        := price_agreement_;
         assortment_id_             := agreement_assort_id_;
         assortment_node_id_        := node_id_with_deal_price_;
         min_quantity_              := min_qty_with_deal_price_;
         valid_from_date_           := valid_frm_with_deal_price_;
         discount_sub_source_       := 'AgreementDealPerAssortment';
         part_level_db_             := 'ASSORTMENT';
         part_level_id_             := agreement_assort_id_ || ' - ' || node_id_with_deal_price_;
         IF (exclude_from_auto_pricing_ = 'Y') THEN
            customer_level_db_ := 'CUSTOMER';
            customer_level_id_ := customer_no_;
         ELSE
            customer_level_db_ := temp_customer_level_db_;
            customer_level_id_ := temp_customer_level_id_;
         END IF;
         RAISE found_discount;
      END IF;

      -- Discount from price list
      IF (price_list_no_ IS NOT NULL) THEN
         -- Pricelist used. Check if valid.
         IF ((Sales_Price_List_API.Is_Valid(price_list_no_, contract_, catalog_no_, date_, sales_price_type_db_) = TRUE) 
             OR (Sales_Price_List_API.Is_Valid_Assort(price_list_no_, contract_, catalog_no_, date_) = TRUE)) AND
            (Sales_Price_List_API.Get_Sales_Price_Group_Id(price_list_no_) = sales_part_rec_.sales_price_group_id) THEN

            -- Allows Service Managment to use negative amount.
            price_qty_due_        := ABS(buy_qty_due_) * sales_part_rec_.price_conv_factor;
            Sales_Price_List_API.Find_Price_On_Pricelist(price_list_price_, 
                                                         price_list_price_incl_tax_, 
                                                         price_list_discount_type_, 
                                                         price_list_discount_, 
                                                         part_level_db_, 
                                                         part_level_id_, 
                                                         price_list_no_, 
                                                         catalog_no_, 
                                                         price_qty_due_, 
                                                         date_, 
                                                         price_um_,
                                                         rental_chargeable_days_);
            price_found_          := price_list_price_;
            price_incl_tax_found_ := price_list_price_incl_tax_;

            -- Primary discount is fetched from same place as where sales price is fetched.
            IF (price_found_ IS NOT NULL) OR (price_incl_tax_found_ IS NOT NULL) THEN
               discount_type_found_   := price_list_discount_type_;
               discount_found_        := price_list_discount_;
               discount_source_found_ := 'PRICE LIST';
               discount_source_id_    := price_list_no_;
               discount_sub_source_   := 'PriceList';
               RAISE found_discount;
            END IF;
         END IF;
      END IF;
   END IF;
   RAISE found_discount;
EXCEPTION
   WHEN found_discount THEN
      discount_type_   := discount_type_found_;
      discount_        := discount_found_;
      discount_source_ := discount_source_found_;

      Trace_SYS.Field('Discount Source >> ', discount_source_);
      Trace_SYS.Field('Discount Part Level >> ', part_level_db_);
      Trace_SYS.Field('Discount Part Level Id >> ', part_level_id_);
      Trace_SYS.Field('Discount Customer Level >> ', customer_level_db_);
      Trace_SYS.Field('Discount Customer Level Id >> ', customer_level_id_);
END Get_Default_Qdiscount_Rec;


-- Get_Substitute_Part_Price_Info
--   Gets valid price list and returns price info for a line with a substitute
--   sales part for a customer order line.
PROCEDURE Get_Substitute_Part_Price_Info (
   sale_unit_price_          OUT NUMBER,
   unit_price_incl_tax_      OUT NUMBER,
   base_sale_unit_price_     OUT NUMBER,
   base_unit_price_incl_tax_ OUT NUMBER,
   currency_rate_            OUT NUMBER,
   discount_                 OUT NUMBER,
   price_source_             OUT VARCHAR2,
   price_source_id_          OUT VARCHAR2,
   order_no_                 IN  VARCHAR2,
   catalog_no_               IN  VARCHAR2,
   buy_qty_due_              IN  NUMBER,
   effectivity_date_         IN  DATE,
   use_price_incl_tax_       IN  VARCHAR2)
IS
   price_list_no_         VARCHAR2(10);
   contract_              VARCHAR2(5);
   customer_no_           CUSTOMER_ORDER_TAB.customer_no%TYPE;
   currency_code_         VARCHAR2(3);
   agreement_id_          VARCHAR2(10);
   provisional_price_db_  VARCHAR2(20);
   customer_no_pay_       CUSTOMER_ORDER_TAB.customer_no_pay%TYPE;
   net_price_fetched_     VARCHAR2(20) := db_false_;
   price_source_db_       VARCHAR2(2000) := NULL;
   discount_source_db_    VARCHAR2(2000) := NULL;
   discount_source_id_    VARCHAR2(25) := NULL;
   part_level_db_         VARCHAR2(30) := NULL;
   part_level_id_         VARCHAR2(200) := NULL;
   customer_level_db_     VARCHAR2(30) := NULL;
   customer_level_id_     VARCHAR2(200) := NULL;

   CURSOR get_order_info IS
      SELECT contract, customer_no, customer_no_pay, currency_code, agreement_id
      FROM   customer_order_tab
      WHERE  order_no = order_no_;
BEGIN
   OPEN get_order_info;
   FETCH get_order_info INTO contract_, customer_no_, customer_no_pay_, currency_code_, agreement_id_;
   CLOSE get_order_info;

   Sales_Price_List_API.Get_Valid_Price_List(customer_level_db_, customer_level_id_, price_list_no_, contract_, 
                                             catalog_no_, customer_no_, currency_code_, effectivity_date_, NULL);

   Get_Sales_Part_Price_Info___(sale_unit_price_,   unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_,
                                currency_rate_,     discount_,            price_source_id_,      provisional_price_db_,
                                net_price_fetched_, price_source_db_,     discount_source_db_,   discount_source_id_,
                                part_level_db_,     part_level_id_,       customer_level_db_,    customer_level_id_,
                                contract_,          customer_no_,         customer_no_pay_,      currency_code_,
                                agreement_id_,      catalog_no_,          buy_qty_due_,          price_list_no_,
                                effectivity_date_,  NULL,                 NULL,                  use_price_incl_tax_,
                                NULL);
   price_source_ := Pricing_Source_API.Decode(price_source_db_); 
END Get_Substitute_Part_Price_Info;


-- Get_Qsubstitute_Price_Info
--   Gets valid price list and returns price info for a line with a substitute
--   sales part for a sales quotation line.
PROCEDURE Get_Qsubstitute_Price_Info (
   sale_unit_price_          OUT NUMBER,
   unit_price_incl_tax_      OUT NUMBER,
   base_sale_unit_price_     OUT NUMBER,
   base_unit_price_incl_tax_ OUT NUMBER,
   currency_rate_            OUT NUMBER,
   discount_                 OUT NUMBER,
   price_source_             OUT VARCHAR2,
   price_source_id_          OUT VARCHAR2,
   quotation_no_             IN  VARCHAR2,
   catalog_no_               IN  VARCHAR2,
   buy_qty_due_              IN  NUMBER,
   effectivity_date_         IN  DATE,
   use_price_incl_tax_       IN  VARCHAR2)
IS
   price_list_no_         VARCHAR2(10);
   contract_              VARCHAR2(5);
   customer_no_           ORDER_QUOTATION_TAB.customer_no%TYPE;
   currency_code_         VARCHAR2(3);
   agreement_id_          VARCHAR2(10);
   provisional_price_db_  VARCHAR2(20);
   customer_no_pay_       ORDER_QUOTATION_TAB.customer_no_pay%TYPE;
   net_price_fetched_     VARCHAR2(20) := db_false_;
   price_source_db_       VARCHAR2(2000) := NULL;
   discount_source_db_    VARCHAR2(2000) := NULL;
   discount_source_id_    VARCHAR2(25) := NULL;
   part_level_db_         VARCHAR2(30) := NULL;
   part_level_id_         VARCHAR2(200) := NULL;
   customer_level_db_     VARCHAR2(30) := NULL;
   customer_level_id_     VARCHAR2(200) := NULL;

   CURSOR get_quote_info IS
      SELECT contract, customer_no, customer_no_pay, currency_code, agreement_id
      FROM   order_quotation_tab
      WHERE  quotation_no = quotation_no_;
BEGIN
   OPEN  get_quote_info;
   FETCH get_quote_info INTO contract_, customer_no_, customer_no_pay_, currency_code_, agreement_id_;
   CLOSE get_quote_info;

   Sales_Price_List_API.Get_Valid_Price_List(customer_level_db_, customer_level_id_, price_list_no_, contract_, 
                                             catalog_no_, customer_no_, currency_code_, effectivity_date_, NULL);

   Get_Sales_Part_Price_Info___(sale_unit_price_,   unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_,
                                currency_rate_,     discount_,            price_source_id_,      provisional_price_db_,
                                net_price_fetched_, price_source_db_,     discount_source_db_,   discount_source_id_,
                                part_level_db_,     part_level_id_,       customer_level_db_,    customer_level_id_,
                                contract_,          customer_no_,         customer_no_pay_,      currency_code_,
                                agreement_id_,      catalog_no_,          buy_qty_due_,          price_list_no_,
                                effectivity_date_,  NULL,                 NULL,                  use_price_incl_tax_,
                                NULL);
   price_source_ := Pricing_Source_API.Decode(price_source_db_); 
END Get_Qsubstitute_Price_Info;


-- Replace_Default_Discount_Rec
--   Replaces the default discount record(s) created for a new order line with
--   a new record with the specified discount percentage.
PROCEDURE Replace_Default_Discount_Rec (
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   discount_           IN NUMBER,
   create_partial_sum_ IN VARCHAR2,
   copy_discount_      IN VARCHAR2 DEFAULT NULL)
IS
   discount_type_          VARCHAR2(25);
   new_create_partial_sum_ CUST_ORDER_LINE_DISCOUNT_TAB.Create_Partial_Sum%TYPE;
   contract_               Customer_Order_Line_Tab.contract%TYPE;
   CURSOR get_all_discount_records IS
      SELECT discount_no
      FROM   cust_order_line_discount_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;

   CURSOR get_discount_type IS
      SELECT discount_type
      FROM   sales_discount_type_tab;
BEGIN
   -- Remove all existing discount records for the order line
   FOR next_discount_ IN get_all_discount_records LOOP
      Cust_Order_Line_Discount_API.Remove_Discount_Row(order_no_,
                                                       line_no_,
                                                       rel_no_,
                                                       line_item_no_,
                                                       next_discount_.discount_no);

   END LOOP;

   IF (discount_ != 0) THEN
      contract_ := Customer_Order_Line_API.Get_Contract(order_no_, line_no_, rel_no_, line_item_no_);      
      IF (NVL(copy_discount_, 'FALSE') = 'TRUE') THEN
         discount_type_ := Site_Discom_Info_API.Get_Discount_Type(contract_);            
      ELSE          
         -- Create a new discount record for the desired discount percentage
         -- Check if the General discount type exists, if so then use this as the discount type
         -- Added Sales_Discount_Type_API.Check_Exist() instead of Get_Description().         
         IF (Sales_Discount_Type_API.Check_Exist('G')) THEN
            -- Discount type 'G' exists
            discount_type_ := 'G';            
         ELSE
            -- Use the first available discount type for the new discount
            OPEN get_discount_type;
            FETCH get_discount_type INTO discount_type_;
            IF get_discount_type%NOTFOUND THEN
               CLOSE get_discount_type;
               Error_SYS.Record_General(lu_name_, 'NO_DISCOUNT_TYPE: No discount type has been defined. Discount record cannot be created');
            END IF;
            CLOSE get_discount_type;            
         END IF;  
      END IF;
      -- Create a new discount record using the retrieved discount type
      new_create_partial_sum_ := NVL(create_partial_sum_, 'PARTIAL SUM');
      Cust_Order_Line_Discount_API.New(order_no_, line_no_, rel_no_, line_item_no_,
                                       discount_type_, discount_, 'MANUAL',
                                       new_create_partial_sum_, 1, NULL, NULL, NULL, NULL, NULL, NULL);
      Cust_Order_Line_Discount_API.Calc_Discount_Upd_Co_Line__(order_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      -- Make sure the discount saved on the order line is 0
      Customer_Order_Line_API.Modify_Discount__(order_no_, line_no_, rel_no_, line_item_no_, 0);
   END IF;
END Replace_Default_Discount_Rec;


-- Update_Prices_From_Agreement
--   Update the sales unit price of selected customer order lines.
PROCEDURE Update_Prices_From_Agreement (
   agreement_id_               IN VARCHAR2,
   provisional_price_db_       IN VARCHAR2,
   none_provisional_price_db_  IN VARCHAR2,
   from_planned_delivery_date_ IN DATE,
   to_planned_delivery_date_   IN DATE )
IS
   agreement_rec_               Customer_Agreement_API.Public_Rec;
   attr_                        VARCHAR2(2000);
   discount_type_               VARCHAR2(25);
   net_price_                   VARCHAR2(25);
   provisional_price_           VARCHAR2(25);
   temp_provisional_price_db_   VARCHAR2(15);
   currency_rate_type_          VARCHAR2(3);
   base_price_                  NUMBER;
   base_price_incl_tax_         NUMBER;
   currency_rate_               NUMBER;
   discount_                    NUMBER;
   min_quantity_                NUMBER;
   sale_price_                  NUMBER;
   sale_price_incl_tax_         NUMBER;
   valid_from_date_             DATE;

   -- select customer order lines to update the price from sales agreement
   CURSOR get_order_lines IS
      SELECT colt.order_no,     colt.line_no,     colt.rel_no, colt.line_item_no,
             colt.catalog_no,   colt.buy_qty_due, colt.price_effectivity_date,
             configuration_id,  cot.customer_no,  cot.customer_no_pay, 
             cot.currency_code, cot.contract,     supply_code,
             colt.price_conv_factor
        FROM customer_order_line_tab colt, customer_order_tab cot
       WHERE colt.order_no                        = cot.order_no
         AND NVL(colt.price_source_id, CHR(2))    = agreement_id_
         AND colt.price_source                    = 'AGREEMENT'
         AND (provisional_price LIKE temp_provisional_price_db_)
         AND (TRUNC(colt.planned_delivery_date)  >= NVL(from_planned_delivery_date_, TRUNC(colt.planned_delivery_date))
             AND TRUNC(colt.planned_delivery_date) <= NVL(to_planned_delivery_date_,TRUNC(colt.planned_delivery_date)))
         AND colt.rowstate NOT IN ('Invoiced', 'Cancelled')
         AND colt.price_freeze = 'FREE'
         AND colt.line_item_no <= 0;
BEGIN
   IF (from_planned_delivery_date_  IS NOT NULL) AND
       (to_planned_delivery_date_    IS NOT NULL) AND
       (from_planned_delivery_date_ > to_planned_delivery_date_) THEN
      Error_SYS.Record_General('CustomerOrderPricing','INVALIDFROMTODATES: From Planned Delivery Date cannot be later than To Planned Delivery Date.');
   END IF;

   IF (provisional_price_db_ = db_true_ AND none_provisional_price_db_ = db_true_) THEN
      -- select all price lines
      temp_provisional_price_db_ := '%';
   ELSIF (provisional_price_db_ = db_true_) THEN
      -- select provisional price lines
      temp_provisional_price_db_ := db_true_;
   ELSIF (none_provisional_price_db_ = db_true_) THEN
       -- select none provisional price lines
       temp_provisional_price_db_ := db_false_;
   END IF;

   agreement_rec_ := Customer_Agreement_API.Get(agreement_id_);

   FOR line_rec_ IN get_order_lines LOOP
      Find_Price_On_Agr_Part_Deal___(sale_price_, sale_price_incl_tax_, provisional_price_, discount_type_,
                                     discount_, min_quantity_, valid_from_date_,
                                     net_price_, line_rec_.catalog_no, agreement_id_,
                                     line_rec_.buy_qty_due * line_rec_.price_conv_factor, NVL(line_rec_.price_effectivity_date, SYSDATE));

      Client_SYS.Clear_Attr(attr_);
      IF (line_rec_.supply_code != 'SEO') THEN
         IF (line_rec_.configuration_id != '*') THEN
            Client_SYS.Add_to_Attr('PRICE_SOURCE_ID', agreement_id_, attr_);
         ELSE
            -- convert agreement price into base price
            Get_Base_Price_In_Currency(base_price_, currency_rate_,
                                       NVL(line_rec_.customer_no_pay, line_rec_.customer_no),
                                       line_rec_.contract, agreement_rec_.currency_code , sale_price_, currency_rate_type_);
            Get_Base_Price_In_Currency(base_price_incl_tax_, currency_rate_,
                                       NVL(line_rec_.customer_no_pay, line_rec_.customer_no),
                                       line_rec_.contract, agreement_rec_.currency_code , sale_price_incl_tax_, currency_rate_type_);
            IF (line_rec_.currency_code != agreement_rec_.currency_code) THEN
               -- convert above base into sales price
               Get_Sales_Price_In_Currency(sale_price_, currency_rate_,
                                           NVL(line_rec_.customer_no_pay, line_rec_.customer_no),
                                           line_rec_.contract, line_rec_.currency_code , base_price_, currency_rate_type_);
               Get_Sales_Price_In_Currency(sale_price_incl_tax_, currency_rate_,
                                           NVL(line_rec_.customer_no_pay, line_rec_.customer_no),
                                           line_rec_.contract, line_rec_.currency_code , base_price_incl_tax_, currency_rate_type_);
            END IF;
            Customer_Order_Line_API.Calculate_Prices(sale_price_, sale_price_incl_tax_, base_price_, base_price_incl_tax_, line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
            
            Client_SYS.Add_to_Attr('SALE_UNIT_PRICE',      sale_price_, attr_);
            Client_SYS.Add_to_Attr('UNIT_PRICE_INCL_TAX',      sale_price_incl_tax_, attr_);
            Client_SYS.Add_to_Attr('BASE_SALE_UNIT_PRICE', base_price_, attr_);
            Client_SYS.Add_to_Attr('BASE_UNIT_PRICE_INCL_TAX', base_price_incl_tax_, attr_);
         END IF;
         IF (Customer_Order_API.Get_Use_Price_Incl_Tax_Db(line_rec_.order_no) = 'TRUE') THEN
            Client_SYS.Add_to_Attr('PART_PRICE',               sale_price_incl_tax_, attr_);
         ELSE
         Client_SYS.Add_to_Attr('PART_PRICE',           sale_price_, attr_);
         END IF;
         Client_SYS.Add_to_Attr('PROVISIONAL_PRICE_DB', db_false_,     attr_);
         IF (sale_price_ IS NOT NULL) THEN
            Customer_Order_Line_API.Modify(attr_, line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no );
         END IF;
      END IF;
   END LOOP;
END Update_Prices_From_Agreement;


-- Update_Prices_From_Sb
--   This mehod will update the Sales Unit Price of selected customer order lines from the customer price in Self Billing Invoice.
PROCEDURE Update_Prices_From_Sb (
   info_                       OUT    VARCHAR2,
   agreement_id_               IN OUT VARCHAR2,
   customer_no_                IN     VARCHAR2,
   catalog_no_                 IN     VARCHAR2,
   contract_                   IN     VARCHAR2,
   currency_code_              IN     VARCHAR2,
   provisional_price_db_       IN     VARCHAR2,
   none_provisional_price_db_  IN     VARCHAR2,
   update_agreement_           IN     VARCHAR2,
   from_planned_delivery_date_ IN     DATE,
   to_planned_delivery_date_   IN     DATE,
   new_sale_unit_price_        IN     NUMBER )
IS
   temp_provisional_price_db_   VARCHAR2(15);
   attr_                        VARCHAR2(32000);
   quantity_                    NUMBER;
   effectivity_date_            DATE;
   -- select customer order lines to update the price from self billing.
   CURSOR get_order_lines IS
      SELECT colt.order_no, colt.line_no, colt.rel_no, colt.line_item_no, colt.buy_qty_due,
             colt.price_effectivity_date, colt.date_entered, configuration_id
      FROM customer_order_line_tab colt, customer_order_tab cot
      WHERE colt.order_no                      = cot.order_no
      AND cot.customer_no                      = customer_no_
      AND cot.currency_code                    = currency_code_
      AND colt.catalog_no                      = catalog_no_
      AND colt.contract                        = contract_
      AND (provisional_price LIKE temp_provisional_price_db_)
      AND (TRUNC(colt.planned_delivery_date)  >= NVL(from_planned_delivery_date_, TRUNC(colt.planned_delivery_date))
      AND TRUNC(colt.planned_delivery_date) <= NVL(to_planned_delivery_date_, TRUNC(colt.planned_delivery_date)))
      AND colt.rowstate NOT IN ('Invoiced', 'Cancelled')
      AND colt.price_freeze = 'FREE'
      AND colt.line_item_no <= 0;
BEGIN
   IF (provisional_price_db_ = db_true_ AND none_provisional_price_db_ = db_true_) THEN
      -- select all price lines
      temp_provisional_price_db_ := '%';
   ELSIF (provisional_price_db_ = db_true_) THEN
      -- select provisional price lines
      temp_provisional_price_db_ := db_true_;
   ELSIF (none_provisional_price_db_ = db_true_) THEN
      -- select none provisional price lines
      temp_provisional_price_db_ := db_false_;
   END IF;
   FOR line_rec_ IN get_order_lines LOOP
      Customer_Order_Line_API.Modify_Sale_Unit_Price(line_rec_.order_no,
                                                     line_rec_.line_no,
                                                     line_rec_.rel_no,
                                                     line_rec_.line_item_no,
                                                     new_sale_unit_price_);
      IF line_rec_.price_effectivity_date IS NULL THEN
         effectivity_date_ := line_rec_.date_entered;
      ELSE
         effectivity_date_ := line_rec_.price_effectivity_date;
      END IF;
      quantity_ := line_rec_.buy_qty_due;
   END LOOP;
   IF (agreement_id_ IS NOT NULL AND update_agreement_ = 'UPDATE') THEN
      Agreement_Sales_Part_Deal_API.Modify_Deal_Price(agreement_id_, quantity_, effectivity_date_, catalog_no_, new_sale_unit_price_, new_sale_unit_price_);
      agreement_id_ := NULL;
   ELSE
      IF (agreement_id_ IS NOT NULL AND update_agreement_ = 'NEW_LINE') THEN
         Client_SYS.Set_Item_Value('AGREEMENT_ID',agreement_id_, attr_);
         Client_SYS.Set_Item_Value('MIN_QUANTITY', quantity_, attr_);
         Client_SYS.Set_Item_Value('VALID_FROM_DATE', effectivity_date_, attr_);
         Client_SYS.Set_Item_Value('CATALOG_NO', catalog_no_, attr_);
         Client_SYS.Set_Item_Value('BASE_PRICE_SITE', contract_, attr_);
         Client_SYS.Set_Item_Value('BASE_PRICE', new_sale_unit_price_, attr_);
         Client_SYS.Set_Item_Value('DEAL_PRICE', new_sale_unit_price_, attr_);
         Client_SYS.Set_Item_Value('PERCENTAGE_OFFSET', 0, attr_);
         Client_SYS.Set_Item_Value('AMOUNT_OFFSET', 0, attr_);

         Agreement_Sales_Part_Deal_API.New(info_, attr_);
         agreement_id_ := NULL;
      ELSE
         IF (agreement_id_ IS NULL AND update_agreement_ = 'NEW_AGREEMENT') THEN
            Customer_Agreement_API.New_Agreement_And_Part_Deal(info_, agreement_id_, customer_no_, contract_, currency_code_, catalog_no_, new_sale_unit_price_, new_sale_unit_price_);
         ELSE
            agreement_id_ := NULL;
         END IF;
      END IF;
   END IF;
END Update_Prices_From_Sb;


PROCEDURE New_Default_Pq_Discount_Rec (
   acc_discount_           OUT NUMBER,
   price_query_id_         IN  NUMBER,
   contract_               IN  VARCHAR2,
   customer_no_            IN  VARCHAR2,
   currency_code_          IN  VARCHAR2,
   agreement_id_           IN  VARCHAR2,
   catalog_no_             IN  VARCHAR2,
   buy_qty_due_            IN  NUMBER,
   price_list_no_          IN  VARCHAR2,
   price_effectivity_date_ IN  DATE,
   customer_level_db_      IN  VARCHAR2,
   customer_level_id_      IN  VARCHAR2,
   rental_chargeable_days_ IN NUMBER DEFAULT NULL )
IS
   discount_type_             VARCHAR2(25);
   discount_                  NUMBER;
   discount_source_           VARCHAR2(40);
   discount_source_id_        VARCHAR2(25);
   discount_temp_             NUMBER;
   discount_method_db_        VARCHAR2(30);
   effectivity_date_          DATE;
   discount_flag_             BOOLEAN := FALSE;
   effective_min_quantity_    NUMBER;
   effective_valid_from_date_ DATE;
   discount_sub_source_       VARCHAR2(30);
   effective_disc_price_uom_  SALES_PART_TAB.price_unit_meas%TYPE;
   assortment_id_             VARCHAR2(50);
   assortment_node_id_        VARCHAR2(50);
   temp_part_level_db_        VARCHAR2(30) := NULL;
   temp_part_level_id_        VARCHAR2(200) := NULL;
   temp_customer_level_db_    VARCHAR2(30) := customer_level_db_;
   temp_customer_level_id_    VARCHAR2(200) := customer_level_id_;
   price_fetched_is_net_      VARCHAR2(20);
   discount_source_temp_      VARCHAR2(40);
   discount_sub_source_temp_  VARCHAR2(30);
BEGIN
   price_fetched_is_net_ := Price_Query_API.Get_Price_Source_Net_Price(price_query_id_);

   -- If price_fetched_is_net_ is TRUE no discounts should be there.
   IF (Fnd_Boolean_API.Encode(price_fetched_is_net_) = db_false_) THEN
      effectivity_date_   := NVL(price_effectivity_date_, TRUNC(Site_API.Get_Site_Date(contract_)));

      discount_method_db_ := Cust_Order_Discount_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Discount_Method(contract_));
      Get_Default_Pq_Discount_Rec(discount_type_,
                                  discount_,
                                  discount_source_,
                                  discount_source_id_,
                                  effective_min_quantity_,
                                  effective_valid_from_date_,
                                  assortment_id_,
                                  assortment_node_id_,
                                  discount_sub_source_,
                                  temp_part_level_db_,
                                  temp_part_level_id_,
                                  temp_customer_level_db_,
                                  temp_customer_level_id_,
                                  price_query_id_,
                                  contract_,
                                  customer_no_,
                                  currency_code_,
                                  agreement_id_,
                                  catalog_no_,
                                  buy_qty_due_,
                                  price_list_no_,
                                  effectivity_date_,
                                  rental_chargeable_days_);

      discount_temp_ := discount_;
      discount_source_temp_ := discount_source_;
      discount_sub_source_temp_ := discount_sub_source_;

      IF (discount_temp_ IS NOT NULL) THEN
         discount_flag_ := TRUE;
         Create_New_Pq_Disc_Lines___(acc_discount_,
                                    price_query_id_,
                                    discount_source_id_,
                                    discount_source_,
                                    discount_type_,
                                    discount_,
                                    effective_min_quantity_,
                                    effective_valid_from_date_,
                                    contract_,
                                    catalog_no_,
                                    FALSE,
                                    assortment_id_,
                                    assortment_node_id_,
                                    discount_sub_source_,
                                    NULL,
                                    temp_part_level_db_,
                                    temp_part_level_id_,
                                    temp_customer_level_db_,
                                    temp_customer_level_id_);
      END IF;

      IF (discount_method_db_ = 'SINGLE_DISCOUNT' AND discount_temp_ IS NULL) OR (discount_method_db_ = 'MULTIPLE_DISCOUNT') THEN
         -- Fetch additional discount.
         discount_ := 0;
         -- Passed 2 additional parameters discount_source_temp_ and discount_sub_source_temp_
         Get_Multiple_Discount___(discount_,
                                  discount_type_,
                                  discount_source_,
                                  discount_source_id_,
                                  effective_min_quantity_,
                                  effective_valid_from_date_,
                                  assortment_id_,
                                  assortment_node_id_,
                                  discount_sub_source_,
                                  effective_disc_price_uom_,
                                  temp_part_level_db_,
                                  temp_part_level_id_,
                                  temp_customer_level_db_,
                                  temp_customer_level_id_,
                                  contract_,
                                  catalog_no_,
                                  customer_no_,
                                  currency_code_,
                                  agreement_id_,
                                  buy_qty_due_,
                                  effectivity_date_,
                                  rental_chargeable_days_,
                                  discount_source_temp_,
                                  discount_sub_source_temp_);
         discount_temp_ := discount_;

         IF (discount_temp_ != 0 AND discount_temp_ IS NOT NULL) THEN
            Create_New_Pq_Disc_Lines___(acc_discount_,
                                        price_query_id_,
                                        discount_source_id_,
                                        discount_source_,
                                        discount_type_,
                                        discount_,
                                        effective_min_quantity_,
                                        effective_valid_from_date_,
                                        contract_,
                                        catalog_no_,
                                        TRUE,
                                        assortment_id_,
                                        assortment_node_id_,
                                        discount_sub_source_,
                                        effective_disc_price_uom_,
                                        temp_part_level_db_,
                                        temp_part_level_id_,
                                        temp_customer_level_db_,
                                        temp_customer_level_id_);
         END IF;
      END IF;
   END IF;
END New_Default_Pq_Discount_Rec;


PROCEDURE Modify_Default_Pq_Discount_Rec (
   acc_discount_             OUT NUMBER,
   price_query_id_           IN  NUMBER,
   contract_                 IN  VARCHAR2,
   customer_no_              IN  VARCHAR2,
   currency_code_            IN  VARCHAR2,
   agreement_id_             IN  VARCHAR2,
   catalog_no_               IN  VARCHAR2,
   buy_qty_due_              IN  NUMBER,
   price_list_no_            IN  VARCHAR2,
   price_effectivity_date_   IN  DATE,
   customer_level_db_        IN  VARCHAR2,
   customer_level_id_        IN  VARCHAR2,
   rental_chargeable_days_   IN  NUMBER DEFAULT NULL)
IS
   new_discount_type_           VARCHAR2(25);
   new_discount_                NUMBER;
   new_discount_source_         VARCHAR2(40);
   discount_method_db_          VARCHAR2(30);
   effectivity_date_            DATE;
   new_discount_source_id_      VARCHAR2(25);
   effective_min_quantity_      NUMBER;
   effective_valid_from_date_   DATE;
   discount_sub_source_         VARCHAR2(30);
   effective_disc_price_uom_    SALES_PART_TAB.price_unit_meas%TYPE;
   assortment_id_               VARCHAR2(50);
   assortment_node_id_          VARCHAR2(50);
   temp_part_level_db_          VARCHAR2(30) := NULL;
   temp_part_level_id_          VARCHAR2(200) := NULL;
   temp_customer_level_db_      VARCHAR2(30) := customer_level_db_;
   temp_customer_level_id_      VARCHAR2(200) := customer_level_id_;
   price_fetched_is_net_        VARCHAR2(20);
   discount_source_temp_        VARCHAR2(40);
   discount_sub_source_temp_    VARCHAR2(30);

   CURSOR get_old_rec IS
      SELECT price_query_id, discount_no
      FROM   price_query_discount_line_tab
      WHERE  price_query_id = price_query_id_
      AND    discount_source NOT LIKE ('MANUAL');
BEGIN
   price_fetched_is_net_ := Price_Query_API.Get_Price_Source_Net_Price(price_query_id_);

   -- Remove all old discount lines that has not been created manually.
   FOR old_line_rec_ IN get_old_rec LOOP
       IF (old_line_rec_.price_query_id IS NOT NULL) THEN
          Price_Query_Discount_Line_API.Remove_Discount_Row(old_line_rec_.price_query_id,
                                                            old_line_rec_.discount_no);
       END IF;
   END LOOP;

   -- If price_fetched_is_net_ is TRUE no discounts should be there.
   IF (Fnd_Boolean_API.Encode(price_fetched_is_net_) = db_false_) THEN
      effectivity_date_   := NVL(price_effectivity_date_, TRUNC(Site_API.Get_Site_Date(contract_)));

      discount_method_db_ := Cust_Order_Discount_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Discount_Method(contract_));
      -- Get new discount lines.
      Get_Default_Pq_Discount_Rec(new_discount_type_,
                                  new_discount_,
                                  new_discount_source_,
                                  new_discount_source_id_,
                                  effective_min_quantity_,
                                  effective_valid_from_date_,
                                  assortment_id_,
                                  assortment_node_id_,
                                  discount_sub_source_,
                                  temp_part_level_db_,
                                  temp_part_level_id_,
                                  temp_customer_level_db_,
                                  temp_customer_level_id_,
                                  price_query_id_,
                                  contract_,
                                  customer_no_,
                                  currency_code_,
                                  agreement_id_,
                                  catalog_no_,
                                  buy_qty_due_,
                                  price_list_no_,
                                  effectivity_date_,
                                  rental_chargeable_days_);
                                  
      discount_source_temp_ := new_discount_source_;
      discount_sub_source_temp_ := discount_sub_source_;

      IF (new_discount_ IS NOT NULL) THEN
         Create_New_Pq_Disc_Lines___(acc_discount_,
                                     price_query_id_,
                                     new_discount_source_id_,
                                     new_discount_source_,
                                     new_discount_type_,
                                     new_discount_,
                                     effective_min_quantity_,
                                     effective_valid_from_date_,
                                     contract_,
                                     catalog_no_,
                                     TRUE,
                                     assortment_id_,
                                     assortment_node_id_,
                                     discount_sub_source_,
                                     NULL,
                                     temp_part_level_db_,
                                     temp_part_level_id_,
                                     temp_customer_level_db_,
                                     temp_customer_level_id_);
      END IF;
      IF (discount_method_db_ = 'SINGLE_DISCOUNT' AND new_discount_ IS NULL) OR (discount_method_db_ = 'MULTIPLE_DISCOUNT') THEN
         -- Fetch additional discount if no discount was found or if multiple discount is used.
         new_discount_ := 0;
	 -- Passed 2 additional parameters discount_source_temp_ and discount_sub_source_temp_
         Get_Multiple_Discount___(new_discount_,
                                  new_discount_type_,
                                  new_discount_source_,
                                  new_discount_source_id_,
                                  effective_min_quantity_,
                                  effective_valid_from_date_,
                                  assortment_id_,
                                  assortment_node_id_,
                                  discount_sub_source_,
                                  effective_disc_price_uom_,
                                  temp_part_level_db_,
                                  temp_part_level_id_,
                                  temp_customer_level_db_,
                                  temp_customer_level_id_,
                                  contract_,
                                  catalog_no_,
                                  customer_no_,
                                  currency_code_,
                                  agreement_id_,
                                  buy_qty_due_,
                                  effectivity_date_,
                                  rental_chargeable_days_,
                                  discount_source_temp_,
                                  discount_sub_source_temp_);

         IF (new_discount_ != 0 AND new_discount_ IS NOT NULL) THEN
            Create_New_Pq_Disc_Lines___(acc_discount_,
                                        price_query_id_,
                                        new_discount_source_id_,
                                        new_discount_source_,
                                        new_discount_type_,
                                        new_discount_,
                                        effective_min_quantity_,
                                        effective_valid_from_date_,
                                        contract_,
                                        catalog_no_,
                                        TRUE,
                                        assortment_id_,
                                        assortment_node_id_,
                                        discount_sub_source_,
                                        effective_disc_price_uom_,
                                        temp_part_level_db_,
                                        temp_part_level_id_,
                                        temp_customer_level_db_,
                                        temp_customer_level_id_);
         END IF;
      END IF;
      IF (acc_discount_ IS NULL) THEN
         --To get the discount, if only manually entered discount lines (from CO line) exist in Price Query
         acc_discount_ := Price_Query_Discount_Line_API.Get_Total_Discount(price_query_id_);
      END IF;
   END IF;
END Modify_Default_Pq_Discount_Rec;


PROCEDURE Get_Default_Pq_Discount_Rec (
   discount_type_             OUT    VARCHAR2,
   discount_                  OUT    NUMBER,
   discount_source_           OUT    VARCHAR2,
   discount_source_id_        OUT    VARCHAR2,
   min_quantity_              OUT    NUMBER,
   valid_from_date_           OUT    DATE,
   assortment_id_             OUT    VARCHAR2,
   assortment_node_id_        OUT    VARCHAR2,
   discount_sub_source_       OUT    VARCHAR2,
   part_level_db_             OUT    VARCHAR2,
   part_level_id_             OUT    VARCHAR2,
   customer_level_db_         IN OUT VARCHAR2,
   customer_level_id_         IN OUT VARCHAR2,
   price_query_id_            IN     NUMBER,
   contract_                  IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,
   currency_code_             IN     VARCHAR2,
   agreement_id_              IN     VARCHAR2,
   catalog_no_                IN     VARCHAR2,
   buy_qty_due_               IN     NUMBER,
   price_list_no_             IN     VARCHAR2,
   price_effectivity_date_    IN     DATE,
   rental_chargeable_days_    IN     NUMBER DEFAULT NULL)
IS
   price_found_                NUMBER;
   price_incl_tax_found_       NUMBER;
   discount_type_found_        VARCHAR2(25);
   discount_found_             NUMBER;
   price_list_price_           NUMBER;
   price_list_price_incl_tax_  NUMBER;
   price_list_discount_type_   VARCHAR2(25);
   price_list_discount_        NUMBER;
   found_discount              EXCEPTION;
   price_qty_due_              NUMBER;
   discount_source_found_      VARCHAR2(40);
   sales_part_rec_             Sales_Part_API.Public_Rec;
   hierarchy_id_               VARCHAR2(10);
   effectivity_date_           DATE;
   hierarchy_agreement_        VARCHAR2(10);
   prnt_cust_                  CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE;
   price_agreement_            VARCHAR2(10) := NULL;
   agreement_price_            NUMBER;
   agreement_price_incl_tax_   NUMBER;
   provisional_price_          AGREEMENT_SALES_PART_DEAL_TAB.provisional_price%TYPE;
   agreement_discount_type_    AGREEMENT_SALES_PART_DEAL_TAB.discount_type%TYPE;
   agreement_discount_         NUMBER;
   agreement_assort_id_        ASSORTMENT_STRUCTURE_TAB.assortment_id%TYPE;
   part_no_                    VARCHAR2(25);
   part_exists_                BOOLEAN;
   node_id_with_deal_price_    ASSORTMENT_NODE_TAB.assortment_node_id%TYPE := NULL;
   min_qty_with_deal_price_    AGREEMENT_ASSORTMENT_DEAL_TAB.min_quantity%TYPE := NULL;
   valid_frm_with_deal_price_  AGREEMENT_ASSORTMENT_DEAL_TAB.valid_from%TYPE := NULL;
   agreement_assort_deal_rec_  Agreement_Assortment_Deal_API.Public_Rec;
   temp_agreement_id_          AGREEMENT_ASSORTMENT_DEAL_TAB.agreement_id%TYPE := NULL;
   temp_assortment_id_         AGREEMENT_ASSORTMENT_DEAL_TAB.assortment_id%TYPE := NULL;
   price_um_                   SALES_PART_TAB.price_unit_meas%TYPE;
   is_net_price_               VARCHAR2(20);
   campaign_discount_type_     VARCHAR2(25);
   campaign_discount_          NUMBER;
   campaign_price_             NUMBER;
   campaign_price_incl_tax_    NUMBER;
   exclude_from_auto_pricing_  VARCHAR2(5) := 'N';
   temp_part_level_db_         VARCHAR2(30) := NULL;
   temp_part_level_id_         VARCHAR2(200) := NULL;
   temp_customer_level_db_     VARCHAR2(30) := NULL;
   temp_customer_level_id_     VARCHAR2(200) := NULL;
   price_source_               VARCHAR2(25);
   ignore_if_low_price_found_  VARCHAR2(5) := db_false_;
   sales_price_type_db_        VARCHAR2(20);
BEGIN
   price_source_        := Pricing_Source_API.Encode(Price_Query_API.Get_Price_Source(price_query_id_));
  
   -- When rental_chargeable_days_ is specified, it is considered rental prices.
   -- Discount should only be fetched from rental price list and sales part.
   IF (rental_chargeable_days_ IS NULL) THEN
      sales_price_type_db_ := Sales_Price_Type_API.DB_SALES_PRICES;
   ELSE
      sales_price_type_db_ := Sales_Price_Type_API.DB_RENTAL_PRICES;
   END IF;
   
   -- Used in the Create_New_Discount_Lines___
   discount_sub_source_ := NULL;
   IF (price_source_ != 'CONDITION CODE') THEN
      effectivity_date_    := NVL(price_effectivity_date_, TRUNC(Site_API.Get_Site_Date(contract_)));
      sales_part_rec_      := Sales_Part_API.Get(contract_, catalog_no_);
      hierarchy_id_        := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
      part_no_             := sales_part_rec_.part_no;
      part_exists_         := Part_Catalog_API.Check_Part_Exists(part_no_);
      price_um_            := sales_part_rec_.price_unit_meas;
      price_qty_due_       := ABS(buy_qty_due_) * sales_part_rec_.price_conv_factor;
      -- if CO header has an agreement defined check whehter it's a manually added one with exclude from atopicing.
      IF (agreement_id_ IS NOT NULL) THEN
         exclude_from_auto_pricing_ := Customer_Agreement_API.Get_Use_Explicit_Db(agreement_id_);
      END IF;

      -- Discount from agreement.
   -- If CO header has an agreement the deal per part tab and deal per assortment tab of it gets the highest priority.
   -- First check if the agrement id passed in can be used for discount retrieval
      IF (exclude_from_auto_pricing_ = 'Y' AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN   
         IF (Customer_Agreement_API.Is_Valid(agreement_id_, contract_, customer_no_, currency_code_, effectivity_date_) = 1) THEN
            Find_Price_On_Agr_Part_Deal___(agreement_price_, agreement_price_incl_tax_, provisional_price_, agreement_discount_type_, agreement_discount_,
                                           min_quantity_, valid_from_date_, is_net_price_, catalog_no_, agreement_id_, price_qty_due_, effectivity_date_);
            IF (agreement_price_ IS NOT NULL OR agreement_price_incl_tax_ IS NOT NULL) THEN
               price_agreement_ := agreement_id_;
            ELSE
               agreement_assort_id_ := Customer_Agreement_API.Get_Assortment_Id(agreement_id_);
               IF (agreement_assort_id_ IS NOT NULL AND part_exists_) THEN
                  Agreement_Assortment_Deal_API.Get_Deal_Price_Node(node_id_with_deal_price_,
                                                                    min_qty_with_deal_price_,
                                                                    valid_frm_with_deal_price_,
                                                                    agreement_assort_id_,
                                                                    part_no_,
                                                                    agreement_id_,
                                                                    price_um_,
                                                                    price_qty_due_,
                                                                    effectivity_date_);
                  IF (node_id_with_deal_price_ IS NOT NULL) THEN
                     price_agreement_ := agreement_id_;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;

      -- Fetch discount from campaign if agreement id CO header is for auto pricing
      IF (price_agreement_ IS NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         Campaign_API.Get_Campaign_Price_Info(campaign_price_,
                                              campaign_price_incl_tax_,
                                              campaign_discount_type_,
                                              campaign_discount_,
                                              discount_source_found_,
                                              discount_source_id_,
                                              temp_part_level_db_,
                                              temp_part_level_id_,
                                              temp_customer_level_db_,
                                              temp_customer_level_id_,
                                              is_net_price_,
                                              customer_no_,
                                              contract_,
                                              catalog_no_,
                                              currency_code_,
                                              price_um_,
                                              effectivity_date_); 


         IF (discount_source_id_ IS NOT NULL) THEN
            ignore_if_low_price_found_ := Fnd_Boolean_API.Encode(Campaign_API.Get_Ignore_If_Low_Price_Found(discount_source_id_));
            IF (ignore_if_low_price_found_ = db_true_ AND price_source_ = 'CAMPAIGN') OR 
                (ignore_if_low_price_found_ = db_false_) THEN
               discount_type_found_ := campaign_discount_type_;
               discount_found_      := campaign_discount_;
               part_level_db_       := temp_part_level_db_;
               part_level_id_       := temp_part_level_id_;
               customer_level_db_   := temp_customer_level_db_;
               customer_level_id_   := temp_customer_level_id_;
               RAISE found_discount;
            END IF;
         END IF;
      END IF;

      -- If no agreement was passed in or no discount could be retrieved from that agreement then
      -- retrieve the default discount agreement
      IF (price_agreement_ IS NULL) THEN
          price_agreement_ := Customer_Agreement_API.Get_Price_Agreement_For_Part(customer_no_, contract_,
                                                                                  currency_code_, catalog_no_, effectivity_date_, price_qty_due_);
         Find_Price_On_Agr_Part_Deal___(agreement_price_, agreement_price_incl_tax_, provisional_price_, agreement_discount_type_, agreement_discount_,
                                        min_quantity_, valid_from_date_, is_net_price_, catalog_no_, price_agreement_, price_qty_due_, effectivity_date_);
      END IF;

      -- Primary discount is fetched from same place as where sales price is fetched.
      IF ((agreement_price_ IS NOT NULL OR agreement_price_incl_tax_ IS NOT NULL) AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         discount_type_found_   := agreement_discount_type_;
         discount_found_        := agreement_discount_;
         discount_source_found_ := 'AGREEMENT';
         discount_source_id_    := price_agreement_;
         discount_sub_source_   := 'AgreementDealPerPart';
         part_level_db_         := 'PART';
         part_level_id_         := catalog_no_;
         customer_level_db_     := 'CUSTOMER';
         customer_level_id_     := customer_no_;
         RAISE found_discount;
      END IF;

      -- Discount per part and agreement from customer hierarchy.
      -- If the deal per part records from customer's agreement(s) does/do not have maching discount line OR
      -- In case there is a customer agreement id on the CO header and its deal per assortment records does not have matching discount
      -- search through customer hierarchy
      IF (hierarchy_id_ IS NOT NULL AND price_agreement_ IS NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         -- Loop through the hierarchy and select price and discount from first customer that has valid agreement.
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
         WHILE (prnt_cust_ IS NOT NULL) LOOP
            -- Get first price agreement valid for the current catalog_no.
            hierarchy_agreement_ := Customer_Agreement_API.Get_Price_Agreement_For_Part(
                                       customer_no_       => prnt_cust_,
                                       contract_          => contract_,
                                       currency_          => currency_code_,
                                       catalog_no_        => catalog_no_,
                                       effectivity_date_  => effectivity_date_,
                                       quantity_	       => price_qty_due_ );

            IF (hierarchy_agreement_ IS NOT NULL) THEN
               Find_Price_On_Agr_Part_Deal___(price_found_, price_incl_tax_found_, provisional_price_, agreement_discount_type_, agreement_discount_,
                                              min_quantity_, valid_from_date_, is_net_price_, catalog_no_, hierarchy_agreement_, price_qty_due_, effectivity_date_);

               -- Primary discount is fetched from same place as where sales price is fetched.
               IF (price_found_ IS NOT NULL OR price_incl_tax_found_ IS NOT NULL) THEN
                  discount_type_found_   := agreement_discount_type_;
                  discount_found_        := agreement_discount_;
                  discount_source_found_ := 'AGREEMENT';
                  discount_source_id_    := hierarchy_agreement_;
                  discount_sub_source_   := 'AgreementDealPerPart';
                  part_level_db_         := 'PART';
                  part_level_id_         := catalog_no_;
                  customer_level_db_     := 'HIERARCHY';
                  customer_level_id_     := prnt_cust_;
                  RAISE found_discount;
               END IF;
            END IF;
            prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
         END LOOP;
      END IF;

      --Get price from best deal per Assortment record. This can be from a valid agreement of the customer or else from customer hierarchy.
      IF (node_id_with_deal_price_ IS NULL AND part_exists_) THEN
         -- Get the valid Agreement - Assortment combination first.
         Customer_Agreement_API.Get_Price_Agrm_For_Part_Assort(temp_assortment_id_,
                                                               temp_agreement_id_,
                                                               temp_customer_level_db_,
                                                               temp_customer_level_id_,
                                                               customer_no_,
                                                               contract_,
                                                               currency_code_,
                                                               effectivity_date_,
                                                               part_no_,
                                                               price_um_,
                                                               hierarchy_id_);

         -- Using Part step pricing logic for deal per Assortment, search for the best node in the Assortment Structure selected from above method call.
         Agreement_Assortment_Deal_API.Get_Deal_Price_Node(node_id_with_deal_price_,
                                                           min_qty_with_deal_price_,
                                                           valid_frm_with_deal_price_,
                                                           temp_assortment_id_,
                                                           part_no_,
                                                           temp_agreement_id_,
                                                           price_um_,
                                                           price_qty_due_,
                                                           effectivity_date_);
         IF (node_id_with_deal_price_ IS NOT NULL) THEN
             price_agreement_     := temp_agreement_id_;
             agreement_assort_id_ := temp_assortment_id_;
         END IF;
      END IF;

      -- IF a node_id_with_deal_price_ found a Assortment Node with a deal price has found.
      IF (node_id_with_deal_price_ IS NOT NULL AND sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) THEN
         agreement_assort_deal_rec_ := Agreement_Assortment_Deal_API.Get(price_agreement_, agreement_assort_id_, node_id_with_deal_price_, min_qty_with_deal_price_, valid_frm_with_deal_price_, price_um_);
         discount_type_found_       := agreement_assort_deal_rec_.discount_type;
         discount_found_            := agreement_assort_deal_rec_.discount;
         Trace_SYS.Field('Default discount searched until Customer Agreement with a deal per Assortment : ', price_agreement_);
         discount_source_found_     := 'AGREEMENT';
         discount_source_id_        := price_agreement_;
         assortment_id_             := agreement_assort_id_;
         assortment_node_id_        := node_id_with_deal_price_;
         min_quantity_              := min_qty_with_deal_price_;
         valid_from_date_           := valid_frm_with_deal_price_;
         discount_sub_source_       := 'AgreementDealPerAssortment';
         part_level_db_             := 'ASSORTMENT';
         part_level_id_             := agreement_assort_id_ || ' - ' || node_id_with_deal_price_;
         IF (exclude_from_auto_pricing_ = 'Y') THEN
            customer_level_db_ := 'CUSTOMER';
            customer_level_id_ := customer_no_;
         ELSE
            customer_level_db_ := temp_customer_level_db_;
            customer_level_id_ := temp_customer_level_id_;
         END IF;
         RAISE found_discount;
      END IF;

      -- Discount from price list
      IF (price_list_no_ IS NOT NULL) THEN
         -- Pricelist used. Check if valid.
         IF ((Sales_Price_List_API.Is_Valid(price_list_no_, contract_, catalog_no_, effectivity_date_, sales_price_type_db_) = TRUE) 
             OR (Sales_Price_List_API.Is_Valid_Assort(price_list_no_, contract_, catalog_no_, effectivity_date_) = TRUE) ) AND
             (Sales_Price_List_API.Get_Sales_Price_Group_Id(price_list_no_) = sales_part_rec_.sales_price_group_id) THEN
            -- Allows Service Managment to use negative amount.
            price_qty_due_        := ABS(buy_qty_due_) * sales_part_rec_.price_conv_factor;
            Sales_Price_List_API.Find_Price_On_Pricelist(price_list_price_, 
                                                         price_list_price_incl_tax_, 
                                                         price_list_discount_type_, 
                                                         price_list_discount_, 
                                                         part_level_db_, 
                                                         part_level_id_, 
                                                         price_list_no_, 
                                                         catalog_no_, 
                                                         price_qty_due_, 
                                                         effectivity_date_, 
                                                         price_um_,
                                                         rental_chargeable_days_);
            price_found_          := price_list_price_;
            price_incl_tax_found_ := price_list_price_incl_tax_;
            -- Primary discount is fetched from same place as where sales price is fetched.
            IF (price_found_ IS NOT NULL) OR (price_incl_tax_found_ IS NOT NULL) THEN
               discount_type_found_   := price_list_discount_type_;
               discount_found_        := price_list_discount_;
               discount_source_found_ := 'PRICE LIST';
               discount_source_id_    := price_list_no_;
               discount_sub_source_   := 'PriceList';
               RAISE found_discount;
            END IF;
         END IF;
      END IF;
      RAISE found_discount;
   END IF;
EXCEPTION
   WHEN found_discount THEN
      discount_type_   := discount_type_found_;
      discount_        := discount_found_;
      discount_source_ := discount_source_found_;
      Trace_SYS.Field('Discount Source >> ', discount_source_);
      Trace_SYS.Field('Discount Part Level >> ', part_level_db_);
      Trace_SYS.Field('Discount Part Level Id >> ', part_level_id_);
      Trace_SYS.Field('Discount Customer Level >> ', customer_level_db_);
      Trace_SYS.Field('Discount Customer Level Id >> ', customer_level_id_);
END Get_Default_Pq_Discount_Rec;


PROCEDURE Copy_Discounts_To_Pq (
   source_           IN VARCHAR2,
   source_ref1_      IN VARCHAR2,
   source_ref2_      IN VARCHAR2,
   source_ref3_      IN VARCHAR2,
   source_ref4_      IN NUMBER,
   price_query_id_   IN NUMBER )
IS
   discount_line_no_      NUMBER := 1;
   acc_discount_          NUMBER;  -- not returned from this method at this time, we already have correct ones from the COL/OQL

   CURSOR get_order_rec IS
      SELECT *
      FROM cust_order_line_discount_tab
      WHERE order_no = source_ref1_
      AND   line_no = source_ref2_
      AND   rel_no = source_ref3_
      AND   line_item_no = source_ref4_;

   CURSOR get_quotation_rec IS
      SELECT *
      FROM order_quote_line_discount_tab
      WHERE quotation_no = source_ref1_
      AND   line_no = source_ref2_
      AND   rel_no = source_ref3_
      AND   line_item_no = source_ref4_;
BEGIN
   IF (source_ = 'CUSTOMER_ORDER_LINE') THEN
      FOR order_rec_ IN get_order_rec LOOP
         Price_Query_Discount_Line_API.New(acc_discount_,
                                           price_query_id_,
                                           order_rec_.discount_type,
                                           order_rec_.discount,
                                           order_rec_.discount_source,
                                           order_rec_.create_partial_sum,
                                           discount_line_no_,
                                           order_rec_.discount_source_id,
                                           order_rec_.discount_amount,
                                           order_rec_.part_level,
                                           order_rec_.part_level_id,
                                           order_rec_.customer_level,
                                           order_rec_.customer_level_id);
         discount_line_no_ := discount_line_no_ + 1;
      END LOOP;
   ELSIF (source_ = 'ORDER_QUOTATION_LINE') THEN
      FOR quotation_rec_ IN get_quotation_rec LOOP
         Price_Query_Discount_Line_API.New(acc_discount_,
                                           price_query_id_,
                                           quotation_rec_.discount_type,
                                           quotation_rec_.discount,
                                           quotation_rec_.discount_source,
                                           quotation_rec_.create_partial_sum,
                                           discount_line_no_,
                                           quotation_rec_.discount_source_id,
                                           quotation_rec_.discount_amount,
                                           quotation_rec_.part_level,
                                           quotation_rec_.part_level_id,
                                           quotation_rec_.customer_level,
                                           quotation_rec_.customer_level_id);
         discount_line_no_ := discount_line_no_ + 1;
      END LOOP;
   END IF;
END Copy_Discounts_To_Pq;


PROCEDURE Get_Price_Query_Data (
   newrec_ IN OUT PRICE_QUERY_TAB%ROWTYPE )
IS
   customer_no_pay_           CUSTOMER_ORDER_TAB.customer_no_pay%TYPE;
   currency_rate_type_        VARCHAR2(10);
   currency_rate_             NUMBER;
   price_list_no_             VARCHAR2(10);
   provisional_price_db_      VARCHAR2(10);
   discount_source_db_        VARCHAR2(2000) := NULL;
   discount_source_id_        VARCHAR2(25) := NULL;
   company_                   COMPANY_INVOICE_INFO_TAB.company%TYPE;
   dummy_                     NUMBER;
   sale_unit_price_           NUMBER;
   price_qty_due_             NUMBER;
BEGIN
   customer_no_pay_           := Cust_Ord_Customer_Api.Get_Customer_No_Pay(newrec_.customer_no);
   price_qty_due_ := ABS(newrec_.sales_qty)*(Sales_Part_API.Get_Price_Conv_Factor(newrec_.contract, newrec_.catalog_no));
   
   Sales_Price_List_API.Get_Valid_Price_List(newrec_.customer_level, newrec_.customer_level_id, price_list_no_, newrec_.contract, 
                                             newrec_.catalog_no, newrec_.customer_no, newrec_.currency_code, newrec_.price_effective_date, price_qty_due_);

   company_                   := Site_API.Get_Company(newrec_.contract);
   newrec_.use_price_incl_tax := Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(newrec_.customer_no, company_);
   
   IF (newrec_.use_price_incl_tax IS NULL) THEN
      newrec_.use_price_incl_tax := 'FALSE';
   END IF;
   
   IF (newrec_.use_price_incl_tax = 'TRUE') THEN
      Get_Sales_Part_Price_Info___(dummy_,                         sale_unit_price_,       dummy_,                        newrec_.base_sale_unit_price, 
                                   currency_rate_,                 newrec_.acc_discount,   newrec_.price_source_id,       provisional_price_db_,
                                   newrec_.price_source_net_price, newrec_.price_source,   discount_source_db_,           discount_source_id_,
                                   newrec_.part_level,             newrec_.part_level_id,  newrec_.customer_level,        newrec_.customer_level_id,
                                   newrec_.contract,               newrec_.customer_no,    customer_no_pay_,              newrec_.currency_code,
                                   newrec_.agreement_id,           newrec_.catalog_no,     newrec_.sales_qty,             price_list_no_,
                                   newrec_.price_effective_date,   newrec_.condition_code, currency_rate_type_,           newrec_.use_price_incl_tax,
                                   NULL, TRUE);
   ELSE
      Get_Sales_Part_Price_Info___(sale_unit_price_,               dummy_,                 newrec_.base_sale_unit_price,  dummy_, 
                                   currency_rate_,                 newrec_.acc_discount,   newrec_.price_source_id,       provisional_price_db_,
                                   newrec_.price_source_net_price, newrec_.price_source,   discount_source_db_,           discount_source_id_,
                                   newrec_.part_level,             newrec_.part_level_id,  newrec_.customer_level,        newrec_.customer_level_id,
                                   newrec_.contract,               newrec_.customer_no,    customer_no_pay_,              newrec_.currency_code,
                                   newrec_.agreement_id,           newrec_.catalog_no,     newrec_.sales_qty,             price_list_no_,
                                   newrec_.price_effective_date,   newrec_.condition_code, currency_rate_type_,           newrec_.use_price_incl_tax,
                                   NULL, TRUE);
   END IF;
   newrec_.sale_unit_price := sale_unit_price_;
END Get_Price_Query_Data;


PROCEDURE Get_Price_Query_Data_Source (
   newrec_ IN OUT PRICE_QUERY_TAB%ROWTYPE )
IS
   order_rec_      Customer_Order_API.Public_Rec;
   order_line_rec_ Customer_Order_Line_API.Public_Rec;
   quotation_rec_  Order_Quotation_API.Public_Rec;
   quot_line_rec_  Order_Quotation_Line_API.Public_Rec;
BEGIN
   -- fetching price query data from customer order and order quotation LU's
   IF (newrec_.source = 'CUSTOMER_ORDER_LINE') THEN
      order_rec_      := Customer_Order_API.Get(newrec_.source_ref1);
      order_line_rec_ := Customer_Order_Line_API.Get(newrec_.source_ref1,
                                                     newrec_.source_ref2,
                                                     newrec_.source_ref3,
                                                     newrec_.source_ref4);
      -- price query head fields
      newrec_.creator               := Fnd_Session_API.Get_Fnd_User;
      newrec_.contract              := order_rec_.contract;
      newrec_.customer_no           := order_rec_.customer_no;
      newrec_.currency_code         := order_rec_.currency_code;
      newrec_.catalog_no            := order_line_rec_.catalog_no;
      newrec_.sales_qty             := order_line_rec_.buy_qty_due;
      newrec_.price_qty             := (order_line_rec_.buy_qty_due * order_line_rec_.price_conv_factor);
      newrec_.additional_discount   := order_line_rec_.additional_discount;         
      newrec_.customer_part_no      := order_line_rec_.customer_part_no;
      newrec_.agreement_id          := order_rec_.agreement_id;
      newrec_.price_effective_date  := order_line_rec_.price_effectivity_date;
      newrec_.condition_code        := order_line_rec_.condition_code;
      -- price query summary fields
      newrec_.price_source          := order_line_rec_.price_source;
      newrec_.price_source_id       := order_line_rec_.price_source_id;
      newrec_.part_level            := order_line_rec_.part_level;
      newrec_.part_level_id         := order_line_rec_.part_level_id;
      newrec_.customer_level        := order_line_rec_.customer_level;
      newrec_.customer_level_id     := order_line_rec_.customer_level_id;
      newrec_.use_price_incl_tax    := order_rec_.use_price_incl_tax;
      IF (newrec_.use_price_incl_tax = 'TRUE') THEN
         newrec_.sale_unit_price      := order_line_rec_.unit_price_incl_tax;
         newrec_.base_sale_unit_price := order_line_rec_.base_unit_price_incl_tax;
      ELSE
         newrec_.sale_unit_price      := order_line_rec_.sale_unit_price;
         newrec_.base_sale_unit_price := order_line_rec_.base_sale_unit_price;
      END IF;
      newrec_.acc_discount            := order_line_rec_.discount;
      newrec_.group_discount          := order_line_rec_.order_discount;
      newrec_.part_cost              := order_line_rec_.cost;
      newrec_.price_source_net_price := order_line_rec_.price_source_net_price;
         
   ELSIF (newrec_.source = 'ORDER_QUOTATION_LINE') THEN
      quotation_rec_ := Order_Quotation_API.Get(newrec_.source_ref1);
      quot_line_rec_ := Order_Quotation_Line_API.Get(newrec_.source_ref1,
                                                     newrec_.source_ref2,
                                                     newrec_.source_ref3,
                                                     newrec_.source_ref4);
      -- price query head fields
      newrec_.creator              := Fnd_Session_API.Get_Fnd_User;
      newrec_.contract             := quotation_rec_.contract;
      newrec_.customer_no          := quotation_rec_.customer_no;
      newrec_.currency_code        := quotation_rec_.currency_code;
      newrec_.catalog_no           := quot_line_rec_.catalog_no;
      newrec_.sales_qty            := quot_line_rec_.buy_qty_due;
      newrec_.price_qty            := (quot_line_rec_.buy_qty_due * quot_line_rec_.price_conv_factor);
      newrec_.additional_discount  := quot_line_rec_.additional_discount;                
      newrec_.customer_part_no     := quot_line_rec_.customer_part_no;
      newrec_.agreement_id         := quotation_rec_.agreement_id;
      newrec_.price_effective_date := quotation_rec_.price_effectivity_date;
      newrec_.condition_code       := quot_line_rec_.condition_code;
      -- price query summary fields
      newrec_.price_source         := quot_line_rec_.price_source;
      newrec_.price_source_id      := quot_line_rec_.price_source_id;
      newrec_.part_level           := quot_line_rec_.part_level;
      newrec_.part_level_id        := quot_line_rec_.part_level_id;
      newrec_.customer_level       := quot_line_rec_.customer_level;
      newrec_.customer_level_id    := quot_line_rec_.customer_level_id;
      newrec_.use_price_incl_tax   := quotation_rec_.use_price_incl_tax;
      IF (newrec_.use_price_incl_tax = 'TRUE') THEN
         newrec_.sale_unit_price      := quot_line_rec_.unit_price_incl_tax;
         newrec_.base_sale_unit_price := quot_line_rec_.base_unit_price_incl_tax;
      ELSE
         newrec_.sale_unit_price      := quot_line_rec_.sale_unit_price;
         newrec_.base_sale_unit_price := quot_line_rec_.base_sale_unit_price;
      END IF;
      newrec_.acc_discount           := quot_line_rec_.discount;
      newrec_.group_discount         := quot_line_rec_.quotation_discount;
      newrec_.part_cost              := quot_line_rec_.cost;
      newrec_.price_source_net_price := quot_line_rec_.price_source_net_price;
   END IF;
END Get_Price_Query_Data_Source;


PROCEDURE Do_Price_Query_Calculations (
   newrec_ IN OUT PRICE_QUERY_TAB%ROWTYPE )
IS
   dummy_gross_weight_        NUMBER;
   dummy_total_volume_        NUMBER;
   dummy_adj_net_weight_      NUMBER;
   dummy_adj_gross_weight_    NUMBER;
   dummy_adj_volume_          NUMBER;
   total_price_base_          NUMBER;
   sales_part_rec_            Sales_Part_API.Public_Rec;
   company_                   VARCHAR2(20);
   currency_rounding_         NUMBER;
   currency_rounding_base_    NUMBER;
   currency_rate_type_        VARCHAR2(10);
   price_base_with_discount_  NUMBER;
   cost_in_sales_currency_    NUMBER;
   input_unit_meas_           VARCHAR2(30);
   input_qty_                 NUMBER;
   line_total_value_          NUMBER;
   discount_code_             VARCHAR2(20);
   rebate_agreement_exist_    PRICE_QUERY_TAB.rebate_agreement%TYPE := db_false_;
   currency_rate_             NUMBER;
   order_rec_                 Customer_Order_API.Public_Rec;
   order_line_rec_            Customer_Order_Line_API.Public_Rec;
   quotation_rec_             Order_Quotation_API.Public_Rec;
   quot_line_rec_             Order_Quotation_Line_API.Public_Rec;
   conv_factor_               NUMBER;
   inverted_conv_factor_      NUMBER;
   price_conv_factor_         NUMBER;
   supply_type_               VARCHAR2(3);
   customer_no_pay_           VARCHAR2(20);
   configuration_id_          VARCHAR2(50) := '*';
   line_discount_amount_      NUMBER;
   add_discount_amount_       NUMBER;
   group_discount_amount_     NUMBER;
   curr_type_                 VARCHAR2(10);
   curr_conv_factor_          NUMBER;
   active_agreement_list_     Rebate_Agreement_API.Agreement_Info_List;
BEGIN

   sales_part_rec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);
   IF (newrec_.source = 'CUSTOMER_ORDER_LINE') THEN
      order_rec_      := Customer_Order_API.Get(newrec_.source_ref1);
      order_line_rec_ := Customer_Order_Line_API.Get(newrec_.source_ref1,
                                                     newrec_.source_ref2,
                                                     newrec_.source_ref3,
                                                     newrec_.source_ref4);
      conv_factor_          := order_line_rec_.conv_factor;
      inverted_conv_factor_ := order_line_rec_.inverted_conv_factor;
      price_conv_factor_    := order_line_rec_.price_conv_factor;
      supply_type_          := order_line_rec_.supply_code;
      customer_no_pay_      := order_rec_.customer_no_pay;
      configuration_id_     := order_line_rec_.configuration_id;
      currency_rate_        := order_line_rec_.currency_rate;
   ELSIF (newrec_.source = 'ORDER_QUOTATION_LINE') THEN
      quotation_rec_  := Order_Quotation_API.Get(newrec_.source_ref1);
      quot_line_rec_  := Order_Quotation_Line_API.Get(newrec_.source_ref1,
                                                      newrec_.source_ref2,
                                                      newrec_.source_ref3,
                                                      newrec_.source_ref4);
      conv_factor_          := quot_line_rec_.conv_factor;
      inverted_conv_factor_ := quot_line_rec_.inverted_conv_factor;
      price_conv_factor_    := quot_line_rec_.price_conv_factor;
      supply_type_          := quot_line_rec_.order_supply_type;
      customer_no_pay_      := quotation_rec_.customer_no_pay;
      configuration_id_     := quot_line_rec_.configuration_id;
      currency_rate_        := quot_line_rec_.currency_rate;
   ELSE
      conv_factor_          := sales_part_rec_.conv_factor;
      inverted_conv_factor_ := sales_part_rec_.inverted_conv_factor; 
      price_conv_factor_    := sales_part_rec_.price_conv_factor;
      supply_type_          := Order_Supply_Type_API.Encode(Sales_Part_API.Get_Default_Supply_Code(newrec_.contract, newrec_.catalog_no));
      customer_no_pay_      := Cust_Ord_Customer_Api.Get_Customer_No_Pay(newrec_.customer_no);
   END IF;

   company_ := Site_API.Get_Company(newrec_.contract);
   Rebate_Agreement_Receiver_API.Get_Active_Agreement(active_agreement_list_, 
                                                       newrec_.customer_no, 
                                                       company_, 
                                                       NVL(newrec_.price_effective_date, SYSDATE));
   IF active_agreement_list_.COUNT > 0 THEN   
      rebate_agreement_exist_ := db_true_;
   END IF;
   newrec_.rebate_agreement    := rebate_agreement_exist_;
   newrec_.base_currency_code  := Company_Finance_API.Get_Currency_Code(company_);
   currency_rounding_          := Currency_Code_API.Get_Currency_Rounding(company_, newrec_.currency_code);
   currency_rounding_base_     := Currency_Code_API.Get_Currency_Rounding(company_, newrec_.base_currency_code);
   total_price_base_           := newrec_.sales_qty * newrec_.base_sale_unit_price * price_conv_factor_;
   newrec_.acc_discount        := NVL(newrec_.acc_discount,0);
   newrec_.additional_discount := NVL(newrec_.additional_discount, 0);

   -- accumulated discount values are calculated without rounding.
   -- gelr:disc_price_rounded, added use_price_incl_tax to Price_Query_Discount_Line_API.Get_Total_Line_Discount
   newrec_.acc_discount_amount := Price_Query_Discount_Line_API.Get_Total_Line_Discount(newrec_.price_query_id, 1,  1, use_price_incl_tax_ => newrec_.use_price_incl_tax);
   
   IF currency_rate_ IS NULL THEN
      Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, curr_conv_factor_, currency_rate_, Site_API.Get_Company(newrec_.contract), newrec_.currency_code,
                                                     Site_API.Get_Site_Date(newrec_.contract), 'CUSTOMER', NVL(customer_no_pay_, newrec_.customer_no));
      currency_rate_ := currency_rate_/curr_conv_factor_;
   END IF;
   newrec_.base_acc_discount_amount   := newrec_.acc_discount_amount * currency_rate_;
   newrec_.net_price_incl_acc_disc    := newrec_.sale_unit_price - newrec_.acc_discount_amount;
   newrec_.base_net_price_incl_ac_dsc := newrec_.base_sale_unit_price - newrec_.base_acc_discount_amount;

   -- additional discount
   newrec_.add_discount_amount      := newrec_.net_price_incl_acc_disc * (newrec_.additional_discount/100);
   newrec_.base_add_discount_amount := newrec_.base_net_price_incl_ac_dsc * (newrec_.additional_discount/100);

   -- calculate group/order discount_
   IF (newrec_.source IS NULL) THEN
      -- for price query standalone records we need to calculation the group discount, for source records it has already got a value from Get_Price_Query_Data_Source
      discount_code_ := Discount_Basis_Code_API.Encode(Sales_Discount_Group_API.Get_Discount_Code(sales_part_rec_.discount_group));
      IF (discount_code_ = 'V') THEN
         line_total_value_ := ROUND(total_price_base_, currency_rounding_base_) - ROUND(total_price_base_ - (total_price_base_ * ((1 - newrec_.acc_discount / 100))), currency_rounding_base_);
      ELSIF (discount_code_ = 'W') THEN
         Sales_Weight_Volume_Util_API.Get_Total_Weight_Volume(line_total_value_, dummy_gross_weight_, dummy_total_volume_,
                                                              dummy_adj_net_weight_, dummy_adj_gross_weight_,
                                                              dummy_adj_volume_, newrec_.contract, newrec_.catalog_no,
                                                              sales_part_rec_.part_no,
                                                              newrec_.sales_qty, configuration_id_, input_unit_meas_, input_qty_);
      ELSE
         line_total_value_ := newrec_.sales_qty;
      END IF;
      Trace_SYS.Field('discount_code_ >> ', discount_code_);
      Trace_SYS.Field('line_total_value_ >> ', line_total_value_);
      newrec_.group_discount := NVL(Sales_Discount_Group_API.Get_Amount_Discount(sales_part_rec_.discount_group, line_total_value_, discount_code_, newrec_.use_price_incl_tax),0);
   END IF;
   -- group discount amount is based on net price including accumulated discount amount
   newrec_.group_discount_amount      := newrec_.net_price_incl_acc_disc * (newrec_.group_discount/100);
   newrec_.base_group_discount_amount := newrec_.base_net_price_incl_ac_dsc * (newrec_.group_discount/100);
   newrec_.net_price                  := newrec_.net_price_incl_acc_disc - (newrec_.add_discount_amount + newrec_.group_discount_amount);
   newrec_.base_net_price             := newrec_.base_net_price_incl_ac_dsc - (newrec_.base_add_discount_amount + newrec_.base_group_discount_amount);
   -- gelr:disc_price_rounded, added use_price_incl_tax to Price_Query_Discount_Line_API.Get_Total_Line_Discount
   line_discount_amount_              := Price_Query_Discount_Line_API.Get_Total_Line_Discount(newrec_.price_query_id, newrec_.sales_qty,  price_conv_factor_, currency_rounding_, use_price_incl_tax_ => newrec_.use_price_incl_tax);
   add_discount_amount_               := ROUND(((newrec_.sale_unit_price * newrec_.sales_qty * price_conv_factor_) - line_discount_amount_ )*(newrec_.additional_discount/100), currency_rounding_ ); 
   group_discount_amount_             := ROUND(((newrec_.sale_unit_price * newrec_.sales_qty * price_conv_factor_) - line_discount_amount_ )* (newrec_.group_discount/100) , currency_rounding_ );
   -- total amounts, costs and estimated contribution margin
   newrec_.total_amount               := ROUND((newrec_.sale_unit_price * newrec_.sales_qty * price_conv_factor_), currency_rounding_) - (line_discount_amount_ + add_discount_amount_ + group_discount_amount_);
   -- calcualtion for base price, should be consistant with customer order line calculations
   IF currency_rate_ IS NULL THEN
      Get_Base_Price_In_Currency(newrec_.base_total_amount,currency_rate_, NVL(customer_no_pay_, newrec_.customer_no), newrec_.contract, newrec_.currency_code , newrec_.total_amount);
   ELSE
      newrec_.base_total_amount := ROUND((newrec_.total_amount * currency_rate_), currency_rounding_base_) ;
   END IF;
   
   IF (newrec_.source IS NULL) THEN
      -- get part cost in base currency for standalone case, for the other source cases we use the value saved on the COL/OQL
      IF (sales_part_rec_.part_no IS NOT NULL) THEN
         -- Part cost for inventory sales parts
         newrec_.part_cost := Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead(newrec_.contract, 
                                                                               sales_part_rec_.part_no, 
                                                                               '*', 
                                                                               newrec_.condition_code,
                                                                               newrec_.sales_qty * conv_factor_/inverted_conv_factor_, 
                                                                               'CHARGED ITEM',
                                                                               supply_type_, 
                                                                               newrec_.customer_no, 
                                                                               'COMPANY OWNED');
      ELSIF (sales_part_rec_.catalog_type = 'PKG') THEN
         -- Part cost for package parts
         newrec_.part_cost := Sales_Part_API.Get_Total_Cost(newrec_.contract, newrec_.catalog_no);
      ELSE
         -- Part cost for non inventory sales parts
         newrec_.part_cost := sales_part_rec_.cost;
      END IF;
   END IF;
   -- fetch part_cost in sales currency
   Get_Sales_Price_In_Currency(cost_in_sales_currency_, currency_rate_, NVL(customer_no_pay_, newrec_.customer_no), newrec_.contract, newrec_.currency_code , newrec_.part_cost, currency_rate_type_);
   Trace_SYS.Field('cost per unit>> ', cost_in_sales_currency_);
   Trace_SYS.Field('cost base per unit >> ', newrec_.part_cost);
   newrec_.total_cost            := cost_in_sales_currency_ * newrec_.sales_qty * conv_factor_/inverted_conv_factor_;
   newrec_.base_total_cost       := newrec_.part_cost * newrec_.sales_qty * conv_factor_/inverted_conv_factor_;
   newrec_.est_contr_margin      := newrec_.total_amount - newrec_.total_cost;
   newrec_.base_est_contr_margin := newrec_.base_total_amount - newrec_.base_total_cost;
   -- some extra totals
   price_base_with_discount_     := total_price_base_ * (1 - newrec_.acc_discount / 100) * (1 - (newrec_.group_discount + newrec_.additional_discount) / 100);
   IF (total_price_base_ <> 0) THEN   -- avoiding divisor is equal to zero problems
      newrec_.total_discount := ROUND(100 * (1 - (price_base_with_discount_ / total_price_base_)), 2);
   ELSE
      newrec_.total_discount := ROUND(100 * (1 - (price_base_with_discount_ / 1)), 2);
   END IF;
   IF (newrec_.total_amount <> 0) THEN  -- avoiding divisor is equal to zero problems
      newrec_.est_contr_margin_rate := ROUND((newrec_.est_contr_margin / newrec_.total_amount) * 100, 2);
   ELSE
      newrec_.est_contr_margin_rate := ROUND((newrec_.est_contr_margin / 1) * 100, 2);
   END IF;

   -- roundings
   --             add_discount_amount, base_add_discount_amount, group_discount_amount, base_group_discount_amount, net_price, base_net_price, 
   --             Price values should display without rounding.
   newrec_.total_amount          := ROUND(newrec_.total_amount, currency_rounding_);
   newrec_.base_total_amount     := ROUND(newrec_.base_total_amount, currency_rounding_base_);
   newrec_.total_cost            := ROUND(newrec_.total_cost, currency_rounding_);
   newrec_.base_total_cost       := ROUND(newrec_.base_total_cost, currency_rounding_base_);
   newrec_.est_contr_margin      := ROUND(newrec_.est_contr_margin, currency_rounding_);
   newrec_.base_est_contr_margin := ROUND(newrec_.base_est_contr_margin, currency_rounding_base_);

   -- NOTE: This method will sometime not return the exact same values for the base currency amounts and contr margin fields as a similar order/quotation would do,
   -- since those clients do extra conversions from sale_unit_price to base_unit_price to cover cases when you manually change the sale_unit_price in the client.
   -- And the sale_unit_price in this extra conversion is rounded to 2 decimals and has not the full precision as it has after Get_Sales_Part_Price_Info___, if we were
   -- to start using IFS Currency - Preserve Precision for all amount fields this could be solved, but so far in support it has been decided not to do that due the complex
   -- nature of having to change all places in distribution, since each client calculation would require 4 new code lines to handle this.
END Do_Price_Query_Calculations;

FUNCTION Calculate_Margin_Values (   
   msg_            IN CLOB,
   source_         IN VARCHAR2,
   adjust_price_   IN VARCHAR2,
   save_           IN VARCHAR2,
   margin_percent_ IN VARCHAR2) RETURN CLOB
IS   
   attr_                         VARCHAR2(2000);      
   sq_rec_                       Order_Quotation_Line_API.Public_Rec;
   sq_head_rec_                  Order_Quotation_API.Public_Rec;
   attr_new_                     VARCHAR2(2000);     
   tab_quotation_no_             tab_quotation_no;
   tab_line_no_                  tab_line_no;
   tab_rel_no_                   tab_rel_no;
   tab_line_item_no_             tab_line_item_no;   
   tab_base_unit_price_incl_tax_ tab_base_unit_price_incl_tax;
   tab_unit_price_incl_tax_      tab_unit_price_incl_tax;
   tab_base_unit_price_          tab_base_unit_price;
   tab_unit_price_               tab_unit_price;
   tab_discount_                 tab_discount;
   names_                        Message_SYS.name_table_clob;
   values_                       Message_SYS.line_table_clob;   
   count_                        NUMBER;
   n_                            NUMBER := 0;   
   sub_message_                  CLOB;
   message_                      CLOB;
   line_count_                   NUMBER := 0;
   total_tax_percentage_         NUMBER;
   quotation_no_                 ORDER_QUOTATION_LINE_TAB.quotation_no%TYPE;
   base_unit_price_incl_tax_     ORDER_QUOTATION_LINE_TAB.base_unit_price_incl_tax%TYPE;
   unit_price_incl_tax_          ORDER_QUOTATION_LINE_TAB.unit_price_incl_tax%TYPE;
   base_unit_price_              ORDER_QUOTATION_LINE_TAB.base_sale_unit_price%TYPE;
   unit_price_                   ORDER_QUOTATION_LINE_TAB.sale_unit_price%TYPE;
   tab_total_line_discount_      tab_total_line_discount;
   tab_tot_line_disc_excl_tax_   tab_total_line_discount;
   info_                         VARCHAR2(2000);
   currency_rounding_            NUMBER;
   uom_conv_ratio_               NUMBER := 1; 
   sales_part_rec_               Sales_Part_API.Public_Rec;
   
   $IF Component_Crm_SYS.INSTALLED $THEN
      TYPE tab_opportunity_no IS TABLE OF BUSINESS_OPPORTUNITY_LINE_TAB.opportunity_no%TYPE INDEX BY BINARY_INTEGER;
      TYPE tab_revision_no    IS TABLE OF BUSINESS_OPPORTUNITY_LINE_TAB.revision_no%TYPE INDEX BY BINARY_INTEGER;
      TYPE tab_opp_line_no    IS TABLE OF BUSINESS_OPPORTUNITY_LINE_TAB.line_no%TYPE INDEX BY BINARY_INTEGER;
      bo_rec_                 Business_Opportunity_Line_API.Public_Rec; 
      bo_header_rec_          Business_Opportunity_API.Public_Rec;        
      tab_opportunity_no_     tab_opportunity_no;
      tab_opp_line_no_        tab_opp_line_no;
      tab_revision_no_        tab_revision_no;
      opportunity_no_         BUSINESS_OPPORTUNITY_LINE_TAB.opportunity_no%TYPE;
   $END
BEGIN    
   Message_SYS.Get_Clob_Attributes( msg_, count_, names_, values_ );   
   FOR index_ IN 1 .. count_ LOOP               
      IF names_( index_ ) = 'QUOTATION_NO' THEN
         n_ := n_ + 1;         
         tab_quotation_no_(n_) := values_( index_ );
         quotation_no_ := tab_quotation_no_(n_);
      ELSIF names_( index_ ) = 'LINE_NO' THEN
         tab_line_no_(n_) := values_( index_ );
      ELSIF names_( index_ ) = 'REL_NO' THEN
         tab_rel_no_(n_) := values_( index_ );
      ELSIF names_( index_ ) = 'LINE_ITEM_NO' THEN
         tab_line_item_no_(n_) := Client_Sys.Attr_Value_To_Number(values_( index_ ));            
      $IF Component_Crm_SYS.INSTALLED $THEN
         ELSIF names_( index_ ) = 'OPPORTUNITY_NO' THEN
            n_ := n_ + 1;
            tab_opportunity_no_(n_) := values_( index_ ); 
            opportunity_no_  := tab_opportunity_no_(n_);  
         ELSIF names_( index_ ) = 'REVISION_NO' THEN
            tab_revision_no_(n_) := values_( index_ );         
         ELSIF names_( index_ ) = 'OPP_LINE_NO' THEN         
            tab_opp_line_no_(n_) := values_( index_);                  
      $END
      END IF;
   END LOOP;     
   Client_Sys.Clear_Attr(attr_new_); 
   IF (source_ = 'SQ') THEN
      sq_head_rec_ := Order_Quotation_API.Get(quotation_no_);
   ELSIF (source_ = 'BO') THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         bo_header_rec_   := Business_Opportunity_API.Get(opportunity_no_);                  
      $ELSE
         NULL;
      $END
   END IF;   
   message_   := Message_Sys.Construct('MAIN MESSAGE');
   FOR index_ IN 1 .. n_ LOOP      
      info_ := NULL;
      IF (source_ = 'SQ') THEN         
         sq_rec_ := Order_Quotation_Line_API.Get(tab_quotation_no_(index_), tab_line_no_(index_), tab_rel_no_(index_), tab_line_item_no_(index_));
         sales_part_rec_ := Sales_Part_API.Get(sq_rec_.contract,sq_rec_.catalog_no);
         uom_conv_ratio_ := (sales_part_rec_.conv_factor/sales_part_rec_.inverted_conv_factor)/ sales_part_rec_.price_conv_factor ;                                                                      
         IF (sq_head_rec_.use_price_incl_tax = 'TRUE') THEN                
            IF (sq_rec_.tax_liability_type = 'TAX') THEN  
               total_tax_percentage_ := NVL(Source_Tax_Item_API.Get_Total_Tax_Percentage(sq_rec_.company, Tax_Source_API.DB_ORDER_QUOTATION_LINE, tab_quotation_no_(index_), 
                                                                              tab_line_no_(index_), tab_rel_no_(index_), TO_CHAR(tab_line_item_no_(index_)), '*'),0);
            END IF;            
            IF adjust_price_ = '1' THEN 
               IF (sq_rec_.discount != 100) THEN
                  base_unit_price_incl_tax_ := (((1 + NVL(total_tax_percentage_/100, 0)) * sq_rec_.cost * uom_conv_ratio_)/ (1 - margin_percent_/100)) * (1/(1 - sq_rec_.discount/100 - ((NVL(sq_rec_.additional_discount, 0)/100 + sq_rec_.quotation_discount/100)* (1 - sq_rec_.discount/100))));                                                        
               ELSE
                  base_unit_price_incl_tax_ := sq_rec_.base_unit_price_incl_tax;
               END IF;
               tab_discount_(index_) := sq_rec_.discount;                
            ELSE
               IF Order_Quote_Line_Discount_API.Get_Discount_Line_Count(tab_quotation_no_(index_), tab_line_no_(index_), tab_rel_no_(index_), tab_line_item_no_(index_)) > 1 THEN
                  info_                 := 'MULTI_DISCOUNT';
                  base_unit_price_incl_tax_  := sq_rec_.base_unit_price_incl_tax;
                  tab_discount_(index_) := sq_rec_.discount;
               ELSE                     
                  base_unit_price_incl_tax_  := sq_rec_.base_unit_price_incl_tax;                  
                  tab_discount_(index_) := (((((1 + (total_tax_percentage_/100)) * sq_rec_.cost  * uom_conv_ratio_)/(sq_rec_.base_unit_price_incl_tax * (1 - margin_percent_/100))) + (((NVL(sq_rec_.additional_discount, 0) + sq_rec_.quotation_discount)/100) - 1))/(((NVL(sq_rec_.additional_discount, 0) + sq_rec_.quotation_discount)/100) - 1)) * 100;                                
               END IF;               
            END IF;            
            Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(unit_price_incl_tax_, 
                                                                   sq_rec_.currency_rate,
                                                                   sq_rec_.customer_no,
                                                                   sq_rec_.contract,
                                                                   sq_head_rec_.currency_code,
                                                                   base_unit_price_incl_tax_);             
            Calculate_Discount___(tab_total_line_discount_(index_), tab_quotation_no_(index_), tab_line_no_(index_), tab_rel_no_(index_), tab_line_item_no_(index_), tab_discount_(index_), base_unit_price_incl_tax_, sq_rec_.buy_qty_due, sq_rec_.price_conv_factor);            
            Calculate_Discount___(tab_tot_line_disc_excl_tax_(index_), tab_quotation_no_(index_), tab_line_no_(index_), tab_rel_no_(index_), tab_line_item_no_(index_), tab_discount_(index_), base_unit_price_incl_tax_, sq_rec_.buy_qty_due, sq_rec_.price_conv_factor, TRUE);                        
         ELSE               
            IF adjust_price_ = '1' THEN 
               IF (sq_rec_.discount != 100) THEN
                  base_unit_price_ := sq_rec_.cost * uom_conv_ratio_ / ((1 - margin_percent_/100) * (1 - sq_rec_.discount/100) * (1 - (NVL(sq_rec_.additional_discount, 0)/100 + sq_rec_.quotation_discount/100)));                                 
               ELSE
                  base_unit_price_ := sq_rec_.base_sale_unit_price;
               END IF;
               tab_discount_(index_) := sq_rec_.discount;                              
            ELSE
               IF Order_Quote_Line_Discount_API.Get_Discount_Line_Count(tab_quotation_no_(index_), tab_line_no_(index_), tab_rel_no_(index_), tab_line_item_no_(index_)) > 1 THEN
                  info_                 := 'MULTI_DISCOUNT';
                  base_unit_price_      := sq_rec_.base_sale_unit_price;
                  tab_discount_(index_) := sq_rec_.discount;
               ELSE
                  base_unit_price_      := sq_rec_.base_sale_unit_price;                  
                  tab_discount_(index_) := (1 - (sq_rec_.cost * uom_conv_ratio_ / (sq_rec_.base_sale_unit_price * (1 - margin_percent_/100) * (1 - (NVL(sq_rec_.additional_discount, 0)/100 + sq_rec_.quotation_discount/100)))) ) * 100;                                 
               END IF;               
            END IF;
            
            Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(unit_price_, 
                                                                   sq_rec_.currency_rate,
                                                                   sq_rec_.customer_no,
                                                                   sq_rec_.contract,
                                                                   sq_head_rec_.currency_code,
                                                                   base_unit_price_);            
            
            Calculate_Discount___(tab_total_line_discount_(index_), tab_quotation_no_(index_), tab_line_no_(index_), tab_rel_no_(index_), tab_line_item_no_(index_), tab_discount_(index_), base_unit_price_, sq_rec_.buy_qty_due, sq_rec_.price_conv_factor);                        
            tab_tot_line_disc_excl_tax_(index_) := tab_total_line_discount_(index_);             
         END IF;   
         
         Order_Quotation_Line_API.Calculate_Prices(unit_price_, unit_price_incl_tax_, base_unit_price_, base_unit_price_incl_tax_, tab_quotation_no_(index_), tab_line_no_(index_), tab_rel_no_(index_), tab_line_item_no_(index_));
         tab_unit_price_(index_)               := unit_price_;
         tab_unit_price_incl_tax_(index_)      := unit_price_incl_tax_;
         tab_base_unit_price_(index_)          := base_unit_price_;
         tab_base_unit_price_incl_tax_(index_) := base_unit_price_incl_tax_;
         
         IF save_ = 'TRUE' THEN
            currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(sq_head_rec_.company, sq_head_rec_.currency_code);        
            Client_Sys.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('SALE_UNIT_PRICE', ROUND(tab_unit_price_(index_), currency_rounding_), attr_);
            Client_SYS.Add_To_Attr('UNIT_PRICE_INCL_TAX', ROUND(tab_unit_price_incl_tax_(index_), currency_rounding_), attr_);
            Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', ROUND(tab_base_unit_price_(index_), currency_rounding_), attr_);
            Client_SYS.Add_To_Attr('BASE_UNIT_PRICE_INCL_TAX', ROUND(tab_base_unit_price_incl_tax_(index_), currency_rounding_), attr_);               
            Client_SYS.Add_To_Attr('DISCOUNT', tab_discount_(index_), attr_);  
            Client_SYS.Add_To_Attr('PRICE_FREEZE_DB', 'FROZEN', attr_);
            Order_Quotation_Line_API.Modify(attr_, tab_quotation_no_(index_), tab_line_no_(index_), tab_rel_no_(index_), tab_line_item_no_(index_));                  
         END IF;
         
         sub_message_ := Message_Sys.Construct('OUTPUT_DATA');         
        
         Message_Sys.Add_Attribute(sub_message_, 'QUOTATION_NO', tab_quotation_no_(index_));
         Message_Sys.Add_Attribute(sub_message_, 'LINE_NO', tab_line_no_(index_));
         Message_Sys.Add_Attribute(sub_message_, 'REL_NO', tab_rel_no_(index_));
         Message_Sys.Add_Attribute(sub_message_, 'LINE_ITEM_NO', tab_line_item_no_(index_));
         Message_Sys.Add_Attribute(sub_message_, 'SALE_UNIT_PRICE', tab_unit_price_(index_));
         Message_Sys.Add_Attribute(sub_message_, 'UNIT_PRICE_INCL_TAX', tab_unit_price_incl_tax_(index_));
         Message_Sys.Add_Attribute(sub_message_, 'BASE_SALE_UNIT_PRICE', tab_base_unit_price_(index_));
         Message_Sys.Add_Attribute(sub_message_, 'BASE_UNIT_PRICE_INCL_TAX', tab_base_unit_price_incl_tax_(index_));
         Message_Sys.Add_Attribute(sub_message_, 'DISCOUNT', tab_discount_(index_));
         Message_Sys.Add_Attribute(sub_message_, 'DISCOUNT_AMOUNT', tab_total_line_discount_(index_));
         Message_Sys.Add_Attribute(sub_message_, 'DISC_AMOUNT_EXCL_TAX', tab_tot_line_disc_excl_tax_(index_));
         Message_Sys.Add_Attribute(sub_message_, 'INFO', info_);                
         
         line_count_ := line_count_ + 1;
         Message_Sys.Add_Clob_Attribute(message_, TO_CHAR(count_) , sub_message_);            
      ELSIF (source_ = 'BO') THEN
         $IF Component_Crm_SYS.INSTALLED $THEN            
            bo_rec_   := Business_Opportunity_Line_API.Get(tab_opportunity_no_(index_), tab_revision_no_(index_), tab_opp_line_no_(index_));
                        
            IF bo_rec_.non_exist_part = Fnd_Boolean_API.DB_TRUE THEN
               uom_conv_ratio_ := 1;
            ELSE
               sales_part_rec_ := Sales_Part_API.Get(bo_rec_.contract,bo_rec_.catalog_no);
               uom_conv_ratio_ := (sales_part_rec_.conv_factor/sales_part_rec_.inverted_conv_factor)/ sales_part_rec_.price_conv_factor ;
            END IF;
            
            IF adjust_price_ = '1' THEN   
               IF (bo_rec_.discount != 100 OR bo_rec_.discount IS NULL) THEN                  
                  tab_base_unit_price_(index_) := NVL(bo_rec_.cost * uom_conv_ratio_,0) / ((1 - margin_percent_/100) * (1 - NVL(bo_rec_.discount,0)/100) * ( 1- NVL(bo_rec_.additional_discount, 0)/100));                                 
               ELSE                  
                  tab_base_unit_price_(index_) := bo_rec_.base_sale_unit_price;                  
               END IF;
               tab_discount_(index_) := bo_rec_.discount;               
            ELSE
               tab_discount_(index_)        := 100 - (NVL(bo_rec_.cost * uom_conv_ratio_,0) * 100 / (bo_rec_.base_sale_unit_price * (1 - margin_percent_/100)* ( 1- NVL(bo_rec_.additional_discount, 0)/100)));                              
               tab_base_unit_price_(index_) := bo_rec_.base_sale_unit_price;                 
            END IF;
            tab_unit_price_(index_) := Business_Opportunity_API.Get_Curr_Opportunity_Value(bo_header_rec_.customer_id, bo_header_rec_.company, bo_header_rec_.currency_code, tab_base_unit_price_(index_));
            IF save_ = 'TRUE' THEN         
               Client_Sys.Clear_Attr(attr_);            
               Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', tab_base_unit_price_(index_), attr_);
               Client_SYS.Add_To_Attr('DISCOUNT', tab_discount_(index_), attr_);  
               Client_SYS.Add_To_Attr('PRICE_FREEZE_DB', 'FROZEN', attr_);
               Business_Opportunity_Line_API.Modify(info_, attr_, tab_opportunity_no_(index_), tab_opp_line_no_(index_));                  
            END IF;
            sub_message_ := Message_Sys.Construct('OUTPUT_DATA');                     
            
            Message_Sys.Add_Attribute(sub_message_, 'OPPORTUNITY_NO', tab_opportunity_no_(index_));
            Message_Sys.Add_Attribute(sub_message_, 'REVISION_NO', tab_revision_no_(index_));
            Message_Sys.Add_Attribute(sub_message_, 'LINE_NO', tab_opp_line_no_(index_));            
            Message_Sys.Add_Attribute(sub_message_, 'SALE_UNIT_PRICE', tab_unit_price_(index_));            
            Message_Sys.Add_Attribute(sub_message_, 'BASE_SALE_UNIT_PRICE', tab_base_unit_price_(index_));            
            Message_Sys.Add_Attribute(sub_message_, 'DISCOUNT', tab_discount_(index_));            
            line_count_ := line_count_ + 1;
            Message_Sys.Add_Clob_Attribute(message_, TO_CHAR(count_) , sub_message_);            
         $ELSE
            NULL;
         $END
      END IF;
      
   END LOOP;
   RETURN message_;         
END Calculate_Margin_Values;

-- gelr:disc_price_rounded, begin
-- Calculate_Additional_Discount
--    This method should be called only if the DISC_PRICE_ROUNDED localization parameter is enabled
FUNCTION Calculate_Additional_Discount (
   contract_            IN VARCHAR2,
   currency_code_       IN VARCHAR2,
   additional_discount_ IN NUMBER,
   buy_qty_due_         IN NUMBER,
   price_conv_factor_   IN NUMBER,
   sale_unit_price_     IN NUMBER,
   discount_            IN NUMBER  ) RETURN NUMBER
IS
   additional_discount_per_unit_ NUMBER;
   additional_discount_amount_ NUMBER;
   new_additional_discount_    NUMBER;
   rounding_                   NUMBER;
   price_qty_                  NUMBER;
   discounted_unit_price_      NUMBER;
   discounted_price_           NUMBER;

BEGIN
   -- Note: This method should be called only if the DISC_PRICE_ROUNDED localization parameter is enabled
   rounding_ := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(contract_), currency_code_);
   price_qty_ := buy_qty_due_*price_conv_factor_;
   
   -- price after "normal" disocunt will be taken as the base for additional discount
   discounted_unit_price_ := ROUND(sale_unit_price_*(1-discount_/100), rounding_); 
   discounted_price_      := ROUND((discounted_unit_price_*price_qty_), rounding_);
   
   
   -- Recalculate additional discount
   IF discounted_price_ = 0 THEN
      new_additional_discount_ := 0;
   ELSE
      additional_discount_per_unit_ := ROUND(discounted_unit_price_ * (additional_discount_/100), rounding_);
      additional_discount_amount_ := ROUND((additional_discount_per_unit_ * price_qty_), rounding_);

      new_additional_discount_ := additional_discount_amount_ / discounted_price_ * 100;
   END IF;

   RETURN new_additional_discount_;
END Calculate_Additional_Discount;
-- gelr:disc_price_rounded, end
