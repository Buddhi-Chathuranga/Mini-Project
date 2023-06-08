-----------------------------------------------------------------------------
--
--  Logical unit: BinaryObject
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980810  DAJO  Created
--  981014  MANY  Fixed compilation problem in Duplicate() for older Oracle
--                versions (Bug #2794)
--  020624  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  051115  JEHU  Made New__, Modify__ accept Db values for enumeration Binary Object Type    
--  090123  HAAR  Attribute Data has changed data type from Long Raw to Blob (Bug#78975).
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK Merged Rose Documentation.
-----------------------------------------------------------------------------


layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT BINARY_OBJECT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_next_id_ IS
      SELECT binary_object_seq.nextval 
      FROM dual;
BEGIN
   --
   -- Get next id
   --
   OPEN get_next_id_;
   FETCH get_next_id_ INTO newrec_.blob_id;
   CLOSE get_next_id_;
   --
   -- Insert
   --
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('BLOB_ID', newrec_.blob_id, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Length (
   blob_id_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN(Binary_Object_Data_Block_API.Get_Length(blob_id_, 1));
END Get_Length;


PROCEDURE Get_Object_Info (
   objid_            OUT VARCHAR2,
   objversion_       OUT VARCHAR2,
   display_text_     OUT VARCHAR2,
   file_name_        OUT VARCHAR2,
   file_path_        OUT VARCHAR2,
   external_storage_ OUT VARCHAR2,
   application_data_ OUT VARCHAR2,
   length_           OUT NUMBER,
   lob_objid_        OUT VARCHAR2,
   blob_id_          IN  NUMBER )
IS
   CURSOR get_attr IS
      SELECT objid, objversion, display_text, file_name, file_path, external_storage
      FROM BINARY_OBJECT
      WHERE blob_id = blob_id_;
BEGIN
   FOR rec IN get_attr LOOP
      objid_            := rec.objid;
      objversion_       := rec.objversion;
      display_text_     := rec.display_text;
      file_name_        := rec.file_name;
      file_path_        := rec.file_path;
      external_storage_ := rec.external_storage;
   END LOOP;
   application_data_ := Binary_Object_Data_Block_API.Get_Application_Data(blob_id_, 1);
   length_           := Binary_Object_Data_Block_API.Get_Length(blob_id_, 1);
   lob_objid_        := Binary_Object_Data_Block_API.Get_Objid(blob_id_, 1);
END Get_Object_Info;

-- Create_Or_Replace
--    Creates a new BinaryObject, or updates an existing object.
--    This function is typically called by clients to retrieve a reference to a
--    binary object, which can then be used to store the actual data blocks.
PROCEDURE Create_Or_Replace (
   blob_id_          IN OUT NUMBER,
   display_text_     IN     VARCHAR2,
   file_name_        IN     VARCHAR2,
   file_path_        IN     VARCHAR2,
   external_storage_ IN     VARCHAR2,
   length_           IN     NUMBER,
   type_             IN     VARCHAR2,
   application_data_ IN     VARCHAR2 DEFAULT NULL )
IS
   attr_        VARCHAR2(32000);
   objid_       VARCHAR2(1000);
   objversion_  VARCHAR2(1000);
   info_        VARCHAR2(1000);
   CURSOR get_version IS
      SELECT objid, objversion FROM BINARY_OBJECT WHERE blob_id = blob_id_;
BEGIN
   -- Build attribute string
   --
   Client_SYS.Add_To_Attr( 'DISPLAY_TEXT', display_text_, attr_ );
   Client_SYS.Add_To_Attr( 'FILE_NAME', file_name_, attr_ );
   Client_SYS.Add_To_Attr( 'FILE_PATH', file_path_, attr_ );
   Client_SYS.Add_To_Attr( 'EXTERNAL_STORAGE', external_storage_, attr_ );
   --Client_SYS.Add_To_Attr( 'LENGTH', length_, attr_ );
   Client_SYS.Add_To_Attr( 'APPLICATION_DATA', application_data_, attr_ );
   Client_SYS.Add_To_Attr( 'BINARY_OBJECT_TYPE', Binary_Object_Type_API.Decode( type_ ), attr_ );
   --
   -- Create new BinaryObject, or update existing
   --
   IF (blob_id_ IS NULL) OR(blob_id_ = 0) THEN
     -- Create new header
     New__( info_, objid_, objversion_, attr_, 'DO' );
     blob_id_ := Client_SYS.Get_Item_Value( 'BLOB_ID', attr_ );
   ELSE
     -- Modify existing header
     OPEN get_version;
     FETCH get_version INTO objid_, objversion_;
     IF get_version%FOUND THEN
       CLOSE get_version;
       Modify__( info_, objid_, objversion_, attr_, 'DO' );
       -- Delete any existing data blocks
       Binary_Object_Data_Block_API.Remove_( blob_id_ );
     ELSE
       CLOSE get_version;
       Exist( blob_id_ );
     END IF;
   END IF;
END Create_Or_Replace;

PROCEDURE Do_Delete (
   blob_id_ IN NUMBER )
IS
   info_ VARCHAR2(2000);
   objid_      BINARY_OBJECT.objid%TYPE;
   objversion_ BINARY_OBJECT.objversion%TYPE;
BEGIN
   -- Delete any existing data blocks
   --
   Binary_Object_Data_Block_API.Remove_( blob_id_ );
   --
   -- Remove this blob
   --
   Get_Id_Version_By_Keys___ (objid_,objversion_,blob_id_);
   Remove__ (info_,objid_,objversion_,'DO');
END Do_Delete;

PROCEDURE Duplicate (
   blob_id_ OUT NUMBER,
   blob_id_ref_ IN NUMBER )
IS
   rec_  BINARY_OBJECT_TAB%ROWTYPE;
   tmp_blob_id_ NUMBER;
BEGIN
   --
   -- Remove this blob
   --
   rec_ := Lock_By_Keys___( blob_id_ref_ );
   Create_Or_Replace( tmp_blob_id_, rec_.display_text, rec_.file_name, rec_.file_path, rec_.external_storage, Get_Length(blob_id_ref_), rec_.binary_object_type, rec_.application_data );
   --
   -- Copy all data blocks
   --
   Binary_Object_Data_Block_API.Copy_( blob_id_ref_, tmp_blob_id_ );
   blob_id_ := tmp_blob_id_;
END Duplicate;


