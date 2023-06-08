-----------------------------------------------------------------------------
--
--  Logical unit: CustomerInfoOurId
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990125  Camk    Created.
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  091203  Kanslk  Reverse Engineering, changed the company to a parent key.
--  131021  Isuklk  CAHOOK-2793 Refactoring in CustomerInfoOurId.entity
--  140703  Hawalk  Bug 116673 (merged via PRFI-287), User-company authorization added inside Check_Common___().
--  141121  MaIklk  PRSC-4358, Fixed to skip copying records if user-company is not allowed in copy_customer().
--  150813  Wahelk  BLU-1192,Modified Copy_Customer method to add new parameter copy_info_
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     customer_info_our_id_tab%ROWTYPE,
   newrec_ IN OUT customer_info_our_id_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.our_id IS NOT NULL) THEN
      Attribute_Definition_API.Check_Value(newrec_.our_id, lu_name_, 'OUR_ID');
   END IF;   
   -- Note: Validate that the user is one within the company.
   -- Note: No need for ELSE as application doesn't run without ACCRUL - only installation issue addressed here!
   $IF Component_Accrul_SYS.INSTALLED $THEN
      User_Finance_API.Exist_Current_User(newrec_.company);
   $END
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Copy_Customer (
   customer_id_ IN VARCHAR2,
   new_id_      IN VARCHAR2,
   copy_info_   IN Customer_Info_API.Copy_Param_Info)
IS   
   newrec_              customer_info_our_id_tab%ROWTYPE;
   oldrec_              customer_info_our_id_tab%ROWTYPE;
   user_company_exist_  BOOLEAN;
   CURSOR get_attr IS
      SELECT *
      FROM   customer_info_our_id_tab
      WHERE  customer_id = customer_id_;
BEGIN
   FOR rec_ IN get_attr LOOP
      oldrec_ := Lock_By_Keys___(customer_id_, rec_.company);   
      newrec_ := oldrec_ ;
      newrec_.customer_id := new_id_;
      $IF Component_Accrul_SYS.INSTALLED $THEN
         user_company_exist_ := User_Finance_API.Exists(newrec_.company, Fnd_Session_API.Get_Fnd_User);
      $END
      IF (user_company_exist_) THEN
         New___(newrec_);
      END IF;
   END LOOP;   
END Copy_Customer;



