-----------------------------------------------------------------------------
--
--  Logical unit: CreditControlGroup
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130607  SURBLK Added column ext_cust_crd_chk and set it true in Prepare_Insert___.
--  120525  JeLise   Made description private.
--  120508  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120508           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120508           was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  081121  ChJalk Bug 78438, Made the attribute Description public, so added the method Get_Description.
--  060821  RaKalk Create
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
   Client_SYS.Add_To_Attr('DO_CHECK_WHEN_RELEASE_DB',     'FALSE', attr_);
   Client_SYS.Add_To_Attr('DO_CHECK_WHEN_PICK_PLAN_DB',   'FALSE', attr_);
   Client_SYS.Add_To_Attr('DO_CHECK_WHEN_PICK_LIST_DB',   'FALSE', attr_);
   Client_SYS.Add_To_Attr('DO_CHECK_WHEN_DELIVER_DB',     'FALSE', attr_);
   Client_SYS.Add_To_Attr('DEFAULT_FOR_NEW_CUSTOMERS_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('EXT_CUST_CRD_CHK_DB', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CREDIT_CONTROL_GROUP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.default_for_new_customers = 'TRUE') THEN
      UPDATE CREDIT_CONTROL_GROUP_TAB
      SET    default_for_new_customers = 'FALSE'
      WHERE  default_for_new_customers = 'TRUE';
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CREDIT_CONTROL_GROUP_TAB%ROWTYPE,
   newrec_     IN OUT CREDIT_CONTROL_GROUP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.default_for_new_customers = 'TRUE'  AND
      oldrec_.default_for_new_customers = 'FALSE') THEN

      UPDATE CREDIT_CONTROL_GROUP_TAB
      SET    default_for_new_customers = 'FALSE'
      WHERE  default_for_new_customers = 'TRUE';
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Default_Group RETURN VARCHAR2
IS
   default_group_id_   CREDIT_CONTROL_GROUP_TAB.credit_control_group_id%TYPE;
   CURSOR get_default_group_id IS
      SELECT credit_control_group_id
      FROM   CREDIT_CONTROL_GROUP_TAB
      WHERE  default_for_new_customers = 'TRUE';
BEGIN
   OPEN get_default_group_id;
   FETCH get_default_group_id INTO default_group_id_;
   CLOSE get_default_group_id;

   RETURN default_group_id_;
END Get_Default_Group;

@UncheckedAccess
FUNCTION Get_Description (
   credit_control_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ credit_control_group_tab.description%TYPE;
BEGIN
   IF (credit_control_group_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      credit_control_group_id_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
   INTO   temp_
   FROM   credit_control_group_tab
   WHERE  credit_control_group_id = credit_control_group_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(credit_control_group_id_, 'Get_Description');
END Get_Description;




