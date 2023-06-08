-----------------------------------------------------------------------------
--
--  Logical unit: BatchJob
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  961113  MANY  Created.
--  961120  MANY  Fixed method Reactivate_Job, status ACTIVE not ACTIVATE.
--  961127  ERFO  Added STATUS_DB and changed STATUS in view definition.
--  970414  ERFO  Generated from IFS/Design for release 2.0.0.
--  970725  ERFO  Replaced usage of obsolete method Utility_SYS.Get_User
--                with the new Fnd_Session_API.Get_Fnd_User (ToDo #1172).
--  980728  ERFO  Review of English texts by US (ToDo #2497).
--  990920  ERFO  Rewrite of view definition for improved performance (ToDo #3580).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  050811  HAAR  Changed view Batch_Job to use System privileges (F1PR483).
--  090623  HAAR  Changed all public methods regarding Batch_Job to be protected.
--                These methods should only be used by component FNDBAS (IID#80009).
--  100127  HAAR  Changes needed for using Dbms_Scheduler instead of Dbms_Job (EACS-750).
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remove_Job (
   job_id_ IN NUMBER )
IS
BEGIN
   Batch_SYS.Remove_Job_(job_id_);
END Remove_Job;


PROCEDURE Reactivate_Job (
   job_id_ IN NUMBER )
IS
BEGIN
   Batch_SYS.Enable_Job_(job_id_);
END Reactivate_Job;


PROCEDURE Break_Job (
   job_id_ IN NUMBER )
IS
BEGIN
   Batch_SYS.Disable_Job_(job_id_);
END Break_Job;
