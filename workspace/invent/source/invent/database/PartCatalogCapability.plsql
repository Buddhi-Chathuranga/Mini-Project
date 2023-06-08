-----------------------------------------------------------------------------
--
--  Logical unit: PartCatalogCapability
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  181222  NipKlk   Bug 146014 (SCZ-2365), Added indrec_.removed check when setting newrec_.removed := 'FALSE' in the Check_Insert___ method.
--  130814  JeLise   Changed from part_catalog_tab to part_catalog_invent_attrib_tab in PART_CATALOG_OPERATIVE_CAP.
--  120904  JeLise   Moved from Partca to Invent.
--  120118  ChJalk   Removed CASCADE from the view comments of storage_capability_id.
--  120117  ChJalk   Added CASCADE into the view comments of storage_capability_id.
--  110523  MaEelk   Removed the cascade option from PART_CATALOG_CAPABILITY.storage_capability_id.
--  101021  JeLise   Added Copy.
--  100820  JeLise   Created
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
   Client_SYS.Add_To_Attr('REMOVED', Fnd_Boolean_API.Decode('FALSE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT part_catalog_capability_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF ((NOT indrec_.removed) OR (newrec_.removed IS NULL)) THEN 
      newrec_.removed := 'FALSE';
   END IF;

   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_Removed_Line__ (
   part_no_               IN VARCHAR2,
   storage_capability_id_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   objid_      PART_CATALOG_CAPABILITY.objid%TYPE;
   objversion_ PART_CATALOG_CAPABILITY.objversion%TYPE;
   newrec_     PART_CATALOG_CAPABILITY_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN

   IF (Check_Exist___(part_no_, storage_capability_id_)) THEN
      Error_SYS.Record_General(lu_name_, 'CAPLINEEXIST: You cannot remove this capability because it already exists on this level, please remove the capability on this level first');
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('STORAGE_CAPABILITY_ID', storage_capability_id_, attr_);
   Client_SYS.Add_To_Attr('REMOVED_DB', 'TRUE', attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Create_Removed_Line__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Copy (
   from_part_no_ IN VARCHAR2,
   to_part_no_   IN VARCHAR2 )
IS
   newrec_     PART_CATALOG_CAPABILITY_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   objid_      PART_CATALOG_CAPABILITY.objid%TYPE;
   objversion_ PART_CATALOG_CAPABILITY.objversion%TYPE;
   attr_       VARCHAR2(32000);

   CURSOR    get_capability_lines IS
      SELECT *
        FROM PART_CATALOG_CAPABILITY_TAB
       WHERE part_no = from_part_no_;
BEGIN

   FOR capability_rec_ IN get_capability_lines LOOP
      --Initialize variables         
      Client_SYS.Clear_Attr(attr_);
      newrec_     := NULL;
      objid_      := NULL;
      objversion_ := NULL;
      
      Client_SYS.Add_To_Attr('PART_NO', to_part_no_, attr_);
      Client_SYS.Add_To_Attr('STORAGE_CAPABILITY_ID', capability_rec_.storage_capability_id, attr_);
      Client_SYS.Add_To_Attr('REMOVED_DB', capability_rec_.removed, attr_);

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
END Copy;



