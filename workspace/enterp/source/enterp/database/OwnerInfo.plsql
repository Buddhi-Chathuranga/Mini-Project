-----------------------------------------------------------------------------
--
--  Logical unit: OwnerInfo
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
--  990820  BmEk    Removed Error_SYS.Check_Not_Null in Unpack_Check_Insert___ for owner_id. 
--                  Added a control in Insert___ instead, to check if owner_id is null. This 
--                  because it should be possible to fetch an automatic generated owner_id 
--                  from LU PartyIdentitySeries. Also added the procedure Get_Identity___. 
--  000128  Mnisse  Check on capital letters for ID, bug #30596.
--  000525  LiSv    Removed call to Check_If_Null___ (this is an old solution).
--  010504  Inkase  Bug #20229, Added check if entered country or language is 2 characters, 
--                  then save it, else encode it. Also set uppercase on country.
--  041004  SAAHLK  LCS Patch Merge, Bug 37877.
--  131023  Isuklk  CAHOOK-2836 Refactoring in OwnerInfo.entity
--  140725  Hecolk  PRFI-41, Moved code that generates Owner Id from Check_Insert___ to Insert___ 
--  151012  chiblk  STRFI-233  Creating records using New___ method
--  200624  jagrno  Added ObjectConnectionMethod annotation for method Get_Doc_Object_Description
--  210325  kugnlk  FI21R2-451, Get rid of string manipulations in db - Modified Modify method.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Obj_Info___ (
   owner_id_   IN VARCHAR2,
   objid_      OUT VARCHAR2,
   objversion_ OUT VARCHAR2 )
IS
BEGIN
   SELECT objid, objversion
   INTO   objid_, objversion_
   FROM   owner_info
   WHERE  owner_id = owner_id_;
END Get_Obj_Info___;


PROCEDURE Get_Next_Party___ (
   newrec_ IN OUT owner_info_tab%ROWTYPE )
IS
BEGIN
   Party_Id_API.Get_Next_Party('DEFAULT', newrec_.party);   
END Get_Next_Party___;


PROCEDURE Get_Identity___ (   
   attr_   IN OUT VARCHAR2,
   newrec_ IN OUT owner_info_tab%ROWTYPE )
IS
   party_type_   owner_info_tab.party_type%TYPE;
   owner_id_     owner_info_tab.owner_id%TYPE;
BEGIN
   party_type_   := newrec_.party_type;
   owner_id_     := newrec_.owner_id;
   IF (owner_id_ IS NULL) THEN
      LOOP
         Party_Identity_Series_API.Get_Next_Identity(owner_id_, party_type_);
         EXIT WHEN NOT Check_Exist___(owner_id_);
      END LOOP;
      IF (owner_id_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'OWNER_ERROR: Error while retrieving the next free identity. Check the identity series for owner');
      END IF;
      newrec_.owner_id := owner_id_;
      Client_SYS.Set_Item_Value('OWNER_ID', owner_id_, attr_);
   END IF;
END Get_Identity___;       


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     owner_info_tab%ROWTYPE,
   newrec_ IN OUT owner_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Association_Info_API.Check_Association_No(newrec_.association_no, 'OWNER');
   IF (newrec_.association_no IS NOT NULL AND indrec_.association_no = TRUE) THEN
      Association_Info_API.Warn_Association_No(newrec_.association_no, NVL(newrec_.owner_id, oldrec_.owner_id), 'OWNER');
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
   Client_SYS.Add_To_Attr('PARTY_TYPE', Party_Type_API.Decode('OWNER'), attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT owner_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Get_Identity___(attr_, newrec_);
   Get_Next_Party___(newrec_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT owner_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   IF (indrec_.owner_id = TRUE) THEN            
      IF (UPPER(newrec_.owner_id) != newrec_.owner_id) THEN
         Error_SYS.Record_General(lu_name_, 'CAPCHECK: Only capital letters are allowed in the ID.');            
      END IF;
   END IF;           
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     owner_info_tab%ROWTYPE,
   newrec_ IN OUT owner_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN      
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PARTY', newrec_.party);
END Check_Update___;
               
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   owner_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(owner_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


@ObjectConnectionMethod
@UncheckedAccess
FUNCTION Get_Doc_Object_Description (
   owner_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   obj_description_    VARCHAR2(122);
   CURSOR get_obj_description IS
      SELECT owner_id||'-'||name description
      FROM   owner_info
      WHERE  owner_id = owner_id_;
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


PROCEDURE New (
   owner_id_         IN VARCHAR2,
   name_             IN VARCHAR2,
   association_no_   IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2 DEFAULT NULL,
   default_language_ IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       owner_info_tab%ROWTYPE;
BEGIN
   newrec_.owner_id           := owner_id_;
   newrec_.name               := name_;
   newrec_.creation_date      := TRUNC(SYSDATE);
   newrec_.party_type         := 'OWNER';
   newrec_.default_domain     := 'TRUE';
   newrec_.association_no     := association_no_;
   newrec_.country            := Iso_Country_API.Encode(country_);
   newrec_.default_language   := Iso_Language_API.Encode(default_language_);
   New___(newrec_);
END New;


PROCEDURE Modify (
   owner_id_         IN VARCHAR2,
   name_             IN VARCHAR2 DEFAULT NULL,
   association_no_   IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2 DEFAULT NULL,
   default_language_ IN VARCHAR2 DEFAULT NULL )
IS
   newrec_      owner_info_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(owner_id_);
   newrec_.name             := name_;
   newrec_.association_no   := association_no_;
   newrec_.country          := Iso_Country_API.Encode(country_);
   newrec_.default_language := Iso_Language_API.Encode(default_language_);
   Modify___(newrec_);
END Modify;


PROCEDURE Remove (
   owner_id_ IN VARCHAR2 )
IS
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
   remrec_      owner_info_tab%ROWTYPE;
BEGIN
   Get_Obj_Info___(owner_id_, objid_, objversion_);
   remrec_ := Lock_By_Id___(objid_, objversion_);   
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


