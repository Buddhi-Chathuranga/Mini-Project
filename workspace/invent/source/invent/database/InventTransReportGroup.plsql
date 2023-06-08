-----------------------------------------------------------------------------
--
--  Logical unit: InventTransReportGroup
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120507  Matkse   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.
--  120507           Insert_Basic_Data_Translation in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507           was added. The view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  060823  KeFelk   Changed the logic of Copy_To_Company__.
--  060823  IsWilk   Modified the Copy_To_Company as a private PROCEDURE.
--  060810  MiErlk   Changed Error Message INVALIDDIRECTION
--  060804  KeFelk   Added Code Review Changes.
--  060802  NaLrlk   Corrected  the error message in Unpack_Check_Insert___.
--  060714  MaJalk   Set Direction as a mandatory field.
--  060711  MaJalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT invent_trans_report_group_tab%ROWTYPE,
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

   IF newrec_.direction NOT IN ('+', '-', '0') THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDDIRECTION: The direction can only contain +, - or 0.');
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
   newrec_        INVENT_TRANS_REPORT_GROUP_TAB%ROWTYPE;
   indrec_        Indicator_Rec;
   objid_         INVENT_TRANS_REPORT_GROUP.objid%TYPE;
   objversion_    INVENT_TRANS_REPORT_GROUP.objversion%TYPE;
   attr_          VARCHAR2(2000);

   CURSOR get_from_rec IS
      SELECT *
      FROM INVENT_TRANS_REPORT_GROUP_TAB
      WHERE company = from_company_ ;
BEGIN
   
   FOR rec_ IN get_from_rec LOOP
      IF NOT Check_Exist___(to_company_, rec_.report_group_id) THEN
         Client_SYS.Clear_Attr(attr_);
         newrec_     := NULL;
         objid_      := NULL;
         objversion_ := NULL;

         Client_SYS.Add_To_Attr('COMPANY'         , to_company_          , attr_);
         Client_SYS.Add_To_Attr('REPORT_GROUP_ID' , rec_.report_group_id , attr_);
         Client_SYS.Add_To_Attr('DESCRIPTION'     , rec_.description     , attr_);
         Client_SYS.Add_To_Attr('DIRECTION'       , rec_.direction       , attr_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END IF;
   END LOOP;

   Invent_Trans_Rep_Grp_Type_API.Copy_To_Company__(from_company_,to_company_);
END Copy_To_Company__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


