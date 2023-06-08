-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210629  SBalLK  SC21R2-1426, Added Remove_Remote_Warehouse() method to clean and remove specific warehouse.
--  210521  SBalLK  SC21R2-1272, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Create_Default_Inventory_Location___(
   location_no_      OUT VARCHAR2,
   contract_         IN  VARCHAR2,
   warehouse_id_     IN  VARCHAR2,
   location_group_   IN  VARCHAR2 )
IS
BEGIN
   Warehouse_Bay_Bin_API.New( location_no_,
                              contract_,
                              warehouse_id_,
                              location_group_,
                              Warehouse_Bay_API.default_bay_id_,
                              Warehouse_Bay_Tier_API.default_tier_id_,
                              Warehouse_Bay_Row_API.default_row_id_,
                              Warehouse_Bay_Bin_API.default_bin_id_);
   
   $IF Component_Discom_SYS.INSTALLED $THEN
      Warehouse_Default_Location_API.New(contract_, warehouse_id_, Inventory_Location_Group_API.Get_Inventory_Location_Type_Db(location_group_), location_no_);
   $END
END Create_Default_Inventory_Location___;

PROCEDURE Raise_Non_Remote_Whse_Exist___ (
   contract_      IN VARCHAR2,
   warehouse_id_  IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NONREMOTEWHSEEXIST: Warehouse :P1 already exists in site :P2 as non remote warehouse.', warehouse_id_, contract_);
END Raise_Non_Remote_Whse_Exist___;

PROCEDURE Raise_Warehouse_Not_In_Address___ (
   contract_         IN VARCHAR2,
   warehouse_id_     IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'REMOTEWHSENOTINADD: Remote warehouse :P1 in site :P2 is already exists in diffrent address.', warehouse_id_, contract_);
END Raise_Warehouse_Not_In_Address___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Create_Remote_Warehouse(
   location_no_                OUT VARCHAR2,
   warehouse_id_            IN OUT VARCHAR2,
   contract_                IN     VARCHAR2,
   address_type_db_         IN     VARCHAR2,
   address_type_id_         IN     VARCHAR2,
   address_id_              IN     VARCHAR2,
   receive_case_db_         IN     VARCHAR2 DEFAULT NULL,
   location_group_          IN     VARCHAR2 DEFAULT NULL,
   availability_control_id_ IN     VARCHAR2 DEFAULT NULL,
   ship_via_code_           IN     VARCHAR2 DEFAULT NULL,
   delivery_terms_          IN     VARCHAR2 DEFAULT NULL,
   whse_description_        IN     VARCHAR2 DEFAULT NULL )
IS
   remote_warehouse_exists_   BOOLEAN := FALSE; 
   $IF Component_Discom_SYS.INSTALLED $THEN
      warehouse_id_tab_       Whse_Shipment_Receipt_Info_API.Warehouse_Id_Tab;
   $END
BEGIN
   IF (warehouse_id_ IS NOT NULL ) THEN
      IF (Warehouse_API.Exists(contract_, warehouse_id_)) THEN
         IF (Warehouse_API.Is_Remote(contract_, warehouse_id_) = Fnd_Boolean_API.DB_TRUE ) THEN
            $IF Component_Discom_SYS.INSTALLED $THEN
               IF (Whse_Shipment_Receipt_Info_API.Is_Warehouse_In_Address(contract_, warehouse_id_, address_type_db_, address_type_id_, address_id_)) THEN
                  remote_warehouse_exists_ := TRUE;
               ELSE
                  Raise_Warehouse_Not_In_Address___(contract_, warehouse_id_);
               END IF;
            $ELSE
               NULL;
               -- DISCOM component is not installed.
            $END
         ELSE
            Raise_Non_Remote_Whse_Exist___(contract_, warehouse_id_);
         END IF;
      END IF;
   ELSE
      $IF Component_Discom_SYS.INSTALLED $THEN
         warehouse_id_tab_ := Whse_Shipment_Receipt_Info_API.Get_Warehouses_For_Address(contract_, address_type_db_, address_type_id_, address_id_);
         IF ( warehouse_id_tab_.count > 0 ) THEN
            FOR i_ IN warehouse_id_tab_.FIRST..warehouse_id_tab_.LAST LOOP
               -- Even there is a warehouse exists for the same location but not a remote warehouse
               -- system will generate new remote warehouse for the location.
               IF (Warehouse_API.Is_Remote(contract_, warehouse_id_tab_(i_)) = Fnd_Boolean_API.DB_TRUE) THEN
                  warehouse_id_            := warehouse_id_tab_(i_);
                  remote_warehouse_exists_ := TRUE;
                  EXIT;
               END IF;
            END LOOP;
         END IF;
      $ELSE
         NULL;
         -- DISCOM component is not installed.
      $END
   END IF;

   IF (NOT remote_warehouse_exists_) THEN
      -- Even it is possible to create simple warehouse though WarehouseBayBin method used seperate 
      -- implemenation to deal with additional parameters needed.
      Warehouse_API.New(warehouse_id_,
                        contract_,
                        whse_description_,
                        availability_control_id_,
                        remote_warehouse_db_          => Fnd_Boolean_API.DB_TRUE,
                        putaway_destination_db_       => Fnd_Boolean_API.DB_FALSE,
                        auto_refill_putaway_zones_db_ => Fnd_Boolean_API.DB_FALSE,
                        auto_created_db_              => Fnd_Boolean_API.DB_TRUE,
                        auto_generate_warehouse_id_   => TRUE );

      -- Create warehouse Bay
      IF (location_group_ IS NOT NULL ) THEN
         Create_Default_Inventory_Location___(location_no_, contract_, warehouse_id_, location_group_);
      END IF;

      -- Create Shipment Receipt Information
      IF (address_type_db_ IS NOT NULL ) THEN
         $IF Component_Discom_SYS.INSTALLED $THEN
            Whse_Shipment_Receipt_Info_API.New(contract_,        warehouse_id_,  address_type_db_, address_type_id_, address_id_,
                                               receive_case_db_, ship_via_code_, delivery_terms_);
         $ELSE
            NULL;
            -- DISCOM component is not installed.
         $END
      END IF;
   ELSE
      location_no_ := Warehouse_Bay_Bin_API.Get_First_Existing_Location(contract_, warehouse_id_, Inventory_Location_Type_API.DB_PICKING);
   END IF;
END Create_Remote_Warehouse;

PROCEDURE Remove_Remote_Warehouse(
   contract_      IN VARCHAR2,
   warehouse_id_  IN VARCHAR2)
IS
   
BEGIN
   IF ( Warehouse_API.Exists(contract_, warehouse_id_) ) THEN
      -- Remove warehouse/ attched locations. Exisitance of warehouse already validated.
      Warehouse_API.Remove(contract_, warehouse_id_);
   END IF;
END Remove_Remote_Warehouse;

-------------------- LU  NEW METHODS -------------------------------------
