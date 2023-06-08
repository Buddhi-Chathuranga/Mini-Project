-----------------------------------------------------------------------------
--
--  Logical unit: RemoteWhseAssortSite
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130424  DaZase  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN REMOTE_WHSE_ASSORT_SITE_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);

   Remote_Whse_Assort_Connect_API.Remove_Connections_For_Site(remrec_.contract, remrec_.assortment_id);

END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT remote_whse_assort_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(newrec_, indrec_, attr_);


   Remote_Whse_Assortment_API.Check_Inventory_Part(assortment_id_          => newrec_.assortment_id, 
                                                   contract_               => newrec_.contract,
                                                   part_no_                => NULL,
                                                   valid_for_all_sites_db_ => NULL);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract); 

END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   assortment_id_ IN VARCHAR2,
   contract_      IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(assortment_id_, contract_);
END;


@UncheckedAccess
FUNCTION Is_Connected_To_A_Site (
   assortment_id_ IN VARCHAR2 ) RETURN VARCHAR2  
IS
   exist_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   dummy_ NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   REMOTE_WHSE_ASSORT_SITE_TAB
      WHERE  assortment_id = assortment_id_;
BEGIN
   -- IF valid for all sites is checked or any site for this assortment exist in the table we return TRUE
   IF (Remote_Whse_Assortment_API.Get_Valid_For_All_Sites_Db(assortment_id_) = Fnd_Boolean_API.DB_TRUE) THEN
      exist_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      IF (exist_control%FOUND) THEN
         exist_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
      CLOSE exist_control;      
   END IF;
   RETURN exist_;
END Is_Connected_To_A_Site;


PROCEDURE Connect_To_All_Remote_Whses (
   assortment_id_ IN VARCHAR2 )
IS
   CURSOR get_user_allowed_sites IS
      SELECT site
      FROM   user_allowed_site_pub;

   CURSOR get_sites IS
      SELECT contract
      FROM   REMOTE_WHSE_ASSORT_SITE_TAB
      WHERE  assortment_id = assortment_id_;
BEGIN
   IF (Remote_Whse_Assortment_API.Get_Valid_For_All_Sites_Db(assortment_id_) = Fnd_Boolean_API.DB_TRUE) THEN
      FOR sites_rec_ IN get_user_allowed_sites LOOP
         Warehouse_API.Connect_Assortment_To_Remotes(sites_rec_.site, assortment_id_);
      END LOOP;
   ELSE
      FOR sites_rec_ IN get_sites LOOP
         Warehouse_API.Connect_Assortment_To_Remotes(sites_rec_.contract, assortment_id_);
      END LOOP;
   END IF;
   
END Connect_To_All_Remote_Whses;



