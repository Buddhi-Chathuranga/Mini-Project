-----------------------------------------------------------------------------
--
--  Logical unit: RemoteWhseAssortment
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140211  Matkse  Added method Check_Unit_Meas___. Modified Check_Inventory_Part to call Check_Unit_Meas___ when neccessary.
--  131017  JeLise  Added attribute order_processing_type.
--  130424  DaZase  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Priority___ (
   priority_   IN NUMBER ) 
IS
BEGIN
   IF (priority_ <= 0) THEN
      Error_SYS.Record_General(lu_name_,'ONLYPOSITIVEPRIORITY: Zero and negative priority values are not allowed.');
   END IF;
   IF (TRUNC(priority_) != priority_) THEN
      Error_SYS.Record_General(lu_name_,'NODECIMALSINPRIORITY: Decimal values for priority are not allowed.');
   END IF;
END Check_Priority___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('VALID_FOR_ALL_SITES_DB', Fnd_Boolean_API.db_false, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     REMOTE_WHSE_ASSORTMENT_TAB%ROWTYPE,
   newrec_     IN OUT REMOTE_WHSE_ASSORTMENT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   remove_all_connected_lines_ VARCHAR2(1);
BEGIN
   remove_all_connected_lines_ := Client_SYS.Get_Item_Value('REMOVE_CONNECTED_WHSE_LINES', attr_);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   IF (newrec_.valid_for_all_sites != oldrec_.valid_for_all_sites AND
       newrec_.valid_for_all_sites = Fnd_Boolean_API.DB_FALSE AND 
       remove_all_connected_lines_ = 'Y') THEN
      Remote_Whse_Assort_Connect_API.Remove_Connections_For_Site(contract_      => NULL, 
                                                                 assortment_id_ => newrec_.assortment_id);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT remote_whse_assortment_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.valid_for_all_sites := Fnd_Boolean_API.db_false;
   super(newrec_, indrec_, attr_);

   Error_SYS.Check_Valid_Key_String('ASSORTMENT_ID', newrec_.assortment_id);
   
   Check_Priority___(newrec_.priority);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     remote_whse_assortment_tab%ROWTYPE,
   newrec_ IN OUT remote_whse_assortment_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);


   IF (newrec_.valid_for_all_sites != oldrec_.valid_for_all_sites) THEN
      Check_Inventory_Part(assortment_id_          => newrec_.assortment_id, 
                           contract_               => NULL,
                           part_no_                => NULL,
                           valid_for_all_sites_db_ => newrec_.valid_for_all_sites);
   END IF;
   Check_Priority___(newrec_.priority);
END Check_Update___;

PROCEDURE Check_Unit_Meas___(
   contract_ VARCHAR2, 
   part_no_  VARCHAR2 ) 
IS
   invent_part_uom_      VARCHAR2(10);
   invent_part_base_uom_ VARCHAR2(10);
   part_uom_             VARCHAR2(10);
   part_base_uom_        VARCHAR2(10);
BEGIN
    invent_part_uom_ := Inventory_Part_API.Get_Unit_Meas(contract_, part_no_);
    part_uom_        := Part_Catalog_API.Get_Unit_Code(part_no_);
         
    invent_part_base_uom_ := Iso_Unit_API.Get_Base_Unit(invent_part_uom_);
    part_base_uom_        := Iso_Unit_API.Get_Base_Unit(part_uom_);
        
   IF (invent_part_base_uom_ != part_base_uom_) THEN
       Error_SYS.Record_General(lu_name_,'REMOTEASSORTBASEUNITDIFF: Part :P1 with base U/M :P2 cannot be converted to the base U/M of the inventory part on site :P3.', part_no_, part_base_uom_, contract_);
   END IF;
END Check_Unit_Meas___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
FUNCTION Get_Order_Processing_Type_Desc (
   assortment_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_processing_type_      REMOTE_WHSE_ASSORTMENT_TAB.order_processing_type%TYPE;
   order_processing_type_desc_ VARCHAR2(200);
BEGIN
   order_processing_type_ := Get_Order_Processing_Type(assortment_id_);
   $IF (Component_Purch_SYS.INSTALLED) $THEN 
      order_processing_type_desc_ := Order_Proc_Type_API.Get_Description(order_processing_type_);
   $ELSE
      order_processing_type_desc_ := NULL;
   $END
   
   RETURN order_processing_type_desc_;
END Get_Order_Processing_Type_Desc;


PROCEDURE Check_Inventory_Part (
   assortment_id_          IN VARCHAR2, 
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   valid_for_all_sites_db_ IN VARCHAR2 DEFAULT NULL)
IS
   local_valid_for_all_sites_db_ REMOTE_WHSE_ASSORTMENT_TAB.valid_for_all_sites%TYPE;
   CURSOR get_parts IS
      SELECT part_no
      FROM   REMOTE_WHSE_ASSORT_PART_TAB
      WHERE  assortment_id = assortment_id_;

   CURSOR get_all_sites IS
      SELECT contract
      FROM   SITE_INVENT_INFO_TAB;

   CURSOR get_sites IS
      SELECT contract
      FROM   REMOTE_WHSE_ASSORT_SITE_TAB
      WHERE  assortment_id = assortment_id_;

   TYPE Part_Tab IS TABLE OF get_parts%ROWTYPE INDEX BY PLS_INTEGER;
   part_tab_       Part_Tab;
   TYPE Site_Tab IS TABLE OF get_all_sites%ROWTYPE INDEX BY PLS_INTEGER;
   site_tab_       Site_Tab;
   
BEGIN

   IF (contract_ IS NULL) THEN
      IF (valid_for_all_sites_db_ IS NULL) THEN
         local_valid_for_all_sites_db_ := Get_Valid_For_All_Sites_Db(assortment_id_);
      ELSE
         local_valid_for_all_sites_db_ := valid_for_all_sites_db_; 
      END IF;
      IF (local_valid_for_all_sites_db_ = Fnd_Boolean_API.DB_TRUE) THEN
         OPEN  get_all_sites;
         FETCH get_all_sites BULK COLLECT INTO site_tab_;
         CLOSE get_all_sites;
      ELSE
         OPEN  get_sites;
         FETCH get_sites BULK COLLECT INTO site_tab_;
         CLOSE get_sites;
      END IF;
   
      IF (site_tab_.COUNT > 0) THEN
         FOR i IN site_tab_.FIRST..site_tab_.LAST LOOP
            IF (Inventory_Part_API.Exists(site_tab_(i).contract, part_no_)) THEN
               Check_Unit_Meas___(site_tab_(i).contract, part_no_);
            END IF;
         END LOOP;
      END IF;
   ELSE
      site_tab_(1).contract := contract_;
   END IF;
   
   IF (part_no_ IS NULL) THEN
      OPEN  get_parts;
      FETCH get_parts BULK COLLECT INTO part_tab_;
      CLOSE get_parts;
   ELSE
      part_tab_(1).part_no := part_no_;
   END IF;

   IF (part_tab_.COUNT > 0) THEN
      FOR i IN part_tab_.FIRST..part_tab_.LAST LOOP
         IF (site_tab_.COUNT > 0) THEN
            FOR j IN site_tab_.FIRST..site_tab_.LAST LOOP
               Inventory_Part_API.Exist(site_tab_(j).contract, part_tab_(i).part_no);
               Check_Unit_Meas___(site_tab_(j).contract, part_tab_(i).part_no);
            END LOOP;
         END IF;
      END LOOP;
   END IF;
END Check_Inventory_Part;
