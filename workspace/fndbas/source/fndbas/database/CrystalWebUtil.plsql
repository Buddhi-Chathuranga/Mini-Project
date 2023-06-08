-----------------------------------------------------------------------------
--
--  Logical unit: CrystalWebUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  111006  UTGULK  Created to include CrWebInit stored procedure.(Bug#60734)
--  160309  SUBSLK  Used Get_Lang_Code_Rfc3066() to get the language values like 'en-US' instead of 'en'. (Bug#81295)
--  090810  NABALK  Certified the assert safe for dynamic SQLs in Cr_Web_Init (Bug#84218)
--  110316  ChMuLK  Modified Cr_Web_Init to resolve issue with the security check (Bug#96254
--  180517  CHAALK  Patch Merge Bug#135899
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

CURSOR Cr_Web_Dummy_Rec IS
SELECT '40000101000000' Objversion FROM dual;                            
TYPE Dual_Cur IS REF CURSOR RETURN Cr_Web_Dummy_Rec%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Cr_Web_Init (
   ifs_dual_rec_ IN OUT Dual_Cur,
   ifs_web_user_ IN VARCHAR2 )
IS
   fnd_user_ VARCHAR2(30);
   lang_     VARCHAR2(30);

BEGIN
   -- Initialize the FndSession first
   IF (ifs_web_user_ IS NOT NULL) AND (ifs_web_user_ <> '*') THEN
      lang_ := nvl(Fnd_User_API.Get_Recursive_Property_(upper(ifs_web_user_), 'PREFERRED_LANGUAGE'), Fnd_Setting_API.Get_Value('DEFAULT_LANGUAGE'));
      fnd_user_ := Login_SYS.Init_Fnd_Session_(ifs_web_user_, Language_Code_API.Get_Lang_Code_Rfc3066(lang_), 'FALSE');
   END IF;
   -- check method security after
   General_SYS.Check_Security(lu_name_, 'Crystal_Web_Util_API', 'Cr_Web_Init');
   -- Safe due to not using non-literals
   @ApproveDynamicStatement(2009-08-10,nabalk)
   OPEN ifs_dual_rec_ FOR SELECT '40000101000000' Objversion FROM dual;
END Cr_Web_Init;



