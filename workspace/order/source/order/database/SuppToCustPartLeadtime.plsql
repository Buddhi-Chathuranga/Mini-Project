-----------------------------------------------------------------------------
--
--  Logical unit: SuppToCustPartLeadtime
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150813  Wahelk  BLU-1192, Modified Copy_Customer method by adding new parameter copy_info_
--  150812  Wahelk  BLU-1191, Removed method Copy_Customer_Def_Address
--  150713  Wahelk  BLU-958, Modified Copy_Customer_Def_Address
--  150710  Wahelk  BLU-958, Added Copy_Customer_Def_Address
--  140113  MaIklk  EAP-910, Overridden Insert() and handled default ship via value.
--  141107  MaRalk  PRSC-3112, Removed parameter convert_customer_ from Copy_Customer method.
--  140507  SURBLK  Set newrec_.rowkey  as null in Copy_Supplier().
--  140415  JanWse  PBSC-8348, Set ROWKEY to NULL before inserting in Copy_Customer
--  130708  ChJalk  TIBE-1034, Removed the global variable inst_SupplierAddress_.
--  120316  JeLise  Changed the error message in Check_Exist.
--  110425  NaLrlk  Modified the method Get_Manually_Assigned_Zone to use FndBoolean.
--  100806  MaHplk  Modified reference of the manually_assigned_zone to FndBoolean.
--  100513  KRPELK  Merge Rose Method Documentation.
--  100113  MaRalk  Modified SUPP_TO_CUST_PART_LEADTIME - supply_chain_part_group, vendor_no, supplier_address,  
--  100113          ShipViaCode column comments as not updatable and modified Unpack_Check_Update___.
--  091001  MaMalk  Removed unused code in Copy_Customer.
--  -------------------- 14.0.0 --------------------------------------------- 
--  100426  JeLise  Renamed zone_definition_id to freight_map_id.
--  080918  MaHplk  Modified Unpack_Check_Insert___ to set default 'N' to manually_assigned_zone if it is null. 
--  080908  MaHplk  Added new method Modify_Zone_Info, and zone_definition_id, zone _id and manuallt_assign_zone to SuppToCustPartLeadtime.
--  ------------------------ Nice Price ------------------------------------
--  060823  MiKulk  Added the methods Copy_Customer and Copy_Supplier.
--  060517  MiErlk   Enlarge Identity - Changed view comment
--  060417  RoJalk  Enlarge Identity - Changed view comments.
--  -------------------- 13.4.0 ---------------------------------------------
--  060124  JaJalk  Added Assert safe annotation.
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040511  JaJalk   Corrected the lead time lables.
--  040226  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  ----------------13.3.0---------------------------------------------------
--  030930  ChBalk  Added Check_Part_Group_Rows_Exist to check whether any lines exist.
--  030922  ChBalk  Added more conditions to the Check_Exist.
--  030918  KeFelk  Corrected B103541
--  030820  GaSolk  Performed CR Merge(CR Only).
--  030724  NuFilk  Added method Check_Exist.
--  030702  NuFilk  Modified method Unpack_Check_Update___ to clear currency field if exp additional cost is null.
--  030609  WaJalk  Modified the error message, when currency is not specified for the exp. additional cost.
--  030521  WaJalk  Modified view comments, closed the cursor get_ship_via_code.
--  030508  WaJalk  Made Delivery Leadtime mandatory.
--  030421  WaJalk  Added new method Get_Default_Ship_Via_Code.
--  030407  WaJalk  Added new method Is_Default_Ship_Via.
--  030403  WaJalk  Added new key attribute 'Ship Via Code'.
--  030402  WaJalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SUPP_TO_CUST_PART_LEADTIME_TAB%ROWTYPE,
   newrec_     IN OUT SUPP_TO_CUST_PART_LEADTIME_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   
   IF (newrec_.default_ship_via = 'Y') THEN
      UPDATE SUPP_TO_CUST_PART_LEADTIME_TAB
         SET default_ship_via = 'N',
             rowversion = sysdate
       WHERE customer_no = newrec_.customer_no
         AND addr_no = newrec_.addr_no
         AND vendor_no = newrec_.vendor_no
         AND supplier_address = newrec_.supplier_address
         AND supply_chain_part_group = newrec_.supply_chain_part_group
         AND default_ship_via = 'Y';
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     supp_to_cust_part_leadtime_tab%ROWTYPE,
   newrec_ IN OUT supp_to_cust_part_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   
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
END Check_Common___;




@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT supp_to_cust_part_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN     
   IF newrec_.manually_assigned_zone IS NULL THEN
      newrec_.manually_assigned_zone:= 'FALSE';
   END IF;
   IF( newrec_.default_ship_via IS NULL) THEN
      newrec_.default_ship_via := Gen_Yes_No_API.DB_NO; 
   END IF;   
   super(newrec_, indrec_, attr_);     
END Check_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT supp_to_cust_part_leadtime_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
 
IS
BEGIN 
   IF (Is_Default_Ship_Via(newrec_.vendor_no, newrec_.supplier_address, newrec_.customer_no,newrec_.addr_no, newrec_.supply_chain_part_group) = 'FALSE' ) THEN
      newrec_.default_ship_via := 'Y';
   ELSE
      IF(newrec_.default_ship_via = 'Y') THEN
         UPDATE supp_to_cust_part_leadtime_tab
         SET default_ship_via = 'N',
             rowversion = sysdate
         WHERE customer_no = newrec_.customer_no
           AND addr_no = newrec_.addr_no
           AND vendor_no = newrec_.vendor_no
           AND supplier_address = newrec_.supplier_address
           AND supply_chain_part_group = newrec_.supply_chain_part_group
           AND default_ship_via = 'Y';
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('DEFAULT_SHIP_VIA_DB', newrec_.default_ship_via, attr_);      
   super(objid_, objversion_, newrec_, attr_);
END Insert___;
    
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Is_Default_Ship_Via
--   hecks whether a default ship via exists for a specified From Supplier,
--   Supplier Address, To Customer, Delivery Address and Part Supply Chain Group.
@UncheckedAccess
FUNCTION Is_Default_Ship_Via (
   vendor_no_               IN VARCHAR2,
   supplier_address_        IN VARCHAR2,
   customer_no_             IN VARCHAR2,
   addr_no_                 IN VARCHAR2,
   supply_chain_part_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_   NUMBER;
   flag_   VARCHAR2(5);
   CURSOR get_attr IS
      SELECT 1
      FROM SUPP_TO_CUST_PART_LEADTIME_TAB
      WHERE vendor_no = vendor_no_
      AND   supplier_address = supplier_address_
      AND   customer_no = customer_no_
      AND   addr_no = addr_no_
      AND   supply_chain_part_group = supply_chain_part_group_
      AND   default_ship_via = 'Y';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF (get_attr%FOUND) THEN
      CLOSE get_attr;
      flag_ := 'TRUE';
   ELSE
      CLOSE get_attr;
      flag_ := 'FALSE';
   END IF;
   RETURN flag_;
END Is_Default_Ship_Via;


-- Get_Default_Ship_Via_Code
--   Returns the Default Ship Via Code.
@UncheckedAccess
FUNCTION Get_Default_Ship_Via_Code (
   vendor_no_               IN VARCHAR2,
   supplier_address_        IN VARCHAR2,
   customer_no_             IN VARCHAR2,
   addr_no_                 IN VARCHAR2,
   supply_chain_part_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   ship_via_code_   SUPP_TO_CUST_PART_LEADTIME_TAB.SHIP_VIA_CODE%TYPE;

   CURSOR get_ship_via_code IS
      SELECT ship_via_code
      FROM   SUPP_TO_CUST_PART_LEADTIME_TAB
      WHERE vendor_no = vendor_no_
      AND   supplier_address = supplier_address_
      AND   customer_no = customer_no_
      AND   addr_no = addr_no_
      AND   supply_chain_part_group = supply_chain_part_group_
      AND   default_ship_via = 'Y';
BEGIN
   OPEN get_ship_via_code;
   FETCH get_ship_via_code INTO ship_via_code_;
   CLOSE get_ship_via_code;
   RETURN ship_via_code_;
END Get_Default_Ship_Via_Code;


-- Check_Exist
--   Checks if an instance exist corresponding to SuppToCustLeadtime, If one
--   exist then an Error is given so that the records in this LU should be first
--   removed before a corresponding instance in SuppToCustLeadtime LU is removed.
PROCEDURE Check_Exist (
   customer_no_      IN VARCHAR2,
   addr_no_          IN VARCHAR2,
   vendor_no_        IN VARCHAR2,
   supplier_address_ IN VARCHAR2,
   ship_via_code_    IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SUPP_TO_CUST_PART_LEADTIME_TAB
      WHERE  customer_no = customer_no_
      AND    addr_no = addr_no_
      AND    vendor_no = vendor_no_
      AND    supplier_address = supplier_address_;
BEGIN
   IF (Supp_To_Cust_Leadtime_API.Count_Rows(customer_no_, addr_no_, vendor_no_, supplier_address_) = 1) THEN
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      IF (exist_control%FOUND) THEN
         CLOSE exist_control;
         Error_SYS.Record_General(lu_name_, 'SUPP_CUST_PLED_EXIST: May not be deleted since it has exception records');
      END IF;
      CLOSE exist_control;
   END IF;
END Check_Exist;


@UncheckedAccess
FUNCTION Check_Part_Group_Rows_Exist(
   customer_no_      IN VARCHAR2,
   addr_no_          IN VARCHAR2,
   vendor_no_        IN VARCHAR2,
   supplier_address_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_         NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SUPP_TO_CUST_PART_LEADTIME_TAB
      WHERE  customer_no = customer_no_
      AND    addr_no = addr_no_
      AND    vendor_no = vendor_no_
      AND    supplier_address = supplier_address_;
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
--   Copies the data of customer_id in Supp_To_Cust_Part_Leadtime_tab to the new _id.
PROCEDURE Copy_Customer (
   customer_id_      IN VARCHAR2,
   new_id_           IN VARCHAR2,
   copy_info_        IN  Customer_Info_API.Copy_Param_Info)
IS
   objid_                VARCHAR2(100);
   objversion_           VARCHAR2(200);
   attr_                VARCHAR2(2000);
   indrec_               Indicator_Rec;
   new_del_address_      CUSTOMER_INFO_ADDRESS_TAB.address_id%TYPE;
   
   CURSOR get_attr IS
      SELECT *
        FROM SUPP_TO_CUST_PART_LEADTIME_TAB
        WHERE customer_no = customer_id_;
        
   CURSOR get_def_leadtime IS
      SELECT *
      FROM SUPP_TO_CUST_PART_LEADTIME_TAB
      WHERE customer_no = customer_id_
      AND addr_no = copy_info_.temp_del_addr;     
BEGIN
   IF (copy_info_.copy_convert_option = 'CONVERT' ) THEN 
      new_del_address_ := nvl(copy_info_.new_del_address,copy_info_.temp_del_addr);
      IF (copy_info_.temp_del_addr IS NOT NULL) THEN
         FOR rec_ IN get_def_leadtime LOOP
            IF NOT (Check_Exist___(new_id_, new_del_address_, rec_.supply_chain_part_group, rec_.vendor_no, rec_.supplier_address, rec_.ship_via_code)) THEN
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


-- Copy_Supplier
--   Copies the data of Supplier_Id in Supp_To_Cust_Part_Leadtime_tab to the new _id.
PROCEDURE Copy_Supplier (
   supplier_id_ IN VARCHAR2,
   new_id_      IN VARCHAR2 )

IS
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(200);
   attr_         VARCHAR2(2000);
   indrec_       Indicator_Rec;
   
   CURSOR get_attr IS
      SELECT *
        FROM SUPP_TO_CUST_PART_LEADTIME_TAB
        WHERE vendor_no = supplier_id_;

BEGIN

   FOR newrec_ IN get_attr LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('VENDOR_NO', new_id_, attr_);
      newrec_.rowkey := NULL;
        
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
   Client_SYS.Clear_Info;
END Copy_Supplier;


PROCEDURE Modify_Zone_Info (
   customer_no_               IN VARCHAR2,
   addr_no_                   IN VARCHAR2,
   supply_chain_part_group_   IN VARCHAR2,
   vendor_no_                 IN VARCHAR2,
   supplier_address_          IN VARCHAR2,
   ship_via_code_             IN VARCHAR2,
   freight_map_id_            IN VARCHAR2,
   zone_id_                   IN VARCHAR2,
   manually_assigned_zone_db_ IN VARCHAR2 )
IS
   oldrec_     SUPP_TO_CUST_PART_LEADTIME_TAB%ROWTYPE;
   newrec_     SUPP_TO_CUST_PART_LEADTIME_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', freight_map_id_, attr_);
   Client_SYS.Add_To_Attr('ZONE_ID', zone_id_, attr_);
   Client_SYS.Add_To_Attr('MANUALLY_ASSIGNED_ZONE_DB', manually_assigned_zone_db_, attr_);
   oldrec_ := Lock_By_Keys___(customer_no_, addr_no_, supply_chain_part_group_,
                              vendor_no_, supplier_address_, ship_via_code_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Zone_Info;

