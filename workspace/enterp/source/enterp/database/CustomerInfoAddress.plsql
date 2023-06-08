-----------------------------------------------------------------------------
--
--  Logical unit: CustomerInfoAddress
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110731  Dobese  Changed Chemmate to HSE
--  981116  Camk    Created
--  981126  Camk    Method Check_If_Null added
--  990105  Camk    Added new columns Secondary_Contact and Primary_Contact to
--                  to view. Added new functions Get_primary_contact() and
--                  Get_secondary_contact()
--  990416  Maruse  New template
--  990429  Maruse  New template corr.
--  990907  BmEk    Bug #11396. Added check in Unpack_Check_Insert and Unpack_Check_Update
--                  if valid to date is earlier then valid from date .
--  991228  LiSv    Corrected bug #13129, changed substr_b to substr in function
--                  Get_Line.
--  000209  Mnisse  FIN243, new address fields.
--  000118  Camk    Address not mandatory
--  000225  Mnisse  Change of public methods for the new address fields.
--  000227  Mnisse  Change of public methods for the new address fields.
--  000229  Mnisse  Bug #32920, uppercase for Zip_Code
--  000302  Mnisse  Update also old address field.
--  000303  Mnisse  Public New and Modify shall update new address fields.
--  000410  Camk    Raise a warning to the user that the address format might not
--                  correctly stored.
--  000525  LiSv    Removed call to Check_If_Null___ (this is an old solution).
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  001024  Camk    County added
--  001025  Camk    Added procedure Pack_And_Post_Message__. Procedure will send
--                  a message to IFS Connectivity on insert, modify and delete action.
--  001130  Camk    Bug #18471 Wrong customer name in Chemmate transfer corrected
--  001130  Camk    Bug #18498 ORA-06502 in Enterprise/ Customer/ Adress tab corrected
--  001221  Camk    Bug #18821 CHEMMATE message does not exist in Connectivity
--  010308  JeGu    Bug #20475, New function: Get_Country_Code
--  010314  Cand    Bug #18479, Added procedure Cascade_Delete_Comm_Method__
--  010517  JeGu    Bug #21988 Added Procedure Get_Address_Lines
--  010627  Gawilk  Fixed bug # 15677. Checked General_SYS.Init_Method.
--  011001  MACH    Bug# 20679 Fixed. Address is passed in a proper way.
--  020124  Bmek    IID 10220. Added the columns jurisdiction_code and in_city to the LU
--                  and the methods Get_Jurisdiction_Code and Get_In_City
--  020127  Bmek    IID 10220. Modified Unpack_Check_Insert___ and Unpack_Check_Update___ so
--                  a jurisdiction_code is fetched from Vertex when a delivery address is saved.
--  030317  SaAblk  Add public Method Check_Exist
--  030512  SaAblk  Removed public Method Check_Exist (Roll back previous modification)
--  030916  Gepelk  IID ARFI124N. Add procedure Validate_Address
--  040324  mgutse  Merge of 2004-1 SP1.
--  040628  Jeguse  Bug 45629, Added functions Get_Address_Form, Get_Address_Rec, Get_All_Address_Lines and Get_Address_Line 
--  040730  WAPELK  Bug 42739 Merged.
--  050105  Saahlk  LCS Patch Merge, Bug 42347.
--  050215  AjPelk  B120109 En error msg EANEXIST: has renamed.
--  050923  Iswalk  Changed call to Get_Jurisdiction_Code to Get_Enterp_Jurisdiction_Code to avoid unnecessary error message.
--  051209  Hecolk  LCS Merge 53510, Added PROCEDURE Get_Id_By_Ean_Loc_If_Unique
--  051214  Kagalk  LCS Merge 54707
--  0601096 Sacalk  LCS Merge 55184,Modified UnpackCheckInsert and UnpackCheckUpdate to return Jurisdiction code for all the countries using Vertex.
--  060227  Dobese  B135466 Remove empty lines in address to Chemmate in Pack_And_Post_Messages
--  060428  Sacalk  Bug 56972, Added function Sync_Addr, Modified New_ and Modify_ methods  
------------------------------------ 1.9.0 ----------------------------------
--  060726  CsAmlk  Persian Calendar Modifications.
--  061010  DiAmlk  LCS Merge 59885.Modified in Get_Address_Form to print blanks in the address lines when required.
--  070604  Shsalk  LCS Merge 65531, Modified New__ to check the system definitions.
--  070627  Kagalk  LCS Merge 65835, Rolled back 59885.
--  070627  Kagalk  LCS Merge 65828, Fixed address presentation in Get_Address_Form.
--  090224  Shdilk  Bug 80642, Modified variable length of 'name' in Get_Address_Form.
--  090503  Chhulk  Bug 79336, Modified Cascade_Delete_Comm_Method__()
--  091103  Sacalk  Bug 86629, Modified PROCEDURE Copy_Customer
--  100105  Yothlk  Bug 88104, Modified PROCEDURE Copy_Customer
--  100113  Umdolk  Refactoring in Communication methods in Enterprise.
--  100622  Samblk  Bug 90960, Modified Validate_Address to support given test case
--  101124  Mamalk  DF-494, Replaced Ipd_Tax_Info_Addr_API with Customer_Ipd_Tax_Info_Addr_API.
--  110718  Shdilk  FIDEAGLE-350, Merged bug 95753, Modified to store correct party value.
--  110809  Umdolk  FIDEAGLE-352, Merged Bug 94883, Modified Get_Address_Form()
--  121022  MaRalk  PBR-560, Added public attributes end_customer_id and end_cust_addr_id and modified base methods. 
--  121024  MaRalk  PBR-562, Added method Validate___ to bring the comman code in Unpack_Check_Insert___, Unpack_Check_Update___ methods.
--  130118  SALIDE  EDEL-1994, Added column name and modified Copy_Customer()
--  130920  Chhulk  Bug 111274, Added new function Get_Delivery_Country_Db()
--  121024          and added end customer validations. Added method Modify_End_Cust_Addr_Info___. Modified method Update___. 
--  121114  MaRalk  PBR-565, Modified method Copy_Customer to add end customer information when new customer is created.
--  130206  MaRalk  PBR-1203, Modified Customer_Info_API.Exist method calls by adding the customer category.
--  130614  DipeLK  TIBE-726, Removed global variable which used to check exsistance of INVOIC component(variable declared only)
--  131017  Isuklk  CAHOOK-2752 Refactoring in CustomerInfoAddress.entity
--  121230  MaRalk  PBSC-5457, Override methods Check_Customer_Id_Ref___, Check_End_Customer_Id_Ref___.
--  140312  JanWse  PBSC-7421, Use error message ENDCUSTADDRNOTDEFINED when connecting an end customer and new address id is not saved (Check_Connect___)
--  140321  JanWse  PBSC-7421, Modified IF statement in Check_Common___
--  140328  Dihelk  PBFI-4378, Modified the Check_Common___() method
--  140424  Shhelk  PBFI-6527, replaced Concat_Addr_Fields___ method with Attribute_Definition_API.Check_Value() in New_Address()
--  140603  MaRalk  PBSC-9824, Added error message INVALIDADDR to restrict connecting end customer address, having invalid validity period.
--  140710  MaIklk  PRSC-1761, Implemented to preserve records if customer is existing in copy_customer().
--  140714  MAHPLK  PRSC-427, Modified Update___ to remove the update of company_name_2 of Cust_Ord_Customer_Address_API.
--  141107  MaRalk  PRSC-3112, Removed parameter convert_customer_ from Copy_Customer method.
--  141122  MaIklk  PRSC-1485, Added Exist_End_Customer(). 
--  150706  MaIklk  BLU-490, Added Get_Last_Modified().
--  150708  Wahelk  BLU-958, Added new method Copy_Customer_Def_Address
--  150722  Wahelk  BLU-961, Modified method Copy_Customer_Def_Address to add new address id and added new parameter company to metho
--  150610  Waudlk  Bug 121697, Added Check_Exist method.
--  150812  Wahelk  BLU-1191, Removed method Copy_Customer_Def_Address
--  150812  Wahelk  BLU-1192,Modified Copy_Customer method by adding new parameter copy_info_
--  150813  Wahelk  BLU-1192,Modified Copy_Customer method to send  copy_info_ as IN OUT parameter
--  150818  Wahelk  BLU-1192,Modified Copy_Customer method
--  151103  THPELK  STRFI-307 - Removed Reset_Valid_From(),Reset_Valid_To().
--  160106	Chwtlk  STRFI-962, Merge of LCS Bug 126573, Modified Cascade_Delete_Comm_Method__()
--  160307  DipeLK  STRLOC-247,Removed Validate_Address() method.
--  160413  reanpl  STRLOC-75, Added handling of new attributes address3, address4, address5, address6, removed Get_Address_Lines
--  160505  ChguLK  STRCLOC-369, Renamed the package name to Address_Setup_API.
--  170113  NaJyLK  STRFI-4023,Merged Bug 132505
--  170214  Hasplk  STRMF-9630, Merged lcs patch 132521.
--  170327  Dkanlk  STRFI-5457, Merged bug 132512.
--  180509  Nirylk  Bug 141210, Merged App9 correction. Modified Check_Common___().
--  180624  JanWse  SCUXX-3748, Added public version of Pack_Table___ (Pack_Table)
--  180724  AwWelk  SCUXX-4048, Added conditional compilation for duplication logic in rmcom.
--  181008  JanWse  SCUXX-4712, Re-arranged code used for duplication check
--  181203  thjilk  Modified Check_Delete___ to validate Address Types
--  190828  JiThlk  Bug 149324 (SCZ-6119), Added condition in Update___() to check if end customer is changed before saving end customer Address Info.
--  191105  Vashlk  Bug 150833, Performance improvement for Vertex.
--  200824  JICESE  Changed HSE integration to post message to receiver as BizAPIs are obsoleted
--  210201  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in methods Modify_End_Cust_Addr_Info___, New, Modify and New_Address
--  211207  AKDELK  SM21R2-3481, Modified Update___
--  211210  Sanvlk  Added logs to Account CRM and Account contact journals in insert___ and update___ methods.
--  211220  VIKALK  Added Get_Object_By_Keys public method.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                  
-------------------- PRIVATE DECLARATIONS -----------------------------------
                  
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_, 'NOTEXIST: Address ID :P1 does not exist in Customer Address Info.', address_id_);
   super(customer_id_, address_id_);  
END Raise_Record_Not_Exist___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     customer_info_address_tab%ROWTYPE,
   newrec_ IN OUT customer_info_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   end_customer_category_ customer_info_tab.customer_category%TYPE;      
BEGIN   
   IF (indrec_.end_customer_id = TRUE AND newrec_.end_customer_id IS NOT NULL) THEN      
      end_customer_category_  := Customer_Info_API.Get_Customer_Category_Db(newrec_.end_customer_id);
      Customer_Info_API.Exist(newrec_.end_customer_id, end_customer_category_);
   END IF;   
   IF ((newrec_.end_customer_id IS NOT NULL) AND (newrec_.end_cust_addr_id IS NOT NULL)) THEN
      Exist(newrec_.end_customer_id, newrec_.end_cust_addr_id);
   END IF;
   IF (newrec_.in_city IS NULL) THEN
      newrec_.in_city := 'FALSE';      
   END IF;
   IF (Object_Property_API.Get_Value('PartyType', '*', 'UNIQUE_OWN_ADDR') = 'TRUE') THEN
      Check_Ean_Location___(newrec_);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_); 
   IF (Validate_SYS.Is_Changed(oldrec_.end_customer_id, newrec_.end_customer_id) AND newrec_.end_customer_id IS NOT NULL AND newrec_.end_cust_addr_id IS NULL) THEN      
      Error_SYS.Record_General(lu_name_, 'ENDCUSTADDRNOTDEFINED: There is no address identity specified for end customer :P1.', newrec_.end_customer_id);
   END IF;
   Address_Setup_API.Check_Nullable_Address_Fields(lu_name_, newrec_.address1, newrec_.address2, newrec_.address3, newrec_.address4, newrec_.address5, newrec_.address6);
   Validate___(oldrec_, newrec_, indrec_, attr_);
   Address_Setup_API.Validate_Address_Attributes(lu_name_, 
                                                 newrec_.country, 
                                                 newrec_.address1, 
                                                 newrec_.address2, 
                                                 newrec_.address3, 
                                                 newrec_.address4, 
                                                 newrec_.address5, 
                                                 newrec_.address6, 
                                                 newrec_.zip_code, 
                                                 newrec_.city, 
                                                 newrec_.county, 
                                                 newrec_.state);
   newrec_.address := Address_Presentation_API.Format_Address(newrec_.country, 
                                                              newrec_.address1, 
                                                              newrec_.address2, 
                                                              newrec_.address3, 
                                                              newrec_.address4, 
                                                              newrec_.address5, 
                                                              newrec_.address6, 
                                                              newrec_.city, 
                                                              newrec_.county, 
                                                              newrec_.state, 
                                                              newrec_.zip_code, 
                                                              Iso_Country_API.Decode(newrec_.country));
END Check_Common___;


PROCEDURE Get_Customer_Party___ (
   newrec_ IN OUT customer_info_address_tab%ROWTYPE,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.party := Customer_Info_API.Get_Party(newrec_.customer_id);
   Client_SYS.Add_To_Attr('PARTY', newrec_.party, attr_);
END Get_Customer_Party___;


PROCEDURE Check_Ean_Location___ (
   rec_ IN customer_info_address_tab%ROWTYPE )
IS
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(200);
   CURSOR Check_Exist IS
      SELECT 1
      FROM   customer_info_address_tab
      WHERE  ean_location = rec_.ean_location
      AND    ROWID||'' <> NVL(objid_, CHR(0));
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, rec_.customer_id, rec_.address_id);
   IF (rec_.ean_location IS NOT NULL) THEN
      FOR a IN Check_Exist LOOP
         Error_SYS.Appl_General(lu_name_,'EANEXIST: This Customer''s Own Address ID already exists on another address for this customer, or on another customer.');
      END LOOP;
   END IF;
END Check_Ean_Location___;


PROCEDURE Split_Address___ (
   address1_ OUT VARCHAR2,
   address2_ OUT VARCHAR2,
   address3_ OUT  VARCHAR2,
   address4_ OUT  VARCHAR2,
   address5_ OUT  VARCHAR2,
   address6_ OUT  VARCHAR2,
   zip_code_ OUT VARCHAR2,
   city_     OUT VARCHAR2,
   county_   OUT VARCHAR2,
   state_    OUT VARCHAR2,
   country_  IN  VARCHAR2,
   address_  IN  VARCHAR2 )
IS
   address_pres_  Address_Presentation_API.Public_Rec_Address;
   lines_         NUMBER := 1;
   line_          VARCHAR2(100);
   addr_          VARCHAR2(2000);
   ptr_           NUMBER;
   cnt_           NUMBER;
   start_         NUMBER;
   end_           NUMBER;
   line_assigned_ BOOLEAN := FALSE;
   make_warning_  BOOLEAN := FALSE;
BEGIN
   -- Get the address presentation definition.
   address_pres_ := Address_Presentation_API.Get_Address_Record(Iso_Country_API.Encode(country_));
   -- Get the values from the address field and assign them to the specified
   -- address fields.
   -- This will not work correctly for fields on the same row due to the impossibility
   -- to know where on the line to split for the different fields. Hence, save the whole
   -- line in one field.
   -- A notification should be supplied to the user.
   -- Get the number of lines for the current address, call is depending on party_type.
   addr_ := address_;
   addr_ := RTRIM(REPLACE(addr_, CHR(13), ''), CHR(10));
   LOOP
      ptr_ := INSTR(addr_, CHR(10));
      IF (ptr_ > 0 AND ptr_ < LENGTH(addr_)) THEN
         lines_ := lines_ + 1;
         addr_ := SUBSTR(addr_, ptr_+1);
      ELSE
         EXIT;
      END IF;
   END LOOP;
   -- Loop through all the address lines
   FOR i IN 1 .. lines_ LOOP
      line_assigned_ := FALSE;
      -- Get the next line
      addr_ := address_;
      addr_ := CHR(10)||RTRIM(REPLACE(addr_, CHR(13), ''),CHR(10))||CHR(10);
      cnt_ := i;
      start_ := NVL(INSTR(addr_, CHR(10), 1, cnt_), 0);
      end_   := NVL(INSTR(addr_, CHR(10), 1, cnt_ + 1), 0);
      line_ := SUBSTR(addr_, start_ + 1, end_ - start_ - 1);
      -- Assign the values.
      IF (address_pres_.address1_row = i) THEN
         address1_ := SUBSTR(line_,1,35);
         line_assigned_ := TRUE;
      END IF;
      IF (address_pres_.address2_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            address2_ := SUBSTR(line_,1,35);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.address3_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            address3_ := SUBSTR(line_,1,100);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.address4_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            address4_ := SUBSTR(line_,1,100);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.address5_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            address5_ := SUBSTR(line_,1,100);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.address6_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            address6_ := SUBSTR(line_,1,100);
            line_assigned_ := TRUE;
         END IF;
      END IF;      
      IF (address_pres_.zip_code_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            zip_code_ := SUBSTR(line_,1,35);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.city_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            city_ := SUBSTR(line_,1,35);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.county_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            county_ := SUBSTR(line_,1,35);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.state_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            state_ := SUBSTR(line_,1,35);
            line_assigned_ := TRUE;
         END IF;
      END IF;
   END LOOP;
   -- IF make_warning flag is TRUE then make a warning to the user
   -- that an address line is not split correctly.
   IF (make_warning_ = TRUE) THEN
      -- How is this done??
      --NULL;
      Client_SYS.Clear_Info;
      Client_SYS.Add_Warning(lu_name_, 'CUSTADDR1: The address might have been stored with an invalid format. Please check the address.');
   END IF;
END Split_Address___;


PROCEDURE Validate___ ( 
   oldrec_ IN     customer_info_address_tab%ROWTYPE,   
   newrec_ IN OUT customer_info_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   end_customer_id_     customer_info_address_tab.end_customer_id%TYPE;
   end_cust_addr_id_    customer_info_address_tab.end_cust_addr_id%TYPE;
   default_company_     VARCHAR2(20);
   action_              VARCHAR2(10); 
   validation_result_   VARCHAR2(5);
   validation_flag_     VARCHAR2(5);
   $IF Component_Accrul_SYS.INSTALLED $THEN
      postal_addresses_   External_Tax_System_Util_API.postal_address_arr;
      postal_address_     External_Tax_System_Util_API.postal_address_rec; 
   $END
   CURSOR exist_end_cust_conn(customer_id_ IN VARCHAR2, end_customer_id_ IN VARCHAR2, end_cust_addr_id_ IN VARCHAR2) IS
      SELECT end_customer_id, end_cust_addr_id
      FROM   customer_info_address_tab
      WHERE  customer_id = customer_id_
      AND    end_customer_id = end_customer_id_
      AND    end_cust_addr_id = end_cust_addr_id_;
   CURSOR get_address_types(customer_id_ IN VARCHAR2, address_id_ IN VARCHAR2) IS
      SELECT t.rowid, t.customer_id, Address_Type_Code_API.Decode(t.address_type_code) AS address_type_code, t.def_address
      FROM   customer_info_address_type_tab t
      WHERE  t.customer_id = customer_id_
      AND    t.address_id = address_id_;
BEGIN
   action_ := Client_SYS.Get_Item_Value('ACTION', attr_);      
   IF (newrec_.valid_from > newrec_.valid_to ) THEN
      Error_SYS.Appl_General(lu_name_, 'WRONGINTERVAL: Valid From date is later than Valid To date');
   END IF;
   IF ((newrec_.end_customer_id IS NOT NULL) AND (newrec_.end_cust_addr_id IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'ENDCUSTADDRNOTDEFINED: There is no address identity specified for end customer :P1.', newrec_.end_customer_id);
   END IF;  
   IF ((newrec_.end_customer_id IS NULL) AND (newrec_.end_cust_addr_id IS NOT NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'ENDCUSTNOTDEFINED: There is no end customer specified.');
   END IF;      
   IF ((newrec_.end_customer_id IS NOT NULL) AND (newrec_.end_cust_addr_id IS NOT NULL)) THEN      
      IF (Customer_Info_Address_Type_API.Check_Exist(newrec_.end_customer_id, newrec_.end_cust_addr_id, Address_Type_Code_API.Decode(Address_Type_Code_API.DB_DELIVERY)) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'ONLYDELADDRALLOWED: The address is not a delivery type address and cannot be connected as an end customer address.');
      END IF;
      IF (Is_Valid(newrec_.end_customer_id, newrec_.end_cust_addr_id) = 'FALSE') THEN   
         Error_SYS.Record_General(lu_name_, 'INVALIDADDR: End customer address :P1 is invalid. Please check the validity period of the address.', newrec_.end_cust_addr_id);
      END IF;      
   END IF;
   IF (newrec_.customer_id = newrec_.end_customer_id) THEN
      Error_SYS.Record_General(lu_name_, 'SAMECUSTASENDCUSTNOTALLOWED: Customer ID :P1 cannot be connected as an end customer to the same customer.', newrec_.end_customer_id);
   END IF;  
   IF (Customer_Info_API.Get_One_Time_Db(newrec_.end_customer_id) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'ONETIMENOTALLOWED: One-Time customer :P1 cannot be connected as an end customer.', newrec_.end_customer_id);
   END IF;
   -- Need to check the existency of same End Customer Id, Address Identity Combination only when one of those two fields are changed.       
   IF ((NVL(oldrec_.end_customer_id, ' ') != NVL(newrec_.end_customer_id, ' ')) OR (NVL(oldrec_.end_cust_addr_id, ' ') != NVL(newrec_.end_cust_addr_id, ' '))) THEN
      OPEN exist_end_cust_conn(newrec_.customer_id, newrec_.end_customer_id, newrec_.end_cust_addr_id);
      FETCH exist_end_cust_conn INTO end_customer_id_, end_cust_addr_id_;
      IF (exist_end_cust_conn%FOUND) THEN
         CLOSE exist_end_cust_conn;
         Error_SYS.Record_General(lu_name_, 'SAMEENDCUSTCONNECTION: The address identity :P1 of end customer :P2 is already registered to this customer.', end_cust_addr_id_, newrec_.end_customer_id);
      END IF; 
      CLOSE exist_end_cust_conn;   
   END IF;
   -- Give an information message if address information is edited manually once end customer connection exists.  
   -- Save correct address information fetched from the end customer.
   IF (((NVL(oldrec_.end_customer_id, ' ') != NVL(newrec_.end_customer_id, ' '))  OR (NVL(oldrec_.end_cust_addr_id, ' ') != NVL(newrec_.end_cust_addr_id, ' '))) AND  
        (newrec_.end_customer_id IS NOT NULL AND newrec_.end_cust_addr_id IS NOT NULL ) AND    
       ((newrec_.address1 != Get_Address1(newrec_.end_customer_id, newrec_.end_cust_addr_id)) OR
       (NVL(newrec_.address2, ' ') != NVL(Get_Address2(newrec_.end_customer_id, newrec_.end_cust_addr_id), ' ')) OR
       (NVL(newrec_.address3, ' ') != NVL(Get_Address3(newrec_.end_customer_id, newrec_.end_cust_addr_id), ' ')) OR
       (NVL(newrec_.address4, ' ') != NVL(Get_Address4(newrec_.end_customer_id, newrec_.end_cust_addr_id), ' ')) OR
       (NVL(newrec_.address5, ' ') != NVL(Get_Address5(newrec_.end_customer_id, newrec_.end_cust_addr_id), ' ')) OR
       (NVL(newrec_.address6, ' ') != NVL(Get_Address6(newrec_.end_customer_id, newrec_.end_cust_addr_id), ' ')) OR
       (NVL(newrec_.zip_code, ' ') != NVL(Get_Zip_Code(newrec_.end_customer_id, newrec_.end_cust_addr_id), ' ')) OR
       (NVL(newrec_.city, ' ') != NVL(Get_City(newrec_.end_customer_id, newrec_.end_cust_addr_id), ' ')) OR
       (NVL(newrec_.state, ' ') != NVL(Get_State(newrec_.end_customer_id, newrec_.end_cust_addr_id), ' ')) OR
       (NVL(newrec_.county, ' ') != NVL(Get_County(newrec_.end_customer_id, newrec_.end_cust_addr_id), ' ')) OR
       (NVL(newrec_.country, ' ') != NVL(Get_Country_Code(newrec_.end_customer_id, newrec_.end_cust_addr_id), ' ')))) THEN
          Client_SYS.Add_Info(lu_name_, 'CANNOTMANUEDITTED: You cannot edit address information obtained from the end customer. The original information will be saved.'); 
          newrec_.address1 := Get_Address1(newrec_.end_customer_id, newrec_.end_cust_addr_id);
          newrec_.address2 :=  Get_Address2(newrec_.end_customer_id, newrec_.end_cust_addr_id);
          newrec_.address3 :=  Get_Address3(newrec_.end_customer_id, newrec_.end_cust_addr_id);
          newrec_.address4 :=  Get_Address4(newrec_.end_customer_id, newrec_.end_cust_addr_id);
          newrec_.address5 :=  Get_Address5(newrec_.end_customer_id, newrec_.end_cust_addr_id);
          newrec_.address6 :=  Get_Address6(newrec_.end_customer_id, newrec_.end_cust_addr_id);
          newrec_.zip_code := Get_Zip_Code(newrec_.end_customer_id, newrec_.end_cust_addr_id);
          newrec_.city := Get_City(newrec_.end_customer_id, newrec_.end_cust_addr_id);
          newrec_.state := Get_State(newrec_.end_customer_id, newrec_.end_cust_addr_id);
          newrec_.county := Get_County(newrec_.end_customer_id, newrec_.end_cust_addr_id);   
          newrec_.country := Get_Country_Code(newrec_.end_customer_id, newrec_.end_cust_addr_id);          
   END IF;
   Address_Setup_API.Validate_Address(newrec_.country, newrec_.state, newrec_.county, newrec_.city);   
   IF (newrec_.state = '*') THEN
      newrec_.state := NULL;
   END IF;
   IF (newrec_.county = '*') THEN
      newrec_.county := NULL;
   END IF;
   IF (newrec_.city = '*') THEN
      newrec_.city := NULL;
   END IF;
   IF (action_ = 'DO') THEN
      $IF Component_Accrul_SYS.INSTALLED $THEN
         IF (indrec_.address1 OR indrec_.address2 OR indrec_.zip_code OR indrec_.city OR indrec_.state OR indrec_.county OR indrec_.country) THEN            
            User_Finance_API.Get_Default_Company(default_company_);               
            postal_addresses_.DELETE;      
            postal_address_            := NULL;
            postal_address_.address_id := newrec_.address_id;
            postal_address_.address1   := newrec_.address1;
            postal_address_.address2   := newrec_.address2;
            postal_address_.zip_code   := newrec_.zip_code;
            postal_address_.city       := newrec_.city;
            postal_address_.state      := newrec_.state;
            postal_address_.county     := newrec_.county;
            postal_address_.country    := newrec_.country;
            postal_addresses_(0)       := postal_address_;
            External_Tax_System_Util_API.Handle_Address_Information(postal_addresses_, default_company_, 'COMPANY_CUSTOMER');
            IF (postal_addresses_.EXISTS(0)) THEN
               newrec_.jurisdiction_code := postal_addresses_(0).jurisdiction_code;   
            ELSE
               newrec_.jurisdiction_code := NULL;
            END IF;    
         END IF;             
      $ELSE
         newrec_.jurisdiction_code := NULL;
      $END
   ELSE
      newrec_.jurisdiction_code := NULL;
   END IF;  
   -- Sent the jurisdiction_code back to the client
   Client_SYS.Add_To_Attr('JURISDICTION_CODE', newrec_.jurisdiction_code, attr_);
   -- Check if connected address types still are valid according to modified date periods.
   IF (NVL(newrec_.valid_from, Database_Sys.Get_First_Calendar_Date()) != NVL(oldrec_.valid_from, Database_Sys.Get_First_Calendar_Date())) OR 
      (NVL(newrec_.valid_to, Database_Sys.Get_Last_Calendar_Date()) != NVL(oldrec_.valid_to, Database_Sys.Get_Last_Calendar_Date())) THEN 
      FOR c1 IN get_address_types(newrec_.customer_id, newrec_.address_id) LOOP
         Customer_Info_Address_Type_API.Check_Def_Address_Exist(validation_result_, 
                                                                validation_flag_, 
                                                                c1.customer_id, 
                                                                c1.def_address, 
                                                                c1.address_type_code, 
                                                                c1.rowid, 
                                                                newrec_.valid_from, 
                                                                newrec_.valid_to);
         IF (c1.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
            Client_SYS.Add_Warning(lu_name_, 'DEFADDEXIST1: A default address ID already exists for :P1 Address Type for this time period. Do you want to set the current address ID as default instead?', c1.address_type_code);
         END IF;
      END LOOP;
   END IF;
END Validate___;


PROCEDURE Modify_End_Cust_Addr_Info___(
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 )
IS
   count_         NUMBER := 0;
   address_rec_   Public_Rec;
   CURSOR get_end_cust_connections IS
      SELECT * 
      FROM   customer_info_address_tab
      WHERE  end_customer_id = customer_id_
      AND    end_cust_addr_id = address_id_;
   
BEGIN
   address_rec_ := Get(customer_id_, address_id_);
   FOR rec_ IN get_end_cust_connections LOOP  
      count_:= count_+1;
      rec_.address1  := address_rec_.address1;
      rec_.address2  := address_rec_.address2;
      rec_.address3  := address_rec_.address3;
      rec_.address4  := address_rec_.address4;
      rec_.address5  := address_rec_.address5;
      rec_.address6  := address_rec_.address6;
      rec_.zip_code  := address_rec_.zip_code;
      rec_.city      := address_rec_.city;
      rec_.state     := address_rec_.state;
      rec_.county    := address_rec_.county;
      rec_.country   := address_rec_.country;
      Modify___(rec_);
   END LOOP;
   IF (count_ > 0) THEN      
      Client_SYS.Add_Info(lu_name_, 'ENDCUSTADRSUPDATED: All the addresses connected as end customer addresses were updated.');
   END IF;
END Modify_End_Cust_Addr_Info___;    


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PARTY_TYPE', Party_Type_API.Decode('CUSTOMER'), attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('IN_CITY', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT customer_info_address_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS 
BEGIN
   Get_Customer_Party___(newrec_, attr_);
   super(objid_, objversion_, newrec_, attr_);   
   $IF Component_Order_SYS.INSTALLED $THEN
      IF (newrec_.end_customer_id IS NOT NULL) THEN
         Cust_Ord_Customer_Address_API.Set_End_Cust_Ord_Addr_Info(newrec_.customer_id, newrec_.end_customer_id, newrec_.address_id, newrec_.end_cust_addr_id);
      END IF;
   $END
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Insert___(newrec_);
      Rm_Dup_Check_For_Duplicate___(attr_, newrec_);
   $ELSE
      NULL;
   $END
   $IF Component_Crm_SYS.INSTALLED $THEN  
      -- Add a log to account CRM journal
      Crm_Cust_Info_History_API.New_Event(customer_id_   => newrec_.customer_id, 
                                          event_type_db_ => Rmcom_Event_Type_API.DB_HISTORY, 
                                          action_        => 'C', 
                                          event_db_      => 'ADDRESS_ID', 
                                          description_   => newrec_.address_id, 
                                          info_          => Language_SYS.Translate_Constant(lu_name_, 'ADDRESS_ADDED_CUSTOMER: Address :P1 has been added.', NULL, newrec_.address_id));
   $ELSE
      NULL;
   $END
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     customer_info_address_tab%ROWTYPE,
   newrec_     IN OUT customer_info_address_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   validation_result_   VARCHAR2(5);
   validation_flag_     VARCHAR2(5);   
   CURSOR get_address_types(customer_id_ IN VARCHAR2, address_id_ IN VARCHAR2) IS
      SELECT t.rowid, t.customer_id, Address_Type_Code_API.Decode(t.address_type_code) AS address_type_code, t.def_address
      FROM   customer_info_address_type_tab t
      WHERE  t.customer_id = customer_id_
      AND    t.address_id = address_id_;
BEGIN    
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);     
   -- Once End Customer is connected, address information are not allowed to modify manually.
   -- For the other records(end_customer_id null) address information are allowed to be modified and then  
   -- checking only such records and update the address information of connected end user addresses.
   IF (newrec_.end_customer_id IS NULL) THEN
      IF ((NVL(oldrec_.address1, ' ') != NVL(newrec_.address1, ' ')) OR
          (NVL(oldrec_.address2, ' ') != NVL(newrec_.address2, ' ')) OR
          (NVL(oldrec_.address3, ' ') != NVL(newrec_.address3, ' ')) OR
          (NVL(oldrec_.address4, ' ') != NVL(newrec_.address4, ' ')) OR
          (NVL(oldrec_.address5, ' ') != NVL(newrec_.address5, ' ')) OR
          (NVL(oldrec_.address6, ' ') != NVL(newrec_.address6, ' ')) OR
          (NVL(oldrec_.zip_code, ' ') != NVL(newrec_.zip_code, ' ')) OR
          (NVL(oldrec_.city, ' ')     != NVL(newrec_.city, ' ')) OR
          (NVL(oldrec_.state, ' ')    != NVL(newrec_.state, ' ')) OR
          (NVL(oldrec_.county, ' ')   != NVL(newrec_.county, ' ')) OR
          (NVL(oldrec_.country, ' ')  != NVL(newrec_.country, ' ')) ) THEN
         Modify_End_Cust_Addr_Info___(newrec_.customer_id, newrec_.address_id);     
      END IF;
   ELSIF NVL(oldrec_.end_customer_id, Database_SYS.string_null_) != NVL(newrec_.end_customer_id, Database_SYS.string_null_) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Cust_Ord_Customer_Address_API.Set_End_Cust_Ord_Addr_Info(newrec_.customer_id, newrec_.end_customer_id, newrec_.address_id, newrec_.end_cust_addr_id);
      $ELSE
         NULL;
      $END
   END IF;  
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Update___(newrec_);
      Rm_Dup_Check_For_Duplicate___(attr_, newrec_);
   $ELSE
      NULL;
   $END
   -- Logic to remove address default flag on other address IDs if time period overlaps.
   IF (NVL(newrec_.valid_from, Database_Sys.Get_First_Calendar_Date()) != NVL(oldrec_.valid_from, Database_Sys.Get_First_Calendar_Date())) OR 
      (NVL(newrec_.valid_to, Database_Sys.Get_Last_Calendar_Date()) != NVL(oldrec_.valid_to, Database_Sys.Get_Last_Calendar_Date())) THEN 
      FOR c1 IN get_address_types(newrec_.customer_id, newrec_.address_id) LOOP
         Customer_Info_Address_Type_API.Check_Def_Address_Exist(validation_result_, 
                                                                validation_flag_, 
                                                                c1.customer_id, 
                                                                c1.def_address, 
                                                                c1.address_type_code, 
                                                                c1.rowid, 
                                                                newrec_.valid_from, 
                                                                newrec_.valid_to);
         IF (c1.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
            Customer_Info_Address_Type_API.Check_Def_Addr_Temp(c1.customer_id, 
                                                               c1.address_type_code, 
                                                               c1.def_address,
                                                               c1.rowid, 
                                                               newrec_.valid_from, 
                                                               newrec_.valid_to);
         END IF;
      END LOOP;
   END IF;
   $IF Component_Loc_SYS.INSTALLED $THEN
      IF (Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_id) = 'CUSTOMER') THEN
         Location_API.Handle_Party_Location(Location_Category_API.DB_CUSTOMER, newrec_.customer_id, newrec_.address_id);
      END IF;
   $END
   $IF Component_Crm_SYS.INSTALLED $THEN
      -- log address column changes in account CRM journal
      Crm_Cust_Info_History_API.Log_Address_Changes(oldrec_,newrec_);
   $END
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_info_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
BEGIN
   newrec_.in_city := NVL(newrec_.in_city, 'FALSE');
   super(newrec_, indrec_, attr_);
   IF (newrec_.output_media IS NULL) THEN      
      newrec_.output_media := '1';
   END IF;
   Attribute_Definition_API.Check_Value(newrec_.address_id, lu_name_, 'ADDRESS_ID');
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_info_address_tab%ROWTYPE,
   newrec_ IN OUT customer_info_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PARTY', newrec_.party);
END Check_Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN customer_info_address_tab%ROWTYPE )
IS
   addr_type_code_list_     VARCHAR2(2000);
   addr_type_count_         NUMBER;
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   counter_                 NUMBER := 1;
   info_str_                VARCHAR2(2000);
   CURSOR get_address_types (customer_id_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT *
      FROM   customer_info_address_type
      WHERE  customer_id = customer_id_
      AND   address_id = address_id_;
   CURSOR get_def_address_types_count (customer_id_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT COUNT(*)
      FROM   customer_info_address_type
      WHERE  customer_id = customer_id_
      AND    address_id = address_id_
      AND    def_address = 'TRUE';
BEGIN
   OPEN get_def_address_types_count(remrec_.customer_id, remrec_.address_id);
   FETCH get_def_address_types_count INTO addr_type_count_;
   CLOSE get_def_address_types_count;
   FOR rec_ IN get_address_types(remrec_.customer_id, remrec_.address_id) LOOP
      Customer_Info_Address_Type_API.Check_Def_Address_Exist(validation_result_, validation_flag_, rec_.customer_id, rec_.def_address, rec_.address_type_code_db, rec_.objid, remrec_.valid_from, remrec_.valid_to);
      IF ((validation_result_ = 'TRUE') AND (rec_.def_address = 'TRUE')) THEN
         IF ((counter_ = 1)  AND (addr_type_count_ > 1)) THEN
            addr_type_code_list_ := CONCAT(rec_.address_type_code, ', ');
         ELSIF (counter_ = addr_type_count_) THEN
            addr_type_code_list_ := CONCAT(addr_type_code_list_, CONCAT(rec_.address_type_code, ''));
         ELSE
            addr_type_code_list_ := CONCAT(addr_type_code_list_, CONCAT(rec_.address_type_code, ', '));
         END IF;
         counter_ := counter_ + 1;
      END IF;
   END LOOP;
   IF (addr_type_code_list_ IS NOT NULL) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVEADDRWITHDEFADDRTYPES: This is the default :P1 Address Type(s) for Customer :P2. If removed, there will be no default address for this Address Type(s).', addr_type_code_list_, remrec_.customer_id);
   END IF;
   info_str_ := Client_SYS.Get_All_Info();
   super(remrec_);
   Client_SYS.Clear_Info();
   Client_SYS.Merge_Info(info_str_);     
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN customer_info_address_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Delete___(remrec_);
   $ELSE
      NULL;
   $END
END Delete___;

   
PROCEDURE Check_Customer_Id_Ref___ (
   newrec_ IN OUT customer_info_address_tab%ROWTYPE )
IS
   customer_category_   customer_info_tab.customer_category%TYPE;
BEGIN
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_id);
   Customer_Info_API.Exist(newrec_.customer_id, customer_category_);
END Check_Customer_Id_Ref___;


PROCEDURE Check_End_Customer_Id_Ref___ (
   newrec_ IN OUT customer_info_address_tab%ROWTYPE )
IS
   customer_category_   customer_info_tab.customer_category%TYPE;
BEGIN
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(newrec_.end_customer_id);
   Customer_Info_API.Exist(newrec_.end_customer_id, customer_category_);
END Check_End_Customer_Id_Ref___;


PROCEDURE Rm_Dup_Insert___ (
   rec_  IN customer_info_address_tab%ROWTYPE )
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
   rec_  IN customer_info_address_tab%ROWTYPE )
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
   rec_  IN customer_info_address_tab%ROWTYPE )
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
   rec_  IN     customer_info_address_tab%ROWTYPE )
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

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_ customer_info_address_tab%ROWTYPE;
BEGIN 
   Client_SYS.Add_To_Attr('ACTION', action_, attr_);   
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      newrec_ := Get_Object_By_Id___(objid_);
      Pack_And_Post_Message__(newrec_, 'ADDEDIT');
   END IF;
END New__;


@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_ customer_info_address_tab%ROWTYPE;
BEGIN   
   Client_SYS.Add_To_Attr('ACTION', action_, attr_);   
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      newrec_ := Get_Object_By_Id___(objid_);
      Pack_And_Post_Message__(newrec_, 'ADDEDIT');
   END IF;
END Modify__;


@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ customer_info_address_tab%ROWTYPE;
BEGIN      
   IF (action_ = 'DO') THEN
      remrec_ := Get_Object_By_Id___(objid_);
      Cascade_Delete_Comm_Method__(remrec_.customer_id, remrec_.address_id);
   END IF; 
   super(info_, objid_, objversion_, action_);
   IF (action_ = 'DO') THEN      
      Pack_And_Post_Message__(remrec_, 'ADDEDIT');
   END IF;
END Remove__;


PROCEDURE Pack_And_Post_Message__ (
   rec_    IN customer_info_address_tab%ROWTYPE,
   action_ IN VARCHAR2 )
IS
   def_addr_id_               VARCHAR2(50);
   object_property_value_     VARCHAR2(1000);
   hse_address_param_rec_     Plsqlap_Record_API.Type_Record_;
   xml_                       CLOB;
BEGIN
   object_property_value_ := Object_Property_API.Get_Value('CustomerInfoAddress', 'CUSTOMER', 'HSE'); 
   IF (NVL(object_property_value_,'FALSE') <> 'FALSE') THEN
      def_addr_id_ := Get_Id_By_Type(rec_.customer_id, Address_Type_Code_API.Decode('INVOICE'));
      def_addr_id_ := NVL(def_addr_id_, rec_.address_id);
      $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
         IF (rec_.address_id = def_addr_id_) THEN 
            Trace_SYS.Message('HSE transfer: TRUE');
            hse_address_param_rec_ := Plsqlap_Record_API.New_Record('HSE_CUSTOMER_ADDRESS_PARAMS');
            Plsqlap_Record_API.Set_Value(hse_address_param_rec_, 'CUSTOMER_ID', rec_.customer_id);
            Plsqlap_Record_API.Set_Value(hse_address_param_rec_, 'ADDRESS_ID', def_addr_id_);
            IF (action_ = 'ADDEDIT') THEN
               Plsqlap_Record_API.To_Xml(xml_, hse_address_param_rec_);
               Plsqlap_Server_API.Post_Outbound_Message(xml_      => xml_,
                                                        sender_   => Fnd_Session_API.Get_Fnd_User,
                                                        receiver_ => 'HSECustomerAddress');
            END IF;
            IF (action_ = 'DELETE') THEN
               -- For delete operation, use custom event and Application Message event action to trigger BIZAPI
               NULL;
            END IF;
         ELSE
            Trace_SYS.Message('HSE transfer: FALSE');
         END IF;
      $ELSE
         NULL;
      $END 
   END IF; 
END Pack_And_Post_Message__;


PROCEDURE Cascade_Delete_Comm_Method__ (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
   CURSOR comm_method_ IS
      SELECT ROWID, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') AS rowversion
      FROM   comm_method_tab
      WHERE  party_type = 'CUSTOMER'
      AND    identity   = customer_id_
      AND    address_id  = address_id_;
BEGIN
   FOR item_ IN comm_method_ LOOP
      Comm_Method_API.Remove__(info_, item_.ROWID, item_.rowversion, 'DO');
   END LOOP;
END Cascade_Delete_Comm_Method__;
                
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
@UncheckedAccess
FUNCTION Get_Name (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_info_address_tab.name%TYPE;   
BEGIN
    temp_ := super(customer_id_, address_id_);
    RETURN  NVL(temp_, Customer_Info_API.Get_Name(customer_id_));   
END Get_Name;


FUNCTION Get_Address_Form (
   identity_       IN VARCHAR2,
   address_id_     IN VARCHAR2,
   fetch_name_     IN VARCHAR2 DEFAULT 'FALSE',
   remove_empty_   IN VARCHAR2 DEFAULT 'TRUE',
   separator_      IN VARCHAR2 DEFAULT NULL,
   order_language_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   address_         VARCHAR2(2000);
   country_         VARCHAR2(35);
   name_            customer_info_tab.name%TYPE;
   address_record_  Public_Rec;
BEGIN
   address_record_ := Get(identity_, address_id_);
   address_ := Address_Presentation_API.Format_Address(address_record_.country, 
                                                       address_record_.address1,
                                                       address_record_.address2,
                                                       address_record_.address3,
                                                       address_record_.address4,
                                                       address_record_.address5,
                                                       address_record_.address6,
                                                       address_record_.city,
                                                       address_record_.county,
                                                       address_record_.state,
                                                       address_record_.zip_code,
                                                       country_,
                                                       order_language_);
   IF (fetch_name_ = 'TRUE') THEN
      name_    := Customer_Info_API.Get_Name(identity_);
      address_ := name_ || Address_Presentation_API.lfcr_ || address_;
   END IF;                            
   IF (separator_ IS NOT NULL) THEN
      address_ := REPLACE(address_,Address_Presentation_API.lfcr_,separator_);                                                        
   END IF;
   RETURN address_;
END Get_Address_Form;


FUNCTION Get_Address_Rec (
   identity_     IN VARCHAR2,
   address_id_   IN VARCHAR2,
   fetch_name_   IN VARCHAR2 DEFAULT 'FALSE',
   remove_empty_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN Address_Presentation_API.Address_Rec_Type
IS
   address_rec_     Address_Presentation_API.Address_Rec_Type;
   address_         VARCHAR2(2000);
BEGIN
   address_     := Get_Address_Form(identity_, address_id_, fetch_name_, remove_empty_);
   address_rec_ := Address_Presentation_API.Format_To_Line(address_);
   RETURN address_rec_;
END Get_Address_Rec;


PROCEDURE Get_All_Address_Lines (
   address_l_    IN OUT VARCHAR2,
   address_2_    IN OUT VARCHAR2,
   address_3_    IN OUT VARCHAR2,
   address_4_    IN OUT VARCHAR2,
   address_5_    IN OUT VARCHAR2,
   address_6_    IN OUT VARCHAR2,
   identity_     IN     VARCHAR2,
   address_id_   IN     VARCHAR2,
   fetch_name_   IN     VARCHAR2 DEFAULT 'FALSE',
   remove_empty_ IN     VARCHAR2 DEFAULT 'TRUE')
IS
   address_rec_        Address_Presentation_API.Address_Rec_Type;
BEGIN
   address_rec_ := Get_Address_Rec(identity_, address_id_, fetch_name_, remove_empty_);
   address_l_   := address_rec_.address1;
   address_2_   := address_rec_.address2;
   address_3_   := address_rec_.address3;
   address_4_   := address_rec_.address4;
   address_5_   := address_rec_.address5;
   address_6_   := address_rec_.address6;
END Get_All_Address_Lines;


PROCEDURE Get_All_Address_Lines (
   address_l_    IN OUT VARCHAR2,
   address_2_    IN OUT VARCHAR2,
   address_3_    IN OUT VARCHAR2,
   address_4_    IN OUT VARCHAR2,
   address_5_    IN OUT VARCHAR2,
   address_6_    IN OUT VARCHAR2,
   address_7_    IN OUT VARCHAR2,
   address_8_    IN OUT VARCHAR2,
   address_9_    IN OUT VARCHAR2,
   address_10_   IN OUT VARCHAR2,
   identity_     IN     VARCHAR2,
   address_id_   IN     VARCHAR2,
   fetch_name_   IN     VARCHAR2 DEFAULT 'FALSE',
   remove_empty_ IN     VARCHAR2 DEFAULT 'TRUE')
IS
   address_rec_        Address_Presentation_API.Address_Rec_Type;
BEGIN
   address_rec_ := Get_Address_Rec(identity_, address_id_, fetch_name_, remove_empty_);
   address_l_   := address_rec_.address1;
   address_2_   := address_rec_.address2;
   address_3_   := address_rec_.address3;
   address_4_   := address_rec_.address4;
   address_5_   := address_rec_.address5;
   address_6_   := address_rec_.address6;
   address_7_   := address_rec_.address7;
   address_8_   := address_rec_.address8;
   address_9_   := address_rec_.address9;
   address_10_  := address_rec_.address10;
END Get_All_Address_Lines;


FUNCTION Get_Address_Line (
   identity_     IN VARCHAR2,
   address_id_   IN VARCHAR2,
   line_no_      IN NUMBER DEFAULT 1,
   remove_empty_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN VARCHAR2
IS
   address_rec_     Address_Presentation_API.Address_Rec_Type;
   address_line_    VARCHAR2(2000);
BEGIN
   address_rec_ := Get_Address_Rec(identity_, address_id_, 'FALSE', remove_empty_);
   address_line_ := CASE line_no_
                       WHEN 1 THEN address_rec_.address1
                       WHEN 2 THEN address_rec_.address2
                       WHEN 3 THEN address_rec_.address3
                       WHEN 4 THEN address_rec_.address4
                       WHEN 5 THEN address_rec_.address5
                       WHEN 6 THEN address_rec_.address6
                       WHEN 7 THEN address_rec_.address7
                       WHEN 8 THEN address_rec_.address8
                       WHEN 9 THEN address_rec_.address9
                       WHEN 10 THEN address_rec_.address10
                    END;
   RETURN address_line_;
END Get_Address_Line;


PROCEDURE Get_Id_By_Ean_Loc_If_Unique (
   customer_id_  IN OUT VARCHAR2,
   address_id_   IN OUT VARCHAR2,
   ean_location_ IN     VARCHAR2 )
IS 
   dummy_        NUMBER;
   CURSOR get_count IS
      SELECT COUNT(*)
      FROM   customer_info_address_tab
      WHERE  ean_location = ean_location_;
   CURSOR get_info IS
      SELECT customer_id, address_id
      FROM   customer_info_address_tab
      WHERE  ean_location = ean_location_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO dummy_;
   CLOSE get_count;
   IF (dummy_ = 1) THEN
      OPEN get_info;
      FETCH get_info INTO customer_id_, address_id_;
      CLOSE get_info;
   ELSE
      customer_id_  := NULL;
      address_id_   := NULL;
   END IF;
END Get_Id_By_Ean_Loc_If_Unique;


PROCEDURE Sync_Addr (
   country_code_  IN VARCHAR2)
IS
   address_   customer_info_address_tab.address%TYPE;
   country_   iso_country_tab.description%TYPE;
   CURSOR get_records IS
      SELECT country, address1, address2, address3, address4, address5, address6,
             city, county, state, zip_code, address, ROWID objid
      FROM   customer_info_address_tab
      WHERE  country = country_code_
      FOR UPDATE;   
BEGIN
   country_:= Iso_Country_API.Decode(country_code_);  
   FOR rec_ IN get_records LOOP
      address_ := Address_Presentation_API.Format_Address(rec_.country,
                                                          rec_.address1,
                                                          rec_.address2,
                                                          rec_.address3,
                                                          rec_.address4,
                                                          rec_.address5,
                                                          rec_.address6,
                                                          rec_.city,
                                                          rec_.county,
                                                          rec_.state,
                                                          rec_.zip_code,
                                                          country_); 
      IF (address_ != rec_.address) THEN
         UPDATE customer_info_address_tab
            SET address = address_       
          WHERE ROWID = rec_.objid;       
      END IF;                            
   END LOOP;   
END Sync_Addr;


@UncheckedAccess
FUNCTION Get_Next_Address_Id (
   customer_id_ IN VARCHAR2,
   company_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_       NUMBER;
   temp_pay_   NUMBER;
   CURSOR get_next IS
      SELECT MAX(TO_NUMBER(address_id)) 
      FROM   customer_info_address_tab 
      WHERE  REGEXP_LIKE(address_id,'^[0-9]+$')
      AND    customer_id = customer_id_;
   $IF Component_Payled_SYS.INSTALLED $THEN
      CURSOR get_next_pay IS
         SELECT MAX(TO_NUMBER(address_id)) 
         FROM   payment_address_tab 
         WHERE  regexp_like(address_id,'^[0-9]+$')
         AND    company = company_
         AND    identity = customer_id_
         AND    party_type = 'CUSTOMER';
   $END
BEGIN
   OPEN  get_next;
   FETCH get_next INTO temp_;
   CLOSE get_next;
   $IF Component_Payled_SYS.INSTALLED $THEN
      OPEN  get_next_pay;
      FETCH get_next_pay INTO temp_pay_;
      CLOSE get_next_pay;
   $END
   RETURN GREATEST(NVL(temp_, 0),NVL(temp_pay_, 0)) + 1;
END Get_Next_Address_Id;


PROCEDURE Modify_One_Time_Address (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   attr_        IN VARCHAR2 )
IS
   oldrec_       customer_info_address_tab%ROWTYPE;
   newrec_       customer_info_address_tab%ROWTYPE;
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(200);
   newattr_      VARCHAR2(2000);
   indrec_       Indicator_Rec;
BEGIN
   IF (Check_Exist___( customer_id_, address_id_)) THEN
      newattr_ := attr_;
      oldrec_ := Lock_By_Keys___(customer_id_, address_id_);
      Get_Id_Version_By_Keys___(objid_, objversion_, customer_id_, address_id_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, newattr_);
      Check_Update___(oldrec_, newrec_, indrec_, newattr_);
      Update___(objid_, oldrec_, newrec_, newattr_, objversion_);
   ELSE
      Client_SYS.Add_To_Attr('CUSTOMER_ID', customer_id_, newattr_);
      Client_SYS.Add_To_Attr('ADDRESS_ID', address_id_, newattr_);
      newattr_ := newattr_ || attr_;
      Client_SYS.Add_To_Attr('PARTY_TYPE', Party_Type_API.Decode('CUSTOMER'), newattr_);
      Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', 'TRUE', newattr_);
      Client_SYS.Add_To_Attr('IN_CITY', 'FALSE', newattr_);      
      Unpack___(newrec_, indrec_, newattr_);
      Check_Insert___(newrec_, indrec_, newattr_);
      Insert___(objid_, objversion_, newrec_, newattr_);
      Customer_Info_Address_Type_API.New_One_Time_Addr_Type(customer_id_, address_id_);
   END IF;
END Modify_One_Time_Address;


@UncheckedAccess
FUNCTION Get_Ar_Contact_Name (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_    VARCHAR2(200);
   comm_id_ NUMBER;
BEGIN
   comm_id_ := Get_Comm_Id(customer_id_, address_id_);
   temp_ := Comm_Method_API.Get_Name(Party_Type_API.Decode('CUSTOMER'), customer_id_, comm_id_);
   RETURN temp_;
END Get_Ar_Contact_Name;


@UncheckedAccess
FUNCTION Get_Delivery_Country_Db (
   customer_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   delivery_address_id_      customer_info_address_tab.address_id%TYPE;
BEGIN
   delivery_address_id_ := Get_Default_Address(customer_id_, Address_Type_Code_API.Decode('DELIVERY'));
   RETURN Get_Country_Code(customer_id_, delivery_address_id_ );
END Get_Delivery_Country_Db;


@UncheckedAccess
FUNCTION Get_Line (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   line_no_     IN NUMBER DEFAULT 1 ) RETURN VARCHAR2
IS
   country_       customer_info_address.country%TYPE;
   address_pres_  Address_Presentation_API.Public_Rec_Address;
   line_          NUMBER;
   row1_          VARCHAR2(100);
   row2_          VARCHAR2(100);
   row3_          VARCHAR2(100);
   row4_          VARCHAR2(100);
   row5_          VARCHAR2(100);
BEGIN
   country_ := Get_Country_Code(customer_id_, address_id_); 
   address_pres_ := Address_Presentation_API.Get_Address_Record(country_);          
   line_ := line_no_;
   -- IF line_no_ = 0 then return the last line.
   -- Set line_no_ to the highest row in the definition
   IF (line_ = 0) THEN
      line_ := address_pres_.address1_row;
      IF (address_pres_.address2_row > line_) THEN
         line_ := address_pres_.address2_row;
      END IF;
      IF (address_pres_.address3_row > line_) THEN
         line_ := address_pres_.address3_row;
      END IF;
      IF (address_pres_.address4_row > line_) THEN
         line_ := address_pres_.address4_row;
      END IF;
      IF (address_pres_.address5_row > line_) THEN
         line_ := address_pres_.address5_row;
      END IF;
      IF (address_pres_.address6_row > line_) THEN
         line_ := address_pres_.address6_row;
      END IF;
      IF (address_pres_.zip_code_row > line_) THEN
         line_ := address_pres_.zip_code_row;
      END IF;
      IF (address_pres_.city_row > line_) THEN
         line_ := address_pres_.city_row;
      END IF;
      IF (address_pres_.county_row > line_) THEN
         line_ := address_pres_.county_row;
      END IF;
      IF (address_pres_.state_row > line_) THEN
         line_ := address_pres_.state_row;
      END IF;
   END IF;
   -- Check the different address fields for the correct line number.
   -- Put the value in the right order.
   IF (address_pres_.address1_row = line_) THEN
      IF (address_pres_.address1_order = 1) THEN
         row1_ := Get_Address1(customer_id_, address_id_);
      ELSIF (address_pres_.address1_order = 2) THEN
         row2_ := Get_Address1(customer_id_, address_id_);
      ELSIF (address_pres_.address1_order = 3) THEN
         row3_ := Get_Address1(customer_id_, address_id_);
      ELSIF (address_pres_.address1_order = 4) THEN
         row4_ := Get_Address1(customer_id_, address_id_);
      ELSIF (address_pres_.address1_order = 5) THEN
         row5_ := Get_Address1(customer_id_, address_id_);
      ELSE
         row1_ := Get_Address1(customer_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address2_row = line_) THEN
      IF (address_pres_.address2_order = 1) THEN
         row1_ := Get_Address2(customer_id_, address_id_);
      ELSIF (address_pres_.address2_order = 2) THEN
         row2_ := Get_Address2(customer_id_, address_id_);
      ELSIF (address_pres_.address2_order = 3) THEN
         row3_ := Get_Address2(customer_id_, address_id_);
      ELSIF (address_pres_.address2_order = 4) THEN
         row4_ := Get_Address2(customer_id_, address_id_);
      ELSIF (address_pres_.address2_order = 5) THEN
         row5_ := Get_Address2(customer_id_, address_id_);
      ELSE
         row1_ := Get_Address2(customer_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address3_row = line_) THEN
      IF (address_pres_.address3_order = 1) THEN
         row1_ := Get_Address3(customer_id_, address_id_);
      ELSIF (address_pres_.address3_order = 2) THEN
         row2_ := Get_Address3(customer_id_, address_id_);
      ELSIF (address_pres_.address3_order = 3) THEN
         row3_ := Get_Address3(customer_id_, address_id_);
      ELSIF (address_pres_.address3_order = 4) THEN
         row4_ := Get_Address3(customer_id_, address_id_);
      ELSIF (address_pres_.address3_order = 5) THEN
         row5_ := Get_Address3(customer_id_, address_id_);
      ELSE
         row1_ := Get_Address3(customer_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address4_row = line_) THEN
      IF (address_pres_.address4_order = 1) THEN
         row1_ := Get_Address4(customer_id_, address_id_);
      ELSIF (address_pres_.address4_order = 2) THEN
         row2_ := Get_Address4(customer_id_, address_id_);
      ELSIF (address_pres_.address4_order = 3) THEN
         row3_ := Get_Address4(customer_id_, address_id_);
      ELSIF (address_pres_.address4_order = 4) THEN
         row4_ := Get_Address4(customer_id_, address_id_);
      ELSIF (address_pres_.address4_order = 5) THEN
         row5_ := Get_Address4(customer_id_, address_id_);
      ELSE
         row1_ := Get_Address4(customer_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address5_row = line_) THEN
      IF (address_pres_.address5_order = 1) THEN
         row1_ := Get_Address5(customer_id_, address_id_);
      ELSIF (address_pres_.address5_order = 2) THEN
         row2_ := Get_Address5(customer_id_, address_id_);
      ELSIF (address_pres_.address5_order = 3) THEN
         row3_ := Get_Address5(customer_id_, address_id_);
      ELSIF (address_pres_.address5_order = 4) THEN
         row4_ := Get_Address5(customer_id_, address_id_);
      ELSIF (address_pres_.address5_order = 5) THEN
         row5_ := Get_Address5(customer_id_, address_id_);
      ELSE
         row1_ := Get_Address5(customer_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address6_row = line_) THEN
      IF (address_pres_.address6_order = 1) THEN
         row1_ := Get_Address6(customer_id_, address_id_);
      ELSIF (address_pres_.address6_order = 2) THEN
         row2_ := Get_Address6(customer_id_, address_id_);
      ELSIF (address_pres_.address6_order = 3) THEN
         row3_ := Get_Address6(customer_id_, address_id_);
      ELSIF (address_pres_.address6_order = 4) THEN
         row4_ := Get_Address6(customer_id_, address_id_);
      ELSIF (address_pres_.address6_order = 5) THEN
         row5_ := Get_Address6(customer_id_, address_id_);
      ELSE
         row1_ := Get_Address6(customer_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.zip_code_row = line_) THEN
      IF (address_pres_.zip_code_order = 1) THEN
         row1_ := Get_Zip_Code(customer_id_, address_id_);
      ELSIF (address_pres_.zip_code_order = 2) THEN
         row2_ := Get_Zip_Code(customer_id_, address_id_);
      ELSIF (address_pres_.zip_code_order = 3) THEN
         row3_ := Get_Zip_Code(customer_id_, address_id_);
      ELSIF (address_pres_.zip_code_order = 4) THEN
         row4_ := Get_Zip_Code(customer_id_, address_id_);
      ELSIF (address_pres_.zip_code_order = 5) THEN
         row5_ := Get_Zip_Code(customer_id_, address_id_);
      ELSE
         row1_ := Get_Zip_Code(customer_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.city_row = line_) THEN
      IF (address_pres_.city_order = 1) THEN
         row1_ := Get_City(customer_id_, address_id_);
      ELSIF (address_pres_.city_order = 2) THEN
         row2_ := Get_City(customer_id_, address_id_);
      ELSIF (address_pres_.city_order = 3) THEN
         row3_ := Get_City(customer_id_, address_id_);
      ELSIF (address_pres_.city_order = 4) THEN
         row4_ := Get_City(customer_id_, address_id_);
      ELSIF (address_pres_.city_order = 5) THEN
         row5_ := Get_City(customer_id_, address_id_);
      ELSE
         row1_ := Get_City(customer_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.county_row = line_) THEN
      IF (address_pres_.county_order = 1) THEN
         row1_ := Get_County(customer_id_, address_id_);
      ELSIF (address_pres_.county_order = 2) THEN
         row2_ := Get_County(customer_id_, address_id_);
      ELSIF (address_pres_.county_order = 3) THEN
         row3_ := Get_County(customer_id_, address_id_);
      ELSIF (address_pres_.county_order = 4) THEN
         row4_ := Get_County(customer_id_, address_id_);
      ELSIF (address_pres_.county_order = 5) THEN
         row5_ := Get_County(customer_id_, address_id_);
      ELSE
         row1_ := Get_County(customer_id_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.state_row = line_) THEN
      IF (address_pres_.state_order = 1) THEN
         row1_ := Get_State(customer_id_, address_id_);
      ELSIF (address_pres_.state_order = 2) THEN
         row2_ := Get_State(customer_id_, address_id_);
      ELSIF (address_pres_.state_order = 3) THEN
         row3_ := Get_State(customer_id_, address_id_);
      ELSIF (address_pres_.state_order = 4) THEN
         row4_ := Get_State(customer_id_, address_id_);
      ELSIF (address_pres_.state_order = 5) THEN
         row5_ := Get_State(customer_id_, address_id_);
      ELSE
         row1_ := Get_State(customer_id_, address_id_);
      END IF;
   END IF;
   --Concatenate the different parts.
   RETURN RTRIM(LTRIM(row1_ || ' ' || row2_ || ' ' || row3_ || ' ' || row4_ || ' ' || row5_));
END Get_Line;


@UncheckedAccess
FUNCTION Get_Lines_Count (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 ) RETURN NUMBER
IS
   country_       customer_info_address.country%TYPE;
   address_pres_  Address_Presentation_API.Public_Rec_Address;
   line_no_       NUMBER;
BEGIN
   country_ := Get_Country(customer_id_ ,address_id_);
   address_pres_ := Address_Presentation_API.Get_Address_Record(Iso_Country_API.Encode(country_));
   -- Get the highest row value in the definition.
   line_no_ := address_pres_.address1_row;
   IF (address_pres_.address2_row > line_no_) THEN
      line_no_ := address_pres_.address2_row;
   END IF;
   IF (address_pres_.address3_row > line_no_) THEN
      line_no_ := address_pres_.address3_row;
   END IF;
   IF (address_pres_.address4_row > line_no_) THEN
      line_no_ := address_pres_.address4_row;
   END IF;
   IF (address_pres_.address5_row > line_no_) THEN
      line_no_ := address_pres_.address5_row;
   END IF;
   IF (address_pres_.address6_row > line_no_) THEN
      line_no_ := address_pres_.address6_row;
   END IF;
   IF (address_pres_.zip_code_row > line_no_) THEN
      line_no_ := address_pres_.zip_code_row;
   END IF;
   IF (address_pres_.city_row > line_no_) THEN
      line_no_ := address_pres_.city_row;
   END IF;
   IF (address_pres_.county_row > line_no_) THEN
      line_no_ := address_pres_.county_row;
   END IF;
   IF (address_pres_.state_row > line_no_) THEN
      line_no_ := address_pres_.state_row;
   END IF;
   IF (line_no_ IS NULL) THEN
      RETURN 0;
   END IF;
   RETURN line_no_;
END Get_Lines_Count;
    

@UncheckedAccess
FUNCTION Get_Db_Types (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   types_   VARCHAR2(2000) := Client_SYS.text_separator_;
   CURSOR types IS
      SELECT address_type_code_db
      FROM   customer_info_address_type
      WHERE  customer_id = customer_id_
      AND    address_id = address_id_;
BEGIN
   FOR t IN types LOOP
      types_ := types_ || t.address_type_code_db || Client_SYS.text_separator_;
   END LOOP;
   RETURN types_;
END Get_Db_Types;


@UncheckedAccess
FUNCTION Get_Id_By_Type (
   customer_id_       IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   curr_date_         IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   addr_id_  VARCHAR2(50);
   db_value_ VARCHAR2(20);
   CURSOR get_id_by IS
      SELECT a.address_id
      FROM   customer_info_address_tab a, customer_info_address_type t
      WHERE  a.customer_id = customer_id_
      AND    t.customer_id = a.customer_id
      AND    t.address_id = a.address_id
      AND    t.def_address = 'TRUE'
      AND    t.address_type_code_db =  db_value_
      AND    TRUNC(curr_date_) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date());
BEGIN
   db_value_ := Address_Type_Code_API.encode(address_type_code_);
   OPEN get_id_by;
   FETCH get_id_by INTO addr_id_;
   IF (get_id_by%NOTFOUND) THEN
      CLOSE get_id_by;
      RETURN NULL;
   END IF;
   CLOSE get_id_by;
   RETURN addr_id_;
END Get_Id_By_Type;


@UncheckedAccess
FUNCTION Get_Id_By_Ean_Location (
   customer_id_  IN VARCHAR2,
   ean_location_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   address_id_  VARCHAR2(50);
   CURSOR get_id IS
      SELECT address_id
      FROM   customer_info_address_tab
      WHERE  customer_id = customer_id_
      AND    ean_location = ean_location_;
BEGIN
   OPEN get_id;
   FETCH get_id INTO address_id_;
   IF (get_ID%NOTFOUND) THEN
      CLOSE get_id;
      RETURN NULL;
   END IF;
   CLOSE get_id;
   RETURN address_id_;
END Get_Id_By_Ean_Location;


@UncheckedAccess
FUNCTION Is_Valid (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   curr_date_   IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   is_valid_    NUMBER;
   CURSOR valid_data IS
      SELECT 1
      FROM   customer_info_address_tab
      WHERE  customer_id = customer_id_
      AND    address_id = address_id_
      AND    TRUNC(curr_date_) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date());
BEGIN
   OPEN valid_data;
   FETCH valid_data INTO is_valid_;
   IF (valid_data%NOTFOUND) THEN
      CLOSE valid_data;
      RETURN 'FALSE';
   ELSE
      CLOSE valid_data;
      RETURN 'TRUE';
   END IF;
END Is_Valid;


PROCEDURE New (
   customer_id_  IN VARCHAR2,
   address_id_   IN VARCHAR2,
   address_      IN VARCHAR2,
   country_      IN VARCHAR2,
   ean_location_ IN VARCHAR2 DEFAULT NULL,
   valid_from_   IN DATE DEFAULT NULL,
   valid_to_     IN DATE DEFAULT NULL )
IS
   newrec_       customer_info_address_tab%ROWTYPE;
   address1_     customer_info_address_tab.address1%TYPE;
   address2_     customer_info_address_tab.address2%TYPE;
   address3_     customer_info_address_tab.address3%TYPE;
   address4_     customer_info_address_tab.address4%TYPE;
   address5_     customer_info_address_tab.address5%TYPE;
   address6_     customer_info_address_tab.address6%TYPE;
   zip_code_     customer_info_address_tab.zip_code%TYPE;
   city_         customer_info_address_tab.city%TYPE;
   county_       customer_info_address_tab.county%TYPE;
   state_        customer_info_address_tab.state%TYPE;
BEGIN
   newrec_.customer_id        := customer_id_;
   newrec_.address_id         := address_id_;
   newrec_.country            := Iso_Country_API.Encode(country_);
   newrec_.party_type         := 'CUSTOMER';
   newrec_.default_domain     := 'TRUE';
   newrec_.ean_location       := ean_location_;    
   newrec_.valid_from         := valid_from_;
   newrec_.valid_to           := valid_to_;
   Split_Address___(address1_, address2_, address3_, address4_, address5_, address6_, zip_code_, city_, county_, state_, country_, address_);
   newrec_.address1  := address1_;
   newrec_.address2  := address2_;
   newrec_.address3  := address3_;
   newrec_.address4  := address4_;
   newrec_.address5  := address5_;
   newrec_.address6  := address6_; 
   newrec_.zip_code  := zip_code_;
   newrec_.city      := city_;
   newrec_.county    := county_;
   newrec_.state     := state_;
   New___(newrec_);   
END New;


PROCEDURE Modify (
   customer_id_  IN VARCHAR2,
   address_id_   IN VARCHAR2,
   address_      IN VARCHAR2 DEFAULT NULL,
   country_      IN VARCHAR2 DEFAULT NULL,
   ean_location_ IN VARCHAR2 DEFAULT NULL,
   valid_from_   IN DATE DEFAULT NULL,
   valid_to_     IN DATE DEFAULT NULL )
IS
   oldrec_       customer_info_address_tab%ROWTYPE;
   newrec_       customer_info_address_tab%ROWTYPE;
   address1_     customer_info_address_tab.address1%TYPE;
   address2_     customer_info_address_tab.address2%TYPE;
   address3_     customer_info_address_tab.address3%TYPE;
   address4_     customer_info_address_tab.address4%TYPE;
   address5_     customer_info_address_tab.address5%TYPE;
   address6_     customer_info_address_tab.address6%TYPE;
   zip_code_     customer_info_address_tab.zip_code%TYPE;
   city_         customer_info_address_tab.city%TYPE;
   county_       customer_info_address_tab.county%TYPE;
   state_        customer_info_address_tab.state%TYPE;
   country_temp_ customer_info_address.country%TYPE;
BEGIN
   oldrec_ := Get_Object_By_Keys___(customer_id_, address_id_);
   newrec_ := oldrec_;
   newrec_.country      := Iso_Country_API.Encode(country_);
   newrec_.ean_location := ean_location_;    
   newrec_.valid_from   := valid_from_;
   newrec_.valid_to     := valid_to_;   
   -- The new address fields should only be updated when the address_ is not NULL.
   IF (address_ IS NOT NULL) THEN
      -- IF the country is not supplied then use the country from the old record.
      country_temp_ := NVL(country_, Iso_Country_API.Decode(oldrec_.country));
      Split_Address___(address1_, address2_, address3_, address4_, address5_, address6_, zip_code_, city_, county_, state_, country_temp_, address_);
      newrec_.address1  := address1_;
      newrec_.address2  := address2_;
      newrec_.address3  := address3_;
      newrec_.address4  := address4_;
      newrec_.address5  := address5_;
      newrec_.address6  := address6_; 
      newrec_.zip_code  := zip_code_;
      newrec_.city      := city_;
      newrec_.county    := county_;
      newrec_.state     := state_;
      newrec_.country   := Iso_Country_API.Encode(country_temp_);      
   END IF;
   Modify___(newrec_);
END Modify;


PROCEDURE Remove (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 )
IS
   remrec_ customer_info_address_tab%ROWTYPE;
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(200);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, customer_id_, address_id_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


@UncheckedAccess
FUNCTION Get_Default_Address (
   customer_id_       IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   curr_date_         IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   address_id_   customer_info_address_tab.address_id%TYPE;
   db_value_     customer_info_address_type_tab.address_type_code%TYPE;
   CURSOR get_def_address IS     
       SELECT ci.address_id
       FROM   customer_info_address_tab ci, customer_info_address_type_tab cit
       WHERE  ci.customer_id               = customer_id_
       AND    cit.address_id               = ci.address_id
       AND    cit.customer_id              = ci.customer_id
       AND    cit.address_type_code        = db_value_
       AND    NVL(cit.def_address,'FALSE') = 'TRUE'
       AND    TRUNC(curr_date_) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date())
       AND    NVL(valid_to,   Database_SYS.Get_Last_Calendar_Date());
BEGIN
   db_value_ := Address_Type_Code_API.Encode(address_type_code_);
   OPEN  get_def_address;
   FETCH get_def_address INTO address_id_;
   IF (get_def_address%FOUND) THEN 
      RETURN address_id_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Default_Address;


PROCEDURE Copy_Customer (
   new_addr_id_ OUT VARCHAR2,
   customer_id_ IN  VARCHAR2,
   new_id_      IN  VARCHAR2,
   copy_info_   IN  Customer_Info_API.Copy_Param_Info)
IS   
   newrec_ customer_info_address_tab%ROWTYPE;
   oldrec_ customer_info_address_tab%ROWTYPE;
   CURSOR get_attr IS
      SELECT *
      FROM   customer_info_address_tab
      WHERE  customer_id = customer_id_;
   CURSOR get_def_attr IS
      SELECT *
      FROM   customer_info_address_tab
      WHERE  customer_id = customer_id_
      AND    address_id = copy_info_.temp_del_addr;
BEGIN
   -- if transfer address data is checked in CONVERT , copy address information from default delivery template
   -- when new customer has no default delivery address define
   IF (Customer_Info_API.Get_One_Time_Db(customer_id_) = 'FALSE') THEN
      IF (copy_info_.copy_convert_option = 'CONVERT') THEN   
         IF (copy_info_.temp_del_addr IS NOT NULL AND copy_info_.new_del_address IS NULL) THEN
            FOR def_ IN get_def_attr LOOP
               oldrec_ := Lock_By_Keys___(customer_id_, def_.address_id);   
               newrec_ := oldrec_ ;
               newrec_.customer_id := new_id_;
               newrec_.default_domain := 'TRUE';
               IF (Customer_Info_API.Get_Customer_Category_Db(new_id_) != Customer_Category_API.DB_CUSTOMER) THEN
                  newrec_.end_customer_id := NULL;
                  newrec_.end_cust_addr_id := NULL;
               END IF;
               newrec_.ean_location := NULL;
               IF (Check_Exist___(new_id_, copy_info_.temp_del_addr)) THEN
                  newrec_.address_id := Get_Next_Address_Id(new_id_, copy_info_.company );
                  new_addr_id_ :=  newrec_.address_id;
               END IF;
               New___(newrec_);
            END LOOP;
         END IF;
      ELSE
         FOR rec_ IN get_attr LOOP
            oldrec_ := Lock_By_Keys___(customer_id_, rec_.address_id);   
            newrec_ := oldrec_ ;
            newrec_.customer_id := new_id_;
            newrec_.default_domain := 'TRUE';
            IF (Customer_Info_API.Get_Customer_Category_Db(new_id_) != Customer_Category_API.DB_CUSTOMER) THEN
               newrec_.end_customer_id := NULL;
               newrec_.end_cust_addr_id := NULL;
            END IF;
            newrec_.ean_location := NULL;
            New___(newrec_);
         END LOOP;
      END IF;
   END IF;   
END Copy_Customer;


PROCEDURE New_Address (
   customer_id_      IN VARCHAR2,
   address_id_       IN VARCHAR2,
   address1_         IN VARCHAR2 DEFAULT NULL,
   address2_         IN VARCHAR2 DEFAULT NULL,
   zip_code_         IN VARCHAR2 DEFAULT NULL,
   city_             IN VARCHAR2 DEFAULT NULL,
   state_            IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2,
   ean_location_     IN VARCHAR2 DEFAULT NULL,
   valid_from_       IN DATE     DEFAULT NULL,
   valid_to_         IN DATE     DEFAULT NULL,
   county_           IN VARCHAR2 DEFAULT NULL,
   name_             IN VARCHAR2 DEFAULT NULL,
   address3_         IN VARCHAR2 DEFAULT NULL,
   address4_         IN VARCHAR2 DEFAULT NULL,
   address5_         IN VARCHAR2 DEFAULT NULL,
   address6_         IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       customer_info_address_tab%ROWTYPE;
BEGIN
   newrec_.customer_id  := customer_id_;
   newrec_.address_id   := address_id_;
   newrec_.name         := name_;
   newrec_.address1     := address1_;
   newrec_.address2     := address2_;
   newrec_.address3     := address3_;
   newrec_.address4     := address4_;
   newrec_.address5     := address5_;
   newrec_.address6     := address6_; 
   newrec_.zip_code     := zip_code_;
   newrec_.city         := city_;
   newrec_.county       := county_;
   newrec_.state        := state_;
   newrec_.country      := Iso_Country_API.Encode(country_);
   newrec_.party_type   := 'CUSTOMER';
   newrec_.default_domain  := 'TRUE';
   newrec_.ean_location := ean_location_;   
   newrec_.valid_from   := valid_from_;
   newrec_.valid_to     := valid_to_;
   New___(newrec_);   
END New_Address;


PROCEDURE Modify_Address (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   attr_        IN OUT VARCHAR2 )
IS
   oldrec_       customer_info_address_tab%ROWTYPE;
   newrec_       customer_info_address_tab%ROWTYPE;
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(200);
   indrec_       Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(customer_id_, address_id_);
   Get_Id_Version_By_Keys___(objid_, objversion_, customer_id_, address_id_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);   
END Modify_Address;


@UncheckedAccess
FUNCTION Get_Country_Code (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_info_address_tab.country%TYPE;
   CURSOR get_attr IS
      SELECT country
      FROM   customer_info_address_tab
      WHERE  customer_id = customer_id_
      AND    address_id = address_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Country_Code;


PROCEDURE Get_Address_Lines (
   addr_one_    IN OUT VARCHAR2,
   addr_two_    IN OUT VARCHAR2,
   addr_three_  IN OUT VARCHAR2,
   addr_four_   IN OUT VARCHAR2,
   addr_five_   IN OUT VARCHAR2,
   country_     IN OUT VARCHAR2,
   customer_id_ IN     VARCHAR2,
   address_id_  IN     VARCHAR2 )
IS
   address_pres_       Address_Presentation_API.Public_Rec_Address;
   line_               NUMBER;
   row1_               VARCHAR2(35);
   row2_               VARCHAR2(35);
   row3_               VARCHAR2(35);
   row4_               VARCHAR2(35);
   row5_               VARCHAR2(35);
   address1_           customer_info_address_tab.address1%TYPE;
   address2_           customer_info_address_tab.address2%TYPE;
   zip_code_           customer_info_address_tab.zip_code%TYPE;
   city_               customer_info_address_tab.city%TYPE;
   county_             customer_info_address_tab.county%TYPE;
   state_              customer_info_address_tab.state%TYPE;
   CURSOR get_address IS
      SELECT country, address1, address2, zip_code, city, county, state 
      FROM   customer_info_address_tab
      WHERE  customer_id = customer_id_
      AND    address_id = address_id_;
BEGIN
   OPEN get_address;
   FETCH get_address INTO country_, address1_, address2_, zip_code_, city_, county_, state_;
   CLOSE get_address;
   address_pres_ := Address_Presentation_API.Get_Address_Record(country_);
   country_ := Iso_Country_API.Decode(country_);
   FOR line_no_ IN 1 .. 5 LOOP
      row1_ := NULL;
      row2_ := NULL;
      row3_ := NULL;
      row4_ := NULL;
      row5_ := NULL;
      line_ := line_no_;
      -- Check the different address fields for the correct line number.
      -- Put the value in the right order.
      IF (address_pres_.address1_row = line_) THEN
         IF (address_pres_.address1_order = 1) THEN
            row1_ := address1_;
         ELSIF (address_pres_.address1_order = 2) THEN
            row2_ := address1_;
         ELSIF (address_pres_.address1_order = 3) THEN
            row3_ := address1_;
         ELSIF (address_pres_.address1_order = 4) THEN
            row4_ := address1_;
         ELSIF (address_pres_.address1_order = 5) THEN
            row5_ := address1_;
         ELSE
            row1_ := address1_;
         END IF;
      END IF;
      IF (address_pres_.address2_row = line_) THEN
         IF (address_pres_.address2_order = 1) THEN
            row1_ := address2_;
         ELSIF (address_pres_.address2_order = 2) THEN
            row2_ := address2_;
         ELSIF (address_pres_.address2_order = 3) THEN
            row3_ := address2_;
         ELSIF (address_pres_.address2_order = 4) THEN
            row4_ := address2_;
         ELSIF (address_pres_.address2_order = 5) THEN
            row5_ := address2_;
         ELSE
            row1_ := address2_;
         END IF;
      END IF;
      IF (address_pres_.zip_code_row = line_) THEN
         IF (address_pres_.zip_code_order = 1) THEN
            row1_ := zip_code_;
         ELSIF (address_pres_.zip_code_order = 2) THEN
            row2_ := zip_code_;
         ELSIF (address_pres_.zip_code_order = 3) THEN
            row3_ := zip_code_;
         ELSIF (address_pres_.zip_code_order = 4) THEN
            row4_ := zip_code_;
         ELSIF (address_pres_.zip_code_order = 5) THEN
            row5_ := zip_code_;
         ELSE
            row1_ := zip_code_;
         END IF;
      END IF;
      IF (address_pres_.city_row = line_) THEN
         IF (address_pres_.city_order = 1) THEN
            row1_ := city_;
         ELSIF (address_pres_.city_order = 2) THEN
            row2_ := city_;
         ELSIF (address_pres_.city_order = 3) THEN
            row3_ := city_;
         ELSIF (address_pres_.city_order = 4) THEN
            row4_ := city_;
         ELSIF (address_pres_.city_order = 5) THEN
            row5_ := city_;
         ELSE
            row1_ := city_;
         END IF;
      END IF;
      IF (address_pres_.county_row = line_) THEN
         IF (address_pres_.county_order = 1) THEN
            row1_ := county_;
         ELSIF (address_pres_.county_order = 2) THEN
            row2_ := county_;
         ELSIF (address_pres_.county_order = 3) THEN
            row3_ := county_;
         ELSIF (address_pres_.county_order = 4) THEN
            row4_ := county_;
         ELSIF (address_pres_.county_order = 5) THEN
            row5_ := county_;
         ELSE
            row1_ := county_;
         END IF;
      END IF;
      IF (address_pres_.state_row = line_) THEN
         IF (address_pres_.state_order = 1) THEN
            row1_ := state_;
         ELSIF (address_pres_.state_order = 2) THEN
            row2_ := state_;
         ELSIF (address_pres_.state_order = 3) THEN
            row3_ := state_;
         ELSIF (address_pres_.state_order = 4) THEN
            row4_ := state_;
         ELSIF (address_pres_.state_order = 5) THEN
            row5_ := state_;
         ELSE
            row1_ := state_;
         END IF;
      END IF;
      --Concatenate the different parts.
      IF (line_ = 1) THEN
         addr_one_ := RTRIM(LTRIM(row1_ || ' ' || row2_ || ' ' || row3_ || ' ' || row4_ || ' ' || row5_));
      ELSIF (line_ = 2) THEN
         addr_two_ := RTRIM(LTRIM(row1_ || ' ' || row2_ || ' ' || row3_ || ' ' || row4_ || ' ' || row5_));
      ELSIF (line_ = 3) THEN
         addr_three_ := RTRIM(LTRIM(row1_ || ' ' || row2_ || ' ' || row3_ || ' ' || row4_ || ' ' || row5_));
      ELSIF (line_ = 4) THEN
         addr_four_ := RTRIM(LTRIM(row1_ || ' ' || row2_ || ' ' || row3_ || ' ' || row4_ || ' ' || row5_));
      ELSIF (line_ = 5) THEN
         addr_five_ := RTRIM(LTRIM(row1_ || ' ' || row2_ || ' ' || row3_ || ' ' || row4_ || ' ' || row5_));
      END IF;
   END LOOP;
END Get_Address_Lines;


@UncheckedAccess
FUNCTION Exist_End_Customer (
   end_customer_id_   IN VARCHAR2,
   end_cust_addr_id_  IN VARCHAR2 ) RETURN BOOLEAN
IS   
   dummy_ NUMBER;
   CURSOR exist_end_cust IS
      SELECT 1
      FROM   customer_info_address_tab
      WHERE  end_customer_id = end_customer_id_
      AND    end_cust_addr_id = end_cust_addr_id_;
BEGIN
   OPEN exist_end_cust;
   FETCH exist_end_cust INTO dummy_;
   IF (exist_end_cust%FOUND) THEN
      CLOSE exist_end_cust;
      RETURN TRUE;
   ELSE
      CLOSE exist_end_cust;  
      RETURN FALSE;
   END IF;    
END Exist_End_Customer;


@UncheckedAccess
FUNCTION Check_Exist (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF (Check_Exist___(customer_id_, address_id_)) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Check_Exist;


-- This will be used to fetch the rowversion
-- in CCTI integration.
@UncheckedAccess
FUNCTION Get_Last_Modified (
   customer_id_   IN VARCHAR2,
   address_id_    IN VARCHAR2 ) RETURN DATE
IS
   last_modified_    DATE;
   CURSOR get_last_modified IS
      SELECT rowversion
      FROM   customer_info_address_tab
      WHERE  customer_id = customer_id_
      AND    address_id = address_id_;
BEGIN
   OPEN get_last_modified;
   FETCH get_last_modified INTO last_modified_;
   CLOSE get_last_modified;   
   RETURN last_modified_; 
END Get_Last_Modified;


-- This functions is used when pumping data for duplication check
FUNCTION Pack_Table (
   rec_  IN customer_info_address_tab%ROWTYPE ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      RETURN Pack_Table___(rec_);
   $ELSE
      RETURN NULL;
   $END
END Pack_Table;


FUNCTION Get_Object_By_Keys (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 ) RETURN customer_info_address_tab%ROWTYPE
IS
BEGIN
   RETURN Get_Object_By_Keys___(customer_id_, address_id_);
END Get_Object_By_Keys;
