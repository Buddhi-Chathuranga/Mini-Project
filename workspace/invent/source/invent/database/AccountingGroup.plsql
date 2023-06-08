-----------------------------------------------------------------------------
--
--  Logical unit: AccountingGroup
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120504  Matkse  Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120504          in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120504          was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060117  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  000925  JOHESE  Added undefines.
--  000414  NISOSE  Added General_SYS.Init_Method in Get_Control_Type_Value_Desc.
--  990419  ANHO    General performance improvements.
--  990408  ANHO    Upgraded to performance optimized template.
--  971120  GOPE    Upgrade to fnd 2.0
--  970508  FRMA    Added Get_Control_Type_Value_Desc.
--  970313  CHAN    Changed table name: mpc_accounting_groups is replaced by
--                  accounting_group_tab
--  970219  JOKE    Uses column rowversion as objversion (timestamp).
--  961212  LEPE    Modified for new template standard.
--  961101  MAOR    Added rtrim, rpad around objversion.
--  961024  MAOR    Modified file to Rational Rose Model-standard.
--  960916  JICE    Added function Get_Description.
--  960307  JICE    Renamed from InvAccountingGroups
--  951029  xxxx    Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   accounting_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ accounting_group_tab.description%TYPE;
BEGIN
   IF (accounting_group_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      accounting_group_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  accounting_group_tab
      WHERE accounting_group = accounting_group_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(accounting_group_, 'Get_Description');
END Get_Description;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;



