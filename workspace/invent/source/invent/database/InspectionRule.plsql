-----------------------------------------------------------------------------
--
--  Logical unit: InspectionRule
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190925  DaZase  SCSPRING20-114, Added Raise_Sample_Percent_Error____() and Raise_Sample_Quantity_Error____ to solve MessageDefinitionValidation issues.
--  150617  CHINLK  MIN-653, Modified Check_Update___ and added Check_Delete___ to add validations for 'ACCEPTANCE SAMPLING".
--  140807  NWeelk  Bug 118174, Changed method name of Insert_Or_Update__ to Insert_Record__ as it now handles only insertion. 
--  120525  JeLise  Made description private.
--  120508  Matkse  Modified method Get, replaced obsolete method call
--  120507  Matkse  Added the possibility to translate data by adding a call to Basic_Data_Translation_API.
--  120507          Insert_Basic_Data_Translation in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507          was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  080116  MaEelk  Bug 70539, Removed the restriction for deleting inspection codes A, B and C 
--  080116          from Check_Delete___
--  071029  NuVelk  Bug 68058, Change the cursor syntax to use table definitions.
--  071024  NuVelk  Bug 68058, Replaced the private method Insert_Lu_Data_Rec__ with
--                  Insert_Or_Update__ to make sure the proper use of business logic.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060117  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  040517  HeWelk  Added new method Get_Inspection_Type_Db.
--  040429  HeWelk  Modify Unpack_Check_Insert___ ,Unpack_Check_Update___
--                  which restrict  0 < Inspection Percentage <=100  and
--                  Inspection Quantity >0.
--  040428  HeWelk  Move logical unit InspectionRule from Purch to Invent.
--  --------------------------EDGE PKG GRP 5-----------------------------------------
--  040217  IsAnlk  Removed substrb from views and from the code.
--  ---------------------------------EDGE PKG GRP 3--------------------------
--  040209  IsAnlk Removed General_SYS.Init_Method calls from Implentation methods.
--  ------------------------13.3.0 EDGE PKG GRP 2-----------------------------------
--  030926  ThGulk  Changed substr to substrb, instr to instrb, length to lengthb.
--  020123  JOHESE  IID 21001, Component Translation support. Insert_Lu_Data_Rec__
--  000324  IsWi  Clean up the commentd code.
--  000321  IsWi  Added the General_SYS.Init_Method to the PROCEDURES.
--  990616  OsAm  Modified the Function Get_Object_By_Id__.
--  990614  KaWi  Replaced a comma by 'or' in Error_Sys.Record_General
--  990513  DuDs  Changed simple letter at the beginning of words to capitals inside prompts
--  990428  Reza  Yoshimura - Performance Enhancements.
--  990420  Reza  Upgraded to Foundation1 Template Version 2.2.1.
--  980727  BjSa  Changed inspection_type to not updateable. Added checks on remove.
--  980626  SHVE  Added column inspection_type
--  980527  JOHW  Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  971120  JICE  Upgraded to Foundation1 2.0.0
--  970507  PHDE  Added PROCEDURE Get_Control_Type_Value_Desc.
--  970320  JRM   Changed references to table INSPECTION_SAMPLE to
--                INSPECTION_RULE_TAB
--  970227  VAPH  New template and changed object version
--  961210  SHVE  New template.
--  961108  SHVE  Modified file to rational rose model and workbench standards.
--  961008  SHVE  Added validation in unpack_check_update for sample percent.
--  960308  SHVE  Changed LU Name PurInspectionSample.
--  951012  SHR   Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Sample_Percent_Error____ 
IS
BEGIN   
   Error_SYS.Record_General('InspectionRule', 'SAMPLE_PERCENT: Inspection Percentage must be between 0 and 100.');
END Raise_Sample_Percent_Error____;   

PROCEDURE Raise_Sample_Quantity_Error____
IS
BEGIN   
   Error_SYS.Record_General('InspectionRule', 'SAMPLE_QUANTITY: Inspection Quantity must be greater than 0.');
END Raise_Sample_Quantity_Error____;   

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inspection_rule_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   IF (newrec_.inspection_type = 'PERCENT') AND
      (NOT(newrec_.sample_percent>0) OR newrec_.sample_percent > 100 OR newrec_.sample_percent IS NULL)THEN
      Raise_Sample_Percent_Error____;
   END IF;
   IF (newrec_.inspection_type = 'QUANTITY') AND
      (NOT(newrec_.sample_percent > 0) OR newrec_.sample_percent IS NULL )THEN
      Raise_Sample_Quantity_Error____;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     inspection_rule_tab%ROWTYPE,
   newrec_ IN OUT inspection_rule_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.inspection_type = 'PERCENT') AND
      (NOT(newrec_.sample_percent>0) OR newrec_.sample_percent > 100 OR newrec_.sample_percent IS NULL )THEN
      Raise_Sample_Percent_Error____;
   END IF;
   IF (newrec_.inspection_type = 'QUANTITY') AND
      (NOT(newrec_.sample_percent > 0) OR newrec_.sample_percent IS NULL )THEN
      Raise_Sample_Quantity_Error____;
   END IF;
   IF (newrec_.inspection_code = 'ACCEPTANCE SAMPLING' AND (oldrec_.inspection_type != newrec_.inspection_type OR oldrec_.sample_percent != newrec_.sample_percent)) THEN
      Error_SYS.Record_General('InspectionRule', 'ACCEPT_SAMP_EDIT_NOT_ALLOWED: This inspection code is system-generated. You can only edit the description and its translations.');
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;
   
@Override
PROCEDURE Check_Delete___ (
   remrec_ IN inspection_rule_tab%ROWTYPE )
IS
BEGIN
   IF (remrec_.inspection_code = 'ACCEPTANCE SAMPLING')THEN
      Error_SYS.Record_General('InspectionRule', 'ACCEPT_SAMP_REM_NOT_ALLOWED: This inspection code is system-generated and cannot be removed.');
   END IF;
   super(remrec_);
END Check_Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Record__
--   Handles component translations
PROCEDURE Insert_Record__ (
   rec_ IN INSPECTION_RULE_TAB%ROWTYPE )
IS
   dummy_        VARCHAR2(1);
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(32000);
   newrec_       INSPECTION_RULE_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
   
   CURSOR Exist IS
      SELECT 'X'
      FROM INSPECTION_RULE_TAB
      WHERE inspection_code =  rec_.inspection_code;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
      Client_SYS.Add_To_Attr('INSPECTION_CODE', rec_.inspection_code, attr_);
      Client_SYS.Add_To_Attr('SAMPLE_PERCENT', rec_.sample_percent, attr_);
      Client_SYS.Add_To_Attr('INSPECTION_TYPE_DB', rec_.inspection_type, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);   
      
      -- Insert Data into Basic Data Translations tab
      Basic_Data_Translation_API.Insert_Prog_Translation('INVENT',
                                                         'InspectionRule',
                                                         newrec_.inspection_code,
                                                         newrec_.description);         
   END IF;
   CLOSE Exist;
END Insert_Record__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Control_Type_Value_Desc
--   Replaces Mpccom.Mpc4Am.Get_Description which was removed for 10.3.
PROCEDURE Get_Control_Type_Value_Desc (
   desc_    IN OUT VARCHAR2,
   company_ IN     VARCHAR2,
   value_   IN     VARCHAR2 )
IS
BEGIN
   desc_ := NULL;
   desc_ := Get_Description (value_);
END Get_Control_Type_Value_Desc;

@UncheckedAccess
FUNCTION Get_Description (
   inspection_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inspection_rule_tab.description%TYPE;
BEGIN
   IF (inspection_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      inspection_code_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  inspection_rule_tab
      WHERE inspection_code = inspection_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(inspection_code_, 'Get_Description');
END Get_Description;




