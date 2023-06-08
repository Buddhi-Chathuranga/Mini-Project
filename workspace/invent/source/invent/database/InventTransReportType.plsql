-----------------------------------------------------------------------------
--
--  Logical unit: InventTransReportType
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120525  JeLise   Made description private.
--  120511  Matkse   Modified call Get_Basic_Data_Translation in Insert___ by expanding attribute key to contain both company and report_type_id
--  120507  Matkse   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.
--  120507           Insert_Basic_Data_Translation in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507           was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  120111  NaLrlk   Modified the direction column enumerate with MpccomTransDirection.
--  080108  NuVelk   Bug 69993, Changed the base view to only show report types
--  080108           of companies that the user is connected to.
--  060823  KeFelk   Changed the logic of Copy_To_Company__.
--  060823  IsWilk   Modified the Copy_To_Company as a private PROCEDURE.
--  060810  NaLrlk   Added the authorized company condition in the function Copy_To_Company.
--  060810  MiErlk   Changed Error Message INVALIDDIRECTION
--  060804  KeFelk   Added Code Review Changes.
--  060802  NaLrlk   Corrected the error message in Unpack_Check_Insert___.
--  060714  MaJalk   Set Direction as a mandatory field.
--  060711  MaJalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT invent_trans_report_type_tab%ROWTYPE,
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
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy_To_Company__ (
   from_company_ IN VARCHAR2,
   to_company_   IN VARCHAR2 )
IS
   newrec_        INVENT_TRANS_REPORT_TYPE_TAB%ROWTYPE;
   objid_         INVENT_TRANS_REPORT_TYPE.objid%TYPE;
   objversion_    INVENT_TRANS_REPORT_TYPE.objversion%TYPE;
   attr_          VARCHAR2(2000);
   indrec_        Indicator_Rec;
   CURSOR get_from_rec IS
      SELECT *
      FROM INVENT_TRANS_REPORT_TYPE_TAB
      WHERE company = from_company_ ;
BEGIN
   
   FOR rec_ IN get_from_rec LOOP
      IF NOT Check_Exist___(to_company_, rec_.report_type_id) THEN
         Client_SYS.Clear_Attr(attr_);
         newrec_     := NULL;
         objid_      := NULL;
         objversion_ := NULL;
      
         Client_SYS.Add_To_Attr('COMPANY'        , to_company_         , attr_);
         Client_SYS.Add_To_Attr('REPORT_TYPE_ID' , rec_.report_type_id , attr_);
         Client_SYS.Add_To_Attr('DESCRIPTION'    , rec_.description    , attr_);
         Client_SYS.Add_To_Attr('DIRECTION'      , rec_.direction      , attr_);
         
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END IF;
   END LOOP;
END Copy_To_Company__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   company_ IN VARCHAR2,
   report_type_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ invent_trans_report_type_tab.description%TYPE;
BEGIN
   IF (company_ IS NULL OR report_type_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      company_||'^'|| report_type_id_), 1, 100);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  invent_trans_report_type_tab
      WHERE company = company_
      AND   report_type_id = report_type_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(company_, report_type_id_, 'Get_Description');
END Get_Description;




