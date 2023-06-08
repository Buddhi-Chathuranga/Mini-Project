-----------------------------------------------------------------------------
--
--  Logical unit: ComponentPatchRow
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050406  STDAFI  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT component_patch_row_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.component IS NOT NULL THEN
      Module_API.Exist(newrec_.component);
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Comp_Patch_Registration_Row_ (
   patch_id_     IN NUMBER,   
   component_    IN VARCHAR2,
   version_      IN VARCHAR2,
   file_name_    IN VARCHAR2)
IS
   objid_        COMPONENT_PATCH_ROW.objid%TYPE;
   objversion_   COMPONENT_PATCH_ROW.objversion%TYPE;
   newrec_       COMPONENT_PATCH_ROW_TAB%ROWTYPE;
   attr_         VARCHAR2(4000);

BEGIN
   Error_SYS.Check_Not_Null(lu_name_, 'PATCH_ID', patch_id_);
   Error_SYS.Check_Not_Null(lu_name_, 'COMPONENT', component_);
   Error_SYS.Check_Not_Null(lu_name_, 'VERSION', version_);   
   Error_SYS.Check_Not_Null(lu_name_, 'FILE_NAME', file_name_);
   
   IF (NOT Check_Exist___(patch_id_, component_, version_, file_name_)) THEN

      -- Create the record
      newrec_.patch_id    := patch_id_;
      newrec_.component   := component_;
      newrec_.version     := version_;
      newrec_.file_name   := file_name_;
      newrec_.rowversion  := SYSDATE;
      Insert___(objid_, objversion_, newrec_, attr_);
   
   END IF;

END Comp_Patch_Registration_Row_;


@UncheckedAccess
FUNCTION Comp_Patch_Row_Is_Registered_ (
   patch_id_     IN NUMBER,
   component_    IN VARCHAR2,
   version_      IN VARCHAR2,
   file_name_    IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(patch_id_, component_, version_, file_name_);
END Comp_Patch_Row_Is_Registered_;


@UncheckedAccess
PROCEDURE Comp_Patch_Row_Clear_Reg_ (
   patch_id_     IN NUMBER,
   component_    IN VARCHAR2 DEFAULT '%',
   version_      IN VARCHAR2 DEFAULT '%',
   file_name_    IN VARCHAR2 DEFAULT '%')
IS
   CURSOR getrec IS
      SELECT rowid
      FROM  COMPONENT_PATCH_ROW_TAB
      WHERE patch_id = patch_id_
      AND   component like component_
      AND   version  like version_
      AND   file_name like file_name_;
BEGIN
   FOR rec IN getrec LOOP
       DELETE FROM component_patch_row_tab WHERE rowid = rec.rowid;
   END LOOP;
END Comp_Patch_Row_Clear_Reg_;


@UncheckedAccess
FUNCTION Include_Centura_ (
   patch_id_     IN NUMBER,
   component_    IN VARCHAR2,
   version_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR getrec IS
      SELECT 1
      FROM  COMPONENT_PATCH_ROW_TAB
      WHERE patch_id  = patch_id_
      AND   component = component_
      AND   version   = version_
      AND   substr(file_name,length(file_name)-3) IN 
              ('.apt','.apx','.apl','.app','.qrp');
BEGIN
   OPEN getrec;
   FETCH getrec INTO dummy_;
   IF (getrec%FOUND) THEN
      CLOSE getrec;
      RETURN(TRUE);
   END IF;
   CLOSE getrec;
   RETURN(FALSE);
END Include_Centura_;


@UncheckedAccess
FUNCTION Include_Web_ (
   patch_id_     IN NUMBER,
   component_    IN VARCHAR2,
   version_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR getrec IS
      SELECT 1
      FROM  COMPONENT_PATCH_ROW_TAB
      WHERE patch_id  = patch_id_
      AND   component = component_
      AND   version   = version_
      AND   (substr(file_name,length(file_name)-4) = '.java'
             OR substr(file_name,length(file_name)-5) = '.class');
BEGIN
   OPEN getrec;
   FETCH getrec INTO dummy_;
   IF (getrec%FOUND) THEN
      CLOSE getrec;
      RETURN(TRUE);
   END IF;
   CLOSE getrec;
   RETURN(FALSE);
END Include_Web_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


