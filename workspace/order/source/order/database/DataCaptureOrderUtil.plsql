-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptureOrderUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  180719  BudKlk   Bug 142134, Modified Add_Details_For_Order_No() to get  RECEIVER_ADDRESS_NAME from the method Add_Address_Name___().
--  171003  KhVese   STRSC-12224, Modified method Add_Ship_Addr_Name___ to get address name instead of address1.
--  170718  KhVese   STRSC-8846, Modified method Add_Details_For_Order_No and added new methods Add_Order_Salesman_Name___, Add_Order_Salesman_Code___,
--  170718           Add_Order_Route_Desc___, Add_Order_Forward_Name___, Add_Delivery_Terms_Desc___, Add_Order_Ship_Via_Desc___.
--  170418  DaZase   LIM-10662, Added method Inventory_Barcode_Enabled.
--  161115  SWiclk   LIM-5313, Modified Fixed_Value_Is_Applicable() by adding serial_no as a parameter so that it will be used to decide on quantity when applicable.
--  160923  DaZase   LIM-8337, Moved Add_Del_Note_No/Add_Details_For_Del_Note_No and implementation methods to Data_Capture_Shpmnt_Util_API.
--  160608  MaIklk   LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--- 151214  DaZase   LIM-2922, Moved Add_Details_For_Shipment to Data_Capture_Shpmnt_Util_API.
--  151124  SWiclk   STRSC-306, Added Add_Details_For_Ship_Location() in order to handle SHIP_LOCATION_NO_DESC separately.
--  151110  MaIklk   LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151106  MaEelk   LIM-4453, Removed pallet_id_ from Add_Del_Note_No.
--  151027  DaZase   LIM-4297, Moved methods Add_Details_For_Hand_Unit_Type/Add_Details_For_Handling_Unit to 
--  151027           DataCaptureInventUtil instead since that is the more logical place for these methods.
--  150826  DaZase   AFT-1965, Fixed PARENT_HANDLING_UNIT_DESC in Add_Details_For_Hand_Unit_Type so it will correctly fetched.
--  150505  RILASE   COB-364, Added methods Add_Details_For_Hand_Unit_Type, Add_Details_For_Handling_Unit and Add_Details_For_Shipment.
--  141126  BudKlk   Bug 119908, Modified Add_Details_For_Order_No() to get the order type description when the data_item_detail_id_ is 'ORDER_TYPE_DESCRIPTION'.
--  141105  ChBnlk   Bug 119558, Added new method Add_Condition_Code___() and modified Add_Details_For_CO_Line() to
--                   add condition code to the session line using that method. 
--  140908  RiLase   PRSC-2497, Added Fixed_Value_Is_Applicable().
--  140306  MatKse   Bug 115429, Added "Add"-functions for Delivery Terms, Ship Address, Bill Address,
--  140306           Delivery Note {Ship Date, Create Date, Status, Forwarder}. Added Add_Details_For_Delnote_No.                                                                                   
--  121005  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Cust_Ord_Line_Keys___ (
   order_no_           IN OUT VARCHAR2,
   line_no_            IN OUT VARCHAR2,
   rel_no_             IN OUT VARCHAR2,
   line_item_no_       IN OUT NUMBER,
   capture_session_id_ IN     NUMBER,
   data_item_id_b_     IN     VARCHAR2 )   
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      order_no_     := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                         data_item_id_a_     => 'ORDER_NO',
                                                                         data_item_id_b_     => data_item_id_b_);

      line_no_      := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                         data_item_id_a_     => 'LINE_NO',
                                                                         data_item_id_b_     => data_item_id_b_);

      rel_no_       := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                         data_item_id_a_     => 'REL_NO',
                                                                         data_item_id_b_     => data_item_id_b_);
      
      line_item_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                         data_item_id_a_     => 'LINE_ITEM_NO',
                                                                         data_item_id_b_     => data_item_id_b_);
   $ELSE
      NULL;                                                                      
   $END
END Get_Cust_Ord_Line_Keys___;


PROCEDURE Add_Customer_No___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   customer_no_         IN VARCHAR2 )
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => customer_no_);
   $ELSE
      NULL;                                     
   $END
END Add_Customer_No___;


PROCEDURE Add_Customer_Name___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   customer_no_         IN VARCHAR2 )
IS
   customer_name_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      customer_name_ := Cust_Ord_Customer_API.Get_Name(customer_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => customer_name_);
   $ELSE
      NULL;                                     
   $END
END Add_Customer_Name___;


PROCEDURE Add_Order_No___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => order_no_);
   $ELSE
      NULL;                                     
   $END
END Add_Order_No___;


PROCEDURE Add_Wanted_Delivery_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   wanted_delivery_date_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      wanted_delivery_date_ := Customer_Order_API.Get_Wanted_Delivery_Date(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => wanted_delivery_date_);
   $ELSE
      NULL;                                     
   $END
END Add_Wanted_Delivery_Date___;


PROCEDURE Add_Type___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   order_id_ VARCHAR2(3);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      order_id_ := Customer_Order_API.Get_Order_Id(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => order_id_);
   $ELSE
      NULL;                                     
   $END
END Add_Type___;


PROCEDURE Add_Type_Description___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   order_id_  VARCHAR2(3);
   type_desc_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      order_id_  := Customer_Order_API.Get_Order_Id(order_no_);
      type_desc_ := Cust_Order_Type_API.Get_Description(order_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => type_desc_);
   $ELSE
      NULL;                                     
   $END
END Add_Type_Description___;


PROCEDURE Add_Coordinator___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   coordinator_  VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      coordinator_  := Customer_Order_API.Get_Authorize_Code(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => coordinator_);
   $ELSE
      NULL;                                     
   $END
END Add_Coordinator___;


PROCEDURE Add_Status___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   status_  VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      status_  := Customer_Order_API.Get_State(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => status_);
   $ELSE
      NULL;                                     
   $END
END Add_Status___;


PROCEDURE Add_Priority___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   priority_  NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      priority_  := Customer_Order_API.Get_Priority(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => priority_);
   $ELSE
      NULL;                                     
   $END
END Add_Priority___;


PROCEDURE Add_Reference___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   reference_  VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      reference_  := Customer_Order_API.Get_Cust_Ref(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => reference_);
   $ELSE
      NULL;                                     
   $END
END Add_Reference___;


PROCEDURE Add_Reference_Name___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   customer_no_         IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   reference_      VARCHAR2(30);
   bill_addr_no_   VARCHAR2(50);
   reference_name_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      reference_      := Customer_Order_API.Get_Cust_Ref(order_no_);
      bill_addr_no_   := Customer_Order_API.Get_Bill_Addr_No(order_no_);
      reference_name_ := Contact_Util_API.Get_Cust_Contact_Name(customer_no_, bill_addr_no_, reference_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => reference_name_);
   $ELSE
      NULL;                                     
   $END
END Add_Reference_Name___;


PROCEDURE Add_Customer_Po_No___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   customer_no_      VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      customer_no_ := Customer_Order_API.Get_Customer_Po_No(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => customer_no_);
   $ELSE
      NULL;                                   
   $END
END Add_Customer_Po_No___;


PROCEDURE Add_Order_Delivery_Terms___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   delivery_terms_ VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      delivery_terms_ := Customer_Order_API.Get_Delivery_Terms(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => delivery_terms_);
   $ELSE
      NULL;
   $END
END Add_Order_Delivery_Terms___;


PROCEDURE Add_Delivery_Terms_Desc___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   delivery_terms_ VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      delivery_terms_ := Customer_Order_API.Get_Delivery_Terms(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => Order_Delivery_Term_API.Get_Description(delivery_terms_));
   $ELSE
      NULL;
   $END
END Add_Delivery_Terms_Desc___;


PROCEDURE Add_Order_Ship_Via_Desc___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   ship_via_code_ VARCHAR2(3);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      ship_via_code_ := Customer_Order_API.Get_Ship_Via_Code(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => Mpccom_Ship_Via_API.Get_Description(ship_via_code_));
   $ELSE
      NULL;
   $END
END Add_Order_Ship_Via_Desc___;

PROCEDURE Add_Order_Ship_Via_Code___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   ship_via_code_ VARCHAR2(3);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      ship_via_code_ := Customer_Order_API.Get_Ship_Via_Code(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => ship_via_code_);
   $ELSE
      NULL;
   $END
END Add_Order_Ship_Via_Code___;

PROCEDURE Add_Order_Shipment_Type___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   shipment_type_ VARCHAR2(3);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      shipment_type_ := Customer_Order_API.Get_Shipment_Type(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => shipment_type_);
   $ELSE
      NULL;
   $END
END Add_Order_Shipment_Type___;


PROCEDURE Add_Ship_Addr_No___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   ship_addr_no_ VARCHAR2(50);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      ship_addr_no_ := Customer_Order_API.Get_Ship_Addr_No(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => ship_addr_no_);
   $ELSE
      NULL;
   $END
END Add_Ship_Addr_No___;

PROCEDURE Add_Ship_Addr_Name___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   customer_no_    VARCHAR2(20);
   ship_addr_no_   VARCHAR2(50);
   ship_addr_name_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      customer_no_    := Customer_Order_API.Get_Customer_No(order_no_);
      ship_addr_no_   := Customer_Order_API.Get_Ship_Addr_No(order_no_);
      ship_addr_name_ := Cust_Ord_Customer_Address_API.Get_Name(customer_no_, ship_addr_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => ship_addr_name_);
   $ELSE
      NULL;
   $END
END Add_Ship_Addr_Name___;

PROCEDURE Add_Bill_Addr_No___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   bill_addr_no_   VARCHAR2(50);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      bill_addr_no_   := Customer_Order_API.Get_Bill_Addr_No(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => bill_addr_no_);
   $ELSE
      NULL;
   $END
END Add_Bill_Addr_No___;

PROCEDURE Add_Bill_Addr_Name___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   customer_no_    VARCHAR2(20);
   bill_addr_no_   VARCHAR2(50);
   bill_addr_name_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      customer_no_    := Customer_Order_API.Get_Customer_No(order_no_);
      bill_addr_no_   := Customer_Order_API.Get_Ship_Addr_No(order_no_);
      bill_addr_name_ := Customer_Info_Address_API.Get_Name(customer_no_,bill_addr_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => bill_addr_name_);
   $ELSE
      NULL;
   $END
END Add_Bill_Addr_Name___;


PROCEDURE Add_Line_Sales_Part___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   sales_part_ VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      sales_part_ := Customer_Order_Line_API.Get_Catalog_No(order_no_, line_no_, rel_no_, line_item_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => sales_part_);
   $ELSE
      NULL;                                     
   $END
END Add_Line_Sales_Part___;


PROCEDURE Add_Line_Sales_Part_Desc___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   sales_part_desc_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      sales_part_desc_ := Customer_Order_Line_API.Get_Catalog_Desc(order_no_, line_no_, rel_no_, line_item_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => sales_part_desc_);
   $ELSE
      NULL;                                     
   $END
END Add_Line_Sales_Part_Desc___;


PROCEDURE Add_Line_Wanted_Dely_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   delivery_date_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      delivery_date_ := Customer_Order_Line_API.Get_Wanted_Delivery_Date(order_no_, line_no_, rel_no_, line_item_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => delivery_date_);
   $ELSE
      NULL;                                     
   $END
END Add_Line_Wanted_Dely_Date___;


PROCEDURE Add_Line_Target_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   target_date_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      target_date_ := Customer_Order_Line_API.Get_Target_Date(order_no_, line_no_, rel_no_, line_item_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => target_date_);
   $ELSE
      NULL;                                     
   $END
END Add_Line_Target_Date___;


PROCEDURE Add_Line_Planned_Dely_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   planned_date_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      planned_date_ := Customer_Order_Line_API.Get_Planned_Delivery_Date(order_no_, line_no_, rel_no_, line_item_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => planned_date_);
   $ELSE
      NULL;                                     
   $END
END Add_Line_Planned_Dely_Date___;


PROCEDURE Add_Line_Promised_Dely_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   promised_date_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      promised_date_ := Customer_Order_Line_API.Get_Promised_Delivery_Date(order_no_, line_no_, rel_no_, line_item_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => promised_date_);
   $ELSE
      NULL;                                     
   $END
END Add_Line_Promised_Dely_Date___;


PROCEDURE Add_Line_Planned_Ship_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   planned_ship_date_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      planned_ship_date_ := Customer_Order_Line_API.Get_Planned_Ship_Date(order_no_, line_no_, rel_no_, line_item_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => planned_ship_date_);
   $ELSE
      NULL;                                     
   $END
END Add_Line_Planned_Ship_Date___;


PROCEDURE Add_Line_Planned_Due_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   planned_date_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      planned_date_ := Customer_Order_Line_API.Get_Planned_Due_Date(order_no_, line_no_, rel_no_, line_item_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => planned_date_);
   $ELSE
      NULL;                                     
   $END
END Add_Line_Planned_Due_Date___;


PROCEDURE Add_Line_Created___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   created_date_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      created_date_ := Customer_Order_Line_API.Get_Date_Entered(order_no_, line_no_, rel_no_, line_item_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => created_date_);
   $ELSE
      NULL;                                     
   $END
END Add_Line_Created___;

PROCEDURE Add_Condition_Code___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   condition_code_    VARCHAR2(10);
BEGIN   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      condition_code_ := Customer_Order_Line_API.Get_Condition_Code(order_no_, line_no_, rel_no_, line_item_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => condition_code_);
   $ELSE
      NULL;
   $END
END Add_Condition_Code___;

PROCEDURE Add_Order_Forward_Agent_Id___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   forward_agent_id_    VARCHAR2(20);
BEGIN   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      forward_agent_id_ := Customer_Order_API.Get_Forward_Agent_Id(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => forward_agent_id_);
   $ELSE
      NULL;
   $END
END Add_Order_Forward_Agent_Id___;


PROCEDURE Add_Order_Forward_Name___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   forward_agent_id_    VARCHAR2(20);
BEGIN   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      forward_agent_id_ := Customer_Order_API.Get_Forward_Agent_Id(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => Forwarder_Info_API.Get_Name(forward_agent_id_));
   $ELSE
      NULL;
   $END
END Add_Order_Forward_Name___;


PROCEDURE Add_Order_Route_Desc___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   route_id_            VARCHAR2(12);
BEGIN   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      route_id_ := Customer_Order_API.Get_Route_Id(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => Delivery_Route_API.Get_Description(route_id_));
   $ELSE
      NULL;
   $END
END Add_Order_Route_Desc___;


PROCEDURE Add_Order_Salesman_Code___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   salesman_code_       VARCHAR2(20);
BEGIN   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      salesman_code_ := Customer_Order_API.Get_Salesman_Code(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => salesman_code_);
   $ELSE
      NULL;
   $END
END Add_Order_Salesman_Code___;


PROCEDURE Add_Order_Salesman_Name___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2 )
IS
   salesman_code_       VARCHAR2(20);
BEGIN   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      salesman_code_ := Customer_Order_API.Get_Salesman_Code(order_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => Person_Info_API.Get_Name(salesman_code_));
   $ELSE
      NULL;
   $END
END Add_Order_Salesman_Name___;


PROCEDURE Add_Address_Name___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   addr_1_      VARCHAR2(100);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      addr_1_    := Customer_Order_Address_API.Get_Address_Name(order_no_, line_no_, rel_no_, line_item_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => addr_1_);
   $ELSE
      NULL;
   $END
END Add_Address_Name___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Add_Details_For_Order_No (
   capture_session_id_   IN NUMBER,
   owning_data_item_id_  IN VARCHAR2,
   data_item_detail_id_  IN VARCHAR2,
   order_no_             IN VARCHAR2 )
IS
   customer_no_ VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      customer_no_ := Customer_Order_API.Get_Customer_No(order_no_);
      CASE
         WHEN data_item_detail_id_ IN ('CUSTOMER_NO') THEN 
            Add_Customer_No___(capture_session_id_  => capture_session_id_,
                               owning_data_item_id_ => owning_data_item_id_,
                               data_item_detail_id_ => data_item_detail_id_,   
                               customer_no_         => customer_no_);
         WHEN data_item_detail_id_ IN ('DELIVER_TO_CUSTOMER_NO') THEN 
            Add_Customer_No___(capture_session_id_  => capture_session_id_,
                               owning_data_item_id_ => owning_data_item_id_,
                               data_item_detail_id_ => data_item_detail_id_,   
                               customer_no_         => customer_no_);
         WHEN data_item_detail_id_ IN ('CUSTOMER_NAME') THEN 
            Add_Customer_Name___(capture_session_id_  => capture_session_id_, 
                                 owning_data_item_id_ => owning_data_item_id_,
                                 data_item_detail_id_ => data_item_detail_id_,   
                                 customer_no_         => customer_no_);
         WHEN data_item_detail_id_ IN ('WANTED_DELIVERY_DATE') THEN 
            Add_Wanted_Delivery_Date___(capture_session_id_  => capture_session_id_, 
                                        owning_data_item_id_ => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('ORDER_NO') THEN 
            Add_Order_No___(capture_session_id_  => capture_session_id_, 
                            owning_data_item_id_ => owning_data_item_id_,
                            data_item_detail_id_ => data_item_detail_id_,   
                            order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('ORDER_TYPE') THEN 
            Add_Type___(capture_session_id_  => capture_session_id_, 
                              owning_data_item_id_ => owning_data_item_id_,
                              data_item_detail_id_ => data_item_detail_id_,   
                              order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('ORDER_TYPE_DESCRIPTION') THEN 
            Add_Type_Description___(capture_session_id_  => capture_session_id_, 
                                    owning_data_item_id_ => owning_data_item_id_,
                                    data_item_detail_id_ => data_item_detail_id_,   
                                    order_no_            => order_no_);        
         WHEN data_item_detail_id_ IN ('ORDER_COORDINATOR') THEN 
            Add_Coordinator___(capture_session_id_  => capture_session_id_, 
                               owning_data_item_id_ => owning_data_item_id_,
                               data_item_detail_id_ => data_item_detail_id_,   
                               order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('ORDER_STATUS') THEN 
            Add_Status___(capture_session_id_  => capture_session_id_, 
                          owning_data_item_id_ => owning_data_item_id_,
                          data_item_detail_id_ => data_item_detail_id_,   
                          order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('ORDER_PRIORITY') THEN 
            Add_Priority___(capture_session_id_  => capture_session_id_, 
                            owning_data_item_id_ => owning_data_item_id_,
                            data_item_detail_id_ => data_item_detail_id_,   
                            order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('ORDER_REFERENCE') THEN 
            Add_Reference___(capture_session_id_  => capture_session_id_, 
                             owning_data_item_id_ => owning_data_item_id_,
                             data_item_detail_id_ => data_item_detail_id_,   
                             order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('ORDER_REFERENCE_NAME') THEN 
            Add_Reference_Name___(capture_session_id_  => capture_session_id_, 
                                  owning_data_item_id_ => owning_data_item_id_,
                                  data_item_detail_id_ => data_item_detail_id_,
                                  customer_no_         => customer_no_,
                                  order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('CUSTOMER_PO_NO') THEN 
            Add_Customer_Po_No___(capture_session_id_  => capture_session_id_, 
                                  owning_data_item_id_ => owning_data_item_id_,
                                  data_item_detail_id_ => data_item_detail_id_,   
                                  order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('ORDER_DELIVERY_TERMS', 'DELIVERY_TERMS') THEN 
            Add_Order_Delivery_Terms___(capture_session_id_  => capture_session_id_, 
                                        owning_data_item_id_ => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,   
                                        order_no_            => order_no_); 
         WHEN data_item_detail_id_ IN ('DELIVERY_TERMS_DESC') THEN 
            Add_Delivery_Terms_Desc___(capture_session_id_  => capture_session_id_, 
                                       owning_data_item_id_ => owning_data_item_id_,
                                       data_item_detail_id_ => data_item_detail_id_,   
                                       order_no_            => order_no_); 
         WHEN data_item_detail_id_ IN ('SHIP_ADDR_NO') THEN 
            Add_Ship_Addr_No___(capture_session_id_  => capture_session_id_, 
                                owning_data_item_id_ => owning_data_item_id_,
                                data_item_detail_id_ => data_item_detail_id_,   
                                order_no_            => order_no_);    
         WHEN data_item_detail_id_ IN ('CUSTOMER_ADDRESS_ID') THEN 
            Add_Ship_Addr_No___(capture_session_id_  => capture_session_id_, 
                                owning_data_item_id_ => owning_data_item_id_,
                                data_item_detail_id_ => data_item_detail_id_,   
                                order_no_            => order_no_);    
         WHEN data_item_detail_id_ IN ('SHIP_ADDR_NAME') THEN 
            Add_Ship_Addr_Name___(capture_session_id_  => capture_session_id_, 
                                  owning_data_item_id_ => owning_data_item_id_,
                                  data_item_detail_id_ => data_item_detail_id_,   
                                  order_no_            => order_no_); 
         WHEN data_item_detail_id_ IN ('BILL_ADDR_NO') THEN 
            Add_Bill_Addr_No___(capture_session_id_  => capture_session_id_, 
                                owning_data_item_id_ => owning_data_item_id_,
                                data_item_detail_id_ => data_item_detail_id_,   
                                order_no_            => order_no_); 
         WHEN data_item_detail_id_ IN ('BILL_ADDR_NAME') THEN 
            Add_Bill_Addr_Name___(capture_session_id_  => capture_session_id_, 
                                  owning_data_item_id_ => owning_data_item_id_,
                                  data_item_detail_id_ => data_item_detail_id_,   
                                  order_no_            => order_no_);     
         WHEN data_item_detail_id_ IN ('ORDER_SHIP_VIA_CODE', 'SHIP_VIA_CODE') THEN 
            Add_Order_Ship_Via_Code___(capture_session_id_  => capture_session_id_, 
                                       owning_data_item_id_ => owning_data_item_id_,
                                       data_item_detail_id_ => data_item_detail_id_,   
                                       order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('SHIP_VIA_CODE_DESC') THEN 
            Add_Order_Ship_Via_Desc___(capture_session_id_  => capture_session_id_, 
                                       owning_data_item_id_ => owning_data_item_id_,
                                       data_item_detail_id_ => data_item_detail_id_,   
                                       order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('SHIPMENT_TYPE') THEN 
            Add_Order_Shipment_Type___(capture_session_id_  => capture_session_id_, 
                                       owning_data_item_id_ => owning_data_item_id_,
                                       data_item_detail_id_ => data_item_detail_id_,   
                                       order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('FORWARD_AGENT_ID') THEN
            Add_Order_Forward_Agent_Id___(capture_session_id_  => capture_session_id_, 
                                          owning_data_item_id_ => owning_data_item_id_,
                                          data_item_detail_id_ => data_item_detail_id_,   
                                          order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('FORWARD_AGENT_NAME') THEN
            Add_Order_Forward_Name___(capture_session_id_  => capture_session_id_, 
                                      owning_data_item_id_ => owning_data_item_id_,
                                      data_item_detail_id_ => data_item_detail_id_,   
                                      order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('ROUTE_DESCRIPTION') THEN
            Add_Order_Route_Desc___(capture_session_id_  => capture_session_id_, 
                                    owning_data_item_id_ => owning_data_item_id_,
                                    data_item_detail_id_ => data_item_detail_id_,   
                                    order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('SALESMAN_CODE') THEN
            Add_Order_Salesman_Code___(capture_session_id_  => capture_session_id_, 
                                       owning_data_item_id_ => owning_data_item_id_,
                                       data_item_detail_id_ => data_item_detail_id_,   
                                       order_no_            => order_no_);
         WHEN data_item_detail_id_ IN ('SALESMAN_NAME') THEN
            Add_Order_Salesman_Name___(capture_session_id_  => capture_session_id_, 
                                       owning_data_item_id_ => owning_data_item_id_,
                                       data_item_detail_id_ => data_item_detail_id_,   
                                       order_no_            => order_no_);
         ELSE 
            NULL;
      END CASE;
   $ELSE
      NULL;   
   $END
END Add_Details_For_Order_No;



PROCEDURE Add_Details_For_CO_Line (
   capture_session_id_   IN NUMBER,
   owning_data_item_id_  IN VARCHAR2,
   data_item_detail_id_  IN VARCHAR2,
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER )
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('LINE_SALES_PART') THEN 
            Add_Line_Sales_Part___(capture_session_id_  => capture_session_id_, 
                                   owning_data_item_id_ => owning_data_item_id_,
                                   data_item_detail_id_ => data_item_detail_id_,   
                                   order_no_            => order_no_,
                                   line_no_             => line_no_,
                                   rel_no_              => rel_no_,
                                   line_item_no_        => line_item_no_);
         WHEN ('LINE_SALES_PART_DESCRIPTION') THEN 
            Add_Line_Sales_Part_Desc___(capture_session_id_  => capture_session_id_, 
                                        owning_data_item_id_ => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,   
                                        order_no_            => order_no_,
                                        line_no_             => line_no_,
                                        rel_no_              => rel_no_,
                                        line_item_no_        => line_item_no_);
         WHEN ('LINE_WANTED_DELIVERY_DATE') THEN 
            Add_Line_Wanted_Dely_Date___(capture_session_id_  => capture_session_id_, 
                                         owning_data_item_id_ => owning_data_item_id_,
                                         data_item_detail_id_ => data_item_detail_id_,   
                                         order_no_            => order_no_,
                                         line_no_             => line_no_,
                                         rel_no_              => rel_no_,
                                         line_item_no_        => line_item_no_);
         WHEN ('LINE_TARGET_DATE') THEN 
            Add_Line_Target_Date___(capture_session_id_  => capture_session_id_, 
                                    owning_data_item_id_ => owning_data_item_id_,
                                    data_item_detail_id_ => data_item_detail_id_,   
                                    order_no_            => order_no_,
                                    line_no_             => line_no_,
                                    rel_no_              => rel_no_,
                                    line_item_no_        => line_item_no_);
         WHEN ('LINE_PLANNED_DELIVERY_DATE') THEN 
            Add_Line_Planned_Dely_Date___(capture_session_id_  => capture_session_id_, 
                                          owning_data_item_id_ => owning_data_item_id_,
                                          data_item_detail_id_ => data_item_detail_id_,   
                                          order_no_            => order_no_,
                                          line_no_             => line_no_,
                                          rel_no_              => rel_no_,
                                          line_item_no_        => line_item_no_);
         WHEN ('LINE_PROMISED_DELIVERY_DATE') THEN 
            Add_Line_Promised_Dely_Date___(capture_session_id_  => capture_session_id_, 
                                           owning_data_item_id_ => owning_data_item_id_,
                                           data_item_detail_id_ => data_item_detail_id_,   
                                           order_no_            => order_no_,
                                           line_no_             => line_no_,
                                           rel_no_              => rel_no_,
                                           line_item_no_        => line_item_no_);
         WHEN ('LINE_PLANNED_SHIP_DATE') THEN 
            Add_Line_Planned_Ship_Date___(capture_session_id_  => capture_session_id_, 
                                          owning_data_item_id_ => owning_data_item_id_,
                                          data_item_detail_id_ => data_item_detail_id_,   
                                          order_no_            => order_no_,
                                          line_no_             => line_no_,
                                          rel_no_              => rel_no_,
                                          line_item_no_        => line_item_no_);
         WHEN ('LINE_PLANNED_DUE_DATE') THEN 
            Add_Line_Planned_Due_Date___(capture_session_id_  => capture_session_id_, 
                                         owning_data_item_id_ => owning_data_item_id_,
                                         data_item_detail_id_ => data_item_detail_id_,   
                                         order_no_            => order_no_,
                                         line_no_             => line_no_,
                                         rel_no_              => rel_no_,
                                         line_item_no_        => line_item_no_);
         WHEN ('LINE_CREATED') THEN 
            Add_Line_Created___(capture_session_id_  => capture_session_id_, 
                                owning_data_item_id_ => owning_data_item_id_,
                                data_item_detail_id_ => data_item_detail_id_,   
                                order_no_            => order_no_,
                                line_no_             => line_no_,
                                rel_no_              => rel_no_,
                                line_item_no_        => line_item_no_);
         WHEN ('CONDITION_CODE') THEN 
            Add_Condition_Code___(capture_session_id_  => capture_session_id_, 
                                  owning_data_item_id_ => owning_data_item_id_,
                                  data_item_detail_id_ => data_item_detail_id_,   
                                  order_no_            => order_no_,
                                  line_no_             => line_no_,
                                  rel_no_              => rel_no_,
                                  line_item_no_        => line_item_no_);
         WHEN ('RECEIVER_ADDRESS_NAME') THEN 
            Add_Address_Name___(capture_session_id_  => capture_session_id_,
                                owning_data_item_id_ => owning_data_item_id_,
                                data_item_detail_id_ => data_item_detail_id_,   
                                order_no_            => order_no_,
                                line_no_             => line_no_,
                                rel_no_              => rel_no_,
                                line_item_no_        => line_item_no_);
         ELSE 
            NULL;
      END CASE;
   $ELSE
      NULL;   
   $END
END Add_Details_For_CO_Line;


PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
BEGIN
   -- Method not used at the moment, add Customer Order specific validations here that are not process specific
   -- Check other DataCapture<Component>Utils for examples how the code should look like, like for example DataCaptureInventUtil or DataCapturePurchUtil
   NULL;
END Validate_Data_Item; 


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   automatic_value_ VARCHAR2(200);
BEGIN
   -- Method not used at the moment, add Customer Order specific automatic values here that are not process specific
   -- Check other DataCapture<Component>Utils for examples how the code should look like, like for example DataCaptureInventUtil or DataCapturePurchUtil
    RETURN automatic_value_;
END Get_Automatic_Data_Item_Value;


PROCEDURE Create_List_Of_Values (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_       IN VARCHAR2,
   contract_           IN VARCHAR2 )
IS
BEGIN
   
   -- Method not used at the moment, add Customer Order specific LOVs here that are not process specific
   -- Check other DataCapture<Component>Utils for examples how the code should look like, like for example DataCaptureInventUtil or DataCapturePurchUtil
   NULL;
END Create_List_Of_Values;


FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2,
   part_no_            IN VARCHAR2,
   serial_no_          IN VARCHAR2 DEFAULT NULL) RETURN BOOLEAN
IS
BEGIN
   RETURN Data_Capture_Invent_Util_API.Fixed_Value_Is_Applicable(capture_session_id_, data_item_id_, part_no_, serial_no_);
END Fixed_Value_Is_Applicable;


PROCEDURE Add_Details_For_Ship_Location(
   capture_session_id_   IN   NUMBER,
   owning_data_item_id_  IN   VARCHAR2,
   data_item_detail_id_  IN   VARCHAR2,
   contract_             IN   VARCHAR2,
   shipment_id_          IN   NUMBER,
   ship_location_no_     IN   VARCHAR2)
IS
   feedback_item_value_   VARCHAR2(200);   
BEGIN
$IF Component_Wadaco_SYS.INSTALLED $THEN
   CASE (data_item_detail_id_)   
   WHEN ('SHIP_LOCATION_NO_DESC') THEN                                                                            
      feedback_item_value_ := Inventory_Location_API.Get_Location_Name(contract_,NVL(ship_location_no_, Shipment_API.Get_Ship_Inventory_Location_No(shipment_id_)));   
   ELSE
      NULL;
   END CASE;
   Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                     data_item_id_        => owning_data_item_id_,
                                     data_item_detail_id_ => data_item_detail_id_,
                                     data_item_value_     => feedback_item_value_);
$ELSE
   NULL;                                     
$END   
END Add_Details_For_Ship_Location;


FUNCTION Inventory_Barcode_Enabled (
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Data_Capture_Invent_Util_API.Inventory_Barcode_Enabled(capture_process_id_, capture_config_id_);
END Inventory_Barcode_Enabled;

   
