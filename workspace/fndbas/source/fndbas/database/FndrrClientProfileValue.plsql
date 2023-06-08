-----------------------------------------------------------------------------
--
--  Logical unit: FndrrClientProfileValue
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050307  RaKu  Created (F1PR483).
--  110311  MaBo  Rowversion is added as a table colum
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FNDRR_CLIENT_PROFILE_VALUE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.override_allowed := 0;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FNDRR_CLIENT_PROFILE_VALUE_TAB%ROWTYPE,
   newrec_     IN OUT FNDRR_CLIENT_PROFILE_VALUE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.override_allowed := 0;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Delete_Value__ (
   profile_id_ IN VARCHAR2,
   profile_section_ IN VARCHAR2,
   profile_entry_ IN VARCHAR2 )
IS
BEGIN
   DELETE
      FROM  FNDRR_CLIENT_PROFILE_VALUE_TAB
      WHERE profile_id = profile_id_
      AND   profile_section = profile_section_
      AND   profile_entry = profile_entry_;
END Delete_Value__;


@UncheckedAccess
PROCEDURE Set_Value__ (
   profile_id_      IN VARCHAR2,
   profile_section_ IN VARCHAR2,
   profile_entry_   IN VARCHAR2,
   profile_value_   IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   newrec_     FNDRR_CLIENT_PROFILE_VALUE_TAB%ROWTYPE;
   oldrec_     FNDRR_CLIENT_PROFILE_VALUE_TAB%ROWTYPE;
   attr_       VARCHAR2(1000);
BEGIN
   IF Check_Exist___(profile_id_, profile_section_, profile_entry_) THEN
      oldrec_ := Get_Object_By_Keys___ (profile_id_, profile_section_, profile_entry_);
      newrec_ := oldrec_;
      newrec_.profile_value := profile_value_;
      Update___(NULL, oldrec_, newrec_, attr_, objversion_, TRUE);
   ELSE
      newrec_.profile_id      := profile_id_;
      newrec_.profile_section := profile_section_;
      newrec_.profile_entry   := profile_entry_;
      newrec_.profile_value   := profile_value_;
      Insert___ (objid_, objversion_, newrec_, attr_);
   END IF;
END Set_Value__;


PROCEDURE Set_Binary_Value__ (
   profile_id_             IN VARCHAR2,
   profile_section_        IN VARCHAR2,
   profile_entry_          IN VARCHAR2,
   profile_binary_value_   IN CLOB )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   newrec_     FNDRR_CLIENT_PROFILE_VALUE_TAB%ROWTYPE;
   oldrec_     FNDRR_CLIENT_PROFILE_VALUE_TAB%ROWTYPE;
   attr_       VARCHAR2(1000);
BEGIN
   oldrec_ := Get_Object_By_Keys___ (profile_id_, profile_section_, profile_entry_);
   IF (oldrec_.profile_id IS NOT NULL) THEN
      newrec_ := oldrec_;
      newrec_.profile_binary_value := profile_binary_value_;
      Update___(NULL, oldrec_, newrec_, attr_, objversion_, TRUE);
   ELSE
      newrec_.profile_id      := profile_id_;
      newrec_.profile_section := profile_section_;
      newrec_.profile_entry   := profile_entry_;
      newrec_.profile_binary_value := profile_binary_value_;
      newrec_.modified_date := sysdate;
      Insert___ (objid_, objversion_, newrec_, attr_);
   END IF;
END Set_Binary_Value__;


PROCEDURE Delete_Section__ (
   profile_id_ IN VARCHAR2,
   profile_section_ IN VARCHAR2 )
IS
   profile_section_desc_ VARCHAR2(1000) := profile_section_ || '/%';
BEGIN
   DELETE
      FROM  FNDRR_CLIENT_PROFILE_VALUE_TAB
      WHERE profile_id = profile_id_
      AND  ( profile_section = profile_section_ OR profile_section like profile_section_desc_ );
END Delete_Section__;


PROCEDURE Delete_All_Values__ (
   profile_id_ IN VARCHAR2 )
IS
BEGIN
   DELETE
      FROM  FNDRR_CLIENT_PROFILE_VALUE_TAB
      WHERE profile_id = profile_id_;
END Delete_All_Values__;


FUNCTION Get_Binary_Value_By_Id__ (
   objid_ IN VARCHAR2 ) RETURN CLOB
IS
   fndrr_client_profile_value_rec_ fndrr_client_profile_value_tab%ROWTYPE;
BEGIN
   fndrr_client_profile_value_rec_ := Get_Object_By_Id___(objid_);
   RETURN  fndrr_client_profile_value_rec_.profile_binary_value;
END Get_Binary_Value_By_Id__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


