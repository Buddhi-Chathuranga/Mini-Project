-----------------------------------------------------------------------------
--
--  Logical unit: ReportCategory
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990301  DAJO  Rearrangements in LOV-view for Project Invader (ToDo #3177).
--  020624  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021118  ROOD  Removed attribute protection (GLOB11). Updated template.
--  021129  ROOD  Corrected syntax in Get_By_Description (GLOB11).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   category_id_ NUMBER;
BEGIN
   super(attr_);
   SELECT report_category_seq.nextval
      INTO category_id_
      FROM dual;
   Client_SYS.Add_To_Attr('CATEGORY_ID', category_id_, attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Description (
   category_id_ IN NUMBER,
   description_ IN VARCHAR2 )
IS
   newrec_     REPORT_CATEGORY_TAB%ROWTYPE;
   oldrec_     REPORT_CATEGORY_TAB%ROWTYPE;
   objid_      REPORT_CATEGORY.objid%TYPE;
   objversion_ REPORT_CATEGORY.objversion%TYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(category_id_);
   newrec_ := oldrec_;
   Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   Client_SYS.Clear_Info;
END Set_Description;


FUNCTION Get_By_Description (
   description_ IN VARCHAR2 ) RETURN NUMBER
IS
   rec_        REPORT_CATEGORY_TAB%ROWTYPE;
   objid_      REPORT_CATEGORY.objid%TYPE;
   objversion_ REPORT_CATEGORY.objversion%TYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;

   CURSOR get_record IS
      SELECT *
      FROM  REPORT_CATEGORY_TAB
      WHERE description = description_;
BEGIN
   IF (description_ IS NOT NULL) THEN
      OPEN get_record;
      FETCH get_record INTO rec_;
      IF get_record%NOTFOUND THEN
         CLOSE get_record;
         Prepare_Insert___(attr_);
         Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
         Unpack___(rec_, indrec_, attr_);
         Check_Insert___(rec_, indrec_, attr_);      
         Insert___(objid_, objversion_, rec_, attr_);
      ELSE
         CLOSE get_record;
      END IF;
      RETURN rec_.category_id;
   ELSE
      RETURN NULL;
   END IF;
END Get_By_Description;



