-----------------------------------------------------------------------------
--
--  Logical unit: PresObject
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000218  ERFO  Added view PRES_OBJECT_BUILD.
--  000221  PeNi  Added view PRES_OBJECT_SECURITY_BUILD.
--  000222  PeNi  Added rowversion and objid to additional views.
--  000224  PeNi  Added Get_Description
--  000225  ERFO  Changed server behavior for IID-simulated type definitions.
--  000225  PeNi  Added decode to view.
--  000225  PeNi  Added description to view.
--  000225  PeNi  Modified Unpack_Check_Update__
--  000225  PeNi  Added logic for update of description in Modify__
--  000401  PeNi  Added pres_object_type_db
--  000426  PeNi  Added validate_po_id
--  000501  PeNi  Added logic for 'Modified'
--  000503  PeNi  Made info_type public
--  000524  PeNi  New definition of po id for portlets.
--  010820  ROOD  Added 'page' as an allowed file extension for web-pages
--                and added Validate_Report_Po_Id___ (ToDo#3991).
--  020626  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030616  ROOD  Removed call to Remove_Dependency. Now handled with
--                references instead (Bug#36465).
--  050413  RAKU  Added PRES_OBJECT_TYPE_DB in both Unpack* methods (F1PR480).
--  121024  MADD  Change GET_DESCRIPTION for handle null values(106187).
--  121025  USRA  Added validation for INFO_TYPE (Bug#106173).
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

SUBTYPE table_rec IS pres_object_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   layer_id_ Fnd_Layer_TAB.layer_id%TYPE;
   CURSOR get_layer IS 
      SELECT layer_id
      FROM fnd_layer
      ORDER BY ordinal DESC;

BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('INFO_TYPE', 'Manual', attr_);
   Client_SYS.Add_To_Attr('ALLOW_READ_ONLY_DB','TRUE', attr_);
   OPEN get_layer;
   FETCH get_layer INTO layer_id_;
   CLOSE get_layer;
   Client_SYS.Add_To_Attr('LAYER_ID',layer_id_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT NOCOPY pres_object_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   Validate_Po_Id(newrec_.po_id, newrec_.module, Pres_Object_Type_API.Decode(newrec_.pres_object_type));
   --
   IF (newrec_.info_type IS NOT NULL) THEN
       Validate_Info_Type___(newrec_.info_type);
   END IF;
END Check_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PRES_OBJECT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   IF (Client_SYS.Get_Item_Value('DESCRIPTION', attr_) IS NOT NULL) THEN 
      Pres_Object_Description_API.Insert_Description(newrec_.po_id, Nvl(Fnd_Session_API.Get_Language, 'en'),  Client_SYS.Get_Item_Value('DESCRIPTION', attr_));
   END IF;
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     pres_object_tab%ROWTYPE,
   newrec_     IN OUT pres_object_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   --Add pre-processing code here
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (Client_SYS.Get_Item_Value('DESCRIPTION', attr_) IS NOT NULL) THEN 
      Pres_Object_Description_API.Modify_Description(newrec_.po_id, Nvl(Fnd_Session_API.Get_Language, 'en'), Client_SYS.Get_Item_Value('DESCRIPTION', attr_));
   END IF;
END Update___;

   
PROCEDURE Validate_Windows_Po_Id___ (
   po_id_ IN VARCHAR2 )
IS
   prefix_   VARCHAR2(3);
BEGIN
   prefix_ := substr(po_id_, 1, 3);
   IF prefix_ NOT IN ('dlg', 'frm', 'tbw', 'dyn', 'viz') THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDPREFIX: The presentation object id [:P1] for a Windows form must begin with the prefix "dlg", "frm", "tbw" or "viz".', po_id_);
   END IF;
END Validate_Windows_Po_Id___;


PROCEDURE Validate_Web_Po_Id___ (
   po_id_ IN VARCHAR2 )
IS
   pos_module_ NUMBER;
   pos_file_   NUMBER;
   length_     NUMBER;
   module_     VARCHAR2(10);
   file_ext_   VARCHAR2(10);
   dummy_      NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   MODULE
      WHERE  module = upper(module_);
BEGIN
   pos_module_ := instr(po_id_, '/', 1);
   pos_file_ := instr(po_id_, '.', 1);
   length_ := length(po_id_);

   IF (pos_module_ > 0) AND (pos_file_ > 0) THEN
      module_ := substr(po_id_, 1, pos_module_ -1);
      file_ext_ := substr(po_id_, pos_file_ + 1, length_ - pos_file_);

      -- Check module
      -- Does it exist?
      IF (module_ != 'FND') THEN -- Don't check FND
         OPEN exist_control;
         FETCH exist_control INTO dummy_;
         IF (NOT exist_control%FOUND) THEN
            CLOSE exist_control;
            Error_SYS.Record_General(lu_name_, 'INVALIDWEBMODULE: The id for web pages must begin with the name of the module. Module ":P1" does not exist!', module_);
         END IF;
         CLOSE exist_control;
      END IF;
      
      -- Is it in upper case?
      IF (module_ != upper(module_)) THEN
         Error_SYS.Record_General(lu_name_, 'MODULEINUPPER: The part of the id that represent the module name must be in upper case for web pages!');
      END IF;

      -- Check file extension
      IF file_ext_ != 'asp' AND file_ext_ != 'page' THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDFILEEXT: Invalid file extension! The part of the id that represent the file name must end with ".asp" or ".page" for web pages!');
      END IF;
   ELSE
      IF (module_ != 'FND') THEN -- Don't check FND
         Error_SYS.Record_General(lu_name_, 'INVALIDWEBPATTERN: The presentation object id for web pages must follow this particular pattern: "<MODULE>/<FileName>.asp"');
      END IF;
   END IF;
END Validate_Web_Po_Id___;


PROCEDURE Validate_Portal_Po_Id___ (
   po_id_ IN VARCHAR2 )
IS
   pos_company_  NUMBER;
   pos_module_   NUMBER;
   pos_portlets_ NUMBER;
   company_      VARCHAR2(100);
   module_       VARCHAR2(100);
   portlets_     VARCHAR2(100);
   dummy_        NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   MODULE
      WHERE  module = upper(module_);
BEGIN
   pos_company_  := instr(po_id_, '.', 1, 1);
   pos_module_   := instr(po_id_, '.', 1, 2);
   pos_portlets_ := instr(po_id_, '.', 1, 3);


   IF (pos_company_ > 0) AND (pos_module_ >0 AND pos_portlets_>0) THEN
      company_ := substr(po_id_, 1, pos_company_ - 1);
      module_ := substr(po_id_, pos_company_ + 1, pos_module_ - pos_company_ - 1);
      portlets_ := substr(po_id_, pos_module_ + 1, pos_portlets_ - pos_module_ - 1);

      -- Check company name
      IF company_ != 'ifs' THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDCOMPNAME: The presentation object id must begin with "ifs"');
      END IF;

      -- Check module
      -- Does it exist?
      IF (module_ != 'fnd') THEN
         OPEN exist_control;
         FETCH exist_control INTO dummy_;
         IF (NOT exist_control%FOUND) THEN
            CLOSE exist_control;
            Error_SYS.Record_General(lu_name_, 'INVALIDMODULE: The second part of the id must be the name of the module. Module ":P1" does not exist!', module_);
         END IF;
         CLOSE exist_control;
      END IF;

      -- In lower case?
      IF lower(module_) != module_ THEN
         Error_SYS.Record_General(lu_name_, 'MODULENAMEINLOWER: The part of the id that contains the module name must be in lower case!');
      END IF;

      -- Check portlets
      IF portlets_ != 'portlets' THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDPORT: The third part of the id must be "portlets"');
      END IF;

   ELSE
      Error_SYS.Record_General(lu_name_, 'INVALIDPOPATTERN: The presentation object id for a portal must follow this particular patter: "ifs.<module>.portlets[.<sub-dir>].<ClassName>"!');
   END IF;
END Validate_Portal_Po_Id___;


PROCEDURE Validate_Global_Po_Id___ (
   po_id_ IN VARCHAR2,
   module_ IN VARCHAR2 )
IS
   prefix_ VARCHAR2(10);
BEGIN
   -- Check prefix
   prefix_ := substr(po_id_, 1, 6);
   IF prefix_ != 'global' THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDGLOBPREFIX: A global presentation object must begin with "global"');
   END IF;
   -- Check Module Name
   Module_API.Exist(module_);
   IF upper(module_) != module_ THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDMODCASE: Module name must be in upper case!');
   END IF;
END Validate_Global_Po_Id___;

PROCEDURE Validate_Report_Po_Id___ (
   po_id_ IN VARCHAR2 )
IS
   prefix_   VARCHAR2(3);
   length_   NUMBER;
   rep_view_ VARCHAR2(30);
BEGIN
   IF (po_id_ LIKE '%ifsExcelReport') THEN
      NULL;
   ELSE 
      -- Check prefix
      prefix_ := substr(po_id_, 1, 3);
      IF prefix_ != 'rep' THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDREPPREFIX: A report presentation object must begin with "rep"');
      END IF;
      -- Check Report View Name (the rest of the name)
      length_ := Length(po_id_);
      rep_view_ := substr(po_id_, 4, length_ - 3);
      IF upper(rep_view_) != rep_view_ THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDREPVIEWCASE: Report view part of name for a report presentation object must be in upper case!');
      END IF;
   END IF;
END Validate_Report_Po_Id___;


PROCEDURE Validate_Info_Type___ (
   info_type_ IN VARCHAR2 )
IS
BEGIN
   IF ( info_type_ NOT IN ( 'Auto', 'Manual', 'Modified' ) ) THEN
      Error_SYS.Item_Format(lu_name_, 'INFO_TYPE', info_type_);
   END IF;
END Validate_Info_Type___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   po_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
  --If no translation found ,return in English
  RETURN NVL(Pres_Object_Description_API.Get_Description(po_id_, Fnd_Session_API.Get_Language),Pres_Object_Description_API.Get_Description(po_id_,'en'));
END Get_Description;



@UncheckedAccess
PROCEDURE Set_Change_Date (
   po_id_ IN VARCHAR2 )
IS
   newrec_     PRES_OBJECT_TAB%ROWTYPE;
   oldrec_     PRES_OBJECT_TAB%ROWTYPE;
   attr_       VARCHAR2(100);
   objversion_ VARCHAR2(100);
   record_removed  EXCEPTION;
   PRAGMA EXCEPTION_INIT(record_removed, -20115);
BEGIN
   IF (Check_Exist___(po_id_)) THEN
      newrec_ := Lock_By_Keys___ (po_id_);
      newrec_.change_date := sysdate;
      Update___ (NULL, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
EXCEPTION
   WHEN record_removed THEN
      NULL;
END Set_Change_Date;

PROCEDURE Validate_Po_Id (
   po_id_ IN VARCHAR2,
   module_  IN VARCHAR2,
   pres_object_type_ IN VARCHAR2 )
IS
   prefix_              VARCHAR2(20);
   pres_object_type_db_ VARCHAR2(50) := Pres_Object_Type_API.Encode(pres_object_type_);
BEGIN
   prefix_ := substr(po_id_, 1, 6);
   IF lower(prefix_) = 'global' THEN
      Validate_Global_Po_Id___(po_id_, module_);
   ELSIF pres_object_type_db_ =  'WIN' THEN
      Validate_Windows_Po_Id___(po_id_);
   ELSIF pres_object_type_db_ =  'WEB' THEN
      Validate_Web_Po_Id___(po_id_);
   ELSIF pres_object_type_db_ =  'PORT' THEN
      Validate_Portal_Po_Id___(po_id_);
   ELSIF pres_object_type_db_ =  'REP' THEN
      Validate_Report_Po_Id___(po_id_);
   END IF;
END Validate_Po_Id;


PROCEDURE New_Pres_Object (
   rec_  IN OUT table_rec )
IS
BEGIN
   New___(rec_);
END New_Pres_Object;

PROCEDURE Modify_Pres_Object (
   rec_  IN OUT table_rec )
IS
BEGIN
   Modify___(rec_);
END Modify_Pres_Object;

FUNCTION Lock_By_Keys_Nowait (
   po_id_ IN VARCHAR2 ) RETURN pres_object_tab%ROWTYPE
IS
BEGIN
   RETURN(Lock_By_Keys_Nowait___(po_id_));
END Lock_By_Keys_Nowait;

--SOLSETFW
FUNCTION Is_Active (
   po_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (po_id_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  pres_object_tab a
      WHERE po_id = po_id_
        AND EXISTS (SELECT 1 FROM module_tab m
                     WHERE a.module = m.module
                       AND m.active = 'TRUE');
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(po_id_, 'Is_Active');
END Is_Active;