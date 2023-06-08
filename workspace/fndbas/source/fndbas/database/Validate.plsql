-----------------------------------------------------------------------------
--
--  Logical unit: Validate
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Item_Update_If_Null (
   lu_name_    IN VARCHAR2, 
   attribute_  IN VARCHAR2, 
   value_      IN VARCHAR2,
   old_value_  IN VARCHAR2,
   indicator_  IN BOOLEAN )
IS
BEGIN
   IF (indicator_) THEN
      Error_SYS.Check_Update_If_Null(lu_name_, attribute_, value_, old_value_);
   END IF;
END Item_Update_If_Null;


@UncheckedAccess
PROCEDURE Item_Update_If_Null (
   lu_name_    IN VARCHAR2, 
   attribute_  IN VARCHAR2, 
   value_      IN NUMBER,
   old_value_  IN NUMBER,
   indicator_  IN BOOLEAN )
IS
BEGIN
   IF (indicator_) THEN
      Error_SYS.Check_Update_If_Null(lu_name_, attribute_, value_, old_value_);
   END IF;
END Item_Update_If_Null;


@UncheckedAccess
PROCEDURE Item_Update_If_Null (
   lu_name_    IN VARCHAR2, 
   attribute_  IN VARCHAR2, 
   value_      IN DATE,
   old_value_  IN DATE,
   indicator_  IN BOOLEAN )
IS
BEGIN
   IF (indicator_) THEN
      Error_SYS.Check_Update_If_Null(lu_name_, attribute_, value_, old_value_);
   END IF;
END Item_Update_If_Null;


@UncheckedAccess
PROCEDURE Item_Update_If_Null (
   lu_name_    IN VARCHAR2, 
   attribute_  IN VARCHAR2, 
   value_      IN TIMESTAMP_UNCONSTRAINED,
   old_value_  IN TIMESTAMP_UNCONSTRAINED,
   indicator_  IN BOOLEAN )
IS
BEGIN
   IF (indicator_) THEN
      Error_SYS.Check_Update_If_Null(lu_name_, attribute_, value_, old_value_);
   END IF;
END Item_Update_If_Null;


@UncheckedAccess
FUNCTION Is_Changed (
   old_value_  IN VARCHAR2,
   new_value_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF old_value_ IS NOT NULL AND new_value_ IS NOT NULL and old_value_ != new_value_ THEN
      RETURN(TRUE);
   ELSIF (old_value_ IS NOT NULL AND new_value_ IS NULL) OR (old_value_ IS NULL AND new_value_ IS NOT NULL) THEN
      RETURN(TRUE);
   END IF;
   RETURN(FALSE);
END Is_Changed;

@UncheckedAccess
FUNCTION Is_Changed (
   old_value_  IN CLOB,
   new_value_  IN CLOB ) RETURN BOOLEAN
IS
BEGIN
   IF old_value_ IS NOT NULL AND new_value_ IS NOT NULL and old_value_ != new_value_ THEN
      RETURN(TRUE);
   ELSIF (old_value_ IS NOT NULL AND new_value_ IS NULL) OR (old_value_ IS NULL AND new_value_ IS NOT NULL) THEN
      RETURN(TRUE);
   END IF;
   RETURN(FALSE);
END Is_Changed;

@UncheckedAccess
FUNCTION Is_Changed (
   old_value_  IN DATE,
   new_value_  IN DATE ) RETURN BOOLEAN
IS
BEGIN
   IF old_value_ IS NOT NULL AND new_value_ IS NOT NULL and old_value_ != new_value_ THEN
      RETURN(TRUE);
   ELSIF (old_value_ IS NOT NULL AND new_value_ IS NULL) OR (old_value_ IS NULL AND new_value_ IS NOT NULL) THEN
      RETURN(TRUE);
   END IF;
   RETURN(FALSE);
END Is_Changed;


@UncheckedAccess
FUNCTION Is_Changed (
   old_value_  IN TIMESTAMP_UNCONSTRAINED,
   new_value_  IN TIMESTAMP_UNCONSTRAINED ) RETURN BOOLEAN
IS
BEGIN
   IF old_value_ IS NOT NULL AND new_value_ IS NOT NULL and old_value_ != new_value_ THEN
      RETURN(TRUE);
   ELSIF (old_value_ IS NOT NULL AND new_value_ IS NULL) OR (old_value_ IS NULL AND new_value_ IS NOT NULL) THEN
      RETURN(TRUE);
   END IF;
   RETURN(FALSE);
END Is_Changed;


@UncheckedAccess
FUNCTION Is_Changed (
   old_value_  IN NUMBER,
   new_value_  IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   IF old_value_ IS NOT NULL AND new_value_ IS NOT NULL and old_value_ != new_value_ THEN
      RETURN(TRUE);
   ELSIF (old_value_ IS NOT NULL AND new_value_ IS NULL) OR (old_value_ IS NULL AND new_value_ IS NOT NULL) THEN
      RETURN(TRUE);
   END IF;
   RETURN(FALSE);
END Is_Changed;


@UncheckedAccess
FUNCTION Is_Changed (
   old_value_  IN VARCHAR2,
   new_value_  IN VARCHAR2,
   indicator_  IN BOOLEAN ) RETURN BOOLEAN
IS
BEGIN
   IF (indicator_) THEN
      RETURN(Is_Changed(old_value_, new_value_));
   END IF;
   RETURN(FALSE);
END Is_Changed;

@UncheckedAccess
FUNCTION Is_Changed (
   old_value_  IN CLOB,
   new_value_  IN CLOB,
   indicator_  IN BOOLEAN ) RETURN BOOLEAN
IS
BEGIN
   IF (indicator_) THEN
      RETURN(Is_Changed(old_value_, new_value_));
   END IF;
   RETURN(FALSE);
END Is_Changed;

@UncheckedAccess
FUNCTION Is_Changed (
   old_value_  IN DATE,
   new_value_  IN DATE,
   indicator_  IN BOOLEAN ) RETURN BOOLEAN
IS
BEGIN
   IF (indicator_) THEN
      RETURN(Is_Changed(old_value_, new_value_));
   END IF;
   RETURN(FALSE);
END Is_Changed;


@UncheckedAccess
FUNCTION Is_Changed (
   old_value_  IN NUMBER,
   new_value_  IN NUMBER,
   indicator_  IN BOOLEAN ) RETURN BOOLEAN
IS
BEGIN
   IF (indicator_) THEN
      RETURN(Is_Changed(old_value_, new_value_));
   END IF;
   RETURN(FALSE);
END Is_Changed;

@UncheckedAccess
FUNCTION Is_Different (
   old_value_  IN VARCHAR2,
   new_value_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Is_Changed(old_value_, new_value_));
END Is_Different;

@UncheckedAccess
FUNCTION Is_Different (
   old_value_  IN CLOB,
   new_value_  IN CLOB ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Is_Changed(old_value_, new_value_));
END Is_Different;

@UncheckedAccess
FUNCTION Is_Different (
   old_value_  IN DATE,
   new_value_  IN DATE ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Is_Changed(old_value_, new_value_));
END Is_Different;


@UncheckedAccess
FUNCTION Is_Different (
   old_value_  IN TIMESTAMP_UNCONSTRAINED,
   new_value_  IN TIMESTAMP_UNCONSTRAINED ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Is_Changed(old_value_, new_value_));
END Is_Different;


@UncheckedAccess
FUNCTION Is_Different (
   old_value_  IN NUMBER,
   new_value_  IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Is_Changed(old_value_, new_value_));
END Is_Different;


@UncheckedAccess
FUNCTION Is_Equal (
   old_value_  IN VARCHAR2,
   new_value_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF old_value_ IS NULL AND new_value_ IS NULL OR old_value_ = new_value_ THEN
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Is_Equal;


@UncheckedAccess
FUNCTION Is_Equal (
   old_value_  IN CLOB,
   new_value_  IN CLOB ) RETURN BOOLEAN
IS
BEGIN
   IF old_value_ IS NULL AND new_value_ IS NULL OR Dbms_Lob.Compare(old_value_, new_value_) = 0 THEN
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Is_Equal;


@UncheckedAccess
FUNCTION Is_Equal (
   old_value_  IN DATE,
   new_value_  IN DATE ) RETURN BOOLEAN
IS
BEGIN
   IF old_value_ IS NULL AND new_value_ IS NULL OR old_value_ = new_value_ THEN
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Is_Equal;


@UncheckedAccess
FUNCTION Is_Equal (
   old_value_  IN TIMESTAMP_UNCONSTRAINED,
   new_value_  IN TIMESTAMP_UNCONSTRAINED ) RETURN BOOLEAN
IS
BEGIN
   IF old_value_ IS NULL AND new_value_ IS NULL OR old_value_ = new_value_ THEN
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Is_Equal;


@UncheckedAccess
FUNCTION Is_Equal (
   old_value_  IN NUMBER,
   new_value_  IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   IF old_value_ IS NULL AND new_value_ IS NULL OR old_value_ = new_value_ THEN
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Is_Equal;


@UncheckedAccess
PROCEDURE Item_Insert (
   lu_name_    IN VARCHAR2, 
   attribute_  IN VARCHAR2, 
   indicator_  IN BOOLEAN )
IS
BEGIN
   IF (indicator_) THEN
      Error_SYS.Item_Insert(lu_name_, attribute_);
   END IF;
END Item_Insert;


@UncheckedAccess
PROCEDURE Item_Update (
   lu_name_    IN VARCHAR2, 
   attribute_  IN VARCHAR2, 
   indicator_  IN BOOLEAN )
IS
BEGIN
   IF (indicator_) THEN
      Error_SYS.Item_Update(lu_name_, attribute_);
   END IF;
END Item_Update;

@UncheckedAccess
PROCEDURE Check_Interval (
   lu_name_     IN VARCHAR2, 
   start_date_  IN DATE, 
   stop_date_   IN DATE )
IS
   from_date_   DATE := nvl(start_date_, Database_SYS.Get_First_Calendar_Date);
   to_date_     DATE := nvl(stop_date_, Database_SYS.Get_Last_Calendar_Date);
BEGIN
   IF (from_date_ >= to_date_) THEN 
      Error_SYS.Appl_General(lu_name_, 'DATE_INTERVAL: Date interval is not correct defined [:P1] - [:P2]', Database_SYS.Get_Formatted_Datetime(from_date_), Database_SYS.Get_Formatted_Datetime(to_date_));
   END IF;
END Check_Interval;



