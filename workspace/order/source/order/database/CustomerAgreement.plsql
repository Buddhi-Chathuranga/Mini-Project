-----------------------------------------------------------------------------
--
--  Logical unit: CustomerAgreement
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
-- 
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210801  MiKulk  SC21R2-2177, Added Unit Test Set_Msg_Sequence_And_Version, Get_Next_Agreement_Id___ 
--  210509  MiKulk  SC21R2-1151-Fixed Validate_Hierarchy_Customerfor correct parent customer evaluation.
--  210507  Skanlk  Bug 159001(SCZ-14722), Modified Get_Agreement_For_Group, Get_Price_Agreement_For_Part, Get_Disc_Agreement_For_Part and Get_Disc_Agrm_For_Part_Assort methods by adding
--  210507          new parameter quantity_ to solve the issue in fetching price agreement Id.
--  210127  DhAplk  SC2020R1-11651, Removed Cust_Agr_Struct_Rec_To_Json() method.
--  201102  RasDlk  SCZ-11045, Added Base_Price_Updated_Constant___ and Deal_Price_Updated_Constant___ to solve MessageDefinitionValidation issue.
--  201020  Erlise  Bug 155787, Modified Check_Update___(). Added checks in method Customer_Agreement_API.Check_Delete___() to prevent an active agreement from being deleted if it is used in any of the following instances,
--  201020          Customer Order Line, Sales Quotation Line, Customer Order Line Discount, Sales Quotation Line Discount, Price Query, Price Query Discount Line. When an occurrence is found, an error will be raised.
--  200928  DhAplk  SC2020R1-820, Changed a public interface Customer_Agr_Struct_Rec_To_Xml to Cust_Agr_Struct_Rec_To_Json.
--  200529  MiKulk  SC2020R1-820, Added a public interface to Customer_Agr_Struct_Rec_To_Xml.
--  190927  DaZase  SCSPRING20-154, Added Raise_Assort_Not_Act_Error___ to solve MessageDefinitionValidation issue.
--  190511  LaThlk  Bug 142914, Modified Add_Part_To_Agreement__() by Passing the from_header_ parameter as TRUE into Agreement_Sales_Part_Deal_API.Insert_Price_Break_Lines().
--  190511          in order to identify the adding sales part through the header.
--  180710  ShPrlk  Bug 139081, Modified Get_Price_Agrm_For_Part_Assort to consider price_qty_due_ to fetch suitable agreement from heirarchy when a CO_line quantity is entered. 
--  180119  CKumlk  STRSC-15930, Modified Update_Part_Prices___ by changing Get_State() to Get_Objstate(). 
--  170825  NiDalk  Bug 137488, Modified Get_Price_Agrm_For_Part_Assort and Get_Disc_Agrm_For_Part_Assort to consider price_unit_meas when getting the maximum valid_from date.
--  170926  RaVdlk  STRSC-11152, Removed Get_State function, since it is generated from the foundation
--  170424  KiSalk  Bug 135491, Annotated Validate_Hierarchy_Customer with UncheckedAccess because it is used in views.
--  170420  IzShlk  STRSC-4713, Added an additional parameter(raise_msg_) to Copy_Agreement__() to raise a warning msg if the new valid_from date is later than the valid_to date.
--  170403  KiSalk  KiSalk  Bug 135001, Added function Validate_Hierarchy_Customer and Allowed agreements of hierachy parents in Is_Valid.
--  161011  ChFolk  STRSC-6270, Modified Adjust_Or_Duplicate_Part___ by adding new parameters modify_base_price_ and create_new_line to distingush the process as this is called when 
--  161011          update from base prices and Adjust Offset is done. Modified Update_Part_Prices___ to support base price update when include period is selected.
--  161011  ChFolk  STRSC-4268, Added new parameter include_period into Update_Part_Prices___ and modifed to support update from base prices when the include_period is un checked..
--  161010  TiRalk  Bug 130821, Added Price logic handling for Special Agreements on Service Quotations. Added new method Has_Valid_Group_Deal and changed 
--  161010          Has_Valid_Assortment_Deal, Has_Valid_Part_Deal also to get the outcome correctly considering the valid_to date.
--  160926  ChFolk  STRSC-3834, Removed method Get_Offset_Values___ as it is no longer valid. Added new parameter include_period_ into Adjust_Offset_Agreement__ and modified 
--  160926          the method to support updating offset based on the include_period_ flag.
--  160922  ChFolk  STRSC-3834, Added new parameter include_period_ into Update_Assortment_Prices___ and modified the method to support updating offset based on the include_period_ flag.
--  160922          Added valid_to_date into Adjust_Or_Duplicate_Asortmt___.
--  160907  SudJlk  STRSC-3927, Modified Get_First_Valid_Agreement to check if the agreement is to be used by object heads and fetch accordingly depending on the parameter value sent in.
--  160902  SudJlk  STRSC-3926, Modified Prepare_Insert___ and Check_Insert___ to set value to Use_By_Object_Head.
--  160825  IzShlk  STRSC-3770, Changed error messages to information messages.
--  160802  ChFolk  STRSC-3666, Added new methods Get_Earliest_Valid_From___ and Get_Latest_Valid_To___ to validate entered valid from and valid until dates in Customer Agreement.
--  160727  ChFolk  STRSC-3674, Added new parameter valid to date to Adjust_Offset_Agreement__and Adjust_Or_Duplicate_Part___.
--  160726  ChFolk  STRSC-3673, Modified Remove_Invalid_Prices__ to consider valid to date when deleting the invalid price lines.
--  160720  ChFolk  STRSC-3574, Modified Get_Price_Agrm_For_Part_Assort, Get_Disc_Agrm_For_Part_Assort, Has_Valid_Assortment_Deal to include valid_to date when selecting possible part assortment line.
--  160718  ChFolk  STRSC-3632, Added new parameter valid_to_date into Add_Part_To_Agreement__ and Add_Part_To_Agreement_Batch__ and respective calling places.
--  160601  MAHPLK  FINHR-2018, Removed Validate_Tax_Calc_Basis___.
--  160520  ApWilk  Bug 128894, Modified the Get_Sales_Price_In_Currency() of Add_Part_To_Agreement__ and Adjust_Or_Duplicate_Part___ to get the customer no by using the Get_Customer_No() in order to
--  160520          prevent customer no getting null and take the customer's currency type for the base price calculation in the customer agreement.
--  150929  MeAblk  Bug 124475, Modified Update_Part_Prices___ to exculde closed agreements.
--  150925  AyAmlk  Bug 124656, Modified Get_Price_Agreement_For_Part(),Get_Disc_Agreement_For_Part(), Get_Price_Agrm_For_Part_Assort() and Get_Disc_Agrm_For_Part_Assort()
--  150925          in order to prevent considering the Part/Assortment lines that are not valid for a given effectivity_date_. Added the new methods Has_Valid_Part_Deal()
--  150925          and Has_Valid_Assortment_Deal() in order to check whether an Agreement has a valid line for part with the latest valid from date.
--  150819  Wahelk  BLU-767, Modified Check_Update___ to remove status closed validation and override Unpack___ to add this validation there
--  150709  MeAblk  Bug 123517, Modified methods Get_Price_Agrm_For_Part_Assort, Get_Disc_Agrm_For_Part_Assort in order to correctly get assortment node price and discount correctly.
--  141218  RuLiLk  PRSC-2213, Moved method Get_Translated_State() to Customer_Order_Flow_API.
--  140908  ShVese  Changed the label <<inner>> to a comment in Get_Disc_Agrm_For_Part_Assort and Get_Price_Agrm_For_Part_Assort.
--  140904  SBalLK  PRSC-2639, Added Get_Translated_state() method to translate state in to relevent language.
--  140321  CLHASE  PBSA-4158, Removed obsolete call to Pm_Action_Util_API.Agreement_Modified.
--  140129  AyAmlk  Bug 114990, Modified Adjust_Or_Duplicate_Part___() and Adjust_Or_Duplicate_Asortmt___() by altering a condition to allow adding discount lines through
--  140129          a sever data change when having a discount_type_ as well.
--  140102  AyAmlk  Bug 114544, modified the CURSORs get_valid_deal_price_entry, get_valid_dicount_entry and get_valid_disc_all_uom defined in Get_Price_Agrm_For_Part_Assort()
--  140102          and Get_Disc_Agrm_For_Part_Assort() to improve performance.
--  131230  AyAmlk  Bug 114544, Modified Get_Price_Agrm_For_Part_Assort() and Get_Disc_Agrm_For_Part_Assort() by removing the get_parent_hierarchy CURSOR and introduced a
--  131230          WHILE loop instead to improve performance. Modified the CONNECT BY clause in the CURSORs to avoid invalid condition.
--  130717  PraWlk  Bug 111158, Modified Check_Delete___() by adding conditional compilation instead of dynamic method calls.  
--  130314  NaLrlk  Modified Add_Part_To_Agreement__ to filter sales_part_base_price records from sales_price type.
--  120131  CPriLK  Filtered Sales Part data from CUSTOMER_AGREEMENT_JOIN.
--  121004  SURBLK  Added Get_Agreement_Curr_Rounding().
--  120911  SURBLK  Removed deal_price_ and deal_price_incl_tax_ from Adjust_Or_Duplicate_Part___().
--  120910  ShKolk  Modified Copy_Agreement__() to copy use_price_incl_tax value to the new agreement.
--  120910  JeeJlk  Modified Update___ to update discount lines when use_price_incl_tax is changed.
--  120907  ShKolk  Modified Add_Part_To_Agreement__() to calculate correct prices depending on use_price_incl_tax. Removed Calculate_Sales_Price_Part___.
--  120829  SURBLK  Modified  New() and New_Agreement_And_Part_Deal with adding use_price_incl_tax_ parameter.
--  120829  SURBLK  Modified Unpack_Check_Update___ and Adjust_Or_Duplicate_Part___ to add price including tax values.
--  120822  SurBlk  Added Validate_Tax_Calc_Basis___.
--  120820  SurBlk  Added a new column use_price_incl_tax.
--  130704  AwWelk  TIBE-969, Removed global variables inst_PmActionUtil_, last_calendar_date_, inst_CcCaseBusinessObject_, inst_CcCaseSolBusinessObj_,
--  130704          inst_CcSupKeyBusinessObj_ and introduced conditional compilation.
--  120629  NipKlk  Bug 102950, Added Check_Reference_Exist method calls in Check_Delete___  to validate if a Business Object Reference exists.
--  120525  JeLise  Made description private.
--  120511  JeLise  Replaced all calls to Module_Translate_Attr_Util_API with calls to Basic_Data_Translation_API
--  120511          in Insert___, Update___, Delete___, Get, Get_Description and in the views. 
--  120412  AyAmlk  Bug 100608, Increased the column length of delivery_terms to 5 in view CUSTOMER_AGREEMENT.
--  120126  ChJalk  Added ENUMERATION to the view comments of the column use_price_break_templates  in the base view.
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111116  ChJalk  Modified the views CUSTOMER_AGREEMENT, VALID_CUSTOMER_AGREEMENT_LOV and CUSTOMER_AGREEMENT_LOV to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111020  ChJalk  Modified the base view customer_agreement, VALID_CUSTOMER_AGREEMENT_LOV and CUSTOMER_AGREEMENT_LOV to use the user allowed company filter.
--  111003  MaRalk  Modified cursor get_valid_deal_price_entry in Get_Price_Agrm_For_Part_Assort and 
--  111003          get_valid_dicount_entry, get_valid_disc_all_uom cursors in Get_Disc_Agrm_For_Part_Assort method to consider the price effective date.
--  110901  NaLrlk  Modified the method Unpack_Check_Update___ to raise the error message when updating the assortment id.
--  110822  SWiclk  Bug 98486, Modified Get_Disc_Agreement_For_Part(), Get_Price_Agreement_For_Part(), Get_Agreement_For_Group(), Get_Agreement_For_Part() and Is_Valid() methods
--  110822          by truncating effective_date_.
--  110802  IsSalk  Bug 98129, Modified method Get_Next_Agreement_Id___ to check the existence of the agreement id. 
--  110802  NWeelk  Bug 94360, Added method Get_Agreement_Defaults.
--  110509  NWeelk  Bug 96967, Modified methods Get_Disc_Agreement_For_Part and Get_Disc_Agrm_For_Part_Assort by removeing discount is not null check from the cursors.
--  110604  MaRalk  Used BASE_PRICE_SITE column in AGREEMENT_SALES_PART_DEAL_TAB instead of CONTRACT in 
--  110604          AGREEMENT_SALES_PART_DEAL_TAB and CUSTOMER_AGREEMENT_TAB within CUSTOMER_AGREEMENT_JOIN view.   
--  110526  MiKulk  Modified the method Adjust_Or_Duplicate_Asortmt___ to copy multiple discount lines also.
--  110526  MaMalk  Modified the where condition of CUSTOMER_AGREEMENT_LOV3 to restrict companies only exist in company_finance_auth_pub
--  110526          and modified methods Update_Part_Prices___ and Update_Assortment_Prices___ to filter the agreements by the company.
--  110325  ChJalk  EANE-4849, Removed VIEWJOIN. 
--  110207  RiLase  Added check to only update active base price parts in Update_Part_Prices___.
--  110204  RiLase  Added call to Agreement_Sales_Part_Deal_API.Insert_Price_Break_Lines in Update_Part_Prices___() and Add_Part_To_Agreement__.
--  110131  Nekolk  EANE-3744  added where clause to View CUSTOMER_AGREEMENT.
--  110124  RiLase  Added USE_PRICE_BREAK_TEMPLATES to Copy_Agreement__.
--  110121  NaLrlk  Modified the method Adjust_Or_Duplicate_Part___ and Add_Part_To_Agreement__ to fetch the calculated base price.
--  110113  RiLase  Added USE_PRICE_BREAK_TEMPLATES.
--  101207  RiLase  Removed DISCOUNT from New_Agreement_And_Part_Deal.
--  100819  NaLrlk  Added method Activate_Allowed.
--  100513  Ajpelk  Merge rose method documentation
--  091224  MaRalk  Modified the state machine according to the new template.
--  090930  MaMalk  Removed constant state_separator_. Modified Finite_State_Init___ to remove unused code.
--  ----------------------------------- 14.0.0 --------------------------------
--  100422  DaZase  Added calls to Invoice_Library_API.Get_Currency_Rate_Defaults in unpack methods to check for valid currency rate.
--  090722  NiBalk  Bug 84905, Added column text_id$ needed for Search Domain to CUSTOMER_AGREEMENT view.
--  091009  NaLrlk  Modified the method Copy_Agreement__ to copy del terms location and rebate builder attributes.
--  090930  DaZase  Added length on view comment for company.
--  090806  AmPalk  Bug 82295, Modified Get_Disc_Agrm_For_Part_Assort by handling standalone discount lines can be valid for all UoMs.
--  090806          If valid discount lines exists for both 'a given UoM' and 'all UoM'; priority given for the known/given UoM.
--  090316  SudJlk  Bug 80264, Modified relevant views and methods to introduce new column del_terms_location.
--  080619  MaRalk  Bug 74883, Increased saved_attr_ variable length in procedure Modify_.   
--  090713  HimRlk  Merged Bug 83496, Removed condition from WHERE clause in cursor get_part_disc_agreement in method Get_Disc_Agreement_For_Part.
--  090115  DaZase  Added customer_level_db_/customer_level_id_ parameters to Get_Price_Agrm_For_Part_Assort and Get_Disc_Agrm_For_Part_Assort.
--  081208  KiSalk  Removed checking active state of assortment in Get_Price_Agrm_For_Part_Assort and Get_Disc_Agrm_For_Part_Assort
--  081205  KiSalk  Removed Assortment_Structure_API.Get_State calls from cursors and added method Check_Active_Agree_Per_Assort.
--  081204  AmPalk  Modified Update_Assortment_Prices___ to ommit deal_price null records in cursor selects.
--  081114  MaJalk  Changed association Company to CompanyFinance.
--  080701  MaJalk  Merged APP75 SP2.
--  ---------------------- APP75 SP2 Merge - End -------------------------------
--  080229  MaMalk  Bug 72023, Modified method Has_Part_Deal to close open cursors.
-- ----------------------- APP75 SP2 Merge - Start -----------------------------
--  080423  MaJalk  Added method Get_Rebate_Builder_Db.
--  080423  MaJalk  At method Get_Rebate_Builder, changed decoding method.
--  080422  MaJalk  Added attribute REBATE_BUILDER.
--  080422  MaJalk  Increased the length of variable saved_attr_ at method Modify__.
--  080404  AmPalk  Removed CUST_EXTERNAL_PROJ_REF.
--  080312  MaJalk  Merged APP 75 SP1.
--  --------------------------- APP 75 SP1 merge - End ----------------------
--  071203  PrPrlk  Bug 68771, Added new method Set_Sequence_And_Version that sets the sequence and version when an invoice is transferred.
--  071203          Updated the relevent methods and views to handle the new columns  sequence_no and version_no.
--  --------------------------- APP 75 SP1 merge - Start --------------------
--  080305  AmPalk Added Get_Id_In_Assortment_Deal.
--  080304  MaJalk  Modified cursor get_part_agreement at Get_Agreement_For_Part.
--  080228  MaJalk  Changed contract retrival method at CUSTOMER_AGREEMENT_JOIN and modified Get().
--  080227  MaJalk  Modified cursor get_part_price_agreement at Get_Price_Agreement_For_Part and
--  080227          added method Get_Contract.
--  080226  AmPalk  Modified CUSTOMER_AGREEMENT_LOV by adding new column and difining description.
--  080226  MaJalk  Modified Unpack_Check_Insert___ and Insert___. Modified parameters of the method call Agreement_Sales_Part_Deal_API.New.
--  080222  MaJalk  Added view CUSTOMER_AGREEMENT_LOV3.
--  080221  MaJalk  Added methods Update_Assortment_Prices__, Start_Update_Assortmt_Prices__,
--  080221          Update_Assortment_Prices___, Adjust_Or_Duplicate_Asortmt___.
--  080221          Renamed Duplicate_Agreement_Part___ to Adjust_Or_Duplicate_Part___.
--  080218  AmPalk  In Get_Disc_Agreement_For_Part, Get_Disc_Agrm_For_Part_Assort, Get_Price_Agreement_For_Part and Get_Price_Agrm_For_Part_Assort corrections done for cursors.
--  080218  MaJalk  Added methods Update_Deal_Part_Prices__, Start_Update_Part_Prices___, Update_Part_Prices___.
--  080211  AmPalk  Changed the select statement of the LOVVIEW, Removed the User Allowed Site filter.
--  080208  MaJalk  Added methods Duplicate_Agreement_Part___, Get_Offset_Values___, Calculate_Sales_Price_Part___,
--  080208          Adjust_Offset_Agreement__, Remove_Invalid_Prices__, Add_Part_To_Agreement__,
--  080208          Add_Part_To_Agreement_Batch__, Start_Add_Part_To_Agreement__. Modified procedure New_Agreement_And_Part_Deal.
--  080208  AmPalk  Changed the select statement of the LOVVIEW, to reflect the changes done to the contract field of the agreement with the addition of valid sites tab.
--  080125  AmPalk  To support multiple discount lines changed the check with discount_type to discount in the cursor get_valid_dicount_entry in method Get_Disc_Agrm_For_Part_Assort.
--  080124  AmPalk  Modified parameters of New_Agreement_And_Part_Deal and method.
--  080124  AmPalk  Added Get_Disc_Agrm_For_Part_Assort.
--  071226  KiSalk  Added method Copy_Agreement__.
--  071220  AmPalk  Added Get_Price_Agrm_For_Part_Assort.
--  071218  KiSalk  Added description to CUSTOMER_AGREEMENT_LOV and VALID_CUSTOMER_AGREEMENT_LOV.
--  071212  AmPalk  Added Assortment_ID as a public attribute.
--  071210  AmPalk  Renamed AGREEMENT_DESCRIPTION as COMMENTS.
--  071206  KiSalk  Added parameter language_code_ to Get_Description. Added Basic_Data_Translation handling to attribute description.
--  071204  AmPalk  Made AGREEMENT_DESCRIPTION 2000 in length and DESCRIPTION 50 in length and mandatory.
--  071203  MaJalk  Added method Get_Company.
--  071203  AmPalk  Added AGREEMENT_DESCRIPTION as a public attribute.
--  071130  AmPalk  Added CUST_EXTERNAL_PROJ_REF as a public attribute.
--  071129  MaJalk  Added company to VIEW, modified methods to refer contract
--  071129          from customer_agreement_site_tab. Removed method Get_Contract.
-- -------------------------------- Nice Price Start ---------------------------
--  070512  NiDalk  Removed Agreement_Type.
--  060807  MaMalk  Replaced some of the instances of TO_DATE function with global constant last_calendar_date_.
--  060418  SaRalk  Enlarge Identity - Changed view comments.
-- ----------------------------------- 13.4.0 --------------------------------
--  060124  NiDalk  Added Assert safe annotation.
--  050922  SaMelk  Removed Unused variables.
--  050519  IsAnlk  Added Lov view VALID_CUSTOMER_AGREEMENT_LOV.
--  050519  IsAnlk  Added public methods New_Agreement_And_Part_Deal and New.
--  050323  Castse  Bug 49463, Added functions Get_Price_Agreement_For_Part and Get_Disc_Agreement_For_Part.
--  041014  KiSalk  Moved CUSTOMER_AGREEMENT_PUB to api.
--  040218  IsWilk  Removed the SUBSTRB from the views and modified the SUBSTRB to SUBSTR for Unicode Changes.
--  040129  ErSolk  Bug 40491, Modified procedure Unpack_Check_Update___.
--  040114  Samnlk  Bug 40031, Change the cursor not to select an items which 'use_explicit' was ticked.
--  040126  GeKalk  Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  020322  CaStse  Bug fix 28116, Added attribut USE_EXPLICIT. Added methods Get_Use_Explicit and Get_Use_Explicit_Db.
--  020102  JICE    Added public view for Sales Configurator export.
--  010528  JSAnse  Bug fix 21463, added call to General_SYS.Init_Method for procedures Get_Agreement_For_Part and Get_Agreement_For_Group.
--  010517  PaLj    Bug fix 20458, added check for valid site in unpack_check_insert___
--  010413  JaBa    Bug Fix 20598,Added new global lu constant inst_PmActionUtil_ and used that in necessary place.
--  010104  MaGu    Added truncate of date parameter in Get_First_Valid_Agreement.
--  001026  MaGu    Added method Get_Agreement_For_Group.
--  001016  MaGu    Added method Get_Agreement_For_Part.
--  000911  CaRa    Added view Customer_Agreement_Join
--  000711  TFU     merging from Chameleon
--  000517  LIN     Added parameter effectivity_date in IS_VALID
-- ----------------  ------------- 13.0 ---------------------------------------
--  000425  PaLj    Changed check for installed logical units. A check is made when API is instantiatet.
--                  See beginning of api-file.
--  000113  JoEd    Bug fix 13159. Changed date until check in Is_Valid.
--  000110  JoEd    Added public attributes AGREEMENT_SENT, CUST_AGREEMENT_ID and
--                  SUP_AGREEMENT_ID.
--                  Added methods Has_Part_Deal and Set_Agreement_Sent.
-- ----------------  ------------- 11.2 ----------------------------------------
--  991007  JoEd    Call Id 21210: Corrected double-byte problems.
-- ----------------  ------------- 11.1 ----------------------------------------
--  990503  PaLj    Added Active check on LOV.
--  990416  RaKu    Y.Cleanup.
--  990409  PaLj    YOSHIMURA - New Template
--  990216  JoAn    Added new method Get_State.
--  990209  CAST    Added note_text.
--  990118  PaLj    changed sysdate to Site_API.Get_Site_Date(contract)
--  990115  RaKu    Changed return type to number in function Is_Valid.
--  990107  ErFi    Changed view comments on authorize_code to 20 characters
--  981214  JoAn    Corrected default value for agreement type in Prepare_Insert__
--  981027  CAST    Added authorize_code.
--  981026  RaKu    Added function Is_Valid.
--  981023  RaKu    Removed price_list_no.
--  980422  RaKu    Changed length on state-machine from 32000.
--  980420  JoAn    SID 4119 Added new function Is_Active. Moved call made
--                  to Pm_Action_Util from Unpack_Check_Update___ to Modify__
--  980417  DaZa    SID 3665, added control in Unpack_Check_Update___ so update
--                  when status Closed is no longer allowed.
--  980330  JoAn    SID 3001 Emty attribute string passed to Pm_Action_Util_API.
--                  Corrected in Unpack_Check_Update___
--  980325  JoAn    SID 2362 Added WHEN others to Unpack_Check_Update___
--  980320  RaKu    Added function Get_Note_Id.
--  980211  MNYS    Changed name on sequence for agreement_id to agreement_id_seq.
--  980210  MNYS    Currency_code, contract and customer_no no longer updateable.
--  980209  MNYS    Changes in Get_First_Valid_Agreement.
--                  Added call to Pm_Action_Util_API.Agreement_Modified.
--  980204  MNYS    Added new LOV-VIEW: CUSTOMER_AGREEMENT_LOV.
--                  Changed CURSOR in Get_First_Valid_Agreement.
--                  Added attribute LANGUAGE_CODE.
--  980128  MNYS    Added note_id.
--  980123  MNYS    Changes in Finite_State_Machine.
--                  Added functions Get_First_Valid_Agreement and Get_Next_Agreement_Id.
--  980122  MNYS    Added agreement_type in Prepare_Insert___.
--  980121  MNYS    Made contract, valid_from, agreement_date and currency_code
--                  MANDATORY.
--  980120  MNYS    Added contract, valid_from and agreement_date in Prepare_Insert___.
--  980107  MNYS    Added Finite_State_Machine.
--                  Added new attributes: agreement_date, contract, currency_code,
--                  ship_via_code and delivery_terms.
--                  Deleted attribute: agreement_name.
--  971216  MNYS    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Assort_Not_Act_Error___ (
   assortment_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'ASSORTACTERR: Assortment :P1 connected to this agreement is not active.', assortment_id_);
END Raise_Assort_Not_Act_Error___;

FUNCTION Base_Price_Updated_Constant___ (
   number_of_updates_ IN NUMBER ) RETURN VARCHAR2  
IS
BEGIN
   RETURN Language_SYS.Translate_Constant(lu_name_, 'BASEPRICEUPDATED: Base price updated in :P1 record(s).', NULL, TO_CHAR(number_of_updates_));
END Base_Price_Updated_Constant___;

FUNCTION Deal_Price_Updated_Constant___ (
   number_of_updates_ IN NUMBER ) RETURN VARCHAR2 
IS
BEGIN
   RETURN Language_SYS.Translate_Constant(lu_name_, 'DEALPRICEUPDATED: Deal price updated in :P1 record(s).', NULL, TO_CHAR(number_of_updates_));
END Deal_Price_Updated_Constant___;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Next_Agreement_Id___ RETURN VARCHAR2
IS
   next_id_ CUSTOMER_AGREEMENT_TAB.agreement_id%TYPE;
   exist_   BOOLEAN := TRUE;
BEGIN
   WHILE (exist_) LOOP
      SELECT agreement_id_seq.nextval INTO next_id_ FROM dual;
      exist_ := Check_Exist___(next_id_);
   END LOOP;
   RETURN next_id_;
END Get_Next_Agreement_Id___;


-- Adjust_Or_Duplicate_Part___
--   Duplicate an agreement deal per part line with new offset values.
--   If valid line exists, modify base price or offsets.
PROCEDURE Adjust_Or_Duplicate_Part___ (
    no_of_changes_       OUT NUMBER,
    agreement_id_        IN  VARCHAR2,
    catalog_no_          IN  VARCHAR2,
    min_quantity_        IN  NUMBER,
    valid_from_date_     IN  DATE,
    new_valid_from_date_ IN  DATE,
    percentage_offset_   IN  NUMBER,
    amount_offset_       IN  NUMBER,
    new_valid_to_date_   IN  DATE,
    modify_base_price_   IN  BOOLEAN,
    create_new_line_     IN  BOOLEAN )
IS
   base_price_                   NUMBER;
   base_price_incl_tax_          NUMBER;
   sales_price_                  NUMBER;
   sales_price_incl_tax_         NUMBER;
   currency_rate_                NUMBER;
   curr_code_                    VARCHAR2(3);
   base_price_site_              VARCHAR2(5);
   net_price_                    VARCHAR2(5);
   provisional_price_            VARCHAR2(5);
   discount_type_                VARCHAR2(25);
   discount_                     NUMBER;
   curr_percentage_offset_       NUMBER;
   curr_amount_offset_           NUMBER;
   rounding_                     NUMBER;
   counter_                      NUMBER:=0;
   temp_info_                    VARCHAR2(2000);
   attr_                         VARCHAR2(32000);
   agreement_rec_                Public_Rec;
   used_price_break_template_id_ VARCHAR2(10);
   sales_price_type_db_          VARCHAR2(20);
   new_deal_price_               NUMBER;
   new_deal_price_incl_tax_      NUMBER;
   new_base_price_               NUMBER;
   new_base_price_incl_tax_      NUMBER;
   current_base_price_incl_tax_  NUMBER;
   current_base_price_           NUMBER;
   calc_base_                    VARCHAR2(10);
   base_price_in_agr_curr_       NUMBER;
   base_price_tax_in_agr_curr_   NUMBER;
   calc_base_price_              NUMBER;
   calc_base_price_incl_tax_     NUMBER;
   
   CURSOR get_cust_agreement_part_info IS
      SELECT base_price_site, discount_type, discount, percentage_offset, amount_offset, rounding, net_price, provisional_price, sales_price_type, 
             base_price, base_price_incl_tax
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_;
BEGIN

   -- Fetch record to duplicate.
   OPEN  get_cust_agreement_part_info;
   FETCH get_cust_agreement_part_info INTO base_price_site_, discount_type_, discount_, curr_percentage_offset_, curr_amount_offset_, rounding_, net_price_, provisional_price_, sales_price_type_db_,
         current_base_price_, current_base_price_incl_tax_;
   IF (get_cust_agreement_part_info%NOTFOUND) THEN
      CLOSE get_cust_agreement_part_info;
      Trace_SYS.Message('No record found');
   ELSE
      CLOSE get_cust_agreement_part_info;

      agreement_rec_ := Customer_Agreement_API.Get(agreement_id_);      

      -- Fetch new base price
      IF agreement_rec_.use_price_incl_tax = 'TRUE' THEN
         Sales_Part_Base_Price_API.Calculate_Base_Price_incl_tax(used_price_break_template_id_, base_price_incl_tax_, base_price_site_, catalog_no_, sales_price_type_db_, min_quantity_, agreement_rec_.use_price_break_templates);
         calc_base_ := 'GROSS_BASE';
         Tax_Handling_Order_Util_API.Calc_Price_Source_Prices(base_price_,
                                                              base_price_incl_tax_,
                                                              base_price_site_,
                                                              catalog_no_,
                                                              calc_base_,
                                                              16);
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(base_price_tax_in_agr_curr_, currency_rate_, Get_Customer_No(agreement_id_), base_price_site_, agreement_rec_.currency_code, base_price_incl_tax_); 
      ELSE
         Sales_Part_Base_Price_API.Calculate_Base_Price(used_price_break_template_id_, base_price_, base_price_site_, catalog_no_, sales_price_type_db_, min_quantity_, agreement_rec_.use_price_break_templates);      
         calc_base_ := 'NET_BASE';
         Tax_Handling_Order_Util_API.Calc_Price_Source_Prices(base_price_,
                                                              base_price_incl_tax_,
                                                              base_price_site_,
                                                              catalog_no_,
                                                              calc_base_,
                                                              16);
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(base_price_in_agr_curr_, currency_rate_, Get_Customer_No(agreement_id_), base_price_site_, agreement_rec_.currency_code, base_price_);
      END IF;    

      -- Modifies base price
      IF (NOT create_new_line_) THEN
         -- modify existing line
         IF (agreement_rec_.use_price_incl_tax = 'TRUE') THEN
            calc_base_ := 'GROSS_BASE';
         ELSE
            calc_base_ := 'NET_BASE';
         END IF;
         IF (modify_base_price_) THEN
            --Modifies base prices
            calc_base_price_ := base_price_in_agr_curr_;
            new_base_price_ := base_price_in_agr_curr_;
            calc_base_price_incl_tax_ := base_price_tax_in_agr_curr_;
            new_base_price_incl_tax_ := base_price_tax_in_agr_curr_;
            Sales_Part_Base_Price_API.Calculate_Part_Prices(calc_base_price_,
                                                            calc_base_price_incl_tax_,
                                                            new_deal_price_,
                                                            new_deal_price_incl_tax_,
                                                            percentage_offset_,      
                                                            amount_offset_,    
                                                            base_price_site_,         
                                                            catalog_no_,       
                                                            calc_base_,        
                                                            'FORWARD',
                                                            rounding_,
                                                            ifs_curr_rounding_ => 16);
            Agreement_Sales_Part_Deal_API.Modify_Price_Info(agreement_id_,
                                                            min_quantity_,
                                                            valid_from_date_,
                                                            catalog_no_,
                                                            new_base_price_,
                                                            new_base_price_incl_tax_,
                                                            new_deal_price_,
                                                            new_deal_price_incl_tax_,
                                                            used_price_break_template_id_,
                                                            new_valid_to_date_,
                                                            percentage_offset_,
                                                            amount_offset_);
            counter_ := counter_ + 1;
         ELSE
            -- Modifies percentage offset and amount offset when new valid date is equal
            Sales_Part_Base_Price_API.Calculate_Part_Prices(current_base_price_,
                                                            current_base_price_incl_tax_,
                                                            new_deal_price_,
                                                            new_deal_price_incl_tax_,
                                                            percentage_offset_,
                                                            amount_offset_,
                                                            base_price_site_,
                                                            catalog_no_,
                                                            calc_base_,
                                                            'FORWARD',
                                                            rounding_,
                                                            16);
            Agreement_Sales_Part_Deal_API.Modify_Offset(agreement_id_,
                                                        catalog_no_,
                                                        min_quantity_,
                                                        new_valid_from_date_,
                                                        percentage_offset_,
                                                        amount_offset_,
                                                        new_valid_to_date_,
                                                        new_deal_price_,
                                                        new_deal_price_incl_tax_);
            counter_ := counter_ + 1;
         END IF;   
      
      ELSE
         -- add new record
         IF NOT(Agreement_Sales_Part_Deal_API.Check_Exist(agreement_id_, min_quantity_, new_valid_from_date_, catalog_no_)) THEN

            Client_SYS.Set_Item_Value('AGREEMENT_ID', agreement_id_, attr_);
            Client_SYS.Set_Item_Value('MIN_QUANTITY', min_quantity_, attr_);
            Client_SYS.Set_Item_Value('VALID_FROM_DATE', new_valid_from_date_, attr_);
            Client_SYS.Set_Item_Value('CATALOG_NO', catalog_no_, attr_);
            Client_SYS.Set_Item_Value('BASE_PRICE_SITE', base_price_site_, attr_);
            Client_SYS.Set_Item_Value('DISCOUNT_TYPE', discount_type_, attr_);
            Client_SYS.Set_Item_Value('DISCOUNT', discount_, attr_);
            Client_SYS.Set_Item_Value('BASE_PRICE', base_price_in_agr_curr_, attr_);
            Client_SYS.Set_Item_Value('BASE_PRICE_INCL_TAX', base_price_tax_in_agr_curr_, attr_);
            Client_SYS.Set_Item_Value('PERCENTAGE_OFFSET', percentage_offset_, attr_);
            Client_SYS.Set_Item_Value('AMOUNT_OFFSET', amount_offset_, attr_);
            Client_SYS.Set_Item_Value('ROUNDING', rounding_, attr_);
            Client_SYS.Set_Item_Value('NET_PRICE_DB', net_price_, attr_);
            Client_SYS.Set_Item_Value('PROVISIONAL_PRICE_DB', provisional_price_, attr_);
            Client_SYS.Set_Item_Value('PRICE_BREAK_TEMPLATE_ID', used_price_break_template_id_, attr_);
            Client_SYS.Set_Item_Value('SERVER_DATA_CHANGE', 1, attr_);
            Client_SYS.Set_Item_Value('VALID_TO_DATE', new_valid_to_date_, attr_);
            Agreement_Sales_Part_Deal_API.New(temp_info_, attr_);

            IF (discount_ IS NOT NULL) THEN
               Agreement_Part_Discount_API.Copy_All_Discount_Lines__(agreement_id_, min_quantity_, valid_from_date_, catalog_no_,
                                                                     agreement_id_, min_quantity_, new_valid_from_date_, catalog_no_,
                                                                     currency_rate_);
            END IF;
            counter_ := counter_ + 1;
         END IF;
      END IF;
   END IF;
   no_of_changes_ := counter_;
END Adjust_Or_Duplicate_Part___;

-- Update_Part_Prices___
--   Update deal per part lines in customer agreements from base prices.
PROCEDURE Update_Part_Prices___ (
   number_of_updates_      OUT NUMBER,
   valid_from_date_        IN  DATE,
   sales_price_origin_db_  IN  VARCHAR2,
   agreement_attr_         IN  VARCHAR2,
   catalog_no_attr_        IN  VARCHAR2,
   base_price_site_attr_   IN  VARCHAR2,
   include_period_         IN  VARCHAR2 )
IS
   counter_                   NUMBER := 0;
   number_of_changes_         NUMBER := 0;
   sales_price_origin_        VARCHAR2(200);
   agreement_id_where_        VARCHAR2(2000);
   catalog_no_where_          VARCHAR2(2000);
   base_price_site_where_     VARCHAR2(2000);
   attr_                      VARCHAR2(2000);
   stmt_                      VARCHAR2(32000);
 --  prestmt_                   VARCHAR2(32000);

   TYPE dynamic_cursor_type   IS REF CURSOR;
   dynamic_cursor_            dynamic_cursor_type;
   agreement_id_              AGREEMENT_SALES_PART_DEAL_TAB.AGREEMENT_ID%TYPE;
   catalog_no_                AGREEMENT_SALES_PART_DEAL_TAB.CATALOG_NO%TYPE;
   min_quantity_              AGREEMENT_SALES_PART_DEAL_TAB.MIN_QUANTITY%TYPE;
   line_valid_from_date_      AGREEMENT_SALES_PART_DEAL_TAB.VALID_FROM_DATE%TYPE;
   percentage_offset_         AGREEMENT_SALES_PART_DEAL_TAB.PERCENTAGE_OFFSET%TYPE;
   amount_offset_             AGREEMENT_SALES_PART_DEAL_TAB.AMOUNT_OFFSET%TYPE;
   base_price_site_           AGREEMENT_SALES_PART_DEAL_TAB.base_price_site%TYPE;
   rounding_                  AGREEMENT_SALES_PART_DEAL_TAB.rounding%TYPE;
   discount_type_             AGREEMENT_SALES_PART_DEAL_TAB.discount_type%TYPE;
   discount_                  AGREEMENT_SALES_PART_DEAL_TAB.discount%TYPE;
 --  added_lines_               NUMBER;
   sales_price_type_db_       VARCHAR2(20);
   line_valid_to_date_        AGREEMENT_SALES_PART_DEAL_TAB.valid_to_date%TYPE;
   exist_rec_                 agreement_sales_part_deal_tab%ROWTYPE;
   new_valid_from_date_       DATE;
   create_new_line_           BOOLEAN;
   next_valid_from_date_      DATE;
   next_valid_to_date_        DATE;
   next_valid_from_found_     BOOLEAN;
   dummy_                     NUMBER;
   prev_agreement_id_         VARCHAR2(10);
   prev_catalog_no_           VARCHAR2(25);
   prev_min_quantity_         NUMBER;
   same_date_record_updated_  BOOLEAN := FALSE;
   new_rec_created_on_from_date_  BOOLEAN;
   new_line_from_date_        DATE;
   new_valid_to_date_         DATE;
   
   CURSOR get_exist_record(agreement_id_ IN VARCHAR2, catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, new_from_date_ IN DATE) IS
      SELECT *
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = new_from_date_;
   
   CURSOR check_overlap_rec_found(agreement_id_ IN VARCHAR2, catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, from_date_ IN DATE, to_date_ IN DATE) IS
      SELECT 1
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_to_date IS NULL
      AND    valid_from_date > from_date_
      AND    valid_from_date <= to_date_;
      
   CURSOR get_adjacent_valid_rec(agreement_id_ IN VARCHAR2, catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, next_valid_from_date_ IN DATE) IS
      SELECT valid_to_date
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_     
      AND    valid_from_date = next_valid_from_date_;
      
       
      
BEGIN

   sales_price_origin_ := Sales_Price_Origin_API.Decode(sales_price_origin_db_);

   -- Convert input variables to where conditions
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ca.agreement_id', agreement_attr_, attr_);
   agreement_id_where_ := Report_SYS.Parse_Where_Expression(attr_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('catalog_no', catalog_no_attr_, attr_);
   catalog_no_where_ := Report_SYS.Parse_Where_Expression(attr_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('base_price_site', base_price_site_attr_, attr_);
   base_price_site_where_ := Report_SYS.Parse_Where_Expression(attr_);
      
   IF (include_period_ = 'FALSE') THEN
      stmt_ := 'SELECT ca.agreement_id, catalog_no, min_quantity, valid_from_date, percentage_offset, amount_offset, base_price_site, rounding, discount_type, discount, asp.sales_price_type
         FROM CUSTOMER_AGREEMENT_TAB ca, AGREEMENT_SALES_PART_DEAL_TAB asp
         WHERE ca.agreement_id = asp.agreement_id
         AND   ca.rowstate != ''Closed''
         AND   ca.company IN (SELECT company FROM company_finance_auth_pub)
             AND   (Sales_Part_Base_Price_API.Get_Sales_Price_Origin(base_price_site, catalog_no, Sales_Price_Type_API.Decode(asp.sales_price_type)) = :sales_price_origin OR :sales_price_origin_db IS NULL)';
   ELSE
      stmt_ := 'SELECT ca.agreement_id, catalog_no, min_quantity, valid_from_date, asp.valid_to_date, percentage_offset, amount_offset, base_price_site, rounding, discount_type, discount, asp.sales_price_type
         FROM CUSTOMER_AGREEMENT_TAB ca, AGREEMENT_SALES_PART_DEAL_TAB asp
         WHERE ca.agreement_id = asp.agreement_id
         AND   ca.rowstate != ''Closed''
         AND   ca.company IN (SELECT company FROM company_finance_auth_pub)
             AND   (Sales_Part_Base_Price_API.Get_Sales_Price_Origin(base_price_site, catalog_no, Sales_Price_Type_API.Decode(asp.sales_price_type)) = :sales_price_origin OR :sales_price_origin_db IS NULL)';
   END IF;

   IF agreement_id_where_ IS NOT NULL THEN
      stmt_ := stmt_ || ' AND ' || agreement_id_where_;
   END IF;

   IF catalog_no_where_ IS NOT NULL THEN
      stmt_ := stmt_ || ' AND ' || catalog_no_where_;
   END IF;

   IF base_price_site_where_ IS NOT NULL THEN
      stmt_ := stmt_ || ' AND ' || base_price_site_where_;
   END IF;

   IF (include_period_ = 'FALSE') THEN
      stmt_ := stmt_ || 'AND    NVL(asp.valid_to_date, :valid_from_date) >= :valid_from_date
                         AND    asp.valid_to_date IS NULL
                         AND   (ca.agreement_id, asp.catalog_no, asp.min_quantity, asp.valid_from_date) IN
                              (SELECT agreement_id, catalog_no, min_quantity, valid_from_date
                               FROM  agreement_sales_part_deal_tab
                               WHERE (agreement_id, catalog_no, min_quantity, valid_from_date) IN
                                 (SELECT agreement_id, catalog_no, min_quantity, MAX(valid_from_date) valid_from_date
                                  FROM   agreement_sales_part_deal_tab
                                  WHERE  valid_from_date <= :valid_from_date
                                  AND    valid_to_date IS NULL
                                  GROUP BY agreement_id, catalog_no, min_quantity)
                                  UNION ALL
                                 (SELECT agreement_id, catalog_no, min_quantity, valid_from_date
                                  FROM   agreement_sales_part_deal_tab
                                  WHERE  valid_from_date > :valid_from_date
                                  AND    valid_to_date IS NULL))
                  ORDER BY ca.agreement_id, asp.catalog_no, asp.min_quantity, asp.valid_from_date';
   ELSE
      stmt_ := stmt_ || 'AND    NVL(asp.valid_to_date, :valid_from_date) >= :valid_from_date
                         AND   (ca.agreement_id, asp.catalog_no, asp.min_quantity, asp.valid_from_date) IN
                              (SELECT agreement_id, catalog_no, min_quantity, valid_from_date
                               FROM  agreement_sales_part_deal_tab
                               WHERE (agreement_id, catalog_no, min_quantity, valid_from_date) IN
                                 (SELECT agreement_id, catalog_no, min_quantity, MAX(valid_from_date) valid_from_date
                                  FROM   agreement_sales_part_deal_tab
                                  WHERE  valid_from_date <= :valid_from_date
                                  AND    valid_to_date IS NULL
                                  GROUP BY agreement_id, catalog_no, min_quantity)
                                  UNION ALL
                                 (SELECT agreement_id, catalog_no, min_quantity, valid_from_date
                                  FROM   agreement_sales_part_deal_tab
                                  WHERE  valid_from_date >= :valid_from_date)
                                  UNION ALL
                                 (SELECT agreement_id, catalog_no, min_quantity, valid_from_date
                                  FROM   agreement_sales_part_deal_tab
                                  WHERE  valid_to_date IS NOT NULL
                                  AND    valid_from_date < :valid_from_date
                                  AND    valid_to_date >= :valid_from_date ))
                  ORDER BY ca.agreement_id, asp.catalog_no, asp.min_quantity, asp.valid_from_date';
   END IF;
   
   IF (include_period_ = 'FALSE') THEN
      @ApproveDynamicStatement(2008-12-04,ampalk)
      OPEN dynamic_cursor_ FOR stmt_ USING sales_price_origin_, sales_price_origin_db_, TRUNC(valid_from_date_), TRUNC(valid_from_date_), TRUNC(valid_from_date_), TRUNC(valid_from_date_);
      LOOP
         FETCH dynamic_cursor_ INTO agreement_id_, catalog_no_, min_quantity_, line_valid_from_date_, percentage_offset_, amount_offset_, base_price_site_, rounding_, discount_type_, discount_, sales_price_type_db_;
         EXIT WHEN dynamic_cursor_%NOTFOUND;
         IF (Sales_Part_Base_Price_API.Get_Objstate(base_price_site_, catalog_no_, Sales_Price_Type_API.Decode(sales_price_type_db_)) = 'Active') THEN
            new_valid_from_date_ := NULL;
            create_new_line_ := FALSE;
            exist_rec_ := NULL;
            next_valid_from_date_ := NULL;
            next_valid_to_date_ := NULL;
            IF (line_valid_from_date_ < valid_from_date_) THEN
               -- Need to create a new line with valid from_date = valid_from_date_.
               -- For that we need to check whether any record exists with that valid_from_date.
               next_valid_from_found_ := FALSE;
               new_valid_from_date_ := valid_from_date_;
               LOOP
                  EXIT WHEN (next_valid_from_found_);
                  OPEN get_exist_record(agreement_id_, catalog_no_, min_quantity_, new_valid_from_date_);
                  FETCH get_exist_record INTO exist_rec_;
                  IF (get_exist_record%FOUND) THEN
                     CLOSE get_exist_record;
                     IF (exist_rec_.valid_to_date IS NULL) THEN
                        -- record exist with valid_from_date = valid_from_date_ and valid_to_date null. Hence no need to create a new record
                        next_valid_from_found_ := TRUE;
                        create_new_line_ := FALSE;
                     ELSE
                        new_valid_from_date_ := exist_rec_.valid_to_date + 1; 
                     END IF;
                  ELSE
                     CLOSE get_exist_record;
                     create_new_line_ := TRUE;
                     next_valid_from_found_ := TRUE;
                  END IF;
               END LOOP;
               IF (create_new_line_) THEN
                  -- find the next record with valid_to_date null. If that record valid_from_date is earlier than our new valid_from_date then no need to create the record
                  OPEN check_overlap_rec_found(agreement_id_, catalog_no_, min_quantity_, valid_from_date_, new_valid_from_date_);
                  FETCH check_overlap_rec_found INTO dummy_;
                  IF (check_overlap_rec_found%NOTFOUND) THEN
                     CLOSE check_overlap_rec_found;
                     Adjust_Or_Duplicate_Part___(number_of_changes_, agreement_id_, catalog_no_,
                                                 min_quantity_, line_valid_from_date_, new_valid_from_date_,
                                                 percentage_offset_, amount_offset_, NULL, TRUE, TRUE);
                     counter_ := counter_ + NVL(number_of_changes_, 0);
                  ELSE
                     CLOSE check_overlap_rec_found;
                  END IF;
               END IF;
            ELSE
               Adjust_Or_Duplicate_Part___(number_of_changes_, agreement_id_, catalog_no_,
                                           min_quantity_, line_valid_from_date_, line_valid_from_date_,
                                           percentage_offset_, amount_offset_, NULL, TRUE, FALSE);
               counter_ := counter_ + NVL(number_of_changes_, 0);
            END IF;
         END IF;
      END LOOP;
      CLOSE dynamic_cursor_;
   ELSE 
      -- include_period_ = TRUE
      @ApproveDynamicStatement(2016-10-11, ChFolk)
      OPEN dynamic_cursor_ FOR stmt_ USING sales_price_origin_, sales_price_origin_db_, TRUNC(valid_from_date_), TRUNC(valid_from_date_), TRUNC(valid_from_date_), TRUNC(valid_from_date_), TRUNC(valid_from_date_), TRUNC(valid_from_date_);
      LOOP
         FETCH dynamic_cursor_ INTO agreement_id_, catalog_no_, min_quantity_, line_valid_from_date_, line_valid_to_date_, percentage_offset_, amount_offset_, base_price_site_, rounding_, discount_type_, discount_, sales_price_type_db_;
         EXIT WHEN dynamic_cursor_%NOTFOUND;
         IF (Sales_Part_Base_Price_API.Get_Objstate(base_price_site_, catalog_no_, Sales_Price_Type_API.Decode(sales_price_type_db_)) = 'Active') THEN
            next_valid_to_date_ := NULL;
            create_new_line_ := FALSE;
            exist_rec_ := NULL; 
            new_line_from_date_ := NULL;
            IF ((NVL(prev_agreement_id_, agreement_id_) != agreement_id_) OR (NVL(prev_catalog_no_, catalog_no_) != catalog_no_) 
               OR (NVL(prev_min_quantity_, min_quantity_) != min_quantity_)) THEN
               same_date_record_updated_ := FALSE;
               new_rec_created_on_from_date_ := FALSE;
            END IF;
            IF (line_valid_from_date_ < valid_from_date_) THEN
               IF (line_valid_to_date_ IS NOT NULL) THEN
                  -- timeframe record found. that has to be broken into two. with old prices and new prices with adjustments.
                  -- update record with valid_to_date = valid_from_date_ - 1 
                  new_valid_to_date_ := valid_from_date_ - 1;
                  Agreement_Sales_Part_Deal_API.Modify_Valid_To_Date(agreement_id_, catalog_no_, min_quantity_, line_valid_from_date_, new_valid_to_date_);
               END IF;
               -- create a new line with valid from date = valid_from_date_. If any line exists with same valid_from_date_ update that record
               OPEN get_exist_record(agreement_id_, catalog_no_, min_quantity_, valid_from_date_);
               FETCH get_exist_record INTO exist_rec_;
               CLOSE get_exist_record;
               IF (exist_rec_.valid_from_date IS NOT NULL) THEN
                  -- there is an record exists with given valid_from_date
                  IF (line_valid_to_date_ IS NOT NULL) THEN
                     -- current line has a valid_to_date. Hence we have to update it with new base price. But we need to create a new line after the todate.
                     IF (NOT same_date_record_updated_) THEN
                        -- update existing record with price information of line_rec_ and offset from existing rec
                        Adjust_Or_Duplicate_Part___(number_of_changes_, agreement_id_, catalog_no_, min_quantity_, valid_from_date_,
                                                    valid_from_date_, percentage_offset_, amount_offset_, line_valid_to_date_, TRUE, FALSE);
                        counter_ := counter_ + NVL(number_of_changes_, 0);
                        same_date_record_updated_ := TRUE;
                     END IF;
                     next_valid_to_date_ := line_valid_to_date_;
                     IF (exist_rec_.valid_to_date IS NULL AND new_rec_created_on_from_date_) THEN
                        -- new line has already created on the user specified valid_from_date which falls in between the current line timeframe
                        -- Needs to modify the valid_to_date as well as correct offset values from the current line. 
                        Adjust_Or_Duplicate_Part___(number_of_changes_, agreement_id_, catalog_no_, min_quantity_, valid_from_date_,
                                                    valid_from_date_, percentage_offset_, amount_offset_, line_valid_to_date_, TRUE, FALSE); 
                        -- No need to increase the counter_ here as this line is already counted at the time of creation. 
                        -- Here it is just modifying with correct offset and to_date which were unable to decide at the time of creation.                            
                     END IF;
                  ELSE
                     IF (NOT same_date_record_updated_) THEN
                        -- if line_rec_ is not timeframed, existing record can be modified only with offset values
                        Adjust_Or_Duplicate_Part___(number_of_changes_, agreement_id_, catalog_no_, min_quantity_, valid_from_date_,
                                                    valid_from_date_, exist_rec_.percentage_offset, exist_rec_.amount_offset, exist_rec_.valid_to_date, TRUE, FALSE);
                        counter_ := counter_ + NVL(number_of_changes_, 0);
                        same_date_record_updated_ := TRUE;
                     END IF;   
                     next_valid_to_date_ := exist_rec_.valid_to_date;
                  END IF;
                  next_valid_from_found_ := FALSE;
                  create_new_line_ := FALSE;
                  LOOP
                     EXIT WHEN next_valid_from_found_;
                     new_line_from_date_ := next_valid_to_date_ + 1;
                     OPEN get_adjacent_valid_rec(agreement_id_, catalog_no_, min_quantity_, new_line_from_date_);
                     FETCH get_adjacent_valid_rec INTO next_valid_to_date_;
                     IF (get_adjacent_valid_rec%FOUND) THEN
                        CLOSE get_adjacent_valid_rec;
                        IF (next_valid_to_date_ IS NULL) THEN
                           next_valid_from_found_ := TRUE;
                           create_new_line_ := FALSE;
                        END IF;
                     ELSE      
                        CLOSE get_adjacent_valid_rec;
                        create_new_line_ := TRUE;
                        next_valid_from_found_ := TRUE;
                     END IF;
                  END LOOP;
                  IF (create_new_line_) THEN
                     -- need to create a new line with valid_from_date = next_valid_to_date_ + 1 = new_line_from_date_;.
                     OPEN check_overlap_rec_found(agreement_id_, catalog_no_, min_quantity_, valid_from_date_, new_line_from_date_);
                     FETCH check_overlap_rec_found INTO dummy_;
                     IF (check_overlap_rec_found%NOTFOUND) THEN
                        CLOSE check_overlap_rec_found;
                        IF (line_valid_to_date_ IS NOT NULL) THEN
                           -- create new line on new_line_from_date_
                           Adjust_Or_Duplicate_Part___(number_of_changes_, agreement_id_, catalog_no_, min_quantity_, valid_from_date_,
                                                       new_line_from_date_, exist_rec_.percentage_offset, exist_rec_.amount_offset, NULL, TRUE, TRUE);                                                         
                           counter_ := counter_ + NVL(number_of_changes_, 0);
                        ELSE
                           -- if no overlapping rec found. The  create the line 
                           Adjust_Or_Duplicate_Part___(number_of_changes_, agreement_id_, catalog_no_, min_quantity_, line_valid_from_date_,
                                                       new_line_from_date_, percentage_offset_, amount_offset_, NULL, TRUE, TRUE);                                                        
                           counter_ := counter_ + NVL(number_of_changes_, 0);
                        END IF;

                     ELSE
                        CLOSE check_overlap_rec_found;
                        -- no need to create the line
                     END IF;
                  END IF;
               ELSE
                  -- There is no record exists in the given valid_from_date. Hence create a new record on that date
                  IF (NOT same_date_record_updated_) THEN
                     -- No record exists on user defined from_date_. Hence Create a new line on that date with offset adjustment     
                     Adjust_Or_Duplicate_Part___(number_of_changes_, agreement_id_, catalog_no_, min_quantity_, line_valid_from_date_,
                                                 valid_from_date_, percentage_offset_, amount_offset_, line_valid_to_date_, TRUE, TRUE);                              
                     counter_ := counter_ + NVL(number_of_changes_, 0);
                     same_date_record_updated_ := TRUE;
                     new_rec_created_on_from_date_ := TRUE;
                  END IF;
               END IF;   
            ELSIF ( (line_valid_from_date_ > valid_from_date_) OR (line_valid_from_date_ = valid_from_date_ AND NOT same_date_record_updated_)) THEN
               -- update the existing lines with new base price
               Adjust_Or_Duplicate_Part___(number_of_changes_, agreement_id_, catalog_no_, min_quantity_, line_valid_from_date_,
                                           line_valid_from_date_, percentage_offset_, amount_offset_, line_valid_to_date_, TRUE, FALSE);
               counter_ := counter_ + NVL(number_of_changes_, 0);
            END IF;
            prev_agreement_id_ := agreement_id_;
            prev_catalog_no_ := catalog_no_;
            prev_min_quantity_ := min_quantity_;
         END IF;
      END LOOP;
      CLOSE dynamic_cursor_;
   END IF;
   number_of_updates_ := counter_;
END Update_Part_Prices___;


-- Update_Assortment_Prices___
--   Update deal prices at deal per assortment lines at customer agreement.
PROCEDURE Update_Assortment_Prices___ (
   number_of_updates_      OUT NUMBER,
   valid_from_date_        IN  DATE,
   percentage_offset_      IN  NUMBER,
   amount_offset_          IN  NUMBER,
   agreement_attr_         IN  VARCHAR2,
   assortment_attr_        IN  VARCHAR2,
   assortment_node_attr_   IN  VARCHAR2,
   include_period_         IN  VARCHAR2 )

IS
   counter_                   NUMBER := 0;
   next_valid_from_date_      DATE;
   next_valid_to_date_        DATE;
   new_valid_to_date_         DATE;
   new_valid_from_date_       DATE;
   new_line_from_date_        DATE;
   next_valid_from_found_     BOOLEAN := FALSE;
   dummy_                     NUMBER;
   create_new_line_           BOOLEAN;
   exist_rec_                 agreement_assortment_deal_tab%ROWTYPE;
   deal_price_                NUMBER;
   same_date_record_updated_  BOOLEAN := FALSE;
   prev_agreement_id_         VARCHAR2(10);
   prev_assortment_id_        VARCHAR2(50);
   prev_assortment_node_id_   VARCHAR2(50);
   prev_price_unit_meas_      VARCHAR2(30);
   prev_min_quantity_         NUMBER;
   new_rec_created_on_from_date_ BOOLEAN;
      
   CURSOR find_null_valid_to_date_recs IS
      SELECT ca.agreement_id, ca.assortment_id, aad.assortment_node_id, aad.price_unit_meas, aad.min_quantity, aad.valid_from, aad.deal_price, aad.rounding
      FROM   customer_agreement_tab ca, agreement_assortment_deal_tab aad
      WHERE  ca.agreement_id = aad.agreement_id
      AND    Report_SYS.Parse_Parameter(ca.agreement_id, agreement_attr_) = 'TRUE'
      AND    Report_SYS.Parse_Parameter(ca.assortment_id, assortment_attr_) = 'TRUE'
      AND    Report_SYS.Parse_Parameter(assortment_node_id, assortment_node_attr_) = 'TRUE'
      AND    NVL(valid_until, valid_from_date_) >= valid_from_date_
      AND    aad.deal_price IS NOT NULL
      AND    ca.company IN (SELECT company FROM company_finance_auth_pub)
      AND    (ca.agreement_id, ca.assortment_id, aad.assortment_node_id, aad.price_unit_meas, aad.min_quantity, aad.valid_from) IN
          (SELECT agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity, valid_from
           FROM   agreement_assortment_deal_tab
           WHERE (agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity, valid_from) IN
                 (SELECT agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity, MAX(valid_from) valid_from
                  FROM   agreement_assortment_deal_tab
                  WHERE valid_from <= valid_from_date_
                  AND valid_to IS NULL
                  GROUP BY agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity)
                  UNION ALL
                 (SELECT agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity, valid_from
                  FROM  agreement_assortment_deal_tab
                  WHERE valid_from > valid_from_date_
                  AND   valid_to IS NULL))
      ORDER BY agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity, valid_from;
                           
   CURSOR find_valid_record IS
      SELECT ca.agreement_id, ca.assortment_id, aad.assortment_node_id, aad.price_unit_meas, aad.min_quantity, aad.valid_from, aad.valid_to,
             aad.deal_price, aad.rounding
      FROM   customer_agreement_tab ca, agreement_assortment_deal_tab aad
      WHERE  ca.agreement_id = aad.agreement_id
      AND    aad.deal_price IS NOT NULL
      AND    Report_SYS.Parse_Parameter(ca.agreement_id, agreement_attr_) = 'TRUE'
      AND    Report_SYS.Parse_Parameter(ca.assortment_id, assortment_attr_) = 'TRUE'
      AND    Report_SYS.Parse_Parameter(assortment_node_id, assortment_node_attr_) = 'TRUE'
      AND    ca.company IN (SELECT company FROM company_finance_auth_pub)
      AND    NVL(valid_until, valid_from_date_) >= valid_from_date_
      AND   (ca.agreement_id, ca.assortment_id, aad.assortment_node_id, aad.price_unit_meas, aad.min_quantity, aad.valid_from) IN
           (SELECT agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity, valid_from
              FROM  agreement_assortment_deal_tab
              WHERE (agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity, valid_from) IN
                  (SELECT agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity, MAX(valid_from) valid_from
                     FROM   agreement_assortment_deal_tab
                     WHERE  valid_from <= valid_from_date_
                     AND    valid_to IS NULL
                     GROUP BY agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity)
                     UNION ALL
                     (SELECT agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity, valid_from
                      FROM   agreement_assortment_deal_tab
                      WHERE  valid_from >= valid_from_date_)
                     UNION ALL
                     (SELECT agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity, valid_from
                      FROM   agreement_assortment_deal_tab
                      WHERE  valid_to IS NOT NULL
                      AND    valid_from < valid_from_date_
                      AND    valid_to >= valid_from_date_ ))
         ORDER BY agreement_id, assortment_id, assortment_node_id, price_unit_meas, min_quantity, valid_from;
          
   CURSOR get_next_adjacent_rec(agreement_id_ IN VARCHAR2, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, min_quantity_ IN NUMBER, price_unit_meas_ IN VARCHAR2, new_valid_from_date_ IN DATE) IS
      SELECT valid_to
      FROM   agreement_assortment_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    min_quantity = min_quantity_
      AND    price_unit_meas = price_unit_meas_
      AND    valid_from = new_valid_from_date_;
      
   CURSOR check_overlap_rec_found(agreement_id_ IN VARCHAR2, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, min_quantity_ IN NUMBER, price_unit_meas_ IN VARCHAR2, from_date_ IN DATE, to_date_ IN DATE) IS
      SELECT 1
      FROM agreement_assortment_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    min_quantity = min_quantity_
      AND    price_unit_meas = price_unit_meas_
      AND    valid_to IS NULL
      AND    valid_from > from_date_
      AND    valid_from <= to_date_;
      
   CURSOR get_exist_record(agreement_id_ IN VARCHAR2, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, min_quantity_ IN NUMBER, price_unit_meas_ IN VARCHAR2, from_date_ IN DATE) IS
      SELECT *
      FROM agreement_assortment_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    min_quantity = min_quantity_
      AND    price_unit_meas = price_unit_meas_
      AND    valid_from = from_date_;
   
BEGIN

   IF (include_period_ = 'FALSE') THEN
      FOR line_rec_ IN find_null_valid_to_date_recs LOOP
         new_valid_from_date_ := NULL;
         create_new_line_ := FALSE;
         exist_rec_ := NULL;
         next_valid_from_date_ := NULL;
         next_valid_to_date_ := NULL;
         IF (line_rec_.valid_from < valid_from_date_) THEN
            -- Need to create a new line with valid from_date = valid_from_date_.
            -- For that we need to check whether any record exists with that valid_from_date.
            next_valid_from_found_ := FALSE;
            new_valid_from_date_ := valid_from_date_;
            LOOP
               EXIT WHEN (next_valid_from_found_);
              -- new_valid_from_date_ := timeframe_valid_to_date_ + 1;
               OPEN get_exist_record(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.min_quantity, line_rec_.price_unit_meas, new_valid_from_date_);
               FETCH get_exist_record INTO exist_rec_;
               IF (get_exist_record%FOUND) THEN
                  CLOSE get_exist_record;
                  IF (exist_rec_.valid_to IS NULL) THEN
                     -- record exist with valid_from_date = new_valid_from_date_ and valid_to_date null. Hence no need to create a new record
                     next_valid_from_found_ := TRUE;
                     create_new_line_ := FALSE;
                  ELSE
                     new_valid_from_date_ := exist_rec_.valid_to + 1; 
                  END IF;   
               ELSE
                  CLOSE get_exist_record;
                  create_new_line_ := TRUE;
                  next_valid_from_found_ := TRUE;
               END IF;   
            END LOOP;
            IF (create_new_line_) THEN
               -- find the next record with valid_to_date null. If that record valid_from_date is earlier than our new valid_from_date then no need to create the record
               OPEN check_overlap_rec_found(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.min_quantity, line_rec_.price_unit_meas, valid_from_date_, new_valid_from_date_);
               FETCH check_overlap_rec_found INTO dummy_;
               IF (check_overlap_rec_found%NOTFOUND) THEN
                  CLOSE check_overlap_rec_found;
                  -- create new record with valid_from_date = new_valid_from_date_
                  Adjust_Or_Duplicate_Asortmt___(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id,
                                                 line_rec_.price_unit_meas, line_rec_.min_quantity, line_rec_.valid_from, new_valid_from_date_,
                                                 percentage_offset_, amount_offset_, NULL);                               
                  counter_ := counter_ + 1;
               ELSE
                  CLOSE check_overlap_rec_found;
               END IF;
            END IF;   
         ELSE
            -- valid_from_date >= user defined from_date. Hence update those records with the given offset.
            Adjust_Or_Duplicate_Asortmt___(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id,
                                           line_rec_.price_unit_meas, line_rec_.min_quantity, line_rec_.valid_from, line_rec_.valid_from,
                                           percentage_offset_, amount_offset_, NULL);                               
            counter_ := counter_ + 1;
         END IF;   
      END LOOP; 
   ELSE
      -- include_period = TRUE
      FOR line_rec_ IN find_valid_record LOOP
         next_valid_to_date_ := NULL;
         create_new_line_ := FALSE;
         exist_rec_ := NULL; 
         new_line_from_date_ := NULL;
         IF ((NVL(prev_agreement_id_, line_rec_.agreement_id) != line_rec_.agreement_id) OR 
            (NVL(prev_assortment_id_, line_rec_.assortment_id) != line_rec_.assortment_id) OR
            (NVL(prev_assortment_node_id_, line_rec_.assortment_node_id) != line_rec_.assortment_node_id) OR
            (NVL(prev_price_unit_meas_, line_rec_.price_unit_meas) != line_rec_.price_unit_meas) OR
            (NVL(prev_min_quantity_, line_rec_.min_quantity) != line_rec_.min_quantity)) THEN
           same_date_record_updated_ := FALSE;
           new_rec_created_on_from_date_ := FALSE;
        END IF;
         IF (line_rec_.valid_from < valid_from_date_) THEN
            IF (line_rec_.valid_to IS NOT NULL) THEN
               -- timeframe record found. that has to be broken into two. with old prices and new prices with adjustments.
               -- update record with valid_to_date = valid_from_date_ - 1 
               new_valid_to_date_ := valid_from_date_ - 1;
               Agreement_Assortment_Deal_API.Modify_Valid_To_Date(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.min_quantity,
                                                                  line_rec_.valid_from, line_rec_.price_unit_meas, new_valid_to_date_);
            END IF;
            -- create a new line with valid from date = valid_from_date_. If any line exists with same valid_from_date_ update that record
            OPEN get_exist_record(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.min_quantity, line_rec_.price_unit_meas, valid_from_date_);
            FETCH get_exist_record INTO exist_rec_;
            CLOSE get_exist_record;
            IF (exist_rec_.valid_from IS NOT NULL) THEN
               IF (line_rec_.valid_to IS NOT NULL) THEN
                  deal_price_ := ROUND((line_rec_.deal_price * (1 + percentage_offset_ / 100)) + amount_offset_, NVL(line_rec_.rounding,20));
                  IF (NOT same_date_record_updated_) THEN
                     -- update existing record with price information of line_rec_ and offset
                     deal_price_ := ROUND((line_rec_.deal_price * (1 + percentage_offset_ / 100)) + amount_offset_, NVL(line_rec_.rounding,20));
                     Agreement_Assortment_Deal_API.Modify_Deal_Price(line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.agreement_id, line_rec_.min_quantity,
                                                                     valid_from_date_, line_rec_.price_unit_meas, deal_price_, line_rec_.valid_to);
                     counter_ := counter_ + 1;
                     same_date_record_updated_ := TRUE;
                  END IF;
                  next_valid_to_date_ := line_rec_.valid_to;
                  IF (exist_rec_.valid_to IS NULL AND same_date_record_updated_) THEN
                     Agreement_Assortment_Deal_API.Modify_Deal_Price(line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.agreement_id, line_rec_.min_quantity,
                                                                     exist_rec_.valid_from, line_rec_.price_unit_meas, deal_price_, next_valid_to_date_);
                  END IF;
               ELSE
                  IF (NOT same_date_record_updated_) THEN
                     -- if line_rec_ is not timeframed, existing record can be modified only with offset values
                     Adjust_Or_Duplicate_Asortmt___(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id,
                                                    line_rec_.price_unit_meas, line_rec_.min_quantity, exist_rec_.valid_from, valid_from_date_,
                                                    percentage_offset_, amount_offset_, exist_rec_.valid_to);                                                 
                     counter_ := counter_ + 1;
                     same_date_record_updated_ := TRUE;
                  END IF;   
                  next_valid_to_date_ := exist_rec_.valid_to;
               END IF;
               next_valid_from_found_ := FALSE;
               create_new_line_ := FALSE;
               LOOP
                  EXIT WHEN next_valid_from_found_;
                  new_line_from_date_ := next_valid_to_date_ + 1;
                  OPEN get_next_adjacent_rec(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.min_quantity, line_rec_.price_unit_meas, new_line_from_date_);
                  FETCH get_next_adjacent_rec INTO next_valid_to_date_;
                  IF (get_next_adjacent_rec%FOUND) THEN
                     CLOSE get_next_adjacent_rec;
                     IF (next_valid_to_date_ IS NULL) THEN
                        next_valid_from_found_ := TRUE;
                        create_new_line_ := FALSE;
                     END IF;
                  ELSE
                     CLOSE get_next_adjacent_rec;
                     create_new_line_ := TRUE;
                     next_valid_from_found_ := TRUE;
                  END IF;
               END LOOP;
               IF (create_new_line_) THEN
                  -- need to create a new line with valid_from_date = next_valid_to_date_ + 1;.
                  OPEN check_overlap_rec_found(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.min_quantity, line_rec_.price_unit_meas, valid_from_date_, new_line_from_date_);
                  FETCH check_overlap_rec_found INTO dummy_;
                  IF (check_overlap_rec_found%NOTFOUND) THEN
                     CLOSE check_overlap_rec_found;
                     IF (line_rec_.valid_to IS NOT NULL) THEN
                        -- create new line on new_line_from_date_
                        deal_price_ := ROUND((exist_rec_.deal_price * (1 + percentage_offset_ / 100)) + amount_offset_, NVL(exist_rec_.rounding,20));
                        IF (new_rec_created_on_from_date_) THEN
                           --  offset has already adjusted.. so need to re-calculate it.
                           deal_price_ := exist_rec_.deal_price;
                        END IF;
                        -- create new timeframed record with valid from date = valid_from_date_ and adjust offset
                        Agreement_Assortment_Deal_API.New(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.price_unit_meas,
                                                          line_rec_.min_quantity, new_line_from_date_, deal_price_, exist_rec_.provisional_price,
                                                          exist_rec_.discount_type, exist_rec_.discount, exist_rec_.net_price, exist_rec_.rounding, NULL);
                        IF (exist_rec_.discount IS NOT NULL) THEN
                           Agreement_Assort_Discount_API.Copy_All_Discount_Lines__(line_rec_.agreement_id, line_rec_.min_quantity, exist_rec_.valid_from, line_rec_.price_unit_meas,
                                                                                   line_rec_.assortment_id, line_rec_.assortment_node_id, line_rec_.agreement_id, line_rec_.min_quantity,
                                                                                   new_valid_from_date_, line_rec_.price_unit_meas, line_rec_.assortment_id, line_rec_.assortment_node_id, 1);
                        END IF;                                                          
                        counter_ := counter_ + 1;
                     ELSE
                        Adjust_Or_Duplicate_Asortmt___(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id,
                                                       line_rec_.price_unit_meas, line_rec_.min_quantity, line_rec_.valid_from, new_line_from_date_,
                                                       percentage_offset_, amount_offset_, NULL);                                                       
                        counter_ := counter_ + 1;
                     END IF;
                  ELSE
                     CLOSE check_overlap_rec_found;
                     -- no need to create the line
                  END IF;
               END IF;
            ELSE
               IF (NOT same_date_record_updated_) THEN
                  -- No record exists on user defined from_date_. Hence Create a new line on that date with offset adjustment     
                  Adjust_Or_Duplicate_Asortmt___(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id,
                                                 line_rec_.price_unit_meas, line_rec_.min_quantity, line_rec_.valid_from, valid_from_date_,
                                                 percentage_offset_, amount_offset_, line_rec_.valid_to);                               
                  counter_ := counter_ + 1;
                  same_date_record_updated_ := TRUE;
                  new_rec_created_on_from_date_ := TRUE;
               END IF;
            END IF;
         ELSIF ((line_rec_.valid_from > valid_from_date_) OR (line_rec_.valid_from = valid_from_date_ AND NOT same_date_record_updated_)) THEN
            -- update the line with offset values
            Adjust_Or_Duplicate_Asortmt___(line_rec_.agreement_id, line_rec_.assortment_id, line_rec_.assortment_node_id,
                                           line_rec_.price_unit_meas, line_rec_.min_quantity, line_rec_.valid_from, line_rec_.valid_from,
                                           percentage_offset_, amount_offset_, line_rec_.valid_to);                                            
            counter_ := counter_ + 1;
         END IF;
         prev_agreement_id_ := line_rec_.agreement_id;
         prev_assortment_id_ := line_rec_.assortment_id;
         prev_assortment_node_id_ := line_rec_.assortment_node_id;
         prev_price_unit_meas_ := line_rec_.price_unit_meas;
         prev_min_quantity_ := line_rec_.min_quantity;
      END LOOP;
   END IF;
   number_of_updates_ := counter_;
END Update_Assortment_Prices___;


-- Adjust_Or_Duplicate_Asortmt___
--   Duplicate an agreement deal per assortment line with new deal price and new
--   valid from date. If valid line exists, modify deal price.
PROCEDURE Adjust_Or_Duplicate_Asortmt___ (
   agreement_id_          IN VARCHAR2,
   assortment_id_         IN VARCHAR2,
   assortment_node_id_    IN VARCHAR2,
   price_unit_meas_       IN VARCHAR2,
   min_quantity_          IN NUMBER,
   valid_from_date_       IN DATE,
   new_valid_from_date_   IN DATE,
   percentage_offset_     IN NUMBER,
   amount_offset_         IN NUMBER,
   valid_to_date_         IN DATE )
IS
   provisional_price_   VARCHAR2(20);
   net_price_           VARCHAR2(20);
   discount_type_       VARCHAR2(25);
   discount_            NUMBER;
   deal_price_          NUMBER;
   rounding_            NUMBER;

   CURSOR get_deal_per_assortment_info IS
      SELECT deal_price, provisional_price, discount_type, discount, net_price, rounding
      FROM   agreement_assortment_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas = price_unit_meas_
      AND    min_quantity = min_quantity_
      AND    valid_from = valid_from_date_;
BEGIN

   -- Fetch record to duplicate.
   OPEN  get_deal_per_assortment_info;
   FETCH get_deal_per_assortment_info INTO deal_price_, provisional_price_, discount_type_,
                                           discount_, net_price_, rounding_;
   IF (get_deal_per_assortment_info%NOTFOUND) THEN
      CLOSE get_deal_per_assortment_info;
      Trace_SYS.Message('No record found');
   ELSE
      CLOSE get_deal_per_assortment_info;

      -- Calculate new deal price.
      deal_price_ := (deal_price_ * (1 + percentage_offset_ / 100)) + amount_offset_;

      IF (new_valid_from_date_ = valid_from_date_) THEN
         -- Record already exist. Modify deal price.
         Agreement_Assortment_Deal_API.Modify_Deal_Price(assortment_id_, assortment_node_id_, agreement_id_, min_quantity_,
                                                         valid_from_date_, price_unit_meas_, deal_price_, valid_to_date_);
      ELSE
         -- Duplicate record with new valid_from_date.
         Agreement_Assortment_Deal_API.New(agreement_id_, assortment_id_, assortment_node_id_, price_unit_meas_,
                                           min_quantity_, new_valid_from_date_, deal_price_, provisional_price_,
                                           discount_type_, discount_, net_price_, rounding_, valid_to_date_);


         IF (discount_ IS NOT NULL) THEN
            Agreement_Assort_Discount_API.Copy_All_Discount_Lines__ (agreement_id_, min_quantity_, valid_from_date_, price_unit_meas_,
                                                                     assortment_id_, assortment_node_id_, agreement_id_, min_quantity_,
                                                                     new_valid_from_date_, price_unit_meas_, assortment_id_, assortment_node_id_, 1);
         END IF;
      END IF;
   END IF;
END Adjust_Or_Duplicate_Asortmt___;


@Override
PROCEDURE Finite_State_Set___ (
   rec_   IN OUT CUSTOMER_AGREEMENT_TAB%ROWTYPE,
   state_ IN     VARCHAR2 )
IS
BEGIN
   IF (state_ = 'Active' AND rec_.assortment_id IS NOT NULL) THEN
      IF (Assortment_Structure_API.Get_Objstate(rec_.assortment_id) != 'Active') THEN
         Raise_Assort_Not_Act_Error___(rec_.assortment_id);
      END IF;
   END IF;
   super(rec_, state_);
END Finite_State_Set___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);

   Client_SYS.Add_To_Attr('VALID_FROM', SYSDATE, attr_ );
   Client_SYS.Add_To_Attr('AGREEMENT_DATE', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_SENT_DB', 'N', attr_);
   Client_SYS.Add_To_Attr('USE_EXPLICIT_DB', 'N', attr_);
   Client_SYS.Add_To_Attr('REBATE_BUILDER_DB', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_BREAK_TEMPLATES_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('USE_BY_OBJECT_HEAD_DB', Fnd_Boolean_API.DB_TRUE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_AGREEMENT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.agreement_id IS NULL) THEN
      newrec_.agreement_id := Get_Next_Agreement_Id___;
   END IF;
   Client_SYS.Add_To_Attr('AGREEMENT_ID', newrec_.agreement_id, attr_);
   IF (newrec_.description IS NULL) THEN
      newrec_.description := newrec_.agreement_id;
   END IF;

   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);

   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUSTOMER_AGREEMENT_TAB%ROWTYPE,
   newrec_     IN OUT CUSTOMER_AGREEMENT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (oldrec_.use_price_incl_tax != newrec_.use_price_incl_tax) THEN
      Agreement_Part_Discount_API.Update_Discount_Lines(newrec_.agreement_id);
   END IF;
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CUSTOMER_AGREEMENT_TAB%ROWTYPE )
IS
   CURSOR check_order_line IS
      SELECT 1
      FROM  customer_order_line_tab
      WHERE price_source = 'AGREEMENT'
      AND   price_source_id = remrec_.agreement_id;

   CURSOR check_quotation_line IS
      SELECT 1
      FROM  order_quotation_line_tab
      WHERE price_source = 'AGREEMENT'
      AND   price_source_id = remrec_.agreement_id;

   CURSOR check_ord_line_disc IS
      SELECT 1
      FROM   cust_order_line_discount_tab
      WHERE  discount_source = 'AGREEMENT'
      AND    discount_source_id = remrec_.agreement_id;

   CURSOR check_quot_line_disc IS
      SELECT 1
      FROM   order_quote_line_discount_tab
      WHERE  discount_source = 'AGREEMENT'
      AND    discount_source_id = remrec_.agreement_id;

   CURSOR check_price_query IS
      SELECT 1
      FROM  price_query_tab
      WHERE price_source = 'AGREEMENT'
      AND   price_source_id = remrec_.agreement_id;

   CURSOR check_price_query_discount IS
      SELECT 1 
      FROM  price_query_discount_line_tab
      WHERE discount_source = 'AGREEMENT'
      AND   discount_source_id = remrec_.agreement_id;
   
   dummy_            NUMBER;
   agreement_found_  EXCEPTION;
BEGIN
   IF (Get_Objstate(remrec_.agreement_id) = 'Active') THEN
      -- Check order lines
      OPEN check_order_line;
      FETCH check_order_line INTO dummy_;
      IF (check_order_line%FOUND) THEN
         CLOSE check_order_line;
         RAISE agreement_found_;
      END IF;
      CLOSE check_order_line;

      -- Check quotation lines
      OPEN check_quotation_line;
      FETCH check_quotation_line INTO dummy_;
      IF (check_quotation_line%FOUND) THEN
         CLOSE check_quotation_line;
         RAISE agreement_found_;
      END IF;
      CLOSE check_quotation_line;

      -- Check order line discount lines
      OPEN check_ord_line_disc;
      FETCH check_ord_line_disc INTO dummy_;
      IF (check_ord_line_disc%FOUND) THEN
         CLOSE check_ord_line_disc;
         RAISE agreement_found_;
      END IF;
      CLOSE check_ord_line_disc;

      -- Check order quotation discount lines
      OPEN check_quot_line_disc;
      FETCH check_quot_line_disc INTO dummy_;
      IF (check_quot_line_disc%FOUND) THEN
         CLOSE check_quot_line_disc;
         RAISE agreement_found_;
      END IF;
      CLOSE check_quot_line_disc;

      -- Check price query
      OPEN check_price_query;
      FETCH check_price_query INTO dummy_;
      IF (check_price_query%FOUND) THEN
         CLOSE check_price_query;
         RAISE agreement_found_;
      END IF;
      CLOSE check_price_query;

      -- Check price query discount
      OPEN check_price_query_discount;
      FETCH check_price_query_discount INTO dummy_;
      IF (check_price_query_discount%FOUND) THEN
         CLOSE check_price_query_discount;
         RAISE agreement_found_;
      END IF;
      CLOSE check_price_query_discount;
   END IF;

   super(remrec_);  
   $IF (Component_Callc_SYS.INSTALLED) $THEN
      Cc_Case_Business_Object_API.Check_Reference_Exist('CUSTOMER_AGREEMENT', remrec_.agreement_id );
      Cc_Case_Sol_Business_Obj_API.Check_Reference_Exist('CUSTOMER_AGREEMENT', remrec_.agreement_id );
   $END
   $IF (Component_Supkey_SYS.INSTALLED) $THEN
      Cc_Sup_Key_Business_Obj_API.Check_Reference_Exist('CUSTOMER_AGREEMENT', remrec_.agreement_id);
   $END    

EXCEPTION
   WHEN agreement_found_ THEN
      Error_SYS.Record_General(lu_name_, 'DELETEAGRMNTNOTALLOWED: The Customer Agreement :P1 is used in another object.', remrec_.agreement_id);
END Check_Delete___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     customer_agreement_tab%ROWTYPE,
   newrec_ IN OUT customer_agreement_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   dummy_currtype_    VARCHAR2(10);
   dummy_conv_factor_ NUMBER;
   dummy_rate_        NUMBER;
BEGIN
   IF (newrec_.sup_agreement_id = newrec_.agreement_id) THEN
      Error_SYS.Record_General(lu_name_, 'NOT_SAME_AGREEMENT: The field Superseded Agreement Id can not point to the current agreement!');   
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF ((newrec_.valid_from IS NOT NULL) AND (newrec_.valid_until IS NOT NULL)
      AND ( newrec_.valid_from > newrec_.valid_until )) THEN
      Error_Sys.Record_General(lu_name_,'FINDATE: The final date may not be earlier than the start date.');
   END IF;
   
   IF ((newrec_.delivery_terms IS NULL) AND (newrec_.del_terms_location IS NOT NULL)) THEN
      Error_Sys.Record_General(lu_name_, 'NODELTERMS: Delivery terms should also be specified in order to enter delivery term location.');
   END IF;
   
   IF (indrec_.valid_from AND newrec_.valid_from > Get_Earliest_Valid_From___(newrec_.agreement_id)) THEN
      Client_SYS.Add_Info(lu_name_, 'EARLY_VALID_FROM_EXISTS: Customer Agreement lines exist where Valid From date is earlier than Customer Agreement Valid From date.');
   END IF;
   
   IF (indrec_.valid_until AND newrec_.valid_until < Get_Latest_Valid_To___(newrec_.agreement_id)) THEN
       Client_SYS.Add_Info(lu_name_, 'LATE_VALID_TO_EXISTS: Customer Agreement lines exist where either Valid From date or Valid To date is later than Customer Agreement To Date.');
   END IF;

   -- Checking if the currency code has a valid currency rate for this company, this method gives an error no valid currency rate exist for this company/currency code
   Invoice_Library_API.Get_Currency_Rate_Defaults(dummy_currtype_, dummy_conv_factor_, dummy_rate_, newrec_.company, newrec_.currency_code, SYSDATE, 'CUSTOMER', NULL);
END Check_Common___;




@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_agreement_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN 
   IF indrec_.agreement_sent = FALSE OR newrec_.agreement_sent IS NULL THEN
      newrec_.agreement_sent := 'N';
   END IF;
   IF indrec_.use_price_incl_tax = FALSE OR newrec_.use_price_incl_tax IS NULL THEN
      newrec_.use_price_incl_tax := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF indrec_.use_by_object_head = FALSE OR newrec_.use_by_object_head IS NULL THEN
      newrec_.use_by_object_head := Fnd_Boolean_API.DB_TRUE;
   END IF;
   
   super(newrec_, indrec_, attr_);
      
   IF (newrec_.agreement_id IS NOT NULL) THEN
      Error_SYS.Check_Not_Null(lu_name_, 'DESCRIPTION', newrec_.description);
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_agreement_tab%ROWTYPE,
   newrec_ IN OUT customer_agreement_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS      
   
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);   

   IF (newrec_.rowstate = 'Active' AND newrec_.assortment_id IS NOT NULL) THEN
      IF (Assortment_Structure_API.Get_Objstate(newrec_.assortment_id) != 'Active') THEN
         Raise_Assort_Not_Act_Error___(newrec_.assortment_id);
      END IF;
   END IF;
   
   IF (NVL(oldrec_.assortment_id, Database_SYS.string_null_) != NVL(newrec_.assortment_id, Database_SYS.string_null_)) THEN
      IF Get_Id_In_Assortment_Deal(newrec_.agreement_id) IS NOT NULL THEN
         Error_SYS.Record_General(lu_name_, 'ASSORTNOTUPDATE: You cannot modify or delete an assortment ID with a deal per assortment line attached to it.');
      END IF;
      IF (newrec_.assortment_id IS NOT NULL) THEN
         IF (Agreement_Sales_Group_Deal_API.Check_Exist_For_Agrmnt(newrec_.agreement_id) = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'DEALGRPEXIST: Deal per sales group records already exists. Both deal per assortment and deal per sales group can not have records for an agreement.');
         END IF;
      END IF;
   END IF;
   
   IF (oldrec_.use_price_incl_tax != newrec_.use_price_incl_tax) THEN
      Agreement_Sales_Part_Deal_API.Modify_Deal_Prices(newrec_.agreement_id, newrec_.use_price_incl_tax);
   END IF;
   
END Check_Update___;

@Override
PROCEDURE Unpack___ (
   newrec_   IN OUT customer_agreement_tab%ROWTYPE,
   indrec_   IN OUT Indicator_Rec,
   attr_     IN OUT VARCHAR2 )
IS
   ptr_     NUMBER;
   name_    VARCHAR2(30);
   value_   VARCHAR2(4000);
BEGIN
   IF (newrec_.rowstate = 'Closed') THEN
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ NOT IN ('NOTE_TEXT', 'COMMENTS')) THEN
            Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Update not allowed when status is closed');   
         END IF;
      END LOOP;
   END IF;
   super(newrec_, indrec_, attr_);
END Unpack___;

FUNCTION Get_Earliest_Valid_From___ (
   agreement_id_  IN  VARCHAR2 ) RETURN DATE
IS
   earliest_valid_from_  DATE;  
   
   CURSOR get_early_valid_from_date IS
      SELECT MIN(valid_from_date)
      FROM
         (SELECT MIN(valid_from_date) valid_from_date
          FROM   AGREEMENT_SALES_PART_DEAL_TAB
          WHERE  agreement_id = agreement_id_
          UNION
          SELECT MIN(valid_from_date) valid_from_date
          FROM AGREEMENT_SALES_GROUP_DEAL_TAB
          WHERE agreement_id = agreement_id_
          UNION
          SELECT MIN(valid_from) valid_from_date
          FROM AGREEMENT_ASSORTMENT_DEAL_TAB
          WHERE agreement_id = agreement_id_);
BEGIN
   OPEN get_early_valid_from_date;
   FETCH get_early_valid_from_date INTO earliest_valid_from_;
   CLOSE get_early_valid_from_date;
   
   RETURN earliest_valid_from_;
END Get_Earliest_Valid_From___;


FUNCTION Get_Latest_Valid_To___ (
   agreement_id_  IN  VARCHAR2 ) RETURN DATE
IS
   latest_valid_to_  DATE;  
   
   CURSOR get_late_valid_to_date IS
      SELECT MAX(max_valid_to_date)
      FROM
         (SELECT MAX(valid_to_date) max_valid_to_date
          FROM   AGREEMENT_SALES_PART_DEAL_TAB
          WHERE  agreement_id = agreement_id_
          AND    valid_to_date IS NOT NULL
          UNION
          SELECT MAX(valid_from_date) max_valid_to_date
          FROM   AGREEMENT_SALES_PART_DEAL_TAB
          WHERE  agreement_id = agreement_id_
          AND    valid_to_date IS NULL
          UNION
          SELECT MAX(valid_to_date) max_valid_to_date
          FROM AGREEMENT_SALES_GROUP_DEAL_TAB
          WHERE agreement_id = agreement_id_
          AND    valid_to_date IS NOT NULL
          UNION
          SELECT MAX(valid_from_date) max_valid_to_date
          FROM AGREEMENT_SALES_GROUP_DEAL_TAB
          WHERE agreement_id = agreement_id_
          AND    valid_to_date IS NULL
          UNION
          SELECT MAX(valid_to) max_valid_to_date
          FROM AGREEMENT_ASSORTMENT_DEAL_TAB
          WHERE agreement_id = agreement_id_
          AND   valid_to IS NOT NULL
          UNION
          SELECT MAX(valid_from) max_valid_to_date
          FROM AGREEMENT_ASSORTMENT_DEAL_TAB
          WHERE agreement_id = agreement_id_
          AND   valid_to IS NULL);
BEGIN
   OPEN get_late_valid_to_date;
   FETCH get_late_valid_to_date INTO latest_valid_to_;
   CLOSE get_late_valid_to_date;
   
   RETURN latest_valid_to_;
END Get_Latest_Valid_To___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_Agreement__
--   Copies an Existing agreement to a new one.
PROCEDURE Copy_Agreement__ (
   to_agreement_id_     IN OUT VARCHAR2,
   raise_msg_           IN OUT VARCHAR2,
   agreement_id_        IN     VARCHAR2,
   valid_from_date_     IN     DATE,
   to_agreement_desc_   IN     VARCHAR2,
   to_customer_no_      IN     VARCHAR2,
   to_currency_code_    IN     VARCHAR2,
   to_company_          IN     VARCHAR2,
   to_valid_from_date_  IN     DATE,
   currency_rate_       IN     NUMBER,
   copy_doc_text_       IN     NUMBER,
   copy_notes_          IN     NUMBER,
   copy_dates_          IN     NUMBER DEFAULT 1)
IS
   attr_                    VARCHAR2(20000);
   copyrec_                 CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   newrec_                  CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   new_company_             CUSTOMER_AGREEMENT_TAB.company%TYPE;
   new_note_id_             CUSTOMER_AGREEMENT_TAB.note_id%TYPE;
   currtype_                VARCHAR2(10);
   conv_factor_             NUMBER;
   temp_currency_rate_      NUMBER;
   rate_                    NUMBER;
   objid_                   VARCHAR2(2000);
   objversion_              VARCHAR2(2000);
   dummy_                   NUMBER;
   company_                 CUSTOMER_AGREEMENT_TAB.company%TYPE;
   indrec_                  Indicator_Rec;
   row_select_state_        VARCHAR2(20); 
   raise_msg_part_deal_     VARCHAR2(20);
   raise_msg_group_deal_    VARCHAR2(20);
   raise_msg_assort_deal_   VARCHAR2(20);

   CURSOR get_attr IS
      SELECT *
      FROM CUSTOMER_AGREEMENT_TAB
      WHERE agreement_id = agreement_id_;

   CURSOR user_company (company_ VARCHAR2) IS
   SELECT 1
   FROM COMPANY_FINANCE_AUTH_PUB
   WHERE company = company_;

BEGIN
   raise_msg_ := 'FALSE';
   company_ := Customer_Agreement_API.Get_Company(agreement_id_);
   OPEN user_company(company_);
   FETCH user_company INTO dummy_;
   IF (user_company%NOTFOUND) THEN
      CLOSE user_company;
      Error_SYS.Record_General(lu_name_, 'VALIDCOMPANY: Agreement :P1 belongs to company :P2. It is not allowed to copy agreements from companies that you are not connected to.', agreement_id_, company_);
   END IF;
   CLOSE user_company;

   IF (to_valid_from_date_ IS NOT NULL) AND (valid_from_date_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'VALID_FROM_DATE: The Valid From must be entered on the source agreement when using Valid From on the destination agreement.');
   END IF;

   -- Check if from agreement exist
   IF (NOT Check_Exist___(agreement_id_)) THEN
      Error_SYS.Record_General(lu_name_, 'NO_AGREEMENT_EXIST: Customer Agreement :P1 does not exist.', agreement_id_);
   END IF;

   --From Customer Agreement
   OPEN get_attr;
   FETCH get_attr INTO copyrec_;
   CLOSE get_attr;

   Prepare_Insert___(attr_);

   IF (to_agreement_id_ IS NOT NULL ) THEN
      -- Check if to agreement already exists
      IF (Check_Exist___(to_agreement_id_)) THEN
         Error_SYS.Record_General(lu_name_, 'AGREEMENT_EXIST: Customer Agreement :P1 already exist.', to_agreement_id_);
      END IF;
      Client_SYS.Add_To_Attr('AGREEMENT_ID', to_agreement_id_, attr_);
   END IF;

   IF (to_company_ IS NOT NULL ) THEN
      Company_Finance_API.Exist(to_company_);
      new_company_ := to_company_;
   ELSE
      new_company_ := copyrec_.company;
   END IF;

   Client_SYS.Set_Item_Value('VALID_FROM', NVL(to_valid_from_date_, copyrec_.valid_from), attr_);
   Client_SYS.Set_Item_Value('USE_EXPLICIT_DB', copyrec_.use_explicit, attr_);

   IF (copyrec_.valid_until IS NOT NULL) THEN
      IF (copyrec_.valid_until > to_valid_from_date_) THEN
         Client_SYS.Add_To_Attr('VALID_UNTIL', copyrec_.valid_until, attr_);
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('DESCRIPTION', to_agreement_desc_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', to_customer_no_, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE', to_currency_code_, attr_);
   Client_SYS.Add_To_Attr('SHIP_VIA_CODE', copyrec_.ship_via_code, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TERMS', copyrec_.delivery_terms, attr_);
   Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', copyrec_.del_terms_location, attr_);
   Client_SYS.Add_To_Attr('AUTHORIZE_CODE', copyrec_.authorize_code, attr_);
   IF (copy_notes_ = 1) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', copyrec_.note_text, attr_);
   END IF;
   Client_SYS.Add_To_Attr('CUST_AGREEMENT_ID', copyrec_.cust_agreement_id, attr_);
   Client_SYS.Add_To_Attr('SUP_AGREEMENT_ID', copyrec_.sup_agreement_id, attr_);
   Client_SYS.Add_To_Attr('COMPANY', new_company_, attr_);
   Client_SYS.Add_To_Attr('COMMENTS', copyrec_.comments, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_ID', copyrec_.assortment_id, attr_);
   Client_SYS.Add_To_Attr('REBATE_BUILDER_DB', copyrec_.rebate_builder, attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_BREAK_TEMPLATES_DB', copyrec_.use_price_break_templates, attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', copyrec_.use_price_incl_tax, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   to_agreement_id_ := Client_SYS.Get_Item_Value('AGREEMENT_ID', attr_);
   new_note_id_ := Client_SYS.Get_Item_Value('NOTE_ID', attr_);

   IF (copy_doc_text_ = 1) THEN
      -- Copy document texts to the new agreement
      Document_Text_API.Copy_All_Note_Texts(copyrec_.note_id, new_note_id_);
   END IF;

   IF (currency_rate_ IS NULL) THEN
      IF (copyrec_.currency_code = to_currency_code_) THEN
         temp_currency_rate_ := 1;
      ELSE
         Invoice_Library_API.Get_Currency_Rate_Defaults(currtype_, conv_factor_, rate_, copyrec_.company, copyrec_.currency_code, SYSDATE, 'CUSTOMER', NULL);
         -- Currence rate for Source agreement's currency to base currency
         temp_currency_rate_ := rate_ / conv_factor_;
         Invoice_Library_API.Get_Currency_Rate_Defaults(currtype_, conv_factor_, rate_, copyrec_.company, to_currency_code_, SYSDATE, 'CUSTOMER', NULL);
         -- Currence rate for new agreement's currency from Source agreement's currency
         temp_currency_rate_ := temp_currency_rate_ * conv_factor_ / rate_ ;
      END IF;
   ELSE
      temp_currency_rate_ := currency_rate_;
   END IF;
   
   -- Checks whether 'Include lines with both Valid From and Valid To dates' check box checked.
   -- If checked then we copy all the dates including the valid_to_date lines, o.w we copy lines only with valid_from_date.
   IF copy_dates_ = 1 THEN
      row_select_state_ := 'Include_All_Dates';
   ELSE
      row_select_state_ := 'Include_From_Dates';
   END IF;

  -- Copy all rows on Customer Agreement-Deal Per Sales Part.
   Agreement_Sales_Part_Deal_API.Copy_All_Sales_Part_Deals__(raise_msg_, agreement_id_, to_agreement_id_, temp_currency_rate_, valid_from_date_, to_valid_from_date_, copy_notes_, copyrec_.use_price_incl_tax, row_select_state_);

   -- Copy all rows on Customer Agreement-Deal Per Sales Group.
   Agreement_Sales_Group_Deal_API.Copy_All_Sales_Group_Deals__(raise_msg_, agreement_id_, to_agreement_id_, valid_from_date_, to_valid_from_date_, copy_notes_, row_select_state_);

   --Copy all rows on Customer Agreement-Deal per Assortment.
   Agreement_Assortment_Deal_API.Copy_All_Assortment_Deals__(raise_msg_, agreement_id_, to_agreement_id_, temp_currency_rate_, valid_from_date_, to_valid_from_date_, copy_notes_, row_select_state_);

   IF (to_company_ = copyrec_.company) THEN
      --Copy all rows on Customer Agreement-Valid for Site.
      Customer_Agreement_Site_API.Copy_All_Agreement_Sites__(agreement_id_, to_agreement_id_);
   END IF;
END Copy_Agreement__;


-- Adjust_Offset_Agreement__
--   Adjust agreement offsets for a valid from date.
PROCEDURE Adjust_Offset_Agreement__ (
   number_of_adjustmets_   OUT NUMBER,
   agreement_id_           IN  VARCHAR2,
   percentage_offset_      IN  NUMBER,
   amount_offset_          IN  NUMBER,
   new_valid_from_date_    IN  DATE,
   adjustment_type_        IN  VARCHAR2,
   include_period_         IN  VARCHAR2 )
IS
   counter_                    NUMBER := 0;
   new_valid_to_date_          DATE;
   next_valid_from_found_      BOOLEAN := FALSE;
   dummy_                      NUMBER;
   create_new_line_            BOOLEAN;
   exist_rec_                  agreement_sales_part_deal_tab%ROWTYPE;
   deal_price_                NUMBER;
   next_valid_from_date_       DATE;
   next_valid_to_date_         DATE;
   same_date_record_updated_   BOOLEAN := FALSE;
   new_line_from_date_         DATE;
   deal_price_incl_tax_       NUMBER;
   use_price_incl_tax_db_      VARCHAR2(20);
   line_count_                 NUMBER := 0;
   final_percentage_offset_    NUMBER;
   final_amount_offset_        NUMBER;
   temp_info_                  VARCHAR2(2000);
   attr_                       VARCHAR2(2000); 
   calc_base_                  VARCHAR2(10);
   prev_catalog_no_            VARCHAR2(25);
   prev_min_quantity_          NUMBER;
   new_rec_created_on_from_date_ BOOLEAN;
   
   CURSOR find_null_valid_to_date_recs IS
      SELECT catalog_no, min_quantity, valid_from_date, deal_price, rounding, base_price, base_price_incl_tax, base_price_site,
             percentage_offset, amount_offset
      FROM   AGREEMENT_SALES_PART_DEAL_TAB
      WHERE  agreement_id = agreement_id_
      AND    valid_to_date IS NULL
      AND   (catalog_no, min_quantity, valid_from_date) IN
          (SELECT catalog_no, min_quantity, valid_from_date
           FROM  AGREEMENT_SALES_PART_DEAL_TAB
           WHERE (catalog_no, min_quantity, valid_from_date) IN
                 (SELECT catalog_no, min_quantity, MAX(valid_from_date) valid_from_date
                  FROM   AGREEMENT_SALES_PART_DEAL_TAB
                  WHERE  agreement_id = agreement_id_
                  AND    valid_from_date <= new_valid_from_date_
                  AND    valid_to_date IS NULL
                  GROUP BY catalog_no, min_quantity)
                  UNION ALL
                  (SELECT catalog_no, min_quantity, valid_from_date
                   FROM   AGREEMENT_SALES_PART_DEAL_TAB
                   WHERE  agreement_id = agreement_id_
                   AND    valid_from_date > new_valid_from_date_
                   AND    valid_to_date IS NULL))
      ORDER BY catalog_no, min_quantity, valid_from_date;
               
   CURSOR find_valid_record IS
      SELECT catalog_no, min_quantity, valid_from_date, valid_to_date, deal_price, rounding, base_price, base_price_incl_tax, base_price_site,
             percentage_offset, amount_offset
      FROM  AGREEMENT_SALES_PART_DEAL_TAB
      WHERE  agreement_id = agreement_id_
      AND    NVL(valid_to_date, new_valid_from_date_) >= new_valid_from_date_
      AND   (catalog_no, min_quantity, valid_from_date) IN
          (SELECT catalog_no, min_quantity, valid_from_date
           FROM  AGREEMENT_SALES_PART_DEAL_TAB
           WHERE (catalog_no, min_quantity, valid_from_date) IN
                 (SELECT catalog_no, min_quantity, MAX(valid_from_date) valid_from_date
                  FROM   AGREEMENT_SALES_PART_DEAL_TAB
                  WHERE  agreement_id = agreement_id_
                  AND    valid_from_date <= new_valid_from_date_
                  AND    valid_to_date IS NULL
                  GROUP BY catalog_no, min_quantity)
                  UNION ALL
                  (SELECT catalog_no, min_quantity, valid_from_date
                   FROM   AGREEMENT_SALES_PART_DEAL_TAB
                   WHERE  agreement_id = agreement_id_
                   AND    valid_from_date >= new_valid_from_date_)
                  UNION ALL
                  (SELECT catalog_no, min_quantity, valid_from_date
                  FROM   AGREEMENT_SALES_PART_DEAL_TAB
                  WHERE  agreement_id = agreement_id_
                  AND    valid_to_date IS NOT NULL
                  AND    valid_from_date < new_valid_from_date_
                  AND    valid_to_date >= new_valid_from_date_ ))
      ORDER BY catalog_no, min_quantity, valid_from_date;
               
   CURSOR get_adjacent_valid_rec(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, next_valid_from_date_ IN DATE) IS
      SELECT valid_to_date
      FROM   AGREEMENT_SALES_PART_DEAL_TAB
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = next_valid_from_date_;
            
   CURSOR check_overlap_rec_found(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, from_date_ IN DATE, to_date_ IN DATE) IS
      SELECT 1
      FROM AGREEMENT_SALES_PART_DEAL_TAB
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_to_date IS NULL
      AND    valid_from_date > from_date_
      AND    valid_from_date <= to_date_;
               
   CURSOR get_exist_record(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, from_date_ IN DATE) IS
      SELECT *
      FROM AGREEMENT_SALES_PART_DEAL_TAB
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = from_date_;
   
BEGIN
   --Adjustmet will be done only when percentage_offset!=0 or amount_offset!=0
   IF (percentage_offset_ != 0) OR (amount_offset_ != 0) THEN
      IF (include_period_ = 'FALSE') THEN
         FOR line_rec_ IN find_null_valid_to_date_recs LOOP
            create_new_line_ := FALSE;
            exist_rec_ := NULL;
            next_valid_from_date_ := NULL;
            next_valid_to_date_ := NULL;
            line_count_ := 0;
            IF (adjustment_type_ = 'AddToOffset') THEN
               final_percentage_offset_ := line_rec_.percentage_offset + percentage_offset_;
               final_amount_offset_     := line_rec_.amount_offset     + amount_offset_;
            ELSIF (adjustment_type_ =  'AdjustOffset') THEN
               final_percentage_offset_  := line_rec_.percentage_offset +(line_rec_.percentage_offset * percentage_offset_)/100;
               final_amount_offset_      := line_rec_.amount_offset     +(line_rec_.amount_offset * amount_offset_)/100;
            END IF;   
            IF (line_rec_.valid_from_date < new_valid_from_date_) THEN
               -- Need to create a new line with valid from_date = valid_from_date_.
               -- For that we need to check whether any record exists with that valid_from_date.
               next_valid_from_found_ := FALSE;
               next_valid_from_date_ := new_valid_from_date_;
               LOOP
                  EXIT WHEN (next_valid_from_found_);
                  OPEN get_exist_record(line_rec_.catalog_no, line_rec_.min_quantity, next_valid_from_date_);
                  FETCH get_exist_record INTO exist_rec_;
                  IF (get_exist_record%FOUND) THEN
                     CLOSE get_exist_record;
                     IF (exist_rec_.valid_to_date IS NULL) THEN
                        -- record exist with valid_from_date = valid_from_date_ and valid_to_date null. Hence no need to create a new record
                        next_valid_from_found_ := TRUE;
                        create_new_line_ := FALSE;
                     ELSE
                        next_valid_from_date_ := exist_rec_.valid_to_date + 1; 
                     END IF;   
                  ELSE
                     CLOSE get_exist_record;
                     create_new_line_ := TRUE;
                     next_valid_from_found_ := TRUE;
                  END IF;   
               END LOOP;
               IF (create_new_line_) THEN
                  -- find the next record with valid_to_date null. If that record valid_from_date is earlier than our new valid_from_date then no need to create the record
                  OPEN check_overlap_rec_found(line_rec_.catalog_no, line_rec_.min_quantity, new_valid_from_date_, next_valid_from_date_);
                  FETCH check_overlap_rec_found INTO dummy_;
                  IF (check_overlap_rec_found%NOTFOUND) THEN
                     CLOSE check_overlap_rec_found;
                     -- create new record with valid_from_date = next_valid_from_date_
                     Adjust_Or_Duplicate_Part___(line_count_, agreement_id_, line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                                 next_valid_from_date_, final_percentage_offset_, final_amount_offset_, NULL, FALSE, TRUE);
                     counter_ := counter_ + line_count_;
                  ELSE
                     -- No need to create a new line as period is covered by an existing line.
                     CLOSE check_overlap_rec_found;
                  END IF;
               END IF;   
            ELSE
               -- valid_from_date >= user defined from_date. Hence update those records with the given offset.
               Adjust_Or_Duplicate_Part___(line_count_, agreement_id_, line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                           line_rec_.valid_from_date, final_percentage_offset_, final_amount_offset_, NULL, FALSE, FALSE);
               counter_ := counter_ + line_count_;
            END IF;   
         END LOOP; 
      ELSE
         -- include_period = TRUE
         use_price_incl_tax_db_ := Customer_Agreement_API.Get_Use_Price_Incl_Tax_Db(agreement_id_);
         IF (use_price_incl_tax_db_ = 'TRUE') THEN
            calc_base_ := 'GROSS_BASE';
         ELSE
            calc_base_ := 'NET_BASE';
         END IF;
         FOR line_rec_ IN find_valid_record LOOP
            next_valid_to_date_ := NULL;
            create_new_line_ := FALSE;
            exist_rec_ := NULL; 
            new_line_from_date_ := NULL;
            IF ((NVL(prev_catalog_no_, line_rec_.catalog_no) != line_rec_.catalog_no) OR (NVL(prev_min_quantity_, line_rec_.min_quantity) != line_rec_.min_quantity)) THEN
               same_date_record_updated_ := FALSE;
               new_rec_created_on_from_date_ := FALSE;
            END IF;
            IF (adjustment_type_ = 'AddToOffset') THEN
               final_percentage_offset_ := line_rec_.percentage_offset + percentage_offset_;
               final_amount_offset_     := line_rec_.amount_offset     + amount_offset_;
            ELSIF (adjustment_type_ =  'AdjustOffset') THEN
               final_percentage_offset_ := line_rec_.percentage_offset +(line_rec_.percentage_offset * percentage_offset_)/100;
               final_amount_offset_     := line_rec_.amount_offset     +(line_rec_.amount_offset * amount_offset_)/100;
            END IF;
            IF (line_rec_.valid_from_date < new_valid_from_date_) THEN
               IF (line_rec_.valid_to_date IS NOT NULL) THEN
                  -- timeframe record found. that has to be broken into two. with old prices and new prices with adjustments.
                  -- update record with valid_to_date = new_valid_from_date_ - 1 
                  new_valid_to_date_ := new_valid_from_date_ - 1;
                  Agreement_Sales_Part_Deal_API.Modify_Valid_To_Date(agreement_id_, line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.valid_from_date, new_valid_to_date_);
               END IF;
               -- create a new line with valid from date = new_valid_from_date_. If any line exists with same new_valid_from_date_ update that record
               OPEN get_exist_record(line_rec_.catalog_no, line_rec_.min_quantity, new_valid_from_date_);
               FETCH get_exist_record INTO exist_rec_;
               CLOSE get_exist_record;
               IF (exist_rec_.valid_from_date IS NOT NULL) THEN
                  IF (line_rec_.valid_to_date IS NOT NULL) THEN
                     -- update existing record with price information of line_rec_ and offset
                     IF (NOT same_date_record_updated_) THEN
                        Sales_Part_Base_Price_API.Calculate_Part_Prices(line_rec_.base_price,
                                                                        line_rec_.base_price_incl_tax,
                                                                        deal_price_,
                                                                        deal_price_incl_tax_,
                                                                        final_percentage_offset_,      
                                                                        final_amount_offset_,    
                                                                        line_rec_.base_price_site,         
                                                                        line_rec_.catalog_no,       
                                                                        calc_base_,        
                                                                        'FORWARD',
                                                                        line_rec_.rounding,
                                                                        16);                                                                         
                        Agreement_Sales_Part_Deal_API.Modify_Offset(agreement_id_,
                                                                    line_rec_.catalog_no,
                                                                    line_rec_.min_quantity,
                                                                    new_valid_from_date_,
                                                                    final_percentage_offset_,
                                                                    final_amount_offset_,
                                                                    line_rec_.valid_to_date,
                                                                    deal_price_,
                                                                    deal_price_incl_tax_);                                                                         
                        counter_ := counter_ + 1;
                        same_date_record_updated_ := TRUE;
                     END IF;   
                     next_valid_to_date_ := line_rec_.valid_to_date;
                     IF (exist_rec_.valid_to_date IS NULL AND same_date_record_updated_) THEN
                        Agreement_Sales_Part_Deal_API.Modify_Offset(agreement_id_,
                                                                      line_rec_.catalog_no,
                                                                      line_rec_.min_quantity,
                                                                      exist_rec_.valid_from_date,
                                                                      final_percentage_offset_,
                                                                      final_amount_offset_,
                                                                      next_valid_to_date_,
                                                                      line_rec_.deal_price,
                                                                      deal_price_incl_tax_);
                     END IF;
                  ELSE
                     -- if line_rec_ is not timeframed, existing record can be modified only with offset values
                     IF (NOT same_date_record_updated_) THEN
                        IF (adjustment_type_ = 'AddToOffset') THEN
                           final_percentage_offset_ := exist_rec_.percentage_offset + percentage_offset_;
                           final_amount_offset_     := exist_rec_.amount_offset     + amount_offset_;
                        ELSIF (adjustment_type_ =  'AdjustOffset') THEN
                           final_percentage_offset_ := exist_rec_.percentage_offset +(exist_rec_.percentage_offset * percentage_offset_)/100;
                           final_amount_offset_     := exist_rec_.amount_offset     +(exist_rec_.amount_offset * amount_offset_)/100;
                        END IF;
                        Adjust_Or_Duplicate_Part___(line_count_, agreement_id_, line_rec_.catalog_no, line_rec_.min_quantity, exist_rec_.valid_from_date,
                                                    new_valid_from_date_, final_percentage_offset_, final_amount_offset_, exist_rec_.valid_to_date, FALSE, FALSE);
                        counter_ := counter_ + line_count_;
                        same_date_record_updated_ := TRUE;
                     END IF;   
                     next_valid_to_date_ := exist_rec_.valid_to_date;
                  END IF;
                  next_valid_from_found_ := FALSE;
                  create_new_line_ := FALSE;
                  LOOP
                     EXIT WHEN next_valid_from_found_;
                     new_line_from_date_ := next_valid_to_date_ + 1;
                     OPEN get_adjacent_valid_rec(line_rec_.catalog_no, line_rec_.min_quantity, new_line_from_date_);
                     FETCH get_adjacent_valid_rec INTO next_valid_to_date_;
                     IF (get_adjacent_valid_rec%FOUND) THEN
                        CLOSE get_adjacent_valid_rec;
                        IF (next_valid_to_date_ IS NULL) THEN
                           next_valid_from_found_ := TRUE;
                           create_new_line_ := FALSE;
                        END IF;
                     ELSE      
                        CLOSE get_adjacent_valid_rec;
                        create_new_line_ := TRUE;
                        next_valid_from_found_ := TRUE;
                     END IF;
                  END LOOP;
                  IF (create_new_line_) THEN
                     -- need to create a new line with valid_from_date = next_valid_to_date_ + 1;.
                     OPEN check_overlap_rec_found(line_rec_.catalog_no, line_rec_.min_quantity, new_valid_from_date_, new_line_from_date_);
                     FETCH check_overlap_rec_found INTO dummy_;
                     IF (check_overlap_rec_found%NOTFOUND) THEN
                        CLOSE check_overlap_rec_found;
                        IF (line_rec_.valid_to_date IS NOT NULL) THEN
                           -- create new line on new_line_from_date_
                           IF (adjustment_type_ = 'AddToOffset') THEN
                              final_percentage_offset_ := exist_rec_.percentage_offset + percentage_offset_;
                              final_amount_offset_     := exist_rec_.amount_offset     + amount_offset_;
                           ELSIF (adjustment_type_ =  'AdjustOffset') THEN
                              final_percentage_offset_ := exist_rec_.percentage_offset +(exist_rec_.percentage_offset * percentage_offset_)/100;
                              final_amount_offset_     := exist_rec_.amount_offset     +(exist_rec_.amount_offset * amount_offset_)/100;
                           END IF;
                           
                           IF (new_rec_created_on_from_date_) THEN
                              -- offset has already adjusted.. so need to re-calculate it.
                              final_percentage_offset_ := exist_rec_.percentage_offset;
                              final_amount_offset_     := exist_rec_.amount_offset;
                           END IF;
                                                                                                    
                           -- create new timeframed record with valid from date = new_valid_from_date_ and adjust offset
                           Sales_Part_Base_Price_API.Calculate_Part_Prices(exist_rec_.base_price,
                                                                           exist_rec_.base_price_incl_tax,
                                                                           deal_price_,
                                                                           deal_price_incl_tax_,
                                                                           final_percentage_offset_,      
                                                                           final_amount_offset_,    
                                                                           exist_rec_.base_price_site,         
                                                                           exist_rec_.catalog_no,       
                                                                           calc_base_,        
                                                                           'FORWARD',
                                                                           line_rec_.rounding,
                                                                           16);
                           Client_SYS.Set_Item_Value('AGREEMENT_ID', agreement_id_, attr_);
                           Client_SYS.Set_Item_Value('MIN_QUANTITY', line_rec_.min_quantity, attr_);
                           Client_SYS.Set_Item_Value('VALID_FROM_DATE', new_line_from_date_, attr_);
                           Client_SYS.Set_Item_Value('CATALOG_NO', line_rec_.catalog_no, attr_);
                           Client_SYS.Set_Item_Value('BASE_PRICE_SITE', line_rec_.base_price_site, attr_);
                           Client_SYS.Set_Item_Value('DISCOUNT_TYPE', exist_rec_.discount_type, attr_);
                           Client_SYS.Set_Item_Value('DISCOUNT', exist_rec_.discount, attr_);
                           Client_SYS.Set_Item_Value('BASE_PRICE', exist_rec_.base_price, attr_);
                           Client_SYS.Set_Item_Value('BASE_PRICE_INCL_TAX', exist_rec_.base_price_incl_tax, attr_);
                           Client_SYS.Set_Item_Value('DEAL_PRICE', deal_price_, attr_);
                           Client_SYS.Set_Item_Value('DEAL_PRICE_INCL_TAX', deal_price_incl_tax_, attr_);
                           Client_SYS.Set_Item_Value('PERCENTAGE_OFFSET', final_percentage_offset_, attr_);
                           Client_SYS.Set_Item_Value('AMOUNT_OFFSET', final_amount_offset_, attr_);
                           Client_SYS.Set_Item_Value('ROUNDING', exist_rec_.rounding, attr_);
                           Client_SYS.Set_Item_Value('NET_PRICE_DB', exist_rec_.net_price, attr_);
                           Client_SYS.Set_Item_Value('PROVISIONAL_PRICE_DB', exist_rec_.provisional_price, attr_);
                           Client_SYS.Set_Item_Value('PRICE_BREAK_TEMPLATE_ID', exist_rec_.price_break_template_id, attr_);
                           Client_SYS.Set_Item_Value('SERVER_DATA_CHANGE', 1, attr_);
                                     
                           Agreement_Sales_Part_Deal_API.New(temp_info_, attr_);
                         /*  IF (exist_rec_.discount IS NOT NULL) THEN
                              Agreement_Part_Discount_API.Copy_All_Discount_Lines__(agreement_id_, min_quantity_, valid_from_date_, catalog_no_,
                                                                                    agreement_id_, min_quantity_, new_valid_from_date_, catalog_no_,
                                                                                    currency_rate_);
                           END IF; */
                           counter_ := counter_ + 1;
                        ELSE
                           IF (adjustment_type_ = 'AddToOffset') THEN
                              final_percentage_offset_ := line_rec_.percentage_offset + percentage_offset_;
                              final_amount_offset_     := line_rec_.amount_offset     + amount_offset_;
                           ELSIF (adjustment_type_ =  'AdjustOffset') THEN
                              final_percentage_offset_ := line_rec_.percentage_offset +(line_rec_.percentage_offset * percentage_offset_)/100;
                              final_amount_offset_     := line_rec_.amount_offset     +(line_rec_.amount_offset * amount_offset_)/100;
                           END IF;
                           Adjust_Or_Duplicate_Part___(line_count_, agreement_id_, line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                                       new_line_from_date_, final_percentage_offset_, final_amount_offset_, NULL, FALSE, TRUE);
                           counter_ := counter_ + line_count_;
                        END IF;
                     ELSE
                        CLOSE check_overlap_rec_found;
                        -- no need to create the line
                     END IF;
                  END IF;
               ELSE
                  IF (NOT same_date_record_updated_) THEN
                     -- No record exists on user defined from_date_. Hence Create a new line on that date with offset adjustment
                     IF (adjustment_type_ = 'AddToOffset') THEN
                        final_percentage_offset_ := line_rec_.percentage_offset + percentage_offset_;
                        final_amount_offset_     := line_rec_.amount_offset     + amount_offset_;
                     ELSIF (adjustment_type_ =  'AdjustOffset') THEN
                        final_percentage_offset_ := line_rec_.percentage_offset +(line_rec_.percentage_offset * percentage_offset_)/100;
                        final_amount_offset_     := line_rec_.amount_offset     +(line_rec_.amount_offset * amount_offset_)/100;
                     END IF;
                     Adjust_Or_Duplicate_Part___(line_count_, agreement_id_, line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                                 new_valid_from_date_, final_percentage_offset_, final_amount_offset_, line_rec_.valid_to_date, FALSE, TRUE);
                     counter_ := counter_ + line_count_;
                     same_date_record_updated_ := TRUE;
                     new_rec_created_on_from_date_ := TRUE;
                  END IF;
               END IF;
            ELSIF ( (line_rec_.valid_from_date > new_valid_from_date_) OR (line_rec_.valid_from_date = new_valid_from_date_ AND NOT same_date_record_updated_)) THEN
               -- update the line with offset values
               Adjust_Or_Duplicate_Part___(line_count_, agreement_id_, line_rec_.catalog_no, line_rec_.min_quantity, line_rec_.valid_from_date,
                                           line_rec_.valid_from_date, final_percentage_offset_, final_amount_offset_, line_rec_.valid_to_date, FALSE, FALSE);
               counter_ := counter_ + line_count_;
            END IF;
            prev_catalog_no_ := line_rec_.catalog_no;
            prev_min_quantity_ := line_rec_.min_quantity;
         END LOOP; 
      END IF; 
   END IF;
   number_of_adjustmets_ := counter_;
END Adjust_Offset_Agreement__;


-- Remove_Invalid_Prices__
--   Remove all prices from customer agreements that are older than for a given date.
PROCEDURE Remove_Invalid_Prices__ (
   removed_items_    OUT NUMBER,
   valid_from_date_  IN  DATE,
   agreement_attr_   IN  VARCHAR2 )
IS
   counter_                 NUMBER := 0;
   agreement_id_            VARCHAR2(10);
   ptr_                     NUMBER := NULL;
   name_                    VARCHAR2(30);
   decision_pending_        BOOLEAN;
   next_valid_to_date_      DATE;
   effective_from_date_     DATE;
   current_valid_from_      DATE;
   
   CURSOR get_past_timeframed_part_rec IS
      SELECT catalog_no, min_quantity, valid_from_date
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    valid_to_date < valid_from_date_
      AND    valid_to_date IS NOT NULL;
   
   CURSOR find_invalid_part_records IS
      SELECT catalog_no, min_quantity, MAX(valid_from_date) valid_from_date
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    valid_from_date < valid_from_date_
      AND    valid_to_date IS NULL
      GROUP BY catalog_no, min_quantity;
      
   CURSOR get_past_part_records(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, max_valid_from_ IN DATE) IS
      SELECT valid_from_date
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date < max_valid_from_
      AND    valid_to_date IS NULL;
   
   CURSOR get_part_rec_valid_dates(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, effetive_valid_from_ IN DATE, current_valid_from_ IN DATE) IS
      SELECT valid_from_date, valid_to_date
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date <= effetive_valid_from_
      AND    valid_from_date > current_valid_from_;

CURSOR get_past_timeframed_assort_rec IS
      SELECT assortment_id, assortment_node_id, price_unit_meas, min_quantity, valid_from
      FROM   agreement_assortment_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    valid_to < valid_from_date_
      AND    valid_to IS NOT NULL;
   
   CURSOR find_invalid_assort_records IS
      SELECT assortment_id, assortment_node_id, price_unit_meas, min_quantity, MAX(valid_from) valid_from
      FROM   agreement_assortment_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    valid_from < valid_from_date_
      AND    valid_to IS NULL
      GROUP BY assortment_id, assortment_node_id, price_unit_meas, min_quantity;
      
   CURSOR get_past_assort_records(assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, price_unit_meas_ IN VARCHAR2, min_quantity_ IN NUMBER, max_valid_from_ IN DATE) IS
      SELECT valid_from
      FROM   agreement_assortment_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas = price_unit_meas_
      AND    min_quantity = min_quantity_
      AND    valid_from < max_valid_from_
      AND    valid_to IS NULL;
   
   CURSOR get_assort_rec_valid_dates(assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, price_unit_meas_ IN VARCHAR2, min_quantity_ IN NUMBER, effetive_valid_from_ IN DATE, current_valid_from_ IN DATE) IS
      SELECT valid_from, valid_to
      FROM   agreement_assortment_deal_tab
      WHERE  agreement_id = agreement_id_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas = price_unit_meas_
      AND    min_quantity = min_quantity_
      AND    valid_from <= effetive_valid_from_
      AND    valid_from > current_valid_from_;

BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(agreement_attr_, ptr_, name_, agreement_id_)) LOOP
      -- Deal per part tab
      -- Removed all part prices that are defined both from date and to date which are before the user specified valid_from_date.
      FOR rem_rec_ IN get_past_timeframed_part_rec LOOP
         Agreement_Sales_Part_Deal_API.Remove(agreement_id_, rem_rec_.catalog_no, rem_rec_.min_quantity, rem_rec_.valid_from_date);
         counter_ := counter_ + 1;
      END LOOP;
      
      FOR rec_ IN find_invalid_part_records LOOP
         -- all record prior to the max(valid_from_date) < user defined valid_from_date must be removed
         FOR rem_rec_ IN get_past_part_records(rec_.catalog_no, rec_.min_quantity, rec_.valid_from_date) LOOP
            Agreement_Sales_Part_Deal_API.Remove(agreement_id_, rec_.catalog_no, rec_.min_quantity, rem_rec_.valid_from_date);
            counter_ := counter_ + 1;
         END LOOP;
         -- need to consider whether the current record can be removed
         effective_from_date_ := valid_from_date_;
         current_valid_from_ := rec_.valid_from_date;
         decision_pending_ := TRUE;
         LOOP
            next_valid_to_date_ := NULL;
            EXIT WHEN NOT(decision_pending_);
            OPEN get_part_rec_valid_dates(rec_.catalog_no, rec_.min_quantity, effective_from_date_, current_valid_from_);
            FETCH get_part_rec_valid_dates INTO current_valid_from_, next_valid_to_date_;
            IF (get_part_rec_valid_dates%FOUND) THEN
               CLOSE get_part_rec_valid_dates;
               IF (next_valid_to_date_ IS NULL) THEN 
                  -- another valid record exists from the defined date. Hence we can remove the MAX(valid_from_date) < user defined from date(valid_from_date_)
                  Agreement_Sales_Part_Deal_API.Remove(agreement_id_, rec_.catalog_no, rec_.min_quantity, rec_.valid_from_date);
                  counter_ := counter_ + 1;
                  decision_pending_ := FALSE;
               ELSE
                  effective_from_date_ := next_valid_to_date_ + 1;
               END IF;
            ELSE
               CLOSE get_part_rec_valid_dates;
               decision_pending_ := FALSE;
            END IF;
         END LOOP;
      END LOOP;
       
      -- Deal per Assortment tab
      -- Removed all assortment based prices that are defined both from date and to date which are before the user specified valid_from_date.
      FOR rem_rec_ IN get_past_timeframed_assort_rec LOOP
         Agreement_Assortment_Deal_API.Remove(rem_rec_.assortment_id, rem_rec_.assortment_node_id, agreement_id_, rem_rec_.min_quantity, rem_rec_.valid_from, rem_rec_.price_unit_meas);
         counter_ := counter_ + 1;
      END LOOP;
      
      FOR rec_ IN find_invalid_assort_records LOOP
         -- all record prior to the max(valid_from_date) < user defined valid_from_date must be removed
         FOR rem_rec_ IN get_past_assort_records(rec_.assortment_id, rec_.assortment_node_id, rec_.price_unit_meas, rec_.min_quantity, rec_.valid_from) LOOP
            Agreement_Assortment_Deal_API.Remove(rec_.assortment_id, rec_.assortment_node_id, agreement_id_, rec_.min_quantity, rem_rec_.valid_from, rec_.price_unit_meas);
            counter_ := counter_ + 1;
         END LOOP;
         -- need to consider whether the current record can be removed
         effective_from_date_ := valid_from_date_;
         current_valid_from_ := rec_.valid_from;
         decision_pending_ := TRUE;
         LOOP
            next_valid_to_date_ := NULL;
            EXIT WHEN NOT(decision_pending_);
            OPEN get_assort_rec_valid_dates(rec_.assortment_id, rec_.assortment_node_id, rec_.price_unit_meas, rec_.min_quantity, effective_from_date_, current_valid_from_);
            FETCH get_assort_rec_valid_dates INTO current_valid_from_, next_valid_to_date_;
            IF (get_assort_rec_valid_dates%FOUND) THEN
               CLOSE get_assort_rec_valid_dates;
               IF (next_valid_to_date_ IS NULL) THEN 
                  -- another valid record exists from the defined date. Hence we can remove the MAX(valid_from_date) < user defined from date(valid_from_date_)
                  Agreement_Assortment_Deal_API.Remove(rec_.assortment_id, rec_.assortment_node_id, agreement_id_, rec_.min_quantity, rec_.valid_from, rec_.price_unit_meas);
                  counter_ := counter_ + 1;
                  decision_pending_ := FALSE;
               ELSE
                  effective_from_date_ := next_valid_to_date_ + 1;
               END IF;
            ELSE
               CLOSE get_assort_rec_valid_dates;
               decision_pending_ := FALSE;
            END IF;
         END LOOP;
      END LOOP;
   END LOOP;

   removed_items_ := counter_;
END Remove_Invalid_Prices__;


-- Add_Part_To_Agreement__
--   Add new sales parts to agreement.
PROCEDURE Add_Part_To_Agreement__ (
   number_of_new_lines_ OUT NUMBER,
   agreement_id_        IN  VARCHAR2,
   catalog_no_          IN  VARCHAR2,
   valid_from_date_     IN  DATE,
   base_price_site_     IN  VARCHAR2,
   discount_type_       IN  VARCHAR2,
   discount_            IN  NUMBER,
   percentage_offset_   IN  NUMBER,
   amount_offset_       IN  NUMBER,
   valid_to_date_       IN  DATE )
IS
   counter_                    NUMBER := 0;
   applicable_base_price_      NUMBER;
   applicable_base_price_curr_ NUMBER;
   min_quantity_               NUMBER := 0;
   rounding_                   NUMBER;
   rate_                       NUMBER;
   posi0_                      NUMBER;
   posi1_                      NUMBER;
   catalog_no1_                VARCHAR2(25);
   done_                       BOOLEAN;
   site_posi0_                 NUMBER;
   site_posi1_                 NUMBER;
   site_done_                  BOOLEAN;
   temp_base_price_site_       VARCHAR2(6);
   info_                       VARCHAR2(2000);
   attr_                       VARCHAR2(32000);
   agreement_rec_              Customer_Agreement_API.Public_Rec;
   added_lines_                NUMBER;
   used_price_break_templates_ VARCHAR2(10);
   
   CURSOR find_records_for_insert IS
      SELECT base_price_site, catalog_no, sales_price_type
      FROM   SALES_PART_BASE_PRICE_TAB
      WHERE  rowstate = 'Active'
      AND    base_price_site LIKE temp_base_price_site_
      AND    catalog_no LIKE catalog_no1_
      AND    catalog_no NOT IN (SELECT catalog_no
                                FROM   AGREEMENT_SALES_PART_DEAL_TAB
                                WHERE  agreement_id = agreement_id_)
      AND    base_price_site IN (SELECT contract
                                 FROM   site_public
                                 WHERE  EXISTS (SELECT 1 FROM user_allowed_site_pub
                                                WHERE base_price_site = site))
      AND    sales_price_type = Sales_Price_Type_API.DB_SALES_PRICES;

BEGIN

   agreement_rec_ := Customer_Agreement_API.Get(agreement_id_);

   site_posi0_ := 1;
   site_done_ := FALSE;

   WHILE (site_done_ = FALSE) LOOP
      site_posi1_ :=INSTR(base_price_site_, ';', site_posi0_);
      IF (site_posi1_ = 0) THEN
         temp_base_price_site_ := SUBSTR(base_price_site_, site_posi0_);
      ELSE
         temp_base_price_site_ := SUBSTR(base_price_site_, site_posi0_, site_posi1_ - site_posi0_);
      END IF;

      posi0_ := 1;
      done_ := FALSE;
      WHILE (done_ = FALSE) LOOP
         posi1_ :=INSTR(catalog_no_, ';', posi0_);
         IF (posi1_ = 0) THEN
            catalog_no1_ := SUBSTR(catalog_no_, posi0_);
         ELSE
            catalog_no1_ := SUBSTR(catalog_no_, posi0_, posi1_ - posi0_);
         END IF;
         FOR rec_ IN find_records_for_insert LOOP
           IF NOT (Agreement_Sales_Part_Deal_API.Check_Exist(agreement_id_, min_quantity_, valid_from_date_, rec_.catalog_no)) THEN
              -- Retreive/calculate the base price
               used_price_break_templates_ := NULL;
               IF (agreement_rec_.use_price_incl_tax = 'TRUE') THEN
                  Sales_Part_Base_Price_API.Calculate_Base_Price_Incl_Tax(used_price_break_templates_, applicable_base_price_, rec_.base_price_site, rec_.catalog_no,
                                                                 rec_.sales_price_type, min_quantity_,agreement_rec_.use_price_break_templates);
               ELSE
                  Sales_Part_Base_Price_API.Calculate_Base_Price(used_price_break_templates_, 
                                                                 applicable_base_price_, 
                                                                 rec_.base_price_site, 
                                                                 rec_.catalog_no, 
                                                                 rec_.sales_price_type, 
                                                                 min_quantity_,
                                                             agreement_rec_.use_price_break_templates); 
               END IF;
               
               -- Get base price in agreement currency
               Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(applicable_base_price_curr_, rate_, Get_Customer_No(agreement_id_), rec_.base_price_site, agreement_rec_.currency_code, applicable_base_price_);

               IF used_price_break_templates_ IS NOT NULL THEN
                  Agreement_Sales_Part_Deal_API.Insert_Price_Break_Lines(added_lines_,
                                                                         agreement_id_,
                                                                         valid_from_date_,
                                                                         rec_.catalog_no,
                                                                         rec_.base_price_site,
                                                                         percentage_offset_,
                                                                         amount_offset_,
                                                                         rounding_,
                                                                         discount_type_,
                                                                         discount_,
                                                                         min_quantity_,
                                                                         NULL,
                                                                         valid_to_date_,
                                                                         from_header_ => TRUE);
                  counter_ := counter_ + added_lines_;
               ELSE
                  Client_SYS.Set_Item_Value('AGREEMENT_ID', agreement_id_, attr_);
                  Client_SYS.Set_Item_Value('MIN_QUANTITY', min_quantity_, attr_);
                  Client_SYS.Set_Item_Value('VALID_FROM_DATE', valid_from_date_, attr_);
                  Client_SYS.Set_Item_Value('CATALOG_NO', rec_.catalog_no, attr_);
                  Client_SYS.Set_Item_Value('BASE_PRICE_SITE', rec_.base_price_site, attr_);
                  Client_SYS.Set_Item_Value('DISCOUNT_TYPE', discount_type_, attr_);
                  Client_SYS.Set_Item_Value('DISCOUNT', discount_, attr_);
                  IF (agreement_rec_.use_price_incl_tax = 'TRUE') THEN
                     Client_SYS.Set_Item_Value('BASE_PRICE_INCL_TAX', applicable_base_price_curr_, attr_);
                  ELSE
                     Client_SYS.Set_Item_Value('BASE_PRICE',          applicable_base_price_curr_, attr_);
                  END IF;
                  Client_SYS.Set_Item_Value('PERCENTAGE_OFFSET', percentage_offset_, attr_);
                  Client_SYS.Set_Item_Value('AMOUNT_OFFSET', amount_offset_, attr_);
                  Client_SYS.Set_Item_Value('ROUNDING', rounding_, attr_);
                  IF (valid_to_date_ IS NOT NULL) THEN
                     Client_SYS.Set_Item_Value('VALID_TO_DATE', valid_to_date_, attr_);
                  END IF;
                  
                 Agreement_Sales_Part_Deal_API.New(info_, attr_);
                 counter_ := counter_ + 1;
              END IF;
           END IF;
         END LOOP;
         IF (posi1_ = 0) THEN
             done_ := TRUE;
         ELSE
             posi0_ := posi1_ + 1;
         END IF;
      END LOOP;

      IF (site_posi1_ = 0) THEN
         site_done_ := TRUE;
      ELSE
         site_posi0_ := site_posi1_ + 1;
      END IF;
   END LOOP;

   number_of_new_lines_ := counter_;
END Add_Part_To_Agreement__;


-- Add_Part_To_Agreement_Batch__
--   Add new sales parts to agreement as a background job.
PROCEDURE Add_Part_To_Agreement_Batch__ (
   agreement_id_      IN VARCHAR2,
   catalog_no_        IN VARCHAR2,
   valid_from_date_   IN DATE,
   base_price_site_   IN VARCHAR2,
   discount_type_     IN VARCHAR2,
   discount_          IN NUMBER,
   percentage_offset_ IN NUMBER,
   amount_offset_     IN NUMBER,
   valid_to_date_     IN DATE )
IS
   attr_ VARCHAR2(32000);
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_ID', agreement_id_, attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', valid_from_date_, attr_);
   Client_SYS.Add_To_Attr('BASE_PRICE_SITE', base_price_site_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_TYPE', discount_type_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
   Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', percentage_offset_, attr_);
   Client_SYS.Add_To_Attr('AMOUNT_OFFSET', amount_offset_, attr_);
   Client_SYS.Add_To_Attr('VALID_TO_DATE', valid_to_date_, attr_);
   
    Transaction_SYS.Deferred_Call('Customer_Agreement_API.Start_Add_Part_To_Agreement__', attr_,
    Language_SYS.Translate_Constant(lu_name_, 'ADD_TO_AGREEMENT: Add Sales Parts to Customer Agreement'));
END Add_Part_To_Agreement_Batch__;


-- Start_Add_Part_To_Agreement__
--   Add new sales parts to agreement.
PROCEDURE Start_Add_Part_To_Agreement__ (
   attr_ IN VARCHAR2 )
IS
   number_of_new_lines_  NUMBER;
   agreement_id_         VARCHAR2(10);
   catalog_no_           VARCHAR2(4000);
   valid_from_date_      DATE;
   base_price_site_      VARCHAR2(2000);
   discount_type_        VARCHAR2(25);
   discount_             NUMBER;
   percentage_offset_    NUMBER;
   amount_offset_        NUMBER;
   info_                 VARCHAR2(2000);
   valid_to_date_        DATE;
BEGIN

   agreement_id_           := Client_SYS.Get_Item_Value('AGREEMENT_ID', attr_);
   catalog_no_             := Client_SYS.Get_Item_Value('CATALOG_NO', attr_);
   valid_from_date_        := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_FROM_DATE', attr_));
   base_price_site_        := Client_SYS.Get_Item_Value('BASE_PRICE_SITE', attr_);
   discount_type_          := Client_SYS.Get_Item_Value('DISCOUNT_TYPE', attr_);
   discount_               := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('DISCOUNT', attr_));
   percentage_offset_      := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('PERCENTAGE_OFFSET', attr_));
   amount_offset_          := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('AMOUNT_OFFSET', attr_));
   valid_to_date_          := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_TO_DATE', attr_));
   
   Add_Part_To_Agreement__(number_of_new_lines_, agreement_id_, catalog_no_, valid_from_date_, base_price_site_, discount_type_, discount_, percentage_offset_, amount_offset_, valid_to_date_);

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (number_of_new_lines_ > 0) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NEW_LINES: :P1 Sales Part(s) added to the Customer Agreement.', NULL, TO_CHAR(number_of_new_lines_));
      ELSE
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NO_LINES: No records added.');
      END IF;
      Transaction_SYS.Set_Progress_Info(info_);
   END IF;

END Start_Add_Part_To_Agreement__;


-- Update_Deal_Part_Prices__
--   Update deal per part lines in customer agreements from base prices.
PROCEDURE Update_Deal_Part_Prices__ (
   info_ OUT VARCHAR2,
   attr_ IN  VARCHAR2 )
IS
   update_foreground_      VARCHAR2(20);
BEGIN

   update_foreground_ := Client_SYS.Get_Item_Value('EXECUTE_ONLINE', attr_);

   IF update_foreground_ = 'TRUE' THEN
      Start_Update_Part_Prices__(attr_);
      info_ := Client_SYS.Get_All_Info;
   ELSE
      Transaction_SYS.Deferred_Call('Customer_Agreement_API.Start_Update_Part_Prices__', attr_,
         Language_SYS.Translate_Constant(lu_name_, 'UPDATE_AGREEMENT: Update Customer Agreements'));
   END IF;

END Update_Deal_Part_Prices__;


-- Start_Update_Part_Prices__
--   Update deal per part lines in customer agreements from base prices.
PROCEDURE Start_Update_Part_Prices__ (
   attr_ IN VARCHAR2 )
IS
   number_of_updates_      NUMBER;
   valid_from_date_        DATE;
   sales_price_origin_db_  VARCHAR2(10);
   agreement_attr_         VARCHAR2(4000);
   catalog_no_attr_        VARCHAR2(4000);
   base_price_site_attr_   VARCHAR2(4000);
   info_                   VARCHAR2(2000);
   include_period_         VARCHAR2(10);
BEGIN

   valid_from_date_        := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_FROM', attr_));
   sales_price_origin_db_  := Client_SYS.Get_Item_Value('PRICE_ORIGIN', attr_);
   agreement_attr_         := Client_SYS.Get_Item_Value('AGREEMENT_ATTR', attr_);
   catalog_no_attr_        := Client_SYS.Get_Item_Value('CATALOG_NO_ATTR', attr_);
   base_price_site_attr_   := Client_SYS.Get_Item_Value('BASE_PRICE_SITE_ATTR', attr_);
   include_period_         := Client_SYS.Get_Item_Value('INCLUDE_PERIOD', attr_);
   
   Update_Part_Prices___(number_of_updates_, valid_from_date_, sales_price_origin_db_,
                         agreement_attr_, catalog_no_attr_, base_price_site_attr_, include_period_);

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (number_of_updates_ > 0) THEN
         info_ := Base_Price_Updated_Constant___(number_of_updates_);
      ELSE
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NO_UPDATES: No records were updated.');
      END IF;
      Transaction_SYS.Set_Progress_Info(info_);
   ELSE
      Client_SYS.Add_Info(lu_name_, Base_Price_Updated_Constant___(number_of_updates_));
   END IF;
END Start_Update_Part_Prices__;


-- Update_Assortment_Prices__
--   Update deal prices at deal per assortment lines at customer agreement
--   as foreground or background job.
PROCEDURE Update_Assortment_Prices__ (
   info_ OUT VARCHAR2,
   attr_ IN  VARCHAR2 )
IS
   update_foreground_      VARCHAR2(20);
BEGIN

   update_foreground_ := Client_SYS.Get_Item_Value('EXECUTE_ONLINE', attr_);

   IF update_foreground_ = 'TRUE' THEN
      Start_Update_Assortmt_Prices__(attr_);
      info_ := Client_SYS.Get_All_Info;
   ELSE
      Transaction_SYS.Deferred_Call('Customer_Agreement_API.Start_Update_Assortmt_Prices__', attr_,
         Language_SYS.Translate_Constant(lu_name_, 'UPDATE_ASSORTMENT: Update Assortment Prices on Customer Agreements'));
   END IF;

END Update_Assortment_Prices__;


-- Start_Update_Assortmt_Prices__
--   Update deal prices at deal per assortment lines at customer agreement
--   and set info about the update.
PROCEDURE Start_Update_Assortmt_Prices__ (
   attr_ IN VARCHAR2 )
IS
   valid_from_date_        DATE;
   number_of_updates_      NUMBER;
   percentage_offset_      NUMBER;
   amount_offset_          NUMBER;
   agreement_attr_         VARCHAR2(4000);
   assortment_attr_        VARCHAR2(4000);
   assortment_node_attr_   VARCHAR2(4000);
   info_                   VARCHAR2(2000);
   include_period_         VARCHAR2(5);
BEGIN

   valid_from_date_        := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_FROM', attr_));
   percentage_offset_      := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('PERCENTAGE_OFFSET', attr_));
   amount_offset_          := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('AMOUNT_OFFSET', attr_));
   agreement_attr_         := Client_SYS.Get_Item_Value('AGREEMENT_ATTR', attr_);
   assortment_attr_        := Client_SYS.Get_Item_Value('ASSORTMENT_ATTR', attr_);
   assortment_node_attr_   := Client_SYS.Get_Item_Value('ASSORTMENT_NODE_ATTR', attr_);
   include_period_         := Client_SYS.Get_Item_Value('INCLUDE_PERIOD', attr_);

   Update_Assortment_Prices___(number_of_updates_, valid_from_date_, percentage_offset_, amount_offset_,
                               agreement_attr_, assortment_attr_, assortment_node_attr_, include_period_);

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (number_of_updates_ > 0) THEN
         info_ := Deal_Price_Updated_Constant___(number_of_updates_);
      ELSE
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NO_UPDATES: No records were updated.');
      END IF;
      Transaction_SYS.Set_Progress_Info(info_);
   ELSE
      Client_SYS.Add_Info(lu_name_, Deal_Price_Updated_Constant___(number_of_updates_));
   END IF;
END Start_Update_Assortmt_Prices__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   agreement_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_agreement_tab.description%TYPE;
BEGIN
   IF (agreement_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER', 'CustomerAgreement',
      agreement_id_), 1, 50);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
   INTO   temp_
   FROM   customer_agreement_tab
   WHERE  agreement_id = agreement_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(agreement_id_, 'Get_Description');
END Get_Description;

-- Get_First_Valid_Agreement
--   Return the first found agreement valid at the specified date for the
--   specified customer_no, contract and currency code.
@UncheckedAccess
FUNCTION Get_First_Valid_Agreement (
   customer_no_   IN VARCHAR2,
   contract_      IN VARCHAR2,
   currency_code_ IN VARCHAR2,
   date_          IN DATE,
   use_by_object_header_   IN VARCHAR2) RETURN VARCHAR2
IS
   last_calendar_date_   DATE := Database_Sys.last_calendar_date_;
   agreement_id_  CUSTOMER_AGREEMENT_TAB.agreement_id%TYPE;
   CURSOR get_agreement_id IS
      SELECT MIN(ca.agreement_id)
      FROM  CUSTOMER_AGREEMENT_TAB ca, customer_agreement_site_tab cas
      WHERE customer_no = customer_no_
      AND   ca.agreement_id = cas.agreement_id
      AND   cas.contract = contract_
      AND   currency_code = currency_code_
      AND   use_explicit != 'Y'
      AND   rowstate = 'Active'
      AND   (trunc(date_) BETWEEN valid_from AND nvl(valid_until, last_calendar_date_))
      AND   (((use_by_object_header_ = 'TRUE') AND (ca.use_by_object_head = Fnd_Boolean_API.DB_TRUE)) OR (use_by_object_header_ = 'FALSE'));
BEGIN
   OPEN get_agreement_id;
   FETCH get_agreement_id INTO agreement_id_;
   IF (get_agreement_id%NOTFOUND) THEN
      CLOSE get_agreement_id;
      RETURN NULL;
   END IF;
   CLOSE get_agreement_id;
   RETURN agreement_id_ ;
END Get_First_Valid_Agreement;



@UncheckedAccess
FUNCTION Get_Use_Price_Break_Templ_Db (
   agreement_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_AGREEMENT_TAB.use_price_break_templates%TYPE;
   CURSOR get_attr IS
      SELECT use_price_break_templates
      FROM CUSTOMER_AGREEMENT_TAB
      WHERE agreement_id = agreement_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Use_Price_Break_Templ_Db;


-- Is_Active
--   Return TRUE (1) if the specified customer agreement is active.
--   Return FALSE if the agreement is not in state 'Active' or
--   if the agreement does not exist.
@UncheckedAccess
FUNCTION Is_Active (
   agreement_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   rowstate_ CUSTOMER_AGREEMENT_TAB.rowstate%TYPE;
   CURSOR get_rowstate IS
      SELECT rowstate
      FROM   CUSTOMER_AGREEMENT_TAB
      WHERE  agreement_id = agreement_id_;
BEGIN
   OPEN get_rowstate;
   FETCH get_rowstate INTO rowstate_;
   IF (get_rowstate%NOTFOUND) THEN
      CLOSE get_rowstate;
      RETURN 0;
   END IF;
   CLOSE get_rowstate;
   IF (rowstate_ = 'Active') THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Active;


-- Is_Valid
--   Check if the customer agreement is valid or not for the specified site,
--   Returns TRUE (1) if agreement_id is valid for specified contract,
--   customer and currency.
@UncheckedAccess
FUNCTION Is_Valid (
   agreement_id_     IN VARCHAR2,
   contract_         IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   currency_code_    IN VARCHAR2,
   effectivity_date_ IN DATE DEFAULT NULL ) RETURN NUMBER
IS
   site_date_ DATE;

   CURSOR get_attr IS
      SELECT valid_from, valid_until, currency_code, customer_no, rowstate
      FROM  CUSTOMER_AGREEMENT_TAB
      WHERE agreement_id = agreement_id_;
   rec_       get_attr%ROWTYPE;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO rec_;
   CLOSE get_attr;

   IF (effectivity_date_ IS NULL)  THEN
      site_date_ := trunc(Site_API.Get_Site_Date(contract_));
   ELSE
      site_date_ := trunc(effectivity_date_);
   END IF;

   IF (rec_.valid_from > site_date_) OR (NVL(rec_.valid_until, site_date_) < site_date_) THEN
      -- Agreement not valid.
      RETURN 0;
   ELSIF (rec_.currency_code != currency_code_) THEN
      -- Agreement currency do not match order currency.
      RETURN 0;
   ELSIF NOT(Customer_Agreement_Site_API.Check_Exist(contract_, agreement_id_)) THEN
      -- Agreement is not valid for specified site.
      RETURN 0;
   ELSIF (rec_.customer_no != customer_no_ AND Customer_Agreement_API.Validate_Hierarchy_Customer(agreement_id_, customer_no_) = 0) THEN
      -- Agreement is not valid for specified site.
      RETURN 0;
   ELSIF (rec_.rowstate != 'Active') THEN
      -- Agreement state not 'Active'.
      RETURN 0;
   ELSE
      RETURN 1;
   END IF;
END Is_Valid;


-- Has_Part_Deal
--   Return TRUE (1) if the agreement has part deal records.
@UncheckedAccess
FUNCTION Has_Part_Deal (
   agreement_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR exist_part_deal IS
      SELECT 1
      FROM agreement_sales_part_deal_tab
      WHERE agreement_id = agreement_id_;
BEGIN
   OPEN exist_part_deal;
   FETCH exist_part_deal INTO found_;
   IF exist_part_deal%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE exist_part_deal;
   RETURN found_;
END Has_Part_Deal;


-- Set_Agreement_Sent
--   Updates the "agreement has been sent" flag.
PROCEDURE Set_Agreement_Sent (
   agreement_id_      IN VARCHAR2,
   agreement_sent_db_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000) := NULL;
   newrec_     CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   oldrec_     CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   objid_      CUSTOMER_AGREEMENT.objid%TYPE;
   objversion_ CUSTOMER_AGREEMENT.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Client_SYS.Add_To_Attr('AGREEMENT_SENT_DB', agreement_sent_db_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Agreement_Sent;


-- Get_Agreement_For_Part
--   Returns agreement_id for the first valid agreement for a specified
--   sales part.
PROCEDURE Get_Agreement_For_Part (
   agreement_id_     OUT VARCHAR2,
   customer_no_      IN  VARCHAR2,
   contract_         IN  VARCHAR2,
   currency_         IN  VARCHAR2,
   catalog_no_       IN  VARCHAR2,
   effectivity_date_ IN  DATE )
IS
   last_calendar_date_  DATE := Database_Sys.last_calendar_date_;
   CURSOR get_part_agreement (customer_no_ IN VARCHAR2, contract_ IN VARCHAR2, currency_ IN VARCHAR2,
                              catalog_no_ IN VARCHAR2, effectivity_date_ IN DATE) IS
     SELECT MIN(ca.agreement_id)
     FROM   agreement_sales_part_deal_tab asp, customer_agreement_tab ca, customer_agreement_site_tab cas
     WHERE  ca.customer_no = customer_no_
     AND    cas.contract = contract_
     AND    ca.currency_code = currency_
     AND    ca.rowstate = 'Active'
     AND    ca.use_explicit != 'Y'
     AND    (trunc(effectivity_date_) BETWEEN ca.valid_from AND nvl(ca.valid_until, last_calendar_date_))
     AND    asp.agreement_id = ca.agreement_id
     AND    ca.agreement_id = cas.agreement_id
     AND    asp.catalog_no = catalog_no_;
BEGIN
   OPEN get_part_agreement(customer_no_, contract_, currency_, catalog_no_, effectivity_date_);
   FETCH get_part_agreement INTO agreement_id_;
   CLOSE get_part_agreement;

END Get_Agreement_For_Part;


-- Get_Agreement_For_Group
--   Returns agreement_id for the first valid agreement for a specified
--   sales group.
PROCEDURE Get_Agreement_For_Group (
   agreement_id_     OUT VARCHAR2,
   customer_no_      IN  VARCHAR2,
   contract_         IN  VARCHAR2,
   currency_         IN  VARCHAR2,
   catalog_group_    IN  VARCHAR2,
   effectivity_date_ IN  DATE,
   quantity_         IN  NUMBER )
IS
   last_calendar_date_  DATE := Database_Sys.last_calendar_date_;
   CURSOR get_group_agreement(customer_no_ IN VARCHAR2, contract_ IN VARCHAR2, currency_ IN VARCHAR2,
                              catalog_group_ IN VARCHAR2, effectivity_date_ IN DATE) IS
      SELECT MIN(ca.agreement_id)
      FROM agreement_sales_group_deal_tab asg, customer_agreement_tab ca, customer_agreement_site_tab cas
      WHERE ca.customer_no = customer_no_
      AND   cas.contract = contract_
      AND   ca.currency_code = currency_
      AND   ca.rowstate = 'Active'
      AND   ca.use_explicit != 'Y'
      AND   (trunc(effectivity_date_) BETWEEN ca.valid_from AND nvl(ca.valid_until, last_calendar_date_))
      AND   (trunc(effectivity_date_) BETWEEN asg.valid_from_date AND nvl(asg.valid_to_date, last_calendar_date_))
      AND   asg.min_quantity <= quantity_
      AND   asg.agreement_id = ca.agreement_id
      AND   ca.agreement_id = cas.agreement_id
      AND   asg.catalog_group = catalog_group_;
BEGIN
   OPEN get_group_agreement(customer_no_, contract_, currency_, catalog_group_, effectivity_date_);
   FETCH get_group_agreement INTO agreement_id_;
   CLOSE get_group_agreement;

END Get_Agreement_For_Group;


-- Get_Price_Agreement_For_Part
--   Returns agreement_id for the first valid agreement with a price
--   for a specified sales part.
@UncheckedAccess
FUNCTION Get_Price_Agreement_For_Part (
   customer_no_      IN VARCHAR2,
   contract_         IN VARCHAR2,
   currency_         IN VARCHAR2,
   catalog_no_       IN VARCHAR2,
   effectivity_date_ IN DATE,
   quantity_         IN NUMBER ) RETURN VARCHAR2
IS
   last_calendar_date_  DATE := Database_Sys.last_calendar_date_;
   agreement_id_  CUSTOMER_AGREEMENT_TAB.agreement_id%TYPE;

   CURSOR get_part_price_agreement (customer_no_      IN VARCHAR2,
                                    contract_         IN VARCHAR2,
                                    currency_         IN VARCHAR2,
                                    catalog_no_       IN VARCHAR2,
                                    effectivity_date_ IN DATE) IS
      SELECT MIN(ca.agreement_id)
        FROM agreement_sales_part_deal_tab asp, customer_agreement_tab ca, customer_agreement_site_tab cas
       WHERE ca.customer_no   = customer_no_
         AND cas.contract      = contract_
         AND ca.currency_code = currency_
         AND ca.rowstate      = 'Active'
         AND ca.use_explicit != 'Y'
         AND (trunc(effectivity_date_) BETWEEN ca.valid_from AND nvl(ca.valid_until, last_calendar_date_))
         AND (trunc(effectivity_date_) BETWEEN asp.valid_from_date AND nvl(asp.valid_to_date, last_calendar_date_))
         AND asp.min_quantity <= quantity_
         AND asp.agreement_id = ca.agreement_id
         AND cas.agreement_id = ca.agreement_id
         AND asp.catalog_no   = catalog_no_
         AND asp.deal_price IS NOT NULL;
BEGIN
   OPEN  get_part_price_agreement(customer_no_, contract_, currency_, catalog_no_, effectivity_date_);
   FETCH get_part_price_agreement INTO agreement_id_;
   CLOSE get_part_price_agreement;
   RETURN agreement_id_;
END Get_Price_Agreement_For_Part;


-- Get_Disc_Agreement_For_Part
--   Returns agreement_id for the first valid agreement with a discount only
--   (no price) for a specified sales part.
@UncheckedAccess
FUNCTION Get_Disc_Agreement_For_Part (
   customer_no_      IN VARCHAR2,
   contract_         IN VARCHAR2,
   currency_         IN VARCHAR2,
   catalog_no_       IN VARCHAR2,
   effectivity_date_ IN DATE,
   quantity_         IN NUMBER ) RETURN VARCHAR2
IS
   last_calendar_date_  DATE := Database_Sys.last_calendar_date_;
   agreement_id_  CUSTOMER_AGREEMENT_TAB.agreement_id%TYPE;

   CURSOR get_part_disc_agreement (customer_no_      IN VARCHAR2,
                                   contract_         IN VARCHAR2,
                                   currency_         IN VARCHAR2,
                                   catalog_no_       IN VARCHAR2,
                                   effectivity_date_ IN DATE) IS
      SELECT MIN(ca.agreement_id)
        FROM agreement_sales_part_deal_tab asp, customer_agreement_tab ca, customer_agreement_site_tab cas
       WHERE ca.customer_no   = customer_no_
         AND cas.contract      = contract_
         AND ca.currency_code = currency_
         AND ca.rowstate      = 'Active'
         AND ca.use_explicit != 'Y'
         AND (trunc(effectivity_date_) BETWEEN ca.valid_from AND nvl(ca.valid_until, last_calendar_date_))
         AND (trunc(effectivity_date_) BETWEEN asp.valid_from_date AND NVL(asp.valid_to_date, last_calendar_date_))
         AND asp.min_quantity <= quantity_
         AND asp.agreement_id = ca.agreement_id
         AND ca.agreement_id  = cas.agreement_id
         AND asp.catalog_no   = catalog_no_
         AND asp.deal_price IS NULL;
BEGIN
   OPEN  get_part_disc_agreement(customer_no_, contract_, currency_, catalog_no_, effectivity_date_);
   FETCH get_part_disc_agreement INTO agreement_id_;
   CLOSE get_part_disc_agreement;
   RETURN agreement_id_;
END Get_Disc_Agreement_For_Part;


@UncheckedAccess
FUNCTION Get_Agreement_Curr_Rounding (
   agreement_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_currency_info IS
      SELECT company , currency_code
        FROM CUSTOMER_AGREEMENT_TAB 
       WHERE agreement_id = agreement_id_;
       
   company_           VARCHAR2(80);
   currency_code_     VARCHAR2(12);    
   currency_rounding_ NUMBER := 0;
BEGIN
   OPEN get_currency_info;
   FETCH get_currency_info INTO company_, currency_code_;
   CLOSE get_currency_info;
   
   currency_rounding_ := Currency_Code_Api.Get_Currency_Rounding( company_, currency_code_); 
   
   RETURN currency_rounding_;
END Get_Agreement_Curr_Rounding;


-- New
--   Creates new agreement.
PROCEDURE New (
   info_          OUT VARCHAR2,
   agreement_id_  OUT VARCHAR2,
   customer_no_   IN  VARCHAR2,
   contract_      IN  VARCHAR2,
   currency_code_ IN  VARCHAR2 )
IS
   objid_      CUSTOMER_AGREEMENT.objid%TYPE;
   objversion_ CUSTOMER_AGREEMENT.objversion%TYPE;
   newrec_     CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   company_    VARCHAR2(20);
   use_price_incl_tax_ VARCHAR2(20);
   indrec_     Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);

   company_ := Site_API.Get_Company(contract_);
   use_price_incl_tax_ := Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(customer_no_, company_);
   
   Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_no_, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE', currency_code_, attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', use_price_incl_tax_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___( objid_, objversion_, newrec_, attr_ );

   info_ := Client_SYS.Get_All_Info;
   agreement_id_ := Client_SYS.Get_Item_Value('AGREEMENT_ID', attr_);

END New;


-- New_Agreement_And_Part_Deal
--   Creates new agreement and a sales part deal record.
PROCEDURE New_Agreement_And_Part_Deal (
   info_          OUT VARCHAR2,
   agreement_id_  OUT VARCHAR2,
   customer_no_   IN  VARCHAR2,
   contract_      IN  VARCHAR2,
   currency_code_ IN  VARCHAR2,
   catalog_no_    IN  VARCHAR2,
   deal_price_          IN  NUMBER,
   deal_price_incl_tax_ IN  NUMBER )
IS
   temp_info_    VARCHAR2(2000);
   attr_         VARCHAR2(32000);
   sales_price_type_db_ VARCHAR2(20);

BEGIN
   -- Create customer agreement header
   New(info_, agreement_id_, customer_no_, contract_, currency_code_);
   sales_price_type_db_ := Sales_Price_Type_API.DB_SALES_PRICES;

   IF (Sales_Part_Base_Price_API.Check_Exist(contract_, catalog_no_, sales_price_type_db_) = 0) THEN
      Sales_Part_Base_Price_API.New(contract_, 
                                    catalog_no_, 
                                    sales_price_type_db_, 
                                    deal_price_,
                                    deal_price_incl_tax_,
                                    'MANUAL', 
                                    NULL, 
                                    0, 
                                    0);
   END IF;

   -- create customer agreement line
   Client_SYS.Set_Item_Value('AGREEMENT_ID', agreement_id_, attr_);
   Client_SYS.Set_Item_Value('MIN_QUANTITY', 0, attr_);
   Client_SYS.Set_Item_Value('VALID_FROM_DATE', Site_API.Get_Site_Date(contract_), attr_);
   Client_SYS.Set_Item_Value('CATALOG_NO', catalog_no_, attr_);
   Client_SYS.Set_Item_Value('BASE_PRICE_SITE', contract_, attr_);
   Client_SYS.Set_Item_Value('BASE_PRICE', deal_price_, attr_);
   Client_SYS.Set_Item_Value('BASE_PRICE_INCL_TAX', deal_price_incl_tax_, attr_);
   Client_SYS.Set_Item_Value('PERCENTAGE_OFFSET', 0, attr_);
   Client_SYS.Set_Item_Value('AMOUNT_OFFSET', 0, attr_);

   Agreement_Sales_Part_Deal_API.New(temp_info_, attr_);

   IF NOT Customer_Agreement_Site_API.Check_Exist(contract_,agreement_id_) THEN
      Customer_Agreement_Site_API.New(agreement_id_,contract_);
   END IF;
   info_ := info_ ||temp_info_;

END New_Agreement_And_Part_Deal;

-- Added the paarameter price_qty_due_ to fetch the agreeement from heirarchy when a CO_line quantity is entered.
-- Get_Price_Agrm_For_Part_Assort
--   Searches a valid agreement for the customer (or from a parent customer of the customer), with the Assortment that has the part node.
--   The selection criteria does not have measures to pick the quantity range.
--   Like in Price List's part step pricing logic; that validation is handled separately in  AgreementAssortmentDeal LU.
PROCEDURE Get_Price_Agrm_For_Part_Assort (
   assortment_id_     OUT VARCHAR2,
   agreement_id_      OUT VARCHAR2,
   customer_level_db_ OUT VARCHAR2,
   customer_level_id_ OUT VARCHAR2,
   customer_no_       IN  VARCHAR2,
   contract_          IN  VARCHAR2,
   currency_          IN  VARCHAR2,
   effectivity_date_  IN  DATE,
   part_no_           IN  VARCHAR2,
   price_uom_         IN  VARCHAR2,
   cust_hierarchy_id_ IN  VARCHAR2 DEFAULT NULL,
   price_qty_due_     IN  NUMBER DEFAULT NULL  )
IS
   last_calendar_date_  DATE := Database_Sys.last_calendar_date_;
   -- This cursor will return valid agreements for the customer
   -- Which have an assortment defined on them
   -- and in those assortment trees the part exist as a sub part node.
   -- Logic derived from Get_Price_Agreement_For_Part method of CustomerAgreement LU
   CURSOR get_valid_agreements (customer_no_ IN VARCHAR2) IS
      SELECT ca.agreement_id, ca.assortment_id
        FROM customer_agreement_tab ca, customer_agreement_site_tab cas, assortment_node_tab ant
       WHERE ca.customer_no   = customer_no_
         AND cas.contract      = contract_
         AND ca.currency_code = currency_
         AND ca.rowstate      = 'Active'
         AND ca.use_explicit != 'Y'
         AND (TRUNC(effectivity_date_) BETWEEN TRUNC(ca.valid_from) AND TRUNC(nvl(ca.valid_until, last_calendar_date_)))
         AND ant.assortment_id = ca.assortment_id
         AND ant.assortment_node_id = part_no_
         AND cas.agreement_id = ca.agreement_id
         AND ca.assortment_id IS NOT NULL;
   temp_node_id_              Agreement_Assortment_Deal_Tab.Assortment_Node_Id%TYPE := NULL;
   prnt_cust_                 cust_hierarchy_struct_tab.customer_parent%TYPE;

   -- Once a valid Agreement-Assortment selected check whether the deal per Assortment has a valid entry for the part.
   -- The below mentioned quantity related comment is not valid further. The quantity is considered in finding the node agreement 
   -- that satisfies the minimum quantity requirement along with the best 'valid from' date to make it traverse the customer hierarchy.   
   -- In this case the quantity range is not considered.
   -- It'll handled at the AgreementAssortmentDeal LU level like the way things handled in the price list's part step pricing logic.
   -- Modified the cursor to consider price_qty_due_ to fetch suitable agreement from heirarchy when a CO_line quantity is entered.    
	CURSOR get_valid_deal_price_entry (assortment_id_ IN VARCHAR2, agreement_id_ IN VARCHAR2) IS
      SELECT t.assortment_node_id
      FROM (SELECT assortment_id, assortment_node_id, parent_node
            FROM assortment_node_tab
            WHERE assortment_id = assortment_id_
            ) t
      WHERE EXISTS (SELECT 1 
                    FROM agreement_assortment_deal_tab dt
                    WHERE dt.assortment_id = t.assortment_id
                    AND dt.assortment_node_id = t.assortment_node_id
                    AND dt.agreement_id = agreement_id_
                    AND NVL(dt.price_unit_meas,CHR(32)) = price_uom_
                    AND dt.valid_from = (SELECT MAX(aad.valid_from)
                                         FROM   agreement_assortment_deal_tab aad
                                         WHERE  aad.agreement_id       = dt.agreement_id
                                         AND    aad.assortment_node_id = dt.assortment_node_id
                                         AND    aad.price_unit_meas = price_uom_
                                         AND    aad.valid_from <= (TRUNC(effectivity_date_))
                                         AND    TRUNC(NVL(valid_to, last_calendar_date_)) >= TRUNC(effectivity_date_))
                    AND dt.deal_price IS NOT NULL
                    AND (dt.min_quantity <= price_qty_due_ OR price_qty_due_ IS NULL)
                    )
      START WITH        t.assortment_node_id = part_no_
      CONNECT BY PRIOR  t.parent_node = t.assortment_node_id;
BEGIN
   -- Check all the valid agreements (with an assortment in it) of the customer, whether any assortment node defined in deal per assortment tab.
   FOR rec_ IN get_valid_agreements (customer_no_) LOOP
      -- temp_node_id_ := Agreement_Assortment_Deal_API.Get_Deal_Price_Node(rec_.assortment_id ,part_no_ ,rec_.agreement_id ,price_uom_);
      OPEN get_valid_deal_price_entry (rec_.assortment_id , rec_.agreement_id);
      FETCH get_valid_deal_price_entry INTO  temp_node_id_;
      CLOSE get_valid_deal_price_entry;

      IF (temp_node_id_ IS NOT NULL) THEN
         assortment_id_     := rec_.assortment_id;
         agreement_id_      := rec_.agreement_id;
         customer_level_db_ := 'CUSTOMER';
         customer_level_id_ := customer_no_;         
      END IF;
      EXIT WHEN temp_node_id_ IS NOT NULL;
   END LOOP;

   -- Look for Customer hierarchy for a deal price node using above logic.
   IF ((cust_hierarchy_id_ IS NOT NULL) AND (temp_node_id_ IS NULL)) THEN
      prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(cust_hierarchy_id_, customer_no_);
      -- Loop label used for exit statement
      <<outer>>
      WHILE (prnt_cust_ IS NOT NULL) LOOP
	  -- <<inner>>
         FOR rec_ IN get_valid_agreements (prnt_cust_) LOOP
            -- temp_node_id_ := Agreement_Assortment_Deal_API.Get_Deal_Price_Node(rec_.assortment_id ,part_no_ ,rec_.agreement_id ,price_uom_);
            OPEN get_valid_deal_price_entry (rec_.assortment_id , rec_.agreement_id);
            FETCH get_valid_deal_price_entry INTO  temp_node_id_;
            CLOSE get_valid_deal_price_entry;
            IF (temp_node_id_ IS NOT NULL) THEN
               assortment_id_ := rec_.assortment_id;
               agreement_id_ := rec_.agreement_id;
               customer_level_db_ := 'HIERARCHY';
               customer_level_id_ := prnt_cust_;
            END IF;
            EXIT outer WHEN temp_node_id_ IS NOT NULL;  -- Exit from both loops
         END LOOP;
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(cust_hierarchy_id_, prnt_cust_);
      END LOOP;
   END IF;
END Get_Price_Agrm_For_Part_Assort;


-- Get_Disc_Agrm_For_Part_Assort
--   Searches a valid agreement with an additional discount for the customer (or from a parent customer of the customer), with the Assortment that has the part node.
--   The selection criteria does not have measures to pick the quantity range.
--   Like in Price List's part step pricing logic; that validation is handled separately in  AgreementAssortmentDeal LU.
PROCEDURE Get_Disc_Agrm_For_Part_Assort (
   assortment_id_      OUT VARCHAR2,
   assortment_node_id_ OUT VARCHAR2,
   agreement_id_       OUT VARCHAR2,
   customer_level_db_  OUT VARCHAR2,
   customer_level_id_  OUT VARCHAR2,
   customer_no_        IN  VARCHAR2,
   contract_           IN  VARCHAR2,
   currency_           IN  VARCHAR2,
   effectivity_date_   IN  DATE,
   part_no_            IN  VARCHAR2,
   price_uom_          IN  VARCHAR2,
   cust_hierarchy_id_  IN  VARCHAR2 DEFAULT NULL,
   quantity_           IN  NUMBER )
IS
   last_calendar_date_  DATE := Database_Sys.last_calendar_date_;
   -- This cursor will return valid agreements for the customer
   -- Which have an assortment defined on them
   -- and in those assortment trees the part exist as a sub part node.
   -- Logic derived from Get_Disc_Agreement_For_Part method of CustomerAgreement LU
   CURSOR get_valid_agreements (customer_no_ IN VARCHAR2) IS
      SELECT ca.agreement_id, ca.assortment_id
        FROM customer_agreement_tab ca, customer_agreement_site_tab cas, assortment_node_tab ant, agreement_assortment_deal_tab dt
       WHERE ca.customer_no   = customer_no_
         AND cas.contract     = contract_
         AND ca.currency_code = currency_
         AND ca.rowstate      = 'Active'
         AND ca.use_explicit != 'Y'
         AND ca.agreement_id = dt.agreement_id
         AND dt.min_quantity <= quantity_
         AND (TRUNC(effectivity_date_) BETWEEN TRUNC(ca.valid_from) AND TRUNC(nvl(ca.valid_until, last_calendar_date_)))
         AND (TRUNC(effectivity_date_) BETWEEN dt.valid_from AND nvl(dt.valid_to, last_calendar_date_))
         AND ant.assortment_id = ca.assortment_id
         AND ant.assortment_node_id = part_no_
         AND cas.agreement_id = ca.agreement_id
         AND ca.assortment_id IS NOT NULL
         AND dt.deal_price IS NULL;
   temp_node_id_              Agreement_Assortment_Deal_Tab.Assortment_Node_Id%TYPE := NULL;
   prnt_cust_                 cust_hierarchy_struct_tab.customer_parent%TYPE;

   -- Once a valid Agreement-Assortment selected check whether the deal per Assortment has a valid dicount entry for the part.
   -- Like in the Get_Disc_Agreement_For_Part, the lines only with a discount has considered.
   -- In this case the quantity range is not considered. Like with the Get_Price_Agrm_For_Part_Assort.
   -- It'll handled at the AgreementAssortmentDeal LU level like the way things handled in the price fetching logic with part step pricing logic.
   CURSOR get_valid_dicount_entry (assortment_id_ IN VARCHAR2, agreement_id_ IN VARCHAR2) IS
      SELECT t.assortment_node_id
      FROM (SELECT assortment_id, assortment_node_id, parent_node
            FROM assortment_node_tab
            WHERE assortment_id = assortment_id_
            ) t
      WHERE EXISTS (SELECT 1 FROM agreement_assortment_deal_tab dt
                    WHERE  dt.assortment_id = t.assortment_id
                    AND    dt.assortment_node_id = t.assortment_node_id
                    AND    dt.agreement_id = agreement_id_
                    AND    dt.price_unit_meas = NVL(price_uom_,'*')
                    AND    dt.min_quantity <= quantity_
                    AND    dt.valid_from = (SELECT MAX(aad.valid_from)
                                            FROM   agreement_assortment_deal_tab aad
                                            WHERE  aad.agreement_id       = dt.agreement_id
                                            AND    aad.assortment_node_id = dt.assortment_node_id
                                            AND    aad.price_unit_meas = NVL(price_uom_,'*')
                                            AND    aad.valid_from <= (TRUNC(effectivity_date_))
                                            AND    TRUNC(NVL(aad.valid_to, last_calendar_date_)) >= TRUNC(NVL(effectivity_date_, SYSDATE)))
                    AND    dt.deal_price IS NULL)
      START WITH        t.assortment_node_id = part_no_
      CONNECT BY PRIOR  t.parent_node = t.assortment_node_id;
  
   -- Standalone discount may exist that valid for all UoMs.
   CURSOR get_valid_disc_all_uom (assortment_id_ IN VARCHAR2, agreement_id_ IN VARCHAR2) IS
      SELECT t.assortment_node_id
      FROM (SELECT assortment_id, assortment_node_id, parent_node
            FROM assortment_node_tab 
            WHERE assortment_id = assortment_id_
            )  t
      WHERE  EXISTS (SELECT 1 FROM agreement_assortment_deal_tab dt
                        WHERE  dt.assortment_id = t.assortment_id
                        AND    dt.assortment_node_id = t.assortment_node_id
                        AND    dt.agreement_id = agreement_id_
                        AND    dt.price_unit_meas = '*'
                        AND    dt.min_quantity <= quantity_
                        AND    dt.valid_from = (SELECT MAX(aad.valid_from)
                                                FROM   agreement_assortment_deal_tab aad
                                                WHERE  aad.agreement_id       = dt.agreement_id
                                                AND    aad.assortment_node_id = dt.assortment_node_id
                                                AND    aad.price_unit_meas = '*'
                                                AND    aad.valid_from <= (TRUNC(effectivity_date_))
                                                AND    TRUNC(NVL(aad.valid_to, last_calendar_date_)) >= TRUNC(NVL(effectivity_date_, SYSDATE)))
                        AND    dt.deal_price IS NULL
                     )
      START WITH        t.assortment_node_id = part_no_
      CONNECT BY PRIOR  t.parent_node = t.assortment_node_id;
BEGIN
   -- Check all the valid agreements (with an assortment in it) of the customer, whether any assortment node defined in deal per assortment tab.
   FOR rec_ IN get_valid_agreements (customer_no_) LOOP
      OPEN get_valid_dicount_entry (rec_.assortment_id , rec_.agreement_id);
      FETCH get_valid_dicount_entry INTO  temp_node_id_;
      CLOSE get_valid_dicount_entry;
      IF (temp_node_id_ IS NOT NULL) THEN
         assortment_id_ := rec_.assortment_id;
         agreement_id_ := rec_.agreement_id;
         customer_level_db_ := 'CUSTOMER';
         customer_level_id_ := customer_no_;
         assortment_node_id_ := temp_node_id_;
      ELSE            
         -- Search for Standalone discount that valid for all UoMs, only if the given UoM does not have a match.
         OPEN get_valid_disc_all_uom (rec_.assortment_id , rec_.agreement_id);
         FETCH get_valid_disc_all_uom INTO  temp_node_id_;
         CLOSE get_valid_disc_all_uom;
         IF (temp_node_id_ IS NOT NULL) THEN
            assortment_id_ := rec_.assortment_id;
            agreement_id_ := rec_.agreement_id;
            customer_level_db_ := 'CUSTOMER';
            customer_level_id_ := customer_no_;
            assortment_node_id_ := temp_node_id_;
         END IF;
      END IF;
      EXIT WHEN temp_node_id_ IS NOT NULL;
   END LOOP;

   -- Look for Customer hierarchy for a discount node using above logic.
   IF ((cust_hierarchy_id_ IS NOT NULL) AND (temp_node_id_ IS NULL)) THEN
      prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(cust_hierarchy_id_, customer_no_);
      -- Loop label used for exit statement
      <<outer>>
      WHILE (prnt_cust_ IS NOT NULL) LOOP
        -- <<inner>>
         FOR rec_ IN get_valid_agreements (prnt_cust_) LOOP
            OPEN get_valid_dicount_entry (rec_.assortment_id , rec_.agreement_id);
            FETCH get_valid_dicount_entry INTO  temp_node_id_;
            CLOSE get_valid_dicount_entry;
            IF (temp_node_id_ IS NOT NULL) THEN
               assortment_id_ := rec_.assortment_id;
               agreement_id_ := rec_.agreement_id;
               customer_level_db_ := 'HIERARCHY';
               customer_level_id_ := prnt_cust_;
               assortment_node_id_ := temp_node_id_;
            ELSE                             
               -- Search for Standalone discount that valid for all UoMs, only if the given UoM does not have a match.
               OPEN get_valid_disc_all_uom (rec_.assortment_id , rec_.agreement_id);
               FETCH get_valid_disc_all_uom INTO  temp_node_id_;
               CLOSE get_valid_disc_all_uom;
               IF (temp_node_id_ IS NOT NULL) THEN
                  assortment_id_ := rec_.assortment_id;
                  agreement_id_ := rec_.agreement_id;
                  customer_level_db_ := 'HIERARCHY';
                  customer_level_id_ := prnt_cust_;
                  assortment_node_id_ := temp_node_id_;
               END IF;
            END IF;
            EXIT outer WHEN temp_node_id_ IS NOT NULL;  -- Exit from both loops
         END LOOP;
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(cust_hierarchy_id_, prnt_cust_);
      END LOOP;
   END IF;
END Get_Disc_Agrm_For_Part_Assort;


@UncheckedAccess
FUNCTION Get_Contract (
   agreement_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_AGREEMENT_SITE_TAB.CONTRACT%TYPE;
   CURSOR get_contract IS
      SELECT contract
      FROM customer_agreement_site_tab
      WHERE agreement_id = agreement_id_;
BEGIN
   OPEN get_contract;
   FETCH get_contract INTO temp_;
   CLOSE get_contract;
   RETURN temp_;
END Get_Contract;


-- Get_Id_In_Assortment_Deal
--   This will return the assortment id if there are records found on deal per assortment for the agreement.
@UncheckedAccess
FUNCTION Get_Id_In_Assortment_Deal (
   agreement_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ AGREEMENT_ASSORTMENT_DEAL_TAB.assortment_id%TYPE;
   CURSOR get_attr IS
      SELECT assortment_id
      FROM agreement_assortment_deal_tab
      WHERE agreement_id = agreement_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Id_In_Assortment_Deal;

@IgnoreUnitTest DMLOperation
PROCEDURE Set_Msg_Sequence_And_Version (
   agreement_id_ IN VARCHAR2,
   sequence_no_  IN NUMBER,
   version_no_   IN NUMBER )
IS
   attr_       VARCHAR2(2000) := NULL;
   newrec_     CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   oldrec_     CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   objid_      CUSTOMER_AGREEMENT.objid%TYPE;
   objversion_ CUSTOMER_AGREEMENT.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Client_SYS.Add_To_Attr('MSG_SEQUENCE_NO', sequence_no_, attr_);
   Client_SYS.Add_To_Attr('MSG_VERSION_NO', version_no_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);

END Set_Msg_Sequence_And_Version;


-- Check_Active_Agree_Per_Assort
--   This will return 1 if the assortment_id is connected to an active agreement; 0 otherwise.
@UncheckedAccess
FUNCTION Check_Active_Agree_Per_Assort (
   assortment_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_agreement IS
      SELECT count(*)
      FROM   CUSTOMER_AGREEMENT_TAB
      WHERE  rowstate = 'Active'
      AND    assortment_id = assortment_id_;
BEGIN

   OPEN exist_agreement;
   FETCH exist_agreement INTO dummy_;
   CLOSE exist_agreement;

   IF (dummy_ > 0) THEN
      dummy_ := 1;
   END IF;

   RETURN dummy_;
END Check_Active_Agree_Per_Assort;


-- Activate_Allowed
--   This will return 1 if the agreement can be possible to active; 0 otherwise.
@UncheckedAccess
FUNCTION Activate_Allowed (
   agreement_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;

   CURSOR get_site IS
      SELECT 1
        FROM customer_agreement_site_tab
       WHERE agreement_id = agreement_id_;
   CURSOR get_part_deal IS
      SELECT 1
        FROM agreement_sales_part_deal_tab
       WHERE agreement_id = agreement_id_;
   CURSOR get_group_deal IS
      SELECT 1
        FROM agreement_sales_group_deal_tab
       WHERE agreement_id = agreement_id_;
   CURSOR get_assortment IS
      SELECT 1
        FROM agreement_assortment_deal_tab
       WHERE agreement_id = agreement_id_;
BEGIN
   OPEN get_part_deal;
   FETCH get_part_deal INTO dummy_;
   IF (get_part_deal%NOTFOUND) THEN
      OPEN get_group_deal;
      FETCH get_group_deal INTO dummy_;
      IF (get_group_deal%NOTFOUND) THEN
         OPEN get_assortment;
         FETCH get_assortment INTO dummy_;
         IF (get_assortment%NOTFOUND) THEN
            RETURN 0;
         END IF;
         CLOSE get_assortment;
      END IF;
      CLOSE get_group_deal;
   END IF;
   CLOSE get_part_deal;

   OPEN get_site;
   FETCH get_site INTO dummy_;
   IF (get_site%NOTFOUND) THEN
      CLOSE get_site;
      RETURN 0;
   END IF;
   CLOSE get_site;
   RETURN 1;
END Activate_Allowed;


-- Get_Agreement_Defaults
--   Sets default values for the customer agreement.
PROCEDURE Get_Agreement_Defaults (
   attr_ IN OUT VARCHAR2 )
IS
   customer_no_        CUSTOMER_AGREEMENT_TAB.customer_no%TYPE := Client_SYS.Get_Item_Value('CUSTOMER_NO', attr_);
   company_            CUSTOMER_AGREEMENT_TAB.company%TYPE := Client_SYS.Get_Item_Value('COMPANY', attr_);
   delivery_terms_     CUSTOMER_AGREEMENT_TAB.delivery_terms%TYPE;
   del_terms_location_ CUSTOMER_AGREEMENT_TAB.del_terms_location%TYPE := NULL;
   ship_via_code_      CUSTOMER_AGREEMENT_TAB.ship_via_code%TYPE;
   curr_code_          CUSTOMER_AGREEMENT_TAB.currency_code%TYPE;
   address_rec_        Cust_Ord_Customer_Address_API.Public_Rec;
   ship_addr_no_       VARCHAR2(50);
   customer_name_      VARCHAR2(100);
   lang_code_          VARCHAR2(2);
   use_price_incl_tax_ VARCHAR2(20);
   
BEGIN
   
   ship_addr_no_ := Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_);
   address_rec_  := Cust_Ord_Customer_Address_API.Get(customer_no_, ship_addr_no_);
   
   IF (Client_SYS.Get_Item_Value('CUSTOMER_NAME', attr_) IS NULL) THEN
      customer_name_ := Cust_Ord_Customer_API.Get_Name(customer_no_);
      Client_SYS.Set_Item_Value('CUSTOMER_NAME', customer_name_, attr_);
   END IF;

   IF (Client_SYS.Get_Item_Value('LANGUAGE_CODE', attr_) IS NULL) THEN
      lang_code_ := Cust_Ord_Customer_API.Get_Language_Code(customer_no_);
      Client_SYS.Set_Item_Value('LANGUAGE_CODE', lang_code_, attr_);
   END IF;
   
   IF (Client_SYS.Get_Item_Value('DELIVERY_TERMS', attr_) IS NULL) THEN
      delivery_terms_ := address_rec_.delivery_terms;
      Client_SYS.Set_Item_Value('DELIVERY_TERMS', delivery_terms_, attr_);
   END IF;

   IF (Client_SYS.Get_Item_Value('DEL_TERMS_LOCATION', attr_) IS NULL) THEN
      del_terms_location_ := address_rec_.del_terms_location;
      Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', del_terms_location_, attr_);
   END IF;    

   IF (Client_SYS.Get_Item_Value('SHIP_VIA_CODE', attr_) IS NULL) THEN
      ship_via_code_ := address_rec_.ship_via_code;
      Client_SYS.Set_Item_Value('SHIP_VIA_CODE', ship_via_code_, attr_);
   END IF;  

   IF (Client_SYS.Get_Item_Value('CURRENCY_CODE', attr_) IS NULL) THEN
      curr_code_ := Cust_Ord_Customer_API.Get_Currency_Code(customer_no_);
      Client_SYS.Set_Item_Value('CURRENCY_CODE', curr_code_, attr_);
   END IF;

   IF (Client_SYS.Get_Item_Value('USE_PRICE_INCL_TAX', attr_) IS NULL) THEN
      use_price_incl_tax_ := Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(customer_no_, company_);
      Client_SYS.Set_Item_Value('USE_PRICE_INCL_TAX', use_price_incl_tax_, attr_);
   END IF;   

END Get_Agreement_Defaults;

-----------------------------------------------------------------------------
-- Has_Valid_Part_Deal
--    Return TRUE (1) if the agreement has a valid Part deal for a given
--    Agreement, Catalog No, Price Qty Due and Effectivity Date. check_for_price_
--    is set as TRUE (1) if price needed to be checked and set as FALSE (0)
--    if discounts needed to be checked.
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Has_Valid_Part_Deal(
   agreement_id_        IN  VARCHAR2,
   catalog_no_          IN  VARCHAR2,
   check_for_price_     IN  NUMBER,
   price_qty_due_       IN  NUMBER,
   effectivity_date_    IN  DATE ) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR exist_part_deal IS
      SELECT 1
      FROM   agreement_sales_part_deal_tab asp
      WHERE  asp.agreement_id  = agreement_id_
      AND    (asp.valid_from_date = (SELECT MAX(asp2.valid_from_date)
                                     FROM   agreement_sales_part_deal_tab asp2
                                     WHERE  asp2.agreement_id     = agreement_id_
                                     AND    asp2.catalog_no       = catalog_no_
                                     AND    asp2.min_quantity    <= price_qty_due_
                                     AND    asp2.valid_from_date <= TRUNC(effectivity_date_)
                                     AND    asp2.valid_to_date IS NULL)                                       
           OR asp.valid_from_date = (SELECT asp2.valid_from_date
                                     FROM   agreement_sales_part_deal_tab asp2
                                     WHERE  asp2.agreement_id     = agreement_id_
                                     AND    asp2.catalog_no       = catalog_no_
                                     AND    asp2.min_quantity    <= price_qty_due_
                                     AND    valid_from_date      <= TRUNC(effectivity_date_)
                                     AND    valid_to_date        >= TRUNC(effectivity_date_)
                                     AND    valid_to_date IS NOT NULL))                                       
      AND    asp.catalog_no   = catalog_no_
      AND    asp.min_quantity <= price_qty_due_
      AND    ((check_for_price_ = 1 AND asp.deal_price IS NOT NULL) OR (check_for_price_ = 0 AND asp.deal_price IS NULL));
BEGIN
   OPEN exist_part_deal;
   FETCH exist_part_deal INTO found_;
   IF exist_part_deal%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE exist_part_deal;
   RETURN found_;
END Has_Valid_Part_Deal;

-----------------------------------------------------------------------------
-- Has_Valid_Assortment_Deal
--    Return TRUE (1) if the agreement has a valid Assortment deal for a given
--    Agreement, Catalog No, Price Qty Due and Effectivity Date. check_for_price_
--    is set as TRUE (1) if price needed to be checked and set as FALSE (0)
--    if discounts needed to be checked.
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Has_Valid_Assortment_Deal(
   agreement_id_        IN  VARCHAR2,
   assortment_id_       IN  VARCHAR2,
   catalog_no_          IN  VARCHAR2,
   price_uom_           IN  VARCHAR2,
   check_for_price_     IN  NUMBER,
   price_qty_due_       IN  NUMBER,
   effectivity_date_    IN  DATE ) RETURN NUMBER
IS
   found_               NUMBER;
   price_unit_meas_     VARCHAR2(30);   
   CURSOR exist_assortment_deal (price_unit_meas_ IN VARCHAR2)IS
      SELECT 1
      FROM assortment_node_tab t
      WHERE EXISTS (SELECT 1 FROM agreement_assortment_deal_tab dt
                             WHERE dt.assortment_id = t.assortment_id
                             AND dt.assortment_node_id = t.assortment_node_id
                             AND dt.agreement_id = agreement_id_
                             AND dt.price_unit_meas = price_unit_meas_
                             AND dt.min_quantity <= price_qty_due_
                             AND ((check_for_price_ = 1 AND dt.deal_price IS NOT NULL) OR (check_for_price_ = 0 AND dt.deal_price IS NULL))
                             AND (dt.valid_from = (SELECT MAX(aad.valid_from)
                                                   FROM   agreement_assortment_deal_tab aad
                                                   WHERE  aad.agreement_id       = dt.agreement_id
                                                   AND    aad.assortment_id      = dt.assortment_id
                                                   AND    aad.assortment_node_id = dt.assortment_node_id
                                                   AND    aad.price_unit_meas    = price_unit_meas_
                                                   AND    aad.min_quantity      <= price_qty_due_
                                                   AND    aad.valid_from        <= TRUNC(effectivity_date_)
                                                   AND    aad.valid_to IS NULL)                                                  
                               OR dt.valid_from = (SELECT aad.valid_from
                                                   FROM   agreement_assortment_deal_tab aad
                                                   WHERE  aad.agreement_id       = dt.agreement_id
                                                   AND    aad.assortment_id      = dt.assortment_id
                                                   AND    aad.assortment_node_id = dt.assortment_node_id
                                                   AND    aad.price_unit_meas    = price_unit_meas_
                                                   AND    aad.min_quantity      <= price_qty_due_
                                                   AND    aad.valid_from        <= TRUNC(effectivity_date_)
                                                   AND    aad.valid_to          >= TRUNC(effectivity_date_)
                                                   AND    aad.valid_to IS NOT NULL))                                        
                    )
      START WITH        t.assortment_id = assortment_id_
             AND        t.assortment_node_id = catalog_no_
      CONNECT BY PRIOR  t.assortment_id = t.assortment_id
             AND PRIOR  t.parent_node = t.assortment_node_id;

BEGIN
   price_unit_meas_ := price_uom_;
   -- Search for the best line that has the given price uom. 
   OPEN exist_assortment_deal(price_unit_meas_);
   FETCH exist_assortment_deal INTO found_;
   IF exist_assortment_deal%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE exist_assortment_deal;
   -- If given UoM does not have a matching line for discount, search for all UoM lines.
   IF (check_for_price_ = 0) AND (found_ = 0) THEN
      price_unit_meas_ := '*';
      OPEN exist_assortment_deal(price_unit_meas_);
      FETCH exist_assortment_deal INTO found_;
      IF exist_assortment_deal%NOTFOUND THEN
         found_ := 0;
      END IF;
      CLOSE exist_assortment_deal;
   END IF;
   RETURN found_;
END Has_Valid_Assortment_Deal;

-----------------------------------------------------------------------------
-- Has_Valid_Group_Deal
--    Return TRUE (1) if the agreement has a valid Assortment deal for a given
--    Agreement, Catalog group, Price Qty Due and Effectivity Date.
-----------------------------------------------------------------------------
FUNCTION Has_Valid_Group_Deal(
   agreement_id_     IN VARCHAR2,
   catalog_group_    IN VARCHAR2,
   price_qty_due_    IN NUMBER,
   effectivity_date_ IN DATE ) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR exist_group_deal IS
      SELECT 1
      FROM   agreement_sales_group_deal_tab asp
      WHERE  asp.agreement_id  = agreement_id_      
      AND    (asp.valid_from_date = (SELECT MAX(asp2.valid_from_date)
                                     FROM   agreement_sales_group_deal_tab asp2
                                     WHERE  asp2.agreement_id    = agreement_id_
                                     AND    asp.catalog_group = catalog_group_
                                     AND    asp.min_quantity <= price_qty_due_
                                     AND    asp2.valid_from_date <= TRUNC(effectivity_date_)
                                     AND    asp2.valid_to_date IS NULL)
          OR  asp.valid_from_date = (SELECT t.valid_from_date
                                     FROM   agreement_sales_group_deal_tab t
                                     WHERE  t.agreement_id = agreement_id_
                                     AND    asp.catalog_group = catalog_group_
                                     AND    asp.min_quantity <= price_qty_due_
                                     AND    valid_from_date <= TRUNC(effectivity_date_)
                                     AND    valid_to_date >= TRUNC(effectivity_date_)
                                     AND    valid_to_date IS NOT NULL))
      AND asp.catalog_group = catalog_group_
      AND asp.min_quantity <= price_qty_due_;                                 
BEGIN
   OPEN exist_group_deal;
   FETCH exist_group_deal INTO found_;
   IF exist_group_deal%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE exist_group_deal;
   RETURN found_;
END Has_Valid_Group_Deal;
-- Validate_Hierarchy_Customer
--   This will return 1 if the agreement is valid considering customer and parents hierarchy; 0 otherwise.
@UncheckedAccess
FUNCTION Validate_Hierarchy_Customer (
   agreement_id_ IN VARCHAR2,
   customer_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR validate_agreement IS
      SELECT 1
        FROM customer_agreement_tab ca 
       WHERE agreement_id = agreement_id_
         AND ca.customer_no IN (SELECT ch.customer_parent 
                                  FROM cust_hierarchy_struct_tab ch
                                  START WITH ch.customer_no = customer_no_
                                  CONNECT BY PRIOR ch.customer_parent = ch.customer_no);
BEGIN
   
   IF (Customer_Agreement_API.Get_Customer_No(agreement_id_) = customer_no_) THEN
         RETURN 1;
      END IF;
   IF Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_) IS NOT NULL THEN
      OPEN validate_agreement;
      FETCH validate_agreement INTO dummy_;
      IF (validate_agreement%FOUND) THEN
         CLOSE validate_agreement;
         RETURN 1;
      END IF;
      CLOSE validate_agreement;
   END IF;
  RETURN 0;
END Validate_Hierarchy_Customer;
