-----------------------------------------------------------------------------
--
--  Logical unit: CommodityGroup
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190425  NiNilk  Bug 147887 (SCZ-4075), Modified the method Exist_With_Wildcard by adding a if condition to avoid the error message when the second commodity group
--  190425          is null or '%' in dialog copy parts to site, when there are no data defined in commodity groups.
--  170512  LEPESE  STRSC-8414, Added method Exist_With_Wildcard.
--  140320  MeAblk  Overrided methods Check_Insert___ and Check_Update___in order validate the format of Min Periods. 
--  120525  JeLise  Made description private.
--  120504  Matkse  Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120504          in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120504          was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  120123  MaEelk  Added view comments to prime_commodity and second_comodity.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  070519  WaJalk  Made the column 'commodity_code' uppercase.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060117  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  001127  PEADSE  Change COMMENT ON COLUMN from Setup Cost to Ordering Cost
--  000925  JOHESE  Added undefines.
--  000414  NISOSE  Added General_SYS.Init_Method in Get_Control_Type_Value_Desc.
--  000323  LEPE    Changed default value for min_periods to 3 in Prepare_Insert___.
--  000321  ANHO    Changed carry_rate from NUMBER(3) to NUMBER.
--  990531  ROOD    Added pseudo-columns prime_commodity and second_commodity in view.
--  990512  ROOD    Added item value in method exist.
--  990506  DAZA    General performance improvements. Added NOCHECK to LOV_COMM2.
--  990422  SHVE    General performance improvements.
--  990409  SHVE    Upgraded to performance optimized template.
--  981202  SHVE    Removed the columns percent_addition and percent_burden.
--  980527  JOHW    Removed uppercase on COMMENT ON COLUMN &VIEW..description,
--                  COMMENT ON COLUMN &LOV_COMM1..description, COMMENT ON COLUMN &LOV_COMM2..description
--  980422  FRDI    SID 3589 - Created seperate LOVs for the Commodity groups.
--  980209  JOHO    Format on amount columns, Added get_currency_rounding in
--                  Insert and update in Commodity_group_Tab.
--  971120  GOPE    Upgrade to fnd 2.0
--  970605  PELA    Added default value 0 for percent_addition and percent_burden in Prepare_Insert___.
--  970508  FRMA    Added Get_Control_Type_Value_Desc.
--  970312  CHAN    Changed table name: Commodity_group_tab instead of
--                  commodity_codes.
--  970219  JOKE    Uses column rowversion as objversion (timestamp).
--  970129  MAOR    Added default values in prepare_insert___.
--  961212  MAOR    Changed to new template.
--  961114  MAOR    Changed order of part_no and contract in call to
--                  Inventory_Part_API.Get_Prime_Commodity.
--  961104  MAOR    Added rtrim, rpad around objversion.
--  961028  MAOR    Modified file to Rational Rose Model-standard.
--  960902  HARH    Added PROCEDURE Get_Acquisit.
--  960725  JOKE    Added PROCEDURE Get_Description.
--  960701  HARH    Added function Get_Com_Min_Periods.
--  960306  JICE    Renamed from InvCommodityCodes
--  960222  LEPE    Bug 96-0030. Added reference to ServiceRate LU on column
--                  service_rate in order to get LOV functionality i the client.
--                  Also added Exist checks against service_rate_api for
--                  validation when inserting or updating service_rate.
--  951012  SHR     Base Table to Logical Unit Generator 1.
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
   Client_SYS.Add_To_Attr('MIN_PERIODS',3, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT commodity_group_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   IF ((newrec_.min_periods <= 0) OR (newrec_.min_periods != ROUND(newrec_.min_periods))) THEN
      Error_SYS.Record_General(lu_name_, 'MINPERIODSFORMAT: Min periods must be a positive integer.');       
   END IF;   
END Check_Insert___; 


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     commodity_group_tab%ROWTYPE,
   newrec_ IN OUT commodity_group_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_); 
   IF (newrec_.min_periods != oldrec_.min_periods) THEN
      IF ((newrec_.min_periods <= 0) OR (newrec_.min_periods != ROUND(newrec_.min_periods))) THEN
         Error_SYS.Record_General(lu_name_, 'MINPERIODSFORMAT: Min periods must be a positive integer.');       
      END IF; 
   END IF;   
END Check_Update___;   

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   commodity_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ commodity_group_tab.description%TYPE;
BEGIN
   IF (commodity_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('INVENT', 'CommodityGroup',
              commodity_code), description), 1, 35)
      INTO  temp_
      FROM  commodity_group_tab
      WHERE commodity_code = commodity_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(commodity_code_, 'Get_Description');
END Get_Description;


PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;


PROCEDURE Exist_With_Wildcard (
   commodity_code_    IN VARCHAR2 )
IS
   dummy_ NUMBER;
   exist_ BOOLEAN;

   CURSOR exist_control IS
      SELECT 1
        FROM commodity_group_tab
       WHERE commodity_code LIKE NVL(commodity_code_,'%');
BEGIN
   IF (NVL(commodity_code_,'%') != '%') THEN
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      exist_ := exist_control%FOUND;
      CLOSE exist_control;

      IF (NOT exist_) THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'WILDNOTEXIST: Search criteria :P1 does not match any of the commodity groups.', commodity_code_);
      END IF;
   END IF;
END Exist_With_Wildcard;

