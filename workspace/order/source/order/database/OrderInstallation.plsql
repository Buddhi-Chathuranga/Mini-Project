-----------------------------------------------------------------------------
--
--  Logical unit: OrderInstallation
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220105  Inaklk  SC21R2-7011, Modified Register_Cash_Plan_Info___ to change source refs for customer order invoice sub source, corrected luname
--  211025  Inaklk  SC21R2-5278,Added Register_Cash_Plan_Info___ to register customer order basic data for cash plan
--  201009  OsAllk  SC2020R1-10455, Replaced Database_SYS.Component_Exist with Component_Active to check component ACTIVE/INACTIVE.
--  190108  NiDalk  Bug 146184(SCZ-2464), Re-written Reg_Obj_Con_Lu_Transform___ to check if lu has different lu registered as editable.
--  181203  NiDalk  Bug 145626(SCZCRM-275), Modified Reg_Obj_Con_Lu_Transform___ to add object connection transformation to BusinessOpportunityLine.
--  160629  TiRalk  STRSC-2702, Changed the places where it has used CreditBlocked from CustomerOrder has changed to state Blocked.
--  141017  DipeLK  PRFI-2878, Changes for Handling Discounts
--  141009  NaLrlk  Removed Post_Installation_Object method.
--  140929  RoJalk  Modified EXT_CUST_ORDER_LINE_CHANGE_ALL and added shipment_type.
--  140922  DipeLK  PRFI-671, Made the method Register_Cash_Flow_Info___ compatible for basic data translation in FINCFA
--  140821  ChFolk  Replaced the usages of object_status with type_status.
--  140703  ChFolk  Added new method Register_Cash_Flow_Info___ which register ORDER cash flow information and used in Post_Installation_Data.
--  140421  BudKlk  Bug 116395, Added conditional compilation to register LU connection transformations.
--  140318  NaSalk  Added primary_rental_no to CUSTOMER_ORDER_RENTAL_LINE.
--  140227  NaLrlk  Created.  
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Insert_Post_Ctrl_Comb___
IS      
BEGIN
   -- postings for COST components  
   IF (Database_SYS.Component_Active('COST')) THEN
      Posting_Ctrl_API.Insert_Allowed_Comb('M24', 'C91', 'COST', '*');
      Posting_Ctrl_API.Insert_Allowed_Comb('M25', 'C91', 'COST', '*');
      Posting_Ctrl_API.Insert_Allowed_Comb('M77', 'C91', 'COST', '*');
      Posting_Ctrl_API.Insert_Allowed_Comb('M190', 'C91', 'COST', '*');
      Posting_Ctrl_API.Insert_Allowed_Comb('M194', 'C91', 'COST', '*');
   END IF;
END Insert_Post_Ctrl_Comb___;

PROCEDURE Reg_Obj_Con_Lu_Transform___
IS 
   editable_lu_name_ OBJ_CONNECT_LU_TRANSFORM_TAB.target_lu_name%TYPE := NULL;
   err_text_         VARCHAR2(200);
BEGIN
   err_text_ := 'CANNNOTREGOBJTRANS: Cannot register object connection tranformations for '':P1'' as '':P2'' is already registered as editable LU for it.';
   editable_lu_name_ := Obj_Connect_Lu_Transform_API.Get_Editable_Lu_Name('CustomerOrderLine', 'DocReferenceObject');
   
   IF editable_lu_name_ IS NULL OR UPPER(editable_lu_name_) = UPPER('CustomerOrderLine') THEN 
      IF Installation_SYS.Get_Installation_Mode = FALSE OR Module_API.Is_Included_In_Delivery('ORDER') OR Module_API.Is_Included_In_Delivery('MFGSTD') THEN
         $IF Component_Mfgstd_SYS.INSTALLED $THEN 
            Obj_Connect_Lu_Transform_API.Register('CustomerOrderLine','PartRevision','DocReferenceObject','TARGET','SALES_OBJECT_TRANSFORM_API.TRANSF_ORD_LINE_TO_PART_REV');
         $ELSE
            NULL;
         $END
      END IF;
      
      IF Installation_SYS.Get_Installation_Mode = FALSE OR Module_API.Is_Included_In_Delivery('ORDER') OR Module_API.Is_Included_In_Delivery('PDMCON') THEN
         $IF Component_Pdmcon_SYS.INSTALLED $THEN
            Obj_Connect_Lu_Transform_API.Register('CustomerOrderLine','EngPartRevision','DocReferenceObject','TARGET','SALES_OBJECT_TRANSFORM_API.TRANSF_ORD_LINE_TO_ENG_PART_RV');
          $ELSE
            NULL;   
         $END
      END IF;
      
      IF Installation_SYS.Get_Installation_Mode = FALSE OR Module_API.Is_Included_In_Delivery('ORDER') OR Module_API.Is_Included_In_Delivery('CRM') THEN
         $IF Component_Crm_SYS.INSTALLED $THEN
            Obj_Connect_Lu_Transform_API.Register('CustomerOrderLine','BusinessOpportunityLine','DocReferenceObject','TARGET','SALES_OBJECT_TRANSFORM_API.TRANSF_ORDER_LINE_TO_OPP_LINE');
         $ELSE
            NULL;   
         $END
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, err_text_, 'CustomerOrderLine', editable_lu_name_);
   END IF;
   
   editable_lu_name_ := NULL;
   editable_lu_name_ := Obj_Connect_Lu_Transform_API.Get_Editable_Lu_Name('SalesPart', 'DocReferenceObject');
   
   IF editable_lu_name_ IS NULL OR UPPER(editable_lu_name_) = UPPER('SalesPart') THEN 
      IF Installation_SYS.Get_Installation_Mode = FALSE OR Module_API.Is_Included_In_Delivery('ORDER') OR Module_API.Is_Included_In_Delivery('MFGSTD') THEN
         $IF Component_Mfgstd_SYS.INSTALLED $THEN 
            Obj_Connect_Lu_Transform_API.Register('SalesPart','PartRevision','DocReferenceObject','TARGET','SALES_OBJECT_TRANSFORM_API.TRANSF_SALES_PART_TO_PART_REV');
         $ELSE
            NULL;   
         $END
      END IF;
      
      IF Installation_SYS.Get_Installation_Mode = FALSE OR Module_API.Is_Included_In_Delivery('ORDER') OR Module_API.Is_Included_In_Delivery('PDMCON') THEN
         $IF Component_Pdmcon_SYS.INSTALLED $THEN
            Obj_Connect_Lu_Transform_API.Register('SalesPart','EngPartRevision','DocReferenceObject','TARGET','SALES_OBJECT_TRANSFORM_API.TRANSF_SALES_TO_ENG_PART_REV');
         $ELSE
            NULL;   
         $END
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, err_text_, 'SalesPart', editable_lu_name_);
      editable_lu_name_ := NULL;
   END IF;
   
   editable_lu_name_ := NULL;
   editable_lu_name_ := Obj_Connect_Lu_Transform_API.Get_Editable_Lu_Name('OrderQuotationLine', 'DocReferenceObject');
   
   IF editable_lu_name_ IS NULL OR UPPER(editable_lu_name_) = UPPER('OrderQuotationLine') THEN
      IF Installation_SYS.Get_Installation_Mode = FALSE OR Module_API.Is_Included_In_Delivery('ORDER') OR Module_API.Is_Included_In_Delivery('CRM') THEN
         $IF Component_Crm_SYS.INSTALLED $THEN
            Obj_Connect_Lu_Transform_API.Register('OrderQuotationLine','BusinessOpportunityLine','DocReferenceObject','TARGET','SALES_OBJECT_TRANSFORM_API.TRANSF_QUOTE_LINE_TO_OPP_LINE');
         $ELSE
            NULL;   
         $END
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, err_text_, 'OrderQuotationLine', editable_lu_name_);
      editable_lu_name_ := NULL;
   END IF;
END Reg_Obj_Con_Lu_Transform___;

PROCEDURE Register_Cash_Flow_Info___
IS  
   source_id_           VARCHAR2(30) := 'CUSTOMER ORDER';
   cash_flow_type_id_   VARCHAR2(30) := 'IFS_CUSTORD';
   module_              VARCHAR2(25) := 'ORDER';
   logical_unit_        VARCHAR2(25) := 'CustomerOrderCashFlow';
   type_status_msg_     VARCHAR2(32000);
   attr_                VARCHAR2(32000);
BEGIN
   $IF (Component_Fincfa_SYS.INSTALLED) $THEN
      Cfa_Update_Utility_API.Register_Cfa_Source(module_,
                                                 logical_unit_,
                                                 source_id_,
                                                 'Input from IFS Customer Order',
                                                 'CUSTOMER_ORDER_CASH_FLOW_API.Create_Cfa_Cash_Flow_Data',
                                                 'TRUE',
                                                 '1',
                                                 'TRUE',
                                                 'FALSE',
                                                 'FALSE');
        
      Cfa_Update_Utility_API.Register_Cfa_Cash_Flow_Type(module_,
                                                         logical_unit_,
                                                         source_id_, 
                                                         cash_flow_type_id_, 
                                                         'Customer Order', 
                                                         'TRUE');
                                                         
    
      Client_SYS.Clear_Attr(attr_);
      type_status_msg_ := Message_SYS.Construct('TYPE_STATUS_MSG');
      Message_SYS.Add_Attribute(type_status_msg_, 'Released', 3);
      Message_SYS.Add_Attribute(type_status_msg_, 'Reserved', 3);
      Message_SYS.Add_Attribute(type_status_msg_, 'Picked', 3);
      Message_SYS.Add_Attribute(type_status_msg_, 'PartiallyDelivered', 2);
      Message_SYS.Add_Attribute(type_status_msg_, 'Delivered', 2);
      Message_SYS.Add_Attribute(type_status_msg_, 'Invoiced', 2);
      Message_SYS.Add_Attribute(type_status_msg_, 'Planned', 3);
      Message_SYS.Add_Attribute(type_status_msg_, 'Blocked', 3);
      Client_SYS.Add_To_Attr('TYPE_STATUS_MSG', type_status_msg_, attr_);
      Cfa_Update_Utility_API.Register_Cfa_Type_Status(module_, logical_unit_, source_id_, cash_flow_type_id_, attr_);
   $ELSE
      NULL;
   $END
END Register_Cash_Flow_Info___;
   

PROCEDURE Register_Cash_Plan_Info___
IS   
   $IF Component_Cshpln_SYS.INSTALLED $THEN
      module_                    cash_plan_source_tab.module%TYPE;
      cash_plan_function_        cash_plan_function_tab.cash_plan_function%TYPE;
      source_id_                 cash_plan_source_tab.source_id%TYPE;
      sub_source_id_             cash_plan_sub_source_tab.sub_source_id%TYPE;
      logical_unit_              cash_plan_source_tab.logical_unit%TYPE;
   $END
BEGIN
   $IF Component_Cshpln_SYS.INSTALLED $THEN
      IF (Installation_SYS.Get_Installation_Mode = FALSE OR Module_API.Is_Included_In_Delivery('ORDER') OR Module_API.Is_Included_In_Delivery('CSHPLN')) THEN   
         module_                 := 'ORDER';
         logical_unit_           := 'CustomerOrderCashPlan';
         cash_plan_function_     := 'CUSTOMER_ORDER';
         source_id_              := 'CUSTOMER ORDER';

         Cash_Plan_Utility_API.Register_Cash_Plan_Function(module_, logical_unit_, cash_plan_function_, 'Customer Order');

         Cash_Plan_Utility_API.Register_Cash_Plan_Source(module_, 
                                                         logical_unit_, 
                                                         source_id_, 
                                                         'Input from Customer Order', 
                                                         'Customer_Order_Cash_Plan_API.Create_Cshpln_Cash_Flow_Data',
                                                         cash_plan_function_);


         sub_source_id_             := 'CUSTOMER_ORDER';
         Cash_Plan_Utility_API.Register_Cash_Plan_Sub_Source(module_, 
                                                             logical_unit_, 
                                                             source_id_, 
                                                             sub_source_id_, 
                                                             'Customer Order', 
                                                             Cash_Flow_In_Out_API.DB_IN,
                                                             'CUSTOMER',
                                                             'CustomerOrder/Form', 
                                                             'OrderNo', 
                                                             NULL, 
                                                             NULL, 
                                                             NULL, 
                                                             NULL, 
                                                             'FALSE', 
                                                             'STRING',  
                                                             NULL, 
                                                             NULL, 
                                                             NULL, 
                                                             NULL);

         Cash_Plan_Utility_API.Register_Sub_Source_Status(module_, 
                                                          logical_unit_, 
                                                          source_id_, 
                                                          sub_source_id_, 
                                                          'PLANNED', 
                                                          3, 
                                                          'Planned Customer Order');  

         Cash_Plan_Utility_API.Register_Sub_Source_Status(module_, 
                                                          logical_unit_, 
                                                          source_id_, 
                                                          sub_source_id_, 
                                                          'RELEASED', 
                                                          3, 
                                                          'Released Customer Order');  

         Cash_Plan_Utility_API.Register_Sub_Source_Status(module_, 
                                                          logical_unit_, 
                                                          source_id_, 
                                                          sub_source_id_, 
                                                          'RESERVED', 
                                                          3, 
                                                          'Reserved Customer Order');

         Cash_Plan_Utility_API.Register_Sub_Source_Status(module_, 
                                                          logical_unit_, 
                                                          source_id_, 
                                                          sub_source_id_, 
                                                          'PICKED', 
                                                          3, 
                                                          'Picked Customer Order');   

         Cash_Plan_Utility_API.Register_Sub_Source_Status(module_, 
                                                             logical_unit_, 
                                                             source_id_, 
                                                             sub_source_id_, 
                                                             'PARTIALLY_DELIVERED', 
                                                             2, 
                                                             'Partially Delivered Customer Order');

         Cash_Plan_Utility_API.Register_Sub_Source_Status(module_, 
                                                             logical_unit_, 
                                                             source_id_, 
                                                             sub_source_id_, 
                                                             'DELIVERED', 
                                                             2, 
                                                             'Delivered Customer Order'); 

         Cash_Plan_Utility_API.Register_Sub_Source_Status(module_, 
                                                             logical_unit_, 
                                                             source_id_, 
                                                             sub_source_id_, 
                                                             'BLOCKED', 
                                                             3, 
                                                             'Blocked Customer Order'); 

         --register customer order invoice as sub source and register status and probabilities
         sub_source_id_ := 'CUSTOMER_ORDER_INVOICE';
         Cash_Plan_Utility_API.Register_Cash_Plan_Sub_Source(module_, 
                                                             logical_unit_, 
                                                             source_id_, 
                                                             sub_source_id_, 
                                                             'Customer Order Invoice',
                                                             Cash_Flow_In_Out_API.DB_IN,
                                                             'CUSTOMER',
                                                             'CustomerOrderInvoice/Form', 
                                                             'InvoiceId', 
                                                             NULL,
                                                             NULL, 
                                                             NULL, 
                                                             NULL, 
                                                             'TRUE',  
                                                             'NUMBER', 
                                                             NULL,
                                                             NULL, 
                                                             NULL, 
                                                             NULL); 

         Cash_Plan_Utility_API.Register_Sub_Source_Status(module_, 
                                                             logical_unit_, 
                                                             source_id_, 
                                                             sub_source_id_, 
                                                             'INVOICED', 
                                                             2, 
                                                             'Invoiced Customer Order');     
      END IF;                                                       
   $ELSE
      NULL;
   $END
END Register_Cash_Plan_Info___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Post_Installation_Data
IS
BEGIN
   -- Create all posting control enties for dynamic modules.
   IF Installation_SYS.Get_Installation_Mode = FALSE OR Module_API.Is_Included_In_Delivery('ORDER') OR Module_API.Is_Included_In_Delivery('COST') THEN
      Insert_Post_Ctrl_Comb___();
   END IF;
   -- Register Object LU Connection Transformation for dynamic modules.
   Reg_Obj_Con_Lu_Transform___();

   -- Register Cash Flow Information.
   IF Installation_SYS.Get_Installation_Mode = FALSE OR Module_API.Is_Included_In_Delivery('ORDER') OR Module_API.Is_Included_In_Delivery('FINCFA') THEN
      Register_Cash_Flow_Info___();
   END IF;
   
   -- Create basic data for all Order sources in cash plan
   Register_Cash_plan_Info___();
END Post_Installation_Data;
