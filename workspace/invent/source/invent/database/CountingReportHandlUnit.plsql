-----------------------------------------------------------------------------
--
--  Logical unit: CountingReportHandlUnit
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200311  DaZase  SCXTEND-3803, Small change in both Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  191212  DaZase  SCXTEND-1005, Changed the dynamic selects in methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and
--  191212          Record_With_Column_Value_Exist to increase performance. Also changed Get_Column_Value_If_Unique to have distinct select and 
--  191212          'FETCH FIRST 2 ROWS ONLY' statement and use a collection instead of having a loop to increase performance.
--  190123  LaThlk  Bug 146078(SCZ-2487), Modified Create_Data_Capture_Lov() by dynamically binding the variable last_character_ in order to be accessible when it is executed.
--  180308  LEPESE  STRSC-17479, Added package constant last_character_ and replaced usage of Database_SYS.Get_Last_Character with this new constant for increased performance.
--  171102  ChFolk  STRSC-14016, Modifed message constant VALUENOTEXIST in method Record_With_Column_Value_Exist to a different name (COLDESCVALUENOTEXIST) 
--  171102          as the same constant exists with a different description.
--  170125  Chfose  LIM-8752, Improved performance of Approval_Needed, Is_Confirmed & Is_Counted by evaluating them in the cursor.
--  161128  DaZase  LIM-9572, Added overloaded Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist methods 
--  161128          using Start_Counting_Report_Process as data source.
--  161122  DaZase  LIM-5062, Added Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist for process DataCaptCountHuReport. 
--  160629  Jhalse  LIM-7520, Changed several methods to use server based refresh of the handling unit snapshot.
--  160629                    Added new parameters to several methods to make use of the new Inventory_Event_ID concept. Removed
--  160629                    Removed Delete_Aggr_Handl_Unit_View.
--  160504  KhVese  LIM-1310, Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Lov_Value_Tab  IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;

last_character_ CONSTANT VARCHAR2(1) := Database_SYS.Get_Last_Character;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Generate_Aggr_Handl_Unit_View (
   inv_list_no_ IN VARCHAR2 )         
IS
   count_report_line_tab_  Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   CURSOR get_all_lines IS
      SELECT cr.contract, cr.part_no, cr.configuration_id, cr.location_no, 
             cr.lot_batch_no, cr.serial_no, cr.eng_chg_level, cr.waiv_dev_rej_no, cr.activity_seq, 
             cr.handling_unit_id, invp.Qty_Onhand
      FROM COUNTING_REPORT_LINE_TAB cr, INVENTORY_PART_IN_STOCK_TAB invp
      WHERE cr.inv_list_no       = inv_list_no_
      AND   cr.contract          = invp.contract
      AND   cr.part_no           = invp.part_no
      AND   cr.configuration_id  = invp.configuration_id
      AND   cr.location_no       = invp.location_no
      AND   cr.lot_batch_no      = invp.lot_batch_no
      AND   cr.serial_no         = invp.serial_no
      AND   cr.eng_chg_level     = invp.eng_chg_level
      AND   cr.waiv_dev_rej_no   = invp.waiv_dev_rej_no
      AND   cr.activity_seq      = invp.activity_seq
      AND   cr.handling_unit_id  = invp.handling_unit_id;
BEGIN
   IF(Counting_Report_Line_API.Check_Unconfirmed_Lines(inv_list_no_) =
      Fnd_Boolean_API.DB_TRUE) THEN
      -- Send empty collection to the snapshot logic in case all lines are confirmed. This will create an empty snapshot.
      -- Old snapshot records gets removed.
      OPEN get_all_lines;
      FETCH get_all_lines BULK COLLECT INTO count_report_line_tab_;
      CLOSE get_all_lines;
   END IF;
   Handl_Unit_Snapshot_Util_API.Generate_Snapshot(source_ref1_              => inv_list_no_,
                                                  source_ref_type_db_       => Handl_Unit_Snapshot_Type_API.DB_COUNTING_REPORT,
                                                  inv_part_stock_tab_       => count_report_line_tab_,
                                                  only_outermost_in_result_ => FALSE,
                                                  incl_hu_zero_in_result_   => TRUE,
                                                  incl_qty_zero_in_result_  => TRUE);
END Generate_Aggr_Handl_Unit_View;


PROCEDURE Count_Hu_Without_Diff (
   inv_list_no_   IN VARCHAR2,
   contract_      IN VARCHAR2,
   attr_          IN VARCHAR2 )         
IS
   handling_unit_id_ NUMBER;
   location_no_      VARCHAR2(35);   
   ptr_              NUMBER := NULL;
   name_                  VARCHAR2(30);
   value_                 VARCHAR2(2000);
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'LOCATION_NO') THEN
         location_no_ := value_;
         handling_unit_id_ := 0;
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         location_no_ := '';
         handling_unit_id_ := value_;
      END IF ; 
      
      Count_Hu_Without_Diff(inv_list_no_      => inv_list_no_,
                            handling_unit_id_ => handling_unit_id_,
                            contract_         => contract_,
                            location_no_      => location_no_);
   END LOOP;
END Count_Hu_Without_Diff;


PROCEDURE Count_Hu_As_Non_Existing (
   inv_list_no_   IN VARCHAR2,
   contract_      IN VARCHAR2,
   attr_          IN VARCHAR2 )         
IS
   handling_unit_id_ NUMBER;
   location_no_      VARCHAR2(35);   
   ptr_              NUMBER := NULL;
   name_                  VARCHAR2(30);
   value_                 VARCHAR2(2000);
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'LOCATION_NO') THEN
         location_no_ := value_;
         handling_unit_id_ := 0;
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         location_no_ := '';
         handling_unit_id_ := value_;
      END IF ; 
      
      Count_Hu_As_Non_Existing(inv_list_no_      => inv_list_no_,
                               handling_unit_id_ => handling_unit_id_,
                               contract_         => contract_,
                               location_no_      => location_no_);
   END LOOP;
END Count_Hu_As_Non_Existing;

PROCEDURE Confirm_Handling_Unit (
   inv_list_no_   IN VARCHAR2,
   contract_      IN VARCHAR2,
   attr_          IN VARCHAR2 )         
IS
   handling_unit_id_       NUMBER;
   location_no_            VARCHAR2(35);   
   ptr_                    NUMBER := NULL;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'LOCATION_NO') THEN
         location_no_ := value_;
         handling_unit_id_ := 0;
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         location_no_ := '';
         handling_unit_id_ := value_;
      END IF ; 
      
      Confirm_Handling_Unit(inv_list_no_        => inv_list_no_,
                            handling_unit_id_   => handling_unit_id_,
                            contract_           => contract_,
                            location_no_        => location_no_);
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Confirm_Handling_Unit;


PROCEDURE Count_Hu_As_Non_Existing (
   inv_list_no_      IN VARCHAR2,
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2 )         
IS
   CURSOR get_all_lines IS
      SELECT contract, part_no, configuration_id, location_no, 
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, 
             activity_seq, handling_unit_id, quantity, NULL, NULL, NULL, NULL
      FROM  INV_PART_STOCK_SNAPSHOT_TAB
      WHERE source_ref1 = inv_list_no_
      AND   contract = contract_
      AND   location_no = location_no_
      AND source_ref_type = Handl_Unit_Snapshot_Type_API.DB_COUNTING_REPORT;

   inv_part_stock_tab_     Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   count_report_line_rec_  Counting_Report_Line_API.Public_Rec;
   seq_no_                 Counting_Report_Line_TAB.seq%TYPE;
   last_count_date_        Counting_Report_Line_TAB.last_count_date%TYPE;
   qty_counted_            Counting_Report_Line_TAB.qty_count1%TYPE;
   is_confirmed_           VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF handling_unit_id_ != 0 THEN 
      inv_part_stock_tab_ := Handling_Unit_API.Get_Part_Stock_Onhand_Content(handling_unit_id_);
   ELSE 
      OPEN get_all_lines;
      FETCH get_all_lines BULK COLLECT INTO inv_part_stock_tab_;
      CLOSE get_all_lines;
   END IF;
   FOR i_ IN inv_part_stock_tab_.FIRST .. inv_part_stock_tab_.LAST LOOP  
      seq_no_ := Counting_Report_Line_API.Get_Seq_No(inv_list_no_       => inv_list_no_,
                                                     contract_          => inv_part_stock_tab_(i_).contract,
                                                     part_no_           => inv_part_stock_tab_(i_).part_no,
                                                     configuration_id_  => inv_part_stock_tab_(i_).configuration_id, 
                                                     location_no_       => inv_part_stock_tab_(i_).location_no,
                                                     lot_batch_no_      => inv_part_stock_tab_(i_).lot_batch_no,
                                                     serial_no_         => inv_part_stock_tab_(i_).serial_no,
                                                     eng_chg_level_     => inv_part_stock_tab_(i_).eng_chg_level,
                                                     waiv_dev_rej_no_   => inv_part_stock_tab_(i_).waiv_dev_rej_no,
                                                     activity_seq_      => inv_part_stock_tab_(i_).activity_seq,
                                                     handling_unit_id_  => inv_part_stock_tab_(i_).handling_unit_id);
      
      count_report_line_rec_ := Counting_Report_Line_API.Get(inv_list_no_ => inv_list_no_,
                                                               seq_         => seq_no_);
      last_count_date_ := count_report_line_rec_.last_count_date;
      qty_counted_ := count_report_line_rec_.qty_count1;
      
      is_confirmed_ := Counting_Result_API.Check_Exist(contract_           => inv_part_stock_tab_(i_).contract,
                                                       part_no_            => inv_part_stock_tab_(i_).part_no,
                                                       configuration_id_   => inv_part_stock_tab_(i_).configuration_id, 
                                                       location_no_        => inv_part_stock_tab_(i_).location_no,
                                                       lot_batch_no_       => inv_part_stock_tab_(i_).lot_batch_no,
                                                       serial_no_          => inv_part_stock_tab_(i_).serial_no,
                                                       eng_chg_level_      => inv_part_stock_tab_(i_).eng_chg_level,
                                                       waiv_dev_rej_no_    => inv_part_stock_tab_(i_).waiv_dev_rej_no,
                                                       activity_seq_       => inv_part_stock_tab_(i_).activity_seq,
                                                       handling_unit_id_   => inv_part_stock_tab_(i_).handling_unit_id,
                                                       count_date_         => last_count_date_);

      IF  (is_confirmed_ = Fnd_Boolean_API.DB_FALSE) AND 
          (qty_counted_ IS NULL) THEN 
         IF (Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(inv_part_stock_tab_(i_).part_no) AND 
             inv_part_stock_tab_(i_).serial_no = '*')  THEN 
            Error_SYS.Record_General(lu_name_, 'LOCSERIALTRACKEDRECISSUE: Cannot count all stocks in location :P1 to zero since part :P2 is serial tracked at receipt and issue. It can be done on detail level.',
                                     inv_part_stock_tab_(i_).location_no, inv_part_stock_tab_(i_).part_no);
         ELSE 
            Counting_Report_Line_API.Count_As_Non_Existing(inv_list_no_ => inv_list_no_,
                                                           seq_         => seq_no_);
         END IF ; 
      END IF ; 
   END LOOP;
END Count_Hu_As_Non_Existing;


PROCEDURE Count_Hu_Without_Diff (
   inv_list_no_      IN VARCHAR2,
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2 )         
IS
   CURSOR get_all_lines IS
      SELECT contract, part_no, configuration_id, location_no, 
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, 
             activity_seq, handling_unit_id, quantity, NULL, NULL, NULL, NULL
      FROM  INV_PART_STOCK_SNAPSHOT_TAB
      WHERE source_ref1 = inv_list_no_
      AND   contract = contract_
      AND   location_no = location_no_
      AND source_ref_type = Handl_Unit_Snapshot_Type_API.DB_COUNTING_REPORT;

   inv_part_stock_tab_     Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   count_report_line_rec_  Counting_Report_Line_API.Public_Rec;
   inv_part_rec_           Inventory_Part_In_Stock_API.Public_Rec;
   seq_no_                 Counting_Report_Line_TAB.seq%TYPE;
   last_count_date_        Counting_Report_Line_TAB.last_count_date%TYPE;
   qty_counted_            Counting_Report_Line_TAB.qty_count1%TYPE;
   is_confirmed_           VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF handling_unit_id_ != 0 THEN 
      inv_part_stock_tab_ := Handling_Unit_API.Get_Part_Stock_Onhand_Content(handling_unit_id_);
   ELSE 
      OPEN get_all_lines;
      FETCH get_all_lines BULK COLLECT INTO inv_part_stock_tab_;
      CLOSE get_all_lines;
   END IF;
   FOR i_ IN inv_part_stock_tab_.FIRST .. inv_part_stock_tab_.LAST LOOP 
      seq_no_ := Counting_Report_Line_API.Get_Seq_No(inv_list_no_       => inv_list_no_,
                                                     contract_          => inv_part_stock_tab_(i_).contract,
                                                     part_no_           => inv_part_stock_tab_(i_).part_no,
                                                     configuration_id_  => inv_part_stock_tab_(i_).configuration_id, 
                                                     location_no_       => inv_part_stock_tab_(i_).location_no,
                                                     lot_batch_no_      => inv_part_stock_tab_(i_).lot_batch_no,
                                                     serial_no_         => inv_part_stock_tab_(i_).serial_no,
                                                     eng_chg_level_     => inv_part_stock_tab_(i_).eng_chg_level,
                                                     waiv_dev_rej_no_   => inv_part_stock_tab_(i_).waiv_dev_rej_no,
                                                     activity_seq_      => inv_part_stock_tab_(i_).activity_seq,
                                                     handling_unit_id_  => inv_part_stock_tab_(i_).handling_unit_id);
      
      count_report_line_rec_ := Counting_Report_Line_API.Get(inv_list_no_ => inv_list_no_,
                                                               seq_         => seq_no_);
      last_count_date_ := count_report_line_rec_.last_count_date;
      qty_counted_ := count_report_line_rec_.qty_count1;
      
      is_confirmed_ := Counting_Result_API.Check_Exist(contract_           => inv_part_stock_tab_(i_).contract,
                                                       part_no_            => inv_part_stock_tab_(i_).part_no,
                                                       configuration_id_   => inv_part_stock_tab_(i_).configuration_id, 
                                                       location_no_        => inv_part_stock_tab_(i_).location_no,
                                                       lot_batch_no_       => inv_part_stock_tab_(i_).lot_batch_no,
                                                       serial_no_          => inv_part_stock_tab_(i_).serial_no,
                                                       eng_chg_level_      => inv_part_stock_tab_(i_).eng_chg_level,
                                                       waiv_dev_rej_no_    => inv_part_stock_tab_(i_).waiv_dev_rej_no,
                                                       activity_seq_       => inv_part_stock_tab_(i_).activity_seq,
                                                       handling_unit_id_   => inv_part_stock_tab_(i_).handling_unit_id,
                                                       count_date_         => last_count_date_);

      IF  (is_confirmed_ = Fnd_Boolean_API.DB_FALSE) AND 
          (qty_counted_ IS NULL) THEN 
         inv_part_rec_ := Inventory_Part_In_Stock_API.Get(contract_           => inv_part_stock_tab_(i_).contract,
                                                          part_no_            => inv_part_stock_tab_(i_).part_no,
                                                          configuration_id_   => inv_part_stock_tab_(i_).configuration_id,
                                                          location_no_        => inv_part_stock_tab_(i_).location_no,
                                                          lot_batch_no_       => inv_part_stock_tab_(i_).lot_batch_no,
                                                          serial_no_          => inv_part_stock_tab_(i_).serial_no,
                                                          eng_chg_level_      => inv_part_stock_tab_(i_).eng_chg_level,
                                                          waiv_dev_rej_no_    => inv_part_stock_tab_(i_).waiv_dev_rej_no,
                                                          activity_seq_       => inv_part_stock_tab_(i_).activity_seq,
                                                          handling_unit_id_   => inv_part_stock_tab_(i_).handling_unit_id );
         Counting_Report_Line_API.Count_Line_Without_Diff(inv_list_no_        => inv_list_no_,
                                                          seq_                => seq_no_,
                                                          qty_count1_         => inv_part_rec_.qty_onhand,
                                                          catch_qty_counted_  => inv_part_rec_.catch_qty_onhand);
      END IF ; 
   END LOOP;
END Count_Hu_Without_Diff;


PROCEDURE Confirm_Handling_Unit (
   inv_list_no_         IN VARCHAR2,
   handling_unit_id_    IN NUMBER,
   contract_            IN VARCHAR2,
   location_no_         IN VARCHAR2)         
IS
   CURSOR get_all_lines IS
      SELECT contract, part_no, configuration_id, location_no, 
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, 
             activity_seq, handling_unit_id, quantity, NULL, NULL, NULL, NULL
      FROM  INV_PART_STOCK_SNAPSHOT_TAB
      WHERE source_ref1 = inv_list_no_
      AND   contract = contract_
      AND   location_no = location_no_
      AND source_ref_type = Handl_Unit_Snapshot_Type_API.DB_COUNTING_REPORT;

   inv_part_stock_tab_        Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   count_report_line_rec_     Counting_Report_Line_API.Public_Rec;
   seq_no_                    Counting_Report_Line_TAB.seq%TYPE;
   last_count_date_           Counting_Report_Line_TAB.last_count_date%TYPE;
   qty_counted_               Counting_Report_Line_TAB.qty_count1%TYPE;
   is_confirmed_              VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF handling_unit_id_ != 0 THEN 
      inv_part_stock_tab_ := Handling_Unit_API.Get_Part_Stock_Onhand_Content(handling_unit_id_);
   ELSE 
      OPEN get_all_lines;
      FETCH get_all_lines BULK COLLECT INTO inv_part_stock_tab_;
      CLOSE get_all_lines;
   END IF;
   
   Inventory_Event_Manager_API.Start_Session;
   FOR i_ IN inv_part_stock_tab_.FIRST .. inv_part_stock_tab_.LAST LOOP  
      seq_no_ := Counting_Report_Line_API.Get_Seq_No(inv_list_no_       => inv_list_no_,
                                                     contract_          => inv_part_stock_tab_(i_).contract,
                                                     part_no_           => inv_part_stock_tab_(i_).part_no,
                                                     configuration_id_  => inv_part_stock_tab_(i_).configuration_id, 
                                                     location_no_       => inv_part_stock_tab_(i_).location_no,
                                                     lot_batch_no_      => inv_part_stock_tab_(i_).lot_batch_no,
                                                     serial_no_         => inv_part_stock_tab_(i_).serial_no,
                                                     eng_chg_level_     => inv_part_stock_tab_(i_).eng_chg_level,
                                                     waiv_dev_rej_no_   => inv_part_stock_tab_(i_).waiv_dev_rej_no,
                                                     activity_seq_      => inv_part_stock_tab_(i_).activity_seq,
                                                     handling_unit_id_  => inv_part_stock_tab_(i_).handling_unit_id);
      
      count_report_line_rec_ := Counting_Report_Line_API.Get(inv_list_no_ => inv_list_no_,
                                                               seq_         => seq_no_);
      last_count_date_ := count_report_line_rec_.last_count_date;
      qty_counted_ := count_report_line_rec_.qty_count1;
      
      is_confirmed_ := Counting_Result_API.Check_Exist(contract_           => inv_part_stock_tab_(i_).contract,
                                                       part_no_            => inv_part_stock_tab_(i_).part_no,
                                                       configuration_id_   => inv_part_stock_tab_(i_).configuration_id, 
                                                       location_no_        => inv_part_stock_tab_(i_).location_no,
                                                       lot_batch_no_       => inv_part_stock_tab_(i_).lot_batch_no,
                                                       serial_no_          => inv_part_stock_tab_(i_).serial_no,
                                                       eng_chg_level_      => inv_part_stock_tab_(i_).eng_chg_level,
                                                       waiv_dev_rej_no_    => inv_part_stock_tab_(i_).waiv_dev_rej_no,
                                                       activity_seq_       => inv_part_stock_tab_(i_).activity_seq,
                                                       handling_unit_id_   => inv_part_stock_tab_(i_).handling_unit_id,
                                                       count_date_         => last_count_date_);
                                                       
      IF (qty_counted_ IS NOT NULL AND (is_confirmed_ = Fnd_Boolean_API.DB_FALSE)) THEN  
         Counting_Report_Line_API.Confirm_Line(inv_list_no_          => inv_list_no_,
                                               seq_                  => seq_no_);
      END IF ; 
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Confirm_Handling_Unit;


@UncheckedAccess
FUNCTION Approval_Needed (
   inv_list_no_      IN VARCHAR2,
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2) RETURN VARCHAR2         
IS
   CURSOR get_inv_part_sanpshot_lines IS
      SELECT DISTINCT Counting_Result_API.Check_Approval_Needed(contract_           => ipss.contract,
                                                                part_no_            => ipss.part_no,
                                                                configuration_id_   => ipss.configuration_id, 
                                                                qty_counted_        => Counting_Report_Line_API.Get_Qty_Counted(
                                                                                            inv_list_no_       => inv_list_no_,
                                                                                            contract_          => ipss.contract,
                                                                                            part_no_           => ipss.part_no,
                                                                                            configuration_id_  => ipss.configuration_id, 
                                                                                            location_no_       => ipss.location_no,
                                                                                            lot_batch_no_      => ipss.lot_batch_no,
                                                                                            serial_no_         => ipss.serial_no,
                                                                                            eng_chg_level_     => ipss.eng_chg_level,
                                                                                            waiv_dev_rej_no_   => ipss.waiv_dev_rej_no,
                                                                                            activity_seq_      => ipss.activity_seq,
                                                                                            handling_unit_id_  => ipss.handling_unit_id), 
                                                                qty_onhand_         => ipis.qty_onhand,
                                                                part_ownership_db_  => ipis.part_ownership)
      FROM INV_PART_STOCK_SNAPSHOT_TAB ipss, INVENTORY_PART_IN_STOCK_TAB ipis
      WHERE ipss.source_ref1        = inv_list_no_
      AND   ipss.contract           = contract_
      AND   ipss.location_no        = location_no_
      AND   ipss.source_ref_type    = Handl_Unit_Snapshot_Type_API.DB_COUNTING_REPORT
      AND 	ipss.contract           = ipis.contract
      AND 	ipss.part_no            = ipis.part_no
      AND 	ipss.configuration_id   = ipis.configuration_id
      AND   ipss.location_no        = ipis.location_no
      AND   ipss.lot_batch_no       = ipis.lot_batch_no
      AND   ipss.serial_no          = ipis.serial_no
      AND   ipss.eng_chg_level      = ipis.eng_chg_level
      AND   ipss.waiv_dev_rej_no    = ipis.waiv_dev_rej_no
      AND   ipss.activity_seq       = ipis.activity_seq
      AND   ipss.handling_unit_id   = ipis.handling_unit_id;

   CURSOR get_counting_report_lines IS
      SELECT DISTINCT Counting_Result_API.Check_Approval_Needed(contract_           => crl.contract,
                                                                part_no_            => crl.part_no,
                                                                configuration_id_   => crl.configuration_id, 
                                                                qty_counted_        => crl.qty_count1, 
                                                                qty_onhand_         => ipis.qty_onhand,
                                                                part_ownership_db_  => ipis.part_ownership)
      FROM   COUNTING_REPORT_LINE_TAB crl, INVENTORY_PART_IN_STOCK_TAB ipis
      WHERE  crl.inv_list_no       = inv_list_no_
      AND    crl.handling_unit_id IN (SELECT           hu.handling_unit_id
                                      FROM             handling_unit_tab hu
                                      CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                      START WITH       hu.handling_unit_id = handling_unit_id_)
      AND crl.contract           = ipis.contract
      AND crl.part_no            = ipis.part_no
      AND crl.configuration_id   = ipis.configuration_id
      AND crl.location_no        = ipis.location_no
      AND crl.lot_batch_no       = ipis.lot_batch_no
      AND crl.serial_no          = ipis.serial_no
      AND crl.eng_chg_level      = ipis.eng_chg_level
      AND crl.waiv_dev_rej_no    = ipis.waiv_dev_rej_no
      AND crl.activity_seq       = ipis.activity_seq
      AND crl.handling_unit_id   = ipis.handling_unit_id;
      
   TYPE Approval_Needed_Tab   IS TABLE OF VARCHAR2(5) INDEX BY PLS_INTEGER;
   approval_needed_tab_       Approval_Needed_Tab;
   approval_needed_           VARCHAR2(5);
BEGIN
   IF handling_unit_id_ != 0 THEN 
      OPEN get_counting_report_lines;
      FETCH get_counting_report_lines BULK COLLECT INTO approval_needed_tab_;
      CLOSE get_counting_report_lines;
   ELSE 
      OPEN get_inv_part_sanpshot_lines;
      FETCH get_inv_part_sanpshot_lines BULK COLLECT INTO approval_needed_tab_;
      CLOSE get_inv_part_sanpshot_lines;
   END IF;
   
   IF (approval_needed_tab_.COUNT = 1) THEN
      approval_needed_ := approval_needed_tab_(1);
   ELSIF (approval_needed_tab_.COUNT > 1) THEN
      approval_needed_ := 'TRUE';
   END IF;
   
   RETURN approval_needed_;
END Approval_Needed;


@UncheckedAccess
FUNCTION Is_Confirmed (
   inv_list_no_      IN VARCHAR2,
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2) RETURN VARCHAR2         
IS
   CURSOR get_inv_part_sanpshot_lines IS
      SELECT DISTINCT Counting_Result_API.Check_Exist(contract_           => contract,
                                                      part_no_            => part_no,
                                                      configuration_id_   => configuration_id, 
                                                      location_no_        => location_no,
                                                      lot_batch_no_       => lot_batch_no,
                                                      serial_no_          => serial_no,
                                                      eng_chg_level_      => eng_chg_level,
                                                      waiv_dev_rej_no_    => waiv_dev_rej_no,
                                                      activity_seq_       => activity_seq,
                                                      handling_unit_id_   => handling_unit_id,
                                                      count_date_         => Counting_Report_Line_API.Get_Last_Count_Date(
                                                                                   inv_list_no_       => inv_list_no_,
                                                                                   contract_          => contract,
                                                                                   part_no_           => part_no,
                                                                                   configuration_id_  => configuration_id, 
                                                                                   location_no_       => location_no,
                                                                                   lot_batch_no_      => lot_batch_no,
                                                                                   serial_no_         => serial_no,
                                                                                   eng_chg_level_     => eng_chg_level,
                                                                                   waiv_dev_rej_no_   => waiv_dev_rej_no,
                                                                                   activity_seq_      => activity_seq,
                                                                                   handling_unit_id_  => handling_unit_id))
      FROM   INV_PART_STOCK_SNAPSHOT_TAB
      WHERE  source_ref1      = inv_list_no_
      AND    contract         = contract_
      AND    location_no      = location_no_
      AND    source_ref_type  = Handl_Unit_Snapshot_Type_API.DB_COUNTING_REPORT;

   CURSOR get_counting_report_lines IS
      SELECT DISTINCT Counting_Result_API.Check_Exist(contract_           => contract,
                                                      part_no_            => part_no,
                                                      configuration_id_   => configuration_id, 
                                                      location_no_        => location_no,
                                                      lot_batch_no_       => lot_batch_no,
                                                      serial_no_          => serial_no,
                                                      eng_chg_level_      => eng_chg_level,
                                                      waiv_dev_rej_no_    => waiv_dev_rej_no,
                                                      activity_seq_       => activity_seq,
                                                      handling_unit_id_   => handling_unit_id,
                                                      count_date_         => last_count_date)
      FROM   COUNTING_REPORT_LINE_TAB
      WHERE  inv_list_no       = inv_list_no_
      AND    handling_unit_id IN (SELECT           hu.handling_unit_id
                                  FROM             handling_unit_tab hu
                                  CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                  START WITH       hu.handling_unit_id = handling_unit_id_);

   TYPE Is_Confirmed_Tab   IS TABLE OF VARCHAR2(5) INDEX BY PLS_INTEGER;
   is_confirmed_tab_       Is_Confirmed_Tab;
   is_confirmed_           VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

BEGIN
   IF handling_unit_id_ != 0 THEN 
      OPEN get_counting_report_lines;
      FETCH get_counting_report_lines BULK COLLECT INTO is_confirmed_tab_;
      CLOSE get_counting_report_lines;
   ELSE 
      OPEN get_inv_part_sanpshot_lines;
      FETCH get_inv_part_sanpshot_lines BULK COLLECT INTO is_confirmed_tab_;
      CLOSE get_inv_part_sanpshot_lines;
   END IF;
   
   IF (is_confirmed_tab_.COUNT = 1) THEN
      is_confirmed_ := is_confirmed_tab_(1);
   ELSIF (is_confirmed_tab_.COUNT > 1) THEN
      is_confirmed_ := 'FALSE';
   END IF;
   
   RETURN is_confirmed_;
END Is_Confirmed;


@UncheckedAccess
FUNCTION Is_Counted (
   inv_list_no_      IN VARCHAR2,
   handling_unit_id_ IN NUMBER,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2) RETURN VARCHAR2         
IS
   CURSOR get_inv_part_sanpshot_lines IS
      SELECT SUM(Counting_Report_Line_API.Get_Qty_Counted(inv_list_no_       => inv_list_no_,
                                                          contract_          => contract,
                                                          part_no_           => part_no,
                                                          configuration_id_  => configuration_id, 
                                                          location_no_       => location_no,
                                                          lot_batch_no_      => lot_batch_no,
                                                          serial_no_         => serial_no,
                                                          eng_chg_level_     => eng_chg_level,
                                                          waiv_dev_rej_no_   => waiv_dev_rej_no,
                                                          activity_seq_      => activity_seq,
                                                          handling_unit_id_  => handling_unit_id))
      FROM   INV_PART_STOCK_SNAPSHOT_TAB
      WHERE  source_ref1      = inv_list_no_
      AND    contract         = contract_
      AND    location_no      = location_no_
      AND    source_ref_type  = Handl_Unit_Snapshot_Type_API.DB_COUNTING_REPORT;

   CURSOR get_counting_report_lines IS
      SELECT SUM(qty_count1)
      FROM   COUNTING_REPORT_LINE_TAB
      WHERE  inv_list_no       = inv_list_no_
      AND    handling_unit_id IN (SELECT           hu.handling_unit_id
                                  FROM             handling_unit_tab hu
                                  CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                  START WITH       hu.handling_unit_id = handling_unit_id_);

   qty_counted_         counting_report_line_tab.qty_count1%TYPE;

BEGIN
   IF handling_unit_id_ != 0 THEN 
      OPEN get_counting_report_lines;
      FETCH get_counting_report_lines INTO qty_counted_;
      CLOSE get_counting_report_lines;
   ELSE 
      OPEN get_inv_part_sanpshot_lines;
      FETCH get_inv_part_sanpshot_lines INTO qty_counted_;
      CLOSE get_inv_part_sanpshot_lines;
   END IF;
   
   IF qty_counted_ IS NOT NULL THEN 
      RETURN Fnd_Boolean_API.DB_TRUE;
   ELSE 
      RETURN Fnd_Boolean_API.DB_FALSE;
   END IF ; 
END Is_Counted;


-- This method is used by DataCaptCountHuReport 
@ServerOnlyAccess 
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   inv_list_no_                IN VARCHAR2,
   aggregated_line_id_         IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL)
IS
   TYPE Get_Lov_Values           IS REF CURSOR;
   get_lov_values_               Get_Lov_Values;
   stmt_                         VARCHAR2(4000);
   lov_value_tab_                Lov_Value_Tab;
   tmp_location_no_              VARCHAR2(35);
   lov_item_description_         VARCHAR2(200);
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   aggr_line_id_in_a_loop_       BOOLEAN := FALSE;
   lov_row_limitation_           NUMBER;
   exit_lov_                     BOOLEAN := FALSE;
   temp_handling_unit_id_        NUMBER;
   temp_sscc_                    VARCHAR2(18);
   temp_alt_handl_unit_label_id_ VARCHAR2(25);

BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_View_Column('COUNTING_REPORT_HU_PROCESS', column_name_);

      stmt_ := 'SELECT ' || column_name_;
      stmt_ := stmt_  || ' FROM COUNTING_REPORT_HU_PROCESS
                           WHERE contract = :contract_';
      IF inv_list_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :inv_list_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND inv_list_no = :inv_list_no_';
      END IF;
      IF aggregated_line_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :aggregated_line_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND aggregated_line_id = :aggregated_line_id_';
      END IF;
      IF location_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :location_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND location_no = :location_no_';
      END IF;
      IF handling_unit_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
      END IF;
      IF sscc_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
      ELSIF sscc_ = '%' THEN
         stmt_ := stmt_ || ' AND :sscc_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND sscc = :sscc_';
      END IF;
      IF alt_handling_unit_label_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
      ELSIF alt_handling_unit_label_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
      END IF;

      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || ' AND ' || sql_where_expression_;
      END IF;


      -- Add extra filtering of earlier scanned values of this data item to dynamic cursor if data item is AGGREGATED_LINE_ID and is in a loop for this configuration
      IF (column_name_ = 'AGGREGATED_LINE_ID') THEN
         IF (Data_Capt_Conf_Data_Item_API.Is_Data_Item_In_A_Loop(session_rec_.capture_process_id, session_rec_.capture_config_id, column_name_)) THEN
            stmt_ := stmt_  || ' AND NOT EXISTS (SELECT 1 FROM DATA_CAPTURE_SESSION_LINE_PUB WHERE capture_session_id = :capture_session_id_
                                                                                              AND  data_item_id = ''AGGREGATED_LINE_ID''
                                                                                              AND  data_item_detail_id IS NULL
                                                                                              AND  data_item_value = ROWIDTOCHAR(aggregated_line_id)) ';   
            aggr_line_id_in_a_loop_ := TRUE;
         END IF;
      END IF;
      -- TODO: We might have issues if it is a large hu structure with several levels, those will not be consumed here with this solution,
      -- there is similar problem with the other 2 hu processes, we turned off fake consumation for transport task hu due to this and other issues.
      -- Not sure that we can support fake consumation for large hu structures, needs investigation if we get issues with this.

      --stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(' || column_name_ || ') ASC, ' || column_name_ || ' ASC';

      -- Add the general route order sorting 
      -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes 
      -- since this needs be exactly same order as the IEE client (frmInvCountHandlingUnit).
      stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(warehouse_route_order) ASC, 
                                    UPPER(warehouse_route_order) ASC,
                                    Utility_SYS.String_To_Number(bay_route_order) ASC, 
                                    UPPER(decode(bay_route_order, ''  -'', :last_character, bay_route_order)) ASC, 
                                    Utility_SYS.String_To_Number(row_route_order) ASC, 
                                    UPPER(decode(row_route_order, ''  -'', :last_character, row_route_order)) ASC,
                                    Utility_SYS.String_To_Number(tier_route_order) ASC, 
                                    UPPER(decode(tier_route_order, ''  -'', :last_character, tier_route_order)) ASC, 
                                    Utility_SYS.String_To_Number(bin_route_order) ASC, 
                                    UPPER(decode(bin_route_order, ''  -'', :last_character, bin_route_order)) ASC,
                                    location_no,
                                    NVL(top_parent_handling_unit_id, handling_unit_id),
                                    structure_level,
                                    handling_unit_id ';


      IF (aggr_line_id_in_a_loop_) THEN
         @ApproveDynamicStatement(2019-01-24,LATHLK)
         OPEN get_lov_values_ FOR stmt_ USING contract_,
                                              inv_list_no_,
                                              aggregated_line_id_,
                                              location_no_,
                                              handling_unit_id_,
                                              sscc_,
                                              alt_handling_unit_label_id_,
                                              capture_session_id_,
                                              last_character_,
                                              last_character_,
                                              last_character_,
                                              last_character_;
      ELSE
         @ApproveDynamicStatement(2019-01-24,LATHLK)
         OPEN get_lov_values_ FOR stmt_ USING contract_,
                                              inv_list_no_,
                                              aggregated_line_id_,
                                              location_no_,
                                              handling_unit_id_,
                                              sscc_,
                                              alt_handling_unit_label_id_,
                                              last_character_,
                                              last_character_,
                                              last_character_,
                                              last_character_;
      END IF;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;


      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK 
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              

               IF (column_name_ = 'AGGREGATED_LINE_ID') THEN
                  IF (session_rec_.capture_process_id = 'COUNT_HANDL_UNIT_COUNT_REPORT') THEN -- just in case some other process starts using this LOV since they dont have these details probably
                     IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_HANDLING_UNIT_ID'))) THEN
                        temp_handling_unit_id_ := Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                             inv_list_no_                => inv_list_no_,
                                                                             aggregated_line_id_         => lov_value_tab_(i),
                                                                             location_no_                => location_no_,
                                                                             handling_unit_id_           => handling_unit_id_,
                                                                             sscc_                       => sscc_,
                                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                             column_name_                => 'HANDLING_UNIT_ID');
                     END IF;
                     IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_SSCC'))) THEN
                        temp_sscc_ := Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                 inv_list_no_                => inv_list_no_,
                                                                 aggregated_line_id_         => lov_value_tab_(i),
                                                                 location_no_                => location_no_,
                                                                 handling_unit_id_           => handling_unit_id_,
                                                                 sscc_                       => sscc_,
                                                                 alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                 column_name_                => 'SSCC');
                     END IF;
                     IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_ALT_HANDLING_UNIT_LABEL_ID'))) THEN
                        temp_alt_handl_unit_label_id_ := Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                                    inv_list_no_                => inv_list_no_,
                                                                                    aggregated_line_id_         => lov_value_tab_(i),
                                                                                    location_no_                => location_no_,
                                                                                    handling_unit_id_           => handling_unit_id_,
                                                                                    sscc_                       => sscc_,
                                                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                    column_name_                => 'ALT_HANDLING_UNIT_LABEL_ID');
                     END IF;
                     tmp_location_no_ := Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                    inv_list_no_                => inv_list_no_,
                                                                    aggregated_line_id_         => lov_value_tab_(i),
                                                                    location_no_                => location_no_,
                                                                    handling_unit_id_           => handling_unit_id_,
                                                                    sscc_                       => sscc_,
                                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                    column_name_                => 'LOCATION_NO');


                     lov_item_description_ := tmp_location_no_; 
                     IF (temp_handling_unit_id_ IS NOT NULL) THEN
                        lov_item_description_ := lov_item_description_ || ' | ' || temp_handling_unit_id_; 
                     END IF;
                     IF (temp_sscc_ IS NOT NULL AND temp_sscc_ != 'NULL') THEN
                        lov_item_description_ := lov_item_description_ || ' | ' || temp_sscc_; 
                     END IF;
                     IF (temp_alt_handl_unit_label_id_ IS NOT NULL AND temp_alt_handl_unit_label_id_ != 'NULL') THEN
                        lov_item_description_ := lov_item_description_ || ' | ' || temp_alt_handl_unit_label_id_; 
                     END IF;
                  END IF;
               ELSIF (column_name_ = 'LOCATION_NO') THEN
                  lov_item_description_ :=  Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
               ELSIF (column_name_ IN ('HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN
                  IF (column_name_ = 'HANDLING_UNIT_ID') THEN
                     temp_handling_unit_id_ := lov_value_tab_(i);
                  ELSIF (column_name_ = 'SSCC') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                  ELSIF (column_name_ = 'ALT_HANDLING_UNIT_LABEL_ID') THEN  
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                     IF (temp_handling_unit_id_ IS NULL) THEN
                        temp_handling_unit_id_ := Get_Column_Value_If_Unique(contract_                   => contract_,
                                                                             inv_list_no_                => inv_list_no_,
                                                                             aggregated_line_id_         => aggregated_line_id_,
                                                                             location_no_                => location_no_,
                                                                             handling_unit_id_           => handling_unit_id_,
                                                                             sscc_                       => sscc_,
                                                                             alt_handling_unit_label_id_ => lov_value_tab_(i),
                                                                             column_name_                => 'HANDLING_UNIT_ID',
                                                                             sql_where_expression_       => sql_where_expression_);
                     END IF;
                  END IF;
                  lov_item_description_ := Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(temp_handling_unit_id_));
               END IF;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


-- This method is used by DataCaptCountHuReport 
@ServerOnlyAccess 
FUNCTION Get_Column_Value_If_Unique (
   contract_                   IN VARCHAR2,
   inv_list_no_                IN VARCHAR2,
   aggregated_line_id_         IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;                 
   get_column_values_    Get_Column_Value;     
   stmt_                 VARCHAR2(2000);
   unique_column_value_  VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab; 
BEGIN

   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('COUNTING_REPORT_HU_PROCESS', column_name_);

   stmt_ := 'SELECT DISTINCT ' || column_name_ || ' 
             FROM COUNTING_REPORT_HU_PROCESS
             WHERE contract = :contract_ ';
   IF inv_list_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :inv_list_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND inv_list_no = :inv_list_no_';
   END IF;
   IF aggregated_line_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :aggregated_line_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND aggregated_line_id = :aggregated_line_id_';
   END IF;
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
   END IF;
   IF sscc_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
   ELSIF sscc_ = '%' THEN
      stmt_ := stmt_ || ' AND :sscc_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND sscc = :sscc_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;

   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';
             
   @ApproveDynamicStatement(2016-11-15,DAZASE)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           inv_list_no_,
                                           aggregated_line_id_,
                                           location_no_,
                                           handling_unit_id_,
                                           sscc_,
                                           alt_handling_unit_label_id_;
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
   END IF; 
   CLOSE get_column_values_;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptCountHuReport 
@ServerOnlyAccess 
PROCEDURE Record_With_Column_Value_Exist (
   contract_                   IN VARCHAR2,
   inv_list_no_                IN VARCHAR2,
   aggregated_line_id_         IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL) 
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(2000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('COUNTING_REPORT_HU_PROCESS', column_name_);

   stmt_ := 'SELECT 1 
             FROM COUNTING_REPORT_HU_PROCESS
             WHERE contract = :contract_ ';
   IF inv_list_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :inv_list_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND inv_list_no = :inv_list_no_';
   END IF;
   IF aggregated_line_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :aggregated_line_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND aggregated_line_id = :aggregated_line_id_';
   END IF;
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
   END IF;
   IF sscc_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
   ELSIF sscc_ = '%' THEN
      stmt_ := stmt_ || ' AND :sscc_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND sscc = :sscc_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;

   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';

   @ApproveDynamicStatement(2016-11-15,DAZASE)
   OPEN exist_control_ FOR stmt_ USING contract_,
                                       inv_list_no_,
                                       aggregated_line_id_,
                                       location_no_,
                                       handling_unit_id_,
                                       sscc_,
                                       alt_handling_unit_label_id_,
                                       column_value_,
                                       column_value_;


   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: The value :P1 does not exist on Count Report No :P2.', column_value_, inv_list_no_);
   END IF;
END Record_With_Column_Value_Exist;


-- This method is used by DataCapStartCountRep 
@ServerOnlyAccess 
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   inv_list_no_                IN VARCHAR2,
   location_no_                IN VARCHAR2,
   count_report_level_db_      IN VARCHAR2,
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL)
IS
   TYPE Get_Lov_Values     IS REF CURSOR;
   get_lov_values_         Get_Lov_Values;
   stmt_                   VARCHAR2(4000);
   TYPE Lov_Value_Tab      IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_          Lov_Value_Tab;
   lov_item_description_   VARCHAR2(200);
   session_rec_            Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_     NUMBER;
   exit_lov_               BOOLEAN := FALSE;
   temp_lov_item_value_    VARCHAR2(200);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_View_Column('START_COUNTING_REPORT_PROCESS', column_name_);

      stmt_ := 'SELECT ' || column_name_;
      stmt_ := stmt_  || ' FROM START_COUNTING_REPORT_PROCESS
                           WHERE contract = :contract_ ';
      IF inv_list_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :inv_list_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND inv_list_no = :inv_list_no_';
      END IF;
      IF location_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :location_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND location_no = :location_no_';
      END IF;
      IF count_report_level_db_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :count_report_level_db_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND part_or_handling_unit = :count_report_level_db_';
      END IF;

      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || ' AND ' || sql_where_expression_;
      END IF;
      
      -- Add the general route order sorting 
      -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes 
      -- since this needs be route order sorted.
      stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(warehouse_route_order) ASC, 
                                    UPPER(warehouse_route_order) ASC,
                                    Utility_SYS.String_To_Number(bay_route_order) ASC, 
                                    UPPER(decode(bay_route_order, ''  -'', :last_character, bay_route_order)) ASC, 
                                    Utility_SYS.String_To_Number(row_route_order) ASC, 
                                    UPPER(decode(row_route_order, ''  -'', :last_character, row_route_order)) ASC,
                                    Utility_SYS.String_To_Number(tier_route_order) ASC, 
                                    UPPER(decode(tier_route_order, ''  -'', :last_character, tier_route_order)) ASC, 
                                    Utility_SYS.String_To_Number(bin_route_order) ASC, 
                                    UPPER(decode(bin_route_order, ''  -'', :last_character, bin_route_order)) ASC,
                                    location_no, 
                                    handling_unit_id ';
      -- Having handling_unit_id after location_no makes sure that we always get non handling unit lines handle before handling unit lines on each location

      --stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(' || column_name_ || ') ASC, ' || column_name_ || ' ASC';
      
      @ApproveDynamicStatement(2019-01-24,LATHLK)
      OPEN get_lov_values_ FOR stmt_ USING contract_,
                                           inv_list_no_,
                                           location_no_,
                                           count_report_level_db_,
                                           last_character_,
                                           last_character_,
                                           last_character_,
                                           last_character_;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK 
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (column_name_ = 'LOCATION_NO') THEN
                  lov_item_description_ :=  Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
               END IF;
            END IF;
            IF (column_name_ = 'PART_OR_HANDLING_UNIT') THEN
               temp_lov_item_value_ :=  Part_Or_Handl_Unit_Level_API.Decode(lov_value_tab_(i));
            ELSE
               temp_lov_item_value_ :=  lov_value_tab_(i);
            END IF;

            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => temp_lov_item_value_,
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


-- This method is used by DataCapStartCountRep 
@ServerOnlyAccess 
FUNCTION Get_Column_Value_If_Unique (
   contract_                   IN VARCHAR2,
   inv_list_no_                IN VARCHAR2,
   location_no_                IN VARCHAR2,
   count_report_level_db_      IN VARCHAR2,
   column_name_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;                 
   get_column_values_    Get_Column_Value;     
   stmt_                 VARCHAR2(2000);
   unique_column_value_  VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab; 
BEGIN

   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('START_COUNTING_REPORT_PROCESS', column_name_);

   stmt_ := 'SELECT DISTINCT ' || column_name_ || ' 
             FROM START_COUNTING_REPORT_PROCESS
             WHERE contract = :contract_ ';

   IF inv_list_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :inv_list_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND inv_list_no = :inv_list_no_';
   END IF;
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;
   IF count_report_level_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :count_report_level_db_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_or_handling_unit = :count_report_level_db_';
   END IF;
             
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';
             
   @ApproveDynamicStatement(2016-11-15,DAZASE)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           inv_list_no_,
                                           location_no_,
                                           count_report_level_db_;

   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
   END IF; 
   CLOSE get_column_values_;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCapStartCountRep 
@ServerOnlyAccess 
PROCEDURE Record_With_Column_Value_Exist (
   contract_                   IN VARCHAR2,
   inv_list_no_                IN VARCHAR2,
   location_no_                IN VARCHAR2,
   count_report_level_db_      IN VARCHAR2,
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   column_description_         IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL) 
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(2000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('START_COUNTING_REPORT_PROCESS', column_name_);

   stmt_ := 'SELECT 1 
             FROM START_COUNTING_REPORT_PROCESS
             WHERE contract = :contract_ ';
   IF inv_list_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :inv_list_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND inv_list_no = :inv_list_no_';
   END IF;
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;
   IF count_report_level_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :count_report_level_db_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_or_handling_unit = :count_report_level_db_';
   END IF;

   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';

   @ApproveDynamicStatement(2016-11-15,DAZASE)
   OPEN exist_control_ FOR stmt_ USING contract_,
                                       inv_list_no_,
                                       location_no_,
                                       count_report_level_db_,
                                       column_value_,
                                       column_value_;


   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Error_SYS.Record_General(lu_name_, 'COLDESCVALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
   END IF;
END Record_With_Column_Value_Exist;

