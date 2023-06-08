-----------------------------------------------------------------------------
--
--  Logical unit: CustomerInfoContact
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211228  Sanvlk   CRM21R2-714, Added a journal entry to account crm journal when contact is deleted in Delete___.
--  211203  Kavflk  CRM21R2-258 , Added Job title field into Create_Contact as an attribute.
--  211210  Sanvlk  Added history log when new address is added in insert___ .
--  181008  JanWse  SCUXX-4712, Re-arranged code used for duplication check
--  180724  AwWelk  SCUXX-4048, Added conditional compilation for duplication logic in rmcom.
--  180215  NiNilk  Bug 139431, Modified method Get_Contact_Values to fetch the value for column power of decision in contacts tab in business opportunity window, when adding a new contact. 
--  180119  niedlk  SCUXX-1233, Added functionality to log CRM related history and interactions for Customer.
--  170712  Dakplk  STRFI-9164, Merged LCS bug 135981, Eliminated duplicated definitions for the error messages.
--  170517  SBalLK  Bug 131756, Added connect_all_cust_addr attribute and modified Get_Customer_Addr_Primary___(), Check_Values___(),Prepare_Insert___(), Get_Secondary_Contact_Id(),
--  170517          Copy_Customer(), Check_Default_Values(), Check_Insert___(), Get_Contact_Values(), Validate_Customer_Address(), Get_Guid_By_Cust_Address(), Get_Customer_Contact_Info() 
--  170517          methods and added Check_Common___(), Validate_Customer_Address___() method to reflect the changes of new attribute.
--  170403  KoDelk  STRSC-6363, Rename BusinessObjectRep to BusObjRepresentative
--  170329  SudJlk  STRSC-6857, Changed the conditional compilation from CRM to RMCOM in the earlier correction.
--  170328  JanWse  STRSC-6857, Wrapped declaration of representative_id_ with a conditional $IF
--  170324  JanWse  VAULT-2449, Add logged in user as a representative when inserting a new record (only if logged on user is a representative)
--  160404  TiRalk  STRSC-1589, Override Check_Delete___ to validate existence of BusinessObjectContact record 
--  160404          for the customer when deleting.
--  150908  MaIklk  AFT-4018, Fixed to save contact address in New().
--  150825  MaRalk  BLU-1173, Modified Get_Contact_Values in order to fetch WWW value  
--  150819  AmThLK  Bug 124065,Modified Prepare_Insert___ , added else part for cinditional block , added default value for BLOCKED_FOR_CRM_OBJECTS
--  150825          when adding customer info contacts into Sales Quotation, Business Opportunity, Business Activity - Contacts tab.
--  150821  Wahelk  BLU-1097, Modified method Prepare_Insert___ and Check_Insert___ to add default values for BLOCKED_FOR_CRM_OBJECTS  
--  150820  MaRalk  BLU-1154, Modified method Insert__ by replacing the method call 
--  150820          Business_Object_Rep_API.New_Business_Object_Main_Rep with Business_Object_Rep_API.New_Business_Object_Rep. 
--  150813  Wahelk  BLU-1192,Modified Copy_Customer method to use newly created address id if same exist
--  150812  Wahelk  BLU-1192,Modified Copy_Customer method by adding new parameter copy_info_
--  150812  Wahelk  BLU-1191, Removed method Copy_Customer_Def_Address
--  150806  MaIklk  BLU-1135, Added Get_Key_By_Objid() and Removed duplicated Modify().
--  150729  Wahelk  BLU-1094, Modified Update___ to add record to BUSINESS_OBJECT_REP in CRM
--  150708  Wahelk  BLU-956, Added new method Copy_Customer_Def_Address
--  150603  Wahelk  BLU-721, Modified method Get_Customer_Contact_Info
--  150602  JanWse  BLU-738, Removed an orphan public Modify method
--  150601  Wahelk  BLU-722, Added method Get_Customer_Contact_info method
--  150529  JanWse  BLU-738, Changed public method Modify to use objid as key
--  150527  JanWse  BLU-736, Moved all functionallity for Multi Edit to CRM/MultiEditUtil and created a new public Modify method
--  150525  JanWse  BLU-736, Added functionallity for append or replace multiple choice
--  150525  RoJalk  ORA-161, Modified Get_Primary_Contact_Id_Addr and added a check to see if address_id_ is NULL.
--  150520  JanWse  BLU-755, Added method Modify_Multiple___ and Modify_Multiple
--  150519  MaIklk  BLU-666, Added Modify().
--  150519  RoJalk  ORA-161, Added the method Get_Primary_Contact_Id_Addr, Get_Customer_Addr_Primary___ and
--  150519          Get_Customer_Primary___. Redirected the common logic in Get_Primary_Contact_Id. 
--  150505  Maabse  BLU-644, Added Write_Note_Excel__
--  150420  Maabse  BLU-534, Added Validate_Person_Id
--  150224  MaRalk  PRSC-6264, Modified Check_Update___ in order to aviod setting same two contact records 
--  150224          being manager to each other.
--  150216  MaIklk  PRSC-5860, Handled to copy contact managers at last in copy customers.
--  150207  MaRalk  PRSC-6005, Added method Exist_As_Manager and modified Check_Update___ to restrict updating 
--  150207          customer address when it is used as a manager customer address.
--  150127  Maabse  PRSC-5579, Added Get_objid and Get_Doc_Object_Description
--  150123  MaRalk  PRSC-5384, Modified method Create_Contact in order to facilitate retrieving Initials 
--  150123          which comes from Customer Contact - Add Contact dialog.
--  141107  MaRalk  PRSC-3112, Removed parameter convert_customer_ from Copy_Customer method.
--  141028  MaRalk  PRSC-3971, Modified Get_Contact_Values in order to fetch client values for the Role 
--  141028          column when adding customer info contact as a contact entry.
--  141015  JanWse  PRSC-2933, Modified Create_Contact to handle NOTE_TEXT as a CLOB
--  140916  JanWse  PRSC-2365, Modified Create_Contact to support user defined PERSON_ID
--  140710  MaIklk  PRSC-1761, Implemented to preserve records if customer is existing in copy_customer().
--  140623  MaRalk  PRSC-1291, Modified Customer_Contact_Role_API usages as Contact_Role_API.
--  140526  MaRalk  PBSC-8831, Modified method Create_Contact in order to facilitate retrieving first, middle, last names
--  140526          which comes from Customer Contact - Add Contact dialog.
--  140523  MaIklk  PBSC-8864, Added Main rep in Prepare_Insert().
--  140401  MaRalk  PBSC-6408, Modified method New by adding CRM specific attributes to the attribute string.
--  140324  MaRalk  PBSC-6408, Changed parameter to the method Create_Contact  as IN OUT in order to use in 
--  140324          Business_Object_Contact_API - Create_Contact__ method.
--  140321  MaIklk  PBSC-7889, Added condition to check blocked for use person when copy customer.
--  140214  Maabse  Return GUID in Insert___. Needed when adding representative directly after creating contact
--  140205  Maabse  Modified parameters to Modify_Main_Representative to enable remove of main representative
--  140203  Maabse  Modified parameters to Modify_Main_Representative
--  121224  MaRalk  PBSC-5405, Override method Check_Customer_Id_Ref___.
--  131029  MaRalk  PBR-1914, Modified method Create_Contact to support new attributes coming from Add Contact dialog. 
--  131014  MaIklk  Implemented to handle representatives.
--  131017  Isuklk  CAHOOK-2771 Refactoring in CustomerInfoContact.entity.
--  131009  MaRalk  PBR-1751, Added columns customer_address, role, department, manager, blocked_for_crm_objects_db columns to
--  131009          the view CONTACT_CUSTOMER in order to display in Person-Contact for Customer child table. Added validation to avoid setting
--  131009          same person as the manager.
--  131008  MaRalk  PBR-1621, Added Is_Customer_Contact function.
--  130604  MaIklk  Added Get_Guid_By_Cust_Address__() and Check_Manager__().
--  130530  MaRalk  PBR-1624, Added method Modify_Blocked_For_Crm_Objects.
--  130529  MaIklk  Added new columns personal_interest, campaign_interest, decision_power_type and department related to CRM.
--  130528  MaRalk  PBR-1614, Added public attribte Blocked_For_Crm_Objects and modified relevant methods.  
--  130520  MaRalk  PBR-1605, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to 
--  130520          avoid saving customer contacts where person is not a customer contact.
--  130206  MaRalk  PBR-1203, Modified Unpack_Check_Insert___ by adding customer category to Customer_Info_API.Exist method call.
--  130115  MaRalk  PBR-1203, Replaced CUSTOMER_INFO with CUSTOMER_INFO_CUSTCATEGORY_PUB in CUSTOMER_INFO_CONTACT_LOV view definition. 
--  121012  MaIklk  Added Exist_Contact().
--  120925  MaIklk  Added new LOV view called CUSTOMER_INFO_CONTACT_LOV2. 
--  111130  Chgulk  SFI-970, Merged the Bug 99792
--  100216  SJayLK  Bug 88807, Modified Check_Values___, Added Check_Default_Values
--  091111  Yothlk  Bug 86911, Modified ViewComments.Added no check in ref part
--  081128  Hiralk  Bug 78907, Modified Copy_Customer(). Increased the buffer size to 32000
--  070919  Lisvse  Added procedure Copy_Customer
--  070829  AmPalk  Modified Create_Contact by adding new attribute to the new_attr_string. TITLE, WWW, MESSENGER, INTERCOM and PAGER.
--  070404  ToBeSe  Created
--  190206  ThJilk  Removed check for Fndab1.
--  210202  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in methods Modify_Main_Representative and Modify_Blocked_For_Crm_Objects
--  210303  Hecolk  FISPRING20-9407, Rolled-back changes of FISPRING20-8730 as method Update___ has string manupulation logic that cannot be removed at the moment   
--  210710  Smallk  FI21R2-2313, Merged LCS bug 159691, modified Insert___() and Update___(). Moved logic from validate action of CustomerInfoContact in CustomerHandling.projection.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE contact_manager_rec IS RECORD(
     person_id              VARCHAR2(30),
     customer_address       VARCHAR2(50),
     manager                VARCHAR2(30),
     manager_cust_addr      VARCHAR2(50));
      
TYPE contact_manager_table IS TABLE OF contact_manager_rec INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Customer_Address___ (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 )
IS
   CURSOR validate_primary IS
      SELECT NVL(COUNT(*), 0)
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    address_primary = 'TRUE'
      AND    ((customer_address = address_id_) OR connect_all_cust_addr = 'TRUE');
   CURSOR validate_secondary IS
      SELECT NVL(COUNT(*), 0)
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    address_secondary = 'TRUE'
      AND    ((customer_address = address_id_) OR connect_all_cust_addr = 'TRUE');
      dummy_ NUMBER;
BEGIN
   OPEN validate_primary;
   FETCH validate_primary INTO dummy_;
   CLOSE validate_primary;
   IF (dummy_ > 1) THEN
      Error_SYS.Record_General(lu_name_,
                               'ERR_DUPLICATE2: The :P1 check box can be selected for only one contact per customer address ID.',
                               Language_SYS.Translate_Item_Prompt_(lu_name_ => lu_name_,
                                                                   item_    => 'ADDRESS_PRIMARY'));
   END IF;
   OPEN validate_secondary;
   FETCH validate_secondary INTO dummy_;
   CLOSE validate_secondary;
   IF (dummy_ > 1) THEN
      Error_SYS.Record_General(lu_name_,
                               'ERR_DUPLICATE2: The :P1 check box can be selected for only one contact per customer address ID.',
                               Language_SYS.Translate_Item_Prompt_(lu_name_ => lu_name_,
                                                                   item_    => 'ADDRESS_SECONDARY'));
   END IF;
END Validate_Customer_Address___;


FUNCTION Get_Customer_Addr_Primary___ (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR customer_address_primary IS
      SELECT person_id
      FROM   customer_info_contact
      WHERE  address_primary = 'TRUE'
      AND    customer_id = customer_id_
      AND    ((customer_address = address_id_) OR 
              (customer_address IS NULL AND connect_all_cust_addr = 'TRUE'));
   person_id_  person_info_tab.person_id%TYPE;
BEGIN
   OPEN customer_address_primary;
   FETCH customer_address_primary INTO person_id_;
   CLOSE customer_address_primary;
   RETURN person_id_;
END Get_Customer_Addr_Primary___;

   
FUNCTION Get_Customer_Primary___ (
   customer_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR customer_primary IS
      SELECT person_id
      FROM   customer_info_contact
      WHERE  customer_primary = 'TRUE'
      AND    customer_id = customer_id_;
   person_id_  person_info_tab.person_id%TYPE;
BEGIN   
   OPEN customer_primary;
   FETCH customer_primary INTO person_id_;
   CLOSE customer_primary;
   RETURN person_id_;
END Get_Customer_Primary___;

   
PROCEDURE Check_Values___ (
   newrec_ IN customer_info_contact_tab%ROWTYPE,
   objid_ IN VARCHAR2 )
IS
   CURSOR check_duplicate_customer(customer_id_ VARCHAR2, person_id_ VARCHAR2) IS
      SELECT 1
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    person_id = person_id_
      AND    ROWID||'' <> NVL(objid_,CHR(0))
      AND    customer_address IS NULL;
   CURSOR check_duplicate_address(customer_id_ VARCHAR2, person_id_ VARCHAR2, customer_address_ VARCHAR2 DEFAULT NULL) IS
      SELECT 1
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    person_id = person_id_
      AND    customer_address = customer_address_
      AND    ROWID||'' <> NVL(objid_,CHR(0));
   dummy_    INTEGER;
BEGIN 
   -- Address Defaults
   IF (newrec_.customer_address IS NOT NULL) THEN
      -- Only one Person allowed for each customer, customer address combination.
      OPEN check_duplicate_address(newrec_.customer_id, newrec_.person_id,newrec_.customer_address);
      FETCH check_duplicate_address INTO dummy_;
      IF (check_duplicate_address%FOUND) THEN
         CLOSE check_duplicate_address;
         Error_SYS.Record_General(lu_name_, 'ERR_DUPLICATE: A Person can only be conncted once per customer address and once without address.');
      END IF;
      CLOSE check_duplicate_address;
   -- Customer defaults
   ELSE
      -- Only one Person allowed for each customer, when no customer address set.
      OPEN check_duplicate_customer(newrec_.customer_id, newrec_.person_id);
      FETCH check_duplicate_customer INTO dummy_;
      IF (check_duplicate_customer%FOUND) THEN
         CLOSE check_duplicate_customer;
         Error_SYS.Record_General(lu_name_, 'ERR_DUPLICATE: A Person can only be conncted once per customer address and once without address.');
      END IF;
      CLOSE check_duplicate_customer;
      -- Address defaults only allowed if customer address set
      IF ('TRUE' IN (newrec_.address_primary, newrec_.address_secondary) AND newrec_.connect_all_cust_addr = Fnd_Boolean_API.DB_FALSE) THEN
         Error_SYS.Record_General(lu_name_, 'ERR_NO_CUST_ADDRESS: Customer address must be set.');
      END IF;
   END IF;
END Check_Values___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     customer_info_contact_tab%ROWTYPE,
   newrec_ IN OUT customer_info_contact_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.connect_all_cust_addr = Fnd_Boolean_API.DB_TRUE AND newrec_.customer_address IS NOT NULL AND oldrec_.customer_address = newrec_.customer_address) THEN
      Error_SYS.Record_General(lu_name_, 'CONNALLWITHCUSTADDR: Connect all customer addresses checkbox cannot be selected when a customer address is specified.');
   ELSIF (newrec_.connect_all_cust_addr = Fnd_Boolean_API.DB_TRUE AND newrec_.customer_address IS NOT NULL ) THEN
      Error_SYS.Record_General(lu_name_, 'CONNALLWITHCUSTADDR2: Cannot specify a customer address when the connect all customer addresses checkbox is selected.');
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
   Client_SYS.Add_To_Attr('CUSTOMER_PRIMARY', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_SECONDARY', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('BLOCKED_FOR_CRM_OBJECTS_DB', Fnd_Boolean_API.DB_FALSE, attr_); 
   Client_SYS.Add_To_Attr('CONNECT_ALL_CUST_ADDR_DB', Fnd_Boolean_API.DB_FALSE, attr_);
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
   newrec_     IN OUT customer_info_contact_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   $IF Component_Rmcom_SYS.INSTALLED $THEN    
      representative_id_   bus_obj_representative_tab.representative_id%TYPE;
   $END
BEGIN
   Check_Values___(newrec_, NULL);
   super(objid_, objversion_, newrec_, attr_);
   -- Moved logic from validate action of CustomerInfoContact in CustomerHandling.projection. Please do not move to Check_Common___.
   Check_Default_Values(newrec_.customer_id, NULL);
   Client_SYS.Add_To_Attr('GUID', newrec_.guid, attr_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Insert___(newrec_);
      Rm_Dup_Check_For_Duplicate___(attr_, newrec_);
      representative_id_ := Person_Info_API.Get_Id_For_User(Fnd_Session_API.Get_Fnd_User);
      IF (representative_id_ != newrec_.main_representative_id) THEN
         -- Only if the user is a representative add as representative
         IF (Business_Representative_API.Exists(representative_id_) = FALSE) THEN
            representative_id_ := NULL;
         END IF;
         -- Add "inserting" user if not already present
         IF (representative_id_ IS NOT NULL AND Bus_Obj_Representative_API.Exists_Db(newrec_.guid, Business_Object_Type_API.DB_CUSTOMER_CONTACT, representative_id_) = FALSE) THEN
            Bus_Obj_Representative_API.New_Bus_Obj_Representative(newrec_.guid, Business_Object_Type_API.DB_CUSTOMER_CONTACT, representative_id_, Fnd_Boolean_API.DB_FALSE);
         END IF;
      END IF;
      IF (newrec_.main_representative_id IS NOT NULL) THEN
         -- Insert main representative. 
         Bus_Obj_Representative_API.New_Bus_Obj_Representative(newrec_.guid, Business_Object_Type_API.DB_CUSTOMER_CONTACT, newrec_.main_representative_id, Fnd_Boolean_API.DB_TRUE);
      END IF;
   $END
   $IF Component_Crm_SYS.INSTALLED $THEN    
      Crm_Cust_Info_History_API.Log_Interaction(newrec_); 
      -- If a address is connected to contact add it to contact journal
      IF (newrec_.customer_address IS NOT NULL) THEN
         Crm_Cust_Info_Cont_History_API.Log_History(NULL, newrec_, 'CUSTOMER_ADDRESS');
      END IF;
   $END
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     customer_info_contact_tab%ROWTYPE,
   newrec_     IN OUT customer_info_contact_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Check_Values___(newrec_, objid_);   
   newrec_.changed := SYSDATE;
   newrec_.changed_by := Fnd_Session_API.Get_Fnd_User; 
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Moved logic from validate action of CustomerInfoContact in CustomerHandling.projection. Please do not move to Check_Common___.
   Check_Default_Values(newrec_.customer_id, NULL);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Update___(newrec_);
      Rm_Dup_Check_For_Duplicate___(attr_, newrec_);
      IF (Client_SYS.Get_Item_Value('UPDATE_MAIN_REP', attr_) = Fnd_Boolean_API.DB_TRUE) THEN  
         IF (Validate_SYS.Is_Changed(oldrec_.main_representative_id, newrec_.main_representative_id)) THEN
            -- Insert main representative.          
            Bus_Obj_Representative_API.Modify_Object_Main_Rep(newrec_.guid, Business_Object_Type_API.DB_CUSTOMER_CONTACT, newrec_.main_representative_id, Fnd_Boolean_API.DB_TRUE);
         END IF;
      END IF;
      $IF Component_Crm_SYS.INSTALLED $THEN
         Log_Column_Changes___(oldrec_, newrec_);
      $END
   $END
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_info_contact_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS      
BEGIN
   newrec_.guid := sys_guid();
   newrec_.created := SYSDATE;
   newrec_.created_by := Fnd_Session_API.Get_Fnd_User;
   newrec_.changed := SYSDATE;
   newrec_.changed_by := Fnd_Session_API.Get_Fnd_User; 
   IF (newrec_.blocked_for_crm_objects IS NULL) THEN      
      newrec_.blocked_for_crm_objects := Fnd_Boolean_API.DB_FALSE;
   END IF;   
   IF (newrec_.connect_all_cust_addr IS NULL) THEN
      newrec_.Connect_all_cust_addr := Fnd_Boolean_API.DB_FALSE;
   END IF;
   super(newrec_, indrec_, attr_);
   IF (newrec_.person_id IS NOT NULL) THEN
      IF (Person_Info_API.Get_Customer_Contact_Db(newrec_.person_id) = Fnd_Boolean_API.DB_FALSE) THEN 
         Error_SYS.Record_General(lu_name_, 'NOTCUSTOMERCONTACT: The person :P1 you entered has not been specified as a customer contact.', newrec_.person_id);
      ELSIF (Person_Info_API.Get_Blocked_For_Use_Db(newrec_.person_id) = Fnd_Boolean_API.DB_TRUE) THEN
         Error_SYS.Record_General(lu_name_, 'CUSTOMERCONTACTBLOCKED: The person :P1 you entered has been blocked for use.', newrec_.person_id);       
      END IF;
   END IF;
   IF (newrec_.manager IS NOT NULL) THEN
      IF (newrec_.person_id = newrec_.manager) THEN
         Error_SYS.Record_General(lu_name_, 'SAMEPERSONNOTALLOWEDASMAN: The same person cannot be specified as a manager.');
      END IF;   
      IF (NOT Check_Exist___(newrec_.customer_id, newrec_.manager, newrec_.manager_guid)) THEN
         IF (newrec_.manager_cust_address IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'MANAGERNOTEXIST: The Manager :P1 of Customer Address :P2 does not exist as a contact for Customer :P3.', newrec_.manager, newrec_.manager_cust_address, newrec_.customer_id);            
         ELSE
            Error_SYS.Record_General(lu_name_, 'MANAGERNOTEXIST2: The Manager :P1 does not exist as a contact for Customer :P2.', newrec_.manager, newrec_.customer_id);
         END IF;
      END IF;
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_info_contact_tab%ROWTYPE,
   newrec_ IN OUT customer_info_contact_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   manager_cust_addr_ customer_info_contact_tab.manager_cust_address%TYPE;
   err_text_1_        VARCHAR2(2000);
   err_text_2_        VARCHAR2(2000);
BEGIN      
   super(oldrec_, newrec_, indrec_, attr_); 
   IF (newrec_.manager IS NOT NULL AND 
      (Validate_SYS.Is_Changed(oldrec_.manager, newrec_.manager) OR Validate_SYS.Is_Changed(oldrec_.manager_cust_address, newrec_.manager_cust_address))) THEN   
      IF (newrec_.person_id = newrec_.manager) THEN
         Error_SYS.Record_General(lu_name_, 'SAMEPERSONNOTALLOWEDASMAN: The same person cannot be specified as a manager.');
      END IF;
      IF (NOT Check_Exist___(newrec_.customer_id, newrec_.manager, newrec_.manager_guid)) THEN
         IF (newrec_.manager_cust_address IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'MANAGERNOTEXIST: The Manager :P1 of Customer Address :P2 does not exist as a contact for Customer :P3.', newrec_.manager, newrec_.manager_cust_address, newrec_.customer_id);            
         ELSE
            Error_SYS.Record_General(lu_name_, 'MANAGERNOTEXIST3: The Manager :P1 of Customer Address (empty) does not exist as a contact for Customer :P2.', newrec_.manager, newrec_.customer_id);            
         END IF;
      END IF; 
      -- Aviod setting same two contact records being manager to each other.
      manager_cust_addr_ := Get_Manager_Cust_Address(newrec_.customer_id, newrec_.manager, newrec_.manager_guid);        
      IF ((Get_Manager(newrec_.customer_id, newrec_.manager, newrec_.manager_guid) = newrec_.person_id)  AND
         ((manager_cust_addr_ IS NULL AND newrec_.customer_address IS NULL) OR
         ((manager_cust_addr_ IS NOT NULL AND newrec_.customer_address IS NOT NULL) AND (manager_cust_addr_ = newrec_.customer_address)))) THEN    
         err_text_1_ := Language_SYS.Translate_Constant (lu_name_,
                                                         'INVALIDMANAGER1: The person :P1 and address :P2 combination that you are trying to specify as manager already have person ',
                                                         NULL,
                                                         newrec_.manager,
                                                         NVL(newrec_.manager_cust_address, '(empty)'));
         err_text_2_ := Language_SYS.Translate_Constant (lu_name_,
                                                         'INVALIDMANAGER2: :P1 and address :P2 as manager. Therefore this combination is not allowed.',
                                                         NULL,
                                                         newrec_.person_id,
                                                         NVL(newrec_.customer_address, '(empty)'));
         Error_SYS.Record_General(lu_name_, 'INVALIDMANAGER3: :P1 :P2', err_text_1_, err_text_2_);
      END IF; 
   END IF;
   IF (Validate_SYS.Is_Changed(oldrec_.customer_address, newrec_.customer_address)) THEN
      IF (Exist_As_Manager(newrec_.customer_id, newrec_.person_id, oldrec_.customer_address)) THEN
         Error_SYS.Record_General(lu_name_, 'USEDASAMANAGER: Cannot modify customer address when the contact is used as a manager.');            
      END IF;
   END IF;  
END Check_Update___;

   
PROCEDURE Check_Customer_Id_Ref___ (
   newrec_ IN OUT customer_info_contact_tab%ROWTYPE )
IS
   customer_category_   customer_info_tab.customer_category%TYPE;
BEGIN
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_id);
   Customer_Info_API.Exist(newrec_.customer_id, customer_category_);
END Check_Customer_Id_Ref___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN customer_info_contact_tab%ROWTYPE )
IS
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      -- Remove the representatives
      Bus_Obj_Representative_API.Remove(remrec_.guid, Business_Object_Type_API.DB_CUSTOMER_CONTACT);
   $END
   super(objid_, remrec_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Delete___(remrec_);
   $ELSE
      NULL;
   $END
   $IF Component_Crm_SYS.INSTALLED $THEN 
      -- Add a record to Account-CRM journal when a contact is deleted.
      Crm_Cust_Info_History_API.Log_Remove_Contact(remrec_); 
   $END
END Delete___;


PROCEDURE Copy_Manager___ (
   new_id_                IN VARCHAR2,
   contact_manager_tab_   IN contact_manager_table)
IS
   newrec_                   customer_info_contact_tab%ROWTYPE;
   oldrec_                   customer_info_contact_tab%ROWTYPE; 
   attr_                     VARCHAR2(32000);
   objid_                    customer_info_contact.objid%TYPE;
   objversion_               customer_info_contact.objversion%TYPE;
   indrec_                   Indicator_Rec;  
   contact_guid_             customer_info_contact_tab.guid%TYPE;
   manager_guid_             customer_info_contact_tab.guid%TYPE; 
BEGIN
   IF (contact_manager_tab_.COUNT > 0) THEN
      FOR j_ IN contact_manager_tab_.FIRST..contact_manager_tab_.LAST LOOP
         contact_guid_ := Get_Guid_By_Cust_Address(new_id_, contact_manager_tab_(j_).person_id, contact_manager_tab_(j_).customer_address);
         manager_guid_ := Get_Guid_By_Cust_Address(new_id_, contact_manager_tab_(j_).manager, contact_manager_tab_(j_).manager_cust_addr);
         IF (contact_guid_ IS NOT NULL AND manager_guid_ IS NOT NULL) THEN
            oldrec_ := Lock_By_Keys___(new_id_, contact_manager_tab_(j_).person_id, contact_guid_);
            newrec_ := oldrec_;             
            newrec_.manager              := contact_manager_tab_(j_).manager;
            newrec_.manager_cust_address := contact_manager_tab_(j_).manager_cust_addr;
            newrec_.manager_guid         := manager_guid_;            
            Get_Id_Version_By_Keys___(objid_, objversion_, new_id_, contact_manager_tab_(j_).person_id, contact_guid_);
            Check_Update___(oldrec_, newrec_, indrec_, attr_);
            Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); 
         END IF;
      END LOOP;
   END IF;
   
END Copy_Manager___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN customer_info_contact_tab%ROWTYPE )
IS   
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN      
      Business_Object_Contact_API.Check_Contact(remrec_.customer_id, 'CUSTOMER', remrec_.person_id, remrec_.guid);                  
   $END
   super(remrec_);
END Check_Delete___;


PROCEDURE Log_Column_Changes___ (
   oldrec_     IN customer_info_contact_tab%ROWTYPE,
   newrec_     IN customer_info_contact_tab%ROWTYPE )
IS
   old_attr_  VARCHAR2(32000):= Pack_Table___(oldrec_);
   new_attr_  VARCHAR2(32000):= Pack_Table___(newrec_);
   name_      VARCHAR2(50);
   new_value_ VARCHAR2(4000);
   old_value_ VARCHAR2(4000);
   ptr_      NUMBER;
BEGIN
   $IF Component_Crm_SYS.INSTALLED $THEN      
      WHILE (Client_SYS.Get_Next_From_Attr(new_attr_, ptr_, name_, new_value_)) LOOP
         IF (Business_Object_Columns_API.Exists_Customer_Info_Con_Db(name_)) THEN
            old_value_ := Client_SYS.Get_Item_Value(name_, old_attr_);
            IF (Validate_SYS.Is_Different(old_value_, new_value_)) THEN
               Crm_Cust_Info_Cont_History_API.Log_History(oldrec_, newrec_, name_);
            END IF;         
         END IF;
      END LOOP;
   $ELSE
      NULL;
   $END
END Log_Column_Changes___;


PROCEDURE Rm_Dup_Insert___ (
   rec_  IN customer_info_contact_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Insert(lu_name_, attr_);
   $ELSE
      NULL;
   $END
END Rm_Dup_Insert___;


PROCEDURE Rm_Dup_Update___ (
   rec_  IN customer_info_contact_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Update(lu_name_, attr_);
   $ELSE 
      NULL;
   $END
END Rm_Dup_Update___;


PROCEDURE Rm_Dup_Delete___ (
   rec_  IN customer_info_contact_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Delete(lu_name_, attr_);
   $ELSE 
      NULL;
   $END
END Rm_Dup_Delete___;


PROCEDURE Rm_Dup_Check_For_Duplicate___ (
   attr_ IN OUT VARCHAR2,
   rec_  IN     customer_info_contact_tab%ROWTYPE )
IS
   dup_attr_   VARCHAR2(32000);
   dup_action_ VARCHAR2(50) := 'DUPLICATE_ACTION';
   dup_keys_   VARCHAR2(50) := 'DUPLICATE_KEYS';
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      dup_attr_ := Pack_Table___(rec_);
      Rm_Dup_Util_API.Check_For_Duplicate(dup_attr_, lu_name_);
      IF (Client_SYS.Item_Exist(dup_action_, dup_attr_)) THEN 
         Client_SYS.Add_To_Attr(dup_action_, Client_SYS.Get_Item_Value(dup_action_, dup_attr_), attr_);
      END IF;
      IF (Client_SYS.Item_Exist(dup_keys_, dup_attr_)) THEN 
         Client_SYS.Add_To_Attr(dup_keys_, Client_SYS.Get_Item_Value(dup_keys_, dup_attr_), attr_);
      END IF;
   $ELSE
      NULL;
   $END
END Rm_Dup_Check_For_Duplicate___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Manager__
--   Checks if the Contact exists as a manager. If found, print an error message.
--   Used for restricted delete check when removing an contact.
PROCEDURE Check_Manager__ (
   key_list_ IN VARCHAR2 )
IS
   customer_id_   customer_info_contact_tab.customer_id%TYPE;
   contact_id_    customer_info_contact_tab.manager%TYPE;
   guid_          customer_info_contact_tab.manager_guid%TYPE;
   count_         NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    manager = contact_id_
      AND    manager_guid = guid_;
BEGIN
   customer_id_ := SUBSTR(key_list_, 1, INSTR(key_list_, '^') - 1);
   contact_id_ := SUBSTR(key_list_, INSTR(key_list_, '^') + 1, INSTR(key_list_, '^' , 1, 2) - (INSTR(key_list_, '^') + 1));
   guid_ := SUBSTR(key_list_, INSTR(key_list_, '^' , 1, 2) + 1, INSTR(key_list_, '^' , 1, 3) - (INSTR(key_list_, '^' , 1, 2) + 1));
   OPEN exist_control;
   FETCH exist_control INTO count_;
   IF (exist_control%NOTFOUND) THEN
      count_ := 0;
   END IF;
   CLOSE exist_control;
   IF (count_ <> 0) THEN
      Error_SYS.Record_General(lu_name_, 'CONTACTEXIST: The Customer Info Contact :P1 is used as a manager by :P2 row(s).', contact_id_, count_);
   END IF;
END Check_Manager__;


-- Write_Note_Excel__
--   Similar to Write_Note_Text__, but uses VARCHAR2 parameters so it can be used by Excel Add-In migration jobs.
PROCEDURE Write_Note_Excel__ (
   objversion_ IN OUT VARCHAR2,
   objid_      IN     VARCHAR2,
   note_       IN     VARCHAR2 )
IS
   rec_ customer_info_contact_tab%ROWTYPE;
BEGIN
   rec_ := Lock_By_Id___(objid_, objversion_);
   UPDATE customer_info_contact_tab
   SET note_text = note_,
       rowversion = SYSDATE
   WHERE ROWID = objid_
   RETURNING rowversion INTO rec_.rowversion;
   objversion_ := TO_CHAR(rec_.rowversion,'YYYYMMDDHH24MISS');
END Write_Note_Excel__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Contact (
   attr_ IN OUT VARCHAR2,
   note_text_ IN CLOB)
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   new_attr_   VARCHAR2(2000);

   person_id_        person_info_tab.person_id%TYPE;
   customer_id_      customer_info_tab.customer_id%TYPE;
   customer_address_ customer_info_address_tab.address_id%TYPE;
   guid_             customer_info_contact_tab.guid%TYPE;  
BEGIN
   customer_id_ := Client_SYS.Get_Item_Value('CUSTOMER_ID', attr_);
   customer_address_ := Client_SYS.Get_Item_Value('CUSTOMER_ADDRESS', attr_);
   -- Create new Contact/Person
   Client_SYS.Clear_Attr(new_attr_);
   IF (Client_SYS.Get_Item_Value('PERSON_ID', attr_) IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PERSON_ID', Client_SYS.Get_Item_Value('PERSON_ID', attr_), new_attr_);
   END IF;
   Client_SYS.Add_To_Attr('FIRST_NAME', Client_SYS.Get_Item_Value('FIRST_NAME', attr_), new_attr_);
   Client_SYS.Add_To_Attr('MIDDLE_NAME', Client_SYS.Get_Item_Value('MIDDLE_NAME', attr_), new_attr_);
   Client_SYS.Add_To_Attr('LAST_NAME', Client_SYS.Get_Item_Value('LAST_NAME', attr_), new_attr_);
   Client_SYS.Add_To_Attr('NAME', Client_SYS.Get_Item_Value('NAME', attr_), new_attr_);
   Client_SYS.Add_To_Attr('PHONE', Client_SYS.Get_Item_Value('PHONE', attr_), new_attr_);
   Client_SYS.Add_To_Attr('FAX', Client_SYS.Get_Item_Value('FAX', attr_), new_attr_);
   Client_SYS.Add_To_Attr('MOBILE', Client_SYS.Get_Item_Value('MOBILE', attr_), new_attr_);
   Client_SYS.Add_To_Attr('E_MAIL', Client_SYS.Get_Item_Value('E_MAIL', attr_), new_attr_);
   Client_SYS.Add_To_Attr('TITLE', Client_SYS.Get_Item_Value('TITLE', attr_), new_attr_);
   Client_SYS.Add_To_Attr('JOB_TITLE', Client_SYS.Get_Item_Value('JOB_TITLE', attr_), new_attr_);
   Client_SYS.Add_To_Attr('INITIALS', Client_SYS.Get_Item_Value('INITIALS', attr_), new_attr_);
   Client_SYS.Add_To_Attr('WWW', Client_SYS.Get_Item_Value('WWW', attr_), new_attr_);
   Client_SYS.Add_To_Attr('MESSENGER', Client_SYS.Get_Item_Value('MESSENGER', attr_), new_attr_);
   Client_SYS.Add_To_Attr('INTERCOM', Client_SYS.Get_Item_Value('INTERCOM', attr_), new_attr_);
   Client_SYS.Add_To_Attr('PAGER', Client_SYS.Get_Item_Value('PAGER', attr_), new_attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_CONTACT_DB', Fnd_Boolean_API.DB_TRUE, new_attr_);
   Client_SYS.Add_To_Attr('BLOCKED_FOR_USE_DB', Fnd_Boolean_API.DB_FALSE, new_attr_);    
   Client_SYS.Add_To_Attr('CUSTOMER_ID', customer_id_, new_attr_);
   IF (Client_SYS.Get_Item_Value('COPY_ADDRESS', attr_) = 'TRUE' AND customer_address_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ADDRESS_ID', customer_address_, new_attr_);
   END IF;
   Contact_Util_API.Create_Contact(new_attr_);
   person_id_ := Client_SYS.Get_Item_Value('PERSON_ID', new_attr_);
   -- Create new CustomerInfoContact
   Client_SYS.Clear_Attr(new_attr_);
   -- Prepare
   New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
   Client_SYS.Add_To_Attr('CUSTOMER_ID', customer_id_, new_attr_);
   Client_SYS.Add_To_Attr('PERSON_ID', person_id_, new_attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_ADDRESS', customer_address_, new_attr_);
   Client_SYS.Add_To_Attr('ROLE_DB', Contact_Role_API.Encode_List(Client_SYS.Get_Item_Value('ROLE', attr_)), new_attr_);
   $IF Component_Crm_SYS.INSTALLED $THEN
      Client_SYS.Add_To_Attr('PERSONAL_INTEREST_DB', Personal_Interest_API.Encode_List(Client_SYS.Get_Item_Value('PERSONAL_INTEREST', attr_)), new_attr_);
      Client_SYS.Add_To_Attr('CAMPAIGN_INTEREST_DB', Business_Campaign_Interest_API.Encode_List(Client_SYS.Get_Item_Value('CAMPAIGN_INTEREST', attr_)), new_attr_);
      Client_SYS.Add_To_Attr('DECISION_POWER_TYPE_DB', Decision_Power_Type_API.Encode(Client_SYS.Get_Item_Value('DECISION_POWER_TYPE', attr_)), new_attr_);
      Client_SYS.Add_To_Attr('DEPARTMENT_DB', Contact_Department_API.Encode(Client_SYS.Get_Item_Value('DEPARTMENT', attr_)), new_attr_);
      Client_SYS.Add_To_Attr('MANAGER', Client_SYS.Get_Item_Value('MANAGER', attr_), new_attr_);
      Client_SYS.Add_To_Attr('MANAGER_CUST_ADDRESS', Client_SYS.Get_Item_Value('MANAGER_CUST_ADDRESS', attr_), new_attr_);
      Client_SYS.Add_To_Attr('MANAGER_GUID', Client_SYS.Get_Item_Value('MANAGER_GUID', attr_), new_attr_);
      Client_SYS.Add_To_Attr('BLOCKED_FOR_CRM_OBJECTS_DB', Client_SYS.Get_Item_Value('BLOCKED_FOR_CRM_OBJECTS_DB', attr_), new_attr_); 
   $END
   -- Modify values that might be set
   Contact_Util_API.Modify_Item_Value('ADDRESS_PRIMARY', Client_SYS.Get_Item_Value('ADDRESS_PRIMARY', attr_), new_attr_);
   Contact_Util_API.Modify_Item_Value('ADDRESS_SECONDARY', Client_SYS.Get_Item_Value('ADDRESS_SECONDARY', attr_), new_attr_);
   Contact_Util_API.Modify_Item_Value('CUSTOMER_PRIMARY', Client_SYS.Get_Item_Value('CUSTOMER_PRIMARY', attr_), new_attr_);
   Contact_Util_API.Modify_Item_Value('CUSTOMER_SECONDARY', Client_SYS.Get_Item_Value('CUSTOMER_SECONDARY', attr_), new_attr_);
   New__(info_, objid_, objversion_, new_attr_, 'DO');
   Write_Note_Text__(objversion_, objid_, note_text_);
   guid_ := Client_SYS.Get_Item_Value('GUID', new_attr_);   
   -- Copy address to the person and set it as contact address.
   IF (Client_SYS.Get_Item_Value('COPY_ADDRESS', attr_) = 'TRUE' AND customer_address_ IS NOT NULL) THEN
      Client_SYS.Clear_Attr(new_attr_);
      Client_SYS.Add_To_Attr('CONTACT_ADDRESS', customer_address_, new_attr_);
      Modify__(info_, objid_, objversion_, new_attr_, 'DO');
   END IF;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_ID', customer_id_, attr_);
   Client_SYS.Add_To_Attr('PERSON_ID', person_id_, attr_);
   Client_SYS.Add_To_Attr('GUID', guid_, attr_);   
END Create_Contact;


PROCEDURE New (
   customer_id_      IN VARCHAR2,
   person_id_        IN VARCHAR2,
   note_text_        IN CLOB,
   customer_address_ IN VARCHAR2 DEFAULT NULL,
   attr_             IN VARCHAR2 DEFAULT NULL )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   new_attr_   VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(new_attr_);
   New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
   Client_SYS.Add_To_Attr('CUSTOMER_ID', customer_id_, new_attr_);
   Client_SYS.Add_To_Attr('PERSON_ID', person_id_, new_attr_);
   IF (customer_address_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_ADDRESS', customer_address_, new_attr_);
      -- Copy address to the person and set it as contact address.
      IF (Client_SYS.Get_Item_Value('COPY_ADDRESS', attr_) = 'TRUE') THEN
         Contact_Util_API.Copy_Customer_Address(person_id_, customer_id_, customer_address_);
         Client_SYS.Add_To_Attr('CONTACT_ADDRESS', customer_address_, new_attr_);
      END IF;
   END IF;
   -- Extra Attributes
   Client_SYS.Add_To_Attr('ROLE_DB', Contact_Role_API.Encode_List(Client_SYS.Get_Item_Value('ROLE', attr_)), new_attr_);   
   IF (NOT Client_SYS.Item_Exist('CONTACT_ADDRESS', new_attr_)) THEN
      Client_SYS.Add_To_Attr('CONTACT_ADDRESS', Client_SYS.Get_Item_Value('CONTACT_ADDRESS', attr_), new_attr_);
   END IF;
   $IF Component_Crm_SYS.INSTALLED $THEN
      Client_SYS.Add_To_Attr('PERSONAL_INTEREST_DB', Personal_Interest_API.Encode_List(Client_SYS.Get_Item_Value('PERSONAL_INTEREST', attr_)), new_attr_);
      Client_SYS.Add_To_Attr('CAMPAIGN_INTEREST_DB', Business_Campaign_Interest_API.Encode_List(Client_SYS.Get_Item_Value('CAMPAIGN_INTEREST', attr_)), new_attr_);
      Client_SYS.Add_To_Attr('DECISION_POWER_TYPE_DB', Decision_Power_Type_API.Encode(Client_SYS.Get_Item_Value('DECISION_POWER_TYPE', attr_)), new_attr_);
      Client_SYS.Add_To_Attr('DEPARTMENT_DB', Contact_Department_API.Encode(Client_SYS.Get_Item_Value('DEPARTMENT', attr_)), new_attr_);
      Client_SYS.Add_To_Attr('MANAGER', Client_SYS.Get_Item_Value('MANAGER', attr_), new_attr_);
      Client_SYS.Add_To_Attr('MANAGER_CUST_ADDRESS', Client_SYS.Get_Item_Value('MANAGER_CUST_ADDRESS', attr_), new_attr_);
      Client_SYS.Add_To_Attr('MANAGER_GUID', Client_SYS.Get_Item_Value('MANAGER_GUID', attr_), new_attr_); 
      IF (Client_SYS.Item_Exist('BLOCKED_FOR_CRM_OBJECTS_DB', attr_)) THEN
         Client_SYS.Set_Item_Value('BLOCKED_FOR_CRM_OBJECTS_DB', Client_SYS.Get_Item_Value('BLOCKED_FOR_CRM_OBJECTS_DB', attr_), new_attr_); 
      END IF;
   $END
   New__(info_, objid_, objversion_, new_attr_, 'DO');
   Write_Note_Text__(objversion_, objid_, note_text_);
END New;
   

PROCEDURE Remove (
   customer_id_ IN VARCHAR2,
   person_id_   IN VARCHAR2,
   guid_        IN VARCHAR2)
IS
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
   remrec_      customer_info_contact_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, customer_id_, person_id_, guid_);
   remrec_ := Lock_By_Keys___(customer_id_, person_id_, guid_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;
   

PROCEDURE Modify_Main_Representative(
   guid_             IN VARCHAR2,
   rep_id_           IN VARCHAR2,
   remove_main_      IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
   oldrec_        customer_info_contact_tab%ROWTYPE;
   newrec_        customer_info_contact_tab%ROWTYPE;
   attr_          VARCHAR2(32000);
   objid_         customer_info_contact.objid%TYPE;
   objversion_    customer_info_contact.objversion%TYPE;
   found_         NUMBER;
   customer_id_   customer_info_contact_tab.customer_id%TYPE;
   person_id_     customer_info_contact_tab.person_id%TYPE;
   indrec_        Indicator_Rec;
   CURSOR check_main_rep IS
      SELECT COUNT(*)
      FROM   customer_info_contact_tab
      WHERE  guid = guid_
      AND    main_representative_id = rep_id_; 
   CURSOR get_rec IS
      SELECT customer_id, person_id
      FROM   customer_info_contact_tab
      WHERE  guid = guid_;
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      OPEN get_rec;
      FETCH get_rec INTO customer_id_, person_id_;
      CLOSE get_rec;
      IF (customer_id_ IS NOT NULL) THEN
         oldrec_ := Lock_By_Keys___(customer_id_, person_id_, guid_);
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
            Get_Id_Version_By_Keys___(objid_, objversion_, customer_id_, person_id_, guid_);
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
      FROM   customer_info_contact_tab
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
FUNCTION Get_Objid (
   customer_id_ IN VARCHAR2,
   person_id_   IN VARCHAR2,
   guid_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   objid_  VARCHAR2(200);
BEGIN
   IF (customer_id_ IS NULL OR person_id_ IS NULL OR guid_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT ROWID
      INTO  objid_
      FROM  customer_info_contact_tab
      WHERE customer_id = customer_id_
      AND   person_id = person_id_
      AND   guid = guid_;
   RETURN objid_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(customer_id_, person_id_, guid_, 'Get_Objid');
END Get_Objid;


@ObjectConnectionMethod
@UncheckedAccess
FUNCTION Get_Doc_Object_Description (
   customer_id_ IN VARCHAR2,
   person_id_   IN VARCHAR2,
   guid_        IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   --Return PERSON ID - Person Name (CUSTOMER ID)
   RETURN person_id_ ||' - ' || Person_Info_API.Get_Name(person_id_) ||'  (' || customer_id_ || ') ';
END Get_Doc_Object_Description;


@UncheckedAccess
FUNCTION Get_Primary_Contact_Id (
   customer_id_   IN VARCHAR2,
   address_id_    IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   person_id_  person_info_tab.person_id%TYPE;
BEGIN
   IF (address_id_ IS NOT NULL) THEN
      person_id_ := Get_Customer_Addr_Primary___(customer_id_, address_id_);
   ELSE
      person_id_ := Get_Customer_Primary___(customer_id_);
   END IF;
   RETURN person_id_;
END Get_Primary_Contact_Id;


@UncheckedAccess
FUNCTION Get_Primary_Contact_Id_Addr (
   customer_id_   IN VARCHAR2,
   address_id_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   person_id_  person_info_tab.person_id%TYPE;
BEGIN
   IF (address_id_ IS NOT NULL) THEN
      person_id_ := Get_Customer_Addr_Primary___(customer_id_, address_id_);
   END IF;
   IF (person_id_ IS NULL) THEN
      person_id_ := Get_Customer_Primary___(customer_id_);
   END IF;
   RETURN person_id_;
END Get_Primary_Contact_Id_Addr;


@UncheckedAccess
FUNCTION Get_Primary_Contact_Name (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN Person_Info_API.Get_Name(Get_Primary_Contact_Id(customer_id_, address_id_));
END Get_Primary_Contact_Name;


@UncheckedAccess
FUNCTION Get_Secondary_Contact_Id (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   CURSOR customer_secondary IS
      SELECT person_id
      FROM   customer_info_contact
      WHERE  customer_secondary = 'TRUE'
      AND    customer_id = customer_id_;
   CURSOR customer_address_secondary IS
      SELECT person_id
      FROM   customer_info_contact
      WHERE  address_secondary = 'TRUE'
      AND    customer_id = customer_id_
      AND    ((customer_address = address_id_) OR
               (customer_address IS NULL AND connect_all_cust_addr = 'TRUE'));
   person_id_   person_info_tab.person_id%TYPE;
BEGIN
   IF (address_id_ IS NOT NULL) THEN
      OPEN customer_address_secondary;
      FETCH customer_address_secondary INTO person_id_;
      CLOSE customer_address_secondary;
   ELSE
      OPEN customer_secondary;
      FETCH customer_secondary INTO person_id_;
      CLOSE customer_secondary;
   END IF;
   RETURN person_id_;
END Get_Secondary_Contact_Id;


@UncheckedAccess
FUNCTION Get_Secondary_Contact_Name (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN Person_Info_API.Get_Name(Get_Secondary_Contact_Id(customer_id_, address_id_));
END Get_Secondary_Contact_Name;


PROCEDURE Copy_Customer (
   customer_id_ IN VARCHAR2,
   new_id_      IN VARCHAR2,
   copy_info_   IN  Customer_Info_API.Copy_Param_Info)
IS
   newrec_                   customer_info_contact_tab%ROWTYPE;
   oldrec_                   customer_info_contact_tab%ROWTYPE;    
   is_one_time_customer_     VARCHAR2(20);
   i_                        NUMBER := 0;
   contact_manager_tab_      contact_manager_table;
   CURSOR get_attr IS
      SELECT *
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_;
   CURSOR get_def_attr IS
      SELECT *
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    customer_address = copy_info_.temp_del_addr;
BEGIN  
   is_one_time_customer_:= Customer_Info_API.Get_One_Time_Db(customer_id_);
   -- if transfer address data is checked in CONVERT , copy acustomer contact information from default delivery template
   -- when new customer has no default delivery address define
   IF (copy_info_.copy_convert_option = 'CONVERT') THEN
      IF (copy_info_.temp_del_addr IS NOT NULL AND copy_info_.new_del_address IS NULL) THEN
         FOR rec_ IN get_def_attr LOOP      
            IF (Person_Info_API.Get_Blocked_For_Use_Db(rec_.person_id) = Fnd_Boolean_API.DB_FALSE) THEN         
               oldrec_ := Lock_By_Keys___(customer_id_, rec_.person_id, rec_.guid);          
               newrec_ := oldrec_;
               IF (is_one_time_customer_ = 'FALSE') THEN
                  newrec_.customer_id := new_id_;
                  newrec_.customer_address  := NVL(copy_info_.new_address_id, copy_info_.temp_del_addr);
                  newrec_.guid := NULL;
                  newrec_.created := NULL;
                  newrec_.created_by := NULL;
                  newrec_.changed := NULL;
                  newrec_.changed_by := NULL;
                  IF (newrec_.customer_address IS NOT NULL) THEN
                     newrec_.connect_all_cust_addr := 'FALSE';
                  END IF;
                  IF (newrec_.manager IS NOT NULL) THEN
                     i_ := i_ + 1;
                     contact_manager_tab_(i_).person_id := newrec_.person_id;
                     contact_manager_tab_(i_).customer_address :=  NVL(copy_info_.new_address_id, copy_info_.temp_del_addr);
                     contact_manager_tab_(i_).manager := newrec_.manager;
                     contact_manager_tab_(i_).manager_cust_addr := newrec_.manager_cust_address;
                     newrec_.manager := NULL;            
                     newrec_.manager_guid := NULL;            
                     newrec_.manager_cust_address := NULL;
                  END IF;
                  New___(newrec_);  
               END IF;
            END IF;
         END LOOP;  
         Copy_Manager___(new_id_, contact_manager_tab_);
      END IF;
   ELSE
      FOR rec_ IN get_attr LOOP      
         IF (Person_Info_API.Get_Blocked_For_Use_Db(rec_.person_id) = Fnd_Boolean_API.DB_FALSE) THEN         
            oldrec_ := Lock_By_Keys___(customer_id_, rec_.person_id, rec_.guid);          
            newrec_ := oldrec_;
            IF (is_one_time_customer_ = 'FALSE' OR (newrec_.customer_address IS NULL)) THEN
               newrec_.customer_id := new_id_;
               newrec_.guid := NULL;
               newrec_.created := NULL;
               newrec_.created_by := NULL;
               newrec_.changed := NULL;
               newrec_.changed_by := NULL;
               IF (newrec_.manager IS NOT NULL) THEN
                  i_ := i_ + 1;
                  contact_manager_tab_(i_).person_id := newrec_.person_id;
                  contact_manager_tab_(i_).customer_address := newrec_.customer_address;
                  contact_manager_tab_(i_).manager := newrec_.manager;
                  contact_manager_tab_(i_).manager_cust_addr := newrec_.manager_cust_address;
                  newrec_.manager := NULL;            
                  newrec_.manager_guid := NULL;            
                  newrec_.manager_cust_address := NULL;
               END IF;
               New___(newrec_);  
            END IF;
         END IF;
      END LOOP;
      Copy_Manager___(new_id_, contact_manager_tab_);
   END IF;
END Copy_Customer;


PROCEDURE Check_Default_Values (
   customer_id_   IN VARCHAR2,
   address_id_    IN VARCHAR2 )
IS
   dummy_    INTEGER;
   -- Customer address with NULL values can be avoid since primary, secondary checkbox cannot be selected with NULL values.
   CURSOR get_address IS
      SELECT DISTINCT customer_address
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    customer_address IS NOT NULL;
   CURSOR check_dupl_customer_primary(customer_id_ VARCHAR2) IS
      SELECT 1
      FROM   customer_info_contact_tab a
      WHERE  customer_id = customer_id_
      AND    customer_primary = 'TRUE'
      AND    EXISTS (SELECT 1
                     FROM   customer_info_contact_tab b
                     WHERE  a.ROWID             !=  b.ROWID
                     AND    a.customer_id        =  b.customer_id
                     AND    customer_primary     =  'TRUE');      
   CURSOR check_dupl_customer_secondary(customer_id_ VARCHAR2) IS
      SELECT 1
      FROM   customer_info_contact_tab a
      WHERE  customer_id =  customer_id_
      AND    customer_secondary = 'TRUE'
      AND    EXISTS (SELECT 1
                     FROM   customer_info_contact_tab b
                     WHERE  a.ROWID             !=  b.ROWID
                     AND    a.customer_id        =  b.customer_id
                     AND    customer_secondary   =  'TRUE');
BEGIN
   IF (address_id_ IS NULL) THEN
      FOR rec_ IN get_address LOOP
         Validate_Customer_Address___(customer_id_, rec_.customer_address);
      END LOOP;
   ELSE
      Validate_Customer_Address___(customer_id_, address_id_);
   END IF;
   OPEN check_dupl_customer_primary(customer_id_);
   FETCH check_dupl_customer_primary INTO dummy_;
   IF (check_dupl_customer_primary%FOUND) THEN
      CLOSE check_dupl_customer_primary;
      Error_SYS.Record_General(lu_name_,
                               'ERR_DUPLICATE3: The :P1 check box can be selected for only one contact per customer',
                               Language_SYS.Translate_Item_Prompt_(lu_name_ => lu_name_,
                                                                   item_    => 'CUSTOMER_PRIMARY'));
   END IF;                    
   CLOSE check_dupl_customer_primary;
   OPEN check_dupl_customer_secondary(customer_id_);
   FETCH check_dupl_customer_secondary INTO dummy_;
   IF (check_dupl_customer_secondary%FOUND) THEN
      CLOSE check_dupl_customer_secondary;
      Error_SYS.Record_General(lu_name_,
                               'ERR_DUPLICATE3: The :P1 check box can be selected for only one contact per customer',
                               Language_SYS.Translate_Item_Prompt_(lu_name_ => lu_name_,
                                                                   item_    => 'CUSTOMER_SECONDARY'));
   END IF;                    
   CLOSE check_dupl_customer_secondary;
END Check_Default_Values;


-- Get_Contact_Values
--   Fetch the contact values according to the given customer id, person id and customer address.
PROCEDURE Get_Contact_Values (
   attr_ IN OUT VARCHAR2 )
IS
   customer_id_                customer_info_contact_tab.customer_id%TYPE;
   person_id_                  customer_info_contact_tab.person_id%TYPE;
   customer_address_           customer_info_contact_tab.customer_address%TYPE;
   guid_                       customer_info_contact_tab.guid%TYPE;
   role_                       customer_info_contact_tab.role%TYPE;
   contact_address_            customer_info_contact_tab.contact_address%TYPE;
   decision_power_type_        customer_info_contact_tab.decision_power_type%TYPE;
   CURSOR get_contact IS
      SELECT guid, role, contact_address, decision_power_type
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    person_id = person_id_
      AND    ((customer_address = customer_address_) OR
              (customer_address IS NULL AND connect_all_cust_addr = 'TRUE'));
   CURSOR get_person_contact IS
      SELECT guid, role, contact_address, customer_address, connect_all_cust_addr, decision_power_type
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    person_id = person_id_;
   CURSOR get_person_empty_contact IS
      SELECT guid, role, contact_address, decision_power_type
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    person_id = person_id_
      AND    (customer_address IS NULL AND connect_all_cust_addr = 'FALSE');
BEGIN
   -- Retrieve values passed in the attribute string   
   customer_id_        := Client_SYS.Get_Item_Value('CUSTOMER_ID', attr_);
   person_id_          := Client_SYS.Get_Item_Value('PERSON_ID', attr_);
   customer_address_   := Client_SYS.Get_Item_Value('CUSTOMER_ADDRESS', attr_);     
   IF (customer_address_ IS NULL) THEN
      -- First check whether contact is existing for empty customer address      
      OPEN get_person_empty_contact;
      FETCH get_person_empty_contact INTO guid_, role_, contact_address_, decision_power_type_;
      IF (get_person_empty_contact%NOTFOUND) THEN
         CLOSE get_person_empty_contact;   
         -- Second, if empty customer address contact not found then fetch the contacts which has customer address.
         FOR rec_ IN get_person_contact LOOP
            IF (guid_ IS NOT NULL) THEN
               Client_SYS.Add_To_Attr('MULTI_ADDR_FOUND', 'TRUE', attr_);              
               RETURN;
            END IF;        
            guid_ := rec_.guid;
            role_ := rec_.role;
            contact_address_ := rec_.contact_address;
            IF (rec_.customer_address IS NULL AND rec_.connect_all_cust_addr = 'TRUE') THEN
               customer_address_ := Customer_Info_Address_API.Get_Default_Address(customer_id_, Address_Type_Code_API.DB_PRIMARY_CONTACT);
            ELSE
               customer_address_ := rec_.customer_address;           
            END IF;
            decision_power_type_ := rec_.decision_power_type;
         END LOOP;    
         Client_SYS.Set_Item_Value('CUSTOMER_ADDRESS', customer_address_, attr_);
      ELSE
          CLOSE get_person_empty_contact;
      END IF;
   ELSE
      -- Fetch the contact for the customer address given
      OPEN get_contact;
      FETCH get_contact INTO guid_, role_, contact_address_, decision_power_type_;
      CLOSE get_contact;     
   END IF; 
   Client_SYS.Add_To_Attr('GUID', guid_, attr_);
   Client_SYS.Add_To_Attr('ROLE', Contact_Role_API.Decode_List(role_), attr_);
   Client_SYS.Add_To_Attr('CONTACT_ADDRESS', contact_address_, attr_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Client_SYS.Add_To_Attr('OBJECT_DECISION_POWER_TYPE', Decision_Power_Type_API.Decode(decision_power_type_), attr_);
   $END
   IF (guid_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PHONE', Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('PHONE'), 1, contact_address_, SYSDATE), attr_);
      Client_SYS.Add_To_Attr('MOBILE', Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('MOBILE'), 1, contact_address_, SYSDATE), attr_);
      Client_SYS.Add_To_Attr('E_MAIL', Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('E_MAIL'), 1, contact_address_, SYSDATE), attr_);
      Client_SYS.Add_To_Attr('FAX', Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('FAX'), 1, contact_address_, SYSDATE), attr_);
      Client_SYS.Add_To_Attr('WWW', Comm_Method_API.Get_Value('PERSON', person_id_, Comm_Method_Code_API.Decode('WWW'), 1, contact_address_, SYSDATE), attr_);
   END IF;         
END Get_Contact_Values;


FUNCTION Exist_Contact (
   customer_id_ IN VARCHAR2,
   person_id_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_contact IS
      SELECT 1
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
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


-- Is_Customer_Contact
--    This method checks whether given person has registered as a customer contact.
FUNCTION Is_Customer_Contact (
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_contact IS
      SELECT 1
      FROM   customer_info_contact_tab
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
END Is_Customer_Contact;


-- Validate_Customer_Address
--   Return the count and customer_address(if count = 1) for a given customer_id and person_id.
PROCEDURE Validate_Customer_Address (
   row_count_        OUT NUMBER,
   customer_address_ OUT VARCHAR2,
   customer_id_      IN  VARCHAR2,
   person_id_        IN  VARCHAR2 )
IS
   CURSOR exist_contact IS
      SELECT COUNT(*)
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    person_id = person_id_;
   CURSOR get_cust_address IS
      SELECT DECODE( connect_all_cust_addr, 'FALSE', customer_address, Customer_Info_Address_API.Get_Default_Address(customer_id_, Address_Type_Code_API.DB_PRIMARY_CONTACT))
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    person_id = person_id_;
BEGIN
   OPEN exist_contact;
   FETCH exist_contact INTO row_count_;
   IF (exist_contact%FOUND) THEN
      CLOSE exist_contact;
      IF (row_count_ = 1) THEN
         OPEN get_cust_address;
         FETCH get_cust_address INTO customer_address_;
         CLOSE get_cust_address;
      END IF; 
   ELSE
      CLOSE exist_contact;      
   END IF;  
END Validate_Customer_Address;


-- Modify_Blocked_For_Crm_Objects
--   Modify Blocked for CRM Objects value for all the customer contacts
--   in which given person is connected.
PROCEDURE Modify_Blocked_For_Crm_Objects (
   person_id_                  IN VARCHAR2,
   blocked_for_crm_objects_db_ IN VARCHAR2 )
IS   
   attr_       VARCHAR2(2000) := NULL;
   newrec_     customer_info_contact_tab%ROWTYPE;
   oldrec_     customer_info_contact_tab%ROWTYPE;
   objid_      customer_info_contact.objid%TYPE;
   objversion_ customer_info_contact.objversion%TYPE;
   indrec_     Indicator_Rec;
   CURSOR get_contacts IS 
      SELECT *
      FROM   customer_info_contact_tab
      WHERE  person_id = person_id_;   
BEGIN   
   FOR contacts_rec_ IN get_contacts LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, contacts_rec_.customer_id, person_id_, contacts_rec_.guid);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Client_SYS.Add_to_Attr('BLOCKED_FOR_CRM_OBJECTS_DB', blocked_for_crm_objects_db_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END LOOP;
END Modify_Blocked_For_Crm_Objects;


-- Get_Guid_By_Cust_Address
--    Fetch the the guid according to the given customer id, person id and customer address.
@UncheckedAccess
FUNCTION Get_Guid_By_Cust_Address(
   customer_id_      IN VARCHAR2,
   person_id_        IN VARCHAR2,
   customer_address_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   guid_       customer_info_contact_tab.guid%TYPE;
   CURSOR get_guid IS
      SELECT guid
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    person_id = person_id_
      AND    ((customer_address = customer_address_) OR
              (customer_address IS NULL AND connect_all_cust_addr = 'TRUE'));
    CURSOR get_guid_empty_addr IS
      SELECT guid
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    person_id = person_id_
      AND    (customer_address IS NULL AND connect_all_cust_addr = 'FALSE');
BEGIN
   IF (customer_address_ IS NOT NULL) THEN
      OPEN get_guid;
      FETCH get_guid INTO guid_;
      CLOSE get_guid;   
   ELSE
      OPEN get_guid_empty_addr;
      FETCH get_guid_empty_addr INTO guid_;
      CLOSE get_guid_empty_addr;  
   END IF;
   RETURN guid_;
END Get_Guid_By_Cust_Address;


-- Exist_As_Manager
--    This method checks whether given person and customer address is set as the manager and manager cust address
--    for an another customer contact.
FUNCTION Exist_As_Manager (
   customer_id_          IN VARCHAR2,
   person_id_            IN VARCHAR2,
   customer_address_     IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;  
   CURSOR check_exist IS
      SELECT 1
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    manager = person_id_
      AND    manager_cust_address = customer_address_;      
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   IF (check_exist%FOUND) THEN
      CLOSE check_exist;
      RETURN(TRUE);
   ELSE
      CLOSE check_exist;
      RETURN(FALSE);
   END IF;     
END Exist_As_Manager;


-- Validate_Person_Id
--   Return the count and guid (if count = 1) for a given person_id. If customer_id is not specified it is also returned (if count = 1)
PROCEDURE Validate_Person_Id (
   row_count_        OUT    NUMBER,
   guid_             OUT    VARCHAR2,
   customer_id_      IN OUT VARCHAR2,
   person_id_        IN     VARCHAR2 )
IS
   CURSOR get_customer_and_guid IS
      SELECT customer_id, guid
      FROM   customer_info_contact_tab
      WHERE  person_id = person_id_;
   CURSOR get_guid IS
      SELECT guid
      FROM   customer_info_contact_tab
      WHERE  customer_id = customer_id_
      AND    person_id = person_id_;
BEGIN
   row_count_ := 0;
   IF (person_id_ IS NULL) THEN
      RETURN;
   END IF;
   IF (customer_id_ IS NULL) THEN
      FOR rec_ IN get_customer_and_guid LOOP
         row_count_ := row_count_ + 1;
         IF (row_count_ = 1) THEN
            guid_:= rec_.guid;
            customer_id_:= rec_.customer_id;
         ELSE
            guid_:= NULL;
            customer_id_:= NULL;
         END IF;
      END LOOP;   
   ELSE
      FOR rec_ IN get_guid LOOP
         row_count_ := row_count_ + 1;
         IF (row_count_ = 1) THEN
            guid_:= rec_.guid;
         ELSE
            guid_:= NULL;
         END IF;
      END LOOP;   
   END IF;
END Validate_Person_Id;


PROCEDURE Modify (   
   attr_          IN OUT   VARCHAR2,
   customer_id_   IN       VARCHAR2,
   person_id_     IN       VARCHAR2,
   guid_          IN       VARCHAR2,
   note_text_     IN       CLOB,
   write_note_    IN       BOOLEAN )
IS
   oldrec_       customer_info_contact_tab%ROWTYPE;
   newrec_       customer_info_contact_tab%ROWTYPE;  
   indrec_       Indicator_Rec;
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(200);
BEGIN    
   oldrec_ := Lock_By_Keys___(customer_id_, person_id_, guid_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   objid_ := Get_Objid(customer_id_, person_id_, guid_);  
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);   
   IF (write_note_) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, customer_id_, person_id_, guid_);
      Write_Note_Text__(objversion_, objid_, note_text_);
   END IF;
END Modify;


PROCEDURE Get_Customer_Contact_Info (
   customer_id_            OUT VARCHAR2,
   person_id_              OUT VARCHAR2,
   customer_address_       OUT VARCHAR2,
   main_representative_id_ OUT VARCHAR2,
   guid_                   OUT VARCHAR2,
   objid_                  IN  VARCHAR2 )
IS
   CURSOR get_contact_info IS
      SELECT customer_id, person_id, customer_address, main_representative_id, guid, connect_all_cust_addr
      FROM  customer_info_contact_tab
      WHERE ROWID = objid_;    
   connect_all_cust_addr_ customer_info_contact_tab.connect_all_cust_addr%TYPE;
BEGIN
   OPEN get_contact_info;
   FETCH get_contact_info INTO customer_id_, person_id_, customer_address_, main_representative_id_, guid_, connect_all_cust_addr_;
   CLOSE get_contact_info;
   IF (customer_address_ IS NULL AND connect_all_cust_addr_ = 'TRUE') THEN
      customer_address_ := Customer_Info_Address_API.Get_Default_Address(customer_id_, Address_Type_Code_API.DB_PRIMARY_CONTACT);
   END IF;
END Get_Customer_Contact_Info;


@UncheckedAccess
FUNCTION Get_Key_By_Objid (
   objid_ IN   VARCHAR2 ) RETURN customer_info_contact_tab%ROWTYPE
IS
   rec_ customer_info_contact_tab%ROWTYPE;    
   CURSOR get_keys IS
      SELECT customer_id, person_id, guid
      FROM   customer_info_contact_tab
      WHERE  ROWID = objid_;
BEGIN
   OPEN get_keys;
   FETCH get_keys INTO rec_.customer_id, rec_.person_id, rec_.guid;
   CLOSE get_keys;   
   RETURN rec_; 
END Get_Key_By_Objid;


FUNCTION Pack_Table (
   rec_  IN customer_info_contact_tab%ROWTYPE ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      RETURN Pack_Table___(rec_);
   $ELSE
      RETURN NULL;
   $END
END Pack_Table;
