-----------------------------------------------------------------------------
--
--  Logical unit: TemporaryPartTracking
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210427  KETKLK  PJ21R2-448, Removed PDMPRO references.
--  200528  RoJalk  SC2020R1-1231, Modified the call Inventory_Part_Reservation_API.Identify_Serials in Split_Reservation so the pick_list_no_ will have the correct value.
--  200520  RoJalk  SC2020R1-1231, Modified Split_Reservation to support Shipment Order.
--  200319  BudKlk  Bug 145218(SCZ-2117), Modified the method Create_Data_Capture_Lov() in order to get the  values for the LOV when part_ownership_db is either 'COMPANY OWNED' or 'CUSTOMER OWNED'.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  200206  NiFrse  SASPRING20-937, Modified the Maint_Material_Allocation_API.Split_Reservation_Into_Serials() call in Split_Reservation().
--  181109  JaThlk  SCUXXW4-5836, Added a new public method, Modify_Catch_Qty().
--  180810  JaThlk  SCUXXW4-5516, Added a new public method, Remove().
--  161125  RoJalk  LIM-9738, Modified Split_Reservation and called Inventory_Part_Reservation_API.Identify_Serials 
--  161125          to support demand types using inventory_part_reservation_tab as reservation source.
--  160531  PrYaLK  Bug 127654, Added a new method New_Clob().
--  151029  MaEelk  LIM-3787, Replaced the call to Transport_Task_Line_Nopall_API.Split_Into_Serials with Transport_Task_Line_API.Split_Into_Serials.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729          method call in ORDER BY clause to sort string and number values seperately.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150520  DaZase  COB-437, Removed 100 record description limitation in method Create_Data_Capture_Lov, 
--  150520          this will be replaced with a new configurable LOV record limitation in WADACO framework.
--  150421  Chfose  Added handling_unit_id_ in Split_Reservation_Into_Serials calls. 
--  150413  JeLise  Added handling_unit_id_ in calls to Inventory_Part_In_Stock_API.
--  141217  DaZase  PRSC-1611, Added extra column check in method Create_Data_Capture_Lov to avoid any risk of getting sql injection problems.
--  141103  ChJalk  PRSC-2216, Added missing assert safe anotation for get_lov_values_.
--  140619  DaZase  PRSC-1207, Changed Create_Data_Capture_Lov so it now only uses ORDER BY ASC.
--  131107  DaZase  Bug 113189, Rewrote Create_Data_Capture_Lov to now use a dynamic cursor, changed the parameters. 
--  130923  MaEelk  Added source_ref_6_ to Identify_Serial_On_Reservation to support Billabong changes in shipment_id 
--  130923  AwWelk  TIBE-2916, Replaced the Installed_Component_SYS.CROMFG with Component_CROMFG_SYS."CROMFG" in 
--  130923          Split_Reservation() method.
--  130312  RiLase  Added New and Create_Data_Capture_Lov.
--  130515  IsSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130507  KANILK  Modified Split_Reservation method .
--  130104  Asawlk  Bug 106455, Added method New(). Also added derived attribute 'IDENTIFICATION_CONTEXT', which can be
--  130104          'NEGATIVE_COUNTING_DIFF', 'POSITIVE_COUNTING_DIFF' or 'OTHER'.
--  121211  RoJalk  Added source_ref_6_ parameter to the method Split_Reservation.
--  120314  LEPESE  Added parameter validate_ to method Add_Serials_To_Session___.
--  111207  RaKalk  Modified Split_Reservation to support CRO
--  111205  MAHPLK  Removed General_SYS.Init_Method from Get_Next_Session_Id.
--  111115  Rakalk  Added procedure Validate_Serial, Added derived fields contract and part_no.
--  111012  LEPESE  Added parameters part_no_ and lot_batch_no_ to methods Get_Serials___ and Get_And_Remove_Serials.
--  111012          Added cursor get_lot_serials in method Get_Serials___. 
--  110926  MaMalk  Modified procedure Insert___ to give a more user freindly error message when duplicate records found.
--  110601  NaLrlk  Added column configuration_id to the view TEMPORARY_PART_TRACKING_SERIAL.
--  110308  ShVese  Modified Split_Reservation for demand source Project Misc Demand and Project Delivery.
--  110308  RaKalk  Added more columns to TEMPORARY_PART_TRACKING_SERIAL
--  110228  LaRelk  Modified Split_Reservation() to handle demand source Design Object Demand in plant design.
--  110224  LaRelk  Modified Split_Reservation() to handle demand source project delivery.
--  110224  RaKalk  Modification in Remove_Old_Sessions___ to avoid removing records that are
--  110222          connected to a Nonconfirmed Counting Report Lines.
--  110222  LEPESE  Modification in Remove_Old_Sessions___ to avoid removing records that are
--  110222          connected to a Rejected Counting Result. Added method Get_Serials.
--  110219  LEPESE  Added methods Get_Number_Of_Serials, Get_Splitted_Session and Add_Serials_To_Session___.
--  110211  LaRelk  Modified Split_Reservation() to handle demand source project misc demand.
--  110203  JoAnSe  Added handling for work order reservations to Split_Reservation
--  110124  LaRelk  Added objid,objversion to view Temporary_Part_Tracking_Serial.
--  101228  LaRelk  Modified Split_Reservation() to handle demand source transport task.
--  101216  LaRelk  Modified Split_Reservation() to handle purchase order reservations to Split_Reservation.
--  101215  JoAnSe  Added handling for shop order reservations to Split_Reservation
--  101210  LEPESE  Changed call from Inventory_Part_In_Stock_API.Split_Reservation_Into_Serials to
--  101210          Inventory_Part_In_Stock_API.Split_Into_Serials in Split_Reservation.
--  101209  LEPESE  Added Remove_Old_Sessions___, Remove_Serial___, Remove_Serials___, Remove_Session___
--  101209          and Get_And_Remove_Serials.
--  101207  RaKalk  Modified procedure Split_Reservation to use dynamic code. Added function Get_Serials__.
--  101201  LEPESE  Changed Get_And_Remove_Details___ into public Get_Serials_And_Remove_Session.
--  101116  RaKalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Remove_Serials___ (
   session_id_       IN NUMBER,
   serial_catch_tab_ IN Inventory_Part_In_Stock_API.Serial_Catch_Table )
IS
BEGIN
   IF (serial_catch_tab_.COUNT > 0) THEN
      FOR i IN serial_catch_tab_.FIRST..serial_catch_tab_.LAST LOOP
         Remove_Serial___(session_id_, serial_catch_tab_(i).serial_no);
      END LOOP;
   END IF;
END Remove_Serials___;


PROCEDURE Remove_Session___ (
   session_id_ IN NUMBER)
IS
   CURSOR get_serials(session_id_ VARCHAR2) IS
      SELECT serial_no
      FROM TEMPORARY_PART_TRACKING_TAB
      WHERE session_id = session_id_
      FOR UPDATE;
BEGIN
   FOR rec_ IN get_serials(session_id_) LOOP
      Remove_Serial___(session_id_, rec_.serial_no);
   END LOOP;
END Remove_Session___;


PROCEDURE Remove_Old_Sessions___
IS
   CURSOR get_old_records IS
      SELECT DISTINCT session_id
      FROM TEMPORARY_PART_TRACKING_TAB
      WHERE TRUNC(rowversion) < TRUNC(SYSDATE) - 7;
BEGIN
   FOR rec_ IN get_old_records LOOP
      IF NOT (Counting_Result_API.Part_Track_Id_Is_On_Rejected(rec_.session_id) OR 
              Counting_Report_Line_API.Tracking_Id_Is_On_Nonconfirmed(rec_.session_id)) THEN
         Remove_Session___(rec_.session_id);
      END IF;
   END LOOP;
END Remove_Old_Sessions___;


PROCEDURE Get_Serials___ (
   serial_catch_tab_  OUT Inventory_Part_In_Stock_API.Serial_Catch_Table,
   session_id_        IN  NUMBER,
   number_of_serials_ IN  NUMBER   DEFAULT NULL,
   part_no_           IN  VARCHAR2 DEFAULT NULL,
   lot_batch_no_      IN  VARCHAR2 DEFAULT NULL )
IS
   CURSOR get_serials IS
      SELECT serial_no,
             catch_qty
      FROM   TEMPORARY_PART_TRACKING_TAB
      WHERE  session_id = session_id_
       AND   ((number_of_serials_ IS NULL) OR (ROWNUM <= number_of_serials_))
      FOR UPDATE;

   CURSOR get_lot_serials IS
      SELECT temp.serial_no,
             temp.catch_qty
      FROM   TEMPORARY_PART_TRACKING_TAB temp
      WHERE  temp.session_id = session_id_
       AND   ((number_of_serials_ IS NULL) OR (ROWNUM <= number_of_serials_))
       AND EXISTS (SELECT 1
                   FROM part_serial_catalog_pub cat
                   WHERE cat.part_no      = part_no_
                     AND cat.serial_no    = temp.serial_no
                     AND cat.lot_batch_no = lot_batch_no_)
      FOR UPDATE;
BEGIN
   IF (number_of_serials_ IS NOT NULL) THEN
      IF (number_of_serials_ < 1) THEN
         Error_SYS.Record_General(lu_name_,'SMALLSERNUM: It is only allowed to request a positive number of serials.');
      END IF;
   
      IF (number_of_serials_ != TRUNC(number_of_serials_)) THEN
         Error_SYS.Record_General(lu_name_,'INTSERNUM: Number of requested serials can only be expressed as an integer.');
      END IF;
   END IF;

   IF ((lot_batch_no_ IS NULL) OR (part_no_ IS NULL)) THEN
      OPEN  get_serials;
      FETCH get_serials BULK COLLECT INTO serial_catch_tab_;
      CLOSE get_serials;
   ELSE
      OPEN  get_lot_serials;
      FETCH get_lot_serials BULK COLLECT INTO serial_catch_tab_;
      CLOSE get_lot_serials;
   END IF;

   IF (number_of_serials_ IS NOT NULL) AND
      (serial_catch_tab_.COUNT < number_of_serials_) THEN

      IF ((lot_batch_no_ IS NULL) OR (part_no_ IS NULL)) THEN
         Error_SYS.Record_General(lu_name_,'TOOFEW: :P1 serials were requested but only :P2 were identified.', number_of_serials_, serial_catch_tab_.COUNT);
      ELSE
         Error_SYS.Record_General(lu_name_,'TOOFEWLOT: :P1 serials from Lot/Batch No :P2 are required but only :P3 were identified.', number_of_serials_, lot_batch_no_, serial_catch_tab_.COUNT);
      END IF;
   END IF;
END Get_Serials___;


PROCEDURE Remove_Serial___ (
   session_id_ IN NUMBER,
   serial_no_  IN VARCHAR2 )
IS
   objid_      TEMPORARY_PART_TRACKING.objid%TYPE;
   objversion_ TEMPORARY_PART_TRACKING.objversion%TYPE;
   remrec_     TEMPORARY_PART_TRACKING_TAB%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(session_id_, serial_no_);
   Check_Delete___(remrec_);
   Get_Id_Version_By_Keys___(objid_,
                             objversion_,
                             remrec_.session_id,
                             remrec_.serial_no);
   Delete___(objid_, remrec_);
END Remove_Serial___;


PROCEDURE Add_Serials_To_Session___ (
   session_id_       IN NUMBER, 
   serial_catch_tab_ IN Inventory_Part_In_Stock_API.Serial_Catch_Table,
   validate_         IN BOOLEAN )
IS
   objid_      TEMPORARY_PART_TRACKING.objid%TYPE;
   objversion_ TEMPORARY_PART_TRACKING.objversion%TYPE;
   newrec_     TEMPORARY_PART_TRACKING_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   IF (serial_catch_tab_.COUNT > 0) THEN
      FOR i IN serial_catch_tab_.FIRST..serial_catch_tab_.LAST LOOP
         IF (validate_) THEN
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('SESSION_ID', session_id_, attr_);
            Client_SYS.Add_To_Attr('SERIAL_NO', serial_catch_tab_(i).serial_no, attr_);
            Client_SYS.Add_To_Attr('CATCH_QTY', serial_catch_tab_(i).catch_qty, attr_);
            Unpack___(newrec_, indrec_, attr_);
            Check_Insert___(newrec_, indrec_, attr_);
         ELSE
            newrec_.session_id := session_id_;
            newrec_.serial_no  := serial_catch_tab_(i).serial_no;
            newrec_.catch_qty  := serial_catch_tab_(i).catch_qty;
         END IF;
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
   END IF;
END Add_Serials_To_Session___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT temporary_part_tracking_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   contract_               VARCHAR2(5);
   part_no_                VARCHAR2(25);
   identification_context_ VARCHAR2(25) := 'OTHER';
BEGIN
   contract_ := Client_SYS.Get_Item_Value('CONTRACT',attr_);
   part_no_  := Client_SYS.Get_Item_Value('PART_NO',attr_);
   identification_context_ := Client_SYS.Get_Item_Value('IDENTIFICATION_CONTEXT',attr_);
   super(newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'CONTRACT', contract_);
   Error_SYS.Check_Not_Null(lu_name_, 'PART_NO', part_no_);
   
   IF (identification_context_ != 'POSITIVE_COUNTING_DIFF') THEN
      Validate_Serial(contract_, part_no_, newrec_.serial_no);
   END IF;
END Check_Insert___;

@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ temporary_part_tracking_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Record_Exist(lu_name_, 'DUPLICATE: Serial number :P1 has been entered more than once.', rec_.serial_no);
   super(rec_);   
END Raise_Record_Exist___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Get_Serials__ (
   serial_catch_tab_ OUT Inventory_Part_In_Stock_API.Serial_Catch_Table,
   session_id_       IN  NUMBER )
IS
BEGIN
   Get_Serials___(serial_catch_tab_, session_id_);
END Get_Serials__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Identify_Serial_On_Reservation (
   source_type_db_   IN VARCHAR2,
   source_ref_1_     IN VARCHAR2,
   source_ref_2_     IN VARCHAR2,
   source_ref_3_     IN VARCHAR2,
   source_ref_4_     IN VARCHAR2,
   source_ref_5_     IN VARCHAR2,
   source_ref_6_     IN VARCHAR2,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   catch_qty_        IN NUMBER )
IS
   session_id_       NUMBER;
BEGIN
   session_id_ := Temporary_Part_Tracking_API.Get_Next_Session_Id;
   New(session_id_, serial_no_, catch_qty_, contract_, part_no_, identification_context_ => 'OTHER');
   Split_Reservation(session_id_,
                     source_type_db_,
                     source_ref_1_,
                     source_ref_2_,
                     source_ref_3_,
                     source_ref_4_,
                     source_ref_5_,
                     source_ref_6_,
                     contract_,
                     part_no_,
                     configuration_id_,
                     location_no_,
                     lot_batch_no_,
                     eng_chg_level_,
                     waiv_dev_rej_no_,
                     activity_seq_,
                     handling_unit_id_);
END Identify_Serial_On_Reservation; 


-- This method is used by DataCaptAttachPartHu, DataCaptIssueInvPart, DataCaptIssueMtrlReq, DataCaptScrapInvPart,
-- DataCaptReportPickPart, DataCaptManIssSoPart, DataCaptRepPickPartSo, DataCaptManIssueWo and DataCaptUnplanIssueWo
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   configuration_id_   IN VARCHAR2, 
   capture_session_id_ IN NUMBER,
   column_name_        IN VARCHAR2,
   lov_type_db_        IN VARCHAR2,
   customer_no_        IN VARCHAR2 DEFAULT NULL)
IS
   TYPE Get_Lov_Values       IS REF CURSOR;
   get_lov_values_           Get_Lov_Values;
   stmt_                     VARCHAR2(2000);
   TYPE Lov_Value_Tab        IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_            Lov_Value_Tab;
   second_column_name_       VARCHAR2(200);
   second_column_value_      VARCHAR2(200);
   lov_item_description_     VARCHAR2(200);
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_View_Column('TEMPORARY_PART_TRACKING_SERIAL', column_name_);

      stmt_ := ' FROM   TEMPORARY_PART_TRACKING_SERIAL
                 WHERE  contract         = NVL(:contract_,         contract)
                 AND    part_no          = NVL(:part_no_,          part_no)
                 AND    serial_no        = NVL(:serial_no_,        serial_no)
                 AND    configuration_id = NVL(:configuration_id_, configuration_id)
                 AND    lot_batch_no     = NVL(:lot_batch_no_,     lot_batch_no) 
                 AND    Inventory_Part_In_Stock_API.Check_Individual_Exist(part_no, serial_no) = 0
                 AND    (part_ownership_db = ''COMPANY OWNED'' OR (part_ownership_db = ''CUSTOMER OWNED'' AND owning_customer_no = :customer_no_))';

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK and can have the normal order since only 1 value will be picked anyway
         stmt_ := 'SELECT ' || column_name_ || stmt_ || ' ORDER BY Utility_SYS.String_To_Number (' || column_name_ || ') ASC, ' || column_name_ || ' ASC' ;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_ || stmt_ || ' ORDER BY Utility_SYS.String_To_Number (' || column_name_ || ') ASC, ' || column_name_ || ' ASC';
      END IF;
      @ApproveDynamicStatement(2014-11-03,CHJALK)
      OPEN get_lov_values_ FOR stmt_ USING contract_,
                                           part_no_,
                                           serial_no_,
                                           configuration_id_,
                                           lot_batch_no_,
                                           customer_no_;
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;      
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('PART_NO') THEN
               second_column_name_ := 'PART_DESCRIPTION';
            ELSE
               NULL;
         END CASE;
         
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'PART_DESCRIPTION') THEN
                     second_column_value_ := Inventory_Part_API.Get_Description(contract_, lov_value_tab_(i));
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


@UncheckedAccess
FUNCTION Get_Next_Session_Id RETURN NUMBER
IS
   CURSOR get_id IS
      SELECT temporary_part_tracking_id_seq.nextval
      FROM dual;

   session_id_ NUMBER;
BEGIN
   OPEN get_id;
   FETCH get_id INTO session_id_;
   CLOSE get_id;

   RETURN session_id_;
END Get_Next_Session_Id;


@UncheckedAccess
PROCEDURE Remove_Session (
   session_id_ IN NUMBER)
IS
BEGIN
   Remove_Session___(session_id_);
   Remove_Old_Sessions___;
END Remove_Session;


PROCEDURE Split_Reservation (
   session_id_       IN NUMBER,
   source_type_db_   IN VARCHAR2,
   source_ref_1_     IN VARCHAR2,
   source_ref_2_     IN VARCHAR2,
   source_ref_3_     IN VARCHAR2,
   source_ref_4_     IN VARCHAR2,
   source_ref_5_     IN VARCHAR2,
   source_ref_6_     IN VARCHAR2,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER )
IS
   serials_tab_               Inventory_Part_In_Stock_API.Serial_Catch_Table;
   demand_res_source_type_db_ VARCHAR2(20);
BEGIN
   Get_Serials___(serials_tab_,session_id_);
  
   IF (source_type_db_ NOT IN (Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO,
                               Order_Supply_Demand_Type_API.DB_TRANSPORT_TASK,
                               Order_Supply_Demand_Type_API.DB_WORK_ORDER,
                               Order_Supply_Demand_Type_API.DB_PROJ_MISC_DEMAND,
                               Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES,
                               Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER,
                               Order_Supply_Demand_Type_API.DB_COMPONENT_REPAIR_ORDER,
                               Order_Supply_Demand_Type_API.DB_COMPONENT_REPAIR_EXCHANGE))THEN

      Inventory_Part_In_Stock_API.Split_Into_Serials(contract_         => contract_,
                                                     part_no_          => part_no_,
                                                     configuration_id_ => configuration_id_,
                                                     location_no_      => location_no_,
                                                     lot_batch_no_     => lot_batch_no_,
                                                     eng_chg_level_    => eng_chg_level_,
                                                     waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                     activity_seq_     => activity_seq_,
                                                     handling_unit_id_ => handling_unit_id_,
                                                     serial_catch_tab_ => serials_tab_,
                                                     reservation_      => TRUE);
   END IF;

   -- Here we will call PLSQL methods depending on the source type
   IF (source_type_db_ = Order_Supply_Demand_Type_API.DB_MATERIAL_REQ) THEN
      Material_Requis_Reservat_API.Split_Reservation_Into_Serials(order_no_         => source_ref_1_,
                                                                  line_no_          => source_ref_2_,
                                                                  release_no_       => source_ref_3_,
                                                                  line_item_no_     => source_ref_4_,
                                                                  part_no_          => part_no_,
                                                                  contract_         => contract_,
                                                                  configuration_id_ => configuration_id_,
                                                                  location_no_      => location_no_,
                                                                  lot_batch_no_     => lot_batch_no_,
                                                                  waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                  eng_chg_level_    => eng_chg_level_,
                                                                  activity_seq_     => activity_seq_,
                                                                  handling_unit_id_ => handling_unit_id_,
                                                                  serial_catch_tab_ => serials_tab_);
   ELSIF (source_type_db_ = Order_Supply_Demand_Type_API.DB_CUST_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Reservation_API.Split_Reservation_Into_Serials(order_no_          => source_ref_1_,
                                                                       line_no_           => source_ref_2_,
                                                                       rel_no_            => source_ref_3_,
                                                                       line_item_no_      => source_ref_4_,
                                                                       contract_          => contract_,
                                                                       part_no_           => part_no_,
                                                                       configuration_id_  => configuration_id_,
                                                                       location_no_       => location_no_,
                                                                       lot_batch_no_      => lot_batch_no_,
                                                                       eng_chg_level_     => eng_chg_level_,
                                                                       waiv_dev_rej_no_   => waiv_dev_rej_no_,
                                                                       activity_seq_      => activity_seq_,
                                                                       handling_unit_id_  => handling_unit_id_,
                                                                       pick_list_no_      => NVL(source_ref_5_,'*'),
                                                                       shipment_id_       => source_ref_6_,
                                                                       serial_catch_tab_  => serials_tab_);
      $ELSE
         NULL;
      $END
   ELSIF (source_type_db_ = Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO) THEN
      $IF Component_Shpord_SYS.INSTALLED $THEN
         Shop_Material_Assign_API.Split_Reservation_Into_Serials(order_no_          => source_ref_1_, 
                                                                 release_no_        => source_ref_2_, 
                                                                 sequence_no_       => source_ref_3_, 
                                                                 line_item_no_      => source_ref_4_,
                                                                 contract_          => contract_, 
                                                                 part_no_           => part_no_, 
                                                                 configuration_id_  => configuration_id_, 
                                                                 location_no_       => location_no_, 
                                                                 lot_batch_no_      => lot_batch_no_,
                                                                 eng_chg_level_     => eng_chg_level_, 
                                                                 waiv_dev_rej_no_   => waiv_dev_rej_no_, 
                                                                 activity_seq_      => activity_seq_, 
                                                                 handling_unit_id_  => handling_unit_id_,
                                                                 serial_catch_tab_  => serials_tab_);
      $ELSE
         NULL;            
      $END
   ELSIF (source_type_db_ = Order_Supply_Demand_Type_API.DB_PURCH_ORDER_RES) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         Purchase_Order_Reservation_API.Split_Reservation_Into_Serials(order_no_          => source_ref_1_, 
                                                                       line_no_           => source_ref_2_, 
                                                                       release_no_        => source_ref_3_, 
                                                                       line_item_no_      => source_ref_4_, 
                                                                       contract_          => contract_,
                                                                       part_no_           => part_no_, 
                                                                       location_no_       => location_no_, 
                                                                       configuration_id_  => configuration_id_, 
                                                                       lot_batch_no_      => lot_batch_no_, 
                                                                       eng_chg_level_     => eng_chg_level_,
                                                                       waiv_dev_rej_no_   => waiv_dev_rej_no_, 
                                                                       activity_seq_      => activity_seq_, 
                                                                       handling_unit_id_  => handling_unit_id_,
                                                                       serial_catch_tab_  => serials_tab_);
      $ELSE
         NULL;            
      $END
   ELSIF (source_type_db_ = Order_Supply_Demand_Type_API.DB_TRANSPORT_TASK) THEN
      Transport_Task_Line_API.Split_Into_Serials(TO_NUMBER(source_ref_1_), 
                                                        TO_NUMBER(source_ref_2_),                                                                        
                                                        serials_tab_);

   ELSIF (source_type_db_ = Order_Supply_Demand_Type_API.DB_WORK_ORDER) THEN
      $IF Component_Wo_SYS.INSTALLED $THEN  
         Maint_Material_Allocation_API.Split_Reservation_Into_Serials(wo_no_                   => source_ref_1_,
                                                                      maint_material_order_no_ => source_ref_3_, 
                                                                      line_item_no_            => source_ref_4_, 
                                                                      spare_contract_          => contract_, 
                                                                      part_no_                 => part_no_, 
                                                                      configuration_id_        => configuration_id_, 
                                                                      location_no_             => location_no_, 
                                                                      lot_batch_no_            => lot_batch_no_,
                                                                      eng_chg_level_           => eng_chg_level_, 
                                                                      waiv_dev_rej_no_         => waiv_dev_rej_no_, 
                                                                      activity_seq_            => activity_seq_, 
                                                                      handling_unit_id_        => handling_unit_id_,
                                                                      serial_catch_tab_        => serials_tab_);
      $ELSE
         NULL;            
      $END
   ELSIF (source_type_db_ = Order_Supply_Demand_Type_API.DB_PROJ_MISC_DEMAND) THEN
      $IF Component_Proj_SYS.INSTALLED $THEN
         Project_Reserved_Material_API.Split_Reservation_Into_Serials(project_demand_key_        => TO_NUMBER(source_ref_4_),
                                                                      order_supply_demand_type_  => source_type_db_,
                                                                      contract_                  => contract_,
                                                                      part_no_                   => part_no_,
                                                                      configuration_id_          => configuration_id_,
                                                                      location_no_               => location_no_,
                                                                      lot_batch_no_              => lot_batch_no_,
                                                                      eng_chg_level_             => eng_chg_level_,
                                                                      waiv_dev_rej_no_           => waiv_dev_rej_no_,
                                                                      activity_seq_              => activity_seq_,
                                                                      handling_unit_id_          => handling_unit_id_,
                                                                      session_id_                => session_id_,
                                                                      split_at_issue_            => 'FALSE');
      $ELSE
         NULL;            
      $END
   ELSIF (source_type_db_ IN (Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES, Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER)) THEN
      demand_res_source_type_db_ := Inventory_Part_Reservation_API.Get_Demand_Res_Source_Type_Db(source_type_db_);
      Inventory_Part_Reservation_API.Identify_Serials(contract_                 => contract_,
                                                      part_no_                  => part_no_,
                                                      configuration_id_         => configuration_id_,
                                                      location_no_              => location_no_,
                                                      lot_batch_no_             => lot_batch_no_,
                                                      eng_chg_level_            => eng_chg_level_,
                                                      waiv_dev_rej_no_          => waiv_dev_rej_no_,
                                                      activity_seq_             => activity_seq_,
                                                      handling_unit_id_         => handling_unit_id_, 
                                                      part_tracking_session_id_ => session_id_,
                                                      source_ref_type_db_       => demand_res_source_type_db_,   
                                                      source_ref1_              => source_ref_1_,
                                                      source_ref2_              => NVL(source_ref_2_,'*'),
                                                      source_ref3_              => NVL(source_ref_3_,'*'),
                                                      source_ref4_              => NVL(source_ref_4_,'*'),      
                                                      pick_list_no_             => (CASE source_ref_5_ WHEN '*' THEN 0 ELSE NVL(source_ref_5_, 0) END),
                                                      shipment_id_              => source_ref_6_);
                                                      
   ELSIF (source_type_db_ = Order_Supply_Demand_Type_API.DB_DESIGN_OBJECT_DEMAND) THEN
      $IF Component_Plades_SYS.INSTALLED  $THEN   
         Plant_Reserved_Material_API.Split_Reservation_Into_Serials(plant_part_seq_no_ => TO_NUMBER(source_ref_1_),
                                                                    contract_          => contract_,
                                                                    part_no_           => part_no_,
                                                                    configuration_id_  => configuration_id_,
                                                                    location_no_       => location_no_,
                                                                    lot_batch_no_      => lot_batch_no_,
                                                                    eng_chg_level_     => eng_chg_level_,
                                                                    waiv_dev_rej_no_   => waiv_dev_rej_no_,
                                                                    activity_seq_      => activity_seq_,
                                                                    handling_unit_id_  => handling_unit_id_,
                                                                    session_id_        => session_id_);
      $ELSE
         NULL;            
      $END                                                                    
   ELSIF (source_type_db_ = Order_Supply_Demand_Type_API.DB_COMPONENT_REPAIR_ORDER) THEN
      $IF Component_Cromfg_SYS.INSTALLED $THEN
         Cro_Reservation_API.Split_Reservation_Into_Serials(cro_no_           => source_ref_1_,
                                                            line_number_      => source_ref_2_,
                                                            contract_         => contract_,
                                                            part_no_          => part_no_,
                                                            configuration_id_ => configuration_id_,
                                                            location_no_      => location_no_,
                                                            lot_batch_no_     => lot_batch_no_,
                                                            eng_chg_level_    => eng_chg_level_,
                                                            waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                            activity_seq_     => activity_seq_,
                                                            handling_unit_id_ => handling_unit_id_,
                                                            serial_catch_tab_ => serials_tab_);
      $ELSE
         NULL;
      $END
   ELSIF (source_type_db_ = Order_Supply_Demand_Type_API.DB_COMPONENT_REPAIR_EXCHANGE) THEN
      $IF Component_Cromfg_SYS.INSTALLED $THEN
         Cro_Exchange_Reservation_API.Split_Reservation_Into_Serials(cro_no_           => source_ref_1_,
                                                                     line_number_      => source_ref_2_,
                                                                     contract_         => contract_,
                                                                     part_no_          => part_no_,
                                                                     configuration_id_ => configuration_id_,
                                                                     location_no_      => location_no_,
                                                                     lot_batch_no_     => lot_batch_no_,
                                                                     eng_chg_level_    => eng_chg_level_,
                                                                     waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                     activity_seq_     => activity_seq_,
                                                                     handling_unit_id_ => handling_unit_id_,
                                                                     serial_catch_tab_ => serials_tab_);
      $ELSE
         NULL;
      $END   
   ELSE
      Error_SYS.Record_General(lu_name_,'NOTIMPL: This source type is not supported yet.');
   END IF;

   Remove_Session(session_id_);
END Split_Reservation;


PROCEDURE Get_Serials_And_Remove_Session (
   serial_catch_tab_ OUT Inventory_Part_In_Stock_API.Serial_Catch_Table,
   session_id_       IN  NUMBER )
IS
BEGIN
   Get_Serials___(serial_catch_tab_, session_id_);
   Remove_Session(session_id_);
END Get_Serials_And_Remove_Session;


PROCEDURE Get_And_Remove_Serials (
   serial_catch_tab_  OUT Inventory_Part_In_Stock_API.Serial_Catch_Table,
   session_id_        IN  NUMBER,
   number_of_serials_ IN  NUMBER,
   part_no_           IN  VARCHAR2 DEFAULT NULL,
   lot_batch_no_      IN  VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Get_Serials___(serial_catch_tab_,
                  session_id_,
                  number_of_serials_,
                  part_no_,
                  lot_batch_no_);

   Remove_Serials___(session_id_, serial_catch_tab_);
   Remove_Old_Sessions___;
END Get_And_Remove_Serials;


@UncheckedAccess
FUNCTION Get_Number_Of_Serials (
   session_id_ IN NUMBER ) RETURN NUMBER
IS
   number_of_serials_ NUMBER;

   CURSOR get_number_of_serials IS
      SELECT COUNT(*)
        FROM TEMPORARY_PART_TRACKING_TAB
       WHERE session_id = session_id_;
BEGIN
   OPEN  get_number_of_serials;
   FETCH get_number_of_serials INTO number_of_serials_;
   CLOSE get_number_of_serials;

   RETURN (number_of_serials_);
END Get_Number_Of_Serials;


FUNCTION Get_Splitted_Session (
   session_id_        IN NUMBER,
   number_of_serials_ IN NUMBER ) RETURN NUMBER
IS
   new_session_id_   TEMPORARY_PART_TRACKING_TAB.session_id%TYPE;
   serial_catch_tab_ Inventory_Part_In_Stock_API.Serial_Catch_Table;
BEGIN
   new_session_id_ := Get_Next_Session_Id;
   Get_And_Remove_Serials(serial_catch_tab_, session_id_, number_of_serials_);
   Add_Serials_To_Session___(new_session_id_, serial_catch_tab_, validate_ => FALSE);

   RETURN (new_session_id_);
END Get_Splitted_Session;


FUNCTION Get_Serials (
   session_id_ IN NUMBER ) RETURN Inventory_Part_In_Stock_API.Serial_Catch_Table
IS
   serial_catch_tab_ Inventory_Part_In_Stock_API.Serial_Catch_Table;
BEGIN
   Get_Serials___(serial_catch_tab_, session_id_);

   RETURN (serial_catch_tab_);
END Get_Serials;


PROCEDURE Validate_Serial (
   contract_   IN VARCHAR2,
   part_no_    IN VARCHAR2,
   serial_no_  IN VARCHAR2 )
IS
   latest_invent_transaction_id_ NUMBER;
   serial_stored_on_contract_    VARCHAR2(5);
BEGIN
   Part_Serial_Catalog_API.Exist(part_no_, serial_no_);

   IF (Part_Serial_Catalog_API.Is_In_Inventory(part_no_, serial_no_) = Fnd_Boolean_API.DB_FALSE) THEN
      Error_SYS.Record_General(lu_name_, 'SPLITSERPOS: The current position of serial :P1 is :P2.', part_no_||','||serial_no_, Part_Serial_Catalog_API.Get_State(part_no_, serial_no_));
   END IF;
   
   latest_invent_transaction_id_ := Part_Serial_History_API.Get_Latest_Inv_Transaction_Id(part_no_, serial_no_);
   serial_stored_on_contract_    := Inventory_Transaction_Hist_API.Get_Transaction_Contract(latest_invent_transaction_id_);

   IF (serial_stored_on_contract_ != contract_) THEN
      Error_SYS.Record_General(lu_name_, 'SPLITSERSITE: Serial :P1 is In Inventory on site :P2', part_no_||','||serial_no_, serial_stored_on_contract_);
   END IF;
END Validate_Serial;


PROCEDURE New (
   session_id_             IN NUMBER,
   serial_no_              IN VARCHAR2,
   catch_qty_              IN NUMBER,
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   identification_context_ IN VARCHAR2)
IS
   attr_       VARCHAR2(2000);
   objid_      TEMPORARY_PART_TRACKING.objid%TYPE;
   objversion_ TEMPORARY_PART_TRACKING.objversion%TYPE;
   newrec_     TEMPORARY_PART_TRACKING_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SESSION_ID', session_id_, attr_);
   Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);
   Client_SYS.Add_To_Attr('CATCH_QTY', catch_qty_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('IDENTIFICATION_CONTEXT', identification_context_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


FUNCTION New_Clob (
   serial_no_attr_   IN CLOB,
   session_id_       IN NUMBER,
   catch_qty_        IN NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2 ) RETURN CLOB
IS
   dummy_number_     NUMBER;
   attr_             VARCHAR2(32000);
   indrec_           Indicator_Rec;
   serial_no_tab_    Utility_SYS.STRING_TABLE;
   objid_            temporary_part_tracking.objid%TYPE;
   objversion_       temporary_part_tracking.objversion%TYPE;
   newrec_           temporary_part_tracking_tab%ROWTYPE;   
BEGIN
   Utility_SYS.Tokenize(serial_no_attr_, Client_SYS.record_separator_, serial_no_tab_, dummy_number_);

   IF (serial_no_tab_.COUNT > 0) THEN
      FOR i_ IN serial_no_tab_.FIRST..serial_no_tab_.LAST LOOP
         Client_SYS.Clear_Attr(attr_);
         newrec_.session_id := session_id_;
         newrec_.serial_no := serial_no_tab_(i_);
         newrec_.catch_qty := catch_qty_;
         Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
         Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
         
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
   END IF;   
   RETURN Client_SYS.Get_All_Info;
END New_Clob;


PROCEDURE Remove (
   session_id_ IN NUMBER,
   serial_no_  IN VARCHAR2 )
IS
   remrec_ temporary_part_tracking_tab%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(session_id_, serial_no_);
   Remove___(remrec_);
END Remove;


PROCEDURE Modify_Catch_Qty (
   session_id_       IN NUMBER,
   serial_no_        IN VARCHAR2,
	catch_qty_        IN NUMBER)
IS
   newrec_   temporary_part_tracking_tab%ROWTYPE;
BEGIN
   newrec_           := Lock_By_Keys___(session_id_, serial_no_);
   newrec_.catch_qty := catch_qty_;
   Modify___ (newrec_);
END Modify_Catch_Qty;
