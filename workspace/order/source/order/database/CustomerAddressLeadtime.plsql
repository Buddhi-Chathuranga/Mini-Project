-----------------------------------------------------------------------------
--
--  Logical unit: CustomerAddressLeadtime
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200601  Aabalk  SCSPRING20-1687, Moved code to check if entered location is a shipment location, from Check_Insert___ and Check_Update___
--  200601          to Check_Common___. Modified Check_Common___ by adding a check to validate if selected shipment location is a non-remote warehouse location.
--  150813  Wahelk  BLU-1192, Modified Copy_Customer method by adding new parameter copy_info_
--  150812  Wahelk  BLU-1191, Removed method Copy_Customer_Def_Address
--  150713  Wahelk  BLU-958, Modified Copy_Customer_Def_Address
--  150710  Wahelk  BLU-958, Added Copy_Customer_Def_Address
--  140123  MaIklk  EAP-910, Overridden Insert() and handled default ship via value.
--  141217  MaIklk  PRSC-974, Restricted to entering value for prospects.
--  141107  MaRalk  PRSC-3112, Removed parameter convert_customer_ from Copy_Customer method.
--  140711  MaIklk  PRSC-1761, Implemented to preserve records if customer is existing in copy_customer().
--  140505  MaRalk  PBSC-8721, Added method Check_Customer_No_Ref___ to avoid unnecessary error 'Customer is not of category Customer'.
--  140415  JanWse  PBSC-8348, Set ROWKEY to NULL before inserting in Copy_Customer
--  140224  SudJlk  Bug 111497, Modified Copy_Customer by selecting records for user allowed sites only to be copied to avoid user allowed restriction error .
--  130113  RoJalk  Moved the code related to manually_assigned_zone and default_ship_via in Check_Insert___ before not null checks.
--  13103   RoJalk  Modified the view comments of default_ship_via in the base view to be aligned with the model.
--  130715  MAHPLK  Removed attribute Load_Sequence_No.
--  130614  SURBLK  Added attribute forward_agent_id.
--  120912  MeAblk  Modified Unpack_Check_Insert___, Unpack_Check_Update___ in order to validate whether the entered location is a shipment location.  
--  120910  MeAblk  Added ship_inventory_location_no and accordingly done other modification. Also added function Get_Ship_Inventory_Location_No. 
--  120822  MeAblk  Unit testing corrections done on task BI-478.
--  120820  MeAblk  Added shipment_type and function Get_Shipment_Type.
--  120702  MAHPLK  Added attribute picking_leadtime.
--  120627  MaMalk  Added attributes ROUTE_ID and LOAD_SEQUENCE_NO.
--  130213  GayDLK  Bug 103827, Modified Unpack_Check_Insert___(), Unpack_Check_Update___(), Check_Delete___()  
--  130213          and CUSTOMER_ADDRESS_LEADTIME view by adding user allowed site validation. 
--  100811  MaHplk  Merged Bug 90108.
--  100806  MaHplk  Modified reference of the manually_assigned_zone to FndBoolean.
--  100513  Ajpelk  Merge rose method documentation
--  090925  MaMalk  Removed unused view CUSTOMER_ADDRESS_LEADTIME_ENT.
--  ------------------------- 14.0.0 -----------------------------------------
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  090806  ChFolk  Bug 84961, Removed NOCHECK for addr_no in CUSTOMER_ADDRESS_LEADTIME.
--  080917  MaHplk  Modified Unpack_Check_Insert___ to set default 'N' to manually_assigned_zone if it is null. 
--  080904  MaHplk  Added new method Modify_Zone_Info, and zone_definition_id, zone _id and manuallt_assign_zone to CustomerAddressLeadtime.
--  ------------------------ Nice Price ------------------------------------
--  060823  MiKulk  Modified the method Copy_Customer with better logic.
--  060726  ThGulk  Added Objid instead of rowid in Procedure Insert__
--  060516  MiErlk  Enlarge Identity - Changed view comment
--  060418  MaJalk  Enlarge Identity - Changed view comments of customer_id.
--  060410  IsWilk  Enlarge Identity - Changed view comments of customer_no.
--  ------------------------- 13.4.0 -----------------------------------------
--  040511  JaJalk  Corrected the lead time lables.
--  040220  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  ------------------------- 13.3.0 -----------------------------------------
--  020930  WaJalk  Modified method Unpack_Check_Insert___ to check the customer address type.
--  030922  ChBalk  Added new method Count_Rows.
--  030902  GaSolk  Performed CR Merge 2.
--  030819  WaJalk  Added code review modifications.
--  030702  NuFilk  Modified method Unpack_Check_Update___ to clear currency field if exp additional cost is null.
--  030702  NuFilk  Modified Delete___ removed restriction on delete.
--  030609  WaJalk  Modified the error message, when currency is not specified for the exp. additional cost.
--  030505  WaJalk  Added a check for ship via code in method Get_Default_Leadtime_Values.
--  030424  NuFilk  Reviewed Code and adjusted necessary.
--  030422  NuFilk  Added Method Get_Default_Ship_Via_Code and Get_Default_Leadtime_Values.
--  030418  NuFilk  Added public method Get_Default_Leadtime_Values and removed method Check_Ship_Via_Lines__.
--  030409  NuFilk  Added private method Check_Ship_Via_Lines__ and Modified Is_Default_Ship_Via,
--  030409          and Unpack_Check_Insert___.
--  030403  NuFilk  Added public attributes default_ship_via, currency_code, expected_additional_cost to the LU and method Is_Default_Ship_Via.
--  ***********************************CR Merge*******************************
--  000913  FBen  Added UNDEFINE.
--  000419  PaLj  Corrected Init_Method Errors
--  000228  MaGu  CID 32799. Modified method Copy_Customer.
--  991111  PaLj  Added Method Copy_Customer
--  991103  sami  Distans can not have negative value
--  991007  JoEd  Call Id 21210: Corrected double-byte problems.
--  990818  sami  New column(distance) added to Customer_address_leadtime_tab and function  Get_Distance added to Customer_address_leadtime_api
--  --------------------------- 11.1 ----------------------------------------
--  990416  JoAn  Yoshimura general changes.
--  990412  PaLj  YOSHIMURA - New Template
--  981202  JoEd  Changed use of Enterprise columns customer id and address id.
--  981006  CaSt  Added Site.
--  971120  RaKu  Changed to FND200 Templates.
--  970828  JoAn  Changes due to integration with Enterprise.
--                Added new view used from client.
--  970508  PAZE  Changed language_code length.
--  970312  RaKu  Changed table name.
--  970219  RaKu  Changed rowverion. (10.3 Project).
--  970206  RaKu  Added function-column language_code. BUG 97-0002 and 97-0003
--  960216  RaKu  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUSTOMER_ADDRESS_LEADTIME_TAB%ROWTYPE,
   newrec_     IN OUT CUSTOMER_ADDRESS_LEADTIME_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN   
   IF (newrec_.default_ship_via = 'Y') THEN
      UPDATE CUSTOMER_ADDRESS_LEADTIME_TAB
         SET default_ship_via = 'N',
             rowversion = sysdate
       WHERE customer_no = newrec_.customer_no
         AND addr_no = newrec_.addr_no
         AND contract = newrec_.contract
         AND default_ship_via = 'Y';
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CUSTOMER_ADDRESS_LEADTIME_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, remrec_.contract);
END Check_Delete___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     customer_address_leadtime_tab%ROWTYPE,
   newrec_ IN OUT customer_address_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   --  Added an IF condition to check whether entered location is a shipment location.
   IF (newrec_.ship_inventory_location_no IS NOT NULL) THEN
      Site_Discom_Info_API.Check_Site_Shipment_Location(newrec_.contract, newrec_.ship_inventory_location_no);
   END IF;
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_address_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   value_    VARCHAR2(100);
BEGIN   
   IF (newrec_.manually_assigned_zone IS NULL) THEN
      newrec_.manually_assigned_zone:= 'FALSE';
   END IF;
   
   IF (newrec_.default_ship_via IS NULL) THEN
      newrec_.default_ship_via:= Gen_Yes_No_API.DB_NO;
   END IF;
   
   IF (newrec_.customer_no IS NULL) THEN
      value_ := Client_SYS.Get_Item_Value('CUSTOMER_ID', attr_);
      IF (value_ IS NOT NULL) THEN
         newrec_.customer_no := value_;
         indrec_.customer_no := TRUE;
      END IF;      
   END IF;
   IF (newrec_.addr_no IS NULL) THEN
      value_ := Client_SYS.Get_Item_Value('ADDRESS_ID', attr_);
      IF (value_ IS NOT NULL) THEN
         newrec_.addr_no := value_;
         indrec_.addr_no := TRUE;
      END IF;      
   END IF;          
   super(newrec_, indrec_, attr_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   IF ((newrec_.freight_map_id IS NULL) AND (newrec_.zone_id IS NOT NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'ZONE_ID_NOT_EXIST: The Zone ID object does not exist');
   END IF;

   IF (Cust_Ord_Customer_Category_API.Encode(
       Cust_Ord_Customer_API.Get_Category(newrec_.customer_no)) = 'I' ) THEN
      Error_SYS.Record_General(lu_name_, 'CUST_TYPE_NOT_VALID: Only External Customer Info can be added');
   END IF;
   IF newrec_.delivery_leadtime < 0 OR newrec_.delivery_leadtime > 999 THEN
      Error_SYS.Record_General(lu_name_, 'LEADTIME_NOT_VALID: External transport lead time must be between 0 and 999');
   END IF;
   IF (newrec_.distance < 0) THEN
      Error_SYS.Record_General(lu_name_, 'DISTANCE_NOT_VALID: Distance can not have negative Value');
   END IF;
   IF (newrec_.expected_additional_cost < 0) THEN
      Error_SYS.Record_General(lu_name_, 'EXP_ADD_COST_NOT_VALID: Expected Additional Cost can not be a negative Value');
   END IF;
   IF ((newrec_.expected_additional_cost IS NOT NULL) AND (newrec_.currency_code IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOT_BE_NULL: Currency is mandatory when a value exists in the Expected Additional Cost field.');
   END IF;
   IF ((newrec_.expected_additional_cost IS NULL) AND (newrec_.currency_code IS NOT NULL)) THEN
      newrec_.currency_code := NULL;
      Client_SYS.Add_To_Attr('CURRENCY_CODE', newrec_.currency_code, attr_);
   END IF;
   IF Customer_Info_Address_Type_API.Check_Exist( newrec_.customer_no, newrec_.addr_no, Address_Type_Code_API.Decode( 'DELIVERY' )) != 'TRUE' THEN
      Error_SYS.Record_General(lu_name_, 'MUST_BE_DELIVERY: Customer address must be a delivery address.');
   END IF;
   IF newrec_.picking_leadtime IS NOT NULL THEN
      IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0) THEN
         Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'PICKVALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
      END IF;
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_address_leadtime_tab%ROWTYPE,
   newrec_ IN OUT customer_address_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   IF (Client_SYS.Get_Item_Value('CUSTOMER_ID', attr_) IS NOT NULL) THEN
      Validate_SYS.Item_Update(lu_name_, 'CUSTOMER_ID', TRUE);
   END IF;
   IF (Client_SYS.Get_Item_Value('ADDRESS_ID', attr_) IS NOT NULL) THEN
      Validate_SYS.Item_Update(lu_name_, 'ADDRESS_ID', TRUE);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   IF ((newrec_.freight_map_id IS NULL) AND (newrec_.zone_id IS NOT NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'ZONE_ID_NOT_EXIST: The Zone ID object does not exist');
   END IF;

   IF (newrec_.expected_additional_cost < 0) THEN
      Error_SYS.Record_General(lu_name_, 'EXP_ADD_COST_NOT_VALID: Expected Additional Cost can not be a negative Value');
   END IF;
   IF ((newrec_.expected_additional_cost IS NOT NULL) AND (newrec_.currency_code IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOT_BE_NULL: Currency is mandatory when a value exists in the Expected Additional Cost field.');
   END IF;
   IF ((newrec_.delivery_leadtime < 0) OR (newrec_.delivery_leadtime > 999)) THEN
      Error_SYS.Record_General(lu_name_, 'LEADTIME_NOT_VALID: External transport lead time must be between 0 and 999');
   END IF;
      IF (newrec_.distance < 0) THEN
      Error_SYS.Record_General(lu_name_, 'DISTANCE_NOT_VALID: Distance can not have negative Value');
   END IF;
   IF ((newrec_.expected_additional_cost IS NULL) AND (newrec_.currency_code IS NOT NULL)) THEN
      newrec_.currency_code := NULL;
      Client_SYS.Add_To_Attr('CURRENCY_CODE', newrec_.currency_code, attr_);
   END IF;
   IF newrec_.picking_leadtime IS NOT NULL THEN
      IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0) THEN
         Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'PICKVALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
      END IF;
   END IF;
END Check_Update___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT customer_address_leadtime_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 ) 
IS
BEGIN 
   IF (Is_Default_Ship_Via(newrec_.customer_no, newrec_.addr_no, newrec_.contract) = 'FALSE' ) THEN
      newrec_.default_ship_via := 'Y';
   ELSE
      IF(newrec_.default_ship_via = 'Y') THEN
        UPDATE customer_address_leadtime_tab
         SET default_ship_via = 'N',
             rowversion = sysdate
         WHERE customer_no = newrec_.customer_no
           AND addr_no = newrec_.addr_no
           AND contract = newrec_.contract
           AND default_ship_via = 'Y';
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('DEFAULT_SHIP_VIA_DB', newrec_.default_ship_via, attr_);      
   super(objid_, objversion_, newrec_, attr_);
END Insert___;
   
   
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Inserts new record
--   Creates a new record with delivery leadtime
PROCEDURE New (
   customer_no_       IN VARCHAR2,
   addr_no_           IN VARCHAR2,
   ship_via_code_     IN VARCHAR2,
   contract_          IN VARCHAR2,
   delivery_leadtime_ IN NUMBER )
IS
   newrec_     CUSTOMER_ADDRESS_LEADTIME_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_no_, attr_);
   Client_SYS.Add_To_Attr('ADDR_NO', addr_no_, attr_);
   Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', delivery_leadtime_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Modify_Delivery_Leadtime
--   Updates delivery leadtime
--   Modify delivery leadtime
PROCEDURE Modify_Delivery_Leadtime (
   customer_no_       IN VARCHAR2,
   addr_no_           IN VARCHAR2,
   ship_via_code_     IN VARCHAR2,
   contract_          IN VARCHAR2,
   delivery_leadtime_ IN NUMBER )
IS
   oldrec_     CUSTOMER_ADDRESS_LEADTIME_TAB%ROWTYPE;
   newrec_     CUSTOMER_ADDRESS_LEADTIME_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_   Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', delivery_leadtime_, attr_);
   oldrec_ := Lock_By_Keys___(customer_no_, addr_no_, ship_via_code_, contract_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Delivery_Leadtime;


-- Remove
--   Removes record
--   Removes a delivery leadtime record
PROCEDURE Remove (
   customer_no_   IN VARCHAR2,
   addr_no_       IN VARCHAR2,
   ship_via_code_ IN VARCHAR2,
   contract_      IN VARCHAR2 )
IS
   remrec_     CUSTOMER_ADDRESS_LEADTIME_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(customer_no_, addr_no_, ship_via_code_, contract_);
   Get_Id_Version_By_Keys___(objid_, objversion_, customer_no_, addr_no_, ship_via_code_, contract_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


-- Copy_Customer
--   Copies the customer information in Customer_Address_Leadtime_Tab to a
--   new customer id
PROCEDURE Copy_Customer (
   customer_id_      IN VARCHAR2,
   new_id_           IN VARCHAR2,
   copy_info_        IN  Customer_Info_API.Copy_Param_Info)
IS
   objid_                VARCHAR2(100);
   attr_                VARCHAR2(2000);
   objversion_           VARCHAR2(2000);
   indrec_               Indicator_Rec;
   new_del_address_      CUSTOMER_INFO_ADDRESS_TAB.address_id%TYPE;
   
   CURSOR get_attr IS
      SELECT *
      FROM CUSTOMER_ADDRESS_LEADTIME_TAB
      WHERE customer_no = customer_id_
      AND EXISTS (SELECT 1 
                  FROM user_allowed_site_pub 
                  WHERE site = contract);
                  
   CURSOR get_def_addr_leadtime IS
      SELECT *
      FROM CUSTOMER_ADDRESS_LEADTIME_TAB
      WHERE customer_no = customer_id_
      AND   addr_no = copy_info_.temp_del_addr
      AND EXISTS (SELECT 1 
                  FROM user_allowed_site_pub 
                  WHERE site = contract);
BEGIN
   IF (copy_info_.copy_convert_option = 'CONVERT' ) THEN   
      new_del_address_ := nvl(copy_info_.new_del_address,copy_info_.temp_del_addr);
      IF (copy_info_.temp_del_addr IS NOT NULL) THEN
         FOR rec_ IN get_def_addr_leadtime LOOP
            IF NOT(Check_Exist___(new_id_, new_del_address_, rec_.ship_via_code, rec_.contract)) THEN
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('CUSTOMER_NO', new_id_,attr_);
               Client_SYS.Add_To_Attr('ADDR_NO', new_del_address_, attr_);
               rec_.rowkey := NULL;
               Unpack___(rec_, indrec_, attr_);
               Check_Insert___(rec_, indrec_, attr_);
               Insert___(objid_, objversion_, rec_, attr_); 
            END IF;
         END LOOP;
      END IF;
   ELSE
      FOR newrec_ IN get_attr LOOP
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('CUSTOMER_NO', new_id_,attr_);
         newrec_.rowkey := NULL;
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
   END IF;
   Client_SYS.Clear_Info;
END Copy_Customer;


@UncheckedAccess
FUNCTION Is_Default_Ship_Via (
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2,
   contract_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   NUMBER;
   flag_    VARCHAR2(5);

   CURSOR exist_control IS
      SELECT 1
      FROM   CUSTOMER_ADDRESS_LEADTIME_TAB
      WHERE customer_no = customer_no_
      AND   addr_no = addr_no_
      AND   contract = contract_
      AND   default_ship_via = 'Y';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      flag_ := 'TRUE';
   ELSE
      flag_ := 'FALSE';
   END IF;
   CLOSE exist_control;
   RETURN flag_;
END Is_Default_Ship_Via;


PROCEDURE Get_Default_Leadtime_Values (
   ship_via_code_       OUT VARCHAR2,
   delivery_leadtime_   OUT NUMBER,
   customer_no_         IN  VARCHAR2,
   addr_no_             IN  VARCHAR2,
   contract_            IN  VARCHAR2,
   part_group_contract_ IN  VARCHAR2,
   part_no_             IN  VARCHAR2 DEFAULT NULL )
IS
   supply_chain_part_group_  VARCHAR2(20);
BEGIN
   IF (part_no_ IS NOT NULL) THEN
      supply_chain_part_group_ :=  Inventory_Part_API.Get_Supply_Chain_Part_Group( part_group_contract_, part_no_);
   END IF;
   IF ( supply_chain_part_group_ IS NOT NULL ) THEN
      ship_via_code_ := Cust_Addr_Part_Leadtime_API.Get_Default_Ship_Via_Code( customer_no_,
                                                                               addr_no_,
                                                                               supply_chain_part_group_,
                                                                               contract_);
      delivery_leadtime_ := Cust_Addr_Part_Leadtime_API.Get_Delivery_Leadtime( customer_no_,
                                                                               addr_no_,
                                                                               supply_chain_part_group_,
                                                                               contract_,
                                                                               ship_via_code_);
   END IF;
   IF (ship_via_code_ IS NULL OR delivery_leadtime_ IS NULL ) THEN
      ship_via_code_ := Get_Default_Ship_Via_Code( customer_no_, addr_no_, contract_);
      delivery_leadtime_ := Get_Delivery_Leadtime( customer_no_, addr_no_, ship_via_code_, contract_);
   END IF;
END Get_Default_Leadtime_Values;


@UncheckedAccess
FUNCTION Get_Default_Ship_Via_Code (
   customer_no_   IN  VARCHAR2,
   addr_no_       IN  VARCHAR2,
   contract_      IN  VARCHAR2 ) RETURN VARCHAR2
IS
   ship_via_code_   CUSTOMER_ADDRESS_LEADTIME_TAB.SHIP_VIA_CODE%TYPE;

   CURSOR get_ship_via_code IS
      SELECT ship_via_code
      FROM   CUSTOMER_ADDRESS_LEADTIME_TAB
      WHERE customer_no = customer_no_
      AND   addr_no = addr_no_
      AND   contract = contract_
      AND   default_ship_via = 'Y';
BEGIN
   OPEN get_ship_via_code;
   FETCH get_ship_via_code INTO ship_via_code_;
   CLOSE get_ship_via_code;
   RETURN ship_via_code_;
END Get_Default_Ship_Via_Code;


-- Count_Rows
--   Count the number of rows exists in a given key combination and return.
@UncheckedAccess
FUNCTION Count_Rows (
   customer_no_   IN VARCHAR2,
   addr_no_       IN VARCHAR2,
   contract_      IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_   NUMBER;
   CURSOR get_num_rows IS
      SELECT COUNT(*)
      FROM CUSTOMER_ADDRESS_LEADTIME_TAB
      WHERE customer_no = customer_no_
      AND addr_no = addr_no_
      AND contract = contract_;
BEGIN
   OPEN get_num_rows;
   FETCH get_num_rows INTO dummy_;
   CLOSE get_num_rows;
   RETURN dummy_;
END Count_Rows;


PROCEDURE Modify_Zone_Info (
   customer_no_               IN VARCHAR2,
   addr_no_                   IN VARCHAR2,
   ship_via_code_             IN VARCHAR2,
   contract_                  IN VARCHAR2,
   freight_map_id_            IN VARCHAR2,
   zone_id_                   IN VARCHAR2,
   manually_assigned_zone_db_ IN VARCHAR2 )
IS
   oldrec_     CUSTOMER_ADDRESS_LEADTIME_TAB%ROWTYPE;
   newrec_     CUSTOMER_ADDRESS_LEADTIME_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', freight_map_id_, attr_);
   Client_SYS.Add_To_Attr('ZONE_ID', zone_id_, attr_);
   Client_SYS.Add_To_Attr('MANUALLY_ASSIGNED_ZONE_DB', manually_assigned_zone_db_, attr_);
   oldrec_ := Lock_By_Keys___(customer_no_, addr_no_, ship_via_code_, contract_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Zone_Info;

