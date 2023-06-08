-----------------------------------------------------------------------------
--
--  Logical unit: SupplyOrderAnalysis
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220726  KiSalk  Bug 163961(SCDEV-12683), Moved condition check before cursor loop in Gen_Children_From_Orders___ and Gen_Children_From_Ordchg___.
--  220303  Avjalk  SCDEV-8061, Implemented Delete_Old_Trees___() to clear redundant data of the SUPPLY_ORDER_ANALYSIS_TAB older than 1 day.
--  210621  JoAnSe  MF21R2-2107, In New method Shop_Ord_API.Get_So_Supply_Date is used to get the revised_due_date for a shop order. 
--  210126  RoJalk  SC2020R1-11621, Modified New to call New___ instead of Unpack methods.
--  210113  ErRalk  SC2020R1-11985, Removed unused variables in methods and method calls.
--  201016  RoJalk  Bug 154791(SCZ-11814), Modified Find_Source()to get a new parameter to identify it's for the DESADV or not.
--  201016          And modified if it is for DESADV then searching for the source is stop when deman code is 'ICT'
--  200221  ChBnlk  Bug 150799(SCZ-8677), Modified Find_Source() to exclude component part from getting the source as purchase order and made it possible to create 
--  200221          a new tree structure to the component part.  
--  190306  ChBnlk  Bug 147259 (SCZ-3194), Modified Find_Source() in order to get the PO reference properly if the PO is initiated from a DOP 
--  190306          in order to display the records in the analysis window properly.
--  181103  DilMlk  Bug 144731(SCZ-1461), Added new method Gen_Children_From_Ordchg___ and modified methods Generate_Child_Nodes___ and New to display
--  181103          order change requests in Supply Order Analysis window.
--  170313  TiRalk  STRSC-6162, Modified Gen_Children_From_Coline___ and Gen_Children_From_Poline_C___ to display replacement orders properly.
--  160718  DAYJLK  LIM-8119, Replaced usage of Purchase_Order_Line_API.Get_Qty_Arrived with Receipt_Info_API.Get_Sum_Qty_Arrived_By_Source. 
--  150902  SWiclk  Bug 124303, Modified Gen_Children_From_Coline___() in order to check the demand code when creating the child nodes from CO lines.
--  150130  ShKolk  Added Distribution order connected PO/CO.
--  141111  ShKolk  Added incoming_message and incoming_message_status_db to store message info related to PO and CO.
--  141021  SURBLK  Added header_status_ for New().
--  141010  ShKolk  Moved from ORDER component.
--  140919  NaLrlk  Modified Find_Source() to consider IPT_RO demand_code for replacement rental.
--  140625  RoJalk  Modified New method and added code to fetch client values for status.
--  130521  ShKolk  Created
-----------------------------------------------------------------------------

layer Core;

@AllowTableOrViewAccess CUSTOMER_ORDER_LINE_TAB
@AllowTableOrViewAccess CUSTOMER_ORDER_PUR_ORDER_TAB
@AllowTableOrViewAccess CUSTOMER_ORDER_SHOP_ORDER_TAB
@AllowTableOrViewAccess DISTRIBUTION_ORDER_TAB
@AllowTableOrViewAccess DOP_DEMAND_CUST_ORD_TAB
@AllowTableOrViewAccess DOP_ORDER_TAB
@AllowTableOrViewAccess DOP_SUPPLY_PURCH_ORD_TAB
@AllowTableOrViewAccess DOP_SUPPLY_PURCH_REQ_LINE_TAB
@AllowTableOrViewAccess DOP_SUPPLY_SHOP_ORD_TAB
@AllowTableOrViewAccess EXTERNAL_CUST_ORDER_LINE_TAB
@AllowTableOrViewAccess EXTERNAL_CUSTOMER_ORDER_TAB
@AllowTableOrViewAccess PURCHASE_ORDER_LINE_TAB
@AllowTableOrViewAccess PURCHASE_ORDER_TAB
@AllowTableOrViewAccess PURCHASE_REQ_LINE_TAB
@AllowTableOrViewAccess PURCHASE_REQUISITION_TAB
@AllowTableOrViewAccess SHOP_ORD_TAB


-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Node_Id___ (
   tree_id_ IN NUMBER ) RETURN NUMBER
IS
   node_id_   NUMBER;

   CURSOR get_next_node_id IS
      SELECT MAX(node_id)
      FROM SUPPLY_ORDER_ANALYSIS_TAB
      WHERE tree_id = tree_id_;
BEGIN
   OPEN get_next_node_id;
   FETCH get_next_node_id INTO node_id_;
   CLOSE get_next_node_id;
   IF (node_id_ IS NULL) THEN
      node_id_ := 0;
   ELSE
      node_id_ := node_id_ + 1;
   END IF;
   RETURN node_id_;
END Get_Next_Node_Id___;


PROCEDURE Generate_Child_Nodes___ (
   tree_id_        IN NUMBER,
   parent_node_id_ IN NUMBER,
   order_ref1_     IN VARCHAR2,
   order_ref2_     IN VARCHAR2,
   order_ref3_     IN VARCHAR2,
   order_ref4_     IN VARCHAR2,
   order_type_     IN VARCHAR2 )
IS
   dummy_           BOOLEAN := FALSE;
   purch_fetched_   BOOLEAN := FALSE;

BEGIN

   IF (order_type_ = 'PURCHASE_ORDER') THEN
      -- from Messages
      dummy_ := Gen_Children_From_Orders___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_);
      dummy_ := Gen_Children_From_Ordchg___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_);
      -- from ORDER
      dummy_ := Gen_Children_From_Coline___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);

   ELSIF (order_type_ = 'DOP_ORDER') THEN
      -- from ORDER
      dummy_         := Gen_Children_From_Coline___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      -- from PURCH
      purch_fetched_ := Gen_Children_From_Poline___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      IF (NOT purch_fetched_) THEN
         purch_fetched_ := Gen_Children_From_Poline_C___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      END IF;
      IF (NOT purch_fetched_) THEN
         purch_fetched_ := Gen_Children_From_Prline___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      END IF;
      IF (NOT purch_fetched_) THEN
         dummy_ := Gen_Children_From_Prline_C___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      END IF;
      -- from SHPORD
      dummy_ := Gen_Children_From_Shopord___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      dummy_ := Gen_Children_From_Shopord_C___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_);
      -- from DOP
      dummy_ := Gen_Children_From_Dop_Order___(tree_id_, parent_node_id_, order_ref1_, order_ref2_);
      dummy_ := Gen_Children_From_Dop_Pr___(tree_id_, parent_node_id_, order_ref1_, order_ref2_);
      dummy_ := Gen_Children_From_Dop_Po___(tree_id_, parent_node_id_, order_ref1_, order_ref2_);
      dummy_ := Gen_Children_From_Dop_Shop___(tree_id_, parent_node_id_, order_ref1_, order_ref2_);

   ELSIF (order_type_ = 'CUSTOMER_ORDER') THEN
      -- from PURCH
      purch_fetched_ := Gen_Children_From_Poline___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      IF (NOT purch_fetched_) THEN
         purch_fetched_ := Gen_Children_From_Poline_C___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      END IF;
      IF (NOT purch_fetched_) THEN
         purch_fetched_ := Gen_Children_From_Prline___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      END IF;
      IF (NOT purch_fetched_) THEN
         purch_fetched_ := Gen_Children_From_Prline_C___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      END IF;
      -- from SHPORD
      dummy_ := Gen_Children_From_Shopord___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      dummy_ := Gen_Children_From_Shopord_C___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_);
      -- from DOP
      dummy_ := Gen_Children_From_Dop_Head___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);

   ELSIF (order_type_ = 'PURCHASE_REQUISITION') THEN
      -- from PURCH
      purch_fetched_ := Gen_Children_From_Poline___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      IF (NOT purch_fetched_) THEN
         purch_fetched_ := Gen_Children_From_Poline_C___(tree_id_, parent_node_id_, order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      END IF;
   END IF;

END Generate_Child_Nodes___;

FUNCTION Gen_Children_From_Coline___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN VARCHAR2 ) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;

   $IF (Component_Order_SYS.INSTALLED) $THEN
   CURSOR get_children_from_coline IS
      SELECT order_no, line_no, rel_no, line_item_no
      FROM customer_order_line_tab
      WHERE demand_order_ref1 = order_ref1_
      AND   demand_order_ref2 = order_ref2_
      AND   demand_order_ref3 = order_ref3_
      AND   (demand_order_ref4 = order_ref4_ OR order_ref4_ IS NULL)
      AND   demand_code IN ('IPT', 'IPD', 'PO', 'IPT_RO');
   $END

   $IF (Component_Disord_SYS.INSTALLED) $THEN
   CURSOR get_children_from_coline_do IS
      SELECT col.order_no, line_no, rel_no, line_item_no
      FROM customer_order_line_tab col, distribution_order_tab do
      WHERE col.order_no     = do.co_order_no
      AND   col.line_no      = do.co_line_no
      AND   col.rel_no       = do.co_rel_no
      AND   col.line_item_no = do.co_line_item_no
      AND   do.po_order_no   = order_ref1_
      AND   do.po_line_no    = order_ref2_
      AND   do.po_rel_no     = order_ref3_
      AND   col.demand_code  = 'DO';
   $END
BEGIN
   -- Connected Customer Order lines
   $IF (Component_Order_SYS.INSTALLED) $THEN
   FOR child_co_rec_ IN get_children_from_coline LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, child_co_rec_.order_no, child_co_rec_.line_no, child_co_rec_.rel_no, to_char(child_co_rec_.line_item_no), 'CUSTOMER_ORDER');
      Generate_Child_Nodes___(tree_id_, node_id_, child_co_rec_.order_no, child_co_rec_.line_no, child_co_rec_.rel_no, to_char(child_co_rec_.line_item_no), 'CUSTOMER_ORDER');
   END LOOP;
   $END
   
   $IF (Component_Disord_SYS.INSTALLED) $THEN
   FOR child_co_rec_ IN get_children_from_coline_do LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, child_co_rec_.order_no, child_co_rec_.line_no, child_co_rec_.rel_no, to_char(child_co_rec_.line_item_no), 'CUSTOMER_ORDER');
      Generate_Child_Nodes___(tree_id_, node_id_, child_co_rec_.order_no, child_co_rec_.line_no, child_co_rec_.rel_no, to_char(child_co_rec_.line_item_no), 'CUSTOMER_ORDER');
   END LOOP;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Coline___;


FUNCTION Gen_Children_From_Prline___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN VARCHAR2 ) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;

   $IF (Component_Order_SYS.INSTALLED) $THEN
   CURSOR get_children_from_prline IS
      SELECT po_order_no, po_line_no, po_rel_no
      FROM customer_order_pur_order_tab
      WHERE oe_order_no     = order_ref1_
      AND   oe_line_no      = order_ref2_
      AND   oe_rel_no       = order_ref3_
      AND   oe_line_item_no = order_ref4_
      AND   purchase_type = 'R';
   $END

BEGIN
   -- Connected Purchase Requisition lines
   $IF (Component_Order_SYS.INSTALLED) $THEN
   FOR child_pr_rec_ IN get_children_from_prline LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, child_pr_rec_.po_order_no, child_pr_rec_.po_line_no, child_pr_rec_.po_rel_no, '', 'PURCHASE_REQUISITION');
      Generate_Child_Nodes___(tree_id_, node_id_, child_pr_rec_.po_order_no, child_pr_rec_.po_line_no, child_pr_rec_.po_rel_no, '', 'PURCHASE_REQUISITION');
   END LOOP;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Prline___;


FUNCTION Gen_Children_From_Prline_C___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN VARCHAR2 ) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;

   $IF (Component_Purch_SYS.INSTALLED) $THEN
   CURSOR get_children_from_prline_c IS
      SELECT requisition_no, line_no, release_no
      FROM purchase_req_line_tab
      WHERE demand_order_no     = order_ref1_
      AND   demand_release      = order_ref2_
      AND   demand_sequence_no  = order_ref3_
      AND   demand_operation_no = order_ref4_
      AND   demand_code IN ('CD', 'CT', 'ICT', 'ICD');
   $END

BEGIN
   -- Connected Purchase Requisition lines (Cancelled)
   $IF (Component_Purch_SYS.INSTALLED) $THEN
   FOR child_pr_rec_ IN get_children_from_prline_c LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, child_pr_rec_.requisition_no, child_pr_rec_.line_no, child_pr_rec_.release_no, '', 'PURCHASE_REQUISITION');
      Generate_Child_Nodes___(tree_id_, node_id_, child_pr_rec_.requisition_no, child_pr_rec_.line_no, child_pr_rec_.release_no, '', 'PURCHASE_REQUISITION');
   END LOOP;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Prline_C___;

FUNCTION Gen_Children_From_Poline___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN VARCHAR2 ) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;

   $IF (Component_Order_SYS.INSTALLED) $THEN
   CURSOR get_children_from_poline IS
      SELECT po_order_no, po_line_no, po_rel_no
      FROM customer_order_pur_order_tab
      WHERE oe_order_no     = order_ref1_
      AND   oe_line_no      = order_ref2_
      AND   oe_rel_no       = order_ref3_
      AND   oe_line_item_no = order_ref4_
      AND   purchase_type = 'O';
   $END

BEGIN
   -- Connected Purchase Order lines
   $IF (Component_Order_SYS.INSTALLED) $THEN
   FOR child_po_rec_ IN get_children_from_poline LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, child_po_rec_.po_order_no, child_po_rec_.po_line_no, child_po_rec_.po_rel_no, '', 'PURCHASE_ORDER');
      Generate_Child_Nodes___(tree_id_, node_id_, child_po_rec_.po_order_no, child_po_rec_.po_line_no, child_po_rec_.po_rel_no, '', 'PURCHASE_ORDER');
   END LOOP;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Poline___;


FUNCTION Gen_Children_From_Poline_C___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN VARCHAR2 ) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;

   $IF (Component_Purch_SYS.INSTALLED) $THEN
   CURSOR get_children_from_poline_c IS
      SELECT order_no, line_no, release_no
      FROM purchase_order_line_tab
      WHERE demand_order_no     = order_ref1_
      AND   demand_release      = order_ref2_
      AND   demand_sequence_no  = order_ref3_
      AND   demand_operation_no = order_ref4_
      AND   demand_code IN ('CD', 'CT', 'ICT', 'ICD', 'RPO');
   $END
BEGIN
   -- Connected Purchase Order lines (Cancelled)
   $IF (Component_Purch_SYS.INSTALLED) $THEN
   FOR child_po_rec_ IN get_children_from_poline_c LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, child_po_rec_.order_no, child_po_rec_.line_no, child_po_rec_.release_no, '', 'PURCHASE_ORDER');
      Generate_Child_Nodes___(tree_id_, node_id_, child_po_rec_.order_no, child_po_rec_.line_no, child_po_rec_.release_no, '', 'PURCHASE_ORDER');
   END LOOP;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Poline_C___;


FUNCTION Gen_Children_From_Shopord___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN VARCHAR2 ) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;

   $IF (Component_Order_SYS.INSTALLED) $THEN
   CURSOR get_children_from_shopord IS
      SELECT so_order_no, so_release_no, so_sequence_no
      FROM customer_order_shop_order_tab
      WHERE oe_order_no     = order_ref1_
      AND   oe_line_no      = order_ref2_
      AND   oe_rel_no       = order_ref3_
      AND   oe_line_item_no = order_ref4_;
   $END
BEGIN
   -- Connected Shop Orders
   $IF (Component_Order_SYS.INSTALLED) $THEN
   FOR child_so_rec_ IN get_children_from_shopord LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, child_so_rec_.so_order_no, child_so_rec_.so_release_no, child_so_rec_.so_sequence_no, '', 'SHOP_ORDER');
      Generate_Child_Nodes___(tree_id_, node_id_, child_so_rec_.so_order_no, child_so_rec_.so_release_no, child_so_rec_.so_sequence_no, '', 'SHOP_ORDER');
   END LOOP;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Shopord___;


FUNCTION Gen_Children_From_Shopord_C___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2 ) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;

   $IF (Component_Shpord_SYS.INSTALLED) $THEN
   CURSOR get_children_from_shopord_c IS
      SELECT order_no, release_no, sequence_no
      FROM shop_ord_tab
      WHERE source_order_no    = order_ref1_
      AND   source_release_no  = order_ref2_
      AND   source_sequence_no = order_ref3_;
   $END
BEGIN
   -- Connected Shop Orders (Cancelled)
   $IF (Component_Shpord_SYS.INSTALLED) $THEN
   FOR child_so_rec_ IN get_children_from_shopord_c LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, child_so_rec_.order_no, child_so_rec_.release_no, child_so_rec_.sequence_no, '', 'SHOP_ORDER');
      Generate_Child_Nodes___(tree_id_, node_id_, child_so_rec_.order_no, child_so_rec_.release_no, child_so_rec_.sequence_no, '', 'SHOP_ORDER');
   END LOOP;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Shopord_C___;


FUNCTION Gen_Children_From_Dop_Head___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN VARCHAR2 ) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;

   $IF (Component_Dop_SYS.INSTALLED) $THEN
   CURSOR get_children_from_dop_header IS
      SELECT dop.dop_id, dop.dop_order_id
      FROM dop_demand_cust_ord_tab dco, dop_order_tab dop
      WHERE dco.dop_id = dop.dop_id
      AND   dco.order_no     = order_ref1_
      AND   dco.line_no      = order_ref2_
      AND   dco.rel_no       = order_ref3_
      AND   dco.line_item_no = order_ref4_
      AND   dop.parent_dop_order_id = 0;
   $END
BEGIN
   -- Connected Dop Headers
   $IF (Component_Dop_SYS.INSTALLED) $THEN
   FOR dop_header_rec_ IN get_children_from_dop_header LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, to_char(dop_header_rec_.dop_id), to_char(dop_header_rec_.dop_order_id), '', '', 'DOP_ORDER');
      Generate_Child_Nodes___(tree_id_, node_id_, to_char(dop_header_rec_.dop_id), to_char(dop_header_rec_.dop_order_id), '', '', 'DOP_ORDER');
   END LOOP;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Dop_Head___;

FUNCTION Gen_Children_From_Dop_Order___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2 ) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;

   $IF (Component_Dop_SYS.INSTALLED) $THEN
   CURSOR get_children_from_dop_order IS
      SELECT dop_id, dop_order_id
      FROM dop_order_tab
      WHERE dop_id              = order_ref1_
      AND   parent_dop_order_id = order_ref2_;
   $END

BEGIN
   -- Connected Dop Orders
   $IF (Component_Dop_SYS.INSTALLED) $THEN
   FOR child_dop_rec_ IN get_children_from_dop_order LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, to_char(child_dop_rec_.dop_id), to_char(child_dop_rec_.dop_order_id), '', '', 'DOP_ORDER');
      Generate_Child_Nodes___(tree_id_, node_id_, to_char(child_dop_rec_.dop_id), to_char(child_dop_rec_.dop_order_id), '', '', 'DOP_ORDER');
   END LOOP;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Dop_Order___;

FUNCTION Gen_Children_From_Dop_Pr___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;

   $IF (Component_Dop_SYS.INSTALLED) $THEN
   CURSOR get_children_from_dop_pr IS
      SELECT requisition_no, line_no, release_no
      FROM dop_supply_purch_req_line_tab
      WHERE dop_id = order_ref1_
      AND   dop_order_id = order_ref2_;
   $END

BEGIN
   -- Purchase Requisition lines connected to Dop Order
   $IF (Component_Dop_SYS.INSTALLED) $THEN
   FOR child_dop_pr_rec_ IN get_children_from_dop_pr LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, child_dop_pr_rec_.requisition_no, child_dop_pr_rec_.line_no, child_dop_pr_rec_.release_no, '', 'PURCHASE_REQUISITION');
      Generate_Child_Nodes___(tree_id_, node_id_, child_dop_pr_rec_.requisition_no, child_dop_pr_rec_.line_no, child_dop_pr_rec_.release_no, '', 'PURCHASE_REQUISITION');
   END LOOP;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Dop_Pr___;

FUNCTION Gen_Children_From_Dop_Po___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;

   $IF (Component_Dop_SYS.INSTALLED) $THEN
   CURSOR get_children_from_dop_po IS
      SELECT order_no, line_no, release_no
      FROM dop_supply_purch_ord_tab
      WHERE dop_id = order_ref1_
      AND   dop_order_id = order_ref2_;
   $END

BEGIN
   -- Purchase Order lines connected to Dop Order
   $IF (Component_Dop_SYS.INSTALLED) $THEN
   FOR child_dop_po_rec_ IN get_children_from_dop_po LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, child_dop_po_rec_.order_no, child_dop_po_rec_.line_no, child_dop_po_rec_.release_no, '', 'PURCHASE_ORDER');
      Generate_Child_Nodes___(tree_id_, node_id_, child_dop_po_rec_.order_no, child_dop_po_rec_.line_no, child_dop_po_rec_.release_no, '', 'PURCHASE_ORDER');
   END LOOP;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Dop_Po___;

FUNCTION Gen_Children_From_Dop_Shop___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;

   $IF (Component_Dop_SYS.INSTALLED) $THEN
   CURSOR get_children_from_dop_shop IS
      SELECT order_no, release_no, sequence_no
      FROM dop_supply_shop_ord_tab
      WHERE dop_id = order_ref1_
      AND   dop_order_id = order_ref2_;
   $END

BEGIN
   -- Shop Orders connected to Dop Order
   $IF (Component_Dop_SYS.INSTALLED) $THEN
   FOR child_dop_shop_rec_ IN get_children_from_dop_shop LOOP
      child_fetched_ := TRUE;
      node_id_ := Get_Next_Node_Id___(tree_id_);
      New(tree_id_, node_id_, parent_node_id_, child_dop_shop_rec_.order_no, child_dop_shop_rec_.release_no, child_dop_shop_rec_.sequence_no, '', 'SHOP_ORDER');
      Generate_Child_Nodes___(tree_id_, node_id_, child_dop_shop_rec_.order_no, child_dop_shop_rec_.release_no, child_dop_shop_rec_.sequence_no, '', 'SHOP_ORDER');
   END LOOP;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Dop_Shop___;


FUNCTION Gen_Children_From_Orders___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2) RETURN BOOLEAN
IS
   node_id_         NUMBER;
   child_fetched_   BOOLEAN := FALSE;
   order_created_   NUMBER;

   $IF (Component_Order_SYS.INSTALLED) $THEN
   CURSOR get_children_from_orders IS
      SELECT l.message_id, l.message_line, l.rowstate
      FROM external_customer_order_tab h, external_cust_order_line_tab l
      WHERE h.message_id = l.message_id
      AND   h.internal_po_no = order_ref1_
      AND   l.line_no        = order_ref2_
      AND   l.rel_no         = order_ref3_
      AND   l.rowstate NOT IN ('Created', 'Cancelled');

   CURSOR get_order_created_messages IS
      SELECT 1
      FROM external_customer_order_tab h, external_cust_order_line_tab l
      WHERE h.message_id = l.message_id
      AND   h.internal_po_no = order_ref1_
      AND   l.line_no        = order_ref2_
      AND   l.rel_no         = order_ref3_
      AND   l.rowstate = 'Created';
   $END

BEGIN
   -- Incoming ORDERS messages
   $IF (Component_Order_SYS.INSTALLED) $THEN
   OPEN get_order_created_messages;
   FETCH get_order_created_messages INTO order_created_;
   CLOSE get_order_created_messages;

   IF (order_created_ IS NULL) THEN
      FOR inc_co_rec_ IN get_children_from_orders LOOP
         child_fetched_ := TRUE;
         node_id_ := Get_Next_Node_Id___(tree_id_);
         New(tree_id_, node_id_, parent_node_id_, inc_co_rec_.message_id, inc_co_rec_.message_line, '', '', 'ORDERS');
      END LOOP;
   END IF;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Orders___;

-- Generate children from incoming Change Requests
FUNCTION Gen_Children_From_Ordchg___ (
   tree_id_          IN NUMBER,
   parent_node_id_   IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2) RETURN BOOLEAN
IS
   node_id_           NUMBER;
   child_fetched_     BOOLEAN := FALSE;
   chg_child_fetched_ BOOLEAN := FALSE;
   order_created_     NUMBER;
   incoming_messages_ NUMBER;

   $IF (Component_Order_SYS.INSTALLED) $THEN
   CURSOR get_children_from_ordchg IS
      SELECT l.message_id, l.message_line, l.rowstate
      FROM ext_cust_order_change_tab h, ext_cust_order_line_change_tab l
      WHERE h.message_id = l.message_id
      AND   h.internal_po_no = order_ref1_
      AND   l.line_no        = order_ref2_
      AND   l.rel_no         = order_ref3_
      AND   l.rowstate NOT IN ('Processed', 'Cancelled');
      
   CURSOR get_incoming_orders_messages IS
      SELECT 1
      FROM external_customer_order_tab h, external_cust_order_line_tab l
      WHERE h.message_id = l.message_id
      AND   h.internal_po_no = order_ref1_
      AND   l.line_no        = order_ref2_
      AND   l.rel_no         = order_ref3_
      AND   l.rowstate NOT IN ('Created', 'Cancelled');
   
   CURSOR get_order_created_messages IS
      SELECT 1
      FROM external_customer_order_tab h, external_cust_order_line_tab l
      WHERE h.message_id = l.message_id
      AND   h.internal_po_no = order_ref1_
      AND   l.line_no        = order_ref2_
      AND   l.rel_no         = order_ref3_
      AND   l.rowstate = 'Created';   
   $END
   
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
   -- Incoming ORDCHG messages
   OPEN get_incoming_orders_messages;
   FETCH get_incoming_orders_messages INTO incoming_messages_;
   CLOSE get_incoming_orders_messages;
   
   OPEN get_order_created_messages;
   FETCH get_order_created_messages INTO order_created_;
   CLOSE get_order_created_messages;
   
   IF(incoming_messages_ IS NULL) THEN
      IF (order_created_ IS NULL) THEN
         FOR inc_chg_rec_ IN get_children_from_ordchg LOOP
            chg_child_fetched_ := TRUE;
            node_id_ := Get_Next_Node_Id___(tree_id_);
            New(tree_id_, node_id_, parent_node_id_, inc_chg_rec_.message_id, inc_chg_rec_.message_line, '', '', 'ORDCHG');
         END LOOP;
      END IF;
   END IF;
   $END

   RETURN child_fetched_;
END Gen_Children_From_Ordchg___;

PROCEDURE Delete_Tree___ (
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN VARCHAR2 )
IS
   remrec_   SUPPLY_ORDER_ANALYSIS_TAB%ROWTYPE;

   CURSOR get_trees IS
      SELECT tree_id
      FROM SUPPLY_ORDER_ANALYSIS_TAB
      WHERE order_ref1 = order_ref1_
      AND   order_ref2 = order_ref2_
      AND   order_ref3 = order_ref3_
      AND   (order_ref4 = order_ref4_ OR order_ref4_ IS NULL)
      AND   node_id = 0;

   CURSOR get_nodes(tree_id_ VARCHAR2) IS
      SELECT rowid objid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) objversion
      FROM SUPPLY_ORDER_ANALYSIS_TAB
      WHERE tree_id = tree_id_;

BEGIN
   FOR tree_ IN get_trees LOOP
      FOR node_ IN get_nodes(tree_.tree_id) LOOP
         remrec_ := Lock_By_Id___(node_.objid, node_.objversion);
         Check_Delete___(remrec_);
         Delete___(node_.objid, remrec_);
      END LOOP;
   END LOOP;

END Delete_Tree___;

PROCEDURE Delete_Old_Trees___ 
   
IS  
BEGIN
   
   DELETE FROM SUPPLY_ORDER_ANALYSIS_TAB
   WHERE rowversion < SYSDATE - 1;
   
END Delete_Old_Trees___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Tree_Id (
   order_ref1_     IN VARCHAR2,
   order_ref2_     IN VARCHAR2,
   order_ref3_     IN VARCHAR2,
   order_ref4_     IN VARCHAR2 ) RETURN NUMBER
IS
   tree_id_   NUMBER;

   CURSOR get_data IS
      SELECT tree_id
      FROM SUPPLY_ORDER_ANALYSIS_TAB
      WHERE order_ref1 = order_ref1_
      AND   order_ref2 = order_ref2_
      AND   order_ref3 = order_ref3_
      AND   (order_ref4 = order_ref4_ OR order_ref4_ IS NULL)
      AND   parent_node_id = 0;
BEGIN
   OPEN get_data;
   FETCH get_data INTO tree_id_;
   CLOSE get_data;
   RETURN tree_id_;
END Get_Tree_Id;


PROCEDURE New (
   tree_id_        IN NUMBER,
   node_id_        IN NUMBER,
   parent_node_id_ IN NUMBER,
   order_ref1_     IN VARCHAR2,
   order_ref2_     IN VARCHAR2,
   order_ref3_     IN VARCHAR2,
   order_ref4_     IN VARCHAR2,
   order_type_     IN VARCHAR2 )
IS
   attr_                         VARCHAR2(2000);
   info_                         VARCHAR2(2000);
   objid_                        VARCHAR2(2000);
   objversion_                   VARCHAR2(2000);

   contract_                     SUPPLY_ORDER_ANALYSIS_TAB.contract%TYPE;
   part_no_                      SUPPLY_ORDER_ANALYSIS_TAB.part_no%TYPE;
   status_db_                    SUPPLY_ORDER_ANALYSIS_TAB.status_db%TYPE;
   status_                       SUPPLY_ORDER_ANALYSIS_TAB.status%TYPE;
   header_status_db_             SUPPLY_ORDER_ANALYSIS_TAB.header_status_db%TYPE;
   header_status_                SUPPLY_ORDER_ANALYSIS_TAB.header_status%TYPE;
   customer_no_                  SUPPLY_ORDER_ANALYSIS_TAB.customer_no%TYPE;
   vendor_no_                    SUPPLY_ORDER_ANALYSIS_TAB.vendor_no%TYPE;
   demand_code_                  SUPPLY_ORDER_ANALYSIS_TAB.demand_code%TYPE;
   supply_code_                  SUPPLY_ORDER_ANALYSIS_TAB.supply_code%TYPE;
   condition_code_               SUPPLY_ORDER_ANALYSIS_TAB.condition_code%TYPE;
   wanted_delivery_date_         SUPPLY_ORDER_ANALYSIS_TAB.wanted_delivery_date%TYPE;
   planned_delivery_date_        SUPPLY_ORDER_ANALYSIS_TAB.planned_delivery_date%TYPE;
   planned_receipt_date_         SUPPLY_ORDER_ANALYSIS_TAB.planned_receipt_date%TYPE;
   planned_ship_date_            SUPPLY_ORDER_ANALYSIS_TAB.planned_ship_date%TYPE;
   revised_start_date_           SUPPLY_ORDER_ANALYSIS_TAB.revised_start_date%TYPE;
   revised_due_date_             SUPPLY_ORDER_ANALYSIS_TAB.revised_due_date%TYPE;
   ship_via_code_                SUPPLY_ORDER_ANALYSIS_TAB.ship_via_code%TYPE;
   quantity_                     SUPPLY_ORDER_ANALYSIS_TAB.quantity%TYPE;
   unit_meas_                    SUPPLY_ORDER_ANALYSIS_TAB.unit_meas%TYPE;
   qty_assigned_                 SUPPLY_ORDER_ANALYSIS_TAB.qty_assigned%TYPE;
   qty_picked_                   SUPPLY_ORDER_ANALYSIS_TAB.qty_picked%TYPE;
   qty_shipped_                  SUPPLY_ORDER_ANALYSIS_TAB.qty_shipped%TYPE;
   qty_arrived_                  SUPPLY_ORDER_ANALYSIS_TAB.qty_arrived%TYPE;
   qty_per_assembly_             SUPPLY_ORDER_ANALYSIS_TAB.qty_per_assembly%TYPE;
   revised_qty_due_              SUPPLY_ORDER_ANALYSIS_TAB.revised_qty_due%TYPE;
   qty_complete_                 SUPPLY_ORDER_ANALYSIS_TAB.qty_complete%TYPE;
   incoming_message_db_          SUPPLY_ORDER_ANALYSIS_TAB.incoming_message%TYPE;
   incoming_message_status_db_   SUPPLY_ORDER_ANALYSIS_TAB.incoming_message_status_db%TYPE;
   catalog_type_                 SUPPLY_ORDER_ANALYSIS_TAB.catalog_type%TYPE;
   newrec_                       SUPPLY_ORDER_ANALYSIS_TAB%ROWTYPE;

   $IF (Component_Order_SYS.INSTALLED) $THEN
   CURSOR get_coline_data IS
      SELECT contract, catalog_no, rowstate, customer_no, demand_code, supply_code, condition_code,
             wanted_delivery_date, planned_delivery_date, planned_ship_date,
             ship_via_code, buy_qty_due, sales_unit_meas, qty_assigned, qty_picked, qty_shipped, catalog_type
      FROM customer_order_line_tab
      WHERE order_no     = order_ref1_
      AND   line_no      = order_ref2_
      AND   rel_no       = order_ref3_
      AND   line_item_no = order_ref4_;
   coline_rec_   get_coline_data%ROWTYPE;

   CURSOR get_orders_data IS
      SELECT h.contract, l.customer_part_no, l.rowstate, h.rowstate header_rowstate, h.customer_no, l.condition_code,
             l.wanted_delivery_date, h.delivery_date,
             l.ship_via_code, l.customer_quantity
      FROM external_customer_order_tab h, external_cust_order_line_tab l
      WHERE h.message_id   = l.message_id
      AND   l.message_id   = order_ref1_
      AND   l.message_line = order_ref2_;
   orders_rec_   get_orders_data%ROWTYPE;

   CURSOR get_ordchg_data IS
      SELECT h.contract, l.customer_part_no, l.rowstate, h.rowstate header_rowstate, h.customer_no, l.condition_code,
             l.wanted_delivery_date, h.delivery_date,
             l.ship_via_code, l.customer_quantity
      FROM ext_cust_order_change_tab h, ext_cust_order_line_change_tab l
      WHERE h.message_id   = l.message_id
      AND   l.message_id   = order_ref1_
      AND   l.message_line = order_ref2_;
   ordchg_rec_   get_ordchg_data%ROWTYPE;
   $END

   $IF (Component_Purch_SYS.INSTALLED) $THEN
   CURSOR get_prline_data IS
      SELECT prl.contract, prl.rowstate, pr.rowstate header_rowstate, part_no, vendor_no, demand_code, condition_code,
             original_qty, unit_meas
      FROM purchase_requisition_tab pr, purchase_req_line_tab prl
      WHERE pr.requisition_no = prl.requisition_no
      AND   prl.requisition_no = order_ref1_
      AND   prl.line_no        = order_ref2_
      AND   prl.release_no     = order_ref3_;
   prline_rec_   get_prline_data%ROWTYPE;

   CURSOR get_poline_data IS
      SELECT pol.contract, pol.part_no, pol.rowstate, po.rowstate header_rowstate, po.vendor_no, pol.demand_code, pol.condition_code,
             pol.wanted_delivery_date, pol.planned_delivery_date, pol.planned_receipt_date,
             pol.ship_via_code, pol.buy_qty_due, pol.buy_unit_meas
      FROM purchase_order_tab po, purchase_order_line_tab pol
      WHERE po.order_no = pol.order_no
      AND   pol.order_no   = order_ref1_
      AND   pol.line_no    = order_ref2_
      AND   pol.release_no = order_ref3_;
   poline_rec_   get_poline_data%ROWTYPE;
   $END

   $IF (Component_Dop_SYS.INSTALLED) $THEN
   CURSOR get_dop_data IS
      SELECT contract, part_no, rowstate, condition_code,
             revised_start_date, revised_due_date,
             qty_per_assembly, revised_qty_due, qty_complete
      FROM dop_order_tab
      WHERE dop_id       = order_ref1_
      AND   dop_order_id =  order_ref2_;
   dop_rec_   get_dop_data%ROWTYPE;
   $END

   $IF (Component_Shpord_SYS.INSTALLED) $THEN
   CURSOR get_soline_data IS
      SELECT contract, part_no, rowstate, customer_no, demand_code, condition_code,
             revised_start_date, qty_on_order, qty_complete
      FROM shop_ord_tab
      WHERE order_no    = order_ref1_
      AND   release_no  = order_ref2_
      AND   sequence_no = order_ref3_;
   soline_rec_   get_soline_data%ROWTYPE;
   $END

BEGIN

   IF (order_type_ = 'CUSTOMER_ORDER') THEN
      $IF (Component_Order_SYS.INSTALLED) $THEN

      OPEN get_coline_data;
      FETCH get_coline_data INTO coline_rec_;
      CLOSE get_coline_data;

      contract_                   := coline_rec_.contract;
      status_db_                  := coline_rec_.rowstate;
      status_                     := Customer_Order_Line_API.Get_State(order_ref1_, order_ref2_, order_ref3_, order_ref4_);
      header_status_db_           := Customer_Order_API.Get_Objstate(order_ref1_);
      header_status_              := Customer_Order_API.Get_State(order_ref1_);
      part_no_                    := coline_rec_.catalog_no;
      customer_no_                := coline_rec_.customer_no;
      vendor_no_                  := NULL;
      demand_code_                := coline_rec_.demand_code;
      supply_code_                := coline_rec_.supply_code;
      condition_code_             := coline_rec_.condition_code;
      wanted_delivery_date_       := coline_rec_.wanted_delivery_date;
      planned_delivery_date_      := coline_rec_.planned_delivery_date;
      planned_receipt_date_       := NULL;
      planned_ship_date_          := coline_rec_.planned_ship_date;
      revised_start_date_         := NULL;
      revised_due_date_           := NULL;
      ship_via_code_              := coline_rec_.ship_via_code;
      quantity_                   := coline_rec_.buy_qty_due;
      unit_meas_                  := coline_rec_.sales_unit_meas;
      qty_assigned_               := coline_rec_.qty_assigned;
      qty_picked_                 := coline_rec_.qty_picked;
      qty_shipped_                := coline_rec_.qty_shipped;
      qty_arrived_                := NULL;
      qty_per_assembly_           := NULL;
      revised_qty_due_            := NULL;
      qty_complete_               := NULL;
      Ext_Cust_Order_Line_Change_API.Get_Request_Info(incoming_message_db_, incoming_message_status_db_, order_ref1_, order_ref2_, order_ref3_);
      catalog_type_               := coline_rec_.catalog_type;

      $ELSE
      NULL;
      $END

   ELSIF (order_type_ = 'PURCHASE_REQUISITION') THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN

      OPEN get_prline_data;
      FETCH get_prline_data INTO prline_rec_;
      CLOSE get_prline_data;

      contract_                   := prline_rec_.contract;
      status_db_                  := prline_rec_.rowstate;
      status_                     := Purchase_Req_Line_API.Get_State(order_ref1_, order_ref2_, order_ref3_);
      header_status_db_           := prline_rec_.header_rowstate;
      header_status_              := Purchase_Requisition_API.Get_State(order_ref1_);
      part_no_                    := prline_rec_.part_no;
      customer_no_                := NULL;
      vendor_no_                  := prline_rec_.vendor_no;
      demand_code_                := prline_rec_.demand_code;
      supply_code_                := NULL;
      condition_code_             := prline_rec_.condition_code;
      wanted_delivery_date_       := NULL;
      planned_delivery_date_      := NULL;
      planned_receipt_date_       := NULL;
      planned_ship_date_          := NULL;
      revised_start_date_         := NULL;
      revised_due_date_           := NULL;
      ship_via_code_              := NULL;
      quantity_                   := prline_rec_.original_qty;
      unit_meas_                  := prline_rec_.unit_meas;
      qty_assigned_               := NULL;
      qty_picked_                 := NULL;
      qty_shipped_                := NULL;
      qty_arrived_                := NULL;
      qty_per_assembly_           := NULL;
      revised_qty_due_            := NULL;
      qty_complete_               := NULL;
      incoming_message_db_        := 'FALSE';
      incoming_message_status_db_ := NULL;
      catalog_type_               := NULL;

      $ELSE
      NULL;
      $END

   ELSIF (order_type_ = 'PURCHASE_ORDER') THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN

      OPEN get_poline_data;
      FETCH get_poline_data INTO poline_rec_;
      CLOSE get_poline_data;

      contract_                   := poline_rec_.contract;
      status_db_                  := poline_rec_.rowstate;
      status_                     := Purchase_Order_Line_API.Get_State(order_ref1_, order_ref2_, order_ref3_);
      header_status_db_           := poline_rec_.header_rowstate;
      header_status_              := Purchase_Order_API.Get_State(order_ref1_);
      part_no_                    := poline_rec_.part_no;
      customer_no_                := NULL;
      vendor_no_                  := poline_rec_.vendor_no;
      demand_code_                := poline_rec_.demand_code;
      supply_code_                := NULL;
      condition_code_             := poline_rec_.condition_code;
      wanted_delivery_date_       := poline_rec_.wanted_delivery_date;
      planned_delivery_date_      := poline_rec_.planned_delivery_date;
      planned_receipt_date_       := poline_rec_.planned_receipt_date;
      planned_ship_date_          := NULL;
      revised_start_date_         := NULL;
      revised_due_date_           := NULL;
      ship_via_code_              := poline_rec_.ship_via_code;
      quantity_                   := poline_rec_.buy_qty_due;
      unit_meas_                  := poline_rec_.buy_unit_meas;
      qty_assigned_               := NULL;
      qty_picked_                 := NULL;
      qty_shipped_                := NULL;
      qty_arrived_                := Receipt_Info_API.Get_Sum_Qty_Arrived_By_Source(order_ref1_, order_ref2_, order_ref3_, NULL, Logistics_Source_Ref_Type_API.DB_PURCHASE_ORDER, NULL);
      qty_per_assembly_           := NULL;
      revised_qty_due_            := NULL;
      qty_complete_               := NULL;
      Purchase_Order_Resp_Line_API.Get_Response_Info(incoming_message_db_, incoming_message_status_db_, order_ref1_, order_ref2_, order_ref3_);
      catalog_type_               := NULL;

      $ELSE
      NULL;
      $END

   ELSIF (order_type_ = 'DOP_ORDER') THEN
      $IF (Component_Dop_SYS.INSTALLED) $THEN

      OPEN get_dop_data;
      FETCH get_dop_data INTO dop_rec_;
      CLOSE get_dop_data;

      contract_                   := dop_rec_.contract;
      status_db_                  := '';
      status_                     := '';
      header_status_db_           := dop_rec_.rowstate;
      header_status_              := Dop_Order_API.Get_State(order_ref1_, order_ref2_);
      part_no_                    := dop_rec_.part_no;
      customer_no_                := NULL;
      vendor_no_                  := NULL;
      demand_code_                := NULL;
      supply_code_                := NULL;
      condition_code_             := dop_rec_.condition_code;
      wanted_delivery_date_       := NULL;
      planned_delivery_date_      := NULL;
      planned_receipt_date_       := NULL;
      planned_ship_date_          := NULL;
      revised_start_date_         := dop_rec_.revised_start_date;
      revised_due_date_           := dop_rec_.revised_due_date;
      ship_via_code_              := NULL;
      quantity_                   := NULL;
      unit_meas_                  := NULL;
      qty_assigned_               := NULL;
      qty_picked_                 := NULL;
      qty_shipped_                := NULL;
      qty_arrived_                := NULL;
      qty_per_assembly_           := dop_rec_.qty_per_assembly;
      revised_qty_due_            := dop_rec_.revised_qty_due;
      qty_complete_               := dop_rec_.qty_complete;
      incoming_message_db_        := 'FALSE';
      incoming_message_status_db_ := NULL;
      catalog_type_               := NULL;

      $ELSE
      NULL;
      $END

   ELSIF (order_type_ = 'SHOP_ORDER') THEN
      $IF (Component_Shpord_SYS.INSTALLED) $THEN

      OPEN get_soline_data;
      FETCH get_soline_data INTO soline_rec_;
      CLOSE get_soline_data;

      contract_                   := soline_rec_.contract;
      status_db_                  := '';
      status_                     := '';
      header_status_db_           := soline_rec_.rowstate;
      header_status_              := Shop_ord_API.Get_State(order_ref1_, order_ref2_, order_ref3_);
      part_no_                    := soline_rec_.part_no;
      customer_no_                := soline_rec_.customer_no;
      vendor_no_                  := NULL;
      demand_code_                := soline_rec_.demand_code;
      supply_code_                := NULL;
      condition_code_             := soline_rec_.condition_code;
      wanted_delivery_date_       := NULL;
      planned_delivery_date_      := NULL;
      planned_receipt_date_       := NULL;
      planned_ship_date_          := NULL;
      revised_start_date_         := soline_rec_.revised_start_date;
      revised_due_date_           := Shop_Ord_API.Get_So_Supply_Date(order_ref1_, order_ref2_, order_ref3_);
      ship_via_code_              := NULL;
      quantity_                   := soline_rec_.qty_on_order;
      unit_meas_                  := Inventory_Part_API.Get_Unit_Meas(soline_rec_.contract, soline_rec_.part_no);
      qty_assigned_               := NULL;
      qty_picked_                 := NULL;
      qty_shipped_                := NULL;
      qty_arrived_                := NULL;
      qty_per_assembly_           := NULL;
      revised_qty_due_            := NULL;
      qty_complete_               := soline_rec_.qty_complete;
      incoming_message_db_        := 'FALSE';
      incoming_message_status_db_ := NULL;
      catalog_type_               := NULL;

      $ELSE
      NULL;
      $END

   ELSIF (order_type_ = 'ORDERS') THEN
      $IF (Component_Order_SYS.INSTALLED) $THEN

      OPEN get_orders_data;
      FETCH get_orders_data INTO orders_rec_;
      CLOSE get_orders_data;

      contract_                   := orders_rec_.contract;
      status_db_                  := orders_rec_.rowstate;
      status_                     := External_Cust_Order_Line_API.Get_State(order_ref1_, order_ref2_);
      header_status_db_           := orders_rec_.header_rowstate;
      header_status_              := External_Customer_Order_API.Get_State(order_ref1_);
      part_no_                    := orders_rec_.customer_part_no;
      customer_no_                := orders_rec_.customer_no;
      vendor_no_                  := NULL;
      demand_code_                := NULL;
      supply_code_                := NULL;
      condition_code_             := orders_rec_.condition_code;
      wanted_delivery_date_       := orders_rec_.wanted_delivery_date;
      planned_delivery_date_      := orders_rec_.delivery_date;
      planned_receipt_date_       := NULL;
      planned_ship_date_          := NULL;
      revised_start_date_         := NULL;
      revised_due_date_           := NULL;
      ship_via_code_              := orders_rec_.ship_via_code;
      quantity_                   := orders_rec_.customer_quantity;
      unit_meas_                  := NULL;
      qty_assigned_               := NULL;
      qty_picked_                 := NULL;
      qty_shipped_                := NULL;
      qty_arrived_                := NULL;
      qty_per_assembly_           := NULL;
      revised_qty_due_            := NULL;
      qty_complete_               := NULL;
      incoming_message_db_        := 'FALSE';
      incoming_message_status_db_ := NULL;
      catalog_type_               := NULL;

      $ELSE
      NULL;
      $END
   
   ELSIF (order_type_ = 'ORDCHG') THEN     
      $IF (Component_Order_SYS.INSTALLED) $THEN

      OPEN get_ordchg_data;
      FETCH get_ordchg_data INTO ordchg_rec_;
      CLOSE get_ordchg_data;

      contract_                   := ordchg_rec_.contract;
      status_db_                  := ordchg_rec_.rowstate;
      status_                     := Ext_Cust_Order_Line_Change_API.Finite_State_Decode__(ordchg_rec_.rowstate);
      header_status_db_           := ordchg_rec_.header_rowstate;
      header_status_              := Ext_Cust_Order_Change_API.Finite_State_Decode__(ordchg_rec_.rowstate);
      part_no_                    := ordchg_rec_.customer_part_no;
      customer_no_                := ordchg_rec_.customer_no;
      vendor_no_                  := NULL;
      demand_code_                := NULL;
      supply_code_                := NULL;
      condition_code_             := ordchg_rec_.condition_code;
      wanted_delivery_date_       := ordchg_rec_.wanted_delivery_date;
      planned_delivery_date_      := ordchg_rec_.delivery_date;
      planned_receipt_date_       := NULL;
      planned_ship_date_          := NULL;
      revised_start_date_         := NULL;
      revised_due_date_           := NULL;
      ship_via_code_              := ordchg_rec_.ship_via_code;
      quantity_                   := ordchg_rec_.customer_quantity;
      unit_meas_                  := NULL;
      qty_assigned_               := NULL;
      qty_picked_                 := NULL;
      qty_shipped_                := NULL;
      qty_arrived_                := NULL;
      qty_per_assembly_           := NULL;
      revised_qty_due_            := NULL;
      qty_complete_               := NULL;
      incoming_message_db_        := 'TRUE';
      incoming_message_status_db_ := NULL;
      catalog_type_               := NULL;

      $ELSE
      NULL;
      $END
   END IF;

   newrec_.tree_id                    := tree_id_;
   newrec_.node_id                    := node_id_;
   newrec_.parent_node_id             := parent_node_id_;
   newrec_.order_ref1                 := order_ref1_;
   newrec_.order_ref2                 := order_ref2_;
   newrec_.order_ref3                 := order_ref3_;
   newrec_.order_ref4                 := order_ref4_;
   newrec_.order_type                 := order_type_;
   newrec_.contract                   := contract_;
   newrec_.part_no                    := part_no_;
   newrec_.status_db                  := status_db_;
   newrec_.status                     := status_;
   newrec_.header_status_db           := header_status_db_;
   newrec_.header_status              := header_status_;
   newrec_.customer_no                := customer_no_;
   newrec_.vendor_no                  := vendor_no_;
   newrec_.demand_code                := demand_code_;
   newrec_.supply_code                := supply_code_;
   newrec_.condition_code             := condition_code_;
   newrec_.wanted_delivery_date       := wanted_delivery_date_;
   newrec_.planned_delivery_date      := planned_delivery_date_;
   newrec_.planned_receipt_date       := planned_receipt_date_;
   newrec_.planned_ship_date          := planned_ship_date_;
   newrec_.revised_start_date         := revised_start_date_;
   newrec_.revised_due_date           := revised_due_date_;
   newrec_.ship_via_code              := ship_via_code_;
   newrec_.quantity                   := quantity_;
   newrec_.unit_meas                  := unit_meas_;
   newrec_.qty_assigned               := qty_assigned_;
   newrec_.qty_picked                 := qty_picked_;
   newrec_.qty_shipped                := qty_shipped_;
   newrec_.qty_arrived                := qty_arrived_;
   newrec_.qty_per_assembly           := qty_per_assembly_;
   newrec_.revised_qty_due            := revised_qty_due_;
   newrec_.qty_complete               := qty_complete_;
   newrec_.incoming_message           := incoming_message_db_;
   newrec_.incoming_message_status_db := incoming_message_status_db_;
   newrec_.catalog_type               := catalog_type_;

   New___(newrec_);
   
END New;


@UncheckedAccess
PROCEDURE Generate_Tree (
   tree_id_     OUT NUMBER,
   source_ref1_ IN  VARCHAR2,
   source_ref2_ IN  VARCHAR2,
   source_ref3_ IN  VARCHAR2,
   source_ref4_ IN  VARCHAR2,
   source_type_ IN  VARCHAR2 )
IS

BEGIN
  
   --Removes Tree structures older than 1 day.
   Delete_Old_Trees___();
   
   -- Delete previous tree structure
   Delete_Tree___(source_ref1_, source_ref2_, source_ref3_, source_ref4_);

   SELECT supply_order_analysis_seq.NEXTVAL INTO tree_id_ FROM DUAL;

   -- Create parent node
   New(tree_id_, 0, NULL, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_type_);

   -- Create child nodes for the parent node
   Generate_Child_Nodes___(tree_id_, 0, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_type_);

END Generate_Tree;


PROCEDURE Find_Source (
   source_ref1_ OUT VARCHAR2,
   source_ref2_ OUT VARCHAR2,
   source_ref3_ OUT VARCHAR2,
   source_ref4_ OUT VARCHAR2,
   source_type_ OUT VARCHAR2,
   order_ref1_  IN  VARCHAR2,
   order_ref2_  IN  VARCHAR2,
   order_ref3_  IN  VARCHAR2,
   order_ref4_  IN  VARCHAR2,
   order_type_  IN  VARCHAR2,
   from_desadv_ IN  BOOLEAN DEFAULT FALSE)
IS
   $IF (Component_Order_SYS.INSTALLED) $THEN
      coline_rec_   Customer_Order_Line_API.Public_Rec;
   $END
   
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      poline_rec_   Purchase_Order_Line_API.Public_Rec;
   $END
   
   $IF (Component_Dop_SYS.INSTALLED) $THEN
      dop_rec_   Dop_Order_API.Public_Rec;
      CURSOR get_order_data IS
         SELECT order_no, line_no, rel_no, line_item_no 
         FROM  dop_demand_cust_ord_tab
         WHERE dop_id = order_ref1_;     
      order_rec_   get_order_data%ROWTYPE;
      
      CURSOR get_purch_data IS
         SELECT order_no, line_no, release_no 
         FROM  dop_supply_purch_ord_tab
         WHERE dop_id = order_ref1_;     
      purch_rec_   get_purch_data%ROWTYPE;
   $END
   
   $IF (Component_Disord_SYS.INSTALLED) $THEN
      po_order_no_   distribution_order_tab.po_order_no%TYPE;
      po_line_no_    distribution_order_tab.po_line_no%TYPE;
      po_rel_no_     distribution_order_tab.po_rel_no%TYPE;
   $END
   
BEGIN
   IF (order_type_ = 'CUSTOMER_ORDER') THEN
      $IF (Component_Order_SYS.INSTALLED) $THEN
         coline_rec_ := Customer_Order_Line_API.Get(order_ref1_, order_ref2_, order_ref3_, order_ref4_);

         IF ( NOT(coline_rec_.line_item_no > 0 ) AND (coline_rec_.demand_code IN ('IPD', 'IPT', 'PD', 'PT', 'IPT_RO'))) THEN
            -- Source of this request is a Purchase Order
            Find_Source(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_type_,
                        coline_rec_.demand_order_ref1, coline_rec_.demand_order_ref2, coline_rec_.demand_order_ref3, coline_rec_.demand_order_ref4, 'PURCHASE_ORDER', from_desadv_);
         ELSIF (coline_rec_.demand_code = 'DO') THEN
            -- Source of this request is a Distribution Order
            Find_Source(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_type_,
                        coline_rec_.demand_order_ref1, NULL, NULL, NULL, 'DISTRIBUTION_ORDER');
         ELSE
            -- Source request is a Customer Order
            source_type_ := order_type_;
            source_ref1_ := order_ref1_;
            source_ref2_ := order_ref2_;
            source_ref3_ := order_ref3_;
            source_ref4_ := order_ref4_;
         END IF;
      $ELSE
         -- ORDER not installed so the source request is a Purchase Order
         source_type_ := 'PURCHASE_ORDER';
         source_ref1_ := order_ref1_;
         source_ref2_ := order_ref2_;
         source_ref3_ := order_ref3_;
         source_ref4_ := order_ref4_;
      $END

   ELSIF (order_type_ = 'PURCHASE_ORDER') THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         poline_rec_ := Purchase_Order_Line_API.Get(order_ref1_, order_ref2_, order_ref3_);

         IF ((poline_rec_.demand_code IN ('ICD', 'CD', 'CT')) OR (from_desadv_ = FALSE AND poline_rec_.demand_code = 'ICT')) THEN
            -- Source of this request is a Customer Order
            Find_Source(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_type_,
                        poline_rec_.demand_order_no, poline_rec_.demand_release, poline_rec_.demand_sequence_no, poline_rec_.demand_operation_no, 'CUSTOMER_ORDER', from_desadv_);
         ELSIF (poline_rec_.demand_code = 'DOP') THEN
            Find_Source(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_type_,
                        poline_rec_.demand_order_no, poline_rec_.demand_release, poline_rec_.demand_sequence_no, poline_rec_.demand_operation_no, 'DOP'); 
         ELSE
            -- Source request is a Purchase Order
            source_type_ := order_type_;
            source_ref1_ := order_ref1_;
            source_ref2_ := order_ref2_;
            source_ref3_ := order_ref3_;
            source_ref4_ := order_ref4_;
         END IF;
      $ELSE
         -- PURCH not installed so the source request is a Customer Order
         source_type_ := 'CUSTOMER_ORDER';
         source_ref1_ := order_ref1_;
         source_ref2_ := order_ref2_;
         source_ref3_ := order_ref3_;
         source_ref4_ := order_ref4_;
      $END
   
   ELSIF (order_type_ = 'DOP') THEN
      $IF (Component_Dop_SYS.INSTALLED) $THEN
         IF dop_rec_.parent_dop_order_id != 0 THEN
            dop_rec_ := Dop_Order_API.Get(order_ref1_, order_ref2_);     
            Find_Source(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_type_,
                        dop_rec_.dop_id, dop_rec_.parent_dop_order_id, '', '', 'DOP'); 
         ELSE
            OPEN get_order_data;
            FETCH get_order_data INTO order_rec_;
            CLOSE get_order_data;

            IF (order_rec_.order_no IS NOT NULL AND order_rec_.line_no IS NOT NULL AND order_rec_.rel_no IS NOT NULL AND order_rec_.line_item_no IS NOT NULL) THEN
               Find_Source(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_type_,
                        order_rec_.order_no, order_rec_.line_no, order_rec_.rel_no, order_rec_.line_item_no, 'CUSTOMER_ORDER');
            ELSE
               OPEN get_purch_data;
               FETCH get_purch_data INTO purch_rec_;
               CLOSE get_purch_data;
               
               source_type_ := 'PURCHASE_ORDER';
               source_ref1_ := purch_rec_.order_no;
               source_ref2_ := purch_rec_.line_no;
               source_ref3_ := purch_rec_.release_no;
               source_ref4_ := NULL;
            END IF; 
         END IF;
      $ELSE
         NULL;
      $END
      
   ELSIF (order_type_ = 'DISTRIBUTION_ORDER') THEN
      $IF (Component_Disord_SYS.INSTALLED) $THEN
         Distribution_Order_API.Get_Purchase_Order_Info(po_order_no_, po_line_no_, po_rel_no_, order_ref1_);
         IF (po_order_no_ IS NOT NULL AND po_line_no_ IS NOT NULL AND po_rel_no_ IS NOT NULL) THEN
            Find_Source(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_type_,
                        po_order_no_, po_line_no_, po_rel_no_, NULL, 'PURCHASE_ORDER');
         END IF;
      $ELSE
         NULL;
      $END
   
   END IF;

END Find_Source;

