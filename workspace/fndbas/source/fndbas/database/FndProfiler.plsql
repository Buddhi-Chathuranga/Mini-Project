-----------------------------------------------------------------------------
--
--  Logical unit: FndProfiler
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN FND_PROFILER_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Assert_SYS.Assert_Is_Number(remrec_.runid);
   @ApproveDynamicStatement(2014-08-29,haarse)
   EXECUTE IMMEDIATE 'DELETE FROM dbmshp_runs WHERE runid = :runid_;' USING IN remrec_.runid;
   @ApproveDynamicStatement(2014-08-29,haarse)
   EXECUTE IMMEDIATE 'DELETE FROM dbmshp_function_info WHERE runid = :runid_;' USING IN remrec_.runid;
   @ApproveDynamicStatement(2014-08-29,haarse)
   EXECUTE IMMEDIATE 'DELETE FROM dbmshp_parent_child_info WHERE runid = :runid_;' USING IN remrec_.runid;
END Delete___;


PROCEDURE Check_Path___ (
   directory_  IN VARCHAR2,
   file_name_  IN VARCHAR2 )
IS
BEGIN 
   IF (directory_ IS NULL OR file_name_ IS NULL ) THEN 
      Error_SYS.Appl_General(lu_name_, 'PROFILER_DIR_FILE: Directory [:P1] or file name [:P2] does not have a value.', directory_, file_name_);
   END IF;   
END Check_Path___;


PROCEDURE Check_Allowed___
IS
   profiling_     VARCHAR2(3)    := Fnd_Setting_API.Get_Value('PROFILING');
   
   not_allowed EXCEPTION;
BEGIN
   IF (profiling_ = 'OFF') THEN
      RAISE not_allowed;
   END IF;
EXCEPTION
   WHEN not_allowed THEN
      Error_SYS.Record_General(lu_name_, 'PROFILING_NOT_ALLOWED: Profiling is not allowed on this installation.');
END Check_Allowed___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Create_Directory_ (
   name_    IN VARCHAR2,
   path_    IN VARCHAR2 )
IS
BEGIN
   Database_SYS.Create_Directory(name_, path_, TRUE, TRUE, TRUE);
END Create_Directory_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Start_Profiling (
   file_name_  IN VARCHAR2 DEFAULT NULL   ) RETURN VARCHAR2 
IS
   file_       VARCHAR2(200);
BEGIN
   -- Check if profiling is allowed on this installation
   Check_Allowed___;
   -- Create file name
   IF (file_name_ IS NULL) THEN
      file_ := sys_guid || '.trc';
   ELSE
      file_ := file_name_;
   END IF;
   -- Check so that directory and file has values
   Check_Path___(Fnd_Setting_API.Get_Value('PROFILING_DIR'), file_);
   -- Start profiling
   Dbms_Hprof.Start_Profiling(Fnd_Setting_API.Get_Value('PROFILING_DIR'), file_);
   --
   RETURN(file_);
END Start_Profiling;


FUNCTION Stop_Profiling (
   file_name_  IN VARCHAR2,
   comment_    IN VARCHAR2 DEFAULT NULL,
   statement_  IN VARCHAR2 DEFAULT NULL ) RETURN  NUMBER
IS
   PRAGMA      AUTONOMOUS_TRANSACTION;
   runid_      NUMBER;
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(1000);
   attr_       VARCHAR2(2000);
   newrec_     FND_PROFILER_TAB%ROWTYPE;
BEGIN
   -- Stop profiling
   Dbms_Hprof.Stop_Profiling;
   -- 
   -- Check so that directory and file has values
   --Check_Path___('FND_PROFILER_DIR', file_name_);
   -- Analyze the data
   runid_ := Dbms_Hprof.Analyze(Fnd_Setting_API.Get_Value('PROFILING_DIR'), file_name_, run_comment => comment_);
   -- Insert a row in FND_PROFILER_TAB
   newrec_.runid := runid_;
   newrec_.identity := Fnd_Session_API.Get_Fnd_User;
   newrec_.statement := statement_;
   Insert___(objid_, objversion_, newrec_, attr_);
   @ApproveTransactionStatement(2013-04-25,haarse)
   COMMIT;
   RETURN(runid_);
END Stop_Profiling;


