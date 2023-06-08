-----------------------------------------------------------------------------
--  Module     : SHPMNT
--
--  File       : POST_Shpmnt_MoveFromOrder.sql
--
--  Purpose    : In APP10 existing Shipment functionality was taken into separate module called 'SHPMNT'
--             : in order to support more Generic Shipment functionality.
--             : Shipment related table structures itself will be used and there are some new columns as well as
--             : more suitable generic column names in some of the tables.
--             : Along with the [PreComponent] tag in the deploy.ini for SHPMNT, it implies that SHPMNT inherits
--             : (or upgrade from) ORDER component. It has already being moved Shipment related code from
--             : ORDER upgs into new UPGs in SHPMNT.
--             : As ORDER having a static connection to SHPMNT, some updates dependent on ORDER module must be execute
--             : after the ORDER execution. Such code blocks have placed in this post script.
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  190712   SBalLK  Bug 149302(SCZ-5855), Changed the Timestamp_8 block by changing eng_chg_level parameter type to VARCHAR2 from NUMBER.
--  170818   KhVese  STRSC-11356, Modified cursor get_shipment_lines to exclude connected order lines with quantity NULL when inserting 
--  170818           handling units into shipment_line_handl_unit_tab (timestamp_6).
--  170817   KhVese  STRSC-11356, Modified cursor get_shipment_lines to exclude package records with quantity NULL when inserting package units into shipment_line_handl_unit_tab.
--  170809   KhVese  STRSC-10969, Removed cursors and convert the logic in to a direct sql when inserting package units into shipment_reserv_handl_unit_tab
--  170809           in order to improve performance. (Copied the correction done by KoDelk in Beta for LCS Bug LCS-136923: EAP_G1818324_EAP)
--  170706   MaRalk  STRSC-9550, Modified upgrade of shipment_line_tab - connected_source_qty by taking the 
--  170706           SUM of the delivered quantities in the customer_order_delivery_tab. This is reapplying the correction for the Bug 127245.
--  170508   SBalLK  Bug 133745, Modified to copy closed shipment reservation connections from package structure - handling units, package structure - package.
--  170504   MaIklk  STRSC-7884, Removed $ELSE part in Delcare block of timestap3.
--  161221   MaRalk  LIM-10099, Improved code for updating delivery_note_tab - source_lang_code.
--  161215   MaIklk  STRSC-5195, Fixed to include shipment_line_no when inserting records to Shipment_Reserv_Handl_unit_tab.
--  161129   MaIklk  LIM-9178, Moved Shipment_reserv_Handl_Unit_Tab related updates to this post script.
--  161118   NiNilk  Bug 132536, Under 'Timestamp_3', added NVL to avoid getting null values for column inventory_qty in shipment_line_tab.
--  160930   MaIklk  LIM-8330, Added source ref type check in neccessary places.
--  160704   MaRalk  LIM-7671, Modified the block for updating DELIVERY_NOTE_TAB columns
--  160704           to reflect column renaming delivery_note_tab - originating_co_lang_code as source_lang_code.
--  160608   MaIklk  LIM-7442, Moved ORDER upg content related to delivery_note_tab.
--  160509   MaRalk  LIM-6531, Moved updating currency code in SHIPMENT_TAB to ORDER/1500.upg file as now the column has moved to
--  160509           the new table shipment_freight_tab in ORDER.
--  160317   SBalLK  Bug 127245, Modified to get SUM of the delivered quantities from the customer_order_delivery_tab since there can have partial deliveries
--  160317           through the same shipment when shipment not Closed state and when in Complete state.
--  160304   MaRalk  LIM-6423, Modified the data insertion to Shipment_Line_Handl_Unit_Tab by adding shipment_line_no and by
--  160304           removing order_no, line_no, rel_no, line_item_no in the blocks which are related to inserting connections
--  160304           from package structure - handling units/package units.
--  160111   RoJalk  LIM-5712, Rename shipment_qty to connected_source_qty in SHIPMENT_LINE_TAB.
--  151216   MaRalk  LIM-4614, Moved shpmnt content from order 1410.upg. Replaced usages of renamed columns/tables
--  151216           SHIPMENT_ORDER_LINE_TAB as SHIPMENT_LINE_TAB, SHIPMENT_ORDER_LINE_TAB - ORDER_NO, LINE_NO, REL_NO,
--  151216           LINE_ITEM_NO, SALES_QTY, REVISED_QTY_DUE as SOURCE_REF1 2 3 4, SHIPMENT_QTY, INVENTORY_QTY,
--  151216           SHIPMENT_LINE_HANDL_UNIT_TAB - ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO as SOURCE_REF1 2 3 4,
--  151216           SHIPMENT_TAB - ORDER_NO as SOURCE_REF1.
--  151203   MaIklk  LIM-4028, Moved shpmnt content from order 1400.upg when the block refers the order tables.
--  151202   MaRalk  LIM-4029, Created.
--  151202           Following modifications related to shipment functionality was moved from Order 1400.upg and 1410.upg.
--  ---------------------------------------------  **********************  -----------------------------------------------
--  1410.upg contents
--
--  130802   MaEelk  Changed the codes to execute dynamic statements where the SHIPMENT_HANDLING_UNIT_TAB and SHIPMENT_PACKAGE_UNIT_TAB have been used.
--  130731   MaEelk  Added SHIPMENT_HANDLING_UNIT_TAB and SHIPMENT_PACKAGE_UNIT_TAB to Rename obsolete table setction.
--  130604   JeLise  Upgrading data from package structure to handling unit structure on shipment.
--  130207   MeAblk  Adding not null column QTY_PICKED column into SHIPMENT_ORDER_LINE_TAB and do the respective data upgrade.
--  121108   MeAblk  Adding the not null column qty_to_ship to SHIPMENT_ORDER_LINE_TAB.
--  120822   MeAblk  Adding SHIPMENT_TYPE, ORDER_NO and SHIPMENT_CATEGORY to SHIPMENT_TAB.
--  120706   MAEELK  Added columns SALES_QTY, REVISED_QTY_DUE, QTY_ASSIGNED and QTY_SHIPPED to SHIPMENT_ORDER_LINE_TAB.
--  120520   MaMalk  Added SHIPMENT_TYPE, ORDER_NO and SHIPMENT_CATEGORY to SHIPMENT_TAB.
-- --------------------------------------------- ********************** ---------------------------------------------
--  1400.upg Contents
--
--  110721   MaMalk  Bug 96637, Remove shipment order lines when the shipment connection flags are not set in customer order lines.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------
SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_MoveFromOrder.sql','Timestamp_1');
PROMPT POST_Shpmnt_MoveFromOrder.sql

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_MoveFromOrder.sql','Timestamp_2');
PROMPT Removing shipment order lines that have not been connected with customer order lines
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      DELETE FROM shipment_line_tab sl
      WHERE  sl.source_ref_type = 'CUSTOMER_ORDER'
      AND    EXISTS (SELECT 1
                     FROM   customer_order_line_tab co
                     WHERE  co.order_no = sl.source_ref1
                     AND    co.line_no =  sl.source_ref2
                     AND    co.rel_no = sl.source_ref3
                     AND    co.line_item_no = sl.source_ref4
                     AND    co.shipment_connected = 'FALSE')
      AND    EXISTS (SELECT 1
                     FROM  shipment_tab s
                     WHERE s.shipment_id = sl.shipment_id
                     AND   s.rowstate = 'Preliminary');
      COMMIT;
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_MoveFromOrder.sql','Timestamp_3');
PROMPT Updating column SHIPMENT_TYPE in SHIPMENT_TAB
DECLARE
   $IF (Component_Order_SYS.INSTALLED) $THEN
      CURSOR get_shipments IS
         SELECT shipment_id
         FROM   shipment_tab
         WHERE  shipment_type IS NULL
         AND    shipment_category = 'NORMAL';

      CURSOR get_common_shipment_type(shipment_id_ IN NUMBER) IS
         SELECT col.shipment_type
         FROM   shipment_line_tab sl, customer_order_line_tab col
         WHERE  sl.source_ref1 = col.order_no
         AND    sl.source_ref2 = col.line_no
         AND    sl.source_ref3 = col.rel_no
         AND    sl.source_ref4 = col.line_item_no
         AND    sl.source_ref_type = 'CUSTOMER_ORDER'
         AND    sl.shipment_id = shipment_id_
         AND    col.rowstate != 'Cancelled'
         GROUP BY col.shipment_type
         ORDER BY COUNT(sl.shipment_id) DESC;

      CURSOR get_order_no(shipment_id_ IN NUMBER, ship_type_ IN VARCHAR2) IS
         SELECT col.order_no
         FROM   shipment_line_tab sl, customer_order_line_tab col
         WHERE  sl.source_ref1 = col.order_no
         AND    sl.source_ref2 = col.line_no
         AND    sl.source_ref3 = col.rel_no
         AND    sl.source_ref4 = col.line_item_no
         AND    sl.source_ref_type = 'CUSTOMER_ORDER'
         AND    sl.shipment_id = shipment_id_
         AND    col.shipment_type = ship_type_
         AND    col.rowstate != 'Cancelled';

      shipment_type_   VARCHAR2(3);
      order_no_        VARCHAR2(12);
   $END
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      FOR rec_ IN get_shipments LOOP
         shipment_type_ := NULL;
         order_no_      := NULL;

         OPEN get_common_shipment_type(rec_.shipment_id);
         FETCH get_common_shipment_type INTO shipment_type_;
         CLOSE get_common_shipment_type;

         IF (shipment_type_ IS NOT NULL) THEN
            IF shipment_type_ IN ('NR', 'NP') THEN
               OPEN get_order_no(rec_.shipment_id, shipment_type_);
               FETCH get_order_no INTO order_no_;
               CLOSE get_order_no;

               UPDATE shipment_tab
               SET    shipment_type =  shipment_type_,
                      source_ref1 = order_no_
               WHERE  shipment_id = rec_.shipment_id;
            ELSE
               UPDATE shipment_tab
               SET    shipment_type =  shipment_type_
               WHERE  shipment_id = rec_.shipment_id;
            END IF;
         END IF;
      END LOOP;

      UPDATE shipment_tab
      SET    shipment_type =  'NA'
      WHERE  shipment_type IS NULL
      AND    shipment_category = 'NORMAL';

      COMMIT;

   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_MoveFromOrder.sql','Timestamp_4');
PROMPT Updating columns in SHIPMENT_LINE_TAB

BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      UPDATE shipment_line_tab sl
         SET inventory_qty = CASE
                                WHEN EXISTS (SELECT 1
                                             FROM  customer_order_delivery_tab cod
                                             WHERE cod.order_no = sl.source_ref1
                                             AND   cod.line_no = sl.source_ref2
                                             AND   cod.rel_no = sl.source_ref3
                                             AND   cod.line_item_no = sl.source_ref4
                                             AND   cod.shipment_id = sl.shipment_id) THEN
                                   (NVL((SELECT SUM(cod.qty_shipped)
                                    FROM customer_order_delivery_tab cod
                                    WHERE cod.order_no = sl.source_ref1
                                    AND   cod.line_no = sl.source_ref2
                                    AND   cod.rel_no = sl.source_ref3
                                    AND   cod.line_item_no = sl.source_ref4
                                    AND   cod.shipment_id = sl.shipment_id), 0))
                                ELSE
                                   (NVL((SELECT col.open_shipment_qty
                                    FROM customer_order_line_tab col
                                    WHERE col.order_no = sl.source_ref1
                                    AND   col.line_no = sl.source_ref2
                                    AND   col.rel_no = sl.source_ref3
                                    AND   col.line_item_no = sl.source_ref4), 0))
                                END,
             connected_source_qty = CASE
                               WHEN EXISTS (SELECT 1
                                            FROM  customer_order_delivery_tab cod
                                            WHERE cod.order_no = sl.source_ref1
                                            AND   cod.line_no = sl.source_ref2
                                            AND   cod.rel_no = sl.source_ref3
                                            AND   cod.line_item_no = sl.source_ref4
                                            AND   cod.shipment_id = sl.shipment_id) THEN
                                  (NVL((SELECT SUM(cod.qty_shipped * (col.inverted_conv_factor/col.conv_factor))
                                   FROM  customer_order_delivery_tab cod, customer_order_line_tab col
                                   WHERE cod.order_no = sl.source_ref1
                                   AND   cod.line_no = sl.source_ref2
                                   AND   cod.rel_no = sl.source_ref3
                                   AND   cod.line_item_no = sl.source_ref4
                                   AND   cod.shipment_id = sl.shipment_id
                                   AND   col.order_no = sl.source_ref1
                                   AND   col.line_no = sl.source_ref2
                                   AND   col.rel_no = sl.source_ref3
                                   AND   col.line_item_no = sl.source_ref4), 0))
                               ELSE
                                  (NVL((SELECT col.open_shipment_qty * (col.inverted_conv_factor/col.conv_factor)
                                   FROM  customer_order_line_tab col
                                   WHERE col.order_no = sl.source_ref1
                                   AND   col.line_no = sl.source_ref2
                                   AND   col.rel_no = sl.source_ref3
                                   AND   col.line_item_no = sl.source_ref4), 0))
                               END,
             qty_assigned = CASE
                               WHEN (qty_assigned IS NULL) THEN
                                  NVL((SELECT SUM(cor.qty_assigned)
                                       FROM  customer_order_reservation_tab cor
                                       WHERE cor.order_no = sl.source_ref1
                                       AND   cor.line_no = sl.source_ref2
                                       AND   cor.rel_no = sl.source_ref3
                                       AND   cor.line_item_no = sl.source_ref4
                                       AND   cor.shipment_id = sl.shipment_id), 0)
                               ELSE
                                  qty_assigned
                               END,
             qty_shipped = CASE
                              WHEN (qty_shipped IS NULL) THEN
                                 NVL((SELECT SUM(cod.qty_shipped)
                                      FROM  customer_order_delivery_tab cod
                                      WHERE cod.order_no  = sl.source_ref1
                                      AND   cod.line_no = sl.source_ref2
                                      AND   cod.rel_no = sl.source_ref3
                                      AND   cod.line_item_no = sl.source_ref4
                                      AND   cod.shipment_id  = sl.shipment_id), 0)
                              ELSE
                                 qty_shipped
                              END,

             qty_to_ship = CASE
                              WHEN (qty_to_ship IS NULL) THEN
                                 CASE
                                    WHEN (sl.source_ref1, sl.source_ref2, sl.source_ref3, sl.source_ref4)  IN (SELECT order_no, line_no, rel_no, line_item_no
                                                                                                               FROM   customer_order_line_tab
                                                                                                               WHERE  part_no IS NULL) THEN
                                       (SELECT b.qty_to_ship
                                        FROM   customer_order_line_tab b
                                        WHERE  sl.source_ref1  = b.order_no
                                        AND    sl.source_ref2  = b.line_no
                                        AND    sl.source_ref3  = b.rel_no
                                        AND    sl.source_ref4  = b.line_item_no)
                                    ELSE
                                       0
                                    END
                              ELSE
                                 qty_to_ship
                              END,
             qty_picked = CASE
                             WHEN (qty_picked IS NULL) THEN
                                NVL((SELECT SUM(cor.qty_picked)
                                     FROM  customer_order_reservation_tab cor
                                     WHERE cor.order_no = sl.source_ref1
                                     AND   cor.line_no = sl.source_ref2
                                     AND   cor.rel_no = sl.source_ref3
                                     AND   cor.line_item_no = sl.source_ref4
                                     AND   cor.shipment_id = sl.shipment_id), 0)
                             ELSE
                                qty_picked
                             END
         WHERE inventory_qty IS NULL
         AND   sl.source_ref_type = 'CUSTOMER_ORDER';
      COMMIT;
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_MoveFromOrder.sql','Timestamp_5');
PROMPT Modifying SHIPMENT_QTY, INVENTORY_QTY, QTY_ASSIGNED, QTY_SHIPPED, QTY_PICKED, QTY_TO_SHIP not null in SHIPMENT_LINE_TAB
DECLARE
   column_ Database_SYS.ColRec;
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      column_ := Database_SYS.Set_Column_Values('CONNECTED_SOURCE_QTY', 'NUMBER', 'N');
      Database_SYS.Alter_Table_Column('SHIPMENT_LINE_TAB', 'M', column_, TRUE);

      column_ := Database_SYS.Set_Column_Values('INVENTORY_QTY', 'NUMBER', 'N');
      Database_SYS.Alter_Table_Column('SHIPMENT_LINE_TAB', 'M', column_, TRUE);

      column_ := Database_SYS.Set_Column_Values('QTY_ASSIGNED', 'NUMBER', 'N');
      Database_SYS.Alter_Table_Column('SHIPMENT_LINE_TAB', 'M', column_, TRUE);

      column_ := Database_SYS.Set_Column_Values('QTY_SHIPPED', 'NUMBER', 'N');
      Database_SYS.Alter_Table_Column('SHIPMENT_LINE_TAB', 'M', column_, TRUE);

      column_ := Database_SYS.Set_Column_Values('QTY_TO_SHIP', 'NUMBER', 'N');
      Database_SYS.Alter_Table_Column('SHIPMENT_LINE_TAB', 'M', column_, TRUE);

      column_ := Database_SYS.Set_Column_Values('QTY_PICKED', 'NUMBER', 'N');
      Database_SYS.Alter_Table_Column('SHIPMENT_LINE_TAB', 'M', column_, TRUE);
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_MoveFromOrder.sql','Timestamp_6');
PROMPT Upgrading data from package structure to handling unit structure on shipment.
-- Insert all connections to shipment lines from package structure - handling units
DECLARE
   stmt_ VARCHAR2(32000);
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      IF (Database_SYS.Table_Exist('SHIPMENT_HANDLING_UNIT_TAB')) THEN
         stmt_ := 'DECLARE
                      conv_factor_          NUMBER;
                      inverted_conv_factor_ NUMBER;
                      quantity_             NUMBER;
                      shipment_line_no_     NUMBER;

                      CURSOR get_order_line_info (order_no_     IN VARCHAR2,
                                                  line_no_      IN VARCHAR2,
                                                  rel_no_       IN VARCHAR2,
                                                  line_item_no_ IN VARCHAR2) IS
                         SELECT conv_factor,
                                inverted_conv_factor
                         FROM customer_order_line_tab
                         WHERE order_no     = order_no_
                         AND   line_no      = line_no_
                         AND   rel_no       = rel_no_
                         AND   line_item_no = line_item_no_;

                      CURSOR get_shipment_lines IS
                         SELECT shipment_id,
                                order_no,
                                line_no,
                                rel_no,
                                line_item_no,
                                handling_unit_id,
                                quantity
                         FROM shipment_handling_unit_tab sh
                         WHERE sh.order_no IS NOT NULL
                         AND   sh.quantity IS NOT NULL
                         AND   NOT EXISTS (SELECT 1
                                           FROM shipment_reserv_handl_unit_tab h
                                           WHERE sh.handling_unit_id = h.handling_unit_id);

                      CURSOR get_shipment_line_no (shipment_id_ IN NUMBER,
                                                   source_ref1_ IN VARCHAR2,
                                                   source_ref2_ IN VARCHAR2,
                                                   source_ref3_ IN VARCHAR2,
                                                   source_ref4_ IN VARCHAR2) IS
                         SELECT sl.shipment_line_no
                         FROM shipment_line_tab sl
                         WHERE sl.shipment_id = shipment_id_
                         AND   sl.source_ref1 = source_ref1_
                         AND   sl.source_ref2 = source_ref2_
                         AND   sl.source_ref3 = source_ref3_
                         AND   sl.source_ref4 = source_ref4_
                         AND   sl.source_ref_type = ''CUSTOMER_ORDER'' ;
                   BEGIN
                      FOR shipment_line_rec_ IN get_shipment_lines LOOP
                         OPEN get_order_line_info(shipment_line_rec_.order_no,
                                                  shipment_line_rec_.line_no,
                                                  shipment_line_rec_.rel_no,
                                                  shipment_line_rec_.line_item_no);
                         FETCH get_order_line_info INTO conv_factor_, inverted_conv_factor_;
                         CLOSE get_order_line_info;
                         -- Convert from Inventory UoM to Sales UoM
                         quantity_ := (shipment_line_rec_.quantity/conv_factor_ * inverted_conv_factor_);
                         OPEN get_shipment_line_no(shipment_line_rec_.shipment_id,
                                                   shipment_line_rec_.order_no,
                                                   shipment_line_rec_.line_no,
                                                   shipment_line_rec_.rel_no,
                                                   shipment_line_rec_.line_item_no);
                         FETCH get_shipment_line_no INTO shipment_line_no_;
                         CLOSE get_shipment_line_no;
                         BEGIN
                            INSERT INTO shipment_line_handl_unit_tab (
                               shipment_id,
                               shipment_line_no,
                               handling_unit_id,
                               quantity,
                               rowversion)
                            VALUES (
                               shipment_line_rec_.shipment_id,
                               shipment_line_no_,
                               shipment_line_rec_.handling_unit_id,
                               quantity_,
                               sysdate);
                          EXCEPTION
                             WHEN dup_val_on_index THEN
                                NULL;
                         END;
                         COMMIT;
                      END LOOP;
                   END;';
         EXECUTE IMMEDIATE stmt_;
         COMMIT;
      END IF;
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_MoveFromOrder.sql','Timestamp_7');
PROMPT Upgrading data from package structure to handling unit structure on shipment.
-- Insert all connections to shipment lines from package structure - package units
DECLARE
   stmt_ VARCHAR2(32000);
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      IF (Database_SYS.Table_Exist('SHIPMENT_PACKAGE_UNIT_TAB')) THEN
         stmt_ := 'DECLARE
                     conv_factor_          NUMBER;
                     inverted_conv_factor_ NUMBER;
                     quantity_             NUMBER;
                     shipment_line_no_     NUMBER;

                     CURSOR get_order_line_info (order_no_     IN VARCHAR2,
                                                 line_no_      IN VARCHAR2,
                                                 rel_no_       IN VARCHAR2,
                                                 line_item_no_ IN VARCHAR2) IS
                        SELECT conv_factor,
                               inverted_conv_factor
                        FROM customer_order_line_tab
                        WHERE order_no     = order_no_
                        AND   line_no      = line_no_
                        AND   rel_no       = rel_no_
                        AND   line_item_no = line_item_no_;

                     CURSOR get_shipment_lines IS
                        SELECT shipment_id,
                               order_no,
                               line_no,
                               rel_no,
                               line_item_no,
                               package_unit_id,
                               quantity
                        FROM shipment_package_unit_tab sp
                        WHERE sp.order_no IS NOT NULL
                        AND   sp.quantity IS NOT NULL   
                        AND   NOT EXISTS (SELECT 1
                                          FROM shipment_reserv_handl_unit_tab h
                                          WHERE sp.package_unit_id  = h.handling_unit_id);

                     CURSOR get_shipment_line_no (shipment_id_ IN NUMBER,
                                                  source_ref1_ IN VARCHAR2,
                                                  source_ref2_ IN VARCHAR2,
                                                  source_ref3_ IN VARCHAR2,
                                                  source_ref4_ IN VARCHAR2) IS
                        SELECT sl.shipment_line_no
                        FROM shipment_line_tab sl
                        WHERE sl.shipment_id = shipment_id_
                        AND   sl.source_ref1 = source_ref1_
                        AND   sl.source_ref2 = source_ref2_
                        AND   sl.source_ref3 = source_ref3_
                        AND   sl.source_ref4 = source_ref4_
                        AND   sl.source_ref_type = ''CUSTOMER_ORDER'' ;
                   BEGIN
                     FOR shipment_line_rec_ IN get_shipment_lines LOOP
                        OPEN get_order_line_info(shipment_line_rec_.order_no,
                                                 shipment_line_rec_.line_no,
                                                 shipment_line_rec_.rel_no,
                                                 shipment_line_rec_.line_item_no);
                        FETCH get_order_line_info INTO conv_factor_, inverted_conv_factor_;
                        CLOSE get_order_line_info;
                        -- Convert from Inventory UoM to Sales UoM
                        quantity_ := (shipment_line_rec_.quantity/conv_factor_ * inverted_conv_factor_);
                        OPEN get_shipment_line_no(shipment_line_rec_.shipment_id,
                                                  shipment_line_rec_.order_no,
                                                  shipment_line_rec_.line_no,
                                                  shipment_line_rec_.rel_no,
                                                  shipment_line_rec_.line_item_no);
                        FETCH get_shipment_line_no INTO shipment_line_no_;
                        CLOSE get_shipment_line_no;
                        BEGIN
                           INSERT
                              INTO shipment_line_handl_unit_tab (
                                 shipment_id,
                                 shipment_line_no,
                                 handling_unit_id,
                                 quantity,
                                 rowversion)
                              VALUES (
                                 shipment_line_rec_.shipment_id,
                                 shipment_line_no_,
                                 shipment_line_rec_.package_unit_id,
                                 quantity_,
                                 sysdate);
                        EXCEPTION
                           WHEN dup_val_on_index THEN
                              NULL;
                        END;
                        COMMIT;
                     END LOOP;
                   END;';
         EXECUTE IMMEDIATE stmt_;
         COMMIT;
      END IF;
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_MoveFromOrder.sql','Timestamp_8');
PROMPT Inserting data of reservation connections from package structure - handling units into shipment_reserv_handl_unit_tab.
-- Insert all reservation connections from package structure - handling units
DECLARE
   stmt_ VARCHAR2(32000);
BEGIN
   IF (Database_SYS.Table_Exist('SHIPMENT_HANDLING_UNIT_TAB')) THEN
      stmt_ := 'DECLARE
                   part_no_                  VARCHAR2(25);
                   count_                    NUMBER;
                   location_no_              VARCHAR2(35);
                   activity_seq_             NUMBER;
                   reserv_handling_unit_id_  NUMBER;
                   configuration_id_         VARCHAR2(50);
                   pick_list_no_             VARCHAR2(15);
                   shipment_line_no_         NUMBER;

                   CURSOR get_shipment_lines IS
                      SELECT sh.order_no,
                             sh.line_no,
                             sh.rel_no,
                             sh.line_item_no,
                             s.contract,
                             sh.lot_batch_no,
                             sh.serial_no,
                             sh.eng_chg_level,
                             sh.waiv_dev_rej_no,
                             sh.shipment_id,
                             sh.handling_unit_id,
                             sh.quantity
                      FROM shipment_handling_unit_tab sh, shipment_tab s
                      WHERE sh.shipment_id = s.shipment_id
                      AND   sh.order_no IS NOT NULL
                      AND   NOT EXISTS (SELECT 1
                                        FROM shipment_reserv_handl_unit_tab h
                                        WHERE sh.handling_unit_id = h.handling_unit_id);

                   CURSOR get_part_no (order_no_     IN VARCHAR2,
                                       line_no_      IN VARCHAR2,
                                       rel_no_       IN VARCHAR2,
                                       line_item_no_ IN VARCHAR2) IS
                      SELECT part_no
                      FROM customer_order_line_tab
                      WHERE order_no     = order_no_
                      AND   line_no      = line_no_
                      AND   rel_no       = rel_no_
                      AND   line_item_no = line_item_no_;

                   CURSOR count_reservation (order_no_        IN VARCHAR2,
                                             line_no_         IN VARCHAR2,
                                             rel_no_          IN VARCHAR2,
                                             line_item_no_    IN NUMBER,
                                             contract_        IN VARCHAR2,
                                             part_no_         IN VARCHAR2,
                                             lot_batch_no_    IN VARCHAR2,
                                             serial_no_       IN VARCHAR2,
                                             eng_chg_level_   IN VARCHAR2,
                                             waiv_dev_rej_no_ IN VARCHAR2,
                                             shipment_id_     IN NUMBER) IS
                      SELECT count(1)
                      FROM customer_order_reservation_tab c
                      WHERE order_no        = order_no_
                      AND   line_no         = line_no_
                      AND   rel_no          = rel_no_
                      AND   line_item_no    = line_item_no_
                      AND   contract        = contract_
                      AND   part_no         = part_no_
                      AND   lot_batch_no    = lot_batch_no_
                      AND   serial_no       = serial_no_
                      AND   eng_chg_level   = eng_chg_level_
                      AND   waiv_dev_rej_no = waiv_dev_rej_no_
                      AND   shipment_id     = shipment_id_
                      AND   (qty_assigned + qty_shipped)- (SELECT NVL(SUM(quantity), 0)
                                            FROM shipment_reserv_handl_unit_tab s
                                            WHERE s.source_ref1               = c.order_no
                                            AND   s.source_ref2               = c.line_no
                                            AND   s.source_ref3               = c.rel_no
                                            AND   s.source_ref4               = c.line_item_no
                                            AND   s.contract                  = c.contract
                                            AND   s.part_no                   = c.part_no
                                            AND   s.location_no               = c.location_no
                                            AND   s.lot_batch_no              = c.lot_batch_no
                                            AND   s.serial_no                 = c.serial_no
                                            AND   s.eng_chg_level             = c.eng_chg_level
                                            AND   s.waiv_dev_rej_no           = c.waiv_dev_rej_no
                                            AND   s.activity_seq              = c.activity_seq
                                            AND   s.reserv_handling_unit_id   = c.handling_unit_id
                                            AND   s.configuration_id          = c.configuration_id
                                            AND   s.pick_list_no              = c.pick_list_no
                                            AND   s.shipment_id               = c.shipment_id) > 0;

                   CURSOR get_reservations (order_no_        IN VARCHAR2,
                                            line_no_         IN VARCHAR2,
                                            rel_no_          IN VARCHAR2,
                                            line_item_no_    IN NUMBER,
                                            contract_        IN VARCHAR2,
                                            part_no_         IN VARCHAR2,
                                            lot_batch_no_    IN VARCHAR2,
                                            serial_no_       IN VARCHAR2,
                                            eng_chg_level_   IN VARCHAR2,
                                            waiv_dev_rej_no_ IN VARCHAR2,
                                            shipment_id_     IN NUMBER) IS
                      SELECT location_no,
                             activity_seq,
                             handling_unit_id,
                             configuration_id,
                             pick_list_no
                      FROM customer_order_reservation_tab
                      WHERE order_no        = order_no_
                      AND   line_no         = line_no_
                      AND   rel_no          = rel_no_
                      AND   line_item_no    = line_item_no_
                      AND   contract        = contract_
                      AND   part_no         = part_no_
                      AND   lot_batch_no    = lot_batch_no_
                      AND   serial_no       = serial_no_
                      AND   eng_chg_level   = eng_chg_level_
                      AND   waiv_dev_rej_no = waiv_dev_rej_no_
                      AND   shipment_id     = shipment_id_;

                  CURSOR get_shipment_line_no (shipment_id_ IN NUMBER,
                                               source_ref1_ IN VARCHAR2,
                                               source_ref2_ IN VARCHAR2,
                                               source_ref3_ IN VARCHAR2,
                                               source_ref4_ IN VARCHAR2) IS
                        SELECT sl.shipment_line_no
                        FROM shipment_line_tab sl
                        WHERE sl.shipment_id = shipment_id_
                        AND   sl.source_ref1 = source_ref1_
                        AND   sl.source_ref2 = source_ref2_
                        AND   sl.source_ref3 = source_ref3_
                        AND   sl.source_ref4 = source_ref4_
                        AND   sl.source_ref_type = ''CUSTOMER_ORDER'' ;
                BEGIN
                   FOR shipment_line_rec_ IN get_shipment_lines LOOP
                     OPEN get_part_no(shipment_line_rec_.order_no,
                                      shipment_line_rec_.line_no,
                                      shipment_line_rec_.rel_no,
                                      shipment_line_rec_.line_item_no);
                     FETCH get_part_no INTO part_no_;
                     CLOSE get_part_no;

                     OPEN count_reservation(shipment_line_rec_.order_no,
                                            shipment_line_rec_.line_no,
                                            shipment_line_rec_.rel_no,
                                            shipment_line_rec_.line_item_no,
                                            shipment_line_rec_.contract,
                                            part_no_,
                                            shipment_line_rec_.lot_batch_no,
                                            shipment_line_rec_.serial_no,
                                            shipment_line_rec_.eng_chg_level,
                                            shipment_line_rec_.waiv_dev_rej_no,
                                            shipment_line_rec_.shipment_id);
                     FETCH count_reservation INTO count_;
                     CLOSE count_reservation;

                     IF (count_ = 1) THEN
                        OPEN get_reservations(shipment_line_rec_.order_no,
                                              shipment_line_rec_.line_no,
                                              shipment_line_rec_.rel_no,
                                              shipment_line_rec_.line_item_no,
                                              shipment_line_rec_.contract,
                                              part_no_,
                                              shipment_line_rec_.lot_batch_no,
                                              shipment_line_rec_.serial_no,
                                              shipment_line_rec_.eng_chg_level,
                                              shipment_line_rec_.waiv_dev_rej_no,
                                              shipment_line_rec_.shipment_id);
                        FETCH get_reservations INTO location_no_,
                                                    activity_seq_,
                                                    reserv_handling_unit_id_,
                                                    configuration_id_,
                                                    pick_list_no_;
                        CLOSE get_reservations;

                        OPEN get_shipment_line_no(shipment_line_rec_.shipment_id,
                                                  shipment_line_rec_.order_no,
                                                  shipment_line_rec_.line_no,
                                                  shipment_line_rec_.rel_no,
                                                  shipment_line_rec_.line_item_no);
                        FETCH get_shipment_line_no INTO shipment_line_no_;
                        CLOSE get_shipment_line_no;

                        INSERT
                           INTO shipment_reserv_handl_unit_tab (
                              source_ref1,
                              source_ref2,
                              source_ref3,
                              source_ref4,
                              contract,
                              part_no,
                              location_no,
                              lot_batch_no,
                              serial_no,
                              eng_chg_level,
                              waiv_dev_rej_no,
                              activity_seq,
                              reserv_handling_unit_id,
                              configuration_id,
                              pick_list_no,
                              shipment_id,
                              shipment_line_no,
                              handling_unit_id,
                              quantity,
                              rowversion)
                           VALUES (
                              shipment_line_rec_.order_no,
                              shipment_line_rec_.line_no,
                              shipment_line_rec_.rel_no,
                              shipment_line_rec_.line_item_no,
                              shipment_line_rec_.contract,
                              part_no_,
                              location_no_,
                              shipment_line_rec_.lot_batch_no,
                              shipment_line_rec_.serial_no,
                              shipment_line_rec_.eng_chg_level,
                              shipment_line_rec_.waiv_dev_rej_no,
                              activity_seq_,
                              reserv_handling_unit_id_,
                              configuration_id_,
                              pick_list_no_,
                              shipment_line_rec_.shipment_id,
                              shipment_line_no_,
                              shipment_line_rec_.handling_unit_id,
                              shipment_line_rec_.quantity,
                              sysdate);
                        COMMIT;
                     END IF;
                  END LOOP;
               END;';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_MoveFromOrder.sql','Timestamp_9');
PROMPT Inserting data of reservation connections from package structure - package units into shipment_reserv_handl_unit_tab.
-- Insert all reservation connections from package structure - package units
DECLARE
   stmt_ VARCHAR2(32000);
BEGIN
   IF (Database_SYS.Table_Exist('SHIPMENT_PACKAGE_UNIT_TAB')) THEN
      stmt_ := 'INSERT INTO SHIPMENT_RESERV_HANDL_UNIT_TAB
                  (source_ref1,
                   source_ref2,
                   source_ref3,
                   source_ref4,
                   contract,
                   part_no,
                   location_no,
                   activity_seq,
                   reserv_handling_unit_id,
                   configuration_id,
                   pick_list_no,
                   lot_batch_no,
                   serial_no,
                   eng_chg_level,
                   waiv_dev_rej_no,
                   shipment_id,
                   shipment_line_no,
                   handling_unit_id,
                   quantity,
                   rowversion)
                  select sp.order_no,
                         sp.line_no,
                         sp.rel_no,
                         sp.line_item_no,
                         s.contract,
                         (SELECT part_no
                            FROM CUSTOMER_ORDER_LINE_TAB
                           WHERE order_no = sp.order_no
                             AND line_no = sp.line_no
                             AND rel_no = sp.rel_no
                             AND line_item_no = sp.line_item_no),
                         cort.location_no,
                         cort.activity_seq,
                         cort.handling_unit_id,
                         cort.configuration_id,
                         cort.pick_list_no,
                         sp.lot_batch_no,
                         sp.serial_no,
                         sp.eng_chg_level,
                         sp.waiv_dev_rej_no,
                         sp.shipment_id,
                         (SELECT sl.shipment_line_no
                            FROM SHIPMENT_LINE_TAB sl
                           WHERE sl.shipment_id = sp.shipment_id
                             AND sl.source_ref1 = sp.order_no
                             AND sl.source_ref2 = sp.line_no
                             AND sl.source_ref3 = sp.rel_no
                             AND sl.source_ref4 = sp.line_item_no
                             AND sl.source_ref_type = ''CUSTOMER_ORDER''),
                         sp.package_unit_id,
                         sp.quantity,
                         sysdate
                    FROM SHIPMENT_PACKAGE_UNIT_TAB      sp,
                         SHIPMENT_TAB                   s,
                         CUSTOMER_ORDER_RESERVATION_TAB cort
                   WHERE sp.shipment_id         = s.shipment_id
                     AND sp.quantity            IS NOT NULL
                     AND sp.order_no            IS NOT NULL
                     AND NOT EXISTS (SELECT 1
                                       FROM SHIPMENT_RESERV_HANDL_UNIT_TAB h
                                      WHERE sp.package_unit_id = h.handling_unit_id)
                     AND cort.order_no          = sp.order_no
                     AND cort.line_no           = sp.line_no
                     AND cort.rel_no            = sp.rel_no
                     AND cort.line_item_no      = sp.line_item_no
                     AND cort.contract          = s.contract
                     AND cort.part_no           = (SELECT part_no
                                                     FROM CUSTOMER_ORDER_LINE_TAB
                                                    WHERE order_no      = sp.order_no
                                                      AND line_no       = sp.line_no
                                                      AND rel_no        = sp.rel_no
                                                      AND line_item_no  = sp.line_item_no)
                     AND cort.lot_batch_no      = sp.lot_batch_no
                     AND cort.serial_no         = sp.serial_no
                     AND cort.eng_chg_level     = sp.eng_chg_level
                     AND cort.waiv_dev_rej_no   = sp.waiv_dev_rej_no
                     AND cort.shipment_id       = sp.shipment_id
                     AND (SELECT count(1)
                            FROM CUSTOMER_ORDER_RESERVATION_TAB c
                           WHERE order_no       = sp.order_no
                             AND line_no        = sp.line_no
                             AND rel_no         = sp.rel_no
                             AND line_item_no   = sp.line_item_no
                             AND contract       = s.contract
                             AND part_no        = (SELECT part_no
                                                     FROM CUSTOMER_ORDER_LINE_TAB
                                                    WHERE order_no      = sp.order_no
                                                      AND line_no       = sp.line_no
                                                      AND rel_no        = sp.rel_no
                                                      AND line_item_no  = sp.line_item_no)
                             AND lot_batch_no   = sp.lot_batch_no
                             AND serial_no      = sp.serial_no
                             AND eng_chg_level  = sp.eng_chg_level
                             AND waiv_dev_rej_no = sp.waiv_dev_rej_no
                             AND shipment_id    = sp.shipment_id
                             AND ((qty_assigned + qty_shipped) -
                                 (SELECT NVL(SUM(quantity), 0)
                                    FROM SHIPMENT_RESERV_HANDL_UNIT_TAB s1
                                   WHERE s1.source_ref1              = c.order_no
                                     AND s1.source_ref2              = c.line_no
                                     AND s1.source_ref3              = c.rel_no
                                     AND s1.source_ref4              = c.line_item_no
                                     AND s1.contract                 = c.contract
                                     AND s1.part_no                  = c.part_no
                                     AND s1.location_no              = c.location_no
                                     AND s1.lot_batch_no             = c.lot_batch_no
                                     AND s1.serial_no                = c.serial_no
                                     AND s1.eng_chg_level            = c.eng_chg_level
                                     AND s1.waiv_dev_rej_no          = c.waiv_dev_rej_no
                                     AND s1.activity_seq             = c.activity_seq
                                     AND s1.reserv_handling_unit_id  = c.handling_unit_id
                                     AND s1.configuration_id         = c.configuration_id
                                     AND s1.pick_list_no             = c.pick_list_no
                                     AND s1.shipment_id              = c.shipment_id)) > 0) = 1';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_MoveFromOrder.sql','Timestamp_10');
PROMPT Renaming obsolete tables
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      Database_SYS.Rename_Table('SHIPMENT_HANDLING_UNIT_TAB',  'SHIPMENT_HANDLING_UNIT_1410',  TRUE);
      Database_SYS.Rename_Table('SHIPMENT_PACKAGE_UNIT_TAB',   'SHIPMENT_PACKAGE_UNIT_1410',   TRUE);
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_MoveFromOrder.sql','Timestamp_11');
PROMPT Updating column source_lang_code in DELIVERY_NOTE_TAB
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      UPDATE delivery_note_tab dn
      SET    dn.source_lang_code =(SELECT ci.default_language
                                   FROM   customer_info_tab ci
                                   WHERE  ci.customer_id = dn.receiver_id)
      WHERE dn.source_lang_code IS NULL
      AND EXISTS (SELECT 1
                  FROM  customer_order_tab co
                  WHERE co.order_no = dn.order_no
                  AND   co.customer_no != dn.receiver_id);
      COMMIT;
   $ELSE
      NULL;
   $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_MoveFromOrder.sql','Done');
PROMPT Finished with POST_Shpmnt_MoveFromOrder.sql


