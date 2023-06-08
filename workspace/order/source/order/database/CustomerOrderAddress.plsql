-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderAddress
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210716  ThKrlk  Bug 159549(SCZ-15322), Modified Update___() to change the assignment of changed_country_code_. 
--  210607  Skanlk  Bug 159547(SCZ-15101), Modified Get_Address5() to fetch the value of address 5 correctly.
--  210427  ApWilk  Bug 158550(SCZ-14419), Modified the method Modify__() to trigger an information message when changing the single occurrence address in a CO having a shipment connected.
--  210129  Skanlk  SCZ-13274, Modified Update___() and Insert___() to update the tax code in charges lines when changing the tax free tax code when single occurence
--  210129          checkbox is checked.
--  210111  MaEelk  SC2020R1-12010, Replaced the logic insde New and Modify with New___ and Modify___ respectively.
--  201204  PamPlk  Bug 156222(SCZ-12747), Modified the method Modify__() by re-allocating the assignment of changed_country_code_.
--  200711  NiDalk  SCXTEND-4446, Modified Update___ to fetch taxes through a bundle call when using AVALARA. 
--  191206  DhAplk  Bug 150459(SCZ-7282) Modified Modify__() to get shipment connected info message from App_Context_SYS when supply code in IPD, IPT.
--  191003  Hairlk  SCXTEND-876, Avalara integration, Modified Check_Update___, Added code to fetch jurisdiction code if the external tax calculation method is Avalara.
--  190923  UdGnlk  Bug 148052 (SCZ-5108), Modified Insert___() and Update___() to prevent refetching the tax code when the single occurence address 
--  190923          is checked for a taxable part unless the sales part is using a tax class.
--  190827  JiThlk  Bug 149444(SCZ-6259) Modified Modify__() to fix error for missing country code when removing Single Occurrence Checkbox from CO header 
--  190827          with a cancelled order line.
--  190709  KiSalk  Bug 149120(SCZ-5052) Modified Modify_License_Address___ to call Customer_Order_Flow_API.Modify_License_Address with more parameters not to be fetched again.
--  190709          Modified Update___ not to call Tax_Handling_Order_Util_API.Set_To_Default for package components.
--  180719  BudKlk  Bug 142134, Added a new method Get_Address_Name() to retrive the cusotmer order header or line address accordingly.
--  171205  DilMlk  STRSC-14265, Modified Check_Common___() to prevent getting the 'Tax Exempt' info message when transaction level customer tax is not selected in company.
--  160623  SudJlk  STRSC-2698, Replaced Cust_Order_Line_Address_API.Public_Rec with Cust_Order_Line_Address_API.Co_Line_Addr_Rec and 
--  160623          Cust_Order_Line_Address_API.Get() with Cust_Order_Line_Address_API.Get_Co_Line_Addr() 
--  160620  SudJlk  STRSC-2697, Renamed Public_Rec to Cust_Ord_Addr_Rec and Get() to Get_Cust_Ord_Addr() to avoid confusion with model generated Public_Rec and Get().
--  160516  Chgulk  STRLOC-80, Added new address fields.
--  160506  Chgulk  STRLOC-369, used the correct package.
--  160328  ShPrLk  Bug 127644, Modified Insert___() to pass changed_vat_free_vat_code_ to Customer_Order_API.Modify_Address(). Modified Modify__() to handle info.   
--  160307  DipeLK  STRLOC-247,Change Validate_Address() method call to Address_validation_API.Validate_Address
--  160203  ErFelk  Bug 125233, Modified Modify__() by removing a get info call as another Get info is added at the end of the method. 
--  151106  Wahelk  Bug 122061, Modified Check_Insert___, Insert___ to send client values for address data when freight details are fetch in CO single occurance address update
--  151001  ErFelk  Bug 124888, Some message constants were renamed to CREATEPOCOAUTO, NONDEFLINEDATESCHANGED and NONDEFEARLYLINEDUEDATE in Modify__().
--  150813  KhVeSE  COB-691, Modified Modify__() method to handle tax changes on line level when VAT_FREE_VAT_CODE is changed on header SO address.
--  150910  ErFelk Bug 123263, Modified Insert___(), Modify__() and Update___() by passing vat_free_vat_code_ when calling the method Customer_Order_API.Modify_Address().        
--  150907  MeAblk Bug 124288, Modified Insert___ in order to correctly set the single occurence address by setting correct default values.
--  150710  PrYaLK Bug 123556, Modified Update___() to re-fetch the tax lines when the address is changed when sales tax is used 
--  150710         or when the country code is changed when VAT or MIX tax is used. Modified Insert___() to fetch the tax lines 
--  150710         when the address is used for the first time when VAT or MIX tax is used.
--  150630  KhVeSE  COB-14, Added logic to method Modify__() to copying header address to the lines with no default info set but same addr as header. 
--  141212  RasDlk PRSC-4614, Modified Check_Common___() to check whether in_city is null.
--  141209  RasDlk Bug 119764, Modified Update___() by passing FALSE as a parameter when calling Modify_Order_Defaults__ method.
--  140522  RoJalk Corrected the parameter error in Modify__ - super method call.
--  140408  ChBnlk Bug 116100, Modified Check_Update___() to give an error message when trying to modify the address of the invoiced customer
--  140408         order lines which are connected to freight functionality. 
--  140317  MAHPLK Modified Insert___ Update___ and Modify__ method to avoid overtake of Modify__. 
--  130911  IsSalk Bug 111274, Modified Modify__() to use correct delivery country when single occurrence is enabled.
--  130611  Cpeilk Bug 110375, Modified method Modify__ to update CO line vat_free_vat_code when CO header vat_free_vat_code gets changed.
--  130418  MaRalk Replaced view CUSTOMER_INFO_PUBLIC with CUSTOMER_INFO_CUSTCATEGORY_PUB in CUSTORD_ADDRESS view definition.
--  130227  SALIDE EDEL-2020, Replaced the use of company_name2 with the name from customer_info_address (ENTERP).
--  120918  GiSalk Bug 103562, Modified Modify__(), by calling Customer_Order_API.Check_Ipd_Tax_Registration() when country code is changed, if addr_flag is set.
--  120215  MeAblk Bug 100690, Modified the WHERE clause in the CURSOR get_lines_with_def_address in Update___ procedure in order to avoid getting cancelled order lines.
--  120125  ChJalk Modified the view comments of addr_1, addr_2, addr_3, addr_4, addr_5 and addr_6 in the base view.
--  111009  NaLrlk Modified the method Modify__ to pass the correct paramater in call Customer_Order_API.Modify_Address().
--  110818  AmPalk Bug 93557,In Unpack_Check_Update___ and Unpack_Check_Insert___ validated country, state, county and city.
--  110317  MaMalk Removed the use of pay tax in meesages since the pay tax is removed from the CO client.
--  101230  MiKulk Replaced the calls to Customer_Info_Vat_API with the new methods.
--  100728  ChFolk Modified New__ and Modify__ to support frieght information for single occurance.
--  100716  ChFolk Modified the usages of Cust_Ord_Charge_Tax_Lines_API.Set_To_Default as the parameters are changed.
--  100603  SaFalk Replaced Application_Country_API with Iso_Country_API.
--  100517  Ajpelk Merge rose method documentation
--  100427  MaGuse Bug 90022, Added method Get_Address_Country_Code. Modified methods New__ and Modify___. 
--  100427         Added new parameter changed_country_code_ to call to Customer_Order_API.Modify_Address.
--  090930  MaMalk Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  080526  ChJalk Bug 72771, Modified Update___ to update the charge line tax lines.
--  070511  ChBalk Bug 63020, Added parameter vat_free_vat_code_ to New.
--  070321  MalLlk Bug 60882, Removed parameter vat_no from methods New , Modify and Get.
--  070216  DAYJLK LCS Merge 63278, Added SUBSTR to the address in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  061213  SuSalk LCS Merge 61933, Modified Unpack_Check_Insert___ and Unpack_Check_Update___
--  061213         to get the correct address format.
--  061125  Cpeilk Added parameter VAT_NO to methods New and Modify.
--  060817  MiErlk Modified length of view comment ADDR_1
--  060726  ThGulk Added Objid instead of rowid in Procedure Insert__
--  060516  MiErlk Enlarge Identity - Changed view comment
--  060410  IsWilk Enlarge Identity - Changed view comments of customer_no.
--  ------------------------- 13.4.0 -----------------------------------------
--  060223  MiKulk Manual merge of bug 51197. Added error message when deleting the tax free tax code.
--  060125  JaJalk Added Assert safe annotation.
--  060112  NaWalk Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  050613  KiSalk Bug 50953, Added parameter IN_CITY to New and Modify.
--  050127  SaNalk Modified Get_Vat_No.
--  041028  HoInlk Bug 47642, Added validation for vat_free_vat_code when tax regime is sales tax, in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040827  NaWilk Bug 40315, Modified the veiw CUSTOMER_ORDER_ADDRESS by adding the columns vat_free_vat_code and company. Added a methods Get_Company
--  040827         and Get_Vat_Free_Vat_Code. Modified the methods Unpack_Check_Insert___,Unpack_Check_Update___, Insert___, and Update___,Modify__.
--  040531  ErSolk Bug 43207, Modified procedure Modify__.
--  040301  NaWilk Bug 37557, Modified the veiws, CUSTOMER_ORDER_ADDRESS by adding the column VAT_NO.Added a method Get_Vat_No.
--  040301         Modified the methods Unpack_Check_Insert___,Unpack_Check_Update___, Insert___, and Update___,Modify__
--  040220  IsWilk Removed the SUBSTRB from view and modified the SUBSTRB to SUBSTR for Unicode Changes.
--  030929  ThGu   Changed substr to substrb, instr to instrb, length to lengthb.
--  020617  AjShlk Bug 29312, Added county to Update_Ord_Address_Util_API.Get_Order_Address_Line
--  020322  SaKaLk Call 77116(Foreign Call 28170). Added county to public methods
--                 'New' and 'Modify' parameter list.
--  020317  JoAn  ID 10220 Vertex Integration - Added call to
--                Cust_Order_Line_Tax_Lines_API.Set_To_Default in Update___ to
--                initialize new retrival of tax lines from Vertex for order lines
--                with order default address.
--  020314  PerK  Added in_city
--  020307  PerK  Added county
--  001003  MaGu  Added control value ORDER_ADDRESS_UPDATE to Unpack_Check_Update___ to
--                prevent old address fields from being overwritten when running the order
--                address update application.
--  000914  MaGu  Added new address fields to CUSTORD_ADDRESS.
--                Added convertion to old address fields in Unpack_Check_Insert__ and
--                Unpack_Check_Update__. Renamed parameters in methods New and Modify.
--  000913  FBen  Added UNDEFINE.
--  000905  MaGu  Removed procedure Get_Addr_For_Country.
--  000901  MaGu  Added new attributes address1, address2, zip_code, city and
--                state.
--  000829  MaGu  Modified Get_Addr_For_Country, changed parameters.
--  000816  MaGu  Added procedure Get_Addr_For_Country. Used when updating
--                to the new address format.
--  ------------------------------ 12.1 -------------------------------------
--  991007  JoEd  Call Id 21210: Corrected double-byte problems.
--  990819  JoEd  Added ship_addr_no and addr_flag to public Get for use in
--                CustomerOrderLine when inserting default address.
--  ------------------------------ 11.1 -------------------------------------
--  990507  RaKu  Changed in CUSTOMER_ADDRESS view. Country code was wrong defined.
--  990506  PaLj  Changed temp_ declaration to VIEW type in Get_Addr_1-6 and Get_Country_Code
--  990506  JoAn  Using customer_info_address_public instead of customer_info_address_tab
--  990422  RaKu  Y.Corrections.
--  990414  RaKu  New templates.
--  990126  RaKu  Different changes for the new Address-tab in CustomerOrder-form.
--  981006  RaKu  Removed obsolete code from procedure Modify.
--  981002  RaKu  Added procedures Modify and Remove. Tuned the view by replacing
--                Gen_Yes_No_API.Get_Db_Value(0) with 'Y'.
--  971222  JoAn  Added Get_Country_Code.
--  971125  RaKu  Changed to FND200 Templates.
--  970924  RaKu  The country_code was returned as varchar2(2000) in view. Changed so
--                it returns varchar2(2).
--  970828  JoAn  Changes due to Enterprise integration. Columns addr_1..addr_5
--                and country code previosly retrieved from Cust_Ord_Customer_Address
--                view now retrieved using function calls.
--  970604  PAZE  Country_code set to required.
--  970522  JoEd  Rebuild Get_.. methods calling Get_Instance___.
--                Added .._db column in the view for the IID column.
--  970508  PAZE  Changed Mpccom_Country_API to Application_Country_API and reference.
--                Changed length on country_code.
--  970505  JoEd  Rebuild package, changed Check_Exist___ method. Removed unused
--                public methods.
--                Changed reference on order_no from NOCHECK to CASCADE.
--  970312  RaKu  Changed table name.
--  970219  JoEd  Changed objversion
--  960626  JoEd  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Cust_Ord_Addr_Rec IS RECORD
   (addr_1 CUSTOMER_ORDER_ADDRESS_TAB.addr_1%TYPE,
    addr_2 CUSTOMER_ORDER_ADDRESS_TAB.addr_2%TYPE,
    addr_3 CUSTOMER_ORDER_ADDRESS_TAB.addr_3%TYPE,
    addr_4 CUSTOMER_ORDER_ADDRESS_TAB.addr_4%TYPE,
    addr_5 CUSTOMER_ORDER_ADDRESS_TAB.addr_5%TYPE,
    addr_6 CUSTOMER_ORDER_ADDRESS_TAB.addr_6%TYPE,
    country_code CUSTOMER_ORDER_ADDRESS_TAB.country_code%TYPE,
    ship_addr_no CUSTOMER_ORDER_TAB.ship_addr_no%TYPE,
    addr_flag CUSTOMER_ORDER_TAB.addr_flag%TYPE,
    address1 CUSTOMER_ORDER_ADDRESS_TAB.address1%TYPE,
    address2 CUSTOMER_ORDER_ADDRESS_TAB.address2%TYPE,
    address3 CUSTOMER_ORDER_ADDRESS_TAB.address3%TYPE,
    address4 CUSTOMER_ORDER_ADDRESS_TAB.address4%TYPE,
    address5 CUSTOMER_ORDER_ADDRESS_TAB.address5%TYPE,
    address6 CUSTOMER_ORDER_ADDRESS_TAB.address6%TYPE,
    zip_code CUSTOMER_ORDER_ADDRESS_TAB.zip_code%TYPE,
    city CUSTOMER_ORDER_ADDRESS_TAB.city%TYPE,
    state CUSTOMER_ORDER_ADDRESS_TAB.state%TYPE,
    county CUSTOMER_ORDER_ADDRESS_TAB.county%TYPE,
    in_city CUSTOMER_ORDER_ADDRESS_TAB.in_city%TYPE,
    company CUSTOMER_ORDER_ADDRESS_TAB.company%TYPE,
    vat_free_vat_code CUSTOMER_ORDER_ADDRESS_TAB.vat_free_vat_code%TYPE);


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Modify_License_Address___ (
   order_no_     IN VARCHAR2)
IS
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no, demand_code, demand_order_ref1, demand_order_ref2, demand_order_ref3
      FROM   Customer_Order_Line_Tab t
      WHERE  t.order_no = order_no_
      AND    t.default_addr_flag = 'Y';

BEGIN

   FOR rec_ IN get_lines LOOP
      Customer_Order_Flow_API.Modify_License_Address(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.demand_code, rec_.demand_order_ref1, rec_.demand_order_ref2, rec_.demand_order_ref3);
   END LOOP;

END Modify_License_Address___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUSTOMER_ORDER_ADDRESS_TAB%ROWTYPE,
   newrec_     IN OUT CUSTOMER_ORDER_ADDRESS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   order_rec_             Customer_Order_API.Public_Rec;
   company_               VARCHAR2(20);
   tax_method_            VARCHAR2(50);
   bill_addr_no_          CUSTOMER_ORDER_ADDRESS_2.bill_addr_no%TYPE;
   ship_addr_no_          CUSTOMER_ORDER_ADDRESS_2.ship_addr_no%TYPE;
   addr_flag_db_          VARCHAR2(200);
   changed_country_code_  VARCHAR2(2) := NULL;
   freight_map_id_        VARCHAR2(15);
   zone_id_               VARCHAR2(15);
   zone_info_exist_       VARCHAR2(5) := 'FALSE';
   delivery_country_code_ VARCHAR2(2);   
   no_of_lines_           NUMBER;
   tax_calc_structure_id_ VARCHAR2(20);
   tax_liability_type_db_ VARCHAR2(20) := NULL;
   copy_addr_to_line_     VARCHAR2(10) := 'FALSE';
   
   CURSOR get_lines_with_def_address(order_no_ IN VARCHAR2) IS
      SELECT line_no, rel_no, line_item_no
      FROM customer_order_line_tab
      WHERE order_no = order_no_ AND   line_item_no <= 0
      AND   default_addr_flag = 'Y' AND rowstate != 'Cancelled'
      AND   tax_class_id IS NOT NULL;

   CURSOR get_connected_charge_lines(tax_liability_type_ IN VARCHAR2, copy_addr_to_line_ IN VARCHAR2) IS
      SELECT sequence_no
      FROM   customer_order_charge_tab coc
      WHERE  order_no = newrec_.order_no
      AND    ((coc.tax_class_id IS NOT NULL AND tax_liability_type_ != 'EXM') OR tax_liability_type_ = 'EXM')
      AND    Sales_Charge_Type_API.Get_Taxable_Db(coc.contract, coc.charge_type) = 'TRUE'
      AND    (EXISTS (SELECT 1
                      FROM  customer_order_line_tab col
                      WHERE coc.order_no = col.order_no
                      AND   coc.line_no = col.line_no
                      AND   coc.rel_no = col.rel_no
                      AND   coc.line_item_no = col.line_item_no
                      AND   ((col.default_addr_flag = 'Y') OR (col.default_addr_flag = 'N'
                                                          AND  copy_addr_to_line_ = 'TRUE'
                                                          AND  tax_liability_type_ = 'EXM')))
                      
              OR

              EXISTS (SELECT 1
                      FROM customer_order_line_tab col
                      WHERE coc.order_no = col.order_no
                      AND coc.line_no IS NULL
                      AND coc.rel_no IS NULL
                      AND coc.line_item_no IS NULL));

   CURSOR get_lines_to_update_fee_code (order_no_ IN VARCHAR2) IS
      SELECT count(line_no)
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    tax_liability_type = 'EXM'
      AND    default_addr_flag = 'Y'
      AND    addr_flag = 'Y';

   CURSOR get_rec (order_no_ IN VARCHAR2)IS
      SELECT addr_1, addr_2, addr_3, addr_4, addr_5, addr_6, country_code, address1, address2,address3,address4,address5,address6, zip_code, city, state, vat_free_vat_code
      FROM   CUSTOMER_ORDER_ADDRESS_2
      WHERE  order_no = order_no_;  
BEGIN
   addr_flag_db_ := Client_SYS.Get_Item_Value('ADDR_FLAG_DB', attr_);
   bill_addr_no_ := Client_SYS.Get_Item_Value('BILL_ADDR_NO', attr_);
   ship_addr_no_ := Client_SYS.Get_Item_Value('SHIP_ADDR_NO', attr_);
   delivery_country_code_ := Client_SYS.Get_Item_Value('COUNTRY_CODE', attr_);   
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   order_rec_ := Customer_Order_API.Get(newrec_.order_no);
   
   -- IF tax lines are retrived from Vertex a new retrival should be done for all lines with
   -- order default address if city, state, zip_code, county or in_city has been changed
   company_     := Site_API.Get_Company(order_rec_.contract);
   tax_method_  := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);
   tax_liability_type_db_  := Customer_Order_API.Get_Tax_Liability_Type_Db(newrec_.order_no);
   copy_addr_to_line_      := Client_SYS.Get_Item_Value('COPY_ADDR_TO_LINE', attr_);
   
   -- If tax lines are retrived from Vertex a new retrival should be done for all lines with
   -- order default address if city, state, zip_code, county or in_city has been changed
   -- setting the tax to default at an address updation.
   IF (((((nvl(newrec_.city, ' ') != nvl(oldrec_.city, ' ')) OR
       (nvl(newrec_.state, ' ') != nvl(oldrec_.state, ' ')) OR
       (nvl(newrec_.zip_code, ' ') != nvl(oldrec_.zip_code, ' ')) OR
       (nvl(newrec_.county, ' ') != nvl(oldrec_.county, ' ')) OR
       (nvl(newrec_.in_city, ' ') != nvl(oldrec_.in_city, ' '))) AND 
       (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED)) OR
       ((NVL(newrec_.country_code, ' ') != NVL(oldrec_.country_code, ' ')) AND (tax_liability_type_db_ != 'EXM'))) OR tax_liability_type_db_ = 'EXM') THEN
      
      IF (tax_liability_type_db_ != 'EXM') THEN
         -- gelr:br_external_tax_integration, added AVALARA_TAX_BRAZIL
         IF (tax_method_ IN (External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX, External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL)) THEN 
            Customer_Order_API.Fetch_External_Tax(newrec_.order_no, 'TRUE');
         ELSE 
            FOR next_line_ IN get_lines_with_def_address(newrec_.order_no) LOOP
               Tax_Handling_Order_Util_API.Set_To_Default(tax_calc_structure_id_,
                                                          company_,
                                                          Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                          newrec_.order_no, 
                                                          next_line_.line_no, 
                                                          next_line_.rel_no, 
                                                          next_line_.line_item_no,
                                                          '*');
            END LOOP;
         END IF;
      END IF;
      
      FOR chrge_rec_ IN get_connected_charge_lines (tax_liability_type_db_, copy_addr_to_line_) LOOP
         Tax_Handling_Order_Util_API.Set_To_Default(tax_calc_structure_id_, company_, Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, newrec_.order_no, chrge_rec_.sequence_no, '*', '*', '*', copy_addr_to_line_);
      END LOOP;
   END IF;
      
   IF addr_flag_db_ IS NOT NULL THEN
      IF (newrec_.country_code = oldrec_.country_code) THEN
         changed_country_code_ := NULL;
      ELSE
         changed_country_code_ := newrec_.country_code;
      END IF;
      IF (addr_flag_db_ = 'Y') THEN    
         OPEN  get_rec(newrec_.order_no);
         FETCH get_rec INTO newrec_.addr_1, newrec_.addr_2, newrec_.addr_3, newrec_.addr_4, newrec_.addr_5, newrec_.addr_6, newrec_.country_code, newrec_.address1, newrec_.address2,newrec_.address3,newrec_.address4,newrec_.address5,newrec_.address6, newrec_.zip_code, newrec_.city, newrec_.state, newrec_.vat_free_vat_code;
         CLOSE get_rec;
         
         IF NVL(delivery_country_code_, '*')!= NVL(newrec_.country_code, '*') THEN
            Customer_Order_API.Check_Ipd_Tax_Registration(oldrec_.order_no, 'TRUE');
         END IF;
         
         Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(freight_map_id_,
                                                           zone_id_,
                                                           zone_info_exist_,
                                                           order_rec_.contract,
                                                           order_rec_.ship_via_code,
                                                           newrec_.zip_code,
                                                           newrec_.city,
                                                           newrec_.county,
                                                           newrec_.state,
                                                           newrec_.country_code);
        
      END IF; 
      -- Update fields on order header
      Customer_Order_API.Modify_Address(newrec_.order_no, bill_addr_no_, ship_addr_no_, 
                                        addr_flag_db_, changed_country_code_, freight_map_id_, zone_id_, newrec_.vat_free_vat_code);
   END IF;
   
   IF (oldrec_.vat_free_vat_code != newrec_.vat_free_vat_code) THEN
      OPEN get_lines_to_update_fee_code(newrec_.order_no);
      FETCH get_lines_to_update_fee_code INTO no_of_lines_;
      CLOSE get_lines_to_update_fee_code;

      IF (no_of_lines_ > 0) THEN
         Customer_Order_Line_API.Modify_Order_Defaults__(newrec_.order_no, 'FALSE');
      END IF;
   END IF;
END Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     customer_order_address_tab%ROWTYPE,
   newrec_ IN OUT customer_order_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   tax_liability_type_ VARCHAR2(20);
   ship_country_       VARCHAR2(50);
   address_rec_        Address_Presentation_API.Address_Rec_Type;
BEGIN   
   IF (newrec_.company IS NULL) THEN
      newrec_.company := Site_API.Get_Company(Customer_Order_API.Get_Contract(newrec_.order_no));
   END IF;
   IF (newrec_.in_city IS NULL) THEN
      newrec_.in_city := 'FALSE';
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   
   Address_Setup_API.Validate_Address(newrec_.country_code, newrec_.state, newrec_.county, newrec_.city);
   
   IF (newrec_.vat_free_vat_code IS NOT NULL) THEN
      Statutory_Fee_API.Exist(newrec_.company, newrec_.vat_free_vat_code);      
      IF (Statutory_Fee_API.Get_Percentage(newrec_.company, newrec_.vat_free_vat_code) != 0) THEN
         Error_SYS.Record_General(lu_name_, 'VATFREEVATERR: Tax Free Tax Code :P1 should be the percentage of 0', newrec_.vat_free_vat_code);
      END IF;
   ELSE
      IF (Company_Tax_Control_API.Get_Tax_Code_Validation(newrec_.company, 'CUSTOMER_TAX', 'TRANSACTION')= Fnd_Boolean_API.DB_TRUE) THEN 
         tax_liability_type_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(Customer_Order_API.Get_Tax_Liability(newrec_.order_no), Customer_Order_Address_API.Get_Address_Country_Code(newrec_.order_no));
         IF (tax_liability_type_ = 'EXM') THEN
            Client_SYS.Add_Info(lu_name_, 'NOTAXFREECODE: A tax liability with Exempt liability type is used on this Customer Order but Tax Free Tax Code is missing');
         END IF;
      END IF;
   END IF;
   -- Convert the new address to the address presentation format.
   ship_country_ := SUBSTR(Iso_Country_API.Get_Description(newrec_.country_code), 1, 50);
   address_rec_  := Update_Ord_Address_Util_API.Get_All_Order_Address_Lines(newrec_.country_code, newrec_.address1, newrec_.address2, newrec_.zip_code,
                                                                            newrec_.city, newrec_.state, newrec_.county, ship_country_ ,newrec_.address3,
                                                                            newrec_.address4,newrec_.address5,newrec_.address6);
   newrec_.addr_2 := SUBSTR(address_rec_.address1,1,35);
   newrec_.addr_3 := SUBSTR(address_rec_.address2,1,35);
   newrec_.addr_4 := SUBSTR(address_rec_.address3,1,35);
   newrec_.addr_5 := SUBSTR(address_rec_.address4,1,35);
   newrec_.addr_6 := SUBSTR(address_rec_.address5,1,35);
END Check_Common___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_order_address_tab%ROWTYPE,
   newrec_ IN OUT customer_order_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   order_address_update_      BOOLEAN := FALSE;
   external_tax_calc_method_  VARCHAR2(50);
   postal_addresses_          External_Tax_System_Util_API.postal_address_arr;
   postal_address_            External_Tax_System_Util_API.postal_address_rec;
BEGIN
   IF Client_SYS.Item_Exist('ORDER_ADDRESS_UPDATE', attr_) THEN
      order_address_update_ := TRUE;
   END IF;
   indrec_.order_no := FALSE;
   IF (Customer_Order_API.Has_Invoiced_Lines(newrec_.order_no) AND Customer_Order_API.Exists_Freight_Info_Lines(newrec_.order_no)) THEN
      Error_SYS.Record_General(lu_name_, 'FREIGHT_ORDER: Invoiced order lines connected to Freight functionality cannot be changed.');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   
   external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);      
   IF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX) THEN
      IF newrec_.country_code = 'US' THEN
            postal_addresses_.DELETE;      
            postal_address_          := NULL;
            postal_address_.address_id := newrec_.addr_1;
            postal_address_.address1 := newrec_.address1;
            postal_address_.address2 := newrec_.address2;
            postal_address_.zip_code := newrec_.zip_code;
            postal_address_.city     := newrec_.city;
            postal_address_.state    := newrec_.state;
            postal_address_.county   := newrec_.county;
            postal_address_.country  := newrec_.country_code;
            postal_addresses_(0)     := postal_address_; 
            External_Tax_System_Util_API.Handle_Address_Information(postal_addresses_, newrec_.company, 'COMPANY_CUSTOMER'); 
      END IF;
   END IF;
END Check_Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_order_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(newrec_, indrec_, attr_);
   Client_SYS.Add_To_Attr('COUNTRY_CODE', newrec_.country_code, attr_);
   Client_SYS.Add_To_Attr('VAT_FREE_VAT_CODE', newrec_.vat_free_vat_code, attr_);
   Client_SYS.Add_To_Attr('ZIP_CODE', newrec_.zip_code, attr_);
   Client_SYS.Add_To_Attr('CITY', newrec_.city, attr_);
   Client_SYS.Add_To_Attr('STATE', newrec_.state, attr_);
   Client_SYS.Add_To_Attr('COUNTY', newrec_.county, attr_);   
END Check_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT customer_order_address_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   bill_addr_no_              VARCHAR2(50);
   ship_addr_no_              VARCHAR2(50);
   addr_flag_db_              VARCHAR2(200) := NULL;
   freight_map_id_            VARCHAR2(15);
   zone_id_                   VARCHAR2(15);
   zone_info_exist_           VARCHAR2(5) := 'FALSE';
   changed_country_code_      VARCHAR2(2):= NULL;
   order_rec_                 Customer_Order_API.Public_Rec;
   company_                   VARCHAR2(20);
   country_code_              VARCHAR2(50);
   changed_vat_free_vat_code_ VARCHAR2(20);
   changed_zip_code_          customer_order_address_tab.zip_code%TYPE;
   changed_city_              customer_order_address_tab.city%TYPE;
   changed_county_            customer_order_address_tab.county%TYPE;
   changed_state_             customer_order_address_tab.state%TYPE;
   tax_calc_structure_id_     VARCHAR2(20);
   tax_liability_type_db_     VARCHAR2(20) := NULL;
   copy_addr_to_line_         VARCHAR2(10) := 'FALSE';
   
   CURSOR get_rec (order_no_ IN VARCHAR2)IS
      SELECT addr_1, addr_2, addr_3, addr_4, addr_5, addr_6, country_code, address1, address2,address3,address4,address5,address6, zip_code, city, state, vat_free_vat_code
      FROM   CUSTOMER_ORDER_ADDRESS_2
      WHERE  order_no = order_no_;

   CURSOR get_lines_with_def_address(order_no_ IN VARCHAR2) IS
      SELECT line_no, rel_no, line_item_no
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      AND   default_addr_flag = 'Y'
      AND   rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   tax_class_id IS NOT NULL;

   CURSOR get_charge_lines(tax_liability_type_ IN VARCHAR2, copy_addr_to_line_ IN VARCHAR2) IS
      SELECT sequence_no
      FROM   customer_order_charge_tab coc, customer_order_line_tab col
      WHERE  coc.order_no = newrec_.order_no
      AND    coc.order_no = col.order_no
      AND    ((coc.tax_class_id IS NOT NULL AND tax_liability_type_ != 'EXM') OR tax_liability_type_ = 'EXM')
      AND    Sales_Charge_Type_API.Get_Taxable_Db(coc.contract, coc.charge_type) = 'TRUE'
      AND    (coc.line_no IS NULL  OR    (coc.line_no = col.line_no
                                   AND   coc.rel_no = col.rel_no
                                   AND   coc.line_item_no = col.line_item_no
                                   AND   ((col.default_addr_flag = 'Y') OR (col.default_addr_flag = 'N'
                                                                        AND copy_addr_to_line_ = 'TRUE'
                                                                        AND tax_liability_type_ = 'EXM'))));                      
BEGIN
   -- shipping and billing addreses.
   order_rec_   := Customer_Order_API.Get(newrec_.order_no);
   addr_flag_db_ := NVL(Client_SYS.Get_Item_Value('ADDR_FLAG_DB', attr_), 'Y');
   bill_addr_no_ := NVL(Client_SYS.Get_Item_Value('BILL_ADDR_NO', attr_), order_rec_.bill_addr_no);
   ship_addr_no_ := NVL(Client_SYS.Get_Item_Value('SHIP_ADDR_NO', attr_), order_rec_.ship_addr_no);
   
   country_code_ := Client_SYS.Get_Item_Value('COUNTRY_CODE', attr_);
   
   IF (newrec_.vat_free_vat_code IS NULL) THEN
      newrec_.vat_free_vat_code := Get_Vat_Free_Vat_Code(newrec_.order_no);
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);
   
  
   company_     := Site_API.Get_Company(order_rec_.contract);
   
   tax_liability_type_db_  := Customer_Order_API.Get_Tax_Liability_Type_Db(newrec_.order_no);
   copy_addr_to_line_      := Client_SYS.Get_Item_Value('COPY_ADDR_TO_LINE', attr_);
 
   IF (addr_flag_db_ = 'Y') THEN
      changed_country_code_ := Client_SYS.Get_Item_Value('COUNTRY_CODE', attr_);
      changed_vat_free_vat_code_ := Client_SYS.Get_Item_Value('VAT_FREE_VAT_CODE', attr_);
      changed_zip_code_ := Client_SYS.Get_Item_Value('ZIP_CODE', attr_);
      changed_city_     := Client_SYS.Get_Item_Value('CITY', attr_);
      changed_county_   := Client_SYS.Get_Item_Value('COUNTY', attr_);
      changed_state_    := Client_SYS.Get_Item_Value('STATE', attr_);
      
      OPEN  get_rec(newrec_.order_no);
      FETCH get_rec INTO newrec_.addr_1, newrec_.addr_2, newrec_.addr_3, newrec_.addr_4, newrec_.addr_5, newrec_.addr_6, newrec_.country_code, newrec_.address1, newrec_.address2,newrec_.address3,newrec_.address4,newrec_.address5,newrec_.address6, newrec_.zip_code, newrec_.city, newrec_.state, newrec_.vat_free_vat_code;
      CLOSE get_rec;

      Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(freight_map_id_,
                                                        zone_id_,
                                                        zone_info_exist_,
                                                        order_rec_.contract,
                                                        order_rec_.ship_via_code,
                                                        NVL(changed_zip_code_, newrec_.zip_code),
                                                        NVL(changed_city_, newrec_.city),
                                                        NVL(changed_county_, newrec_.county),
                                                        NVL(changed_state_, newrec_.state),
                                                        NVL(changed_country_code_, newrec_.country_code) );
   END IF;
   
   -- Update fields on order header
      Customer_Order_API.Modify_Address(newrec_.order_no, bill_addr_no_, ship_addr_no_,
                                        addr_flag_db_, changed_country_code_, freight_map_id_, zone_id_, changed_vat_free_vat_code_);
   
   -- when setting the single occurrence address for the first time.
   IF (tax_liability_type_db_ != 'EXM') THEN
      FOR next_line_ IN get_lines_with_def_address(newrec_.order_no) LOOP
         Tax_Handling_Order_Util_API.Set_To_Default(tax_calc_structure_id_,
                                                    company_,
                                                    Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                    newrec_.order_no, 
                                                    next_line_.line_no, 
                                                    next_line_.rel_no, 
                                                    next_line_.line_item_no,
                                                    '*');
      END LOOP;
   END IF;
   FOR chrge_records_ IN get_charge_lines(tax_liability_type_db_, copy_addr_to_line_) LOOP
      Tax_Handling_Order_Util_API.Set_To_Default(tax_calc_structure_id_, company_, Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, newrec_.order_no, chrge_records_.sequence_no, '*', '*', '*', copy_addr_to_line_);
   END LOOP;
END Insert___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_              CUSTOMER_ORDER_ADDRESS_API.Cust_Ord_Addr_Rec;
   new_co_addr_rec_     CUSTOMER_ORDER_ADDRESS_API.Cust_Ord_Addr_Rec;
   newrec_              CUSTOMER_ORDER_ADDRESS_TAB%ROWTYPE;
   remrec_              CUSTOMER_ORDER_ADDRESS_TAB%ROWTYPE;
   dummy_               VARCHAR2(2002);
   order_no_            VARCHAR2(12);
   addr_flag_db_        VARCHAR2(200);   
   bill_addr_no_        CUSTOMER_ORDER_ADDRESS_2.bill_addr_no%TYPE;
   ship_addr_no_        CUSTOMER_ORDER_ADDRESS_2.ship_addr_no%TYPE;
   changed_country_code_ VARCHAR2(2) := NULL;
   freight_map_id_      VARCHAR2(15);
   zone_id_             VARCHAR2(15);
   corec_               Customer_Order_API.Public_Rec;
   indrec_              Indicator_Rec;   
   copy_addr_to_line_   VARCHAR2(10) := 'FALSE';
   line_addr_rec_       CUST_ORDER_LINE_ADDRESS_API.Co_Line_Addr_Rec;
   lineattr_            VARCHAR2(2000);
   refresh_tax_code_    BOOLEAN := FALSE;
   pegged_obj_          VARCHAR2(5); 
   message_attr_        VARCHAR2(2000);
   shpmnt_info_        VARCHAR2(2000);
   single_occ_addr_created_ BOOLEAN := FALSE;

   CURSOR get_non_default_lines (order_no_ IN VARCHAR2, addr_flag_ IN VARCHAR2) IS 
      SELECT line_no, rel_no, line_item_no, contract, catalog_no, tax_liability, supply_code
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    default_addr_flag = 'N'
      AND    addr_flag = addr_flag_
      AND    rowstate NOT IN ('Delivered','Invoiced','Cancelled');

BEGIN

   IF (action_ = 'CHECK') THEN
      super(info_, objid_, objversion_, attr_, 'CHECK');
   ELSIF (action_ = 'DO') THEN
      order_no_ := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
      addr_flag_db_ := Client_SYS.Get_Item_Value('ADDR_FLAG_DB', attr_);
      bill_addr_no_ := Client_SYS.Get_Item_Value('BILL_ADDR_NO', attr_);
      ship_addr_no_ := Client_SYS.Get_Item_Value('SHIP_ADDR_NO', attr_);
      copy_addr_to_line_ := Client_SYS.Get_Item_Value('COPY_ADDR_TO_LINE', attr_);
      corec_ := Customer_Order_API.Get(order_no_);   
      oldrec_ := CUSTOMER_ORDER_ADDRESS_API.Get_Cust_Ord_Addr(order_no_);
      
      IF (addr_flag_db_ = 'Y') THEN         
         IF Check_Exist___(order_no_) THEN
            super(info_, objid_, objversion_, attr_, 'DO');
         ELSE
            Trace_SYS.Message('Create order address');
            Unpack___(newrec_, indrec_, attr_);
            Check_Insert___(newrec_, indrec_, attr_);
            Insert___(dummy_, objversion_, newrec_, attr_); 
            single_occ_addr_created_ := TRUE;
         END IF;
      ELSIF Check_Exist___(order_no_) THEN
         -- Update fields on order header
         changed_country_code_ := Cust_Ord_Customer_Address_API.Get_Country_Code(corec_.customer_no, corec_.ship_addr_no);   
         Customer_Order_API.Modify_Address(order_no_, bill_addr_no_, ship_addr_no_, addr_flag_db_, 
                                           changed_country_code_, freight_map_id_, zone_id_, newrec_.vat_free_vat_code);
         Trace_SYS.Message('Delete order address');
         Client_SYS.Clear_Attr(attr_);
         remrec_ := Lock_By_Id___(objid_, objversion_);      
         Check_Delete___(remrec_);
         Delete___(objid_, remrec_);
         objversion_ := NULL;      
      END IF;
      
      IF(addr_flag_db_ = 'N' OR single_occ_addr_created_ OR (addr_flag_db_ = 'Y' AND
         (nvl(oldrec_.addr_1, ' ') != nvl(newrec_.addr_1, ' '))OR
         (nvl(oldrec_.addr_2, ' ') != nvl(newrec_.addr_2, ' '))OR
         (nvl(oldrec_.addr_3, ' ') != nvl(newrec_.addr_3, ' '))OR
         (nvl(oldrec_.addr_4, ' ') != nvl(newrec_.addr_4, ' '))OR
         (nvl(oldrec_.addr_5, ' ') != nvl(newrec_.addr_5, ' '))OR
         (nvl(oldrec_.addr_6, ' ') != nvl(newrec_.addr_6, ' '))OR
         (nvl(oldrec_.address1, ' ') != nvl(newrec_.address1, ' '))OR
         (nvl(oldrec_.address2, ' ') != nvl(newrec_.address2, ' '))OR
         (nvl(oldrec_.address3, ' ') != nvl(newrec_.address3, ' '))OR
         (nvl(oldrec_.address4, ' ') != nvl(newrec_.address4, ' '))OR
         (nvl(oldrec_.address5, ' ') != nvl(newrec_.address5, ' '))OR
         (nvl(oldrec_.address6, ' ') != nvl(newrec_.address6, ' '))OR
         (nvl(oldrec_.zip_code, ' ') != nvl(newrec_.zip_code, ' '))OR
         (nvl(oldrec_.city, ' ') != nvl(newrec_.city, ' '))OR
         (nvl(oldrec_.in_city, ' ') != nvl(newrec_.in_city, ' '))OR
         (nvl(oldrec_.state, ' ') != nvl(newrec_.state, ' '))OR
         (nvl(oldrec_.county, ' ') != nvl(newrec_.county, ' '))OR
         (nvl(oldrec_.country_code, ' ') != nvl(newrec_.country_code, ' '))))THEN
            IF (Shipment_Handling_Utility_API.Any_Shipment_Connected_Lines(order_no_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = 'TRUE') THEN
               Client_SYS.Add_Info(lu_name_, 'SHIPCONN: One or more order lines are connected to shipment(s). Note that the delivery information must be changed manually for each shipment connected to the changed customer order');
            END IF;           
      END IF;
      
      IF copy_addr_to_line_  = 'TRUE' THEN

         new_co_addr_rec_ := CUSTOMER_ORDER_ADDRESS_API.Get_Cust_Ord_Addr(order_no_);  
         Client_SYS.Clear_Attr(message_attr_);
         Client_SYS.Add_To_Attr('INFO_ADDED','FALSE', message_attr_);
         Client_SYS.Add_To_Attr('LINE_DUE_DATE_CHANGED','FALSE', message_attr_);
         Client_SYS.Add_To_Attr('LINE_DATE_CHANGED','FALSE', message_attr_);
         Client_SYS.Add_To_Attr('POCO_AUTO','FALSE', message_attr_);
         IF (Fnd_Session_API.Is_Odp_Session) THEN
            Client_SYS.Add_To_Attr('REPLICATE_CHANGES', Client_SYS.Get_Item_Value('REPLICATE_CHANGES', attr_), message_attr_);
            Client_SYS.Add_To_Attr('CHANGE_REQUEST', Client_SYS.Get_Item_Value('CHANGE_REQUEST', attr_), message_attr_);
         END IF;
         
         FOR linerec_ IN get_non_default_lines(order_no_, corec_.addr_flag) LOOP
            Client_Sys.Clear_Attr(lineattr_);
            line_addr_rec_ := CUST_ORDER_LINE_ADDRESS_API.Get_Co_Line_Addr(order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
            IF Validate_SYS.Is_Equal(oldrec_.addr_1, line_addr_rec_.addr_1) AND
               Validate_SYS.Is_Equal(oldrec_.address1, line_addr_rec_.address1) AND
               Validate_SYS.Is_Equal(oldrec_.address2, line_addr_rec_.address2) AND
               Validate_SYS.Is_Equal(oldrec_.country_Code, line_addr_rec_.country_Code) AND
               Validate_SYS.Is_Equal(oldrec_.state, line_addr_rec_.state) AND 
               Validate_SYS.Is_Equal(oldrec_.zip_code, line_addr_rec_.zip_code) AND
               Validate_SYS.Is_Equal(oldrec_.city, line_addr_rec_.city) AND
               Validate_SYS.Is_Equal(oldrec_.county, line_addr_rec_.county) THEN 
               
               IF Validate_SYS.Is_Changed(oldrec_.vat_free_vat_code, Client_SYS.Get_Item_Value('VAT_FREE_VAT_CODE', attr_)) then 
                  refresh_tax_code_ := TRUE;
               END IF; 
               
               IF Validate_SYS.Is_Different(corec_.addr_flag, addr_flag_db_) OR 
                  refresh_tax_code_ THEN 
                     CUSTOMER_ORDER_LINE_API.Modify_Delivery_Address__(message_attr_,
                                                                       order_no_, 
                                                                       linerec_.line_no, 
                                                                       linerec_.rel_no, 
                                                                       linerec_.line_item_no,
                                                                       addr_flag_db_,
                                                                       ship_addr_changed_ => FALSE,
                                                                       refresh_tax_code_ => refresh_tax_code_,
                                                                       supply_country_changed_ => FALSE);   
               END IF; 
                  
               IF addr_flag_db_ = 'Y' AND corec_.addr_flag = 'Y' AND 
                  (Validate_SYS.Is_Different(new_co_addr_rec_.addr_1, line_addr_rec_.addr_1) OR 
                   Validate_SYS.Is_Different(new_co_addr_rec_.address1, line_addr_rec_.address1) OR
                   Validate_SYS.Is_Different(new_co_addr_rec_.address2, line_addr_rec_.address2) OR
                   Validate_SYS.Is_Different(new_co_addr_rec_.country_Code, line_addr_rec_.country_Code) OR
                   Validate_SYS.Is_Different(new_co_addr_rec_.state, line_addr_rec_.state) OR 
                   Validate_SYS.Is_Different(new_co_addr_rec_.zip_code, line_addr_rec_.zip_code) OR
                   Validate_SYS.Is_Different(new_co_addr_rec_.city, line_addr_rec_.city) OR
                   Validate_SYS.Is_Different(new_co_addr_rec_.county, line_addr_rec_.county)) THEN 
                  
                  pegged_obj_ := Customer_Order_Line_API.Check_Address_Replication__(order_no_ ,linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
                  IF pegged_obj_ = 'TRUE' AND NOT Fnd_Session_API.Is_Odp_Session THEN 
                     Client_SYS.Add_To_Attr('REPLICATE_CHANGES', 'TRUE', lineattr_);
                     Client_SYS.Add_To_Attr('CHANGE_REQUEST', 'TRUE', lineattr_);
                     Client_SYS.Add_To_Attr('CHANGED_ATTRIB_NOT_IN_POL', 'FALSE', lineattr_);
                  END IF ;
                  Client_SYS.Add_To_Attr('ADDR_1', new_co_addr_rec_.addr_1, lineattr_);
                  Client_SYS.Add_To_Attr('ADDRESS1', new_co_addr_rec_.address1, lineattr_);
                  Client_SYS.Add_To_Attr('ADDRESS2', new_co_addr_rec_.address2, lineattr_);
                  Client_SYS.Add_To_Attr('ZIP_CODE', new_co_addr_rec_.zip_code, lineattr_);
                  Client_SYS.Add_To_Attr('CITY', new_co_addr_rec_.city, lineattr_);
                  Client_SYS.Add_To_Attr('STATE', new_co_addr_rec_.state, lineattr_);
                  Client_SYS.Add_To_Attr('COUNTRY_CODE', new_co_addr_rec_.country_code, lineattr_);
                  Client_SYS.Add_To_Attr('COMPANY', new_co_addr_rec_.company, lineattr_);
                  Client_SYS.Add_To_Attr('COUNTY', new_co_addr_rec_.county, lineattr_);
                  Client_SYS.Add_To_Attr('IN_CITY', new_co_addr_rec_.in_city, lineattr_);
                  Client_SYS.Add_To_Attr('ADDR_FLAG_DB', addr_flag_db_, lineattr_);
                  Cust_Order_Line_Address_API.Change_Address(lineattr_, order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
               END IF;
               IF(linerec_.supply_code IN ('IPD', 'IPT')) THEN
                  shpmnt_info_ := App_Context_SYS.Find_Value('CUSTOMER_ORDER_LINE_API.SHPMNT_INFO_');
               END IF;
            END IF; 
         END LOOP; 
      END IF; 
      IF (shpmnt_info_ IS NOT NULL) THEN
         Client_SYS.Add_Info(lu_name_, shpmnt_info_);
      END IF;  
      Modify_License_Address___(order_no_);
      
      IF NVL(Client_SYS.Get_Item_Value('POCO_AUTO', message_attr_), 'FALSE') = 'TRUE' THEN
         Client_SYS.Add_Info(lu_name_, 'CREATEPOCOAUTO: It is not allowed to directly update Purchase Order for some lines, so the changes need to be processed via a Purchase Order Change Order. New Change Orders are created for those Purchase Order lines.');
      END IF;
         
      IF NVL(Client_SYS.Get_Item_Value('INFO_ADDED', message_attr_), 'FALSE') = 'TRUE' THEN
         Client_SYS.Add_Info(lu_name_, 'PREL_DELNOTE: Preliminary Delivery Note is already created. IF the Delivery Note is already printed the delivery information needs to be updated manually.');
      END IF;

      IF NVL(Client_SYS.Get_Item_Value('LINE_DATE_CHANGED', message_attr_), 'FALSE') = 'TRUE' THEN
         Client_SYS.Add_Info(lu_name_, 'NONDEFLINEDATESCHANGED: Planned Delivery Date/Planned Ship Date has been changed on applicable non Default Info order lines.');
      END IF;

      IF NVL(Client_SYS.Get_Item_Value('LINE_DUE_DATE_CHANGED', message_attr_), 'FALSE') = 'TRUE' THEN
         Client_SYS.Add_Info(lu_name_, 'NONDEFEARLYLINEDUEDATE: The planned due date is earlier than today''s date in some non Default Info order lines.');
      END IF;
      info_ := info_ || Client_SYS.Get_All_Info;
      
   END IF;
END Modify__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Addr_1
--   Returns Addr_1
@UncheckedAccess
FUNCTION Get_Addr_1 (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.addr_1%TYPE;
   CURSOR get_attr IS
      SELECT addr_1
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE  order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Addr_1;


-- Get_Addr_2
--   Returns Addr_2
@UncheckedAccess
FUNCTION Get_Addr_2 (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.addr_2%TYPE;
   CURSOR get_attr IS
      SELECT addr_2
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE  order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Addr_2;


-- Get_Addr_3
--   Returns Addr_3
@UncheckedAccess
FUNCTION Get_Addr_3 (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.addr_3%TYPE;
   CURSOR get_attr IS
      SELECT addr_3
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE  order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Addr_3;


-- Get_Addr_4
--   Returns Addr_4
@UncheckedAccess
FUNCTION Get_Addr_4 (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.addr_4%TYPE;
   CURSOR get_attr IS
      SELECT addr_4
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE  order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Addr_4;


-- Get_Addr_5
--   Returns Addr_5
@UncheckedAccess
FUNCTION Get_Addr_5 (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.addr_5%TYPE;
   CURSOR get_attr IS
      SELECT addr_5
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE  order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Addr_5;


-- Get_Addr_6
--   Returns Addr_6
@UncheckedAccess
FUNCTION Get_Addr_6 (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.addr_6%TYPE;
   CURSOR get_attr IS
      SELECT addr_6
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE  order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Addr_6;


-- Get_Address1
--   Returns address1
@UncheckedAccess
FUNCTION Get_Address1 (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.address1%TYPE;
   CURSOR get_attr IS
      SELECT address1
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address1;


-- Get_Address2
--   Returns address2
@UncheckedAccess
FUNCTION Get_Address2 (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.address2%TYPE;
   CURSOR get_attr IS
      SELECT address2
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address2;

@UncheckedAccess
FUNCTION Get_Address3 (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.address3%TYPE;
   CURSOR get_attr IS
      SELECT address3
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address3;

@UncheckedAccess
FUNCTION Get_Address4 (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.address4%TYPE;
   CURSOR get_attr IS
      SELECT address4
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address4;

@UncheckedAccess
FUNCTION Get_Address5 (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.address5%TYPE;
   CURSOR get_attr IS
      SELECT address5
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address5;

@UncheckedAccess
FUNCTION Get_Address6 (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.address6%TYPE;
   CURSOR get_attr IS
      SELECT address6
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address6;


FUNCTION Get_Address_Name (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_            VARCHAR2(100);
   CURSOR get_attr IS
      SELECT addr_1
      FROM CUSTOMER_ORDER_ADDRESS_TAB
      WHERE order_no = order_no_;
BEGIN
   IF (line_no_ IS NOT NULL AND rel_no_ IS NOT NULL AND line_item_no_ IS NOT NULL ) THEN 
      temp_ := Cust_Order_Line_Address_API.Get_Addr_1(order_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Address_Name;


-- Get_Zip_Code
--   Returns zip_code
@UncheckedAccess
FUNCTION Get_Zip_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.zip_code%TYPE;
   CURSOR get_attr IS
      SELECT zip_code
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Zip_Code;


-- Get_City
--   Returns city
@UncheckedAccess
FUNCTION Get_City (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.city%TYPE;
   CURSOR get_attr IS
      SELECT city
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_City;


-- Get_State
--   Returns state
@UncheckedAccess
FUNCTION Get_State (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.state%TYPE;
   CURSOR get_attr IS
      SELECT state
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_State;


@UncheckedAccess
FUNCTION Get_County (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.county%TYPE;
   CURSOR get_attr IS
      SELECT county
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_County;


@UncheckedAccess
FUNCTION Get_In_City (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.in_city%TYPE;
   CURSOR get_attr IS
      SELECT in_city
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_In_City;


-- Get_Country_Code
--   Returns country_code
@UncheckedAccess
FUNCTION Get_Country_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.country_code%TYPE;
   CURSOR get_attr IS
      SELECT country_code
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Country_Code;


-- Get_Address_Country_Code
--   Fetches country_code from the table.
@UncheckedAccess
FUNCTION Get_Address_Country_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_TAB.country_code%TYPE;
   CURSOR get_attr IS
      SELECT country_code
      FROM CUSTOMER_ORDER_ADDRESS_TAB
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address_Country_Code;


@UncheckedAccess
FUNCTION Get_Company (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.company%TYPE;
   CURSOR get_attr IS
      SELECT company
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Company;


@UncheckedAccess
FUNCTION Get_Vat_Free_Vat_Code (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_ADDRESS_2.vat_free_vat_code%TYPE;
   CURSOR get_attr IS
      SELECT vat_free_vat_code
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Vat_Free_Vat_Code;


-- New
--   Create a new record
--   Create a new single occurance address
PROCEDURE New (
   order_no_     IN VARCHAR2,
   addr_1_       IN VARCHAR2,
   address1_     IN VARCHAR2,
   address2_     IN VARCHAR2,
   address3_     IN VARCHAR2,
   address4_     IN VARCHAR2,
   address5_     IN VARCHAR2,
   address6_     IN VARCHAR2,
   zip_code_     IN VARCHAR2,
   city_         IN VARCHAR2,
   state_        IN VARCHAR2,
   county_       IN VARCHAR2,
   country_code_ IN VARCHAR2,
   in_city_      IN VARCHAR2,
   vat_free_vat_code_ IN VARCHAR2)
IS
   newrec_     CUSTOMER_ORDER_ADDRESS_TAB%ROWTYPE;
BEGIN
   newrec_.order_no := order_no_;
   newrec_.addr_1 := addr_1_;
   newrec_.address1 := address1_;
   newrec_.address2 := address2_;
   newrec_.address3 := address3_;
   newrec_.address4 := address4_;
   newrec_.address5 := address5_;
   newrec_.address6 := address6_;
   newrec_.zip_code := zip_code_;
   newrec_.city := city_;
   newrec_.state := state_;
   newrec_.county := county_;
   newrec_.country_code := country_code_;
   newrec_.in_city := in_city_;
   newrec_.vat_free_vat_code := vat_free_vat_code_;
   New___(newrec_);  
END New;


-- Modify
--   Modify a single occurance address
PROCEDURE Modify (
   order_no_     IN VARCHAR2,
   addr_1_       IN VARCHAR2,
   address1_     IN VARCHAR2,
   address2_     IN VARCHAR2,
   address3_     IN VARCHAR2,
   address4_     IN VARCHAR2,
   address5_     IN VARCHAR2,
   address6_     IN VARCHAR2,
   zip_code_     IN VARCHAR2,
   city_         IN VARCHAR2,
   state_        IN VARCHAR2,
   county_       IN VARCHAR2,
   country_code_ IN VARCHAR2,
   in_city_      IN VARCHAR2)
IS
   newrec_     CUSTOMER_ORDER_ADDRESS_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(order_no_);
   newrec_.addr_1 := addr_1_;
   newrec_.address1 := address1_;
   newrec_.address2 := address2_;
   newrec_.address3 := address3_;
   newrec_.address4 := address4_;
   newrec_.address5 := address5_;
   newrec_.address6 := address6_;
   newrec_.zip_code := zip_code_;
   newrec_.city := city_;
   newrec_.state := state_;
   newrec_.county := county_;
   newrec_.country_code := country_code_;
   IF in_city_ IS NOT NULL THEN
      newrec_.in_city := in_city_;
   END IF;   
   Modify___(newrec_);
END Modify;


-- Remove
--   Remove a single occurance address
PROCEDURE Remove (
   order_no_     IN VARCHAR2 )
IS
   remrec_     CUSTOMER_ORDER_ADDRESS_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(order_no_);
   Check_Delete___(remrec_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
   Delete___(objid_, remrec_);
END Remove;


@UncheckedAccess
FUNCTION Get_Cust_Ord_Addr (
   order_no_ IN VARCHAR2 ) RETURN Cust_Ord_Addr_Rec
IS
   temp_ Cust_Ord_Addr_Rec;
   CURSOR get_attr IS
      SELECT addr_1, addr_2, addr_3, addr_4, addr_5, addr_6, country_code, ship_addr_no, addr_flag_db addr_flag, address1, address2,address3,address4,address5,address6, zip_code, city, state, county, in_city,company, vat_free_vat_code
      FROM CUSTOMER_ORDER_ADDRESS_2
      WHERE order_no = order_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Cust_Ord_Addr;



