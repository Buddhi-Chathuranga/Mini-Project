-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartBarcode
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210422  DaZase  Bug 159018 (SCZ-14495), Changed parameter_attr_ size to 2100 in Print() to avoid rare string buffer issue.
--  210125  SBalLK  Issue SC2020R1-11830, Modified methods with Client_SYS.Add/Set_To_Attr() by removing attr_ functionality to optimize the performance.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  191213  DaZase  SCXTEND-1005, Changed the dynamic selects in methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and
--  191213          Record_With_Column_Value_Exist to increase performance. Also changed Get_Column_Value_If_Unique to have distinct select and 
--  191213          'FETCH FIRST 2 ROWS ONLY' statement and use a collection instead of having a loop to increase performance.
--  190807  ShPrlk  Bug 148810(SCZ-5505), Modified Print() to add value for 'OPTIONS' to the print_job_attr_ to avoid error.
--  181010  SBalLK  Bug 144422, Added Change_Eng_Chg_Level() method to update eng_chg_level when receive part form internal order transit with different eng_chg_level.
--  161111  PrYaLK  Bug 132558, Modified Create_And_Print() and Print() methods by adding contract as a parameter to handle the barcode printing logic.
--  160902  UdGnlk  LIM-8289, Modified Change_Waiv_Dev_Rej_No() by adding CONTRACT as the parameter.  
--  160705  ChFolk  STRSC-2730, Modified New_From_Reserved_Lots_Serials to replace the usage of Serial_No_Reservation_API.Reserved_Serial_Table from Part_Serial_Catalog_API.Serial_No_Tab.
--  160531  SWiclk  Bug 129539, Modified Create_And_Print() to print barcodes as batches because otherwise it would exceed 
--  160531          the maximum length of parameter_attr_ in Print() and also in Archive_API.
--  160129  SWiclk  Bug 126798, Modified Create_And_Print() in order to align the print barcodes functionality with Core.
--  150730  SWiclk  Bug 121254, Removed Get_Barcode_Id___() and added Get_Barcode_Id_Tab___(). Modified 
--  150730          Made contract as a Key. Added Copy(), Get_Barcode_Id_Tab___() and Check_Barcode_Id___().  
--  150730          Modified Check_Insert___() in order to validate barcode id since it can be copied, 2 identical
--  150730          barcodes must have identical values for lot_batch_no, serial_no, part_no, configuration_id and activity_seq.
--  150730          Made part_no, configuration_id, eng_chg_level, activity_seq, lot_batch_no, serial_no and project_id as not updatable attributes.
--  150730          Copy() method gets a list of barcode ids and copy all of them to the destination site when moving parts.
--  150529  KhVese  Added sql_where_expression_ as a default parameter to the method signatures of Create_Data_Capture_Lov()
--  150529          and Get_Column_Value_If_Unique() and Record_With_Column_Value_Exist().
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150520  DaZase  COB-437, Removed 100 record description limitation in method Create_Data_Capture_Lov, 
--  150520          this will be replaced with a new configurable LOV record limitation in WADACO framework.--  150728  ShKolk  Bug 123092, Modified Change_Waiv_Dev_Rej_No() to set COPIES option to support StreamServe reports.
--  141215  UdGnlk  PRSC-4609, Added annotation Approve Dynamic Statement which were missing.
--  141112  MaEelk  Bug 119658, Added condition to check if the serial_tab_ is not empty in New_From_Reserved_Lots_Serials.
--  141002  DaZase  PRSC-63, Added methods Get_Column_Value_If_Unique, Create_Data_Capture_Lov and Record_With_Column_Value_Exist.
--  130731  UdGnlk  TIBE-873, Removed the dynamic code and modify to conditional compilation.
--  121008  RiLase  Added methods Print and Create_And_Print.
--  130516  MAANLK  PCM-2798, Modified New_From_Reserved_Lots_Serials to only create barcodes for number of reserved serial numbers.
--  120301  AwWelk  SSC-4046, Added function Check_Inv_Part_Barcode_Exist. This was added to provide support to 
--  120301          check the existing printed barcodes for a given part.
--  111027  NISMLK  SMA-285, Increased eng_chg_level length to STRING(6) in column comments.
--  110802  MaEelk  Replaced the obsolete method call Print_Server_SYS.Enumerate_Printer_Id with Logical_Printer_API.Enumerate_Printer_Id.
--  110324  LEPESE  Correction in New_From_Reserved_Lots_Serials. Removed erroneous condition on serial tracking code.
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  110302  RaKalk  Added overloaded function Get_Serial_No.
--  110125  JoAnSe  Changes in New_From_Reserved_Lots_Serials to handle receipt and issue tracked serials
--  100707  GayDLK  Bug 91379, Added the default NULL parameter activity_seq_ to the method 
--  100707          New_From_Reserved_Lots_Serials() and passed it to New().
--  100511  KRPELK  Merge Rose Method Documentation.
--  -------------------------------- 14.0.0 ----------------------------------
--  060123  NiDalk  Added Assert safe annotation. 
--  050920  NiDalk  Removed unused variables.
--  050425  Ishelk  Bug 50779, Added condition to check for 'Order Based' tracking in New_From_Reserved_Lots_Serials().
--  050407  SeJalk  Bug 50050, Added two new methods, Get_No_Of_Packs__ and New_From_Reserved_Lots_Serials.
--  040619  DaZaSe  Project Inventory: added activity_seq and project_id.
--  -------------------------------- 13.3.0 ----------------------------------
--  030911  MiKulk  Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  020619  LEPESE  Added contract in reference to InventoryPartConfig.
--  020523  NASALK  Extended length of Serial no from VARCHAR2(15) to VARCHAR2(50) in view comments
--  000925  JOHESE  Added undefines.
--  000809  PERK    Added another New method with configuration_id as an added parameter
--  000413  NISOSE  Cleaned-up General_SYS.Init_Method.
--  990919  ROOD    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990422  ANHO    General performance improvements.
--  990407  ANHO    Upgraded to performance optimized template.
--  990310  RaKu    Added view INVENTORY_PART_BARCODE_LOV.
--  990204  ANHO    Added public method New.
--  990201  ANHO    Added procedure Change_Waiv_Dev_Rej_No.
--  981228  ANHO    Made attribute lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no
--                  and origin_pack_size public.
--  981218  ANHO    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Barcode_Table IS TABLE OF NUMBER
   INDEX BY BINARY_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT inventory_part_barcode_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS   
BEGIN   
   IF (newrec_.barcode_id IS NULL) THEN   
      SELECT barcode_id.nextval
        INTO newrec_.barcode_id
        FROM DUAL;   
   END IF;
   IF (Component_Proj_SYS.INSTALLED AND newrec_.activity_seq > 0) THEN
      $IF (Component_Proj_SYS.INSTALLED) $THEN
         newrec_.project_id := Activity_API.Get_Project_Id( newrec_.activity_seq );
      $ELSE
         NULL;
      $END        
   END IF;
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('BARCODE_ID', newrec_.barcode_id, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_barcode_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.activity_seq != 0) THEN
      $IF (Component_Proj_SYS.INSTALLED) $THEN
         Activity_API.Exist(newrec_.activity_seq);
      $ELSE
         Error_SYS.Record_General(lu_name_, 'NOACTIVITY: Activity Seq cannot have value since Module Project is not installed');
      $END
   END IF;   
   super(newrec_, indrec_, attr_);   
   IF (newrec_.barcode_id IS NOT NULL) THEN
      Check_Barcode_Id___(newrec_.barcode_id,
                          newrec_.lot_batch_no,
                          newrec_.serial_no,
                          newrec_.part_no,
                          newrec_.configuration_id,
                          newrec_.activity_seq);
   END IF;   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;   

FUNCTION Get_Barcode_Id_Tab___(
   contract_         VARCHAR2,
   part_no_          VARCHAR2,
   configuration_id_ VARCHAR2,
   lot_batch_no_     VARCHAR2,
   serial_no_        VARCHAR2,
   eng_chg_level_    VARCHAR2,
   waiv_dev_rej_no_  VARCHAR2,
   activity_seq_     NUMBER ) RETURN Barcode_Table
IS 
   barcode_id_tab_   Barcode_Table;
   
   CURSOR get_barcode_id IS
      SELECT barcode_id
      FROM   inventory_part_barcode_tab
      WHERE  contract          = contract_
        AND  part_no           = part_no_
        AND  configuration_id  = configuration_id_
        AND  lot_batch_no      = lot_batch_no_
        AND  serial_no         = serial_no_
        AND  eng_chg_level     = eng_chg_level_
        AND  waiv_dev_rej_no   = waiv_dev_rej_no_
        AND  activity_seq      = activity_seq_;
BEGIN   
   OPEN  get_barcode_id;
   FETCH get_barcode_id BULK COLLECT INTO barcode_id_tab_;
   CLOSE get_barcode_id;

   RETURN barcode_id_tab_;
END Get_Barcode_Id_Tab___;

PROCEDURE Check_Barcode_Id___(
   barcode_id_       IN NUMBER,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   activity_seq_     IN NUMBER)
IS
   temp_ NUMBER;
   CURSOR get_attr IS
      SELECT 1
        FROM inventory_part_barcode_tab
       WHERE barcode_id     = barcode_id_
         AND (lot_batch_no != lot_batch_no_ OR
              serial_no    != serial_no_ OR
              part_no      != part_no_ OR 
              configuration_id != configuration_id_ OR 
              activity_seq != activity_seq_);
BEGIN   
   OPEN  get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF (temp_ = 1) THEN
      Error_SYS.Record_General(lu_name_, 'NOTIDENTICAL: There exists same Barcode ID with different lot batch no/serianl no/part no/configuration id or activity sequence.');
   END IF;
END Check_Barcode_Id___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_No_Of_Packs__ (
   pack_size_ IN NUMBER,
   lot_size_  IN NUMBER ) RETURN NUMBER
IS
   mod_           NUMBER;
   no_of_packs_   NUMBER; 
BEGIN
   IF (lot_size_ <= pack_size_) THEN
      no_of_packs_ := 1;
   ELSE
      mod_ := MOD(lot_size_, pack_size_);
      IF (mod_ > 0) THEN
         IF (mod_/pack_size_ < 0.5) THEN
            no_of_packs_ := (ROUND(lot_size_/pack_size_, 0) + 1);
         ELSE
            no_of_packs_ := (ROUND(lot_size_/pack_size_, 0));
         END IF;
      ELSE
         no_of_packs_ := (lot_size_/pack_size_);
      END IF;
   END IF;
   RETURN no_of_packs_; 
END Get_No_Of_Packs__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Inv_Part_Barcode_Exist(
   contract_         VARCHAR2,
   part_no_          VARCHAR2,
   configuration_id_ VARCHAR2,
   lot_batch_no_     VARCHAR2,
   serial_no_        VARCHAR2,
   eng_chg_level_    VARCHAR2,
   waiv_dev_rej_no_  VARCHAR2,
   activity_seq_     NUMBER ) RETURN VARCHAR2
IS 
   dummy_        NUMBER;
   record_exist_ VARCHAR2(5);

   CURSOR exist_control IS
      SELECT 1
      FROM   inventory_part_barcode_tab
      WHERE  contract          = contract_
        AND  part_no           = part_no_
        AND  configuration_id  = configuration_id_
        AND  lot_batch_no      = lot_batch_no_
        AND  serial_no         = serial_no_
        AND  eng_chg_level     = eng_chg_level_
        AND  waiv_dev_rej_no   = waiv_dev_rej_no_
        AND  activity_seq      = activity_seq_;
BEGIN
   record_exist_ := 'FALSE';

   OPEN  exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      record_exist_ := 'TRUE';
   END IF;
   CLOSE exist_control;

   RETURN record_exist_;
END Check_Inv_Part_Barcode_Exist;

-- Change_Waiv_Dev_Rej_No
--   Changes waiv_dev_rej_no for a record in InventoryPartBarcode and
--   if required prints out a new barcode label. This method is called
--   after the method Change_Waiv_Dev_Rej_No in InventoryPartLocation is called.
PROCEDURE Change_Waiv_Dev_Rej_No (
   contract_   IN VARCHAR2,
   barcode_id_ IN NUMBER,
   waiv_dev_rej_no_ IN VARCHAR2,
   to_waiv_dev_rej_no_ IN VARCHAR2,
   change_wdr_ IN NUMBER,
   print_barcode_ IN NUMBER )
IS
   newrec_                 inventory_part_barcode_tab%ROWTYPE;
   dummy_                  NUMBER;
   print_job_id_           NUMBER;
   printer_id_list_        VARCHAR2(32000);
   print_attr_             VARCHAR2(2000);
   rep_attr_               VARCHAR2(2000);
   par_attr_               VARCHAR2(2000);
   printer_id_             VARCHAR2(100);
   result_key_             NUMBER;
   
   CURSOR get_attr IS
      SELECT 1
      FROM   inventory_part_barcode_tab
      WHERE  contract        = contract_
      AND    barcode_id      = barcode_id_
      AND    waiv_dev_rej_no = waiv_dev_rej_no_;

BEGIN

   IF to_waiv_dev_rej_no_ IS NULL THEN
      Error_SYS.Record_General('InventoryPartBarcode','WDRNONULL: W/D/R No must have a value.');
   END IF;

   OPEN  get_attr;
   FETCH get_attr INTO dummy_;
   IF (get_attr%NOTFOUND) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
   CLOSE get_attr;

   IF (change_wdr_ = 1) THEN
      IF (to_waiv_dev_rej_no_ != waiv_dev_rej_no_) THEN         
         newrec_ := Lock_By_Keys___(contract_, barcode_id_);
         newrec_.waiv_dev_rej_no := to_waiv_dev_rej_no_;
         Modify___(newrec_);
      END IF;
   END IF;

   IF (print_barcode_ = 1) THEN

      printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, 'INVENTORY_PART_BARCODE_REP');
      Client_SYS.Clear_Attr(print_attr_);
      Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, print_attr_);
      Print_Job_API.New(print_job_id_, print_attr_);
      
      Client_SYS.Clear_Attr(rep_attr_);
      Client_SYS.Add_To_Attr('REPORT_ID', 'INVENTORY_PART_BARCODE_REP', rep_attr_);
      Client_SYS.Clear_Attr(par_attr_);
      Client_SYS.Add_To_Attr('BARCODE_ID', barcode_id_, par_attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, par_attr_);
      Archive_API.New_Instance(result_key_, rep_attr_, par_attr_);
      
      Client_SYS.Clear_Attr(print_attr_);
      Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, print_attr_);
      Client_SYS.Add_To_Attr('RESULT_KEY',   result_key_,   print_attr_);
      Client_SYS.Add_To_Attr('OPTIONS',      'COPIES(1)',   print_attr_);
      Print_Job_Contents_API.New_Instance(print_attr_);

      Logical_Printer_API.Enumerate_Printer_Id(printer_id_list_);
      IF (printer_id_list_ IS NOT NULL) THEN
          IF (print_job_id_ IS NOT NULL) THEN
            Print_Job_API.Print(print_job_id_);
          END IF;
      END IF;

   END IF;
END Change_Waiv_Dev_Rej_No;


-- New
--   Creates new InventoryPartBarcode records.
--   Creates new InventoryPartBarcode records.
PROCEDURE New (
   barcode_id_       OUT NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   origin_pack_size_ IN NUMBER )
IS
   temp_barcode_id_ Inventory_Part_Barcode_Tab.barcode_id%TYPE;

BEGIN
   New(temp_barcode_id_,contract_,part_no_,'*',lot_batch_no_,serial_no_,eng_chg_level_,waiv_dev_rej_no_,origin_pack_size_,0);
   barcode_id_ := temp_barcode_id_;
END New;


-- New
--   Creates new InventoryPartBarcode records.
--   Creates new InventoryPartBarcode records.
PROCEDURE New (
   barcode_id_       OUT NUMBER,
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   configuration_id_ IN  VARCHAR2,
   lot_batch_no_     IN  VARCHAR2,
   serial_no_        IN  VARCHAR2,
   eng_chg_level_    IN  VARCHAR2,
   waiv_dev_rej_no_  IN  VARCHAR2,
   origin_pack_size_ IN  NUMBER,
   activity_seq_     IN  NUMBER )
IS
   newrec_       inventory_part_barcode_tab%ROWTYPE;
BEGIN
   newrec_.contract         := contract_;
   newrec_.part_no          := part_no_;
   newrec_.lot_batch_no     := lot_batch_no_;
   newrec_.serial_no        := serial_no_;
   newrec_.eng_chg_level    := eng_chg_level_;
   newrec_.waiv_dev_rej_no  := waiv_dev_rej_no_;
   newrec_.origin_pack_size := origin_pack_size_;
   newrec_.configuration_id := configuration_id_;
   newrec_.activity_seq     := activity_seq_;
   New___(newrec_);
   barcode_id_ := newrec_.barcode_id;
END New;


PROCEDURE New_From_Reserved_Lots_Serials (
   barcode_tab_          OUT Barcode_Table,
   part_no_              IN  VARCHAR2,
   contract_             IN  VARCHAR2,
   order_ref1_           IN  VARCHAR2,
   order_ref2_           IN  VARCHAR2,
   order_ref3_           IN  VARCHAR2,
   order_ref4_           IN  VARCHAR2,
   eng_chg_level_        IN  VARCHAR2,
   waiv_dev_rej_no_      IN  VARCHAR2,
   origin_pack_size_     IN  NUMBER,
   lot_size_             IN  NUMBER,
   reservation_type_db_  IN  VARCHAR2,
   serial_res_source_db_ IN  VARCHAR2,
   activity_seq_         IN  NUMBER DEFAULT NULL )
IS
   serial_no_           inventory_part_barcode_tab.serial_no%TYPE;
   lot_batch_no_        inventory_part_barcode_tab.lot_batch_no%TYPE;   
   barcode_id_          inventory_part_barcode_tab.barcode_id%TYPE;
   no_of_packs_         NUMBER;
   index_               NUMBER := 0;
   part_catalog_rec_    Part_Catalog_API.Public_Rec;
   serial_tab_          Part_Serial_Catalog_API.Serial_No_Tab;
   lot_batch_data_tab_  Reserved_Lot_Batch_API.Res_Lot_Batch_Table;
   activity_sequence_   NUMBER := 0;

BEGIN
   IF activity_seq_ IS NOT NULL THEN
      activity_sequence_ :=  activity_seq_;  
   END IF;
   part_catalog_rec_   := Part_Catalog_API.Get(part_no_);
   serial_tab_       := Serial_No_Reservation_API.Get_Reserved_Serial_Tab(part_no_,
                                                                            order_ref1_,
                                                                            order_ref2_,
                                                                            order_ref3_,
                                                                            serial_res_source_db_);
   lot_batch_data_tab_ := Reserved_Lot_Batch_API.Get_Lot_Batch_Data_Tab(part_no_,
                                                                        order_ref1_,
                                                                        order_ref2_,
                                                                        order_ref3_,
                                                                        reservation_type_db_);
   
   IF (part_catalog_rec_.lot_tracking_code = 'LOT TRACKING' OR part_catalog_rec_.lot_tracking_code = 'ORDER BASED') THEN
      serial_no_ := '*';
      IF (lot_batch_data_tab_.COUNT > 0) THEN
         IF (serial_tab_.COUNT> 0) THEN
            index_ := serial_tab_.FIRST;
         END IF;
         FOR n IN lot_batch_data_tab_.FIRST..lot_batch_data_tab_.LAST LOOP 
            no_of_packs_ := Get_No_Of_Packs__(origin_pack_size_, lot_batch_data_tab_(n).reserved_qty);
            FOR i IN 1..no_of_packs_ LOOP
               IF (part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.DB_TRUE) THEN
                  serial_no_ := serial_tab_(index_).serial_no;
               END IF;
               New( barcode_id_,
                     contract_,
                     part_no_,
                     order_ref4_,
                     lot_batch_data_tab_(n).lot_batch_no,
                     serial_no_,
                     eng_chg_level_,
                     waiv_dev_rej_no_,
                     origin_pack_size_,
                     activity_sequence_);
               barcode_tab_(index_) := barcode_id_;
               index_ := index_ + 1;
               EXIT WHEN index_ > serial_tab_.LAST;
            END LOOP;
         END LOOP;
      END IF;
   ELSE
      lot_batch_no_ := '*';
      IF (part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.db_true) THEN
         IF (serial_tab_.COUNT > 0) THEN
            FOR n IN serial_tab_.FIRST..serial_tab_.LAST LOOP
               New( barcode_id_,
                     contract_,
                     part_no_,
                     order_ref4_,
                     lot_batch_no_,
                     serial_tab_(n).serial_no,
                     eng_chg_level_,
                     waiv_dev_rej_no_,
                     origin_pack_size_,
                     activity_sequence_);
               barcode_tab_(index_) := barcode_id_;
               index_ := index_ + 1;
            END LOOP;
         END IF;
      ELSE
         serial_no_ := '*';
         no_of_packs_ := Get_No_Of_Packs__(origin_pack_size_, lot_size_);
         FOR i IN 1..no_of_packs_ LOOP
            New( barcode_id_,
                contract_,
                part_no_,
                order_ref4_,
                lot_batch_no_,
                serial_no_,
                eng_chg_level_,
                waiv_dev_rej_no_,
                origin_pack_size_,
                activity_sequence_);

            barcode_tab_(index_) := barcode_id_;
            index_ := index_ +1;
         END LOOP;
      END IF;
   END IF;

END New_From_Reserved_Lots_Serials;


PROCEDURE Print (
   barcode_id_       IN VARCHAR2,
   contract_         IN VARCHAR2,
   number_of_copies_ IN NUMBER DEFAULT 1 )
IS
   printer_id_             VARCHAR2(250);
   print_job_attr_         VARCHAR2(200);
   report_attr_            VARCHAR2(2000);
   -- Note that FW and the report actually supports 32000 character parameter attribute string, but there might be some issues with too large report files 
   -- so it might not be good to increase the size too much wihtout testing it
   parameter_attr_         VARCHAR2(2100); 
   result_key_             NUMBER;
   print_job_id_           NUMBER;
   printer_id_list_        VARCHAR2(32000);

BEGIN
   
   -- Generate a new print job id 
   printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, 'INVENTORY_PART_BARCODE_REP');
   Client_SYS.Clear_Attr(print_job_attr_);
   Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, print_job_attr_);
   Print_Job_API.New(print_job_id_, print_job_attr_);

   Client_SYS.Clear_Attr(report_attr_);
   Client_SYS.Add_To_Attr('REPORT_ID', 'INVENTORY_PART_BARCODE_REP', report_attr_);

   --Note: Create the report
   Client_SYS.Clear_Attr(parameter_attr_);
   Client_SYS.Add_To_Attr('BARCODE_ID', barcode_id_, parameter_attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, parameter_attr_);
   Client_SYS.Add_To_Attr('NUMBER_OF_COPIES', number_of_copies_, parameter_attr_);
   Archive_API.New_Instance(result_key_, report_attr_, parameter_attr_);

   --Note: Connect the created report to a print job id
   Client_SYS.Clear_Attr(print_job_attr_);
   Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, print_job_attr_);
   Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, print_job_attr_);
   Client_SYS.Add_To_Attr('OPTIONS', 'COPIES(1)', print_job_attr_);
   Print_Job_Contents_API.New_Instance(print_job_attr_);
   
   -- Send the print job to the printer.
   Logical_Printer_API.Enumerate_Printer_Id(printer_id_list_);
   IF (printer_id_list_ IS NOT NULL) THEN
      IF (print_job_id_ IS NOT NULL) THEN
         Print_Job_API.Print(print_job_id_);
         -- TODO: Investigate alternate method:
         --Archive_API.Create_And_Print_Report__(msg_);
      END IF;
   END IF;
END Print;


PROCEDURE Create_And_Print (
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   configuration_id_ IN  VARCHAR2,
   lot_batch_no_     IN  VARCHAR2,
   serial_no_        IN  VARCHAR2,
   eng_chg_level_    IN  VARCHAR2,
   waiv_dev_rej_no_  IN  VARCHAR2,
   origin_pack_size_ IN  NUMBER,
   activity_seq_     IN  NUMBER,
   quantity_         IN  NUMBER)
IS   
   number_of_labels_    NUMBER;
   list_of_barcode_ids_ VARCHAR2(2000);
   i_                   NUMBER := 0;
   barcode_id_        NUMBER;
BEGIN
   number_of_labels_ := ceil(quantity_/origin_pack_size_);   
   WHILE (i_ < number_of_labels_ ) LOOP   
      New(barcode_id_,
          contract_         => contract_,
          part_no_          => part_no_,
          configuration_id_ => '*',
          lot_batch_no_     => lot_batch_no_,
          serial_no_        => serial_no_,
          eng_chg_level_    => eng_chg_level_,
          waiv_dev_rej_no_  => waiv_dev_rej_no_,
          origin_pack_size_ => origin_pack_size_,
          activity_seq_     => activity_seq_);          
      list_of_barcode_ids_ := list_of_barcode_ids_ || barcode_id_ || ';';
      IF (LENGTH(list_of_barcode_ids_) > 1950) THEN
         Print(list_of_barcode_ids_, contract_, 1);
         list_of_barcode_ids_ := NULL;
      END IF; 
      i_ := i_ + 1;
   END LOOP;
   IF (list_of_barcode_ids_ IS NOT NULL) THEN
      Print(list_of_barcode_ids_, contract_, 1);
   END IF;
END Create_And_Print;

@UncheckedAccess
FUNCTION Get_Serial_No (
   contract_            IN VARCHAR2,
   barcode_id_          IN NUMBER,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER) RETURN VARCHAR2
IS
   rec_  inventory_part_barcode_tab%ROWTYPE;
BEGIN   
   rec_ := Get_Object_By_Keys___(contract_, barcode_id_);   
   IF rec_.part_no            = NVL(part_no_, rec_.part_no)                   AND
      rec_.configuration_id   = NVL(configuration_id_, rec_.configuration_id) AND
      rec_.lot_batch_no       = NVL(lot_batch_no_, rec_.lot_batch_no)         AND
      rec_.eng_chg_level      = NVL(eng_chg_level_, rec_.eng_chg_level)       AND
      rec_.waiv_dev_rej_no    = NVL(waiv_dev_rej_no_, rec_.waiv_dev_rej_no)   AND
      rec_.activity_seq       = NVL(activity_seq_, rec_.activity_seq)   THEN
      RETURN rec_.serial_no;
   ELSE
      RETURN NULL;
   END IF;

END Get_Serial_No;


-- This method is used by DataCaptAttachPartHu, DataCaptCountPartRep, DataCaptIssueInvPart, DataCaptIssueMtrlReq
-- DataCaptRecFromTransit, DataCaptScrapInvPart, DataCaptTranspTaskPart, DataCaptUnattachPartHu, DataCaptureCountPart,
-- DataCaptureMovePart, DataCaptReportPickPart, DataCapAttachReceiptHu, DataCapRecPartDispAdv, DataCaptRegstrArrivals,
-- DataCaptureMoveReceipt, DataCapUnattachRcptHu, DataCapPackIntoHuShip, DataCapProcessPartShip, DataCaptUnpackHuShip, 
-- DataCaptManIssSoPart, DataCaptRecSo, DataCaptRepPickPartSo, DataCaptManIssueWo, DataCaptUnissueWo and DataCaptUnplanIssueWo
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_         IN VARCHAR2,
   barcode_id_       IN NUMBER,  
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   column_name_      IN VARCHAR2,
   sql_where_expression_    IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(4000);
   unique_column_value_           VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab; 

BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_Table_Column('INVENTORY_PART_BARCODE_TAB', column_name_);   
   
   stmt_ := ' SELECT DISTINCT ' || column_name_ || '
              FROM  INVENTORY_PART_BARCODE_TAB
              WHERE EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site = contract) ';
   IF contract_ IS NULL THEN
      stmt_ := stmt_ || ' AND :contract_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND contract = :contract_';
   END IF;
   IF barcode_id_ IS NULL THEN
      stmt_ := stmt_ || ' AND :barcode_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND barcode_id = :barcode_id_';
   END IF;
   IF part_no_ IS NULL THEN
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;
   IF configuration_id_ IS NULL THEN
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
   END IF;
   IF lot_batch_no_ IS NULL THEN
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
   END IF;
   IF serial_no_ IS NULL THEN
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND serial_no = :serial_no_';
   END IF;
   IF eng_chg_level_ IS NULL THEN
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
   END IF;
   IF waiv_dev_rej_no_ IS NULL THEN
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
   END IF;
   IF activity_seq_ IS NULL THEN
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
   END IF;
   
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';

   @ApproveDynamicStatement(2014-12-09,UdGnlk)
   OPEN get_column_values_ FOR stmt_ USING contract_, 
                                           barcode_id_,
                                           part_no_,
                                           configuration_id_,
                                           lot_batch_no_,
                                           serial_no_,
                                           eng_chg_level_,
                                           waiv_dev_rej_no_,
                                           activity_seq_;
                                                       
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
   END IF;
   CLOSE get_column_values_;   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptAttachPartHu, DataCaptCountPartRep, DataCaptIssueInvPart, DataCaptIssueMtrlReq
-- DataCaptRecFromTransit, DataCaptScrapInvPart, DataCaptTranspTaskPart, DataCaptUnattachPartHu, DataCaptureCountPart, 
-- DataCaptureMovePart, DataCaptReportPickPart, DataCapAttachReceiptHu, DataCaptureMoveReceipt, DataCapUnattachRcptHu,
-- DataCapPackIntoHuShip, DataCapProcessPartShip, DataCaptUnpackHuShip, DataCaptManIssSoPart, DataCaptRecSo, 
-- DataCaptRepPickPartSo, DataCaptManIssueWo, DataCaptUnissueWo and DataCaptUnplanIssueWo
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_              IN VARCHAR2,
   barcode_id_            IN NUMBER,   
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   eng_chg_level_         IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   activity_seq_          IN NUMBER,
   capture_session_id_    IN NUMBER,
   column_name_           IN VARCHAR2,
   lov_type_db_           IN VARCHAR2,
   sql_where_expression_  IN VARCHAR2 DEFAULT NULL)
IS
   TYPE Get_Lov_Values       IS REF CURSOR;
   get_lov_values_           Get_Lov_Values;
   stmt_                     VARCHAR2(2000);
   TYPE Lov_Value_Tab        IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_            Lov_Value_Tab;
   lov_item_description_     VARCHAR2(200);
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   second_column_name_       VARCHAR2(200);
   second_column_value_      VARCHAR2(200);
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN

      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_Table_Column('INVENTORY_PART_BARCODE_TAB', column_name_);

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK 
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;      
      stmt_ := stmt_ || 
         ' FROM  INVENTORY_PART_BARCODE_TAB
           WHERE EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site = contract) ';
      IF contract_ IS NULL THEN
         stmt_ := stmt_ || ' AND :contract_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND contract = :contract_';
      END IF;
      IF barcode_id_ IS NULL THEN
         stmt_ := stmt_ || ' AND :barcode_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND barcode_id = :barcode_id_';
      END IF;
      IF part_no_ IS NULL THEN
         stmt_ := stmt_ || ' AND :part_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND part_no = :part_no_';
      END IF;
      IF configuration_id_ IS NULL THEN
         stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
      END IF;
      IF lot_batch_no_ IS NULL THEN
         stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
      END IF;
      IF serial_no_ IS NULL THEN
         stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND serial_no = :serial_no_';
      END IF;
      IF eng_chg_level_ IS NULL THEN
         stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
      END IF;
      IF waiv_dev_rej_no_ IS NULL THEN
         stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
      END IF;
      IF activity_seq_ IS NULL THEN
         stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
      END IF;
      
      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || ' AND ' || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' ASC';

      @ApproveDynamicStatement(2014-12-09,UdGnlk)
      OPEN get_lov_values_ FOR stmt_ USING contract_,
                                           barcode_id_,
                                           part_no_,
                                           configuration_id_,
                                           lot_batch_no_,
                                           serial_no_,
                                           eng_chg_level_,
                                           waiv_dev_rej_no_,
                                           activity_seq_;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN

         CASE (column_name_)
            WHEN ('BARCODE_ID') THEN
               second_column_name_ := 'PART_DESCRIPTION';
            ELSE
               NULL;
         END CASE;
         
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'PART_DESCRIPTION') THEN                     
                     second_column_value_ := Inventory_Part_API.Get_Description(contract_, Get_Part_No(contract_, lov_value_tab_(i)));
                  END IF;
                  IF (second_column_value_ IS NOT NULL) THEN
                     lov_item_description_ := second_column_value_;
                  ELSE
                    lov_item_description_ := NULL;
                  END IF;
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


-- This method is used by DataCaptAttachPartHu, DataCaptCountPartRep, DataCaptIssueInvPart, DataCaptIssueMtrlReq
-- DataCaptRecFromTransit, DataCaptScrapInvPart, DataCaptTranspTaskPart, DataCaptUnattachPartHu, DataCaptureCountPart,
-- DataCaptureMovePart, DataCaptReportPickPart, DataCapAttachReceiptHu, DataCapRecPartDispAdv, DataCaptRegstrArrivals,
-- DataCaptureMoveReceipt, DataCapUnattachRcptHu, DataCapPackIntoHuShip, DataCapProcessPartShip, DataCaptUnpackHuShip,
-- DataCaptManIssSoPart, DataCaptRecSo, DataCaptRepPickPartSo, DataCaptManIssueWo, DataCaptUnissueWo and DataCaptUnplanIssueWo 
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_           IN VARCHAR2,
   barcode_id_         IN NUMBER,   
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN NUMBER,
   column_name_        IN VARCHAR2,
   column_value_       IN VARCHAR2,
   column_description_ IN VARCHAR2,
   sql_where_expression_    IN VARCHAR2 DEFAULT NULL) 
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(2000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN

   -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
   Assert_SYS.Assert_Is_Table_Column('INVENTORY_PART_BARCODE_TAB', column_name_);   
   
   stmt_ := ' SELECT 1
              FROM  INVENTORY_PART_BARCODE_TAB
              WHERE EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site = contract) '; 
   IF contract_ IS NULL THEN
      stmt_ := stmt_ || ' AND :contract_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND contract = :contract_';
   END IF;
   IF barcode_id_ IS NULL THEN
      stmt_ := stmt_ || ' AND :barcode_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND barcode_id = :barcode_id_';
   END IF;
   IF part_no_ IS NULL THEN
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;
   IF configuration_id_ IS NULL THEN
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
   END IF;
   IF lot_batch_no_ IS NULL THEN
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
   END IF;
   IF serial_no_ IS NULL THEN
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND serial_no = :serial_no_';
   END IF;
   IF eng_chg_level_ IS NULL THEN
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
   END IF;
   IF waiv_dev_rej_no_ IS NULL THEN
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
   END IF;
   IF activity_seq_ IS NULL THEN
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL ';
   ELSE
      stmt_ := stmt_ || ' AND activity_seq = :activity_seq_ ';
   END IF;
   stmt_ := stmt_ || ' AND ' || column_name_ ||'  = :column_value_';


   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   @ApproveDynamicStatement(2014-12-09,UdGnlk)          
   OPEN exist_control_ FOR stmt_ USING contract_,
                                       barcode_id_,
                                       part_no_,
                                       configuration_id_,
                                       lot_batch_no_,
                                       serial_no_,
                                       eng_chg_level_,
                                       waiv_dev_rej_no_,
                                       activity_seq_,
                                       column_value_;
             
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
   END IF;

END Record_With_Column_Value_Exist;
 
PROCEDURE Copy(
   from_contract_       IN VARCHAR2,
   to_contract_         IN VARCHAR2,
   to_eng_chg_level_    IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER)
IS
   newrec_           inventory_part_barcode_tab%ROWTYPE;
   origin_pack_size_ NUMBER;   
   barcode_id_tab_   Barcode_Table;   
BEGIN   
   barcode_id_tab_ := Get_Barcode_Id_Tab___(contract_         => from_contract_,
                                            part_no_          => part_no_,
                                            configuration_id_ => configuration_id_,
                                            lot_batch_no_     => lot_batch_no_,
                                            serial_no_        => serial_no_,
                                            eng_chg_level_    => eng_chg_level_,
                                            waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                            activity_seq_     => activity_seq_);   
   
   IF (barcode_id_tab_.COUNT > 0) THEN 
      FOR i IN barcode_id_tab_.FIRST..barcode_id_tab_.LAST LOOP
         IF NOT (Check_Exist___(to_contract_, barcode_id_tab_(i))) THEN              
            origin_pack_size_ := Get_Origin_Pack_Size(from_contract_, barcode_id_tab_(i));
            origin_pack_size_ := Inventory_Part_API.Get_Site_Converted_Qty(from_contract_,
                                                                           part_no_,
                                                                           to_contract_,
                                                                           origin_pack_size_,
                                                                           'REMOVE');
            newrec_.contract         := to_contract_;
            newrec_.barcode_id       := barcode_id_tab_(i);
            newrec_.part_no          := part_no_;
            newrec_.lot_batch_no     := lot_batch_no_;
            newrec_.serial_no        := serial_no_;
            newrec_.eng_chg_level    := to_eng_chg_level_;
            newrec_.waiv_dev_rej_no  := waiv_dev_rej_no_;
            newrec_.origin_pack_size := origin_pack_size_;
            newrec_.configuration_id := configuration_id_;
            newrec_.activity_seq     := activity_seq_;
            New___(newrec_);
         END IF;
      END LOOP;
   END IF;   
END Copy;

PROCEDURE Change_Eng_Chg_Level(
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   to_eng_chg_level_ IN VARCHAR2 )
IS
   newrec_           inventory_part_barcode_tab%ROWTYPE;
   barcode_id_tab_   Barcode_Table;
BEGIN
   IF to_eng_chg_level_ IS NULL THEN
      Error_SYS.Record_General('InventoryPartBarcode','ENGCHGLIEVELNULL: Part revision must have a value.');
   END IF;

   IF ( eng_chg_level_ != to_eng_chg_level_) THEN
      barcode_id_tab_ := Get_Barcode_Id_Tab___(contract_, part_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_ );
      
      IF (barcode_id_tab_.COUNT > 0) THEN 
         FOR i IN barcode_id_tab_.FIRST..barcode_id_tab_.LAST LOOP
            newrec_ := Get_Object_By_Keys___(contract_, barcode_id_tab_(i));
            newrec_.eng_chg_level := to_eng_chg_level_;
            Modify___(newrec_);  
         END LOOP;
      END IF;
   END IF;
END Change_Eng_Chg_Level;

