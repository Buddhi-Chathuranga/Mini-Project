-----------------------------------------------------------------------------
--
--  Logical unit: Lock
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Is_Locked___ (
   lock_name_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_              VARCHAR2(5) := 'FALSE'; 
-- necessary grant to ifsapp: grant select on dba_lock, dbms_lock_allocated to ifsapp;
   CURSOR get_lock IS
   SELECT 'TRUE'
   FROM v$lock l, sys.dbms_lock_allocated a
   WHERE l.id1 = a.lockid
   AND a.name = lock_name_;
BEGIN
   OPEN  get_lock;
   FETCH get_lock INTO value_;
   CLOSE get_lock;
   RETURN(value_);
END Is_Locked___;

FUNCTION Is_Locked2___ (
   lock_name_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   lock_handle_         VARCHAR2(100);
BEGIN
   lock_handle_ := Lock_Object___(lock_name_);
   RETURN('TRUE');
EXCEPTION
   WHEN OTHERS THEN
      RETURN('FALSE');
END Is_Locked2___;

FUNCTION Lock_Object___(
   lock_name_           IN VARCHAR2,
   release_on_commit_   IN BOOLEAN DEFAULT FALSE) RETURN VARCHAR2 
IS
   lock_handle_            VARCHAR2(100);
   lock_id_                NUMBER;
   --
   object_locked    EXCEPTION;
BEGIN
   Dbms_Lock.Allocate_Unique_Autonomous(lock_name_, lock_handle_);
   lock_id_ := Dbms_Lock.Request(lock_handle_, timeout => 0, release_on_commit => release_on_commit_);
   CASE lock_id_ 
      WHEN 0 THEN
         NULL;
      WHEN 1 THEN
         RAISE object_locked;
      WHEN 2 THEN
         RAISE object_locked;
      WHEN 3 THEN
         RAISE object_locked;
      WHEN 4 THEN 
         NULL;
      WHEN 5 THEN
         RAISE object_locked;
      ELSE
         RAISE object_locked;
   END CASE;
   RETURN(lock_handle_);
EXCEPTION
   WHEN object_locked THEN
      Error_SYS.Appl_General(service_, 'LOCK_OBJECT: The object ":P1" is already locked by another session.', lock_name_);
END Lock_Object___;

PROCEDURE Unlock_Object___ (
   lock_name_        IN VARCHAR2 )
IS
   lock_handle_      VARCHAR2(100);
   lock_id_          NUMBER;
   object_locked     EXCEPTION;
BEGIN
   Dbms_Lock.Allocate_Unique_Autonomous(lock_name_, lock_handle_);
   lock_id_ := Dbms_Lock.Release(lock_handle_);
   CASE lock_id_ 
      WHEN 0 THEN
         NULL;
      WHEN 3 THEN
         RAISE object_locked;
      WHEN 4 THEN 
         RAISE object_locked;
      WHEN 5 THEN
         RAISE object_locked;
      ELSE
         RAISE object_locked;
   END CASE;
EXCEPTION
   WHEN object_locked THEN
      Error_SYS.Appl_General(service_, 'LOCK_OBJECT: The object ":P1" is already locked by another session.', lock_name_);
END Unlock_Object___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Lock_Object (
   lock_name_              IN VARCHAR2,
   release_on_transaction_ IN BOOLEAN DEFAULT FALSE )
IS
   lock_handle_   VARCHAR2(100);
BEGIN
   General_SYS.Check_Security(service_, 'LOCK_SYS', 'Lock_Object', TRUE);
   lock_handle_ := Lock_Object___(lock_name_, release_on_transaction_);
END Lock_Object;

PROCEDURE Unlock_Object (
   lock_name_  IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'LOCK_SYS', 'Unlock_Object', TRUE);
   Unlock_Object___(lock_name_);
END Unlock_Object;

@UncheckedAccess
FUNCTION Is_Locked (
   lock_name_        IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Is_Locked___(lock_name_));
END Is_Locked;

@UncheckedAccess
FUNCTION Is_Locked2 (
   lock_name_        IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Is_Locked2___(lock_name_));
END Is_Locked2;
