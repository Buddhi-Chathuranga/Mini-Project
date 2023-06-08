---------------------------------------------------------------------
--
--  File: POST_Discom_Messages.sql
--
--  Module        : DISCOM
--
--  Purpose       : Create Message Classes for ORDER, PURCH and RCEIPT, depending on their availabllity.
--
--  Note          :
--
--
--  Date    Sign    History
--  ------  ----    -------------------------------------------------
--  170321  KiSalk  Created.
---------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_Discom_Messages.sql','Timestamp_1');
PROMPT Connectivity Create Message Classes ORDERS, ORDCHG, ORDRSP, DIRDEL, DESADV, PRICAT, SBIINV, RECADV...

DECLARE
   is_conn_msg_installed_ BOOLEAN;
   orders_action_method_  VARCHAR2(100);
   ordchg_action_method_  VARCHAR2(100);
   sbiinv_action_method_  VARCHAR2(100);
   recadv_action_method_  VARCHAR2(100);
   ordrsp_action_method_  VARCHAR2(100);
   dirdel_action_method_  VARCHAR2(100);
   pricat_action_method_  VARCHAR2(100);
   desadv_action_method_  VARCHAR2(100);
   desadv_module_         VARCHAR2(10);
   module_                VARCHAR2(10) := 'ORDER';

   PROCEDURE Activate_Class (
      class_id_  IN VARCHAR2 )
   IS
      info_         VARCHAR2(100);
      objid_        VARCHAR2(100);
      objv_         VARCHAR2(2000);
      attr_         VARCHAR2(2000);
      not_installed EXCEPTION;
      PRAGMA exception_init(not_installed, -20115);

      CURSOR c1 IS
         SELECT objid, objversion
         FROM   message_class
         WHERE  class_id = class_id_;
   BEGIN
      OPEN c1;
      FETCH c1 INTO objid_, objv_;
      IF ( c1%NOTFOUND ) THEN
         RAISE not_installed;
      END IF;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('SEND_DB', 'TRUE', attr_);
      Client_SYS.Add_To_Attr('RECEIVE_DB', 'TRUE', attr_);
      Message_Class_API.Modify__(info_, objid_, objv_, attr_, 'DO');
      EXCEPTION
        WHEN others THEN
           dbms_output.put_line(sqlerrm);
   END Activate_Class;

   FUNCTION Is_Installed (
      class_id_  IN VARCHAR2 ) RETURN BOOLEAN
   IS
      temp_         NUMBER;
      found_        BOOLEAN;

      CURSOR message_class_ IS
         SELECT 1
           FROM message_class
          WHERE class_id = class_id_;
   BEGIN
      OPEN message_class_;
      FETCH message_class_ INTO temp_;
      IF (message_class_%NOTFOUND) THEN
         found_ := FALSE;
      ELSE
         found_ := TRUE;
      END IF;
      CLOSE message_class_;
      RETURN found_;
   EXCEPTION
      WHEN OTHERS THEN
         IF (message_class_%ISOPEN) THEN
            CLOSE message_class_;
         END IF;
      RETURN FALSE;
   END Is_Installed;

BEGIN
   IF ( Component_Order_SYS.INSTALLED ) THEN
      orders_action_method_ := 'Customer_Order_Transfer_API.Receive_Order';
      ordchg_action_method_ := 'Customer_Order_Transfer_API.Receive_Order_Change';
      sbiinv_action_method_ := 'Customer_Order_Transfer_API.Receive_Self_Billing_Invoice';
      recadv_action_method_ := 'Customer_Order_Transfer_API.Receive_Receiving_Advice';

      -- Create MessageClass ORDCHG
      is_conn_msg_installed_ := Is_Installed('ORDCHG');
      Connectivity_SYS.Create_Message_Class('ORDCHG', ordchg_action_method_, 'Used to send changed orders from IFS Purchase Order to IFS Customer Order for approval.', 'ORDER');
      IF NOT is_conn_msg_installed_ THEN
         Activate_Class('ORDCHG');
      END IF;

      Connectivity_SYS.Create_Message_Class('HSE_CUST_ORDER_DELIVERY.ADD', NULL, 'Used to send customer order delivery information for parts with HSE_Contract set in Part Catalog.', 'ORDER');

   END IF;

   IF ( Component_Purch_SYS.INSTALLED ) THEN
      ordrsp_action_method_ := 'Purchase_Order_Transfer_API.Receive_Order_Response';
      dirdel_action_method_ := 'Purchase_Order_Transfer_API.Receive_Direct_Delivery';
      pricat_action_method_ := 'Price_Catalog_Transfer_API.Receive_Price_Catalog';
      module_ := 'PURCH';
   END IF;

   IF (Component_Order_SYS.INSTALLED OR Component_Purch_SYS.INSTALLED ) THEN

      -- Create MessageClass ORDERS
      is_conn_msg_installed_ := Is_Installed('ORDERS');
      Connectivity_SYS.Create_Message_Class('ORDERS', orders_action_method_, 'Used to send orders from IFS Purchase Order to IFS Customer Order for approval.', module_);
      IF NOT is_conn_msg_installed_ THEN
         Activate_Class('ORDERS');
      END IF;

      -- Create MessageClass SBIINV
      is_conn_msg_installed_ := Is_Installed('SBIINV');
      Connectivity_SYS.Create_Message_Class('SBIINV', sbiinv_action_method_, 'Used to send self-billing information from IFS Purchase Order to IFS Customer Order.', module_);
      IF NOT is_conn_msg_installed_ THEN
         Activate_Class('SBIINV');
      END IF;

      -- Create MessageClass RECADV
      is_conn_msg_installed_ := Is_Installed('RECADV');
      Connectivity_SYS.Create_Message_Class('RECADV', recadv_action_method_, 'Used to send receiving advice from IFS Purchase Order to IFS Customer Order.', module_);
      IF NOT is_conn_msg_installed_ THEN
         Activate_Class('RECADV');
      END IF;

      -- Create MessageClass ORDRSP
      is_conn_msg_installed_ := Is_Installed('ORDRSP');
      Connectivity_SYS.Create_Message_Class('ORDRSP', ordrsp_action_method_, 'Used to send order response from IFS Customer Order to IFS Purchase Order.', module_);
      IF NOT is_conn_msg_installed_ THEN
         Activate_Class('ORDRSP');
      END IF;

      -- Create MessageClass DIRDEL
      is_conn_msg_installed_ := Is_Installed('DIRDEL');
      Connectivity_SYS.Create_Message_Class('DIRDEL', dirdel_action_method_, 'Used to send direct delivery message from IFS Customer Order to IFS Purchase Order.', module_);
      IF NOT is_conn_msg_installed_ THEN
         Activate_Class('DIRDEL');
      END IF;

      -- Create MessageClass PRICAT
      is_conn_msg_installed_ := Is_Installed('PRICAT');
      Connectivity_SYS.Create_Message_Class('PRICAT', pricat_action_method_, 'Used to send pricing information from IFS Customer Order to IFS Purchasing.', module_);
      IF NOT is_conn_msg_installed_ THEN
         Activate_Class('PRICAT');
      END IF;
   END IF;

   -- Create or edit MessageClass DESADV
   IF (Component_Order_SYS.INSTALLED OR Component_Shpmnt_SYS.INSTALLED OR Component_Rceipt_SYS.INSTALLED) THEN
      is_conn_msg_installed_ := Is_Installed('DESADV');
      IF (Component_Rceipt_SYS.INSTALLED) THEN
         desadv_module_ := 'RCEIPT';
         desadv_action_method_ := 'Receipt_Info_Transfer_API.Receive_Dispatch_Advice';
      ELSIF Component_Order_SYS.INSTALLED THEN
         desadv_module_ := 'ORDER';
      ELSE
         desadv_module_ := 'SHPMNT';
      END IF;
      IF (Component_Rceipt_SYS.INSTALLED OR NOT is_conn_msg_installed_) THEN
         Connectivity_SYS.Create_Message_Class('DESADV', desadv_action_method_, 'Used to send inbound dispatch advice from Shipment to Receipt.', desadv_module_);
         Activate_Class('DESADV');
      END IF;
      Basic_Data_Translation_API.Insert_Prog_Translation(desadv_module_, 'MessageClass', 'DESADV', 'Used to send inbound dispatch advice from Shipment to Receipt.');
   END IF;

END;
/
COMMIT;


exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_Discom_Messages.sql','Timestamp_2');
PROMPT Inserting PROG translations for ORDER connectivity messages...
BEGIN
   IF Component_Order_SYS.INSTALLED THEN
      Basic_Data_Translation_API.Insert_Prog_Translation('ORDER', 'MessageClass', 'ORDCHG', 'Used to send changed orders from IFS Purchase Order to IFS Customer Order for approval.');
      Basic_Data_Translation_API.Insert_Prog_Translation('ORDER', 'MessageClass', 'HSE_CUST_ORDER_DELIVERY.ADD', 'Used to send customer order delivery information for parts with HSE_Contract set in Part Catalog.');
   END IF;
END;
/
COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_Discom_Messages.sql','Timestamp_3');
PROMPT Inserting PROG translations for ORDER PURCH shared  connectivity messages...
DECLARE
   module_                VARCHAR2(10) := 'ORDER';
BEGIN
   IF Component_Order_SYS.INSTALLED OR Component_Purch_SYS.INSTALLED THEN
      IF (Component_Purch_SYS.INSTALLED) THEN
         module_ := 'PURCH';
      END IF;
      Basic_Data_Translation_API.Insert_Prog_Translation(module_, 'MessageClass', 'ORDERS', 'Used to send orders from IFS Purchase Order to IFS Customer Order for approval.');
      Basic_Data_Translation_API.Insert_Prog_Translation(module_, 'MessageClass', 'ORDRSP', 'Used to send order response from IFS Customer Order to IFS Purchase Order.');
      Basic_Data_Translation_API.Insert_Prog_Translation(module_, 'MessageClass', 'DIRDEL', 'Used to send direct delivery message from IFS Customer Order to IFS Purchase Order.');
      Basic_Data_Translation_API.Insert_Prog_Translation(module_, 'MessageClass', 'PRICAT', 'Used to send pricing information from IFS Customer Order to IFS Purchase Order.');
      Basic_Data_Translation_API.Insert_Prog_Translation(module_, 'MessageClass', 'RECADV', 'Used to send receiving advice from IFS Purchase Order to IFS Customer Order.');
      Basic_Data_Translation_API.Insert_Prog_Translation(module_, 'MessageClass', 'SBIINV', 'Used to send self-billing information from IFS Purchase Order to IFS Customer Order.');
   END IF;
END;
/
COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_Discom_Messages.sql','Done');
