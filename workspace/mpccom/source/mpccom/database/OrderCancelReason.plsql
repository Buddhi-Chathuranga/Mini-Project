-----------------------------------------------------------------------------
--
--  Logical unit: OrderCancelReason
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120630  ChFolk   STRSC-1960, Removed override of method Check_Insert___ as blocked_for_use is removed.
--  121129  Maabse   Added Block for use, at the same time changed to template version 2.5
--  120507  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120507           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507           was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  050214  JICE     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   all_values_ VARCHAR2(4000);
BEGIN
   super(attr_);
   
   -- Check all Used By choices as default.
   Reason_Used_By_Api.Enumerate(all_values_);
   all_values_ := RTRIM(Replace(all_values_, Client_SYS.field_separator_, ';' ), ';');
   
   Client_SYS.Add_To_Attr('USED_BY_ENTITY', all_values_, attr_);
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
   
@UncheckedAccess
PROCEDURE Exist (
   cancel_reason_ IN VARCHAR2,
   reason_used_by_ IN VARCHAR2)
IS
   list_ VARCHAR2(500);
   find_ VARCHAR2(100);
BEGIN
   Exist(cancel_reason_, true);
   list_ :=  Get_Used_By_Entity_Db(cancel_reason_);
   find_ := '^' || reason_used_by_ || '^';
      
   IF ( list_ IS NULL OR INSTR( list_, find_ ) = 0 ) THEN
      Error_Sys.Record_General(lu_name_, 'USEDBYENTITY: Cancellation Reason :P1 is not valid for :P2.', 
        cancel_reason_, Reason_Used_By_API.Decode(reason_used_by_ ));
   END IF;
   
END Exist;

-- Get_Reason_Description
--   Fetches the ReasonDescription attribute for a record.
@UncheckedAccess
FUNCTION Get_Reason_Description (
   cancel_reason_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ order_cancel_reason_tab.reason_description%TYPE;
BEGIN
   IF (cancel_reason_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      cancel_reason_), 1, 100);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT reason_description
      INTO  temp_
      FROM  order_cancel_reason_tab
      WHERE cancel_reason = cancel_reason_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(cancel_reason_, 'Get_Reason_Description');
END Get_Reason_Description;



