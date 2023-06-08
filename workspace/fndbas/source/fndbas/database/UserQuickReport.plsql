-----------------------------------------------------------------------------
--
--  Logical unit: UserQuickReport
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
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   quick_report_id_ VARCHAR2(20);
   owner_           VARCHAR2(30);
BEGIN
   quick_report_id_ := Client_SYS.Get_Item_Value('REPORT_ID', attr_);
   owner_ := Client_SYS.Get_Item_Value('OWNER', attr_);
   
   super(attr_);
   
   IF (owner_ IS NULL) THEN
      owner_ := Fnd_Session_API.Get_Fnd_User;
   END IF;
   Client_SYS.Add_To_Attr('OWNER', owner_, attr_);
      
   WHILE (quick_report_id_ IS NULL OR Check_Exist___(quick_report_id_)) LOOP
      SELECT 'U' || trunc(mod((extract(second from systimestamp)+extract(minute from systimestamp)*60)*1000, 1000000))
      INTO quick_report_id_
      FROM dual;
   END LOOP;
   Client_SYS.Add_To_Attr('REPORT_ID', quick_report_id_, attr_);
   
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

