-----------------------------------------------------------------------------
--
--  Logical unit: ClientProfileValue
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191028  ratslk  TSMI-65/66: Profiles
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
   newrec_.modified_date := SYSDATE;
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
   newrec_.modified_date := SYSDATE;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Set_Value__ (
   profile_id_      IN VARCHAR2,
   profile_section_ IN VARCHAR2,
   profile_entry_   IN VARCHAR2,
   profile_value_   IN VARCHAR2,
   lob_loc_         IN CLOB,
   lob_value_type_  IN VARCHAR2 )
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
      newrec_.profile_binary_value := lob_loc_;
      newrec_.binary_value_type := lob_value_type_;
      
      Update___(NULL, oldrec_, newrec_, attr_, objversion_, TRUE);
   ELSE
      newrec_.profile_id      := profile_id_;
      newrec_.profile_section := profile_section_;
      newrec_.profile_entry   := profile_entry_;
      newrec_.profile_value   := profile_value_;
      newrec_.profile_binary_value := lob_loc_;
      newrec_.binary_value_type := lob_value_type_;

      Insert___ (objid_, objversion_, newrec_, attr_);   
   END IF;
END Set_Value__;


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


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Import(
   xml_                IN  XMLTYPE)
IS
   public_rec_             Public_Rec;
   import_rec_             fndrr_client_profile_value_tab%ROWTYPE;
   
   CURSOR get_profile_value(xml_ IN Xmltype) IS
    SELECT xt.*
     FROM dual,
          XMLTABLE('/VALUES/CLIENT_PROFILE_VALUE'
                     PASSING xml_
                     COLUMNS 
                       PROFILE_ID           VARCHAR2(100)   PATH 'PROFILE_ID',
                       PROFILE_SECTION      VARCHAR2(1000)  PATH 'PROFILE_SECTION ',
                       PROFILE_ENTRY        VARCHAR2(200)   PATH 'PROFILE_ENTRY',
                       PROFILE_VALUE        VARCHAR2(4000)  PATH 'PROFILE_VALUE',
                       CATEGORY             VARCHAR2(200)   PATH 'CATEGORY',
                       OVERRIDE_ALLOWED     NUMBER          PATH 'OVERRIDE_ALLOWED', 
                       MODIFIED_DATE        DATE            PATH 'MODIFIED_DATE'
                    ) xt;
BEGIN 
   FOR rec_ IN get_profile_value(xml_) LOOP
      import_rec_ := NULL;
      IF Check_Exist___(rec_.PROFILE_ID, rec_.PROFILE_SECTION, rec_.PROFILE_ENTRY) THEN
         public_rec_                   := Get(rec_.PROFILE_ID, rec_.PROFILE_SECTION, rec_.PROFILE_ENTRY);
         import_rec_.rowversion        := public_rec_.rowversion;
         import_rec_.profile_id        := public_rec_.profile_id;
         import_rec_.profile_section   := public_rec_.profile_section;
         import_rec_.profile_entry     := public_rec_.profile_entry;
         import_rec_.profile_value     := rec_.PROFILE_VALUE;
         import_rec_.override_allowed  := rec_.OVERRIDE_ALLOWED;
         import_rec_.modified_date     := rec_.MODIFIED_DATE;
         Modify___(import_rec_);
      ELSE
         import_rec_.profile_id        := rec_.PROFILE_ID;
         import_rec_.profile_section   := rec_.PROFILE_SECTION;
         import_rec_.profile_entry     := rec_.PROFILE_ENTRY;
         import_rec_.profile_value     := rec_.PROFILE_VALUE;
         import_rec_.override_allowed  := rec_.OVERRIDE_ALLOWED;
         import_rec_.modified_date     := rec_.MODIFIED_DATE;
         New___(import_rec_);
      END IF;   
   END LOOP;
END Import;

PROCEDURE Import_Values(
    rec_                IN         fndrr_client_profile_value_tab%ROWTYPE)
IS  
   newrec_                          fndrr_client_profile_value_tab%ROWTYPE;
BEGIN 
   newrec_.profile_id        := rec_.profile_id;
   newrec_.profile_section   := rec_.profile_section;
   newrec_.profile_entry     := rec_.profile_entry;
   newrec_.profile_value     := rec_.profile_value;
   newrec_.override_allowed  := rec_.override_allowed;
   newrec_.modified_date     := rec_.modified_date;
   newrec_.category          := rec_.category;
   newrec_.rowversion     := Get(newrec_.profile_id, newrec_.profile_section, newrec_.profile_entry).rowversion;
   IF Check_Exist___(rec_.profile_id, rec_.profile_section, rec_.profile_entry) THEN
      Modify___(newrec_);
   ELSE
      New___(newrec_);
   END IF;   
END Import_Values;
