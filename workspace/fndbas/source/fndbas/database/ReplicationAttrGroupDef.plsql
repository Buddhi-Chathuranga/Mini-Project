-----------------------------------------------------------------------------
--
--  Logical unit: ReplicationAttrGroupDef
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000101  JhMa    Created.
--  000621  ROOD    Modified parameters in Check_Module___, Check_Unique___ and Is_Master___.
--                  Set business_object uppercase in view.
--  000628  ROOD    Changes in error handling.
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030408  ROOD    Modifications in the handling of the table name (Bug#36670).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Create_Attribute___ (
   newrec_     IN OUT REPLICATION_ATTR_GROUP_DEF_TAB%ROWTYPE,
   view_name_  IN VARCHAR2,
   type_       IN VARCHAR2 )
IS
   attr_              VARCHAR2(2000);
   info_              VARCHAR2(2000);
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);
   view_              VARCHAR2(30);
   key_list_          VARCHAR2(2000);
   now_               VARCHAR2(30) := TO_CHAR(sysdate, Client_SYS.Date_Format_);
   dummy_             VARCHAR2(2000);
   separator_         VARCHAR2(1) := Client_SYS.text_separator_;
   column_present_    EXCEPTION;
   PRAGMA EXCEPTION_INIT(column_present_, -20112);

   CURSOR get_columns (view_ VARCHAR2) IS
      SELECT a.column_name AS column_,
             a.column_id   AS column_id_
      FROM   user_tab_columns a
      WHERE  a.table_name = view_
      ORDER BY a.column_id;
BEGIN
   IF ( view_name_ IS NOT NULL ) THEN
      view_ := view_name_;
   ELSE
      view_ := Dictionary_SYS.ClientNameToDbName_(newrec_.lu_name);
   END IF;
   Dictionary_SYS.Get_Logical_Unit_Keys_(key_list_, dummy_, newrec_.lu_name);
   FOR col IN get_columns(view_) LOOP
      attr_ := NULL;
      Client_SYS.Add_To_Attr('BUSINESS_OBJECT', newrec_.business_object, attr_);
      Client_SYS.Add_To_Attr('LU_NAME', newrec_.lu_name, attr_);
      Client_SYS.Add_To_Attr('TABLE_NAME', newrec_.trigger_table, attr_);
      Client_SYS.Add_To_Attr('COLUMN_NAME', col.column_, attr_);
      Client_SYS.Add_To_Attr('SEQUENCE_NO', col.column_id_, attr_);
      IF ( INSTR(separator_ || key_list_, separator_ || col.column_ || separator_) > 0 ) THEN
         Client_SYS.Add_To_Attr('KEY', 'TRUE', attr_);
         Client_SYS.Add_To_Attr('ON_NEW', 'TRUE', attr_);
         Client_SYS.Add_To_Attr('ON_MODIFY', 'TRUE', attr_);
         IF ( (col.column_ != 'CONTRACT') AND (SUBSTR(col.column_,1,7) != 'COMPANY') ) THEN
            Client_SYS.Add_To_Attr('BO_KEY_NAME', col.column_, attr_);
         END IF;
      ELSE
         Client_SYS.Add_To_Attr('KEY', 'FALSE', attr_);
         IF ( SUBSTR(col.column_, LENGTH(col.column_) - 2) = '_DB' ) THEN
            Client_SYS.Add_To_Attr('ON_NEW', 'TRUE', attr_);
            Client_SYS.Add_To_Attr('ON_MODIFY', 'TRUE', attr_);
         ELSE
            IF ( Db_Column_Exist___(view_, col.column_) ) THEN
               Client_SYS.Add_To_Attr('ON_NEW', 'FALSE', attr_);
               Client_SYS.Add_To_Attr('ON_MODIFY', 'FALSE', attr_);
            ELSIF ( col.column_ IN ('OBJID','OBJVERSION') ) THEN
               Client_SYS.Add_To_Attr('ON_NEW', 'FALSE', attr_);
               Client_SYS.Add_To_Attr('ON_MODIFY', 'FALSE', attr_);
            ELSE
               Client_SYS.Add_To_Attr('ON_NEW', 'TRUE', attr_);
               Client_SYS.Add_To_Attr('ON_MODIFY', 'TRUE', attr_);
            END IF;
         END IF;
      END IF;
      IF ( NVL(type_,'X') = 'REFRESH' ) THEN
         Client_SYS.Add_To_Attr('DESCRIPTION', 'Added by refresh on ' || now_, attr_);
      END IF;
      BEGIN
         Replication_Attr_Def_API.New__(info_, objid_, objversion_, attr_, 'DO');
      EXCEPTION
         WHEN column_present_ THEN
            UPDATE replication_attr_def_tab p
               SET p.column_available = 'TRUE',
                   p.description      = 'Added by refresh on ' || now_
               WHERE  p.business_object = newrec_.business_object
                  AND p.lu_name = newrec_.lu_name
                  AND p.column_name = col.column_
                  AND p.column_available = 'FALSE';
         WHEN others THEN
            RAISE;
      END;
   END LOOP;
IF ( NVL(type_,'X') = 'REFRESH' ) THEN   
   UPDATE replication_attr_def_tab p
      SET p.key              = 'FALSE',
          p.on_new           = 'FALSE',
          p.on_modify        = 'FALSE',
          p.description      = 'Marked to be removed by refresh on ' || now_,
          p.column_available = 'FALSE'
      WHERE  p.business_object = newrec_.business_object
         AND p.lu_name = newrec_.lu_name
         AND p.column_name IN
         (     
            SELECT *
            FROM ( SELECT t.column_name
                   FROM  replication_attr_def_tab t
                   WHERE t.business_object = newrec_.business_object
                     AND t.lu_name = newrec_.lu_name
                   MINUS
                   SELECT a.column_name
                   FROM user_tab_columns a
                   WHERE a.table_name = view_name_)
         )
         AND (p.column_available = 'TRUE' OR p.column_available IS NULL);
END IF;
END Create_Attribute___;


FUNCTION Check_Unique___ (
   lu_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR unique_control IS
      SELECT 1
      FROM   REPLICATION_ATTR_GROUP_DEF_TAB
      WHERE  lu_name = lu_name_;
BEGIN
   OPEN unique_control;
   FETCH unique_control INTO dummy_;
   IF (unique_control%FOUND) THEN
      CLOSE unique_control;
      RETURN(TRUE);
   END IF;
   CLOSE unique_control;
   RETURN(FALSE);
END Check_Unique___;


PROCEDURE Check_Module___ (
   lu_name_          IN VARCHAR2,
   master_component_ IN VARCHAR2 )
IS
   --SOLSETFW
   CURSOR cModule (module_ VARCHAR2,
                   lu_     VARCHAR2) IS
      SELECT 1
      FROM   dictionary_sys_active a
      WHERE  a.lu_name = lu_
      AND    a.module  = module_;
   dummy_        NUMBER;
   module_error_ EXCEPTION;
BEGIN
   OPEN cModule(master_component_, lu_name_);
   FETCH cModule INTO dummy_;
   IF ( cModule%NOTFOUND ) THEN
      CLOSE cModule;
      RAISE module_error_;
   END IF;
   CLOSE cModule;
EXCEPTION
   WHEN module_error_ THEN
      Error_SYS.Record_general(lu_name_,'MISMATCH: The logical unit :P1 and the master component :P2 mismatch.', lu_name_, master_component_);
END Check_Module___;


FUNCTION Db_Column_Exist___ (
   view_    IN VARCHAR2,
   column_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_     NUMBER;
   return_    BOOLEAN;
   CURSOR db_column_exist (view_name_   VARCHAR2,
                           column_name_ VARCHAR2) IS
      SELECT 1
      FROM   user_tab_columns a
      WHERE  a.table_name = view_name_
      AND    a.column_name = column_name_ || '_DB';
BEGIN
   OPEN db_column_exist (view_, column_);
   FETCH db_column_exist INTO dummy_;
   IF ( db_column_exist%FOUND ) THEN
      return_ := TRUE;
   ELSE
      return_ := FALSE;
   END IF;
   CLOSE db_column_exist;
   RETURN return_;
EXCEPTION
   WHEN others THEN
      CLOSE db_column_exist;
      RETURN FALSE;
END Db_Column_Exist___;


FUNCTION Is_Master___ (
   business_object_ IN VARCHAR2,
   lu_name_         IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR cMaster (object_  replication_object_def_tab.business_object%TYPE,
                   lu_name_ replication_object_def_tab.master_lu%TYPE) IS
      SELECT 1
      FROM   replication_object_def_tab a
      WHERE  a.business_object = object_
      AND    a.master_lu       = lu_name_;
   dummy_     NUMBER;
   return_    BOOLEAN;
BEGIN
   OPEN cMaster(business_object_, lu_name_);
   FETCH cMaster INTO dummy_;
   IF ( cMaster%FOUND ) THEN
      return_ := TRUE;
   ELSE
      return_ := FALSE;
   END IF;
   CLOSE cMaster;
   RETURN return_;
END Is_Master___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REPLICATION_ATTR_GROUP_DEF_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Replication_Object_Def_API.Set_Last_Cfg_Time_(newrec_.business_object);
   Create_Attribute___(newrec_, NULL, NULL);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     REPLICATION_ATTR_GROUP_DEF_TAB%ROWTYPE,
   newrec_     IN OUT REPLICATION_ATTR_GROUP_DEF_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Replication_Object_Def_API.Set_Last_Cfg_Time_(newrec_.business_object);
   IF (newrec_.view_name != oldrec_.view_name) OR 
      (newrec_.trigger_table != oldrec_.trigger_table) THEN
      BEGIN
         DELETE FROM replication_attr_def_tab
         WHERE  business_object = oldrec_.business_object
         AND    lu_name         = oldrec_.lu_name;
      EXCEPTION
         WHEN others THEN NULL;
      END;
      Create_Attribute___(newrec_, newrec_.view_name, NULL);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN REPLICATION_ATTR_GROUP_DEF_TAB%ROWTYPE )
IS
BEGIN
   IF ( Is_Master___(remrec_.business_object, remrec_.lu_name) )  THEN
      Error_SYS.Record_general(lu_name_,'CANNOTREMOVEMASTER: A master logical unit can cannot be removed.');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT replication_attr_group_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   lu_duplicated_ EXCEPTION;
BEGIN
   super(newrec_, indrec_, attr_);
   IF ( Check_Unique___(newrec_.lu_name) ) THEN
      RAISE lu_duplicated_;
   END IF;
   IF ( newrec_.view_name IS NULL ) THEN
      newrec_.view_name :=  Dictionary_SYS.ClientNameToDbName_(newrec_.lu_name);
   END IF;
   -- Suggest the most likely table name
   IF ( newrec_.trigger_table IS NULL ) THEN
      newrec_.trigger_table :=  newrec_.view_name || '_TAB';
   END IF;
EXCEPTION
   WHEN lu_duplicated_ THEN
      Error_SYS.Record_general(lu_name_,'ONLYONEBUSINESSOBJ: A logical unit can only be part of one Business Object.');
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     replication_attr_group_def_tab%ROWTYPE,
   newrec_ IN OUT replication_attr_group_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'TRIGGER_TABLE', newrec_.trigger_table);
   Error_SYS.Check_Not_Null(lu_name_, 'VIEW_NAME', newrec_.view_name);
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     replication_attr_group_def_tab%ROWTYPE,
   newrec_ IN OUT replication_attr_group_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF ( newrec_.context = 'INSTANCE' ) THEN
      newrec_.context_key := NULL;
   ELSIF ( (newrec_.context = 'COMPANY') AND (newrec_.context_key IS NULL) ) THEN
      newrec_.context_key := 'COMPANY';
   ELSIF ( (newrec_.context = 'SITE') AND (newrec_.context_key IS NULL) ) THEN
      newrec_.context_key := 'CONTRACT';
   END IF;
   Check_Module___(newrec_.lu_name, newrec_.master_component);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Is_Complete__ (
   business_object_ IN VARCHAR2,
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   view_            VARCHAR2(30);
   dummy_           NUMBER;
   column_missing_  EXCEPTION;
   CURSOR c_view_name (object_  replication_attr_group_def_tab.business_object%TYPE,
                       lu_      replication_attr_group_def_tab.lu_name%TYPE) IS
      SELECT view_name
      FROM   replication_attr_group_def_tab
      WHERE  business_object = object_
      AND    lu_name         = lu_;
   CURSOR c_view_columns (view_name_ IN VARCHAR2) IS
      SELECT column_name
      FROM   user_tab_columns
      WHERE  table_name = view_name_;
   CURSOR c_column_exist (object_ replication_attr_def_tab.business_object%TYPE,
                          lu_     replication_attr_def_tab.lu_name%TYPE,
                          column_ replication_attr_def_tab.column_name%TYPE) IS
      SELECT 1
      FROM   replication_attr_def_tab
      WHERE  business_object = object_
      AND    lu_name         = lu_
      AND    column_name     = column_
      AND    (column_available ='TRUE' OR column_available IS NULL);
BEGIN
   OPEN c_view_name (business_object_, lu_name_);
   FETCH c_view_name INTO view_;
   CLOSE c_view_name;
   FOR rec_col IN c_view_columns (view_) LOOP
      OPEN c_column_exist (business_object_, lu_name_, rec_col.column_name);
      FETCH c_column_exist INTO dummy_;
      IF ( c_column_exist%NOTFOUND ) THEN
         RAISE column_missing_;
      END IF;
      CLOSE c_column_exist;
   END LOOP;
   
   BEGIN
      SELECT 1
         INTO dummy_
         FROM (SELECT t.column_name
               FROM replication_attr_def_tab t
               WHERE  t.business_object = business_object_
                  AND t.lu_name = lu_name_
               MINUS
               SELECT a.column_name
               FROM user_tab_columns a
               WHERE a.table_name = view_);
      RAISE column_missing_;
   EXCEPTION
      WHEN no_data_found THEN
         NULL;
      WHEN too_many_rows THEN
        RAISE column_missing_;   
   END;
   RETURN 'TRUE';
EXCEPTION
   WHEN column_missing_ THEN
      IF ( c_column_exist%ISOPEN ) THEN
         CLOSE c_column_exist;
      END IF;
      RETURN 'FALSE';
   WHEN others THEN
      IF ( c_view_name%ISOPEN ) THEN
         CLOSE c_view_name;
      END IF;
      IF ( c_column_exist%ISOPEN ) THEN
         CLOSE c_column_exist;
      END IF;
      RETURN 'FALSE';
END Is_Complete__;


@UncheckedAccess
PROCEDURE Refresh__ (
   business_object_ IN VARCHAR2,
   lu_name_ IN VARCHAR2 )
IS
   newrec_ REPLICATION_ATTR_GROUP_DEF_TAB%ROWTYPE;
   CURSOR c_view_name (object_  REPLICATION_ATTR_GROUP_DEF_TAB.business_object%TYPE,
                       lu_      REPLICATION_ATTR_GROUP_DEF_TAB.lu_name%TYPE) IS
      SELECT *
      FROM   REPLICATION_ATTR_GROUP_DEF_TAB
      WHERE  business_object = object_
      AND    lu_name         = lu_;
BEGIN
   OPEN c_view_name (business_object_, lu_name_);
   FETCH c_view_name INTO newrec_;
   CLOSE c_view_name;
   Create_Attribute___(newrec_, newrec_.view_name, 'REFRESH');
EXCEPTION
   WHEN others THEN
      IF ( c_view_name%ISOPEN ) THEN
         CLOSE c_view_name;
      END IF;
      RAISE;
END Refresh__;


PROCEDURE Check_Cascade_Delete__ (
   business_object_ IN VARCHAR2 )
IS
   key_     VARCHAR2(2000);
   CURSOR get_rec IS
      SELECT lu_name
      FROM REPLICATION_ATTR_GROUP_DEF_TAB
      WHERE business_object = business_object_;
BEGIN
   FOR rec_ IN get_rec
      LOOP
         key_ := business_object_ || '^' || rec_.lu_name || '^';
         Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
      END LOOP;
END Check_Cascade_Delete__;


PROCEDURE Do_Cascade_Delete__ (
   business_object_ IN VARCHAR2 )
IS
   remrec_     REPLICATION_ATTR_GROUP_DEF_TAB%ROWTYPE;
   objid_      REPLICATION_ATTR_GROUP_DEF.objid%TYPE;
   objversion_ REPLICATION_ATTR_GROUP_DEF.objversion%TYPE;
   CURSOR get_rec IS
      SELECT objid, objversion
      FROM REPLICATION_ATTR_GROUP_DEF
      WHERE business_object = business_object_;
BEGIN
   OPEN get_rec;
   FETCH get_rec INTO objid_, objversion_;
   WHILE get_rec%FOUND LOOP
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Delete___(objid_, remrec_);
      FETCH get_rec INTO objid_, objversion_;
   END LOOP;
   CLOSE get_rec;
END Do_Cascade_Delete__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


