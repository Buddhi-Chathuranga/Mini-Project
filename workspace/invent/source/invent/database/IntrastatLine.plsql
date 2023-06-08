-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatLine
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220120  ErFelk  Bug 161243(FI21R2-6364), Modified Check_Insert___() by adding logic to fetch opponent tax id for Italy. This is a merge from GET. 
--  220113  ErFelk  Bug 161265(SC21R2-6817), Modified Check_Insert___() to get the opponent tax id from deliver to customer if demand code is IPD and country codes are 
--  220113          different between internal customer and deliver to customer. 
--  220110  ErRalk  SC21R2-6682, Modified Check_Insert___ by including shipment del_terms_location for supplier return.
--  211209  ErFelk  Bug 161021(SC21R2-6450), Modified Check_Update___() By removing notc 29, 31, 32, 33 from a condition to trigger error messages.
--  211104  ErFelk  Bug 161107(SC21R2-4958), Modified Check_Insert___() to get the opponent tax id from the company when opponent type is COMPANY. Also opponent tax id was fetched 
--  211104          for PD-SHIP transaction which is getting created for PROJECT_DELIVERABLES.
--  200831  SBalLK  GESPRING20-537, Modified Check_Insert___()Check_Insert___, Check_Update___() and New_Intrastat_Line() methods and added Validate_Italy_Intra_Data___(),
--  200831          Check_Service_Statistical_Code_Ref___(), Advance_Trans_For_Order_Exists() methods to enable italy intrastat localization.
--  200710  ErFelk  Bug 147354(SCZ-5560), Modified Check_Insert___() by changing a condition, so that opponent_tax_id is fetched for all countries.
--  200213  ApWilk  Bug 145769 (SCZ-2219), Modified Check_Insert___() by assigning value for opponent_tax_id if country is Hungary.
--  200206  ApWilk  Bug 147188 (SCZ-3428), Modified Check_Insert___() by assigning value for opponent_tax_id if country is Portugal.
--  200107  ApWilk  Bug 145333, Handled an error message to be informed the user if entered a movement code without having a value for the site.
--  200107  ErFelk  Bug 145333, Added new procedure Consolidate_Intrastat_Lines().
--  191218  ErFelk  Bug 150820(SCZ-7228), Modified Check_Insert___() by assigning value for opponent_tax_id if country is Luxenbourg(LU). 
--  191203  ErFelk  Bug 147442(SCZ-4060), Modified Check_Update___() by allowing info messages ORDERUNITPRICE and INVOICEDUNITPRICEZERO to be raised when the direction is EXPORT and IMPORT. 
--  190507  ErFelk  Bug 145499(SCZ-2992), Modified Check_Insert___() by assigning value for opponent_tax_id if country is Belgium. 
--  171204  ErFelk  Bug 135151, Modified Check_Insert___() by assigning opponent_tax_id with values if the country is Polish. 
--  171011  ErFelk  Bug 137492, Modified Check_Update___() by adding info messages ORDERUNITPRICE and INVOICEDUNITPRICEZERO when country_code_ is DE. 
--  170420  NiLalk  Bug 134708, Modified Check_Insert___() by passing value to the opponent_tax_id from the CO line or CO header or Customer's 
--  170420          Document tax information in a hierarchical order.
--  160420  JanWse  STRSC-1785, Added TRUE to also check for blocked in a call to Scrapping_Cause_API.Exist
--  151120  IsSalk  FINHR-327, Renamed attribute VAT_NO to TAX_ID_NO in Customer Order.
--  151111  PrYaLK  Bug 121643, Modified Check_Insert___() by adding new column opponent_tax_id.
--  151026  PrYaLK  Bug 124575, Modified Check_Insert___() and Check_Update___() by adding new columns del_terms_location and place_of_delivery
--  151026          for the country Slovenia.
--  150810  SBalLK  Bug 123739, Modified New_Intrastat_Line() method to avoid pack and unpack attr when inserting new record and
--  150810          changed method parameter names to identify DB values among the client values. 
--  150727  IsSalk  KES-1123, Modified Get_Co_Line_Conn_Intrastat_Id() to get connected Intrastat ID of a CO line delivery. 
--  150624  IsSalk  KES-656, Added Get_Co_Line_Conn_Intrastat_Id() to get connected Intrastat ID of a CO line.
--  130725  IsSalk  Bug 107531, Added column UNIT_STATISTICAL_CHARGE_DIFF and modified Unpack_Check_Insert__, Unpack_Check_Update__, Insert___, Update___
--  130725          and New_Intrastat_Line methods to store the domestic charges for import transactions and to store receiving country charges for 
--  130725          export transactions which is using when calculating Statistical value.
--  130515  IsSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  120629  ChFolk  Modified View to increased the length of customs_stat_no to VARCHAR2(15).
--  120210  TiRalk  Bug 100825, Added movement_code to New_Intrastat_Line for county CZ.
--  120410  AyAmlk  Bug 100608, Increased the column length of delivery_terms to 5 in view INTRASTAT_LINE.
--  110409  RoJalk  Bug 101284, Added new parameter opponent_type_ to method New_Intrastat_Line to clarify the type of opponent 
--  110308          to fetch the opponent document address country code when generating intrastat file for country IT.
--  120309  MalLlk  Modified Check_Transaction_Id___ to compile the method call 
--  120309          Purchase_Transaction_Hist_API.Exist conditionally. 
--  120131  MaEelk  Modified view comments of country_code. 
--  111215  GanNLK  In the insert__ procedure, moved objversion_ to the bottom of the procedure.
--  111118  MaEelk  Modified Unpack_Check_Insert___ and made a check to add only user allowed sites to the intrastat line.
--  110804  TiRalk  Bug 97374, Modified Unpack_Check_Insert___, Unpack_Check_Update___ by adding condition
--  110804          to avoid method call when transaction_id is NULL.
--  110721  MaEelk  Return_Cause_API.Exist and Return_Material_Reason_API.Exist were made dynamic.
--  110707  PraWlk  Bug 95295, Added attributes return_material_reason and return_reason to IntrastatLine LU. 
--  110428  TiRalk  Bug 95518, Added Check_Transaction_Id___ and Modified Unpack_Check_Insert___, Unpack_Check_Update___ 
--  110428          by calling newly added method to validate transaction_id considering non inventory purchase parts
--  110428          and no parts transactions also. Removed LOV reference from transaction_id view comment.
--  100602  LARELK  Changed reference to Iso_Country insteard from Application_country. Replaced Application_country
--  100602          usage with Iso_country in Unpack_Check_Insert__, Unpack_Check_Update__. 
--  100511  KRPELK  Merge Rose Method Documentation.
--  090930  ChFolk  Removed unused variables in the package.
--  ------------------------------ 14.0.0 -----------------------------------
--  090216  MalLlk  Bug 80014, Added function Get_Customs_Stat_No_Desc to get the translated
--  090216          Customs Statistics Number description.
--  081027  NWeelk  Bug 77889, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ 
--  081027          by increasing the length of the variable receiver_ to 50.
--  080417  Prawlk  Bug 72795, Added code for the validation of Inventory Direction in Unpack_Check_Insert___
--  080417          and Unpack_Check_Update___.
--  060911  ChBalk  Bug 53157, Added private attribute 'county' to the LU and added new
--  060911          parameter 'county_' to method New_Intrastat_Line.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060601  RoJalk  Enlarge Part Description - Changed view comments.
--  ----------------------------------13.4.0---------------------------------
--  060118  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  050712  HaPulk  Removed Hint 'INDEX(INTRASTAT_LINE_TAB INTRASTAT_LINE_PK)' in method Insert___.
--  050407  SeJalk  Bug 47761, Changed Region_Of_Origin_API to Country_Region_API in
--                  Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040721  ChFolk  Bug 45865, Added new parameter intrastat_id into First_Receipt_Exist.
--  040720  ChFolk  Bug 45865, Added function First_Receipt_Exist.
--  040301  GeKalk  Removed substrb from the view for UNICODE modifications.
--  ------------------------------- 13.3.0 ------------------------------------
--  031219  ANLASE  Bug fix 40483. Added check for header status in Check_Delete___.
--  030820  KiSalk  ***************** CR Merge End ***************************
--  030326  SeKalk  Replaced Site_Delivery_Address_API with Company_Address_API
--  030820  KiSalk  ***************** CR Merge Start *************************
--  020919  LEPESE  ***************** IceAge Merge Start *********************
--  020619  DaZa    Bug 30248, added new attribute region_of_origin in view
--                  and methods including New_Intrastat_Line.
--  020919  LEPESE  ***************** IceAge Merge End ***********************
--  020524  NASALK  Extended serial_no length from VARCHAR2(15) to VARCHAR2(50) in view comments
--  010320  MaGu    Added restriction for update and insert when header is in status
--                  Processing in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  010319  MaGu    Changed length on variable in error message in Unpack_Check_Insert___.
--                  Changed value in check of header status from 'Closed' to 'Cancelled'
--                  in Unpack_Check_Insert___. Also modified setting of triangulation_db in
--                  method New_Intrastat_Line.
--  010316  ANLASE  Removed global variable g_eu_member_ to avoid translation problems.
--                  Modified checks for reject code in Unpack_Check_Insert___ and Unpack_Check_Update___.
--                  Added hint for index in Insert___.
--  010309  ANLASE  Added global variable g_eu_member_.
--  010306  ANLASE  Added check for print flags in unpack_check_update.
--  010305  ANLASE  Added check for EU-countries in unpack_check_update___ and unpack_check_insert___.
--  010302  ErFi    Added Get_Notc___, modifed Unpack_Check_Insert___ and
--                  Unpack_Check_Update___ to get the detailed notc.
--                  Modified INTRASTAT_LINE to include country_notc and country_code
--  010228  ANLASE  Modified insert for date_applied and userid in prepare insert and unpack_check_insert___.
--  010227  ANLASE  Added reference for country_of_origin, opposite_country, notc and delivery_terms.
--  010227  ANLASE  Changed to datatype number for net_unit_weight_. Added value for net_unit_weight in New_Intrastat_Line.
--  010223  ANLASE  Added references for contract, unit_meas, reject_code and intrastat_alt_unit_meas.
--  010221  ANLASE  Added restrictions for update in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  010220  ANLASE  Added default for date_applied in Unpack_Check_Insert___.
--  010219  ANLASE  Added part_description in method New_Intrastat_Line.
--  010215  ANLASE  Added default values for intrastat_origin and triangulation.
--                  Added attribute part_description.
--  010214  ANLASE  Added cascade for Intrastat_Id in viewcomments.
--                  Made intrastat_alt_unit_meas non mandatory.
--  010213  ANLASE  Created. Added undefines
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Do_Cancel___ (
   rec_  IN OUT INTRASTAT_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   NULL;
END Do_Cancel___;


-- Get_Notc___
--   Returns detailed Notc if the line was created manually or modified
PROCEDURE Get_Notc___ (
   notc_             OUT VARCHAR2,
   intrastat_id_     IN  NUMBER,
   country_notc_     IN  VARCHAR2,
   intrastat_origin_ IN  VARCHAR2 )
IS
BEGIN
   -- Only get the detailed notc if this line was created manually or modifed
   Trace_SYS.Message('Intrastat origin '||intrastat_origin_);
   Trace_SYS.Message('country notc '||country_notc_);
   IF intrastat_origin_ = 'MANUAL' THEN
      notc_ := Country_Notc_API.Get_Notc(Intrastat_API.Get_Country_Code(intrastat_id_),
                                         country_notc_);
   ELSE
      notc_ := country_notc_;
   END IF;
END Get_Notc___;


PROCEDURE Check_Transaction_Id___ (
   transaction_id_   IN NUMBER,
   transaction_code_ IN VARCHAR2 )
IS
   trancode_rec_ Mpccom_Transaction_Code_API.Public_Rec;  
BEGIN
   trancode_rec_ := Mpccom_Transaction_Code_API.Get(transaction_code_);

   IF (trancode_rec_.transaction_source = 'PURCHASE') THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         Purchase_Transaction_Hist_API.Exist(transaction_id_);
      $ELSE
         NULL;
      $END
   ELSE
      Inventory_Transaction_Hist_API.Exist(transaction_id_);
   END IF;

END Check_Transaction_Id___;

PROCEDURE Check_Movement_Code_Ref___ (
   newrec_ IN OUT NOCOPY intrastat_line_tab%ROWTYPE )
IS
   receiver_     VARCHAR2(50);
   country_code_ VARCHAR2(3);   
BEGIN
   receiver_ := Site_API.Get_Delivery_Address(newrec_.contract);
   country_code_ := ISO_Country_API.Encode(Company_Address_API.Get_Country(Site_API.Get_Company(newrec_.contract), receiver_));
   Special_Code_Of_Movement_API.Exist(country_code_, newrec_.movement_code);
END Check_Movement_Code_Ref___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('TRIANGULATION_DB','NO TRIANGULATION',attr_);
   Client_SYS.Add_To_Attr('STATISTICAL_PROCEDURE', Statistical_Procedure_API.Decode('DELIVERY'), attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_ORIGIN', Intrastat_Origin_API.Decode('MANUAL'), attr_);
   Client_SYS.Add_To_Attr('DATE_APPLIED', Site_API.Get_Site_Date(User_Allowed_Site_API.Get_Default_Site), attr_);
   Client_SYS.Add_To_Attr('USERID', Fnd_Session_API.Get_Fnd_User, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INTRASTAT_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_new_line_no(intrastat_id_ NUMBER) IS
      SELECT NVL(MAX(line_no), 0) + 1
        FROM intrastat_line_tab
       WHERE intrastat_id = intrastat_id_;
BEGIN
   --generate new line no
   OPEN get_new_line_no(newrec_.intrastat_id);
   FETCH get_new_line_no INTO newrec_.line_no;
   CLOSE get_new_line_no;

   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', newrec_.line_no, attr_ );
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN INTRASTAT_LINE_TAB%ROWTYPE )
IS
   head_state_ VARCHAR2(20);
BEGIN
   head_state_ := Intrastat_API.Get_Objstate(remrec_.intrastat_id);
   IF (head_state_ IN ('Confirmed', 'Cancelled')) THEN
      Error_SYS.Record_General(lu_name_, 'NODELHEAD: Lines can not be removed when the intrastat header is in status Confirmed or Cancelled.');
   ELSIF (head_state_ = 'Processing') THEN
      Error_SYS.Record_General(lu_name_, 'NODELHEAD2: Lines can not be removed when the intrastat header is in status Processing.');
   END IF;
   super(remrec_);
END Check_Delete___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT intrastat_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_            VARCHAR2(30);
   value_           VARCHAR2(4000);

   intrastat_rec_   Intrastat_API.Public_Rec;
   receiver_        VARCHAR2(50);
   country_code_    VARCHAR2(3);      
   address_id_      VARCHAR2(50);   
   
   $IF (Component_Order_SYS.INSTALLED) $THEN
      co_line_rec_  Customer_Order_Line_API.Public_Rec;
      rma_line_     Return_Material_Line_API.Public_Rec;
   $END
   $IF Component_Purch_SYS.INSTALLED $THEN
      pur_trans_hist_rec_    Purchase_Transaction_Hist_API.Public_Rec;
   $END
   inv_trans_hist_rec_    Inventory_Transaction_Hist_API.Public_Rec;
BEGIN
   intrastat_rec_ := Intrastat_API.Get(newrec_.intrastat_id);
   IF intrastat_rec_.rowstate IN ('Confirmed', 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'NOT_ALLOWED: No new lines allowed when intrastat header is in status Confirmed or Cancelled');
   END IF;
   
   IF((newrec_.contract IS NULL) AND (newrec_.movement_code IS NOT NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'SITENOTENTERED: Value for site is required before inserting the movement code');
   END IF;
   
   -- gelr:italy_intrastat, start
   IF (newrec_.adjust_to_prev_intrastat IS NULL) THEN
      newrec_.adjust_to_prev_intrastat :=  Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (newrec_.advance_transaction IS NULL) THEN
      newrec_.advance_transaction := Fnd_Boolean_API.DB_FALSE;
   END IF;
   -- gelr:italy_intrastat, end
   
   Get_Notc___(newrec_.notc, newrec_.intrastat_id, newrec_.notc,
               newrec_.intrastat_origin);

   super(newrec_, indrec_, attr_);

   IF (newrec_.order_type = Order_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         IF (newrec_.order_ref1 IS NOT NULL) THEN
            co_line_rec_ := Customer_Order_Line_API.Get(newrec_.order_ref1, newrec_.order_ref2, newrec_.order_ref3, newrec_.order_ref4);
            IF (intrastat_rec_.country_code = 'SI') THEN
               newrec_.del_terms_location := co_line_rec_.del_terms_location;
            END IF;
            IF (newrec_.intrastat_direction = 'EXPORT') THEN   
               newrec_.opponent_tax_id := co_line_rec_.tax_id_no;              
            
               IF (co_line_rec_.demand_code = 'IPD' ) AND (Customer_Info_API.Get_Country_Db(co_line_rec_.customer_no) != Customer_Info_API.Get_Country_Db(co_line_rec_.deliver_to_customer_no)) THEN
                     newrec_.opponent_tax_id := co_line_rec_.tax_id_no;
               ELSE
                  IF (newrec_.opponent_tax_id IS NULL) THEN                     
                     newrec_.opponent_tax_id := Customer_Order_API.Get_Tax_Id_No(newrec_.order_ref1);
                  END IF;
               END IF;               
            END IF;
         END IF;
      $ELSE
         NULL;
         -- Order component is not installed.
      $END
   END IF;

   IF (newrec_.order_type = Order_Type_API.DB_PURCHASE_ORDER) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         IF(newrec_.order_ref1 IS NOT NULL) THEN 
            IF (intrastat_rec_.country_code='SI') THEN
               inv_trans_hist_rec_ := Inventory_Transaction_Hist_API.Get(newrec_.transaction_id);
               pur_trans_hist_rec_ := Purchase_Transaction_Hist_API.Get(newrec_.transaction_id);
               IF (inv_trans_hist_rec_.alt_source_ref_type  = Order_Type_API.DB_PURCH_RECEIPT_RETURN) OR
                  (Inventory_Transaction_Hist_API.Get_Alt_Source_Ref_Type_Db(inv_trans_hist_rec_.original_transaction_id)  = Order_Type_API.DB_PURCH_RECEIPT_RETURN) OR
                  (pur_trans_hist_rec_.alt_source_ref_type = Order_Type_API.DB_PURCH_RECEIPT_RETURN)OR
                  (Purchase_Transaction_Hist_API.Get_Alt_Source_Ref_Type_Db(pur_trans_hist_rec_.original_transaction_id)  = Order_Type_API.DB_PURCH_RECEIPT_RETURN) THEN                 
                  $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
                     newrec_.del_terms_location := Shipment_API.Get_Del_Terms_Location(newrec_.order_ref1);
                  $ELSE
                     NULL;
                  $END
               ELSE 
                  newrec_.del_terms_location := Purchase_Order_Line_API.Get_Del_Terms_Location(newrec_.order_ref1, newrec_.order_ref2, newrec_.order_ref3);
               END IF;
            END IF;
            IF (newrec_.intrastat_direction = 'EXPORT') THEN
               $IF Component_Invoic_SYS.INSTALLED $THEN
                  newrec_.opponent_tax_id := Supplier_Document_Tax_Info_API.Get_Vat_No(newrec_.opponent_number, Purchase_Order_API.Get_Doc_Addr_No(newrec_.order_ref1), intrastat_rec_.company);                 
               $ELSE               
                  NULL;
                  -- Invoic component is not installed.               
               $END
            END IF;            
         END IF;
      $ELSE
         NULL;
         -- Purch component is not installed.
      $END
   END IF; 
   
   IF (newrec_.order_type = Order_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         IF (newrec_.order_ref1 IS NOT NULL) THEN
            IF (newrec_.intrastat_direction = 'EXPORT') THEN                
               $IF Component_Order_SYS.INSTALLED $THEN
                  newrec_.opponent_tax_id := Customer_Document_Tax_Info_API.Get_Vat_No(newrec_.opponent_number, 
                                                                                       Cust_Ord_Customer_API.Get_Document_Address(newrec_.opponent_number), 
                                                                                       Intrastat_API.Get_Company(newrec_.intrastat_id), 
                                                                                       Iso_Country_API.Decode(Intrastat_API.Get_Country_Code(newrec_.intrastat_id)), 
                                                                                       '*');
               $ELSE
                  NULL;
                  -- Order component is not installed.
               $END                                                                      
            END IF;   
         END IF;   
      $ELSE
         NULL;
         -- Prjdel component is not installed.
      $END
   END IF;  
   
   IF (newrec_.opponent_type = 'COMPANY') AND (newrec_.intrastat_direction = 'EXPORT') THEN
      $IF Component_Invoic_SYS.INSTALLED $THEN
         newrec_.opponent_tax_id := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(newrec_.opponent_number, newrec_.opposite_country, TRUNC(Intrastat_API.Get_To_Invoice_Date(newrec_.intrastat_id)));
      $ELSE               
         NULL;
         -- Invoic component is not installed.               
      $END
   END IF; 
   
   -- Italy, start
   IF (intrastat_rec_.country_code = 'IT') THEN
      IF(Company_Localization_Info_API.Get_Parameter_Value_Db(intrastat_rec_.company, 'ITALY_INTRASTAT') = Fnd_Boolean_API.DB_TRUE) THEN
         IF (newrec_.order_type = Order_Type_API.DB_RETURN_MTRL_AUTHORIZATION AND newrec_.intrastat_direction = 'EXPORT') THEN
            $IF Component_Order_SYS.INSTALLED $THEN
               rma_line_ := Return_Material_Line_API.Get(newrec_.order_ref1, newrec_.order_ref4);         
               newrec_.opponent_tax_id := Customer_Order_Line_API.Get_Tax_Id_No(rma_line_.order_no, rma_line_.line_no, rma_line_.rel_no, rma_line_.line_item_no);
               IF (newrec_.opponent_tax_id IS NULL) THEN
                  newrec_.opponent_tax_id := Customer_Order_API.Get_Tax_Id_No(rma_line_.order_no);
               END IF;
               country_code_ := Customer_Info_Address_API.Get_Country_Code(newrec_.opponent_number, Customer_Order_API.Get_Bill_Addr_No(rma_line_.order_no));         
            $ELSE
               NULL;
            $END
         ELSIF (newrec_.order_type = Order_Type_API.DB_PURCHASE_ORDER AND newrec_.intrastat_direction = 'IMPORT') THEN
            $IF (Component_Purch_SYS.INSTALLED AND Component_Invoic_SYS.INSTALLED) $THEN
               IF(newrec_.order_ref1 IS NOT NULL) THEN 
                  newrec_.opponent_tax_id := Supplier_Document_Tax_Info_API.Get_Vat_No(newrec_.opponent_number, Purchase_Order_API.Get_Doc_Addr_No(newrec_.order_ref1), intrastat_rec_.company);                 
               END IF;
               country_code_ := Supplier_Info_Address_API.Get_Country_Code(newrec_.opponent_number, Purchase_Order_API.Get_Doc_Addr_No(newrec_.order_ref1));         
            $ELSE
               NULL;
            $END
         END IF;
         $IF (Component_Invoic_SYS.INSTALLED) $THEN
         IF (newrec_.opponent_tax_id IS NULL) THEN
            IF (newrec_.opponent_type = 'SUPPLIER') THEN
               address_id_ := Supplier_Info_Address_API.Get_Default_Address(newrec_.opponent_number, Address_Type_Code_API.Decode('INVOICE'));
               newrec_.opponent_tax_id := Supplier_Document_Tax_Info_API.Get_Vat_No(newrec_.opponent_number, 
                                                                                    address_id_, 
                                                                                    intrastat_rec_.company);
               country_code_ := Supplier_Info_Address_API.Get_Country_Code(newrec_.opponent_number, address_id_);         
            ELSIF (newrec_.opponent_type = 'CUSTOMER') THEN
               address_id_ := Customer_Info_Address_API.Get_Default_Address(newrec_.opponent_number, Address_Type_Code_API.Decode('INVOICE')); 
               newrec_.opponent_tax_id := Customer_Document_Tax_Info_API.Get_Vat_No_Db(newrec_.opponent_number, 
                                                                                       address_id_, 
                                                                                       intrastat_rec_.company,
                                                                                       intrastat_rec_.country_code,
                                                                                       Customer_Info_Address_API.Get_Delivery_Country_Db(newrec_.opponent_number));
               country_code_ := Customer_Info_Address_API.Get_Country_Code(newrec_.opponent_number, address_id_);
            ELSE
            -- Company 
               newrec_.opponent_tax_id := Tax_Liability_Countries_API.Get_Tax_Id_Number_Db(newrec_.opponent_number, newrec_.opposite_country, TRUNC(intrastat_rec_.to_invoice_date));
               country_code_ := Company_Address_API.Get_Country_Db(newrec_.opponent_number, Company_Address_API.Get_Default_Address(newrec_.opponent_number, Address_Type_Code_API.Decode('INVOICE')));
            END IF;   
         END IF;   
         $END

         IF (newrec_.order_type = Order_Type_API.DB_CUSTOMER_ORDER AND newrec_.intrastat_direction = 'EXPORT') THEN
            $IF Component_Order_SYS.INSTALLED $THEN
               country_code_ := Customer_Info_Address_API.Get_Country_Code(newrec_.opponent_number, Customer_Order_API.Get_Bill_Addr_No(newrec_.order_ref1));
            $ELSE
               NULL;
            $END
         ELSIF (newrec_.opponent_type = 'COMPANY') AND (newrec_.intrastat_direction = 'EXPORT') THEN
            country_code_ := Company_Address_API.Get_Country_Db(newrec_.opponent_number, Company_Address_API.Get_Default_Address(newrec_.opponent_number, Address_Type_Code_API.Decode('INVOICE')));
         END IF; 

         IF (NVL(country_code_, 'XX') = 'IT' AND SUBSTR(newrec_.opponent_tax_id,1,2) != 'IT') THEN
            newrec_.opponent_tax_id := 'IT'||newrec_.opponent_tax_id;
         END IF;
      END IF;
   END IF;   
   -- Italy, end
   
   IF (newrec_.contract IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,newrec_.contract);
   END IF;
   
   IF newrec_.intrastat_origin = 'MANUAL' AND newrec_.reject_code IS NOT NULL THEN
      Scrapping_Cause_API.Exist(newrec_.reject_code, TRUE);
   END IF;

   --checking EU-country for manually inserted lines
   IF newrec_.intrastat_origin ='MANUAL' AND EU_Member_Api.Encode(Iso_Country_API.Get_Eu_Member(newrec_.opposite_country)) != 'Y' THEN
      Error_SYS.Record_General(lu_name_,'NOEUCOUNTRY: :P1 is not a EU-country.', Iso_Country_API.Get_Description(newrec_.opposite_country));
   END IF;

   IF (intrastat_rec_.rowstate = 'Processing') THEN
      IF (newrec_.intrastat_origin = 'MANUAL') THEN
         Error_SYS.Record_General(lu_name_,'NO_NEW_LINE: No new lines allowed when intrastat header is in status Processing');
      END IF;
   END IF;

   receiver_ := Site_API.Get_Delivery_Address(newrec_.contract);
   country_code_ := ISO_Country_API.Encode(Company_Address_API.Get_Country(Site_API.Get_Company(newrec_.contract), receiver_));
   
   IF (newrec_.region_of_origin IS NOT NULL) THEN
      IF (country_code_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_,'NORECEIVCOUNTRY: Site receiver :P1 must have a country code.', receiver_ );
      ELSE
         Country_Region_API.Exist(country_code_, newrec_.region_of_origin);
      END IF;
   END IF;
   
   IF country_code_ = 'CZ' THEN
      newrec_.movement_code := 'ST';
   END IF;

   IF (newrec_.place_of_delivery IS NOT NULL) THEN
      IF (newrec_.place_of_delivery NOT IN ('1','2','3')) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDPLACEOFDEL: The value for the place of delivery can only be 1, 2 or 3.');
      END IF;
   END IF;

   IF (newrec_.inventory_direction IS NOT NULL) THEN
      IF (newrec_.inventory_direction NOT IN ('0','-','+')) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDINVDIR: The direction of an inventory transaction can only be 0, + or -.');
      END IF;
   END IF;
   
   IF newrec_.transaction_id IS NOT NULL THEN
      Check_Transaction_Id___(newrec_.transaction_id, newrec_.transaction);
   END IF;
   
   -- gelr:italy_intrastat, start
   Validate_Italy_Intra_Data___(newrec_, indrec_);
   -- gelr:italy_intrastat, end
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     intrastat_line_tab%ROWTYPE,
   newrec_ IN OUT intrastat_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                VARCHAR2(30);
   value_               VARCHAR2(4000);
   head_state_          VARCHAR2(20);
   receiver_            VARCHAR2(50);
   country_code_        VARCHAR2(3);
BEGIN
   --any modification to an automatically generated line will change intrastat_origin and userid.
   Client_SYS.Add_To_Attr('INTRASTAT_ORIGIN_DB', 'MANUAL', attr_);
         
   newrec_.userid := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('USERID', newrec_.userid, attr_);   

   -- Update is always done using origin 'MANUAL'
   IF (Validate_SYS.Is_Changed(oldrec_.notc, newrec_.notc))THEN
      Get_Notc___(newrec_.notc, newrec_.intrastat_id, newrec_.notc,
                  'MANUAL');
   END IF;
   
   IF ((newrec_.reject_code IS NOT NULL) AND (Validate_SYS.Is_Changed(oldrec_.reject_code, newrec_.reject_code))) THEN
      Scrapping_Cause_API.Exist(newrec_.reject_code, TRUE);
   END IF;

   super(oldrec_, newrec_, indrec_, attr_);

   receiver_ := Site_API.Get_Delivery_Address(newrec_.contract);
   country_code_ := ISO_Country_API.Encode(Company_Address_API.Get_Country(Site_API.Get_Company(newrec_.contract), receiver_));

   --checking eu-country
   IF EU_Member_Api.Encode(Iso_Country_API.Get_Eu_Member(newrec_.opposite_country)) != 'Y'  THEN
      Error_SYS.Record_General(lu_name_,'NOEUCOUNTRY: :P1 is not a EU-country.', Iso_Country_API.Get_Description(newrec_.opposite_country));
   END IF;

   IF (newrec_.region_of_origin IS NOT NULL) THEN
      IF (country_code_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_,'NORECEIVCOUNTRY: Site receiver :P1 must have a country code.', receiver_ );
      ELSE
         Country_Region_API.Exist(country_code_, newrec_.region_of_origin);
      END IF;
   END IF;

   IF newrec_.rowstate IN ('Cancelled') THEN
      Error_SYS.Record_General(lu_name_,'NOUPDLINE: An intrastat line in status Cancelled can not be modified.');
   END IF;

   --checking whether the intrastat header is processing, confirmed or closed
   head_state_ := Intrastat_API.Get_Objstate(newrec_.intrastat_id);
   IF (head_state_ IN ('Confirmed', 'Cancelled')) THEN
      Error_SYS.Record_General(lu_name_, 'NOUPDHEAD: Lines can not be modified when the intrastat header is in status Confirmed or Cancelled.');
   ELSIF (head_state_ = 'Processing') THEN
      Error_SYS.Record_General(lu_name_, 'NOUPDHEAD2: Lines can not be modified when the intrastat header is in status Processing.');
   END IF;

   IF ((Validate_SYS.Is_Changed(oldrec_.place_of_delivery, newrec_.place_of_delivery)) AND
       (newrec_.place_of_delivery IS NOT NULL)) THEN
      IF (newrec_.place_of_delivery NOT IN ('1','2','3')) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDPLACEOFDEL: The value for the place of delivery can only be 1, 2 or 3.');
      END IF;
   END IF;

   IF ((Validate_SYS.Is_Changed(oldrec_.inventory_direction, newrec_.inventory_direction)) AND 
       (newrec_.inventory_direction IS NOT NULL)) THEN
      IF (newrec_.inventory_direction NOT IN ('0','-','+')) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDINVDIR: The direction of an inventory transaction can only be 0, + or -.');
      END IF;
   END IF;
   
   IF newrec_.transaction_id IS NOT NULL THEN
      Check_Transaction_Id___(newrec_.transaction_id, newrec_.transaction);
   END IF;

   country_code_ := Intrastat_API.Get_Country_Code(newrec_.intrastat_id);
   IF country_code_ = 'IT' THEN
      IF newrec_.opponent_number IS NULL THEN
         newrec_.opponent_type := NULL;
      ELSIF newrec_.opponent_type IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOOPPTYPE: Opponent type must be specified.');
      END IF;
   END IF;
   
   IF (country_code_ = 'DE') THEN      
      IF ((Validate_SYS.Is_Changed(oldrec_.notc, newrec_.notc) OR 
           Validate_SYS.Is_Changed(oldrec_.order_unit_price, newrec_.order_unit_price) OR
           Validate_SYS.Is_Changed(oldrec_.invoiced_unit_price, newrec_.invoiced_unit_price)) AND 
          (newrec_.notc IN (22,23,34))) THEN
         IF (newrec_.order_unit_price = 0) THEN
            Client_SYS.Add_Info(lu_name_, 'ORDERUNITPRICE: Net Price/Base cannot be zero for Intrastat Line No :P1 having NOTC :P2.', newrec_.line_no, newrec_.notc); 
         END IF;
         IF ((newrec_.invoiced_unit_price !=0) OR (newrec_.invoiced_unit_price IS NULL)) THEN
            Client_SYS.Add_Info(lu_name_, 'INVOICEDUNITPRICEZERO: Net Invoiced Price/Base should be zero for Intrastat Line No :P1 having NOTC :P2.', newrec_.line_no, newrec_.notc);
         END IF;
      END IF;       
   END IF;
   -- gelr:italy_intrastat, start
   Validate_Italy_Intra_Data___(newrec_, indrec_);
   -- gelr:italy_intrastat, end
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

-- gelr:italy_intrastat, start
PROCEDURE Check_Service_Statistical_Code_Ref___ (
   newrec_ IN OUT NOCOPY intrastat_line_tab%ROWTYPE )
IS
BEGIN
   Statistical_Code_API.Exist(Site_API.Get_Company(newrec_.contract), newrec_.service_statistical_code);
END Check_Service_Statistical_Code_Ref___;

PROCEDURE Validate_Italy_Intra_Data___(
   newrec_ IN OUT NOCOPY intrastat_line_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec )
IS
BEGIN
   IF ( Company_Localization_Info_API.Get_Parameter_Value_Db(Site_API.Get_Company(newrec_.contract), 'ITALY_INTRASTAT') = Fnd_Boolean_API.DB_FALSE ) THEN
      IF(indrec_.invoice_date                   OR
         indrec_.service_statistical_code       OR
         indrec_.service_way                    OR
         indrec_.service_payment_way            OR
         indrec_.opposite_country_curr_code     OR
         indrec_.opposite_country_curr_amt      OR
         indrec_.adjust_to_prev_intrastat       OR
         indrec_.prev_intrastat_invoic_date     OR
         indrec_.advance_transaction            OR
         indrec_.payment_method                 OR
         indrec_.reference_invoice_serie        OR
         indrec_.reference_invoice_number       OR
         indrec_.reference_invoice_date         OR
         indrec_.protocol_no                ) THEN
         Error_SYS.Record_General(lu_name_, 'ITALYLOCATTRIBUTE: Some of the attribute can have value when italy intrastat functionality is used.');
      END IF;
   ELSE
      IF (newrec_.protocol_no IS NOT NULL AND newrec_.adjust_to_prev_intrastat = Fnd_Boolean_API.DB_FALSE) THEN
         Error_SYS.Record_General(lu_name_, 'ITALYPROTOCOLERR: Protocol number cannot have value when line is not an adjustment for previous intrastat report.');
      END IF;
      IF (newrec_.service_way IS NOT NULL AND newrec_.service_statistical_code IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDWAY: Service way cannot have value when the line is not a service intrastat line.');
      END IF;
      IF (newrec_.service_payment_way IS NOT NULL AND newrec_.service_statistical_code IS NULL ) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDPAYWAY: Service payment way cannot have value when the line is not a service intrastat line.');
      END IF;
      IF(newrec_.service_statistical_code IS NOT NULL AND newrec_.customs_stat_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'BOTHSTATHASVAL: Customs statistics number and services statistical code cannot have values at the same time.');
      END IF;
   END IF;
END Validate_Italy_Intra_Data___;
-- gelr:italy_intrastat, end

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Customs_Stat_No_Desc
--   Returns the Customs Statistics Number description after translated it to
--   company default language.
@UncheckedAccess
FUNCTION Get_Customs_Stat_No_Desc (
   customs_stat_no_ IN VARCHAR2,
   contract_        IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Customs_Statistics_Number_API.Get_Description(customs_stat_no_, Site_API.Get_Default_Language_Db(contract_));
END Get_Customs_Stat_No_Desc;


-- First_Receipt_Exist
--   Get the first receipt
@UncheckedAccess
FUNCTION First_Receipt_Exist (
   intrastat_id_ IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_   NUMBER := 0;
   CURSOR check_exist IS
      SELECT 1
      FROM INTRASTAT_LINE_TAB
      WHERE intrastat_id = intrastat_id_
      AND order_ref1 = order_no_
      AND order_ref2 = line_no_
      AND order_ref3 = release_no_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   CLOSE check_exist;
   IF (dummy_ = 1) THEN
      RETURN 'TRUE';
   END IF;
   RETURN 'FALSE';
END First_Receipt_Exist;


@UncheckedAccess
FUNCTION Get_Opponent_Type (
   intrastat_id_ IN NUMBER,
   line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ INTRASTAT_LINE_TAB.opponent_type%TYPE;
   CURSOR get_attr IS
      SELECT opponent_type
      FROM   INTRASTAT_LINE_TAB
      WHERE  intrastat_id = intrastat_id_
       AND   line_no = line_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN Opponent_Type_API.Decode(temp_);
END Get_Opponent_Type;


-- New_Intrastat_Line
--   Public method for creating a new record of IntrastatLine.
PROCEDURE New_Intrastat_Line (
   intrastat_id_             IN NUMBER,
   transaction_id_           IN NUMBER,
   transaction_              IN VARCHAR2,
   order_type_db_            IN VARCHAR2,
   contract_                 IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   part_description_         IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   lot_batch_no_             IN VARCHAR2,
   serial_no_                IN VARCHAR2,
   order_ref1_               IN VARCHAR2,
   order_ref2_               IN VARCHAR2,
   order_ref3_               IN VARCHAR2,
   order_ref4_               IN NUMBER,
   inventory_direction_      IN VARCHAR2,
   quantity_                 IN NUMBER,
   qty_reversed_             IN NUMBER,
   unit_meas_                IN VARCHAR2,
   reject_code_              IN VARCHAR2,
   date_applied_             IN DATE,
   user_id_                  IN VARCHAR2,
   net_unit_weight_          IN NUMBER,
   customs_stat_no_          IN VARCHAR2,
   intrastat_alt_qty_        IN NUMBER,
   intrastat_alt_unit_meas_  IN VARCHAR2,
   notc_                     IN VARCHAR2,
   intrastat_direction_db_   IN VARCHAR2,
   country_of_origin_        IN VARCHAR2,
   intrastat_origin_db_      IN VARCHAR2,
   opposite_country_         IN VARCHAR2,
   opponent_number_          IN VARCHAR2,
   opponent_name_            IN VARCHAR2,
   order_unit_price_         IN NUMBER,
   unit_add_cost_amount_     IN NUMBER,
   unit_charge_amount_       IN NUMBER,
   mode_of_transport_        IN VARCHAR2,
   invoice_serie_            IN VARCHAR2,
   invoice_number_           IN VARCHAR2,
   invoiced_unit_price_      IN NUMBER,
   unit_add_cost_amount_inv_ IN NUMBER,
   unit_charge_amount_inv_   IN NUMBER,
   delivery_terms_           IN VARCHAR2,
   triangulation_db_         IN VARCHAR2,
   statistical_procedure_db_ IN VARCHAR2,
   region_port_              IN VARCHAR2,
   region_of_origin_         IN VARCHAR2,
   county_                   IN VARCHAR2,
   return_reason_            IN VARCHAR2, 
   return_material_reason_   IN VARCHAR2,
   opponent_type_db_         IN VARCHAR2,
   unit_stat_charge_diff_    IN NUMBER,
   -- gelr:italy_intrastat, start
   invoice_date_                 IN DATE     DEFAULT NULL,
   service_statistical_code_     IN VARCHAR2 DEFAULT NULL,
   opposite_country_curr_code_   IN VARCHAR2 DEFAULT NULL,
   opposite_country_curr_amount_ IN NUMBER   DEFAULT NULL,
   prev_intrastat_invoic_date_   IN DATE     DEFAULT NULL,
   payment_method_               IN VARCHAR2 DEFAULT NULL,
   reference_series_id_          IN VARCHAR2 DEFAULT NULL,
   reference_invoice_no_         IN VARCHAR2 DEFAULT NULL,
   reference_invoice_date_       IN DATE     DEFAULT NULL                 
   -- gelr:italy_intrastat, end
   )
IS
   newrec_          INTRASTAT_LINE_TAB%ROWTYPE;
BEGIN
   newrec_.intrastat_id             := intrastat_id_;
   newrec_.transaction_id           := transaction_id_;
   newrec_.transaction              := transaction_;
   newrec_.order_type               := order_type_db_;
   newrec_.contract                 := contract_;
   newrec_.part_no                  := part_no_;
   newrec_.part_description         := part_description_;
   newrec_.configuration_id         := configuration_id_;
   newrec_.lot_batch_no             := lot_batch_no_;
   newrec_.serial_no                := serial_no_;
   newrec_.order_ref1               := order_ref1_;
   newrec_.order_ref2               := order_ref2_;
   newrec_.order_ref3               := order_ref3_;
   newrec_.order_ref4               := order_ref4_;
   newrec_.inventory_direction      := inventory_direction_;
   newrec_.quantity                 := quantity_;
   newrec_.qty_reversed             := qty_reversed_;
   newrec_.unit_meas                := unit_meas_;
   newrec_.reject_code              := reject_code_;
   newrec_.date_applied             := date_applied_;
   newrec_.userid                   := user_id_;
   newrec_.net_unit_weight          := NVL(net_unit_weight_, 0);
   newrec_.customs_stat_no          := customs_stat_no_;
   newrec_.intrastat_alt_qty        := intrastat_alt_qty_;
   newrec_.intrastat_alt_unit_meas  := intrastat_alt_unit_meas_;
   newrec_.notc                     := notc_;
   newrec_.intrastat_direction      := intrastat_direction_db_;
   newrec_.country_of_origin        := country_of_origin_;
   newrec_.intrastat_origin         := NVL(intrastat_origin_db_, 'AUTOMATIC');
   newrec_.opposite_country         := opposite_country_;
   newrec_.opponent_name            := opponent_name_;
   newrec_.opponent_number          := opponent_number_;
   newrec_.opponent_type            := opponent_type_db_;
   newrec_.order_unit_price         := order_unit_price_;
   newrec_.unit_add_cost_amount     := unit_add_cost_amount_;
   newrec_.unit_add_cost_amount_inv := unit_add_cost_amount_inv_;
   newrec_.unit_charge_amount       := unit_charge_amount_;
   newrec_.unit_charge_amount_inv   := unit_charge_amount_inv_;
   newrec_.mode_of_transport        := Mode_Of_Transport_API.Encode(mode_of_transport_);
   --             and will proceed with the NULL value. To avoid inserting unexpected null values added Exist_Db validation.
   --             Check_Common___() will not validate this since the value is null even though mode_of_transport_ have a value.
   IF mode_of_transport_ IS NOT NULL THEN
      Mode_Of_Transport_API.Exist_Db(newrec_.mode_of_transport);
   END IF;
   newrec_.invoice_serie            := invoice_serie_;
   newrec_.invoice_number           := invoice_number_;
   newrec_.invoiced_unit_price      := invoiced_unit_price_;
   newrec_.delivery_terms           := delivery_terms_;
   newrec_.triangulation            := triangulation_db_;
   newrec_.statistical_procedure    := NVL(statistical_procedure_db_, 'DELIVERY');
   newrec_.region_port              := region_port_;
   newrec_.region_of_origin         := region_of_origin_;
   newrec_.return_reason            := return_reason_;
   newrec_.return_material_reason   := return_material_reason_;
   newrec_.county                   := county_;
   newrec_.unit_statistical_charge_diff := unit_stat_charge_diff_;
   
   -- gelr:italy_intrastat, start
   IF ( Company_Localization_Info_API.Get_Parameter_Value_Db(Site_API.Get_Company(newrec_.contract), 'ITALY_INTRASTAT') = Fnd_Boolean_API.DB_TRUE ) THEN
      IF (service_statistical_code_ IS NOT NULL) THEN
         newrec_.payment_method           := payment_method_;
         newrec_.service_statistical_code := service_statistical_code_;
         newrec_.service_way              := Intrastat_Service_Way_API.DB_ONE_TIME_SERVICE;
         newrec_.service_payment_way      := Intrastat_Service_Pay_Way_API.DB_OTHER;
      END IF;
      newrec_.invoice_date                := invoice_date_;
      newrec_.opposite_country_curr_code  := opposite_country_curr_code_ ;
      newrec_.opposite_country_curr_amt   := opposite_country_curr_amount_;
      newrec_.prev_intrastat_invoic_date  := prev_intrastat_invoic_date_ ;
      newrec_.reference_invoice_serie     := reference_series_id_ ;
      newrec_.reference_invoice_number    := reference_invoice_no_;
      newrec_.reference_invoice_date      := reference_invoice_date_;
   END IF;
   -- gelr:italy_intrastat, end
   
   New___(newrec_);
END New_Intrastat_Line;


@UncheckedAccess
FUNCTION Get_Co_Line_Conn_Intrastat_Id(
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   deliv_no_     IN NUMBER) RETURN NUMBER
IS
   intrastat_id_ NUMBER;
   
   CURSOR get_intrastat_id IS
      SELECT intrastat_id
      FROM   INTRASTAT_LINE_TAB
      WHERE  order_ref1 = order_no_
      AND    order_ref2 = line_no_
      AND    order_ref3 = rel_no_
      AND    order_ref4 = line_item_no_
      AND    order_type = 'CUST ORDER'
      AND    rowstate  != 'Cancelled'
      AND    transaction_id  IN (SELECT transaction_id
                                 FROM   INVENTORY_TRANSACTION_HIST_TAB
                                 WHERE  source_ref1 = order_no_
                                 AND    source_ref2 = line_no_
                                 AND    source_ref3 = rel_no_
                                 AND    source_ref4 = line_item_no_
                                 AND    source_ref5 = deliv_no_);
       
BEGIN
   OPEN get_intrastat_id;
   FETCH get_intrastat_id INTO intrastat_id_;
   CLOSE get_intrastat_id;
   
   RETURN intrastat_id_;
END Get_Co_Line_Conn_Intrastat_Id;

PROCEDURE Consolidate_Intrastat_Lines (
   valid_intrastat_id_ IN NUMBER,
   new_intrastat_id_   IN NUMBER )
IS
   CURSOR get_valid_lines IS
      SELECT *
      FROM intrastat_line_tab
      WHERE intrastat_id = valid_intrastat_id_;
BEGIN
   FOR rec_ IN get_valid_lines LOOP
      rec_.line_no := NULL;
      rec_.intrastat_id := new_intrastat_id_;
      New___(rec_);
      
   END LOOP;
   
   
END Consolidate_Intrastat_Lines;

-- gelr:italy_intrastat, start
FUNCTION Advance_Trans_For_Order_Exists (
   order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_           NUMBER;
   adv_trans_found_ BOOLEAN := FALSE;
   CURSOR exist_adv_trans IS
      SELECT 1
      FROM  intrastat_line_tab
      WHERE order_ref1          = order_no_
      AND   advance_transaction = FnD_Boolean_API.DB_TRUE
      AND   rowstate            != 'Cancelled';
BEGIN
   OPEN exist_adv_trans;
   FETCH exist_adv_trans INTO dummy_;
   IF (exist_adv_trans%FOUND) THEN
      adv_trans_found_ := TRUE;
   END IF;
   CLOSE exist_adv_trans;
   RETURN adv_trans_found_;
END Advance_Trans_For_Order_Exists;
-- gelr:italy_intrastat, end
