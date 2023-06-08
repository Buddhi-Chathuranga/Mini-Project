-----------------------------------------------------------------------------
--
--  Logical unit: TransportDeliveryNote
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210118  WaSalk  SC2020R1-11757, Modified Modify_Date_Applied__() by adding new condition to retrieve site date if the applied date rule is DB_PRINT_DATE.
--  201026  WaSalk  SC2020R1-10885, Modified Reverse_Transactions___() by passing remove_del_info_ as TRUE in Inventory_Transaction_Hist_API.Modify_Delivery_Info().
--  201022  MaEelk  SC2020R1-10849, Dynamic stmt_ in Check_Ref_Value_Exists___ was bounded corectly
--  200505  WaSalk  gelr: Added to support Global Extension Functionalities.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
--gelr:transport_delivery_note, Begin
@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_        transport_delivery_note_tab.contract%TYPE := User_Default_API.Get_Contract;
   authorize_code_  transport_delivery_note_tab.authorize_code%TYPE := User_Default_API.Get_Authorize_Code;
BEGIN
   super(attr_);
   
   IF (contract_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   END IF;
   IF (authorize_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('AUTHORIZE_CODE', authorize_code_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('SINGLE_OCCURENCE_ADDRESS', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('GROSS_WEIGHT',             0,                        attr_);
   Client_SYS.Add_To_Attr('NET_WEIGHT',               0,                        attr_);
   Client_SYS.Add_To_Attr('VOLUME',                   0,                        attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     transport_delivery_note_tab%ROWTYPE,
   newrec_ IN OUT transport_delivery_note_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   Company_Localization_Info_API.Check_Parameter_Enabled_Site(newrec_.contract, 'TRANSPORT_DELIVERY_NOTE');
   IF (newrec_.vendor_no IS NULL AND newrec_.recipient_company IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'RECIPIENT_VENDOR: Recipient or Supplier must be entered.');
   END IF;
   IF (newrec_.single_occurrence_address = Fnd_Boolean_API.DB_FALSE) THEN
      newrec_.ship_address_name         := NULL;
      newrec_.ship_address1             := NULL;
      newrec_.ship_address2             := NULL;
      newrec_.ship_zip_code             := NULL;
      newrec_.ship_city                 := NULL;
      newrec_.ship_state                := NULL;
      newrec_.ship_county               := NULL;
      newrec_.ship_country_code         := NULL;
   END IF;
   
   IF (newrec_.single_occurrence_address = Fnd_Boolean_API.DB_TRUE) THEN
      IF Validate_SYS.Is_Changed(oldrec_.single_occurrence_address, newrec_.single_occurrence_address) OR Is_Single_Occurrence_Address_Changed___(oldrec_, newrec_) THEN
         Client_SYS.Add_Info(lu_name_, 'RECEIVERPERSON: If the receiver is a natural person, subject to GDPR, verify if a use of personal data is approved.');
      END IF;
   END IF;
END Check_Common___;

PROCEDURE Check_Single_Occurrence_Address_Ref___ (
   newrec_ IN OUT transport_delivery_note_tab%ROWTYPE )
IS
BEGIN
   IF (newrec_.vendor_no IS NULL) THEN
      Company_Address_API.Exist(newrec_.recipient_company, newrec_.Single_Occurrence_Address);
   ELSE
      Supplier_Info_Address_API.Exist(newrec_.vendor_no, newrec_.Single_Occurrence_Address);
   END IF;
END Check_single_occurrence_address_Ref___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     transport_delivery_note_tab%ROWTYPE,
   newrec_ IN OUT transport_delivery_note_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.rowstate = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'DELNOTECANCELLED: You cannot make any changes when the Transport Delivery Note is Cancelled.');
   END IF;
END Check_Update___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT transport_delivery_note_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT to_char(mpc_delnote_no.nextval)
   INTO newrec_.delivery_note_id
   FROM dual;
   newrec_.alt_delivery_note_id := newrec_.delivery_note_id;
   newrec_.create_date          := Site_API.Get_Site_Date(newrec_.contract);
   IF newrec_.transport_date IS NULL THEN
      newrec_.transport_date     := newrec_.create_date;
   END IF;
   
   Client_SYS.Add_To_Attr('DELIVERY_NOTE_ID',         newrec_.delivery_note_id,         attr_);
   Client_SYS.Add_To_Attr('ALT_DELIVERY_NOTE_ID',     newrec_.alt_delivery_note_id,     attr_);
   Client_SYS.Add_To_Attr('CREATE_DATE',              newrec_.create_date,              attr_);
   Client_SYS.Add_To_Attr('TRANSPORT_DATE',           newrec_.transport_date,           attr_);
   
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

-- Generate_Alt_Delivery_Note_Id
--   Genarates the alternative delivery note number from branch and defined number series.
PROCEDURE Generate_Alt_Delnote___ (
   rec_  IN OUT transport_delivery_note_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   company_         VARCHAR2(20);
   branch_          VARCHAR2(20);
   site_date_       DATE;
   number_series_   VARCHAR2(50) := -1;
   newrec_          transport_delivery_note_tab%ROWTYPE;
   
BEGIN
   company_ := Site_API.Get_Company(rec_.contract);
   $IF (Component_Discom_SYS.INSTALLED) $THEN
      branch_  := Site_Discom_Info_API.Get_Branch(rec_.contract);
   $ELSE
      Client_SYS.Add_Warning(lu_name_, 'GENALTDELNO: Alternate Delivery Note No can not be generated unless :P1 component installed.', 'Discom');
   $END
   IF branch_ IS NOT NULL THEN
      site_date_ := Site_API.Get_Site_Date(rec_.contract);
      $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
         Deliv_Note_Number_Series_API.Get_Next_Delnote_Number(number_series_, company_, branch_, site_date_);
      $ELSE
         Client_SYS.Add_Warning(lu_name_, 'GENALTDELNO: Alternate Delivery Note No can not be generated unless :P1 component installed.', 'Shpmnt');    
      $END
      IF number_series_ != -1 THEN
         -- Generate the alternative delivery note no
         rec_.alt_delivery_note_id := (branch_ ||'-'|| number_series_);
         -- Update the record with the alternative delivery note no
         newrec_ := Get_Object_By_Keys___(rec_.delivery_note_id);
         newrec_.alt_delivery_note_id := rec_.alt_delivery_note_id;
         Modify___(newrec_);
      END IF;
   END IF;
END Generate_Alt_Delnote___;

PROCEDURE Modify_Delivery_Info___ (
   rec_  IN OUT NOCOPY transport_delivery_note_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   CURSOR get_inventory_transactions IS
      SELECT *
      FROM transport_deliv_note_line_tab
      WHERE delivery_note_id = rec_.delivery_note_id;
    
BEGIN
   FOR line_rec_ IN get_inventory_transactions LOOP
      IF (line_rec_.transaction_type = Transport_Transaction_Type_API.DB_INVENTORY )THEN
         -- Update delivery info
         Inventory_Transaction_Hist_API.Modify_Delivery_Info(line_rec_.transaction_id, rec_.alt_delivery_note_id, rec_.create_date, rec_.delivery_reason_id);
      ELSE
         $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
            -- Update delivery info
            Operation_History_API.Modify_Transport_Del_Note_No(line_rec_.transaction_id, rec_.delivery_note_id);
         $ELSE
            NULL;
         $END
      END IF;
   END LOOP;  
END Modify_Delivery_Info___;

PROCEDURE Reverse_Transactions___ (
   rec_  IN OUT NOCOPY transport_delivery_note_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   CURSOR get_transactions IS
      SELECT *
      FROM transport_deliv_note_line_tab
      WHERE delivery_note_id = rec_.delivery_note_id;
      
BEGIN
   FOR line_rec_ IN get_transactions LOOP
      IF (line_rec_.transaction_type = Transport_Transaction_Type_API.DB_INVENTORY )THEN
         Inventory_Transaction_Hist_API.Modify_Delivery_Info(line_rec_.transaction_id, NULL, NULL, NULL, TRUE);
      ELSE
         $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
            Operation_History_API.Modify_Transport_Del_Note_No(line_rec_.transaction_id, NULL); 
         $ELSE
            NULL;
         $END
      END IF;
   END LOOP;
END Reverse_Transactions___;

   
FUNCTION Is_Single_Occurrence_Address_Changed___ (
   oldrec_ IN transport_delivery_note_tab%ROWTYPE,
   newrec_ IN transport_delivery_note_tab%ROWTYPE) RETURN BOOLEAN
IS
BEGIN
   IF Validate_SYS.Is_Changed(oldrec_.ship_address_name,    newrec_.ship_address_name   ) OR
      Validate_SYS.Is_Changed(oldrec_.ship_address1,     newrec_.ship_address1    ) OR
      Validate_SYS.Is_Changed(oldrec_.ship_address2,     newrec_.ship_address2    ) OR
      Validate_SYS.Is_Changed(oldrec_.ship_zip_code,     newrec_.ship_zip_code    ) OR
      Validate_SYS.Is_Changed(oldrec_.ship_city,         newrec_.ship_city        ) OR
      Validate_SYS.Is_Changed(oldrec_.ship_state,        newrec_.ship_state       ) OR
      Validate_SYS.Is_Changed(oldrec_.ship_county,       newrec_.ship_county      ) OR
      Validate_SYS.Is_Changed(oldrec_.ship_country_code, newrec_.ship_country_code) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Single_Occurrence_Address_Changed___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Modify_Date_Applied__ (
   delivery_note_id_ IN VARCHAR2 )
IS
   rec_                           Public_Rec;
   date_applied_rule_             VARCHAR2(80);
   modify_date_applied_enabled_   VARCHAR2(20);
   dummy_info_                    VARCHAR2(2000);

   CURSOR get_transactions IS
      SELECT *
      FROM transport_deliv_note_line_tab 
      WHERE delivery_note_id = rec_.delivery_note_id;

BEGIN
   rec_ := Get(delivery_note_id_);
   modify_date_applied_enabled_ := Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(rec_.contract, 'MODIFY_DATE_APPLIED');
   date_applied_rule_ := Company_Invent_Info_API.Get_Auto_Update_Date_Applie_Db(Site_API.Get_Company(rec_.contract));
   
   FOR line_rec_ IN get_transactions LOOP
      -- Update date applied
      IF (line_rec_.transaction_type = Transport_Transaction_Type_API.DB_INVENTORY )THEN
         IF (modify_date_applied_enabled_ = Fnd_Boolean_API.DB_TRUE) THEN
            IF (date_applied_rule_ = Auto_Update_Date_Applied_API.DB_TRANSPORT_DATE) THEN
               Inventory_Transaction_Hist_API.Modify_Date_Applied(dummy_info_, line_rec_.transaction_id, NVL(rec_.transport_date, Site_API.Get_Site_Date(rec_.contract)));
            ELSIF (date_applied_rule_ = Auto_Update_Date_Applied_API.DB_PRINT_DATE) THEN   
               Inventory_Transaction_Hist_API.Modify_Date_Applied(dummy_info_, line_rec_.transaction_id, Site_API.Get_Site_Date(rec_.contract));
            ELSE
               Inventory_Transaction_Hist_API.Modify_Date_Applied(dummy_info_, line_rec_.transaction_id, NVL(rec_.create_date, Site_API.Get_Site_Date(rec_.contract)));
            END IF;
         END IF;
      ELSE
         $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
            -- Update date applied
            IF (modify_date_applied_enabled_ = Fnd_Boolean_API.DB_TRUE) THEN
               IF (date_applied_rule_ = Auto_Update_Date_Applied_API.DB_TRANSPORT_DATE) THEN
                  Operation_History_API.Modify_Date_Applied(line_rec_.transaction_id, NVL(rec_.transport_date, Site_API.Get_Site_Date(rec_.contract)));
               ELSIF (date_applied_rule_ = Auto_Update_Date_Applied_API.DB_PRINT_DATE) THEN 
                  Operation_History_API.Modify_Date_Applied(line_rec_.transaction_id, Site_API.Get_Site_Date(rec_.contract));
               ELSE
                  Operation_History_API.Modify_Date_Applied(line_rec_.transaction_id, NVL(rec_.create_date, Site_API.Get_Site_Date(rec_.contract)));
               END IF;
            END IF;
         $ELSE
            NULL;
         $END
      END IF;
   END LOOP;
   
END Modify_Date_Applied__;

PROCEDURE Check_Ref_Value_Exists___ (
   column_name_ IN VARCHAR2,
   column_value_ IN VARCHAR2 )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_ Check_Exist;
   stmt_ VARCHAR2(2000);
   rec_ Transport_Delivery_Note_Tab%ROWTYPE;
   exist_ BOOLEAN := FALSE;
BEGIN
   stmt_ := ' SELECT *
            FROM Transport_Delivery_Note_Tab
            WHERE rowstate != ''Cancelled'' ';
   stmt_ := stmt_ || ' AND ' || column_name_ ||' = :column_value_';
   @ApproveDynamicStatement(2020-06-09,WASALK)
   OPEN exist_control_ FOR stmt_ USING column_value_;
   FETCH exist_control_ INTO rec_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (exist_) THEN
      Error_SYS.Record_General(lu_name_, 'BASDATAUSED: This :P1 is used by Transport Delivery Note(s) in :P2 status and cannot be deleted', column_value_, rec_.rowstate);
   END IF;
END Check_Ref_Value_Exists___;

PROCEDURE Check_Authorize_Code_Ref__ (
   authorize_code_ IN VARCHAR2 )
IS
BEGIN
   Check_Ref_Value_Exists___('AUTHORIZE_CODE', authorize_code_);
END Check_Authorize_Code_Ref__;

PROCEDURE Check_Forward_Agent_Ref__ (
   forward_agent_id_ IN VARCHAR2 )
IS
BEGIN
   Check_Ref_Value_Exists___('FORWARD_AGENT_ID', forward_agent_id_);
END Check_Forward_Agent_Ref__;

PROCEDURE Check_Delivery_Terms_Ref__ (
   delivery_terms_ IN VARCHAR2 )
IS
BEGIN
   Check_Ref_Value_Exists___('DELIVERY_TERMS', delivery_terms_);
END Check_Delivery_Terms_Ref__;

PROCEDURE Check_Ship_Via_Code_Ref__ (
   ship_via_code_ IN VARCHAR2 )
IS
BEGIN
   Check_Ref_Value_Exists___('SHIP_VIA_CODE', ship_via_code_);
END Check_Ship_Via_Code_Ref__;

PROCEDURE Check_Delivery_Reason_Ref__ (
   delivery_reason_id_ IN VARCHAR2 )
IS
BEGIN
   Check_Ref_Value_Exists___('DELIVERY_REASON_ID', delivery_reason_id_);
END Check_Delivery_Reason_Ref__;

-- gelr:transport_delivery_note, end
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

