-----------------------------------------------------------------------------
--
--  Logical unit: CustOrderLineAddress
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200728  MaRalk  SCXTEND-4714, Modified method Update___ in order to correctly handle info messages when append info with SHIPCONADDRINFO.
--  200622  KiSalk  Bug 153559(SCZ-9918), In Change_Address__, called Customer_Order_Line_API.Check_And_Add_To_Shipment to create/connect to shipment,
--  200622          if new address is for a new CO line created through Change Request.
--  191206  DhAplk  Bug 150459(SCZ-7282) Modified Update___() to a add new value to App_Context_SYS to give shipment connected info message.
--  191105  Vashlk  Bug 150833(FIZ-4648), In Check_Update___ passed source_ parameter to External_Tax_System_Util_API.Fetch_Jurisdiction_Code improve performance for Vertex.
--  160624  MalLlk  FINHR-1818, Modified method Check_Update___ to check the value from Iso_Country_API.Get_Sales_Tax() to fetch Jurisdiction code.
--  160620  SudJlk  STRSC-2698, Replaced Public_Rec with Co_Line_Addr_Rec and Get() with Get_Co_Line_Addr() to avoid confusion with model generated Public_Rec and Get().
--  160623  SudJlk  STRSC-2697, Replaced customer_Order_Address_API.Public_Rec with customer_Order_Address_API.Cust_Ord_Addr_Rec and 
--  160623          customer_Order_Address_API.Get() with customer_Order_Address_API.Get_Cust_Ord_Addr().
--  160519  MaIklk  STRSC-2346, Added Check_Exist_Line_Address().
--  160516  Chgulk  STRLOC-80, Added new Address fields.
--  160506  Chgulk  STRLOC-369, used the correct package.
--  160307  DipeLK  STRLOC-247,Change Validate_Address() method call to Address_validation_API.Validate_Address
--  160202  IsSalk  FINHR-647, Redirect method calls to new utility LU TaxHandlingOrderUtil.
--  151119  IsSalk  FINHR-327, Renamed attribute VAT_NO to TAX_ID_NO in Customer Order Line.
--  150220  MAHPLK  PRSC-5852, Added new implementation method Modify_Connected_Addr_Line___().
--  150213  HimRlk  Modified Update___ by adding info message to CUSTOMER_ORDER_LINE_API.CURRENT_INFO_ App_context to avoid clearing.
--  141217  PraWlk  PRSC-4668, Modified Is_Connected_Addr_Same() to return true if the supply code is PD and purchase type is PR.
--  141212  RasDlk  PRSC-4614, Overrided the Check_Common___() to check whether in_city is null.
--  141210  HimRlk  Added new method Modify_Connected_Addr_Line__() to handle address replication.
--  141204  HimRlk  Added new method Is_Connected_Addr_Same() to check whether address attributes has changed and replication is needed.
--  141121  HimRlk  Added new method Modify_Connected_Addr_Line() to replicate address information to connected orders. Called  the replication in
--  141121          Insert___ and Update___ methods.
--  141014  HimRlk  Modified Change_Address__() to trigger replicating changes to connected order lines if requested.
--  141002  AyAmlk  Bug 118970, Modified Update___() in order to prevent fetching default tax values when the country_code is changed but the Customer's
--  141002          Tax Liability is exempt or the sales part does not have a Tax Class defined.
--  140917  AyAmlk  Bug 117407, Modified Update___() to re-fetch the tax lines when the address is changed when sales tax is used or when the country code is
--  140917          changed when VAT or MIX tax is used.
--  140527  PraWlk  Modified the condition in Update___() to re-fetch the tax lines from vertex as well as when the delivery country is changed.
--  140408  ChBnlk  Bug 116100, Modified Insert___() and Update___() to stop modifying the freight information when the customer order line is delivered or invoiced.
--  140110  AyAmlk  Bug 114352, Modified the line_item_no column comments in the CUST_ORDER_LINE_ADDRESS_2 view by changing it to a Key. Modified all the get methods
--  140110          cursors where values are fetched from the CUST_ORDER_LINE_ADDRESS_TAB, so that the parent part's address details are fetched for component parts.
--  131211  RoJalk  Replaced the usage of Get_Addr_Flag with Get_Addr_Flag_Db.
--  131101  RoJalk  Modified in_city to be STRING(5) instead of BOOLEAN to align with the model.
--  130911  IsSalk  Bug 111274, Modified Update___() to set the CO line vat_no according to the delivery country.
--  130419  JeeJlk  Modified CUST_ORDER_LINE_ADDRESS_2 by adding originating_co_lang_code to show in dlgCustOrderLineAddress window.
--  130227  SALIDE  EDEL-2020, Replaced the use of company_name2 with the name from customer_info_address (ENTERP).
--  121030  MaMalk  Modified Update___ to change the condition and the message text given by constant SHIPCONADDR, when the address information is changed in shipment connected COLines.
--  121019  ChFolk  Modified Update___ to retrieve taxes when the country code is changed also.
--  120918  GiSalk  Bug 103562, Modified Change_Address__() by validating CO line supply country vs delivery country using 
--  120918          Customer_Order_Tax_Util_API.Check_Ipd_Tax_Registration, when country code of the address is changed and single occurrence address is used.
--  120125  ChJalk  Modified the view comments of addr_1, addr_2, addr_3, addr_4, addr_5 and addr_6.
--  110818  AmPalk  Bug 93557, In Unpack_Check_Update___ and Unpack_Check_Insert___ validated country, state, county and city.
--  110519  MiKulk  Changed the condition for calling the Vertex_Utility to check for the cmpany sales tax calculation method.
--  110309  Kagalk  RAVEN-1074, Removed call to Validation_Per_Company_API.Validate_Tax_Number
--  100817  ChFolk  Modified Insert___ and Update___ to update freight infomation in CO line based on the address.
--  100719  Cpeilk  Bug 90564, Added a check for country_code_ in method Change_Address__ to handle tax id validation for single occurrence address.
--  100716  ChFolk  Modified the usages of Cust_Ord_Charge_Tax_Lines_API.Set_To_Default as the parameters are changed.
--  100604   MaMalk  Replaced ApplicationCountry with IsoCountry to represent relationships in overviews correctly.
--  100520  KRPELK  Merge Rose Method Documentation.
--  090930  MaMalk  Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  080526  ChJalk  Bug 72771, Modified Method Update___ to update the charge line taxes when the tax_method is QUANTUM_SALES_USE_TAX.
--  080306  Cpeilk  Bug 71451, Modified Change_Address__ to avoid calling New__ when the record is already added.
--  070529  MaJalk  Bug 64949, Modified method Update___ to raise an information message if the address
--  070529          fields are updated when the CO Line is already connected to an open shipment.
--  070427  NuVelk  Bug 64184, Modified CUST_ORDER_LINE_ADDRESS_2 view to fetch the correct single occurrence delivery address when demand code is IPD.
--  070321  MalLlk  Bug 60882, Removed column vat_no and function Get_Vat_No from the LU.
--  070216  DAYJLK  LCS Merge 63278, Modified addr_line_ length to 1000 from 100 in Unpack_Check_Insert___ and Unpack_Check_Update___ .
--  060817  MiErlk  Modified length of view comment addr_1 for VIEW and VIEW2. Removed SUBSTR 35 from addr_1 in VIEW2
--  060517  MiErlk  Enlarge Identity - Changed view comment
--  060508  JoEd    Bug 57621. Changed Get_Vat_No to query VIEW2 instead of TABLE.
--  -------------------- 13.4.0 --------------------------------------------- 
--  060223  MiKulk  Removed the attribute vat_free_vat_code and the related logic.
--  060125  NiDalk  Added Assert safe annotation. 
--  060110  CsAmlk  Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  050408  KeFelk  Added Decode to the where condition of VIEW2.
--  041028  HoInlk  Bug 47642, Added validation for vat_free_vat_code when tax regime is sales tax, in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040827  NaWilk  Bug 40315, Added company, vat_free_vat_code to the views CUST_ORDER_LINE_ADDRESS and CUST_ORDER_LINE_ADDRESS_2. Added methods Get_Company,
--  040827          and Get_Vat_Free_Vat_Code. Modified the methods Get, Unpack_Check_Insert___,Unpack_Check_Update___, Insert___, and Update___.
--  040708  IsWilk  Replaced customer_no as deliver_to_customer_no and removed the added deliver_to_customer_no
--  040708          in the view CUST_ORDER_LINE_ADDRESS_2.
--  040616  LoPrlk  Added the field deliver_to_customer_no to CUST_ORDER_LINE_ADDRESS_2.
--  040531  ErSolk  Bug 43207, Modified procedure Unpack_Check_Update___.
--  040301  NaWilk  Bug 37557, Added the VAT_NO to the views CUST_ORDER_LINE_ADDRESS and CUST_ORDER_LINE_ADDRESS_2. Added a method get_vat_no.
--  040301          Modified the methods Unpack_Check_Insert___,Unpack_Check_Update___, Insert___, and Update___.Added the vat_no to the Get method.
--  040224  ChJalk  Bug 40249, Modified the view CUST_ORDER_LINE_ADDRESS_2 by adding a decode to the where condition to get the details of the package line
--  040224          address for the component lines and modified several methods to remove the decode from the cursor where conditions when using the modified view.
--  040219  IsWilk  Modified the SUBSTRB to SUBSTR for Unicode Changes.
--  030924  BhRalk  Changed NOCHECK as CASCADE on view comments for column line_item_no  of view CUST_ORDER_LINE_ADDRESS.
--  030924  BhRalk  Added NOCHECK on view comments for column line_item_no  of view CUST_ORDER_LINE_ADDRESS.
--  021212  Asawlk  Merged bug fixes in 2002-3 SP3
--  021126  RoAnse  Bug 34460, Modified the cursor get_addr_flag in Change_Address__ to use tab
--  021126          customer_order_line_tab instead of view customer_order_line.
--  020927  RuRalk  Bug 32361, Modified Change_Address__ by Changing the Cursor get_addr_flag to aviod poor performance.
--  020827  ShFelk  Bug 32296, Truncated the value of addr_1 in CUST_ORDER_LINE_ADDRESS_2 to 35 characters
--  020618  AjShlk  Bug 29312, Added attribute county to Update_Ord_Address_Util_API.Get_Order_Address_Line.
--  020314  PerK    Added in_city
--  020307  PerK    Added county
--  010528  JSAnse  Bug 21463, Added call to General_SYS.Init_Method in procedures Get_Address1, Get_Address2,
--                  Get_Zip_Code, Get_City and Get_State.
--  001003  MaGu    Added control value ORDER_ADDRESS_UPDATE to Unpack_Check_Update___ to
--                  prevent old address fields from being overwritten when running the order
--                  address update application.
--  000915  MaGu    Added new address columns to CUST_ORDER_LINE_ADDRESS_2. Changed
--                  to new address columns in method Prepare_Insert___. Added conversion
--                  to old address format in Unpack_Check_Insert___ and Unpack_Check_Update___.
--                  Changed get function for new address fields. Fetch from CUST_ORDER_LINE_ADDRESS_2
--                  instead of from table.
--  000913  FBen    Added UNDEFINE.
--  000907  MaGu    Added attributes address1, address2, zip_code, city and state.
--  --------------  ---------------- 12.1 -------------------------------------
--  991215  JoEd    Added public method Change_Address.
--  991105  JoEd    Added extra check to create a new single occurence address
--                  in Change_Address__.
--  991007  JoEd    Call Id 21210: Corrected double-byte problems.
--  990915  JoEd    Changed VIEW2 - used removed column.
--  9908xx  JoEd    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Co_Line_Addr_Rec IS RECORD
   (addr_1 cust_order_line_address_tab.addr_1%TYPE,
    addr_2 cust_order_line_address_tab.addr_2%TYPE,
    addr_3 cust_order_line_address_tab.addr_3%TYPE,
    addr_4 cust_order_line_address_tab.addr_4%TYPE,
    addr_5 cust_order_line_address_tab.addr_5%TYPE,
    addr_6 cust_order_line_address_tab.addr_6%TYPE,
    country_code CUST_ORDER_LINE_ADDRESS_TAB.country_code%TYPE,
    address1 CUST_ORDER_LINE_ADDRESS_TAB.address1%TYPE,
    address2 CUST_ORDER_LINE_ADDRESS_TAB.address2%TYPE,
    address3 CUST_ORDER_LINE_ADDRESS_TAB.address3%TYPE,
    address4 CUST_ORDER_LINE_ADDRESS_TAB.address4%TYPE,
    address5 CUST_ORDER_LINE_ADDRESS_TAB.address5%TYPE,
    address6 CUST_ORDER_LINE_ADDRESS_TAB.address6%TYPE,
    zip_code CUST_ORDER_LINE_ADDRESS_TAB.zip_code%TYPE,
    city CUST_ORDER_LINE_ADDRESS_TAB.city%TYPE,
    state CUST_ORDER_LINE_ADDRESS_TAB.state%TYPE,
    county CUST_ORDER_LINE_ADDRESS_TAB.county%TYPE,
    in_city CUST_ORDER_LINE_ADDRESS_TAB.in_city%TYPE,
    company CUST_ORDER_LINE_ADDRESS_TAB.company%TYPE);


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   order_no_  CUST_ORDER_LINE_ADDRESS_TAB.order_no%TYPE := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   addr_rec_  CUSTOMER_ORDER_ADDRESS_API.Cust_Ord_Addr_Rec;
BEGIN
   super(attr_);
   -- Fetch order's address and add the order_no back to the outgoing attribute string...
   addr_rec_ := Customer_Order_Address_API.Get_Cust_Ord_Addr(order_no_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('ADDR_1', addr_rec_.addr_1, attr_);
   Client_SYS.Add_To_Attr('ADDRESS1', addr_rec_.address1, attr_);
   Client_SYS.Add_To_Attr('ADDRESS2', addr_rec_.address2, attr_);
   Client_SYS.Add_To_Attr('ADDRESS3', addr_rec_.address3, attr_);
   Client_SYS.Add_To_Attr('ADDRESS4', addr_rec_.address4, attr_);
   Client_SYS.Add_To_Attr('ADDRESS5', addr_rec_.address5, attr_);
   Client_SYS.Add_To_Attr('ADDRESS6', addr_rec_.address6, attr_);
   Client_SYS.Add_To_Attr('ZIP_CODE', addr_rec_.zip_code, attr_);
   Client_SYS.Add_To_Attr('CITY', addr_rec_.city, attr_);
   Client_SYS.Add_To_Attr('STATE', addr_rec_.state, attr_);
   Client_SYS.Add_To_Attr('COUNTRY_CODE', addr_rec_.country_code, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_ORDER_LINE_ADDRESS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   freight_map_id_  VARCHAR2(15);
   zone_id_         VARCHAR2(15);
   zone_info_exist_ VARCHAR2(5);
   ordrow_rec_      Customer_Order_Line_API.Public_Rec;
   replicate_changes_ VARCHAR2(5);
   change_request_    VARCHAR2(5);   
   co_status_         CUSTOMER_ORDER_TAB.rowstate%TYPE;
BEGIN   
   super(objid_, objversion_, newrec_, attr_);
   IF (Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no ) != 'Invoiced') THEN
      ordrow_rec_ := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(freight_map_id_,
                                                        zone_id_,
                                                        zone_info_exist_,
                                                        ordrow_rec_.contract,
                                                        ordrow_rec_.ship_via_code,
                                                        newrec_.zip_code,
                                                        newrec_.city,
                                                        newrec_.county,
                                                        newrec_.state,
                                                        newrec_.country_code);

      Customer_Order_Line_API.Modify_Freight_Info(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, freight_map_id_, zone_id_); 
      
      replicate_changes_ := Client_SYS.Get_Item_Value('REPLICATE_CHANGES', attr_);
      change_request_    := Client_SYS.Get_Item_Value('CHANGE_REQUEST', attr_);  
      co_status_ := CUSTOMER_ORDER_API.Get_Objstate(newrec_.order_no);
      
      Customer_Order_Line_API.Modify_Country_Code(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, newrec_.country_code);

      IF (replicate_changes_ = 'TRUE') THEN
         Modify_Connected_Addr_Line__ (newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, 
                                       replicate_changes_, change_request_, co_status_, ordrow_rec_.supply_code); 
      END IF;
   END IF; 
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUST_ORDER_LINE_ADDRESS_TAB%ROWTYPE,
   newrec_     IN OUT CUST_ORDER_LINE_ADDRESS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   ordrow_rec_            Customer_Order_Line_API.Public_Rec;
   company_               VARCHAR2(20);
   freight_map_id_        VARCHAR2(15);
   zone_id_               VARCHAR2(15);
   zone_info_exist_       VARCHAR2(5);   
   vat_no_                VARCHAR2(50);
   custord_row_           Customer_Order_API.Public_Rec;
   tax_method_            VARCHAR2(50);
   replicate_changes_     VARCHAR2(5);
   change_request_        VARCHAR2(5);   
   co_status_             CUSTOMER_ORDER_TAB.rowstate%TYPE;
   current_info_          VARCHAR2(32000);
   country_code_          VARCHAR2(2);
   tax_calc_structure_id_ VARCHAR2(20);
   
   CURSOR get_connected_charge_lines IS
      SELECT sequence_no
        FROM customer_order_charge_tab
       WHERE order_no     = newrec_.order_no
         AND line_no      = newrec_.line_no
         AND rel_no       = newrec_.rel_no
         AND line_item_no = newrec_.line_item_no;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   ordrow_rec_         := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   company_            := Site_API.Get_Company(ordrow_rec_.contract);
   tax_method_         := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);
      
   -- If tax lines are retrived from Vertex a new retrival should be done if
   -- city, state, zip_code, county or in_city has been changed
   IF ((((NVL(newrec_.city,        ' ') != NVL(oldrec_.city,         ' ')) OR
         (NVL(newrec_.state,       ' ') != NVL(oldrec_.state,        ' ')) OR
         (NVL(newrec_.zip_code,    ' ') != NVL(oldrec_.zip_code,     ' ')) OR
         (NVL(newrec_.county,      ' ') != NVL(oldrec_.county,       ' ')) OR
         (NVL(newrec_.in_city,     ' ') != NVL(oldrec_.in_city,      ' '))) AND 
         (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED)) OR
       ((NVL(newrec_.country_code, ' ') != NVL(oldrec_.country_code, ' '))  AND 
        (Customer_Order_Line_API.Get_Tax_Liability_Type_Db(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) != 'EXM') AND (Sales_Part_API.Get_Tax_Class_Id(ordrow_rec_.contract, ordrow_rec_.catalog_no) IS NOT NULL) )) THEN

      Tax_Handling_Order_Util_API.Set_To_Default(tax_calc_structure_id_,
                                                 company_,
                                                 Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                 newrec_.order_no, 
                                                 newrec_.line_no, 
                                                 newrec_.rel_no, 
                                                 newrec_.line_item_no,
                                                 '*');
      
      FOR rec_ IN get_connected_charge_lines LOOP
         Tax_Handling_Order_Util_API.Set_To_Default(tax_calc_structure_id_, company_, Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, newrec_.order_no, rec_.sequence_no, '*', '*', '*');
      END LOOP;
   END IF;
   
   IF (Validate_SYS.Is_Different(NVL(newrec_.city,' '),         NVL(oldrec_.city, ' ')) OR
       Validate_SYS.Is_Different(NVL(newrec_.state,' '),        NVL(oldrec_.state, ' ')) OR
       Validate_SYS.Is_Different(NVL(newrec_.zip_code,' '),     NVL(oldrec_.zip_code, ' ')) OR
       Validate_SYS.Is_Different(NVL(newrec_.county,' '),       NVL(oldrec_.county, ' ')) OR
       Validate_SYS.Is_Different(NVL(newrec_.country_code,' '), NVL(oldrec_.country_code, ' ')) OR 
       Validate_SYS.Is_Different(NVL(newrec_.address1,' '),     NVL(oldrec_.address1, ' ')) OR
       Validate_SYS.Is_Different(NVL(newrec_.address2,' '),     NVL(oldrec_.address2, ' ')) OR
       Validate_SYS.Is_Different(NVL(newrec_.address3,' '),     NVL(oldrec_.address3, ' ')) OR
       Validate_SYS.Is_Different(NVL(newrec_.address4,' '),     NVL(oldrec_.address4, ' ')) OR
       Validate_SYS.Is_Different(NVL(newrec_.address5,' '),     NVL(oldrec_.address5, ' ')) OR
       Validate_SYS.Is_Different(NVL(newrec_.address6,' '),     NVL(oldrec_.address6, ' ')) OR
       Validate_SYS.Is_Different(NVL(newrec_.addr_1,' '),       NVL(oldrec_.addr_1, ' '))) THEN

      IF (Customer_Order_Line_API.Get_Shipment_Connected_Db(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no)= 'TRUE') THEN
         Client_SYS.Add_Info(lu_name_, 'SHIPCONADDRINFO: Line no, rel no, order :P1  is connected to shipment(s). Note that delivery address must be changed manually for these shipment(s).', (newrec_.line_no ||' '||newrec_.rel_no ||' '|| newrec_.order_no));       
         current_info_ := App_Context_SYS.Find_Value('CUSTOMER_ORDER_LINE_API.CURRENT_INFO_');
         IF (current_info_ IS NOT NULL) THEN
            Client_SYS.Add_Info(lu_name_, current_info_); 
         END IF;   
         current_info_ := Client_SYS.Get_All_Info;
         App_Context_SYS.Set_Value('CUSTOMER_ORDER_LINE_API.CURRENT_INFO_', current_info_);
         App_Context_SYS.Set_Value('CUSTOMER_ORDER_LINE_API.SHPMNT_INFO_', 'SHIPCONNECTINFO: There are internal orders connected to shipment(s), which you may find using the Supply Chain Orders Analysis. Note that the delivery address must be changed manually for these shipment(s).');
         END IF;
      END IF;

   IF ((NVL(newrec_.city, ' ') != NVL(oldrec_.city, ' ')) OR
       (NVL(newrec_.state, ' ') != NVL(oldrec_.state, ' ')) OR
       (NVL(newrec_.zip_code, ' ') != NVL(oldrec_.zip_code, ' ')) OR
       (NVL(newrec_.county, ' ') != NVL(oldrec_.county, ' ')) OR
       (NVL(newrec_.country_code, ' ') != NVL(oldrec_.country_code, ' '))) THEN
      IF (Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no ) != 'Invoiced') THEN
         Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(freight_map_id_,
                                                           zone_id_,
                                                           zone_info_exist_,
                                                           ordrow_rec_.contract,
                                                           ordrow_rec_.ship_via_code,
                                                           newrec_.zip_code,
                                                           newrec_.city,
                                                           newrec_.county,
                                                           newrec_.state,
                                                           newrec_.country_code);
         Customer_Order_Line_API.Modify_Freight_Info(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, freight_map_id_, zone_id_);
      END IF;
   END IF;
      
   IF (NVL(newrec_.country_code, ' ') != NVL(oldrec_.country_code, ' ')) THEN
      custord_row_ := Customer_Order_API.Get(newrec_.order_no);
      vat_no_ := Customer_Document_Tax_Info_API.Get_Vat_No_Db(ordrow_rec_.customer_no ,
                                                              custord_row_.bill_addr_no,
                                                              Site_API.Get_Company(ordrow_rec_.contract),
                                                              custord_row_.supply_country, 
                                                              newrec_.country_code);
      Customer_Order_Line_API.Modify_Tax_Id_No_Details__(newrec_.order_no,
                                                         newrec_.line_no,
                                                         newrec_.rel_no,
                                                         newrec_.line_item_no,
                                                         vat_no_,
                                                         Tax_Handling_Order_Util_API.Get_Tax_Id_Validated_Date(custord_row_.customer_no_pay,
                                                                                                               custord_row_.customer_no_pay_addr_no, 
                                                                                                               ordrow_rec_.customer_no,
                                                                                                               custord_row_.bill_addr_no,
                                                                                                               Site_API.Get_Company(ordrow_rec_.contract), 
                                                                                                               custord_row_.supply_country,
                                                                                                               newrec_.country_code ));
      IF (newrec_.country_code IS NULL) THEN
         country_code_:= Customer_Order_Address_API.Get_Country_Code(newrec_.order_no);
      ELSE
         country_code_ := newrec_.country_code;
      END IF;
      Customer_Order_Line_API.Modify_Country_Code(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, country_code_);
   END IF;

   replicate_changes_ := Client_SYS.Get_Item_Value('REPLICATE_CHANGES', attr_);
   change_request_    := Client_SYS.Get_Item_Value('CHANGE_REQUEST', attr_);  
   co_status_ := CUSTOMER_ORDER_API.Get_Objstate(newrec_.order_no);
   IF (replicate_changes_ = 'TRUE') THEN
      Modify_Connected_Addr_Line__ (newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, 
                                    replicate_changes_, change_request_, co_status_, ordrow_rec_.supply_code); 
   END IF;
      
END Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     cust_order_line_address_tab%ROWTYPE,
   newrec_ IN OUT cust_order_line_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.in_city IS NULL) THEN
      newrec_.in_city := 'FALSE';
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;



@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_order_line_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   addr_line_ VARCHAR2(1000);   
BEGIN
   IF (nvl(newrec_.line_item_no, 0) > 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_ITEM_NO: Address may not be added on component level!');
   END IF;

   super(newrec_, indrec_, attr_);

   Address_Setup_API.Validate_Address(newrec_.country_code, newrec_.state, newrec_.county, newrec_.city);
   
   --Convert the new address to the old format and save as addr_2 to addr_6.
   FOR i in 1..5 LOOP
     addr_line_ := Update_Ord_Address_Util_API.Get_Order_Address_Line(newrec_.address1, newrec_.address2,newrec_.address3,newrec_.address4,newrec_.address5,newrec_.address6, newrec_.zip_code,
                                                       newrec_.city, newrec_.state, newrec_.county, newrec_.country_code, i);
     IF (i = 1) THEN
        newrec_.addr_2 := SUBSTR(addr_line_, 1, 35);
     ELSIF (i = 2) THEN
        newrec_.addr_3 := SUBSTR(addr_line_, 1, 35);
     ELSIF (i = 3) THEN
        newrec_.addr_4 := SUBSTR(addr_line_, 1, 35);
     ELSIF (i = 4) THEN
        newrec_.addr_5 := SUBSTR(addr_line_, 1, 35);
     ELSIF (i = 5) THEN
        newrec_.addr_6 := SUBSTR(addr_line_, 1, 35);
     END IF;
   END LOOP;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_order_line_address_tab%ROWTYPE,
   newrec_ IN OUT cust_order_line_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   addr_line_                VARCHAR2(1000);   
   city_                     VARCHAR2(35);
   state_                    VARCHAR2(35);
   zip_code_                 VARCHAR2(35);
   county_                   VARCHAR2(35);
   external_tax_calc_method_ VARCHAR2(50);
   postal_addresses_   External_Tax_System_Util_API.postal_address_arr;
   postal_address_     External_Tax_System_Util_API.postal_address_rec;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   Address_Setup_API.Validate_Address(newrec_.country_code, newrec_.state, newrec_.county, newrec_.city);
   
   IF (NOT Client_SYS.Item_Exist('ORDER_ADDRESS_UPDATE', attr_)) THEN
   --Convert the new address to the old format and save as addr_2 to addr_6.
      FOR i in 1..5 LOOP
       addr_line_ := Update_Ord_Address_Util_API.Get_Order_Address_Line(newrec_.address1, newrec_.address2,newrec_.address3,newrec_.address4,newrec_.address5,newrec_.address6, newrec_.zip_code,
                                                       newrec_.city, newrec_.state, newrec_.county, newrec_.country_code, i);
       IF (i = 1) THEN
          newrec_.addr_2 := SUBSTR(addr_line_, 1, 35);
       ELSIF (i = 2) THEN
          newrec_.addr_3 := SUBSTR(addr_line_, 1, 35);
       ELSIF (i = 3) THEN
          newrec_.addr_4 := SUBSTR(addr_line_, 1, 35);
       ELSIF (i = 4) THEN
          newrec_.addr_5 := SUBSTR(addr_line_, 1, 35);
       ELSIF (i = 5) THEN
          newrec_.addr_6 := SUBSTR(addr_line_, 1, 35);
       END IF;
     END LOOP;
   END IF;

   external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);      
   IF (external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
      IF (Iso_Country_API.Get_Fetch_Jurisdiction_Code_Db(newrec_.country_code) = 'TRUE') THEN
         IF (newrec_.city IS NULL) THEN
            city_ := 'X';
         ELSE
            city_ := newrec_.city;
         END IF;
         IF (newrec_.state IS NULL) THEN
            state_ := 'X';
         ELSE
            state_ := newrec_.state;
         END IF;
         IF (newrec_.zip_code IS NULL) THEN
            zip_code_ := '0';
         ELSE
            zip_code_ := newrec_.zip_code;
         END IF;
         IF (newrec_.county IS NULL) THEN
            county_ := 'X';
         ELSE
            county_ := newrec_.county;
         END IF;
         
         postal_addresses_.DELETE;      
         postal_address_          := NULL;
         postal_address_.address_id := newrec_.addr_1;
         postal_address_.address1 := newrec_.address1;
         postal_address_.address2 := newrec_.address2;
         postal_address_.zip_code := zip_code_;
         postal_address_.city     := city_;
         postal_address_.state    := state_;
         postal_address_.county   := county_;
         postal_address_.country  := newrec_.country_code;
         postal_addresses_(0)     := postal_address_; 

         External_Tax_System_Util_API.Handle_Address_Information(postal_addresses_, newrec_.company, 'COMPANY_CUSTOMER'); 
      END IF;
   END IF;
END Check_Update___;

PROCEDURE Modify_Connected_Addr_Line___ (
   order_no_          IN  VARCHAR2,
   line_no_           IN  VARCHAR2,
   rel_no_            IN  VARCHAR2,
   line_item_no_      IN  NUMBER,
   replicate_changes_ IN  VARCHAR2,
   change_request_    IN  VARCHAR2,
   co_status_         IN  VARCHAR2,
   supply_code_       IN  VARCHAR2 )
   
IS
   attr_          VARCHAR2(32000);
   qty_on_order_  NUMBER;
   newrec_addr_   CUST_ORDER_LINE_ADDRESS_API.Co_Line_Addr_Rec;
   col_rec_       Customer_Order_Line_API.Public_Rec;
BEGIN
   IF (NOT Is_Connected_Addr_Same(order_no_, line_no_, rel_no_, line_item_no_, co_status_, supply_code_)) THEN

      newrec_addr_ := Cust_Order_Line_Address_API.Get_Co_Line_Addr(order_no_, line_no_, rel_no_, line_item_no_);
      col_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
      
      Client_SYS.Add_To_Attr('ADDR_NAME',          newrec_addr_.addr_1,       attr_);
      Client_SYS.Add_To_Attr('ADDRESS1',           newrec_addr_.address1,     attr_);
      Client_SYS.Add_To_Attr('ADDRESS2',           newrec_addr_.address2,     attr_);
      Client_SYS.Add_To_Attr('ADDRESS3',           newrec_addr_.address3,     attr_);
      Client_SYS.Add_To_Attr('ADDRESS4',           newrec_addr_.address4,     attr_);
      Client_SYS.Add_To_Attr('ADDRESS5',           newrec_addr_.address5,     attr_);
      Client_SYS.Add_To_Attr('ADDRESS6',           newrec_addr_.address6,     attr_);
      Client_SYS.Add_To_Attr('ADDR_STATE',         newrec_addr_.state,        attr_);
      Client_SYS.Add_To_Attr('CITY',               newrec_addr_.city,         attr_);
      Client_SYS.Add_To_Attr('COUNTY',             newrec_addr_.county,       attr_);
      Client_SYS.Add_To_Attr('ZIP_CODE',           newrec_addr_.zip_code,     attr_);
      Client_SYS.Add_To_Attr('COUNTRY_CODE',       newrec_addr_.country_code, attr_);
      Client_SYS.Add_To_Attr('CHANGE_REQUEST',     change_request_,           attr_);
      Client_SYS.Add_To_Attr('REPLICATE_CHANGES',  replicate_changes_,        attr_);                         
      Client_SYS.Add_To_Attr('SUPPLY_CODE',        supply_code_,              attr_);
      Client_SYS.Add_To_Attr('CO_HEADER_STATUS',   co_status_,                attr_);
      Client_SYS.Add_To_Attr('ORIGINATING_FROM',   'ADDRESS',                 attr_);
      Client_SYS.Add_To_Attr('CHANGED_ATTRIB_NOT_IN_POL', 'FALSE',            attr_);
      Client_SYS.Add_To_Attr('ADDR_FLAG_DB',       col_rec_.addr_flag,              attr_);
      Client_SYS.Add_To_Attr('SHIP_ADDR_NO',       col_rec_.ship_addr_no,           attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_NO',        col_rec_.deliver_to_customer_no, attr_);
      Client_SYS.Add_To_Attr('DEFAULT_ADDR_FLAG',  col_rec_.default_addr_flag,      attr_);

      Connect_Customer_Order_API.Modify_Connected_Order_Line(qty_on_order_,
                                                             attr_,
                                                             order_no_,
                                                             line_no_,
                                                             rel_no_,
                                                             line_item_no_);
   END IF;
END Modify_Connected_Addr_Line___;


----@Override
--PROCEDURE Delete___ (
--   objid_  IN VARCHAR2,
--   remrec_ IN cust_order_line_address_tab%ROWTYPE )
--IS
--   delivery_country_db_   VARCHAR2(2);
--BEGIN
--   super(objid_, remrec_);
--   
--   IF (Customer_Order_Line_API.Check_Exist(remrec_.order_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no)) THEN
--      delivery_country_db_ := Get_Country_Code(remrec_.order_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no);
--      Customer_Order_Line_API.Modify_Country_Code(remrec_.order_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no, delivery_country_db_);
--   END IF;
--END Delete___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Change_Address__
--   Called from the Customer Order Line Address dialog to handle
--   single occurance address modifications.
PROCEDURE Change_Address__ (
   info_       OUT    VARCHAR2,
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   new_          BOOLEAN := (objid_ IS NULL);
   oldrec_       CUST_ORDER_LINE_ADDRESS_TAB%ROWTYPE;
   addr_flag_    CUST_ORDER_LINE_ADDRESS_2.addr_flag_db%TYPE;
   ptr_          NUMBER;
   name_         VARCHAR2(30);
   value_        VARCHAR2(2000);
   new_attr_     VARCHAR2(2000) := NULL;
   order_no_     CUST_ORDER_LINE_ADDRESS_TAB.order_no%TYPE;
   line_no_      CUST_ORDER_LINE_ADDRESS_TAB.line_no%TYPE;
   rel_no_       CUST_ORDER_LINE_ADDRESS_TAB.rel_no%TYPE;
   line_item_no_ CUST_ORDER_LINE_ADDRESS_TAB.line_item_no%TYPE;
   
   CURSOR get_addr_flag IS
      SELECT addr_flag
      FROM CUST_ORDER_LINE_ADDRESS cla, customer_order_line_tab col
      WHERE (cla.order_no = col.order_no
      AND cla.line_no = col.line_no
      AND cla.rel_no = col.rel_no
      AND cla.line_item_no = col.line_item_no)
      AND cla.objid = objid_;
      
   old_addr_flag_         CUST_ORDER_LINE_ADDRESS_2.addr_flag_db%TYPE;
   oldcountry_            CUST_ORDER_LINE_ADDRESS_TAB.country_code%TYPE;
   supply_country_        VARCHAR2(2); 
   company_               VARCHAR2(20);
   country_desc_          VARCHAR2(740);
   delivery_country_code_ VARCHAR2(2);
   order_line_rec_        Customer_Order_Line_API.Public_Rec;  
   method_info_           VARCHAR2(2000);
   replicate_changes_     VARCHAR2(5);
   change_request_        VARCHAR2(5);
   temp_action_           VARCHAR2(10) := 'DO';
BEGIN
   Trace_SYS.Field('attr_', attr_);
   order_no_     := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   line_no_      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   rel_no_       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   line_item_no_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   
   replicate_changes_ := Client_SYS.Get_Item_Value('REPLICATE_CHANGES', attr_);
   change_request_    := Client_SYS.Get_Item_Value('CHANGE_REQUEST', attr_);            
      
   IF NOT new_ THEN
      IF Check_Exist___(order_no_, line_no_, rel_no_, line_item_no_) THEN
         Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_);
      ELSE
         objid_ := NULL;
         objversion_ := NULL;
      END IF;
      IF (objid_ IS NOT NULL) THEN
         oldrec_ := Get_Object_By_Id___(objid_);
      END IF;
   END IF;

   Trace_SYS.Field('objid_', objid_);
   Trace_SYS.Field('objversion_', objversion_);

   IF Customer_Order_Line_API.Get_Configuration_Id(order_no_, line_no_, rel_no_, line_item_no_) != '*' THEN
      IF Customer_Order_Line_API.Get_Addr_Flag_Db(order_no_, line_no_, rel_no_, line_item_no_) = 'Y' THEN
         oldcountry_ := oldrec_.country_code;
      ELSE
         oldcountry_ := Cust_Ord_Customer_Address_API.Get_Country_Code(Customer_Order_Line_API.Get_Customer_No(order_no_, line_no_, rel_no_, line_item_no_), Customer_Order_Line_API.Get_Ship_Addr_No(order_no_, line_no_, rel_no_, line_item_no_));
      END IF;   
    
      IF Nvl(Client_SYS.Get_Item_Value('COUNTRY_CODE', attr_), '*') != Nvl(oldcountry_, '*') THEN
         Client_SYS.Add_Info(lu_name_,
          'CONFIGSUPPSITE: Delivery country change may affect configuration. Edit configuration to verify characteristics.');
      END IF;
   END IF;

   addr_flag_ := Client_SYS.Get_Item_Value('ADDR_FLAG_DB', attr_);
   IF (addr_flag_ IS NULL) THEN
      addr_flag_ := Gen_Yes_No_API.Encode(Client_SYS.Get_Item_Value('ADDR_FLAG', attr_));
   END IF;
   
   order_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   IF (addr_flag_ = 'Y') THEN
      delivery_country_code_ := Nvl(Client_SYS.Get_Item_Value('COUNTRY_CODE', attr_), '*');
      IF delivery_country_code_ != Nvl(oldrec_.country_code, '*') THEN      
         supply_country_ := Customer_Order_API.Get_Supply_Country_Db(order_no_);         
         company_        := Site_API.Get_Company(order_line_rec_.contract);
         IF Tax_Handling_Order_Util_API.Check_Ipd_Tax_Registration (company_, order_line_rec_.contract, order_line_rec_.supply_code, supply_country_, delivery_country_code_) THEN
            country_desc_ := Iso_Country_API.Get_Description(delivery_country_code_, NULL);
            Client_SYS.Add_Info(lu_name_, 'SUPCOUNTRYDIFF: Company :P1 has a tax registration in delivery country :P2. The company tax ID number for the supply country of the order might not be appropriate.', company_, country_desc_);                                                                 
         END IF; 
      END IF;
   END IF;
   method_info_ := Client_SYS.Get_All_Info;
   
   IF (nvl(addr_flag_, 'N') = 'Y') THEN
      OPEN get_addr_flag;
      FETCH get_addr_flag INTO old_addr_flag_;
      CLOSE get_addr_flag;
      IF (new_) THEN
         IF (old_addr_flag_ = 'N') THEN
            Trace_SYS.Message('Addr Yes - New record!');
            objid_ := NULL;
            objversion_ := NULL;
            New__(info_, objid_, objversion_, attr_, action_);
         END IF;
      ELSE
         Trace_SYS.Message('Modify existing record!');
         -- remove key attributes to avoid update error message
         ptr_ := NULL;
         WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
            IF (name_ NOT IN ('ORDER_NO', 'LINE_NO', 'REL_NO', 'LINE_ITEM_NO')) THEN
               Trace_SYS.Field('Repacking ''' || name_ || '''', value_);
               Client_SYS.Add_To_Attr(name_, value_, new_attr_);
            END IF;
         END LOOP;
         Modify__(info_, objid_, objversion_, new_attr_, action_);
         attr_ := new_attr_;
      END IF;
      IF (NVL(change_request_, 'FALSE') = 'TRUE') THEN
         -- When creating new CO line through Change Request, the shipment connection was delayed if single occurrance line address to be created.
         -- Therefore, call this method after the address record created.
         Customer_Order_Line_API.Check_And_Add_To_Shipment(order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   -- if there's something to remove
   ELSIF (oldrec_.order_no IS NOT NULL) THEN
      Trace_SYS.Message('Addr No - Remove record!');
      Remove__(info_, objid_, objversion_, action_);
      objid_ := NULL;
      objversion_ := NULL;
   ELSE
      Trace_SYS.Message('Non existing record - do nothing!');
      temp_action_ := 'DONOTHING';
      attr_ := NULL;
   END IF;
   
   info_ := method_info_ || info_ || App_Context_SYS.Find_Value('CUSTOMER_ORDER_LINE_API.CURRENT_INFO_');
   Customer_Order_Flow_API.Modify_License_Address(order_no_, line_no_, rel_no_, line_item_no_);   
   
END Change_Address__;


-- Remove_Address__
--   Removes an order line address if it exists. Called from
PROCEDURE Remove_Address__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   remrec_      CUST_ORDER_LINE_ADDRESS_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_);
   IF (objid_ IS NOT NULL) THEN
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
END Remove_Address__;


PROCEDURE Modify_Connected_Addr_Line__ (
   order_no_          IN  VARCHAR2,
   line_no_           IN  VARCHAR2,
   rel_no_            IN  VARCHAR2,
   line_item_no_      IN  NUMBER,
   replicate_changes_ IN  VARCHAR2,
   change_request_    IN  VARCHAR2,
   co_status_         IN  VARCHAR2,
   supply_code_       IN  VARCHAR2 )
   
IS
   
   CURSOR get_component_lines IS
      SELECT line_item_no, supply_code
      FROM   customer_order_line_tab 
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      AND    rowstate NOT IN ('Invoiced', 'Cancelled');
      
BEGIN
   
   IF (line_item_no_ <= 0) AND (supply_code_ = 'PKG') THEN
      FOR linerec_ IN get_component_lines LOOP
         Modify_Connected_Addr_Line___ (order_no_, line_no_, rel_no_, linerec_.line_item_no, replicate_changes_,
                                       change_request_, co_status_, linerec_.supply_code);
      END LOOP;
   ELSE   
      Modify_Connected_Addr_Line___ (order_no_, line_no_, rel_no_, line_item_no_, replicate_changes_,
                                    change_request_, co_status_, supply_code_);
   END IF;   
END Modify_Connected_Addr_Line__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Addr_1 (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.addr_1%TYPE;

   CURSOR get_attr IS
      SELECT addr_1
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Addr_1;


@UncheckedAccess
FUNCTION Get_Addr_2 (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.addr_2%TYPE;
   
   CURSOR get_attr IS
      SELECT addr_2
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Addr_2;


@UncheckedAccess
FUNCTION Get_Addr_3 (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.addr_3%TYPE;
   
   CURSOR get_attr IS
      SELECT addr_3
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Addr_3;


@UncheckedAccess
FUNCTION Get_Addr_4 (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.addr_4%TYPE;
   
   CURSOR get_attr IS
      SELECT addr_4
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Addr_4;


@UncheckedAccess
FUNCTION Get_Addr_5 (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.addr_5%TYPE;
   
   CURSOR get_attr IS
      SELECT addr_5
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Addr_5;


@UncheckedAccess
FUNCTION Get_Addr_6 (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.addr_6%TYPE;
   
   CURSOR get_attr IS
      SELECT addr_6
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Addr_6;

@UncheckedAccess
FUNCTION Get_Address1 (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.address1%TYPE;
   
   CURSOR get_attr IS
      SELECT address1
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address1;

@UncheckedAccess
FUNCTION Get_Address2 (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.address2%TYPE;
   
   CURSOR get_attr IS
      SELECT address2
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address2;

@UncheckedAccess
FUNCTION Get_Address3 (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.address3%TYPE;
   
   CURSOR get_attr IS
      SELECT address3
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address3;

@UncheckedAccess
FUNCTION Get_Address4 (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.address4%TYPE;
   
   CURSOR get_attr IS
      SELECT address4
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address4;

@UncheckedAccess
FUNCTION Get_Address5 (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.address5%TYPE;
   
   CURSOR get_attr IS
      SELECT address5
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address5;

@UncheckedAccess
FUNCTION Get_Address6 (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.address6%TYPE;
   
   CURSOR get_attr IS
      SELECT address6
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address6;

@UncheckedAccess
FUNCTION Get_Zip_Code (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.zip_code%TYPE;
   
   CURSOR get_attr IS
      SELECT zip_code
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Zip_Code;

@UncheckedAccess
FUNCTION Get_City (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.city%TYPE;
   
   CURSOR get_attr IS
      SELECT city
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_City;

@UncheckedAccess
FUNCTION Get_State (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.state%TYPE;
   
   CURSOR get_attr IS
      SELECT state
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_State;

@UncheckedAccess
FUNCTION Get_County (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.county%TYPE;
   
   CURSOR get_attr IS
      SELECT county
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_County;


FUNCTION Get_In_City (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.in_city%TYPE;
   
   CURSOR get_attr IS
      SELECT in_city
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_; 
END Get_In_City;


@UncheckedAccess
FUNCTION Get_Country_Code (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.country_code%TYPE;
   
   CURSOR get_attr IS
      SELECT country_code
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Country_Code;


@UncheckedAccess
FUNCTION Get_Company (
   order_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUST_ORDER_LINE_ADDRESS_2.company%TYPE;
   
   CURSOR get_attr IS
      SELECT company
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Company;


-- Change_Address
--   Public interface to change order line address.
PROCEDURE Change_Address (
   attr_         IN OUT VARCHAR2,
   order_no_     IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   rel_no_       IN     VARCHAR2,
   line_item_no_ IN     NUMBER )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(2000);
BEGIN
   -- Add mandatory values to the attribute string
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   -- Do like in the client dialog - existing record is being updated...
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_);
   Change_Address__(info_, objid_, objversion_, attr_, 'DO');
END Change_Address;

-- Is_Connected_Addr_Same
-- Public function to check whether address information is same between the customer order line
--    and the connected purchase order lin
FUNCTION Is_Connected_Addr_Same (
   order_no_     IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   rel_no_       IN     VARCHAR2,
   line_item_no_ IN     NUMBER,
   co_status_    IN     VARCHAR2,
   supply_code_  IN     VARCHAR2 ) RETURN BOOLEAN
IS
   pegged_order_no_ VARCHAR2(12);
   pegged_line_no_  VARCHAR2(4);
   pegged_rel_no_   VARCHAR2(4);
   purchase_type_   VARCHAR2(50) := 'O';
   newrec_addr_     CUST_ORDER_LINE_ADDRESS_API.Co_Line_Addr_Rec;
   col_rec_         Customer_Order_Line_API.Public_Rec;
   col_ean_locatn_  VARCHAR2(100) := NULL;
   pol_ean_locatn_  VARCHAR2(100) := NULL;
BEGIN
   IF(co_status_ != 'Planned') AND (supply_code_ IN ('PD', 'IPD')) THEN
      Customer_Order_Pur_Order_API.Get_Purord_For_Custord(pegged_order_no_, pegged_line_no_, pegged_rel_no_, purchase_type_,
                                                       order_no_, line_no_, rel_no_, line_item_no_);
      IF (supply_code_ = 'PD')THEN
         IF (Purchase_Type_API.Encode(purchase_type_) = 'R') THEN
            RETURN TRUE;
         END IF;   
      END IF;
      $IF Component_Purch_SYS.INSTALLED $THEN
         DECLARE
            pur_order_line_addr_ Pur_Order_Line_Address_API.Public_Rec;
         BEGIN
            pur_order_line_addr_ := Pur_Order_Line_Address_API.Get(pegged_order_no_, '*', pegged_line_no_, pegged_rel_no_);
            newrec_addr_ := Cust_Order_Line_Address_API.Get_Co_Line_Addr(order_no_, line_no_, rel_no_, line_item_no_);
            
            IF (supply_code_ = 'IPD') THEN
               col_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
               IF (col_rec_.addr_flag = 'N') THEN  
                  IF (col_rec_.ship_addr_no IS NOT NULL) THEN
                     col_ean_locatn_ := Customer_Info_Address_API.Get_Ean_Location(col_rec_.deliver_to_customer_no, col_rec_.ship_addr_no);
                     pol_ean_locatn_ := Purchase_Order_Line_Part_API.Get_Ean_Location_Del_Addr(pegged_order_no_, pegged_line_no_, pegged_rel_no_);
                  END IF;
               END IF;
            END IF;
            IF (NVL(pur_order_line_addr_.addr_name, Database_SYS.string_null_) != NVL(newrec_addr_.addr_1, Database_SYS.string_null_)) OR (NVL(pur_order_line_addr_.address1, Database_SYS.string_null_) != NVL(newrec_addr_.address1, Database_SYS.string_null_)) OR 
               (NVL(pur_order_line_addr_.address2, Database_SYS.string_null_) != NVL(newrec_addr_.address2, Database_SYS.string_null_))  OR  (NVL(pur_order_line_addr_.address3, Database_SYS.string_null_) != NVL(newrec_addr_.address3, Database_SYS.string_null_)) OR 
               (NVL(pur_order_line_addr_.address4, Database_SYS.string_null_) != NVL(newrec_addr_.address4, Database_SYS.string_null_)) OR (NVL(pur_order_line_addr_.address5, Database_SYS.string_null_) != NVL(newrec_addr_.address5, Database_SYS.string_null_)) OR 
               (NVL(pur_order_line_addr_.address6, Database_SYS.string_null_) != NVL(newrec_addr_.address6, Database_SYS.string_null_)) OR (NVL(pur_order_line_addr_.zip_code, Database_SYS.string_null_) != NVL(newrec_addr_.zip_code, Database_SYS.string_null_)) OR 
               (NVL(pur_order_line_addr_.city, Database_SYS.string_null_) != NVL(newrec_addr_.city, Database_SYS.string_null_)) OR (NVL(pur_order_line_addr_.addr_state, Database_SYS.string_null_) != NVL(newrec_addr_.state, Database_SYS.string_null_)) OR
               (NVL(pur_order_line_addr_.county, Database_SYS.string_null_) != NVL(newrec_addr_.county, Database_SYS.string_null_)) OR (NVL(pur_order_line_addr_.country_code, Database_SYS.string_null_) != NVL(newrec_addr_.country_code, Database_SYS.string_null_)) OR
               (NVL(col_ean_locatn_, Database_SYS.string_null_) != NVL(pol_ean_locatn_, Database_SYS.string_null_))THEN
               RETURN FALSE;
            END IF;
         END;
      $END
      RETURN TRUE;
   END IF;
   RETURN TRUE;
END Is_Connected_Addr_Same;




@UncheckedAccess
FUNCTION Get_Co_Line_Addr (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN Co_Line_Addr_Rec 
IS
   temp_ Co_Line_Addr_Rec;
   
   CURSOR get_attr IS
      SELECT addr_1, addr_2, addr_3, addr_4, addr_5, addr_6, country_code, address1, address2,address3,address4,address5,address6, zip_code, city, state, county, in_city, company 
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Co_Line_Addr;


@UncheckedAccess
FUNCTION Check_Exist_Line_Address (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_   NUMBER;
   
   CURSOR get_rec IS
      SELECT 1
      FROM CUST_ORDER_LINE_ADDRESS_2
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = DECODE(line_item_no_, 0, 0, -1);
BEGIN
   OPEN get_rec;
   FETCH get_rec INTO dummy_;
   IF(get_rec%NOTFOUND) THEN
      CLOSE get_rec;
      RETURN Fnd_Boolean_API.DB_FALSE;
   END IF;
   CLOSE get_rec;
   RETURN Fnd_Boolean_API.DB_TRUE;
END Check_Exist_Line_Address;



