-----------------------------------------------------------------------------
--
--  Logical unit: SuppToCustLeadtime
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
--  140123  MaIklk  EAP-910, Overridden Insert() and handled default ship via value.
--  141217  MaIklk  PRSC-974, Restricted to entering value for prospects.
--  141107  MaRalk  PRSC-3112, Removed parameter convert_customer_ from Copy_Customer method.
--  140711  MaIklk  PRSC-1761, Implemented to preserve records if customer is existing in copy_customer().
--  140505  MaRalk  PBSC-8721, Added method Check_Customer_No_Ref___ to avoid unnecessary error 'Customer is not of category Customer'.
--  140430  SURBLK  Modified Copy_Supplier()by assigning newrec_.rowkey to null.
--  140415  JanWse  PBSC-8348, Set ROWKEY to NULL before inserting in Copy_Customer
--  130911  ErFelk  Bug 111147, Restructured the code using condition compilation in methods Is_External_Supplier() and Check_Supplier_Type().
--  130710  MaRalk  TIBE-1033, Removed following global LU constants and modified relevant methods accordingly.
--  130710          inst_Supplier_ - Check_Default_Addr, Is_External_Supplier, Check_Supplier_Type, 
--  130710          inst_SupplierAddress_ - Unpack_Check_Insert___.
--  110425  NaLrlk  Modified the method Get_Manually_Assigned_Zone to use FndBoolean.
--  100806  MaHplk  Modified reference of the manually_assigned_zone to FndBoolean.
--  100513  KRPELK  Merge Rose Method Documentation.
--  100113  MaRalk  Modified SUPP_TO_CUST_LEADTIME - vendor_no, supplier_address, ship_via_code column comments 
--  100113          as not updatable and modified Unpack_Check_Update___.
--  091001  MaMalk  Removed unused code in Copy_Supplier.
--  -------------------- 14.0.0 --------------------------------------------- 
--  100426  JeLise  Renamed zone_definition_id to freight_map_id.
--  080918  MaHplk  Modified Unpack_Check_Insert___ to set default 'N' to manually_assigned_zone if it is null. 
--  080908  MaHplk  Added new method Modify_Zone_Info, and zone_definition_id, zone _id and manuallt_assign_zone to SuppToCustLeadtime.
--  ------------------------ Nice Price ------------------------------------
--  080229  MaMalk  Bug 72023, Modified method Get_Default_Ship_Via_Code to close open cursors.
--  060823  MiKulk  Added new procedures Copy_Customer and Copy_Supplier.
--  060517  MiErlk  Enlarge Identity - Changed view comment
--  060516  MiErlk  Enlarge Identity - Changed view comment
--  060417  RoJalk  Enlarge Identity - Changed view comments.
--  -------------------- 13.4.0 ---------------------------------------------
--  060124  JaJalk  Added Assert safe annotation.
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040511  JaJalk  Corrected the lead time lables.
--  040406  WaJalk  Modified methods Unpack_Check_Insert___ and Check_Default_Addr to handle delivery address
--                  as supplier's default address instead of using document address.
--  040226  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  ----------------Version 13.3.0-------------------------------------------
--  030929  WaJalk  Modified method Unpack_Check_Insert___ to check supplier/customer address type.
--  030922  ChBalk  Added new method Count_Rows.
--  030918  KeFelk  Corrected B103541.
--  030902  GaSolk  Performed CR Merge 2.
--  030702  NuFilk  Modified method Unpack_Check_Update___ to clear currency field if exp additional cost is null.
--  030702  NuFilk  Modified Check_Delete___ removed restriction on delete.
--  030609  WaJalk  Modified the error message, when currency is not specified for the exp. additional cost.
--  030521  WaJalk  Modified order of view comments to match with the view.
--  030508  WaJalk  Made Delivery Leadtime mandatory.
--  030421  WaJalk  Added new methods Get_Default_Ship_Via_Code and Get_Default_Leadtime_Values.
--  030408  WaJalk  Added new method Is_External_Supplier.
--  030407  WaJalk  Added new method Is_Default_Ship_Via.
--  030404  WaJalk  Added new method Check_Default_Addr.
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
   oldrec_     IN     SUPP_TO_CUST_LEADTIME_TAB%ROWTYPE,
   newrec_     IN OUT SUPP_TO_CUST_LEADTIME_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.default_ship_via = 'Y') THEN
      UPDATE supp_to_cust_leadtime_tab
         SET default_ship_via = 'N',
             rowversion = sysdate
         WHERE customer_no = newrec_.customer_no
         AND addr_no = newrec_.addr_no
         AND vendor_no = newrec_.vendor_no
         AND supplier_address = newrec_.supplier_address
         AND default_ship_via = 'Y';
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     supp_to_cust_leadtime_tab%ROWTYPE,
   newrec_ IN OUT supp_to_cust_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   
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
END Check_Common___;



@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT supp_to_cust_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   flag_  VARCHAR2(5);
BEGIN  
   newrec_.manually_assigned_zone:= NVL(newrec_.manually_assigned_zone, 'FALSE');
   newrec_.default_ship_via      := NVL(newrec_.default_ship_via, Gen_Yes_No_API.DB_NO); 
       
   super(newrec_, indrec_, attr_);

   IF (Cust_Ord_Customer_Category_API.Encode(Cust_Ord_Customer_API.Get_Category(newrec_.customer_no)) = 'I' OR Is_External_Supplier(newrec_.vendor_no) = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'TYPE_NOT_VALID: Only External Customer or External Supplier Info can be added');
   END IF;  
   
   IF Customer_Info_Address_Type_API.Check_Exist( newrec_.customer_no, newrec_.addr_no, Address_Type_Code_API.Decode( 'DELIVERY' )) != 'TRUE' THEN
      Error_SYS.Record_General(lu_name_, 'MUST_BE_DELIVERY: Customer address must be a delivery address.');
   END IF;
   $IF Component_Purch_SYS.INSTALLED $THEN
      flag_ := Supplier_Info_Address_Type_API.Check_Exist(newrec_.vendor_no, newrec_.supplier_address, Address_Type_Code_API.Decode('DELIVERY'));
      
      IF flag_ != 'TRUE' THEN
         Error_SYS.Record_General(lu_name_, 'MUST_BE_DEL: Supplier address must be a delivery address.');
      END IF;
   $END  
END Check_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT supp_to_cust_leadtime_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
 
IS
BEGIN 
   IF (Is_Default_Ship_Via(newrec_.vendor_no, newrec_.supplier_address, newrec_.customer_no, newrec_.addr_no) = 'FALSE' ) THEN
      newrec_.default_ship_via := 'Y';
   ELSE
      IF(newrec_.default_ship_via = 'Y') THEN
         UPDATE supp_to_cust_leadtime_tab
         SET default_ship_via = 'N',
             rowversion = sysdate
         WHERE customer_no = newrec_.customer_no
         AND addr_no = newrec_.addr_no
         AND vendor_no = newrec_.vendor_no
         AND supplier_address = newrec_.supplier_address
         AND default_ship_via = 'Y';
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('DEFAULT_SHIP_VIA_DB', newrec_.default_ship_via, attr_);      
   super(objid_, objversion_, newrec_, attr_);
END Insert___;
  
 
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Default_Addr
--   Checks whether the defult address is the supplier's document address.
@UncheckedAccess
FUNCTION Check_Default_Addr (
   vendor_no_        IN VARCHAR2,
   supplier_address_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   default_ VARCHAR2(5);
   address_type_code_ VARCHAR2(20);
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      address_type_code_  := Address_Type_Code_API.Decode('DELIVERY');
      default_ := Supplier_Info_Address_Type_API.Is_Default(vendor_no_, supplier_address_, address_type_code_);         
   $ELSE
      default_ := 'FALSE';    
   $END  
      RETURN default_;
END Check_Default_Addr;


-- Is_Default_Ship_Via
--   Checks whether a default ship via exists for a specified From Supplier,
--   Supplier Address, To Customer, Delivery Address.
@UncheckedAccess
FUNCTION Is_Default_Ship_Via (
   vendor_no_        IN VARCHAR2,
   supplier_address_ IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   addr_no_          IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_   NUMBER;
   flag_   VARCHAR2(5);
   CURSOR get_attr IS
      SELECT 1
      FROM SUPP_TO_CUST_LEADTIME_TAB
      WHERE vendor_no = vendor_no_
      AND   supplier_address = supplier_address_
      AND   customer_no = customer_no_
      AND   addr_no = addr_no_
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


-- Is_External_Supplier
--   Checks whether the Supplier is external.
@UncheckedAccess
FUNCTION Is_External_Supplier (
   vendor_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   category_db_ VARCHAR2(1);
   flag_        VARCHAR2(5);
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      category_db_ := Supplier_Category_API.Encode(Supplier_API.Get_Category(vendor_no_));    
      -- NVL is added becuase when copying the supplier info category_db is initially null
      IF  NVL(category_db_,'E') = 'E' THEN
         flag_ := 'TRUE';
      ELSE
         flag_ := 'FALSE';
      END IF;           
   $ELSE
      NULL; 
   $END   
   RETURN flag_;     
END Is_External_Supplier;


-- Get_Default_Ship_Via_Code
--   Returns the Default Ship Via Code.
@UncheckedAccess
FUNCTION Get_Default_Ship_Via_Code (
   vendor_no_        IN VARCHAR2,
   supplier_address_ IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   addr_no_          IN VARCHAR2 ) RETURN VARCHAR2
IS
   ship_via_code_   SUPP_TO_CUST_LEADTIME_TAB.SHIP_VIA_CODE%TYPE;

   CURSOR get_ship_via_code IS
      SELECT ship_via_code
      FROM   SUPP_TO_CUST_LEADTIME_TAB
      WHERE vendor_no = vendor_no_
      AND   supplier_address = supplier_address_
      AND   customer_no = customer_no_
      AND   addr_no = addr_no_
      AND   default_ship_via = 'Y';
BEGIN
   OPEN get_ship_via_code;
   FETCH get_ship_via_code INTO ship_via_code_;
   CLOSE get_ship_via_code;
   RETURN ship_via_code_;
END Get_Default_Ship_Via_Code;


-- Get_Default_Leadtime_Values
--   This is used to get the default leadtime values.
PROCEDURE Get_Default_Leadtime_Values (
   ship_via_code_     OUT VARCHAR2,
   delivery_leadtime_ OUT NUMBER,
   vendor_no_         IN VARCHAR2,
   supplier_address_  IN VARCHAR2,
   customer_no_       IN VARCHAR2,
   addr_no_           IN VARCHAR2,
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2 DEFAULT NULL )
IS
   supply_chain_part_group_  VARCHAR2(20);
BEGIN
   IF (part_no_ IS NOT NULL) THEN
      supply_chain_part_group_ :=  Inventory_Part_API.Get_Supply_Chain_Part_Group( contract_, part_no_);
         IF ( supply_chain_part_group_ IS NOT NULL ) THEN
            ship_via_code_ := Supp_To_Cust_Part_Leadtime_API.Get_Default_Ship_Via_Code( vendor_no_,
                                                                                        supplier_address_,
                                                                                        customer_no_,
                                                                                        addr_no_,
                                                                                        supply_chain_part_group_);

            delivery_leadtime_ := Supp_To_Cust_Part_Leadtime_API.Get_Delivery_Leadtime( customer_no_,
                                                                                        addr_no_,
                                                                                        supply_chain_part_group_,
                                                                                        vendor_no_,
                                                                                        supplier_address_,
                                                                                        ship_via_code_);
        END IF;
   END IF;
  IF (ship_via_code_ IS NULL OR delivery_leadtime_ IS NULL ) THEN
     ship_via_code_ := Get_Default_Ship_Via_Code( vendor_no_,
                                                  supplier_address_,
                                                  customer_no_,
                                                  addr_no_ );
     delivery_leadtime_ :=   Get_Delivery_Leadtime( customer_no_,
                                                    addr_no_,
                                                    vendor_no_,
                                                    supplier_address_,
                                                    ship_via_code_ );
  END IF;
END Get_Default_Leadtime_Values;


-- Check_Supplier_Type
--   Return the internal supplier site for the supplier
@UncheckedAccess
FUNCTION Check_Supplier_Type (
   vendor_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   site_   VARCHAR2(5);
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      site_ := Supplier_API.Get_Acquisition_Site(vendor_no_);            
   $ELSE
      NULL;    
   $END
   RETURN site_;
END Check_Supplier_Type;


@UncheckedAccess
FUNCTION Count_Rows (
   customer_no_      IN VARCHAR2,
   addr_no_          IN VARCHAR2,
   vendor_no_        IN VARCHAR2,
   supplier_address_ IN VARCHAR2) RETURN NUMBER
IS
   dummy_            NUMBER;
   CURSOR get_num_rows IS
      SELECT COUNT(*)
      FROM   SUPP_TO_CUST_LEADTIME_TAB
      WHERE  customer_no = customer_no_
      AND    addr_no = addr_no_
      AND    vendor_no = vendor_no_
      AND    supplier_address = supplier_address_;
BEGIN
   OPEN get_num_rows;
   FETCH get_num_rows INTO dummy_;
   CLOSE get_num_rows;
   RETURN dummy_;
END Count_Rows;


-- Copy_Customer
--   Copies the data of customer_id in Supp_To_Cust_Leadtime_tab to the new _id.
PROCEDURE Copy_Customer (
   customer_id_      IN VARCHAR2,
   new_id_           IN VARCHAR2,
   copy_info_        IN  Customer_Info_API.Copy_Param_Info)
IS
   objid_                VARCHAR2(100);
   objversion_           VARCHAR2(200);
   attr_                 VARCHAR2(2000);
   indrec_               Indicator_Rec;
   new_del_address_      CUSTOMER_INFO_ADDRESS_TAB.address_id%TYPE;
   
   CURSOR get_attr IS
      SELECT *
        FROM SUPP_TO_CUST_LEADTIME_TAB
        WHERE customer_no = customer_id_;
        
   CURSOR get_def_leadtime IS
      SELECT *
      FROM SUPP_TO_CUST_LEADTIME_TAB
      WHERE customer_no = customer_id_
      AND addr_no = copy_info_.temp_del_addr;

BEGIN
   IF (copy_info_.copy_convert_option = 'CONVERT' ) THEN
      new_del_address_ := nvl(copy_info_.new_del_address,copy_info_.temp_del_addr);
      IF (copy_info_.temp_del_addr IS NOT NULL) THEN
         FOR rec_ IN get_def_leadtime LOOP
            IF NOT (Check_Exist___(new_id_, new_del_address_, rec_.vendor_no, rec_.supplier_address, rec_.ship_via_code)) THEN   
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
--   Copies the data of Supplier in Supp_To_Cust_Leadtime_tab to the new _id.
PROCEDURE Copy_Supplier (
   supplier_id_ IN VARCHAR2,
   new_id_      IN VARCHAR2 )
IS   
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(200);
   attr_         VARCHAR2(2000);
   indrec_   Indicator_Rec;
   CURSOR get_attr IS
      SELECT *
        FROM SUPP_TO_CUST_LEADTIME_TAB
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
   vendor_no_                 IN VARCHAR2,
   supplier_address_          IN VARCHAR2,
   ship_via_code_             IN VARCHAR2,
   freight_map_id_            IN VARCHAR2,
   zone_id_                   IN VARCHAR2,
   manually_assigned_zone_db_ IN VARCHAR2 )
IS
   oldrec_     SUPP_TO_CUST_LEADTIME_TAB%ROWTYPE;
   newrec_     SUPP_TO_CUST_LEADTIME_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', freight_map_id_, attr_);
   Client_SYS.Add_To_Attr('ZONE_ID', zone_id_, attr_);
   Client_SYS.Add_To_Attr('MANUALLY_ASSIGNED_ZONE_DB', manually_assigned_zone_db_, attr_);
   oldrec_ := Lock_By_Keys___(customer_no_, addr_no_, vendor_no_, supplier_address_, ship_via_code_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Zone_Info;


