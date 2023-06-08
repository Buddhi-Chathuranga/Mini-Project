-----------------------------------------------------------------------------
--
--  Logical unit: RotablePartPool
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130805  MaRalk   TIBE-902, Removed following global LU constants, used conditional compilation instead and  
--  130805           modified relevant methods accordingly. inst_CustOrdCustomer_ - Unpack_Check_Insert___ , 
--  130805           Unpack_Check_Update___. inst_RotablePoolFaObject_ - Validate_Rotable_Part_Pool___.
--  130805           Removed unused global LU constant inst_FixassConnectionV890_.
--  130515  IsSalk   Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  110919  HaPulk   Changed ConnectionPackage method calls to Conditional Compilation
--  110220  LEPESE   Changed error message NOTSERIALTRACKING. Added method Part_Exists.
--  100505  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  070906  NiDalk   Modified Validate_Rotable_Part_Pool___ to check for target quantity greater than zero.
--  060418  NaLrlk   Enlarge Identity - Changed view comments of owning_customer_no.
--  ------------------------- 13.4.0 -----------------------------------------
--  060124  NiDalk   Added Assert safe annotation. 
--  060119  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060119           and added UNDEFINE according to the new template.
--  050921  NiDalk   Removed unused variables.
--  040302  GeKalk   Removed substrb from views for UNICODE modifications.
--  --------------------------------- 13.3.0 --------------------------------
--  031017  MaGulk   Bug 108262, Changed error message constants in Validate_Rotable_Pool part availability control messages
--  030917  GEBOSE   Bug 99755, Changed error message LOWTARGETQTYOBJ in Unpack_Check_Update___
--  030911  MiKulk   Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  030805  DAYJLK   Added function Get_Rotable_Pool_Asset_Type_Db.
--  030704  GEBOSE   Changed rotables checks in Unpack_Check_Update___ to execute
--  030704           dynamic calls against Fixass via intermediary LU Fixass_Connection_V890_API
--  030704  GEBOSE   Added constant inst_FixassConnectionV890_ for checks in dynamic calls against Fixass.
--  030522  MaGulk   Added validations for Availability Control to Validate_Rotable_Part_Pool___
--  030521  MaGulk   Added Validate_Rotable_Part_Pool___ for common validations
--  030519  MaGulk   Modified Unpack_Check_Update___ validations for Fixed Asset pool
--  030513  MaGulk   Modified Unpack_Check_Insert___ validations for Fixed Asset pool
--  030506  JOHESE   Changed attribute rotable_part_pool_id to uppercase
--  030423  MaGulk   Rearranged columns
--  040414  MaGulk   Modified Unpack_Check_Update___, Unpack_Check_Insert___ & Prepare_Insert___
--  030410  MaGulk   Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Validate_Rotable_Part_Pool___
--   This will make all validations that need to have for a rotable part.
PROCEDURE Validate_Rotable_Part_Pool___ (
   newrec_ IN ROTABLE_PART_POOL_TAB%ROWTYPE )
IS
   partrec_  Part_Catalog_API.Public_Rec;
   pacrec_   Part_Availability_Control_API.Public_Rec;
BEGIN

   -- Read part information for validating part no
   partrec_ := Part_Catalog_API.Get(newrec_.part_no);

   -- Check for serial handled part
   IF partrec_.serial_tracking_code = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING THEN
      Error_SYS.Record_General('RotablePartPool', 'NOTSERIALTRACKING: Only parts that are Serial Tracked In Inventory can be used for Rotable pools.');
   END IF;

   -- Check for not position part
   IF partrec_.position_part = 'POSITION PART' THEN
      Error_SYS.Record_General('RotablePartPool', 'POSITIONPART: Position Parts can not be used for Rotable pools.');
   END IF;

   -- Validations specific to Fixed Asset pool
   IF newrec_.rotable_pool_asset_type = 'FIXED ASSET' THEN
      -- Check if FIXASS is installed
      $IF NOT Component_Fixass_SYS.INSTALLED $THEN
         Error_SYS.Record_General('RotablePartPool', 'FANOTINSTALLED: Rotable Pool FA Object in Fixed Assets is not installed'); 
      $END
      -- Check ownership of FA pool
      IF newrec_.part_ownership != 'COMPANY OWNED' THEN
         Error_SYS.Record_General('RotablePartPool', 'FAPOOLOWNERSHIP: Fixed Asset pool can only be Company Owned');
      END IF;
   END IF;

   -- check for ownership and owner
   IF newrec_.part_ownership = 'COMPANY OWNED' THEN
      IF NOT newrec_.owning_customer_no IS NULL THEN
         Error_SYS.Record_General('RotablePartPool', 'OWNERFORCOMPANY: Company Owned parts can not have external owner');
      END IF;
   ELSIF newrec_.part_ownership = 'CUSTOMER OWNED' THEN
      IF newrec_.owning_customer_no IS NULL THEN
         Error_SYS.Record_General('RotablePartPool', 'NOOWNERFORCUSTOMER: Customer must be defined for Customer Owned parts');
      END IF;
   ELSE
      Error_SYS.Record_General('RotablePartPool', 'INVALIDOWNERSHIP: Ownership can be only Company Owned or Customer Owned');
   END IF;

   -- check settings on Part Availability Control
   pacrec_ := Part_Availability_Control_API.Get(newrec_.availability_control_id);

   IF pacrec_.part_supply_control != 'NOT NETTABLE' THEN
      Error_SYS.Record_General('RotablePartPool', 'INVPACSUP: Invalid Part Availability Control setting. :P1 must be Not Nettable', newrec_.availability_control_id);
   END IF;

   IF pacrec_.part_order_issue_control != 'NOT ORDER ISSUE' THEN
      Error_SYS.Record_General('RotablePartPool', 'INVACPOIC: Invalid Part Availability Control setting. :P1 must be Not Order Issue', newrec_.availability_control_id);
   END IF;

   IF pacrec_.part_reservation_control != 'NOT AUTO RESERVATION' THEN
      Error_SYS.Record_General('RotablePartPool', 'INVPACPRC: Invalid Part Availability Control setting. :P1 must be Not Auto Reservation', newrec_.availability_control_id);
   END IF;

   IF pacrec_.part_manual_reserv_ctrl != 'NOT_MANUAL_RESERV' THEN
      Error_SYS.Record_General('RotablePartPool', 'INVPACPMRC: Invalid Part Availability Control setting. :P1 must be Not Manual Reservation', newrec_.availability_control_id);
   END IF;

   IF pacrec_.part_scrap_control != 'NOT SCRAPPABLE' THEN
      Error_SYS.Record_General('RotablePartPool', 'INVPACPSC: Invalid Part Availability Control setting. :P1 must be Not Scrappable', newrec_.availability_control_id);
   END IF;

   IF pacrec_.part_counting_control != 'NOT ALLOW REDUCING' THEN
      Error_SYS.Record_General('RotablePartPool', 'INVPACPCC: Invalid Part Availability Control setting. :P1 must be Not Allow Reducing', newrec_.availability_control_id);
   END IF;


   -- check target quantity is greater than zero
   IF (newrec_.target_qty <= 0) THEN
      Error_SYS.Record_General('RotablePartPool', 'TARGETZERO: Target pool quantity should be greater than zero.');
   END IF;

END Validate_Rotable_Part_Pool___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr( 'PART_OWNERSHIP', Part_Ownership_API.Decode('COMPANY OWNED'), attr_);
   Client_SYS.Add_To_Attr( 'ROTABLE_POOL_ASSET_TYPE_DB', 'INVENTORY ASSET', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT rotable_part_pool_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT (indrec_.part_ownership) THEN 
      newrec_.part_ownership := 'COMPANY OWNED';
   END IF;
   IF NOT (indrec_.rotable_pool_asset_type)THEN 
      newrec_.rotable_pool_asset_type := 'INVENTORY ASSET';
   END IF;
   super(newrec_, indrec_, attr_);
   Validate_Rotable_Part_Pool___(newrec_);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     rotable_part_pool_tab%ROWTYPE,
   newrec_ IN OUT rotable_part_pool_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
   poolqty_    NUMBER;
   faobjqty_   NUMBER;
   fansobjqty_ NUMBER;
   site_    VARCHAR2(5);
   company_ VARCHAR2(20);

   CURSOR check_sites IS
    SELECT contract
    FROM ROTABLE_POOL_SITE_TAB
    WHERE rotable_part_pool_id = newrec_.rotable_part_pool_id;

BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   -- Standard validations
   Validate_Rotable_Part_Pool___(newrec_);

   -- Checks specific for FA-pools
   IF (oldrec_.rotable_pool_asset_type = 'FIXED ASSET') AND Component_Fixass_SYS.INSTALLED THEN

      -- Get FA object count (scrapped included) for an FA pool
      $IF Component_Fixass_SYS.INSTALLED $THEN
         faobjqty_ := Rotable_Pool_Fa_Object_API.Get_Fa_Object_Qty(oldrec_.rotable_part_pool_id);
      $ELSE
         NULL;
      $END
      
      -- An FA-pool with connected objects (scrapped included) should not
      -- be modified other than in its target quantity)
      IF (faobjqty_ > 0) THEN
       IF (newrec_.description != oldrec_.description) OR
           (newrec_.part_ownership != oldrec_.part_ownership ) OR
           (NVL(newrec_.owning_customer_no, 'varchar2null') != NVL(oldrec_.owning_customer_no,'varchar2null') ) OR
           (newrec_.rotable_pool_asset_type != oldrec_.rotable_pool_asset_type ) OR
           (newrec_.part_no != oldrec_.part_no ) OR
           (newrec_.availability_control_id != oldrec_.availability_control_id ) THEN
           Error_SYS.Record_General('RotablePartPool', 'FAOBJCREATED: Only target quantity may be modified when FA objects are created');
        END IF;

        -- Get FA object count (scrapped excluded) for an FA pool
        $IF Component_Fixass_SYS.INSTALLED $THEN
           fansobjqty_ := Rotable_Pool_Fa_Object_API.Get_Not_Scrapped_Fa_Object_Qty(oldrec_.rotable_part_pool_id);
        $ELSE
           NULL;
        $END

        -- An FA-pools new target quantity of objects should not be less than
        -- its actual quantity of objects (scrapped excluded)
        IF (fansobjqty_ > newrec_.target_qty) THEN
           Error_SYS.Record_General('RotablePartPool', 'LOWTARGETQTYOBJ: Target quantity can not be less than the number of FA Objects');
        END IF;
      END IF;

   -- Checks specific for normal non-empty pools
   ELSE

      -- get actual pool quantity
      poolqty_ := Inventory_Part_In_Stock_API.Get_Rotable_Part_Pool_Qty(newrec_.rotable_part_pool_id);

      IF (poolqty_ > 0) THEN
        IF (newrec_.description != oldrec_.description) OR
           (newrec_.part_ownership != oldrec_.part_ownership ) OR
           (NVL(newrec_.owning_customer_no, 'varchar2null') != NVL(oldrec_.owning_customer_no,'varchar2null') ) OR
           (newrec_.rotable_pool_asset_type != oldrec_.rotable_pool_asset_type ) OR
           (newrec_.part_no != oldrec_.part_no ) OR
           (newrec_.availability_control_id != oldrec_.availability_control_id ) THEN
           Error_SYS.Record_General('RotablePartPool', 'POOLNOTEMPTY: Only target quantity may be modified in a non empty pool');
        END IF;

        -- check target qty >= actual qty when pool is not empty
        IF (poolqty_ > newrec_.target_qty) THEN
           Error_SYS.Record_General('RotablePartPool', 'LOWTARGETQTY: Target quantity can not be less than actual quantity');
        END IF;

      -- pool is still empty, which means it still can be
      -- converted into an FA-pool
      ELSE
        IF newrec_.rotable_pool_asset_type = 'FIXED ASSET' THEN

           -- Check all selected sites connected to same company
           OPEN check_sites;
           FETCH check_sites INTO site_;
           IF (check_sites%FOUND) THEN
              company_ := Site_API.Get_Company(site_);
              FETCH check_sites INTO site_;
              WHILE (check_sites%FOUND) LOOP
                 IF company_ != Site_API.Get_Company(site_) THEN
                    CLOSE check_sites;
                    Error_SYS.Record_General(lu_name_, 'NOTSINGLECOMPANY: All sites selected for Fixed Assets rotable part pool need to be connected to the same company');
                 END IF;
                 FETCH check_sites INTO site_;
              END LOOP;
           END IF;
           CLOSE check_sites;
        END IF;
      END IF;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Part_Exists (
   part_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   part_exists_ BOOLEAN := FALSE;
   dummy_       NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   ROTABLE_PART_POOL_TAB
      WHERE part_no = part_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      part_exists_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN (part_exists_);
END Part_Exists;



