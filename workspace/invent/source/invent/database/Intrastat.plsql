-----------------------------------------------------------------------------
--
--  Logical unit: Intrastat
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210119  SBalLK  Issue SC2020R1-11830, Modified Set_Process_Info(), Reset_Process_Info() and Reset_Consolidation_Flag() methods by removing attr_
--  210119          functionality to optimize the performance.
--  200107  ErFelk  Bug 145333, Modified Check_Insert___() to set the consolidation_flag to FALSE if it is not send. Added new method Reset_Consolidation_Flag().
--  150810  SBalLK  Bug 123739, Modified New_Intrastat_Header() method to avoid pack and unpack attr when inserting new record.
--  140825  NipKlk  Bug 118047, Added a validation to check if the values have decimals or negative in the method Validate_Pl_Import_Export___();
--  140731  NipKlk  Bug 118047, Added 6 new columns to the LU and assigned the default vales for declaration_export_ and declaration_import_ 
--  140731          when the country is 'PL' in Insert___();
--  131108  Asawlk  PBSC-221, Modified file to correct model errors.
--  111215  GanNLK  In the insert__ procedure, moved objversion_ to the bottom of the procedure.
--  100628  MaMalk  Aligned the code in Finite_State_Machine___ and in Insert___ according to the generated code from the model.
--  100602  LARELK  Replaced reference to application_country with iso_country for country_code.
--  100602          Modified Unpack_Check_Insert__, Unpack_Check_Update__ according to that.
--  100511  KRPELK  Merge Rose Method Documentation.
--  090930  ChFolk  Removed unused variables in the package.
--  ------------------------------- 14.0.0 ----------------------------------
--  060911  ChBalk  Merged call 53157, Added two new private attributes IMPORT_PROGRESS_NO 
--  060911          and EXPORT_PROGRESS_NO to the LU.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060523  KanGlk  Instead of INTRASTAT_LINE, INTRASTAT_LINE_TAB  had been used.  
--  --------------- 13.4.0 ---------------------------------------------------
--  060117  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  050919  NiDalk  Removed unused variables.
--  040226  GeKalk  Removed substrb from views for UNICODE modifications.
--  031219  ANLASE  Bug Fix 40483. Added check for status in Check_Delete___.
--  010320  ANLASE  Added check for process_info in Unpack_Check_Update.
--  010320  ANLASE  Added state Processing in StateDiagram, added method Set_Released.
--  010316  ANLASE  Corrected spelling branch in prompt.
--  010312  ErFi    Added join with company_finance_auth for security.
--  010307  ANLASE  Added methods SetProcessInfo and ResetProcessInfo.
--  010306  ANLASE  Added check for print flags in unpack_check_update.
--  010302  ANLASE  Changed process_info to refer to IID Process_Info.
--  010226  ANLASE  Added out parameter Intrastat_Id to method New_Intrastat_Header.
--  010223  ANLASE  Added reference for representative.
--  010222  ANLASE  Modified StateDiagram, added methods All_Lines Cancelled___,
--                  Cancel_Lines___, Get_ObjState and Check_Lines_Exist___.
--  010221  ANLASE  Added restrictions for update in unpack_check_update___.
--  010216  ANLASE  Made Intrastat_Id not mandatory and not updatable, is automatically generated.
--                  Added default value sysdate for creation_date.
--  010215  ANLASE  Replaced reference to isocountry with applicationcountry for country_code.
--                  Added default for company in prepare_insert.
--  010214  ANLASE  Added default for print-flags in Prepare_Insert.
--  010212  ANLASE  Created. Added undefines
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Cancel_Lines___ (
   rec_  IN OUT intrastat_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   CURSOR get_line IS
    SELECT rowid objid, to_char(rowversion,'YYYYMMDDHH24MISS') objversion
    FROM INTRASTAT_LINE_TAB
    WHERE intrastat_id = rec_.intrastat_id
    AND rowstate = 'Released';

   info_  VARCHAR2(2000);
   lattr_ VARCHAR2(2000);
BEGIN
   FOR lin IN get_line LOOP
      Client_SYS.Clear_Attr(lattr_);
      Intrastat_Line_API.Cancel__ (
       info_,
       lin.objid,
       lin.objversion,
       lattr_,
       'DO');
   END LOOP;
END Cancel_Lines___;


PROCEDURE Do_Confirm___ (
   rec_  IN OUT intrastat_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   NULL;
END Do_Confirm___;


FUNCTION All_Lines_Cancelled___ (
   rec_ IN intrastat_tab%ROWTYPE ) RETURN BOOLEAN
IS
   CURSOR get_line IS
    SELECT 1
    FROM INTRASTAT_LINE_TAB
    WHERE intrastat_id = rec_.intrastat_id
    AND rowstate != 'Cancelled';

   dummy_ VARCHAR2(1);
BEGIN
   IF (Check_Lines_Exist___(rec_.intrastat_id)) THEN
      OPEN get_line;
      FETCH get_line INTO dummy_;
      IF (get_line%NOTFOUND) THEN
         CLOSE get_line;
         -- all lines are in Cancelled state
         RETURN TRUE;
      END IF;
      CLOSE get_line;
      RETURN FALSE;
   ELSE
      RETURN FALSE;
   END IF;
END All_Lines_Cancelled___;


-- Check_Lines_Exist___
--   Checks if any Intrastat lines exist for a specific intrastat_id.
FUNCTION Check_Lines_Exist___ (
   intrastat_id_ IN NUMBER ) RETURN BOOLEAN
IS
  CURSOR get_line IS
   SELECT 'X'
   FROM INTRASTAT_LINE_TAB
   WHERE intrastat_id = intrastat_id_;
  dummy_ VARCHAR2(1);
BEGIN
   OPEN get_line;
   FETCH get_line INTO dummy_;
   IF (get_line%NOTFOUND) THEN
      CLOSE get_line;
      RETURN FALSE;
   END IF;
   CLOSE get_line;
   RETURN TRUE;
END Check_Lines_Exist___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);

   Client_SYS.Add_To_Attr('COMPANY', Site_API.Get_Company(User_Default_API.Get_Contract), attr_);
   Client_SYS.Add_To_Attr('FILE_PRINT_EXPORT_DB', 'NO IMPORT FILE PRINTED', attr_);
   Client_SYS.Add_To_Attr('FILE_PRINT_IMPORT_DB', 'NO EXPORT FILE PRINTED', attr_);
   Client_SYS.Add_To_Attr('DOC_PRINT_EXPORT_DB', 'NO EXPORT DOC PRINTED', attr_);
   Client_SYS.Add_To_Attr('DOC_PRINT_IMPORT_DB', 'NO IMPORT DOC PRINTED', attr_);
   Client_SYS.Add_To_Attr('CONSOLIDATION_FLAG_DB', 'FALSE', attr_);

END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT intrastat_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Generate New Intrastat_Id.
   SELECT intrastat_no_seq.nextval INTO newrec_.intrastat_id FROM dual;
   Client_SYS.Add_To_Attr('INTRASTAT_ID', newrec_.intrastat_id, attr_);

   IF (newrec_.country_code = 'PL') THEN
      newrec_.declaration_import := Intrastat_Declaration_API.DB_DECLARATION;
      newrec_.declaration_export := Intrastat_Declaration_API.DB_DECLARATION;
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN intrastat_tab%ROWTYPE )
IS
BEGIN   
   IF remrec_.rowstate NOT IN ('Released') THEN
      Error_SYS.Record_General('Intrastat','DELRELEASEONLY: Only Intrastat in status Released can be removed.');      
   END IF;
   
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT intrastat_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_          VARCHAR2(30);
   value_         VARCHAR2(4000);

   contract_      VARCHAR2(5);
   curr_type_     VARCHAR2(10);
   conv_factor_   NUMBER;
   rate_          NUMBER;
   currency_rate_ NUMBER;
BEGIN

   --set creation date (report is ordered per country, not site)
   contract_ := User_Allowed_Site_API.Get_Default_Site;
   newrec_.creation_date := Site_API.Get_Site_Date(contract_);

   -- Get the currency and rates for the company.
   IF NOT(indrec_.rep_curr_code) THEN
      newrec_.rep_curr_code := Company_Finance_API.Get_Currency_Code(newrec_.company);
   END IF;
   IF NOT(indrec_.rep_curr_rate) THEN
      Currency_Rate_API.Get_Currency_Rate_Defaults(curr_type_, conv_factor_, rate_, newrec_.company, newrec_.rep_curr_code, newrec_.end_date);
      currency_rate_ := rate_ / conv_factor_;
      newrec_.rep_curr_rate := currency_rate_;
   END IF;   
   IF NOT(indrec_.consolidation_flag) THEN
      newrec_.consolidation_flag := 'FALSE' ;
   END IF;
   
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     intrastat_tab%ROWTYPE,
   newrec_ IN OUT intrastat_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN

   IF newrec_.rowstate = 'Cancelled' THEN
      Error_SYS.Record_General('Intrastat','NOUPDATE: Intrastat in status Cancelled cannot be modified.' );
   END IF;

   IF newrec_.rowstate = 'Processing' THEN
      IF (indrec_.intrastat_id OR 
          indrec_.begin_date OR 
          indrec_.end_date OR 
          indrec_.company OR 
          indrec_.country_code OR
          indrec_.customs_id OR
          indrec_.to_invoice_date OR
          indrec_.intrastat_tax_no OR
          indrec_.bransch_no OR
          indrec_.bransch_no_repr OR
          indrec_.creation_date OR
          indrec_.representative OR
          indrec_.repr_tax_no OR
          indrec_.rep_curr_code OR
          indrec_.rep_curr_rate OR
          indrec_.registration_no OR
          indrec_.company_contact OR
          indrec_.dec_number_export OR
          indrec_.version_export OR
          indrec_.declaration_export OR
          indrec_.dec_number_import OR
          indrec_.version_import OR
          indrec_.declaration_import OR
          indrec_.file_print_export OR
          indrec_.file_print_import OR
          indrec_.doc_print_export OR
          indrec_.doc_print_import OR
          indrec_.import_progress_no OR
          indrec_.export_progress_no) THEN
         Error_SYS.Record_General('Intrastat','INPROCESS: Intrastat in status Processing cannot be modified.');
      END IF;
   END IF;

   IF (newrec_.rowstate = 'Confirmed') THEN
      -- Only print flags may be updated when the header has the status 'Confirmed'
      IF (indrec_.intrastat_id OR 
          indrec_.begin_date OR 
          indrec_.end_date OR 
          indrec_.company OR 
          indrec_.country_code OR
          indrec_.customs_id OR
          indrec_.to_invoice_date OR
          indrec_.intrastat_tax_no OR
          indrec_.bransch_no OR
          indrec_.bransch_no_repr OR
          indrec_.creation_date OR
          indrec_.representative OR
          indrec_.repr_tax_no OR
          indrec_.rep_curr_code OR
          indrec_.rep_curr_rate OR
          indrec_.process_info OR
          indrec_.registration_no OR
          indrec_.company_contact OR
          indrec_.dec_number_export OR
          indrec_.version_export OR
          indrec_.declaration_export OR
          indrec_.dec_number_import OR
          indrec_.version_import OR
          indrec_.declaration_import) THEN
         Error_SYS.Record_General('Intrastat','ONLYUPDATEFLAG: Intrastat in status Confirmed or Cancelled cannot be modified.');
      END IF;
   END IF;

   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     intrastat_tab%ROWTYPE,
   newrec_ IN OUT intrastat_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.country_code = 'PL') THEN
      Validate_Pl_Import_Export___(newrec_);
   END IF; 
   
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

   
PROCEDURE Validate_Pl_Import_Export___ (
   rec_  IN     intrastat_tab%ROWTYPE)
IS
BEGIN
   IF (rec_.version_export <= 0 OR rec_.version_import <= 0 OR (MOD(rec_.version_export, 1) != 0) OR (MOD(rec_.version_import, 1) != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'VERNUMBERZERO: Version number should be a positive integer.');         
   END IF;    
   IF (rec_.dec_number_export <= 0 OR rec_.dec_number_import <= 0 OR (MOD(rec_.dec_number_export, 1) != 0) OR (MOD(rec_.dec_number_import, 1) != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'DECNUMBERZERO: Declaration number should be a positive integer.');         
   END IF;
END Validate_Pl_Import_Export___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New_Intrastat_Header
--   Creates new record in Intrastat_tab.
PROCEDURE New_Intrastat_Header (
   intrastat_id_    OUT NUMBER,
   company_         IN VARCHAR2,
   country_code_    IN VARCHAR2,
   begin_date_      IN DATE,
   end_date_        IN DATE,
   to_invoice_date_ IN DATE )
IS
   newrec_          intrastat_tab%ROWTYPE;
BEGIN
   newrec_.company            := company_;
   newrec_.country_code       := country_code_;
   newrec_.begin_date         := begin_date_;
   newrec_.end_date           := end_date_;
   newrec_.to_invoice_date    := to_invoice_date_;
   newrec_.file_print_export  := 'NO IMPORT FILE PRINTED';
   newrec_.file_print_import  := 'NO EXPORT FILE PRINTED';
   newrec_.doc_print_export   := 'NO EXPORT DOC PRINTED';
   newrec_.doc_print_import   := 'NO IMPORT DOC PRINTED';
   New___(newrec_);
   intrastat_id_  := newrec_.intrastat_id;
END New_Intrastat_Header;


-- Set_Process_Info
--   Sets attribute process_info to incomplete when a warning message is
--   created in the background job.
PROCEDURE Set_Process_Info (
   intrastat_id_ IN NUMBER )
IS
   newrec_  intrastat_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(intrastat_id_);
   newrec_.process_info := Process_Info_API.DB_INCOMPLETE;
   Modify___(newrec_);
END Set_Process_Info;


-- Set_Released
--   Sets status to released when the background job is finished.
PROCEDURE Set_Released (
   intrastat_id_ IN NUMBER )
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000) := NULL;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   --Changes the status to 'Released'
   Get_Id_Version_By_Keys___(objid_, objversion_, intrastat_id_);
   Release__(info_, objid_, objversion_, attr_, 'DO');
END Set_Released;


-- Reset_Process_Info
--   Sets attribute process_info to complete when an intrastat report is confirmed.
PROCEDURE Reset_Process_Info (
   intrastat_id_ IN NUMBER )
IS
   newrec_ intrastat_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(intrastat_id_);
   newrec_.process_info := Process_Info_API.DB_COMPLETE;
   Modify___(newrec_);
END Reset_Process_Info;

-- Reset_Consolidation_Flag
--   Sets the Consolidation_Flag when this is initiated from Intrastat Consolidation Process.
PROCEDURE Reset_Consolidation_Flag (
   intrastat_id_           IN NUMBER,
   consolidation_flag_db_  IN VARCHAR2)
IS
   newrec_ intrastat_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(intrastat_id_);
   newrec_.consolidation_flag := consolidation_flag_db_;
   Modify___(newrec_);
END Reset_Consolidation_Flag;



