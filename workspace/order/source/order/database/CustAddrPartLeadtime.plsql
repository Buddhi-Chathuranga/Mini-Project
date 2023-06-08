-----------------------------------------------------------------------------
--
--  Logical unit: CustAddrPartLeadtime
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  150813  Wahelk   BLU-1192, Modified Copy_Customer method by adding new parameter copy_info_
--  150812  Wahelk   BLU-1191, Removed method Copy_Customer_Def_Address
--  150713  Wahelk   BLU-958, Modified Copy_Customer_Def_Address
--  150710  Wahelk   BLU-958, Added Copy_Customer_Def_Address
--  140123  MaIklk   EAP-910, Overridden Insert() and handled default ship via value.
--  141107  MaRalk   PRSC-3112, Removed parameter convert_customer_ from Copy_Customer method.
--  140415  JanWse   PBSC-8348, Set ROWKEY to NULL before inserting in Copy_Customer
--  140224  SudJlk   Bug 111497, Modified Copy_Customer by selecting records for user allowed sites only to be copied to avoid user allowed restriction error.
--  130715  MAHPLK   Removed attribute Load_Sequence_No.
--  130614  SURBLK   Added attribute forward_agent_id.
--  120822  MeAblk   Unit testing corrections done on task BI-478.
--  120820  MeAblk   Added shipment_type and function Get_Shipment_Type.
--  120702  MAHPLK   Added attribute picking_leadtime.
--  120627  MaMalk   Added attributes ROUTE_ID and LOAD_SEQUENCE_NO.
--  130213  GayDLK   Bug 103827, Modified Unpack_Check_Insert___(), Unpack_Check_Update___(), Check_Delete___() 
--  130213           and CUST_ADDR_PART_LEADTIME view by adding user allowed site validation. 
--  120316  JeLise   Changed the error message in Check_Exist.
--  100806  MaHplk   Modified reference of the manually_assigned_zone to FndBoolean. 
--  100513  Ajpelk   Merge rose method documentation
--  100112  MaRalk   Modified CUST_ADDR_PART_LEADTIME - supply_chain_part_group, contract, ship_via_code column comments
--  100112           as not updatable and modified Unpack_Check_Update___.
--  100423  JeLise   Renamed zone_definition_id to freight_map_id.
--  080918  MaHplk   Modified Unpack_Check_Insert___ to set default 'N' to manually_assigned_zone if it is null.
--  080904  MaHplk   Added new method Modify_Zone_Info, and zone_definition_id, zone _id and manuallt_assign_zone to CustAddrPartLeadtime.
--  ------------------------ Nice Price ------------------------------------
--  070417  NiDalk  Removed TRUE as last parameter in method call General_SYS.Init_Method in Copy_Customer.
--  060823  MiKulk  Added the method Copy_Customer.
--  060516  MiErlk  Enlarge Identity - Changed view comment
--  060417  SaRalk  Enlarge Identity - Changed view comments.
--  --------------------------------- 13.4.0 --------------------------------
--  060117  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  040510  JaJalk  Corrected the lead time lables.
--  040218  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  ---------------------------------------13.3.0----------------------------
--  030930  ChBalk  Added Check_Part_Group_Rows_Exist to check whether any lines exist.
--  030922  ChBalk  Added more conditions in Check_Exist.
--  030902  GaSolk  Performed CR Merge 2.
--  030806  ChBalk  Code review corrections.
--  030724  NuFilk  Added method Check_Exist.
--  030702  NuFilk  Modified method Unpack_Check_Update___ to clear currency field if exp additional cost is null.
--  030609  WaJalk  Modified the error message, when currency is not specified for the exp. additional cost.
--  030425  NuFilk  Removed the check on default lines in Check_Delete___.
--  030424  NuFilk  Reviewed Code and adjusted necessary.
--  030422  NuFilk  Added Method Get_Default_Ship_Via_Code.
--  030418  NuFilk  Removed method Remove_Lines.
--  030409  NuFilk  Added method Remove_Lines, Check_Ship_Via_Lines__ and changed return type for Is_Default_Ship_Via.
--  030404  NuFilk  Added method Is_Default_Ship_Via and modified methods Unpack_Check_Insert___, Unpack_Check_Update___ and Update___.
--  030403  NuFilk  Created the LU
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUST_ADDR_PART_LEADTIME_TAB%ROWTYPE,
   newrec_     IN OUT CUST_ADDR_PART_LEADTIME_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.default_ship_via = 'Y') THEN
      UPDATE CUST_ADDR_PART_LEADTIME_TAB
         SET default_ship_via = 'N',
             rowversion = sysdate
       WHERE customer_no = newrec_.customer_no
         AND addr_no = newrec_.addr_no
         AND contract = newrec_.contract
         AND supply_chain_part_group = newrec_.supply_chain_part_group
         AND default_ship_via = 'Y';
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CUST_ADDR_PART_LEADTIME_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, remrec_.contract);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_addr_part_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN  
   IF newrec_.manually_assigned_zone IS NULL THEN
      newrec_.manually_assigned_zone:= 'FALSE';
   END IF;
   
   IF (newrec_.default_ship_via IS NULL) THEN
      newrec_.default_ship_via:= Gen_Yes_No_API.DB_NO;
   END IF;

   super(newrec_, indrec_, attr_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   IF (Cust_Ord_Customer_Category_API.Encode(
       Cust_Ord_Customer_API.Get_Category(newrec_.customer_no)) = 'I' ) THEN
      Error_SYS.Record_General(lu_name_, 'CUST_TYPE_NOT_VALID: Only External Customer Info can be added');
   END IF;

   IF ( newrec_.delivery_leadtime < 0 OR newrec_.delivery_leadtime > 999  ) THEN
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
   IF newrec_.picking_leadtime IS NOT NULL THEN
      IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0) THEN
         Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'PICKVALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_addr_part_leadtime_tab%ROWTYPE,
   newrec_ IN OUT cust_addr_part_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   
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
   IF newrec_.picking_leadtime IS NOT NULL THEN
      IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0) THEN
         Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'PICKVALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT cust_addr_part_leadtime_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 ) 
IS
BEGIN 
   IF (Is_Default_Ship_Via(newrec_.customer_no, newrec_.addr_no, newrec_.supply_chain_part_group, newrec_.contract) = 'FALSE' ) THEN
      newrec_.default_ship_via := 'Y';
   ELSE
      IF(newrec_.default_ship_via = 'Y') THEN
        UPDATE cust_addr_part_leadtime_tab
         SET default_ship_via = 'N',
             rowversion = sysdate
         WHERE customer_no = newrec_.customer_no
           AND addr_no = newrec_.addr_no
           AND contract = newrec_.contract
           AND supply_chain_part_group = newrec_.supply_chain_part_group
           AND default_ship_via = 'Y';
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('DEFAULT_SHIP_VIA_DB', newrec_.default_ship_via, attr_);      
   super(objid_, objversion_, newrec_, attr_);
END Insert___;
   
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Ship_Via_Lines__
--   Check if there exists any non default ship via lines for the specified
--   customer, address, supply chain part group and contract.
--   Return TRUE if this is the case FALSE if not.
@UncheckedAccess
FUNCTION Check_Ship_Via_Lines__ (
   remrec_ IN CUST_ADDR_PART_LEADTIME_TAB%ROWTYPE ) RETURN VARCHAR2
IS
   flag_      VARCHAR2(5);
   dummy_     NUMBER;
   CURSOR Exist_Control IS
      SELECT 1
      FROM  CUST_ADDR_PART_LEADTIME_TAB
      WHERE customer_no = remrec_.customer_no
      AND   addr_no = remrec_.addr_no
      AND   supply_chain_part_group = remrec_.supply_chain_part_group
      AND   contract = remrec_.contract
      AND   default_ship_via = 'N';
BEGIN
   OPEN Exist_Control;
   FETCH Exist_Control INTO dummy_;
   IF Exist_Control%FOUND THEN
      flag_ := 'TRUE';
   ELSE
      flag_ := 'FALSE';
   END IF;
   CLOSE Exist_Control;
   RETURN flag_;
END Check_Ship_Via_Lines__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
@UncheckedAccess
FUNCTION Get_Manually_Assigned_Zone (
   customer_no_             IN VARCHAR2,
   addr_no_                 IN VARCHAR2,
   supply_chain_part_group_ IN VARCHAR2,
   contract_                IN VARCHAR2,
   ship_via_code_           IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUST_ADDR_PART_LEADTIME_TAB.manually_assigned_zone%TYPE;
BEGIN
   temp_ := super(customer_no_, addr_no_, supply_chain_part_group_, contract_, ship_via_code_); 
   RETURN Gen_Yes_No_API.Decode(temp_);
END Get_Manually_Assigned_Zone;


-- Is_Default_Ship_Via
--   Check if for the given customer, address, supply chain part group and
--   contract the ship via code is the default ship via,
--   return TRUE if this is the case FALSE if not.
@UncheckedAccess
FUNCTION Is_Default_Ship_Via (
   customer_no_             IN VARCHAR2,
   addr_no_                 IN VARCHAR2,
   supply_chain_part_group_ IN VARCHAR2,
   contract_                IN VARCHAR2 ) RETURN VARCHAR2
IS
   flag_    VARCHAR2(5);
   dummy_   NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM  CUST_ADDR_PART_LEADTIME_TAB
      WHERE supply_chain_part_group = supply_chain_part_group_
      AND   customer_no = customer_no_
      AND   addr_no = addr_no_
      AND   contract = contract_
      AND   default_ship_via = 'Y';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND)THEN
      flag_ := 'TRUE';
   ELSE
      flag_ := 'FALSE';
   END IF;
   CLOSE exist_control;
   RETURN flag_;
END Is_Default_Ship_Via;


-- Get_Default_Ship_Via_Code
--   Get the ship via code for the given customer, address,
--   supply chain part group and contract.
@UncheckedAccess
FUNCTION Get_Default_Ship_Via_Code (
   customer_no_             IN VARCHAR2,
   addr_no_                 IN VARCHAR2,
   supply_chain_part_group_ IN VARCHAR2,
   contract_                IN VARCHAR2 ) RETURN VARCHAR2
IS
   ship_via_code_  CUST_ADDR_PART_LEADTIME_TAB.SHIP_VIA_CODE%TYPE;
   CURSOR get_ship_via_code IS
      SELECT ship_via_code
      FROM  CUST_ADDR_PART_LEADTIME_TAB
      WHERE customer_no = customer_no_
      AND   addr_no = addr_no_
      AND   supply_chain_part_group = supply_chain_part_group_
      AND   contract = contract_
      AND   default_ship_via = 'Y';
BEGIN
   OPEN get_ship_via_code;
   FETCH get_ship_via_code INTO ship_via_code_;
   CLOSE get_ship_via_code;
   RETURN ship_via_code_;
END Get_Default_Ship_Via_Code;


-- Check_Exist
--   Checks if an instance exist corresponding to CustomerAddressLeadtime,
--   If one exist then an Error is given so that the records in CustAddrPartLeadtime,
--   are first removed before a corresponding instance in CustomerAddressLeadtime LU
--   is removed.
--   Note: Handles the deletion of an instance of CustomerAddressLeadtime through
--   the View comments and Reference Sys methods in this LU. The parameter
--   ship_via_code_ is not used and only necessary because of the key set.
PROCEDURE Check_Exist (
   customer_no_   IN VARCHAR2,
   addr_no_       IN VARCHAR2,
   ship_via_code_ IN VARCHAR2,
   contract_      IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   CUST_ADDR_PART_LEADTIME_TAB
      WHERE  customer_no = customer_no_
      AND    addr_no = addr_no_
      AND    contract = contract_;
BEGIN
   IF (Customer_Address_Leadtime_API.Count_Rows (customer_no_, addr_no_, contract_) = 1) THEN
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      IF (exist_control%FOUND) THEN
         CLOSE exist_control;
         Error_SYS.Record_General(lu_name_, 'CUSADD_PARTLED_EXIST:  May not be deleted since it has exception records');
      END IF;
      CLOSE exist_control;
   END IF;
END Check_Exist;


@UncheckedAccess
FUNCTION Check_Part_Group_Rows_Exist(
   customer_no_   IN VARCHAR2,
   addr_no_       IN VARCHAR2,
   contract_      IN VARCHAR2) RETURN VARCHAR2
IS
   dummy_      NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM CUST_ADDR_PART_LEADTIME_TAB
      WHERE  customer_no = customer_no_
      AND    addr_no = addr_no_
      AND    contract = contract_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_control;
   RETURN 'FALSE';
END Check_Part_Group_Rows_Exist;


-- Copy_Customer
--   Copies the data of customer_id in Cust_Addr_Part_Leadtime_tab to
--   the new _id.
PROCEDURE Copy_Customer (
   customer_id_      IN VARCHAR2,
   new_id_           IN VARCHAR2,
   copy_info_        IN  Customer_Info_API.Copy_Param_Info)
IS
   objid_                VARCHAR2(100);
   objversion_           VARCHAR2(2000);
   attr_                VARCHAR2(2000);
   indrec_               Indicator_Rec;
   new_del_address_      CUSTOMER_INFO_ADDRESS_TAB.address_id%TYPE;

   CURSOR get_attr IS
      SELECT *
      FROM CUST_ADDR_PART_LEADTIME_TAB
      WHERE customer_no = customer_id_
      AND EXISTS (SELECT 1 
                  FROM user_allowed_site_pub 
                  WHERE site = contract);

   CURSOR get_def_part_leadtime IS
      SELECT *
      FROM CUST_ADDR_PART_LEADTIME_TAB
      WHERE customer_no = customer_id_
      AND   addr_no = copy_info_.temp_del_addr
      AND EXISTS (SELECT 1 
                  FROM user_allowed_site_pub 
                  WHERE site = contract);
BEGIN
   IF (copy_info_.copy_convert_option = 'CONVERT' ) THEN  
      new_del_address_ := nvl(copy_info_.new_del_address,copy_info_.temp_del_addr);
      IF (copy_info_.temp_del_addr IS NOT NULL) THEN
         FOR rec_ IN get_def_part_leadtime LOOP
            IF NOT(Check_Exist___(new_id_, new_del_address_, rec_.supply_chain_part_group, rec_.contract, rec_.ship_via_code)) THEN
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('CUSTOMER_NO', new_id_, attr_);
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
         Client_SYS.Add_To_Attr('CUSTOMER_NO', new_id_, attr_);
         newrec_.rowkey := NULL;

         Unpack___(newrec_, indrec_, attr_); 
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
   END IF;
   Client_SYS.Clear_Info;
END Copy_Customer;


PROCEDURE Modify_Zone_Info (
   customer_no_               IN VARCHAR2,
   addr_no_                   IN VARCHAR2,
   supply_chain_part_group_   IN VARCHAR2,
   contract_                  IN VARCHAR2,
   ship_via_code_             IN VARCHAR2,
   freight_map_id_            IN VARCHAR2,
   zone_id_                   IN VARCHAR2,
   manually_assigned_zone_db_ IN VARCHAR2 )
IS
   oldrec_     CUST_ADDR_PART_LEADTIME_TAB%ROWTYPE;
   newrec_     CUST_ADDR_PART_LEADTIME_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', freight_map_id_, attr_);
   Client_SYS.Add_To_Attr('ZONE_ID', zone_id_, attr_);
   Client_SYS.Add_To_Attr('MANUALLY_ASSIGNED_ZONE_DB', manually_assigned_zone_db_, attr_);
   oldrec_ := Lock_By_Keys___(customer_no_, addr_no_, supply_chain_part_group_, contract_, ship_via_code_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Zone_Info;
