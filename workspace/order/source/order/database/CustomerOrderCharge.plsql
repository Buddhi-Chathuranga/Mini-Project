-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderCharge
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211228  NiDalk  Bug 161737(SCZ-17041), Introduced new Get_Tot_Base_Chg_Amt_Incl_Tax, Get_Total_Charged_Amount___ and Get_Total_Charged_Amt_Incl_Tax___ to calculate charge amounts with input parameters
--  211228          without fetching them to improve performance.
--  211108  ChWkLk  Bug 161540(MFZ-9150), Removed Check_Demand_Code___() and the referenced calls for it in Check_Insert___() and Check_Update___() to allow 
--                  customer order creation for charge connected Company Owned CRO Exchange parts. 
--  210520  KiSalk  Bug 158901(SCZ-15337), Added Update_Connected_Foc_Db and Set_Foc_And_Charge_Amounts___, set free_of charge in Prepare_Insert___, Check_Insert___,
--  210520          Insert___ and Update___. Modified Get_Default_Charge_Attr___ to round values depending on new attr_ values company and round_amounts.
--  210625  Skanlk  Bug 159759(SCZ-15309), Modified Copy_Charge_Lines to set the charge_percent_basis and base_charge_percent_basis as null to resolve the issue when copying 
--  210625          customer order charges with a charge percentage.
--  210305  ErFelk  Bug 156198(SCZ-12927), Modified Get_Base_Charged_Cost() by passing default null parameters inv_net_curr_amount_ and invoiced_quantity_. This was done to
--  210305          calculate sales_charge_cost_ and base_charge_cost_ using modified latest invoice values. 
--  210126  Skanlk  SCZ-13308, Modified Copy_Charge_Lines() to prevent copying Returned Qty from the original CO while executing Copy Order.
--  210108  MaEelk  SC2020R1-12004, Replaced the logic written inside Update_Connected_Charged_Qty with Modify___.
--  200625  NiDalk  SCXTEND-4438, Modified Insert___ to avoid fetch of taxes during insert when company_tax_control.fetch_tax_on_line_entry for Avalara sales tax is set to false.
--  200625          When attr_ has UPDATE_TAX set to false in Insert___ and Update___ that means taxes are fetched from a bundle call.
--  200505  ThKrLk  Bug 153087 (SCZ-9625), Modified Remove() and Check_Delete___() methods to get new parameter and added new condition in Check_Delete___().
--  200505          And modified Validate_Source_Pkg_Info() method by changing the order of ELSEIF.
--  200225  ErFelk  Bug 152250 (SCZ-8648), Added new function Check_Connected_Unit_Charges(). 
--  200131  Erlise  SCXTEND-1768, Added evaluation of line connection changes in Update() to force a recalculation of the tax lines.
--  200127  ThKrLk  Bug 150623 (SCZ-7909), Modified Get_Base_Charged_Cost() to get the correct invoice date when it uses debit invoice date to calculate the RMA charge cost.
--  200127  Erlise  SCXTEND-1516, Modified method Add_Transaction_Tax_Info() to avoid unnecessary calls to the external tax system.
--  190115  Hairlk  SCXTEND-1770, Modified Update___,  when there is a change in the charge type added code to remove tax lines for old charge type and refetch tax lines for the new one.
--  191022  Hairlk  SCXTEND-876, Modified Prepare_Insert___, added code to fetch CUSTOMER_TAX_USAGE_TYPE from the header and added it to the attr.
--  191018  ApWilk  Bug 150399 (SCZ-7312), Modified Check_Delete___ and Delete___ to allow for deleting an uninvoiced sales promotion charge line. 
--  191003  Hairlk  SCXTEND-876, Avalara integration, Added Get_Co_Line_Cust_Tax_Usg_Type. Modified Insert___, Added code to fetch customer_tax_usage_type from customer if its not available in the attr.
--                  Modified Update___, Added customer_tax_usage_type to the condition when changed will recalculate the tax amount for the changed line.
--  190927  SURBLK  Added Raise_Charge_Modify_Error___ to handle error messages and avoid code duplication.
--  190413  NipKlk  Bug 147864 (SCZ-4205), Added a method Remove_Charge_Lines_If_Exist to delete the customer order line connected charge lines 
--  190413          when deleting the existing CO line upon adding the new line with substitute part. 
--  190106  UdGnlk  Bug 144611, Modified Validate_Prepayment___() messages to be more meaningful.  
--  180221  ApWilk  STRSC-17295, Changed END name of Copy_Charge_Lines() exactly the same as the method name.
--  180209  KoDelk  STRSC-15901, When creating tax lines for invoice use the current currency rate rather than using the source line currency rate.
--  180202  RaVdlk   STRSC-16673, Copied the document text of charge lines if 'Document text' copy option is selected and renamed Copy_Charges_Lines as Copy_Charge_Lines
--  180112  ApWilk  Bug 139371, Modified Get_Base_Charged_Cost() to do the cost calculation by considering the delivered quantity when there is a total or partial delivery rather taking the qty as a total.
--  171227  MAHPLK  STRFI-10886, Added new method Get_External_Tax_Info(), Added two our parameters to Get_Line_Address_Info(),
--  171227          Modified Insert___ and Update___ methods to fetch taxes from defaults when external tax calculation system has been used. 
--  171025  RaVdlk  STRSC-13733, Made the invoiced quantity zero when copying the charge lines.
--  171024  MalLlk  STRSC-12754, Removed the methods Get_Line_Total_Base_Amount().
--  171016  DiKuLk  Bug 138039, Modified Check_Update___() message constant from NOORDERFREIGT to NOFREIGTCOL in order to avoid overriding of language translations and added Raise_Freight_Charge_Error___() procedure
--  171016          for the message constant NOORDERFREIGT.
--  170928  IzShlk  STRSC-12264, Introduced Copy_Charges_Lines__() to copy charges from order.
--  170626  ErRalk  Bug 135979, Changed the error message constant from NOORDERFREIGT to NOFREIGTCOL in Check_Insert___ and modified message content of CHARGEQTYNOTZERO message in Check_Update___ and removed space in NOTAXFREECODE message constant.
--  170305  SURBLK   Modified Do_Additional_Validations___() by changing the error message when charge_type_category_ is PROMOTION.
--  170202  IsSalk  STRSC-5655, Modified Calculate_Charges___() to prevent calculating prices when creating Charge lines from Sales Quotation.
--  170125  slkapl  FINHR-5388, Implement Tax Structures in Sales Promotions
--  170103  NWeelk  FINHR-5248, Introduced Tax Calculation Structures.
--  161130  PrYaLK  Bug 132907, Modified Get_Base_Charged_Cost() to change the cost calculation logic by considering the invoiced order quantity.
--  161024  SeJalk  Bug 132047, Modified Check_Update___ to raise error when updating invoiced charge line except changing statistical_charge_diff.  
--  160920  NWeelk  FINHR-2990, Added method Get_Promo_Amounts to calculate gross_base and gross_curr amounts.
--  160725  RoJalk  LIM-8141, Replaced the usage of Shipment_Line_API.Check_Exist_Source with Shipment_Line_API.Source_Exist.
--  160628  MalLlk  FINHR-1818, Added methods Get_Line_Total_Base_Amount and Get_Line_Address_Info.
--  160510  SURBLK  Added Do_Additional_Validations___().
--  160428  RoJalk  LIM-6952, Removed Shipment_Line_API.Is_Charge_Allowed and replaced the usage with Shipment_Line_API.Check_Exist_Source.
--  160211  IsSalk  FINHR-685, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Charge.
--  160201  SBalLK  Bug 125958, Added Get_Base_Charged_Cost() procedure to get charge cost amounts in Base Currency for create invoice postings and
--  160201          invoiced sales statistics. Removed Get_Base_Charged_Cost() function.
--  160118  IsSalk  FINHR-657, Used FndBoolean in taxable attribute in Sales Charge Type.
--  160111  IsSalk  FINHR-581, Renamed column FEE_CODE to TAX_CODE in SALES_CHARGE_TYPE_TAB.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151103  SURBLK  FINHR-317, Modified fee_code_changed_ in to tax_code_changed_.
--  150626  Hecolk  KES-779, Handling charges when Cancelling preliminary CO Invoice
--  150625  ChBnlk  ORA-892, Modified Copy_From_Sales_Part_Charge() and Copy_From_Customer_Charge() by moving the attribute string manipulation to seperate method. Introduced new methods Build_Attr_Copy_SP_Chg___()
--  150625          and Build_Attr_Copy_Cust_Chg___() for the attr_ manipulation. 
--  150910  ErFelk  Bug 123263, Modified Validate_Fee_Code___() so that Vat_Free_Vat_Code is fetched to the charge line from the customer order if the
--  150910          Customer Order is Single Occurrence. 
--  150724  ErFelk  Bug 122380, Modified Check_Update___() so that error CHARGEINVOICED: is not raise when unit charge is TRUE.
--  150327  NWeelk  Bug 121800, Modified methods Add_All_Tax_Lines and Remove_Tax_Lines to select only the not fully invoiced charge lines 
--  150327          for addition and removal of tax lines since no changes should be applied after the charge line is fully invoiced. 
--  150216  JeLise  PRSC-5818, Added call to Cust_Ord_Charge_Tax_Lines_API.Modify_Charge_Line_Fee_Code in both Remove_Tax_Lines.
--  150128  SlKapl  PRSC-5757, Modified Update___ to avoid problem with tax calculation for percentage charges
--  150102  SlKapl  PRFI-4296, Added new parameter of method call Cust_Ord_Charge_Tax_Lines_API.New
--  141224  RasDlk  PRSC-4771, Removed rounding from Get_Base_Charged_Cost.
--  140620  BudKlk  Bug 117462, Modified the method Update___() to change the customer order state according to the behavior of the Collect checkbox
--  140620          on Customer Order Charges and replaced the method New_Charge_Added() from  New_Or_Changed_Charge().
--  141013  SlKapl  FIPR19 Multiple tax handling in CO and PO flows - improved Get_Total_Charged_Amount and Get_Total_Charged_Amt_Incl_Tax by removing redundant code
--  141008  SlKapl  FIPR19 Multiple tax handling in CO and PO flows - prepare Customer Order for Localization Hooks, renamed Cust_Ord_Charge_Tax_Lines_API.Add_Tax_Lines to Cust_Ord_Charge_Tax_Lines_API.Add_Sales_Tax_Lines
--  140905  SlKapl  FIPR19 Multiple tax handling in CO and PO flows - changed Get_Total_Charged_Amount, Get_Total_Base_Charged_Amount, Get_Total_Charged_Amt_Incl_Tax, Get_Tot_Base_Chg_Amt_Incl_Tax to handle both setups with/without Price Including Tax used.
--  140812  SlKapl  FIPR19 Multiple tax handling in CO and PO flows - replaced Customer_Order_Line_API.Get_Total_Tax_Amount by Customer_Order_Line_API.Get_Total_Tax_Amount_Curr
--                  renamed Get_Total_Tax_Amount to Get_Total_Tax_Amount_Curr changed Get_Total_Tax_Amount_Base and Get_Total_Tax_Amount_Curr 
--                  in order to retrieve tax amount directly from cust_ord_charge_tax_lines_tab without calculation
--  140610  JanWse  PRSC-991, Only calculate next sequence_no if sequence_no is null, in insert___
--  140417  MaRalk  Bug 114913 Merged to APP9. 
--  140417          Modified Validate_Fee_Code___() by removing vat_db_ = 'Y' from a condition so that sales charge_type's fee code 
--  140417          is fetched when the part is non taxable. 
--  140320  NiDalk  Bug 112499, Added function Get_Total_Tax_Amount_Base to calculate total tax amount per charge line in base currency.
--  140225  AyAmlk  Bug 114313, Modified Post_Update_Actions___() by altering the condition to allow add and remove Sales tax lines if there is a
--  140225          qty/amount change only when Vertex Sales Tax Q Series is used.
--  131211  RoJalk   Replaced the usage of Get_Addr_Flag with Get_Addr_Flag_Db.
--  130925  MalLlk  Bug 111242, Added functions Get_Co_Line_Project_Id and Get_Co_Line_Activity_Seq to return project id and activity seq 
--  130925          in the CO line which connected to the CO Charge line.
--  130813  MaMalk  Modified the error text given by message constant NOREMOVEINVCHARGE to make it more meaningful.
--  130725  IsSalk  Bug 107531, Added column STATISTICAL_CHARGE_DIFF and modified Unpack_Check_Insert__, Unpack_Check_Update__, Insert___ 
--  130725          and Update___methods to store the receiving country charges which is using when collecting intrastat. Modified Prepare_Insert___, 
--  130725          Copy_From_Sales_Part_Charge and Copy_From_Customer_Charge by adding default value as zero to STATISTICAL_CHARGE_DIFF.
--  130725          Modified Unpack_Check_Update__ to allow updating STATISTICAL_CHARGE_DIFF though it is invoiced or cancelled. 
--  130705  MaIklk  TIBE-974, Removed inst_Jinsui_ and inst_OnAccountLedgerItem_ global constants. Used conditional compilation instead.
--  130322  IsSalk  Bug 108922, Made implementation method Validate_Jinsui_Constraints___() private. Added parameter company_max_jinsui_amt_ to the 
--  130322          method Validate_Jinsui_Constraints__(). Modified methodsValidate_Jinsui_Constraints__(), Insert___() and Update___() in order to 
--  130322          perform validation with the Jinsui Invoice Constraints for all the charge lines in a CO.
--  120913  SURBLK  Added use_price_incl_tax_db to LOVVIEW.
--  120816  ShKolk  Added method Calculate_Charges to recalculate charge amounts.
--  120815  ShKolk  Added functions Get_Total_Charged_Amt_Incl_Tax and Get_Tot_Base_Chg_Amt_Incl_Tax to return including tax values.
--  120808  SURBLK  Modified prices fetching according to 'use price incl tax'.
--  120803  SURBLK  Added columns charge_amount_incl_tax and base_charge_amt_incl_tax.
--  130606  ChJalk  EBALL-72. Added new method Check_Demand_Code___ and called it in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  130521  ChJalk  EBALL-72, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to add the validation and introduce the error message NO_CHRG_CRO when trying to connect a charge line to a 
--  130521          part exchange order line.
--  120423  Darklk  Added the procedure Refresh_Fee_Code.
--  120419  Darklk  Bug 101806, Added a new parameter to the procedure Modify_Invoiced_Qty and modified the procedure Update___ to encapsulate the CO state transition.
--  120314  DaZase  Added Init_Method calls to methods Get_Promo_Gross_Amount_Base and Get_Promo_Gross_Amount_Curr since they cant have pragma.
--  120104  NaLrlk  Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___ to handle collect fro freight charges.
--  111202  DaZase  Added methods Get_Promo_Charged_Qty, Get_Promo_Net_Amount_Curr, Get_Promo_Net_Amount_Curr, Get_Promo_Gross_Amount_Base, Get_Promo_Gross_Amount_Curr.
--  111202  MaMalk  Added pragma to Get_Total_Base_Charged_Amount.
--  110928  MaMalk  Modified Unpack_Check_Update___ to introduce an error message for freight charges when changing the value 
--  110928          of collect which is different to the value of delivery terms.
--  110920  MaMalk  Modified Copy_From_Sales_Part_Charge to exclude CO lines when the part ownership is not Company Owned.
--  110712  ChJalk  Added user_allowed_site filter to the view SUBSTITUTE_SALES_PART2.
--  110707  MaMalk  Added the user allowed site filteration on customer_order_charge_lov.
--  110701  KiSalk  Bug 96918, Set Get_Total_Charged_Amount to return 0 if CO is cancelled.
--  110526  MiKulk  Removed the restriction added from bug 91146 for the internal customer order of same company.
--  110523  MaMalk  Modified Validate_Fee_Code___ to consider the supply country when no value for the delivery country is found for the tax class.
--  110511  NaLrlk  Modified the method Copy_Order_Line_Tax_Lines to calculate correct tax amount for each charge tax lines.
--  110321  MaMalk  Modified Get_Default_Charge_Attr___ to pack the delivery_type to the attribute string.
--  110321          Modified Validate_Fee_Code___ and Unpack_Check_Update___ to fetch the taxes when the delivery type is changed.
--  110316  MaMalk  Removed some unwanted code related to tax_class_id.
--  110201  MaMalk  Added methods Get_Connected_Tax_Liability and Get_Connected_Deliv_Country.
--  110124  MiKulk  Modified the tax fetching logic to fix some bugs.
--  110121  MiKulk  Added a new methods Get_Connected_Tax_Liability__, Get_Connected_Deliv_Country__, and Modify_Tax_Class_Id.
--  110118  MiKulk  Added the tax_class_id and changed the tax fetching logic accordingly.
--  101230  MiKulk  Replaced the calls to Customer_Info_Vat_APi with the new methods.
--  100727  Ampalk  Bug 92006, On CUSTOMER_ORDER_CHARGE_LOV used charged_qty instead of invoiced_qty to get available quantity. 
--  100727          On the RMA Charge non-invoiced charges are allowed to insert.
--  100809  ShKolk  Modified Get_Default_Charge_Attr___(), removed fee_code from attr_.
--  100702  PaWelk  Bug 91146, Modified Unpack_Check_Insert___() and Unpack_Check_Update___() to raise errors relevant to charged items.
--  100716  ChFolk  Modified usages of Cust_Ord_Charge_Tax_Lines_API.Add_Tax_Lines as the parameters are changed.
--  100701  ChFolk  Modified Copy_Order_Line_Tax_Lines to change the parameters of method call Cust_Ord_Charge_Tax_Lines_API.New.
--  100701          Made Get_Connected_Address_Id__ to public.
--  100716  KiSalk  Message text of 'NONTAXABLE' changed to 'Tax code should be of ...' from 'Tax code be of ...'. 
--  100716          Set newrec_ to NULL within the loops in Copy_From_Sales_Part_Charge and Copy_From_Customer_Charge.
--  100517  Ajpelk  Merge rose method documentation
--  100430  NuVelk  Merged Twin Peaks
--  091007  KaEllk  Renamed Report_Revenue to Calculate_Revenue.
--  090930  ShRalk  Modified Insert___,Update___ and Delete___ to calculate revenue when the charge line is connected to CO line.          
--  100419  MaGuse  Bug 89278, Modified method Add_All_Tax_Lines by removing IN parameter single_occ_ and modified methods Insert___,   
--  100419          Post_Update_Actions___ and Add_All_Tax_Lines by removing sending single_occ_ to the method call Cust_Ord_Charge_Tax_Lines_API.Add_All_Tax_Lines. 
--  100405  NWeelk  Bug 89874, Modified procedure Validate_Fee_Code___ to retrieve temp_fee_code_ correctly when approving the internal CO. 
--  100215  AmPalk  Bug 87931, Added currency_rate as a public attribute. Update of the column is with the changes to prices (charge amounts),  
--  100215          charge quantity or connected order line on client windows. Removed Invoice_Library_API.Get_Currency_Rate_Defaults calls 
--  100215          from data populates. Instead used saved value as the currency rate.
--  100310  KiSalk   charge (percentage) included in the condition to raise pack size charge change error in Modify__
--  090922  AmPalk  Bug 70316, Modified Get_Total_Base_Charged_Amount. In it made base amounts to get calculated considering curr amounts and the currency rate as in the INVOIC side.
--  090922          Added rounding to Get_Total_Tax_Amount.
--  090512  NWeelk  Bug 81195, Added procedure Remove to use when removing the connected charge lines for a customer order line.
--  091110  KiSalk  NVL added to fee_code comparision in modify__.
--  090930  DaZase  Added length on view comment for charge_price_list_no.
--  090930  MiKulk  Modified the Unpack_Check_Update___ to allow changing charges of all categories. 
--  090817  HimRlk  Addes Server_data_change and modified Unpack_Check_Insert___ and Unpack_Check_Update___.
--  090804  KiSalk  Added Get_Base_Charged_Cost.
--  090131  MaRalk  Bug 79753, Modified methods Copy_From_Customer_Charge and Copy_From_Sales_Part_Charge to retrieve charge_cost correctly.
--  081215  ChJalk  Bug 77014, Modified and added General_SYS.Init_Method to Get_Total_Base_Charged_Amount.
--  081001  SuJalk  Bug 74635, Added delivery type to the LU. Added method Check_Delivery_Type__. Added delivery type to methods Copy_From_Customer_Charge and
--  081001          Copy_From_Sales_Part_Charge in order to pass the delivery type when creating a new Customer Order Charge.
--  080620  SuJalk  Bug 74879, Modified the IF condition to stop showing the error if the tax regime is sales tax in method Validate_Fee_Code___.
--  080526  ChJalk  Bug 72771, Modified methods Post_Update_Actions___ and Add_Tax_Lines to add the last paremeter in call to Cust_Ord_Charge_Tax_Lines_API.Add_Tax_Lines.
--  090708  ShKolk  Modified Unpack_Check_Insert___() to bypass CHARGEQTYNOTZERO error message when creating temporary charge lines for consolidation logic.
--  090702  RiLase  Added sales promotion charges error message stating that promotion charges can't be removed.
--  090625  RiLase  Added campaign_id and deal_id.
--  090406  KiSalk  Modified methods Copy_From_Customer_Charge and Copy_From_Sales_Part_Charge to retrieve charge_cost and charge_cost_percent correctly.
--  090331  KiSalk  Added Get_Charge_Percent_Basis, Get_Base_Charge_Percent_Basis and modified Modify_Invoiced_Qty to save charge_percent_basis and base_charge_percent_basis
--  090331          when fully invoiced. Changed logic to set line_item_no in Unpack_Check_Insert___ and Unpack_Check_Update___ to allow connect package parts with no components.
--  090324  KiSalk  Added Get_Charge, Get_Charge_Cost_Percent and Get_Total_Base_Charged_Cost. Modified Get_Total_Base_Charged_Amount and Get_Total_Charged_Amount.
--  090319  KiSalk  Added attributes charge and charge_cost_percent and made charge_cost, base_charge_amount and charge_amount nullable; added validations.
--  090109  NaLrlk  Added method Copy_Order_Line_Tax_Lines to copy order line tax lines to pack size charge line.
--    081114   MaJalk  At Update___, added CHARGED_QTY to the attr_.
--  081017  AmPalk  Modified Modify_Invoiced_Qty to append new invoiced qtys to exist.
--  081016  AmPalk  Restricted inserts and updates of Freight charges with out CO Line or Freight Info. on sales part.
--  081009  AmPalk  Changed Copy_From_Sales_Part_Charge to get unit_charge_db from sales part charge records.
--    081009   MaJalk  At Unpack_Check_Insert___, corrected the assignment of value for charged_qty.
--  080929  AmPalk  Conditions that were in Unpack_Check_Update___, which set charged quantity to CO line, restricted for Freight Charges updates. This is for consolidation.
--    080829   MaJalk  Modified conditions to raise error message UPDATENOTALLOWED at Modify__.
--    080825   MaJalk  Changed sales_charge_type_category to sales_chg_type_category.
--    080820   MaJalk  Modified Remove() to remove charge tax lines.
--    080818   MaJalk  Modified Unpack_Check_Update___ and Modify__ to handle pack size charge lines.
--    080815   MaJalk  Moved method Get_Pack_Size_Charge_Attr___ to CustomerOrderChargeUtil.apy
--    080815           and modified new(), Update_Connected_Charged_Qty() and Get_Pack_Size_Chg_Line_Seq_No().
--    080808   MaJalk  Added attribute charge_price_list_no and removed sales_charge_type_category.
--    080808           Added method Get_Pack_Size_Chg_Line_Seq_No.
--    080805   MaJalk  Set values for SALES_CHARGE_TYPE_CATEGORY_DB at Copy_From_Customer_Charge and Copy_From_Sales_Part_Charge.
--    080730   MaJalk  Added method Get_Pack_Size_Charge_Attr___ and modified method New.
--    080730   MaJalk  Added attribute sales_charge_type_category.
--  080701  KiSalk   Merged APP75 SP2.
--  ----------------------------- APP75 SP2 Merge - End -----------------------------
--  080526  ChJalk  Bug 72771, Modified methods Post_Update_Actions___ and Add_Tax_Lines to add the last paremeter in call to Cust_Ord_Charge_Tax_Lines_API.Add_Tax_Lines.
--  ----------------------------- APP75 SP2 Merge - Start -----------------------------
--  080605  MiKulk  Added a new method Update_Connected_Charged_Qty
--  080603  MiKulk  Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to add some validations
--  080603          for the charged qty modifications.
--  080603  MiKulk  Added the Unit Charge as a public attribute
--  ---------------------------- Nice Price -----------------------------------
--  071224  MaRalk  Bug 64486, Mofidied functions Copy_From_Customer_Charge, Copy_From_Sales_Part_Charge and Get_Default_Charge_Attr___.
--  071019  LaBolk  Bug 67369, Modified method Update___ to call Cust_Ord_Charge_Tax_Lines_API.Recalculate_Tax_Lines when amount or qty has changed.
--  070425  Haunlk  Checked and added assert_safe comments where necessary.
--  070124  NaWilk  Added implementation methods Validate_Prepayment___ and Post_Update_Actions___ to raise error message PREPAYEXCEED
--  070124          and modified methods Modify, Modify___ and Check_Delete___.
--  061107  MaJalk  Bug 60919, Removed FEE_CODE from attr_ string inside procedure Copy_From_Customer_Charge and Copy_From_Sales_Part_Charge.
--  060626  MalLlk  Added method Get_Intrastat_Exempt_Db.
--  060621  MalLlk  Modified Get to include Intrastat_exempt to the cursor get_attr.
--  060621          Modified Copy_From_Customer_Charge to include Intrastat_exempt attr_.
--  060621          Modified Copy_From_Sales_Part_Charge to include Intrastat_exempt attr_.
--  060621          Modified Prepare_Insert___
--  060526  SeNslk  Modified method Copy_From_Sales_Part_Charge() and added Fee code to attribute string and made invoiced qty to assign 0.
--  060526  KanGlk  Modified Copy_From_Customer_Charge procedure.
--  060525  KanGlk  Renamed method Add_Customer_Charge to Copy_From_Customer_Charge.
--  060524  RaKalk  Modified Add_Customer_Charge method to use charge_amount_base field of Customer_Charge_Table instead of charge_amount.
--  060517  RaKalk  Modified the Add_Customer_Charge and Copy_From_Sales_Part_Charges method to remove the COLLECT field
--  060515  RoJalk  Enlarge Address - Changed variable definitions.
--  060505  SeNslk  Modified method Copy_From_Sales_Part_Charge().
--  060504  KanGlk  Addec method Add_Customer_Charge.
--  060504  SeNslk  Added method Copy_From_Sales_Part_Charge().
--  060419  IsWilk  Enlarge Customer - Changed variable definitions.
--  060418  SaRalk  Enlarge Identity - Changed view comments.
--  --------------------------------- 13.4.0 --------------------------------
--  060306  MiKulk  Modified the Unpack_Check_Update___ and Validate_Fee_Code to handle the non taxable parts.
--  060307          Added the method Modify_Fee_Code.
--  060215  NiDalk  Modified a warning message in Unpack_Check_Insert___.
--  060125  NiDalk  Added Assert safe annotation.
--  060110  CsAmlk  Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  060106  UsRalk  Removed the restriction on self billing lines from Unpack_Check_Insert___ and Unpack_Check_Update___.
--  051202  GeKalk  Modified the error message SALECONCHARGE in Unpack_Check_Insert___.
--  051121  GeKalk  Modified Unpack_Check_Insert___ to add a check for sales contract added orders before adding charge.
--  050928  IsAnlk  Added customer_payer_no as parameter to customer_Order_Pricing_API.Get_Sales_Price_In_Currency call.
--  050922  SaMelk  Removed unused variables.
--  050909  SaMelk  Replace 'Get_Max_Amt_Js_Trans_Batch' with 'Get_Virtual_Inv_Max_Amount'.
--  050803  KanGlk  Changed the error message in Validate_Jinsui_Constraints___ method.
--  050705  KanGlk  Added method Validate_Jinsui_Constraints___ and Modified Insert___ and Update___.
--  050704  KanGlk  Added functions Get_Total_Tax_Amount and Get_Gross_Amount_For_Col.
--  041229  IsAnlk  Removed consignment functionality from customer order.
--  041029  ChJalk  Bug 47613, Added FUNCTION Exist_Charge_On_Order_Line and modified PROCEDURE Delete___.
--  041015  NuFilk  Added method Get_Total_Charge_Tax_Pct.
--  040830  SeJalk  Bug 45357, Changed the cursor in Add_Tax_Lines and Remove_Sales_Tax_Lines methods.
--  040624  MiKulk  Bug 45640, Modifed the methods Modify_Invoiced_Qty and Delete___.
--  040607  MiKalk  Bug 41488, Modified method Insert___ to call method New_Charge_Added in Customer_Order_API.
--  040607          Modified method Modify_Invoiced_Qty, Delete___ and Update___ to add Customer_Order_API.Check_State.
--  040603  GaJalk  Bug 43315, Modified the Unpack_Check_Update___ and Unpack_Check_Insert___.
--  040220  ErSolk  Bug 40425, Modified procedure Update___ to recalculate tax when charge line is modified.
--  040218  IsWilk  Removed the SUBSTRB from the views for Unicode Changes.
--  021017  Prinlk  Modified the self_billing restriction. Removed the cursor.Replaced with a function call.
--  021008  Prinlk  Added restictions when adding and modifying charges to a self billing order line.
--  020305  Prinlk  Added the control not to connect lines to charges which is not specified
--                  in the stated shipment.
--  020304  Prinlk  Added the possibility to add charges when consignment or shipment defined.
--  020115  Prinlk  Added the field Shipment_Id. Disallow the user to enter both
--                  shipment_id and consignment_id.
--  ********************* VSHSB Merge *****************************
--  030912  MiKulk  Bug 38102, Modified procedure Insert___ to transfer DocummentText from quotation.
--  030729  JaJalk  Performed SP4 Merge.
--  030513  ChFolk  Modified an error message in Validate_Fee_Code___.
--  030506  ChFolk  Call ID 96789. Modified the inconsistent error messages.
--  030502  ChFolk  Modified Validate_Fee_Code___ to add an error message when customer tax regime is VAT/MIX but fee_code is null.
--  030429  ChFolk  Modified PROCEDURE Modify__ to add sales tax lines when order line is connected to a charge line.
--  030422  PrJalk  Bug 36603, Changed Add_Tax_Lines(order_no_,line_no_,rel_no_,line_item_no_,company_,customer_no_,ship_addr_no_)
--  030422          added if condition to prevent adding tax lines if charge_type is non taxable.
--  030417  ChFolk  Modified procedure Modify__ to added new if condition before adding new tax lines.
--  030411  ChFolk  Modified procedure Add_Tax_Lines to modify charge line fee_code after adding tax lines.
--  030410  ChFolk  Modified Remove_Tax_Lines and Add_Tax_Lines to modify the charge line fee code depending on the number of tax lines in the dialog.
--  030408  ChFolk  Modified PROCEDUREs Add_Tax_Lines, Modify__, Insert___, Remove_Sales_Tax_Lines and Unpack_Check_Insert___ to remove the old functionality which are not applicable to the new functionality.
--                  and added new functional requirements.
--                  Added PROCEDURE Add_All_Tax_Lines and FUNCTION Get_Connected_Addr_Flag__.
--  030407  PrJalk  Bug 36603, Changed Add_Tax_Lines, added if condition to prevent adding tax lines if charge_type is non taxable.
--  030404  ChFolk  Added FUNCTIONs Get_Connected_Address_Id__.
--  030402  ChFolk  Replaced INSTR with INSTRB.
--  030401  ChFolk  Replaced SUBSTR with SUBSTRB.
--  030327  ChFolk  Modified Validate_Fee_Code___, Add_Tax_Lines, Remove_Tax_Lines.
--                  Modified PROCEDURE Insert___, not to add tax lines when pay tax is not checked.
--  030326  ChFolk  Modified PROCEDURE Validate_Fee_Code__ as Validate_Fee_Code___ and added sequence_no as a new IN parameter.
--  030325  ChFolk  Modified Unpack_Check_Insert___ to handle sinle occurrence functionality.
--  030324  ChFolk  Added PROCEDURE Remove_Sales_Tax_Lines.
--                  Modified PROCEDURE Insert___ to insert taxes from customer when charge line is connected to a order line.
--                  Modified PROCEDURE Modify__ to modify the Sales Taxes when order line connection to a charge line is changed.
--  030321  ChFolk  Modified PROCEDUREs Unpack_Check_Insert___, Unpack_Check_Update___ and Validate_Fee_Code__ to apply the change of DB values of Tax_Regime_API.
--  030320  ChFolk  Removed un-used variables.
--  030319  ChFolk  Modified the Prompt as Tax Code in view comments of Fee_Code. Removed un-necessary comments and traces.
--                  Modified PROCEDURE Validate_Fee_Code___ as PROCEDURE Validate_Fee_Code__.
--  030317  ChFolk  Modified PROCEDURE Remove__ to remove all connected tax lines.
--  030314  ChFolk  Modified PROCEDURES Unpack_Check_Insert___ and Unpack_Check_Update___ to validate fee code against the customer Tax Regime.
--                  Modified PROCEDURE Insert___ to insert tax lines. Added new PROCEDURE Validate_Fee_Code___ and public PROCEDURE Modify.
--                  Modified PROCEDURE Modify__ to modify the first tax line according to the modification of fee code in charge line.
--  020528  MIGUUS  Bug fix 30096, Added validation in Unpack_Check_Update___ to limit change of charge_type
--                  when customer order is in state of 'Cancelled' or customer order line is in 'Cancelled' and 'Invoiced/Colsed'.
--  010606  IsWilk  Bug Fix 22145, Modified the WHERE clause in the LOVVIEW.
--  010531  DaJolk  Bug fix 22022, Modified condition in check for invoiced_qty in PROC Check_Delete___.
--                  Added error messages to restrict zero value for charged_qty in Unpack_Check_Update___ and Unpack_Check_Insert___.
--  001024  DaZa  Added a invoiced_qty check in Check_Delete___.
--  001017  FBen  Added Get_Default_Charge_Attr___ which is called from Procedure New.
--  001016  FBen  Modified Public Procedure New. Changed in/out parameters (Request from Yeager Team).
--  000925  DaZa  Added reference on consignment_id and exist checks in unpack methods.
--  000922  DaZa  Changed return value on Exist_Collect_On_Consignment and
--                Exist_Collect_On_Consignment to number.
--  000921  DaZa  Added consignment check in both unpack methods.
--  000908  DaZa  Currency_Code fix in Get_Total_Base_Charged_Amount. Added
--                methods Exist_Collect_On_Consignment and Exist_Collect_On_Consignment.
--                Added a couple of insert/update
--                checks for collect/consignment
--  000822  DaZa  Added print_collect_charge, collect and consignment_id to
--                view and methods.
--  000711  TFU   merging from Chameleon
--  000511  GBO   Added New
--  ------------------------------ 12.1 -------------------------------------
--  000531  PaLj  Changed Modify_Qty_Returned and CUSTOMER_ORDER_CHARGE_LOV
--  000303  JoEd  Added line_item_no in attribute string back to client on
--                insert and update.
--  000225  JakH  Removed /CURRENCY from comments on amounts in views
--  000218  DaZa  Added company to view and methods, also new method Get_Company.
--  000217  JakH  Added Get_Vat_Db.
--  000215  JoEd  Added update check of tax lines addition.
--  000214  JoEd  Changed fetch of "VAT usage" from Company.
--                Added error message NOTAXINFO.
--  000211  JoEd  Made line_no, rel_no and line_item_no public.
--  000209  JoEd  Changed check value on taxable in Insert___.
--  000207  JoEd  Changed "add tax lines" check on insert and update.
--  000202  JoEd  Added two overloaded methods: Add_Tax_Lines and Remove_Tax_Lines.
--                Added calls to the sub LU's Add_Tax_Lines when creating a new charge item.
--  000126  DaZa  Removed TRUE on General_SYS.Init_Method for Modify_Qty_Returned.
--  000110  JakH  Added LOV
--  000110  JakH  Moved default setting for QTY_RETURNED to Unpack Check insert
--  991230  JakH  Added QTY_RETURNED
--  991210  DaZa  Added print_charge_type and note_id.
--  ------------------------------ 12.0 -------------------------------------
--  991112  DaZa  Added method Get_Total_Base_Charge_Amount.
--  991103  DaZa  Added check in Unpack_Check_Update___ so we dont update invoiced charges.
--  991028  DaZa  Removed Check on inserting/updating charges on order in status 'Invoiced'.
--  991020  DaZa  Backed to old Unpack_Check_Update___ again and rewrote
--                Modify_Invoiced_Qty so it dont use Unpack_Check_Update___
--                anymore, since there is no use of going
--                thru all the checks for this simple update.
--  991015  JoAn  Changed Unpack_Check_Update___ to allow update of
--                invoiced_qty when the order is 'Invoiced'
--  990929  DaZa  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Tax_Calc_Struct_Ref___ (
   newrec_ IN OUT NOCOPY CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE )
IS
   company_    VARCHAR2(20);
BEGIN
   company_ := Site_API.Get_Company(newrec_.contract);
   Tax_Calc_Structure_API.Validate_Tax_Structure_State(company_, newrec_.tax_calc_structure_id);
END Check_Tax_Calc_Struct_Ref___;

-- Get_Default_Charge_Attr___
--   Retrieves default attribute values for a charge line.
PROCEDURE Get_Default_Charge_Attr___ (
   attr_ IN OUT VARCHAR2 )
IS
   order_no_               CUSTOMER_ORDER_CHARGE_TAB.order_no%TYPE;
   charge_type_            CUSTOMER_ORDER_CHARGE_TAB.charge_type%TYPE;
   charge_amount_          CUSTOMER_ORDER_CHARGE_TAB.charge_amount%TYPE;
   charge_amount_incl_tax_ CUSTOMER_ORDER_CHARGE_TAB.charge_amount%TYPE;

   base_charge_amount_       CUSTOMER_ORDER_CHARGE_TAB.base_charge_amount%TYPE;
   base_charge_amt_incl_tax_ CUSTOMER_ORDER_CHARGE_TAB.base_charge_amt_incl_tax%TYPE;
   rounding_               NUMBER;
   acc_currency_           VARCHAR2(3);
   company_                CUSTOMER_ORDER_CHARGE_TAB.company%TYPE;
   round_amounts_          VARCHAR2(5);

   chargetyperec_          Sales_Charge_Type_API.Public_Rec;
   ordrec_                 Customer_Order_API.Public_Rec;
   currency_rate_          NUMBER;
BEGIN
   order_no_      := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   charge_type_   := Client_SYS.Get_Item_Value('CHARGE_TYPE', attr_);
   ordrec_        := Customer_Order_API.Get(order_no_);
   chargetyperec_ := Sales_Charge_Type_API.Get(ordrec_.contract, charge_type_);

   Client_SYS.Add_To_Attr('CONTRACT', ordrec_.contract, attr_);

   -- Check if a charge_amount was passed with the attribute string.
   -- IF that was the case this charge_amount should override the default price

   IF (chargetyperec_.charge_amount IS NOT NULL OR chargetyperec_.charge_amount_incl_tax IS NULL) THEN

      base_charge_amount_       := chargetyperec_.charge_amount;
      base_charge_amt_incl_tax_ := chargetyperec_.charge_amount_incl_tax;

      -- Get the corresponding charge_amount
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amount_, currency_rate_,
                                                             NVL(ordrec_.customer_no_pay, ordrec_.customer_no),
                                                             ordrec_.contract, ordrec_.currency_code, chargetyperec_.charge_amount,
                                                             ordrec_.currency_rate_type);
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amount_incl_tax_, currency_rate_,
                                                             NVL(ordrec_.customer_no_pay, ordrec_.customer_no),
                                                             ordrec_.contract, ordrec_.currency_code, chargetyperec_.charge_amount_incl_tax,
                                                             ordrec_.currency_rate_type);

      round_amounts_ := NVL(Client_SYS.Get_Item_Value('ROUND_AMOUNTS', attr_), 'FALSE');
      company_ := Client_SYS.Get_Item_Value('COMPANY', attr_);
      IF (round_amounts_ = 'TRUE' AND company_ IS NOT NULL) THEN
         rounding_                 := Currency_Code_API.Get_Currency_Rounding(company_, ordrec_.currency_code);
         charge_amount_            := ROUND(charge_amount_, rounding_);
         charge_amount_incl_tax_   := ROUND(charge_amount_incl_tax_, rounding_);
         acc_currency_             := Company_Finance_API.Get_Currency_Code(company_);

         IF (acc_currency_ != ordrec_.currency_code) THEN
            rounding_              := Currency_Code_API.Get_Currency_Rounding(company_, acc_currency_);
         END IF;
         base_charge_amount_       := ROUND(chargetyperec_.charge_amount, rounding_);
         base_charge_amt_incl_tax_ := ROUND(chargetyperec_.charge_amount_incl_tax, rounding_);
      END IF;

      Client_SYS.Add_To_Attr('CHARGE_AMOUNT', charge_amount_, attr_);

      Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT', base_charge_amount_, attr_);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', charge_amount_incl_tax_, attr_);

      Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', base_charge_amt_incl_tax_, attr_);
      Client_SYS.Add_To_Attr('CURRENCY_RATE', currency_rate_, attr_);
   END IF;

   Client_SYS.Add_To_Attr('CONTRACT', ordrec_.contract, attr_);
   Client_SYS.Add_To_Attr('SALES_UNIT_MEAS', chargetyperec_.sales_unit_meas, attr_);
   Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB', chargetyperec_.print_charge_type, attr_);
   Client_SYS.Add_To_Attr('TAX_CLASS_ID', chargetyperec_.tax_class_id, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TYPE', chargetyperec_.delivery_type, attr_);
END Get_Default_Charge_Attr___;


-- Validate_Prepayment___
--   Validating CO gross amount/curr including charges by checking whether
--   it has exceeded the prepayment amount.
PROCEDURE Validate_Prepayment___ (
   rec_     IN CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE,
   action_  IN VARCHAR2 )
IS
   gross_amount_     NUMBER;
   prepay_amount_    NUMBER;
   line_amount_      NUMBER;
BEGIN
   $IF (Component_Payled_SYS.INSTALLED) $THEN
      prepay_amount_ := On_Account_Ledger_Item_API.Get_Payment_Amt_For_Order_Ref
                                       (rec_.company,
                                        NVL(Customer_Order_API.Get_Customer_No_Pay(rec_.order_no), Customer_Order_API.Get_Customer_No(rec_.order_no)),
                                        rec_.order_no);             
   $END
   IF NVL(prepay_amount_, 0) > 0 THEN
      gross_amount_  := Customer_Order_API.Get_Gross_Amt_Incl_Charges(rec_.order_no);
      IF action_ = 'MODIFY' THEN
         IF (prepay_amount_ > gross_amount_) THEN
            Error_SYS.Record_General(lu_name_, 'PREPAYEXCEED: The prepayment amount is larger than the CO gross amount/curr including charges.');
         END IF;
      ELSIF action_ = 'DELETE' THEN
         line_amount_   := Get_Total_Charged_Amount(rec_.order_no, rec_.sequence_no) + Get_Total_Tax_Amount_Curr(rec_.order_no, rec_.sequence_no);
         IF (prepay_amount_ > (gross_amount_ - line_amount_)) THEN
            Error_SYS.Record_General(lu_name_, 'PREPAYEXCEED: The prepayment amount is larger than the CO gross amount/curr including charges.');
         END IF;
      END IF;
  END IF;
END Validate_Prepayment___;


-- Post_Update_Actions___
--   Actions to be executed after updating an existing record.
PROCEDURE Post_Update_Actions___ (   
   newrec_ IN OUT CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE,
   oldrec_ IN OUT CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE)
IS
BEGIN
   IF NVL(oldrec_.charge_amount, 0) != NVL(newrec_.charge_amount, 0) OR
       NVL(oldrec_.charge_amount_incl_tax, 0) != NVL(newrec_.charge_amount_incl_tax, 0) OR
       NVL(oldrec_.charged_qty, 0)  != NVL(newrec_.charged_qty, 0) OR
       NVL(oldrec_.tax_code, ' ')   != NVL(newrec_.tax_code, ' ') THEN

      Validate_Prepayment___(newrec_, 'MODIFY');
   END IF;
END Post_Update_Actions___;


-- Validate_Charge_And_Cost___
--   Validates the use of charge and cost in amount and percentage forms.
PROCEDURE Validate_Charge_And_Cost___ (
   newrec_ IN CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE )
IS
BEGIN
   IF (newrec_.charge_cost IS NULL AND newrec_.charge_cost_percent IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NULL_COST_ERR: Either Charge cost or charge cost % must have a value.');
   END IF;
   IF (newrec_.charge IS NULL AND newrec_.charge_amount IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NULL_CHARGE_ERR: Either Charge Price or Charge % must have a value.');
   END IF;
   IF (newrec_.charge_cost IS NOT NULL AND newrec_.charge_cost_percent IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'BOTH_COST_ERR: Both charge cost and charge cost % cannot have values at the same time.');
   END IF;
   IF (newrec_.charge IS NOT NULL AND newrec_.charge_amount IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'BOTH_CHARGE_ERR: Both charge price and Charge % cannot have values at the same time.');
   END IF;
   IF (newrec_.charged_qty != 1 AND newrec_.unit_charge != 'TRUE') THEN
      IF (NVL(newrec_.charge, 0) != 0 OR NVL(newrec_.charge_cost_percent, 0) != 0) THEN
         Error_SYS.Record_General(lu_name_, 'MULTIPERCENTUNIERR: Charged quantity should be 1 for non-unit charges when charge cost or charge price is entered as a percentage.');
      END IF;
   END IF;
END Validate_Charge_And_Cost___;

-- Set_Foc_And_Charge_Amounts___
--   Retrieves default charge amount values for a charge line depending on free_of_charge.
PROCEDURE Set_Foc_And_Charge_Amounts___ (
   newrec_             IN OUT CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE,
   oldrec_             IN     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE,
   use_price_incl_tax_ IN     VARCHAR2,
   attr_               IN     VARCHAR2)
IS
   new_attr_             VARCHAR2(2000);
BEGIN
   IF (newrec_.free_of_charge IS NULL OR newrec_.line_no IS NULL) THEN
      newrec_.free_of_charge := 'FALSE';
   END IF;

   IF (newrec_.line_no IS NOT NULL) THEN
      IF (Validate_SYS.Is_Changed(oldrec_.line_no, newrec_.line_no) OR Validate_SYS.Is_Changed(oldrec_.rel_no, newrec_.rel_no) OR Validate_SYS.Is_Changed(oldrec_.line_item_no, newrec_.line_item_no) ) THEN
         newrec_.free_of_charge := Customer_Order_Line_API.Get_Free_Of_Charge_Db(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      END IF;
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.free_of_charge, oldrec_.free_of_charge) AND newrec_.charge IS NULL) THEN
      -- Value changed or called from copy functionality with NULL oldrec_
      IF (newrec_.free_of_charge = 'TRUE') THEN
         newrec_.charge_amount := 0;
         newrec_.charge_amount_incl_tax := 0;
         newrec_.base_charge_amount := 0;
         newrec_.base_charge_amt_incl_tax := 0;
      ELSIF ((oldrec_.order_no IS NOT NULL) OR (newrec_.free_of_charge = 'FALSE' AND NVL(Client_SYS.Get_Item_Value('ORIGINAL_FREE_OF_CHARGE', attr_), 'FALSE') = 'TRUE')) THEN
         -- Recalculation is done for edited or copied records
         Client_SYS.Add_To_Attr('ORDER_NO', newrec_.order_no, new_attr_);
         Client_SYS.Add_To_Attr('CHARGE_TYPE', newrec_.charge_type, new_attr_);
         Client_SYS.Add_To_Attr('CONTRACT', newrec_.contract, new_attr_);
         Client_SYS.Add_To_Attr('ROUND_AMOUNTS', 'TRUE', new_attr_);
         Client_SYS.Add_To_Attr('COMPANY', newrec_.company, new_attr_);

         Get_Default_Charge_Attr___(new_attr_);

         IF (NVL(use_price_incl_tax_, Customer_Order_API.Get_Use_Price_Incl_Tax_Db(newrec_.order_no)) = 'FALSE') THEN
            newrec_.charge_amount := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('CHARGE_AMOUNT', new_attr_));
            newrec_.base_charge_amount := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('BASE_CHARGE_AMOUNT', new_attr_));
         ELSE
            newrec_.charge_amount_incl_tax := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('CHARGE_AMOUNT_INCL_TAX', new_attr_));
            newrec_.base_charge_amt_incl_tax := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('BASE_CHARGE_AMT_INCL_TAX', new_attr_));
         END IF;
         Calculate_Charges___(newrec_);
      END IF;   
   END IF;
   IF (newrec_.free_of_charge = 'TRUE') THEN
      IF (NVL(newrec_.charge_amount, 0) <> 0 OR NVL(newrec_.base_charge_amount, 0) <> 0 ) THEN
         Error_SYS.Record_General(lu_name_, 'CANTCHGPRICE: Price information cannot be modified for free of charge lines.');
      END IF;       
   END IF;
END Set_Foc_And_Charge_Amounts___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   customer_tax_usage_type_ VARCHAR2(5);
BEGIN
   customer_tax_usage_type_ := Customer_Order_API.Get_Customer_Tax_Usage_Type(Client_SYS.Get_Item_Value('ORDER_NO', attr_));
   super(attr_);
   Client_SYS.Add_To_Attr('CHARGED_QTY', 1, attr_);
   Client_SYS.Add_To_Attr('INVOICED_QTY', 0, attr_);
   Client_SYS.Add_To_Attr('COLLECT_DB', 'INVOICE', attr_);
   Client_SYS.Add_To_Attr('PRINT_COLLECT_CHARGE_DB', 'NO PRINT', attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('UNIT_CHARGE_DB','FALSE', attr_);
   Client_SYS.Add_To_Attr('STATISTICAL_CHARGE_DIFF', 0, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', customer_tax_usage_type_, attr_);   
   Client_SYS.Add_To_Attr('FREE_OF_CHARGE_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   old_note_id_                  NUMBER;
   jinsui_invoice_db_            VARCHAR2(5);
   tax_from_defaults_            BOOLEAN;
   original_order_no_            VARCHAR2(12);
   original_sequence_no_         VARCHAR2(50);
   add_tax_lines_                BOOLEAN;
   quotation_no_                 VARCHAR2(12);
   quotation_charge_no_          NUMBER;   
   
   CURSOR get_seq_no(order_no_ IN VARCHAR2) IS
      SELECT nvl(max(sequence_no) + 1, 1)
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE  order_no = order_no_;
   
   line_rec_      Customer_Order_Line_API.Public_Rec;
   tax_method_    VARCHAR2(50);
   tax_from_external_system_ BOOLEAN := FALSE;
   fetch_external_tax_       BOOLEAN := TRUE;
BEGIN
   old_note_id_ := newrec_.note_id;
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;

   IF (old_note_id_ IS NOT NULL) THEN
      Document_Text_API.Copy_All_Note_Texts(old_note_id_, newrec_.note_id);
   END IF;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);

   OPEN get_seq_no(newrec_.order_no);
   FETCH get_seq_no INTO newrec_.sequence_no;
   CLOSE get_seq_no;

   Client_SYS.Add_To_Attr('SEQUENCE_NO', newrec_.sequence_no, attr_);
   
   IF (newrec_.customer_tax_usage_type IS NULL)THEN
      newrec_.customer_tax_usage_type  := Customer_Order_API.Get_Customer_Tax_Usage_Type(newrec_.order_no);
   END IF;
   
   original_order_no_     := Client_SYS.Get_Item_Value('ORIGINAL_ORDER_NO', attr_);
   original_sequence_no_  := Client_SYS.Get_Item_Value('ORIGINAL_SEQ_NO', attr_);   
   IF (Client_SYS.Get_Item_Value('SET_TAX_FROM_ORIGINAL', attr_) = 'TRUE') AND
      (Customer_Order_API.Get_Customer_No(original_order_no_) = Customer_Order_API.Get_Customer_No(newrec_.order_no)) THEN
      newrec_.tax_class_id := Get_Tax_Class_Id(original_order_no_, 
                                               original_sequence_no_);  
   END IF;  
   IF (newrec_.free_of_charge IS NULL OR newrec_.line_no IS NOT NULL) THEN
      Set_Foc_And_Charge_Amounts___(newrec_, NULL, NULL, attr_);         
   END IF;

   super(objid_, objversion_, newrec_, attr_);
   $IF (Component_Jinsui_SYS.INSTALLED) $THEN
      jinsui_invoice_db_ := Customer_Order_API.Get_Jinsui_Invoice_Db(newrec_.order_no);
      IF jinsui_invoice_db_ ='TRUE' THEN
         Validate_Jinsui_Constraints__(newrec_.order_no, newrec_.sequence_no, newrec_.line_no,
                                       newrec_.rel_no, newrec_.line_item_no, 0, FALSE);
      END IF;
   $END

   IF (newrec_.line_no IS NULL) AND (newrec_.collect != 'COLLECT') THEN
      Customer_Order_API.New_Or_Changed_Charge(newrec_.order_no);
   END IF;
   
   tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);
   IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
      tax_from_defaults_ := TRUE;
      tax_from_external_system_ := TRUE;
   ELSE      
      IF (NVL(Client_SYS.Get_Item_Value('COPY_ORDER_CHARGE', attr_), 'FALSE') = 'TRUE') THEN      
         tax_from_defaults_ := FALSE;
      ELSE
         IF (NVL(Client_SYS.Get_Item_Value('FETCH_TAX_CODES', attr_), 'TRUE') = 'TRUE') THEN
            IF (newrec_.tax_calc_structure_id IS NULL) THEN 
               IF (newrec_.tax_code IS NULL) THEN
                  tax_from_defaults_ := TRUE;         
               ELSE
                  tax_from_defaults_ := FALSE;
               END IF;
            ELSE
               tax_from_defaults_ := FALSE;
            END IF;
         END IF;
      END IF;
   END IF;
   
   IF tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX  
      AND (Company_Tax_Control_API.Get_Fetch_Tax_On_Line_Entry_Db(newrec_.company) = Fnd_Boolean_API.DB_FALSE
           OR NVL(Client_SYS.Get_Item_Value('UPDATE_TAX', attr_), 'TRUE') = 'FALSE') THEN
      fetch_external_tax_ := FALSE;
   END IF;
   
   -- If the line is copied or duplicated, taxes should be copied from the original line.
   IF (((Client_SYS.Get_Item_Value('SET_TAX_FROM_ORIGINAL', attr_) = 'TRUE') AND
      (Customer_Order_API.Get_Customer_No(original_order_no_) = Customer_Order_API.Get_Customer_No(newrec_.order_no)))
      OR
      -- in case we have multiple tax (neither tax code nor tax calculation structure on the charge line) 
      -- then when using RMB Copy Order... we should copy tax lines from the original order charge line
     ((NVL(Client_SYS.Get_Item_Value('COPY_ORDER_CHARGE', attr_), 'FALSE') = 'TRUE') AND
      newrec_.tax_calc_structure_id IS NULL AND
      newrec_.tax_code IS NULL)) AND (NOT tax_from_external_system_) THEN
      Tax_Handling_Order_Util_API.Transfer_Tax_lines(newrec_.company, 
                                                     Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, 
                                                     original_order_no_, 
                                                     original_sequence_no_, 
                                                     '*', 
                                                     '*', 
                                                     '*',
                                                     Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, 
                                                     newrec_.order_no, 
                                                     newrec_.sequence_no, 
                                                     '*', 
                                                     '*', 
                                                     '*',
                                                     'TRUE',
                                                     'FALSE');

   ELSIF (NVL(Client_SYS.Get_Item_Value('FROM_ORDER_QUOTATION', attr_), 'FALSE') = 'TRUE') AND (NOT tax_from_external_system_)THEN
      quotation_no_           := Client_SYS.Get_Item_Value('QUOTATION_NO', attr_);
      quotation_charge_no_    := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('QUOTATION_CHARGE_NO', attr_));
      Tax_Handling_Order_Util_API.Transfer_Tax_lines(newrec_.company, 
                                                     Tax_Source_API.DB_ORDER_QUOTATION_CHARGE, 
                                                     quotation_no_, 
                                                     quotation_charge_no_, 
                                                     '*', 
                                                     '*', 
                                                     '*',
                                                     Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, 
                                                     newrec_.order_no, 
                                                     newrec_.sequence_no, 
                                                     '*', 
                                                     '*', 
                                                     '*');
   ELSE
      IF (NVL(Client_SYS.Get_Item_Value('ADD_TAX_LINES', attr_), 'TRUE') = 'TRUE') THEN
         add_tax_lines_ := TRUE;
      ELSE
         add_tax_lines_ := FALSE;
      END IF;         
         
      IF fetch_external_tax_ THEN 
         Add_Transaction_Tax_Info___ (newrec_ => newrec_,
                                      tax_from_defaults_ => tax_from_defaults_,
                                      entered_tax_code_ => newrec_.tax_code,
                                      add_tax_lines_ => add_tax_lines_,
                                      attr_  => NULL); 
      END IF;
   END IF;
   line_rec_ := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   
   IF (NVL(line_rec_.activity_seq, -9999 ) > 0 ) THEN
       Customer_Order_Line_API.Calculate_Revenue ( newrec_.order_no,
                                                   newrec_.line_no,
                                                   newrec_.rel_no,
                                                   newrec_.line_item_no);
   END IF ;
END Insert___;

PROCEDURE Update_Line___ (
   objid_  IN VARCHAR2,
   newrec_ IN customer_order_charge_tab%ROWTYPE )
IS
BEGIN
   UPDATE customer_order_charge_tab
      SET ROW = newrec_
      WHERE rowid = objid_;    
END Update_Line___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE,
   newrec_     IN OUT CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   jinsui_invoice_db_      VARCHAR2(5);
   line_rec_               Customer_Order_Line_API.Public_Rec;
   old_line_rec_           Customer_Order_Line_API.Public_Rec;
   lines_invoiced_         VARCHAR2(5);
   use_price_incl_tax_     VARCHAR2(5);
   tax_code_changed_       VARCHAR2(5) := 'FALSE';
   freight_charges_recalc_ VARCHAR2(5) := 'FALSE';
   multiple_tax_lines_     VARCHAR2(20);
   tax_item_removed_       VARCHAR2(5) := 'FALSE';
   tax_method_             VARCHAR2(50);
   from_defaults_          BOOLEAN;
BEGIN
   use_price_incl_tax_ := Customer_Order_API.Get_Use_Price_Incl_Tax_Db(newrec_.order_no);
   Set_Foc_And_Charge_Amounts___(newrec_, oldrec_, use_price_incl_tax_, attr_);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   lines_invoiced_ := Client_SYS.Get_Item_Value('LINES_INVOICED',attr_);
   
   IF (newrec_.invoiced_qty != oldrec_.invoiced_qty) THEN
      IF (Customer_Order_API.Get_Objstate(newrec_.order_no) IN ('Invoiced','Delivered')) OR ((Customer_Order_API.Get_Objstate(newrec_.order_no) = 'Released') AND nvl(lines_invoiced_, ' ') = 'FALSE' ) THEN
         Customer_Order_API.Check_State(newrec_.order_no);
      END IF;
   END IF;

   $IF (Component_Jinsui_SYS.INSTALLED) $THEN
      jinsui_invoice_db_ := Customer_Order_API.Get_Jinsui_Invoice_Db(newrec_.order_no);
      IF jinsui_invoice_db_ ='TRUE' THEN
         Validate_Jinsui_Constraints__(newrec_.order_no,newrec_.sequence_no, newrec_.line_no,
                                       newrec_.rel_no,newrec_.line_item_no, 0, FALSE);
      END IF;
   $END

   
   multiple_tax_lines_  := Client_SYS.Get_Item_Value('MULTIPLE_TAX_LINES', attr_);
   IF ((newrec_.tax_code IS NULL) AND (newrec_.tax_calc_structure_id IS NULL) 
      AND (multiple_tax_lines_ IS NOT NULL) AND (multiple_tax_lines_ = 'FALSE')) THEN
      
      tax_item_removed_ := 'TRUE';
      
      Source_Tax_Item_Order_API.Remove_Tax_Items(newrec_.company, 
                                                 Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                 newrec_.order_no, 
                                                 TO_CHAR(newrec_.sequence_no), 
                                                 '*', 
                                                 '*',
                                                 '*');
      Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(newrec_.company, 'CUSTOMER_TAX');       
   END IF;
   
   --When there are multiple tax lines and if the charge type is changed we need to remove tax lines for the old charge type and add new tax lines for the new charge type.
   --Removing is needed since the new charge type could be a non taxable charge type.
   IF (newrec_.charge_type != oldrec_.charge_type) AND (multiple_tax_lines_ = 'TRUE') THEN
      tax_item_removed_ := 'TRUE';
      Source_Tax_Item_Order_API.Remove_Tax_Items(newrec_.company, 
                                                 Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                 newrec_.order_no, 
                                                 TO_CHAR(newrec_.sequence_no), 
                                                 '*', 
                                                 '*',
                                                 '*');
   END IF;
      
   IF ((tax_item_removed_ != 'TRUE') AND ((NVL(oldrec_.tax_code, ' ') != NVL(newrec_.tax_code, ' ')) OR
      (NVL(newrec_.tax_calc_structure_id, Database_SYS.string_null_) != NVL(oldrec_.tax_calc_structure_id, Database_SYS.string_null_)) OR
      (newrec_.charge_type != oldrec_.charge_type) OR
      (NVL(oldrec_.line_no, ' ') != NVL(newrec_.line_no, ' ')) OR 
      (NVL(oldrec_.rel_no, ' ') != NVL(newrec_.rel_no, ' ')))) THEN
      -- Recalculate the tax if there has been a change in the line connection.
      IF ((NVL(oldrec_.line_no, ' ') != NVL(newrec_.line_no, ' ')) OR (NVL(oldrec_.rel_no, ' ') != NVL(newrec_.rel_no, ' '))) THEN
         from_defaults_ := TRUE;
      ELSE
         from_defaults_ := FALSE;
      END IF;
      Add_Transaction_Tax_Info___(newrec_ => newrec_,
                                  tax_from_defaults_ => from_defaults_,
                                  entered_tax_code_ => newrec_.tax_code,
                                  add_tax_lines_ => TRUE,
                                  attr_ => NULL);         
   ELSIF ((newrec_.base_charge_amount != oldrec_.base_charge_amount OR newrec_.charge_amount != oldrec_.charge_amount) AND use_price_incl_tax_ = 'FALSE') OR
       ((newrec_.base_charge_amt_incl_tax != oldrec_.base_charge_amt_incl_tax OR newrec_.charge_amount_incl_tax != oldrec_.charge_amount_incl_tax) AND use_price_incl_tax_ = 'TRUE') OR
       (NVL(oldrec_.customer_tax_usage_type,' ') != NVL(newrec_.customer_tax_usage_type,' ')) OR
       (newrec_.charged_qty != oldrec_.charged_qty) OR (NVL(newrec_.charge, -9999999999999) != NVL(oldrec_.charge, -9999999999999)) THEN

      tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);
      IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
         from_defaults_ := TRUE;
         Add_Transaction_Tax_Info___(newrec_ => newrec_,
                                     tax_from_defaults_ => from_defaults_,
                                     entered_tax_code_ => newrec_.tax_code,
                                     add_tax_lines_ => TRUE,
                                     attr_ => NULL);
      ELSE
         Recalculate_Tax_Lines___(newrec_, from_defaults_, NULL);
      END IF;
      
   END IF;
   
   tax_code_changed_ := Client_Sys.Get_Item_Value('TAX_CODE_CHANGED', attr_);
   freight_charges_recalc_ := Client_Sys.Get_Item_Value('FREIGHT_CHARGES_RECALCULATED', attr_);
   IF ((NVL(tax_code_changed_, 'FALSE') = 'TRUE' AND newrec_.charge IS NULL) OR NVL(freight_charges_recalc_, 'FALSE') = 'TRUE') THEN
      Calculate_Charges___(newrec_);
      Update_Line___(objid_, newrec_);
   END IF;
   
   Client_SYS.Add_To_Attr('CHARGED_QTY', newrec_.charged_qty, attr_);
   old_line_rec_ := Customer_Order_Line_API.Get(oldrec_.order_no, oldrec_.line_no, oldrec_.rel_no, oldrec_.line_item_no);
   line_rec_     := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   
   -- Check whether the charge line is changed.
   IF (NVL(newrec_.line_no, 0) != NVL(oldrec_.line_no,0)) OR (NVL(newrec_.rel_no, 0) != NVL(oldrec_.rel_no, 0))THEN
      -- IF charge line is connected to CO Line remove revenue values of the old record 
      IF (NVL(old_line_rec_.activity_seq, -9999) > 0) THEN
         Customer_Order_Line_API.Calculate_Revenue(oldrec_.order_no,
                                                   oldrec_.line_no,
                                                   oldrec_.rel_no,
                                                   oldrec_.line_item_no);   
      END IF;
      
      -- Charge line is connected to CO Line add revenue values for the new record if charge line is connected to CO Line.
      IF (NVL(line_rec_.activity_seq, -9999) > 0) THEN 
         Customer_Order_Line_API.Calculate_Revenue(newrec_.order_no,
                                                   newrec_.line_no,
                                                   newrec_.rel_no,
                                                   newrec_.line_item_no);         
      END IF;
   ELSE 
      -- Check whether the charge line is connected to CO Line.
      IF (NVL(line_rec_.activity_seq, -9999) > 0 ) THEN
         -- Check whether charge line values are changed. 
         IF ((newrec_.base_charge_amount != oldrec_.base_charge_amount) OR (newrec_.base_charge_amt_incl_tax != oldrec_.base_charge_amt_incl_tax) OR (newrec_.charged_qty != oldrec_.charged_qty) OR
            (newrec_.charge_type != oldrec_.charge_type) OR (newrec_.charge_amount != oldrec_.charge_amount) OR (newrec_.charge_amount_incl_tax != oldrec_.charge_amount_incl_tax)) THEN
            Customer_Order_Line_API.Calculate_Revenue(newrec_.order_no,
                                                      newrec_.line_no,
                                                      newrec_.rel_no,
                                                      newrec_.line_item_no);
         END IF ;
      END IF;
   END IF ;
   
   IF (newrec_.collect != oldrec_.collect) THEN 
      IF (newrec_.line_no IS NULL) AND (newrec_.collect != 'COLLECT') THEN
          Customer_Order_API.New_Or_Changed_Charge(newrec_.order_no);
      END IF;
      IF (Customer_Order_API.Get_Objstate(newrec_.order_no) = 'Delivered') AND (newrec_.line_no IS NULL) AND (newrec_.collect = 'COLLECT')  THEN
          Customer_Order_API.Check_State(newrec_.order_no);
      END IF;
   END IF;
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_          IN CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE,
   allow_promo_del_ IN BOOLEAN DEFAULT FALSE,
   allow_invoiced_chrg_del_ IN BOOLEAN DEFAULT FALSE)
IS
BEGIN
   -- A invoiced charge cannot be removed
   IF (remrec_.invoiced_qty != 0 AND NOT allow_invoiced_chrg_del_) THEN
      Error_SYS.Record_General(lu_name_, 'NOREMOVEINVCHARGE: The charge line with sequence number :P1 on customer order :P2 is invoiced and cannot be removed.', remrec_.sequence_no, remrec_.order_no);
   END IF;
   IF ((remrec_.campaign_id IS NOT NULL) AND (NOT allow_promo_del_) AND (remrec_.invoiced_qty = 0) AND (Invoice_Customer_Order_Api.Check_Invoice_Exist_For_Co(remrec_.order_no) = 'FALSE')) THEN
      Error_SYS.Record_General(lu_name_, 'NOREMOVEPROMOCHG: Sales promotion charge lines can only be removed by clearing the sales promotion calculations.');
   END IF;
   
   Validate_Prepayment___(remrec_, 'DELETE');
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE )
IS
   activity_seq_ NUMBER;
BEGIN
   super(objid_, remrec_);
   IF(remrec_.invoiced_qty = 0 AND Invoice_Customer_Order_Api.Check_Invoice_Exist_For_Co(remrec_.order_no)='TRUE')THEN
      Promo_Deal_Get_Order_Line_API.Remove_Charge_Lines_For_Deal(remrec_.campaign_id, remrec_.deal_id, remrec_.sequence_no);
   END IF;
   IF (Customer_Order_API.Get_Objstate(remrec_.order_no) != 'Invoiced') THEN
      Customer_Order_API.Check_State(remrec_.order_no);
   END IF;
   
   activity_seq_ := Customer_Order_Line_API.Get_Activity_Seq(remrec_.order_no, remrec_.line_no, remrec_.rel_no,remrec_.line_item_no);
   IF (NVL(activity_seq_, -9999) > 0) THEN
      Customer_Order_Line_API.Calculate_Revenue(remrec_.order_no,
                                                remrec_.line_no,
                                                remrec_.rel_no,
                                                remrec_.line_item_no) ;
   END IF;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_order_charge_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   rows_                        NUMBER;
   objstate_                    VARCHAR2(20);
   temp_charge_line_            VARCHAR2(5) := 'FALSE';
   server_data_change_          VARCHAR2(5);
   sales_chg_type_category_db_  VARCHAR2(20);
   ordrec_                      Customer_Order_API.Public_Rec;
   line_rec_                    Customer_Order_Line_API.Public_Rec;
   identity_                    VARCHAR2(20);
   error_text_                  VARCHAR2(40);

   CURSOR get_rows(order_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2) IS
      SELECT 1
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no  = rel_no_
      AND    line_item_no = -1;
BEGIN
   newrec_.qty_returned         := NVL(newrec_.qty_returned, 0);
   newrec_.collect              := NVL(newrec_.collect, 'INVOICE');
   newrec_.print_collect_charge := NVL(newrec_.print_collect_charge, 'NO PRINT');
   newrec_.company              := NVL(newrec_.company, Site_API.Get_Company(newrec_.contract));
      
   temp_charge_line_            := Client_SYS.Get_Item_Value('TEMP_CHARGE_LINE', attr_);
   server_data_change_          := Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_);
   
   ordrec_                      := Customer_Order_API.Get(newrec_.order_no);
   -- adding charges to cancelled orders is not allowed
   objstate_                    := Customer_Order_API.Get_Objstate(newrec_.order_no);
   IF (objstate_ = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'CHARGEWRONGSTATEHDIN: A charge can not be added when order has status Cancelled.');
   END IF;

   -- fetch line_item_no
   IF (newrec_.line_item_no IS NULL AND newrec_.line_no IS NOT NULL AND newrec_.rel_no IS NOT NULL) THEN
      OPEN get_rows(newrec_.order_no, newrec_.line_no, newrec_.rel_no);
      FETCH get_rows INTO rows_;
      IF get_rows%FOUND THEN
         newrec_.line_item_no := -1;
      ELSE
         newrec_.line_item_no := 0;
      END IF;
      CLOSE get_rows;
      Customer_Order_Line_API.Exist(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   END IF;

   IF ((newrec_.line_no IS NULL) AND (newrec_.rel_no IS NULL)) THEN
      newrec_.line_item_no := NULL;
   -- checks so you dont try to connect to line with some of the keys null
   ELSIF (((newrec_.line_no IS NOT NULL) AND (newrec_.rel_no IS NULL)) OR ((newrec_.rel_no IS NOT NULL) AND (newrec_.line_no IS NULL))) THEN
      Error_SYS.Record_General(lu_name_, 'CHARGEWRONGLINE: Order line does not exist');
   END IF;
   
   line_rec_ := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   
   -- Initialize free_of_charge now and set the correct value if connected to CO line later
   newrec_.free_of_charge := 'FALSE';

   IF (newrec_.line_no IS NOT NULL) THEN
      IF (Client_SYS.Get_Item_Value('FREE_OF_CHARGE_DB', attr_) IS NULL AND Client_SYS.Get_Item_Value('FREE_OF_CHARGE', attr_) IS NULL AND newrec_.free_of_charge IS NULL) THEN
         newrec_.free_of_charge := line_rec_.free_of_charge;
      END IF;
   -- adding charges to cancelled/invoiced order lines is not allowed
      objstate_ := Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);

      IF (objstate_ IN ('Cancelled', 'Invoiced')) THEN
         Error_SYS.Record_General(lu_name_, 'CHARGEWRONGSTATELNIN: A charge can not be added when the connected order line has status Cancelled or Invoiced/Closed.');
      END IF;
      error_text_ := newrec_.order_no || '-' || newrec_.line_no ||'-' || newrec_.rel_no;
      IF (line_rec_.part_ownership != Part_Ownership_API.DB_COMPANY_OWNED) THEN
         IF (line_rec_.rental = Fnd_Boolean_API.DB_FALSE) THEN 
            Error_SYS.Record_General(lu_name_, 'CHARGEWRONGOWNERSHIP: You are not allowed to connect sales charge :P1 to customer order line :P2 since the ownership of the line is set to Customer Owned or Supplier Loaned.',
                                     newrec_.charge_type, error_text_);
         ELSE
            Error_SYS.Record_General(lu_name_, 'CHARGEWRONGOWNERSHIPRENT: You are not allowed to connect sales charge :P1 to customer order line :P2 since the order line is a rental line.',
                                     newrec_.charge_type, error_text_);         
         END IF;         
      ELSIF (line_rec_.charged_item = 'ITEM NOT CHARGED') THEN
         Error_SYS.Record_General(lu_name_, 'CHARGEWRONGOWNERITEMCHARGE:  You are not allowed to connect sales charge :P1 to sales part :P2 since one or more purchase component line(s) exist as non charged item(s). ',
                                  newrec_.charge_type, line_rec_.part_no);
      END IF;
   END IF;

   sales_chg_type_category_db_ := Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, newrec_.charge_type);
   IF ((sales_chg_type_category_db_ != 'OTHER') AND (server_data_change_ IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALCHGTYPE: Only charges of the charge type category Other can be entered manually.');
   END IF;

   IF (newrec_.unit_charge = 'TRUE') THEN
      IF (newrec_.line_no IS NULL) THEN
          Error_SYS.Record_General(lu_name_, 'SHOULD_BE_CONNECTED: Charge Type with Unit Charge should be connected to a Customer Order Line.');
      END IF;
      -- for the unit charges the charge qty should be equal to the Connected CO line's buy_qty_due.
      IF newrec_.charge_price_list_no IS NULL THEN
         newrec_.charged_qty := line_rec_.buy_qty_due;
      END IF;
   ELSE
      newrec_.charged_qty := NVL(newrec_.charged_qty, 1);
   END IF;

   IF (newrec_.unit_charge IS NULL) THEN
      newrec_.unit_charge := 'FALSE';
   END IF;

   IF (newrec_.charged_qty = 0 AND temp_charge_line_ = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'CHARGEQTYNOTZERO: Charged quantity may not be zero.');
   END IF;

   IF (newrec_.shipment_id IS NOT NULL AND newrec_.line_no IS NOT NULL AND newrec_.rel_no IS NOT NULL AND newrec_.order_no IS NOT NULL) THEN
      IF NOT (Shipment_Line_API.Source_Exist(newrec_.shipment_id, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no))  THEN
         Error_SYS.Record_General(lu_name_,'NOSHIPMENTCONN: The charge line is not connected to the specified shipment');
      END IF;
   END IF;

   newrec_.date_entered := Site_API.Get_Site_Date(newrec_.contract);

   IF newrec_.currency_rate IS NULL THEN
      identity_ := ordrec_.customer_no_pay;
      IF identity_ IS NULL THEN
         identity_ := ordrec_.customer_no;
      END IF;
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(newrec_.charge_amount, newrec_.currency_rate,
                                                             identity_, newrec_.contract, ordrec_.currency_code, 
                                                             newrec_.base_charge_amount, ordrec_.currency_rate_type);
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(newrec_.charge_amount_incl_tax, newrec_.currency_rate,
                                                             identity_, newrec_.contract, ordrec_.currency_code, 
                                                             newrec_.base_charge_amt_incl_tax, ordrec_.currency_rate_type);

   END IF;
   super(newrec_, indrec_, attr_);
	
	Client_SYS.Add_To_Attr('DATE_ENTERED', newrec_.date_entered, attr_);
   -- add line item no back to client to make e.g. the tax lines RMB work correctly
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', newrec_.line_item_no, attr_);

   Validate_Charge_And_Cost___(newrec_);

   -- IF the Customer Order is connected to a Sales Contract it is not possible to connect a charge item.
   IF (ordrec_.Sales_Contract_No IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'SALECONCHARGE: A Charge cannot be added when Customer Order is connected to a Sales Contract.');
   END IF;

   IF (sales_chg_type_category_db_ = 'FREIGHT' )THEN
      IF (newrec_.order_no IS NULL OR newrec_.line_no IS NULL OR newrec_.rel_no IS NULL ) THEN
         Error_SYS.Record_General(lu_name_, 'NOFREIGTCOL: A Freight Charge cannot be added with out a Customer Order Line.');
      ELSE
         -- newrec_.Line_Item_No IS FETCHED
         IF (Customer_Order_Line_API.Get_Adjusted_Weight_Gross(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) IS NULL
            AND Customer_Order_Line_API.Get_Adjusted_Volume(newrec_.Order_No, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) IS NULL) THEN
            Raise_Freight_Charge_Error___();
         END IF;
      END IF;
   ELSE
      IF (newrec_.collect = 'COLLECT') AND (newrec_.shipment_id IS NULL) THEN
         Client_SYS.Add_Warning(lu_name_, 'COLLWITHOUTCONSIORSH: Charge is entered as collect without Shipment ID reference. You may want to connect it to a shipment.');
      END IF;
   END IF;
   
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_order_charge_tab%ROWTYPE,
   newrec_ IN OUT customer_order_charge_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   objstate_                    VARCHAR2(20);
   rows_                        NUMBER;
   line_objstate_               VARCHAR2(20);   
   co_rec_                      Customer_Order_API.Public_Rec;
   line_rec_                    Customer_Order_Line_API.Public_Rec;
   error_text_                  VARCHAR2(40);   
   server_data_change_          VARCHAR2(5);
   collect_charge_              VARCHAR2(10);
   sales_chg_type_category_db_  VARCHAR2(20);
   only_stat_diff_changed_      BOOLEAN := TRUE;
   
   CURSOR get_rows (order_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2) IS
      SELECT 1
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no  = rel_no_
      AND    line_item_no = -1;
BEGIN
   -- fetch company for old clients that don't have company in them
   newrec_.company := NVL (newrec_.company, Site_API.Get_Company(newrec_.contract));
   
   co_rec_         := Customer_Order_API.Get(newrec_.order_no);
   objstate_       := Customer_Order_API.Get_Objstate(newrec_.order_no);
   line_objstate_  := Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);

   -- It should be allowed to update statistical charge diff though the CO lines invoiced or cancelled.   
   IF NOT indrec_.statistical_charge_diff THEN
      only_stat_diff_changed_ := FALSE;
   END IF;    
      
   IF indrec_.charge_type THEN
      -- Since change charge_type will also try to change company, therefore, added the below check separately.
      IF (objstate_ = 'Cancelled') THEN
         Error_SYS.Record_General(lu_name_, 'CHARGEWRONGSTATEHDUP: A charge can not be altered when order has status Cancelled.');
      END IF;
      IF (line_objstate_ IN ('Cancelled','Invoiced')) THEN
         Raise_Charge_Modify_Error___;
      END IF;
   END IF;
   
   server_data_change_ := Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_);
   
   -- changing charges to cancelled orders is not allowed
   IF (objstate_ = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'CHARGEWRONGSTATEHDUP: A charge can not be altered when order has status Cancelled.');
   END IF;

   IF (line_objstate_ IN ('Cancelled','Invoiced') AND NOT(only_stat_diff_changed_)) THEN
      Raise_Charge_Modify_Error___;
   END IF;
   
   IF (newrec_.invoiced_qty != 0 AND NOT(only_stat_diff_changed_) AND newrec_.unit_charge = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'CHARGEINVOICED: A charge can not be altered when the charge has been invoiced.');
   END IF;

   IF (newrec_.charged_qty = 0) THEN
      Error_SYS.Record_General(lu_name_, 'CHARGEQTYNOTZERO: Charged quantity may not be zero.');
   END IF;

   -- set line_item_no
   IF (newrec_.line_item_no IS NULL AND newrec_.line_no IS NOT NULL AND newrec_.rel_no IS NOT NULL) THEN
      OPEN get_rows(newrec_.order_no, newrec_.line_no, newrec_.rel_no);
      FETCH get_rows INTO rows_;
      IF get_rows%FOUND THEN
         newrec_.line_item_no := -1;
      ELSE
         newrec_.line_item_no := 0;
      END IF;
      CLOSE get_rows;
      Customer_Order_Line_API.Exist(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   END IF;

   IF ((newrec_.line_no IS NULL) AND (newrec_.rel_no IS NULL)) THEN
      newrec_.line_item_no := NULL;
   -- checks so you don't try to connect to a line with some of the keys null
   ELSIF (((newrec_.line_no IS NOT NULL) AND (newrec_.rel_no IS NULL)) OR ((newrec_.rel_no IS NOT NULL) AND (newrec_.line_no IS NULL))) THEN
      Error_SYS.Record_General(lu_name_, 'CHARGEWRONGLINE: Order line does not exist');
   END IF;

   -- Moved this line from up for having correct values for the parameters.
   line_rec_ := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);

   IF (newrec_.line_no IS NOT NULL) THEN
      -- changing charges to cancelled/invoiced order lines is not allowed
      objstate_ := Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);

      IF (objstate_ IN ('Cancelled', 'Invoiced') AND NOT(only_stat_diff_changed_)) THEN
         Raise_Charge_Modify_Error___;
      END IF;
      error_text_ := newrec_.order_no || '-' || newrec_.line_no ||'-' || newrec_.rel_no;
      IF (line_rec_.part_ownership != Part_Ownership_API.DB_COMPANY_OWNED) THEN
         IF (line_rec_.rental = Fnd_Boolean_API.DB_FALSE) THEN 
            Error_SYS.Record_General(lu_name_, 'CHARGEWRONGOWNERSHIP: You are not allowed to connect sales charge :P1 to customer order line :P2 since the ownership of the line is set to Customer Owned or Supplier Loaned.',
                                     newrec_.charge_type, error_text_);
         ELSE
            Error_SYS.Record_General(lu_name_, 'CHARGEWRONGOWNERSHIPRENT: You are not allowed to connect sales charge :P1 to customer order line :P2 since the order line is a rental line.',
                                     newrec_.charge_type, error_text_);         
         END IF;
      ELSIF (line_rec_.charged_item = 'ITEM NOT CHARGED') THEN
         Error_SYS.Record_General(lu_name_, 'CHARGEWRONGOWNERITEMCHAR: You are not allowed to connect sales charge :P1 to customer order line :P2 since the order line is set as a non charged item.',
                                  newrec_.charge_type, error_text_);
      END IF;
   END IF;

   sales_chg_type_category_db_ := Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, newrec_.charge_type);

   IF (newrec_.unit_charge = 'TRUE') THEN
      IF (newrec_.line_no IS NULL) THEN
          Error_SYS.Record_General(lu_name_, 'SHOULD_BE_CONNECTED: Charge Type with Unit Charge should be connected to a Customer Order Line.');
      END IF;
      IF (sales_chg_type_category_db_ != 'FREIGHT') AND
          (newrec_.unit_charge != oldrec_.unit_charge) OR
          (NVL(newrec_.line_no,chr(2)) != NVL(oldrec_.line_no, chr(2))) OR
          (NVL(newrec_.rel_no,chr(2)) != NVL(oldrec_.rel_no, chr(2))) THEN
         --Unit charge has been set to true or connected CO line has changed in this operation
         newrec_.charged_qty := Customer_Order_Line_API.Get_Buy_Qty_Due(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      ELSIF (NVL(newrec_.charged_qty,-1) != oldrec_.charged_qty) AND (sales_chg_type_category_db_ NOT IN ('PACK_SIZE', 'FREIGHT')) THEN
         -- Charge Qty has been changed while unit charge is true
         IF (NVL(newrec_.charged_qty,-1) != Customer_Order_Line_API.Get_Buy_Qty_Due(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no)) THEN
            Error_SYS.Record_General(lu_name_, 'CHARGE_QTY_CHANGED: Charged Quantity must be equal to the quantity on the connected Customer Order Line when Unit Charge is used.');
         END IF;
      END IF;
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
  
   -- add line item no back to client to make e.g. the tax lines RMB work correctly
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', newrec_.line_item_no, attr_);
   
   IF indrec_.tax_code THEN
      Client_SYS.Add_To_Attr('TAX_CODE_CHANGED', 'TRUE', attr_);
   END IF;
   
   Validate_Charge_And_Cost___(newrec_);

   IF (sales_chg_type_category_db_ = 'FREIGHT')THEN
      IF (newrec_.order_no IS NULL OR newrec_.line_no IS NULL OR newrec_.rel_no IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOFREIGTCOL: A Freight Charge cannot be added with out a Customer Order Line.');
      ELSE
         -- newrec_.Line_Item_No IS FETCHED
         IF (Customer_Order_Line_API.Get_Adjusted_Weight_Gross(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) IS NULL
             AND Customer_Order_Line_API.Get_Adjusted_Volume(newrec_.Order_No, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) IS NULL) THEN
            Raise_Freight_Charge_Error___();
         END IF;

         IF (Order_Delivery_Term_API.Get_Collect_Freight_Charge_Db(Customer_Order_Line_API.Get_Delivery_Terms(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no)) = 'TRUE') THEN
            collect_charge_ := 'COLLECT';
         ELSE
            collect_charge_ := 'INVOICE';
         END IF;

         IF ( collect_charge_ != newrec_.collect) THEN
            Error_SYS.Record_General(lu_name_, 'DIFFCOLLECT: The value of Collect check box cannot be changed when the charge type category is freight. '||
                                               'You may change the delivery term with a desired value for Collect Freight Charge.');
         END IF;
      END IF;
   ELSE
      IF (newrec_.collect = 'COLLECT') AND( newrec_.shipment_id IS NULL) THEN
         Client_SYS.Add_Warning(lu_name_, 'COLLWITHOUTCONSIGNSH: Charge is entered as collect without Shipment ID reference. You may want to connect it to a Consignment Note or to a Shipment.');
      END IF;
   END IF;

END Check_Update___;


-- Build_Attr_Copy_SP_Chg___ 
-- This method is used to build the attr_ which is used in method Copy_From_Sales_Part_Charge. 
FUNCTION Build_Attr_Copy_SP_Chg___ (
   charge_rec_        IN      Sales_Part_Charge_API.customer_charge_rec,
   order_no_          IN      VARCHAR2,
   line_no_           IN      VARCHAR2,
   rel_no_            IN      VARCHAR2,
   line_item_no_      IN      NUMBER,
   company_           IN      VARCHAR2, 
   order_rec_         IN      Customer_Order_API.Public_Rec,
   order_line_rec_    IN      Customer_Order_Line_API.Public_Rec) RETURN VARCHAR2
IS
   attr_                   VARCHAR2(32000); 
   charge_type_rec_        Sales_Charge_Type_API.Public_Rec;
   charge_amount_          NUMBER;
   charge_amount_incl_tax_ NUMBER;
   curr_rate_              NUMBER;   
BEGIN
   Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amount_,
                                                                   curr_rate_,
                                                                   order_rec_.customer_no,
                                                                   order_line_rec_.contract,
                                                                   order_rec_.currency_code,
                                                                   charge_rec_.charge_amount,
                                                                   order_rec_.currency_rate_type);
   
   Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amount_incl_tax_,
                                                                   curr_rate_,
                                                                   order_rec_.customer_no,
                                                                   order_line_rec_.contract,
                                                                   order_rec_.currency_code,
                                                                   charge_rec_.charge_amount_incl_tax,
                                                                   order_rec_.currency_rate_type);
   
   charge_type_rec_  := Sales_Charge_Type_API.Get(order_line_rec_.contract,charge_rec_.charge_type);
   
   Client_SYS.Clear_Attr(attr_);   
   Client_SYS.Add_To_Attr('ORDER_NO',                 order_no_,                              attr_);
   Client_SYS.Add_To_Attr('CHARGE_AMOUNT',            charge_amount_,                         attr_);
   Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',   charge_amount_incl_tax_,                attr_);
   Client_SYS.Add_To_Attr('CHARGE',                   charge_rec_.charge,                 attr_);
   Client_SYS.Add_To_Attr('CHARGED_QTY',              charge_rec_.charged_qty,            attr_);
   Client_SYS.Add_To_Attr('SALES_UNIT_MEAS',          charge_type_rec_.sales_unit_meas,       attr_);
   Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT',       charge_rec_.charge_amount,          attr_);
   Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', charge_rec_.charge_amount_incl_tax, attr_);
   Client_SYS.Add_To_Attr('CHARGE_COST',              charge_rec_.charge_cost,            attr_);
   Client_SYS.Add_To_Attr('CHARGE_COST_PERCENT',      charge_rec_.charge_cost_percent,    attr_);
   Client_SYS.Add_To_Attr('LINE_NO',                  line_no_,                               attr_);
   Client_SYS.Add_To_Attr('REL_NO',                   rel_no_,                                attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO',             line_item_no_,                          attr_);
   Client_SYS.Add_To_Attr('CHARGE_TYPE',              charge_rec_.charge_type,            attr_);
   Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB',     charge_rec_.print_charge_type,      attr_);
   Client_SYS.Add_To_Attr('PRINT_COLLECT_CHARGE_DB',  charge_rec_.print_collect_charge,   attr_);
   Client_SYS.Add_To_Attr('CONTRACT',                 order_line_rec_.contract,               attr_);
   Client_SYS.Add_To_Attr('INVOICED_QTY',             0,                                      attr_);
   Client_SYS.Add_To_Attr('COMPANY',                  company_,                               attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB',      charge_rec_.intrastat_exempt,       attr_);
   Client_SYS.Add_To_Attr('UNIT_CHARGE_DB',           charge_rec_.unit_charge,            attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TYPE',            charge_type_rec_.delivery_type,         attr_);
   Client_SYS.Add_To_Attr('CURRENCY_RATE',            curr_rate_,                             attr_);
   Client_SYS.Add_To_Attr('STATISTICAL_CHARGE_DIFF',  0,                                      attr_);
	RETURN attr_;
END Build_Attr_Copy_SP_Chg___;


-- Build_Attr_Copy_Cust_Chg___ 
-- This method is used to build the attr_ which is used in method Copy_From_Customer_Charge. 
FUNCTION Build_Attr_Copy_Cust_Chg___ (
   charge_rec_  IN     Customer_Charge_API.Customer_Charge_Rec,
   customer_no_ IN     VARCHAR2,
   contract_    IN     VARCHAR2,
   order_no_    IN     VARCHAR2,
   ordrec_      IN     Customer_Order_API.Public_Rec) RETURN VARCHAR2
IS
   attr_                   VARCHAR2(32000);   
   charge_amount_          NUMBER;
   charge_amount_incl_tax_ NUMBER;
   curr_rate_              NUMBER;
   rec_                    Sales_Charge_Type_API.Public_Rec;
BEGIN
	Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amount_,
                                                                curr_rate_,
                                                                customer_no_,
                                                                contract_,
                                                                ordrec_.currency_code,
                                                                charge_rec_.charge_amount_base,
                                                                ordrec_.currency_rate_type);
   rec_ := Sales_Charge_Type_API.Get(contract_,charge_rec_.charge_type);

   Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amount_incl_tax_,
                                                                curr_rate_,
                                                                customer_no_,
                                                                contract_,
                                                                ordrec_.currency_code,
                                                                charge_rec_.charge_amt_incl_tax_base,
                                                                ordrec_.currency_rate_type);
   rec_ := Sales_Charge_Type_API.Get(contract_,charge_rec_.charge_type);

   Client_SYS.Clear_Attr(attr_);

   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_ );
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_ );
   Client_SYS.Add_To_Attr('CHARGE_TYPE', charge_rec_.charge_type, attr_);
   Client_SYS.Add_To_Attr('CHARGE_AMOUNT', charge_amount_, attr_ );
   Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', charge_amount_incl_tax_, attr_ );
   Client_SYS.Add_To_Attr('CHARGE', charge_rec_.charge, attr_ );
   Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT', charge_rec_.charge_amount_base, attr_ );
   Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', charge_rec_.charge_amt_incl_tax_base, attr_ );
   Client_SYS.Add_To_Attr('CHARGED_QTY', charge_rec_.charged_qty, attr_ );
   Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB', charge_rec_.print_charge_type, attr_ );
   Client_SYS.Add_To_Attr('PRINT_COLLECT_CHARGE_DB', charge_rec_.print_collect_charge, attr_ );
   Client_SYS.Add_To_Attr('CHARGE_COST', charge_rec_.charge_cost, attr_);
   Client_SYS.Add_To_Attr('CHARGE_COST_PERCENT', charge_rec_.charge_cost_percent, attr_);
   Client_SYS.Add_To_Attr('SALES_UNIT_MEAS', rec_.sales_unit_meas, attr_ );
   Client_SYS.Add_To_Attr('COMPANY', rec_.company, attr_ );
   Client_SYS.Add_To_Attr('INVOICED_QTY', 0, attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', charge_rec_.intrastat_exempt, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TYPE', rec_.delivery_type, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_RATE', curr_rate_, attr_);
   Client_SYS.Add_To_Attr('STATISTICAL_CHARGE_DIFF', 0, attr_);   
	RETURN attr_;   
END Build_Attr_Copy_Cust_Chg___;


-- Add_Transaction_Tax_Info___
--    Fetch and calculate taxes and add tax lines to source_tax_item_tab.
PROCEDURE Add_Transaction_Tax_Info___ (
   newrec_              IN OUT CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE, 
   tax_from_defaults_   IN BOOLEAN,   
   entered_tax_code_    IN VARCHAR2,
   add_tax_lines_       IN BOOLEAN,
   attr_                IN VARCHAR2)
IS
   line_amount_rec_       Tax_Handling_Util_API.line_amount_rec;
   source_key_rec_        Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_    Tax_Handling_Order_Util_API.tax_line_param_rec;
   order_rec_             Customer_Order_API.Public_Rec;   
   order_line_rec_        Customer_Order_Line_API.Public_Rec;
   customer_no_           VARCHAR2(20);
   ship_addr_no_          VARCHAR2(50);   
   tax_liability_         VARCHAR2(20);
   multiple_tax_          VARCHAR2(20);
   tax_liability_date_    DATE;
   tax_info_table_        Tax_Handling_Util_API.tax_information_table;
BEGIN
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                                      newrec_.order_no, 
                                                                      TO_CHAR(newrec_.sequence_no), 
                                                                      '*', 
                                                                      '*',  
                                                                      '*',
                                                                      attr_); 
                                      
   order_rec_      := Customer_Order_API.Get(newrec_.order_no);   
   IF (newrec_.line_no IS NOT NULL) THEN
      order_line_rec_ := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      tax_liability_date_ := order_line_rec_.planned_ship_date;      
      IF (order_line_rec_.customer_no != order_line_rec_.deliver_to_customer_no) THEN
         customer_no_  := order_rec_.customer_no;
         ship_addr_no_ := order_rec_.ship_addr_no;
         tax_liability_ := order_rec_.tax_liability;
      ELSE
         customer_no_  := order_line_rec_.customer_no;
         ship_addr_no_ := order_line_rec_.ship_addr_no;
         tax_liability_ := order_line_rec_.tax_liability;
      END IF;
   ELSE
      tax_liability_date_ := order_rec_.wanted_delivery_date;
      customer_no_  := order_rec_.customer_no;
      ship_addr_no_ := order_rec_.ship_addr_no;
      tax_liability_ := order_rec_.tax_liability;
   END IF;
      
   tax_line_param_rec_.company               := newrec_.company;
   tax_line_param_rec_.contract              := order_rec_.contract;
   tax_line_param_rec_.customer_no           := customer_no_;
   tax_line_param_rec_.ship_addr_no          := ship_addr_no_;
   tax_line_param_rec_.planned_ship_date     := tax_liability_date_;
   tax_line_param_rec_.supply_country_db     := order_rec_.supply_country;
   tax_line_param_rec_.delivery_type         := NVL(newrec_.delivery_type, '*');
   tax_line_param_rec_.object_id             := newrec_.charge_type;
   tax_line_param_rec_.use_price_incl_tax    := order_rec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code         := order_rec_.currency_code;
   tax_line_param_rec_.currency_rate         := newrec_.currency_rate;
   tax_line_param_rec_.tax_liability         := tax_liability_;
   tax_line_param_rec_.tax_liability_type_db := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_liability_, Get_Connected_Deliv_Country(newrec_.order_no, newrec_.sequence_no));      
   tax_line_param_rec_.from_defaults         := tax_from_defaults_;
   tax_line_param_rec_.tax_code              := entered_tax_code_;
   tax_line_param_rec_.tax_calc_structure_id := newrec_.tax_calc_structure_id;
   tax_line_param_rec_.add_tax_lines         := add_tax_lines_;

   Tax_Handling_Order_Util_API.Add_Transaction_Tax_Info (line_amount_rec_,
                                                         multiple_tax_,
                                                         tax_info_table_,
                                                         tax_line_param_rec_,
                                                         source_key_rec_,                                                         
                                                         attr_);
END Add_Transaction_Tax_Info___;


PROCEDURE Recalculate_Tax_Lines___ (
   newrec_        IN OUT CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE,
   from_defaults_ IN BOOLEAN,
   attr_          IN VARCHAR2)
IS
   source_key_rec_              Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_          Tax_Handling_Order_Util_API.tax_line_param_rec;   
   order_rec_           Customer_Order_API.Public_Rec;   
   order_line_rec_      Customer_Order_Line_API.Public_Rec;
   customer_no_         VARCHAR2(20);
   ship_addr_no_        VARCHAR2(50);   
   tax_liability_       VARCHAR2(20);
   tax_liability_date_  DATE;
BEGIN
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                                      newrec_.order_no, 
                                                                      TO_CHAR(newrec_.sequence_no), 
                                                                      '*', 
                                                                      '*', 
                                                                      '*', 
                                                                      attr_); 
                                      
   order_rec_      := Customer_Order_API.Get(newrec_.order_no);   
   IF (newrec_.line_no IS NOT NULL) THEN
      order_line_rec_ := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      tax_liability_date_ := order_line_rec_.planned_ship_date;      
      IF (order_line_rec_.customer_no != order_line_rec_.deliver_to_customer_no) THEN
         customer_no_  := order_rec_.customer_no;
         ship_addr_no_ := order_rec_.ship_addr_no;
         tax_liability_ := order_rec_.tax_liability;
      ELSE
         customer_no_  := order_line_rec_.customer_no;
         ship_addr_no_ := order_line_rec_.ship_addr_no;
         tax_liability_ := order_line_rec_.tax_liability;
      END IF;
   ELSE
      tax_liability_date_ := order_rec_.wanted_delivery_date;
      customer_no_  := order_rec_.customer_no;
      ship_addr_no_ := order_rec_.ship_addr_no;
      tax_liability_ := order_rec_.tax_liability;
   END IF;
      
   tax_line_param_rec_.company               := newrec_.company;
   tax_line_param_rec_.contract              := order_rec_.contract;
   tax_line_param_rec_.customer_no           := customer_no_;
   tax_line_param_rec_.ship_addr_no          := ship_addr_no_;
   tax_line_param_rec_.planned_ship_date     := tax_liability_date_;
   tax_line_param_rec_.supply_country_db     := order_rec_.supply_country;
   tax_line_param_rec_.delivery_type         := NVL(newrec_.delivery_type, '*');
   tax_line_param_rec_.object_id             := newrec_.charge_type;
   tax_line_param_rec_.use_price_incl_tax    := order_rec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code         := order_rec_.currency_code;
   tax_line_param_rec_.currency_rate         := newrec_.currency_rate;
   tax_line_param_rec_.tax_liability         := tax_liability_;
   tax_line_param_rec_.tax_liability_type_db := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_liability_, Get_Connected_Deliv_Country(newrec_.order_no, newrec_.sequence_no));   
   tax_line_param_rec_.from_defaults         := from_defaults_;
   tax_line_param_rec_.tax_code              := newrec_.tax_code;
   tax_line_param_rec_.tax_calc_structure_id := newrec_.tax_calc_structure_id;
   tax_line_param_rec_.add_tax_lines         := FALSE;

   Tax_Handling_Order_Util_API.Recalculate_Tax_Lines (source_key_rec_,
                                                      tax_line_param_rec_,
                                                      attr_);
END Recalculate_Tax_Lines___;


PROCEDURE Do_Additional_Validations___ (
   charge_price_list_no_   IN VARCHAR2,
   charge_type_category_   IN VARCHAR2)
IS
BEGIN
   IF charge_type_category_ = 'PROMOTION' THEN
      Error_SYS.Record_General(lu_name_, 'NOMODIFYCHARGETAXLINESPROMO: Charge line cannot be modified when sales charge type category is Promotion.');
   END IF;

   IF (charge_type_category_ = 'PACK_SIZE') AND charge_price_list_no_ IS NOT NULL THEN
      Error_Sys.Record_General(lu_name_, 'UPDATENOTALLOW: Charge line cannot be modified when Sales Charge Type Category is Pack Size.');      
   END IF;  
   
END Do_Additional_Validations___;


PROCEDURE Calculate_Charges___ (
   newrec_    IN OUT CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE )
IS 
   order_rec_             Customer_Order_API.Public_Rec;   
   order_line_rec_        Customer_Order_Line_API.Public_Rec;
   multiple_tax_          VARCHAR2(20);
   customer_no_           VARCHAR2(20);
   ship_addr_no_          VARCHAR2(50);   
   tax_liability_         VARCHAR2(20);   
   tax_liability_type_db_ VARCHAR2(20);
   tax_liability_date_    DATE;
BEGIN
   order_rec_      := Customer_Order_API.Get(newrec_.order_no);
   IF (newrec_.line_no IS NOT NULL) THEN
      order_line_rec_ := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      tax_liability_date_ := order_line_rec_.planned_ship_date;      
      IF (order_line_rec_.customer_no != order_line_rec_.deliver_to_customer_no) THEN
         customer_no_  := order_rec_.customer_no;
         ship_addr_no_ := order_rec_.ship_addr_no;
         tax_liability_ := order_rec_.tax_liability;
      ELSE
         customer_no_  := order_line_rec_.customer_no;
         ship_addr_no_ := order_line_rec_.ship_addr_no;
         tax_liability_ := order_line_rec_.tax_liability;
      END IF;
   ELSE
      tax_liability_date_ := order_rec_.wanted_delivery_date;
      customer_no_  := order_rec_.customer_no;
      ship_addr_no_ := order_rec_.ship_addr_no;
      tax_liability_ := order_rec_.tax_liability;
   END IF;
   
   tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_liability_, 
                                                   Get_Connected_Deliv_Country(newrec_.order_no, newrec_.sequence_no));

   IF (newrec_.charge IS NULL) THEN
      Tax_Handling_Order_Util_API.Get_Prices(newrec_.base_charge_amount,
                                             newrec_.base_charge_amt_incl_tax,
                                             newrec_.charge_amount,
                                             newrec_.charge_amount_incl_tax,
                                             multiple_tax_,
                                             newrec_.tax_code,
                                             newrec_.tax_calc_structure_id,
                                             newrec_.tax_class_id,
                                             newrec_.order_no, 
                                             newrec_.sequence_no, 
                                             '*',
                                             '*',
                                             '*',
                                             Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                             newrec_.contract,
                                             customer_no_,
                                             ship_addr_no_,
                                             tax_liability_date_,
                                             order_rec_.supply_country,
                                             NVL(newrec_.delivery_type, '*'),
                                             newrec_.charge_type,
                                             order_rec_.use_price_incl_tax,
                                             order_rec_.currency_code,
                                             newrec_.currency_rate,
                                             'FALSE',                                          
                                             tax_liability_,
                                             tax_liability_type_db_,
                                             delivery_country_db_ => NULL,
                                             ifs_curr_rounding_ => 16,
                                             tax_from_diff_source_ => 'FALSE',
                                             attr_ => NULL);                                             
   END IF;                                          
END Calculate_Charges___;

PROCEDURE Raise_Freight_Charge_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOORDERFREIGT: A Freight Charge cannot be added with out adjusted gross weight/volume on Customer Order Line. Please check freight information on sales part.'); 
END Raise_Freight_Charge_Error___;


PROCEDURE Raise_Charge_Modify_Error___ 
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'CHARGEWRONGSTATE: A charge can not be altered when the connected order line has status Cancelled or Invoiced/Closed.');
END Raise_Charge_Modify_Error___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_      CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   newrec_      CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   charge_type_ VARCHAR2(25);
BEGIN
   IF (action_ = 'DO') THEN
      oldrec_ := Get_Object_By_Id___(objid_);
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      newrec_ := Get_Object_By_Id___(objid_);
      charge_type_ := Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, oldrec_.charge_type);
      IF (NVL(newrec_.line_no, -1) != NVL(oldrec_.line_no, -1) OR
          NVL(newrec_.rel_no, -1) != NVL(oldrec_.rel_no, -1) OR
          newrec_.charge_type != oldrec_.charge_type OR
          NVL(newrec_.tax_code, Database_SYS.string_null_) != NVL(oldrec_.tax_code, Database_SYS.string_null_) OR
          NVL(newrec_.tax_class_id, Database_SYS.string_null_) != NVL(oldrec_.tax_class_id, Database_SYS.string_null_) OR
          NVL(newrec_.tax_calc_structure_id, Database_SYS.string_null_) != NVL(oldrec_.tax_calc_structure_id, Database_SYS.string_null_) OR
          newrec_.charge_cost != oldrec_.charge_cost OR
          NVL(newrec_.charge_cost_percent, -9999999999999) != NVL(oldrec_.charge_cost_percent, -9999999999999) OR
          newrec_.charged_qty != oldrec_.charged_qty OR
          newrec_.unit_charge != oldrec_.unit_charge OR
          newrec_.intrastat_exempt != oldrec_.intrastat_exempt OR
          newrec_.collect != oldrec_.collect OR
          newrec_.shipment_id != oldrec_.shipment_id OR
          NVL(newrec_.charge_amount, -9999999999999) != NVL(oldrec_.charge_amount, -9999999999999) OR
          NVL(newrec_.charge_amount_incl_tax, -9999999999999) != NVL(oldrec_.charge_amount_incl_tax, -9999999999999) OR
          NVL(newrec_.charge, -9999999999999) != NVL(oldrec_.charge, -9999999999999) OR
          newrec_.base_charge_amount != oldrec_.base_charge_amount OR newrec_.base_charge_amt_incl_tax != oldrec_.base_charge_amt_incl_tax) THEN
            Do_Additional_Validations___(newrec_.charge_price_list_no, charge_type_);
      END IF;
      
      Post_Update_Actions___(newrec_, oldrec_);
   END IF;
   info_ := Client_SYS.Append_Info(info_);
END Modify__;


@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
BEGIN
   IF (action_ = 'DO') THEN
      remrec_ := Get_Object_By_Id___(objid_);
   END IF;
   super(info_, objid_, objversion_, action_);
   IF (action_ = 'DO') THEN
      Source_Tax_Item_Order_API.Remove_Tax_Items(remrec_.company, Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, remrec_.order_no, 
                                                 TO_CHAR(remrec_.sequence_no), '*', '*', '*' );
   END IF;
   info_ := Client_SYS.Append_Info(info_);
END Remove__;


-- Check_Delivery_Type__
--   Checks if delivery_type exists. If found, print an error message.
--   Used for restricted delete check when removing delivery_type (INVOIC-module).
PROCEDURE Check_Delivery_Type__ (
   key_list_ IN VARCHAR2 )
IS
   company_       VARCHAR2(20);
   delivery_type_ CUSTOMER_ORDER_CHARGE_TAB.delivery_type%TYPE;
   found_         NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE  Site_API.Get_Company(contract) = company_
      AND    delivery_type = delivery_type_;
BEGIN
   company_       := SUBSTR(key_list_, 1, INSTR(key_list_, '^') - 1);
   delivery_type_ := SUBSTR(key_list_, INSTR(key_list_, '^') + 1, INSTR(key_list_, '^' , 1, 2) - (INSTR(key_list_, '^') + 1));

   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   IF found_ = 1 THEN
      Error_SYS.Record_General(lu_name_, 'NO_DEL_TYPE: Delivery Type :P1 exists on one or several Customer Order Charge(s)', delivery_type_ );
   END IF;
END Check_Delivery_Type__;


-- Get_Connected_Addr_Flag__
--   Called from CUSTOMER_ORDER_CHARGE_API
--   This method returns the address flag connected to a charge line.
@UncheckedAccess
FUNCTION Get_Connected_Addr_Flag__ (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN VARCHAR2
IS
   line_no_               CUSTOMER_ORDER_CHARGE_TAB.line_no%TYPE;
   rel_no_                CUSTOMER_ORDER_CHARGE_TAB.rel_no%TYPE;
   line_item_no_          CUSTOMER_ORDER_CHARGE_TAB.line_item_no%TYPE;
   addr_flag_             VARCHAR2(2);

   CURSOR get_ord_line_connection IS
      SELECT line_no, rel_no, line_item_no
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE  order_no = order_no_
      AND    sequence_no = sequence_no_;
BEGIN
   OPEN get_ord_line_connection;
   FETCH get_ord_line_connection INTO line_no_, rel_no_, line_item_no_;
   CLOSE get_ord_line_connection;
   IF (line_no_ IS NULL) THEN
      addr_flag_ := NVL(Customer_Order_API.Get_Addr_Flag_Db(order_no_), 'N');
   ELSE
      addr_flag_ := NVL(Customer_Order_Line_API.Get_Addr_Flag_Db(order_no_, line_no_, rel_no_, line_item_no_), 'N');
   END IF;
   RETURN addr_flag_;
END Get_Connected_Addr_Flag__;


-- Get_Connected_Tax_Liability__
--   Called from CUSTOMER_ORDER_CHARGE_API.
--   This method returns the tax liability connected to a charge line.
@UncheckedAccess
FUNCTION Get_Connected_Tax_Liability__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   tax_liability_ CUSTOMER_ORDER_TAB.tax_liability%TYPE;
BEGIN
   IF (line_no_ IS NULL) THEN
      tax_liability_ := Customer_Order_API.Get_Tax_Liability(order_no_);
   ELSE
      tax_liability_ := Customer_Order_Line_API.Get_Tax_Liability(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   RETURN tax_liability_;
END Get_Connected_Tax_Liability__;


-- Get_Connected_Deliv_Country__
--   Called from CUSTOMER_ORDER_CHARGE_API.
--   This method returns the delivery country to the connected to a charge line.
--   Please note that retrieving the delivery country from the ship_addr_no is
--   not correct since we could have single occurence addresses in the CO/COL
@UncheckedAccess
FUNCTION Get_Connected_Deliv_Country__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   delivery_country_db_   VARCHAR2(2);
BEGIN
   IF (line_no_ IS NULL) THEN
      delivery_country_db_ := Customer_Order_Address_API.Get_Country_Code(order_no_);
   ELSE
      delivery_country_db_ := Cust_Order_Line_Address_API.Get_Country_Code(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   RETURN delivery_country_db_;
END Get_Connected_Deliv_Country__;


-- Validate_Jinsui_Constraints__
--   Performs validation with the Junsi Invoice Constraints.
--   This method checks Jinsui maximum amount against Charges
--   gross amount in customer currency.
PROCEDURE Validate_Jinsui_Constraints__ (
   order_no_               IN VARCHAR2,
   sequence_no_            IN NUMBER,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   company_max_jinsui_amt_ IN NUMBER,
   co_header_validation_   IN BOOLEAN )
IS
   company_                     VARCHAR2(20);
   company_maximum_amt_         NUMBER :=0;
   net_amount_                  NUMBER :=0;
   total_tax_pct_               NUMBER :=0;
   gross_charge_total_          NUMBER :=0;
   linr_net_amount_curr_        NUMBER :=0;
   line_total_tax_curr_         NUMBER :=0;
   gross_line_charge_amount_    NUMBER :=0;
   gross_line_total_base_curr_  NUMBER :=0;
   gross_line_toal_incl_charge_ NUMBER :=0;
BEGIN
   company_maximum_amt_ := company_max_jinsui_amt_;
   company_             := Get_Company(order_no_, sequence_no_);
   IF (company_maximum_amt_ = 0 ) THEN
      $IF Component_Jinsui_SYS.INSTALLED $THEN
         company_maximum_amt_ := Js_Company_Info_API.Get_Virtual_Inv_Max_Amount(company_);
      $ELSE
         company_maximum_amt_ := 0;
      $END
   END IF;

   net_amount_         := Get_Total_Charged_Amount(order_no_, sequence_no_);
   total_tax_pct_      := NVL(Source_Tax_Item_API.Get_Total_Tax_Percentage(company_, 'CUSTOMER_ORDER_CHARGE', order_no_, TO_CHAR(sequence_no_), '*', '*', '*'),0);
   gross_charge_total_ := net_amount_ *(1+total_tax_pct_/100);
   IF (gross_charge_total_ > company_maximum_amt_) THEN
      IF (co_header_validation_) THEN
         Error_SYS.Record_General(lu_name_, 'COCHGEXCEEDED: The total charge amount of customer order charge :P1 cannot be greater than the maximum amount for Jinsui invoice :P2 for the company :P3.', order_no_||'-'||sequence_no_, company_maximum_amt_,company_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'CHGEXCEEDED: The total charge amount cannot be greater than the maximum amount for Jinsui invoice :P1 for the company :P2.',company_maximum_amt_,company_);         
      END IF;
   END IF;

   gross_line_charge_amount_    := Get_Gross_Amount_For_Col(order_no_,line_no_,rel_no_,line_item_no_);
   linr_net_amount_curr_        := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_,line_no_,rel_no_,line_item_no_);
   line_total_tax_curr_         := Customer_Order_Line_API.Get_Total_Tax_Amount_Curr(order_no_,line_no_,rel_no_,line_item_no_);
   gross_line_total_base_curr_  := linr_net_amount_curr_ + line_total_tax_curr_;
   gross_line_toal_incl_charge_ := gross_line_total_base_curr_ + gross_line_charge_amount_;

   IF (gross_line_toal_incl_charge_ > company_maximum_amt_ ) THEN
      IF (co_header_validation_) THEN
         Error_SYS.Record_General(lu_name_, 'COAMTLINECHEXCEED: The total charge and the connected line amount of customer order charge :P1 cannot be greater than the maximum amount for Jinsui invoice :P2 for the company :P3.', order_no_||'-'||sequence_no_, company_maximum_amt_,company_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'AMTLINECHEXCEED: The total charge and the connected line amount cannot be greater than the maximum amount for Jinsui invoice :P1 for the company :P2.',company_maximum_amt_,company_);
      END IF;
   END IF;

END Validate_Jinsui_Constraints__;

-----------------------------------------------------------------------------------
-- Get_Total_Charged_Amount___
--    Returns charge amount without tax in order currency.
-----------------------------------------------------------------------------------
FUNCTION Get_Total_Charged_Amount___(
   order_no_                  IN    VARCHAR2,
   sequence_no_               IN    NUMBER,
   company_                   IN    VARCHAR2,
   charge_amount_             IN    NUMBER,
   charge_amount_incl_tax_    IN    NUMBER,
   charged_qty_               IN    NUMBER,
   charge_                    IN    NUMBER,
   rounding_                  IN    NUMBER,
   use_price_incl_tax_        IN    VARCHAR2) RETURN NUMBER 
IS 
   total_charged_amount_ NUMBER;
BEGIN
   IF (Customer_Order_API.Get_Objstate(order_no_) = 'Cancelled' ) THEN
      total_charged_amount_ := 0;
   ELSE 
      IF use_price_incl_tax_ = 'FALSE' THEN
         IF (charge_amount_ IS NULL) THEN
            total_charged_amount_ := charge_ * Get_Net_Charge_Percent_Basis(order_no_, sequence_no_) * charged_qty_ / 100;
         ELSE
            total_charged_amount_ := charge_amount_ * charged_qty_;
         END IF;
      ELSE
         total_charged_amount_ := Get_Total_Charged_Amt_Incl_Tax___ ( order_no_,
                                                                      sequence_no_,
                                                                      company_,
                                                                      charge_amount_,
                                                                      charge_amount_incl_tax_,
                                                                      charged_qty_,
                                                                      charge_,
                                                                      rounding_,
                                                                      use_price_incl_tax_) - Get_Total_Tax_Amount_Curr(order_no_, sequence_no_, company_);
      END IF;
      
      total_charged_amount_ := NVL(total_charged_amount_, 0);
   END IF;

   RETURN ROUND(total_charged_amount_, rounding_);
END Get_Total_Charged_Amount___;

-----------------------------------------------------------------------------------
-- Get_Total_Charged_Amt_Incl_Tax___
--    Returns charge amount including tax in order currency.
-----------------------------------------------------------------------------------
FUNCTION Get_Total_Charged_Amt_Incl_Tax___ (
   order_no_                  IN    VARCHAR2,
   sequence_no_               IN    NUMBER,
   company_                   IN    VARCHAR2,
   charge_amount_             IN    NUMBER,
   charge_amount_incl_tax_    IN    NUMBER,
   charged_qty_               IN    NUMBER,
   charge_                    IN    NUMBER,
   rounding_                  IN    NUMBER,
   use_price_incl_tax_        IN    VARCHAR2) RETURN NUMBER
IS
   total_chrg_amt_incl_tax_ NUMBER;
BEGIN
   IF (Customer_Order_API.Get_Objstate(order_no_) = 'Cancelled' ) THEN
      total_chrg_amt_incl_tax_ := 0;
   ELSE    
      IF use_price_incl_tax_ = 'FALSE' THEN
         total_chrg_amt_incl_tax_ := Get_Total_Charged_Amount___(order_no_,
                                                                 sequence_no_,
                                                                 company_,
                                                                 charge_amount_,
                                                                 charge_amount_incl_tax_,
                                                                 charged_qty_,
                                                                 charge_,
                                                                 rounding_,
                                                                 use_price_incl_tax_) + Get_Total_Tax_Amount_Curr(order_no_, sequence_no_, company_);
      ELSE
         IF (charge_amount_incl_tax_ IS NULL) THEN
            total_chrg_amt_incl_tax_ := charge_ * Get_Gross_Charge_Percent_Basis(order_no_, sequence_no_) * charged_qty_ / 100;
         ELSE
            total_chrg_amt_incl_tax_ := charge_amount_incl_tax_ * charged_qty_;
         END IF;
      END IF;     
      total_chrg_amt_incl_tax_ := NVL(total_chrg_amt_incl_tax_, 0);
   END IF;
   RETURN ROUND(total_chrg_amt_incl_tax_, rounding_);
END Get_Total_Charged_Amt_Incl_Tax___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Connected_Tax_Liability
--   This method returns the tax liability connected for a give order_no and sequence_no
@UncheckedAccess
FUNCTION Get_Connected_Tax_Liability (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN VARCHAR2
IS
   rec_ Public_Rec;
BEGIN   
   rec_ := get (order_no_, sequence_no_);
   RETURN Get_Connected_Tax_Liability__(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
END Get_Connected_Tax_Liability;


-- Get_Connected_Deliv_Country
--   This method returns the delivery country for a give order_no and sequence_no
@UncheckedAccess
FUNCTION Get_Connected_Deliv_Country (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN VARCHAR2
IS
   rec_ Public_Rec;
BEGIN   
   rec_ := get (order_no_, sequence_no_);
   RETURN Get_Connected_Deliv_Country__(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
END Get_Connected_Deliv_Country;


-- Get_Charge_Percent_Basis
--   Calculate and returns the  base value (in order currency) which is used to apply charge percentage on.
@UncheckedAccess
FUNCTION Get_Charge_Percent_Basis (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_               CUSTOMER_ORDER_CHARGE_TAB.charge_percent_basis%TYPE;
   use_price_incl_tax_ VARCHAR2(20);
   rec_                CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
BEGIN
   rec_                := Get_Object_By_Keys___(order_no_, sequence_no_);
   use_price_incl_tax_ := Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_);

   IF (use_price_incl_tax_ = 'TRUE') THEN   
      temp_ := Get_Gross_Charge_Percent_Basis(order_no_, sequence_no_);  
   ELSE
      temp_ := Get_Net_Charge_Percent_Basis(order_no_, sequence_no_);
   END IF;
   RETURN temp_;
END Get_Charge_Percent_Basis;


-- Get_Net_Charge_Percent_Basis
--   Calculate and returns the  base value (in order currency) which is used to apply net charge percentage on.
@UncheckedAccess
FUNCTION Get_Net_Charge_Percent_Basis (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_CHARGE_TAB.charge_percent_basis%TYPE;
   rec_  CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(order_no_, sequence_no_);
   
   IF (rec_.charge_amount IS NULL) THEN
      IF (rec_.charge_percent_basis IS NULL) THEN
         IF (rec_.line_no IS NULL) THEN
            temp_ := Customer_Order_API.Get_Total_Sale_Price__(order_no_);
         ELSE
            temp_ := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
         END IF;
         temp_ := temp_ / rec_.charged_qty;
      ELSE
         temp_ := rec_.charge_percent_basis;
      END IF;
   END IF;

   RETURN temp_;
END Get_Net_Charge_Percent_Basis;


-- Get_Gross_Charge_Percent_Basis
--   Calculate and returns the  base value (in order currency) which is used to apply gross charge percentage on.
@UncheckedAccess
FUNCTION Get_Gross_Charge_Percent_Basis (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_CHARGE_TAB.charge_percent_basis%TYPE;
   rec_  CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(order_no_, sequence_no_);
   
   IF ((rec_.charge_amount IS NULL) OR (rec_.charge_amount_incl_tax IS NULL)) THEN
      IF (rec_.charge_percent_basis IS NULL) THEN  
         IF (rec_.line_no IS NULL) THEN
            temp_ := Customer_Order_API.Get_Ord_Gross_Amount(order_no_);
         ELSE
            temp_ := Customer_Order_Line_API.Get_Sale_Price_Incl_Tax_Total(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
         END IF;   
         temp_ := temp_ / rec_.charged_qty;
      ELSE
         temp_ := rec_.charge_percent_basis;
      END IF;
   END IF;
   RETURN temp_;
END Get_Gross_Charge_Percent_Basis;


-- Get_Base_Charge_Percent_Basis
--   Calculate and returns the  base value (in base currency) which is used to apply charge percentage on.
@UncheckedAccess
FUNCTION Get_Base_Charge_Percent_Basis (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_CHARGE_TAB.base_charge_percent_basis%TYPE;
   rec_  CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(order_no_, sequence_no_);

   IF ((rec_.charge_amount IS NULL) OR (rec_.charge_amount_incl_tax IS NULL)) THEN
      IF (rec_.base_charge_percent_basis IS NULL) THEN
         IF (rec_.line_no IS NULL) THEN
            temp_ := Customer_Order_API.Get_Ord_Gross_Amount(order_no_);
         ELSE
            temp_ := Customer_Order_Line_API.Get_Base_Sale_Price_Total(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
         END IF;
         temp_ := temp_ / rec_.charged_qty;
      ELSE
         temp_ := rec_.base_charge_percent_basis;
      END IF;
   END IF;

   RETURN temp_;
END Get_Base_Charge_Percent_Basis;


-- Get_Total_Charged_Amount
--   Calculates the total charged amount in order currency
--   If Price Including Tax setup is used then amount is calculated as Total Charged Amount Including Tax in order currency - Tax Amount in order currency
--   If Price Including Tax setup is not used then amount is calculated as Total Charged Amount Without Tax
@UncheckedAccess
FUNCTION Get_Total_Charged_Amount (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   rec_                  CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   rounding_             NUMBER;
   currency_code_        VARCHAR2(3);
   use_price_incl_tax_   VARCHAR2(20);
BEGIN
   rec_ := Get_Object_By_Keys___(order_no_, sequence_no_);
   currency_code_      := Customer_Order_API.Get_Currency_Code(order_no_);
   rounding_           := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_);
   use_price_incl_tax_ := Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_);
   
   RETURN Get_Total_Charged_Amount___( order_no_, sequence_no_, rec_.company, rec_.charge_amount, rec_.charge_amount_incl_tax,  rec_.charged_qty, rec_.charge, rounding_, use_price_incl_tax_);
END Get_Total_Charged_Amount;


-- Get_Total_Charged_Amt_Incl_Tax
--   Calculates the total charged amount including tax in order currency
--   If Price Including Tax setup is used then amount is calculated as Total Charged Amount Including Tax in order currency
--   If Price Including Tax setup is not used then amount is calculated as Total Charged Amount Without Tax + Tax Amount in order currency
@UncheckedAccess
FUNCTION Get_Total_Charged_Amt_Incl_Tax (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   rec_                     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   rounding_                NUMBER;
   currency_code_           VARCHAR2(3);
   use_price_incl_tax_      VARCHAR2(20);
BEGIN
   rec_ := Get_Object_By_Keys___(order_no_, sequence_no_);
   currency_code_      := Customer_Order_API.Get_Currency_Code(order_no_);
   rounding_           := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_);
   use_price_incl_tax_ := Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_);
   
   RETURN Get_Total_Charged_Amt_Incl_Tax___( order_no_, sequence_no_, rec_.company, rec_.charge_amount, rec_.charge_amount_incl_tax,  rec_.charged_qty, rec_.charge, rounding_, use_price_incl_tax_);
END Get_Total_Charged_Amt_Incl_Tax;

-- Get_Total_Base_Charged_Amount
--   Calculates the total charged amount in base currency
--   If Price Including Tax setup is used then amount is calculated as Total Charged Amount Including Tax in base currency - Tax Amount in base currency
--   If Price Including Tax setup is not used then amount is calculated as Total Charged Amount Without Tax in order currency * currency rate
@UncheckedAccess
FUNCTION Get_Total_Base_Charged_Amount (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_charged_amount_ NUMBER;
   rounding_                  NUMBER;
   charge_rec_                Public_Rec;
BEGIN
   IF Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_) = 'FALSE' THEN
      charge_rec_ := Get(order_no_, sequence_no_);
      rounding_   := Currency_Code_API.Get_Currency_Rounding(charge_rec_.company, Company_Finance_API.Get_Currency_Code(charge_rec_.company));
      -- Please Note : Since charge_amount (price each) can have as many decimals as you like when curr_rounding_ != rounding_
      -- the base amount needed to be derived from cuur amount like in the invoice. To tally with invoice figures.
   
      total_base_charged_amount_ := ROUND((Get_Total_Charged_Amount(order_no_, sequence_no_) *  charge_rec_.currency_rate), rounding_);
   ELSE
      total_base_charged_amount_ := Get_Tot_Base_Chg_Amt_Incl_Tax(order_no_, sequence_no_) - Get_Total_Tax_Amount_Base(order_no_, sequence_no_);
   END IF;

   RETURN NVL(total_base_charged_amount_,0);
END Get_Total_Base_Charged_Amount;


-- Get_Tot_Base_Chg_Amt_Incl_Tax
--   Calculates the total charged amount including tax in base currency
--   If Price Including Tax setup is used then amount is calculated as Total Charged Amount Including Tax in order currency * currency rate
--   If Price Including Tax setup is not used then amount is calculated as Total Charged Amount Without Tax in base currency + Tax Amount in base currency
@UncheckedAccess
FUNCTION Get_Tot_Base_Chg_Amt_Incl_Tax (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_charged_amount_ NUMBER;
   rounding_                  NUMBER;
   charge_rec_                Public_Rec;
BEGIN
   IF Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_) = 'FALSE' THEN
      total_base_charged_amount_ := Get_Total_Base_Charged_Amount(order_no_, sequence_no_) + Get_Total_Tax_Amount_Base(order_no_, sequence_no_);
   ELSE
      charge_rec_ := Get(order_no_, sequence_no_);
      rounding_   := Currency_Code_API.Get_Currency_Rounding(charge_rec_.company, Company_Finance_API.Get_Currency_Code(charge_rec_.company));
      -- Please Note : Since charge_amount (price each) can have as many decimals as you like when curr_rounding_ != rounding_
      -- the base amount needed to be derived from cuur amount like in the invoice. To tally with invoice figures.
      
      total_base_charged_amount_ := ROUND( (Get_Total_Charged_Amt_Incl_Tax(order_no_, sequence_no_) *  charge_rec_.currency_rate), rounding_);
   END IF;

   RETURN NVL(total_base_charged_amount_,0);
END Get_Tot_Base_Chg_Amt_Incl_Tax;

----------------------------------------------------------------------
-- Get_Tot_Base_Chg_Amt_Incl_Tax
--   Calculates the total charged amount including tax in base currency
--   All parametrs are passed as input parameters.
-----------------------------------------------------------------------
@IgnoreUnitTest TrivialFunction
FUNCTION Get_Tot_Base_Chg_Amt_Incl_Tax (
   order_no_                  IN   VARCHAR2,
   sequence_no_               IN   NUMBER,
   company_                   IN   VARCHAR2,
   charged_qty_               IN   NUMBER,
   charge_amount_             IN   NUMBER,
   charge_amount_incl_tax_    IN   NUMBER,
   charge_                    IN   NUMBER,
   currency_rate_             IN   NUMBER,
   rounding_                  IN   NUMBER,
   use_price_incl_tax_        IN   VARCHAR2) RETURN NUMBER
IS
   total_base_charged_amount_    NUMBER;
BEGIN
   IF use_price_incl_tax_ = 'FALSE' THEN
      total_base_charged_amount_ := ROUND((Get_Total_Charged_Amount___( order_no_,
                                                                       sequence_no_,
                                                                       company_,
                                                                       charge_amount_,
                                                                       charge_amount_incl_tax_,
                                                                       charged_qty_,
                                                                       charge_,
                                                                       rounding_,
                                                                       use_price_incl_tax_) *  currency_rate_), rounding_) + Get_Total_Tax_Amount_Base(order_no_, sequence_no_, company_);
   ELSE      
      total_base_charged_amount_ := ROUND((Get_Total_Charged_Amt_Incl_Tax___( order_no_, sequence_no_, company_, charge_amount_, charge_amount_incl_tax_,  charged_qty_, charge_, rounding_, use_price_incl_tax_) *  currency_rate_), rounding_);
   END IF;

   RETURN NVL(total_base_charged_amount_,0);
END Get_Tot_Base_Chg_Amt_Incl_Tax;


-- Get_Total_Base_Charged_Cost
--   Calculate and returns the effective charge cost in base currency
--   depending on the charge cost or percentage and line connection.
@UncheckedAccess
FUNCTION Get_Total_Base_Charged_Cost (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_charge_cost_ NUMBER;
   rec_                    CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   rounding_               NUMBER;
   currency_code_          VARCHAR2(3);
BEGIN
   rec_           := Get_Object_By_Keys___(order_no_, sequence_no_);
   currency_code_ := Company_Finance_API.Get_Currency_Code(rec_.company);
   rounding_      := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_);

   IF (rec_.charge_cost IS NULL) THEN
      IF (rec_.line_no IS NULL) THEN
         total_base_charge_cost_ := rec_.charge_cost_percent * Customer_Order_API.Get_Total_Base_Price(order_no_) / 100;
      ELSE
         total_base_charge_cost_ := rec_.charge_cost_percent * Customer_Order_Line_API.Get_Base_Sale_Price_Total(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no) / 100;
      END IF;
   ELSE
      total_base_charge_cost_ := rec_.charge_cost * rec_.charged_qty;
   END IF;
   RETURN ROUND(total_base_charge_cost_, rounding_);
END Get_Total_Base_Charged_Cost;


-- Modify_Invoiced_Qty
--   This method should only be used when invoicing the order.
--   We do not use unpack_check_update___ here, because we do not want to
--   make all the unpack checks in this case (only time the data could be
--   invalid is if someone have change them via SQLPLUS), we also gain some
--   performance by bypassing unpack.
PROCEDURE Modify_Invoiced_Qty (
   order_no_       IN VARCHAR2,
   sequence_no_    IN NUMBER,
   invoiced_qty_   IN NUMBER,
   lines_invoiced_ IN BOOLEAN DEFAULT FALSE )
IS
   objid_      CUSTOMER_ORDER_CHARGE.objid%TYPE;
   objversion_ CUSTOMER_ORDER_CHARGE.objversion%TYPE;
   newrec_     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   oldrec_     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(order_no_, sequence_no_);
   newrec_ := oldrec_;
   newrec_.invoiced_qty := NVL(newrec_.invoiced_qty, 0) + invoiced_qty_;
   IF (newrec_.charge IS NOT NULL AND newrec_.charged_qty = newrec_.invoiced_qty) THEN
      -- Base values for charge percent are saved in db when the charge line is totally invoiced
      newrec_.charge_percent_basis      := Get_Charge_Percent_Basis(newrec_.order_no, newrec_.sequence_no);
      newrec_.base_charge_percent_basis := Get_Base_Charge_Percent_Basis(newrec_.order_no, newrec_.sequence_no);
   ELSIF (newrec_.charged_qty != newrec_.invoiced_qty) AND NOT lines_invoiced_ THEN
      newrec_.charge_percent_basis      := NULL;
      newrec_.base_charge_percent_basis := NULL;
   END IF;
   
   IF (lines_invoiced_) THEN
      Client_SYS.Add_To_Attr('LINES_INVOICED', 'TRUE', attr_);
   ELSE
      Client_SYS.Add_To_Attr('LINES_INVOICED', 'FALSE', attr_);
   END IF;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Invoiced_Qty;


-- Modify_Qty_Returned
--   Modify qty_returned
PROCEDURE Modify_Qty_Returned (
   order_no_     IN VARCHAR2,
   sequence_no_  IN NUMBER,
   qty_returned_ IN NUMBER )
IS
   oldrec_     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(order_no_ , sequence_no_);
   newrec_ := oldrec_;
   newrec_.qty_returned := qty_returned_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE );
END Modify_Qty_Returned;


-- Get_Charge_Type_Desc
--   Gets charge type description in order language if possible
@UncheckedAccess
FUNCTION Get_Charge_Type_Desc (
   contract_    IN VARCHAR2,
   order_no_    IN VARCHAR2,
   charge_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   language_code_     VARCHAR2(2);
   charge_desc_lang_  VARCHAR2(35);
BEGIN
   language_code_    := Customer_Order_API.Get_Language_Code(order_no_);
   charge_desc_lang_ := Sales_Charge_Type_Desc_API.Get_Charge_Type_Desc(contract_, charge_type_, language_code_);
   -- show language specific description if possible
   IF (charge_desc_lang_ IS NOT NULL) THEN
      RETURN charge_desc_lang_;
   ELSE
      RETURN Sales_Charge_Type_API.Get_Charge_Type_Desc(contract_, charge_type_);
   END IF;
END Get_Charge_Type_Desc;


-- Get_Charge_Group_Desc
--   Gets charge group description in order language if possible
@UncheckedAccess
FUNCTION Get_Charge_Group_Desc (
   contract_    IN VARCHAR2,
   order_no_    IN VARCHAR2,
   charge_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   language_code_     VARCHAR2(2);
   charge_desc_lang_  VARCHAR2(35);
   charge_group_      VARCHAR2(25);
BEGIN
   charge_group_     := Sales_Charge_Type_API.Get_Charge_Group(contract_, charge_type_);
   language_code_    := Customer_Order_API.Get_Language_Code(order_no_);
   charge_desc_lang_ := Sales_Charge_Group_Desc_API.Get_Charge_Group_Desc(language_code_, charge_group_);
   -- show language specific description if possible
   IF (charge_desc_lang_ IS NOT NULL) THEN
      RETURN charge_desc_lang_;
   ELSE
      RETURN Sales_Charge_Group_API.Get_Charge_Group_Desc(charge_group_);
   END IF;
END Get_Charge_Group_Desc;


-- Remove_Tax_Lines
--   Called from CustomerOrderLine when e.g. the line address is changed
--   Removes the tax lines for all charges connected to the bypassed
--   customer order line.
PROCEDURE Remove_Tax_Lines (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   CURSOR get_sequence_no IS
      SELECT company, sequence_no
      FROM  CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no = order_no_
      AND   (line_no = line_no_ OR line_no IS NULL)
      AND   (rel_no = rel_no_ OR rel_no IS NULL)
      AND   (line_item_no = line_item_no_ OR line_item_no IS NULL)
      AND   invoiced_qty < charged_qty;
BEGIN
   FOR rec_ IN get_sequence_no LOOP
      Source_Tax_Item_Order_API.Remove_Tax_Items(rec_.company, Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, order_no_, TO_CHAR(rec_.sequence_no), '*', '*', '*');      
   END LOOP;
END Remove_Tax_Lines;


-- Remove_Tax_Lines
--   Called from Substitute Sales Part window
--   Removes CO line connected charge lines when deleting the CO line 
--   when substitute part line is being added.
PROCEDURE Remove_Charge_Lines_If_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   CURSOR get_sequence_no IS
      SELECT company, sequence_no
      FROM  CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_ 
      AND   rel_no = rel_no_ 
      AND   line_item_no = line_item_no_
      AND   invoiced_qty = 0;
BEGIN   
   FOR rec_ IN get_sequence_no LOOP
      Remove(order_no_, rec_.sequence_no);   
   END LOOP;
END Remove_Charge_Lines_If_Exist;


-- Get_Conn_Tax_Liability_Type_Db
--   Fetches  tax liability type when order no is available.
@UncheckedAccess
FUNCTION Get_Conn_Tax_Liability_Type_Db (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN VARCHAR2
IS
   rec_ Public_Rec;
BEGIN
   rec_ := get (order_no_, sequence_no_);

   RETURN Get_Conn_Tax_Liability_Type_Db(order_no_,
                                  rec_.line_no,
                                  rec_.rel_no,
                                  rec_.line_item_no,
                                  NULL,
                                  NULL);
END Get_Conn_Tax_Liability_Type_Db;



-- Get_Conn_Tax_Liability_Type_Db
--   Fetches  the tax liability type db from order keys.
@UncheckedAccess
FUNCTION Get_Conn_Tax_Liability_Type_Db (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   tax_liability_ IN VARCHAR2,
   address_id_    IN VARCHAR2) RETURN VARCHAR2
IS
   temp_tax_liability_ VARCHAR2(20);
   temp_address_id_    VARCHAR2(20);
BEGIN
   IF line_no_ IS NOT NULL THEN      
      temp_tax_liability_ := NVL(tax_liability_, Customer_Order_Line_API.Get_Tax_Liability(order_no_, line_no_, rel_no_, line_item_no_));
      temp_address_id_ := NVL(address_id_, Cust_Order_Line_Address_API.Get_Country_Code(order_no_, line_no_, rel_no_, line_item_no_));   
   ELSE    
      temp_tax_liability_ := NVL(tax_liability_, Customer_Order_API.Get_Tax_Liability(order_no_));
      temp_address_id_ := NVL(address_id_, Customer_Order_Address_API.Get_Country_Code(order_no_));    
   END IF;
   
   RETURN Tax_Liability_API.Get_Tax_Liability_Type_Db(temp_tax_liability_,  temp_address_id_);
END Get_Conn_Tax_Liability_Type_Db;

-- New
--   Public interface for creating a new charge line.
--   Public method for creating CustomerOrderCharge from OrderQuotation
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   ptr_         NUMBER;
   name_        VARCHAR2(30);
   value_       VARCHAR2(2000);
   new_attr_    VARCHAR2(2000);
   newrec_      CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   order_no_    CUSTOMER_ORDER_CHARGE_TAB.order_no%TYPE;
   charge_type_ CUSTOMER_ORDER_CHARGE_TAB.charge_type%TYPE;
   indrec_      Indicator_Rec;
BEGIN
   order_no_    := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   charge_type_ := Client_SYS.Get_Item_Value('CHARGE_TYPE', attr_);

   -- Retrieve the default attribute values, order_no must be passed to Prepare_Insert___
   Prepare_Insert___(new_attr_);

   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, new_attr_);
   Client_SYS.Add_To_Attr('CHARGE_TYPE', charge_type_, new_attr_);

   -- Add the default attributes for charges
   Get_Default_Charge_Attr___(new_attr_);

   -- Replace the default attribute values with the ones passed in the in parameter string
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      -- Attribute values passed in the parameter string do not include DB values. This is taken care of here.
      IF (name_ = 'PRINT_CHARGE_TYPE') THEN
         Client_SYS.Set_Item_Value('PRINT_CHARGE_TYPE_DB', Gen_Yes_No_API.Encode(value_), new_attr_);
      ELSIF (name_ = 'PRINT_COLLECT_CHARGE') THEN
         Client_SYS.Set_Item_Value('PRINT_COLLECT_CHARGE_DB', Print_Collect_Charge_API.Encode(value_), new_attr_);
      ELSIF (name_ = 'COLLECT') THEN
         Client_SYS.Set_Item_Value('COLLECT_DB', Collect_API.Encode(value_), new_attr_);
      ELSE
         Client_SYS.Set_Item_Value(name_, value_, new_attr_);
      END IF;
   END LOOP;
   
   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);
   attr_ := new_attr_;
END New;


-- Modify
--   Public interface to modify a new charge line.
PROCEDURE Modify (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER,
   attr_        IN VARCHAR2 )
IS
   objid_      CUSTOMER_ORDER_CHARGE.objid%TYPE;
   objversion_ CUSTOMER_ORDER_CHARGE.objversion%TYPE;
   oldrec_     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   new_attr_   VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   new_attr_ := attr_;
   Get_Id_Version_By_Keys___ (objid_, objversion_, order_no_, sequence_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, new_attr_);
   Check_Update___(oldrec_, newrec_, indrec_, new_attr_);   
   Update___(objid_, oldrec_, newrec_, new_attr_, objversion_);
   Post_Update_Actions___(newrec_, oldrec_);
END Modify;


-- Add_All_Tax_Lines
--   Called from CUSTOMER_ORDER_API and CUSTOMER_ORDER_LINE_API.
--   To add all tax lines, when changing the pay tax of order line connected to a charge line.
PROCEDURE Add_Transaction_Tax_Info (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS   
   CURSOR get_line_rec IS
      SELECT *
      FROM  CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no = order_no_
      AND   (line_no = line_no_)
      AND   (rel_no = rel_no_)
      AND   (line_item_no = line_item_no_)
      AND   invoiced_qty < charged_qty;

      CURSOR get_unconnected_line_rec IS
         SELECT *
         FROM  CUSTOMER_ORDER_CHARGE_TAB
         WHERE order_no = order_no_
         AND   line_no is null
         AND   rel_no is null
         AND   line_item_no is null
         AND   invoiced_qty < charged_qty;
BEGIN
   IF (line_no_ IS NULL AND rel_no_ IS NULL AND line_item_no_ IS NULL) THEN
      FOR rec_ IN get_unconnected_line_rec LOOP
         Add_Transaction_Tax_Info___ (newrec_ => rec_,
                                      tax_from_defaults_ => TRUE,
                                      entered_tax_code_ => NULL,
                                      add_tax_lines_ => TRUE,
                                      attr_ => NULL);
      END LOOP;
   ELSE
      FOR rec_ IN get_line_rec LOOP
         Add_Transaction_Tax_Info___ (newrec_ => rec_,
                                      tax_from_defaults_ => TRUE,
                                      entered_tax_code_ => NULL,
                                      add_tax_lines_ => TRUE,
                                      attr_ => NULL);
      END LOOP;
   END IF;
END Add_Transaction_Tax_Info;


-- Exist_Charge_On_Order_Line
--   Returns 1 if at least one charge is connected to an order line.
@UncheckedAccess
FUNCTION Exist_Charge_On_Order_Line (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR check_charge IS
      SELECT 1
      FROM CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   OPEN check_charge;
   FETCH check_charge INTO dummy_;
   CLOSE check_charge;
   RETURN (NVL(dummy_,0));
END Exist_Charge_On_Order_Line;


-- Get_Total_Tax_Amount
--   This function returns total tax amount in customer currency.
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount_Curr (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER,
   company_     IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS   
   contract_   VARCHAR2(5);
   comp_       VARCHAR2(20);   
   tax_amount_ NUMBER := 0;

BEGIN
   IF company_ IS NULL THEN 
      contract_ := Get_Contract(order_no_, sequence_no_);
      comp_  := Site_API.Get_Company(contract_);
   ELSE
      comp_ := company_;
   END IF;
   
   tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Curr_Amount(comp_, 
                                                                Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                                order_no_,
                                                                TO_CHAR(sequence_no_),
                                                                '*',
                                                                '*',
                                                                '*');
   RETURN NVL(tax_amount_, 0);
END Get_Total_Tax_Amount_Curr;

-- Get_Total_Tax_Amount_Base
--    This function returns total tax amount in base currency.
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount_Base (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER,
   company_     IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS   
   contract_   VARCHAR2(5);
   comp_       VARCHAR2(20);   
   tax_amount_ NUMBER := 0;

BEGIN
   IF company_ IS NULL THEN 
      contract_ := Get_Contract(order_no_, sequence_no_);
      comp_  := Site_API.Get_Company(contract_);
   ELSE
      comp_ := company_;
   END IF;

   tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Dom_Amount(comp_, 
                                                               Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                               order_no_,
                                                               TO_CHAR(sequence_no_),
                                                               '*',
                                                               '*',
                                                               '*');
   RETURN NVL(tax_amount_, 0);
END Get_Total_Tax_Amount_Base;


-- Get_Gross_Amount_For_Col
--   This function returns Gross Charge amount connected to a Customer Order
--   Line in customer currency.
@UncheckedAccess
FUNCTION Get_Gross_Amount_For_Col (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   tot_gross_amount_ NUMBER;

   CURSOR get_charges_connected_to_order IS
      SELECT sequence_no
        FROM customer_order_charge_tab
       WHERE order_no = order_no_
         AND NVL(line_no,CHR(132)) = line_no_
         AND NVL(rel_no,CHR(132)) = rel_no_
         AND NVL(line_item_no,-9999999) = line_item_no
         AND collect ='INVOICE';
BEGIN
   tot_gross_amount_ := 0;
   FOR chg_ IN get_charges_connected_to_order LOOP
      tot_gross_amount_ := tot_gross_amount_ + Get_Total_Charged_Amt_Incl_Tax(order_no_,chg_.sequence_no);
   END LOOP;
   RETURN tot_gross_amount_;
END Get_Gross_Amount_For_Col;


-- Modify_Tax_Code
--   This method will only modify the tax code in the charge line.
--   We do not use unpack_check_update___ here, because we do not want to
--   make all the unpack checks in this case, we also gain some
--   performance by bypassing unpack.
PROCEDURE Modify_Tax_Code (
   order_no_     IN VARCHAR2,
   sequence_no_  IN NUMBER,
   tax_code_     IN VARCHAR2 )
IS
   objid_      CUSTOMER_ORDER_CHARGE.objid%TYPE;
   objversion_ CUSTOMER_ORDER_CHARGE.objversion%TYPE;
   newrec_     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   oldrec_     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, sequence_no_);
   oldrec_ := Lock_By_Keys___(order_no_, sequence_no_);
   newrec_ := oldrec_;
   newrec_.tax_code := tax_code_;
   Client_SYS.Set_Item_Value('TAX_CODE_CHANGED', 'TRUE', attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Tax_Code;


PROCEDURE Modify_Tax_Class_Id (
   attr_        IN OUT VARCHAR2,
   order_no_    IN     VARCHAR2,
   sequence_no_ IN     NUMBER )
IS
   objid_      CUSTOMER_ORDER_CHARGE.objid%TYPE;
   objversion_ CUSTOMER_ORDER_CHARGE.objversion%TYPE;
   newrec_     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   oldrec_     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;  
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, sequence_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.tax_class_id := Client_Sys.Get_Item_Value('TAX_CLASS_ID', attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Tax_Class_Id;


-- Copy_From_Sales_Part_Charge
--   This method retrieves the default charges for the given order line
--   and inserts into Customer_Order_Charge_Tab
PROCEDURE Copy_From_Sales_Part_Charge (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER )
IS
   order_rec_              Customer_Order_API.Public_Rec;
   order_line_rec_         Customer_Order_Line_API.Public_Rec;
   company_                VARCHAR2(60);
   newrec_                 CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   indrec_                 Indicator_Rec;
   objid_                  VARCHAR2(100);
   objversion_             VARCHAR2(100);

   charge_tab_             Sales_Part_Charge_API.Sales_Part_Charge_Table;
   attr_                   VARCHAR2(32000);
BEGIN
   order_line_rec_ := Customer_Order_Line_API.Get(order_no_,line_no_,rel_no_,line_item_no_);
   IF (order_line_rec_.part_ownership = 'COMPANY OWNED') THEN
      order_rec_  := Customer_Order_API.Get(order_no_);
      company_    := Site_API.Get_Company(order_line_rec_.contract);
      charge_tab_ := Sales_Part_Charge_API.Get_Default_Charges(order_rec_.customer_no,
                                                               order_line_rec_.catalog_no,
                                                               order_line_rec_.contract);
      IF charge_tab_.COUNT>0 THEN
         FOR i_ IN charge_tab_.FIRST .. charge_tab_.LAST LOOP 
            attr_ := Build_Attr_Copy_SP_Chg___(charge_tab_(i_), order_no_, line_no_, rel_no_, line_item_no_, company_, order_rec_, order_line_rec_);
            -- Clear attribute values assigned previously in the loop
            newrec_ := NULL;
   
            Unpack___(newrec_, indrec_, attr_);
            Check_Insert___(newrec_, indrec_, attr_);            
            Insert___(objid_, objversion_, newrec_, attr_);
         END LOOP;
      END IF;
   END IF;
END Copy_From_Sales_Part_Charge;


-- Copy_From_Customer_Charge
--   For a given contract this adds default charges to customer.
PROCEDURE Copy_From_Customer_Charge (
   customer_no_ IN VARCHAR2,
   contract_    IN VARCHAR2,
   order_no_    IN VARCHAR2 )
IS
   attr_                   VARCHAR2(32000);
   charge_tab_             Customer_Charge_API.Customer_Charge_Table;
   newrec_                 CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   objid_                  VARCHAR2(100);
   objversion_             VARCHAR2(100);
   ordrec_                 Customer_Order_API.Public_Rec;
   indrec_                 Indicator_Rec;
BEGIN
   charge_tab_ := Customer_Charge_API.Get_Default_Charges(customer_no_, contract_);
   ordrec_     := Customer_Order_API.Get(order_no_);
   IF (charge_tab_.COUNT > 0) THEN
      FOR i_ IN charge_tab_.FIRST..charge_tab_.LAST LOOP
         attr_ := Build_Attr_Copy_Cust_Chg___(charge_tab_(i_), customer_no_, contract_, order_no_, ordrec_);
         -- Clear attribute values assigned previously in the loop
         newrec_ := NULL;

         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
   END IF;
END Copy_From_Customer_Charge;


-- Update_Connected_Charged_Qty
--   This method will update the connected charged for a given CO line,
--   with the given qty. This is used to synchonise the quantities for unit charges
PROCEDURE Update_Connected_Charged_Qty (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER,
   charged_qty_  IN NUMBER )
IS
   CURSOR get_attr IS
      SELECT sequence_no
      FROM  CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = release_no_
      AND   line_item_no = line_item_no_
      AND   unit_charge  ='TRUE'
      AND   charge_price_list_no IS NULL;

   newrec_        CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
BEGIN
   FOR rec_ IN get_attr LOOP
      newrec_ := Get_Object_By_Keys___(order_no_, rec_.sequence_no);
      newrec_.charged_qty := charged_qty_;
      Modify___(newrec_);      
   END LOOP;
END Update_Connected_Charged_Qty;


-- Update_Connected_Foc_Db
--   This method will update the connected charged for a given CO line,
--   with the given free_of_charge flag.
PROCEDURE Update_Connected_Foc_Db (
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   release_no_        IN VARCHAR2,
   line_item_no_      IN NUMBER,
   free_of_charge_db_ IN VARCHAR2 )
IS
   CURSOR get_attr IS
      SELECT sequence_no
      FROM  CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = release_no_
      AND   line_item_no = line_item_no_;

   attr_          VARCHAR2(2000);
   newrec_        CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   oldrec_        CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   indrec_        Indicator_Rec;
BEGIN
   FOR rec_ IN get_attr LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('FREE_OF_CHARGE_DB', free_of_charge_db_, attr_);

      Get_Id_Version_By_Keys___ ( objid_, objversion_, order_no_, rec_.sequence_no);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);      
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END LOOP;
END Update_Connected_Foc_Db;

-- Remove
--   Public interface for removing an charge line.
PROCEDURE Remove (
   order_no_        IN VARCHAR2,
   sequence_no_     IN NUMBER,
   allow_promo_del_ IN BOOLEAN DEFAULT FALSE,
   allow_invoiced_chrg_del_ IN BOOLEAN DEFAULT FALSE)
IS
   remrec_     CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(order_no_, sequence_no_);
   Check_Delete___(remrec_, allow_promo_del_, allow_invoiced_chrg_del_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, sequence_no_);
   Delete___(objid_, remrec_);
   Source_Tax_Item_Order_API.Remove_Tax_Items(remrec_.company, Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, order_no_, TO_CHAR(sequence_no_), '*', '*', '*');
END Remove;


-- Get_Pack_Size_Chg_Line_Seq_No
--   This method returns sequence no of a CO charge line which is connected to CO line
--   and sales charge type category is PACK SIZE.
@UncheckedAccess
FUNCTION Get_Pack_Size_Chg_Line_Seq_No (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   sequence_no_   NUMBER;
   CURSOR get_sequence_no IS
      SELECT sequence_no
      FROM   customer_order_charge_tab coc, sales_charge_type_tab sct
      WHERE  coc.order_no     = order_no_
      AND    coc.line_no      = line_no_
      AND    coc.rel_no       = rel_no_
      AND    coc.line_item_no = line_item_no_
      AND    coc.charge_type = sct.charge_type
      AND    coc.charge_price_list_no IS NOT NULL
      AND    sct.sales_chg_type_category = 'PACK_SIZE';
BEGIN
   OPEN get_sequence_no;
   FETCH get_sequence_no INTO sequence_no_;
   CLOSE get_sequence_no;
   RETURN sequence_no_;
END Get_Pack_Size_Chg_Line_Seq_No;

-- Check_Connected_Unit_Charges
--   This method will check unit charges which is connected to CO line and return TRUE if exist.
@UncheckedAccess
FUNCTION Check_Connected_Unit_Charges (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER ) RETURN VARCHAR2
IS
   dummy_ NUMBER; 
   CURSOR check_unit_charges IS
      SELECT 1
      FROM   customer_order_charge_tab 
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_
      AND    unit_charge  = 'TRUE';
BEGIN
   OPEN check_unit_charges;
   FETCH check_unit_charges INTO dummy_;
   IF (check_unit_charges%FOUND) THEN
      CLOSE check_unit_charges;
      RETURN 'TRUE';
   END IF;
   CLOSE check_unit_charges;
   RETURN 'FALSE';
END Check_Connected_Unit_Charges;

-- Copy_Order_Line_Tax_Lines
--   This method copy all connected tax lines from specified CO line
--   to the PACK SIZE charge line which is connected to same CO line.
PROCEDURE Copy_Order_Line_Tax_Lines (
   company_         IN VARCHAR2,
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   line_item_no_    IN NUMBER,
   to_sequence_no_  IN NUMBER )
IS   
BEGIN
   Tax_Handling_Order_Util_API.Transfer_Tax_Lines(company_, 
                                                  Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                  order_no_, 
                                                  line_no_, 
                                                  rel_no_, 
                                                  line_item_no_, 
                                                  '*',
                                                  Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, 
                                                  order_no_, 
                                                  to_sequence_no_, 
                                                  '*', 
                                                  '*',
                                                  '*',
                                                  'TRUE',
                                                  'TRUE');    

   -- Modify the charge line tax_code as NULL.
   Modify_Tax_Code(order_no_, to_sequence_no_, NULL);
END Copy_Order_Line_Tax_Lines;

--  Get_Base_Charge_Cost
--    This procedure returns the base price of the Fixed or % charge cost for the specific date and the desired date
--    currency rates. This method is calling from the CustomerOrderInvItem LU when creating the invoice postings and invoiced statistics.
PROCEDURE Get_Base_Charged_Cost(
   base_charge_cost_    OUT   NUMBER,
   order_no_            IN    VARCHAR2,
   sequence_no_         IN    NUMBER,
   invoice_id_          IN    NUMBER,
   invoice_item_id_     IN    NUMBER,
   company_             IN    VARCHAR2,
   unit_charge_         IN    BOOLEAN,
   inv_net_curr_amount_ IN    NUMBER DEFAULT NULL,
   invoiced_quantity_   IN    NUMBER DEFAULT NULL )
IS
   sales_charge_cost_      NUMBER;
   ord_buy_qty_due_        NUMBER := 1;
   rounding_               NUMBER;
   dummy_rate_             NUMBER;
   currency_code_          VARCHAR2(3);
   rec_                    CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   invoice_rec_            Customer_Order_Inv_Head_API.Public_Rec;
   invoice_line_rec_       Customer_Order_Inv_Item_API.Public_Rec;
   ref_invoice_id_         NUMBER;      
   ref_invoice_date_       DATE;
BEGIN
   rec_           := Get_Object_By_Keys___(order_no_, sequence_no_);
   
   invoice_rec_         := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);
   invoice_line_rec_    := Customer_Order_Inv_Item_API.Get(company_, invoice_id_, invoice_item_id_);
   IF(invoice_rec_.use_ref_inv_curr_rate = 'TRUE' ) THEN 
      ref_invoice_id_   := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, invoice_rec_.number_reference, invoice_rec_.series_reference);           
      ref_invoice_date_ := Customer_Order_Inv_Head_API.Get_Invoice_Date(company_, ref_invoice_id_);
   END IF;
   
   IF ( rec_.charge_cost IS NOT NULL ) THEN
      base_charge_cost_ := rec_.charge_cost;
   ELSE
      IF ( rec_.line_no IS NULL ) THEN
         sales_charge_cost_ := Customer_Order_API.Get_Total_Sales_Price(order_no_) * (rec_.charge_cost_percent / 100);
      ELSE
         
         IF ((inv_net_curr_amount_ IS NOT NULL) AND (rec_.unit_charge = 'TRUE')) THEN
            -- Since the sales_unit_price could be update in customer invoice and in turn if there are unit charges exists with charge %, charge line amount will also get change.
            -- Therefore when calculating the sales_charge_cost_ we need to consider inv_net_curr_amount_. 
            sales_charge_cost_ := inv_net_curr_amount_ * (rec_.charge_cost_percent / 100);
         ELSE   
            sales_charge_cost_ := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no) * (rec_.charge_cost_percent / 100);
         END IF;
         
         IF ( rec_.unit_charge = 'TRUE' ) THEN
            ord_buy_qty_due_ := Customer_Order_Line_API.Get_Buy_Qty_Due(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
         END IF;
      END IF;
      Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_charge_cost_,          dummy_rate_,        invoice_rec_.customer_no,        invoice_line_rec_.contract,
                                                            invoice_rec_.currency_code, sales_charge_cost_, invoice_rec_.currency_rate_type, NVL(ref_invoice_date_, invoice_rec_.invoice_date));
   END IF;
   
   IF unit_charge_ THEN
      IF ((invoiced_quantity_ IS NOT NULL) AND (rec_.unit_charge = 'TRUE')) THEN
         -- In customer invoice, invoiced quantity can be modified. If there are unit charges exists charge lines will also get 
         -- auto update with the modifed invoiced quantity. Therefore when calculating the base_charge_cost_ we must use the modified invoiced quantity.
         base_charge_cost_ := base_charge_cost_/invoiced_quantity_;
      ELSE
         -- ord_buy_qty_due_ will be 1 for fixed charge cost.
         -- Unit charges will not be rounded since rounding can cause to issue when calculate amounts against the qty.
         base_charge_cost_ := base_charge_cost_/ord_buy_qty_due_;
      END IF;  
   ELSE
      currency_code_    := Company_Finance_API.Get_Currency_Code(company_);
      rounding_         := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
      -- invoiced_qty will be used to determine base_charge_cost_ considering all the order delivery types.
      base_charge_cost_ := base_charge_cost_ * invoice_line_rec_.invoiced_qty;
      -- Here apply rounding due to total amounts needs to be rounded.
      base_charge_cost_ := ROUND(base_charge_cost_, rounding_);
   END IF;
END Get_Base_Charged_Cost;


-- Get_Connected_Address_Id
--   Called from CUSTOMER_ORDER_CHARGE_API.
--   This method returns the address id connected to a charge line.
@UncheckedAccess
FUNCTION Get_Connected_Address_Id (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN VARCHAR2
IS
   line_no_      CUSTOMER_ORDER_CHARGE_TAB.line_no%TYPE;
   rel_no_       CUSTOMER_ORDER_CHARGE_TAB.rel_no%TYPE;
   line_item_no_ CUSTOMER_ORDER_CHARGE_TAB.line_item_no%TYPE;
   address_id_   CUSTOMER_ORDER_TAB.ship_addr_no%TYPE;

   CURSOR get_ord_line_connection IS
      SELECT line_no, rel_no, line_item_no
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE  order_no = order_no_
      AND    sequence_no = sequence_no_;
BEGIN
   OPEN get_ord_line_connection;
   FETCH get_ord_line_connection INTO line_no_, rel_no_, line_item_no_;
   CLOSE get_ord_line_connection;
   IF (line_no_ IS NULL) THEN
      address_id_  := Customer_Order_API.Get_Ship_Addr_No(order_no_);
   ELSE
      address_id_ := Customer_Order_Line_API.Get_Ship_Addr_No(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   RETURN address_id_;
END Get_Connected_Address_Id;


@UncheckedAccess
FUNCTION Get_Promo_Charged_Qty (
   order_no_    IN VARCHAR2,
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_CHARGE_TAB.charged_qty%TYPE;
   CURSOR get_attr IS
      SELECT sum(charged_qty)
      FROM CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no = order_no_
      AND   campaign_id = campaign_id_
      AND   deal_id = deal_id_
      GROUP BY order_no, campaign_id, deal_id;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN NVL(temp_,0);
END Get_Promo_Charged_Qty;


@UncheckedAccess
FUNCTION Get_Promo_Net_Amount_Curr (
   order_no_    IN VARCHAR2,
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER ) RETURN NUMBER
IS
   company_         VARCHAR2(20);
   rounding_        NUMBER;
   currency_code_   VARCHAR2(3);   
   net_amount_curr_ NUMBER;

   CURSOR get_attr IS
      SELECT company, sum(charged_qty * charge_amount) 
      FROM CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no = order_no_
      AND   campaign_id = campaign_id_
      AND   deal_id = deal_id_
      GROUP BY company, order_no, campaign_id, deal_id;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO company_, net_amount_curr_;
   CLOSE get_attr;
   currency_code_ := Customer_Order_API.Get_Currency_Code(order_no_);
   rounding_      := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   RETURN NVL(ROUND(net_amount_curr_, rounding_), 0);
END Get_Promo_Net_Amount_Curr;


@UncheckedAccess
FUNCTION Get_Promo_Net_Amount_Base (
   order_no_    IN VARCHAR2,
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER ) RETURN NUMBER
IS
   rounding_         NUMBER;
   company_          VARCHAR2(20);
   currency_rate_    NUMBER;

   CURSOR get_attr IS
      SELECT company, currency_rate 
      FROM CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no = order_no_
      AND   campaign_id = campaign_id_
      AND   deal_id = deal_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO company_, currency_rate_;
   CLOSE get_attr;
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   -- Please Note : Since charge_amount (price each) can have as many decimals as you like when curr_rounding_ != rounding_
   -- the base amount needed to be derived from curr amount like in the invoice. To tally with invoice figures.
   RETURN NVL(ROUND( (Get_Promo_Net_Amount_Curr(order_no_, campaign_id_, deal_id_) *  currency_rate_), rounding_),0);
END Get_Promo_Net_Amount_Base;


@UncheckedAccess
FUNCTION Get_Promo_Gross_Amount_Base (
   order_no_    IN VARCHAR2,
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER ) RETURN NUMBER
IS
   gross_base_amount_   NUMBER;
   gross_curr_amount_   NUMBER;
BEGIN
   Get_Promo_Amounts(gross_base_amount_, gross_curr_amount_, order_no_, campaign_id_, deal_id_);
   RETURN NVL(gross_base_amount_, 0);
END Get_Promo_Gross_Amount_Base;


@UncheckedAccess
FUNCTION Get_Promo_Gross_Amount_Curr (
   order_no_    IN VARCHAR2,
   campaign_id_ IN NUMBER,
   deal_id_     IN NUMBER ) RETURN NUMBER
IS
   gross_base_amount_   NUMBER;
   gross_curr_amount_   NUMBER;
BEGIN
   Get_Promo_Amounts(gross_base_amount_, gross_curr_amount_, order_no_, campaign_id_, deal_id_);
RETURN NVL(gross_curr_amount_, 0);
END Get_Promo_Gross_Amount_Curr;

PROCEDURE Get_Promo_Amounts (
   gross_base_amount_ OUT NUMBER, 
   gross_curr_amount_ OUT NUMBER,
   order_no_          IN  VARCHAR2,
   campaign_id_       IN  NUMBER,
   deal_id_           IN  NUMBER ) 
IS
   rounding_         NUMBER;
   company_          CUSTOMER_ORDER_CHARGE_TAB.company%TYPE;
   sequence_no_      CUSTOMER_ORDER_CHARGE_TAB.sequence_no%TYPE;
   ordrec_           Customer_Order_API.Public_Rec;
   tax_dom_amount_    NUMBER := 0;   
   net_base_amount_   NUMBER := 0;
   tax_curr_amount_   NUMBER := 0; 
   net_curr_amount_   NUMBER := 0;
   
   CURSOR get_attr IS
      SELECT sequence_no, company 
      FROM CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no = order_no_
      AND   campaign_id = campaign_id_
      AND   deal_id = deal_id_;
BEGIN
   ordrec_ := Customer_Order_API.Get(order_no_);
   OPEN get_attr;
   FETCH get_attr INTO sequence_no_, company_;
   CLOSE get_attr;
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   net_curr_amount_ := NVL(ROUND(Get_Promo_Net_Amount_Curr(order_no_, campaign_id_, deal_id_), rounding_), 0);
   Tax_Handling_Order_Util_API.Get_Amounts(tax_dom_amount_, 
                                           net_base_amount_, 
                                           gross_base_amount_, 
                                           tax_curr_amount_, 
                                           net_curr_amount_, 
                                           gross_curr_amount_, 
                                           company_, 
                                           Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, 
                                           order_no_, 
                                           sequence_no_, 
                                           NULL, 
                                           NULL,
                                           NULL);        
END Get_Promo_Amounts;

-- Get_Co_Line_Project_Id
--   Returns the Project Id in the CO line which connected to a CO charge line.
@UncheckedAccess
FUNCTION Get_Co_Line_Project_Id (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN VARCHAR2
IS
   project_id_  customer_order_line_tab.project_id%TYPE;
   CURSOR get_project_id IS
      SELECT col.project_id
      FROM   CUSTOMER_ORDER_CHARGE_TAB coc, customer_order_line_tab col
      WHERE  coc.order_no     = order_no_
      AND    coc.sequence_no  = sequence_no_
      AND    coc.order_no     = col.order_no
      AND    coc.line_no      = col.line_no
      AND    coc.rel_no       = col.rel_no
      AND    coc.line_item_no = col.line_item_no;
BEGIN
   OPEN get_project_id;
   FETCH get_project_id INTO project_id_;
   CLOSE get_project_id;
   RETURN project_id_;
END Get_Co_Line_Project_Id;


-- Get_Co_Line_Activity_Seq
--   Returns the Activity Seq in the CO line which connected to a CO charge line.
@UncheckedAccess
FUNCTION Get_Co_Line_Activity_Seq (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   activity_seq_  customer_order_line_tab.activity_seq%TYPE;
   CURSOR get_activity_seq IS
      SELECT col.activity_seq
      FROM   CUSTOMER_ORDER_CHARGE_TAB coc, customer_order_line_tab col
      WHERE  coc.order_no     = order_no_
      AND    coc.sequence_no  = sequence_no_
      AND    coc.order_no     = col.order_no
      AND    coc.line_no      = col.line_no
      AND    coc.rel_no       = col.rel_no
      AND    coc.line_item_no = col.line_item_no;
BEGIN
   OPEN get_activity_seq;
   FETCH get_activity_seq INTO activity_seq_;
   CLOSE get_activity_seq;
   RETURN activity_seq_;
END Get_Co_Line_Activity_Seq;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_Tax_Info (
   attr_          OUT VARCHAR2,
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2)
IS
   linerec_                CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   tax_liability_type_db_  VARCHAR2(20);
   tax_liability_          VARCHAR2(20);
   delivery_country_db_    VARCHAR2(2);
   order_rec_              Customer_Order_API.Public_Rec;
   order_line_rec_         Customer_Order_Line_API.Public_Rec;
   ship_addr_no_           VARCHAR2(50);   
BEGIN
   linerec_        := Get_Object_By_Keys___(source_ref1_, source_ref2_);
   order_rec_      := Customer_Order_API.Get(source_ref1_);
   
   Client_SYS.Set_Item_Value('TAX_CODE', linerec_.tax_code, attr_);
   Client_SYS.Set_Item_Value('TAX_CLASS_ID', linerec_.tax_class_id, attr_);
   
   tax_liability_         := Get_Connected_Tax_Liability(source_ref1_, source_ref2_);
   tax_liability_type_db_ := Get_Conn_Tax_Liability_Type_Db(source_ref1_, source_ref2_);
   delivery_country_db_   := Get_Connected_Deliv_Country(source_ref1_, source_ref2_);
   IF (linerec_.line_no IS NOT NULL) THEN
      order_line_rec_ := Customer_Order_Line_API.Get(source_ref1_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
      IF (order_line_rec_.customer_no != order_line_rec_.deliver_to_customer_no) THEN
         ship_addr_no_ := order_rec_.ship_addr_no;
      ELSE
         ship_addr_no_ := order_line_rec_.ship_addr_no;
      END IF;
   ELSE
      ship_addr_no_ := order_rec_.ship_addr_no;
   END IF;
   
   Client_SYS.Set_Item_Value('TAX_LIABILITY', tax_liability_, attr_);   
   Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', tax_liability_type_db_, attr_);   
   Client_SYS.Set_Item_Value('DELIVERY_COUNTRY_DB', delivery_country_db_, attr_);
   Client_SYS.Set_Item_Value('IS_TAXABLE_DB', Sales_Charge_Type_API.Get_Taxable_Db(linerec_.contract, linerec_.charge_type), attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY_DATE', TRUNC(Site_API.Get_Site_Date(linerec_.contract)), attr_);
   Client_SYS.Set_Item_Value('SHIP_ADDR_NO', ship_addr_no_, attr_);
   Client_SYS.Set_Item_Value('PLANNED_SHIP_DATE', NVL(order_line_rec_.planned_ship_date, TRUNC(Site_API.Get_Site_Date(order_rec_.contract))), attr_);
   Client_SYS.Set_Item_Value('SUPPLY_COUNTRY_DB', order_rec_.supply_country , attr_);
   Client_SYS.Set_Item_Value('DELIVERY_TYPE',  NVL(linerec_.delivery_type, '*'), attr_);
END Get_Tax_Info;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_External_Tax_Info (
   attr_          OUT VARCHAR2,
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2,
   company_       IN VARCHAR2)
IS
   linerec_                   CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
BEGIN
   linerec_  := Get_Object_By_Keys___(source_ref1_, source_ref2_);   
   Client_SYS.Set_Item_Value('QUANTITY', linerec_.charged_qty, attr_);   
END Get_External_Tax_Info;

-- Modify_Tax_Info
--   Modifies the tax information with the tax line tax information at the same time.
--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Modify_Tax_Info (
   attr_         IN OUT VARCHAR2,
   source_ref1_  IN VARCHAR2,
   source_ref2_  IN VARCHAR2,
   source_ref3_  IN VARCHAR2,
   source_ref4_  IN VARCHAR2 )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   oldrec_           CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   newrec_           CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;   
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, source_ref1_, source_ref2_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.tax_code  := Client_Sys.Get_Item_Value('TAX_CODE', attr_);   
   newrec_.tax_class_id := Client_Sys.Get_Item_Value('TAX_CLASS_ID', attr_);
   Client_SYS.Set_Item_Value('TAX_CODE_CHANGED', 'TRUE', attr_);
   newrec_.tax_calc_structure_id  := Client_Sys.Get_Item_Value('TAX_CALC_STRUCTURE_ID', attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Tax_Info;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Validate_Source_Pkg_Info (
   source_ref1_  IN VARCHAR2,
   source_ref2_  IN VARCHAR2,
   source_ref3_  IN VARCHAR2,
   source_ref4_  IN VARCHAR2,
   attr_         IN VARCHAR2 )
IS
   status_                    VARCHAR2(30);
   chargerec_                 Customer_Order_Charge_API.Public_Rec;   
   error_                     BOOLEAN := FALSE;
   sales_chg_type_category_   VARCHAR2(20);
   do_additional_validate_    VARCHAR2(5);
BEGIN
   chargerec_ := Customer_Order_Charge_API.Get(source_ref1_, source_ref2_);
   IF (Customer_Order_API.Get_Objstate(source_ref1_) = 'Cancelled') THEN
      error_ := TRUE;
   ELSIF (chargerec_.line_no IS NOT NULL) THEN
      status_ := Customer_Order_Line_API.Get_Objstate(source_ref1_, chargerec_.line_no, chargerec_.rel_no, chargerec_.line_item_no);
      IF (status_ IN ('Cancelled', 'Invoiced')) THEN
         error_ := TRUE;
      END IF;
   ELSIF (chargerec_.invoiced_qty != 0) THEN
      error_ := TRUE;
   END IF;
   IF error_ THEN
      Error_SYS.Record_General(lu_name_, 'INVOICED_LINE: Tax lines cannot be altered when the charge line has been Cancelled or Invoiced/Closed.');
   END IF;
   
   do_additional_validate_ := nvl(Client_SYS.Get_Item_Value('DO_ADDITIONAL_VALIDATE', attr_),'FALSE');
   
   IF (do_additional_validate_ = 'TRUE') THEN
      sales_chg_type_category_ := Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(chargerec_.contract, chargerec_.charge_type);
      Do_Additional_Validations___(chargerec_.charge_price_list_no, sales_chg_type_category_);
   END IF;
END Validate_Source_Pkg_Info;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Fetch_Tax_Line_Param(   
   company_                IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2) RETURN Tax_Handling_Order_Util_API.tax_line_param_rec
IS
   order_rec_           Customer_Order_API.Public_Rec;
   charge_rec_          Customer_Order_Charge_API.Public_Rec;
   tax_line_param_rec_  Tax_Handling_Order_Util_API.tax_line_param_rec;
   order_line_rec_      Customer_Order_Line_API.Public_Rec;
   customer_no_         VARCHAR2(20);
   ship_addr_no_        VARCHAR2(50);   
   tax_liability_       VARCHAR2(20);
   tax_liability_date_  DATE;
BEGIN
   order_rec_      := Customer_Order_API.Get(source_ref1_);
   charge_rec_     := Customer_Order_Charge_API.Get(source_ref1_, source_ref2_);
   IF (charge_rec_.line_no IS NOT NULL) THEN
      order_line_rec_ := Customer_Order_Line_API.Get(source_ref1_, charge_rec_.line_no, charge_rec_.rel_no, charge_rec_.line_item_no);
      tax_liability_date_ := order_line_rec_.planned_ship_date;      
      IF (order_line_rec_.customer_no != order_line_rec_.deliver_to_customer_no) THEN
         customer_no_  := order_rec_.customer_no;
         ship_addr_no_ := order_rec_.ship_addr_no;
         tax_liability_ := order_rec_.tax_liability;
      ELSE
         customer_no_  := order_line_rec_.customer_no;
         ship_addr_no_ := order_line_rec_.ship_addr_no;
         tax_liability_ := order_line_rec_.tax_liability;
      END IF;
   ELSE
      tax_liability_date_ := order_rec_.wanted_delivery_date;
      customer_no_  := order_rec_.customer_no;
      ship_addr_no_ := order_rec_.ship_addr_no;
      tax_liability_ := order_rec_.tax_liability;
   END IF;
      
   tax_line_param_rec_.company               := company_;
   tax_line_param_rec_.contract              := order_rec_.contract;
   tax_line_param_rec_.customer_no           := customer_no_;
   tax_line_param_rec_.tax_code              := charge_rec_.tax_code;
   tax_line_param_rec_.tax_calc_structure_id := charge_rec_.tax_calc_structure_id;
   tax_line_param_rec_.tax_class_id          := charge_rec_.tax_class_id;
   tax_line_param_rec_.ship_addr_no          := ship_addr_no_;
   tax_line_param_rec_.planned_ship_date     := tax_liability_date_;
   tax_line_param_rec_.supply_country_db     := order_rec_.supply_country;
   tax_line_param_rec_.delivery_type         := NVL(charge_rec_.delivery_type, '*');
   tax_line_param_rec_.object_id             := charge_rec_.charge_type;
   tax_line_param_rec_.use_price_incl_tax    := order_rec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code         := order_rec_.currency_code;
   tax_line_param_rec_.currency_rate         := charge_rec_.currency_rate;
   tax_line_param_rec_.tax_liability         := tax_liability_;
   tax_line_param_rec_.tax_liability_type_db := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_liability_, 
                                                   Get_Connected_Deliv_Country(source_ref1_, source_ref2_)); 
   tax_line_param_rec_.taxable               := Sales_Charge_Type_API.Get_Taxable_Db(order_rec_.contract, charge_rec_.charge_type);
   
   RETURN tax_line_param_rec_;
   
END Fetch_Tax_Line_Param;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Fetch_Gross_Net_Tax_Amounts(
   gross_curr_amount_      OUT NUMBER,
   net_curr_amount_        OUT NUMBER,
   tax_curr_amount_        OUT NUMBER,
   company_                IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2) 
IS
BEGIN
   gross_curr_amount_ := Customer_Order_Charge_API.Get_Total_Charged_Amt_Incl_Tax(source_ref1_, source_ref2_);
   net_curr_amount_  := Customer_Order_Charge_API.Get_Total_Charged_Amount(source_ref1_, source_ref2_);
   tax_curr_amount_  := Customer_Order_Charge_API.Get_Total_Tax_Amount_Curr(source_ref1_, source_ref2_); 
END Fetch_Gross_Net_Tax_Amounts;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Get_Price_Total (
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Total_Charged_Amount(source_ref1_, source_ref2_);
END Get_Price_Total;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Get_Price_Incl_Tax_Total  (
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Total_Charged_Amt_Incl_Tax (source_ref1_, source_ref2_);
END Get_Price_Incl_Tax_Total ;

-- Get_Line_Address_Info
--   Returns Customer Order charge line Address information.
--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_Line_Address_Info (
   address1_      OUT VARCHAR2,
   address2_      OUT VARCHAR2,
   country_code_  OUT VARCHAR2,
   city_          OUT VARCHAR2,
   state_         OUT VARCHAR2,
   zip_code_      OUT VARCHAR2,
   county_        OUT VARCHAR2,
   in_city_       OUT VARCHAR2,
   source_ref1_   IN  VARCHAR2,
   source_ref2_   IN  VARCHAR2,
   source_ref3_   IN  VARCHAR2,
   source_ref4_   IN  VARCHAR2,
   company_       IN  VARCHAR2)
IS
   order_addr_rec_      Customer_Order_Address_API.Cust_Ord_Addr_Rec;
   ord_line_addr_rec_   Cust_Order_Line_Address_API.Co_Line_Addr_Rec;
   line_no_             CUSTOMER_ORDER_CHARGE_TAB.line_no%TYPE;
   rel_no_              CUSTOMER_ORDER_CHARGE_TAB.rel_no%TYPE;
   line_item_no_        CUSTOMER_ORDER_CHARGE_TAB.line_item_no%TYPE;
   
   CURSOR get_cust_ord_line_connection IS
      SELECT line_no, rel_no, line_item_no
      FROM   customer_order_charge_tab
      WHERE  order_no    = source_ref1_
      AND    sequence_no = source_ref2_;
BEGIN
   OPEN get_cust_ord_line_connection;
   FETCH get_cust_ord_line_connection INTO line_no_, rel_no_, line_item_no_;
   CLOSE get_cust_ord_line_connection;
   
   IF ((line_no_ IS NOT NULL) AND (rel_no_ IS NOT NULL) AND (line_item_no_ IS NOT NULL)) THEN
      ord_line_addr_rec_ := Cust_Order_Line_Address_API.Get_Co_Line_Addr(source_ref1_, line_no_, rel_no_, line_item_no_);
      address1_          := ord_line_addr_rec_.address1;
      address2_          := ord_line_addr_rec_.address2;
      country_code_      := ord_line_addr_rec_.country_code;
      city_              := ord_line_addr_rec_.city;
      state_             := ord_line_addr_rec_.state;
      zip_code_          := ord_line_addr_rec_.zip_code;
      county_            := ord_line_addr_rec_.county;
      in_city_           := ord_line_addr_rec_.in_city;
   ELSE
      order_addr_rec_    := Customer_Order_Address_API.Get_Cust_Ord_Addr(source_ref1_);
      address1_          := order_addr_rec_.address1;
      address2_          := order_addr_rec_.address2;
      country_code_      := order_addr_rec_.country_code;
      city_              := order_addr_rec_.city;
      state_             := order_addr_rec_.state;
      zip_code_          := order_addr_rec_.zip_code;
      county_            := order_addr_rec_.county;
      in_city_           := order_addr_rec_.in_city;
   END IF;
END Get_Line_Address_Info;


-- Recalculate_Charges
--   This method call from Order_Quotation_Charge_API.Transfer_To_Order_Line 
---  after transferring tax lines to customer order charge to recalculate and save charge prices. 
PROCEDURE Recalculate_Charges  (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   newrec_           CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;   
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, sequence_no_);
   newrec_ := Lock_By_Id___(objid_, objversion_);
   Calculate_Charges___(newrec_);
   Update_Line___(objid_, newrec_);
END Recalculate_Charges;

-- Copy_Charges_Lines
--   Copies all the charge lines in from_order_no_ to to_order_no_. 
PROCEDURE Copy_Charge_Lines (
   from_order_no_        IN VARCHAR2,
   to_order_no_          IN VARCHAR2,   
   copy_lines_           IN VARCHAR2,
   copy_document_texts_  IN VARCHAR2) 
IS  
   TYPE order_chrg_tab IS TABLE OF CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE INDEX BY PLS_INTEGER;
   order_charge_tab_    order_chrg_tab;
   attr_                VARCHAR2(2000);
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   newrec_              CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   empty_rec_           CUSTOMER_ORDER_CHARGE_TAB%ROWTYPE;
   header_rec_          Customer_Order_API.Public_Rec; 
   curr_code_           varchar2(3);
   customer_no_         varchar2(20);
   curr_rate_           number;
   conv_factor_         number;
   curr_type_           varchar2(10);
      
   CURSOR get_rec IS
      SELECT coc.*
      FROM CUSTOMER_ORDER_CHARGE_TAB coc, SALES_CHARGE_TYPE_TAB sct
      WHERE order_no = from_order_no_
      AND coc.charge_type = sct.charge_type
      AND coc.contract = sct.contract
      AND sct.sales_chg_type_category = 'OTHER';
      
   CURSOR get_unconnected_charg_rec IS
      SELECT coc.*
      FROM CUSTOMER_ORDER_CHARGE_TAB coc, SALES_CHARGE_TYPE_TAB sct
      WHERE order_no = from_order_no_
      AND coc.charge_type = sct.charge_type
      AND coc.contract = sct.contract
      AND sct.sales_chg_type_category = 'OTHER'
      AND coc.line_no IS NULL;   
BEGIN  
   	
   Customer_Order_API.Exist(to_order_no_);
   header_rec_ := Customer_Order_API.Get(to_order_no_);   
   IF (copy_lines_ = Fnd_Boolean_API.DB_TRUE) THEN 
      OPEN get_rec;
   ELSE 
      OPEN get_unconnected_charg_rec;
   END IF ;
   LOOP  
      IF (copy_lines_ = Fnd_Boolean_API.DB_TRUE) THEN 
         FETCH get_rec BULK COLLECT INTO order_charge_tab_ LIMIT 1000;
      ELSE 
         FETCH get_unconnected_charg_rec BULK COLLECT INTO order_charge_tab_ LIMIT 1000;
      END IF ;

      IF (order_charge_tab_.COUNT >0) THEN             
         FOR j IN order_charge_tab_.FIRST..order_charge_tab_.LAST LOOP
            -- Reset variables
            attr_                := NULL;            
            Client_SYS.Add_To_Attr('COPY_ORDER_CHARGE', 'TRUE', attr_);   
            Client_SYS.Add_To_Attr('ORIGINAL_ORDER_NO', from_order_no_, attr_);
            Client_SYS.Add_To_Attr('ORIGINAL_SEQ_NO', order_charge_tab_(j).sequence_no, attr_);      
            Client_SYS.Add_To_Attr('ORIGINAL_FREE_OF_CHARGE', order_charge_tab_(j).free_of_charge, attr_);
            newrec_              := empty_rec_;
            -- Assign copy record
            newrec_              := order_charge_tab_(j);           
            newrec_.order_no     := to_order_no_;               
            newrec_.rowkey       := NULL ; 
            curr_code_           := Customer_Order_API.Get_Currency_Code(newrec_.order_no); 
            customer_no_         := Customer_Order_API.Get_Customer_No (newrec_.order_no);
            Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, conv_factor_, curr_rate_, newrec_.company, curr_code_,
                                                           Site_API.Get_Site_Date(newrec_.contract), 'CUSTOMER', customer_no_);
            newrec_.currency_rate := curr_rate_ / conv_factor_;  
            newrec_.invoiced_qty := 0;
            newrec_.qty_returned := 0;
            
            IF (copy_document_texts_ = Fnd_Boolean_API.DB_FALSE) THEN
               newrec_.note_id := NULL;
            END IF;
            
            newrec_.charge_percent_basis      := NULL;
            newrec_.base_charge_percent_basis := NULL;
            
            Insert___(objid_, objversion_, newrec_, attr_);            
                      
            --Copy custom field values
            newrec_ := Get_Object_By_Id___(objid_);
            Custom_Objects_SYS.Copy_Cf_Instance(lu_name_, order_charge_tab_(j).rowkey, newrec_.rowkey);                
            Recalculate_Tax_Lines___(newrec_, FALSE, NULL);
         END LOOP;
      END IF;            
      IF (copy_lines_ = Fnd_Boolean_API.DB_TRUE) THEN 
         EXIT WHEN get_rec%NOTFOUND;
      ELSE 
         EXIT WHEN get_unconnected_charg_rec%NOTFOUND;
      END IF ;
   END LOOP;
   IF (copy_lines_ = Fnd_Boolean_API.DB_TRUE) THEN 
      CLOSE get_rec;       
   ELSE 
      CLOSE get_unconnected_charg_rec;       
   END IF;       
END Copy_Charge_Lines;

@UncheckedAccess
FUNCTION Get_Connected_Addr_Flag(
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Connected_Addr_Flag__(order_no_, sequence_no_);
END Get_Connected_Addr_Flag;

-- Get_Objversion
--   Return the current objversion for line.
@UncheckedAccess
FUNCTION Get_Objversion (
   order_no_     IN VARCHAR2,
   sequence_no_  IN NUMBER) RETURN VARCHAR2
IS
   temp_  customer_order_charge_tab.rowversion%TYPE;
   CURSOR get_attr IS
      SELECT rowversion
      FROM   customer_order_charge_tab
      WHERE  order_no = order_no_
      AND   sequence_no = sequence_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN TO_CHAR(temp_, 'YYYYMMDDHH24MISS');
END Get_Objversion;

FUNCTION Get_Co_Line_Cust_Tax_Usg_Type (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN VARCHAR2
IS
   customer_tax_usage_type_  customer_order_line_tab.customer_tax_usage_type%TYPE;
   CURSOR get_customer_tax_usage_type IS
      SELECT col.customer_tax_usage_type
      FROM   CUSTOMER_ORDER_CHARGE_TAB coc, customer_order_line_tab col
      WHERE  coc.order_no     = order_no_
      AND    coc.sequence_no  = sequence_no_
      AND    coc.order_no     = col.order_no
      AND    coc.line_no      = col.line_no
      AND    coc.rel_no       = col.rel_no
      AND    coc.line_item_no = col.line_item_no; 
BEGIN
   OPEN get_customer_tax_usage_type;
   FETCH get_customer_tax_usage_type INTO customer_tax_usage_type_;
   CLOSE get_customer_tax_usage_type;
   RETURN customer_tax_usage_type_;
END Get_Co_Line_Cust_Tax_Usg_Type;

   
