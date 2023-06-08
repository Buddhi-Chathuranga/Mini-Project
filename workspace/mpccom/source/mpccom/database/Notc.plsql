-----------------------------------------------------------------------------
--
--  Logical unit: Notc
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140320  AwWelk   PBSC-7677, Modified Insert_Or_Update__ () to correctly insert basic data translations.
--  120525  JeLise   Made description private.
--  120511  JeLise   Replaced all calls to Module_Translate_Attr_Util_API with calls to Basic_Data_Translation_API
--  120511           in New___, Modify__, Delete___, Insert_Or_Update__, Get_Description and in the view. 
--  100429  Ajpelk   Merge rose method documentation
--  ---------------------------Eagle--------------------------------------------
--  070328   RaKalk  Added Get_Description function
--  041026  HaPulk  Moved methods Insert_Lu_Translation from Insert___ to New__ and
--  041026          Modify_Translation from Update___ to Modify__.
--  040929  HaPulk  Renamed Insert_Lu_Data_Rec__ as Insert_Or_Update__ and changed the logic.
--  040224  SaNalk  Removed SUBSTRB.
--  ---------------------------- 13.3.0 --------------------------------------
--  030930  ThGulk Changed substr to substrb, instr to instrb, length to lengthb.
--  020128  DaMase  IID 21001, Component Translation support. Insert_Lu_Data_Rec__
--  010209  ANLASE  Created, added undefines
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Or_Update__
--   Handles component translations
PROCEDURE Insert_Or_Update__ (
   rec_ IN NOTC_TAB%ROWTYPE )
IS
   dummy_        VARCHAR2(1);
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(32000);
   indrec_       Indicator_Rec;
   newrec_       NOTC_TAB%ROWTYPE;
   oldrec_       NOTC_TAB%ROWTYPE;

   CURSOR Exist IS
      SELECT 'X'
      FROM NOTC_TAB
      WHERE notc = rec_.notc;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);

   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      Client_SYS.Add_To_Attr('NOTC', rec_.notc, attr_);      
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      newrec_.rowversion := sysdate;
      INSERT
         INTO notc_tab
         VALUES newrec_
         RETURNING rowid INTO objid_;
   ELSE
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.notc);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;      
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      newrec_.rowversion := sysdate;
      UPDATE notc_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   CLOSE Exist;
   
   -- Insert Data into Basic Data Translations tab
   Basic_Data_Translation_API.Insert_Prog_Translation('MPCCOM',
                                                      'Notc',
                                                      newrec_.notc,
                                                      newrec_.description);
END Insert_Or_Update__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   notc_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ notc_tab.description%TYPE;
BEGIN
   IF (notc_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      notc_), 1, 50);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  notc_tab
      WHERE notc = notc_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(notc_, 'Get_Description');
END Get_Description;



