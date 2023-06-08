-----------------------------------------------------------------------------
--
--  Logical unit: ReplicationObject
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000621  ROOD    Set business_object uppercase in views.
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Create_Attribute_Group___ (
   newrec_     IN OUT REPLICATION_OBJECT_TAB%ROWTYPE )
IS
   attr_              VARCHAR2(2000);
   info_              VARCHAR2(2000);
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);
   already_installed  EXCEPTION;
   PRAGMA exception_init(already_installed, -20112);
   CURSOR attribute_groups (object_ VARCHAR2) IS
      SELECT a.lu_name AS lu_name_
      FROM   replication_attr_group_def_tab a
      WHERE  a.business_object = object_;
BEGIN
   FOR grp IN attribute_groups(newrec_.business_object) LOOP
      attr_ := NULL;
      Client_SYS.Add_To_Attr('REPLICATION_GROUP', newrec_.replication_group, attr_);
      Client_SYS.Add_To_Attr('BUSINESS_OBJECT', newrec_.business_object, attr_);
      Client_SYS.Add_To_Attr('LU_NAME', grp.lu_name_, attr_);
      Client_SYS.Add_To_Attr('ON_NEW', 'TRUE', attr_);
      Client_SYS.Add_To_Attr('ON_MODIFY', 'TRUE', attr_);
      BEGIN
         Replication_Attr_Group_API.New__(info_, objid_, objversion_, attr_, 'DO');
      EXCEPTION
         WHEN already_installed THEN
            NULL;
     END;
   END LOOP;
END Create_Attribute_Group___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ON_NEW', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('ON_MODIFY', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REPLICATION_OBJECT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Create_Attribute_Group___(newrec_);   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     REPLICATION_OBJECT_TAB%ROWTYPE,
   newrec_     IN OUT REPLICATION_OBJECT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Replication_Object_Def_API.Set_Last_Cfg_Time_(newrec_.business_object);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Is_Complete__ (
   replication_group_ IN VARCHAR2,
   business_object_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_      NUMBER;
   lu_missing_ EXCEPTION;
   CURSOR c_attribute_group (object_ replication_attr_group_def_tab.business_object%TYPE) IS
      SELECT lu_name
      FROM   replication_attr_group_def_tab
      WHERE  business_object = object_;
   CURSOR c_lu_exist (group_   replication_attr_group_tab.replication_group%TYPE,
                      object_  replication_attr_group_tab.business_object%TYPE,
                      lu_      replication_attr_group_tab.lu_name%TYPE) IS
   SELECT 1
   FROM   replication_attr_group_tab
   WHERE  replication_group = group_
   AND    business_object   = object_
   AND    lu_name           = lu_;
BEGIN
   FOR rec_lu IN c_attribute_group (business_object_) LOOP
      OPEN c_lu_exist (replication_group_, business_object_, rec_lu.lu_name);
      FETCH c_lu_exist INTO dummy_;
      IF (  c_lu_exist%NOTFOUND ) THEN
         RAISE lu_missing_;
      END IF;
      CLOSE c_lu_exist;
   END LOOP;
   RETURN 'TRUE';
EXCEPTION
   WHEN lu_missing_ THEN
      CLOSE c_lu_exist;
      RETURN 'FALSE';
   WHEN others THEN
      IF ( c_lu_exist%ISOPEN ) THEN
         CLOSE c_lu_exist;
      END IF;
      RETURN 'FALSE';
END Is_Complete__;


PROCEDURE Refresh__ (
   replication_group_ IN VARCHAR2,
   business_object_ IN VARCHAR2 )
IS
   newrec_     REPLICATION_OBJECT_TAB%ROWTYPE;
BEGIN
   newrec_.replication_group := replication_group_;
   newrec_.business_object := business_object_;
   Create_Attribute_Group___(newrec_);
END Refresh__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


