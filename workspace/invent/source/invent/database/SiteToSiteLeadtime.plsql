-----------------------------------------------------------------------------
--
--  Logical unit: SiteToSiteLeadtime
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210505  JaThlk   Bug 158994 (SCZ-14511), Overridden Prepare_Insert___() to add default value for DEFAULT_SHIP_VIA_DB.
--  200601  Aabalk   SCSPRING20-1687, Moved code to check if entered location is a shipment location, from Check_Insert___ and Check_Update___
--  200601           to Check_Common___. Modified Check_Common___ by adding a check to validate if selected shipment location is a non-remote warehouse location.
--  200310  RasDlk   SCSPRING20-1238, Modified the method Get_Default_Leadtime_Values() by adding the new parameter ship_inv_loc_no_.
--  200206  AsZelk   SCSPRING20-1348, Added picking_leadtime_, shipment_type_ and forward_agent_id_ out paramers into Get_Default_Leadtime_Values().
--  161118  VISALK   STRMF-8219, Overrided Check_Common___ to raise error messages for the negative values.
--  150929  ChFolk   Bug 124822, Modified Check_Update___ and Check_Insert___ to set default value for transport leadtime.
--  150925  ChFolk   Bug 124593, Added new OUT parameter arrival_route_id_ into Get_Default_Leadtime_Values.
--  150527  ChFolk   ORA-513, Modified Get_Default_Leadtime_Values to and New add new parameter transport_leadtime.
--  150402  ChFolk   ORA-141, Added new OUT parameter route_id to Get_Default_Leadtime_Values. Route_id is used in purchase date calculations.
--  140123  MaIklk   EAP-910, Overridden Insert() and handled default ship via value.
--  141128  SBalLK   PRSC-3709, Modified Get_Default_Leadtime_Values() method to get delivery term and delivery term location values from the supply chain matrix.
--  130805  MaRalk   TIBE-906, Removed global LU constant inst_FreightZone_ and modified methods Unpack_Check_Insert___ 
--  130805           Unpack_Check_Update___ using conditional compilation instead.
--  130715  MAHPLK   Removed attribute Load_Sequence_No.
--  130625  MeAblk   Converted the static calls to Shipment_Type_API.Exist into dynamic calls. 
--  130614  SURBLK   Added attribute forward_agent_id.
--  130213  GayDLK   Bug 103827, Modified Unpack_Check_Insert___(), Unpack_Check_Update___(), Check_Delete___() 
--  130213           and SITE_TO_SITE_LEADTIME view by adding user allowed site validation. 
--  120912  MeAblk   Modified Unpack_Check_Insert___, Unpack_Check_Update___ in order to validate whether the entered location is a shipment location.
--  120910  MeAblk   Added ship_inventory_location_no and accordingly modified other methods. Added function Get_Ship_Inventory_Location_No.
--  120820  MeAblk   Added shipment_type and function Get_Shipment_Type.
--  120704  MaHplk   Added attribute picking_leadtime.
--  120627  MaMalk   Added attributes Route_ID and Load_Sequence_No.
--  110815  Darklk   Bug 96145, Added the public attribute dist_order_curr_code and the function Get_Default_Dist_Ord_Curr and renamed 
--  110815           the currency_code to exp_add_cost_curr_code.
--  101202  ShKolk   Modified method call to Freight_Zone_API into dynamic call.
--  100816  MaHplk   Added new method Modify_Zone_Info.
--  100805  MaHplk   Added attribute freight_map_id, zone_id and manually_assigned_zone to LU.
--  100505  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  090401  SaWjlk   Bug 81590, Deleted the General_SYS.Init_Method code line from procedure Get_Default_Leadtime_Values() 
--  090401           and function Get_Default_Ship_Via_Code() as pragma conditions added.  
--  081202  DAYJLK   Bug 78624, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ by adding checks 
--  081202           to ensure that only valid values are entered for attribute Internal Lead time.
--  060120  MaHplk   Correct grammatical errors in error messages in Unpack_Check_Insert___ &Unpack_Check_Update___
--  060119  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___
--  060119           and added UNDEFINE according to the new template.
--  041011  Samnlk   Changed view comment of contract to site in view site_to_site_leadtime_lov.
--  040520  HeWelk   Modifications(Leadtime to Lead Time) according to 'Date & Lead Time Realignment'
--  040302  GeKalk   Removed substrb from views for UNICODE modifications.
--  --------------------------------- 13.3.0 --------------------------------
--  031014  PrJalk   Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  030922  ChBalk   Added new method Count_Rows.
--  190803  MaEelk   Performed CR Merge (CR Only).
--  030807  SeKalk   Code Review
--  030725  BhRalk   Added new View SITE_TO_SITE_LEADTIME_LOV.
--  030724  NuFilk   Modified method Check_Delete___.
--  030702  NuFilk   Modified method Unpack_Check_Update___ to clear currency field if exp additional cost is null.
--  030609  WaJalk   Modified the error message, when currency is not specified for the exp. additional cost.
--  030527  ChBalk   Added internal_leadtime to the Get_Default_Leadtime_Values method.
--  030507  ChBalk   Added public New method.
--  030506  WaJalk   Made internal_delivery_leadtime mandatory.
--  030424  ChBalk   Removed Check_Ship_Via_Lines__.
--  030408  ChBalk   Added Check_Ship_Via_Lines__ and delete functionality.
--  030407  ChBalk   Default ship via, newline functionality completed
--  030326  ChBalk   Created.
--  ************************* CR Merge *************************************
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SITE_TO_SITE_LEADTIME_TAB%ROWTYPE,
   newrec_     IN OUT SITE_TO_SITE_LEADTIME_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.default_ship_via = 'Y') THEN
      UPDATE site_to_site_leadtime_tab
         SET default_ship_via = 'N',
             rowversion = sysdate
         WHERE demand_site = newrec_.demand_site
         AND supply_site = newrec_.supply_site
         AND default_ship_via = 'Y';
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN SITE_TO_SITE_LEADTIME_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   Site_To_Site_Part_Leadtime_API.Check_Exist(remrec_.demand_site, remrec_.supply_site);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, remrec_.demand_site);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, remrec_.supply_site);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT site_to_site_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_     VARCHAR2(30);
   value_    VARCHAR2(4000);
BEGIN   
   IF (newrec_.manually_assigned_zone IS NULL) THEN
      newrec_.manually_assigned_zone := 'FALSE';
   END IF;
   IF( newrec_.default_ship_via IS NULL) THEN
      newrec_.default_ship_via := Gen_Yes_No_API.DB_NO; 
   END IF;
   IF (newrec_.transport_leadtime IS NULL) THEN
      newrec_.transport_leadtime := 0;
   END IF;
   super(newrec_, indrec_, attr_);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.demand_site);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.supply_site);

   IF newrec_.delivery_leadtime < 0 OR newrec_.delivery_leadtime > 999 THEN
      Error_SYS.Record_General(lu_name_, 'LEADTIME_NOT_VALID: External Transport Lead Time must be between 0 and 999');
   END IF;
   IF (newrec_.transport_leadtime < 0 ) THEN
      Error_SYS.Record_General(lu_name_ , 'NEGLEADTIME: Transport Lead Time may not be Negative');
   END IF;
   IF newrec_.internal_delivery_leadtime < 0 OR newrec_.internal_delivery_leadtime > 999 THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_INTLEADTIME: Internal Transport Lead Time must be between 0 and 999');
   END IF;
   IF (newrec_.distance < 0) THEN
      Error_SYS.Record_General(lu_name_, 'DISTANCE_NOT_VALID: Distance cannot have negative Value');
   END IF;
   IF (newrec_.expected_additional_cost < 0) THEN
      Error_SYS.Record_General(lu_name_, 'EXP_ADD_COST_NOT_VALID: Expected Additional Cost cannot be a negative Value');
   END IF;
   IF (newrec_.expected_additional_cost IS NOT NULL) AND (newrec_.exp_add_cost_curr_code IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOT_BE_NULL: Currency is mandatory when a value exists in the Expected Additional Cost field.');
   END IF;
   IF (newrec_.demand_site = newrec_.supply_site) THEN
      Error_SYS.Record_General(lu_name_, 'SAME_SITE_NOT_VALID: Demand Site and Supply Site cannot be the same site '':P1''. ', newrec_.demand_site);
   END IF;  
   IF ((newrec_.expected_additional_cost IS NULL) AND (newrec_.exp_add_cost_curr_code IS NOT NULL)) THEN
      newrec_.exp_add_cost_curr_code := NULL;
      Client_SYS.Add_To_Attr('EXP_ADD_COST_CURR_CODE', newrec_.exp_add_cost_curr_code, attr_);
   END IF;

   IF newrec_.picking_leadtime IS NOT NULL THEN
      IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0)  THEN
         Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'VALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     site_to_site_leadtime_tab%ROWTYPE,
   newrec_ IN OUT site_to_site_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_     VARCHAR2(30);
   value_    VARCHAR2(4000);
BEGIN
   -- Checking the default_ship_via NULL and enter defualt value.
   IF (newrec_.default_ship_via IS NULL) THEN
      newrec_.default_ship_via := 'N';
   END IF;
   IF (newrec_.manually_assigned_zone IS NULL) THEN
      newrec_.manually_assigned_zone := 'FALSE';
   END IF;
   IF(newrec_.transport_leadtime IS NULL) THEN
      newrec_.transport_leadtime := 0;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.demand_site);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.supply_site);

   IF (newrec_.expected_additional_cost < 0) THEN
      Error_SYS.Record_General(lu_name_, 'EXP_ADD_COST_NOT_VALID: Expected Additional Cost cannot be a negative Value');
   END IF;
   IF ((newrec_.expected_additional_cost IS NOT NULL) AND (newrec_.exp_add_cost_curr_code IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOT_BE_NULL: Currency is mandatory when a value exists in the Expected Additional Cost field.');
   END IF;
   IF ((newrec_.delivery_leadtime < 0) OR (newrec_.delivery_leadtime > 999)) THEN
      Error_SYS.Record_General(lu_name_, 'LEADTIME_NOT_VALID: External Transport Lead Time must be between 0 and 999');
   END IF;
   IF (newrec_.transport_leadtime < 0 ) THEN
      Error_SYS.Record_General(lu_name_ , 'NEGLEADTIME: Transport Lead Time may not be Negative');
   END IF;
   IF newrec_.internal_delivery_leadtime < 0 OR newrec_.internal_delivery_leadtime > 999 THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_INTLEADTIME: Internal Transport Lead Time must be between 0 and 999');
   END IF;
   IF (newrec_.distance < 0) THEN
      Error_SYS.Record_General(lu_name_, 'DISTANCE_NOT_VALID: Distance cannot have negative Value');
   END IF;
   IF ((newrec_.expected_additional_cost IS NULL) AND (newrec_.exp_add_cost_curr_code IS NOT NULL)) THEN
      newrec_.exp_add_cost_curr_code := NULL;
      Client_SYS.Add_To_Attr('EXP_ADD_COST_CURR_CODE', newrec_.exp_add_cost_curr_code, attr_);
   END IF;
   IF newrec_.picking_leadtime IS NOT NULL THEN
      IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0)  THEN
         Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'VALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
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
   newrec_     IN OUT site_to_site_leadtime_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
 
IS
BEGIN 
   IF (Is_Default_Ship_Via(newrec_.demand_site, newrec_.supply_site) = 'FALSE' ) THEN
      newrec_.default_ship_via := 'Y';
   ELSE
      IF(newrec_.default_ship_via = 'Y') THEN
         UPDATE site_to_site_leadtime_tab
         SET default_ship_via = 'N',
             rowversion = sysdate
         WHERE demand_site = newrec_.demand_site
         AND supply_site = newrec_.supply_site
         AND default_ship_via = 'Y';
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('DEFAULT_SHIP_VIA_DB', newrec_.default_ship_via, attr_);      
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

@Override 
PROCEDURE Check_Common___ (
   oldrec_ IN     site_to_site_leadtime_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY site_to_site_leadtime_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   IF (newrec_.safety_lead_time < 0 ) THEN
      Error_SYS.Record_General(lu_name_ , 'NEGSAFLEADTIME: Safety Lead Time may not be Negative');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   --   Added an IF condition to check whether entered location is a shipment location.
   IF (newrec_.ship_inventory_location_no IS NOT NULL) THEN
      $IF (Component_Discom_SYS.INSTALLED) $THEN
         Site_Discom_Info_API.Check_Site_Shipment_Location(newrec_.supply_site, newrec_.ship_inventory_location_no);
      $ELSE
         Error_SYS.Record_General(lu_name_,'DISCOMNOTEXIST: Component DISCOM is not installed.');
      $END
   END IF;
END Check_Common___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DEFAULT_SHIP_VIA_DB', Gen_Yes_No_API.DB_NO, attr_);
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Is_Default_Ship_Via
--   If a default ship via exist between the demand site and the supply site then returns 'TRUE' otherwise 'FALSE'.
FUNCTION Is_Default_Ship_Via (
   demand_site_ IN VARCHAR2,
   supply_site_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   NUMBER;
   flag_    VARCHAR2(5);

   CURSOR exist_control IS
      SELECT 1
      FROM SITE_TO_SITE_LEADTIME_TAB
      WHERE demand_site = demand_site_
      AND supply_site = supply_site_
      AND default_ship_via = 'Y';
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


-- Get_Default_Leadtime_Values
--   Retrieve the default ship via code and leadtime values between demand
--   site and the supply site.
@UncheckedAccess
PROCEDURE Get_Default_Leadtime_Values (
   ship_via_code_      OUT VARCHAR2,
   delivery_terms_     OUT VARCHAR2,
   del_terms_location_ OUT VARCHAR2,
   delivery_leadtime_  OUT NUMBER,
   transport_leadtime_ OUT NUMBER, 
   internal_leadtime_  OUT NUMBER,
   picking_leadtime_   OUT NUMBER,
   route_id_           OUT VARCHAR2,
   arrival_route_id_   OUT VARCHAR2,
   shipment_type_      OUT VARCHAR2,
   forward_id_         OUT VARCHAR2,
   ship_inv_loc_no_    OUT VARCHAR2,
   contract_           IN  VARCHAR2,
   demand_site_        IN  VARCHAR2,
   supply_site_        IN  VARCHAR2,
   part_no_            IN  VARCHAR2 DEFAULT NULL )
IS
   supply_chain_part_group_      VARCHAR2(20);
   site_to_site_part_lead_rec_   Site_To_SIte_Part_Leadtime_API.Public_Rec;
   site_to_site_lead_rec_        Site_To_Site_Leadtime_API.Public_Rec;
BEGIN
   IF (part_no_ IS NOT NULL) THEN
      supply_chain_part_group_ :=  Inventory_Part_API.Get_Supply_Chain_Part_Group( contract_, part_no_);
      IF ( supply_chain_part_group_ IS NOT NULL ) THEN
         ship_via_code_     := Site_To_Site_Part_Leadtime_API.Get_Default_Ship_Via_Code (demand_site_,
                                                                                     supply_site_,
                                                                                     supply_chain_part_group_);
         site_to_site_part_lead_rec_ := Site_To_Site_Part_Leadtime_API.Get(demand_site_, supply_site_, ship_via_code_, supply_chain_part_group_);
         delivery_terms_ := site_to_site_part_lead_rec_.delivery_terms;
         del_terms_location_ := site_to_site_part_lead_rec_.del_terms_location;
         delivery_leadtime_ := site_to_site_part_lead_rec_.delivery_leadtime;
         transport_leadtime_ := site_to_site_part_lead_rec_.transport_leadtime;
         internal_leadtime_ := site_to_site_part_lead_rec_.internal_delivery_leadtime;
         picking_leadtime_ := site_to_site_part_lead_rec_.picking_leadtime;
         shipment_type_ := site_to_site_part_lead_rec_.shipment_type;
         forward_id_ := site_to_site_part_lead_rec_.forward_agent_id;
         route_id_ := site_to_site_part_lead_rec_.route_id;
         arrival_route_id_ := site_to_site_part_lead_rec_.arrival_route_id;
      END IF;
   END IF;

   IF (ship_via_code_ IS NULL) THEN
      ship_via_code_     := Get_Default_Ship_Via_Code(demand_site_, supply_site_);
      site_to_site_lead_rec_ := Site_To_Site_Leadtime_API.Get(demand_site_, supply_site_, ship_via_code_);
      delivery_terms_ :=site_to_site_lead_rec_.delivery_terms;
      del_terms_location_ := site_to_site_lead_rec_.del_terms_location;
      delivery_leadtime_ := site_to_site_lead_rec_.delivery_leadtime;
      transport_leadtime_ := site_to_site_lead_rec_.transport_leadtime;
      internal_leadtime_ := site_to_site_lead_rec_.internal_delivery_leadtime;
      picking_leadtime_ := site_to_site_lead_rec_.picking_leadtime;
      shipment_type_ := site_to_site_lead_rec_.shipment_type;
      forward_id_ := site_to_site_lead_rec_.forward_agent_id;
      route_id_ := site_to_site_lead_rec_.route_id;
      arrival_route_id_ := site_to_site_lead_rec_.arrival_route_id;
      ship_inv_loc_no_ := site_to_site_lead_rec_.ship_inventory_location_no;
   END IF;
END Get_Default_Leadtime_Values;


-- Get_Default_Ship_Via_Code
--   Return the Default ship via code between the demand site and the supply site.
@UncheckedAccess
FUNCTION Get_Default_Ship_Via_Code (
   demand_site_ IN VARCHAR2,
   supply_site_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR Get_Default_Ship_Via_Code IS
      SELECT ship_via_code
      FROM SITE_TO_SITE_LEADTIME_TAB
      WHERE demand_site = demand_site_
      AND supply_site = supply_site_
      AND default_ship_via = 'Y';

   ship_via_code_   VARCHAR2(3);

BEGIN
   OPEN Get_Default_Ship_Via_Code;
   FETCH Get_Default_Ship_Via_Code INTO ship_via_code_;
   CLOSE Get_Default_Ship_Via_Code;

   RETURN ship_via_code_;
END Get_Default_Ship_Via_Code;


-- New
--   Public interface to create an instance of the class.
PROCEDURE New (
   demand_site_                IN VARCHAR2,
   supply_site_                IN VARCHAR2,
   ship_via_code_              IN VARCHAR2,
   delivery_leadtime_          IN NUMBER,
   transport_leadtime_         IN NUMBER,
   internal_delivery_leadtime_ IN NUMBER,
   default_ship_via_           IN VARCHAR2 )
IS
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(2000);

BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DEMAND_SITE', demand_site_, attr_);
   Client_SYS.Add_To_Attr('SUPPLY_SITE', supply_site_, attr_);
   Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', delivery_leadtime_, attr_);
   Client_SYS.Add_To_Attr('TRANSPORT_LEADTIME', transport_leadtime_, attr_);   
   Client_SYS.Add_To_Attr('INTERNAL_DELIVERY_LEADTIME', internal_delivery_leadtime_, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_SHIP_VIA_DB', default_ship_via_, attr_);
   New__ (info_, objid_, objversion_, attr_, 'DO');
END New;


@UncheckedAccess
FUNCTION Count_Row (
   demand_site_ IN VARCHAR2,
   supply_site_ IN VARCHAR2) RETURN NUMBER
IS
   dummy_      NUMBER;
   CURSOR get_num_rows IS
      SELECT count(*)
      FROM SITE_TO_SITE_LEADTIME_TAB
      WHERE  demand_site = demand_site_
      AND    supply_site = supply_site_;
BEGIN
   OPEN get_num_rows;
   FETCH get_num_rows INTO dummy_;
   CLOSE get_num_rows;
   RETURN dummy_;
END Count_Row;


PROCEDURE Modify_Zone_Info (
   demand_site_               IN VARCHAR2,
   supply_site_               IN VARCHAR2,
   ship_via_code_             IN VARCHAR2,
   freight_map_id_            IN VARCHAR2,
   zone_id_                   IN VARCHAR2,
   manually_assigned_zone_db_ IN VARCHAR2 )
IS
   oldrec_     SITE_TO_SITE_LEADTIME_TAB%ROWTYPE;
   newrec_     SITE_TO_SITE_LEADTIME_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', freight_map_id_, attr_);
   Client_SYS.Add_To_Attr('ZONE_ID', zone_id_, attr_);
   Client_SYS.Add_To_Attr('MANUALLY_ASSIGNED_ZONE_DB', manually_assigned_zone_db_, attr_);
   oldrec_ := Lock_By_Keys___(demand_site_, supply_site_, ship_via_code_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Zone_Info;


-- Get_Default_Dist_Ord_Curr
--   Return the default distribution order currency
@UncheckedAccess
FUNCTION Get_Default_Dist_Ord_Curr (
   demand_site_ IN VARCHAR2,
   supply_site_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   default_ship_via_code_   SITE_TO_SITE_LEADTIME_TAB.ship_via_code%TYPE;
   default_curr_code_       SITE_TO_SITE_LEADTIME_TAB.dist_order_curr_code%TYPE;
BEGIN   
   default_ship_via_code_ := Get_Default_Ship_Via_Code(demand_site_, supply_site_);
   IF (default_ship_via_code_ IS NOT NULL) THEN
      default_curr_code_ := Get_Dist_Order_Curr_Code(demand_site_, supply_site_, default_ship_via_code_);
   END IF;
   RETURN default_curr_code_;
END Get_Default_Dist_Ord_Curr;



