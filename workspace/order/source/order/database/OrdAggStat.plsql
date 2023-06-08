-----------------------------------------------------------------------------
--
--  Logical unit: OrdAggStat
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100107  MaMalk   Changed company from a parent key to a key.   
--  091222  MaMalk   Set company as a parent key.   
--  091208  MaMalk   Made the necessary changes to make Company and AggregateId the key.
--  ----------------- 14.0.0 ------------------------------------------------
--  060726  ThGulk Added Objid instead of rowid in Procedure Insert__
--  060112  NaWalk   Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  040220  IsWilk   Removed the SUBSTRB from view and modified the SUBSTRB to SUBSTR for Unicode Changes.
--  -------------    Edge Package Group 3 Unicode Changes-----------------------
--  040120  GeKalk   Replaced INSTRB with INSTR for UNICODE modifications.
--  030929  ThGu     Changed substr to substrb, instr to instrb, length to lengthb.
--  991110  JoAn     CID 27863 Added check in Unpack_Check_Insert___ to assure that
--                   a weekday is specified if aggregating per week.
--  990415  JakH     Y. Removed old obsolete commented code.
--  990407  JakH     New template.
--  990325  JakH     Restored dummy view declaration from earlier version.
--  990322  JakH     Added description to LOV. Changed lov-titles to Aggregation Period and Day.
--  990205  JoEd     Run through Design.
--  990129  KaSu     Added comments for the public procedures.
--  990125  KaSu     Replaced all_col_comments with user_col_comments
--  98xxxx  xxxx     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ORD_AGG_STAT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- generate the aggregate id for a given company
   SELECT NVL(MAX(aggregate_id), 0) + 1
   INTO   newrec_.aggregate_id
   FROM   ORD_AGG_STAT_TAB
   WHERE  company = newrec_.company;

   Client_SYS.Add_To_Attr('AGGREGATE_ID', newrec_.aggregate_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT ord_agg_stat_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   -- IF the aggregation is done weekly the week day must also be specified
   IF (newrec_.ord_day_mon_year_stat = 'WEEK')  THEN
      IF (newrec_.ord_week_day_stat IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'DAYNOTSPEC: A day must be specified when aggregation is :P1',  
                                  Ord_Day_Mon_Year_Stat_API.Decode(newrec_.ord_day_mon_year_stat));
      END IF;
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Delete_Records
--   This procedure selects the records from the aggregate dimension and
--   aggregate columns and delete them, for given AggregateId, Dimesions
--   and Columns.
PROCEDURE Delete_Records (
   company_      IN VARCHAR2,
   aggregate_id_ IN NUMBER,
   dimensions_   IN VARCHAR2,
   columns_      IN VARCHAR2 )
IS
   CURSOR aggdim IS
      SELECT dim_row
      FROM   ord_agg_stat_dimension_tab
      WHERE  company = company_
      AND    aggregate_id = aggregate_id_;

   CURSOR aggcol IS
      SELECT column_name
      FROM   ord_agg_stat_column_tab
      WHERE  company = company_
      AND    aggregate_id = aggregate_id_;

   info_       VARCHAR2(500);
   token_      VARCHAR2(40);
   pos_        NUMBER;
   len_        NUMBER;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   dim_row_    NUMBER;
BEGIN

   -- Select the records from the aggregate dimension
   --- and aggregate columns and delete them
   FOR dim_ IN aggdim LOOP
      Ord_Agg_Stat_Dimension_API.Remove(company_, aggregate_id_, dim_.dim_row);
   END LOOP;

   FOR col_ IN aggcol LOOP
      Ord_Agg_Stat_Column_API.Remove(company_,aggregate_id_, col_.column_name);
   END LOOP;

   -- insert columns
   len_ := length(columns_);
   pos_ := 1;
   token_ := '';
   WHILE (pos_ <= len_) LOOP
      IF (substr(columns_, pos_, 1) <> '|') THEN
         token_ := token_ || substr(columns_, pos_, 1);
      ELSE
         IF (length(token_) > 0) THEN
            Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
            Client_SYS.Add_To_Attr('AGGREGATE_ID', aggregate_id_, attr_);
            Client_SYS.Add_To_Attr('COLUMN_NAME', token_, attr_);
            Ord_Agg_Stat_Column_API.New__(info_, objid_, objversion_, attr_, 'DO');
            token_ := '';
            Client_SYS.Clear_Attr(attr_);
         END IF;
      END IF;
      pos_ := pos_ + 1;
   END LOOP;

   -- insert dimensions
   len_ := length(dimensions_);
   pos_ := 1;
   token_ := '';
   dim_row_ := 0;
   WHILE (pos_ <= len_ ) LOOP
      IF (substr(dimensions_, pos_, 1)<>'|') THEN
         token_ := token_ || substr(dimensions_, pos_, 1);
      ELSE
         IF (length(token_) > 0) THEN
            dim_row_ := dim_row_ + 1;
            Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
            Client_SYS.Add_To_Attr('AGGREGATE_ID', aggregate_id_, attr_);
            Client_SYS.Add_To_Attr('DIM_ROW', dim_row_, attr_);
            Client_SYS.Add_To_Attr('DIMENSION', token_, attr_);
            Ord_Agg_Stat_dimension_API.New__(info_, objid_, objversion_, attr_, 'DO');
            token_ := '';
            Client_SYS.Clear_Attr(attr_);
         END IF;
      END IF;
      pos_ := pos_ + 1;
   END LOOP;
END Delete_Records;


-- Translate_Item_Prompt
--   This function returns the translated prompt of the given column name of
--   the specified view.
@UncheckedAccess
FUNCTION Translate_Item_Prompt (
   view_   IN VARCHAR2,
   column_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_prompt IS
     SELECT text
     FROM language_sys_tab
     WHERE type = 'Column'
     AND attribute = 'Prompt'
     AND lang_code = Language_SYS.Get_Language
     AND path = view_ || '.' || column_;

   CURSOR get_comment IS
      SELECT comments
      FROM   user_col_comments
      WHERE  table_name = view_
      AND    column_name = column_;

   prompt_  VARCHAR2(300);
   right_   VARCHAR2(300);
   comment_ VARCHAR2(300);
BEGIN
   OPEN get_prompt;
   FETCH get_prompt INTO prompt_;
   CLOSE get_prompt;

   IF (prompt_ IS NULL) THEN
      OPEN get_comment;
      FETCH get_comment INTO comment_;
      CLOSE get_comment;

      right_ := SUBSTR(comment_, instr(comment_, 'PROMPT=') + 7);
      prompt_ := SUBSTR(right_, 1, instr(right_, '^') - 1);
   END IF;
   RETURN prompt_;
END Translate_Item_Prompt;



