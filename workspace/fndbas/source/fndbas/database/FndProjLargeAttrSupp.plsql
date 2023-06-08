-----------------------------------------------------------------------------
--
--  Logical unit: FndLargeAttribute
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT fnd_proj_large_attr_supp_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF ((newrec_.clob_size > 0 OR newrec_.blob_size > 0) AND newrec_.attribute_size_modified != 'TRUE') OR
         (newrec_.clob_size = 0 AND newrec_.blob_size = 0 AND newrec_.attribute_size_modified = 'TRUE') THEN
      Error_SYS.Item_General(lu_name_, 'ATTRIBUTE_SIZE_MODIFIED', 'CLOB_BLOB_SIZE_GE_ZERO: clob_size or blob_size must be greater than zero if attribute_size_modified is set to "TRUE"');
   END IF;
   super(objid_, objversion_, newrec_, attr_);
   Model_Design_SYS.Refresh_Projection_Version(newrec_.projection_name);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     fnd_proj_large_attr_supp_tab%ROWTYPE,
   newrec_     IN OUT fnd_proj_large_attr_supp_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF ((newrec_.clob_size > 0 OR newrec_.blob_size > 0) AND
         ((newrec_.attribute_size_modified IS NULL AND oldrec_.attribute_size_modified = 'FALSE') OR
            (newrec_.attribute_size_modified IS NOT NULL AND newrec_.attribute_size_modified = 'FALSE'))) OR
      (newrec_.clob_size = 0 AND newrec_.blob_size = 0 AND
         ((newrec_.attribute_size_modified IS NULL AND oldrec_.attribute_size_modified = 'TRUE') OR
            (newrec_.attribute_size_modified IS NOT NULL AND newrec_.attribute_size_modified = 'TRUE'))) THEN
      Error_SYS.Item_General(lu_name_, 'ATTRIBUTE_SIZE_MODIFIED', 'CLOB_BLOB_SIZE_GE_ZERO: clob_size or blob_size must be greater than zero if attribute_size_modified is set to "TRUE"');
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Model_Design_SYS.Refresh_Projection_Version(newrec_.projection_name);
END Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     fnd_proj_large_attr_supp_tab%ROWTYPE,
   newrec_ IN OUT fnd_proj_large_attr_supp_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.blob_size < 0 OR newrec_.clob_size < 0 THEN
      Error_SYS.Appl_General(lu_name_, 'NOTNEGATIVE: clob_size or blob_size must be a positive integer.');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Or_Replace (
   projection_name_ IN VARCHAR2)
IS
   rec_ fnd_proj_large_attr_supp_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_; 
   
   IF (NOT Check_Exist___(projection_name_)) THEN
      New___(rec_);
   END IF;    
   
END Create_Or_Replace;

PROCEDURE Set_Lob_Max_Size_Modifiable(
   projection_name_  IN VARCHAR2,
   modifiable_       IN BOOLEAN DEFAULT TRUE)
IS
   rec_ fnd_proj_large_attr_supp_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   
   IF modifiable_ THEN
      IF (NOT Check_Exist___(projection_name_)) THEN
         New___(rec_);
      END IF;
   ELSE
      IF Check_Exist___(projection_name_) THEN
         Remove___(rec_);
      END IF;
   END IF;
END Set_Lob_Max_Size_Modifiable;


PROCEDURE Remove_Proj_Large_Attr (
   projection_name_ IN VARCHAR2,   
   show_info_       IN BOOLEAN DEFAULT FALSE)
IS
   rec_ fnd_proj_large_attr_supp_tab%ROWTYPE;
BEGIN
   IF Check_Exist___(projection_name_) THEN
      rec_ := Get_Object_By_Keys___(projection_name_);
      Remove___(rec_,FALSE);         
      
      IF (show_info_) THEN
         Dbms_Output.Put_Line('Remove_Proj_Large_Attr: Large attribute size modify support is being removed for the projection ' || projection_name_);
      END IF;   
   END IF;  
END Remove_Proj_Large_Attr;


FUNCTION Get_Attribute_Size (
   projection_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS  
   json_       VARCHAR2(200)  := '"LobMaxSizeMeta": ';
   clob_size_  NUMBER         := Get_Clob_Size(projection_name_);
   blob_size_  NUMBER         := Get_Blob_Size(projection_name_);
BEGIN
   IF Get_Attribute_Size_Modified(projection_name_) = 'TRUE' THEN
      json_ := json_ || '{"ResizeEnabled": true';
      IF clob_size_ > 0 THEN
         json_ := json_ || ',"ClobSize": ' || clob_size_;
      END IF;
      IF blob_size_ > 0 THEN
         json_ := json_ || ',"BlobSize": ' || blob_size_;
      END IF;
      json_ := json_ || '}';
   ELSE
      json_ := json_|| '{"ResizeEnabled": false}';
   END IF;
   
   RETURN json_;
END Get_Attribute_Size;


