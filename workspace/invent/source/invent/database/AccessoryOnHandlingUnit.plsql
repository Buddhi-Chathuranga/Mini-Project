-----------------------------------------------------------------------------
--
--  Logical unit: AccessoryOnHandlingUnit
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210115  SBalLK  Issue SC2020R1-11830, Modified New() method by removing attr_ functionality to optimize the performance.
--  171123  MeAblk   Bug 138895, Modified  Delete___() to avoid updating handling unit related things when the handling unit is already removed.
--  170522  ChBnlk   Bug 135688, Added new method Remove() in order to manually delete the records in the accessory_on_handling_unit_tab.
--  170104  MaIklk   LIM-9397, Replaced the Shipment_handling_Utility_API.Calculate_Shipment_Charges() call with Shipment_Freight_Charge_API.Calculate_Shipment_Charges().
--  150901  MaEelk   Bug 124141, Replaced the method call Handling_Unit_API.Get_Top_Shipment_Id with Handling_Unit_API.Get_Shipment_Id
--  150626  LEPESE  Renamed to_shipment_id into root_shipment_id.
--  130823  MaEelk   Added Calculate_Shipment_Charges. This will fetch all shipments having the changed handling_unit_accessory_id and calculate freight charges for them.
--  130823           Modified Insert___, Update___ and Delete___ to calculate the freight charges of the shipment where the handling unit is connected. 
--  130523  MaEelk   Added Contains_Additive_Volume to check if the hu has accessories with additive volume or not.
--  130507  MaEelk   Added Remove_Manual_Volume___ to remove manual volume in HU level and shipment level 
--  130507           when an accessory is added, modiffied or deleted in the handling unit.
--  130419  MaEelk   Added Get_Connected_Accessory_Volume. This would calculate the volume of all accessories connected to the handling unit
--  130419           according to the value given for additive_volume_
--  130410  MaEelk   Added Remove_Gross_Weight___ to remove the manual gross weight of the handling unit and shipment 
--  130410           when an accessory is added, modiffied or deleted in the handling unit.
--  130308  MeAblk   Converted the method New___ into public method New.
--  130223  MeAblk   Implemented new method New.
--  130221  MaEelk   Added Get_Connected_Accessory_Weight to calculete the weight of all accessories connected to a handling unit
--  121129  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Quantity___ (
   quantity_ IN NUMBER )
IS
BEGIN
   
   IF (quantity_ <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'QTYERROR: Quantity must be greater than zero.');
   END IF;
END Check_Quantity___ ;


PROCEDURE Remove_Gross_Weight___ (
handling_unit_id_  IN NUMBER )
IS
   root_shipment_id_  NUMBER;
BEGIN
   Handling_Unit_API.Remove_Manual_Gross_Weight(handling_unit_id_);
   root_shipment_id_ := Handling_Unit_API.Get_Shipment_Id(handling_unit_id_);
   IF (root_shipment_id_ IS NOT NULL) THEN
      $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
         Shipment_API.Remove_Manual_Gross_Weight(root_shipment_id_);
      $ELSE
         NULL;            
      $END          
   END IF;
END Remove_Gross_Weight___;


PROCEDURE Remove_Manual_Volume___ (
handling_unit_id_  IN NUMBER )
IS
BEGIN
   Handling_Unit_API.Remove_Manual_Volume(handling_unit_id_);
END Remove_Manual_Volume___;


-- Calculate_Shipment_Charges___
--   This method will calculate the shipment freight charges if any change that affects the weight and volume of the shipment is occurred.
PROCEDURE Calculate_Shipment_Charges___ (
   handling_unit_id_  IN NUMBER )
IS
   shipment_id_    NUMBER;
BEGIN
   shipment_id_ := Handling_Unit_API.Get_Shipment_Id(handling_unit_id_);
   IF (shipment_id_ IS NOT NULL) THEN
      $IF (Component_Order_SYS.INSTALLED) $THEN
         Shipment_Freight_Charge_API.Calculate_Shipment_Charges(shipment_id_, NULL, NULL, NULL, NULL, 1);
      $ELSE
         NULL;
      $END
   END IF;
END Calculate_Shipment_Charges___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT accessory_on_handling_unit_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Remove_Gross_Weight___(newrec_.handling_unit_id);
   IF (Handling_Unit_Accessory_API.Get_Additive_Volume_Db(newrec_.handling_unit_accessory_id) = Fnd_Boolean_API.DB_TRUE) THEN
      Remove_Manual_Volume___(newrec_.handling_unit_id);
   END IF;
   Calculate_Shipment_Charges___(newrec_.handling_unit_id);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     accessory_on_handling_unit_tab%ROWTYPE,
   newrec_     IN OUT accessory_on_handling_unit_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (newrec_.quantity != oldrec_.quantity) THEN
      Remove_Gross_Weight___(newrec_.handling_unit_id);
      IF (Handling_Unit_Accessory_API.Get_Additive_Volume_Db(newrec_.handling_unit_accessory_id) = Fnd_Boolean_API.DB_TRUE) THEN
         Remove_Manual_Volume___(newrec_.handling_unit_id);
      END IF;
      Calculate_Shipment_Charges___(newrec_.handling_unit_id);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN accessory_on_handling_unit_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   IF (Handling_Unit_API.Exists(remrec_.handling_unit_id)) THEN
      Remove_Gross_Weight___(remrec_.handling_unit_id);
      IF (Handling_Unit_Accessory_API.Get_Additive_Volume_Db(remrec_.handling_unit_accessory_id) = Fnd_Boolean_API.DB_TRUE) THEN
         Remove_Manual_Volume___(remrec_.handling_unit_id);
      END IF;
      Calculate_Shipment_Charges___(remrec_.handling_unit_id);
   END IF;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT accessory_on_handling_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   
   Check_Quantity___(newrec_.quantity);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     accessory_on_handling_unit_tab%ROWTYPE,
   newrec_ IN OUT accessory_on_handling_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   Check_Quantity___(newrec_.quantity);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Handling_Unit_Connected_Exist (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM accessory_on_handling_unit_tab
      WHERE handling_unit_id = handling_unit_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO temp_;
   IF(exist_control%NOTFOUND) THEN
      CLOSE exist_control;
      RETURN Fnd_Boolean_API.DB_FALSE;
   ELSE
      CLOSE exist_control;
      RETURN Fnd_Boolean_API.DB_TRUE;
   END IF;
END Handling_Unit_Connected_Exist;


PROCEDURE New (
   handling_unit_id_           IN NUMBER,
   handling_unit_accessory_id_ IN VARCHAR2,
   quantity_                   IN NUMBER )
IS
   newrec_     accessory_on_handling_unit_tab%ROWTYPE;
BEGIN
   newrec_.handling_unit_id           := handling_unit_id_;
   newrec_.handling_unit_accessory_id := handling_unit_accessory_id_;
   newrec_.quantity                   := quantity_;
   New___(newrec_);
END New;   


PROCEDURE Change_Handling_Unit_Id (
   old_handling_unit_id_           IN NUMBER,
   new_handling_unit_id_           IN NUMBER,
   handling_unit_accessory_id_     IN VARCHAR2,
   quantity_                       IN NUMBER )
IS
   oldrec_  accessory_on_handling_unit_tab%ROWTYPE;
   newrec_  accessory_on_handling_unit_tab%ROWTYPE;
BEGIN
   IF NOT Check_Exist___(old_handling_unit_id_, handling_unit_accessory_id_) THEN
      Error_SYS.Record_General(lu_name_, 'NOSUCHACC: There is no accessory :P1 on handling unit :P2', 
         handling_unit_accessory_id_, old_handling_unit_id_);
   END IF;
   
   oldrec_ := Get_Object_By_Keys___(old_handling_unit_id_, handling_unit_accessory_id_);
   
   IF oldrec_.quantity = quantity_ THEN
      Remove___(oldrec_);
   ELSIF oldrec_.quantity > quantity_ THEN
      oldrec_.quantity := oldrec_.quantity - quantity_;
      Modify___(oldrec_);
   ELSE
      Error_SYS.Record_General(lu_name_, 'QTYEXCEEDED: You only have :P1 pcs of accessory :P2 to move on Handling Unit :P3' , 
         oldrec_.quantity, handling_unit_accessory_id_, old_handling_unit_id_);
   END IF;
   
   IF Check_Exist___(new_handling_unit_id_, handling_unit_accessory_id_) THEN
      newrec_ := Get_Object_By_Keys___(new_handling_unit_id_, handling_unit_accessory_id_);
      newrec_.quantity := newrec_.quantity + quantity_;
      Modify___(newrec_);
   ELSE
      New(new_handling_unit_id_, handling_unit_accessory_id_, quantity_);
   END IF;
END Change_Handling_Unit_Id;


PROCEDURE Copy (
   from_handling_unit_id_ IN NUMBER,
   to_handling_unit_id_   IN NUMBER )
IS
   CURSOR get_accessories IS
      SELECT handling_unit_accessory_id, quantity
      FROM accessory_on_handling_unit_tab
      WHERE handling_unit_id = from_handling_unit_id_;
BEGIN
   
   FOR rec_ IN get_accessories LOOP 
      New(to_handling_unit_id_, rec_.handling_unit_accessory_id, rec_.quantity);
   END LOOP;
END Copy;


@UncheckedAccess
FUNCTION Get_Connected_Accessory_Weight (
   handling_unit_id_      IN NUMBER,
   uom_for_weight_        IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_connected_accessories IS
      SELECT handling_unit_accessory_id, quantity
      FROM   accessory_on_handling_unit_tab
      WHERE  handling_unit_id = handling_unit_id_;
   
   handling_unit_accessory_rec_  Handling_Unit_Accessory_API.Public_Rec;
   connected_accessory_weight_ NUMBER := 0; 
      
BEGIN
   FOR connected_accessories_ IN get_connected_accessories LOOP
      handling_unit_accessory_rec_  := Handling_Unit_Accessory_API.Get(connected_accessories_.handling_unit_accessory_id);
      connected_accessory_weight_ := connected_accessory_weight_ + connected_accessories_.quantity * NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_accessory_rec_.weight,
                                                                                                                    handling_unit_accessory_rec_.uom_for_weight,
                                                                                                                    uom_for_weight_),0);
   END LOOP;      
   RETURN connected_accessory_weight_;
END Get_Connected_Accessory_Weight;


@UncheckedAccess
FUNCTION Get_Connected_Accessory_Volume (
   handling_unit_id_ IN NUMBER,
   uom_for_volume_   IN VARCHAR2,
   additive_volume_  IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_connected_accessories IS
      SELECT handling_unit_accessory_id, quantity
      FROM   accessory_on_handling_unit_tab
      WHERE  handling_unit_id = handling_unit_id_;

   handling_unit_accessory_rec_  Handling_Unit_Accessory_API.Public_Rec;
   connected_accessory_volume_   NUMBER := 0; 

BEGIN
   FOR connected_accessories_ IN get_connected_accessories LOOP
      handling_unit_accessory_rec_  := Handling_Unit_Accessory_API.Get(connected_accessories_.handling_unit_accessory_id);
      IF (additive_volume_ IS NOT NULL) THEN
         IF (handling_unit_accessory_rec_.additive_volume = additive_volume_) THEN 
            connected_accessory_volume_ := connected_accessory_volume_ + connected_accessories_.quantity * NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_accessory_rec_.volume,
                                                                                                                                                            handling_unit_accessory_rec_.uom_for_volume,
                                                                                                                                                            uom_for_volume_),0);
         END IF;
      ELSE
         -- this would sum up the volume irrespective of the value of additive volume
            connected_accessory_volume_ := connected_accessory_volume_ + connected_accessories_.quantity * NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(handling_unit_accessory_rec_.volume,
                                                                                                                                                            handling_unit_accessory_rec_.uom_for_volume,
                                                                                                                                                            uom_for_volume_),0);          
      END IF;
   END LOOP;      
   RETURN connected_accessory_volume_;
END Get_Connected_Accessory_Volume;


@UncheckedAccess
FUNCTION Contains_Additive_Volume (
   handling_unit_id_ IN NUMBER ) RETURN BOOLEAN
IS
   accessory_exists_  BOOLEAN := FALSE;
   
   CURSOR get_connected_accessories IS
      SELECT handling_unit_accessory_id
      FROM accessory_on_handling_unit_tab
      WHERE handling_unit_id = handling_unit_id_;
BEGIN
   FOR connected_accessories_ IN get_connected_accessories LOOP
      IF (Handling_Unit_Accessory_API.Get_Additive_Volume_Db(connected_accessories_.handling_unit_accessory_id) = Fnd_Boolean_API.DB_TRUE) THEN 
         accessory_exists_ := TRUE;
         EXIT;
      END IF;         
   END LOOP;
   RETURN accessory_exists_;   
END Contains_Additive_Volume;


PROCEDURE Calculate_Shipment_Charges (
   handling_unit_accessory_id_ IN VARCHAR2 )
IS

BEGIN
   $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
      DECLARE
         CURSOR get_shipment_id IS
         SELECT DISTINCT Handling_unit_API.Get_Shipment_Id(handling_unit_id) 
         FROM   accessory_on_handling_unit_tab
         WHERE  handling_unit_accessory_id = handling_unit_accessory_id_;   
         
         shipment_id_tab_  Shipment_API.Shipment_Id_Tab;         
      BEGIN
         OPEN get_shipment_id;
         FETCH get_shipment_id BULK COLLECT INTO shipment_id_tab_;
         CLOSE get_shipment_id;
         
         IF (shipment_id_tab_.COUNT >0) THEN
            $IF (Component_Order_SYS.INSTALLED) $THEN
               Shipment_Freight_Charge_API.Calculate_Shipment_Charges(shipment_id_tab_);
            $ELSE
               NULL;
            $END
         END IF;
      END;
   $ELSE
      NULL;
   $END
END Calculate_Shipment_Charges;


PROCEDURE Remove (
   handling_unit_id_ IN NUMBER )
IS
   CURSOR get_records IS
      SELECT *
      FROM accessory_on_handling_unit_tab
      WHERE handling_unit_id = handling_unit_id_
      FOR UPDATE;
BEGIN
   FOR remrec_ IN get_records LOOP
      Remove___(remrec_);
   END LOOP;
END Remove;

