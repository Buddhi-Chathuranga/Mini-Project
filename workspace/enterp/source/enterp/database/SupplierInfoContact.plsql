-----------------------------------------------------------------------------
--
--  Logical unit: SupplierInfoContact
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210802  NaLrlk  PR21R2-399, Modified Create_Contact() for include extra attributes new contact information.
--  210731  NaLrlk  PR21R2-399, Modified New() for include extra attributes for new contact.
--  210710  Smallk  FI21R2-2313, Merged LCS bug 159691, modified Insert___() and Update___(). Moved logic from validate action of SupplierInfoContact in SupplierHandling.projection.
--  200327  JanWse  SCXTEND-1815, Added Pack_Table as a public version of Pack_Table___
--  191003  NiDalk  SCXTEND-724, Added Rm_Dup_Insert___, Rm_Dup_Delete___ and Rm_Dup_Update___ to update rm_dup_search_tab and 
--  191003          rm_dup_search_comm_method_tab with supplier contact related information. Called them from Insert___, Delete___ and Update___.
--  190619  Hairlk  SCUXXW4-17027, Added the correct object type in Update___.
--  190327  Nuudlk  SCUXXW4-17741, Added generated GUID to the attr after inserting a record.
--  170517  SBalLK  Bug 131756, Added connect_all_supp_addr attribute and modified Check_Values___(), Prepare_Insert___(), Get_Supp_Addr_Primary___(), Get_Secondary_Contact_Id(),
--  170517          Check_Default_Values(), Check_Insert___(), Get_Guid_By_Supp_Address(), Get_Supplier_Contact_Info(), Get_Contact_Values(), Validate_Supplier_Address() methods and 
--  170517          added Check_Common___(), Validate_Supplier_Address___() method to reflect the changes of new attribute.
--  170403  KoDelk  STRSC-6363, Rename BusinessObjectRep to BusObjRepresentative
--  160404  TiRalk  STRSC-1589, Override Check_Delete___ to validate existence of BusinessObjectContact record 
--  160404          for the supplier when deleting.
--  160315  TiRalk  STRSC-1581, Added Validate_Supplier_Address to validate supplier contact and fetch the supplier address accordingly.
--  160310  TiRalk  STRSC-919, Added Get_Contact_Values in order to fetch client values for the Role 
--  160310          column when adding supplier info contact as a contact entry to business_object_contact_tab.
--  160215  Hairlk  STRSC-1209, Added public get method Get_Key_By_Objid to retreive table keys by provided Objid. Similar impementation exists in CustomerInfoContact lu
--  150920  Maabse  AFT-3384, Added Get_Doc_Object_Description
--  150908  MaIklk  AFT-4018, Fixed to save contact address in New().
--  150828  RoJalk  AFT-2185, Modified the method Create_Contact and changed the attr_ to be IN OUT and assigned supplier_id_, person_id_, guid_.
--  150825  MaIklk  AFT-1961, Added Get_Objid(), Modify() and Remove().
--  150820  MaRalk  BLU-1154, Modified method Insert__ by replacing the method call 
--  150820          Business_Object_Rep_API.New_Business_Object_Main_Rep with Business_Object_Rep_API.New_Business_Object_Rep. 
--  150724  Wahelk  BLU-1093, Added new method Get_Supplier_Contact_Info to get supplier contact info from objid
--  150713  SudJlk  ORA-777, Added Exist_Contact_For_Supplier to check if contact exists for a supplier and return TRUE or FALSE.
--  150626  RoJalk  ORA-882, Added methods Get_Guid_By_Supp_Address, Validate_Person_Id to be used in Business Mail functionality.
--  150616  SudJlk  ORA-740, Overriden Delete___ to handle removing of Business_Object_Rep record if exists.
--  150616          Added methods Exist_Guid and Check_Guid_Exist.
--  150603  SudJlk  ORA-474, Modified Create_Contact() and New() to handle new attribute Department.
--  150603          Modified Prepare_Insert___ and Insert___ to handle new attribute Main_Representative_Id.
--  150603          Added new method Modify_Main_Representative();
--  150602  RoJalk  ORA-499, Replaced Supplier_Info_API.Get_One_Time_Db with Supplier_Info_General_API.Get_One_Time_Db.
--  150525  RoJalk  ORA-161, Modified Get_Primary_Contact_Id_Addr and added a check to see if address_id_ is NULL.
--  150519  RoJalk  ORA-470, Moved the common code in Get_Primary_Contact_Id_Addr and Get_Primary_Contact_Id to Get_Supplier_Primary___. 
--  150514  SudJlk  ORA-292, Modified Check_Insert___ to ensure only unbloccked supplier contact type persons are entered.
--  150513  RoJalk  ORA-160, Added the methods Get_Supp_Addr_Primary___. Added  Get_Primary_Contact_Id_Addr 
--  150513          Supplier to fecth Supplier Reference in the PO. 
--  150513  SudJlk  ORA-292, Added Is_Supplier_Contact().
--  150423  hairlk  Added Exist_Contact function which checks a given contact exists for a given supplier
--  150126  MaRalk  PRSC-5384, Modified method Create_Contact in order to facilitate retrieving Initials 
--  150126          which comes from Supplier Contact - Add Contact dialog.
--  140916  JanWse  PRSC-2365, Modified Create_Contact to support user defined PERSON_ID
--  140623  MaRalk  PRSC-1291, Modified Create_Contact to support multiple choice values for Role field, when using add contact dialog.
--  111130  Chgulk  SFI-970, Merged the Bug 99792
--  100216  SJayLK  Bug 88807, Modified Check_Values___, Added Check_Default_Values
--  091111  Yothlk  Bug 86911, Modified ViewComments.Added no check in ref part
--  070919  Lisvse  Added procedure Copy_Supplier
--  070829  AmPalk  Modified Create_Contact by adding new attribute to the new_attr_string. TITLE, WWW, MESSENGER, INTERCOM and PAGER.
--  070404  ToBeSe  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Supplier_Address___ (
   supplier_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 )
IS
   CURSOR validate_primary IS
      SELECT NVL(COUNT(*), 0)
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_
      AND    address_primary = 'TRUE'
      AND    ((supplier_address = address_id_) OR connect_all_supp_addr = 'TRUE');
   CURSOR validate_secondary IS
      SELECT NVL(COUNT(*), 0)
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_
      AND    address_secondary = 'TRUE'
      AND    ((supplier_address = address_id_) OR connect_all_supp_addr = 'TRUE');
   dummy_ NUMBER;
BEGIN
   OPEN validate_primary;
   FETCH validate_primary INTO dummy_;
   CLOSE validate_primary;
   IF (dummy_ > 1) THEN
      Error_SYS.Record_General(lu_name_,
                               'ERR_DUPLICATE2: The :P1 check box can be selected for only one contact per supplier address ID.',
                               Language_SYS.Translate_Item_Prompt_(lu_name_ => lu_name_,
                                                                   item_    => 'ADDRESS_PRIMARY'));
   END IF;
   OPEN validate_secondary;
   FETCH validate_secondary INTO dummy_;
   CLOSE validate_secondary;
   IF (dummy_ > 1) THEN
      Error_SYS.Record_General(lu_name_,
                               'ERR_DUPLICATE2: The :P1 check box can be selected for only one contact per supplier address ID.',
                               Language_SYS.Translate_Item_Prompt_(lu_name_ => lu_name_,
                                                                   item_    => 'ADDRESS_SECONDARY'));
   END IF;
END Validate_Supplier_Address___;


PROCEDURE Check_Values___ (
   newrec_ IN supplier_info_contact_tab%ROWTYPE,
   objid_  IN VARCHAR2 )
IS
   CURSOR check_duplicate_supplier(supplier_id_ VARCHAR2,
                                   person_id_   VARCHAR2) IS
      SELECT 1
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_
      AND    person_id = person_id_
      AND    ROWID||'' <> NVL(objid_,CHR(0))
      AND    supplier_address IS NULL;
   CURSOR check_duplicate_address(supplier_id_      VARCHAR2,
                                  person_id_        VARCHAR2,
                                  supplier_address_ VARCHAR2 DEFAULT NULL) IS
      SELECT 1
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_
      AND    person_id = person_id_
      AND    supplier_address = supplier_address_
      AND    ROWID||'' <> NVL(objid_,CHR(0));
   dummy_   INTEGER;
BEGIN
   -- Address Defaults
   IF (newrec_.supplier_address IS NOT NULL) THEN
      -- Only one Person allowed for each supplier, supplier address combination.
      OPEN check_duplicate_address(newrec_.supplier_id, newrec_.person_id,newrec_.supplier_address);
      FETCH check_duplicate_address INTO dummy_;
      IF (check_duplicate_address%FOUND) THEN
         CLOSE check_duplicate_address;
         Error_SYS.Record_General(lu_name_, 'ERR_DUPLICATE: A Person can only be conncted once per supplier address and once without address.');
      END IF;
      CLOSE check_duplicate_address;
   -- Supplier defaults
   ELSE
      -- Only one Person allowed for each supplier, when no supplier address set.
      OPEN check_duplicate_supplier(newrec_.supplier_id, newrec_.person_id);
      FETCH check_duplicate_supplier INTO dummy_;
      IF (check_duplicate_supplier%FOUND) THEN
         CLOSE check_duplicate_supplier;
         Error_SYS.Record_General(lu_name_, 'ERR_DUPLICATE: A Person can only be conncted once per supplier address and once without address.');
      END IF;
      CLOSE check_duplicate_supplier;
      -- Address defaults only allowed if supplier address set
      IF ('TRUE' IN (newrec_.address_primary, newrec_.address_secondary) AND newrec_.connect_all_supp_addr = Fnd_Boolean_API.DB_FALSE ) THEN
         Error_SYS.Record_General(lu_name_, 'ERR_NO_CUST_ADDRESS: Supplier address must be set.');
      END IF;
   END IF;
END Check_Values___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     supplier_info_contact_tab%ROWTYPE,
   newrec_ IN OUT supplier_info_contact_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.connect_all_supp_addr = Fnd_Boolean_API.DB_TRUE AND newrec_.supplier_address IS NOT NULL AND oldrec_.supplier_address = newrec_.supplier_address) THEN
      Error_SYS.Record_General(lu_name_, 'CONNALLWITHSUPPADDR: Connect all supplier addresses checkbox cannot be selected when a supplier address is specified.');
   ELSIF (newrec_.connect_all_supp_addr = Fnd_Boolean_API.DB_TRUE AND newrec_.supplier_address IS NOT NULL ) THEN
      Error_SYS.Record_General(lu_name_, 'CONNALLWITHSUPPADDR2: Cannot specify a supplier address when the connect all supplier addresses checkbox is selected.');
   END IF;
END Check_Common___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   id_ person_info_tab.person_id%TYPE;
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ADDRESS_PRIMARY', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('ADDRESS_SECONDARY', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SUPPLIER_PRIMARY', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SUPPLIER_SECONDARY', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('CONNECT_ALL_SUPP_ADDR_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      id_ := Person_Info_API.Get_Id_For_User(Fnd_Session_API.Get_Fnd_User());
      IF (Business_Representative_API.Exists(id_)) THEN
         Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', id_, attr_);
      END IF;
   $END
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT supplier_info_contact_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Check_Values___(newrec_, NULL);   
   super(objid_, objversion_, newrec_, attr_);
   -- Moved logic from validate action of SupplierInfoContact in SupplierHandling.projection. Please do not move to Check_Common___.
   Check_Default_Values(newrec_.supplier_id, NULL);
   Client_SYS.Add_To_Attr('GUID', newrec_.guid, attr_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN    
      IF (newrec_.main_representative_id IS NOT NULL) THEN
         -- Insert main representative. 
         Bus_Obj_Representative_API.New_Bus_Obj_Representative(newrec_.guid, Business_Object_Type_API.DB_SUPPLIER_CONTACT, newrec_.main_representative_id, Fnd_Boolean_API.DB_TRUE);
      END IF;
   $END
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      Rm_Dup_Insert___(newrec_);
   $END
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     supplier_info_contact_tab%ROWTYPE,
   newrec_     IN OUT supplier_info_contact_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Check_Values___(newrec_, objid_);   
   newrec_.changed := SYSDATE;
   newrec_.changed_by := Fnd_Session_API.Get_Fnd_User;   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Moved logic from validate action of SupplierInfoContact in SupplierHandling.projection. Please do not move to Check_Common___.
   Check_Default_Values(newrec_.supplier_id, NULL);
   $IF Component_Srm_SYS.INSTALLED $THEN
      IF (Client_SYS.Get_Item_Value('UPDATE_MAIN_REP', attr_) = Fnd_Boolean_API.DB_TRUE) THEN  
         IF (Validate_SYS.Is_Changed(oldrec_.main_representative_id, newrec_.main_representative_id)) THEN
            -- Update main representative.          
            Bus_Obj_Representative_API.Modify_Object_Main_Rep(newrec_.guid, Business_Object_Type_API.DB_SUPPLIER_CONTACT, newrec_.main_representative_id, Fnd_Boolean_API.DB_TRUE);
         END IF;
      END IF;
      $IF Component_Rmpanl_SYS.INSTALLED $THEN
         Rm_Dup_Update___(newrec_);
      $END
   $END
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT supplier_info_contact_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
BEGIN   
   newrec_.guid := sys_guid();
   newrec_.created := SYSDATE;
   newrec_.created_by := Fnd_Session_API.Get_Fnd_User;
   newrec_.changed := SYSDATE;
   newrec_.changed_by := Fnd_Session_API.Get_Fnd_User;
   IF (newrec_.connect_all_supp_addr IS NULL) THEN
      newrec_.Connect_all_supp_addr := Fnd_Boolean_API.DB_FALSE;
   END IF;
   super(newrec_, indrec_, attr_);
   IF (newrec_.person_id IS NOT NULL) THEN
      IF (Person_Info_API.Get_Supplier_Contact_Db(newrec_.person_id) = Fnd_Boolean_API.DB_FALSE) THEN 
         Error_SYS.Record_General(lu_name_, 'NOTSUPPLIERCONTACT: The person :P1 you entered has not been specified as a supplier contact.', newrec_.person_id);
      ELSIF (Person_Info_API.Get_Blocked_For_Use_Supplie_Db(newrec_.person_id) = Fnd_Boolean_API.DB_TRUE) THEN
         Error_SYS.Record_General(lu_name_, 'SUPPLIERCONTACTBLOCKED: The person :P1 you entered has been blocked for use.', newrec_.person_id);       
      END IF;
   END IF;
END Check_Insert___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN supplier_info_contact_tab%ROWTYPE )
IS
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      -- Remove the representatives
      Bus_Obj_Representative_API.Remove(remrec_.guid, Business_Object_Type_API.DB_SUPPLIER_CONTACT);
   $END
   super(objid_, remrec_);
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      Rm_Dup_Delete___(remrec_);
   $END
END Delete___;


FUNCTION Get_Supp_Addr_Primary___ (
   supplier_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2) RETURN VARCHAR2
IS
   CURSOR supplier_address_primary IS
      SELECT person_id
      FROM   supplier_info_contact
      WHERE  address_primary = 'TRUE'
      AND    supplier_id = supplier_id_
      AND    ((supplier_address = address_id_) OR
              (supplier_address IS NULL AND connect_all_supp_addr = 'TRUE'));
   person_id_  person_info_tab.person_id%TYPE;
BEGIN
   OPEN supplier_address_primary;
   FETCH supplier_address_primary INTO person_id_;
   CLOSE supplier_address_primary;
   RETURN person_id_;
END Get_Supp_Addr_Primary___;


FUNCTION Get_Supplier_Primary___ (
   supplier_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR supplier_primary IS
      SELECT person_id
      FROM   supplier_info_contact
      WHERE  supplier_primary = 'TRUE'
      AND    supplier_id = supplier_id_;
   person_id_  person_info_tab.person_id%TYPE;
BEGIN
   OPEN  supplier_primary;
   FETCH supplier_primary INTO person_id_;
   CLOSE supplier_primary;
   RETURN person_id_;
END Get_Supplier_Primary___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN supplier_info_contact_tab%ROWTYPE )
IS   
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN      
      Business_Object_Contact_API.Check_Contact(remrec_.supplier_id, 'SUPPLIER', remrec_.person_id, remrec_.guid);                  
   $END
   super(remrec_);
END Check_Delete___;


PROCEDURE Rm_Dup_Insert___ (
   rec_  IN supplier_info_contact_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Insert(lu_name_, attr_);
   $ELSE
      NULL;
   $END
END Rm_Dup_Insert___;


PROCEDURE Rm_Dup_Update___ (
   rec_  IN supplier_info_contact_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Update(lu_name_, attr_);
   $ELSE 
      NULL;
   $END
END Rm_Dup_Update___;


PROCEDURE Rm_Dup_Delete___ (
   rec_  IN supplier_info_contact_tab%ROWTYPE )
IS 
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Delete(lu_name_, attr_);
   $ELSE 
      NULL;
   $END
END Rm_Dup_Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Contact (
   attr_ IN OUT VARCHAR2 )
IS
   info_             VARCHAR2(2000);
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   new_attr_         VARCHAR2(2000);
   person_id_        person_info_tab.person_id%TYPE;
   supplier_id_      supplier_info_tab.supplier_id%TYPE;
   supplier_address_ supplier_info_address_tab.address_id%TYPE;
   guid_             supplier_info_contact_tab.guid%TYPE;  
BEGIN
   supplier_id_ := Client_SYS.Get_Item_Value('SUPPLIER_ID', attr_);
   supplier_address_ := Client_SYS.Get_Item_Value('SUPPLIER_ADDRESS', attr_);
   -- Create new Contact/Person
   Client_SYS.Clear_Attr(new_attr_);
   IF (Client_SYS.Get_Item_Value('PERSON_ID', attr_) IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PERSON_ID', Client_SYS.Get_Item_Value('PERSON_ID', attr_), new_attr_);
   END IF;
   Client_SYS.Add_To_Attr('NAME', Client_SYS.Get_Item_Value('NAME', attr_), new_attr_);
   Client_SYS.Add_To_Attr('FIRST_NAME', Client_SYS.Get_Item_Value('FIRST_NAME', attr_), new_attr_);
   Client_SYS.Add_To_Attr('MIDDLE_NAME', Client_SYS.Get_Item_Value('MIDDLE_NAME', attr_), new_attr_);
   Client_SYS.Add_To_Attr('LAST_NAME', Client_SYS.Get_Item_Value('LAST_NAME', attr_), new_attr_);
   Client_SYS.Add_To_Attr('PHONE', Client_SYS.Get_Item_Value('PHONE', attr_), new_attr_);
   Client_SYS.Add_To_Attr('FAX', Client_SYS.Get_Item_Value('FAX', attr_), new_attr_);
   Client_SYS.Add_To_Attr('MOBILE', Client_SYS.Get_Item_Value('MOBILE', attr_), new_attr_);
   Client_SYS.Add_To_Attr('E_MAIL', Client_SYS.Get_Item_Value('E_MAIL', attr_), new_attr_);
   Client_SYS.Add_To_Attr('TITLE', Client_SYS.Get_Item_Value('TITLE', attr_), new_attr_);
   Client_SYS.Add_To_Attr('INITIALS', Client_SYS.Get_Item_Value('INITIALS', attr_), new_attr_);
   Client_SYS.Add_To_Attr('WWW', Client_SYS.Get_Item_Value('WWW', attr_), new_attr_);
   Client_SYS.Add_To_Attr('MESSENGER', Client_SYS.Get_Item_Value('MESSENGER', attr_), new_attr_);
   Client_SYS.Add_To_Attr('INTERCOM', Client_SYS.Get_Item_Value('INTERCOM', attr_), new_attr_);
   Client_SYS.Add_To_Attr('PAGER', Client_SYS.Get_Item_Value('PAGER', attr_), new_attr_);
   Client_SYS.Add_To_Attr('SUPPLIER_ID', supplier_id_, new_attr_);
   IF (Client_SYS.Get_Item_Value('COPY_ADDRESS', attr_) = 'TRUE' AND supplier_address_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ADDRESS_ID', supplier_address_, new_attr_);
   END IF;
   Contact_Util_API.Create_Contact(new_attr_);
   person_id_ := Client_SYS.Get_Item_Value('PERSON_ID', new_attr_);
   -- Create new SupplierInfoContact
   Client_SYS.Clear_Attr(new_attr_);
   -- Prepare
   New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
   Client_SYS.Add_To_Attr('SUPPLIER_ID', supplier_id_, new_attr_);
   Client_SYS.Add_To_Attr('PERSON_ID', person_id_, new_attr_);
   Client_SYS.Add_To_Attr('SUPPLIER_ADDRESS', supplier_address_, new_attr_);
   Client_SYS.Add_To_Attr('ROLE_DB', Contact_Role_API.Encode_List(Client_SYS.Get_Item_Value('ROLE', attr_)), new_attr_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Client_SYS.Add_To_Attr('DEPARTMENT_DB', Contact_Department_API.Encode(Client_SYS.Get_Item_Value('DEPARTMENT', attr_)), new_attr_); 
   $END  
   -- Modify values that might be set
   Contact_Util_API.Modify_Item_Value('ADDRESS_PRIMARY', Client_SYS.Get_Item_Value('ADDRESS_PRIMARY', attr_), new_attr_);
   Contact_Util_API.Modify_Item_Value('ADDRESS_SECONDARY', Client_SYS.Get_Item_Value('ADDRESS_SECONDARY', attr_), new_attr_);
   Contact_Util_API.Modify_Item_Value('SUPPLIER_PRIMARY', Client_SYS.Get_Item_Value('SUPPLIER_PRIMARY', attr_), new_attr_);
   Contact_Util_API.Modify_Item_Value('SUPPLIER_SECONDARY', Client_SYS.Get_Item_Value('SUPPLIER_SECONDARY', attr_), new_attr_);
   Contact_Util_API.Modify_Item_Value('CONNECT_ALL_SUPP_ADDR_DB', Client_SYS.Get_Item_Value('CONNECT_ALL_SUPP_ADDR_DB', attr_), new_attr_);
   New__(info_, objid_, objversion_, new_attr_, 'DO');
   guid_ := Client_SYS.Get_Item_Value('GUID', new_attr_);   
   -- Copy address to the person and set it as contact address.
   IF (Client_SYS.Get_Item_Value('COPY_ADDRESS', attr_) = 'TRUE' AND supplier_address_ IS NOT NULL) THEN
      Client_SYS.Clear_Attr(new_attr_);
      Client_SYS.Add_To_Attr('CONTACT_ADDRESS', supplier_address_, new_attr_);
      Modify__(info_, objid_, objversion_, new_attr_, 'DO');
   END IF;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SUPPLIER_ID', supplier_id_, attr_);
   Client_SYS.Add_To_Attr('PERSON_ID',   person_id_,   attr_);
   Client_SYS.Add_To_Attr('GUID',        guid_,        attr_);   
END Create_Contact;


PROCEDURE New (
   supplier_id_      IN VARCHAR2,
   person_id_        IN VARCHAR2,
   supplier_address_ IN VARCHAR2 DEFAULT NULL,
   attr_             IN VARCHAR2 DEFAULT NULL )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   new_attr_   VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(new_attr_);
   New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
   Client_SYS.Add_To_Attr('SUPPLIER_ID', supplier_id_, new_attr_);
   Client_SYS.Add_To_Attr('PERSON_ID', person_id_, new_attr_);
   IF (supplier_address_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SUPPLIER_ADDRESS', supplier_address_, new_attr_);
      -- Copy address to the person and set it as contact address.
      IF (Client_SYS.Get_Item_Value('COPY_ADDRESS', attr_) = 'TRUE') THEN
         Contact_Util_API.Copy_Supplier_Address(person_id_, supplier_id_, supplier_address_);
         Client_SYS.Add_To_Attr('CONTACT_ADDRESS', supplier_address_, new_attr_);
      END IF;
   END IF;
   -- Extra Attributes
   Client_SYS.Add_To_Attr('ROLE', Client_SYS.Get_Item_Value('ROLE', attr_), new_attr_);
   IF (NOT Client_SYS.Item_Exist('CONTACT_ADDRESS', new_attr_)) THEN
      Client_SYS.Add_To_Attr('CONTACT_ADDRESS', Client_SYS.Get_Item_Value('CONTACT_ADDRESS', attr_), new_attr_);
   END IF;
   IF (Client_SYS.Item_Exist('SUPPLIER_PRIMARY', attr_)) THEN
      Client_SYS.Set_Item_Value('SUPPLIER_PRIMARY', Client_SYS.Get_Item_Value('SUPPLIER_PRIMARY', attr_), new_attr_);
   END IF;
   IF (Client_SYS.Item_Exist('ADDRESS_PRIMARY', attr_)) THEN
      Client_SYS.Set_Item_Value('ADDRESS_PRIMARY', Client_SYS.Get_Item_Value('ADDRESS_PRIMARY', attr_), new_attr_);
   END IF;
   IF (Client_SYS.Item_Exist('CONNECT_ALL_SUPP_ADDR_DB', attr_)) THEN
      Client_SYS.Set_Item_Value('CONNECT_ALL_SUPP_ADDR_DB', Client_SYS.Get_Item_Value('CONNECT_ALL_SUPP_ADDR_DB', attr_), new_attr_);
   END IF;
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Client_SYS.Add_To_Attr('DEPARTMENT_DB', Contact_Department_API.Encode(Client_SYS.Get_Item_Value('DEPARTMENT', attr_)), new_attr_); 
   $END
   New__(info_, objid_, objversion_, new_attr_, 'DO');
END New;


@UncheckedAccess
FUNCTION Get_Primary_Contact_Id (
   supplier_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   person_id_  person_info_tab.person_id%TYPE;
BEGIN
   IF (address_id_ IS NOT NULL) THEN
      person_id_ := Get_Supp_Addr_Primary___(supplier_id_, address_id_);
   ELSE
      person_id_ := Get_Supplier_Primary___(supplier_id_);
   END IF;
   RETURN person_id_;
END Get_Primary_Contact_Id;


@UncheckedAccess
FUNCTION Get_Primary_Contact_Id_Addr (
   supplier_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   person_id_  person_info_tab.person_id%TYPE;
BEGIN
   IF (address_id_ IS NOT NULL) THEN
      person_id_ := Get_Supp_Addr_Primary___(supplier_id_, address_id_);
   END IF;
   IF (person_id_ IS NULL) THEN
      person_id_ := Get_Supplier_Primary___(supplier_id_);
   END IF;
   RETURN person_id_;
END Get_Primary_Contact_Id_Addr;


@UncheckedAccess
FUNCTION Get_Primary_Contact_Name (
   supplier_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN Person_Info_API.Get_Name(Get_Primary_Contact_Id(supplier_id_, address_id_));
END Get_Primary_Contact_Name;


@UncheckedAccess
FUNCTION Get_Secondary_Contact_Id (
   supplier_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   CURSOR supplier_secondary IS
      SELECT person_id
      FROM   supplier_info_contact
      WHERE  supplier_secondary = 'TRUE'
      AND    supplier_id = supplier_id_;
   CURSOR supplier_address_secondary IS
      SELECT person_id
      FROM   supplier_info_contact
      WHERE  address_secondary = 'TRUE'
      AND    supplier_id = supplier_id_
      AND    ((supplier_address = address_id_) OR 
              (supplier_address IS NULL AND connect_all_supp_addr = 'TRUE'));
   person_id_  person_info_tab.person_id%TYPE;
BEGIN
   IF (address_id_ IS NOT NULL) THEN
      OPEN supplier_address_secondary;
      FETCH supplier_address_secondary INTO person_id_;
      CLOSE supplier_address_secondary;
   ELSE
      OPEN supplier_secondary;
      FETCH supplier_secondary INTO person_id_;
      CLOSE supplier_secondary;
   END IF;
   RETURN person_id_;
END Get_Secondary_Contact_Id;


@UncheckedAccess
FUNCTION Get_Secondary_Contact_Name (
   supplier_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN Person_Info_API.Get_Name(Get_Secondary_Contact_Id(supplier_id_, address_id_));
END Get_Secondary_Contact_Name;


PROCEDURE Copy_Supplier (
   supplier_id_ IN VARCHAR2,
   new_id_      IN VARCHAR2 )
IS   
   newrec_               supplier_info_contact_tab%ROWTYPE;
   oldrec_               supplier_info_contact_tab%ROWTYPE;
   is_one_time_supplier_ VARCHAR2(20);
   CURSOR get_attr IS
      SELECT *
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_;
BEGIN 
   is_one_time_supplier_:= Supplier_Info_General_API.Get_One_Time_Db(supplier_id_);
   FOR rec_ IN get_attr LOOP
      oldrec_ := Lock_By_Keys___(supplier_id_, rec_.person_id, rec_.guid);   
      newrec_ := oldrec_ ;
      newrec_.supplier_id := new_id_;
      IF (is_one_time_supplier_ = 'FALSE' OR (newrec_.supplier_address IS NULL)) THEN
         newrec_.guid := NULL;
         newrec_.created := NULL;
         newrec_.created_by := NULL;
         newrec_.changed := NULL;
         newrec_.changed_by := NULL;
         New___(newrec_);
      END IF;
   END LOOP;
END Copy_Supplier;


PROCEDURE Check_Default_Values (
   supplier_id_   IN VARCHAR2,
   address_id_    IN VARCHAR2 )
IS
   dummy_    INTEGER;
   -- Supplier address with NULL values can be avoid since primary, secondary checkbox cannot be selected with NULL values.
   CURSOR get_address IS
      SELECT DISTINCT supplier_address
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_
      AND    supplier_address IS NOT NULL;
   CURSOR check_dupl_supplier_primary(supplier_id_ VARCHAR2) IS
      SELECT 1
      FROM   supplier_info_contact_tab a
      WHERE  supplier_id = supplier_id_
      AND    supplier_primary = 'TRUE'
      AND    EXISTS (SELECT 1
                     FROM   supplier_info_contact_tab b
                     WHERE  a.ROWID !=  b.ROWID
                     AND    a.supplier_id =  b.supplier_id
                     AND    supplier_primary =  'TRUE');      
   CURSOR check_dupl_supplier_secondary(supplier_id_ VARCHAR2) IS
      SELECT 1
      FROM   supplier_info_contact_tab a
      WHERE  supplier_id = supplier_id_
      AND    supplier_secondary = 'TRUE'
      AND    EXISTS (SELECT 1
                     FROM   supplier_info_contact_tab b
                     WHERE  a.ROWID !=  b.ROWID
                     AND    a.supplier_id =  b.supplier_id
                     AND    supplier_secondary =  'TRUE');
BEGIN
   IF (address_id_ IS NULL) THEN
      FOR rec_ IN get_address LOOP
         Validate_Supplier_Address___(supplier_id_, rec_.supplier_address);
      END LOOP;
   ELSE
      Validate_Supplier_Address___(supplier_id_, address_id_);
   END IF;
   OPEN check_dupl_supplier_primary(supplier_id_);
   FETCH check_dupl_supplier_primary INTO dummy_;
   IF (check_dupl_supplier_primary%FOUND) THEN
      CLOSE check_dupl_supplier_primary;
      Error_SYS.Record_General(lu_name_,
                               'ERR_DUPLICATE3: The :P1 check box can be selected for only one contact per supplier',
                               Language_SYS.Translate_Item_Prompt_(lu_name_ => lu_name_,
                                                                   item_    => 'SUPPLIER_PRIMARY'));
   END IF;                    
   CLOSE check_dupl_supplier_primary;
   OPEN check_dupl_supplier_secondary(supplier_id_);
   FETCH check_dupl_supplier_secondary INTO dummy_;
   IF (check_dupl_supplier_secondary%FOUND) THEN
      CLOSE check_dupl_supplier_secondary;
      Error_SYS.Record_General(lu_name_,
                               'ERR_DUPLICATE3: The :P1 check box can be selected for only one contact per supplier',
                               Language_SYS.Translate_Item_Prompt_(lu_name_ => lu_name_,
                                                                   item_    => 'SUPPLIER_SECONDARY'));
   END IF;                    
   CLOSE check_dupl_supplier_secondary;
END Check_Default_Values;      


FUNCTION Exist_Contact (
   supplier_id_ IN VARCHAR2,
   person_id_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_contact IS
      SELECT 1
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_
      AND    person_id = person_id_;
BEGIN
   OPEN exist_contact;
   FETCH exist_contact INTO dummy_;
   IF (exist_contact%FOUND) THEN
      CLOSE exist_contact;
      RETURN(TRUE);
   ELSE
      CLOSE exist_contact;
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;     
END Exist_Contact;


-- Is_Supplier_Contact
--    This method checks whether the given person is registered as a supplier contact.
FUNCTION Is_Supplier_Contact (
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_contact IS
      SELECT 1
      FROM   supplier_info_contact_tab
      WHERE  person_id = person_id_;      
BEGIN
   OPEN exist_contact;
   FETCH exist_contact INTO dummy_;
   IF (exist_contact%FOUND) THEN
      CLOSE exist_contact;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_contact;
   RETURN 'FALSE'; 
END Is_Supplier_Contact;


PROCEDURE Modify_Main_Representative (
   guid_             IN VARCHAR2,
   rep_id_           IN VARCHAR2,
   remove_main_      IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
   oldrec_        supplier_info_contact_tab%ROWTYPE;
   newrec_        supplier_info_contact_tab%ROWTYPE;
   attr_          VARCHAR2(32000);
   objid_         supplier_info_contact.objid%TYPE;
   objversion_    supplier_info_contact.objversion%TYPE;
   found_         NUMBER;
   supplier_id_   supplier_info_contact_tab.supplier_id%TYPE;
   person_id_     supplier_info_contact_tab.person_id%TYPE;
   indrec_        Indicator_Rec;
   CURSOR check_main_rep IS
      SELECT COUNT(*)
      FROM   supplier_info_contact_tab
      WHERE  guid = guid_
      AND    main_representative_id = rep_id_ ; 
   CURSOR get_rec IS
      SELECT supplier_id, person_id
      FROM   supplier_info_contact_tab
      WHERE  guid = guid_;
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      OPEN get_rec;
      FETCH get_rec INTO supplier_id_, person_id_;
      CLOSE get_rec;
      IF (supplier_id_ IS NOT NULL) THEN
         oldrec_ := Lock_By_Keys___(supplier_id_, person_id_, guid_);
         Client_SYS.Clear_Attr(attr_);      
         IF (remove_main_ = Fnd_Boolean_API.DB_FALSE) THEN
            Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', rep_id_, attr_);
         ELSE
            Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', '', attr_); 
         END IF;
         OPEN check_main_rep;
         FETCH check_main_rep INTO found_;
         CLOSE check_main_rep;
         IF (remove_main_ = Fnd_Boolean_API.DB_FALSE AND found_ = 0) OR (remove_main_ = Fnd_Boolean_API.DB_TRUE AND found_ = 1) THEN            
            newrec_ := oldrec_;
            Get_Id_Version_By_Keys___(objid_, objversion_, supplier_id_, person_id_, guid_);
            Unpack___(newrec_, indrec_, attr_);
            Check_Update___(oldrec_, newrec_, indrec_, attr_);
            Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);   
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Modify_Main_Representative;
   

@UncheckedAccess
FUNCTION Check_Guid_Exist (
   guid_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   supplier_info_contact_tab
      WHERE  guid = guid_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Guid_Exist;


PROCEDURE Exist_Guid (   
   guid_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Guid_Exist(guid_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist_Guid;


@UncheckedAccess
FUNCTION Get_Guid_By_Supp_Address(
   supplier_id_      IN VARCHAR2,
   person_id_        IN VARCHAR2,
   supplier_address_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   guid_   supplier_info_contact_tab.guid%TYPE;
   CURSOR get_guid IS
      SELECT guid
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_
      AND    person_id = person_id_
      AND    ((supplier_address = supplier_address_) OR 
              (supplier_address IS NULL AND connect_all_supp_addr = 'TRUE'));
   CURSOR get_guid_empty_addr IS
      SELECT guid
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_
      AND    person_id = person_id_
      AND    (supplier_address IS NULL AND connect_all_supp_addr = 'FALSE');
BEGIN
   IF (supplier_address_ IS NOT NULL) THEN
      OPEN get_guid;
      FETCH get_guid INTO guid_;
      CLOSE get_guid;   
   ELSE
      OPEN get_guid_empty_addr;
      FETCH get_guid_empty_addr INTO guid_;
      CLOSE get_guid_empty_addr;  
   END IF;
   RETURN guid_;
END Get_Guid_By_Supp_Address;


FUNCTION Exist_Contact_For_Supplier (
   supplier_id_ IN VARCHAR2,
   person_id_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_contact IS
      SELECT 1
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_
      AND    person_id = person_id_;
BEGIN
   OPEN exist_contact;
   FETCH exist_contact INTO dummy_;
   IF (exist_contact%FOUND) THEN
      CLOSE exist_contact;
      RETURN 'TRUE';
   ELSE
      CLOSE exist_contact;
      RETURN 'FALSE';
   END IF;     
END Exist_Contact_For_Supplier;


@UncheckedAccess
FUNCTION Get_Objid (
   supplier_id_ IN VARCHAR2,
   person_id_   IN VARCHAR2,
   guid_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   objid_  VARCHAR2(200);
BEGIN
   IF (supplier_id_ IS NULL OR person_id_ IS NULL OR guid_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT ROWID
   INTO   objid_
   FROM   supplier_info_contact_tab
   WHERE  supplier_id = supplier_id_
   AND    person_id = person_id_
   AND    guid = guid_;
   RETURN objid_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(supplier_id_, person_id_, guid_, 'Get_Objid');
END Get_Objid;
   
   
PROCEDURE Modify (   
   attr_          IN OUT   VARCHAR2,
   supplier_id_   IN       VARCHAR2,
   person_id_     IN       VARCHAR2,
   guid_          IN       VARCHAR2 )
IS
   oldrec_       supplier_info_contact_tab%ROWTYPE;
   newrec_       supplier_info_contact_tab%ROWTYPE;  
   indrec_       Indicator_Rec;
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(200);
BEGIN    
   oldrec_ := Lock_By_Keys___(supplier_id_, person_id_, guid_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   objid_ := Get_Objid(supplier_id_, person_id_, guid_);  
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);      
END Modify;
   

PROCEDURE Remove (
   supplier_id_ IN VARCHAR2,
   person_id_   IN VARCHAR2,
   guid_        IN VARCHAR2)
IS
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
   remrec_      supplier_info_contact_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, supplier_id_, person_id_, guid_);
   remrec_ := Lock_By_Keys___(supplier_id_, person_id_, guid_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


@ObjectConnectionMethod
@UncheckedAccess
FUNCTION Get_Doc_Object_Description (
   supplier_id_ IN VARCHAR2,
   person_id_   IN VARCHAR2,
   guid_        IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   --Return PERSON ID - Person Name (SUPPLIER ID)
   RETURN person_id_ ||' - ' || Person_Info_API.Get_Name(person_id_) ||'  (' || supplier_id_ || ') ';
END Get_Doc_Object_Description;


@UncheckedAccess
FUNCTION Get_Key_By_Objid (
   objid_ IN   VARCHAR2 ) RETURN supplier_info_contact_tab%ROWTYPE
IS
   rec_ supplier_info_contact_tab%ROWTYPE;    
   CURSOR get_keys IS
      SELECT supplier_id, person_id, guid
      FROM   supplier_info_contact_tab
      WHERE  ROWID = objid_;
BEGIN
   OPEN get_keys;
   FETCH get_keys INTO rec_.supplier_id, rec_.person_id, rec_.guid;
   CLOSE get_keys;   
   RETURN rec_; 
END Get_Key_By_Objid;


-- Get_Contact_Values
--   Fetch the contact values according to the given supplier id, person id and supplier address.
PROCEDURE Get_Contact_Values (
   attr_ IN OUT VARCHAR2 )
IS
   supplier_id_                supplier_info_contact_tab.supplier_id%TYPE;
   person_id_                  supplier_info_contact_tab.person_id%TYPE;
   supplier_address_           supplier_info_contact_tab.supplier_address%TYPE;
   guid_                       supplier_info_contact_tab.guid%TYPE;
   role_                       supplier_info_contact_tab.role%TYPE;
   contact_address_            supplier_info_contact_tab.contact_address%TYPE;    
   CURSOR get_contact IS
      SELECT guid, role, contact_address
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_
      AND    person_id = person_id_
      AND    ((supplier_address = supplier_address_) OR 
              (supplier_address IS NULL AND connect_all_supp_addr = 'TRUE'));
   CURSOR get_person_contact IS
      SELECT guid, role, contact_address, supplier_address, connect_all_supp_addr
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_
      AND    person_id = person_id_;
   CURSOR get_person_empty_contact IS
      SELECT guid, role, contact_address
      FROM   supplier_info_contact_tab
      WHERE  supplier_id = supplier_id_
      AND    person_id = person_id_
      AND    (supplier_address IS NULL AND connect_all_supp_addr = 'FALSE');
BEGIN
   -- Retrieve values passed in the attribute string   
   supplier_id_        := Client_SYS.Get_Item_Value('SUPPLIER_ID', attr_);
   person_id_          := Client_SYS.Get_Item_Value('PERSON_ID', attr_);
   supplier_address_   := Client_SYS.Get_Item_Value('SUPPLIER_ADDRESS', attr_);     
   IF (supplier_address_ IS NULL) THEN
      -- First check whether contact is existing for empty supplier address      
      OPEN get_person_empty_contact;
      FETCH get_person_empty_contact INTO guid_,role_,contact_address_;
      IF (get_person_empty_contact%NOTFOUND) THEN
         CLOSE get_person_empty_contact;   
         -- Second, if empty supplier address contact not found then fetch the contacts which has supplier address.
         FOR rec_ IN get_person_contact LOOP
            IF (guid_ IS NOT NULL) THEN
               Client_SYS.Add_To_Attr('MULTI_ADDR_FOUND', 'TRUE', attr_);              
               RETURN;
            END IF;        
            guid_            := rec_.guid;
            role_            := rec_.role;
            contact_address_ := rec_.contact_address;
            IF (rec_.supplier_address IS NULL AND rec_.connect_all_supp_addr = 'TRUE') THEN
               supplier_address_ := Supplier_Info_Address_API.Get_Default_Address(supplier_id_, Address_Type_Code_API.DB_PRIMARY_CONTACT);
            ELSE
               supplier_address_ := rec_.supplier_address;           
            END IF;
         END LOOP;
         Client_SYS.Set_Item_Value('SUPPLIER_ADDRESS', supplier_address_, attr_);
      ELSE
          CLOSE get_person_empty_contact;
      END IF;
   ELSE
      -- Fetch the contact for the supplier address given
      OPEN get_contact;
      FETCH get_contact INTO guid_, role_, contact_address_;
      CLOSE get_contact;     
   END IF; 
   Client_SYS.Add_To_Attr('GUID', guid_, attr_);
   Client_SYS.Add_To_Attr('ROLE', Contact_Role_API.Decode_List(role_), attr_);
   Client_SYS.Add_To_Attr('CONTACT_ADDRESS', contact_address_, attr_);   
   IF (guid_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PHONE', Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('PHONE'), 1, contact_address_, SYSDATE), attr_);
      Client_SYS.Add_To_Attr('MOBILE', Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('MOBILE'), 1, contact_address_, SYSDATE), attr_);
      Client_SYS.Add_To_Attr('E_MAIL', Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('E_MAIL'), 1, contact_address_, SYSDATE), attr_);
      Client_SYS.Add_To_Attr('FAX', Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('FAX'), 1, contact_address_, SYSDATE), attr_);
      Client_SYS.Add_To_Attr('WWW', Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('WWW'), 1, contact_address_, SYSDATE), attr_);
   END IF;         
END Get_Contact_Values;


FUNCTION Pack_Table (
   rec_  IN supplier_info_contact_tab%ROWTYPE ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      RETURN Pack_Table___(rec_);
   $ELSE
      RETURN NULL;
   $END
END Pack_Table;
