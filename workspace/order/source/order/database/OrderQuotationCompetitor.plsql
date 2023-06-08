-----------------------------------------------------------------------------
--
--  Logical unit: OrderQuotationCompetitor
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140902  UdGnlk  Added Copy_Competitors__() for Copy Sales Quotation functionality.   
--  131025  RoJa  Modified ORDER_QUOTATION_COMPETITOR and increased the column length of note to be 2000.
--  130710  ErFe  Bug 111142, Corrected the method name in General_SYS.Init_Method of Modify().
--  130130  SUJA  Bug 106597, Removed QUOTATION_NO and COMPETITOR_ID attributes from being added to attr in Modify.
--  121105  JICE  Added public methods Check_Exist, New, Modify, Remove for BizAPI use.
--  000907  CaSt  Changed comment on competitor_id and compete_id to uppercase
-----------------------------------------------------------------------------
--  000712  LUDI  Merged from Chameleon
-----------------------------------------------------------------------------
--  000420  GBO   Added competitor_id as key. Remove note from key
--  000410  LD    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Copy_Competitors__ (
   from_quotation_no_   IN VARCHAR2,
   to_quotation_no_     IN VARCHAR2)
IS
   attr_              VARCHAR2(2000);
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);
   newrec_            ORDER_QUOTATION_COMPETITOR_TAB%ROWTYPE;   
   from_rowkey_       ORDER_QUOTATION_COMPETITOR_TAB.rowkey%TYPE;
   indrec_            Indicator_Rec;
   
   CURSOR get_rec IS
      SELECT *
      FROM order_quotation_competitor_tab
      WHERE quotation_no = from_quotation_no_;
BEGIN
   FOR rec_ IN get_rec LOOP
      newrec_      := Lock_By_Keys___(from_quotation_no_, rec_.competitor_id);
      from_rowkey_ := newrec_.rowkey;      
      newrec_.quotation_no   := to_quotation_no_;
      newrec_.rowkey         := NULL;

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   
      -- Copy Custom Field Values
      Custom_Objects_SYS.Copy_Cf_Instance(lu_name_, from_rowkey_, newrec_.rowkey); 
   END LOOP;   
END Copy_Competitors__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Returns 1 if the specified charge exists.
@UncheckedAccess
FUNCTION Check_Exist (
   quotation_no_ IN VARCHAR2,
   competitor_id_ IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(quotation_no_, competitor_id_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Exist;


-- New
--   Public interface for creating records
PROCEDURE New (
   quotation_no_ IN VARCHAR2,
   competitor_id_ IN VARCHAR2,
   compete_id_ IN VARCHAR2,
   note_ IN VARCHAR2,
   main_competitor_ IN VARCHAR2)
IS
   attr_        VARCHAR2(32000);
   newrec_      ORDER_QUOTATION_COMPETITOR_TAB%ROWTYPE;
   objid_       rowid;
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN   
   Client_SYS.Clear_Attr( attr_ );
   Client_SYS.Add_To_Attr( 'QUOTATION_NO', quotation_no_, attr_ );
   Client_SYS.Add_To_Attr( 'COMPETITOR_ID', competitor_id_, attr_ );
   Client_SYS.Add_To_Attr( 'COMPETE_ID', compete_id_, attr_ );
   Client_SYS.Add_To_Attr( 'NOTE', note_, attr_ );
   Client_SYS.Add_To_Attr( 'MAIN_COMPETITOR_DB', main_competitor_, attr_ );
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___( objid_, objversion_, newrec_, attr_);
END New;


-- Modify
--   Public interface for modifying records
PROCEDURE Modify (
   quotation_no_ IN VARCHAR2,
   competitor_id_ IN VARCHAR2,
   compete_id_ IN VARCHAR2,
   note_ IN VARCHAR2,
   main_competitor_ IN VARCHAR2 )
IS
   attr_        VARCHAR2(32000);
   oldrec_      ORDER_QUOTATION_COMPETITOR_TAB%ROWTYPE;
   newrec_      ORDER_QUOTATION_COMPETITOR_TAB%ROWTYPE;
   objid_       rowid;
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN

   oldrec_ := Lock_By_Keys___(quotation_no_, competitor_id_);
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
   competitor_id_ IN VARCHAR2)
IS
   remrec_     ORDER_QUOTATION_COMPETITOR_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, competitor_id_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;



