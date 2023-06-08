-----------------------------------------------------------------------------
--
--  Logical unit: PresObjectSecurity
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000218  ERFO  Added view PRES_OBJECT_SECURITY_BUILD.
--  000222  PeNi  Added sysdate to insert statement in new_pres_object_sec_build.
--  000225  ERFO  Changed server behavior for IID-simulated type definitions.
--  000225  PeNi  Changed view.
--  000225  PeNi  Modified Unpack_Check_Update__
--  000401  PeNi  Added sec_object_type_db to view.
--  000403  PeNi  Altered table.
--  000405  ERFO  Added view PRES_OBJECT_SECURITY_AVAIL.
--  000407  RoOd  Modified view PRES_OBJECT_SECURITY_AVAIL.
--  000411  PeNi  Modified view PRES_OBJECT_SECURITY_AVAIL.
--  000412  RoOd  Modified view PRES_OBJECT_SECURITY_AVAIL.
--  000413  RoOd  Modified view PRES_OBJECT_SECURITY_AVAIL.
--                Added view PRES_OBJECT_SECURITY_INST
--  000419  RoOd  Added column sec_object_method_type in view PRES_OBJECT_SECURITY_AVAIL.
--                Removed view PRES_OBJECT_SECURITY_INST.
--  000502  PeNi  Added logic for "Modified".
--  000504  PeNi  Made info_type public
--  000525  RoOd  Removed method restrictions on 'ENUMERATE', 'EXIST', 'EXIST_DB'
--                in view PRES_OBJECT_SECURITY_AVAIL.
--  000822  ROOD  Added case formatting for sec_object (Bug #17118).
--  010705  ROOD  Added hint /*+RULE*/ upon pres_object_security_avail (Bug#23114).
--  011031  ROOD  Added validation in Format_Sec_Object_Name__ to avoid methods with
--                locking problems (ToDo#4033).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030508  ROOD  Added call to Package_Will_Deadlock__ (ToDo#4259).
--  030527  ROOD  Added more validations in Format_Sec_Object_Name___ (Bug#36906).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  041020  ROOD  Added warning instead of raising error for methods in packages that will deadlock.
--  050630  HAAR  System privilege changes (F1PR843).
--  050630  HAAR  Removed RULE hint from Pres_Object_Security_Avail (F1PR480).
--  050705  HAAR  Changed Pres_Object_Security_Avail to use DBA_xxx instead of User_xxx (F1PR843).
--  050908  HAAR  Removed special handled methods from Pres_Object_Security_Avail (F1PR483).
--  051111  HAAR  Changed so that the following methods are treated as PRAGMA methods:
--                LOCK__, LANGUAGE_REFRESHED, INIT, FINITE_STATE_DECODE__, ENUMERATE_STATES__,
--                FINITE_STATE_EVENTS__, ENUMERATE_EVENTS__, 'ENUMERATE', 'EXIST', 'EXIST_DB' (F1PR483).
--  051208  JEHU  Added view Pres_Object_Dic_Security
--  061205  UTGULK Removed cascade delete in PRES_OBJECT_DIC_SECURITY and added NOCHECK.(Bug#62239).
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK Merged Rose Documentation.
--  -------------------------------------------------------------------------
--  121228  USRA  Added validation for INFO_TYPE (Bug#106173).
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

SUBTYPE table_rec IS pres_object_security_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('INFO_TYPE', 'Manual', attr_);
   Client_SYS.Add_To_Attr('FORCE_READ_ONLY_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('FORCE_READ_ONLY', Fnd_Boolean_API.Decode(Fnd_Boolean_API.DB_FALSE), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT pres_object_security_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(newrec_, indrec_, attr_);
   IF (Validate_SYS.Is_Changed(NULL, newrec_.info_type, indrec_.info_type)) THEN
      Validate_Info_Type___(newrec_.info_type);
   END IF;
END Check_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PRES_OBJECT_SECURITY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.sec_object := Format_Sec_Object_Name___(newrec_.sec_object, newrec_.sec_object_type);
   Client_SYS.Add_To_Attr('SEC_OBJECT', newrec_.sec_object, attr_);
   super(objid_, objversion_, newrec_, attr_);
   Pres_Object_API.Set_Change_Date(newrec_.po_id);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     PRES_OBJECT_SECURITY_TAB%ROWTYPE,
   newrec_     IN OUT PRES_OBJECT_SECURITY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.sec_object != oldrec_.sec_object) THEN
      newrec_.sec_object := Format_Sec_Object_Name___(newrec_.sec_object, newrec_.sec_object_type);
      Client_SYS.Add_To_Attr('SEC_OBJECT', newrec_.sec_object, attr_);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN PRES_OBJECT_SECURITY_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Pres_Object_API.Set_Change_Date(remrec_.po_id);
END Delete___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Format_Sec_Object_Name___
--    To format the name of the security object (eg. View or Method) to have
--    the same format concerning case that is used when inserting objects from
--    the Scan Tool.
--    Also validates the correctness of the sec_object and that the method does
--    not belong to packages that cause internal locking problems when granting.
FUNCTION Format_Sec_Object_Name___ (
   sec_object_name_    IN VARCHAR2,
   sec_object_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   package_name_ VARCHAR2(30);
   method_name_  VARCHAR2(30);
   view_name_    VARCHAR2(30);
   point_pos_    NUMBER;
   dummy_        NUMBER;

   CURSOR view_exist(view_name_ IN VARCHAR2) IS
       SELECT 1
       FROM user_views
       WHERE view_name = view_name_;

   CURSOR method_exist(package_name_ IN VARCHAR2, method_name_ IN VARCHAR2) IS
       SELECT 1
       FROM user_procedures
       WHERE object_name = upper(package_name_)
       AND   procedure_name  = upper(method_name_);
BEGIN
   IF sec_object_type_db_ = 'VIEW' THEN
      view_name_ := upper(sec_object_name_);
      OPEN view_exist(view_name_);
      FETCH view_exist INTO dummy_;
      IF view_exist%NOTFOUND THEN
         CLOSE view_exist;
         Client_SYS.Add_Info(lu_name_, 'VIEWNOTEXIST: The view :P1 does not exist in the database. It is included into the repository anyway, but you may encounter problems when granting or revoking!', view_name_);
      ELSE
         CLOSE view_exist;
      END IF;
      RETURN view_name_;
   ELSIF sec_object_type_db_ = 'METHOD' THEN
      -- Split the name into the different relevant parts.
      point_pos_ := instr(sec_object_name_, '.');
      package_name_ := substr(sec_object_name_, 1, point_pos_ - 1);
      method_name_  := substr(sec_object_name_, point_pos_ + 1);
      -- Perform the formatting on the different parts.
      package_name_ := upper(package_name_);
      -- Check for possible deadlock package
      IF Security_SYS.Package_Will_Deadlock__(package_name_) THEN
         Client_SYS.Add_Info(lu_name_, 'LOCKPROBLEMPACKAGE: The package :P1 can not be revoked by Security_SYS. Method :P2 is included into the repository anyway, but it will be ignored when revoking!', package_name_, package_name_||'.'||method_name_);
      END IF;
      -- Verify that the package exist in the database.
      method_name_  := replace(method_name_, '_', ' ');
      method_name_  := Initcap(method_name_);
      method_name_  := replace(method_name_, ' ', '_');
      IF package_name_ IS NOT NULL AND method_name_ IS NOT NULL THEN
         OPEN method_exist(package_name_, method_name_);
         FETCH method_exist INTO dummy_;
         IF method_exist%NOTFOUND THEN
            CLOSE method_exist;
            Client_SYS.Add_Info(lu_name_, 'METHODNOTEXIST: The method :P1 does not exist in the database. It is included into the repository anyway, but you may encounter problems when granting or revoking!', package_name_||'.'||method_name_);
         ELSE
            CLOSE method_exist;
         END IF;
         RETURN (package_name_||'.'||method_name_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'ONLYPKGNOTALLOWED: Only complete methods of the format <Package_Name>.<Method_Name> can be entered as method database objects!');
      END IF;
   ELSE
      -- No known formating, simply return.
      RETURN sec_object_name_;
   END IF;
END Format_Sec_Object_Name___;


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

PROCEDURE Create_Or_Replace (
   rec_  IN OUT table_rec )
IS
BEGIN
   IF Check_Exist___(rec_.po_id, rec_.sec_object) THEN
      Modify___(rec_);
   ELSE
      New___(rec_);
   END IF;
END Create_Or_Replace;
