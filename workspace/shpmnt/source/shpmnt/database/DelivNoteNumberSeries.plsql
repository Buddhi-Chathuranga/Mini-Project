-----------------------------------------------------------------------------
--
--  Logical unit: DelivNoteNumberSeries
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190607  MaEelk  SCUXXW4-18057, Check_Common___ was overridden and added validation over authorized companies to
--                  aviod insert and update records in unauthorized companies.
--  100519  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090527  SuJalk  Bug 83173, Formatted the error message MAXLENGTH and MINLENGTH.
--  060525  PrPrlk  Bug 58196, Modified the method Get_Next_Delnote_Number to enable locking of the data set to
------------------------------------- 13.4.0 ---------------------------------
--  060111  MaHplk  Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  030728  SuAmlk  Added public attribute LENGTH_OF_DEL_NOTE_NO and modified method
--                  Get_Next_Delnote_Number to make the delivery note number length fixed.
--  030228  SuAmlk  Made the function Get_Next_Delnote_Number a procedure.
--  030205  SuAmlk  Added current_value to attribute string when inserting.
--  030131  SuAmlk  Made start_value and end_value update not allowed and included
--                  some validations for updating current_value.
--  030129  SuAmlk  Added function Get_Next_Delnote_Number and renamed procedure
--                  Validate_Comb___to Validate_Combination___.
--  030127  SuAmlk  Added function Check_Start_Value___ and procedure Validate_Comb___
--                  for validation of start value, end value and current value of a series.
--  030123  SuAmlk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Start_Value___
--   Checks whether there is overlapping intervals between delivery note number serieses.
--   Checks whether there is overlapping intervals between delivery note
--   number serieses.
FUNCTION Check_Start_Value___ (
   newrec_ IN DELIV_NOTE_NUMBER_SERIES_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   DELIV_NOTE_NUMBER_SERIES_TAB
      WHERE  company = newrec_.company
      AND    branch = newrec_.branch
      AND    valid_from != newrec_.valid_from
      AND    ((newrec_.start_value BETWEEN start_value AND end_value)
      OR     (newrec_.end_value BETWEEN start_value AND end_value))
      AND    end_value >= newrec_.start_value;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN TRUE;
   END IF;
   CLOSE exist_control;
   RETURN FALSE;
END Check_Start_Value___;


-- Validate_Combination___
--   Checks whether end value and current value of a delivery note number series is
--   compatible with the start value.
--   Checks whether end value and current value of a delivery note number
--   series is compatible with the start value.
PROCEDURE Validate_Combination___ (
   newrec_ IN DELIV_NOTE_NUMBER_SERIES_TAB%ROWTYPE )
IS
BEGIN
   IF ( newrec_.start_value IS NOT NULL ) THEN
      IF ( newrec_.end_value IS NOT NULL ) THEN
         IF ( newrec_.start_value >= newrec_.end_value ) THEN
            Error_SYS.Record_General('DelivNoteNumberSeries', 'ILLNUMBINT: Illegal number interval.');
         END IF;
      END IF;
   END IF;

   IF ( newrec_.current_value IS NOT NULL ) THEN
      IF ( newrec_.current_value < newrec_.start_value OR
           newrec_.current_value > newrec_.end_value) THEN
          Error_SYS.Record_General('DelivNoteNumberSeries', 'VALOUTOFINT: Next Value is not in the interval.');
      END IF;
   END IF;

   IF Check_Start_Value___(newrec_) THEN
      Error_SYS.Record_General('DelivNoteNumberSeries','OVINT: Overlapped intervals');
   END IF;
END Validate_Combination___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     deliv_note_number_series_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY deliv_note_number_series_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   User_Finance_API.Exist(newrec_.company, Fnd_Session_API.Get_Fnd_User);   
END Check_Common___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT deliv_note_number_series_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   
   Validate_Combination___(newrec_);
   IF newrec_.current_value IS NULL THEN
      newrec_.current_value := newrec_.start_value;
   END IF;

   IF NVL(newrec_.length_of_del_note_no,0) > 20  THEN
      Error_SYS.Appl_General(lu_name_,'MAXLENGTH: Fixed length of delivery note number cannot be greater than 20 characters.');
   END IF;
   IF NVL(newrec_.length_of_del_note_no,0) < 0  THEN
      Error_SYS.Appl_General(lu_name_,'MINLENGTH: Fixed length of delivery note number cannot be less than 0.');
   END IF;
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     deliv_note_number_series_tab%ROWTYPE,
   newrec_ IN OUT deliv_note_number_series_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_    VARCHAR2(30);
   value_   VARCHAR2(2000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   Validate_Combination___(newrec_);
   IF newrec_.current_value IS NOT NULL THEN
      IF oldrec_.current_value > newrec_.current_value THEN
         Error_SYS.Record_General(lu_name_, 'LOWVAL: Next value can only be Incremented.');
      END IF;
   ELSE
      newrec_.current_value := oldrec_.current_value;
   END IF;

   IF NVL(newrec_.length_of_del_note_no,0) > 20  THEN
      Error_SYS.Appl_General(lu_name_,'MAXLENGTH: Fixed length of delivery note number cannot be greater than 20 characters.');
   END IF;
   IF NVL(newrec_.length_of_del_note_no,0) < 0  THEN
      Error_SYS.Appl_General(lu_name_,'MINLENGTH: Fixed length of delivery note number cannot be less than 0.');
   END IF;

   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT deliv_note_number_series_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('CURRENT_VALUE', newrec_.current_value, attr_);
END Insert___;





-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Next_Delnote_Number
--   Returns the next unused delivery note number
--   Returns the next unused delivery note number.
PROCEDURE Get_Next_Delnote_Number (
   return_     OUT VARCHAR2,
   company_    IN VARCHAR2,
   branch_     IN VARCHAR2,
   valid_from_ IN DATE )
IS
   info_             VARCHAR2(2000);
   attr_             VARCHAR2(2000);
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);

   valid_from_date_  DATE;
   current_value_    NUMBER;
   end_value_        NUMBER;

   oldrec_           DELIV_NOTE_NUMBER_SERIES_TAB%ROWTYPE;
   newrec_           DELIV_NOTE_NUMBER_SERIES_TAB%ROWTYPE;
   fixed_length_of_delnote_no_ NUMBER; 
   
   CURSOR next_delnote_no IS
      SELECT valid_from, current_value, end_value
      FROM DELIV_NOTE_NUMBER_SERIES_TAB i
      WHERE company = company_
      AND branch = branch_
      AND valid_from IN ( SELECT MAX(valid_from)
                          FROM DELIV_NOTE_NUMBER_SERIES_TAB j
                          WHERE j.company = i.company
                          AND j.branch = i.branch
                          AND j.valid_from <= valid_from_ )
      FOR UPDATE;
BEGIN

   OPEN next_delnote_no;
   FETCH next_delnote_no INTO valid_from_date_, current_value_, end_value_;

   IF (next_delnote_no%FOUND) THEN
      IF ( current_value_ <= end_value_ ) THEN
         fixed_length_of_delnote_no_ := Get_Length_Of_Del_Note_No(company_, branch_, valid_from_date_);
         oldrec_ := Get_Object_By_Keys___(company_, branch_, valid_from_date_);
         newrec_ := oldrec_;
         newrec_.current_value := current_value_ + 1;
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
         IF fixed_length_of_delnote_no_ IS NOT NULL THEN
            IF (fixed_length_of_delnote_no_ < LENGTH(current_value_)) THEN
               info_ := Language_SYS.Translate_Constant(lu_name_, 'FIXEDLENGTH: For the Delivery Note Number to be filled out with beginning zeros, the Fixed Length should be greater than the number of positions in the Next Value for the Delivery Note Number Series !');
               Transaction_SYS.Set_Status_Info(info_);
               return_ := current_value_;
            ELSE
               return_ :=  LPAD(current_value_, fixed_length_of_delnote_no_,'0');
            END IF;
         ELSE
            return_ := current_value_;
         END IF;
      ELSE
         info_ := Language_SYS.Translate_Constant(lu_name_, 'UPPERLIMIT: The Upper Limit of the Delivery Note Number Series is reached !');
         Transaction_SYS.Set_Status_Info(info_);
         return_ := -1;
      END IF;
   ELSE
      info_ := Language_SYS.Translate_Constant(lu_name_, 'NONUMBER: There is no valid Delivery Note Number Series !');
      Transaction_SYS.Set_Status_Info(info_);
      return_ := -1;
   END IF;
   CLOSE next_delnote_no;
END Get_Next_Delnote_Number;



