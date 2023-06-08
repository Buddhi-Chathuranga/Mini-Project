-----------------------------------------------------------------------------
--
--  Logical unit: FuncAreaConflictCache
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100316  DUWI    Created.
--  100422  DUWI    Corrected the cursor get_conflict_data in Refresh_Cache(Bug#90217)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE  UserId           IS TABLE OF FUNC_AREA_CONFLICT_CACHE_TAB.user_id%TYPE INDEX BY BINARY_INTEGER;
TYPE  FunctionalAreaId IS TABLE OF FUNC_AREA_CONFLICT_CACHE_TAB.functional_area_id%TYPE INDEX BY BINARY_INTEGER;
TYPE  ConflictType     IS TABLE OF FUNC_AREA_CONFLICT_CACHE_TAB.conflict_type%TYPE INDEX BY BINARY_INTEGER;
TYPE  ConflictAreaId   IS TABLE OF FUNC_AREA_CONFLICT_CACHE_TAB.conflict_area_id%TYPE INDEX BY BINARY_INTEGER;
TYPE  Description      IS TABLE OF FUNC_AREA_CONFLICT_CACHE_TAB.description%TYPE  INDEX BY BINARY_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Refresh_Cache
IS
  user_ids_               UserId;
  functional_area_ids_    FunctionalAreaId;
  conflict_types_         ConflictType;
  conflict_area_ids_      ConflictAreaId;
  descriptions_           Description;
  rowversion_             DATE;

  CURSOR get_conflict_data IS
     SELECT a1.USERID,
            a1.FUNCTIONAL_AREA_ID,
            a1.CONFLICT_TYPE_DB,
            a1.CONFLICT_AREA_ID,
            a2.DESCRIPTION
     FROM USER_AREA_ALL_PERMISSIONS a1, FND_USER a2
     WHERE (a1.USERID = a2.IDENTITY(+));
BEGIN
   

   -- Clear the cache tables first
   @ApproveDynamicStatement(2010-03-16,duwilk)
   EXECUTE IMMEDIATE 'TRUNCATE TABLE FUNC_AREA_CONFLICT_CACHE_TAB';

   rowversion_ := sysdate;

   OPEN get_conflict_data;
   LOOP
      FETCH get_conflict_data BULK COLLECT INTO user_ids_, functional_area_ids_, conflict_types_ ,conflict_area_ids_ , descriptions_ LIMIT 1000;
      FORALL i_ IN 1..user_ids_.count          
         INSERT
            INTO func_area_conflict_cache_tab (
              user_id,
              functional_area_id,
              conflict_type,
              conflict_area_id,
              description,
              rowversion)
         VALUES (
              user_ids_(i_),
              functional_area_ids_(i_),
              conflict_types_(i_),
              conflict_area_ids_(i_),
              descriptions_(i_),
              rowversion_);
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
      EXIT WHEN get_conflict_data%NOTFOUND;
   END LOOP;
   CLOSE get_conflict_data;

   -- Call the child method
   Func_Area_Sec_Cache_API.Refresh_Cache;


END Refresh_Cache;



