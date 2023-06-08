-----------------------------------------------------------------------------
--
--  Logical unit: BasicDataWindow
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Insert_Lu_Data_Rec (
   newrec_        IN basic_data_window_tab%ROWTYPE)
IS
   rec_           basic_data_window_tab%ROWTYPE;
   oldrec_        basic_data_window_tab%ROWTYPE;
BEGIN
   oldrec_ := Get_Object_By_Keys___(newrec_.logical_unit_name);
   IF (oldrec_.rowversion IS NULL) THEN
      rec_ := newrec_;
      New___(rec_);
      Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP', lu_name_, newrec_.logical_unit_name, newrec_.window);
   ELSE
      rec_ := oldrec_;
      rec_.window := newrec_.window;
      Modify___(rec_);
      Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP', lu_name_, newrec_.logical_unit_name, newrec_.window);
   END IF;   
END Insert_Lu_Data_Rec;