-----------------------------------------------------------------------------
--
--  Logical unit: PlanningNetwork
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  040304  NALWLK Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Update_Mrp_Run_Date (
   network_id_ IN VARCHAR2 )
IS
   info_           VARCHAR2(2000);
   objversion_     VARCHAR2(2000);
   objid_          VARCHAR2(50);
   attr_           VARCHAR2(1000);
BEGIN

   Get_Id_Version_By_Keys___ ( objid_, objversion_, network_id_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('MRP_RUN_DATE',SYSDATE, attr_);
   Modify__ (info_,objid_,objversion_,attr_,'DO');
END Update_Mrp_Run_Date;



