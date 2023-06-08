-----------------------------------------------------------------------------
--
--  Logical unit: CustomsInfo
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981124  Camk    Created
--  981126  Camk    Method Check_If_Null added
--  981202  Camk    Check on Association No added.
--  990125  Camk    Our_Id removed.
--  000128  Mnisse  Check on capital letters for ID, bug #30596.
--  000525  LiSv    Removed call to Check_If_Null___ (this is an old solution).
--  010504  Inkase  Bug #20229, Added check if entered country or language is 2 characters, 
--                  then save it, else encode it. Also set uppercase on country.
--  041004  SAAHLK  LCS Patch Merge, Bug 37877.
--  131024  Isuklk  PBFI-787 Refactoring in CustomsInfo.entity
--  210203  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in Methods New and Modify
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Obj_Info___ (
   customs_id_ IN  VARCHAR2,
   objid_      OUT VARCHAR2,
   objversion_ OUT VARCHAR2 )
IS
BEGIN
   SELECT objid, objversion
   INTO   objid_, objversion_
   FROM   customs_info
   WHERE  customs_id = customs_id_;
END Get_Obj_Info___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     customs_info_tab%ROWTYPE,
   newrec_ IN OUT customs_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   Association_Info_API.Check_Association_No(newrec_.association_no, 'CUSTOMS');
   IF (newrec_.association_no IS NOT NULL AND indrec_.association_no = TRUE) THEN
      Association_Info_API.Warn_Association_No(newrec_.association_no, NVL(newrec_.customs_id, oldrec_.customs_id), 'CUSTOMS');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);   
END Check_Common___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CREATION_DATE', TRUNC(SYSDATE), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customs_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   IF (indrec_.customs_id = TRUE) THEN
      IF (UPPER(newrec_.customs_id) != newrec_.customs_id) THEN
         Error_SYS.Record_General(lu_name_, 'CAPCHECK: Only capital letters are allowed in the ID.');
      END IF;
   END IF;   
   super(newrec_, indrec_, attr_);
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Doc_Object_Description (
   customs_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   obj_description_    VARCHAR2(122);
   CURSOR get_obj_description IS
      SELECT customs_id||'-'||name description
      FROM   customs_info
      WHERE  customs_id = customs_id_;
BEGIN
   OPEN get_obj_description;
   FETCH get_obj_description INTO obj_description_;
   IF (get_obj_description%NOTFOUND) THEN
      CLOSE get_obj_description;
      RETURN Language_SYS.Translate_Constant(lu_name_, 'NODOCDESC: No description available');
   END IF;
   CLOSE get_obj_description;
   RETURN obj_description_;
END Get_Doc_Object_Description;


@UncheckedAccess
FUNCTION Check_Exist (
   customs_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(customs_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE New (
   customs_id_       IN VARCHAR2,
   name_             IN VARCHAR2,
   association_no_   IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2 DEFAULT NULL,
   default_language_ IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       customs_info_tab%ROWTYPE;
BEGIN
   newrec_.customs_id         := customs_id_;
   newrec_.name               := name_;
   newrec_.creation_date      := TRUNC(SYSDATE);   
   newrec_.association_no     := association_no_;
   newrec_.country            := Iso_Country_API.Encode(country_);
   newrec_.default_language   := Iso_Language_API.Encode(default_language_);
   New___(newrec_);   
END New;


PROCEDURE Modify (
   customs_id_       IN VARCHAR2,
   name_             IN VARCHAR2 DEFAULT NULL,
   association_no_   IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2 DEFAULT NULL,
   default_language_ IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       customs_info_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(customs_id_);
   newrec_.name               := name_;
   newrec_.association_no     := association_no_;
   newrec_.country            := Iso_Country_API.Encode(country_);
   newrec_.default_language   := Iso_Language_API.Encode(default_language_);
   Modify___(newrec_);   
END Modify;


PROCEDURE Remove (
   customs_id_ IN VARCHAR2 )
IS
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
   remrec_      customs_info_tab%ROWTYPE;
BEGIN
   Get_Obj_Info___(customs_id_, objid_, objversion_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);      
END Remove;



