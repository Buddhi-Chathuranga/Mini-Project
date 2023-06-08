-----------------------------------------------------------------------------
--
--  Logical unit: ImportedPartPeriodHist
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Insert_Update (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   qty_issued_       IN NUMBER,
   number_of_issues_ IN NUMBER )
IS
   oldrec_       IMPORTED_PART_PERIOD_HIST_TAB%ROWTYPE;
   newrec_       IMPORTED_PART_PERIOD_HIST_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
   objid_        IMPORTED_PART_PERIOD_HIST.objid%TYPE;
   objversion_   IMPORTED_PART_PERIOD_HIST.objversion%TYPE;
   attr_         VARCHAR2(32000);
BEGIN
   IF Check_Exist___(contract_, part_no_, stat_year_no_, stat_period_no_) THEN
      oldrec_ := Lock_By_Keys___(contract_, part_no_, stat_year_no_, stat_period_no_);
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Set_Item_Value('QTY_ISSUED', qty_issued_, attr_);
      Client_SYS.Set_Item_Value('NUMBER_OF_ISSUES', number_of_issues_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
   ELSE
      Prepare_Insert___(attr_);
      Client_SYS.Set_Item_Value('CONTRACT', contract_, attr_);
      Client_SYS.Set_Item_Value('PART_NO', part_no_, attr_);
      Client_SYS.Set_Item_Value('STAT_YEAR_NO', stat_year_no_, attr_);
      Client_SYS.Set_Item_Value('STAT_PERIOD_NO', stat_period_no_, attr_);
      Client_SYS.Set_Item_Value('QTY_ISSUED', qty_issued_, attr_);
      Client_SYS.Set_Item_Value('NUMBER_OF_ISSUES', number_of_issues_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END Insert_Update;


@UncheckedAccess
FUNCTION Period_Exist (
   contract_       IN VARCHAR2,
   stat_year_no_   IN NUMBER,
   stat_period_no_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_        NUMBER;
   period_exist_ BOOLEAN := FALSE;

   CURSOR exist_control IS
      SELECT 1
        FROM IMPORTED_PART_PERIOD_HIST_TAB
       WHERE contract       = contract_
         AND stat_year_no   = stat_year_no_
         AND stat_period_no = stat_period_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      period_exist_ := TRUE;
   END IF;
   CLOSE exist_control;
   RETURN(period_exist_);
END Period_Exist;



