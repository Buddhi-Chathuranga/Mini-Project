-----------------------------------------------------------------------------
--
--  Logical unit: FuncAreaSecCache
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100316  DUWI    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE  UserId           IS TABLE OF FUNC_AREA_SEC_CACHE_TAB.user_id%TYPE INDEX BY BINARY_INTEGER;
TYPE  FunctionalAreaId IS TABLE OF FUNC_AREA_SEC_CACHE_TAB.functional_area_id%TYPE INDEX BY BINARY_INTEGER;
TYPE  ConflictAreaId   IS TABLE OF FUNC_AREA_SEC_CACHE_TAB.conflict_area_id%TYPE INDEX BY BINARY_INTEGER;
TYPE  SecurityObject   IS TABLE OF FUNC_AREA_SEC_CACHE_TAB.security_object%TYPE INDEX BY BINARY_INTEGER;
TYPE  ObjectType       IS TABLE OF FUNC_AREA_SEC_CACHE_TAB.object_type%TYPE INDEX BY BINARY_INTEGER;
TYPE  PermissionSet    IS TABLE OF FUNC_AREA_SEC_CACHE_TAB.permission_set%TYPE  INDEX BY BINARY_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Refresh_Cache
IS 
   user_ids_               UserId;
   functional_area_ids_    FunctionalAreaId;
   conflict_area_ids_      ConflictAreaId;
   security_objects_       SecurityObject;
   sec_object_types_       ObjectType;
   permission_sets_        PermissionSet;
   rowversion_    DATE;

   CURSOR get_data IS
      SELECT
         a1.USERID, 
         a1.FUNCTIONAL_AREA_ID, 
         a1.CONFLICT_AREA_ID, 
         a1.SEC_OBJECT, 
         a1.SEC_OBJECT_TYPE_DB, 
         a1.PERMISSION_SET
 FROM FUNC_AREA_CONFLICT_PERMISSIONS a1;

BEGIN

   -- Clear the cache tables first
   @ApproveDynamicStatement(2009-08-24,duwilk)
   EXECUTE IMMEDIATE 'TRUNCATE TABLE FUNC_AREA_SEC_CACHE_TAB';

   -- Insert Data to the cache table

   rowversion_ := sysdate;

   OPEN get_data;
   LOOP
      FETCH get_data BULK COLLECT INTO user_ids_, functional_area_ids_, conflict_area_ids_ ,security_objects_ , sec_object_types_, permission_sets_  LIMIT 1000;
      FORALL i_ IN 1..user_ids_.count          
      INSERT
         INTO FUNC_AREA_SEC_CACHE_TAB(
          user_id,
          functional_area_id,
          conflict_area_id,
          security_object,
          object_type,
          permission_set,
          rowversion)
         VALUES (
          user_ids_(i_),
          functional_area_ids_(i_),
          conflict_area_ids_(i_),
          security_objects_(i_),
          sec_object_types_(i_),
          permission_sets_(i_),
          rowversion_);
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
      EXIT WHEN get_data%NOTFOUND;
   END LOOP;
   CLOSE get_data;

END Refresh_Cache;



