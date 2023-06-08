-----------------------------------------------------------------------------
--
--  Logical unit: InventTransRepGrpType
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120111  NaLrlk   Modified Unpack_Check_Insert___ to get the Invent_Trans_Report_Type_API.Get_Direction_Db value.
--  060823  KeFelk   Changed the logic of Copy_To_Company__.
--  060823  IsWilk   Modified the Copy_To_Company as a private PROCEDURE.
--  060810  MiErlk   Changed Error Message DIRECTIONMISMATCHTG
--  060804  KeFelk   Added Code Review Changes.
--  060803  IsWiLK   Modified the PROCEDURE Check_Delete___ to call
--  060803           Invent_Transaction_Report_API.Check_Report_Type_Id_Is_Used.
--  060714  MaJalk   Added an error message to Unpack_Check_Insert___ to validate Directions.
--  060711  MaJalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN INVENT_TRANS_REP_GRP_TYPE_TAB%ROWTYPE )
IS
BEGIN
   Invent_Transaction_Report_API.Check_Report_Type_Id_Is_Used(remrec_.company, remrec_.report_type_id, remrec_.report_group_id);

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT invent_trans_rep_grp_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   IF NOT (User_Finance_API.Check_User(newrec_.company, Fnd_Session_API.Get_Fnd_User)) THEN
      Error_SYS.Record_General(lu_name_ , 'CHECKUSER: User :P1 is not connected to company :P2.', Fnd_Session_API.Get_Fnd_User, newrec_.company);
   END IF;

   IF (Invent_Trans_Report_Type_API.Get_Direction_Db(newrec_.company, newrec_.report_type_id) != Invent_Trans_Report_Group_API.Get_Direction(newrec_.company, newrec_.report_group_id)) THEN
      Error_SYS.Record_General(lu_name_, 'DIRECTIONMISMATCHTG: It is only allowed to connect report types with the same direction as the report group.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy_To_Company__ (
   from_company_ IN VARCHAR2,
   to_company_   IN VARCHAR2 )
IS
   newrec_        INVENT_TRANS_REP_GRP_TYPE_TAB%ROWTYPE;
   indrec_        Indicator_Rec;
   objid_         INVENT_TRANS_REP_GRP_TYPE.objid%TYPE;
   objversion_    INVENT_TRANS_REP_GRP_TYPE.objversion%TYPE;
   attr_          VARCHAR2(2000);

   CURSOR get_from_rec IS
      SELECT *
      FROM INVENT_TRANS_REP_GRP_TYPE_TAB
      WHERE company = from_company_ ;
BEGIN
   
   FOR rec_ IN get_from_rec LOOP
      IF NOT Check_Exist___(to_company_,  rec_.report_type_id, rec_.report_group_id) THEN
         Client_SYS.Clear_Attr(attr_);
         newrec_     := NULL;
         objid_      := NULL;
         objversion_ := NULL;

         Client_SYS.Add_To_Attr('COMPANY'         , to_company_          , attr_);
         Client_SYS.Add_To_Attr('REPORT_TYPE_ID'  , rec_.report_type_id  , attr_);
         Client_SYS.Add_To_Attr('REPORT_GROUP_ID' , rec_.report_group_id , attr_);

         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END IF;
   END LOOP;
END Copy_To_Company__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


