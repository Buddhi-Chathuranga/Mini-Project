-----------------------------------------------------------------------------
--
--  Logical unit: BcLogInfo
--  Component:    BCRCO
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
-----------------------------------------------------------------------------
--  230501  Buddhi  Initial Mini Project Develop
-----------------------------------------------------------------------------


layer Cust;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
--(+)220615 SEBSA-BUDDHI MINIPROJECT(START)
@Override
PROCEDURE Prepare_Insert___ (
   attr_    IN OUT   VARCHAR2 )
IS 
BEGIN
   
   super(attr_);
   
   Client_SYS.Add_To_Attr('DATE_CREATED',    SYSDATE,                      attr_);
   Client_SYS.Add_To_Attr('REPORTED_BY',     Fnd_Session_API.Get_Fnd_User, attr_);
   Client_SYS.Add_To_Attr('ENTER_BY',        'Manual',                     attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT bc_log_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   temp_    NUMBER;
BEGIN
   
   temp_    :=    Info_Id_Sequence.NEXTVAL;
   newrec_.log_info_id := temp_;
   
   super(newrec_, indrec_, attr_);
   
END Check_Insert___;





-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU CUST NEW METHODS -------------------------------------
--Create log infor for given line and note
PROCEDURE Create_Log_Info__ (
   rec_        IN    bc_repair_line_tab%ROWTYPE,
   note_       IN    VARCHAR2)
IS
   newrec_     bc_log_info_tab%ROWTYPE;
BEGIN
      
   newrec_.rco_no       :=       rec_.rco_no;
   newrec_.rco_line     :=       rec_.repair_line_no;
   newrec_.part_number  :=       rec_.part_number;
   newrec_.date_created :=       sysdate;
   newrec_.notes        :=       note_;
   newrec_.reported_by  :=       Fnd_Session_API.Get_Fnd_User;
   newrec_.contract     :=       rec_.repair_site;
   newrec_.enter_by     :=       'Auto';
   
   Bc_Log_Info_API.New___(newrec_); 
END Create_Log_Info__;
--(+)220615 SEBSA-BUDDHI MINIPROJECT(FINSH)