-----------------------------------------------------------------------------
--
--  Logical unit: Site
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190927  SURBLK  Added Raise_Del_Address_Error___ to handle error messages and avoid code duplication.
--  160509  NWeelk  STRLOC-57, Modified Get_Packed_Customer_Data and Fetch_Int_Supplier_Info by adding new address information.   
--  160405  Rakalk  MATP-2099, CBS/CBSINT Split Moved code from Scheduling_Int_API to Cbs_So_Int_API.
--  160310  KhVeSe  LIM-4892, removed public method Remove_Data_Capture_Menu and modified method New_Data_Capture_Menu__().
--  160304  KhVese  LIM-6028, Added public method Get_Connected_Menu_Id().
--  160223  KhVese  LIM-4892, Added methods New_Data_Capture_Menu__(), Remove_Data_Capture_Menu__() and Remove_Data_Capture_Menu().
--  141124  DaZase  PRSC-4337, Added Get_Company_Address_Name().
--  141006  AwWelk  GEN-30,Modified Check_Insert___() by not allowing to put '*' symbol as the site name.
--  140311  AyAmlk  Bug 115778, Added a new method Check_Country_Code___() which will raise an info message when the site country is different from the delivery
--  140311          address country and called this in Insert___() and Update___(). Modified Unpack_Check_Insert___() and Unpack_Check_Update___() by removing 
--  140311          the code block which raised an error when the country codes are different.
--  130730  Chsllk Modified Insert___ to add a new record to rental tab.
--  130813  MaIklk TIBE-2738, Removed global variables and used conditional compilation instead.
--  120309  PraWlk Bug 101672, Modified Update___() by restructuring the code to give appropriate warning messages when 
--  120309         calendar ids have been switched to another ones.  
--  111118  MaEelk Added User Allowed Filter to COMPANY_SITE_LOV.
--  110810  LEPESE Added call to User_Default_API.New() from Insert___.
--  110610  LEPESE Added call to User_Allowed_Site_API.New() from Insert___.
--  111005  DeKoLK EANE-3742, Moved 'User Allowed Site' in Default Where condition from client.
--  110127  AndDse BP-3827, Moved code that adds info from Unpack_Check_Update___ to Update___.
--  101207  AndDse BP-3485, Modified functions Unpack_Check_Update___, Insert___ and Unpack_Check_Insert___ to use new function in Work_Time_Calendar_API to validate data.
--  101216  MaMalk Added validations in Unpack_Check_Insert___ and Unpack_Check_Update___ to validate the delivery address 
--  101216         country against the site country.
--  100430  Ajpelk Merge rose method documentation
--  100120  MaMalk Added global lu constants to replace the calls to Transaction_SYS.Logical_Unit_Is_Installed
--  100120         in the business logic.
--  091110  MaMalk Added method Get_Min_Offset_By_Company.
--  --------------------- 14.0.0 --------------------------------------------
--  090212  MalLlk Bug 80014, Added method Get_Default_Language_Db.
--  070417  Lisvse Added new LOV view to be used for Site
--  070316  Lisvse Changed due to FIPR663 - CompanySite in Enterprise. Removed attribute contract_ref. 
--                 Each site in site_tab must exist in company_site_tab. Description (contract_ref) of site is now stored 
--                 in company_site_tab. Company is stored both in site_tab and company_site_tab.
--  061106  NiBalk Bug 60671, Modified the procedure Unpack_Check_Insert___,
--  061106         in order to avoid special characters used by F1.
--  061106  RaKalk Added view COMPANY_HAVING_SITE
--  060515  IsAnlk Enlarge Address - Changed variable definitions.
--  060420  IsAnlk Enlarge customer - Changed variable definitions.
--  ------------------------- 13.4.0 ----------------------------------------
--  060123  JaJalk  Added Assert safe annotation.
--  051104  JoEd   Removed Get_Cost_Source_Id.
--  051103  IsAnlk Modified Get_Packed_Customer_Data to add default ean_location.
--  051018  KeFelk Changes due to redesign of Site LU.
--  051014  MaEelk Moved Structure_State_Default and Structure_Update logic from Site LU to SiteMfgstdInfo LU.
--  051013  MaEelk Site Re-design Changes
--  051012  IsAnlk Modified Insert___ to call Site_Invent_Info_API.New.
--  051006  KeFelk Moved some attributes and relavant methods to Site_invent_Info_API.
--  050922  JOHESE Added function Get_Cost_Source_Id
--  050921  IsAnlk Modified Get_Packed_Customer_Data to add ean_location to the message.
--  050919  NaLrlk Removed unused variables.
--  050411  ToBeSe Bug 49880, Modified procedure Update___ by adding parameter contract in
--                 calls to Work_Time_Calendar_API.Calendar_Switched.
--  050407  SeJalk Bug 47761, Added region_code and country_code, did relevent validations.
--  050328  RaSilk Modified Prepare_Insert___ to fetch default value for DOP_AUTO_CLOSE_DB.
--  050322  RaSilk Added the attribute DOP_AUTO_CLOSE.
--  050303  IsWilk Added FUNCTION Get_Currency_Converted_Cost,PROCEDURE Get_Currency_Converted___
--  050303         and moved the logic from FUNCTION Get_Currency_Converted_Amount to
--  050303         PROCEDURE Get_Currency_Converted___.
--  050301  SaNalk Added column SHPORD_RECEIPT_BACKGROUND to SITE_TAB.Added method Get_Shpord_Receipt_Background.
--  050202  LEPESE Added procedures Check_Ownership_Transfer_Point and
--                 Check_Invoice_Consideration___. Added calls to method
--                 Check_Invoice_Consideration___ from unpack_check_insert___ and
--                 unpack_check_update___. Added new validation between invoice_consideration
--                 and ownership_transfer_point on company in Check_Invoice_Consideration___.
--  050106  VeMolk Bug 44226, Added new public attribute document_address_id. Modified the the
--  050106         methods Get_Document_Address_Id, Unpack_Check_Insert___ and Unpack_Check_Update___.
--  041129  KanGlk Added the function Get_Currency_Converted_Amount.
--  040903  LoPrlk Some modifications were done to method Get_Packed_Customer_Data.
--  040901  LoPrlk Added the methods Get_Packed_Customer_Data and Fetch_Int_Supplier_Info.
--  040707  KaDilk Bug 45057, Added new public attribute  avg_work_days_per_week to the site_tab and set the default
--  040707         value to 5 days. Modified procedures Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040513  IsWilk Modified the PROCEDUREs Insert___ and Delete___ to call the QUAMAN methods.
--  040511  HeWelk   Modifications according to 'Date & Lead Time Realignment'
--  040426  IsAnlk B114403 - Replaced actual_cost by invoice_consideration in Procedure Update_Cache___
--  **************  Touchdown Merge Begin  *********************
--  040128  JoAnSe Replaced actual_cost attribute with invoice_consideration
--  **************  Touchdown Merge End    *********************
--  040311  IsWilk Removed the commented codes which were added to described
--  040311         the red codes appear after micro cache implementation.
--  040304  NALWLK Added two columns NETWORK_ID, MRP_RUN_DATE and PROCEDURE Update_Planned_Info()
--                 for Planning Network.
--  040224  SaNalk Removed SUBSTRB.
--  040223  IsAnlk B112831, Closed cursors in Get_Max_Offset and Get_Min_Offset.
--  040202  GeKalk Rewrote DBMS_SQL using Native dynamic SQL for UNICODE modifications.
--  040129  LaBolk Removed view SITE_PUBLIC with its define and undefine statements in order to include it in the package specification.
--  040126  IsAnlk Implemented MicroCache. Added new mehods Invalidate_Cache___ and Update_Cache___
--                 and changed get methods accordingly.
--  040121  JeLise Bug 40240, Moved definition of SITE_PUBLIC to api-file.
--  040119  LaBolk Added a comment for cursor get_site_cur indicating that it should be removed.
--  -------------------------------- 13.3.0 -------------------------------
--  031030  JoEd   Added manuf and dist calendar IDs to SITE_PUBLIC view.
--  031013  PrJalk Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  030902  JaJalk Call 100185, Restricted the combination of 'Standard Cost' and 'Include Service Cost' for new records.
--  030820  DAYJLK Performed CR Merge.
--  030611  SeKalk Modified View SITE
--  030424  SeKalk Removed GLOBAL LU CONSTANTS section
--  030423  BhRalk Added new method Get_Del_Addr_By_Company.
--  030321  SeKalk Replaced occurences of Site_Delivery_Address_API with Company_Address_Deliv_Info_API
--  **************************** CR Merge ***********************************
--  030610  JaJalk Modified the Get method.
--  030609  JaJalk Added the new field EXT_SERVICE_COST_METHOD as a not null column.
--  030509  JOHESE Added function Check_Vim_Used
--  030403  GEBOSE Addded column VIM_MRO_USAGE to the SITE_TAB.
--  020813  NABE   Fixed Prepare_Insert___ method to send Db values for the three disp cond check box.
--  020723  NABE   Added default values for disp_cond_customer_order, disp_cond_purchase_order, disp_cond_work_order
--                 in Unpack_Check_Insert___ and Unpack_Check_Update___ methods.
--                 This can be removed if client is fixed.
--  020705  PEKR   Added columns disp_cond_customer_order, disp_cond_purchase_order, disp_cond_work_order
--                 and functions Display_Cond_Customer_Order, Display_Cond_Purchase_Order, Display_Cond_Work_Order.
--  020609  jagr   Added public attribute MESSAGE_RECEIVER.
--  **************************** TSO Merge **********************************
--  030123  SuAmlk Added column BRANCH.
--  020109  JICE   Added description to SITE_PUBLIC for Sales Configurator.
--  011011  sobj   Bug 21598, Modified condition for call to CBS-module in function Update__
--  011009  PuIllk  Bug fix 24658, Modify Company length to VARCHAR(20) in view comments.
--  010924  sobj   Bug 21598, Modified call to CBS-module in function Update__
--  010306  Makulk Bug fixed 19968, Added information message to the PROCEDURE Update___.
--  010305  Susalk Bug fix 20130, Added a check to get user allowed sites in Unpack_Check_Update___.
--  010228  IsWilk Bug Fix 20131, Added the Information message to the PROCEDURE Insert___,Unpack_Check_Update___
--                 when the chosen calendar id is in state ChangesPending.
--  010214  JeAsSe Added check to insure that variable CONTRACT does not contain percentage sign
--                 and errormessage NOPERCENTSIGN.
--  001208  ANLASE Added errormessage STRUCSTATINVALID.
--  001204  ANLASE Corrected errormessage STRUCUPDINVALID.
--  001120  LEPE   Added default value for actual_cost_db in method prepare_insert___.
--  001115  JOHESE Added Error_SYS.Check_Not_Null calls in Unpack_Check_Update___
--  001115  LEPE   Added combination validation for Actual Cost and
--                 inventory valuation method. AC is only allowed for Standard Cost.
--  001113  LEPE   Moved method FUNCTION Get_Actual_Cost_Db to correct position.
--  001027  MaGu   Added column Cust_Order_Discount_Method.
--  001022  JOKE   Added column last_actual_cost_calc and methods to set and
--                 get the same.
--  001016  JOHESE Added column Cust_Order_Pricing_Method.
--  001014  JOKE   Added public method Get_Actual_Cost_Db.
--  001010  JOKE   Added actual_cost to prepare insert.
--  000925  JOHESE Added undefines.
--  000914  JOHESE Added column disposition_of_quotation.
--  000914  JOKE   Added column actual_cost.
--  000907  ANLASE Modified text in error message for Structure_State_Default.
--  000823  ANLASE Added validation for negative values on count_diff_amount and count_diff_percentage.
--  000823  ANLASE Added attribute Structure_State_Default and function
--                 Get_Structure_State_Default_Db.
--  000418  NISOSE Added General_SYS.Init_Method in Get_Control_Type_Value_Desc.
--  000329  ANLASE Added attribute picking_leadtime.
--  000126  SHVE   Removed validations for inventory_value_method in unpack_check_update.
--  000119  JOHW   Added create Kanban defaults for a new site, in insert___.
--  991229  ANHO   Added attributes count_diff_amount and count_diff_percentage.
--  991206  LEPE   Added company to public view Site_Public.
--  990518  FRDI   Added function Get_Min_Offset and Get_Max_Offset.
--  990518  DAZA   Fixed a checkbug in Unpack_Check_Insert___.
--  990422  DAZA   General performance improvements.
--  990413  JOHW   Upgraded to performance optimized template.
--  990401  JOHW   Added Checks on Logical_Unit_Is_Installed when calling dynamic.
--  990318  FRDI   Change behaviour of errors due to invalid for calendar.
--  990317  FRDI   Added control of offset column, +/- 24h, server may not be in Greenwich.
--  990224  JOHW   Changed labels on some error_sys messages in unpack_check_update.
--  990219  FRDI   Changed Structure_Update to update allowed and mandatory.
--  990212  JOHW   Added validation to Purch Purchase_Part_Supplier_API.Check_Consignment_Exist
--                 and Purchase_Order_Line_Part_API.Check_Consignment_Exist from unpack_check_update.
--  990211  JOHW   Added validation to Inventory_Part_Loc_Consign from unpack_check_update.
--  980121  FRDI   Added default parameters to prepare_Insert.
--  980121  FRDI   Added Get_Inventory_Value_Method_Db and Get_Negative_On_Hand_Db.
--  990121  JoEd   Call Id 7219: Added extra validation on the two calendar ids.
--  990120  FRDI   Added Purch_Comp_Method and Structure_Update columns and
--                 function Get_Structure_Update_Db
--  990119  DAZA   Added dynamic call in insert to create default warehouse task
--                 types in warehouse task type setup
--  981222  FRDI   Added offset, allow negative values on hand and
--                 inventory value method columns and Get_Site_Date.
--  981130  SHVE   Added dynamic call to create default cost sets for a new site.
--  981027  JoEd   Added dist_calendar_id and manuf_calendar_id.
--  980616  JOHNI  Created view SITE_PUBLIC.
--  980317  FRDI   Supp 879 : Moved LU:SITE_DELIVERY_ADDRESS_API from purch to mpccom.
--  980213  LEPE   Added new view for List of Values.
--  971121  TOOS   Upgrade to F1 2.0
--  970507  FRMA   Added Get_Control_Type_Value_Desc.
--  970506  FRMA   Changed reference from MpccomCompany to CompanyFinance for
--                 attribute company.
--  970424  PEKR   Added public cursor Get_Site_Cur.
--  970324  MAGN   Added column company to &VIEW and added function Get_Company.
--  970313  MAGN   Changed tablename contract_contract_ref to site_tab.
--  970226  MAGN   Uses column rowversion as objversion(timestamp).
--  961214  JOKE   Modified with new workbench default templates.
--  961121  JOKE   Modified for workbench.
--  960918  LEPE   Added exception handling for dynamic SQL.
--  960819  CAJO   Replaced "Delivery Address" with "Receiver" in view comment.
--  960811  MAOS   Modified error message within the dynamic call.
--  960811  MAOS   Replaced call to Site_Delivery_Address with dynamic SQL.
--  960517  AnAr   Added purpose comment to file.
--  960307  SHVE   Changed LU Name GenSite.
--  960209  LEPE   Bug 96-0009. Reference to PurDeliveryAddress was missing.
--  951116  BJSA   Added Get_delivery_address
--  951025  SHVE   Base Table to Logical Unit Generator 1.0
--  150805	AKDELK Added Is_Company_Site_Available()
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Site_Address_Info IS RECORD( contract         VARCHAR2(5),
                                  delivery_address VARCHAR2(50));

TYPE Site_Address_Info_Type IS TABLE OF Site_Address_Info
        INDEX BY BINARY_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Currency_Converted___
--   This procedure will convert the cost or amount from one
--   base currency to another and out the the converted cost or amount.
PROCEDURE Get_Currency_Converted___ (
   to_contract_curr_amount_   OUT NUMBER,
   from_contract_             IN  VARCHAR2,
   to_contract_               IN  VARCHAR2,
   from_contract_curr_amount_ IN  NUMBER,
   make_currency_rounding_    IN  BOOLEAN )
IS
   from_company_       SITE_TAB.company%TYPE;
   to_company_         SITE_TAB.company%TYPE;
   from_currency_code_ VARCHAR2(3);
   to_currency_code_   VARCHAR2(3);
   from_currency_type_ VARCHAR2(10);
   from_conv_factor_   NUMBER;
   from_currency_rate_ NUMBER;
   currency_rounding_  NUMBER;
BEGIN

   to_contract_curr_amount_ := from_contract_curr_amount_;

   IF (from_contract_ != to_contract_) THEN
      from_company_ := Get_Company(from_contract_);
      to_company_   := Get_Company(to_contract_);

      IF (from_company_ != to_company_) THEN
         from_currency_code_ := Company_Finance_API.Get_Currency_Code(from_company_);
         to_currency_code_   := Company_Finance_API.Get_Currency_Code(to_company_);

         IF (from_currency_code_ != to_currency_code_) THEN
            Currency_Code_API.Exist(to_company_, from_currency_code_);
            Currency_Rate_API.Get_Currency_Rate_Defaults(from_currency_type_,
                                                         from_conv_factor_,
                                                         from_currency_rate_,
                                                         to_company_,
                                                         from_currency_code_,
                                                         Get_Site_Date(to_contract_));
            to_contract_curr_amount_ := to_contract_curr_amount_ * from_currency_rate_/from_conv_factor_;

            IF (make_currency_rounding_) THEN
               currency_rounding_       := Currency_Code_API.Get_Currency_Rounding(to_company_, to_currency_code_);
               to_contract_curr_amount_ := ROUND(to_contract_curr_amount_, currency_rounding_);
            END IF;
         END IF;
      END IF;
   END IF;
END Get_Currency_Converted___;


-- Check_Country_Code___
--    This procedure will raise an info message if the Delivery
--    address country is different from the Site country.
PROCEDURE Check_Country_Code___ (
   newrec_ IN SITE_TAB%ROWTYPE )
IS
   site_country_code_       VARCHAR2(2);
   deliv_addr_country_code_ VARCHAR2(2);
BEGIN
   site_country_code_       := Company_Site_API.Get_Country_Db(newrec_.contract);
   deliv_addr_country_code_ := Company_Address_API.Get_Country_Db(newrec_.company, newrec_.delivery_address);

   IF (site_country_code_ != deliv_addr_country_code_) THEN
      Client_SYS.Add_Info(lu_name_, 'DIFFCOUNTRYINADDR: The delivery address country :P1 is not the same as the site country :P2.', 
                            Iso_Country_API.Get_Description(deliv_addr_country_code_), Iso_Country_API.Get_Description(site_country_code_));
   END IF;
END Check_Country_Code___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('OFFSET', 0, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SITE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);

   IF (newrec_.delivery_address IS NOT NULL) THEN
      Check_Country_Code___(newrec_);
   END IF;
   -- create default invent info for a new site.
   $IF (Component_Invent_SYS.INSTALLED) $THEN
      Site_Invent_Info_API.New(newrec_.contract);               
   $END

   -- create default ipr info for a new site.
   $IF (Component_Invpla_SYS.INSTALLED) $THEN
      Site_Ipr_Info_API.New(newrec_.contract);               
   $END
   -- create default discom info for a new site.
   $IF (Component_Discom_SYS.INSTALLED) $THEN
      Site_Discom_Info_API.New(newrec_.contract);      
   $END

   -- create default mfgstd info for a new site.
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      Site_Mfgstd_Info_API.New(newrec_.contract);       
   $END

   -- create default mscom info for a new site.
   $IF (Component_Mscom_SYS.INSTALLED) $THEN
      Site_Mscom_Info_API.New(newrec_.contract);              
   $END

   -- create default cost sets for a new site.
   $IF (Component_Cost_SYS.INSTALLED) $THEN
      Cost_Set_API.Create_Default(newrec_.contract); 
   $END

   -- create default warehouse task types in warehouse task type setup.
   $IF (Component_Invent_SYS.INSTALLED) $THEN
      Warehouse_Task_Type_Setup_API.New_Site(newrec_.contract);
   $END

   -- create Kanban defaults for a new Site in Kanban Setup.
   $IF (Component_Kanban_SYS.INSTALLED) $THEN
      Kanban_Setup_API.New_Site(newrec_.contract);
   $END

   -- create default rental info for a new site.
   $IF (Component_Rental_SYS.INSTALLED) $THEN
      Site_Rental_Info_API.New(newrec_.contract);
   $ELSE
      NULL;
   $END

   Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.dist_calendar_id);

   IF (newrec_.dist_calendar_id != newrec_.manuf_calendar_id) THEN
      Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.manuf_calendar_id);
   END IF;

   SELECT rowid
      INTO  objid_
      FROM  SITE_TAB
      WHERE contract = newrec_.contract;

   $IF (Component_Quaman_SYS.INSTALLED) $THEN
      Qman_Mandatory_Site_API.New(newrec_.contract);     
   $END

   User_Default_API.New(Fnd_Session_API.Get_Fnd_User);
   User_Allowed_Site_API.New(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SITE_TAB%ROWTYPE,
   newrec_     IN OUT SITE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF ((NVL(newrec_.delivery_address, Database_SYS.string_null_) != NVL(oldrec_.delivery_address, Database_SYS.string_null_))
        AND newrec_.delivery_address IS NOT NULL) THEN
      Check_Country_Code___(newrec_);
   END IF;
   -- Tell the calendar dependent LU's that the calendar id has been switched to another one
   IF (newrec_.dist_calendar_id != oldrec_.dist_calendar_id) THEN
      IF (Work_Time_Calendar_API.Get_Max_Work_Day(oldrec_.dist_calendar_id) > Work_Time_Calendar_API.Get_Max_Work_Day(newrec_.dist_calendar_id)) THEN
          IF (Work_Time_Calendar_API.Get_Min_Work_Day(oldrec_.dist_calendar_id) < Work_Time_Calendar_API.Get_Min_Work_Day(newrec_.dist_calendar_id))THEN
             Client_SYS.Add_Info(lu_name_, 'CAL_START_END_DIF: The specified time period in calendar :P1 is shorter than that of calendar :P2. This may affect outstanding orders.', newrec_.dist_calendar_id, oldrec_.dist_calendar_id);
          ELSE
             Client_SYS.Add_Info(lu_name_, 'CAL_EARLIER: The end date for calendar :P1 is earlier than for calendar :P2. This may affect outstanding orders.', newrec_.dist_calendar_id, oldrec_.dist_calendar_id); 
          END IF;
      ELSE
         IF (Work_Time_Calendar_API.Get_Min_Work_Day(oldrec_.dist_calendar_id) < Work_Time_Calendar_API.Get_Min_Work_Day(newrec_.dist_calendar_id)) THEN
            Client_SYS.Add_Info(lu_name_, 'CAL_LATER: The start date for calendar :P1 is later than for calendar :P2. This may affect outstanding orders.', newrec_.dist_calendar_id, oldrec_.dist_calendar_id);    
         END IF;
      END IF;
      Work_Time_Calendar_API.Calendar_Switched(newrec_.dist_calendar_id, newrec_.contract);
   END IF;

   IF ((newrec_.manuf_calendar_id != oldrec_.manuf_calendar_id)
     AND ((newrec_.dist_calendar_id = oldrec_.dist_calendar_id)                -- only skip if made
            OR (newrec_.dist_calendar_id != newrec_.manuf_calendar_id))) THEN  -- for dist.cal
        IF (Work_Time_Calendar_API.Get_Max_Work_Day(oldrec_.manuf_calendar_id) > Work_Time_Calendar_API.Get_Max_Work_Day(newrec_.manuf_calendar_id)) THEN
          IF (Work_Time_Calendar_API.Get_Min_Work_Day(oldrec_.manuf_calendar_id) < Work_Time_Calendar_API.Get_Min_Work_Day(newrec_.manuf_calendar_id)) THEN
             Client_SYS.Add_Info(lu_name_, 'CAL_START_END_DIF: The specified time period in calendar :P1 is shorter than that of calendar :P2. This may affect outstanding orders.', newrec_.manuf_calendar_id, oldrec_.manuf_calendar_id);
          ELSE
             Client_SYS.Add_Info(lu_name_, 'CAL_EARLIER: The end date for calendar :P1 is earlier than for calendar :P2. This may affect outstanding orders.', newrec_.manuf_calendar_id, oldrec_.manuf_calendar_id); 
          END IF;
      ELSE
         IF (Work_Time_Calendar_API.Get_Min_Work_Day(oldrec_.manuf_calendar_id) < Work_Time_Calendar_API.Get_Min_Work_Day(newrec_.manuf_calendar_id)) THEN
            Client_SYS.Add_Info(lu_name_, 'CAL_LATER: The start date for calendar :P1 is later than for calendar :P2. This may affect outstanding orders.', newrec_.manuf_calendar_id, oldrec_.manuf_calendar_id);    
         END IF;
      END IF;
      Work_Time_Calendar_API.Calendar_Switched(newrec_.manuf_calendar_id, newrec_.contract);
   END IF;

   IF (oldrec_.dist_calendar_id != newrec_.dist_calendar_id) THEN
      Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.dist_calendar_id);
   END IF;

   IF (oldrec_.manuf_calendar_id != newrec_.manuf_calendar_id) THEN
      IF NOT((newrec_.manuf_calendar_id = newrec_.dist_calendar_id) AND (newrec_.dist_calendar_id != oldrec_.dist_calendar_id)) THEN
         Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.manuf_calendar_id);
      END IF;
   END IF;
   
   $IF (Component_Cbsint_SYS.INSTALLED) $THEN
      IF (oldrec_.offset != newrec_.offset) THEN
         DECLARE
            check_contract_ BOOLEAN;
         BEGIN
            check_contract_ := Scheduling_Site_Config_API.Check_Contract(newrec_.contract);
            IF (check_contract_) THEN
               Cbs_So_Int_API.Modify_Site(newrec_.contract,
                                              newrec_.dist_calendar_id,
                                              oldrec_.dist_calendar_id,
                                              newrec_.offset,
                                              oldrec_.offset);
            END IF;
         END;
      END IF;
   $END
   Invalidate_Cache___;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN SITE_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);

   $IF (Component_Quaman_SYS.INSTALLED) $THEN
      Qman_Mandatory_Site_API.Remove(remrec_.contract);      
   $END
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(4000);
   delivery_address_exists_ VARCHAR2(5);
BEGIN
   
   IF (newrec_.contract = '*') THEN
      Error_SYS.Record_General(lu_name_,'NOSTARSIGN: Site ID cannot be * sign');
   END IF;
      
   IF (indrec_.contract) THEN 
      IF (instr(newrec_.contract, '%') > 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOPERCENTSIGN: Site ID cannot contain % sign.');
      END IF;
   END IF;
   
   IF (Client_SYS.Item_Exist('DESCRIPTION', attr_)) THEN 
      Error_SYS.Item_Insert(lu_name_, 'DESCRIPTION');
   END IF;
 
   super(newrec_, indrec_, attr_);

   Error_SYS.Check_Valid_Key_String('CONTRACT', newrec_.contract);

   -- Note: Check Delivery Address
   IF (newrec_.delivery_address IS NOT NULL) THEN
      -- Note: Checks whether the address is of type DELIVERY
      delivery_address_exists_ := Company_Address_Type_API.Check_Exist(newrec_.company,
                                                                       newrec_.delivery_address,
                                                                       Address_Type_Code_API.Decode('DELIVERY'));
      IF (delivery_address_exists_ = 'FALSE') THEN
         Raise_Del_Address_Error___(newrec_.company, newrec_.delivery_address);
      END IF;
   END IF;

   IF newrec_.offset>24 OR newrec_.offset<-24 THEN
      Error_SYS.Record_General(lu_name_, 'OFFOFFSET: Time offset must be between -24 and 24 hours.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     site_tab%ROWTYPE,
   newrec_ IN OUT site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                     VARCHAR2(30);
   value_                    VARCHAR2(4000);
   delivery_address_exists_  VARCHAR2(5);
   char_null_                VARCHAR2(12) := 'VARCHAR2NULL';
BEGIN

   IF (Client_SYS.Item_Exist('DESCRIPTION', attr_)) THEN 
      Error_SYS.Item_Insert(lu_name_, 'DESCRIPTION');
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,newrec_.contract);

   IF (newrec_.offset>24) OR (newrec_.offset<-24) THEN
      Error_SYS.Record_General(lu_name_, 'OFFOFFSET: Time offset must be between -24 and 24 hours.');
   END IF;
   
   IF ((NVL(newrec_.delivery_address, char_null_) != NVL(oldrec_.delivery_address, char_null_))
        AND newrec_.delivery_address IS NOT NULL) THEN
      -- Note: Checks whether the address is of type DELIVERY
      delivery_address_exists_ := Company_Address_Type_API.Check_Exist(newrec_.company,
                                                                       newrec_.delivery_address,
                                                                       Address_Type_Code_API.Decode('DELIVERY'));
      IF (delivery_address_exists_ = 'FALSE') THEN
         Raise_Del_Address_Error___(newrec_.company, newrec_.delivery_address);
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   contract_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_, p1_ => contract_);
   super(contract_);
END Raise_Record_Not_Exist___;


PROCEDURE Raise_Del_Address_Error___ (
   company_      VARCHAR2,
   del_address_  VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'DELTYPENOTEXISTIN: Address ID :P1 in company :P2 is not a delivery address.', del_address_, company_ );
END Raise_Del_Address_Error___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
@UncheckedAccess
PROCEDURE New_Data_Capture_Menu__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2)
IS
   contract_       SITE_TAB.contract%TYPE;
   newrec_         SITE_TAB%ROWTYPE;
   oldrec_         SITE_TAB%ROWTYPE;
   indrec_         Indicator_Rec;
   newattr_        VARCHAR2(1500);
   exit_procedure_ EXCEPTION;
BEGIN
   IF (action_ = 'PREPARE') THEN
      RAISE exit_procedure_;
   END IF;
   
   contract_ := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   Exist(contract_);
   Get_Id_Version_By_Keys___(objid_, objversion_, contract_);
   Client_SYS.Add_To_Attr('DATA_CAPTURE_MENU_ID', Client_SYS.Get_Item_Value('DATA_CAPTURE_MENU_ID', attr_), newattr_);

   IF (action_ = 'CHECK') THEN
      oldrec_ := Get_Object_By_Id___(objid_);      
      newrec_ := oldrec_;     
      Unpack___(newrec_, indrec_, newattr_);
      Check_Update___(oldrec_, newrec_, indrec_, newattr_);      
   ELSIF (action_ = 'DO') THEN
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;      
      Unpack___(newrec_, indrec_, newattr_);
      IF Validate_SYS.Is_Equal(oldrec_.data_capture_menu_id, newrec_.data_capture_menu_id) THEN 
         Error_SYS.Record_Exist('Site');
      END IF;
      Check_Update___(oldrec_, newrec_, indrec_, newattr_);
      Update___(objid_, oldrec_, newrec_, newattr_, objversion_);
      IF ((oldrec_.data_capture_menu_id IS NOT NULL) AND (newrec_.data_capture_menu_id IS NOT NULL)) THEN  
         Client_SYS.Add_Info(lu_name_, 'CHANGEMENU: The warehouse data collection menu ID for site :P1 was changed from :P2 to :P3.', 
                             newrec_.contract, oldrec_.data_capture_menu_id, newrec_.data_capture_menu_id );
      END IF ; 
   END IF;
   info_ := Client_SYS.Get_All_Info;
   
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END New_Data_Capture_Menu__;

   
PROCEDURE Remove_Data_Capture_Menu__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   attr_             VARCHAR2(2000);
   newrec_           SITE_TAB%ROWTYPE;
   oldrec_           SITE_TAB%ROWTYPE;
   indrec_           Indicator_Rec;
   new_objversion_   SITE.objversion%TYPE := objversion_;
BEGIN
   Client_SYS.Add_To_Attr('DATA_CAPTURE_MENU_ID', to_char(NULL), attr_);
   IF (action_ = 'CHECK') THEN
      oldrec_ := Get_Object_By_Id___(objid_);      
      newrec_ := oldrec_;     
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);      
   ELSIF (action_ = 'DO') THEN
      oldrec_ := Lock_By_Id___(objid_, new_objversion_);
      newrec_ := oldrec_;      
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, new_objversion_);
   END IF;
   
END Remove_Data_Capture_Menu__;
   
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Company_Site_API.Get_Description(contract_);
END Get_Description;


-- Get_Control_Type_Value_Desc
--   Procedure to get description for accounting rules.
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
  description_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;


-- Get_Site_Date
--   Fetches Site Date, which is sysdate + offset.
@UncheckedAccess
FUNCTION Get_Site_Date (
   contract_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN SYSDATE + (Get_Offset(contract_) / 24);
END Get_Site_Date;


@UncheckedAccess
FUNCTION Get_Min_Offset RETURN NUMBER
IS
  temp_ SITE_TAB.offset%TYPE;
   CURSOR get_attr IS
      SELECT MIN(offset)
      FROM SITE_TAB;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_ ;
   CLOSE get_attr;
   RETURN temp_;
END Get_Min_Offset;


@UncheckedAccess
FUNCTION Get_Min_Offset_By_Company (
   company_ IN VARCHAR2) RETURN NUMBER
IS
  temp_ SITE_TAB.offset%TYPE;
   CURSOR get_attr IS
      SELECT MIN(offset)
      FROM   SITE_TAB
      WHERE  company = company_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_ ;
   CLOSE get_attr;
   RETURN temp_;
END Get_Min_Offset_By_Company;


@UncheckedAccess
FUNCTION Get_Max_Offset RETURN NUMBER
IS
   temp_ SITE_TAB.offset%TYPE;
   CURSOR get_attr IS
      SELECT MAX(offset)
      FROM SITE_TAB;
BEGIN
  OPEN get_attr;
  FETCH get_attr INTO temp_ ;
  CLOSE get_attr;
  RETURN temp_;
END Get_Max_Offset;


-- Get_Del_Addr_By_Company
--   This will return connected site and its delivery address for
--   a particular Company.
PROCEDURE Get_Del_Addr_By_Company (
   count_                 OUT NUMBER,
   delivery_address_info_ OUT SITE_ADDRESS_INFO_TYPE,
   company_               IN VARCHAR2 )
IS
   index_no_      NUMBER:=-1;
   address_array_ SITE_ADDRESS_INFO_TYPE;

   CURSOR get_address IS
      SELECT contract,delivery_address
      FROM SITE_TAB
      WHERE company = company_;
BEGIN
   FOR i IN get_address LOOP
      IF (index_no_ = -1) THEN
         index_no_ :=0;
      END IF;
      address_array_(index_no_).contract := i.contract;
      address_array_(index_no_).delivery_address := i.delivery_address;
      index_no_ := index_no_ + 1;
   END LOOP;
   count_ :=index_no_-1;
   delivery_address_info_ := address_array_;
END Get_Del_Addr_By_Company;


-- Get_Packed_Customer_Data
--   Fetches necessary information in order to create the internal customer.
FUNCTION Get_Packed_Customer_Data (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   site_rec_        Public_Rec;
   del_addr_rec_    Company_Address_API.Public_Rec;
   doc_addr_rec_    Company_Address_API.Public_Rec;
   del_addr_name_   VARCHAR2(2000);
   doc_addr_name_   VARCHAR2(2000);
   customer_no_     Customer_Info_Public.customer_id%TYPE;
   msg_             VARCHAR2(32000);
   doc_addr_        site_tab.delivery_address%TYPE;
   extended_search_ VARCHAR2(5) := 'FALSE';   
BEGIN
   site_rec_ := Get(contract_);

   $IF (Component_Discom_SYS.INSTALLED) $THEN
      doc_addr_ := Site_Discom_Info_API.Get_Document_Address_Id(contract_, extended_search_);               
   $END
   
   $IF (Component_Invent_SYS.INSTALLED) $THEN
      IF (site_rec_.delivery_address IS NOT NULL OR doc_addr_ IS NOT NULL) THEN
         del_addr_name_ := Company_Address_Deliv_Info_API.Get_Address_Name(site_rec_.company, site_rec_.delivery_address);
         doc_addr_name_ := Company_Address_Deliv_Info_API.Get_Address_Name(site_rec_.company, doc_addr_);            
      END IF;
   $END

   del_addr_rec_ := Company_Address_API.Get(site_rec_.company, site_rec_.delivery_address);

   doc_addr_rec_ := Company_Address_API.Get(site_rec_.company, doc_addr_);

   IF (Party_Identity_Series_API.Get_Next_Value(Party_Type_API.Decode('CUSTOMER')) IS NOT NULL) THEN
      LOOP
         Party_Identity_Series_API.Get_Next_Identity(customer_no_, 'CUSTOMER');
         EXIT WHEN Customer_Info_API.Check_Exist(customer_no_) = 'FALSE';
      END LOOP;
   END IF;
     
   msg_ := Message_SYS.Construct('SITE');      
   Message_SYS.Add_Attribute(msg_, 'NEW_CUSTOMER_ID',      customer_no_);
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDR_NO',          site_rec_.delivery_address);
   Message_SYS.Add_Attribute(msg_, 'DEL_NAME',             del_addr_name_);
   Message_SYS.Add_Attribute(msg_, 'DEL_NAME',             del_addr_name_);
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDRESS1',         del_addr_rec_.address1);
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDRESS2',         del_addr_rec_.address2);
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDRESS3',         del_addr_rec_.address3);
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDRESS4',         del_addr_rec_.address4);
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDRESS5',         del_addr_rec_.address5);
   Message_SYS.Add_Attribute(msg_, 'DEL_ADDRESS6',         del_addr_rec_.address6);
   Message_SYS.Add_Attribute(msg_, 'DEL_ZIP_CODE',         del_addr_rec_.zip_code);
   Message_SYS.Add_Attribute(msg_, 'DEL_CITY',             del_addr_rec_.city);
   Message_SYS.Add_Attribute(msg_, 'DEL_STATE',            del_addr_rec_.state);
   Message_SYS.Add_Attribute(msg_, 'DEL_COUNTY',           del_addr_rec_.county);
   Message_SYS.Add_Attribute(msg_, 'DEL_COUNTRY',          Iso_Country_API.Decode(del_addr_rec_.country));
   Message_SYS.Add_Attribute(msg_, 'DEL_EAN_LOCATION',     del_addr_rec_.ean_location);
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDR_NO',          doc_addr_);
   Message_SYS.Add_Attribute(msg_, 'DOC_NAME',             doc_addr_name_);
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDRESS1',         doc_addr_rec_.address1);
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDRESS2',         doc_addr_rec_.address2);
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDRESS3',         doc_addr_rec_.address3);
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDRESS4',         doc_addr_rec_.address4);
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDRESS5',         doc_addr_rec_.address5);
   Message_SYS.Add_Attribute(msg_, 'DOC_ADDRESS6',         doc_addr_rec_.address6);
   Message_SYS.Add_Attribute(msg_, 'DOC_ZIP_CODE',         doc_addr_rec_.zip_code);
   Message_SYS.Add_Attribute(msg_, 'DOC_CITY',             doc_addr_rec_.city);
   Message_SYS.Add_Attribute(msg_, 'DOC_STATE',            doc_addr_rec_.state);
   Message_SYS.Add_Attribute(msg_, 'DOC_COUNTY',           doc_addr_rec_.county);
   Message_SYS.Add_Attribute(msg_, 'DOC_COUNTRY',          Iso_Country_API.Decode(doc_addr_rec_.country));
   Message_SYS.Add_Attribute(msg_, 'DOC_EAN_LOCATION',     doc_addr_rec_.ean_location);
   Message_SYS.Add_Attribute(msg_, 'ACQUISITION_SITE',     contract_);
   Message_SYS.Add_Attribute(msg_, 'IS_INTERNAL_CUSTOMER', 'TRUE');
   RETURN msg_;
END Get_Packed_Customer_Data;


-- Fetch_Int_Supplier_Info
--   Fetches default values from delivery address connected to site.
PROCEDURE Fetch_Int_Supplier_Info (
   del_addr1_    OUT VARCHAR2,
   del_addr2_    OUT VARCHAR2,
   del_addr3_    OUT VARCHAR2,
   del_addr4_    OUT VARCHAR2,
   del_addr5_    OUT VARCHAR2,
   del_addr6_    OUT VARCHAR2,
   del_zip_code_ OUT VARCHAR2,
   del_city_     OUT VARCHAR2,
   del_state_    OUT VARCHAR2,
   del_county_   OUT VARCHAR2,
   del_country_  OUT VARCHAR2,
   contract_     IN  VARCHAR2 )
IS
   site_rec_ Public_Rec;
   addr_rec_ Company_Address_API.Public_Rec;
BEGIN
   site_rec_ := Get(contract_);
   addr_rec_ := Company_Address_API.Get(site_rec_.company, site_rec_.delivery_address);

   del_addr1_    := addr_rec_.address1;
   del_addr2_    := addr_rec_.address2;
   del_addr3_    := addr_rec_.address3;
   del_addr4_    := addr_rec_.address4;
   del_addr5_    := addr_rec_.address5;
   del_addr6_    := addr_rec_.address6;
   del_zip_code_ := addr_rec_.zip_code;
   del_city_     := addr_rec_.city;
   del_state_    := addr_rec_.state;
   del_county_   := addr_rec_.county;
   del_country_  := Iso_Country_API.Decode(addr_rec_.country);
END Fetch_Int_Supplier_Info;


-- Get_Currency_Converted_Amount
--   This function will convert the currency amount from one base currency
--   to another and returns the converted amount
FUNCTION Get_Currency_Converted_Amount (
   from_contract_             IN VARCHAR2,
   to_contract_               IN VARCHAR2,
   from_contract_curr_amount_ IN NUMBER ) RETURN NUMBER
IS
   to_contract_curr_amount_ NUMBER;
BEGIN
   -- The above General_SYS.Init is added instead of PRAGMA. Do not remove the Init

   Get_Currency_Converted___(to_contract_curr_amount_,
                             from_contract_,
                             to_contract_,
                             from_contract_curr_amount_,
                             TRUE);
   RETURN to_contract_curr_amount_;
END Get_Currency_Converted_Amount;


-- Get_Currency_Converted_Cost
--   This function will convert the cost amount from one
--   base currency to another and returns the converted cost
FUNCTION Get_Currency_Converted_Cost (
   from_contract_           IN VARCHAR2,
   to_contract_             IN VARCHAR2,
   from_contract_curr_cost_ IN NUMBER ) RETURN NUMBER
IS
   to_contract_curr_cost_ NUMBER;
BEGIN
   -- The above General_SYS.Init is added instead of PRAGMA. Do not remove the Init

   Get_Currency_Converted___(to_contract_curr_cost_,
                             from_contract_,
                             to_contract_,
                             from_contract_curr_cost_,
                             FALSE);
   RETURN to_contract_curr_cost_;
END Get_Currency_Converted_Cost;


@UncheckedAccess
FUNCTION Check_Exist (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(contract_) = TRUE) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


@UncheckedAccess
FUNCTION Get_Default_Language_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Company_API.Get_Default_Language_Db(Get_Company(contract_));
END Get_Default_Language_Db;



@UncheckedAccess
FUNCTION Get_Company_Address_Name (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   doc_addr_id_      VARCHAR2(50);
   company_name_     VARCHAR2(100);
   company_          SITE_TAB.company%TYPE;
   addr_name_        VARCHAR2(100);
BEGIN
   $IF Component_Discom_SYS.INSTALLED $THEN
      doc_addr_id_ := Site_Discom_Info_API.Get_Document_Address_Id(contract_, 'TRUE');
   $END
   company_ := Get_Company(contract_);
   $IF Component_Invent_SYS.INSTALLED $THEN
      addr_name_ := Company_Address_Deliv_Info_API.Get_Address_Name(company_, doc_addr_id_);
   $END
   company_name_ := NVL(addr_name_, Company_API.Get_Name(company_));
   RETURN company_name_;
END Get_Company_Address_Name;

@UncheckedAccess   
FUNCTION Is_Company_Site_Available (
	company_ IN VARCHAR2,
   site_    IN VARCHAR2) RETURN VARCHAR2
IS
   CURSOR get_company_sites IS
      SELECT 1 FROM site_tab 
      WHERE company=company_ AND contract=site_;

   dummy_ NUMBER;
   
BEGIN
	OPEN get_company_sites;
   FETCH get_company_sites INTO dummy_;
   IF get_company_sites%NOTFOUND THEN
      CLOSE get_company_sites;
      RETURN 'FALSE';
   ELSE
      CLOSE get_company_sites;
      RETURN 'TRUE';
   END IF;
END Is_Company_Site_Available;


FUNCTION Get_Connected_Menu_Id (
   contract_    IN VARCHAR2) RETURN VARCHAR2
IS
   menu_id_ VARCHAR2(50) := NULL;
   company_ VARCHAR2(20);
BEGIN
   menu_id_ := Get_Data_Capture_Menu_Id(contract_);
   IF menu_id_ IS NULL THEN 
      company_ := Get_Company(contract_);
      menu_id_ := Company_Distribution_Info_API.Get_Data_Capture_Menu_Id(company_);
   END IF ;
   RETURN menu_id_;
END Get_Connected_Menu_Id;

