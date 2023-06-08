-----------------------------------------------------------------------------
--
--  Logical unit: PartCopyModule
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201222  SBalLK  Issue SC2020R1-11830, Modified New_Or_Modify() method by removing attr_ functionality to optimize the performance.
--  100423  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  050104  KeFelk   Change the error msg and parameters in Check_Execution_Order_Exist___.
--  041211  JaBalk   Updated New_Or_Modify.
--  041210  SaRalk   Removed join view.
--  041206  KeFelk   Added Check_Execution_Order_Exist___.
--  041201  KanGlk   Added PART_COPY_MODULE_JOIN.
--  041129  SaRalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Execution_Order_Exist___
--   This method is used to check whether given execution order is already
--   used in existing records.
PROCEDURE Check_Execution_Order_Exist___ (
   module_          IN VARCHAR2,
   execution_order_ IN NUMBER ) 
IS
   module_used_ PART_COPY_MODULE.module%TYPE;

   CURSOR is_execution_order_exist IS
      SELECT module
        FROM part_copy_module_tab
       WHERE execution_order = execution_order_;
BEGIN
   OPEN is_execution_order_exist;
   FETCH is_execution_order_exist INTO module_used_;
   IF (is_execution_order_exist%FOUND) THEN
      CLOSE is_execution_order_exist;
      Error_SYS.Record_General(lu_name_, 
         'EXE_ORDER_USED: Execution order :P1 cannot be used for module :P2, it is already used for module :P3.', execution_order_, module_used_, module_ );
   END IF;
   CLOSE is_execution_order_exist;
END Check_Execution_Order_Exist___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT part_copy_module_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   Check_Execution_Order_Exist___(newrec_.module, newrec_.execution_order);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     part_copy_module_tab%ROWTYPE,
   newrec_ IN OUT part_copy_module_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);   
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   IF ( oldrec_.execution_order != newrec_.execution_order ) THEN
      Check_Execution_Order_Exist___(newrec_.module, newrec_.execution_order);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New_Or_Modify
--   This method is used to insert a new record or modify an existing record.
PROCEDURE New_Or_Modify (
   module_          IN VARCHAR2,
   copy_method_     IN VARCHAR2,
   execution_order_ IN NUMBER )
IS
   newrec_       part_copy_module_tab%ROWTYPE;
BEGIN
   IF (Check_Exist___( module_ )) THEN
      newrec_ := Lock_By_Keys___(module_);
      newrec_.copy_method     := copy_method_;
      newrec_.execution_order := execution_order_;
      Modify___(newrec_);
   ELSE
      newrec_.module          := module_;
      newrec_.copy_method     := copy_method_;
      newrec_.execution_order := execution_order_;
      New___(newrec_);
   END IF;
END New_Or_Modify;



