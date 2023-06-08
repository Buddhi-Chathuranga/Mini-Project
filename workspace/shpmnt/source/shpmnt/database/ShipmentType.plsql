-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentType
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  --------------------------------------------------------- 
--  220525  SaLelk   SCDEV-9674, Modified Insert_Lu_Data_Rec to add value for automatic_receipt when inserting.
--  220523  SaLelk   SCDEV-9674, Modified Prepare_Insert___, Check_Insert___ to add default value for automatic_receipt when inserting. 
--  211102  PrRtlk   SC21R2-5679, Added NVL to Insert_Lu_Data_Rec to handle null values for mandotary fields.
--  211001  PrRtlk   SC21R2-2966, Modified Prepare_Insert___, Check_Insert___ to add default value for shipment_cre_rceipt_ret when inserting.
--  201104  Aabalk   SCZ-12088, Modified Prepare_Insert___, Check_Insert___ and Insert_Lu_Data_Rec to add value for keep_manual_weight_vol when inserting.
--  170317  Jhalse   LIM-10113, Removed limitation for automatic pick for shipment inventory.
--  170307  Jhalse   LIM-10113, Removed all references to Pick_Inventory_Type as Shipment Inventory is now mandatory for Shipment.
--  170307           Also added reference to new column Confirm_Shipment_Location to support new picking functionality.
--  160825  MaIklk   LIM-8481, Made Insert_Lu_Data_Rec as public.
--  160721  MaIklk   LIM-8053, Renamed SHIPMENT_CREATION to SHIPMENT_CREATION_CO.
--  151130  MaRalk   LIM-4594, Modified Insert_Lu_Data_Rec__ to support 
--  151130           basic data translations from shpmnt module.
--  151014  MaRalk   LIM-3836, Moved to the shpmnt module from order module in order to support
--  151014           generic shipment functionality.
--  150324  JeLise   COB-173, Added new attribute allow_partial_picking.
--  140312  RoJalk   Modified Insert_Lu_Data_Rec__ and used Basic_Data_Translation_API.Insert_Prog_Translation.
--  131113  RoJalk   Hooks implementation - refactor files.
--  130610  MAHPLK   Added new public attribute approve_before_delivery to LU.
--  120410  MaMalk   Added Shipment_Creation to control how the shipment gets created from the shipment_type.
--  120710  RoJalk   Removed the view SHIPMENT_TYPE_LOV.
--  120709  RoJalk   Modified SHIPMENT_TYPE_LOV and added online_processing. 
--  120702  MeAblk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ONLINE_PROCESSING_DB', Fnd_Boolean_API.DB_FALSE, attr_);   
   Client_SYS.Add_To_Attr('SHIPMENT_CREATION_CO', Shipment_Creation_API.Decode('NO_AUTOMATIC'), attr_);   
   Client_SYS.Add_To_Attr('SHIPMENT_CREATION_SHIP_ORD', Shipment_Creation_API.Decode('NO_AUTOMATIC'), attr_);  
   Client_SYS.Add_To_Attr('SHIPMENT_CRE_RCEIPT_RET', Shipment_Creation_API.Decode('NO_AUTOMATIC'), attr_);   
   Client_SYS.Add_To_Attr('APPROVE_ON_DELIVERY_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('ALLOW_PARTIAL_PICKING_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('CONFIRM_SHIPMENT_LOCATION_DB', Fnd_Boolean_API.DB_TRUE, attr_);
   Client_SYS.Add_To_Attr('KEEP_MANUAL_WEIGHT_VOL_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('AUTOMATIC_RECEIPT', Fnd_Boolean_API.DB_FALSE, attr_);   
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SHIPMENT_TYPE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_event IS
      SELECT event
      FROM SHIPMENT_EVENT;
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   
   FOR eventrec_ IN get_event LOOP
      Shipment_Type_Event_API.New(newrec_.shipment_type,
                                  eventrec_.event,
                                  Fnd_Boolean_API.Decode('TRUE'));
   END LOOP;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SHIPMENT_TYPE_TAB%ROWTYPE,
   newrec_     IN OUT SHIPMENT_TYPE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT shipment_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (NOT indrec_.online_processing) THEN
      newrec_.online_processing := Fnd_Boolean_API.DB_FALSE; 
   END IF;   
   IF (NOT indrec_.shipment_creation_co) THEN
      newrec_.shipment_creation_co := 'NO_AUTOMATIC';
   END IF; 
   IF (NOT indrec_.shipment_creation_ship_ord) THEN
      newrec_.shipment_creation_ship_ord := Shipment_Creation_API.DB_NO_AUTOMATIC;
   END IF;
   IF (NOT indrec_.shipment_cre_rceipt_ret) THEN
      newrec_.shipment_cre_rceipt_ret := Shipment_Creation_API.DB_NO_AUTOMATIC;
   END IF;
   IF (NOT indrec_.approve_before_delivery) THEN
      newrec_.approve_before_delivery := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (NOT indrec_.allow_partial_picking) THEN
      newrec_.allow_partial_picking := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (NOT indrec_.keep_manual_weight_vol) THEN
      newrec_.keep_manual_weight_vol := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (NOT indrec_.automatic_receipt) THEN
      newrec_.automatic_receipt := Fnd_Boolean_API.DB_FALSE;
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   shipment_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ shipment_type_tab.description%TYPE;
BEGIN
   IF (shipment_type_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_, shipment_type_), 1, 50);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
   INTO   temp_
   FROM   shipment_type_tab
   WHERE  shipment_type = shipment_type_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(shipment_type_, 'Get_Description');
END Get_Description;


PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
   new_attr_   VARCHAR2(2000);
   newrec_     SHIPMENT_TYPE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Info;
   -- Retrieve the default attribute values
   Prepare_Insert___(new_attr_);

   -- Replace the default attribute values with the ones passed in the in parameter string
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
   END LOOP;

   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);

   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;
END New;

-- Insert_Lu_Data_Rec__
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec (
   newrec_ IN SHIPMENT_TYPE_TAB%ROWTYPE)
IS
   dummy_ VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM SHIPMENT_TYPE_TAB
      WHERE shipment_type = newrec_.shipment_type;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO SHIPMENT_TYPE_TAB (
            shipment_type,
            description,
            online_processing,
            shipment_creation_co,
            confirm_shipment_location,
            approve_before_delivery,
            allow_partial_picking,
            keep_manual_weight_vol,
            shipment_creation_ship_ord,
            shipment_cre_rceipt_ret,
            automatic_receipt,
            rowversion)
         VALUES (
            newrec_.shipment_type,
            newrec_.description,
            NVL(newrec_.online_processing, Fnd_Boolean_API.DB_FALSE),
            NVL(newrec_.shipment_creation_co, Shipment_Creation_API.DB_NO_AUTOMATIC),
            NVL(newrec_.confirm_shipment_location, Fnd_Boolean_API.DB_TRUE),
            NVL(newrec_.approve_before_delivery, Fnd_Boolean_API.DB_FALSE),
            NVL(newrec_.allow_partial_picking, Fnd_Boolean_API.DB_FALSE),
            NVL(newrec_.keep_manual_weight_vol, Fnd_Boolean_API.DB_FALSE),
            NVL(newrec_.shipment_creation_ship_ord, Shipment_Creation_API.DB_NO_AUTOMATIC),
            NVL(newrec_.shipment_cre_rceipt_ret, Shipment_Creation_API.DB_NO_AUTOMATIC),
            NVL(newrec_.automatic_receipt, Fnd_Boolean_API.DB_FALSE),
            newrec_.rowversion);
   ELSE                                                     
      UPDATE SHIPMENT_TYPE_TAB
      SET description = newrec_.description
      WHERE shipment_type = newrec_.shipment_type;
   END IF;
   CLOSE Exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('SHPMNT', 
                                                      'ShipmentType',
                                                       newrec_.shipment_type,      
                                                       newrec_.description); 
END Insert_Lu_Data_Rec;



