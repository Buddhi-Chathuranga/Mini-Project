-----------------------------------------------------------------------------
--
--  Filename      : POST_Invent_DynamicViews.sql
--
--  Module        : INVENT
--
--  Purpose       : Creating dynamically dependent views for INVENT module.
--
--  Note          : This Script is run automatically during the installation.
--
--
--  Date    Sign   History
--  ------  ------ ----------------------------------------------------------
--  170509  HaPulk STRSC-2065, Exclude view OPEN_PROJECT_SITE since Dummy interface is created inside INVENT.
--  161020  SWeelk STRSC-2065, Modified the script to drop all the dummy views created in INVENT component when the component of the
--  161020         original view is not installed. Dummy view 'PM_MATR_DEMAND_EXT' handled separately since its comments are not defined.
--  160406  DilMlk Bug 127386, Moved INVENTORY_PART_LOV_MRP creation to InventoryPart.views. Modified this script to remove
--  160406         PURCHASE_PART_LOV6 when PURCH is not installed.
--  140312  MaEdlk Bug 115687, Changed the string length of supply_code column comment in INVENTORY_PART_LOV_MRP from 20 to 200.
--  140207  AwWelk Created and added INVENTORY_PART_LOV_MRP view since this is dependent on PURCHASE_PART_LOV6
--  140207         view in PURCH module.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DynamicViews.sql','Timestamp_1');
PROMPT Starting POST_Invent_DynamicViews.sql

DECLARE
   table_name_    FND_tab_comments.table_name%TYPE;
   CURSOR get_table_name IS
		SELECT table_name
		FROM FND_tab_comments
      WHERE (
               (table_name IN ('SHOP_MATERIAL_ASSIGN_RES', 'CUSTOMER_ORDER_RES', 'PURCHASE_PART_LOV6',
                        		'SOURCED_CO_SUPPLY_SITE_RES', 'CO_SUPPLY_SITE_RESERVATION', 'PURCHASE_ORDER_RESERVATION',
                              'SUPPLIER_SHIPMENT_RESERVATION', 'DOP_INVENT_ASSIGN_EXT_RES', 'DOP_INVENT_ASSIGN_INT_RES',
                              'MAINT_MATERIAL_ALLOCATION', 'INTERIM_ORD_INV_ASSIGN_RES', 'MTRL_TRANSFER_REQ_RESERVATION',
         							'CRO_RESERVATION_RES', 'CRO_EXCHANGE_RESERVATION','MAINT_ORDER_MATR_SHORTAGE',
                  				'PLANT_RESERVED_MATERIAL', 'PROJECT_RESERVED_MATERIAL_RES', 'SHOP_MATERIAL_ALLOC_DEMAND',
                           	'SHOP_ORD_SUPPLY', 'SHOP_ORDER_PROP_SUPPLY', 'CUSTOMER_ORDER_LINE_DEMAND',
         							'SALES_QUOTATION_LINE_DEMAND', 'SOURCED_ORDER_LINE_DEMAND', 'PURCHASE_ORDER_RES_DEMAND',
                  				'PURCHASE_ORDER_LINE_SUPPLY', 'PURCHASE_REQUIS_LINE_SUPPLY', 'ARRIVED_PUR_ORDER_SUPPLY',
                           	'PUR_ORD_CHARGED_COMP_DEMAND', 'WO_ORDER_LINE_DEMAND', 'WO_ORDER_REPAIR_DEMAND',
                              'LINE_SCHED_COMP_DEMAND', 'LINE_SCHED_SUPPLY', 'PROJECT_DELIVERY_DEMAND',
                              'DIST_ORDER_SUPPLY_DEMAND', 'PROJECT_MISC_PROC_DEMAND', 'MAINT_ORDER_MATR_DEMAND',
                  				'SHOP_MATERIAL_ALLOC_DEMAND_OE', 'SHOP_ORD_SUPPLY_OE', 'CUSTOMER_ORDER_LINE_DEMAND_OE',
                  				'SALES_QUOTATION_LINE_DEMAND_OE', 'SOURCED_ORDER_LINE_DEMAND_OE', 'PURCHASE_ORDER_RES_DEMAND_OE',
                  				'PURCHASE_ORDER_LINE_SUPPLY_OE', 'PURCHASE_REQUIS_LINE_SUPPLY_OE', 'ARRIVED_PUR_ORDER_SUPPLY_OE',
                  				'PUR_ORD_CHARGED_COMP_DEMAND_OE', 'WO_ORDER_LINE_DEMAND_OE', 'WO_ORDER_REPAIR_DEMAND_OE',
                  				'LINE_SCHED_COMP_DEMAND_OE', 'LINE_SCHED_SUPPLY_OE', 'DIST_ORDER_SUPPLY_DEMAND_OE',
                  				'INTERIM_ORDER_SUPPLY_OE', 'INTERIM_ORDER_DEMAND_OE', 'MAINT_ORDER_MATR_DEMAND_OE',
                  				'CUSTOMER_ORDER_LINE_MS', 'SALES_QUOTATION_LINE_MS', 'SOURCED_ORDER_LINE_MS',
                  				'PURCHASE_ORDER_LINE_MS', 'PURCHASE_ORDER_RES_MS', 'PURCHASE_REQUIS_LINE_MS',
                     			'ARRIVED_PUR_ORDER_MS', 'PUR_ORD_CHARGED_COMP_DEMAND_MS', 'SHOP_ORDER_MS',
                     			'SHOP_ORDER_PROP_MS', 'SHOP_MATERIAL_ALLOC_MS', 'DIST_ORDER_SUPPLY_DEMAND_MS',
                     			'WO_ORDER_LINE_MS', 'WO_ORDER_REPAIR_MS', 'MRP_PART_SUPPLY_DEMAND_MS',
                  				'LINE_SCHED_COMP_MS', 'LINE_SCHED_MS', 'UNRELEASED_DOP_MS', 'SHOP_MATERIAL_ALLOC_SHORTAGE',
                  				'COMPATIBLE_UNIT_DEMAND_MS', 'MAINT_ORDER_MATR_DEMAND_MS', 'SHOP_MATERIAL_ALLOC_EXT',
                  				'SHOP_ORDER_EXT', 'SHOP_ORDER_PROP_EXT', 'CUSTOMER_ORDER_LINE_EXT',
                  				'SALES_QUOTATION_LINE_EXT', 'SOURCED_ORDER_LINE_EXT', 'PURCHASE_ORDER_LINE_EXT',
                  				'PURCHASE_ORDER_RES_EXT', 'PURCHASE_REQUIS_LINE_EXT', 'ARRIVED_PUR_ORDER_EXT',
                  				'PUR_ORD_CHARGED_COMP_DEMAND_XT', 'WO_ORDER_LINE_EXT', 'WO_ORDER_REPAIR_EXT',
               					'MRP_PART_SUPPLY_DEMAND_EXT', 'SPARE_PART_FORECAST_EXT', 'LEVEL_1_FORECAST_EXT',
               					'DOP_ORDER_DEMAND_EXT', 'DOP_ORDER_SUPPLY_EXT', 'LINE_SCHED_COMP_EXT', 'CUSTOMER_ORDER_LINE_SHORTAGE',
               					'LINE_SCHED_EXT', 'CUST_SCHED_PLAN_DEMAND_EXT', 'PROJECT_DELIVERY_DEMAND_EXT',
            						'SUPP_SCHED_PLAN_DEMAND_EXT', 'DIST_ORDER_SUPPLY_DEMAND_EXT',
            						'PROJECT_MISC_PROC_DEMAND_EXT', 'PMRP_MTR_DEMAND_EXT', 'MATERIAL_TRANS_REQUISITION_EXT',
            						'INTERIM_ORDER_DEMAND_CTP_EXT', 'INTERIM_ORDER_SUPPLY_CTP_EXT', 'DOP_NETTED_DEMAND_EXT',
                              'MAINT_ORDER_MATR_DEMAND_EXT', 'COMPATIBLE_UNIT_DEMAND_EXT', 'WO_ORDER_LINE_SHORTAGE',
                              'TRANSPORT_TASK_SUPPL_DEMAND_MS', 'TRANSPORT_TASK_SUPPLY_DEMAND', 'MATERIAL_REQUIS_LINE_DEMAND',
                              'MATERIAL_REQUIS_LINE_SHORTAGE', 'MATERIAL_REQUIS_LINE_MS', 'MATERIAL_REQUIS_RESERVAT',
                              'TRANSPORT_TASK_LINE_RES', 'TRANSPORT_TASK_SUPP_DEMAND_EXT', 'TRANSPORT_TASK_SUPPL_DEMAND_OE',
                              'MATERIAL_REQUIS_LINE_DEMAND_OE', 'MATERIAL_REQUIS_LINE_EXT')
                           AND INSTR(comments, 'MODULE=IGNORE') > 0)
            OR (table_name = 'PM_MATR_DEMAND_EXT' AND  comments IS NULL)
            );
BEGIN
   OPEN get_table_name;
   LOOP
     FETCH get_table_name INTO table_name_;
     EXIT WHEN get_table_name%NOTFOUND;
     Database_SYS.Remove_View(table_name_, TRUE);
   END LOOP;
   CLOSE get_table_name;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DynamicViews.sql','Done');
PROMPT Finished with POST_Invent_DynamicViews.sql
