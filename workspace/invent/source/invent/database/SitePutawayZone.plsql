-----------------------------------------------------------------------------
--
--  Logical unit: SitePutawayZone
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130102  MaEelk  storage_zone_id was made uppercase.
--  121116  MAHPLK  Added storage_zone_id and removed warehouse_id, bay_id, tier_id, row_id, bin_id from LU. 
--  121116          Removed Check_Remove_Warehouse__, Do_Remove_Warehouse__, Check_Remove_Bay__, Do_Remove_Bay__, 
--  121116          Check_Remove_Tier__, Do_Remove_Tier__, Check_Remove_Row__, Do_Remove_Row__, Check_Remove_Bin__, 
--  121116          Do_Remove_Bin__, Remove_Whse_Structure_Node___, Check_Site_Node_Ranking___, Check_Asset_Node_Ranking___, 
--  121116          Check_Comm_Node_Ranking___, Raise_Node_Ranking_Error___ Methods.
--  121116          Modified Site_Zone_Exist___, Asset_Frequency_Zone_Exist___ and Comm_Frequency_Zone_Exist___ methods to 
--  121116          add parameter storage_zone_id_ and removed warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_.
--  120802  Matkse  Removed methods Check_Remove_Warehouse, Check_Remove_Bay, Check_Remove_Row, Check_Remove_Tier and Check_Remove_Bin
--  120706  Matkse  Modified Unpack_Check_Insert by adding call to Check_Hierarchy_Level().
--  120705  Matkse  Added sql_where_expression to SITE_PUTAWAY_ZONE_TAB. 
--  120705          Modified methods Check_Remove.. and Do_Remove.. by making them public and renamed Do_Remove.. to Remove..
--  120425  JeLise  Changed the text for error message ZONERANK and moved it into the new method Raise_Node_Ranking___.
--  120125  MaEelk  Added Enumeration property to the view comments for frequency_class.
--  110713  MaEelk  Added user allowed site filter to SITE_PUTAWAY_ZONE.
--  101110  DaZase  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Sequence_No___(
   contract_ IN VARCHAR2 ) RETURN NUMBER
IS
   next_seq_ NUMBER;

   CURSOR get_next_seq IS
      SELECT NVL(MAX(sequence_no),0) + 1
      FROM   SITE_PUTAWAY_ZONE_TAB
      WHERE  contract = contract_;
BEGIN
   OPEN  get_next_seq;
   FETCH get_next_seq INTO next_seq_;
   CLOSE get_next_seq;
   RETURN next_seq_;
END Get_Next_Sequence_No___;


PROCEDURE Site_Zone_Exist___ (
   contract_        IN VARCHAR2,
   storage_zone_id_ IN VARCHAR2 )
IS
   dummy_    NUMBER;

   CURSOR exist_control IS
      SELECT 1
        FROM SITE_PUTAWAY_ZONE_TAB
       WHERE contract        = contract_
         AND asset_class     IS NULL
         AND commodity_group IS NULL
         AND storage_zone_id    = storage_zone_id_;
BEGIN

   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_General(lu_name_, 'ZONELINEEXIST: Putaway Zone :P1 already exist for Site :P2.', storage_zone_id_, contract_);
   END IF;
   CLOSE exist_control;
END Site_Zone_Exist___;


PROCEDURE Asset_Frequency_Zone_Exist___ (
   contract_        IN VARCHAR2,
   asset_class_     IN VARCHAR2,
   frequency_class_ IN VARCHAR2,
   storage_zone_id_ IN VARCHAR2)
IS
   str_null_ VARCHAR2(11) := Database_SYS.string_null_;
   dummy_    NUMBER;

   CURSOR exist_control IS
      SELECT 1
        FROM SITE_PUTAWAY_ZONE_TAB
       WHERE contract     = contract_
         AND asset_class  = asset_class_
         AND NVL(frequency_class , str_null_) = NVL(frequency_class_ , str_null_)
         AND storage_zone_id = storage_zone_id_;
BEGIN

   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_General(lu_name_, 'ASSETZONELINEEXIST: Putaway Zone :P1 already exist for Asset Class :P2.', storage_zone_id_, asset_class_);
   END IF;
   CLOSE exist_control;
END Asset_Frequency_Zone_Exist___;


PROCEDURE Comm_Frequency_Zone_Exist___ (
   contract_        IN VARCHAR2,
   commodity_group_ IN VARCHAR2,
   frequency_class_ IN VARCHAR2,
   storage_zone_id_ IN VARCHAR2 )
IS
   str_null_ VARCHAR2(11) := Database_SYS.string_null_;
   dummy_    NUMBER;

   CURSOR exist_control IS
      SELECT 1
        FROM SITE_PUTAWAY_ZONE_TAB
       WHERE contract         = contract_
         AND commodity_group  = commodity_group_
         AND NVL(frequency_class , str_null_) = NVL(frequency_class_ , str_null_)
         AND storage_zone_id = storage_zone_id_;
BEGIN

   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_General(lu_name_, 'COMMZONELINEEXIST: Putaway Zone :P1 already exist for Commodity Group :P2.', storage_zone_id_, commodity_group_);
   END IF;
   CLOSE exist_control;
END Comm_Frequency_Zone_Exist___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SITE_PUTAWAY_ZONE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.sequence_no := Get_Next_Sequence_No___(newrec_.contract);
   Client_SYS.Add_To_Attr('SEQUENCE_NO', newrec_.sequence_no, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT site_putaway_zone_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
      
   IF newrec_.ranking < 1 OR (newrec_.ranking != ROUND(newrec_.ranking)) THEN
      Error_SYS.Record_General(lu_name_,'RANKING: Ranking must be an integer greater than zero.');
   END IF;

   IF newrec_.asset_class IS NOT NULL AND newrec_.commodity_group IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'ASSETCOMM: Asset Class and Commodity Group can not be combined for one Putaway Zone record.');
   END IF;

   IF newrec_.asset_class IS NOT NULL THEN
      Asset_Frequency_Zone_Exist___(newrec_.contract, newrec_.asset_class, newrec_.frequency_class, newrec_.storage_zone_id);
   ELSIF newrec_.commodity_group IS NOT NULL THEN
      Comm_Frequency_Zone_Exist___(newrec_.contract, newrec_.commodity_group, newrec_.frequency_class, newrec_.storage_zone_id);
   ELSE
      Site_Zone_Exist___(newrec_.contract, newrec_.storage_zone_id);
   END IF;

   IF newrec_.max_bins_per_part IS NOT NULL THEN
      IF newrec_.max_bins_per_part < 1 OR (newrec_.max_bins_per_part != ROUND(newrec_.max_bins_per_part)) THEN
         Error_SYS.Record_General(lu_name_,'MAXBINSPERPART: Max Bins per Part must be an integer greater than 0.');
      END IF;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_Hierarchy_Level (
   bay_id_  IN VARCHAR2,
   tier_id_ IN VARCHAR2,
   row_id_  IN VARCHAR2,
   bin_id_  IN VARCHAR2 )
IS
   level_error_ VARCHAR2(25);
BEGIN
   IF(row_id_ IS NOT NULL AND bay_id_ IS NULL) THEN
      level_error_ := Warehouse_Structure_Level_API.DB_ROW;
   END IF;
   
   IF(tier_id_ IS NOT NULL AND bay_id_ IS NULL) THEN
      level_error_ := Warehouse_Structure_Level_API.DB_TIER;
   END IF;
            
   IF(bin_id_ IS NOT NULL AND (tier_id_ IS NULL AND row_id_ IS NULL)) THEN
      level_error_ := Warehouse_Structure_Level_API.DB_BIN;
   END IF;
   
   IF (level_error_ IS NOT NULL) THEN
      Error_Sys.Record_General(lu_name_, 'HIERARCHYLEVELERROR: There is an incomplete inventory level hierarchy for :P1', Warehouse_Structure_Level_API.Decode(level_error_));
   END IF;   
END Check_Hierarchy_Level;


PROCEDURE Lock_By_Keys_Wait (
   contract_    IN VARCHAR2,
   sequence_no_ IN NUMBER )
IS 
   dummy_ SITE_PUTAWAY_ZONE_TAB%ROWTYPE;
BEGIN
   dummy_ := Lock_By_keys___(contract_, sequence_no_);
END Lock_By_Keys_Wait;



