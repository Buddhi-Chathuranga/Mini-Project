-----------------------------------------------------------------------------
--
--  Logical unit: TypeDesignationUtil
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960920  ADBR    Created from Rose model using Developer's Workbench.
--  961106  ADBR    Upgraded to 1.2.2.
--  961211  ADBR    Ref 37: Changed Create_Attr_Template to call New if not exist_control.
--  970402  CAJO    Adjusted to new templates in Foundation1 1.2.2C.
--  991022  ANCE    Call Id. 23122 Create_Attr_Template: Changed the cursor get_template and
--                  the the parameter newrec.type_ to type_ in attributstring to get TYPE.
--  000103  ANCE    Changed template due to performance improvement.
--  000524  RECASE  Deleted procedure Create_Attr_Template and Remove_Attr_Template__. Deleted calls to these 
--                  from Check_Type_Status and exchanged the call for TYPE_DESIGNATION_ATTR_API.Has_Technical_Data
--                  for Equipment_Object_API.Has_Technical_Spec_No
--  131122  Nekolk  PBSA-1829:Hooks: Refactored and split code.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_Type_Status (
   type_ IN VARCHAR2,
   new_mch_type_ IN VARCHAR2 )
IS
   key_ref_     VARCHAR2(200);
BEGIN
   -- If no change, no action
   IF (Type_Designation_API.Get_Mch_Type( type_ ) = new_mch_type_) THEN
      Null;
   ELSE
      -- Was changed, not allowed if has technical data
      key_ref_ := Client_SYS.Get_Key_Reference('TypeDesignation','TYPE','type_');
      IF EQUIPMENT_OBJECT_API.Has_Technical_Spec_No('TypeDesignation', key_ref_ ) = 'TRUE' THEN
         Error_SYS.Appl_General(lu_name_, 'HASTECHDATA: Type designation :P1 has technical data values! Type can''t be changed.', type_);
      END IF;
   END IF;   /* end else */
END Check_Type_Status;



