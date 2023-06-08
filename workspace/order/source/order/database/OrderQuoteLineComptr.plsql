-----------------------------------------------------------------------------
--
--  Logical unit: OrderQuoteLineComptr
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130829  MaMa  Increased the length of Note to VARCHAR2(2000).
--  130710  ErFe  Bug 111142, Corrected the method name in General_SYS.Init_Method of Modify().
--  130130  SUJA  Bug 106597, Removed QUOTATION_NO, LINE_NO, REL_NO, LINE_ITEM_NO and COMPETITOR_ID attributes from being added to attr in Modify.
--  121105  JICE  Added public methods Check_Exist, Modify, Remove for BizAPI use.
--  100519  KRPE  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  000907  CaSt  Changed comment on competitor_id and compete_id to uppercase.
-----------------------------------------------------------------------------
--  000712  LUDI  Merged from Chameleon
-----------------------------------------------------------------------------
--  000508  GBO   Added cascade deleter
--  000503  GBO   Added New
--  000420  GBO   Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Returns 1 if the specified charge exists.
@UncheckedAccess
FUNCTION Check_Exist (
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER,
   competitor_id_ IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(quotation_no_, line_no_, rel_no_, line_item_no_, competitor_id_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Exist;


-- New
--   Public interface for creating records
PROCEDURE New (
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER,
   competitor_id_ IN VARCHAR2,
   compete_id_ IN VARCHAR2,
   note_ IN VARCHAR2,
   main_competitor_ IN VARCHAR2)
IS
   attr_       VARCHAR2(32000);
   newrec_     ORDER_QUOTE_LINE_COMPTR_TAB%ROWTYPE;
   objid_      rowid;
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN   
   Client_SYS.Clear_Attr( attr_ );
   Client_SYS.Add_To_Attr( 'QUOTATION_NO', quotation_no_, attr_ );
   Client_SYS.Add_To_Attr( 'LINE_NO', line_no_, attr_ );
   Client_SYS.Add_To_Attr( 'REL_NO', rel_no_, attr_ );
   Client_SYS.Add_To_Attr( 'LINE_ITEM_NO', line_item_no_, attr_ );
   Client_SYS.Add_To_Attr( 'COMPETITOR_ID', competitor_id_, attr_ );
   Client_SYS.Add_To_Attr( 'COMPETE_ID', compete_id_, attr_ );
   Client_SYS.Add_To_Attr( 'NOTE', note_, attr_ );
   Client_SYS.Add_To_Attr( 'MAIN_COMPETITOR_DB', main_competitor_, attr_ );
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Modify
--   Public interface for modifying records
PROCEDURE Modify (
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER,
   competitor_id_ IN VARCHAR2,
   compete_id_ IN VARCHAR2,
   note_ IN VARCHAR2,
   main_competitor_ IN VARCHAR2)
IS
   attr_        VARCHAR2(32000);
   oldrec_      ORDER_QUOTE_LINE_COMPTR_TAB%ROWTYPE;
   newrec_      ORDER_QUOTE_LINE_COMPTR_TAB%ROWTYPE;
   objid_       rowid;
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN

   oldrec_ := Lock_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_, competitor_id_);
   newrec_ := oldrec_;
   
   Client_SYS.Clear_Attr( attr_ );
   Client_SYS.Add_To_Attr( 'COMPETE_ID', compete_id_, attr_ );
   Client_SYS.Add_To_Attr( 'NOTE', note_, attr_ );
   Client_SYS.Add_To_Attr( 'MAIN_COMPETITOR_DB', main_competitor_, attr_ );
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify;


-- Remove
--   Public interface for deleting records
PROCEDURE Remove (
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER,
   competitor_id_ IN VARCHAR2)
IS
   remrec_     ORDER_QUOTE_LINE_COMPTR_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_no_, rel_no_, line_item_no_, competitor_id_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;



