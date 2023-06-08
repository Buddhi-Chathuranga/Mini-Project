-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentTwSettings
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  090224  NIFRSE  Bug 80778, Added Equipment Tw Settings Lu with referenced IID's
--  100506  NIFRSE  Bug 90453, Added Cleanup_Tw_Settings method.
--  100519  NIFRSE  Bug 90713, Remodify the Cleanup_Tw_Settings method
--  131128  MAWILK  PBSA-1824, Hooks: refactoring and splitting. 
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     equipment_tw_settings_tab%ROWTYPE,
   newrec_ IN OUT equipment_tw_settings_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.grouping_criteria IS NULL AND newrec_.equipment_object_seq IS NOT NULL) THEN
      newrec_.grouping_criteria := 'SITE';
   ELSIF (newrec_.grouping_criteria IS NULL) THEN
      newrec_.grouping_criteria := 'DEFAULT';
   END IF;
   IF (newrec_.disp_wo_task_node IS NULL AND newrec_.disp_pm_plan_node IS NULL AND newrec_.disp_sc_node IS NULL AND
       newrec_.disp_conn_objs_node IS NULL AND newrec_.hide_empty_grup IS NULL AND newrec_.hide_objs_without_grup IS NULL ) THEN
      newrec_.disp_wo_task_node := 0;
      newrec_.disp_pm_plan_node := 0;
      newrec_.disp_sc_node := 0;
      newrec_.disp_conn_objs_node := 0;
      newrec_.hide_empty_grup := 0;
      newrec_.hide_objs_without_grup := 0;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Cleanup_Tw_Settings
IS
   CURSOR get_tw_record IS
     SELECT t.OBJID, t.OBJVERSION, t.TREE_VIEW_ID FROM EQUIPMENT_TW_SETTINGS t
       WHERE NOT EXISTS (SELECT 1
         FROM   BOEXP_TW_SETTINGS b
         WHERE  b.tree_view_id = t.tree_view_id);

   info_ VARCHAR2(500);
BEGIN
   FOR rec_ IN get_tw_record LOOP
      EQUIPMENT_TW_SETTINGS_API.REMOVE__(info_, rec_.objid, rec_.objversion, 'DO');
   END LOOP;
END Cleanup_Tw_Settings;



