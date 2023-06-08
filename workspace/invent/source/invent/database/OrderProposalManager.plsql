-----------------------------------------------------------------------------
--
--  Logical unit: OrderProposalManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180612  ChJalk  Bug 142212, Modified Create_Order_Proposal__ to remove the error message ORDCORDINATORREQ.
--  170425  AwWelk  STRSC-7322, Modified Create_Order_Proposal__() by adding error message by checking wheather authorize_code have a value when part
--  170425          default supply type is Order.
--  160712  SudJlk  STRSC-1959, Modified Validate_Params to handle data validity of coordinator.
--  151020  Chfose  LIM-3893, Removed pallet location types in call to Inventory_Part_In_Stock_API.Get_Avail_Plan_Qty_Loc_Type.
--  150623  MatKse  Modified Create_Order_Proposal__ to filter on Supplier ID and Route ID. Modified Validate_Params to validate Supplier ID and Route ID.
--  150728  ShKolk  Bug 123092, Modified Create_Order_Proposal__() to set COPIES option to support StreamServe reports.
--  141124  DaZase  PRSC-4337, Replaced call to Company_Address_Deliv_Info_API.Get_Address_Name with Site_API.Get_Company_Address_Name in Create_Order_Proposal__.
--  140716  TiRalk  Bug 117850, Modified report method to print company name properly.
--  140225  TiRalk  Bug 112795, Modified Create_Order_Proposal__ to reset the Purchase order no if error occurs when creating bulk POs  
--  140225          from Order proposal and the order_coordinator_group_tab should be released without locking.
--  140210  AwWelk  PBSC-5837, Modified Create_Order_Proposal__() to use Archive_API.Init_Archive_item to insert an archive item before the
--  140210          update of archive record. This was done because of the framework change made on Archive_API.Attach_Report. 
--  130801  ChJalk  TIBE-898, Removed the global variables.
--  130530  PraWlk  Bug 110337, Modified Create_Order_Proposal__() to fetch the session language and passed it when calling
--  130530          Archive_API.Attach_Report() and Print_Job_Contents_API.New_Instance().
--  111221  PraWlk  Removed order_date_ variable from Create_Order_Proposal__().
--  110916  Darklk  Bug 98988, Modified Create_Order_Proposal to avoid creating another background job when it's invoked from a schedule job.
--  110701  MaRalk  Replaced hardcoded value 'InvOrderReportPrintRep.xsl' by the method call 
--  110701          Report_Layout_Definition_API.Get_Default_Layout in Create_Order_Proposal__ method.   
--  100505  KRPELK  Merge Rose Method Documentation.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  090930  ChFolk  Removed unused variables in the package.
--  ----------------------------------- 14.0.0 ---------------------------------
--  090828  HoInlk  Bug 83043, Moved do_xml block in Create_Order_Proposal__ to be executed only when necessary.
--  090810  HoInlk  Bug 83043, Modified Create_Order_Proposal__ to enable event
--  090810          Order_Prop_Error_Occurred when an error is raised.
--  090522  PraWlk  Bug 81853, Modified PROCEDURE Validate_Params to validate AUTHORIZE_CODE and PLANNER_BUYER for '%'.
--  090226  PraWlk  Bug 77435, Modified PROCEDURE Validate_Params to validate AUTHORIZE_CODE and PLANNER_BUYER. 
--  080422  NiBalk  Bug 72596, Renamed method Create_Order_Proposal to Create_Order_Proposal__ and
--  080422          added new method Create_Order_Proposal to make a deffered call to Create_Order_Proposal__.
--  070906  KaDilk  Modified Create_Order_Proposal to avoid Oracle error when priting the report after having a warning message.
--  070703  RaKalk  Modified Create_Order_Proposal to support report designer layouts.
--  070424  IsAnlk  Modifed f1.note_id to get document texts from Part Catalog when centralized description is used. 
--  070807  NaWilk  Removed field ip.description from cursor get_parts.
--  060720  RoJalk  Centralized Part Desc - Use Inventory_Part_API.Get_Description.
--  060306  JOHESE  Added call to Client_Sys.Get_All_Info at the end of Create_Order_Proposal to suppress info messages
--  060127  MAJOse  Make/Buy Split. A part can be both manufactured and purhased at the sime time
--                  Need to delete requsitions without any lead_time_code checks.
--  060124  NiDalk  Added Assert safe annotation. 
--  060113  JOHESE  Added deletion of previously created distribution orders in Create_Order_Proposal
--  060103  JOHESE  Modified exception handling in Create_Order_Proposal to raise hard errors when run online
--  051003   KeFelk  Added Site_Invent_Info_API in relavant places where Site_API is used.
--  050921  NiDalk  Removed unused variables.
--  050328  IsWilk  Added PROCEDURE Validate_Params to validate the parameters 
--  050328          when running the Schedule Create Order Proposal
--  050217  Hapulk  Added new method Create_Order_Proposal.
--  050216  Hapulk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Order_Proposal__
--   This method holds the logic need to CreateOrderProposal.
PROCEDURE Create_Order_Proposal__ (
   attrib_ IN VARCHAR2 )
IS
   user_                      VARCHAR2(30);
   report_attr_               VARCHAR2(2000) := NULL;
   parameter_attr_            VARCHAR2(2000) := NULL;
   print_attr_                VARCHAR2(2000) := NULL;
   distribution_list_         VARCHAR2(2000) := NULL;
   attr_                      VARCHAR2(2000);
   stmt_                      VARCHAR2(2000);
   report_line_attr_          VARCHAR2(10000);
   rows_fetched_              NUMBER;
   qty_onhand_                NUMBER;
   disp_qty_onhand_           NUMBER;
   lu_req_exists_             BOOLEAN;
   lu_shp_exists_             BOOLEAN;
   contract_                  VARCHAR2(5);
   part_no_                   VARCHAR2(25);
   second_commodity_          VARCHAR2(5);
   planner_buyer_             VARCHAR2(20);
   result_key_                NUMBER;
   report_id_                 VARCHAR2(30) := 'INV_PART_ORDER_PNT_REP_REP';
   print_job_id_              NUMBER;
   create_req_                VARCHAR2(1);
   delete_req_                VARCHAR2(1);
   create_req_n_              NUMBER;
   note_id_                   NUMBER;
   note_id_purch_             NUMBER;
   qty_supply_                NUMBER;
   qty_demand_                NUMBER;
   qty_ordered_               NUMBER;
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   authorize_code_            VARCHAR2(20);
   recalc_data_               VARCHAR2(20);
   periods_                   NUMBER;
   all_parts_db_              VARCHAR2(20);
   process_pur_               VARCHAR2(20);
   process_shp_               VARCHAR2(20);
   work_days_                 NUMBER;
   average_period_            NUMBER;
   leadtime_                  NUMBER;
   went_ok_                   VARCHAR2(1);
   rows_changed_              NUMBER;
   date_required_             DATE;
   requisition_no_            VARCHAR2(12);
   error_message_             VARCHAR2(2000);
   info_                      VARCHAR2(2000);
   manuf_median_period_       NUMBER;
   purch_median_period_       NUMBER;
   periods_per_year_          NUMBER;
   dummy_                     VARCHAR2(100);
   multi_site_planned_        VARCHAR2(50);

   company_                   VARCHAR2(20);
   logotype_                  VARCHAR2(100);
   company_name_              VARCHAR2(100);

   prev_contract_             VARCHAR2(5);
   prev_second_comm_          VARCHAR2(5);
   prev_planner_buyer_        VARCHAR2(20);
   prev_lead_time_code_       VARCHAR2(1);
   create_new_header_         VARCHAR2(5)    := 'N';
   close_old_header_          VARCHAR2(5)    := 'N';
   str_null_                  VARCHAR2(10)   := 'NULLVALUE';
   first_row_                 BOOLEAN        := TRUE;
   do_xml_                    BOOLEAN := Report_SYS.Should_Generate_Xml('INV_PART_ORDER_PNT_REP_REP');   
   xml_                       CLOB;
   lang_code_                 VARCHAR2(2);
   vendor_no_                 VARCHAR2(20);
   route_id_                  VARCHAR2(12);
   
   -----------------------------------------
   -- IID VALUES USED BY CURSOR GET_PARTS --
   -----------------------------------------
   iid_yes_no_0_              VARCHAR2(20) := 'Y';
   authorize_group_           VARCHAR2(1);
   current_purchase_order_no_ NUMBER;   

   CURSOR get_parts IS
      SELECT ip.contract, ip.part_no, ip.planner_buyer, ip.second_commodity,
             ip.purch_leadtime, ip.type_code, ip.unit_meas,
             ip.note_id, ip.lead_time_code, ip.manuf_leadtime, ipp.planning_method,
             ipp.safety_stock, ipp.order_point_qty, ipp.lot_size,
             ipp.qty_predicted_consumption, ipp.order_requisition
      FROM  inventory_part_status_par_tab ipsp, inventory_part_planning_tab ipp, inventory_part_tab ip
      WHERE ipp.planning_method IN ('B','C')
      AND   ipp.contract = ip.contract
      AND   ipp.part_no  = ip.part_no
      AND   ((process_pur_ = iid_Yes_No_0_ AND
              ip.lead_time_code = 'P') OR
             (process_shp_ = iid_Yes_No_0_ AND
              ip.lead_time_code = 'M'))
      AND   ipsp.supply_flag = 'Y'
      AND   ip.part_status = ipsp.part_status
      AND   ip.stock_management = 'SYSTEM MANAGED INVENTORY'
      AND   NVL(ip.avail_activity_status,'%') LIKE decode(
               all_parts_db_,
               'Y',
               'CHANGED','%')
      AND   ip.planner_buyer LIKE planner_buyer_
      AND   NVL(ip.second_commodity, '%') LIKE second_commodity_
      AND   ip.contract = contract_
      AND   ip.part_no LIKE part_no_
      ORDER BY ip.contract, ip.planner_buyer, ip.second_commodity,ip.lead_time_code;
BEGIN
   ptr_      := NULL;
   Client_SYS.Add_To_Attr('REPORT_ID', 'INV_PART_ORDER_PNT_REP_REP', report_attr_);
   Report_Definition_API.Get_Result_Key(result_key_);
   contract_ := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   user_     := Fnd_Session_API.Get_Fnd_User;
   --
   -- Unpack attribute string
   --
   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
      Trace_SYS.Message('Name: '||name_||' - '||value_);
      IF (name_ = 'BATCH_USER') THEN
         user_ := value_;
      ELSIF (name_ = 'CONTRACT') THEN
         contract_ := value_;
         Client_SYS.Add_To_Attr('Q_CONTRACT',value_, parameter_attr_);
      ELSIF (name_ = 'PART_NO') THEN
         part_no_ := value_;
         Client_SYS.Add_To_Attr('Q_PART_NO',value_, parameter_attr_);
      ELSIF (name_ = 'SECOND_COMMODITY') THEN
         second_commodity_:= value_;
         Client_SYS.Add_To_Attr('Q_SECOND_COMMODITY',value_, parameter_attr_);
      ELSIF (name_ = 'PLANNER_BUYER') THEN
         planner_buyer_ := value_;
         Client_SYS.Add_To_Attr('Q_PLANNER_BUYER',value_, parameter_attr_);
      ELSIF (name_ = 'CREATE_REQ') THEN
         IF (value_ = 'TRUE') THEN
            create_req_ := 'Y';
         ELSIF (value_ = 'FALSE') THEN
            create_req_ := 'N';
         END IF;
         IF value_ IS NOT NULL THEN
            Client_SYS.Add_To_Attr('Q_CREATE_REQ', Gen_Yes_No_API.Decode(create_req_), parameter_attr_);
         END IF;
      ELSIF (name_ = 'DELETE_REQ') THEN
         IF (value_ = 'TRUE') THEN
            delete_req_ := 'Y';
         ELSIF (value_ = 'FALSE') THEN
            delete_req_ := 'N';
         END IF;
         IF value_ IS NOT NULL THEN
            Client_SYS.Add_To_Attr('Q_DELETE_REQ', Gen_Yes_No_API.Decode(delete_req_), parameter_attr_);
         END IF;
      ELSIF (name_ = 'AUTHORIZE_CODE') THEN
         authorize_code_ := value_;
         IF value_ IS NOT NULL THEN
           Client_SYS.Add_To_Attr('Q_AUTHORIZE_CODE', authorize_code_, parameter_attr_);
         END IF;
      ELSIF (name_ = 'VENDOR_NO') THEN
         vendor_no_ := value_;
         Client_SYS.Add_To_Attr('Q_VENDOR_NO', vendor_no_, parameter_attr_);
      ELSIF (name_ = 'ROUTE_ID') THEN
         route_id_ := value_;
         Client_SYS.Add_To_Attr('Q_ROUTE_ID', route_id_, parameter_attr_);
      ELSIF (name_ = 'RECALC_DATA') THEN
         IF (value_ = 'TRUE') THEN
            recalc_data_ := 'Y';
         ELSIF (value_ = 'FALSE') THEN
            recalc_data_ := 'N';
         END IF;
         IF value_ IS NOT NULL THEN
           Client_SYS.Add_To_Attr('Q_RECALC_DATA',Gen_Yes_No_API.Decode(recalc_data_), parameter_attr_);
           Trace_SYS.Message('recalc'||value_);
         END IF;
      ELSIF (name_ = 'PERIODS') THEN
         periods_ := value_;
         Client_SYS.Add_To_Attr('Q_PERIODS',value_, parameter_attr_);
      ELSIF (name_ = 'ALL_PARTS') THEN
         IF (value_ = 'TRUE') THEN
            all_parts_db_ := 'Y';
         ELSIF (value_ = 'FALSE') THEN
            all_parts_db_ := 'N';
         END IF;
         IF value_ IS NOT NULL THEN
            Client_SYS.Add_To_Attr('Q_ALL_PARTS',Gen_Yes_No_API.Decode(all_parts_db_), parameter_attr_);
         END IF;
      ELSIF (name_ = 'PROCESS_PUR') THEN
         IF (value_ = 'TRUE') THEN
            process_pur_ := 'Y';
         ELSIF (value_ = 'FALSE') THEN
            process_pur_ := 'N';
         END IF;
         IF value_ IS NOT NULL THEN
           Client_SYS.Add_To_Attr('Q_PROCESS_PUR',Gen_Yes_No_API.Decode(process_pur_), parameter_attr_);
         END IF;
      ELSIF (name_ = 'PROCESS_SHP') THEN
         IF (value_ = 'TRUE') THEN
            process_shp_ := 'Y';
         ELSIF (value_ = 'FALSE') THEN
            process_shp_ := 'N';
         END IF;
         IF value_ IS NOT NULL THEN
           Client_SYS.Add_To_Attr('Q_PROCESS_SHP',Gen_Yes_No_API.Decode(process_shp_), parameter_attr_);
         END IF;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   part_no_          := NVL(part_no_, '%');
   second_commodity_ := NVL(second_commodity_, '%');
   planner_buyer_    := NVL(planner_buyer_, '%');

   -----------------------------------------------------------------------
   -- Initiate phase, get data needed in loop
   -----------------------------------------------------------------------

   Trace_Sys.Message('ORDER_PROPOSAL_MANAGER_API.'||'Make_Order_Point_Res. '||
      ' Contract: '||contract_||
      ' Part_no: '||part_no_||
      ' Sec_Com: '||second_commodity_||
      ' Planner: '||planner_buyer_||
      ' Create: '||create_req_||
      ' Delete: '||delete_req_||' Result Key: '||to_char(result_key_));
   --
   -- Check LU:s installed
   --
   $IF Component_Purch_SYS.INSTALLED $THEN   
      lu_req_exists_ := TRUE;
   $ELSE
      lu_req_exists_ := FALSE;
   $END
   --
   $IF Component_Shpord_SYS.INSTALLED $THEN
      lu_shp_exists_ := TRUE;
   $ELSE
      lu_shp_exists_ := FALSE;
   $END
   --
   -- Retrieve the number of workdays in a week.
   --
   work_days_ := Site_Invent_Info_API.Get_Avg_Work_Days_Per_Week(contract_);
   --
   -- Retrieve the average number of days in a period.
   --
   average_period_ := Statistic_Period_API.Get_Average_Period;

   ------------------------------------------------------------------------
   --
   -- Main loop, process each part
   --
   ------------------------------------------------------------------------

   rows_fetched_     := 0;

   periods_per_year_ := Statistic_Period_API.Get_Periods_Per_Year;

   IF (recalc_data_ = iid_yes_no_0_) THEN
      Statistic_Period_API.Get_Median_Period(manuf_median_period_, average_period_, work_days_, 'M');
      Statistic_Period_API.Get_Median_Period(purch_median_period_, average_period_, work_days_, 'P');
   END IF;

   IF (do_xml_) THEN
      Xml_Record_Writer_SYS.Create_Report_Header(xml_,'INV_PART_ORDER_PNT_REP_REP','INV_PART_ORDER_PNT_REP_REP');
      Xml_Record_Writer_SYS.Start_Element(xml_, 'ORDER_POINT_HEADERS');
   END IF;

   authorize_group_ := Order_Coordinator_API.Get_Authorize_Group(authorize_code_);
   
   FOR f1 IN get_parts LOOP
      
      $IF Component_Purch_SYS.INSTALLED $THEN
         IF NOT (Purchase_Part_Supplier_API.Include_In_Order_Proposal(f1.contract, f1.part_no, vendor_no_, route_id_)) THEN
            CONTINUE;
         END IF;         
      $END
      
      --
      -- The process for one part is built in a anonymous block
      -- to be able to continue if error occur for one part.
      -- The error is logged in F1 - Background processes.
      --
      BEGIN
         went_ok_ := 'Y';
         --
         rows_fetched_ := rows_fetched_ + 1;
         --
         Trace_Sys.Message('ORDER_PROPOSAL_MANAGER_API.'||' LOOP: '||
            ' Row_no: '||to_char(rows_fetched_)||
            ' Contract: '||f1.contract||
            ' Part_no:  '||f1.part_no);
         --
         -- Modify stock factors in InventoryPartPlanning.
         --
         IF (recalc_data_ = iid_yes_no_0_) THEN
            Inventory_Part_Planning_API.Modify_Stockfactors(
               rows_changed_        => rows_changed_,
               contract_            => f1.contract,
               part_no_             => f1.part_no,
               second_commodity_    => f1.second_commodity,
               periods_             => periods_,
               work_days_           => work_days_,
               manuf_median_period_ => manuf_median_period_,
               purch_median_period_ => purch_median_period_,
               periods_per_year_    => periods_per_year_,
               lead_time_code_db_   => f1.lead_time_code,
               manuf_leadtime_      => f1.manuf_leadtime,
               purch_leadtime_      => f1.purch_leadtime);
         END IF;
         
         IF delete_req_ = 'Y' AND lu_req_exists_ THEN               
            IF f1.order_requisition != 'O' THEN 
               
               -- Delete purchase requisitions for this part_no, contract.
               stmt_ := 'BEGIN Purchase_Req_Util_API.Remove_Line_Part(
                            :contract,
                            :part_no);
                         END;';
               @ApproveDynamicStatement(2006-01-24,nidalk)
               EXECUTE IMMEDIATE stmt_
                  USING IN f1.contract,
                        IN f1.part_no;
                     
            ELSE
               $IF Component_Disord_SYS.INSTALLED $THEN 
                  DECLARE
                     primary_supplier_ VARCHAR2(100);
                  BEGIN
                     primary_supplier_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(f1.contract, f1.part_no);                           
                     multi_site_planned_ := Purchase_Part_Supplier_API.Get_Multisite_Planned_Part_Db(f1.contract, f1.part_no, primary_supplier_);
                  END;                                         

                  IF nvl(multi_site_planned_, 'null') = 'MULTISITE_PLAN' THEN 
                     -- Delete distribution orders for this part_no, contract.
                     Distribution_Order_Util_API.Delete_Unreleased_Dos(dummy_, f1.contract, Mpccom_Defaults_API.Get_Char_Value ('ORDPNT', 'REQUISITION_HEADER', 'REQUISITIONER_CODE'), f1.part_no);                               
                  END IF;
               $ELSE
                  NULL;
               $END               
            END IF;
         END IF;

         -- Delete shop order proposals for this part_no, contract
         IF delete_req_ = 'Y' AND lu_shp_exists_ THEN
            stmt_ := 'BEGIN Shop_Order_Prop_API.Remove_Proposal(
                         :part_no,
                         :contract,
                         NULL,
                         Shop_Proposal_Type_API.Decode(''INV''));
                      END;';
            @ApproveDynamicStatement(2006-01-24,nidalk)
            EXECUTE IMMEDIATE stmt_
               USING IN f1.part_no,
                     IN f1.contract;
         END IF;
         --
         -- Get qty_onhand from InventoryPartLocation
         --

         -- Order proposal should only work for non configured parts
         qty_onhand_ := Inventory_Part_In_Stock_API.Get_Avail_Plan_Qty_Loc_Type(contract_          => f1.contract,
                                                                                part_no_           => f1.part_no,
                                                                                configuration_id_  => '*',
                                                                                activity_seq_      => 0,
                                                                                qty_type_          => 'ONHAND',
                                                                                date_requested_    => NULL,
                                                                                location_type1_db_ => 'PICKING',
                                                                                location_type2_db_ => 'F',
                                                                                location_type3_db_ => 'SHIPMENT',
                                                                                location_type4_db_ => 'MANUFACTURING');

         disp_qty_onhand_ := qty_onhand_;

         Trace_SYS.Message('disp_qty_onhand_ = '||to_char(disp_qty_onhand_));
         --
         -- Get qty_supply and qty_demand from OrderSupplyDemand.
         --
         qty_supply_ := Order_Supply_Demand_API.Get_Sum_Qty_Supply(f1.contract, f1.part_no, '*');
         qty_demand_ := Order_Supply_Demand_API.Get_Sum_Qty_Demand(f1.contract, f1.part_no, '*');

         Trace_SYS.Message('qty_supply_ = '||to_char(qty_supply_));
         Trace_SYS.Message('qty_demand_ = '||to_char(qty_demand_));
         --
         -- Leadtime is purchased or manufactured
         --
         IF (f1.lead_time_code = 'P') THEN
            leadtime_ := f1.purch_leadtime;
         ELSE
            leadtime_ := f1.manuf_leadtime;
         END IF;
         --
         -- Translate create_req_ to numeric variable to be used as parameter
         -- to procedure.
         --
         IF (create_req_ = 'Y') THEN
            create_req_n_ := 1;
         ELSE
            create_req_n_ := 0;
         END IF;

         current_purchase_order_no_ := Order_Coordinator_Group_API.Get_Purch_Order_No(authorize_group_);
                          
         Order_Supply_Demand_API.Get_Order_Supply_Demands (
            report_line_attr_,
            requisition_no_,
            disp_qty_onhand_ ,
            qty_ordered_     ,
            went_ok_,
            date_required_   ,
            leadtime_        ,
            f1.safety_stock    ,
            f1.order_point_qty ,
            f1.type_code     ,
            lu_req_exists_   ,
            lu_shp_exists_   ,
            create_req_n_    ,
            f1.part_no       ,
            f1.contract      ,
            '*'              ,
            user_,
            authorize_code_);

         IF went_ok_ = 'Y' THEN
            -- Fetch Purchase Note_ID .
            note_id_purch_ := NULL;
            IF (Site_Invent_Info_API.Get_Use_Partca_Desc_Invent_Db(f1.contract) = 'TRUE') THEN
               f1.note_id := Part_Catalog_Language_API.Get_Note_Id(f1.part_no, Language_SYS.Get_Language);
            ELSE               
               $IF Component_Purch_SYS.INSTALLED $THEN
                  IF f1.lead_time_code = 'P' THEN
                     note_id_purch_ := Purchase_Part_API.Get_Note_Id(f1.part_no, f1.contract);                  
                  END IF;
               $ELSE
                  NULL;
               $END               
            END IF;

            -- Notes
            note_id_       := f1.note_id;
            note_id_purch_ := NVL(note_id_purch_,f1.note_id);

            IF (first_row_) OR
               (f1.contract          != prev_contract_) OR
               (f1.planner_buyer     != prev_planner_buyer_) OR
               (f1.lead_time_code    != prev_lead_time_code_) OR
               (NVL(f1.second_commodity,str_null_)  != NVL(prev_second_comm_,str_null_))THEN
      
               create_new_header_   := 'Y';
      
               prev_contract_       := f1.contract;
               prev_planner_buyer_  := f1.planner_buyer;
               prev_lead_time_code_ := f1.lead_time_code;
               prev_second_comm_    := f1.second_commodity;
            ELSE
               create_new_header_ := 'N';
            END IF;

            Trace_SYS.Field('create_new_header_',create_new_header_);
            Trace_SYS.Field('close_old_header_',close_old_header_);

            stmt_ := 'BEGIN Inv_Part_Order_Pnt_Rep_RPI.Create_Report_Line (
                         :report_line_attr,
                         :result_key,
                         :rows_fetched,
                         :xml,
                         :contract,
                         :part_no,
                         :description,
                         :unit_meas,
                         :purch_leadtime,
                         :planner_buyer,
                         :second_commodity,
                         :planning_method,
                         :safety_stock,
                         :order_point_qty,
                         :lot_size,
                         :qty_predicted_consumption,
                         :qty_supply,
                         :qty_demand,
                         :note_id,
                         :note_id_purch,
                         :create_new_header,
                         :close_old_header);
                      END;';
            @ApproveDynamicStatement(2006-01-24,nidalk)
            EXECUTE IMMEDIATE stmt_
               USING IN     report_line_attr_,
                     IN     result_key_,
                     IN OUT rows_fetched_,
                     IN OUT xml_, 
                     IN     f1.contract,
                     IN     f1.part_no,
                     IN     Inventory_Part_API.Get_Description(f1.contract, f1.part_no),
                     IN     f1.unit_meas,
                     IN     f1.purch_leadtime,
                     IN     f1.planner_buyer,
                     IN     f1.second_commodity,
                     IN     f1.planning_method,
                     IN     f1.safety_stock,
                     IN     f1.order_point_qty,
                     IN     f1.lot_size,
                     IN     f1.qty_predicted_consumption,
                     IN     qty_supply_,
                     IN     qty_demand_,
                     IN     note_id_,
                     IN     note_id_purch_,
                     IN     create_new_header_,
                     IN     close_old_header_;
            
            close_old_header_ := 'Y';
            first_row_        := FALSE;
         --
         -- Clear avail_activity_status flag on InventoryPart.
         --
            Inventory_Part_API.Clear_Avail_Activity_Status(f1.contract,
                                                           f1.part_no);
         END IF;
         --
         --
         @ApproveTransactionStatement(2012-01-25,GanNLK)
         COMMIT;

         current_purchase_order_no_ := NULL;
      EXCEPTION
         WHEN OTHERS THEN
            IF current_purchase_order_no_ IS NOT NULL THEN
               Order_Coordinator_Group_API.Reset_Purch_Ord_No_Autonomous(authorize_group_, current_purchase_order_no_);
            END IF;
            IF Transaction_SYS.Is_Session_Deferred() THEN
               error_message_ := SQLERRM;
               @ApproveTransactionStatement(2012-01-25,GanNLK)
               ROLLBACK;
               info_ := Language_SYS.Translate_Constant(lu_name_, 'PARTERR: A supply could not be created for part number: :P1 on site: :P2 due to the following error: :P3',
                                                        NULL, f1.part_no, f1.contract, error_message_);
               --
               -- Logg the error in F1
               --
               Transaction_SYS.Log_Status_Info(info_);
               Trace_Sys.Message(info_);
               Invent_Event_Creation_API.Order_Prop_Error_Occurred(contract_, info_);
               @ApproveTransactionStatement(2012-01-25,GanNLK)
               COMMIT;
            ELSE
               IF (do_xml_) THEN
                  IF close_old_header_ = 'Y' THEN
                     Xml_Record_Writer_SYS.End_Element(xml_, 'ORDER_POINT_DETAILS');
                     Xml_Record_Writer_SYS.End_Element(xml_, 'ORDER_POINT_HEADER');
                  END IF;
                  Xml_Record_Writer_SYS.End_Element(xml_, 'ORDER_POINT_HEADERS');
                  Xml_Record_Writer_SYS.End_Element(xml_,'INV_PART_ORDER_PNT_REP_REP');
                  Report_SYS.Finish_Xml_Report('INV_PART_ORDER_PNT_REP_REP',result_key_,xml_);
               END IF;
               RAISE;
            END IF;
      END;
   END LOOP;

   IF (do_xml_) THEN
      IF close_old_header_ = 'Y' THEN
         Xml_Record_Writer_SYS.End_Element(xml_, 'ORDER_POINT_DETAILS');
         Xml_Record_Writer_SYS.End_Element(xml_, 'ORDER_POINT_HEADER');
      END IF;
      Xml_Record_Writer_SYS.End_Element(xml_, 'ORDER_POINT_HEADERS');
      Xml_Record_Writer_SYS.End_Element(xml_,'INV_PART_ORDER_PNT_REP_REP');
      Report_SYS.Finish_Xml_Report('INV_PART_ORDER_PNT_REP_REP',result_key_,xml_);
   END IF;
   --
   -- Create new print job
   --
   Client_SYS.Clear_Attr(print_attr_);
   Client_SYS.Add_To_Attr('PRINTER_ID', Printer_Connection_API.Get_Default_Printer(
   Fnd_Session_API.Get_Fnd_User, report_id_), print_attr_);
   Client_SYS.Add_To_Attr('EXPIRE_DATE', Site_API.Get_Site_Date(contract_)+30, print_attr_);
   Print_Job_API.New(print_job_id_, print_attr_);
   lang_code_ := Fnd_Session_API.Get_Language;
   --
   -- Put the report in the archive
   --
   Client_SYS.Add_To_Attr('REPORT_ID', report_id_, report_attr_);
   Client_SYS.Add_To_Attr('LANG_CODE', lang_code_, report_attr_);
   --
   -- Add the report to the archive
   --
   Archive_API.Init_Archive_item(result_key_, report_id_, SYSDATE, Fnd_Session_API.Get_Fnd_User);
   Archive_API.Attach_Report(result_key_,
                             report_attr_,
                             parameter_attr_,
                             distribution_list_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, attr_);
   Client_SYS.Add_To_Attr('RESULT_KEY',   result_key_,   attr_);
   Client_SYS.Add_To_Attr('LAYOUT_NAME',  Report_Layout_Definition_API.Get_Default_Layout(report_id_), attr_);
   Client_SYS.Add_To_Attr('LANG_CODE',    lang_code_,    attr_); 
   Client_SYS.Add_To_Attr('OPTIONS',      'COPIES(1)',   attr_);

   --
   -- Add the report instance to print job
   --
   Print_Job_Contents_API.New_Instance(attr_);

   Print_Job_API.Print(print_job_id_);

   company_      := Site_API.Get_Company(contract_);
   logotype_     := Company_API.Get_Logotype(company_);
   company_name_ := Site_API.Get_Company_Address_Name(contract_);

   IF (logotype_ IS NOT NULL ) THEN
      Archive_Variable_API.Set_Object(result_key_, 'rhSysLogo', logotype_);
      Archive_Variable_API.Set_Variable(result_key_, 'companyName', company_name_);
   END IF;

   info_ := Client_Sys.Get_All_Info();
   
   Trace_Sys.Message('ORDER_PROPOSAL_MANAGER_API.'||'Create_Order_Proposal ended. ');
END Create_Order_Proposal__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Order_Proposal
--   This method holds the logic need to CreateOrderProposal.
PROCEDURE Create_Order_Proposal (
   attrib_ IN VARCHAR2 )
IS
   batch_desc_ VARCHAR2(100);
BEGIN
   IF (Transaction_SYS.Is_Session_Deferred()) THEN
      Create_Order_Proposal__(attrib_);
   ELSE
      batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'BDESCCCR: Create Order Proposal');
      Transaction_SYS.Deferred_Call('Order_Proposal_Manager_API.Create_Order_Proposal__',attrib_,batch_desc_);
   END IF;      
END Create_Order_Proposal;


-- Validate_Params
--   Validates the parameters when running the Schedule for Create Order Proposal.
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_            NUMBER;
   name_arr_         Message_SYS.name_table;
   value_arr_        Message_SYS.line_table;
   contract_         VARCHAR2(5);
   authorize_code_   VARCHAR2(20);
   planner_buyer_    VARCHAR2(20);
   vendor_no_        VARCHAR2(20);
   route_id_         VARCHAR2(12);
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'AUTHORIZE_CODE') THEN
         authorize_code_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PLANNER_BUYER') THEN
         planner_buyer_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'VENDOR_NO') THEN
         vendor_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ROUTE_ID') THEN
         route_id_ := value_arr_(n_);
      END IF;
   END LOOP;

   IF (contract_ IS NOT NULL) THEN
      Site_API.Exist(contract_);
   END IF;

   IF (contract_ IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;

   IF (authorize_code_ IS NOT NULL) AND (authorize_code_ != '%') THEN
      Order_Coordinator_API.Exist(authorize_code_, true);
   END IF;

   IF (planner_buyer_ IS NOT NULL) AND (planner_buyer_ != '%') THEN
      Inventory_Part_Planner_API.Exist(planner_buyer_, true);
   END IF;
   
   $IF Component_Purch_SYS.INSTALLED $THEN     
      IF (vendor_no_ IS NOT NULL) AND (vendor_no_ != '%') THEN
         Supplier_API.Exist(vendor_no_);
      END IF;

      IF (route_id_ IS NOT NULL) AND (route_id_ != '%') THEN
         Delivery_Route_API.Exist(route_id_);
      END IF;   
   $END
   
END Validate_Params;



