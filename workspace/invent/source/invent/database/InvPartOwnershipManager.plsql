-----------------------------------------------------------------------------
--
--  Logical unit: InvPartOwnershipManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200116  NISMLK  MFSPRING20-850, Added ownership_transfer_reason_id to ownership_transfer_rec.
--  200109  PAMMLK  MFSPRING20-381,Added new parameter ownership_transfer_reason_id_ to Transfer_Cust_To_Cust_Stock___ 
--  20019           and a variable to Packed_Transfer_Cust_To_Cust__.
--  150414  LEPESE  LIM-77, added handling_unit_id to several methods.
--  140912 NaSalk Modified Packed_Transfer_Rental_Asset__ to support company rental asset transfer to company owned.
--  140910 NaSalk Renamed ownership_transfer_rec and ownership_transfer_table to ownership_transfer_rec
--  140910        and ownership_transfer_table. Modifed Packed_Transfer_Rental_Asset__.
--  140828 NaSalk Added Packed_Transfer_Rental_Asset__.
--  140718 NaSalk Modifed Check_Supp_To_Own_Stock_Allow to include company rental asset ownership.
--  130926 AwWelk TIBE-3812, Modified dummy_param_2_ in Packed_Transfer_Cust_To_Cust__() as IN parameter and modified 
--  130926        transfer_cust_to_cust_tab_ parameter in Transfer_Cust_To_Cust_Stock___() as IN parameter.
--  130731 AwWelk TIBE-862, Removed global variables, modified Packed_Transfer_Cust_To_Cust__() to accept CLOB 
--  130731        parameter and modified Transfer_Cust_To_Cust_Stock___(),Fill_Transfer_Cust_To_Cust___() to 
--  130731        accept transfer_cust_to_cust_rec as a parameter. Remvoed Reset_Transfer_Cust_To_Cust___().
--  110309 LEPESE Modifications to make it possible to change ownership from one customer to another
--  110309        also for parts that are receipt and issue serial tracked only. part_tracking_session_id
--  110309        is received from the client in Packed_Transfer_Cust_To_Cust__ and passed on to
--  110309        Inventory_Part_In_Stock_API.Modify_Owning_Customer_No in method Transfer_Cust_To_Cust_Stock___.
--  100629 MaRalk Removed method Validate_Cancel_Per_Part_Loc since it is no longer used.
--  100629        Moved validations in Validate_Cancel_Per_Line into
--  100629        Inventory_Part_In_Stock_API.Cancel_Receipt_In_Place and removed the method.
--  100622 MaRalk Modified Transfer_Cust_To_Cust_Stock___ to remove extra database call to
--  100622        Inventory_Part_In_Stock_API.Get and moved error message SAMECUST to
--  100622        Inventory_Part_In_Stock_API.Modify_Owning_Customer_No.
--  100622        Modified Packed_Transfer_Cust_To_Cust__ to assign ownership,
--  100622        owner information to transferring record. 
--  100618 MaRalk Removed method Validate_Transfer_To_Company and moved its validations
--  100618        into Inventory_Part_In_Stock_API.Receipt_In_Place.
--  100615 MaRalk Removed error messages QTYRESERVEDEXISTSCUS, QTYTRANSITEXISTSCUST from
--  100615        Transfer_Cust_To_Cust_Stock___ since the logic was moved to
--  100615        Inventory_Part_In_Stock_API.Check_Ownership___ method. Modified Check_Structure_Ownership___
--  100615        as a private method. Moved the validations in Validate_Trans_To_Customer___ into
--  100615        Inventory_Part_In_Stock_API-Check_Ownership___ and Modify_Owning_Customer_No methods and
--  100615        removed the entire method. Modified Packed_Transfer_Cust_To_Cust__.
--  100611 MaEelk Defined the columns of transfer_cust_to_cust_rec as inventory_part_in_stock_tab.<column name>%TYPE.
--  100609 MaEelk Replaced calls to Inventory_Part_Stock_Owner_tab and Inventory_Part_Stock_Owner_API.Get
--  100609        with Inventory_Part_In_Stock_Tab and Inventory_Part_In_Stock_API.Get in Validate_Cancel_Per_Line.
--  100609        Modified Check_Supp_To_Own_Stock_Allow to change the logic in fetching values to to_location_type_db_.
--  100607 MaEelk Modified Check_Supp_To_Own_Stock_Allow, removing unnecessary validations and
--  100607        restructuring the code.
--  100602 MaEelk Removed the obsolete method Check_Move_Part. Modified the signature of Check_Supp_To_Own_Stock_Allow
--  100602        to support the  Receipt of Supplier Owned Stocks into Inventory Locations.
--  100520 MaRalk Removed obsolete method Validate_Per_Inv_Part_Location.
--  100513 MaRalk Removed global variable check_transfer_cust_tab_. Modified methods Packed_Transfer_Cust_To_Cust__,
--  100513        Fill_Transfer_Cust_To_Cust___, Transfer_Cust_To_Cust_Stock___, Reset_Transfer_Cust_To_Cust___
--  100513        to support transfer of ownership between customers.
--  100511 MaEelk Removed obsolete method Move_Part.
--  100505 KRPELK Merge Rose Method Documentation.
--  100426 MaEelk Removed obsolete method Inventory_Transaction.
--  100420 MaEelk Removed the obsolete method Unissue_Part.
--  100420 MaEelk Removed parameters parameters contract_ and part_no from Inventory_Transaction. changed the
--  100420        IN OUT parameter transaction_code_ to an IN parameter. 
--  100416 MaEelk Moved validations to part ownership aggainst transaction codes in Inventory_Transaction to
--  100416        Mpccom_Transaction_Code_API.Check_Part_Ownership_Db.
--  100407 MaEelk Signature was changed in Inventory_Transaction. Introduced new parameters current_owning_vendor_no_ 
--  100407        and  current_owning_customer_no_. Removed location_no_,configuration_id_ and vendor_no_. Restructured the code
--  100407        and moved all ownership validations to Inventory_Part_In_stock_API.Check_Ownership___.
--- -------------------------------- 14.0.0 ---------------------------------
--  080208 LEPESE Bug 71124, modifications in methods Inventory_Transaction, Check_Move_Part and
--  080208        Unissue_Part to increase performance by using methods Get_Inventory_Quantity and
--  080208        Quantity_Exist_At_Location instead of Get_Qty_Onhand_By_Location and 
--  080208        Get_Qty_In_Transit_By_Locations (from Inventory_Part_In_Stock_API).
--  070519 MaMalk Modified Inventory_Transaction to change the messages given by INVALIDTRANSSUP and INVALIDTRANSCUS.
--  070420 RaKalk Removed transaction_ parameter from Unissue_Part procedure
--  070404 RaKalk Removed Transaction parameter from Inventory_Transaction method
-- --------------------------------- Wings Merge End ------------------------
--  070129 Dinklk Merged Wings code.
--  070104 DAYJLK Added overloaded methods Check_Move_Part and Move_Part. Modified old
--  070104        methods Check_Move_Part and Move_Part by adding new parameter to_part_no_.
--  -------------------------------- Wings Merge Start ----------------------
--  060420 IsAnlk Enlarge customer - Changed variable definitions.
--  ------------------------- 13.4.0 ----------------------------------------
--  060222 ShVese LCS 55644- Changed method Inventory_Transaction to handle transit movements as well.
--  060215 LEPESE Changed parameter to_destination_ to to_destination_db_ in Move_Part.
--  060125 JoAnSe Passed in NULL as value in calls to Do_Transaction_Booking
--  060124 LEPESE Corrected contract_ assignment error i method Check_Move_Part.
--  060124 NiDalk Added Assert safe annotation.
--  051024 DaZase Removed error check on activity_seq/project inventory in method Validate_Trans_To_Customer___.
--                The code should allow for transfer ownership between customers even for project inventory.
--  050920 NiDalk Removed unused variables.
--  050706 JOHESE Modified Validate_Cancel_Per_Line to support project inventory
--  050304 Samnlk Modified method Check_Supp_To_Own_Stock_Allow to restrict the pallet locations for 'supplier owned' ownership.
--  041213 JOHESE Modified Validate_Transfer_To_Company, transfer_cust_to_cust_rec, Packed_Transfer_Cust_To_Cust__, Validate_Trans_To_Customer___ and Transfer_Cust_To_Cust_Stock___
--  041130 JOHESE Modivied calls to Inventory_Part_In_Stock_API.Get_Inventory_Quantity
--  041116 WaJalk Changed the message tag in method Inventory_Transaction.
--  041109 Samnlk Change the ownership transaction, in method Inventory_Transaction and added new error message in method Check_Move_Part.
--  041108 WaJalk Modified method Check_Supp_To_Own_Stock_Allow.
--  041102 WaJalk Added method Check_Supp_To_Own_Stock_Allow.
--  041101 Samnlk Change the procedure Inventory_Transaction, exclude supplier owned from one of the selection.
--  041021 Samnlk Changed the procedure Inventory_Transaction, added supplier owned to the conditions.
--  040921 HeWelk Passed null to paramater catch_quantity in Inventory_Transaction_Hist_API.New.
--  040920 JOHESE Modified calls to Inventory_Part_In_Stock_API.Get_Inventory_Quantity
--  040518 DaZaSe Project Inventory: Added zero/null-parameters to call Inventory_Transaction_Hist_API.New,
--                change these parameters to real Activity_Seq and Project_Id values if this functionality uses Project Inventory.
--  040505 DaZaSe Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods,
--                the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  040325 LoPrlk Corrected some errors found in the 2004 SP1 merge.
--  040202 NaWalk Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  -------------------------------- 13.3.0 ----------------------------------
--  040128 MaEeLK Bug 41495, Changed the function Check_Structure_Ownership___ into a procedure and added two extra parameters.
--  040128        Allowed changing part ownership when the top part is composed of company ownerd parts.
--  031016 DAYJLK Call Id 108211, Replaced 'PALLET QA' with 'PALLET QUALITY' in Validate_Transfer_To_Company.
--  031014 PrJalk Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  030917 DAYJLK Call 102743, Modified text of error message OWNERSHIPMISMATCH.
--  030911 MaGulk Changed long error messages
--  030911 DAYJLK Added transaction_id_ as parameter to Validate_Cancel_Per_Line.
--  030910 DAYJLK Modified grouping logic in Validate_Per_Inv_Part_Location.
--  030909 DAYJLK Added public method Validate_Per_Inv_Part_Location.
--  030908 KiSalk Added calls for Inventory_Transaction_Hist_API.Do_Transaction_Booking in Transfer_Cust_To_Cust_Stock___.
--  030905 DAYJLK Added error INVALIDOWNERSHIP in Validate_Transfer_To_Company. Modified Validate_Cancel_Per_Line.
--  030904 KiSalk Removed procedures New_Cust_Part_Acq_Value___ and Receipt_In_Place_Bulk.
--  030903 DAYJLK Moved private methods Packed_Transfer_To_Company__, and Get_Purchase_Price_Info__ to PURCH.
--  030903        Removed methods Get_Transfer_To_Company_Tab, Make_Transfer_To_Company__,Reset_Transfer_To_Company___, Fill_Transfer_To_Company___, and Validate_Per_Inv_Part_Loc___.
--  030903        Added method Validate_Transfer_To_Company.
--  030901 KiSalk Improved procedures Transfer_Cust_To_Cust_Stock___ and Validate_Trans_To_Customer___.
--  030729 DAYJLK Call 99547, Modified error messages in Inventory_Transaction, Check_Move_Part and Unissue_Part to contain more information.
--  030725 DAYJLK Modified methods Receipt_In_Place_Bulk, Validate_Cancel_Per_Part_Loc and Validate_Cancel_Per_Line.
--  030724 KiSalk GEDI206NK Owner Codes- Modified Methods Validate_Trans_To_Customer___, Transfer_Cust_To_Cust_Stock___
--  030724        & New_Cust_Part_Acq_Value___ to allow multiple from Owning Customers.
--  030723 DAYJLK Added methods Validate_Cancel_Per_Line, and Validate_Cancel_Per_Part_Loc.
--  030721 DAYJLK Added public procedure Receipt_In_Place_Bulk.
--  030721 DAYJLK Modified methods Validate_Trans_To_Company___, Validate_Per_Inv_Part_Loc___, and Packed_Transfer_To_Company__.
--  030718 KiSalk GEDI206NK Owner Codes- Added Methods Validate_Trans_To_Customer___ & Check_Structure_Ownership___.
--  030717 DAYJLK Modified interface of method Get_Purchase_Price_Info__ and Modified method Validate_Trans_To_Company___.
--  030716 DAYJLK Added private methods Packed_Transfer_To_Company__, Make_Transfer_To_Company__, Get_Purchase_Price_Info__ and public method
--  030716        Get_Transfer_To_Company_Tab. Added new implementation methods Reset_Transfer_To_Company___, Fill_Transfer_To_Company___
--  030716        Validate_Trans_To_Company___ and Validate_Per_Inv_Part_Loc___. Declared global variable transfer_to_company_tab_.
--  030715 KiSalk GEDI206NK Owner Codes- Added Methods Packed_Transfer_Cust_To_Cust__, Transfer_Cust_To_Cust_Stock___,
--  030715        New_Cust_Part_Acq_Value___,   Reset_Transfer_Cust_To_Cust___
--  030715        & Fill_Transfer_Cust_To_Cust___ and type check_transfer_cust_table.
--  030613 DAYJLK Modified Inventory_Transaction by moving the the previously added restriction block.
--  030529 DAYJLK Added checks to restrict Supplier Loaned and Customer Owned Transactions based on
--  030529        MPCCOM Transaction code settings in Inventory_Transaction.
--  030529 DAYJLK Added Method Unissue_Part.
--  030522 DAYJLK Modified Interfaces of Move_Part and Check_Move_Part.
--  030521 DAYJLK Replaced the usage of IID Consignment_Stock_API with IID Part_Ownership and
--  030521        merged consignment related checks together in Method Check_Move_Part.
--  030515 DAYJLK Added Methods Move_Part and Check_Move_Part.
--  030505 MaEelk Assigned NULL values to owning_vendor_no_ and owning_customer_no
--  030505        for relevant placesin Inventory_Transaction.
--  030502 MaEelk Modified method Inventory_Transaction.
--  030430 MaEelk Modified method Inventory_Transaction.
--  030428 MaEelk Created the LU and created public method Inventory_Transaction
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE ownership_transfer_rec IS RECORD(
      row_no                   NUMBER,
      contract                 VARCHAR2(5),
      part_no                  VARCHAR2(25),
      configuration_id         VARCHAR2(50),
      location_no              VARCHAR2(35),
      lot_batch_no             VARCHAR2(20),
      serial_no                VARCHAR2(50),
      eng_chg_level            VARCHAR2(6),
      waiv_dev_rej_no          VARCHAR2(15),
      activity_seq             NUMBER,
      handling_unit_id         NUMBER,
      condition_code           VARCHAR2(10),
      part_ownership           VARCHAR2(20),
      owner                    VARCHAR2(20),
      qty                      NUMBER,
      catch_qty                NUMBER,
      price                    NUMBER,
      currency_code            VARCHAR2(3),
      discount                 NUMBER,
      additional_cost          NUMBER,
      order_no                 VARCHAR2(12),
      line_no                  VARCHAR2(4),
      release_no               VARCHAR2(4),
      receipt_no               NUMBER,
      order_type               VARCHAR2(20),
      part_tracking_session_id NUMBER,
      ownership_transfer_reason_id VARCHAR2(50));
TYPE ownership_transfer_table IS TABLE OF ownership_transfer_rec INDEX BY BINARY_INTEGER;

TYPE cancel_receipt_in_place_rec IS RECORD(
      order_no           VARCHAR2(12),
      line_no            VARCHAR2(4),
      release_no         VARCHAR2(4),
      receipt_no         NUMBER      );
TYPE cancel_receipt_in_place_table IS TABLE OF cancel_receipt_in_place_rec INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE transfer_cust_to_cust_rec IS RECORD(
      contract                 inventory_part_in_stock_tab.contract%TYPE,
      part_no                  inventory_part_in_stock_tab.part_no%TYPE,
      configuration_id         inventory_part_in_stock_tab.configuration_id%TYPE,
      location_no              inventory_part_in_stock_tab.location_no%TYPE,
      lot_batch_no             inventory_part_in_stock_tab.lot_batch_no%TYPE,
      serial_no                inventory_part_in_stock_tab.serial_no%TYPE,
      eng_chg_level            inventory_part_in_stock_tab.eng_chg_level%TYPE,
      waiv_dev_rej_no          inventory_part_in_stock_tab.waiv_dev_rej_no%TYPE,
      activity_seq             inventory_part_in_stock_tab.activity_seq%TYPE,
      handling_unit_id         inventory_part_in_stock_tab.handling_unit_id%TYPE,
      part_ownership           inventory_part_in_stock_tab.part_ownership%TYPE,
      owning_customer_no       inventory_part_in_stock_tab.owning_customer_no%TYPE,
      qty_on_hand              inventory_part_in_stock_tab.qty_onhand%TYPE,
      part_tracking_session_id NUMBER);
TYPE transfer_cust_to_cust_table IS TABLE OF transfer_cust_to_cust_rec INDEX BY BINARY_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Transfer_Cust_To_Cust_Stock___
--   This will be used to transfer ownership from one customer to another
--   for customer owned stock in Inventory.
PROCEDURE Transfer_Cust_To_Cust_Stock___ (
   transfer_cust_to_cust_tab_    IN  transfer_cust_to_cust_table,
   to_owning_customer_no_        IN  VARCHAR2,
   ownership_transfer_reason_id_ IN VARCHAR2)
IS   
BEGIN
   
   -- transfer ownership
   FOR i IN transfer_cust_to_cust_tab_.FIRST..transfer_cust_to_cust_tab_.LAST LOOP
      -- i equals to the current row number of selected records, being processed.      
       
      IF (transfer_cust_to_cust_tab_(i).part_ownership = Part_Ownership_API.DB_CUSTOMER_OWNED) THEN
         --Modify the Owning Customer
         Inventory_Part_In_Stock_API.Modify_Owning_Customer_No(contract_                     => transfer_cust_to_cust_tab_(i).contract,
                                                               part_no_                      => transfer_cust_to_cust_tab_(i).part_no,
                                                               configuration_id_             => transfer_cust_to_cust_tab_(i).configuration_id,
                                                               location_no_                  => transfer_cust_to_cust_tab_(i).location_no,
                                                               lot_batch_no_                 => transfer_cust_to_cust_tab_(i).lot_batch_no,
                                                               serial_no_                    => transfer_cust_to_cust_tab_(i).serial_no,
                                                               eng_chg_level_                => transfer_cust_to_cust_tab_(i).eng_chg_level,
                                                               waiv_dev_rej_no_              => transfer_cust_to_cust_tab_(i).waiv_dev_rej_no,
                                                               activity_seq_                 => transfer_cust_to_cust_tab_(i).activity_seq,
                                                               handling_unit_id_             => transfer_cust_to_cust_tab_(i).handling_unit_id,
                                                               owning_customer_              => to_owning_customer_no_,
                                                               part_tracking_session_id_     => transfer_cust_to_cust_tab_(i).part_tracking_session_id,
                                                               ownership_transfer_reason_id_ => ownership_transfer_reason_id_);
      END IF;
   END LOOP;
END Transfer_Cust_To_Cust_Stock___;


-- Fill_Transfer_Cust_To_Cust___
--   This will be used to fill the public PL/SQL table
--   transfer_cust_to_cust_tab_ with data.
PROCEDURE Fill_Transfer_Cust_To_Cust___ (
   transfer_cust_to_cust_tab_ IN OUT transfer_cust_to_cust_table,
   transfer_rec_              IN     transfer_cust_to_cust_rec )
IS
   index_                NUMBER;   
BEGIN
   index_:=transfer_cust_to_cust_tab_.COUNT;
   index_:= index_+ 1;   

   -- Insert in to the PL/SQL table 'transfer_cust_to_cust_tab_':
   transfer_cust_to_cust_tab_(index_).contract                 := transfer_rec_.contract;
   transfer_cust_to_cust_tab_(index_).part_no                  := transfer_rec_.part_no;
   transfer_cust_to_cust_tab_(index_).configuration_id         := transfer_rec_.configuration_id;
   transfer_cust_to_cust_tab_(index_).location_no              := transfer_rec_.location_no;
   transfer_cust_to_cust_tab_(index_).lot_batch_no             := transfer_rec_.lot_batch_no;
   transfer_cust_to_cust_tab_(index_).serial_no                := transfer_rec_.serial_no;
   transfer_cust_to_cust_tab_(index_).eng_chg_level            := transfer_rec_.eng_chg_level;
   transfer_cust_to_cust_tab_(index_).waiv_dev_rej_no          := transfer_rec_.waiv_dev_rej_no;
   transfer_cust_to_cust_tab_(index_).activity_seq             := transfer_rec_.activity_seq;
   transfer_cust_to_cust_tab_(index_).handling_unit_id         := transfer_rec_.handling_unit_id;
   transfer_cust_to_cust_tab_(index_).qty_on_hand              := transfer_rec_.qty_on_hand;
   transfer_cust_to_cust_tab_(index_).part_ownership           := transfer_rec_.part_ownership;
   transfer_cust_to_cust_tab_(index_).owning_customer_no       := transfer_rec_.owning_customer_no;
   transfer_cust_to_cust_tab_(index_).part_tracking_session_id := transfer_rec_.part_tracking_session_id;
   
END Fill_Transfer_Cust_To_Cust___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Packed_Transfer_Cust_To_Cust__ (
   dummy_param_1_       IN OUT VARCHAR2,
   dummy_param_2_       IN     VARCHAR2,
   message_             IN     CLOB )
IS
   count_                      NUMBER;
   name_arr_                     Message_SYS.name_table;
   value_arr_                    Message_SYS.line_table;
   transfer_rec_                 transfer_cust_to_cust_rec;
   to_owning_customer_no_        Inventory_Part_In_Stock_Tab.owning_customer_no%TYPE;
   transfer_cust_to_cust_tab_    transfer_cust_to_cust_table; 
   ownership_transfer_reason_id_ VARCHAR2(50);
   
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'PACK_START') THEN
         transfer_cust_to_cust_tab_.DELETE; 
      ELSIF (name_arr_(n_) = 'TO_CUSTOMER') THEN
         to_owning_customer_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONTRACT') THEN
         transfer_rec_.contract := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PART_NO') THEN
         transfer_rec_.part_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONFIGURATION_ID') THEN
         transfer_rec_.configuration_id := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOCATION_NO') THEN
         transfer_rec_.location_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOT_BATCH_NO') THEN
         transfer_rec_.lot_batch_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SERIAL_NO') THEN
         transfer_rec_.serial_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ENG_CHG_LEVEL') THEN
         transfer_rec_.eng_chg_level := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'WAIV_DEV_REJ_NO') THEN
         transfer_rec_.waiv_dev_rej_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ACTIVITY_SEQ') THEN
         transfer_rec_.activity_seq := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         transfer_rec_.handling_unit_id := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PART_OWNERSHIP_DB') THEN
         transfer_rec_.part_ownership := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'OWNER') THEN
         transfer_rec_.owning_customer_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PART_TRACKING_SESSION_ID') THEN
         transfer_rec_.part_tracking_session_id := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'QTY_ON_HAND') THEN
         transfer_rec_.qty_on_hand  := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
         -- Insert in the PL/SQL table 'transfer_cust_to_cust_tab_'
         Fill_Transfer_Cust_To_Cust___(transfer_cust_to_cust_tab_, transfer_rec_); 
      ELSIF (name_arr_(n_) = 'OWNERSHIP_TRANSFER_REASON_ID') THEN
         ownership_transfer_reason_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PACK_COMPLETE') THEN
         Transfer_Cust_To_Cust_Stock___(transfer_cust_to_cust_tab_, to_owning_customer_no_,ownership_transfer_reason_id_);        
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;
   
END Packed_Transfer_Cust_To_Cust__;


PROCEDURE Check_Structure_Ownership__ (
   message_              OUT VARCHAR2,
   has_single_ownership_ OUT VARCHAR2,
   part_no_              IN  VARCHAR2,
   lot_batch_no_         IN  VARCHAR2,
   serial_no_            IN  VARCHAR2,
   top_ownership_db_     IN  VARCHAR2,
   top_customer_no_      IN  VARCHAR2,
   top_vendor_no_        IN  VARCHAR2,
   transfer_to_company_  IN  VARCHAR2 )
IS
   contains_company_owned_    VARCHAR2(10);
   contains_supplier_loaned_  VARCHAR2(10);
   contains_customer_owned_   VARCHAR2(10);
   owning_vendor_no_list_     VARCHAR2(32000);
   owning_customer_no_list_   VARCHAR2(32000);
   delim_                     CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;
   contains_top_customer_     BOOLEAN := FALSE;
   contains_top_vendor_       BOOLEAN := FALSE;
   customer_count_            NUMBER;
   vendor_count_              NUMBER;
BEGIN


   message_ := '';

   IF serial_no_!='*' THEN
      Part_Serial_Catalog_API.Get_Structure_Ownership (has_single_ownership_,
                                                       contains_company_owned_,
                                                       contains_supplier_loaned_,
                                                       contains_customer_owned_,
                                                       owning_vendor_no_list_,
                                                       owning_customer_no_list_,
                                                       part_no_,
                                                       serial_no_,
                                                       top_ownership_db_,
                                                       top_vendor_no_,
                                                       top_customer_no_);
      IF has_single_ownership_='FALSE' THEN
         message_ := Language_SYS.Translate_Constant(lu_name_, 'SERIALWITHDIFFOWNER: Part :P1, Serial No. :P2 has components with different owners.', NULL, part_no_,serial_no_);
      END IF;
   ELSIF lot_batch_no_!='*' THEN
      Lot_Batch_Master_API.Get_Structure_Ownership (has_single_ownership_,
                                                    contains_company_owned_,
                                                    contains_supplier_loaned_,
                                                    contains_customer_owned_,
                                                    owning_vendor_no_list_,
                                                    owning_customer_no_list_,
                                                    part_no_,
                                                    lot_batch_no_,
                                                    top_ownership_db_,
                                                    top_vendor_no_,
                                                    top_customer_no_);
      IF has_single_ownership_='FALSE' THEN
         message_ := Language_SYS.Translate_Constant(lu_name_, 'LOTWITHDIFFOWNER: Part :P1, Lot :P2 has components with different owners.', NULL, part_no_,lot_batch_no_);
      END IF;
   ELSE
      has_single_ownership_:= 'TRUE';
   END IF;

   IF (has_single_ownership_='FALSE') AND (transfer_to_company_ = 'YES') THEN
      IF (owning_vendor_no_list_ IS NOT NULL) THEN

         -- check if vendor list contains top part owner
         IF (INSTR(owning_vendor_no_list_, delim_ || top_vendor_no_ || delim_) > 0 ) THEN
            contains_top_vendor_ := TRUE;
         END IF;

         -- remove starting and ending delimiters
         owning_vendor_no_list_ := SUBSTR(owning_vendor_no_list_, 2, LENGTH(owning_vendor_no_list_)-2);

         vendor_count_ := 1;
         WHILE (INSTR(owning_vendor_no_list_, delim_, 1, vendor_count_) > 0) LOOP
            vendor_count_ := vendor_count_ + 1;
         END LOOP;

      ELSE
         vendor_count_ := 0;
      END IF;

      IF (owning_customer_no_list_ IS NOT NULL) THEN

         -- check if customer list contains top part owner
         IF (INSTR(owning_customer_no_list_, delim_ || top_customer_no_ || delim_) > 0 ) THEN
            contains_top_customer_ := TRUE;
         END IF;

         -- remove starting and ending delimiters
         owning_customer_no_list_ := SUBSTR(owning_customer_no_list_, 2, LENGTH(owning_customer_no_list_)-2);

         customer_count_ := 1;
         WHILE (INSTR(owning_customer_no_list_, delim_, 1, customer_count_) > 0) LOOP
            customer_count_ := customer_count_ + 1;
         END LOOP;

      ELSE
         customer_count_ := 0;
      END IF;

      IF (top_ownership_db_ = 'CUSTOMER OWNED') THEN
         IF (contains_supplier_loaned_ = 'FALSE') THEN
            IF (((customer_count_ = 1) AND contains_top_customer_) OR
               ((customer_count_ = 0) AND (contains_company_owned_ = 'TRUE'))) THEN
               has_single_ownership_ := 'TRUE';
               message_ := '';
            END IF;
         END IF;

      ELSIF (top_ownership_db_ = 'SUPPLIER LOANED') THEN
         IF (contains_customer_owned_ = 'FALSE') THEN
            IF (((vendor_count_ = 1) AND contains_top_vendor_) OR
               ((vendor_count_ = 0) AND (contains_company_owned_ = 'TRUE'))) THEN
               has_single_ownership_ := 'TRUE';
               message_ := '';
            END IF;
         END IF;
      END IF;

   END IF;

END Check_Structure_Ownership__;

--Packed_Transfer_Rental_Asset___  
--  This method is used to transfer ownership between company owned and company rental assets. Ownership change is 
--  passed in transfer_action_.
PROCEDURE Packed_Transfer_Rental_Asset__ (
   dummy_param_1_       IN OUT VARCHAR2,
   attr_                IN     VARCHAR2,
   message_             IN     CLOB )
IS
   count_                      NUMBER;
   name_arr_                   Message_SYS.name_table;
   value_arr_                  Message_SYS.line_table;
   transfer_rec_               ownership_transfer_rec;
   index_                      NUMBER;
   rental_asset_transfer_tab_  ownership_transfer_table;  
   account_no_                 VARCHAR2(20);
   code_b_                     VARCHAR2(20);
   code_c_                     VARCHAR2(20);
   code_d_                     VARCHAR2(20);
   code_e_                     VARCHAR2(20);
   code_f_                     VARCHAR2(20);
   code_g_                     VARCHAR2(20);
   code_h_                     VARCHAR2(20);
   code_i_                     VARCHAR2(20);
   code_j_                     VARCHAR2(20);
   transfer_action_            VARCHAR2(30);
   ptr_                        NUMBER;
   name_                       VARCHAR2(30);
   value_                      VARCHAR2(32000);
   cost_detail_id_             NUMBER;
BEGIN
    WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
       CASE name_
       WHEN ('ACCOUNT_NO') THEN
          account_no_ := value_; 
       WHEN ('CODE_B') THEN
          code_b_ := value_; 
       WHEN ('CODE_C') THEN
          code_c_ := value_; 
       WHEN ('CODE_D') THEN
          code_d_ := value_; 
       WHEN ('CODE_E') THEN
          code_e_ := value_; 
       WHEN ('CODE_F') THEN
          code_f_ := value_; 
       WHEN ('CODE_G') THEN
          code_g_ := value_; 
       WHEN ('CODE_H') THEN
          code_h_ := value_; 
       WHEN ('CODE_I') THEN
          code_i_ := value_; 
       WHEN ('CODE_J') THEN
          code_j_ := value_; 
       WHEN ('TRANSFER_ACTION') THEN
          transfer_action_ := value_; 
       WHEN ('COST_DETAIL_ID') THEN
          cost_detail_id_ := value_;   
       ELSE
          Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_);
       END CASE;
    END LOOP;
    
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         transfer_rec_.contract := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PART_NO') THEN
         transfer_rec_.part_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONFIGURATION_ID') THEN
         transfer_rec_.configuration_id := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOCATION_NO') THEN
         transfer_rec_.location_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOT_BATCH_NO') THEN
         transfer_rec_.lot_batch_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SERIAL_NO') THEN
         transfer_rec_.serial_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ENG_CHG_LEVEL') THEN
         transfer_rec_.eng_chg_level := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'WAIV_DEV_REJ_NO') THEN
         transfer_rec_.waiv_dev_rej_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ACTIVITY_SEQ') THEN
         transfer_rec_.activity_seq := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         transfer_rec_.handling_unit_id := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'QTY_ON_HAND') THEN
         transfer_rec_.qty := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'CATCH_QTY_ON_HAND') THEN
         transfer_rec_.catch_qty := Client_SYS.Attr_Value_To_Number(value_arr_(n_));   
      ELSIF (name_arr_(n_) = 'PART_TRACKING_SESSION_ID') THEN
         transfer_rec_.part_tracking_session_id := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
         IF (transfer_action_ = 'TransferToRentalAsset') THEN 
            transfer_rec_.part_ownership := Part_Ownership_API.DB_COMPANY_OWNED;
         ELSE
            transfer_rec_.part_ownership := Part_Ownership_API.DB_COMPANY_RENTAL_ASSET;
         END IF;
          -- Insert to rental_asset_transfer_table
         index_:= rental_asset_transfer_tab_.COUNT+1; 
         rental_asset_transfer_tab_(index_) := transfer_rec_;
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;
   IF (rental_asset_transfer_tab_.COUNT > 0 ) THEN
      Inventory_Part_In_Stock_API.Transfer_Rental_Asset(account_no_,
                                                        code_b_,
                                                        code_c_,
                                                        code_d_,
                                                        code_e_,
                                                        code_f_,
                                                        code_g_,
                                                        code_h_,
                                                        code_i_,
                                                        code_j_,
                                                        transfer_action_,
                                                        cost_detail_id_,
                                                        rental_asset_transfer_tab_); 
    END IF;   
END Packed_Transfer_Rental_Asset__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Supp_To_Own_Stock_Allow
--   This method is used for validations of Supplier Owned Stock.
PROCEDURE Check_Supp_To_Own_Stock_Allow (
   allow_sup_to_own_stock_  OUT BOOLEAN,
   contract_                IN  VARCHAR2,
   part_no_                 IN  VARCHAR2,
   configuration_id_        IN  VARCHAR2,
   lot_batch_no_            IN  VARCHAR2,
   serial_no_               IN  VARCHAR2,
   eng_chg_level_           IN  VARCHAR2,
   waiv_dev_rej_no_         IN  VARCHAR2,
   activity_seq_            IN  NUMBER,
   handling_unit_id_        IN  NUMBER,
   from_location_no_        IN  VARCHAR2,
   to_location_no_          IN  VARCHAR2 )
IS
   message_                 VARCHAR2(500);
   has_single_ownership_    VARCHAR2(10);
   to_part_loc_             Inventory_Part_In_Stock_API.Public_Rec;
   from_part_loc_           Inventory_Part_In_Stock_API.Public_Rec;
   to_location_type_db_     VARCHAR2(20);
BEGIN
   allow_sup_to_own_stock_ := FALSE;
   from_part_loc_ := Inventory_Part_In_Stock_API.Get(contract_,
                                                     part_no_,
                                                     configuration_id_,
                                                     from_location_no_,
                                                     lot_batch_no_,
                                                     serial_no_,
                                                     eng_chg_level_,
                                                     waiv_dev_rej_no_,
                                                     activity_seq_,
                                                     handling_unit_id_);

   to_part_loc_ := Inventory_Part_In_Stock_API.Get(contract_,
                                                   part_no_,
                                                   configuration_id_,
                                                   to_location_no_,
                                                   lot_batch_no_,
                                                   serial_no_,
                                                   eng_chg_level_,
                                                   waiv_dev_rej_no_,
                                                   activity_seq_,
                                                   handling_unit_id_);
   IF (to_part_loc_.location_type IS NULL) THEN
      to_location_type_db_ := Inventory_Location_API.Get_Location_Type_Db(contract_, to_location_no_);
   ELSE
      to_location_type_db_ := to_part_loc_.location_type;
   END IF;
   
   IF ((from_part_loc_.part_ownership = Part_Ownership_API.DB_SUPPLIER_OWNED) AND
       (to_part_loc_.part_ownership IS NULL OR to_part_loc_.part_ownership IN (Part_Ownership_API.DB_COMPANY_OWNED, Part_Ownership_API.DB_COMPANY_RENTAL_ASSET))) THEN
      IF (Inventory_Location_API.Arrival_Or_Quality_Location(from_part_loc_.location_type) = 'TRUE') AND
         (Inventory_Location_API.Arrival_Or_Quality_Location(to_location_type_db_) = 'FALSE') THEN
         Check_Structure_Ownership__(message_,
                                     has_single_ownership_,
                                     part_no_,
                                     lot_batch_no_,
                                     serial_no_,
                                     from_part_loc_.part_ownership,
                                     NULL,
                                     from_part_loc_.owning_vendor_no,
                                     'YES');

         IF has_single_ownership_ = 'TRUE' THEN
            allow_sup_to_own_stock_ := TRUE;
         ELSE
            Error_SYS.Record_General(lu_name_,'CANNOTMOVE: :P1, Cannot make the move.', message_);
         END IF;
      END IF;
   END IF;
END Check_Supp_To_Own_Stock_Allow;



