-----------------------------------------------------------------------------
--
--  Logical unit: ManufacturerInfo
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981123  Camk    Created
--  981126  Camk    Method Check_If_Null added
--  981202  Camk    Check on Association No added.
--  990125  Camk    Our_Id removed.
--  990416  Camk    New template
--  990820  BmEk    Removed Error_SYS.Check_Not_Null in Unpack_Check_Insert___ for manufacturer_id.
--                  Added a control in Insert___ instead, to check if manufacturer_id is null. This
--                  because it should be possible to fetch an automatic generated manufacturer_id
--                  from LU PartyIdentitySeries. Also added the procedure Get_Identity___.
--  000128  Mnisse  Check on capital letters for ID, bug #30596.
--  000525  LiSv    Removed call to Check_If_Null___ (this is an old solution).
--  010504  Inkase  Bug #20229, Added check if entered country or language is 2 characters,
--                  then save it, else encode it. Also set uppercase on country.
--  041004  SAAHLK  LCS Patch Merge, Bug 37877.
--  050919  Hecolk  LCS Merge - Bug 52720, Added FUNCTION Get_Next_Identity and Removed PROCEDURE Get_Identity___
--  090728  Maanlk  Bug 84593, Modified Get_Next_Identity() to update the next available value correctly.
--  131023  Isuklk  CAHOOK-2834 Refactoring in ManufacturerInfo.entity
--  140725  Hecolk  PRFI-41, Moved code that generates Manufaturer Id from Check_Insert___ to Insert___ 
--  200624  jagrno  Added ObjectConnectionMethod annotation for method Get_Doc_Object_Description
--  210212  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in methods New and Modify
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     manufacturer_info_tab%ROWTYPE,
   newrec_ IN OUT manufacturer_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Association_Info_API.Check_Association_No(newrec_.association_no, 'MANUFACTURER');
   IF (newrec_.association_no IS NOT NULL AND indrec_.association_no = TRUE) THEN
      Association_Info_API.Warn_Association_No(newrec_.association_no, NVL(newrec_.manufacturer_id, oldrec_.manufacturer_id), 'MANUFACTURER');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);   
END Check_Common___;


PROCEDURE Get_Next_Party___ (
   newrec_ IN OUT manufacturer_info_tab%ROWTYPE )
IS
BEGIN
   Party_Id_API.Get_Next_Party('DEFAULT', newrec_.party);   
END Get_Next_Party___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CREATION_DATE', TRUNC(SYSDATE), attr_);
   Client_SYS.Add_To_Attr('PARTY_TYPE', Party_Type_API.Decode('MANUFACTURER'), attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT manufacturer_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.manufacturer_id IS NULL) THEN
      newrec_.manufacturer_id := Get_Next_Identity();            
      IF (newrec_.manufacturer_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'MANU_ERROR: Error while retrieving the next free identity. Check the identity series for manufacturer');
      END IF;
      Client_SYS.Set_Item_Value('MANUFACTURER_ID', newrec_.manufacturer_id, attr_);
   END IF;    
   Get_Next_Party___(newrec_);   
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT manufacturer_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (indrec_.manufacturer_id = TRUE) THEN      
      IF (UPPER(newrec_.manufacturer_id) != newrec_.manufacturer_id) THEN
         Error_SYS.Record_General(lu_name_, 'CAPCHECK: Only capital letters are allowed in the ID.');
      END IF;
   END IF;     
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     manufacturer_info_tab%ROWTYPE,
   newrec_ IN OUT manufacturer_info_tab%ROWTYPE,
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
   manufacturer_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(manufacturer_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


@ObjectConnectionMethod
@UncheckedAccess
FUNCTION Get_Doc_Object_Description (
   manufacturer_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   obj_description_    VARCHAR2(122);
   CURSOR get_obj_description IS
      SELECT manufacturer_id||'-'||name description
      FROM   manufacturer_info_tab
      WHERE  manufacturer_id = manufacturer_id_;
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
   manufacturer_id_  IN VARCHAR2,
   name_             IN VARCHAR2,
   association_no_   IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2 DEFAULT NULL,
   default_language_ IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       manufacturer_info_tab%ROWTYPE;
BEGIN
   newrec_.manufacturer_id    := manufacturer_id_;
   newrec_.name               := name_;
   newrec_.creation_date      := TRUNC(SYSDATE);
   newrec_.party_type         := Party_Type_API.DB_MANUFACTURER;
   newrec_.default_domain     := 'TRUE';
   newrec_.association_no     := association_no_;
   newrec_.country            := Iso_Country_API.Encode(country_);
   newrec_.default_language   := Iso_Language_API.Encode(default_language_);
   New___(newrec_);   
END New;


PROCEDURE Modify (
   manufacturer_id_  IN VARCHAR2,
   name_             IN VARCHAR2 DEFAULT NULL,
   association_no_   IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2 DEFAULT NULL,
   default_language_ IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       manufacturer_info_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(manufacturer_id_);
   newrec_.name               := name_;
   newrec_.association_no     := association_no_;
   newrec_.country            := Iso_Country_API.Encode(country_);
   newrec_.default_language   := Iso_Language_API.Encode(default_language_);
   Modify___(newrec_);    
END Modify;


PROCEDURE Remove (
   manufacturer_id_ IN VARCHAR2 )
IS
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
   remrec_      manufacturer_info_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, manufacturer_id_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


FUNCTION Get_Next_Identity  RETURN NUMBER
IS
   next_id_             NUMBER;
   party_type_db_       manufacturer_info_tab.party_type%TYPE := 'MANUFACTURER';
BEGIN
   next_id_ := Party_Identity_Series_API.Get_Next_Value(Party_Type_API.Decode(party_type_db_));  
   WHILE Check_Exist___(next_id_) LOOP
      next_id_ := next_id_ + 1;
   END LOOP;
   Party_Identity_Series_API.Update_Next_Value(next_id_ + 1, party_type_db_);         
   RETURN next_id_; 
END Get_Next_Identity;



