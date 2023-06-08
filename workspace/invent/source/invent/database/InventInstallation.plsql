-----------------------------------------------------------------------------
--
--  Logical unit: InventInstallation
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201009  OsAllk  SC2020R1-10455, Replaced Database_SYS.Component_Exist with Component_Active to check component ACTIVE/INACTIVE.
--  190730  TiRalk  SCUXXW4-23069, Added code to check if the componenet is included in the delivery before  executing the Post Intallation Data sections.
--  160120  ChJalk  Bug 125845, Added Reg_Obj_Con_Lu_Transform___ and modifed Post_Installation_Data to support registering of LU 
--  160120          connection transformations of dynamic components.
--  140325  UdGnlk  PBSC-8043, Added Post_Installation_Data() and Insert_Post_Ctrl_Comb___()
--  140325          to support posting control insertions of dynamic components.
--  140325  UdGnlk  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Insert_Post_Ctrl_Comb___
IS      
BEGIN
   -- postings for COST components
   IF Installation_SYS.Get_Installation_Mode = FALSE OR Module_API.Is_Included_In_Delivery('INVENT') OR Module_API.Is_Included_In_Delivery('COST') THEN
      IF (Database_SYS.Component_Active('COST')) THEN
         Posting_Ctrl_API.Insert_Allowed_Comb('M1', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M2', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M3', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M4', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M5', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M6', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M7', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M8', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M9', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M51', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M52', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M53', 'C91', 'COST', '*');      
         Posting_Ctrl_API.Insert_Allowed_Comb('M60', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M88', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M156', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M157', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M181', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M182', 'C91', 'COST', '*');
         Posting_Ctrl_API.Insert_Allowed_Comb('M184', 'C91', 'COST', '*');
      END IF;
   END IF;
END Insert_Post_Ctrl_Comb___;

PROCEDURE Reg_Obj_Con_Lu_Transform___
IS      
BEGIN
   IF Installation_SYS.Get_Installation_Mode = FALSE OR Module_API.Is_Included_In_Delivery('INVENT') OR Module_API.Is_Included_In_Delivery('PDMCON') THEN
      $IF Component_Pdmcon_SYS.INSTALLED $THEN
         Obj_Connect_Lu_Transform_API.Register('InventoryPart',        'EngPartRevision', 'DocReferenceObject', 'TARGET', 'INVENTORY_PART_API.TRANSF_INVENT_PART_TO_ENG_REV');
         Obj_Connect_Lu_Transform_API.Register('InventoryPartInStock', 'EngPartRevision', 'DocReferenceObject', 'TARGET', 'INVENTORY_PART_IN_STOCK_API.TRANS_INV_PART_STK_TO_ENG_REV');
      $ELSE
         NULL;   
      $END
   END IF;
   IF Installation_SYS.Get_Installation_Mode = FALSE OR Module_API.Is_Included_In_Delivery('INVENT') OR Module_API.Is_Included_In_Delivery('MFGSTD') THEN
      $IF Component_Mfgstd_SYS.INSTALLED $THEN 
         Obj_Connect_Lu_Transform_API.Register('InventoryPartInStock', 'PartRevision',    'DocReferenceObject', 'TARGET', 'CONTRACT,ENG_CHG_LEVEL,PART_NO');
      $ELSE
         NULL;   
      $END
   END IF;
END Reg_Obj_Con_Lu_Transform___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Post_Installation_Data
IS
BEGIN
   -- Create all posting control enties for dynamic modules.
   Insert_Post_Ctrl_Comb___();   
   -- Register Object LU Connection Transformation for dynamic modules.
   Reg_Obj_Con_Lu_Transform___();   
END Post_Installation_Data;
