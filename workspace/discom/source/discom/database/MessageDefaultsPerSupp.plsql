-----------------------------------------------------------------------------
--
--  Logical unit: MessageDefaultsPerSupp
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220120  Aabalk  SC21R2-7164, Moved common logic from Check_Insert___ and Check_Update___ into Check_Common___.
--  211209  Cpeilk  SC21R2-2566, Added column adhoc_pur_rqst_approval to check whether supp_auto_approval_user is correctly validated against new column values.
--  160623  DilMlk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___(
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DIR_DEL_APPROVAL_DB', Approval_Option_API.DB_NOT_APPLICABLE, attr_);
   Client_SYS.Add_To_Attr('DIR_DEL_APPROVAL', Approval_Option_API.Decode(Approval_Option_API.DB_NOT_APPLICABLE), attr_);
   Client_SYS.Add_To_Attr('ORDER_CONF_APPROVAL_DB', Approval_Option_API.DB_NOT_APPLICABLE, attr_);
   Client_SYS.Add_To_Attr('ORDER_CONF_APPROVAL', Approval_Option_API.Decode(Approval_Option_API.DB_NOT_APPLICABLE), attr_);
   Client_SYS.Add_To_Attr('ORDER_CONF_DIFF_APPROVAL_DB', Approval_Option_API.DB_NOT_APPLICABLE, attr_);
   Client_SYS.Add_To_Attr('ORDER_CONF_DIFF_APPROVAL', Approval_Option_API.Decode(Approval_Option_API.DB_NOT_APPLICABLE), attr_);
   Client_SYS.Add_To_Attr('ADHOC_PUR_RQST_APPROVAL_DB', Approval_Option_API.DB_NOT_APPLICABLE, attr_);
   Client_SYS.Add_To_Attr('ADHOC_PUR_RQST_APPROVAL', Approval_Option_API.Decode(Approval_Option_API.DB_NOT_APPLICABLE), attr_);
END Prepare_Insert___;   


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     message_defaults_per_supp_tab%ROWTYPE,
   newrec_ IN OUT message_defaults_per_supp_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.dir_del_approval = Approval_Option_API.DB_AUTOMATICALLY OR 
       newrec_.order_conf_approval = Approval_Option_API.DB_AUTOMATICALLY OR 
       newrec_.order_conf_diff_approval = Approval_Option_API.DB_AUTOMATICALLY OR
       newrec_.adhoc_pur_rqst_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
      IF (newrec_.supp_auto_approval_user IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NO_APPROVAL_USER: Approval user must be entered if automatic approval is used for incoming delivery notification or incoming order confirmation with/without differences or incoming ad-hoc purchase request.');
      END IF;
   END IF;
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Common___;
   
   
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

