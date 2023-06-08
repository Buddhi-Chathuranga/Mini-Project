-----------------------------------------------------------------------------
--
--  Logical unit: SiteToSitePartLeadtime
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210505  JaThlk   Bug 158994 (SCZ-14511), Overridden Prepare_Insert___() to add default value for DEFAULT_SHIP_VIA_DB. 
--  161118  VISALK   STRMF-8219, Overrided Check_Common___ to raise error messages for the negative values.
--  150929  ChFolk   Bug 124822, Modified Check_Update___ and Check_Insert___ to set default value for transport leadtime.
--  140123  MaIklk   EAP-910, Overridden Insert() and handled default ship via value.
--  130802  ChJalk   TIBE-907, Removed the global variable inst_FreightZone_.
--  130715  MAHPLK   Removed attribute Load_Sequence_No.
--  130625  MeAblk   Converted the static calls to Shipment_Type_API.Exist into dynamic calls. 
--  130614  SURBLK   Added attribute forward_agent_id.
--  130213  GayDLK   Bug 103827, Modified Unpack_Check_Insert___(), Unpack_Check_Update___(), Check_Delete___()  
--  130213           and SITE_TO_SITE_PART_LEADTIME view by adding user allowed site validation.
--  120822  MeAblk   Unit testing corrections done on task BI-478.  
--  120820  MeAblk   Added shipment_type and function Get_Shipment_Type.
--  120704  MaHplk   Added attribute picking_leadtime.
--  120627  MaMalk   Added attributes Route_ID and Load_Sequence_No.
--  120316  JeLise   Changed the error message in Check_Exist.
--  120201  MaEelk   Corrected view comments in default_ship_via. and corrected view comments of SITE_TO_SITE_PART_LEADTIME_LOV
--  101202  ShKolk   Modified method call to Freight_Zone_API into dynamic call.
--  100816  MaHplk   Added new method Modify_Zone_Info.
--  100805  MaHplk   Added attribute freight_map_id, zone_id and manually_assigned_zone to LU.
--  100505  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  090401  SaWjlk   Bug 81590, Deleted the General_SYS.Init_Method code line from function Get_Default_Ship_Via_Code()
--  081202  DAYJLK   Bug 78624, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ by adding checks 
--  081202           to ensure that only valid values are entered for attribute Internal Lead time.
--  060206  IsAnlk   Modified Insert___ to avoid Ora error when entering a supply chain part group.
--  040511  HeWelk   Modifications(Leadtime to Lead Time) according to 'Date & Lead Time Realignment'
--  040302  GeKalk   Removed substrb from views for UNICODE modifications.
--  ----------------------------------13.3--------------------------------------
--  031014  PrJalk   Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  031001  ChBalk   Added Check_Part_Group_Rows_Exist.
--  030922  ChBalk   Added more conditions in Check_Exist.
--  030819  MaEelk   Performed CR Merge (CR Only).
--  030806  SeKalk   Code Review
--  030725  BhRalk   Added new Method Check_Ship_Via_Exist.
--  030725  BhRalk   Added new View SITE_TO_SITE_PART_LEADTIME_LOV.
--  030724  NuFilk   Added method Check_Exist.
--  030702  NuFilk   Modified method Unpack_Check_Update___ to clear currency field if exp additional cost is null.
--  030609  WaJalk   Modified the error message, when currency is not specified for the exp. additional cost.
--  030506  WaJalk   Made internal_delivery_leadtime mandatory.
--  030424  ChBalk   Removed Check_Ship_Via_Lines__.
--  030423  ChBalk   Added CheckRecordExist public method.
--  030421  ChBalk   Added Get_Default_Ship_Via_Code and Removed Remove_Lines.
--  030408  ChBalk   Added Check_Ship_Via_Lines__, Remove_Lines and delete functionality.
--  030407  ChBalk   Default ship via, newline functionality completed
--  030327  ChBalk   Modified according to the design Changes
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
   oldrec_     IN     SITE_TO_SITE_PART_LEADTIME_TAB%ROWTYPE,
   newrec_     IN OUT SITE_TO_SITE_PART_LEADTIME_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.default_ship_via = 'Y') THEN
      UPDATE site_to_site_part_leadtime_tab
         SET default_ship_via = 'N',
             rowversion = sysdate
         WHERE demand_site = newrec_.demand_site
         AND supply_site = newrec_.supply_site
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
   remrec_ IN SITE_TO_SITE_PART_LEADTIME_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, remrec_.demand_site);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, remrec_.supply_site);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT site_to_site_part_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   IF (newrec_.manually_assigned_zone IS NULL) THEN
      newrec_.manually_assigned_zone := 'FALSE';
   END IF;
   IF( newrec_.default_ship_via IS NULL) THEN
      newrec_.default_ship_via := Gen_Yes_No_API.DB_NO; 
   END IF;
   IF(newrec_.transport_leadtime IS NULL) THEN
      newrec_.transport_leadtime := 0;
   END IF;
   super(newrec_, indrec_, attr_);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.demand_site);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.supply_site);

   IF newrec_.delivery_leadtime < 0 OR newrec_.delivery_leadtime > 999 THEN
      Error_SYS.Record_General(lu_name_, 'LEADTIME_NOT_VALID: External Transport Lead Time must be between 0 and 999');
   END IF;
   IF (newrec_.transport_leadtime < 0 ) THEN
      Error_SYS.Record_General(lu_name_ , 'MINUSLEADTIME: Transport Lead Time may not be Negative');
   END IF;   
   IF newrec_.internal_delivery_leadtime < 0 OR newrec_.internal_delivery_leadtime > 999 THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_INTLEADTIME: Internal Transport Lead Time must be between 0 and 999');
   END IF;
   IF (newrec_.distance < 0) THEN
      Error_SYS.Record_General(lu_name_, 'DISTANCE_NOT_VALID: Distance can not have negative Value');
   END IF;
   IF (newrec_.expected_additional_cost < 0) THEN
      Error_SYS.Record_General(lu_name_, 'EXP_ADD_COST_NOT_VALID: Expected Additional Cost can not be a negative Value');
   END IF;
   IF (newrec_.expected_additional_cost IS NOT NULL) AND (newrec_.currency_code IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOT_BE_NULL: Currency is mandatory when a value exists in the Expected Additional Cost field.');
   END IF;  
   IF ((newrec_.expected_additional_cost IS NULL) AND (newrec_.currency_code IS NOT NULL)) THEN
      newrec_.currency_code := NULL;
      Client_SYS.Add_To_Attr('CURRENCY_CODE', newrec_.currency_code, attr_);
   END IF;

   IF newrec_.picking_leadtime IS NOT NULL THEN
      IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0)  THEN
         Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'VALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
      END IF;
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     site_to_site_part_leadtime_tab%ROWTYPE,
   newrec_ IN OUT site_to_site_part_leadtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
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

   IF newrec_.delivery_leadtime < 0 OR newrec_.delivery_leadtime > 999 THEN
      Error_SYS.Record_General(lu_name_, 'LEADTIME_NOT_VALID: External Transport Lead Time must be between 0 and 999');
   END IF;
   IF (newrec_.transport_leadtime < 0 ) THEN
      Error_SYS.Record_General(lu_name_ , 'MINUSLEADTIME: Transport Lead Time may not be Negative');
   END IF;
   IF newrec_.internal_delivery_leadtime < 0 OR newrec_.internal_delivery_leadtime > 999 THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_INTLEADTIME: Internal Transport Lead Time must be between 0 and 999');
   END IF;
   IF (newrec_.distance < 0) THEN
      Error_SYS.Record_General(lu_name_, 'DISTANCE_NOT_VALID: Distance can not have negative Value');
   END IF;
   IF (newrec_.expected_additional_cost < 0) THEN
      Error_SYS.Record_General(lu_name_, 'EXP_ADD_COST_NOT_VALID: Expected Additional Cost can not be a negative Value');
   END IF;
   IF (newrec_.expected_additional_cost IS NOT NULL) AND (newrec_.currency_code IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOT_BE_NULL: Currency is mandatory when a value exists in the Expected Additional Cost field.');
   END IF;
   IF ((newrec_.expected_additional_cost IS NULL) AND (newrec_.currency_code IS NOT NULL)) THEN
      newrec_.currency_code := NULL;
      Client_SYS.Add_To_Attr('CURRENCY_CODE', newrec_.currency_code, attr_);
   END IF;
   IF newrec_.picking_leadtime IS NOT NULL THEN
      IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0)  THEN
         Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'VALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
      END IF;
   END IF;
END Check_Update___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT site_to_site_part_leadtime_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 ) 
IS
BEGIN 
   IF (Is_Default_Ship_Via(newrec_.demand_site, newrec_.supply_site, newrec_.supply_chain_part_group) = 'FALSE' ) THEN
      newrec_.default_ship_via := 'Y';
   ELSE
      IF(newrec_.default_ship_via = 'Y') THEN
         UPDATE site_to_site_part_leadtime_tab
         SET default_ship_via = 'N',
             rowversion = sysdate
         WHERE demand_site = newrec_.demand_site
         AND supply_site = newrec_.supply_site
         AND supply_chain_part_group = newrec_.supply_chain_part_group
         AND default_ship_via = 'Y';
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('DEFAULT_SHIP_VIA_DB', newrec_.default_ship_via, attr_);      
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

@Override 
PROCEDURE Check_Common___ (
   oldrec_ IN     site_to_site_part_leadtime_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY site_to_site_part_leadtime_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS 
BEGIN
   IF (newrec_.safety_lead_time < 0 ) THEN
      Error_SYS.Record_General(lu_name_ , 'NEGSAFLEADTIME: Safety Lead Time may not be Negative');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);   
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
--   If a default ship via exist between the demand site and the supply
--   site for the supply chain part group then returns 'TRUE' otherwise 'FALSE'.
FUNCTION Is_Default_Ship_Via (
   demand_site_           IN VARCHAR2,
   supply_site_           IN VARCHAR2,
   supp_chain_part_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   flag_    VARCHAR2(5);
   dummy_   NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM SITE_TO_SITE_PART_LEADTIME_TAB
      WHERE demand_site = demand_site_
      AND supply_site = supply_site_
      AND supply_chain_part_group = supp_chain_part_group_
      AND default_ship_via = 'Y';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND)THEN
      CLOSE exist_control;
      flag_ := 'TRUE';
   ELSE
      CLOSE exist_control;
      flag_ := 'FALSE';
   END IF;
   RETURN flag_;
END Is_Default_Ship_Via;


-- Get_Default_Ship_Via_Code
--   Return the default ship via code between demand site and the supply
--   site for the specified supply chain part group.
@UncheckedAccess
FUNCTION Get_Default_Ship_Via_Code (
   demand_site_            IN VARCHAR2,
   supply_site_            IN VARCHAR2,
   supp_chain_part_group_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR Get_Default_Ship_Via_Code IS
      SELECT ship_via_code
      FROM SITE_TO_SITE_PART_LEADTIME_TAB
      WHERE demand_site = demand_site_
      AND supply_site = supply_site_
      AND supply_chain_part_group = supp_chain_part_group_
      AND default_ship_via = 'Y';

      ship_via_code_   VARCHAR2(3);

BEGIN
   OPEN Get_Default_Ship_Via_Code;
   FETCH Get_Default_Ship_Via_Code INTO ship_via_code_;
   CLOSE Get_Default_Ship_Via_Code;

   RETURN ship_via_code_;
END Get_Default_Ship_Via_Code;


-- Check_Exist
--   Checks if an instance exist corresponding to SiteToSiteLeadtime,
--   If one exist then an Error is given so that the records in SiteToSitePartLeadtime,
--   are first removed before a corresponding instance in SiteToSiteLeadtime LU
--   is removed.
--   Note: Handles the deletion of an instance of SiteToSiteLeadtime through
--   the View comments and Reference Sys methods in this LU. The parameter
--   ship_via_code_ is not used and only necessary because of the key set.
PROCEDURE Check_Exist (
   demand_site_   IN VARCHAR2,
   supply_site_   IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SITE_TO_SITE_PART_LEADTIME_TAB
      WHERE  demand_site = demand_site_
      AND    supply_site = supply_site_;
BEGIN
   IF (Site_To_Site_Leadtime_API.Count_Row (demand_site_, supply_site_) = 1) THEN
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      IF (exist_control%FOUND) THEN
         CLOSE exist_control;
         Error_SYS.Record_General(lu_name_, 'SITE_PART_LEAD_EXIST:  May not be deleted since it has exception records');
      END IF;
      CLOSE exist_control;
   END IF;
END Check_Exist;


-- Check_Ship_Via_Exist
--   This method will return 1 when a matching record is found and
--   if not will return 0.
@UncheckedAccess
FUNCTION Check_Ship_Via_Exist (
   demand_site_             IN VARCHAR2,
   supply_site_             IN VARCHAR2,
   supply_part_chain_group_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SITE_TO_SITE_PART_LEADTIME_TAB
      WHERE demand_site = demand_site_
      AND   supply_site = supply_site_ 
      AND   supply_chain_part_group = supply_part_chain_group_; 
      
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 1;
   END IF;
   CLOSE exist_control;
   RETURN 0;
END Check_Ship_Via_Exist;


-- Check_Part_Group_Rows_Exist
--   Count the number of rows.
@UncheckedAccess
FUNCTION Check_Part_Group_Rows_Exist (
   demand_site_ IN VARCHAR2,
   supply_site_ IN VARCHAR2) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SITE_TO_SITE_PART_LEADTIME_TAB
      WHERE demand_site = demand_site_
      AND   supply_site = supply_site_;
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


PROCEDURE Modify_Zone_Info (
   demand_site_               IN VARCHAR2,
   supply_site_               IN VARCHAR2,
   ship_via_code_             IN VARCHAR2,
   supply_chain_part_group_   IN VARCHAR2,
   freight_map_id_            IN VARCHAR2,
   zone_id_                   IN VARCHAR2,
   manually_assigned_zone_db_ IN VARCHAR2 )
IS
   oldrec_     SITE_TO_SITE_PART_LEADTIME_TAB%ROWTYPE;
   newrec_     SITE_TO_SITE_PART_LEADTIME_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', freight_map_id_, attr_);
   Client_SYS.Add_To_Attr('ZONE_ID', zone_id_, attr_);
   Client_SYS.Add_To_Attr('MANUALLY_ASSIGNED_ZONE_DB', manually_assigned_zone_db_, attr_);
   oldrec_ := Lock_By_Keys___(demand_site_, supply_site_, ship_via_code_, supply_chain_part_group_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Zone_Info;



