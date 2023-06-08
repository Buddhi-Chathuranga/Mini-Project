-----------------------------------------------------------------------------
--
--  Logical unit: ReportColumnDefinition
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970817  MANY  Created
--  980527  MANY  Added column comments (ToDo #2453).
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  990806  ERFO  Performance improvements for report LOV-properties (ToDo #3462).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  060927  UTGULK Added method Remove_Column_ to be used by EXCEL reports.(Bug #60820).
--  080603  HAAR  Changed wrong comparison in where-clauses (Bug#71008).
--  081126  HASPLK Added method Get_Column_Dataformat.(Bug #77866)
--  120215  LAKRLK RDTERUNTIME-1846
--  130819  MABALK QA script cleanup - Call to General_SYS.Init_Method in procedure (Bug #111927)
--  130905  MABALK QA Script Cleanup - PrivateInterfaces (Bug #112227
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Remove_Column_ (
   report_id_   IN VARCHAR2,
   column_name_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   remrec_     REPORT_SYS_COLUMN_TAB%ROWTYPE;   
BEGIN
   Get_Id_Version_By_Keys___(objid_,objversion_,report_id_,column_name_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);   
END Remove_Column_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


