-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseCapability
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140512  JeLise  PBSC-9124, Changed the check on indrec_.removed to newrec_.removed in Check_Insert___.
--  120306  LEPESE  Added method Copy__.
--  111121  JeLise  Added methods Check_And_Delete___ and Clear_Storage_Capabilities__.
--  110719  MaEelk  Added user allowed site filter to WAREHOUSE_CAPABILITY.
--  100812  DaZase  Created
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


PROCEDURE Check_And_Delete___ (
   remrec_ IN WAREHOUSE_CAPABILITY_TAB%ROWTYPE )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   
   Get_Id_Version_By_Keys___(objid_, 
                             objversion_,
                             remrec_.contract,
                             remrec_.warehouse_id,
                             remrec_.storage_capability_id);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Check_And_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warehouse_capability_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.removed IS NULL)THEN  
      newrec_.removed := Fnd_Boolean_API.DB_FALSE; 
   END IF;   
   
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_Removed_Line__ (
   contract_              IN VARCHAR2,
   warehouse_id_          IN VARCHAR2,
   storage_capability_id_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   objid_      WAREHOUSE_CAPABILITY.objid%TYPE;
   objversion_ WAREHOUSE_CAPABILITY.objversion%TYPE;
   newrec_     WAREHOUSE_CAPABILITY_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN

   IF (Check_Exist___(contract_, warehouse_id_, storage_capability_id_)) THEN
      Error_SYS.Record_General(lu_name_, 'WHCAPLINEEXIST: You cannot remove this capability because it already exists on this level, please remove the capability on this level first');
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE_ID', warehouse_id_, attr_);
   Client_SYS.Add_To_Attr('STORAGE_CAPABILITY_ID', storage_capability_id_, attr_);
   Client_SYS.Add_To_Attr('REMOVED_DB', 'TRUE', attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Create_Removed_Line__;


PROCEDURE Clear_Storage_Capabilities__ (
   contract_            IN VARCHAR2,
   warehouse_id_        IN VARCHAR2,
   all_capabilities_db_ IN BOOLEAN,
   capability_tab_      IN Storage_Capability_API.Capability_Tab )
IS
   remrec_ WAREHOUSE_CAPABILITY_TAB%ROWTYPE;
   
   CURSOR get_all_capabilities IS
      SELECT *
      FROM WAREHOUSE_CAPABILITY_TAB
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_
      FOR UPDATE;
BEGIN
   
   IF (all_capabilities_db_) THEN
      FOR rec_ IN get_all_capabilities LOOP 
         Check_And_Delete___(rec_);
      END LOOP;
   ELSE
      IF (capability_tab_.COUNT > 0) THEN
         FOR i IN capability_tab_.FIRST..capability_tab_.LAST LOOP
            IF Check_Exist___(contract_, warehouse_id_, capability_tab_(i).storage_capability_id) THEN
               remrec_ := Lock_By_Keys___(contract_, warehouse_id_, capability_tab_(i).storage_capability_id);
               IF remrec_.removed = Fnd_Boolean_API.db_false THEN
                  Check_And_Delete___(remrec_);
               END IF;
            END IF;
         END LOOP;
      END IF;
   END IF;
END Clear_Storage_Capabilities__;


PROCEDURE Copy__ (
   contract_              IN VARCHAR2,
   warehouse_id_          IN VARCHAR2,
   storage_capability_id_ IN VARCHAR2,
   to_contract_           IN VARCHAR2,
   to_warehouse_id_       IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   objid_      WAREHOUSE_CAPABILITY.objid%TYPE;
   objversion_ WAREHOUSE_CAPABILITY.objversion%TYPE;
   oldrec_     WAREHOUSE_CAPABILITY_TAB%ROWTYPE;
   newrec_     WAREHOUSE_CAPABILITY_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN

   oldrec_ := Get_Object_By_Keys___(contract_, warehouse_id_, storage_capability_id_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT'             , to_contract_          , attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE_ID'         , to_warehouse_id_      , attr_);
   Client_SYS.Add_To_Attr('STORAGE_CAPABILITY_ID', storage_capability_id_, attr_);
   Client_SYS.Add_To_Attr('REMOVED_DB'           , oldrec_.removed       , attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Copy__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


