-----------------------------------------------------------------------------
--
--  Logical unit: CustOrdCustomer
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  211122  Skanlk   Bug 161241(SC21R2-5748), In New_Customer_From_Template() modified the existing conditions to check the value of all delivery and document address related fields
--  211122           in order to set the value for Customer's own address id and also added a condition to check for the default delivery address before setting the value for Customer's own address id.
--  200712  ThKrLk   Bug 154440(SCZ-10218), Modified Prepare_Insert___() by adding new attribute PRINT_WITHHOLDING_TAX into attr.
--  200304  BudKlk   Bug 148995 (SCZ-5793), , Modified the method Fetch_Cust_Ref to resize the variable size of cust_ref_.    
--  191024  HarWlk   SCXTEND-963, Salesman renamed to Salesperson.
--  190930  DaZase   SCSPRING20-136, Added Raise_Self_Bill_Appr_Error___ and Raise_Deliv_Conf_Error___ to solve MessageDefinitionValidation issues.
--  180210  Hairlk   SCUXX-5152, Added public interface for modifying customer order info.
--  180213  Nikplk   STRSC-16275, Removed language_code_ parameter from New_Customer_From_Template and New_Prospect___ methods.
--  180130  Nikplk   STRSC-16275, Removed Customer Category check from PROCEDURE New_Customer_From_Template method when default_language_, new_country_ and language_code_ parameter values are NOT NULL. 
--  171222  RuLiLk   Bug 137426, Added new method Get_Cust_Credit_Stop_Detail to retrieve credit stopped parent customer details.
--  171130  ChBnlk   Bug 139001, Added new method Incr_Customer_Id_Autonomous___() to autonomously commit the customer identity as soon as it was fetched and modified New_Customer_From_Template()
--                   to call it to avoid deadlocks.
--  170830  IzShlk   STRSC-11319, Introduced Check_Access_For_Customer() method to check CRM Access for a customer for specific objects.
--  170706  KhVeSE   STRSC-8973, Added attribute HANDL_UNIT_AT_CO_DELIVERY to methods Prepare_Insert___() and Check_Insert___();
--  170530  MaEelk   STRSC-8072, re-wrote the error message in Check_Ownership_Transfer to tally with the message given in Transfer of Of Ownership from Customer owned to Company Owned.
--  170328  ThImlk   Modified Insert___() to set the default value of the agreement selection, when creating a new customer.
--  170125  Hairlk   APPUXX-8708, The column ALOW_B2B_AUTO_CRT_FRM_QUOT has been renamed to B2B_AUTO_CREATE_CO_FROM_SQ. Modified attr string in prepare_insert___ and Copy_Customer.
--  170118  Hairlk   APPUXX-7887, Added ALOW_B2B_AUTO_CRT_FRM_QUOT_DB to the attr string in prepare_insert___ and Copy_Customer
--  161219  IzShlk   VAULT-2206, Handled logic to remove automatically created CRM info (default main representative).
--  161219  IzShlk   VAULT-2257, Handled logic to prioratize main representative as per the requirment.
--  161219  IzShlk   VAULT-2257, Added an additional parameter(Main representative) to New_Customer_From_Template() method.
--  150920  Budklk   Bug 131362, Modified the method Check_No_Multiple_Payer___() in order to avoid geting an error message when the customer_no_pay_ and exist_customer_no_pay_ are same.
--  160712  SudJlk   STRSC-1959, Modified Check_Edi_Auth_Code_Ref___ to handle data validity of coordinator. Removed redundant checks for coordinator in
--  160712           Check_Insert___ and Check_Update___.
--  160517  Chgulk   STRLOC-80, Added new Address fields.
--  151210  MaIklk   LIM-4060, Checked whether any shipment exists for given customer no in check_delete.
--  150826  RoJalk   AFT-1657, Modified Check_Insert___, Check_Update___ and called Customer_Info_API.Exist when acquisition_site/category is not null.
--  150813  Wahelk   BLU-1192, Modified Copy_Customer method by addingnew parameter copy_info_ including overwrite_order_data_
--  150519  RoJalk   ORA-161, Added the method Fetch_Cust_Ref to include the hierachy to fecth contacts.
--  150204  ShVese   PRSC-5926, Added note_id to attr string in Copy_Customer to get the next note id from the sequence.
--  150127  MaRalk   PRSC-5045, Modified methods Prepare_Insert___ and Check_Insert___ by removing usages of obsolete columns 
--  150127           email_quotation and email_pro_forma_inv in Cust_Ord_Customer_Tab. 
--  150126  MaIklk   EAP-910, Fixed in better way to create document address for both prospect and customer in qucik register wizard.
--  150121  RoJalk   PRSC-5302, Modified Copy_Customer and assigned the default value as FALSE for mul_tier_del_notification.
--  141107  MaRalk   PRSC-3112, Removed parameter convert_customer_ from Copy_Customer method.
--  140912  HimRlk   PRSC-2447, Modified enumeration value of print_delivered_lines to Delivery_Note_Options_API.
--  140728  Hecolk   PRFI-41, Replaced usage of Party_Identity_Series_API.Update_Next_Identity with Party_Identity_Series_API.Update_Next_Value
--  140722  RoJalk   Modified Check_Update___, Check_Insert___ to include validations related to customer category and mul_tier_del_notification.
--  140714  MAHPLK   Removed del_name_ parameter from New_Customer_From_Template.
--  140711  MaIklk   PRSC-1761, Implemented to update missing information from template in copy_customer().
--  140708  RoJalk   Added mul_tier_del_notification and assigned default values in Check_Insert___ and Prepare_Insert___. 
--  140701  HimRlk   PRSC-1722, Renamed automatic_order_release to release_internal_order.
--  140415  JanWse   PBSC-8056, Only call Cust_Def_Com_Receiver_API.New in Insert___ if category customer
--  140408  MaIklk   PBSC-8044, Added customer category (default 'customer') parameter to Exist().
--  140408  RoJalk   Modified New_Customer_From_Template and updated Identity_Invoice_Info_Tab only of record exists.
--  140318  MaIklk   PBSC-7577, Implemented to create prospect using a template customer id.
--  140313  MiKulk   Modified the Copy_Customer method by adding only the relevent attribute to the attr_.
--  140311  ShVese   Removed Override annotation from the method Check_Edi_Auth_Code_Ref__.
--  140210  SURBLK   Added raise_error_ into Validate_Customer_Calendar().
--  140207  Maabse   Modified New_Customer_From_Template to work for End Customer (Same as for Prospects)
--  130117  MalLlk   Bug 113896, Modified Get_Delivery_Address to fetch the default delivery address and change the 
--  130117           cursor to retrieve data from customer_info_address_public and customer_info_address_type_pub.
--  081210  MaJalk   Added attribute summarized_packsize_chg.
--  081003  MaHplk   Added attribute summarized_freight_charges to LU.
--  080808  MaJalk   Added attribute receive_pack_size_chg and method Receive_Pack_Size_Chg_Db.
--  080702  JeLise   Merged APP75 SP2.
--  ----------------------- APP75 SP2 merge - End ------------------------------
--  080421  ChJalk   Bug 72427, Cust_grp and currency_code were made mandetory.
--  ----------------------- APP75 SP2 merge - Start ----------------------------
--  080313  MaHplk   Merged APP75 SP1
--  --------------------------APP75 SP1 merge - End ---------------------------------------------
--  080130  NaLrlk   Bug 70005, Added parameter del_terms_location_ and Modified the method New_Customer_From_Template.
--  --------------------------- APP75 SP1 merge - Start------------------------------------------------
--  071128  JeLise   Added column priority.
--  **************************** Nice Price ***************************
--  070913  NaLrlk  Bug 66663, Added view CUST_ORD_CUST7 to select customers and their default addresses with or without a record in identity_invoice_info.
--  070509  Cpeilk  Removed General_SYS.Init_Method from Customer_Is_Credit_Stopped and put PRAGMA.
--  070425  MiKulk  B142924, Modified the method Copy_Customer to correctly update the values for tempalte customer and quick registered customer.
--  070320  NaLrlk  B141510, Modified the method Copy_Customer for update the internal customer, the site connection form existing customer.
--  070316  NaLrlk  B141037, Modified the method Get_Name.
--  070314  MiErlk  Bug 63203, Made the send_change_message,replicate_doc_text and match_type mandatory in CUST_ORD_CUSTOMER.
--  070208  RaKalk  Modified New_Customer_From_Template method to reve Delivery terms desc from attribute string
--  070118  KaDilk  Removed Language code for delivery_terms_desc.
--  061110  NaLrlk  Removed allow_backorders from views, Removed function Get_Allow_Backorders and added the backorder_option to view,
--                  Added functions Get_Backorder_Option and Get_Backorder_Option_Db.
--  061018  MiErlk  Bug 60272, Modified cursor check_cust_pay in procedure Check_Delete___.
--  060828  IsWilk  Bug 59534, Changed the IF condition of checking date_del in PROCEDURE Check_Delete___.
--  030823  MiKulk  Modified the methods Copy_Customer, New_Customer_From_Template and Unpack_Check_Insert
--  030823          With a better logic for copying the customer.
--  060822  NaWilk  Added field credit_control_group_id to VIEW_ENT.
--  060822  NaWilk  Modified method Get_Credit_Control_Group_Id to use micro cache and modified methods
--  060822          Copy_Customer and Prepare_Insert___ by adding field credit_control_group_id.
--  060822  NaWilk  Added field credit_control_group_id.
--  060821  MiErlk  Removed SUBSTR from return value of FUNCTION Get_Name.
--  060816  MalLlk  Added public function Get_Invoice_Sort_Db to return the invoice sort db value for a given customer.
--  060811  DaZase  Added new attribute automatic_order_release and modified code accordingly.
--  060728  ChJalk  Replaced Order_Delivery_Term_Desc with Order_Delivery_Term.
--  060518  RaKalk  Bug 57776, Added view CUST_ORD_CUST6.
--  060515  NaLrlk  Enlarge Address_Id - Changed variable definitions.
--  060418  IsWilk  Enlarge Identity - Changed view comments for customer_no, template_customer_id, customer_no_pay.
--  060418  MaJalk  Enlarge Identity - Changed view comments for customer_id.
--  --------------------------------- 13.4.0 ----------------------------------
--  060207  IsAnlk  Modified Unpack_Check_Insert___ and Unapack_Check_Upadate___.
--  060124  NiDalk  Added Assert safe annotation.
--  051101  SaRalk  Added new attribute adv_inv_full_pay and modified code accordingly.
--  051012  MaGuse  Bug 53526, Changed reference on edi_auto_approval_user from FND_USER to USER_DEFAULT.
--  050922  SaMelk  Removed Unused variables.
--  050922  IsWilk  Modified the PROCEDURE Unpack_Check_Update___ to change the
--  050922          condition of the info message when modifying confirm_Deliveries
--  050922          and receiving_advice_type.
--  050920  IsAnlk  Added doc_ean_location_ and del_ean_location_ parameters to New_Customer_From_Template.
--  050907  PrPrlk  Bug 53186, Modified the method Unpack_Check_Update___ to make the validation only when the value of the field date_del is changed.
--  050907  RaKalk  Modified Unpack_Check_Insert___,Unpack_Check_Update___ to set sbi_auto_approval_user to null when automatic matic matching is not used
--  050907  NaLrlk  Added new conditions for info message when confirm_deliveries is 'FALSE' in Unpack_Check_Update___
--  050907  KeFelk  Added rec_adv_auto_approval_user and Get_Rec_Adv_Auto_Approval_User.
--  050907  JaBalk  Removed SUBSTRB in view VIEW_ENT.
--  050906  SaJjlk  Removed SUBSTRB in view CUST_ORD_CUST5.
--  050906  Samnlk  Change the code SUBSTRB to SUBSTR in view column category in view CUST_ORD_CUST2.
--  050906  RaKalk  Added column sbi_auto_approval_user and method Get_Sbi_Auto_Approval_User
--  050825  JaBalk  Changed the Copy_Customer method to add the self billing match option.
--  050809  NaLrlk  Added the function Get_Receiving_Advice_Type_Db
--  050802  KiSalk  Bug 51603, In CUST_ORD_CUSTOMER's view comments reference of customer_no to CustomerInfo, changed to 'CASCADE'.
--  050715  NaLrlk  Added RECEIVING_ADVICE_TYPE and REC_ADV_MATCHING_OPTION to prepare_insert___.
--  050707  JaJalk  Modified Update_Cache___ and Get to select the self billing match option.
--  050707  IsAnlk  Modified Unpack_Check_Update___ to validate newrec_.update_price_from_sbi.
--  050706  MaEelk  Added CYCLE_PERIOD to the attr_ in Unpack_Check_Update___.
--  050629  JaBalk  Renamed the column sb_matching_option to self_billing_match_option.
--  050628  NaLrlk  Added columns rec_adv_auto_match_diff,rec_adv_auto_matching,rec_adv_matching_option and receiving_advice_type.
--  050627  JaBalk  Added column sb_matching_option
--  050622  MaEelk  Modified the error message we get when having a closing date with a cycle interval.
--  050620  MaEelk  When saving a record with a no value in the Cycle Interval field,
--  050620          "0" was set as the default value.Modified Unpack_Check_Update___.
--  050525  IsWilk  Modified the PROCEDURE Unpack_Check_Update to remove the closing
--  050525          dates from cust_invoice_close_date_tab when modifing the invoice
--  050525          type to collective invoice.
--  050520  IsWilk  Modified the PROCEDUREs Unpack_Check_Insert___ and Unpck_Check_Update___
--  050520          validate the cyclic period with the closing dates functionality.
--  050513  NiDalk  Added column update_price_from_sbi
--  050331  Samnlk  Modified method Copy_Customer,make Template_Customer_Desc always NULL.
--  050310  JoEd    Added columns confirm_deliveries and check_sales_grp_deliv_conf.
--  050202  JICE    Bug 49188, Added public attribute Min_Sales_Amount.
--  041221  VeMolk  Bug 48512, Modified a method call, inside the method Customer_Is_Credit_Stopped.
--  041215  ToBeSe  Bug 48539, Modified New_Customer_From_Template, corrected erroneous use of NVL.
--  041207  ErFelk  Bug 48361, Modified New_Customer_From_Template by adding an IF condition when Updating Next Identity.
--  041021  ErFelk  Bug 45424, Modified New_Customer_From_Template to Update Next Identity.
--  041019  SaRalk  Modified view comments of views &VIEW and &VIEW_ENT.
--  041004  MaJalk   Bug 44670, Add new function Get_Customer_E_Mail.
--  041001  NuFilk  Modified the method Prepare_Insert___.
--  040902  LoPrlk  Altered the method New_Customer_From_Template.
--  040902  SaMelk  Modified Unpack_Check_Insert___ set default value to print_amounts_incl_tax.
--  040831  DiVelk  Modified [Unpack_Check_Insert___] and [Unpack_Check_Update___].
--  040831  SaMelk  Added print_amounts_incl_tax column to CUST_ORD_CUSTOMER_ENT View.
--  040830  SaMelk  Added print_amounts_incl_tax column to CUST_ORD_CUSTOMER_TAB.
--  040827  SaJjlk  Added a new view CUST_ORD_CUST5.
--  040823  DaRulk  Added company to CUST_ORD_CUST2 view.
--  040617  WaJalk  Modified New_Customer_From_Template to add Template Customer contact to New Customer Reference.
--  040609  NiRulk   Bug 43785, Added new column to CUST_ORD_CUST2 view.
--  040308  LoPrlk  Commented codes in the micro cache implementation were removed.
--  040303  LoPrlk  Impliment LU Microcache, Method Get was updated to prevent a performence problem.
--  040218  IsWilk  Removed the SUBSTRB from the views and modified the SUBSTRB to SUBSTR for Unicode Changes.
--  -----------------EDGE Package Group 3 Unicode Changes--------------------------------------
--  040211  LoPrlk  Impliment LU Microcache, Cache was implemented on all get methods except Get_Bonus_Rate and Get_Discount.
--  -----------------EDGE Package Group 2--------------------------------------
--  040130  GeKalk  Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  ********************* VSHSB Merge End *************************
--  040122  JoEd    Added forward_agent_id and auto_despatch_adv_send to Copy_Customer() function.
--  021101  GeKaLk  Added match_type to Copy_Customer() function.
--  020930  GeKaLk  Added match_type to Update__ function.
--  020422  GeKaLk  Added match_type to CUST_ORD_CUSTOMER_ENT.
--  020422  GeKaLk  Added a new attribute Match_Type to CUST_ORD_CUSTOMER_TAB.
--  020528  DaMase Improved readability for the Shipment changes.
--  020424  Prinlk Added public attribute Auto_Despatch_Adv_Send.
--  020107  Prinlk Added the attribute Forward_Agent_Id.
--  ********************* VSHSB Merge *****************************
--  030924  ChBalk  Added Send_Change, Replicate_Changes to Prepare_Insert___.
--  030924  BhRalk   Modified the method Copy_Customer.
--  030916  JaJalk   Modified the method New_Customer_From_Template.
--  030901  UdGnlk   Performed CR Merge2.
--  030822  WaJalk   Added new LOV view EXTERNAL_CUSTOMER_LOV for external customer selection.
--  030827  MaGulk   Moved public view CUST_ORD_CUSTOMER_PUB to customer.api
--  030820  MaGulk   Merged CR
--  030718  PrInlk   Modified Prepare_Insert___ so that, Summarised Source Lines will be defaulted.
--  030718  NuFilk   Modified Prepare_Insert___ so that, Send Order Confimation will be ticked as default.
--  030716  NaWalk   Removed Bug coments.
--  030708  BhRalk   Applied the Bug 35765.
--  030623  WaJalk   Removed column automatic_repl_change.
--  030602  WaJalk   Added column replicate_doc_text.
--  030530  WaJalk   Added two new columns, automatic_repl_change, send_change_message.
--  030513  PrInlk   Added column summarized_source_lines
--  030421  ChBalk   Added Get_Contract_From_Customer_No, will return acquisition_site for the internal customer.
--  ****************************** CR Merge ***********************************
--  030729  JaJalk   Performed SP4 Merge.
--  030715  AnJplk   Added function Get_Cust_Part_Owner_Trans_Db.
--  030502  SuAmlk   Added attributes CUST_PART_ACQ_VAL_LEVEL and CUST_PART_OWNER_TRANSFER to the method Copy_Customer.
--  030422  SuAmlk   Modified column comments for columns CUST_PART_ACQ_VAL_LEVEL and
--                   CUST_PART_OWNER_TRANSFER in the views VIEW and VIEW_ENT.
--  030422  SuAmlk   Added default values for attributes CUST_PART_ACQ_VAL_LEVEL and
--                   CUST_PART_OWNER_TRANSFER in PROCEDURE Prepare_Insert___.
--  030418  SuAmlk   Added new attributes CUST_PART_ACQ_VAL_LEVEL and CUST_PART_OWNER_TRANSFER.
--  030324  SuAmlk   Removed default value of column NO_DELNOTE_COPIES.
--  030321  SuAmlk   Added public attribute NO_DELNOTE_COPIES.
--  030207  ChiWlk   Bug fix 35765, Changed Unpack_Check_Insert___ and Unpack_Check_Update___
--  030207  ChiWlk   to prevent discount percentages without a discount type.
--  021212  Asawlk   Merged bug fixes in 2002-3 SP3
--  021003  GaJalk   Bug 32993, Added the function Get_Pay_Address.
--  020628  CaRase   Bug fix 28581, Modified PROCEDURE New_Customer_From_Template, added call to Identity_Invoice_Info_API.Modify.
--  020618  AjShlk   Bug 29312, Added county to attr in New_Customer_From_Template.
--  020107  CaStse   Bug fix 26922, Changed discount limits in Unpack_Check_Insert___ and Unpack_Check_Update___
--                   to allow negative discount.
--  010917  JICE     Added public view CUST_ORD_CUSTOMER_PUB.
--  010223  RoAnse   Bug fix 19071, Removed code added earlier for this bug fix.
--  011001  SaNalk   Bug fix 24893, Added a coundition to check discount limits in procedure Unpack_Check_Update___.
--  010517  JSAnse   Bug fix 21965, Deleted a redundant call to Customer_Info_API.Exist in procedure Unpack_Check_Insert.
--  010419  JSAnse   Bug fix 21249, Comment on column &View2..name modifed, removed "/UPPERCASE".
--  010413  JaBa     Bug Fix 20598,Added new global lu constant inst_CustomerCreditInfo_.
--  010220  RoAnse   Bug fix 19071, Modified PROCEDURE New_Customer_From_Template, checking if
--                   payment terms have been defined for the template customer .
--  010215  RoAnse   Bug fix 19528, changed addr_id_ from NUMBER to VARCHAR2 in
--                   CURSOR order_data_defined in New_Customer_From_Template in Customer.apy.
--  010104  JoAn     Changed New_Customer_From_Template, removed cursors
--                   directly accessing views in Enterprice, added check
--                   before attempting to update order address data.
--  001204  CaSt     Changed message ORDERATTR in procedure Exist.
--  001117  CaSt     Client value was used in New_Customer_From_Template.
--  001015  CaSt     Continued modifying method New_Customer_From_Template.
--  001004  CaSt     Modified method New_Customer_From_Template.
--  000913  FBen     Added UNDEFINE.
--  000710  ReSt     Added default value for Commission_Receiver_DB in Prepare_Insert__
--  000710  ThIs     Added method Modify_Commission_Receiver
--  000710  ThIs     Modified Insert__ and Unpack_Check_Update
--  000710  JakH     Merged Chameleon. Functions for Commissions.
--  --------------------------- 12.1.0 --------------------------------------
--  000509  PaLj     Added Configurator_Customer
--  000420  PaLj     Changed check for installed logical units. A check is made when API is instantiatet.
--                   See beginning of api-file.
--  000419  DaZa     Added public method Check_Exist.
--  000411  MaGu     Modified method New_Customer_From_Template. Modified call to Customer_Info_Address_API.Modify_Address.
--  000229  MaGu     Modified method New_Customer_From_Template. Added call to new method Customer_Info_Address_API.Modify_Address.
--  000228  MaGu     CID 32799. Modified method new_customer_from_template. Added new address fields.
--  000211  MaGu     Modified handling of Template_Customer in Unpack_Check_Insert___. Default value is given
--                   to Template_Customer in order to avoid problems when no value is sent from client.
--  991215  MaGu     Added view template_customer_lov. Added Quick_Registered_Customer_db to comments for view cust_ord_customer_ent.
--  991209  MaGu     Added public attributes Quick_Registered_Customer,Template_Customer and Template_Customer_Description.
--                   Added public method New_Customer_From_Template. Added the new attributes to Prepare_Insert___ and Copy_Customer.
--                   Added the new attributes in view cust_ord_customer_ent.
--  991126  SaMi     note_id added to cust_ord_customer_ent
--  991125  SaMi     Added  note_id to cust_ord_customer_tab.
--  --------------   ------------- 12.0 ----------------------------------------
--  991129  SaMi     Note_id added to Cust_Order_Customer_tab,function Get_Note_Id is added too. Get function
--                   returns note_id
--  991111  PaLj     Added Method Copy_Customer
--  991015  JOHW     Added Get_Discount_Class. ONLY for Maintenance.
--  991007  JoEd     Call Id 21210: Corrected double-byte problems.
--  991006  JOHW     Removed Discount Class from VIEW_ENT.
--  990901  JOHW     Added Discount_Type and Discount in view cust_ord_customer_ent.
--  990901  JOHW     Made Discount Public.
--  990831  JOHW     Added Discount_Type and Discount.
--  --------------------------- 11.1 ----------------------------------------
--  990614  JoEd     Added function Get_Visit_Address.
--  990510  RaKu     Removed obsolete code from Prepare_Insert___.
--  990503  RaKu     SID 11753. Added substr in function Get_Name.
--  990420  RaKu     Added new default values to Prepare_Insert___.
--  990414  JakH     Modified a modify procedure not to use get-id-by-keys
--  990408  JakH     New template.
--  990401  JoAn     Removed Modify_Credit_Info.
--  990324  JoAn     Added new method Customer_Is_Credit_Stopped.
--  990322  RaKu     Removed obsolete functions Get_Cr_Limit and Get_Cr_Limit_Currency_Code
--                   Removed oboslete columns CR_LIMIT and CR_LIMIT_CURRENCY_CODE.
--  990311  JoAn     Removed the code for controlling credit info from Finance.
--                   If Finance controls the credit the information will be retrived
--                   from Payment when the credit check is made in ordflow.apy.
--  990126  JoAn     Corrected name of payment procedure called in Cr_Limit_Set_By_Finance___
--  990122  JoAn     Changes in Unpack_.. methods for Extended Credit Check.
--  990120  JoAn     Added new methods Modify_Credit_Info, Cr_Limit_Set_By_Finance___
--                   and Get_Finance_Credit_Info___. Theese are all needed to handle
--                   credit limits controlled by Finance.
--  990113  JoEd     Added public attribute cr_limit_currency_code.
--  990109  ToBe     Changed salesman_code to 20 characters.
--  981229  ErFi     Changed edi_authorize_code to 20 characters.
--  981208  JoEd     Modified New procedure - added value to info_.
--  981207  JoEd     Added procedure New.
--  981202  JoEd     Changed calls to Enterprise.
--  981127  JoEd     Call id 5307: Changed data type from number to string(12)
--                   on template_id.
--  981109  JoEd     Removed NOCHECK on template_id.
--  981029  RaKu     Added Get_Price_List_No (again) for compability reasons.
--  980922  RaKu     Removed PRICE_LIST_NO. Added CUST_PRICE_GROUP_ID.
--  980918  RaKu     Changed column Edi_Order_Id to Order_Id.
--  980916  JoEd     Added column Template_id and method Get_Template_Id.
--  980803  ANHO     Changed promptname on cust_ref and cycle_period.
--  980422  JoAn     SID 594 Hardcoded db value in Get_Customer_No_From_Contract
--  980331  RaKu     Added procedure Check_No_Multiple_Payer___.
--  980326  RaKu     Added mandatory-checks on discount_class.
--  980319  JoAn     Added checks to assure that the adress retrived is valid in
--                   Get_Delivery_Address and Get_Document_Address.
--                   Removed obsolete method Get_First_Address.
--  980316  RaKu     Added edi_auto_approval_user and logic to it.
--  980316  RaKu     Support Id 1418. Changed comments on BONUS_RATE.
--  980311  JoEd     Support Id 752. Added Get_Date_Del function.
--  980310  JoEd     Support Id 868. Remove obsolete columns - authorize_code and order_id.
--                   Also removed Get_Authorize_Code and Get_Order_Id methods.
--  980303  MNYS     Added method Get_Default_E_Mail.
--  980227  MNYS     Support Id 594. Cursor in Get_Customer_No_From_Contract changed to
--                   use category_db instead of category.
--  980226  JoEd     Added Get_Default_Media_Code.
--  980224  ToOs     Corrected format on amount columns
--  980219  RaKu     Added EDI-functions and columns.
--  980210  ToOs     Changed format on amount columns
--  971124  RaKu     Changed to FND200 Templates.
--  971027  JoAn     Replaced calls to removed private methods in Cust_Ord_Customer_Address
--                   with calls to the new public ones.
--  971020  JoAn     Added check for default address in Get_Document_Address and
--                   Get_Delivery_Address.
--  970929  RaKu     Added check for acquisition_site, order_id, authorize_code
--                   when making the category mandatory.
--  970926  JoAn     Corrected Get_Acquisition_Site
--  970925  JoAn     Added Get_Acquisition_Site
--  970924  JoAn     Added check for customer_no_pay = customer_no in Unpack_Check_Insert___.
--                   Added check if a site has already been used for a customer in
--                   Unpack_Check_Insert___ and Unpack_Check_Update___.
--                   Added customer_name to view in order to display it in LOV:s.
--                   Added check against Party_Type_Customer in Exist
--  970908  RaKu     Made changes in Prepare_Insert, Unpack_Check_Insert___/Update___.
--  970826  JoAn     Changes due to integration with Enterprise.
--                   Removed columns stored in Enterprise or Invoice module.
--  970528  PAZE     Bonus Rate was set to Insertable and Updateable.
--  970526  JoAn     Removed LOV flag on lots of columns.
--  970526  PAZE     Changed LOV-order.
--  970521  JoEd     Rebuild Get_.. methods calling Get_Instance___.
--                   Added .._db columns in the view for all IID columns.
--  970512  JoAn     Exist check for vendor_no made with dynamic SQL call
--  970507  PAZE     Renamed curr_code to currency_code and changed reference to IsoCurrency.
--                   Changed length on language_code.
--  970507  PAZE     Removed accnt, pay_terms, assoc_no, balance_ord,
--                   balance_res, bank_giro, post_giro, external_update, invoice_fee,
--                   invoice_fee_amount, invoice_fee_flag and related get functions.
--  970505  PAZE     According to integration with Module Accounting Rules:
--                   Removed Mpccom_Company_API.Get_Curr_code, Mpccom_Company_API.Get_language_code in Prepare_Insert__.
--                   Removecompany from insert cust_ord_customer_tab.
--  970417  NABE     Added Get_Category public method.
--  970416  NABE     Made Authorize_code and Order_Id as Public, Added a new
--                   public method Get_Customer_No_From_Contract.
--  970414  JoEd     Added columns category, acquisition_site, order_id and
--                   authorize_code.
--  970312  RaKu     Changed tablename.
--  970220  RaKu     Added company in Insert___. Was removed by mistake.
--  970219  PAZE     Changed rowversion (10.3 project).
--  960219  PARO     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Self_Bill_Appr_Error___
IS
BEGIN
   Error_SYS.Record_General('CustOrdCustomer','ENTERSBIAPPRUSER1: Self-Billing approval user must be entered when automatic matching is used');
END Raise_Self_Bill_Appr_Error___;   

PROCEDURE Raise_Deliv_Conf_Error___ (
   customer_no_ IN VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_Info(lu_name_, 'MISSINGDELIVCONF: Customer :P1 is not set up to use Delivery Confirmation.', customer_no_);
END Raise_Deliv_Conf_Error___;   
   

-- Check_No_Multiple_Payer___
--   Compares the customer_no and customer_no_pay so that the customer_no_pay
--   do not have a payer himself when they are not the same.
PROCEDURE Check_No_Multiple_Payer___ (
   customer_no_     IN VARCHAR2,
   customer_no_pay_ IN VARCHAR2 )
IS
   exist_customer_no_pay_ CUST_ORD_CUSTOMER_TAB.customer_no_pay%TYPE;

   CURSOR check_used_as_payer IS
      SELECT customer_no_pay
      FROM   CUST_ORD_CUSTOMER_TAB
      WHERE  customer_no = customer_no_pay_
      AND    customer_no_pay IS NOT NULL;

   CURSOR check_already_a_payer IS
      SELECT customer_no_pay
      FROM   CUST_ORD_CUSTOMER_TAB
      WHERE  customer_no_pay = customer_no_
      AND    customer_no != customer_no_ ;
BEGIN
   
   IF (customer_no_pay_ IS NOT NULL) THEN
      IF (customer_no_ != customer_no_pay_) THEN
         OPEN  check_used_as_payer;
         FETCH check_used_as_payer INTO exist_customer_no_pay_;
         IF (check_used_as_payer%FOUND) THEN
            CLOSE check_used_as_payer;
            IF (customer_no_pay_ != exist_customer_no_pay_) THEN 
               Error_SYS.Record_General(lu_name_, 'MULTIPLE_CUST_PAY: Customer :P1 has another payer :P2 and can not be used as payer himself.', customer_no_pay_, exist_customer_no_pay_);
            END IF;
         ELSE
            CLOSE check_used_as_payer;
         END IF;
         OPEN  check_already_a_payer;
         FETCH check_already_a_payer INTO exist_customer_no_pay_;
         IF (check_already_a_payer%FOUND) THEN
            CLOSE check_already_a_payer;
            Error_SYS.Record_General(lu_name_, 'ALREADY_A_PAYER: Customer :P1 is used as payer for one or several customers and can not have another payer himself.', customer_no_);
         ELSE
            CLOSE check_already_a_payer;
         END IF;
      END IF;
   END IF;
END Check_No_Multiple_Payer___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CYCLE_PERIOD', 0, attr_);
   Client_SYS.Add_To_Attr('INVOICE_SORT', Customer_Invoice_Type_API.Decode('N'), attr_);
   Client_SYS.Add_To_Attr('CR_STOP_DB', 'N',  attr_);
   Client_SYS.Add_To_Attr('ORDER_CONF_FLAG_DB', 'Y',  attr_);
   Client_SYS.Add_To_Attr('PACK_LIST_FLAG_DB', 'Y',  attr_);
   Client_SYS.Add_To_Attr('CATEGORY_DB', 'E',  attr_);
   Client_SYS.Add_To_Attr('EDI_AUTO_ORDER_APPROVAL_DB', Approval_Option_API.DB_MANUALLY, attr_);
   Client_SYS.Add_To_Attr('EDI_AUTO_CHANGE_APPROVAL_DB', Approval_Option_API.DB_MANUALLY, attr_);
   Client_SYS.Add_To_Attr('EDI_AUTO_ORDER_APPROVAL', Approval_Option_API.Decode(Approval_Option_API.DB_MANUALLY), attr_);
   Client_SYS.Add_To_Attr('EDI_AUTO_CHANGE_APPROVAL', Approval_Option_API.Decode(Approval_Option_API.DB_MANUALLY), attr_);
   Client_SYS.Add_To_Attr('QUICK_REGISTERED_CUSTOMER_DB', 'NORMAL', attr_);
   Client_SYS.Add_To_Attr('TEMPLATE_CUSTOMER_DB', 'NOT_TEMPLATE', attr_);
   Client_SYS.Add_To_Attr('COMMISSION_RECEIVER_DB', 'DONOTCREATE', attr_);
   Client_SYS.Add_To_Attr('CUST_PART_ACQ_VAL_LEVEL', Cust_Part_Acq_Val_Level_API.Decode('NO_ACQ'), attr_);
   Client_SYS.Add_To_Attr('CUST_PART_OWNER_TRANSFER_DB', 'DONT_ALLOW_TRANSFER', attr_);
   Client_SYS.Add_To_Attr('SEND_CHANGE_MESSAGE_DB', 'N', attr_);
   Client_SYS.Add_To_Attr('SUMMARIZED_SOURCE_LINES_DB', 'Y', attr_);
   Client_SYS.Add_To_Attr('MATCH_TYPE', Match_Type_API.Decode('NOAUTO'), attr_);
   Client_SYS.Add_To_Attr('PRINT_AMOUNTS_INCL_TAX_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('CONFIRM_DELIVERIES_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('CHECK_SALES_GRP_DELIV_CONF_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('HANDL_UNIT_AT_CO_DELIVERY', Handl_Unit_At_Co_Delivery_API.Decode('USE_SITE_DEFAULT'), attr_);
   Client_SYS.Add_To_Attr('UPDATE_PRICE_FROM_SBI_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SELF_BILLING_MATCH_OPTION', Matching_Option_API.Decode('DELIVERY NOTE'), attr_);
   Client_SYS.Add_To_Attr('RECEIVING_ADVICE_TYPE', Receiving_Advice_Type_API.Decode('DO_NOT_USE'), attr_);
   Client_SYS.Add_To_Attr('REC_ADV_MATCHING_OPTION', Matching_Option_API.Decode('DELIVERY NOTE'), attr_);
   Client_SYS.Add_To_Attr('REC_ADV_AUTO_MATCHING_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('REC_ADV_AUTO_MATCH_DIFF_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('ADV_INV_FULL_PAY_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('RELEASE_INTERNAL_ORDER_DB', Approval_Option_API.DB_MANUALLY, attr_);
   Client_SYS.Add_To_Attr('RELEASE_INTERNAL_ORDER', Approval_Option_API.Decode(Approval_Option_API.DB_MANUALLY), attr_);
   Client_SYS.Add_To_Attr('CREDIT_CONTROL_GROUP_ID', Credit_Control_Group_API.Get_Default_Group(), attr_);
   Client_SYS.Add_To_Attr('BACKORDER_OPTION', Customer_Backorder_Option_API.Decode('INCOMPLETE PACKAGES NOT ALLOWED'),  attr_);
   Client_SYS.Add_To_Attr('REPLICATE_DOC_TEXT', Doc_Text_Replicate_Option_API.Decode(Doc_Text_Replicate_Option_API.DB_DO_NOT_REPLICATE), attr_);
   Client_SYS.Add_To_Attr('RECEIVE_PACK_SIZE_CHG_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SUMMARIZED_FREIGHT_CHARGES_DB', 'Y', attr_);
   Client_SYS.Add_To_Attr('PRINT_DELIVERED_LINES_DB', Delivery_Note_Options_API.DB_SHIPMENT, attr_);
   Client_SYS.Add_To_Attr('PRINT_DELIVERED_LINES', Delivery_Note_Options_API.Decode(Delivery_Note_Options_API.DB_SHIPMENT), attr_);   
   Client_SYS.Add_To_Attr('EMAIL_ORDER_CONF_DB', 'TRUE', attr_);   
   Client_SYS.Add_To_Attr('EMAIL_INVOICE_DB', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('MUL_TIER_DEL_NOTIFICATION_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('B2B_AUTO_CREATE_CO_FROM_SQ_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('PRINT_WITHHOLDING_TAX_DB', Fnd_Boolean_API.DB_FALSE, attr_);

END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_ORD_CUSTOMER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   company_             VARCHAR2(20) := Site_API.Get_Company(User_Default_API.Get_Contract);
   currency_rounding_   NUMBER;
   commission_receiver_ VARCHAR2(20);
   customer_category_   CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   IF (newrec_.note_id IS NULL) THEN
      newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   END IF;

   IF ((newrec_.edi_auto_order_approval = Approval_Option_API.DB_AUTOMATICALLY) OR (newrec_.edi_auto_change_approval = Approval_Option_API.DB_AUTOMATICALLY)) THEN
      -- Automatic Order Approval is ON.
      IF (newrec_.edi_auto_approval_user IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NO_APPROVAL_USER: Approval user must be entered if automatic approval is used for incoming customer order or for incoming change requests.');
      END IF;
   END IF;

   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);

   super(objid_, objversion_, newrec_, attr_);

   commission_receiver_ := Commission_Receiver_API.Get_Com_Receiver_For_Salesman(newrec_.salesman_code);

   customer_category_  := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no); 
   IF (newrec_.commission_receiver = 'CREATE' AND customer_category_ = Customer_Category_API.DB_CUSTOMER) THEN
      IF Commission_Receiver_API.Check_Exist(commission_receiver_) THEN
         Cust_Def_Com_Receiver_API.New(commission_receiver_, newrec_.customer_no);
      ELSE
         Error_SYS.Record_General(lu_name_, 'CHECK_EXIST_FALSE: Salesperson is not registered as a commission receiver');
      END IF;
   END IF;
   Multiple_Rebate_Criteria_API.Set_Default_Values(newrec_.customer_no);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUST_ORD_CUSTOMER_TAB%ROWTYPE,
   newrec_     IN OUT CUST_ORD_CUSTOMER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   company_           VARCHAR2(20) := Site_API.Get_Company(User_Default_API.Get_Contract);
   currency_rounding_ NUMBER;
BEGIN
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   IF ((newrec_.edi_auto_order_approval = Approval_Option_API.DB_AUTOMATICALLY) OR (newrec_.edi_auto_change_approval = Approval_Option_API.DB_AUTOMATICALLY)) THEN
      -- Automatic Order Approval  or Automatic Change Request Approval is ON.
      IF (newrec_.edi_auto_approval_user IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NO_APPROVAL_USER: Approval user must be entered if automatic approval is used for incoming customer order or for incoming change requests.');
      END IF;
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CUST_ORD_CUSTOMER_TAB%ROWTYPE )
IS
   dummy_  NUMBER;
   quote_count_   NUMBER;
   ref_lu_prompt_ VARCHAR2(2000);

   CURSOR check_cust_pay IS
      SELECT 1
      FROM CUST_ORD_CUSTOMER_TAB
      WHERE  customer_no_pay = NVL(remrec_.customer_no,CHR(132));
BEGIN
   IF (remrec_.date_del IS NOT NULL) THEN
      IF (remrec_.date_del > SYSDATE) THEN
         Error_SYS.Record_General(lu_name_, 'INVALID_EXP_DATE: This customer can not be deleted since the expiration date has not yet been reached.');
      END IF;
   END IF;

   OPEN check_cust_pay;
   FETCH check_cust_pay INTO dummy_;
   IF check_cust_pay%FOUND THEN
      Error_SYS.Record_General(lu_name_, 'PAYER_EXIST: This customer can not be deleted since it is payer to another customer.');
   END IF;
   CLOSE check_cust_pay;

   super(remrec_);
   
   -- Check Shipment exist for the given customer
   Shipment_API.Check_Exist_By_Receiver(Sender_Receiver_Type_API.DB_CUSTOMER, remrec_.customer_no, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
   
    -- Check Order quotation record is used,
   quote_count_ := Order_Quotation_API.Get_Customer_Count(remrec_.customer_no);
   IF ( quote_count_ > 0 ) THEN
      ref_lu_prompt_ := Language_SYS.Translate_Lu_Prompt_('OrderQuotation');
      Error_SYS.Record_Constraint(lu_name_, ref_lu_prompt_, to_char(quote_count_), NULL, remrec_.customer_no );
   END IF;
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_ord_customer_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   exists_              VARCHAR2(50);
   site_customer_no_    CUST_ORD_CUSTOMER_TAB.customer_no%TYPE;
   customer_category_   CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   -- NVL is handled in order to avoid initialising of the following attributes when copying a customer.
   newrec_.cycle_period := NVL(newrec_.cycle_period,0);
   newrec_.invoice_sort := NVL(newrec_.invoice_sort,'N');
   newrec_.cr_stop := NVL(newrec_.cr_stop, 'N');
   newrec_.order_conf_flag := NVL(newrec_.order_conf_flag,'Y');
   newrec_.pack_list_flag := NVL(newrec_.pack_list_flag,'Y');
   newrec_.category := NVL(newrec_.category,'E');
   newrec_.edi_auto_order_approval := NVL(newrec_.edi_auto_order_approval, Approval_Option_API.DB_MANUALLY);
   newrec_.edi_auto_change_approval := NVL(newrec_.edi_auto_change_approval, Approval_Option_API.DB_MANUALLY);
   newrec_.quick_registered_customer := NVL(newrec_.quick_registered_customer,'NORMAL');
   newrec_.template_customer := NVL(newrec_.template_customer,'NOT_TEMPLATE');
   newrec_.commission_receiver := NVL(newrec_.commission_receiver,'DONOTCREATE');
   newrec_.cust_part_acq_val_level := NVL(newrec_.cust_part_acq_val_level,'NO_ACQ');
   newrec_.cust_part_owner_transfer := NVL(newrec_.cust_part_owner_transfer,'DONT_ALLOW_TRANSFER');
   newrec_.send_change_message := NVL(newrec_.send_change_message,'N');
   newrec_.summarized_source_lines := NVL(newrec_.summarized_source_lines,'Y');
   newrec_.match_type := NVL(newrec_.match_type,'NOAUTO');
   newrec_.print_amounts_incl_tax := NVL(newrec_.print_amounts_incl_tax,'FALSE');
   newrec_.confirm_deliveries := NVL(newrec_.confirm_deliveries,'FALSE');
   newrec_.check_sales_grp_deliv_conf := NVL(newrec_.check_sales_grp_deliv_conf,'FALSE');
   newrec_.handl_unit_at_co_delivery := NVL(newrec_.handl_unit_at_co_delivery,'USE_SITE_DEFAULT');
   newrec_.replicate_doc_text := NVL(newrec_.replicate_doc_text, Doc_Text_Replicate_Option_API.DB_DO_NOT_REPLICATE);
   newrec_.print_delivered_lines := NVL(newrec_.print_delivered_lines, 'SHIPMENT');
   newrec_.summarized_freight_charges := NVL(newrec_.summarized_freight_charges,'Y');  
   newrec_.email_order_conf := NVL(newrec_.email_order_conf, 'TRUE');   
   newrec_.email_invoice := NVL(newrec_.email_invoice, 'TRUE');
   newrec_.mul_tier_del_notification := NVL(newrec_.mul_tier_del_notification, Fnd_Boolean_API.DB_FALSE);   
  
   IF (newrec_.customer_no IS NULL) THEN
      newrec_.customer_no := Client_SYS.Get_Item_Value('CUSTOMER_ID', attr_);
   END IF;

   IF (newrec_.update_price_from_sbi IS NULL) THEN
      newrec_.update_price_from_sbi := 'FALSE';
   END IF;

   IF (newrec_.cycle_period != 0) THEN
      IF (Cust_Invoice_Close_Date_API.Check_Closing_Dates(newrec_.customer_no) = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'NOCYCLEPERIOD: Cycle Interval cannot be defined with Closing Dates.');
      END IF;
   END IF; 
   
   IF (newrec_.acquisition_site IS NOT NULL) THEN  
      -- customer should be of category 'CUSTOMER'
      Customer_Info_API.Exist(newrec_.customer_no, 'CUSTOMER');
      -- Make sure no other customer has been connected to this site  
      site_customer_no_ := Get_Customer_No_From_Contract(newrec_.acquisition_site);
      IF ((site_customer_no_ IS NOT NULL) AND (site_customer_no_ != newrec_.customer_no)) THEN
         Error_SYS.Record_General(lu_name_, 'SITE_CONNECTED: The site :P1 has already been connected to customer :P2',
                                  newrec_.acquisition_site, site_customer_no_);
      END IF;
   END IF; 
   
   super(newrec_, indrec_, attr_);  

   IF (newrec_.adv_inv_full_pay IS NULL) THEN
      newrec_.adv_inv_full_pay := 'FALSE';
   END IF;

   IF (newrec_.release_internal_order IS NULL) THEN
      newrec_.release_internal_order := Approval_Option_API.DB_MANUALLY;
   END IF;      

   IF (newrec_.match_type IS NOT NULL) AND
      (newrec_.match_type != 'NOAUTO') THEN
      IF (newrec_.sbi_auto_approval_user IS NULL) THEN
         Raise_Self_Bill_Appr_Error___;
      END IF;
   ELSE
      newrec_.sbi_auto_approval_user := NULL;
   END IF;
   
   customer_category_  := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);
   IF (customer_category_ = Customer_Category_API.DB_END_CUSTOMER) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDCUSTCATEGORY: Customer :P1 is not of category :P2 or :P3.', newrec_.customer_no, Customer_Category_API.Decode(Customer_Category_API.DB_CUSTOMER), Customer_Category_API.Decode(Customer_Category_API.DB_PROSPECT)); 
   END IF;

   IF newrec_.rec_adv_auto_matching = 'TRUE' AND newrec_.rec_adv_auto_approval_user IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'NORECADVAPPUSER: Receiving advice approval user must be entered if automatic matching is used.');
   END IF;

   IF (newrec_.template_customer = 'TEMPLATE' AND newrec_.template_customer_desc IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NEEDTEMPL: Template customer needs a template description');
   END IF;

   IF (newrec_.discount < -100) OR (newrec_.discount > 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISCOUNT3: Discount must be between -100 and 100!');
   END IF;

   -- Note: make sure that discount % can not be entered without a discount type
   IF ((newrec_.discount >= -100) AND (newrec_.discount <= 100)) AND (newrec_.discount_type IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NODISCOUNTTYPE: Discount % can not be entered without a corresponding Discount Type');
   END IF;

   IF (nvl(newrec_.date_del, trunc(SYSDATE)) < trunc(SYSDATE)) THEN
      Error_SYS.Record_General(lu_name_, 'EXP_DATE_NOT_RCHED: The expiration date :P1 may not be earlier than todays date', newrec_.date_del);
   END IF;

   IF newrec_.confirm_deliveries = 'FALSE' AND newrec_.receiving_advice_type != 'DO_NOT_USE' THEN
      Raise_Deliv_Conf_Error___(newrec_.customer_no);
   END IF;

   IF (newrec_.adv_inv_full_pay = 'TRUE' AND newrec_.customer_no_pay IS NOT NULL) THEN
      Client_SYS.Add_Info(lu_name_, 'ADINVFULLPAY: When Payer exist the Advance Invoice Full Payment check will be done for the Paying Customer.');
   END IF;

   IF (newrec_.category = 'I') THEN
      -- customer should be of category 'CUSTOMER'
      Customer_Info_API.Exist(newrec_.customer_no, 'CUSTOMER');
      Error_SYS.Check_Not_Null(lu_name_, 'ACQUISITION_SITE', newrec_.acquisition_site);
      IF (newrec_.allow_auto_sub_of_parts = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'AUTOSPNOTALLOWD: Automatic sales part substitution is not allowed for internal customers.');       
      END IF;          
   ELSE
      IF (newrec_.mul_tier_del_notification = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'MULTIERDELNOTALL: Multi-tier delivery notification is only applicable to internal customers.');
      END IF;   
   END IF;

   Check_No_Multiple_Payer___(newrec_.customer_no, newrec_.customer_no_pay);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_ord_customer_tab%ROWTYPE,
   newrec_ IN OUT cust_ord_customer_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   exists_                    VARCHAR2(50);
   site_customer_no_          CUST_ORD_CUSTOMER_TAB.customer_no%TYPE;
   commission_receiver_       VARCHAR2(20);
   customer_category_         CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   IF (newrec_.acquisition_site IS NOT NULL) THEN
      -- customer should be of category 'CUSTOMER'
      Customer_Info_API.Exist(newrec_.customer_no, 'CUSTOMER');
      -- Make sure no other customer has been connected to this site
      site_customer_no_ := Get_Customer_No_From_Contract(newrec_.acquisition_site);
      IF ((site_customer_no_ IS NOT NULL) AND (site_customer_no_ != newrec_.customer_no)) THEN
         Error_SYS.Record_General(lu_name_, 'SITE_CONNECTED: The site :P1 has already been connected to customer :P2',
                                  newrec_.acquisition_site, site_customer_no_);
      ELSIF (site_customer_no_ IS NULL) THEN 
         IF (Customer_Order_API.Check_Order_Exist_For_Customer(newrec_.acquisition_site, newrec_.customer_no)) THEN
            Error_SYS.Record_General(lu_name_, 'ORDEREXIST: There exist open customer orders for the customer :P1 from the site :P2. Therefore, the customer cannot be registered as the internal customer of this site.', newrec_.customer_no, newrec_.acquisition_site); 
         END IF;
      END IF;
   END IF;
   IF (newrec_.update_price_from_sbi IS NULL OR newrec_.match_type = 'NOAUTO') THEN
      newrec_.update_price_from_sbi := 'FALSE';
   END IF;

   IF (newrec_.cycle_period != 0) THEN
      IF (Cust_Invoice_Close_Date_API.Check_Closing_Dates(newrec_.customer_no) = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'NOCYCLEPERIOD: Cycle Interval cannot be defined with Closing Dates.');
      END IF;
   ELSE
      newrec_.cycle_period := 0;
      Client_SYS.Add_To_Attr('CYCLE_PERIOD', newrec_.cycle_period, attr_);
   END IF;   
  
   super(oldrec_, newrec_, indrec_, attr_);
   
   customer_category_  := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);
   IF (customer_category_ = Customer_Category_API.DB_END_CUSTOMER) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDCUSTCATEGORY: Customer :P1 is not of category :P2 or :P3.', newrec_.customer_no, Customer_Category_API.Decode(Customer_Category_API.DB_CUSTOMER), Customer_Category_API.Decode(Customer_Category_API.DB_PROSPECT)); 
   END IF;
   
   IF (newrec_.match_type IS NOT NULL) AND
      (newrec_.match_type != 'NOAUTO') THEN
      IF (newrec_.sbi_auto_approval_user IS NULL) THEN
         Raise_Self_Bill_Appr_Error___;
      END IF;
   ELSE
      newrec_.sbi_auto_approval_user := NULL;
   END IF;

   IF newrec_.rec_adv_auto_matching = 'TRUE' AND newrec_.rec_adv_auto_approval_user IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'NORECADVAPPUSER: Receiving advice approval user must be entered if automatic matching is used.');
   END IF;

   IF (newrec_.template_customer = 'TEMPLATE' AND newrec_.template_customer_desc IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NEEDTEMPL: Template customer needs a template description');
   END IF;

   IF (newrec_.template_customer_desc IS NOT NULL AND newrec_.template_customer = 'NOT_TEMPLATE') THEN
      Error_SYS.Record_General(lu_name_, 'NOTTEMPL: You may only enter a template description for a template customer.');
   END IF;

   -- Negative discount should be allowed
   IF (newrec_.discount < -100) OR (newrec_.discount > 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISCOUNT3: Discount must be between -100 and 100!');
   END IF;

   -- Note: make sure that discount % can not be entered without a discount type
   IF ((newrec_.discount >= -100) AND (newrec_.discount <= 100)) AND (newrec_.discount_type IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NODISCOUNTTYPE: Discount % can not be entered without a corresponding Discount Type');
   END IF;

   IF (newrec_.date_del != NVL(oldrec_.date_del, Database_SYS.last_calendar_date_)) THEN
      IF (newrec_.date_del < TRUNC(SYSDATE)) THEN
         Error_SYS.Record_General(lu_name_, 'EXP_DATE_NOT_RCHED: The expiration date :P1 may not be earlier than todays date', newrec_.date_del);
      END IF;
   END IF;

   IF (newrec_.confirm_deliveries != oldrec_.confirm_deliveries) THEN
      IF (newrec_.confirm_deliveries = 'FALSE') AND (newrec_.receiving_advice_type != 'DO_NOT_USE') THEN
         Client_SYS.Add_Info(lu_name_, 'MISSINGDELIVCONF2: Customer :P1 has been set up to use Receiving Advice.', newrec_.customer_no);
      END IF;
   END IF;

   IF (newrec_.receiving_advice_type != oldrec_.receiving_advice_type) THEN
      IF (newrec_.receiving_advice_type != 'DO_NOT_USE') AND (newrec_.confirm_deliveries = 'FALSE') THEN
         Raise_Deliv_Conf_Error___(newrec_.customer_no);
      END IF;
   END IF;

   IF (newrec_.adv_inv_full_pay != oldrec_.adv_inv_full_pay OR
      ((newrec_.customer_no_pay IS NOT NULL AND oldrec_.customer_no_pay IS NULL) OR
      newrec_.customer_no_pay != oldrec_.customer_no_pay)) THEN
      IF (newrec_.adv_inv_full_pay = 'TRUE' AND newrec_.customer_no_pay IS NOT NULL) THEN
         Client_SYS.Add_Info(lu_name_, 'ADINVFULLPAY: When Payer exist the Advance Invoice Full Payment check will be done for the Paying Customer.');
      END IF;
   END IF;

   IF (newrec_.category = 'I') THEN
      -- customer should be of category 'CUSTOMER'
      Customer_Info_API.Exist(newrec_.customer_no, 'CUSTOMER');
      Error_SYS.Check_Not_Null(lu_name_, 'ACQUISITION_SITE', newrec_.acquisition_site);
      IF (newrec_.allow_auto_sub_of_parts = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'AUTOSPNOTALLOWD: Automatic sales part substitution is not allowed for internal customers.');       
      END IF;
   ELSE   
      IF (newrec_.mul_tier_del_notification = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'MULTIERDELNOTALL: Multi-tier delivery notification is only applicable to internal customers.');
      END IF;      
   END IF;

   Check_No_Multiple_Payer___(newrec_.customer_no, newrec_.customer_no_pay);

   IF (newrec_.invoice_sort != oldrec_.invoice_sort) THEN
      IF (newrec_.invoice_sort = 'N') THEN
         Cust_Invoice_Close_Date_API.Remove_Closing_Dates(newrec_.customer_no);
      END IF;
   END IF;

   IF (newrec_.commission_receiver = 'CREATE' AND oldrec_.commission_receiver = 'DONOTCREATE') THEN
      commission_receiver_ := Commission_Receiver_API.Get_Com_Receiver_For_Salesman(newrec_.salesman_code);
      IF Commission_Receiver_API.Check_Exist(commission_receiver_) THEN
         Cust_Def_Com_Receiver_API.New(commission_receiver_, newrec_.customer_no);
      ELSE
         Error_SYS.Record_General(lu_name_, 'CHECK_EXIST_FALSE: Salesperson is not registered as a commission receiver');
      END IF;
   END IF;
   IF (newrec_.commission_receiver = 'DONOTCREATE' AND oldrec_.commission_receiver = 'CREATE') THEN
      commission_receiver_ := Commission_Receiver_API.Get_Com_Receiver_For_Salesman(oldrec_.salesman_code);
      Cust_Def_Com_Receiver_API.Remove(commission_receiver_, oldrec_.customer_no);
   END IF;
   IF (newrec_.commission_receiver = 'CREATE') THEN
      IF (newrec_.salesman_code != oldrec_.salesman_code) THEN
         Error_SYS.Record_General(lu_name_, 'CHG_SALESMAN: Salesperson :P1 cannot be changed while defined as commission receiver', oldrec_.salesman_code);
      END IF;
   END IF;
   IF (newrec_.category != oldrec_.category) THEN
      IF (newrec_.category = 'I') THEN
         IF (Cust_Ord_Customer_Address_API.Check_Cust_Calendar_Id_Entered(newrec_.customer_no) = 1) THEN
            Error_SYS.Record_General(lu_name_, 'CUSTCALENDAREXIST: The customer calendar must be removed from the customer address before it is possible to change from an external to an internal customer');
         END IF;
         Client_SYS.Add_Info(lu_name_, 'CHANGECUSTINTERNAL: Changing customer to an internal customer. The customer calendar data from the customer addresses will no longer be used for new orders. 
If required, go through all open orders and remove the customer calendar and recalculate the orders.');
      ELSE
         Client_SYS.Add_Info(lu_name_, 'CHANGECUSTEXTERNAL: Changing customer to an external customer. Add the customer calendar to the customer addresses to get the correct calendar when new orders are created. 
If required, go through all open orders and add the customer calendar and recalculate the orders.');
      END IF;
   END IF;
END Check_Update___;

PROCEDURE Check_Edi_Auth_Code_Ref___ (
   newrec_ IN OUT cust_ord_customer_tab%ROWTYPE )
IS
   exists_           VARCHAR2(5);
BEGIN
   IF (newrec_.edi_authorize_code IS NOT NULL) THEN
      Order_Coordinator_API.Exist(newrec_.edi_authorize_code, true);
   END IF;   
END Check_Edi_Auth_Code_Ref___;

   
PROCEDURE New_Prospect___(
   new_customer_id_      IN VARCHAR2,      
   new_name_             IN VARCHAR2,
   new_association_no_   IN VARCHAR2,  
   cust_ref_             IN VARCHAR2,
   customer_category_    IN VARCHAR2,
   default_language_     IN VARCHAR2,
   new_country_          IN VARCHAR2,
   del_addr_no_          IN VARCHAR2,   
   del_address1_         IN VARCHAR2,
   del_address2_         IN VARCHAR2,
   del_address3_         IN VARCHAR2,
   del_address4_         IN VARCHAR2,
   del_address5_         IN VARCHAR2,
   del_address6_         IN VARCHAR2,
   del_zip_code_         IN VARCHAR2,
   del_city_             IN VARCHAR2,
   del_state_            IN VARCHAR2, 
   del_county_           IN VARCHAR2,
   del_country_          IN VARCHAR2,
   del_ean_location_     IN VARCHAR2,
   doc_addr_no_          IN VARCHAR2,   
   doc_address1_         IN VARCHAR2,
   doc_address2_         IN VARCHAR2,
   doc_address3_         IN VARCHAR2,
   doc_address4_         IN VARCHAR2,
   doc_address5_         IN VARCHAR2,
   doc_address6_         IN VARCHAR2,
   doc_zip_code_         IN VARCHAR2,
   doc_city_             IN VARCHAR2,
   doc_state_            IN VARCHAR2,
   doc_county_           IN VARCHAR2,
   doc_country_          IN VARCHAR2,
   doc_ean_location_     IN VARCHAR2,
   salesman_code_        IN VARCHAR2,
   ship_via_code_        IN VARCHAR2,
   delivery_terms_       IN VARCHAR2,
   del_terms_location_   IN VARCHAR2, 
   region_code_          IN VARCHAR2,
   district_code_        IN VARCHAR2,
   market_code_          IN VARCHAR2,   
   acquisition_site_     IN VARCHAR2,
   is_internal_customer_ IN VARCHAR2,
   cust_group_           IN VARCHAR2,
   currency_             IN VARCHAR2)
IS   
   newrec_                CUST_ORD_CUSTOMER_TAB%ROWTYPE;
   indrec_                Indicator_Rec;
   count_                 NUMBER := 0;   
   attr_                  VARCHAR2(2000);      
   objid_                 VARCHAR2(2000);
   objversion_            VARCHAR2(2000);                      
   addr_types_            Utility_SYS.STRING_TABLE;
   addr_type_list_        VARCHAR2(600);
   num_types_             NUMBER;
   add_cust_ord_addr_     BOOLEAN := FALSE;
   add_cust_ord_          BOOLEAN := FALSE;
   info_                  VARCHAR2(2000);   
   name_                  VARCHAR2(30);
   temp_                  VARCHAR2(2000);
   value_                 VARCHAR2(2000);
   ptr_                   NUMBER := NULL;
   
BEGIN
   
   Customer_Info_API.New(new_customer_id_, new_name_, Customer_Category_API.Encode(customer_category_), new_association_no_, new_country_, default_language_);
   Address_Type_Code_API.Enumerate_Type(addr_type_list_, Party_Type_API.DB_CUSTOMER);
   Utility_SYS.Tokenize(addr_type_list_, Client_SYS.field_separator_, addr_types_, num_types_);
   -- Insert delviery address information
   IF(del_addr_no_ IS NOT NULL) THEN
      Customer_Info_Address_API.New_Address(new_customer_id_, del_addr_no_, del_address1_, del_address2_, del_zip_code_, del_city_, del_state_, del_country_, del_ean_location_, NULL, NULL, del_county_,del_address3_,del_address4_,del_address5_,del_address6_); 
      count_ := 1;     
      WHILE count_ <= num_types_ LOOP
         IF (doc_addr_no_ IS NOT NULL AND addr_types_(count_) = Address_Type_Code_API.Decode(Address_Type_Code_API.DB_DOCUMENT)) THEN
            Customer_Info_Address_Type_API.New(new_customer_id_, del_addr_no_, addr_types_(count_), 'FALSE');
         ELSE
            Customer_Info_Address_Type_API.New(new_customer_id_, del_addr_no_, addr_types_(count_), 'TRUE');
         END IF;                   
         count_ := count_ + 1;
      END LOOP;    
   END IF;
   IF (doc_addr_no_ IS NOT NULL) THEN
      IF (nvl(del_addr_no_,CHR(2)) <> doc_addr_no_) THEN
         -- Insert document address information
         Customer_Info_Address_API.New_Address(new_customer_id_, doc_addr_no_, doc_address1_, doc_address2_, doc_zip_code_, doc_city_, doc_state_, doc_country_, doc_ean_location_, NULL, NULL, doc_county_,doc_address3_,doc_address4_,doc_address5_,doc_address6_); 
         count_ := 1;
         -- Only create document type if delivery address is created already.
         IF(del_addr_no_ IS NOT NULL) THEN
            Customer_Info_Address_Type_API.New(new_customer_id_, doc_addr_no_, Address_Type_Code_API.Decode(Address_Type_Code_API.DB_DOCUMENT), 'TRUE');  
         ELSE
            WHILE count_ <= num_types_ LOOP               
               Customer_Info_Address_Type_API.New(new_customer_id_, doc_addr_no_, addr_types_(count_), 'TRUE');              
               count_ := count_ + 1;
            END LOOP;
         END IF;
      ELSIF(del_addr_no_ IS NOT NULL) THEN
         Customer_Info_Address_Type_API.Modify_Def_Address(new_customer_id_, del_addr_no_, Address_Type_Code_API.Decode(Address_Type_Code_API.DB_DOCUMENT), 'TRUE');  
      END IF;   
   END IF;   

   Client_SYS.Clear_Attr(attr_);
   
   IF( delivery_terms_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DELIVERY_TERMS', delivery_terms_, attr_);
      add_cust_ord_addr_ := TRUE;
   END IF;
   
   IF( del_terms_location_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', del_terms_location_, attr_);
      add_cust_ord_addr_ := TRUE;
   END IF;

   IF( district_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DISTRICT_CODE', district_code_, attr_);
      add_cust_ord_addr_ := TRUE;
   END IF;
   
   IF( region_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REGION_CODE', region_code_, attr_);
      add_cust_ord_addr_ := TRUE;
   END IF;
   
   IF( ship_via_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_);
      add_cust_ord_addr_ := TRUE;
   END IF;
   
   -- Add record to customer order address
   IF (add_cust_ord_addr_) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_NO', new_customer_id_, attr_);
      Client_SYS.Add_To_Attr('ADDR_NO', del_addr_no_, attr_);      
      Cust_Ord_Customer_Address_API.New(info_, attr_);
   END IF;
              
   Client_SYS.Clear_Attr(attr_);
   
   IF (cust_group_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUST_GRP', cust_group_, attr_);   
      add_cust_ord_ := TRUE;
   END IF;
       
   IF (currency_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CURRENCY_CODE', currency_, attr_); 
      add_cust_ord_ := TRUE;
   END IF;
   IF (salesman_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SALESMAN_CODE', salesman_code_, attr_);
      add_cust_ord_ := TRUE;
   END IF;

   IF (market_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MARKET_CODE', market_code_, attr_);
      add_cust_ord_ := TRUE;
   END IF;

   IF (cust_ref_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUST_REF', cust_ref_, attr_);
      add_cust_ord_ := TRUE;  
   END IF;

   IF is_internal_customer_ = 'TRUE' THEN
      Client_SYS.Add_To_Attr('CATEGORY_DB', 'I', attr_);
      Client_SYS.Add_To_Attr('ACQUISITION_SITE', acquisition_site_, attr_);
      add_cust_ord_ := TRUE;
   END IF;
   
   -- Add cust order information
   IF (add_cust_ord_) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_NO', new_customer_id_, attr_);
      Client_SYS.Add_To_Attr('QUICK_REGISTERED_CUSTOMER_DB', 'QUICK', attr_);
      -- Fetch default values
      Prepare_Insert___(temp_);
      -- Replace default values with the incoming attribute values
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         Client_SYS.Set_Item_Value(name_, value_, temp_);
      END LOOP;

      Unpack___(newrec_, indrec_, temp_);
      Check_Insert___(newrec_, indrec_, temp_);   
      Insert___(objid_, objversion_, newrec_, temp_);

      info_ := Client_SYS.Get_All_Info;
   END IF;

END New_Prospect___;


PROCEDURE Check_Customer_No_Ref___ (
   newrec_ IN OUT NOCOPY cust_ord_customer_tab%ROWTYPE )
IS
   customer_category_         CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   IF (newrec_.customer_no IS NOT NULL) THEN
      customer_category_  := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);     
      Customer_Info_API.Exist(newrec_.customer_no, customer_category_);     
   END IF;
END Check_Customer_No_Ref___;

-- Incr_Identity_Autonomous___
-- Increase the customer identity using autonomous transaction
-- to avoid dead locks.
PROCEDURE Incr_Customer_Id_Autonomous___ (
   customer_id_ OUT VARCHAR2)
IS
   PRAGMA  AUTONOMOUS_TRANSACTION;   
BEGIN
      customer_id_ := Customer_Info_API.Get_Next_Identity();
      Party_Identity_Series_API.Update_Next_Value(customer_id_ + 1, 'CUSTOMER');
      @ApproveTransactionStatement(2017-11-30,chbnlk)
      COMMIT;
   
END Incr_Customer_Id_Autonomous___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
@UncheckedAccess
PROCEDURE Exist (
   customer_no_ IN VARCHAR2,
   customer_category_ IN VARCHAR2 DEFAULT 'CUSTOMER')
IS   
BEGIN     
   Customer_Info_API.Exist(customer_no_, customer_category_);
   IF (NOT Check_Exist___(customer_no_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_,'ORDERATTR: Customer :P1 has no delivery address with order specific attributes specified.', customer_no_);
   END IF;
   super(customer_no_);
END Exist; 

-- Get_Name
--   Returns the customer name
@UncheckedAccess
FUNCTION Get_Name (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   customer_name_       VARCHAR2(100) := NULL;
   customer_category_   CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   customer_category_  := Customer_Info_API.Get_Customer_Category_Db(customer_no_); 
   IF (Customer_Info_API.Check_Exist(customer_no_, customer_category_) = 'TRUE') THEN
      customer_name_ := Customer_Info_API.Get_Name(customer_no_);
   END IF;
   RETURN customer_name_;
END Get_Name;


-- Modify_Last_Ivc_Date
--   Updates Last Ivc Date to SYSDATE
--   Modify last invoice date to todays date when invoice for the customer
--   has been created
PROCEDURE Modify_Last_Ivc_Date (
   customer_no_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   oldrec_     CUST_ORD_CUSTOMER_TAB%ROWTYPE;
   newrec_     CUST_ORD_CUSTOMER_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(customer_no_);
   newrec_ := oldrec_ ;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('LAST_IVC_DATE', trunc(SYSDATE), attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Last_Ivc_Date;


-- Get_Document_Address
--   Get customers document address
@UncheckedAccess
FUNCTION Get_Document_Address (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   addr_no_ CUST_ORD_CUSTOMER_ADDRESS.addr_no%TYPE;

   CURSOR get_address IS
      SELECT MIN(cit.address_id)
      FROM   customer_info_address_public cia, customer_info_address_type_pub cit
      WHERE  cia.customer_id = customer_no_
      AND    cia.customer_id = cit.customer_id
      AND    cia.address_id  = cit.address_id
      AND    cit.address_type_code_db = 'INVOICE'
      AND    TRUNC(SYSDATE) BETWEEN NVL(cia.valid_from, Database_SYS.Get_First_Calendar_Date())
      AND    NVL(cia.valid_to, Database_SYS.Get_Last_Calendar_Date());
BEGIN

   addr_no_ := Customer_Info_Address_API.Get_Id_By_Type(customer_no_, Address_Type_Code_API.Decode('INVOICE'));
   IF addr_no_ IS NULL THEN
      OPEN get_address;
      FETCH get_address INTO addr_no_;
      IF get_address%NOTFOUND THEN
         CLOSE get_address;
         RETURN NULL;
      ELSE
         CLOSE get_address;
         RETURN addr_no_;
      END IF;
   END IF;
   RETURN addr_no_;
END Get_Document_Address;


-- Get_Delivery_Address
--   Get customers delivery address
@UncheckedAccess
FUNCTION Get_Delivery_Address (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   addr_no_             CUST_ORD_CUSTOMER_ADDRESS.addr_no%TYPE;
   site_date_           DATE;
   first_calendar_date_ DATE;
   last_calendar_date_  DATE;
 
   CURSOR get_address IS
      SELECT MIN(cit.address_id)
      FROM   customer_info_address_public cia, customer_info_address_type_pub cit
      WHERE  cia.customer_id = customer_no_
      AND    cia.customer_id = cit.customer_id
      AND    cia.address_id  = cit.address_id
      AND    cit.address_type_code_db = 'DELIVERY'
      AND    site_date_ BETWEEN NVL(cia.valid_from, first_calendar_date_)
                        AND     NVL(cia.valid_to,   last_calendar_date_);
BEGIN
   -- Retrieves the default delivery address
   addr_no_ := Customer_Info_Address_API.Get_Id_By_Type(customer_no_, Address_Type_Code_API.Decode('DELIVERY'));
   IF (addr_no_ IS NULL) THEN
      site_date_ := TRUNC(NVL(Site_API.Get_Site_Date(User_Default_API.Get_Contract), SYSDATE));
      first_calendar_date_ := Database_SYS.Get_First_Calendar_Date();
      last_calendar_date_  := Database_SYS.Get_Last_Calendar_Date();
      
      OPEN get_address;
      FETCH get_address INTO addr_no_;
      IF get_address%NOTFOUND THEN
         CLOSE get_address;
         RETURN NULL;
      ELSE
         CLOSE get_address;
         RETURN addr_no_;
      END IF;
   END IF;
   RETURN addr_no_;
END Get_Delivery_Address;


-- Get_Visit_Address
--   Get customers visit address
@UncheckedAccess
FUNCTION Get_Visit_Address (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   addr_no_ CUST_ORD_CUSTOMER_ADDRESS.addr_no%TYPE;

   CURSOR get_default IS
      SELECT addr_no
      FROM   CUST_ORD_CUSTOMER_ADDRESS_TAB
      WHERE  customer_no = customer_no_
      AND    Cust_Ord_Customer_Address_API.Is_Default_Visit_Location__(customer_no, addr_no) = 1
      AND    Cust_Ord_Customer_Address_API.Is_Valid(customer_no, addr_no) = 1;

   CURSOR get_address IS
      SELECT MIN(addr_no)
      FROM   CUST_ORD_CUSTOMER_ADDRESS_TAB
      WHERE  customer_no = customer_no_
      AND    Cust_Ord_Customer_Address_API.Is_Visit_Location(customer_no, addr_no) = 1
      AND    Cust_Ord_Customer_Address_API.Is_Valid(customer_no, addr_no) = 1;
BEGIN
   OPEN get_default;
   FETCH get_default INTO addr_no_;
   IF get_default%FOUND THEN
      CLOSE get_default;
      RETURN addr_no_;
   END IF;
   CLOSE get_default;

   OPEN get_address;
   FETCH get_address INTO addr_no_;
   IF get_address%NOTFOUND THEN
      CLOSE get_address;
      RETURN NULL;
   ELSE
      CLOSE get_address;
      RETURN addr_no_;
   END IF;
END Get_Visit_Address;


-- Get_Customer_No_From_Contract
--   Retrive the custmor number connected to the specified acquisition site.
--   This may be done only for an internal customer.
@UncheckedAccess
FUNCTION Get_Customer_No_From_Contract (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   customer_no_  CUST_ORD_CUSTOMER_TAB.customer_no%TYPE;

   CURSOR get_customer IS
      SELECT customer_no
      FROM   CUST_ORD_CUSTOMER_TAB
      WHERE  acquisition_site = contract_
      AND    category = 'I';
BEGIN
   OPEN get_customer;
   FETCH get_customer INTO customer_no_;
   IF (get_customer%NOTFOUND) THEN
      CLOSE get_customer;
      RETURN NULL;
   ELSE
      CLOSE get_customer;
      RETURN customer_no_;
   END IF;
END Get_Customer_No_From_Contract;


-- Get_Language_Code
--   Returns the language code retrieved from Enterprise
@UncheckedAccess
FUNCTION Get_Language_Code (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Iso_Language_API.Encode(Customer_Info_API.Get_Default_Language(customer_no_));
END Get_Language_Code;


-- Get_Default_Media_Code
--   Retrieve the default media code for the specified message type.
--   If no media code has been defined return NULL
@UncheckedAccess
FUNCTION Get_Default_Media_Code (
   customer_no_   IN VARCHAR2,
   message_class_ IN VARCHAR2,
   company_       IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   media_code_    VARCHAR2(30) := NULL;
BEGIN
   IF (company_ IS NOT NULL AND message_class_ = 'INVOIC') THEN
      media_code_ := Customer_Inv_Msg_Setup_API.Get_Default_Media_Code(company_       => company_,
                                                                       customer_id_   => customer_no_,
                                                                       party_type_    => 'CUSTOMER',
                                                                       message_class_ => message_class_);
   ELSE
      media_code_ := Customer_Info_Msg_Setup_API.Get_Default_Media_Code(customer_id_   => customer_no_,
                                                                        message_class_ => message_class_);
   END IF;
   RETURN media_code_;
END Get_Default_Media_Code;


-- Get_Default_E_Mail
--   Returns the default email address if any conenected
@UncheckedAccess
FUNCTION Get_Default_E_Mail (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Comm_Method_API.Get_Default_Value('CUSTOMER', customer_no_, 'E_MAIL');
END Get_Default_E_Mail;


-- Get_Price_List_No
--   Return always NULL. For compability reasons only (used in IFS/Maintanance).
@UncheckedAccess
FUNCTION Get_Price_List_No (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   -- For compability reasons only (used in IFS/Maintanance).
   RETURN NULL;
END Get_Price_List_No;


-- New
--   Public interface for creating a new customer.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   ptr_        NUMBER := NULL;
   newrec_     CUST_ORD_CUSTOMER_TAB%ROWTYPE;
   name_       VARCHAR2(30);
   temp_       VARCHAR2(2000);
   value_      VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   -- Fetch default values
   Prepare_Insert___(temp_);
   -- Replace default values with the incoming attribute values
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, temp_);
   END LOOP;

   Unpack___(newrec_, indrec_, temp_);
   Check_Insert___(newrec_, indrec_, temp_);   
   Insert___(objid_, objversion_, newrec_, temp_);

   info_ := Client_SYS.Get_All_Info;
   attr_ := temp_;
END New;

-- Modify
--   Public interface for modifying customer order info.
PROCEDURE Modify (
   attr_        IN OUT VARCHAR2,
   customer_id_ IN     VARCHAR2)
IS 
   oldrec_       cust_ord_customer_tab%ROWTYPE;
   newrec_       cust_ord_customer_tab%ROWTYPE;  
   indrec_       Indicator_Rec;
   objid_        cust_ord_customer.objid%TYPE;
   objversion_   cust_ord_customer.objversion%TYPE;
BEGIN
   oldrec_ := Lock_By_Keys___(customer_id_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify;

-- Customer_Is_Credit_Stopped
--   Check if the customer is credit stopped or not.
--   If the Payment module is installed the method will check the value set
--   for CreditBlock in Payment for the customer.
--   If Payment is not installed the return value will be based on the value
--   for the CrStop flag for the customer in Customer Orders.
--   Return TRUE (1) if the customer is credit stopped, FALSE (0) if not.
@UncheckedAccess
FUNCTION Customer_Is_Credit_Stopped (
   customer_no_ IN VARCHAR2,
   company_     IN VARCHAR2 ) RETURN NUMBER
IS
   fin_cr_block_ VARCHAR2(20);
   ret_val_      NUMBER := 0;
BEGIN
   $IF (Component_PAYLED_SYS.INSTALLED) $THEN
      fin_cr_block_ :=  Customer_Credit_Info_API.Is_Credit_Block(company_, customer_no_);  
      
      fin_cr_block_ := NVL(fin_cr_block_, 'FALSE');
      IF (fin_cr_block_ = 'TRUE') THEN
         ret_val_ := 1;
      END IF;
   $ELSE
      IF (Get_Cr_Stop(customer_no_) = Customer_Credit_Block_API.Decode('Y')) THEN 
      ret_val_ := 1;
   END IF;
   $END   
   RETURN ret_val_;
END Customer_Is_Credit_Stopped;

PROCEDURE Get_Cust_Credit_Stop_Detail (
   credit_block_ OUT NUMBER,
   attr_         OUT VARCHAR2,
   customer_no_  IN VARCHAR2,
   company_      IN VARCHAR2 )
IS
   check_credit_block_   VARCHAR2(10);
BEGIN
   credit_block_ := 0;
   $IF (Component_Payled_SYS.INSTALLED) $THEN
      Customer_Credit_Info_API.Get_Credit_Block_Info(check_credit_block_, attr_, company_, customer_no_);
      
      IF (check_credit_block_ = 'TRUE') THEN
         credit_block_ := 1;
      END IF;
   $ELSE
      IF (Get_Cr_Stop(customer_no_) = Customer_Credit_Block_API.Decode('Y')) THEN 
      credit_block_ := 1;
   END IF;
   $END 
END Get_Cust_Credit_Stop_Detail;


-- Validate_Customer_Calendar
--   The function Validate_Customer_Calendar checks for the calendar validations
--   and customer category validations on the customer.
PROCEDURE Validate_Customer_Calendar (
   customer_no_      IN VARCHAR2,
   cust_calendar_id_ IN VARCHAR2,
   raise_error_      IN BOOLEAN)
IS
BEGIN
   IF (cust_calendar_id_ IS NOT NULL) THEN
      Work_Time_Calendar_API.Check_Not_Generated(cust_calendar_id_);
      IF (Cust_Ord_Customer_Category_API.Encode(Get_Category(customer_no_)) = 'I' AND raise_error_) THEN
         Error_SYS.Record_General(lu_name_, 'CALENDARONINTERNALCUST: Cannot modify the customer calendar of the internal customer.');
      END IF;
   END IF;
END Validate_Customer_Calendar;


-- Copy_Customer
--   The function Copy_Customer Copies the customer information in
--   Cust_Ord_Customer_Tab to a new customer id
PROCEDURE Copy_Customer (
   customer_no_ IN VARCHAR2,
   new_id_      IN VARCHAR2,
   copy_info_   IN  Customer_Info_API.Copy_Param_Info)
IS
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(32000);
   tempattr_         VARCHAR2(32000);
   newrec_       CUST_ORD_CUSTOMER_TAB%ROWTYPE;
   rec_          CUST_ORD_CUSTOMER_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
   customer_note_id_ NUMBER;   
   dummy_            NUMBER;
   oldrec_           CUST_ORD_CUSTOMER_TAB%ROWTYPE;     
   ptr_              NUMBER;
   name_             VARCHAR2(30);
   value_            VARCHAR2(2000);
   
   CURSOR get_attr IS
      SELECT *
        FROM CUST_ORD_CUSTOMER_TAB
        WHERE customer_no = customer_no_;
   CURSOR check_exist IS
      SELECT 1
        FROM CUST_ORD_CUSTOMER_TAB
        WHERE customer_no = new_id_;  
BEGIN

   Trace_SYS.Field('FROM CUSTOMER_NO', customer_no_);
   Trace_SYS.Field('NEW CUSTOMER_NO', new_id_);
   -- If changing the customer category then keep the records as it is or update missing information according to overwrite data setting.
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   IF check_exist%FOUND THEN
      CLOSE check_exist;
      OPEN get_attr;
      FETCH get_attr INTO rec_;
      IF get_attr%FOUND THEN
         CLOSE get_attr;
         rec_.customer_no := NULL; 
         rec_.acquisition_site := NULL; 
         rec_.category := NULL; 
         rec_.note_id := NULL; 
         rec_.template_customer := NULL;
         rec_.template_customer_desc := NULL;
         rec_.mul_tier_del_notification := 'FALSE';
         -- Make the template attr
         tempattr_ := Pack___(rec_);
         oldrec_ := Lock_By_Keys___(new_id_);
         Get_Id_Version_By_Keys___(objid_, objversion_, new_id_);             

         newrec_ := oldrec_;
         -- If overwrite data is not applied then preserve the original record information
         IF (copy_info_.overwrite_order_data = 'FALSE') THEN
            -- Make the existing record attr
            attr_ := Pack___(newrec_);
            attr_ := Client_SYS.Remove_Attr('CUSTOMER_NO', attr_);
            attr_ := Client_SYS.Remove_Attr('NOTE_ID', attr_);

            --Replace the template attribute values with the ones with original rec values.
            ptr_ := NULL;
            WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
               IF (value_ IS NOT NULL) THEN
                  Client_SYS.Set_Item_Value(name_, value_, tempattr_);
               END IF;
            END LOOP;
         END IF;
         Unpack___(newrec_, indrec_, tempattr_);
         Check_Update___(oldrec_, newrec_, indrec_, tempattr_);
         Update___(objid_, oldrec_, newrec_, tempattr_, objversion_);
      ELSE
         CLOSE get_attr;
      END IF;
      RETURN;
   ELSE
      CLOSE check_exist;
   END IF;       
  
   OPEN get_attr;
   FETCH get_attr INTO rec_;
   IF get_attr%FOUND THEN
      attr_ := Pack___(rec_);
      Client_SYS.Set_Item_Value('CUSTOMER_NO', new_id_, attr_);
      -- Update the value for internal customer, the site connection from existing customer.
      Client_SYS.Set_Item_Value('CATEGORY_DB', 'E', attr_);
      Client_SYS.Set_Item_Value('ACQUISITION_SITE', '', attr_);
      Client_SYS.Set_Item_Value('QUICK_REGISTERED_CUSTOMER_DB', 'QUICK', attr_);
      Client_SYS.Set_Item_Value('TEMPLATE_CUSTOMER_DB', 'NOT_TEMPLATE', attr_);
      Client_SYS.Set_Item_Value('TEMPLATE_CUSTOMER_DESC', '', attr_);
      Client_SYS.Set_Item_Value('MUL_TIER_DEL_NOTIFICATION_DB', 'FALSE', attr_);
      Client_SYS.Set_Item_Value('B2B_AUTO_CREATE_CO_FROM_SQ_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   
      customer_note_id_ := Cust_Ord_Customer_API.Get_Note_Id(customer_no_);

      newrec_.note_id := Document_Text_API.Get_Next_Note_Id;

      Client_SYS.Set_Item_Value('NOTE_ID',newrec_.note_id, attr_);
      Document_Text_API.Copy_All_Note_Texts(customer_note_id_, newrec_.note_id);

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_); 
      Insert___(objid_, objversion_, newrec_, attr_);
      Client_SYS.Clear_Info;
      CLOSE get_attr;
   ELSE
      CLOSE get_attr;
   END IF;
END Copy_Customer;


-- Get_Discount_Class
--   Kept for maintenance 2000 compatibility only. Returns the discount for the customer.
--   The function Get_Discount_Class is used by Maintenance 2000 release ONLY.
@UncheckedAccess
FUNCTION Get_Discount_Class (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_        CUST_ORD_CUSTOMER_TAB.discount%TYPE;
   discount_    VARCHAR2(10);
   CURSOR get_attr IS
      SELECT discount
      FROM CUST_ORD_CUSTOMER_TAB
      WHERE customer_no = customer_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   discount_ := to_char(temp_);
   RETURN discount_;
END Get_Discount_Class;


-- New_Customer_From_Template
--   This function creates a new customer from a template customer.
PROCEDURE New_Customer_From_Template (
   new_customer_id_      IN OUT VARCHAR2,
   template_customer_id_ IN VARCHAR2,
   company_              IN VARCHAR2,
   new_name_             IN VARCHAR2,
   new_association_no_   IN VARCHAR2,
   cust_ref_             IN VARCHAR2,
   customer_category_    IN VARCHAR2,
   default_language_     IN VARCHAR2,
   new_country_          IN VARCHAR2,
   del_addr_no_          IN VARCHAR2,
   del_name_             IN VARCHAR2,
   del_address1_         IN VARCHAR2,
   del_address2_         IN VARCHAR2,
   del_address3_         IN VARCHAR2,
   del_address4_         IN VARCHAR2,
   del_address5_         IN VARCHAR2,
   del_address6_         IN VARCHAR2,
   del_zip_code_         IN VARCHAR2,
   del_city_             IN VARCHAR2,
   del_state_            IN VARCHAR2,
   del_county_           IN VARCHAR2,
   del_country_          IN VARCHAR2,
   del_ean_location_     IN VARCHAR2,
   doc_addr_no_          IN VARCHAR2,
   doc_name_             IN VARCHAR2,
   doc_address1_         IN VARCHAR2,
   doc_address2_         IN VARCHAR2,
   doc_address3_         IN VARCHAR2,
   doc_address4_         IN VARCHAR2,
   doc_address5_         IN VARCHAR2,
   doc_address6_         IN VARCHAR2,
   doc_zip_code_         IN VARCHAR2,
   doc_city_             IN VARCHAR2,
   doc_state_            IN VARCHAR2,
   doc_county_           IN VARCHAR2,
   doc_country_          IN VARCHAR2,
   doc_ean_location_     IN VARCHAR2,
   salesman_code_        IN VARCHAR2,
   ship_via_code_        IN VARCHAR2,
   delivery_terms_       IN VARCHAR2,
   del_terms_location_   IN VARCHAR2,
   region_code_          IN VARCHAR2,
   district_code_        IN VARCHAR2,
   market_code_          IN VARCHAR2,
   pay_term_id_          IN VARCHAR2,
   acquisition_site_     IN VARCHAR2,
   is_internal_customer_ IN VARCHAR2,
   cust_group_           IN VARCHAR2,
   currency_             IN VARCHAR2,
   main_rep_             IN VARCHAR2 DEFAULT NULL,
   current_form_         IN VARCHAR2 DEFAULT NULL)
IS
   oldrec_                CUST_ORD_CUSTOMER_TAB%ROWTYPE;
   newrec_                CUST_ORD_CUSTOMER_TAB%ROWTYPE;
   indrec_                Indicator_Rec;
   count_                 NUMBER := 0;
   addr1_                 VARCHAR2(2000);
   attr_                  VARCHAR2(2000);
   copy_attr_             VARCHAR2(2000);
   info_                  VARCHAR2(2000);
   objid_                 VARCHAR2(2000);
   objversion_            VARCHAR2(2000);
   document_addr_id_      CUST_ORD_CUSTOMER_ADDRESS.addr_no%TYPE;
   delivery_def_addr_     CUST_ORD_CUSTOMER_ADDRESS.addr_no%TYPE;
   order_data_defined_    NUMBER;
   cust_addr_rec_         Cust_Ord_Customer_Address_API.Public_Rec;   
   address_valid_from_    DATE;
   adress_valid_to_       DATE;
   validation_result_     VARCHAR2(20);
   validation_flag_       VARCHAR2(20);    

   CURSOR get_addr_id IS
      SELECT ADDRESS_ID
      FROM customer_info_address_public
      WHERE CUSTOMER_ID = new_customer_id_;

   CURSOR order_data_defined(addr_id_ VARCHAR2) IS
      SELECT 1
      FROM   CUST_ORD_CUSTOMER_ADDRESS_TAB
      WHERE  customer_no = new_customer_id_
      AND    addr_no = addr_id_;
BEGIN
   --Creating new instance of customer, copy of template.
   IF (new_customer_id_ IS NULL) THEN
      Incr_Customer_Id_Autonomous___(new_customer_id_);
   END IF;
   -- If Prospect or End Customer
   IF (template_customer_id_ IS NULL) THEN      
      New_Prospect___(new_customer_id_, new_name_, new_association_no_ , cust_ref_, customer_category_ , default_language_, new_country_, del_addr_no_, del_address1_,
                      del_address2_,del_address3_,del_address4_,del_address5_,del_address6_, del_zip_code_, del_city_, del_state_, del_county_, del_country_, del_ean_location_, doc_addr_no_, doc_address1_,
                      doc_address2_,doc_address3_,doc_address4_,doc_address5_,doc_address6_, doc_zip_code_, doc_city_, doc_state_, doc_county_, doc_country_, doc_ean_location_, salesman_code_, ship_via_code_,
                      delivery_terms_, del_terms_location_, region_code_, district_code_, market_code_, acquisition_site_, is_internal_customer_, cust_group_, currency_);
   ELSE    
      IF (Template_Customer_API.Encode(Get_Template_Customer(template_customer_id_)) = 'TEMPLATE') THEN
         Customer_Info_API.Copy_Existing_Customer(template_customer_id_, new_customer_id_, company_, new_name_, customer_category_, new_association_no_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'NOTTEMPCUST: The customer :P1 cannot be used as a template customer', template_customer_id_);
      END IF;
      
      IF (default_language_ IS NOT NULL OR new_country_ IS NOT NULL) THEN
         Customer_Info_API.Modify(new_customer_id_, new_name_, new_association_no_, nvl(new_country_, Customer_Info_API.Get_Country(new_customer_id_)), nvl(default_language_, Customer_Info_API.Get_Default_Language(new_customer_id_)));
      END IF;

      IF (del_address1_ IS NOT NULL OR del_address2_ IS NOT NULL OR del_address3_ IS NOT NULL OR del_address4_ IS NOT NULL OR del_address5_ IS NOT NULL OR del_address6_ IS NOT NULL OR 
          del_zip_code_ IS NOT NULL OR del_city_ IS NOT NULL OR del_state_ IS NOT NULL OR del_county_ IS NOT NULL OR del_country_ IS NOT NULL) THEN
         Client_SYS.Clear_Attr(copy_attr_);
         Client_SYS.Add_To_Attr('NAME', del_name_, copy_attr_);
         Client_SYS.Add_To_Attr('ADDRESS1', del_address1_, copy_attr_);
         Client_SYS.Add_To_Attr('ADDRESS2', del_address2_, copy_attr_);
         Client_SYS.Add_To_Attr('ADDRESS3', del_address3_, copy_attr_);
         Client_SYS.Add_To_Attr('ADDRESS4', del_address4_, copy_attr_);
         Client_SYS.Add_To_Attr('ADDRESS5', del_address5_, copy_attr_);
         Client_SYS.Add_To_Attr('ADDRESS6', del_address6_, copy_attr_);
         Client_SYS.Add_To_Attr('ZIP_CODE', del_zip_code_, copy_attr_);
         Client_SYS.Add_To_Attr('CITY', del_city_, copy_attr_);
         Client_SYS.Add_To_Attr('STATE', del_state_, copy_attr_);
         Client_SYS.Add_To_Attr('COUNTY', del_county_, copy_attr_);
         Client_SYS.Add_To_Attr('COUNTRY', del_country_, copy_attr_);
         
         -- Retrieve the default delivery address id.
         delivery_def_addr_ := Customer_Info_Address_API.Get_Default_Address(new_customer_id_, Address_Type_Code_Api.Decode('DELIVERY'));

         --Modifying address data for the new customer. Setting the delivery address for all existing address id:s.
         FOR addr_id_ IN get_addr_id LOOP
            count_ := count_ + 1;
            addr1_ := addr_id_.address_id;
            attr_ := copy_attr_;

            IF (del_ean_location_ IS NOT NULL AND addr1_ = delivery_def_addr_ ) THEN
               Client_SYS.Add_To_Attr('EAN_LOCATION', del_ean_location_, attr_);
            END IF;

            Customer_Info_Address_API.Modify_Address(new_customer_id_, addr1_, attr_);

            -- Make sure order data has been defined for the customer before modifying
            OPEN order_data_defined(addr1_);
            FETCH order_data_defined INTO order_data_defined_;
            IF (order_data_defined%NOTFOUND) THEN
               order_data_defined_ := 0;
            END IF;
            CLOSE order_data_defined;

            IF (order_data_defined_ = 1) THEN               
               cust_addr_rec_ := Cust_Ord_Customer_Address_API.Get(template_customer_id_, addr1_);

               --If the data differs from that on the template customer: Modify the address record for the new customer.
               IF (NVL(ship_via_code_, CHR(2)) != NVL(cust_addr_rec_.ship_via_code, CHR(2)) OR
                   NVL(delivery_terms_, CHR(2)) != NVL(cust_addr_rec_.delivery_terms, CHR(2)) OR
                   NVL(del_terms_location_, CHR(2)) != NVL(cust_addr_rec_.del_terms_location, CHR(2)) OR
                   NVL(region_code_, CHR(2)) != NVL(cust_addr_rec_.region_code, CHR(2)) OR
                   NVL(district_code_, CHR(2)) != NVL(cust_addr_rec_.district_code, CHR(2))) THEN
                  Client_SYS.Add_To_Attr('DELIVERY_TERMS', NVL(delivery_terms_, cust_addr_rec_.delivery_terms), attr_);
                  Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', NVL(del_terms_location_, cust_addr_rec_.del_terms_location), attr_);
                  Client_SYS.Add_To_Attr('DISTRICT_CODE', NVL(district_code_, cust_addr_rec_.district_code), attr_);
                  Client_SYS.Add_To_Attr('REGION_CODE', NVL(region_code_, cust_addr_rec_.region_code), attr_);
                  Client_SYS.Add_To_Attr('SHIP_VIA_CODE', NVL(ship_via_code_, cust_addr_rec_.ship_via_code), attr_);
               END IF;
               Cust_Ord_Customer_Address_API.Modify(info_, attr_, new_customer_id_, addr1_);
            END IF;
         END LOOP;

         IF (count_ = 0) THEN
            Error_SYS.Record_General(lu_name_, 'NOADDR: The address info for template customer :P1 is not complete', template_customer_id_);
         END IF;
      END IF;

      --Modifying salesman_code, market_code and cust_ref.
      oldrec_ := Lock_By_Keys___(new_customer_id_);
      newrec_ := oldrec_ ;

      Client_SYS.Clear_Attr(attr_);

      IF (salesman_code_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('SALESMAN_CODE', salesman_code_, attr_);
      END IF;

      IF (market_code_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('MARKET_CODE', market_code_, attr_);
      END IF;

      IF (cust_ref_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('CUST_REF', cust_ref_, attr_);
      ELSIF (cust_addr_rec_.contact IS NOT NULL)  THEN
         Client_SYS.Add_To_Attr('CUST_REF', cust_addr_rec_.contact, attr_);
      END IF;

      IF is_internal_customer_ = 'TRUE' THEN
         Client_SYS.Add_To_Attr('CATEGORY_DB', 'I', attr_);
         Client_SYS.Add_To_Attr('ACQUISITION_SITE', acquisition_site_, attr_);
      END IF;
      
      IF (cust_group_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('CUST_GRP', cust_group_, attr_);         
      END IF;
       
      IF (currency_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('CURRENCY_CODE', currency_, attr_);         
      END IF;

      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

      --Modifying payment terms.
      Client_SYS.Clear_Attr(attr_);
      Trace_SYS.Field('pay_term_id_', pay_term_id_);
      -- Only allow customer to add payment terms.
      IF (pay_term_id_ IS NOT NULL AND Customer_Category_API.Encode(customer_category_) = Customer_Category_API.DB_CUSTOMER) THEN
         Client_SYS.Add_To_Attr('PAY_TERM_ID', pay_term_id_, attr_);
         -- Identity_Invoice_Info_API.Modify(company_, new_customer_id_, 'CUSTOMER', attr_);
         Trace_SYS.Field('1 attr_', attr_);
         IF (Identity_Invoice_Info_API.Exists_Db(company_, new_customer_id_, 'CUSTOMER')) THEN 
            Identity_Invoice_Info_API.Modify(company_, new_customer_id_, 'CUSTOMER', attr_); 
         END IF;
         Trace_SYS.Field('2 attr_', attr_);
      END IF;

      --Modifying document address data if document address data exists.
      IF (doc_address1_ IS NOT NULL OR doc_address2_ IS NOT NULL OR doc_address3_ IS NOT NULL OR doc_address4_ IS NOT NULL OR doc_address5_ IS NOT NULL OR doc_address6_ IS NOT NULL OR 
          doc_zip_code_ IS NOT NULL OR doc_city_ IS NOT NULL OR doc_state_ IS NOT NULL OR doc_county_ IS NOT NULL OR doc_country_ IS NOT NULL) THEN

         -- Retrieve the default document address id.
         document_addr_id_  := Customer_Info_Address_API.Get_Default_Address(new_customer_id_, Address_Type_Code_Api.Decode('INVOICE'));

         --Modifying document address data if a separate document address exists on the template customer.
         IF (delivery_def_addr_ != document_addr_id_) THEN

            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('NAME', doc_name_, attr_);
            Client_SYS.Add_To_Attr('ADDRESS1', doc_address1_, attr_);
            Client_SYS.Add_To_Attr('ADDRESS2', doc_address2_, attr_);
            Client_SYS.Add_To_Attr('ADDRESS3', doc_address3_, attr_);
            Client_SYS.Add_To_Attr('ADDRESS4', doc_address4_, attr_);
            Client_SYS.Add_To_Attr('ADDRESS5', doc_address5_, attr_);
            Client_SYS.Add_To_Attr('ADDRESS6', doc_address6_, attr_);
            Client_SYS.Add_To_Attr('ZIP_CODE', doc_zip_code_, attr_);
            Client_SYS.Add_To_Attr('CITY', doc_city_, attr_);
            Client_SYS.Add_To_Attr('STATE', doc_state_, attr_);
            Client_SYS.Add_To_Attr('COUNTY', doc_county_, attr_);
            Client_SYS.Add_To_Attr('COUNTRY', doc_country_, attr_);
            Client_SYS.Add_To_Attr('EAN_LOCATION', doc_ean_location_, attr_);
            Customer_Info_Address_API.Modify_Address(new_customer_id_, document_addr_id_, attr_);

            -- Create or modify order address with doc_name_
            -- Make sure order data has been defined for the customer before modifying

            OPEN order_data_defined(document_addr_id_);
            FETCH order_data_defined INTO order_data_defined_;
            IF (order_data_defined%NOTFOUND) THEN
               order_data_defined_ := 0;
            END IF;
            CLOSE order_data_defined;

            Client_SYS.Clear_Attr(attr_);            
            IF (cust_ref_ IS NULL) THEN
               Client_SYS.Add_To_Attr('CONTACT', cust_addr_rec_.contact, attr_);
            ELSE
               Client_SYS.Add_To_Attr('CONTACT', cust_ref_, attr_);
            END IF;
            IF (order_data_defined_ = 1) THEN
               Cust_Ord_Customer_Address_API.Modify(info_, attr_, new_customer_id_, document_addr_id_);
            END IF;
         ELSIF(NVL(del_name_, CHR(2))           <> NVL(doc_name_, CHR(2))  OR 
               NVL(del_address1_, CHR(2))       <> NVL(doc_address1_, CHR(2)) OR 
               NVL(del_address2_, CHR(2))       <> NVL(doc_address2_, CHR(2)) OR
               NVL(del_address3_, CHR(2))       <> NVL(doc_address3_, CHR(2)) OR 
               NVL(del_address4_, CHR(2))       <> NVL(doc_address4_, CHR(2)) OR 
               NVL(del_address5_, CHR(2))       <> NVL(doc_address5_, CHR(2)) OR 
               NVL(del_address6_, CHR(2))       <> NVL(doc_address6_, CHR(2)) OR 
               NVL(del_zip_code_, CHR(2))       <> NVL(doc_zip_code_, CHR(2)) OR 
               NVL(del_city_, CHR(2))           <> NVL(doc_city_, CHR(2)) OR 
               NVL(del_state_, CHR(2))          <> NVL(doc_state_, CHR(2)) OR
               NVL(del_county_, CHR(2))         <> NVL(doc_county_, CHR(2)) OR 
               NVL(del_country_, CHR(2))        <> NVL(doc_country_, CHR(2)) OR
               NVL(del_ean_location_, CHR(2))   <> NVL(doc_ean_location_, CHR(2))) THEN
            -- Only create new address if above delivery and document information are different.
            address_valid_from_ := Customer_Info_Address_API.Get_Valid_From(new_customer_id_, document_addr_id_);
            adress_valid_to_    := Customer_Info_Address_API.Get_Valid_To(new_customer_id_, document_addr_id_);
            -- Check if default document address already exsists.
            Customer_Info_Address_Type_API.Check_Def_Address_Exist(validation_result_, validation_flag_, new_customer_id_ 
                                                                   , 'TRUE', address_Type_Code_API.Decode('INVOICE') 
                                                                   ,  NULL, address_valid_from_, adress_valid_to_);
            IF (validation_result_ = 'FALSE') THEN
               -- Remove default address tick from other document addresses, since a new one is going to get created from below.
               Customer_Info_Address_Type_API.Check_Def_Addr_Temp(new_customer_id_, address_Type_Code_API.Decode('INVOICE') 
                                                                  , 'TRUE', NULL, address_valid_from_, adress_valid_to_ );
            END IF;                                                                

            --Creating a new document address.
            document_addr_id_ := count_ + 1;
            Customer_Info_Address_API.New_Address(new_customer_id_, document_addr_id_, doc_address1_, doc_address2_, doc_zip_code_, doc_city_, doc_state_, doc_country_, doc_ean_location_, NULL, NULL, doc_county_, doc_name_,doc_address3_,doc_address4_,doc_address5_,doc_address6_);
            Customer_Info_Address_Type_API.New(new_customer_id_, document_addr_id_, Address_Type_Code_API.Decode('INVOICE'));
            Comm_Method_API.Copy_Identity_Info('CUSTOMER', template_customer_id_, new_customer_id_, delivery_def_addr_, document_addr_id_);         

            -- Retrive defaults from the delivery address
            cust_addr_rec_ := Cust_Ord_Customer_Address_API.Get(new_customer_id_, delivery_def_addr_);

            --Creating a new order address
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('CUSTOMER_ID', new_customer_id_, attr_);
            Client_SYS.Add_To_Attr('ADDRESS_ID', document_addr_id_, attr_);
            Client_SYS.Add_To_Attr('CUSTOMER_ID', new_customer_id_, attr_);
            Client_SYS.Add_To_Attr('DELIVERY_TERMS', NVL(delivery_terms_, cust_addr_rec_.delivery_terms), attr_);
            Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', NVL(del_terms_location_, cust_addr_rec_.del_terms_location), attr_);
            Client_SYS.Add_To_Attr('DISTRICT_CODE', NVL(district_code_, cust_addr_rec_.district_code), attr_);
            Client_SYS.Add_To_Attr('REGION_CODE', NVL(region_code_, cust_addr_rec_.region_code), attr_);
            Client_SYS.Add_To_Attr('SHIP_VIA_CODE', NVL(ship_via_code_, cust_addr_rec_.ship_via_code), attr_);
            Client_SYS.Add_To_Attr('COMPANY_NAME2', doc_name_, attr_);
            IF (cust_ref_ IS NULL) THEN
               Client_SYS.Add_To_Attr('CONTACT', cust_addr_rec_.contact, attr_);
            ELSE
               Client_SYS.Add_To_Attr('CONTACT', cust_ref_, attr_); 
            END IF;
            Cust_Ord_Customer_Address_API.New(info_, attr_);
         END IF;
      END IF;
   END IF;
   IF (TO_CHAR(Party_Identity_Series_API.Get_Next_Value(Party_Type_API.Decode('CUSTOMER'))) = new_customer_id_ ) THEN
      Party_Identity_Series_API.Update_Next_Value(new_customer_id_ + 1, 'CUSTOMER');
   END IF;
   
   $IF Component_Crm_SYS.INSTALLED $THEN
      Crm_Cust_Info_API.Set_Main_Representative(new_customer_id_, main_rep_, template_customer_id_, currency_, customer_category_, current_form_);
   $END
END New_Customer_From_Template;


-- Check_Exist
--   Public check_exist
@UncheckedAccess
FUNCTION Check_Exist (
   customer_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(customer_no_);
END Check_Exist;


-- Modify_Commission_Receiver
--   Public Method for setting if the salesman on the customer is a
--   commission receiver or not.
PROCEDURE Modify_Commission_Receiver (
   customer_no_         IN VARCHAR2,
   commission_receiver_ IN VARCHAR2 )
IS
   attr_          VARCHAR2(2000);
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   oldrec_        CUST_ORD_CUSTOMER_TAB%ROWTYPE;
   newrec_        CUST_ORD_CUSTOMER_TAB%ROWTYPE;
BEGIN
   oldrec_ := Lock_By_Keys___(customer_no_);
   newrec_ := oldrec_ ;
   newrec_.commission_receiver := Create_Com_Receiver_API.Encode(commission_receiver_);

   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Commission_Receiver;


-- Get_Pay_Address
--   Return the customer's pay address.
@UncheckedAccess
FUNCTION Get_Pay_Address (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   addr_no_ CUST_ORD_CUSTOMER_ADDRESS.addr_no%TYPE;
   CURSOR get_default IS
      SELECT addr_no
      FROM   CUST_ORD_CUSTOMER_ADDRESS_TAB
      WHERE  customer_no = customer_no_
      AND    Cust_Ord_Customer_Address_API.Is_Default_Pay_Location__(customer_no, addr_no) = 1
      AND    Cust_Ord_Customer_Address_API.Is_Valid(customer_no, addr_no) = 1;
   CURSOR get_address IS
      SELECT MIN(addr_no)
      FROM   CUST_ORD_CUSTOMER_ADDRESS_TAB
      WHERE  customer_no = customer_no_
      AND    Cust_Ord_Customer_Address_API.Is_Pay_Location(customer_no, addr_no) = 1
      AND    Cust_Ord_Customer_Address_API.Is_Valid(customer_no, addr_no) = 1;
BEGIN
   OPEN get_default;
   FETCH get_default INTO addr_no_;
   IF get_default%FOUND THEN
      CLOSE get_default;
      RETURN addr_no_;
   END IF;
   CLOSE get_default;
   OPEN get_address;
   FETCH get_address INTO addr_no_;
   IF get_address%NOTFOUND THEN
      CLOSE get_address;
      RETURN NULL;
   ELSE
      CLOSE get_address;
      RETURN addr_no_;
   END IF;
END Get_Pay_Address;


-- Get_Cust_Part_Owner_Trans_Db
--   Returns the DB value of cust_part_owner_transfer
@UncheckedAccess
FUNCTION Get_Cust_Part_Owner_Trans_Db (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(customer_no_);
   RETURN micro_cache_value_.cust_part_owner_transfer;
END Get_Cust_Part_Owner_Trans_Db;


-- Get_Contract_From_Customer_No
--   This method will return site for the internal customer
@UncheckedAccess
FUNCTION Get_Contract_From_Customer_No (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_   CUST_ORD_CUSTOMER_TAB.acquisition_site%TYPE;

   CURSOR Get_Contract IS
      SELECT acquisition_site
      FROM CUST_ORD_CUSTOMER_TAB
      WHERE customer_no = customer_no_
      AND category = 'I';
BEGIN
   OPEN Get_Contract;
   FETCH Get_Contract INTO contract_;
   CLOSE Get_Contract;

   RETURN contract_;
END Get_Contract_From_Customer_No;


@UncheckedAccess
FUNCTION Get_Customer_E_Mail (
   customer_no_ IN VARCHAR2,
   address_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Comm_Method_Api.Get_Default_Value ('CUSTOMER', customer_no_ , 'E_MAIL', address_id_, SYSDATE );
END Get_Customer_E_Mail;


@UncheckedAccess
FUNCTION Get_Chk_Sales_Grp_Del_Conf_Db (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(customer_no_);
   RETURN micro_cache_value_.check_sales_grp_deliv_conf;
END Get_Chk_Sales_Grp_Del_Conf_Db;


PROCEDURE Check_Ownership_Transfer(
   customer_no_ IN VARCHAR2 )
IS
   cust_part_owner_transfer_ CUST_ORD_CUSTOMER_TAB.cust_part_owner_transfer%TYPE;
BEGIN

	cust_part_owner_transfer_ := Get_Cust_Part_Owner_Trans_Db(customer_no_);

	IF (cust_part_owner_transfer_ = Cust_Part_Owner_Transfer_API.DB_DO_NOT_ALLOW_OWNERSHIP_TRAN) THEN
      Error_SYS.Record_General(lu_name_,'TRANSFERNOTALLOWED: Ownership transfer is not allowed for customer :P1.',
                               customer_no_);
   END IF;   
END Check_Ownership_Transfer;

@UncheckedAccess
FUNCTION Fetch_Cust_Ref (
   customer_no_       IN VARCHAR2,
   bill_addr_no_      IN VARCHAR2,
   bill_addr_fetched_ IN VARCHAR2) RETURN VARCHAR2
IS
   cust_ref_               VARCHAR2(100);
   cust_ord_cust_rec_      CUST_ORD_CUSTOMER_TAB%ROWTYPE; 
   bill_addr_no_fetched_   VARCHAR2(50);
BEGIN
   IF (NVL(bill_addr_fetched_, 'FALSE') = 'FALSE') THEN
      bill_addr_no_fetched_ := Get_Document_Address(customer_no_);
   ELSE
      bill_addr_no_fetched_ := bill_addr_no_;
   END IF;   
   cust_ref_ :=  Cust_Ord_Customer_Address_API.Get_Contact(customer_no_, bill_addr_no_fetched_);
   IF (cust_ref_ IS NULL) THEN
      cust_ord_cust_rec_ := Get_Object_By_Keys___(customer_no_);
      cust_ref_          := NVL(Customer_Info_Contact_API.Get_Primary_Contact_Id_Addr(customer_no_, bill_addr_no_fetched_), cust_ord_cust_rec_.cust_ref);
   END IF;
   RETURN cust_ref_;
END Fetch_Cust_Ref;

-- This method will check CRM Access for a customer. 
PROCEDURE Check_Access_For_Customer(
   customer_no_   IN VARCHAR2,
   customer_role_ IN VARCHAR2)
IS
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      IF Rm_Acc_Usage_API.Possible_To_Read('CustomerInfo', NULL, customer_no_) = FALSE THEN
         Error_SYS.Record_General(lu_name_, 'NO_ACCESS: You do not have access for :P1 :P2', customer_role_, customer_no_);
      END IF;
   $ELSE
      NULL;
   $END
END Check_Access_For_Customer;
