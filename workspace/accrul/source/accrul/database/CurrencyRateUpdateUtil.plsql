-----------------------------------------------------------------------------
--
--  Logical unit: CurrencyRateUpdateUtil
--  Component:    ACCRUL
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
TYPE source_currency_rec_type IS RECORD(
   currency_rate_rec       currency_rate_tab%ROWTYPE,
   ref_currency_code       currency_type_tab.ref_currency_code%TYPE,
   ref_currency_inverted   currency_code_tab.inverted%TYPE);

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-- Set source currency record.
FUNCTION Set_Source_Currency_Record___(
   source_company_         IN VARCHAR2,
   source_currency_type_   IN VARCHAR2,
   currency_code_          IN VARCHAR2,
   valid_from_             IN DATE) RETURN source_currency_rec_type
IS
   source_currency_rec_       source_currency_rec_type;
   source_curr_rate_rec_      currency_rate_tab%ROWTYPE;
   
   CURSOR get_source_curr_rate IS
      SELECT *
      FROM currency_rate_tab
      WHERE company     = source_company_
      AND currency_type = source_currency_type_
      AND currency_code = currency_code_
      AND valid_from    = valid_from_;
BEGIN
   OPEN get_source_curr_rate;
   FETCH get_source_curr_rate INTO source_curr_rate_rec_;
   CLOSE get_source_curr_rate;
   source_currency_rec_.currency_rate_rec     := source_curr_rate_rec_;
   source_currency_rec_.ref_currency_code     := Currency_Type_API.Get_Ref_Currency_Code(source_company_, source_currency_type_);
   source_currency_rec_.ref_currency_inverted := Currency_Code_API.Get_Inverted(source_company_, source_currency_rec_.ref_currency_code);
   RETURN source_currency_rec_;
END Set_Source_Currency_Record___;

@IgnoreUnitTest DMLOperation
PROCEDURE Update_Single_Currency___(
   row_inserted_           OUT BOOLEAN,
   source_currency_rec_    IN  source_currency_rec_type,
   target_company_         IN  VARCHAR2,
   target_currency_type_   IN  VARCHAR2)
IS   
   target_curr_rate_rec_      currency_rate_tab%ROWTYPE;
   target_ref_curr_inverted_  currency_code_tab.inverted%TYPE;
BEGIN
   row_inserted_ := FALSE;
   -- Check currency rate already exist in the target.
   IF (NOT Currency_Rate_API.Exists(target_company_, target_currency_type_, source_currency_rec_.currency_rate_rec.currency_code, source_currency_rec_.currency_rate_rec.valid_from)) THEN
                                    
      Set_Target_Curr_Rate_Basics___(target_curr_rate_rec_, target_company_, target_currency_type_, source_currency_rec_.currency_rate_rec.currency_code, source_currency_rec_.currency_rate_rec.valid_from);
                                     
      -- No need to insert currency rate for the target company reference currency.
      IF target_curr_rate_rec_.ref_currency_code = source_currency_rec_.currency_rate_rec.currency_code THEN
         -- current currency = ref currency. skip this reccord.
         RETURN;
      END IF;
      target_ref_curr_inverted_ := Currency_Code_API.Get_Inverted(target_company_, target_curr_rate_rec_.ref_currency_code);
      -- If source ref currency is not equal to the target ref currency. Triangulation should be done.
      IF source_currency_rec_.ref_currency_code != target_curr_rate_rec_.ref_currency_code THEN
         Do_Triangulation___(target_curr_rate_rec_, source_currency_rec_, target_ref_curr_inverted_);
         -- Triangulation failed. skip record.
         IF target_curr_rate_rec_.currency_rate IS NULL THEN
            RETURN;
         END IF;
      ELSE
         IF source_currency_rec_.ref_currency_inverted = target_ref_curr_inverted_ THEN
            target_curr_rate_rec_.currency_rate := source_currency_rec_.currency_rate_rec.currency_rate/source_currency_rec_.currency_rate_rec.conv_factor;
         ELSE
            -- If source and target inverted flags are diffrent.
            IF NVL(source_currency_rec_.currency_rate_rec.currency_rate,0) != 0 THEN
               -- Consider inverse value when source company = target company, but inverted flags are diffrent.
               target_curr_rate_rec_.currency_rate := 1/(source_currency_rec_.currency_rate_rec.currency_rate/source_currency_rec_.currency_rate_rec.conv_factor);
            ELSE
               -- Inverse failed. skip record.
               RETURN;
            END IF;
         END IF;
      END IF;
      
      -- Apply target conversion factor.
      Apply_Conv_Factor___(target_curr_rate_rec_, source_currency_rec_);
      
      IF NVL(target_curr_rate_rec_.currency_rate, 0) != 0 THEN
         IF ((target_curr_rate_rec_.currency_rate > 1) OR
            (ROUND(target_curr_rate_rec_.currency_rate, Currency_Code_API.Get_No_Of_Decimals_In_Rate(target_curr_rate_rec_.company, target_curr_rate_rec_.currency_code)) != 0)) THEN
            -- Insert new currency rate record.
            Currency_Rate_API.New_Record(target_curr_rate_rec_);
            row_inserted_ := TRUE;
         END IF;
      END IF;
   ELSE
      RETURN;
   END IF;
END Update_Single_Currency___;

-- Note: Set target company currency rate basic data.
PROCEDURE Set_Target_Curr_Rate_Basics___ (
   target_curr_rate_rec_ OUT  currency_rate_tab%ROWTYPE,
   target_company_       IN   VARCHAR2,
   target_currency_type_ IN   VARCHAR2,
   currency_code_        IN   VARCHAR2,
   valid_from_           IN   DATE )
IS   
BEGIN
   target_curr_rate_rec_.company           := target_company_;
   target_curr_rate_rec_.currency_type     := target_currency_type_;
   target_curr_rate_rec_.currency_code     := currency_code_;
   target_curr_rate_rec_.valid_from        := valid_from_;
   target_curr_rate_rec_.conv_factor       := Currency_Code_API.Get_Conversion_Factor(target_company_, currency_code_);
   target_curr_rate_rec_.ref_currency_code := Currency_Type_API.Get_Ref_Currency_Code(target_company_, target_currency_type_);
END Set_Target_Curr_Rate_Basics___;

-- Apply conversion factor logic.
PROCEDURE Apply_Conv_Factor___ (
   target_curr_rate_rec_ IN OUT currency_rate_tab%ROWTYPE,
   source_currency_rec_   IN     source_currency_rec_type) IS
BEGIN      
   IF (NVL(source_currency_rec_.currency_rate_rec.conv_factor,0) != 0) THEN
      -- Apply conversion factor.
      target_curr_rate_rec_.currency_rate := target_curr_rate_rec_.currency_rate*target_curr_rate_rec_.conv_factor;
   END IF;
END Apply_Conv_Factor___;

-- Do currency rate triangulation.
PROCEDURE Do_Triangulation___ (
   target_curr_rate_rec_      IN OUT currency_rate_tab%ROWTYPE,
   source_currency_rec_       IN     source_currency_rec_type,
   target_ref_curr_inverted_  IN     VARCHAR2)
IS
   parent_triangular_rate_         NUMBER;
   parent_triangular_conv_factor_  NUMBER;
   
   CURSOR get_source_tringular_rate IS
      SELECT currency_rate, conv_factor
      FROM Latest_Currency_Rates
      WHERE company     = source_currency_rec_.currency_rate_rec.company
      AND currency_type = source_currency_rec_.currency_rate_rec.currency_type
      AND currency_code = target_curr_rate_rec_.ref_currency_code;
BEGIN
   -- Check source company has the intermediate currency rate.
   -- Source company should have a rate for the target company ref currency code to do the tringulation.
   OPEN get_source_tringular_rate;
   FETCH get_source_tringular_rate INTO parent_triangular_rate_, parent_triangular_conv_factor_;
   CLOSE get_source_tringular_rate;
   IF (NVL(parent_triangular_rate_, 0) != 0 AND NVL(parent_triangular_conv_factor_,0) != 0) THEN
      parent_triangular_rate_ := parent_triangular_rate_/parent_triangular_conv_factor_;
      -- To triangulation calculation.
      IF (NVL(source_currency_rec_.currency_rate_rec.currency_rate, 0) != 0) THEN
         IF source_currency_rec_.ref_currency_inverted = target_ref_curr_inverted_ THEN
            target_curr_rate_rec_.currency_rate := ((source_currency_rec_.currency_rate_rec.currency_rate/source_currency_rec_.currency_rate_rec.conv_factor)/parent_triangular_rate_);
         ELSE
            target_curr_rate_rec_.currency_rate := (parent_triangular_rate_/(source_currency_rec_.currency_rate_rec.currency_rate/source_currency_rec_.currency_rate_rec.conv_factor));
         END IF;
      ELSE
         -- Set this value to null so it will not be inserted.
         target_curr_rate_rec_.currency_rate := NULL;
      END IF;
   ELSE
      -- Source company doesn't have a rate to do the triangulation.
      -- Set this value to null so it will not be inserted.
      target_curr_rate_rec_.currency_rate := NULL;
   END IF;
END Do_Triangulation___;

PROCEDURE Val_Central_Upd_Batch_Param___ (
   source_company_         OUT VARCHAR2,
   source_curr_rate_type_  OUT VARCHAR2,
   message_                IN VARCHAR2 )
IS
   count_                  NUMBER;
   name_arr_               Message_SYS.name_table;
   value_arr_              Message_SYS.line_table; 
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'SOURCE_COMPANY') THEN
         source_company_ := UPPER(value_arr_(n_));
         Error_SYS.Check_Not_Null(lu_name_, 'SOURCE_COMPANY', source_company_);
      ELSIF (name_arr_(n_) = 'SOURCE_CURRENCY_RATE_TYPE') THEN
         source_curr_rate_type_ := value_arr_(n_);
         Error_SYS.Check_Not_Null(lu_name_, 'SOURCE_CURRENCY_RATE_TYPE', source_curr_rate_type_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;        
END Val_Central_Upd_Batch_Param___;

PROCEDURE Check_Source_Curr_Exist___(
   source_company_         IN VARCHAR2,
   source_curr_rate_type_  IN VARCHAR2)
IS
   source_curr_rec_     Source_Comp_Curr_Rate_Type_API.Public_Rec;
BEGIN
   IF source_company_ IS NOT NULL AND source_curr_rate_type_ IS NOT NULL THEN
      source_curr_rec_  := Source_Comp_Curr_Rate_Type_API.Get(source_company_, source_curr_rate_type_);
      IF source_curr_rec_.rowstate IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'SOURCENOTEXIST: Record doesn''t exist for Source Company :P1, Source Currency Rate Type :P2 in Centralized Currency Rate Handling page.', source_company_, source_curr_rate_type_);
      ELSIF source_curr_rec_.rowstate != Source_Comp_Curr_Rate_Type_API.DB_ACTIVE THEN
         Error_SYS.Record_General(lu_name_, 'SOURCENOTACTIVE: Status should be Active for Source Company :P1, Source Currency Rate Type :P2 in Centralized Currency Rate Handling page.', source_company_, source_curr_rate_type_);
      END IF;
   END IF;
END Check_Source_Curr_Exist___;

PROCEDURE Extract_Central_Batch_Param___(
   source_company_         OUT VARCHAR2,
   source_curr_rate_type_  OUT VARCHAR2,
   message_                IN  VARCHAR2)
IS
   count_                  NUMBER;
   name_arr_               Message_SYS.name_table;
   value_arr_              Message_SYS.line_table;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'SOURCE_COMPANY') THEN
         source_company_ := UPPER(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'SOURCE_CURRENCY_RATE_TYPE') THEN
         source_curr_rate_type_ := value_arr_(n_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;
END Extract_Central_Batch_Param___;

PROCEDURE Check_Cur_Type_Exist___(
   message_  IN VARCHAR2)
IS
   count_                  NUMBER;
   name_arr_               Message_SYS.name_table;
   value_arr_              Message_SYS.line_table;
   company_                VARCHAR2(4000);
   currency_type_          VARCHAR2(4000);
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY') THEN
         company_ := UPPER(value_arr_(n_));
         Error_SYS.Check_Not_Null(lu_name_, 'COMPANY', company_);
      ELSIF (name_arr_(n_) = 'CURRENCY_TYPE') THEN
         currency_type_ := value_arr_(n_);
         Error_SYS.Check_Not_Null(lu_name_, 'CURRENCY_TYPE', currency_type_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;
   Error_SYS.Check_Not_Null(lu_name_, 'COMPANY', company_);
   Error_SYS.Check_Not_Null(lu_name_, 'CURRENCY_TYPE', currency_type_);
   Currency_Type_API.Exist_Currency_Type(company_, currency_type_);
END Check_Cur_Type_Exist___;

PROCEDURE Extract_Cur_Type_Batch_Para___(
   company_         OUT VARCHAR2,
   currency_type_   OUT VARCHAR2,
   message_         IN  VARCHAR2)
IS
   count_                  NUMBER;
   name_arr_               Message_SYS.name_table;
   value_arr_              Message_SYS.line_table;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY') THEN
         company_ := UPPER(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'CURRENCY_TYPE') THEN
         currency_type_ := value_arr_(n_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;
END Extract_Cur_Type_Batch_Para___;

PROCEDURE Exec_Central_Workflow_Batch___(
   source_company_         IN VARCHAR2,
   source_curr_rate_type_  IN VARCHAR2)
IS
   message_       VARCHAR2(32000);
   event_id_      CONSTANT VARCHAR2(30) := 'CENTRAL_CURRENCY_RATE_HANDLING';
   bpa_key_       CONSTANT VARCHAR2(30) := 'finCentralCurrencyHandling';
   bpa_meta_      VARCHAR2(32000);
BEGIN
   $IF Component_Fndwf_SYS.INSTALLED $THEN 
   Message_SYS.Add_Attribute(bpa_meta_, 'BPA_KEY', bpa_key_);
   Message_SYS.Add_Attribute(bpa_meta_, 'BPA_TYPE', 'PROCESS_AUGMENT');
   Message_SYS.Add_Attribute(bpa_meta_, 'BPA_TIMING', 'ASYNC');
   
   message_ := Message_SYS.Construct(event_id_);
   Message_SYS.Add_Attribute(message_, Dictionary_SYS.Dbnametoclientname_('SOURCE_COMPANY'), source_company_);
   Message_SYS.Add_Attribute(message_, Dictionary_SYS.Dbnametoclientname_('SOURCE_CURR_RATE_TYPE'), source_curr_rate_type_);
   
   BPA_SYS.Append_Event(event_id_, lu_name_, NULL, NULL, bpa_meta_, message_);
   $ELSE
   Module_API.Check_Active('FNDWF');
   $END
END Exec_Central_Workflow_Batch___;

PROCEDURE Ex_Cur_Type_Workflow_Batch___(
   company_         IN VARCHAR2,
   currency_type_   IN VARCHAR2)
IS
   message_       VARCHAR2(32000);
   event_id_      CONSTANT VARCHAR2(30) := 'CURRENCY_TYPE_UPDATE';
   bpa_key_       CONSTANT VARCHAR2(30) := 'finCurrencyTypeUpdate';
   bpa_meta_      VARCHAR2(32000);
BEGIN
   $IF Component_Fndwf_SYS.INSTALLED $THEN 
   Message_SYS.Add_Attribute(bpa_meta_, 'BPA_KEY', bpa_key_);
   Message_SYS.Add_Attribute(bpa_meta_, 'BPA_TYPE', 'PROCESS_AUGMENT');
   Message_SYS.Add_Attribute(bpa_meta_, 'BPA_TIMING', 'ASYNC');
      
   message_ := Message_SYS.Construct(event_id_);
   Message_SYS.Add_Attribute(message_, Dictionary_SYS.Dbnametoclientname_('COMPANY'), company_);
   Message_SYS.Add_Attribute(message_, Dictionary_SYS.Dbnametoclientname_('CURRENCY_TYPE'), currency_type_);
   
   BPA_SYS.Append_Event(event_id_, lu_name_, NULL, NULL, bpa_meta_, message_);
   $ELSE
   Module_API.Check_Active('FNDWF');
   $END
END Ex_Cur_Type_Workflow_Batch___;

PROCEDURE Extract_Cur_Task_Batch_Para___(
   task_id_   OUT VARCHAR2,
   message_   IN  VARCHAR2)
IS
   count_                  NUMBER;
   name_arr_               Message_SYS.name_table;
   value_arr_              Message_SYS.line_table;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'TASK_ID') THEN
         task_id_ := UPPER(value_arr_(n_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;
END Extract_Cur_Task_Batch_Para___;

PROCEDURE Ex_Cur_Task_Workflow_Batch____(
   task_id_         IN VARCHAR2)
IS
   message_       VARCHAR2(32000);
   event_id_      CONSTANT VARCHAR2(30) := 'CURRENCY_TASK_UPDATE';
   bpa_key_       CONSTANT VARCHAR2(50) := 'finUpdateCurrencyRatesForCurrencyTask';
   bpa_meta_      VARCHAR2(32000);
BEGIN
   $IF Component_Fndwf_SYS.INSTALLED $THEN 
   Message_SYS.Add_Attribute(bpa_meta_, 'BPA_KEY', bpa_key_);
   Message_SYS.Add_Attribute(bpa_meta_, 'BPA_TYPE', 'PROCESS_AUGMENT');
   Message_SYS.Add_Attribute(bpa_meta_, 'BPA_TIMING', 'ASYNC');
      
   message_ := Message_SYS.Construct(event_id_);
   Message_SYS.Add_Attribute(message_, Dictionary_SYS.Dbnametoclientname_('TASK_ID'), task_id_);
   
   BPA_SYS.Append_Event(event_id_, lu_name_, NULL, NULL, bpa_meta_, message_);
   $ELSE
   Module_API.Check_Active('FNDWF');
   $END
END Ex_Cur_Task_Workflow_Batch____;

PROCEDURE Check_Cur_Task_Exist___(
   message_  IN VARCHAR2)
IS
   count_                  NUMBER;
   name_arr_               Message_SYS.name_table;
   value_arr_              Message_SYS.line_table;
   task_id_                VARCHAR2(4000);
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'TASK_ID') THEN
         task_id_ := UPPER(value_arr_(n_));
         Error_SYS.Check_Not_Null(lu_name_, 'TASK_ID', task_id_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;
   Error_SYS.Check_Not_Null(lu_name_, 'TASK_ID', task_id_);
   Ext_Currency_Task_API.Exist(task_id_);
END Check_Cur_Task_Exist___;

-- Copy rates from one currency type to another currency type.
-- Note: No PLSQL Unit test needed for this since calle method has a DML operation.
@IgnoreUnitTest DMLOperation
PROCEDURE Copy_Rates_From_Curr_Type___(
   row_inserted_           OUT BOOLEAN,
   source_company_         IN  VARCHAR2,
   source_currency_type_   IN  VARCHAR2,
   target_company_         IN  VARCHAR2,
   target_currency_type_   IN  VARCHAR2)
IS
   -- Copy currency rates only when target contains at least one row with the same currency.
   CURSOR get_source_valid_currencies IS
   SELECT currency_code, valid_from
     FROM latest_currency_rates l
    WHERE company     = source_company_
      AND currency_type = source_currency_type_
      AND EXISTS (SELECT 1
                    FROM currency_rate r
                   WHERE r.company       = target_company_
                     AND r.currency_type = target_currency_type_
                     AND r.currency_code = l.currency_code);
                  
   source_currency_rec_      source_currency_rec_type;
   current_row_inserted_     BOOLEAN := FALSE;
BEGIN
   row_inserted_ := FALSE;
   FOR source_curr_ IN get_source_valid_currencies LOOP
      source_currency_rec_ := Set_Source_Currency_Record___(source_company_, source_currency_type_, source_curr_.currency_code, source_curr_.valid_from);
      Update_Single_Currency___(current_row_inserted_, source_currency_rec_, target_company_, target_currency_type_);
      IF current_row_inserted_ THEN
         row_inserted_ := current_row_inserted_;
      END IF;
   END LOOP;
END Copy_Rates_From_Curr_Type___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- Check whether active workflow configuation exists for the projection action.
@UncheckedAccess
FUNCTION Active_Wf_Configuration_Exist(
   projection_    IN VARCHAR2,
   call_name_     IN VARCHAR2) RETURN BOOLEAN
IS
   $IF Component_Fndwf_SYS.INSTALLED $THEN
   CURSOR get_active_projection IS
      SELECT 1
      FROM bpmn_projection_tab
      WHERE projection_name = projection_
      AND call_name         = call_name_
      AND is_enabled        = 'TRUE';
   $END
   ndummy_ NUMBER;
BEGIN
   $IF Component_Fndwf_SYS.INSTALLED $THEN 
   OPEN get_active_projection;
   FETCH get_active_projection INTO ndummy_;
   IF get_active_projection%FOUND THEN
      CLOSE get_active_projection;
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
   $ELSE
   RETURN FALSE;
   $END
END Active_Wf_Configuration_Exist;


-- Copy multiple source currencies to a single target currency type.
-- Note: No PLSQL Unit test needed for this since callee method has a DML operation.
@IgnoreUnitTest DMLOperation
PROCEDURE Copy_Multi_Curr_Single_Target(
   full_selection_         IN VARCHAR2,
   target_company_         IN VARCHAR2,
   target_currency_type_   IN VARCHAR2)
IS
   source_currency_rec_    source_currency_rec_type;   
   source_currency_type_   currency_type_tab.currency_type%TYPE;
   currency_code_          currency_code_tab.currency_code%TYPE;
   selection_              VARCHAR2(32000) := CONCAT(full_selection_, ';');
   source_company_         VARCHAR2(32000);
   current_selection_      VARCHAR2(32000);
   valid_from_             DATE;
   row_inserted_           BOOLEAN;
BEGIN
   -- LOOP full_selection_
   WHILE (INSTR(selection_, ';') > 0) LOOP
      current_selection_      := substr(selection_, 0, INSTR(selection_, ';'));
      
      source_currency_type_ := NULL;
      currency_code_        := NULL;
      valid_from_           := NULL;
      
      -- source currency rate selection.
      source_company_        := Client_SYS.Get_Key_Reference_Value(current_selection_, 'COMPANY');
      source_currency_type_  := Client_SYS.Get_Key_Reference_Value(current_selection_, 'CURRENCY_TYPE');
      currency_code_         := Client_SYS.Get_Key_Reference_Value(current_selection_, 'CURRENCY_CODE');
      valid_from_            := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Key_Reference_Value(current_selection_, 'VALID_FROM'));

      source_currency_rec_ := Set_Source_Currency_Record___(source_company_, source_currency_type_, currency_code_, valid_from_);
         
      Update_Single_Currency___(row_inserted_, source_currency_rec_, target_company_, target_currency_type_);
      selection_ := substr(selection_, INSTR(selection_, ';')+1);
   END LOOP;
END Copy_Multi_Curr_Single_Target;


-- Sync source company with targets.
@SecurityCheck Company.UserAuthorized(source_company_)
@IgnoreUnitTest DMLOperation
PROCEDURE Sync_Source_With_All_Targets(
   source_company_         IN VARCHAR2,
   source_currency_type_   IN VARCHAR2)
IS
   row_inserted_ BOOLEAN := FALSE;
   
   CURSOR get_children IS
   SELECT target_company, target_curr_rate_type
   FROM target_comp_curr_rate_type
   WHERE source_company        = source_company_
   AND   source_curr_rate_type = source_currency_type_
   AND EXISTS (SELECT 1
               FROM source_comp_curr_rate_type
               WHERE source_company        = source_company_
               AND   source_curr_rate_type = source_currency_type_
               AND   objstate              = Source_Comp_Curr_Rate_Type_API.DB_ACTIVE);
BEGIN
   Source_Comp_Curr_Rate_Type_API.Update_Last_Updated(source_company_, source_currency_type_);
   FOR target_curr_ IN get_children LOOP
      row_inserted_ := FALSE;
      Copy_Rates_From_Curr_Type___(row_inserted_, source_company_, source_currency_type_ , target_curr_.target_company, target_curr_.target_curr_rate_type);
      IF row_inserted_ THEN
         Currency_Type_API.Update_Last_Updated(target_curr_.target_company, target_curr_.target_curr_rate_type);
      END IF;
   END LOOP;
END Sync_Source_With_All_Targets;

PROCEDURE Upd_Central_Curr_Rates_Batch(
   message_    IN VARCHAR2)
IS
   source_company_         VARCHAR2(4000);
   source_curr_rate_type_  VARCHAR2(4000);
BEGIN
   Module_API.Check_Active('FNDWF');
   Extract_Central_Batch_Param___(source_company_, source_curr_rate_type_, message_);
   Exec_Central_Workflow_Batch___(source_company_, source_curr_rate_type_);
END Upd_Central_Curr_Rates_Batch;

PROCEDURE Val_Centrl_Cur_Upd_Batch_Param(
   message_    IN VARCHAR2)
IS
   source_company_         VARCHAR2(4000);
   source_curr_rate_type_  VARCHAR2(4000);
BEGIN
   Module_API.Check_Active('FNDWF');
   Val_Central_Upd_Batch_Param___(source_company_, source_curr_rate_type_, message_);
   Check_Source_Curr_Exist___(source_company_, source_curr_rate_type_);
END Val_Centrl_Cur_Upd_Batch_Param;


PROCEDURE Update_Currency_Type_Batch(
   message_    IN VARCHAR2)
IS
   company_         VARCHAR2(4000);
   currency_type_   VARCHAR2(4000);
BEGIN
   Module_API.Check_Active('FNDWF');
   
   Extract_Cur_Type_Batch_Para___(company_, currency_type_, message_);
   Ex_Cur_Type_Workflow_Batch___(company_, currency_type_);
END Update_Currency_Type_Batch;

PROCEDURE Validate_Curr_Type_Batch_Param(
   message_    IN VARCHAR2)
IS
BEGIN
   Module_API.Check_Active('FNDWF');
   Check_Cur_Type_Exist___(message_);
END Validate_Curr_Type_Batch_Param;

PROCEDURE Update_Currency_Task_Batch(
   message_    IN VARCHAR2)
IS
   task_id_         VARCHAR2(4000);
BEGIN
   Module_API.Check_Active('FNDWF');
   
   Extract_Cur_Task_Batch_Para___(task_id_, message_);
   Ex_Cur_Task_Workflow_Batch____(task_id_);
END Update_Currency_Task_Batch;

PROCEDURE Validate_Curr_Task_Batch_Param(
   message_    IN VARCHAR2)
IS
BEGIN
   Module_API.Check_Active('FNDWF');
   Check_Cur_Task_Exist___(message_);
END Validate_Curr_Task_Batch_Param;

-------------------- LU  NEW METHODS -------------------------------------
