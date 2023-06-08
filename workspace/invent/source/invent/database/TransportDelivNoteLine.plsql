-----------------------------------------------------------------------------
--
--  Logical unit: TransportDelivNoteLine
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200520  WaSalk  gelr: Added to support Global Extension Functionalities.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-- gelr:transport_delivery_note, begin
@Override
PROCEDURE Check_Delete___ (
   remrec_ IN transport_deliv_note_line_tab%ROWTYPE )
IS
   objstate_ transport_delivery_note_tab.rowstate%TYPE;
BEGIN
   super(remrec_);
   objstate_ := Transport_Delivery_Note_API.Get_Objstate(remrec_.delivery_note_id);
   IF (objstate_ IN ('Printed','Cancelled')) THEN
      Error_SYS.Record_General(lu_name_, 'DELNOTESTATECHANGED: You cannot delete when the Transport Delivery Note is :P1' ,objstate_);
   END IF;
END Check_Delete___;

PROCEDURE Check_Transaction_Id_Ref___ (
   newrec_ IN OUT transport_deliv_note_line_tab%ROWTYPE )
IS
BEGIN
   IF (newrec_.transaction_type = Transport_Transaction_Type_API.DB_INVENTORY) THEN
      Inventory_Transaction_Hist_API.Exist(newrec_.transaction_id);
   ELSE
      $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
         Operation_History_API.Exist(newrec_.transaction_id);
      $ELSE
         NULL;
      $END
   END IF;
END Check_Transaction_Id_Ref___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT transport_deliv_note_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   delivery_note_id_   transport_deliv_note_line_tab.delivery_note_id%TYPE;
   
   CURSOR get_lines IS
      SELECT delivery_note_id
      FROM transport_deliv_note_line_tab line
      WHERE transaction_id   = newrec_.transaction_id;
BEGIN
   super(newrec_, indrec_, attr_);
   
   FOR line_rec_ IN  get_lines LOOP
      IF (Transport_Delivery_Note_API.Get_Objstate(line_rec_.delivery_note_id) IN ('Created','Printed'))THEN
         Error_SYS.Record_General(lu_name_, 'TRANSALREADYCONNECTED: Transaction ID :P1 is already connected to delivery note :P2', newrec_.transaction_id, line_rec_.delivery_note_id);
      END IF;
  END LOOP;

END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Get_Connected_Line_Count__(
   delivery_note_id_  IN VARCHAR2 ) RETURN NUMBER
IS
   count_ NUMBER := 0;
   
   CURSOR line_count IS
      SELECT count(*)
      FROM  transport_deliv_note_line_tab
      WHERE delivery_note_id = delivery_note_id_;
      
BEGIN
   OPEN line_count;
   FETCH line_count INTO count_;
   CLOSE line_count;
   RETURN count_;
END Get_Connected_Line_Count__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Transaction_Code (
   delivery_note_id_    IN VARCHAR2,
   transaction_id_      IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Transaction_Type_Db(delivery_note_id_, transaction_id_) = Transport_Transaction_Type_API.DB_INVENTORY) THEN
      RETURN Inventory_Transaction_Hist_API.Get_Transaction_Code(transaction_id_);
   ELSE
      $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
         RETURN Operation_History_API.Get_Transaction_Code(transaction_id_);
      $ELSE
         RETURN NULL;
      $END
   END IF;
END Get_Transaction_Code;

@UncheckedAccess
FUNCTION Get_Part_No (
   delivery_note_id_    IN VARCHAR2,
   transaction_id_      IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Transaction_Type_Db(delivery_note_id_, transaction_id_) = Transport_Transaction_Type_API.DB_INVENTORY) THEN
      RETURN Inventory_Transaction_Hist_API.Get_Part_No(transaction_id_);
   ELSE
      $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
         RETURN Operation_History_API.Get_Part_No(transaction_id_);
      $ELSE
         RETURN NULL;
      $END
   END IF;
END Get_Part_No;

@UncheckedAccess
FUNCTION Get_Part_Description (
   delivery_note_id_     IN VARCHAR2,
   transaction_id_       IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Inventory_Part_API.Get_Description(Transport_Delivery_Note_API.Get_Contract(delivery_note_id_), Get_Part_No(delivery_note_id_, transaction_id_));
END Get_Part_Description;

@UncheckedAccess
FUNCTION Get_Qty_Shipped (
   delivery_note_id_     IN VARCHAR2,
   transaction_id_       IN NUMBER ) RETURN NUMBER
IS
BEGIN
   IF (Get_Transaction_Type_Db(delivery_note_id_, transaction_id_) = Transport_Transaction_Type_API.DB_INVENTORY) THEN
      RETURN Inventory_Transaction_Hist_API.Get_Quantity(transaction_id_);
   ELSE
      $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
         RETURN Operation_History_API.Get_Outside_Qty_Shipped(transaction_id_);
      $ELSE
         RETURN NULL;
      $END
   END IF;
END Get_Qty_Shipped;

@UncheckedAccess
PROCEDURE New (
   delivery_note_id_      IN VARCHAR2,
   transaction_id_        IN NUMBER,
   transaction_type_      IN VARCHAR2 )
IS
   newrec_   transport_deliv_note_line_tab%ROWTYPE;
BEGIN
   newrec_.delivery_note_id := delivery_note_id_;
   newrec_.transaction_id   := transaction_id_;
   newrec_.transaction_type := transaction_type_;
   New___(newrec_);
END New;
-- gelr:transport_delivery_note, end