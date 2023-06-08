-----------------------------------------------------------------------------
--
--  Logical unit: StorageZone
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190627  SBalLK  SCUXXW4-22873, Modified Get_Sql_Where_Expression() method by increasing the length of sql_where_expression_ variable length to 28000 from 4000.
--  171019  SBalLK  Bug 138324, Modified Get_Sql_Where_Expression() method to optimize performance when defined storage zone used to fetch expression.
--  130131  MAHPLK  Modified Get_Sql_Where_Expression method to handle operator values for selection.
--  121116  MAHPLK  Added new public method Get_Sql_Where_Expression.
--  121115  MaEelk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT',USER_ALLOWED_SITE_API.Get_Default_Site,attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Sql_Where_Expression
--   Return all 'Sql_Where_Expression' for specific contract and storage_zone_id
--   by concatenating together with an OR statement between each Sql_Where_Expression.
@UncheckedAccess
FUNCTION Get_Sql_Where_Expression (
   contract_        IN VARCHAR2,
   storage_zone_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- Set length to 28000 instead of 32767 to give some space to select statement which intended to append with where stmt.
   sql_where_expression_ VARCHAR2(28000);
   
   CURSOR get_expression IS
      SELECT sql_where_expression 
      FROM storage_zone_detail_tab
      WHERE contract = contract_
      AND ((storage_zone_id = storage_zone_id_) OR 
           (Report_SYS.Parse_Parameter(storage_zone_id, storage_zone_id_) = 'TRUE'))
      ORDER BY Utility_SYS.String_To_Number(warehouse_id),
               warehouse_id,
               Utility_SYS.String_To_Number(bay_id),
               bay_id,
               Utility_SYS.String_To_Number(row_id),
               row_id,
               Utility_SYS.String_To_Number(tier_id),
               tier_id,
               Utility_SYS.String_To_Number(bin_id),
               bin_id;
BEGIN
   FOR rec_ IN get_expression LOOP
      IF (sql_where_expression_ IS NOT NULL) THEN
         sql_where_expression_ := sql_where_expression_ ||' OR ';
      END IF;
      sql_where_expression_ := sql_where_expression_ || '('||rec_.sql_where_expression||')';
   END LOOP;
   -- Make sure to return a valid WHERE-clause condition in case no details were found for this storage zone
   IF (sql_where_expression_ IS NULL) THEN
      sql_where_expression_ := '1=2';
   END IF;

   RETURN sql_where_expression_;
END Get_Sql_Where_Expression;



