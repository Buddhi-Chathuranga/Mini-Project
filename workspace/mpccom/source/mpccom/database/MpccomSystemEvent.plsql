-----------------------------------------------------------------------------
--
--  Logical unit: MpccomSystemEvent
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200601  LEPESE  SC2021R1-291, Added private method Update__. Moved implementation from private Insert_Or_Update__ to
--  200601          implementation method Insert_Or_Update___. Rewrote implementation using New___ and Modify___.
--  130508  Asawlk   EBALL-37, Replaced the reference towards Transit_Qty_Direction_API with Stock_Quantity_Direction_API.
--  121203  NaLrlk  Added company_owned_allowed, company_rent_asset_allowed and supplier_rented_allowed to view MPCCOM_SYSTEM_EVENT_ALL.
--  120525  JeLise   Made description private.
--  120511  JeLise   Replaced all calls to Module_Translate_Attr_Util_API with calls to Basic_Data_Translation_API
--  120511           in New___, Modify__, Insert_Or_Update__, Get_Description and in the views. 
--  110503  MatKSE  Modified Unpack_Check_Insert to validate that uppercase is used for system event id, and updated
--  110503          view comments for system event id to be uppercase as well.
--  101015  LaRelk  BP-2366, Added RECEIPT_ISSUE_TRACKING to view MPCCOM_SYSTEM_EVENT_ALL.
--  070321  RaKalk  Created View MPCCOM_SYSTEM_EVENT_ALL
--  070321  RaKalk  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT mpccom_system_event_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   IF (upper(newrec_.system_event_id) != newrec_.system_event_id) THEN
      Error_SYS.Record_General(lu_name_,'UPPERCASE: The system event id must be entered in upper-case.');
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


PROCEDURE Insert_Or_Update___ (
   system_event_id_ IN VARCHAR2,
   description_     IN VARCHAR2,
   insert_          IN BOOLEAN DEFAULT TRUE )
IS
   newrec_ MPCCOM_SYSTEM_EVENT_TAB%ROWTYPE;
   oldrec_ MPCCOM_SYSTEM_EVENT_TAB%ROWTYPE;
BEGIN
   IF (Check_Exist___(system_event_id_)) THEN
      oldrec_             := Lock_By_Keys___(system_event_id_);
      newrec_             := oldrec_;
      newrec_.description := description_;
      Modify___(newrec_);
   ELSE
      IF (insert_) THEN
         newrec_.system_event_id := system_event_id_;
         newrec_.description     := description_;
         New___(newrec_);
      END IF;
   END IF;

   Basic_Data_Translation_API.Insert_Prog_Translation('MPCCOM',
                                                      'MpccomSystemEvent',
                                                      system_event_id_,
                                                      description_);
END Insert_Or_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Or_Update__ (
   system_event_id_ IN VARCHAR2,
   description_     IN VARCHAR2 )
IS
BEGIN
   Insert_Or_Update___(system_event_id_, description_ );
END Insert_Or_Update__;


PROCEDURE Update__ (
   system_event_id_ IN VARCHAR2,
   description_     IN VARCHAR2 )
IS 
BEGIN
   Insert_Or_Update___(system_event_id_, description_, insert_ => FALSE );
END Update__;   


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------





