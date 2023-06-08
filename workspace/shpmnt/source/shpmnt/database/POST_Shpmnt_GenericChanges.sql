-----------------------------------------------------------------------------
--  Module     : SHPMNT
--
--  File       : POST_Shpmnt_GenericChanges.sql
--
--  Purpose    : This post script will be used to handle the generic changes done in shpmnt. Mainly it will contain data upgrade which refer customer order related tables.
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  201031   KiSalk  Bug 152187(SCZ-8787), Modified the way updating SHIPMENT_LINE_TAB (Timestamp_3) to improve performance, by eliminating growing Rollback Segment very large 
--  201031           due to high volume of data being changed, by adding commits between 1000-record updates.
--  171030   MaRalk  STRSC-11615, Modified shipment_line_tab updation by adding the check for the existence of 
--  171030           customer order lines in order to avoid the deployment error when there exist shipment lines 
--  171030           without customer order connection as a result of cleanup of customer orders functionality.
--  160823   MaIklk  LIM-8300, Implemented to update customs_value_currency in shipment_tab.
--  160802   MaIklk  LIM-8216, Implemented update existing record values for customs_value and merged two update stmts together.
--  160527   MaRalk  LIM-7316, Removed code block for setting SOURCE_UNIT_MEAS, CONV_FACTOR, INVERTED_CONV_FACTOR columns
--  160527           as mandatory in SHIPMENT_LINE_TAB as that setting is now done in shpmnt upg file itself.
--  160328   MaRalk  LIM-6591, Update SOURCE_UNIT_MEAS, CONV_FACTOR and INVERTED_CONV_FACTOR values in SHIPMENT_LINE_TAB.
--  160108   MaIklk  LIM-4231, Updating SOURCE_PART_NO, SOURCE_PART_DESCRIPTION and INVENTORY_PART_NO columns in SHIPMENT_LINE_TAB.
--  151216   MaIklk  LIM-5356, Created. Update actual ship date by fetching maximum date_delivered in customer_order_deilvery_tab.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------
SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_GenericChanges.sql','Timestamp_1');
PROMPT POST_Shpmnt_GenericChanges.sql

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_GenericChanges.sql','Timestamp_2');
PROMPT Updating actual ship date in SHIPMENT_TAB
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      UPDATE shipment_tab s
      SET s.actual_ship_date = (SELECT max(date_delivered)
                                 FROM customer_order_delivery_tab
                                 WHERE shipment_id = s.shipment_id
                                 AND cancelled_delivery = 'FALSE')
      WHERE s.actual_ship_date IS NULL
      AND EXISTS (SELECT 1 FROM shipment_line_tab
                  WHERE shipment_id = s.shipment_id
                  AND qty_shipped > 0);
      COMMIT;
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_GenericChanges.sql','Timestamp_3');
PROMPT Updating SOURCE_PART_NO, SOURCE_PART_DESCRIPTION and INVENTORY_PART_NO, CUSTOMS_VALUE, SOURCE_UNIT_MEAS, CONV_FACTOR AND INVERTRED_CONV_FACTOR columns in SHIPMENT_LINE_TAB

BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      DECLARE
         max_rows_ NUMBER := 1000;
         CURSOR get_order_lines IS
            SELECT sl.shipment_id, col.order_no, col.line_no, col.rel_no, catalog_no, col.line_item_no, nvl(col.catalog_desc, Sales_Part_API.Get_Catalog_Desc(col.contract, col.catalog_no)) catalog_description, 
               col.part_no, col.customs_value, col.sales_unit_meas, col.conv_factor, col.inverted_conv_factor
             FROM shipment_line_tab sl, customer_order_line_tab col
                                                                            WHERE col.order_no = sl.source_ref1
                                                                            AND col.line_no = sl.source_ref2
                                                                            AND col.rel_no = sl.source_ref3
              AND col.line_item_no = sl.source_ref4
              AND sl.source_ref_type = 'CUSTOMER_ORDER'
              AND sl.source_part_description = 'DUMMY_UPG'; -- this condition will make sure that rerunning of this block will not give any strange results.

         TYPE order_values_tab IS TABLE OF get_order_lines%ROWTYPE INDEX BY PLS_INTEGER;
         order_values_tab_ order_values_tab;
      BEGIN

         OPEN get_order_lines;
         LOOP
            FETCH get_order_lines BULK COLLECT INTO order_values_tab_ LIMIT max_rows_;
            EXIT WHEN order_values_tab_.COUNT = 0;

            FORALL i IN order_values_tab_.first .. order_values_tab_.last
               UPDATE shipment_line_tab sl
                  SET sl.source_part_no = order_values_tab_(i).catalog_no,
                     sl.source_part_description = order_values_tab_(i).catalog_description, 
                     sl.inventory_part_no = order_values_tab_(i).part_no,
                     sl.customs_value = order_values_tab_(i).customs_value,
                     sl.source_unit_meas = order_values_tab_(i).sales_unit_meas,
                     sl.conv_factor = order_values_tab_(i).conv_factor,
                     sl.inverted_conv_factor = order_values_tab_(i).inverted_conv_factor
               WHERE sl.shipment_id = order_values_tab_(i).shipment_id
                 AND sl.source_ref1 = order_values_tab_(i).order_no
                 AND sl.source_ref2 = order_values_tab_(i).line_no
                 AND sl.source_ref3 = order_values_tab_(i).rel_no
                 AND sl.source_ref4 = order_values_tab_(i).line_item_no
                 AND sl.source_ref_type = 'CUSTOMER_ORDER'
                 AND sl.source_part_description = 'DUMMY_UPG';
      COMMIT;

         END LOOP;
         CLOSE get_order_lines;


      END;
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_GenericChanges.sql','Timestamp_4');
PROMPT Updating customs_value_currency in SHIPMENT_TAB
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      UPDATE shipment_tab st
      SET customs_value_currency = (SELECT DISTINCT customs_value_currency
                                    FROM customer_order_tab co
                                    WHERE co.order_no IN (SELECT source_ref1
                                                            FROM shipment_line_tab slt
                                                           WHERE slt.shipment_id = st.shipment_id))
      WHERE customs_value_currency IS NULL
      AND (SELECT COUNT(DISTINCT nvl(customs_value_currency, 'STRING_NULL'))
           FROM customer_order_tab co
           WHERE co.order_no IN (SELECT source_ref1
                                 FROM shipment_line_tab slt
                                 WHERE slt.shipment_id = st.shipment_id)) = 1;

      COMMIT;
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_GenericChanges.sql','Done');
PROMPT Finished with POST_Shpmnt_GenericChanges.sql


