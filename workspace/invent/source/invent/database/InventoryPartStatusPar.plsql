-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartStatusPar
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120525  JeLise   Made description private.
--  120504  Matkse   Replaced calls to obsolete Module_Translate_Attr_Util_API with Basic_Data_Translation.Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120504           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120504           was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  120927  NiDalk   Bug 104034, Modified view INVENTORY_PART_STATUS_PAR by adding default_status. Modified Unpack_Check_Update___(),
--  120927           Update___(),  Prepare_Insert___(), Insert___(), Insert_Lu_Data_Rec__() and Check_Delete___() accordingly.
--  120927           Also added Get_Default_Status().
--  100507  KRPELK   Merge Rose Method Documentation.
--  100212  Asawlk   Bug 88330, Modified Update___() to place the call to Invalidate_Cache___ right after the UPDATE clause.
--  ------------------------------- Eagle ----------------------------------
--  091030  ShKolk   Bug 86768, Merge IPR to APP75 core.
--  060119  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060119           and added UNDEFINE according to the new template.
--  040302  GeKalk   Removed substrb from views and replaced substrb with substr where necessary
--                   for UNICODE modifications.
--  -------------------------------------- 13.3.0 ---------------------------
--  031001  ThGulk   Changed substr to substrb, instr to instrb, length to lengthb.
--  020124  DaMase   IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  000925  JOHESE   Added undefines.
--  990421  JOHW     General performance improvements.
--  990409  JOHW     Upgraded to performance optimized template.
--  990331  JAKH     Corrected spelling error 'You are now'... to 'You are not'...
--                   in Check_Delete___
--  990128  DAZA     Removed bom_flag and plan_flag and their Get methods.
--                   Added Get_xxx_Db methods for demand_flag, onhand_flag and
--                   supply_flag. Changed substr to substrb. Added a check in
--                   Check_Delete___ so part_status = 'A' can't be removed.
--                   Changed to update not allowed on the flags.
--  980526  JOHW     Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  971201  GOPE     Upgrade to fnd 2.0
--  970618  JOED     Changed public Get_.. methods. Added _db column in the view.
--                   Beautified parts of the code.
--  970313  MAGN     Changed tablename from part_status_code to inventory_part_status_par_tab.
--  970220  JOKE     Uses column rowversion as objversion (timestamp).
--  961214  AnAr     Modified file for new template standard.
--  961104  JICE     Modified for Rational Rose/Workbench.
--  960509  MAOS     Added functions Get_Supply_Flag and Check_Part_Status.
--  960308  JICE     Renamed from InvPartStatusCode
--  951012  SHR      Base Table to Logical Unit Generator 1.
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
   Client_SYS.Add_To_Attr('DEFAULT_STATUS_DB','FALSE',attr_);   
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     INVENTORY_PART_STATUS_PAR_TAB%ROWTYPE,
   newrec_     IN OUT INVENTORY_PART_STATUS_PAR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.default_status = 'TRUE') THEN
      UPDATE INVENTORY_PART_STATUS_PAR_TAB
         SET default_status = 'FALSE',
             rowversion = sysdate
       WHERE default_status = 'TRUE';
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Invalidate_Cache___;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN INVENTORY_PART_STATUS_PAR_TAB%ROWTYPE )
IS
BEGIN	
   IF (remrec_.default_status = 'TRUE') THEN
      Error_Sys.Record_General(lu_name_, 'PARTSTATA: You are not allowed to remove the default part status :P1.', remrec_.description);
   END IF;
   super(remrec_);
END Check_Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN INVENTORY_PART_STATUS_PAR_TAB%ROWTYPE)
IS
   dummy_      VARCHAR2(1);
   default_status_   VARCHAR2(5) := 'TRUE';

   CURSOR Exist IS
      SELECT 'X'
      FROM INVENTORY_PART_STATUS_PAR_TAB
      WHERE part_status = newrec_.part_status;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      IF (Get_Default_Status IS NOT NULL ) THEN
         default_status_ := 'FALSE';
      END IF;

      INSERT
         INTO INVENTORY_PART_STATUS_PAR_TAB(
         part_status,
         description,
         demand_flag,
         onhand_flag,
         supply_flag,
         default_status,
         rowstate,
         rowversion)
      VALUES (
         newrec_.part_status,
         newrec_.description,
         newrec_.demand_flag,
         newrec_.onhand_flag,
         newrec_.supply_flag,
         default_status_,
         newrec_.rowstate,
         newrec_.rowversion);
   ELSE
      UPDATE INVENTORY_PART_STATUS_PAR_TAB
         SET description = newrec_.description
         WHERE part_status = newrec_.part_status;
   END IF;
   -- Insert Data into Basic Data Translations tab
   Basic_Data_Translation_API.Insert_Prog_Translation('INVENT',
                                                      'InventoryPartStatusPar',
                                                      newrec_.part_status,
                                                      newrec_.description);
   CLOSE Exist;
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Part_Status (
   part_status_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   part_stat_ INVENTORY_PART_STATUS_PAR_TAB.part_status%TYPE;
   CURSOR check_exist IS
      SELECT part_status
      FROM   INVENTORY_PART_STATUS_PAR_TAB
      WHERE  part_status = part_status_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO part_stat_;
   IF check_exist%NOTFOUND THEN
      CLOSE check_exist;
      RETURN (NULL);
   END IF;
   CLOSE check_exist;
   RETURN part_stat_;
END Check_Part_Status;


@UncheckedAccess
FUNCTION Get_Default_Status RETURN VARCHAR2
IS
   default_status_ INVENTORY_PART_STATUS_PAR_TAB.part_status%TYPE;
   CURSOR get_default_status IS
      SELECT part_status
      FROM   INVENTORY_PART_STATUS_PAR_TAB
      WHERE  default_status = 'TRUE';
BEGIN
   OPEN get_default_status;
   FETCH get_default_status INTO default_status_;
   CLOSE get_default_status;
   RETURN default_status_;
END Get_Default_Status;


-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   part_status_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_status_par_tab.description%TYPE;
BEGIN
   IF (part_status_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      part_status_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  inventory_part_status_par_tab
      WHERE part_status = part_status_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(part_status_, 'Get_Description');
END Get_Description;


