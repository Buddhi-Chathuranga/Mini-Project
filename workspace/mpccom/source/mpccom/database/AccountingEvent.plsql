-----------------------------------------------------------------------------
--
--  Logical unit: AccountingEvent
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201103  LEPESE  SCZ-12186, removed event_code 'RETPODSINT' from the set of events that are allowed to have delivery_overhead_flag set to 'Y'.
--  201103          Added override of Update___ to create a replication solution of delivery_overhead_flag setting for PODIRSH and RETPODIRSH.
--  200601  LEPESE  SC2021R1-291, Added private method Update__. Moved implementation from private Insert_Or_Update__ to
--  200601          implementation method Insert_Or_Update___. Rewrote implementation using New___ and Modify___.
--  200602          Added event codes 'WTISS', 'WTREPISS', 'CO-WTISS','WTUNISS','CO-WTUNISS' to Validate_Event___.
--  150622  MAJOSE  MONO-370, Introduced micro-cache-array
--  150513  ErSrLK  MONO-207, Modified Validate_Event___() to add SOCLOSE+, SOCLOSE- as allowed event codes for General Overhead.
--  150120  UdGnlk  PRSC-5170, Modified Validate_Event___() langauge constants to meaningful  messages.  
--  140912  Asawlk  PRSC-1950, Modified Create_Postings() by adding parameter control_type_key_rec_ and passing it to
--  140912          Mpccom_Accounting_API.Do_Accounting().
--  131112  UdGnlk  PBSC-356, Modified base view comments to align with model file errors.    
--  130828  Asawlk  TIBE-2517, Removed call to obsolete method Mpccom_Accounting_API.End_Booking.
--  121203  GanNlk  Modified Validate_Event___() to enable delivery_overhead_flag for event code 'RETPODSINT'.
--  121015  ChFolk  Modified Validate_Event___() to enable delivery_overhead_flag for event code 'RETPODIRSH'.
--  130514  ErFelk  Bug 109671, Modified Create_Postings() by adding conversion_factor as a parameter to Do_Accounting().
--  111108  PraWlk  Bug 99806, Modified Insert_Or_Update__() to update the existing records during the upgrade if it violates 
--  111108          existing validations and keep the records as it is if it does not violate the existing validations.
--  110524  MaEelk  Modified Insert_Or_Update__ to avoid installation error from 2004-1
--  100908  JoAnSe  Added Create_Postings.
--  100609  UdGnlk  Modified Validate_Event___() to enable addition_flag for event code 'WOREPISS'.
--  100426  Ajpelk  Merge rose method documentation
--  091119  PraWlk  Bug 86967, Modified Validate_Event___() to enable delivery_overhead_flag for event code 'XO-ARRIVAL' 
--  080123  LEPESE  Bug 68763, modified method Validate_Event___. Added events 'RETCREDIT','RETWORK'
--  080123          and 'SCPCREDIT' to the list of events allowed for delivery_overhead_flag = 'Y'.
--  070820  ErSrLK  Bug 65666, added method Get_Delivery_Overhead_Flag_Db.
--  070626  NaWilk  Modified methods Insert_Or_Update__ and Validate_Event___ to handle modifications of delivery_overhead_flag. 
--  070405  RaKalk  Removed description column. But the description field in the view and the get_description method will remain
--  070405          Values for that will be fetched from Mpccom_System_Event LU
--  070405  ErSrLK  Bug 62890, Added event code PSGENOH in method Validate_Event___.
--  070326  RaKalk  Modified Insert_Or_Update__ method to create the System event if it does not exist
--                  This change will be rolled back once the ins files are restructured.
--  070321  RaKalk  Added MpccomSystemEvent as the parent LU, Modified the main  view,
--  070321          unpack_check_insert___ method and Get_Description method.  And public Get method
--  070104  NiDalk  Bug 62246, Modified Insert_Or_Update__() to use Lock_By_Keys() and perform the
--  070104          update by using keys.
--  070102  RaKalk  Modified Validate_Event___ method to allow sales overhead for PODIRSH, INTPODIRSH events.
--  061218  RaKalk  Added public FndBoolean field Sales_Overhead_Flag,
--  061218          Modified Validate_Event___ method to validate Sales_Overhead_Flag.
--  061218          Modified Insert_Or_Update__ method to handle fresh instalations and upgrades.
--  ------------------------------------ 13.4.0 -------------------------------
--  051223  NuFilk  Modified method Validate_Event___ to accept 'PURDIR' for delivery overheads.
--  051221  DAYJLK  Modified Validate_Event___ to enable COSUPCONSM to have delivery overhead flag 'Y'.
--  051129  JoEd    Labor overhead flag is always set in Insert_Or_Update___.
--  051125  JoEd    Changed the ILLEGAL_FLAG message.
--  051122  JoEd    Changed validation of labor_overhead_flag.
--  051031  LEPESE  Changed parameter rec_ in method Insert_Or_Update__ to IN OUT.
--  051031          Assign null to the record just before ending the method.
--  050919  NaLrlk  Removed unused variables.
--  050823  NaLrlk  Added the event_code UNOPFDSCP and UNSODSPSCP
--  050823          when labor_overhead_flag = 'Y' in Validate_Event___
--  041026  HaPulk  Moved methods Insert_Lu_Translation from Insert___ to New__ and
--  041026          Modify_Translation from Update___ to Modify__.
--  041025  HaPulk  Modification in validation Validate_Event___.
--  041013  HaPulk  Move validations into new procedure Validate_Event___.
--  040929  HaPulk  Renamed Insert_Lu_Data_Rec__ as Insert_Or_Update__ and changed the logic.
--  040223  SaNalk Removed SUBSTRB.
--  ----------------------------- 13.3.0 --------------------------------------
--  030930  ThGulk Changed substr to substrb, instr to instrb, length to lengthb.
--  020111  DaMase  IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  000925  JOHESE  Added undefines.
--  000505  NISOSE  Changed PSBKFL-OP to PSBKFL-LA in if statement in PROCEDURE
--                  Unpack_Check_Update__ .
--  000502  NISOSE  Changed COMMENT ON COLUMN &VIEW..description from 35 to 100.
--  990511  ROOD    Added translation of flag_name_ in Unpack_Check_Update___.
--  990422  SHVE    General performance improvements.
--  990415  SHVE    Upgraded to performance optimized template.
--  990214  SHVE    Changed overhead flags for events PSBKFL,PSBKFL-OP,PSSCRAP,RPSSCRAP.
--  990208  SHVE    Replaced event_code 'CO-ARRIVAL' with 'CO-CONSUM' for deliveryoverheads.
--  990204  SHVE    Added validations for overhead flags.
--  990203  JOKE    Added column Consignment_Event.
--  981114  SHVE    Added columns general_overhead_flag,delivery_overhead_flag and
--                  labor_overhead_flag.
--  980526  JOHW    Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  980330  LEPE    Added handling of _db view columns in unpack_check methods.
--  971120  JOKE    Converted to Foundation1 2.0.0 (32-bit).
--  971015  LEPE    Changed implementation of performance enhancement on get_ functions.
--  971002  GOPE    Made the get methods to use own cursor, performance
--  970313  CHAN    Changed table name: mpc_str_event is replaced by
--                  accounting_event_tab
--  970221  JOKE    Uses column rowversion as objversion (timestamp).
--  970113  PEKR    INTSHIP and INTUNISS added to use ms_addition.
--  961126  JOBE    Modified for compatibility with workbench.
--  960828  PEKR    Add Get_Flags.
--  960812  MAOS    Removed validation and references to LU PurchaseAuthorize.
--  960611  JOKE    Added validation of IID-fields in unpack_check_update.
--  960604  AnAr    Added Remark to file.
--  960528  xxxx    Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Event___ (
   rec_ IN ACCOUNTING_EVENT_TAB%ROWTYPE )
IS
   illegal_flag  EXCEPTION;
   flag_name_    VARCHAR2(200);
BEGIN
   IF   rec_.Material_Addition_flag = 'Y'
   AND  rec_.event_code NOT IN ('SOISS','CO-SOISS','UNISS','CO-UNISS','BACFLUSH','PSBKFL','RPSREC','CO-BACFLSH','CO-PSBKFL')
      THEN flag_name_ := Language_SYS.Translate_Constant(lu_name_, 'MATERIAL_OVERHEAD: Material Overhead');
           RAISE illegal_flag;
   END IF;

   IF   rec_.Ms_Addition_flag = 'Y'
   AND  rec_.event_code NOT IN ('WOISS', 'WOREPISS', 'CO-WOISS','WOUNISS','CO-WOUNISS',
                                'WTISS', 'WTREPISS', 'CO-WTISS','WTUNISS','CO-WTUNISS',
                               'NISS','CO-NISS','INTSHIP','CO-INTSHIP','INTUNISS')
      THEN flag_name_ := Language_SYS.Translate_Constant(lu_name_, 'ADMIN_OVERHEAD: Administration Overhead');
           RAISE illegal_flag;
   END IF;

   IF   rec_.Oh1_Burden_Flag = 'Y'
   AND  rec_.event_code NOT IN ('OPFEED','UNOPFEED','TO4-MACH','TO4-NMACH','PSBKFL-OP','PSSCRAP','RPSSCRAP','RPSBKFL-OP')
      THEN flag_name_ := Language_SYS.Translate_Constant(lu_name_, 'MACHINE_OVERHEAD_1: Machine Overhead 1');
           RAISE illegal_flag;
   END IF;

   IF   rec_.Oh2_Burden_Flag = 'Y'
   AND  rec_.event_code NOT IN ('OPFEED','UNOPFEED','TO4-MACH','TO4-NMACH','PSBKFL-OP','PSSCRAP','RPSSCRAP', 'RPSBKFL-OP')
      THEN flag_name_ := Language_SYS.Translate_Constant(lu_name_, 'MACHINE_OVERHEAD_2: Machine Overhead 2');
           RAISE illegal_flag;
   END IF;

   IF   rec_.labor_overhead_flag = 'Y'
   AND  rec_.event_code NOT IN ('OPFEED','UNOPFEED','TO4-LABOR','TO4-NLABOR','PSBKFL-LA','PSSCRAP','RPSSCRAP','UNOPFDSCP','UNSODSPSCP')
      THEN flag_name_ := Language_SYS.Translate_Constant(lu_name_, 'LABOR_OVERHEAD: Labor Overhead');
           RAISE illegal_flag;
   END IF;

   IF   rec_.delivery_overhead_flag = 'Y'
   AND  rec_.event_code NOT IN ('ARRIVAL','CO-CONSUM', 'PODIRSH', 'PURDIR', 'COSUPCONSM',
                                'PODIRINTEM', 'RETCREDIT', 'RETWORK', 'SCPCREDIT', 'XO-ARRIVAL', 'RETPODIRSH')
      THEN flag_name_ := Language_SYS.Translate_Constant(lu_name_, 'DELIVERY_OVERHEAD: Delivery Overhead');
           RAISE illegal_flag;
   END IF;

   IF   rec_.general_overhead_flag = 'Y'
   AND  rec_.event_code NOT IN ('SOSTART', 'SOCLOSE+', 'SOCLOSE-', 'PSGENOH')
      THEN flag_name_ := Language_SYS.Translate_Constant(lu_name_, 'GENERAL_OVERHEAD: General Overhead');
           RAISE illegal_flag;
   END IF;

   IF (rec_.sales_overhead_flag = 'TRUE') AND
      (rec_.event_code NOT IN('OESHIP','CO-OESHIP','DELIVCONF','CO-CONSUME','PODIRSH','INTPODIRSH'))THEN

      flag_name_ := Language_SYS.Translate_Constant(lu_name_, 'SALES_OVERHEAD: Sales Overhead');
      RAISE illegal_flag;
   END IF;
EXCEPTION
   WHEN illegal_flag THEN
      Error_SYS.Record_General('AccountingEvent', 'ILLEGAL_FLAG: :P1 Flag cannot be set with event code :P2.', flag_name_, rec_.event_code);
END Validate_Event___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     accounting_event_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY accounting_event_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   IF Client_SYS.Item_Exist('DESCRIPTION', attr_) THEN
      Error_SYS.Item_Insert(lu_name_, 'DESCRIPTION');
   END IF;
   Validate_Event___ (newrec_);
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     accounting_event_tab%ROWTYPE,
   newrec_     IN OUT NOCOPY accounting_event_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2,
   objversion_ IN OUT NOCOPY VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   podirsh_                  accounting_event_tab.event_code%TYPE := 'PODIRSH';
   retpodirsh_               accounting_event_tab.event_code%TYPE := 'RETPODIRSH';
   corresponding_event_code_ accounting_event_tab.event_code%TYPE;
   corresponding_event_rec_  accounting_event_tab%ROWTYPE;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF (newrec_.delivery_overhead_flag != oldrec_.delivery_overhead_flag) THEN
      -- Make sure that PODIRSH and RETPODIRSH always have the same setting of the delivery_overhead_flag.
      corresponding_event_code_ := CASE newrec_.event_code WHEN podirsh_ THEN retpodirsh_ WHEN retpodirsh_ THEN podirsh_ ELSE NULL END;
      IF (corresponding_event_code_ IS NOT NULL) THEN
         corresponding_event_rec_ := Lock_By_Keys___(corresponding_event_code_);         
         IF (corresponding_event_rec_.delivery_overhead_flag != newrec_.delivery_overhead_flag) THEN 
            corresponding_event_rec_.delivery_overhead_flag := newrec_.delivery_overhead_flag;
            Modify___(corresponding_event_rec_);
            Client_SYS.Add_Info('AccountingEvent', 'DELOHSYNC: Delivery Overhead setting replicated to :P1', corresponding_event_code_);
         END IF;
      END IF;
   END IF;
   
END Update___;


-- Insert_Or_Update__
--   Handles component translations
PROCEDURE Insert_Or_Update___ (
   newrec_ IN OUT ACCOUNTING_EVENT_TAB%ROWTYPE,
   insert_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_   ACCOUNTING_EVENT_TAB%ROWTYPE;
   emptyrec_ ACCOUNTING_EVENT_TAB%ROWTYPE;
   
   CURSOR Get_Record IS
      SELECT *
      FROM ACCOUNTING_EVENT_TAB
      WHERE event_code = newrec_.event_code
      FOR UPDATE;
BEGIN
   OPEN Get_Record;
   FETCH Get_Record INTO oldrec_;
   IF (Get_Record%FOUND) THEN
      BEGIN
         -- Validate the existing record and only update it if it breaks the validation rules.
         Validate_Event___ (oldrec_);
      EXCEPTION
         WHEN OTHERS THEN
            newrec_.rowversion := oldrec_.rowversion;
            newrec_.rowkey     := oldrec_.rowkey;
            -- No need to update these attributes below since they are not included in the Validate_Event___ checks.
            newrec_.authorize_id      := oldrec_.authorize_id;
            newrec_.consignment_event := oldrec_.consignment_event;
            newrec_.online_flag       := oldrec_.online_flag;            
            Modify___(newrec_);
      END;
   ELSE
      IF (insert_) THEN
         New___(newrec_);
      END IF;
   END IF;
   CLOSE Get_Record;
   newrec_ := emptyrec_;
END Insert_Or_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Or_Update__
--   Handles component translations
PROCEDURE Insert_Or_Update__ (
   rec_ IN OUT ACCOUNTING_EVENT_TAB%ROWTYPE )
IS
BEGIN   
   Insert_Or_Update___(rec_);
END Insert_Or_Update__;


PROCEDURE Update__ (
   rec_ IN OUT ACCOUNTING_EVENT_TAB%ROWTYPE )
IS
BEGIN
   Insert_Or_Update___(rec_, insert_ => FALSE);
   NULL;
END Update__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   event_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Mpccom_System_Event_API.Get_Description(event_code_);
END Get_Description;

-- Create_Postings
--   Create postings in Mpccom_Accounting for the specified posting event
PROCEDURE Create_Postings (
   rcode_                   IN OUT VARCHAR2,
   company_                 IN     VARCHAR2,
   event_code_              IN     VARCHAR2,
   accounting_id_           IN     NUMBER,
   booking_source_          IN     VARCHAR2,
   value_                   IN     NUMBER,
   accounting_date_         IN     DATE,
   contract_                IN     VARCHAR2,
   userid_                  IN     VARCHAR2,
   control_type_key_rec_    IN     Mpccom_Accounting_API.Control_Type_Key,
   cost_source_id_          IN     VARCHAR2 DEFAULT NULL,
   bucket_posting_group_id_ IN     VARCHAR2 DEFAULT NULL,
   value_adjustment_        IN     BOOLEAN DEFAULT FALSE,
   per_oh_adjustment_id_    IN     NUMBER  DEFAULT NULL )
IS
   i_                     PLS_INTEGER := 1;
   currency_code_         VARCHAR2(3);
   currency_rate_         NUMBER;
   currency_type_         VARCHAR2(10);
   curr_amount_           NUMBER;
   old_booking_           NUMBER := -1;
   conv_factor_           NUMBER;
   ac_error_flag_         BOOLEAN := FALSE;

   CURSOR get_str_event_acc IS
      SELECT str_code, booking, pre_accounting_flag, debit_credit, project_accounting_flag
      FROM acc_event_posting_type_tab
      WHERE  event_code = event_code_;
BEGIN

   Company_Finance_API.Get_Accounting_Currency(currency_code_, company_);

   Currency_Rate_API.Get_Currency_Rate_Defaults(currency_type_,
                                                conv_factor_,
                                                currency_rate_,
                                                company_,
                                                currency_code_,
                                                Site_API.Get_Site_Date(contract_));
   FOR eventrec_ IN get_str_event_acc LOOP
      curr_amount_ := value_;      
      Mpccom_Accounting_API.Do_Accounting(
                             rcode_                       =>  rcode_,
                             company_                     =>  company_,
                             event_code_                  =>  event_code_,
                             str_code_                    =>  eventrec_.str_code,
                             pre_accounting_flag_db_      =>  eventrec_.pre_accounting_flag,
                             accounting_id_               =>  accounting_id_,
                             debit_credit_db_             =>  eventrec_.debit_credit,
                             value_                       =>  value_,
                             booking_source_              =>  booking_source_,
                             currency_code_               =>  currency_code_,
                             currency_rate_               =>  currency_rate_,
                             curr_amount_                 =>  curr_amount_,
                             accounting_date_             =>  accounting_date_,
                             project_accounting_flag_db_  =>  eventrec_.project_accounting_flag,
                             contract_                    =>  contract_,
                             userid_                      =>  userid_,
                             conversion_factor_           =>  conv_factor_,
                             control_type_key_rec_        =>  control_type_key_rec_,
                             cost_source_id_              =>  cost_source_id_,
                             bucket_posting_group_id_     =>  bucket_posting_group_id_,
                             value_adjustment_            =>  value_adjustment_,
                             per_oh_adjustment_id_        =>  per_oh_adjustment_id_);

      IF (rcode_ = 'ERROR') THEN
         ac_error_flag_ := TRUE;
      END IF;

      i_ := i_ + 1;
      old_booking_ := eventrec_.booking;
   END LOOP;
   IF (ac_error_flag_ = TRUE) THEN
      rcode_ := 'ERROR';
   ELSE
      rcode_ := 'SUCCESS';
   END IF;
END Create_Postings;



