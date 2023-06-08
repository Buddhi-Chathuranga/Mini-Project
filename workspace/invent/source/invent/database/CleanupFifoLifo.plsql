-----------------------------------------------------------------------------
--
--  Logical unit: CleanupFifoLifo
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130918  PraWlk   Bug 99627, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Is_Executing___ (
   contract_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   count_            NUMBER;
   job_id_tab_       Message_Sys.name_table;
   attrib_tab_       Message_Sys.line_table;
   my_job_id_        NUMBER;
   local_contract_   VARCHAR2 (5);
   msg_              VARCHAR2 (32000);
   deferred_call_    CONSTANT VARCHAR2(200) := 'CLEANUP_FIFO_LIFO_API'||'.Cleanup_Routine__';
BEGIN
   -- Find the parameters and job id's for the currently executing jobs with
   -- the procedure name that is defined in deferred_call_.
   Transaction_SYS.Get_Executing_Job_Arguments(msg_, deferred_call_);
   -- Store in internal tables.
   Message_Sys.Get_Attributes(msg_, count_, job_id_tab_, attrib_tab_);

   -- Get the job id of the job we are executing.
   my_job_id_ := Transaction_SYS.Get_Current_Job_Id;

   WHILE (count_ > 0) LOOP
      IF (my_job_id_ != job_id_tab_(count_)) THEN
         -- Get the contract that is passed on as a parameter to the job under investigation.
         local_contract_ := Client_SYS.Get_Item_Value ('CONTRACT', attrib_tab_(count_));

         -- When we find the first disqualifying case, stop processing and return TRUE.
         IF (contract_ IS NULL) OR (contract_ = '%') THEN
            -- cannot differentiate contracts but my
            -- job is using wildcards and wants to process for all contracts.
            RETURN TRUE;
         ELSIF (local_contract_ IS NULL) OR (local_contract_ = '%') THEN
            -- cannot differentiate contracts but another
            -- job is using wildcards and is processing for all contracts.
            RETURN TRUE;
         ELSIF (local_contract_ = contract_) THEN
            -- matching contracts
            RETURN TRUE;
         END IF;
      END IF;
      count_ := count_ - 1;
   END LOOP;
   RETURN FALSE;
END Is_Executing___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cleanup_Routine__ (
   attr_      IN VARCHAR2 )
IS
   info_             VARCHAR2(2000);
   count_            NUMBER;
   contract_         VARCHAR2(5);
   number_of_days_   NUMBER;
BEGIN
   contract_ := Client_SYS.Get_Item_Value( 'CONTRACT', attr_ );
   number_of_days_ := Client_SYS.Get_Item_Value( 'NUMBER_OF_DAYS', attr_ );

   -- To avoid simultaneous execution of FIFO/LIFO Cleanup.
   Is_Executing(contract_);

   Inventory_Part_Cost_Fifo_API.Remove_Zero_Quantity_Records(count_, contract_, number_of_days_);

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (count_ > 0) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NO_OF_REC_REMOVED: :P1 FIFO/LIFO records were removed.', NULL, TO_CHAR(count_));
      ELSE
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NO_REC_REMOVED: No records were removed.');
      END IF;
      Transaction_SYS.Set_Progress_Info(info_);
   END IF;

END Cleanup_Routine__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Cleanup_Routine (
   message_ IN VARCHAR2 )
IS
   name_arr_         Message_SYS.name_table;
   value_arr_        Message_SYS.line_table;
   attr_             VARCHAR2(32000);
   batch_desc_       VARCHAR2(100);
   contract_         VARCHAR2(5);
   number_of_days_   NUMBER;
   count_            NUMBER;

   CURSOR get_contracts (in_contract_ IN VARCHAR2) IS
      SELECT site contract
      FROM user_allowed_site_pub
      WHERE site LIKE NVL(in_contract_,'%');

   TYPE Contract_Tab_Type IS TABLE OF get_contracts%ROWTYPE
     INDEX BY BINARY_INTEGER;
   contract_tab_       Contract_Tab_Type;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'NUMBER_OF_DAYS') THEN
         number_of_days_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;

   User_Allowed_Site_API.Exist_With_Wildcard(contract_);

   OPEN get_contracts(contract_);
   FETCH get_contracts BULK COLLECT INTO contract_tab_;
   CLOSE get_contracts;

   FOR i IN contract_tab_.FIRST..contract_tab_.LAST LOOP
      contract_ := contract_tab_(i).contract;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Client_SYS.Add_To_Attr('NUMBER_OF_DAYS', number_of_days_, attr_);

      IF (Transaction_SYS.Is_Session_Deferred()) THEN
         Cleanup_Routine__(attr_);
      ELSE
         batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'CLEANFIFOLIFO: Cleanup FIFO/LIFO Records for site ');
         batch_desc_ := batch_desc_ || contract_;
         Transaction_SYS.Deferred_Call('CLEANUP_FIFO_LIFO_API.Cleanup_Routine__', attr_, batch_desc_);
      END IF;
   END LOOP;

END Cleanup_Routine;


PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_                   NUMBER;
   name_arr_                Message_SYS.name_table;
   value_arr_               Message_SYS.line_table;
   contract_                VARCHAR2(5);
   no_of_days_              NUMBER;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'SITE') THEN
         contract_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'NO_OF_DAYS') THEN
         no_of_days_ := NVL(value_arr_(n_), 0);
      END IF;
   END LOOP;

   IF ((contract_ IS NOT NULL) AND (contract_ != '%')) THEN
      User_Allowed_Site_API.Exist_With_Wildcard(contract_);
   END IF;
   IF (no_of_days_ < 0 OR no_of_days_ != ROUND(no_of_days_)) THEN
      Error_Sys.Record_General(lu_name_, 'NEGNOOFDAYS: The no of days should be a positive integer.');
   END IF;
END Validate_Params;


PROCEDURE Is_Executing (
   contract_ IN VARCHAR2 )
IS
BEGIN

   -- To avoid simultaneous execution of Cleanup FIFO/LIFO Records
   IF Is_Executing___(contract_) THEN
      IF (contract_ = '%') OR contract_ IS NULL THEN
         Error_Sys.Appl_General(lu_name_, 'CLEANUPFLALLSITES: Cleanup FIFO/LIFO Records is already executing on at least one of the Sites and must complete first.');
      ELSE
         Error_Sys.Appl_General(lu_name_, 'CLEANUPFL: Cleanup FIFO/LIFO Records is already executing on Site :P1 and must complete first.', contract_);
      END IF;
   END IF;

END Is_Executing;



