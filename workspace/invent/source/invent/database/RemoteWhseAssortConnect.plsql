-----------------------------------------------------------------------------
--
--  Logical unit: RemoteWhseAssortConnect
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131003  Matkse  Added method Copy__.
--  130927  Matkse  Added Lock_By_Keys_Wait.
--  130429  DaZase  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT remote_whse_assort_connect_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);

   IF (Warehouse_API.Get_Remote_Warehouse_Db(newrec_.contract, newrec_.warehouse_id) = Fnd_Boolean_API.DB_FALSE) THEN
      Error_SYS.Record_General(lu_name_, 'NOTREMOTEWAREHOUSE: Warehouse :P1 on Site :P2 is not a Remote Warehouse.', newrec_.warehouse_id, newrec_.contract);
   END IF;

   IF (Remote_Whse_Assortment_API.Get_Valid_For_All_Sites_Db(newrec_.assortment_id) = Fnd_Boolean_API.DB_FALSE) THEN
      IF (NOT Remote_Whse_Assort_Site_API.Check_Exist(newrec_.assortment_id, newrec_.contract)) THEN
         Error_SYS.Record_General(lu_name_, 'NOTREMOTEWHSESITE: Site :P1 is not valid for Assortment :P2.', newrec_.contract, newrec_.assortment_id);
      END IF;      
   ELSE  -- valid for all sites
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy__ (
   contract_        IN VARCHAR2,
   warehouse_id_    IN VARCHAR2,
   assortment_id_   IN VARCHAR2,
   to_contract_     IN VARCHAR2,
   to_warehouse_id_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   objid_      REMOTE_WHSE_ASSORT_CONNECT.objid%TYPE;
   objversion_ REMOTE_WHSE_ASSORT_CONNECT.objversion%TYPE;
   oldrec_     REMOTE_WHSE_ASSORT_CONNECT_TAB%ROWTYPE;
   newrec_     REMOTE_WHSE_ASSORT_CONNECT_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN

   oldrec_ := Get_Object_By_Keys___(contract_, warehouse_id_, assortment_id_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT'     , to_contract_    , attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE_ID' , to_warehouse_id_, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_ID', assortment_id_  , attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);     
   Insert___(objid_, objversion_, newrec_, attr_);
END Copy__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   contract_      IN VARCHAR2,
   warehouse_id_  IN VARCHAR2,
   assortment_id_ IN VARCHAR2 )
IS
  attr_       VARCHAR2(32000);
  objid_      ROWID;
  objversion_ VARCHAR2(2000);
  newrec_     REMOTE_WHSE_ASSORT_CONNECT_TAB%ROWTYPE;
  indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE_ID', warehouse_id_, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_ID', assortment_id_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);    
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


@UncheckedAccess
FUNCTION Check_Exist (
   contract_      IN VARCHAR2,
   warehouse_id_  IN VARCHAR2,
   assortment_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, warehouse_id_, assortment_id_);
END Check_Exist;


@UncheckedAccess
FUNCTION Connected_Assortment_Exist (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   REMOTE_WHSE_ASSORT_CONNECT_TAB
      WHERE  contract = contract_
       AND   warehouse_id = NVL(warehouse_id_, warehouse_id);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Connected_Assortment_Exist;


@UncheckedAccess
FUNCTION Connected_Warehouse_Exist (
   assortment_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   REMOTE_WHSE_ASSORT_CONNECT_TAB
      WHERE  assortment_id = assortment_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(Fnd_Boolean_API.DB_TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(Fnd_Boolean_API.DB_FALSE);
END Connected_Warehouse_Exist;


PROCEDURE Remove_Connections_For_Site (
   contract_      IN VARCHAR2,   
   assortment_id_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_user_allowed_sites IS
      SELECT site
      FROM   user_allowed_site_pub;
   
   CURSOR get_connected_whse_for_site (contract_ IN VARCHAR2) IS
      SELECT *
      FROM   REMOTE_WHSE_ASSORT_CONNECT_TAB
      WHERE  contract = contract_
      AND    assortment_id = assortment_id_
      FOR UPDATE;

   TYPE Site_Tab IS TABLE OF get_user_allowed_sites%ROWTYPE INDEX BY PLS_INTEGER;
   site_tab_       Site_Tab;

BEGIN

   IF (contract_ IS NULL) THEN
      OPEN  get_user_allowed_sites;
      FETCH get_user_allowed_sites BULK COLLECT INTO site_tab_;
      CLOSE get_user_allowed_sites;
   ELSE
      site_tab_(1).site := contract_;
   END IF;

   IF (site_tab_.COUNT > 0) THEN
      FOR i IN site_tab_.FIRST..site_tab_.LAST LOOP
         FOR remrec_ IN get_connected_whse_for_site(site_tab_(i).site) LOOP
            Check_Delete___(remrec_);
            Get_Id_Version_By_Keys___(objid_, objversion_, site_tab_(i).site, remrec_.warehouse_id, assortment_id_);
            Delete___(objid_, remrec_);      
         END LOOP;
      END LOOP;
   END IF;

END Remove_Connections_For_Site;


PROCEDURE Optimize_Using_Putaway (
   assortment_id_  IN VARCHAR2 )
IS
   CURSOR get_connected_whse_for_assort IS
      SELECT contract, warehouse_id
      FROM   REMOTE_WHSE_ASSORT_CONNECT_TAB
      WHERE  assortment_id = assortment_id_
      AND    EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site = contract);

BEGIN

   FOR rec_ IN get_connected_whse_for_assort LOOP
      Warehouse_API.Optimize_Using_Putaway(rec_.contract, rec_.warehouse_id);
   END LOOP;

END Optimize_Using_Putaway;


PROCEDURE Lock_By_Keys_Wait (
   contract_      IN VARCHAR2,
   warehouse_id_  IN VARCHAR2,
   assortment_id_ IN VARCHAR2 )
IS
   dummy_ REMOTE_WHSE_ASSORT_CONNECT_TAB%ROWTYPE;
BEGIN
   dummy_ := Lock_By_Keys___(contract_, warehouse_id_, assortment_id_);
END Lock_By_Keys_Wait;



