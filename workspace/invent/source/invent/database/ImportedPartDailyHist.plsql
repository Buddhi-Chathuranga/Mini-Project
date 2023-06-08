-----------------------------------------------------------------------------
--
--  Logical unit: ImportedPartDailyHist
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

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('INCLUDED_IN_PERIOD_HIST_DB','FALSE',attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Insert_Update (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   issue_date_       IN DATE,
   qty_issued_       IN NUMBER,
   number_of_issues_ IN NUMBER )
IS
   oldrec_       IMPORTED_PART_DAILY_HIST_TAB%ROWTYPE;
   newrec_       IMPORTED_PART_DAILY_HIST_TAB%ROWTYPE;
   objid_        IMPORTED_PART_DAILY_HIST.objid%TYPE;
   objversion_   IMPORTED_PART_DAILY_HIST.objversion%TYPE;
   attr_         VARCHAR2(32000);
   indrec_       Indicator_Rec;
BEGIN
   IF Check_Exist___(contract_, part_no_, issue_date_) THEN
      oldrec_ := Get_Object_By_Keys___(contract_, part_no_, issue_date_);
      IF ((oldrec_.qty_issued != qty_issued_) OR (oldrec_.number_of_issues != number_of_issues_))  THEN
         oldrec_ := Lock_By_Keys___(contract_, part_no_, issue_date_);
         newrec_ := oldrec_;
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Set_Item_Value('QTY_ISSUED', qty_issued_, attr_);
         Client_SYS.Set_Item_Value('NUMBER_OF_ISSUES', number_of_issues_, attr_);
         Client_SYS.Set_Item_Value('INCLUDED_IN_PERIOD_HIST_DB','FALSE',attr_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
      END IF;
   ELSE
      Prepare_Insert___(attr_);
      Client_SYS.Set_Item_Value('CONTRACT', contract_, attr_);
      Client_SYS.Set_Item_Value('PART_NO', part_no_, attr_);
      Client_SYS.Set_Item_Value('ISSUE_DATE', issue_date_, attr_);
      Client_SYS.Set_Item_Value('QTY_ISSUED', qty_issued_, attr_);
      Client_SYS.Set_Item_Value('NUMBER_OF_ISSUES', number_of_issues_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END Insert_Update;


PROCEDURE Modify_Included_In_Period_Hist (
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   issue_date_                IN DATE,
   included_in_period_hist_   IN VARCHAR2 )
IS
   oldrec_       IMPORTED_PART_DAILY_HIST_TAB%ROWTYPE;
   newrec_       IMPORTED_PART_DAILY_HIST_TAB%ROWTYPE;
   objid_        IMPORTED_PART_DAILY_HIST.objid%TYPE;
   objversion_   IMPORTED_PART_DAILY_HIST.objversion%TYPE;
   attr_         VARCHAR2(32000);
   indrec_       Indicator_Rec;
BEGIN
   
   oldrec_ := Lock_By_Keys___(contract_, part_no_, issue_date_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Set_Item_Value('INCLUDED_IN_PERIOD_HIST_DB',included_in_period_hist_,attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
   
END Modify_Included_In_Period_Hist;



