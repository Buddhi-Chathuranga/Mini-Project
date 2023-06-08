-----------------------------------------------------------------------------
--
--  Logical unit: ConditionCodeManager
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100423  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  031204  LaBolk  Modified lines in the design history to remove red code.
--  -----------------------EDGE - Package Group 2------------------------------
--  020816  LEPESE  Removed obsolete method Get_Condition_Code_Value.
--  020815  LEPESE  Removed logic from obsolete method Get_Condition_Code_Value.
--  020808  LEPESE  Added calls to Lot_Batch_Master_API.
--  020806  LEPESE  Redesigned method Modify_Condition_Code.
--  020712  PEKR    Added Modify_Condition_Code.
--  020712  PEKR    Added Get_Condition_Code_Value.
--  020612  LEPESE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Condition_Code
--   This method should be used in situations when you need to know
--   the condition code and you have both serial_no and lot_batch_no at hand.
--   The method encapsulates the business logic that decides whether to get
--   condition code for the serial_no or the lot_batch_no.
@UncheckedAccess
FUNCTION Get_Condition_Code (
   part_no_      IN VARCHAR2,
   serial_no_    IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (NVL(serial_no_,'*') != '*') THEN
      RETURN Part_Serial_Catalog_API.Get_Condition_Code(part_no_, serial_no_);
   ELSIF (NVL(lot_batch_no_,'*') !='*') THEN
      RETURN Lot_Batch_Master_API.Get_Condition_Code(part_no_, lot_batch_no_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Condition_Code;



-- Modify_Condition_Code
--   Should be used when an individual changes from a Condition Code
--   to another Condition Code.
PROCEDURE Modify_Condition_Code (
   part_no_        IN VARCHAR2,
   serial_no_      IN VARCHAR2,
   lot_batch_no_   IN VARCHAR2,
   condition_code_ IN VARCHAR2 )
IS
BEGIN

   IF (NVL(serial_no_,'*') != '*') THEN

      Part_Serial_Catalog_API.Modify_Condition_Code(part_no_,
                                                    serial_no_,
                                                    condition_code_);
   ELSIF (NVL(lot_batch_no_,'*') != '*') THEN
      Lot_Batch_Master_API.Modify_Condition_Code(part_no_,
                                                 lot_batch_no_,
                                                 condition_code_);
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOLOTORSERIAL: Serial No or Lot Batch No must be specified.');
   END IF;
END Modify_Condition_Code;



