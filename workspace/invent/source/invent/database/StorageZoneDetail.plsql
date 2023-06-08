-----------------------------------------------------------------------------
--
--  Logical unit: StorageZoneDetail
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210209  SBalLK  Bug 156901(SCZ-12600), Modified Generate_Sql_Where_Expression___() method to consider leading spaces on default warehouse bay bin when creating SQL statement.
--  190627  SBalLK  SCUXXW4-22873, Modified Check_Generated_Sql_Length___() method by increasing the length of current_sql_expression_ variable length to 28000 from 4000.
--  190611  SBalLK  SCUXXW4-22255, Added Generate_Sql_Where_Expression___() and modified Insert___() method to generate and insert SQL where statement in the server itself for avoid SQL Injections.
--  161018  NiLalk  STRSC-4499, Modified Insert___() and added Check_Generated_Sql_Length___() method to validate generated SQL expression length for avoid buffer small error.
--  140603  MAHPLK  PRSC-454, Removed Check_Hierarchy_Level and Modified Check_Insert___ to ensure at lease on inventory level have defined in storage zone line.
--  121128  MaEelk  changed the error message HIERARCHYLEVELERROR in Check_Hierachy_Level.
--  121115  MaEelk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Remove_Whse_Structure_Node___ (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 )
IS
   objid_      STORAGE_ZONE_DETAIL.objid%TYPE;
   objversion_ STORAGE_ZONE_DETAIL.objversion%TYPE;

   CURSOR get_records_and_lock IS
      SELECT *
      FROM STORAGE_ZONE_DETAIL_TAB
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_
      AND  (bay_id  = bay_id_  OR bay_id_  IS NULL)
      AND  (tier_id = tier_id_ OR tier_id_ IS NULL)
      AND  (row_id  = row_id_  OR row_id_  IS NULL)
      AND  (bin_id  = bin_id_  OR bin_id_  IS NULL)
      FOR UPDATE;
BEGIN
   FOR record_ IN get_records_and_lock LOOP
      Check_Delete___(record_);
      Get_Id_Version_By_Keys___(objid_,
                                objversion_,
                                record_.contract,
                                record_.storage_zone_id,
                                record_.sequence_no);
      Delete___(objid_, record_);
   END LOOP;
END Remove_Whse_Structure_Node___;


-- Get_Next_Sequence_No___
--   Retuns the next number value that can be taken as the sequence no
FUNCTION Get_Next_Sequence_No___(
   contract_         IN VARCHAR2,
   storage_zone_id_  IN VARCHAR2 ) RETURN NUMBER
IS
   next_seq_ NUMBER;

   CURSOR get_next_seq IS
      SELECT NVL(MAX(sequence_no),0) + 1
      FROM   STORAGE_ZONE_DETAIL_TAB
      WHERE  contract = contract_
      AND    storage_zone_id = storage_zone_id_;
BEGIN
   OPEN  get_next_seq;
   FETCH get_next_seq INTO next_seq_;
   CLOSE get_next_seq;
   RETURN next_seq_;
END Get_Next_Sequence_No___;


PROCEDURE Storage_Zone_Detail_Exist___ (
   contract_        IN VARCHAR2,
   storage_zone_id_ IN VARCHAR2,
   warehouse_id_    IN VARCHAR2,
   bay_id_          IN VARCHAR2,
   tier_id_         IN VARCHAR2,
   row_id_          IN VARCHAR2,
   bin_id_          IN VARCHAR2 )
IS
   str_null_ VARCHAR2(11) := Database_SYS.string_null_;
   dummy_    NUMBER;

   CURSOR exist_control IS
      SELECT 1
        FROM STORAGE_ZONE_DETAIL_TAB
       WHERE contract        = contract_
         AND storage_zone_id = storage_zone_id_
         AND NVL(warehouse_id, str_null_) = NVL(warehouse_id_, str_null_)
         AND NVL(bay_id , str_null_) = NVL(bay_id_ , str_null_)
         AND NVL(row_id , str_null_) = NVL(row_id_ , str_null_)
         AND NVL(tier_id, str_null_) = NVL(tier_id_, str_null_)
         AND NVL(bin_id , str_null_) = NVL(bin_id_ , str_null_);
BEGIN

   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_General(lu_name_, 'ZONELINEEXIST: The Warehouse Bay Bin object already exists for the storage zone :P1 in site :P2', storage_zone_id_, contract_);
   END IF;
   CLOSE exist_control;
END Storage_Zone_Detail_Exist___;

PROCEDURE Check_Generated_Sql_Length___(
   storage_zone_id_        IN storage_zone_detail_tab.storage_zone_id%TYPE,
   contract_               IN storage_zone_detail_tab.contract%TYPE )
IS
   current_sql_expression_ VARCHAR2(28000);
BEGIN
   current_sql_expression_ := Storage_Zone_API.Get_Sql_Where_Expression(contract_, storage_zone_id_);
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Record_General(lu_name_, 'SQLLENGTHERR: The character limit set for the concatenated SQL Where Expressions is exceeded. Consider revising the expressions to fit the limitation.');
END Check_Generated_Sql_Length___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT STORAGE_ZONE_DETAIL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.sequence_no := Get_Next_Sequence_No___(newrec_.contract, newrec_.storage_zone_id);
   Generate_Sql_Where_Expression___(newrec_);
   Client_SYS.Add_To_Attr('SEQUENCE_NO', newrec_.sequence_no, attr_);
   
   super(objid_, objversion_, newrec_, attr_);
   Check_Generated_Sql_Length___(newrec_.storage_zone_id, newrec_.contract);
   
   Client_SYS.Add_To_Attr('SQL_WHERE_EXPRESSION', newrec_.sql_where_expression, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT storage_zone_detail_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.warehouse_id IS NULL) AND (newrec_.bay_id IS NULL) AND (newrec_.tier_id IS NULL) AND (newrec_.row_id IS NULL) AND (newrec_.bin_id IS NULL) THEN 
      Error_Sys.Record_General(lu_name_, 'INVENTLEVELERROR: Please ensure that at least a warehouse, bay, row, tier or a bin has been specified for the storage zone line.');
   END IF;
   
   super(newrec_, indrec_, attr_);
   
   Storage_Zone_Detail_Exist___(newrec_.contract, newrec_.storage_zone_id, newrec_.warehouse_id, newrec_.bay_id, newrec_.tier_id, newrec_.row_id, newrec_.bin_id);
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remove_Warehouse (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 )
IS
BEGIN
   Remove_Whse_Structure_Node___(contract_, warehouse_id_, NULL, NULL, NULL, NULL);
END Remove_Warehouse;


PROCEDURE Remove_Bay (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2 )
IS
BEGIN
   Remove_Whse_Structure_Node___(contract_, warehouse_id_, bay_id_, NULL, NULL, NULL);
END Remove_Bay;


PROCEDURE Remove_Row (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   row_id_       IN VARCHAR2 )
IS
BEGIN
   Remove_Whse_Structure_Node___(contract_, warehouse_id_, bay_id_, NULL, row_id_, NULL);
END Remove_Row;


PROCEDURE Remove_Bin (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2,
   row_id_       IN VARCHAR2,
   bin_id_       IN VARCHAR2 )
IS
BEGIN
   Remove_Whse_Structure_Node___(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);
END Remove_Bin;


PROCEDURE Remove_Tier (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   bay_id_       IN VARCHAR2,
   tier_id_      IN VARCHAR2 )
IS
BEGIN
   Remove_Whse_Structure_Node___(contract_, warehouse_id_, bay_id_, tier_id_, NULL, NULL);
END Remove_Tier;


PROCEDURE Lock_By_Keys_Wait (
   contract_        IN VARCHAR2,
   storage_zone_id_ IN VARCHAR2,   
   sequence_no_     IN NUMBER )
IS 
   dummy_ STORAGE_ZONE_DETAIL_TAB%ROWTYPE;
BEGIN
   dummy_ := Lock_By_keys___(contract_, storage_zone_id_, sequence_no_);
END Lock_By_Keys_Wait;

PROCEDURE Generate_Sql_Where_Expression___(
   newrec_ IN OUT storage_zone_detail_tab%ROWTYPE )
IS
   sql_where_            VARCHAR2(4000);
   sql_where_expression_ VARCHAR2(4000);
   default_id_           VARCHAR2(3)  := Warehouse_Bay_Bin_API.default_bin_id_;
   dummy_string_         VARCHAR2(9)  := 'DEFAULTID';
BEGIN
   IF newrec_.warehouse_id IS NOT NULL THEN
      Report_SYS.Parse_Column_Where_(sql_where_, 'WAREHOUSE_ID', newrec_.warehouse_id, 'N', 'STRING');
      sql_where_expression_ := CONCAT('(', CONCAT(sql_where_, ') AND '));
   END IF;
   IF newrec_.bay_id IS NOT NULL THEN
      Report_SYS.Parse_Column_Where_(sql_where_, 'BAY_ID', REPLACE(newrec_.bay_id, default_id_, dummy_string_), 'N', 'STRING');
      sql_where_expression_ := CONCAT(sql_where_expression_, CONCAT('(', CONCAT(sql_where_, ') AND ')));
   END IF;
   IF newrec_.row_id IS NOT NULL THEN
      Report_SYS.Parse_Column_Where_(sql_where_, 'ROW_ID', REPLACE(newrec_.row_id, default_id_, dummy_string_), 'N', 'STRING');
      sql_where_expression_ := CONCAT(sql_where_expression_, CONCAT('(', CONCAT(sql_where_, ') AND ')));
   END IF;
   IF newrec_.tier_id IS NOT NULL THEN
      Report_SYS.Parse_Column_Where_(sql_where_, 'TIER_ID', REPLACE(newrec_.tier_id, default_id_, dummy_string_), 'N', 'STRING');
      sql_where_expression_ := CONCAT(sql_where_expression_, CONCAT('(', CONCAT(sql_where_, ') AND ')));
   END IF;
   IF newrec_.bin_id IS NOT NULL THEN
      Report_SYS.Parse_Column_Where_(sql_where_, 'BIN_ID', REPLACE(newrec_.bin_id, default_id_, dummy_string_), 'N', 'STRING');
      sql_where_expression_ := CONCAT(sql_where_expression_, CONCAT('(', CONCAT(sql_where_, ') AND ')));
   END IF;
   IF sql_where_expression_ IS NOT NULL THEN
      sql_where_expression_ := SUBSTR(sql_where_expression_, 1, (length(sql_where_expression_) -5));
      newrec_.sql_where_expression := REPLACE(CONCAT(CONCAT('(', sql_where_expression_), ')'), dummy_string_, default_id_);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Record_General(lu_name_, 'CHAREXCEEDED: Generated sql statement exceded the 4000 character limitation.');
END Generate_Sql_Where_Expression___;