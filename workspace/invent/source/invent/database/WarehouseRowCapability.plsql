-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseRowCapability
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210218  SBalLK  Issue SC2020R1-11830, Modified methods with Client_SYS.Add/Set_To_Attr() by removing attr_ functionality to optimize the performance.
--  140509  JeLise  PBSC-9124, Added check on newrec_.removed in Check_Insert___, so that removed 
--  140509          is set to FALSE when not already set.
--  120307  LEPESE  Added method Copy__.
--  111121  JeLise  Added methods Check_And_Delete___ and Clear_Storage_Capabilities__.
--  110719  MaEelk  Added user allowed site filter to WAREHOUSE_ROW_CAPABILITY.
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
   remrec_ IN warehouse_row_capability_tab%ROWTYPE )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   
   Get_Id_Version_By_Keys___(objid_, 
                             objversion_,
                             remrec_.contract,
                             remrec_.warehouse_id,
                             remrec_.bay_id,
                             remrec_.row_id,
                             remrec_.storage_capability_id);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Check_And_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warehouse_row_capability_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(2000);
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
   bay_id_                IN VARCHAR2,
   row_id_                IN VARCHAR2,
   storage_capability_id_ IN VARCHAR2 )
IS
   newrec_     warehouse_row_capability_tab%ROWTYPE;
BEGIN
   IF (Check_Exist___(contract_, warehouse_id_, bay_id_, row_id_, storage_capability_id_)) THEN
      Error_SYS.Record_General(lu_name_, 'WHROWCAPLINEEXIST: You cannot remove this capability because it already exists on this level, please remove the capability on this level first');
   END IF;

   newrec_.contract              := contract_;
   newrec_.warehouse_id          := warehouse_id_;
   newrec_.bay_id                := bay_id_;
   newrec_.row_id                := row_id_;
   newrec_.storage_capability_id := storage_capability_id_;
   newrec_.removed               := Fnd_Boolean_API.DB_TRUE;
   New___(newrec_);
END Create_Removed_Line__;


PROCEDURE Clear_Storage_Capabilities__ (
   contract_            IN VARCHAR2,
   warehouse_id_        IN VARCHAR2,
   bay_id_              IN VARCHAR2,
   row_id_              IN VARCHAR2,
   all_capabilities_db_ IN BOOLEAN,
   capability_tab_      IN Storage_Capability_API.Capability_Tab )
IS
   remrec_ warehouse_row_capability_tab%ROWTYPE;
   
   CURSOR get_all_capabilities IS
      SELECT *
      FROM warehouse_row_capability_tab
      WHERE contract     = contract_
      AND   warehouse_id = warehouse_id_
      AND   bay_id       = bay_id_
      AND   row_id       = row_id_
      FOR UPDATE;
BEGIN
   
   IF (all_capabilities_db_) THEN
      FOR rec_ IN get_all_capabilities LOOP 
         Check_And_Delete___(rec_);
      END LOOP;
   ELSE
      IF (capability_tab_.COUNT > 0) THEN
         FOR i IN capability_tab_.FIRST..capability_tab_.LAST LOOP
            IF Check_Exist___(contract_, warehouse_id_, bay_id_, row_id_, capability_tab_(i).storage_capability_id) THEN
               remrec_ := Lock_By_Keys___(contract_, warehouse_id_, bay_id_, row_id_, capability_tab_(i).storage_capability_id);
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
   bay_id_                IN VARCHAR2,
   row_id_                IN VARCHAR2,
   storage_capability_id_ IN VARCHAR2,
   to_contract_           IN VARCHAR2,
   to_warehouse_id_       IN VARCHAR2,
   to_bay_id_             IN VARCHAR2,
   to_row_id_             IN VARCHAR2 )
IS
   oldrec_     warehouse_row_capability_tab%ROWTYPE;
   newrec_     warehouse_row_capability_tab%ROWTYPE;
BEGIN
   oldrec_ := Get_Object_By_Keys___(contract_, warehouse_id_, bay_id_, row_id_, storage_capability_id_);

   newrec_.contract              := to_contract_;
   newrec_.warehouse_id          := to_warehouse_id_;
   newrec_.bay_id                := to_bay_id_;
   newrec_.row_id                := to_row_id_;
   newrec_.storage_capability_id := oldrec_.storage_capability_id;
   newrec_.removed               := oldrec_.removed;
   New___(newrec_);
END Copy__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


