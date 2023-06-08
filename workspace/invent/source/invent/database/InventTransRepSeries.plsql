-----------------------------------------------------------------------------
--
--  Logical unit: InventTransRepSeries
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  161216  ApWilk  Bug 133186, Modified Check_Insert___() to check whether the user entered site belongs to the header company 
--  161216          and is allowed for the user.
--  150814  BudKlk  Bug 120336, Modified the method Get_Valid_Next_Report_No__() to retrie data from the table instead of the view.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN INVENT_TRANS_REP_SERIES_TAB%ROWTYPE )
IS
BEGIN
   IF (remrec_.start_report_no != remrec_.next_report_no ) THEN
      Error_SYS.Record_General(lu_name_, 'NODELETEALLOWED: Used Number Series cannot be removed.');
   END IF;

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT invent_trans_rep_series_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT(indrec_.warehouse) THEN 
      newrec_.warehouse := '*';
   END IF;
   
   IF (newrec_.warehouse != '*') THEN
      IF (Inventory_Location_API.Check_Warehouse_Exist(newrec_.contract, newrec_.warehouse) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_,'INVALWAREHOUSE: Warehouse :P1 is not a valid warehouse.', newrec_.warehouse );
      END IF;
   END IF;

   IF (newrec_.start_date < TRUNC(SYSDATE)) THEN
      Error_SYS.Record_General(lu_name_, 'STARTDATENOTALLOWED: The From Date should be greater than or equal to current date.');
   END IF;
   
   IF (newrec_.start_report_no < 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALSTARTREPORTNO: The Start Value cannot be a negative value.');
   END IF;

   IF (newrec_.start_report_no > newrec_.end_report_no) THEN
      Error_SYS.Record_General(lu_name_, 'INVALENDREPORTNO: The End Value should be greater than Start Value.');
   END IF;
   
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,newrec_.contract);
      
   IF (newrec_.company != Site_API.Get_Company(newrec_.contract)) THEN
      Error_SYS.Record_General(lu_name_,'COMPANYMISMATCH: Site :P1 does not belong to company :P2',newrec_.contract, newrec_.company);
   END IF;
   
   super(newrec_, indrec_, attr_);

   newrec_.next_report_no := newrec_.start_report_no;
   Client_SYS.Add_To_Attr( 'NEXT_REPORT_NO', newrec_.next_report_no, attr_ );
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     invent_trans_rep_series_tab%ROWTYPE,
   newrec_ IN OUT invent_trans_rep_series_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   report_no_     NUMBER;
   name_          VARCHAR2(30);
   value_         VARCHAR2(2000);
BEGIN
   IF (oldrec_.start_report_no != oldrec_.next_report_no) THEN
      report_no_ := oldrec_.next_report_no - 1;
   ELSE
      report_no_ := oldrec_.next_report_no;
   END IF;

   IF (report_no_ > newrec_.end_report_no ) THEN
      Error_SYS.Record_General(lu_name_, 'INVALENDREPNO: The End Value should be greater than or equal to :P1.',report_no_);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   Client_SYS.Add_To_Attr( 'NEXT_REPORT_NO', newrec_.next_report_no, attr_ );
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Valid_Next_Report_No__
--   Returns next report number according to the values in Contract and Warehouse.
FUNCTION Get_Valid_Next_Report_No__ (
   company_        IN VARCHAR2,
   report_type_id_ IN VARCHAR2,
   contract_       IN VARCHAR2,
   warehouse_      IN VARCHAR2 ) RETURN NUMBER
IS
   next_report_no_ INVENT_TRANS_REP_SERIES_TAB.next_report_no%TYPE;

   CURSOR get_attr IS
      SELECT next_report_no, end_report_no, start_date
        FROM INVENT_TRANS_REP_SERIES_TAB
       WHERE company = company_
         AND report_type_id = report_type_id_
         AND contract = contract_
         AND warehouse = NVL(warehouse_, '*')
         AND start_date <= SYSDATE
    ORDER BY start_date DESC;
BEGIN
   FOR rec_ IN get_attr LOOP
      IF (rec_.next_report_no > rec_.end_report_no) THEN
         IF (warehouse_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'MAXNUMSERFORSITE: The Number Series for Report Type :P1 for Site :P2 has reached its maximum number.',report_type_id_,contract_);
         ELSE
            Error_SYS.Record_General(lu_name_, 'MAXNUMSERFORWH: The Number Series for Report Type :P1, Site :P2 and Warehouse :P3 has reached its maximum number.',report_type_id_,contract_,warehouse_);
         END IF;
      END IF;

      Set_Next_Report_No__(company_, report_type_id_, contract_, warehouse_, rec_.start_date);
      next_report_no_ := rec_.next_report_no;
      EXIT;
   END LOOP;

   IF (next_report_no_ IS NULL) THEN
      IF (warehouse_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NONUMSERFORSITE: No Number Series is defined for the Report Type :P1 on Site :P2.',report_type_id_, contract_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'NONUMSERFORWH: No Number Series is defined for the Report Type :P1 ,Site :P2 and Warehouse :P3.',report_type_id_, contract_, warehouse_);
      END IF;
   END IF;
   
   RETURN next_report_no_;
END Get_Valid_Next_Report_No__;


-- Set_Next_Report_No__
--   Set next report series number.
PROCEDURE Set_Next_Report_No__ (
   company_        IN VARCHAR2,
   report_type_id_ IN VARCHAR2,
   contract_       IN VARCHAR2,
   warehouse_      IN VARCHAR2,
   start_date_     IN VARCHAR2 )
IS
   objid_          VARCHAR2(2000);
   objversion_     VARCHAR2(2000);
   attr_           VARCHAR2(2000);
   oldrec_         INVENT_TRANS_REP_SERIES_TAB%ROWTYPE;
   newrec_         INVENT_TRANS_REP_SERIES_TAB%ROWTYPE;
   next_report_no_ INVENT_TRANS_REP_SERIES_TAB.next_report_no%TYPE;
   info_           VARCHAR2(2000);
   indrec_         Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___ (company_, 
                               report_type_id_,
                               contract_, 
                               NVL(warehouse_, '*'), 
                               start_date_);
   newrec_ := oldrec_;
   next_report_no_ :=  oldrec_.next_report_no + 1;

   IF (next_report_no_ > oldrec_.end_report_no) THEN
      IF (warehouse_ IS NULL) THEN
         info_ := Language_SYS.Translate_Constant (lu_name_, 'NUMSERMAXVALSITE: The Number Series is reached its maximum number for the Report Type :P1 on Site :P2.',NULL,report_type_id_, contract_);
      ELSE
         info_ := Language_SYS.Translate_Constant (lu_name_, 'NUMSERMAXVALWH: The Number Series is reached its maximum number for the Report Type :P1 on Site :P2 and Warehouse :P3.',NULL,report_type_id_, contract_, warehouse_);
      END IF;
      IF (Transaction_SYS.Is_Session_Deferred) THEN
         Transaction_SYS.Set_Status_Info(info_, 'INFO');
      ELSE
         Client_SYS.Add_Info(lu_name_, info_);
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('NEXT_REPORT_NO', next_report_no_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Next_Report_No__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


