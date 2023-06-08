-----------------------------------------------------------------------------
--
--  Logical unit: ReportUserSettings
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970815  MANY  Created
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  990327  ERFO  Fixed life time setting bug in method Get_Life (Bug #3069).
--  020624  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  050216  Bamalk Added validation for negative life in Unpack_Check_Insert___ (Bug#48656).
--  090911  Chaalk Updated Get_Life_Recursive method to remove the appowner report lifetime default check (Bug #85643)
--  110911  NaBaLK Changed type of reference from ReportUserSettings to ReportDefinition to CASCADE (RDTERUNTIME-407)
--  130905  MABALK QA Script Cleanup - PrivateInterfaces (Bug #112227
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     report_user_settings_tab%ROWTYPE,
   newrec_ IN OUT report_user_settings_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.life < 0) THEN
       Error_SYS.Appl_General(lu_name_, 'LIFENEGERR: Life attribute must be positive' );
    END IF;
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Life (
   identity_  IN VARCHAR2,
   report_id_ IN VARCHAR2,
   life_      IN NUMBER )
IS
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(32000);
   objversion_ VARCHAR2(32000);
   indrec_     Indicator_Rec;
   oldrec_     REPORT_USER_SETTINGS_TAB%ROWTYPE;
   newrec_     REPORT_USER_SETTINGS_TAB%ROWTYPE;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('LIFE', life_, attr_);
   IF (Check_Exist___(identity_,report_id_)) THEN
      oldrec_ := Lock_By_Keys___(identity_,report_id_);
      newrec_ := oldrec_;            
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);            
      Update___(objid_, oldrec_, newrec_, objversion_, attr_, TRUE);
   ELSE
      Client_SYS.Add_To_Attr('IDENTITY', identity_, attr_);
      Client_SYS.Add_To_Attr('REPORT_ID', report_id_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);   
      Insert___(objid_, objversion_, newrec_, attr_);      
   END IF;
END Set_Life;


@UncheckedAccess
PROCEDURE Get_Life_Recursive (
   life_      OUT NUMBER,
   identity_  IN  VARCHAR2,
   report_id_ IN  VARCHAR2 )
IS
BEGIN
   life_ := Get_Life_Recursive(identity_, report_id_);
END Get_Life_Recursive;


@UncheckedAccess
FUNCTION Get_Life_Recursive (
   identity_ IN VARCHAR2,
   report_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   life_ NUMBER;
BEGIN
   life_ := Get_Life(identity_, report_id_);
   IF (life_ IS NULL) THEN
         life_ := Report_Definition_API.Get_Life_Default(report_id_);
         IF (life_ IS NULL) THEN
            life_ := 0;
         END IF;
   END IF;
   RETURN (life_);
END Get_Life_Recursive;



