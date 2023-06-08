-----------------------------------------------------------------------------
--
--  Logical unit: OrderConfigUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200120  UtSwlk  Bug 151751, Modified Replace_Quotation_Line() to allow replace when line in Released state.
--  190304  NiDalk  Bug 147214, Modified Check_Ord_Line_Config_Mismatch to correct a buffer overflow issue.
--  171011  RoJalk  STRSC-11648, Added methods Replace_Order_Line and Replace_Quotation_Line.
--  170615  TiRalk  LIM-8588, STRSC-9106, Modified Check_Ord_Line_Config_Mismatch to check the correct value of Part_Catalog_API.Get_Configurable_Db and
--  170615          to check the mismatch configuration for project deliverables flows as well.
--  170206  MaIklk  STRSC-4517, Moved function call in Order_Config_Exist_For_Part() from cursor to body for order and quotation. Kept function call for CRM as it is, since it uses different parameters.
--  170202  SBalLK  Bug 132653, Modified Check_Ord_Line_Config_Mismatch() method to validate Supply/Demand order part having configuration enabled before validate configuration mismatches.
--  170113  SeJalk  Bug 133539, Modified Order_Config_Exist_For_Part() by adding condition to check CRM installed prior to use CRM objects.
--  160929  SWeelk  Bug 130897, Modified Order_Config_Exist_For_Part() by adding catalog_no with a NVL for CO and SQ in the cursor.
--  160929  SWeelk  Bug 131111, Modified Order_Config_Exist_For_Cust() by removing customer_no from WHERE and changing CONFNOTEXISTFORCUST message to CONFNOTVALIDFORPART.
--  160929          Renamed Order_Config_Exist_For_Cust as Order_Config_Exist_For_Part and removed customer_no_ from the parameterlist.
--  150922  NiNilk  Bug 124401, Modified Check_Cust_Ord_Config_Mismatch() to ignore cancelled order lines from configuration mismatch check.  
--  150901  VISALK  STRMF-124, Changed the DOP_ID data type into VARCHAR2(12).
--  141226  Ospalk  PRMF-1288, Modified Check_Ord_Line_Config_Mismatch method. Add a dynamic call to Purchase_Order_Line_Part_API.Get_Demand_Code method.
--  141219  Ospalk  PRMF-1288, Modified Check_Ord_Line_Config_Mismatch method. Write get_dop_info cursor to get dop id and dop order id from Dop_Supply_Purch_Ord_tab. Check if the 
--                             demand code is DOP and then get the configuration ID of demand side from Dop_Order_Tab and check it is equal with supply configuration ID.
--  141217  RuLiLk  PRSC-4694, Modified method Check_Configuration_Exist() by adding condition compilation.
--  141217          Removed the NVL check as configuration_id_ is a not null column in customer order line and return material line table.
--  141210  RuLiLk  PRSC-2695, Added new method Check_Configuration_Exist to validate configuration_id against part and order line.
--  140919  NaLrlk  Modified Check_Cust_Ord_Config_Mismatch(), Check_Ord_Line_Config_Mismatch() to consider IPT_RO demand_code for replacement rental.
--  140226  ChBnlk  Bug 113704, Modified Get_Edit_Config_Info() by changing the error messages.
--  140217  MaEdlk  Bug 113407, Called Sales_Part_API.Validate_Config_Allowed in Check_Configurable_Change to check sales part on configurability change in part catalog.
--  140129  ChBnlk  Bug 113704, Added methods Get_Edit_Config_Info(), Check_Cust_Ord_Config_Mismatch() and Check_Ord_Line_Config_Mismatch(). 
--  140129          Modified Check_Edit_Config_Allowed() to set order_type_ to 'PR' and 'PO' when purchase_type_db_ is 'R' and 'O' and
--  140129          removed the error message that was desplayed when trying to edit the configuration when demand code is 'IPD' or 'IPT'.          
--  140129          Modified Update_Configuration__() to update the configuration of a purchase order line when when it is connected to a customer order line.  
--  131204  TiRalk  Bug 113856, Modified Check_Edit_Config_Allowed() to check the state of the Purchase requisition and raise an error. 
--  131125  TiRalk  Bug 113856, Added Get_Config_Spec_Objstate to fetch objstate of configuration and modified Update_Configuration__
--  131125          to update of connected supply orders even if the configuration id has not changed.
--  130708  MaRalk  TIBE-1001, Removed following global LU constants and modified relevant methods accordingly.
--  130708          inst_ConfigurationSpec_ - Configuration_Exist, Is_Base_Part_Config_Valid, inst_ConfigSpecValue_ - Config_Spec_Value_Exist, 
--  130708          inst_InterimDemandHead_ - Update_Configuration__, Evaluate_Usage_For_Cost__, Re_Evaluate_Usage_For_Cost__, 
--  130708          Inst_InterimCtpManager_ - Update_Configuration__, Evaluate_Usage_For_Cost__, Re_Evaluate_Usage_For_Cost__, 
--  130708          inst_ShopOrd_ -Check_Edit_Config_Allowed, inst_DopDemandCustOrd_ -Check_Edit_Config_Allowed, 
--  130708          inst_DopHead_ - Update_Configuration__, inst_PurReqLinePart_ - Update_Configuration__,  
--  130708          inst_ConfigManager_ - Check_Configuration_Revision.
--  130508  KiSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130318  MaIklk  Included to fetch BusinessOpportunity info in Get_Order_Info().
--  120509  Hasplk  Added method Is_Allow_Create_Config_Order.
--  120416  ChJalk  Modified the method Evaluate_Usage_For_Cost__ to evaluate the cost through interim demand head if there is no interim order created.
--  120213  HaPulk  Write existing Dynamic code to INVENT (PurchaseType) as static
--  120402  JICE    Added public method Get_Order_Info.
--  120131  IsSalk  Bug 101020, Modified procedure Update_Configuration__ by replacing the dynamic call to method
--  120131          Purchase_Req_Line_Part_API.Modify_Requis_Line with Purchase_Req_Line_Part_API.Set_Configuration_Id. 
--  110509  AmPalk  Bug 96073, Added Recalc_Line_Tot_Net_Weight. 
--  100525  MaAnlk  Bug 90829, Modified Check_Configuration_Revision procedure.
--  100519  KRPELK  Merge Rose Method Documentation.
--  100422  MaAnlk  Bug 79609, Added Check_Configuration_Revision. Modified the way changes in configuration are propagated.
--  091228  MaEelk  Replaced the obsolete method calls Interim_Order_Int_API.Get_Int_Head_By_Usage,
--  091228          Interim_Order_Int_API.Set_Conf_For_Interim_Demand, Interim_Order_Int_API.Evaluate_Usage_For_Cost and
--  091228          Interim_Order_Int_API.Re_Evaluate_Usage_For_Cost with Interim_Demand_Head_API.Get_Int_Head_By_Usage,
--  091228          Interim_Demand_Head_API.Set_Conf_For_Interim_Demand, Interim_Demand_Head_API.Evaluate_Usage_For_Cost
--  091228          and Interim_Demand_Head_API.Re_Evaluate_Usage_For_Cost respectively.
--  ------------------------- 14.0.0 ----------------------------------------
--  080917  ThAylk  Bug 76924, Modified the error message which get raised when try to changes the 
--  080917          configuration where pegged PO exists, in method Check_Edit_Config_Allowed. 
--  080128  ThAylk  Bug 70710, Replaced the check for CO state Released with qty_on_order!=0 in Check_Edit_Config_Allowed.
--  070704  ChJalk  Modified Update_Configuration__ to pass old configuration_id in call Dop_Head_API.Change_Config_For_Oe.
--  070104  RaKalk  Modified Evaluate_Usage_For_Cost__ and Re_Evaluate_Usage_For_Cost__ methods to correct the method call
--  070104          to Sales_Cost_Util_API.Modify_Cost_Incl_Sales_Oh by removing duplicated word 'cost' in the method name.
--  070102  ChBalk  Replaced call Customer_Order_Line_API.Modify_Cost with 
--  070102          Sales_Cost_Util_API.Modify_Cost_Incl_Sales_Oh
--  061220  ChBalk  Replaced call Order_Quotation_Line_API.Modify_Cost with 
--  061220          Sales_Cost_Util_API.Modify_Cost_Incl_Sales_Oh
--  060220  SaNalk  Added an error message when demand_cod is IPT or IPD, in Check_Edit_Config_Allowed. 
--  060212  RaSilk  Modified method Check_Edit_Config_Allowed to fetch correct CO state DB value.
--  060124  JaJalk  Added Assert safe annotation.
--  050920  NaLrlk  Removed unused variables.
--  050914  RaSilk  Modified information messages in method Check_Edit_Config_Allowed.
--  050815  RaSilk  Modified parameters of method Check_Edit_Config_Allowed.
--  050715  RaSilk  Modified Check_Edit_Config_Allowed to handle supply code IPD and IPT.
--  050609  RaSilk  Added dynamic call to Purchase_Req_Line_Part_API.Modify_Requis_Line in method Update_Configuration__.
--  050607  RaSilk  Modified Update_Configuration__ to update configuration in DOP and SO. Added parameter supply_code_
--  050607          to method Update_Configuration__ and int_order_exist_ to Check_Edit_Config_Allowed.
--  050505  IsWilk  Added the PROCEDURE Check_Edit_Config_Allowed when editing
--  050505          the configurations for different supply types.
--  050217  DaZase  Added ctp_planned_db_ to Update_Configuration__. Added some ctp_planned handling
--                  in methods Evaluate_Usage_For_Cost__/Re_Evaluate_Usage_For_Cost__.
--  040128  GeKalk  Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  031118  JoAnSe  Reversed previous correction made in Check_Configurable_Change
--  031023  JOHESE  Added check on sourcing option in Check_Configurable_Change
--  030730  UsRalk  Merged SP4 changes to TAKEOFF code.
--  030417  MaGu    Bug 33755. Modified method Copy_Config_Pricing. Added catalog_no to the cursors
--  030417          find_option_price_list and find_char_price_list.
--  021212  Asawlk  Merged bug fixes in 2002-3 SP3
--  021119  MaGu    Bug 32538. Modified method Copy_Config_Pricing.
--  021111  MaGu    Bug 32538. Added methods Config_Pricing_Exist and Copy_Config_Pricing.
--  020820  JoAnSe  Bug 19110 Added check for configured package component in
--  020820          Check_Configurable_Change.
--  010528  JSAnse  Bug Fix 21463, Added call to General_SYS.Init_Method in procedure Check_Configurable_Change and removed 'True'
--                  as last parameter in the same statement in procedures Update_Configuration, Configuration_Exist,
--                  Is_Base_Part_Config_Valid and Config_Spec_Value_Exist.
--  010413  JaBa  Bug Fix 20598,Added new global lu constants inst_ConfigurationSpec_,inst_ConfigSpecValue_,Inst_InterimOrderInt_.
--  001219  JoEd  Added CustomerConsignmentStock check in Check_Configurable_Change.
--  001201  JoAn  Changed the check in Check_Configurable_Change to be more restrictive
--                in order to eliminate the need for a similar check in Customer Scheduling.
--  001127  JoAn  Added Check_Configurable_Change.
--  001115  JakH  Added evaluate_usage_for_cost and re_evaluate_usage_for_cost
--  001109  JakH  Added Update_Configuration__ to take care of updates associated
--                with a changed cfg id on an order or quote line
--  001002  JakH  Added functino for controlling ConfigSpecValue
--  001002  JakH  Added LU-variables for is-installed check. Added exception handler.
--  000929  JakH  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Update_Configuration__
--   Takes care of updates associated with changes of the configuration
--   update on customer order line or quotation line.
PROCEDURE Update_Configuration__ (
   interim_demand_usage_type_db_ IN VARCHAR2,
   identity_no_                  IN VARCHAR2,
   line_no_                      IN VARCHAR2,
   rel_no_                       IN VARCHAR2,
   line_item_no_                 IN NUMBER,
   old_configuration_id_         IN VARCHAR2,
   new_configuration_id_         IN VARCHAR2,
   ctp_planned_db_               IN VARCHAR2,
   supply_code_                  IN VARCHAR2 )
IS
   i_interim_demand_usage_type_ VARCHAR2(20) := interim_demand_usage_type_db_;
   i_identity_no_               VARCHAR2(12) := identity_no_;
   i_line_no_                   VARCHAR2(4)  := line_no_;
   i_rel_no_                    VARCHAR2(4)  := rel_no_;
   i_line_item_no_              NUMBER       := line_item_no_;
   i_new_configuration_id_      VARCHAR2(50) := new_configuration_id_;
   po_order_no_                 VARCHAR2(12);
   po_line_no_                  VARCHAR2(4);
   po_rel_no_                   VARCHAR2(4);
   purchase_type_               VARCHAR2(200);
   interim_header_id_           VARCHAR2(12);
   attr_                        VARCHAR2(2000);
   change_request_              VARCHAR2(5) := 'FALSE';
   configuration_status_        VARCHAR2(30);
   po_state_                    VARCHAR2(20);
   pr_line_state_               VARCHAR2(20);
BEGIN
   -- if the interim demand head exist for the usage and we change the configuration then we must update the interim demand head.
   $IF Component_Ordstr_SYS.INSTALLED $THEN
      IF (old_configuration_id_ != new_configuration_id_ AND ctp_planned_db_ = 'N') THEN  
         interim_header_id_ := Interim_Demand_Head_API.Get_Int_Head_By_Usage( i_interim_demand_usage_type_, i_identity_no_, i_line_no_, i_rel_no_, i_line_item_no_);
         IF interim_header_id_ IS NOT NULL THEN
            Interim_Demand_Head_API.Set_Conf_For_Interim_Demand (interim_header_id_, i_new_configuration_id_);
         END IF;
         
         Trace_Sys.Field('Configuration ' || old_configuration_id_ ||' was updated to ' || new_configuration_id_ ||' for ' || interim_demand_usage_type_db_ || ' no ' ||
                          identity_no_ || ' ' || line_no_ || ' ' || rel_no_, line_item_no_);         
      -- when its a ctp_planned row we use another method to fetch the interim_header_id
      ELSIF (old_configuration_id_ != new_configuration_id_ AND ctp_planned_db_ = 'Y') THEN
         interim_header_id_ := Interim_Ctp_Manager_API.Get_Top_Int_Head_By_Usage(i_interim_demand_usage_type_, i_identity_no_, i_line_no_, i_rel_no_, i_line_item_no_);
         IF interim_header_id_ IS NOT NULL THEN
            Interim_Demand_Head_API.Set_Conf_For_Interim_Demand ( interim_header_id_, i_new_configuration_id_);
         END IF;
         
         Trace_Sys.Field('Configuration ' || old_configuration_id_ ||' was updated to ' || new_configuration_id_ ||' for ' || interim_demand_usage_type_db_ || ' no ' ||
                         identity_no_ || ' ' || line_no_ || ' ' || rel_no_, line_item_no_);
      END IF;
   $END
   
   IF (supply_code_ = 'DOP') THEN
      $IF Component_Dop_SYS.INSTALLED $THEN
          Dop_Head_API.Handle_Config_Change(identity_no_, line_no_, rel_no_, line_item_no_, new_configuration_id_, old_configuration_id_);        
      $ELSE
          NULL;    
      $END         
   END IF;
   IF (supply_code_ = 'SO') THEN
      Customer_Order_Shop_Order_API.Update_Configuration(identity_no_, line_no_, rel_no_, line_item_no_, new_configuration_id_);
   END IF;

   IF (supply_code_ IN ('PT', 'PD', 'IPT', 'IPD') AND (old_configuration_id_ != new_configuration_id_))  THEN
      Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_, po_line_no_, po_rel_no_, purchase_type_,
                                                          identity_no_, line_no_, rel_no_, line_item_no_);
      IF (po_order_no_ IS NOT NULL) THEN
         change_request_ := Customer_Order_Line_API.Get_Send_Change_Msg_For_Supp(identity_no_, line_no_, rel_no_, line_item_no_);
         configuration_status_ := Get_Config_Spec_Objstate(Customer_order_line_API.Get_Purchase_Part_No(identity_no_, line_no_, rel_no_, line_item_no_), new_configuration_id_);
         $IF Component_Purch_SYS.INSTALLED $THEN
            pr_line_state_ := Purchase_Req_Line_API.Get_Requisition_Line_Objstate(po_order_no_, po_line_no_, po_rel_no_);
            po_state_ := Purchase_Order_API.Get_Objstate(po_order_no_);
         $ELSE
            NULL;         
         $END
         IF (Purchase_Type_API.Encode(purchase_type_) = 'R') THEN
            IF ( (pr_line_state_ != 'Planned') AND (configuration_status_ != 'Completed') ) THEN
               Error_SYS.Record_General(lu_name_, 'STOPEDITPR: Configured part need to be in Complete status when the pegged purchase requisition is not in Planned status. Therefore customer order is not updated.');               
            END IF;
         ELSIF (Purchase_Type_API.Encode(purchase_type_) = 'O') THEN
            IF ( (po_state_ != 'Planned') AND (configuration_status_ != 'Completed')) THEN
               Error_SYS.Record_General(lu_name_, 'STOPEDITPO: Configured part need to be in Complete status when the pegged purchase order is not in Planned status. Therefore customer order is not updated.'); 
            END IF;
         END IF;
         Client_SYS.Add_To_Attr('CONFIGURATION_ID', new_configuration_id_ , attr_);
         $IF Component_Purch_SYS.INSTALLED $THEN
            Purchase_Order_Line_API.Modify_Ord_Line( po_order_no_, po_line_no_, po_rel_no_, purchase_type_, change_request_, attr_);
         $ELSE
            NULL;            
         $END             
      END IF;
   END IF;
END Update_Configuration__;


-- Evaluate_Usage_For_Cost__
--   Wrapper function that calls the interim order to create and get the cost.
--   Will update the cost on the calling object.
PROCEDURE Evaluate_Usage_For_Cost__ (
   interim_demand_usage_type_db_ IN VARCHAR2,
   identity_no_                  IN VARCHAR2,
   line_no_                      IN VARCHAR2,
   rel_no_                       IN VARCHAR2,
   line_item_no_                 IN NUMBER,
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   qty_required_                 IN NUMBER,
   required_date_                IN DATE )
IS
   total_cost_       NUMBER;
   ctp_planned_db_   VARCHAR2(1);
   interim_order_no_ VARCHAR2(12);
BEGIN

   IF (interim_demand_usage_type_db_ = 'CUSTOMERORDER') THEN
      ctp_planned_db_   := Gen_Yes_No_API.Encode(Customer_Order_Line_Api.Get_Ctp_Planned(identity_no_, line_no_, rel_no_, line_item_no_));
      interim_order_no_ := Customer_Order_Line_API.Get_Interim_Order_No(identity_no_, line_no_, rel_no_, line_item_no_, 'N');
   ELSE
      ctp_planned_db_   := Gen_Yes_No_API.Encode(Order_Quotation_Line_API.Get_Ctp_Planned(identity_no_, line_no_, rel_no_, line_item_no_));
      interim_order_no_ := Order_Quotation_Line_API.Get_Interim_Order_No(identity_no_, line_no_, rel_no_, line_item_no_, 'N');
   END IF;   
      
   $IF Component_Ordstr_SYS.INSTALLED $THEN
      IF (ctp_planned_db_ = 'N') OR (interim_order_no_ IS NULL) THEN   
         Interim_Demand_Head_API.Evaluate_Usage_For_Cost(total_cost_, interim_demand_usage_type_db_,
                                                         identity_no_, line_no_, rel_no_, line_item_no_,
                                                         contract_, part_no_, qty_required_, required_date_);

      ELSE -- for ctp_planned rows use the Interim_Ctp_Manager method instead  
         Interim_Ctp_Manager_API.Evaluate_Usage_For_Cost(total_cost_, interim_demand_usage_type_db_,
                                                         identity_no_, line_no_, rel_no_, line_item_no_,
                                                         contract_, part_no_, qty_required_, required_date_);             
      END IF; 
      
      Trace_Sys.Field('Rolled up cost', total_cost_);      
   $END
   
   IF total_cost_ IS NOT NULL THEN 
      IF (interim_demand_usage_type_db_ = 'CUSTOMERORDER') THEN
         Sales_Cost_Util_API.Modify_Cost_Incl_Sales_Oh (identity_no_, line_no_, rel_no_, line_item_no_, total_cost_, 'ORDER');
      ELSIF (interim_demand_usage_type_db_ = 'CUSTOMERQUOTE') THEN
         Sales_Cost_Util_API.Modify_Cost_Incl_Sales_Oh (identity_no_, line_no_, rel_no_, line_item_no_, total_cost_, 'QUOTATION');
      ELSE
         Error_SYS.Record_General(lu_name_,'USAGETYPERR: The usage type :P1 is not recognized.', interim_demand_usage_type_db_);
      END IF;   
   END IF;   
END Evaluate_Usage_For_Cost__;


-- Re_Evaluate_Usage_For_Cost__
--   Wrapper function that calls the interim order to reevaluate the interim
--   structure and get the cost. Will update the cost on the calling object.
PROCEDURE Re_Evaluate_Usage_For_Cost__ (
   interim_demand_usage_type_db_ IN VARCHAR2,
   identity_no_                  IN VARCHAR2,
   line_no_                      IN VARCHAR2,
   rel_no_                       IN VARCHAR2,
   line_item_no_                 IN NUMBER )
IS
   total_cost_     NUMBER;
   ctp_planned_db_ VARCHAR2(1);
BEGIN
   IF (interim_demand_usage_type_db_ = 'CUSTOMERORDER') THEN
      ctp_planned_db_ := Gen_Yes_No_API.Encode(Customer_Order_Line_Api.Get_Ctp_Planned(identity_no_, line_no_, rel_no_, line_item_no_));
   ELSE
      ctp_planned_db_ := Gen_Yes_No_API.Encode(Order_Quotation_Line_API.Get_Ctp_Planned(identity_no_, line_no_, rel_no_, line_item_no_));
   END IF;
   
   $IF Component_Ordstr_SYS.INSTALLED $THEN
      IF (ctp_planned_db_ = 'N') THEN
         Interim_Demand_Head_API.Re_Evaluate_Usage_For_Cost(total_cost_, interim_demand_usage_type_db_,
                                                            identity_no_, line_no_, rel_no_, line_item_no_);
      ELSE -- for ctp_planned rows use the Interim_Ctp_Manager method instead   
         Interim_Ctp_Manager_API.Re_Evaluate_Usage_For_Cost(total_cost_, interim_demand_usage_type_db_,
                                                            identity_no_, line_no_, rel_no_, line_item_no_); 
      END IF;
      Trace_Sys.Field('Rolled up cost', total_cost_);           
   $END  
   
   IF total_cost_ IS NOT NULL THEN
      IF (interim_demand_usage_type_db_ = 'CUSTOMERORDER') THEN
         Sales_Cost_Util_API.Modify_Cost_Incl_Sales_Oh (identity_no_, line_no_, rel_no_, line_item_no_, total_cost_, 'ORDER');
      ELSIF (interim_demand_usage_type_db_ = 'CUSTOMERQUOTE') THEN
         Sales_Cost_Util_API.Modify_Cost_Incl_Sales_Oh (identity_no_, line_no_, rel_no_, line_item_no_, total_cost_, 'QUOTATION');
      ELSE
         Error_SYS.Record_General(lu_name_,'USAGETYPERR: The usage type :P1 is not recognized.', interim_demand_usage_type_db_);
      END IF;    
   END IF;      
END Re_Evaluate_Usage_For_Cost__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Recalc_Line_Tot_Net_Weight
--   Recalculates line total net weight of configuration spec connected CO Lines and/or OQ Lines.
PROCEDURE Recalc_Line_Tot_Net_Weight (
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
BEGIN
   Customer_Order_Line_API.Recalc_Line_Tot_Net_Weight(part_no_,configuration_id_);
   Order_Quotation_Line_API.Recalc_Line_Tot_Net_Weight(part_no_,configuration_id_);
END Recalc_Line_Tot_Net_Weight;


-- Configuration_Exist
--   Fails if the configuration does not exist.
PROCEDURE Configuration_Exist (
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
   i_part_no_          VARCHAR2(25) := part_no_;
   i_configuration_id_ VARCHAR2(50) := configuration_id_;
BEGIN
   -- assume this is a part-catalog part which is a base item!
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      IF (configuration_id_ != '*') THEN
         Configuration_Spec_API.Exist(i_part_no_, i_configuration_id_);   
      END IF;        
   $ELSE
      NULL;  
   $END
END Configuration_Exist;


-- Order_Config_Exist_For_Part
--   Checks whether a configuration exists in the SQ/CO lines for a given customer.
PROCEDURE Order_Config_Exist_For_Part (
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   planned_del_date_ IN DATE )
IS
   temp_ NUMBER := 0;
   spec_revision_no_ NUMBER;

   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      CURSOR check_config_spec_in_order IS
         SELECT 1 
         FROM   customer_order_line_tab c, CONFIG_SPEC_ORDER_USAGE o
         WHERE  c.Order_No = o.identity1
         AND    c.line_no = o.identity2
         AND    c.rel_no = o.identity3
         AND    c.line_item_no  = o.identity4
         AND    o.configuration_id = configuration_id_
         AND    o.part_no = part_no_
         AND    o.spec_revision_no = spec_revision_no_
         $IF Component_Crm_SYS.INSTALLED $THEN
            UNION
            SELECT 1 
            FROM   business_opportunity_line_tab b, CONFIG_SPEC_ORDER_USAGE o
            WHERE  b.opportunity_no = o.identity1
            AND    b.revision_no = o.identity2
            AND    b.line_no = o.identity3
            AND    o.configuration_id = configuration_id_
            AND    o.part_no = part_no_
            AND    o.spec_revision_no = Config_Part_Spec_Rev_API.Get_Spec_Rev_For_Date(NVL(b.catalog_no, b.customer_part_no), NVL(planned_del_date_,SYSDATE))
         $END
         UNION
         SELECT 1
         FROM   order_quotation_line_tab q, CONFIG_SPEC_ORDER_USAGE o
         WHERE  q.quotation_no = o.identity1
         AND    q.line_no = o.identity2
         AND    q.rel_no = o.identity3
         AND    q.line_item_no  = o.identity4
         AND    o.configuration_id = configuration_id_
         AND    o.part_no = part_no_
         AND    o.spec_revision_no = spec_revision_no_;        
   $END
BEGIN   
   -- assume this is a part-catalog part which is a base item!
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      IF (NVL(configuration_id_, ' ') != '*') THEN
         spec_revision_no_ := Config_Part_Spec_Rev_API.Get_Spec_Rev_For_Date(part_no_, NVL(planned_del_date_,SYSDATE)); 
         OPEN check_config_spec_in_order;
         FETCH check_config_spec_in_order INTO temp_;
         CLOSE check_config_spec_in_order;
   
         IF temp_ = 0 THEN
            Error_SYS.Record_General(lu_name_, 'CONFNOTVALIDFORPART: The configuration ID :P1 is not valid for the  sales part No :P2', configuration_id_, part_no_);
         END IF;
      END IF;
   $ELSE
      NULL;   
   $END
END Order_Config_Exist_For_Part;

-- Validate_Configuration_Id
--   Checks whether a configuration exists in the SQ/CO lines for a given customer.
PROCEDURE Check_Configuration_Exist (
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER)
IS
   
BEGIN
   -- assume this is a part-catalog part which is a base item!
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
   IF (configuration_id_ != '*') THEN
      IF (Configuration_Spec_API.Exist_Configuration_Spec(part_no_, configuration_id_) IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CONFNOTEXISTFORPART: The configuration id :P1 does not exist for part :P2.', configuration_id_, part_no_);
      END IF;
   END IF;
   IF order_no_ IS NOT NULL THEN
      IF (Customer_Order_Line_API.Get_Configuration_Id(order_no_, line_no_, release_no_, NVL(line_item_no_,0)) != configuration_id_) THEN
         Error_SYS.Record_General(lu_name_, 'CONFNOTEXISTFORORDER: The configuration id :P1 does not exist for customer order :P2.', configuration_id_, order_no_);
      END IF;
   END IF;
   $ELSE
      NULL;
   $END   
   
END Check_Configuration_Exist;

-- Get_Config_Spec_Status
--   Fetches the configuration spec status for a given part no and a configuration id.
@UncheckedAccess
FUNCTION Get_Config_Spec_Status (
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   status_  VARCHAR2(30) := NULL;   
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      status_ := Configuration_Spec_API.Get_State(part_no_, configuration_id_);
   $END

   RETURN status_;
END Get_Config_Spec_Status;



-- Is_Base_Part_Config_Valid
--   Returns 1 if the configuration is valid 0 otherwise
FUNCTION Is_Base_Part_Config_Valid (
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   result_             NUMBER := 1;
   i_part_no_          VARCHAR2(25) := part_no_ ;
   i_configuration_id_ VARCHAR2(50) := configuration_id_;
BEGIN
   -- assume this is a part-catalog part which is a base item!

   IF (configuration_id_ = '*') THEN
      result_ := 0;      
   ELSE
      $IF Component_Cfgchr_SYS.INSTALLED $THEN
         result_ := Configuration_Spec_API.Is_Valid(i_part_no_, i_configuration_id_);                   
      $ELSE
          NULL;    
      $END      
   END IF;

   RETURN result_;
END Is_Base_Part_Config_Valid;


-- Config_Spec_Value_Exist
--   Fails if the config spec value does not exist.
PROCEDURE Config_Spec_Value_Exist (
   part_no_              IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   spec_revision_no_     IN NUMBER,
   characteristic_id_    IN VARCHAR2,
   config_spec_value_id_ IN NUMBER )
IS
   i_part_no_              VARCHAR2(25) := part_no_;
   i_configuration_id_     VARCHAR2(50) := configuration_id_;
   i_spec_revision_no_     NUMBER       := spec_revision_no_;
   i_characteristic_id_    VARCHAR2(24) := characteristic_id_;
   i_config_spec_value_id_ NUMBER       := config_spec_value_id_;
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      Config_Spec_Value_API.Exist(i_configuration_id_, i_part_no_, i_spec_revision_no_, i_characteristic_id_, i_config_spec_value_id_);  
   $ELSE
      NULL;                 
   $END
END Config_Spec_Value_Exist;


-- Check_Configurable_Change
--   Method which should be called from part catalog when changing the value
--   of the configurable attribute for a part.
--   This method checks if changing the flag should be allowed or not.
--   Changing the value is only allowed when the part does not exist on
--   any released customer orders or quotations.
PROCEDURE Check_Configurable_Change (
   part_no_         IN VARCHAR2,
   configurable_db_ IN VARCHAR2 )
IS
   -- package parts are not configurable
   CURSOR check_orders IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE decode(catalog_type, 'PKG', ' ', nvl(part_no, catalog_no)) = part_no_;

   CURSOR check_quotations IS
      SELECT 1
      FROM ORDER_QUOTATION_LINE_TAB
      WHERE decode(catalog_type, 'PKG', ' ', nvl(part_no, catalog_no)) = part_no_;

   -- only inventory parts are used by CustomerConsignmentStock
   CURSOR check_consignment IS
      SELECT 1
      FROM CUSTOMER_CONSIGNMENT_STOCK_TAB
      WHERE (contract, catalog_no) IN (SELECT contract, catalog_no
                                       FROM SALES_PART_TAB
                                       WHERE catalog_type = 'INV'
                                       AND part_no = part_no_);

   -- configured parts are not allowed in packages
   CURSOR check_package_component IS
      SELECT 1
      FROM   SALES_PART_PACKAGE_TAB
      WHERE  (contract, catalog_no) IN (SELECT contract, catalog_no
                                        FROM SALES_PART_TAB
                                        WHERE (catalog_type = 'INV' AND part_no = part_no_)
                                        OR    (catalog_type = 'NON' AND catalog_no = part_no_));

   found_ NUMBER;
BEGIN
   -- Validate sales part/inventory part combination 
   Sales_Part_API.Validate_Config_Allowed(part_no_, configurable_db_, NULL);
   
   OPEN check_orders;
   FETCH check_orders INTO found_;
   IF (check_orders%FOUND) THEN
      CLOSE check_orders;
      Error_SYS.Record_General(lu_name_, 'CONFIG_ON_ORDER: The configurable flag may not be changed for part :P1 because the part is used on Customer Orders', part_no_);
   END IF;
   CLOSE check_orders;

   OPEN check_quotations;
   FETCH check_quotations INTO found_;
   IF (check_quotations%FOUND) THEN
      CLOSE check_quotations;
      Error_SYS.Record_General(lu_name_, 'CONFIG_ON_QUOTE: The configurable flag may not be changed for part :P1 because the part is used on Sales Quotations', part_no_);
   END IF;
   CLOSE check_quotations;

   OPEN check_consignment;
   FETCH check_consignment INTO found_;
   IF (check_consignment%FOUND) THEN
      CLOSE check_consignment;
      Error_SYS.Record_General(lu_name_, 'CONFIG_ON_CONS: The configurable flag may not be changed for part :P1 because the part is used on Customer Consignment Stock', part_no_);
   END IF;
   CLOSE check_consignment;

   IF (configurable_db_ = 'CONFIGURED') THEN
      OPEN check_package_component;
      FETCH check_package_component INTO found_;
      IF (check_package_component%FOUND) THEN
         CLOSE check_package_component;
         Error_SYS.Record_General(lu_name_, 'CONFIG_IN_PKG: The configurable flag may not set for part :P1 because the part is included as a component in a Package Part', part_no_);
      END IF;
      CLOSE check_package_component;
   END IF;
END Check_Configurable_Change;


-- Config_Pricing_Exist
--   Returns value for TRUE if configuration pricing exists for the current
--   part number and spec revision number. If a characteristic id is specified,
--   this method only checks for pricing records for that characteristic.
@UncheckedAccess
FUNCTION Config_Pricing_Exist (
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   found_ NUMBER;

   CURSOR get_sales_part_info IS
      SELECT contract, catalog_no
      FROM   SALES_PART_TAB
      WHERE  part_no = part_no_;

   CURSOR find_base_price_all(contract_ IN VARCHAR2, catalog_no_ IN VARCHAR2) IS
      SELECT 1
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE contract = contract_
      AND   catalog_no = catalog_no_
      AND   part_no = part_no_
      AND   spec_revision_no = spec_revision_no_;

   CURSOR find_price_list_all IS
      SELECT 1
      FROM CHARACTERISTIC_PRICE_LIST
      WHERE part_no = part_no_
      AND   spec_revision_no = spec_revision_no_;

   CURSOR find_base_price_char(contract_ IN VARCHAR2, catalog_no_ IN VARCHAR2) IS
      SELECT 1
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE contract = contract_
      AND   catalog_no = catalog_no_
      AND   part_no = part_no_
      AND   spec_revision_no = spec_revision_no_
      AND   characteristic_id = characteristic_id_;

   CURSOR find_price_list_char IS
      SELECT 1
      FROM CHARACTERISTIC_PRICE_LIST
      WHERE part_no = part_no_
      AND   spec_revision_no = spec_revision_no_
      AND   characteristic_id = characteristic_id_;
BEGIN
   found_ := 0;

   IF (characteristic_id_ IS NOT NULL) THEN
      -- Search for pricing records for a specific characteristic
      FOR sales_part_rec_ IN get_sales_part_info LOOP
         -- Search for characteristic base price
         OPEN find_base_price_char(sales_part_rec_.contract, sales_part_rec_.catalog_no);
           FETCH find_base_price_char INTO found_;
           IF find_base_price_char%FOUND THEN
              CLOSE find_base_price_char;
              EXIT;
           END IF;
         CLOSE find_base_price_char;
      END LOOP;

      IF (found_ != 1) THEN
         -- Search for characteristic price list
         OPEN find_price_list_char;
         FETCH find_price_list_char INTO found_;
         CLOSE find_price_list_char;
      END IF;
   ELSIF (characteristic_id_ IS NULL) THEN
      -- Search for all characteristic pricing records for the current part_no and revision
      FOR sales_part_rec_ IN get_sales_part_info LOOP
         -- Search for characteristic base price
         OPEN find_base_price_all(sales_part_rec_.contract, sales_part_rec_.catalog_no);
           FETCH find_base_price_all INTO found_;
           IF find_base_price_all%FOUND THEN
              CLOSE find_base_price_all;
              EXIT;
           END IF;
         CLOSE find_base_price_all;
      END LOOP;

      IF (found_ != 1) THEN
         -- Search for characteristic price list
         OPEN find_price_list_all;
         FETCH find_price_list_all INTO found_;
         CLOSE find_price_list_all;
      END IF;
   END IF;

   RETURN found_;
END Config_Pricing_Exist;



-- Copy_Config_Pricing
--   Copies all configuration pricing records from one part specification
--   revision to another. Records are copied in tables Characteristic_Base_Price,
--   Option_Value_Base_Price, Characteristic_Price_List and Option_Value_Price_List.
PROCEDURE Copy_Config_Pricing (
   part_no_              IN VARCHAR2,
   old_spec_revision_no_ IN NUMBER,
   new_spec_revision_no_ IN NUMBER )
IS
   char_id_temp_    VARCHAR2(24) := ' ';
   price_list_temp_ VARCHAR2(10) := ' ';
   sales_part_temp_ VARCHAR2(25) := ' ';

   CURSOR get_sales_part_info IS
      SELECT contract, catalog_no
      FROM   SALES_PART_TAB
      WHERE  part_no = part_no_
      ORDER BY catalog_no;

   CURSOR find_char_base_price(contract_ IN VARCHAR2, catalog_no_ IN VARCHAR2) IS
      SELECT characteristic_id, break_line_no, valid_from_date, quantity_break
      FROM   CHARACTERISTIC_BASE_PRICE_TAB
      WHERE  contract = contract_
      AND    catalog_no = catalog_no_
      AND    part_no = part_no_
      AND    spec_revision_no = old_spec_revision_no_
      ORDER BY characteristic_id;

   CURSOR find_option_base_price(contract_ IN VARCHAR2, catalog_no_ IN VARCHAR2,
                                 characteristic_id_ IN VARCHAR2) IS
      SELECT option_value_id, valid_from_date
      FROM   OPTION_VALUE_BASE_PRICE_TAB
      WHERE  contract = contract_
      AND    catalog_no = catalog_no_
      AND    part_no = part_no_
      AND    spec_revision_no = old_spec_revision_no_
      AND    characteristic_id = characteristic_id_;

   CURSOR find_char_price_list(catalog_no_ IN VARCHAR2) IS
      SELECT price_list_no, characteristic_id, break_line_no, valid_from_date, quantity_break
      FROM   CHARACTERISTIC_PRICE_LIST
      WHERE  part_no = part_no_
      AND    spec_revision_no = old_spec_revision_no_
      AND    catalog_no = catalog_no_
      ORDER BY price_list_no, characteristic_id;

   CURSOR find_option_price_list (price_list_no_ IN VARCHAR2, characteristic_id_ IN VARCHAR2, catalog_no_ IN VARCHAR2) IS
      SELECT option_value_id, valid_from_date
      FROM OPTION_VALUE_PRICE_LIST_TAB
      WHERE price_list_no = price_list_no_
      AND   part_no = part_no_
      AND   spec_revision_no = old_spec_revision_no_
      AND   catalog_no = catalog_no_
      AND   characteristic_id = characteristic_id_;
BEGIN
   -- Get attributes from sales part to be able to use key index in CHARACTERISTIC_BASE_PRICE_TAB
   FOR sales_part_rec_ IN get_sales_part_info LOOP

      -- Get all price records for characteristics base price for the old revision
      FOR char_base_price_rec_ IN find_char_base_price(sales_part_rec_.contract,
                                                       sales_part_rec_.catalog_no) LOOP

         -- Copy characteristics base price to the new revision.
         Characteristic_Base_Price_API.Copy_Revision_Price(sales_part_rec_.catalog_no,
                                                           part_no_,
                                                           sales_part_rec_.contract,
                                                           char_base_price_rec_.characteristic_id,
                                                           char_base_price_rec_.break_line_no,
                                                           char_base_price_rec_.valid_from_date,
                                                           char_base_price_rec_.quantity_break,
                                                           old_spec_revision_no_,
                                                           new_spec_revision_no_);

         -- Get all price records for option value base price for the old revision.
         IF (char_base_price_rec_.characteristic_id != char_id_temp_) THEN

            char_id_temp_ := char_base_price_rec_.characteristic_id;

            FOR option_base_price_rec_ IN find_option_base_price(sales_part_rec_.contract,
                                                                 sales_part_rec_.catalog_no,
                                                                 char_base_price_rec_.characteristic_id) LOOP
                -- Copy option value base price to the new revision.
                Option_Value_Base_Price_API.Copy_Revision_Price(sales_part_rec_.contract,
                                                                sales_part_rec_.catalog_no,
                                                                part_no_,
                                                                char_base_price_rec_.characteristic_id,
                                                                option_base_price_rec_.option_value_id,
                                                                option_base_price_rec_.valid_from_date,
                                                                old_spec_revision_no_,
                                                                new_spec_revision_no_);
            END LOOP;
         END IF;
      END LOOP;

      char_id_temp_ := ' ';

      -- Note: Restructured loop to handle new key element catalog_no in
      -- Note: tables characteristic_price_list_tab and option_value_price_list_tab.
      IF sales_part_temp_ != sales_part_rec_.catalog_no THEN
         -- Make sure that price list prices are only copied once per sales part no.
         sales_part_temp_ := sales_part_rec_.catalog_no;

         -- Get all price records for characteristics price list for the old revision
         FOR char_price_list_rec_ IN find_char_price_list(sales_part_rec_.catalog_no) LOOP

            -- Copy characteristics price list to the new revision.
            Characteristic_Price_List_API.Copy_Revision_Price(char_price_list_rec_.price_list_no,
                                                              part_no_,
                                                              char_price_list_rec_.characteristic_id,
                                                              char_price_list_rec_.break_line_no,
                                                              char_price_list_rec_.valid_from_date,
                                                              char_price_list_rec_.quantity_break,
                                                              old_spec_revision_no_,
                                                              new_spec_revision_no_,
                                                              sales_part_rec_.catalog_no);

            -- Copy option value price list to the new revision.
            IF (char_price_list_rec_.price_list_no != price_list_temp_) OR
                (char_price_list_rec_.characteristic_id != char_id_temp_) THEN
               -- Make sure that an option price list record is only copied once
               -- for every unique combination of price_list_no and characteristic_id.
               price_list_temp_ := char_price_list_rec_.price_list_no;
               char_id_temp_    := char_price_list_rec_.characteristic_id;

                -- Get all price records for option value price list for the old revision
               FOR option_price_list_rec_ IN find_option_price_list(char_price_list_rec_.price_list_no,
                                                                    char_price_list_rec_.characteristic_id,
                                                                    sales_part_rec_.catalog_no) LOOP

                   Option_Value_Price_List_API.Copy_Revision_Price(char_price_list_rec_.price_list_no,
                                                                   part_no_,
                                                                   char_price_list_rec_.characteristic_id,
                                                                   option_price_list_rec_.option_value_id,
                                                                   option_price_list_rec_.valid_from_date,
                                                                   old_spec_revision_no_,
                                                                   new_spec_revision_no_,
                                                                   sales_part_rec_.catalog_no);
               END LOOP;
            END IF;
         END LOOP;
      END IF;
   END LOOP;
END Copy_Config_Pricing;


PROCEDURE Check_Edit_Config_Allowed (
   order_type_      OUT VARCHAR2,
   ctp_planned_     OUT VARCHAR2,
   int_order_exist_ OUT VARCHAR2,
   info_            OUT VARCHAR2,
   order_no_        IN  VARCHAR2,
   line_no_         IN  VARCHAR2,
   release_no_      IN  VARCHAR2,
   line_item_no_    IN  NUMBER )
IS
   po_order_no_      VARCHAR2(12);
   po_line_no_       VARCHAR2(4);
   po_rel_no_        VARCHAR2(4);
   purchase_type_    VARCHAR2(20);
   purchase_type_db_ VARCHAR2(1);
   so_order_no_      VARCHAR2(12);
   so_release_no_    VARCHAR2(4);
   so_sequence_no_   VARCHAR2(4);
   so_state_         VARCHAR2(30);
   dop_id_           VARCHAR2(12);
   interim_id_       VARCHAR2(12);
   dop_state_        VARCHAR2(30);
   co_state_         VARCHAR2(30);
   co_line_rec_      Customer_Order_Line_API.Public_Rec;
   inv_part_rec_     Inventory_Part_API.Public_Rec;
BEGIN
   order_type_      := NULL;
   int_order_exist_ := 'FALSE';
   co_line_rec_     := Customer_Order_Line_API.Get(order_no_, line_no_, release_no_, line_item_no_);
   co_state_        := Customer_Order_API.Get_Objstate(order_no_);
   ctp_planned_     := co_line_rec_.ctp_planned;
   interim_id_      := Customer_Order_Line_API.Get_Interim_Order_No(order_no_, line_no_, release_no_, line_item_no_, 'N');
   IF (interim_id_ IS NOT NULL) THEN
      int_order_exist_ := 'TRUE';
   END IF;
   IF (co_line_rec_.qty_on_order != 0) THEN

      IF (co_line_rec_.supply_code IN ('PD', 'PT', 'IPD', 'IPT')) THEN
         Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_,
                                                          po_line_no_,
                                                          po_rel_no_,
                                                          purchase_type_,
                                                          order_no_,
                                                          line_no_,
                                                          release_no_,
                                                          line_item_no_);
         
         purchase_type_db_ := Purchase_Type_API.Encode(purchase_type_);         
         
         IF (purchase_type_db_ = 'R') THEN
            order_type_  := 'PR';
         END IF;

         IF (purchase_type_db_ = 'O') THEN
            order_type_ := 'PO';
         END IF;
      END IF;

      IF (co_line_rec_.supply_code = 'SO') THEN
         Customer_Order_Shop_Order_API.Get_Shop_Order(so_order_no_,
                                                      so_release_no_,
                                                      so_sequence_no_,
                                                      order_no_,
                                                      line_no_,
                                                      release_no_,
                                                      line_item_no_);

         $IF Component_Shpord_SYS.INSTALLED $THEN
            IF (so_order_no_ IS NOT NULL) THEN
               so_state_ := Shop_Ord_API.Get_State_Db(so_order_no_, so_release_no_, so_sequence_no_);   
            
               IF (so_state_ NOT IN ('Planned', 'Released', 'Reserved')) THEN
                  Error_SYS.Record_General(lu_name_, 'EDITPEGSO: Pegged Order has a status :P1. Edit configuration not allowed.', so_state_);
               ELSE
                  order_type_ := 'SO'; 
               END IF;
            END IF;             
         $END
      END IF;

      IF (co_line_rec_.supply_code = 'DOP') THEN
         $IF Component_Dop_SYS.INSTALLED $THEN
            dop_id_ := Dop_Demand_Cust_Ord_API.Get_Dop_Id_For_Cust_Ord_Line(order_no_, line_no_, release_no_, line_item_no_); 
            IF (dop_id_ IS NOT NULL) THEN 
               dop_state_ := Dop_Head_API.Get_Status(dop_id_);
               IF (dop_state_ IN ('Created', 'Unreleased', 'Netted', 'Released'))THEN
                  order_type_ := 'DOP';
               END IF;
            END IF;
         $ELSE
             NULL;    
         $END
      END IF;
      IF (co_line_rec_.supply_code = 'IO') THEN
         Error_SYS.Record_General(lu_name_, 'EDITPEGPO: The customer order line is pegged to a supply. Remove the pegging first, then change the configuration.');
      END IF;
   ELSE
      Client_SYS.Clear_Info;
      IF co_state_ = 'Planned' THEN
         IF (int_order_exist_ = 'FALSE' AND (co_line_rec_.ctp_planned = 'Y' OR co_line_rec_.latest_release_date IS NOT NULL)) THEN
            inv_part_rec_ := Inventory_Part_API.Get(co_line_rec_.contract, Sales_Part_API.Get_Part_No(co_line_rec_.contract, co_line_rec_.catalog_no));
            IF (inv_part_rec_.automatic_capability_check = 'NO AUTOMATIC CAPABILITY CHECK') THEN
               Client_SYS.Add_Info(lu_name_, 'CCIONOMATCH: Editing the configuration will make it necessary to run the Capability Check again.');
            ELSE
               Client_SYS.Add_Info(lu_name_, 'AUTOCCIONOMATCH: After the configuration is changed, the Capability Check will be performed automatically.');
            END IF;
         END IF;
         
         IF int_order_exist_ = 'TRUE' AND co_line_rec_.ctp_planned = 'N' THEN
            Client_SYS.Add_Info(lu_name_, 'NOCCIONOMATCH: Editing the configuration will make it no longer match your Interim Order. You will need to re-evaluate the Interim Order from the Interim Demand Head form.');
         END IF;
      END IF;
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Check_Edit_Config_Allowed;


-- Check_Configuration_Revision
--   This method checks whether the part configuration revision used to create the
--   configuration is valid for the planned delivery date.
PROCEDURE Check_Configuration_Revision (
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   planned_delivery_date_ IN DATE,
   qty_reserved_          IN NUMBER DEFAULT 0 )
IS
   revision_status_ VARCHAR2(50);   
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      IF (configuration_id_ != '*') THEN    
         revision_status_ := Config_Manager_API.Validate_Effective_Revision(part_no_, configuration_id_, planned_delivery_date_);  
         
         IF revision_status_ = 'INVALID' THEN
            IF (qty_reserved_ = 0) THEN
               Client_SYS.Add_Info(lu_name_, 'REVISIONNOTVALID: This change of the planned delivery date means that another part configuration revision is effective for configuration of :P1. Perform edit to use it.', part_no_);
            ELSE
               Client_SYS.Add_Info(lu_name_, 'REVNOTVALIDRESERV: This change of the planned delivery date means that another part configuration revision is effective for configuration of :P1. Reserved quantities will remain reserved.', part_no_);
            END IF;
         END IF;         
      END IF;         
   $ELSE
      NULL;    
   $END
END Check_Configuration_Revision;


-- Get_Order_Info
--   This method returns all order information from connected quotation / order
--   that is relevant when using sales configuration rules.
PROCEDURE Get_Order_Info (
   contract_         OUT VARCHAR2,
   catalog_no_       OUT VARCHAR2,
   sales_group_      OUT VARCHAR2,
   customer_no_      OUT VARCHAR2,
   sales_qty_        OUT NUMBER,
   sales_uom_        OUT VARCHAR2,
   delivery_country_ OUT VARCHAR2,
   usage_type_       IN VARCHAR2,
   usage_ref1_       IN VARCHAR2,
   usage_ref2_       IN VARCHAR2,
   usage_ref3_       IN VARCHAR2,
   usage_ref4_       IN NUMBER )
IS
   contract_tmp_   VARCHAR2(5);
   catalog_no_tmp_ VARCHAR2(25);
BEGIN
   IF usage_type_ = 'CUSTOMERORDER' THEN
      contract_tmp_     := Customer_Order_API.Get_Contract(usage_ref1_);
      customer_no_      := Customer_Order_API.Get_Customer_No(usage_ref1_);
      catalog_no_tmp_   := Customer_Order_Line_API.Get_Catalog_No(usage_ref1_, usage_ref2_, usage_ref3_, usage_ref4_);
      delivery_country_ := Cust_Order_Line_Address_API.Get_Country_Code(usage_ref1_, usage_ref2_, usage_ref3_, usage_ref4_);
      sales_qty_        := Customer_Order_Line_API.Get_Buy_Qty_Due(usage_ref1_, usage_ref2_, usage_ref3_, usage_ref4_);
      sales_uom_        := Customer_Order_Line_API.Get_Sales_Unit_Meas(usage_ref1_, usage_ref2_, usage_ref3_, usage_ref4_);
   ELSIF usage_type_ = 'CUSTOMERQUOTE' THEN
      contract_tmp_     := Order_Quotation_API.Get_Contract(usage_ref1_);
      customer_no_      := Order_Quotation_API.Get_Customer_No(usage_ref1_);
      catalog_no_tmp_   := Order_Quotation_Line_API.Get_Catalog_No(usage_ref1_, usage_ref2_, usage_ref3_, usage_ref4_);
      delivery_country_ := Customer_Info_Address_API.Get_Country_Code(Order_Quotation_API.Get_Customer_No(usage_ref1_), Order_Quotation_API.Get_Ship_Addr_No(usage_ref1_));
      sales_qty_        := Order_Quotation_Line_API.Get_Buy_Qty_Due(usage_ref1_, usage_ref2_, usage_ref3_, usage_ref4_);
      sales_uom_        := Order_Quotation_Line_API.Get_Sales_Unit_Measure(usage_ref1_, usage_ref2_, usage_ref3_, usage_ref4_);
   ELSIF usage_type_ = 'BUSINESSOPPORTUNITY' THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         contract_tmp_   := Business_Opportunity_Line_API.Get_Contract(usage_ref1_, usage_ref3_, usage_ref2_);
         customer_no_    := Business_Opportunity_API.Get_Customer_Id(usage_ref1_);
         catalog_no_tmp_ := Business_Opportunity_Line_API.Get_Catalog_No(usage_ref1_, usage_ref3_, usage_ref2_);
         sales_qty_      := Business_Opportunity_Line_API.Get_Qty(usage_ref1_, usage_ref3_, usage_ref2_);
         sales_uom_      := Sales_Part_API.Get_Sales_Unit_Meas(contract_tmp_,catalog_no_tmp_);
      $ELSE
         NULL;
      $END
   END IF;

   sales_group_ := Sales_Part_API.Get_Catalog_Group(contract_tmp_, catalog_no_tmp_);
   catalog_no_  := catalog_no_tmp_;
   contract_    := contract_tmp_;   
END Get_Order_Info;


FUNCTION Is_Allow_Create_Config_Order(
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   family_id_ VARCHAR2(200);
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      family_id_ := Config_Part_Catalog_API.Get_Config_Family_Id(part_no_);
      RETURN Config_Family_API.Get_Allow_Partial_Config_Quat(family_id_);
   $END
   
   RETURN 0;
END Is_Allow_Create_Config_Order;


-- Get_Config_Spec_Objstate
--   Fetches the configuration spec objstate for a given part no and a configuration id.
@UncheckedAccess
FUNCTION Get_Config_Spec_Objstate (
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS 
BEGIN
   IF (configuration_id_ != '*') THEN
      $IF Component_Cfgchr_SYS.INSTALLED $THEN
         RETURN Configuration_Spec_API.Get_Objstate(part_no_, configuration_id_);
      $ELSE
         NULL;
      $END
   END IF;

   RETURN 'Incomplete';
END Get_Config_Spec_Objstate;


-- Get_Edit_Config_Info
--  Returns the information required to check if the configuration changes are allowed
--  for a customer order line.
PROCEDURE Get_Edit_Config_Info (
   internal_co_no_            OUT VARCHAR2,
   internal_co_line_state_    OUT VARCHAR2,
   po_line_state_             OUT VARCHAR2,
   transfer_config_           OUT VARCHAR2,
   internal_config_id_        OUT VARCHAR2,   
   order_no_                  IN  VARCHAR2,
   line_no_                   IN  VARCHAR2,
   release_no_                IN  VARCHAR2,
   line_item_no_              IN  NUMBER,
   supply_code_               IN  VARCHAR2 )
IS
    po_order_no_          VARCHAR2(12);
    po_line_no_           VARCHAR2(4);
    po_rel_no_            VARCHAR2(4);
    purchase_type_        VARCHAR2(20);    
    internal_co_line_no_  VARCHAR2(20);
    internal_co_rel_no_   VARCHAR2(20);
    internal_co_item_no_  VARCHAR2(20);
    contract_             VARCHAR2(100);
    vendor_no_            VARCHAR2(20);
    part_no_              VARCHAR2(25);
    internal_supply_code_ VARCHAR2(3);
    pegged_identity1_     VARCHAR2(12);
    pegged_identity2_     VARCHAR2(4);
    pegged_identity3_     VARCHAR2(4);
    pegged_purchase_type_ VARCHAR2(20);
BEGIN
   Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_ , po_line_no_ , po_rel_no_ , purchase_type_ , order_no_, line_no_, release_no_, line_item_no_);
   $IF Component_Purch_SYS.INSTALLED $THEN
      po_line_state_ := Purchase_Order_Line_API.Get_Objstate(po_order_no_, po_line_no_, po_rel_no_);
   $ELSE
      NULL;
   $END  
   IF (po_line_state_ IN ('Released', 'Confirmed')) THEN
      Customer_Order_Line_API.Get_Custord_From_Demand_Info(internal_co_no_, internal_co_line_no_, internal_co_rel_no_, internal_co_item_no_, po_order_no_, po_line_no_, po_rel_no_, NULL, Order_Supply_Type_API.Encode(supply_code_));
      internal_co_line_state_ := Customer_Order_Line_API.Get_Objstate(internal_co_no_, internal_co_line_no_, internal_co_rel_no_, internal_co_item_no_);
      vendor_no_ := Customer_Order_Line_API.Get_Vendor_No(order_no_, line_no_, release_no_, line_item_no_);
      contract_  := Customer_Order_Line_API.Get_Contract(order_no_, line_no_, release_no_, line_item_no_);
      part_no_   := Customer_Order_Line_API.Get_Purchase_Part_No(order_no_, line_no_, release_no_, line_item_no_);
      $IF Component_Purch_SYS.INSTALLED $THEN
         transfer_config_ := Supply_Configuration_API.Encode(Purchase_Part_Supplier_API.Get_Supply_Configuration (contract_, part_no_, vendor_no_));
      $ELSE
         NULL;      
      $END     
      internal_config_id_ := Customer_Order_Line_API.Get_Configuration_Id(internal_co_no_, internal_co_line_no_, internal_co_rel_no_, internal_co_item_no_);
      internal_supply_code_ := Order_Supply_Type_API.Encode(Customer_Order_Line_API.Get_Supply_Code(internal_co_no_, internal_co_line_no_, internal_co_rel_no_, internal_co_item_no_));
      IF (internal_supply_code_ = 'SO') THEN
         Customer_Order_Shop_Order_API.Get_Shop_Order(pegged_identity1_, pegged_identity2_, pegged_identity3_, internal_co_no_, internal_co_line_no_, internal_co_rel_no_, internal_co_item_no_);
         $IF Component_Shpord_SYS.INSTALLED $THEN
            IF (Shop_Ord_API.Get_State_Db(pegged_identity1_, pegged_identity2_, pegged_identity3_) NOT IN ('Planned', 'Reserved', 'Released')) THEN
               Error_SYS.Record_General(lu_name_, 'NOCHGCONFIG: Configuration ID change is not allowed since the supply site shop order is in Started status');
            END IF;
         $ELSE
            NULL;         
         $END    
      ELSIF ((internal_supply_code_ IN ('IPD', 'IPT')) AND 
          (Customer_Order_Pur_Order_API.Connected_Orders_Found(internal_co_no_, internal_co_line_no_, internal_co_rel_no_, internal_co_item_no_) = 1)) THEN
         Error_SYS.Record_General(lu_name_, 'INTPONOTUPDATED: Editing the configuration is not allowed since the customer order in supply site is connected to a purchase order and released with multi-site supply options.');
      ELSIF ((internal_supply_code_ IN ('PD', 'PT') AND (internal_co_line_state_ != 'Reserved')) AND 
            (Customer_Order_Pur_Order_API.Connected_Orders_Found(internal_co_no_, internal_co_line_no_, internal_co_rel_no_, internal_co_item_no_) = 1)) THEN       
         Customer_Order_Pur_Order_API.Get_Purord_For_Custord(pegged_identity1_, pegged_identity2_, pegged_identity3_, pegged_purchase_type_,
                                            internal_co_no_, internal_co_line_no_, internal_co_rel_no_, internal_co_item_no_);
         $IF Component_Purch_SYS.INSTALLED $THEN
            IF ((Purchase_Type_API.Encode(pegged_purchase_type_) = 'O') AND ((Purchase_Order_Line_API.Get_Objstate(pegged_identity1_, pegged_identity2_, pegged_identity3_) != 'Released')))THEN
               Error_SYS.Record_General(lu_name_, 'STOPEDITINTPO: Editing the configuration is not allowed since the customer order in supply site is connected to a purchase order which is in a status beyond  Released or Confirmed.'); 
            END IF;
         $ELSE
            NULL;           
         $END 
      END IF;
   END IF;   
END Get_Edit_Config_Info;

-- Check_Cust_Ord_Config_Mismatch
--  Checks whether there is a mismatch between the configurations in the customer orders
--  created in the demand site and the supply site.
--  Input order_no of the internal customer order.
@UncheckedAccess
FUNCTION Check_Cust_Ord_Config_Mismatch (
   order_no_ IN VARCHAR2) RETURN VARCHAR2
IS
   has_config_mismatch_  VARCHAR2(5) := 'FALSE';   
   CURSOR get_demand_info IS
      SELECT order_no, line_no, rel_no, line_item_no
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    demand_code IN ('IPD', 'IPT', 'IPT_RO')
      AND    configuration_id != '*'
      AND    rowstate != 'Cancelled'; 
BEGIN
   FOR co_line_rec_ IN get_demand_info LOOP
      has_config_mismatch_ := Check_Ord_Line_Config_Mismatch(co_line_rec_.order_no, co_line_rec_.line_no, co_line_rec_.rel_no, co_line_rec_.line_item_no);
      IF (has_config_mismatch_ = 'TRUE') THEN
         EXIT;
      END IF;
   END LOOP; 
   RETURN has_config_mismatch_;
END Check_Cust_Ord_Config_Mismatch;

-- Check_Ord_Line_Config_Mismatch
--  Checks whether there is a mismatch between the configurations in the customer order
--  lines created in the demand site and the supply site.
--  Input order_no, line_no, rel_no and line_item_no of the internal customer order.
@UncheckedAccess
FUNCTION Check_Ord_Line_Config_Mismatch (
   order_no_      IN  VARCHAR2,
   line_no_       IN  VARCHAR2,
   rel_no_        IN  VARCHAR2,
   line_item_no_  IN  VARCHAR2 ) RETURN VARCHAR2
IS
   has_line_config_mismatch_ VARCHAR2(5) := 'FALSE';
   demand_order_ref1_      VARCHAR2(15);
   demand_order_ref2_      VARCHAR2(10);
   demand_order_ref3_      VARCHAR2(4);
   eo_order_no_            VARCHAR2(12);
   eo_line_no_             VARCHAR2(4);
   eo_rel_no_              VARCHAR2(4);
   eo_line_item_no_        VARCHAR2(4);
   configuration_id_       VARCHAR2(50);   
   demand_code_db_         VARCHAR2(20);
   demand_dop_id_          VARCHAR2(12);
   demand_dop_order_id_    NUMBER;
   part_no_                VARCHAR2(50);
   item_no_                NUMBER;
   
   CURSOR get_demand_info IS
      SELECT demand_order_ref1, demand_order_ref2, demand_order_ref3, configuration_id, part_no
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no    = line_no_
      AND    rel_no     = rel_no_
      AND    line_item_no = line_item_no_
      AND    demand_code IN ('IPD', 'IPT', 'IPT_RO')
      AND    configuration_id != '*';   
BEGIN
   OPEN get_demand_info;
   FETCH get_demand_info INTO demand_order_ref1_, demand_order_ref2_, demand_order_ref3_, configuration_id_, part_no_;
   CLOSE get_demand_info;

   IF Part_Catalog_API.Get_Configurable_Db(part_no_) = 'CONFIGURED' THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         demand_code_db_ := Purchase_Order_Line_Part_API.Get_Demand_Code_Db(demand_order_ref1_, demand_order_ref2_, demand_order_ref3_);
      $ELSE
         NULL;
      $END

      IF demand_code_db_ = 'DOP' THEN
         $IF Component_Dop_SYS.INSTALLED $THEN         
            Dop_Supply_Purch_Ord_API.Select_Demand_For_Supply(demand_dop_id_, demand_dop_order_id_, demand_order_ref1_, demand_order_ref2_, demand_order_ref3_);
            IF (Dop_Order_API.Get_Configuration_Id(demand_dop_id_, demand_dop_order_id_) != configuration_id_) THEN
               has_line_config_mismatch_  := 'TRUE';
            END IF;
         $ELSE
            NULL;
         $END
      ELSIF demand_code_db_ = 'PJD' THEN
         $IF Component_Prjdel_SYS.INSTALLED $THEN
            item_no_ := Planning_Procured_API.Get_Item_No_By_Po(demand_order_ref1_, demand_order_ref2_, demand_order_ref3_);            
            -- item_revision_ is R1
            IF (Delivery_Structure_API.Get_Configuration_Id(item_no_, 'R1') != configuration_id_) THEN
               has_line_config_mismatch_  := 'TRUE';
            END IF;
         $ELSE
            NULL;
         $END
      ELSE
         Customer_Order_Pur_Order_API.Get_Custord_For_Purord(eo_order_no_, eo_line_no_, eo_rel_no_, eo_line_item_no_, demand_order_ref1_, demand_order_ref2_, demand_order_ref3_);
         part_no_ := Customer_Order_Line_API.Get_Part_No(eo_order_no_, eo_line_no_, eo_rel_no_, eo_line_item_no_);
         IF Part_Catalog_API.Get_Configurable_Db(part_no_) = 'CONFIGURED' THEN
            IF (Customer_Order_Line_API.Get_Configuration_Id(eo_order_no_, eo_line_no_, eo_rel_no_, eo_line_item_no_) != configuration_id_) THEN
               has_line_config_mismatch_  := 'TRUE';
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN has_line_config_mismatch_;
END Check_Ord_Line_Config_Mismatch;

PROCEDURE Replace_Order_Line (
   info_                 OUT VARCHAR2,
   order_no_             IN  VARCHAR2,
   line_no_              IN  VARCHAR2,
   rel_no_               IN  VARCHAR2,
   line_item_no_         IN  NUMBER,
   shipment_id_          IN  NUMBER,
   contract_             IN  VARCHAR2,
   catalog_no_           IN  VARCHAR2,
   buy_qty_due_          IN  NUMBER,
   wanted_delivery_date_ IN  DATE,
   make_reservation_     IN  VARCHAR2 )
IS 
   attr_             VARCHAR2(4000);
   new_line_no_      VARCHAR2(4);
   new_rel_no_       VARCHAR2(4);
   new_line_item_no_ NUMBER;
   qty_reserved_     NUMBER;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ORDER_NO',             order_no_,             attr_);
   Client_SYS.Add_To_Attr('CONTRACT',             contract_,             attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO',           catalog_no_,           attr_);
   Client_SYS.Add_To_Attr('BUY_QTY_DUE',          buy_qty_due_,          attr_);
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', wanted_delivery_date_, attr_);
   Customer_Order_Line_API.New(info_, attr_);
   
   Customer_Order_Line_API.Remove(order_no_, line_no_, rel_no_, line_item_no_);
   
   new_line_no_      := Client_Sys.Get_Item_Value('LINE_NO',      attr_);
   new_rel_no_       := Client_Sys.Get_Item_Value('REL_NO',       attr_);
   new_line_item_no_ := Client_Sys.Get_Item_Value('LINE_ITEM_NO', attr_);
   
   IF (NVL(make_reservation_, 'FALSE') = 'TRUE') THEN
      Reserve_Customer_Order_API.Reserve_Order_Line__(qty_reserved_       => qty_reserved_,
                                                      order_no_           => order_no_, 
                                                      line_no_            => new_line_no_, 
                                                      rel_no_             => new_rel_no_, 
                                                      line_item_no_       => new_line_item_no_, 
                                                      qty_to_be_reserved_ => buy_qty_due_, 
                                                      shipment_id_        => shipment_id_);
   END IF;
   
END Replace_Order_Line;

PROCEDURE Replace_Quotation_Line (
   info_           OUT VARCHAR2,
   quotation_no_   IN  VARCHAR2,
   line_no_        IN  VARCHAR2,
   rel_no_         IN  VARCHAR2,
   line_item_no_   IN  NUMBER, 
   contract_       IN  VARCHAR2,
   catalog_no_     IN  VARCHAR2,
   buy_qty_due_    IN  NUMBER,
   desired_qty_    IN  NUMBER )
IS 
   attr_             VARCHAR2(4000);
   new_line_no_      NUMBER;
   new_rel_no_       VARCHAR2(500);
   new_line_item_no_ NUMBER;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QUOTATION_NO', quotation_no_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT',     contract_,     attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO',   catalog_no_,   attr_);
   Client_SYS.Add_To_Attr('BUY_QTY_DUE',  buy_qty_due_,  attr_);
   Client_SYS.Add_To_Attr('DESIRED_QTY',  desired_qty_,  attr_);
   Order_Quotation_Line_API.New(info_, attr_);
   new_line_no_      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   new_rel_no_       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   new_line_item_no_ := Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_);

   -- IF the existing line is in Released state, set the new line status to Released.
   IF Order_Quotation_Line_API.Get_Objstate(quotation_no_, line_no_, rel_no_, line_item_no_) = 'Released' THEN
      Order_Quotation_Line_API.Set_Released(quotation_no_, new_line_no_, new_rel_no_, new_line_item_no_);
   END IF;
   Order_Quotation_Line_API.Remove(quotation_no_, line_no_, rel_no_, line_item_no_, 'TRUE');

END Replace_Quotation_Line;

