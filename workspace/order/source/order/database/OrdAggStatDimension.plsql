-----------------------------------------------------------------------------
--
--  Logical unit: OrdAggStatDimension
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190429  LaThlk  SCUXXW4-19484, Removed the unused parameter from Get_Ord_Agg_Stat_Dimensions().
--  190419  LaThlk  SCUXXW4-9257, Added the function Get_Ord_Agg_Stat_Dimensions() to return dimensions as a stringify json.
--  091208  MaMalk  Made the necessary changes to make the Company and Aggregate_Id the parent key.
--  --------------------- 14.0.0 --------------------------------------------
--  060726  ThGulk Added Objid instead of rowid in Procedure Insert__
--  060112  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  000126  JakH  Init_Method fixes.
--  990407  JakH  New template. Removed get_dim_detail, added public remove.
--                Removed public view.
--  990205  JoEd  Run through Design.
--  990129  KaSu  Added cascade contraint with respect to OrdAggStat
--  98xxxx  xxxx  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Remove
--   Provided public delete method to be used from Ord_Agg_Stat
PROCEDURE Remove (
   company_      IN VARCHAR2,
   aggregate_id_ IN NUMBER,
   dim_row_      IN NUMBER )
IS
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   info_          VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___ ( objid_ , objversion_ , company_, aggregate_id_ , dim_row_  );
   Remove__ ( info_ , objid_ , objversion_ , 'DO');
END Remove;

FUNCTION Get_Ord_Agg_Stat_Dimensions (
   company_             IN VARCHAR2,
   aggregate_id_        IN NUMBER,
   issue_id_            IN VARCHAR2) RETURN VARCHAR2
IS 
   selected_str_     VARCHAR2(4000);
   CURSOR get_values IS
      SELECT dimension
      FROM   ORD_AGG_STAT_DIMENSION
      WHERE  aggregate_id = aggregate_id_
      AND    company = company_;   
BEGIN
   selected_str_ := '[';
   FOR value_ IN get_values LOOP
      selected_str_ := selected_str_ || '"' || 'COLUMN_NAME=' || value_.dimension || '^ISSUE_ID=' || issue_id_ || '^",';
   END LOOP;
   IF (selected_str_ = '[') THEN 
      RETURN NULL;
   END IF;
   selected_str_ := SUBSTR(selected_str_, 0, LENGTH(selected_str_) - 1) || ']';
   RETURN selected_str_;
END Get_Ord_Agg_Stat_Dimensions;



