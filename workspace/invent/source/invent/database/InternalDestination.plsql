-----------------------------------------------------------------------------
--
--  Logical unit: InternalDestination
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210831  SBalLK  SC21R2-2442, Replaced Client_SYS.Add_To_Attr by assigning values directly to newrec_ throughout the file.
--  120507  Matkse  Added the possibility to translate data by adding a call to Basic_Data_Translation_API.
--  120507          Insert_Basic_Data_Translation in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507          was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  120315  MaEelk  Removed the last parameter TRUE in call General_SYS.Init_Method from  non-implementation methods
--  110203  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  081031  NuVelk  Bug 75662, Modified Get_Control_type_Value_Desc to correctly fetch values.
--  081010  NuVelk  Bug 75662, Added package Internal_Destination2_API including methods
--                  Exist and Get_Control_type_Value_Desc. This is for the
--                  integration with Accounting Rules. Also added view INTERNAL_DESTINATION_LOV2.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060117  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  020301  WAJALK  Bug ID 28163 - Added a check for user allowed sites in Unpack_Check_Insert___.
--  000925  JOHESE  Added undefines.
--  000918  ANLASE  Added call to USER_ALLOWED_SITE_API.Get_Default_Site 
--                  in method prepare_insert___.
--  000718  ANLASE  Added LOV_VIEW.
--  000718  ANLASE  Created
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
   Client_SYS.Add_To_Attr('CONTRACT', User_Allowed_Site_API.Get_Default_Site, attr_);   
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT internal_destination_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   contract_       IN VARCHAR2,
   destination_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ internal_destination_tab.description%TYPE;
BEGIN
   IF (contract_ IS NULL OR destination_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      contract_||'^'||destination_id_), 1, 2000);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  internal_destination_tab
      WHERE contract = contract_
      AND   destination_id = destination_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, destination_id_, 'Get_Description');
END Get_Description;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------





