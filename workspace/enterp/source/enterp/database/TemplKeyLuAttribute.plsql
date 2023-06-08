-----------------------------------------------------------------------------
--
--  Logical unit: TemplKeyLuAttribute
--  Component:    ENTERP
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

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Prog__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   text_          IN VARCHAR2 )
IS
   newrec_        key_lu_attribute_tab%ROWTYPE;
   oldrec_        key_lu_attribute_tab%ROWTYPE;
   attr_          VARCHAR2(2000);
   objid_         VARCHAR2(30);
   objversion_    VARCHAR2(2000);   
BEGIN   
   oldrec_ := Get_Object_By_Keys___('TemplKeyLu', key_value_, module_, lu_, attribute_key_);
   IF (oldrec_.key_name IS NOT NULL) THEN
      newrec_ := oldrec_;
      newrec_.attribute_text           := text_;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   ELSE
      newrec_.key_name                 := 'TemplKeyLu';
      newrec_.key_value                := key_value_;
      newrec_.module                   := module_;
      newrec_.lu                       := lu_;
      newrec_.attribute_key            := attribute_key_;
      newrec_.attribute_text           := text_;
      newrec_.first_reg_text           := text_;      
      Error_SYS.Check_Not_Null(lu_name_, 'KEY_NAME', newrec_.key_name);
      Error_SYS.Check_Not_Null(lu_name_, 'KEY_VALUE', newrec_.key_value);
      Error_SYS.Check_Not_Null(lu_name_, 'MODULE', newrec_.module);
      Error_SYS.Check_Not_Null(lu_name_, 'LU', newrec_.lu);
      Error_SYS.Check_Not_Null(lu_name_, 'ATTRIBUTE_KEY', newrec_.attribute_key);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;   
END Insert_Prog__;


PROCEDURE Remove_Attribute_Key__ (
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM key_lu_translation_tab
      WHERE key_name = 'TemplKeyLu'
      AND   key_value = key_value_
      AND   module = module_
      AND   lu = lu_
      AND   attribute_key = attribute_key_;   
   DELETE FROM key_lu_attribute_tab
      WHERE key_name = 'TemplKeyLu'
      AND   key_value = key_value_
      AND   module = module_
      AND   lu = lu_
      AND   attribute_key = attribute_key_;
   Key_Lu_Translation_API.Refresh_Translation_Imp__('TemplKeyLu', key_value_);        
END Remove_Attribute_Key__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
