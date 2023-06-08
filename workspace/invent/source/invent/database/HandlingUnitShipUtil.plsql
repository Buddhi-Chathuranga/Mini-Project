-----------------------------------------------------------------------------
--
--  Logical unit: HandlingUnitShipUtil
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170202  Chfose  LIM-10117, Reworked alot of methods to be able to include HandlingUnitHistory when needed.
--  170104  MaIklk  LIM-9397, Replaced the Shipment_handling_Utility_API.Calculate_Shipment_Charges() call with Shipment_Freight_Charge_API.Calculate_Shipment_Charges().
--  161117  Chfose  LIM-9436, Moved logic regarding Adding/Removing HU to/from a Shipment to ShipmentHandlingUtility(SHPMNT).
--  161025  DaZase  LIM-7326, Added methods Get_Print_Shp_Labels_For_Shp and Print_Shp_Labels_Exist_On_Shp.
--  161018  Chfose  LIM-9300, Separated disconnect and delete of handling unit from shipment.
--  160928  Chfose  LIM-8612, Added methods for integration between handling units in shipment and inventory (connecting/disconnecting).
--  160607  RoJalk  LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  151204  Chfose  LIM-4842, Created. Contains methods originating from HandlingUnit.plsql.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


@UncheckedAccess
FUNCTION Shipment_Has_Hu_Connected (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_           NUMBER;
   shipment_exist_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

   CURSOR check_exist IS
      SELECT 1
      FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
      WHERE shipment_id = shipment_id_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO temp_;
   IF(check_exist%FOUND) THEN
      shipment_exist_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   CLOSE check_exist;
   RETURN shipment_exist_;
END Shipment_Has_Hu_Connected;


@UncheckedAccess
FUNCTION Get_Shipment_Tare_Weight (
   shipment_id_    IN NUMBER,
   uom_for_weight_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_top_handling_units IS
      SELECT handling_unit_id, uom_for_weight, tare_weight
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND parent_handling_unit_id IS NULL;
   
   tare_weight_  NUMBER := 0; 
BEGIN
   FOR rec_ IN get_top_handling_units LOOP
      IF (rec_.uom_for_weight != uom_for_weight_) THEN
         tare_weight_ := tare_weight_ + Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_    => rec_.tare_weight,
                                                                                 from_unit_code_   => rec_.uom_for_weight,
                                                                                 to_unit_code_     => uom_for_weight_);
      ELSE
         tare_weight_ := tare_weight_ + rec_.tare_weight;
      END IF;
   END LOOP;
   
   RETURN tare_weight_;
END Get_Shipment_Tare_Weight;


@UncheckedAccess
FUNCTION Get_Ship_Operat_Gross_Weight (
   shipment_id_          IN NUMBER,
   uom_for_weight_       IN VARCHAR2,
   apply_freight_factor_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_top_handling_units IS  
      SELECT handling_unit_id, operative_gross_weight, adjust_operat_gross_weight, uom_for_weight
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND parent_handling_unit_id IS NULL;
   
   operative_gross_weight_      NUMBER := 0;
   hu_operative_gross_weight_   NUMBER;
BEGIN
   FOR rec_ IN get_top_handling_units LOOP
      IF (apply_freight_factor_ = 'TRUE') THEN
         hu_operative_gross_weight_ := rec_.adjust_operat_gross_weight;
      ELSE
         hu_operative_gross_weight_ := rec_.operative_gross_weight;
      END IF;
      
      IF (rec_.uom_for_weight != uom_for_weight_) THEN
         hu_operative_gross_weight_ := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_    => hu_operative_gross_weight_, 
                                                                                 from_unit_code_   => rec_.uom_for_weight, 
                                                                                 to_unit_code_     => uom_for_weight_);
      END IF;
      
      operative_gross_weight_ := operative_gross_weight_ + hu_operative_gross_weight_;
   END LOOP;
                                                                
   RETURN operative_gross_weight_;
END Get_Ship_Operat_Gross_Weight;


@UncheckedAccess
FUNCTION Get_Shipment_Net_Weight (
   shipment_id_          IN NUMBER,
   uom_for_weight_       IN VARCHAR2,
   apply_freight_factor_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_top_handling_units IS  
      SELECT handling_unit_id, net_weight, adjusted_net_weight, uom_for_weight
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND parent_handling_unit_id IS NULL;
   
   net_weight_      NUMBER := 0;
   hu_net_weight_   NUMBER;
BEGIN
   FOR rec_ IN get_top_handling_units LOOP
      IF (apply_freight_factor_ = 'TRUE') THEN
         hu_net_weight_ := rec_.adjusted_net_weight;
      ELSE
         hu_net_weight_ := rec_.net_weight;
      END IF;
      
      IF (rec_.uom_for_weight != uom_for_weight_) THEN
         hu_net_weight_ := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_     => hu_net_weight_, 
                                                                     from_unit_code_    => rec_.uom_for_weight, 
                                                                     to_unit_code_      => uom_for_weight_);
      END IF;
      
      net_weight_ := net_weight_ + hu_net_weight_;
   END LOOP;
                                
   RETURN net_weight_;
END Get_Shipment_Net_Weight; 


@UncheckedAccess
FUNCTION Get_Ship_Operat_Volume (
   shipment_id_    IN NUMBER,
   uom_for_volume_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_top_handling_units IS 
     SELECT handling_unit_id, uom_for_volume, operative_volume
       FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
      WHERE shipment_id = shipment_id_
        AND parent_handling_unit_id IS NULL;
   
   operative_volume_  NUMBER := 0;  
BEGIN
   FOR rec_ IN get_top_handling_units LOOP
      IF (rec_.uom_for_volume != uom_for_volume_) THEN
         operative_volume_ := operative_volume_ + Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_  => rec_.operative_volume,
                                                                                           from_unit_code_ => rec_.uom_for_volume,
                                                                                           to_unit_code_   => uom_for_volume_);
      ELSE
         operative_volume_ := operative_volume_ + rec_.operative_volume;
      END IF;
   END LOOP;
   
   RETURN operative_volume_;
END Get_Ship_Operat_Volume;


PROCEDURE Create_Ssccs_For_Shipment (
   shipment_id_ IN NUMBER)
IS
   CURSOR get_top_level_hus IS
      SELECT handling_unit_id, generate_sscc_no, sscc
        FROM HANDLING_UNIT_TAB
       WHERE shipment_id = shipment_id_
         AND parent_handling_unit_id IS NULL;
BEGIN
   FOR handling_unit_ IN get_top_level_hus LOOP
      Handling_Unit_API.Create_Ssccs_For_Structure(handling_unit_.handling_unit_id);
   END LOOP;
END Create_Ssccs_For_Shipment;


PROCEDURE Get_Print_Labels_For_Shipment (
   handling_unit_info_list_ OUT VARCHAR2,
   shipment_id_             IN NUMBER,
   handling_unit_id_        IN NUMBER DEFAULT NULL )
IS
   CURSOR get_print_labels IS
      SELECT handling_unit_id, no_of_handling_unit_labels
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND print_label_db = Fnd_Boolean_API.DB_TRUE;
       
   CURSOR get_print_labels_for_struct IS
      SELECT handling_unit_id, no_of_handling_unit_labels
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND print_label_db = Fnd_Boolean_API.DB_TRUE
     CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
       START WITH     handling_unit_id = handling_unit_id_;

   local_info_list_ VARCHAR2(2000) := NULL;
BEGIN 
   IF (handling_unit_id_ IS NULL) THEN
      FOR rec_ IN get_print_labels LOOP
         local_info_list_ := local_info_list_ || rec_.handling_unit_id || '^' || rec_.no_of_handling_unit_labels || '^';
      END LOOP;   
   ELSE
      FOR rec_ IN get_print_labels_for_struct LOOP
         local_info_list_ := local_info_list_ || rec_.handling_unit_id || '^' || rec_.no_of_handling_unit_labels || '^';
      END LOOP;
   END IF;
   
   handling_unit_info_list_ := local_info_list_;
END Get_Print_Labels_For_Shipment;


PROCEDURE Get_Print_Shp_Labels_For_Shp (
   handling_unit_info_list_ OUT VARCHAR2,
   shipment_id_             IN NUMBER,
   handling_unit_id_        IN NUMBER DEFAULT NULL )
IS
   CURSOR get_print_shp_labels IS
      SELECT handling_unit_id, no_of_shipment_labels
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND print_shipment_label_db = Fnd_Boolean_API.DB_TRUE;
         
   CURSOR get_print_shp_labels_struct IS
      SELECT handling_unit_id, no_of_shipment_labels
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND print_shipment_label_db = Fnd_Boolean_API.DB_TRUE
     CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
       START WITH     handling_unit_id = handling_unit_id_;
      
   local_info_list_ VARCHAR2(2000) := NULL;
BEGIN
   IF (handling_unit_id_ IS NULL) THEN
      FOR rec_ IN get_print_shp_labels LOOP
         local_info_list_ := local_info_list_ || rec_.handling_unit_id || '^' || rec_.no_of_shipment_labels || '^';
      END LOOP; 
   ELSE
      FOR rec_ IN get_print_shp_labels_struct LOOP
         local_info_list_ := local_info_list_ || rec_.handling_unit_id || '^' || rec_.no_of_shipment_labels || '^';
      END LOOP; 
   END IF;
   
   handling_unit_info_list_ := local_info_list_;
END Get_Print_Shp_Labels_For_Shp;


@UncheckedAccess
FUNCTION Print_Labels_Exist_On_Shipment (
   shipment_id_      IN NUMBER,
   handling_unit_id_ IN NUMBER DEFAULT NULL ) RETURN VARCHAR2
IS
   CURSOR check_print_labels IS
      SELECT 1
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND print_label_db = Fnd_Boolean_API.DB_TRUE;
         
   CURSOR check_print_labels_for_struct IS
      SELECT 1
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND print_label_db = Fnd_Boolean_API.DB_TRUE
     CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
       START WITH     handling_unit_id = handling_unit_id_;
         
   temp_              NUMBER;
   print_label_exist_ VARCHAR2(20) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF (handling_unit_id_ IS NULL) THEN
      OPEN check_print_labels;
      FETCH check_print_labels INTO temp_;
      IF (check_print_labels%FOUND) THEN
         print_label_exist_ := Fnd_Boolean_API.DB_TRUE;
      END IF;   
      CLOSE check_print_labels;
   ELSE
      OPEN check_print_labels_for_struct;
      FETCH check_print_labels_for_struct INTO temp_;
      IF (check_print_labels_for_struct%FOUND) THEN
         print_label_exist_ := Fnd_Boolean_API.DB_TRUE;
      END IF;   
      CLOSE check_print_labels_for_struct;
   END IF;
      
   RETURN print_label_exist_;
END Print_Labels_Exist_On_Shipment;


@UncheckedAccess
FUNCTION Print_Shp_Labels_Exist_On_Shp (
   shipment_id_      IN NUMBER,
   handling_unit_id_ IN NUMBER DEFAULT NULL ) RETURN VARCHAR2
IS
   CURSOR check_print_labels IS
      SELECT 1
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND print_shipment_label_db = Fnd_Boolean_API.DB_TRUE;
         
   CURSOR check_print_labels_for_struct IS
      SELECT 1
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND print_shipment_label_db = Fnd_Boolean_API.DB_TRUE
     CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
       START WITH handling_unit_id = handling_unit_id_;
         
   temp_              NUMBER;
   print_label_exist_ VARCHAR2(20) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF (handling_unit_id_ IS NULL) THEN
      OPEN check_print_labels;
      FETCH check_print_labels INTO temp_;
      IF (check_print_labels%FOUND) THEN
         print_label_exist_ := Fnd_Boolean_API.DB_TRUE;
      END IF;   
      CLOSE check_print_labels;
   ELSE
      OPEN check_print_labels_for_struct;
      FETCH check_print_labels_for_struct INTO temp_;
      IF (check_print_labels_for_struct%FOUND) THEN
         print_label_exist_ := Fnd_Boolean_API.DB_TRUE;
      END IF;   
      CLOSE check_print_labels_for_struct;
   END IF;
      
   RETURN print_label_exist_;
END Print_Shp_Labels_Exist_On_Shp;

 
FUNCTION Get_Top_Level_Hand_Units (
   shipment_id_ IN NUMBER ) RETURN Handling_Unit_API.Handling_Unit_Id_Tab
IS
   CURSOR get_top_level_hus IS
      SELECT handling_unit_id
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND parent_handling_unit_id IS NULL;
   handling_unit_id_tab_ Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   OPEN get_top_level_hus;
   FETCH get_top_level_hus BULK COLLECT INTO handling_unit_id_tab_;
   CLOSE get_top_level_hus;

   RETURN handling_unit_id_tab_;
END Get_Top_Level_Hand_Units;
   

@UncheckedAccess
FUNCTION Get_Top_Level_Hu_Count (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   hu_count_ NUMBER;

   CURSOR get_top_level_hu_count IS
      SELECT COUNT(handling_unit_id)
      FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
      WHERE shipment_id = shipment_id_
      AND   parent_handling_unit_id IS NULL;
BEGIN
   OPEN get_top_level_hu_count;
   FETCH get_top_level_hu_count INTO  hu_count_;
   CLOSE get_top_level_hu_count;   
   RETURN hu_count_;
END Get_Top_Level_Hu_Count;    


@UncheckedAccess
FUNCTION Get_Second_Level_Hu_Count (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   second_level_hu_count_ NUMBER;

   CURSOR get_second_level_hu_count IS
      SELECT COUNT(handling_unit_id)
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND parent_handling_unit_id IN (SELECT handling_unit_id
                                           FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
                                          WHERE shipment_id = shipment_id_
                                            AND parent_handling_unit_id IS NULL);
BEGIN
   OPEN get_second_level_hu_count;
   FETCH get_second_level_hu_count INTO second_level_hu_count_;
   CLOSE get_second_level_hu_count;
   
   RETURN second_level_hu_count_; 
END Get_Second_Level_Hu_Count;   


PROCEDURE Calc_Ship_Charges_By_Hu_Type (
   handling_unit_type_id_ IN VARCHAR2 )
IS
BEGIN
   $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
      DECLARE
         CURSOR get_shipment_id IS
            SELECT DISTINCT shipment_id 
            FROM   SHPMNT_HANDL_UNIT_WITH_HISTORY
            WHERE  handling_unit_type_id = handling_unit_type_id_;   
         
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
END Calc_Ship_Charges_By_Hu_Type;


FUNCTION Is_Connected_To_Shipment_Lines (
   shipment_id_      IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_structure IS
      SELECT handling_unit_id
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
     CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
       START WITH     handling_unit_id = handling_unit_id_;
   
   is_connected_      VARCHAR2(20) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   FOR rec_ IN get_structure LOOP
      $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
         is_connected_ := Shipment_Line_Handl_Unit_API.Handling_Unit_Exist(shipment_id_, rec_.handling_unit_id);  
      $END  
      EXIT WHEN (is_connected_ = Fnd_Boolean_API.DB_TRUE);
   END LOOP;

   RETURN(is_connected_);
END Is_Connected_To_Shipment_Lines;


@UncheckedAccess
FUNCTION Has_Parent_At_Any_Level (
   shipment_id_             IN NUMBER,
   handling_unit_id_        IN NUMBER,
   parent_handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_parents IS
      SELECT handling_unit_id
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
          CONNECT BY handling_unit_id = PRIOR parent_handling_unit_id
          START WITH handling_unit_id = handling_unit_id_;
   
   has_parent_at_any_level_ VARCHAR2(5) := 'FALSE';
BEGIN
   FOR rec_ IN get_parents LOOP
      IF (rec_.handling_unit_id = parent_handling_unit_id_) THEN
         has_parent_at_any_level_ := 'TRUE';
         EXIT;
      END IF;
   END LOOP;

   RETURN(has_parent_at_any_level_);
END Has_Parent_At_Any_Level;

