-----------------------------------------------------------------------------
--
--  Logical unit: SalesChargeTypeDesc
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210126  MaEelk   SC2020R1-11977, Modified Copy_Chg_Type_Desc and replaced the calls to Prepare_Insert___, 
--  210128           Pack___, Check_Insert___ and Insert___ with New___
--  110705  ChJalk   Added user_allowed_site filter to the VIEW.
--  080718  MaJalk   Added method Copy_Chg_Type_Desc__.
--  060726  ThGulk   Added Objid instead of rowid in Procedure Insert__
--  991001  DaZa     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SALES_CHARGE_TYPE_DESC_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT Document_Text_API.Get_Next_Note_Id INTO newrec_.note_id FROM DUAL;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy_Chg_Type_Desc
--   Copies an Existing Sales Charge Type Desc to the site.
PROCEDURE Copy_Chg_Type_Desc (
   charge_type_      IN VARCHAR2,
   from_contract_    IN VARCHAR2,
   to_contract_      IN VARCHAR2 )
IS
   CURSOR get_attr IS
      SELECT *
      FROM SALES_CHARGE_TYPE_DESC_TAB
      WHERE charge_type = charge_type_
      AND   contract = from_contract_;
      
   newrec_ sales_charge_type_desc_tab%ROWTYPE;
BEGIN
   
   FOR rec_ IN get_attr LOOP
      newrec_.contract := to_contract_;
      newrec_.charge_type := rec_.charge_type;
      newrec_.language_code := rec_.language_code;
      newrec_.charge_type_desc := rec_.charge_type_desc;
      newrec_.note_id := rec_.note_id;
      New___(newrec_);
   END LOOP;
END Copy_Chg_Type_Desc;



