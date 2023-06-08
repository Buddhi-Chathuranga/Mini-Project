-----------------------------------------------------------------------------
--
--  Logical unit: InfoChgReqAttribute
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210728  NaLrlk  PR21R2-398, Modified changes for rename the info_chg_request tables.
--  210701  NaLrlk  PR21R2-395, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--    Create a new record if record does not exist, 
--    otherwise update a record for the given record.
@IgnoreUnitTest DMLOperation
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN info_chg_req_attribute_tab%ROWTYPE )
IS
   lu_rec_  info_chg_req_attribute_tab%ROWTYPE ;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(newrec_.attribute_key);
   IF (lu_rec_.attribute_key IS NOT NULL) THEN
      lu_rec_.attribute_text := newrec_.attribute_text;
      Modify___(lu_rec_);
   ELSE
      lu_rec_ := newrec_;
      New___(lu_rec_);
   END IF;
END Insert_Lu_Data_Rec__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

