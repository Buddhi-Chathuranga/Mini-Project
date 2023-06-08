-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPart
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220131  Jayplk  MF21R2-6781, Modified Check_Auto_Capability_Check___() to not allow automatic capability check to be set to Reserve and Allocate when 
--                  connected sales part has source option set to Shop Order.
--  211207  NiRalk  SC21R2-5959, Modified New_Part() and Copy_Impl___() methods by adding statistical_code_,acquisition_origin_ and acquisition_reason_id_.
--  211006  SBalLK  SC21R2-3216, Modified Copy_Impl___() and added Convert_Storage_Req_Uom___() methods to convert storage requirement to
--  211006          company related UOM when copy inventory part from on contract to other contract connected to different companies.
--  210727  RasDlk  SC21R2-1035, Modified Prepare_Insert___ and Check_Insert___ by setting a default value for EXCL_SHIP_PACK_PROPOSAL_DB.
--  210710  LEPESE  MF21R2-2533, Added UncheckedAccess annotation to method Get_Values_For_Accounting to get better performance. 
--  210615  JaThlk  SC21R2-1470, Obsoleted Modify_Lifecycle_Stage with the new development of manual inventory part classification.
--  210601  JaThlk  SC21R2-1009, Modified Modify_Abc_Frequency_Lifecycle to reset abc_class_locked_until, freq_class_locked_until or life_stage_locked_until
--  210601          if these dates are not valid anymore and modified Check_Update___ to prevent raising errors when lifecycle_stage or frequency_class
--  210601          are getting updated from the client and modified Insert___ to set initial values for lifecycle_stage and frequency_class.
--  210512  JiThlk  SCZ-14214, Change API for Get_Ipr_Active_Db to Site_Ipr_Info_API.
--  210302  JaThlk  Bug 158208 (SCZ-13846), Modified Qty_To_Order to create purchase order when it is MULTISITE_PLAN and 
--  210302          the component DISORD has not been installed.
--  210223  UtSwlk  MFZ-6989, Merged Bug 158059, Replaced the default calendar Id in Get_Latest_Order_Date().
--  210202  GrGaLK  SC2020R1-12360, Changed the parameter order of Raise_Inv_Part_Not_Exist___() which was called inside Raise_Record_Not_Exist___()
--  210120  SBalLK  Issue SC2020R1-11830, Modified methods with Client_SYS.Add/Set_To_Attr() by removing attr_ functionality to optimize the performance.
--  200824  JICESE  Changed HSE integration to post message to receiver, BizAPIs obsoleted
--  200720  BudKlk  SCXTEND-4452, Added ObjectConnectionMethod annotation to the Get_Description() method.
--  200602  UtSwLK  Bug 154219(MFZ-4676), Modified public record Get_Mrp_Part_Rec, to correct its data types.
--  200406  BudKlk  Bug 152981(SCZ-9159), Modified the method Check_Value_Method_Combinat___()to allow a combination of Weighted Average / Cost per Lot Batch for configured parts.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in calls to Data_Capture_Session_Lov_API.New.
--  200220  AmPalk  Bug 151912(MFZ-3086), Modified New_Part to insert abc_class_ to the new record based on the passed in value. Merged under MFZ-3401.
--  191225  SBalLK  Bug 151591(SCZ-7966), Modified Validate_Lead_Time_Code___(), Check_Update___() and Check_Insert___() methods to validate connected part structures
--  191225          and routing when only part type changed.
--  191202  SBalLK  Bug 151210 (SCZ-7953), Modified Copy_Impl___() method to copy custom field from original part to new part.
--  190925  DaZase  SCSPRING20-115, Added Raise_Inv_Part_Not_Exist___, Raise_Part_Not_Exist___, Raise_Lot_Bat_Cost_Lvl_Error___, Raise_Position_Part_Type_Error___, 
--  190925          Raise_Input_Uom_Error___ to solve MessageDefinitionValidation issues.
--  190519  Cpeilk  Bug 147826 (SCZ-4760), Modified method Get_Site_Converted_Qty() by adding a default null parameter to_part_no.
--  180716  ChBnlk  Bug 142182, Modified Check_Update___() to check for the input_unit_meas_group_id in the newrec_ instead of the value from the attr_, when checking 
--  180716          whether it is allowed to be changed.
--  171117  DAYJLK  STRSC-12219, Modified Copy_Part_To_Site_Impl__ to pattern match records with NULL for second commodity when using the % wildcard.
--  171115  Asawlk  Bug 138667, Modified Validate_Lead_Time_Code___ to not to allow structures for expense parts as purchased raw parts by performing the same validations.
--  170801  AmPalk  STRMF-5011, Added region_of_origin_ to the  New_Part.
--  170606  AwWelk  STRSC-8620, Modified Handle_Planning_Attr_Change___() to check whether the site is IPR-Active or not.
--  170512  LEPESE  STRSC-8414, Made modifications in Copy_Part_To_Site and Copy_Part_To_Site_Impl__ to support wildcards in second_commodity_.
--  170214  Hasplk  STRMF-7997, Merged LCS patch 132521.
--  170214          161228  Hasplk  Bug 132521, Re-implement Pack_And_Post_Message__ method to support IFS connect framework.
--  161118  ErFelk  Bug 132138, Modified Qty_To_Order() by increasing the length of demand_code to 200 from 20.
--  161028  Hairlk  APPUXX-5312, Modified ONLINECONSUMNOTALLOW message to indicate that Rejected quotation lines are also considered.
--  161006  LEPESE  LIM-9167, added attribute mandatory_expiration_date.
--  160526  SWeelk  Bug 128643, Modified Qty_To_Order() by removing calls to Purchase_Req_Util_API.Activate_Requisition() to stop
--  160526          unnecessarily releasing the PR header. 
--  160525  MAJOSE  STRMF-4087, Included new planning method H in public cursor Get_Mrp_Part_Cur.
--  160426  SudJlk  STRSC-2107, Added validity to commodity_group-api.exist calls.
--  160405  Rakalk  MATP-2099, CBS/CBSINT Split Moved code from Scheduling_Int_API to Cbs_So_Int_API.
--  160212  RuLiLk  Bug 127279, Added new parameter co_reserve_onh_analys_flag_db_ to method New_Part() to handle copy functionality of 'Availability Check CO Reserve'.
--  160212          Modified Copy_Impl___() to pass value for co_reserve_onh_analys_flag_db_ when calling New_Part().
--  151029  JeLise  LIM-4351, Removed attribute pallet_handled and all related methods and code.
--  150911  RaKalk  AFT-4757, Modified Get_Latest_Order_Date to to avoid infinite loops.
--  150910  ThImlk  AFT-4263, Modified the method, Get_Latest_Order_Date() to correct the Latest Order Date calcuation logic.
--  150811  Vishlk  ANPJ-1349, Restrict creation of inventory parts for external resource purchase parts.
--  150622  MAJOSE  MONO-370, Added columns to the micro_cache record, and modified Get_Values_For_Accounting to use the new columns.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150408  AwWelk  GEN-414, Added Check_Any_Forecast_Part_Exist(), Get_Forecast_Trans_Start_Date() and Get_Forecast_Phase_In_Date() to facilate fetching values from
--  150408          DEMAND component.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729          method call in ORDER BY clause to sort string and number values seperately.
--  150727  Asawlk  Bug 121753, Modified Insert___() by placing the the Cost_Set_API.Create_Part_Cost() code block right before calling Inventory_Part_Config_API.NEW()
--  150727          so that a record is inserted to Standard_Cost_Bucket_Tab first. 
--  141201  AwWelk  GEN-239, Modified Update___() by simplifying the condition for resetting the decline/expired date and issue counters. Modified Check_Common___() 
--  141201          by adding validation to check whether the issue counters are integers.
--  141201  AwWelk  GEN-239, Moved lifecycle stage change logic from Modify_Abc_Frequency_Lifecycle() to Update___(). Renamed Modify_Life_Stg_Issue_Counters() to 
--  141201          Add_Issue_For_Decline_Expired() and restructured the code. Added validations for decline_issue_counter and expired_issue_counter  in Check_Common___().
--  141201          Modified Modify_Latest_Stat_Issue_Date() to move the part from 'Expired' state to 'Introduction' state. Modified Modify_Lifecycle_Stage() by removing
--  141201          NULL value assignments for issue counters and expired_date, decline_date fields since they are handled in Update___().
--  141118  NiDalk  Bug 119736, Added parameter ignore_unit_type_ to Get_Calc_Rounded_Qty and Get_Calc_Rounded_Qty___. Modified Get_Calc_Rounded_Qty___
--  141118          to round adjusted_qty_ to extra two places when ignore_unit_type_ is set to TRUE. 
--  141107  AwWelk  GEN-184, Modified Modify_Abc_Frequency_Lifecycle() to change the first stat issue date of Expired parts when the expired issue
--  141107          issue counter is exceeded. 
--  141105  PraWlk  Bug 117741, Added parameter dop_netting_db_ to New_Part() and modified Copy_Impl___() to copy DOP netting when using Copy Part.
--  141031  AwWelk  GEN-49, Added method Modify_Lifecycle_Stage().
--  141029  AwWelk  GEN-158, Added Modify_Life_Stg_Issue_Counters() and modified Modify_Abc_Frequency_Lifecycle() by adding
--  141029          logic for the fields DECLINE_DATE, EXPIRED_DATE, DECLINE_ISSUE_COUNTER and EXPIRED_ISSUE_COUNTER.
--  141028  LEPESE  PRSC-3954, copied logic from Modify_Earliest_Ultd_Sply_Date into a new implementation method Mod_Earliest_Ultd_Sply_Date___.
--  141028          Added one extra interface method Modify_Earliest_Ultd_Sply_Date having a boolean OUT parameter date_modified_.
--  141023  AwWelk  GEN-44, Modified Insert___() by making default value for frequency_class to VERY SLOW MOVER.
--  141017  LEPESE  PRSC-3337, added parameter backdate_allowed_db_ to method Modify_Earliest_Ultd_Sply_Date. Also modified the
--  141017          Modify_Earliest_Ultd_Sply_Date method to avoid unnecessary updates and the consider the new parameter. 
--  140911  NWeelk   Bug 118453, Modified Update___ by calling Handle_Type_Code_Change in expctr to add the info message CHECKEXPCONN
--  140911           to be raised when modifying the type_code of an export controlled part.
--  140804  AwWelk   PRSC-2052, Corrected the check_update___ method to handle asset class default values.
--  140718  AwWelk   PRSC-1525, Removed the overriden Unpack___ method and moved the logic to Check_Insert___ and Check_Update___.
--  140703  MaEdlk   Bug 117072, Removed rounding of volume and weight from Get_Volume_Net and Get_Weight_Net methods. 
--  140620  IsSalk   Bug 113974, Added attribute reset_config_std_cost. Modified New_Part(), Copy_Impl___() adn Update_Cache___() accordingly.
--  140619  DaZase   PRSC-1207, Changed Create_Data_Capture_Lov so it now only uses ORDER BY ASC.
--  140514  JeLise   PBSC-9466, Added check on newrec_.inventory_valuation_method to set the correct value for newrec_.negative_on_hand in Check_Insert___.
--  140327  TiRalk   Bug 112795, Modified Add_To_Purchase_Order___ to pass value correctly to is_order_proposal_ parameter.
--  140225  TiRalk   Bug 112795, Added Add_To_Purchase_Order___ to handle logic to create PO, passed value for is_order_proposal_ in 
--  140225           Purchase_Order_API.Prepare_Order call and Modified method Qty_To_Order to identify that PO has been created from order proposal.
--  140206  AyAmlk   Bug 115096, Modified Check_Delete___() to raise an error when trying to remove a record with part no having the caret symbol.
--  140212  Matkse   Made column Putaway_Zone_Refill_Option private and added method Get_Putaway_Zone_Refill_Option to handle inheritence functionality.
--  140123  AyAmlk   Bug 113885, Modified Qty_To_Order() to increase the length of requisition_code_ to 20.
--  140113  Rakalk   PBMF-4500, Added function Get_Latest_Order_Date
--  131119  AwWelk   PBSC-4272,Modifid Unpack_Check_Insert___  to take the value of ESTIMATED_MATERIAL_COST, only if it available in attr_.
--  131112  UdGnlk   PBSC-225, Modified base view comments to align with model file errors.
--  131017  IRJALK   Bug 110594, Added new parameter unit_meas_ to method Get_Calc_Rounded_Qty___() in order to round adjust_qty_ 
--  131017           only when the unit type of the used unit of measure is 'WEIGHT','VOLUME'or 'LENGTH'. Also modified Get_Calc_Rounded_Qty()  
--  131017           to get the value of unit_meas_ and passed to Get_Calc_Rounded_Qty___().
--  130924  Cpeilk   Bug 110800, Modified Check_Value_Method_Change___ to change the return value from method
--  130924           Inventory_Part_In_Stock_API.Check_Consignment_Exist to a boolean variable.  
--  130904  ThiMlk   Bug 109778, Made method Check_Negative_On_Hand___() as public. Modified Check_Negative_On_Hand() and Unpack_Check_Insert___()   
--  130904           to avoid allowing negative quantity on-hand for tracked parts by giving an error.
--  130823  IsSalk   Bug 112006, Modified Unpack_Check_Update___ by removing error message NOPURPART to avoid popping error message 
--  130823           when inventory UoM group is used.
--  130730  PraWlk   Bug 106812, Modified Get_Std_Name_Id() to get the Std_Name_Id from the part catalog when Inventory part std_Name_Id is NULL.
--  130730           Also modified the Get() by removing std_Name_Id.
--  130715  ErFelk   Bug 111147, Modified Get_Cumm_Leadtime() by moving the return statement to the end of the function.
--  121122  NaLrlk   Modified Company_Owned_Stock_Exists___ to exclude Supplier Rented and Company Rental Asset ownership.
--  130827  AwWelk   TIBE-872, Corrected the fresh install error found in Insert___().
--  130821  AwWelk   TIBE-872, Corrected the conditional compilation error at Unpack_Check_Update___().
--  130813  UdGnlk   TIBE-872, Removed global variable new_estimated_material_cost_ and move to methods to pass through the attr.
--  130812  UdGnlk   TIBE-872, Removed the dynamic code and modify to conditional compilation.
--  130809  UdGnlk   TIBE-872, Removed the dynamic code and modify to conditional compilation.
--  130531  Asawlk   EBALL-37, Modified Unpack_Check_Update___() by calling Invent_Part_Quantity_Util_API.Check_Part_Exist() instead of 
--  130531           Inventory_Part_In_Stock_API.Check_Part_Exist() to check for parts in stock, in trasit and at customer. Also modified error
--  130531           message HAS_QTY_ON_HAND. 
--  130529  Asawlk   EBALL-37, Modified Check_Value_Method_Change___() by adding two new  error messages QTYEXCHANGE and WAEXCHANGE. Also modified
--  130529           Company_Owned_Stock_Exists___() to use Invent_Part_Quantity_Util_API.Check_Quantity_Exist().
--  130528  PraWlk   Bug 90095, Modified Unpack_Check_Update___() to make the attribute abc_class updatable.
--  130515  IsSalk   Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130409  UTSWLK   Bug 108665, Modified method Update___ to send value of oldrec_.type_code when calling Manuf_Structure_Util_API.Handle_Type_Code_Change.
--  130402  GayDLK   Bug 109025, Moved the logic to modify the avail_activity_status of a part, from Unpack_Check_Update___() to Update___().
--  130322  Asawlk   EBALL-37, Modified Get_Our_Qty_At_Customer___() and Company_Owned_Stock_Exists___() in order to make the call to
--  130322           Inventory_Part_At_Customer_API.Get_Our_Total_Qty_At_Customer() static. Also removed the constant inst_InventoryPartAtCustomer_.
--  130214  VISALK   Bug 108032, Added new function Transf_Invent_Part_To_Eng_Rev() for object connection LU transformation, from InventoryPart to EngPartRevision.
--  130220  Matkse   Added method Get_Hazard_Code().
--  120827  DaZase   Added method Create_Data_Capture_Lov.
--  120816  RiLase   Added method Get_Media_Id().
--  120629  ChFolk   Modified View to increased the length of customs_stat_no to VARCHAR2(15).
--  120608  MaEelk   Replaced the usage of Company_Distribution_Info_API with Company_Invent_Info_API.
--  120927  NiDalk   Bug 104034, Modified Prepare_Insert___() to add value for default status from Inventory_Part_Status_Par.API.Get_Default_Status()
--  120927           instead of adding 'A'. 
--  120921  Cpeilk   Bug 102401, Added another description field to inventory_part view with alias name DESCRIPTION_COPY. This was added
--  120921           so that binded field in inventory part window can be shown in query dialog from IEE.
--  120904  JeLise   Changed from calling storage related Part_Catalog_API methods to call the same methods in Part_Catalog_Invent_Attrib_API.
--  120816  SeJalk   Bug 104501, Redesigned the functions Get_Stop_Analysis_Date, Get_Ultd_Manuf_Supply_Date__, Get_Ultd_Purch_Supply_Date__ and
--  120816           added new method Get_Stop_Analysis_Date___ to make purchase and expected lead times to be same.
--  120710  Asawlk   Bug 102950, Modified Check_Delete___() to check whether there are connections with Case or Solution upon deletion of a part.
--  120629  ChFolk   Modified View to increased the length of customs_stat_no to VARCHAR2(15).
--  120608  MaEelk   Replaced the usage of Company_Distribution_Info_API with Company_Invent_Info_API.
--  120426  AndDse   PCM-108, Introduced revisions in eco-footprint, therefore a change was needed in Insert___.
--  120322  MoIflk   Bug 99430, Modified Unpack_Check_Update___ by changing the error message NOSALESPART to include 'Invert Conversion factor' words.
--  120315  MaEelk   Removed the last parameter TRUE in call General_SYS.Init_Method from  non-implementation methods
--  120313  LEPESE   Added validations for serial tracking flags in Check_Pallet_Handled___.
--  120312  JeLise   Added check in method Copy to see if the copying of part is within the same site, if not we will not copy putaway zones.
--  120216  LEPESE   Added method Exist_With_Wildcard.
--  120215  Matkse   Corrections on implementation of PUTAWAY_ZONE_REFILL_OPTION
--  120210  Matkse   Added method Get_Putaway_Zone_Refill_Opt_Db
--  120208  Matkse   Added attribute PUTAWAY_ZONE_REFILL_OPTION
--  120131  SBallk   Bug 99546, Added a new procedure Check_Intrastat_And_Customs___(). Used that procedure inside the Unpack_Check_Insert___() 
--  120131           and Unpack_Check_Update___() to validate the customs_stat_no and intrastat_conv_factor.
--  120130  PraWlk   Bug 99404, Removed the attribute superseded_by and modified the code accordingly. Modified Validate_Replaced_Parts___()
--  120130           by changing the name to Check_Supersedes___(), and also changing the signature and content of it.
--  120130  MaEelk   Modified Date Format of create_date and last_activity_date in view comments.
--  120126  NaLrlk   Modified the Unpack_Check_Update___ to change the method calls Part_Input_Unit_Meas_API to Part_Gtin_Unit_Meas_API. 
--  120124  MoIflk   Bug 100743, Modified procedure Update___ allow to updates both customs statistics number 
--  120124           and intrastat conversion factor changes in every connected sales part for given inventory part.
--  120112  Matkse   Moved view INVENTORY_PART_LOV27 to INVENTORY_PART_IN_STOCK
--  120110  Matkse   Added VIEW INVENTORY_PART_LOV27
--  111017  PraWlk   Removed order_date_ variable from Qty_To_Order().
--  111222  Matkse   Modified Modify_Earliest_Ultd_Sply_Date to check planned receipt date for NULL value before calling 
--  111222           Work_Time_Calendar_Api.Get_Nearest_Work_Day
--  111220  LEPESE   Added lead_time_code, purch_leadtime and manuf_leadtime to micro_cache_rec.
--  111220           Modified Get_Stop_Analysis_Date to fetch data from micro_cache.
--  111216  LEPESE   Modified Get_Stop_Analysis_Date to consider earliest_ultd_supply_date for purchased parts.
--  111216           Added logic in Modify_Earliest_Ultd_Sply_Date to make it transform planned_receipt_date
--  111216           from the PO line by adding an extra day and then finding next work day.
--  111216           Added validation for earliest_ultd_supply_date to give error if not work day in dist calendar.
--  111216           Added new parameter earliest_ultd_supply_date_ to method Get_Ultd_Purch_Supply_Date__.
--  111214  Matkse   Added method Modify_Earliest_Ultd_Sply_Date
--  111213  Matkse   Added methods Get_Ultd_Purch_Supply_Date, Get_Ultd_Manuf_Supply_Date, Get_Ultd_Expected_Supply_Date
--  111213           Get_Ultd_Purch_Supply_Date__, Get_Ultd_Manuf_Supply_Date__, Get_Ultd_Expect_Supply_Date__ 
--  111208  Matkse   Modified column comment on EARLIEST_ULTD_SUPPLY_DATE to not insertable.
--  111208           Modified method Get_Earliest_Ultd_Supply_Date to have micro_cache support
--  111207  Matkse   Added attribute earliest_ultd_supply_date
--  111010  DaZase   Made changes in Get_Storage_Volume_Requirement so instead of getting volume uom from company we use the method that is used 
--  111010           in the inventory part client. Also removed the 4 decimal rounding in the convertion since it caused problems.
--  110215  GayDLK   Bug 93972, Added new methods Company_Owned_Stock_Exists___() and Get_Updated_Control_Type___(). Used the above methods
--  110215           in Unpack_Check_Update___() to prevent the user from modifying a control type, if it is used as the control type
--  110215           for a code part, depending on the setting of the new check box frmCompanyDistributionGeneral.cbsStockCtrlTypesBlocked.
--  110829  SurBlk   Bug 97779, Modified Unpack_Check_Insert___() to set default values for the inventory valuation method.   
--  110811  PraWlk   Modified Qty_To_Order() by adding new parameter order_point_qty_. Adjusted the code to avoid getting minus  
--  110811           ordered qty when lot size is smaller than order point qty.
--  110731  Dobese   Changed Chemmate receiver to HSE receiver.
--  110720  MaEelk   Added user allowed site filter to INVENTORY_PART_ALTERNATE.
--  110718  PraWlk   Bug 98061, Modified Unpack_Check_Update___() by removing IF condition to update intrastat conv factor without 
--  110718           considering the customs_stat_no is NULL or not.
--  110711  MaEelk   Added user allowed site filter to INTORDER_PART_ALTERNATE_LOV.
--  110627  PraWlk   Bug 95672, Moved the code which update the replaced part to complete the connection from Unpack_Check_Update___()
--  110627           to Update___() and from Unpack_Check_Insert___() to Insert___().
--  110610  MAJOSE   Bug 97433, Added parameter exclude_reserved_ when calling Order_Supply_Demand_API.Get_Total_Demand in
--                   Handle_Part_Status_Change___.
--  110601  MuShlk   EASTONE-21592. Merged LCS Patch 96447.
--                   110331  NALWLK   Bug 96447, Added new function Customs_Stat_No_With_Uom_Exist().
--  110520  AndDse   EASTONE-18789, Merged LCS bug 93415, Modified Get_Mrp_Part_Cur cursor to remove an AND condition.
--  110512  JeLise   Changed from calling Get_Uom_For_Lenght to calling Get_Uom_For_Volume in 
--  110512           Get_Storage_Volume_Requirement to compare the correct uom's.
--  110505  JeLise   Changed the checks on lot_tracking_code_db_ in Check_Value_Method_Combinat___,
--  110505           to handle all variants of lot tracking.
--  110503  LEPESE   Changed data source of cursor get_oldrec in method Copy_Impl___ from VIEW to TABLE. Since this
--  110503           will make the cursor select db-values for IID columns then the parameter list to New_Part must
--  110503           include Decode statements. Also method Overwrite_Record_With_Attr___ must be changed to Encode
--  110503           the client values for IID columns that are passed in the attribute string. 
--  110503  ChJalk   Reversed the change done to use the base view in Copy_Impl___.
--  110503  ChJalk   Modified Copy_Impl___ to change the usage of base view in the cursor to the table.
--  110406  MiKulk   Modified the Micro_Cache_Rec definition by correctly positioning the note_id.
--  110315  DaZase   Added call to Invent_Part_Pallet_Refill_API.Remove in Update___.
--  110314  DaZase   Added new methods Pallet_Handled and Pallet_Handled_Num.
--  110125  JoAnSe   Added receipt_issue_serial_track_db to INVENTORY_PART_LOV
--  110302  DaZase   Added Check_Pallet_Part_Exist and Check_Pallet_Handled___.
--  110301  ChJalk   Moved 'User Allowed Site' Default Where condition from client to base view.
--  110301  DaZase   Added attribute pallet_handled.
--  110222  JeLise   Added call to Invent_Part_Putaway_Zone_API.Copy in Copy.
--  110210  DaZase   Added checks in Check_Qty_Calc_Rounding___/Unpack_Check_Insert___ to make sure qty_calc_rounding is zero for discrete unit_meas. 
--  110111  JeLise   Added attribute standard_putaway_qty.
--  110104  DaZase   Added methods Get_Storage_Volume_Req_Oper_Cl and Get_Storage_Volume_Req_Client.
--  101105  DaZase   Changed Get_Storage_Volume_Requirement so it can handle different uoms and recalculate volume using that.
--  101103  ShKolk   Removed GTIN_NO and GTIN_SERIES.
--  101029  LEPESE   Added parameter receipt_issue_serial_track_db_ to methods Check_Value_Method_Combinat___ and
--  101029           Check_Value_Method_Combination. Added logic in Check_Value_Method_Combinat___ to make sure that it will not be
--  101029           possible to use 'COST PER LOT BATCH' on a part that is lot tracked if it at the same time is serial tracked
--  101029           at receipt and issue but not in inventory. We need to have the serial tracking also in inventory to make this
--  101029           work since the serial numbers will also be stored in InventoryPartUnitCost when running 'COST PER LOT BATCH'.
--  101027  LEPESE   Removed method Check_Serial_Conv_Factor. Added method Unit_Meas_Different_On_Sites.
--  101027           Replaced logic base on serial_tracking_code with logic based on receipt_issue_serial_track
--  101027           in methods Unpack_Check_Insert___, Check_Qty_Calc_Rounding___ and Check_Unit_Meas___.
--  101022  JeLise   Added storage_width_requirement, storage_height_requirement, storage_depth_requirement, 
--  101022           storage_volume_requirement, storage_weight_requirement, min_storage_temperature, max_storage_temperature, 
--  101022           min_storage_humidity and max_storage_humidity as parameters in New_Part.
--  110120  Cpeilk   Bug 95250, Modified Unpack_Check_Insert___ to give an INFO message and Unpack_Check_Update___ to give a 
--  110120           warning message when the Online Consumption check box is checked.
--  101020  Asawlk   Bug 93454, Modified Copy_Impl___() to pass oldrec_.qty_calc_rounding when calling New_Part().
--  100917  DAYJLK   Bug 89720, Modified record type Micro_Cache_Rec, function Get_Note_Id and procedure Update_Cache___ 
--  100917           to use micro cache functionality for attribute note_id.
--  100922  JeLise   Added Check_Temperature_Range and Check_Humidity_Range.
--  100915  NaLrlk   Modified the method Unpack_Check_Update___ to raise information messsage when changing the input unit meas group.
--  100830  JeLise   Added Get_Xxx_Source methods.
--  100817  JeLise   Adding columns storage_width_requirement, storage_height_requirement, storage_depth_requirement, 
--  100817           storage_volume_requirement, storage_weight_requirement, min_storage_temperature, max_storage_temperature, 
--  100817           min_storage_humidity and max_storage_humidity.
--  100707  MaRalk   Added new view INVENTORY_PART_LOV26 in order to display parts with
--  100707           TYPE code 1 or 4 and that are not position parts.
--  100702  GayDLK   Bug 90385, Removed part_status handling logic from Unpack_Check_Update___() method and placed it in new method
--  100702           Handle_Part_Status_Change___() and called the new method from Update___() method. Also removed info message QTYEXCEEDSDEMAND 
--  100702           and implemented method Handle_Part_Status_Change___() in a way to proceed irrespective to the supply flag of old part status. 
--  100629  ShKolk   Added column min_durab_days_planning.
--  100618  Asawlk   Bug 91327, Added new parameter qty_calc_rounding_ to New_Part() method and handled it inside the method.
--  100611  Asawlk   Bug 90095, Modified Unpack_Check_Update___() to make attribute abc_class updatable.
--  100609  CwIclk   Bug 90569, Removed attributes type_code and lead_time_code from cursor Get_Mrp_Part_Cur and modified the same cursor
--  100609           to read from table INVENTORY_PART_TAB instead of view INVENTORY_PART.
--  100519  MaMalk   Modified the reference for COUNTRY_OF_ORIGIN from ApplicationCountry to IsoCountry.
--  100511  KRPELK   Merge Rose Method Documentation.
--  100423  MaRalk   Replaced method call Inventory_Part_Stock_Owner_API.Check_Consignment_Exist with
--  100423           Inventory_Part_In_Stock_API.Check_Consignment_Exist in Check_Value_Method_Change___ method. 
--  100423  PraWlk   Bug 88817, Added new overloaded method Cascade_Trans_Cost_Update() and modified existing
--  100423           Cascade_Trans_Cost_Update() to call new method Cascade_Trans_Cost_Update().
--  100311  HaPulk   Bug 84970, Added assert_safe tag for ExecuteImmediate
--  100212  Asawlk   Bug 88330, Modified Update___() to place the call to Invalidate_Cache___ right after the UPDATE clause.
--  100118  MaMalk   Replaced inst_PartRevisionInt_ with inst_PartRevision_.  
--  100113  MaMalk   Replaced calls to Part_Revision_Int_API with Part_Revision_API.
--  100111  MaEelk   Replaced the Shop_Order_Operation_Int_API.Check_Create_Inventory_Part with 
--  100111           Shop_Order_Operation_List_API.Check_Create_Inventory_Part.
--  100108  KiSalk   Replaced Shop_Order_Prop_Int_API calls with other APIs.
--  100106  ChFolk   Redirect method calls from obsolete package Shop_Order_Int_API.
--  091030  ShKolk   Bug 86768, Merge IPR to APP75 core.
--  091001  LaNilk   Bug 85192, Added supply_flag_db to the Get_Mrp_Part_Cur cursor and modified the where clause.  
--  090928  ChFolk   Removed parameter part_no_ from Check_Expense_Part_Allowed___. Removed unused variables in the package.
--  ---------------------------------------- 14.0.0 ----------------------------
--  100312  NaLrlk   Added derived column auto_created_gtin and used it in server call Part_Catalog_API.Update_Gtin.
--  100222  NaLrlk   Modified the method Get_Weight_Net to optimize performance.
--  091030  ShKolk   Bug 86768, Merge IPR to APP75 core.
--  091001  LaNilk   Bug 85192, Added supply_flag_db to the Get_Mrp_Part_Cur cursor and modified the where clause.  
--  090714  AmPalk   Bug 83121, Made gtin a varcahr2. Changed file accordingly.
--  090623  IrRalk   Bug 82835, Modified Get_Weight_Net,Get_Volume_Net methods to round the weight and volume to 4 and 6 
--  090623           decimals respectively. 
--  090818  ShKolk   Renamed column min_durab_days_co_reserv to min_durab_days_co_deliv.
--  090817  ShKolk   Changed NUMBER(4) to NUMBER in view comments of min_durab_days_co_reserv. 
--  090817           Modified method Check_Min_Durab_Days_Co_Res___ added error message MINDURABNULL.
--  090817           Added column min_durab_days_co_reserv to method Overwrite_Record_With_Attr___
--  090812  ShKolk   Added column min_durab_days_co_reserv.
--  090603  PraWlk   Bug 82280, Modified Check_Value_Method_Combinat___ to enable inventory part cost
--  090603           level 'Cost per Serial' for configured serial parts.  
--  090519  HoInlk   Bug 82673, Modified Unpack_Check_Insert___ to use default qty calc round value for site.
--  090518  AndDse   Bug 80049, In function Insert___, added so that new InvPartEmissionHead object is created if ecoman is installed.
--  090515  PraWlk   Bug 81859, Added new views INVENTORY_PART_LOV24 and INVENTORY_PART_LOV25.
--  090511  PraWlk   Bug 81853, Modified PROCEDURE Copy_Impl___ to validate planner_buyer.
--  090319  PraWlk   Bug 77435, Modified Prepare_Insert___ and Unpack_Check_Insert___to set default 
--  090319         value for PLANNER_BUYER. 
--  090227  CsAmlk   Bug 79654, Modified Handle_Description_Change___ to handle part description modifications inside CBS. 
--  090220  ErSrlk   Bug 80663, Added new function Cascade_Update_On_SO_Close_Str(). 
--  090202  DAYJLK   Bug 79188, Modified Get_Calc_Rounded_Qty___ to round decimals outside the measurable range 
--  090202           of variable adjusted_qty_ before rounding it further.
--  090115  PraWlk   Bug 79568, Modified  Unpack_Check_Update___ to raise an error when Note Id is tried to modify.
--  081210  MoNilk   Bug 78663, Modified Insert___ to handle purchase dynamic call conditionally.          
--  081104  PraWlk   Bug 78165, Modified Get_Stop_Analysis_Date by substracting 1 from
--  081104           Database_Sys.last_calendar_date_.
--  080917  SuSalk   Bug 73322, Added Check_Expense_Part_Allowed___ and Check_Disallow_As_Not_Consumed methods.
--  080917           Modified Unpack_Check_Insert___ and Unpack_Check_Update___ methods to validate expense parts. 
--  080822  MaEelk   Bug 76391, Modified Insert___ to set the Inventory flag of the puchase part 
--  080819           when the puchase part has been created before the inventory part.
--  080818           Restructured the dynamic calls that used to fetched the technical coordinator id.   
--  080813  ThImLk   Bug 72355, Added a new method, Modify_Type_Code.
--  090708  HimRlk   Bug 83459, Modified the IF condition in method Modify__ to consider whether the GTIN_NO has been changed.
--  ----------------------------- MF022 Paint & Inc Extension End ----------
--  090611  KiSalk   Removed obsolete attributes from Pack_And_Post_Message__.
--  090522  JoAnSe   Changes methods for manufacturing interface in Pack_And_Post_Message__
--  ----------------------------- MF022 Paint & Inc Extension Begin ---------
--  081201  MaJalk   Modified Unpack_Check_Insert___ to set the GTIN, only when GTIN is active.
--  080908  KiSalk   Added function Get_Volume_Net.
--  080825  AmPalk   Changed Get_Weight_Net to consider 1 qty UoM between partcat and invent part.
--  080729  AmPalk   Removed attribute Weight_Net and used the Part Catalog to fetch the net weight and UoM of it.
--  080705  AmPalk   Merged APP75 SP2.
--  ---------------------------- APP75 SP2 End -------------------------------
--  080418  Prawlk   Bug 58090, Added view comments for missed db columns,inventory_valuation_method_db,negative_on_hand_db,
--  080418           invoice_consideration_db and ext_service_cost_method_db.
--  080320  ErSrLK   Bug 72132, Added method Cascade_Trans_Cost_Update to check if an inventory part is using Actual Cost.
--  080314  NiBalk   Bug 72262, Modified the where clause of views, INVENTORY_PART_WO_LOV and INVENTORY_PART_LOV_MRP.
--  080228  HoInlk   Bug 69938, Modified methods Unpack_Check_Update___ and Modify__ to display
--  080228           error FPURCHZEROLT only if updated by client.
--  ---------------------------- APP75 SP2 Start -------------------------------
--  080527  AmPalk   Renamed Update_Gtin_In_All to Update_Gtin_In_All_Sites. Update_Gtin_In_All_Sites method calls moved in to the Part_Catalog_API.Update_Gtin.
--  080526  KiSalk   Removed ean_no.
--  080425  AmPalk   Set GTIN Nullable.
--  080423  KiSalk   Added attribute gtin_series and method Get_Gtin_Series. Added parameter gtin_series to Update_Gtin_In_All.
--  080418  AmPalk   Modified Modify__ to handle GTIN update.
--  080417  AmPalk   Added Update_Gtin_In_All. Modified Insert___ to update GTIN in part cat and sales parts if the GTIN entered at the Invent Part level.
--  080416  AmPalk   Only active gtin nos will be saved on inventory part.
--  080414  AmPalk   Added gtin_no.
--  080123  NiBalk   Bug 70681, Removed an unwanted validation and error message from Unpack_Check_Update___ and Check_Unit_Meas___,
--  080123           to make it possible to enter catch UoM even if the "Catch UoM Enabled" parameter is disabled in Part Catalog.
-- -----------------------------------AP75SPETT Merge End-----------------------
--  080114  LaRelk   Bug 69046, Changed  Function Document_Connected according to cording standards.
--  080111  CsAmlk   Bug 69046, Merge AP75SPETT.
--  080104  CsAmlk   DM003: Added Function Document_Connected.
-- -----------------------------------AP75SPETT Merge Start---------------------
--  071210  NuVelk   Bug 69863, Added column dim_quality to view INVENTORY_PART_LOV_MRP.
--  071122  KaDilk   Bug 68240, Added procedure Check_Lead_Time___. Validate lead times when inserting and updating.
--  071115  IsAnlk   Bug 69010, Restructured the procedure Modify_Purch_Leadtime to use normal base methods Unpack_Check_Update___
--                   and Update___. Modified conditions to call Manuf_Part_Attribute_API.Get_Sched_Capacity in Unpack_Check_Update___.
--  071030  KeFelk   Bug 68753, Added text_id$ to the necessary views.
--  070917  RoJalk   Added method Get_All_Notes.
--  070808  SuSalk   LCS Merge Bug 66010, Modified the method Modify_Expected_Leadtime.
--  070808           In Modify_Manuf_Leadtime. removed the addition of expected_leadtime to the attribure string.
--  070709  RoJalk   Bug 65378, Added method Modify_Qty_Calc_Rounding. Modified methods
--  070709           Check_Qty_Calc_Rounding___, Unpack_Check_Insert___ and Unpack_Check_Update___ to
--  070709           disallow non zero values for qty_calc_rounding when part is serial tracked.
--  070727  MiKulk   Changed planned_due_date_ to IN OUT parameter in the call to method Distribution_Order_API.Create_Distribution_Order.
--  070621  NiDalk   Bug 65739, Modified the methods Set_Avail_Activity_Status and Clear_Avail_Activity_Status
--  070621           to avoid unneccesary locking of records.
--  070604  AmPalk   Bug 64681, [ No need this part --> Added new parameter action_ as default value 'ADD', to the method Get_Calc_Rounded_Qty.]
--  070604           Modified method Get_Calc_Rounded_Qty___ in order to deal with action_ = 'ROUND'.
--  070512  Cpeilk   Added a check to stop catch UoM entering for catch unit disabled parts.
--  070507  AmPalk   Bug 64834, Modification in method Copy_Impl___ to copy part_cost_group_id to new part if both contracts are same.
--  070507           Added parameter part_cost_group_id_ to method New_Part and attached value to attr_.
--  070425  Haunlk   Checked and added assert_safe comments where necessary.
--  070319  ChBalk   Added condition to check stage payments in purchase order lines. Added call to Purchase_Order_Milestone_API.Check_Approved_Stage_Payments.
--  070314  SuRalk   Bug 63689, Added in parameter newrec_.inventory_valuation_method in call to
--  070314           Inventory_Part_Config_API.Check_Zero_Cost_Flag.
--  070313  MaMalk   Bug 63943, Added missed UNDEFINE for LOV_VIEW22 and LOV_VIEW23.
--  070301  MoMalk   Bug 63118, Added new views INTORDER_PART_LOV3 and INTORDER_PART_LOV4.
--  070207  DaZase   Added parameter catch_unit_meas to New_Part. Also added catch_unit_meas to Copy_Impl___.
--  070206  NiDalk   Added parameter create_part_planning_ to PROCEDURE New_Part.
--  061228  DaZase   Added method Check_Enable_Catch_Unit. Also added calls to Sales_Part_API.Check_Enable_Catch_Unit in
--                   Check_Unit_Meas___ and Unpack_Check_Update___.
--  061212  DaZase   Added some changes for catch unit meas in method Get_Default_Site_And_Uom___.
--  061123  ShVese   Minor code changes conforming to the model changes.
--  061117  Dobese   Changed to compare base unit instead in check_partcat_unit_code_change
--  061116  ShVese   Added mandatory check for Catch UoM when catch unit is enabled.
--  061110  DaZase   Added unit_category_ as an inparam to methods Get_Site_Converted_Qty, Get_User_Default_Converted_Qty,
--                   Get_User_Default_Unit_Meas, Get_User_Default_Site and Get_Default_Site_And_Uom___.
--  061102  ShVese   Added column catch_unit_meas and the related code. Added method Get_Enabled_Catch_Unit_Meas,
--                   Check_Serial_Conv_Factor,Check_Unit_Meas___.
--                   Removed the check that PartCatalog UoM should be equal to Inv UoM if input_unit_meas_group_id is specified.
--  061011  DaZase   Added methods Get_Site_Converted_Qty (overloaded 3 times), Get_User_Default_Converted_Qty,
--                   Get_User_Default_Unit_Meas, Get_User_Default_Site, Get_Default_Site_And_Uom___.
--  060913  RoJalk   Minor modifications to the Handle_Partca_Desc_Flag_Change.
--  060904  RoJalk   Added methods Handle_Partca_Desc_Change, Handle_Partca_Desc_Flag_Change,
--  060904           Handle_Description_Change___. Modified Update___ to handle description change.
--  060821  ErFelk   Bug 59786, Modified INVENTORY_PART_LOV view by changing the last flag of contract in view commnets.
--  060818  KaDilk   Reversed the public cursor changes by removing Point_Parts method.
--  060817  RoJalk   Made the DESCRIPTION column not null in INVENTORY_PART_TAB.
--  060810  ChJalk   Modified hard_coded dates to be able to use any calendar.
--  060803  RoJalk   Removed description field from public rec and INVENTORY_PART_PUB.
--  060802  ChBalk   Modified Point_Parts method cursor since it was selecting client value of lead_time_code from INVENTORY_PART_PUB
--  060725  RoJalk   Modified the method Get_Description to fetch the description from
--  060725           part_catalog_tab depending on the flag set.Modified the views to fetch
--  060725           the description using Get_Description.
--  060714  Kadilk   Removed public cursor Get_Mrp_Part_Cur.Added function Point_Parts.
--  060714           Declared the types Reorder_Point_Parts_Rec and reorder_point_parts_tab.
--  060629  DaZase   Made attribute qty_calc_rounding public.
--  060619  DaZase   Added action_ as default parameter to Get_Calc_Rounded_Qty. Added method Get_Qty_Calc_Rounding.
--  060608  MarSlk   Bug 58437, Created dummy view Purchase_part_lov6. Modified Inventroy_part_lov
--  060608           and added union to join columns of Purchase_part_lov6.
--  060601  RoJalk   Enlarge Part Description - Changed view comments.
--  060531  MuShlk   Bug 57088, Reversed the previous changes done for this bug. Recalculated qty_to_buy_ and qty_to_make_.
--  060529  SuSalk   Bug 58090, Added view comments for missed db columns,inventory_valuation_method_db,negative_on_hand_db,
--  060529           invoice_consideration_db,ext_service_cost_method_db and added ip.accounting_group to the Get method.
--  060524  WiJalk   Bug 34067, Added procedure Check_Partcat_Unit_Code_Change to validate when
--  060524           changing Unit Code in part catalog.
--  060522  MarSlk   Bug 56887, Modified the error message in method Check_Value_Method_Change___ when validating the
--  060522           inventory valuation method and the inventory part cost level.
--  060518  MuShlk   Bug 57088, Replaced the occurrences of Inventory_Part_Planning_API.Get_Scrap_Added_Qty() with Inventory_Part_API.Get_Calc_Rounded_Qty().
--  060505  MarSlk   Bug 56887, Added Get_Our_Qty_At_Customer___ method to check if the consignment stock qty
--  060505           & delivery qty has value. Modified Check_Value_Method_Change___ and raised error messages according to the new validations.
--  060420  IsAnlk   Enlarge supplier - Changed variable definitions.
--  -----------------------------13.4.0-----------------------------------------
--  060327  SaJjlk   Added column LOT_QUANTITY_RULE to view INVENTORY_PART_LOV.
--  060320  SaJjlk   Added call to Inventory_Part_Planning_API.Modify_Manuf_Acq_Percent from Unpack_Check_Update___.
--  060315  SaJjlk   Added more columns to view INVENTORY_PART_LOV.
--  060313  ISWILK   Modified the DB value from 'RECEIVE INTO INVENTORY' to
--  060313           RECEIPT INTO INVENTORY in PROCEDURE Check_Invoice_Consideration___.
--  060302  LEPESE   Added view INVENTORY_PART_SO_CASCADE_LOV.
--  060223  JaBalk   Added : to P3 in TRBAFILI message.
--  060222  CHASLK   Created new view INTORDER_POSITION_PART_LOV
--  060217  LEPESE   Added call to Inventory_Part_Config_API.Modify_Standard_Cost__() from
--  060217           method New__.
--  060208  JaJalk   Added two parameters negative_on_hand and inventory_valuation_method to the New_Part method.
--  060206  RaKalk   Modified the method Unpack_Chack_Insert___ and Check_Value_Method_Change___ to give a information message
--  060206           when the inventory valuation method is FIFO/LIFO and the part is condition code enabled.
--  060131  JoAnSe   Corrected validations in Check_Value_Method_Change___.
--  060127  MAJOse   Introduced Make/Buy Split in Qty_To_Order (Order Proposal Calculation).
--  060123  NiDalk   Added Assert safe annotation.
--  060123  RaKalk   Added detect_supplies_not_allowed_ paraneter to Get_Stop_Analysis_Date method
--  060123           The method will return an unrealistic date when detect_supplies_not_allowed_ true when the supply is not allowed
--  060117  LEPESE   Added call to Inventory_Part_Unit_Cost_API.Handle_Valuation_Method_Change in
--  060117           method Update___.
--  060112  JOHESE   Added check if Distribution Order is installe in Qty_To_Order
--  060110  JOHESE   Renamed parameter use_expected_tead_time to use_expected_leadtime_ in Get_Stop_Analysis_Date
--  060103  JOHESE   Removed exception handling in Qty_To_Order
--  060102  RaKalk   Added view INVENTORY_PART_CC_LOV to be used by Call Center module
--  051229  JOHESE   Added possibility to create distribution order in Qty_To_Order
--  051229  JoAnSe   Added new methods Cascade_Update_On_SO_Close___ and
--  051229           Check_Value_Method_Change___. Moved validations from
--  051229           Unpack_Check_Update___ to Check_Value_Method_Change___ and added
--  051229           some additional checks replacing call to Shop_Order_Int_API.Check_Valuation_Method_Change
--  051228  ISWILK   (LCS 54614)Modified the PROCEDURE Unpack_Check_Update___ to replace
--  051228           the dynamic call to Customer_Order_API.Check_Forecast_Consumpt_Change.
--  051228           And modified Global LU constants by removing inst_OrderQuotationLine_,
--  051228           inst_Level1Forecast_, inst_SparePartForecast_ and adding inst_CustomerOrder_.
--  051219  LEPESE   Removed validation for specific cost level in combination with
--  051219           TRANSACTION BASED invoice consideration for Weighted Average in
--  051219           method Check_Value_Method_Combinat___.
--  051201  JoAnSe   Added Cascade_Update_On_SO_Close
--  051121  HoInlk   Bug 54431, Added column qty_calc_rounding and added new methods
--  051121           Get_Calc_Rounded_Qty, Check_Qty_Calc_Rounding___ and Get_Calc_Rounded_Qty___.
--  051116  LEPESE   Removed Error when selecting Weighted Average for Manufactured parts.
--  051110  GeKalk   Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to
--  051110           fetch the co_reserve_onh_analys_flag from the asset_class.
--  051101  GeKalk   Added CO_RESERVE_ONH_ANALYS_FLAG attribute to the inventory_part_tab.
--  051013  JoAnSe   Added Get_Accounting_Group
--  051003  KeFelk   Added Site_Invent_Info_API in relavant places where Site_API is used.
--  051003  KeFelk   Replaced some method calls to Site LU with SiteInventInfo.
--  050927  LEPESE   Merged DMC changes below.
--  050922  ThGulk   Bug 52942, Modified column size of purch_leadtime, manuf_leadtime,expected_leadtime
--  ***************** DMC Merge Begin ******************
--  050817  LEPESE   Removed obsolete method Modify_Inventory_Value.
--  050816  LEPESE   Changes in method Check_Value_Method_Combinat___ to allow inventory
--  050816           valuation method Weighted Average in combination with inventory part
--  050816           cost level COST PER LOT BATCH.
--  ***************** DMC Merge End ******************
--  050920  NiDalk   Removed unused variables.
--  050916  SaNalk   Modified view LOV_VIEW20. Replaced SUBSTRB with SUBSTR.
--  050906  ShKolk   Modified view INVENTORY_PART_ALTERNATE_LOV2 replaced SUBSTRB with SUBSTR.
--  050902  NuFilk   Modified method Insert___ to correct the creation of configured part details using the dynamic call.
--  050823  IsAnlk   Included NULL parameter to Inventory_Part_In_Transit_API.Get_Total_Qty_In_Order_Transit method call.
--  050815  RaSilk   Rearranged SELECT varialbes in method Get.
--  050628  HaPulk   Fixed invalid usage of General_SYS.Init_Method.
--  050621  DaZase   Changes in unpack methods so automatic_capability_check gets default value from asset_class now.
--  050519  Asawlk   Bug 50392, Added function Get_Objid__.
--  050429  KeFelk   Changed parameters to the method call Approval_Routing_API.Copy_App_Route().
--  050411  ShKolk   Added the view INVENTORY_PART_ALTERNATE_LOV2.
--  050411  SeJalk   Bug 47761, Changed Region_Of_Origin_API to Country_Region_API in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  050331  RaSilk   Modified unpack_check_insert___ to fetch default value to dop_netting.
--  050329  JOHESE   Replaced call to Customer_Consignment_Stock_API.Get_Sum_Consignment_Stock_Qty
--                   with Inventory_Part_At_Customer_Api.Get_Our_Total_Qty_At_Customer calls to include
--                   parts in consignment as well as parts awaiting delivery confirmation
--  050323  JoEd     Added update check on part cost level "COST PER PART" and delivery confirmation.
--  050321  RaSilk   Added attribute dop_netting.
--  050301  KeFelk   Small changes to previous change.
--  050224  KeFelk   Added default parameter create_purchase_part to Copy,Copy_Impl___,New_Part and Insert___.
--  050222  RuRalk   Bug 49476, Added a new method call to Shop_Order_Int_API.Check_Valuation_Method_Change
--  050222           inside Unpack_Check_Update to check whether any active shop Orders exist for an
--  050222           inventory part when changing the inventory_valuation_Method to "Weighted Average".
--  050214  KeFelk   Added AUTOMATIC_CAPABILITY_CHECK to New_Part().
--  050210  HoInlk   Bug 49546, Modified Unpack_Check_Insert___ to check if the part
--  050210           has been used as an outside operation item.
--  050209  KeFelk   Changes to Copy_Characteristics().
--  050209           Introduced err msg IPNOTEXIST, change the logic to reduced database reads,
--  050209           and moved all the contents of Copy() in InventoryPartChar to this method.
--  050207  DaZase   Added automatic_capability_check. Added method Check_Auto_Capability_Check___.
--  050203  LEPESE   Added procedures Check_Ownership_Transfer_Point and
--                   Check_Invoice_Consideration___. Added calls to method
--                   Check_Invoice_Consideration___ from unpack_check_insert___ and
--                   unpack_check_update___. Added new validation between invoice_consideration
--                   and ownership_transfer_point on company in Check_Invoice_Consideration___.
--  050202  KeFelk   Added Copy_Characteristics, removed Modify_Eng_Attribute and
--  050202           pass NULL as parameter value for eng_attribute when calling New_Part.
--  050131  KaDilk   Bug 49189, Added new view LOV_VIEW20.
--  050128  Asawlk   Bug 49005, Modified Prepare_Insert___ inorder to stop fetching parameters based on asset class.
--  050127  KanGlk   Added new procedure Modify_Eng_Attribute.
--  050121  JOHESE   Modified Get_Stop_Analysis_Date
--  050120  IsWilk   Modified the PROCEDURE Copy_Connected_Objects to call the copy methods from Doc_Reference_Object_API,
--  050120           Approval_Routing_API, Technical_Object_Reference_API.
--  050117  SeJalk   Bug 48580, Modified view comments for part no in view INTORDER_PART_ALTERNATE_LOV.
--  041231  SaRalk   Changed Doc_Reference_Object_API.Copy_Connected_Objects method call in Copy_Connected_Objects to a dynamic call.
--  041220  ErSolk   Bug 48120, modifications in method Update___. Cleanup of code
--  041220           that handles modifications of lead_time_code and type_code.
--  041220           Added calls to Manuf_Structure_Util_API.Handle_Type_Code_Change
--  041220           and Purchase_Part_API.Handle_Lead_Time_Code_Change.
--  041216  JaBalk   Removed default TRUE parameters from Copy_Impl___,Copy_Connected_Objects,
--  041216           and Copy_Note_Texts. Added Overwrite_Record_With_Attr___ to replace the oldrec with attr.
--  041215  SaRalk   Modified procedure Copy.
--  041214  JaBalk   if original record exists only, call the copy method of
--  041214           InventoryPartPlanning in Copy() method.
--  041214  SaRalk   Added missing view comments for db values and modified procedure Copy.
--  041213  SaRalk   Added new methods Copy_Connected_Objects and Copy_Note_Texts.
--  041211  JaBalk   Added default TRUE parameter to Copy(), Copy_Impl___() and default null paramteres to New_Part().
--  041211           modified New_Part() by adding some missing columns when do copy part.
--  041209  NuFilk   Call Id 120536, Modified Unpack_Check_Update___.
--  041105  GeKalk   Modified Unpack_Check_Insert___ to set negative_onhand value to 'NEG ONHAND NOT OK' for catch unit handled parts.
--  041101  GeKalk   Modified Unpack_Check_Insert___ to set negative_onhand for catch unit handled parts.
--  041025  ErSolk   Bug 46932, Modified procedure Update___ to refresh description
--  041025           of connected objects in Document info.
--  041012  KiSalk   Made method Recalc_Stockfactors_Impl___ (renamed as Recalc_Stockfactors_Impl__) as private .
--  040915  RaKalk   Added new implementation method Check_Negative_On_Hand___.
--  040913  RaKalk   Improving Code in Unpack_Check_Update___ and Unpack_Check_Insert___.
--  040910  SaJjlk   Added method Check_Neg_Onhand_Part_Exist.
--  040909  RaKalk   Added New Validation to Unpack_Check_Update___ and Unpack_Check_Insert___
--  040909           To dissabe the Negative Onhand Allowed when catch unit is enabled.
--  040903  HaPulk   Removed General_SYS from FUNCTION Check_If_Alternate_Part and added PRAGMA References.
--  040903  DAYJLK   Call ID 115982, Modified Unpack_Check_Update___ by adding checks to prevent zero value for purchase leadtime
--  040903           when scheduling capacity is finite for Purchased (raw), Purchased, and Expense type Inventory parts.
--  040824  LaBolk   Added method Check_Exist_On_User_Site.
--  040816  KaDilk   Bug 46051, Removed and restructured the code when setting the flags from assest class in procedure Unpack_Check_Insert___.
--  040811  WaJalk   Modified Unpack_Check_Update___ to check for Manuf/Acquired Split for purchased(raw) parts.
--  040715  HeWelk   Modified Unpack_Check_Update___ - Check the Input UoM Group against the Purchase Parts
--  040714  HeWelk   Modified Unpack_Check_Update___ - Check the Input UoM Group against the Sales Parts.
--  040713  HeWelk   Modified Unpack_Check_Update___ - Check whether the Inventory UM is equal to unit code of input UoM Group.
--  040713  HeWelk   Modified Unpack_Check_Insert___ - Check the Input UoM Group against Input UoM and Partca.
--  040713  HeWelk   Added column input_unit_meas_group_id to view inventory_part.
--  040707  KaDilk   Bug 45057, Modified the procedure Recalc_Stockfactors_Impl___.
--  040625  ErSolk   Bug 45604, Modified procedures Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040614  MaGulk   Modified Unpack_Check_Update___ to consider qty_in_transit when changing flags
--  040609  KeFelk   Modified Condition in err msg PRTTYPCANTSET.
--  040604  WaJalk   Modified Check_Delete___ to check for demand site inventory part.
--  040531  KaDilk   Bug 44464, Added global constant inst_ShopOrderInt_ and modified the procedure Unpack_Check_Update___.
--  040521  LoPrlk   Added an error message PRTTYPCANTSET to Unpack_Check_Update___.
--  040520  HeWelk   Modifications(Leadtime to Lead Time) according to 'Date & Lead Time Realignment'
--  040517  IsAnlk   Modified Unpack_Check_Insert___ and Prepare_Insert___.
--  040513  IsWilk   Modified the PROCEDUREs Insert___ and Delete___ to call the QUAMAN methods.
--  040427  IsAnlk   B114412 , Changed Unpack_Check_Insert___ to avoid error message
--                   when creating the Serial Handled Invent Part.
--  040427  ChFolk   Bug 40649, Removed functions Get_Manufacturer_Id and Get_Manufacturer_Part_Id.
--  **********************  Touchdown Merge Begin  *****************************
--  040312  LEPESE   Changes in Unpack_Check_Insert___ to avoid a situation when creation of
--                   a manufactured part is stopped because of default settings on the site.
--                   The combination of WA and Transaction Based on the site must be transformed
--                   to ST and Ignore Invoice Price for manufactured parts (lead time code = 'M').
--  040308  LEPESE   Minor change of validation for Weighted Average and Transaction Based
--                   in method Check_Value_Method_Combinat___.
--  040210  LEPESE   Minor change of validation for Weighted Average and Transaction Based
--                   in method Check_Value_Method_Combinat___.
--  040204  LEPESE   Remove every trace of obsolete attribute actual_cost.
--  040202  LEPESE   Added all validations needed for new attribute invoice_consideration.
--  040128  LEPESE   Removed reference against obsolete IID LU ActualCost. Added reference
--                   to new IID LU InvoiceConsideration which replaces ActualCost.
--  **********************  Touchdown Merge End  *****************************
--  040315  IsWilk   Added the LOV view INVENTORY_PART_QMAN_LOV for Basic Data for Quality Mgmt.
--  040302  JoEd     Restructured methods according to IFS Design.
--  040301  GeKalk   Removed substrb from views for UNICODE modifications.
--  040202  NaWalk   Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  040122  LaBolk   Removed PKG2 and define undefine statements for it. Moved constant new_estimated_material_cost_ to PKG and modified methods that use it.
--  040122           Removed Check_Exist_Anywhere_Impl___ and moved its coding to Check_Exist_Anywhere.
--  040122           Removed Check_If_Counting_Impl___ and moved its coding to Check_If_Counting.
--  040122  LaBolk   Moved method Validate_Lead_Time_Code___ from PKG2 to PKG and corrected the calls to it in Unpack_Check_Insert___ and Unpack_Check_Update___..
--  040122  LaBolk   Moved method Recalc_Stockfactors_Impl___ from PKG2 to PKG and corrected the call to it in Recalc_Stockfactors.
--  040122  LaBolk   Removed method Qty_To_Order_Impl___ from PKG2 and moved its code to Qty_To_Order in PKG.
--  040119  SuAmlk   Bug 41271, Removed obsolete cursor Get_Hpm_Part_Cur.
--  040119  LaBolk   Removed method Count_Sites_Impl___ from PKG2 and moved its code to Count_Sites in PKG.
--  040114  IsAnlk   Changed the code to use local cursor get_all_alternative_part instead of public cursor in Check_If_Alternate_Part.
--  040114  LaBolk   Moved method Copy_Impl___ from PKG2 to PKG. Modified the call to it in Copy.
--  040114  LaBolk   Moved methods Unpack_Check_Insert___, Unpack_Check_Update___, Check_Value_Method_Combinat___ and Check_Open_Eso_Exist___ from PKG2 to PKG.
--  040114           Moved the global lu constantas used by them. Modifeid calls to them in other methods.
--  040114  LaBolk   Moved method Check_If_Counting_Impl___ from PKG2 to PKG. Modified the call to it in Check_If_Counting.
--  040114           Added view comments for columns lead_time_code_db, inventory_valuation_method_db, negative_on_hand_db, actual_cost_db and ext_service_cost_method_db.
--  040114  LaBolk   Moved method Check_Exist_Anywhere_Impl___ from PKG2 to PKG. Modified the call to it in Check_Exist_Anywhere.
--  --------------------------------------- 13.3.0 -----------------------------------------
--  031105  MaEelk   Created view INTORDER_PART_LOV2 for the MRO Agreement flow.
--  031024  KiSalk   Call 108851, Removed nurm_code.
--  031015  PrJalk   Bug Fix 106224, Corrected wrong General_Sys.Init_Method calls for Implementation methods declared in Package.
--  031014  PrJalk   Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  031009  MaGulk   Modified all views to include additional WHERE condition to exclude POSITION PARTs
--  031008  MaEelk   Call ID 106691, Changed the error message.
--  031007  MaEelk   Call ID 104532, Replaced the word Forecast Consumption with Online Consuptionat the error message in Procedure Unpack_Check_Update.
--  030929  PrTilk   Merged bug 39016. Modified method Check_Value_Method_Combinat___. Added a error message for Zero Cost Only.
--  030924  MaEelk   Removed codes written to get Quantiry_Onhand and Quantity_In_Transit in Procedure Unpack_Check_Update___.
--  030922  PrTilk   Merged LCS bug 37447. Added the error message NONINVSALESPARTEXIST in Unpack_Check_Insert___
--  030922           and modify method Copy_Part_To_Site_Impl__.
--  030917  SHVESE   Added validations in Unpack_Check_Update__ to check if the part exists on a Shop Order and is externally owned.
--  030917  MaMalk   Bug 35560, Modified New_Part in order to transfer Std Name ID from the engineering part to the inventory part.
--  030716  NaWalk   Performed CR Merge.
--  030716  NaWalk   Removed Bug coments.
--  030512  JoEd     Removed call to Sales_Part_API.Check_So_Flag.
--  030506  ChJalk   Bug 37151, Modified procedure Unpack_Check_Update___ to check whether the entered Asset class Exists.
--  030328  WaJalk   Renamed public attribute supply_chain_id to supply_chain_part_group.
--  030327  SeKalk   Replaced occurences of Site_Delivery_Address_API with Company_Address_API
--  030325  WaJalk   Added public attribute supply_chain_id to vie
--  ********************* CRMerge *****************************
--  030812  DAYJLK   Removed variable old_configuration_cost_method_ from Unpack_Check_Update__.
--  030811  LEPESE   Replaced call to method Inventory_Part_Config_API.Get_Inventory_Value_By_Method
--                   with call to method Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method.
--  030730  MaGulk   Merged SP4
--  030718  JOHESE   Added checks on position part in Unpack_Check_Update__ & Unpack_Check_Insert__
--  030709  MaEelk   Replaced calling Inventory_Part_In_Stock_API.Get_Aggregate_Qty_Onhand and Inventory_Part_In_Stock_API.Get_Total_Qty_IN_Transit
--  030709           with the call to Inventory_Part_In_Stock_API.Check_Quantity_Exist in Check_Delete___ and Unpack_Check_Update___.
--  030627  SudWlk   Modified the method Unpack_Check_Update__.
--  030626  SudWlk   Modified the method Unpack_Check_Update__ to check for exchange components
--  030626           when actual cost functionality is enabled.
--  030623  Dobese   Added more attributes in transfer to Chemmate. Pack_And_Post_Message__.
--  030617  DAYJLK   Removed all occurrences of configuration_cost_method and weighted_average_level.
--  030613  JOHESE   Added checks in Unpack_Check_Update___
--  030610  JaJalk   Added the method Check_Open_Eso_Exist___.
--  030609  JaJalk   Added the column EXT_SERVICE_COST_METHOD to the INVENTORY_PART_TAB.
--  030507  LEPESE   Changes in Check_Value_Method_Combinat___ in order to make sure that
--                   part_cost_level can only be 'COST PER PART' or 'COST PER CONFIGURAITON'
--                   for configured parts.
--  030506  ChJalk   Bug 37151, Modified procedure Unpack_Check_Update___ to check whether the entered Asset class Exists.
--  030429  LEPESE   Added parameter inventory_part_cost_level in call to
--                   Inventory_Part_Config_API.Check_Zero_Cost_Flag.
--  030416  LEPESE   Inserted call to Inventory_Part_Unit_Cost_API.Handle_Part_Cost_Level_Change
--                   in method Update___. Removed call to Handle_Average_Level_Change.
--                   Removed all business logic based on obsolete attributes weighted_average_level
--                   and configuration_cost_method.
--  030324  DAYJLK   Modified PKG of method call Check_Consignment_Exist from Inventory_Part_Loc_Consign_API
--  030324           to Inventory_Part_Stock_Owner_API in PROC Unpack_Check_Update___.
--  030226  SHVESE   Changed parameters in method Check_Value_Method_Combination and Check_Value_Method_Combinat___
--  030226           from part_catalog_rec_ to configurable_, condition_code_usage_,lot_tracking_code_,
--  030226           serial_tracking_code_.
--  030206  WaJalk   Bug 35246, Modified procedure Update___ to get the Inventory part Customs Stat No to Overview Sales Parts.
--  030205  SHVESE   Changed parameters in method Check_Value_Method_Combination.
--  030204  LEPESE   Added method Check_Value_Method_Combination.
--  030124  LEPESE   Added method Check_Value_Method_Combinat___. Moved several validations
--  030124           from unpack_check_insert___ and unpack_check_update___ to this new method.
--  030120  SHVESE   Added column inventory_part_cost_level in inventory_part.
--  030120           Added public method Get_Invent_Part_Cost_Level_Db. Included the column in the methods Get,
--  030120           Prepare_Insert___,New__,New_Part,Copy_Impl__.
--  030119  LEPESE   Bug 33140, added arguments in call to Inventory_Part_Config_API.Modify_Average_Cost.
--  021213  ThPalk   Bug 34758, Added information messages and aditional checks when changing part status on an inventory part.
--  021210  NaWalk   Bug 34633, Removed the correction done by Bug 19809.(ie made it possible to enter '%' in Part Description field)
--  ***********************************Take Off Phase 2***********************************************************
--  021118  DayJlk   Bug 34163, Added new LOV view INVENTORY_PART_LOV16.
--  021113  MiKulk   Bug 34105, Reverse the correction of bug 28243.
--  021107  DhAalk   Bug 33000, Changed the error message to reflect more accurately the reason why the
--  021107           update is not allowed on Forecast Consumption in Unpack_Check_Update___.
--  021024  PRINLK   Removed General_SYS.init method from method Get_Country_Of_Origin. Added PRAGMA instead.
--  020927  DhAalk   Bug 33000, Changed the error message on Forecast Consumption update in Unpack_Check_Update___ .
--  021023  LEPESE   Added call to Inventory_Part_Planning_API.Copy in method Copy.
--  020918  LEPESE   ***************** IceAge Merge Start *********************
--  020815  MaGu     Bug 30882. Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___.
--  020815           Removed check on net weight when customs stat no unit of measure is used.
--  020805  GaSolk   Bug 29440, Added new method Check_Partca_Part_Exist.
--  020619  DaZa     Bug 30248, new public attribute region_of_origin to views and methods.
--  020515  WaJalk   Bug 28243, Modified the method Qty_To_Order_Impl___.
--  ******************************** IceAge Merge End ***********************
--  020827  LEPESE   Redesign of checks for weighted average level in unpack_check_update___.
--  020826  LEPESE   Added call to Inventory_Part_Unit_Cost_API.Handle_Average_Level_Change
--                   from method Update___. Some code cleanup in unpack_check methods.
--  020826  ANLASE   Modified check for weighted average.
--  020821  ANLASE   Added check for weighted_average_level and qty in Unpack_Check_Update___.
--  020816  ANLASE   Corrected setting value for weighted_average_level in Unpack_Check_Update___.
--  020815  ANLASE   Added methods Check_Exist_Anywhere and Check_Exist_Anywhere_Impl___.
--  020812  ANLASE   Added WEIGHTED_AVERAGE_LEVEL_DB in Unpack_Check_Update___.
--  020805  ANLASE   Implemented new column weighted_average_level to real value.
--                   Added control to check that WA per condition code and consignment stock not
--                   is activated at the same time. Added global LU constant inst_CustConsStock_.
--  020630  SiJoNo   Altered view INVENTORY_PART_ALTERNATE.
--  020624  SiJoNo   Added view INTORDER_PART_ALTERNATE_LOV.
--  020620  LEPESE   Added hardcode value for weighted_average_level in function Get. Has
--                   to be changed to real value when column gets implemented.
--  020618  LEPESE   Removed method Modify_Average_Cost.
--  020617  SiJoNo   Added view INVENTORY_PART_ALTERNATE.
--  020603  ToFjNo   Removed manufacturer_id and manufacturer_part_id from the lu.
--  020514  SiJono   Added function Check_If_Alternate_Part.
--  ******************************** takeoff ( Baseline)**************************************************
--  020424  PRINLK   Added public method Get_Country_Of_Origin.
--  020404  JaBalk   Bug fix 28243,Remove all corrections.
--  020331  JaBalk   Bug fix 28243,Modified the method Qty_To_Order_Impl___.
--  020328  Thajlk   Bug fix 28243,Modified the method Qty_To_Order_Impl___.
--  020327  Thajlk   Call 80633, Removed traces, which included for Bug fix 28243.Correction already done by bug 28243.
--  020325  Thajlk   Bug fix 28243,Modified the method Qty_To_Order_Impl___ by adding dynamic calls.
--  020320  RoAnse   Bug fix 27908, Added check for actual costing, zero_cost_flag and Part_Catalog_API.Get_Configurable_Db
--                   and added messages in procedures Unpack_Check_Insert___ and Unpack_Check_Update___.
--  020319  Thajlk   Bug fix 28243 ( call Id 77405 ) Modified the method Qty_To_Order_Impl___.
--  020312  DAZA     Bug fix 28308, added error message for when intrastat_conv_factor <= 0 in
--                   methods Unpack_check_insert__ and Unpack_check_update__.
--  020220  LEPESE   Removed methods Get_Desc, Get_Unit_Meas_Noninv and Get_Description_Noninv.
--  020220  THAJLK   Added New Function Get_Desc.
--  020108  MKrase   Bug fix 27231, Deleted old_attr_ in Modify__ to get Note text to work.
--  020104  THAJLK   Added New Function Get_Unit_Meas_Noninv
--  020104  THAJLK   Added New Function Get_Description_Noninv
--  011129  ROALUS   Bug fix 26035, Unpack_check_insert__ modified.
--  010928  JeLise   Bug fix 19809, Added check on description in Unpack_Check_Update___.
--  010919  PuIllk   Bug fix 23535, Get correct oe_alloc_assign_flag,shortage_flag,forecast_consumption_flag,onhand_analysis_flag
--                   and assign to Asset_Class in Unpack_Check_Insert.
--  010824  OsAllk   Bug Fix 22700,Added Error_SYS.Item_Update(lu_name_, 'UNIT_MEAS'); in Unpack_Check_Update___.
--  010525  JSAnse   Bug fix 21463, Added TRUE as last parameter in the General_SYS.Init_Method call in Recalc_Stockfactors_Impl__ and
--                   Removed TRUE as the last parameter in Pack_And_Post_Message.
--  010522  JSAnse   Bug fix 21592, Removed dbms_output.
--  010418  JaBalk   Bug Fix 21022,Call the Purchase_Req_Util_API.Activate_Requisition before calling the
--                   Purchase_Req_Util_API.New_Line_Part in the procedure:Qty_To_Order_Impl___.
--  010411  DaJoLK   Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and
--                   TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  010403  RoAnse   Bug fix 19545, Modified procedure Unpack_Check_Update___  to prevent Forecast Consumption flag from
--                   getting updated when some order lines / quotation lines exist for planning (corrections from SOPRUS).
--  010313  SOPRUS   Bug Fix 19539, Modified MRP cursor to include DOP configured parts.
--  010302  MaKulk   Bug Fix 19766, Creted new view INVENTORY_PART_LOV_MRP Excluding parts with MRP code O,T or K.
--  010227  IsWilk   Bug Fix 20110, Modified the PROCEDURE Unpack_Check_Insert___.
--  010220  IsWilk   Bug Fix 19946, Modified the code to fetch the value as newrec_.shortage_flag := 'N'
--                   for the configured parts in the Unpack_Check_Insert___.
--  010216  JeAsSe   Added check in Unpack_Check_Insert___ to insure that variables PART_NO and
--                   DESCRIPTION don't contain percentage signs and added errormessage NOPERCENTSIGN.
--  010205  ANLASE   Made attribute country_of_origin public.
--  010104  JOHESE   Changed procedure Pack_And_Post_Message__
--  001220  JOHESE   Added check in Unpack_Check_Insert___
--  001218  ANLASE   Moved call to Inventory_Part_Config_API.Modify_Inventory_Value from
--                   Unpack_Check_Update___ to Update___.
--  001213  PERK     Changed cursor Get_Mrp_Part_Cur.
--  001212  PaLj     Changed method Insert___. Added dynamic call to ConfigurationSpec.
--  001211  ANLASE   Added parameter shortage_flag to New_Part, modified check for
--                   asset_class flags in Unpack_Check_Insert___ to enable CopyPartsToSite.
--  001204  ANLASE   Modified check for ConfigurationCostMethod in Unpack_Check_Update___.
--  001130  SHVE     Added restriction to prevent a combination of Weighted Average and
--                   Cost per Base Part for configured parts.
--  001127  LEPE     Added calls to set last_actual_cost_calc on Site when the first
--                   part ever on the site is switched over to be an Actual Costing part.
--  001121  JOHESE   Moved Purchase_Req_Util_API.Activate_Requisition call.
--  001113  ANLASE   Changed from REF CostConfigurationMethod to ConfigurationCostMethod in view comments.
--  001113  JOHW     Added missing join to part_catalog in LOV_VIEW14.
--  001105  JOHESE   Added calls to PROD_STRUCTURE_HEAD_API and RECIPE_STRUCTURE_HEAD_API
--                   in procedure Pack_And_Post_Message__
--  001103  JOHESE   Added PROCEDURE Pack_And_Post_Message__
--  001101  LEPE     Added calls to methods Purchase_Order_Line_Comp_API.Component_Part_Used
--                   and Pur_Ord_Charged_Comp_API.Not_Charged_Comp_Used in method
--                   Unpack_Check_Update___ to ensure that Actual Costing can not be
--                   activated for parts used as supplier material components
--                   or No Charge components.
--  001031  LEPE     Moved validation for attribute actual_cost from method Update___
--                   to method Unpack_Check_Update___.
--  001026  ANLASE   Added validation for configuration_cost_method in Unpack_Check_Update___.
--                   Changed default value for configuration_cost_method to COST PER CONFIGURATION.
--  001026  JOKE     Added initialization (Reset of value to NULL.) of the global
--                   estimated_material_cost in the beginning of the unpack_check
--                   methods.
--  001025  JOKE     Added validations on the actual_cost_flag.
--  001023  ANLASE   Replaced call to part_catalog with part_catalog_rec_ in Unpack_Check_Update___.
--  001022  JOKE     Default actual_cost_activated to the last transaction date applied for the
--                   part that got Actual Cost Activated.
--  001020  PaLj     Added cust_warranty_id and sup_warranty_id
--  001019  ANLASE   Renamed Cost_Configuration_Method to Configuration_Cost_Method and
--                   Get_Cost_Config_Method_Db to Get_Config_Cost_Method_Db.
--  001019  JOKE     Added public attribute Max_Actual_Cost_Update.
--  001018  ANLASE   Added attribute Cost_Configuration_Method. Added method Get_Cost_Config_Method_Db.
--  001017  JOKE     Get default Actual Cost per site in Unpack_Check_Insert.
--  001012  JOKE     Added new attribute actual_cost_activated.
--  001011  ANLASE   Added function Get_Shortage_Flag_Db.
--  001009  ANLASE   Added validation for configurations in unpack_check_insert___ and
--                   unpack_check_update___.
--  001002  JOKE     Corrected handling of actual_cost_ in New_Part.
--  000927  JOKE     Added column actual_cost and actual_cost_db.
--  000925  JOHESE   Added undefines.
--  000925  PERK     Added checks to prevent a part from using weighted average as valuation method if it is manufactured
--  000915  PaLj     Made expected_leadtime public
--  000908  PaLj     CID 48014. Added outer join (+) in get-function.
--  000901  PERK     Added technical_coordinator_id
--  000825  ANLASE   Added function Get_Type_Code_Db.
--  000824  PERK     Made count_variance public.
--  000804  LEPE     Continued reconstruction...
--  000727  LEPE     Major redesign because of CTO demands. Moved attributes
--                   inventory_value, estimated_material_cost, average_purchase_price
--                   and latest_purchase_price to LU InventoryPartConfig.
--  000719  GBO      Removed Get_Configurable function.
--                   Removed configurable_ parameter in New_Part
--  000718  GBO      Cleaned merging.
--  000717  GBO      Merged from Chameleon
--                   Changed configurable and configurable_db calls from Inventory_Part_Config_API.Decode
--                       to Part_Catalog_API.Get_Configurable and Part_Catalog_API.Get_Configurable_db.
--                   Changed configurable and configurable_db flags to A---L
--                   Moved procedure Update_Sales_Config___ to PARTCA. Removed all references.
--                   Added join to Part_Catalog.configurable_db in Create LOV_VIEW14
--                   Changed select Configurable in Get() function to Part_Catalog_API.Get_Configurable_Db
--  -------------------------- 12.10 -------------------------------------------
--  000615  LEPE     Changed behavior in method Modify_Average_Cost to avoid hard
--                   errors when cancelling PO Receipts.
--  000613  ROOD     Added restriction against changing the inventory_value if a part has a value in costing.
--  000609  ROOD     Added check for user_allowed_site on all LOV-views that didn't have it.
--  000606  ANLASE   Added check for user_allowed_site in WO_LOV_VIEW.
--  000531  NISOSE   Made a correction in recalc_stockfactors.
--  000525  NISOSE   Made a correction in recalc_stockfactors.
--  000505  ANHO     Replaced call to USER_DEFAULT_API.Get_Contract with USER_ALLOWED_SITE_API.Get_Default_Site.
--  000504  ANLASE   Added ean_no_ in procedure New_Part and Copy_Impl___.
--  000503  SHVE     Removed obsolete method Get_Inventory_Value.
--  000417  SHVE     Replaced reference to obsolete method Inventory_Part_Planning_API.Get_Scrapping_Adjusted_Qty
--                   with Inventory_Part_Planning_API.Get_Scrap_Added_Qty.
--  000414  NISOSE   Added General_SYS.Init_Method in Copy_Part_To_Site_Impl__,
--                   Distribute_Service_Rate_Priv__ and Get_Cumm_Leadtime.
--  000413  NISOSE   Cleaned-up General_SYS.Init_Method.
--  000411  ANHO     Removed obsolete method Get_Serialization_Flag.
--  000320  LEPE     Added call to Cost_Int_API.New_Lead_Time_Code from method
--                   Update___ whenever the lead_time_code is changed.
--  000309  NISOSE   Added EXPECTED_LEADTIME to attr_ in Modify_Manuf_Leadtime.
--  000308  JOHW     Done performance impovmentes in method Calc_Purch_Costs_Priv__.
--  000306  JOHW     Added Asset Class info to attr sent back to Client.
--  000306  NISOSE   Added check for negative values on weight_net.
--  000303  SHVE     Removed defaults for inventory_valuation_method and negative_on_hand
--                   from Prepare_Insert__.
--  000302  NISOSE   Performance tuning of Lov_View9.
--  000221  JOHW     Corrected Inventory_Part_Lov view.
--  000217  JOHW     Changed to new User_Allowed_Site functionality in views and cursors.
--  000214  ANHO     Removed function Get_Freeze_Code.
--  000103  SHVE     Added default value setting for db flags in Prepare_Insert__.
--  000128  SHVE     Added functions Get_Superseded_By and Get_Supersedes.
--  000126  SHVE     Added default value setting for db flags in Prepare_Insert__.
--  000121  SHVE     Added consignment stock validations for Inventory_valuation_method in
--                   unpack_check_update__.
--  000113  ANHO     Removed attribute freeze_code and methods Modify_Freeze_Code,
--                   Set_Freeze_Code and Reset_Freeze_Code.
--  000112  ANHO     Made cycle_period and cycle_code public and added method Get_Cycle_Code_Db.
--  000112  ANHO     Removed attributes next_count_date and last_count_date.
--  000105  SHVE     Added validations for inventory_value_method in Unpack_check_insert and unpack_check_update.
--  991230  SHVE     Added attributes inventory_valuation_method and negative_on_hand.
--  991207  JOHW     Changed name from INVENTORY_PART_MANUF_CELL_LOV to INVENTORY_PART_PROD_LINE_LOV.
--  991105  JoEd     Changed LOV view column comments on PART_NO.
--  991101  SHVE     Bug fix 12242: Copying estimated material cost to inventory value in insert__.
--  991020  SHVE     Bug fix 11224:Added a validation for negative estimated material cost
--                   in unpack_check_insert and unpack_check_update.
--  991007  ROOD     Added INVENTORY_PART_SPARE_PART_LOV to be used by MRP.
--  990921  ROOD     Bug fix 11406, NULL now indicates all sites in methods
--                   Calc_Purch_Costs and Calc_Purch_Costs_Priv__.
--  990919  ROOD     Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990824  ROOD     Changes in Get_Mrp_Part_Cur and Get_Hpm_Part_Cur to improve performance.
--  990614  DAZA     Moved check on CONFIGURABLE and Update_Sales_Config___ calls to update.
--  990607  SHVE     Changed priority of validations for supply type DOP.
--  990604  LEPE     Removed currency rounding from weighted average purchase price,
--                   average purchase price and latest purchase price calculations.
--  990603  LEPE     Added call to Purchase_Part_API.Remove in method Delete___.
--  990601  ANHO     Removed comma from errormessages and changed errormessage PARENT_NOT_3.
--  990528  ANHO     Removed scraphandling in loop in Qty_To_Order_Impl___.
--  990527  LEPE     Request for new call to MFGSTD from method Update___.
--  990526  ANHO     Removed unused view INVENTORY_PART_SPARE_PART_LOV.
--  990519  ANHO     Changed errormessages in the validation on customs_stat_no in the unpack-methods.
--  990519  SHVE     Updated estimated material cost too in Init_Inventory_Value.
--  990517  ROOD     Changed method Get_Stop_Analysis_Date from Procedure to Function.
--  990512  ROOD     Made several client-ordered processes behave in a similar way concerning mainly
--                   the handling of second_commodity.
--  990510  ROOD     Changes in method Recalc_Stockfactors_Impl___.
--  990505  ROOD     Made avail_activity_status mandatory and changed Get_Avail_Activity_Status accordingly.
--  990503  ROOD     Removed methods Get_Max_Part_No and Get_Min_Part_No.
--  990503  ROOD     General performance improvements.
--  990428  ROOD     Renamed Get_Value_By_Method to Get_Inventory_Value_By_Method.
--                   Made attribute Inventory_Value private.
--  990428  ROOD     Added LOV_VIEW12 and LOV_VIEW13 for MFGSTD.
--  990428  ROOD     Added function Get_Value_By_Method.
--                   Redirected Get_Inventory_Value to call this new method.
--  990427  ROOD     Removed view INVENTORY_PART_PUBLIC.
--                   Added parameter lead_time_code_db in call to Cost_Set_API.Create_Part_Cost.
--  990423  ROOD     Changed LOV_VIEW4 and LOV_VIEW5 for MFGSTD.
--  990421  ROOD     Added public cursor Get_Reorder_Point_Parts to be used by MRP.
--                   Changed the values sent back to the client efter Insert___ and Update___.
--                   Used the table when joining with InventoryPartPlanning to avoid dependencies.
--  990413  ROOD     Upgraded to performance optimized template.
--  990401  SHVE     Added currency rounding in Modify_Average_Cost.
--  990331  ANHO     Changed calculations in Qty_To_Order_Impl___ (mrpcode B) (CID 7540).
--  990330  FRDI     Removed check that leadtime =0 in Unpack_Check_insert___.
--  990326  FRDI     Leadtime restrictions for MRP code 'K' are now removed in
--                   Unpack_Check_insert___,  Unpack_Check_update___.
--  990326  JOHW     Tuned performance in Get_Stop_Analysis_Date.
--  990325  ANHO     Added Inventory_Part_Planning_API.Get_Scrapping_Adjusted_Qty in
--                   Qty_To_Order_Impl___.
--  990325  JOKE     Added handling for qty_at_customer in Modify_Average_Cost.
--  990322  ANHO     Added public attributes manufacturer_part_id and nurm_code.
--  990319  LEPE     Introduced currency rounding in method calc_purch_costs_priv__.
--  990319  SHVE     CID 11640: Corrected validation for MRP code K.
--  990318  SHVE     Added call to Part_Cost_API.Changed_Group_Id in Insert___.
--                   Removed Lock__ in Calc_Purch_Cost.
--  990316  FRDI     Updated insert properties on columns, count_variance, latest_purchase_price,
--                   average_purchase_price, last_count_date end next_count_date.
--  990311  ANHO     Added public method Get_No_Of_Parts.
--  990310  JOHW     Added check on negativ value on Cycle Period in unpack_check_update___.
--  990309  SHVE     CID-11616: Wrong transaction_code for transit in Revalue_impl.
--  990305  SHVE     Changed Modify_Average_Cost to include qty_in_transit and qty_onhand
--                   at all locations.
--  990303  FRDI     Added usage of asset class in Unpack_Check_Update___ for shortage and forecastconsumption
--                   and updating of flags if asset class is updated in Unpack_Check_insert___.
--  990302  SHVE     Added public method Modify_Part_Cost_Group_Id.
--  990226  SHVE     Removed rounding of latest_purchase_price and average_purchase_price.
--  990225  RaKu     Call ID 9021. Added lead_time_code to the returning attribute-string in Insert___.
--  990224  SHVE     Removed obsolete methods Count_Parts_On_Site, Insert_Period_History,
--                   Insert_Inventory_Value. Corrected Revalue_Impl___.
--  990219  JOHW     Corrected the Shortage Handling check.
--  990217  FRDI     CID 4427 - Lead time sould not be removed when chaning the part type for an inventory part
--  990216  ANHO     Changed ean_no from number to varchar.
--  990210  JOHW     Changed the call to SparePart to a dynamic PL call.
--  990209  RaKu     Added view INVENTORY_PART_PUBLIC.
--  990208  JAKH     Removed period_no in calls to Shop_Order_Prop_Int_API.Generate_proposal
--  990207  JOKE     Temporarily removed validation between SparePart and attribute
--                   Configurable (Weeklybuild Week 06).
--  990205  LEPE     Added valitation between SparePart and attribute Configurable.
--  990204  DAZA     Removed method Get_Inactive_Obs_Flag.
--  990204  ANHO     Changed call to Inventory_Transaction_Hist_API.Do_Booking in Revalue_Impl___ to call
--                   Inventory_Transaction_Hist_API.Do_Transaction_Booking .
--  990203  ANHO     Added attribut ean_no and method Get_Ean_No.
--  990203  DAZA     Added extra checks in Unpack_Check_Update___ and Update___
--                   for lead_time_code and stock_management. Added method Get_Stock_Management_Db.
--  990202  DAZA     A small change in error message HAS_QTY_ON_HAND.
--  990202  ROOD     Added public cursor Get_Hpm_Part_Cur.
--  990128  DAZA     Removed call to Inventory_Part_Status_Par_API.Get_Plan_Flag,
--                   changed calls to Inventory_Part_Status_Par_API.Get_xxx_Flag to
--                   Inventory_Part_Status_Par_API.Get_xxx_Flag_Db. Added
--                   demand_flag to LOV_VIEW8.
--  990127  DAZA     Removed inactive_obs_flag, only still left as an inparam to
--                   New_Part and in method Get_Inactive_Obs_Flag. Also removed
--                   method Check_Flags__, in Unpack_Check_Update___ the call to
--                   Check_Flags was replaced with a validation of onhand_flag
--  990126  LEPE     Corrections to create_date and last_activity_date.
--  990126  LEPE     Change to Get_Mrp_Part_Cur due to removal of inactive_obs_flag.
--  990125  FRDI     System parameter 'PURCHASE_VALUE_METHOD' to Site_API.Get_Inventory_Value_Method_Db(contract)
--  990122  SHVE     Fixed default setting of freeze_code in Prepare_Insert.
--  990117  ROOD     Added validation of Type Code and Order Requisition in Unpack_Check_Update___.
--  990115  ANHO     Added view INT_LOV_VIEW_ALL.
--  990114  FRDI     Now last_activity_date and create_date are set by the server
--                   only(to Site_API.Get_Site_Date(contract)).
--  990114  DAZA     Added public attributes Manufacturer_Id and Std_Name_Id and
--                   related methods.
--  990114  JoEd     Added intrastat_conv_factor and weight_net to Copy_Impl___ and
--                   New_Part procedures.
--  990112  FRDI     Changed Sysdate to site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--  990107  ERFI     Changed authorize_code to 20 characters in Qty_To_Order_Impl___
--  990106  ROOD     Added public attribute Dop_Connection and related methods.
--                   Replaced substr() with substrb() in views.
--  981217  JICE     Added public attribute Configurable and related methods.
--  981217  JOKE     Added call to Part_Cost_API.Changed_Group_Id in Update___.
--  981217  FRDI     Replaced calls to Unit_Type_API with calls ISO_Unit_Type_API.
--  981216  FRDI     Removed Get_Unit_Type___ and replaced it with calls to ISO_Unit_Type_API.
--  981214  FRDI     Replaced calls to MPCCOM_SHOP_CALENDAR_API with calls to WORK_TIME_CALENDAR_API.
--  981206  JOKE     Changed check for logical unit CostSetTemp to CostSet.
--  981203  FRDI     Inserted default values in prepare insert.
--  981202  SHVE     Changed where clause for LOV9 and renamed cost_set_temp to cost_set.
--                   Commented call to Cost_Type_Cost_Set in Insert_Inventory_Value.
--  981131  FRDI     Full precision for UOM, round result of shrinkage conservative.
--  981130  SHVE     Added part_cost_group_id.
--                   Added view LOV9.
--  981127  FRDI     Full precision for UOM,  round result of scrap calculation
--                   up to the next adjacent number.
--  981124  JOED     SID 7727: Added extra validations on net_weight, intrastat_conv_factor
--                   and customs_stat_no.
--  981122  FRDI     Full precision for UOM, change comments in tab,
--                   opend variables to number in Calc_Purch_Costs_Priv__.
--  981119  FRDI     Swaped Swapped places of contract and Part_on in &LOV_VIEW.
--  981117  SHVE     Corrected bugs in the costing related methods.
--  981104  SHVE     Replaced calls to InventoryPartLocation Get_Total_Qty_Onhand
--                   with Get_Aggregate_Qty_Onhand.
--  981030  SHVE     Added Calc_Purch_Costs,Modify_Inventory_Value,
--                   changed Get_Inventory_Value.
--  981020  SHVE     Removed serialization_flag,lot_tracking_code from New_Part.
--  981018  JOKE     Added NOCOSTDEL in check_delete__ to verify that there are
--                   no quantities on part location or in transit when deleting
--                   inventory part.
--  981015  JOKE     Added method Get_No_Of_Purchase_Parts plus removed
--                   user_allowed_site from lov_view8.
--  981015  SHVE     Removed serialization_flag,serial_rule and lot_tracking_code.
--                   Temporarily fixed New_Part, Get_Lot_Tracking_Code.
--  981012  JOED     Added weight_net and intrastat_conv_factor. Run LU through IFS/Design.
--                   Changed length of IIDs to 200 characters.
--  981009  JOKE     Changed Part_No to be a key instead of a parent key in LOV8 for MRP.
--  981006  JOKE     Added lov-view inventory_part_spare_part_lov.
--  981002  JOKE     Added cost related attributes Inventory_Value,
--                   Latest_Purchase_Price, Average_Purchase_Price and
--                   Estimated_Material_Cost.
--  980930  JOHW     Removed calls to Inventory_Part_Lock_API.
--  980928  JOKE     Added dynamic creation of part cost record in insert___. Plus
--                   beutified code in insert___.
--  980923  FRDI     HEAT 5038 - Added description to Copy Part To Site.
--  980917  ANHO     Added default value for stock_management in prepare_insert and unpack_check_insert.
--  980917  LEPE     Corrections in methods Set_Freeze_Code and Reset_Freeze_Code.
--  980916  JOHW     Added decode in Re-/Set_Freeze_Code.
--  980916  ANHO     Added attribute stock_management and method Get_Stock_Management.
--  980915  JOHW     Added methods Set_Freeze_Code and Reset_Freeze_Code.
--  980821  ANHO     Removed density and Calc_Qty_Uom (moved to ManufacturingStandard).
--  980820  ANHO     Removed stop_roll, low_level, the public cursors Get_Part and Get_Parts_Per_Low_Level,
--                   procedures Modify_Stop_Roll_Auto and Restore_Auto_Stop_Cost_Calc.
--  980820  ANHO     Removed bf_inv and Get_Bf_Inv.
--  980819  ANHO     Removed cumm_leadtime, Reset_Cumm_Leadtime, Modity_Cumm_Leadtime
--                   and added call to MANUF_PART_ATTRIBUTE_API.Get_Cum_Leadtime.
--  980817  SHVE     Replaced calls to ProdStructure Lu's with call to ManufStructureUtil.
--  980813  ANHO     Moved attribute mrp_order_code to InventoryPartPlanning.
--  980811  ANHO     Removed order_gap_time and function Get_Order_Gap_Time
--                   (moved to ManufacturingStandard).
--  980806  ANHO     Removed id_serial_code, est_scrap_value, buy_unit_meas, jit_flag,
--                   maintenance_flag, package_code, prod_plan_group, source.
--  980729  ANHO     Changed name on prompts.
--  980708  FRDI     Bug fix: Density is set to 1 as default in new_part().
--  980702  FRDI     Created and started usage of Get_Unit_Type___.
--  980701  FRDI     Bug fix: Density can't be negative now &
--                   in new_part() default value for density if UoM = m^3.
--  980625  FRDI     Moved functionality: now 'PurchasePart not exist'-check is
--                   done in Check_Delete___.
--  980609  GOPE     Get default value for serial rule from asset class
--  980608  GOPE     Added serial rule
--  980605  FRDI     Added Default_Buy_Unit_Meas in dynamic call to Purchase_Part_API.new().
--  980604  GOPE     Removed check against InventoryPartSerialTrac Allowed
--                   The IID value ALLOWED is removed in 10.5
--  980424  JOHO     SID 2792 - Added criterion in copy_part_to_site. And exist validation.
--  980417  FRDI     SID 3715 - Added description to Batch Processes.
--  980408  GOPE     Made asset class public
--  980407  SHVE     SID 2939: Changed parameters in call to Prepare_Order
--  980406  LEPE     Changed LU prompt for one of the LOV views.
--  980324  ANHO     SID 907. Change promptnames on viewcolumns.
--  980306  LEPE     Removal of illegal empty lines in view definitions.
--  980305  JICE     Bug 3651, JOHNIs changes from 10.3.1: Major changes in inventory
--                   statistics batch.
--                   Added function Count_Parts_On_Sites.
--                   Changes in Insert_Period_History and Insert_Inventory_Value.
--  980303  SHVE     Changed parameters in call to Inventory_Part_Planning_Api.Create_New_Part_Planning.
--  980227  SHVE     Added requisition_no as a parameter to procedure Qty_To_Order
--  980226  JOHO     Heat Id 3459 Correction of leadtimes when changing part types.
--  980225  JOHO     Heat Id 2786 Correction Check_Flags___
--  980223  GOPE     Used forcast consumption flag in asset class to get a default value
--                   for forecast consumption flag.
--  980223  JOHO     Heat Id 3087 correction.
--  980219  GOPE     Added checks on forecast consumption flag
--  980218  GOPE     Added Forecast consumption flag
--  980209  FRDI     Format on Amount Columns
--  980206  LEPE     Changes to methods Set_Avail_Activity_Status and Clear_Avail_Activity_Status
--                   to increase performance.
--  980123  JOHO     Added new method CopyPartToSite.
--  980122  JOHO     Restrucuring of shop order #2
--  980121  GOPE     Changed in Qty_To_Order_Impl___ check against InventoryPartSupplyType
--  980109  FRDI     Clean up conection to Purchase requisition
--  980109  GOPE/JOH O  Restructuring of shop order
--  971128  GOPE     Upgrade to fnd 2.0
--  971105  JOKE     Added validation to methods Modify_Purch_Leadtime and
--                   Modify_Expected_Leadtime.
--  971104  JOKE     Added creation of purchase_part and structure_head to update___.
--  971104  JOHNI    Rewrite of methods Modify_Purch_Leadtime and
--                   Modify_Expected_Leadtime.
--  971022  LEPE     Replaced note_id.nextval with a call to Document_Text_API.Get_Next_Note_Id.
--  971022  GOPE     Change in method Qty_To_Order_Impl___  to qty < order_point_qty_
--  971021  LEPE     Added restriction on removal of eng_attribute in unpack_check_update___.
--  971013  LEPE     Corrected bug on asset_class flags in unpack_check_insert___.
--  971013  LEPE     Made performance enhancement on method Reset_Cumm_Leadtime.
--  971009  GOPE     Made perfomance enhancement for count report
--  971009  LEPE     Added views INVENTORY_PART_NO_RECIPE_LOV and INVENTORY_PART_WEIGHT_VOL_LOV.
--  971003  LEPE     Changed view INTORDER_PART_LOV so that it also includes manufactured inventory parts.
--                   Added validation of supply_code against lead_time_code.
--  971002  LEPE     Added public cursor Get_Parts_Per_Low_Level. Redesigned procedures
--                   Reset_Low_Level and Set_Low_Level for better performance.
--  971002  GOPE     Added a cursor in method Get_Values_For_Accounting, performance
--  970926  JOKE     Changed check against System_parameter 'one_cost_set' and
--                   'sum_str_code' to use Gen_yes_no instead of language
--                   dependent 'J' and 'N'.
--  970917  PEKR     Further Bug 97-0175 correction in Reset_Low_Level.
--  970915  PEKR     Bug 97-0175 Dynamic call to Prod_Structure_Head_Util_API in
--                   Update___ should only be executed if type_code is modyfied.
--  970911  ANTA     Added scrapping algorithm to Qty_To_Order_Impl___.
--  970911  LEPE     Changed Recalc_Stockfactors_Priv__ to Recalc_Stockfactors_Impl___ since
--                   it is an implementation method. Removed validation against PartCatalog for U/M.
--                   Corrections in method Copy.
--  970910  LEPE     Added public method Copy.
--  970909  NABE     Changed UOM to 10 chars, removed all references of Unit_OF_Measure_API to
--                   Iso_Unit_API.
--  970908  LEPE     Redirected supply_code to connect to IID Material_Requis_Supply.
--  970904  LEPE     Added public modify methods for part_product_code and part_product_family.
--  970818  LEPE     BUG 97-0158. Error in public cursor Get_Mrp_Part_Cur regarding leadtime.
--  970720  NAVE     Initialized shortage_flag using Asset_Class_API in UCI. Moved checks
--                   related to MPCCOM System Parameter value and shortage_flag to the right
--                   places within UCI and UCU.
--  970708  NAVE     Added Shortage_Flag and Shortage_Flag_DB to main view and associated
--                   changes in UCI, UCU, Insert___ and Update___. Added public
--                   Get_Shortage_Flag. Added check for System Parameter - Shortage_Flag
--                   in UCU and UCI.
--  970618  PEKR     Corrected dynamic SQL of Shop_Order_Prop_API.Generate_Proposal in
--                   Qty_To_Order_Impl___.
--  970618  MAGN     Added control of unit_type for type_code "Manufacturing Recipe" in
--                   Unpack_Check_Insert and Unpack_Check_Update.
--  970617  PEKR     Changed call to SHPORD in Modify_Stop_Roll_Auto.
--  970617  GOPE     Removed check on lead time in unpack_check_update
--  970617  GOPE     Changed default for part track to NO client value 1
--  970617  JOED     Changed public Get_.. methods. Added _db column in the view.
--                   Beautified parts of the code.
--  970616  PELA     Changed message in procedure Exist Error_SYS.Record_Not_Exist and
--                   in procedure Insert___ under Exeption Error_SYS.Record_Exist.
--  970612  GOPE     Added rules on how to permit chage on tracking types
--  970606  LEPE     Call to method Modify_Rate_Cost in Inventory_Part_Planning changed to
--                   Modify_Planning_Attributes. New method does same thing.
--  970603  GOPE     Removed creation of struct and recipe head
--  970602  GOPE     Changed to new api call for head creation
--  970602  GOPE     Correction for shop order heads
--  970530  GOPE     Made an adjustment of required date in method Qty_To_Order_Impl_
--                   to insure that the date is a working day.
--  970523  GOPE     Added Recipe request and changes to PartCatalog
--  970520  FRMA     Removed call to Prod_Structure_Head_API.New in Insert__.
--  970520  CHAN     Added two new procedures ResetCummLeadtime and ModifyCummLeadtime.
--                   Added a new public cursor.
--  970519  FRMA/PEL A Corrected attribute name 'EST_SCRAP_VALUE' in procedure New_Part.
--  970516  PELA     Replaced call to Part_Ledger_API with call to Part_Catalog_API.
--  970516  MAGN     Corrected cursor in Insert_Inventory_Value and Insert_Period_History to insert values for
--                   part per contract.
--  970516  PEKR     Rewrite New_Part to not handle attr_ as inparameter.
--  970516  PEKR     Replaced call to Inventory_Part_Revision_API.New_Part_Rev
--                   with Inventory_Part_Revision_API.Create_First_Part_Rev.
--  970516  MAGN     Changed hardcoded transaction_code default 'INV' to function call get_char_value.
--  970509  PEKR     Added eng_attribute as an attribute + Get_Eng_Attribute.
--  970507  NAVE     Added public Modify_Manuf_Leadtime and added checks in UCI and UCU
--                   to raise error if attribute density is entered for UoM type != VOLUME
--  970507  FRMA     Changed reference for country_of_origin (Mpccom_Country to
--                   Application_Country)
--  970505  PEKR     Added 'M' in public cursor Get_Mrp_Part_Cur.
--  970502  PEKR     Removed parameters density, conv_factor and added code for
--                   Calc_Qty_Uom.
--  970429  PEKR     Added column density, methods Get_Density, Calc_Qty_Uom.
--  970428  PEKR     Added Check_If_Manufactured, Get_Stop_Roll, Modify_Stop_Roll_Auto,
--                   Restore_Auto_Stop_Cost_Calc.
--  970425  PEKR     Added public cursor Get_Mrp_Part_Cur.
--  970423  FRMA     Changed value of wanted_receipt_date_ from order_date_ to
--                   date_required in method Qty_To_Order_Impl___ (AGAIN!?).
--                   Added parameter requisition_no in call to Generate_Proposal from
--                   Qty_To_Order_Impl___.
--  970421  FRMA     Removed parameter user and added parameter lu_shp_exist
--                   for Qty_To_Order and Qty_To_Order_Impl. Added call to
--                   Shop_Order_Prop_API.Generate_Proposal in Qty_To_Order_Impl.
--  970417  LEPE     Added General_SYS.Init_Method to some procedures.
--  970415  VIVA     Added procedures Reset_Low_Level and Set_Low_Level.
--  970407  PELA     Added attribute order_gap_time to unpack_check_insert,
--                   prepare_insert, unpack_check_update plus validation on
--                   leadtime fields (no negative values).
--  970402  PELA     Added attribute order_gap_time.
--  970401  JOKE     Added Get_Customs_Stat_No.
--  970326  GOPE     Change in unpack_check_update to made it possible to get
--                   next_count_date for cyclic parts
--  970319  GOPE/NAV E Made Part_Product_Code, Part_Product_Family public
--  970312  CHAN     Change table name : part_description is replaced by
--                   inventory_part_tab
--  970311  JOKE     Changed calls to Purchase_Order_reservation due to name
--                   changes in purchase module.
--  970220  JOKE     Uses column rowversion as objversion (timestamp).
--  970131  ADBR     Changed col comments on view INVENTORY_PART_WO_LOV.
--  970129  ASBE     Added check for commodity_code in Distribute_Service_Rate.
--  970128  MAOR     Added procedure Get_Stop_Analysis_Date.
--  970127  JOKE     Added Note_Text to attr_ in Insert___.
--  970127  JOKE     Added calls to Part_Ledger and Document_Text in Insert___
--                   to fetch document_text and Note_text.
--  970126  ASBE     Added public procedure Modify_Mrp_Order_Code.
--  970121  JOKE     Removed references to PartLedger on LOV views.
--  970117  ADBR     Changed col comments on view INVENTORY_PART_WO_LOV.
--  970113  MAOR     Changed if-statement in Validate_Lead_Time_Code___. Replaced
--                   call to Inventory_Part_Type_API.Get_Client_Value(5) with no 4.
--                   Commented check on newrec_.lead_time_code in
--                   Unpack_Check_Insert___ and Unpack_Check_Update___.
--  970108  MAOR     Changed order of part_no and contract in INTORDER_PART_LOV.
--  970108  MAOR     Added view-comments on view INTORDER_PART_LOV.
--  970108  FRMA     Removed parameters in call to New_Requis_Line.
--  970108  PEOD     Added a call to ProdStructureHead New in Insert___
--  970107  FRMA     Bugfix in method Qty_To_Order (Used wrong Client_Value for
--                   Order_Requisition).
--  970103  FRMA     Replaced Mpccom_Default_API.Get_Defaults, with
--                   Mpccom_Default_API.Get_Number_Value in Recalc_Stockfactors_Priv__.
--                   Changed defaultvalue for Avail_Activity_Status.
--                   Added parameter demand_code in call to Prepare_Order.
--                   Changed order of parameters in call to Qty_To_Order.
--  961220  FRMA     Distribute_Service_Rate_Priv__ was called in wrong package.
--  961219  JOED     Changed the L-flags on columns used in LOV views.
--  961218  AnAr     Fixed check on second_commodity in Update___.
--  961217  AnAr     Fixed Call to Pur_Part_API and Inventory_Part_Planning_API.
--  961217  MAOR     Removed use of Inventory_Part_Status_API.
--  961217  FRMA     Added default values in prepare_insert and unpack_check_update
--  961217  AnAr     Made note_id not reaqired.
--  961217  PEKR     Unpack_Check_Update corrected due to asset_class handling.
--  961216  FRMA     Removed call to Set_Avail_Activity_Status in Update___.
--                   Removed NOT NULL restriction for Avail_Activity_Status.
--  961216  MNYS     Added parameter unit_GE in call to Purchase_Order_API.
--                   Prepare_Order.
--  961216  GOPE     Change the argument in call to New_Requis_line
--  961215  FRMA     Added update of avail_activity_status when purch_leadtime is changed.
--  961215  FRMA     Moved code from Qty_To_Order_Impl___ to
--                   Purchase_Order_API.Prepare_Order.
--  961215  JICE     Moved call to Part_Ledger_API.Check_Part_Exist from insert__
--                   to client.
--  961214  MAOR     Removed user from procedure Modify_Inventory_Value,
--                   Insert_Inventory_Value and Insert_Period_History.
--  961214  MAOR     Changed Get_Db_Value to Get_Client_Value.
--  961214  MAOR     Removed double declarations of procedures.
--  961213  HP       Removed user parameter from Purchase_Requisition and
--                   Purchase_Requis_Line.
--  961212  JOED     Renamed Check_Part_Contract_N to Part_Exist and changed order
--                   on parameter list.
--  961211  HP       Fetched a lot of extra parameters in Qty_To_Order_Impl.
--                   Changed call to Proposal_To_Order to dynamic SQL.
--                   Changed calls to User_Allowed_Site_API.Authorized_Batch_User
--                   to User_Allowed_Site_API.Authorized.
--                   Removed references to USER.
--  961210  HP       Added default value for avail_activity_status.
--  961205  HP       Added Set_Avail_Activity_Status and
--                   Clear_Avail_Activity_Status. Added authorize_code as a
--                   parameter to Qty_To_Order. Added call to
--                   Purchase_Order_API.Proposal_To_Order in Qty_To_Order.
--  961205  PEKR     Changed parameter order in Purchase_Part_API calls.
--  961202  JOBI     Removed parameter service_rate in procedure
--                   Distribute_Service_Rate.
--  961129  SHVE     Changed call to Purchase_Requis_Line_Api.New_Requis_Line.
--  961128  JOBI     Added Distribute_Service_Rate and Distribute_Service_Rate__.
--  961125  MAOR     Changed file to Rational Rose-Model and Workbench.
--  961107  SHVE     Changed order of part_no, contract in call to LU
--                   Purchase_Order_Reservation.Check_Part_Res_N. Also changed name
--                   of function called to Check_Part_Reservation.
--  961105  MAOR     Changed order of part_no, contract in call to LU
--                   Inventory_Part_Lock_API.
--  961105  JOED     Renamed calls to Sales_Part_API, added dynamic call to
--                   Active_Sales_Part_API.
--  961104  MAOR     Changed order of part_no, contract in call to LU
--                   Inventory_Part_Def_Loc_API.
--  961104  JICE     Replaced call to Inventory_Part_Status_Par_API.Get_Flags
--                   with 1 function per flag changed IID's for parameters.
--  961104  AnAr     Bug 96-0335.
--  961104  JOKE     Removed company parameters from call to Mpccom_Country_API.
--  961029  MAOR     Changed order of arguments in call to
--                   Cost_Type_Cost_Set_API.Create_All_Part_Costs.
--  961028  MAOR     Splitted call to Commodity_Group_API.Get_Rates into call to
--                   three functions Commodity_Group_API.Get_Carry_Rate,
--  961018  JOHNI    Modified all dbms_output by calls to Trace_SYS.
--  961016  MAOR     Added check if accounting_group is not null in
--                   Unpack_Check_Update___.
--  961015  SHVE     Added user as a parameter to procedure Qty_To_Order,Qty_To_Order__.
--  961015  STCE     Added view LOV_VIEW4 (due to that accounting group is showed in view
--                   INVENTORY_PART).
--  961015  MAOR     Removed procedure Recalc_Leatimes and Recalc_Leadtimes__.
--  961014  MAOR     Added batch_user to deferred_call in procedure
--                   Recalc_Stockfactors.
--  961014  ASBE     BUG 96-0318 Changed INT_LOV_VIEW so that only inventory parts
--                   are fetched.
--  961009  STCE     Added view LOV_VIEW3.
--  961009  JICE     Fixed cursor error in Calculate_Count_Date.
--  961009  JOKE     Added validation on field country_of_origin.
--  960926  VIVA     Added procedure p_Get_Planner_Buyer.
--  960924  AnAr     Removed procedure Make_Order_Point_Requisitions.
--  960923  JICE     Fixed cursor error in Validate_Lead_Time_Code.
--  960919  SHVE     Replaced Table references to Production tables with dynamic
--                   calls to the respective packages.
--  960918  LEPE     Added Exception handling for dynamic SQL.
--  960917  JICE     Changed oe_alloc_assign_flag to use IID CustOrdReservationType
--                   instead of GenYesNo.
--  960916  JICE     Added handling of customs_stat_no, added function Get_Low_Level,
--                   declaration of Part_Type in views uses Client_Values.
--  960916  SHVE     Added deferred call to procedures Recalc_Stockfactors,
--                   Recalc_Leadtimes, Make_Order_Point_Requisitions.
--  960913  SHVE     Created private package Inventory_Part3_Api to decrease the
--                   size of the main package.
--  960911  HARH     Added procedures Make_Order_Point_Requisitions, Qty_To_Order
--  960904  SHVE     Removed view INVENTORY_PART_DEMAND.
--  960902  GOPE     Correction in get_part_no
--  960902  HARH     Added functions Check_Parts_Commodity, Check_Type_Code_In_34
--  960902  GOPE     Change the argument cycle code to be client values and not numbers
--  960829  SHVE     Changed check with flag update_ to compare with iid
--                   UPDATE_LEADTIME_API(Client value) in procedure Recalc_Leadtimes.
--  960829  MAOR     Added procedure Update_Abc_Class.
--  960828  MAOS     Added Get_Part_Issue_Info.
--  960827  GOPE     Added function Get_Max_Part_No and Get_Min_Part_No
--  960826  RaKu     Fixed bug in cursor in procedure Get_Partdesc_Flags
--  960822  HARH     Removed exception raising from Recalc_Stockfactors
--  960822  JOAN     Added function Get_Note_Id
--  960821  MAOR     Added public cursor Get_Parts_To_Insert.
--  960817  MAOS     Removed check in module Production before delete.
--  960819  ADBR     Ref 96-0173: Added description in INT_LOV_VIEW.
--  960809  MAOS     Removed functions Get_Part_Remaining_Qty_So and
--                   Get_Qty_Demand_So.
--  960724  JOKE     Added FUNCTION Get_Abc_Class.
--  960718  JOED     Added procedure Get_Part_Description. Rewrote the
--                   Get_Description methods.
--  960717  JOED     Removed Yes_No-exist check on cycle_period.
--                   Changed req_upgrade_flag and eng_chg_status parameters (IID)
--                   values to Inventory_Part_Revision_API.New_Part_Rev
--                   Added Init_Method calls to some methods.
--  960716  JICE     Added function Part_Exist.
--  960705  HARH     Added function Get_Zero_Cost_Flag
--  960704  JICE     Changed number of arguments for bind on numeric columns.
--  960703  GOPE     Comment SHOP_MATERIAL_ALLOC_API.Get_Qty_Demand
--  960703  AnAr     Fixed flags on Note_Text.
--  960702  HARH     Added procedure Recalc_Stockfactors.
--  960701  HARH     Recalc_Leadtimes was changed to use Dynamic calls.
--  960628  JOLA     Changed db_value to client_value in procedure
--                   Get_Stop_Analysis_Date.
--  960624  HARH     Added procedure Recalc_Leadtimes.
--  960624  SHVE     Replaced calls to Lu's PurchasePart,CustomerOrderLine,
--                   PurchaseOrderLine,PurchaseOrderReservation,SalesPart.
--                   Replaced note_id.nextval in Insert___ with a select from dual.
--  960620  SHVE     Changed Get_Supply_code to select from the TABLE instead of
--                   the VIEW.
--  960620  GOPE     Change material_burden_flag_ to 1 if just commodity 2
--  960618  PEOD     Added the function Get_Type_Code and the procedure
--                   Get_Production_Flags.
--  960611  GOPE     Added setting of freeze_code if Null in Unpack_Chck_Insert___
--  960607  JOBE     Added functionality to CONTRACT.
--  960605  JOLA     Changed use of db_value to client_value in
--                   procedure Get_Stop_Analysis_Date
--  960531  PEOD     Temporarily commented out call to Shop_Ord_API.Get_Part_..
--                   and call to Shop_Material_Alloc_API.Get_Qty_Demand
--  960530  PEOD     Added function Get_Cumm_Leadtime.
--  960529  SHVE     Replaced reference to Mpc_Shop_Calendar_Pkg with call to
--                   MPCCOM_SHOP_CALENDAR_API.
--  960528  SHVE     Added function Get_Purch_Leadtime.
--  960521  RaKu     Fixed a bug in procedure Get_Partdesc_Flags
--  960514  SHVE     Replaced table references to part_classify and mpc_lock_part
--                   with calls to methods in the respective LU's.
--  960510  SHVE     Added methods Get_Part_No, Get_Partdesc_Flags.
--  960510  SHVE     Bug 96-0110: Introduced a decode statement in the view for
--                   supply_code.
--  960508  JOED     Added function Get_Manuf_Leadtime in LU 2
--  960508  JOLA     Added function Get_Stop_Analysis_Date
--                   Added procedure Get_Onhand_Analysis_Flag
--  960503  SHVE     Replaced table references with calls to LU's SALES_PART_API,
--                   CUSTOMER_ORDER_LINE_API.
--  960429  MAOS     Replaced call to note_id.nextval in procedure Insert___.
--  960426  ASBE     BUG 96-0096 Same part_no at another site. Added unit_meas
--                   check in cursors get_prev_uom.
--  960425  JOAN     Added function Check_Exist
--  960425  MPC5     Spec 96-0002 LONG-fields is replaced by VARCHAR2(2000).
--  960412  SHVE     Added methods fGet_Inactive_Obs_Flag, Get_Part_Information,
--                   New_Part,Get_Alloc_Assign_Flag and view INVENTORY_PART_LOV2
--                   (old name INV_PART_DESCRIPTION_LOV2) from the old track.
--  960328  JOHNI    Corrected END clause.
--  960327  SHVE     Cleaned up all SELECT,INSERTS etc to other LU's.
--  960326  LEPE     Done some serious work around the counting problem
--  960321  LEPE     Added public function get_serialization_flag
--  960320  JOHNI    Added view INVENTORY_PART_DEMAND for select from
--                   SUPPLY_DEMAND. Also added functions Get_Qty_Demand_So and
--                   Get_Qty_Demand_So.
--  960307  JICE     Renamed from InvPartDescription
--  960215  JICE     Fixed update_counted_part; didn't update last_count_date
--  960207  SHVE     Bug 96-0007: Changed declaration of material_burden_flag in
--                   the procedure Insert___.
--  960206  LEPE     Bug 96-0006: Changed parameter-type for newrec_ in procedure
--                   Insert___ in order to make it work on Oracle 7.2.3.
--  960123  JOHNI    Corrected invalid END clause.
--  960118  JOBR     Added purch_leadtime to prepare_insert
--  951113  OYME     Added procedure Get_Durability_Day. Corrected bug in proc.
--                   Get_Durability_Day (missing underscore on part_no in select.)
--  960112  JOBR     Set Last_activity_date to sysdate in update statement.
--  960112  JICE     Added functions Get_Type_Designation, Get_Dim_Quality.
--  960110  JOBR     Fetch of oe_alloc_assisgn_flag, onhand_analysis_flag
--                   according to asset-class. Zero_Cost_flag default 'N'.
--  951109  SVRO     Added function Get_UnitMeas.
--  951017  STOL     Added procedure Get_Lead_Time_Code.
--  951013  JOBR     Base Table to Logical Unit Generator 1.0
--  951013  JOBR     Created
--  951013  JOBR     Added functionality for V10.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Get_Mrp_Part_Rec IS RECORD(
   part_no        inventory_part_tab.part_no%TYPE,
   planner_buyer  inventory_part_tab.planner_buyer%TYPE,
   mrp_order_code inventory_part_planning_tab.planning_method%TYPE,
   lead_time      NUMBER,
   supply_flag_db inventory_part_status_par_tab.supply_flag%TYPE,
   lead_time_code inventory_part_tab.lead_time_code%TYPE,
   unit_meas      inventory_part_tab.unit_meas%TYPE,
   type_code      inventory_part_tab.type_code%TYPE);

CURSOR Get_Mrp_Part_Cur(contract_ IN VARCHAR2) RETURN Get_Mrp_Part_Rec
IS
   SELECT part.part_no,
          part.planner_buyer,
          plan.planning_method,
          decode(part.lead_time_code, 'M', part.manuf_leadtime, part.purch_leadtime) lead_time,
          stat.supply_flag_db,
          part.lead_time_code,
          part.unit_meas,
          part.type_code
   FROM  inventory_part_tab part, inventory_part_planning_pub plan, inventory_part_status_par_pub stat
   WHERE plan.part_no = part.part_no
   AND   plan.contract = part.contract
   AND   part.part_status = stat.part_status
   AND   stat.demand_flag_db = 'Y'
   AND   plan.planning_method IN ('A','D','E','F','G','H','K','M','P')
   AND   plan.contract = contract_;

TYPE Reorder_Point_Parts IS RECORD(
   part_no        VARCHAR2(25),
   type_code      VARCHAR2(20),
   mrp_order_code VARCHAR2(1),
   lead_time_code VARCHAR2(20),
   manuf_leadtime NUMBER,
   purch_leadtime NUMBER);

CURSOR Get_Reorder_Point_Parts(contract_ IN VARCHAR2) RETURN Reorder_Point_Parts
IS
   SELECT part.part_no,
          part.type_code,
          plan.planning_method,
          part.lead_time_code,
          part.manuf_leadtime,
          part.purch_leadtime
   FROM inventory_part_tab part, inventory_part_planning_tab plan
   WHERE  plan.part_no = part.part_no
   AND    plan.contract = part.contract
   AND    plan.planning_method IN ('B','C')
   AND    plan.contract = contract_;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Inv_Part_Not_Exist___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_,'NOTEXIST: Inventory part :P1 does not exist on site :P2.', part_no_, contract_);
END Raise_Inv_Part_Not_Exist___;   

PROCEDURE Raise_Part_Not_Exist___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'CONV_ERR_PART_MISS: Part :P1 does not exist on site :P2.', part_no_, contract_);
END Raise_Part_Not_Exist___;  

PROCEDURE Raise_Lot_Bat_Cost_Lvl_Error___ (
   newrec_   IN inventory_part_tab%ROWTYPE )   
IS
BEGIN   
   Error_SYS.Record_General(lu_name_,'LOTBATCOSLEV: Part Cost Level :P1 is only allowed for Lot Tracked Parts.',Inventory_Part_Cost_Level_API.Decode(newrec_.inventory_part_cost_level));
END Raise_Lot_Bat_Cost_Lvl_Error___;

PROCEDURE Raise_Position_Part_Type_Error___ 
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'POSITIONPART: Position parts can only have part type :P1.', Inventory_Part_Type_API.Decode('1'));   
END Raise_Position_Part_Type_Error___;   

PROCEDURE Raise_Input_Uom_Error___
IS 
BEGIN   
   Error_SYS.Record_General(lu_name_,'NOINPUTUOM: The Inventory UoM of Input UoM Group must be equal to Inventory Part U/M.');
END Raise_Input_Uom_Error___;

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   Raise_Inv_Part_Not_Exist___(contract_,part_no_);
   super(contract_, part_no_);
   --Add post-processing code here   
END Raise_Record_Not_Exist___;


-- Validate_Lead_Time_Code___
--   Fetches lead_time_code and validates type_code.
PROCEDURE Validate_Lead_Time_Code___ (
   lead_time_code_ OUT VARCHAR2,
   contract_       IN  VARCHAR2,
   part_no_        IN  VARCHAR2,
   type_code_      IN  VARCHAR2,
   old_type_code_  IN  VARCHAR2 )
IS   
   exist_ NUMBER;
BEGIN
   IF (type_code_ IN ('1', '2')) THEN
      lead_time_code_ := 'M';   
   ELSIF (type_code_ IN ('3', '6')) THEN
      IF ((old_type_code_ IS NOT NULL AND old_type_code_ != type_code_ ) OR (old_type_code_ IS NULL ))THEN
         $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
            exist_ := Manuf_Structure_Util_API.Part_Is_A_Product_Head(part_no_, contract_);  
            IF (exist_ = 1) THEN
               Error_SYS.Record_General(lu_name_, 'PARENT_NOT_3: The parent part cannot be of type :P1 when there exists routing head and structure head.', Inventory_Part_Type_API.Decode(type_code_));
            END IF;
         $ELSE
            NULL;
            -- Manufacturing component not installed.
         $END
      END IF;
      lead_time_code_ := 'P';
   ELSIF (type_code_ = '4') THEN
      lead_time_code_ := 'P';
   ELSE
      Error_SYS.Record_General(lu_name_, 'INVALID_PART_TYPE: Invalid part type. Enter 1 or 2 or 3 or 4 or 6.');
   END IF;
END Validate_Lead_Time_Code___;


PROCEDURE Check_Unit_Meas___ (
  contract_                      IN VARCHAR2,
  part_no_                       IN VARCHAR2,
  unit_meas_                     IN VARCHAR2,
  catch_unit_meas_               IN VARCHAR2,
  receipt_issue_serial_track_db_ IN VARCHAR2,
  catch_unit_enabled_            IN VARCHAR2 )
IS
    part_unit_meas_        VARCHAR2(10);
    part_catch_unit_meas_  VARCHAR2(30);
    
    CURSOR get_part_uom IS
      SELECT unit_meas
      FROM   inventory_part_tab
      WHERE  part_no    = part_no_
      AND    contract  != contract_
      AND    unit_meas != unit_meas_;

    CURSOR get_catch_uom IS
      SELECT catch_unit_meas
      FROM   inventory_part_tab
      WHERE  part_no    = part_no_
      AND    contract  != contract_
      AND    catch_unit_meas != catch_unit_meas_;
BEGIN
   OPEN get_part_uom;
   FETCH get_part_uom INTO part_unit_meas_;

   IF (get_part_uom%FOUND) THEN

      IF (Iso_Unit_API.Get_Base_Unit(unit_meas_) != Iso_Unit_API.Get_Base_Unit(part_unit_meas_)) THEN
         CLOSE get_part_uom;
         Error_SYS.Record_General(lu_name_, 'BASEUNITDIFF: The base unit :P1 for U/M :P2 is different from the base unit for this part on another site.', Iso_Unit_API.Get_Base_Unit(unit_meas_), unit_meas_ );
      ELSE
         IF (receipt_issue_serial_track_db_ = Fnd_Boolean_API.db_true) THEN
            IF Unit_Meas_Different_On_Sites(part_no_, unit_meas_) THEN
               Error_SYS.Record_General(lu_name_, 'CONVFACTOR: A part that is serial tracked cannot have different U/M in different sites.');
            END IF;
         END IF;
      END IF;
   END IF;
   CLOSE get_part_uom;

   IF catch_unit_meas_ IS NOT NULL THEN
      OPEN get_catch_uom;
      FETCH get_catch_uom INTO part_catch_unit_meas_;

      IF (get_catch_uom%FOUND) THEN
         IF (Iso_Unit_API.Get_Base_Unit(catch_unit_meas_) != Iso_Unit_API.Get_Base_Unit(part_catch_unit_meas_)) THEN
            CLOSE get_catch_uom;
            Error_SYS.Record_General(lu_name_, 'BASCATUNIT: The base unit :P1 for catch U/M :P2 is different from the base unit for this part on another site.', Iso_Unit_API.Get_Base_Unit(catch_unit_meas_), catch_unit_meas_ );
         END IF;
      END IF;
      CLOSE get_catch_uom;
      IF (catch_unit_enabled_ = 'TRUE') THEN
         $IF (Component_Order_SYS.INSTALLED) $THEN
            Sales_Part_API.Check_Enable_Catch_Unit(contract_, part_no_, catch_unit_meas_);
         $ELSE
            NULL;
         $END            
      END IF;
   ELSE
      IF (catch_unit_enabled_ = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'MANCATCH: The Catch UoM has to be entered when the Catch Unit functionality is enabled in Part Catalog.');
      END IF;
   END IF;
END Check_Unit_Meas___;


@Override
PROCEDURE Modify___ (
   newrec_              IN OUT NOCOPY inventory_part_tab%ROWTYPE,
   lock_mode_wait_      IN     BOOLEAN DEFAULT TRUE,
   updated_by_client_   IN     BOOLEAN DEFAULT FALSE )
IS
   objid_      inventory_part.objid%TYPE;
   objversion_ inventory_part.objversion%TYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_rec;
   oldrec_     inventory_part_tab%ROWTYPE;
BEGIN
   IF (updated_by_client_) THEN
      super(newrec_, lock_mode_wait_);
   ELSE
      IF (lock_mode_wait_) THEN
         oldrec_ := Lock_By_Keys___(newrec_.contract, newrec_.part_no);
      ELSE
         oldrec_ := Lock_By_Keys_Nowait___(newrec_.contract, newrec_.part_no);
      END IF;
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_, FALSE);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
   END IF;
END Modify___;


-- Copy_Impl___
--   Method creates new instance and copies all public attributes from
--   old part. The copying can be overriden by sending in specific values
--   via the attribute string.
PROCEDURE Copy_Impl___ (
   new_contract_             IN VARCHAR2,
   new_part_no_              IN VARCHAR2,
   old_contract_             IN VARCHAR2,
   old_part_no_              IN VARCHAR2,
   attr_                     IN VARCHAR2,
   error_when_no_source_     IN VARCHAR2,
   error_when_existing_copy_ IN VARCHAR2,
   create_purchase_part_     IN VARCHAR2 )
IS
   oldrec_                  inventory_part_tab%ROWTYPE;
   estimated_material_cost_ NUMBER;
   exit_procedure           EXCEPTION;
   part_cost_group_id_      inventory_part_tab.part_cost_group_id%TYPE := NULL;
   part_rec_                Inventory_Part_API.Public_Rec;
   to_storage_width_requirement_    inventory_part_tab.storage_width_requirement%TYPE;
   to_storage_height_requirement_   inventory_part_tab.storage_height_requirement%TYPE;
   to_storage_depth_requirement_    inventory_part_tab.storage_depth_requirement%TYPE;
   to_storage_volume_requirement_   inventory_part_tab.storage_volume_requirement%TYPE;
   to_storage_weight_requirement_   inventory_part_tab.storage_weight_requirement%TYPE;
   to_min_storage_temperature_      inventory_part_tab.min_storage_temperature%TYPE;
   to_max_storage_temperature_      inventory_part_tab.max_storage_temperature%TYPE;
   to_min_storage_humidity_         inventory_part_tab.min_storage_humidity%TYPE;
   to_max_storage_humidity_         inventory_part_tab.max_storage_humidity%TYPE;

   CURSOR get_oldrec IS
      SELECT *
      FROM   inventory_part_tab
      WHERE  contract = old_contract_
      AND    part_no  = old_part_no_;
BEGIN
   OPEN get_oldrec;
   FETCH get_oldrec INTO oldrec_;
   IF (get_oldrec%NOTFOUND) THEN
      CLOSE get_oldrec;
      IF (error_when_no_source_ = 'TRUE') THEN
         Raise_Inv_Part_Not_Exist___(old_part_no_, old_contract_);
      ELSE
         RAISE exit_procedure;
      END IF;
   ELSE
      CLOSE get_oldrec;
   END IF;
   IF (error_when_existing_copy_ = 'FALSE') THEN
      IF (Check_Exist___(new_contract_, new_part_no_)) THEN
         RAISE exit_procedure;
      END IF;
   END IF;
   Overwrite_Record_With_Attr___ (oldrec_, attr_);
   estimated_material_cost_ := Inventory_Part_Config_API.Get_Estimated_Material_Cost(old_contract_,
                                                                                     old_part_no_,
                                                                                     '*');
   estimated_material_cost_ := Site_API.Get_Currency_Converted_Amount(old_contract_,
                                                                      new_contract_,
                                                                      estimated_material_cost_);

   IF (new_contract_ = old_contract_) THEN
      part_cost_group_id_ := oldrec_.part_cost_group_id;
   ELSE
      Convert_Storage_Req_Uom___(to_storage_width_requirement_,
                                 to_storage_height_requirement_,
                                 to_storage_depth_requirement_,
                                 to_storage_volume_requirement_,
                                 to_storage_weight_requirement_,
                                 to_min_storage_temperature_,
                                 to_max_storage_temperature_,
                                 to_min_storage_humidity_,
                                 to_max_storage_humidity_,
                                 oldrec_,
                                 new_contract_);
   END IF;

   IF (Inventory_Part_Planner_API.Get_Objstate(oldrec_.planner_buyer) = 'Blocked') THEN
      oldrec_.planner_buyer := User_Default_API.Get_Planner_Id(Fnd_Session_API.Get_Fnd_User);
   END IF;
   -- gelr: good_service_statistical_code, acquisition_origin and  brazilian_specific_attributes added.
   New_Part(contract_                      => new_contract_ ,
            part_no_                       => new_part_no_ ,
            accounting_group_              => oldrec_.accounting_group ,
            asset_class_                   => oldrec_.asset_class ,
            country_of_origin_             => oldrec_.country_of_origin ,
            hazard_code_                   => oldrec_.hazard_code ,
            part_product_code_             => oldrec_.part_product_code ,
            part_product_family_           => oldrec_.part_product_family ,
            part_status_                   => oldrec_.part_status ,
            planner_buyer_                 => oldrec_.planner_buyer ,
            prime_commodity_               => oldrec_.prime_commodity ,
            second_commodity_              => oldrec_.second_commodity ,
            unit_meas_                     => oldrec_.unit_meas ,
            description_                   => oldrec_.description ,
            abc_class_                     => NULL ,
            count_variance_                => NULL ,
            create_date_                   => NULL ,
            cycle_code_                    => Inventory_Part_Count_Type_API.Decode(oldrec_.cycle_code) ,
            cycle_period_                  => oldrec_.cycle_period ,
            dim_quality_                   => oldrec_.dim_quality ,
            durability_day_                => oldrec_.durability_day ,
            expected_leadtime_             => oldrec_.expected_leadtime ,
            inactive_obs_flag_             => NULL ,
            last_activity_date_            => NULL ,
            lead_time_code_                => Inv_Part_Lead_Time_Code_API.Decode(oldrec_.lead_time_code) ,
            manuf_leadtime_                => oldrec_.manuf_leadtime ,
            note_text_                     => oldrec_.note_text ,
            oe_alloc_assign_flag_          => Cust_Ord_Reservation_Type_API.Decode(oldrec_.oe_alloc_assign_flag) ,
            onhand_analysis_flag_          => Inventory_Part_Onh_Analys_API.Decode(oldrec_.onhand_analysis_flag) ,
            purch_leadtime_                => oldrec_.purch_leadtime ,
            supersedes_                    => NULL ,
            supply_code_                   => Material_Requis_Supply_API.Decode(oldrec_.supply_code) ,
            type_code_                     => Inventory_Part_Type_API.Decode(oldrec_.type_code) ,
            customs_stat_no_               => oldrec_.customs_stat_no ,
            type_designation_              => oldrec_.type_designation ,
            zero_cost_flag_                => Inventory_Part_Zero_Cost_API.Decode(oldrec_.zero_cost_flag) ,
            avail_activity_status_         => NULL ,
            eng_attribute_                 => NULL ,
            forecast_consumption_flag_     => Inv_Part_Forecast_Consum_API.Decode(oldrec_.forecast_consumption_flag),
            intrastat_conv_factor_         => oldrec_.intrastat_conv_factor,
            invoice_consideration_         => Invoice_Consideration_API.Decode(oldrec_.invoice_consideration),
            max_actual_cost_update_        => oldrec_.max_actual_cost_update,
            shortage_flag_                 => Inventory_Part_Shortage_API.Decode(oldrec_.shortage_flag),
            inventory_part_cost_level_     => Inventory_Part_Cost_Level_API.Decode(oldrec_.inventory_part_cost_level),
            std_name_id_                   => oldrec_.std_name_id,
            input_unit_meas_group_id_      => oldrec_.input_unit_meas_group_id,
            dop_connection_                => Dop_Connection_API.Decode(oldrec_.dop_connection),
            supply_chain_part_group_       => oldrec_.supply_chain_part_group,
            ext_service_cost_method_       => Ext_Service_Cost_Method_API.Decode(oldrec_.ext_service_cost_method),
            stock_management_              => Inventory_Part_Management_API.Decode(oldrec_.stock_management),
            technical_coordinator_id_      => oldrec_.technical_coordinator_id,
            sup_warranty_id_               => oldrec_.sup_warranty_id,
            cust_warranty_id_              => oldrec_.cust_warranty_id,
            estimated_material_cost_       => estimated_material_cost_,
            automatic_capability_check_    => Capability_Check_Allocate_API.Decode(oldrec_.automatic_capability_check),
            create_purchase_part_          => create_purchase_part_,
            inventory_valuation_method_    => Inventory_Value_Method_API.Decode(oldrec_.inventory_valuation_method),
            negative_on_hand_              => Negative_On_Hand_API.Decode(oldrec_.negative_on_hand),
            create_part_planning_          => 'TRUE',
            catch_unit_meas_               => oldrec_.catch_unit_meas,
            part_cost_group_id_            => part_cost_group_id_,
            qty_calc_rounding_             => oldrec_.qty_calc_rounding,
            min_durab_days_co_deliv_       => oldrec_.min_durab_days_co_deliv,
            min_durab_days_planning_       => oldrec_.min_durab_days_planning,
            storage_width_requirement_     => to_storage_width_requirement_,
            storage_height_requirement_    => to_storage_height_requirement_,
            storage_depth_requirement_     => to_storage_depth_requirement_,
            storage_volume_requirement_    => to_storage_volume_requirement_,
            storage_weight_requirement_    => to_storage_weight_requirement_,
            min_storage_temperature_       => to_min_storage_temperature_,
            max_storage_temperature_       => to_max_storage_temperature_,
            min_storage_humidity_          => to_min_storage_humidity_,
            max_storage_humidity_          => to_max_storage_humidity_,
            standard_putaway_qty_          => oldrec_.standard_putaway_qty,
            putaway_zone_refill_option_    => Putaway_Zone_Refill_Option_API.Decode(oldrec_.putaway_zone_refill_option),
            dop_netting_db_                => oldrec_.dop_netting,
            reset_config_std_cost_db_      => oldrec_.reset_config_std_cost,
            co_reserve_onh_analys_flag_db_ => oldrec_.co_reserve_onh_analys_flag,
            mandatory_expiration_date_db_  => oldrec_.mandatory_expiration_date,
            statistical_code_              => oldrec_.statistical_code,
            acquisition_origin_            => oldrec_.acquisition_origin,
            acquisition_reason_id_         => oldrec_.acquisition_reason_id);            
   part_rec_ := Get(new_contract_, new_part_no_);
   -- Copy inventory part connected custom fields values.
   Custom_Objects_SYS.Copy_Cf_Instance(lu_name_, oldrec_.rowkey, part_rec_.rowkey);
EXCEPTION
   WHEN exit_procedure THEN
      NULL;
END Copy_Impl___;

PROCEDURE Convert_Storage_Req_Uom___(
   to_storage_width_requirement_    OUT NUMBER,
   to_storage_height_requirement_   OUT NUMBER,
   to_storage_depth_requirement_    OUT NUMBER,
   to_storage_volume_requirement_   OUT NUMBER,
   to_storage_weight_requirement_   OUT NUMBER,
   to_min_storage_temperature_      OUT NUMBER,
   to_max_storage_temperature_      OUT NUMBER,
   to_min_storage_humidity_         OUT NUMBER,
   to_max_storage_humidity_         OUT NUMBER,
   from_rec_                        IN  inventory_part_tab%ROWTYPE,
   to_contract_                     IN  VARCHAR2)
IS
   from_company_            VARCHAR2(20);
   to_company_              VARCHAR2(20);
   to_company_invent_rec_   Company_Invent_Info_API.Public_Rec;
   from_company_invent_rec_ Company_Invent_Info_API.Public_Rec;
BEGIN
   from_company_ := Site_API.Get_Company(from_rec_.contract);
   to_company_   := Site_API.Get_Company(to_contract_);
   IF (from_company_ != to_company_) THEN
      from_company_invent_rec_ := Company_Invent_Info_API.Get(from_company_);
      to_company_invent_rec_   := Company_Invent_Info_API.Get(to_company_);

      IF(from_rec_.storage_width_requirement IS NOT NULL OR from_rec_.storage_height_requirement IS NOT NULL OR from_rec_.storage_depth_requirement IS NOT NULL) THEN
         IF (from_company_invent_rec_.uom_for_length != to_company_invent_rec_.uom_for_length) THEN
            IF (from_rec_.storage_width_requirement IS NOT NULL) THEN
               to_storage_width_requirement_ := Iso_Unit_API.Get_Unit_Converted_Quantity( from_rec_.storage_width_requirement,
                                                                                          from_company_invent_rec_.uom_for_length,
                                                                                          to_company_invent_rec_.uom_for_length);
            END IF;
            IF (from_rec_.storage_height_requirement IS NOT NULL) THEN
               to_storage_height_requirement_ := Iso_Unit_API.Get_Unit_Converted_Quantity( from_rec_.storage_height_requirement,
                                                                                           from_company_invent_rec_.uom_for_length,
                                                                                           to_company_invent_rec_.uom_for_length);
            END IF;
            IF (from_rec_.storage_depth_requirement IS NOT NULL) THEN
               to_storage_depth_requirement_ := Iso_Unit_API.Get_Unit_Converted_Quantity( from_rec_.storage_depth_requirement,
                                                                                          from_company_invent_rec_.uom_for_length,
                                                                                          to_company_invent_rec_.uom_for_length);
            END IF;
         ELSE
            to_storage_width_requirement_    := from_rec_.storage_width_requirement;
            to_storage_height_requirement_   := from_rec_.storage_height_requirement;
            to_storage_depth_requirement_    := from_rec_.storage_depth_requirement;
         END IF;
      END IF;
      
      IF(from_rec_.storage_volume_requirement IS NOT NULL) THEN
         IF (from_company_invent_rec_.uom_for_volume != to_company_invent_rec_.uom_for_volume) THEN
            to_storage_volume_requirement_ := Iso_Unit_API.Get_Unit_Converted_Quantity( from_rec_.storage_volume_requirement,
                                                                                        from_company_invent_rec_.uom_for_volume,
                                                                                        to_company_invent_rec_.uom_for_volume);
         ELSE
            to_storage_volume_requirement_ := from_rec_.storage_volume_requirement;
         END IF;
      END IF;
      
      IF(from_rec_.storage_weight_requirement IS NOT NULL) THEN
         IF (from_company_invent_rec_.uom_for_weight != to_company_invent_rec_.uom_for_weight) THEN
            to_storage_weight_requirement_ := Iso_Unit_API.Get_Unit_Converted_Quantity( from_rec_.storage_weight_requirement,
                                                                                        from_company_invent_rec_.uom_for_weight,
                                                                                        to_company_invent_rec_.uom_for_weight);
         ELSE
            to_storage_weight_requirement_ := from_rec_.storage_weight_requirement;
         END IF;
      END IF;
      
      IF (from_rec_.min_storage_temperature IS NOT NULL OR from_rec_.max_storage_temperature IS NOT NULL) THEN
         IF (from_company_invent_rec_.uom_for_temperature != to_company_invent_rec_.uom_for_temperature) THEN
            IF (from_rec_.min_storage_temperature IS NOT NULL) THEN
               to_min_storage_temperature_ := Iso_Unit_API.Get_Unit_Converted_Quantity( from_rec_.min_storage_temperature,
                                                                                        from_company_invent_rec_.uom_for_temperature,
                                                                                        to_company_invent_rec_.uom_for_temperature);
            END IF;
            IF (from_rec_.max_storage_temperature IS NOT NULL) THEN
               to_max_storage_temperature_ := Iso_Unit_API.Get_Unit_Converted_Quantity( from_rec_.max_storage_temperature,
                                                                                        from_company_invent_rec_.uom_for_temperature,
                                                                                        to_company_invent_rec_.uom_for_temperature);
            END IF;
         ELSE
            to_min_storage_temperature_ := from_rec_.min_storage_temperature;
            to_max_storage_temperature_ := from_rec_.max_storage_temperature;
         END IF;
      END IF;

      to_min_storage_humidity_ := from_rec_.min_storage_humidity;
      to_max_storage_humidity_ := from_rec_.max_storage_humidity;
   END IF;
END Convert_Storage_Req_Uom___;


-- Check_Value_Method_Combinat___
--   This implementation method is called from unpack_check_insert___ and
--   unpack_check_update___ in order perform combination checks between
--   Inventory Valuation Method and Part Cost Level and Actual Costing
--   and Serial Tracking (In Inventory, Receipt and Issue) and Lot Batch Tracking and Zero Cost Allowed
--   and Condition Code settings and Configuration settings.
PROCEDURE Check_Value_Method_Combinat___ (
   newrec_                        IN inventory_part_tab%ROWTYPE,
   configurable_db_               IN VARCHAR2,
   condition_code_usage_db_       IN VARCHAR2,
   lot_tracking_code_db_          IN VARCHAR2,
   serial_tracking_code_db_       IN VARCHAR2,
   receipt_issue_serial_track_db_ IN VARCHAR2 )
IS
BEGIN

   IF (newrec_.inventory_valuation_method = 'ST') THEN
--    **********************************************
--    *                                            *
--    *      The "Standard Cost" section           *
--    *                                            *
--    **********************************************
      IF (configurable_db_ = 'CONFIGURED') THEN
         IF (newrec_.inventory_part_cost_level NOT IN ('COST PER CONFIGURATION',
                                                       'COST PER PART',
                                                       'COST PER SERIAL')) THEN
            Error_SYS.Record_General(lu_name_,'STCONFLEVERR: Part Cost Level :P1 is not allowed for Configured Parts.',Inventory_Part_Cost_Level_API.Decode(newrec_.inventory_part_cost_level));
         END IF;
      ELSE
         IF (newrec_.inventory_part_cost_level = 'COST PER CONFIGURATION') THEN
            Error_SYS.Record_General(lu_name_,'STCONFCOSLEV: Part Cost Level :P1 is only allowed for Configured Parts.',Inventory_Part_Cost_Level_API.Decode(newrec_.inventory_part_cost_level));
         END IF;
      END IF;
      IF ((condition_code_usage_db_ != 'ALLOW_COND_CODE') AND
          (newrec_.inventory_part_cost_level = 'COST PER CONDITION')) THEN
            Error_SYS.Record_General(lu_name_, 'CONDCOSTLEV: Cost Level :P1 is only allowed for Condition Code enabled parts.',Inventory_Part_Cost_Level_API.Decode(newrec_.inventory_part_cost_level));
      END IF;
      IF ((serial_tracking_code_db_ = Part_Serial_Tracking_API.db_not_serial_tracking)  AND
          (newrec_.inventory_part_cost_level = 'COST PER SERIAL')) THEN
         Error_SYS.Record_General(lu_name_,'SERIALCOSLEV: Part Cost Level :P1 is only allowed for parts that use the serial tracking option of ''In Inventory''.',Inventory_Part_Cost_Level_API.Decode(newrec_.inventory_part_cost_level));
      END IF;
      IF (newrec_.inventory_part_cost_level = Inventory_Part_Cost_Level_API.db_cost_per_lot_batch) THEN
         IF (lot_tracking_code_db_ = Part_Lot_Tracking_API.db_not_lot_tracking) THEN
            Raise_Lot_Bat_Cost_Lvl_Error___(newrec_);
         ELSE
            IF ((serial_tracking_code_db_       = Part_Serial_Tracking_API.db_not_serial_tracking) AND 
                (receipt_issue_serial_track_db_ = Fnd_Boolean_API.db_true)) THEN
               Error_SYS.Record_General(lu_name_,'STLOTBATCOSSER: Part Cost Level :P1 can only be used on a serial tracked part if it uses the serial tracking option of ''In Inventory''.',Inventory_Part_Cost_Level_API.Decode(newrec_.inventory_part_cost_level));
            END IF;
         END IF;
      END IF;
      IF (newrec_.invoice_consideration = 'PERIODIC WEIGHTED AVERAGE') THEN
         IF (configurable_db_ = 'CONFIGURED') THEN
            IF (newrec_.zero_cost_flag = 'N') THEN
               Error_SYS.Record_General(lu_name_,'CONFIGACTUAL: Zero Cost must be allowed when using :P1 for a Configured part.',Invoice_Consideration_API.Decode(newrec_.invoice_consideration));
            END IF;
            IF (newrec_.inventory_part_cost_level != 'COST PER CONFIGURATION') THEN
               Error_SYS.Record_General(lu_name_,'CONFIGCOST: :P2 on configured parts is only allowed for part cost level :P1.',Inventory_Part_Cost_Level_API.Decode('COST PER CONFIGURATION'), Invoice_Consideration_API.Decode(newrec_.invoice_consideration));
            END IF;
         ELSE
            IF (newrec_.inventory_part_cost_level != 'COST PER PART') THEN
               Error_SYS.Record_General(lu_name_,'NOCONFIGCOST: :P2 is only allowed for part cost level :P1.',Inventory_Part_Cost_Level_API.Decode('COST PER PART'), Invoice_Consideration_API.Decode(newrec_.invoice_consideration));
            END IF;
         END IF;
         IF (newrec_.zero_cost_flag = 'O') THEN
            Error_SYS.Record_General(lu_name_,'ZEROCOST: :P2 needs to be able to alter the cost. Therefore :P1 is not allowed.',Inventory_Part_Zero_Cost_API.Decode(newrec_.zero_cost_flag), Invoice_Consideration_API.Decode(newrec_.invoice_consideration));
         END IF;
      END IF;
      IF (newrec_.invoice_consideration ='TRANSACTION BASED') THEN
         IF (newrec_.inventory_part_cost_level != 'COST PER SERIAL') THEN
            Error_SYS.Record_General(lu_name_,'STTRANBSER: Supplier invoice consideration :P1 in combination with inventory valuation method :P2 is only allowed for part cost level :P3 ',Invoice_Consideration_API.Decode(newrec_.invoice_consideration),Inventory_Value_Method_API.Decode(newrec_.inventory_valuation_method),Inventory_Part_Cost_Level_API.Decode('COST PER SERIAL'));
         END IF;
      END IF;
      IF (newrec_.ext_service_cost_method = 'INCLUDE SERVICE COST') THEN
         IF (newrec_.inventory_part_cost_level != 'COST PER SERIAL') THEN
            Error_SYS.Record_General(lu_name_,'SERVICECOST: This combination of External Service Cost Method and the Inventory Valuation Method can only be used with Inventory Part Cost Level :P1.' ,Inventory_Part_Cost_Level_API.Decode('COST PER SERIAL'));
         END IF;
      END IF;
--    ******  End of the "Standard Cost" section  ******

   ELSIF (newrec_.inventory_valuation_method = 'AV') THEN
--    ***************************************************
--    *                                                 *
--    *  The "Weighted Average Purchase Price" section  *
--    *                                                 *
--    ***************************************************
      IF ((newrec_.negative_on_hand = 'NEG ONHAND OK')) THEN
         Error_SYS.Record_General(lu_name_, 'NEGQTYONHAND: Negative quantity onhand is not allowed for :P1 valuation method.',Inventory_Value_Method_API.Decode(newrec_.inventory_valuation_method));
      END IF;
      IF (newrec_.inventory_part_cost_level NOT IN ('COST PER PART',
                                                    'COST PER CONFIGURATION',
                                                    'COST PER CONDITION',
                                                    'COST PER LOT BATCH')) THEN
         Error_SYS.Record_General(lu_name_, 'AVGCOSTLEVEL: Cost Level :P1 is not allowed in combination with Inventory Valuation Method :P2.',Inventory_Part_Cost_Level_API.Decode(newrec_.inventory_part_cost_level),Inventory_Value_Method_API.Decode(newrec_.inventory_valuation_method));
      END IF;
      IF (newrec_.inventory_part_cost_level = Inventory_Part_Cost_Level_API.db_cost_per_lot_batch) THEN
         IF (lot_tracking_code_db_ = Part_Lot_Tracking_API.db_not_lot_tracking) THEN
            Raise_Lot_Bat_Cost_Lvl_Error___(newrec_);
         ELSE
            IF ((serial_tracking_code_db_       = Part_Serial_Tracking_API.db_not_serial_tracking) AND 
                (receipt_issue_serial_track_db_ = Fnd_Boolean_API.db_true)) THEN
               Error_SYS.Record_General(lu_name_,'AVLOTBATCOSSER: Part Cost Level :P1 can be used on a serial tracked part only if it is serial tracked in inventory.',Inventory_Part_Cost_Level_API.Decode(newrec_.inventory_part_cost_level));
            END IF;
         END IF;
      END IF;
      IF ((condition_code_usage_db_ != 'ALLOW_COND_CODE') AND
          (newrec_.inventory_part_cost_level = 'COST PER CONDITION')) THEN
            Error_SYS.Record_General(lu_name_, 'CONDCOSTLEV: Cost Level :P1 is only allowed for Condition Code enabled parts.',Inventory_Part_Cost_Level_API.Decode(newrec_.inventory_part_cost_level));
      END IF;
      IF (configurable_db_ = 'CONFIGURED') THEN
         IF (newrec_.inventory_part_cost_level NOT IN ('COST PER CONFIGURATION', 'COST PER LOT BATCH')) THEN
            Error_SYS.Record_General(lu_name_, 'AVCONFCOLEV: For a Configured part Inventory Valution Method :P1 is only allowed on Cost Level :P2.',Inventory_Value_Method_API.Decode(newrec_.inventory_valuation_method),Inventory_Part_Cost_Level_API.Decode('COST PER CONFIGURATION'));
         END IF;
         IF (newrec_.invoice_consideration ='TRANSACTION BASED') THEN
            Error_SYS.Record_General(lu_name_, 'WATRNOCOCOPA: :P1 invoice consideration in combination with inventory valuation method :P2 is not allowed for configured parts.', Invoice_Consideration_API.Decode(newrec_.invoice_consideration), Inventory_Value_Method_API.Decode(newrec_.inventory_valuation_method));
         END IF;
      ELSE
         IF (newrec_.inventory_part_cost_level NOT IN ('COST PER PART',
                                                       'COST PER CONDITION',
                                                       'COST PER LOT BATCH')) THEN
            Error_SYS.Record_General(lu_name_, 'AVNOCOCOLEV: Inventory Valution Method :P1 is only allowed on Cost Levels :P2 and :P3.',Inventory_Value_Method_API.Decode(newrec_.inventory_valuation_method),Inventory_Part_Cost_Level_API.Decode('COST PER PART'),Inventory_Part_Cost_Level_API.Decode('COST PER CONDITION'));
         END IF;
      END IF;
      IF (newrec_.invoice_consideration ='PERIODIC WEIGHTED AVERAGE') THEN
         Error_SYS.Record_General(lu_name_,'NOSTACTCST: :P2 is only allowed with inventory valuation method :P1.',Inventory_Value_Method_API.Decode('ST'),Invoice_Consideration_API.Decode(newrec_.invoice_consideration));
      END IF;
      IF (newrec_.negative_on_hand = 'NEG ONHAND NOT OK') AND
         (newrec_.zero_cost_flag = 'O') THEN
         Error_SYS.Record_General(lu_name_, 'ZEROCOSTONLY: Zero Cost Only can only be used together with Inventory Valuaton Method Standard Cost.');
      END IF;
--    ******  End of the "Weighted Average Purchase Price" section  ******

   ELSIF (newrec_.inventory_valuation_method IN ('FIFO','LIFO')) THEN
--    **********************************************
--    *                                            *
--    *      The "FIFO and LIFO" section           *
--    *                                            *
--    **********************************************
      IF ((newrec_.negative_on_hand = 'NEG ONHAND OK')) THEN
         Error_SYS.Record_General(lu_name_, 'NEGQTYONHAND: Negative quantity onhand is not allowed for :P1 valuation method.',Inventory_Value_Method_API.Decode(newrec_.inventory_valuation_method));
      END IF;
      IF (newrec_.inventory_part_cost_level != 'COST PER PART') THEN
         Error_SYS.Record_General(lu_name_,'FIFOCOSTLEV: :P1 is the only allowed Part Cost Level in combination with Inventory Valuation Method :P2 or :P3.',Inventory_Part_Cost_Level_API.Decode('COST PER PART'),Inventory_Value_Method_API.Decode('FIFO'),Inventory_Value_Method_API.Decode('LIFO'));
      END IF;
      IF (configurable_db_ = 'CONFIGURED') THEN
         Error_SYS.Record_General(lu_name_, 'VALMETCONFIG: Inventory valuation method :P1 is not allowed for configured parts.',Inventory_Value_Method_API.Decode(newrec_.inventory_valuation_method));
      END IF;
      IF (newrec_.invoice_consideration = 'PERIODIC WEIGHTED AVERAGE') THEN
         Error_SYS.Record_General(lu_name_,'NOSTACTCST: :P2 is only allowed with inventory valuation method :P1.',Inventory_Value_Method_API.Decode('ST'),Invoice_Consideration_API.Decode(newrec_.invoice_consideration));
      END IF;
      IF (newrec_.invoice_consideration = 'TRANSACTION BASED') THEN
         Error_SYS.Record_General(lu_name_,'TRBAFILI: :P1 invoice consideration is only allowed with inventory valuation methods :P2 and :P3.',Invoice_Consideration_API.Decode(newrec_.invoice_consideration),Inventory_Value_Method_API.Decode('ST'),Inventory_Value_Method_API.Decode('AV'));
      END IF;
      IF (newrec_.negative_on_hand = 'NEG ONHAND NOT OK') AND
         (newrec_.zero_cost_flag = 'O') THEN
         Error_SYS.Record_General(lu_name_, 'ZEROCOSTONLY: Zero Cost Only can only be used together with Inventory Valuaton Method Standard Cost.');
      END IF;
--    ******  End of the "FIFO and LIFO" section  ******
   ELSE
      Error_SYS.Record_General(lu_name_,'VALMETNOSUPP: Inventory Valuation Method :P1 is not supported by IFS Applications.',Inventory_Value_Method_API.Decode(newrec_.inventory_valuation_method));
   END IF;
END Check_Value_Method_Combinat___;


-- Check_Value_Method_Change___
--   Checks to be executed when changing inventory_valuation_method
--   or inventory_part_cost_level
PROCEDURE Check_Value_Method_Change___ (
   newrec_ IN inventory_part_tab%ROWTYPE,
   oldrec_ IN inventory_part_tab%ROWTYPE )
IS
   exist_                   NUMBER;
   part_exist_              NUMBER;
   quantity_exist_          BOOLEAN;   
   qty_to_deliv_confirm_    NUMBER;
   qty_in_consignment_      NUMBER;
   qty_in_exchange_         NUMBER;
   open_shop_orders_exist_  NUMBER := 0;
   qty_at_customer_fetched_ BOOLEAN := FALSE;
   consignment_exist_       BOOLEAN := FALSE;
BEGIN
   IF (newrec_.inventory_valuation_method != oldrec_.inventory_valuation_method) THEN
      IF (((oldrec_.inventory_valuation_method     IN ('FIFO', 'LIFO')) AND
           (newrec_.inventory_valuation_method NOT IN ('FIFO', 'LIFO'))) OR
          ((oldrec_.inventory_valuation_method NOT IN ('FIFO', 'LIFO')) AND
           (newrec_.inventory_valuation_method     IN ('FIFO', 'LIFO')))) THEN

         IF (Inventory_Part_In_Stock_API.Check_Quantity_Exist(newrec_.contract,newrec_.part_no,NULL) = 'TRUE') THEN
            quantity_exist_ := TRUE;
         ELSE
            quantity_exist_ := FALSE;
         END IF;

         IF NOT(qty_at_customer_fetched_) THEN
            Get_Our_Qty_At_Customer___(qty_to_deliv_confirm_,
                                       qty_in_consignment_,
                                       qty_in_exchange_,
                                       newrec_.contract,
                                       newrec_.part_no);

            qty_at_customer_fetched_ := TRUE;
         END IF;

         IF quantity_exist_ THEN
            -- It is only possible to change to and from FIFO/LIFO when inventory is empty.
            Error_SYS.Record_General(lu_name_, 'VMETHOD: Inventory must be empty when changing to :P1 valuation method.',Inventory_Value_Method_API.Decode(newrec_.inventory_valuation_method));
         END IF;

         IF (NVL(qty_in_consignment_, 0) > 0) THEN
            Error_SYS.Record_General(lu_name_, 'QTYCONS: Unconsumed customer consignment stocks exist for the part. Inventory Valuation Method can not be changed');
         END IF;

         IF (NVL(qty_to_deliv_confirm_, 0) > 0) THEN
            Error_SYS.Record_General(lu_name_, 'QTYDELV: This part is waiting for delivery confirmation. Inventory Valuation method can not be changed.');
         END IF;

         IF (NVL(qty_in_exchange_, 0) > 0) THEN
            Error_SYS.Record_General(lu_name_, 'QTYEXCHANGE: This part is in exchange. Inventory Valuation method can not be changed.');
         END IF;
      END IF;

      IF (oldrec_.inventory_valuation_method = 'ST') THEN
           consignment_exist_ := Inventory_Part_In_Stock_API.Check_Consignment_Exist(newrec_.contract, newrec_.part_no);
           IF (consignment_exist_) THEN
              Error_SYS.Record_General(lu_name_, 'PARTLOCCON: The inventory valuation method must be :P1 when there are goods in Consignment Stock.', Inventory_Value_Method_API.Decode('ST'));
           END IF;
           
           $IF (Component_Purch_SYS.INSTALLED) $THEN
              exist_ := Purchase_Part_Supplier_API.Check_Consignment_Exist(newrec_.contract, newrec_.part_no);           
              IF (exist_ = 1) THEN
                 Error_SYS.Record_General(lu_name_, 'PARTSUPPLIER: The inventory valuation method must be :P1 when there are Purchase part suppliers marked with consignment.', Inventory_Value_Method_API.Decode('ST'));
              END IF;
           $END

           $IF (Component_Purch_SYS.INSTALLED) $THEN
              exist_ := Purchase_Order_Line_Part_API.Check_Consignment_Exist(newrec_.contract, newrec_.part_no);
           
              IF (exist_ = 1) THEN
                 Error_SYS.Record_General(lu_name_, 'ORDERLINE: The inventory valuation method must be :P1 when there are Purchase order lines marked with consignment.', Inventory_Value_Method_API.Decode('ST'));
              END IF;
           $END
      END IF;

      IF newrec_.inventory_valuation_method != 'ST' THEN
         IF Inventory_Part_In_Stock_API.Is_Part_In_Fa_Rotable_Pool(newrec_.contract, newrec_.part_no) = 1 THEN
            Error_SYS.Record_General(lu_name_, 'PARTINPOOL: The inventory valuation method must be :P1 when the part exists in a fixed asset rotable part pool.', Inventory_Value_Method_API.Decode('ST'));
         END IF;
      END IF;
   END IF;

   IF (newrec_.inventory_part_cost_level != oldrec_.inventory_part_cost_level) THEN
      IF (newrec_.invoice_consideration = 'PERIODIC WEIGHTED AVERAGE') THEN
         Error_SYS.Record_General(lu_name_, 'ACLEVELERR: Cost Level can not be changed when Periodic Weighted Average is enabled.');
      END IF;

      IF (Inventory_Part_In_Stock_API.Check_Quantity_Exist(newrec_.contract,newrec_.part_no,NULL) = 'TRUE') THEN
         quantity_exist_ := TRUE;
      ELSE
         quantity_exist_ := FALSE;
      END IF;

      IF quantity_exist_ THEN
         Error_SYS.Record_General(lu_name_, 'WAINVEMTPY: It is not allowed to change Inventory Part Cost Level when you have a quantity in stock or in transit between stock locations.');
      END IF;

      IF NOT (qty_at_customer_fetched_) THEN
         Get_Our_Qty_At_Customer___(qty_to_deliv_confirm_,
                                    qty_in_consignment_,
                                    qty_in_exchange_,
                                    newrec_.contract,
                                    newrec_.part_no);
         qty_at_customer_fetched_ := TRUE;
      END IF;

      IF (nvl(qty_to_deliv_confirm_, 0) > 0) THEN
         Error_SYS.Record_General(lu_name_, 'WADELCONF: This part is waiting for delivery confirmation. Inventory Part Cost Level can not be changed.');
      END IF;

      IF (nvl(qty_in_consignment_, 0) > 0) THEN
         -- It is only possible to change weighted average level when inventory is empty.
         Error_SYS.Record_General(lu_name_, 'WACUSTCONS: Unconsumed customer consignment stocks exist for the part. Inventory Part Cost Level can not be changed');
      END IF;

      IF (NVL(qty_in_exchange_, 0) > 0) THEN
         Error_SYS.Record_General(lu_name_, 'WAEXCHANGE: This part is in exchange. Inventory Part Cost Level can not be changed.');
      END IF;

      IF newrec_.inventory_part_cost_level != 'COST PER SERIAL' THEN
         IF Inventory_Part_In_Stock_API.Is_Part_In_Fa_Rotable_Pool(newrec_.contract, newrec_.part_no) = 1 THEN
            Error_SYS.Record_General(lu_name_, 'PARTINPOOL2: The inventory part cost level must be :P1 when the part exists in a rotable part pool.', Inventory_Part_Cost_Level_API.Decode('COST PER SERIAL'));
         END IF;
      END IF;

      -- if part cost level is changed FROM Cost Per Part - check if there are orders using Delivery Confirmation
      -- and have order lines with this part that haven't been confirmed yet.
      $IF (Component_Order_SYS.INSTALLED) $THEN
         IF (oldrec_.inventory_part_cost_level = 'COST PER PART') THEN
            part_exist_ := Customer_Order_Line_API.Check_Part_Used(newrec_.contract, newrec_.part_no);        
            IF (part_exist_ = 1) THEN
               Error_SYS.Record_General(lu_name_, 'DELCONF_PARTUSED: The inventory part exists on customer order lines that haven''t been Delivery Confirmed yet. Inventory Part Cost Level can only be set to :P1 at this point.', Inventory_Part_Cost_Level_API.Decode('COST PER PART'));
            END IF;
         END IF;
      $END
   END IF;

   -- Check if open shop orders exist for the part
   $IF (Component_Shpord_SYS.INSTALLED) $THEN
      IF (Shop_Ord_Util_API.Active_Shop_Orders_Exist(newrec_.part_no, newrec_.contract)) THEN
         open_shop_orders_exist_ := 1;
      ELSE
         open_shop_orders_exist_ := 0;
      END IF;
   $END  

   IF (open_shop_orders_exist_ = 1) THEN
      IF (Cascade_Update_On_SO_Close___(oldrec_.inventory_valuation_method,
                                        oldrec_.inventory_part_cost_level)) THEN

         IF (Cascade_Update_On_SO_Close___(newrec_.inventory_valuation_method,
                                           newrec_.inventory_part_cost_level)) THEN
            -- Both settings would result in cascade updates for SO receipt transactions when the SO is
            -- closed, but changing valuation method or part cost level may result in variances
            -- being booked for open shop orders.
            -- Inform the user that variances may be booked for already open Shop Orders
            Client_SYS.Add_Info(lu_name_,
               'DIFFFORSO1: Open Shop Order(s) exist for this part. Change of Inventory Valuation Method or Inventory Part Cost Level may result in Variances being booked.');
         ELSE
            -- No cascade update of transactions will be executed for the new settings.
            -- Just inform the user that variances may be booked
            Client_SYS.Add_Info(lu_name_,
               'DIFFFORSO2: Open Shop Order(s) exist for this part. Variances may be booked for these as well as for new orders.');
         END IF;
      ELSIF (Cascade_Update_On_SO_Close___(newrec_.inventory_valuation_method,
                                           newrec_.inventory_part_cost_level)) THEN
         -- Cascade updates of transaction will be made for new SO:s but not for orders
         -- not closed for which receipts have already been made.
         -- Inform the user that variances may be booked for already open Shop Orders
         Client_Sys.Add_Info(lu_name_,
            'DIFFFORSO3: Open Shop Order(s) exist for this part. IF receipts have already been made Variances may be booked for these orders.');
      END IF;
   END IF;

   --Give an alert if the part is FIFO /LIFO and CC enabled
   IF (newrec_.inventory_valuation_method IN ('FIFO','LIFO') AND
       oldrec_.inventory_valuation_method NOT IN ('FIFO','LIFO')) THEN

      IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(newrec_.part_no) = 'ALLOW_COND_CODE') THEN
         Client_SYS.Add_Info(lu_name_,'FIFOLIFOANDCC: This part is set up using condition codes. The FIFO / LIFO valuation method will however not consider the condition code of the inventory transactions.');
      END IF;
   END IF;
END Check_Value_Method_Change___;


-- Check_Open_Eso_Exist___
--   This method checks whether there are open purchase order lines or
--   requisition lines for the part. If so an error will be raised.
PROCEDURE Check_Open_Eso_Exist___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   open_line_exist_ VARCHAR2(5);
BEGIN
   
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      open_line_exist_  := Purchase_Order_Line_Util_API.Check_Open_Eso_Exist(contract_, part_no_);  
      IF (open_line_exist_ = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_,'NOMODEXTCOSTORD: Since open service order(s) exist with the part :P1, External Service Cost Method cannot be modified.', part_no_);
      END IF;
      
      open_line_exist_  := Purchase_Req_Util_API.Check_Open_Eso_Exist(contract_, part_no_);
      IF (open_line_exist_ = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_,'NOMODEXTCOSTREQ: Since open service requisition(s) exist with the part :P1, External Service Cost Method cannot be modified.', part_no_);
      END IF;
   $ELSE
      NULL;  
   $END 
END Check_Open_Eso_Exist___;


-- Overwrite_Record_With_Attr___
--   This implementation method will unpack the attribute string and
--   overwrites the oldrec.
PROCEDURE Overwrite_Record_With_Attr___ (
   lu_rec_ IN OUT inventory_part_tab%ROWTYPE,
   attr_   IN     VARCHAR2 )
IS
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(2000);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'ACCOUNTING_GROUP') THEN
         lu_rec_.accounting_group := value_;
      ELSIF (name_ = 'ASSET_CLASS') THEN
         lu_rec_.asset_class := value_;
      ELSIF (name_ = 'COUNTRY_OF_ORIGIN') THEN
         lu_rec_.country_of_origin := value_;
      ELSIF (name_ = 'HAZARD_CODE') THEN
         lu_rec_.hazard_code := value_;
      ELSIF (name_ = 'NOTE_ID') THEN
         lu_rec_.note_id := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'PART_PRODUCT_CODE') THEN
         lu_rec_.part_product_code := value_;
      ELSIF (name_ = 'PART_PRODUCT_FAMILY') THEN
         lu_rec_.part_product_family := value_;
      ELSIF (name_ = 'PART_STATUS') THEN
         lu_rec_.part_status := value_;
      ELSIF (name_ = 'PLANNER_BUYER') THEN
         lu_rec_.planner_buyer := value_;
      ELSIF (name_ = 'PRIME_COMMODITY') THEN
         lu_rec_.prime_commodity := value_;
      ELSIF (name_ = 'SECOND_COMMODITY') THEN
         lu_rec_.second_commodity := value_;
      ELSIF (name_ = 'UNIT_MEAS') THEN
         lu_rec_.unit_meas := value_;
      ELSIF (name_ = 'DESCRIPTION') THEN
         lu_rec_.description := value_;
      ELSIF (name_ = 'ABC_CLASS') THEN
         lu_rec_.abc_class := value_;
      ELSIF (name_ = 'CYCLE_CODE') THEN
         lu_rec_.cycle_code := Inventory_Part_Count_Type_API.Encode(value_);
      ELSIF (name_ = 'CYCLE_PERIOD') THEN
         lu_rec_.cycle_period := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'DIM_QUALITY') THEN
         lu_rec_.dim_quality := value_;
      ELSIF (name_ = 'DURABILITY_DAY') THEN
         lu_rec_.durability_day := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'EXPECTED_LEADTIME') THEN
         lu_rec_.expected_leadtime := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'LEAD_TIME_CODE') THEN
         lu_rec_.lead_time_code := Inv_Part_Lead_Time_Code_API.Encode(value_);
      ELSIF (name_ = 'MANUF_LEADTIME') THEN
         lu_rec_.manuf_leadtime := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'NOTE_TEXT') THEN
         lu_rec_.note_text := value_;
      ELSIF (name_ = 'PURCH_LEADTIME') THEN
         lu_rec_.purch_leadtime := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'SUPERSEDES') THEN
         lu_rec_.supersedes := value_;
      ELSIF (name_ = 'SUPPLY_CODE') THEN
         lu_rec_.supply_code := Material_Requis_Supply_API.Encode(value_);
      ELSIF (name_ = 'TYPE_CODE') THEN
         lu_rec_.type_code := Inventory_Part_Type_API.Encode(value_);
      ELSIF (name_ = 'CUSTOMS_STAT_NO') THEN
         lu_rec_.customs_stat_no := value_;
      ELSIF (name_ = 'TYPE_DESIGNATION') THEN
         lu_rec_.type_designation := value_;
      ELSIF (name_ = 'ZERO_COST_FLAG') THEN
         lu_rec_.zero_cost_flag := Inventory_Part_Zero_Cost_API.Encode(value_);
      ELSIF (name_ = 'SHORTAGE_FLAG') THEN
         lu_rec_.shortage_flag := Inventory_Part_Shortage_API.Encode(value_);
      ELSIF (name_ = 'OE_ALLOC_ASSIGN_FLAG') THEN
         lu_rec_.oe_alloc_assign_flag := Cust_Ord_Reservation_Type_API.Encode(value_);
      ELSIF (name_ = 'ONHAND_ANALYSIS_FLAG') THEN
         lu_rec_.onhand_analysis_flag := Inventory_Part_Onh_Analys_API.Encode(value_);
      ELSIF (name_ = 'ENG_ATTRIBUTE') THEN
         lu_rec_.eng_attribute := value_;
      ELSIF (name_ = 'COUNT_VARIANCE') THEN
         Error_SYS.Item_Insert(lu_name_, name_);
      ELSIF (name_ = 'CREATE_DATE') THEN
         Error_SYS.Item_Insert(lu_name_, name_);
      ELSIF (name_ = 'AVAIL_ACTIVITY_STATUS') THEN
         Error_SYS.Item_Insert(lu_name_, name_);
      ELSIF (name_ = 'LAST_ACTIVITY_DATE') THEN
         Error_SYS.Item_Insert(lu_name_, name_);
      ELSIF (name_ = 'FORECAST_CONSUMPTION_FLAG') THEN
         lu_rec_.forecast_consumption_flag := Inv_Part_Forecast_Consum_API.Encode(value_);
      ELSIF (name_ = 'INTRASTAT_CONV_FACTOR') THEN
         lu_rec_.intrastat_conv_factor := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'INVOICE_CONSIDERATION') THEN
         lu_rec_.invoice_consideration := Invoice_Consideration_API.Encode(value_);
      ELSIF (name_ = 'MAX_ACTUAL_COST_UPDATE') THEN
         lu_rec_.max_actual_cost_update := value_;
      ELSIF (name_ = 'INVENTORY_PART_COST_LEVEL') THEN
         lu_rec_.inventory_part_cost_level := Inventory_Part_Cost_Level_API.Encode(value_);
      ELSIF (name_ = 'INPUT_UNIT_MEAS_GROUP_ID') THEN
         lu_rec_.input_unit_meas_group_id := value_;
      ELSIF (name_ = 'DOP_CONNECTION') THEN
         lu_rec_.dop_connection := Dop_Connection_API.Encode(value_);
      ELSIF (name_ = 'SUPPLY_CHAIN_PART_GROUP') THEN
         lu_rec_.supply_chain_part_group := value_;
      ELSIF (name_ = 'EXT_SERVICE_COST_METHOD') THEN
         lu_rec_.ext_service_cost_method := Ext_Service_Cost_Method_API.Encode(value_);
      ELSIF (name_ = 'STOCK_MANAGEMENT') THEN
         lu_rec_.stock_management := Inventory_Part_Management_API.Encode(value_);
      ELSIF (name_ = 'TECHNICAL_COORDINATOR_ID') THEN
         lu_rec_.technical_coordinator_id := value_;
      ELSIF (name_ = 'SUP_WARRANTY_ID') THEN
         lu_rec_.sup_warranty_id := value_;
      ELSIF (name_ = 'CUST_WARRANTY_ID') THEN
         lu_rec_.cust_warranty_id := value_;
      ELSIF (name_ = 'MIN_DURAB_DAYS_CO_DELIV') THEN
         lu_rec_.min_durab_days_co_deliv := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'MIN_DURAB_DAYS_PLANNING') THEN
         lu_rec_.min_durab_days_planning := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'PUTAWAY_ZONE_REFILL_OPTION') THEN
         lu_rec_.putaway_zone_refill_option := Putaway_Zone_Refill_Option_API.Encode(value_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
END Overwrite_Record_With_Attr___;


-- Check_Invoice_Consideration___
--   Validates the combination of Ownership Transfer Point and Supplier
--   Invoice Consideration. Called during insert and update of inventory parts.
PROCEDURE Check_Invoice_Consideration___ (
   contract_                 IN VARCHAR2,
   company_                  IN VARCHAR2,
   invoice_consideration_db_ IN VARCHAR2 )
IS
   company_dist_rec_ Company_Invent_Info_API.Public_Rec;
BEGIN
   IF (invoice_consideration_db_ = 'TRANSACTION BASED') THEN
      company_dist_rec_ := Company_Invent_Info_API.Get(company_);
      IF (company_dist_rec_.ownership_transfer_point = 'RECEIPT INTO INVENTORY') THEN
         Error_SYS.Record_General(lu_name_, 'TRBARECININ: You cannot use Transaction Based Supplier Invoice Consideration on site :P1 since the Ownership Transfer Point on company :P2 is :P3.', contract_, company_, Ownership_Transfer_Point_API.Decode(company_dist_rec_.ownership_transfer_point));
      END IF;
   END IF;
END Check_Invoice_Consideration___;


-- Check_Auto_Capability_Check___
--   Used for checking different criterias of the automatic capability check flag
PROCEDURE Check_Auto_Capability_Check___ (
   newrec_ IN inventory_part_tab%ROWTYPE )
IS
   planning_method_     VARCHAR2(1);
   sourcing_option_db_  VARCHAR2(20);
   dop_or_so_           NUMBER;   
BEGIN

   IF (newrec_.automatic_capability_check IN ('RESERVE AND ALLOCATE','ALLOCATE ONLY','NEITHER RESERVE NOR ALLOCATE')) THEN
      IF (newrec_.forecast_consumption_flag = 'FORECAST') THEN
         Error_SYS.Record_General(lu_name_, 'AOCCYESANDFORECAST: Online consumption cannot be set to active if Automatic Capability Check on inventory part is ":P1".',Capability_Check_Allocate_API.Decode(newrec_.automatic_capability_check));
      END IF;
      IF (newrec_.onhand_analysis_flag = 'Y') THEN
         Error_SYS.Record_General(lu_name_, 'AOCCYESANDAVAILCH: Availability check cannot be set to active if Automatic Capability Check on inventory part is ":P1".',Capability_Check_Allocate_API.Decode(newrec_.automatic_capability_check));
      END IF;
      planning_method_ := Get_Planning_Method___(newrec_.contract, newrec_.part_no);
      IF (planning_method_ IN ('P','N')) THEN
         Error_SYS.Record_General(lu_name_, 'AOCCYESANDMRPPN: Planning Method cannot be P or N if Automatic Capability Check on inventory part is ":P1".',Capability_Check_Allocate_API.Decode(newrec_.automatic_capability_check));
      END IF;
      $IF (Component_Order_SYS.INSTALLED) $THEN
         IF (newrec_.automatic_capability_check = 'RESERVE AND ALLOCATE') THEN
            sourcing_option_db_ := Sales_Part_API.Get_Sourcing_Option_Db(newrec_.contract, newrec_.part_no);
            IF sourcing_option_db_ = 'SHOPORDER' THEN
               Error_SYS.Record_General(lu_name_, 'AOANDSOINVALID: Capability Check cannot be set to ":P1" if Sourcing Option on any related sales part is set to ":P2".',
                                        Capability_Check_Allocate_API.Decode(newrec_.automatic_capability_check), 
                                        Sourcing_Option_API.Decode(sourcing_option_db_));
            END IF;
         ELSE 
            dop_or_so_ := Sales_Part_API.Src_Option_Must_Be_Dop_Or_So(newrec_.contract, newrec_.part_no);   
            IF (dop_or_so_ = 0) THEN
               Error_SYS.Record_General(lu_name_, 'INVPARTAOCCYES: Sourcing Option on any related sales part must be set to DOP Order or Shop Order if Automatic Capability Check on inventory part is ":P1".',Capability_Check_Allocate_API.Decode(newrec_.automatic_capability_check));
            END IF;
         END IF;
      $END
   END IF;
END Check_Auto_Capability_Check___;


-- Cascade_Update_On_SO_Close___
--   Check if a Shop Order for a part should trigger a cascade update
--   of transactions when the SO is closed. A cascade should be initiated
--   when valuation method is Weighted Average or cost level is cost per
FUNCTION Cascade_Update_On_SO_Close___ (
   inventory_valuation_method_db_ IN VARCHAR2,
   inventory_part_cost_level_db_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF ((inventory_valuation_method_db_ = 'AV') OR
       (inventory_part_cost_level_db_ = 'COST PER SERIAL')) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Cascade_Update_On_SO_Close___;


-- Get_Calc_Rounded_Qty___
--   Calculates and returns the rounded inventory quantity.
FUNCTION Get_Calc_Rounded_Qty___ (
   original_qty_      IN NUMBER,
   qty_calc_rounding_ IN NUMBER,
   action_            IN VARCHAR2,
   unit_meas_         IN VARCHAR2,
   ignore_unit_type_  IN BOOLEAN ) RETURN NUMBER
IS
   adjusted_qty_ NUMBER;
   unit_type_db_ VARCHAR2(10);
BEGIN
   adjusted_qty_ := original_qty_;
   IF (qty_calc_rounding_ IS NOT NULL) THEN
      -- Round adjust_qty_ only when the unit type of the used unit of measure is 'WEIGHT','VOLUME','LENGTH' 
      unit_type_db_ := Iso_Unit_API.Get_Unit_Type_Db(unit_meas_);
      IF (unit_type_db_ IN ('WEIGHT','VOLUME', 'LENGTH') OR (ignore_unit_type_)) THEN 
         adjusted_qty_ := ROUND(adjusted_qty_, qty_calc_rounding_ + 2);
      END IF;
      IF (adjusted_qty_ != TRUNC(adjusted_qty_, qty_calc_rounding_)) THEN
         IF (action_ = 'ADD') THEN
            adjusted_qty_ := TRUNC(adjusted_qty_, qty_calc_rounding_) +
                             POWER(10, qty_calc_rounding_ * -1);
         ELSIF (action_ = 'REMOVE') THEN
            adjusted_qty_ := TRUNC(adjusted_qty_, qty_calc_rounding_);
         ELSIF (action_ = 'ROUND') THEN
            adjusted_qty_ := ROUND(adjusted_qty_, qty_calc_rounding_);
         END IF;
      END IF;
   END IF;
   adjusted_qty_ := NVL(adjusted_qty_, 0);
   RETURN adjusted_qty_;
END Get_Calc_Rounded_Qty___;


-- Check_Qty_Calc_Rounding___
--   Checks if the qty_calc_rounding is valid.
--   EBALL-37, Added new parameter qty_in_exchange_.
PROCEDURE Check_Qty_Calc_Rounding___ (
   qty_calc_rounding_             IN NUMBER,
   receipt_issue_serial_track_db_ IN VARCHAR2,
   unit_meas_                     IN VARCHAR2 )
IS
BEGIN
   IF (receipt_issue_serial_track_db_ = Fnd_Boolean_API.db_true AND qty_calc_rounding_ != 0) THEN
      Error_SYS.Record_General(lu_name_, 'CALCROUNDSER: Qty Calc Rounding must be zero for parts that are serial tracked during receipt and issue.');
   ELSIF (Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(unit_meas_)) = 'DISCRETE' AND qty_calc_rounding_ != 0) THEN
      Error_SYS.Record_General(lu_name_, 'CALCROUNDDIS: Qty Calc Rounding must be zero for parts with a discrete unit of measure.');
   END IF;
   IF ((qty_calc_rounding_ > 20) OR (qty_calc_rounding_ < 0)
       OR (MOD(qty_calc_rounding_, 1) != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'ERRORQTYCALCROUNDING: Qty Calc Rounding must be an integer between 0 and 20.');
   END IF;
END Check_Qty_Calc_Rounding___;


-- Get_Our_Qty_At_Customer___
--   Gets the customer's inventory quantity and consignment value.
PROCEDURE Get_Our_Qty_At_Customer___ (
   qty_to_deliv_confirm_ OUT NUMBER,
   qty_in_consignment_   OUT NUMBER,
   qty_in_exchange_      OUT NUMBER,
   contract_             IN  VARCHAR2,
   part_no_              IN  VARCHAR2 )
IS   
BEGIN
   Inventory_Part_At_Customer_API.Get_Our_Total_Qty_At_Customer (qty_to_deliv_confirm_,
                                                                 qty_in_consignment_,
                                                                 qty_in_exchange_,
                                                                 contract_,
                                                                 part_no_);
END Get_Our_Qty_At_Customer___;


-- Handle_Description_Change___
--   This method can be used to update description in object reference and
--   send an EDI message to Chemmate.
PROCEDURE Handle_Description_Change___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   key_ref_ VARCHAR2(2000);   
BEGIN
    IF (Part_Catalog_Invent_Attrib_API.Get_Hse_Contract(part_no_) = contract_) THEN
      Pack_And_Post_Message__('ADDEDIT', part_no_, contract_);
   END IF;
   
   $IF (Component_Docman_SYS.INSTALLED) $THEN   
      Client_SYS.Get_Key_Reference(key_ref_, lu_name_, Get_Objid__(contract_, part_no_));
      Doc_Reference_Object_API.Refresh_Object_Reference_Desc(lu_name_, key_ref_);      
   $END
   
   $IF (Component_Cbsint_SYS.INSTALLED) $THEN
      Cbs_So_Int_API.Modify_Part_Desc(contract_, part_no_);
   $END
END Handle_Description_Change___;


PROCEDURE Check_Lead_Time___ (
   lead_time_ IN NUMBER )
IS
BEGIN
   IF ((lead_time_ < 0) OR (lead_time_ != trunc(lead_time_)))THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDLEADTIMES: Lead Time must have a positive integer value.');
   END IF;
END Check_Lead_Time___;


PROCEDURE Check_Expense_Part_Allowed___ (
   allow_not_consumed_ IN VARCHAR2)
IS
BEGIN
   IF (allow_not_consumed_ = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'NOTALLWCONSUMED: Allowed as Not Consumed must be selected in Part Catalog when Part Type is set to Expense.');
   END IF; 
END Check_Expense_Part_Allowed___;


PROCEDURE Check_Min_Durab_Days_Co_Del___ (
   durability_day_          IN NUMBER,
   min_durab_days_co_deliv_ IN NUMBER )
IS
BEGIN
   
   IF ((min_durab_days_co_deliv_ < 0) OR
       (min_durab_days_co_deliv_ != ROUND(min_durab_days_co_deliv_))) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDCODURABLELE: The minimum remaining durability days for the customer order delivery must be a positive integer value.');
   END IF;
   
   IF (durability_day_ IS NOT NULL) THEN
      IF (min_durab_days_co_deliv_ > durability_day_) THEN
         Error_SYS.Record_General(lu_name_, 'CODURABLELESSTHANDURABLE: The minimum remaining durability days for the customer order delivery must not be greater than the shelf life of the inventory part.');
      END IF;
   END IF;
END Check_Min_Durab_Days_Co_Del___;


PROCEDURE Check_Min_Durab_Days_Plan___ (
   durability_day_          IN NUMBER,
   min_durab_days_planning_ IN NUMBER )
IS
BEGIN
   IF ((min_durab_days_planning_ < 0) OR
       (min_durab_days_planning_ != ROUND(min_durab_days_planning_))) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDMINDURABPLAN: The minimum remaining durability days for planning must be a positive integer value.');
   END IF;

   IF (durability_day_ IS NOT NULL) THEN
      IF (min_durab_days_planning_ > durability_day_) THEN
         Error_SYS.Record_General(lu_name_, 'MINDURABLESSTHANDURABLE: The minimum remaining durability days for planning must not be greater than the shelf life of the inventory part.');
      END IF;
   END IF;
END Check_Min_Durab_Days_Plan___;


PROCEDURE Handle_Planning_Attr_Change___ (
   newrec_ IN inventory_part_tab%ROWTYPE,
   oldrec_ IN inventory_part_tab%ROWTYPE)
IS
   new_status_rec_  Inventory_Part_Status_Par_API.Public_Rec;
   old_status_rec_  Inventory_Part_Status_Par_API.Public_Rec;   
   planning_method_ VARCHAR2(1);
   exit_procedure_  EXCEPTION;
BEGIN
   
   IF NOT (Component_Invpla_SYS.INSTALLED) THEN 
      RAISE exit_procedure_;
   END IF;
   $IF (Component_Invpla_SYS.INSTALLED) $THEN
      IF (Site_Ipr_Info_API.Get_Ipr_Active_Db(newrec_.contract) = Fnd_Boolean_API.DB_FALSE) THEN
         RAISE exit_procedure_;
      END IF;
   $END

   IF (oldrec_.expected_leadtime != newrec_.expected_leadtime) THEN
      $IF (Component_Invpla_SYS.INSTALLED) $THEN
         Inventory_Part_Invpla_Info_API.Handle_Expect_Leadtime_Change(newrec_.contract,
                                                                      newrec_.part_no,
                                                                      oldrec_.expected_leadtime,
                                                                      newrec_.expected_leadtime );
      $ELSE
         NULL;
      $END
   END IF;

   planning_method_ := Get_Planning_Method___(newrec_.contract, newrec_.part_no);

   IF (planning_method_ != 'B') THEN
      RAISE exit_procedure_;
   END IF;

   new_status_rec_ := Inventory_Part_Status_Par_API.Get(newrec_.part_status);

   IF (newrec_.part_status = oldrec_.part_status) THEN
      old_status_rec_ := new_status_rec_;
   ELSE
      old_status_rec_ := Inventory_Part_Status_Par_API.Get(oldrec_.part_status);
   END IF;

   IF (((newrec_.stock_management = 'SYSTEM MANAGED INVENTORY') AND
        (new_status_rec_.onhand_flag = 'Y') AND
        (new_status_rec_.supply_flag = 'Y'))
       OR
       ((oldrec_.stock_management = 'SYSTEM MANAGED INVENTORY') AND
        (old_status_rec_.onhand_flag = 'Y') AND
        (old_status_rec_.supply_flag = 'Y'))) THEN
           
         $IF (Component_Invpla_SYS.INSTALLED) $THEN
            Inventory_Part_Invpla_Info_API.Set_Latest_Plan_Activity_Time(newrec_.contract, newrec_.part_no);
         $ELSE
            NULL;
         $END           
   END IF;

   IF (((newrec_.stock_management = 'SYSTEM MANAGED INVENTORY') AND
        (new_status_rec_.onhand_flag = 'Y') AND
        (new_status_rec_.supply_flag = 'Y'))
       AND
       ((oldrec_.stock_management != 'SYSTEM MANAGED INVENTORY') OR
        (old_status_rec_.onhand_flag != 'Y') OR
        (old_status_rec_.supply_flag != 'Y'))) THEN
           
      $IF (Component_Invpla_SYS.INSTALLED) $THEN
         Inventory_Part_Invpla_Info_API.Refresh_Unit_Cost_Snapshot(newrec_.contract, newrec_.part_no);
      $ELSE
         NULL;   
      $END      
   END IF;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Handle_Planning_Attr_Change___;


FUNCTION Get_Planning_Method___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Inventory_Part_Planning_API.Get_Planning_Method(contract_, part_no_);
END Get_Planning_Method___;


PROCEDURE Check_Supersedes___ (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   supersedes_   IN VARCHAR2,
   part_status_  IN VARCHAR2 )
IS
   dummy_        inventory_part_tab.part_no%TYPE;

   CURSOR get_supersedes_data IS
      SELECT part_no 
      FROM inventory_part_tab
      WHERE contract = contract_
      AND   supersedes = supersedes_
      AND   part_no != part_no_;
BEGIN
   IF (supersedes_ IS NOT NULL) THEN
      IF (part_no_ = supersedes_) THEN
         Error_SYS.Record_General(lu_name_, 'PARTREPLACE: This part cannot replace itself.');
      END IF;

      -- Check part status of the current part
      IF (Inventory_Part_Status_Par_API.Get_Supply_Flag_Db(Get_Part_Status(contract_, supersedes_)) = 'Y') THEN
         Error_SYS.Record_General(lu_name_, 'WRONGPARTSTATUS: Supply status of part :P1 being replaced must be Supplies Not Allowed.', supersedes_);
      END IF;
   
      -- Check part status of the current part
      IF (Inventory_Part_Status_Par_API.Get_Supply_Flag_Db(part_status_) = 'N') THEN
         Error_SYS.Record_General(lu_name_, 'WRONGPARTSTATUS2: Supply status of replacing part :P1 must be Supplies Allowed.', part_no_);
      END IF;
   
      -- Check for a part being replaced by multiple parts
      OPEN get_supersedes_data;
      FETCH get_supersedes_data INTO dummy_;
      IF get_supersedes_data%FOUND THEN
         CLOSE get_supersedes_data;
         Error_SYS.Record_General(lu_name_, 'MULTIPLEREPLACEMENTS: Part :P1 has already been replaced by :P2 and cannot be replaced by more than one part at a time.', supersedes_, dummy_);
      END IF;
      CLOSE get_supersedes_data;
   END IF;
END Check_Supersedes___;


PROCEDURE Handle_Part_Status_Change___ (
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   old_part_status_ IN VARCHAR2,
   new_part_status_ IN VARCHAR2 )
IS
   total_demand_     NUMBER;
   total_supply_     NUMBER;
   starting_balance_ NUMBER; 
BEGIN
   IF (Inventory_Part_Status_Par_API.Get_Supply_Flag_Db(new_part_status_)= 'N') THEN
      total_demand_ := Order_Supply_Demand_API.Get_Total_Demand(contract_         => contract_,
                                                                part_no_          => part_no_,
                                                                configuration_id_ => NULL,
                                                                include_standard_ => 'TRUE',
                                                                include_project_  => 'TRUE',
                                                                project_id_       => NULL,
                                                                activity_seq_     => NULL,
                                                                date_required_    => NULL,
                                                                source_           => 'CUSTORD_SUPPLY_DEMAND',
                                                                exclude_reserved_ => 'TRUE');

      IF (total_demand_ > 0) THEN
         total_supply_ := Order_Supply_Demand_API.Get_Total_Supply(contract_         => contract_,
                                                                   part_no_          => part_no_,
                                                                   configuration_id_ => NULL,
                                                                   include_standard_ => 'TRUE',
                                                                   include_project_  => 'TRUE',
                                                                   project_id_       => NULL,
                                                                   activity_seq_     => NULL,
                                                                   date_required_    => NULL,
                                                                   source_           => 'CUSTORD_SUPPLY_DEMAND'); 
         IF (total_demand_ > total_supply_) THEN
            starting_balance_ := Inventory_Part_In_Stock_API.Get_Starting_Balance(contract_            => contract_, 
                                                                                  part_no_             => part_no_,
                                                                                  configuration_id_    => NULL, 
                                                                                  include_standard_    => 'TRUE',                                                                               
                                                                                  include_project_     => 'TRUE',
                                                                                  project_id_          => NULL,
                                                                                  activity_seq_        => NULL,
                                                                                  include_floor_stock_ => 'TRUE');    
            IF (total_demand_ > (total_supply_ + starting_balance_)) THEN
               Client_SYS.Add_Info(lu_name_, 'DEMANDEXCEEDSQTY: The sum of the quantity on hand and the supplies does not cover the demands.');
            END IF;
         END IF;
      END IF;
   END IF;
END Handle_Part_Status_Change___;


-- Company_Owned_Stock_Exists___
--   This function will check whether there are any Company Owned Stock for a given part.
FUNCTION Company_Owned_Stock_Exists___(
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Invent_Part_Quantity_Util_API.Check_Quantity_Exist(contract_                      => contract_,
                                                             part_no_                       => part_no_,
                                                             configuration_id_              => NULL,
                                                             exclude_customer_owned_stock_  => 'TRUE',                                                                 
                                                             exclude_supplier_loaned_stock_ => 'TRUE',
                                                             exclude_supplier_owned_stock_  => 'TRUE',
                                                             exclude_supplier_rented_stock_ => 'TRUE',
                                                             exclude_company_rental_stock_  => 'TRUE');
END Company_Owned_Stock_Exists___;


-- Get_Updated_Control_Type___
--   This function will return a currently used control type if modified.
FUNCTION Get_Updated_Control_Type___ (
   oldrec_            IN inventory_part_tab%ROWTYPE,
   newrec_            IN inventory_part_tab%ROWTYPE,
   check_only_active_ IN BOOLEAN,
   company_           IN VARCHAR2 ) RETURN VARCHAR2
IS
   updated_control_type_ VARCHAR2(3);
   today_                DATE;
   c32_                  CONSTANT VARCHAR2(3) := 'C32';
   c50_                  CONSTANT VARCHAR2(3) := 'C50';
   c49_                  CONSTANT VARCHAR2(3) := 'C49';
   c12_                  CONSTANT VARCHAR2(3) := 'C12';
   c10_                  CONSTANT VARCHAR2(3) := 'C10';
   c9_                   CONSTANT VARCHAR2(2) := 'C9';
   c6_                   CONSTANT VARCHAR2(3) := 'C6';
   c7_                   CONSTANT VARCHAR2(3) := 'C7';
   c8_                   CONSTANT VARCHAR2(3) := 'C8';
   m1_                   CONSTANT VARCHAR2(2) := 'M1';
   m3_                   CONSTANT VARCHAR2(2) := 'M3';
BEGIN                                    

   IF (check_only_active_) THEN
      today_ := TRUNC(Site_API.Get_Site_Date(newrec_.contract));
   END IF;

   IF ((NVL(newrec_.accounting_group, Database_SYS.string_null_)) != 
       (NVL(oldrec_.accounting_group, Database_SYS.string_null_))) THEN
      IF (check_only_active_) THEN
         IF ((Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m1_,c32_,today_)) OR 
             (Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m3_,c32_,today_))) THEN
            updated_control_type_ := c32_;
         END IF;
      ELSE
         updated_control_type_ := c32_;
      END IF;
   END IF;

   IF (updated_control_type_ IS NULL) THEN
      IF ((NVL(newrec_.asset_class, Database_SYS.string_null_)) != 
          (NVL(oldrec_.asset_class, Database_SYS.string_null_))) THEN
         IF (check_only_active_) THEN
            IF ((Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m1_,c9_,today_)) OR 
                (Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m3_,c9_,today_))) THEN
               updated_control_type_ := c9_;
            END IF;
         ELSE
            updated_control_type_ := c9_;
         END IF;
      END IF;
   END IF;

   IF (updated_control_type_ IS NULL) THEN
      IF ((NVL(newrec_.part_product_code, Database_SYS.string_null_)) != 
          (NVL(oldrec_.part_product_code, Database_SYS.string_null_))) THEN
         IF (check_only_active_) THEN
            IF ((Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m1_,c50_,today_)) OR 
                (Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m3_,c50_,today_))) THEN
               updated_control_type_ := c50_;
            END IF;
         ELSE
            updated_control_type_ := c50_;
         END IF;
      END IF;
   END IF;

   IF (updated_control_type_ IS NULL) THEN
      IF ((NVL(newrec_.part_product_family, Database_SYS.string_null_)) != 
          (NVL(oldrec_.part_product_family, Database_SYS.string_null_))) THEN
         IF (check_only_active_) THEN
            IF ((Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m1_,c49_,today_)) OR 
                (Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m3_,c49_,today_))) THEN
               updated_control_type_ := c49_;
            END IF;
         ELSE
            updated_control_type_ := c49_;
         END IF;
      END IF;
   END IF;

   IF (updated_control_type_ IS NULL) THEN
      IF ((NVL(newrec_.planner_buyer, Database_SYS.string_null_)) != 
          (NVL(oldrec_.planner_buyer, Database_SYS.string_null_))) THEN
         IF (check_only_active_) THEN
            IF ((Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m1_,c12_,today_)) OR 
                (Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m3_,c12_,today_))) THEN
               updated_control_type_ := c12_;
            END IF;
         ELSE
            updated_control_type_ := c12_;
         END IF;
      END IF;
   END IF;

   IF (updated_control_type_ IS NULL) THEN
      IF ((NVL(newrec_.abc_class, Database_SYS.string_null_)) != 
          (NVL(oldrec_.abc_class, Database_SYS.string_null_))) THEN
         IF (check_only_active_) THEN
            IF ((Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m1_,c10_,today_)) OR 
                (Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m3_,c10_,today_))) THEN
               updated_control_type_ := c10_;
            END IF;
         ELSE
            updated_control_type_ := c10_;
         END IF;
      END IF;
   END IF;

   IF (updated_control_type_ IS NULL) THEN
      IF ((NVL(newrec_.type_code, Database_SYS.string_null_)) != 
          (NVL(oldrec_.type_code, Database_SYS.string_null_))) THEN
         IF (check_only_active_) THEN
            IF ((Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m1_,c6_,today_)) OR 
                (Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m3_,c6_,today_))) THEN
               updated_control_type_ := c6_;
            END IF;
         ELSE
            updated_control_type_ := c6_;
         END IF;
      END IF;
   END IF;

   IF (updated_control_type_ IS NULL) THEN
      IF ((NVL(newrec_.prime_commodity, Database_SYS.string_null_)) != 
          (NVL(oldrec_.prime_commodity, Database_SYS.string_null_))) THEN
         IF (check_only_active_) THEN
            IF ((Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m1_,c7_,today_)) OR 
                (Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m3_,c7_,today_))) THEN
               updated_control_type_ := c7_;
            END IF;
         ELSE
            updated_control_type_ := c7_;
         END IF;
      END IF;
   END IF;

   IF (updated_control_type_ IS NULL) THEN
      IF ((NVL(newrec_.second_commodity, Database_SYS.string_null_)) != 
          (NVL(oldrec_.second_commodity, Database_SYS.string_null_))) THEN
         IF (check_only_active_) THEN
            IF ((Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m1_,c8_,today_)) OR 
                (Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,m3_,c8_,today_))) THEN
               updated_control_type_ := c8_;
            END IF;
         ELSE
            updated_control_type_ := c8_;
         END IF;
      END IF;
   END IF;

   RETURN (updated_control_type_);
END Get_Updated_Control_Type___;


PROCEDURE Check_Standard_Putaway_Qty___(
   standard_putaway_qty_ IN NUMBER )
IS
BEGIN

   IF (standard_putaway_qty_ <= 0) THEN
      Error_SYS.Record_General('InventoryPart','STDPUTAWAYQTY: Standard putaway qty must be greater than zero.');
   END IF;
END Check_Standard_Putaway_Qty___;


-- Check_Intrastat_And_Customs___
--   This procedure will validate the customs_Stat_No and intrastat_conv_factor.
PROCEDURE Check_Intrastat_And_Customs___ (
   customs_stat_no_       IN VARCHAR2,
   intrastat_conv_factor_ IN NUMBER )
IS
   customs_unit_meas_ VARCHAR2(10);
BEGIN

   IF (customs_stat_no_ IS NOT NULL) THEN
      customs_unit_meas_ := Customs_Statistics_Number_API.Get_Customs_Unit_Meas(customs_stat_no_);
   END IF;
      
   IF (customs_unit_meas_ IS NULL) THEN
      IF (intrastat_conv_factor_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOINTRA1: Intrastat conversion factor cannot have a value if the customs statistics number does not have a unit of measure.');
      END IF;
   ELSE
      IF (intrastat_conv_factor_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOINTRA: Intrastat conversion factor must have a value when the customs statistics number has a defined customs unit of measure.');
      END IF;
   END IF;

   IF (intrastat_conv_factor_ <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'INTRACONVGREATER0: The Intrastat conversion factor must be greater than zero.');
   END IF;
   
END Check_Intrastat_And_Customs___;


-- Get_Stop_Analysis_Date___
--   The method uses the expected lead time for the inventory part and
--   also uses the Shop Calendar. It returns the date of the actual
--   workday that is the first workday beyond the lead time span based
--   on today's date
FUNCTION Get_Stop_Analysis_Date___ (
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   site_date_                   IN DATE,
   dist_calendar_id_            IN VARCHAR2,
   manuf_calendar_id_           IN VARCHAR2,
   detect_supplies_not_allowed_ IN BOOLEAN,
   use_expected_leadtime_       IN BOOLEAN,
   lead_time_code_db_           IN VARCHAR2 ) RETURN DATE
IS
   stop_analysis_date_          DATE;
   earliest_stop_analysis_date_ DATE;
   manuf_leadtime_              inventory_part_tab.manuf_leadtime%TYPE;
   purch_leadtime_              inventory_part_tab.purch_leadtime%TYPE;
BEGIN

   Update_Cache___(contract_, part_no_);

   IF (use_expected_leadtime_) THEN
      manuf_leadtime_ := micro_cache_value_.expected_leadtime; 
      purch_leadtime_ := micro_cache_value_.expected_leadtime; 
   ELSE
      manuf_leadtime_ := micro_cache_value_.manuf_leadtime; 
      purch_leadtime_ := micro_cache_value_.purch_leadtime; 
   END IF;

   IF (micro_cache_value_.earliest_ultd_supply_date IS NOT NULL) THEN
      earliest_stop_analysis_date_ := Work_Time_Calendar_API.Get_Previous_Work_Day(dist_calendar_id_,
                                                                                   micro_cache_value_.earliest_ultd_supply_date);
   END IF;

   IF ((detect_supplies_not_allowed_) AND
       (Inventory_Part_Status_Par_API.Get_Supply_Flag_Db(micro_cache_value_.part_status) =
                                                          Inventory_Part_Supply_Flag_API.DB_SUPPLIES_NOT_ALLOWED)) THEN
      -- Setting a stop analys date that indicates an "infinite" leadtime.
      -- The "minus 1" is because calling methods sometimes adds one day to the returned
      -- date and that causes an error.
      stop_analysis_date_ := Database_SYS.last_calendar_date_ -1;
   ELSE
      IF (lead_time_code_db_ = Inv_Part_Lead_Time_Code_API.DB_PURCHASED) THEN
         -- Purchased
         stop_analysis_date_ := trunc(site_date_) + purch_leadtime_;
         stop_analysis_date_ := GREATEST(stop_analysis_date_, NVL(earliest_stop_analysis_date_, stop_analysis_date_));
         -- The same method as Get_Closest_Work_Day but without internal error handling.
         stop_analysis_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day (dist_calendar_id_, stop_analysis_date_);
      ELSE
         -- Manufactured
         stop_analysis_date_ := Work_Time_Calendar_API.Get_End_Date(manuf_calendar_id_,
                                                                    site_date_,
                                                                    manuf_leadtime_);
      END IF;
   END IF;

   RETURN stop_analysis_date_;
END Get_Stop_Analysis_Date___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   asset_class_ VARCHAR2(240);
   contract_    INVENTORY_PART.contract%TYPE;

BEGIN
   contract_ := USER_ALLOWED_SITE_API.Get_Default_Site;
   super(attr_);
   Client_SYS.Add_To_Attr('PART_STATUS', Inventory_Part_Status_Par_API.Get_Default_Status, attr_);
   Client_SYS.Add_To_Attr('CONTRACT',contract_,attr_);

   asset_class_ := Mpccom_Defaults_API.Get_Char_Value('*','PART_DESCRIPTION','ASSET_CLASS');
   Client_SYS.Add_To_Attr('ASSET_CLASS', asset_class_, attr_);
   Client_SYS.Add_To_Attr('STOCK_MANAGEMENT_DB', 'SYSTEM MANAGED INVENTORY', attr_);
   Client_SYS.Add_To_Attr('DOP_CONNECTION', Dop_Connection_API.Decode('AUT'), attr_);
   Client_SYS.Add_To_Attr('DOP_NETTING', Dop_Netting_API.Decode('NONET'), attr_);
   Client_SYS.Add_To_Attr('PLANNER_BUYER', User_Default_API.Get_Planner_Id(Fnd_Session_API.Get_Fnd_User), attr_);
   Client_SYS.Add_To_Attr('MANDATORY_EXPIRATION_DATE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('EXCL_SHIP_PACK_PROPOSAL_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   ----------------------------------------
   -- Set default values for maintenance
   ----------------------------------------
   Client_SYS.Add_To_Attr('CYCLE_PERIOD', 0, attr_);
   Client_SYS.Add_To_Attr('CYCLE_CODE_DB', 'N', attr_);

   Client_SYS.Add_To_Attr('MANUF_LEADTIME', 0, attr_);
   Client_SYS.Add_To_Attr('PURCH_LEADTIME', 0, attr_);
   Client_SYS.Add_To_Attr('EXPECTED_LEADTIME', 0, attr_);
   Client_SYS.Add_To_Attr('SUPPLY_CODE', Material_Requis_Supply_API.Decode('IO'),attr_);
   Client_SYS.Add_To_Attr('TYPE_CODE', Inventory_Part_Type_API.Decode('4'), attr_);
   Client_SYS.Add_To_Attr('ZERO_COST_FLAG', Inventory_Part_Zero_Cost_API.Decode('N'),attr_);
   Client_SYS.Add_To_Attr('LEAD_TIME_CODE', Inv_Part_Lead_Time_Code_API.Decode('P'), attr_);
   Client_SYS.Add_To_Attr('AVAIL_ACTIVITY_STATUS', Inventory_Part_Avail_Stat_API.Decode('CHANGED'),attr_);
   ----------------------------------------
   -- Set default values for costing
   ----------------------------------------
   Client_SYS.Add_To_Attr('ESTIMATED_MATERIAL_COST', 0, attr_);

   Client_SYS.Add_To_Attr('MIN_DURAB_DAYS_CO_DELIV', 0, attr_);
   Client_SYS.Add_To_Attr('MIN_DURAB_DAYS_PLANNING', 0, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_                OUT    VARCHAR2,
   objversion_           OUT    VARCHAR2,
   newrec_               IN OUT inventory_part_tab%ROWTYPE,
   attr_                 IN OUT VARCHAR2,
   create_purchase_part_ IN     VARCHAR2 DEFAULT 'TRUE',
   create_part_planning_ IN     VARCHAR2 DEFAULT 'TRUE')
IS
   inventory_flag_               VARCHAR2(20);
   site_date_                    DATE;   
   exist_                        NUMBER;
   new_estimated_material_cost_  NUMBER;
BEGIN

   newrec_.note_id            := Document_Text_API.Get_Next_Note_Id;
   site_date_                 := Site_API.Get_Site_Date(newrec_.contract);
   newrec_.create_date        := trunc(site_date_);
   newrec_.last_activity_date := trunc(site_date_);
   IF (newrec_.abc_class IS NULL) THEN
      newrec_.abc_class          := 'C';
   END IF;
   IF (newrec_.lifecycle_stage IS NULL) THEN
      newrec_.lifecycle_stage    := 'DEVELOPMENT';
   END IF;
   IF (newrec_.frequency_class IS NULL) THEN
      newrec_.frequency_class    := Inv_Part_Frequency_Class_API.DB_VERY_SLOW_MOVER;
   END IF;
   IF (newrec_.invoice_consideration = 'PERIODIC WEIGHTED AVERAGE') THEN
      newrec_.actual_cost_activated := Inventory_Transaction_Hist_API.Get_Last_Transaction_For_Part(newrec_.contract, newrec_.part_no);
   END IF;
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (newrec_.technical_coordinator_id IS NULL) THEN
         IF (Purchase_Part_API.Check_Exist(newrec_.contract, newrec_.part_no) = 1) THEN
             newrec_.technical_coordinator_id := Purchase_Part_API.Get_Technical_Coordinator_ID(newrec_.contract, newrec_.part_no);
         END IF;    
      END IF;
   $END
   
   IF newrec_.lead_time_code = 'P' THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN 
         exist_ := Purchase_Part_API.Check_Exist(newrec_.contract, newrec_.part_no);
         IF (exist_ = 1) THEN
            newrec_.technical_coordinator_id := Purchase_Part_API.Get_Technical_Coordinator_ID(newrec_.contract, newrec_.part_no);          
        END IF;       
      $ELSE
         NULL;
      $END
   END IF;

   IF newrec_.storage_volume_requirement IS NOT NULL THEN
      newrec_.storage_width_requirement  := NVL(newrec_.storage_width_requirement, 0);
      newrec_.storage_height_requirement := NVL(newrec_.storage_height_requirement, 0);
      newrec_.storage_depth_requirement  := NVL(newrec_.storage_depth_requirement, 0);
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);
   
   -- Moved this code block right before calling Inventory_Part_Config_API.NEW()
   $IF (Component_Cost_SYS.INSTALLED) $THEN
       Cost_Set_API.Create_Part_Cost(newrec_.contract, newrec_.part_no, newrec_.lead_time_code);
   $END   
   
   new_estimated_material_cost_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ESTIMATED_MATERIAL_COST', attr_));   
   Inventory_Part_Config_API.NEW(newrec_.contract,
                                 newrec_.part_no,
                                 '*',
                                 new_estimated_material_cost_);
                                 
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
      FOR config_rec_ IN Configuration_Spec_API.Get_Valid_Configuration_Id(newrec_.part_no) LOOP
          IF NOT Inventory_Part_Config_API.Check_Exist(newrec_.contract, newrec_.part_no, config_rec_.configuration_id) THEN
             Inventory_Part_Config_API.NEW(newrec_.contract, newrec_.part_no, config_rec_.configuration_id,0);
          END IF;
      END LOOP;
   $END   
 
   IF (create_part_planning_ = 'TRUE') THEN
      Inventory_Part_Planning_API.Create_New_Part_Planning(newrec_.contract, newrec_.part_no);

   END IF;
   
   $IF (Component_Purch_SYS.INSTALLED) $THEN     
      exist_ := Purchase_Part_API.Check_Exist(newrec_.contract, newrec_.part_no);
      IF (exist_ = 1) THEN
         inventory_flag_ := Inventory_Flag_API.Decode('Y');
         Purchase_Part_API.Set_Inventory_Flag(newrec_.contract,  newrec_.part_no, inventory_flag_);      
      ELSE
         IF newrec_.lead_time_code = 'P' THEN
            IF (create_purchase_part_ = 'TRUE') THEN
               Purchase_Part_API.New(newrec_.contract, newrec_.part_no, newrec_.description, newrec_.unit_meas);               
            END IF;
         END IF;
      END IF;     
   $END  
   
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      Part_Revision_API.Create_First_Part_Rev(newrec_.contract, newrec_.part_no);
   $END
   
   $IF (Component_Ecoman_SYS.INSTALLED) $THEN
      -- Create inv part emission head, should exist for all parts
      Inv_Part_Emission_Head_API.Create_If_Not_Exist(newrec_.contract, newrec_.part_no, '1', '*', '*');
   $END
   
   IF newrec_.part_cost_group_id IS NOT NULL THEN
      $IF (Component_Cost_SYS.INSTALLED) $THEN
         Part_Cost_API.Changed_Group_Id(newrec_.contract, newrec_.part_no, newrec_.part_cost_group_id);
      $ELSE
         NULL;
      $END
   END IF;

   IF newrec_.cust_warranty_id IS NOT NULL THEN
      Cust_Warranty_API.Inherit(newrec_.cust_warranty_id);
   END IF;

   IF newrec_.sup_warranty_id IS NOT NULL THEN
      Sup_Warranty_API.Inherit(newrec_.sup_warranty_id);
   END IF;

   -- Update Chemmate
   IF (Part_Catalog_Invent_Attrib_API.Get_Hse_Contract(newrec_.part_no) = newrec_.contract) THEN
      Pack_And_Post_Message__('ADDEDIT', newrec_.part_no, newrec_.contract);
   END IF;

   IF (newrec_.invoice_consideration = 'PERIODIC WEIGHTED AVERAGE') THEN
      IF (Site_Invent_Info_API.Get_Last_Actual_Cost_Calc(newrec_.contract) IS NULL) THEN
         Site_Invent_Info_API.Set_Last_Actual_Cost_Calc(newrec_.contract, site_date_);
      END IF;
   END IF;
   
   $IF (Component_Quaman_SYS.INSTALLED) $THEN
      Qman_Mandatory_Part_API.Insert_From_Invent(newrec_.part_no, newrec_.contract, newrec_.type_code);
   $END 
   
   -- These checks needs to be performed after storing the record
   -- because they are using the method for fetching the operative
   -- values which read the database.
   Check_Temperature_Range(newrec_.part_no, newrec_.contract);
   Check_Humidity_Range(newrec_.part_no, newrec_.contract);
    
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_, 'DUPLPART: Inventory part :P1 already exists on site :P2.',newrec_.part_no, newrec_.contract);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_             IN     VARCHAR2,
   oldrec_            IN     inventory_part_tab%ROWTYPE,
   newrec_            IN OUT inventory_part_tab%ROWTYPE,
   attr_              IN OUT VARCHAR2,
   objversion_        IN OUT VARCHAR2,
   by_keys_           IN     BOOLEAN DEFAULT FALSE )
IS
   site_date_                    DATE;   
   num_null_                     NUMBER       := -99999;
   str_null_                     VARCHAR2(11) := Database_SYS.string_null_;
   new_estimated_material_cost_  NUMBER;
BEGIN
   site_date_                        := Site_API.Get_Site_Date(newrec_.contract);
   newrec_.last_activity_date        := trunc(site_date_);
   newrec_.earliest_ultd_supply_date := trunc(newrec_.earliest_ultd_supply_date);

   IF (newrec_.purch_leadtime != oldrec_.purch_leadtime) THEN
      newrec_.avail_activity_status := 'CHANGED';
   END IF;

   IF (oldrec_.lead_time_code = 'P' AND newrec_.lead_time_code = 'M') THEN
      newrec_.stock_management := 'SYSTEM MANAGED INVENTORY';
   END IF;

   IF (newrec_.invoice_consideration != oldrec_.invoice_consideration) THEN
      IF (newrec_.invoice_consideration = 'PERIODIC WEIGHTED AVERAGE') THEN
         -- Activate Periodic Weighted Average.
         newrec_.actual_cost_activated := Inventory_Transaction_Hist_API.Get_Last_Transaction_For_Part(newrec_.contract, newrec_.part_no);
      ELSE
         -- Deactivate Periodic Weighted Average.
         newrec_.actual_cost_activated := NULL;
      END IF;
   END IF;

   IF newrec_.storage_volume_requirement IS NOT NULL THEN
      IF Part_Catalog_Invent_Attrib_API.Get_Storage_Width_Requirement(newrec_.part_no) IS NULL AND
          newrec_.storage_width_requirement IS NULL THEN
         newrec_.storage_width_requirement := 0;
      END IF;
      IF Part_Catalog_Invent_Attrib_API.Get_Storage_Height_Requirement(newrec_.part_no) IS NULL AND
          newrec_.storage_height_requirement IS NULL THEN
         newrec_.storage_height_requirement := 0;
      END IF;
      IF Part_Catalog_Invent_Attrib_API.Get_Storage_Depth_Requirement(newrec_.part_no) IS NULL AND
          newrec_.storage_depth_requirement IS NULL THEN
         newrec_.storage_depth_requirement := 0;
      END IF;
   END IF;
   
   IF (Validate_SYS.Is_Changed(oldrec_.lifecycle_stage, newrec_.lifecycle_stage)) THEN    
      IF (newrec_.lifecycle_stage = Inv_Part_Lifecycle_Stage_API.DB_DECLINE) THEN
         newrec_.decline_date := trunc(site_date_);
         newrec_.expired_date := NULL;
         newrec_.expired_issue_counter := NULL;
      ELSIF (newrec_.lifecycle_stage = Inv_Part_Lifecycle_Stage_API.DB_EXPIRED)THEN
         newrec_.expired_date := trunc(site_date_);
         newrec_.decline_date := NULL;
         newrec_.decline_issue_counter := NULL;
      ELSE
         newrec_.decline_date := NULL;
         newrec_.expired_date := NULL;
         newrec_.decline_issue_counter := NULL;
         newrec_.expired_issue_counter := NULL;
      END IF;
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   new_estimated_material_cost_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ESTIMATED_MATERIAL_COST', attr_));
   -------------------------------------------------------------
   --  The call to method Modify_Estimated_Material_Cost      --
   --  below must NOT under any circumstances be moved above  --
   --  the UPDATE statements for table INVENTORY_PART_TAB.    --
   --  That would lead to fatal database inconsistency.       --
   -------------------------------------------------------------
   Inventory_Part_Config_API.Modify_Estimated_Material_Cost(
                             newrec_.contract,
                             newrec_.part_no,
                             '*',
                             new_estimated_material_cost_);

   IF (nvl(newrec_.part_cost_group_id,'NOTNULL') != nvl(oldrec_.part_cost_group_id,'NOTNULL')) THEN    
      $IF (Component_Cost_SYS.INSTALLED) $THEN
         Part_Cost_API.Changed_Group_Id(newrec_.contract, newrec_.part_no, newrec_.part_cost_group_id);
      $ELSE
         NULL;
      $END   
   END IF;

   IF ( newrec_.type_code != oldrec_.type_code ) THEN
      IF (Split_Manuf_Acquired_API.Encode(Inventory_Part_Planning_API.Get_Split_Manuf_Acquired(newrec_.contract, newrec_.part_no)) = 'NO_SPLIT') THEN
         Inventory_Part_Planning_API.Modify_Manuf_Acq_Percent(newrec_.contract,
                                                              newrec_.part_no,
                                                              newrec_.type_code);
      END IF;
      
      $IF Component_Mfgstd_SYS.INSTALLED $THEN
         Manuf_Structure_Util_API.Handle_Type_Code_Change(newrec_.contract,
                                                          newrec_.part_no,
                                                          newrec_.type_code,
                                                          oldrec_.type_code);

      $END
 
      $IF Component_Expctr_SYS.INSTALLED $THEN
         Exp_License_Connect_Util_API.Handle_Type_Code_Change(newrec_.part_no);
      $END
   END IF;

   IF (newrec_.lead_time_code != oldrec_.lead_time_code) THEN      
      $IF (Component_Cost_SYS.INSTALLED) $THEN
         Cost_Int_API.New_Lead_Time_Code(newrec_.contract, newrec_.part_no, newrec_.lead_time_code);
      $ELSE
         NULL;
      $END  

      $IF (Component_Purch_SYS.INSTALLED) $THEN
         Purchase_Part_API.Handle_Lead_Time_Code_Change(newrec_.contract,
                                                        newrec_.part_no,
                                                        newrec_.lead_time_code,
                                                        newrec_.description,
                                                        newrec_.unit_meas);
      $ELSE
         NULL;
      $END        
   END IF;

   IF (newrec_.invoice_consideration != oldrec_.invoice_consideration) THEN
      IF (newrec_.invoice_consideration = 'PERIODIC WEIGHTED AVERAGE') THEN
         IF (Site_Invent_Info_API.Get_Last_Actual_Cost_Calc(newrec_.contract) IS NULL) THEN
            Site_Invent_Info_API.Set_Last_Actual_Cost_Calc(newrec_.contract, site_date_);
         END IF;
      END IF;
   END IF;

   IF (newrec_.inventory_part_cost_level != oldrec_.inventory_part_cost_level) THEN
      Inventory_Part_Unit_Cost_API.Handle_Part_Cost_Level_Change(newrec_.contract,
                                                                 newrec_.part_no,
                                                                 oldrec_.inventory_part_cost_level,
                                                                 newrec_.inventory_part_cost_level);
   END IF;

   IF (newrec_.inventory_valuation_method != oldrec_.inventory_valuation_method) THEN
      Inventory_Part_Unit_Cost_API.Handle_Valuation_Method_Change(newrec_.contract,
                                                                  newrec_.part_no,
                                                                  newrec_.inventory_part_cost_level,
                                                                  oldrec_.inventory_valuation_method,
                                                                  newrec_.inventory_valuation_method);
   END IF;
   
   $IF (Component_Order_SYS.INSTALLED) $THEN   
      IF (nvl(newrec_.customs_stat_no, CHR(2)) != nvl(oldrec_.customs_stat_no, CHR(2)) OR nvl(newrec_.intrastat_conv_factor, 0) != nvl(oldrec_.intrastat_conv_factor, 0)) THEN
         Sales_Part_API.Modify_Intrastat_And_Customs(newrec_.contract, newrec_.part_no, newrec_.customs_stat_no, newrec_.intrastat_conv_factor);
      END IF;
   $END

   -- Update Chemmate and doc reference
   IF ((newrec_.description != oldrec_.description) AND
      (Site_Invent_Info_API.Get_Use_Partca_Desc_Invent_Db(newrec_.contract) = 'FALSE'))THEN
      Handle_Description_Change___(newrec_.contract, newrec_.part_no);
   END IF;

   IF ((NVL(newrec_.prime_commodity,  str_null_) != NVL(oldrec_.prime_commodity,  str_null_)) OR
       (NVL(newrec_.second_commodity, str_null_) != NVL(oldrec_.second_commodity, str_null_)) OR
       (NVL(newrec_.durability_day,   num_null_) != NVL(oldrec_.durability_day,   num_null_)) OR
       (    newrec_.asset_class                  !=     oldrec_.asset_class                 ) OR
       (    newrec_.abc_class                    !=     oldrec_.abc_class                   ) OR
       (    newrec_.frequency_class              !=     oldrec_.frequency_class             ) OR
       (    newrec_.lifecycle_stage              !=     oldrec_.lifecycle_stage             ) OR
       (    newrec_.qty_calc_rounding            !=     oldrec_.qty_calc_rounding           ) OR
       (    newrec_.part_status                  !=     oldrec_.part_status                 ) OR
       (    newrec_.stock_management             !=     oldrec_.stock_management            ) OR
       (    newrec_.expected_leadtime            !=     oldrec_.expected_leadtime           )) THEN
      Handle_Planning_Attr_Change___(newrec_, oldrec_);
   END IF;
   
   IF (newrec_.part_status != oldrec_.part_status) THEN
      Handle_Part_Status_Change___(newrec_.contract,
                                   newrec_.part_no,
                                   oldrec_.part_status,
                                   newrec_.part_status);
   END IF;
   
   IF ((NVL(newrec_.min_storage_temperature, num_null_) != NVL(oldrec_.min_storage_temperature, num_null_)) OR
       (NVL(newrec_.max_storage_temperature, num_null_) != NVL(oldrec_.max_storage_temperature, num_null_))) THEN
      -- These checks needs to be performed after updating the record
      -- because it uses Get_Min_Storage_Temperature and Get_Max_Storage_Temperature which reads the database.
      Check_Temperature_Range(newrec_.part_no, newrec_.contract);
   END IF;

   IF ((NVL(newrec_.min_storage_humidity, num_null_) != NVL(oldrec_.min_storage_humidity, num_null_)) OR
       (NVL(newrec_.max_storage_humidity, num_null_) != NVL(oldrec_.max_storage_humidity, num_null_))) THEN
      -- These checks needs to be performed after updating the record
      -- because it uses Get_Min_Storage_Humidity and Get_Max_Storage_Humidity which reads the database.
      Check_Humidity_Range(newrec_.part_no, newrec_.contract);
   END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     inventory_part_tab%ROWTYPE,
   newrec_ IN OUT inventory_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF ((newrec_.decline_issue_counter IS NOT NULL) AND 
       (newrec_.decline_issue_counter != ROUND(newrec_.decline_issue_counter)) AND 
       (newrec_.decline_issue_counter <= 0)) THEN
      Error_SYS.Record_General(lu_name_,'DECISSUECOUNT: Number of issues for decline must be a positive integer.');
   END IF;
   IF ((newrec_.expired_issue_counter IS NOT NULL) AND 
       (newrec_.expired_issue_counter != ROUND(newrec_.expired_issue_counter)) AND 
       (newrec_.expired_issue_counter <= 0)) THEN
      Error_SYS.Record_General(lu_name_,'EXPISSUECOUNT: Number of issues for expired must be a positive integer.');
   END IF;
END Check_Common___;




@Override
PROCEDURE Check_Delete___ (
   remrec_ IN inventory_part_tab%ROWTYPE )
IS
   part_exist_in_demand_site_ NUMBER := 0;

BEGIN
   IF (INSTR(remrec_.part_no, '^') > 0) OR (INSTR(remrec_.contract, '^') > 0) THEN
      Error_Sys.Record_General(lu_name_, 'INVALIDCHAR: Caret symbol is used in part no :P1 and/or on site :P2. Removal is not permitted.', remrec_.part_no, remrec_.contract);
   END IF;
   -- EBALL-37, Modified method call to use the fully encapsulated method from Invent_Part_Quantity_Util_API.
   IF (Invent_Part_Quantity_Util_API.Check_Quantity_Exist(remrec_.contract,
                                                          remrec_.part_no,
                                                          NULL)) THEN
      Error_Sys.Record_General(lu_name_, 'NOCOSTDEL: There are quantities in inventory for this part. Removal is not permitted');
   END IF;
   
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (Purchase_Part_Supplier_API.Is_Part_In_Demand_Site(remrec_.contract, remrec_.part_no, Supplier_API.Get_Vendor_No_From_Contract(remrec_.contract))  = 'TRUE') THEN
          part_exist_in_demand_site_ := 1;
      END IF;
      IF (part_exist_in_demand_site_ = 1)THEN
         Error_SYS.Record_General(lu_name_, 'NOPARTDEL: Inventory Part cannot be removed, Mult-site Planned Part exists in demand site(s)');
      END IF;
   $END

   $IF (Component_Callc_SYS.INSTALLED) $THEN
      Cc_Case_Business_Object_API.Check_Reference_Exist('INVENTORY_PART', remrec_.part_no, remrec_.contract );
      Cc_Case_Sol_Business_Obj_API.Check_Reference_Exist('INVENTORY_PART', remrec_.part_no, remrec_.contract );
   $END
   
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN inventory_part_tab%ROWTYPE )
IS
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF Purchase_Part_API.Check_Exist(remrec_.contract, remrec_.part_no) = 1 THEN
         Purchase_Part_API.Remove(remrec_.contract, remrec_.part_no);
      END IF;
   $END  
  
   super(objid_, remrec_);

   Document_Text_API.Remove_Note(remrec_.note_id);

   -- Update Chemmate
   IF (Part_Catalog_Invent_Attrib_API.Get_Hse_Contract(remrec_.part_no) = remrec_.contract) THEN
      Pack_And_Post_Message__('DELETE', remrec_.part_no, remrec_.contract);
   END IF;
   
   $IF (Component_Quaman_SYS.INSTALLED) $THEN
      Qman_Mandatory_Part_API.Remove_From_Invent(remrec_.part_no, remrec_.contract, remrec_.type_code);
   $END      
END Delete___;


-- Get_Default_Site_And_Uom___
--   Fetches the UoM and Site for the Part on either the user default site or if the user default
--   site dont have the part it will use the first available site where this part exist.
--   unit_category can be INVENT(default) or CATCH depending on which UoM you would like to use.
--   The Procedure is not declared because of pragma violation issues.
PROCEDURE Get_Default_Site_And_Uom___ (
   contract_      OUT VARCHAR2,
   unit_meas_     OUT VARCHAR2,
   part_no_       IN  VARCHAR2,
   unit_category_ IN  VARCHAR2 DEFAULT 'INVENT' )
IS
   part_rec_        inventory_part_tab%ROWTYPE;
   catch_unit_meas_ inventory_part_tab.catch_unit_meas%TYPE;

   CURSOR get_attr IS
      SELECT unit_meas, catch_unit_meas, contract
      FROM inventory_part_tab
      WHERE part_no = part_no_
      ORDER BY create_date;
BEGIN
   contract_ := User_Allowed_Site_API.Get_Default_Site();
   part_rec_  := Get_Object_By_Keys___(contract_,part_no_);

   IF (unit_category_ = 'INVENT' AND part_rec_.unit_meas IS NULL) OR
      (unit_category_ = 'CATCH' AND part_rec_.catch_unit_meas IS NULL) THEN
      -- fetch first available unit_meas and contract if this part dont exist on user default site
      OPEN get_attr;
      FETCH get_attr INTO unit_meas_, catch_unit_meas_, contract_;
      CLOSE get_attr;
      IF (unit_category_ = 'CATCH' AND catch_unit_meas_ IS NOT NULL) THEN
         unit_meas_ := catch_unit_meas_;
      ELSIF (unit_category_ = 'CATCH' AND catch_unit_meas_ IS NULL) THEN
         unit_meas_ := NULL;
      END IF;
   ELSIF (unit_category_ = 'INVENT' AND part_rec_.unit_meas IS NOT NULL) THEN
      unit_meas_ := part_rec_.unit_meas;
   ELSIF (unit_category_ = 'CATCH' AND part_rec_.catch_unit_meas IS NOT NULL) THEN
      unit_meas_ := part_rec_.catch_unit_meas;
   END IF;

   -- do not return UoM for catch unit if it is not enabled on Part Catalog
   IF (unit_category_ = 'CATCH') AND (Part_Catalog_API.Get_Catch_Unit_Enabled_Db(part_no_) = 'FALSE') THEN
      unit_meas_ := NULL;
   END IF;
END Get_Default_Site_And_Uom___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                         VARCHAR2(30);
   value_                        VARCHAR2(4000);
   unit_type_                    VARCHAR2(200);   
   part_catalog_rec_             Part_Catalog_API.Public_Rec;
   site_rec_                     Site_API.Public_Rec;
   country_code_                 VARCHAR2(3);
   noninv_sales_part_exist_      NUMBER;
   input_group_uom_              INPUT_UNIT_MEAS_GROUP_TAB.unit_code%TYPE;
   new_estimated_material_cost_  NUMBER;
   purchase_part_exist_          NUMBER;
   external_resource_db_         VARCHAR2(5);
   asset_class_rec_              Asset_Class_API.Public_Rec;
   site_invent_info_rec_ Site_Invent_info_API.Public_Rec; 
BEGIN
   IF (newrec_.asset_class IS NULL) THEN
      newrec_.asset_class := Mpccom_Defaults_API.Get_Char_Value('*','PART_DESCRIPTION','ASSET_CLASS');
      newrec_.automatic_capability_check := 'NO AUTOMATIC CAPABILITY CHECK';
   END IF;
   
   IF (newrec_.part_status IS NULL) THEN
      newrec_.part_status := Inventory_Part_Status_Par_API.Get_Default_Status();  
   END IF;   
   
   asset_class_rec_      := Asset_Class_API.Get(newrec_.asset_class);
   part_catalog_rec_     := Part_Catalog_API.Get(newrec_.part_no);
   site_invent_info_rec_ := Site_Invent_Info_API.Get(newrec_.contract);
   
   IF (NOT indrec_.shortage_flag) THEN 
      newrec_.shortage_flag              := asset_class_rec_.shortage_flag;
   END IF;
   IF (NOT indrec_.onhand_analysis_flag) THEN 
      newrec_.onhand_analysis_flag       := asset_class_rec_.onhand_analysis_flag;
   END IF;
   IF (NOT indrec_.co_reserve_onh_analys_flag) THEN 
      newrec_.co_reserve_onh_analys_flag := asset_class_rec_.co_reserve_onh_analys_flag;
   END IF;
   IF (NOT indrec_.oe_alloc_assign_flag) THEN
      newrec_.oe_alloc_assign_flag       := asset_class_rec_.oe_alloc_assign_flag;
   END IF;
   IF (NOT indrec_.forecast_consumption_flag) THEN
      newrec_.forecast_consumption_flag  := asset_class_rec_.forecast_consumption_flag;
   END IF;
   IF (NOT indrec_.automatic_capability_check) THEN
      newrec_.automatic_capability_check := asset_class_rec_.automatic_capability_check;
   END IF;
   IF (NOT indrec_.stock_management) THEN
      newrec_.stock_management  := 'SYSTEM MANAGED INVENTORY';
   END IF;
   IF (NOT indrec_.dop_connection) THEN
      newrec_.dop_connection    := 'MAN';
   END IF;
   IF (NOT indrec_.count_variance) THEN
      newrec_.count_variance    := 0;
   END IF;
   IF (NOT indrec_.cycle_code) THEN
      newrec_.cycle_code    := 'N';
   END IF;
   IF (NOT indrec_.cycle_period) THEN
      newrec_.cycle_period  := 0;
   END IF;
   IF (NOT indrec_.manuf_leadtime) THEN
      newrec_.manuf_leadtime := 0;
   END IF;
   IF (NOT indrec_.purch_leadtime) THEN
       newrec_.purch_leadtime := 0;
   END IF;
   IF (NOT indrec_.expected_leadtime) THEN
       newrec_.expected_leadtime := 0;
   END IF;
   IF (NOT indrec_.supply_code) THEN
       newrec_.supply_code := 'IO';
   END IF;
   IF (NOT indrec_.zero_cost_flag) THEN
       newrec_.zero_cost_flag := 'N';
   END IF;
   IF (NOT indrec_.lead_time_code) THEN
       newrec_.lead_time_code := 'P';
   END IF;
   IF (NOT indrec_.avail_activity_status) THEN
       newrec_.avail_activity_status := 'CHANGED';
   END IF;
   IF (NOT indrec_.invoice_consideration) THEN
       newrec_.invoice_consideration := site_invent_info_rec_.invoice_consideration;
   END IF;
   IF (NOT indrec_.inventory_part_cost_level) THEN
       newrec_.inventory_part_cost_level  := 'COST PER PART';
   END IF;
   IF (NOT indrec_.ext_service_cost_method) THEN
      newrec_.ext_service_cost_method := site_invent_info_rec_.ext_service_cost_method;
   END IF;
   IF (NOT indrec_.planner_buyer) THEN
      newrec_.planner_buyer := User_Default_API.Get_Planner_Id(Fnd_Session_API.Get_Fnd_User);
   END IF;
   IF (NOT indrec_.min_durab_days_co_deliv) THEN
      newrec_.min_durab_days_co_deliv := 0;
   END IF;
   IF (NOT indrec_.min_durab_days_planning) THEN
      newrec_.min_durab_days_planning := 0;
   END IF;
   IF (NOT indrec_.qty_calc_rounding) THEN
      newrec_.qty_calc_rounding := Site_Invent_Info_API.Get_Default_Qty_Calc_Round(newrec_.contract);
   END IF;
   
   IF (newrec_.type_code IS NULL)  THEN
      newrec_.type_code := '4';
   END IF; 
   
   IF (newrec_.reset_config_std_cost IS NULL) THEN
      newrec_.reset_config_std_cost := site_invent_info_rec_.reset_config_std_cost;
   END IF;
   
   IF (NOT indrec_.inventory_valuation_method) THEN   
      IF (newrec_.type_code IN ('1','2'))  THEN
         newrec_.inventory_valuation_method := site_invent_info_rec_.manuf_inv_value_method;
      ELSE
         newrec_.inventory_valuation_method := site_invent_info_rec_.purch_inv_value_method;
      END IF;
   END IF;
   
   IF (part_catalog_rec_.configurable = 'CONFIGURED') THEN
      IF (NOT indrec_.inventory_part_cost_level) THEN
         newrec_.inventory_part_cost_level := 'COST PER CONFIGURATION';
      END IF;
      IF (newrec_.inventory_valuation_method IN ('FIFO','LIFO')) THEN
         -- Inventory valuation methods FIFO and LIFO is not allowed for configured
         -- parts. Inventory valuation method will be set to Standard Cost instead.
         IF (NOT indrec_.inventory_valuation_method) THEN
            newrec_.inventory_valuation_method := 'ST';
         END IF;
      END IF;
   END IF;

   --When creating an Inventory Part for an existing catch unit handled part in Part Catalog or if the part is a tracked part
   --negative_on_hand should be NEG ONHAND NOT OK.
   IF (NOT indrec_.negative_on_hand) THEN 
      IF ((part_catalog_rec_.catch_unit_enabled          = Fnd_Boolean_API.db_true) OR 
          (part_catalog_rec_.receipt_issue_serial_track  = Fnd_Boolean_API.db_true) OR 
          (part_catalog_rec_.lot_tracking_code          != 'NOT LOT TRACKING')) THEN
         newrec_.negative_on_hand := 'NEG ONHAND NOT OK';
      ELSE
         newrec_.negative_on_hand := site_invent_info_rec_.negative_on_hand;
      END IF;
   END IF;
   
   IF ((newrec_.invoice_consideration = 'TRANSACTION BASED') AND (newrec_.inventory_valuation_method = 'ST')) THEN
      IF (part_catalog_rec_.serial_tracking_code = Part_Serial_Tracking_API.db_serial_tracking) THEN
         IF (NOT indrec_.inventory_part_cost_level) THEN 
            newrec_.inventory_part_cost_level  := 'COST PER SERIAL';
         END IF;
      ELSE
         IF (NOT indrec_.invoice_consideration) THEN 
            newrec_.invoice_consideration := 'IGNORE INVOICE PRICE';
         END IF;
      END IF;
   END IF;
   
   IF (newrec_.inventory_valuation_method IN ('FIFO', 'LIFO', 'AV')) THEN
      newrec_.negative_on_hand := 'NEG ONHAND NOT OK';
   END IF;
   
   unit_type_            := Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.unit_meas));
   site_rec_             := Site_API.Get(newrec_.contract);
   new_estimated_material_cost_ := 0;
   
   IF Client_SYS.Item_Exist('ESTIMATED_MATERIAL_COST', attr_) THEN 
      new_estimated_material_cost_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ESTIMATED_MATERIAL_COST', attr_));
      attr_ := Client_Sys.Remove_Attr('ESTIMATED_MATERIAL_COST', attr_);
   END IF;  
      
   IF (part_catalog_rec_.configurable = 'CONFIGURED') THEN
      -- Shortage notification is not allowed for configured parts.
      newrec_.shortage_flag := 'N';
   END IF;

   IF (newrec_.dop_netting IS NULL) THEN
      newrec_.dop_netting := 'NETT';
   END IF;
   
   IF (instr(newrec_.part_no, '%') > 0) THEN
      Error_SYS.Item_General(lu_name_, 'PART_NO', 'NOPERCENTSIGN: The field [:NAME] cannot contain % sign.');
   END IF;
   
   IF (newrec_.mandatory_expiration_date IS NULL) THEN 
      newrec_.mandatory_expiration_date := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   IF (newrec_.excl_ship_pack_proposal IS NULL) THEN 
      newrec_.excl_ship_pack_proposal := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   super(newrec_, indrec_, attr_);
   
   IF Client_SYS.Item_Exist('DESCRIPTION_COPY', attr_) THEN  
      newrec_.description := Client_SYS.Get_Item_Value('DESCRIPTION_COPY', attr_);
   END IF;
   
   Error_SYS.Check_Not_Null(lu_name_, 'ESTIMATED_MATERIAL_COST', new_estimated_material_cost_);
   
   Check_Min_Durab_Days_Co_Del___(newrec_.durability_day, newrec_.min_durab_days_co_deliv);
   Check_Min_Durab_Days_Plan___(newrec_.durability_day, newrec_.min_durab_days_planning);
   
   IF (newrec_.supersedes IS NOT NULL) THEN
      Exist(newrec_.contract, newrec_.supersedes);
   END IF;
   -- always override default or user entered qty_calc_rounding for serial tracking and discrete parts with zero
   IF ((part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.db_true) OR (unit_type_ = 'DISCRETE')) THEN
      newrec_.qty_calc_rounding := 0;
   END IF;

   Check_Qty_Calc_Rounding___(newrec_.qty_calc_rounding, part_catalog_rec_.receipt_issue_serial_track, newrec_.unit_meas);


   -- IF Catch Unit is enabled or whether the part is tracked or if the part is lot tracked, 
   -- negative_on_hand should be NEG ONHAND NOT OK
   Check_Negative_On_Hand(newrec_.negative_on_hand, 
                          part_catalog_rec_.catch_unit_enabled, 
                          part_catalog_rec_.receipt_issue_serial_track, 
                          part_catalog_rec_.lot_tracking_code);

   IF (newrec_.shortage_flag = 'Y') THEN
      IF (Mpccom_System_Parameter_API.Get_Parameter_Value1('SHORTAGE_HANDLING') = 'N') THEN
         Error_SYS.Record_General(lu_name_, 'NOSHORTAGEHANDLE: Cannot have shortages at part level if System flag is set to No.');
      END IF;
      IF (part_catalog_rec_.configurable = 'CONFIGURED') THEN
      -- shortage handling is not allowed for configured parts.
         Error_SYS.Record_General(lu_name_, 'NOSHORTCONFIG: Shortage handling is not allowed for configured parts.');
      END IF;
   END IF;

   IF newrec_.forecast_consumption_flag = 'FORECAST' THEN
      IF newrec_.onhand_analysis_flag = 'Y' THEN      
         Error_SYS.Record_General(lu_name_,'ERRORFORECASTCONSUMP: :P1 is not allowed when Availability Check is selected.',
         Inv_Part_Forecast_Consum_API.Decode(newrec_.forecast_consumption_flag));
      END IF;
      Client_SYS.Add_Info(lu_name_, 'ONLINECONSUMNOTALLOW: IF online consumption is allowed, it is not possible to set it back to not allowed when customer orders are in a state other than Delivered, Invoiced/Closed and/or sales quotation lines are in Released, Revised or Rejected status.'); 
   END IF;

   IF (newrec_.max_actual_cost_update IS NOT NULL) THEN
      IF (newrec_.max_actual_cost_update<0 or newrec_.max_actual_cost_update>1) THEN
         Error_SYS.Record_General(lu_name_, 'ERRORMAXACTCOST: Max Periodic Weighted Average Update can not be less than 0% or higher than 100%.');
      END IF;
   END IF;

   Validate_Lead_Time_Code___(newrec_.lead_time_code,
                              newrec_.contract,
                              newrec_.part_no,
                              newrec_.type_code,
                              NULL );

   IF(newrec_.type_code IN(1, 2)) THEN
      newrec_.purch_leadtime := 0;
      newrec_.expected_leadtime := newrec_.manuf_leadtime;
   ELSIF(newrec_.type_code IN(3, 4, 6)) THEN
      newrec_.manuf_leadtime := 0;
      newrec_.expected_leadtime := newrec_.purch_leadtime;
   END IF;

   Check_Unit_Meas___(newrec_.contract,
                      newrec_.part_no,
                      newrec_.unit_meas,
                      newrec_.catch_unit_meas,
                      part_catalog_rec_.receipt_issue_serial_track,
                      part_catalog_rec_.catch_unit_enabled);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,newrec_.contract);

   Check_Lead_Time___(newrec_.purch_leadtime);
   Check_Lead_Time___(newrec_.manuf_leadtime);
   Check_Lead_Time___(newrec_.expected_leadtime);

   IF (newrec_.type_code = '2') THEN
      IF unit_type_ NOT IN ('WEIGHT', 'VOLUME') THEN
         Error_SYS.Record_General(lu_name_, 'RECIPUNITTYPE: Unit of measure for part type :P1 must be of unit type :P2 or :P3.',
                                  Inventory_Part_Type_API.Decode(newrec_.type_code),
                                  Iso_Unit_Type_API.Decode('WEIGHT'),
                                  Iso_Unit_Type_API.Decode('VOLUME'));
      END IF;
-- CTO Type code 2 is not allowed for configured parts
      IF (part_catalog_rec_.configurable = 'CONFIGURED') THEN
         Error_SYS.Record_General(lu_name_, 'NOCONFIGRECIPE: Type code must not be :P1 for a configured part.',
                                  Inventory_Part_Type_API.Decode(newrec_.type_code) );
      END IF;
-- CTO End
   END IF;

   IF (newrec_.lead_time_code = 'M' AND newrec_.supply_code = 'P') THEN
      Error_SYS.Record_General(lu_name_,'NOTVALIDSUPPLYCODE: Supply code must not be :P1 for a manufactured part', Material_Requis_Supply_API.Decode(newrec_.supply_code));
   END IF;

   -- IF customs statistics number's unit measure has a value, check if intrastat conv factor and net weight have been entered too
   Check_Intrastat_And_Customs___(newrec_.customs_stat_no, newrec_.intrastat_conv_factor);

   IF (newrec_.part_cost_group_id IS NOT NULL) THEN
      $IF (Component_Cost_SYS.INSTALLED) $THEN
         Part_Cost_Group_API.Exist(newrec_.contract, newrec_.part_cost_group_id);
      $ELSE
         NULL;
      $END
   END IF;
   IF (newrec_.cycle_period < 0) THEN
      Error_SYS.Record_General(lu_name_, 'CYCLEPERIOD: The value for Cycle Period may not be negative.');
   END IF;
   --

   Check_Value_Method_Combinat___(newrec_,
                                  part_catalog_rec_.configurable,
                                  part_catalog_rec_.condition_code_usage,
                                  part_catalog_rec_.lot_tracking_code,
                                  part_catalog_rec_.serial_tracking_code,
                                  part_catalog_rec_.receipt_issue_serial_track);

   --Give an alert if the part is FIFO /LIFO and CC enabled
   IF (newrec_.inventory_valuation_method IN ('FIFO','LIFO')) THEN

      IF (part_catalog_rec_.condition_code_usage = 'ALLOW_COND_CODE') THEN
         Client_SYS.Add_Info(lu_name_,'FIFOLIFOANDCC: This part is set up using condition codes. The FIFO / LIFO valuation method will however not consider the condition code of the inventory transactions.');
      END IF;
   END IF;

   IF (newrec_.region_of_origin IS NOT NULL) THEN
      -- fetch country from delivery address and check it
      country_code_ := ISO_Country_API.Encode(Company_Address_API.Get_Country(site_rec_.company,
                                                                              site_rec_.delivery_address));
      IF (country_code_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_,'NORECEIVCOUNTRY: Site delivery address :P1 must have a country code.', site_rec_.delivery_address );
      ELSE
         Country_Region_API.Exist(country_code_, newrec_.region_of_origin);
      END IF;
   END IF;

   IF newrec_.type_code != '1' THEN
      IF part_catalog_rec_.position_part = 'POSITION PART' THEN
         Raise_Position_Part_Type_Error___;
      END IF;
   END IF;

   --Check whether the Inventory UM is equal to unit code of Input UoM Group and
   -- unit code of patca if part is inherited from partca.
   IF (newrec_.input_unit_meas_group_id IS NOT NULL) THEN
      input_group_uom_ := Input_Unit_Meas_Group_API.Get_Unit_Code(newrec_.input_unit_meas_group_id);
      IF (input_group_uom_ != newrec_.unit_meas) THEN
         Raise_Input_Uom_Error___;
      END IF;
   END IF;

   noninv_sales_part_exist_ := 0;
   $IF (Component_Order_SYS.INSTALLED) $THEN
      DECLARE
         temp_ VARCHAR2(4);
      BEGIN
         temp_ := Sales_Part_API.Get_Catalog_Type_Db(newrec_.contract, newrec_.part_no);
         IF (temp_ IS NOT NULL)THEN
            IF (temp_ = 'NON')THEN
               noninv_sales_part_exist_ := 1 ;
            END IF;
         END IF;
      END;  

      IF (noninv_sales_part_exist_ = 1)THEN
         Error_SYS.Record_General(lu_name_, 'NONINVSALESPARTEXIST: Part number :P1 already exists on Site :P2 as a Non inventory sales part.',newrec_.part_no, newrec_.contract);
      END IF;
   $END

   -- XPR, not allowed to create inventory parts if part is already created with the external resource flag in purchase part.
   $IF (Component_Purch_SYS.INSTALLED) $THEN 
      purchase_part_exist_ := Purchase_Part_API.Check_Exist(newrec_.contract, newrec_.part_no);
      IF (purchase_part_exist_ = 1) THEN
         external_resource_db_ := Purchase_Part_API.Get_External_Resource_Db(newrec_.contract, newrec_.part_no);
         IF (external_resource_db_ = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'EXTRESEXIST: You cannot define :P1 as an inventory part as it already exists as a contractor purchase part on site :P2.', newrec_.part_no, newrec_.contract);
         END IF;
      END IF;     
   $END    

   Check_Invoice_Consideration___(newrec_.contract,
                                  site_rec_.company,
                                  newrec_.invoice_consideration);

   Check_Auto_Capability_Check___(newrec_);
   IF (newrec_.automatic_capability_check IN ('RESERVE AND ALLOCATE','ALLOCATE ONLY','NEITHER RESERVE NOR ALLOCATE')) THEN
      -- warn the user that an automatic order capability check could take time
      Client_SYS.Add_Info(lu_name_, 'AOCCWARNING: The current set up will start the Capability Check automatically when a customer order line is entered or updated. Please, be aware of that such a check can take time.');
   END IF;
   
   $IF (Component_Shpord_SYS.INSTALLED) $THEN
      Shop_Order_Operation_List_API.Check_Create_Inventory_Part(newrec_.contract, newrec_.part_no);
   $END 
   
   IF (newrec_.type_code = 6) THEN
      Check_Expense_Part_Allowed___(part_catalog_rec_.allow_as_not_consumed);
   END IF;     

   -- Check Storage Capacities and Conditions Requirement
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.storage_width_requirement);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.storage_height_requirement);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.storage_depth_requirement);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.storage_weight_requirement);
   Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.min_storage_humidity);
   Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.max_storage_humidity);

   Check_Standard_Putaway_Qty___(newrec_.standard_putaway_qty);
   Check_Supersedes___(newrec_.contract, newrec_.part_no, newrec_.supersedes, newrec_.part_status);
   
   Client_Sys.Add_To_Attr('ESTIMATED_MATERIAL_COST', new_estimated_material_cost_, attr_ );
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_            IN     inventory_part_tab%ROWTYPE,
   newrec_            IN OUT inventory_part_tab%ROWTYPE,
   indrec_            IN OUT Indicator_Rec,
   attr_              IN OUT VARCHAR2,
   updated_by_client_ IN     BOOLEAN DEFAULT TRUE  )
IS
   name_                         VARCHAR2(30);
   value_                        VARCHAR2(4000);
   unit_type_                    VARCHAR2(200);  
   part_exist_                   NUMBER;
   order_requisition_            VARCHAR2(200);
   part_catalog_rec_             Part_Catalog_API.Public_Rec;
   site_rec_                     Site_API.Public_Rec;
   site_rec_fetched_             BOOLEAN := FALSE;
   country_code_                 VARCHAR2(3);  
   char_null_                    VARCHAR2(12) := 'VARCHAR2NULL';
   input_group_uom_              INPUT_UNIT_MEAS_GROUP_TAB.unit_code%TYPE;
   exist_invpart_                NUMBER;
   sched_capacity_               VARCHAR2(60);
   line_exist_                   NUMBER;
   part_catalog_fetched_         BOOLEAN := FALSE;
   part_catch_unit_meas_         VARCHAR2(30);
   number_null_                  NUMBER := -9999999;
   updated_control_type_         VARCHAR2(3);
   str_null_                     VARCHAR2(11) := Database_SYS.string_null_;
   new_estimated_material_cost_  NUMBER;
   asset_class_rec_              Asset_Class_API.Public_Rec;

   CURSOR get_catch_uom IS
     SELECT catch_unit_meas
     FROM   inventory_part_tab
     WHERE  part_no          = newrec_.part_no
     AND    contract        != newrec_.contract
     AND    catch_unit_meas != newrec_.catch_unit_meas;
BEGIN
   
   IF (indrec_.asset_class AND newrec_.asset_class IS NOT NULL) THEN
      asset_class_rec_  := Asset_Class_API.Get(newrec_.asset_class);
      IF (NOT indrec_.shortage_flag) THEN 
         newrec_.shortage_flag  := asset_class_rec_.shortage_flag;
         Inventory_Part_Shortage_API.Exist_Db(newrec_.shortage_flag);
      END IF;
      IF (NOT indrec_.onhand_analysis_flag) THEN 
         newrec_.onhand_analysis_flag   := asset_class_rec_.onhand_analysis_flag;
         Inventory_Part_Onh_Analys_API.Exist_Db(newrec_.onhand_analysis_flag);
      END IF;
      IF (NOT indrec_.co_reserve_onh_analys_flag) THEN 
         newrec_.co_reserve_onh_analys_flag := asset_class_rec_.co_reserve_onh_analys_flag;
         Inventory_Part_Onh_Analys_API.Exist_Db(newrec_.co_reserve_onh_analys_flag);
      END IF;
      IF (NOT indrec_.oe_alloc_assign_flag) THEN 
         newrec_.oe_alloc_assign_flag       := asset_class_rec_.oe_alloc_assign_flag;
         Cust_Ord_Reservation_Type_API.Exist_Db(newrec_.oe_alloc_assign_flag);
      END IF;
      IF (NOT indrec_.forecast_consumption_flag) THEN 
         newrec_.forecast_consumption_flag  := asset_class_rec_.forecast_consumption_flag;
         Inv_Part_Forecast_Consum_API.Exist_Db(newrec_.forecast_consumption_flag);
      END IF;
      IF (NOT indrec_.automatic_capability_check) THEN 
         newrec_.automatic_capability_check := asset_class_rec_.automatic_capability_check;
         Capability_Check_Allocate_API.Exist_Db(newrec_.automatic_capability_check);
      END IF;
   END IF;
   
   new_estimated_material_cost_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ESTIMATED_MATERIAL_COST', attr_));
   
   -- IF the global variable new_estimated_material_cost_ is NULL
   IF new_estimated_material_cost_ IS NULL THEN
      new_estimated_material_cost_ :=
         Inventory_Part_Config_API.Get_Estimated_Material_Cost(newrec_.contract, newrec_.part_no, '*');
   END IF;

  IF (newrec_.part_status != oldrec_.part_status) THEN
      IF (Inventory_Part_Status_Par_API.Get_Onhand_Flag_Db(newrec_.part_status) = 'N') THEN
         IF Invent_Part_Quantity_Util_API.Check_Part_Exist(newrec_.contract, newrec_.part_no) THEN
            Error_SYS.Record_General(lu_name_, 'HAS_QTY_ON_HAND: Invalid part status. This part has a quantity on hand, quantity in transit or quantity at customer not equal to 0.');
         END IF;
      END IF;
   END IF;

   IF (Inventory_Part_Status_Par_API.Get_Supply_Flag_Db(newrec_.part_status) = 'Y') AND 
      (Inventory_Part_API.Get_Superseded_By(newrec_.contract, newrec_.part_no) IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGSTSSUPERSESEDBY: Supply status of part :P1 must be Supplies Not Allowed since it is a superseded part.', newrec_.part_no);      
   END IF;

   Validate_Lead_Time_Code___(newrec_.lead_time_code,
                              newrec_.contract,
                              newrec_.part_no,
                              newrec_.type_code,
                              oldrec_.type_code );

   IF (newrec_.forecast_consumption_flag != oldrec_.forecast_consumption_flag)
      OR (newrec_.onhand_analysis_flag != oldrec_.onhand_analysis_flag) THEN
      IF newrec_.forecast_consumption_flag = 'FORECAST' AND newrec_.onhand_analysis_flag = 'Y' THEN
          Error_SYS.Record_General(lu_name_, 'ERRORFORECASTCONSUMP: :P1 is not allowed when Availability Check is selected.',
                                   Inv_Part_Forecast_Consum_API.Decode(newrec_.forecast_consumption_flag));
      END IF;
   END IF;

   IF (newrec_.forecast_consumption_flag != oldrec_.forecast_consumption_flag) THEN
      IF (newrec_.forecast_consumption_flag = 'NOFORECAST') THEN
         $IF (Component_Order_SYS.INSTALLED) $THEN
            Customer_Order_API.Check_Forecast_Consumpt_Change(newrec_.contract, newrec_.part_no);
         $ELSE
            NULL;
         $END                                                                        
      ELSE
         Client_SYS.Add_Warning(lu_name_, 'ONLINECONSUMNOTALLOW: IF online consumption is allowed, it is not possible to set it back to not allowed when customer orders are in a state other than Delivered, Invoiced/Closed and/or sales quotation lines are in Released, Revised or Rejected status.');            
      END IF;
   END IF;

   IF (newrec_.max_actual_cost_update IS NOT NULL) THEN
      IF (newrec_.max_actual_cost_update<0 or newrec_.max_actual_cost_update>1) THEN
         Error_SYS.Record_General(lu_name_, 'ERRORMAXACTCOST: Max Periodic Weighted Average Update can not be less than 0% or higher than 100%.');
      END IF;
   END IF;

   --Check whether the Inventory UM is equal to unit code of input UoM Group.
   IF (newrec_.input_unit_meas_group_id IS NOT NULL) THEN
      input_group_uom_ := Input_Unit_Meas_Group_API.Get_Unit_Code(newrec_.input_unit_meas_group_id);
      IF (input_group_uom_ != newrec_.unit_meas) THEN
         Raise_Input_Uom_Error___;
      END IF;
   END IF;

   --Check the Input UoM Group against the Sales Parts.
   IF( (oldrec_.input_unit_meas_group_id IS NULL) AND (newrec_.input_unit_meas_group_id IS NOT NULL)) THEN 
      $IF (Component_Order_SYS.INSTALLED) $THEN
         exist_invpart_ := Sales_Part_API.Exist_Mum_Inv_Part(newrec_.contract, newrec_.part_no);       
         IF (exist_invpart_ = 1) THEN
            Error_SYS.Record_General(lu_name_,'NOSALESPART: Sales Part is connected to the Inventory Part with an Inventory Conversion factor / Invert Conversion factor not equal to 1, cannot attach an Input UoM for this Inventory Part.');
         END IF;
      $ELSE
         NULL;
      $END
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF Client_SYS.Item_Exist('DESCRIPTION_COPY', attr_) THEN 
      newrec_.description := Client_SYS.Get_Item_Value('DESCRIPTION_COPY', attr_);
   END IF;
   
   Error_SYS.Check_Not_Null(lu_name_, 'ESTIMATED_MATERIAL_COST', new_estimated_material_cost_);
   
   Check_Min_Durab_Days_Co_Del___(newrec_.durability_day, newrec_.min_durab_days_co_deliv);
   Check_Min_Durab_Days_Plan___(newrec_.durability_day, newrec_.min_durab_days_planning);

   IF (newrec_.supersedes IS NOT NULL) THEN
      Exist(newrec_.contract, newrec_.supersedes);
   END IF;

   IF (newrec_.purch_leadtime != oldrec_.purch_leadtime) THEN
      Check_Lead_Time___(newrec_.purch_leadtime);
   END IF;
   IF (newrec_.manuf_leadtime != oldrec_.manuf_leadtime) THEN
      Check_Lead_Time___(newrec_.manuf_leadtime);
   END IF;
   IF (newrec_.expected_leadtime != oldrec_.expected_leadtime) THEN
      Check_Lead_Time___(newrec_.expected_leadtime);
   END IF;

   IF (newrec_.qty_calc_rounding != oldrec_.qty_calc_rounding) THEN
      IF NOT (part_catalog_fetched_) THEN
         part_catalog_rec_     := Part_Catalog_API.Get(newrec_.part_no);
         part_catalog_fetched_ := TRUE;
      END IF;
      Check_Qty_Calc_Rounding___(newrec_.qty_calc_rounding, part_catalog_rec_.receipt_issue_serial_track, newrec_.unit_meas);
   END IF;

   IF (newrec_.type_code != oldrec_.type_code) THEN
   -- Validate the Type Code with the Order Requisition in corresponding InventoryPartPlanning
      order_requisition_ := Inventory_Part_Planning_API.Get_Order_Requisition(newrec_.contract, newrec_.part_no);
      Inventory_Part_Planning_API.Validate_Order_Requisition(newrec_.contract,
                                                             newrec_.part_no,
                                                             order_requisition_,
                                                             Inventory_Part_Type_API.Decode(newrec_.type_code));

      IF (newrec_.type_code = '2') THEN
         unit_type_ := Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.unit_meas ));
         IF unit_type_ NOT IN ('WEIGHT', 'VOLUME') THEN
            Error_SYS.Record_General(lu_name_, 'RECIPUNITTYPE: Unit of measure for part type :P1 must be of unit type :P2 or :P3.',
                                     Inventory_Part_Type_API.Decode(newrec_.type_code),
                                     Iso_Unit_Type_API.Decode('WEIGHT'),
                                     Iso_Unit_Type_API.Decode('VOLUME'));
         END IF;
         IF NOT (part_catalog_fetched_) THEN
            part_catalog_rec_     := Part_Catalog_API.Get(newrec_.part_no);
            part_catalog_fetched_ := TRUE;
         END IF;
         IF (part_catalog_rec_.configurable = 'CONFIGURED') THEN
            Error_SYS.Record_General(lu_name_, 'NOCONFIGRECIPE: Type code must not be :P1 for a configured part.',
                                     Inventory_Part_Type_API.Decode(newrec_.type_code) );
         END IF;
      END IF;

      IF newrec_.type_code != '1' THEN
         IF NOT (part_catalog_fetched_) THEN
            part_catalog_rec_     := Part_Catalog_API.Get(newrec_.part_no);
            part_catalog_fetched_ := TRUE;
         END IF;
         IF (part_catalog_rec_.position_part = 'POSITION PART') THEN
            Raise_Position_Part_Type_Error___;
         END IF;
      END IF;

      IF (newrec_.type_code IN ('3', '6') AND oldrec_.type_code IN ('1', '2'))
         OR (newrec_.type_code IN ('3') AND oldrec_.type_code IN ('4'))THEN
         IF Split_Manuf_Acquired_Api.Encode(Inventory_Part_Planning_API.Get_Split_Manuf_Acquired(newrec_.contract, newrec_.part_no)) = 'SPLIT' THEN
            Error_SYS.Record_General(lu_name_, 'PRTTYPCANTSET: Part type cannot set to :P1 since the inventory part :P2 defines split on planing data.',
                                     Inventory_Part_Type_API.Decode(newrec_.type_code), newrec_.part_no);
         END IF;
      END IF;
      IF (newrec_.type_code = 6) THEN
         IF NOT (part_catalog_fetched_) THEN
            part_catalog_rec_     := Part_Catalog_API.Get(newrec_.part_no);
            part_catalog_fetched_ := TRUE;
         END IF;
         Check_Expense_Part_Allowed___(part_catalog_rec_.allow_as_not_consumed);
      END IF;
   END IF;

   IF (newrec_.lead_time_code = 'M' AND newrec_.supply_code = 'PO') THEN
       Error_SYS.Record_General(lu_name_,'NOTVALIDSUPPLYCODE: Supply code must not be :P1 for a manufactured part',
                                Material_Requis_Supply_API.Decode(newrec_.supply_code));
   END IF;

   IF ((oldrec_.eng_attribute IS NOT NULL) AND (newrec_.eng_attribute IS NULL)) THEN
      IF (Inventory_Part_char_API.Part_Has_Char(newrec_.contract,newrec_.part_no)) THEN
         Error_SYS.Record_General(lu_name_,'CHARVALUESSEXIST: All characteristic codes must be deleted before characteristic template is removed');
      END IF;
   END IF;

   -- IF customs statistics number's unit measure has a value, check if intrastat conv factor and net weight have been entered too
   IF ((NVL(newrec_.intrastat_conv_factor, number_null_) != NVL(oldrec_.intrastat_conv_factor, number_null_)) OR 
       (NVL(newrec_.customs_stat_no, str_null_) != NVL(oldrec_.customs_stat_no, str_null_))) THEN
      Check_Intrastat_And_Customs___(newrec_.customs_stat_no, newrec_.intrastat_conv_factor);
   END IF;

   IF (newrec_.zero_cost_flag != oldrec_.zero_cost_flag) THEN
      Inventory_Part_Config_API.Check_Zero_Cost_Flag(newrec_.contract,
                                                     newrec_.part_no,
                                                     newrec_.zero_cost_flag,
                                                     newrec_.inventory_part_cost_level,
                                                     newrec_.inventory_valuation_method);
   END IF;

   IF (NVL(newrec_.part_cost_group_id, char_null_) !=
       NVL(oldrec_.part_cost_group_id, char_null_)) THEN
       IF (newrec_.part_cost_group_id IS NOT NULL) THEN
          $IF (Component_Cost_SYS.INSTALLED) $THEN
             Trace_SYS.Message('contract -' || newrec_.contract||' cost group -'||newrec_.part_cost_group_id);
             Part_Cost_Group_API.Exist(newrec_.contract, newrec_.part_cost_group_id);
          $ELSE
             NULL;
          $END      
      END IF;
   END IF;

   IF (oldrec_.stock_management = 'SYSTEM MANAGED INVENTORY') AND
      (newrec_.stock_management = 'VENDOR MANAGED INVENTORY') AND
      (newrec_.lead_time_code   = 'M') THEN
       Error_SYS.Record_General(lu_name_, 'NOVMIMANUF: Cannot have Vendor Managed Inventory when part is manufactured.');
   END IF;

   IF (newrec_.cycle_period < 0) THEN
      Error_SYS.Record_General(lu_name_, 'CYCLEPERIOD: The value for Cycle Period may not be negative.');
   END IF;

   IF (newrec_.invoice_consideration != oldrec_.invoice_consideration) THEN
      IF NOT (site_rec_fetched_) THEN
         site_rec_ := Site_API.Get(newrec_.contract);
         site_rec_fetched_ := TRUE;
      END IF;
      Check_Invoice_Consideration___(newrec_.contract,
                                     site_rec_.company,
                                     newrec_.invoice_consideration);
      IF (newrec_.invoice_consideration = 'PERIODIC WEIGHTED AVERAGE') THEN
         -- This section captures the following modifications of invoice_consideration:
         -- IGNORE INVOICE PRICE  ==>  PERIODIC WEIGHTED AVERAGE
         -- TRANSACTION BASED     ==>  PERIODIC WEIGHTED AVERAGE
         -- Activate Periodic Weighted Average.
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            IF (Purchase_Order_Line_Comp_API.Component_Part_Used(newrec_.contract, newrec_.part_no)) THEN
               part_exist_ := 1;
            ELSE
               part_exist_ := 0;
            END IF;
            IF (part_exist_ = 1) THEN
                  Error_SYS.Record_General(lu_name_, 'ACPOLCOMP: Supplier Invoice Consideration :P1 is not allowed for parts entered as supplier material components on active purchase orders.', Invoice_Consideration_API.Decode(newrec_.invoice_consideration));
            END IF;
           
         
            IF (Pur_Ord_Charged_Comp_API.Not_Charged_Comp_Used(newrec_.contract, newrec_.part_no)) THEN
               part_exist_ := 1;
            ELSE
               part_exist_ := 0;
            END IF;
            IF (part_exist_ = 1) THEN
                Error_SYS.Record_General(lu_name_, 'ACNOCHARGE: Supplier Invoice Consideration :P1 is not allowed for parts entered as No Charge material on active purchase orders.', Invoice_Consideration_API.Decode(newrec_.invoice_consideration));
            END IF;
         
        
            -- Note: Check if the inventory part is used as an exchange component in an open purchase order and/or requisition
            part_exist_ := Pur_Order_Exchange_Comp_API.Exchange_Comp_Used(newrec_.contract, newrec_.part_no);
            IF (part_exist_ = 1) THEN
                Error_SYS.Record_General(lu_name_, 'ACEXCOMP: Supplier Invoice Consideration :P1 not allowed for parts entered as exchange components on active purchase orders and/or requisitions.', Invoice_Consideration_API.Decode(newrec_.invoice_consideration));
            END IF;
         $ELSE 
            NULL;
         $END
         
         -- Check if the inventory part is used on any MRO Shop Order
         $IF (Component_Mromfg_SYS.INSTALLED) $THEN        
            part_exist_ :=0;
            part_exist_ := Interim_Mro_Manager_API.Check_Part_In_Shop_Order(newrec_.contract, newrec_.part_no);
            IF (part_exist_ = 1) THEN
                Error_SYS.Record_General(lu_name_, 'ACSHOPORD: Supplier Invoice Consideration :P1 is not allowed for parts existing on a MRO Shop Order.', Invoice_Consideration_API.Decode(newrec_.invoice_consideration));
            END IF;
         $ELSE 
            NULL;
         $END
       
       -- Check if the inventory part is used on a Shop Order is externally owned
         $IF (Component_Shpord_SYS.INSTALLED) $THEN        
            part_exist_ :=0;
            part_exist_ := Shop_Ord_Util_API.External_Part_In_Shop_Order(newrec_.contract, newrec_.part_no);          
            IF (part_exist_ = 1) THEN
               Error_SYS.Record_General(lu_name_, 'ACEXTSHOP: Supplier Invoice Consideration :P1 is not allowed for externally owned parts existing on a Shop Order.', Invoice_Consideration_API.Decode(newrec_.invoice_consideration));
            END IF;
         $ELSE 
            NULL;
         $END

         -- This block will search for Purchase Order Lines which has wither 'Released' Milestone lines or
         -- No Milestone Lines with purchase payment type 'STAGE'. Found will raised error for PWA modification.
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            IF (Purchase_Order_Milestone_API.Chk_Released_Or_No_Stage_Lines(newrec_.contract, newrec_.part_no)) THEN
               line_exist_ := 1;
            ELSE
               line_exist_ := 0;
            END IF;         
            IF (line_exist_ = 1) THEN
               Error_SYS.Record_General(lu_name_, 'STAGELINEEXIST: Supplier Invoice Consideration :P1 is not allowed for parts in Purchase Order Lines with Stage Payments.', Invoice_Consideration_API.Decode(newrec_.invoice_consideration));
            END IF;
         $ELSE 
            NULL;
         $END
      ELSIF (oldrec_.invoice_consideration = 'PERIODIC WEIGHTED AVERAGE') THEN
         -- This section captures the following modifications of invoice_consideration:
         -- PERIODIC WEIGHTED AVERAGE  ==>  IGNORE INVOICE PRICE
         -- PERIODIC WEIGHTED AVERAGE  ==>  TRANSACTION BASED
         -- Periodic Weighted Average has been switched off for the part. Check that
         -- the accumulated differences are equal to zero for all configurations.
         Actual_Cost_Manager_API.Check_Actual_Cost_Closure(newrec_.contract,
                                                           newrec_.part_no);
      ELSE
         -- This section captures all other modifications of invoice_consideration:
         -- IGNORE INVOICE PRICE  ==>  TRANSACTION_BASED
         -- TRANSACTION BASED     ==>  IGNORE INVOICE PRICE
         NULL;
      END IF;
   END IF;

   IF (newrec_.inventory_valuation_method != oldrec_.inventory_valuation_method) OR
      (newrec_.inventory_part_cost_level  != oldrec_.inventory_part_cost_level)  OR
      (newrec_.invoice_consideration      != oldrec_.invoice_consideration)      OR
      (newrec_.zero_cost_flag             != oldrec_.zero_cost_flag)             OR
      (newrec_.negative_on_hand           != oldrec_.negative_on_hand)           OR
      (newrec_.ext_service_cost_method    != oldrec_.ext_service_cost_method)    OR
      (newrec_.lead_time_code             != oldrec_.lead_time_code)             THEN

      IF NOT (part_catalog_fetched_) THEN
         part_catalog_rec_     := Part_Catalog_API.Get(newrec_.part_no);
         part_catalog_fetched_ := TRUE;
      END IF;

      Check_Value_Method_Combinat___(newrec_,
                                     part_catalog_rec_.configurable,
                                     part_catalog_rec_.condition_code_usage,
                                     part_catalog_rec_.lot_tracking_code,
                                     part_catalog_rec_.serial_tracking_code,
                                     part_catalog_rec_.receipt_issue_serial_track);

      -- IF Catch Unit is enabled or whether the part is tracked or if the part is lot tracked, 
      -- negative_on_hand should be NEG ONHAND NOT OK
      IF (newrec_.negative_on_hand != oldrec_.negative_on_hand) THEN
         Check_Negative_On_Hand(newrec_.negative_on_hand, 
                                part_catalog_rec_.catch_unit_enabled,
                                part_catalog_rec_.receipt_issue_serial_track, 
                                part_catalog_rec_.lot_tracking_code);
      END IF;
   END IF;

   IF ((oldrec_.inventory_valuation_method != newrec_.inventory_valuation_method) OR
       (oldrec_.inventory_part_cost_level  != newrec_.inventory_part_cost_level)) THEN
      -- Execute validations when changing valuation method or part cost level
      Check_Value_Method_Change___(newrec_, oldrec_);
   END IF;

   IF (newrec_.shortage_flag != oldrec_.shortage_flag) THEN
      IF (newrec_.shortage_flag = 'Y') THEN
         IF (Mpccom_System_Parameter_API.Get_Parameter_Value1('SHORTAGE_HANDLING') = 'N') THEN
            Error_SYS.Record_General(lu_name_, 'NOSHORTAGEHANDLE: Cannot have shortages at part level if System flag is set to No.');
         END IF;
         IF NOT (part_catalog_fetched_) THEN
            part_catalog_rec_     := Part_Catalog_API.Get(newrec_.part_no);
            part_catalog_fetched_ := TRUE;
         END IF;
         IF (part_catalog_rec_.configurable = 'CONFIGURED') THEN
         -- shortage handling is not allowed for configured parts.
            Error_SYS.Record_General(lu_name_, 'NOSHORTCONFIG: Shortage handling is not allowed for configured parts.');
         END IF;
      END IF;
   END IF;

   IF (NVL(newrec_.region_of_origin,char_null_) != NVL(oldrec_.region_of_origin,char_null_)) THEN
      IF (newrec_.region_of_origin IS NOT NULL) THEN
         IF NOT (site_rec_fetched_) THEN
            site_rec_ := Site_API.Get(newrec_.contract);
            site_rec_fetched_ := TRUE;
         END IF;
         -- fetch site/receivers country and check it
         country_code_ := ISO_Country_API.Encode(Company_Address_API.Get_Country(site_rec_.company,
                                                                                 site_rec_.delivery_address));
         IF (country_code_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_,'NORECEIVCOUNTRY: Site delivery address :P1 must have a country code.', site_rec_.delivery_address );
         ELSE
            Country_Region_API.Exist(country_code_, newrec_.region_of_origin);
         END IF;
      END IF;
   END IF;

   IF (newrec_.ext_service_cost_method != oldrec_.ext_service_cost_method) THEN
      Check_Open_Eso_Exist___(newrec_.contract, newrec_.part_no);
   END IF;

   IF (updated_by_client_) THEN
      IF ((newrec_.type_code != oldrec_.type_code) OR (newrec_.purch_leadtime != oldrec_.purch_leadtime)) THEN
         IF ((newrec_.type_code IN ('3','4','6')) AND (newrec_.purch_leadtime = 0)) THEN
            $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
               sched_capacity_ := Inventory_Part_Planning_API.Get_Sched_Capacity_Db(newrec_.contract, newrec_.part_no);
               IF (sched_capacity_ = 'F') THEN
                  Error_SYS.Record_General(lu_name_, 'FPURCHZEROLT: Leadtime for purchased part with finite capacity cannot be zero.');
               END IF;
            $ELSE
               NULL;  
            $END
         END IF;
      END IF; 
   END IF;

   Check_Auto_Capability_Check___(newrec_);
   IF (oldrec_.automatic_capability_check != newrec_.automatic_capability_check) AND
      (newrec_.automatic_capability_check IN ('RESERVE AND ALLOCATE','ALLOCATE ONLY','NEITHER RESERVE NOR ALLOCATE')) THEN
      -- warn the user that an automatic order capability check could take time
      Client_SYS.Add_Info(lu_name_, 'AOCCWARNING: The current set up will start the Capability Check automatically when a customer order line is entered or updated. Please, be aware of that such a check can take time.');
   END IF;

   -- Updating catch unit meas is not allowed if it is a not null value
   IF ((oldrec_.catch_unit_meas != newrec_.catch_unit_meas) OR
       (oldrec_.catch_unit_meas IS NOT NULL AND newrec_.catch_unit_meas IS NULL)) THEN
      Error_SYS.Record_General('InventoryPart','NOUPDATEINVEXIST: Catch UoM cannot be modified once specified.');
   END IF;

   -- checking catch unit meas
   IF (oldrec_.catch_unit_meas IS NULL AND newrec_.catch_unit_meas IS NOT NULL) THEN
      OPEN get_catch_uom;
      FETCH get_catch_uom INTO part_catch_unit_meas_;

      IF (get_catch_uom%FOUND) THEN
         IF (Iso_Unit_API.Get_Base_Unit(newrec_.catch_unit_meas) != Iso_Unit_API.Get_Base_Unit(part_catch_unit_meas_)) THEN
            CLOSE get_catch_uom;
            Error_SYS.Record_General(lu_name_, 'BASCATUNIT: The base unit :P1 for catch U/M :P2 is different from the base unit for this part on another site.', Iso_Unit_API.Get_Base_Unit(newrec_.catch_unit_meas), newrec_.catch_unit_meas );
         END IF;
      END IF;
      CLOSE get_catch_uom;

      IF NOT (part_catalog_fetched_) THEN
         part_catalog_rec_     := Part_Catalog_API.Get(newrec_.part_no);
         part_catalog_fetched_ := TRUE;
      END IF;

      IF (part_catalog_rec_.catch_unit_enabled = 'TRUE') THEN
         $IF (Component_Order_SYS.INSTALLED) $THEN
            Sales_Part_API.Check_Enable_Catch_Unit(newrec_.contract, newrec_.part_no, newrec_.catch_unit_meas);         
         $ELSE
            NULL;
         $END         
      END IF;
   END IF;

   IF (oldrec_.input_unit_meas_group_id IS NOT NULL) THEN
      IF (NVL(newrec_.input_unit_meas_group_id, Database_SYS.string_null_) != NVL(oldrec_.input_unit_meas_group_id, Database_SYS.string_null_)) THEN
         IF NOT (part_catalog_fetched_) THEN
            part_catalog_rec_     := Part_Catalog_API.Get(newrec_.part_no);
            part_catalog_fetched_ := TRUE;
         END IF;
         IF (oldrec_.input_unit_meas_group_id = part_catalog_rec_.input_unit_meas_group_id) THEN
            IF (Part_Gtin_Unit_Meas_API.Check_Exist_Any_Unit(newrec_.part_no)) THEN
               -- Info message to user that connection to the GTIN 14 numbers are lost in Part Catalog
               Client_SYS.Add_Info(lu_name_, 'GTIN14CONNLOST: IF you manually change or delete the input unit of measure group, the connection to the GTIN 14 for packages will be lost from the site :P1.', newrec_.contract);
            END IF;
         END IF;
      END IF;
   END IF;

   -- Check Storage Capacities and Conditions Requirements
   IF (NVL(newrec_.storage_width_requirement, number_null_) != NVL(oldrec_.storage_width_requirement, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.storage_width_requirement);
   END IF;
   IF (NVL(newrec_.storage_height_requirement, number_null_) != NVL(oldrec_.storage_height_requirement, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.storage_height_requirement);
   END IF;
   IF (NVL(newrec_.storage_depth_requirement, number_null_) != NVL(oldrec_.storage_depth_requirement, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity(newrec_.storage_depth_requirement);
   END IF;
   IF (NVL(newrec_.storage_weight_requirement, number_null_) != NVL(oldrec_.storage_weight_requirement, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.storage_weight_requirement);
   END IF;
   IF (NVL(newrec_.min_storage_humidity, number_null_) != NVL(oldrec_.min_storage_humidity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.min_storage_humidity);
   END IF;
   IF (NVL(newrec_.max_storage_humidity, number_null_) != NVL(oldrec_.max_storage_humidity, number_null_)) THEN
      Part_Catalog_Invent_Attrib_API.Check_Humidity(newrec_.max_storage_humidity);
   END IF;
   IF (NVL(newrec_.standard_putaway_qty, number_null_) != NVL(oldrec_.standard_putaway_qty, number_null_)) THEN
      Check_Standard_Putaway_Qty___(newrec_.standard_putaway_qty);
   END IF;

   IF (NVL(newrec_.standard_putaway_qty, number_null_) != NVL(oldrec_.standard_putaway_qty, number_null_)) THEN
      IF NOT (part_catalog_fetched_) THEN
         part_catalog_rec_     := Part_Catalog_API.Get(newrec_.part_no);
         part_catalog_fetched_ := TRUE;
      END IF;
   END IF;
   
   IF (newrec_.zero_cost_flag != 'O') THEN
      updated_control_type_ := Get_Updated_Control_Type___(oldrec_,
                                                        newrec_,
                                                        check_only_active_ => FALSE,
                                                        company_           => NULL);
      IF (updated_control_type_ IS NOT NULL) THEN
         IF NOT (site_rec_fetched_) THEN
            site_rec_ := Site_API.Get(newrec_.contract);
            site_rec_fetched_ := TRUE;
         END IF;
         IF (Company_Invent_Info_API.Stock_Ctrl_Types_Blocked(site_rec_.company)) THEN
            updated_control_type_ := Get_Updated_Control_Type___(oldrec_,
                                                                 newrec_,
                                                                 check_only_active_ => TRUE,
                                                                 company_           => site_rec_.company);
            IF (updated_control_type_ IS NOT NULL) THEN
               IF (Company_Owned_Stock_Exists___(newrec_.contract, newrec_.part_no)) THEN
                  Error_SYS.Record_General(lu_name_, 'CTRLTYPEBLOCKED: Control type :P1 cannot be updated since modification of stock account control type values is blocked in company :P2.',Posting_Ctrl_Control_Type_API.Get_Description(updated_control_type_,'INVENT',site_rec_.company), site_rec_.company);
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;

   IF (NVL(newrec_.earliest_ultd_supply_date, Database_SYS.first_calendar_date_) != 
       NVL(oldrec_.earliest_ultd_supply_date, Database_SYS.first_calendar_date_)) THEN
      IF (newrec_.earliest_ultd_supply_date IS NOT NULL) THEN
         IF NOT (site_rec_fetched_) THEN
            site_rec_ := Site_API.Get(newrec_.contract);
            site_rec_fetched_ := TRUE;
         END IF;

         IF (Work_Time_Calendar_API.Is_Working_Day(site_rec_.dist_calendar_id,
                                                   newrec_.earliest_ultd_supply_date) = 0) THEN
               Error_SYS.Record_General(lu_name_, 'NOTWORKDAY: :P1 is not a work day in calendar :P2 - :P3.', to_char(newrec_.earliest_ultd_supply_date, 'YYYY-MM-DD'), site_rec_.dist_calendar_id, Work_Time_Calendar_API.Get_Description(site_rec_.dist_calendar_id));
         END IF;
      END IF;
   END IF;

   IF (NVL(newrec_.supersedes, str_null_) != NVL(oldrec_.supersedes, str_null_)) THEN
      Check_Supersedes___(newrec_.contract, newrec_.part_no, newrec_.supersedes, newrec_.part_status);
   END IF;

   IF ((newrec_.mandatory_expiration_date = Fnd_Boolean_API.DB_TRUE )  AND
       (oldrec_.mandatory_expiration_date = Fnd_Boolean_API.DB_FALSE)) THEN
      IF (Inventory_Part_In_Stock_API.Expiration_Date_Is_Missing(newrec_.contract, newrec_.part_no)) THEN
         Error_SYS.Record_General(lu_name_, 'MANDEXPDATE: Expiration date must be specified for all stock records except on location types :P1 and :P2.', Inventory_Location_Type_API.Decode(Inventory_Location_Type_API.DB_ARRIVAL), Inventory_Location_Type_API.Decode(Inventory_Location_Type_API.DB_QUALITY_ASSURANCE));
      END IF;
   END IF;
   
   Client_Sys.Add_To_Attr('ESTIMATED_MATERIAL_COST', new_estimated_material_cost_, attr_ );
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


PROCEDURE Add_To_Purchase_Order___ (
   order_no_            OUT VARCHAR2,
   contract_            IN  VARCHAR2,
   part_no_             IN  VARCHAR2,
   inventory_unit_qty_  IN  NUMBER,
   inventory_unit_meas_ IN  VARCHAR2,
   wanted_receipt_date_ IN  DATE,
   authorize_code_      IN  VARCHAR2 )
IS
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      Purchase_Order_API.Prepare_Order(order_no_, 
                                       contract_, 
                                       part_no_,
                                       inventory_unit_qty_, 
                                       inventory_unit_meas_, 
                                       Order_Supply_Type_API.Decode('IO'), 
                                       wanted_receipt_date_, 
                                       authorize_code_, 
                                       is_order_proposal_ => 'TRUE');
   $ELSE
      Error_SYS.Component_Not_Exist('PURCH');
   $END
END Add_To_Purchase_Order___;

PROCEDURE Mod_Earliest_Ultd_Sply_Date___ (
   date_modified_        OUT BOOLEAN, 
   contract_             IN  VARCHAR2,
   part_no_              IN  VARCHAR2,
   planned_receipt_date_ IN  DATE,
   backdate_allowed_db_  IN  VARCHAR2 )
IS
   earliest_ultd_supply_date_ DATE;
   oldrec_                    inventory_part_tab%ROWTYPE;
BEGIN
   IF (planned_receipt_date_ IS NOT NULL) THEN
      earliest_ultd_supply_date_ := Work_Time_Calendar_Api.Get_Nearest_Work_Day(Site_API.Get_Dist_Calendar_Id(contract_), (planned_receipt_date_ + 1));
   END IF;
   
   oldrec_        := Get_Object_By_Keys___(contract_, part_no_);
   date_modified_ := FALSE;
   
   IF (NVL(earliest_ultd_supply_date_       , Database_SYS.first_calendar_date_) != 
       NVL(oldrec_.earliest_ultd_supply_date, Database_SYS.first_calendar_date_)) THEN
       -- There is a difference and we have a reason to update
      IF ((backdate_allowed_db_ = Fnd_Boolean_API.DB_TRUE) OR
         (NVL(earliest_ultd_supply_date_       , Database_SYS.first_calendar_date_) >
          NVL(oldrec_.earliest_ultd_supply_date, Database_SYS.first_calendar_date_))) THEN
          -- If either the new date is greater than the old date OR we are allowed to update
          -- to an older date, then update.
         oldrec_ := Lock_by_Keys___(contract_, part_no_);
         oldrec_.earliest_ultd_supply_date := earliest_ultd_supply_date_;
         Modify___(oldrec_);
         date_modified_ := TRUE;
      END IF;
   END IF;
   
END Mod_Earliest_Ultd_Sply_Date___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_                      inventory_part_tab%ROWTYPE;
   new_estimated_material_cost_ NUMBER; 
BEGIN
   --Add pre-processing code here
   super(info_, objid_, objversion_, attr_, action_);
   IF action_ = 'DO' THEN
      newrec_ := Get_Object_By_Id___(objid_);
      new_estimated_material_cost_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ESTIMATED_MATERIAL_COST', attr_));
      IF ((NVL(new_estimated_material_cost_,0) != 0) AND
          (newrec_.zero_cost_flag != 'O')) THEN
         Inventory_Part_Config_API.Modify_Standard_Cost__(newrec_.contract,
                                                          newrec_.part_no,
                                                          '*',
                                                          new_estimated_material_cost_);
      END IF;

      -- Communicating info that is decided in the server, back to the client after inserting a record.
      Client_SYS.Add_To_Attr('INVENTORY_VALUATION_METHOD',Inventory_Value_Method_API.Decode(newrec_.inventory_valuation_method),attr_);
      Client_SYS.Add_To_Attr('INVOICE_CONSIDERATION',Invoice_Consideration_API.Decode(newrec_.invoice_consideration),attr_);
      Client_SYS.Add_To_Attr('NEGATIVE_ON_HAND_DB',newrec_.negative_on_hand,attr_);
      Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);
      Client_SYS.Add_To_Attr('LEAD_TIME_CODE', Inv_Part_Lead_Time_Code_API.Decode(newrec_.lead_time_code), attr_);
      Client_SYS.Add_To_Attr('CREATE_DATE', newrec_.create_date, attr_);
      Client_SYS.Add_To_Attr('LAST_ACTIVITY_DATE', newrec_.last_activity_date, attr_);
      Client_SYS.Add_To_Attr('SHORTAGE_FLAG_DB', newrec_.shortage_flag,attr_);
      Client_SYS.Add_To_Attr('ONHAND_ANALYSIS_FLAG_DB',newrec_.Onhand_Analysis_Flag,attr_);
      Client_SYS.Add_To_Attr('FORECAST_CONSUMPTION_FLAG_DB',newrec_.Forecast_Consumption_Flag,attr_);
      Client_SYS.Add_To_Attr('OE_ALLOC_ASSIGN_FLAG',Cust_Ord_Reservation_Type_API.Decode(newrec_.oe_alloc_assign_flag),attr_);
      Client_SYS.Add_To_Attr('TECHNICAL_COORDINATOR_ID',newrec_.technical_coordinator_id,attr_);
      Client_SYS.Add_To_Attr('INVENTORY_PART_COST_LEVEL',Inventory_Part_Cost_Level_API.Decode(newrec_.inventory_part_cost_level),attr_);
      Client_SYS.Add_To_Attr('EXT_SERVICE_COST_METHOD', Ext_Service_Cost_Method_API.Decode(newrec_.ext_service_cost_method), attr_);
   END IF;
   --Add post-processing code here
END New__;

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
    newrec_     inventory_part_tab%ROWTYPE;
BEGIN
   --Add pre-processing code here
   super(info_, objid_, objversion_, attr_, action_);
   IF action_ = 'DO' THEN
      newrec_ := Get_Object_By_Id___(objid_);
      -- Communicating info that is decided in the server, back to the client after updating a record.
      Client_SYS.Add_To_Attr('LAST_ACTIVITY_DATE', newrec_.last_activity_date, attr_);
      Client_SYS.Add_To_Attr('LEAD_TIME_CODE', Inv_Part_Lead_Time_Code_API.Decode(newrec_.lead_time_code), attr_);
      Client_SYS.Add_To_Attr('STOCK_MANAGEMENT', Inventory_Part_Management_API.Decode(newrec_.stock_management), attr_);
      Client_SYS.Add_To_Attr('SHORTAGE_FLAG_DB', newrec_.shortage_flag,attr_);
      Client_SYS.Add_To_Attr('ONHAND_ANALYSIS_FLAG_DB',newrec_.Onhand_Analysis_Flag,attr_);
      Client_SYS.Add_To_Attr('FORECAST_CONSUMPTION_FLAG_DB',newrec_.Forecast_Consumption_Flag,attr_);
      Client_SYS.Add_To_Attr('OE_ALLOC_ASSIGN_FLAG',Cust_Ord_Reservation_Type_API.Decode(newrec_.oe_alloc_assign_flag),attr_); 
   END IF; 
   --Add post-processing code here
END Modify__;




-- Recalc_Stockfactors_Impl__
--   Private method for RecalcStockfactors. This made private for calling
--   as a Deferred_Call.
PROCEDURE Recalc_Stockfactors_Impl__ (
   attrib_ IN VARCHAR2 )
IS
   average_period_      NUMBER;
   work_days_           NUMBER;
   rows_changed_        NUMBER;
   records_changed_     NUMBER;
   contract_            inventory_part_tab.contract%TYPE;
   second_commodity_    inventory_part_tab.second_commodity%TYPE;
   periods_             NUMBER;
   ptr_                 NUMBER;
   name_                VARCHAR2(30);
   value_               VARCHAR2(2000);
   periods_per_year_    NUMBER;
   manuf_median_period_ NUMBER;
   purch_median_period_ NUMBER;

   CURSOR get_parts IS
      SELECT ip.part_no,
             ip.contract,
             ip.second_commodity,
             ip.lead_time_code,
             ip.manuf_leadtime,
             ip.purch_leadtime
      FROM   inventory_part_planning_pub ipp, inventory_part_tab ip, user_allowed_site_pub
      WHERE  (ipp.safety_stock_auto_db = 'Y' OR ipp.order_point_qty_auto_db = 'Y' OR ipp.lot_size_auto_db = 'Y')
      AND    ip.part_no = ipp.part_no
      AND    ip.contract = ipp.contract
      AND    (ip.second_commodity = second_commodity_ OR second_commodity_ IS NULL)
      AND    ip.contract = site
      AND    (ip.contract = contract_ OR contract_ IS NULL);
BEGIN

   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
    IF (name_ = 'CONTRACT') THEN
       contract_ := value_;
    ELSIF (name_ = 'SECOND_COMMODITY') THEN
       second_commodity_:= value_;
    ELSIF (name_ = 'PERIODS') THEN
       periods_:= Client_SYS.Attr_Value_To_Number(value_);
    ELSE
       Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
    END IF;
   END LOOP;

   rows_changed_    := 0;
   records_changed_ := 0;

   -- Retrieve number of workdays in a week
   work_days_ := 0;
   work_days_ := Site_Invent_Info_API.Get_Avg_Work_Days_Per_Week(contract_);

   -- Retrieve general statistic data.
   average_period_ := Statistic_Period_API.Get_Average_Period;
   periods_per_year_ := Statistic_Period_API.Get_Periods_Per_Year;
   Statistic_Period_API.Get_Median_Period(manuf_median_period_, average_period_, work_days_, 'M');
   Statistic_Period_API.Get_Median_Period(purch_median_period_, average_period_, work_days_, 'P');

   -- Loop over all parts in question and modify their stockfactors.
   FOR rec_ IN get_parts LOOP
      Inventory_Part_Planning_API.Modify_Stockfactors(rows_changed_,
                                                      rec_.contract,
                                                      rec_.part_no,
                                                      rec_.second_commodity,
                                                      periods_,
                                                      work_days_,
                                                      manuf_median_period_,
                                                      purch_median_period_,
                                                      periods_per_year_,
                                                      rec_.lead_time_code,
                                                      rec_.manuf_leadtime,
                                                      rec_.purch_leadtime);
      IF (rows_changed_ > 0) THEN
         records_changed_ := records_changed_ + 1;
         Trace_SYS.Field('records_changed_',records_changed_);
         
      END IF;
   END LOOP;
   Trace_SYS.Message('Recalc_Stockfactors ended. Changed: ' || to_char(records_changed_));
END Recalc_Stockfactors_Impl__;


-- Copy_Part_To_Site_Impl__
--   The implementation of CopyPartToSite all the parts from From site to
--   To site that doesn't exist on the To site.
PROCEDURE Copy_Part_To_Site_Impl__ (
   attr_ IN VARCHAR2 )
IS
   from_contract_           inventory_part_tab.contract%TYPE;
   from_second_commodity_   inventory_part_tab.second_commodity%TYPE;
   to_contract_             inventory_part_tab.contract%TYPE;
   noninv_sales_part_exist_ NUMBER;

   CURSOR get_parts IS
      SELECT part_no
      FROM inventory_part_tab
      WHERE NVL(second_commodity, '%') LIKE from_second_commodity_
      AND   contract = from_contract_
      AND   part_no NOT IN (SELECT part_no FROM inventory_part_tab
                            WHERE contract = to_contract_);
BEGIN
   from_contract_         := Client_SYS.Get_Item_Value('FROM_CONTRACT', attr_);
   from_second_commodity_ := NVL(Client_SYS.Get_Item_Value('FROM_SECOND_COMMODITY', attr_), '%');
   to_contract_           := Client_SYS.Get_Item_Value('TO_CONTRACT', attr_);
   FOR part_rec IN get_parts LOOP
      -- Loop for selected parts --
      noninv_sales_part_exist_ := 0 ;
      $IF (Component_Order_SYS.INSTALLED) $THEN
         DECLARE
            temp_ VARCHAR2(4);
         BEGIN
            temp_ := Sales_Part_API.Get_Catalog_Type_Db(to_contract_, part_rec.part_no);
            IF (temp_ IS NOT NULL)THEN
               IF (temp_ = 'NON')THEN
                 noninv_sales_part_exist_ := 1 ;
               END IF;
            END IF;
         END;
      $END     
      IF (noninv_sales_part_exist_ = 0)THEN
         Copy (to_contract_, part_rec.part_no, from_contract_, part_rec.part_no);
      END IF;
   END LOOP;
END Copy_Part_To_Site_Impl__;


-- Pack_And_Post_Message__
--   Creates connect message for HSE transfer.
PROCEDURE Pack_And_Post_Message__ (
   action_   IN VARCHAR2,
   part_no_  IN VARCHAR2,
   contract_ IN VARCHAR2 DEFAULT NULL )
IS
   hse_contract_              VARCHAR2(5);   
   invent_attrib_rec_         Part_Catalog_Invent_Attrib_API.Public_rec;
   hse_inv_part_params_rec_   Plsqlap_Record_API.Type_Record_;
   xml_                       CLOB;
BEGIN

   invent_attrib_rec_   := Part_Catalog_Invent_Attrib_API.Get(part_no_);
   hse_contract_        := invent_attrib_rec_.hse_contract;
   
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      hse_inv_part_params_rec_ := Plsqlap_Record_API.New_Record('HSE_INV_PART_PARAMS');
      Plsqlap_Record_API.Set_Value(hse_inv_part_params_rec_, 'SITE', hse_contract_);
      Plsqlap_Record_API.Set_Value(hse_inv_part_params_rec_, 'PART_NO', part_no_);
      
      IF (action_ = 'ADDEDIT') THEN
         Plsqlap_Record_API.To_Xml(xml_, hse_inv_part_params_rec_);
         Plsqlap_Server_API.Post_Outbound_Message( xml_ => xml_,
                                                   sender_       => Fnd_Session_API.Get_Fnd_User,
                                                   receiver_     => 'HSEInventoryPart');

         Hse_Structure_Transfer_API.Transfer_Part_Structure(hse_contract_, part_no_);
      ELSIF (action_ = 'DELETE') THEN
         -- For delete operation, use custom event and Application Message event action to trigger BIZAPI
         NULL;
      END IF;
   $END
END Pack_And_Post_Message__;


-- Get_Objid__
--   This function will return Objid of a Inventory Part record given
--   contract and part number.
@UncheckedAccess
FUNCTION Get_Objid__ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   objid_      INVENTORY_PART.objid%TYPE;
   objversion_ INVENTORY_PART.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, contract_, part_no_);
   RETURN (objid_);
END Get_Objid__;


@UncheckedAccess
FUNCTION Get_Ultd_Expect_Supply_Date__ (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   lead_time_code_db_ IN VARCHAR2,
   dist_calendar_id_  IN VARCHAR2,
   manuf_calendar_id_ IN VARCHAR2,
   site_date_         IN DATE ) RETURN DATE
IS
   ultd_expected_supply_date_ DATE;
   stop_analysis_date_        DATE;
   calendar_id_               VARCHAR2(10);
BEGIN 
   IF (lead_time_code_db_ = Inv_Part_Lead_Time_Code_API.DB_PURCHASED) THEN
      calendar_id_ := dist_calendar_id_;
   ELSE
      calendar_id_ := manuf_calendar_id_;
   END IF;

   stop_analysis_date_ := Get_Stop_Analysis_Date(contract_,
                                                 part_no_,
                                                 site_date_,
                                                 dist_calendar_id_,
                                                 manuf_calendar_id_,
                                                 'TRUE',
                                                 'TRUE');
   
   -- The same method as Get_Closest_Work_Day but without internal error handling.
   ultd_expected_supply_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(calendar_id_,
                                                                                  stop_analysis_date_ + 1);

   RETURN (ultd_expected_supply_date_);

END Get_Ultd_Expect_Supply_Date__;


@UncheckedAccess
FUNCTION Get_Ultd_Manuf_Supply_Date__ (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   manuf_calendar_id_ IN VARCHAR2,
   site_date_         IN DATE ) RETURN DATE
IS
   ultd_manuf_supply_date_ DATE;
   stop_analysis_date_     DATE;
BEGIN
   stop_analysis_date_ := Get_Stop_Analysis_Date___(contract_                    => contract_,
                                                    part_no_                     => part_no_,
                                                    site_date_                   => site_date_,
                                                    dist_calendar_id_            => NULL,
                                                    manuf_calendar_id_           => manuf_calendar_id_,
                                                    detect_supplies_not_allowed_ => TRUE,
                                                    use_expected_leadtime_       => FALSE,
                                                    lead_time_code_db_           => Inv_Part_Lead_Time_Code_API.DB_MANUFACTURED);

   -- The same method as Get_Closest_Work_Day but without internal error handling.
   ultd_manuf_supply_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(manuf_calendar_id_,
                                                                               stop_analysis_date_ + 1);
   RETURN (ultd_manuf_supply_date_);

END Get_Ultd_Manuf_Supply_Date__;


@UncheckedAccess
FUNCTION Get_Ultd_Purch_Supply_Date__ (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   dist_calendar_id_  IN VARCHAR2,
   site_date_         IN DATE ) RETURN DATE
IS
   ultd_purch_supply_date_ DATE;
   stop_analysis_date_     DATE;
BEGIN
   stop_analysis_date_ := Get_Stop_Analysis_Date___(contract_                    => contract_,
                                                    part_no_                     => part_no_,
                                                    site_date_                   => site_date_,
                                                    dist_calendar_id_            => dist_calendar_id_,
                                                    manuf_calendar_id_           => NULL,
                                                    detect_supplies_not_allowed_ => TRUE,
                                                    use_expected_leadtime_       => FALSE,
                                                    lead_time_code_db_           => Inv_Part_Lead_Time_Code_API.DB_PURCHASED);

   -- The same method as Get_Closest_Work_Day but without internal error handling.
   ultd_purch_supply_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(dist_calendar_id_,
                                                                               stop_analysis_date_ + 1);
   RETURN (ultd_purch_supply_date_);

END Get_Ultd_Purch_Supply_Date__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


@UncheckedAccess
FUNCTION Get_Superseded_By (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(25);
   CURSOR get_attr IS
      SELECT part_no
       FROM inventory_part_tab
      WHERE contract   = contract_
        AND supersedes = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Superseded_By;


@UncheckedAccess
FUNCTION Get_Volume_Net (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_values IS
      SELECT t.unit_meas, t.input_unit_meas_group_id
      FROM Inventory_Part_Tab t
      WHERE t.contract = contract_
      AND t.part_no = part_no_;

   value_rec_                 get_values%ROWTYPE;
   con_factor_for_invent_uom_ NUMBER := 0;
   converted_qty_             NUMBER := 0;
BEGIN         
   OPEN get_values;
   FETCH get_values INTO value_rec_;
   CLOSE get_values;
   
   IF (value_rec_.unit_meas = Part_Catalog_Api.Get_Unit_Code(part_no_)) THEN
      -- if the part cat and the invent part has same UoM both implies 1 qty in same UoM.
      converted_qty_ := 1;
   END IF;

   -- Note : no need to consider Input UoM group .. because always if a Input UoM Grp. is there invent and partcat has same UoM.
   
   IF (converted_qty_ = 0) THEN
   -- Check the convertion factor in the unit relationships
      con_factor_for_invent_uom_ := Technical_Unit_Conv_API.Get_Valid_Conv_Factor( Part_Catalog_Api.Get_Unit_Code(part_no_), value_rec_.unit_meas);
      IF (con_factor_for_invent_uom_ IS NOT NULL) THEN
          converted_qty_ := 1 / con_factor_for_invent_uom_;
      END IF;
   END IF;
   -- IF no convertion found returned value will be 0
   RETURN (converted_qty_ * Iso_Unit_API.Get_Unit_Converted_Quantity(Part_Catalog_API.Get_Volume_Net(part_no_),
                                                                     Part_Catalog_API.Get_Uom_For_Volume_Net(part_no_),
                                                                     Company_Invent_Info_API.Get_Uom_For_Volume(Site_API.Get_Company(contract_))));
END Get_Volume_Net;


@UncheckedAccess
FUNCTION Get_Weight_Net (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   partca_rec_                Part_Catalog_API.Public_Rec;
   unit_meas_                 inventory_part_tab.unit_meas%TYPE;
   con_factor_for_invent_uom_ NUMBER := 0;
   converted_qty_             NUMBER := 0;
   weight_net_                NUMBER;
   comp_uom_for_weight_       VARCHAR2(30);  
BEGIN
   partca_rec_ := Part_Catalog_API.Get(part_no_);
   unit_meas_  := Get_Unit_Meas(contract_, part_no_);
   
   IF (partca_rec_.unit_code = unit_meas_) THEN
      -- if the part cat and the invent part has same UoM both implies 1 qty in same UoM.
      converted_qty_ := 1;
   END IF;

   -- Note : no need to consider Input UoM group .. because always if a Input UoM Grp. is there invent and partcat has same UoM.
   IF (converted_qty_ = 0) THEN
   -- Check the convertion factor in the unit relationships
      con_factor_for_invent_uom_ := Technical_Unit_Conv_API.Get_Valid_Conv_Factor( partca_rec_.unit_code, unit_meas_);
      IF (con_factor_for_invent_uom_ IS NOT NULL) THEN
          converted_qty_ := 1 / con_factor_for_invent_uom_;
      END IF;
   END IF;

   comp_uom_for_weight_ := Company_Invent_Info_API.Get_Uom_For_Weight(Site_API.Get_Company(contract_));
   IF (partca_rec_.uom_for_weight_net = comp_uom_for_weight_) THEN
      weight_net_ := converted_qty_ * partca_rec_.weight_net;
   ELSE
      weight_net_ := converted_qty_ * Iso_Unit_API.Get_Unit_Converted_Quantity(partca_rec_.weight_net,
                                                                               partca_rec_.uom_for_weight_net,
                                                                               comp_uom_for_weight_);
   END IF;
   -- IF no convertion found returned value will be 0
   RETURN weight_net_;
END Get_Weight_Net;


@Override
@UncheckedAccess
FUNCTION Get_Std_Name_Id (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS   
BEGIN
   RETURN NVL(super(contract_, part_no_),Part_Catalog_API.Get_Std_Name_Id(part_no_));
END Get_Std_Name_Id;


-- Check_Stored
--   To check whether a part is stored or not.
@UncheckedAccess
FUNCTION Check_Stored (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   temp_  NUMBER;
   CURSOR get_attr IS
      SELECT 1
      FROM   inventory_part_tab
      WHERE  contract = contract_
      AND    part_no = part_no_;
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO temp_;
   IF (get_attr%NOTFOUND) THEN
      temp_ := 0;
   END IF;
   CLOSE get_attr;
   RETURN (temp_ = 1);
END Check_Stored;


-- Count_Sites
--   Counts the number of sites where a part is registered.
@UncheckedAccess
FUNCTION Count_Sites (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR count_sites is
      SELECT count(*)
      FROM  inventory_part_tab
      WHERE part_no = part_no_;
   no_of_sites_ NUMBER;
BEGIN
   OPEN count_sites;
   FETCH count_sites into no_of_sites_;
   CLOSE count_sites;
   RETURN no_of_sites_;
END Count_Sites;


-- Check_Exist_Anywhere
--   Check if a part exists on any site. Returns TRUE if the specified part
--   exists, otherwise FALSE.
@UncheckedAccess
FUNCTION Check_Exist_Anywhere (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   inventory_part_tab
      WHERE  part_no = part_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_control;
   RETURN 'FALSE';
END Check_Exist_Anywhere;


-- Check_Exist
--   Check if the specified part exists.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_,part_no_);
END Check_Exist;


-- Check_If_Purchased
--   Returns part_no if type_code indicates a purchasepart, else returns NULL.
@UncheckedAccess
FUNCTION Check_If_Purchased (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_  inventory_part_tab.type_code%TYPE;
   CURSOR get_attr IS
      SELECT type_code
      FROM   inventory_part_tab
      WHERE  contract = contract_
      AND    part_no = part_no_;
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF temp_ IN ('3','4') THEN
      RETURN part_no_;
   ELSE
      RETURN NULL;
   END IF;
END Check_If_Purchased;

-- Check_Forecast_Part_Exist
--   Check whether any forecast part exists for inventory part.
@UncheckedAccess
FUNCTION Check_Any_Forecast_Part_Exist(
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS 
BEGIN
   $IF (Component_Demand_SYS.INSTALLED) $THEN
      RETURN  Forecast_Part_Util_API.Check_Any_Forecast_Part_Exist(contract_, part_no_);
   $ELSE
      RETURN 'FALSE';
   $END
END Check_Any_Forecast_Part_Exist;

-- Part_Exist
--   Returns 1 if the specified part exists, otherwise 0.
@UncheckedAccess
FUNCTION Part_Exist (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF Check_Exist___(contract_, part_no_) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Part_Exist;


-- Document_Connected
--   Check if any document connected.
@UncheckedAccess
FUNCTION Document_Connected (
    contract_ IN VARCHAR2,
    part_no_  IN VARCHAR2) RETURN BOOLEAN
IS
   obj_ref_exists_     VARCHAR2(5);
   document_connected_ BOOLEAN := FALSE;
   key_ref_            VARCHAR2(2000);   

BEGIN
   $IF (Component_Docman_SYS.INSTALLED) $THEN

      key_ref_ := Client_SYS.Get_Key_Reference(lu_name_,
                                                    'CONTRACT', contract_,
                                                    'PART_NO',  part_no_);
      obj_ref_exists_ := Doc_Reference_Object_API.Exist_Obj_Reference(lu_name_, key_ref_);      

      IF (obj_ref_exists_ = 'TRUE') THEN
         document_connected_ := TRUE;
      END IF;
   $END
   RETURN (document_connected_);
END Document_Connected;


-- Get_Values_For_Accounting
--   Returns information needed for MpccomAccounting.
--   Db-value is returned for type_code!
@UncheckedAccess
PROCEDURE Get_Values_For_Accounting (
   type_code_           OUT NOCOPY VARCHAR2,
   prime_commodity_     OUT NOCOPY VARCHAR2,
   second_commodity_    OUT NOCOPY VARCHAR2,
   asset_class_         OUT NOCOPY VARCHAR2,
   abc_class_           OUT NOCOPY VARCHAR2,
   engineering_group_   OUT NOCOPY VARCHAR2,
   planner_buyer_       OUT NOCOPY VARCHAR2,
   accounting_group_    OUT NOCOPY VARCHAR2,
   part_product_family_ OUT NOCOPY VARCHAR2,
   part_product_code_   OUT NOCOPY VARCHAR2,
   contract_            IN  VARCHAR2,
   part_no_             IN  VARCHAR2 )
IS
BEGIN
   Update_Cache___(contract_, part_no_);

   type_code_           := micro_cache_value_.type_code;
   prime_commodity_     := micro_cache_value_.prime_commodity;
   second_commodity_    := micro_cache_value_.second_commodity;
   asset_class_         := micro_cache_value_.asset_class;
   abc_class_           := micro_cache_value_.abc_class;
   engineering_group_   := NULL;
   planner_buyer_       := micro_cache_value_.planner_buyer;
   accounting_group_    := micro_cache_value_.accounting_group;
   part_product_family_ := micro_cache_value_.part_product_family;
   part_product_code_   := micro_cache_value_.part_product_code;
END Get_Values_For_Accounting;


@UncheckedAccess
FUNCTION Get_Inventory_Value_By_Method (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(contract_,
                                                                     part_no_,
                                                                     NULL,
                                                                     NULL,
                                                                     NULL);
END Get_Inventory_Value_By_Method;


PROCEDURE Modify_Abc_Frequency_Lifecycle (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   abc_class_          IN VARCHAR2,
   frequency_class_db_ IN VARCHAR2,
   lifecycle_stage_db_ IN VARCHAR2 )
IS
   newrec_         inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, part_no_);
   IF (abc_class_ != newrec_.abc_class) THEN
      newrec_.abc_class              := abc_class_;
      newrec_.abc_class_locked_until := NULL;
   END IF;

   IF (frequency_class_db_ != newrec_.frequency_class) THEN
      newrec_.frequency_class         := frequency_class_db_;
      newrec_.freq_class_locked_until := NULL;
   END IF;

   IF (lifecycle_stage_db_ != newrec_.lifecycle_stage) THEN
      newrec_.lifecycle_stage         := lifecycle_stage_db_;
      newrec_.life_stage_locked_until := NULL;
   END IF;
   Modify___(newrec_);
END Modify_Abc_Frequency_Lifecycle;


-- Modify_Counted_Part
--   Updates counting data for a part.
PROCEDURE Modify_Counted_Part (
   contract_       IN VARCHAR2,
   part_no_        IN VARCHAR2,
   count_variance_ IN NUMBER )
IS
   newrec_              inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_.count_variance := NVL(newrec_.count_variance, 0) + NVL(count_variance_, 0);
   Modify___(newrec_);
END Modify_Counted_Part;


-- Modify_Purch_Leadtime
--   Updates purchase lead time for a part.
PROCEDURE Modify_Purch_Leadtime (
   contract_       IN VARCHAR2,
   part_no_        IN VARCHAR2,
   purch_leadtime_ IN NUMBER )
IS
   newrec_             inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(contract_, part_no_);
   IF (newrec_.purch_leadtime != purch_leadtime_) THEN
      newrec_ := Lock_By_Keys___(contract_, part_no_);
      --Check the condition again to make sure that it hasn't been modified by someone else
      IF (newrec_.purch_leadtime != purch_leadtime_) THEN
         newrec_.purch_leadtime := purch_leadtime_;
         Modify___(newrec_);
      END IF;
   END IF;
END Modify_Purch_Leadtime;


-- Modify_Expected_Leadtime
--   Modifies the attribute ExpectedLeadtime for a part.
PROCEDURE Modify_Expected_Leadtime (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   expected_leadtime_ IN NUMBER )
IS
   newrec_ inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_.expected_leadtime := expected_leadtime_;
   Modify___(newrec_);
END Modify_Expected_Leadtime;


-- Modify_Part_Product_Code
--   Public method for modification of attribute part_product_code.
PROCEDURE Modify_Part_Product_Code (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   part_product_code_ IN VARCHAR2 )
IS
   newrec_ inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_.part_product_code := part_product_code_;
   Modify___(newrec_);
END Modify_Part_Product_Code;


-- Modify_Part_Product_Family
--   Public method for modification of attribute part product family.
PROCEDURE Modify_Part_Product_Family (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   part_product_family_ IN VARCHAR2 )
IS
   newrec_ inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_.part_product_family := part_product_family_;
   Modify___(newrec_);
END Modify_Part_Product_Family;


PROCEDURE Recalc_Stockfactors (
   contract_         IN VARCHAR2,
   second_commodity_ IN VARCHAR2,
   periods_          IN NUMBER )
IS
   attrib_       VARCHAR2(32000);
   batch_desc_   VARCHAR2(100);
BEGIN

   -- IF site is not given all user allowed sites are to be processed.
   IF contract_ IS NOT NULL THEN
      Site_API.Exist(contract_);
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;

   -- IF second commodity is not given, all second commoditys are to be processed.
   IF second_commodity_ IS NOT NULL THEN
      Commodity_Group_API.Exist(second_commodity_, true);
   END IF;

   IF (periods_ < 1) OR (trunc(periods_) != periods_) THEN
      Error_Sys.Record_General(lu_name_,'PERIODS_NA: Only positive integers are valid.');
   END IF;

   Client_SYS.Clear_Attr(attrib_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attrib_);
   Client_SYS.Add_To_Attr('SECOND_COMMODITY', second_commodity_, attrib_);
   Client_SYS.Add_To_Attr('PERIODS', periods_, attrib_);
   Trace_SYS.Message('TRACE => attrib_ = '||attrib_);
   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'BDESCCAPD: Calculate Planning Data');
   Transaction_SYS.Deferred_Call('INVENTORY_PART_API.Recalc_Stockfactors_Impl__' ,attrib_,batch_desc_);
END Recalc_Stockfactors;


-- Get_Production_Flags
--   Returns attributes used in ShopOrderProp.
--   Db-values are returned where applicable!
PROCEDURE Get_Production_Flags (
   lead_time_code_  OUT VARCHAR2,
   manuf_leadtime_  OUT NUMBER,
   purch_leadtime_  OUT NUMBER,
   planning_method_ OUT VARCHAR2,
   supply_code_     OUT VARCHAR2,
   type_code_       OUT VARCHAR2,
   unit_meas_       OUT VARCHAR2,
   contract_        IN  VARCHAR2,
   part_no_         IN  VARCHAR2 )
IS
   lu_rec_ inventory_part_tab%ROWTYPE;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(contract_, part_no_);
   lead_time_code_  := lu_rec_.lead_time_code;
   manuf_leadtime_  := lu_rec_.manuf_leadtime;
   purch_leadtime_  := lu_rec_.purch_leadtime;
   planning_method_ := Get_Planning_Method___(contract_, part_no_);
   supply_code_     := lu_rec_.supply_code;
   type_code_       := lu_rec_.type_code;
   unit_meas_       := lu_rec_.unit_meas;
END Get_Production_Flags;


-- New_Part
--   Creates a new inventory part.
--   Parameter abc_class_ in method New_Part is obsolete and should
--   be removed in the next core project.
PROCEDURE New_Part (
   contract_                      IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   accounting_group_              IN VARCHAR2,
   asset_class_                   IN VARCHAR2,
   country_of_origin_             IN VARCHAR2,
   hazard_code_                   IN VARCHAR2,
   part_product_code_             IN VARCHAR2,
   part_product_family_           IN VARCHAR2,
   part_status_                   IN VARCHAR2,
   planner_buyer_                 IN VARCHAR2,
   prime_commodity_               IN VARCHAR2,
   second_commodity_              IN VARCHAR2,
   unit_meas_                     IN VARCHAR2,
   description_                   IN VARCHAR2,
   abc_class_                     IN VARCHAR2,
   count_variance_                IN NUMBER,
   create_date_                   IN DATE,
   cycle_code_                    IN VARCHAR2,
   cycle_period_                  IN NUMBER,
   dim_quality_                   IN VARCHAR2,
   durability_day_                IN NUMBER,
   expected_leadtime_             IN NUMBER,
   inactive_obs_flag_             IN VARCHAR2,
   last_activity_date_            IN DATE,
   lead_time_code_                IN VARCHAR2,
   manuf_leadtime_                IN NUMBER,
   note_text_                     IN VARCHAR2,
   oe_alloc_assign_flag_          IN VARCHAR2,
   onhand_analysis_flag_          IN VARCHAR2,
   purch_leadtime_                IN NUMBER,
   supersedes_                    IN VARCHAR2,
   supply_code_                   IN VARCHAR2,
   type_code_                     IN VARCHAR2,
   customs_stat_no_               IN VARCHAR2,
   type_designation_              IN VARCHAR2,
   zero_cost_flag_                IN VARCHAR2,
   avail_activity_status_         IN VARCHAR2,
   eng_attribute_                 IN VARCHAR2,
   forecast_consumption_flag_     IN VARCHAR2 DEFAULT NULL,
   intrastat_conv_factor_         IN NUMBER DEFAULT NULL,
   invoice_consideration_         IN VARCHAR2 DEFAULT NULL,
   max_actual_cost_update_        IN NUMBER DEFAULT NULL,
   shortage_flag_                 IN VARCHAR2 DEFAULT NULL,
   inventory_part_cost_level_     IN VARCHAR2 DEFAULT NULL,
   std_name_id_                   IN NUMBER DEFAULT NULL,
   input_unit_meas_group_id_      IN VARCHAR2 DEFAULT NULL,
   dop_connection_                IN VARCHAR2 DEFAULT NULL,
   supply_chain_part_group_       IN VARCHAR2 DEFAULT NULL,
   ext_service_cost_method_       IN VARCHAR2 DEFAULT NULL,
   stock_management_              IN VARCHAR2 DEFAULT NULL,
   technical_coordinator_id_      IN VARCHAR2 DEFAULT NULL,
   sup_warranty_id_               IN NUMBER DEFAULT NULL,
   cust_warranty_id_              IN NUMBER DEFAULT NULL,
   estimated_material_cost_       IN NUMBER DEFAULT NULL,
   automatic_capability_check_    IN VARCHAR2 DEFAULT NULL,
   create_purchase_part_          IN VARCHAR2 DEFAULT 'TRUE',
   inventory_valuation_method_    IN VARCHAR2 DEFAULT NULL,
   negative_on_hand_              IN VARCHAR2 DEFAULT NULL,
   create_part_planning_          IN VARCHAR2 DEFAULT 'TRUE',
   catch_unit_meas_               IN VARCHAR2 DEFAULT NULL,
   part_cost_group_id_            IN VARCHAR2 DEFAULT NULL,
   qty_calc_rounding_             IN NUMBER DEFAULT NULL,
   min_durab_days_co_deliv_       IN NUMBER DEFAULT NULL,
   min_durab_days_planning_       IN NUMBER DEFAULT NULL,
   storage_width_requirement_     IN NUMBER DEFAULT NULL,
   storage_height_requirement_    IN NUMBER DEFAULT NULL,
   storage_depth_requirement_     IN NUMBER DEFAULT NULL,
   storage_volume_requirement_    IN NUMBER DEFAULT NULL,
   storage_weight_requirement_    IN NUMBER DEFAULT NULL,
   min_storage_temperature_       IN NUMBER DEFAULT NULL,
   max_storage_temperature_       IN NUMBER DEFAULT NULL,
   min_storage_humidity_          IN NUMBER DEFAULT NULL,
   max_storage_humidity_          IN NUMBER DEFAULT NULL,
   standard_putaway_qty_          IN NUMBER DEFAULT NULL,
   putaway_zone_refill_option_    IN VARCHAR2 DEFAULT NULL,
   dop_netting_db_                IN VARCHAR2 DEFAULT NULL,
   reset_config_std_cost_db_      IN VARCHAR2 DEFAULT NULL,
   co_reserve_onh_analys_flag_db_ IN VARCHAR2 DEFAULT NULL,
   mandatory_expiration_date_db_  IN VARCHAR2 DEFAULT NULL,
   region_of_origin_              IN VARCHAR2 DEFAULT NULL,
   statistical_code_              IN VARCHAR2 DEFAULT NULL,
   acquisition_origin_            IN NUMBER DEFAULT NULL,
   acquisition_reason_id_         IN VARCHAR2 DEFAULT NULL)
IS
   newrec_       inventory_part_tab%ROWTYPE;
   objid_        INVENTORY_PART.objid%TYPE;
   objversion_   INVENTORY_PART.objversion%TYPE;
   attr_         VARCHAR2(32000);
   indrec_       Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);
   Unpack___(newrec_, indrec_, attr_);

   newrec_.contract                    := NVL(contract_,                      newrec_.contract);
   newrec_.part_no                     := NVL(part_no_,                       newrec_.part_no);
   newrec_.accounting_group            := NVL(accounting_group_,              newrec_.accounting_group);
   newrec_.asset_class                 := NVL(asset_class_,                   newrec_.asset_class);
   newrec_.country_of_origin           := NVL(country_of_origin_,             newrec_.country_of_origin);
   newrec_.hazard_code                 := NVL(hazard_code_,                   newrec_.hazard_code);
   newrec_.part_product_code           := NVL(part_product_code_,             newrec_.part_product_code);
   newrec_.part_product_family         := NVL(part_product_family_,           newrec_.part_product_family);
   newrec_.part_status                 := NVL(part_status_,                   newrec_.part_status);
   newrec_.planner_buyer               := NVL(planner_buyer_,                 newrec_.planner_buyer);
   newrec_.prime_commodity             := NVL(prime_commodity_,               newrec_.prime_commodity);
   newrec_.second_commodity            := NVL(second_commodity_,              newrec_.second_commodity);
   newrec_.unit_meas                   := NVL(unit_meas_,                     newrec_.unit_meas);
   newrec_.description                 := NVL(description_,                   newrec_.description);
   newrec_.cycle_code                  := NVL(Inventory_Part_Count_Type_API.Encode(cycle_code_),                  newrec_.cycle_code);
   newrec_.cycle_period                := NVL(cycle_period_,                  newrec_.cycle_period);
   newrec_.dim_quality                 := NVL(dim_quality_,                   newrec_.dim_quality);
   newrec_.durability_day              := NVL(durability_day_,                newrec_.durability_day);
   newrec_.expected_leadtime           := NVL(expected_leadtime_,             newrec_.expected_leadtime);
   newrec_.lead_time_code              := NVL(Inv_Part_Lead_Time_Code_API.Encode(lead_time_code_),                newrec_.lead_time_code);
   newrec_.manuf_leadtime              := NVL(manuf_leadtime_,                newrec_.manuf_leadtime);
   newrec_.note_text                   := NVL(note_text_,                     newrec_.note_text);
   newrec_.oe_alloc_assign_flag        := NVL(Cust_Ord_Reservation_Type_API.Encode(oe_alloc_assign_flag_),        newrec_.oe_alloc_assign_flag);
   newrec_.onhand_analysis_flag        := NVL(Inventory_Part_Onh_Analys_API.Encode(onhand_analysis_flag_),        newrec_.onhand_analysis_flag);
   newrec_.purch_leadtime              := NVL(purch_leadtime_,                newrec_.purch_leadtime);
   newrec_.supersedes                  := NVl(supersedes_,                    newrec_.supersedes);
   newrec_.supply_code                 := NVL(Material_Requis_Supply_API.Encode(supply_code_),                    newrec_.supply_code);
   newrec_.type_code                   := NVL(Inventory_Part_Type_API.Encode(type_code_),                         newrec_.type_code);
   newrec_.customs_stat_no             := NVL(customs_stat_no_,               newrec_.customs_stat_no);
   newrec_.type_designation            := NVL(type_designation_,              newrec_.type_designation);
   newrec_.zero_cost_flag              := NVL(Inventory_Part_Zero_Cost_API.Encode(zero_cost_flag_),               newrec_.zero_cost_flag);
   newrec_.avail_activity_status       := NVL(Inventory_Part_Avail_Stat_API.Encode(avail_activity_status_),       newrec_.avail_activity_status);
   newrec_.eng_attribute               := NVL(eng_attribute_,                 newrec_.eng_attribute);
   newrec_.forecast_consumption_flag   := NVL(Inv_Part_Forecast_Consum_API.Encode(forecast_consumption_flag_),    Inv_Part_Forecast_Consum_API.DB_NO_ONLINE_CONSUMPTION);
   newrec_.intrastat_conv_factor       := NVL(intrastat_conv_factor_,         newrec_.intrastat_conv_factor);
   newrec_.invoice_consideration       := NVL(Invoice_Consideration_API.Encode(invoice_consideration_),           newrec_.invoice_consideration);
   newrec_.max_actual_cost_update      := NVL(max_actual_cost_update_,        newrec_.max_actual_cost_update);
   newrec_.shortage_flag               := NVL(Inventory_Part_Shortage_API.Encode(shortage_flag_),                 newrec_.shortage_flag);
   newrec_.inventory_part_cost_level   := NVL(Inventory_Part_Cost_Level_API.Encode(inventory_part_cost_level_),   newrec_.inventory_part_cost_level);
   newrec_.std_name_id                 := NVL(std_name_id_,                   newrec_.std_name_id);
   newrec_.input_unit_meas_group_id    := NVL(input_unit_meas_group_id_,      newrec_.input_unit_meas_group_id);
   newrec_.dop_connection              := NVL(Dop_Connection_API.Encode(dop_connection_),                         newrec_.dop_connection);
   newrec_.supply_chain_part_group     := NVL(supply_chain_part_group_,       newrec_.supply_chain_part_group);
   newrec_.ext_service_cost_method     := NVL(Ext_Service_Cost_Method_API.Encode(ext_service_cost_method_),       newrec_.ext_service_cost_method);
   newrec_.stock_management            := NVL(Inventory_Part_Management_API.Encode(stock_management_),            newrec_.stock_management);
   newrec_.technical_coordinator_id    := NVL(technical_coordinator_id_,      newrec_.technical_coordinator_id);
   newrec_.sup_warranty_id             := NVL(sup_warranty_id_,               newrec_.sup_warranty_id);
   newrec_.cust_warranty_id            := NVL(cust_warranty_id_,              newrec_.cust_warranty_id);
   newrec_.automatic_capability_check  := NVL(Capability_Check_Allocate_API.Encode(automatic_capability_check_),  newrec_.automatic_capability_check);
   newrec_.inventory_valuation_method  := NVL(Inventory_Value_Method_API.Encode(inventory_valuation_method_),     newrec_.inventory_valuation_method);
   newrec_.negative_on_hand            := NVL(Negative_On_Hand_API.Encode(negative_on_hand_),                     newrec_.negative_on_hand);
   newrec_.catch_unit_meas             := NVL(catch_unit_meas_,               newrec_.catch_unit_meas);
   newrec_.part_cost_group_id          := NVL(part_cost_group_id_,            newrec_.part_cost_group_id);
   newrec_.min_durab_days_co_deliv     := NVL(min_durab_days_co_deliv_,       newrec_.min_durab_days_co_deliv);
   newrec_.qty_calc_rounding           := NVL(qty_calc_rounding_,             newrec_.qty_calc_rounding);
   newrec_.min_durab_days_planning     := NVL(min_durab_days_planning_,       newrec_.min_durab_days_planning);
   newrec_.storage_width_requirement   := NVL(storage_width_requirement_,     newrec_.storage_width_requirement);
   newrec_.storage_height_requirement  := NVL(storage_height_requirement_,    newrec_.storage_height_requirement);
   newrec_.storage_depth_requirement   := NVL(storage_depth_requirement_,     newrec_.storage_depth_requirement);
   newrec_.storage_volume_requirement  := NVL(storage_volume_requirement_,    newrec_.storage_volume_requirement);
   newrec_.storage_weight_requirement  := NVL(storage_weight_requirement_,    newrec_.storage_weight_requirement);
   newrec_.min_storage_temperature     := NVL(min_storage_temperature_,       newrec_.min_storage_temperature);
   newrec_.max_storage_temperature     := NVL(max_storage_temperature_,       newrec_.max_storage_temperature);
   newrec_.min_storage_humidity        := NVL(min_storage_humidity_,          newrec_.min_storage_humidity);
   newrec_.max_storage_humidity        := NVL(max_storage_humidity_,          newrec_.max_storage_humidity);
   newrec_.standard_putaway_qty        := NVL(standard_putaway_qty_,          newrec_.standard_putaway_qty);
   newrec_.putaway_zone_refill_option  := NVL(Putaway_Zone_Refill_Option_API.Encode(putaway_zone_refill_option_), newrec_.putaway_zone_refill_option );
   newrec_.dop_netting                 := NVL(dop_netting_db_,                newrec_.dop_netting);
   newrec_.reset_config_std_cost       := NVL(reset_config_std_cost_db_,      newrec_.reset_config_std_cost);
   newrec_.co_reserve_onh_analys_flag  := NVL(co_reserve_onh_analys_flag_db_, newrec_.co_reserve_onh_analys_flag);
   newrec_.mandatory_expiration_date   := NVL(mandatory_expiration_date_db_,  newrec_.mandatory_expiration_date);
   newrec_.region_of_origin            := NVL(region_of_origin_,              newrec_.region_of_origin);
   newrec_.abc_class                   := NVL(abc_class_,                     newrec_.abc_class);
   -- gelr: good_service_statistical_code, acquisition_origin and  brazilian_specific_attributes added to newrec_.
   newrec_.statistical_code            := NVL(statistical_code_,              newrec_.statistical_code);
   newrec_.acquisition_origin          := NVL(acquisition_origin_,            newrec_.acquisition_origin);
   newrec_.acquisition_reason_id       := NVL(acquisition_reason_id_,         newrec_.acquisition_reason_id);

   Client_SYS.Clear_Attr(attr_);
   IF (estimated_material_cost_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('ESTIMATED_MATERIAL_COST', estimated_material_cost_, attr_);
   END IF;
   indrec_ := Get_Indicator_Rec___(newrec_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_, create_purchase_part_, create_part_planning_);
END New_Part;


PROCEDURE Qty_To_Order (
   requisition_no_  IN OUT VARCHAR2,
   qty_ordered_     IN OUT NUMBER,
   disp_qty_onhand_ IN OUT NUMBER,
   contract_        IN     VARCHAR2,
   part_no_         IN     VARCHAR2,
   date_required_   IN     DATE,
   type_code_       IN     VARCHAR2,
   lu_req_exist_    IN     BOOLEAN,
   lu_shp_exist_    IN     BOOLEAN,
   create_req_      IN     NUMBER,
   authorize_code_  IN     VARCHAR2,
   order_point_qty_ IN     NUMBER )
IS   
   stmt_                VARCHAR2(2000);
   planning_method_     VARCHAR2(1);
   unit_meas_           VARCHAR2(10);
   lot_size_            NUMBER;
   lot_count_           NUMBER;
   line_no_             NUMBER;
   order_code_          VARCHAR2(3);
   requisition_code_    VARCHAR2(20);
   demand_code_         VARCHAR2(200);
   release_no_          VARCHAR2(4);
   use_split_           BOOLEAN := FALSE;
   qty_to_make_         NUMBER;
   qty_to_buy_          NUMBER;
   wanted_receipt_date_ DATE;
   lead_time_code_db_   VARCHAR2(20);
   date_req_            DATE;
   nulln_               NUMBER;
   calendar_id_         VARCHAR2(10);
   part_planning_rec_   Inventory_Part_Planning_API.Public_Rec;
   inventory_part_rec_  inventory_part_tab%ROWTYPE;
   multi_site_planned_  VARCHAR2(50);
   primary_supplier_    VARCHAR2(100);
   planned_due_date_    DATE;
BEGIN
   line_no_            := 0;
   inventory_part_rec_ := Get_Object_By_Keys___(contract_, part_no_);
   unit_meas_          := inventory_part_rec_.unit_meas;
   lead_time_code_db_  := inventory_part_rec_.lead_time_code;

   part_planning_rec_  := Inventory_Part_Planning_API.Get(contract_, part_no_);
   planning_method_    := part_planning_rec_.planning_method;
   lot_size_           := part_planning_rec_.lot_size;

   date_req_ := date_required_;
   Trace_SYS.Message('Date required: '||date_req_);
   calendar_id_ := Site_API.Get_Dist_Calendar_Id (contract_);
   Trace_SYS.Message('after site calendar id');

   -- Is_Working_Day returns 0 if FALSE
   IF (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, date_req_ ) = 0) THEN
      Trace_SYS.Message('working day');

      date_req_ := Work_Time_Calendar_API.Get_Previous_Work_Day(calendar_id_,date_req_);
      Trace_SYS.Message('previous work day '||date_req_);

      IF (date_req_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOT_IN_CAL_QORD: Retrieving next work day from :P1 failed. The date is outside the interval of the calendar :P2.', to_char(date_req_, 'YYYY-MM-DD'), calendar_id_);
      END IF;
      Trace_SYS.Message('Adjusted Date required: '||date_req_);
   END IF;

   IF (planning_method_ = 'B') THEN
      IF (lot_size_ = 0) THEN
         lot_size_ := 1;
      END IF;
      lot_count_ := 1;
      -- Round result of shrinkage to the most conservative number with 12 decimals.
      WHILE (trunc((lot_count_ * lot_size_ + disp_qty_onhand_), 12) < order_point_qty_) LOOP
         lot_count_ := lot_count_ + 1;
      END LOOP;
      qty_ordered_ := lot_count_ * lot_size_;
   ELSIF (planning_method_ = 'C') THEN
      qty_ordered_ := GREATEST(lot_size_, order_point_qty_) - disp_qty_onhand_;
   END IF;

   qty_ordered_ := qty_ordered_ / (1 - (part_planning_rec_.shrinkage_fac / 100));

   IF create_req_ = 1 THEN
      -- Check if make/buy split
      -- Purchase Requistion and Shop Order Requisition must have been installed in order to
      -- split between Purch/Shpord
      IF part_planning_rec_.split_manuf_acquired = 'SPLIT' AND lu_req_exist_ AND
         lu_shp_exist_ THEN
         use_split_ := TRUE;
         IF lead_time_code_db_ = 'P' THEN
            -- split for manufactured
            qty_to_make_ := part_planning_rec_.percent_manufactured/100 * qty_ordered_;
            qty_to_buy_  := qty_ordered_ - qty_to_make_;
         ELSE
            -- split for purchased
            qty_to_buy_  := part_planning_rec_.percent_acquired/100 * qty_ordered_;
            qty_to_make_ := qty_ordered_ - qty_to_buy_;
         END IF;
      ELSE
         IF lead_time_code_db_ = 'P' THEN
            qty_to_buy_  := qty_ordered_;
         ELSE
            qty_to_make_ := qty_ordered_;
         END IF;
      END IF;

      qty_to_buy_  := Get_Calc_Rounded_Qty(contract_, part_no_, qty_to_buy_);
      qty_to_make_ := Get_Calc_Rounded_Qty(contract_, part_no_, qty_to_make_);

      disp_qty_onhand_ := disp_qty_onhand_ + qty_ordered_;
      wanted_receipt_date_ := date_req_; -- Do not keep changing this to order_date_ because it's wrong!
      Trace_SYS.Message('wanted receipt date '||wanted_receipt_date_);

      -- IF order_requisition_ is set we will create an order directly without
      -- passing requisitions or collecting $200.
      Trace_SYS.Field('lead_time_code_db_',lead_time_code_db_);

      requisition_code_ := Mpccom_Defaults_API.Get_Char_Value('ORDPNT', 'REQUISITION_HEADER', 'REQUISITIONER_CODE');

      IF use_split_ THEN
         IF lu_shp_exist_ AND part_planning_rec_.manuf_supply_type IN ('R','O') THEN
            stmt_ :=
              'BEGIN
                  Shop_Order_Prop_API.Generate_Proposal
                    (:requisition_no, :part_no, :contract,
                     :nulln1, :wanted_receipt_date, :original_qty,
                     Shop_Proposal_Type_API.Decode(''INV''));
               END;';

            @ApproveDynamicStatement(2006-05-31,mushlk)
            EXECUTE IMMEDIATE stmt_
               USING OUT requisition_no_,
                     IN  part_no_,
                     IN  contract_,
                     IN  nulln_,
                     IN  wanted_receipt_date_,
                     IN  qty_to_make_;
         ELSIF part_planning_rec_.manuf_supply_type = 'S' THEN
            Error_SYS.Record_General(lu_name_, 'INVALID_SUPPLY_TYPE: Invalid supply type for part :P1. Supply type :P2 is not allowed.',
                                     part_no_, Inventory_Part_Supply_Type_API.Decode(part_planning_rec_.manuf_supply_type));
         END IF;
         IF lu_req_exist_ AND part_planning_rec_.acquired_supply_type = 'O' THEN
            stmt_ := '
               DECLARE
                  primary_supplier_ VARCHAR2(100);
               BEGIN
                  primary_supplier_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(:contract, :part_no);
                  :multi_site_planned := Purchase_Part_Supplier_API.Get_Multisite_Planned_Part_Db(:contract, :part_no, primary_supplier_);
                  :primary_supplier := primary_supplier_;
               END;';

            @ApproveDynamicStatement(2006-01-23,nidalk)
            EXECUTE IMMEDIATE stmt_
               USING IN  contract_,
                     IN  part_no_,
                     OUT multi_site_planned_,
                     OUT primary_supplier_;

            IF (nvl(multi_site_planned_, Database_SYS.string_null_) = 'MULTISITE_PLAN') THEN
               -- Create DO
               $IF (Component_Disord_SYS.INSTALLED) $THEN
                  Distribution_Order_API.Create_Distribution_Order(planned_due_date_,
                                                                   requisition_no_,
                                                                   qty_to_buy_,
                                                                   Supplier_API.Get_Acquisition_Site(primary_supplier_),
                                                                   contract_,
                                                                   part_no_,
                                                                   requisition_code_,
                                                                   NULL,
                                                                   wanted_receipt_date_);
               $ELSE
                  Add_To_Purchase_Order___(requisition_no_, contract_, part_no_, qty_to_buy_, unit_meas_, wanted_receipt_date_, authorize_code_);
               $END               
            ELSE
               -- Create PO
               Add_To_Purchase_Order___(requisition_no_, contract_, part_no_, qty_to_buy_, unit_meas_, wanted_receipt_date_, authorize_code_);
            END IF;
         ELSIF lu_req_exist_ AND part_planning_rec_.acquired_supply_type = 'R' THEN
            -- Create PO requisitions
            IF ((line_no_ = 0) OR (line_no_ >= 9999)) THEN
               line_no_ := 1;
               order_code_ := '1';
               stmt_ := 'BEGIN
                            Purchase_Req_Util_API.New_Requisition(:requisition_no, :order_code, :contract, :requisition_code, :mark_for);
                         END;';
               @ApproveDynamicStatement(2006-01-23,nidalk)
               EXECUTE IMMEDIATE stmt_
                  USING OUT requisition_no_,
                        IN  order_code_,
                        IN  contract_,
                        IN  requisition_code_,
                        IN  ' ';
            END IF;


            release_no_    := '1';
            demand_code_   := Order_Supply_Type_API.Decode('IO');

            stmt_ := 'BEGIN
                         Purchase_Req_Util_API.New_Line_Part(:line_no, :release_no, :requisition_no,
                           :contract, :part_no, :unit_meas, :original_qty, :wanted_receipt_date,
                           :demand_code);
                      END;';

            @ApproveDynamicStatement(2006-05-31,mushlk)
            EXECUTE IMMEDIATE stmt_
                  USING IN OUT line_no_,
                        IN OUT release_no_,
                        IN     requisition_no_,
                        IN     contract_,
                        IN     part_no_,
                        IN     unit_meas_,
                        IN     qty_to_buy_,
                        IN     wanted_receipt_date_,
                        IN     demand_code_;

         ELSIF part_planning_rec_.acquired_supply_type = 'S' THEN
            Error_SYS.Record_General(lu_name_, 'INVALID_SUPPLY_TYPE: Invalid supply type for part :P1. Supply type :P2 is not allowed.',
                                     part_no_, Inventory_Part_Supply_Type_API.Decode(part_planning_rec_.acquired_supply_type));
         END IF;
      ELSE
         IF (lu_req_exist_ AND part_planning_rec_.order_requisition = 'O' AND
             lead_time_code_db_ = 'P') THEN
            stmt_ := '
               DECLARE
                  primary_supplier_ VARCHAR2(100);
               BEGIN
                  primary_supplier_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(:contract, :part_no);
                  :multi_site_planned := Purchase_Part_Supplier_API.Get_Multisite_Planned_Part_Db(:contract, :part_no, primary_supplier_);
                  :primary_supplier := primary_supplier_;
               END;';

            @ApproveDynamicStatement(2006-01-23,nidalk)
            EXECUTE IMMEDIATE stmt_
               USING IN  contract_,
                     IN  part_no_,
                     OUT multi_site_planned_,
                     OUT primary_supplier_;

             IF (nvl(multi_site_planned_, Database_SYS.string_null_) = 'MULTISITE_PLAN' ) THEN
                $IF (Component_Disord_SYS.INSTALLED) $THEN
                  Distribution_Order_API.Create_Distribution_Order(planned_due_date_,
                                                                   requisition_no_,
                                                                   qty_to_buy_,
                                                                   Supplier_API.Get_Acquisition_Site(primary_supplier_),
                                                                   contract_,
                                                                   part_no_,
                                                                   requisition_code_,
                                                                   NULL,
                                                                   wanted_receipt_date_);
               $ELSE
                  Add_To_Purchase_Order___(requisition_no_, contract_, part_no_, qty_to_buy_, unit_meas_, wanted_receipt_date_, authorize_code_);
               $END     
             ELSE
               -- SHVE using the same out param requisition_no to return order_no
               Add_To_Purchase_Order___(requisition_no_, contract_, part_no_, qty_to_buy_, unit_meas_, wanted_receipt_date_, authorize_code_);
            END IF;
         ELSIF (lu_req_exist_ AND part_planning_rec_.order_requisition = 'R' AND lead_time_code_db_ = 'P') THEN
            -- Create requisitions
            IF ((line_no_ = 0) OR (line_no_ >= 9999)) THEN
               line_no_ := 1;
               order_code_ := '1';
               stmt_ := 'BEGIN
                            Purchase_Req_Util_API.New_Requisition(:requisition_no, :order_code, :contract, :requisition_code, :mark_for);
                         END;';
               @ApproveDynamicStatement(2006-01-23,nidalk)
               EXECUTE IMMEDIATE stmt_
                  USING OUT requisition_no_,
                        IN  order_code_,
                        IN  contract_,
                        IN  requisition_code_,
                        IN  ' ';
            END IF;


            release_no_    := '1';
            demand_code_   := Order_Supply_Type_API.Decode('IO');

            stmt_ := 'BEGIN
                         Purchase_Req_Util_API.New_Line_Part(:line_no, :release_no, :requisition_no,
                           :contract, :part_no, :unit_meas, :original_qty, :wanted_receipt_date,
                           :demand_code);
                      END;';

            @ApproveDynamicStatement(2006-05-31,mushlk)
            EXECUTE IMMEDIATE stmt_
                  USING IN OUT line_no_,
                        IN OUT release_no_,
                        IN     requisition_no_,
                        IN     contract_,
                        IN     part_no_,
                        IN     unit_meas_,
                        IN     qty_to_buy_,
                        IN     wanted_receipt_date_,
                        IN     demand_code_;
         ELSIF (part_planning_rec_.order_requisition = 'S' AND lead_time_code_db_ = 'P') THEN
            Error_SYS.Record_General(lu_name_, 'INVALID_SUPPLY_TYPE: Invalid supply type for part :P1. Supply type :P2 is not allowed.',
                                     part_no_, Inventory_Part_Supply_Type_API.Decode(part_planning_rec_.order_requisition));
         END IF;

         IF (lu_shp_exist_ AND part_planning_rec_.order_requisition IN ('O','R') AND
             lead_time_code_db_ = 'M') THEN
            stmt_ :=
              'BEGIN
                  Shop_Order_Prop_API.Generate_Proposal
                    (:requisition_no, :part_no, :contract,
                     :nulln1, :wanted_receipt_date, :original_qty,
                     Shop_Proposal_Type_API.Decode(''INV''));
               END;';

            @ApproveDynamicStatement(2006-05-31,mushlk)
            EXECUTE IMMEDIATE stmt_
               USING OUT requisition_no_,
                     IN  part_no_,
                     IN  contract_,
                     IN  nulln_,
                     IN  wanted_receipt_date_,
                     IN  qty_to_make_;
         ELSIF (part_planning_rec_.order_requisition = 'S' AND lead_time_code_db_ = 'M') THEN
            Error_SYS.Record_General(lu_name_, 'INVALID_SUPPLY_TYPE: Invalid supply type for part :P1. Supply type :P2 is not allowed.',
                                     part_no_, Inventory_Part_Supply_Type_API.Decode(part_planning_rec_.order_requisition));
         END IF;
      END IF; -- end if use_split
      Trace_SYS.Message('INVENTORY_PART_API.' || 'Qty_To_Order.' ||
         ' New_requisition_no: ' || requisition_no_ ||
         ' Wanted_receipt_date: ' || to_char(wanted_receipt_date_, 'yyyymmdd') ||
         ' Qty To Order (before shrinkage rounding): '|| qty_ordered_);
   END IF;
END Qty_To_Order;


-- Check_If_Counting
--   Checks if part should be included in counting report.
@UncheckedAccess
FUNCTION Check_If_Counting (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   second_commodity_ IN VARCHAR2,
   cycle_code_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN NULL;
END Check_If_Counting;


-- Set_Avail_Activity_Status
--   Sets the attribute AvailActivityStatus.
PROCEDURE Set_Avail_Activity_Status (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   newrec_     inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(contract_, part_no_);
   IF (newrec_.avail_activity_status != 'CHANGED') THEN
      newrec_ := Lock_By_Keys___(contract_, part_no_);
      --Check the condition again to make sure that it hasn't been modified by someone else
      IF (newrec_.avail_activity_status != 'CHANGED') THEN
         newrec_.avail_activity_status := Inventory_Part_Avail_Stat_API.DB_CHANGED;
         Modify___(newrec_);
      END IF;
   END IF;
END Set_Avail_Activity_Status;


-- Clear_Avail_Activity_Status
--   Clears the attribute AvailActivityStatus.
PROCEDURE Clear_Avail_Activity_Status (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   newrec_     inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(contract_, part_no_);
   IF (newrec_.avail_activity_status != 'UNCHANGED') THEN
      newrec_ := Lock_By_Keys___(contract_, part_no_);
      --Check the condition again to make sure that it hasn't been modified by someone else
      IF (newrec_.avail_activity_status != 'UNCHANGED') THEN
         newrec_.avail_activity_status := Inventory_Part_Avail_Stat_API.DB_UNCHANGED;
         Modify___(newrec_);
      END IF;
   END IF;
END Clear_Avail_Activity_Status;


-- Get_Stop_Analysis_Date
--   The method uses the expected lead time for the inventory part and
--   also uses the Shop Calendar. It returns the date of the actual
--   workday that is the first workday beyond the lead time span based
--   on today's date
@UncheckedAccess
FUNCTION Get_Stop_Analysis_Date (
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   site_date_                   IN DATE,
   dist_calendar_id_            IN VARCHAR2,
   manuf_calendar_id_           IN VARCHAR2,
   detect_supplies_not_allowed_ IN VARCHAR2,
   use_expected_leadtime_       IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_true ) RETURN DATE
IS
BEGIN
   Update_Cache___(contract_, part_no_);

   RETURN (Get_Stop_Analysis_Date___(contract_,
                                     part_no_,
                                     site_date_,
                                     dist_calendar_id_,
                                     manuf_calendar_id_,
                                     (detect_supplies_not_allowed_ = Fnd_Boolean_API.db_true),
                                     (use_expected_leadtime_       = Fnd_Boolean_API.db_true),
                                     micro_cache_value_.lead_time_code));
END Get_Stop_Analysis_Date;


-- Check_If_Manufactured
--   Checks if a part is manufactured. Returns 1 if manufactured else 0.
@UncheckedAccess
FUNCTION Check_If_Manufactured (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ inventory_part_tab.type_code%TYPE;
   CURSOR get_attr IS
      SELECT type_code
      FROM   inventory_part_tab
      WHERE  contract = contract_
      AND    part_no = part_no_;
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF temp_ IN ('1','2') THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_If_Manufactured;


-- Modify_Manuf_Leadtime
--   Modifying manufacturing leadtime.
PROCEDURE Modify_Manuf_Leadtime (
   contract_       IN VARCHAR2,
   part_no_        IN VARCHAR2,
   manuf_leadtime_ IN NUMBER )
IS
   newrec_  inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_.manuf_leadtime := manuf_leadtime_;
   Modify___(newrec_);
END Modify_Manuf_Leadtime;


-- Copy
--   Method creates new instance and copies all public attributes from
--   old part. The copying can be overridden by sending in specific values
--   via the attribute string.
PROCEDURE Copy (
   new_contract_             IN VARCHAR2,
   new_part_no_              IN VARCHAR2,
   old_contract_             IN VARCHAR2,
   old_part_no_              IN VARCHAR2,
   attr_                     IN VARCHAR2 DEFAULT NULL,
   error_when_no_source_     IN VARCHAR2 DEFAULT 'TRUE',
   error_when_existing_copy_ IN VARCHAR2 DEFAULT 'TRUE',
   create_purchase_part_     IN VARCHAR2 DEFAULT 'TRUE' )
IS
BEGIN
   Copy_Impl___(new_contract_,
                new_part_no_,
                old_contract_,
                old_part_no_,
                attr_,
                error_when_no_source_,
                error_when_existing_copy_,
                create_purchase_part_);
   IF (Check_Exist___(old_contract_, old_part_no_)) THEN
      Inventory_Part_Planning_API.Copy(new_contract_, new_part_no_,
                                       old_contract_, old_part_no_);

      Inventory_Part_Capability_API.Copy(new_contract_, new_part_no_,
                                         old_contract_, old_part_no_);
      
      Invent_Part_Putaway_Zone_API.Copy(new_contract_, new_part_no_,
                                        old_contract_, old_part_no_);
   END IF;
END Copy;


-- Copy_Part_To_Site
--   Copy all the parts from From site with SecondCommodity equal to
--   FromSecondCommodity to To site that doesn't exist on the To site.
PROCEDURE Copy_Part_To_Site (
   from_contract_         IN VARCHAR2,
   from_second_commodity_ IN VARCHAR2,
   to_contract_           IN VARCHAR2 )
IS
   attrib_     VARCHAR2(32000);
   batch_desc_ VARCHAR2(100);
BEGIN
   Site_API.Exist(from_contract_);
   Site_API.Exist(to_contract_);
   User_Allowed_Site_api.Exist(Fnd_Session_API.Get_Fnd_User, from_contract_);
   User_Allowed_Site_api.Exist(Fnd_Session_API.Get_Fnd_User, to_contract_);
   IF from_contract_ = to_contract_ THEN
      Error_SYS.Record_General(lu_name_, 'ERRORSAMECONTRACT: You must select different sites.');
   END IF;

   Commodity_Group_API.Exist_With_Wildcard(NVL(from_second_commodity_, '%'));

   Client_SYS.Clear_Attr(attrib_);
   Client_SYS.Add_To_Attr('FROM_CONTRACT', from_contract_, attrib_);
   Client_SYS.Add_To_Attr('FROM_SECOND_COMMODITY', NVL(from_second_commodity_, '%'), attrib_);
   Client_SYS.Add_To_Attr('TO_CONTRACT', to_contract_, attrib_);
   Trace_SYS.Message('TRACE => attrib_ = '||attrib_);
   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'BDESCCOPP: Copy Part To Site');
   Transaction_SYS.Deferred_Call('Inventory_Part_API.Copy_Part_To_Site_Impl__', attrib_,batch_desc_);
END Copy_Part_To_Site;

FUNCTION Get_Cumm_Leadtime (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS    
   temp_ NUMBER;
BEGIN
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      temp_ := Manuf_Part_Attribute_API.Get_Cum_Leadtime(contract_, part_no_);
   $END
   RETURN temp_;
END Get_Cumm_Leadtime;


@UncheckedAccess
FUNCTION Get_Mrp_Order_Code (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Planning_Method___(contract_, part_no_);
END Get_Mrp_Order_Code;


-- Get_No_Of_Purchase_Parts
--   This functions will return the number of purchase part for a specific
--   contract which is needed for calculations in the costing module.
@UncheckedAccess
FUNCTION Get_No_Of_Purchase_Parts (
   contract_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_pur_parts IS
     SELECT COUNT(*)
     FROM inventory_part_tab
     WHERE contract = contract_
     AND   lead_time_code = 'P';
   no_of_pur_parts_ NUMBER;
BEGIN
   OPEN get_pur_parts;
   FETCH get_pur_parts INTO no_of_pur_parts_;
   CLOSE get_pur_parts;
   RETURN no_of_pur_parts_;
END Get_No_Of_Purchase_Parts;


PROCEDURE Calc_Purch_Costs (
   contract_      IN VARCHAR2,
   cost_set_type_ IN VARCHAR2,
   begin_date_    IN DATE,
   end_date_      IN DATE )
IS
BEGIN
   Inventory_Part_Config_API.Calc_Purch_Costs(contract_,
                                              cost_set_type_,
                                              begin_date_,
                                              end_date_);
END Calc_Purch_Costs;


-- Modify_Part_Cost_Group_Id
--   Modifies the PartCostGroupId for the specified part.
PROCEDURE Modify_Part_Cost_Group_Id (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   part_cost_group_id_ IN VARCHAR2 )
IS
   newrec_  inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_.part_cost_group_id := part_cost_group_id_;
   Modify___(newrec_);
END Modify_Part_Cost_Group_Id;


-- Get_No_Of_Parts
--   Counts all inventory parts on one site.
@UncheckedAccess
FUNCTION Get_No_Of_Parts (
   contract_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_parts IS
      SELECT COUNT(*)
      FROM inventory_part_tab
      WHERE contract = contract_;
   no_of_parts_ NUMBER;
BEGIN
   OPEN get_parts;
   FETCH get_parts INTO no_of_parts_;
   CLOSE get_parts;
   RETURN no_of_parts_;
END Get_No_Of_Parts;


-- Get_Invent_Valuation_Method_Db
--   Fetches the database value of the inventory valuation method for the part.
@UncheckedAccess
FUNCTION Get_Invent_Valuation_Method_Db (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.inventory_valuation_method%TYPE;
   CURSOR get_attr IS
      SELECT inventory_valuation_method
      FROM inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Invent_Valuation_Method_Db;


-- Get_Invent_Part_Cost_Level_Db
--   Fetches the database value of the Inventory Part Cost Level for the part.
@UncheckedAccess
FUNCTION Get_Invent_Part_Cost_Level_Db (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.inventory_part_cost_level%TYPE;
   CURSOR get_attr IS
      SELECT inventory_part_cost_level
      FROM inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Invent_Part_Cost_Level_Db;


-- Get_Forecast_Consump_Flag_Db
--   This method will return the forecast consumption flag as a db value.
@UncheckedAccess
FUNCTION Get_Forecast_Consump_Flag_Db (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.forecast_consumption_flag%TYPE;
   CURSOR get_attr IS
      SELECT forecast_consumption_flag
      FROM inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Forecast_Consump_Flag_Db;

-- Get_Forecast_Trans_Start_Date
--   This method will return the latest Transaction_Start_Date 
--   considering all forecast parts connected to inventory part.
@UncheckedAccess
FUNCTION Get_Forecast_Trans_Start_Date (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   $IF (Component_Demand_SYS.INSTALLED) $THEN
     RETURN  Forecast_Part_Util_API.Get_Latest_Trans_Start_Date(contract_, part_no_);
   $ELSE
     RETURN NULL;
   $END
END Get_Forecast_Trans_Start_Date;

-- Get_Forecast_Phase_In_Date
--   This method will return the latest Phase_In_Date 
--   considering all forecast parts connected to inventory part.
@UncheckedAccess
FUNCTION Get_Forecast_Phase_In_Date (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   $IF (Component_Demand_SYS.INSTALLED) $THEN
     RETURN  Forecast_Part_Util_API.Get_Latest_Phase_In_Date(contract_, part_no_);
   $ELSE
     RETURN NULL;
   $END
END Get_Forecast_Phase_In_Date;

-- Get_Forecast_Phase_Out_Date
--   This method will return the latest Phase_Out_Date 
--   considering all forecast parts connected to inventory part.
@UncheckedAccess
FUNCTION Get_Forecast_Phase_Out_Date (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   $IF (Component_Demand_SYS.INSTALLED) $THEN
     RETURN  Forecast_Part_Util_API.Get_Latest_Phase_Out_Date(contract_, part_no_);
   $ELSE
     RETURN NULL;
   $END
END Get_Forecast_Phase_Out_Date;

-- Get_Forecast_Service_Level
--   This method will return the Serice level of a master flow part 
--   considering all forecast parts connected to inventory part.
@UncheckedAccess
FUNCTION Get_Forecast_Service_Level (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   $IF (Component_Demand_SYS.INSTALLED) $THEN
      RETURN  Forecast_Part_Util_API.Get_Master_Flow_Service_Level(contract_, part_no_);
   $ELSE
     RETURN NULL;
   $END
END Get_Forecast_Service_Level;

-- Get_Forecast_Fill_Rate
--   This method will return the Fill Rate of a master flow part 
--   considering all forecast parts connected to inventory part.
@UncheckedAccess
FUNCTION Get_Forecast_Fill_Rate (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   $IF (Component_Demand_SYS.INSTALLED) $THEN
     RETURN  Forecast_Part_Util_API.Get_Master_Flow_Fill_Rate(contract_, part_no_);
   $ELSE
     RETURN NULL;
   $END
END Get_Forecast_Fill_Rate;

-- Check_If_Alternate_Part
--   Check if alternate part exists for given part. Return 'TRUE' or 'FALSE'.
@UncheckedAccess
FUNCTION Check_If_Alternate_Part (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS

   CURSOR  get_all_alternative_part IS
      SELECT   part_no, alternative_part_no
      FROM  part_catalog_alternative_pub
      WHERE part_no = part_no_;
BEGIN
   FOR rec_ IN get_all_alternative_part LOOP
      IF (Check_Exist___(contract_,rec_.alternative_part_no)) THEN
         RETURN 'TRUE';
      END IF;
   END LOOP;
   RETURN 'FALSE';
END Check_If_Alternate_Part;


-- Check_Partca_Part_Exist
--   Check if the part exists on any site. If part exists, return 'TRUE'.
--   'FALSE' otherwise.
@UncheckedAccess
FUNCTION Check_Partca_Part_Exist (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM inventory_part_tab
      WHERE part_no = part_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN ('TRUE');
   END IF;
   CLOSE exist_control;
   RETURN ('FALSE');
END Check_Partca_Part_Exist;


-- Check_Value_Method_Combination
--   This public method performs combination checks between Inventory Valuation
--   Method and Part Cost Level and Actual Costing and Serial Tracking and Lot
--   Batch Tracking and Zero Cost Allowed and Condition Code settings and
--   Configuration settings.
PROCEDURE Check_Value_Method_Combination (
   contract_                      IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   configurable_db_               IN VARCHAR2,
   condition_code_usage_db_       IN VARCHAR2,
   lot_tracking_code_db_          IN VARCHAR2,
   serial_tracking_code_db_       IN VARCHAR2,
   receipt_issue_serial_track_db_ IN VARCHAR2 )
IS
   part_rec_ inventory_part_tab%ROWTYPE;
BEGIN
   part_rec_ := Get_Object_By_Keys___(contract_, part_no_);
   Check_Value_Method_Combinat___(part_rec_,
                                  configurable_db_,
                                  condition_code_usage_db_,
                                  lot_tracking_code_db_,
                                  serial_tracking_code_db_,
                                  receipt_issue_serial_track_db_);
END Check_Value_Method_Combination;


-- Check_Exist_On_User_Site
--   This method checks if the part exists in at least one user allowed site,
--   and if so, returns 'TRUE' ('FALSE' otherwise).
@UncheckedAccess
FUNCTION Check_Exist_On_User_Site (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM  inventory_part_tab ip, USER_ALLOWED_SITE_PUB uas
      WHERE ip.contract = uas.site
      AND   ip.part_no = part_no_;
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


-- Check_Neg_Onhand_Part_Exist
--   This checks whether negative quantity on hand is allowed for a given part.
@UncheckedAccess
FUNCTION Check_Neg_Onhand_Part_Exist (
   part_no_  IN VARCHAR2,
   contract_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   dummy_      NUMBER;
   qty_found_  VARCHAR2(5) := 'FALSE';

   CURSOR check_exist IS
      SELECT 1
      FROM   inventory_part_tab
      WHERE  part_no           = part_no_
        AND  (contract         = contract_ OR contract_ IS NULL)
        AND  negative_on_hand  = 'NEG ONHAND OK';
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   IF (check_exist%FOUND) THEN
      qty_found_ := 'TRUE';
   END IF;
   CLOSE check_exist;
   RETURN qty_found_;
END Check_Neg_Onhand_Part_Exist;


@UncheckedAccess
FUNCTION Customs_Stat_No_With_Uom_Exist (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   stat_with_uom_   VARCHAR2(5) := 'FALSE';
   CURSOR get_custom_stat IS
      SELECT DISTINCT customs_stat_no
      FROM inventory_part_tab
      WHERE part_no = part_no_
      AND customs_stat_no IS NOT NULL;

BEGIN
   FOR rec_ IN get_custom_stat LOOP
      IF (Customs_Statistics_Number_API.Get_Customs_Unit_Meas(rec_.customs_stat_no) IS NOT NULL) THEN
         stat_with_uom_ := 'TRUE';
         EXIT;
      END IF;
   END LOOP;
   RETURN stat_with_uom_;

END Customs_Stat_No_With_Uom_Exist;


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
   objid_               INVENTORY_PART.objid%TYPE;
   objversion_          INVENTORY_PART.objversion%TYPE;
   source_key_ref_      VARCHAR2(2000);
   destination_key_ref_ VARCHAR2(2000);   
BEGIN

   Get_Id_Version_By_Keys___(objid_,
                             objversion_,
                             to_contract_,
                             to_part_no_);

   source_key_ref_      := Client_SYS.Get_Key_Reference(lu_name_, 'PART_NO',  from_part_no_,
                                                                  'CONTRACT', from_contract_);
   destination_key_ref_ := Client_SYS.Get_Key_Reference(lu_name_, 'PART_NO',  to_part_no_,
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
   from_note_id_ inventory_part_tab.note_id%TYPE;
   to_note_id_   inventory_part_tab.note_id%TYPE;
BEGIN

   from_note_id_ := Get_Note_Id(from_contract_, from_part_no_);
   to_note_id_   := Get_Note_Id(to_contract_  , to_part_no_);

   Document_Text_API.Copy_All_Note_Texts(from_note_id_,
                                         to_note_id_,
                                         error_when_no_source_,
                                         error_when_existing_copy_);
END Copy_Note_Texts;


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
   newrec_         inventory_part_tab%ROWTYPE;
   frompartrec_    inventory_part_tab%ROWTYPE;
   exit_procedure_ EXCEPTION;
BEGIN

   frompartrec_ := Get_Object_By_Keys___(from_contract_, from_part_no_);

   IF (frompartrec_.part_no IS NULL) THEN
      IF (error_when_no_source_ = 'TRUE') THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'IPNOTEXIST: Inventory Part :P1 does not exist on site :P2', from_part_no_, from_contract_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   ELSIF (frompartrec_.eng_attribute IS NULL) THEN
      IF (error_when_no_source_ = 'TRUE') THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'IPNOCHARTEMP: Characteristic template does not exist for part :P1 on site :P2', from_part_no_, from_contract_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;

   IF NOT (Check_Exist___(to_contract_, to_part_no_)) THEN
      RAISE exit_procedure_;
   END IF;

   newrec_ := Lock_By_Keys___(to_contract_, to_part_no_);
   IF (newrec_.eng_attribute IS NOT NULL) THEN
      IF (error_when_existing_copy_ = 'TRUE') THEN
         Error_SYS.Record_Exist(lu_name_, 'IPCHARTEMPEXIST: Characteristic template does already exist for part :P1 on site :P2', to_part_no_, to_contract_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   END IF;
   newrec_.eng_attribute := frompartrec_.eng_attribute;
   Modify___(newrec_);

   IF NOT Inventory_Part_Char_API.Part_Has_Char(from_contract_, from_part_no_) THEN
      IF (error_when_no_source_ = 'TRUE') THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'IPCHARNOTEXIST: Characteristics do not exist for Part :P1 on Site :P2', from_part_no_, from_contract_);
      ELSE
         RAISE exit_procedure_;
      END IF;
   ELSE
      Inv_Part_Indiscrete_Char_API.Copy(from_contract_,
                                        from_part_no_,
                                        to_contract_,
                                        to_part_no_,
                                        error_when_existing_copy_);

      Inv_Part_Discrete_Char_API.Copy(from_contract_,
                                      from_part_no_,
                                      to_contract_,
                                      to_part_no_,
                                      error_when_existing_copy_);
   END IF;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Copy_Characteristics;


-- Check_Ownership_Transfer_Point
--   Validates the combination of Ownership Transfer Point and Supplier
--   Invoice Consideration.
PROCEDURE Check_Ownership_Transfer_Point (
   company_                     IN VARCHAR2,
   ownership_transfer_point_db_ IN VARCHAR2 )
IS
   CURSOR get_part IS
      SELECT contract, part_no
      FROM inventory_part_tab
      WHERE invoice_consideration = 'TRANSACTION BASED';
BEGIN
   IF (ownership_transfer_point_db_ = 'RECEIPT INTO INVENTORY') THEN
      FOR part_rec_ IN get_part LOOP
         IF (Site_API.Get_Company(part_rec_.contract) = company_) THEN
            Error_SYS.Record_General(lu_name_, 'TRANBASSEPARR: You cannot use Receipt Into Inventory as Ownership Transfer Point on company :P1 since Transaction Based Invoice Consideration is activated for inventory part :P2 on site :P3.', company_, part_rec_.part_no, part_rec_.contract);
         END IF;
      END LOOP;
   END IF;
END Check_Ownership_Transfer_Point;


-- Cascade_Update_On_SO_Close
--   Check if a Shop Order for a part should trigger a cascade update
--   of transactions when the SO is closed. A cascade should be initiated
--   when valuation method is Weighted Average or cost level is cost per
@UncheckedAccess
FUNCTION Cascade_Update_On_SO_Close (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   inventory_valuation_method_db_ inventory_part_tab.inventory_valuation_method%TYPE;
   inventory_part_cost_level_db_  inventory_part_tab.inventory_part_cost_level%TYPE;

   CURSOR get_valuation_settings IS
      SELECT inventory_valuation_method,
             inventory_part_cost_level
      FROM inventory_part_tab
      WHERE contract = contract_
      AND   part_no  = part_no_;
BEGIN
   OPEN get_valuation_settings;
   FETCH get_valuation_settings INTO inventory_valuation_method_db_,
                                     inventory_part_cost_level_db_;
   CLOSE get_valuation_settings;

   RETURN Cascade_Update_On_So_Close___(inventory_valuation_method_db_,
                                        inventory_part_cost_level_db_);
END Cascade_Update_On_SO_Close;


-- Get_Calc_Rounded_Qty
--   Calculates and returns the rounded inventory quantity.
@UncheckedAccess
FUNCTION Get_Calc_Rounded_Qty (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   original_qty_     IN NUMBER,
   action_           IN VARCHAR2 DEFAULT 'ADD',
   ignore_unit_type_ IN BOOLEAN  DEFAULT FALSE ) RETURN NUMBER
IS
   qty_calc_rounding_ inventory_part_tab.qty_calc_rounding%TYPE;
   unit_meas_         inventory_part_tab.unit_meas%TYPE;
   
   CURSOR get_attr IS
      SELECT qty_calc_rounding, unit_meas
      FROM   inventory_part_tab
      WHERE  contract = contract_
      AND    part_no = part_no_;
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO qty_calc_rounding_, unit_meas_;
   CLOSE get_attr;
   RETURN Get_Calc_Rounded_Qty___(original_qty_, qty_calc_rounding_, action_, unit_meas_, ignore_unit_type_);
END Get_Calc_Rounded_Qty;


-- Check_Partcat_Unit_Code_Change
--   Check unit of measure difference in part catalog and inventory
PROCEDURE Check_Partcat_Unit_Code_Change (
   part_no_             IN VARCHAR2,
   old_unit_of_measure_ IN VARCHAR2,
   new_unit_of_measure_ IN VARCHAR2 )
IS
   uom_in_inventory_  VARCHAR2(10);
   engpart_exists_    VARCHAR2(5);   
   inv_base_unit_     VARCHAR2(120);
   new_base_unit_     VARCHAR2(120);

   CURSOR get_invpart_uom IS
      SELECT unit_meas
      FROM   inventory_part_tab
      WHERE  part_no = part_no_;
BEGIN
   OPEN get_invpart_uom;
   FETCH get_invpart_uom INTO uom_in_inventory_;
   CLOSE get_invpart_uom;
   IF(uom_in_inventory_ IS NOT NULL ) THEN
      $IF (Component_Pdmcon_SYS.INSTALLED) $THEN
         engpart_exists_ := Eng_Part_Revision_API.Check_Part_Exist(part_no_);      
         IF( engpart_exists_ ='TRUE') THEN
            new_base_unit_ := Iso_Unit_API.Get_Base_Unit(new_unit_of_measure_);
            inv_base_unit_ := Iso_Unit_API.Get_Base_Unit(uom_in_inventory_);
            IF NOT(inv_base_unit_ = new_base_unit_) THEN
               Error_SYS.Record_General(lu_name_, 'ONLYALLOWEDTOCHANGE: This is an engineering part and also an inventory part with Base Unit :P1. Therefore it is only allowed to change Unit Code into Base Unit :P1.',inv_base_unit_);
            END IF;
         END IF;
      $ELSE
         NULL;
      $END
   END IF;
END Check_Partcat_Unit_Code_Change;


@ObjectConnectionMethod
@UncheckedAccess
FUNCTION Get_Description (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_   inventory_part_tab.description%TYPE;
   CURSOR get_attr IS
      SELECT description
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no  = part_no_;
BEGIN
   IF (Site_Invent_Info_API.Get_Use_Partca_Desc_Invent_Db(contract_) = 'TRUE') THEN
      description_ := Part_Catalog_API.Get_Description(part_no_);
   ELSE
      OPEN  get_attr;
      FETCH get_attr INTO description_;
      CLOSE get_attr;
   END IF;
   RETURN description_;
END Get_Description;


-- Handle_Partca_Desc_Change
--   Handles the updation of description in accordance with part catalog
--   description when centralized part catalog description is used.
PROCEDURE Handle_Partca_Desc_Change (
   part_no_ IN VARCHAR2 )
IS
   CURSOR get_contract IS
      SELECT contract
      FROM   inventory_part_tab
      WHERE  part_no = part_no_;
BEGIN
   FOR get_contract_ IN get_contract LOOP
      IF (Site_Invent_Info_API.Get_Use_Partca_Desc_Invent_Db(get_contract_.contract) = 'TRUE') THEN
         Handle_Description_Change___(get_contract_.contract, part_no_);
      END IF;
   END LOOP;
END Handle_Partca_Desc_Change;


-- Handle_Partca_Desc_Flag_Change
--   Handles the description according to Use_Partca_Desc_Invent flag
--   modification in site.
PROCEDURE Handle_Partca_Desc_Flag_Change (
   contract_ IN VARCHAR2 )
IS
   partca_description_   inventory_part_tab.description%TYPE;
   CURSOR get_part_info IS
      SELECT part_no, description
      FROM   inventory_part_tab
      WHERE  contract = contract_;
BEGIN
   FOR get_part_info_ IN get_part_info LOOP
     partca_description_ := Part_Catalog_API.Get_Description(get_part_info_.part_no);
     IF (get_part_info_.description != partca_description_) THEN
        Handle_Description_Change___(contract_, get_part_info_.part_no);
     END IF;
  END LOOP;
END Handle_Partca_Desc_Flag_Change;

@UncheckedAccess
FUNCTION Get_Site_Converted_Qty (
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   quantity_        IN NUMBER,
   to_contract_     IN VARCHAR2,
   rounding_action_ IN VARCHAR2,
   unit_category_   IN VARCHAR2 DEFAULT 'INVENT',
   to_part_no_      IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   from_part_rec_  inventory_part_tab%ROWTYPE;
   to_part_rec_    inventory_part_tab%ROWTYPE;
   to_quantity_    NUMBER;
   -- could be either unit_meas (10 characters) or catch_unit_meas (30 characters)
   from_unit_meas_ inventory_part_tab.catch_unit_meas%TYPE;
   to_unit_meas_   inventory_part_tab.catch_unit_meas%TYPE;
BEGIN
   to_quantity_ := quantity_;
   IF (contract_ != to_contract_ AND quantity_ != 0) THEN
      from_part_rec_  := Get_Object_By_Keys___(contract_,part_no_);
      to_part_rec_    := Get_Object_By_Keys___(to_contract_, NVL(to_part_no_, part_no_));
      IF (unit_category_ = 'INVENT') THEN
         from_unit_meas_ := from_part_rec_.unit_meas;
         to_unit_meas_ := to_part_rec_.unit_meas;
      ELSIF (unit_category_ = 'CATCH') THEN
         from_unit_meas_ := from_part_rec_.catch_unit_meas;
         to_unit_meas_ := to_part_rec_.catch_unit_meas;
      END IF;
      IF (from_unit_meas_ != to_unit_meas_) THEN
         to_quantity_ := Iso_Unit_API.Get_Unit_Converted_Quantity(quantity_,
                                                     from_unit_meas_,
                                                     to_unit_meas_ );

         IF (rounding_action_ IN ('ADD','REMOVE')) THEN
            to_quantity_ := Get_Calc_Rounded_Qty___(to_quantity_,
                                                    to_part_rec_.qty_calc_rounding,
                                                    rounding_action_,
                                                    to_unit_meas_,
                                                    FALSE);
         ELSIF (rounding_action_ = 'SKIP') THEN
            NULL;
         ELSE
            to_quantity_ := NULL;
         END IF;
      ELSIF (from_unit_meas_ IS NULL OR to_unit_meas_ IS NULL) THEN
         to_quantity_ := NULL;
      END IF;
   END IF;

   RETURN (to_quantity_);
END Get_Site_Converted_Qty;


FUNCTION Get_Site_Converted_Qty (
   part_no_         IN VARCHAR2,
   quantity_        IN NUMBER,
   unit_meas_       IN VARCHAR2,
   to_contract_     IN VARCHAR2,
   rounding_action_ IN VARCHAR2,
   unit_category_   IN VARCHAR2 DEFAULT 'INVENT' ) RETURN NUMBER
IS
   to_part_rec_   inventory_part_tab%ROWTYPE;
   to_quantity_   NUMBER;
   -- could be either unit_meas (10 characters) or catch_unit_meas (30 characters)
   to_unit_meas_  inventory_part_tab.catch_unit_meas%TYPE;
BEGIN
   to_quantity_ := quantity_;
   IF (quantity_ != 0) THEN
      to_part_rec_    := Get_Object_By_Keys___(to_contract_,part_no_);

      IF (unit_category_ = 'INVENT') THEN
         to_unit_meas_ := to_part_rec_.unit_meas;
      ELSIF (unit_category_ = 'CATCH') THEN
         to_unit_meas_ := to_part_rec_.catch_unit_meas;
      ELSE
         Error_SYS.Record_General(lu_name_, 'ERR_UOM: Unit Category :P1 sent to method Get_Site_Converted_Qty is invalid.',unit_category_);
      END IF;

      IF (unit_meas_ != to_unit_meas_) THEN
         to_quantity_ := Iso_Unit_API.Convert_Unit_Quantity(quantity_,
                                                            unit_meas_,
                                                            to_unit_meas_);
         IF (rounding_action_ IN ('ADD','REMOVE')) THEN
            to_quantity_ := Get_Calc_Rounded_Qty___(to_quantity_,
                                                    to_part_rec_.qty_calc_rounding,
                                                    rounding_action_,
                                                    to_unit_meas_,
                                                    FALSE);
         ELSIF (rounding_action_ = 'SKIP') THEN
            NULL;
         ELSE
            Error_SYS.Record_General(lu_name_, 'ERR_ROUNDING: Rounding action :P1 sent to method Get_Site_Converted_Qty is invalid.',rounding_action_);
         END IF;
      ELSIF (to_unit_meas_ IS NULL) THEN
         Raise_Part_Not_Exist___(part_no_, to_contract_);
      END IF;
   END IF;

   RETURN (to_quantity_);
END Get_Site_Converted_Qty;


FUNCTION Get_Site_Converted_Qty (
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   to_contract_     IN VARCHAR2,
   quantity_        IN NUMBER,
   rounding_action_ IN VARCHAR2,
   unit_category_   IN VARCHAR2 DEFAULT 'INVENT' ) RETURN NUMBER
IS
   from_part_rec_  inventory_part_tab%ROWTYPE;
   to_quantity_    NUMBER;
   -- could be either unit_meas (10 characters) or catch_unit_meas (30 characters)
   from_unit_meas_ inventory_part_tab.catch_unit_meas%TYPE;
BEGIN
   to_quantity_ := quantity_;
   IF (contract_ != to_contract_ AND quantity_ != 0) THEN
      from_part_rec_  := Get_Object_By_Keys___(contract_,part_no_);

      IF (unit_category_ = 'INVENT') THEN
         from_unit_meas_ := from_part_rec_.unit_meas;
      ELSIF (unit_category_ = 'CATCH') THEN
         from_unit_meas_ := from_part_rec_.catch_unit_meas;
      ELSE
         Error_SYS.Record_General(lu_name_, 'ERR_UOM: Unit Category :P1 sent to method Get_Site_Converted_Qty is invalid.',unit_category_);
      END IF;

      IF (from_unit_meas_ IS NOT NULL) THEN
         to_quantity_ := Get_Site_Converted_Qty(part_no_,
                                                quantity_,
                                                from_unit_meas_,
                                                to_contract_,
                                                rounding_action_,
                                                unit_category_);
      ELSE
         Raise_Part_Not_Exist___(part_no_,contract_);
      END IF;
   END IF;

   RETURN (to_quantity_);
END Get_Site_Converted_Qty;


-- Get_User_Default_Converted_Qty
--   Converts a quantity from one sites inventory UoM to another sites inventory UoM.
--   The "to site" will either be the user default site or if the user default site
--   dont have the part it will use the first available site where this part exist.
--   Valid rounding_action_ values are 'ADD', 'REMOVE', 'SKIP' to decide if you want
--   to round the value up, down or skip the rounding. Use 'ADD' if is a demand quantity,
--   use 'REMOVE' if it is a supply quantity, use 'SKIP' when you dont want a rounding
--   like if you summarize several values and you only want to round the sum in the end.
--   unit_category can be INVENT(default) or CATCH depending on which UoM you would like to use.
@UncheckedAccess
FUNCTION Get_User_Default_Converted_Qty (
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   quantity_        IN NUMBER,
   rounding_action_ IN VARCHAR2,
   unit_category_   IN VARCHAR2 DEFAULT 'INVENT' ) RETURN NUMBER
IS
   to_quantity_ NUMBER;
   not_used_    inventory_part_tab.catch_unit_meas%TYPE;
   to_contract_ inventory_part_tab.contract%TYPE;
BEGIN
   to_quantity_ := quantity_;
   IF (quantity_ != 0) THEN
      Get_Default_Site_And_Uom___(to_contract_, not_used_, part_no_, unit_category_);
      to_quantity_ := Get_Site_Converted_Qty(contract_,
                                             part_no_,
                                             quantity_,
                                             to_contract_,
                                             rounding_action_,
                                             unit_category_);
   END IF;
   RETURN (to_quantity_);
END Get_User_Default_Converted_Qty;


-- Get_User_Default_Unit_Meas
--   Fetches the UoM for the Part on either the user default site or if the user default site
--   dont have the part it will use the first available site where this part exist.
--   unit_category can be INVENT(default) or CATCH depending on which UoM you would like to use.
@UncheckedAccess
FUNCTION Get_User_Default_Unit_Meas (
   part_no_       IN VARCHAR2,
   unit_category_ IN VARCHAR2 DEFAULT 'INVENT' ) RETURN VARCHAR2
IS
   not_used_       inventory_part_tab.contract%TYPE;
   -- could be either unit_meas (10 characters) or catch_unit_meas (30 characters)
   unit_meas_      inventory_part_tab.catch_unit_meas%TYPE;
BEGIN
   Get_Default_Site_And_Uom___(not_used_, unit_meas_, part_no_, unit_category_);
   RETURN unit_meas_;
END Get_User_Default_Unit_Meas;


-- Get_User_Default_Site
--   Fetches the Site for the Part on either the user default site or if the user default site
--   dont have the part it will use the first available site where this part exist.
@UncheckedAccess
FUNCTION Get_User_Default_Site (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_ inventory_part_tab.contract%TYPE;
   not_used_ inventory_part_tab.catch_unit_meas%TYPE;
BEGIN
   Get_Default_Site_And_Uom___(contract_, not_used_, part_no_);
   RETURN contract_;
END Get_User_Default_Site;


-- Get_Enabled_Catch_Unit_Meas
--   Fetches the catch UoM for an inventory part that it catch unit enabled in
--   Part Catalog.
@UncheckedAccess
FUNCTION Get_Enabled_Catch_Unit_Meas (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   catch_unit_meas_ inventory_part_tab.catch_unit_meas%TYPE;

   CURSOR get_attr IS
      SELECT catch_unit_meas
      FROM   inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO catch_unit_meas_;
   IF (get_attr%FOUND) THEN
      IF (Part_Catalog_API.Get_Catch_Unit_Enabled_Db(part_no_) = 'FALSE') THEN
         catch_unit_meas_ := NULL;
      END IF;
   END IF;
   CLOSE get_attr;

   RETURN catch_unit_meas_;
END Get_Enabled_Catch_Unit_Meas;


PROCEDURE Check_Enable_Catch_Unit (
   part_no_ IN VARCHAR2 )
IS  
   CURSOR get_inv_part IS
      SELECT contract, catch_unit_meas
      FROM   inventory_part_tab
      WHERE  part_no = part_no_;
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      FOR part_rec_ IN get_inv_part LOOP
         Sales_Part_API.Check_Enable_Catch_Unit(part_rec_.contract, part_no_, part_rec_.catch_unit_meas);
      END LOOP;
   $ELSE
      NULL;
   $END  
END Check_Enable_Catch_Unit;


-- Modify_Qty_Calc_Rounding
--   Modifies the attribute QtyCalcRounding.
PROCEDURE Modify_Qty_Calc_Rounding (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   qty_calc_rounding_ IN NUMBER )
IS
   newrec_  inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_.qty_calc_rounding := qty_calc_rounding_;
   Modify___(newrec_);
END Modify_Qty_Calc_Rounding;

-- Modify_Qty_Calc_Rounding
--   Modifies the attribute QtyCalcRounding.
PROCEDURE Modify_Eng_Attribute (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   eng_attribute_  IN VARCHAR2 )
IS
   newrec_  inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_.eng_attribute := eng_attribute_;
   Modify___(newrec_);
END Modify_Eng_Attribute;



-- Get_All_Notes
--   Return the Notes and Note Ids connected to a Inventory Part and related Part
--   Catalog Language.
PROCEDURE Get_All_Notes (
   partca_part_note_id_ OUT NUMBER,
   partca_part_notes_   OUT VARCHAR2,
   inv_part_note_id_    OUT NUMBER,
   inv_part_notes_      OUT VARCHAR2,
   contract_            IN  VARCHAR2,
   part_no_             IN  VARCHAR2,
   language_code_       IN  VARCHAR2,
   document_code_       IN  VARCHAR2 )
IS
BEGIN
   IF (Site_Invent_Info_API.Get_Use_Partca_Desc_Invent_Db(contract_) = 'TRUE') THEN
      partca_part_note_id_ := Part_Catalog_Language_API.Get_Note_Id(part_no_, language_code_);
   END IF;
   partca_part_notes_ := Document_Text_API.Get_All_Notes(partca_part_note_id_, document_code_);

   inv_part_note_id_  := Inventory_Part_API.Get_Note_Id(contract_, part_no_);
   inv_part_notes_    := Document_Text_API.Get_All_Notes(inv_part_note_id_, document_code_);
END Get_All_Notes;


-- Cascade_Trans_Cost_Update
--   Check if an inventory part is using Actual Cost.
@UncheckedAccess
FUNCTION Cascade_Trans_Cost_Update (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   rec_ inventory_part_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(contract_, part_no_);
   RETURN (Cascade_Trans_Cost_Update(rec_.invoice_consideration,
                                     rec_.inventory_valuation_method,
                                     rec_.inventory_part_cost_level));
END Cascade_Trans_Cost_Update;


-- Cascade_Trans_Cost_Update
--   Check if an inventory part is using Actual Cost.
@UncheckedAccess
FUNCTION Cascade_Trans_Cost_Update (
   invoice_consideration_db_      IN VARCHAR2,
   inventory_valuation_method_db_ IN VARCHAR2,
   inventory_part_cost_level_db_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   cascade_trans_cost_update_ BOOLEAN := FALSE;
BEGIN
   IF ((invoice_consideration_db_ = 'TRANSACTION BASED') OR
       (Cascade_Update_On_SO_Close___(inventory_valuation_method_db_,
                                      inventory_part_cost_level_db_))) THEN
      cascade_trans_cost_update_ := TRUE;
   END IF;
   RETURN (cascade_trans_cost_update_);
END Cascade_Trans_Cost_Update;


-- Modify_Type_Code
--   Modifies the type code of the inventory part.
PROCEDURE Modify_Type_Code (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   type_code_db_ IN VARCHAR2 )
IS
   newrec_  inventory_part_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_.type_code := type_code_db_;
   Modify___(newrec_);
END Modify_Type_Code;


-- Modify_Invent_Part_Cost_Level
--   Modifies the inventory part cost level of the inventory part.
PROCEDURE Modify_Invent_Part_Cost_Level (
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   inventory_part_cost_level_db_ IN VARCHAR2 )
IS 
   record_ inventory_part_tab%ROWTYPE;
BEGIN 
   record_ := Lock_By_Keys___(contract_, part_no_);
   record_.inventory_part_cost_level := inventory_part_cost_level_db_;
   Modify___(record_, updated_by_client_ => TRUE);
END Modify_Invent_Part_Cost_Level;


--  Modify_Invent_Valuation_Met
--  Modifies the inventory part valuation method.
PROCEDURE Modify_Invent_Valuation_Met (
   contract_                      IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   inventory_valuation_method_db_ IN VARCHAR2 )
IS 
   record_ inventory_part_tab%ROWTYPE;
BEGIN 
   record_ := Lock_By_Keys___(contract_, part_no_);
   record_.inventory_valuation_method := inventory_valuation_method_db_;
   Modify___(record_);
END Modify_Invent_Valuation_Met;


-- Modify_Earliest_Ultd_Sply_Date
--   Modifies the attribute earliest unlimited supply date for a part.
PROCEDURE Modify_Earliest_Ultd_Sply_Date (
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   planned_receipt_date_ IN DATE )
IS
   dummy_ BOOLEAN;
BEGIN
   Mod_Earliest_Ultd_Sply_Date___(date_modified_        => dummy_,
                                  contract_             => contract_,
                                  part_no_              => part_no_,
                                  planned_receipt_date_ => planned_receipt_date_,
                                  backdate_allowed_db_  => Fnd_Boolean_API.DB_TRUE);   
END Modify_Earliest_Ultd_Sply_Date;


PROCEDURE Modify_Earliest_Ultd_Sply_Date (
   date_modified_        OUT BOOLEAN,
   contract_             IN  VARCHAR2,
   part_no_              IN  VARCHAR2,
   planned_receipt_date_ IN  DATE,
   backdate_allowed_db_  IN  VARCHAR2 )
IS
BEGIN
   Mod_Earliest_Ultd_Sply_Date___(date_modified_, contract_, part_no_, planned_receipt_date_, backdate_allowed_db_);
END Modify_Earliest_Ultd_Sply_Date;


PROCEDURE Check_Disallow_As_Not_Consumed (
   part_no_ IN VARCHAR2 )
IS
   contract_           inventory_part_tab.contract%TYPE;
   expense_part_exist_ EXCEPTION;

   CURSOR check_invpart IS
      SELECT contract
      FROM   inventory_part_tab
      WHERE  part_no = part_no_
      AND    type_code = 6 ;
BEGIN
   OPEN check_invpart;
   FETCH check_invpart INTO contract_;
   IF check_invpart%FOUND THEN
      CLOSE check_invpart;
      RAISE expense_part_exist_;
   END IF;
   CLOSE check_invpart;
EXCEPTION
   WHEN expense_part_exist_ THEN
      Error_SYS.Record_General(lu_name_, 'EXPENSEPRTEXIST: Allow as Not Consumed check box cannot be cleared when the inventory part :P1 in site :P2 is of type expense.',part_no_, contract_);
END Check_Disallow_As_Not_Consumed;


-- Cascade_Update_On_SO_Close_Str
--   Check if a Shop Order for a part should trigger a cascade update of
--   transactions when the SO is closed. A cascade should be initiated
--   when valuation method is Weighted Average or cost level is cost per serial.
--   used by clients to show the inverted operative volume value
--   used by clients to show the inverted volume value
@UncheckedAccess
FUNCTION Cascade_Update_On_SO_Close_Str (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   cascade_update_ VARCHAR2(5) := 'FALSE';
BEGIN
   IF (Cascade_Update_On_SO_Close(contract_, part_no_)) THEN
      cascade_update_ := 'TRUE';
   END IF;
   RETURN cascade_update_;
END Cascade_Update_On_SO_Close_Str;

PROCEDURE Add_Issue_For_Decline_Expired (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS 
   oldrec_ inventory_part_tab%ROWTYPE;
   newrec_ inventory_part_tab%ROWTYPE;
   modify_ BOOLEAN := FALSE;
BEGIN 
   oldrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_ := oldrec_;

   CASE oldrec_.lifecycle_stage
      WHEN Inv_Part_Lifecycle_Stage_API.DB_DECLINE THEN
         newrec_.decline_issue_counter := NVL(oldrec_.decline_issue_counter, 0) + 1;
         modify_                       := TRUE;
      WHEN Inv_Part_Lifecycle_Stage_API.DB_EXPIRED THEN
         newrec_.expired_issue_counter := NVL(oldrec_.expired_issue_counter, 0) + 1;
         modify_                       := TRUE;
      ELSE
         NULL;
   END CASE;

   IF (modify_) THEN
      Modify___(newrec_);
   END IF;
   
END Add_Issue_For_Decline_Expired;

   
PROCEDURE Modify_Latest_Stat_Issue_Date (
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   latest_stat_issue_date_ IN DATE )
IS
   oldrec_                     inventory_part_tab%ROWTYPE;
   asset_class_rec_            Asset_Class_API.Public_Rec;
   company_invent_info_rec_    Company_Invent_Info_API.Public_Rec;
   update_needed_              BOOLEAN := FALSE;
   new_first_stat_issue_date_  DATE;
   new_latest_stat_issue_date_ DATE;
   expired_inactivity_days_    NUMBER;
   expired_to_intro_issues_    NUMBER;
BEGIN
   oldrec_                     := Lock_By_Keys___(contract_, part_no_);
   new_first_stat_issue_date_  := oldrec_.first_stat_issue_date;
   new_latest_stat_issue_date_ := oldrec_.latest_stat_issue_date;

   IF (NVL(oldrec_.latest_stat_issue_date, Database_SYS.first_calendar_date_) <
                                                                      latest_stat_issue_date_) THEN
      new_latest_stat_issue_date_ := latest_stat_issue_date_;
      update_needed_              := TRUE;
   END IF;

   IF (NVL(oldrec_.first_stat_issue_date, Database_SYS.last_calendar_date_) >
                                                                      latest_stat_issue_date_) THEN
      new_first_stat_issue_date_ := latest_stat_issue_date_;
      update_needed_             := TRUE;
   END IF;

   IF (oldrec_.lifecycle_stage = Inv_Part_Lifecycle_Stage_API.DB_EXPIRED) THEN
      company_invent_info_rec_ := Company_Invent_Info_API.Get(Site_API.Get_Company(contract_));
      asset_class_rec_         := Asset_Class_API.Get(oldrec_.asset_class);
      expired_inactivity_days_ := NVL(asset_class_rec_.expired_inactivity_days ,
                                      company_invent_info_rec_.expired_inactivity_days);
      expired_to_intro_issues_ := NVL(asset_class_rec_.expired_to_intro_issues,
                                      company_invent_info_rec_.expired_to_intro_issues);
      
      -- Confirm that the part latest statistical issue is done in Expired stage. (new_first_stat_issue_date_ + expired_inactivity_days_ < new_latest_stat_issue_date_)
      IF (new_first_stat_issue_date_ < (new_latest_stat_issue_date_ - expired_inactivity_days_)) THEN
         IF (oldrec_.expired_issue_counter >= expired_to_intro_issues_)THEN 
            new_first_stat_issue_date_ := new_latest_stat_issue_date_;
            update_needed_             := TRUE;
         END IF;
      END IF;
   END IF;

   IF (update_needed_) THEN
      oldrec_.first_stat_issue_date  := new_first_stat_issue_date_;
      oldrec_.latest_stat_issue_date := new_latest_stat_issue_date_;
      Modify___(oldrec_);
   END IF;
END Modify_Latest_Stat_Issue_Date;


@Override
@UncheckedAccess
FUNCTION Get_Storage_Width_Requirement (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   storage_width_requirement_ inventory_part_tab.storage_width_requirement%TYPE;
   site_length_uom_           VARCHAR2(30);
   part_length_uom_           VARCHAR2(30);
BEGIN
   storage_width_requirement_ := super(contract_, part_no_);

   IF micro_cache_value_.unit_meas = Part_Catalog_API.Get_Unit_Code(part_no_) THEN
      IF (storage_width_requirement_ IS NULL) THEN
         storage_width_requirement_ := Part_Catalog_Invent_Attrib_API.Get_Storage_Width_Requirement(part_no_);
         IF storage_width_requirement_ IS NOT NULL THEN
            site_length_uom_ := Company_Invent_Info_API.Get_Uom_For_Length(Site_API.Get_Company(contract_));
            part_length_uom_ := Part_Catalog_Invent_Attrib_API.Get_Uom_For_Length(part_no_);
            IF part_length_uom_ IS NULL THEN
               part_length_uom_ := Storage_Capacity_Req_Group_API.Get_Uom_For_Length(
                                         Part_Catalog_Invent_Attrib_API.Get_Capacity_Req_Group_Id(part_no_));
            END IF;
            -- IF the uom on site (company) is different from the one on Part Catalog or Capacity Requirement Group
            -- the width needs to be converted to the uom on site
            IF site_length_uom_ != part_length_uom_ THEN
               storage_width_requirement_ := ROUND(Iso_Unit_API.Get_Unit_Converted_Quantity(storage_width_requirement_,
                                                                                            part_length_uom_,
                                                                                            site_length_uom_), 4);
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (storage_width_requirement_);
END Get_Storage_Width_Requirement;


@Override
@UncheckedAccess
FUNCTION Get_Storage_Height_Requirement (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   storage_height_requirement_ inventory_part_tab.storage_height_requirement%TYPE;
   site_length_uom_            VARCHAR2(30);
   part_length_uom_            VARCHAR2(30);
BEGIN
   storage_height_requirement_ := super(contract_, part_no_);

   IF micro_cache_value_.unit_meas = Part_Catalog_API.Get_Unit_Code(part_no_) THEN
      IF (storage_height_requirement_ IS NULL) THEN
         storage_height_requirement_ := Part_Catalog_Invent_Attrib_API.Get_Storage_Height_Requirement(part_no_);
         IF storage_height_requirement_ IS NOT NULL THEN
            site_length_uom_ := Company_Invent_Info_API.Get_Uom_For_Length(Site_API.Get_Company(contract_));
            part_length_uom_ := Part_Catalog_Invent_Attrib_API.Get_Uom_For_Length(part_no_);
            IF part_length_uom_ IS NULL THEN
               part_length_uom_ := Storage_Capacity_Req_Group_API.Get_Uom_For_Length(
                                         Part_Catalog_Invent_Attrib_API.Get_Capacity_Req_Group_Id(part_no_));
            END IF;
            -- IF the uom on site (company) is different from the one on Part Catalog or Capacity Requirement Group
            -- the height needs to be converted to the uom on site
            IF site_length_uom_ != part_length_uom_ THEN
               storage_height_requirement_ := ROUND(Iso_Unit_API.Get_Unit_Converted_Quantity(storage_height_requirement_,
                                                                                             part_length_uom_,
                                                                                             site_length_uom_), 4);
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (storage_height_requirement_);
END Get_Storage_Height_Requirement;


@Override 
@UncheckedAccess
FUNCTION Get_Storage_Depth_Requirement (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   storage_depth_requirement_ inventory_part_tab.storage_depth_requirement%TYPE;
   site_length_uom_           VARCHAR2(30);
   part_length_uom_           VARCHAR2(30);
BEGIN
   storage_depth_requirement_ := super(contract_, part_no_);

   IF micro_cache_value_.unit_meas = Part_Catalog_API.Get_Unit_Code(part_no_) THEN
      IF (storage_depth_requirement_ IS NULL) THEN
         storage_depth_requirement_ := Part_Catalog_Invent_Attrib_API.Get_Storage_Depth_Requirement(part_no_);
         IF storage_depth_requirement_ IS NOT NULL THEN
            site_length_uom_ := Company_Invent_Info_API.Get_Uom_For_Length(Site_API.Get_Company(contract_));
            part_length_uom_ := Part_Catalog_Invent_Attrib_API.Get_Uom_For_Length(part_no_);
            IF part_length_uom_ IS NULL THEN
               part_length_uom_ := Storage_Capacity_Req_Group_API.Get_Uom_For_Length(
                                         Part_Catalog_Invent_Attrib_API.Get_Capacity_Req_Group_Id(part_no_));
            END IF;
            -- IF the uom on site (company) is different from the one on Part Catalog or Capacity Requirement Group
            -- the depth needs to be converted to the uom on site
            IF site_length_uom_ != part_length_uom_ THEN
               storage_depth_requirement_ := ROUND(Iso_Unit_API.Get_Unit_Converted_Quantity(storage_depth_requirement_,
                                                                                            part_length_uom_,
                                                                                            site_length_uom_), 4);
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (storage_depth_requirement_);
END Get_Storage_Depth_Requirement;


@Override
@UncheckedAccess
FUNCTION Get_Storage_Volume_Requirement (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   storage_volume_requirement_ inventory_part_tab.storage_volume_requirement%TYPE;
   invpart_volume_uom_         VARCHAR2(30);
   partca_volume_uom_          VARCHAR2(30);
BEGIN
   storage_volume_requirement_ := super(contract_, part_no_);

   IF micro_cache_value_.unit_meas = Part_Catalog_API.Get_Unit_Code(part_no_) THEN
      IF (storage_volume_requirement_ IS NULL) THEN
         storage_volume_requirement_ := Part_Catalog_Invent_Attrib_API.Get_Storage_Volume_Requirement(part_no_);
         IF storage_volume_requirement_ IS NOT NULL THEN
            invpart_volume_uom_ := Site_Invent_Info_API.Get_Volume_Uom(contract_);  -- can be null if length uom + 3 becomes an invalid uom
            partca_volume_uom_  := Part_Catalog_Invent_Attrib_API.Get_Uom_For_Volume(part_no_);
            IF partca_volume_uom_ IS NULL THEN
               partca_volume_uom_ := Storage_Capacity_Req_Group_API.Get_Uom_For_Volume(
                                         Part_Catalog_Invent_Attrib_API.Get_Capacity_Req_Group_Id(part_no_));
            END IF;
            IF invpart_volume_uom_ IS NULL THEN
               storage_volume_requirement_ := NULL;
            -- IF the volume uom on inventory part client is different from the one on Part Catalog or Capacity Requirement Group
            -- the volume needs to be converted to the uom on site
            ELSIF invpart_volume_uom_ != partca_volume_uom_ THEN
               storage_volume_requirement_ := Iso_Unit_API.Get_Unit_Converted_Quantity(storage_volume_requirement_,
                                                                                             partca_volume_uom_,
                                                                                             invpart_volume_uom_);
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (storage_volume_requirement_);
END Get_Storage_Volume_Requirement;


@UncheckedAccess
FUNCTION Get_Storage_Volume_Req_Oper_Cl (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   storage_volume_requirement_ inventory_part_tab.storage_volume_requirement%TYPE;
BEGIN
   storage_volume_requirement_ := Get_Storage_Volume_Requirement(contract_,part_no_);
   IF (storage_volume_requirement_ > 0) THEN
      storage_volume_requirement_ := 1 / storage_volume_requirement_;
   ELSE
      storage_volume_requirement_ := NULL;
   END IF;
   RETURN (storage_volume_requirement_);
END Get_Storage_Volume_Req_Oper_Cl;


@UncheckedAccess
FUNCTION Get_Storage_Volume_Req_Client (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   storage_volume_requirement_ inventory_part_tab.storage_volume_requirement%TYPE;
BEGIN
   Update_Cache___(contract_, part_no_);
   storage_volume_requirement_ := micro_cache_value_.storage_volume_requirement;
   IF (storage_volume_requirement_ > 0) THEN
      storage_volume_requirement_ := 1 / storage_volume_requirement_;
   ELSE
      storage_volume_requirement_ := NULL;
   END IF;
   RETURN (storage_volume_requirement_);
END Get_Storage_Volume_Req_Client;


@Override
@UncheckedAccess
FUNCTION Get_Storage_Weight_Requirement (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   storage_weight_requirement_ inventory_part_tab.storage_weight_requirement%TYPE;
   site_weight_uom_            VARCHAR2(30);
   part_weight_uom_            VARCHAR2(30);
BEGIN
   storage_weight_requirement_ := super(contract_, part_no_);

   IF micro_cache_value_.unit_meas = Part_Catalog_API.Get_Unit_Code(part_no_) THEN
      IF (storage_weight_requirement_ IS NULL) THEN
         storage_weight_requirement_ := Part_Catalog_Invent_Attrib_API.Get_Storage_Weight_Requirement(part_no_);
         IF storage_weight_requirement_ IS NOT NULL THEN
            site_weight_uom_ := Company_Invent_Info_API.Get_Uom_For_Weight(Site_API.Get_Company(contract_));
            part_weight_uom_ := Part_Catalog_Invent_Attrib_API.Get_Uom_For_Weight(part_no_);
            IF part_weight_uom_ IS NULL THEN
               part_weight_uom_ := Storage_Capacity_Req_Group_API.Get_Uom_For_Weight(
                                            Part_Catalog_Invent_Attrib_API.Get_Capacity_Req_Group_Id(part_no_));
            END IF;
            -- IF the uom on site (company) is different from the one on Part Catalog or Capacity Requirement Group
            -- the weight needs to be converted to the uom on site
            IF site_weight_uom_ != part_weight_uom_ THEN
               storage_weight_requirement_ := ROUND(Iso_Unit_API.Get_Unit_Converted_Quantity(storage_weight_requirement_,
                                                                                             part_weight_uom_,
                                                                                             site_weight_uom_), 4);

            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (storage_weight_requirement_);
END Get_Storage_Weight_Requirement;


@Override
@UncheckedAccess
FUNCTION Get_Min_Storage_Temperature (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   min_storage_temperature_ inventory_part_tab.min_storage_temperature%TYPE;
   site_temp_uom_           VARCHAR2(30);
   part_temp_uom_           VARCHAR2(30);
BEGIN
   min_storage_temperature_ := super(contract_, part_no_);

   IF (min_storage_temperature_ IS NULL) THEN
      min_storage_temperature_ := Part_Catalog_Invent_Attrib_API.Get_Min_Storage_Temperature(part_no_);
      IF min_storage_temperature_ IS NOT NULL THEN
         site_temp_uom_ := Company_Invent_Info_API.Get_Uom_For_Temperature(Site_API.Get_Company(contract_));
         part_temp_uom_ := Part_Catalog_Invent_Attrib_API.Get_Uom_For_Temperature(part_no_);
         IF part_temp_uom_ IS NULL THEN
            part_temp_uom_ := Storage_Cond_Req_Group_API.Get_Uom_For_Temperature(
                                       Part_Catalog_Invent_Attrib_API.Get_Condition_Req_Group_Id(part_no_));
         END IF;
         -- IF the uom on site (company) is different from the one on Part Catalog or Condition Requirement Group
         -- temperature needs to be converted to the uom on site
         IF site_temp_uom_ != part_temp_uom_ THEN
            min_storage_temperature_ := ROUND(Iso_Unit_API.Get_Unit_Converted_Quantity(min_storage_temperature_,
                                                                                       part_temp_uom_,
                                                                                       site_temp_uom_), 4);
         END IF;
      END IF;
   END IF;
   RETURN (min_storage_temperature_);
END Get_Min_Storage_Temperature;


@Override
@UncheckedAccess
FUNCTION Get_Max_Storage_Temperature (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   max_storage_temperature_ inventory_part_tab.max_storage_temperature%TYPE;
   site_temp_uom_           VARCHAR2(30);
   part_temp_uom_           VARCHAR2(30);
BEGIN
   max_storage_temperature_ := super(contract_, part_no_);

   IF (max_storage_temperature_ IS NULL) THEN
      max_storage_temperature_ := Part_Catalog_Invent_Attrib_API.Get_Max_Storage_Temperature(part_no_);
      IF max_storage_temperature_ IS NOT NULL THEN
         site_temp_uom_ := Company_Invent_Info_API.Get_Uom_For_Temperature(Site_API.Get_Company(contract_));
         part_temp_uom_ := Part_Catalog_Invent_Attrib_API.Get_Uom_For_Temperature(part_no_);
         IF part_temp_uom_ IS NULL THEN
            part_temp_uom_ := Storage_Cond_Req_Group_API.Get_Uom_For_Temperature(
                                     Part_Catalog_Invent_Attrib_API.Get_Condition_Req_Group_Id(part_no_));
         END IF;
         -- IF the uom on site (company) is different from the one on Part Catalog or Condition Requirement Group 
         -- temperature needs to be converted to the uom on site
         IF site_temp_uom_ != part_temp_uom_ THEN
            max_storage_temperature_ := ROUND(Iso_Unit_API.Get_Unit_Converted_Quantity(max_storage_temperature_,
                                                                                       part_temp_uom_,
                                                                                       site_temp_uom_), 4);
         END IF;
      END IF;
   END IF;
   RETURN (max_storage_temperature_);
END Get_Max_Storage_Temperature;


@Override
@UncheckedAccess
FUNCTION Get_Min_Storage_Humidity (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   min_storage_humidity_ inventory_part_tab.min_storage_humidity%TYPE;
BEGIN
   min_storage_humidity_ := super(contract_, part_no_);

   IF (min_storage_humidity_ IS NULL) THEN
      min_storage_humidity_ := Part_Catalog_Invent_Attrib_API.Get_Min_Storage_Humidity(part_no_);
   END IF;
   RETURN (min_storage_humidity_);
END Get_Min_Storage_Humidity;


@Override
@UncheckedAccess
FUNCTION Get_Max_Storage_Humidity (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   max_storage_humidity_ inventory_part_tab.max_storage_humidity%TYPE;
BEGIN
   max_storage_humidity_ := super(contract_, part_no_);

   IF (max_storage_humidity_ IS NULL) THEN
      max_storage_humidity_ := Part_Catalog_Invent_Attrib_API.Get_Max_Storage_Humidity(part_no_);
   END IF;
   RETURN (max_storage_humidity_);
END Get_Max_Storage_Humidity;


@UncheckedAccess
FUNCTION Get_Storage_Width_Req_Source (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   storage_width_req_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, part_no_);
   IF (micro_cache_value_.storage_width_requirement IS NULL) THEN
      IF micro_cache_value_.unit_meas = Part_Catalog_API.Get_Unit_Code(part_no_) THEN
         storage_width_req_source_ := Part_Catalog_Invent_Attrib_API.Get_Storage_Width_Req_Source(part_no_);
      END IF;
   ELSE
      storage_width_req_source_ := Part_Structure_Level_API.Decode('INVENTORY_PART');
   END IF;
   RETURN (storage_width_req_source_);
END Get_Storage_Width_Req_Source;


@UncheckedAccess
FUNCTION Get_Storage_Height_Req_Source (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   storage_height_req_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, part_no_);
   IF (micro_cache_value_.storage_height_requirement IS NULL) THEN
      IF micro_cache_value_.unit_meas = Part_Catalog_API.Get_Unit_Code(part_no_) THEN
         storage_height_req_source_ := Part_Catalog_Invent_Attrib_API.Get_Storage_Height_Req_Source(part_no_);
      END IF;
   ELSE
      storage_height_req_source_ := Part_Structure_Level_API.Decode('INVENTORY_PART');
   END IF;
   RETURN (storage_height_req_source_);
END Get_Storage_Height_Req_Source;


@UncheckedAccess
FUNCTION Get_Storage_Depth_Req_Source (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   storage_depth_req_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, part_no_);
   IF (micro_cache_value_.storage_depth_requirement IS NULL) THEN
      IF micro_cache_value_.unit_meas = Part_Catalog_API.Get_Unit_Code(part_no_) THEN
         storage_depth_req_source_ := Part_Catalog_Invent_Attrib_API.Get_Storage_Depth_Req_Source(part_no_);
      END IF;
   ELSE
      storage_depth_req_source_ := Part_Structure_Level_API.Decode('INVENTORY_PART');
   END IF;
   RETURN (storage_depth_req_source_);
END Get_Storage_Depth_Req_Source;


@UncheckedAccess
FUNCTION Get_Storage_Volume_Req_Source (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   storage_volume_req_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, part_no_);
   IF (micro_cache_value_.storage_volume_requirement IS NULL) THEN
      IF micro_cache_value_.unit_meas = Part_Catalog_API.Get_Unit_Code(part_no_) THEN
         storage_volume_req_source_ := Part_Catalog_Invent_Attrib_API.Get_Storage_Volume_Req_Source(part_no_);
      END IF;
   ELSE
      storage_volume_req_source_ := Part_Structure_Level_API.Decode('INVENTORY_PART');
   END IF;
   RETURN (storage_volume_req_source_);
END Get_Storage_Volume_Req_Source;


@UncheckedAccess
FUNCTION Get_Storage_Weight_Req_Source (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   storage_weight_req_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, part_no_);
   IF (micro_cache_value_.storage_weight_requirement IS NULL) THEN
      IF micro_cache_value_.unit_meas = Part_Catalog_API.Get_Unit_Code(part_no_) THEN
         storage_weight_req_source_ := Part_Catalog_Invent_Attrib_API.Get_Storage_Weight_Req_Source(part_no_);
      END IF;
   ELSE
      storage_weight_req_source_ := Part_Structure_Level_API.Decode('INVENTORY_PART');
   END IF;
   RETURN (storage_weight_req_source_);
END Get_Storage_Weight_Req_Source;


@UncheckedAccess
FUNCTION Get_Min_Storage_Temp_Source (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   min_storage_temp_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, part_no_);
   IF (micro_cache_value_.min_storage_temperature IS NULL) THEN
      min_storage_temp_source_ := Part_Catalog_Invent_Attrib_API.Get_Min_Storage_Temp_Source(part_no_);
   ELSE
      min_storage_temp_source_ := Part_Structure_Level_API.Decode('INVENTORY_PART');
   END IF;
   RETURN (min_storage_temp_source_);
END Get_Min_Storage_Temp_Source;


@UncheckedAccess
FUNCTION Get_Max_Storage_Temp_Source (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   max_storage_temp_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, part_no_);
   IF (micro_cache_value_.max_storage_temperature IS NULL) THEN
      max_storage_temp_source_ := Part_Catalog_Invent_Attrib_API.Get_Max_Storage_Temp_Source(part_no_);
   ELSE
      max_storage_temp_source_ := Part_Structure_Level_API.Decode('INVENTORY_PART');
   END IF;
   RETURN (max_storage_temp_source_);
END Get_Max_Storage_Temp_Source;


@UncheckedAccess
FUNCTION Get_Min_Storage_Humid_Source (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   min_storage_humid_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, part_no_);
   IF (micro_cache_value_.min_storage_humidity IS NULL) THEN
      min_storage_humid_source_ := Part_Catalog_Invent_Attrib_API.Get_Min_Storage_Humid_Source(part_no_);
   ELSE
      min_storage_humid_source_ := Part_Structure_Level_API.Decode('INVENTORY_PART');
   END IF;
   RETURN (min_storage_humid_source_);
END Get_Min_Storage_Humid_Source;


@UncheckedAccess
FUNCTION Get_Max_Storage_Humid_Source (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   max_storage_humidity_source_ VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, part_no_);
   IF (micro_cache_value_.max_storage_humidity IS NULL) THEN
      max_storage_humidity_source_ := Part_Catalog_Invent_Attrib_API.Get_Max_Storage_Humid_Source(part_no_);
   ELSE
      max_storage_humidity_source_ := Part_Structure_Level_API.Decode('INVENTORY_PART');
   END IF;
   RETURN (max_storage_humidity_source_);
END Get_Max_Storage_Humid_Source;


PROCEDURE Check_Temperature_Range (
   part_no_  IN VARCHAR2,
   contract_ IN VARCHAR2 DEFAULT NULL )
IS
   min_storage_temperature_ inventory_part_tab.min_storage_temperature%TYPE;
   max_storage_temperature_ inventory_part_tab.max_storage_temperature%TYPE;

   CURSOR get_sites IS
      SELECT contract
      FROM inventory_part_tab
      WHERE part_no = part_no_;
BEGIN

   IF contract_ IS NOT NULL THEN
      min_storage_temperature_ := Get_Min_Storage_Temperature(contract_, part_no_);
      max_storage_temperature_ := Get_Max_Storage_Temperature(contract_, part_no_);

      IF (Part_Catalog_Invent_Attrib_API.Incorrect_Temperature_Range(min_storage_temperature_, max_storage_temperature_)) THEN
         Error_SYS.Record_General(lu_name_, 'TEMPRANGE: Incorrect Operative Temperature Range in Inventory Part :P1 on Site :P2.', part_no_, contract_);
      END IF;
   ELSE
      -- IF method is called from Part Catalog all parts on all sites must be checked
      FOR sites_rec_ IN get_sites LOOP
         min_storage_temperature_ := Get_Min_Storage_Temperature(sites_rec_.contract, part_no_);
         max_storage_temperature_ := Get_Max_Storage_Temperature(sites_rec_.contract, part_no_);

         IF (Part_Catalog_Invent_Attrib_API.Incorrect_Temperature_Range(min_storage_temperature_, max_storage_temperature_)) THEN
            Error_SYS.Record_General(lu_name_, 'TEMPRANGE: Incorrect Operative Temperature Range in Inventory Part :P1 on Site :P2.', part_no_, sites_rec_.contract);
         END IF;
      END LOOP;
   END IF;
END Check_Temperature_Range;


PROCEDURE Check_Humidity_Range (
   part_no_  IN VARCHAR2,
   contract_ IN VARCHAR2 DEFAULT NULL )
IS
   min_storage_humidity_ inventory_part_tab.min_storage_humidity%TYPE;
   max_storage_humidity_ inventory_part_tab.max_storage_humidity%TYPE;

   CURSOR get_sites IS
      SELECT contract
      FROM inventory_part_tab
      WHERE part_no = part_no_;
BEGIN
   IF contract_ IS NOT NULL THEN
      min_storage_humidity_ := Get_Min_Storage_Humidity(contract_, part_no_);
      max_storage_humidity_ := Get_Max_Storage_Humidity(contract_, part_no_);

      IF (Part_Catalog_Invent_Attrib_API.Incorrect_Humidity_Range(min_storage_humidity_, max_storage_humidity_)) THEN
         Error_SYS.Record_General(lu_name_, 'HUMRANGE: Incorrect Operative Humidity Range in Inventory Part :P1 on Site :P2.', part_no_, contract_);
      END IF;
   ELSE
      -- IF method is called from Part Catalog all parts on all sites must be checked
      FOR sites_rec_ IN get_sites LOOP
         min_storage_humidity_ := Get_Min_Storage_Humidity(sites_rec_.contract, part_no_);
         max_storage_humidity_ := Get_Max_Storage_Humidity(sites_rec_.contract, part_no_);

         IF (Part_Catalog_Invent_Attrib_API.Incorrect_Humidity_Range(min_storage_humidity_, max_storage_humidity_)) THEN
            Error_SYS.Record_General(lu_name_, 'HUMRANGE: Incorrect Operative Humidity Range in Inventory Part :P1 on Site :P2.', part_no_, sites_rec_.contract);
         END IF;
      END LOOP;
   END IF;
END Check_Humidity_Range;


@UncheckedAccess
FUNCTION Unit_Meas_Different_On_Sites (
  part_no_                  IN VARCHAR2,
  unit_meas_for_comparsion_ IN VARCHAR2 DEFAULT NULL) RETURN BOOLEAN
IS
   unit_meas_different_on_sites_ BOOLEAN := FALSE;
   compare_with_unit_meas_       inventory_part_tab.unit_meas%TYPE;
   conversion_factor_            NUMBER;

    CURSOR get_unit_meas IS
      SELECT unit_meas
      FROM   inventory_part_tab
      WHERE  part_no = part_no_;
BEGIN
   compare_with_unit_meas_ := unit_meas_for_comparsion_;

   FOR rec_ IN get_unit_meas LOOP
      IF (compare_with_unit_meas_ IS NULL) THEN
         compare_with_unit_meas_ := rec_.unit_meas;
      ELSE
         IF (rec_.unit_meas != compare_with_unit_meas_) THEN
            conversion_factor_ :=Technical_Unit_Conv_API.Get_Conv_Factor(compare_with_unit_meas_,rec_.unit_meas);
            IF (conversion_factor_ != 1) THEN
               unit_meas_different_on_sites_ := TRUE;
               EXIT;
            END IF;
         END IF;
      END IF;
   END LOOP;

   RETURN (unit_meas_different_on_sites_);
END Unit_Meas_Different_On_Sites;


@UncheckedAccess
FUNCTION Get_Putaway_Zone_Refill_Opt_Db (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   putaway_zone_refill_option_ inventory_part_tab.putaway_zone_refill_option%TYPE;
BEGIN
   Update_Cache___(contract_, part_no_);
   putaway_zone_refill_option_ := micro_cache_value_.putaway_zone_refill_option;
   IF (putaway_zone_refill_option_ IS NULL) THEN
      putaway_zone_refill_option_ := Site_Invent_Info_API.Get_Putaway_Zone_Refill_Opt_Db(contract_);
   END IF;
   RETURN putaway_zone_refill_option_;
END Get_Putaway_Zone_Refill_Opt_Db;


@UncheckedAccess
FUNCTION Get_Putaway_Refill_Option_Src(
   contract_ IN VARCHAR2, 
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   putaway_zone_refill_option_ inventory_part_tab.putaway_zone_refill_option%TYPE;
   source_                     VARCHAR2(200);
BEGIN
   Update_Cache___(contract_, part_no_);
   putaway_zone_refill_option_ := micro_cache_value_.putaway_zone_refill_option;
   IF (putaway_zone_refill_option_ IS NULL) THEN
      source_ := Planning_Hierarchy_Source_API.DB_SITE;
   ELSE
      source_ := Planning_Hierarchy_Source_API.DB_INVENTORY_PART;
   END IF;
   RETURN Planning_Hierarchy_Source_API.Decode(source_);
   
END Get_Putaway_Refill_Option_Src;


@UncheckedAccess
FUNCTION Get_Putaway_Zone_Refill_Option (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Putaway_Zone_Refill_Option_API.Decode(Get_Putaway_Zone_Refill_Opt_Db(contract_, part_no_));
END Get_Putaway_Zone_Refill_Option;


@UncheckedAccess
FUNCTION Get_Ultd_Expected_Supply_Date (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN DATE
IS
   ultd_expected_supply_date_ DATE;
   lu_rec_                    inventory_part_tab%ROWTYPE;
BEGIN
   lu_rec_                    := Get_Object_By_Keys___(contract_, part_no_);
   ultd_expected_supply_date_ := Get_Ultd_Expect_Supply_Date__(contract_,
                                                                 part_no_,
                                                                 lu_rec_.lead_time_code,
                                                                 Site_API.Get_Dist_Calendar_Id(contract_),
                                                                 Site_API.Get_Manuf_Calendar_Id(contract_),
                                                                 Site_API.Get_Site_Date(contract_));
   RETURN (ultd_expected_supply_date_);
END Get_Ultd_Expected_Supply_Date;


@UncheckedAccess
FUNCTION Get_Ultd_Manuf_Supply_Date (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN Get_Ultd_Manuf_Supply_Date__(contract_,
                                       part_no_,
                                       Site_API.Get_Manuf_Calendar_Id(contract_),
                                       Site_API.Get_Site_Date(contract_));
END Get_Ultd_Manuf_Supply_Date;


@UncheckedAccess
FUNCTION Get_Ultd_Purch_Supply_Date (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN Get_Ultd_Purch_Supply_Date__(contract_,
                                       part_no_,
                                       Site_API.Get_Dist_Calendar_Id(contract_),
                                       Site_API.Get_Site_Date(contract_));
END Get_Ultd_Purch_Supply_Date;


PROCEDURE Exist_With_Wildcard (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   dummy_ NUMBER;
   exist_ BOOLEAN;

   CURSOR exist_control IS
      SELECT 1
        FROM inventory_part_tab
       WHERE contract = contract_
         AND part_no LIKE NVL(part_no_,'%');
BEGIN
   
   IF (INSTR(NVL(part_no_,'%'), '%') = 0) THEN
      --No wildcard
      Exist(contract_, part_no_);
   ELSE
      --Wildcard
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      exist_ := exist_control%FOUND;
      CLOSE exist_control;

      IF (NOT exist_) THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'WILDNOTEXIST: Search criteria :P1 does not match any Inventory Part on Site :P2.', part_no_, contract_);
      END IF;
   END IF;
END Exist_With_Wildcard;


-- Transf_Invent_Part_To_Eng_Rev
--   Transform the key ref from lu: InventoryPart to EngPartRevision.
--   Used for Object Connection LU Transformations
FUNCTION Transf_Invent_Part_To_Eng_Rev (
   target_key_ref_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   source_key_ref_            VARCHAR2(2000);
   contract_                  inventory_part_tab.contract%TYPE;
   part_no_                   inventory_part_tab.part_no%TYPE; 
   eng_chg_level_             VARCHAR2(6);
BEGIN
   $IF Component_Mfgstd_SYS.INSTALLED $THEN
      contract_       := Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'CONTRACT');
      part_no_        := Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'PART_NO'); 

      eng_chg_level_  := Inventory_Part_Revision_API.Get_Eng_Chg_Level(contract_, part_no_, Site_API.Get_Site_Date(contract_));
      
      
      source_key_ref_ := 'PART_NO=' || part_no_ ||
                         '^PART_REV=' || Part_Revision_API.Get_Eng_Revision(contract_, part_no_, eng_chg_level_) ||'^';
   $END  
   RETURN source_key_ref_;      
END Transf_Invent_Part_To_Eng_Rev;


-- This method is used by DataCaptureInventUtil and DataCaptureMovePart
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_           IN VARCHAR2,
   capture_session_id_ IN NUMBER,
   type_code_          IN VARCHAR2 DEFAULT NULL,
   part_no_            IN VARCHAR2 DEFAULT NULL,
   lov_id_             IN NUMBER DEFAULT 1 )
IS
   lov_item_description_ VARCHAR2(200);
   session_rec_          Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_   NUMBER;
   exit_lov_             BOOLEAN := FALSE;

   CURSOR get_list_of_values1 IS
      SELECT part_no, description, type_code
      FROM   INVENTORY_PART_LOV2
      WHERE  contract = contract_
      AND    type_code = NVL(type_code_, type_code)
      ORDER BY Utility_SYS.String_To_Number(part_no) ASC, part_no ASC;

   CURSOR get_list_of_values2 IS
      SELECT distinct(contract)
      FROM   INVENTORY_PART_LOV2
      WHERE  part_no = part_no_
      ORDER BY Utility_SYS.String_To_Number(contract) ASC, contract ASC;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      IF (lov_id_ = 1) THEN
         FOR lov_rec_ IN get_list_of_values1 LOOP
            lov_item_description_ := lov_rec_.description;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.part_no,
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      ELSIF (lov_id_ = 2) THEN
         -- NOTE that this LOV actually fetches contract
         FOR lov_rec_ IN get_list_of_values2 LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.contract,
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


-- Get_Media_Id
--   This method returns the default Media ID for a specific Inventory Part
--   by which the media can be fetched from the Media Library
@UncheckedAccess
FUNCTION Get_Media_Id (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2) RETURN ROWID
IS
   media_id_   ROWID;
   objid_      INVENTORY_PART.objid%TYPE;
   objversion_ INVENTORY_PART.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, contract_, part_no_);
   media_id_ := Media_Library_Item_API.Get_Def_Media_Obj_Id(Media_Library_API.Get_Library_Id_From_Obj_Id(lu_name_, objid_));
   RETURN media_id_;
END Get_Media_Id;


PROCEDURE Check_Negative_On_Hand (
   neg_on_hand_allowed_db_          IN VARCHAR2,
   catch_unit_enabled_db_           IN VARCHAR2,
   receipt_issue_serial_track_db_   IN VARCHAR2,
   lot_tracking_code_db_            IN VARCHAR2 )
IS
BEGIN
   IF (neg_on_hand_allowed_db_ = Negative_On_Hand_API.DB_NEGATIVE_ON_HAND_ALLOWED) THEN
      IF (catch_unit_enabled_db_ = Fnd_Boolean_API.db_true ) THEN
         Error_SYS.Record_General(lu_name_,'CATCHUNITENABLED: Negative On Hand cannot be allowed when catch unit is enabled.');
      END IF;
      IF (receipt_issue_serial_track_db_ = Fnd_Boolean_API.db_true OR  lot_tracking_code_db_ != Part_Lot_Tracking_API.DB_NOT_LOT_TRACKING) THEN
         Error_SYS.Record_General(lu_name_,'NEGONHANDNOTALLOWED: Negative On Hand cannot be allowed when the part is Lot or Serial Tracked.');
      END IF;
   END IF;
END Check_Negative_On_Hand;

@UncheckedAccess
FUNCTION Get_Latest_Order_Date (
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   date_required_ IN DATE ) RETURN DATE
IS
   unlimited_supply_date_     DATE;
   unlimited_supply_date_tmp_ DATE;
   local_date_required_       DATE;
   old_order_date_            DATE;
   order_date_                DATE;
   order_date_tmp_            DATE;
   next_working_day_          DATE;
   too_late_order_date_       DATE;
   calendar_id_               VARCHAR2(10);
BEGIN
   local_date_required_ := TRUNC(date_required_);
   Update_Cache___(contract_, part_no_);
   calendar_id_ := CASE micro_cache_value_.lead_time_code
                      WHEN Inv_Part_Lead_Time_Code_API.DB_PURCHASED THEN Site_API.Get_Dist_Calendar_Id(contract_)
                      ELSE                                               Site_API.Get_Manuf_Calendar_Id(contract_)
                      END;
   -- Start the trial-and-error with assuming that we can order one work day before the date_required
   order_date_ := work_time_calendar_API.Get_Prior_Work_Day(calendar_id_, local_date_required_ - 1);
   LOOP
      unlimited_supply_date_ := NULL;
      order_date_tmp_        := order_date_;
      old_order_date_        := order_date_;
      LOOP
          IF (micro_cache_value_.lead_time_code = Inv_Part_Lead_Time_Code_API.DB_PURCHASED) THEN
             unlimited_supply_date_tmp_ := Inventory_Part_API.Get_Ultd_Purch_Supply_Date__(contract_         => contract_,
                                                                                       part_no_          => part_no_,
                                                                                       dist_calendar_id_ => calendar_id_,
                                                                                       site_date_        => order_date_tmp_);
          ELSE
             unlimited_supply_date_tmp_ := Inventory_Part_API.Get_Ultd_Manuf_Supply_Date__(contract_          => contract_,
                                                                                       part_no_           => part_no_,
                                                                                       manuf_calendar_id_ => calendar_id_,
                                                                                       site_date_         => order_date_tmp_);
          END IF;
          IF unlimited_supply_date_tmp_ IS NULL THEN
             EXIT;
          END IF;
          IF unlimited_supply_date_ IS NULL OR unlimited_supply_date_ = unlimited_supply_date_tmp_ THEN
             unlimited_supply_date_ := unlimited_supply_date_tmp_;
             order_date_ := order_date_tmp_;
             order_date_tmp_ := work_time_calendar_API.Get_Next_Work_day(calendar_id_,order_date_tmp_);
          ELSE
             EXIT;
          END IF;           
      END LOOP;
      IF (unlimited_supply_date_ < local_date_required_) THEN
         -- There is no point in placing the order this early. Try with the following work day.
         next_working_day_ := work_time_calendar_API.Get_Next_Work_day(calendar_id_ , order_date_);
         IF (next_working_day_ >= too_late_order_date_) THEN
            -- we have already found out that when ordering on the next working day we get the supply too late.
            -- So we have found the latest possible order date. Let's return it.
           EXIT;
         END IF;
         order_date_ := next_working_day_;
      ELSIF (unlimited_supply_date_ > local_date_required_) THEN
         -- we need to place the order at an earlier date.
         IF (unlimited_supply_date_ = micro_cache_value_.earliest_ultd_supply_date) THEN
            -- there will not be any earlier supply date regardless how early we place the order.
            -- So the date_required is impossible and therefore we return NULL.
            order_date_ := NULL;
            EXIT;
         END IF;
         -- order date was too late, so lets take a note on that.
         too_late_order_date_ := old_order_date_;
         -- Try again with an earlier order date. Reduce the current suggested order date with the number of days that differs
         -- between the supply date that we got and the supply date that we wish to have.
         order_date_ := old_order_date_ - (unlimited_supply_date_ - local_date_required_);
      ELSE
         -- We have managed to find an order date that gives us the exact supply date that we require. 
           EXIT;
      END IF;
   END LOOP;

   RETURN(order_date_);
END Get_Latest_Order_Date;




