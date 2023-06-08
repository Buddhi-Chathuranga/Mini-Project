-----------------------------------------------------------------------------
--
--  Logical unit: MessageDefaultsPerCust
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140702  HimRlk  Added new column release_internal_order.
--  130624  ShKolk  Created
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
   Client_SYS.Add_To_Attr('EDI_AUTO_ORDER_APPROVAL_DB', Approval_Option_API.DB_NOT_APPLICABLE, attr_);
   Client_SYS.Add_To_Attr('EDI_AUTO_ORDER_APPROVAL', Approval_Option_API.Decode(Approval_Option_API.DB_NOT_APPLICABLE), attr_);
   Client_SYS.Add_To_Attr('EDI_AUTO_CHANGE_APPROVAL_DB', Approval_Option_API.DB_NOT_APPLICABLE, attr_);
   Client_SYS.Add_To_Attr('EDI_AUTO_CHANGE_APPROVAL', Approval_Option_API.Decode(Approval_Option_API.DB_NOT_APPLICABLE), attr_);
   Client_SYS.Add_To_Attr('RELEASE_INTERNAL_ORDER_DB', Approval_Option_API.DB_NOT_APPLICABLE, attr_);
   Client_SYS.Add_To_Attr('RELEASE_INTERNAL_ORDER', Approval_Option_API.Decode(Approval_Option_API.DB_NOT_APPLICABLE), attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT message_defaults_per_cust_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   IF (newrec_.edi_auto_order_approval = Approval_Option_API.DB_AUTOMATICALLY OR newrec_.edi_auto_change_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
      -- Automatic Order/Change Approval is ON.
      IF (newrec_.edi_auto_approval_user IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NO_APPROVAL_USER: Approval user must be entered if automatic approval is used for incoming customer order or for incoming change requests.');
      END IF;
   END IF;

   IF (newrec_.edi_authorize_code IS NOT NULL) THEN
      IF (Order_Coordinator_API.Check_Exist(newrec_.edi_authorize_code) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'COORDNOTEXIS: Entered Coordinator does not exist. Use the list of values to find valid entries.');
      END IF;
   END IF;
   IF (newrec_.release_internal_order IS NULL) THEN
      newrec_.release_internal_order := Approval_Option_API.DB_NOT_APPLICABLE;
   END IF;
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     message_defaults_per_cust_tab%ROWTYPE,
   newrec_ IN OUT message_defaults_per_cust_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.edi_auto_order_approval = Approval_Option_API.DB_AUTOMATICALLY OR newrec_.edi_auto_change_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
      -- Automatic Order/Change Approval is ON.
      IF (newrec_.edi_auto_approval_user IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NO_APPROVAL_USER: Approval user must be entered if automatic approval is used for incoming customer order or for incoming change requests.');
      END IF;
   END IF;

   IF (newrec_.edi_authorize_code IS NOT NULL) THEN
      IF (Order_Coordinator_API.Check_Exist(newrec_.edi_authorize_code) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'COORDNOTEXIS: Entered Coordinator does not exist. Use the list of values to find valid entries.');
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


