-----------------------------------------------------------------------------
--
--  Logical unit: AnonymizationSetup
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171221  Piwrpl  Created, LCS 139441, GDPR implemented 
--  180411  Nikplk  FIUXX-12917, added Set_Default_Method
--  180509  Nikplk  FIUXXW2-251, Prepare_Insert___ method
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Default_Method___ (
   newrec_ IN OUT anonymization_setup_tab%ROWTYPE)
IS
   dummy_ NUMBER;
   CURSOR default_exist IS
      SELECT 1
      FROM   anonymization_setup_tab
      WHERE  default_method = 'TRUE'
      AND    method_id != newrec_.method_id;
BEGIN   

   OPEN default_exist;
   FETCH default_exist INTO dummy_;
   IF default_exist%FOUND THEN
      CLOSE default_exist;
      Error_SYS.Appl_General(lu_name_, 'ONLYONEDEFAULT: Only one method can be set as Default Method.');
   END IF;
   CLOSE default_exist;
   
END Validate_Default_Method___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     anonymization_setup_tab%ROWTYPE,
   newrec_ IN OUT anonymization_setup_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN 
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.default_method = 'TRUE') AND (indrec_.default_method = TRUE)THEN
      Validate_Default_Method___(newrec_);
   END IF;     
END Check_Common___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DEFAULT_METHOD_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('TEXT_ANONYMIZATION_MODE', Anonymization_Mode_Type_API.Decode(Anonymization_Mode_Type_API.DB_FIXED_VALUE), attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Default_Method
   RETURN Public_Rec   
IS
   temp_ Public_Rec;
BEGIN
   SELECT method_id,
         rowid, rowversion, rowkey,
         text_value, 
         text_anonymization_mode, 
         date_value, 
         number_value
     INTO  temp_
     FROM  anonymization_setup_tab
     WHERE default_method = 'TRUE';
  RETURN temp_;
EXCEPTION
  WHEN no_data_found THEN
     RETURN NULL;
END Get_Default_Method;

FUNCTION Get_Anonimization (
   method_id_ IN VARCHAR2) RETURN Public_Rec 
IS
BEGIN
   IF method_id_ IS NULL THEN
      RETURN Get_Default_Method();
   ELSE
      RETURN Get(method_id_);
   END IF;
END Get_Anonimization;

-- This method is to be used by Aurena
PROCEDURE Set_Default_Method (
   method_id_ IN VARCHAR2 )
IS
   oldrec_       anonymization_setup_tab%ROWTYPE;  
   newrec_       anonymization_setup_tab%ROWTYPE;
   temp_         Public_Rec;
BEGIN
   temp_ := Get_Default_Method;
   IF (temp_.method_id IS NOT NULL) THEN
      oldrec_ := Lock_By_Keys___(temp_.method_id);
      oldrec_.default_method  := 'FALSE';
      Modify___(oldrec_);
   END IF; 
   newrec_ := Lock_By_Keys___(method_id_);
   newrec_.default_method  := 'TRUE';
   Modify___(newrec_);
END Set_Default_Method; 

-- This method is to be used by Aurena
PROCEDURE Reset_Default_Method (
   method_id_ IN VARCHAR2 )
IS
   oldrec_       anonymization_setup_tab%ROWTYPE;  
BEGIN
   IF (method_id_ IS NOT NULL) THEN
      oldrec_ := Lock_By_Keys___(method_id_);
      oldrec_.default_method  := 'FALSE';
      Modify___(oldrec_);
   END IF; 
END Reset_Default_Method; 