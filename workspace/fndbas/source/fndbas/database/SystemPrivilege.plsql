-----------------------------------------------------------------------------
--
--  Logical unit: SystemPrivilege
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  121001  CHMU  Added Method Export__ and Register (Bug#105198)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Export__ (
   string_        OUT VARCHAR2,
   privilege_id_  IN  VARCHAR2 )
IS
   CURSOR get_priv IS
      SELECT s.description
      FROM system_privilege_tab s
      WHERE s.privilege_id = privilege_id_;
BEGIN
   string_ := 'BEGIN '|| chr(10);
   FOR rec IN get_priv LOOP
      string_ := string_ || '   System_Privilege_API.Register(''' || privilege_id_ || ''',''' || Assert_SYS.Encode_Single_Quote_String(rec.description) || ''');' ||  chr(10);
   END LOOP;
   string_ := string_ || 'END; '|| chr(10);
END Export__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Register (
   privilege_id_  IN VARCHAR2,
   description_   IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(4000);

BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
   IF Check_Exist___(privilege_id_) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, privilege_id_);
      Modify__(info_, objid_, objversion_, attr_, 'DO');
   ELSE 
      Client_SYS.Add_To_Attr('PRIVILEGE_ID', privilege_id_, attr_);
      New__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
END Register;



