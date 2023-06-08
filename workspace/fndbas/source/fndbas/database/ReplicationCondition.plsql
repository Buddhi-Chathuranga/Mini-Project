-----------------------------------------------------------------------------
--
--  Logical unit: ReplicationCondition
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REPLICATION_CONDITION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Replication_Object_Def_API.Set_Last_Cfg_Time_(newrec_.business_object);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     REPLICATION_CONDITION_TAB%ROWTYPE,
   newrec_     IN OUT REPLICATION_CONDITION_TAB%ROWTYPE,
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


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT replication_condition_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   value_found_ NUMBER;
   CURSOR c1_lu_name (group_  VARCHAR2,
                      object_ VARCHAR2,
                      lu_     VARCHAR2) IS
      SELECT 1
      FROM   fndrpl_ro_lu_names a
      WHERE  a.replication_group = group_
      AND    a.business_object   = object_
      AND    a.lu_name           = lu_;
   CURSOR c1_column_name (object_ VARCHAR2,
                          lu_     VARCHAR2,
                          column_ VARCHAR2)IS
      SELECT 1
      FROM   fndrpl_rg_column_name a
      WHERE  a.business_object   = object_
      AND    a.lu_name           = lu_
      AND    a.column_name       = column_;
BEGIN
   super(newrec_, indrec_, attr_);
   IF ( newrec_.lu_name = '*' ) THEN
      NULL;
   ELSE
      value_found_ := 0;
      OPEN c1_lu_name (newrec_.replication_group, newrec_.business_object, newrec_.lu_name);
      FETCH c1_lu_name INTO value_found_;
      CLOSE c1_lu_name;
      IF ( value_found_ = 0 ) THEN
         Error_SYS.Record_Not_Exist(newrec_.lu_name);
      END IF;
   END IF;
   value_found_ := 0;
   OPEN c1_column_name (newrec_.business_object, newrec_.lu_name, newrec_.column_name);
   FETCH c1_column_name INTO value_found_;
   CLOSE c1_column_name;
   IF ( value_found_ = 0 ) THEN
      Error_SYS.Record_Not_Exist(newrec_.column_name);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


