-----------------------------------------------------------------------------
--
--  Logical unit: MpccomDocument
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210111  DiJwlk  SC2020R1-11841, Modified Insert_Or_Update__() by removing string manipulations to optimize performance.
--  140423  ChJalk  PBSC-8426, Modified the method Check_Update___ to correct the condition for raising the error message Item_Update for 'DOCUMENT_PHRASE_SUPPORT'.
--  121010  ChFolk  Bug 105715, Modified view comments of document_phrase_support to set update not allow to consistance with the model.
--  120525  JeLise   Made description private.
--  120507  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120507           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507           was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  120814  SBalLK  Bug 101597, Modified Insert_Or_Update__ by avoiding update output_code column and to insert and update document_phrase_support column.
--  120720  SBallk  Bug 101597, Modified Insert___, Unpack_Check_Update___ and Update___ methods for
--  120720          enhance the document phrase functionality to company and site level. Get_Document_Phrase_Support, Get_Document_Phrase_Support_Db 
--  120720          and Get method for get document phrase functionality to enhance code readability in report (rpt)  files.
--  100429  Ajpelk  Merge rose method documentation
-- ----------------------------Eagle------------------------------------------
--  041026  HaPulk  Moved methods Insert_Lu_Translation from Insert___ to New__ and 
--  041026          Modify_Translation from Update___ to Modify__.
--  040929  HaPulk  Renamed Insert_Lu_Data_Rec__ as Insert_Or_Update__ and changed the logic.
--  040224  SaNalk  Removed SUBSTRB.
-- ------------------------------ 13.3.0 --------------------------------------
--  030930  ThGulk Changed substr to substrb, instr to instrb, length to lengthb.
--  020116  DaMase  IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  000925  JOHESE  Added undefines.
--  990422  JOHW  General performance improvements.
--  990414  JOHW  Upgraded to performance optimized template.
--  971121  TOOS  Upgrade to F1 2.0
--  970313  CHAN  Changed table name: documents is replaced by
--                mpccom_document_tab
--  970226  PELA  Uses column rowversion as objversion (timestamp).
--  961214  JOKE  Modified with new workbench default templates.
--  961106  JOBE  Additional changes for compability with workbench.
--  961030  JOKE  Changed for compatibility with workbench.
--  960612  AnAr  Optimized code in Get_Description.
--  960607  AnAr  Added Get_Description.
--  960523  JOHNI Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     mpccom_document_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY mpccom_document_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2,
   updated_by_client_   IN     BOOLEAN DEFAULT TRUE )
IS
   
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (Validate_Sys.Is_Changed(oldrec_.document_phrase_support, newrec_.document_phrase_support)) AND (updated_by_client_) THEN
      Error_SYS.Item_Update(lu_name_, 'DOCUMENT_PHRASE_SUPPORT');
   END IF;
END Check_Update___;


-- Insert_Or_Update__
--   Handles component translations.
PROCEDURE Insert_Or_Update__ (
   rec_ IN MPCCOM_DOCUMENT_TAB%ROWTYPE )
IS
   dummy_        VARCHAR2(1);
   newrec_       MPCCOM_DOCUMENT_TAB%ROWTYPE;
   CURSOR Exist IS
      SELECT 'X'
      FROM MPCCOM_DOCUMENT_TAB
      WHERE document_code = rec_.document_code;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      newrec_.description              := rec_.description;
      newrec_.document_phrase_support  := rec_.document_phrase_support;
      newrec_.document_code            := rec_.document_code;
      newrec_.output_code              := rec_.output_code;
      New___(newrec_);
   ELSE
      newrec_                          := Lock_By_Keys___(rec_.document_code);
      newrec_.description              := rec_.description;
      newrec_.document_phrase_support  := rec_.document_phrase_support;
      Modify___(newrec_);
   END IF;
   CLOSE Exist;
   -- Insert Data into Basic Data Translations tab
   Basic_Data_Translation_API.Insert_Prog_Translation('MPCCOM',
                                                      'MpccomDocument',
                                                      newrec_.document_code,
                                                      newrec_.description);
END Insert_Or_Update__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


