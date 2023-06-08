-----------------------------------------------------------------------------
--
--  Logical unit: PartSerialHistory
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211101  NEKOLK  AM21R2-2960 : EQUIP redesign PARTCA changes : alternate_id obsolete work.
--  210203  jagrno  Bug 157113 (MFZ-6254). Added method Get_Previous_Oper_Status_Db.
--  210101  SBalLK  Issue SC2020R1-11830, Modified both New(), Inherit_When_Removing_Renamed() and Set_Inv_Transaction_Id_On_Last() methods by removing attr_
--  210101          functionality to optimize the performance.
--  171120  DiKuLk  Bug 137558, Modified Current_Position_Is_Changed() in order to avoid consecutive COUNT-OUT and COUNT-IN being marked as a position change.
--  171120          Added method Is_Counting_Transaction___.
--  170908  ShPrlk  STRSC-11964, Modified Get_Latest_Issue_Transaction to optimize and make it less error prone. 
--  170119  ShPrlk  Bug 133695, Modified Get_Latest_Issue_Transaction to make line_item_no available in Public_Rec for VIM component correction.
--  160921  JeeJlk  Bug 131209, Modified Current_Position_Is_Changed to allow for canceling PO receipts if the earliest and the latest current positions are 'InInventory'  
--  160921          and in between the change of current position is only to 'UnderTransportation'.
--  161208  MeAblk  Bug 132933, Modified Inherit_When_Removing_Renamed() to correctly rename the attribute INV_TRANSSACTION_ID to its correct name.
--  150625  NaSalk  RED-543, Added Get_Latest_Inv_Trans_Owenrship.
--  150622  NaSalk  RED-543, Added fa_object_company_ and fa_object_id_ to New method.
--  140408  Cpeilk  Bug 114430, Added new methods Get_Renamed_From_Serials, Get_Renamed_To_Serials and 
--  140408          Get_Current_Identity. Added new table type Part_Serial_Tab.
--  121204  NaSalk  Modifed  Unpack_Check_Insert___.
--  121115  NaSalk  Modified Unpack_Check_Insert___ to add validations for Supplier Rented and Company Rental Asset Ownerships.
--  130729  MaIklk  TIBE-1047, Removed global constants and used conditional compilation instead.
--  120118  ChJalk  Added ENUMERATION for the column rename_reason.
--  110615  LEPESE  Added method Set_Inv_Transaction_Id_On_Last.
--  110503  LEPESE  Added method Get_Operational_Condition_Db.
--  110217  LEPESE  Changed implementation of method Check_Exist to find any record with matching parameters.
--  110215  RaKalk  Renamed Is_Serials_Created to Check_Exist.
--  110215  Rakalk  Added function Is_Serials_Created
--  100423  KRPELK  Merge Rose Method Documentation.
--  091119  PraWlk  Bug 87075, Removed attribute rename_reason from PART_SERIAL_RENAME_BACK_HIST and \
--  091119          PART_SERIAL_REN_BACK_HIST_ALL views.
--  091022  HoInlk  Bug 86113, Added methods Completely_Reversed___ and Get_Previous_Current_Position.
--  090929  MaJalk  Removed unused variables.
--  ---------------------------- 13.0.0 ------------------------------------------
--  091119  PraWlk  Bug 87075, Removed attribute rename_reason from PART_SERIAL_RENAME_BACK_HIST and \
--  091119          PART_SERIAL_REN_BACK_HIST_ALL views.
--  091022  HoInlk  Bug 86113, Added methods Completely_Reversed___ and Get_Previous_Current_Position.
--  090813  PraWlk  Bug 82147, Added public attribute rename_reason to views PART_SERIAL_HISTORY, PART_SERIAL_REN_AHEAD_HIST_ALL, 
--  090813          PART_SERIAL_REN_BACK_HIST_ALL, PART_SERIAL_RENAME_AHEAD_HIST and PART_SERIAL_RENAME_BACK_HIST. Modified New. 
--  090813          Added Only_In_Facility_Or_Contained to check the position of a serial and Inherit_When_Removing_Renamed
--  090813          to inherit history from a renamed serial that is getting removed. 
--  090220  DAYJLK  Bug 79125, Added functions Get_Line_No, Get_Release_No, Get_Inv_Transsaction_Id, and 
--  090220          Get_Latest_Issue_Transaction. Modified the public Get method to fetch the new attributes 
--  090220          which were added to the Public record.
--  080104  MaEelk  Bug 69186, Modified Current_Position_Is_Changed to filter records
--  080104          having a reference to an inventory transaction
--  071204  IsAnlk  Bug 69352, Made order_no as public and added function Get_Latest_With_Source_Ref to  
--                  return source reference details of latest serial history. 
--  070717  DAYJLK  Added function Get_Earliest_Transaction_Date.
--  -------------------------- Wings Merge End -----------------------------------
--  070426  KaDilk  Added view comments to views VIEW_FORWARD_ALL and VIEW_BACKWARD_ALL.
--  070129  DAYJLK  Merged Wings Code.
--  070117  DAYJLK  Modified names of the four new views added earlier.
--  070101  DAYJLK  Added views PART_SER_REN_FORWARD_HIST_ALL and PART_SER_REN_BACKWARD_HIST_ALL.
--  070101          Modified function name Rename_Allowed to Renaming_Serial_To_Prior_Name. Modified view names
--  070101          PART_SERIAL_FORWARD_HIST and PART_SERIAL_BACKWARD_HIST to PART_SER_RENAME_FORWARD_HIST and 
--  070101          PART_SER_RENAME_BACKWARD_HIST respectively.
--  061208  DAYJLK  Added public methods Rename_Allowed and Get_Latest_Inv_Transaction_Id.
--  061208          Included new attributes renamed_to_part_no,renamed_to_serial_no, renamed_from_part_no 
--  061208          and renamed_from_serial_no in views and in methods which take care of Insert and Update.
--  061208          Modified method New to include new attributes mentioned above as parameters.
--  061208          Added views PART_SERIAL_FORWARD_HIST and PART_SERIAL_BACKWARD_HIST.
--  -------------------------- Wings Merge Start ---------------------------------
--  061206  NaLwlk  Bug 60731, Added Current_Position_Is_Changed to check whether serial part position is changed.
--  060727  ThGulk  Added &OBJID instead of rowif in Procedure Insert___
--  060502  MarSlk  Bug 56279, Added Get_Latest_Trans_Order_Type to get the order type for a serial part
--  060425  MarSlk  Bug 56596, Added Get_Description method to get the part description from Part_Catalog_API.
--  060418  NaLrlk  Enlarge Identity - Changed view comments.
--  ------------------------- 12.4.0 ---------------------------------------------
--  060123  JaJalk  Added Assert safe annotation.
--  060110  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  050125  SaJjlk  Removed unused methods Modify_Superior_Alt_Contract and Modify_Superior_Alternate_Id.
--  040428  KeSmus  EM01 - Reconciled model work which added a relationship to
--                  MaintLevel and changed attribute name PartialMaintLevel to
--                  PartialDisassemblyLevel.
--  040209  KeSmUs  EM01 - Added new attributes PartialSourceOrder, PartialSourceReleaseNo,
--                  PartialSourceSeqNo, PartialDestOrder, PartialDestReleaseNo
--                  PartialDestSeqNo and PartialMaintLevel.
--  040225  LoPrlk  Removed substrb from code. DEFINE STATE and &VIEW were altered.
--  031231  IsAnLk  Added derived column current_position_db. Added block comments to avoid red codes.
--  031205  AnLaSe  Bug 40252, removed method Check_Issued_Serial_No_Exist.
--  031020  AnLaSe  Call Id 108128: Added reference to OrderType.
--                  Made sure that DB-value is saved in table - very important!
--                  Encoded order_type to DB-value in method New.
--                  Corrected bug 37091 - replaced 'Project' with dbvalue 'PROJECT' in Check_Issued_Serial_No_Exist.
--  030804  DAYJLK  Performed SP4 Merge.
--  030508  JaBalk  Bug 37091, Added Check_Issued_Serial_No_Exist.
--  030429  JaBalk  Bug 37075, Reverse the correction of 34371.
--  030429  DAYJLK  Modified methods Unpack_Check_Insert__ and Unpack_Check_Update___.
--  030325  MaGulk  Modified method New to include owner code information
--  030319  MaGulk  Added columns part_ownership, owning_vendor_no, owning_customer_no and
--                  corresponding methods for owner code functionality.
--  030102  JaBalk  Bug 34371, Added Check_Issued_Serial_No_Exist.
--  020708  paskno  Added more parameters to method New.
--  020707  PASKNO  Added columns user_created, eng_part_revision, manufacturer_no, manufacturer_part_no, acquisition_cost,
--                  currency_code, owner_id, alternate_id, alternate_contract and inv_transsaction_id.
--  020612  PEKR    Added column current_position_db in view.
--  020603  JoAnSe  Added new overlodaded New method with non-attribute string parameters.
--  020522  CHFOLK  Extended the length to VARCHAR2(50) of the view comments of columns, serial_no and superior_serial_no.
--  020517  PEKR    Added columns current_position, operational_condition, operational_status, locked_for_update, history_purpose.
--                  Added Set_Item_Value in New for the new columns.
--  *************************** AV 2002 - 3 Baseline *********************************************************************
--  001221  ANLASE  Replaced prompt Contract with Site in view comments.
--  001205  SHVE    Increased length of release_no from VARCHAR2(4) to VARCHAR2(30).
--  000925  JOHESE  Added undefines.
--  000301  ROOD    Increased the length of order_type.
--  990414  FRDI    Upgraded to performance optimized template.
--  981201  JOHW    Added function Get_Latest_Sequence_No and procedures
--                  Modify_Superior_Alternate_Id and
--                  Modify_Superior_Alternate_Contract by
--  980423  TOWI    IID value order type treatment is changed
--  980421  TOWI    Changed order type reference to Lu OrderTypePartCatalog
--  980407  TOWI    Added Reference with cascade to PartSerialCatalog
--  980401  TOWI    Adapt code to IID OrderType
--  980330  TOWI    Added ref to OrderType
--  980306  TOWI    Removed ref to PartSerialCatalog
--  980217  ERJA    Removed else statement in unpack_check_insert
--  980206  CAJO    Corrections in procedure New.
--  980205  TOWI    Commented check on not null for sequence_no.
--  980128  TOWI    Changes in method New.
--  980127  TOWI    Added column Line_Item_No.
--  980125  TOWI    Changed some name of attributes and methods.
--  971212  ERJA    Removed columns line_no, release_no
--  970821  STSU    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Serial_History_Tab IS TABLE OF part_serial_history_tab%ROWTYPE
INDEX BY PLS_INTEGER;

TYPE Part_Serial_Rec IS RECORD (
   part_no   part_serial_history_tab.part_no%TYPE,
   serial_no part_serial_history_tab.serial_no%TYPE);

TYPE Part_Serial_Tab IS TABLE OF Part_Serial_Rec
INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Seq___ RETURN NUMBER
IS
   CURSOR serial_history_seq IS
      SELECT part_serial_history_seq.nextval
      FROM dual;
   next_row_   NUMBER;
BEGIN
   OPEN serial_history_seq;
   FETCH serial_history_seq INTO next_row_;
   CLOSE serial_history_seq;
   RETURN next_row_;
END Get_Next_Seq___;


-- Completely_Reversed___
--   Returns TRUE if the inventory transaction has been completely reversed.
FUNCTION Completely_Reversed___ (
   inv_transaction_id_  IN NUMBER ) RETURN BOOLEAN
IS
   completely_reversed_ NUMBER := 0;   
BEGIN
   $IF (Component_Invent_SYS.INSTALLED) $THEN     
      IF Inventory_Transaction_Hist_API.Is_Completely_Reversed(inv_transaction_id_) THEN
         completely_reversed_ := 1;
      END IF;               
   $END
   RETURN (completely_reversed_ = 1);
END Completely_Reversed___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT part_serial_history_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- server defaults
   newrec_.user_created := Fnd_Session_API.Get_Fnd_User;
   IF (newrec_.sequence_no IS NULL) THEN
      -- Next sequence number for column sequence_no is fetched
      newrec_.sequence_no := Get_Next_Seq___;
      Client_SYS.Add_To_Attr( 'SEQUENCE_NO', newrec_.sequence_no, attr_ );
   END IF;

   IF (newrec_.renamed_to_serial_no IS NULL) THEN
      newrec_.rename_reason := NULL; 
   END IF;
   IF (newrec_.user_created IS NULL) THEN
      newrec_.user_created := Fnd_Session_API.Get_Fnd_User;
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT part_serial_history_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   IF (newrec_.owning_vendor_no IS NOT NULL) THEN
      $IF (NOT Component_Purch_SYS.INSTALLED) $THEN
         Error_SYS.Record_General(lu_name_, 'BLOCKSUPPLIER: A Supplier may not be specified as Owner when Purchasing is not installed.');              
      $ELSE
         NULL;
      $END
   END IF;
   IF (newrec_.owning_customer_no IS NOT NULL) THEN
      $IF (NOT Component_Order_SYS.INSTALLED) $THEN
         Error_SYS.Record_General(lu_name_, 'BLOCKCUSTOMER: A Customer may not be specified as Owner when Customer Orders is not installed.');
      $ELSE
         NULL;
      $END
   END IF;
   IF (newrec_.renamed_to_serial_no IS NOT NULL) THEN
      Part_Serial_Catalog_API.Exist(newrec_.renamed_to_part_no, newrec_.renamed_to_serial_no);
   END IF;
   IF (newrec_.renamed_from_serial_no IS NOT NULL) THEN
      Part_Serial_Catalog_API.Exist(newrec_.renamed_from_part_no, newrec_.renamed_from_serial_no);
   END IF;
   IF (newrec_.renamed_to_serial_no IS NOT NULL) THEN
      Error_SYS.Check_Not_Null(lu_name_, 'RENAME_REASON', newrec_.rename_reason);
   END IF;
   IF (newrec_.renamed_from_part_no IS NULL) AND (newrec_.renamed_from_serial_no IS NOT NULL) THEN
     Error_SYS.Record_General(lu_name_, 'RENFROMPARTNO: Renamed From Part No should be specified when Renamed From Serial No contains a value.');
   END IF;
   IF (newrec_.renamed_from_part_no IS NOT NULL) AND (newrec_.renamed_from_serial_no IS NULL) THEN
     Error_SYS.Record_General(lu_name_, 'RENFROMSERIAL: Renamed From Serial No should be specified when Renamed From Part No contains a value.');
   END IF;
   IF (newrec_.renamed_to_part_no IS NULL) AND (newrec_.renamed_to_serial_no IS NOT NULL) THEN
     Error_SYS.Record_General(lu_name_, 'RENTOPARTNO: Renamed To Part No should be specified when Renamed To Serial No contains a value.');
   END IF;
   IF (newrec_.renamed_to_part_no IS NOT NULL) AND (newrec_.renamed_to_serial_no IS NULL) THEN
     Error_SYS.Record_General(lu_name_, 'RENTOSERIAL: Renamed To Serial No should be specified when Renamed To Part No contains a value.');
   END IF;
   IF (newrec_.renamed_from_part_no IS NOT NULL) AND (newrec_.renamed_to_part_no IS NOT NULL) THEN
     Error_SYS.Record_General(lu_name_, 'RENFROMTOPART: Both Renamed To Part No and Renamed From Part No may not be specified at the same time.');
   END IF;

   IF (newrec_.part_ownership IN (Part_Ownership_API.DB_COMPANY_OWNED, 
                                  Part_Ownership_API.DB_COMPANY_RENTAL_ASSET)) THEN
      IF (newrec_.owning_vendor_no IS NOT NULL) OR (newrec_.owning_customer_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'BLOCKOWNER: Owner should not be specified for :P1 Stock.', Part_Ownership_API.Decode(newrec_.part_ownership) );
      END IF;
   END IF;

   IF (newrec_.owning_vendor_no IS NOT NULL) AND (newrec_.owning_customer_no IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'BLOCKDUALOWNERS: Both Supplier and Customer cannot be specified as owners for an Inventory Part.');
   END IF;

   IF (newrec_.part_ownership = Part_Ownership_API.DB_CUSTOMER_OWNED) AND (newrec_.owning_customer_no IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDOWNER: Owner should be specified for :P1 stock.', Part_Ownership_API.Decode(newrec_.part_ownership));
   END IF;

   IF (newrec_.part_ownership IN (Part_Ownership_API.DB_CONSIGNMENT, 
                                  Part_Ownership_API.DB_SUPPLIER_LOANED, 
                                  Part_Ownership_API.DB_SUPPLIER_RENTED)) 
       AND (newrec_.owning_vendor_no IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDOWNER: Owner should be specified for :P1 stock.', Part_Ownership_API.Decode(newrec_.part_ownership));
   END IF;
END Check_Insert___;

FUNCTION Is_Counting_Transaction___ (
   transaction_id_      IN NUMBER ) RETURN BOOLEAN
IS
   counting_transaction_   BOOLEAN := FALSE;    
BEGIN
   IF transaction_id_ IS NOT NULL THEN
      $IF Component_Invent_SYS.INSTALLED $THEN
         counting_transaction_ := (Mpccom_Transaction_Code_API.Get_Order_Type_Db(Inventory_Transaction_Hist_API.Get_Transaction_Code(transaction_id_)) = Order_Type_API.DB_COUNTING);         
      $ELSE
         NULL;
      $END      
   END IF;
   RETURN counting_transaction_;
END Is_Counting_Transaction___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new record in part serial history.
--   The attribute values passed in are combined with the current values
--   for the related record in Part Serial Catalog when creating the new record.
--   Current values from the record in part serial catalog will be merged
--   with the parameter values, and a new history record will be created
--   for actual serial part.
PROCEDURE New (
   part_no_                   IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   history_purpose_db_        IN VARCHAR2,
   transaction_description_   IN VARCHAR2,
   order_type_                IN VARCHAR2 DEFAULT NULL,
   order_no_                  IN VARCHAR2 DEFAULT NULL,
   line_no_                   IN VARCHAR2 DEFAULT NULL,
   release_no_                IN VARCHAR2 DEFAULT NULL,
   line_item_no_              IN NUMBER   DEFAULT NULL,
   inv_transsaction_id_       IN NUMBER   DEFAULT NULL,
   eng_part_revision_         IN VARCHAR2 DEFAULT NULL,
   manufacturer_no_           IN VARCHAR2 DEFAULT NULL,
   manufacturer_part_no_      IN VARCHAR2 DEFAULT NULL,
   acquisition_cost_          IN NUMBER   DEFAULT NULL,
   currency_code_             IN VARCHAR2 DEFAULT NULL,
   owner_id_                  IN VARCHAR2 DEFAULT NULL,
   renamed_from_part_no_      IN VARCHAR2 DEFAULT NULL,
   renamed_from_serial_no_    IN VARCHAR2 DEFAULT NULL,
   renamed_to_part_no_        IN VARCHAR2 DEFAULT NULL,
   renamed_to_serial_no_      IN VARCHAR2 DEFAULT NULL,
   rename_reason_db_          IN VARCHAR2 DEFAULT NULL,
   fa_object_company_         IN VARCHAR2 DEFAULT NULL,
   fa_object_id_              IN VARCHAR2 DEFAULT NULL,
   transaction_date_          IN DATE     DEFAULT NULL,
   partial_disassembly_level_ IN VARCHAR2 DEFAULT NULL,
   partial_source_order_no_   IN VARCHAR2 DEFAULT NULL,
   partial_source_release_no_ IN VARCHAR2 DEFAULT NULL,
   partial_source_seq_no_     IN VARCHAR2 DEFAULT NULL,
   partial_dest_order_no_     IN VARCHAR2 DEFAULT NULL,
   partial_dest_release_no_   IN VARCHAR2 DEFAULT NULL,
   partial_dest_seq_no_       IN VARCHAR2 DEFAULT NULL)
IS
   part_serial_rec_       Part_Serial_Catalog_API.Public_Rec;
   newrec_                part_serial_history_tab%ROWTYPE;
   order_type_db_         VARCHAR2(20);
BEGIN
   part_serial_rec_ := Part_Serial_Catalog_API.Get(part_no_, serial_no_);
   order_type_db_   := Order_Type_API.Encode(order_type_);

   newrec_.part_no                     := part_no_;
   newrec_.serial_no                   := serial_no_;
   newrec_.history_purpose             := history_purpose_db_;
   newrec_.order_no                    := order_no_;
   newrec_.line_no                     := line_no_;
   newrec_.release_no                  := release_no_;
   newrec_.line_item_no                := line_item_no_;
   newrec_.order_type                  := order_type_db_;
   newrec_.transaction_date            := NVL(transaction_date_, SYSDATE);
   newrec_.transaction_description     := transaction_description_;
   newrec_.superior_part_no            := part_serial_rec_.superior_part_no;
   newrec_.superior_serial_no          := part_serial_rec_.superior_serial_no;
   newrec_.current_position            := part_serial_rec_.rowstate;
   newrec_.operational_condition       := part_serial_rec_.operational_condition;
   newrec_.locked_for_update           := part_serial_rec_.locked_for_update;
   newrec_.operational_status          := part_serial_rec_.operational_status;
   newrec_.inv_transsaction_id         := inv_transsaction_id_;
   newrec_.eng_part_revision           := eng_part_revision_;
   newrec_.manufacturer_no             := manufacturer_no_;
   newrec_.manufacturer_part_no        := manufacturer_part_no_;
   newrec_.acquisition_cost            := acquisition_cost_;
   newrec_.currency_code               := currency_code_;
   newrec_.owner_id                    := owner_id_;
   newrec_.part_ownership              := part_serial_rec_.part_ownership;
   newrec_.owning_vendor_no            := part_serial_rec_.owning_vendor_no;
   newrec_.owning_customer_no          := part_serial_rec_.owning_customer_no;
   newrec_.renamed_from_part_no        := renamed_from_part_no_;
   newrec_.renamed_from_serial_no      := renamed_from_serial_no_;
   newrec_.renamed_to_part_no          := renamed_to_part_no_;
   newrec_.renamed_to_serial_no        := renamed_to_serial_no_;
   newrec_.rename_reason               := rename_reason_db_;
   newrec_.fa_object_company           := fa_object_company_;
   newrec_.fa_object_id                := fa_object_id_;
   newrec_.partial_disassembly_level   := partial_disassembly_level_;
   newrec_.partial_source_order_no     := partial_source_order_no_;
   newrec_.partial_source_release_no   := partial_source_release_no_;
   newrec_.partial_source_seq_no       := partial_source_seq_no_;
   newrec_.partial_dest_order_no       := partial_dest_order_no_;
   newrec_.partial_dest_release_no     := partial_dest_release_no_;
   newrec_.partial_dest_seq_no         := partial_dest_seq_no_;
   New___(newrec_);
END New;


-- Get_Latest_Sequence_No
--   Get the latest sequence number.
@UncheckedAccess
FUNCTION Get_Latest_Sequence_No (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   seq_no_   NUMBER;
   CURSOR get_latest_seq_no IS
      SELECT max(sequence_no)
      FROM part_serial_history_tab
      WHERE part_no = part_no_
      AND serial_no = serial_no_;
BEGIN
   OPEN get_latest_seq_no;
   FETCH get_latest_seq_no INTO seq_no_;
   IF (get_latest_seq_no%NOTFOUND) THEN
      CLOSE get_latest_seq_no;
      RETURN(NULL);
   END IF;
   CLOSE get_latest_seq_no;
   RETURN(seq_no_);
END Get_Latest_Sequence_No;


-- Get_Description
--   Returns the Part_no description from Part_catalog.
@UncheckedAccess
FUNCTION Get_Description (
   part_no_     IN VARCHAR2,
   serial_no_   IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Part_Catalog_API.Get_Description(part_no_);
END Get_Description;


-- Get_Latest_Trans_Order_Type
--   Returns the order type of the latest inventory transaction id for a serial part
@UncheckedAccess
FUNCTION Get_Latest_Trans_Order_Type (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_type_ part_serial_history_tab.order_type%TYPE;

   CURSOR get_order_type IS
      SELECT order_type
      FROM part_serial_history_tab
      WHERE part_no = part_no_
      AND   serial_no = serial_no_
      AND   inv_transsaction_id = (SELECT MAX(inv_transsaction_id)
                                   FROM part_serial_history_tab
                                   WHERE part_no = part_no_
                                   AND serial_no = serial_no_
                                   AND inv_transsaction_id IS NOT NULL);
BEGIN
   OPEN get_order_type;
   FETCH get_order_type INTO order_type_;
   CLOSE get_order_type;

   RETURN order_type_;
END Get_Latest_Trans_Order_Type;


-- Current_Position_Is_Changed
--   This method is used to check whether serial part position is changed.
FUNCTION Current_Position_Is_Changed (
   part_no_        IN VARCHAR2,
   serial_no_      IN VARCHAR2,
   transaction_id_ IN NUMBER ) RETURN BOOLEAN
IS
   position_changed_    BOOLEAN := FALSE;
   trans_sequence_no_ part_serial_history_tab.sequence_no%TYPE;
   trans_position_    part_serial_history_tab.current_position%TYPE;
   current_position_  part_serial_history_tab.current_position%TYPE;

   CURSOR get_part_serial_hist IS
      SELECT a.inv_transsaction_id,  a.current_position
      FROM part_serial_history_tab a
      WHERE a.part_no         = part_no_
         AND a.serial_no       = serial_no_
         AND a.history_purpose = 'CHG_CURRENT_POSITION'
         AND a.inv_transsaction_id IS NOT NULL
         AND a.sequence_no     >  trans_sequence_no_;
         
   CURSOR get_trans_seq_and_pos IS
      SELECT b.sequence_no, b.current_position
        FROM part_serial_history_tab b
       WHERE b.part_no             = part_no_
         AND b.serial_no           = serial_no_
         AND b.inv_transsaction_id = transaction_id_;
         
BEGIN

   current_position_ := Part_Serial_Catalog_API.Get_Objstate(part_no_, serial_no_);
   OPEN  get_trans_seq_and_pos;
   FETCH get_trans_seq_and_pos INTO trans_sequence_no_, trans_position_;
   CLOSE get_trans_seq_and_pos;
   
   FOR part_serial_hist_ IN get_part_serial_hist LOOP
      IF NOT Completely_Reversed___(part_serial_hist_.inv_transsaction_id) THEN
         IF NOT ((trans_position_                    = 'InInventory') AND 
                 (current_position_                  = 'InInventory') AND
                 ((part_serial_hist_.current_position IN ('UnderTransportation', 'InInventory' )) OR 
                  ((part_serial_hist_.current_position = 'Issued') AND Is_Counting_Transaction___ (part_serial_hist_.inv_transsaction_id)))) THEN
            -- If serial was received to inventory and is now also 'in inventory' and the only other position was 'Under Transportation' and In Inventory
            -- then we should not detect this situation as 'positon changed'.
            position_changed_ := TRUE;
            EXIT;
         END IF;
      END IF;
   END LOOP;
   RETURN position_changed_;
END Current_Position_Is_Changed;


-- Get_Latest_Inv_Transaction_Id
--   This function will return the latest inventory transaction id
--   connected to a part serial in the part serial history table.
@UncheckedAccess
FUNCTION Get_Latest_Inv_Transaction_Id (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   inv_transaction_id_ part_serial_history_tab.inv_transsaction_id%TYPE;

   CURSOR get_latest_inv_transaction_id IS
      SELECT MAX(inv_transsaction_id)
      FROM part_serial_history_tab
      WHERE part_no = part_no_
      AND serial_no = serial_no_
      AND inv_transsaction_id IS NOT NULL;
BEGIN
   OPEN get_latest_inv_transaction_id;
   FETCH get_latest_inv_transaction_id INTO inv_transaction_id_;
   CLOSE get_latest_inv_transaction_id;

   RETURN inv_transaction_id_;
END Get_Latest_Inv_Transaction_Id;


-- Renaming_Serial_To_Prior_Name
--   This method will check if the history table contains information that indicates
--   that the serial being renamed was once referred to by the part/serial information
--   that it will be renamed to.
@UncheckedAccess
FUNCTION Renaming_Serial_To_Prior_Name (
   from_part_no_   IN VARCHAR2,
   from_serial_no_ IN VARCHAR2,
   to_part_no_     IN VARCHAR2,
   to_serial_no_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_                  NUMBER;
   renaming_to_prior_name_ BOOLEAN:=FALSE;

   CURSOR get_history_info IS
      SELECT 1
      FROM PART_SERIAL_RENAME_BACK_HIST
      WHERE part_no = from_part_no_ AND serial_no = from_serial_no_
      AND   renamed_from_part_no = to_part_no_ AND renamed_from_serial_no = to_serial_no_;
BEGIN
   OPEN get_history_info;
   FETCH get_history_info INTO dummy_;
   IF get_history_info%FOUND THEN
      renaming_to_prior_name_ := TRUE;
   END IF;
   CLOSE get_history_info;

   RETURN renaming_to_prior_name_;
END Renaming_Serial_To_Prior_Name;


-- Get_Earliest_Transaction_Date
--   Returns the earliest transaction date of a given Serial.
@UncheckedAccess
FUNCTION Get_Earliest_Transaction_Date (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN DATE
IS
   transaction_date_    part_serial_history_tab.transaction_date%TYPE;

   CURSOR get_earliest_transaction_date IS
      SELECT MIN(transaction_date)
      FROM part_serial_history_tab
      WHERE part_no = part_no_
      AND serial_no = serial_no_;
BEGIN
   OPEN get_earliest_transaction_date;
   FETCH get_earliest_transaction_date INTO transaction_date_;
   CLOSE get_earliest_transaction_date;

   RETURN transaction_date_;
END Get_Earliest_Transaction_Date;


@UncheckedAccess
FUNCTION Get_Latest_Issue_Transaction (
   part_no_    IN VARCHAR2,
   serial_no_  IN VARCHAR2 ) RETURN Public_Rec
IS
   sequence_no_         NUMBER;
   part_serial_history_ Public_Rec;
   
   CURSOR get_attr IS
      SELECT sequence_no
      FROM part_serial_history_tab
      WHERE      part_no = part_no_
      AND        serial_no = serial_no_
      AND        current_position = 'Issued'
      AND        history_purpose = 'CHG_CURRENT_POSITION'
      ORDER BY   sequence_no DESC;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO sequence_no_;   
   CLOSE get_attr;
   
   IF (sequence_no_ IS NOT NULL) THEN  
      part_serial_history_ := Get(part_no_, serial_no_, sequence_no_);
   END IF;
   
   RETURN part_serial_history_;
END Get_Latest_Issue_Transaction;


-- Get_Latest_With_Source_Ref
--   This method will return the latest history details with source ref.
@UncheckedAccess
FUNCTION Get_Latest_With_Source_Ref (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN Public_Rec
IS
   sequence_no_         NUMBER;
   part_serial_history_ Public_Rec;

   CURSOR get_latest_seq_no IS
      SELECT MAX(sequence_no)
        FROM part_serial_history_tab
       WHERE part_no   = part_no_
         AND serial_no = serial_no_
         AND order_no IS NOT NULL;
BEGIN
   
  OPEN get_latest_seq_no;
  FETCH get_latest_seq_no INTO sequence_no_;
  CLOSE get_latest_seq_no;

  IF (sequence_no_ IS NOT NULL) THEN 
     part_serial_history_ := Part_Serial_History_API.Get(part_no_, serial_no_, sequence_no_);
  END IF;
  RETURN part_serial_history_;
END Get_Latest_With_Source_Ref;


@UncheckedAccess
FUNCTION Only_In_Facility_Or_Contained (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_                         NUMBER;
   only_in_facility_or_contained_ BOOLEAN:=TRUE;

   CURSOR exist_control IS
      SELECT 1
      FROM part_serial_history_tab
      WHERE part_no = part_no_
      AND serial_no = serial_no_
      AND current_position NOT IN ('InFacility','Contained', 'Unlocated');
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF exist_control%FOUND THEN
      only_in_facility_or_contained_ := FALSE;
   END IF;
   CLOSE exist_control;
   
   RETURN (only_in_facility_or_contained_);
END Only_In_Facility_Or_Contained;


PROCEDURE Inherit_When_Removing_Renamed (
   from_part_no_        IN VARCHAR2,
   from_serial_no_      IN VARCHAR2,
   to_part_no_          IN VARCHAR2,
   to_serial_no_        IN VARCHAR2,
   serial_history_tab_  IN Serial_History_Tab)
IS
   newrec_          part_serial_history_tab%ROWTYPE;
   remrec_          part_serial_history_tab%ROWTYPE;

   CURSOR get_renamed_from_serial_hist IS
      SELECT part_no, serial_no, sequence_no
        FROM part_serial_history_tab
       WHERE part_no                = to_part_no_
         AND serial_no              = to_serial_no_
         AND renamed_from_part_no   = from_part_no_
         AND renamed_from_serial_no = from_serial_no_; 
BEGIN

   FOR serial_history IN get_renamed_from_serial_hist LOOP
      remrec_ :=  Lock_By_Keys___(serial_history.part_no, serial_history.serial_no, serial_history.sequence_no);
      Remove___(remrec_);
   END LOOP;

   IF (serial_history_tab_.COUNT > 0) THEN
      FOR i IN serial_history_tab_.FIRST..serial_history_tab_.LAST LOOP
         IF ( serial_history_tab_(i).operational_status != 'RENAMED' ) THEN
            newrec_           := serial_history_tab_(i);
            newrec_.part_no   := to_part_no_;
            newrec_.serial_no := to_serial_no_;
            New___(newrec_);
        END IF;
      END LOOP;
   END IF;
END Inherit_When_Removing_Renamed;


FUNCTION Get_Serial_History (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2) RETURN Serial_History_Tab
IS
   CURSOR get_serial_history IS
      SELECT *
      FROM  part_serial_history_tab
      WHERE part_no = part_no_
      AND   serial_no = serial_no_;

   serial_history_tab_  Serial_History_Tab;
BEGIN
   OPEN  get_serial_history;
   FETCH get_serial_history BULK COLLECT INTO serial_history_tab_;
   CLOSE get_serial_history;
   
   RETURN serial_history_tab_;
END Get_Serial_History;


-- Get_Previous_Current_Position
--   Returns the position prior to the curront position.
FUNCTION Get_Previous_Current_Position (
   part_no_                    IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   ignore_completely_reversed_ IN BOOLEAN,
   current_position_db_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   previous_current_position_db_ part_serial_history_tab.current_position%TYPE;

   CURSOR get_history IS
   SELECT current_position, inv_transsaction_id
     FROM part_serial_history_tab
    WHERE part_no           = part_no_
      AND serial_no         = serial_no_
      AND current_position != current_position_db_
    ORDER BY sequence_no DESC;
BEGIN
   FOR history_rec_ IN get_history LOOP

      previous_current_position_db_ := history_rec_.current_position;

      IF (history_rec_.inv_transsaction_id IS NULL) THEN
         -- This position was not set by an Inventory Transaction,
         -- so we should consider it at being the previous one.
         EXIT;
      ELSE
         -- This position was set by an inventory transaction.
         IF (ignore_completely_reversed_) THEN
            -- We should ignore the position if the transaction that set it
            -- has been completely reversed
            IF NOT (Completely_Reversed___(history_rec_.inv_transsaction_id)) THEN
               -- The transaction is not completely reversed so we should consider
               -- the position that the transaction set as being the previois one
               EXIT;
            END IF;
         ELSE
            -- We should not ignore the position that was set by this inventory transaction.
            -- So we exit the loop and keep the position as previous position.
            EXIT;
         END IF;
      END IF;
   END LOOP;

   RETURN (previous_current_position_db_);
END Get_Previous_Current_Position;


@UncheckedAccess
FUNCTION Check_Exist (
   part_no_            IN VARCHAR2,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   exist_ BOOLEAN := FALSE;

   CURSOR exist_control IS
      SELECT 1
        FROM part_serial_history_tab
       WHERE part_no      = part_no_
         AND order_no     = source_ref1_
         AND line_no      = source_ref2_
         AND release_no   = source_ref3_
         AND line_item_no = source_ref4_
         AND order_type   = source_ref_type_db_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control;
   RETURN(exist_);
END Check_Exist;


@UncheckedAccess
FUNCTION Get_Operational_Condition_Db (
   inv_transsaction_id_ IN NUMBER ) RETURN VARCHAR2
IS
   operational_condition_db_ part_serial_history_tab.operational_condition%TYPE;

   CURSOR get_operational_condition_db IS
      SELECT operational_condition
        FROM part_serial_history_tab
       WHERE inv_transsaction_id = inv_transsaction_id_;
BEGIN
   OPEN  get_operational_condition_db;
   FETCH get_operational_condition_db INTO operational_condition_db_;
   CLOSE get_operational_condition_db;

   RETURN (operational_condition_db_);
END Get_Operational_Condition_Db;


PROCEDURE Set_Inv_Transaction_Id_On_Last (
   part_no_            IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   inv_transaction_id_ IN NUMBER )
IS
   sequence_no_ part_serial_history_tab.sequence_no%TYPE;
   newrec_      part_serial_history_tab%ROWTYPE;
BEGIN
   sequence_no_ := Get_Latest_Sequence_No(part_no_, serial_no_);
   newrec_      := Lock_By_Keys___(part_no_, serial_no_, sequence_no_);
   newrec_.inv_transsaction_id := inv_transaction_id_;
   Modify___(newrec_);
END Set_Inv_Transaction_Id_On_Last;


@UncheckedAccess
FUNCTION Get_Renamed_From_Serials (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN Part_Serial_Tab
IS
   CURSOR get_serial_history IS
      SELECT renamed_from_part_no, renamed_from_serial_no
        FROM PART_SERIAL_RENAME_BACK_HIST
       WHERE part_no   = part_no_
         AND serial_no = serial_no_;

   renamed_from_serial_tab_ Part_Serial_Tab;
BEGIN
   OPEN get_serial_history;
   FETCH get_serial_history BULK COLLECT INTO renamed_from_serial_tab_;
   CLOSE get_serial_history;
   
   RETURN renamed_from_serial_tab_;
END Get_Renamed_From_Serials;

   
@UncheckedAccess
FUNCTION Get_Renamed_To_Serials (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN Part_Serial_Tab
IS
   CURSOR get_serial_history IS
      SELECT renamed_to_part_no, renamed_to_serial_no
        FROM PART_SERIAL_RENAME_AHEAD_HIST
       WHERE part_no   = part_no_
         AND serial_no = serial_no_;

   renamed_to_serial_tab_ Part_Serial_Tab;
BEGIN
   OPEN get_serial_history;
   FETCH get_serial_history BULK COLLECT INTO renamed_to_serial_tab_;
   CLOSE get_serial_history;
   RETURN renamed_to_serial_tab_;
END Get_Renamed_To_Serials;

@UncheckedAccess
FUNCTION Get_Current_Identity (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN Part_Serial_Rec
IS
   renamed_to_serial_tab_ Part_Serial_Tab;
   current_identity_rec_  Part_Serial_Rec;
BEGIN
   renamed_to_serial_tab_ := Get_Renamed_To_Serials(part_no_, serial_no_);

   IF (renamed_to_serial_tab_.COUNT > 0) THEN
      current_identity_rec_ := renamed_to_serial_tab_(renamed_to_serial_tab_.LAST);
   ELSE
      current_identity_rec_.part_no   := part_no_;
      current_identity_rec_.serial_no := serial_no_;
   END IF;

   RETURN (current_identity_rec_);
END Get_Current_Identity;

@UncheckedAccess   
FUNCTION Get_Latest_Inv_Trans_Owenrship (
   part_no_           IN VARCHAR2,
   serial_no_         IN VARCHAR2,
   part_ownership_db_ IN VARCHAR2) RETURN Public_Rec
IS
   sequence_no_         NUMBER;
   part_serial_history_ Public_Rec;

   CURSOR get_seq_no IS
      SELECT sequence_no
      FROM part_serial_history_tab
      WHERE part_no   = part_no_
      AND serial_no = serial_no_
      AND inv_transsaction_id = (SELECT MAX(inv_transsaction_id)
                                      FROM part_serial_history_tab
                                      WHERE part_no = part_no_
                                      AND serial_no = serial_no_
                                      AND part_ownership = part_ownership_db_
                                      AND inv_transsaction_id IS NOT NULL);
BEGIN

  OPEN get_seq_no;
  FETCH get_seq_no INTO sequence_no_;
  CLOSE get_seq_no;

  IF (sequence_no_ IS NOT NULL) THEN 
     part_serial_history_ := Part_Serial_History_API.Get(part_no_, serial_no_, sequence_no_);
  END IF;
  RETURN part_serial_history_;
END Get_Latest_Inv_Trans_Owenrship;


-- Get_Previous_Oper_Status
--   Returns the operational status prior to the current operational status
FUNCTION Get_Previous_Oper_Status_Db (
   part_no_                    IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   ignore_completely_reversed_ IN BOOLEAN,
   current_oper_status_db_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   prev_oper_status_db_   part_serial_history_tab.operational_status%TYPE := NULL;
   --
   CURSOR get_history (
      part_no_                VARCHAR2,
      serial_no_              VARCHAR2,
      current_oper_status_db_ VARCHAR2 ) IS
      SELECT   operational_status, inv_transsaction_id
         FROM  part_serial_history_tab
         WHERE part_no = part_no_
         AND   serial_no = serial_no_
         AND   operational_status != current_oper_status_db_
         ORDER BY sequence_no DESC;
BEGIN
   FOR history_rec_ IN get_history(part_no_, serial_no_, current_oper_status_db_) LOOP
      prev_oper_status_db_ := history_rec_.operational_status;
      --
      IF (history_rec_.inv_transsaction_id IS NULL) THEN
         -- This operational status was not set by an Inventory Transaction,
         -- so we should consider it at being the previous one.
         EXIT;
      ELSE
         -- This position was set by an inventory transaction.
         IF (ignore_completely_reversed_) THEN
            -- We should ignore the position if the transaction that set it
            -- has been completely reversed
            IF NOT (Completely_Reversed___(history_rec_.inv_transsaction_id)) THEN
               -- The transaction is not completely reversed so we should consider
               -- the position that the transaction set as being the previois one
               EXIT;
            END IF;
         ELSE
            -- We should not ignore the position that was set by this inventory transaction.
            -- So we exit the loop and keep the position as previous position.
            EXIT;
         END IF;
      END IF;
   END LOOP;
   --
   RETURN (prev_oper_status_db_);
END Get_Previous_Oper_Status_Db;
