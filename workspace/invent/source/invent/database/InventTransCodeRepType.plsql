-----------------------------------------------------------------------------
--
--  Logical unit: InventTransCodeRepType
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120111  NaLrlk   Modified Unpack_Check_Insert___ and Unpack_Check_Update___
--  120111           to get the Invent_Trans_Report_Type_API.Get_Direction_Db value.
--  100505  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  060823  KeFelk   Changed the logic of Copy_To_Company__.
--  060823  IsWilk   Modified the Copy_To_Company as a private PROCEDURE.
--  060815  MiErlk   Added a direction check to Unpack_Check_Update___
--  060810  MiErlk   Changed Error Message DIRECTIONMISMATCHTTC
--  060804  KeFelk   Added Code Review Changes.
--  060711  MiErlk   Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN INVENT_TRANS_CODE_REP_TYPE_TAB%ROWTYPE )
IS
BEGIN
   Invent_Transaction_Report_API.Check_Inv_Trans_Rep_Code_Exist(remrec_.transaction_code,remrec_.report_type_id ,remrec_.company);

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT invent_trans_code_rep_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(2000);
BEGIN
   super(newrec_, indrec_, attr_);

   IF NOT (User_Finance_API.Check_User(newrec_.company, Fnd_Session_API.Get_Fnd_User)) THEN
      Error_SYS.Record_General(lu_name_ , 'CHECKUSER: User :P1 is not connected to company :P2.', Fnd_Session_API.Get_Fnd_User, newrec_.company);
   END IF;

   IF (Invent_Trans_Report_Type_API.Get_Direction_Db(newrec_.company, newrec_.report_type_id  ) != Mpccom_Transaction_Code_API.Get_Direction(newrec_.transaction_code)) THEN
      Error_SYS.Record_General(lu_name_, 'DIRECTIONMISMATCHTTC: The direction of the transaction code and the report type ID should match.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     invent_trans_code_rep_type_tab%ROWTYPE,
   newrec_ IN OUT invent_trans_code_rep_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(2000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (Invent_Trans_Report_Type_API.Get_Direction_Db(newrec_.company, newrec_.report_type_id  ) != Mpccom_Transaction_Code_API.Get_Direction(newrec_.transaction_code)) THEN
      Error_SYS.Record_General(lu_name_, 'DIRECTIONMISMATCHTTC: The direction of the transaction code and the report type ID should match.');
   END IF;

   Invent_Transaction_Report_API.Check_Inv_Trans_Rep_Code_Exist(newrec_.transaction_code, newrec_.report_type_id, newrec_.company);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_To_Company__
--   This procedure will copy the Basic data of Inventroy Transaction from
--   one company to another company.
PROCEDURE Copy_To_Company__ (
   from_company_ IN VARCHAR2,
   to_company_   IN VARCHAR2 )
IS
   newrec_        INVENT_TRANS_CODE_REP_TYPE_TAB%ROWTYPE;
   indrec_        Indicator_Rec;
   objid_         INVENT_TRANS_CODE_REP_TYPE.objid%TYPE;
   objversion_    INVENT_TRANS_CODE_REP_TYPE.objversion%TYPE;
   attr_          VARCHAR2(2000);

   CURSOR get_from_rec IS
      SELECT *
      FROM INVENT_TRANS_CODE_REP_TYPE_TAB
      WHERE company = from_company_ ;
BEGIN
   
   FOR rec_ IN get_from_rec LOOP
      IF NOT Check_Exist___(rec_.transaction_code, to_company_) THEN
         Client_SYS.Clear_Attr(attr_);
         newrec_     := NULL;
         objid_      := NULL;
         objversion_ := NULL;
   
         Client_SYS.Add_To_Attr('COMPANY'         , to_company_           , attr_);
         Client_SYS.Add_To_Attr('TRANSACTION_CODE', rec_.transaction_code , attr_);
         Client_SYS.Add_To_Attr('REPORT_TYPE_ID'  , rec_.report_type_id   , attr_);
   
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END IF;
   END LOOP;
END Copy_To_Company__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


