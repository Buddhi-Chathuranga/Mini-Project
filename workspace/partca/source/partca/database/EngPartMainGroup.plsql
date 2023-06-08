-----------------------------------------------------------------------------
--
--  Logical unit: EngPartMainGroup
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130531  NipKlk  Bug 104571, Modified the length in SUBSTR to 200 for desctiption in VIEW and Get_Description() method. 
--  130408  NipKlk  Bug 104571, Modified the column comments of the view ENG_PART_MAIN_GROUP to increase the lenghts of the 
--  130408          part_main_group and description to 20 and 200 respectively.
--  120504  JeLise  Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120504          in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120504          was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  060727  ThGulk  Added &OBJID instead of rowif in Procedure Insert___
--  011006  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  031204  LaBolk  Added CLOSE getrec in Get_Object_By_Id___.
--  -----------------------------12.3.0-------------------------
--  000925  JOHESE  Added undefines.
--  990414  FRDI  Upgraded to performance optimized template.
--  990201  ToBe  Moved to PARTCA module, modified Get_Description to default.
--                Modified rowversion to default
--  970218  frtv  Upgraded.
--  960910  AnSo  Added Get_Description.
--  960904  RoHi  Changed description to unformatted
--  960620  AnSo  Renamed article to eng_part, article_no to part_no and
--                converted to the new foundation 121a template.
--  960305  AnSo  Added sort on view.
--  960205  AnSo  Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   part_main_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ eng_part_main_group_tab.description%TYPE;
BEGIN
   IF (part_main_group_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      part_main_group_), 1, 200);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
   INTO   temp_
   FROM   eng_part_main_group_tab
   WHERE  part_main_group = part_main_group_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(part_main_group_, 'Get_Description');
END Get_Description;


