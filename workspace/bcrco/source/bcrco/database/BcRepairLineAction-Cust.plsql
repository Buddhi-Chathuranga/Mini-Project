-----------------------------------------------------------------------------
--
--  Logical unit: BcRepairLineAction
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


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
--(+)220615 SEBSA-BUDDHI MINIPROJECT(START)
@Override
PROCEDURE Prepare_Insert___ (
   attr_    IN OUT   VARCHAR2 )
IS
   user_id_     VARCHAR2(300);
   site_        VARCHAR2(5);
BEGIN
   
   user_id_ :=    Fnd_Session_API.Get_Fnd_User;
   site_    :=    User_Allowed_Site_API.Get_Default_Site(user_id_);

   super(attr_);

   Client_SYS.Add_To_Attr('CONTRACT',  site_,  attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN        bc_repair_line_action_tab%ROWTYPE,
   newrec_ IN OUT    bc_repair_line_action_tab%ROWTYPE,
   indrec_ IN OUT    Indicator_Rec,
   attr_   IN OUT    VARCHAR2 )
IS
   count_ NUMBER     :=    0;
BEGIN
   
   count_   :=  Check_Repair_Line_Count__(oldrec_);
   IF(count_ = 1) THEN
      Error_SYS.Appl_General(lu_name_, 'Can not Update !');
   ELSE
      
      super(oldrec_, newrec_, indrec_, attr_);
      
   END IF;
END Check_Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN bc_repair_line_action_tab%ROWTYPE )
IS
   count_   NUMBER   := 0;
BEGIN
   
   count_   :=    Check_Repair_Line_Count__(remrec_);
   
   IF(count_ = 1) THEN
      Error_SYS.Appl_General(lu_name_, 'Can not Delete !');
   ELSE
      
      super(remrec_);

   END IF;
END Check_Delete___;



-------------------- LU CUST NEW METHODS -------------------------------------
--Return 1 if line count is more than 0 and else(line count is 0 ) return 0 by the given repair line action which used in the repair line
FUNCTION Check_Repair_Line_Count__(
   val_ IN bc_repair_line_action_tab%ROWTYPE) RETURN NUMBER
IS
   CURSOR      line_action_count IS
      SELECT   * 
      FROM     bc_repair_line_tab r
      WHERE    r.repair_line_action = val_.repair_line_action;
   count_ NUMBER :=0;
BEGIN
   
   FOR data_ IN line_action_count LOOP
      count_   :=    count_ + 1;
   END LOOP;
   
   IF (count_>0) THEN
      count_   :=    1;
   ELSE
      count_   :=    0;
   END IF;
   
   RETURN count_; 
END Check_Repair_Line_Count__;
--(+)220615 SEBSA-BUDDHI MINIPROJECT(FINSH)